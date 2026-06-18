# R/page_figure_feature.R
FIGURE_FEATURE_UI_TEXT <- list(
  t_btn_apply_preview = "Apply Preview",
  t_btn_apply_colors = "Apply Colors",
  t_btn_copy_code = "Copy Code",
  t_btn_download_pdf = "Download PDF",
  t_btn_open_dot_picker = "Open Dot Picker",
  t_btn_shared_plot_settings = "Shared Plot Settings",
  t_label_1_select_dataset = "1. Select Dataset:",
  t_label_2_select_assay = "2. Select Assay:",
  t_label_3_select_gene = "3. Select Gene:",
  t_label_4_column_split = "4. Column split by:",
  t_label_5_row_split = "5. Row split by:",
  t_label_color_high_expression = "High expression color",
  t_label_color_low_expression = "Low expression color",
  t_label_editable_r_code = "Editable R code:",
  t_label_height = "Height (in):",
  t_label_plot_title = "Plot Title:",
  t_label_stroke_clusters = "Stroke clusters:",
  t_label_stroke_cluster_column = "Stroke cluster column:",
  t_label_stroke_color = "Stroke color:",
  t_label_stroke_dash_frequency = "Dash frequency:",
  t_label_stroke_enable = "Enable cluster stroke",
  t_label_stroke_merge = "Merge selected clusters into one stroke",
  t_label_stroke_padding = "Stroke padding:",
  t_label_stroke_smoothness = "Stroke smoothness:",
  t_label_stroke_width = "Stroke width:",
  t_label_width = "Width (in):",
  t_text_feature_gradient_note = "The popup keeps changes in draft mode until you click Apply.",
  t_text_feature_gradient_subtitle = "Low-to-high expression gradient for the active Feature Plot.",
  t_text_code_note_1 = "The generated script includes a workspace import line: bundle <- readRDS('PATH/TO/workspace_bundle.rds').",
  t_text_code_note_2 = "Each configurable parameter line includes an inline comment so users know what to edit.",
  t_text_code_note_3 = "This script is pipeline-independent (Seurat + ggplot2 + workspace object only, no source() helpers).",
  t_text_code_note_4 = "Add custom layers/theme changes under '# 8) Add extra ggplot layers below'.",
  t_text_select_dataset_gene_visualize_its_expression = "Select a dataset and a gene to visualize its expression across the UMAP projection.",
  t_title_color_customization = "Color Customization",
  t_title_custom_r_code = "Customize in R",
  t_title_download_plot = "Download Plot",
  t_title_feature_color_popup = "Feature Plot Colors",
  t_title_feature_gradient_card = "Feature colors",
  t_title_feature_plot_customization = "Feature Plot Customization",
  t_title_plot_controls = "Plot Controls",
  t_title_plot_preview = "Plot Preview",
  t_title_shared_plot_style = "Shared Plot Style",
  t_title_stroke_customization = "Cluster Stroke",
  t_title_text_legend = "Text & Legend",
  t_title_feature_shared_settings = "Shared Plot Settings"
)

library(ggplot2)

