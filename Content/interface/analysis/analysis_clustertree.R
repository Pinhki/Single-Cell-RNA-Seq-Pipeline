# interface/analysis_clustertree.R
# ClusterTree with Seurat/ggplot colors, parent-aware ordering,
# edge width ~ flow, dot size ~ cell count

# ============================================================
# AESTHETIC KNOBS (EDIT THESE)
# ============================================================

# Node (dot) size vs cell count
CT_NODE_SIZE_MIN     <- 6       # min point size
CT_NODE_SIZE_MAX     <- 20      # max point size

# Edge (flow) appearance
CT_EDGE_SCALE_MODE   <- "sqrt"  # "sqrt", "linear", or "log"
CT_EDGE_WIDTH_MIN    <- 0.3
CT_EDGE_WIDTH_MAX    <- 4.8
CT_EDGE_WIDTH_EXPONENT <- 1.75
CT_EDGE_ALPHA_MIN    <- 0.10
CT_EDGE_ALPHA_MAX    <- 0.62
CT_EDGE_ALPHA_EXPONENT <- 1.55
CT_EDGE_COLOUR       <- "grey55"
CT_EDGE_LINEEND      <- "round"
CT_EDGE_CURVATURE    <- 0.18
CT_EDGE_NCP          <- 5
CT_EDGE_S_POINTS     <- 40      # points sampled per edge for smooth S-curve

# Node stroke (outline)
CT_NODE_STROKE_COLOUR <- "black"
CT_NODE_STROKE_WIDTH  <- 0.35   # outline width
CT_NODE_STROKE_ALPHA  <- 1.0    # not in aes, but for future use if needed
CT_NODE_GAP_MIN       <- 1.15   # minimum vertical gap between neighboring dots
CT_NODE_GAP_PER_PT    <- 0.06   # extra gap scaled by neighboring dot sizes

# Cluster label text (inside node)
CT_CLUSTER_TEXT_SIZE_MIN <- 3.0
CT_CLUSTER_TEXT_SIZE_MAX <- 6.0
CT_CLUSTER_TEXT_VJUST  <- 0.45
CT_CLUSTER_TEXT_COLOUR <- "white"

# Cell-count label text (below node)
CT_COUNT_TEXT_SIZE     <- 2.5
CT_COUNT_TEXT_VJUST    <- 1.0
CT_COUNT_TEXT_COLOUR   <- "grey20"
CT_COUNT_MARGIN_TO_DOT  <- 0.05      # fixed margin from dot edge to text top
CT_NODE_RADIUS_Y_PER_PT <- 0.045     # convert point size -> y-radius estimate

# Layout / theme
CT_PLOT_TITLE          <- "ClusterTree across resolutions (Seurat colors)"
CT_BASE_FONT_SIZE      <- 12

# ============================================================
# LOGGING (optional, controlled by options(ct_debug = TRUE))
# ============================================================

.ct_logfile <- file.path(tempdir(), "ct_debug.txt")

.ct_log <- function(...) {
  if (!isTRUE(getOption("ct_debug", FALSE))) return(invisible())
  msg <- paste("[CT]", paste(..., collapse = " "))
  cat(msg, "\n", file = .ct_logfile, append = TRUE)
}

# helper: relevel factor so that purely numeric labels sort as numbers
.ct_relevel_numeric <- function(x) {
  if (is.null(x)) return(x)
  f <- if (is.factor(x)) x else factor(as.character(x))
  lv <- levels(f)
  if (length(lv) && all(grepl("^-?[0-9]+$", lv))) {
    lv_ord <- lv[order(as.numeric(lv))]
    f <- factor(f, levels = lv_ord)
  }
  f
}

.ct_log("--- NEW RUN --------------------------------------------------")

# ============================================================
# HELPERS
# ============================================================

