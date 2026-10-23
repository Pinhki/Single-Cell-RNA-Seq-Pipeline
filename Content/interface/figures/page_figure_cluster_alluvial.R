# R/page_figure_cluster_alluvial.R
FIGURE_CLUSTER_ALLUVIAL_UI_TEXT <- list(
  t_btn_copy_code = "Copy Code",
  t_btn_download_pdf = "Download PDF",
  t_label_1_select_dataset = "1. Select Dataset:",
  t_label_2_cluster_column = "2. Cluster column:",
  t_label_3_group_column = "3. Group (x-axis):",
  t_label_4_split_column = "4. Split panels by:",
  t_label_cluster_palette = "Cluster colors:",
  t_label_metric = "Metric:",
  t_label_mode = "Display mode:",
  t_label_top_clusters = "Show top clusters:",
  t_label_min_cells = "Min cells per segment:",
  t_label_ribbon_alpha = "Ribbon alpha:",
  t_label_ribbon_width = "Ribbon width:",
  t_label_ribbon_waist = "Ribbon waist (middle shrink):",
  t_label_ribbon_sep_alpha = "Ribbon separator alpha:",
  t_label_ribbon_sep_width = "Ribbon separator width:",
  t_label_border = "Border thickness:",
  t_label_stack_border_color = "Stack border color (hex):",
  t_label_stack_fill_alpha = "Stack fill alpha:",
  t_label_stack_bar_width = "Stack bar width:",
  t_label_show_cluster_labels = "Show cluster labels",
  t_label_cluster_label_size = "Cluster label size:",
  t_label_editable_r_code = "Editable R code:",
  t_label_height = "Height (in):",
  t_label_width = "Width (in):",
  t_text_intro = "Compare cluster composition across condition or metadata groups with stacked strata and optional alluvial ribbons.",
  t_text_code_note_1 = "The generated script includes a workspace import line: bundle <- readRDS('PATH/TO/workspace_bundle.rds').",
  t_text_code_note_2 = "Each configurable parameter line includes an inline comment so users know what to edit.",
  t_text_code_note_3 = "This script is pipeline-independent (Seurat + ggplot2 + workspace object only, no source() helpers).",
  t_text_code_note_4 = "Add custom layers/theme changes under '# 5) Add extra ggplot layers below'.",
  t_text_none = "None",
  t_text_plot_note = "Uses object metadata columns (no external file upload).",
  t_title_cluster_alluvial_plot = "Cluster Alluvial Plot",
  t_title_plot_controls = "Plot Controls",
  t_title_plot_preview = "Plot Preview",
  t_title_custom_r_code = "Customize in R",
  t_title_download_plot = "Download Plot",
  t_title_aesthetics = "Aesthetics"
)

library(ggplot2)
source("interface/figures/color_palettes.R")

