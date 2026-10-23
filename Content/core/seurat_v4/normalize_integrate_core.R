# analysis_tab_a_core.R
# Tab A: normalize / integrate

.analysis_v4_backend_script <- function() {
  candidates <- c(
    file.path("seurat4", "main_analysis_seurat.R"),
    file.path("Content", "seurat4", "main_analysis_seurat.R"),
    file.path("..", "..", "seurat4", "main_analysis_seurat.R"),
    file.path("..", "..", "..", "Content", "seurat4", "main_analysis_seurat.R")
  )
  hit <- candidates[file.exists(candidates)][1]
  if (is.na(hit) || !nzchar(hit)) {
    stop("Cannot locate seurat4/main_analysis_seurat.R from current working directory.")
  }
  hit
}

.analysis_v4_source_main <- function() {
  src <- .analysis_v4_backend_script()
  env <- new.env(parent = .GlobalEnv)
  source(src, local = env, chdir = TRUE)
  for (fn in c("run_normalization", "run_integration")) {
    if (!exists(fn, envir = env, mode = "function", inherits = FALSE)) {
      stop("Missing required function in backend script: ", fn)
    }
  }
  env
}

core_analysis_tab_a_run_normalization <- function(seurat_obj, method = "SCT") {
  backend <- .analysis_v4_source_main()
  backend$run_normalization(seurat_obj = seurat_obj, method = method)
}

core_analysis_tab_a_run_integration <- function(
  seurat_obj,
  method = "CCA",
  integrate_by = "batch",
  barcode_suffix = list(enabled = FALSE, delimiter = "_"),
  progress_cb = NULL,
  reference_datasets = character(0)
) {
  backend <- .analysis_v4_source_main()
  backend$run_integration(
    seurat_obj = seurat_obj,
    method = method,
    integrate_by = integrate_by,
    barcode_suffix = barcode_suffix,
    progress_cb = progress_cb,
    reference_datasets = reference_datasets
  )
}
