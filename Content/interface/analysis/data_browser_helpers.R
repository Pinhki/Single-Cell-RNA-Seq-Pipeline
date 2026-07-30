`%||%` <- function(a, b) if (!is.null(a)) a else b

db_is_effectively_numeric <- function(x) {
  if (is.numeric(x)) {
    finite_n <- sum(is.finite(x), na.rm = TRUE)
    return(finite_n > 0L)
  }
  x_chr <- as.character(x %||% character(0))
  x_chr <- trimws(x_chr)
  x_chr[x_chr %in% c("", "NA", "NaN", "Inf", "-Inf")] <- NA_character_
  keep <- !is.na(x_chr)
  if (!any(keep)) return(FALSE)
  parsed <- suppressWarnings(as.numeric(x_chr[keep]))
  all(is.finite(parsed))
}

db_is_cluster_like_metadata <- function(col_name, x = NULL) {
  nm <- tolower(trimws(as.character(col_name %||% "")))
  if (!nzchar(nm)) return(FALSE)

  name_hit <- grepl(
    "(^|[_\\.])(seurat_clusters|cluster|clust|louvain|leiden|graphcluster|snn_res|nn_res)([_\\.]|$)|(^|[_\\.])res\\.[0-9]+$",
    nm,
    perl = TRUE
  ) || grepl("^sweep_(nn_)?res\\.[0-9]+$", nm, perl = TRUE)
  if (isTRUE(name_hit)) return(TRUE)

  if (is.null(x)) return(FALSE)
  x_chr <- as.character(x %||% character(0))
  x_chr <- trimws(x_chr)
  x_chr[x_chr %in% c("", "NA", "NaN", "Inf", "-Inf")] <- NA_character_
  keep <- !is.na(x_chr)
  if (!any(keep)) return(FALSE)

  parsed <- suppressWarnings(as.numeric(x_chr[keep]))
  if (!all(is.finite(parsed))) return(FALSE)

  uniq_n <- length(unique(x_chr[keep]))
  n <- sum(keep)
  mostly_integer <- mean(abs(parsed - round(parsed)) < 1e-8) >= 0.98
  low_cardinality <- uniq_n <= max(60L, as.integer(ceiling(sqrt(n))))
  plausible_cluster_range <- min(parsed, na.rm = TRUE) >= -1 && max(parsed, na.rm = TRUE) <= 200
  mostly_integer && low_cardinality && plausible_cluster_range
}

db_order_levels_for_color <- function(x, cluster_like = FALSE) {
  lv <- unique(as.character(x %||% character(0)))
  lv <- lv[!is.na(lv)]
  if (!length(lv)) return(character(0))
  if (!isTRUE(cluster_like)) return(sort(lv, method = "radix"))

  is_num <- grepl("^-?[0-9]+(\\.[0-9]+)?$", lv)
  lv_num <- lv[is_num]
  lv_chr <- lv[!is_num]

  if (length(lv_num)) {
    ord <- order(suppressWarnings(as.numeric(lv_num)), lv_num, na.last = TRUE)
    lv_num <- lv_num[ord]
  }
  if (length(lv_chr)) lv_chr <- sort(lv_chr, method = "radix")
  c(lv_num, lv_chr)
}

db_discrete_palette <- function(n) {
  n <- as.integer(n %||% 0L)
  if (!is.finite(n) || n < 1L) return(character(0))
  fn <- tryCatch(getFromNamespace("DiscretePalette", "Seurat"), error = function(e) NULL)
  pal <- NULL
  if (is.function(fn)) pal <- tryCatch(fn(n), error = function(e) NULL)
  if (is.null(pal) || length(pal) < n) {
    pal <- grDevices::hcl.colors(max(n, 3L), palette = "Dark 3")[seq_len(n)]
  } else {
    pal <- as.character(pal)[seq_len(n)]
  }
  pal
}

