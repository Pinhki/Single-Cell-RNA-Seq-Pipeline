NICHES_UI_TEXT <- list(
  title = "Analysis: NICHES",
  subtitle = "Run package-native NICHES communication profiling to resolve cell-cell ligand-receptor niches at single-cell resolution and inspect interaction embeddings and niche maps.",
  status_ready = "Ready. Run Step 1 to execute NICHES and verify interaction matrices, then run Step 2 to render final niche outputs."
)

`%||%` <- function(a, b) if (is.null(a)) b else a

niches_ui <- fluidPage(
  class = "plotting-page advanced-analysis-page",
  div(class = "page-header", h2(icon("network-wired"), " ", NICHES_UI_TEXT$title, " ", tags$span("alpha", class = "alpha-badge")), p(NICHES_UI_TEXT$subtitle)),
  fluidRow(
    column(
      3,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        tags$strong("Step 1: Run parameters"),
        selectInput("niches_object", "Object", choices = character(0)),
        selectInput("niches_assay", "Assay", choices = character(0)),
        selectInput("niches_grouping", "Grouping column (meta.data)", choices = character(0)),
        selectInput("niches_split_by", "Recompute split by (optional)", choices = c("(None)" = ""), selected = ""),
        selectizeInput("niches_split_levels", "Split levels (recompute each)", choices = character(0), selected = character(0), multiple = TRUE),
        selectInput("niches_view_split", "View split result", choices = c("All cells" = "__all__"), selected = "__all__"),
        selectInput("niches_species", "Species", choices = c("Human" = "human", "Mouse" = "mouse"), selected = "human"),
        selectInput("niches_lr_db", "Ligand-receptor database", choices = c("fantom5", "omnipath", "celltalkdb", "connectomeDB2020"), selected = "fantom5"),
        sliderInput("niches_neighbors", "Neighborhood k", min = 5, max = 100, value = 15, step = 1),
        sliderInput("niches_top_pairs", "Top interaction pairs", min = 20, max = 300, value = 80, step = 10),
        numericInput("niches_min_cells_ident", "Min cells per identity (optional)", value = NA, min = 1, step = 1),
        numericInput("niches_min_cells_gene", "Min cells per gene (optional)", value = NA, min = 1, step = 1),
        actionButton("niches_step1_run", "Run Step 1: Execute NICHES", class = "btn btn-outline-primary btn-sm"),
        tags$hr(),
        tags$strong("Step 2: Render outputs"),
        actionButton("niches_refresh", "Run Step 2: Render Niche Outputs", class = "btn btn-primary btn-sm"),
        tags$hr(),
        uiOutput("niches_status_ui"),
        tags$hr(),
        beta_result_object_controls_ui(
          id_prefix = "niches_result_io",
          title = "NICHES Result Object"
        )
      )
    ),
    column(
      9,
      tabsetPanel(
        id = "niches_workflow_tabs",
        tabPanel(
          "Step 1 Verify",
          div(
            class = "plot_area_card_style",
            uiOutput("niches_step1_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3", h4("Interaction matrix"), plotlyOutput("niches_step1_matrix_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Top sender-receiver pairs"), plotlyOutput("niches_step1_pairs_plot", height = "280px")))
            )
          )
        ),
        tabPanel(
          "Step 2 Outputs",
          div(
            class = "plot_area_card_style",
            uiOutput("niches_step2_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3", h4("Interaction embedding"), plotlyOutput("niches_embedding_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Ligand-receptor matrix"), plotlyOutput("niches_matrix_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Sender enrichment"), plotlyOutput("niches_enrich_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Niche map"), plotlyOutput("niches_map_plot", height = "280px")))
            )
          )
        )
      )
    )
  )
)

