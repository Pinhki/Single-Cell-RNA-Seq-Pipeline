.helper_source_path <- if (file.exists("Content/interface/figures/figure_color_popup_helpers.R")) {
  "Content/interface/figures/figure_color_popup_helpers.R"
} else {
  "../../Content/interface/figures/figure_color_popup_helpers.R"
}
source(.helper_source_path)

testthat::test_that("figure split choices include none option and exclude selected column", {
  meta <- data.frame(
    condition = c("A", "B"),
    orig.ident = c("sample_1", "sample_2"),
    batch = c("X", "Y"),
    stringsAsFactors = FALSE
  )

  choices <- figure_split_choices(meta, exclude = "orig.ident")

  testthat::expect_equal(unname(choices[[1]]), "__none__")
  testthat::expect_true("condition" %in% unname(choices))
  testthat::expect_true("batch" %in% unname(choices))
  testthat::expect_false("orig.ident" %in% unname(choices))
})

testthat::test_that("figure split vars normalize none and duplicate selections", {
  vars <- figure_normalize_split_vars(column_split = "sample", row_split = "sample")

  testthat::expect_equal(vars$column_split, "sample")
  testthat::expect_null(vars$row_split)
  testthat::expect_equal(figure_facet_mode(NULL, "batch"), "row")
})

testthat::test_that("figure dark modal dialog marks modal shell for figure pages only", {
  modal <- figure_dark_modal_dialog(
    title = "Figure Modal",
    easyClose = TRUE,
    shiny::tags$div("body")
  )

  html <- htmltools::renderTags(modal)$html

  testthat::expect_match(html, "figure-modal-dark-dialog")
  testthat::expect_match(html, "Figure Modal")
})

testthat::test_that("figure assets include dark modal shell styling", {
  html <- htmltools::renderTags(figure_busy_spinner_assets)$html

  testthat::expect_match(html, "figure-modal-dark-dialog")
  testthat::expect_match(html, "modal-content")
  testthat::expect_match(html, "#111111")
  testthat::expect_false(grepl("#0f172a", html, fixed = TRUE))
  testthat::expect_false(grepl("#111827", html, fixed = TRUE))
})
