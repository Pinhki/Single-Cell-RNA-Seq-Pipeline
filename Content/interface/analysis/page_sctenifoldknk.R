SCTENIFOLDKNK_UI_TEXT <- list(
  title = "Analysis: scTenifoldKnk",
  subtitle = "Run package-native virtual gene knockout on single-cell networks to quantify global perturbation shifts, rank affected genes, and inspect pathway-level downstream impact.",
  status_ready = "Ready. Run Step 1 target diagnostics, then run Step 2 for full virtual knockout analysis."
)

`%||%` <- function(a, b) if (is.null(a)) b else a

sctenifoldknk_ui <- fluidPage(
  class = "plotting-page advanced-analysis-page",
  div(class = "page-header", h2(icon("dna"), " ", SCTENIFOLDKNK_UI_TEXT$title, " ", tags$span("alpha", class = "alpha-badge")), p(SCTENIFOLDKNK_UI_TEXT$subtitle)),
  fluidRow(
    column(
      3,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        tags$strong("Step 1: Target diagnostics"),
        selectInput("sctenifoldknk_object", "Object", choices = character(0)),
        selectInput("sctenifoldknk_assay", "Assay", choices = character(0)),
        selectInput("sctenifoldknk_group_col", "Grouping column (meta.data, optional)", choices = setNames("", ""), selected = ""),
        selectInput("sctenifoldknk_split_by", "Recompute split by (optional)", choices = c("(None)" = ""), selected = ""),
        selectizeInput("sctenifoldknk_split_levels", "Split levels (recompute each)", choices = character(0), selected = character(0), multiple = TRUE),
        selectInput("sctenifoldknk_view_split", "View split result", choices = c("All cells" = "__all__"), selected = "__all__"),
        textInput("sctenifoldknk_target_gene", "Target gene", value = "SOX2"),
        sliderInput("sctenifoldknk_top_genes", "Top affected genes", min = 10, max = 200, value = 50, step = 5),
        actionButton("sctenifoldknk_step1_run", "Run Step 1: Target Diagnostics", class = "btn btn-outline-primary btn-sm"),
        tags$hr(),
        tags$strong("Step 2: Virtual knockout"),
        sliderInput("sctenifoldknk_nsubsamp", "Subsampling networks", min = 20, max = 200, value = 80, step = 10),
        checkboxInput("sctenifoldknk_qc", "Enable built-in QC", value = TRUE),
        numericInput("sctenifoldknk_qc_min_lsize", "QC min library size", value = 1000, min = 100, step = 100),
        numericInput("sctenifoldknk_qc_min_cells", "QC min cells per gene", value = 25, min = 1, step = 1),
        numericInput("sctenifoldknk_max_cells", "Max cells (subsample for speed)", value = 3000, min = 500, step = 500),
        numericInput("sctenifoldknk_cores", "Cores", value = 1, min = 1, max = 64, step = 1),
        actionButton("sctenifoldknk_refresh", "Run Step 2: Virtual KO", class = "btn btn-primary btn-sm"),
        tags$hr(),
        uiOutput("sctenifoldknk_status_ui"),
        tags$hr(),
        beta_result_object_controls_ui(
          id_prefix = "sctenifold_result_io",
          title = "scTenifoldKnk Result Object"
        )
      )
    ),
    column(
      9,
      tabsetPanel(
        id = "sctenifold_workflow_tabs",
        tabPanel(
          "Step 1 Verify",
          div(
            class = "plot_area_card_style",
            uiOutput("sctenifold_step1_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3", h4("Target expression map"), plotlyOutput("sctenifold_step1_shift_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Preliminary top genes"), plotlyOutput("sctenifold_step1_rank_plot", height = "280px")))
            )
          )
        ),
        tabPanel(
          "Step 2 Outputs",
          div(
            class = "plot_area_card_style",
            uiOutput("sctenifold_step2_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3", h4("Manifold shift map"), plotlyOutput("sctenifoldknk_shift_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Perturbation rank"), plotlyOutput("sctenifoldknk_rank_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Perturbation volcano"), plotlyOutput("sctenifoldknk_volcano_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Pathway impact"), plotlyOutput("sctenifoldknk_pathway_plot", height = "280px")))
            )
          )
        )
      )
    )
  )
)

