# DEPRECATED FILE
# This file is no longer used by app routing.
# Use versioned core modules instead:
# - core/seurat_v4/*
# - core/seurat_v5/*
# Kept only for historical reference.

# flowgate_core.R
# Standalone + Shiny-shared core for flow-like stepwise gating.

# ------------------------------
# Standalone knobs (RStudio)
# ------------------------------
FLOWGATE_CORE_AUTORUN <- FALSE
FLOWGATE_CORE_INPUT_OBJECT_NAME <- "seurat_obj"
FLOWGATE_CORE_INPUT_OBJECT <- NULL
FLOWGATE_CORE_OUTPUT_OBJECT_NAME <- "flowgate_core_result"
FLOWGATE_CORE_ENSURE_UMAP <- TRUE
# Seurat backend hint for standalone runs: "auto", "4", or "5"
FLOWGATE_CORE_SEURAT_VERSION <- "auto"

`%||%` <- function(a, b) if (is.null(a)) b else a

core_flowgate_default_gates <- function() {
  data.frame(
    gate_id = seq_len(6),
    gate_name = c("MYELOID", "B", "GDT", "MAIT", "INKT", "NK"),
    genes_csv = c(
      "Lyz2,Lyz1,Ms4a7,Csf1r,Lst1",
      "Ms4a1,Cd79a,Cd79b,Cd74,Cd19,Ighm,Igkc,Mzb1,Jchain",
      "Trdc,Trgc1,Trgc2,Sox13",
      "Slc4a10,Klrb1",
      "Zbtb16",
      "Klrf1,Ncr1"
    ),
    direction = rep("low", 6),
    threshold_value = c(0.01, 0.01, 0.01, 0.10, 0.10, 0.10),
    active = rep(TRUE, 6),
    stringsAsFactors = FALSE
  )
}

.core_fg_sanitize <- function(x) {
  x <- gsub("[^A-Za-z0-9_]+", "_", as.character(x))
  gsub("_+", "_", x)
}

core_flowgate_normalize_gate_df <- function(gates) {
  if (is.null(gates) || !is.data.frame(gates) || !nrow(gates)) return(core_flowgate_default_gates())
  if ("threshold_q" %in% names(gates) && !"threshold_value" %in% names(gates)) {
    gates$threshold_value <- suppressWarnings(as.numeric(gates$threshold_q))
  }
  req_cols <- c("gate_id", "gate_name", "genes_csv", "direction", "threshold_value", "active")
  for (cc in setdiff(req_cols, names(gates))) {
    gates[[cc]] <- NA
  }
  gates <- gates[, req_cols, drop = FALSE]
  gates$gate_id <- seq_len(nrow(gates))
  gates$gate_name <- as.character(gates$gate_name)
  gates$gate_name[!nzchar(gates$gate_name)] <- paste0("Gate", which(!nzchar(gates$gate_name)))
  gates$genes_csv <- as.character(gates$genes_csv %||% "")
  gates$direction <- ifelse(tolower(as.character(gates$direction)) %in% c("low", "high"), tolower(as.character(gates$direction)), "low")
  gates$threshold_value <- suppressWarnings(as.numeric(gates$threshold_value))
  gates$threshold_value[!is.finite(gates$threshold_value)] <- 0.10
  gates$threshold_value <- pmax(0, pmin(1, gates$threshold_value))
  gates$active <- as.logical(gates$active)
  gates$active[is.na(gates$active)] <- TRUE
  gates
}

.core_fg_require_pkgs <- function() {
  req <- c("Seurat", "UCell")
  miss <- req[!vapply(req, requireNamespace, logical(1), quietly = TRUE)]
  if (length(miss)) stop("Missing required package(s): ", paste(miss, collapse = ", "))
}

.core_fg_is_seurat <- function(x) inherits(x, "Seurat")

.core_fg_detect_seurat_major <- function() {
  v <- tryCatch(as.character(utils::packageVersion("Seurat")), error = function(e) NA_character_)
  if (is.na(v)) return(NA_integer_)
  parts <- strsplit(v, "\\.", fixed = FALSE)[[1]]
  suppressWarnings(as.integer(parts[1]))
}

