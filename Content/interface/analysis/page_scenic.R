PYSCENIC_UI_TEXT <- list(
  title = "Analysis: pySCENIC",
  subtitle = "Run package-native pySCENIC to infer gene-regulatory networks and regulon activity, then inspect TF programs across embeddings and metadata groups.",
  status_ready = "Ready. Run Step 1 preview to verify settings, then run Step 2 full pySCENIC workflow.",
  db_once_notice = "Database download happens once per species and is reused in future runs.",
  step2_notice = "Step 2 can take substantial time, especially GRN inference on large objects.",
  step3_notice = "After completion, outputs remain in the run directory for reuse and review."
)

`%||%` <- function(a, b) if (is.null(a)) b else a

scenic_ui <- fluidPage(
  class = "plotting-page advanced-analysis-page",
  div(class = "page-header", h2(icon("python"), " ", PYSCENIC_UI_TEXT$title, " ", tags$span("alpha", class = "alpha-badge")), p(PYSCENIC_UI_TEXT$subtitle)),
  fluidRow(
    column(
      3,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        tags$strong("Step 1: Preview parameters"),
        selectInput("scenic_object", "Object", choices = character(0)),
        selectInput("scenic_assay", "Assay", choices = character(0)),
        selectInput("scenic_group_by", "Group column (meta.data)", choices = character(0)),
        selectInput("scenic_split_by", "Recompute split by (optional)", choices = c("(None)" = ""), selected = ""),
        selectizeInput("scenic_split_levels", "Split levels (recompute each)", choices = character(0), selected = character(0), multiple = TRUE),
        selectInput("scenic_view_split", "View split result", choices = c("All cells" = "__all__"), selected = "__all__"),
        textInput("scenic_tf", "TF of interest", value = "SOX2"),
        sliderInput("scenic_top_regulons", "Top regulons", min = 5, max = 60, value = 15, step = 1),
        sliderInput("scenic_edge_n", "Top edges", min = 20, max = 300, value = 60, step = 10),
        actionButton("scenic_preview_run", "Run Step 1: Preview", class = "btn btn-outline-primary btn-sm"),
        tags$hr(),
        tags$strong("Step 2: Full-run parameters"),
        selectInput("scenic_species", "Species database", choices = c("Human (hg38)" = "hg38", "Mouse (mm10)" = "mm10"), selected = "hg38"),
        numericInput("scenic_workers", "Workers", value = 4, min = 1, step = 1),
        numericInput("scenic_max_cells", "Max cells for pySCENIC input", value = 3000, min = 500, step = 500),
        numericInput("scenic_max_genes", "Max genes for pySCENIC input", value = 4000, min = 500, step = 500),
        uiOutput("scenic_db_ui"),
        actionButton("scenic_download_db", "Download pySCENIC DB (one-time)", class = "btn btn-outline-primary btn-sm"),
        actionButton("scenic_refresh", "Run Step 2: Full pySCENIC", class = "btn btn-primary btn-sm"),
        tags$hr(),
        div(class = "alert alert-info p-2 small", strong("Notice"), tags$br(), PYSCENIC_UI_TEXT$db_once_notice),
        div(class = "alert alert-secondary p-2 small", strong("Compute"), tags$br(), PYSCENIC_UI_TEXT$step2_notice),
        div(class = "alert alert-secondary p-2 small", strong("Output"), tags$br(), PYSCENIC_UI_TEXT$step3_notice),
        uiOutput("scenic_status_ui"),
        tags$hr(),
        beta_result_object_controls_ui(
          id_prefix = "scenic_result_io",
          title = "pySCENIC Result Object"
        )
      )
    ),
    column(
      9,
      tabsetPanel(
        id = "scenic_workflow_tabs",
        tabPanel(
          "Step 1 Preview",
          div(
            class = "plot_area_card_style",
            uiOutput("scenic_step1_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3", h4("Preview regulon overlay"), plotlyOutput("scenic_preview_umap_plot", height = "270px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Preview regulon heatmap"), plotlyOutput("scenic_preview_heatmap_plot", height = "270px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Preview RSS"), plotlyOutput("scenic_preview_rss_plot", height = "270px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Preview target rank"), plotlyOutput("scenic_preview_target_rank_plot", height = "270px")))
            )
          )
        ),
        tabPanel(
          "Step 2 Full Outputs",
          div(
            class = "plot_area_card_style",
            uiOutput("scenic_step2_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3", h4("Regulon UMAP overlay"), plotlyOutput("scenic_umap_plot", height = "270px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Regulon heatmap"), plotlyOutput("scenic_heatmap_plot", height = "270px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("RSS summary"), plotlyOutput("scenic_rss_plot", height = "270px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Regulon distribution"), plotlyOutput("scenic_violin_plot", height = "270px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("TF-target network"), plotlyOutput("scenic_network_plot", height = "270px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Target rank"), plotlyOutput("scenic_target_rank_plot", height = "270px")))
            )
          )
        )
      )
    )
  )
)

