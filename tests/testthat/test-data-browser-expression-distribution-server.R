## Server-side production render regression. Browser automation is intentionally
## excluded; this exercises the actual Data Browser module and serialized output.

.db_test_root <- normalizePath(
  if (dir.exists("Content")) "." else file.path("..", ".."),
  winslash = "/",
  mustWork = FALSE
)
.db_test_core_lib <- file.path(.db_test_root, "package_libraries", "core")
if (dir.exists(.db_test_core_lib)) {
  .libPaths(unique(c(.db_test_core_lib, .libPaths())))
}

testthat::test_that("production expression distribution serializes horizontal violin and all-cell dots", {
  required <- c(
    "shiny", "shinyjs", "shinybusy", "bslib", "shinycssloaders",
    "rhandsontable", "plotly", "shinyWidgets", "shinyFiles", "fs", "DT",
    "colourpicker", "ggplot2", "patchwork", "Seurat", "SeuratObject", "jsonlite"
  )
  if (!all(vapply(required, requireNamespace, logical(1), quietly = TRUE))) {
    testthat::skip("project runtime packages are not available")
  }

  old_wd <- getwd()
  setwd(file.path(.db_test_root, "Content"))
  on.exit(setwd(old_wd), add = TRUE)

  old_diag <- Sys.getenv("WANLAB_DB_DIAG_MODE", unset = NA_character_)
  on.exit(
    if (is.na(old_diag)) Sys.unsetenv("WANLAB_DB_DIAG_MODE") else Sys.setenv(WANLAB_DB_DIAG_MODE = old_diag),
    add = TRUE
  )
  Sys.setenv(WANLAB_DB_DIAG_MODE = "1")

  app_env <- new.env(parent = globalenv())
  suppressMessages(suppressWarnings(sys.source("app.R", envir = app_env)))

  set.seed(44)
  cells <- paste0("cell_", seq_len(120L))
  genes <- c("Cd8b1", "Gene2", "Gene3")
  counts <- matrix(
    stats::rpois(length(genes) * length(cells), lambda = 1.2),
    nrow = length(genes),
    dimnames = list(genes, cells)
  )
  counts[1L, seq_len(25L)] <- seq_len(25L)
  obj <- Seurat::CreateSeuratObject(counts = counts, assay = "RNA")
  obj <- Seurat::NormalizeData(obj, verbose = FALSE)
  embeddings <- matrix(
    stats::rnorm(length(cells) * 2L),
    ncol = 2L,
    dimnames = list(cells, c("UMAP_1", "UMAP_2"))
  )
  obj[["umap"]] <- SeuratObject::CreateDimReducObject(
    embeddings = embeddings,
    key = "UMAP_",
    assay = "RNA"
  )
  obj@misc$analysis <- list(
    data_browser_new = list(
      expression_selection = list(
        inherit_population = FALSE,
        active_group_id = "g001",
        next_group_index = 2L,
        next_gene_index = 2L,
        groups = list(list(
          id = "g001",
          name = "T cells",
          open = TRUE,
          require_all = FALSE,
          invert = FALSE,
          active_gene_id = "g001_gene_001",
          genes = list(list(
            id = "g001_gene_001",
            gene = "Cd8b1",
            checked = TRUE,
            range = c(0.2, 3.9)
          ))
        ))
      )
    )
  )

  shared_data <- shiny::reactiveValues(
    all_seurat_objects = list(sample = list(
      obj = obj,
      prefs = list(),
      plots = list(),
      analysis_cache = list(),
      meta = list()
    )),
    active_object_name = "sample",
    full_sample_sheet = data.frame(),
    object_prefs = list(),
    active_environment = list(name = "", path = ""),
    analysis_params_by_page = list()
  )

  shiny::testServer(
    function(input, output, session) {
      app_env$recluster_new_server(input, output, session, shared_data)
    },
    {
      session$setInputs(
        main_navbar = "recluster_new_tab",
        recluster_new_tabs = "umap",
        recluster_new_workspace_tabs = "Selection Workspace",
        recluster_new_expr_limit_population = FALSE
      )
      session$flushReact()
      session$flushReact()

      main_plot <- as.character(output$recluster_new_umap_plot)
      testthat::expect_true(nzchar(main_plot))
      session$flushReact()

      landing_range_ui <- paste(as.character(output$recluster_new_expr_active_range_ui), collapse = "")
      testthat::expect_match(landing_range_ui, "Select a gene row to edit its range")
      groups_ui <- paste(as.character(output$recluster_new_expression_groups_ui), collapse = "")
      testthat::expect_match(groups_ui, "recluster_new_expr_gene_delete__g001__g001_gene_001")
      testthat::expect_match(groups_ui, "data-expr-delete-group-id=\"g001\"")
      testthat::expect_match(groups_ui, "data-expr-delete-gene-id=\"g001_gene_001\"")
      stored_state <- shared_data$all_seurat_objects$sample$obj@misc$analysis$data_browser_new$expression_selection
      testthat::expect_identical(stored_state$groups[[1L]]$active_gene_id, "")

      active_input <- list(1L)
      names(active_input) <- "recluster_new_expr_gene_active__g001__g001_gene_001"
      do.call(session$setInputs, active_input)
      session$flushReact()
      session$flushReact()

      range_ui <- paste(as.character(output$recluster_new_expr_active_range_ui), collapse = "")
      testthat::expect_match(range_ui, "recluster_new_expr_active_distribution")
      testthat::expect_match(range_ui, "height:148px")

      payload <- as.character(output$recluster_new_expr_active_distribution)
      testthat::expect_true(nzchar(payload))
      parsed <- jsonlite::fromJSON(payload, simplifyVector = FALSE)
      traces <- if (is.list(parsed$x) && is.list(parsed$x$data)) parsed$x$data else list()
      types <- vapply(traces, function(trace) {
        if (is.list(trace) && !is.null(trace$type)) as.character(trace$type) else ""
      }, character(1))
      testthat::expect_false("bar" %in% types)
      testthat::expect_true("scatter" %in% types)
      testthat::expect_false("scattergl" %in% types)
      density_idx <- which(types == "scatter")[[1L]]
      testthat::expect_equal(length(traces[[density_idx]]$x), 1024L)
      testthat::expect_equal(length(traces[[density_idx]]$y), 1024L)
      testthat::expect_gt(max(as.numeric(unlist(traces[[density_idx]]$y))), 0)
      testthat::expect_gt(sum(as.numeric(unlist(traces[[density_idx]]$y)) > 0), 64L)
      line_traces <- traces[vapply(traces, function(trace) {
        is.list(trace) && identical(as.character(if (is.null(trace$mode)) "" else trace$mode), "lines")
      }, logical(1))]
      testthat::expect_gte(length(line_traces), 1L)
      testthat::expect_true(any(vapply(line_traces, function(trace) {
        any(as.numeric(unlist(trace$x)) < 0)
      }, logical(1))))
      testthat::expect_false(any(vapply(line_traces, function(trace) {
        any(as.numeric(unlist(trace$y)) < 0)
      }, logical(1))))
      annotations <- if (is.list(parsed$x$layout) && is.list(parsed$x$layout$annotations)) {
        parsed$x$layout$annotations
      } else {
        list()
      }
      annotation_text <- vapply(annotations, function(annotation) {
        if (is.list(annotation) && !is.null(annotation$text)) as.character(annotation$text[[1L]]) else ""
      }, character(1))
      testthat::expect_true(any(grepl("Cd8b1 expression range", annotation_text, fixed = TRUE)))
      shapes <- if (is.list(parsed$x$layout) && is.list(parsed$x$layout$shapes)) parsed$x$layout$shapes else list()
      testthat::expect_true(any(vapply(shapes, function(shape) {
        is.list(shape) && !is.null(shape$x0) && identical(as.numeric(shape$x0[[1L]]), 0)
      }, logical(1))))
      yaxis <- if (is.list(parsed$x$layout) && is.list(parsed$x$layout$yaxis)) parsed$x$layout$yaxis else list()
      yaxis_title <- if (is.character(yaxis$title)) yaxis$title[[1L]] else if (is.list(yaxis$title) && !is.null(yaxis$title$text)) yaxis$title$text[[1L]] else ""
      testthat::expect_false(identical(yaxis_title, "width"))
      dot_traces <- traces[vapply(traces, function(trace) {
        is.list(trace) && identical(as.character(if (is.null(trace$mode)) "" else trace$mode), "markers")
      }, logical(1))]
      testthat::expect_equal(
        sum(vapply(dot_traces, function(trace) if (is.null(trace$x)) 0L else length(trace$x), integer(1))),
        length(cells)
      )

      delete_request <- list(
        group_id = "g001",
        gene_id = "g001_gene_001",
        object = "sample",
        context_revision = 1L,
        nonce = 1
      )
      session$setInputs(recluster_new_expr_gene_delete_event = delete_request)
      session$flushReact()
      session$flushReact()
      deleted_state <- shared_data$all_seurat_objects$sample$obj@misc$analysis$data_browser_new$expression_selection
      testthat::expect_length(deleted_state$groups[[1L]]$genes, 0L)
    }
  )
})

