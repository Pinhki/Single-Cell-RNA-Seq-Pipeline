## Reactive-context tests are server-side only. Browser automation is reserved
## for visual/UI checks and must not be used to validate reactive ownership.

.db_page_source_path <- if (file.exists("Content/interface/analysis/page_data_browser_new.R")) {
  "Content/interface/analysis/page_data_browser_new.R"
} else {
  "../../Content/interface/analysis/page_data_browser_new.R"
}
.app_source_path <- if (file.exists("Content/app.R")) {
  "Content/app.R"
} else {
  "../../Content/app.R"
}
.legacy_db_page_source_path <- if (file.exists("Content/interface/analysis/page_data_browser.R")) {
  "Content/interface/analysis/page_data_browser.R"
} else {
  "../../Content/interface/analysis/page_data_browser.R"
}
.analysis_page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
  "Content/interface/analysis/page_analysis.R"
} else {
  "../../Content/interface/analysis/page_analysis.R"
}
.workspace_page_source_path <- if (file.exists("Content/interface/workspace/page_rds.R")) {
  "Content/interface/workspace/page_rds.R"
} else {
  "../../Content/interface/workspace/page_rds.R"
}
.right_sidebar_source_path <- if (file.exists("Content/interface/components/component_right_sidebar.R")) {
  "Content/interface/components/component_right_sidebar.R"
} else {
  "../../Content/interface/components/component_right_sidebar.R"
}
.gene_selectize_helper_source_path <- if (file.exists("Content/interface/shared/gene_selectize_helpers.R")) {
  "Content/interface/shared/gene_selectize_helpers.R"
} else {
  "../../Content/interface/shared/gene_selectize_helpers.R"
}
.global_runtime_early_source_path <- if (file.exists("Content/www/js/global-runtime-early.js")) {
  "Content/www/js/global-runtime-early.js"
} else {
  "../../Content/www/js/global-runtime-early.js"
}
.global_runtime_ui_source_path <- if (file.exists("Content/www/js/global-runtime-ui.js")) {
  "Content/www/js/global-runtime-ui.js"
} else {
  "../../Content/www/js/global-runtime-ui.js"
}
.spinner_overlay_source_path <- if (file.exists("Content/interface/shared/spinner_overlay.R")) {
  "Content/interface/shared/spinner_overlay.R"
} else {
  "../../Content/interface/shared/spinner_overlay.R"
}
source(.gene_selectize_helper_source_path)