# find clustering meta columns
# accept ANY column that looks like "*_res.<number>"
# e.g. integrated_nn_res.0.4, RNA_snn_res.0.4, seurat_clusters_res.0.4, ...
.find_res_cols <- function(sobj) {
  cn <- tryCatch(colnames(sobj@meta.data), error = function(e) character())
  if (!length(cn)) {
    .ct_log("COLNAMES meta.data: <none>")
    return(character())
  }
  low <- tolower(cn)
  
  # generic: anything ending in "_res.<number>"
  hits <- cn[
    grepl("_res\\.[0-9]", low, perl = TRUE) &
      !grepl("^seurat_", low)    # exclude synthetic columns
  ]
  
  # drop columns that are effectively “no clustering” (<=1 level)
  if (length(hits)) {
    k <- vapply(
      hits,
      function(cn1) {
        v <- tryCatch(sobj@meta.data[[cn1]], error = function(e) NULL)
        if (is.null(v)) return(0L)
        length(unique(na.omit(as.character(v))))
      },
      integer(1)
    )
    .ct_log("CANDIDATE RESOLUTION COLS (raw):", paste(hits, collapse = ", "))
    .ct_log("CANDIDATE RESOLUTION COLS n_levels:",
            paste(sprintf("%s=%d", hits, k), collapse = "; "))
    hits <- hits[k > 1L]
  }
  
  .ct_log("RESOLUTION COLS (final):",
          if (length(hits)) paste(hits, collapse = ", ") else "<none>")
  hits
}

# numeric resolution value from column name
# e.g. "integrated_nn_res.0.4" → 0.4
.res_val_from_name <- function(cn) {
  as.numeric(sub("^.*_res\\.([0-9]+(?:\\.[0-9]+)?)$", "\\1", tolower(cn)))
}

# nearest resolution column for requested value
# prefer the column with MORE clusters (levels) when there are ties
.match_res_col <- function(sobj, r) {
  cols <- .find_res_cols(sobj)
  if (!length(cols)) return(NULL)
  
  r_num <- as.numeric(r)
  vals  <- vapply(cols, .res_val_from_name, numeric(1))
  
  # all columns that numerically match this resolution
  idx_exact <- which(abs(vals - r_num) < 1e-8)
  
  pick_idx <- NA_integer_
  
  if (length(idx_exact)) {
    # among exact matches, choose the one with the MOST distinct levels
    nlev <- vapply(cols[idx_exact], function(cn) {
      v <- tryCatch(sobj@meta.data[[cn]], error = function(e) NULL)
      if (is.null(v)) return(0L)
      length(unique(na.omit(as.character(v))))
    }, integer(1))
    
    pick_idx <- idx_exact[which.max(nlev)]
    .ct_log(
      sprintf("MATCH_RES_COL r=%.2f exact matches: %s → picked %s (nlev=%d)",
              r_num,
              paste(sprintf("%s(%d)", cols[idx_exact], nlev), collapse = ", "),
              cols[pick_idx], nlev[which.max(nlev)])
    )
  } else {
    # no exact match: fall back to nearest by numeric distance
    pick_idx <- which.min(abs(vals - r_num))
    .ct_log(
      sprintf("MATCH_RES_COL r=%.2f no exact match, using nearest %s (val=%.2f)",
              r_num, cols[pick_idx], vals[pick_idx])
    )
  }
  
  cols[pick_idx]
}

# Seurat / ggplot-style palette matching DimPlot cluster colors
.seurat_palette_from_levels <- function(levels_vec) {
  # Prefer ggplot2 default palette (matches most DimPlot setups)
  if (requireNamespace("scales", quietly = TRUE)) {
    pal_fun <- scales::hue_pal()
    pal <- pal_fun(length(levels_vec))
    names(pal) <- levels_vec
    return(pal)
  }
  # Fallback: Seurat's DiscretePalette
  if (!requireNamespace("Seurat", quietly = TRUE)) {
    stop("Seurat not available.")
  }
  dp <- tryCatch(
    get("DiscretePalette", envir = asNamespace("Seurat")),
    error = function(...) NULL
  )
  if (!is.function(dp)) stop("Cannot access Seurat::DiscretePalette.")
  pal <- dp(length(levels_vec))
  names(pal) <- levels_vec
  pal
}

