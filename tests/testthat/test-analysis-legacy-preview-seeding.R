.page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
  "Content/interface/analysis/page_analysis.R"
} else {
  "../../Content/interface/analysis/page_analysis.R"
}

testthat::test_that("analysis seeds preview cache from existing reductions when embedding prefs are missing", {
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "p\\s*<-\\s*tryCatch\\(entry\\$prefs\\$embedding_params",
      page_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "reds\\s*<-\\s*tolower\\(tryCatch\\(names\\(sobj@reductions\\)",
      page_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "if\\s*\\(is\\.null\\(red\\)\\)\\s*\\{[\\s\\S]*?if\\s*\\(\"umap\"\\s*%in%\\s*reds\\)\\s*\\{[\\s\\S]*?\\}\\s*else\\s*if\\s*\\(\"tsne\"\\s*%in%\\s*reds\\)",
      page_source,
      perl = TRUE
    )
  )
})

testthat::test_that("analysis plot format control is native select and re-seeded on object switch", {
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "selectInput\\(\"cfg_plot_format\"[\\s\\S]*?selectize\\s*=\\s*FALSE\\)",
      page_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.preferred_cfg_plot_format\\s*<-\\s*function\\(",
      page_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "updateSelectInput\\(session,\\s*\"cfg_plot_format\",\\s*choices\\s*=\\s*c\\(\"UMAP\",\\s*\"tSNE\"\\),\\s*selected\\s*=\\s*preferred_fmt\\)",
      page_source,
      perl = TRUE
    )
  )
})

testthat::test_that("analysis data browser metadata table avoids DT server-side filter requests", {
  db_source_path <- if (file.exists("Content/interface/analysis/page_data_browser.R")) {
    "Content/interface/analysis/page_data_browser.R"
  } else {
    "../../Content/interface/analysis/page_data_browser.R"
  }
  db_source <- paste(readLines(db_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "output\\$db_meta_table\\s*<-\\s*renderDT\\([\\s\\S]*?\\}\\s*,\\s*server\\s*=\\s*FALSE\\s*\\)",
      db_source,
      perl = TRUE
    )
  )
})

testthat::test_that("analysis bootstrap restores clustertree readiness from imported sweep metadata", {
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "\\.ensure_cluster_sweep_cache_for_object\\s*<-\\s*function\\(",
      page_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "sweep_ready_bootstrapped\\s*<-\\s*isTRUE\\(\\.ensure_cluster_sweep_cache_for_object\\(",
      page_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.sweep_ready\\(sweep_ready_bootstrapped\\)",
      page_source,
      perl = TRUE
    )
  )
})

testthat::test_that("data browser metadata preview gates on data availability, not brittle tab-name matching", {
  db_source_path <- if (file.exists("Content/interface/analysis/page_data_browser.R")) {
    "Content/interface/analysis/page_data_browser.R"
  } else {
    "../../Content/interface/analysis/page_data_browser.R"
  }
  db_source <- paste(readLines(db_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "tab_now\\s*<-\\s*tolower\\(trimws\\(\\.scalar_chr\\(input\\$plot_tabs,\\s*\"data browser\"\\)\\)\\)",
      db_source,
      perl = TRUE
    )
  )

  testthat::expect_false(
    grepl(
      "Open Data Browser tab to load metadata preview\\.",
      db_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "Load data and select an active object first\\.",
      db_source,
      perl = TRUE
    )
  )
})

testthat::test_that("data browser import uses smart barcode key matching for prefixed/suffixed barcodes", {
  db_source_path <- if (file.exists("Content/interface/analysis/page_data_browser.R")) {
    "Content/interface/analysis/page_data_browser.R"
  } else {
    "../../Content/interface/analysis/page_data_browser.R"
  }
  db_source <- paste(readLines(db_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "\\.barcode_match_keys\\s*<-\\s*function\\(",
      db_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "keys\\s*<-\\s*\\.barcode_match_keys\\(bc\\)",
      db_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "key_index\\[\\[k\\]\\]",
      db_source,
      perl = TRUE
    )
  )
})

testthat::test_that("data browser feature-plot gene picker avoids full-matrix client payload updates", {
  db_source_path <- if (file.exists("Content/interface/analysis/page_data_browser.R")) {
    "Content/interface/analysis/page_data_browser.R"
  } else {
    "../../Content/interface/analysis/page_data_browser.R"
  }
  db_source <- paste(readLines(db_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "\\.db_get_assay_features\\s*<-\\s*function\\(",
      db_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "updateSelectizeInput\\(session,\\s*\"db_feature_gene_r\"[\\s\\S]*?server\\s*=\\s*TRUE\\)",
      db_source,
      perl = TRUE
    )
  )
})

testthat::test_that("normalize/integrate offers Loupe CSV shortcut to Data Browser import modal", {
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "to_data_browser_loupe_import_btn",
      page_source,
      fixed = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.go_plot_tab\\(\"data browser\"\\)",
      page_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "db_open_import_modal",
      page_source,
      fixed = TRUE
    )
  )
})

testthat::test_that("deferred UMAP preview dispatch runs inside session reactive domain", {
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "session\\$onFlushed\\(function\\(\\)\\s*\\{[\\s\\S]*?shiny::withReactiveDomain\\(session,\\s*\\{[\\s\\S]*?\\.queue_cfg_preview_run\\(",
      page_source,
      perl = TRUE
    )
  )
})

testthat::test_that("analysis tab empty-restore is gated by DOM active tab signal", {
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "observeEvent\\(input\\$plot_tabs,[\\s\\S]*?if \\(!nzchar\\(tab_now\\)\\)[\\s\\S]*?d <- input\\$plot_tabs_dom_diag[\\s\\S]*?d_active <- \\.scalar_chr\\(d\\$active, default = \"\"\\)[\\s\\S]*?if \\(!is\\.null\\(d\\) && isTRUE\\(d\\$visible\\) && nzchar\\(d_active\\)\\)\\s*\\{[\\s\\S]*?return\\(invisible\\(NULL\\)\\)",
      page_source,
      perl = TRUE
    )
  )
})

testthat::test_that("UMAP preview rendering uses active object embeddings as canonical source", {
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "\\.analysis_reduction_signature\\s*<-\\s*function\\(",
      page_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "\\.cfg_preview_or_saved\\s*<-\\s*reactive\\([\\s\\S]*?if \\(!nzchar\\(sig_cache\\) \\|\\| !identical\\(sig_active, sig_cache\\)\\)\\s*\\{[\\s\\S]*?object = active_sobj",
      page_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "preview_sobj = ref_sobj %\\|\\| out\\$object",
      page_source,
      perl = TRUE
    )
  )
})
