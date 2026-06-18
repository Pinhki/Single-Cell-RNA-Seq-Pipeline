.page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
  "Content/interface/analysis/page_analysis.R"
} else {
  "../../Content/interface/analysis/page_analysis.R"
}

testthat::test_that("analysis elbow preview render is driven by a dedicated snapshot cache", {
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "analysis_active_elbow_preview\\s*<-\\s*reactiveVal\\(",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "output\\$elbow_ready\\s*<-\\s*reactive\\(\\{[\\s\\S]*?analysis_active_elbow_preview\\(\\)",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "output\\$prep_elbow_plot\\s*<-\\s*renderPlot\\(\\{[\\s\\S]*?snapshot\\s*<-\\s*analysis_active_elbow_preview\\(\\)",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_false(
    grepl(
      "output\\$prep_elbow_plot\\s*<-\\s*renderPlot\\(\\{[\\s\\S]*?\\.analysis_build_elbow_plot\\(",
      page_source,
      perl = TRUE
    )
  )
})
