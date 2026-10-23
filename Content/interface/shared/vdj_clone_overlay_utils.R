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

vdj_clone_id_column <- function(meta, feature = "tcr", requested = NULL) {
  cols <- colnames(meta %||% data.frame())
  requested <- as.character(requested %||% "")[[1]]
  if (nzchar(requested) && requested %in% cols) return(requested)

  candidates <- if (identical(feature, "bcr")) {
    c("vdj_bcr_clone", "bcr_clone", "clone_bcr", "cdr3_bcr", "cdr3")
  } else {
    c("vdj_tcr_clone", "tcr_clone", "clone_tcr", "cdr3_tcr", "cdr3")
  }
  hit <- candidates[candidates %in% cols]
  if (length(hit)) hit[[1]] else ""
}

vdj_clone_valid_ids <- function(values) {
  ids <- trimws(as.character(values %||% character(0)))
  invalid <- is.na(ids) | !nzchar(ids) | tolower(ids) %in% c("unknown", "na", "none") | ids == "0"
  ids[invalid] <- NA_character_
  ids
}

vdj_clone_rank_table <- function(meta,
                                 feature = "tcr",
                                 clone_col = NULL,
                                 ranking = c("cell_count", "percent"),
                                 label_map = NULL) {
  ranking <- match.arg(ranking)
  if (is.null(meta) || !is.data.frame(meta) || !nrow(meta)) return(data.frame())

  clone_col <- vdj_clone_id_column(meta, feature = feature, requested = clone_col)
  if (!nzchar(clone_col)) return(data.frame())

  clone_ids <- vdj_clone_valid_ids(meta[[clone_col]])
  clone_ids <- clone_ids[!is.na(clone_ids)]
  if (!length(clone_ids)) return(data.frame())

  # Agent note: User chose pooled clonotype-ID ranking. Identical ID text is
  # intentionally combined across samples; UI must keep the collision warning.
  counts <- sort(table(clone_ids), decreasing = TRUE)
  out <- data.frame(
    clonotype_id = names(counts),
    cell_count = as.integer(counts),
    stringsAsFactors = FALSE
  )
  out$percent <- 100 * out$cell_count / sum(out$cell_count)
  out$receptor <- if (identical(feature, "bcr")) "BCR" else "TCR"

  order_value <- if (identical(ranking, "percent")) out$percent else out$cell_count
  out <- out[order(-order_value, -out$cell_count, out$clonotype_id), , drop = FALSE]
  rownames(out) <- NULL
  out$rank <- seq_len(nrow(out))

  labels <- if (is.null(label_map)) character(0) else as.character(label_map)
  label_names <- names(label_map %||% character(0))
  if (length(labels) && length(label_names) == length(labels)) names(labels) <- label_names
  mapped <- labels[out$clonotype_id]
  default_labels <- paste("Clone", out$rank)
  out$label <- ifelse(!is.na(mapped) & nzchar(trimws(mapped)), trimws(mapped), default_labels)

  out[, c("rank", "label", "cell_count", "clonotype_id", "percent", "receptor"), drop = FALSE]
}

vdj_clone_state_key <- function(object_name, feature = "tcr") {
  paste(as.character(object_name %||% "")[[1]], as.character(feature %||% "tcr")[[1]], sep = "::")
}

vdj_clone_state_get <- function(session, object_name, feature = "tcr") {
  store <- session$userData$vdj_clone_selection_store
  key <- vdj_clone_state_key(object_name, feature)
  if (!is.environment(store) || !exists(key, envir = store, inherits = FALSE)) {
    return(list(selected = character(0), labels = character(0), initialized = FALSE))
  }
  get(key, envir = store, inherits = FALSE)
}

vdj_clone_state_set <- function(session,
                                object_name,
                                feature = "tcr",
                                selected = character(0),
                                labels = character(0),
                                initialized = TRUE) {
  if (!is.environment(session$userData$vdj_clone_selection_store)) {
    session$userData$vdj_clone_selection_store <- new.env(parent = emptyenv())
  }
  selected <- unique(as.character(selected %||% character(0)))
  selected <- selected[!is.na(selected) & nzchar(selected)]
  labels <- as.character(labels %||% character(0))
  assign(
    vdj_clone_state_key(object_name, feature),
    list(selected = selected, labels = labels, initialized = isTRUE(initialized)),
    envir = session$userData$vdj_clone_selection_store
  )
  invisible(NULL)
}
