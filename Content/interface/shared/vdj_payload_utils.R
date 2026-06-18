.vdj_payload_repair_colnames <- function(df, prefix = "col") {
  if (is.null(df) || !is.data.frame(df)) return(df)
  n <- ncol(df)
  if (n <= 0L) return(df)
  nm <- colnames(df)
  if (is.null(nm) || length(nm) != n) nm <- rep("", n)
  nm <- as.character(nm)
  bad <- is.na(nm) | !nzchar(nm)
  if (any(bad)) {
    nm[bad] <- paste0(prefix, "_", seq_len(sum(bad)))
  }
  colnames(df) <- make.unique(nm, sep = "_")
  df
}

.vdj_payload_bind_rows_fill <- function(x, y) {
  if (is.null(x) || !is.data.frame(x) || !nrow(x)) {
    if (is.null(y) || !is.data.frame(y)) return(data.frame(stringsAsFactors = FALSE))
    y <- .vdj_payload_repair_colnames(y, prefix = "y")
    rownames(y) <- NULL
    return(y)
  }
  if (is.null(y) || !is.data.frame(y) || !nrow(y)) {
    x <- .vdj_payload_repair_colnames(x, prefix = "x")
    rownames(x) <- NULL
    return(x)
  }

  x <- .vdj_payload_repair_colnames(x, prefix = "x")
  y <- .vdj_payload_repair_colnames(y, prefix = "y")
  cols <- union(colnames(x), colnames(y))
  for (cc in setdiff(cols, colnames(x))) x[[cc]] <- NA
  for (cc in setdiff(cols, colnames(y))) y[[cc]] <- NA
  out <- rbind(x[, cols, drop = FALSE], y[, cols, drop = FALSE])
  rownames(out) <- NULL
  out
}

.vdj_payload_bind_rows_fill_list <- function(blocks) {
  blocks <- blocks[vapply(blocks, function(x) is.data.frame(x) && nrow(x) > 0L, logical(1))]
  if (!length(blocks)) return(data.frame(stringsAsFactors = FALSE))

  out <- blocks[[1]]
  if (length(blocks) == 1L) {
    rownames(out) <- NULL
    return(out)
  }
  for (i in 2:length(blocks)) out <- .vdj_payload_bind_rows_fill(out, blocks[[i]])
  rownames(out) <- NULL
  out
}

.vdj_payload_normalize_records <- function(x) {
  base <- data.frame(
    barcode = character(0),
    clone = character(0),
    chain = character(0),
    sample = character(0),
    cell = character(0),
    stringsAsFactors = FALSE
  )
  if (is.null(x) || !is.data.frame(x) || !nrow(x)) return(base)

  need <- c("barcode", "clone", "chain", "sample", "cell")
  if (!all(need %in% colnames(x))) return(base)

  out <- x[, need, drop = FALSE]
  out$barcode <- as.character(out$barcode)
  out$clone <- as.character(out$clone)
  out$chain <- toupper(as.character(out$chain))
  out$sample <- as.character(out$sample)
  out$cell <- as.character(out$cell)

  keep <- out$chain %in% c("TCR", "BCR") &
    nzchar(out$barcode) & nzchar(out$clone) & nzchar(out$sample) & nzchar(out$cell)
  out <- out[keep, , drop = FALSE]
  if (!nrow(out)) return(base)

  key <- paste(out$sample, out$chain, out$cell, out$clone, sep = "::")
  out <- out[!duplicated(key, fromLast = TRUE), , drop = FALSE]
  rownames(out) <- NULL
  out
}

.vdj_payload_merge_records <- function(existing, fresh) {
  old <- .vdj_payload_normalize_records(existing)
  new <- .vdj_payload_normalize_records(fresh)
  if (!nrow(old)) return(new)
  if (!nrow(new)) return(old)

  replace_sc <- unique(paste(new$sample, new$chain, sep = "::"))
  old_sc <- paste(old$sample, old$chain, sep = "::")
  old <- old[!(old_sc %in% replace_sc), , drop = FALSE]

  out <- rbind(old, new)
  key <- paste(out$sample, out$chain, out$cell, sep = "::")
  out <- out[!duplicated(key, fromLast = TRUE), , drop = FALSE]
  rownames(out) <- NULL
  out
}