# contingency + parent helper (for parent-aware ordering)
.contingency_pair <- function(f1, f2) {
  tab <- table(f1, f2)
  list(
    tab = tab,
    parent_counts = rowSums(tab),
    child_counts  = colSums(tab)
  )
}

.assign_parents <- function(tab) {
  if (!nrow(tab) || !ncol(tab)) return(setNames(character(0), character(0)))
  m <- apply(tab, 2, function(col) {
    if (all(col == 0)) return(NA_character_)
    rownames(tab)[which.max(col)]
  })
  m
}

# parent-aware ordering of cluster labels per resolution
.parent_aware_order <- function(meta, cols) {
  stopifnot(length(cols) >= 2)
  orders <- vector("list", length(cols))
  
  # first slice: by size (largest on top)
  first_counts <- table(meta[[cols[1]]])
  orders[[1]] <- names(sort(first_counts, decreasing = TRUE))
  
  for (i in seq_len(length(cols) - 1)) {
    f1 <- meta[[cols[i]]]
    f2 <- meta[[cols[i + 1]]]
    cc <- .contingency_pair(f1, f2)
    parent_of_child <- .assign_parents(cc$tab)
    child_levels <- levels(f2)
    
    flow_from <- function(p, c) {
      if (p %in% rownames(cc$tab) && c %in% colnames(cc$tab)) {
        cc$tab[p, c]
      } else 0L
    }
    
    out <- character(0)
    # for each parent (in previous slice order), group its children
    for (p in orders[[i]]) {
      kids <- child_levels[parent_of_child[child_levels] == p]
      if (length(kids)) {
        kid_sizes <- cc$child_counts[kids]; kid_sizes[is.na(kid_sizes)] <- 0
        kid_flow  <- vapply(kids, function(k) flow_from(p, k), numeric(1))
        ord <- order(-kid_flow, -kid_sizes,
                     suppressWarnings(as.numeric(kids)), kids)
        out <- c(out, kids[ord])
      }
    }
    
    # any clusters with no strong parent -> append by size
    rest <- setdiff(child_levels, out)
    if (length(rest)) {
      rest_sizes <- cc$child_counts[rest]; rest_sizes[is.na(rest_sizes)] <- 0
      ord <- order(-rest_sizes,
                   suppressWarnings(as.numeric(rest)), rest)
      out <- c(out, rest[ord])
    }
    
    orders[[i + 1]] <- out
  }
  names(orders) <- cols
  orders
}

# edge width transform
.edge_size_fn <- function(x, mode = c("sqrt","linear","log")) {
  mode <- match.arg(mode)
  x <- as.numeric(x)
  if (mode == "sqrt") sqrt(x) else if (mode == "log") log1p(x) else x
}

.rescale01 <- function(x) {
  x <- as.numeric(x)
  if (!length(x) || all(!is.finite(x))) return(rep(0.5, length(x)))
  rng <- range(x, na.rm = TRUE)
  if (!is.finite(rng[1]) || !is.finite(rng[2]) || diff(rng) <= 0) return(rep(0.5, length(x)))
  (x - rng[1]) / diff(rng)
}

# Build edge width + alpha from flow with stronger visual separation.
.edge_visual_map <- function(weight) {
  base_w <- .edge_size_fn(weight, mode = CT_EDGE_SCALE_MODE)
  s_w <- .rescale01(base_w) ^ CT_EDGE_WIDTH_EXPONENT
  w <- CT_EDGE_WIDTH_MIN + s_w * (CT_EDGE_WIDTH_MAX - CT_EDGE_WIDTH_MIN)

  s_a <- .rescale01(weight) ^ CT_EDGE_ALPHA_EXPONENT
  a <- CT_EDGE_ALPHA_MIN + s_a * (CT_EDGE_ALPHA_MAX - CT_EDGE_ALPHA_MIN)

  list(w = w, a = a)
}

