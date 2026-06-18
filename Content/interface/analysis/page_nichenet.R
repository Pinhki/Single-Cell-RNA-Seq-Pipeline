NICHENET_UI_TEXT <- list(
  title = "Analysis: NicheNet",
  subtitle = "Run package-native NicheNet ligand prioritization for selected sender/receiver groups, with optional condition contrast, and inspect ligand-target/receptor evidence maps.",
  status_ready = "Ready. Run Step 1 to validate sender/receiver setup and resources, then run Step 2 to execute NicheNet."
)

`%||%` <- function(a, b) if (is.null(a)) b else a

nichenet_ui <- fluidPage(
  class = "plotting-page advanced-analysis-page",
  div(class = "page-header", h2(icon("bullseye"), " ", NICHENET_UI_TEXT$title, " ", tags$span("alpha", class = "alpha-badge")), p(NICHENET_UI_TEXT$subtitle)),
  fluidRow(
    column(
      3,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        tags$strong("Step 1: Setup parameters"),
        selectInput("nichenet_object", "Object", choices = character(0)),
        selectInput("nichenet_assay", "Assay", choices = character(0)),
        selectInput("nichenet_species", "Species", choices = c("Human" = "human", "Mouse" = "mouse"), selected = "human"),
        selectInput("nichenet_group_col", "Sender/receiver column (meta.data)", choices = character(0)),
        selectInput("nichenet_sender", "Sender group", choices = character(0)),
        selectInput("nichenet_receiver", "Receiver group", choices = character(0)),
        actionButton("nichenet_step1_run", "Run Step 1: Verify Setup", class = "btn btn-outline-primary btn-sm"),
        tags$hr(),
        tags$strong("Step 2: Resource + model parameters"),
        uiOutput("nichenet_resource_ui"),
        actionButton("nichenet_download_resources", "Download NicheNet Resources (one-time)", class = "btn btn-outline-primary btn-sm"),
        selectInput("nichenet_condition_col", "Condition column (optional)", choices = setNames("", ""), selected = ""),
        selectInput("nichenet_condition_case", "Condition case", choices = setNames("", ""), selected = ""),
        selectInput("nichenet_condition_control", "Condition control", choices = setNames("", ""), selected = ""),
        sliderInput("nichenet_top_ligands", "Top ligands", min = 10, max = 120, value = 30, step = 5),
        sliderInput("nichenet_top_targets", "Top targets per ligand", min = 50, max = 500, value = 200, step = 10),
        sliderInput("nichenet_expression_pct", "Expression pct cutoff", min = 0.01, max = 0.5, value = 0.1, step = 0.01),
        sliderInput("nichenet_lfc_cutoff", "LFC cutoff", min = 0.05, max = 1.5, value = 0.25, step = 0.05),
        actionButton("nichenet_refresh", "Run Step 2: Execute NicheNet", class = "btn btn-primary btn-sm"),
        tags$hr(),
        uiOutput("nichenet_status_ui"),
        tags$hr(),
        beta_result_object_controls_ui(
          id_prefix = "nichenet_result_io",
          title = "NicheNet Result Object"
        )
      )
    ),
    column(
      9,
      tabsetPanel(
        id = "nichenet_workflow_tabs",
        tabPanel(
          "Step 1 Verify",
          div(
            class = "plot_area_card_style",
            uiOutput("nichenet_step1_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3", h4("Group composition"), plotlyOutput("nichenet_setup_group_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Selected sender/receiver cell counts"), plotlyOutput("nichenet_setup_sr_plot", height = "280px")))
            )
          )
        ),
        tabPanel(
          "Step 2 Outputs",
          div(
            class = "plot_area_card_style",
            uiOutput("nichenet_step2_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3", h4("Ligand activity rank"), plotlyOutput("nichenet_ligand_rank_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Ligand-target heatmap"), plotlyOutput("nichenet_ligand_target_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Ligand-receptor map"), plotlyOutput("nichenet_sr_map_plot", height = "280px")))
            ),
            fluidRow(
              column(12, div(class = "card p-3", h4("Receptor/pathway impact"), plotlyOutput("nichenet_pathway_plot", height = "280px")))
            )
          )
        )
      )
    )
  )
)