niches_server <- function(input, output, session, shared_data) {
  .safe_first <- function(x, default = "") if (length(x)) as.character(x[[1]]) else default
  .as_df <- function(x) {
    if (is.null(x)) return(data.frame())
    tryCatch(as.data.frame(x, stringsAsFactors = FALSE), error = function(e) data.frame())
  }
  .as_int_or_null <- function(x) {
    if (is.null(x) || !length(x) || is.na(x)) return(NULL)
    xv <- suppressWarnings(as.integer(x))
    if (!is.finite(xv) || is.na(xv)) return(NULL)
    if (xv <= 0L) return(NULL)
    xv
  }
  .split_levels_from_obj <- function(obj, split_col = "") {
    sc <- as.character(split_col %||% "")
    if (!nzchar(sc) || is.null(obj) || !inherits(obj, "Seurat")) return(character(0))
    md <- tryCatch(obj@meta.data, error = function(e) NULL)
    if (is.null(md) || !(sc %in% colnames(md))) return(character(0))
    vv <- as.character(md[[sc]])
    vv[is.na(vv) | !nzchar(vv)] <- "Unknown"
    sort(unique(vv), method = "radix")
  }
  .subset_obj_by_split <- function(obj, split_col = "", split_level = "") {
    sc <- as.character(split_col %||% "")
    sl <- as.character(split_level %||% "")
    if (!nzchar(sc) || !nzchar(sl)) return(obj)
    md <- tryCatch(obj@meta.data, error = function(e) NULL)
    if (is.null(md) || !(sc %in% colnames(md))) stop("Split column not found in metadata.")
    vv <- as.character(md[[sc]])
    vv[is.na(vv) | !nzchar(vv)] <- "Unknown"
    cells <- rownames(md)[vv %in% sl]
    if (!length(cells)) stop(sprintf("Split level '%s' has zero cells.", sl))
    subset(obj, cells = cells)
  }
  .sync_active_split_view <- function() {
    key <- as.character(input$niches_view_split %||% "__all__")
    if (!is.null(rv$step1_dat_by_split) && key %in% names(rv$step1_dat_by_split)) rv$step1_dat <- rv$step1_dat_by_split[[key]]
    if (!is.null(rv$dat_by_split) && key %in% names(rv$dat_by_split)) rv$dat <- rv$dat_by_split[[key]]
    invisible(NULL)
  }

  rv <- reactiveValues(status = NICHES_UI_TEXT$status_ready, step1_dat = NULL, dat = NULL, step1_dat_by_split = NULL, dat_by_split = NULL, last_error = "")
  beta_result_object_controls_server(
    input = input,
    output = output,
    session = session,
    shared_data = shared_data,
    id_prefix = "niches_result_io",
    get_current_object = function() rv$dat %||% rv$step1_dat,
    set_current_object = function(obj) {
      if (is.list(obj) && !is.null(obj$emb)) {
        rv$dat <- obj
        rv$status <- "Imported NICHES Step 2 result is now active."
        rv$last_error <- ""
        updateTabsetPanel(session, "niches_workflow_tabs", selected = "Step 2 Outputs")
      } else {
        rv$step1_dat <- obj
        rv$status <- "Imported NICHES Step 1 result is now active."
        rv$last_error <- ""
        updateTabsetPanel(session, "niches_workflow_tabs", selected = "Step 1 Verify")
      }
    },
    write_metadata_to_active_object = function(res_obj, sobj) {
      d <- res_obj
      if (is.null(d$sender) && !is.null(rv$dat)) d <- rv$dat
      if (is.null(d$sender) && !is.null(rv$step1_dat)) d <- rv$step1_dat
      if (is.null(d) || !is.list(d)) stop("NICHES result is missing.")

      gcol <- as.character(input$niches_grouping %||% "")
      if (!nzchar(gcol) || !(gcol %in% colnames(sobj@meta.data))) {
        stop("Select a valid grouping column before writing NICHES metadata.")
      }
      s <- .as_df(d$sender)
      if (!nrow(s) || !all(c("group", "score") %in% colnames(s))) {
        stop("No sender enrichment score table found in current NICHES result.")
      }
      grp <- as.character(sobj@meta.data[[gcol]])
      grp[is.na(grp) | !nzchar(grp)] <- "Unknown"
      map <- as.numeric(s$score); names(map) <- as.character(s$group)
      cn <- "niches_sender_enrichment"
      vv <- as.numeric(map[grp]); vv[is.na(vv)] <- 0
      sobj[[cn]] <- vv
      list(obj = sobj, added_cols = c(cn))
    },
    default_workspace_name = "niches_result"
  )
  output$niches_status_ui <- renderUI({
    if (nzchar(rv$last_error %||% "")) {
      div(class = "alert alert-danger p-2 mb-0", rv$last_error)
    } else {
      div(class = "small text-muted", rv$status)
    }
  })

  observe({
    nms <- niches_beta_object_names(shared_data)
    cur <- isolate(input$niches_object %||% "")
    active_nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
    sel <- if (nzchar(cur) && cur %in% nms) cur else if (nzchar(active_nm) && active_nm %in% nms) active_nm else .safe_first(nms)
    updateSelectInput(session, "niches_object", choices = nms, selected = sel)
  })

  observeEvent(
    list(input$niches_object, shared_data$active_object_name, shared_data$all_seurat_objects, shared_data$filtered_objects),
    {
      overlay_show("NICHES: loading object metadata...")
      on.exit(overlay_hide(), add = TRUE)
      tryCatch({
        obj <- niches_beta_get_object(shared_data, input$niches_object)
        if (is.null(obj) || !inherits(obj, "Seurat")) {
          updateSelectInput(session, "niches_grouping", choices = character(0), selected = "")
          updateSelectInput(session, "niches_assay", choices = character(0), selected = "")
          return(invisible(NULL))
        }

        cols <- niches_beta_meta_cols(obj)
        cur_col <- isolate(input$niches_grouping %||% "")
        def_col <- if (nzchar(cur_col) && cur_col %in% cols) cur_col else niches_beta_default_group(cols)
        updateSelectInput(session, "niches_grouping", choices = cols, selected = def_col)
        split_cur <- isolate(input$niches_split_by %||% "")
        split_sel <- if (nzchar(split_cur) && split_cur %in% cols) split_cur else ""
        updateSelectInput(session, "niches_split_by", choices = c("(None)" = "", setNames(cols, cols)), selected = split_sel)
        split_levels <- .split_levels_from_obj(obj, split_sel)
        split_level_cur <- isolate(input$niches_split_levels %||% character(0))
        split_level_sel <- intersect(as.character(split_level_cur), split_levels)
        if (!length(split_level_sel) && length(split_levels) >= 2L) split_level_sel <- split_levels
        updateSelectizeInput(session, "niches_split_levels", choices = split_levels, selected = split_level_sel, server = TRUE)

        assays <- niches_beta_assays(obj)
        cur_assay <- isolate(input$niches_assay %||% "")
        def_assay <- if (nzchar(cur_assay) && cur_assay %in% assays) cur_assay else niches_beta_default_assay(obj)
        updateSelectInput(session, "niches_assay", choices = assays, selected = def_assay)
      }, error = function(e) {
        warning(sprintf("[niches][selectors] %s", conditionMessage(e)), call. = FALSE, immediate. = TRUE)
        updateSelectInput(session, "niches_grouping", choices = character(0), selected = "")
        updateSelectInput(session, "niches_split_by", choices = c("(None)" = ""), selected = "")
        updateSelectizeInput(session, "niches_split_levels", choices = character(0), selected = character(0), server = TRUE)
        updateSelectInput(session, "niches_assay", choices = character(0), selected = "")
      })
    },
    ignoreInit = FALSE
  )

  observeEvent(input$niches_split_by, {
    obj <- niches_beta_get_object(shared_data, input$niches_object)
    split_levels <- .split_levels_from_obj(obj, input$niches_split_by %||% "")
    split_level_cur <- isolate(input$niches_split_levels %||% character(0))
    split_level_sel <- intersect(as.character(split_level_cur), split_levels)
    if (!length(split_level_sel) && length(split_levels) >= 2L) split_level_sel <- split_levels
    updateSelectizeInput(session, "niches_split_levels", choices = split_levels, selected = split_level_sel, server = TRUE)
  }, ignoreInit = TRUE)

  observeEvent(input$niches_view_split, {
    .sync_active_split_view()
  }, ignoreInit = TRUE)

  observeEvent(input$niches_step1_run, {
    overlay_show("NICHES Step 1: executing package-native RunNICHES...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "NICHES Step 1", value = 0, {
      tryCatch({
        setProgress(value = 0.1, detail = "Validating object and grouping")
        obj <- niches_beta_get_object(shared_data, input$niches_object)
        validate(need(!is.null(obj) && inherits(obj, "Seurat"), "Selected object is unavailable."))
        validate(need(input$niches_grouping %in% colnames(obj@meta.data), "Choose a valid metadata grouping column."))

        setProgress(value = 0.35, detail = "Running package-native NICHES")
        split_col <- as.character(input$niches_split_by %||% "")
        split_levels <- as.character(input$niches_split_levels %||% character(0))
        use_split <- nzchar(split_col) && length(split_levels) >= 2L
        run_levels <- if (use_split) split_levels else "__all__"
        dat_by_split <- list()
        for (ii in seq_along(run_levels)) {
          lv <- run_levels[[ii]]
          run_obj <- if (identical(lv, "__all__")) obj else .subset_obj_by_split(obj, split_col = split_col, split_level = lv)
          setProgress(value = min(0.85, 0.2 + 0.6 * (ii / max(1L, length(run_levels)))), detail = if (identical(lv, "__all__")) "Running NICHES (all cells)" else sprintf("Running NICHES split: %s=%s", split_col, lv))
          dat_by_split[[lv]] <- niches_beta_run(
            sobj = run_obj,
            group_col = input$niches_grouping,
            assay = input$niches_assay %||% NULL,
            species = input$niches_species %||% "human",
            lr_database = input$niches_lr_db %||% "fantom5",
            neighbors = as.integer(input$niches_neighbors %||% 15L),
            top_pairs = as.integer(input$niches_top_pairs %||% 80L),
            min_cells_per_ident = .as_int_or_null(input$niches_min_cells_ident),
            min_cells_per_gene = .as_int_or_null(input$niches_min_cells_gene)
          )
        }

        setProgress(value = 0.9, detail = "Preparing Step 1 verification outputs")
        rv$step1_dat_by_split <- dat_by_split
        view_choices <- if (use_split) setNames(names(dat_by_split), names(dat_by_split)) else c("All cells" = "__all__")
        view_sel <- if (use_split) .safe_first(names(dat_by_split)) else "__all__"
        updateSelectInput(session, "niches_view_split", choices = view_choices, selected = view_sel)
        rv$step1_dat <- dat_by_split[[view_sel]]
        rv$dat <- NULL
        rv$dat_by_split <- NULL

        rv$status <- sprintf(
          "Step 1 complete: object=%s, assay=%s, groups=%s",
          input$niches_object,
          rv$step1_dat$assay %||% (input$niches_assay %||% ""),
          nrow(rv$step1_dat$interaction %||% matrix(, 0, 0))
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 1 complete")
        updateTabsetPanel(session, "niches_workflow_tabs", selected = "Step 1 Verify")
      }, error = function(e) {
        rv$status <- paste("Step 1 failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[niches][step1] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  observeEvent(input$niches_refresh, {
    overlay_show("NICHES Step 2: rendering final niche outputs...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "NICHES Step 2", value = 0, {
      tryCatch({
        setProgress(value = 0.1, detail = "Validating Step 1 outputs")
        validate(need(!is.null(rv$step1_dat), "Run Step 1 first."))
        setProgress(value = 0.6, detail = "Rendering final niche outputs")
        validate(need(!is.null(rv$step1_dat_by_split) && length(rv$step1_dat_by_split), "Run Step 1 first."))
        rv$dat_by_split <- rv$step1_dat_by_split
        cur_key <- as.character(input$niches_view_split %||% "")
        if (!nzchar(cur_key) || !(cur_key %in% names(rv$dat_by_split))) cur_key <- .safe_first(names(rv$dat_by_split))
        rv$dat <- rv$dat_by_split[[cur_key]]

        rv$status <- sprintf(
          "Step 2 complete: species=%s, lr_db=%s",
          rv$dat$species %||% (input$niches_species %||% ""),
          rv$dat$lr_database %||% (input$niches_lr_db %||% "")
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 2 complete")
        updateTabsetPanel(session, "niches_workflow_tabs", selected = "Step 2 Outputs")
      }, error = function(e) {
        rv$status <- paste("Step 2 failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[niches][step2] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  .step1 <- reactive({ req(!is.null(rv$step1_dat)); rv$step1_dat })
  .dat <- reactive({ req(!is.null(rv$dat)); rv$dat })

  output$niches_step1_empty_ui <- renderUI({
    if (!is.null(rv$step1_dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No NICHES Step 1 plots yet. Run 'Run Step 1: Execute NICHES' first.",
      height_px = 92L
    )
  })
  output$niches_step2_empty_ui <- renderUI({
    if (!is.null(rv$dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No NICHES Step 2 plots yet. Run Step 1 first, then 'Run Step 2: Render Niche Outputs'.",
      height_px = 92L
    )
  })

  output$niches_step1_matrix_plot <- renderPlotly({
    d <- .step1()
    m <- d$interaction
    validate(need(is.matrix(m), "No interaction matrix available from Step 1."))
    plotly::plot_ly(z = m, x = colnames(m), y = rownames(m), type = "heatmap", colorscale = "RdBu")
  })

  output$niches_step1_pairs_plot <- renderPlotly({
    d <- .step1()
    p <- .as_df(d$pair_df)
    validate(need(nrow(p) > 0, "No sender-receiver pairs available from Step 1."))
    p <- utils::head(p[order(p$score, decreasing = TRUE), , drop = FALSE], 60)
    plotly::plot_ly(p, x = ~paste(sender, receiver, sep = "->"), y = ~score, type = "bar")
  })

  output$niches_embedding_plot <- renderPlotly({
    d <- .dat()
    emb <- .as_df(d$emb)
    validate(need(nrow(emb) > 0, "No interaction embedding available from Step 2."))
    emb_lbl <- if ("vector" %in% colnames(emb)) emb$vector else seq_len(nrow(emb))
    plotly::plot_ly(emb, x = ~x, y = ~y, text = emb_lbl, type = "scatter", mode = "markers")
  })

  output$niches_matrix_plot <- renderPlotly({
    d <- .dat()
    m <- d$interaction
    validate(need(is.matrix(m), "No ligand-receptor matrix available from Step 2."))
    plotly::plot_ly(z = m, x = colnames(m), y = rownames(m), type = "heatmap", colorscale = "RdBu")
  })

  output$niches_enrich_plot <- renderPlotly({
    d <- .dat()
    s <- .as_df(d$sender)
    validate(need(nrow(s) > 0, "No sender enrichment summary available from Step 2."))
    plotly::plot_ly(s, x = ~group, y = ~score, type = "bar")
  })

  output$niches_map_plot <- renderPlotly({
    d <- .dat()
    m <- .as_df(d$map_df)
    if (!nrow(m)) m <- .as_df(d$pair_df)
    validate(need(nrow(m) > 0, "No niche map data available from Step 2."))
    m <- utils::head(m[order(m$score, decreasing = TRUE), , drop = FALSE], 160)
    plotly::plot_ly(m, x = ~sender, y = ~receiver, type = "scatter", mode = "markers", size = ~score, color = ~score)
  })
}