sctenifoldknk_server <- function(input, output, session, shared_data) {
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
    key <- as.character(input$sctenifoldknk_view_split %||% "__all__")
    if (!is.null(rv$step1_dat_by_split) && key %in% names(rv$step1_dat_by_split)) rv$step1_dat <- rv$step1_dat_by_split[[key]]
    if (!is.null(rv$dat_by_split) && key %in% names(rv$dat_by_split)) rv$dat <- rv$dat_by_split[[key]]
    invisible(NULL)
  }

  rv <- reactiveValues(status = SCTENIFOLDKNK_UI_TEXT$status_ready, step1_dat = NULL, dat = NULL, step1_dat_by_split = NULL, dat_by_split = NULL, last_error = "")
  beta_result_object_controls_server(
    input = input,
    output = output,
    session = session,
    shared_data = shared_data,
    id_prefix = "sctenifold_result_io",
    get_current_object = function() rv$dat %||% rv$step1_dat,
    set_current_object = function(obj) {
      if (is.list(obj) && !is.null(obj$volcano)) {
        rv$dat <- obj
        rv$status <- "Imported scTenifoldKnk Step 2 result is now active."
        rv$last_error <- ""
        updateTabsetPanel(session, "sctenifold_workflow_tabs", selected = "Step 2 Outputs")
      } else {
        rv$step1_dat <- obj
        rv$status <- "Imported scTenifoldKnk Step 1 result is now active."
        rv$last_error <- ""
        updateTabsetPanel(session, "sctenifold_workflow_tabs", selected = "Step 1 Verify")
      }
    },
    write_metadata_to_active_object = function(res_obj, sobj) {
      d <- res_obj
      if (is.null(d$target_expr) && !is.null(rv$step1_dat)) d <- rv$step1_dat
      if (is.null(d) || !is.list(d)) stop("scTenifoldKnk result is missing.")

      expr <- as.numeric(d$target_expr %||% numeric(0))
      if (!length(expr) || length(expr) != ncol(sobj)) {
        stop("No cell-level target expression vector is available to write.")
      }
      tg <- make.names(as.character(d$target_gene %||% input$sctenifoldknk_target_gene %||% "target"))
      cn <- paste0("sctenifold_target_expr_", tg)
      sobj[[cn]] <- expr
      list(obj = sobj, added_cols = c(cn))
    },
    default_workspace_name = "sctenifold_result"
  )
  output$sctenifoldknk_status_ui <- renderUI({
    if (nzchar(rv$last_error %||% "")) {
      div(class = "alert alert-danger p-2 mb-0", rv$last_error)
    } else {
      div(class = "small text-muted", rv$status)
    }
  })

  observe({
    nms <- sctenifold_beta_object_names(shared_data)
    cur <- isolate(input$sctenifoldknk_object %||% "")
    active_nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
    sel <- if (nzchar(cur) && cur %in% nms) cur else if (nzchar(active_nm) && active_nm %in% nms) active_nm else .safe_first(nms)
    updateSelectInput(session, "sctenifoldknk_object", choices = nms, selected = sel)
  })

  observeEvent(
    list(input$sctenifoldknk_object, shared_data$active_object_name, shared_data$all_seurat_objects, shared_data$filtered_objects),
    {
      overlay_show("scTenifoldKnk: loading object metadata...")
      on.exit(overlay_hide(), add = TRUE)
      tryCatch({
        obj <- sctenifold_beta_get_object(shared_data, input$sctenifoldknk_object)
        if (is.null(obj) || !inherits(obj, "Seurat")) {
          updateSelectInput(session, "sctenifoldknk_assay", choices = character(0), selected = "")
          updateSelectInput(session, "sctenifoldknk_group_col", choices = setNames("", ""), selected = "")
          return(invisible(NULL))
        }

        assays <- sctenifold_beta_assays(obj)
        cur_assay <- isolate(input$sctenifoldknk_assay %||% "")
        def_assay <- if (nzchar(cur_assay) && cur_assay %in% assays) cur_assay else sctenifold_beta_default_assay(obj)
        updateSelectInput(session, "sctenifoldknk_assay", choices = assays, selected = def_assay)

        cols <- sctenifold_beta_meta_cols(obj)
        cur_col <- isolate(input$sctenifoldknk_group_col %||% "")
        def_col <- if (nzchar(cur_col) && cur_col %in% cols) cur_col else ""
        updateSelectInput(session, "sctenifoldknk_group_col", choices = c("(None)" = "", setNames(cols, cols)), selected = def_col)
        split_cur <- isolate(input$sctenifoldknk_split_by %||% "")
        split_sel <- if (nzchar(split_cur) && split_cur %in% cols) split_cur else ""
        updateSelectInput(session, "sctenifoldknk_split_by", choices = c("(None)" = "", setNames(cols, cols)), selected = split_sel)
        split_levels <- .split_levels_from_obj(obj, split_sel)
        split_level_cur <- isolate(input$sctenifoldknk_split_levels %||% character(0))
        split_level_sel <- intersect(as.character(split_level_cur), split_levels)
        if (!length(split_level_sel) && length(split_levels) >= 2L) split_level_sel <- split_levels
        updateSelectizeInput(session, "sctenifoldknk_split_levels", choices = split_levels, selected = split_level_sel, server = TRUE)
      }, error = function(e) {
        warning(sprintf("[sctenifoldknk][selectors] %s", conditionMessage(e)), call. = FALSE, immediate. = TRUE)
        updateSelectInput(session, "sctenifoldknk_assay", choices = character(0), selected = "")
        updateSelectInput(session, "sctenifoldknk_group_col", choices = setNames("", ""), selected = "")
        updateSelectInput(session, "sctenifoldknk_split_by", choices = c("(None)" = ""), selected = "")
        updateSelectizeInput(session, "sctenifoldknk_split_levels", choices = character(0), selected = character(0), server = TRUE)
      })
    },
    ignoreInit = FALSE
  )

  observeEvent(input$sctenifoldknk_split_by, {
    obj <- sctenifold_beta_get_object(shared_data, input$sctenifoldknk_object)
    split_levels <- .split_levels_from_obj(obj, input$sctenifoldknk_split_by %||% "")
    split_level_cur <- isolate(input$sctenifoldknk_split_levels %||% character(0))
    split_level_sel <- intersect(as.character(split_level_cur), split_levels)
    if (!length(split_level_sel) && length(split_levels) >= 2L) split_level_sel <- split_levels
    updateSelectizeInput(session, "sctenifoldknk_split_levels", choices = split_levels, selected = split_level_sel, server = TRUE)
  }, ignoreInit = TRUE)

  observeEvent(input$sctenifoldknk_view_split, {
    .sync_active_split_view()
  }, ignoreInit = TRUE)

  observeEvent(input$sctenifoldknk_step1_run, {
    overlay_show("scTenifoldKnk Step 1: running target diagnostics...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "scTenifoldKnk Step 1", value = 0, {
      tryCatch({
        setProgress(value = 0.1, detail = "Validating object and target gene")
        obj <- sctenifold_beta_get_object(shared_data, input$sctenifoldknk_object)
        validate(need(!is.null(obj) && inherits(obj, "Seurat"), "Selected object is unavailable."))
        validate(need(nzchar(input$sctenifoldknk_target_gene %||% ""), "Provide a target gene."))

        setProgress(value = 0.35, detail = "Running target diagnostics")
        split_col <- as.character(input$sctenifoldknk_split_by %||% "")
        split_levels <- as.character(input$sctenifoldknk_split_levels %||% character(0))
        use_split <- nzchar(split_col) && length(split_levels) >= 2L
        run_levels <- if (use_split) split_levels else "__all__"
        dat_by_split <- list()
        for (ii in seq_along(run_levels)) {
          lv <- run_levels[[ii]]
          run_obj <- if (identical(lv, "__all__")) obj else .subset_obj_by_split(obj, split_col = split_col, split_level = lv)
          setProgress(value = min(0.85, 0.2 + 0.6 * (ii / max(1L, length(run_levels)))), detail = if (identical(lv, "__all__")) "Running diagnostics (all cells)" else sprintf("Running diagnostics split: %s=%s", split_col, lv))
          dat_by_split[[lv]] <- sctenifold_beta_preview(
            sobj = run_obj,
            target_gene = input$sctenifoldknk_target_gene,
            top_genes = max(10L, min(50L, as.integer(input$sctenifoldknk_top_genes %||% 50L))),
            group_col = input$sctenifoldknk_group_col %||% "",
            assay = input$sctenifoldknk_assay %||% NULL
          )
        }

        setProgress(value = 0.9, detail = "Preparing Step 1 outputs")
        rv$step1_dat_by_split <- dat_by_split
        view_choices <- if (use_split) setNames(names(dat_by_split), names(dat_by_split)) else c("All cells" = "__all__")
        view_sel <- if (use_split) .safe_first(names(dat_by_split)) else "__all__"
        updateSelectInput(session, "sctenifoldknk_view_split", choices = view_choices, selected = view_sel)
        rv$step1_dat <- dat_by_split[[view_sel]]
        rv$dat <- NULL
        rv$dat_by_split <- NULL

        rv$status <- sprintf(
          "Step 1 complete: object=%s, assay=%s, target=%s",
          input$sctenifoldknk_object,
          rv$step1_dat$assay %||% (input$sctenifoldknk_assay %||% ""),
          rv$step1_dat$target_gene %||% input$sctenifoldknk_target_gene
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 1 complete")
        updateTabsetPanel(session, "sctenifold_workflow_tabs", selected = "Step 1 Verify")
      }, error = function(e) {
        rv$status <- paste("Step 1 failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[sctenifoldknk][step1] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  observeEvent(input$sctenifoldknk_refresh, {
    overlay_show("scTenifoldKnk Step 2: running virtual knockout...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "scTenifoldKnk Step 2", value = 0, {
      tryCatch({
        setProgress(value = 0.1, detail = "Validating Step 1 outputs")
        validate(need(!is.null(rv$step1_dat), "Run Step 1 first."))
        obj <- sctenifold_beta_get_object(shared_data, input$sctenifoldknk_object)
        validate(need(!is.null(obj) && inherits(obj, "Seurat"), "Selected object is unavailable."))

        setProgress(value = 0.35, detail = "Running virtual knockout")
        split_col <- as.character(input$sctenifoldknk_split_by %||% "")
        split_levels <- as.character(input$sctenifoldknk_split_levels %||% character(0))
        use_split <- nzchar(split_col) && length(split_levels) >= 2L
        run_levels <- if (use_split) split_levels else "__all__"
        dat_by_split <- list()
        for (ii in seq_along(run_levels)) {
          lv <- run_levels[[ii]]
          run_obj <- if (identical(lv, "__all__")) obj else .subset_obj_by_split(obj, split_col = split_col, split_level = lv)
          setProgress(value = min(0.85, 0.2 + 0.6 * (ii / max(1L, length(run_levels)))), detail = if (identical(lv, "__all__")) "Running virtual KO (all cells)" else sprintf("Running virtual KO split: %s=%s", split_col, lv))
          dat_by_split[[lv]] <- sctenifold_beta_run(
            sobj = run_obj,
            target_gene = input$sctenifoldknk_target_gene,
            nsubsamp = as.integer(input$sctenifoldknk_nsubsamp %||% 80L),
            top_genes = as.integer(input$sctenifoldknk_top_genes %||% 50L),
            assay = input$sctenifoldknk_assay %||% NULL,
            qc = isTRUE(input$sctenifoldknk_qc),
            qc_minLSize = as.integer(input$sctenifoldknk_qc_min_lsize %||% 1000L),
            qc_minCells = as.integer(input$sctenifoldknk_qc_min_cells %||% 25L),
            max_cells = as.integer(input$sctenifoldknk_max_cells %||% 3000L),
            ncores = as.integer(input$sctenifoldknk_cores %||% 1L)
          )
        }

        setProgress(value = 0.9, detail = "Preparing perturbation outputs")
        rv$dat_by_split <- dat_by_split
        cur_key <- as.character(input$sctenifoldknk_view_split %||% "")
        if (!nzchar(cur_key) || !(cur_key %in% names(dat_by_split))) cur_key <- .safe_first(names(dat_by_split))
        rv$dat <- dat_by_split[[cur_key]]
        rv$status <- sprintf(
          "Step 2 complete: target=%s, top_genes=%s",
          rv$dat$target_gene %||% input$sctenifoldknk_target_gene,
          as.integer(input$sctenifoldknk_top_genes %||% 50L)
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 2 complete")
        updateTabsetPanel(session, "sctenifold_workflow_tabs", selected = "Step 2 Outputs")
      }, error = function(e) {
        rv$status <- paste("Step 2 failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[sctenifoldknk][step2] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  .step1 <- reactive({ req(!is.null(rv$step1_dat)); rv$step1_dat })
  .dat <- reactive({ req(!is.null(rv$dat)); rv$dat })

  output$sctenifold_step1_empty_ui <- renderUI({
    if (!is.null(rv$step1_dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No scTenifoldKnk Step 1 plots yet. Run 'Run Step 1: Target Diagnostics' first.",
      height_px = 92L
    )
  })
  output$sctenifold_step2_empty_ui <- renderUI({
    if (!is.null(rv$dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No scTenifoldKnk Step 2 plots yet. Run Step 1 first, then 'Run Step 2: Virtual KO'.",
      height_px = 92L
    )
  })

  output$sctenifold_step1_shift_plot <- renderPlotly({
    d <- .step1()
    emb <- .as_df(d$emb)
    validate(need(nrow(emb) > 0, "No embedding available from Step 1."))
    emb$expr <- as.numeric(d$target_expr %||% rep(NA_real_, nrow(emb)))
    plotly::plot_ly(emb, x = ~x, y = ~y, color = ~expr, type = "scatter", mode = "markers")
  })

  output$sctenifold_step1_rank_plot <- renderPlotly({
    d <- .step1()
    rr <- .as_df(d$rank)
    validate(need(nrow(rr) > 0, "No preliminary rank available from Step 1."))
    rr <- utils::head(rr[order(abs(rr$score), decreasing = TRUE), , drop = FALSE], 30)
    plotly::plot_ly(rr, x = ~gene, y = ~score, type = "bar")
  })

  output$sctenifoldknk_shift_plot <- renderPlotly({
    d <- .dat()
    sh <- .as_df(d$shift_df)
    validate(need(nrow(sh) > 0, "No manifold shift map available from Step 2."))
    sh <- utils::head(sh[order(sh$shift, decreasing = TRUE), , drop = FALSE], 500)
    plotly::plot_ly(sh, x = ~wt1, y = ~wt2, type = "scatter", mode = "markers", color = ~shift, text = ~gene, hoverinfo = "text")
  })

  output$sctenifoldknk_rank_plot <- renderPlotly({
    d <- .dat()
    rr <- .as_df(d$rank)
    validate(need(nrow(rr) > 0, "No perturbation rank available from Step 2."))
    rr <- utils::head(rr, 60)
    plotly::plot_ly(rr, x = ~gene, y = ~score, type = "bar")
  })

  output$sctenifoldknk_volcano_plot <- renderPlotly({
    d <- .dat()
    v <- .as_df(d$volcano)
    validate(need(nrow(v) > 0, "No volcano table available from Step 2."))
    v <- utils::head(v[order(v$nlp, decreasing = TRUE), , drop = FALSE], 2000)
    plotly::plot_ly(v, x = ~effect, y = ~nlp, text = ~gene, type = "scatter", mode = "markers")
  })

  output$sctenifoldknk_pathway_plot <- renderPlotly({
    d <- .dat()
    pw <- .as_df(d$pathway_like)
    validate(need(nrow(pw) > 0, "No pathway impact summary available from Step 2."))
    pw <- utils::head(pw[order(pw$score, decreasing = TRUE), , drop = FALSE], 30)
    plotly::plot_ly(pw, x = ~name, y = ~score, type = "bar")
  })
}
