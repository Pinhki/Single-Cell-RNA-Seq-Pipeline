MONOCLE3_UI_TEXT <- list(
  title = "Analysis: Monocle3",
  subtitle = "Run guarded Monocle3 preprocessing, graph learning, and pseudotime ordering on a selected Seurat object.",
  runtime_title = "Runtime preflight",
  runtime_missing = "Monocle3 is unavailable in the active project environment. This page remains navigable; install it through the project environment workflow before running.",
  object = "Object",
  assay = "Assay",
  dimensions = "PCA dimensions",
  group = "Metadata/group column",
  root_mode = "Root/order mode",
  root_first = "First cell",
  root_group = "Metadata group",
  root_graph = "First graph node",
  root_unrooted = "Unrooted",
  root_value = "Root metadata value",
  run = "Run Monocle3",
  clear = "Clear Monocle3 result and overlay",
  preview = "Monocle3 trajectory preview",
  status_ready = "Ready. Confirm runtime preflight, choose an object, then run Monocle3.",
  result_title = "Monocle3 Result Object",
  no_result = "Run or import a valid Monocle3 result to preview the trajectory.",
  invalid_result = "Imported object is not a valid Monocle3 trajectory result.",
  graph_note = "The overlay stores principal-graph edges when Monocle3 exposes them; no graph line is fabricated when unavailable.",
  plot_settings = "Plot settings",
  plot_color = "Color by",
  plot_annotation = "Annotation",
  plot_pseudotime = "Pseudotime",
  plot_palette = "Annotation palette",
  plot_metadata_palette = "Metadata palette",
  plot_manual_palette = "Manual palette map (JSON)",
  plot_group_labels = "Label cell groups",
  plot_leaf_labels = "Label leaves",
  plot_branch_labels = "Label branch points",
  plot_graph = "Show trajectory graph",
  plot_width = "Export width (inches)",
  plot_height = "Export height (inches)",
  plot_dpi = "Export dpi"
)

`%||%` <- function(a, b) if (is.null(a)) b else a

