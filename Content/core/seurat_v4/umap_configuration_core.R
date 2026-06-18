# analysis_tab_b_core.R
# Tab B: UMAP / tSNE configuration + preview plot

`%||%` <- function(a, b) if (is.null(a)) b else a
.scalar_chr <- function(x, default = "") {
  if (is.null(x) || length(x) == 0) return(default)
  y <- as.character(x)
  if (!length(y)) return(default)
  y <- y[!is.na(y)]
  if (!length(y)) return(default)
  y[[1]]
}

core_analysis_tab_b_compute_plot <- function(sobj, params, persist = FALSE, progress_cb = NULL) {
  stopifnot(inherits(sobj, "Seurat"))
  .emit_progress <- function(text = NULL, pct = NULL) {
    if (is.function(progress_cb)) {
      try(progress_cb(text = text, pct = pct), silent = TRUE)
    }
  }

  if ("umap_cfg" %in% names(sobj@reductions)) {
    old_key <- tryCatch(as.character(sobj@reductions[["umap_cfg"]]@key), error = function(e) "")
    if (tolower(old_key) %in% c("umcfg_", "umap_cfg_")) {
      try(sobj@reductions[["umap_cfg"]]@key <- "umapcfg_", silent = TRUE)
    }
  }
  if ("tsne_cfg" %in% names(sobj@reductions)) {
    old_key <- tryCatch(as.character(sobj@reductions[["tsne_cfg"]]@key), error = function(e) "")
    if (tolower(old_key) %in% c("tscfg_", "tsne_cfg_")) {
      try(sobj@reductions[["tsne_cfg"]]@key <- "tsnecfg_", silent = TRUE)
    }
  }

  fmt <- toupper(as.character(params$plot_format %||% "UMAP"))
  dims <- as.integer(params$dims %||% 30)
  dims <- max(2L, dims)
  seed <- as.integer(params$seed %||% 42L)
  md_cols <- tryCatch(colnames(sobj@meta.data), error = function(e) character(0))
  color_by <- .scalar_chr(params$color_by %||% "", default = "")
  split_by <- .scalar_chr(params$split_by %||% "", default = "")
  if (!nzchar(color_by) || !(color_by %in% md_cols)) color_by <- NULL
  if (!nzchar(split_by) || identical(split_by, "__none__") || !(split_by %in% md_cols)) split_by <- NULL
  sobj_compute <- sobj

  if (!"pca" %in% tolower(names(sobj_compute@reductions))) {
    sobj_compute <- Seurat::RunPCA(sobj_compute, npcs = max(30L, dims), verbose = FALSE)
  }
  pca_n <- suppressWarnings(as.integer(tryCatch(ncol(Seurat::Embeddings(sobj_compute, "pca")), error = function(e) NA_integer_)))
  if (!is.finite(pca_n) || is.na(pca_n) || pca_n < 2L) {
    stop("PCA embedding is missing or has fewer than 2 dimensions. Please run/generate PCA first.")
  }
  dims <- as.integer(max(2L, min(dims, pca_n)))

  .param_signature <- list(
    fmt = fmt,
    dims = dims,
    seed = seed,
    umap_neighbors = as.integer(params$umap_neighbors %||% 30),
    umap_min_dist = as.numeric(params$umap_min_dist %||% 0.3),
    umap_spread = as.numeric(params$umap_spread %||% 1.0),
    tsne_perplexity = as.numeric(params$tsne_perplexity %||% 30),
    tsne_theta = as.numeric(params$tsne_theta %||% 0.5),
    tsne_eta = as.numeric(params$tsne_eta %||% 200),
    tsne_iter = as.integer(params$tsne_iter %||% 1000)
  )
  .same_signature <- function(obj, reduction_name, sig) {
    if (!reduction_name %in% names(obj@reductions)) return(FALSE)
    old <- tryCatch(obj@reductions[[reduction_name]]@misc$cfg_signature, error = function(e) NULL)
    isTRUE(identical(old, sig))
  }

  umap_red_name <- if (isTRUE(persist)) sprintf("umap_pca_%d", dims) else "umap_cfg"
  tsne_red_name <- if (isTRUE(persist)) sprintf("tsne_pca_%d", dims) else "tsne_cfg"
  .emit_progress(sprintf("Computing UMAP under PCA_%d...", dims), 20)
  if (!.same_signature(sobj_compute, umap_red_name, .param_signature)) {
    sobj_compute <- Seurat::RunUMAP(
      object = sobj_compute,
      dims = seq_len(dims),
      reduction.name = umap_red_name,
      reduction.key = if (isTRUE(persist)) "UMAPPCA_" else "umapcfg_",
      seed.use = seed,
      n.neighbors = as.integer(params$umap_neighbors %||% 30),
      min.dist = as.numeric(params$umap_min_dist %||% 0.3),
      spread = as.numeric(params$umap_spread %||% 1.0),
      verbose = FALSE
    )
    sobj_compute@reductions[[umap_red_name]]@misc$cfg_signature <- .param_signature
  }
  .emit_progress(sprintf("Computing tSNE under PCA_%d...", dims), 65)
  if (!.same_signature(sobj_compute, tsne_red_name, .param_signature)) {
    sobj_compute <- Seurat::RunTSNE(
      object = sobj_compute,
      dims = seq_len(dims),
      reduction.name = tsne_red_name,
      reduction.key = if (isTRUE(persist)) "TSNEPCA_" else "tsnecfg_",
      seed.use = seed,
      perplexity = as.numeric(params$tsne_perplexity %||% 30),
      theta = as.numeric(params$tsne_theta %||% 0.5),
      eta = as.numeric(params$tsne_eta %||% 200),
      max_iter = as.integer(params$tsne_iter %||% 1000),
      check_duplicates = FALSE,
      verbose = FALSE
    )
    sobj_compute@reductions[[tsne_red_name]]@misc$cfg_signature <- .param_signature
  }
  .emit_progress(sprintf("Finalizing embeddings for PCA_%d...", dims), 95)
  red_name <- if (fmt == "TSNE") tsne_red_name else umap_red_name

  plt <- NULL
  if (!isTRUE(persist)) {
    plt <- if (!is.null(color_by) && nzchar(color_by) && color_by %in% colnames(sobj@meta.data)) {
      Seurat::DimPlot(sobj_compute, reduction = red_name, group.by = color_by, split.by = split_by)
    } else {
      Seurat::DimPlot(sobj_compute, reduction = red_name, split.by = split_by)
    }
  }

  list(object = sobj_compute, plot = plt, reduction = red_name)
}
