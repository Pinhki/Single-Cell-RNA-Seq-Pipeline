CELLCHAT_UI_TEXT <- list(
  title = "Analysis: CellChat",
  subtitle = "Run package-native CellChat inference to quantify cell-cell signaling, then inspect interaction circles, matrix strength, pathway summaries, and sender/receiver centrality.",
  status_ready = "Ready. Configure metadata and run Step 1 for CellChat inference; then run Step 2 to render pathway-focused outputs.",
  expected_step1 = "Group composition and inferred global communication matrix from full CellChat inference; verify grouping/assay/species before final pathway-focused rendering.",
  expected_step2 = "Interaction circle network, pathway matrix heatmap, sender/receiver role scores, ligand-receptor bubble map, and pathway contribution ranking.",
  expected_plotly_note = "Complicated outputs use interactive Plotly rendering so you can zoom, pan, and export figures when needed.",
  note_object = "Dataset used for CellChat analysis.",
  note_assay = "Expression matrix used for inference.",
  note_group = "Defines the sender and receiver groups.",
  note_species = "Selects the ligand-receptor database by organism.",
  note_pval = "Filters interactions by significance. **Low** = fewer, more confident interactions. **High** = more, less strict interactions.",
  note_min_cells = "Minimum number of cells required for a group to be included. **Low** = keeps rare groups, but may be less stable. **High** = more robust, but may remove small groups.",
  note_nboot = "Number of resampling iterations used for significance estimation. **Low** = faster, less stable. **High** = slower, more stable.",
  note_raw_use = "Uses raw expression values instead of projected or smoothed values. **Off** = more smoothing, less dropout effect. **On** = more direct signal, but may be noisier.",
  note_population = "Adjusts communication strength by group abundance. **Off** = less affected by group size. **On** = larger groups can contribute stronger total signaling.",
  note_pathway = "Selects the signaling pathway family to display. Specific ligand-receptor pairs for that pathway are listed in the LR outputs below.",
  note_top_lr = "Number of top ligand-receptor pairs shown for the selected pathway. **Low** = cleaner and simpler. **High** = more complete, but more crowded.",
  plot_note_network = "Shows directed communication strengths between groups using the full inferred interaction matrix. Thicker links indicate stronger signaling.",
  plot_note_heatmap = "Rows are sender groups and columns are receiver groups. Warmer colors indicate stronger inferred communication for the selected pathway.",
  plot_note_sender = "Higher bars indicate groups with stronger outgoing signaling (sender role). Compare relative heights across groups.",
  plot_note_receiver = "Higher bars indicate groups with stronger incoming signaling (receiver role). Compare relative heights across groups.",
  plot_note_bubble = "Each bubble is a ligand-receptor pair; bubble size/color encode interaction strength. Use this to inspect top pathway drivers.",
  plot_note_pathway = "Ranks pathways (or pathway-level totals) by inferred contribution score. Larger bars indicate stronger contribution."
)

`%||%` <- function(a, b) if (is.null(a)) b else a
.cellchat_note <- function(txt) {
  x <- as.character(txt %||% "")
  x <- gsub("\\*\\*([^*]+)\\*\\*", "<strong>\\1</strong>", x, perl = TRUE)
  x <- gsub("[\r\n]+", "<br/>", x, perl = TRUE)
  div(class = "control-note cellchat-control-note", htmltools::HTML(x))
}