db_colors_from_dimplot <- function(sobj, reduction_name, color_col, cluster_levels) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
  color_col <- as.character(color_col %||% "")
  if (!nzchar(color_col) || !(color_col %in% colnames(sobj@meta.data))) return(NULL)
  reds <- names(sobj@reductions %||% list())
  if (!length(reds)) return(NULL)
  red_use <- as.character(reduction_name %||% "")
  if (!nzchar(red_use) || !(red_use %in% reds)) {
    reds_lc <- tolower(reds)
    red_use <- if ("umap" %in% reds_lc) reds[[match("umap", reds_lc)]] else reds[[1]]
  }
  p_tmp <- tryCatch(
    Seurat::DimPlot(sobj, reduction = red_use, group.by = color_col),
    error = function(e) NULL
  )
  if (is.null(p_tmp) || !inherits(p_tmp, "ggplot")) return(NULL)

  d_plot <- tryCatch(p_tmp$data, error = function(e) NULL)
  d_layer <- tryCatch(ggplot2::ggplot_build(p_tmp)$data[[1]], error = function(e) NULL)
  if (is.null(d_plot) || is.null(d_layer) || !nrow(d_plot) || !nrow(d_layer)) return(NULL)

  col_key <- if (color_col %in% colnames(d_plot)) {
    color_col
  } else if ("ident" %in% colnames(d_plot)) {
    "ident"
  } else {
    ""
  }
  if (!nzchar(col_key)) return(NULL)

  vals <- as.character(d_plot[[col_key]])
  cols <- as.character(d_layer$colour)
  n <- min(length(vals), length(cols))
  if (n < 1L) return(NULL)
  vals <- vals[seq_len(n)]
  cols <- cols[seq_len(n)]
  keep <- !is.na(vals) & nzchar(vals) & !is.na(cols) & nzchar(cols)
  vals <- vals[keep]
  cols <- cols[keep]
  if (!length(vals) || !length(cols)) return(NULL)

  first_idx <- match(unique(vals), vals)
  map <- cols[first_idx]
  names(map) <- unique(vals)
  mapped <- unname(map[cluster_levels])
  names(mapped) <- cluster_levels
  if (!length(mapped) || all(is.na(mapped) | !nzchar(mapped))) return(NULL)
  mapped
}

db_prepare_color_vector <- function(x, col_name = NULL) {
  if (db_is_effectively_numeric(x) && !db_is_cluster_like_metadata(col_name, x)) {
    return(suppressWarnings(as.numeric(as.character(x))))
  }
  out <- as.character(x %||% character(0))
  out[is.na(out) | !nzchar(trimws(out))] <- "NA"
  out
}

db_is_split_safe_metadata <- function(col_name, x = NULL) {
  if (is.null(x)) return(FALSE)
  if (db_is_cluster_like_metadata(col_name, x)) return(TRUE)
  !db_is_effectively_numeric(x)
}

db_split_safe_cols <- function(meta_df, exclude = character(0)) {
  if (!is.data.frame(meta_df) || !ncol(meta_df)) return(character(0))
  cols <- colnames(meta_df)
  keep <- vapply(
    cols,
    function(nm) db_is_split_safe_metadata(nm, meta_df[[nm]]),
    logical(1)
  )
  out <- cols[keep]
  if (length(exclude)) out <- setdiff(out, as.character(exclude))
  unique(as.character(out))
}

db_build_split_choices <- function(cols, exclude = character(0), meta_df = NULL) {
  cols <- unique(as.character(cols %||% character(0)))
  cols <- cols[nzchar(cols)]
  if (is.data.frame(meta_df) && nrow(meta_df) >= 0L) {
    safe_cols <- db_split_safe_cols(meta_df)
    cols <- intersect(cols, safe_cols)
  }
  if (length(exclude)) cols <- setdiff(cols, as.character(exclude))
  preferred <- c("condition", "orig.ident", "batch", "sample", "sample_name")
  keep <- unique(c(preferred[preferred %in% cols], cols))
  choices <- c("None" = "__none__")
  for (nm in keep) choices[[nm]] <- nm
  choices
}

