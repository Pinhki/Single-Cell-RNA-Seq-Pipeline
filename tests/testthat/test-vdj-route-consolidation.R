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

.vdj_page_source_path <- if (file.exists("Content/interface/qc/page_vdj.R")) {
  "Content/interface/qc/page_vdj.R"
} else {
  "../../Content/interface/qc/page_vdj.R"
}

testthat::test_that("VDJ routing is consolidated onto the QC page", {
  navbar_source <- paste(readLines(.navbar_source_path, warn = FALSE), collapse = "\n")
  app_source <- paste(readLines(.app_source_path, warn = FALSE), collapse = "\n")
  vdj_page_source <- paste(readLines(.vdj_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_false(grepl("vdj_reclustering_tab", navbar_source, fixed = TRUE))
  testthat::expect_false(grepl("VDJ Reclustering", navbar_source, fixed = TRUE))

  testthat::expect_false(grepl("page_vdj_reclustering\\.R", app_source, perl = TRUE))
  testthat::expect_false(grepl("vdj_reclustering_ui\\s*=", app_source, perl = TRUE))
  testthat::expect_false(grepl("identical\\(tab,\\s*\"vdj_reclustering_tab\"\\)", app_source, perl = TRUE))
  testthat::expect_false(grepl("vdj_reclustering_tab\\s*=", app_source, perl = TRUE))

  testthat::expect_true(grepl("vdj_show_diagnostics_btn", vdj_page_source, fixed = TRUE))
  testthat::expect_true(grepl("VDJ/Barcode Diagnostics", vdj_page_source, fixed = TRUE))
  testthat::expect_true(grepl("vdj_diag_table", vdj_page_source, fixed = TRUE))
  testthat::expect_true(grepl("vdj_sample_table", vdj_page_source, fixed = TRUE))
  testthat::expect_true(grepl("observeEvent\\(input\\$vdj_show_diagnostics_btn,\\s*\\{", vdj_page_source, perl = TRUE))
  testthat::expect_true(grepl("showModal\\(", vdj_page_source, perl = TRUE))
  testthat::expect_true(grepl("modalDialog\\(", vdj_page_source, perl = TRUE))
})