# Generate an ease-in/ease-out S-curve between two points.
# x is linear in t, y uses smoothstep(t) = 3t^2 - 2t^3 to avoid sharp turns.
.edge_s_curve_df <- function(e_df, n = CT_EDGE_S_POINTS) {
  if (is.null(e_df) || !nrow(e_df)) return(data.frame())
  n <- max(8L, as.integer(n))
  t <- seq(0, 1, length.out = n)
  s <- (3 * t^2) - (2 * t^3)
  out <- lapply(seq_len(nrow(e_df)), function(i) {
    row <- e_df[i, , drop = FALSE]
    data.frame(
      edge_id = i,
      x = row$x0 + (row$x1 - row$x0) * t,
      y = row$y0 + (row$y1 - row$y0) * s,
      w = row$w,
      a = row$a
    )
  })
  do.call(rbind, out)
}

# node size vs cell count: linear scaling into [CT_NODE_SIZE_MIN, CT_NODE_SIZE_MAX]
.node_size_fn <- function(n,
                          min_pt = CT_NODE_SIZE_MIN,
                          max_pt = CT_NODE_SIZE_MAX) {
  n <- as.numeric(n)
  if (all(!is.finite(n))) return(rep((min_pt + max_pt) / 2, length(n)))
  rng <- range(n, na.rm = TRUE)
  if (diff(rng) == 0) return(rep((min_pt + max_pt) / 2, length(n)))
  scaled <- (n - rng[1]) / diff(rng)
  min_pt + scaled * (max_pt - min_pt)
}

# Cluster label size vs dot size: linear scaling into [CT_CLUSTER_TEXT_SIZE_MIN, CT_CLUSTER_TEXT_SIZE_MAX]
.cluster_text_size_fn <- function(pt,
                                  min_txt = CT_CLUSTER_TEXT_SIZE_MIN,
                                  max_txt = CT_CLUSTER_TEXT_SIZE_MAX) {
  pt <- as.numeric(pt)
  if (all(!is.finite(pt))) return(rep((min_txt + max_txt) / 2, length(pt)))
  rng <- range(pt, na.rm = TRUE)
  if (diff(rng) == 0) return(rep((min_txt + max_txt) / 2, length(pt)))
  scaled <- (pt - rng[1]) / diff(rng)
  min_txt + scaled * (max_txt - min_txt)
}

# ============================================================
# CORE BUILDER
# ============================================================