cellchat_ui <- fluidPage(
  class = "plotting-page cellchat-page advanced-analysis-page",
  tags$head(
    tags$style(HTML("
      .cellchat-page .plot_area_card_style > .row {
        margin-left: 0 !important;
        margin-right: 0 !important;
      }
      .cellchat-page .plot_area_card_style > .row > [class*='col-'] {
        float: none !important;
        width: 100% !important;
        max-width: 100% !important;
        min-width: 0 !important;
        padding-left: 0 !important;
        padding-right: 0 !important;
      }
      .cellchat-page .cellchat-plot-card {
        width: 100% !important;
        max-width: 100% !important;
        min-width: 0 !important;
        box-sizing: border-box !important;
      }
      .cellchat-page .cellchat-plot-card .plotly,
      .cellchat-page .cellchat-plot-card .html-widget,
      .cellchat-page .cellchat-plot-card .shiny-plot-output {
        width: 100% !important;
        max-width: 100% !important;
        min-width: 0 !important;
      }
    "))
  ),
  div(class = "page-header", h2(icon("comments"), " ", CELLCHAT_UI_TEXT$title, " ", tags$span("beta", class = "beta-badge")), p(CELLCHAT_UI_TEXT$subtitle)),
  fluidRow(
    column(
      3,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        uiOutput("cellchat_runtime_ui"),
        tags$hr(),
        tags$strong("Step 1: Inference parameters"),
        selectInput("cellchat_object", "Object", choices = character(0)),
        .cellchat_note(CELLCHAT_UI_TEXT$note_object),
        selectInput("cellchat_assay", "Assay", choices = character(0)),
        .cellchat_note(CELLCHAT_UI_TEXT$note_assay),
        selectInput("cellchat_group_by", "Group column (meta.data)", choices = character(0)),
        .cellchat_note(CELLCHAT_UI_TEXT$note_group),
        selectInput("cellchat_split_by", "Recompute split by (optional)", choices = c("(None)" = ""), selected = ""),
        selectizeInput("cellchat_split_levels", "Split levels (recompute each)", choices = character(0), selected = character(0), multiple = TRUE),
        selectInput("cellchat_view_split", "View split result", choices = c("All cells" = "__all__"), selected = "__all__"),
        selectInput("cellchat_species", "Species", choices = c("Human" = "human", "Mouse" = "mouse", "Zebrafish" = "zebrafish"), selected = "human"),
        .cellchat_note(CELLCHAT_UI_TEXT$note_species),
        sliderInput("cellchat_pval", "Communication p-value threshold", min = 0.001, max = 0.2, value = 0.05, step = 0.001),
        .cellchat_note(CELLCHAT_UI_TEXT$note_pval),
        numericInput("cellchat_min_cells", "Min cells per group", value = 10, min = 1, max = 200, step = 1),
        .cellchat_note(CELLCHAT_UI_TEXT$note_min_cells),
        numericInput("cellchat_nboot", "Bootstrap iterations", value = 100, min = 10, max = 2000, step = 10),
        .cellchat_note(CELLCHAT_UI_TEXT$note_nboot),
        checkboxInput("cellchat_raw_use", "Use raw expression", value = TRUE),
        .cellchat_note(CELLCHAT_UI_TEXT$note_raw_use),
        checkboxInput("cellchat_population_size", "Adjust by population size", value = FALSE),
        .cellchat_note(CELLCHAT_UI_TEXT$note_population),
        actionButton("cellchat_step1_run", "Run Step 1: Infer CellChat", class = "btn btn-outline-primary btn-sm"),
        tags$hr(),
        tags$strong("Step 2: Output selection"),
        selectInput("cellchat_pathway", "Signaling pathway", choices = setNames("", ""), selected = ""),
        .cellchat_note(CELLCHAT_UI_TEXT$note_pathway),
        sliderInput("cellchat_top_lr", "Top LR pairs", min = 10, max = 120, value = 30, step = 5),
        .cellchat_note(CELLCHAT_UI_TEXT$note_top_lr),
        actionButton("cellchat_refresh", "Run Step 2: Render Selected Outputs", class = "btn btn-primary btn-sm"),
        tags$hr(),
        uiOutput("cellchat_status_ui"),
        tags$hr(),
        beta_result_object_controls_ui(
          id_prefix = "cellchat_result_io",
          title = "CellChat Result Object"
        )
      )
    ),
    column(
      9,
        tabsetPanel(
          id = "cellchat_workflow_tabs",
          tabPanel(
            "Step 1 Inference",
            value = "cellchat_step1_tab",
            div(
              class = "plot_area_card_style",
            uiOutput("cellchat_step1_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3 cellchat-plot-card", h4("Group composition"), .cellchat_note(CELLCHAT_UI_TEXT$plot_note_sender), uiOutput("cellchat_step1_group_ui")))
            ),
            fluidRow(
              column(12, div(class = "card p-3 cellchat-plot-card", h4("Global interaction matrix"), .cellchat_note(CELLCHAT_UI_TEXT$plot_note_heatmap), uiOutput("cellchat_step1_heatmap_ui")))
            )
          )
        ),
          tabPanel(
            "Step 2 Outputs",
            value = "cellchat_step2_tab",
            div(
              class = "plot_area_card_style",
            uiOutput("cellchat_step2_empty_ui"),
            fluidRow(
              column(12, div(class = "card p-3 cellchat-plot-card", h4("Interaction circle network"), .cellchat_note(CELLCHAT_UI_TEXT$plot_note_network), uiOutput("cellchat_network_ui")))
            ),
            fluidRow(
              column(12, div(class = "card p-3 cellchat-plot-card", h4("Pathway interaction heatmap"), .cellchat_note(CELLCHAT_UI_TEXT$plot_note_heatmap), uiOutput("cellchat_heatmap_ui")))
            ),
            fluidRow(
              column(12, div(class = "card p-3 cellchat-plot-card", h4("Sender role score"), .cellchat_note(CELLCHAT_UI_TEXT$plot_note_sender), uiOutput("cellchat_sender_ui")))
            ),
            fluidRow(
              column(12, div(class = "card p-3 cellchat-plot-card", h4("Receiver role score"), .cellchat_note(CELLCHAT_UI_TEXT$plot_note_receiver), uiOutput("cellchat_receiver_ui")))
            ),
            fluidRow(
              column(12, div(class = "card p-3 cellchat-plot-card", h4("Ligand-receptor bubble map"), .cellchat_note(CELLCHAT_UI_TEXT$plot_note_bubble), uiOutput("cellchat_pathway_bubble_ui")))
            ),
            fluidRow(
              column(12, div(class = "card p-3 cellchat-plot-card", h4("Pathway contribution"), .cellchat_note(CELLCHAT_UI_TEXT$plot_note_pathway), uiOutput("cellchat_pathway_bar_ui")))
            )
          )
        )
      )
    )
  )
)

