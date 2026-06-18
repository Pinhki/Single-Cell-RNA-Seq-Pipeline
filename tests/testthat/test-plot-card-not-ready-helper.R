.shared_helper_path <- if (file.exists("Content/interface/shared/plot_card_state_helpers.R")) {
  "Content/interface/shared/plot_card_state_helpers.R"
} else {
  "../../Content/interface/shared/plot_card_state_helpers.R"
}

testthat::test_that("plot_card_not_ready_ui returns standardized placeholder markup", {
  source(.shared_helper_path)
  or_else <- function(x, y) if (is.null(x)) y else x

  ui <- plot_card_not_ready_ui("Run first", height_px = 420)

  testthat::expect_s3_class(ui, "shiny.tag")
  testthat::expect_match(or_else(ui$attribs$class, ""), "plot-card-not-ready")
  testthat::expect_match(or_else(ui$attribs$class, ""), "anno-empty-state")
  testthat::expect_match(or_else(ui$attribs$style, ""), "height: 420px;")
})

testthat::test_that("analysis differential and annotation cards use standardized helper/ui wrappers", {
  page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
    "Content/interface/analysis/page_analysis.R"
  } else {
    "../../Content/interface/analysis/page_analysis.R"
  }
  page_source <- paste(readLines(page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("output\\$jjvolcano_plot_ui\\s*<-\\s*renderUI\\(", page_source, perl = TRUE))
  testthat::expect_true(grepl("output\\$pb_umap_plot_ui\\s*<-\\s*renderUI\\(", page_source, perl = TRUE))
  testthat::expect_true(grepl("output\\$pb_volcano_grid_plot_ui\\s*<-\\s*renderUI\\(", page_source, perl = TRUE))
  testthat::expect_true(grepl("output\\$pb_custom_volcano_plot_ui\\s*<-\\s*renderUI\\(", page_source, perl = TRUE))
  testthat::expect_true(grepl("plot_card_not_ready_ui\\(", page_source, perl = TRUE))
})