figure_cluster_alluvial_ui <- fluidPage(
  tags$head(
    figure_busy_spinner_assets,
    if (is.function(get0("wl_pdf_modal_assets", mode = "function", ifnotfound = NULL))) wl_pdf_modal_assets() else NULL
  ),
  div(
    class = "page-header",
    h2(icon("chart-bar"), " ", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_title_cluster_alluvial_plot),
    p(FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_text_intro)
  ),
  hr(),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      class = "plotting-left-panel",
      style = "padding-top:0;",
      div(
        class = "wl-side",
        h4(FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_title_plot_controls),
        selectInput("figure_cluster_alluvial_dataset_select", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_1_select_dataset, choices = NULL),
        selectInput("figure_cluster_alluvial_cluster_col", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_2_cluster_column, choices = NULL),
        selectInput("figure_cluster_alluvial_group_col", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_3_group_column, choices = NULL),
        selectInput("figure_cluster_alluvial_split_col", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_4_split_column, choices = stats::setNames("__none__", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_text_none)),
        radioButtons(
          "figure_cluster_alluvial_mode",
          FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_mode,
          choices = c("Alluvial + stacked" = "alluvial", "Stacked only" = "stacked"),
          selected = "alluvial",
          inline = TRUE
        ),
        radioButtons(
          "figure_cluster_alluvial_metric",
          FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_metric,
          choices = c("Ratio" = "ratio", "Cells" = "count"),
          selected = "ratio",
          inline = TRUE
        ),
        sliderInput("figure_cluster_alluvial_top_n", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_top_clusters, min = 3, max = 50, value = 15, step = 1),
        sliderInput("figure_cluster_alluvial_min_cells", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_min_cells, min = 1, max = 100, value = 1, step = 1),
        hr(),
        h5(FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_title_aesthetics),
        selectInput(
          "figure_cluster_alluvial_cluster_palette",
          FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_cluster_palette,
          choices = c("Object cluster colors", "Default Seurat", names(all_palettes)),
          selected = "Object cluster colors"
        ),
        sliderInput("figure_cluster_alluvial_alpha", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_ribbon_alpha, min = 0.1, max = 1, value = 0.45, step = 0.05),
        sliderInput("figure_cluster_alluvial_ribbon_width", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_ribbon_width, min = 0.05, max = 0.8, value = 0.28, step = 0.01),
        sliderInput("figure_cluster_alluvial_ribbon_waist", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_ribbon_waist, min = 0.05, max = 0.45, value = 0.22, step = 0.01),
        sliderInput("figure_cluster_alluvial_ribbon_sep_alpha", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_ribbon_sep_alpha, min = 0, max = 1, value = 0.18, step = 0.01),
        sliderInput("figure_cluster_alluvial_ribbon_sep_width", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_ribbon_sep_width, min = 0, max = 1, value = 0.25, step = 0.01),
        sliderInput("figure_cluster_alluvial_border", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_border, min = 0, max = 1, value = 0.15, step = 0.01),
        textInput("figure_cluster_alluvial_stack_border_color", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_stack_border_color, value = "#4D4D4D"),
        sliderInput("figure_cluster_alluvial_stack_fill_alpha", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_stack_fill_alpha, min = 0.1, max = 1, value = 1, step = 0.05),
        sliderInput("figure_cluster_alluvial_stack_bar_width", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_stack_bar_width, min = 0.2, max = 1, value = 0.85, step = 0.01),
        checkboxInput("figure_cluster_alluvial_show_labels", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_show_cluster_labels, value = FALSE),
        sliderInput("figure_cluster_alluvial_label_size", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_cluster_label_size, min = 1, max = 8, value = 2.4, step = 0.2),
        hr(),
        h4(FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_title_download_plot),
        wellPanel(
          fluidRow(
            column(6, numericInput("figure_cluster_alluvial_width", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_width, value = 12)),
            column(6, numericInput("figure_cluster_alluvial_height", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_height, value = 8))
          )
        ),
        actionButton("open_cluster_alluvial_pdf_modal", FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_btn_download_pdf, class = "btn btn-default"),
        hr(),
        p(class = "text-muted", em(FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_text_plot_note))
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
          h4(FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_title_plot_preview),
          figure_with_busy_spinner(plotOutput("figure_cluster_alluvial_plot", height = "calc(var(--plot-scroll-box-h) - 82px)"))
        ),
        div(
          style = "margin-top:12px;",
          figure_code_card_ui(
            id = "figure_cluster_alluvial_code_card",
            title = FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_title_custom_r_code,
            notes = c(
              FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_text_code_note_1,
              FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_text_code_note_2,
              FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_text_code_note_3,
              FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_text_code_note_4
            ),
            copy_button_label = FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_btn_copy_code,
            code_label = FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_label_editable_r_code
          )
        )
      )
    )
  )
)

