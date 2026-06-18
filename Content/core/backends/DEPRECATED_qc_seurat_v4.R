# DEPRECATED FILE
# This file is no longer used by app routing.
# Use versioned core modules instead:
# - core/seurat_v4/*
# - core/seurat_v5/*
# Kept only for historical reference.

## ---- core/backends/qc_seurat_v4.R -------------------------------------
suppressPackageStartupMessages({
  library(Seurat)
  library(Matrix)
})

.msg <- function(...) message("[qc_core:v4] ", paste0(..., collapse = ""))
`%||%` <- function(a, b) if (is.null(a)) b else a

.get_path <- function(sample_row) {
  p <- if ("path" %in% names(sample_row)) sample_row$path[[1]] else sample_row$name[[1]]
  p <- as.character(p)
  if (!nzchar(p) || !file.exists(p)) {
    stop(sprintf("file not found: %s", p))
  }
  normalizePath(p, winslash = "/")
}

.read_counts_from_delim <- function(path) {
  ext <- tolower(tools::file_ext(path))
  sep <- if (ext == "csv") "," else "\t"
  df <- utils::read.table(path, sep = sep, header = TRUE, row.names = 1, check.names = FALSE, quote = "\"'", comment.char = "")
  if (!nrow(df) || !ncol(df)) stop("Delimited file has no usable matrix dimensions: ", path)

  mat <- as.matrix(df)
  suppressWarnings(storage.mode(mat) <- "numeric")
  mat[is.na(mat)] <- 0
  Matrix::Matrix(mat, sparse = TRUE)
}

.ensure_qc_columns <- function(sobj) {
  if (!"nFeature_RNA" %in% names(sobj@meta.data)) {
    sobj[["nFeature_RNA"]] <- Matrix::colSums(Seurat::GetAssayData(sobj, slot = "counts") > 0)
  }
  if (!"nCount_RNA" %in% names(sobj@meta.data)) {
    sobj[["nCount_RNA"]] <- Matrix::colSums(Seurat::GetAssayData(sobj, slot = "counts"))
  }

  if (!any(c("percent.mt", "percent.mito", "mito") %in% names(sobj@meta.data))) {
    rn <- rownames(sobj)
    has_MT <- any(grepl("^MT-", rn))
    has_mt <- any(grepl("^mt-", rn))
    pat <- if (has_MT && !has_mt) "^MT-" else if (has_mt && !has_MT) "^mt-" else "^(MT-|mt-)"
    sobj[["percent.mt"]] <- Seurat::PercentageFeatureSet(sobj, pattern = pat)
  }

  sobj
}

.apply_filters <- function(sobj, sample_row) {
  md <- sobj@meta.data
  nf <- md[["nFeature_RNA"]]
  nc <- md[["nCount_RNA"]]
  mt <- md[["percent.mt"]] %||% md[["percent.mito"]] %||% md[["mito"]]

  keep <- rep(TRUE, ncol(sobj))

  if (!is.null(sample_row$min_features)) keep <- keep & nf >= as.numeric(sample_row$min_features)
  if (!is.null(sample_row$max_features)) keep <- keep & nf <= as.numeric(sample_row$max_features)
  if (!is.null(sample_row$min_umi_counts)) keep <- keep & nc >= as.numeric(sample_row$min_umi_counts)
  if (!is.null(sample_row$max_umi_counts)) keep <- keep & nc <= as.numeric(sample_row$max_umi_counts)
  if (!is.null(sample_row$max_mt_percent) && !is.null(mt)) keep <- keep & mt <= as.numeric(sample_row$max_mt_percent)

  subset(sobj, cells = colnames(sobj)[keep])
}

run_qc_for_sample <- function(sample_row, apply_filters = FALSE) {
  stopifnot(is.data.frame(sample_row), nrow(sample_row) == 1)

  path <- .get_path(sample_row)
  ext <- tolower(tools::file_ext(path))
  .msg("loading: ", basename(path), " (", ext, ")\n")

  sobj <- NULL
  if (ext %in% c("rds", "rda", "rdata")) {
    obj <- if (ext == "rds") {
      readRDS(path)
    } else {
      e <- new.env(parent = emptyenv()); on.exit(rm(e), add = TRUE)
      load(path, envir = e)
      Filter(function(x) inherits(x, "Seurat"), as.list(e))[[1]]
    }
    if (!inherits(obj, "Seurat")) stop("file did not contain a Seurat object: ", path)
    sobj <- obj
  } else if (ext %in% c("h5", "hdf5")) {
    counts <- Seurat::Read10X_h5(path)
    sobj <- Seurat::CreateSeuratObject(counts = counts, project = basename(path))
  } else if (ext %in% c("csv", "tsv", "txt")) {
    counts <- .read_counts_from_delim(path)
    sobj <- Seurat::CreateSeuratObject(counts = counts, project = basename(path))
  } else if (isTRUE(file.info(path)$isdir)) {
    counts <- Seurat::Read10X(path)
    sobj <- Seurat::CreateSeuratObject(counts = counts, project = basename(path))
  } else {
    stop("unsupported input: ", path)
  }

  sobj <- .ensure_qc_columns(sobj)

  if (isTRUE(apply_filters)) {
    sobj <- .apply_filters(sobj, sample_row)
  }

  sobj
}

run_qc_for_all_samples <- function(sample_info_df, apply_filters = FALSE) {
  stopifnot(is.data.frame(sample_info_df), nrow(sample_info_df) >= 1)
  out <- stats::setNames(vector("list", nrow(sample_info_df)), as.character(sample_info_df$name))
  errs <- character(0)

  for (i in seq_len(nrow(sample_info_df))) {
    row <- sample_info_df[i, , drop = FALSE]
    nm <- as.character(row$name[[1]])
    out[[nm]] <- tryCatch(
      run_qc_for_sample(row, apply_filters = apply_filters),
      error = function(e) { errs <<- c(errs, sprintf("%s -> %s", nm, conditionMessage(e))); NULL }
    )
  }
  attr(out, "errors") <- errs
  out
}

build_qc_objects <- function(sample_info_df) {
  run_qc_for_all_samples(sample_info_df, apply_filters = FALSE)
}
