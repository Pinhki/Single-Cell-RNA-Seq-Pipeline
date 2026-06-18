MONOCLE2_UI_TEXT <- list(
  title = "Analysis: Monocle2",
  subtitle = "Run package-native Monocle2 trajectory ordering and branch analysis to inspect pseudotime structure, state transitions, and BEAM branch-dependent genes.",
  status_ready = "Ready. Run Step 1 trajectory first, review states, then run Step 2 BEAM with selected branch states or branch point."
)

`%||%` <- function(a, b) if (is.null(a)) b else a

monocle2_ui <- fluidPage(
  class = "plotting-page advanced-analysis-page",
  div(class = "page-header", h2(icon("project-diagram"), " ", MONOCLE2_UI_TEXT$title, " ", tags$span("beta", class = "beta-badge")), p(MONOCLE2_UI_TEXT$subtitle)),
  fluidRow(
    column(
      3,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        uiOutput("monocle2_runtime_ui"),
        tags$hr(),
        tags$strong("Step 1: Trajectory parameters"),
        selectInput("monocle2_object", "Object", choices = character(0)),
        selectInput("monocle2_assay", "Assay", choices = character(0)),
        selectInput("monocle2_group_by", "Color/group column (meta.data)", choices = character(0)),
        selectInput("monocle2_split_by", "Split plot by (metadata, optional)", choices = c("(No split)" = "__none__"), selected = "__none__"),
        sliderInput("monocle2_n_genes", "Ordering genes", min = 200, max = 5000, value = 1000, step = 100),
        numericInput("monocle2_min_expr", "Min expression for gene detection", value = 0.1, min = 0, max = 5, step = 0.05),
        checkboxInput("monocle2_reverse", "Reverse pseudotime", value = FALSE),
        selectInput("monocle2_root_state", "Root state (optional)", choices = setNames("", ""), selected = ""),
        actionButton("monocle2_step1_run", "Run Step 1: Build Trajectory", class = "btn btn-outline-primary btn-sm"),
        tags$hr(),
        tags$strong("Step 2: BEAM parameters"),
        selectInput("monocle2_branch_state_a", "BEAM branch state A (optional)", choices = setNames("", ""), selected = ""),
        selectInput("monocle2_branch_state_b", "BEAM branch state B (optional)", choices = setNames("", ""), selected = ""),
        numericInput("monocle2_branch_point", "BEAM branch point", value = 1, min = 1, step = 1),
        sliderInput("monocle2_beam_top_genes", "BEAM top genes", min = 20, max = 300, value = 80, step = 10),
        sliderInput("monocle2_beam_clusters", "BEAM heatmap clusters", min = 2, max = 12, value = 6, step = 1),
        numericInput("monocle2_cores", "Cores", value = 1, min = 1, max = 64, step = 1),
        actionButton("monocle2_refresh", "Run Step 2: Run BEAM", class = "btn btn-primary btn-sm"),
        tags$hr(),
        uiOutput("monocle2_status_ui"),
        tags$hr(),
        beta_result_object_controls_ui(
          id_prefix = "monocle2_result_io",
          title = "Monocle2 Result Object"
        )
      )
    ),
    column(
      9,
      tabsetPanel(
        id = "monocle2_workflow_tabs",
        tabPanel(
          "Step 1 Trajectory",
          div(
            class = "plot_area_card_style",
            uiOutput("monocle2_step1_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3", h4("Trajectory (pseudotime)"), plotlyOutput("monocle2_traj_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Trajectory (group colors)"), plotlyOutput("monocle2_group_plot", height = "280px")))
            )
          )
        ),
        tabPanel(
          "Step 2 BEAM",
          div(
            class = "plot_area_card_style",
            uiOutput("monocle2_step2_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3", h4("BEAM branch heatmap"), plotlyOutput("monocle2_heatmap_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("BEAM divergence"), plotlyOutput("monocle2_divergence_plot", height = "280px")))
            )
          )
        )
      )
    )
  )
)