monocle3_ui <- fluidPage(
  class = "plotting-page advanced-analysis-page",
  div(class = "page-header", h2(icon("project-diagram"), " ", MONOCLE3_UI_TEXT$title, " ", tags$span("beta", class = "beta-badge")), p(MONOCLE3_UI_TEXT$subtitle)),
  fluidRow(
    column(
      3,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        uiOutput("monocle3_runtime_ui"),
        tags$hr(),
        selectInput("monocle3_object", MONOCLE3_UI_TEXT$object, choices = character(0)),
        selectInput("monocle3_assay", MONOCLE3_UI_TEXT$assay, choices = character(0)),
        numericInput("monocle3_num_dim", MONOCLE3_UI_TEXT$dimensions, value = 50, min = 2, max = 200, step = 1),
        selectInput("monocle3_group_by", MONOCLE3_UI_TEXT$group, choices = c("(None)" = ""), selected = ""),
        selectInput("monocle3_root_mode", MONOCLE3_UI_TEXT$root_mode, choices = stats::setNames(c("unrooted", "first_cell", "metadata_group", "graph_node"), c(MONOCLE3_UI_TEXT$root_unrooted, MONOCLE3_UI_TEXT$root_first, MONOCLE3_UI_TEXT$root_group, MONOCLE3_UI_TEXT$root_graph)), selected = "unrooted"),
        selectInput("monocle3_root_value", MONOCLE3_UI_TEXT$root_value, choices = character(0), selected = ""),
        tags$hr(),
        h5(MONOCLE3_UI_TEXT$plot_settings),
        selectInput("monocle3_plot_color", MONOCLE3_UI_TEXT$plot_color, choices = stats::setNames(c("annotation", "pseudotime"), c(MONOCLE3_UI_TEXT$plot_annotation, MONOCLE3_UI_TEXT$plot_pseudotime)), selected = "annotation"),
        selectInput("monocle3_plot_palette", MONOCLE3_UI_TEXT$plot_palette, choices = stats::setNames(c("metadata", "manual"), c(MONOCLE3_UI_TEXT$plot_metadata_palette, "Manual")), selected = "metadata"),
        textAreaInput("monocle3_plot_manual_palette", MONOCLE3_UI_TEXT$plot_manual_palette, value = "{}", rows = 2),
        checkboxInput("monocle3_plot_group_labels", MONOCLE3_UI_TEXT$plot_group_labels, value = FALSE),
        checkboxInput("monocle3_plot_leaf_labels", MONOCLE3_UI_TEXT$plot_leaf_labels, value = FALSE),
        checkboxInput("monocle3_plot_branch_labels", MONOCLE3_UI_TEXT$plot_branch_labels, value = FALSE),
        checkboxInput("monocle3_plot_graph", MONOCLE3_UI_TEXT$plot_graph, value = TRUE),
        fluidRow(column(4, numericInput("monocle3_plot_width", MONOCLE3_UI_TEXT$plot_width, value = 8, min = 1)), column(4, numericInput("monocle3_plot_height", MONOCLE3_UI_TEXT$plot_height, value = 7, min = 1)), column(4, numericInput("monocle3_plot_dpi", MONOCLE3_UI_TEXT$plot_dpi, value = 300, min = 72))),
        actionButton("monocle3_run_btn", MONOCLE3_UI_TEXT$run, class = "btn btn-primary btn-sm"),
        actionButton("monocle3_clear_btn", MONOCLE3_UI_TEXT$clear, class = "btn btn-outline-secondary btn-sm"),
        tags$hr(),
        uiOutput("monocle3_status_ui"),
        tags$hr(),
        div(class = "alert alert-info p-2 small", tags$strong("Overlay storage"), tags$br(), MONOCLE3_UI_TEXT$graph_note),
        tags$hr(),
        beta_result_object_controls_ui(id_prefix = "monocle3_result_io", title = MONOCLE3_UI_TEXT$result_title)
      )
    ),
    column(
      9,
      div(
        class = "plot_area_card_style",
        h4(MONOCLE3_UI_TEXT$preview),
        uiOutput("monocle3_empty_ui"),
        plotlyOutput("monocle3_preview_plot", height = "560px")
      )
    )
  )
)

