# R/page_figure_dotplot.R
FIGURE_DOTPLOT_UI_TEXT <- list(
  t_btn_apply_preview = "Apply Preview",
  t_btn_apply_colors = "Apply Colors",
  t_btn_copy_code = "Copy Code",
  t_btn_download_pdf = "Download PDF",
  t_btn_generate_update_plot = "Generate / Update Plot",
  t_btn_open_dot_picker = "Open Dot Picker",
  t_label_1_select_dataset = "1. Select Dataset:",
  t_label_axis_text_size = "Axis Text Size:",
  t_label_color_high_expression = "High expression color",
  t_label_color_low_expression = "Low expression color",
  t_label_editable_r_code = "Editable R code:",
  t_label_dot_size_max = "Dot Size (Max):",
  t_label_group_identity_list = "Identity groups (optional):",
  t_label_group_gene_list = "Gene groups (optional):",
  t_label_height = "Height (in):",
  t_label_plot_orientation = "Plot Orientation:",
  t_label_provide_list_genes_one_per_line = "Or, provide a list of genes (one per line):",
  t_label_show_group_dashes = "Show dashed separators",
  t_label_show_group_labels = "Show group labels",
  t_label_width = "Width (in):",
  t_label_x_axis_text_angle = "X-axis Text Angle:",
  t_text_default_top_3_marker_genes_per = "By default, the top 3 marker genes per cluster will be shown.",
  t_text_dotplot_gradient_note = "The popup keeps changes in draft mode until you click Apply.",
  t_text_dotplot_gradient_subtitle = "Low-to-high expression gradient for the active Dot Plot.",
  t_text_dotplot_grouping_format_hint = "Format: Group name: item1, item2  (or put items on following lines).",
  t_text_dotplot_identity_group_placeholder = "T cells: 1, 5, 6\nB cells: 10, 17\nMyeloid: 4, 8, 12",
  t_text_dotplot_gene_group_placeholder = "T cell markers:\nSELL\nCCR7\nLEF1\n\nCytotoxic markers:\nNKG7\nGNLY\nPRF1",
  t_text_code_note_1 = "The generated script includes a workspace import line: bundle <- readRDS('PATH/TO/workspace_bundle.rds').",
  t_text_code_note_2 = "Each configurable parameter line includes an inline comment so users know what to edit.",
  t_text_code_note_3 = "This script is pipeline-independent (Seurat + ggplot2 + workspace object only, no source() helpers).",
  t_text_code_note_4 = "Add custom layers/theme changes under '# 6) Add extra ggplot layers below'.",
  t_text_leave_blank_top_3_markers_enter = "Leave blank for top 3 markers, or enter genes like:\\nCd74\\nCxcl10\\nCd3d",
  t_text_visualize_average_expression_detection_rate_genes = "Visualize the average expression and detection rate of genes across clusters.",
  t_title_appearance = "Appearance",
  t_title_custom_r_code = "Customize in R",
  t_title_dot_plot_color_popup = "Dot Plot Colors",
  t_title_dot_plot_customization = "Dot Plot Customization",
  t_title_dotplot_gradient_card = "Dot plot colors",
  t_title_download_plot = "Download Plot",
  t_title_gene_selection = "Gene Selection",
  t_title_grouping = "Grouping (Optional)",
  t_title_plot_controls = "Plot Controls",
  t_title_plot_preview = "Plot Preview",
  t_title_text_axes = "Text & Axes"
)

library(ggplot2)

