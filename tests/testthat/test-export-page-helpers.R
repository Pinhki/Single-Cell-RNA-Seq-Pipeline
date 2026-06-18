.load_export_helper_env <- function() {
  page_source_path <- if (file.exists("Content/interface/export/page_export.R")) {
    "Content/interface/export/page_export.R"
  } else {
    "../../Content/interface/export/page_export.R"
  }

  lines <- readLines(page_source_path, warn = FALSE)
  cut <- grep("# ---------- UI ----------", lines)[1] - 1
  code <- paste(lines[seq_len(cut)], collapse = "\n")

  helper_env <- new.env(parent = .GlobalEnv)
  library(shiny)
  eval(parse(text = code), envir = helper_env)
  helper_env
}

testthat::test_that("export helper rejects invalid registry shapes with a clear error", {
  helper_env <- .load_export_helper_env()
  shared_data <- new.env(parent = emptyenv())
  shared_data$all_seurat_objects <- data.frame(sample_a = 1, stringsAsFactors = FALSE)

  testthat::expect_error(
    helper_env$.export_selected_entry(shared_data, "sample_a"),
    "registry is not a valid object list"
  )
})

testthat::test_that("export helper resolves valid choices and catches stale selections", {
  helper_env <- .load_export_helper_env()
  shared_data <- new.env(parent = emptyenv())
  sample_entry <- list(obj = "placeholder")
  shared_data$all_seurat_objects <- list(sample_a = sample_entry, sample_b = list(obj = "other"))

  testthat::expect_equal(
    helper_env$.export_object_choices(shared_data),
    c("sample_a", "sample_b")
  )

  testthat::expect_identical(
    helper_env$.export_selected_entry(shared_data, "sample_a"),
    sample_entry
  )

  testthat::expect_error(
    helper_env$.export_selected_entry(shared_data, "missing_sample"),
    "Selected dataset is no longer available"
  )
})