# Pure, version-neutral helpers for page_data_browser_new.R.
# Agent note: Keep these functions independent of Shiny input/session and
# recluster_new_data so Seurat v4/v5 pages share identical selection behavior.

db_scalar_chr <- function(x, default = "") {
  x <- as.character(x %||% default)
  x <- x[!is.na(x)]
  if (!length(x)) return(default)
  x[[1]]
}

db_norm_plot_tab <- function(v) {
  x <- tolower(trimws(db_scalar_chr(v, default = "umap")))
  if (x %in% c("scatter", "gene scatter plot")) return("scatter")
  "umap"
}

db_norm_expr_tab <- function(v) {
  x <- tolower(trimws(db_scalar_chr(v, default = "stacked")))
  if (x %in% c("pseudobulk", "pseudobulk table")) return("pseudobulk")
  if (x %in% c("stacked", "stacked bar", "stacked bar plot")) return("stacked")
  "violin"
}

db_norm_rule_plot_tab <- function(v) {
  x <- tolower(trimws(db_scalar_chr(v, default = "rule_umap")))
  if (x %in% c("rule_scatter", "scatter", "gene scatter plot")) return("rule_scatter")
  "rule_umap"
}

db_norm_key <- function(x) {
  gsub("[^a-z0-9]", "", tolower(as.character(x %||% "")))
}

db_strip_suffix <- function(x) {
  sub("([._-][0-9]+)$", "", as.character(x %||% ""), perl = TRUE)
}

db_embedding_reduction_choices <- function(obj) {
  if (is.null(obj) || !inherits(obj, "Seurat")) return(character(0))
  reds <- tryCatch(names(obj@reductions), error = function(e) character(0))
  if (!length(reds)) return(character(0))
  keep <- vapply(reds, function(red) {
    emb <- tryCatch(Seurat::Embeddings(obj, red), error = function(e) NULL)
    is.matrix(emb) && ncol(emb) >= 2L
  }, logical(1))
  reds[keep]
}

db_reduction_shape_signature <- function(obj) {
  if (is.null(obj) || !inherits(obj, "Seurat")) return("")
  reds <- tryCatch(names(obj@reductions), error = function(e) character(0))
  if (!length(reds)) return("")
  parts <- vapply(reds, function(red) {
    emb <- tryCatch(Seurat::Embeddings(obj, red), error = function(e) NULL)
    if (is.null(emb) || !is.matrix(emb)) return(paste(red, "NA", sep = ":"))
    paste(red, nrow(emb), ncol(emb), sep = ":")
  }, character(1))
  paste(parts, collapse = "|")
}

db_preferred_embedding_reduction <- function(obj, entry = NULL) {
  reds <- db_embedding_reduction_choices(obj)
  if (!length(reds)) return("")
  reds_lc <- tolower(reds)
  dims_raw <- tryCatch(entry$prefs$confirmed_dims$value, error = function(e) NULL)
  dims_val <- suppressWarnings(as.integer(dims_raw))
  dims_val <- dims_val[is.finite(dims_val) & !is.na(dims_val)]
  if (length(dims_val)) {
    dims_tag <- as.character(dims_val[[1]])
    umap_dim <- which(grepl("umap", reds_lc, fixed = TRUE) & grepl(dims_tag, reds_lc, fixed = TRUE))
    if (length(umap_dim)) return(reds[[umap_dim[[1]]]])
    tsne_dim <- which(grepl("tsne", reds_lc, fixed = TRUE) & grepl(dims_tag, reds_lc, fixed = TRUE))
    if (length(tsne_dim)) return(reds[[tsne_dim[[1]]]])
  }
  if ("umap" %in% reds_lc) return(reds[[match("umap", reds_lc)]])
  umap_prefix <- which(grepl("^umap", reds_lc))
  if (length(umap_prefix)) return(reds[[umap_prefix[[1]]]])
  umap_any <- which(grepl("umap", reds_lc, fixed = TRUE))
  if (length(umap_any)) return(reds[[umap_any[[1]]]])
  reds[[1]]
}

