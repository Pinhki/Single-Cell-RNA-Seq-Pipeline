# R/page_figure_umap.R
FIGURE_UMAP_UI_TEXT <- list(
  t_btn_apply_preview = "Apply Preview",
  t_btn_apply_palette = "Apply Palette",
  t_btn_copy_code = "Copy Code",
  t_btn_download_pdf = "Download PDF",
  t_btn_download_svg = "Download SVG",
  t_btn_open_curve_picker = "Open Curve Picker",
  t_btn_shared_plot_settings = "Shared Plot Settings",
  t_label_1_select_dataset = "1. Select Dataset:",
  t_label_2_color_points = "2. Color Points By:",
  t_label_3_column_split = "3. Column split by:",
  t_label_4_row_split = "4. Row split by:",
  t_label_annotate_populations = "Annotate populations",
  t_label_apply_color_palette = "Apply Color Palette:",
  t_label_cluster_label_size = "Cluster Label Size:",
  t_label_curve_palette = "Curve palette",
  t_label_editable_r_code = "Editable R code:",
  t_label_height = "Height:",
  t_label_legend_position = "Legend position:",
  t_label_legend_columns = "Legend columns (top/bottom):",
  t_label_stroke_clusters = "Stroke clusters:",
  t_label_stroke_cluster_column = "Stroke cluster column:",
  t_label_stroke_color = "Stroke color:",
  t_label_stroke_dash_frequency = "Dash frequency:",
  t_label_stroke_enable = "Enable cluster stroke",
  t_label_stroke_merge = "Merge selected clusters into one stroke",
  t_label_stroke_padding = "Stroke padding:",
  t_label_stroke_smoothness = "Stroke smoothness:",
  t_label_stroke_width = "Stroke width:",
  t_label_plot_title = "Plot Title:",
  t_label_units = "Units:",
  t_label_width = "Width:",
  t_text_click_plot_image_zoom = "Click the plot image to zoom in.",
  t_text_code_note_1 = "The generated script includes a workspace import line: bundle <- readRDS('PATH/TO/workspace_bundle.rds').",
  t_text_code_note_2 = "Each configurable parameter line includes an inline comment so users know what to edit.",
  t_text_code_note_3 = "This script is pipeline-independent (Seurat + ggplot2 + workspace object only, no source() helpers).",
  t_text_code_note_4 = "Add custom layers/theme changes under '# 8) Add extra ggplot layers below'.",
  t_text_select_dataset_use_controls_below_customize = "Select a dataset and use the controls below to customize the appearance of the UMAP plot for publication.",
  t_text_umap_palette_note = "Preset palettes still apply immediately. Applying the popup switches the page to Custom Curve.",
  t_text_umap_palette_subtitle = "Current effective palette for the active grouping.",
  t_title_color_customization = "Color Customization",
  t_title_custom_r_code = "Customize in R",
  t_title_download_plot = "Download Plot",
  t_title_plot_controls = "Plot Controls",
  t_title_plot_preview = "Plot Preview",
  t_title_shared_plot_style = "Shared Plot Style",
  t_title_stroke_customization = "Cluster Stroke",
  t_title_text_legend = "Text & Legend",
  t_title_umap_curve_popup = "UMAP Palette",
  t_title_umap_palette_card = "Cluster palette",
  t_title_umap_plot_customization = "UMAP Plot Customization",
  t_title_umap_shared_settings = "Shared Plot Settings"
)

library(scales)
source("interface/figures/color_palettes.R")