.core_fg_resolve_seurat_major <- function(seurat_version = "auto") {
  sv <- tolower(as.character(seurat_version %||% "auto"))
  if (!sv %in% c("auto", "4", "5")) {
    stop("seurat_version must be one of: 'auto', '4', '5'.")
  }
  if (sv == "auto") {
    major <- .core_fg_detect_seurat_major()
    if (!is.finite(major)) return(4L)
    return(as.integer(major))
  }
  as.integer(sv)
}

.core_fg_get_assay_data <- function(so, assay, slot = "data", seurat_major = 4L) {
  if (isTRUE(seurat_major >= 5L)) {
    dat <- tryCatch(
      suppressWarnings(Seurat::GetAssayData(so, assay = assay, layer = slot)),
      error = function(e) NULL
    )
    if (!is.null(dat)) return(dat)
  }
  suppressWarnings(Seurat::GetAssayData(so, assay = assay, slot = slot))
}

core_flowgate_list_registry_objects <- function(registry) {
  if (is.null(registry) || !length(registry)) return(character(0))
  nms <- names(registry)
  if (is.null(nms)) return(character(0))
  is_seu <- vapply(nms, function(nm) {
    e <- registry[[nm]]
    obj <- if (is.list(e) && !is.null(e$obj)) e$obj else e
    .core_fg_is_seurat(obj)
  }, logical(1))
  nms <- nms[is_seu]
  if (!length(nms)) return(character(0))
  pref <- grepl("_filtered$", nms, ignore.case = TRUE) | grepl("_dbl_", nms, ignore.case = TRUE)
  c(nms[pref], nms[!pref])
}

core_flowgate_get_registry_object <- function(registry, name) {
  if (is.null(name) || !nzchar(name)) return(NULL)
  e <- registry[[name]]
  if (is.list(e) && !is.null(e$obj)) e$obj else e
}

.core_fg_ensure_rna_data <- function(so, seurat_major = 4L) {
  assay_use <- if ("RNA" %in% names(so@assays)) "RNA" else Seurat::DefaultAssay(so)
  Seurat::DefaultAssay(so) <- assay_use
  dat <- tryCatch(.core_fg_get_assay_data(so, assay = assay_use, slot = "data", seurat_major = seurat_major), error = function(e) NULL)
  ok <- !is.null(dat) && nrow(dat) > 0 && ncol(dat) > 0
  if (ok) return(so)
  so <- Seurat::NormalizeData(so, assay = assay_use, normalization.method = "LogNormalize", scale.factor = 1e4, verbose = FALSE)
  dat <- tryCatch(.core_fg_get_assay_data(so, assay = assay_use, slot = "data", seurat_major = seurat_major), error = function(e) NULL)
  ok2 <- !is.null(dat) && nrow(dat) > 0 && ncol(dat) > 0
  if (!ok2) stop("Unable to create normalized `data` layer.")
  so
}

.core_fg_ensure_umap <- function(so, seurat_major = 4L) {
  reds <- tryCatch(Seurat::Reductions(so), error = function(e) character(0))
  if ("umap" %in% reds) return(so)
  so <- .core_fg_ensure_rna_data(so, seurat_major = seurat_major)
  vf <- tryCatch(Seurat::VariableFeatures(so), error = function(e) character(0))
  if (!length(vf)) so <- Seurat::FindVariableFeatures(so, nfeatures = 2000, verbose = FALSE)
  vf <- Seurat::VariableFeatures(so)
  so <- Seurat::ScaleData(so, features = vf, verbose = FALSE)
  so <- Seurat::RunPCA(so, features = vf, npcs = 30, verbose = FALSE)
  so <- Seurat::RunUMAP(
    so,
    dims = 1:30,
    reduction.name = "umap",
    umap.method = "uwot",
    metric = "cosine",
    verbose = FALSE
  )
  so
}

.core_fg_split_genes <- function(x) {
  vv <- trimws(unlist(strsplit(as.character(x %||% ""), ",", fixed = TRUE)))
  vv[nzchar(vv)]
}

.core_fg_match_genes <- function(genes, all_genes) {
  if (!length(genes)) return(character(0))
  m <- match(tolower(genes), tolower(all_genes))
  unique(all_genes[na.omit(m)])
}