db_safe_assay_choices <- function(obj) {
  assays_raw <- tryCatch(SeuratObject::Assays(obj), error = function(e) NULL)
  if (is.null(assays_raw)) assays_raw <- tryCatch(Assays(obj), error = function(e) NULL)

  assays_chr <- character(0)
  if (is.character(assays_raw) || is.factor(assays_raw)) {
    assays_chr <- as.character(assays_raw)
  } else if (is.list(assays_raw)) {
    named <- names(assays_raw) %||% character(0)
    named <- named[nzchar(named)]
    if (length(named)) assays_chr <- named
  } else {
    named <- tryCatch(names(assays_raw), error = function(e) character(0))
    named <- as.character(named %||% character(0))
    named <- named[nzchar(named)]
    if (length(named)) assays_chr <- named
  }

  assays_chr <- assays_chr[!is.na(assays_chr) & nzchar(assays_chr)]
  assays_chr <- unique(assays_chr)
  if (length(assays_chr)) return(assays_chr)

  fallback <- tryCatch(names(obj@assays), error = function(e) character(0))
  fallback <- as.character(fallback %||% character(0))
  fallback <- fallback[!is.na(fallback) & nzchar(fallback)]
  unique(fallback)
}

db_preferred_assay_choice <- function(obj) {
  assay_choices <- db_safe_assay_choices(obj)
  if (!length(assay_choices)) return("")
  # Data Browser expression must not inherit an integrated DefaultAssay.
  priority <- c("SCT", "RNA", "integrated", "ADT")
  priority_hit <- match(tolower(priority), tolower(assay_choices), nomatch = 0L)
  priority_hit <- priority_hit[priority_hit > 0L]
  if (length(priority_hit)) return(assay_choices[[priority_hit[[1]]]])
  assay_choices[[1]]
}

db_cell_set_signature <- function(cells, universe) {
  universe <- as.character(universe %||% character(0))
  universe <- universe[!is.na(universe) & nzchar(universe)]
  cells <- as.character(cells %||% character(0))
  cells <- unique(cells[!is.na(cells) & nzchar(cells)])
  if (!length(universe) || !length(cells)) return("0:0:0:0")
  mask <- universe %in% cells
  pad_n <- (8L - (length(mask) %% 8L)) %% 8L
  if (pad_n > 0L) mask <- c(mask, rep(FALSE, pad_n))
  raw_bits <- packBits(as.integer(mask), type = "raw")
  byte_vals <- as.integer(raw_bits)
  idx <- seq_along(byte_vals)
  paste(sum(mask), length(byte_vals), sum(byte_vals), sum(byte_vals * (idx %% 104729L)), sep = ":")
}

db_axis_index_choices <- function(obj, reduction_name) {
  red <- db_scalar_chr(reduction_name, default = "")
  if (!nzchar(red)) return(character(0))
  emb <- tryCatch(Seurat::Embeddings(obj, red), error = function(e) NULL)
  if (is.null(emb) || !is.matrix(emb) || ncol(emb) < 2L) return(character(0))
  stats::setNames(as.character(seq_len(ncol(emb))), paste0("Dim ", seq_len(ncol(emb))))
}

