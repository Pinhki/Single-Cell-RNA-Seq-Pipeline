# analysis_tab_c_core.R
# Tab C: clustering resolution (Seurat v5 variant)

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
  if (!exists("run_main_analysis", envir = env, mode = "function", inherits = FALSE)) {
    stop("Missing required function in backend script: run_main_analysis")
  }
  env
}

core_analysis_tab_c_run_main_analysis <- function(seurat_obj, analysis_params) {
  backend <- .analysis_v5_source_main()
  backend$run_main_analysis(seurat_obj = seurat_obj, analysis_params = analysis_params)
}

core_analysis_tab_c_note <- function() {
  "Tab C core wrapper active."
}
