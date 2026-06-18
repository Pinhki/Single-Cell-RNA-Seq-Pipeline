RNA_VELOCITY_V052_UI_TEXT <- list(
  title = "Analysis: RNA Velocity v0.5.2",
  subtitle = "Hidden alpha workflow for loom-based scVelo execution inside the pipeline.",
  status_ready = "Ready. Upload a loom file, confirm runtime preflight, then run velocity.",
  runtime_title = "Runtime preflight",
  run_note = "This hidden page requires managed Python env readiness and matching barcodes between loom and Seurat object."
)

`%||%` <- function(a, b) if (is.null(a)) b else a

rna_velocity_v052_ui <- fluidPage(
  class = "plotting-page",
  div(
    class = "page-header",
    h2(icon("wind"), " ", RNA_VELOCITY_V052_UI_TEXT$title, " ", tags$span("alpha", class = "alpha-badge")),
    p(RNA_VELOCITY_V052_UI_TEXT$subtitle)
  ),
  fluidRow(
    column(
      3,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        uiOutput("rv052_runtime_ui"),
        tags$hr(),
        tags$strong("Step 1: Inputs"),
        selectInput("rv052_object", "Object", choices = character(0)),
        fileInput("rv052_loom", "Loom file", accept = c(".loom")),
        selectInput("rv052_reduction", "Embedding reduction", choices = character(0)),
        selectInput("rv052_group_by", "Group column (optional)", choices = c("(None)" = ""), selected = ""),
        tags$hr(),
        tags$strong("Step 2: Velocity parameters"),
        selectInput("rv052_mode", "Velocity mode", choices = c("stochastic", "deterministic", "dynamical"), selected = "stochastic"),
        sliderInput("rv052_top_genes", "Top genes", min = 500, max = 5000, value = 2000, step = 100),
        numericInput("rv052_n_pcs", "n_pcs", value = 30, min = 2, max = 100, step = 1),
        numericInput("rv052_neighbors", "n_neighbors", value = 30, min = 2, max = 200, step = 1),
        numericInput("rv052_min_shared_counts", "min_shared_counts", value = 20, min = 1, max = 200, step = 1),
        actionButton("rv052_run_btn", "Run RNA Velocity", class = "btn btn-primary btn-sm"),
        tags$hr(),
        sliderInput("rv052_arrow_scale", "Arrow scale", min = 0.2, max = 4, value = 1.0, step = 0.1),
        sliderInput("rv052_max_arrows", "Max arrows shown", min = 300, max = 4000, value = 1200, step = 100),
        tags$hr(),
        uiOutput("rv052_status_ui"),
        tags$hr(),
        div(class = "alert alert-info p-2 small", strong("Note"), tags$br(), RNA_VELOCITY_V052_UI_TEXT$run_note),
        tags$hr(),
        beta_result_object_controls_ui(
          id_prefix = "rv052_result_io",
          title = "RNA Velocity Result Object"
        )
      )
    ),
    column(
      9,
      tabsetPanel(
        id = "rv052_tabs",
        tabPanel(
          "Velocity Field",
          div(
            class = "plot_area_card_style",
            div(class = "card p-3", h4("Velocity overlay"), plotlyOutput("rv052_velocity_plot", height = "520px"))
          )
        ),
        tabPanel(
          "Summary",
          div(
            class = "plot_area_card_style",
            fluidRow(
              column(6, div(class = "card p-3", h4("Speed distribution"), plotlyOutput("rv052_speed_plot", height = "320px"))),
              column(6, div(class = "card p-3", h4("Run summary"), tableOutput("rv052_summary_table")))
            )
          )
        )
      )
    )
  )
)