db_barcode_keys <- function(x) {
  x <- trimws(as.character(x %||% ""))
  if (!nzchar(x)) return(character(0))
  no_suffix <- db_strip_suffix(x)
  tokens <- unlist(strsplit(no_suffix, "[^A-Za-z0-9]+", perl = TRUE), use.names = FALSE)
  dna <- regmatches(no_suffix, gregexpr("[ACGTNacgtn]{8,}", no_suffix, perl = TRUE))[[1]]
  cand <- unique(c(x, no_suffix, tokens, dna))
  keys <- db_norm_key(cand)
  keys <- unique(keys[nzchar(keys)])
  long_keys <- keys[nchar(keys) >= 6]
  if (length(long_keys)) return(long_keys)
  keys
}

db_pick_barcode_col <- function(nms) {
  nms <- as.character(nms %||% character(0))
  if (!length(nms)) return(NA_character_)
  hit <- grep("barcode|cell", nms, ignore.case = TRUE, value = TRUE)[1]
  if (!is.na(hit) && nzchar(hit)) return(hit)
  nms[[1]]
}

db_read_barcodes_from_path <- function(path) {
  p <- as.character(path %||% "")
  if (!nzchar(p) || !file.exists(p) || dir.exists(p)) return(character(0))
  ext <- tolower(tools::file_ext(p))
  if (identical(ext, "txt")) {
    vals <- trimws(readLines(p, warn = FALSE))
    return(unique(vals[nzchar(vals)]))
  }
  read_fun <- if (identical(ext, "csv")) utils::read.csv else utils::read.delim
  df <- tryCatch(read_fun(p, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE), error = function(e) NULL)
  if (is.null(df) || !is.data.frame(df) || !nrow(df)) {
    df <- tryCatch(read_fun(p, header = FALSE, stringsAsFactors = FALSE, check.names = FALSE), error = function(e) NULL)
  }
  if (is.null(df) || !is.data.frame(df) || !nrow(df) || !ncol(df)) return(character(0))
  bc_col <- db_pick_barcode_col(colnames(df))
  vals <- trimws(as.character(df[[bc_col]] %||% character(0)))
  unique(vals[nzchar(vals)])
}

db_match_barcodes_to_cells <- function(barcodes, all_cells) {
  barcodes <- unique(trimws(as.character(barcodes %||% character(0))))
  barcodes <- barcodes[nzchar(barcodes)]
  all_cells <- as.character(all_cells %||% character(0))
  if (!length(barcodes) || !length(all_cells)) return(character(0))

  key_rows <- lapply(seq_along(all_cells), function(i) {
    ks <- db_barcode_keys(all_cells[[i]])
    if (!length(ks)) return(NULL)
    data.frame(row = rep.int(i, length(ks)), key = ks, stringsAsFactors = FALSE)
  })
  key_rows <- key_rows[!vapply(key_rows, is.null, logical(1))]
  key_df <- if (!length(key_rows)) NULL else do.call(rbind, key_rows)
  key_lookup <- if (is.null(key_df)) list() else split(key_df$row, key_df$key)

  hit_rows <- integer(0)
  for (bc in barcodes) {
    keys <- db_barcode_keys(bc)
    cand <- unique(unlist(key_lookup[keys], use.names = FALSE))
    if (!length(cand)) {
      base <- db_strip_suffix(bc)
      if (nzchar(base)) {
        cand <- which(db_strip_suffix(all_cells) == base | grepl(base, all_cells, fixed = TRUE))
      }
    }
    if (!length(cand)) next
    score <- integer(length(cand))
    score[all_cells[cand] == bc] <- score[all_cells[cand] == bc] + 4L
    score[db_strip_suffix(all_cells[cand]) == db_strip_suffix(bc)] <-
      score[db_strip_suffix(all_cells[cand]) == db_strip_suffix(bc)] + 2L
    score[grepl(bc, all_cells[cand], fixed = TRUE)] <-
      score[grepl(bc, all_cells[cand], fixed = TRUE)] + 1L
    hit_rows <- c(hit_rows, cand[score == max(score)])
  }
  unique(all_cells[unique(hit_rows)])
}

db_is_supported_meta_column <- function(v) {
  is.atomic(v) || is.factor(v)
}