figure_umap_ui <- fluidPage(
  tags$head(
    figure_busy_spinner_assets,
    if (is.function(get0("wl_pdf_modal_assets", mode = "function", ifnotfound = NULL))) wl_pdf_modal_assets() else NULL
  ),
  div(
    class = "page-header",
    h2(icon("area-chart"), " ", FIGURE_UMAP_UI_TEXT$t_title_umap_plot_customization),
    p(FIGURE_UMAP_UI_TEXT$t_text_select_dataset_use_controls_below_customize)
  ),
  hr(),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      class = "plotting-left-panel",
      style = "padding-top:0;",
      div(
        class = "wl-side",
        h4(FIGURE_UMAP_UI_TEXT$t_title_plot_controls),

        selectInput("figure_umap_dataset_select", FIGURE_UMAP_UI_TEXT$t_label_1_select_dataset, choices = NULL),
        selectInput("figure_umap_colorby_select", FIGURE_UMAP_UI_TEXT$t_label_2_color_points, choices = NULL),
        selectInput("figure_umap_column_split", FIGURE_UMAP_UI_TEXT$t_label_3_column_split, choices = c("None" = "__none__")),
        selectInput("figure_umap_row_split", FIGURE_UMAP_UI_TEXT$t_label_4_row_split, choices = c("None" = "__none__")),

        hr(),
        h5(FIGURE_UMAP_UI_TEXT$t_title_shared_plot_style),
        actionButton("figure_umap_open_shared_settings", FIGURE_UMAP_UI_TEXT$t_btn_shared_plot_settings, class = "btn btn-default"),

        hr(),
        h5(FIGURE_UMAP_UI_TEXT$t_title_text_legend),
        textInput("figure_umap_title_text", FIGURE_UMAP_UI_TEXT$t_label_plot_title, value = "UMAP Projection"),
        selectInput(
          "figure_umap_legend_position",
          FIGURE_UMAP_UI_TEXT$t_label_legend_position,
          choices = c("Right" = "right", "Top" = "top", "Bottom" = "bottom", "None" = "none"),
          selected = "right"
        ),
        conditionalPanel(
          condition = "input.figure_umap_legend_position == 'top' || input.figure_umap_legend_position == 'bottom'",
          sliderInput(
            "figure_umap_legend_cols",
            FIGURE_UMAP_UI_TEXT$t_label_legend_columns,
            min = 1,
            max = 8,
            value = 4,
            step = 1
          )
        ),
        checkboxInput("figure_umap_annotate_populations", FIGURE_UMAP_UI_TEXT$t_label_annotate_populations, value = FALSE),
        sliderInput("figure_umap_textsize", FIGURE_UMAP_UI_TEXT$t_label_cluster_label_size, min = 0, max = 10, value = 4, step = 0.5),
        hr(),
        h5(FIGURE_UMAP_UI_TEXT$t_title_stroke_customization),
        checkboxInput("figure_umap_stroke_enable", FIGURE_UMAP_UI_TEXT$t_label_stroke_enable, value = FALSE),
        selectInput("figure_umap_stroke_cluster_col", FIGURE_UMAP_UI_TEXT$t_label_stroke_cluster_column, choices = NULL),
        selectizeInput(
          "figure_umap_stroke_clusters",
          FIGURE_UMAP_UI_TEXT$t_label_stroke_clusters,
          choices = NULL,
          selected = character(0),
          multiple = TRUE,
          options = list(placeholder = "Select one or more clusters")
        ),
        checkboxInput("figure_umap_stroke_merge", FIGURE_UMAP_UI_TEXT$t_label_stroke_merge, value = FALSE),
        sliderInput("figure_umap_stroke_padding", FIGURE_UMAP_UI_TEXT$t_label_stroke_padding, min = 0, max = 0.5, value = 0.08, step = 0.01),
        sliderInput("figure_umap_stroke_smoothness", FIGURE_UMAP_UI_TEXT$t_label_stroke_smoothness, min = 0, max = 6, value = 2, step = 1),
        sliderInput("figure_umap_stroke_dash_frequency", FIGURE_UMAP_UI_TEXT$t_label_stroke_dash_frequency, min = 1, max = 9, value = 5, step = 1),
        sliderInput("figure_umap_stroke_width", FIGURE_UMAP_UI_TEXT$t_label_stroke_width, min = 0.2, max = 4, value = 1.2, step = 0.1),
        textInput("figure_umap_stroke_color", FIGURE_UMAP_UI_TEXT$t_label_stroke_color, value = "#111111"),

        hr(),
        h5(FIGURE_UMAP_UI_TEXT$t_title_color_customization),
        selectInput("figure_umap_palette", FIGURE_UMAP_UI_TEXT$t_label_apply_color_palette, choices = c("Default Seurat")),
        uiOutput("figure_umap_palette_card_ui"),

        hr(),
        h4(FIGURE_UMAP_UI_TEXT$t_title_download_plot),
        wellPanel(
          fluidRow(
            column(6, numericInput("figure_umap_width", FIGURE_UMAP_UI_TEXT$t_label_width, value = 10)),
            column(6, numericInput("figure_umap_height", FIGURE_UMAP_UI_TEXT$t_label_height, value = 11))
          ),
          radioButtons(
            "figure_umap_units",
            FIGURE_UMAP_UI_TEXT$t_label_units,
            choices = c("Inches" = "in", "Centimeters" = "cm"),
            selected = "in",
            inline = TRUE
          )
        ),
        fluidRow(
          column(4, actionButton("figure_umap_apply_preview", FIGURE_UMAP_UI_TEXT$t_btn_apply_preview, class = "btn btn-default")),
          column(4, actionButton("open_umap_pdf_modal", FIGURE_UMAP_UI_TEXT$t_btn_download_pdf, class = "btn btn-default")),
          column(4, downloadButton("download_umap_svg", FIGURE_UMAP_UI_TEXT$t_btn_download_svg))
        )
      )
    ),
    mainPanel(
      width = 8,
      class = "plot_area_card_style",
      style = "padding-top:0;",
      tagList(
        div(
          class = "wl-side",
          h4(FIGURE_UMAP_UI_TEXT$t_title_plot_preview),
          p(em(FIGURE_UMAP_UI_TEXT$t_text_click_plot_image_zoom)),
          div(
            id = "figure_umap_preview_stage",
            class = "figure-preview-stage",
            div(
              id = "figure_umap_preview_frame",
              class = "figure-preview-frame",
              figure_with_busy_spinner(plotOutput("figure_umap_plot", width = "100%", height = "100%"))
            )
          )
        ),
        div(
          style = "margin-top:12px;",
          figure_code_card_ui(
            id = "figure_umap_code_card",
            title = FIGURE_UMAP_UI_TEXT$t_title_custom_r_code,
                    notes = c(
                      FIGURE_UMAP_UI_TEXT$t_text_code_note_1,
                      FIGURE_UMAP_UI_TEXT$t_text_code_note_2,
                      FIGURE_UMAP_UI_TEXT$t_text_code_note_3,
                      FIGURE_UMAP_UI_TEXT$t_text_code_note_4
                    ),
            copy_button_label = FIGURE_UMAP_UI_TEXT$t_btn_copy_code,
            code_label = FIGURE_UMAP_UI_TEXT$t_label_editable_r_code
          )
        )
      )
    )
  )
)

