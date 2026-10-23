# R/page_figure_pseudobulk_volcano.R
FIGURE_PBV_UI_TEXT <- list(
  t_btn_apply_preview = "Apply Preview",
  t_btn_copy_code = "Copy Code",
  t_btn_download_pdf = "Download PDF",
  t_btn_shared_plot_settings = "Shared Plot Settings",
  t_choice_mode_custom = "Custom comparison",
  t_choice_mode_overview = "Overview (per-cluster)",
  t_choice_shape_ellipse = "Ellipse",
  t_choice_shape_outline = "Outline",
  t_choice_shape_rect = "Rectangle",
  t_label_1_select_dataset = "1. Select Dataset:",
  t_label_2_data_mode = "2. Cached source:",
  t_label_3_overview_cluster = "3. Overview cluster:",
  t_label_alpha = "Point alpha:",
  t_label_color_down = "Downregulated color:",
  t_label_color_nonsig = "Non-significant color:",
  t_label_color_up = "Upregulated color:",
  t_label_facet_columns = "Facet columns (overview all):",
  t_label_fc_cutoff = "|logFC| cutoff:",
  t_label_figure_height = "Height (in):",
  t_label_figure_width = "Width (in):",
  t_label_fdr_threshold = "FDR threshold:",
  t_label_gene_column = "Gene label column:",
  t_label_label_top_n = "Label top genes:",
  t_label_magnify_box_color = "Magnify border color:",
  t_label_magnify_enable = "Enable ggmagnify inset",
  t_label_magnify_linewidth = "Magnify border width:",
  t_label_magnify_proj = "Projection line mode:",
  t_label_magnify_shape = "Magnify shape:",
  t_label_plot_title = "Plot title:",
  t_label_show_labels = "Show gene labels",
  t_label_threshold_line_color = "Threshold line color:",
  t_text_cache_only_note = "Cache-only page: results are read from object-stored pseudobulk payloads and never recomputed here.",
  t_text_code_note_1 = "The generated script includes a workspace import line: bundle <- readRDS('PATH/TO/workspace_bundle.rds').",
  t_text_code_note_2 = "Each configurable parameter line includes an inline comment so users know what to edit.",
  t_text_code_note_3 = "This script is pipeline-independent (ggplot2 + ggmagnify + cached DEG table).",
  t_text_code_note_4 = "Add custom layers/theme changes under '# 5) Add extra ggplot layers below'.",
  t_text_ggmagnify_required = "This hidden page requires package 'ggmagnify'. Enable TEST_VERSION and rerun run.R bootstrap.",
  t_text_intro = "Render cached pseudobulk volcano views in Figure Studio with full styling controls and required ggmagnify inset support.",
  t_text_no_cache_custom = "No cached custom pseudobulk result found. Run custom pseudobulk in Main Analysis first.",
  t_text_no_cache_overview = "No cached pseudobulk overview found. Run pseudobulk overview in Main Analysis first.",
  t_text_no_dataset = "No dataset available in shared_data$all_seurat_objects.",
  t_text_proj_corresponding = "corresponding",
  t_text_proj_facing = "facing",
  t_text_proj_single = "single",
  t_text_repelling_note = "ggrepel is used when available; otherwise plain labels are drawn.",
  t_title_aesthetics = "Aesthetics",
  t_title_custom_r_code = "Customize in R",
  t_title_download_plot = "Download Plot",
  t_title_hidden_page = "Pseudobulk Volcano",
  t_title_magnify = "Magnify Inset",
  t_title_plot_controls = "Plot Controls",
  t_title_plot_preview = "Plot Preview",
  t_title_pseudobulk_volcano = "Pseudobulk Volcano Studio",
  t_title_shared_plot_style = "Shared Plot Style"
)

library(ggplot2)