.vdj_payload_build_raw_contigs <- function(df,
                                           sample_id,
                                           file_name,
                                           file_path,
                                           source_tag,
                                           barcode_values,
                                           clone_values,
                                           chain_input = NULL,
                                           chain_class = NULL,
                                           mapped_cell = NULL) {
  if (is.null(df) || !is.data.frame(df)) return(data.frame(stringsAsFactors = FALSE))
  n <- nrow(df)
  if (!n) return(df)

  .recycle_chr <- function(x) {
    if (is.null(x)) return(rep(NA_character_, n))
    rep_len(as.character(x), n)
  }

  out <- df
  out$wl_vdj_sample <- .recycle_chr(sample_id)
  out$wl_vdj_file_name <- .recycle_chr(file_name)
  out$wl_vdj_file_path <- .recycle_chr(file_path)
  out$wl_vdj_source_tag <- .recycle_chr(source_tag)
  out$wl_vdj_barcode_input <- .recycle_chr(barcode_values)
  out$wl_vdj_clone_input <- .recycle_chr(clone_values)
  out$wl_vdj_chain_input <- .recycle_chr(chain_input)
  out$wl_vdj_chain_class <- toupper(.recycle_chr(chain_class))
  out$wl_vdj_chain_class[!nzchar(out$wl_vdj_chain_class) | is.na(out$wl_vdj_chain_class)] <- "UNKNOWN"
  out$wl_vdj_mapped_cell <- .recycle_chr(mapped_cell)
  out$wl_vdj_mapped_cell[!nzchar(out$wl_vdj_mapped_cell)] <- NA_character_
  out$wl_vdj_matched_to_object <- !is.na(out$wl_vdj_mapped_cell) & nzchar(out$wl_vdj_mapped_cell)
  out$wl_vdj_row_index <- seq_len(n)
  rownames(out) <- NULL
  out
}

.vdj_payload_normalize_raw_contigs <- function(x) {
  req_cols <- c(
    "wl_vdj_sample",
    "wl_vdj_file_name",
    "wl_vdj_file_path",
    "wl_vdj_source_tag",
    "wl_vdj_barcode_input",
    "wl_vdj_clone_input",
    "wl_vdj_chain_input",
    "wl_vdj_chain_class",
    "wl_vdj_mapped_cell",
    "wl_vdj_matched_to_object",
    "wl_vdj_row_index"
  )

  if (is.null(x) || !is.data.frame(x) || !nrow(x)) {
    return(data.frame(
      wl_vdj_sample = character(0),
      wl_vdj_file_name = character(0),
      wl_vdj_file_path = character(0),
      wl_vdj_source_tag = character(0),
      wl_vdj_barcode_input = character(0),
      wl_vdj_clone_input = character(0),
      wl_vdj_chain_input = character(0),
      wl_vdj_chain_class = character(0),
      wl_vdj_mapped_cell = character(0),
      wl_vdj_matched_to_object = logical(0),
      wl_vdj_row_index = integer(0),
      stringsAsFactors = FALSE
    ))
  }

  out <- x
  for (cc in setdiff(req_cols, colnames(out))) out[[cc]] <- NA

  chr_cols <- setdiff(req_cols, c("wl_vdj_matched_to_object", "wl_vdj_row_index"))
  for (cc in chr_cols) out[[cc]] <- as.character(out[[cc]])
  out$wl_vdj_chain_class <- toupper(out$wl_vdj_chain_class)
  out$wl_vdj_chain_class[!nzchar(out$wl_vdj_chain_class) | is.na(out$wl_vdj_chain_class)] <- "UNKNOWN"
  out$wl_vdj_mapped_cell[!nzchar(out$wl_vdj_mapped_cell)] <- NA_character_
  out$wl_vdj_matched_to_object <- as.logical(out$wl_vdj_matched_to_object)
  out$wl_vdj_matched_to_object[is.na(out$wl_vdj_matched_to_object)] <- !is.na(out$wl_vdj_mapped_cell) & nzchar(out$wl_vdj_mapped_cell)
  out$wl_vdj_row_index <- suppressWarnings(as.integer(out$wl_vdj_row_index))
  out$wl_vdj_row_index[is.na(out$wl_vdj_row_index)] <- seq_len(nrow(out))[is.na(out$wl_vdj_row_index)]
  rownames(out) <- NULL
  out
}

.vdj_payload_merge_raw_contigs <- function(existing, fresh) {
  old <- .vdj_payload_normalize_raw_contigs(existing)
  new <- .vdj_payload_normalize_raw_contigs(fresh)
  if (!nrow(old)) return(new)
  if (!nrow(new)) return(old)

  replace_sc <- unique(paste(new$wl_vdj_sample, new$wl_vdj_chain_class, sep = "::"))
  old_sc <- paste(old$wl_vdj_sample, old$wl_vdj_chain_class, sep = "::")
  old <- old[!(old_sc %in% replace_sc), , drop = FALSE]

  out <- .vdj_payload_bind_rows_fill(old, new)
  rownames(out) <- NULL
  out
}