db_is_numeric_rule_column <- function(v) {
  if (!(is.numeric(v) || is.integer(v))) return(FALSE)
  vv <- suppressWarnings(as.numeric(v))
  any(is.finite(vv))
}

db_likely_positive_values <- function(levels_vec, col_name = "") {
  lv <- as.character(levels_vec %||% character(0))
  lv <- lv[!is.na(lv) & nzchar(lv)]
  if (!length(lv)) return(character(0))
  key <- tolower(trimws(lv))
  hit <- key %in% c("true", "doublet", "positive", "pos", "yes", "1")
  is_doublet_col <- grepl("doublet", tolower(db_scalar_chr(col_name, default = "")), fixed = TRUE)
  if (isTRUE(is_doublet_col)) hit <- hit & (key != "singlet")
  lv[hit]
}

db_rule_color_presets <- function() {
  list(
    default = c(A_only = "#D55E00", B_only = "#0072B2", A_B = "#009E73", Neither = "#9CA3AF", Missing = "#6B7280"),
    colorblind = c(A_only = "#E69F00", B_only = "#56B4E9", A_B = "#009E73", Neither = "#999999", Missing = "#4D4D4D"),
    vivid = c(A_only = "#E64B35", B_only = "#4DBBD5", A_B = "#00A087", Neither = "#7E6148", Missing = "#3C5488")
  )
}

db_classify_rule_column <- function(vec, def) {
  n <- length(vec)
  out <- rep("Missing", n)
  names(out) <- names(vec)
  if (!length(vec) || !is.list(def)) return(out)
  type_now <- db_scalar_chr(def$type, default = "")
  if (identical(type_now, "numeric")) {
    rng <- suppressWarnings(as.numeric(def$range %||% c(NA_real_, NA_real_)))
    if (length(rng) != 2 || any(!is.finite(rng))) return(out)
    vv <- suppressWarnings(as.numeric(vec))
    good <- is.finite(vv)
    out[good] <- ifelse(vv[good] >= rng[[1]] & vv[good] <= rng[[2]], "TRUE", "FALSE")
    return(out)
  }
  vals <- trimws(as.character(vec %||% character(0)))
  good <- !is.na(vals) & nzchar(vals)
  selected <- as.character(def$selected %||% character(0))
  out[good] <- if (length(selected)) ifelse(vals[good] %in% selected, "TRUE", "FALSE") else "FALSE"
  out
}

db_combine_rule_ab_overlap <- function(rule_a_state, rule_b_state) {
  n <- max(length(rule_a_state), length(rule_b_state))
  out <- rep("Missing", n)
  a <- as.character(rule_a_state %||% rep("Missing", n))
  b <- as.character(rule_b_state %||% rep("Missing", n))
  if (!length(a) || !length(b)) return(out)
  miss <- a == "Missing" | b == "Missing"
  a_true <- a == "TRUE"
  b_true <- b == "TRUE"
  out[!miss & a_true & b_true] <- "A_B"
  out[!miss & a_true & !b_true] <- "A_only"
  out[!miss & !a_true & b_true] <- "B_only"
  out[!miss & !a_true & !b_true] <- "Neither"
  out
}

db_is_reasonable_discrete <- function(v) {
  if (is.factor(v) || is.character(v) || is.logical(v)) return(TRUE)
  if (is.numeric(v) || is.integer(v)) return(length(unique(stats::na.omit(v))) <= 40L)
  FALSE
}

db_sort_numeric_first <- function(v) {
  v <- as.character(v %||% character(0))
  v <- v[nzchar(v)]
  if (!length(v)) return(character(0))
  uniq <- unique(v)
  num <- suppressWarnings(as.numeric(uniq))
  ok <- is.finite(num)
  c(uniq[ok][order(num[ok], uniq[ok])], sort(uniq[!ok], na.last = TRUE))
}

