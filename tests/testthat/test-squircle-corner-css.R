.custom_css_path <- if (file.exists("Content/www/custom_bslib.css")) {
  "Content/www/custom_bslib.css"
} else {
  "../../Content/www/custom_bslib.css"
}

testthat::test_that("continuous corners use the configured superellipse shape without a body gate", {
  custom_css <- paste(readLines(.custom_css_path, warn = FALSE), collapse = "\n")

  testthat::expect_false(grepl("body\\.use-apple-corners", custom_css, perl = TRUE))

  testthat::expect_true(
    grepl(
      "@supports\\s*\\(corner-shape:\\s*superellipse\\(1\\.414\\)\\)\\s*\\{",
      custom_css,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.wan-squircle\\s*,",
      custom_css,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "corner-shape\\s*:\\s*superellipse\\(1\\.414\\)\\s*;",
      custom_css,
      perl = TRUE
    )
  )
})

testthat::test_that("squircle selector coverage includes shared rounded-rectangle surfaces", {
  custom_css <- paste(readLines(.custom_css_path, warn = FALSE), collapse = "\n")

  expected_selectors <- c(
    ".card-page-card",
    ".wl-side",
    ".app-page .alert",
    ".beta-badge",
    ".plot_area_card_style",
    ".hto-scatter-controls",
    ".hto-pop-grid details",
    ".hto-tsne-opts",
    ".hto-heatmap-box",
    ".hto-method-picker .radio label",
    ".hto-normalize-picker .checkbox label",
    ".analysis-selector-overlay-link",
    ".elbow-missing-warning-card",
    ".so-card",
    ".wl-pdf-preview-resize-box",
    ".welcome-flow-step"
  )

  missing_selectors <- expected_selectors[
    !vapply(
      expected_selectors,
      function(selector) grepl(selector, custom_css, fixed = TRUE),
      logical(1)
    )
  ]

  testthat::expect_equal(
    length(missing_selectors),
    0L,
    info = paste(missing_selectors, collapse = ", ")
  )
})
