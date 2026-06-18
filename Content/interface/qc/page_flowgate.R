# interface/page_flowgate.R

UI_TEXT <- list(
  t_btn_add_filtered_workspace = "Add filtered to workspace",
  t_btn_add_gate = "Add gate",
  t_btn_run_stepwise_gating = "Run stepwise gating",
  t_label_blue_channel = "Blue channel",
  t_label_choose_object_gate = "Choose object to gate:",
  t_label_green_channel = "Green channel",
  t_label_red_channel = "Red channel",
  t_label_save_diagnostics_pdf = "Save diagnostics PDF",
  t_label_search_gene = "Search gene...",
  t_text_build_stepwise_gates_like_flowjo_customizable = "Build stepwise gates like FlowJo: customizable gene lists + thresholds, with histogram and UMAP recheck.",
  t_text_drag_cards_reorder_stepwise_filtering = "Drag cards to reorder stepwise filtering:",
  t_text_drag_drop_ordering_unavailable_package_sortable = "Drag-and-drop ordering unavailable: package 'sortable' is not installed in this runtime.",
  t_text_no_gates_click_add_gate = "No gates. Click Add gate.",
  t_text_no_seurat_objects_available_yet = "No Seurat objects available yet.",
  t_text_search_add_genes = "Search and add genes...",
  t_text_gate_index_separator = ". ",
  t_title_gate_histograms = "Gate histograms",
  t_title_histogram_gating = "Histogram gating",
  t_title_qc_flow_like_gating_t_lineage = "QC: Flow-like gating (T / lineage filtering)",
  t_title_rgb_confocal_umap = "RGB Confocal UMAP",
  t_title_settings = "Settings",
  t_title_stepwise_summary = "Stepwise summary",
  t_title_umap_recheck = "UMAP recheck",
  t_label_gate_name = "Gate name",
  t_label_gate_genes = "Gate genes",
  t_label_threshold_value = "Threshold value",
  t_label_active = "Active"

)

`%||%` <- function(a, b) if (!is.null(a)) a else b

