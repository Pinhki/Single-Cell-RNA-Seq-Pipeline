## ---- seurat4/qc_seurat.R -----------------------------------------------
suppressPackageStartupMessages({
  library(Seurat)
  library(Matrix)
})

.msg <- function(...) message("[qc_seurat] ", paste0(..., collapse = ""))

# --- helpers --------------------------------------------------------------

.get_path <- function(sample_row) {
  # Prefer a 'path' column; otherwise use 'name' as the path.
  p <- if ("path" %in% names(sample_row)) sample_row$path[[1]] else sample_row$name[[1]]
  p <- as.character(p)
  if (!nzchar(p) || !file.exists(p)) {
    stop(sprintf("file not found: %s", p))
  }
  normalizePath(p, winslash = "/")
}

.ensure_qc_columns <- function(sobj) {
  # nFeature_RNA / nCount_RNA (Seurat normally creates these, but be safe)
  if (!"nFeature_RNA" %in% names(sobj@meta.data)) {
    sobj[["nFeature_RNA"]] <- Matrix::colSums(GetAssayData(sobj, slot = "counts") > 0)
  }
  if (!"nCount_RNA" %in% names(sobj@meta.data)) {
    sobj[["nCount_RNA"]] <- Matrix::colSums(GetAssayData(sobj, slot = "counts"))
  }
  
  # percent.mt — compute if missing (handles human "MT-" and mouse "mt-")
  if (!any(c("percent.mt", "percent.mito", "mito") %in% names(sobj@meta.data))) {
    rn <- rownames(sobj)
    has_MT <- any(grepl("^MT-", rn))
    has_mt <- any(grepl("^mt-", rn))
    pat    <- if (has_MT && !has_mt) "^MT-" else if (has_mt && !has_MT) "^mt-" else "^(MT-|mt-)"
    sobj[["percent.mt"]] <- PercentageFeatureSet(sobj, pattern = pat)
  }
  
  sobj
}

.apply_filters <- function(sobj, sample_row) {
  md <- sobj@meta.data
  nf <- md[["nFeature_RNA"]]
  nc <- md[["nCount_RNA"]]
  mt <- md[["percent.mt"]] %||% md[["percent.mito"]] %||% md[["mito"]]
  
  keep <- rep(TRUE, ncol(sobj))
  
  if (!is.null(sample_row$min_features))   keep <- keep & nf >= as.numeric(sample_row$min_features)
  if (!is.null(sample_row$max_features))   keep <- keep & nf <= as.numeric(sample_row$max_features)
  if (!is.null(sample_row$min_umi_counts)) keep <- keep & nc >= as.numeric(sample_row$min_umi_counts)
  if (!is.null(sample_row$max_umi_counts)) keep <- keep & nc <= as.numeric(sample_row$max_umi_counts)
  if (!is.null(sample_row$max_mt_percent) && !is.null(mt)) {
    keep <- keep & mt <= as.numeric(sample_row$max_mt_percent)
  }
  
  subset(sobj, cells = colnames(sobj)[keep])
}

`%||%` <- function(a, b) if (is.null(a)) b else a

# --- main API -------------------------------------------------------------

# Build ONE Seurat object for a row in the sample sheet.
# NOTE: we no longer try to "locate" files; the path must already be correct.
run_qc_for_sample <- function(sample_row, apply_filters = FALSE) {
  stopifnot(is.data.frame(sample_row), nrow(sample_row) == 1)
  
  path <- .get_path(sample_row)
  ext  <- tolower(tools::file_ext(path))
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
  } else if (ext == "h5") {
    counts <- Seurat::Read10X_h5(path)
    sobj   <- Seurat::CreateSeuratObject(counts = counts, project = basename(path))
  } else if (isTRUE(file.info(path)$isdir)) {
    counts <- Seurat::Read10X(path)
    sobj   <- Seurat::CreateSeuratObject(counts = counts, project = basename(path))
  } else {
    stop("unsupported input: ", path)
  }
  
  sobj <- .ensure_qc_columns(sobj)
  
  if (isTRUE(apply_filters)) {
    sobj <- .apply_filters(sobj, sample_row)
  }
  
  sobj
}

# Compatibility wrapper used by the QC page
run_qc_for_all_samples <- function(sample_info_df, apply_filters = FALSE) {
  stopifnot(is.data.frame(sample_info_df), nrow(sample_info_df) >= 1)
  out <- setNames(vector("list", nrow(sample_info_df)),
                  as.character(sample_info_df$name))
  errs <- character(0)
  
  for (i in seq_len(nrow(sample_info_df))) {
    row <- sample_info_df[i, , drop = FALSE]
    nm  <- as.character(row$name[[1]])
    out[[nm]] <- tryCatch(
      run_qc_for_sample(row, apply_filters = apply_filters),
      error = function(e) { errs <<- c(errs, sprintf("%s → %s", nm, conditionMessage(e))); NULL }
    )
  }
  attr(out, "errors") <- errs
  out
}

# Convenience used by the QC server to preload *unfiltered* objects
build_qc_objects <- function(sample_info_df) {
  run_qc_for_all_samples(sample_info_df, apply_filters = FALSE)
}