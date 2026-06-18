.page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
  "Content/interface/analysis/page_analysis.R"
} else {
  "../../Content/interface/analysis/page_analysis.R"
}

testthat::test_that("final resolution controls stay hidden until a sweep is ready", {
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      paste0(
        "(?s)",
        "conditionalPanel\\(",
        "\\s*condition\\s*=\\s*\"output\\.sweep_ready\"\\s*,",
        "[\\s\\S]*?",
        "h5\\(ANALYSIS_UI_TEXT\\$t_btn_apply_final_resolution\\)",
        "[\\s\\S]*?",
        "uiOutput\\(\"final_res_picker_ui\"\\)",
        "[\\s\\S]*?",
        "actionButton\\(",
        "\"apply_final_res_btn\""
      ),
      page_source,
      perl = TRUE
    )
  )
})

testthat::test_that("clustertree and umap layout switches to stacked mode for large sweeps", {
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl(
    "uiOutput\\(\"clustertree_umap_layout_ui\"\\)",
    page_source,
    perl = TRUE
  ))

  testthat::expect_true(grepl(
    "\\.cluster_sweep_resolution_count\\s*<-\\s*function\\(cache\\)",
    page_source,
    perl = TRUE
  ))

  testthat::expect_true(grepl(
    "\\.clustertree_umap_layout_mode\\s*<-\\s*function\\(cache\\s*,\\s*threshold\\s*=\\s*10L\\)",
    page_source,
    perl = TRUE
  ))

  testthat::expect_true(grepl(
    "if\\s*\\(\\.cluster_sweep_resolution_count\\(cache\\)\\s*>\\s*as\\.integer\\(threshold\\)\\)\\s*\"stacked\"\\s*else\\s*\"side_by_side\"",
    page_source,
    perl = TRUE
  ))
})
