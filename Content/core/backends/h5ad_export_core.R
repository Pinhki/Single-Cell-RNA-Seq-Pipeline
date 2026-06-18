# Core backend helper for deterministic .h5ad export.

.h5ad_export_require_deps <- function() {
  req <- c("Seurat", "SingleCellExperiment", "SummarizedExperiment", "S4Vectors", "zellkonverter")
  missing <- req[!vapply(req, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))]
  if (length(missing)) {
    stop(
      "Missing dependency for h5ad export: ",
      paste(missing, collapse = ", "),
      ". Please bootstrap packages via Content/run.R."
    )
  }
  invisible(TRUE)
}

.h5ad_export_choose_assay <- function(obj) {
  assays <- tryCatch(Seurat::Assays(obj), error = function(e) character(0))
  assays <- as.character(assays %||% character(0))
  if (!length(assays)) stop("h5ad export failed: no assays available in selected object.")
  pref <- c("RNA", "SCT")
  hit <- pref[pref %in% assays]
  if (length(hit)) return(hit[[1]])
  assays[[1]]
}

.h5ad_export_sanitize_obs <- function(obs, cells) {
  if (is.null(obs) || !is.data.frame(obs)) obs <- data.frame(row.names = cells, stringsAsFactors = FALSE)
  if (!all(cells %in% rownames(obs))) {
    stop("h5ad export failed: metadata rownames do not fully match object cell names.")
  }
  if (!identical(rownames(obs), cells)) {
    obs <- obs[cells, , drop = FALSE]
    rownames(obs) <- cells
  }
  for (nm in colnames(obs)) {
    v <- obs[[nm]]
    if (is.list(v)) {
      obs[[nm]] <- vapply(v, function(x) paste(as.character(x), collapse = ";"), character(1))
    }
  }
  obs
}

.h5ad_export_add_reductions <- function(sce, obj, strict_profile = TRUE) {
  red_names <- tryCatch(Seurat::Reductions(obj), error = function(e) character(0))
  red_names <- as.character(red_names %||% character(0))
  if (!length(red_names)) return(sce)

  for (rn in red_names) {
    emb <- tryCatch(Seurat::Embeddings(obj[[rn]]), error = function(e) NULL)
    if (is.null(emb) || !is.matrix(emb) || ncol(emb) < 2) next
    emb <- emb[, seq_len(min(2L, ncol(emb))), drop = FALSE]
    rownames(emb) <- rownames(emb) %||% colnames(obj)
    idx <- match(colnames(obj), rownames(emb))
    if (any(is.na(idx))) next
    emb <- emb[idx, , drop = FALSE]
    colnames(emb) <- c("dim_1", "dim_2")
    SummarizedExperiment::reducedDim(sce, rn) <- emb
    if (strict_profile && identical(tolower(rn), "umap")) {
      SummarizedExperiment::reducedDim(sce, "X_umap") <- emb
    }
  }
  sce
}

.h5ad_export_add_raw <- function(sce, obj, assay_name) {
  cnt <- tryCatch(
    Seurat::GetAssayData(obj, assay = assay_name, slot = "counts"),
    error = function(e) NULL
  )
  if (is.null(cnt) || !nrow(cnt) || !ncol(cnt)) return(sce)
  raw_se <- SummarizedExperiment::SummarizedExperiment(
    assays = list(X = as.matrix(cnt))
  )
  rownames(raw_se) <- rownames(cnt)
  colnames(raw_se) <- colnames(cnt)
  SingleCellExperiment::altExp(sce, "raw") <- raw_se
  sce
}

.export_to_h5ad <- function(
  seurat_object,
  out_path,
  profile = c("cellxgene_strict", "minimal_generic"),
  object_name = NULL
) {
  .h5ad_export_require_deps()
  if (!inherits(seurat_object, "Seurat")) {
    stop("h5ad export failed: selected entry is not a Seurat object.")
  }
  profile <- match.arg(profile)
  strict_profile <- identical(profile, "cellxgene_strict")

  assay_name <- .h5ad_export_choose_assay(seurat_object)
  cells <- tryCatch(colnames(seurat_object), error = function(e) character(0))
  if (!length(cells)) stop("h5ad export failed: selected object has no cells.")

  sce <- tryCatch(
    Seurat::as.SingleCellExperiment(seurat_object, assay = assay_name),
    error = function(e) {
      stop("h5ad export failed while converting Seurat object: ", conditionMessage(e))
    }
  )
  SummarizedExperiment::colData(sce) <- S4Vectors::DataFrame(
    .h5ad_export_sanitize_obs(
      if (strict_profile) seurat_object@meta.data else seurat_object@meta.data[, 0, drop = FALSE],
      cells = cells
    )
  )

  if (strict_profile) {
    sce <- .h5ad_export_add_reductions(sce, seurat_object, strict_profile = TRUE)
    sce <- .h5ad_export_add_raw(sce, seurat_object, assay_name = assay_name)
  }

  out_dir <- dirname(out_path)
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  out_name <- if (length(object_name)) trimws(as.character(object_name[[1]])) else ""
  out_name <- if (nzchar(out_name)) out_name else "seurat_export"
  if (!endsWith(out_path, ".h5ad")) out_path <- paste0(out_path, ".h5ad")

  tryCatch(
    zellkonverter::writeH5AD(sce, file = out_path, X_name = "X"),
    error = function(e) stop("h5ad export failed while writing file: ", conditionMessage(e))
  )
  if (!file.exists(out_path)) stop("h5ad export failed: writer returned without creating an output file.")
  normalizePath(out_path, winslash = "/", mustWork = TRUE)
}
