`%||%` <- function(a, b) if (is.null(a)) b else a

.contam_extract_counts <- function(sobj, assay = "RNA") {
  if (!inherits(sobj, "Seurat")) stop("Expected Seurat object.")
  assays <- tryCatch(names(sobj@assays), error = function(e) character(0))
  if (!length(assays)) stop("No assays found on Seurat object.")
  if (!assay %in% assays) assay <- assays[[1]]

  args <- list(object = sobj, assay = assay)
  ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
  if ("layer" %in% ga_formals) args$layer <- "counts" else args$slot <- "counts"
  m <- tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
  if (is.null(m)) stop("Failed to read counts from assay: ", assay)
  m
}

.contam_make_sce <- function(sobj, assay = "RNA") {
  m <- .contam_extract_counts(sobj, assay = assay)
  sce <- SingleCellExperiment::SingleCellExperiment(
    assays = list(counts = m),
    colData = S4Vectors::DataFrame(sobj@meta.data)
  )
  rownames(SummarizedExperiment::rowData(sce)) <- rownames(m)
  sce
}

contam_run_decontx_backend <- function(seurat_obj, sample_context = list(), config = list()) {
  if (!requireNamespace("celda", quietly = TRUE)) {
    stop("celda is not installed. Please add celda to runtime bootstrap before using method='DecontX'.")
  }
  if (!requireNamespace("SingleCellExperiment", quietly = TRUE)) {
    stop("SingleCellExperiment is required for DecontX.")
  }

  sce <- .contam_make_sce(seurat_obj, assay = as.character(config$assay %||% "RNA"))

  z <- as.integer(config$z %||% NA_integer_)
  if (is.finite(z) && z > 1) {
    sce <- celda::decontX(sce, z = z, estimateDelta = TRUE, verbose = FALSE)
  } else {
    sce <- celda::decontX(sce, estimateDelta = TRUE, verbose = FALSE)
  }

  corrected <- celda::decontXcounts(sce)
  contam <- as.numeric(SummarizedExperiment::colData(sce)$decontX_contamination %||% rep(NA_real_, ncol(sce)))
  names(contam) <- colnames(sce)

  list(
    corrected_counts = corrected,
    contamination_per_cell = contam,
    contamination_global = mean(contam, na.rm = TRUE),
    method_meta = list(
      method = "DecontX",
      contamination_mean = mean(contam, na.rm = TRUE),
      contamination_median = stats::median(contam, na.rm = TRUE)
    )
  )
}