core_flowgate_score_gates <- function(seurat_object, gates, seurat_version = "auto") {
  .core_fg_require_pkgs()
  if (!.core_fg_is_seurat(seurat_object)) stop("seurat_object must be a Seurat object.")
  seurat_major <- .core_fg_resolve_seurat_major(seurat_version = seurat_version)
  gates <- core_flowgate_normalize_gate_df(gates)
  so <- .core_fg_ensure_rna_data(seurat_object, seurat_major = seurat_major)
  assay_use <- if ("RNA" %in% names(so@assays)) "RNA" else Seurat::DefaultAssay(so)
  Seurat::DefaultAssay(so) <- assay_use
  mat <- .core_fg_get_assay_data(so, assay = assay_use, slot = "data", seurat_major = seurat_major)
  all_genes <- rownames(mat)

  feat_list <- list()
  gate_score_col <- character(nrow(gates))
  gate_genes_map <- list()
  for (i in seq_len(nrow(gates))) {
    gn <- .core_fg_sanitize(gates$gate_name[[i]])
    genes <- .core_fg_split_genes(gates$genes_csv[[i]])
    genes <- .core_fg_match_genes(genes, all_genes)
    gate_genes_map[[gn]] <- genes
    if (!length(genes)) {
      gate_score_col[[i]] <- paste0("FG_score_", gn)
      so[[gate_score_col[[i]]]] <- NA_real_
    } else {
      feat_list[[gn]] <- genes
      gate_score_col[[i]] <- paste0(gn, "_UCell")
    }
  }

  gate_keys <- names(gate_genes_map)
  gate_sig <- vapply(gate_keys, function(k) paste0(gate_genes_map[[k]], collapse = "|"), character(1))
  names(gate_sig) <- gate_keys
  sig_hash <- paste0(names(gate_sig), ":", gate_sig, collapse = ";")
  cached_hash <- tryCatch(as.character(so@misc$flowgate$score_spec_hash), error = function(e) "")
  score_cols <- paste0("FG_score_", gate_keys)
  cache_ok <- nzchar(cached_hash) && identical(cached_hash, sig_hash) && all(score_cols %in% colnames(so@meta.data))

  if (length(feat_list) && !cache_ok) {
    bp <- NULL
    if (requireNamespace("BiocParallel", quietly = TRUE) && .Platform$OS.type == "windows") {
      bp <- BiocParallel::SnowParam(workers = 1, progressbar = FALSE)
    }
    sc <- UCell::ScoreSignatures_UCell(
      matrix = mat,
      features = feat_list,
      ncores = 1,
      BPPARAM = bp
    )
    for (cn in colnames(sc)) {
      so[[cn]] <- sc[colnames(so), cn]
    }
  }

  for (i in seq_len(nrow(gates))) {
    gn <- .core_fg_sanitize(gates$gate_name[[i]])
    uc <- paste0(gn, "_UCell")
    fg <- paste0("FG_score_", gn)
    if (uc %in% colnames(so@meta.data)) {
      so[[fg]] <- as.numeric(so[[uc]][, 1])
    } else if (!fg %in% colnames(so@meta.data)) {
      so[[fg]] <- NA_real_
    }
  }
  so@misc$flowgate$score_spec_hash <- sig_hash

  list(seurat_object = so, gates = gates)
}

