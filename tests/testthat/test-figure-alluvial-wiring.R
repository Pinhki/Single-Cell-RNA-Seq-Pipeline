.navbar_source_path <- if (file.exists("Content/interface/components/component_navbar.R")) {
  "Content/interface/components/component_navbar.R"
} else {
  "../../Content/interface/components/component_navbar.R"
}

.app_source_path <- if (file.exists("Content/app.R")) {
  "Content/app.R"
} else {
  "../../Content/app.R"
}

.alluvial_page_source_path <- if (file.exists("Content/interface/figures/page_figure_alluvial.R")) {
  "Content/interface/figures/page_figure_alluvial.R"
} else {
  "../../Content/interface/figures/page_figure_alluvial.R"
}

testthat::test_that("Figure alluvial page is wired into navbar and app lazy init", {
  navbar_source <- paste(readLines(.navbar_source_path, warn = FALSE), collapse = "\n")
  app_source <- paste(readLines(.app_source_path, warn = FALSE), collapse = "\n")
  page_source <- paste(readLines(.alluvial_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("figure_alluvial_ui", navbar_source, fixed = TRUE))
  testthat::expect_true(grepl("figure_studio_alluvial", navbar_source, fixed = TRUE))
  testthat::expect_true(grepl("TCR/BCR Alluvial", navbar_source, fixed = TRUE))

  testthat::expect_true(grepl("page_figure_alluvial\\.R", app_source, perl = TRUE))
  testthat::expect_true(grepl("figure_alluvial_ui\\s*=\\s*figure_alluvial_ui", app_source, perl = TRUE))
  testthat::expect_true(grepl("figure_studio_alluvial", app_source, fixed = TRUE))
  testthat::expect_true(grepl("figure_alluvial_server\\(", app_source, perl = TRUE))

  testthat::expect_true(grepl("figure_alluvial_ui\\s*<-\\s*fluidPage\\(", page_source, perl = TRUE))
  testthat::expect_true(grepl("figure_alluvial_server\\s*<-\\s*function\\(", page_source, perl = TRUE))
  testthat::expect_true(grepl("vdj_tcr_clone_size", page_source, fixed = TRUE))
  testthat::expect_true(grepl("vdj_bcr_clone_size", page_source, fixed = TRUE))
})