flowgate_ui <- fluidPage(
  tags$head(
    tags$style(HTML("\n      .header-row { display:flex; align-items:flex-start; justify-content:space-between; margin-bottom:2px; }\n      .flow-inline-note { margin: 10px 0 12px 0; padding: 14px 16px; border-radius: 8px; font-size: 1.05rem; }\n      .flow-inline-note.alert-info { background-color: #3d95cf; color: #ffffff; border-color: #3d95cf; }\n      .flow-gates-wrap { margin-left: -4px; margin-right: -4px; }\n      .flow-gate-card { border: 1px solid #d4d9de; border-radius: 8px; padding: 6px 8px; margin-bottom: 4px; background: transparent; }\n      .flow-gate-card:focus, .flow-gate-card:focus-within { outline: none; box-shadow: none; }\n      .flow-gate-card > summary { list-style: none; }\n      .flow-gate-card > summary::-webkit-details-marker { display: none; }\n      .flow-gate-head { display:flex; justify-content:space-between; align-items:center; gap:6px; margin-bottom:0; }\n      .flow-gate-title { font-weight: 600; font-size: 14px; line-height: 1.2; }\n      .flow-gate-head-left { display:flex; align-items:center; gap:8px; min-width: 0; }\n      .flow-caret { width: 12px; color:#475569; transition: transform 140ms ease; }\n      .flow-gate-card[open] .flow-caret { transform: rotate(90deg); }\n      .flow-gate-drag { cursor: grab; color:#6b7280; }\n      .flow-gate-del-btn.btn { min-width: 22px; width: 22px; height: 22px; padding: 0; border-radius: 6px; background: transparent !important; border: 1px solid #cbd5e1 !important; color: #64748b !important; box-shadow: none !important; }\n      .flow-gate-del-btn.btn:hover, .flow-gate-del-btn.btn:focus { background: rgba(239,68,68,0.06) !important; border-color: #ef4444 !important; color: #ef4444 !important; }\n      .flow-gate-del-btn .fa { font-size: 12px; }\n      .flow-gate-card .form-group { margin-bottom: 6px !important; }\n      .flow-gate-card .irs { margin-bottom: 0; }\n      .flow-gate-card .radio-inline { margin-right: 14px; }\n      .flow-tab-wrap .nav-tabs { margin-bottom: 12px; }\n      .rank-list-container, .rank-list { border: 0 !important; background: transparent !important; padding: 0 !important; margin: 0 !important; }\n      .rank-list-title { margin: 0 0 6px 0 !important; }\n      .rank-list-item { border: 0 !important; background: transparent !important; padding: 0 !important; margin: 0 0 4px 0 !important; }\n    ")),
    tags$script(HTML("\n      document.addEventListener('toggle', function(e) {\n        var el = e.target;\n        if (!el || !el.classList || !el.classList.contains('flow-gate-card')) return;\n        if (!el.open) return;\n        var root = el.parentElement || document;\n        var cards = root.querySelectorAll('.flow-gate-card');\n        cards.forEach(function(card){ if (card !== el) card.open = false; });\n      }, true);\n    "))
  ),
  div(
    class = "page-header",
    h2(icon("sliders"), " ", UI_TEXT$t_title_qc_flow_like_gating_t_lineage, " ", tags$span("beta", class = "beta-badge")),
    p(UI_TEXT$t_text_build_stepwise_gates_like_flowjo_customizable)
  ),
  uiOutput("flowgate_notice_ui"),
  div(
    class = "flow-tab-wrap",
    tabsetPanel(
      id = "flowgate_tabs",
      tabPanel(
        UI_TEXT$t_title_histogram_gating,
        br(),
        sidebarLayout(
          sidebarPanel(
            width = 4,
            class = "plotting-left-panel",
            h4(UI_TEXT$t_title_settings),
            uiOutput("flowgate_object_selector_ui"),
            fluidRow(
              column(12, actionButton("flowgate_add_gate", UI_TEXT$t_btn_add_gate, icon = icon("plus"), class = "btn btn-outline-primary btn-sm w-100"))
            ),
            div(style = "height:8px"),
            div(class = "flow-gates-wrap", uiOutput("flowgate_gate_boxes_ui")),
            checkboxInput("flowgate_make_pdf", UI_TEXT$t_label_save_diagnostics_pdf, value = FALSE),
            actionButton("flowgate_run_btn", UI_TEXT$t_btn_run_stepwise_gating, icon = icon("sliders"), class = "btn btn-primary btn-block"),
            div(style = "height:8px"),
            actionButton("flowgate_add_workspace_btn", UI_TEXT$t_btn_add_filtered_workspace, icon = icon("plus-circle"), class = "btn btn-outline-primary btn-block")
          ),
          mainPanel(
            width = 8,
            class = "plot_area_card_style",
            h4(UI_TEXT$t_title_gate_histograms),
            qc_with_busy_spinner(plotOutput("flowgate_hist_plot", height = "860px")),
            hr(),
            h4(UI_TEXT$t_title_stepwise_summary),
            DT::DTOutput("flowgate_stats_tbl")
          )
        )
      ),
      tabPanel(
        UI_TEXT$t_title_umap_recheck,
        br(),
        sidebarLayout(
          sidebarPanel(
            width = 4,
            class = "plotting-left-panel",
            h4(UI_TEXT$t_title_rgb_confocal_umap),
            uiOutput("flowgate_umap_gene_select_ui")
          ),
          mainPanel(
            width = 8,
            class = "plot_area_card_style",
            fluidRow(
              column(6, qc_with_busy_spinner(plotOutput("flowgate_umap_rgb", height = "520px"))),
              column(6, qc_with_busy_spinner(plotOutput("flowgate_umap_overlay", height = "520px")))
            )
          )
        )
      )
    )
  )
)