core_run_flowgate_step <- function(seurat_object, gates, ensure_umap = TRUE, progress = NULL, seurat_version = "auto") {
  .progress <- function(pct = NULL, msg = NULL) {
    if (is.function(progress)) {
      try(progress(pct = pct, msg = msg), silent = TRUE)
    }
  }
  .progress(5, "Preparing object…")
  seurat_major <- .core_fg_resolve_seurat_major(seurat_version = seurat_version)
  scored <- core_flowgate_score_gates(seurat_object, gates, seurat_version = seurat_version)
  so <- scored$seurat_object
  gates <- scored$gates
  .progress(55, "Scoring gate signatures…")
  if (isTRUE(ensure_umap)) {
    .progress(72, "Ensuring UMAP…")
    so <- .core_fg_ensure_umap(so, seurat_major = seurat_major)
  }

  keep_curr <- rep(TRUE, ncol(so))
  names(keep_curr) <- colnames(so)
  stats <- data.frame(
    gate = character(0), direction = character(0), threshold_value = numeric(0),
    cutoff = numeric(0), n_in = integer(0), n_keep = integer(0),
    stringsAsFactors = FALSE
  )
  hist_payload <- list()

  n_gates <- max(1L, nrow(gates))
  for (i in seq_len(nrow(gates))) {
    .progress(75 + (i - 1) * (20 / n_gates), paste0("Applying gate ", i, " of ", n_gates, "…"))
    g <- gates[i, , drop = FALSE]
    gname <- as.character(g$gate_name[[1]])
    gsafe <- .core_fg_sanitize(gname)
    score_col <- paste0("FG_score_", gsafe)
    scores <- as.numeric(so[[score_col]][, 1])
    active <- isTRUE(g$active[[1]])
    direction <- as.character(g$direction[[1]])
    threshold_value <- max(0, min(1, as.numeric(g$threshold_value[[1]])))

    in_mask <- keep_curr
    cutoff <- threshold_value
    pass <- rep(TRUE, length(scores))
    if (active && is.finite(cutoff)) {
      if (identical(direction, "high")) pass <- scores >= cutoff else pass <- scores <= cutoff
      pass[is.na(pass)] <- FALSE
      keep_curr <- keep_curr & pass
    }

    keep_col <- paste0("FG_keep_after_", gsafe)
    so[[keep_col]] <- keep_curr

    stats <- rbind(stats, data.frame(
      gate = gname,
      direction = direction,
      threshold_value = threshold_value,
      cutoff = cutoff,
      n_in = sum(in_mask, na.rm = TRUE),
      n_keep = sum(keep_curr, na.rm = TRUE),
      stringsAsFactors = FALSE
    ))

    hist_payload[[gname]] <- list(
      score = scores,
      in_mask = in_mask,
      cutoff = cutoff,
      direction = direction,
      active = active,
      score_col = score_col
    )
  }

  so$FG_keep_final <- keep_curr
  so@misc$flowgate <- list(
    gates = gates,
    stats = stats,
    hist_payload = hist_payload,
    updated = Sys.time()
  )

  list(
    seurat_object = so,
    gates = gates,
    stats = stats,
    keep_final = keep_curr
  )
}

core_flowgate_make_histogram_plot <- function(seurat_object, bins = 120) {
  if (!.core_fg_is_seurat(seurat_object)) stop("seurat_object must be a Seurat object.")
  mg <- seurat_object@misc$flowgate
  if (is.null(mg) || is.null(mg$hist_payload) || !length(mg$hist_payload)) return(NULL)

  plist <- list()
  i <- 1L
  for (nm in names(mg$hist_payload)) {
    h <- mg$hist_payload[[nm]]
    v <- as.numeric(h$score)
    in_mask <- as.logical(h$in_mask)
    vv <- v[in_mask & is.finite(v)]
    if (!length(vv)) next
    df <- data.frame(v = vv)
    y_breaks <- function(lims) {
      upper <- suppressWarnings(max(lims, na.rm = TRUE))
      if (!is.finite(upper) || upper <= 0) return(0)
      pmax_pow <- max(0, ceiling(log10(max(1, upper))))
      pows <- 10^(0:pmax_pow)
      unique(c(0, pows))
    }
    p <- ggplot2::ggplot(df, ggplot2::aes(v)) +
      ggplot2::geom_histogram(bins = bins, fill = "#5f6b7a", color = "white", linewidth = 0.1) +
      ggplot2::scale_y_continuous(
        trans = scales::pseudo_log_trans(base = 10, sigma = 1),
        breaks = y_breaks,
        labels = scales::label_number(big.mark = ","),
        minor_breaks = NULL
      ) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::labs(
        title = paste0(nm, if (isTRUE(h$active)) "" else " (inactive)"),
        x = h$score_col,
        y = "cells"
      )
    if (is.finite(h$cutoff)) {
      p <- p + ggplot2::geom_vline(xintercept = h$cutoff, linetype = "dashed", color = "#ef4444", linewidth = 0.6)
    }
    plist[[i]] <- p
    i <- i + 1L
  }
  if (!length(plist)) return(NULL)
  patchwork::wrap_plots(plist, ncol = 1)
}