scenic_server <- function(input, output, session, shared_data) {
  .safe_first <- function(x, default = "") if (length(x)) as.character(x[[1]]) else default
  .as_df <- function(x) {
    if (is.null(x)) return(data.frame())
    tryCatch(as.data.frame(x, stringsAsFactors = FALSE), error = function(e) data.frame())
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
    key <- as.character(input$scenic_view_split %||% "__all__")
    if (!is.null(rv$preview_dat_by_split) && key %in% names(rv$preview_dat_by_split)) rv$preview_dat <- rv$preview_dat_by_split[[key]]
    if (!is.null(rv$dat_by_split) && key %in% names(rv$dat_by_split)) rv$dat <- rv$dat_by_split[[key]]
    invisible(NULL)
  }

  rv <- reactiveValues(status = PYSCENIC_UI_TEXT$status_ready, preview_dat = NULL, dat = NULL, preview_dat_by_split = NULL, dat_by_split = NULL, last_error = "")
  beta_result_object_controls_server(
    input = input,
    output = output,
    session = session,
    shared_data = shared_data,
    id_prefix = "scenic_result_io",
    get_current_object = function() rv$dat %||% rv$preview_dat,
    set_current_object = function(obj) {
      if (is.list(obj) && !is.null(obj$run_dir)) {
        rv$dat <- obj
        rv$status <- "Imported pySCENIC full result is now active."
        rv$last_error <- ""
        updateTabsetPanel(session, "scenic_workflow_tabs", selected = "Step 2 Full Outputs")
      } else {
        rv$preview_dat <- obj
        rv$status <- "Imported pySCENIC preview result is now active."
        rv$last_error <- ""
        updateTabsetPanel(session, "scenic_workflow_tabs", selected = "Step 1 Preview")
      }
    },
    write_metadata_to_active_object = function(res_obj, sobj) {
      d <- res_obj
      if (is.null(d$tf_expr) && !is.null(rv$preview_dat)) d <- rv$preview_dat
      if (is.null(d) || !is.list(d)) stop("pySCENIC result is missing.")

      n_cells <- ncol(sobj)
      expr <- as.numeric(d$tf_expr %||% numeric(0))
      grp <- as.character(d$groups %||% character(0))
      if (length(expr) != n_cells) stop("pySCENIC TF score length does not match active Seurat cells.")

      tf_label <- make.names(as.character(d$tf_gene %||% "tf"))
      cn_expr <- paste0("scenic_tf_score_", tf_label)
      sobj[[cn_expr]] <- expr
      added <- c(cn_expr)

      if (length(grp) == n_cells) {
        cn_grp <- paste0("scenic_group_", tf_label)
        sobj[[cn_grp]] <- grp
        added <- c(added, cn_grp)
      }
      list(obj = sobj, added_cols = added)
    },
    default_workspace_name = "pyscenic_result"
  )
  db_refresh <- reactiveVal(0L)
  output$scenic_status_ui <- renderUI({
    if (nzchar(rv$last_error %||% "")) {
      div(class = "alert alert-danger p-2 mb-0", rv$last_error)
    } else {
      div(class = "small text-muted", rv$status)
    }
  })

  output$scenic_db_ui <- renderUI({
    db_refresh()
    req(nzchar(input$scenic_species %||% ""))
    st <- scenic_beta_db_status(input$scenic_species)
    py <- scenic_beta_python_status()
    missing <- st$files$file[!st$files$exists]
    size_txt <- sprintf("~%s MB total", format(round(st$total_mb), big.mark = ","))

    if (!isTRUE(py$pyscenic_exists)) {
      return(div(
        class = "alert alert-warning p-2 small",
        strong("pySCENIC runtime missing"), tags$br(),
        "Managed CLI not found: ", tags$code(py$pyscenic_bin), tags$br(),
        "Set up the Python env via ", tags$code("Content/run.R"), "."
      ))
    }

    if (length(missing)) {
      return(div(
        class = "alert alert-warning p-2 small",
        strong("Database not ready"), tags$br(),
        "Missing ", length(missing), " file(s), ", size_txt, ".", tags$br(),
        "Download is one-time and reused from: ", tags$code(st$db_dir)
      ))
    }

    div(
      class = "alert alert-success p-2 small",
      strong("Database ready"), tags$br(),
      "All files are present at: ", tags$code(st$db_dir), tags$br(),
      "Total footprint: ", size_txt, "."
    )
  })

  observe({
    nms <- scenic_beta_object_names(shared_data)
    cur <- isolate(input$scenic_object %||% "")
    active_nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
    sel <- if (nzchar(cur) && cur %in% nms) cur else if (nzchar(active_nm) && active_nm %in% nms) active_nm else .safe_first(nms)
    updateSelectInput(session, "scenic_object", choices = nms, selected = sel)
  })

  observeEvent(
    list(input$scenic_object, shared_data$active_object_name, shared_data$all_seurat_objects, shared_data$filtered_objects),
    {
      overlay_show("pySCENIC: loading object metadata...")
      on.exit(overlay_hide(), add = TRUE)
      tryCatch({
        obj <- scenic_beta_get_object(shared_data, input$scenic_object)
        if (is.null(obj) || !inherits(obj, "Seurat")) {
          updateSelectInput(session, "scenic_group_by", choices = character(0), selected = "")
          updateSelectInput(session, "scenic_assay", choices = character(0), selected = "")
          return(invisible(NULL))
        }

        cols <- scenic_beta_meta_cols(obj)
        cur_col <- isolate(input$scenic_group_by %||% "")
        def_col <- if (nzchar(cur_col) && cur_col %in% cols) cur_col else scenic_beta_default_group(cols)
        updateSelectInput(session, "scenic_group_by", choices = cols, selected = def_col)
        split_cur <- isolate(input$scenic_split_by %||% "")
        split_sel <- if (nzchar(split_cur) && split_cur %in% cols) split_cur else ""
        updateSelectInput(session, "scenic_split_by", choices = c("(None)" = "", setNames(cols, cols)), selected = split_sel)
        split_levels <- .split_levels_from_obj(obj, split_sel)
        split_level_cur <- isolate(input$scenic_split_levels %||% character(0))
        split_level_sel <- intersect(as.character(split_level_cur), split_levels)
        if (!length(split_level_sel) && length(split_levels) >= 2L) split_level_sel <- split_levels
        updateSelectizeInput(session, "scenic_split_levels", choices = split_levels, selected = split_level_sel, server = TRUE)

        assays <- scenic_beta_assays(obj)
        cur_assay <- isolate(input$scenic_assay %||% "")
        def_assay <- if (nzchar(cur_assay) && cur_assay %in% assays) cur_assay else scenic_beta_default_assay(obj)
        updateSelectInput(session, "scenic_assay", choices = assays, selected = def_assay)
      }, error = function(e) {
        warning(sprintf("[scenic][selectors] %s", conditionMessage(e)), call. = FALSE, immediate. = TRUE)
        updateSelectInput(session, "scenic_group_by", choices = character(0), selected = "")
        updateSelectInput(session, "scenic_split_by", choices = c("(None)" = ""), selected = "")
        updateSelectizeInput(session, "scenic_split_levels", choices = character(0), selected = character(0), server = TRUE)
        updateSelectInput(session, "scenic_assay", choices = character(0), selected = "")
      })
    },
    ignoreInit = FALSE
  )

  observeEvent(input$scenic_split_by, {
    obj <- scenic_beta_get_object(shared_data, input$scenic_object)
    split_levels <- .split_levels_from_obj(obj, input$scenic_split_by %||% "")
    split_level_cur <- isolate(input$scenic_split_levels %||% character(0))
    split_level_sel <- intersect(as.character(split_level_cur), split_levels)
    if (!length(split_level_sel) && length(split_levels) >= 2L) split_level_sel <- split_levels
    updateSelectizeInput(session, "scenic_split_levels", choices = split_levels, selected = split_level_sel, server = TRUE)
  }, ignoreInit = TRUE)

  observeEvent(input$scenic_view_split, {
    .sync_active_split_view()
  }, ignoreInit = TRUE)

  observeEvent(input$scenic_download_db, {
    overlay_show("Downloading pySCENIC databases (one-time)...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "pySCENIC DB Download", value = 0, {
      tryCatch({
        setProgress(value = 0.1, detail = "Checking existing database")
        st0 <- scenic_beta_db_status(input$scenic_species)
        if (isTRUE(st0$complete)) {
          rv$status <- sprintf("Database already present (%s).", input$scenic_species)
          rv$last_error <- ""
          setProgress(value = 1, detail = "Database already available")
          showNotification(rv$status, type = "message")
          db_refresh(db_refresh() + 1L)
          return(invisible(NULL))
        }

        setProgress(value = 0.3, detail = "Downloading databases (one-time)")
        scenic_beta_download_db(
          species = input$scenic_species,
          progress = function(msg) showNotification(msg, type = "message", duration = 2)
        )
        setProgress(value = 0.9, detail = "Validating downloaded files")
        st1 <- scenic_beta_db_status(input$scenic_species)
        rv$status <- sprintf("Database download completed for %s at %s.", input$scenic_species, st1$db_dir)
        rv$last_error <- ""
        setProgress(value = 1, detail = "Database download complete")
        showNotification(rv$status, type = "message")
        db_refresh(db_refresh() + 1L)
      }, error = function(e) {
        rv$status <- paste("Database download failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[scenic][download_db] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  observeEvent(input$scenic_preview_run, {
    overlay_show("pySCENIC Step 1: generating preview plots...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "pySCENIC Step 1 Preview", value = 0, {
      tryCatch({
        setProgress(value = 0.1, detail = "Validating object and grouping")
        obj <- scenic_beta_get_object(shared_data, input$scenic_object)
        validate(need(!is.null(obj) && inherits(obj, "Seurat"), "Selected object is unavailable."))
        validate(need(input$scenic_group_by %in% colnames(obj@meta.data), "Choose a valid metadata grouping column."))

        setProgress(value = 0.35, detail = "Generating preview signals")
        split_col <- as.character(input$scenic_split_by %||% "")
        split_levels <- as.character(input$scenic_split_levels %||% character(0))
        use_split <- nzchar(split_col) && length(split_levels) >= 2L
        run_levels <- if (use_split) split_levels else "__all__"
        dat_by_split <- list()
        for (ii in seq_along(run_levels)) {
          lv <- run_levels[[ii]]
          run_obj <- if (identical(lv, "__all__")) obj else .subset_obj_by_split(obj, split_col = split_col, split_level = lv)
          setProgress(value = min(0.85, 0.2 + 0.6 * (ii / max(1L, length(run_levels)))), detail = if (identical(lv, "__all__")) "Preview (all cells)" else sprintf("Preview split: %s=%s", split_col, lv))
          dat_by_split[[lv]] <- scenic_beta_preview(
            sobj = run_obj,
            group_col = input$scenic_group_by,
            tf_gene = input$scenic_tf,
            top_regulons = as.integer(input$scenic_top_regulons %||% 15L),
            edge_n = as.integer(input$scenic_edge_n %||% 60L),
            assay = input$scenic_assay %||% NULL
          )
        }

        setProgress(value = 0.9, detail = "Finalizing preview outputs")
        rv$preview_dat_by_split <- dat_by_split
        view_choices <- if (use_split) setNames(names(dat_by_split), names(dat_by_split)) else c("All cells" = "__all__")
        view_sel <- if (use_split) .safe_first(names(dat_by_split)) else "__all__"
        updateSelectInput(session, "scenic_view_split", choices = view_choices, selected = view_sel)
        rv$preview_dat <- dat_by_split[[view_sel]]
        rv$status <- sprintf(
          "Step 1 preview complete: object=%s, assay=%s, group=%s",
          input$scenic_object,
          rv$preview_dat$assay %||% (input$scenic_assay %||% ""),
          input$scenic_group_by
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 1 preview complete")
        updateTabsetPanel(session, "scenic_workflow_tabs", selected = "Step 1 Preview")
      }, error = function(e) {
        rv$status <- paste("Step 1 preview failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[scenic][step1] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  observeEvent(input$scenic_refresh, {
    overlay_show("Running full pySCENIC workflow...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "pySCENIC Step 2 Full Run", value = 0, {
      tryCatch({
        setProgress(value = 0.08, detail = "Validating object and grouping")
        obj <- scenic_beta_get_object(shared_data, input$scenic_object)
        validate(need(!is.null(obj) && inherits(obj, "Seurat"), "Selected object is unavailable."))
        validate(need(input$scenic_group_by %in% colnames(obj@meta.data), "Choose a valid metadata grouping column."))

        setProgress(value = 0.25, detail = "Preparing full pySCENIC input")
        split_col <- as.character(input$scenic_split_by %||% "")
        split_levels <- as.character(input$scenic_split_levels %||% character(0))
        use_split <- nzchar(split_col) && length(split_levels) >= 2L
        run_levels <- if (use_split) split_levels else "__all__"
        dat_by_split <- list()
        for (ii in seq_along(run_levels)) {
          lv <- run_levels[[ii]]
          run_obj <- if (identical(lv, "__all__")) obj else .subset_obj_by_split(obj, split_col = split_col, split_level = lv)
          setProgress(value = min(0.85, 0.2 + 0.6 * (ii / max(1L, length(run_levels)))), detail = if (identical(lv, "__all__")) "Full pySCENIC (all cells)" else sprintf("Full pySCENIC split: %s=%s", split_col, lv))
          dat_by_split[[lv]] <- scenic_beta_run_full(
            sobj = run_obj,
            group_col = input$scenic_group_by,
            tf_gene = input$scenic_tf,
            species = input$scenic_species,
            assay = input$scenic_assay %||% NULL,
            n_workers = as.integer(input$scenic_workers %||% 4L),
            max_cells = as.integer(input$scenic_max_cells %||% 3000L),
            max_genes = as.integer(input$scenic_max_genes %||% 4000L),
            top_regulons = as.integer(input$scenic_top_regulons %||% 15L),
            edge_n = as.integer(input$scenic_edge_n %||% 60L)
          )
        }

        setProgress(value = 0.9, detail = "Collecting pySCENIC outputs")
        rv$dat_by_split <- dat_by_split
        cur_key <- as.character(input$scenic_view_split %||% "")
        if (!nzchar(cur_key) || !(cur_key %in% names(dat_by_split))) cur_key <- .safe_first(names(dat_by_split))
        rv$dat <- dat_by_split[[cur_key]]
        rv$status <- sprintf(
          "Step 2 complete: object=%s, regulon=%s, output=%s",
          input$scenic_object,
          rv$dat$tf_regulon %||% rv$dat$tf_gene,
          rv$dat$run_dir %||% "N/A"
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 2 complete")
        updateTabsetPanel(session, "scenic_workflow_tabs", selected = "Step 2 Full Outputs")
      }, error = function(e) {
        rv$status <- paste("Run failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[scenic][step2] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  .preview <- reactive({ req(!is.null(rv$preview_dat)); rv$preview_dat })
  .dat <- reactive({ req(!is.null(rv$dat)); rv$dat })

  output$scenic_step1_empty_ui <- renderUI({
    if (!is.null(rv$preview_dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No Step 1 preview plots yet. Run 'Run Step 1: Preview' first.",
      height_px = 92L
    )
  })
  output$scenic_step2_empty_ui <- renderUI({
    if (!is.null(rv$dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No Step 2 full-run plots yet. Run Step 1 first, then 'Run Step 2: Full pySCENIC'.",
      height_px = 92L
    )
  })

  output$scenic_preview_umap_plot <- renderPlotly({
    d <- .preview()
    df <- .as_df(d$emb)
    validate(need(nrow(df) > 0, "No preview embedding available."))
    df$expr <- as.numeric(d$tf_expr %||% rep(NA_real_, nrow(df)))
    plotly::plot_ly(df, x = ~x, y = ~y, color = ~expr, type = "scatter", mode = "markers")
  })

  output$scenic_preview_heatmap_plot <- renderPlotly({
    d <- .preview()
    validate(need(is.matrix(d$heat), "No preview heatmap available."))
    plotly::plot_ly(z = d$heat, x = colnames(d$heat), y = rownames(d$heat), type = "heatmap", colorscale = "Viridis")
  })

  output$scenic_preview_rss_plot <- renderPlotly({
    d <- .preview()
    rr <- .as_df(d$rss)
    validate(need(nrow(rr) > 0, "No preview RSS summary available."))
    plotly::plot_ly(rr, x = ~regulon, y = ~score, type = "bar")
  })

  output$scenic_preview_target_rank_plot <- renderPlotly({
    d <- .preview()
    tr <- .as_df(d$target_rank)
    validate(need(nrow(tr) > 0, "No preview target ranking available."))
    tr <- utils::head(tr, 30)
    plotly::plot_ly(tr, x = ~gene, y = ~score, type = "bar")
  })

  output$scenic_umap_plot <- renderPlotly({
    d <- .dat()
    df <- .as_df(d$emb)
    validate(need(nrow(df) > 0, "No full-run embedding available."))
    df$expr <- as.numeric(d$tf_expr %||% rep(NA_real_, nrow(df)))
    plotly::plot_ly(df, x = ~x, y = ~y, color = ~expr, type = "scatter", mode = "markers")
  })

  output$scenic_heatmap_plot <- renderPlotly({
    d <- .dat()
    validate(need(is.matrix(d$heat), "No full-run heatmap available."))
    plotly::plot_ly(z = d$heat, x = colnames(d$heat), y = rownames(d$heat), type = "heatmap", colorscale = "Viridis")
  })

  output$scenic_rss_plot <- renderPlotly({
    d <- .dat()
    rr <- .as_df(d$rss)
    validate(need(nrow(rr) > 0, "No full-run RSS summary available."))
    plotly::plot_ly(rr, x = ~regulon, y = ~score, type = "bar")
  })

  output$scenic_violin_plot <- renderPlotly({
    d <- .dat()
    dd <- data.frame(group = as.character(d$groups %||% character(0)), auc = as.numeric(d$tf_expr %||% numeric(0)), stringsAsFactors = FALSE)
    validate(need(nrow(dd) > 0, "No regulon distribution data available."))
    plotly::plot_ly(dd, x = ~group, y = ~auc, type = "box")
  })

  output$scenic_network_plot <- renderPlotly({
    d <- .dat()
    tr <- .as_df(d$target_rank)
    validate(need(nrow(tr) > 0, "No TF-target rank available for network view."))

    tr <- utils::head(tr[order(abs(tr$score), decreasing = TRUE), , drop = FALSE], 40)
    n <- nrow(tr)
    theta <- seq(0, 2 * pi, length.out = n + 1L)[seq_len(n)]
    nodes <- data.frame(
      gene = tr$gene,
      x = cos(theta),
      y = sin(theta),
      score = tr$score,
      stringsAsFactors = FALSE
    )

    p <- plotly::plot_ly()
    p <- plotly::add_segments(
      p,
      data = nodes,
      x = 0,
      y = 0,
      xend = ~x,
      yend = ~y,
      line = list(width = 1, color = "#94a3b8"),
      hoverinfo = "none",
      showlegend = FALSE
    )
    p <- plotly::add_trace(
      p,
      x = 0,
      y = 0,
      text = d$tf_gene %||% "TF",
      type = "scatter",
      mode = "markers+text",
      marker = list(size = 18, color = "#dc2626"),
      textposition = "top center",
      showlegend = FALSE
    )
    plotly::add_trace(
      p,
      data = nodes,
      x = ~x,
      y = ~y,
      text = ~gene,
      type = "scatter",
      mode = "markers+text",
      marker = list(size = 10, color = "#2563eb"),
      textposition = "top center",
      showlegend = FALSE
    )
  })

  output$scenic_target_rank_plot <- renderPlotly({
    d <- .dat()
    tr <- .as_df(d$target_rank)
    validate(need(nrow(tr) > 0, "No target rank available from full run."))
    tr <- utils::head(tr, 40)
    plotly::plot_ly(tr, x = ~gene, y = ~score, type = "bar")
  })
}
