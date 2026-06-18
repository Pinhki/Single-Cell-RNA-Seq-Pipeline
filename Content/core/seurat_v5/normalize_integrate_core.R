# analysis_tab_a_core.R
# Tab A: normalize / integrate (Seurat v5 variant)

.analysis_v5_backend_script <- function() {
  candidates <- c(
    file.path("seurat5", "main_analysis_seurat.R"),
    file.path("seurat4", "main_analysis_seurat.R"),
    file.path("Content", "seurat5", "main_analysis_seurat.R"),
    file.path("Content", "seurat4", "main_analysis_seurat.R"),
    file.path("..", "..", "seurat5", "main_analysis_seurat.R"),
    file.path("..", "..", "seurat4", "main_analysis_seurat.R"),
    file.path("..", "..", "..", "Content", "seurat5", "main_analysis_seurat.R"),
    file.path("..", "..", "..", "Content", "seurat4", "main_analysis_seurat.R")
  )
  hit <- candidates[file.exists(candidates)][1]
  if (is.na(hit) || !nzchar(hit)) {
    stop("No analysis backend script found (expected seurat5/main_analysis_seurat.R or seurat4/main_analysis_seurat.R).")
  }
  hit
}

.analysis_v5_source_main <- function() {
  src <- .analysis_v5_backend_script()
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
  backend <- .analysis_v5_source_main()
  backend$run_normalization(seurat_obj = seurat_obj, method = method)
}

core_analysis_tab_a_run_integration <- function(
  seurat_obj,
  method = "CCA",
  integrate_by = "batch",
  barcode_suffix = list(enabled = FALSE, delimiter = "_")
) {
  backend <- .analysis_v5_source_main()
  backend$run_integration(
    seurat_obj = seurat_obj,
    method = method,
    integrate_by = integrate_by,
    barcode_suffix = barcode_suffix
  )
}
