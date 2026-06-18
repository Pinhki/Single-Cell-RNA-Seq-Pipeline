# analysis_tab_c_core.R
# Tab C: clustering resolution

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
  if (!exists("run_main_analysis", envir = env, mode = "function", inherits = FALSE)) {
    stop("Missing required function in backend script: run_main_analysis")
  }
  env
}

core_analysis_tab_c_run_main_analysis <- function(seurat_obj, analysis_params) {
  backend <- .analysis_v4_source_main()
  backend$run_main_analysis(seurat_obj = seurat_obj, analysis_params = analysis_params)
}

core_analysis_tab_c_note <- function() {
  "Tab C core wrapper active."
}