# --- UI for the Feature Plot Page ---
figure_feature_ui <- fluidPage(
  tags$head(
    figure_busy_spinner_assets,
    if (is.function(get0("wl_pdf_modal_assets", mode = "function", ifnotfound = NULL))) wl_pdf_modal_assets() else NULL
  ),
  div(
    class = "page-header",
    h2(icon("line-chart"), " ", FIGURE_FEATURE_UI_TEXT$t_title_feature_plot_customization),
    p(FIGURE_FEATURE_UI_TEXT$t_text_select_dataset_gene_visualize_its_expression)
  ),
  hr(),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      class = "plotting-left-panel",
      style = "padding-top:0;",
      div(
        class = "wl-side",
        h4(FIGURE_FEATURE_UI_TEXT$t_title_plot_controls),

        selectInput("figure_feature_dataset_select", FIGURE_FEATURE_UI_TEXT$t_label_1_select_dataset, choices = NULL),
        selectInput("figure_feature_assay_select", FIGURE_FEATURE_UI_TEXT$t_label_2_select_assay, choices = NULL),
        wl_gene_selectize_input(
          "figure_feature_gene_select",
          FIGURE_FEATURE_UI_TEXT$t_label_3_select_gene,
          placeholder = "Type to search gene"
        ),
        selectInput("figure_feature_column_split", FIGURE_FEATURE_UI_TEXT$t_label_4_column_split, choices = c("None" = "__none__")),
        selectInput("figure_feature_row_split", FIGURE_FEATURE_UI_TEXT$t_label_5_row_split, choices = c("None" = "__none__")),

        hr(),
        h5(FIGURE_FEATURE_UI_TEXT$t_title_shared_plot_style),
        actionButton("figure_feature_open_shared_settings", FIGURE_FEATURE_UI_TEXT$t_btn_shared_plot_settings, class = "btn btn-default"),

        hr(),
        h5(FIGURE_FEATURE_UI_TEXT$t_title_text_legend),
        textInput("figure_feature_title_text", FIGURE_FEATURE_UI_TEXT$t_label_plot_title, value = "Feature Plot"),
        hr(),
        h5(FIGURE_FEATURE_UI_TEXT$t_title_stroke_customization),
        checkboxInput("figure_feature_stroke_enable", FIGURE_FEATURE_UI_TEXT$t_label_stroke_enable, value = FALSE),
        selectInput("figure_feature_stroke_cluster_col", FIGURE_FEATURE_UI_TEXT$t_label_stroke_cluster_column, choices = NULL),
        selectizeInput(
          "figure_feature_stroke_clusters",
          FIGURE_FEATURE_UI_TEXT$t_label_stroke_clusters,
          choices = NULL,
          selected = character(0),
          multiple = TRUE,
          options = list(placeholder = "Select one or more clusters")
        ),
        checkboxInput("figure_feature_stroke_merge", FIGURE_FEATURE_UI_TEXT$t_label_stroke_merge, value = FALSE),
        sliderInput("figure_feature_stroke_padding", FIGURE_FEATURE_UI_TEXT$t_label_stroke_padding, min = 0, max = 0.5, value = 0.08, step = 0.01),
        sliderInput("figure_feature_stroke_smoothness", FIGURE_FEATURE_UI_TEXT$t_label_stroke_smoothness, min = 0, max = 6, value = 2, step = 1),
        sliderInput("figure_feature_stroke_dash_frequency", FIGURE_FEATURE_UI_TEXT$t_label_stroke_dash_frequency, min = 1, max = 9, value = 5, step = 1),
        sliderInput("figure_feature_stroke_width", FIGURE_FEATURE_UI_TEXT$t_label_stroke_width, min = 0.2, max = 4, value = 1.2, step = 0.1),
        textInput("figure_feature_stroke_color", FIGURE_FEATURE_UI_TEXT$t_label_stroke_color, value = "#111111"),

        hr(),
        h5(FIGURE_FEATURE_UI_TEXT$t_title_color_customization),
        uiOutput("feature_gradient_card_ui"),

        hr(),
        h4(FIGURE_FEATURE_UI_TEXT$t_title_download_plot),
        wellPanel(
          fluidRow(
            column(6, numericInput("figure_feature_width", FIGURE_FEATURE_UI_TEXT$t_label_width, value = 7)),
            column(6, numericInput("figure_feature_height", FIGURE_FEATURE_UI_TEXT$t_label_height, value = 7))
          )
        ),
        actionButton("figure_feature_apply_preview", FIGURE_FEATURE_UI_TEXT$t_btn_apply_preview, class = "btn btn-default"),
        br(),
        actionButton("open_feature_pdf_modal", FIGURE_FEATURE_UI_TEXT$t_btn_download_pdf, class = "btn btn-default")
      )
    ),
    mainPanel(
      width = 8,
      class = "plot_area_card_style",
      style = "padding-top:0;",
      tagList(
        div(
          class = "wl-side",
          h4(FIGURE_FEATURE_UI_TEXT$t_title_plot_preview),
          div(
            id = "figure_feature_preview_stage",
            class = "figure-preview-stage",
            div(
              id = "figure_feature_preview_frame",
              class = "figure-preview-frame",
              figure_with_busy_spinner(plotOutput("figure_feature_plot", width = "100%", height = "100%"))
            )
          )
        ),
        div(
          style = "margin-top:12px;",
          figure_code_card_ui(
            id = "figure_feature_code_card",
            title = FIGURE_FEATURE_UI_TEXT$t_title_custom_r_code,
                    notes = c(
                      FIGURE_FEATURE_UI_TEXT$t_text_code_note_1,
                      FIGURE_FEATURE_UI_TEXT$t_text_code_note_2,
                      FIGURE_FEATURE_UI_TEXT$t_text_code_note_3,
                      FIGURE_FEATURE_UI_TEXT$t_text_code_note_4
                    ),
            copy_button_label = FIGURE_FEATURE_UI_TEXT$t_btn_copy_code,
            code_label = FIGURE_FEATURE_UI_TEXT$t_label_editable_r_code
          )
        )
      )
    )
  )
)