monocle2_server <- function(input, output, session, shared_data) {
  .safe_first <- function(x, default = "") if (length(x)) as.character(x[[1]]) else default
  .safe_split_col <- function(x) {
    v <- as.character(x %||% "__none__")
    if (!nzchar(v) || identical(v, "__none__")) return("")
    v
  }
  .as_df <- function(x) {
    if (is.null(x)) return(data.frame())
    tryCatch(as.data.frame(x, stringsAsFactors = FALSE), error = function(e) data.frame())
  }
  .sorted_levels <- function(x) {
    u <- unique(as.character(x))
    u <- u[nzchar(u)]
    sort(u, method = "radix")
  }
  .with_plotly_tools <- function(p, file_stub = "monocle2_plot") {
    plotly::config(
      p,
      displayModeBar = TRUE,
      displaylogo = FALSE,
      scrollZoom = TRUE,
      toImageButtonOptions = list(format = "png", filename = file_stub, scale = 2)
    )
  }
  .traj_with_split <- function(dat, split_col = "") {
    emb <- .as_df(dat$emb)
    validate(need(nrow(emb) > 0, "No trajectory embedding available from Step 1."))
    emb$pseudotime <- as.numeric(dat$pseudotime)
    emb$group <- as.character(dat$group %||% rep("Unknown", nrow(emb)))
    emb$split_value <- "All cells"

    split_col <- as.character(split_col %||% "")
    md <- .as_df(dat$meta)
    if (nzchar(split_col) && nrow(md) > 0 && split_col %in% colnames(md) && nrow(emb) > 0) {
      emb$cell <- as.character(emb$cell %||% rownames(md) %||% character(0))
      split_vals <- as.character(md[[split_col]])
      names(split_vals) <- rownames(md)
      sv <- split_vals[emb$cell]
      sv[is.na(sv) | !nzchar(sv)] <- "Unknown"
      emb$split_value <- sv
    }
    emb
  }
  .render_split_scatter <- function(df, color_col, file_stub = "monocle2_scatter") {
    split_levels <- .sorted_levels(df$split_value %||% "All cells")
    if (!length(split_levels)) split_levels <- "All cells"
    split_levels <- split_levels[nzchar(split_levels)]
    if (!length(split_levels)) split_levels <- "All cells"
    if (length(split_levels) > 12L) {
      split_levels <- split_levels[seq_len(12L)]
      showNotification("Showing first 12 split panels. Narrow split levels for focused inspection.", type = "warning", duration = 6)
    }

    if (length(split_levels) <= 1L) {
      p0 <- plotly::plot_ly(df, x = ~x, y = ~y, color = stats::as.formula(paste0("~", color_col)), type = "scatter", mode = "markers")
      return(.with_plotly_tools(p0, file_stub = file_stub))
    }

    plist <- lapply(split_levels, function(lv) {
      dsub <- df[as.character(df$split_value) %in% lv, , drop = FALSE]
      if (!nrow(dsub)) dsub <- df[0, , drop = FALSE]
      plotly::plot_ly(dsub, x = ~x, y = ~y, color = stats::as.formula(paste0("~", color_col)), type = "scatter", mode = "markers", showlegend = FALSE)
    })
    ncol <- max(1L, min(4L, ceiling(sqrt(length(split_levels)))))
    nrow <- max(1L, ceiling(length(split_levels) / ncol))
    p <- plotly::subplot(plist, nrows = nrow, shareX = TRUE, shareY = TRUE, margin = 0.03, titleX = TRUE, titleY = TRUE, subplot_titles = split_levels)
    p <- plotly::layout(p, showlegend = FALSE)
    .with_plotly_tools(p, file_stub = file_stub)
  }
  .runtime_check <- function() {
    tryCatch(
      monocle2_beta_runtime_guard(
        expected_igraph = "2.2.2",
        min_monocle = "2.34.0",
        require_core_lib = TRUE,
        run_compat_smoke = FALSE
      ),
      error = function(e) {
        warning(sprintf("[monocle2][runtime_guard] %s", conditionMessage(e)), call. = FALSE, immediate. = TRUE)
        list(
          ok = FALSE,
          summary = paste("Runtime check internal error:", conditionMessage(e)),
          issues = conditionMessage(e),
          versions = list(igraph = NA_character_, monocle = NA_character_),
          paths = list(igraph = "", monocle = "", core = "")
        )
      }
    )
  }

  rv <- reactiveValues(status = MONOCLE2_UI_TEXT$status_ready, traj_dat = NULL, beam_dat = NULL, last_error = "", runtime = NULL)
  beta_result_object_controls_server(
    input = input,
    output = output,
    session = session,
    shared_data = shared_data,
    id_prefix = "monocle2_result_io",
    get_current_object = function() rv$beam_dat %||% rv$traj_dat,
    set_current_object = function(obj) {
      if (is.list(obj) && !is.null(obj$divergence)) {
        rv$beam_dat <- obj
        rv$status <- "Imported Monocle2 BEAM result is now active."
        rv$last_error <- ""
        updateTabsetPanel(session, "monocle2_workflow_tabs", selected = "Step 2 BEAM")
      } else {
        rv$traj_dat <- obj
        rv$status <- "Imported Monocle2 trajectory result is now active."
        rv$last_error <- ""
        updateTabsetPanel(session, "monocle2_workflow_tabs", selected = "Step 1 Trajectory")
      }
    },
    write_metadata_to_active_object = function(res_obj, sobj) {
      d <- res_obj
      if (is.null(d$pseudotime) && !is.null(rv$traj_dat)) d <- rv$traj_dat
      if (is.null(d) || !is.list(d)) stop("Monocle2 result is missing.")

      cells <- rownames(sobj@meta.data)
      map_vec <- function(v, named_cells = NULL) {
        vv <- as.numeric(v %||% numeric(0))
        if (!length(vv)) return(rep(NA_real_, length(cells)))
        if (!is.null(named_cells) && length(named_cells) == length(vv) && all(nzchar(named_cells))) {
          names(vv) <- as.character(named_cells)
          return(as.numeric(vv[cells]))
        }
        if (length(vv) == length(cells)) return(vv)
        rep(NA_real_, length(cells))
      }

      named_cells <- as.character(d$emb$cell %||% character(0))
      pt <- map_vec(d$pseudotime, named_cells = named_cells)
      st_raw <- as.character(d$state %||% character(0))
      st <- if (length(st_raw) == length(cells)) st_raw else if (length(named_cells) == length(st_raw)) setNames(st_raw, named_cells)[cells] else rep(NA_character_, length(cells))

      added <- character(0)
      if (any(is.finite(pt), na.rm = TRUE)) {
        sobj[["monocle2_pseudotime"]] <- pt
        added <- c(added, "monocle2_pseudotime")
      }
      if (length(st) == length(cells) && any(nzchar(st), na.rm = TRUE)) {
        sobj[["monocle2_state"]] <- st
        added <- c(added, "monocle2_state")
      }
      if (!length(added)) stop("No writable Monocle2 cell-level metadata was found.")
      list(obj = sobj, added_cols = added)
    },
    default_workspace_name = "monocle2_result"
  )
  .runtime_failure <- function(msg) {
    list(
      ok = FALSE,
      summary = paste("Runtime check failed:", msg),
      issues = msg,
      versions = list(igraph = NA_character_, monocle = NA_character_),
      paths = list(igraph = "", monocle = "", core = "")
    )
  }
  .record_init_error <- function(tag, e) {
    msg <- sprintf("%s: %s", tag, conditionMessage(e))
    rv$last_error <- msg
    warning(sprintf("[monocle2][%s] %s", tag, conditionMessage(e)), call. = FALSE, immediate. = TRUE)
    invisible(msg)
  }
  observeEvent(TRUE, {
    overlay_show("Monocle2: checking runtime dependencies...")
    on.exit(overlay_hide(), add = TRUE)
    tryCatch({
      rv$runtime <- .runtime_check()
    }, error = function(e) {
      rv$runtime <- .runtime_failure(conditionMessage(e))
      .record_init_error("runtime_init", e)
    })
  }, once = TRUE, ignoreInit = FALSE)
  output$monocle2_runtime_ui <- renderUI({
    tryCatch({
      chk <- rv$runtime %||% list(ok = FALSE, summary = "Runtime check has not completed yet.", versions = list(igraph = NA, monocle = NA), paths = list(igraph = "", monocle = ""))
      cls <- if (isTRUE(chk$ok)) "alert alert-success p-2 mb-2 small" else "alert alert-danger p-2 mb-2 small"
      div(
        class = cls,
        tags$strong("Runtime preflight"), tags$br(),
        chk$summary %||% "",
        tags$br(),
        tags$code(sprintf("igraph=%s | monocle=%s", chk$versions$igraph %||% "NA", chk$versions$monocle %||% "NA")),
        tags$br(),
        tags$code(sprintf("igraph path: %s", chk$paths$igraph %||% "NA")),
        tags$br(),
        tags$code(sprintf("monocle path: %s", chk$paths$monocle %||% "NA"))
      )
    }, error = function(e) {
      .record_init_error("runtime_ui", e)
      div(
        class = "alert alert-danger p-2 mb-2 small",
        tags$strong("Runtime preflight"),
        tags$br(),
        "Runtime preflight UI error. Check console logs for details."
      )
    })
  })
  output$monocle2_status_ui <- renderUI({
    if (nzchar(rv$last_error %||% "")) {
      div(class = "alert alert-danger p-2 mb-0", rv$last_error)
    } else {
      div(class = "small text-muted", rv$status)
    }
  })

  observe({
    tryCatch({
      nms <- monocle2_beta_object_names(shared_data)
      cur <- isolate(input$monocle2_object %||% "")
      active_nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
      sel <- if (nzchar(cur) && cur %in% nms) cur else if (nzchar(active_nm) && active_nm %in% nms) active_nm else .safe_first(nms)
      updateSelectInput(session, "monocle2_object", choices = nms, selected = sel)
    }, error = function(e) {
      updateSelectInput(session, "monocle2_object", choices = character(0), selected = "")
      .record_init_error("object_selector", e)
    })
  })

  observeEvent(
    list(input$monocle2_object, shared_data$active_object_name, shared_data$all_seurat_objects, shared_data$filtered_objects),
    {
      overlay_show("Monocle2: loading object metadata...")
      on.exit(overlay_hide(), add = TRUE)
      tryCatch({
        obj <- monocle2_beta_get_object(shared_data, input$monocle2_object)
        if (is.null(obj) || !inherits(obj, "Seurat")) {
          updateSelectInput(session, "monocle2_group_by", choices = character(0), selected = "")
          updateSelectInput(session, "monocle2_assay", choices = character(0), selected = "")
          return(invisible(NULL))
        }

        cols <- monocle2_beta_meta_cols(obj)
        cur_col <- isolate(input$monocle2_group_by %||% "")
        def_col <- if (nzchar(cur_col) && cur_col %in% cols) cur_col else monocle2_beta_default_group(cols)
        updateSelectInput(session, "monocle2_group_by", choices = cols, selected = def_col)
        split_choices <- c("(No split)" = "__none__", setNames(cols, cols))
        cur_split <- isolate(input$monocle2_split_by %||% "__none__")
        def_split <- if (nzchar(cur_split) && (cur_split %in% names(split_choices) || cur_split %in% cols)) cur_split else "__none__"
        updateSelectInput(session, "monocle2_split_by", choices = split_choices, selected = def_split)

        assays <- monocle2_beta_assays(obj)
        cur_assay <- isolate(input$monocle2_assay %||% "")
        def_assay <- if (nzchar(cur_assay) && cur_assay %in% assays) cur_assay else monocle2_beta_default_assay(obj)
        updateSelectInput(session, "monocle2_assay", choices = assays, selected = def_assay)
      }, error = function(e) {
        updateSelectInput(session, "monocle2_group_by", choices = character(0), selected = "")
        updateSelectInput(session, "monocle2_split_by", choices = c("(No split)" = "__none__"), selected = "__none__")
        updateSelectInput(session, "monocle2_assay", choices = character(0), selected = "")
        .record_init_error("metadata_selectors", e)
      })
    },
    ignoreInit = FALSE
  )

  observeEvent(input$monocle2_step1_run, {
    overlay_show("Monocle2 Step 1: building trajectory...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "Monocle2 Step 1", value = 0, {
      tryCatch({
        chk <- .runtime_check()
        rv$runtime <- chk
        validate(need(isTRUE(chk$ok), chk$summary))

        setProgress(value = 0.1, detail = "Validating object and grouping")
        obj <- monocle2_beta_get_object(shared_data, input$monocle2_object)
        validate(need(!is.null(obj) && inherits(obj, "Seurat"), "Selected object is unavailable."))
        validate(need(input$monocle2_group_by %in% colnames(obj@meta.data), "Choose a valid metadata grouping column."))

        setProgress(value = 0.3, detail = "Running trajectory inference")
        dat <- monocle2_beta_run_trajectory(
          sobj = obj,
          group_col = input$monocle2_group_by,
          assay = input$monocle2_assay %||% NULL,
          ordering_genes = as.integer(input$monocle2_n_genes %||% 1000L),
          min_expr = as.numeric(input$monocle2_min_expr %||% 0.1),
          root_state = input$monocle2_root_state %||% NULL,
          reverse = isTRUE(input$monocle2_reverse)
        )

        setProgress(value = 0.85, detail = "Preparing branch-state options")
        rv$traj_dat <- dat
        rv$beam_dat <- NULL

        states <- monocle2_beta_state_levels(dat)
        state_choices <- c("(Auto)" = "")
        if (length(states)) state_choices <- c(state_choices, setNames(states, states))

        updateSelectInput(session, "monocle2_root_state", choices = state_choices, selected = "")
        updateSelectInput(session, "monocle2_branch_state_a", choices = state_choices, selected = .safe_first(states, ""))
        updateSelectInput(session, "monocle2_branch_state_b", choices = state_choices, selected = if (length(states) >= 2L) states[[2]] else "")

        rv$status <- sprintf(
          "Step 1 complete: object=%s, assay=%s, ordering_genes=%s, states=%s",
          input$monocle2_object,
          dat$assay %||% (input$monocle2_assay %||% ""),
          as.integer(input$monocle2_n_genes %||% 1000L),
          length(states)
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 1 complete")
        updateTabsetPanel(session, "monocle2_workflow_tabs", selected = "Step 1 Trajectory")
      }, error = function(e) {
        rv$status <- paste("Step 1 failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[monocle2][step1] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  observeEvent(input$monocle2_refresh, {
    overlay_show("Monocle2 Step 2: running BEAM...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "Monocle2 Step 2 BEAM", value = 0, {
      tryCatch({
        chk <- .runtime_check()
        rv$runtime <- chk
        validate(need(isTRUE(chk$ok), chk$summary))

        setProgress(value = 0.1, detail = "Validating trajectory from Step 1")
        validate(need(!is.null(rv$traj_dat), "Run Step 1 trajectory first."))

        setProgress(value = 0.35, detail = "Running BEAM branch analysis")
        bdat <- monocle2_beta_run_beam(
          traj_dat = rv$traj_dat,
          branch_state_a = input$monocle2_branch_state_a %||% "",
          branch_state_b = input$monocle2_branch_state_b %||% "",
          branch_point = as.integer(input$monocle2_branch_point %||% 1L),
          top_genes = as.integer(input$monocle2_beam_top_genes %||% 80L),
          num_clusters = as.integer(input$monocle2_beam_clusters %||% 6L),
          cores = as.integer(input$monocle2_cores %||% 1L)
        )
        setProgress(value = 0.88, detail = "Preparing BEAM outputs")
        rv$beam_dat <- bdat

        rv$status <- sprintf(
          "Step 2 complete: branch_state_a=%s, branch_state_b=%s, branch_point=%s",
          bdat$branch_state_a %||% (input$monocle2_branch_state_a %||% ""),
          bdat$branch_state_b %||% (input$monocle2_branch_state_b %||% ""),
          as.integer(bdat$branch_point %||% input$monocle2_branch_point %||% 1L)
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 2 complete")
        updateTabsetPanel(session, "monocle2_workflow_tabs", selected = "Step 2 BEAM")
      }, error = function(e) {
        rv$status <- paste("Step 2 failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[monocle2][step2] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  .traj <- reactive({ req(!is.null(rv$traj_dat)); rv$traj_dat })
  .beam <- reactive({ req(!is.null(rv$beam_dat)); rv$beam_dat })

  output$monocle2_step1_empty_ui <- renderUI({
    if (!is.null(rv$traj_dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No trajectory plots yet. Run 'Run Step 1: Build Trajectory' first.",
      height_px = 92L
    )
  })
  output$monocle2_step2_empty_ui <- renderUI({
    if (!is.null(rv$beam_dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No BEAM plots yet. Run Step 1 first, then 'Run Step 2: Run BEAM'.",
      height_px = 92L
    )
  })

  output$monocle2_traj_plot <- renderPlotly({
    d <- .traj()
    split_col <- .safe_split_col(input$monocle2_split_by %||% "__none__")
    emb <- .traj_with_split(d, split_col = split_col)
    .render_split_scatter(emb, color_col = "pseudotime", file_stub = "monocle2_trajectory_pseudotime")
  })

  output$monocle2_group_plot <- renderPlotly({
    d <- .traj()
    split_col <- .safe_split_col(input$monocle2_split_by %||% "__none__")
    emb <- .traj_with_split(d, split_col = split_col)
    .render_split_scatter(emb, color_col = "group", file_stub = "monocle2_trajectory_group")
  })

  output$monocle2_heatmap_plot <- renderPlotly({
    d <- .beam()
    h <- d$heat
    validate(need(is.matrix(h), "No BEAM heatmap matrix returned."))
    plotly::plot_ly(z = h, x = colnames(h), y = rownames(h), type = "heatmap", colorscale = "YlOrRd")
  })

  output$monocle2_divergence_plot <- renderPlotly({
    d <- .beam()
    dd <- .as_df(d$divergence)
    validate(need(nrow(dd) > 0, "No BEAM divergence table returned."))
    if (!"qval_plot" %in% colnames(dd)) dd$qval_plot <- -log10(pmax(as.numeric(dd$qval %||% 1), 1e-300))
    if (!"effect_plot" %in% colnames(dd)) {
      if ("distance" %in% colnames(dd)) {
        dd$effect_plot <- as.numeric(dd$distance)
      } else if ("pval" %in% colnames(dd)) {
        dd$effect_plot <- -log10(pmax(as.numeric(dd$pval), 1e-300))
      } else {
        dd$effect_plot <- seq_len(nrow(dd))
      }
    }
    plotly::plot_ly(dd, x = ~effect_plot, y = ~qval_plot, text = ~gene, type = "scatter", mode = "markers")
  })
}
