testthat::test_that("tab pill styling follows active tab without a second geometry owner", {
  css_path <- if (file.exists("Content/www/global.css")) {
    "Content/www/global.css"
  } else {
    "../../Content/www/global.css"
  }
  js_path <- if (file.exists("Content/www/js/global-runtime-ui.js")) {
    "Content/www/js/global-runtime-ui.js"
  } else {
    "../../Content/www/js/global-runtime-ui.js"
  }
  contract_path <- if (file.exists("docs/agents/interface/ANALYSIS_STATE_SYNC_CONTRACT.md")) {
    "docs/agents/interface/ANALYSIS_STATE_SYNC_CONTRACT.md"
  } else {
    "../../docs/agents/interface/ANALYSIS_STATE_SYNC_CONTRACT.md"
  }

  css <- paste(readLines(css_path, warn = FALSE), collapse = "\n")
  js <- paste(readLines(js_path, warn = FALSE), collapse = "\n")
  contract <- paste(readLines(contract_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("background: #ffffff !important;", css, fixed = TRUE))
  testthat::expect_true(grepl("background: #363636 !important;", css, fixed = TRUE))
  testthat::expect_false(grepl("app-tab-pill-track::before", css, fixed = TRUE))
  testthat::expect_false(grepl("syncTabPillIndicators", js, fixed = TRUE))
  testthat::expect_false(grepl("active.offsetLeft", js, fixed = TRUE))
  testthat::expect_true(grepl("one owner: Bootstrap/Shiny active classes", contract, fixed = TRUE))
})
