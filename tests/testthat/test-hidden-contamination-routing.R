testthat::test_that("hidden contamination tab is registered and hidden by app routing", {
  app_path <- if (file.exists("Content/app.R")) "Content/app.R" else "../../Content/app.R"
  nav_path <- if (file.exists("Content/interface/components/component_navbar.R")) {
    "Content/interface/components/component_navbar.R"
  } else {
    "../../Content/interface/components/component_navbar.R"
  }
  admin_path <- if (file.exists("Content/interface/components/admin_hidden_panel.R")) {
    "Content/interface/components/admin_hidden_panel.R"
  } else {
    "../../Content/interface/components/admin_hidden_panel.R"
  }

  app_lines <- readLines(app_path, warn = FALSE)
  nav_lines <- readLines(nav_path, warn = FALSE)
  admin_lines <- readLines(admin_path, warn = FALSE)

  testthat::expect_true(any(grepl("contam_tab", nav_lines, fixed = TRUE)))
  testthat::expect_true(any(grepl("wl_alpha_label(\"Contamination Correction\"", nav_lines, fixed = TRUE)))
  testthat::expect_true(any(grepl("contamination_correction_server", app_lines, fixed = TRUE)))
  testthat::expect_true(any(grepl("hide(selector = \"a.nav-link[data-value='contam_tab']\"", app_lines, fixed = TRUE)))
  testthat::expect_true(any(grepl("admin_open_contamination_tab_btn", admin_lines, fixed = TRUE)))
})