figure_cluster_alluvial_server <- function(input, output, session, shared_data) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  dataset_select_signature <- reactiveVal("")
  cluster_select_signature <- reactiveVal("")
  group_select_signature <- reactiveVal("")
  split_select_signature <- reactiveVal("")

  dataset_choices <- reactive({
    names(shared_data$all_seurat_objects %||% list())
  })

  selected_dataset_name <- reactive({
    figure_preferred_object_name(
      registry = shared_data$all_seurat_objects %||% list(),
      current_selection = input$figure_cluster_alluvial_dataset_select %||% "",
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
    if (!figure_select_input_needs_update(dataset_select_signature(), object_choices, selected_name)) return(invisible(NULL))
    dataset_select_signature(figure_select_input_signature(object_choices, selected_name))
    shiny::freezeReactiveValue(input, "figure_cluster_alluvial_dataset_select")
    updateSelectInput(session, "figure_cluster_alluvial_dataset_select", choices = object_choices, selected = selected_name)
  })

  observe({
    req(identical(input$main_navbar %||% "", "figure_studio_cluster_alluvial"))
    selected_name <- selected_dataset_name()
    req(nzchar(selected_name))
    if (!identical(shared_data$active_object_name %||% "", selected_name)) {
      shared_data$active_object_name <- selected_name
    }
  })

  .preferred_cluster_col <- function(md) {
    cols <- colnames(md %||% data.frame())
    cand <- c("seurat_clusters", "cluster", "celltype", "cell_type", "annotation", "orig.ident")
    hit <- cand[cand %in% cols]
    if (length(hit)) hit[[1]] else if (length(cols)) cols[[1]] else ""
  }
  .preferred_group_col <- function(md) {
    cols <- colnames(md %||% data.frame())
    cand <- c("orig.ident", "condition", "group", "sample", "sample_name")
    hit <- cand[cand %in% cols]
    if (length(hit)) hit[[1]] else if (length(cols)) cols[[1]] else ""
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
    selected <- input$figure_cluster_alluvial_cluster_col %||% .preferred_cluster_col(md)
    if (!(selected %in% choices)) selected <- .preferred_cluster_col(md)
    if (!figure_select_input_needs_update(cluster_select_signature(), choices, selected)) return(invisible(NULL))
    cluster_select_signature(figure_select_input_signature(choices, selected))
    shiny::freezeReactiveValue(input, "figure_cluster_alluvial_cluster_col")
    updateSelectInput(session, "figure_cluster_alluvial_cluster_col", choices = choices, selected = selected)
  })

  observe({
    obj <- active_object()
    req(obj)
    md <- obj@meta.data
    cols <- colnames(md %||% data.frame())
    choices <- cols[nzchar(cols)]
    req(length(choices) > 0)
    selected <- input$figure_cluster_alluvial_group_col %||% .preferred_group_col(md)
    if (!(selected %in% choices)) selected <- .preferred_group_col(md)
    if (!figure_select_input_needs_update(group_select_signature(), choices, selected)) return(invisible(NULL))
    group_select_signature(figure_select_input_signature(choices, selected))
    shiny::freezeReactiveValue(input, "figure_cluster_alluvial_group_col")
    updateSelectInput(session, "figure_cluster_alluvial_group_col", choices = choices, selected = selected)
  })

  observe({
    obj <- active_object()
    req(obj)
    md <- obj@meta.data
    group_col <- input$figure_cluster_alluvial_group_col %||% .preferred_group_col(md)
    choices <- figure_split_choices(md, exclude = group_col)
    selected <- input$figure_cluster_alluvial_split_col %||% "__none__"
    if (!(selected %in% unname(choices))) selected <- "__none__"
    if (!figure_select_input_needs_update(split_select_signature(), unname(choices), selected)) return(invisible(NULL))
    split_select_signature(figure_select_input_signature(unname(choices), selected))
    shiny::freezeReactiveValue(input, "figure_cluster_alluvial_split_col")
    updateSelectInput(session, "figure_cluster_alluvial_split_col", choices = choices, selected = selected)
  })

  .build_cluster_alluvial_df <- reactive({
    obj <- active_object()
    req(obj)
    md <- obj@meta.data
    validate(need(is.data.frame(md) && nrow(md) > 0, "Selected object has no metadata rows."))

    cluster_col <- input$figure_cluster_alluvial_cluster_col %||% .preferred_cluster_col(md)
    group_col <- input$figure_cluster_alluvial_group_col %||% .preferred_group_col(md)
    split_col <- figure_normalize_split_value(input$figure_cluster_alluvial_split_col)

    validate(need(nzchar(cluster_col) && cluster_col %in% colnames(md), "Cluster column is not available in this object."))
    validate(need(nzchar(group_col) && group_col %in% colnames(md), "Group column is not available in this object."))
    if (!is.null(split_col) && !(split_col %in% colnames(md))) split_col <- NULL

    cluster_vals <- as.character(md[[cluster_col]] %||% "")
    cluster_vals[is.na(cluster_vals) | !nzchar(cluster_vals)] <- "Unknown"

    group_vals <- as.character(md[[group_col]] %||% "")
    group_vals[is.na(group_vals) | !nzchar(group_vals)] <- "Unknown"
    group_levels <- if (is.factor(md[[group_col]])) levels(md[[group_col]]) else sort(unique(group_vals), method = "radix")
    group_levels <- unique(as.character(group_levels))
    group_levels <- group_levels[group_levels %in% group_vals]
    if (!length(group_levels)) group_levels <- sort(unique(group_vals), method = "radix")
    if (.is_orig_ident_col(group_col)) group_levels <- figure_sort_facet_levels(group_vals)

    if (is.null(split_col)) {
      split_vals <- rep("All cells", length(cluster_vals))
      split_levels <- "All cells"
    } else {
      split_vals <- as.character(md[[split_col]] %||% "")
      split_vals[is.na(split_vals) | !nzchar(split_vals)] <- "Unknown"
      split_levels <- if (is.factor(md[[split_col]])) levels(md[[split_col]]) else sort(unique(split_vals), method = "radix")
      split_levels <- unique(as.character(split_levels))
      split_levels <- split_levels[split_levels %in% split_vals]
      if (!length(split_levels)) split_levels <- sort(unique(split_vals), method = "radix")
      if (.is_orig_ident_col(split_col)) split_levels <- figure_sort_facet_levels(split_vals)
    }

    df <- data.frame(
      split = split_vals,
      group = group_vals,
      cluster = cluster_vals,
      stringsAsFactors = FALSE
    )

    df_counts <- dplyr::count(df, .data$split, .data$group, .data$cluster, name = "n_cells")
    min_cells <- as.integer(input$figure_cluster_alluvial_min_cells %||% 1)
    if (!is.finite(min_cells) || min_cells < 1L) min_cells <- 1L
    df_counts <- df_counts[df_counts$n_cells >= min_cells, , drop = FALSE]
    validate(need(nrow(df_counts) > 0, "No segments remain after min-cells filtering."))

    top_n <- as.integer(input$figure_cluster_alluvial_top_n %||% 15)
    if (!is.finite(top_n) || top_n < 1L) top_n <- 15L
    top_clusters <- df_counts |>
      dplyr::group_by(.data$cluster) |>
      dplyr::summarise(total = sum(.data$n_cells), .groups = "drop") |>
      dplyr::arrange(dplyr::desc(.data$total), .data$cluster) |>
      dplyr::slice_head(n = top_n) |>
      dplyr::pull(.data$cluster)
    df_counts <- df_counts[df_counts$cluster %in% top_clusters, , drop = FALSE]
    validate(need(nrow(df_counts) > 0, "No segments remain after top-cluster filtering."))

    cluster_levels <- df_counts |>
      dplyr::group_by(.data$cluster) |>
      dplyr::summarise(total = sum(.data$n_cells), .groups = "drop") |>
      dplyr::arrange(dplyr::desc(.data$total), .data$cluster) |>
      dplyr::pull(.data$cluster)

    df_counts$split <- factor(as.character(df_counts$split), levels = split_levels)
    df_counts$group <- factor(as.character(df_counts$group), levels = group_levels)
    df_counts$cluster <- factor(as.character(df_counts$cluster), levels = cluster_levels)

    metric <- as.character(input$figure_cluster_alluvial_metric %||% "ratio")
    if (identical(metric, "ratio")) {
      df_counts <- df_counts |>
        dplyr::group_by(.data$split, .data$group) |>
        dplyr::mutate(value = .data$n_cells / sum(.data$n_cells)) |>
        dplyr::ungroup()
    } else {
      df_counts$value <- as.numeric(df_counts$n_cells)
    }

    list(
      counts = df_counts,
      cluster_levels = cluster_levels,
      cluster_col = cluster_col,
      split_col = split_col,
      metric = metric
    )
  })

  .compose_cluster_alluvial_plot <- reactive({
    validate(need(requireNamespace("ggalluvial", quietly = TRUE), "Package 'ggalluvial' is required for this plot. Please install/update dependencies in run.R bootstrap."))
    bundle <- .build_cluster_alluvial_df()
    df_counts <- bundle$counts
    cluster_levels <- bundle$cluster_levels

    .seurat_discrete_palette <- function(n) {
      n <- suppressWarnings(as.integer(n))
      if (!is.finite(n) || n < 1L) return(character(0))
      fn <- tryCatch(getFromNamespace("DiscretePalette", "Seurat"), error = function(e) NULL)
      cols <- tryCatch(if (is.function(fn)) as.character(fn(n)) else character(0), error = function(e) character(0))
      if (length(cols) < n) cols <- scales::hue_pal()(n)
      cols[seq_len(n)]
    }
    .cluster_colors_from_dimplot <- function(sobj, group_col, levels_vec) {
      if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
      if (!nzchar(group_col) || !(group_col %in% colnames(sobj@meta.data))) return(NULL)
      red_use <- figure_resolve_reduction_name(sobj, "umap")
      if (!nzchar(red_use)) return(NULL)
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

    seurat_pal <- stats::setNames(.seurat_discrete_palette(length(cluster_levels)), cluster_levels)
    object_pal <- .cluster_colors_from_dimplot(active_object(), bundle$cluster_col, cluster_levels)
    if (is.null(object_pal) || !length(object_pal)) object_pal <- seurat_pal
    if (any(is.na(object_pal) | !nzchar(object_pal))) {
      idx <- is.na(object_pal) | !nzchar(object_pal)
      object_pal[idx] <- seurat_pal[idx]
    }
    palette_mode <- as.character(input$figure_cluster_alluvial_cluster_palette %||% "Object cluster colors")
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

    mode <- as.character(input$figure_cluster_alluvial_mode %||% "alluvial")
    border_w <- as.numeric(input$figure_cluster_alluvial_border %||% 0.15)
    if (!is.finite(border_w) || border_w < 0) border_w <- 0.15
    stack_alpha <- as.numeric(input$figure_cluster_alluvial_stack_fill_alpha %||% 1)
    if (!is.finite(stack_alpha) || stack_alpha <= 0 || stack_alpha > 1) stack_alpha <- 1
    stack_bar_w <- as.numeric(input$figure_cluster_alluvial_stack_bar_width %||% 0.85)
    if (!is.finite(stack_bar_w) || stack_bar_w <= 0 || stack_bar_w > 1) stack_bar_w <- 0.85
    stack_border_col <- as.character(input$figure_cluster_alluvial_stack_border_color %||% "#4D4D4D")
    if (!isTRUE(grepl("^#(?:[A-Fa-f0-9]{3}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$", stack_border_col))) {
      stack_border_col <- "#4D4D4D"
    }

    p <- ggplot(df_counts, aes(x = .data$group, y = .data$value, fill = .data$cluster))
    if (identical(mode, "stacked")) {
      p <- p + geom_col(color = stack_border_col, linewidth = border_w, width = stack_bar_w, alpha = stack_alpha)
      if (isTRUE(input$figure_cluster_alluvial_show_labels)) {
        p <- p + geom_text(
          aes(label = .data$cluster),
          position = position_stack(vjust = 0.5),
          size = as.numeric(input$figure_cluster_alluvial_label_size %||% 2.4),
          check_overlap = TRUE
        )
      }
    } else {
      alluvium_w <- as.numeric(input$figure_cluster_alluvial_ribbon_width %||% 0.28)
      if (!is.finite(alluvium_w) || alluvium_w <= 0) alluvium_w <- 0.28
      waist <- as.numeric(input$figure_cluster_alluvial_ribbon_waist %||% 0.22)
      if (!is.finite(waist) || waist < 0.01 || waist > 0.49) waist <- 0.22
      sep_alpha <- as.numeric(input$figure_cluster_alluvial_ribbon_sep_alpha %||% 0.18)
      if (!is.finite(sep_alpha) || sep_alpha < 0 || sep_alpha > 1) sep_alpha <- 0.18
      sep_width <- as.numeric(input$figure_cluster_alluvial_ribbon_sep_width %||% 0.25)
      if (!is.finite(sep_width) || sep_width < 0) sep_width <- 0.25
      p <- p +
        ggalluvial::geom_alluvium(
          aes(stratum = .data$cluster, alluvium = .data$cluster),
          alpha = as.numeric(input$figure_cluster_alluvial_alpha %||% 0.45),
          width = alluvium_w,
          curve_type = "xspline",
          knot.pos = waist,
          color = scales::alpha("#FFFFFF", sep_alpha),
          linewidth = sep_width,
          linetype = 1
        ) +
        ggalluvial::geom_stratum(
          aes(stratum = .data$cluster),
          color = stack_border_col,
          linewidth = border_w,
          width = alluvium_w,
          alpha = stack_alpha
        )
      if (isTRUE(input$figure_cluster_alluvial_show_labels)) {
        p <- p + ggplot2::geom_text(
          stat = "stratum",
          aes(label = after_stat(stratum)),
          size = as.numeric(input$figure_cluster_alluvial_label_size %||% 2.4),
          check_overlap = TRUE
        )
      }
    }

    if (length(unique(as.character(df_counts$split))) > 1L) {
      p <- p + facet_wrap(~split, scales = if (identical(bundle$metric, "ratio")) "fixed" else "free_y", drop = FALSE)
    }

    p <- p +
      scale_fill_manual(values = cluster_pal, drop = FALSE) +
      theme_classic(base_size = 12) +
      theme(
        plot.margin = margin(8, 10, 8, 8),
        axis.text.x = element_text(angle = 30, hjust = 1),
        legend.position = "right"
      ) +
      labs(
        title = "Cluster alluvial / stacked composition",
        x = NULL,
        y = if (identical(bundle$metric, "ratio")) "Ratio" else "Cells",
        fill = NULL
      )

    if (identical(bundle$metric, "ratio")) {
      p <- p + scale_y_continuous(labels = scales::percent_format(accuracy = 1), expand = expansion(mult = c(0, 0.02)))
    } else {
      p <- p + scale_y_continuous(labels = scales::comma)
    }

    p
  })

  output$figure_cluster_alluvial_plot <- renderPlot({
    tryCatch(
      .compose_cluster_alluvial_plot(),
      error = function(e) {
        plot.new()
        title(main = "Cluster Alluvial Plot Error")
        text(0.5, 0.58, labels = "Could not render cluster alluvial plot.", cex = 1)
        text(0.5, 0.46, labels = tryCatch(conditionMessage(e), error = function(e2) "Unknown plotting error"), cex = 0.8)
        invisible(NULL)
      }
    )
  })

  generated_plot_code <- reactive({
    figure_generate_cluster_alluvial_script(list(
      object_name = selected_dataset_name(),
      cluster_col = input$figure_cluster_alluvial_cluster_col,
      group_col = input$figure_cluster_alluvial_group_col,
      split_col = figure_normalize_split_value(input$figure_cluster_alluvial_split_col),
      metric = input$figure_cluster_alluvial_metric,
      mode = input$figure_cluster_alluvial_mode,
      top_n = input$figure_cluster_alluvial_top_n,
      min_cells = input$figure_cluster_alluvial_min_cells,
      alpha = input$figure_cluster_alluvial_alpha,
      ribbon_width = input$figure_cluster_alluvial_ribbon_width,
      stack_bar_width = input$figure_cluster_alluvial_stack_bar_width,
      stack_fill_alpha = input$figure_cluster_alluvial_stack_fill_alpha,
      cluster_palette = input$figure_cluster_alluvial_cluster_palette
    ))
  })
  figure_code_card_server(
    "figure_cluster_alluvial_code_card",
    code_text_reactive = generated_plot_code,
    shared_data = shared_data,
    object_name_reactive = selected_dataset_name,
    studio_name = "Cluster Alluvial Studio"
  )

  .figure_cluster_alluvial_pdf_bundle <- function(kind, width_px = NULL, height_px = NULL) {
    req(identical(kind, "cluster_alluvial_pdf"))
    p <- .compose_cluster_alluvial_plot()
    req(p)
    width_in <- suppressWarnings(as.numeric(input$figure_cluster_alluvial_width %||% 12))
    height_in <- suppressWarnings(as.numeric(input$figure_cluster_alluvial_height %||% 8))
    if (!is.finite(width_in) || width_in <= 0) width_in <- 12
    if (!is.finite(height_in) || height_in <= 0) height_in <- 8
    if (is.finite(width_px) && width_px > 0) width_in <- width_px / 96
    if (is.finite(height_px) && height_px > 0) height_in <- height_px / 96
    list(
      plot = p,
      width_px = as.integer(max(320, round(width_in * 96))),
      height_px = as.integer(max(240, round(height_in * 96))),
      filename_prefix = paste0(selected_dataset_name() %||% "dataset", "_Cluster_Alluvial_")
    )
  }

  .pdf_modal_server <- get0("wl_pdf_modal_server", mode = "function", ifnotfound = NULL)
  if (is.null(.pdf_modal_server)) {
    stop("Shared PDF modal helper is unavailable. Please source interface/shared/shared_pdf_export_modal.R first.")
  }
  .figure_cluster_alluvial_pdf_modal <- .pdf_modal_server(
    input = input,
    output = output,
    session = session,
    id_prefix = "figure_cluster_alluvial_pdf",
    build_bundle = .figure_cluster_alluvial_pdf_bundle,
    download_btn_label = FIGURE_CLUSTER_ALLUVIAL_UI_TEXT$t_btn_download_pdf,
    default_modal_title = "PDF export settings: Cluster Alluvial Plot"
  )
  observeEvent(input$open_cluster_alluvial_pdf_modal, {
    .figure_cluster_alluvial_pdf_modal$open("cluster_alluvial_pdf", title_txt = "PDF export settings: Cluster Alluvial Plot")
  }, ignoreInit = TRUE)
}