figure_dotplot_ui <- fluidPage(
  tags$head(
    figure_busy_spinner_assets,
    if (is.function(get0("wl_pdf_modal_assets", mode = "function", ifnotfound = NULL))) wl_pdf_modal_assets() else NULL
  ),
  div(
    class = "page-header",
    h2(icon("arrow-up-right-dots"), " ", FIGURE_DOTPLOT_UI_TEXT$t_title_dot_plot_customization),
    p(FIGURE_DOTPLOT_UI_TEXT$t_text_visualize_average_expression_detection_rate_genes)
  ),
  hr(),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      class = "plotting-left-panel",
      style = "padding-top:0;",
      div(
        class = "wl-side",
        h4(FIGURE_DOTPLOT_UI_TEXT$t_title_plot_controls),

        selectInput("figure_dotplot_dataset_select", FIGURE_DOTPLOT_UI_TEXT$t_label_1_select_dataset, choices = NULL),

        hr(),
        h5(FIGURE_DOTPLOT_UI_TEXT$t_title_gene_selection),
        p(FIGURE_DOTPLOT_UI_TEXT$t_text_default_top_3_marker_genes_per),
        textAreaInput(
          "dotplot_gene_list",
          FIGURE_DOTPLOT_UI_TEXT$t_label_provide_list_genes_one_per_line,
          placeholder = FIGURE_DOTPLOT_UI_TEXT$t_text_leave_blank_top_3_markers_enter,
          rows = 5
        ),

        hr(),
        h5(FIGURE_DOTPLOT_UI_TEXT$t_title_appearance),
        sliderInput("dotplot_scale", FIGURE_DOTPLOT_UI_TEXT$t_label_dot_size_max, min = 1, max = 20, value = 6),
        uiOutput("dotplot_gradient_card_ui"),

        hr(),
        h5(FIGURE_DOTPLOT_UI_TEXT$t_title_grouping),
        p(FIGURE_DOTPLOT_UI_TEXT$t_text_dotplot_grouping_format_hint),
        textAreaInput(
          "dotplot_gene_groups",
          FIGURE_DOTPLOT_UI_TEXT$t_label_group_gene_list,
          placeholder = FIGURE_DOTPLOT_UI_TEXT$t_text_dotplot_gene_group_placeholder,
          rows = 5
        ),
        textAreaInput(
          "dotplot_identity_groups",
          FIGURE_DOTPLOT_UI_TEXT$t_label_group_identity_list,
          placeholder = FIGURE_DOTPLOT_UI_TEXT$t_text_dotplot_identity_group_placeholder,
          rows = 4
        ),
        checkboxInput("dotplot_show_group_dashes", FIGURE_DOTPLOT_UI_TEXT$t_label_show_group_dashes, value = TRUE),
        checkboxInput("dotplot_show_group_labels", FIGURE_DOTPLOT_UI_TEXT$t_label_show_group_labels, value = TRUE),

        hr(),
        h5(FIGURE_DOTPLOT_UI_TEXT$t_title_text_axes),
        radioButtons(
          "dotplot_orientation",
          FIGURE_DOTPLOT_UI_TEXT$t_label_plot_orientation,
          choices = c("Vertical (Genes on Y-axis)" = "Vertical", "Horizontal (Genes on X-axis)" = "Horizontal"),
          selected = "Vertical",
          inline = TRUE
        ),
        radioButtons(
          "dotplot_axis_text_angle",
          FIGURE_DOTPLOT_UI_TEXT$t_label_x_axis_text_angle,
          choices = c("Horizontal" = 0, "Tilted" = 45, "Vertical" = 90),
          selected = 45,
          inline = TRUE
        ),
        sliderInput("dotplot_axis_text_size", FIGURE_DOTPLOT_UI_TEXT$t_label_axis_text_size, min = 4, max = 20, value = 10, step = 1),

        hr(),
        actionButton("dotplot_generate_btn", FIGURE_DOTPLOT_UI_TEXT$t_btn_generate_update_plot, class = "btn btn-primary btn-block"),
        br(),
        h4(FIGURE_DOTPLOT_UI_TEXT$t_title_download_plot),
        wellPanel(
          fluidRow(
            column(6, numericInput("figure_dotplot_width", FIGURE_DOTPLOT_UI_TEXT$t_label_width, value = 12)),
            column(6, numericInput("figure_dotplot_height", FIGURE_DOTPLOT_UI_TEXT$t_label_height, value = 8))
          )
        ),
        actionButton("figure_dotplot_apply_preview", FIGURE_DOTPLOT_UI_TEXT$t_btn_apply_preview, class = "btn btn-default"),
        br(),
        actionButton("open_dotplot_pdf_modal", FIGURE_DOTPLOT_UI_TEXT$t_btn_download_pdf, class = "btn btn-default")
      )
    ),
    mainPanel(
      width = 8,
      class = "plot_area_card_style",
      style = "padding-top:0;",
      tagList(
        div(
          class = "wl-side",
          h4(FIGURE_DOTPLOT_UI_TEXT$t_title_plot_preview),
          div(
            id = "figure_dotplot_preview_stage",
            class = "figure-preview-stage",
            div(
              id = "figure_dotplot_preview_frame",
              class = "figure-preview-frame",
              figure_with_busy_spinner(plotOutput("figure_dotplot_plot", width = "100%", height = "100%"))
            )
          )
        ),
        div(
          style = "margin-top:12px;",
          figure_code_card_ui(
            id = "figure_dotplot_code_card",
            title = FIGURE_DOTPLOT_UI_TEXT$t_title_custom_r_code,
            notes = c(
              FIGURE_DOTPLOT_UI_TEXT$t_text_code_note_1,
              FIGURE_DOTPLOT_UI_TEXT$t_text_code_note_2,
              FIGURE_DOTPLOT_UI_TEXT$t_text_code_note_3,
              FIGURE_DOTPLOT_UI_TEXT$t_text_code_note_4
            ),
            copy_button_label = FIGURE_DOTPLOT_UI_TEXT$t_btn_copy_code,
            code_label = FIGURE_DOTPLOT_UI_TEXT$t_label_editable_r_code
          )
        )
      )
    )
  )
)

