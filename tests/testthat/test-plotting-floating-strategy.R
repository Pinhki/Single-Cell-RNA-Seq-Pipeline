testthat::test_that("plotting CSS defines separate float modes and float-only scrolling", {
  css_path <- if (file.exists("Content/www/global.css")) {
    "Content/www/global.css"
  } else {
    "../../Content/www/global.css"
  }
  css <- paste(readLines(css_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "\\.plotting-page\\.float-left-panel\\s+\\.plotting-left-panel\\s*\\{[^}]*position\\s*:\\s*sticky[^}]*top\\s*:\\s*0[^}]*overflow-y\\s*:\\s*auto",
      css,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.plotting-page\\.float-plot-area\\s+\\.plot_area_card_style\\s*\\{[^}]*position\\s*:\\s*sticky[^}]*top\\s*:\\s*0[^}]*overflow-y\\s*:\\s*auto",
      css,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.plotting-page\\.float-left-panel\\s+\\.plot_area_card_style\\s*\\{[^}]*overflow\\s*:\\s*visible",
      css,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.plotting-page\\.float-plot-area\\s+\\.plotting-left-panel\\s*\\{[^}]*overflow-y\\s*:\\s*visible",
      css,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.plotting-page\\.float-left-panel\\s+\\.plotting-left-panel\\s*\\{[^}]*height\\s*:\\s*calc\\(100dvh\\s*-\\s*var\\(--nav-h\\)\\s*-\\s*var\\(--footer-h\\)\\s*-\\s*\\(2\\s*\\*\\s*var\\(--plotting-float-gap-y\\)\\)\\)",
      css,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.plotting-page\\.float-plot-area\\s+\\.plot_area_card_style\\s*\\{[^}]*height\\s*:\\s*calc\\(100dvh\\s*-\\s*var\\(--nav-h\\)\\s*-\\s*var\\(--footer-h\\)\\s*-\\s*\\(2\\s*\\*\\s*var\\(--plotting-float-gap-y\\)\\)\\)",
      css,
      perl = TRUE
    )
  )
})

testthat::test_that("plotting script toggles float mode by taller side", {
  app_path <- if (file.exists("Content/app.R")) {
    "Content/app.R"
  } else {
    "../../Content/app.R"
  }
  app_source <- paste(readLines(app_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("float-left-panel", app_source, fixed = TRUE))
  testthat::expect_true(grepl("float-plot-area", app_source, fixed = TRUE))

  testthat::expect_true(
    grepl(
      "leftH\\s*>=\\s*rightH\\s*\\)\\s*\\{",
      app_source,
      perl = TRUE
    )
  )
})