# --- Server Logic for the Feature Plot Page ---
figure_feature_server <- function(input, output, session, shared_data) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  .normalize_preview_px <- function(width_raw, height_raw) {
    w <- suppressWarnings(as.numeric(width_raw %||% 7))
    h <- suppressWarnings(as.numeric(height_raw %||% 7))
    if (!is.finite(w) || w <= 0) w <- 7
    if (!is.finite(h) || h <= 0) h <- 7
    list(
      width_px = as.integer(max(320, round(w * 96))),
      height_px = as.integer(max(240, round(h * 96)))
    )
  }
  feature_preview_dims <- reactiveVal(.normalize_preview_px(7, 7))
  .pick_reduction <- function(obj) {
    reds <- names(obj@reductions %||% list())
    if (!length(reds)) return(NULL)
    pref <- c("umap", "tsne", "pca")
    hit <- pref[pref %in% reds]
    if (length(hit)) return(hit[[1]])
    reds[[1]]
  }

  feature_gradient_defaults <- c(low = "#D3D3D3", high = "#FF0000")
  feature_gradient_state <- reactiveVal(feature_gradient_defaults)
  feature_gradient_modal_seed <- reactiveVal(feature_gradient_defaults)
  feature_low_picker <- motion_color_picker_server("feature_low_picker", reset_trigger = reactive(input$feature_gradient_reset))
  feature_high_picker <- motion_color_picker_server("feature_high_picker", reset_trigger = reactive(input$feature_gradient_reset))
  shared_plot_settings <- figure_shared_plot_settings(session)
  dataset_select_signature <- reactiveVal("")
  column_split_select_signature <- reactiveVal("")
  row_split_select_signature <- reactiveVal("")
  stroke_column_select_signature <- reactiveVal("")
  stroke_clusters_select_signature <- reactiveVal("")
  dataset_choices <- reactive({
    names(shared_data$all_seurat_objects %||% list())
  })
  figure_bind_shared_settings_inputs(input, shared_plot_settings, prefix = "figure_feature_shared")

  selected_dataset_name <- reactive({
    figure_preferred_object_name(
      registry = shared_data$all_seurat_objects %||% list(),
      current_selection = input$figure_feature_dataset_select %||% "",
      active_name = shared_data$active_object_name %||% "",
      required_reductions = c("umap", "tsne", "pca")
    )
  })

  active_object <- reactive({
    selected_name <- selected_dataset_name()
    req(nzchar(selected_name))
    obj <- figure_extract_seurat_object((shared_data$all_seurat_objects %||% list())[[selected_name]])
    req(obj)
    obj
  })

  observe({
    object_choices <- dataset_choices()
    req(length(object_choices) > 0)
    selected_name <- selected_dataset_name()
    if (!figure_select_input_needs_update(dataset_select_signature(), object_choices, selected_name)) {
      return(invisible(NULL))
    }
    dataset_select_signature(figure_select_input_signature(object_choices, selected_name))
    shiny::freezeReactiveValue(input, "figure_feature_dataset_select")
    updateSelectInput(session, "figure_feature_dataset_select", choices = object_choices, selected = selected_name)
  })

  observe({
    req(identical(input$main_navbar %||% "", "figure_studio_feature"))
    selected_name <- selected_dataset_name()
    req(nzchar(selected_name))
    if (!identical(shared_data$active_object_name %||% "", selected_name)) {
      shared_data$active_object_name <- selected_name
    }
  })

  observe({
    obj <- active_object()
    req(obj)

    assay_choices <- Assays(obj)
    updateSelectInput(session, "figure_feature_assay_select", choices = assay_choices, selected = DefaultAssay(obj))

    req(input$figure_feature_assay_select)
    gene_choices <- rownames(obj[[input$figure_feature_assay_select]])
    wl_update_gene_selectize(session, "figure_feature_gene_select", gene_choices)
  })

  stroke_cluster_column <- reactive({
    obj <- active_object()
    req(obj)
    choices <- figure_meta_columns_for_color(obj@meta.data)
    figure_pick_selected_choice(
      choices,
      preferred = input$figure_feature_stroke_cluster_col %||% if ("seurat_clusters" %in% choices) "seurat_clusters" else NULL
    )
  })

  observe({
    obj <- active_object()
    req(obj)
    stroke_choices <- figure_meta_columns_for_color(obj@meta.data)
    selected_stroke_col <- stroke_cluster_column()
    if (!figure_select_input_needs_update(stroke_column_select_signature(), stroke_choices, selected_stroke_col)) {
      return(invisible(NULL))
    }
    stroke_column_select_signature(figure_select_input_signature(stroke_choices, selected_stroke_col))
    shiny::freezeReactiveValue(input, "figure_feature_stroke_cluster_col")
    updateSelectInput(
      session,
      "figure_feature_stroke_cluster_col",
      choices = stroke_choices,
      selected = selected_stroke_col %||% character(0)
    )
  })

  observe({
    obj <- active_object()
    req(obj)
    stroke_col <- figure_safe_meta_col(obj@meta.data, stroke_cluster_column())
    stroke_levels <- if (is.null(stroke_col)) character(0) else {
      figure_color_levels_from_vector(obj@meta.data[[stroke_col]], column_name = stroke_col)
    }
    stroke_levels_sig <- figure_select_input_signature(stroke_levels, "")
    if (identical(stroke_clusters_select_signature(), stroke_levels_sig)) {
      return(invisible(NULL))
    }
    stroke_clusters_select_signature(stroke_levels_sig)
    selected_clusters <- as.character(input$figure_feature_stroke_clusters %||% character(0))
    selected_clusters <- intersect(selected_clusters, stroke_levels)
    shiny::freezeReactiveValue(input, "figure_feature_stroke_clusters")
    updateSelectizeInput(
      session,
      "figure_feature_stroke_clusters",
      choices = stroke_levels,
      selected = selected_clusters,
      server = TRUE
    )
  })

  observe({
    obj <- active_object()
    req(obj)
    column_choices <- figure_split_choices(obj@meta.data)
    selected_column <- input$figure_feature_column_split %||% "__none__"
    if (!selected_column %in% unname(column_choices)) selected_column <- "__none__"
    if (!figure_select_input_needs_update(column_split_select_signature(), unname(column_choices), selected_column)) {
      return(invisible(NULL))
    }
    column_split_select_signature(figure_select_input_signature(unname(column_choices), selected_column))
    shiny::freezeReactiveValue(input, "figure_feature_column_split")
    updateSelectInput(
      session,
      "figure_feature_column_split",
      choices = column_choices,
      selected = selected_column
    )
  })

  observe({
    obj <- active_object()
    req(obj)
    selected_column <- figure_normalize_split_value(input$figure_feature_column_split)
    row_choices <- figure_split_choices(obj@meta.data, exclude = selected_column %||% character(0))
    selected_row <- input$figure_feature_row_split %||% "__none__"
    if (!selected_row %in% unname(row_choices)) selected_row <- "__none__"
    if (!figure_select_input_needs_update(row_split_select_signature(), unname(row_choices), selected_row)) {
      return(invisible(NULL))
    }
    row_split_select_signature(figure_select_input_signature(unname(row_choices), selected_row))
    shiny::freezeReactiveValue(input, "figure_feature_row_split")
    updateSelectInput(
      session,
      "figure_feature_row_split",
      choices = row_choices,
      selected = selected_row
    )
  })

  output$feature_gradient_card_ui <- renderUI({
    figure_color_card_ui(
      title = FIGURE_FEATURE_UI_TEXT$t_title_feature_gradient_card,
      subtitle = FIGURE_FEATURE_UI_TEXT$t_text_feature_gradient_subtitle,
      swatch_ui = figure_gradient_swatches_ui(feature_gradient_state()),
      button_id = "open_feature_gradient_popup",
      button_label = FIGURE_FEATURE_UI_TEXT$t_btn_open_dot_picker,
      note = FIGURE_FEATURE_UI_TEXT$t_text_feature_gradient_note
    )
  })

  observeEvent(input$open_feature_gradient_popup, {
    current <- feature_gradient_state()
    feature_gradient_modal_seed(current)
    showModal(figure_dark_modal_dialog(
      title = FIGURE_FEATURE_UI_TEXT$t_title_feature_color_popup,
      size = "l",
      easyClose = TRUE,
      footer = figure_picker_modal_footer(
        reset_id = "feature_gradient_reset",
        apply_id = "feature_gradient_apply",
        apply_label = FIGURE_FEATURE_UI_TEXT$t_btn_apply_colors
      ),
      figure_two_color_modal_body(
        low_picker_id = "feature_low_picker",
        high_picker_id = "feature_high_picker",
        low_hex = current[["low"]],
        high_hex = current[["high"]],
        low_label = FIGURE_FEATURE_UI_TEXT$t_label_color_low_expression,
        high_label = FIGURE_FEATURE_UI_TEXT$t_label_color_high_expression
      )
    ))
  }, ignoreInit = TRUE)

  observeEvent(input$feature_gradient_apply, {
    feature_gradient_state(
      figure_gradient_commit_values(
        low_payload = feature_low_picker(),
        high_payload = feature_high_picker(),
        defaults = feature_gradient_modal_seed()
      )
    )
    removeModal()
  }, ignoreInit = TRUE)

  observeEvent(input$figure_feature_open_shared_settings, {
    showModal(figure_dark_modal_dialog(
      title = FIGURE_FEATURE_UI_TEXT$t_title_feature_shared_settings,
      size = "l",
      easyClose = TRUE,
      footer = shiny::modalButton("Close"),
      figure_shared_settings_modal_body(
        prefix = "figure_feature_shared",
        settings_values = figure_shared_plot_settings_values(shared_plot_settings)
      )
    ))
  }, ignoreInit = TRUE)

  custom_feature_plot <- reactive({
    req(active_object(), input$figure_feature_gene_select)

    obj <- active_object()
    gene_to_plot <- input$figure_feature_gene_select
    assay_to_use <- input$figure_feature_assay_select
    gradient_colors <- feature_gradient_state()
    shared_settings <- figure_shared_plot_settings_values(shared_plot_settings, track_reactive = TRUE)

    red_to_use <- .pick_reduction(obj)
    validate(need(!is.null(red_to_use), "No dimensional reduction found. Run PCA/UMAP first."))
    split_vars <- figure_normalize_split_vars(
      column_split = input$figure_feature_column_split,
      row_split = input$figure_feature_row_split
    )
    figure_build_feature_embedding_plot(
      sobj = obj,
      reduction_name = red_to_use,
      assay_name = assay_to_use,
      feature_name = gene_to_plot,
      low_color = gradient_colors[["low"]],
      high_color = gradient_colors[["high"]],
      column_split = split_vars$column_split,
      row_split = split_vars$row_split,
      dot_size = shared_settings$point_size,
      alpha = shared_settings$point_alpha,
      title = input$figure_feature_title_text,
      x_label = shared_settings$x_label,
      y_label = shared_settings$y_label,
      theme_choice = shared_settings$plot_theme,
      point_shape = shared_settings$point_shape,
      point_stroke = shared_settings$point_stroke,
      color_map = shared_settings$color_map,
      stroke_enabled = isTRUE(input$figure_feature_stroke_enable),
      stroke_column = stroke_cluster_column(),
      stroke_selected_values = input$figure_feature_stroke_clusters %||% character(0),
      stroke_merge = isTRUE(input$figure_feature_stroke_merge),
      stroke_padding = input$figure_feature_stroke_padding,
      stroke_smoothness = input$figure_feature_stroke_smoothness,
      stroke_width = input$figure_feature_stroke_width,
      stroke_dash_frequency = input$figure_feature_stroke_dash_frequency,
      stroke_color = input$figure_feature_stroke_color,
      legend_text_size = shared_settings$legend_text_size,
      axis_text_size = shared_settings$axis_text_size,
      axis_title_size = shared_settings$axis_title_size,
      plot_title_size = shared_settings$title_size
    )
  })

  generated_plot_code <- reactive({
    shared_settings <- figure_shared_plot_settings_values(shared_plot_settings, track_reactive = TRUE)
    split_vars <- figure_normalize_split_vars(
      column_split = input$figure_feature_column_split,
      row_split = input$figure_feature_row_split
    )
    figure_generate_feature_script(list(
      object_name = selected_dataset_name(),
      reduction_name = .pick_reduction(active_object()),
      assay_name = input$figure_feature_assay_select,
      feature_name = input$figure_feature_gene_select,
      low_color = feature_gradient_state()[["low"]],
      high_color = feature_gradient_state()[["high"]],
      column_split = split_vars$column_split,
      row_split = split_vars$row_split,
      point_size = shared_settings$point_size,
      point_alpha = shared_settings$point_alpha,
      title = input$figure_feature_title_text,
      x_label = shared_settings$x_label,
      y_label = shared_settings$y_label,
      theme_choice = shared_settings$plot_theme,
      point_shape = shared_settings$point_shape,
      point_stroke = shared_settings$point_stroke,
      color_map = shared_settings$color_map,
      stroke_enabled = isTRUE(input$figure_feature_stroke_enable),
      stroke_column = stroke_cluster_column(),
      stroke_selected_values = input$figure_feature_stroke_clusters %||% character(0),
      stroke_merge = isTRUE(input$figure_feature_stroke_merge),
      stroke_padding = input$figure_feature_stroke_padding,
      stroke_smoothness = input$figure_feature_stroke_smoothness,
      stroke_width = input$figure_feature_stroke_width,
      stroke_dash_frequency = input$figure_feature_stroke_dash_frequency,
      stroke_color = input$figure_feature_stroke_color,
      legend_text_size = shared_settings$legend_text_size,
      axis_text_size = shared_settings$axis_text_size,
      axis_title_size = shared_settings$axis_title_size,
      plot_title_size = shared_settings$title_size
    ))
  })
  figure_code_card_server("figure_feature_code_card", code_text_reactive = generated_plot_code)

  output$figure_feature_plot <- renderPlot({
    custom_feature_plot()
  }, width = function() {
    as.integer(feature_preview_dims()$width_px %||% 672L)
  }, height = function() {
    as.integer(feature_preview_dims()$height_px %||% 672L)
  }, res = 96)

  .apply_feature_preview <- function() {
    dims <- .normalize_preview_px(
      width_raw = input$figure_feature_width,
      height_raw = input$figure_feature_height
    )
    feature_preview_dims(dims)
    session$sendCustomMessage("wl_figure_preview_fit", list(
      stage_id = "figure_feature_preview_stage",
      frame_id = "figure_feature_preview_frame",
      width_px = dims$width_px,
      height_px = dims$height_px
    ))
    invisible(dims)
  }

  observeEvent(input$figure_feature_apply_preview, {
    .apply_feature_preview()
  }, ignoreInit = TRUE)

  observeEvent(input$main_navbar, {
    req(identical(input$main_navbar %||% "", "figure_studio_feature"))
    .apply_feature_preview()
  }, ignoreInit = FALSE)

  .figure_feature_pdf_bundle <- function(kind, width_px = NULL, height_px = NULL) {
    req(identical(kind, "feature_pdf"))
    p <- custom_feature_plot()
    req(p)
    width_in <- suppressWarnings(as.numeric(input$figure_feature_width %||% 7))
    height_in <- suppressWarnings(as.numeric(input$figure_feature_height %||% 7))
    if (!is.finite(width_in) || width_in <= 0) width_in <- 7
    if (!is.finite(height_in) || height_in <= 0) height_in <- 7
    if (is.finite(width_px) && width_px > 0) width_in <- width_px / 96
    if (is.finite(height_px) && height_px > 0) height_in <- height_px / 96
    list(
      plot = p,
      width_px = as.integer(max(320, round(width_in * 96))),
      height_px = as.integer(max(240, round(height_in * 96))),
      filename_prefix = paste0(
        input$figure_feature_dataset_select %||% "dataset",
        "_",
        input$figure_feature_gene_select %||% "gene",
        "_FeaturePlot_"
      )
    )
  }

  .pdf_modal_server <- get0("wl_pdf_modal_server", mode = "function", ifnotfound = NULL)
  if (is.null(.pdf_modal_server)) stop("Shared PDF modal helper is unavailable. Please source interface/shared/shared_pdf_export_modal.R first.")
  .figure_feature_pdf_modal <- .pdf_modal_server(
    input = input,
    output = output,
    session = session,
    id_prefix = "figure_feature_pdf",
    build_bundle = .figure_feature_pdf_bundle,
    download_btn_label = FIGURE_FEATURE_UI_TEXT$t_btn_download_pdf,
    default_modal_title = "PDF export settings: Feature Plot"
  )

  observeEvent(input$open_feature_pdf_modal, {
    .figure_feature_pdf_modal$open("feature_pdf", title_txt = "PDF export settings: Feature Plot")
  }, ignoreInit = TRUE)
}
