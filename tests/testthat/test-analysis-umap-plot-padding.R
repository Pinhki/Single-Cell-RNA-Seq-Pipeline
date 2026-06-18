.helper_source_path <- if (file.exists("Content/interface/analysis/analysis_umap_plot_helpers.R")) {
  "Content/interface/analysis/analysis_umap_plot_helpers.R"
} else {
  "../../Content/interface/analysis/analysis_umap_plot_helpers.R"
}

testthat::test_that("analysis_umap_axis_limits pads embeddings into a square viewport", {
  source(.helper_source_path)

  lims <- analysis_umap_axis_limits(
    x = c(-15, 12),
    y = c(-14, 15)
  )

  testthat::expect_type(lims, "list")
  testthat::expect_true(all(c("x", "y") %in% names(lims)))
  testthat::expect_lt(lims$x[[1]], -15)
  testthat::expect_gt(lims$x[[2]], 12)
  testthat::expect_lt(lims$y[[1]], -14)
  testthat::expect_gt(lims$y[[2]], 15)
  testthat::expect_equal(
    unname(diff(lims$x)),
    29 * 1.10,
    tolerance = 1e-8
  )
  testthat::expect_equal(
    unname(diff(lims$y)),
    29 * 1.10,
    tolerance = 1e-8
  )
})

testthat::test_that("clustering resolution UMAP uses padded axis limits helper", {
  page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
    "Content/interface/analysis/page_analysis.R"
  } else {
    "../../Content/interface/analysis/page_analysis.R"
  }
  page_source <- paste(readLines(page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "analysis_umap_axis_limits\\(",
      page_source,
      perl = TRUE
    )
  )
})