flowgate_server <- function(input, output, session, shared_data) {
  ok_later <- requireNamespace("later", quietly = TRUE)
  flow_notice <- reactiveVal(NULL)
  gate_df <- reactiveVal(core_flowgate_default_gates())
  last_result <- reactiveVal(NULL)
  delete_obs <- reactiveValues(ids = character(0))
  has_sortable <- reactiveVal(requireNamespace("sortable", quietly = TRUE))

  .registry <- reactive({
    shared_data$all_seurat_objects %||% list()
  })
  
  .flowgate_seurat_version <- reactive({
    env_name <- tolower(as.character(shared_data$active_environment$name %||% ""))
    if (grepl("seurat5", env_name, fixed = TRUE)) return("5")
    if (grepl("seurat4", env_name, fixed = TRUE)) return("4")
    "auto"
  })

  .candidate_names <- reactive({
    core_flowgate_list_registry_objects(.registry())
  })

  output$flowgate_notice_ui <- renderUI({
    note <- flow_notice()
    if (is.null(note) || !nzchar(note$msg %||% "")) return(NULL)
    cls <- if (identical(note$type, "error")) "alert alert-danger" else if (identical(note$type, "warning")) "alert alert-warning" else "alert alert-info"
    div(class = paste(cls, "flow-inline-note"), note$msg)
  })

  output$flowgate_object_selector_ui <- renderUI({
    objs <- .candidate_names()
    if (!length(objs)) {
      flow_notice(list(type = "info", msg = "No Seurat objects available for flow gating. Add files from the right sidebar first."))
      return(tags$p(UI_TEXT$t_text_no_seurat_objects_available_yet))
    }
    flow_notice(NULL)
    sel <- shared_data$active_object_name %||% objs[[1]]
    if (!sel %in% objs) sel <- objs[[1]]
    selectInput("flowgate_object_name", UI_TEXT$t_label_choose_object_gate, choices = objs, selected = sel)
  })

  current_obj <- reactive({
    objs <- .candidate_names()
    req(length(objs) > 0)
    nm <- input$flowgate_object_name %||% shared_data$active_object_name %||% objs[[1]]
    if (!nm %in% objs) nm <- objs[[1]]
    so <- core_flowgate_get_registry_object(.registry(), nm)
    validate(need(inherits(so, "Seurat"), "Selected object is not a valid Seurat object."))
    so
  })

  current_name <- reactive({
    objs <- .candidate_names()
    req(length(objs) > 0)
    nm <- input$flowgate_object_name %||% shared_data$active_object_name %||% objs[[1]]
    if (!nm %in% objs) nm <- objs[[1]]
    nm
  })

  make_unique_name <- function(base, existing) {
    nm <- base
    idx <- 1L
    while (nm %in% existing) {
      nm <- paste0(base, "_", idx)
      idx <- idx + 1L
    }
    nm
  }

  all_genes <- reactive({
    so <- current_obj()
    rownames(so)
  })

  collect_gate_df <- function() {
    df <- core_flowgate_normalize_gate_df(gate_df())
    if (!nrow(df)) return(df)
    for (i in seq_len(nrow(df))) {
      gid <- df$gate_id[[i]]
      nm_in <- input[[paste0("fg_name_", gid)]]
      dir_in <- input[[paste0("fg_dir_", gid)]]
      q_in <- input[[paste0("fg_q_", gid)]]
      act_in <- input[[paste0("fg_active_", gid)]]
      gn_in <- input[[paste0("fg_genes_", gid)]]
      if (!is.null(nm_in) && nzchar(nm_in)) df$gate_name[[i]] <- nm_in
      if (!is.null(dir_in) && dir_in %in% c("low", "high")) df$direction[[i]] <- dir_in
      if (!is.null(q_in) && is.finite(q_in)) df$threshold_value[[i]] <- as.numeric(q_in)
      if (!is.null(act_in)) df$active[[i]] <- isTRUE(act_in)
      if (!is.null(gn_in)) df$genes_csv[[i]] <- paste(gn_in, collapse = ",")
    }
    core_flowgate_normalize_gate_df(df)
  }

  output$flowgate_gate_boxes_ui <- renderUI({
    df <- core_flowgate_normalize_gate_df(gate_df())
    if (!nrow(df)) return(tags$div(class = "text-muted", UI_TEXT$t_text_no_gates_click_add_gate))

    boxes <- lapply(seq_len(nrow(df)), function(i) {
      g <- df[i, , drop = FALSE]
      gid <- g$gate_id[[1]]
      genes_sel <- trimws(unlist(strsplit(g$genes_csv[[1]], ",", fixed = TRUE)))
      genes_sel <- genes_sel[nzchar(genes_sel)]
      tags$details(
        class = "flow-gate-card",
        open = i == 1L,
        tags$summary(
          div(
            class = "flow-gate-head",
            div(
              class = "flow-gate-head-left",
              icon("chevron-right", class = "flow-caret"),
              icon("grip-lines", class = "flow-gate-drag"),
              span(class = "flow-gate-title", paste0(i, UI_TEXT$t_text_gate_index_separator, g$gate_name[[1]]))
            ),
            actionButton(paste0("fg_delete_", gid), NULL, icon = icon("minus"), class = "flow-gate-del-btn")
          )
        ),
        textInput(paste0("fg_name_", gid), UI_TEXT$t_label_gate_name, value = g$gate_name[[1]]),
        wl_gene_selectize_input(
          paste0("fg_genes_", gid),
          UI_TEXT$t_label_gate_genes,
          selected = genes_sel,
          multiple = TRUE,
          placeholder = UI_TEXT$t_text_search_add_genes
        ),
        radioButtons(
          paste0("fg_dir_", gid),
          "Keep direction",
          choices = c("Keep below threshold" = "low", "Keep above threshold" = "high"),
          selected = g$direction[[1]],
          inline = TRUE
        ),
        sliderInput(paste0("fg_q_", gid), UI_TEXT$t_label_threshold_value, min = 0, max = 1, value = as.numeric(g$threshold_value[[1]]), step = 0.01),
        checkboxInput(paste0("fg_active_", gid), UI_TEXT$t_label_active, value = isTRUE(g$active[[1]]))
      )
    })
    if (isTRUE(has_sortable())) {
      names(boxes) <- as.character(df$gate_id)
      sortable::rank_list(
        text = UI_TEXT$t_text_drag_cards_reorder_stepwise_filtering,
        labels = boxes,
        input_id = "flowgate_gate_order",
        options = sortable::sortable_options(handle = ".flow-gate-drag", animation = 120)
      )
    } else {
      tagList(
        div(class = "text-warning", UI_TEXT$t_text_drag_drop_ordering_unavailable_package_sortable),
        do.call(tagList, boxes)
      )
    }
  })

  observeEvent(list(all_genes(), gate_df()), {
    genes <- all_genes()
    df <- core_flowgate_normalize_gate_df(gate_df())
    if (!length(genes) || !nrow(df)) return()
    for (i in seq_len(nrow(df))) {
      gid <- df$gate_id[[i]]
      id <- paste0("fg_genes_", gid)
      cur <- isolate(input[[id]])
      if (is.null(cur)) {
        cur <- trimws(unlist(strsplit(df$genes_csv[[i]], ",", fixed = TRUE)))
        cur <- cur[nzchar(cur)]
      }
      cur <- cur[tolower(cur) %in% tolower(genes)]
      wl_update_gene_selectize(session, id, genes, selected = cur)
    }
  }, ignoreInit = FALSE)

  observe({
    df <- core_flowgate_normalize_gate_df(gate_df())
    if (!nrow(df)) return()
    for (gid in df$gate_id) {
      obs_id <- paste0("fg_delete_", gid)
      if (obs_id %in% delete_obs$ids) next
      delete_obs$ids <- c(delete_obs$ids, obs_id)
      local({
        id_local <- gid
        input_id_local <- obs_id
        observeEvent(input[[input_id_local]], {
          df_now <- collect_gate_df()
          df_now <- df_now[df_now$gate_id != id_local, , drop = FALSE]
          gate_df(core_flowgate_normalize_gate_df(df_now))
        }, ignoreInit = TRUE)
      })
    }
  })

  observeEvent(input[["flowgate_gate_order:sortablejs.rank_list"]], {
    ord <- input[["flowgate_gate_order:sortablejs.rank_list"]]
    if (is.null(ord) || !length(ord)) return()
    ord_ids <- suppressWarnings(as.integer(ord))
    ord_ids <- ord_ids[is.finite(ord_ids)]
    if (!length(ord_ids)) return()
    df <- collect_gate_df()
    keep_ids <- intersect(ord_ids, df$gate_id)
    if (!length(keep_ids)) return()
    missing_ids <- setdiff(df$gate_id, keep_ids)
    final_ids <- c(keep_ids, missing_ids)
    df <- df[match(final_ids, df$gate_id), , drop = FALSE]
    gate_df(core_flowgate_normalize_gate_df(df))
  }, ignoreInit = TRUE)

  observeEvent(input$flowgate_add_gate, {
    df <- collect_gate_df()
    next_id <- if (nrow(df)) max(df$gate_id) + 1L else 1L
    df <- rbind(df, data.frame(
      gate_id = next_id,
      gate_name = paste0("Gate", next_id),
      genes_csv = "",
      direction = "low",
      threshold_value = 0.10,
      active = TRUE,
      stringsAsFactors = FALSE
    ))
    gate_df(core_flowgate_normalize_gate_df(df))
  })

  observeEvent(input$flowgate_object_name, {
    gate_df(core_flowgate_default_gates())
    last_result(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$flowgate_run_btn, {
    tryCatch({
      objs <- .candidate_names()
      if (!length(objs)) stop("No Seurat objects are available to gate.")
      nm <- current_name()
      so <- current_obj()
      if (!inherits(so, "Seurat")) stop("Selected object is not a valid Seurat object.")
      gd <- collect_gate_df()
      if (!nrow(gd)) stop("No gates defined.")

      tip_msg <- .spinner_pick_tip()
      progress_bar <- shiny::Progress$new(session, min = 0, max = 100)
      on.exit(progress_bar$close(), add = TRUE)
      update_blocker <- function(msg, pct) {
        overlay_show(text = msg, pct = pct, tip = tip_msg)
        progress_bar$set(value = max(0, min(100, as.numeric(pct %||% 0))), message = msg, detail = sprintf("%d%%", as.integer(round(pct %||% 0))))
      }
      yield <- function() { Sys.sleep(0.02); if (ok_later) later::run_now(0.001) }

      update_blocker("Running stepwise flow gating…", 2)
      yield()
      on.exit(overlay_hide(), add = TRUE)
      res <- core_run_flowgate_step(
        seurat_object = so,
        gates = gd,
        ensure_umap = TRUE,
        seurat_version = .flowgate_seurat_version(),
        progress = function(pct = NULL, msg = NULL) {
          update_blocker(msg %||% "Running stepwise flow gating…", pct %||% 2)
          yield()
        }
      )
      update_blocker("Finalizing flow gating…", 100)
      yield()

      last_result(res)
      gate_df(res$gates)
      flow_notice(list(type = "info", msg = paste0("Flow gating completed for ", nm, ". Click 'Add filtered to workspace' to save this result.")))
    }, error = function(e) {
      flow_notice(list(type = "error", msg = paste0("Flow gating failed: ", conditionMessage(e))))
      try(overlay_hide(), silent = TRUE)
    })
  }, ignoreInit = TRUE)

  observeEvent(input$flowgate_add_workspace_btn, {
    res <- last_result()
    if (is.null(res) || is.null(res$seurat_object) || !inherits(res$seurat_object, "Seurat")) {
      flow_notice(list(type = "warning", msg = "Run stepwise gating first, then add the filtered result to workspace."))
      return()
    }
    parent_name <- current_name()
    reg <- .registry()
    out_base <- paste0(parent_name, "_flowgated")
    out_name <- make_unique_name(out_base, names(reg))
    reg[[out_name]] <- list(
      obj = res$seurat_object,
      prefs = list(),
      plots = list(),
      analysis_cache = list(),
      meta = list(
        stage = "flowgated",
        parent = parent_name,
        parents = parent_name,
        params = list(gates = res$gates, n_steps = nrow(res$gates)),
        created = Sys.time()
      )
    )
    shared_data$all_seurat_objects <- reg
    shared_data$active_object_name <- out_name
    flow_notice(list(type = "info", msg = paste0("Added filtered object to workspace: ", out_name)))
  }, ignoreInit = TRUE)

  output$flowgate_hist_plot <- renderPlot({
    res <- last_result()
    if (is.null(res)) {
      plot.new(); title("Run stepwise gating to view histograms.")
      return(invisible(NULL))
    }
    p <- core_flowgate_make_histogram_plot(res$seurat_object)
    if (is.null(p)) {
      plot.new(); title("No histogram data available.")
      return(invisible(NULL))
    }
    print(p)
  })

  output$flowgate_stats_tbl <- DT::renderDT({
    res <- last_result()
    if (is.null(res)) {
      return(DT::datatable(data.frame(Message = "Run stepwise gating to see summary."), options = list(dom = "t", paging = FALSE), rownames = FALSE))
    }
    st <- res$stats
    st$threshold_value <- round(st$threshold_value, 3)
    st$cutoff <- round(st$cutoff, 4)
    DT::datatable(st, rownames = FALSE, options = list(pageLength = 20, scrollX = TRUE))
  }, server = FALSE)

  output$flowgate_umap_gene_select_ui <- renderUI({
    genes <- all_genes()
    req(length(genes) > 0)
    pick_gene <- function(cur, fallback) {
      cur <- cur %||% fallback
      if (!nzchar(cur)) cur <- fallback
      if (cur %in% genes) return(cur)
      m <- match(tolower(cur), tolower(genes))
      if (!is.na(m)) return(genes[[m]])
      mf <- match(tolower(fallback), tolower(genes))
      if (!is.na(mf)) return(genes[[mf]])
      genes[[1]]
    }
    sel_r <- pick_gene(isolate(input$flow_rgb_r), "Cd3e")
    sel_g <- pick_gene(isolate(input$flow_rgb_g), "Trac")
    sel_b <- pick_gene(isolate(input$flow_rgb_b), "Tcrb")
    tagList(
      wl_gene_selectize_input("flow_rgb_r", UI_TEXT$t_label_red_channel, selected = sel_r, placeholder = UI_TEXT$t_label_search_gene),
      wl_gene_selectize_input("flow_rgb_g", UI_TEXT$t_label_green_channel, selected = sel_g, placeholder = UI_TEXT$t_label_search_gene),
      wl_gene_selectize_input("flow_rgb_b", UI_TEXT$t_label_blue_channel, selected = sel_b, placeholder = UI_TEXT$t_label_search_gene)
    )
  })

  observeEvent(all_genes(), {
    genes <- all_genes()
    req(length(genes) > 0)
    pick_gene <- function(cur, fallback) {
      cur <- cur %||% fallback
      if (!nzchar(cur)) cur <- fallback
      if (cur %in% genes) return(cur)
      m <- match(tolower(cur), tolower(genes))
      if (!is.na(m)) return(genes[[m]])
      mf <- match(tolower(fallback), tolower(genes))
      if (!is.na(mf)) return(genes[[mf]])
      genes[[1]]
    }
    for (id in c("flow_rgb_r", "flow_rgb_g", "flow_rgb_b")) {
      fallback <- if (id == "flow_rgb_r") "Cd3e" else if (id == "flow_rgb_g") "Trac" else "Tcrb"
      cur <- pick_gene(isolate(input[[id]]), fallback)
      wl_update_gene_selectize(session, id, genes, selected = cur)
    }
  }, ignoreInit = FALSE)

  umap_obj <- reactive({
    res <- last_result()
    if (!is.null(res)) return(res$seurat_object)
    current_obj()
  })

  output$flowgate_umap_rgb <- renderPlot({
    so <- umap_obj(); req(so)
    genes <- c(input$flow_rgb_r %||% "Cd3e", input$flow_rgb_g %||% "Trac", input$flow_rgb_b %||% "Tcrb")
    p <- core_flowgate_rgb_umap_plot(so, genes = genes, seurat_version = .flowgate_seurat_version())
    if (is.null(p)) {
      plot.new(); title("Select valid RGB genes.")
      return(invisible(NULL))
    }
    print(p)
  })

  output$flowgate_umap_overlay <- renderPlot({
    so <- umap_obj(); req(so)
    p <- core_flowgate_overlay_umap_plot(so, seurat_version = .flowgate_seurat_version())
    print(p)
  })
}
