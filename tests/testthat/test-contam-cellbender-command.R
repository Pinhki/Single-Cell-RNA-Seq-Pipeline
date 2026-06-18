.load_contam_cellbender_env <- function() {
  src <- if (file.exists("Content/core/backends/contam_cellbender_backend.R")) {
    "Content/core/backends/contam_cellbender_backend.R"
  } else {
    "../../Content/core/backends/contam_cellbender_backend.R"
  }
  env <- new.env(parent = .GlobalEnv)
  sys.source(src, envir = env)
  env
}

testthat::test_that("CellBender command builder enforces GPU policy", {
  env <- .load_contam_cellbender_env()

  env$contam_detect_gpu_available <- function() FALSE

  testthat::expect_error(
    env$contam_build_cellbender_command(
      raw_h5_path = "raw.h5",
      output_h5_path = "output.h5",
      config = list(use_cuda = TRUE, allow_cpu_fallback = FALSE)
    ),
    "GPU was not detected"
  )

  cmd <- env$contam_build_cellbender_command(
    raw_h5_path = "raw.h5",
    output_h5_path = "output.h5",
    config = list(use_cuda = TRUE, allow_cpu_fallback = TRUE, cpu_threads = 6)
  )

  testthat::expect_true(is.list(cmd))
  testthat::expect_equal(cmd$executable, "cellbender")
  testthat::expect_true(any(cmd$args == "--cpu-threads"))
  testthat::expect_false(any(cmd$args == "--cuda"))
})
