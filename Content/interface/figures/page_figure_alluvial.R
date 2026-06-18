# R/page_figure_alluvial.R
FIGURE_ALLUVIAL_UI_TEXT <- list(
  t_btn_apply_colors = "Apply Colors",
  t_btn_copy_code = "Copy Code",
  t_btn_download_pdf = "Download PDF",
  t_btn_open_color_picker = "Open Color Picker",
  t_label_1_select_dataset = "1. Select Dataset:",
  t_label_2_chain = "2. Chain:",
  t_label_3_cluster_column = "3. Cluster column:",
  t_label_4_condition_column = "4. Condition split:",
  t_label_border_cluster = "Cluster border thickness:",
  t_label_border_clonotype = "Clonotype border thickness:",
  t_label_stack_border_color = "Stack border color (hex):",
  t_label_stack_fill_alpha = "Stack fill alpha:",
  t_label_cluster_bar_width = "Cluster bar width:",
  t_label_cluster_label_size = "Cluster label size:",
  t_label_clonotype_bar_width = "Clonotype bar width:",
  t_label_lock_bar_to_ribbon = "Lock stack widths to ribbon width",
  t_label_clonotype_grad_high = "High color",
  t_label_clonotype_grad_low = "Low color",
  t_label_cluster_colors = "Cluster colors:",
  t_label_clonotype_label_max_chars = "Max chars (smart shorten):",
  t_label_clonotype_label_size = "Clonotype label size:",
  t_label_editable_r_code = "Editable R code:",
  t_label_ribbon_width = "Ribbon width:",
  t_label_ribbon_waist = "Ribbon waist (middle shrink):",
  t_label_ribbon_sep_alpha = "Ribbon separator alpha:",
  t_label_ribbon_sep_width = "Ribbon separator width:",
  t_label_show_cluster_labels = "Show cluster labels",
  t_label_show_clonotype_labels = "Show clonotype labels",
  t_label_show_top_clonotype_labels = "Show top clonotype labels:",
  t_label_smart_shorten_clonotype = "Smart shorten clonotype labels",
  t_label_height = "Height (in):",
  t_label_alpha = "Ribbon alpha:",
  t_label_min_cells_per_flow = "Min cells per flow:",
  t_label_show_top_clonotypes = "Show top clonotypes:",
  t_label_width = "Width (in):",
  t_text_color_note = "Color picker stays in draft mode until you click Apply.",
  t_text_color_subtitle = "Low-to-high gradient for clonotype bars.",
  t_text_code_note_1 = "The generated script includes a workspace import line: bundle <- readRDS('PATH/TO/workspace_bundle.rds').",
  t_text_code_note_2 = "Each configurable parameter line includes an inline comment so users know what to edit.",
  t_text_code_note_3 = "This script is pipeline-independent (Seurat + ggplot2 + workspace object only, no source() helpers).",
  t_text_code_note_4 = "Add custom layers/theme changes under '# 5) Add extra ggplot layers below'.",
  t_text_intro = "Build a clonotype alluvial plot directly from processed VDJ metadata stored on the selected Seurat object.",
  t_text_none = "None",
  t_text_plot_note = "Uses object metadata columns (no external file upload).",
  t_title_alluvial_color_popup = "Alluvial Clonotype Colors",
  t_title_alluvial_gradient_card = "Clonotype gradient",
  t_title_alluvial_plot = "TCR/BCR Alluvial Plot",
  t_title_alluvial_styling = "Aesthetics",
  t_title_custom_r_code = "Customize in R",
  t_title_download_plot = "Download Plot",
  t_title_plot_controls = "Plot Controls",
  t_title_plot_preview = "Plot Preview"
)

library(ggplot2)
source("interface/figures/color_palettes.R")

