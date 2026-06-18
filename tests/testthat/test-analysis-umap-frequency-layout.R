.helper_source_path <- if (file.exists("Content/interface/analysis/analysis_umap_frequency_helpers.R")) {
  "Content/interface/analysis/analysis_umap_frequency_helpers.R"
} else {
  "../../Content/interface/analysis/analysis_umap_frequency_helpers.R"
}
source(.helper_source_path)

testthat::test_that("analysis_umap_frequency_plot_height_px grows with legend rows and grouped bars", {
  baseline <- analysis_umap_frequency_plot_height_px(
    cluster_count = 4,
    container_width = 1050,
    outer_n = 1,
    inner_n = 1
  )
  grouped <- analysis_umap_frequency_plot_height_px(
    cluster_count = 22,
    container_width = 760,
    outer_n = 5,
    inner_n = 3
  )

  testthat::expect_equal(baseline, 620L)
  testthat::expect_gt(grouped, baseline)
  testthat::expect_gte(grouped, 700L)
})

testthat::test_that("analysis page frequency card no longer hides vertical overflow", {
  page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
    "Content/interface/analysis/page_analysis.R"
  } else {
    "../../Content/interface/analysis/page_analysis.R"
  }
  page_source <- paste(readLines(page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_false(
    grepl(
      "\\.umap-cluster-freq-card\\s*\\{[^}]*overflow-y\\s*:\\s*hidden",
      page_source,
      perl = TRUE
    )
  )
})

testthat::test_that("plotting pages override internal tab bar top margin", {
  global_css_path <- if (file.exists("Content/www/global.css")) {
    "Content/www/global.css"
  } else {
    "../../Content/www/global.css"
  }
  global_css <- paste(readLines(global_css_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "\\.plotting-page\\s+\\.app-tabs-wrap\\s*>\\s*\\.nav\\.nav-tabs[^{]*\\{[^}]*margin-top\\s*:\\s*0",
      global_css,
      perl = TRUE
    )
  )
})