db_is_cluster_like_name <- function(col_name) {
  cn <- tolower(as.character(col_name %||% ""))
  grepl("(^|_|\\.)(cluster|seurat|res\\.|leiden|louvain|snn|nn|wsnn|wknn|ident)(_|\\.|$)", cn, perl = TRUE)
}

db_is_continuous_metric_name <- function(col_name) {
  cn <- tolower(as.character(col_name %||% ""))
  grepl(
    "(^|_|\\.)(size|count|counts|score|scores|rate|ratio|percent|percentage|pct|freq|frequency|depth|reads|umis|umi|nfeature|ncount|total|sum|mean|median|max|min)(_|\\.|$)",
    cn,
    perl = TRUE
  )
}

db_build_metadata_profile <- function(col_name, vec) {
  x_chr <- trimws(as.character(vec %||% character(0)))
  keep <- nzchar(x_chr) & !is.na(x_chr)
  x_keep <- x_chr[keep]
  parsed <- suppressWarnings(as.numeric(x_keep))
  parse_rate <- if (length(x_keep)) mean(is.finite(parsed)) else 0
  numeric_like <- parse_rate >= 0.95

  numeric_vals <- suppressWarnings(as.numeric(x_chr))
  finite_num <- numeric_vals[is.finite(numeric_vals)]
  unique_num <- sort(unique(finite_num))
  unique_n <- length(unique_num)
  integer_like <- length(unique_num) > 0 && all(abs(unique_num - round(unique_num)) < 1e-8)
  consecutive_numeric <- length(unique_num) > 1 && all(abs(diff(unique_num) - 1) < 1e-8)
  name_continuous_metric <- db_is_continuous_metric_name(col_name)
  name_cluster_like <- db_is_cluster_like_name(col_name) && !isTRUE(name_continuous_metric)
  behavior_cluster_like <- numeric_like && integer_like && unique_n >= 2 && unique_n <= 200 &&
    !isTRUE(name_continuous_metric)
  cluster_like <- isTRUE(name_cluster_like) || isTRUE(behavior_cluster_like)

  if (!numeric_like) {
    default_mode <- "category"
  } else if (unique_n > 200 || isTRUE(name_continuous_metric)) {
    default_mode <- "range"
  } else if (cluster_like) {
    default_mode <- "category"
  } else if (consecutive_numeric) {
    default_mode <- "range"
  } else if (unique_n <= 24) {
    default_mode <- "category"
  } else {
    default_mode <- "range"
  }

  bucket <- if (cluster_like) {
    "cluster"
  } else if (numeric_like && identical(default_mode, "range")) {
    "continuous"
  } else {
    "categorical"
  }

  list(
    col_name = col_name,
    bucket = bucket,
    numeric_like = numeric_like,
    unique_numeric_count = unique_n,
    integer_like = integer_like,
    consecutive_numeric = consecutive_numeric,
    cluster_like = cluster_like,
    default_mode = default_mode,
    levels = db_sort_numeric_first(unique(x_chr[keep])),
    min_val = if (length(unique_num)) min(unique_num) else NA_real_,
    max_val = if (length(unique_num)) max(unique_num) else NA_real_
  )
}

db_safe_key <- function(x) {
  out <- gsub("[^A-Za-z0-9]+", "_", as.character(x %||% ""), perl = TRUE)
  out <- gsub("_+", "_", out)
  out <- gsub("^_|_$", "", out)
  if (!nzchar(out)) out <- "col"
  out
}

db_unique_metadata_col_name <- function(md, label, prefix = "saved_group") {
  base <- paste(prefix, db_safe_key(label), sep = "_")
  base <- gsub("_+", "_", base)
  base <- gsub("^_|_$", "", base)
  if (!nzchar(base)) base <- prefix
  out <- base
  i <- 2L
  while (out %in% colnames(md)) {
    out <- sprintf("%s_%d", base, i)
    i <- i + 1L
  }
  out
}
