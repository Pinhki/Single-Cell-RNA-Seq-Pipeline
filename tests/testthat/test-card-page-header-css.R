.global_css_path <- if (file.exists("Content/www/global.css")) {
  "Content/www/global.css"
} else {
  "../../Content/www/global.css"
}

.custom_css_path <- if (file.exists("Content/www/custom_bslib.css")) {
  "Content/www/custom_bslib.css"
} else {
  "../../Content/www/custom_bslib.css"
}

testthat::test_that("card-page headers use the global page-header spacing contract", {
  global_css <- paste(readLines(.global_css_path, warn = FALSE), collapse = "\n")
  custom_css <- paste(readLines(.custom_css_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "\\.app-page\\s+\\.card-page-header\\s*\\{[^}]*margin-top\\s*:\\s*2px;[^}]*margin-bottom\\s*:\\s*12px;",
      global_css,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.card-page-title-row\\s*\\{[^}]*margin-bottom\\s*:\\s*6px;",
      global_css,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.card-page-header\\s+\\.card-page-subtitle\\s*\\{[^}]*margin-top\\s*:\\s*0;[^}]*margin-left\\s*:\\s*var\\(--card-page-title-sub-indent, 0\\);",
      global_css,
      perl = TRUE
    )
  )

  testthat::expect_false(
    grepl(
      "\\.card-page-header\\s*\\{[^}]*margin-(top|bottom)\\s*:",
      custom_css,
      perl = TRUE
    )
  )

  testthat::expect_false(
    grepl(
      "\\.card-page-subtitle\\s*\\{[^}]*margin\\s*:",
      custom_css,
      perl = TRUE
    )
  )

  testthat::expect_false(
    grepl(
      "\\.card-page-title\\s*\\{[^}]*line-height\\s*:",
      custom_css,
      perl = TRUE
    )
  )
})