figure_pseudobulk_volcano_ui <- fluidPage(
  tags$head(
    figure_busy_spinner_assets,
    if (is.function(get0("wl_pdf_modal_assets", mode = "function", ifnotfound = NULL))) wl_pdf_modal_assets() else NULL
  ),
  div(
    class = "page-header",
    h2(icon("chart-line"), " ", wl_alpha_label(FIGURE_PBV_UI_TEXT$t_title_hidden_page, suffix = "hidden")),
    p(FIGURE_PBV_UI_TEXT$t_text_intro)
  ),
  hr(),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      class = "plotting-left-panel",
      style = "padding-top:0;",
      div(
        class = "wl-side",
        h4(FIGURE_PBV_UI_TEXT$t_title_plot_controls),
        selectInput("figure_pbv_dataset_select", FIGURE_PBV_UI_TEXT$t_label_1_select_dataset, choices = NULL),
        radioButtons(
          "figure_pbv_mode",
          FIGURE_PBV_UI_TEXT$t_label_2_data_mode,
          choices = stats::setNames(
            c("overview", "custom"),
            c(FIGURE_PBV_UI_TEXT$t_choice_mode_overview, FIGURE_PBV_UI_TEXT$t_choice_mode_custom)
          ),
          selected = "overview",
          inline = TRUE
        ),
        uiOutput("figure_pbv_overview_cluster_ui"),
        p(class = "text-muted", FIGURE_PBV_UI_TEXT$t_text_cache_only_note),

        hr(),
        h5(FIGURE_PBV_UI_TEXT$t_title_shared_plot_style),
        actionButton("figure_pbv_open_shared_settings", FIGURE_PBV_UI_TEXT$t_btn_shared_plot_settings, class = "btn btn-default"),

        hr(),
        h5(FIGURE_PBV_UI_TEXT$t_title_aesthetics),
        textInput("figure_pbv_plot_title", FIGURE_PBV_UI_TEXT$t_label_plot_title, value = "Pseudobulk Volcano"),
        sliderInput("figure_pbv_fdr_threshold", FIGURE_PBV_UI_TEXT$t_label_fdr_threshold, min = 0.0001, max = 0.25, value = 0.05, step = 0.0005),
        sliderInput("figure_pbv_fc_cutoff", FIGURE_PBV_UI_TEXT$t_label_fc_cutoff, min = 0, max = 3, value = 0.25, step = 0.05),
        sliderInput("figure_pbv_alpha", FIGURE_PBV_UI_TEXT$t_label_alpha, min = 0.1, max = 1, value = 0.75, step = 0.05),
        numericInput("figure_pbv_facet_cols", FIGURE_PBV_UI_TEXT$t_label_facet_columns, value = 4, min = 1, step = 1),
        textInput("figure_pbv_color_up", FIGURE_PBV_UI_TEXT$t_label_color_up, value = "#B91C1C"),
        textInput("figure_pbv_color_down", FIGURE_PBV_UI_TEXT$t_label_color_down, value = "#1D4ED8"),
        textInput("figure_pbv_color_nonsig", FIGURE_PBV_UI_TEXT$t_label_color_nonsig, value = "#9CA3AF"),
        textInput("figure_pbv_threshold_line_color", FIGURE_PBV_UI_TEXT$t_label_threshold_line_color, value = "#6B7280"),

        hr(),
        checkboxInput("figure_pbv_show_labels", FIGURE_PBV_UI_TEXT$t_label_show_labels, value = FALSE),
        uiOutput("figure_pbv_gene_column_ui"),
        sliderInput("figure_pbv_label_top_n", FIGURE_PBV_UI_TEXT$t_label_label_top_n, min = 1, max = 80, value = 12, step = 1),
        p(class = "text-muted", FIGURE_PBV_UI_TEXT$t_text_repelling_note),

        hr(),
        h5(FIGURE_PBV_UI_TEXT$t_title_magnify),
        checkboxInput("figure_pbv_use_magnify", FIGURE_PBV_UI_TEXT$t_label_magnify_enable, value = FALSE),
        selectInput(
          "figure_pbv_magnify_shape",
          FIGURE_PBV_UI_TEXT$t_label_magnify_shape,
          choices = stats::setNames(
            c("rect", "ellipse", "outline"),
            c(FIGURE_PBV_UI_TEXT$t_choice_shape_rect, FIGURE_PBV_UI_TEXT$t_choice_shape_ellipse, FIGURE_PBV_UI_TEXT$t_choice_shape_outline)
          ),
          selected = "rect"
        ),
        selectInput(
          "figure_pbv_magnify_proj",
          FIGURE_PBV_UI_TEXT$t_label_magnify_proj,
          choices = stats::setNames(
            c("facing", "corresponding", "single"),
            c(FIGURE_PBV_UI_TEXT$t_text_proj_facing, FIGURE_PBV_UI_TEXT$t_text_proj_corresponding, FIGURE_PBV_UI_TEXT$t_text_proj_single)
          ),
          selected = "facing"
        ),
        textInput("figure_pbv_magnify_color", FIGURE_PBV_UI_TEXT$t_label_magnify_box_color, value = "#111827"),
        sliderInput("figure_pbv_magnify_lwd", FIGURE_PBV_UI_TEXT$t_label_magnify_linewidth, min = 0.1, max = 2.5, value = 0.6, step = 0.1),
        fluidRow(
          column(6, numericInput("figure_pbv_from_xmin", "from xmin", value = -2.0)),
          column(6, numericInput("figure_pbv_from_xmax", "from xmax", value = -0.5))
        ),
        fluidRow(
          column(6, numericInput("figure_pbv_from_ymin", "from ymin", value = 2.0)),
          column(6, numericInput("figure_pbv_from_ymax", "from ymax", value = 8.0))
        ),
        fluidRow(
          column(6, numericInput("figure_pbv_to_xmin", "to xmin", value = 0.5)),
          column(6, numericInput("figure_pbv_to_xmax", "to xmax", value = 2.8))
        ),
        fluidRow(
          column(6, numericInput("figure_pbv_to_ymin", "to ymin", value = 8.0)),
          column(6, numericInput("figure_pbv_to_ymax", "to ymax", value = 13.0))
        ),

        hr(),
        h4(FIGURE_PBV_UI_TEXT$t_title_download_plot),
        wellPanel(
          fluidRow(
            column(6, numericInput("figure_pbv_width", FIGURE_PBV_UI_TEXT$t_label_figure_width, value = 11)),
            column(6, numericInput("figure_pbv_height", FIGURE_PBV_UI_TEXT$t_label_figure_height, value = 8))
          )
        ),
        actionButton("figure_pbv_apply_preview", FIGURE_PBV_UI_TEXT$t_btn_apply_preview, class = "btn btn-default"),
        br(),
        actionButton("open_pbv_pdf_modal", FIGURE_PBV_UI_TEXT$t_btn_download_pdf, class = "btn btn-default")
      )
    ),
    mainPanel(
      width = 8,
      class = "plot_area_card_style",
      style = "padding-top:0;",
      tagList(
        div(
          class = "wl-side",
          h4(FIGURE_PBV_UI_TEXT$t_title_plot_preview),
          div(
            id = "figure_pbv_preview_stage",
            class = "figure-preview-stage",
            div(
              id = "figure_pbv_preview_frame",
              class = "figure-preview-frame",
              figure_with_busy_spinner(plotOutput("figure_pbv_plot", width = "100%", height = "100%"))
            )
          )
        ),
        div(
          style = "margin-top:12px;",
          figure_code_card_ui(
            id = "figure_pbv_code_card",
            title = FIGURE_PBV_UI_TEXT$t_title_custom_r_code,
            notes = c(
              FIGURE_PBV_UI_TEXT$t_text_code_note_1,
              FIGURE_PBV_UI_TEXT$t_text_code_note_2,
              FIGURE_PBV_UI_TEXT$t_text_code_note_3,
              FIGURE_PBV_UI_TEXT$t_text_code_note_4
            ),
            copy_button_label = FIGURE_PBV_UI_TEXT$t_btn_copy_code,
            code_label = "Editable R code:"
          )
        )
      )
    )
  )
)

