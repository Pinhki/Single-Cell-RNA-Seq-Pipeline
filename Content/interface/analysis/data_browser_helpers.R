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