figure_alluvial_ui <- fluidPage(
  tags$head(
    figure_busy_spinner_assets,
    if (is.function(get0("wl_pdf_modal_assets", mode = "function", ifnotfound = NULL))) wl_pdf_modal_assets() else NULL
  ),
  div(
    class = "page-header",
    h2(icon("shuffle"), " ", FIGURE_ALLUVIAL_UI_TEXT$t_title_alluvial_plot),
    p(FIGURE_ALLUVIAL_UI_TEXT$t_text_intro)
  ),
  hr(),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      class = "plotting-left-panel",
      style = "padding-top:0;",
      div(
        class = "wl-side",
        h4(FIGURE_ALLUVIAL_UI_TEXT$t_title_plot_controls),
        selectInput("figure_alluvial_dataset_select", FIGURE_ALLUVIAL_UI_TEXT$t_label_1_select_dataset, choices = NULL),
        radioButtons(
          "figure_alluvial_chain",
          FIGURE_ALLUVIAL_UI_TEXT$t_label_2_chain,
          choices = c("TCR" = "tcr", "BCR" = "bcr"),
          selected = "tcr",
          inline = TRUE
        ),
        selectInput("figure_alluvial_cluster_col", FIGURE_ALLUVIAL_UI_TEXT$t_label_3_cluster_column, choices = NULL),
        selectInput("figure_alluvial_condition_col", FIGURE_ALLUVIAL_UI_TEXT$t_label_4_condition_column, choices = stats::setNames("__none__", FIGURE_ALLUVIAL_UI_TEXT$t_text_none)),
        sliderInput("figure_alluvial_top_n", FIGURE_ALLUVIAL_UI_TEXT$t_label_show_top_clonotypes, min = 5, max = 100, value = 25, step = 1),
        sliderInput("figure_alluvial_top_n_labels", FIGURE_ALLUVIAL_UI_TEXT$t_label_show_top_clonotype_labels, min = 5, max = 100, value = 15, step = 1),
        sliderInput("figure_alluvial_min_cells", FIGURE_ALLUVIAL_UI_TEXT$t_label_min_cells_per_flow, min = 1, max = 50, value = 1, step = 1),
        sliderInput("figure_alluvial_alpha", FIGURE_ALLUVIAL_UI_TEXT$t_label_alpha, min = 0.1, max = 1, value = 0.45, step = 0.05),
        hr(),
        h5(FIGURE_ALLUVIAL_UI_TEXT$t_title_alluvial_styling),
        checkboxInput("figure_alluvial_show_cluster_labels", FIGURE_ALLUVIAL_UI_TEXT$t_label_show_cluster_labels, value = TRUE),
        sliderInput("figure_alluvial_cluster_label_size", FIGURE_ALLUVIAL_UI_TEXT$t_label_cluster_label_size, min = 1, max = 8, value = 3, step = 0.2),
        checkboxInput("figure_alluvial_show_clonotype_labels", FIGURE_ALLUVIAL_UI_TEXT$t_label_show_clonotype_labels, value = TRUE),
        sliderInput("figure_alluvial_clonotype_label_size", FIGURE_ALLUVIAL_UI_TEXT$t_label_clonotype_label_size, min = 1, max = 6, value = 2, step = 0.2),
        checkboxInput("figure_alluvial_smart_shorten", FIGURE_ALLUVIAL_UI_TEXT$t_label_smart_shorten_clonotype, value = TRUE),
        sliderInput("figure_alluvial_clonotype_label_max_chars", FIGURE_ALLUVIAL_UI_TEXT$t_label_clonotype_label_max_chars, min = 10, max = 80, value = 28, step = 1),
        sliderInput("figure_alluvial_ribbon_width", FIGURE_ALLUVIAL_UI_TEXT$t_label_ribbon_width, min = 0.02, max = 0.30, value = 0.08, step = 0.01),
        sliderInput("figure_alluvial_ribbon_waist", FIGURE_ALLUVIAL_UI_TEXT$t_label_ribbon_waist, min = 0.05, max = 0.45, value = 0.22, step = 0.01),
        sliderInput("figure_alluvial_ribbon_sep_alpha", FIGURE_ALLUVIAL_UI_TEXT$t_label_ribbon_sep_alpha, min = 0, max = 1, value = 0.18, step = 0.01),
        sliderInput("figure_alluvial_ribbon_sep_width", FIGURE_ALLUVIAL_UI_TEXT$t_label_ribbon_sep_width, min = 0, max = 1, value = 0.25, step = 0.01),
        checkboxInput("figure_alluvial_lock_bar_to_ribbon", FIGURE_ALLUVIAL_UI_TEXT$t_label_lock_bar_to_ribbon, value = TRUE),
        sliderInput("figure_alluvial_cluster_bar_width", FIGURE_ALLUVIAL_UI_TEXT$t_label_cluster_bar_width, min = 0.05, max = 0.40, value = 0.24, step = 0.01),
        sliderInput("figure_alluvial_clonotype_bar_width", FIGURE_ALLUVIAL_UI_TEXT$t_label_clonotype_bar_width, min = 0.05, max = 0.40, value = 0.24, step = 0.01),
        sliderInput("figure_alluvial_cluster_border", FIGURE_ALLUVIAL_UI_TEXT$t_label_border_cluster, min = 0, max = 1, value = 0.15, step = 0.01),
        sliderInput("figure_alluvial_clonotype_border", FIGURE_ALLUVIAL_UI_TEXT$t_label_border_clonotype, min = 0, max = 1, value = 0.10, step = 0.01),
        textInput("figure_alluvial_stack_border_color", FIGURE_ALLUVIAL_UI_TEXT$t_label_stack_border_color, value = "#4D4D4D"),
        sliderInput("figure_alluvial_stack_fill_alpha", FIGURE_ALLUVIAL_UI_TEXT$t_label_stack_fill_alpha, min = 0.1, max = 1, value = 1, step = 0.05),
        selectInput(
          "figure_alluvial_cluster_palette",
          FIGURE_ALLUVIAL_UI_TEXT$t_label_cluster_colors,
          choices = c("Object cluster colors", "Default Seurat", names(all_palettes)),
          selected = "Object cluster colors"
        ),
        uiOutput("figure_alluvial_gradient_card_ui"),
        hr(),
        h4(FIGURE_ALLUVIAL_UI_TEXT$t_title_download_plot),
        wellPanel(
          fluidRow(
            column(6, numericInput("figure_alluvial_width", FIGURE_ALLUVIAL_UI_TEXT$t_label_width, value = 12)),
            column(6, numericInput("figure_alluvial_height", FIGURE_ALLUVIAL_UI_TEXT$t_label_height, value = 8))
          )
        ),
        actionButton("open_alluvial_pdf_modal", FIGURE_ALLUVIAL_UI_TEXT$t_btn_download_pdf, class = "btn btn-default"),
        hr(),
        p(class = "text-muted", em(FIGURE_ALLUVIAL_UI_TEXT$t_text_plot_note))
      )
    ),
    mainPanel(
      width = 8,
      class = "plot_area_card_style",
      style = "padding-top:0;",
      tagList(
        div(
          class = "wl-side",
          style = "min-height: var(--plot-scroll-box-h);",
          h4(FIGURE_ALLUVIAL_UI_TEXT$t_title_plot_preview),
          figure_with_busy_spinner(plotOutput("figure_alluvial_plot", height = "calc(var(--plot-scroll-box-h) - 82px)"))
        ),
        div(
          style = "margin-top:12px;",
          figure_code_card_ui(
            id = "figure_alluvial_code_card",
            title = FIGURE_ALLUVIAL_UI_TEXT$t_title_custom_r_code,
            notes = c(
              FIGURE_ALLUVIAL_UI_TEXT$t_text_code_note_1,
              FIGURE_ALLUVIAL_UI_TEXT$t_text_code_note_2,
              FIGURE_ALLUVIAL_UI_TEXT$t_text_code_note_3,
              FIGURE_ALLUVIAL_UI_TEXT$t_text_code_note_4
            ),
            copy_button_label = FIGURE_ALLUVIAL_UI_TEXT$t_btn_copy_code,
            code_label = FIGURE_ALLUVIAL_UI_TEXT$t_label_editable_r_code
          )
        )
      )
    )
  )
)