figure_pseudobulk_volcano_server <- function(input, output, session, shared_data) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b

  .normalize_preview_px <- function(width_raw, height_raw) {
    w <- suppressWarnings(as.numeric(width_raw %||% 11))
    h <- suppressWarnings(as.numeric(height_raw %||% 8))
    if (!is.finite(w) || w <= 0) w <- 11
    if (!is.finite(h) || h <= 0) h <- 8
    list(
      width_px = as.integer(max(320, round(w * 96))),
      height_px = as.integer(max(240, round(h * 96)))
    )
  }

  .safe_hex <- function(x, fallback = "#111111") {
    xx <- as.character(x %||% "")
    if (isTRUE(grepl("^#(?:[A-Fa-f0-9]{3}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$", xx))) return(xx)
    fallback
  }

  .finite_num <- function(x, fallback = 0) {
    out <- suppressWarnings(as.numeric(x))
    if (!is.finite(out)) return(fallback)
    out
  }

  .theme_settings <- figure_shared_plot_settings(session)
  figure_bind_shared_settings_inputs(input, .theme_settings, prefix = "figure_pbv_shared")

  preview_dims <- reactiveVal(.normalize_preview_px(11, 8))
  dataset_select_signature <- reactiveVal("")

  dataset_choices <- reactive({
    names(shared_data$all_seurat_objects %||% list())
  })

  selected_dataset_name <- reactive({
    figure_preferred_object_name(
      registry = shared_data$all_seurat_objects %||% list(),
      current_selection = input$figure_pbv_dataset_select %||% "",
      active_name = shared_data$active_object_name %||% ""
    )
  })

  active_entry <- reactive({
    nm <- selected_dataset_name()
    req(nzchar(nm))
    (shared_data$all_seurat_objects %||% list())[[nm]]
  })

  active_object <- reactive({
    entry <- active_entry()
    sobj <- figure_extract_seurat_object(entry)
    req(sobj)
    sobj
  })

  observe({
    object_choices <- dataset_choices()
    req(length(object_choices) > 0)
    selected_name <- selected_dataset_name()
    if (!figure_select_input_needs_update(dataset_select_signature(), object_choices, selected_name)) {
      return(invisible(NULL))
    }
    dataset_select_signature(figure_select_input_signature(object_choices, selected_name))
    shiny::freezeReactiveValue(input, "figure_pbv_dataset_select")
    updateSelectInput(session, "figure_pbv_dataset_select", choices = object_choices, selected = selected_name)
  })

  observe({
    req(identical(input$main_navbar %||% "", "figure_studio_pseudobulk_volcano_hidden"))
    selected_name <- selected_dataset_name()
    req(nzchar(selected_name))
    if (!identical(shared_data$active_object_name %||% "", selected_name)) {
      shared_data$active_object_name <- selected_name
    }
  })

  .pseudobulk_store <- reactive({
    entry <- active_entry()
    sobj <- figure_extract_seurat_object(entry)
    if (!inherits(sobj, "Seurat")) return(list())
    misc <- tryCatch(sobj@misc, error = function(e) list())
    ana <- tryCatch(misc$analysis, error = function(e) NULL)
    if (!is.list(ana)) return(list())
    pb <- tryCatch(ana$pseudobulk, error = function(e) NULL)
    if (!is.list(pb)) return(list())
    pb
  })

  .pb_overview <- reactive({
    payload <- .pseudobulk_store()[["overview"]]
    if (!is.list(payload)) return(NULL)
    payload$result %||% NULL
  })

  .pb_custom <- reactive({
    payload <- .pseudobulk_store()[["custom"]]
    if (!is.list(payload)) return(NULL)
    payload$result %||% NULL
  })

  .cluster_choices <- reactive({
    pb <- .pb_overview()
    if (is.null(pb) || is.null(pb$per_cluster) || !is.data.frame(pb$per_cluster) || !nrow(pb$per_cluster)) {
      return(character(0))
    }
    cl <- sort(unique(as.character(pb$per_cluster$cluster %||% character(0))))
    cl <- cl[nzchar(cl)]
    if (!length(cl)) return(character(0))
    c("All clusters (faceted)" = "__all__", stats::setNames(cl, cl))
  })

  output$figure_pbv_overview_cluster_ui <- renderUI({
    if (!identical(input$figure_pbv_mode %||% "overview", "overview")) return(NULL)
    choices <- .cluster_choices()
    if (!length(choices)) {
      return(helpText(FIGURE_PBV_UI_TEXT$t_text_no_cache_overview))
    }
    selected <- input$figure_pbv_overview_cluster %||% "__all__"
    if (!(selected %in% unname(choices))) selected <- "__all__"
    selectInput("figure_pbv_overview_cluster", FIGURE_PBV_UI_TEXT$t_label_3_overview_cluster, choices = choices, selected = selected)
  })

  .gene_candidates <- reactive({
    mode <- input$figure_pbv_mode %||% "overview"
    df <- NULL
    if (identical(mode, "custom")) {
      pb <- .pb_custom()
      if (!is.null(pb) && is.data.frame(pb$custom)) df <- pb$custom
    } else {
      pb <- .pb_overview()
      if (!is.null(pb) && is.data.frame(pb$per_cluster)) df <- pb$per_cluster
    }
    if (is.null(df) || !nrow(df)) return(character(0))
    candidates <- c("gene", "gene_symbol", "symbol", "feature", "features")
    candidates[candidates %in% colnames(df)]
  })

  output$figure_pbv_gene_column_ui <- renderUI({
    candidates <- .gene_candidates()
    if (!length(candidates)) return(helpText("No gene-name columns detected in current cached table."))
    selected <- input$figure_pbv_gene_column %||% candidates[[1]]
    if (!(selected %in% candidates)) selected <- candidates[[1]]
    selectInput("figure_pbv_gene_column", FIGURE_PBV_UI_TEXT$t_label_gene_column, choices = candidates, selected = selected)
  })

  observeEvent(input$figure_pbv_open_shared_settings, {
    showModal(figure_dark_modal_dialog(
      title = FIGURE_PBV_UI_TEXT$t_title_shared_plot_style,
      size = "l",
      easyClose = TRUE,
      footer = shiny::modalButton("Close"),
      figure_shared_settings_modal_body(
        prefix = "figure_pbv_shared",
        settings_values = figure_shared_plot_settings_values(.theme_settings)
      )
    ))
  }, ignoreInit = TRUE)

  .current_volcano_df <- reactive({
    mode <- input$figure_pbv_mode %||% "overview"
    if (identical(mode, "custom")) {
      pb <- .pb_custom()
      validate(need(!is.null(pb) && is.data.frame(pb$custom) && nrow(pb$custom), FIGURE_PBV_UI_TEXT$t_text_no_cache_custom))
      df <- pb$custom
      df$.__panel__ <- as.character(df$comparison %||% "Custom comparison")
    } else {
      pb <- .pb_overview()
      validate(need(!is.null(pb) && is.data.frame(pb$per_cluster) && nrow(pb$per_cluster), FIGURE_PBV_UI_TEXT$t_text_no_cache_overview))
      df <- pb$per_cluster
      sel <- input$figure_pbv_overview_cluster %||% "__all__"
      if (!identical(sel, "__all__")) {
        df <- df[as.character(df$cluster %||% "") %in% as.character(sel), , drop = FALSE]
      }
      validate(need(nrow(df) > 0, "No rows available for the selected overview cluster."))
      df$.__panel__ <- paste0("Cluster ", as.character(df$cluster %||% ""))
    }
    validate(need(all(c("logFC", "neglog10_fdr") %in% colnames(df)), "Cached result missing required columns: logFC and neglog10_fdr."))
    df <- df[is.finite(df$logFC) & is.finite(df$neglog10_fdr), , drop = FALSE]
    validate(need(nrow(df) > 0, "No finite volcano rows are available."))
    df
  })

  .compose_volcano_plot <- reactive({
    validate(need(length(dataset_choices()) > 0, FIGURE_PBV_UI_TEXT$t_text_no_dataset))
    validate(need(requireNamespace("ggmagnify", quietly = TRUE), FIGURE_PBV_UI_TEXT$t_text_ggmagnify_required))

    mode <- input$figure_pbv_mode %||% "overview"
    df <- .current_volcano_df()
    sty <- figure_shared_plot_settings_values(.theme_settings, track_reactive = TRUE)

    fdr_thr <- .finite_num(input$figure_pbv_fdr_threshold, 0.05)
    if (!is.finite(fdr_thr) || fdr_thr <= 0 || fdr_thr >= 1) fdr_thr <- 0.05
    y_cut <- -log10(pmax(fdr_thr, 1e-300))

    fc_cut <- abs(.finite_num(input$figure_pbv_fc_cutoff, 0.25))
    pt_alpha <- .finite_num(input$figure_pbv_alpha, 0.75)
    if (!is.finite(pt_alpha) || pt_alpha <= 0 || pt_alpha > 1) pt_alpha <- 0.75

    p_adj <- if ("p_adj" %in% colnames(df)) suppressWarnings(as.numeric(df$p_adj)) else rep(NA_real_, nrow(df))
    is_sig <- ifelse(is.finite(p_adj), p_adj <= fdr_thr, df$neglog10_fdr >= y_cut)
    df$.__status__ <- ifelse(
      is_sig & abs(df$logFC) >= fc_cut,
      ifelse(df$logFC > 0, "up", "down"),
      "nonsig"
    )

    col_up <- .safe_hex(input$figure_pbv_color_up, "#B91C1C")
    col_down <- .safe_hex(input$figure_pbv_color_down, "#1D4ED8")
    col_ns <- .safe_hex(input$figure_pbv_color_nonsig, "#9CA3AF")
    col_thr <- .safe_hex(input$figure_pbv_threshold_line_color, "#6B7280")

    p <- ggplot2::ggplot(df, ggplot2::aes(x = .data$logFC, y = .data$neglog10_fdr)) +
      ggplot2::geom_point(
        ggplot2::aes(color = .data$.__status__),
        size = sty$point_size,
        alpha = pt_alpha,
        shape = figure_safe_integer(sty$point_shape, 19L, min_value = 0L, max_value = 25L),
        stroke = sty$point_stroke
      ) +
      ggplot2::scale_color_manual(values = c(up = col_up, down = col_down, nonsig = col_ns), name = "Status") +
      ggplot2::geom_vline(xintercept = 0, linetype = 2, color = col_thr, linewidth = 0.4) +
      ggplot2::geom_hline(yintercept = y_cut, linetype = 3, color = col_thr, linewidth = 0.4)

    if (is.finite(fc_cut) && fc_cut > 0) {
      p <- p +
        ggplot2::geom_vline(xintercept = fc_cut, linetype = 3, color = col_thr, linewidth = 0.4) +
        ggplot2::geom_vline(xintercept = -fc_cut, linetype = 3, color = col_thr, linewidth = 0.4)
    }

    if (isTRUE(input$figure_pbv_show_labels)) {
      gene_col <- input$figure_pbv_gene_column %||% "gene"
      if (gene_col %in% colnames(df)) {
        n_top <- suppressWarnings(as.integer(input$figure_pbv_label_top_n %||% 12L))
        if (!is.finite(n_top) || n_top < 1) n_top <- 12L
        cand <- df[df$.__status__ != "nonsig", , drop = FALSE]
        if (nrow(cand)) {
          ord <- if ("p_adj" %in% colnames(cand)) suppressWarnings(as.numeric(cand$p_adj)) else rep(NA_real_, nrow(cand))
          cand <- cand[order(ord, -abs(cand$logFC), na.last = NA), , drop = FALSE]
          label_df <- utils::head(cand, n_top)
          label_df$.__label__ <- as.character(label_df[[gene_col]])
          if (requireNamespace("ggrepel", quietly = TRUE)) {
            p <- p + ggrepel::geom_text_repel(
              data = label_df,
              ggplot2::aes(label = .data$.__label__),
              size = 3,
              box.padding = 0.3,
              point.padding = 0.15,
              segment.alpha = 0.45,
              max.overlaps = Inf
            )
          } else {
            p <- p + ggplot2::geom_text(
              data = label_df,
              ggplot2::aes(label = .data$.__label__),
              size = 3,
              vjust = -0.35,
              check_overlap = TRUE
            )
          }
        }
      }
    }

    if (identical(mode, "overview") && identical(input$figure_pbv_overview_cluster %||% "__all__", "__all__")) {
      ncol_fac <- suppressWarnings(as.integer(input$figure_pbv_facet_cols %||% 4L))
      if (!is.finite(ncol_fac) || ncol_fac < 1) ncol_fac <- 4L
      p <- p + ggplot2::facet_wrap(~.__panel__, ncol = ncol_fac, scales = "free_y")
    }

    p <- figure_apply_plot_theme(
      plot_obj = p,
      theme_choice = sty$plot_theme,
      title = as.character(input$figure_pbv_plot_title %||% "Pseudobulk Volcano"),
      x_label = sty$x_label %||% "Fold change (pseudobulk mean difference)",
      y_label = sty$y_label %||% "-log10(FDR)",
      legend_text_size = sty$legend_text_size,
      axis_text_size = sty$axis_text_size,
      axis_title_size = sty$axis_title_size,
      plot_title_size = sty$title_size
    )

    if (identical(mode, "custom") && isTRUE(input$figure_pbv_use_magnify)) {
      from <- list(
        xmin = .finite_num(input$figure_pbv_from_xmin, -2),
        xmax = .finite_num(input$figure_pbv_from_xmax, -0.5),
        ymin = .finite_num(input$figure_pbv_from_ymin, 2),
        ymax = .finite_num(input$figure_pbv_from_ymax, 8)
      )
      to <- list(
        xmin = .finite_num(input$figure_pbv_to_xmin, 0.5),
        xmax = .finite_num(input$figure_pbv_to_xmax, 2.8),
        ymin = .finite_num(input$figure_pbv_to_ymin, 8),
        ymax = .finite_num(input$figure_pbv_to_ymax, 13)
      )
      validate(need(from$xmin < from$xmax && from$ymin < from$ymax, "Magnify 'from' bounds are invalid."))
      validate(need(to$xmin < to$xmax && to$ymin < to$ymax, "Magnify 'to' bounds are invalid."))

      p <- p + ggmagnify::geom_magnify(
        from = from,
        to = to,
        shape = as.character(input$figure_pbv_magnify_shape %||% "rect"),
        proj = as.character(input$figure_pbv_magnify_proj %||% "facing"),
        colour = .safe_hex(input$figure_pbv_magnify_color, "#111827"),
        linewidth = .finite_num(input$figure_pbv_magnify_lwd, 0.6),
        alpha = 1,
        shadow = FALSE
      )
    }

    p
  })

  output$figure_pbv_plot <- renderPlot({
    .compose_volcano_plot()
  }, width = function() {
    as.integer(preview_dims()$width_px %||% 1056L)
  }, height = function() {
    as.integer(preview_dims()$height_px %||% 768L)
  }, res = 96)

  .apply_preview <- function() {
    dims <- .normalize_preview_px(input$figure_pbv_width, input$figure_pbv_height)
    preview_dims(dims)
    session$sendCustomMessage("wl_figure_preview_fit", list(
      stage_id = "figure_pbv_preview_stage",
      frame_id = "figure_pbv_preview_frame",
      width_px = dims$width_px,
      height_px = dims$height_px
    ))
    invisible(dims)
  }

  observeEvent(input$figure_pbv_apply_preview, {
    .apply_preview()
  }, ignoreInit = TRUE)

  observeEvent(input$main_navbar, {
    req(identical(input$main_navbar %||% "", "figure_studio_pseudobulk_volcano_hidden"))
    .apply_preview()
  }, ignoreInit = FALSE)

  .generate_script <- reactive({
    mode <- input$figure_pbv_mode %||% "overview"
    obj_name <- selected_dataset_name()
    sty <- figure_shared_plot_settings_values(.theme_settings, track_reactive = TRUE)
    analysis_recipe <- list(object_name = obj_name, pseudobulk_result = mode)
    figure_recipe <- list(
      studio = "Pseudobulk Volcano Studio",
      fdr_threshold = .finite_num(input$figure_pbv_fdr_threshold, 0.05),
      fold_change_cutoff = abs(.finite_num(input$figure_pbv_fc_cutoff, 0.25)),
      title = input$figure_pbv_plot_title %||% "Pseudobulk Volcano",
      colors = list(
        up = .safe_hex(input$figure_pbv_color_up, "#B91C1C"),
        down = .safe_hex(input$figure_pbv_color_down, "#1D4ED8"),
        nonsignificant = .safe_hex(input$figure_pbv_color_nonsig, "#9CA3AF")
      ),
      point_size = .finite_num(sty$point_size, 1),
      point_alpha = .finite_num(input$figure_pbv_alpha, 0.75),
      magnify = list(
        enabled = isTRUE(input$figure_pbv_use_magnify) && identical(mode, "custom"),
        shape = input$figure_pbv_magnify_shape %||% "rect",
        projection = input$figure_pbv_magnify_proj %||% "facing"
      )
    )
    lines <- c(
      figure_recipe_code_lines(analysis_recipe, figure_recipe),
      "# 1) Load packages",
      "library(ggplot2)",
      "library(ggmagnify)",
      "",
      "# 2) Optional: import exported workspace bundle (.rds)",
      "bundle <- readRDS('PATH/TO/workspace_bundle.rds')",
      "shared_data <- list(all_seurat_objects = bundle$all_seurat_objects)",
      "",
      sprintf("obj_name <- %s  # Selected object", deparse(as.character(obj_name))),
      sprintf("mode <- %s  # 'overview' or 'custom'", deparse(as.character(mode))),
      "",
      ".coalesce <- function(a, b) if (!is.null(a)) a else b",
      "entry <- shared_data$all_seurat_objects[[obj_name]]",
      "sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry",
      "pb_store <- .coalesce(.coalesce(sobj@misc$analysis, list())$pseudobulk, list())",
      "payload_overview <- pb_store[['overview']]",
      "payload_custom <- pb_store[['custom']]",
      "df <- if (identical(mode, 'custom')) payload_custom$result$custom else payload_overview$result$per_cluster",
      "stopifnot(is.data.frame(df), all(c('logFC','neglog10_fdr') %in% colnames(df)))",
      "df <- df[is.finite(df$logFC) & is.finite(df$neglog10_fdr), , drop = FALSE]",
      "",
      sprintf("fdr_thr <- %s", format(.finite_num(input$figure_pbv_fdr_threshold, 0.05), digits = 6)),
      sprintf("fc_cut <- %s", format(abs(.finite_num(input$figure_pbv_fc_cutoff, 0.25)), digits = 6)),
      sprintf("plot_title <- %s", deparse(as.character(input$figure_pbv_plot_title %||% "Pseudobulk Volcano"))),
      sprintf("color_up <- %s", deparse(.safe_hex(input$figure_pbv_color_up, "#B91C1C"))),
      sprintf("color_down <- %s", deparse(.safe_hex(input$figure_pbv_color_down, "#1D4ED8"))),
      sprintf("color_nonsig <- %s", deparse(.safe_hex(input$figure_pbv_color_nonsig, "#9CA3AF"))),
      "",
      "y_cut <- -log10(pmax(fdr_thr, 1e-300))",
      "is_sig <- if ('p_adj' %in% colnames(df)) is.finite(df$p_adj) & df$p_adj <= fdr_thr else df$neglog10_fdr >= y_cut",
      "status <- ifelse(is_sig & abs(df$logFC) >= fc_cut, ifelse(df$logFC > 0, 'up', 'down'), 'nonsig')",
      "",
      "p <- ggplot(df, aes(logFC, neglog10_fdr)) +",
      sprintf("  geom_point(aes(color = status), size = %s, alpha = %s) +", format(.finite_num(sty$point_size, 1), digits = 6), format(.finite_num(input$figure_pbv_alpha, 0.75), digits = 6)),
      "  scale_color_manual(values = c(up = color_up, down = color_down, nonsig = color_nonsig)) +",
      "  geom_vline(xintercept = c(-fc_cut, 0, fc_cut), linetype = c(3, 2, 3), color = '#6B7280') +",
      "  geom_hline(yintercept = y_cut, linetype = 3, color = '#6B7280') +",
      "  labs(title = plot_title, x = 'Fold change (pseudobulk mean difference)', y = '-log10(FDR)')",
      "",
      sprintf("use_magnify <- %s", if (isTRUE(input$figure_pbv_use_magnify) && identical(mode, "custom")) "TRUE" else "FALSE"),
      "if (isTRUE(use_magnify)) {",
      sprintf("  from <- list(xmin=%s, xmax=%s, ymin=%s, ymax=%s)", format(.finite_num(input$figure_pbv_from_xmin, -2), digits = 6), format(.finite_num(input$figure_pbv_from_xmax, -0.5), digits = 6), format(.finite_num(input$figure_pbv_from_ymin, 2), digits = 6), format(.finite_num(input$figure_pbv_from_ymax, 8), digits = 6)),
      sprintf("  to <- list(xmin=%s, xmax=%s, ymin=%s, ymax=%s)", format(.finite_num(input$figure_pbv_to_xmin, 0.5), digits = 6), format(.finite_num(input$figure_pbv_to_xmax, 2.8), digits = 6), format(.finite_num(input$figure_pbv_to_ymin, 8), digits = 6), format(.finite_num(input$figure_pbv_to_ymax, 13), digits = 6)),
      sprintf("  p <- p + geom_magnify(from = from, to = to, shape = %s, proj = %s, colour = %s, linewidth = %s)",
              deparse(as.character(input$figure_pbv_magnify_shape %||% "rect")),
              deparse(as.character(input$figure_pbv_magnify_proj %||% "facing")),
              deparse(.safe_hex(input$figure_pbv_magnify_color, "#111827")),
              format(.finite_num(input$figure_pbv_magnify_lwd, 0.6), digits = 6)
      ),
      "}",
      "",
      "# 5) Add extra ggplot layers below",
      "print(p)"
    )
    paste(lines, collapse = "\n")
  })

  figure_code_card_server(
    "figure_pbv_code_card",
    code_text_reactive = .generate_script,
    shared_data = shared_data,
    object_name_reactive = selected_dataset_name,
    studio_name = "Pseudobulk Volcano Studio"
  )

  .pdf_bundle <- function(kind, width_px = NULL, height_px = NULL) {
    req(identical(kind, "pbv_pdf"))
    p <- .compose_volcano_plot()
    req(p)
    width_in <- .finite_num(input$figure_pbv_width, 11)
    height_in <- .finite_num(input$figure_pbv_height, 8)
    if (is.finite(width_px) && width_px > 0) width_in <- width_px / 96
    if (is.finite(height_px) && height_px > 0) height_in <- height_px / 96
    list(
      plot = p,
      width_px = as.integer(max(320, round(width_in * 96))),
      height_px = as.integer(max(240, round(height_in * 96))),
      filename_prefix = paste0(selected_dataset_name() %||% "dataset", "_Pseudobulk_Volcano_")
    )
  }

  .pdf_modal_server <- get0("wl_pdf_modal_server", mode = "function", ifnotfound = NULL)
  if (is.null(.pdf_modal_server)) {
    stop("Shared PDF modal helper is unavailable. Please source interface/shared/shared_pdf_export_modal.R first.")
  }
  .pdf_modal <- .pdf_modal_server(
    input = input,
    output = output,
    session = session,
    id_prefix = "figure_pbv_pdf",
    build_bundle = .pdf_bundle,
    download_btn_label = FIGURE_PBV_UI_TEXT$t_btn_download_pdf,
    default_modal_title = "PDF export settings: Hidden Pseudobulk Volcano"
  )

  observeEvent(input$open_pbv_pdf_modal, {
    .pdf_modal$open("pbv_pdf", title_txt = "PDF export settings: Hidden Pseudobulk Volcano")
  }, ignoreInit = TRUE)
}