testthat::test_that("autofill reconciliation follows Shiny event semantics", {
  source_text <- paste(readLines(.global_runtime_early_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("function recordServerExpected", source_text, fixed = TRUE))
  testthat::expect_true(grepl("shiny:updateinput.wlAutofillContract", source_text, fixed = TRUE))
  testthat::expect_true(grepl("if (message.value === undefined) return;", source_text, fixed = TRUE))
  testthat::expect_true(grepl("target.selectize.setValue(target.__prev_value, true)", source_text, fixed = TRUE))
  testthat::expect_false(grepl("target.selectize.setValue(target.__prev_value, false)", source_text, fixed = TRUE))
})

testthat::test_that("shared runtime uses lifecycle events instead of document-wide rescans", {
  early_text <- paste(readLines(.global_runtime_early_source_path, warn = FALSE), collapse = "\n")
  ui_text <- paste(readLines(.global_runtime_ui_source_path, warn = FALSE), collapse = "\n")
  sidebar_text <- paste(readLines(.right_sidebar_source_path, warn = FALSE), collapse = "\n")
  spinner_text <- paste(readLines(.spinner_overlay_source_path, warn = FALSE), collapse = "\n")

  broad_observer <- "observe\\(document\\.documentElement\\s*,\\s*\\{\\s*childList\\s*:\\s*true\\s*,\\s*subtree\\s*:\\s*true"
  testthat::expect_false(grepl(broad_observer, early_text, perl = TRUE))
  testthat::expect_false(grepl(broad_observer, ui_text, perl = TRUE))
  testthat::expect_false(grepl("MutationObserver", early_text, fixed = TRUE))
  testthat::expect_false(grepl("MutationObserver", ui_text, fixed = TRUE))
  testthat::expect_false(grepl("MutationObserver", sidebar_text, fixed = TRUE))
  testthat::expect_true(grepl("isolate\\(.presenter_mode_is_on\\(\\)\\)", sidebar_text, perl = TRUE))
  testthat::expect_false(grepl("setTimeout(scanAndApply", ui_text, fixed = TRUE))
  testthat::expect_false(grepl("setTimeout(fitTabLabels", ui_text, fixed = TRUE))
  testthat::expect_false(grepl("resizePlotlyInContainer(container); }, 70", ui_text, fixed = TRUE))
  testthat::expect_false(grepl("setTimeout|setInterval", ui_text, perl = TRUE))
  testthat::expect_true(grepl("var resizePlotlyPending = new Set();", ui_text, fixed = TRUE))
  testthat::expect_true(grepl("target.__wlLastPlotlyResizeSignature === signature", ui_text, fixed = TRUE))
  testthat::expect_true(grepl("if (nodes[j].__wlPlotlyResizeObserved) continue;", ui_text, fixed = TRUE))
  testthat::expect_false(grepl("cancelAnimationFrame(resizePlotlyRaf)", ui_text, fixed = TRUE))
  testthat::expect_false(grepl("hide-when-output-ready|hideWhenOutputReady|overlay_hide_when_output_ready", spinner_text, perl = TRUE))
  testthat::expect_true(grepl("document.addEventListener('shiny:value', function (ev)", ui_text, fixed = TRUE))
  testthat::expect_true(grepl("scanTargetAndApply(ev && ev.target)", ui_text, fixed = TRUE))
  testthat::expect_true(grepl("document.addEventListener('shiny:value', fitTabLabels", ui_text, fixed = TRUE))
})

testthat::test_that("onFlushed callbacks require an isolated reactive snapshot", {
  observed <- NA_integer_
  shiny::testServer(
    function(input, output, session) {
      value <- shiny::reactiveVal(7L)
      session$onFlushed(function() {
        observed <<- isolate(value())
      }, once = TRUE)
    },
    {
      session$flushReact()
    }
  )
  testthat::expect_identical(observed, 7L)
})

testthat::test_that("Data Browser flush settlement isolates reactive reads", {
  source_text <- paste(readLines(.db_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "context_snapshot\\s*<-\\s*isolate\\(list\\([\\s\\S]*?current_revision\\s*=\\s*\\.recluster_new_context_revision\\(\\)[\\s\\S]*?active_object\\s*=\\s*\\.recluster_new_canonical_object_name\\(\\)",
      source_text,
      perl = TRUE
    )
  )
  testthat::expect_false(
    grepl(
      "session\\$onFlushed\\(function\\(\\)\\s*\\{\\s*current_revision\\s*<-\\s*\\.recluster_new_context_revision\\(\\)",
      source_text,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "plot_cache_sig\\s*<-\\s*isolate\\(\\.umap_plot_cache_signature\\(\\)\\)",
      source_text,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "outputOptions\\(output, \\\"recluster_new_expression_groups_ui\\\", suspendWhenHidden = FALSE\\)",
      source_text,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "expr_ui_render_revision",
      source_text,
      fixed = TRUE
    )
  )
  testthat::expect_true(grepl(".sync_assay_gene_inputs(force = TRUE)", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".sync_rule_assay_gene_inputs(force = TRUE)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("object_ready = inherits(recluster_new_data$seurat_obj, \"Seurat\")", source_text, fixed = TRUE))
  testthat::expect_true(grepl("plot_data_ready = is.data.frame(recluster_new_data$plot_df)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("recluster_new_data$confirmed_plot_context_key <- confirmed_key", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".recluster_new_expected_plot_context_key", source_text, fixed = TRUE))
  testthat::expect_true(grepl("data_browser_new$visual_settings", source_text, fixed = TRUE))
  testthat::expect_false(grepl("visual_settings_by_object", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".recluster_new_clear_page_context <- function", source_text, fixed = TRUE))
  testthat::expect_true(grepl("recluster_new_loaded_object_name(\"\")", source_text, fixed = TRUE))
  testthat::expect_true(grepl("Canonical identity always comes from shared state", source_text, fixed = TRUE))
  testthat::expect_true(
    grepl(
      ".plotly_event_data_if_active",
      source_text,
      fixed = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "recluster_new_plot_source",
      source_text,
      fixed = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "Metadata accordion state is independent from UMAP display/color state.",
      source_text,
      fixed = TRUE
    )
  )
  testthat::expect_false(
    grepl(
      "updateRadioButtons(session, \\\"recluster_new_umap_display_mode\\\", selected = \\\"metadata\\\")",
      source_text,
      fixed = TRUE
    )
  )
  testthat::expect_true(grepl("syncAllReclusterNewTabs", source_text, fixed = TRUE))
  testthat::expect_true(
    grepl(
      "document.addEventListener('shiny:connected', function ()",
      source_text,
      fixed = TRUE
    )
  )
  testthat::expect_false(grepl("syncAllReclusterNewTabs(true)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("__reclusterNewLastPublishedTab", source_text, fixed = TRUE))
  testthat::expect_false(grepl("setTimeout|setInterval|MutationObserver", source_text, perl = TRUE))
})

testthat::test_that("Data Browser diagnostics are opt-in and object-owned state is explicit", {
  source_text <- paste(readLines(.db_page_source_path, warn = FALSE), collapse = "\n")
  analysis_text <- paste(readLines(.analysis_page_source_path, warn = FALSE), collapse = "\n")
  app_text <- paste(readLines(.app_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("WANLAB_DIAG_MODE <- identical(Sys.getenv(\"WANLAB_DIAG_MODE\", \"0\"), \"1\")", app_text, fixed = TRUE))
  testthat::expect_true(grepl("if (!isTRUE(get0(\"WANLAB_DIAG_MODE\", ifnotfound = FALSE))) return(invisible(NULL))", analysis_text, fixed = TRUE))
  testthat::expect_true(grepl(".db_diag_enabled <- isTRUE(get0(\n    \"WANLAB_DB_DIAG_MODE\"", source_text, fixed = TRUE))
  testthat::expect_true(grepl("if (!isTRUE(.db_diag_enabled)) return(invisible(NULL))", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".expr_store_set(obj, expr_state_loaded)", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".saved_group_store_set(obj, saved_groups_loaded)", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".object_owned_state <- function(sobj)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("reload_object_owned_state_changed", source_text, fixed = TRUE))
  testthat::expect_true(grepl("umap_gene_values = vals", source_text, fixed = TRUE))
  testthat::expect_true(grepl("umap_display_mode = recluster_new_data$umap_display_mode", source_text, fixed = TRUE))
})

testthat::test_that("Data Browser overlay release is server-owned and terminal", {
  source_text <- paste(readLines(.db_page_source_path, warn = FALSE), collapse = "\n")
  legacy_source_text <- paste(readLines(.legacy_db_page_source_path, warn = FALSE), collapse = "\n")
  workspace_source_text <- paste(readLines(.workspace_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("recluster_new_overlay_begin", source_text, fixed = TRUE))
  testthat::expect_true(grepl("recluster_new_overlay_finish", source_text, fixed = TRUE))
  testthat::expect_true(grepl("recluster_new_overlay_cancel", source_text, fixed = TRUE))
  testthat::expect_true(grepl("recluster_new_overlay_request_id()", source_text, fixed = TRUE))
  testthat::expect_true(grepl("umap_render_error", source_text, fixed = TRUE))
  testthat::expect_true(grepl("recluster_new_error_plot", source_text, fixed = TRUE))
  testthat::expect_false(grepl("overlay_hide_when_output_ready", source_text, fixed = TRUE))
  testthat::expect_false(grepl("overlay_hide_when_output_ready", legacy_source_text, fixed = TRUE))
  testthat::expect_false(grepl("overlay_hide_when_output_ready", workspace_source_text, fixed = TRUE))
  testthat::expect_true(grepl("session$onFlushed(function()", legacy_source_text, fixed = TRUE))
  testthat::expect_false(grepl("setTimeout|setInterval|MutationObserver", legacy_source_text, perl = TRUE))
})

testthat::test_that("gene Selectize controls avoid large initial catalogs and hydrate after binding", {
  deferred_ui <- wl_gene_selectize_input(
    "recluster_new_expr_add_gene__eg001",
    "Add gene",
    choices = c("Trac", "Cd3d"),
    min_chars = 0L,
    open_on_focus = TRUE,
    preload = TRUE,
    defer_choices = TRUE
  )
  deferred_html <- htmltools::renderTags(deferred_ui)$html
  testthat::expect_false(grepl('value="Trac"', deferred_html, fixed = TRUE))
  testthat::expect_false(grepl('value="Cd3d"', deferred_html, fixed = TRUE))

  local_ui <- wl_gene_selectize_input(
    "gene_local_catalog",
    "Gene",
    choices = c("Trac", "Cd3d")
  )
  local_html <- htmltools::renderTags(local_ui)$html
  testthat::expect_true(grepl('value="Trac"', local_html, fixed = TRUE))
  testthat::expect_true(grepl('value="Cd3d"', local_html, fixed = TRUE))

  source_text <- paste(readLines(.db_page_source_path, warn = FALSE), collapse = "\n")
  testthat::expect_true(grepl("choices = genes_now", source_text, fixed = TRUE))
  testthat::expect_true(
    grepl(
      "\\.db_update_gene_selectize <- function[\\s\\S]{0,500}server = TRUE",
      source_text,
      perl = TRUE
    )
  )
  testthat::expect_false(
    grepl(
      "\\.db_update_gene_selectize <- function[\\s\\S]{0,500}server = FALSE",
      source_text,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "recluster_new_gene_expr_select_3\".*choices = all_genes",
      source_text,
      perl = TRUE
    )
  )
  testthat::expect_true(grepl("defer_choices = TRUE", source_text, fixed = TRUE))
  testthat::expect_true(grepl("gene_selectize_bound", source_text, fixed = TRUE))
  testthat::expect_true(grepl("__reclusterNewGeneSelectizeBoundKey", source_text, fixed = TRUE))
  testthat::expect_true(grepl("gene_catalog_flush_hydrate", source_text, fixed = TRUE))
  testthat::expect_true(grepl("session$onFlushed(function()", source_text, fixed = TRUE))
  testthat::expect_true(grepl("snapshot <- isolate(list(", source_text, fixed = TRUE))
  testthat::expect_true(grepl("source = \"viz_controls_ui\"", source_text, fixed = TRUE))
  testthat::expect_true(grepl("source = \"rule_viz_controls_ui\"", source_text, fixed = TRUE))
  testthat::expect_false(
    grepl(
      "recluster_new_gene_selectize_bound[\\s\\S]{0,500}nonce: Date.now\\(\\)",
      source_text,
      perl = TRUE
    )
  )
  legacy_source_text <- paste(readLines(.legacy_db_page_source_path, warn = FALSE), collapse = "\n")
  testthat::expect_true(grepl("choices = feature_gene_choices", legacy_source_text, fixed = TRUE))
  testthat::expect_true(grepl("expression_gene_catalog", source_text, fixed = TRUE))
})

testthat::test_that("gene selectors do not switch independent display or plot-tab state", {
  source_text <- paste(readLines(.db_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_false(grepl("activate_gene_expression_display", source_text, fixed = TRUE))
  testthat::expect_false(grepl("recluster-new-set-tab", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".set_umap_gene_value(1L, next_gene)", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".set_umap_gene_value(2L, next_gene)", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".set_umap_gene_value(3L, next_gene)", source_text, fixed = TRUE))
  testthat::expect_true(
    grepl("umap_gene_info <- if (identical(display_mode, \"gene\"))", source_text, fixed = TRUE)
  )
})

testthat::test_that("expression distribution keeps traces visible and static", {
  source_text <- paste(readLines(.db_page_source_path, warn = FALSE), collapse = "\n")
  distribution_start <- regexpr("output\\$recluster_new_expr_active_distribution <- renderPlotly", source_text, perl = TRUE)[[1L]]
  distribution_end <- regexpr("observeEvent\\(input\\$recluster_new_expr_limit_population", source_text, perl = TRUE)[[1L]]
  distribution_text <- substr(source_text, distribution_start, distribution_end - 1L)

  testthat::expect_true(grepl("Match QC's horizontal violin contract", source_text, fixed = TRUE))
  testthat::expect_true(grepl("nticks = 6L", source_text, fixed = TRUE))
  testthat::expect_true(grepl("automargin = FALSE", source_text, fixed = TRUE))
  testthat::expect_true(grepl("margin = list(l = 2, r = 7, t = 16, b = 8, pad = 0)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("Bootstrap/widget horizontal padding must not create", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".expr_distribution_display_range <- function(full_rng)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("density_grid <- seq(display_rng[[1]], display_rng[[2]], length.out = 512L)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("stats::density(", source_text, fixed = TRUE))
  testthat::expect_true(grepl("density_df <- data.frame(", source_text, fixed = TRUE))
  testthat::expect_false(grepl("negative_width", distribution_text, fixed = TRUE))
  testthat::expect_true(grepl("range = c(0, plot_y_max)", distribution_text, fixed = TRUE))
  testthat::expect_true(grepl("fill = \"tozeroy\"", source_text, fixed = TRUE))
  testthat::expect_true(grepl("fillcolor = \"rgba(105,179,231,0.28)\"", source_text, fixed = TRUE))
  testthat::expect_false(grepl("add_bars", distribution_text, fixed = TRUE))
  testthat::expect_false(grepl("type = \"bar\"", distribution_text, fixed = TRUE))
  testthat::expect_true(grepl("dot_y <- dot_band", source_text, fixed = TRUE))
  testthat::expect_true(grepl("type = \"scattergl\",", source_text, fixed = TRUE))
  testthat::expect_false(grepl("cliponaxis", distribution_text, fixed = TRUE))
  testthat::expect_true(
    grepl(
      "displayModeBar = FALSE[\\s\\S]*?scrollZoom = FALSE[\\s\\S]*?staticPlot = TRUE",
      source_text,
      perl = TRUE
    )
  )
  testthat::expect_true(grepl("displayModeBar = FALSE", source_text, fixed = TRUE))
  testthat::expect_true(grepl("scrollZoom = FALSE", source_text, fixed = TRUE))
  testthat::expect_true(grepl("doubleClick = FALSE", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".plotly_register_selection_events", source_text, fixed = TRUE))
})

testthat::test_that("expression slider formats labels without changing thresholds", {
  source_text <- paste(readLines(.db_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("full-precision numeric values", source_text, fixed = TRUE))
  testthat::expect_true(grepl("slider.options.prettify", source_text, fixed = TRUE))
  testthat::expect_true(grepl("numeric.toFixed(2)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("formatExpressionRangeTicks", source_text, fixed = TRUE))
  testthat::expect_true(grepl("irs-grid-text", source_text, fixed = TRUE))
  testthat::expect_true(grepl("ticks[ticks.length - 1]", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".trim()", source_text, fixed = TRUE))
  testthat::expect_true(grepl("recluster-new-expr-zero-tick", source_text, fixed = TRUE))
  testthat::expect_true(grepl("slider.options.force_edges = true", source_text, fixed = TRUE))
  testthat::expect_true(grepl("data-force-edges", source_text, fixed = TRUE))
  testthat::expect_true(grepl("shiny:bound.reclusterNewExprRangeDisplay", source_text, fixed = TRUE))
})

testthat::test_that("Data Browser ignores Plotly rebind selection payloads", {
  source_text <- paste(readLines(.db_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl('if (nrow(ev) == 0L || !("key" %in% names(ev))) return(NULL)', source_text, fixed = TRUE))
  testthat::expect_true(grepl('if (!length(keys)) return(NULL)', source_text, fixed = TRUE))
  testthat::expect_true(grepl("plotly_deselect", source_text, fixed = TRUE))
  testthat::expect_true(grepl("plotly_doubleclick", source_text, fixed = TRUE))
})

testthat::test_that("Analysis deferred active-object read is isolated", {
  source_text <- paste(readLines(.analysis_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "session\\$onFlushed\\(function\\(\\)\\s*\\{[\\s\\S]*?sobj_target\\s*<-\\s*tryCatch\\(isolate\\(\\.get_active_sobj\\(shared_data\\)\\)",
      source_text,
      perl = TRUE
    )
  )
})

testthat::test_that("Analysis plot-tab bridge has no self-observing DOM loop", {
  source_text <- paste(readLines(.analysis_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_false(grepl("bindRootObserver", source_text, fixed = TRUE))
  testthat::expect_false(grepl("var mo = new MutationObserver", source_text, fixed = TRUE))
  testthat::expect_false(grepl("plot_tabs_dom_diag", source_text, fixed = TRUE))
  testthat::expect_true(grepl("document.addEventListener('shown.bs.tab'", source_text, fixed = TRUE))
  testthat::expect_true(grepl("function startSync()", source_text, fixed = TRUE))
  testthat::expect_true(grepl("document.addEventListener('shiny:connected', startSync", source_text, fixed = TRUE))
  testthat::expect_true(grepl("function publishPlotTabValue", source_text, fixed = TRUE))
  testthat::expect_true(grepl("if (root.__analysisLastPublishedPlotTab === value) return false;", source_text, fixed = TRUE))
  testthat::expect_true(grepl("root.__analysisLastPublishedPlotTab = value;", source_text, fixed = TRUE))
  testthat::expect_false(grepl("lastSentPlotTab", source_text, fixed = TRUE))
  testthat::expect_false(grepl("reconcilePlotTabState", source_text, fixed = TRUE))
  testthat::expect_false(grepl("lastNonEmptyPlotTab", source_text, fixed = TRUE))
  testthat::expect_false(grepl("root.contains(target)", source_text, fixed = TRUE))
  testthat::expect_false(grepl("$inputValues", source_text, fixed = TRUE))
  testthat::expect_true(grepl("document.addEventListener('shiny:value', syncPlotTabLifecycle", source_text, fixed = TRUE))
  testthat::expect_true(grepl("document.addEventListener('shiny:bound', syncPlotTabLifecycle", source_text, fixed = TRUE))
})

testthat::test_that("Data Browser tab mirror publishes once per DOM transition", {
  source_text <- paste(readLines(.db_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("__reclusterNewLastPublishedTab", source_text, fixed = TRUE))
  testthat::expect_true(grepl("if (root.__reclusterNewLastPublishedTab === value) return false;", source_text, fixed = TRUE))
  testthat::expect_false(grepl("resetPublication", source_text, fixed = TRUE))
  testthat::expect_false(grepl("__reclusterNewLastShownTab", source_text, fixed = TRUE))
  testthat::expect_false(grepl("$inputValues", source_text, fixed = TRUE))
  testthat::expect_false(grepl("reclusterNewTabRootsForTarget", source_text, fixed = TRUE))
})

testthat::test_that("Analysis route publishes canonical tab at scaffold flush", {
  source_text <- paste(readLines(.analysis_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("scaffold_flushed", source_text, fixed = TRUE))
  testthat::expect_true(grepl("analysis_route_lifecycle <- new.env", source_text, fixed = TRUE))
  testthat::expect_true(grepl("context_snapshot <- isolate(list(", source_text, fixed = TRUE))
  testthat::expect_true(grepl("session$sendCustomMessage(\"analysis-set-plot-tab\"", source_text, fixed = TRUE))
  testthat::expect_true(grepl("landing_applied = TRUE", source_text, fixed = TRUE))
  testthat::expect_true(grepl("analysis_plot_tabs_initialized(TRUE)", source_text, fixed = TRUE))
  testthat::expect_false(grepl("dom_ready <-", source_text, fixed = TRUE))
  testthat::expect_true(grepl("route_scaffold_flushed", source_text, fixed = TRUE))
  testthat::expect_true(grepl("isTRUE(st$scaffold_flushed)", source_text, fixed = TRUE))
})

testthat::test_that("Analysis page overlays use server flush ownership", {
  source_text <- paste(readLines(.analysis_page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_false(grepl("overlay_hide_when_output_ready", source_text, fixed = TRUE))
  testthat::expect_true(grepl("umap_viz_overlay_signature", source_text, fixed = TRUE))
  testthat::expect_true(grepl("session$onFlushed(function()", source_text, fixed = TRUE))
  testthat::expect_true(grepl("signature_after <- isolate", source_text, fixed = TRUE))
})
