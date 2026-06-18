.load_contam_core_env <- function() {
  src <- if (file.exists("Content/core/seurat_v4/contamination_core.R")) {
    "Content/core/seurat_v4/contamination_core.R"
  } else {
    "../../Content/core/seurat_v4/contamination_core.R"
  }
  env <- new.env(parent = .GlobalEnv)
  sys.source(src, envir = env)
  env
}

testthat::test_that("core_contam_detect_inputs finds Cell Ranger raw/filtered assets", {
  env <- .load_contam_core_env()

  root <- file.path(tempdir(), paste0("contam_detect_", as.integer(Sys.time())))
  outs <- file.path(root, "SampleA", "outs")
  dir.create(outs, recursive = TRUE, showWarnings = FALSE)
  file.create(file.path(outs, "raw_feature_bc_matrix.h5"))
  file.create(file.path(outs, "filtered_feature_bc_matrix.h5"))

  row <- data.frame(name = "SampleA", path = file.path(outs, "filtered_feature_bc_matrix.h5"), stringsAsFactors = FALSE)
  det <- env$core_contam_detect_inputs(row)

  testthat::expect_true(det$has_raw)
  testthat::expect_true(det$has_filtered)
  testthat::expect_true("CellBender" %in% det$feasible_methods)
  testthat::expect_true("SoupX" %in% det$feasible_methods)
  testthat::expect_true("DecontX" %in% det$feasible_methods)
})
