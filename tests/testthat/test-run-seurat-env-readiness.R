.load_run_seurat_helper_env <- function() {
  run_source_path <- if (file.exists("Content/run.R")) {
    "Content/run.R"
  } else {
    "../../Content/run.R"
  }

  lines <- readLines(run_source_path, warn = FALSE)
  start <- grep("^\\.seurat_env_requirements <- function", lines)[1]
  end <- grep("^#' Install/Load Seurat v4 into an isolated library", lines)[1] - 1L
  code <- paste(lines[start:end], collapse = "\n")
  exprs <- parse(text = code)

  helper_env <- new.env(parent = .GlobalEnv)
  for (expr in exprs) {
    eval(expr, envir = helper_env)
  }
  helper_env
}

testthat::test_that("Seurat v5 readiness rejects stale sctransform", {
  helper_env <- .load_run_seurat_helper_env()

  ready <- helper_env$.seurat_env_is_ready(
    major = 5L,
    seurat_version = "5.0.3",
    seuratobject_version = "5.0.2",
    sctransform_version = "0.4.0"
  )

  testthat::expect_false(ready)
})

testthat::test_that("Seurat v5 readiness accepts compatible sctransform", {
  helper_env <- .load_run_seurat_helper_env()

  ready <- helper_env$.seurat_env_is_ready(
    major = 5L,
    seurat_version = "5.0.3",
    seuratobject_version = "5.0.2",
    sctransform_version = "0.4.1"
  )

  testthat::expect_true(ready)
})