rna_velocity_v052_server <- function(input, output, session, shared_data) {
  .safe_first <- function(x, default = "") if (length(x)) as.character(x[[1]]) else default
  .with_plotly_tools <- function(p, file_stub = "rna_velocity") {
    plotly::config(
      p,
      displayModeBar = TRUE,
      displaylogo = FALSE,
      scrollZoom = TRUE,
      toImageButtonOptions = list(format = "png", filename = file_stub, scale = 2)
    )
  }

  rv <- reactiveValues(
    runtime = NULL,
    status = RNA_VELOCITY_V052_UI_TEXT$status_ready,
    dat = NULL,
    last_error = ""
  )

  beta_result_object_controls_server(
    input = input,
    output = output,
    session = session,
    shared_data = shared_data,
    id_prefix = "rv052_result_io",
    get_current_object = function() rv$dat,
    set_current_object = function(obj) {
      rv$dat <- obj
      rv$last_error <- ""
      rv$status <- "Imported RNA velocity result object is now active."
    },
    write_metadata_to_active_object = function(res_obj, sobj) {
      d <- res_obj
      if (is.null(d) || !is.list(d) || is.null(d$vectors)) stop("RNA velocity result is missing vectors.")
      vec <- as.data.frame(d$vectors, stringsAsFactors = FALSE)
      cells <- colnames(sobj)
      map <- match(cells, as.character(vec$cell))

      speed <- rep(NA_real_, length(cells))
      conf <- rep(NA_real_, length(cells))
      lat <- rep(NA_real_, length(cells))

      ok <- !is.na(map)
      if (any(ok)) {
        speed[ok] <- suppressWarnings(as.numeric(vec$speed[map[ok]]))
        conf[ok] <- suppressWarnings(as.numeric(vec$confidence[map[ok]]))
        lat[ok] <- suppressWarnings(as.numeric(vec$latent_time[map[ok]]))
      }

      sobj[["rna_velocity_speed"]] <- speed
      sobj[["rna_velocity_confidence"]] <- conf
      sobj[["rna_velocity_latent_time"]] <- lat
      list(obj = sobj, added_cols = c("rna_velocity_speed", "rna_velocity_confidence", "rna_velocity_latent_time"))
    },
    default_workspace_name = "rna_velocity_v052_result"
  )

  .refresh_runtime <- function() {
    py <- as.character(tryCatch(shared_data$active_environment$python_path, error = function(e) "") %||% "")
    rv$runtime <- tryCatch(
      rna_velocity_beta_python_status(python_path = py),
      error = function(e) list(ok = FALSE, summary = conditionMessage(e), python = py, modules = list())
    )
  }

  observeEvent(shared_data$active_environment, {
    .refresh_runtime()
  }, ignoreInit = FALSE)

  observe({
    nms <- rna_velocity_beta_object_names(shared_data)
    cur <- isolate(input$rv052_object %||% "")
    active_nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
    sel <- if (nzchar(cur) && cur %in% nms) cur else if (nzchar(active_nm) && active_nm %in% nms) active_nm else .safe_first(nms)
    updateSelectInput(session, "rv052_object", choices = nms, selected = sel)
  })

  observeEvent(input$rv052_object, {
    sobj <- rna_velocity_beta_get_object(shared_data, input$rv052_object)
    req(!is.null(sobj))

    reds <- rna_velocity_beta_reductions(sobj)
    red_sel <- if (!length(reds)) "" else {
      cur <- as.character(input$rv052_reduction %||% "")
      if (nzchar(cur) && cur %in% reds) cur else rna_velocity_beta_default_reduction(sobj)
    }
    updateSelectInput(session, "rv052_reduction", choices = reds, selected = red_sel)

    mcols <- rna_velocity_beta_meta_cols(sobj)
    gcur <- as.character(input$rv052_group_by %||% "")
    gsel <- if (nzchar(gcur) && gcur %in% mcols) gcur else ""
    updateSelectInput(session, "rv052_group_by", choices = c("(None)" = "", setNames(mcols, mcols)), selected = gsel)
  }, ignoreInit = FALSE)

  output$rv052_runtime_ui <- renderUI({
    chk <- rv$runtime %||% list(ok = FALSE, summary = "Runtime check pending.", modules = list())
    cls <- if (isTRUE(chk$ok)) "alert alert-success p-2 mb-2 small" else "alert alert-warning p-2 mb-2 small"
    mod_lines <- character(0)
    if (length(chk$modules %||% list())) {
      mod_lines <- vapply(names(chk$modules), function(nm) {
        ok <- isTRUE(chk$modules[[nm]])
        sprintf("%s: %s", nm, if (ok) "OK" else "Missing")
      }, character(1))
    }

    div(
      class = cls,
      tags$strong(RNA_VELOCITY_V052_UI_TEXT$runtime_title), tags$br(),
      as.character(chk$summary %||% ""),
      if (nzchar(as.character(chk$python %||% ""))) tags$div(tags$code(chk$python)),
      if (length(mod_lines)) tags$div(lapply(mod_lines, function(x) tags$div(x)))
    )
  })

  output$rv052_status_ui <- renderUI({
    if (nzchar(rv$last_error %||% "")) {
      div(class = "alert alert-danger p-2 mb-0", rv$last_error)
    } else {
      div(class = "small text-muted", rv$status)
    }
  })

  observeEvent(input$rv052_run_btn, {
    req(nzchar(input$rv052_object %||% ""))
    fi <- input$rv052_loom
    validate(need(!is.null(fi) && nzchar(fi$datapath %||% ""), "Please upload a loom file first."))

    overlay_show("RNA velocity: running scVelo...")
    on.exit(overlay_hide(), add = TRUE)

    tryCatch({
      sobj <- rna_velocity_beta_get_object(shared_data, input$rv052_object)
      validate(need(!is.null(sobj), "Selected object is not available."))

      py <- as.character(tryCatch(shared_data$active_environment$python_path, error = function(e) "") %||% "")
      out <- rna_velocity_beta_run_from_loom(
        sobj = sobj,
        loom_path = fi$datapath,
        reduction = input$rv052_reduction,
        group_col = input$rv052_group_by,
        python_path = py,
        mode = input$rv052_mode,
        n_top_genes = as.integer(input$rv052_top_genes %||% 2000L),
        n_pcs = as.integer(input$rv052_n_pcs %||% 30L),
        n_neighbors = as.integer(input$rv052_neighbors %||% 30L),
        min_shared_counts = as.integer(input$rv052_min_shared_counts %||% 20L)
      )

      rv$dat <- out
      rv$last_error <- ""
      rv$status <- sprintf(
        "Velocity run completed. Cells=%s | exact=%s | normalized=%s",
        out$summary$n_cells %||% 0,
        out$summary$n_exact %||% 0,
        out$summary$n_normalized %||% 0
      )
      updateTabsetPanel(session, "rv052_tabs", selected = "Velocity Field")
    }, error = function(e) {
      rv$last_error <- paste("RNA velocity failed:", conditionMessage(e))
      rv$status <- "Run failed."
      showNotification(rv$last_error, type = "error", duration = NULL)
    })
  }, ignoreInit = TRUE)

  output$rv052_velocity_plot <- renderPlotly({
    req(rv$dat)
    vec <- as.data.frame(rv$dat$vectors, stringsAsFactors = FALSE)
    validate(need(nrow(vec) > 0, "No velocity vectors available."))

    max_n <- as.integer(input$rv052_max_arrows %||% 1200L)
    if (nrow(vec) > max_n) {
      set.seed(1)
      keep <- sample(seq_len(nrow(vec)), max_n)
      vec <- vec[keep, , drop = FALSE]
    }

    scl <- as.numeric(input$rv052_arrow_scale %||% 1)
    if (!is.finite(scl) || is.na(scl) || scl <= 0) scl <- 1

    vec$xend <- vec$x + vec$vx * scl
    vec$yend <- vec$y + vec$vy * scl

    p <- plotly::plot_ly(
      vec,
      x = ~x,
      y = ~y,
      color = ~group,
      type = "scattergl",
      mode = "markers",
      marker = list(size = 4, opacity = 0.72),
      hovertemplate = paste0(
        "cell=%{text}<br>",
        "speed=%{customdata:.4f}<extra></extra>"
      ),
      text = ~cell,
      customdata = ~speed
    )

    p <- plotly::add_segments(
      p,
      x = ~x,
      y = ~y,
      xend = ~xend,
      yend = ~yend,
      inherit = FALSE,
      line = list(color = "rgba(17,24,39,0.35)", width = 1),
      hoverinfo = "skip",
      showlegend = FALSE
    )

    p <- plotly::layout(p, xaxis = list(title = "UMAP 1"), yaxis = list(title = "UMAP 2"))
    .with_plotly_tools(p, file_stub = "rna_velocity_v052")
  })

  output$rv052_speed_plot <- renderPlotly({
    req(rv$dat)
    vec <- as.data.frame(rv$dat$vectors, stringsAsFactors = FALSE)
    validate(need(nrow(vec) > 0, "No speed values available."))

    p <- plotly::plot_ly(
      vec,
      x = ~speed,
      color = ~group,
      type = "histogram",
      nbinsx = 40,
      opacity = 0.75
    )
    p <- plotly::layout(p, barmode = "overlay", xaxis = list(title = "Velocity speed"), yaxis = list(title = "Cell count"))
    .with_plotly_tools(p, file_stub = "rna_velocity_speed")
  })

  output$rv052_summary_table <- renderTable({
    req(rv$dat)
    sm <- rv$dat$summary %||% list()
    data.frame(
      Metric = c("Cells used", "Exact barcode matches", "Normalized barcode matches", "Median speed"),
      Value = c(
        as.character(sm$n_cells %||% NA),
        as.character(sm$n_exact %||% NA),
        as.character(sm$n_normalized %||% NA),
        format(signif(as.numeric(sm$speed_median %||% NA_real_), 4), scientific = FALSE)
      ),
      stringsAsFactors = FALSE
    )
  }, striped = TRUE, bordered = TRUE, width = "100%")
}