testthat::test_that("expression range uses settled hydration and compact plot sizing", {
  source_file <- file.path(
    .db_test_root,
    "Content",
    "interface",
    "analysis",
    "page_data_browser_new.R"
  )
  source_text <- paste(readLines(source_file, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl(
    "post_settlement_revision <- recluster_new_data$expr_ui_render_revision",
    source_text,
    fixed = TRUE
  ))
  testthat::expect_true(grepl(
    "outputOptions(output, \"recluster_new_expr_active_range_ui\", suspendWhenHidden = FALSE)",
    source_text,
    fixed = TRUE
  ))
  testthat::expect_true(grepl(
    "outputOptions(output, \"recluster_new_expr_active_distribution\", suspendWhenHidden = FALSE)",
    source_text,
    fixed = TRUE
  ))
  testthat::expect_true(grepl(
    ".recluster-new-expr-range .shiny-plot-output",
    source_text,
    fixed = TRUE
  ))
  testthat::expect_true(grepl("height: 148px !important;", source_text, fixed = TRUE))
  testthat::expect_true(grepl("min-height: 0 !important;", source_text, fixed = TRUE))
  testthat::expect_true(grepl("max-width: 300px;", source_text, fixed = TRUE))
  testthat::expect_true(grepl("flex: 0 0 148px !important;", source_text, fixed = TRUE))
  testthat::expect_false(grepl("transform: translateX(-11px);", source_text, fixed = TRUE))
  testthat::expect_true(grepl("var fromCenter = fromHandle.position().left", source_text, fixed = TRUE))
  testthat::expect_true(grepl("var zeroLeft = fromCenter +", source_text, fixed = TRUE))
  testthat::expect_true(grepl("margin = list(l = 10, r = 10, t = 16, b = 8, pad = 0, autoexpand = FALSE)", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".recluster-new-expr-range .irs-grid-text", source_text, fixed = TRUE))
  testthat::expect_true(grepl("title = \"\",", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".expr_distribution_display_range <- function(full_rng)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("density_grid <- seq(display_rng[[1]], display_rng[[2]], length.out = 1024L)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("stats::density(", source_text, fixed = TRUE))
  testthat::expect_true(grepl("label = NULL,", source_text, fixed = TRUE))
  testthat::expect_true(grepl("xanchor = \"right\",", source_text, fixed = TRUE))
  testthat::expect_true(grepl("font = list(size = 12, color = \"#6b7280\")", source_text, fixed = TRUE))
  testthat::expect_true(grepl("adjust = 0.8,", source_text, fixed = TRUE))
  testthat::expect_true(grepl("dot_lane_count <-", source_text, fixed = TRUE))
  testthat::expect_true(grepl("min(48L, ceiling(sqrt(length(vals)) * 1.8))", source_text, fixed = TRUE))
  testthat::expect_true(grepl("plot_value = as.numeric(plot_values)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("min = display_rng[[1]],", source_text, fixed = TRUE))
  testthat::expect_true(grepl("range = display_rng,", source_text, fixed = TRUE))
  testthat::expect_true(grepl("range = c(-plot_y_max * 0.08, plot_y_max)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("confirmed_plot_context_key = \"\"", source_text, fixed = TRUE))
  testthat::expect_true(grepl("plot_context_confirmed", source_text, fixed = TRUE))
  testthat::expect_true(grepl("zero_shape <-", source_text, fixed = TRUE))
  testthat::expect_true(grepl("zeroGridTick.text('0.00')", source_text, fixed = TRUE))
  testthat::expect_true(grepl("grid.find('.irs-grid-pol:not(.small)')", source_text, fixed = TRUE))
  testthat::expect_false(grepl("<span class=\\\"recluster-new-expr-zero-tick\\\">", source_text, fixed = TRUE))
  testthat::expect_false(grepl("negative_width", source_text, fixed = TRUE))
  testthat::expect_false(grepl("width: calc(100% - 22px) !important;", source_text, fixed = TRUE))
  testthat::expect_false(grepl("width: calc(100% - 8px) !important;", source_text, fixed = TRUE))
  testthat::expect_false(grepl("margin-left: 11px !important;", source_text, fixed = TRUE))
  testthat::expect_true(grepl("host.find('.irs-min, .irs-max')", source_text, fixed = TRUE))
  testthat::expect_true(grepl(".expr_without_active_gene_focus <- function(state)", source_text, fixed = TRUE))
})

testthat::test_that("Plotly selection sources subscribe directly and validate object revision", {
  source_file <- file.path(
    .db_test_root,
    "Content",
    "interface",
    "analysis",
    "page_data_browser_new.R"
  )
  source_text <- paste(readLines(source_file, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl(
    ".plotly_selection_event_data <- function(event_name, source)",
    source_text,
    fixed = TRUE
  ))
  testthat::expect_true(grepl(
    "plotly::event_data(event_name, source = source)",
    source_text,
    fixed = TRUE
  ))
  testthat::expect_false(grepl(".plotly_event_source_is_active <- function(source)", source_text, fixed = TRUE))
  testthat::expect_false(grepl(".plotly_event_data_if_active <- function(event_name, source)", source_text, fixed = TRUE))
  testthat::expect_false(grepl('.plotly_selection_event_data("plotly_deselect"', source_text, fixed = TRUE))
  testthat::expect_false(grepl('event_register("plotly_deselect")', source_text, fixed = TRUE))
  testthat::expect_true(grepl(".plotly_selection_key_prefix <- function()", source_text, fixed = TRUE))
  testthat::expect_true(grepl('modeBarButtonsToAdd = c("lasso2d", "select2d")', source_text, fixed = TRUE))
  testthat::expect_true(grepl('id = "recluster_new_lasso_selection_card"', source_text, fixed = TRUE))
  testthat::expect_true(grepl('selected <- unique(c(group_cells, manual_cells))', source_text, fixed = TRUE))
  testthat::expect_true(grepl('selected <- unique(as.character(enabled_group_cells() %||% character(0)))', source_text, fixed = TRUE))
  testthat::expect_true(grepl('source=violet_highlight', source_text, fixed = TRUE))
  testthat::expect_true(grepl('selected_cells_now <- checked_population_cells()', source_text, fixed = TRUE))
  testthat::expect_true(grepl('groups_now[[group_name]] <- list(cells = cells, enabled = TRUE', source_text, fixed = TRUE))
  testthat::expect_true(grepl('selection_saved_group', source_text, fixed = TRUE))
  testthat::expect_true(grepl('saved_group_highlight_color <- "#06B6D4"', source_text, fixed = TRUE))
  testthat::expect_true(grepl("min-height: 38px", source_text, fixed = TRUE))
  testthat::expect_true(grepl("font-size: 11px", source_text, fixed = TRUE))
  testthat::expect_true(grepl("font-size: 10px", source_text, fixed = TRUE))
  testthat::expect_true(grepl("width: 18px", source_text, fixed = TRUE))
  testthat::expect_true(grepl("width: 22px", source_text, fixed = TRUE))
  testthat::expect_true(grepl("min-height: 22px", source_text, fixed = TRUE))
  testthat::expect_true(grepl("border: 1px solid rgba(220, 38, 38, 0.62)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("background: transparent", source_text, fixed = TRUE))
  testthat::expect_true(grepl("color: rgba(220, 38, 38, 0.62)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("font-size: 9px", source_text, fixed = TRUE))
  testthat::expect_true(grepl("width: 1em", source_text, fixed = TRUE))
  testthat::expect_true(grepl("recluster-new-create-feedback", source_text, fixed = TRUE))
  testthat::expect_true(grepl("window.WLSpinnerOverlay.show", source_text, fixed = TRUE))
  testthat::expect_true(grepl("window.WLSpinnerOverlay.hide", source_text, fixed = TRUE))
  testthat::expect_true(grepl("button.disabled = true", source_text, fixed = TRUE))
  testthat::expect_true(grepl("on.exit(.recluster_new_send_create_feedback(\"open_finished\"), add = TRUE)", source_text, fixed = TRUE))
  testthat::expect_true(grepl("on.exit(.recluster_new_send_create_feedback(\"create_finished\"), add = TRUE)", source_text, fixed = TRUE))
  testthat::expect_true(grepl('t_text_subset_note', source_text, fixed = TRUE))
  testthat::expect_true(grepl('recluster_new_data$expr_ui_staged_state <- NULL', source_text, fixed = TRUE))
  testthat::expect_true(grepl('recluster_new_expr_gene_delete_event', source_text, fixed = TRUE))
  testthat::expect_true(grepl('observeEvent(input[[.expr_gene_delete_event_id()]]', source_text, fixed = TRUE))
  testthat::expect_false(grepl('recluster_new_event_allowed(paste0("expr_control:"', source_text, fixed = TRUE))
  testthat::expect_true(grepl(
    "plot_ly(source = \"recluster_new_plot_source\")",
    source_text,
    fixed = TRUE
  ))
  testthat::expect_true(grepl(
    "plot_ly(source = \"recluster_new_rule_plot_source\")",
    source_text,
    fixed = TRUE
  ))
  testthat::expect_false(grepl(
    "observeEvent(event_data(\"plotly_",
    source_text,
    fixed = TRUE
  ))
})

testthat::test_that("saving a lasso selection keeps one shared saved-group state", {
  required <- c(
    "shiny", "shinyjs", "shinybusy", "bslib", "shinycssloaders",
    "rhandsontable", "plotly", "shinyWidgets", "shinyFiles", "fs", "DT",
    "colourpicker", "ggplot2", "patchwork", "Seurat", "SeuratObject", "jsonlite"
  )
  if (!all(vapply(required, requireNamespace, logical(1), quietly = TRUE))) {
    testthat::skip("project runtime packages are not available")
  }

  old_wd <- getwd()
  setwd(file.path(.db_test_root, "Content"))
  on.exit(setwd(old_wd), add = TRUE)

  app_env <- new.env(parent = globalenv())
  suppressMessages(suppressWarnings(sys.source("app.R", envir = app_env)))

  cells <- paste0("cell_", seq_len(40L))
  counts <- matrix(
    1,
    nrow = 2L,
    ncol = length(cells),
    dimnames = list(c("Gene1", "Gene2"), cells)
  )
  obj <- Seurat::CreateSeuratObject(counts = counts, assay = "RNA")
  obj <- Seurat::NormalizeData(obj, verbose = FALSE)
  obj[["umap"]] <- SeuratObject::CreateDimReducObject(
    embeddings = matrix(
      seq_len(length(cells) * 2L),
      ncol = 2L,
      dimnames = list(cells, c("UMAP_1", "UMAP_2"))
    ),
    key = "UMAP_",
    assay = "RNA"
  )
  obj@misc$analysis <- list(
    data_browser_new = list(
        saved_groups = list(
          `Loaded group` = list(
          cells = cells[31:40],
          enabled = TRUE,
          metadata_col = ""
        )
      )
    )
  )

  shared_data <- shiny::reactiveValues(
    all_seurat_objects = list(sample = list(
      obj = obj,
      prefs = list(),
      plots = list(),
      analysis_cache = list(),
      meta = list()
    )),
    active_object_name = "sample",
    full_sample_sheet = data.frame(),
    object_prefs = list(),
    active_environment = list(name = "", path = ""),
    analysis_params_by_page = list()
  )

  shiny::testServer(
    function(input, output, session) {
      app_env$recluster_new_server(input, output, session, shared_data)
    },
    {
      session$setInputs(
        main_navbar = "recluster_new_tab",
        recluster_new_tabs = "umap",
        recluster_new_workspace_tabs = "Selection Workspace"
      )
      session$flushReact()
      session$flushReact()

      stored_landing_obj <- shared_data$all_seurat_objects$sample$obj
      stored_landing_groups <- stored_landing_obj@misc$analysis$data_browser_new$saved_groups
      testthat::expect_false(isTRUE(stored_landing_groups[["Loaded group"]]$enabled))
      landing_groups_ui <- paste(as.character(output$recluster_new_cell_groups_ui), collapse = "")
      testthat::expect_match(
        landing_groups_ui,
        "data-recluster-saved-group-canonical-enabled=\"0\""
      )
      testthat::expect_match(landing_groups_ui, "autocomplete=\"off\"")
      testthat::expect_match(landing_groups_ui, "data-wl-autofill-guard=\"true\"")
      session$setInputs(`recluster_new_group_enabled__Loaded_group` = TRUE)
      session$flushReact()
      restored_input_groups <- shared_data$all_seurat_objects$sample$obj@misc$analysis$data_browser_new$saved_groups
      testthat::expect_false(isTRUE(restored_input_groups[["Loaded group"]]$enabled))
      plot_text <- paste(as.character(output$recluster_new_umap_plot), collapse = "")
      testthat::expect_false(grepl("#7C3AED", toupper(plot_text), fixed = TRUE))
      testthat::expect_false(grepl("#06B6D4", toupper(plot_text), fixed = TRUE))
      session$setInputs(
        recluster_new_saved_group_toggle_event = list(
          id = "recluster_new_group_enabled__Loaded_group",
          enabled = TRUE
        )
      )
      session$flushReact()
      plot_text_on <- paste(as.character(output$recluster_new_umap_plot), collapse = "")
      testthat::expect_true(grepl("#06B6D4", toupper(plot_text_on), fixed = TRUE))
      testthat::expect_false(grepl("#7C3AED", toupper(plot_text_on), fixed = TRUE))
      count_text_on <- paste(as.character(output$recluster_new_final_cell_count_output), collapse = "")
      testthat::expect_match(count_text_on, "10 cells")
      session$setInputs(
        recluster_new_group_name = "Cyan only",
        recluster_new_add_selection_btn = 1
      )
      session$flushReact()
      cyan_only_groups <- shared_data$all_seurat_objects$sample$obj@misc$analysis$data_browser_new$saved_groups
      testthat::expect_false("Cyan only" %in% names(cyan_only_groups))
      context_match <- regexpr("dbctx:[0-9]+::", plot_text_on, perl = TRUE)
      testthat::expect_true(context_match[[1L]] > 0L)
      context_prefix <- regmatches(plot_text_on, context_match)[[1L]]
      selected_other <- data.frame(
        key = paste0(context_prefix, cells[21:30]),
        stringsAsFactors = FALSE
      )
      session$setInputs(
        `plotly_selected-recluster_new_plot_source` = jsonlite::toJSON(selected_other, auto_unbox = TRUE)
      )
      session$flushReact()
      plot_text_both <- paste(as.character(output$recluster_new_umap_plot), collapse = "")
      testthat::expect_true(grepl("#06B6D4", toupper(plot_text_both), fixed = TRUE))
      testthat::expect_true(grepl("#7C3AED", toupper(plot_text_both), fixed = TRUE))
      count_text_both <- paste(as.character(output$recluster_new_final_cell_count_output), collapse = "")
      testthat::expect_match(count_text_both, "10 cells")
      session$setInputs(
        recluster_new_saved_group_toggle_event = list(
          id = "recluster_new_group_enabled__Loaded_group",
          enabled = FALSE
        )
      )
      session$flushReact()
      plot_text_off <- paste(as.character(output$recluster_new_umap_plot), collapse = "")
      testthat::expect_true(grepl("#7C3AED", toupper(plot_text_off), fixed = TRUE))
      testthat::expect_false(grepl("#06B6D4", toupper(plot_text_off), fixed = TRUE))
      count_text_off <- paste(as.character(output$recluster_new_final_cell_count_output), collapse = "")
      testthat::expect_match(count_text_off, "0 cells")
      session$setInputs(recluster_new_clear_lasso_btn = 1)
      session$flushReact()
      plot_text_cleared <- paste(as.character(output$recluster_new_umap_plot), collapse = "")
      testthat::expect_false(grepl("#7C3AED", toupper(plot_text_cleared), fixed = TRUE))
      testthat::expect_false(grepl("#06B6D4", toupper(plot_text_cleared), fixed = TRUE))
      count_text_cleared <- paste(as.character(output$recluster_new_final_cell_count_output), collapse = "")
      testthat::expect_match(count_text_cleared, "0 cells")
      selected <- data.frame(
        key = paste0(context_prefix, cells[seq_len(10L)]),
        stringsAsFactors = FALSE
      )
      session$setInputs(
        `plotly_selected-recluster_new_plot_source` = jsonlite::toJSON(selected, auto_unbox = TRUE)
      )
      session$flushReact()
      plot_text_lasso <- paste(as.character(output$recluster_new_umap_plot), collapse = "")
      testthat::expect_true(grepl("#7C3AED", toupper(plot_text_lasso), fixed = TRUE))
      testthat::expect_false(grepl("#06B6D4", toupper(plot_text_lasso), fixed = TRUE))

      # A stale checked saved group must not enlarge the current lasso capture.
      session$setInputs(
        recluster_new_saved_group_toggle_event = list(
          id = "recluster_new_group_enabled__Loaded_group",
          enabled = TRUE
        )
      )
      session$flushReact()

      session$setInputs(
        recluster_new_group_name = "Pure T cells",
        recluster_new_add_selection_btn = 1
      )
      session$flushReact()
      session$flushReact()

      stored_obj <- shared_data$all_seurat_objects$sample$obj
      stored_groups <- stored_obj@misc$analysis$data_browser_new$saved_groups
      testthat::expect_true("Pure T cells" %in% names(stored_groups))
      testthat::expect_identical(
        sort(stored_groups[["Pure T cells"]]$cells),
        sort(cells[seq_len(10L)])
      )
      testthat::expect_true(isTRUE(stored_groups[["Pure T cells"]]$enabled))
      testthat::expect_false(isTRUE(stored_groups[["Loaded group"]]$enabled))
      testthat::expect_equal(
        sum(vapply(stored_groups, function(group) isTRUE(group$enabled), logical(1))),
        1L
      )
      testthat::expect_true(any(grepl("^saved_group_Pure_T_cells", colnames(stored_obj@meta.data))))
      plot_text_saved <- paste(as.character(output$recluster_new_umap_plot), collapse = "")
      testthat::expect_true(grepl("#06B6D4", toupper(plot_text_saved), fixed = TRUE))
      groups_ui <- paste(as.character(output$recluster_new_cell_groups_ui), collapse = "")
      testthat::expect_match(groups_ui, "Pure T cells")
      count_text_saved <- paste(as.character(output$recluster_new_final_cell_count_output), collapse = "")
      testthat::expect_match(count_text_saved, "10 cells")
    }
  )
})
