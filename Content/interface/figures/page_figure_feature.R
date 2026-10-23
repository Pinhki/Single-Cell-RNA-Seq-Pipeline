# R/page_figure_feature.R
# Feature Plot shares the gene-catalog and object-transition rules in
# docs/agents/interface/ANALYSIS_STATE_SYNC_CONTRACT.md.
FIGURE_FEATURE_UI_TEXT <- list(
  t_btn_apply_preview = "Apply Preview",
  t_btn_apply_colors = "Apply Colors",
  t_btn_copy_code = "Copy Code",
  t_btn_download_pdf = "Download PDF",
  t_btn_open_dot_picker = "Open Dot Picker",
  t_btn_shared_plot_settings = "Shared Plot Settings",
  t_btn_save_program_score = "Save score to metadata",
  t_choice_mode_single = "Single Gene",
  t_choice_mode_rgb = "RGB Gene Expression",
  t_choice_mode_program = "Gene Program",
  t_choice_rgb_dark = "Dark confocal",
  t_choice_rgb_light = "Light publication",
  t_choice_program_panels = "Individual gene panels",
  t_choice_program_score = "Combined program score",
  t_choice_score_add_module = "Seurat AddModuleScore",
  t_choice_score_mean = "Mean normalized expression",
  t_choice_none = "None",
  t_label_1_select_dataset = "1. Select Dataset:",
  t_label_2_select_assay = "2. Select Assay:",
  t_label_3_select_gene = "3. Select Gene:",
  t_label_plot_mode = "3. Plot mode:",
  t_label_rgb_red_gene = "Red gene:",
  t_label_rgb_green_gene = "Green gene:",
  t_label_rgb_blue_gene = "Blue gene:",
  t_label_rgb_style = "RGB style:",
  t_label_program_genes = "Program genes:",
  t_label_program_name = "Program name:",
  t_label_program_output = "Program output:",
  t_label_program_score_method = "Score method:",
  t_label_program_score_column = "Metadata column name:",
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
  t_text_program_gene_status_empty = "Select genes for Gene Program.",
  t_placeholder_gene_search = "Type to search gene",
  t_placeholder_gene_add = "Type to add genes",
  t_placeholder_cluster_select = "Select one or more clusters",
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
        radioButtons(
          "figure_feature_mode",
          FIGURE_FEATURE_UI_TEXT$t_label_plot_mode,
          choices = stats::setNames(
            c("single", "rgb", "program"),
            c(FIGURE_FEATURE_UI_TEXT$t_choice_mode_single, FIGURE_FEATURE_UI_TEXT$t_choice_mode_rgb, FIGURE_FEATURE_UI_TEXT$t_choice_mode_program)
          ),
          selected = "single"
        ),
        conditionalPanel(
          condition = "input.figure_feature_mode == 'single'",
          wl_gene_selectize_input(
            "figure_feature_gene_select",
            FIGURE_FEATURE_UI_TEXT$t_label_3_select_gene,
            placeholder = FIGURE_FEATURE_UI_TEXT$t_placeholder_gene_search,
            min_chars = 0L,
            open_on_focus = TRUE,
            preload = TRUE
          )
        ),
        conditionalPanel(
          condition = "input.figure_feature_mode == 'rgb'",
          wl_gene_selectize_input("figure_feature_rgb_red", FIGURE_FEATURE_UI_TEXT$t_label_rgb_red_gene, placeholder = FIGURE_FEATURE_UI_TEXT$t_placeholder_gene_search, min_chars = 0L, open_on_focus = TRUE, preload = TRUE),
          wl_gene_selectize_input("figure_feature_rgb_green", FIGURE_FEATURE_UI_TEXT$t_label_rgb_green_gene, placeholder = FIGURE_FEATURE_UI_TEXT$t_placeholder_gene_search, min_chars = 0L, open_on_focus = TRUE, preload = TRUE),
          wl_gene_selectize_input("figure_feature_rgb_blue", FIGURE_FEATURE_UI_TEXT$t_label_rgb_blue_gene, placeholder = FIGURE_FEATURE_UI_TEXT$t_placeholder_gene_search, min_chars = 0L, open_on_focus = TRUE, preload = TRUE),
          selectInput(
            "figure_feature_rgb_style",
            FIGURE_FEATURE_UI_TEXT$t_label_rgb_style,
            choices = stats::setNames(c("dark", "light"), c(FIGURE_FEATURE_UI_TEXT$t_choice_rgb_dark, FIGURE_FEATURE_UI_TEXT$t_choice_rgb_light)),
            selected = "light"
          )
        ),
        conditionalPanel(
          condition = "input.figure_feature_mode == 'program'",
          textInput("figure_feature_program_name", FIGURE_FEATURE_UI_TEXT$t_label_program_name, value = "Gene Program"),
          wl_gene_selectize_input(
            "figure_feature_program_genes",
            FIGURE_FEATURE_UI_TEXT$t_label_program_genes,
            multiple = TRUE,
            placeholder = FIGURE_FEATURE_UI_TEXT$t_placeholder_gene_add,
            min_chars = 0L,
            open_on_focus = TRUE,
            preload = TRUE
          ),
          selectInput(
            "figure_feature_program_output",
            FIGURE_FEATURE_UI_TEXT$t_label_program_output,
            choices = stats::setNames(c("panels", "score"), c(FIGURE_FEATURE_UI_TEXT$t_choice_program_panels, FIGURE_FEATURE_UI_TEXT$t_choice_program_score)),
            selected = "panels"
          ),
          conditionalPanel(
            condition = "input.figure_feature_program_output == 'score'",
            selectInput(
              "figure_feature_program_method",
              FIGURE_FEATURE_UI_TEXT$t_label_program_score_method,
              choices = stats::setNames(c("add_module_score", "mean_expression"), c(FIGURE_FEATURE_UI_TEXT$t_choice_score_add_module, FIGURE_FEATURE_UI_TEXT$t_choice_score_mean)),
              selected = "add_module_score"
            ),
            textInput("figure_feature_program_score_column", FIGURE_FEATURE_UI_TEXT$t_label_program_score_column, value = "gene_program_score"),
            actionButton("figure_feature_save_program_score", FIGURE_FEATURE_UI_TEXT$t_btn_save_program_score, class = "btn btn-default btn-sm")
          ),
          uiOutput("figure_feature_program_gene_status")
        ),
        selectInput("figure_feature_column_split", FIGURE_FEATURE_UI_TEXT$t_label_4_column_split, choices = stats::setNames("__none__", FIGURE_FEATURE_UI_TEXT$t_choice_none)),
        selectInput("figure_feature_row_split", FIGURE_FEATURE_UI_TEXT$t_label_5_row_split, choices = stats::setNames("__none__", FIGURE_FEATURE_UI_TEXT$t_choice_none)),

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
          options = list(placeholder = FIGURE_FEATURE_UI_TEXT$t_placeholder_cluster_select)
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
    for (requested in c("umap", "tsne", "pca")) {
      resolved <- figure_resolve_reduction_name(obj, requested)
      if (nzchar(resolved)) return(resolved)
    }
    NULL
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
    # Mode is a real binding lifecycle dependency. Conditional single/RGB/
    # program controls can mount after this observer first runs; isolating mode
    # leaves newly mounted controls with only their initial selected value,
    # making dropdowns appear empty until assay changes.
    mode_now <- as.character(input$figure_feature_mode %||% "single")[[1]]
    assay_obj <- tryCatch(obj[[input$figure_feature_assay_select]], error = function(e) NULL)
    gene_choices <- tryCatch(Seurat::Features(assay_obj), error = function(e) character(0))
    gene_choices <- as.character(gene_choices %||% character(0))
    gene_choices <- gene_choices[!is.na(gene_choices) & nzchar(gene_choices)]
    if (!length(gene_choices)) {
      gene_choices <- tryCatch(rownames(assay_obj), error = function(e) character(0))
      gene_choices <- as.character(gene_choices %||% character(0))
      gene_choices <- gene_choices[!is.na(gene_choices) & nzchar(gene_choices)]
    }
    message(sprintf(
      "[FEATURE_GENE_DBG] assay=%s mode=%s genes=%d",
      as.character(input$figure_feature_assay_select %||% ""),
      mode_now,
      length(gene_choices)
    ))
    .selected_genes <- function(input_id) {
      selected <- isolate(as.character(input[[input_id]] %||% character(0)))
      intersect(selected, gene_choices)
    }
    # Keep feature catalogs in Selectize's server-side store. Serializing the
    # complete catalog for every mode change can freeze the browser and makes
    # RGB/program controls compete with one another during rebinds.
    wl_update_gene_selectize(session, "figure_feature_gene_select", gene_choices, selected = .selected_genes("figure_feature_gene_select"), server = TRUE)
    wl_update_gene_selectize(session, "figure_feature_rgb_red", gene_choices, selected = .selected_genes("figure_feature_rgb_red"), server = TRUE)
    wl_update_gene_selectize(session, "figure_feature_rgb_green", gene_choices, selected = .selected_genes("figure_feature_rgb_green"), server = TRUE)
    wl_update_gene_selectize(session, "figure_feature_rgb_blue", gene_choices, selected = .selected_genes("figure_feature_rgb_blue"), server = TRUE)
    wl_update_gene_selectize(session, "figure_feature_program_genes", gene_choices, selected = .selected_genes("figure_feature_program_genes"), server = TRUE)
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

  output$figure_feature_program_gene_status <- renderUI({
    obj <- active_object()
    req(obj)
    assay_to_use <- input$figure_feature_assay_select %||% Seurat::DefaultAssay(obj)
    genes <- unique(as.character(input$figure_feature_program_genes %||% character(0)))
    genes <- genes[nzchar(genes)]
    if (!length(genes)) return(tags$small(class = "text-muted", FIGURE_FEATURE_UI_TEXT$t_text_program_gene_status_empty))
    available <- rownames(obj[[assay_to_use]])
    missing <- setdiff(genes, available)
    if (length(missing)) {
      return(tags$small(class = "text-danger", paste("Missing genes:", paste(missing, collapse = ", "))))
    }
    tags$small(class = "text-success", sprintf("%d genes available.", length(genes)))
  })

  feature_plot_result <- reactiveVal(list(plot = NULL, score = NULL, error = "Select plot inputs."))

  .build_current_feature_plot <- reactive({
    obj <- active_object()
    req(obj)
    mode <- input$figure_feature_mode %||% "single"
    assay_to_use <- input$figure_feature_assay_select %||% Seurat::DefaultAssay(obj)
    gradient_colors <- feature_gradient_state()
    shared_settings <- figure_shared_plot_settings_values(shared_plot_settings, track_reactive = TRUE)
    red_to_use <- .pick_reduction(obj)
    validate(need(!is.null(red_to_use), "No dimensional reduction found. Run PCA/UMAP first."))
    split_vars <- figure_normalize_split_vars(
      column_split = input$figure_feature_column_split,
      row_split = input$figure_feature_row_split
    )

    .single_feature_plot <- function(feature_name, title = input$figure_feature_title_text, quantile_limits = FALSE) {
      p <- figure_build_feature_embedding_plot(
        sobj = obj,
        reduction_name = red_to_use,
        assay_name = assay_to_use,
        feature_name = feature_name,
        low_color = gradient_colors[["low"]],
        high_color = gradient_colors[["high"]],
        column_split = split_vars$column_split,
        row_split = split_vars$row_split,
        dot_size = shared_settings$point_size,
        alpha = shared_settings$point_alpha,
        title = title,
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
      if (isTRUE(quantile_limits)) {
        expr <- core_feature_get_assay_data(obj, assay = assay_to_use, layer = "data")
        vals <- suppressWarnings(as.numeric(expr[feature_name, , drop = TRUE]))
        limits <- suppressWarnings(stats::quantile(vals, c(0.05, 0.95), na.rm = TRUE, names = FALSE))
        if (all(is.finite(limits)) && limits[[1]] < limits[[2]]) {
          mapping <- figure_point_mapping(shared_settings$point_shape, shared_settings$point_stroke, shared_settings$color_map)
          if (isTRUE(mapping$use_fill)) {
            p <- suppressMessages(p + ggplot2::scale_fill_gradient(low = gradient_colors[["low"]], high = gradient_colors[["high"]], limits = limits, oob = scales::squish, name = feature_name))
          } else {
            p <- suppressMessages(p + ggplot2::scale_color_gradient(low = gradient_colors[["low"]], high = gradient_colors[["high"]], limits = limits, oob = scales::squish, name = feature_name))
          }
        }
      }
      p
    }

    if (identical(mode, "single")) {
      gene_to_plot <- as.character(input$figure_feature_gene_select %||% "")[[1]]
      validate(need(nzchar(gene_to_plot), "Select a gene to plot."))
      return(list(plot = .single_feature_plot(gene_to_plot), score = NULL))
    }

    if (identical(mode, "rgb")) {
      rgb_genes <- c(
        input$figure_feature_rgb_red %||% "",
        input$figure_feature_rgb_green %||% "",
        input$figure_feature_rgb_blue %||% ""
      )
      rgb_df <- core_feature_rgb_data(
        obj,
        genes = rgb_genes,
        assay = assay_to_use,
        reduction = red_to_use,
        column_split = split_vars$column_split %||% "__none__",
        row_split = split_vars$row_split %||% "__none__",
        upper_quantile = 0.99,
        seed = 42L
      )
      is_dark <- identical(input$figure_feature_rgb_style %||% "light", "dark")
      background <- if (is_dark) "#000000" else "#FFFFFF"
      text_color <- if (is_dark) "#FFFFFF" else "#111111"
      title_text <- input$figure_feature_title_text %||% ""
      if (!nzchar(title_text) || identical(title_text, "Feature Plot")) title_text <- "RGB Gene Expression"
      subtitle_text <- paste0("Red: ", rgb_genes[[1]], " | Green: ", rgb_genes[[2]], " | Blue: ", rgb_genes[[3]])
      channel_labels <- c(paste("Red:", rgb_genes[[1]]), paste("Green:", rgb_genes[[2]]), paste("Blue:", rgb_genes[[3]]))
      channel_key <- data.frame(
        Dim_1 = rep(rgb_df$Dim_1[[1]], 3L),
        Dim_2 = rep(rgb_df$Dim_2[[1]], 3L),
        channel = factor(channel_labels, levels = channel_labels)
      )
      p <- ggplot2::ggplot(rgb_df, ggplot2::aes(Dim_1, Dim_2)) +
        ggplot2::geom_point(color = rgb_df$rgb, size = shared_settings$point_size, alpha = shared_settings$point_alpha) +
        ggplot2::geom_point(data = channel_key, ggplot2::aes(Dim_1, Dim_2, color = channel), inherit.aes = FALSE, alpha = 0) +
        ggplot2::scale_color_manual(
          values = stats::setNames(c("#FF0000", "#00C853", "#2979FF"), channel_labels),
          name = "Channels",
          guide = ggplot2::guide_legend(override.aes = list(size = 3, alpha = 1))
        ) +
        ggplot2::coord_fixed() +
        ggplot2::labs(title = title_text, subtitle = subtitle_text, x = shared_settings$x_label, y = shared_settings$y_label)
      if (!is.null(split_vars$row_split)) {
        p <- p + ggplot2::facet_grid(row_group ~ column_group)
      } else if (!is.null(split_vars$column_split)) {
        p <- p + ggplot2::facet_wrap(~column_group)
      }
      p <- p + ggplot2::theme_void() + ggplot2::theme(
        plot.background = ggplot2::element_rect(fill = background, color = NA),
        panel.background = ggplot2::element_rect(fill = background, color = NA),
        text = ggplot2::element_text(color = text_color),
        plot.title = ggplot2::element_text(color = text_color, face = "bold"),
        plot.subtitle = ggplot2::element_text(color = text_color),
        legend.position = "bottom",
        legend.background = ggplot2::element_rect(fill = background, color = NA),
        legend.key = ggplot2::element_rect(fill = background, color = NA),
        legend.text = ggplot2::element_text(color = text_color),
        legend.title = ggplot2::element_text(color = text_color),
        strip.text = ggplot2::element_text(color = text_color, face = "bold"),
        strip.background = ggplot2::element_rect(fill = background, color = text_color)
      )
      return(list(plot = p, score = NULL))
    }

    genes <- unique(as.character(input$figure_feature_program_genes %||% character(0)))
    genes <- genes[nzchar(genes)]
    validate(need(length(genes) > 0, "Select genes for Gene Program."))
    available <- rownames(obj[[assay_to_use]])
    missing <- setdiff(genes, available)
    validate(need(!length(missing), paste("Genes not found:", paste(missing, collapse = ", "))))
    program_name <- trimws(as.character(input$figure_feature_program_name %||% "Gene Program"))
    validate(need(nzchar(program_name), "Enter a program name."))

    if (identical(input$figure_feature_program_output %||% "panels", "panels")) {
      panels <- lapply(genes, function(gene) .single_feature_plot(gene, title = gene, quantile_limits = TRUE))
      p <- patchwork::wrap_plots(panels, ncol = max(1L, ceiling(sqrt(length(panels))))) +
        patchwork::plot_annotation(title = program_name)
      return(list(plot = p, score = NULL))
    }

    score <- core_feature_program_score(
      obj,
      genes = genes,
      assay = assay_to_use,
      method = input$figure_feature_program_method %||% "add_module_score",
      seed = 42L
    )
    emb <- Seurat::Embeddings(obj, reduction = red_to_use)
    cells <- intersect(rownames(emb), names(score))
    validate(need(length(cells) > 0, "Program score and reduction have no matching cells."))
    md <- obj@meta.data
    score_df <- data.frame(
      Dim_1 = emb[cells, 1],
      Dim_2 = emb[cells, 2],
      score = score[cells],
      stringsAsFactors = FALSE
    )
    .split_values <- function(column) {
      if (is.null(column)) return(factor("All cells", levels = "All cells"))
      figure_prepare_split_factor(md[cells, column, drop = TRUE], column_name = column)
    }
    score_df$split_value <- .split_values(split_vars$column_split)
    score_df$split_value_secondary <- .split_values(split_vars$row_split)
    score_df <- score_df[order(score_df$score), , drop = FALSE]
    score_limits <- suppressWarnings(stats::quantile(score_df$score, c(0.05, 0.95), na.rm = TRUE, names = FALSE))
    p <- ggplot2::ggplot(score_df, ggplot2::aes(Dim_1, Dim_2, color = score)) +
      ggplot2::geom_point(size = shared_settings$point_size, alpha = shared_settings$point_alpha) +
      ggplot2::scale_color_gradient(low = gradient_colors[["low"]], high = gradient_colors[["high"]], limits = score_limits, oob = scales::squish, name = program_name) +
      ggplot2::coord_fixed()
    p <- figure_apply_embedding_facets(
      p,
      facet_mode = figure_facet_mode(column_split = split_vars$column_split, row_split = split_vars$row_split)
    )
    p <- figure_apply_plot_theme(
      plot_obj = p,
      theme_choice = shared_settings$plot_theme,
      title = program_name,
      x_label = shared_settings$x_label,
      y_label = shared_settings$y_label,
      legend_text_size = shared_settings$legend_text_size,
      axis_text_size = shared_settings$axis_text_size,
      axis_title_size = shared_settings$axis_title_size,
      plot_title_size = shared_settings$title_size
    )
    list(plot = p, score = score)
  })

  observe({
    result <- tryCatch(
      .build_current_feature_plot(),
      error = function(e) list(plot = NULL, score = NULL, error = conditionMessage(e))
    )
    if (is.null(result$error)) result$error <- ""
    feature_plot_result(result)
  })

  custom_feature_plot <- reactive({
    result <- feature_plot_result()
    validate(need(!nzchar(result$error %||% ""), result$error %||% "Feature plot is unavailable."))
    validate(need(!is.null(result$plot), "Feature plot is unavailable."))
    result$plot
  })

  observeEvent(input$figure_feature_save_program_score, {
    req(identical(input$figure_feature_mode %||% "single", "program"))
    req(identical(input$figure_feature_program_output %||% "panels", "score"))
    result <- feature_plot_result()
    score <- result$score
    validate(need(!is.null(score) && length(score), "Calculate a valid program score before saving."))
    column_name <- trimws(as.character(input$figure_feature_program_score_column %||% ""))
    validate(need(grepl("^[A-Za-z][A-Za-z0-9_.]*$", column_name), "Use a metadata column name that starts with a letter and contains only letters, numbers, periods, or underscores."))

    obj <- active_object()
    validate(need(!(column_name %in% colnames(obj@meta.data)), paste("Metadata column already exists:", column_name)))
    validate(need(all(rownames(obj@meta.data) %in% names(score)), "Program score does not cover all object cells."))
    obj@meta.data[[column_name]] <- as.numeric(score[rownames(obj@meta.data)])

    object_name <- selected_dataset_name()
    registry <- shared_data$all_seurat_objects %||% list()
    entry <- registry[[object_name]]
    if (inherits(entry, "Seurat")) entry <- list(obj = obj) else entry$obj <- obj
    if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
      entry <- wanlab_canonicalize_object_entry(entry)
    }
    registry[[object_name]] <- entry
    shared_data$all_seurat_objects <- registry
    showNotification(paste("Saved program score to metadata column:", column_name), type = "message", duration = 4)
  }, ignoreInit = TRUE)

  generated_plot_code <- reactive({
    shared_settings <- figure_shared_plot_settings_values(shared_plot_settings, track_reactive = TRUE)
    split_vars <- figure_normalize_split_vars(
      column_split = input$figure_feature_column_split,
      row_split = input$figure_feature_row_split
    )
    mode <- input$figure_feature_mode %||% "single"
    genes <- if (identical(mode, "rgb")) {
      c(input$figure_feature_rgb_red %||% "", input$figure_feature_rgb_green %||% "", input$figure_feature_rgb_blue %||% "")
    } else if (identical(mode, "program")) {
      as.character(input$figure_feature_program_genes %||% character(0))
    } else {
      as.character(input$figure_feature_gene_select %||% "")
    }
    analysis_recipe <- list(
      recipe_type = "feature_analysis",
      recipe_version = 1L,
      object_name = selected_dataset_name(),
      mode = mode,
      reduction = .pick_reduction(active_object()),
      assay = input$figure_feature_assay_select,
      genes = genes,
      program_output = input$figure_feature_program_output %||% "panels",
      program_score_method = input$figure_feature_program_method %||% "add_module_score",
      seed = 42L,
      rgb_upper_quantile = 0.99,
      feature_lower_quantile = 0.05,
      feature_upper_quantile = 0.95
    )
    figure_recipe <- list(
      recipe_type = "feature_figure",
      recipe_version = 1L,
      studio = "Feature Plot Studio",
      mode = mode,
      program_name = input$figure_feature_program_name %||% "Gene Program",
      column_split = split_vars$column_split %||% "__none__",
      row_split = split_vars$row_split %||% "__none__",
      rgb_style = input$figure_feature_rgb_style %||% "light",
      low_color = feature_gradient_state()[["low"]],
      high_color = feature_gradient_state()[["high"]],
      point_size = shared_settings$point_size,
      point_alpha = shared_settings$point_alpha,
      title = input$figure_feature_title_text %||% "",
      width_in = suppressWarnings(as.numeric(input$figure_feature_width %||% 7)),
      height_in = suppressWarnings(as.numeric(input$figure_feature_height %||% 7))
    )

    if (identical(mode, "single")) {
      base_code <- figure_generate_feature_script(list(
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
      return(paste(c(figure_recipe_code_lines(analysis_recipe, figure_recipe), base_code), collapse = "\n"))
    }

    common_lines <- c(
      figure_recipe_code_lines(analysis_recipe, figure_recipe),
      "library(Seurat)",
      "library(ggplot2)",
      "library(patchwork)",
      .figure_code_object_lookup_lines(selected_dataset_name()),
      "",
      "assay_name <- analysis_recipe$assay",
      "reduction_name <- analysis_recipe$reduction",
      "genes <- analysis_recipe$genes",
      "get_formals <- names(formals(Seurat::GetAssayData))",
      "get_args <- list(object = sobj, assay = assay_name)",
      "get_args[[if ('layer' %in% get_formals) 'layer' else 'slot']] <- 'data'",
      "data_mat <- do.call(Seurat::GetAssayData, get_args)",
      "missing_genes <- setdiff(genes, rownames(data_mat))",
      "if (length(missing_genes)) stop('Genes not found: ', paste(missing_genes, collapse = ', '))",
      "emb <- Seurat::Embeddings(sobj, reduction = reduction_name)",
      "cells <- intersect(rownames(emb), colnames(data_mat))",
      "md <- sobj@meta.data",
      "clean_group <- function(column, cell_ids) {",
      "  if (identical(column, '__none__')) return(rep('All', length(cell_ids)))",
      "  x <- trimws(as.character(md[cell_ids, column]))",
      "  x[is.na(x) | !nzchar(x)] <- '(NA)'",
      "  x",
      "}",
      "add_facets <- function(p, data) {",
      "  data$column_group <- clean_group(figure_recipe$column_split, data$cell)",
      "  data$row_group <- clean_group(figure_recipe$row_split, data$cell)",
      "  p$data <- data",
      "  if (!identical(figure_recipe$row_split, '__none__')) return(p + facet_grid(row_group ~ column_group))",
      "  if (!identical(figure_recipe$column_split, '__none__')) return(p + facet_wrap(~column_group))",
      "  p",
      "}",
      ""
    )

    if (identical(mode, "rgb")) {
      rgb_lines <- c(
        "if (length(genes) != 3 || anyDuplicated(genes)) stop('Select three different RGB genes.')",
        "values <- as.matrix(data_mat[genes, cells, drop = FALSE])",
        "scale_channel <- function(x) {",
        "  x <- pmax(as.numeric(x), 0)",
        "  upper <- quantile(x, analysis_recipe$rgb_upper_quantile, na.rm = TRUE, names = FALSE)",
        "  if (!is.finite(upper) || upper <= 0) return(rep(0, length(x)))",
        "  pmin(x / upper, 1)",
        "}",
        "red <- scale_channel(values[1, ])",
        "green <- scale_channel(values[2, ])",
        "blue <- scale_channel(values[3, ])",
        "set.seed(analysis_recipe$seed)",
        "df <- data.frame(cell = cells, Dim_1 = emb[cells, 1], Dim_2 = emb[cells, 2], red = red, green = green, blue = blue, tie = runif(length(cells)))",
        "df$signal <- df$red + df$green + df$blue",
        "df$rgb <- rgb(df$red, df$green, df$blue)",
        "df <- df[order(df$signal, df$tie), ]",
        "is_dark <- identical(figure_recipe$rgb_style, 'dark')",
        "background <- if (is_dark) '#000000' else '#FFFFFF'",
        "text_color <- if (is_dark) '#FFFFFF' else '#111111'",
        "plot_title <- if (nzchar(figure_recipe$title) && figure_recipe$title != 'Feature Plot') figure_recipe$title else 'RGB Gene Expression'",
        "p <- ggplot(df, aes(Dim_1, Dim_2)) + geom_point(color = df$rgb, size = figure_recipe$point_size, alpha = figure_recipe$point_alpha) + coord_fixed() +",
        "  labs(title = plot_title, subtitle = paste('Red:', genes[1], '| Green:', genes[2], '| Blue:', genes[3]))",
        "p <- add_facets(p, df) + theme_void() + theme(plot.background = element_rect(fill = background, color = NA), panel.background = element_rect(fill = background, color = NA), text = element_text(color = text_color), strip.text = element_text(color = text_color, face = 'bold'), strip.background = element_rect(fill = background, color = text_color))",
        "print(p)"
      )
      return(paste(c(common_lines, rgb_lines), collapse = "\n"))
    }

    program_lines <- c(
      "program_name <- figure_recipe$program_name",
      "make_feature_df <- function(gene) {",
      "  value <- as.numeric(data_mat[gene, cells])",
      "  data.frame(cell = cells, Dim_1 = emb[cells, 1], Dim_2 = emb[cells, 2], value = value)[order(value), ]",
      "}",
      "if (identical(analysis_recipe$program_output, 'panels')) {",
      "  panels <- lapply(genes, function(gene) {",
      "    df <- make_feature_df(gene)",
      "    limits <- quantile(df$value, c(analysis_recipe$feature_lower_quantile, analysis_recipe$feature_upper_quantile), na.rm = TRUE, names = FALSE)",
      "    p <- ggplot(df, aes(Dim_1, Dim_2, color = value)) + geom_point(size = figure_recipe$point_size, alpha = figure_recipe$point_alpha) +",
      "      scale_color_gradient(low = figure_recipe$low_color, high = figure_recipe$high_color, limits = limits, oob = scales::squish, name = gene) + coord_fixed() + labs(title = gene)",
      "    add_facets(p, df) + theme_classic()",
      "  })",
      "  p <- wrap_plots(panels, ncol = max(1, ceiling(sqrt(length(panels))))) + plot_annotation(title = program_name)",
      "} else {",
      "  if (identical(analysis_recipe$program_score_method, 'mean_expression')) {",
      "    score <- Matrix::colMeans(data_mat[genes, , drop = FALSE])",
      "  } else {",
      "    nbin <- 24L",
      "    ctrl <- min(100L, max(1L, floor((nrow(data_mat) - length(genes)) / (2L * nbin))))",
      "    scored <- Seurat::AddModuleScore(sobj, features = list(genes), assay = assay_name, name = '.wanlab_program_score', nbin = nbin, ctrl = ctrl, seed = analysis_recipe$seed, search = FALSE)",
      "    score_col <- tail(grep('^\\.wanlab_program_score', colnames(scored@meta.data), value = TRUE), 1)",
      "    score <- setNames(scored@meta.data[[score_col]], rownames(scored@meta.data))",
      "  }",
      "  df <- data.frame(cell = cells, Dim_1 = emb[cells, 1], Dim_2 = emb[cells, 2], value = as.numeric(score[cells]))",
      "  df <- df[order(df$value), ]",
      "  limits <- quantile(df$value, c(analysis_recipe$feature_lower_quantile, analysis_recipe$feature_upper_quantile), na.rm = TRUE, names = FALSE)",
      "  p <- ggplot(df, aes(Dim_1, Dim_2, color = value)) + geom_point(size = figure_recipe$point_size, alpha = figure_recipe$point_alpha) +",
      "    scale_color_gradient(low = figure_recipe$low_color, high = figure_recipe$high_color, limits = limits, oob = scales::squish, name = program_name) + coord_fixed() + labs(title = program_name)",
      "  p <- add_facets(p, df) + theme_classic()",
      "  # Optional metadata save:",
      sprintf("  # sobj@meta.data[[%s]] <- score[rownames(sobj@meta.data)]", .figure_code_val(input$figure_feature_program_score_column %||% "gene_program_score")),
      "}",
      "print(p)"
    )
    paste(c(common_lines, program_lines), collapse = "\n")
  })
  figure_code_card_server(
    "figure_feature_code_card",
    code_text_reactive = generated_plot_code,
    shared_data = shared_data,
    object_name_reactive = selected_dataset_name,
    studio_name = "Feature Plot Studio"
  )

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