nichenet_server <- function(input, output, session, shared_data) {
  .safe_first <- function(x, default = "") if (length(x)) as.character(x[[1]]) else default
  .safe_pick <- function(x, idx = 1L, default = "") {
    if (!length(x)) return(default)
    j <- max(1L, min(as.integer(idx), length(x)))
    as.character(x[[j]])
  }
  .as_df <- function(x) {
    if (is.null(x)) return(data.frame())
    tryCatch(as.data.frame(x, stringsAsFactors = FALSE), error = function(e) data.frame())
  }

  rv <- reactiveValues(status = NICHENET_UI_TEXT$status_ready, setup_dat = NULL, dat = NULL, last_error = "")
  beta_result_object_controls_server(
    input = input,
    output = output,
    session = session,
    shared_data = shared_data,
    id_prefix = "nichenet_result_io",
    get_current_object = function() rv$dat %||% rv$setup_dat,
    set_current_object = function(obj) {
      if (is.list(obj) && !is.null(obj$ligand_target)) {
        rv$dat <- obj
        rv$status <- "Imported NicheNet Step 2 result is now active."
        rv$last_error <- ""
        updateTabsetPanel(session, "nichenet_workflow_tabs", selected = "Step 2 Outputs")
      } else {
        rv$setup_dat <- obj
        rv$status <- "Imported NicheNet Step 1 result is now active."
        rv$last_error <- ""
        updateTabsetPanel(session, "nichenet_workflow_tabs", selected = "Step 1 Verify")
      }
    },
    write_metadata_to_active_object = function(res_obj, sobj) {
      d <- res_obj
      if (is.null(d$sender) && !is.null(rv$dat)) d <- rv$dat
      if (is.null(d) || !is.list(d)) stop("NicheNet result is missing.")

      gcol <- as.character(d$group_col %||% "")
      sender <- as.character(d$sender %||% "")
      receiver <- as.character(d$receiver %||% "")
      if (!nzchar(gcol) || !(gcol %in% colnames(sobj@meta.data))) {
        stop("NicheNet grouping column is unavailable in active Seurat object.")
      }
      grp <- as.character(sobj@meta.data[[gcol]])
      grp[is.na(grp)] <- ""

      cn_s <- "nichenet_is_sender_group"
      cn_r <- "nichenet_is_receiver_group"
      sobj[[cn_s]] <- as.integer(grp %in% sender)
      sobj[[cn_r]] <- as.integer(grp %in% receiver)

      lig <- .as_df(d$ligand_rank)
      if (nrow(lig) && all(c("ligand", "score") %in% colnames(lig))) {
        top_lig <- as.character(lig$ligand[[1]])
        top_sc <- as.numeric(lig$score[[1]])
      } else {
        top_lig <- ""
        top_sc <- NA_real_
      }
      sobj[["nichenet_top_ligand"]] <- ifelse(grp %in% receiver, top_lig, NA_character_)
      sobj[["nichenet_top_ligand_score"]] <- ifelse(grp %in% receiver, top_sc, NA_real_)

      list(obj = sobj, added_cols = c(cn_s, cn_r, "nichenet_top_ligand", "nichenet_top_ligand_score"))
    },
    default_workspace_name = "nichenet_result"
  )
  resource_tick <- reactiveVal(0L)
  output$nichenet_status_ui <- renderUI({
    if (nzchar(rv$last_error %||% "")) {
      div(class = "alert alert-danger p-2 mb-0", rv$last_error)
    } else {
      div(class = "small text-muted", rv$status)
    }
  })

  output$nichenet_resource_ui <- renderUI({
    resource_tick()
    sp <- input$nichenet_species %||% "human"
    st <- nichenet_beta_resource_status(sp)
    size_txt <- paste0("~", format(round(st$total_mb), big.mark = ","), " MB")
    if (isTRUE(st$complete)) {
      return(div(class = "alert alert-success p-2 small", strong("Resource status: ready"), tags$br(), "All files found in ", tags$code(st$dir), ". Total footprint: ", size_txt, "."))
    }
    miss <- st$files$file[!st$files$exists]
    div(
      class = "alert alert-warning p-2 small",
      strong("Resource status: missing files"), tags$br(),
      "Missing ", length(miss), " file(s): ", paste(miss, collapse = ", "), tags$br(),
      "Download happens once per species and is reused. Estimated footprint: ", size_txt, "."
    )
  })

  observe({
    nms <- nichenet_beta_object_names(shared_data)
    cur <- isolate(input$nichenet_object %||% "")
    active_nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
    sel <- if (nzchar(cur) && cur %in% nms) cur else if (nzchar(active_nm) && active_nm %in% nms) active_nm else .safe_first(nms)
    updateSelectInput(session, "nichenet_object", choices = nms, selected = sel)
  })

  observeEvent(
    list(input$nichenet_object, shared_data$active_object_name, shared_data$all_seurat_objects, shared_data$filtered_objects),
    {
      overlay_show("NicheNet: loading object metadata...")
      on.exit(overlay_hide(), add = TRUE)
      tryCatch({
        obj <- nichenet_beta_get_object(shared_data, input$nichenet_object)
        if (is.null(obj) || !inherits(obj, "Seurat")) {
          updateSelectInput(session, "nichenet_group_col", choices = character(0), selected = "")
          updateSelectInput(session, "nichenet_assay", choices = character(0), selected = "")
          updateSelectInput(session, "nichenet_condition_col", choices = setNames("", ""), selected = "")
          return(invisible(NULL))
        }

        cols <- nichenet_beta_meta_cols(obj)
        cur_col <- isolate(input$nichenet_group_col %||% "")
        def_col <- if (nzchar(cur_col) && cur_col %in% cols) cur_col else nichenet_beta_default_group(cols)
        updateSelectInput(session, "nichenet_group_col", choices = cols, selected = def_col)

        assays <- nichenet_beta_assays(obj)
        cur_assay <- isolate(input$nichenet_assay %||% "")
        def_assay <- if (nzchar(cur_assay) && cur_assay %in% assays) cur_assay else nichenet_beta_default_assay(obj)
        updateSelectInput(session, "nichenet_assay", choices = assays, selected = def_assay)

        cond_cur <- isolate(input$nichenet_condition_col %||% "")
        cond_sel <- if (nzchar(cond_cur) && cond_cur %in% cols) cond_cur else ""
        updateSelectInput(session, "nichenet_condition_col", choices = c("(None)" = "", setNames(cols, cols)), selected = cond_sel)
      }, error = function(e) {
        warning(sprintf("[nichenet][selectors] %s", conditionMessage(e)), call. = FALSE, immediate. = TRUE)
        updateSelectInput(session, "nichenet_group_col", choices = character(0), selected = "")
        updateSelectInput(session, "nichenet_assay", choices = character(0), selected = "")
        updateSelectInput(session, "nichenet_condition_col", choices = setNames("", ""), selected = "")
      })
    },
    ignoreInit = FALSE
  )

  observe({
    obj <- nichenet_beta_get_object(shared_data, input$nichenet_object)
    grp_col <- input$nichenet_group_col %||% ""
    if (is.null(obj) || !inherits(obj, "Seurat") || !nzchar(grp_col) || !(grp_col %in% colnames(obj@meta.data))) {
      updateSelectInput(session, "nichenet_sender", choices = character(0), selected = "")
      updateSelectInput(session, "nichenet_receiver", choices = character(0), selected = "")
      return(invisible(NULL))
    }

    lv <- sort(unique(as.character(obj@meta.data[[grp_col]])))
    lv <- lv[nzchar(lv)]

    cur_sender <- isolate(input$nichenet_sender %||% "")
    cur_receiver <- isolate(input$nichenet_receiver %||% "")
    sender_sel <- if (nzchar(cur_sender) && cur_sender %in% lv) cur_sender else .safe_first(lv)
    receiver_sel <- if (nzchar(cur_receiver) && cur_receiver %in% lv) cur_receiver else .safe_pick(lv, 2L, sender_sel)

    updateSelectInput(session, "nichenet_sender", choices = lv, selected = sender_sel)
    updateSelectInput(session, "nichenet_receiver", choices = lv, selected = receiver_sel)
  })

  observe({
    obj <- nichenet_beta_get_object(shared_data, input$nichenet_object)
    cc <- input$nichenet_condition_col %||% ""
    vals <- character(0)
    if (!is.null(obj) && inherits(obj, "Seurat") && nzchar(cc) && cc %in% colnames(obj@meta.data)) {
      vals <- sort(unique(as.character(obj@meta.data[[cc]])))
      vals <- vals[nzchar(vals)]
    }
    case_sel <- if ((input$nichenet_condition_case %||% "") %in% vals) input$nichenet_condition_case else .safe_first(vals)
    ctrl_sel <- if ((input$nichenet_condition_control %||% "") %in% vals) input$nichenet_condition_control else .safe_pick(vals, 2L, case_sel)
    updateSelectInput(session, "nichenet_condition_case", choices = c(setNames("", ""), vals), selected = case_sel)
    updateSelectInput(session, "nichenet_condition_control", choices = c(setNames("", ""), vals), selected = ctrl_sel)
  })

  observeEvent(input$nichenet_download_resources, {
    overlay_show("NicheNet: downloading resources...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "NicheNet Resource Download", value = 0, {
      tryCatch({
        setProgress(value = 0.1, detail = "Checking existing resources")
        sp <- input$nichenet_species %||% "human"
        st0 <- nichenet_beta_resource_status(sp)
        if (isTRUE(st0$complete)) {
          rv$status <- sprintf("NicheNet resources already available for %s.", sp)
          rv$last_error <- ""
          setProgress(value = 1, detail = "Resources already available")
          showNotification(rv$status, type = "message")
          resource_tick(resource_tick() + 1L)
          return(invisible(NULL))
        }

        setProgress(value = 0.3, detail = "Downloading one-time resources")
        nichenet_beta_download_resources(sp, progress = function(msg) showNotification(msg, type = "message", duration = 2))
        setProgress(value = 0.9, detail = "Validating downloaded resources")
        st1 <- nichenet_beta_resource_status(sp)
        rv$status <- sprintf("NicheNet resources ready for %s at %s.", sp, st1$dir)
        rv$last_error <- ""
        setProgress(value = 1, detail = "Resource download complete")
        showNotification(rv$status, type = "message")
        resource_tick(resource_tick() + 1L)
      }, error = function(e) {
        rv$status <- paste("Resource download failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[nichenet][download_resources] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  observeEvent(input$nichenet_step1_run, {
    overlay_show("NicheNet Step 1: verifying sender/receiver setup...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "NicheNet Step 1 Verify", value = 0, {
      tryCatch({
        setProgress(value = 0.12, detail = "Validating sender/receiver setup")
        obj <- nichenet_beta_get_object(shared_data, input$nichenet_object)
        validate(need(!is.null(obj) && inherits(obj, "Seurat"), "Selected object is unavailable."))
        validate(need(input$nichenet_group_col %in% colnames(obj@meta.data), "Choose a valid metadata grouping column."))
        validate(need(nzchar(input$nichenet_sender %||% "") && nzchar(input$nichenet_receiver %||% ""), "Choose sender and receiver groups."))

        setProgress(value = 0.5, detail = "Computing group and sender/receiver counts")
        grp <- as.character(obj@meta.data[[input$nichenet_group_col]])
        grp[is.na(grp) | !nzchar(grp)] <- "Unknown"
        tab <- sort(table(grp), decreasing = TRUE)

        rv$setup_dat <- list(
          group_counts = data.frame(group = names(tab), n = as.numeric(tab), stringsAsFactors = FALSE),
          sr_counts = data.frame(
            label = c("Sender", "Receiver"),
            count = c(sum(grp == input$nichenet_sender, na.rm = TRUE), sum(grp == input$nichenet_receiver, na.rm = TRUE)),
            stringsAsFactors = FALSE
          )
        )

        setProgress(value = 0.9, detail = "Checking resource readiness")
        st <- nichenet_beta_resource_status(input$nichenet_species %||% "human")
        rv$status <- sprintf(
          "Step 1 complete: sender=%s, receiver=%s, resources=%s",
          input$nichenet_sender,
          input$nichenet_receiver,
          if (isTRUE(st$complete)) "ready" else "missing"
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 1 complete")
        updateTabsetPanel(session, "nichenet_workflow_tabs", selected = "Step 1 Verify")
      }, error = function(e) {
        rv$status <- paste("Step 1 failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[nichenet][step1] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  observeEvent(input$nichenet_refresh, {
    overlay_show("NicheNet Step 2: running ligand prioritization...")
    on.exit(overlay_hide(), add = TRUE)

    withProgress(message = "NicheNet Step 2 Run", value = 0, {
      tryCatch({
        setProgress(value = 0.1, detail = "Validating Step 1 setup")
        validate(need(!is.null(rv$setup_dat), "Run Step 1 first."))

        setProgress(value = 0.2, detail = "Loading selected object")
        obj <- nichenet_beta_get_object(shared_data, input$nichenet_object)
        validate(need(!is.null(obj) && inherits(obj, "Seurat"), "Selected object is unavailable."))

        setProgress(value = 0.35, detail = "Running ligand prioritization")
        dat <- nichenet_beta_run(
          sobj = obj,
          group_col = input$nichenet_group_col,
          sender_level = input$nichenet_sender,
          receiver_level = input$nichenet_receiver,
          species = input$nichenet_species %||% "human",
          assay = input$nichenet_assay %||% NULL,
          condition_col = input$nichenet_condition_col %||% "",
          condition_case = input$nichenet_condition_case %||% "",
          condition_control = input$nichenet_condition_control %||% "",
          top_ligands = as.integer(input$nichenet_top_ligands %||% 30L),
          top_targets = as.integer(input$nichenet_top_targets %||% 200L),
          expression_pct = as.numeric(input$nichenet_expression_pct %||% 0.1),
          lfc_cutoff = as.numeric(input$nichenet_lfc_cutoff %||% 0.25)
        )

        setProgress(value = 0.9, detail = "Preparing ligand-target outputs")
        rv$dat <- dat
        rv$status <- sprintf(
          "Step 2 complete: sender=%s, receiver=%s, mode=%s",
          dat$sender %||% (input$nichenet_sender %||% ""),
          dat$receiver %||% (input$nichenet_receiver %||% ""),
          dat$condition_mode %||% "default"
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 2 complete")
        updateTabsetPanel(session, "nichenet_workflow_tabs", selected = "Step 2 Outputs")
      }, error = function(e) {
        rv$status <- paste("Step 2 failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[nichenet][step2] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(rv$status, type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  .setup <- reactive({ req(!is.null(rv$setup_dat)); rv$setup_dat })
  .dat <- reactive({ req(!is.null(rv$dat)); rv$dat })

  output$nichenet_step1_empty_ui <- renderUI({
    if (!is.null(rv$setup_dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No NicheNet Step 1 plots yet. Run 'Run Step 1: Verify Setup' first.",
      height_px = 92L
    )
  })
  output$nichenet_step2_empty_ui <- renderUI({
    if (!is.null(rv$dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No NicheNet Step 2 plots yet. Run Step 1 first, then 'Run Step 2: Execute NicheNet'.",
      height_px = 92L
    )
  })

  output$nichenet_setup_group_plot <- renderPlotly({
    d <- .setup()
    validate(need(nrow(d$group_counts) > 0, "No group composition available from Step 1."))
    plotly::plot_ly(d$group_counts, x = ~group, y = ~n, type = "bar")
  })

  output$nichenet_setup_sr_plot <- renderPlotly({
    d <- .setup()
    validate(need(nrow(d$sr_counts) > 0, "No sender/receiver counts available from Step 1."))
    plotly::plot_ly(d$sr_counts, x = ~label, y = ~count, type = "bar")
  })

  output$nichenet_ligand_rank_plot <- renderPlotly({
    d <- .dat()
    rank_df <- .as_df(d$ligand_rank)
    validate(need(nrow(rank_df) > 0, "No ligand ranking available from Step 2."))
    plotly::plot_ly(rank_df, x = ~ligand, y = ~score, type = "bar")
  })

  output$nichenet_ligand_target_plot <- renderPlotly({
    d <- .dat()
    lt <- d$ligand_target
    validate(need(is.matrix(lt), "No ligand-target matrix available from Step 2."))
    plotly::plot_ly(z = lt, x = colnames(lt), y = rownames(lt), type = "heatmap", colorscale = "Blues")
  })

  output$nichenet_sr_map_plot <- renderPlotly({
    d <- .dat()
    p <- .as_df(d$sender_receiver_pairs)
    validate(need(nrow(p) > 0, "No ligand-receptor map available from Step 2."))
    p <- utils::head(p[order(p$score, decreasing = TRUE), , drop = FALSE], 120)
    lbl <- if (all(c("ligand", "receptor") %in% colnames(p))) paste0(p$ligand, " -> ", p$receptor) else paste0(p$sender, " -> ", p$receiver)
    plotly::plot_ly(p, x = ~sender, y = ~receiver, type = "scatter", mode = "markers", size = ~score, color = ~score, text = lbl, hoverinfo = "text")
  })

  output$nichenet_pathway_plot <- renderPlotly({
    d <- .dat()
    pw <- .as_df(d$pathway_like)
    validate(need(nrow(pw) > 0, "No receptor/pathway impact summary available from Step 2."))
    plotly::plot_ly(pw, x = ~name, y = ~score, type = "bar")
  })
}
