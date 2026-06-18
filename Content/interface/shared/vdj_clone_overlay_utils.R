.vdj_clone_size_values <- function(meta, feature = "tcr") {
  if (is.null(meta) || !is.data.frame(meta) || !nrow(meta)) return(numeric(0))

  col_use <- if (identical(feature, "bcr")) "vdj_bcr_clone_size" else "vdj_tcr_clone_size"
  if (!col_use %in% colnames(meta)) return(numeric(0))

  vals <- suppressWarnings(as.numeric(meta[[col_use]]))
  vals[is.finite(vals)]
}

.vdj_clone_threshold_config <- function(meta, feature = "tcr", current = 2, default = 2) {
  vals <- .vdj_clone_size_values(meta, feature = feature)
  maxv <- if (length(vals)) max(2L, as.integer(max(vals, na.rm = TRUE))) else 50L
  slider_max <- max(5L, maxv)

  current_num <- suppressWarnings(as.numeric(current))
  if (!is.finite(current_num)) current_num <- default
  slider_value <- as.integer(max(1, min(current_num, slider_max)))

  list(
    min = 1L,
    max = as.integer(slider_max),
    value = slider_value
  )
}