cellchat_server <- function(input, output, session, shared_data) {
  .safe_first <- function(x, default = "") if (length(x)) as.character(x[[1]]) else default
  .notif_text <- function(x) {
    x <- as.character(x %||% "")
    x <- gsub("[\r\n]+", " | ", x)
    x <- gsub("\\s*\\|\\s*", " | ", x)
    trimws(x)
  }
  .as_df <- function(x) {
    if (is.null(x)) return(data.frame())
    tryCatch(as.data.frame(x, stringsAsFactors = FALSE), error = function(e) data.frame())
  }
  .with_plotly_tools <- function(p, file_stub = "cellchat_plot") {
    p <- plotly::layout(
      p,
      autosize = TRUE
    )
    plotly::config(
      p,
      displayModeBar = TRUE,
      displaylogo = FALSE,
      scrollZoom = TRUE,
      toImageButtonOptions = list(format = "png", filename = file_stub, scale = 2)
    )
  }
  .goto_workflow_tab <- function(tab_value) {
    tv <- as.character(tab_value %||% "")
    if (!nzchar(tv)) return(invisible(NULL))
    updateTabsetPanel(session, "cellchat_workflow_tabs", selected = tv)
    session$onFlushed(function() {
      updateTabsetPanel(session, "cellchat_workflow_tabs", selected = tv)
    }, once = TRUE)
    invisible(NULL)
  }
  .sync_active_split_view <- function() {
    key <- as.character(input$cellchat_view_split %||% "__all__")
    if (!is.null(rv$step1_dat_by_split) && is.list(rv$step1_dat_by_split) && length(rv$step1_dat_by_split) && key %in% names(rv$step1_dat_by_split)) {
      rv$step1_dat <- rv$step1_dat_by_split[[key]]
    }
    if (!is.null(rv$dat_by_split) && is.list(rv$dat_by_split) && length(rv$dat_by_split) && key %in% names(rv$dat_by_split)) {
      rv$dat <- rv$dat_by_split[[key]]
    }
    invisible(NULL)
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
  .canon_levels <- function(x) {
    xx <- unique(as.character(x %||% character(0)))
    xx <- xx[nzchar(xx)]
    sort(xx, method = "radix")
  }
  .step1_key <- function() {
    split_levels <- .canon_levels(input$cellchat_split_levels %||% character(0))
    paste(
      "obj", as.character(input$cellchat_object %||% ""),
      "assay", as.character(input$cellchat_assay %||% ""),
      "group", as.character(input$cellchat_group_by %||% ""),
      "species", as.character(input$cellchat_species %||% ""),
      "split_col", as.character(input$cellchat_split_by %||% ""),
      "split_levels", paste(split_levels, collapse = "||"),
      "p", sprintf("%.6f", as.numeric(input$cellchat_pval %||% 0.05)),
      "min", as.integer(input$cellchat_min_cells %||% 10L),
      "nboot", as.integer(input$cellchat_nboot %||% 100L),
      "raw", as.integer(isTRUE(input$cellchat_raw_use)),
      "pop", as.integer(isTRUE(input$cellchat_population_size)),
      sep = "|"
    )
  }
  .step2_key <- function(step1_key) {
    paste(
      step1_key,
      "pathway", as.character(input$cellchat_pathway %||% ""),
      "top_lr", as.integer(input$cellchat_top_lr %||% 30L),
      sep = "|"
    )
  }
  .hydrate_from_step1_cache <- function(step1_key) {
    ent <- rv$step1_cache[[step1_key]]
    if (is.null(ent) || !is.list(ent) || is.null(ent$dat_by_split) || !length(ent$dat_by_split)) return(FALSE)
    dat_by_split <- ent$dat_by_split
    view_choices <- if (isTRUE(ent$use_split)) setNames(names(dat_by_split), names(dat_by_split)) else c("All cells" = "__all__")
    cur_view <- as.character(input$cellchat_view_split %||% "")
    view_sel <- if (nzchar(cur_view) && cur_view %in% names(dat_by_split)) cur_view else if (isTRUE(ent$use_split)) .safe_first(names(dat_by_split)) else "__all__"
    updateSelectInput(session, "cellchat_view_split", choices = view_choices, selected = view_sel)
    rv$step1_dat_by_split <- dat_by_split
    rv$step1_dat <- dat_by_split[[view_sel]]
    rv$current_step1_key <- step1_key

    pathways <- cellchat_beta_pathway_choices(rv$step1_dat)
    pw_choices <- c("(Auto: strongest pathway)" = "")
    if (length(pathways)) pw_choices <- c(pw_choices, setNames(pathways, pathways))
    sel_pw <- if (!is.null(rv$step1_dat$selected_pathway) && nzchar(rv$step1_dat$selected_pathway) && rv$step1_dat$selected_pathway %in% pathways) rv$step1_dat$selected_pathway else ""
    updateSelectInput(session, "cellchat_pathway", choices = pw_choices, selected = sel_pw)
    TRUE
  }
  .clamp_h <- function(x, lo = 280L, hi = 980L) max(as.integer(lo), min(as.integer(hi), as.integer(round(x))))
  .matrix_h <- function(m, base = 180L, row_px = 22L, col_px = 8L) {
    if (is.null(m) || !is.matrix(m)) return(320L)
    nr <- nrow(m)
    nc <- ncol(m)
    .clamp_h(base + (nr * row_px) + min(180L, nc * col_px))
  }
  .bar_h <- function(df, base = 180L, item_px = 16L) {
    n <- if (is.null(df) || !nrow(df)) 0L else nrow(df)
    .clamp_h(base + n * item_px)
  }
  .network_h <- function(groups) {
    n <- length(groups %||% character(0))
    .clamp_h(260L + n * 18L, lo = 360L)
  }
  .bubble_h <- function(df) {
    if (is.null(df) || !nrow(df)) return(320L)
    nr <- length(unique(as.character(df$receiver)))
    .clamp_h(210L + nr * 34L)
  }
  .as_plot_matrix <- function(m, fallback_groups = character(0)) {
    if (is.null(m)) return(NULL)
    mm <- tryCatch(as.matrix(m), error = function(e) NULL)
    if (is.null(mm)) return(NULL)
    storage.mode(mm) <- "numeric"
    mm[!is.finite(mm)] <- NA_real_
    rn <- rownames(mm)
    cn <- colnames(mm)
    if (is.null(rn) || !length(rn)) rn <- as.character(fallback_groups %||% seq_len(nrow(mm)))
    if (is.null(cn) || !length(cn)) cn <- as.character(fallback_groups %||% seq_len(ncol(mm)))
    rownames(mm) <- as.character(rn)
    colnames(mm) <- as.character(cn)
    mm
  }
  .heatmap_plot <- function(m, file_stub = "cellchat_heatmap", colorscale = "YlOrRd") {
    mm <- .as_plot_matrix(m)
    validate(need(!is.null(mm) && nrow(mm) > 0 && ncol(mm) > 0, "No pathway matrix available."))
    finite_vals <- mm[is.finite(mm)]
    validate(need(length(finite_vals) > 0, "Matrix has no finite values to render."))
    if (all(abs(finite_vals) < .Machine$double.eps^0.5)) {
      validate(need(FALSE, "Selected pathway has near-zero communication matrix. Try another pathway or Auto."))
    }
    .with_plotly_tools(
      plotly::plot_ly(
        x = colnames(mm),
        y = rownames(mm),
        z = mm,
        type = "heatmap",
        colorscale = colorscale,
        hoverongaps = FALSE
      ),
      file_stub = file_stub
    )
  }

  rv <- reactiveValues(
    status = CELLCHAT_UI_TEXT$status_ready,
    step1_dat = NULL,
    dat = NULL,
    step1_dat_by_split = NULL,
    dat_by_split = NULL,
    step1_cache = list(),
    step2_cache = list(),
    current_step1_key = "",
    last_error = ""
  )
  beta_result_object_controls_server(
    input = input,
    output = output,
    session = session,
    shared_data = shared_data,
    id_prefix = "cellchat_result_io",
    get_current_object = function() rv$dat %||% rv$step1_dat,
    set_current_object = function(obj) {
      rv$dat <- obj
      rv$status <- "Imported CellChat result object is now active."
      rv$last_error <- ""
      .goto_workflow_tab("cellchat_step2_tab")
    },
    write_metadata_to_active_object = function(res_obj, sobj) {
      if (is.null(res_obj) || !is.list(res_obj)) stop("CellChat result is missing.")
      gcol <- as.character(res_obj$group_col %||% "")
      if (!nzchar(gcol) || !(gcol %in% colnames(sobj@meta.data))) {
        stop("CellChat group column is not available in the active Seurat object.")
      }
      grp <- as.character(sobj@meta.data[[gcol]])
      grp[is.na(grp) | !nzchar(grp)] <- "Unknown"
      added <- character(0)

      score_from_df <- function(df) {
        dd <- .as_df(df)
        if (!nrow(dd) || !all(c("group", "score") %in% colnames(dd))) return(setNames(numeric(0), character(0)))
        out <- as.numeric(dd$score)
        names(out) <- as.character(dd$group)
        out
      }
      sender_map <- score_from_df(res_obj$sender_score)
      receiver_map <- score_from_df(res_obj$receiver_score)
      suffix <- if (nzchar(res_obj$selected_pathway %||% "")) make.names(res_obj$selected_pathway) else "all"

      if (length(sender_map)) {
        cn <- paste0("cellchat_sender_score_", suffix)
        vv <- as.numeric(sender_map[grp]); vv[is.na(vv)] <- 0
        sobj[[cn]] <- vv
        added <- c(added, cn)
      }
      if (length(receiver_map)) {
        cn <- paste0("cellchat_receiver_score_", suffix)
        vv <- as.numeric(receiver_map[grp]); vv[is.na(vv)] <- 0
        sobj[[cn]] <- vv
        added <- c(added, cn)
      }
      pm <- res_obj$pathway_matrix %||% NULL
      if (is.matrix(pm) && nrow(pm) && ncol(pm)) {
        row_out <- rowSums(pm, na.rm = TRUE); names(row_out) <- rownames(pm)
        col_in <- colSums(pm, na.rm = TRUE); names(col_in) <- colnames(pm)
        cn_out <- paste0("cellchat_pathway_out_", suffix)
        cn_in <- paste0("cellchat_pathway_in_", suffix)
        v_out <- as.numeric(row_out[grp]); v_out[is.na(v_out)] <- 0
        v_in <- as.numeric(col_in[grp]); v_in[is.na(v_in)] <- 0
        sobj[[cn_out]] <- v_out
        sobj[[cn_in]] <- v_in
        added <- c(added, cn_out, cn_in)
      }
      if (!length(added)) stop("No writable CellChat metadata fields were found for the active object.")
      list(obj = sobj, added_cols = unique(added))
    },
    default_workspace_name = "cellchat_result"
  )
  output$cellchat_runtime_ui <- renderUI({
    has_cellchat <- isTRUE(requireNamespace("CellChat", quietly = TRUE))
    has_presto <- isTRUE(requireNamespace("presto", quietly = TRUE))
    if (!has_cellchat) {
      return(div(
        class = "alert alert-danger p-2 mb-0 small",
        strong("Runtime preflight"), tags$br(),
        "CellChat package is not available in the active environment."
      ))
    }
    if (has_presto) {
      return(div(
        class = "alert alert-success p-2 mb-0 small",
        strong("Runtime preflight"), tags$br(),
        "CellChat ready; presto detected (fast Wilcoxon mode available)."
      ))
    }
    div(
      class = "alert alert-warning p-2 mb-0 small",
      strong("Runtime preflight"), tags$br(),
      "CellChat ready; presto not installed. Step 1 will use standard Wilcoxon (slower but supported)."
    )
  })
  output$cellchat_status_ui <- renderUI({
    if (nzchar(rv$last_error %||% "")) {
      div(class = "alert alert-danger p-2 mb-0", style = "white-space: pre-wrap;", rv$last_error)
    } else {
      div(class = "small text-muted", rv$status)
    }
  })

  observe({
    nms <- cellchat_beta_object_names(shared_data)
    cur <- isolate(input$cellchat_object %||% "")
    active_nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
    sel <- if (nzchar(cur) && cur %in% nms) cur else if (nzchar(active_nm) && active_nm %in% nms) active_nm else .safe_first(nms)
    updateSelectInput(session, "cellchat_object", choices = nms, selected = sel)
  })

  observeEvent(
    list(input$cellchat_object, shared_data$active_object_name, shared_data$all_seurat_objects, shared_data$filtered_objects),
    {
      overlay_show("CellChat: loading object metadata...")
      on.exit(overlay_hide(), add = TRUE)
      tryCatch({
        obj <- cellchat_beta_get_object(shared_data, input$cellchat_object)
        if (is.null(obj) || !inherits(obj, "Seurat")) {
          updateSelectInput(session, "cellchat_group_by", choices = character(0), selected = "")
          updateSelectInput(session, "cellchat_assay", choices = character(0), selected = "")
          return(invisible(NULL))
        }

        cols <- cellchat_beta_meta_cols(obj)
        cur_col <- isolate(input$cellchat_group_by %||% "")
        def_col <- if (nzchar(cur_col) && cur_col %in% cols) cur_col else cellchat_beta_default_group(cols)
        updateSelectInput(session, "cellchat_group_by", choices = cols, selected = def_col)
        split_cur <- isolate(input$cellchat_split_by %||% "")
        split_choices <- c("(None)" = "", setNames(cols, cols))
        split_sel <- if (nzchar(split_cur) && split_cur %in% cols) split_cur else ""
        updateSelectInput(session, "cellchat_split_by", choices = split_choices, selected = split_sel)
        split_levels <- .split_levels_from_obj(obj, split_sel)
        split_level_cur <- isolate(input$cellchat_split_levels %||% character(0))
        split_level_sel <- intersect(as.character(split_level_cur), split_levels)
        if (!length(split_level_sel) && length(split_levels) >= 2L) split_level_sel <- split_levels
        updateSelectizeInput(session, "cellchat_split_levels", choices = split_levels, selected = split_level_sel, server = TRUE)

        assays <- cellchat_beta_assays(obj)
        cur_assay <- isolate(input$cellchat_assay %||% "")
        def_assay <- if (nzchar(cur_assay) && cur_assay %in% assays) cur_assay else cellchat_beta_default_assay(obj)
        updateSelectInput(session, "cellchat_assay", choices = assays, selected = def_assay)
      }, error = function(e) {
        warning(sprintf("[cellchat][selectors] %s", conditionMessage(e)), call. = FALSE, immediate. = TRUE)
        updateSelectInput(session, "cellchat_group_by", choices = character(0), selected = "")
        updateSelectInput(session, "cellchat_split_by", choices = c("(None)" = ""), selected = "")
        updateSelectizeInput(session, "cellchat_split_levels", choices = character(0), selected = character(0), server = TRUE)
        updateSelectInput(session, "cellchat_assay", choices = character(0), selected = "")
      })
    },
    ignoreInit = FALSE
  )

  observeEvent(input$cellchat_split_by, {
    obj <- cellchat_beta_get_object(shared_data, input$cellchat_object)
    split_levels <- .split_levels_from_obj(obj, input$cellchat_split_by %||% "")
    split_level_cur <- isolate(input$cellchat_split_levels %||% character(0))
    split_level_sel <- intersect(as.character(split_level_cur), split_levels)
    if (!length(split_level_sel) && length(split_levels) >= 2L) split_level_sel <- split_levels
    updateSelectizeInput(session, "cellchat_split_levels", choices = split_levels, selected = split_level_sel, server = TRUE)
  }, ignoreInit = TRUE)

  observeEvent(input$cellchat_view_split, {
    .sync_active_split_view()
  }, ignoreInit = TRUE)

  observeEvent(
    list(
      input$cellchat_object, input$cellchat_assay, input$cellchat_group_by, input$cellchat_species,
      input$cellchat_split_by, input$cellchat_split_levels, input$cellchat_pval, input$cellchat_min_cells,
      input$cellchat_nboot, input$cellchat_raw_use, input$cellchat_population_size
    ),
    {
      key <- .step1_key()
      if (.hydrate_from_step1_cache(key)) {
        step2_key <- .step2_key(key)
        dat2 <- rv$step2_cache[[step2_key]]
        if (!is.null(dat2) && is.list(dat2) && length(dat2)) {
          rv$dat_by_split <- dat2
          cur_key <- as.character(input$cellchat_view_split %||% "")
          if (!nzchar(cur_key) || !(cur_key %in% names(dat2))) cur_key <- .safe_first(names(dat2))
          rv$dat <- dat2[[cur_key]]
          rv$status <- "Loaded cached CellChat Step 1/Step 2 results for current parameters."
        } else {
          rv$dat <- NULL
          rv$dat_by_split <- NULL
          rv$status <- "Loaded cached CellChat Step 1 results. Run Step 2 if pathway/top-LR settings changed."
        }
        rv$last_error <- ""
      }
    },
    ignoreInit = TRUE
  )

  observeEvent(input$cellchat_step1_run, {
    overlay_show("CellChat Step 1: running package-native inference...")
    on.exit(overlay_hide(), add = TRUE)
    withProgress(message = "CellChat Step 1", value = 0, {
      tryCatch({
        setProgress(value = 0.08, detail = "Validating input")
        obj <- cellchat_beta_get_object(shared_data, input$cellchat_object)
        validate(need(!is.null(obj) && inherits(obj, "Seurat"), "Selected object is unavailable."))
        validate(need(input$cellchat_group_by %in% colnames(obj@meta.data), "Choose a valid metadata grouping column."))
        step1_key <- .step1_key()
        if (.hydrate_from_step1_cache(step1_key)) {
          rv$dat <- NULL
          rv$dat_by_split <- NULL
          rv$status <- "Step 1 loaded from cache for current parameters."
          rv$last_error <- ""
          setProgress(value = 1, detail = "Step 1 cache hit")
          .goto_workflow_tab("cellchat_step1_tab")
          return(invisible(NULL))
        }

        setProgress(value = 0.25, detail = "Preparing CellChat inputs")
        split_col <- as.character(input$cellchat_split_by %||% "")
        split_levels <- as.character(input$cellchat_split_levels %||% character(0))
        use_split <- nzchar(split_col) && length(split_levels) >= 2L
        run_levels <- if (use_split) split_levels else "__all__"
        dat_by_split <- list()

        for (ii in seq_along(run_levels)) {
          lv <- run_levels[[ii]]
          run_obj <- if (identical(lv, "__all__")) obj else .subset_obj_by_split(obj, split_col = split_col, split_level = lv)
          setProgress(value = min(0.8, 0.2 + 0.6 * (ii / max(1L, length(run_levels)))), detail = if (identical(lv, "__all__")) "Running CellChat (all cells)" else sprintf("Running CellChat split: %s=%s", split_col, lv))
          dat_by_split[[lv]] <- cellchat_beta_run(
            sobj = run_obj,
            group_col = input$cellchat_group_by,
            species = input$cellchat_species %||% "human",
            assay = input$cellchat_assay %||% NULL,
            top_lr = 120L,
            pval_thresh = as.numeric(input$cellchat_pval %||% 0.05),
            min_cells = as.integer(input$cellchat_min_cells %||% 10L),
            nboot = as.integer(input$cellchat_nboot %||% 100L),
            raw_use = isTRUE(input$cellchat_raw_use),
            population_size = isTRUE(input$cellchat_population_size),
            pathway_label = ""
          )
        }
        setProgress(value = 0.82, detail = "Collecting inferred pathways")

        rv$step1_dat_by_split <- dat_by_split
        view_choices <- if (use_split) setNames(names(dat_by_split), names(dat_by_split)) else c("All cells" = "__all__")
        view_sel <- if (use_split) .safe_first(names(dat_by_split)) else "__all__"
        updateSelectInput(session, "cellchat_view_split", choices = view_choices, selected = view_sel)
        rv$step1_dat <- if (use_split) dat_by_split[[view_sel]] else dat_by_split[["__all__"]]
        rv$current_step1_key <- step1_key
        rv$dat <- NULL
        rv$dat_by_split <- NULL
        rv$step1_cache[[step1_key]] <- list(dat_by_split = dat_by_split, use_split = use_split)

        pathways <- cellchat_beta_pathway_choices(rv$step1_dat)
        pw_choices <- c("(Auto: strongest pathway)" = "")
        if (length(pathways)) pw_choices <- c(pw_choices, setNames(pathways, pathways))
        sel_pw <- if (!is.null(rv$step1_dat$selected_pathway) && nzchar(rv$step1_dat$selected_pathway) && rv$step1_dat$selected_pathway %in% pathways) rv$step1_dat$selected_pathway else ""
        updateSelectInput(session, "cellchat_pathway", choices = pw_choices, selected = sel_pw)

        rv$status <- sprintf(
          "Step 1 complete: object=%s, assay=%s, group=%s, pathways=%s, test=%s",
          input$cellchat_object,
          rv$step1_dat$assay %||% (input$cellchat_assay %||% ""),
          input$cellchat_group_by,
          length(pathways),
          rv$step1_dat$wilcox_mode %||% "auto"
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 1 complete")
        .goto_workflow_tab("cellchat_step1_tab")
      }, error = function(e) {
        rv$status <- paste("Step 1 failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[cellchat][step1] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(.notif_text(rv$status), type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  observeEvent(input$cellchat_refresh, {
    .goto_workflow_tab("cellchat_step2_tab")
    overlay_show("CellChat Step 2: rendering selected pathway outputs...")
    on.exit(overlay_hide(), add = TRUE)
    withProgress(message = "CellChat Step 2", value = 0, {
      tryCatch({
        setProgress(value = 0.1, detail = "Validating Step 1 outputs")
        validate(need(!is.null(rv$step1_dat), "Run Step 1 first to infer CellChat communications."))

        setProgress(value = 0.35, detail = "Selecting pathway and LR filters")
        validate(need(!is.null(rv$step1_dat_by_split) && length(rv$step1_dat_by_split), "Run Step 1 first to infer CellChat communications."))
        step1_key <- as.character(rv$current_step1_key %||% "")
        if (!nzchar(step1_key)) step1_key <- .step1_key()
        step2_key <- .step2_key(step1_key)
        cache2 <- rv$step2_cache[[step2_key]]
        if (!is.null(cache2) && is.list(cache2) && length(cache2)) {
          rv$dat_by_split <- cache2
          cur_key <- as.character(input$cellchat_view_split %||% "")
          if (!nzchar(cur_key) || !(cur_key %in% names(cache2))) cur_key <- .safe_first(names(cache2))
          rv$dat <- cache2[[cur_key]]
          rv$status <- sprintf(
            "Step 2 loaded from cache: pathway=%s, top LR=%s",
            if (nzchar(rv$dat$selected_pathway %||% "")) rv$dat$selected_pathway else "auto",
            as.integer(input$cellchat_top_lr %||% 30L)
          )
          rv$last_error <- ""
          setProgress(value = 1, detail = "Step 2 cache hit")
          .goto_workflow_tab("cellchat_step2_tab")
          return(invisible(NULL))
        }
        dat_by_split <- lapply(rv$step1_dat_by_split, function(x) {
          cellchat_beta_select_outputs(
            dat = x,
            pathway_label = input$cellchat_pathway %||% "",
            top_lr = as.integer(input$cellchat_top_lr %||% 30L)
          )
        })
        setProgress(value = 0.85, detail = "Preparing plot-ready outputs")
        rv$dat_by_split <- dat_by_split
        rv$step2_cache[[step2_key]] <- dat_by_split
        cur_key <- as.character(input$cellchat_view_split %||% "")
        if (!nzchar(cur_key) || !(cur_key %in% names(dat_by_split))) cur_key <- .safe_first(names(dat_by_split))
        rv$dat <- dat_by_split[[cur_key]]

        rv$status <- sprintf(
          "Step 2 complete: pathway=%s, top LR=%s",
          if (nzchar(rv$dat$selected_pathway %||% "")) rv$dat$selected_pathway else "auto",
          as.integer(input$cellchat_top_lr %||% 30L)
        )
        rv$last_error <- ""
        setProgress(value = 1, detail = "Step 2 complete")
        .goto_workflow_tab("cellchat_step2_tab")
      }, error = function(e) {
        rv$status <- paste("Step 2 failed:", conditionMessage(e))
        rv$last_error <- rv$status
        warning(sprintf("[cellchat][step2] %s", rv$status), call. = FALSE, immediate. = TRUE)
        showNotification(.notif_text(rv$status), type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  .step1 <- reactive({ req(!is.null(rv$step1_dat)); rv$step1_dat })
  .dat <- reactive({ req(!is.null(rv$dat)); rv$dat })

  output$cellchat_step1_empty_ui <- renderUI({
    if (!is.null(rv$step1_dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No CellChat Step 1 plot yet. Run 'Run Step 1: Infer CellChat' to populate these plots.",
      height_px = 92L
    )
  })
  output$cellchat_step2_empty_ui <- renderUI({
    if (!is.null(rv$dat)) return(NULL)
    plot_card_not_ready_ui(
      note = "No CellChat Step 2 plot yet. Run Step 1 first, then 'Run Step 2: Render Selected Outputs'.",
      height_px = 92L
    )
  })

  output$cellchat_step1_group_ui <- renderUI({
    if (is.null(rv$step1_dat)) {
      return(plot_card_not_ready_ui(
        note = "Group composition will appear after Step 1 inference.",
        height_px = 220L
      ))
    }
    d <- rv$step1_dat
    sc <- .as_df(d$sender_score %||% data.frame())
    h <- .bar_h(sc, base = 170L, item_px = 14L)
    plotlyOutput("cellchat_step1_group_plot", height = paste0(h, "px"))
  })
  output$cellchat_step1_heatmap_ui <- renderUI({
    if (is.null(rv$step1_dat)) {
      return(plot_card_not_ready_ui(
        note = "Global interaction matrix will appear after Step 1 inference.",
        height_px = 220L
      ))
    }
    d <- rv$step1_dat
    m <- d$interaction %||% NULL
    h <- .matrix_h(m, base = 150L, row_px = 22L, col_px = 8L)
    plotlyOutput("cellchat_step1_heatmap_plot", height = paste0(h, "px"))
  })
  output$cellchat_network_ui <- renderUI({
    if (is.null(rv$dat)) {
      return(plot_card_not_ready_ui(
        note = "Interaction circle network will appear after Step 2 rendering.",
        height_px = 230L
      ))
    }
    d <- rv$dat
    h <- .network_h(d$groups %||% character(0))
    plotOutput("cellchat_network_plot", height = paste0(h, "px"))
  })
  output$cellchat_heatmap_ui <- renderUI({
    if (is.null(rv$dat)) {
      return(plot_card_not_ready_ui(
        note = "Pathway heatmap will appear after Step 2 rendering.",
        height_px = 220L
      ))
    }
    d <- rv$dat
    m <- d$pathway_matrix %||% d$interaction %||% NULL
    h <- .matrix_h(m, base = 160L, row_px = 24L, col_px = 10L)
    plotlyOutput("cellchat_heatmap_plot", height = paste0(h, "px"))
  })
  output$cellchat_sender_ui <- renderUI({
    if (is.null(rv$dat)) {
      return(plot_card_not_ready_ui(
        note = "Sender score plot will appear after Step 2 rendering.",
        height_px = 220L
      ))
    }
    d <- rv$dat
    sc <- .as_df(d$sender_score %||% data.frame())
    h <- .bar_h(sc, base = 170L, item_px = 14L)
    plotlyOutput("cellchat_sender_plot", height = paste0(h, "px"))
  })
  output$cellchat_receiver_ui <- renderUI({
    if (is.null(rv$dat)) {
      return(plot_card_not_ready_ui(
        note = "Receiver score plot will appear after Step 2 rendering.",
        height_px = 220L
      ))
    }
    d <- rv$dat
    sc <- .as_df(d$receiver_score %||% data.frame())
    h <- .bar_h(sc, base = 170L, item_px = 14L)
    plotlyOutput("cellchat_receiver_plot", height = paste0(h, "px"))
  })
  output$cellchat_pathway_bubble_ui <- renderUI({
    if (is.null(rv$dat)) {
      return(plot_card_not_ready_ui(
        note = "Ligand-receptor bubble map will appear after Step 2 rendering.",
        height_px = 240L
      ))
    }
    d <- rv$dat
    p <- .as_df(d$pair_df %||% data.frame())
    h <- .bubble_h(p)
    plotlyOutput("cellchat_pathway_bubble", height = paste0(h, "px"))
  })
  output$cellchat_pathway_bar_ui <- renderUI({
    if (is.null(rv$dat)) {
      return(plot_card_not_ready_ui(
        note = "Pathway contribution plot will appear after Step 2 rendering.",
        height_px = 220L
      ))
    }
    d <- rv$dat
    pw <- .as_df(d$pathway_df %||% data.frame())
    h <- .bar_h(pw, base = 170L, item_px = 14L)
    plotlyOutput("cellchat_pathway_bar", height = paste0(h, "px"))
  })

  output$cellchat_step1_group_plot <- renderPlotly({
    d <- .step1()
    sc <- .as_df(d$sender_score)
    validate(need(nrow(sc) > 0, "No sender score available from Step 1."))
    .with_plotly_tools(
      plotly::plot_ly(sc, x = ~group, y = ~score, type = "bar"),
      file_stub = "cellchat_step1_group_composition"
    )
  })

  output$cellchat_step1_heatmap_plot <- renderPlotly({
    d <- .step1()
    m <- d$interaction
    .heatmap_plot(m, file_stub = "cellchat_step1_global_interaction_matrix", colorscale = "Blues")
  })

  output$cellchat_network_plot <- renderPlot({
    d <- .dat()
    m <- .as_plot_matrix(d$pathway_matrix %||% d$interaction, fallback_groups = d$groups %||% character(0))
    if (is.null(m) || !nrow(m) || !ncol(m)) {
      m <- .as_plot_matrix(d$interaction, fallback_groups = d$groups %||% character(0))
    }
    validate(need(!is.null(m) && nrow(m) > 0 && ncol(m) > 0, "No interaction matrix available for interaction network."))
    validate(need(isTRUE(requireNamespace("CellChat", quietly = TRUE)), "CellChat package is required for official circle plot."))
    validate(need(all(is.finite(m)), "Interaction matrix contains non-finite values; rerun Step 2 with a different pathway or Auto."))
    validate(need(any(m > 0), "No non-zero interactions for current pathway. Try Auto or a different pathway."))

    m_plot <- m
    v_w <- rowSums(m_plot, na.rm = TRUE) + colSums(m_plot, na.rm = TRUE)
    if (!any(v_w > 0)) v_w <- rep(1, nrow(m_plot))
    title_nm <- if (nzchar(d$selected_pathway %||% "")) paste0("Pathway: ", d$selected_pathway) else "CellChat interaction circle"
    graphics::par(mar = c(1, 1, 2, 1), xpd = NA)
    CellChat::netVisual_circle(
      m_plot,
      vertex.weight = as.numeric(v_w),
      weight.scale = TRUE,
      label.edge = FALSE,
      title.name = title_nm
    )
  })

  output$cellchat_heatmap_plot <- renderPlotly({
    d <- .dat()
    m <- d$pathway_matrix %||% d$interaction
    .heatmap_plot(m, file_stub = "cellchat_step2_pathway_interaction_heatmap", colorscale = "YlOrRd")
  })

  output$cellchat_sender_plot <- renderPlotly({
    d <- .dat()
    sc <- .as_df(d$sender_score)
    validate(need(nrow(sc) > 0, "No sender role score available."))
    .with_plotly_tools(
      plotly::plot_ly(sc, x = ~group, y = ~score, type = "bar"),
      file_stub = "cellchat_step2_sender_role_score"
    )
  })

  output$cellchat_receiver_plot <- renderPlotly({
    d <- .dat()
    sc <- .as_df(d$receiver_score)
    validate(need(nrow(sc) > 0, "No receiver role score available."))
    .with_plotly_tools(
      plotly::plot_ly(sc, x = ~group, y = ~score, type = "bar"),
      file_stub = "cellchat_step2_receiver_role_score"
    )
  })

  output$cellchat_pathway_bubble <- renderPlotly({
    d <- .dat()
    p <- .as_df(d$pair_df)
    validate(need(nrow(p) > 0, "No ligand-receptor pairs available for bubble plot."))
    p <- utils::head(p[order(p$score, decreasing = TRUE), , drop = FALSE], 80)

    lbl <- if ("interaction_name" %in% colnames(p)) p$interaction_name else paste0(p$sender, "->", p$receiver)
    .with_plotly_tools(
      plotly::plot_ly(
        p,
        x = ~sender,
        y = ~receiver,
        type = "scatter",
        mode = "markers",
        size = ~score,
        color = ~score,
        text = ~paste0(lbl, "<br>Score: ", signif(score, 3)),
        hoverinfo = "text",
        colors = c("#440154", "#3b528b", "#21918c", "#5ec962", "#fde725")
      ),
      file_stub = "cellchat_step2_ligand_receptor_bubble"
    )
  })

  output$cellchat_pathway_bar <- renderPlotly({
    d <- .dat()
    pw <- .as_df(d$pathway_df)
    validate(need(nrow(pw) > 0, "No pathway contribution table available."))
    pw <- utils::head(pw[order(pw$score, decreasing = TRUE), , drop = FALSE], 20)
    .with_plotly_tools(
      plotly::plot_ly(pw, x = ~name, y = ~score, type = "bar"),
      file_stub = "cellchat_step2_pathway_contribution"
    )
  })
}
