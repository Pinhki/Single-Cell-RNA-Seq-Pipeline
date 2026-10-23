.curve_js_path <- if (file.exists("Content/www/js/curve-color-picker.vendored.min.js")) {
  "Content/www/js/curve-color-picker.vendored.min.js"
} else {
  "../../Content/www/js/curve-color-picker.vendored.min.js"
}

.motion_js_path <- if (file.exists("Content/www/js/motion-color-picker.vendored.min.js")) {
  "Content/www/js/motion-color-picker.vendored.min.js"
} else {
  "../../Content/www/js/motion-color-picker.vendored.min.js"
}

testthat::test_that("curve picker script supports dynamic modal mounting", {
  script <- paste(readLines(.curve_js_path, warn = FALSE), collapse = "\n")

  testthat::expect_false(grepl("MutationObserver", script, fixed = TRUE))
  testthat::expect_match(script, "shiny:value")
  testthat::expect_match(script, "mountWithin")
  testthat::expect_match(script, "window\\.mountCurveColorPickers\\s*=\\s*mountAll")
})

testthat::test_that("motion picker script supports dynamic modal mounting", {
  script <- paste(readLines(.motion_js_path, warn = FALSE), collapse = "\n")

  testthat::expect_false(grepl("MutationObserver", script, fixed = TRUE))
  testthat::expect_match(script, "shiny:value")
  testthat::expect_match(script, "mountWithin")
  testthat::expect_match(script, "window\\.mountMotionColorPickers\\s*=\\s*mountAll")
  testthat::expect_match(script, "Fine tune")
  testthat::expect_match(script, "mcp-fine-wrap")
  testthat::expect_match(script, "rgb_slider")
  testthat::expect_match(script, "h_slider")
})