core_flowgate_rgb_umap_plot <- function(seurat_object, genes = c("Cd3e", "Trac", "Tcrb"), seurat_version = "auto") {
  if (!.core_fg_is_seurat(seurat_object)) stop("seurat_object must be a Seurat object.")
  seurat_major <- .core_fg_resolve_seurat_major(seurat_version = seurat_version)
  so <- .core_fg_ensure_umap(.core_fg_ensure_rna_data(seurat_object, seurat_major = seurat_major), seurat_major = seurat_major)
  assay_use <- if ("RNA" %in% names(so@assays)) "RNA" else Seurat::DefaultAssay(so)
  mat <- .core_fg_get_assay_data(so, assay = assay_use, slot = "data", seurat_major = seurat_major)
  rn <- rownames(mat)
  gm <- sapply(genes, function(g) {
    idx <- match(tolower(g), tolower(rn))
    if (is.na(idx)) NA_character_ else rn[[idx]]
  })
  if (any(is.na(gm))) return(NULL)

  emb <- Seurat::Embeddings(so, "umap")
  emb <- emb[colnames(so), , drop = FALSE]
  x <- as.numeric(mat[gm[[1]], colnames(so), drop = TRUE])
  y <- as.numeric(mat[gm[[2]], colnames(so), drop = TRUE])
  z <- as.numeric(mat[gm[[3]], colnames(so), drop = TRUE])
  scale01 <- function(v) {
    v[!is.finite(v)] <- 0
    q <- stats::quantile(v, 0.99, na.rm = TRUE)
    v <- pmin(v, q)
    r <- range(v, na.rm = TRUE)
    if (diff(r) == 0) return(rep(0, length(v)))
    (v - r[1]) / diff(r)
  }
  cols <- grDevices::rgb(scale01(x), scale01(y), scale01(z), alpha = 0.9)
  df <- data.frame(UMAP_1 = emb[, 1], UMAP_2 = emb[, 2], col = cols)
  ggplot2::ggplot(df, ggplot2::aes(UMAP_1, UMAP_2)) +
    ggplot2::geom_point(color = df$col, size = 0.5, alpha = 0.95) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::coord_equal() +
    ggplot2::labs(title = sprintf("RGB UMAP (%s / %s / %s)", gm[[1]], gm[[2]], gm[[3]]))
}

core_flowgate_overlay_umap_plot <- function(seurat_object, seurat_version = "auto") {
  if (!.core_fg_is_seurat(seurat_object)) stop("seurat_object must be a Seurat object.")
  seurat_major <- .core_fg_resolve_seurat_major(seurat_version = seurat_version)
  so <- .core_fg_ensure_umap(seurat_object, seurat_major = seurat_major)
  emb <- Seurat::Embeddings(so, "umap")
  emb <- emb[colnames(so), , drop = FALSE]
  keep <- if ("FG_keep_final" %in% colnames(so@meta.data)) {
    as.logical(so[["FG_keep_final"]][, 1])
  } else {
    rep(FALSE, ncol(so))
  }
  keep[is.na(keep)] <- FALSE
  df <- data.frame(UMAP_1 = emb[, 1], UMAP_2 = emb[, 2], keep = keep)
  ggplot2::ggplot(df, ggplot2::aes(UMAP_1, UMAP_2)) +
    ggplot2::geom_point(data = df[!df$keep, , drop = FALSE], color = "#bdbdbd", size = 0.45, alpha = 0.45) +
    ggplot2::geom_point(data = df[df$keep, , drop = FALSE], color = "#16a34a", size = 0.55, alpha = 0.9) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::coord_equal() +
    ggplot2::labs(title = "Filtered overlay on unfiltered population")
}

if (isTRUE(FLOWGATE_CORE_AUTORUN)) {
  .core_fg_require_pkgs()
  obj <- FLOWGATE_CORE_INPUT_OBJECT %||% get0(FLOWGATE_CORE_INPUT_OBJECT_NAME, envir = .GlobalEnv, inherits = TRUE)
  if (!.core_fg_is_seurat(obj)) stop("Standalone autorun expected a Seurat object.")
  res <- core_run_flowgate_step(
    seurat_object = obj,
    gates = core_flowgate_default_gates(),
    ensure_umap = FLOWGATE_CORE_ENSURE_UMAP,
    seurat_version = FLOWGATE_CORE_SEURAT_VERSION
  )
  assign(FLOWGATE_CORE_OUTPUT_OBJECT_NAME, res, envir = .GlobalEnv)
  message("[flowgate_core] Wrote result to .GlobalEnv$", FLOWGATE_CORE_OUTPUT_OBJECT_NAME)
}