figure_alluvial_server <- function(input, output, session, shared_data) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  dataset_select_signature <- reactiveVal("")
  cluster_select_signature <- reactiveVal("")
  condition_select_signature <- reactiveVal("")
  clonotype_gradient_defaults <- c(low = "#E5E7EB", high = "#FF3F00")
  clonotype_gradient_state <- reactiveVal(clonotype_gradient_defaults)
  clonotype_gradient_modal_seed <- reactiveVal(clonotype_gradient_defaults)
  alluvial_low_picker <- motion_color_picker_server("alluvial_low_picker", reset_trigger = reactive(input$figure_alluvial_gradient_reset))
  alluvial_high_picker <- motion_color_picker_server("alluvial_high_picker", reset_trigger = reactive(input$figure_alluvial_gradient_reset))

  dataset_choices <- reactive({
    names(shared_data$all_seurat_objects %||% list())
  })

  selected_dataset_name <- reactive({
    figure_preferred_object_name(
      registry = shared_data$all_seurat_objects %||% list(),
      current_selection = input$figure_alluvial_dataset_select %||% "",
      active_name = shared_data$active_object_name %||% ""
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
    shiny::freezeReactiveValue(input, "figure_alluvial_dataset_select")
    updateSelectInput(session, "figure_alluvial_dataset_select", choices = object_choices, selected = selected_name)
  })

  observe({
    req(identical(input$main_navbar %||% "", "figure_studio_alluvial"))
    selected_name <- selected_dataset_name()
    req(nzchar(selected_name))
    if (!identical(shared_data$active_object_name %||% "", selected_name)) {
      shared_data$active_object_name <- selected_name
    }
  })

  .preferred_cluster_col <- function(md) {
    cols <- colnames(md %||% data.frame())
    cand <- c("seurat_clusters", "cluster", "orig.ident", "sample", "sample_name")
    hit <- cand[cand %in% cols]
    if (length(hit)) hit[[1]] else if (length(cols)) cols[[1]] else ""
  }
  .preferred_condition_col <- function(md) {
    cols <- colnames(md %||% data.frame())
    cand <- c("orig.ident", "sample", "sample_name", "condition", "group")
    hit <- cand[cand %in% cols]
    if (length(hit)) hit[[1]] else "__none__"
  }
  .is_orig_ident_col <- function(col_nm) {
    identical(tolower(as.character(col_nm %||% "")), "orig.ident")
  }

  observe({
    obj <- active_object()
    req(obj)
    md <- obj@meta.data
    cols <- colnames(md %||% data.frame())
    choices <- cols[nzchar(cols)]
    req(length(choices) > 0)
    selected <- input$figure_alluvial_cluster_col %||% .preferred_cluster_col(md)
    if (!(selected %in% choices)) selected <- .preferred_cluster_col(md)
    if (!figure_select_input_needs_update(cluster_select_signature(), choices, selected)) {
      return(invisible(NULL))
    }
    cluster_select_signature(figure_select_input_signature(choices, selected))
    shiny::freezeReactiveValue(input, "figure_alluvial_cluster_col")
    updateSelectInput(session, "figure_alluvial_cluster_col", choices = choices, selected = selected)
  })

  observe({
    obj <- active_object()
    req(obj)
    md <- obj@meta.data
    choices <- figure_split_choices(md)
    selected <- input$figure_alluvial_condition_col %||% .preferred_condition_col(md)
    if (!(selected %in% unname(choices))) selected <- "__none__"
    if (!figure_select_input_needs_update(condition_select_signature(), unname(choices), selected)) {
      return(invisible(NULL))
    }
    condition_select_signature(figure_select_input_signature(unname(choices), selected))
    shiny::freezeReactiveValue(input, "figure_alluvial_condition_col")
    updateSelectInput(session, "figure_alluvial_condition_col", choices = choices, selected = selected)
  })

  output$figure_alluvial_gradient_card_ui <- renderUI({
    figure_color_card_ui(
      title = FIGURE_ALLUVIAL_UI_TEXT$t_title_alluvial_gradient_card,
      subtitle = FIGURE_ALLUVIAL_UI_TEXT$t_text_color_subtitle,
      swatch_ui = figure_gradient_swatches_ui(clonotype_gradient_state()),
      button_id = "open_alluvial_gradient_popup",
      button_label = FIGURE_ALLUVIAL_UI_TEXT$t_btn_open_color_picker,
      note = FIGURE_ALLUVIAL_UI_TEXT$t_text_color_note
    )
  })

  observeEvent(input$open_alluvial_gradient_popup, {
    current <- clonotype_gradient_state()
    clonotype_gradient_modal_seed(current)
    showModal(figure_dark_modal_dialog(
      title = FIGURE_ALLUVIAL_UI_TEXT$t_title_alluvial_color_popup,
      size = "l",
      easyClose = TRUE,
      footer = figure_picker_modal_footer(
        reset_id = "figure_alluvial_gradient_reset",
        apply_id = "figure_alluvial_gradient_apply",
        apply_label = FIGURE_ALLUVIAL_UI_TEXT$t_btn_apply_colors
      ),
      figure_two_color_modal_body(
        low_picker_id = "alluvial_low_picker",
        high_picker_id = "alluvial_high_picker",
        low_hex = current[["low"]],
        high_hex = current[["high"]],
        low_label = FIGURE_ALLUVIAL_UI_TEXT$t_label_clonotype_grad_low,
        high_label = FIGURE_ALLUVIAL_UI_TEXT$t_label_clonotype_grad_high
      )
    ))
  }, ignoreInit = TRUE)

  observeEvent(input$figure_alluvial_gradient_apply, {
    clonotype_gradient_state(
      figure_gradient_commit_values(
        low_payload = alluvial_low_picker(),
        high_payload = alluvial_high_picker(),
        defaults = clonotype_gradient_modal_seed()
      )
    )
    removeModal()
  }, ignoreInit = TRUE)

  .seurat_discrete_palette <- function(n) {
    n <- suppressWarnings(as.integer(n))
    if (!is.finite(n) || n < 1L) return(character(0))
    fn <- tryCatch(getFromNamespace("DiscretePalette", "Seurat"), error = function(e) NULL)
    cols <- tryCatch(
      if (is.function(fn)) as.character(fn(n)) else character(0),
      error = function(e) character(0)
    )
    if (length(cols) < n) cols <- scales::hue_pal()(n)
    cols[seq_len(n)]
  }

  .cluster_colors_from_dimplot <- function(sobj, group_col, levels_vec) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
    group_col <- as.character(group_col %||% "")
    if (!nzchar(group_col) || !(group_col %in% colnames(sobj@meta.data))) return(NULL)
    reds <- tryCatch(tolower(names(sobj@reductions)), error = function(e) character(0))
    red_use <- if ("umap" %in% reds) names(sobj@reductions)[match("umap", reds)] else NULL
    if (is.null(red_use) && length(names(sobj@reductions))) red_use <- names(sobj@reductions)[1]
    if (is.null(red_use) || !nzchar(red_use)) return(NULL)

    p_tmp <- tryCatch(Seurat::DimPlot(sobj, reduction = red_use, group.by = group_col), error = function(e) NULL)
    if (is.null(p_tmp) || !inherits(p_tmp, "ggplot")) return(NULL)

    d_plot <- tryCatch(p_tmp$data, error = function(e) NULL)
    d_layer <- tryCatch(ggplot2::ggplot_build(p_tmp)$data[[1]], error = function(e) NULL)
    if (is.null(d_plot) || is.null(d_layer) || !nrow(d_plot) || !nrow(d_layer)) return(NULL)
    if (!(group_col %in% colnames(d_plot))) return(NULL)

    vals <- as.character(d_plot[[group_col]])
    cols <- as.character(d_layer$colour)
    n <- min(length(vals), length(cols))
    if (n < 1L) return(NULL)
    vals <- vals[seq_len(n)]
    cols <- cols[seq_len(n)]
    keep <- !is.na(vals) & nzchar(vals) & !is.na(cols) & nzchar(cols)
    vals <- vals[keep]
    cols <- cols[keep]
    if (!length(vals) || !length(cols)) return(NULL)

    first_idx <- match(unique(vals), vals)
    map <- cols[first_idx]
    names(map) <- unique(vals)
    mapped <- unname(map[levels_vec])
    names(mapped) <- levels_vec
    if (!length(mapped) || all(is.na(mapped) | !nzchar(mapped))) return(NULL)
    mapped
  }

  alluvial_cluster_palette <- reactive({
    flow_df <- tryCatch(.build_alluvial_flows(), error = function(e) NULL)
    req(flow_df)
    
    cluster_col <- input$figure_alluvial_cluster_col %||% .preferred_cluster_col(active_object()@meta.data)
    req(cluster_col)
    
    cluster_levels <- flow_df |>
      dplyr::group_by(.data$cluster) |>
      dplyr::summarise(total = sum(.data$n_cells), .groups = "drop") |>
      dplyr::arrange(dplyr::desc(.data$total), .data$cluster) |>
      dplyr::pull(.data$cluster)
    if (!length(cluster_levels)) {
      cluster_levels <- sort(unique(flow_df$cluster))
    }
    
    # Check sobj@misc$metadata_level_colors first
    sobj <- active_object()
    misc <- tryCatch(sobj@misc, error = function(e) list())
    stored <- tryCatch(misc$metadata_level_colors[[cluster_col]], error = function(e) NULL)
    
    seurat_pal <- stats::setNames(.seurat_discrete_palette(length(cluster_levels)), cluster_levels)
    
    if (is.list(stored) && length(stored) > 0) {
      mapped <- vapply(cluster_levels, function(nm) {
        val <- stored[[nm]]
        if (!is.null(val) && grepl("^#[0-9A-F]{6}$", toupper(as.character(val)))) {
          toupper(as.character(val))
        } else {
          NA_character_
        }
      }, character(1))
      if (any(!is.na(mapped))) {
        bad <- is.na(mapped)
        if (any(bad)) {
          mapped[bad] <- seurat_pal[bad]
        }
        return(mapped)
      }
    }
    
    object_pal <- .cluster_colors_from_dimplot(
      sobj = sobj,
      group_col = cluster_col,
      levels_vec = cluster_levels
    )
    if (is.null(object_pal) || !length(object_pal)) object_pal <- seurat_pal
    if (any(is.na(object_pal) | !nzchar(object_pal))) {
      idx <- is.na(object_pal) | !nzchar(object_pal)
      object_pal[idx] <- seurat_pal[idx]
    }

    palette_mode <- as.character(input$figure_alluvial_cluster_palette %||% "Object cluster colors")
    cluster_pal <- switch(
      palette_mode,
      "Object cluster colors" = object_pal,
      "Default Seurat" = seurat_pal,
      {
        custom_pal <- figure_resolve_discrete_palette(
          palette_name = palette_mode,
          level_count = length(cluster_levels),
          palette_map = all_palettes,
          custom_palette = NULL,
          default_palette = object_pal
        )
        stats::setNames(custom_pal %||% object_pal, cluster_levels)
      }
    )
    cluster_pal
  })

  # Sync Alluvial palette changes back to Seurat metadata colors
  observe({
    req(identical(input$main_navbar %||% "", "figure_studio_alluvial"))
    
    obj <- active_object()
    req(obj)
    cluster_col <- input$figure_alluvial_cluster_col %||% .preferred_cluster_col(obj@meta.data)
    req(cluster_col)
    pal <- tryCatch(alluvial_cluster_palette(), error = function(e) NULL)
    req(pal)
    
    misc <- tryCatch(obj@misc, error = function(e) list())
    if (!is.list(misc)) misc <- list()
    stored <- tryCatch(misc$metadata_level_colors[[cluster_col]], error = function(e) NULL)
    
    pal_list <- as.list(pal)
    
    needs_update <- FALSE
    if (!is.list(stored)) {
      # Do not overwrite empty metadata colors with default/object palettes
      if (!((input$figure_alluvial_cluster_palette %||% "Object cluster colors") %in% c("Default Seurat", "Object cluster colors"))) {
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
      misc$metadata_level_colors[[cluster_col]] <- pal_list
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

  .build_alluvial_flows <- reactive({
    obj <- active_object()
    req(obj)
    md <- obj@meta.data
    validate(need(is.data.frame(md) && nrow(md) > 0, "Selected object has no metadata rows."))

    cluster_col <- input$figure_alluvial_cluster_col %||% .preferred_cluster_col(md)
    validate(need(nzchar(cluster_col) && cluster_col %in% colnames(md), "Cluster column is not available in this object."))

    chain <- tolower(input$figure_alluvial_chain %||% "tcr")
    chain <- if (identical(chain, "bcr")) "bcr" else "tcr"
    clone_col <- if (identical(chain, "bcr")) "vdj_bcr_clone" else "vdj_tcr_clone"
    size_col <- if (identical(chain, "bcr")) "vdj_bcr_clone_size" else "vdj_tcr_clone_size"
    validate(need(clone_col %in% colnames(md), paste0("Missing metadata column: ", clone_col)))
    validate(need(size_col %in% colnames(md), paste0("Missing metadata column: ", size_col)))

    split_col <- figure_normalize_split_value(input$figure_alluvial_condition_col)
    if (!is.null(split_col) && !(split_col %in% colnames(md))) split_col <- NULL

    cluster_vals <- as.character(md[[cluster_col]] %||% "")
    cluster_vals[is.na(cluster_vals) | !nzchar(cluster_vals)] <- "Unknown"
    clonotype_vals <- as.character(md[[clone_col]] %||% "")
    clonotype_vals[is.na(clonotype_vals)] <- ""
    clone_size_vals <- suppressWarnings(as.numeric(md[[size_col]] %||% 0))
    clone_size_vals[!is.finite(clone_size_vals)] <- 0

    if (is.null(split_col)) {
      cond_vals <- rep("All cells", length(cluster_vals))
    } else {
      cond_vals <- as.character(md[[split_col]] %||% "")
      cond_vals[is.na(cond_vals) | !nzchar(cond_vals)] <- "Unknown"
    }

    base_df <- data.frame(
      condition = cond_vals,
      cluster = cluster_vals,
      clonotype = clonotype_vals,
      clone_size = clone_size_vals,
      stringsAsFactors = FALSE
    )
    base_df <- base_df[nzchar(base_df$clonotype) & base_df$clone_size > 0, , drop = FALSE]
    validate(need(nrow(base_df) > 0, "No VDJ-positive cells found for this chain. Import VDJ first."))
    if (!is.null(split_col) && .is_orig_ident_col(split_col)) {
      condition_levels <- figure_sort_facet_levels(base_df$condition)
    } else {
      condition_levels <- sort(unique(base_df$condition))
    }

    flow_df <- dplyr::count(base_df, .data$condition, .data$cluster, .data$clonotype, name = "n_cells")
    flow_df <- flow_df[flow_df$n_cells >= as.integer(input$figure_alluvial_min_cells %||% 1), , drop = FALSE]
    validate(need(nrow(flow_df) > 0, "No flows remain after min-cells filtering."))

    top_n <- as.integer(input$figure_alluvial_top_n %||% 25)
    top_n <- if (!is.finite(top_n) || top_n < 1) 25L else top_n
    top_tbl <- dplyr::summarise(
      dplyr::group_by(flow_df, .data$condition, .data$clonotype),
      total_cells = sum(.data$n_cells),
      .groups = "drop"
    )
    top_tbl <- dplyr::arrange(top_tbl, .data$condition, dplyr::desc(.data$total_cells), .data$clonotype)
    top_tbl <- dplyr::slice_head(dplyr::group_by(top_tbl, .data$condition), n = top_n)
    top_labels <- dplyr::pull(top_tbl, .data$clonotype)
    flow_df <- flow_df[flow_df$clonotype %in% top_labels, , drop = FALSE]
    validate(need(nrow(flow_df) > 0, "No flows remain after top-clonotype filtering."))

    flow_df$cluster <- as.character(flow_df$cluster)
    flow_df$clonotype <- as.character(flow_df$clonotype)
    flow_df$condition <- as.character(flow_df$condition)
    attr(flow_df, "condition_levels") <- condition_levels
    flow_df
  })

  .compose_alluvial_plot <- reactive({
    validate(need(requireNamespace("ggalluvial", quietly = TRUE), "Package 'ggalluvial' is required for this plot. Please install/update dependencies in run.R bootstrap."))
    validate(need(requireNamespace("ggnewscale", quietly = TRUE), "Package 'ggnewscale' is required for clonotype bar coloring. Please install/update dependencies in run.R bootstrap."))
    flow_df <- .build_alluvial_flows()
    .smart_shorten_labels <- function(labels, max_chars = 28L, enabled = TRUE) {
      labels <- as.character(labels %||% character(0))
      if (!length(labels) || !isTRUE(enabled)) return(labels)
      max_chars <- suppressWarnings(as.integer(max_chars))
      if (!is.finite(max_chars) || max_chars < 10) max_chars <- 28L

      .esc_re <- function(x) gsub("([][{}()+*^$|\\\\?.])", "\\\\\\1", x)
      .common_prefix <- function(x) {
        if (!length(x)) return("")
        chars <- strsplit(x, "", fixed = TRUE)
        lim <- min(lengths(chars))
        if (!is.finite(lim) || lim < 1L) return("")
        out <- character(0)
        for (i in seq_len(lim)) {
          ch <- chars[[1]][i]
          if (all(vapply(chars, function(v) identical(v[[i]], ch), logical(1)))) {
            out <- c(out, ch)
          } else {
            break
          }
        }
        paste(out, collapse = "")
      }
      .common_suffix <- function(x) {
        rev_x <- vapply(x, function(s) paste(rev(strsplit(s, "", fixed = TRUE)[[1]]), collapse = ""), character(1))
        rev_pref <- .common_prefix(rev_x)
        if (!nzchar(rev_pref)) return("")
        paste(rev(strsplit(rev_pref, "", fixed = TRUE)[[1]]), collapse = "")
      }

      base <- labels
      pref <- .common_prefix(base)
      if (nchar(pref) >= 3L) {
        base <- sub(paste0("^", .esc_re(pref)), "", base)
      }
      suff <- .common_suffix(base)
      if (nchar(suff) >= 3L) {
        base <- sub(paste0(.esc_re(suff), "$"), "", base)
      }
      base[!nzchar(trimws(base))] <- labels[!nzchar(trimws(base))]

      too_long <- nchar(base) > max_chars
      if (any(too_long)) {
        left_n <- max(6L, floor((max_chars - 3L) / 2L))
        right_n <- max(3L, max_chars - left_n - 3L)
        base[too_long] <- paste0(
          substr(base[too_long], 1, left_n),
          "...",
          substr(base[too_long], nchar(base[too_long]) - right_n + 1, nchar(base[too_long]))
        )
      }
      make.unique(base, sep = "_")
    }

    cluster_levels <- flow_df |>
      dplyr::group_by(.data$cluster) |>
      dplyr::summarise(total = sum(.data$n_cells), .groups = "drop") |>
      dplyr::arrange(dplyr::desc(.data$total), .data$cluster) |>
      dplyr::pull(.data$cluster)
    if (!length(cluster_levels)) {
      cluster_levels <- sort(unique(flow_df$cluster))
    }
    clone_levels <- flow_df |>
      dplyr::group_by(.data$clonotype) |>
      dplyr::summarise(total = sum(.data$n_cells), .groups = "drop") |>
      dplyr::arrange(dplyr::desc(.data$total), .data$clonotype) |>
      dplyr::pull(.data$clonotype)
    if (!length(clone_levels)) {
      clone_levels <- sort(unique(flow_df$clonotype))
    }

    clone_label_map <- stats::setNames(
      .smart_shorten_labels(
        labels = clone_levels,
        max_chars = input$figure_alluvial_clonotype_label_max_chars %||% 28,
        enabled = isTRUE(input$figure_alluvial_smart_shorten)
      ),
      clone_levels
    )

    flow_df$cluster <- factor(flow_df$cluster, levels = cluster_levels)
    flow_df$clonotype <- factor(flow_df$clonotype, levels = clone_levels)
    flow_df$alluvium <- paste(flow_df$condition, flow_df$cluster, flow_df$clonotype, sep = "||")

    cluster_pal <- alluvial_cluster_palette()

    lodes <- dplyr::bind_rows(
      dplyr::transmute(
        flow_df,
        condition = .data$condition,
        x = 1,
        stratum = .data$cluster,
        alluvium = .data$alluvium,
        n_cells = .data$n_cells,
        cluster_fill = .data$cluster
      ),
      dplyr::transmute(
        flow_df,
        condition = .data$condition,
        x = 2,
        stratum = .data$clonotype,
        alluvium = .data$alluvium,
        n_cells = .data$n_cells,
        cluster_fill = .data$cluster
      )
    )
    stratum_levels <- c(cluster_levels, clone_levels)
    lodes$stratum <- factor(as.character(lodes$stratum), levels = stratum_levels)
    lodes$cluster_fill <- factor(as.character(lodes$cluster_fill), levels = cluster_levels)
    condition_levels <- attr(flow_df, "condition_levels")
    if (!is.null(condition_levels) && length(condition_levels)) {
      lodes$condition <- factor(as.character(lodes$condition), levels = condition_levels)
    } else {
      lodes$condition <- factor(as.character(lodes$condition))
    }

    ribbons <- ggplot(
      lodes,
      aes(x = .data$x, stratum = .data$stratum, alluvium = .data$alluvium, y = .data$n_cells)
    )
    alluvium_w <- as.numeric(input$figure_alluvial_ribbon_width %||% 0.08)
    if (!is.finite(alluvium_w) || alluvium_w <= 0) alluvium_w <- 0.08
    waist <- as.numeric(input$figure_alluvial_ribbon_waist %||% 0.22)
    if (!is.finite(waist) || waist < 0.01 || waist > 0.49) waist <- 0.22
    sep_alpha <- as.numeric(input$figure_alluvial_ribbon_sep_alpha %||% 0.18)
    if (!is.finite(sep_alpha) || sep_alpha < 0 || sep_alpha > 1) sep_alpha <- 0.18
    sep_width <- as.numeric(input$figure_alluvial_ribbon_sep_width %||% 0.25)
    if (!is.finite(sep_width) || sep_width < 0) sep_width <- 0.25
    ribbons <- ribbons +
      ggalluvial::geom_alluvium(
        aes(fill = .data$cluster_fill),
        alpha = as.numeric(input$figure_alluvial_alpha %||% 0.45),
        width = alluvium_w,
        curve_type = "xspline",
        knot.pos = waist,
        color = scales::alpha("#FFFFFF", sep_alpha),
        linewidth = sep_width,
        linetype = 1
      ) +
      scale_fill_manual(values = cluster_pal, guide = "none")
    has_condition_split <- length(unique(lodes$condition)) > 1
    if (has_condition_split) {
      ribbons <- ribbons + facet_wrap(~condition, scales = "free_y", drop = FALSE)
    }
    lock_bar_w <- isTRUE(input$figure_alluvial_lock_bar_to_ribbon)
    if (lock_bar_w) {
      cluster_bar_w <- alluvium_w
      clonotype_bar_w <- alluvium_w
    } else {
      cluster_bar_w <- as.numeric(input$figure_alluvial_cluster_bar_width %||% 0.24)
      clonotype_bar_w <- as.numeric(input$figure_alluvial_clonotype_bar_width %||% 0.24)
      if (!is.finite(cluster_bar_w) || cluster_bar_w <= 0) cluster_bar_w <- 0.24
      if (!is.finite(clonotype_bar_w) || clonotype_bar_w <= 0) clonotype_bar_w <- 0.24
    }
    cluster_border <- as.numeric(input$figure_alluvial_cluster_border %||% 0.15)
    clonotype_border <- as.numeric(input$figure_alluvial_clonotype_border %||% 0.10)
    stack_alpha <- as.numeric(input$figure_alluvial_stack_fill_alpha %||% 1)
    if (!is.finite(stack_alpha) || stack_alpha <= 0 || stack_alpha > 1) stack_alpha <- 1
    stack_border_col <- as.character(input$figure_alluvial_stack_border_color %||% "#4D4D4D")
    if (!isTRUE(grepl("^#(?:[A-Fa-f0-9]{3}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$", stack_border_col))) {
      stack_border_col <- "#4D4D4D"
    }

    clonotype_totals <- flow_df |>
      dplyr::group_by(.data$clonotype) |>
      dplyr::summarise(clonotype_size = sum(.data$n_cells), .groups = "drop")
    clonotype_totals$clonotype <- as.character(clonotype_totals$clonotype)
    anchor_plot <- ggplot(
      lodes,
      aes(x = .data$x, stratum = .data$stratum, alluvium = .data$alluvium, y = .data$n_cells)
    ) +
      ggalluvial::geom_stratum(width = alluvium_w, alpha = 0)
    if (has_condition_split) {
      anchor_plot <- anchor_plot + facet_wrap(~condition, scales = "free_y", drop = FALSE)
    }
    anchor_build <- ggplot2::ggplot_build(anchor_plot)
    anchor_idx <- which(vapply(
      anchor_build$data,
      function(d) all(c("x", "stratum", "ymin", "ymax", "PANEL") %in% colnames(d)),
      logical(1)
    ))
    validate(need(length(anchor_idx) > 0, "Could not compute stratum anchors for alluvial bars."))
    anchors <- anchor_build$data[[anchor_idx[[1]]]]
    anchors$stratum <- as.character(anchors$stratum)

    panel_tbl <- tryCatch(anchor_build$layout$layout, error = function(e) NULL)
    if (has_condition_split && !is.null(panel_tbl) && ("condition" %in% colnames(panel_tbl))) {
      panel_map <- panel_tbl[, c("PANEL", "condition"), drop = FALSE]
      anchors <- dplyr::left_join(anchors, panel_map, by = "PANEL")
      anchors$condition <- as.character(anchors$condition)
    } else {
      anchors$condition <- as.character(condition_levels %||% "All cells")[[1]]
    }
    anchors$condition <- factor(as.character(anchors$condition), levels = condition_levels)

    cluster_rect <- anchors[anchors$x == 1, c("condition", "x", "stratum", "ymin", "ymax"), drop = FALSE]
    names(cluster_rect)[names(cluster_rect) == "stratum"] <- "cluster"
    cluster_rect$cluster <- factor(as.character(cluster_rect$cluster), levels = cluster_levels)
    cluster_rect$ymid <- (cluster_rect$ymin + cluster_rect$ymax) / 2
    cluster_rect$xmin <- cluster_rect$x - cluster_bar_w / 2
    cluster_rect$xmax <- cluster_rect$x + cluster_bar_w / 2
    cluster_rect$cluster_fill <- cluster_rect$cluster

    clonotype_rect <- anchors[anchors$x == 2, c("condition", "x", "stratum", "ymin", "ymax"), drop = FALSE]
    names(clonotype_rect)[names(clonotype_rect) == "stratum"] <- "clonotype"
    clonotype_rect <- dplyr::left_join(clonotype_rect, clonotype_totals, by = "clonotype")
    clonotype_rect$clonotype <- factor(clonotype_rect$clonotype, levels = clone_levels)
    clonotype_rect$ymid <- (clonotype_rect$ymin + clonotype_rect$ymax) / 2
    clonotype_rect$xmin <- clonotype_rect$x - clonotype_bar_w / 2
    clonotype_rect$xmax <- clonotype_rect$x + clonotype_bar_w / 2
    clonotype_rect$clonotype_label <- unname(clone_label_map[as.character(clonotype_rect$clonotype)])

    label_top_n <- as.integer(input$figure_alluvial_top_n_labels %||% 15)
    label_top_n <- if (!is.finite(label_top_n) || label_top_n < 1) 15L else label_top_n
    label_keep <- clonotype_totals |>
      dplyr::arrange(dplyr::desc(.data$clonotype_size), .data$clonotype) |>
      dplyr::slice_head(n = label_top_n) |>
      dplyr::pull(.data$clonotype)

    p <- ribbons +
      geom_rect(
        data = cluster_rect,
        aes(xmin = .data$xmin, xmax = .data$xmax, ymin = .data$ymin, ymax = .data$ymax, fill = .data$cluster_fill),
        inherit.aes = FALSE,
        color = stack_border_col,
        linewidth = cluster_border,
        alpha = stack_alpha
      ) +
      scale_fill_manual(values = cluster_pal, guide = "none") +
      ggnewscale::new_scale_fill() +
      geom_rect(
        data = clonotype_rect,
        aes(xmin = .data$xmin, xmax = .data$xmax, ymin = .data$ymin, ymax = .data$ymax, fill = .data$clonotype_size),
        inherit.aes = FALSE,
        color = stack_border_col,
        linewidth = clonotype_border,
        alpha = stack_alpha
      ) +
      scale_fill_gradient(
        low = clonotype_gradient_state()[["low"]],
        high = clonotype_gradient_state()[["high"]],
        guide = "none"
      ) +
      scale_x_continuous(
        breaks = c(1, 2),
        labels = c("Clusters", "Clonotypes"),
        expand = expansion(mult = c(0.08, 0.08))
      ) +
      coord_cartesian(xlim = c(0.4, 2.6), clip = "off") +
      labs(
        title = paste0(toupper(input$figure_alluvial_chain %||% "tcr"), " clonotype alluvial"),
        x = NULL,
        y = "Cells"
      ) +
      theme_classic(base_size = 12) +
      theme(
        plot.margin = margin(6, 36, 6, 28),
        legend.position = "none",
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()
      )

    if (isTRUE(input$figure_alluvial_show_cluster_labels)) {
      p <- p + geom_text(
        data = cluster_rect,
        aes(x = .data$xmin, y = .data$ymid, label = .data$cluster),
        inherit.aes = FALSE,
        hjust = 1,
        nudge_x = -0.08,
        size = as.numeric(input$figure_alluvial_cluster_label_size %||% 3)
      )
    }

    if (isTRUE(input$figure_alluvial_show_clonotype_labels)) {
      p <- p + geom_text(
        data = dplyr::mutate(
          clonotype_rect,
          label_to_plot = ifelse(as.character(.data$clonotype) %in% label_keep, .data$clonotype_label, "")
        ),
        aes(x = .data$xmax, y = .data$ymid, label = .data$label_to_plot),
        inherit.aes = FALSE,
        hjust = 0,
        nudge_x = 0.08,
        size = as.numeric(input$figure_alluvial_clonotype_label_size %||% 2)
      )
    }

    p
  })

  output$figure_alluvial_plot <- renderPlot({
    tryCatch(
      .compose_alluvial_plot(),
      error = function(e) {
        plot.new()
        title(main = "Alluvial Plot Error")
        msg <- tryCatch(conditionMessage(e), error = function(e2) "Unknown plotting error")
        text(0.5, 0.55, labels = "Could not render alluvial plot.", cex = 1.0)
        text(0.5, 0.45, labels = msg, cex = 0.8)
        invisible(NULL)
      }
    )
  })

  generated_plot_code <- reactive({
    figure_generate_alluvial_script(list(
      object_name = selected_dataset_name(),
      chain = input$figure_alluvial_chain,
      cluster_col = input$figure_alluvial_cluster_col,
      condition_col = figure_normalize_split_value(input$figure_alluvial_condition_col),
      top_n = input$figure_alluvial_top_n,
      min_cells = input$figure_alluvial_min_cells,
      alpha = input$figure_alluvial_alpha,
      ribbon_width = input$figure_alluvial_ribbon_width,
      cluster_palette = input$figure_alluvial_cluster_palette
    ))
  })
  figure_code_card_server("figure_alluvial_code_card", code_text_reactive = generated_plot_code)

  .figure_alluvial_pdf_bundle <- function(kind, width_px = NULL, height_px = NULL) {
    req(identical(kind, "alluvial_pdf"))
    p <- .compose_alluvial_plot()
    req(p)
    width_in <- suppressWarnings(as.numeric(input$figure_alluvial_width %||% 12))
    height_in <- suppressWarnings(as.numeric(input$figure_alluvial_height %||% 8))
    if (!is.finite(width_in) || width_in <= 0) width_in <- 12
    if (!is.finite(height_in) || height_in <= 0) height_in <- 8
    if (is.finite(width_px) && width_px > 0) width_in <- width_px / 96
    if (is.finite(height_px) && height_px > 0) height_in <- height_px / 96
    list(
      plot = p,
      width_px = as.integer(max(320, round(width_in * 96))),
      height_px = as.integer(max(240, round(height_in * 96))),
      filename_prefix = paste0(selected_dataset_name() %||% "dataset", "_", toupper(input$figure_alluvial_chain %||% "tcr"), "_Alluvial_")
    )
  }

  .pdf_modal_server <- get0("wl_pdf_modal_server", mode = "function", ifnotfound = NULL)
  if (is.null(.pdf_modal_server)) {
    stop("Shared PDF modal helper is unavailable. Please source interface/shared/shared_pdf_export_modal.R first.")
  }
  .figure_alluvial_pdf_modal <- .pdf_modal_server(
    input = input,
    output = output,
    session = session,
    id_prefix = "figure_alluvial_pdf",
    build_bundle = .figure_alluvial_pdf_bundle,
    download_btn_label = FIGURE_ALLUVIAL_UI_TEXT$t_btn_download_pdf,
    default_modal_title = "PDF export settings: TCR/BCR Alluvial"
  )
  observeEvent(input$open_alluvial_pdf_modal, {
    .figure_alluvial_pdf_modal$open("alluvial_pdf", title_txt = "PDF export settings: TCR/BCR Alluvial")
  }, ignoreInit = TRUE)
}