monocle3_server <- function(input, output, session, shared_data) {
  .safe_first <- function(x, default = "") if (length(x)) as.character(x[[1L]]) else default
  .plot_settings <- function() {
    manual <- tryCatch(jsonlite::fromJSON(as.character(input$monocle3_plot_manual_palette %||% "{}"), simplifyVector = TRUE), error = function(e) list())
    if (!is.list(manual)) manual <- list()
    trajectory_plot_settings_normalize(list(monocle3 = list(
      color_by = input$monocle3_plot_color %||% "annotation",
      palette_source = input$monocle3_plot_palette %||% "metadata",
      palette = manual,
      label_cell_groups = isTRUE(input$monocle3_plot_group_labels),
      label_leaves = isTRUE(input$monocle3_plot_leaf_labels),
      label_branch_points = isTRUE(input$monocle3_plot_branch_labels),
      show_trajectory_graph = isTRUE(input$monocle3_plot_graph),
      width = input$monocle3_plot_width %||% 8,
      height = input$monocle3_plot_height %||% 7,
      dpi = input$monocle3_plot_dpi %||% 300
    )))
  }
  rv <- reactiveValues(
    runtime = NULL,
    status = MONOCLE3_UI_TEXT$status_ready,
    traj_dat = NULL,
    last_error = ""
  )

  .publish_overlay <- function(result, object_name = input$monocle3_object) {
    record <- monocle3_beta_record_overlay(result)
    registry <- shared_data$all_seurat_objects %||% list()
    nm <- as.character(object_name %||% "")[[1L]]
    if (!nzchar(nm) || is.null(registry[[nm]])) stop("Monocle3 overlay target object is unavailable.", call. = FALSE)
    entry <- registry[[nm]]
    sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (!inherits(sobj, "Seurat")) stop("Monocle3 overlay target is not a Seurat object.", call. = FALSE)
    sobj <- trajectory_overlay_write(sobj, record)
    if (is.list(entry) && !is.null(entry$obj)) entry$obj <- sobj else entry <- sobj
    registry[[nm]] <- entry
    shared_data$all_seurat_objects <- registry
    invisible(TRUE)
  }

  .active_registry_put <- function(object_name, fn) {
    registry <- shared_data$all_seurat_objects %||% list()
    entry <- registry[[object_name]]
    sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (!inherits(sobj, "Seurat")) stop("Selected object is not a Seurat object.", call. = FALSE)
    sobj <- fn(sobj)
    if (is.list(entry) && !is.null(entry$obj)) entry$obj <- sobj else entry <- sobj
    registry[[object_name]] <- entry
    shared_data$all_seurat_objects <- registry
    invisible(TRUE)
  }

  beta_result_object_controls_server(
    input = input,
    output = output,
    session = session,
    shared_data = shared_data,
    id_prefix = "monocle3_result_io",
    get_current_object = function() rv$traj_dat,
    set_current_object = function(obj) {
      if (!is.list(obj) || is.null(obj$emb)) stop(MONOCLE3_UI_TEXT$invalid_result, call. = FALSE)
      obj$provenance <- list(source = "imported_result")
      invisible(monocle3_beta_record_overlay(obj))
      rv$traj_dat <- obj
      rv$last_error <- ""
      rv$status <- "Imported Monocle3 trajectory result is now active."
      .publish_overlay(obj)
    },
    write_metadata_to_active_object = function(res_obj, sobj) {
      d <- res_obj %||% rv$traj_dat
      if (!is.list(d) || is.null(d$emb)) stop("Monocle3 result is missing trajectory coordinates.", call. = FALSE)
      cells <- rownames(sobj@meta.data)
      source_cells <- as.character(d$emb$cell %||% character(0))
      map <- match(cells, source_cells)
      added <- character(0)
      if (!is.null(d$pseudotime)) {
        pt <- rep(NA_real_, length(cells))
        values <- suppressWarnings(as.numeric(d$pseudotime))
        pt[!is.na(map)] <- values[map[!is.na(map)]]
        if (any(is.finite(pt))) {
          sobj[["monocle3_pseudotime"]] <- pt
          added <- c(added, "monocle3_pseudotime")
        }
      }
      state <- as.character(d$state %||% character(0))
      if (length(state) == length(source_cells)) {
        mapped_state <- rep(NA_character_, length(cells))
        mapped_state[!is.na(map)] <- state[map[!is.na(map)]]
        if (any(nzchar(mapped_state), na.rm = TRUE)) {
          sobj[["monocle3_state"]] <- mapped_state
          added <- c(added, "monocle3_state")
        }
      }
      if (!length(added)) stop("No writable Monocle3 cell-level metadata was found.", call. = FALSE)
      list(obj = sobj, added_cols = added)
    },
    default_workspace_name = "monocle3_result"
  )

  observeEvent(TRUE, {
    rv$runtime <- tryCatch(monocle3_beta_runtime_guard(), error = function(e) list(ok = FALSE, summary = conditionMessage(e), issues = conditionMessage(e), versions = list(monocle3 = NA_character_), paths = list(monocle3 = "")))
  }, once = TRUE, ignoreInit = FALSE)

  output$monocle3_runtime_ui <- renderUI({
    chk <- rv$runtime %||% list(ok = FALSE, summary = "Runtime check has not completed yet.", versions = list(monocle3 = NA_character_), paths = list(monocle3 = ""))
    div(
      class = if (isTRUE(chk$ok)) "alert alert-success p-2 mb-2 small" else "alert alert-danger p-2 mb-2 small",
      tags$strong(MONOCLE3_UI_TEXT$runtime_title), tags$br(),
      as.character(chk$summary %||% MONOCLE3_UI_TEXT$runtime_missing), tags$br(),
      tags$code(sprintf("monocle3=%s", chk$versions$monocle3 %||% "NA")), tags$br(),
      tags$code(as.character(chk$paths$monocle3 %||% "NA"))
    )
  })

  output$monocle3_status_ui <- renderUI({
    if (nzchar(rv$last_error %||% "")) div(class = "alert alert-danger p-2 mb-0", rv$last_error) else div(class = "small text-muted", rv$status)
  })

  observe({
    nms <- monocle3_beta_object_names(shared_data)
    cur <- isolate(input$monocle3_object %||% "")
    active <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")[[1L]]
    selected <- if (nzchar(cur) && cur %in% nms) cur else if (nzchar(active) && active %in% nms) active else .safe_first(nms)
    updateSelectInput(session, "monocle3_object", choices = nms, selected = selected)
  })

  observe({
    obj <- monocle3_beta_get_object(shared_data, input$monocle3_object)
    if (is.null(obj)) {
      updateSelectInput(session, "monocle3_assay", choices = character(0), selected = "")
      updateSelectInput(session, "monocle3_group_by", choices = c("(None)" = ""), selected = "")
      updateSelectInput(session, "monocle3_root_value", choices = character(0), selected = "")
      return(invisible(NULL))
    }
    assays <- monocle3_beta_assays(obj)
    current_assay <- as.character(input$monocle3_assay %||% "")[[1L]]
    updateSelectInput(session, "monocle3_assay", choices = assays, selected = if (current_assay %in% assays) current_assay else monocle3_beta_default_assay(obj))
    cols <- monocle3_beta_meta_cols(obj)
    current_group <- as.character(input$monocle3_group_by %||% "")[[1L]]
    group <- if (current_group %in% cols) current_group else monocle3_beta_default_group(cols)
    updateSelectInput(session, "monocle3_group_by", choices = c("(None)" = "", setNames(cols, cols)), selected = group)
    if (identical(input$monocle3_root_mode %||% "first_cell", "metadata_group") && nzchar(group) && group %in% colnames(obj@meta.data)) {
      values <- sort(unique(as.character(obj@meta.data[[group]])))
      values <- values[!is.na(values) & nzchar(values)]
      updateSelectInput(session, "monocle3_root_value", choices = values, selected = .safe_first(values))
    } else updateSelectInput(session, "monocle3_root_value", choices = character(0), selected = "")
  })

  observeEvent(input$monocle3_run_btn, {
    overlay_show("Monocle3: building trajectory...")
    on.exit(overlay_hide(), add = TRUE)
    tryCatch({
      chk <- monocle3_beta_runtime_guard()
      rv$runtime <- chk
      validate(need(isTRUE(chk$ok), chk$summary))
      obj <- monocle3_beta_get_object(shared_data, input$monocle3_object)
      validate(need(!is.null(obj), "Selected object is unavailable."))
      dat <- monocle3_beta_run_trajectory(
        sobj = obj,
        assay = input$monocle3_assay,
        num_dim = as.integer(input$monocle3_num_dim %||% 50L),
        group_col = input$monocle3_group_by %||% "",
        root_mode = input$monocle3_root_mode %||% "unrooted",
        root_value = input$monocle3_root_value %||% "",
        reduction = "UMAP"
      )
      dat$plotting <- .plot_settings()
      .publish_overlay(dat)
      rv$traj_dat <- dat
      rv$last_error <- ""
      rv$status <- sprintf("Monocle3 run completed. Cells=%s | reduction=%s", nrow(dat$emb), dat$reduction)
    }, error = function(e) {
      rv$last_error <- paste("Monocle3 failed:", conditionMessage(e))
      rv$status <- "Run failed."
      showNotification(rv$last_error, type = "error", duration = NULL)
    })
  }, ignoreInit = TRUE)

  observeEvent(input$monocle3_clear_btn, {
    nm <- as.character(input$monocle3_object %||% "")[[1L]]
    tryCatch({
      if (nzchar(nm)) .active_registry_put(nm, function(obj) trajectory_overlay_remove(obj, "monocle3"))
      rv$traj_dat <- NULL
      rv$last_error <- ""
      rv$status <- "Monocle3 result and object overlay cleared."
    }, error = function(e) {
      rv$last_error <- paste("Could not clear Monocle3 overlay:", conditionMessage(e))
      showNotification(rv$last_error, type = "error", duration = NULL)
    })
  }, ignoreInit = TRUE)

  output$monocle3_empty_ui <- renderUI({
    if (is.null(rv$traj_dat)) div(class = "alert alert-info p-2 small", MONOCLE3_UI_TEXT$no_result) else NULL
  })

  output$monocle3_preview_plot <- plotly::renderPlotly({
    req(rv$traj_dat)
    dat <- rv$traj_dat
    emb <- as.data.frame(dat$emb, stringsAsFactors = FALSE)
    emb$pseudotime <- as.numeric(dat$pseudotime)
    emb$cell <- as.character(emb$cell)
    settings <- trajectory_plot_settings_normalize(dat$plotting %||% list())$monocle3
    emb$annotation <- as.character(dat$annotation %||% dat$group %||% rep("", nrow(emb)))
    if (identical(settings$color_by, "pseudotime")) {
      p <- plotly::plot_ly(emb, x = ~x, y = ~y, color = ~pseudotime, colors = grDevices::colorRampPalette(c("#2563EB", "#F97316"))(100), type = "scatter", mode = "markers", text = ~cell, hoverinfo = "text")
    } else {
      p <- plotly::plot_ly(emb, x = ~x, y = ~y, color = ~annotation, type = "scatter", mode = "markers", text = ~cell, hoverinfo = "text")
    }
    record <- trajectory_overlay_record_from_monocle3(dat, reduction = dat$reduction %||% "UMAP")
    projected <- trajectory_overlay_project(record, as.matrix(dat$emb[, c("x", "y"), drop = FALSE], dimnames = list(dat$emb$cell, c("x", "y"))))
    if (isTRUE(settings$show_trajectory_graph) && !is.null(projected$graph_edges) && nrow(projected$graph_edges)) {
      for (i in seq_len(nrow(projected$graph_edges))) {
        edge <- projected$graph_edges[i, , drop = FALSE]
        from <- projected$graph_nodes[as.character(edge$from), , drop = FALSE]
        to <- projected$graph_nodes[as.character(edge$to), , drop = FALSE]
        p <- plotly::add_trace(p, x = c(from[1, "x"], to[1, "x"]), y = c(from[1, "y"], to[1, "y"]), type = "scatter", mode = "lines", line = list(color = "#111827", width = 2), hoverinfo = "skip", showlegend = FALSE)
      }
    }
    if (isTRUE(settings$label_cell_groups) && any(nzchar(emb$annotation))) {
      labels <- stats::aggregate(cbind(x, y) ~ annotation, data = emb[nzchar(emb$annotation), , drop = FALSE], FUN = median)
      p <- plotly::add_trace(p, x = labels$x, y = labels$y, text = labels$annotation, type = "scatter", mode = "text", showlegend = FALSE, hoverinfo = "skip")
    }
    if ((isTRUE(settings$label_leaves) || isTRUE(settings$label_branch_points)) && !is.null(projected$graph_nodes) && nrow(projected$graph_nodes)) {
      degree <- table(c(as.character(projected$graph_edges$from), as.character(projected$graph_edges$to)))
      node_names <- rownames(projected$graph_nodes)
      keep <- (isTRUE(settings$label_leaves) & degree[node_names] == 1) | (isTRUE(settings$label_branch_points) & degree[node_names] > 2)
      keep[is.na(keep)] <- FALSE
      if (any(keep)) p <- plotly::add_trace(p, x = projected$graph_nodes[keep, 1], y = projected$graph_nodes[keep, 2], text = node_names[keep], type = "scatter", mode = "text", showlegend = FALSE, hoverinfo = "skip")
    }
    plotly::layout(p, title = if (identical(settings$color_by, "pseudotime")) "Monocle3 pseudotime" else "Monocle3 annotation", xaxis = list(title = paste0(dat$reduction, " 1")), yaxis = list(title = paste0(dat$reduction, " 2")))
  })
}