figure_dotplot_server <- function(input, output, session, shared_data) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  .normalize_preview_px <- function(width_raw, height_raw) {
    w <- suppressWarnings(as.numeric(width_raw %||% 12))
    h <- suppressWarnings(as.numeric(height_raw %||% 8))
    if (!is.finite(w) || w <= 0) w <- 12
    if (!is.finite(h) || h <= 0) h <- 8
    list(
      width_px = as.integer(max(320, round(w * 96))),
      height_px = as.integer(max(240, round(h * 96)))
    )
  }
  dotplot_preview_dims <- reactiveVal(.normalize_preview_px(12, 8))
  .pick_group_col <- function(obj) {
    md <- obj@meta.data
    cand <- c("seurat_clusters", "cluster", "ident", "orig.ident", "sample")
    hit <- cand[cand %in% colnames(md)]
    if (length(hit)) return(hit[[1]])
    NULL
  }
  .split_group_items <- function(x) {
    x <- as.character(x %||% "")
    if (!nzchar(x)) return(character(0))
    parts <- unlist(strsplit(x, "[,;|]", perl = TRUE), use.names = FALSE)
    parts <- trimws(parts)
    unique(parts[nzchar(parts)])
  }
  .parse_grouping_spec <- function(spec_text) {
    lines <- trimws(unlist(strsplit(as.character(spec_text %||% ""), "\n", fixed = TRUE), use.names = FALSE))
    lines <- lines[nzchar(lines)]
    if (!length(lines)) {
      return(list(names = character(0), items = list()))
    }
    out_names <- character(0)
    out_items <- list()
    current_name <- NULL
    for (ln in lines) {
      if (grepl("^\\[.+\\]$", ln)) {
        current_name <- trimws(sub("^\\[(.+)\\]$", "\\1", ln))
        if (!nzchar(current_name)) current_name <- NULL
        if (!is.null(current_name) && !(current_name %in% out_names)) {
          out_names <- c(out_names, current_name)
          out_items[[current_name]] <- character(0)
        }
        next
      }
      if (grepl(":", ln, fixed = TRUE)) {
        pair <- strsplit(ln, ":", fixed = TRUE)[[1]]
        group_name <- trimws(pair[[1]])
        if (nzchar(group_name)) {
          current_name <- group_name
          if (!(current_name %in% out_names)) {
            out_names <- c(out_names, current_name)
            out_items[[current_name]] <- character(0)
          }
          rhs <- trimws(paste(pair[-1], collapse = ":"))
          if (nzchar(rhs)) {
            out_items[[current_name]] <- unique(c(out_items[[current_name]], .split_group_items(rhs)))
          }
          next
        }
      }
      if (is.null(current_name)) {
        current_name <- paste0("Group ", length(out_names) + 1L)
        out_names <- c(out_names, current_name)
        out_items[[current_name]] <- character(0)
      }
      out_items[[current_name]] <- unique(c(out_items[[current_name]], .split_group_items(ln)))
    }
    list(names = out_names, items = out_items)
  }
  .ordered_levels <- function(x) {
    if (is.factor(x)) return(as.character(levels(x)))
    vals <- unique(as.character(x %||% character(0)))
    vals[!is.na(vals) & nzchar(vals)]
  }
  .build_group_overlay <- function(levels_vec, spec_text) {
    levels_vec <- as.character(levels_vec %||% character(0))
    levels_vec <- levels_vec[nzchar(levels_vec)]
    if (!length(levels_vec)) {
      return(list(boundaries = numeric(0), centers = numeric(0), labels = character(0)))
    }
    spec <- .parse_grouping_spec(spec_text)
    if (!length(spec$names)) {
      return(list(boundaries = numeric(0), centers = numeric(0), labels = character(0)))
    }
    available_idx <- seq_along(levels_vec)
    starts <- integer(0)
    ends <- integer(0)
    labels <- character(0)
    for (nm in spec$names) {
      members <- as.character(spec$items[[nm]] %||% character(0))
      members <- members[nzchar(members)]
      if (!length(members)) next
      idx <- match(members, levels_vec)
      idx <- sort(unique(stats::na.omit(idx)))
      idx <- idx[idx %in% available_idx]
      if (!length(idx)) next
      starts <- c(starts, min(idx))
      ends <- c(ends, max(idx))
      labels <- c(labels, nm)
      available_idx <- setdiff(available_idx, idx)
    }
    if (!length(labels)) {
      return(list(boundaries = numeric(0), centers = numeric(0), labels = character(0)))
    }
    ord <- order(starts, ends)
    starts <- starts[ord]
    ends <- ends[ord]
    labels <- labels[ord]
    centers <- (starts + ends) / 2
    boundaries <- numeric(0)
    if (length(starts) >= 2) {
      for (i in seq_len(length(starts) - 1L)) {
        boundaries <- c(boundaries, (ends[[i]] + starts[[i + 1L]]) / 2)
      }
    }
    list(boundaries = boundaries, centers = centers, labels = labels)
  }

  dotplot_gradient_defaults <- c(low = "#D3D3D3", high = "#0000FF")
  dotplot_gradient_state <- reactiveVal(dotplot_gradient_defaults)
  dotplot_gradient_modal_seed <- reactiveVal(dotplot_gradient_defaults)
  dotplot_color_refresh <- reactiveVal(0L)
  dotplot_low_picker <- motion_color_picker_server("dotplot_low_picker", reset_trigger = reactive(input$dotplot_gradient_reset))
  dotplot_high_picker <- motion_color_picker_server("dotplot_high_picker", reset_trigger = reactive(input$dotplot_gradient_reset))
  dataset_select_signature <- reactiveVal("")
  dataset_choices <- reactive({
    names(shared_data$all_seurat_objects %||% list())
  })

  selected_dataset_name <- reactive({
    figure_preferred_object_name(
      registry = shared_data$all_seurat_objects %||% list(),
      current_selection = input$figure_dotplot_dataset_select %||% "",
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
    shiny::freezeReactiveValue(input, "figure_dotplot_dataset_select")
    updateSelectInput(session, "figure_dotplot_dataset_select", choices = object_choices, selected = selected_name)
  })

  observe({
    req(identical(input$main_navbar %||% "", "figure_studio_dotplot"))
    selected_name <- selected_dataset_name()
    req(nzchar(selected_name))
    if (!identical(shared_data$active_object_name %||% "", selected_name)) {
      shared_data$active_object_name <- selected_name
    }
  })

  marker_genes <- reactive({
    obj <- active_object()
    req(obj)
    if (!isTruthy(input$dotplot_gene_list)) {
      withProgress(message = "Finding top 3 marker genes...", {
        grp <- .pick_group_col(obj)
        if (is.null(grp)) return(character(0))
        old_id <- Seurat::Idents(obj)
        on.exit({
          try(Seurat::Idents(obj) <- old_id, silent = TRUE)
        }, add = TRUE)
        Seurat::Idents(obj) <- as.factor(obj@meta.data[[grp]])
        markers <- tryCatch(
          FindAllMarkers(obj, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25, verbose = FALSE),
          error = function(e) data.frame()
        )
        if (!NROW(markers) || !"gene" %in% names(markers)) return(character(0))
        if ("cluster" %in% names(markers) && "avg_log2FC" %in% names(markers)) {
          top_markers <- markers %>%
            dplyr::group_by(.data$cluster) %>%
            dplyr::slice_max(order_by = .data$avg_log2FC, n = 3, with_ties = FALSE) %>%
            dplyr::ungroup()
          return(unique(as.character(top_markers$gene)))
        }
        unique(as.character(markers$gene))[seq_len(min(30, length(unique(as.character(markers$gene)))))]
      })
    }
  })

  output$dotplot_gradient_card_ui <- renderUI({
    figure_color_card_ui(
      title = FIGURE_DOTPLOT_UI_TEXT$t_title_dotplot_gradient_card,
      subtitle = FIGURE_DOTPLOT_UI_TEXT$t_text_dotplot_gradient_subtitle,
      swatch_ui = figure_gradient_swatches_ui(dotplot_gradient_state()),
      button_id = "open_dotplot_gradient_popup",
      button_label = FIGURE_DOTPLOT_UI_TEXT$t_btn_open_dot_picker,
      note = FIGURE_DOTPLOT_UI_TEXT$t_text_dotplot_gradient_note
    )
  })

  observeEvent(input$open_dotplot_gradient_popup, {
    current <- dotplot_gradient_state()
    dotplot_gradient_modal_seed(current)
    showModal(figure_dark_modal_dialog(
      title = FIGURE_DOTPLOT_UI_TEXT$t_title_dot_plot_color_popup,
      size = "l",
      easyClose = TRUE,
      footer = figure_picker_modal_footer(
        reset_id = "dotplot_gradient_reset",
        apply_id = "dotplot_gradient_apply",
        apply_label = FIGURE_DOTPLOT_UI_TEXT$t_btn_apply_colors
      ),
      figure_two_color_modal_body(
        low_picker_id = "dotplot_low_picker",
        high_picker_id = "dotplot_high_picker",
        low_hex = current[["low"]],
        high_hex = current[["high"]],
        low_label = FIGURE_DOTPLOT_UI_TEXT$t_label_color_low_expression,
        high_label = FIGURE_DOTPLOT_UI_TEXT$t_label_color_high_expression
      )
    ))
  }, ignoreInit = TRUE)

  observeEvent(input$dotplot_gradient_apply, {
    dotplot_gradient_state(
      figure_gradient_commit_values(
        low_payload = dotplot_low_picker(),
        high_payload = dotplot_high_picker(),
        defaults = dotplot_gradient_modal_seed()
      )
    )
    if (input$dotplot_generate_btn > 0) {
      dotplot_color_refresh(dotplot_color_refresh() + 1L)
    }
    removeModal()
  }, ignoreInit = TRUE)

  custom_dot_plot <- eventReactive(
    list(input$dotplot_generate_btn, dotplot_color_refresh()),
    {
      req(input$dotplot_generate_btn > 0)
      obj <- active_object()
      req(obj)

      if (isTruthy(input$dotplot_gene_list)) {
        genes_to_plot <- strsplit(input$dotplot_gene_list, "\n")[[1]]
        genes_to_plot <- trimws(genes_to_plot)
        genes_to_plot <- genes_to_plot[nzchar(genes_to_plot)]
      } else {
        genes_to_plot <- marker_genes()
      }

      genes_to_plot <- intersect(genes_to_plot, rownames(obj))
      validate(need(length(genes_to_plot) > 0, "No genes available for dot plot. Provide genes manually or ensure clustering metadata exists."))

      gradient_colors <- dotplot_gradient_state()
      p <- DotPlot(obj, features = genes_to_plot)

      p <- p + scale_color_gradient(low = gradient_colors[["low"]], high = gradient_colors[["high"]]) +
        theme(
          axis.text.x = element_text(angle = as.numeric(input$dotplot_axis_text_angle), hjust = 1, size = input$dotplot_axis_text_size),
          axis.text.y = element_text(size = input$dotplot_axis_text_size)
        )

      x_levels <- .ordered_levels(p$data$id)
      y_levels <- .ordered_levels(p$data$features.plot)
      ident_groups <- .build_group_overlay(x_levels, input$dotplot_identity_groups)
      gene_groups <- .build_group_overlay(y_levels, input$dotplot_gene_groups)
      show_dashes <- isTRUE(input$dotplot_show_group_dashes)
      show_labels <- isTRUE(input$dotplot_show_group_labels)

      if (show_dashes && length(ident_groups$boundaries)) {
        p <- p + geom_vline(
          xintercept = ident_groups$boundaries,
          linetype = "dashed",
          linewidth = 0.45,
          color = "#3A3A3A",
          alpha = 0.9
        )
      }
      if (show_dashes && length(gene_groups$boundaries)) {
        p <- p + geom_hline(
          yintercept = gene_groups$boundaries,
          linetype = "dashed",
          linewidth = 0.45,
          color = "#3A3A3A",
          alpha = 0.9
        )
      }

      if (show_labels && (length(ident_groups$labels) || length(gene_groups$labels))) {
        n_id <- length(x_levels)
        n_gene <- length(y_levels)
        label_size <- max(3, min(6, as.numeric(input$dotplot_axis_text_size %||% 10) / 3))
        if (identical(input$dotplot_orientation, "Vertical")) {
          if (length(ident_groups$labels)) {
            ident_label_df <- data.frame(
              x = ident_groups$centers,
              y = 0.35,
              label = ident_groups$labels,
              stringsAsFactors = FALSE
            )
            p <- p + geom_text(
              data = ident_label_df,
              mapping = aes(x = .data$x, y = .data$y, label = .data$label),
              inherit.aes = FALSE,
              hjust = 1,
              size = label_size,
              fontface = "bold",
              color = "#222222"
            )
          }
          if (length(gene_groups$labels)) {
            gene_label_df <- data.frame(
              x = n_id + 0.8,
              y = gene_groups$centers,
              label = gene_groups$labels,
              stringsAsFactors = FALSE
            )
            p <- p + geom_text(
              data = gene_label_df,
              mapping = aes(x = .data$x, y = .data$y, label = .data$label),
              inherit.aes = FALSE,
              hjust = 0,
              angle = 35,
              size = label_size,
              fontface = "bold",
              color = "#222222"
            )
          }
        } else {
          if (length(ident_groups$labels)) {
            ident_label_df <- data.frame(
              x = ident_groups$centers,
              y = n_gene + 0.8,
              label = ident_groups$labels,
              stringsAsFactors = FALSE
            )
            p <- p + geom_text(
              data = ident_label_df,
              mapping = aes(x = .data$x, y = .data$y, label = .data$label),
              inherit.aes = FALSE,
              hjust = 0,
              angle = 35,
              size = label_size,
              fontface = "bold",
              color = "#222222"
            )
          }
          if (length(gene_groups$labels)) {
            gene_label_df <- data.frame(
              x = 0.35,
              y = gene_groups$centers,
              label = gene_groups$labels,
              stringsAsFactors = FALSE
            )
            p <- p + geom_text(
              data = gene_label_df,
              mapping = aes(x = .data$x, y = .data$y, label = .data$label),
              inherit.aes = FALSE,
              hjust = 1,
              size = label_size,
              fontface = "bold",
              color = "#222222"
            )
          }
        }
      }

      if (input$dotplot_orientation == "Vertical") {
        p <- p + coord_flip(clip = "off")
      } else {
        p <- p + coord_cartesian(clip = "off")
      }
      p <- p + theme(plot.margin = margin(18, 20, 18, 90))

      max_pct <- suppressWarnings(max(p$data$pct.exp, na.rm = TRUE))
      if (is.finite(max_pct) && max_pct > 0) {
        p$data$pct.exp.scaled <- p$data$pct.exp * (input$dotplot_scale / max_pct)
      }
      if (!is.null(p$guides$size)) {
        p$guides$size$range <- c(0, input$dotplot_scale)
      }

      p
    },
    ignoreInit = TRUE
  )

  generated_plot_code <- reactive({
    genes_to_plot <- if (isTruthy(input$dotplot_gene_list)) {
      x <- strsplit(input$dotplot_gene_list, "\n")[[1]]
      x <- trimws(x)
      x[nzchar(x)]
    } else if (isTRUE(input$dotplot_generate_btn > 0)) {
      p_now <- tryCatch(custom_dot_plot(), error = function(e) NULL)
      if (!is.null(p_now) && is.data.frame(p_now$data) && "features.plot" %in% colnames(p_now$data)) {
        unique(as.character(p_now$data$features.plot))
      } else {
        marker_genes()
      }
    } else {
      marker_genes()
    }
    figure_generate_dotplot_script(list(
      object_name = selected_dataset_name(),
      genes = genes_to_plot,
      low_color = dotplot_gradient_state()[["low"]],
      high_color = dotplot_gradient_state()[["high"]],
      orientation = input$dotplot_orientation,
      axis_text_angle = as.numeric(input$dotplot_axis_text_angle %||% 45),
      axis_text_size = input$dotplot_axis_text_size,
      dot_size_max = input$dotplot_scale,
      gene_group_spec = input$dotplot_gene_groups %||% "",
      ident_group_spec = input$dotplot_identity_groups %||% "",
      show_group_dashes = isTRUE(input$dotplot_show_group_dashes),
      show_group_labels = isTRUE(input$dotplot_show_group_labels)
    ))
  })
  figure_code_card_server(
    "figure_dotplot_code_card",
    code_text_reactive = generated_plot_code,
    shared_data = shared_data,
    object_name_reactive = selected_dataset_name,
    studio_name = "Dot Plot Studio"
  )

  output$figure_dotplot_plot <- renderPlot({
    req(input$dotplot_generate_btn > 0)
    custom_dot_plot()
  }, width = function() {
    as.integer(dotplot_preview_dims()$width_px %||% 1152L)
  }, height = function() {
    as.integer(dotplot_preview_dims()$height_px %||% 768L)
  }, res = 96)

  .apply_dotplot_preview <- function() {
    dims <- .normalize_preview_px(
      width_raw = input$figure_dotplot_width,
      height_raw = input$figure_dotplot_height
    )
    dotplot_preview_dims(dims)
    session$sendCustomMessage("wl_figure_preview_fit", list(
      stage_id = "figure_dotplot_preview_stage",
      frame_id = "figure_dotplot_preview_frame",
      width_px = dims$width_px,
      height_px = dims$height_px
    ))
    invisible(dims)
  }

  observeEvent(input$figure_dotplot_apply_preview, {
    .apply_dotplot_preview()
  }, ignoreInit = TRUE)

  observeEvent(input$main_navbar, {
    req(identical(input$main_navbar %||% "", "figure_studio_dotplot"))
    .apply_dotplot_preview()
  }, ignoreInit = FALSE)

  .figure_dotplot_pdf_bundle <- function(kind, width_px = NULL, height_px = NULL) {
    req(identical(kind, "dotplot_pdf"))
    req(input$dotplot_generate_btn > 0)
    p <- custom_dot_plot()
    req(p)
    width_in <- suppressWarnings(as.numeric(input$figure_dotplot_width %||% 12))
    height_in <- suppressWarnings(as.numeric(input$figure_dotplot_height %||% 8))
    if (!is.finite(width_in) || width_in <= 0) width_in <- 12
    if (!is.finite(height_in) || height_in <= 0) height_in <- 8
    if (is.finite(width_px) && width_px > 0) width_in <- width_px / 96
    if (is.finite(height_px) && height_px > 0) height_in <- height_px / 96
    list(
      plot = p,
      width_px = as.integer(max(320, round(width_in * 96))),
      height_px = as.integer(max(240, round(height_in * 96))),
      filename_prefix = paste0(input$figure_dotplot_dataset_select %||% "dataset", "_DotPlot_")
    )
  }

  .pdf_modal_server <- get0("wl_pdf_modal_server", mode = "function", ifnotfound = NULL)
  if (is.null(.pdf_modal_server)) stop("Shared PDF modal helper is unavailable. Please source interface/shared/shared_pdf_export_modal.R first.")
  .figure_dotplot_pdf_modal <- .pdf_modal_server(
    input = input,
    output = output,
    session = session,
    id_prefix = "figure_dotplot_pdf",
    build_bundle = .figure_dotplot_pdf_bundle,
    download_btn_label = FIGURE_DOTPLOT_UI_TEXT$t_btn_download_pdf,
    default_modal_title = "PDF export settings: Dot Plot"
  )

  observeEvent(input$open_dotplot_pdf_modal, {
    req(input$dotplot_generate_btn > 0)
    .figure_dotplot_pdf_modal$open("dotplot_pdf", title_txt = "PDF export settings: Dot Plot")
  }, ignoreInit = TRUE)
}