figure_umap_server <- function(input, output, session, shared_data) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  .normalize_preview_px <- function(width_raw, height_raw, units_raw = "in") {
    w <- suppressWarnings(as.numeric(width_raw %||% 10))
    h <- suppressWarnings(as.numeric(height_raw %||% 11))
    if (!is.finite(w) || w <= 0) w <- 10
    if (!is.finite(h) || h <= 0) h <- 11
    units_chr <- as.character(units_raw %||% "in")
    if (identical(units_chr, "cm")) {
      w <- w / 2.54
      h <- h / 2.54
    }
    list(
      width_px = as.integer(max(320, round(w * 96))),
      height_px = as.integer(max(240, round(h * 96)))
    )
  }
  umap_preview_dims <- reactiveVal(.normalize_preview_px(10, 11, "in"))
  palette_choices <- c("Custom Curve", "Default Seurat", names(all_palettes))

  umap_custom_palette <- reactiveVal(NULL)
  umap_curve_picker <- curve_color_picker_server("umap_curve_picker", reset_trigger = reactive(input$figure_umap_curve_reset))
  shared_plot_settings <- figure_shared_plot_settings(session)
  dataset_select_signature <- reactiveVal("")
  colorby_select_signature <- reactiveVal("")
  palette_select_signature <- reactiveVal("")
  column_split_select_signature <- reactiveVal("")
  row_split_select_signature <- reactiveVal("")
  stroke_column_select_signature <- reactiveVal("")
  stroke_clusters_select_signature <- reactiveVal("")
  dataset_choices <- reactive({
    names(shared_data$all_seurat_objects %||% list())
  })
  figure_bind_shared_settings_inputs(input, shared_plot_settings, prefix = "figure_umap_shared")

  selected_dataset_name <- reactive({
    figure_preferred_object_name(
      registry = shared_data$all_seurat_objects %||% list(),
      current_selection = input$figure_umap_dataset_select %||% "",
      active_name = shared_data$active_object_name %||% "",
      required_reductions = "umap"
    )
  })

  active_object <- reactive({
    selected_name <- selected_dataset_name()
    req(nzchar(selected_name))
    shared_data$all_seurat_objects[[selected_name]]
  })

  active_seurat_object <- reactive({
    obj <- figure_extract_seurat_object(active_object())
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
    shiny::freezeReactiveValue(input, "figure_umap_dataset_select")
    updateSelectInput(session, "figure_umap_dataset_select", choices = object_choices, selected = selected_name)
  })

  observe({
    req(identical(input$main_navbar %||% "", "figure_studio_umap"))
    selected_name <- selected_dataset_name()
    req(nzchar(selected_name))
    if (!identical(shared_data$active_object_name %||% "", selected_name)) {
      shared_data$active_object_name <- selected_name
    }
  })

  observe({
    selected_palette <- input$figure_umap_palette %||% "Default Seurat"
    if (!selected_palette %in% palette_choices) selected_palette <- "Default Seurat"
    if (!figure_select_input_needs_update(palette_select_signature(), palette_choices, selected_palette)) {
      return(invisible(NULL))
    }
    palette_select_signature(figure_select_input_signature(palette_choices, selected_palette))
    updateSelectInput(session, "figure_umap_palette", choices = palette_choices, selected = selected_palette)
  })

  selected_colorby <- reactive({
    obj <- active_seurat_object()
    color_choices <- figure_meta_columns_for_color(obj@meta.data)
    figure_pick_selected_choice(
      color_choices,
      preferred = input$figure_umap_colorby_select %||% if ("seurat_clusters" %in% color_choices) "seurat_clusters" else NULL
    )
  })

  observe({
    obj <- active_seurat_object()
    req(obj)
    color_choices <- figure_meta_columns_for_color(obj@meta.data)
    selected_choice <- selected_colorby()
    if (!figure_select_input_needs_update(colorby_select_signature(), color_choices, selected_choice)) {
      return(invisible(NULL))
    }
    colorby_select_signature(figure_select_input_signature(color_choices, selected_choice))
    shiny::freezeReactiveValue(input, "figure_umap_colorby_select")
    updateSelectInput(
      session,
      "figure_umap_colorby_select",
      choices = color_choices,
      selected = selected_choice %||% character(0)
    )
  })

  stroke_cluster_column <- reactive({
    obj <- active_seurat_object()
    req(obj)
    choices <- figure_meta_columns_for_color(obj@meta.data)
    figure_pick_selected_choice(
      choices,
      preferred = input$figure_umap_stroke_cluster_col %||% if ("seurat_clusters" %in% choices) "seurat_clusters" else NULL
    )
  })

  observe({
    obj <- active_seurat_object()
    req(obj)
    stroke_choices <- figure_meta_columns_for_color(obj@meta.data)
    selected_stroke_col <- stroke_cluster_column()
    if (!figure_select_input_needs_update(stroke_column_select_signature(), stroke_choices, selected_stroke_col)) {
      return(invisible(NULL))
    }
    stroke_column_select_signature(figure_select_input_signature(stroke_choices, selected_stroke_col))
    shiny::freezeReactiveValue(input, "figure_umap_stroke_cluster_col")
    updateSelectInput(
      session,
      "figure_umap_stroke_cluster_col",
      choices = stroke_choices,
      selected = selected_stroke_col %||% character(0)
    )
  })

  observe({
    obj <- active_seurat_object()
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
    selected_clusters <- as.character(input$figure_umap_stroke_clusters %||% character(0))
    selected_clusters <- intersect(selected_clusters, stroke_levels)
    shiny::freezeReactiveValue(input, "figure_umap_stroke_clusters")
    updateSelectizeInput(
      session,
      "figure_umap_stroke_clusters",
      choices = stroke_levels,
      selected = selected_clusters,
      server = TRUE
    )
  })

  observe({
    obj <- active_seurat_object()
    req(obj)
    column_choices <- figure_split_choices(obj@meta.data)
    selected_column <- input$figure_umap_column_split %||% "__none__"
    if (!selected_column %in% unname(column_choices)) selected_column <- "__none__"
    if (!figure_select_input_needs_update(column_split_select_signature(), unname(column_choices), selected_column)) {
      return(invisible(NULL))
    }
    column_split_select_signature(figure_select_input_signature(unname(column_choices), selected_column))
    shiny::freezeReactiveValue(input, "figure_umap_column_split")
    updateSelectInput(
      session,
      "figure_umap_column_split",
      choices = column_choices,
      selected = selected_column
    )
  })

  observe({
    obj <- active_seurat_object()
    req(obj)
    selected_column <- figure_normalize_split_value(input$figure_umap_column_split)
    row_choices <- figure_split_choices(obj@meta.data, exclude = selected_column %||% character(0))
    selected_row <- input$figure_umap_row_split %||% "__none__"
    if (!selected_row %in% unname(row_choices)) selected_row <- "__none__"
    if (!figure_select_input_needs_update(row_split_select_signature(), unname(row_choices), selected_row)) {
      return(invisible(NULL))
    }
    row_split_select_signature(figure_select_input_signature(unname(row_choices), selected_row))
    shiny::freezeReactiveValue(input, "figure_umap_row_split")
    updateSelectInput(
      session,
      "figure_umap_row_split",
      choices = row_choices,
      selected = selected_row
    )
  })

  umap_color_levels <- reactive({
    obj <- active_seurat_object()
    color_by_var <- selected_colorby()
    validate(need(!is.null(color_by_var) && nzchar(color_by_var), "No metadata column available for Color Points By."))
    validate(need(color_by_var %in% colnames(obj@meta.data), paste("Selected metadata column not found:", color_by_var)))
    figure_color_levels_from_vector(obj@meta.data[[color_by_var]], column_name = color_by_var)
  })

  umap_default_palette <- reactive({
    obj <- active_seurat_object()
    levels <- umap_color_levels()
    req(levels)
    color_by_var <- selected_colorby()
    figure_resolve_metadata_palette(
      sobj = obj,
      reduction_name = "umap",
      color_col = color_by_var %||% "",
      label_values = as.character(obj@meta.data[[color_by_var %||% ""]] %||% character(0)),
      levels_vec = levels
    )
  })

  umap_effective_palette <- reactive({
    levels <- umap_color_levels()
    defaults <- umap_default_palette()
    resolved <- figure_resolve_discrete_palette(
      palette_name = input$figure_umap_palette,
      level_count = length(levels),
      palette_map = all_palettes,
      custom_palette = umap_custom_palette(),
      default_palette = defaults
    )
    resolved %||% defaults
  })

  # Sync UMAP Studio palette changes back to Seurat metadata colors
  observe({
    req(identical(input$main_navbar %||% "", "figure_studio_umap"))
    
    obj <- active_seurat_object()
    req(obj)
    color_by_var <- selected_colorby()
    req(color_by_var)
    levels <- umap_color_levels()
    req(levels)
    pal <- umap_effective_palette()
    req(pal)
    
    misc <- tryCatch(obj@misc, error = function(e) list())
    if (!is.list(misc)) misc <- list()
    stored <- tryCatch(misc$metadata_level_colors[[color_by_var]], error = function(e) NULL)
    
    pal_list <- as.list(pal)
    
    needs_update <- FALSE
    if (!is.list(stored)) {
      # Do not overwrite empty metadata colors unless a custom palette or customized override is chosen
      if (!identical(input$figure_umap_palette, "Default Seurat") || !is.null(umap_custom_palette())) {
        needs_update <- TRUE
      }
    } else {
      for (nm in names(pal_list)) {
        if (!identical(stored[[nm]], pal_list[[nm]])) {
          needs_update <- TRUE
          break
        }
      }
    }
    
    if (needs_update) {
      if (!is.list(misc$metadata_level_colors)) {
        misc$metadata_level_colors <- list()
      }
      misc$metadata_level_colors[[color_by_var]] <- pal_list
      obj@misc <- misc
      
      selected_name <- selected_dataset_name()
      if (nzchar(selected_name)) {
        entry <- shared_data$all_seurat_objects[[selected_name]]
        if (is.list(entry)) {
          entry$obj <- obj
          shared_data$all_seurat_objects[[selected_name]] <- entry
        }
      }
    }
  })

  output$figure_umap_palette_card_ui <- renderUI({
    figure_color_card_ui(
      title = FIGURE_UMAP_UI_TEXT$t_title_umap_palette_card,
      subtitle = FIGURE_UMAP_UI_TEXT$t_text_umap_palette_subtitle,
      swatch_ui = figure_palette_swatches_ui(umap_effective_palette()),
      button_id = "open_umap_curve_popup",
      button_label = FIGURE_UMAP_UI_TEXT$t_btn_open_curve_picker,
      note = FIGURE_UMAP_UI_TEXT$t_text_umap_palette_note
    )
  })

  observeEvent(input$open_umap_curve_popup, {
    fallback_seed_hex <- {
      defaults <- umap_default_palette()
      if (length(defaults)) defaults[[1]] else "#3B82F6"
    }
    seed <- figure_palette_seed(
      colors = umap_effective_palette(),
      fallback = fallback_seed_hex
    )
    showModal(figure_dark_modal_dialog(
      title = FIGURE_UMAP_UI_TEXT$t_title_umap_curve_popup,
      size = "l",
      easyClose = TRUE,
      footer = figure_picker_modal_footer(
        reset_id = "figure_umap_curve_reset",
        apply_id = "figure_umap_curve_apply",
        apply_label = FIGURE_UMAP_UI_TEXT$t_btn_apply_palette
      ),
      figure_curve_palette_modal_body(
        picker_id = "umap_curve_picker",
        initial_hex = seed$initial_hex,
        palette_n = seed$palette_n,
        interpolation = "hsl",
        label = FIGURE_UMAP_UI_TEXT$t_label_curve_palette
      )
    ))
  }, ignoreInit = TRUE)

  observeEvent(input$figure_umap_curve_apply, {
    committed_palette <- figure_palette_from_payload(
      payload = umap_curve_picker(),
      fallback = umap_effective_palette()
    )
    umap_custom_palette(committed_palette)
    updateSelectInput(session, "figure_umap_palette", selected = "Custom Curve")
    removeModal()
  }, ignoreInit = TRUE)

  observeEvent(input$figure_umap_open_shared_settings, {
    showModal(figure_dark_modal_dialog(
      title = FIGURE_UMAP_UI_TEXT$t_title_umap_shared_settings,
      size = "l",
      easyClose = TRUE,
      footer = shiny::modalButton("Close"),
      figure_shared_settings_modal_body(
        prefix = "figure_umap_shared",
        settings_values = figure_shared_plot_settings_values(shared_plot_settings)
      )
    ))
  }, ignoreInit = TRUE)

  custom_umap_plot <- reactive({
    req(
      input$figure_umap_textsize,
      input$figure_umap_title_text,
      input$figure_umap_palette
    )

    obj <- active_seurat_object()
    shared_settings <- figure_shared_plot_settings_values(shared_plot_settings, track_reactive = TRUE)
    color_by_var <- selected_colorby()
    validate(need(!is.null(color_by_var) && nzchar(color_by_var), "No metadata column available for Color Points By."))
    validate(need(color_by_var %in% colnames(obj@meta.data), paste("Selected metadata column not found:", color_by_var)))
    validate(need("umap" %in% figure_entry_reduction_names(active_object()), "Selected dataset has no UMAP reduction. Choose an integrated or processed object with UMAP."))

    colors_to_use <- if (identical(input$figure_umap_palette, "Default Seurat")) NULL else umap_effective_palette()
    split_vars <- figure_normalize_split_vars(
      column_split = input$figure_umap_column_split,
      row_split = input$figure_umap_row_split
    )
    figure_build_discrete_embedding_plot(
      sobj = obj,
      reduction_name = "umap",
      color_by = color_by_var,
      palette_values = colors_to_use,
      column_split = split_vars$column_split,
      row_split = split_vars$row_split,
      dot_size = shared_settings$point_size,
      alpha = shared_settings$point_alpha,
      title = input$figure_umap_title_text,
      x_label = shared_settings$x_label,
      y_label = shared_settings$y_label,
      theme_choice = shared_settings$plot_theme,
      point_shape = shared_settings$point_shape,
      point_stroke = shared_settings$point_stroke,
      color_map = shared_settings$color_map,
      stroke_enabled = isTRUE(input$figure_umap_stroke_enable),
      stroke_column = stroke_cluster_column(),
      stroke_selected_values = input$figure_umap_stroke_clusters %||% character(0),
      stroke_merge = isTRUE(input$figure_umap_stroke_merge),
      stroke_padding = input$figure_umap_stroke_padding,
      stroke_smoothness = input$figure_umap_stroke_smoothness,
      stroke_width = input$figure_umap_stroke_width,
      stroke_dash_frequency = input$figure_umap_stroke_dash_frequency,
      stroke_color = input$figure_umap_stroke_color,
      label_clusters = isTRUE(input$figure_umap_annotate_populations),
      label_size = figure_effective_label_size(input$figure_umap_annotate_populations, input$figure_umap_textsize),
      legend_position = input$figure_umap_legend_position,
      legend_columns = input$figure_umap_legend_cols,
      legend_text_size = shared_settings$legend_text_size,
      axis_text_size = shared_settings$axis_text_size,
      axis_title_size = shared_settings$axis_title_size,
      plot_title_size = shared_settings$title_size
    )
  })

  generated_plot_code <- reactive({
    shared_settings <- figure_shared_plot_settings_values(shared_plot_settings, track_reactive = TRUE)
    split_vars <- figure_normalize_split_vars(
      column_split = input$figure_umap_column_split,
      row_split = input$figure_umap_row_split
    )
    colors_to_use <- if (identical(input$figure_umap_palette, "Default Seurat")) NULL else umap_effective_palette()
    figure_generate_umap_script(list(
      object_name = selected_dataset_name(),
      reduction_name = "umap",
      color_by = selected_colorby(),
      palette_values = colors_to_use,
      column_split = split_vars$column_split,
      row_split = split_vars$row_split,
      point_size = shared_settings$point_size,
      point_alpha = shared_settings$point_alpha,
      title = input$figure_umap_title_text,
      x_label = shared_settings$x_label,
      y_label = shared_settings$y_label,
      theme_choice = shared_settings$plot_theme,
      point_shape = shared_settings$point_shape,
      point_stroke = shared_settings$point_stroke,
      color_map = shared_settings$color_map,
      stroke_enabled = isTRUE(input$figure_umap_stroke_enable),
      stroke_column = stroke_cluster_column(),
      stroke_selected_values = input$figure_umap_stroke_clusters %||% character(0),
      stroke_merge = isTRUE(input$figure_umap_stroke_merge),
      stroke_padding = input$figure_umap_stroke_padding,
      stroke_smoothness = input$figure_umap_stroke_smoothness,
      stroke_width = input$figure_umap_stroke_width,
      stroke_dash_frequency = input$figure_umap_stroke_dash_frequency,
      stroke_color = input$figure_umap_stroke_color,
      label_clusters = isTRUE(input$figure_umap_annotate_populations),
      label_size = figure_effective_label_size(input$figure_umap_annotate_populations, input$figure_umap_textsize),
      legend_position = input$figure_umap_legend_position,
      legend_columns = input$figure_umap_legend_cols,
      legend_text_size = shared_settings$legend_text_size,
      axis_text_size = shared_settings$axis_text_size,
      axis_title_size = shared_settings$axis_title_size,
      plot_title_size = shared_settings$title_size
    ))
  })
  figure_code_card_server("figure_umap_code_card", code_text_reactive = generated_plot_code)

  output$figure_umap_plot <- renderPlot({
    custom_umap_plot()
  }, width = function() {
    as.integer(umap_preview_dims()$width_px %||% 960L)
  }, height = function() {
    as.integer(umap_preview_dims()$height_px %||% 720L)
  }, res = 96)

  .apply_umap_preview <- function() {
    dims <- .normalize_preview_px(
      width_raw = input$figure_umap_width,
      height_raw = input$figure_umap_height,
      units_raw = input$figure_umap_units
    )
    umap_preview_dims(dims)
    session$sendCustomMessage("wl_figure_preview_fit", list(
      stage_id = "figure_umap_preview_stage",
      frame_id = "figure_umap_preview_frame",
      width_px = dims$width_px,
      height_px = dims$height_px
    ))
    invisible(dims)
  }

  observeEvent(input$figure_umap_apply_preview, {
    .apply_umap_preview()
  }, ignoreInit = TRUE)

  observeEvent(input$main_navbar, {
    req(identical(input$main_navbar %||% "", "figure_studio_umap"))
    .apply_umap_preview()
  }, ignoreInit = FALSE)

  .figure_umap_pdf_bundle <- function(kind, width_px = NULL, height_px = NULL) {
    req(identical(kind, "umap_pdf"))
    p <- custom_umap_plot()
    req(p)
    width_raw <- suppressWarnings(as.numeric(input$figure_umap_width %||% 10))
    height_raw <- suppressWarnings(as.numeric(input$figure_umap_height %||% 11))
    if (!is.finite(width_raw) || width_raw <= 0) width_raw <- 10
    if (!is.finite(height_raw) || height_raw <= 0) height_raw <- 11
    units_raw <- as.character(input$figure_umap_units %||% "in")
    width_in <- if (identical(units_raw, "cm")) width_raw / 2.54 else width_raw
    height_in <- if (identical(units_raw, "cm")) height_raw / 2.54 else height_raw
    if (is.finite(width_px) && width_px > 0) width_in <- width_px / 96
    if (is.finite(height_px) && height_px > 0) height_in <- height_px / 96
    list(
      plot = p,
      width_px = as.integer(max(320, round(width_in * 96))),
      height_px = as.integer(max(240, round(height_in * 96))),
      filename_prefix = paste0(selected_dataset_name() %||% "dataset", "_UMAP_")
    )
  }

  .pdf_modal_server <- get0("wl_pdf_modal_server", mode = "function", ifnotfound = NULL)
  if (is.null(.pdf_modal_server)) stop("Shared PDF modal helper is unavailable. Please source interface/shared/shared_pdf_export_modal.R first.")
  .figure_umap_pdf_modal <- .pdf_modal_server(
    input = input,
    output = output,
    session = session,
    id_prefix = "figure_umap_pdf",
    build_bundle = .figure_umap_pdf_bundle,
    download_btn_label = FIGURE_UMAP_UI_TEXT$t_btn_download_pdf,
    default_modal_title = "PDF export settings: UMAP"
  )

  observeEvent(input$open_umap_pdf_modal, {
    .figure_umap_pdf_modal$open("umap_pdf", title_txt = "PDF export settings: UMAP")
  }, ignoreInit = TRUE)

  output$download_umap_svg <- downloadHandler(
    filename = function() {
      paste0(selected_dataset_name() %||% "dataset", "_UMAP.svg")
    },
    content = function(file) {
      ggsave(
        filename = file,
        plot = custom_umap_plot(),
        device = "svg",
        width = input$figure_umap_width,
        height = input$figure_umap_height,
        units = input$figure_umap_units
      )
    }
  )
}