.ct_build <- function(sobj, res_vec) {
  tryCatch({
    
    if (is.null(sobj) || is.null(sobj@meta.data)) {
      .ct_log("ERROR: sobj or meta.data is NULL")
      return(
        ggplot() +
          ggtitle("ClusterTree: no object/meta.data") +
          theme_void() +
          theme(plot.title = element_text(hjust = 0.5))
      )
    }
    
    # ---------------- 1) choose resolution columns ----------------
    present <- .find_res_cols(sobj)
    .ct_log("CANDIDATE RESOLUTION COLS (present):", paste(present, collapse = ", "))
    
    if (!length(present)) {
      .ct_log("ERROR: no resolution columns found in meta.data AFTER PATTERN MATCH")
      return(
        ggplot() +
          ggtitle("ClusterTree: no resolution columns found") +
          theme_void() +
          theme(plot.title = element_text(hjust = 0.5))
      )
    }
    
    if (is.null(res_vec) || !length(res_vec)) {
      res_vals <- sort(unique(vapply(present, .res_val_from_name, numeric(1))))
      ord <- order(vapply(present, .res_val_from_name, numeric(1)))
      cols <- present[ord]
    } else {
      cols <- unique(stats::na.omit(unlist(
        lapply(res_vec, function(r) .match_res_col(sobj, r))
      )))
      if (length(cols) < 2) {
        .ct_log("ERROR: <2 resolution columns mapped from requested res_vec")
        return(
          ggplot() +
            ggtitle("ClusterTree: need ≥ 2 resolutions") +
            theme_void() +
            theme(plot.title = element_text(hjust = 0.5))
        )
      }
      ord <- order(vapply(cols, .res_val_from_name, numeric(1)))
      cols <- cols[ord]
      res_vals <- vapply(cols, .res_val_from_name, numeric(1))
    }
    
    .ct_log("Using resolutions:", paste(cols, collapse = ", "))
    .ct_log("Res_vals:", paste(res_vals, collapse = ", "))
    
    .safe_select_cols <- function(df, cols, default = NA) {
      if (is.null(df) || !is.data.frame(df)) return(data.frame(stringsAsFactors = FALSE))
      cols <- as.character(cols)
      cols <- cols[!is.na(cols) & nzchar(cols)]
      cols <- unique(cols)
      if (!length(cols)) return(data.frame(row.names = seq_len(nrow(df))))
      out <- df
      n <- nrow(out)
      for (cc in cols) {
        if (!(cc %in% colnames(out))) out[[cc]] <- rep(default, n)
      }
      out[, cols, drop = FALSE]
    }

    # ---------------- 2) meta as factors ----------------
    raw <- .safe_select_cols(sobj@meta.data, cols, default = NA_character_)
    
    meta <- data.frame(
      lapply(raw, function(x) .ct_relevel_numeric(x)),
      check.names = FALSE,
      stringsAsFactors = TRUE,
      row.names = rownames(sobj@meta.data)
    )
    
    .ct_log("Meta created. Example levels:",
            paste(head(levels(meta[[1]]), 5), collapse = ", "))
    
    if (!exists("res_vals", inherits = FALSE)) {
      res_vals <- vapply(cols, .res_val_from_name, numeric(1))
    }
    
    # ---------------- 3) parent-aware level orders ----------------
    lev_orders <- .parent_aware_order(meta, cols)
    # harden: ensure every slice has some order; fall back to factor levels
    lev_orders <- lapply(seq_along(cols), function(i) {
      lo <- lev_orders[[i]]
      fallback <- levels(meta[[cols[i]]])
      lo <- intersect(fallback, lo)
      if (!length(lo)) fallback else lo
    })
    names(lev_orders) <- cols
    
    # ---------------- 4) nodes per resolution ----------------
    node_list <- lapply(seq_along(cols), function(i) {
      f  <- meta[[cols[i]]]
      lv <- levels(f)               # levels for palette (DimPlot-compatible)
      if (!length(lv)) return(NULL)
      
      pal <- .seurat_palette_from_levels(lv)
      
      tab <- table(f)
      cnt <- as.numeric(tab[lv])
      cnt[is.na(cnt)] <- 0
      
      data.frame(
        res_idx = i,
        res_lab = sprintf("res.%s", format(res_vals[i], nsmall = 2, trim = TRUE)),
        cluster = lv,
        n_cells = cnt,
        fill    = unname(as.character(pal[lv])),
        stringsAsFactors = FALSE
      )
    })
    
    nodes <- do.call(rbind, node_list)
    
    if (is.null(nodes) || !nrow(nodes)) {
      .ct_log("ERROR: node table is empty after construction")
      return(
        ggplot() +
          ggtitle("ClusterTree: no clusters to show") +
          theme_void() +
          theme(plot.title = element_text(hjust = 0.5))
      )
    }
    
    .ct_log("NODES nrow =", nrow(nodes))
    .ct_log("NODES head:",
            paste(capture.output(head(nodes)), collapse = " | "))
    
    # dot size first (used by layout spacing and count label offsets)
    nodes$pt_size <- .node_size_fn(nodes$n_cells)
    nodes$cluster_text_size <- .cluster_text_size_fn(nodes$pt_size)

    # ---------------- 5) layout in full height, parent-aware ----------------
    nodes$x <- nodes$res_idx

    nodes$y <- NA_real_
    for (i in seq_along(cols)) {
      idx <- which(nodes$res_idx == i)
      if (!length(idx)) next
      
      ord_vec <- lev_orders[[i]]  # parent-aware order of labels
      rank_i <- match(nodes$cluster[idx], ord_vec)
      # clusters not found in ord_vec -> push to bottom
      na_idx <- which(is.na(rank_i))
      if (length(na_idx)) {
        rank_i[na_idx] <- max(rank_i, na.rm = TRUE) + seq_along(na_idx)
      }
      order_by_parent <- order(rank_i)  # small rank -> top

      ord_idx <- idx[order_by_parent]
      y_vals <- numeric(length(ord_idx))
      y_vals[1] <- 0
      if (length(ord_idx) > 1) {
        for (j in 2:length(ord_idx)) {
          prev_pt <- nodes$pt_size[ord_idx[j - 1]]
          cur_pt  <- nodes$pt_size[ord_idx[j]]
          gap_j <- max(CT_NODE_GAP_MIN, CT_NODE_GAP_PER_PT * (prev_pt + cur_pt))
          y_vals[j] <- y_vals[j - 1] - gap_j
        }
      }
      nodes$y[ord_idx] <- y_vals
    }

    # Keep a fixed margin from each dot edge:
    # y_count = center_y - estimated_dot_radius_y - fixed_margin
    node_radius_y <- CT_NODE_RADIUS_Y_PER_PT * nodes$pt_size
    nodes$y_count <- nodes$y - node_radius_y - CT_COUNT_MARGIN_TO_DOT
    
    # ---------------- 6) edges between consecutive resolutions ----------------
    edge_list <- lapply(seq_len(length(cols) - 1), function(i) {
      f1 <- meta[[cols[i]]]
      f2 <- meta[[cols[i + 1]]]
      tab <- table(f1, f2)
      
      df <- as.data.frame(tab, stringsAsFactors = FALSE)
      df <- df[df$Freq > 0, , drop = FALSE]
      if (!nrow(df)) return(NULL)
      
      req_cols <- c("f1", "f2", "Freq")
      if (!all(req_cols %in% colnames(df))) return(NULL)
      df <- .safe_select_cols(df, req_cols, default = NA)
      names(df) <- c("cluster_from", "cluster_to", "weight")
      df$res_from <- i
      df$res_to   <- i + 1
      
      .safe_select_cols(
        df,
        c("res_from", "res_to", "cluster_from", "cluster_to", "weight"),
        default = NA
      )
    })
    
    edges <- if (length(edge_list)) do.call(rbind, edge_list) else NULL
    
    if (is.null(edges) || !nrow(edges)) {
      .ct_log("ERROR: edge table is empty")
      return(
        ggplot() +
          ggtitle("ClusterTree: no edges to draw") +
          theme_void() +
          theme(plot.title = element_text(hjust = 0.5))
      )
    }
    
    .ct_log("EDGES nrow =", nrow(edges))
    .ct_log("EDGES head:",
            paste(capture.output(head(edges)), collapse = " | "))
    
    # ---------------- 7) join edges to node coordinates ----------------
    e <- merge(
      edges,
      .safe_select_cols(nodes, c("res_idx","cluster","x","y"), default = NA),
      by.x = c("res_from","cluster_from"),
      by.y = c("res_idx","cluster"),
      all.x = TRUE,
      sort = FALSE
    )
    names(e)[names(e) %in% c("x","y")] <- c("x0","y0")
    
    e <- merge(
      e,
      .safe_select_cols(nodes, c("res_idx","cluster","x","y"), default = NA),
      by.x = c("res_to","cluster_to"),
      by.y = c("res_idx","cluster"),
      all.x = TRUE,
      sort = FALSE
    )
    names(e)[names(e) %in% c("x","y")] <- c("x1","y1")
    
    incomplete <- sum(!stats::complete.cases(.safe_select_cols(e, c("x0","y0","x1","y1"), default = NA)))
    .ct_log("JOINED edges rows =", nrow(e), " incomplete =", incomplete)
    
    cc <- .safe_select_cols(e, c("x0","y0","x1","y1"), default = NA)
    e <- e[stats::complete.cases(cc), , drop = FALSE]
    
    if (!nrow(e)) {
      .ct_log("ERROR: after join, no complete edge rows")
      return(
        ggplot() +
          ggtitle("ClusterTree: nodes only (no edges matched)") +
          theme_void() +
          theme(plot.title = element_text(hjust = 0.5))
      )
    }
    
    # edge width + alpha from flow (cell count)
    edge_vis <- .edge_visual_map(e$weight)
    e$w <- edge_vis$w
    e$a <- edge_vis$a
    
    # ---------------- 8) draw ----------------
    y_low  <- suppressWarnings(min(nodes$y_count, na.rm = TRUE) - 0.45)
    y_high <- suppressWarnings(max(nodes$y, na.rm = TRUE) + 0.55)
    if (!is.finite(y_low)) y_low <- -1
    if (!is.finite(y_high)) y_high <- 1

    e_plot <- .edge_s_curve_df(e, n = CT_EDGE_S_POINTS)

    ggplot() +
      # S-curve edges (ease-in/ease-out) for smoother-looking transitions
      geom_path(
        data = e_plot,
        aes(x = x, y = y, group = edge_id, size = w, alpha = a),
        colour = CT_EDGE_COLOUR,
        lineend = CT_EDGE_LINEEND
      ) +
      scale_size_identity(guide = "none") +
      scale_alpha_identity(guide = "none") +
      
      # nodes (size outside aes -> independent of edge scale)
      geom_point(
        data   = nodes,
        aes(x = x, y = y),
        size   = nodes$pt_size,
        shape  = 21,
        fill   = nodes$fill,
        colour = CT_NODE_STROKE_COLOUR,
        stroke = CT_NODE_STROKE_WIDTH
      ) +
      
      # cluster labels
      geom_text(
        data = nodes,
        aes(x = x, y = y, label = cluster),
        size     = nodes$cluster_text_size,
        fontface = "bold",
        vjust    = CT_CLUSTER_TEXT_VJUST,
        colour   = CT_CLUSTER_TEXT_COLOUR
      ) +
      
      # cell-count labels
      geom_text(
        data = nodes,
        aes(x = x, y = y_count, label = n_cells),
        size   = CT_COUNT_TEXT_SIZE,
        vjust  = CT_COUNT_TEXT_VJUST,
        colour = CT_COUNT_TEXT_COLOUR
      ) +
      
      scale_x_continuous(
        breaks = sort(unique(nodes$x)),
        labels = nodes$res_lab[match(sort(unique(nodes$x)), nodes$x)]
      ) +
      scale_y_continuous(
        limits = c(y_low, y_high),
        expand = expansion(mult = c(0, 0.01))
      ) +
      coord_cartesian(clip = "on") +
      theme_minimal(base_size = CT_BASE_FONT_SIZE) +
      labs(
        title = CT_PLOT_TITLE,
        x = NULL,
        y = NULL
      ) +
      theme(
        panel.grid  = element_blank(),
        axis.title  = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(
          face = "bold",
          angle = 60,
          hjust = 1,
          vjust = 1
        ),
        plot.title  = element_text(face = "bold", hjust = 0.5)
      )
    
  }, error = function(e) {
    .ct_log("FATAL ERROR:", conditionMessage(e))
    ggplot() +
      annotate("text", x = 0.5, y = 0.5,
               label = paste("ClusterTree error:", conditionMessage(e))) +
      theme_void()
  })
}

# ============================================================
# PUBLIC ENTRYPOINTS
# ============================================================

ClusterTreeCloseToParents <- function(sobj, res_vec, graph = NULL, dims = 30) {
  .ct_build(sobj, res_vec)
}
cluster_tree_close_to_parents <- function(sobj, res_vec, graph = NULL, dims = 30) {
  .ct_build(sobj, res_vec)
}
manual_cluster_tree <- function(sobj, res_vec, graph = NULL, dims = 30) {
  .ct_build(sobj, res_vec)
}
