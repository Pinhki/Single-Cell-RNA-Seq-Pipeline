`%||%` <- function(a, b) if (is.null(a)) b else a

.contam_extract_rna_counts <- function(sobj, assay = "RNA") {
  if (!inherits(sobj, "Seurat")) stop("Expected a Seurat object.")
  assays <- tryCatch(names(sobj@assays), error = function(e) character(0))
  if (!assay %in% assays) {
    if (!length(assays)) stop("No assays found on Seurat object.")
    assay <- assays[[1]]
  }
  args <- list(object = sobj, assay = assay)
  ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
  if ("layer" %in% ga_formals) {
    args$layer <- "counts"
  } else {
    args$slot <- "counts"
  }
  m <- tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
  if (is.null(m) || !inherits(m, "Matrix")) stop("Unable to extract count matrix from Seurat object.")
  m
}

.contam_pick_clusters <- function(sobj) {
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !is.data.frame(md) || !nrow(md)) return(NULL)
  cluster_col <- NULL
  if ("seurat_clusters" %in% colnames(md)) cluster_col <- "seurat_clusters"
  if (is.null(cluster_col)) {
    res_cols <- grep("(snn|wsnn|nn)[._]res", colnames(md), ignore.case = TRUE, value = TRUE)
    if (length(res_cols)) cluster_col <- res_cols[[length(res_cols)]]
  }
  if (is.null(cluster_col)) return(NULL)
  vals <- as.character(md[[cluster_col]])
  names(vals) <- rownames(md)
  vals
}

.contam_read_10x_any <- function(path) {
  if (!nzchar(path) || !file.exists(path)) stop("Input path not found: ", path)
  ext <- tolower(tools::file_ext(path))
  if (ext %in% c("h5", "hdf5")) {
    x <- Seurat::Read10X_h5(path)
  } else if (isTRUE(file.info(path)$isdir)) {
    x <- Seurat::Read10X(path)
  } else {
    stop("Unsupported 10x input path: ", path)
  }
  if (is.list(x)) {
    nms <- tolower(names(x) %||% character(0))
    ridx <- which(grepl("gene expression|rna", nms))
    if (!length(ridx)) ridx <- 1
    return(x[[ridx[[1]]]])
  }
  x
}

contam_run_soupx_backend <- function(seurat_obj, sample_context = list(), config = list()) {
  if (!requireNamespace("SoupX", quietly = TRUE)) {
    stop("SoupX is not installed. Please add SoupX to runtime bootstrap before using method='SoupX'.")
  }
  raw_path <- as.character(sample_context$raw_matrix_path %||% "")
  filt_path <- as.character(sample_context$filtered_matrix_path %||% "")
  if (!nzchar(raw_path) || !nzchar(filt_path)) {
    stop("SoupX requires both raw_matrix_path and filtered_matrix_path.")
  }

  tod <- .contam_read_10x_any(raw_path)
  toc <- .contam_read_10x_any(filt_path)

  sc <- SoupX::SoupChannel(tod = tod, toc = toc)

  cluster_vals <- .contam_pick_clusters(seurat_obj)
  if (!is.null(cluster_vals) && length(cluster_vals)) {
    overlap <- intersect(colnames(toc), names(cluster_vals))
    if (length(overlap)) {
      sc <- SoupX::setClusters(sc, setNames(cluster_vals[overlap], overlap))
    }
  }

  if (isTRUE(config$use_auto_est %||% TRUE)) {
    sc <- SoupX::autoEstCont(sc, doPlot = FALSE)
  } else {
    rho <- as.numeric(config$contamination_fraction %||% NA_real_)
    if (!is.finite(rho) || rho <= 0 || rho >= 1) {
      stop("Invalid contamination_fraction for SoupX; expected value in (0,1).")
    }
    sc <- SoupX::setContaminationFraction(sc, contaminationFraction = rho)
  }

  corrected <- SoupX::adjustCounts(sc, roundToInt = TRUE)
  est <- tryCatch(sc$fit$rhoEst, error = function(e) NA_real_)

  list(
    corrected_counts = corrected,
    contamination_per_cell = NULL,
    contamination_global = as.numeric(est %||% NA_real_),
    method_meta = list(
      method = "SoupX",
      raw_matrix_path = raw_path,
      filtered_matrix_path = filt_path,
      rho_estimate = as.numeric(est %||% NA_real_)
    )
  )
}
