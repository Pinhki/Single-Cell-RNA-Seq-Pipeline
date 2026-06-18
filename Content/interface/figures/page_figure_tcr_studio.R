# R/page_figure_tcr_studio.R
FIGURE_TCR_STUDIO_UI_TEXT <- list(
  t_btn_copy_code = "Copy Code",
  t_btn_download_pdf = "Download PDF",
  t_label_1_select_dataset = "1. Select Dataset:",
  t_label_2_chain = "2. Chain Mode:",
  t_label_3_clone_column = "3. Clone column (ID):",
  t_label_4_condition_column = "4. Condition / Group:",
  t_label_5_plot_type = "5. Plot Type:",
  t_label_show_top_clonotypes = "Show top clonotypes (N):",
  t_label_plot_title = "Plot Title:",
  t_label_theme_choice = "Theme choice:",
  t_label_legend_position = "Legend position:",
  t_label_height = "Height (in):",
  t_label_width = "Width (in):",
  t_label_editable_r_code = "Editable R code:",
  t_text_intro = "Generate publication-ready plots for TCR/BCR clone expansion across conditions, including Stacked Bar plots, Clone Tracking line plots, and Facet UMAP plots.",
  t_text_plot_note = "Uses active object metadata columns. Make sure VDJ data has been applied.",
  t_title_tcr_studio = "TCR/BCR Studio",
  t_title_plot_controls = "Plot Controls",
  t_title_aesthetics = "Aesthetics",
  t_title_plot_preview = "Plot Preview",
  t_title_custom_r_code = "Customize in R",
  t_title_download_plot = "Download Plot"
)

library(ggplot2)
source("interface/figures/color_palettes.R")

figure_tcr_studio_ui <- fluidPage(
  tags$head(
    figure_busy_spinner_assets,
    if (is.function(get0("wl_pdf_modal_assets", mode = "function", ifnotfound = NULL))) wl_pdf_modal_assets() else NULL
  ),
  div(
    class = "page-header",
    h2(icon("bezier-curve"), " ", FIGURE_TCR_STUDIO_UI_TEXT$t_title_tcr_studio),
    p(FIGURE_TCR_STUDIO_UI_TEXT$t_text_intro)
  ),
  hr(),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      class = "plotting-left-panel",
      style = "padding-top:0;",
      div(
        class = "wl-side",
        h4(FIGURE_TCR_STUDIO_UI_TEXT$t_title_plot_controls),
        selectInput("figure_tcr_studio_dataset_select", FIGURE_TCR_STUDIO_UI_TEXT$t_label_1_select_dataset, choices = NULL),
        radioButtons(
          "figure_tcr_studio_chain",
          FIGURE_TCR_STUDIO_UI_TEXT$t_label_2_chain,
          choices = c("TCR" = "tcr", "BCR" = "bcr"),
          selected = "tcr",
          inline = TRUE
        ),
        selectInput("figure_tcr_studio_clone_col", FIGURE_TCR_STUDIO_UI_TEXT$t_label_3_clone_column, choices = NULL),
        selectInput("figure_tcr_studio_condition_col", FIGURE_TCR_STUDIO_UI_TEXT$t_label_4_condition_column, choices = NULL),
        selectInput(
          "figure_tcr_studio_plot_type",
          FIGURE_TCR_STUDIO_UI_TEXT$t_label_5_plot_type,
          choices = c(
            "Stacked Bar Plot" = "stacked_bar",
            "Clone Frequency Tracking" = "tracking_line",
            "Facet UMAP Highlight" = "facet_umap"
          ),
          selected = "stacked_bar"
        ),
        sliderInput("figure_tcr_studio_top_n", FIGURE_TCR_STUDIO_UI_TEXT$t_label_show_top_clonotypes, min = 5, max = 50, value = 15, step = 1),
        hr(),
        h5(FIGURE_TCR_STUDIO_UI_TEXT$t_title_aesthetics),
        textInput("figure_tcr_studio_title", FIGURE_TCR_STUDIO_UI_TEXT$t_label_plot_title, value = ""),
        selectInput(
          "figure_tcr_studio_palette",
          "Color Palette:",
          choices = c("Default Seurat", names(all_palettes)),
          selected = "Brewer: Set2"
        ),
        selectInput(
          "figure_tcr_studio_theme",
          FIGURE_TCR_STUDIO_UI_TEXT$t_label_theme_choice,
          choices = c("Classic" = "theme_classic", "Minimal" = "theme_minimal", "Black & White" = "theme_bw"),
          selected = "theme_classic"
        ),
        selectInput(
          "figure_tcr_studio_legend_pos",
          FIGURE_TCR_STUDIO_UI_TEXT$t_label_legend_position,
          choices = c("right", "left", "top", "bottom", "none"),
          selected = "right"
        ),
        hr(),
        h4(FIGURE_TCR_STUDIO_UI_TEXT$t_title_download_plot),
        wellPanel(
          fluidRow(
            column(6, numericInput("figure_tcr_studio_width", FIGURE_TCR_STUDIO_UI_TEXT$t_label_width, value = 10)),
            column(6, numericInput("figure_tcr_studio_height", FIGURE_TCR_STUDIO_UI_TEXT$t_label_height, value = 6))
          )
        ),
        actionButton("open_tcr_studio_pdf_modal", FIGURE_TCR_STUDIO_UI_TEXT$t_btn_download_pdf, class = "btn btn-default"),
        hr(),
        p(class = "text-muted", em(FIGURE_TCR_STUDIO_UI_TEXT$t_text_plot_note))
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
          h4(FIGURE_TCR_STUDIO_UI_TEXT$t_title_plot_preview),
          figure_with_busy_spinner(plotOutput("figure_tcr_studio_plot", height = "calc(var(--plot-scroll-box-h) - 82px)"))
        ),
        div(
          style = "margin-top:12px;",
          figure_code_card_ui(
            id = "figure_tcr_studio_code_card",
            title = FIGURE_TCR_STUDIO_UI_TEXT$t_title_custom_r_code,
            notes = c(
              "The generated script includes a workspace import line: bundle <- readRDS('PATH/TO/workspace_bundle.rds').",
              "Each configurable parameter line includes an inline comment so users know what to edit.",
              "This script is pipeline-independent (Seurat + ggplot2 + workspace object only, no source() helpers)."
            ),
            copy_button_label = FIGURE_TCR_STUDIO_UI_TEXT$t_btn_copy_code,
            code_label = FIGURE_TCR_STUDIO_UI_TEXT$t_label_editable_r_code
          )
        )
      )
    )
  )
)

figure_tcr_studio_server <- function(input, output, session, shared_data) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  
  dataset_select_signature <- reactiveVal("")
  clone_select_signature <- reactiveVal("")
  condition_select_signature <- reactiveVal("")
  
  dataset_choices <- reactive({
    names(shared_data$all_seurat_objects %||% list())
  })
  
  selected_dataset_name <- reactive({
    figure_preferred_object_name(
      registry = shared_data$all_seurat_objects %||% list(),
      current_selection = input$figure_tcr_studio_dataset_select %||% "",
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
    shiny::freezeReactiveValue(input, "figure_tcr_studio_dataset_select")
    updateSelectInput(session, "figure_tcr_studio_dataset_select", choices = object_choices, selected = selected_name)
  })
  
  observe({
    req(active_object())
    req(identical(input$main_navbar %||% "", "figure_studio_tcr_studio"))
    selected_name <- selected_dataset_name()
    req(nzchar(selected_name))
    if (!identical(shared_data$active_object_name %||% "", selected_name)) {
      shared_data$active_object_name <- selected_name
    }
  })
  
  .preferred_clone_col <- function(md, mode = "tcr") {
    cols <- colnames(md %||% data.frame())
    cand <- if (identical(mode, "bcr")) {
      c("vdj_bcr_clone", "bcr_clone", "clone_bcr", "cdr3_bcr", "cdr3")
    } else {
      c("vdj_tcr_clone", "tcr_clone", "clone_tcr", "cdr3_tcr", "cdr3")
    }
    hit <- cand[cand %in% cols]
    if (length(hit)) hit[[1]] else if (length(cols)) cols[[1]] else ""
  }
  
  .preferred_condition_col <- function(md) {
    cols <- colnames(md %||% data.frame())
    cand <- c("condition", "sample", "orig.ident", "group", "treatment")
    hit <- cand[cand %in% cols]
    if (length(hit)) hit[[1]] else if (length(cols)) cols[[1]] else ""
  }
  
  observe({
    obj <- active_object()
    req(obj)
    md <- obj@meta.data
    cols <- colnames(md %||% data.frame())
    choices <- cols[nzchar(cols)]
    req(length(choices) > 0)
    
    selected_clone <- input$figure_tcr_studio_clone_col %||% .preferred_clone_col(md, input$figure_tcr_studio_chain)
    if (!(selected_clone %in% choices)) selected_clone <- .preferred_clone_col(md, input$figure_tcr_studio_chain)
    
    if (figure_select_input_needs_update(clone_select_signature(), choices, selected_clone)) {
      clone_select_signature(figure_select_input_signature(choices, selected_clone))
      shiny::freezeReactiveValue(input, "figure_tcr_studio_clone_col")
      updateSelectInput(session, "figure_tcr_studio_clone_col", choices = choices, selected = selected_clone)
    }
  })
  
  observe({
    obj <- active_object()
    req(obj)
    md <- obj@meta.data
    cols <- colnames(md %||% data.frame())
    choices <- cols[nzchar(cols)]
    req(length(choices) > 0)
    
    selected_cond <- input$figure_tcr_studio_condition_col %||% .preferred_condition_col(md)
    if (!(selected_cond %in% choices)) selected_cond <- .preferred_condition_col(md)
    
    if (figure_select_input_needs_update(condition_select_signature(), choices, selected_cond)) {
      condition_select_signature(figure_select_input_signature(choices, selected_cond))
      shiny::freezeReactiveValue(input, "figure_tcr_studio_condition_col")
      updateSelectInput(session, "figure_tcr_studio_condition_col", choices = choices, selected = selected_cond)
    }
  })
  
  .compose_tcr_studio_plot <- reactive({
    obj <- active_object()
    req(obj)
    md <- obj@meta.data
    validate(need(is.data.frame(md) && nrow(md) > 0, "Selected object has no metadata rows."))
    
    clone_col <- input$figure_tcr_studio_clone_col
    cond_col <- input$figure_tcr_studio_condition_col
    plot_type <- input$figure_tcr_studio_plot_type
    top_n <- as.integer(input$figure_tcr_studio_top_n %||% 15)
    
    validate(need(nzchar(clone_col) && clone_col %in% colnames(md), "Clone column is not available in this object."))
    validate(need(nzchar(cond_col) && cond_col %in% colnames(md), "Condition column is not available in this object."))
    
    # Extract clone and condition values
    clones <- as.character(md[[clone_col]] %||% "")
    conds <- as.character(md[[cond_col]] %||% "")
    
    # Filter out empty or unknown clones
    valid_idx <- which(nzchar(clones) & clones != "unknown" & clones != "0" & !is.na(clones))
    validate(need(length(valid_idx) > 0, "No cells with valid TCR/BCR clone annotations found."))
    
    df <- data.frame(
      cell = rownames(md)[valid_idx],
      clone = clones[valid_idx],
      condition = conds[valid_idx],
      stringsAsFactors = FALSE
    )
    
    # Calculate top clones by total cell count
    clone_counts <- df |>
      dplyr::count(clone, name = "total_cells") |>
      dplyr::arrange(desc(total_cells))
    
    top_clones <- head(clone_counts$clone, top_n)
    
    # Group remaining clones as 'Others'
    df$plot_clone <- ifelse(df$clone %in% top_clones, df$clone, "Others")
    df$plot_clone <- factor(df$plot_clone, levels = c(top_clones, "Others"))
    
    # Resolve color palette
    pal_name <- input$figure_tcr_studio_palette %||% "Brewer: Set2"
    colors <- if (identical(pal_name, "Default Seurat")) {
      scales::hue_pal()(length(top_clones) + 1)
    } else {
      base_pal <- all_palettes[[pal_name]]
      if (length(base_pal) < (length(top_clones) + 1)) {
        grDevices::colorRampPalette(base_pal)(length(top_clones) + 1)
      } else {
        base_pal[seq_len(length(top_clones) + 1)]
      }
    }
    # Color "Others" gray
    colors[length(colors)] <- "#D1D5DB"
    names(colors) <- c(top_clones, "Others")
    
    theme_choice <- input$figure_tcr_studio_theme %||% "theme_classic"
    legend_pos <- input$figure_tcr_studio_legend_pos %||% "right"
    plot_title <- input$figure_tcr_studio_title %||% ""
    
    theme_fn <- get0(theme_choice, envir = asNamespace("ggplot2"))
    
    if (identical(plot_type, "stacked_bar")) {
      # Stacked Bar Plot: count or proportion of clones across conditions
      plot_df <- df |>
        dplyr::count(condition, plot_clone) |>
        dplyr::group_by(condition) |>
        dplyr::mutate(proportion = n / sum(n)) |>
        dplyr::ungroup()
      
      p <- ggplot(plot_df, aes(x = condition, y = proportion, fill = plot_clone)) +
        geom_col(color = "#4D4D4D", linewidth = 0.15, width = 0.7) +
        scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
        labs(
          title = if (nzchar(plot_title)) plot_title else paste("Clonotype Composition across", cond_col),
          x = cond_col,
          y = "Percentage",
          fill = "Clone ID"
        )
      
    } else if (identical(plot_type, "tracking_line")) {
      # Tracking Line: trace frequency changes
      plot_df <- df |>
        dplyr::count(condition, plot_clone) |>
        dplyr::group_by(condition) |>
        dplyr::mutate(proportion = n / sum(n)) |>
        dplyr::ungroup()
      
      # Filter out "Others" for cleaner tracking of specific top clones
      plot_df <- plot_df[plot_df$plot_clone != "Others", ]
      
      p <- ggplot(plot_df, aes(x = condition, y = proportion, group = plot_clone, color = plot_clone)) +
        geom_line(linewidth = 1) +
        geom_point(size = 3) +
        scale_y_continuous(labels = scales::percent_format(accuracy = 0.1)) +
        labs(
          title = if (nzchar(plot_title)) plot_title else paste("TCR/BCR Clonal Frequencies across", cond_col),
          x = cond_col,
          y = "Frequency in VDJ repertoire",
          color = "Clone ID"
        )
      
    } else {
      # Facet UMAP highlight
      reds <- tryCatch(names(obj@reductions), error = function(e) character(0))
      red_use <- if ("umap" %in% tolower(reds)) reds[match("umap", tolower(reds))] else if (length(reds)) reds[[1]] else ""
      validate(need(nzchar(red_use), "Active object has no embedding reductions (UMAP/TSNE) for visualization."))
      
      emb <- Seurat::Embeddings(obj, reduction = red_use)
      umap_df <- data.frame(
        cell = rownames(emb),
        UMAP_1 = emb[, 1],
        UMAP_2 = emb[, 2],
        condition = as.character(md[[cond_col]]),
        stringsAsFactors = FALSE
      )
      
      # Match TCR clone metadata to all cells
      umap_df$clone <- as.character(md[[clone_col]])
      umap_df$plot_clone <- ifelse(umap_df$clone %in% top_clones, umap_df$clone, "Others")
      
      # For UMAP, we want unexpanded cells or cells without this TCR chain to be colored light gray
      # We separate "Others" (which means VDJ-positive but not in top N) and "Unexpanded/No VDJ"
      umap_df$plot_clone[umap_df$clone == "unknown" | umap_df$clone == "0" | is.na(umap_df$clone)] <- "No VDJ"
      umap_df$plot_clone <- factor(umap_df$plot_clone, levels = c(top_clones, "Others", "No VDJ"))
      
      # Adjust colors for UMAP
      umap_colors <- c(colors, "No VDJ" = "#E5E7EB")
      umap_colors["Others"] <- "#9CA3AF"
      
      # Sort cells so unexpanded are plotted at the back, top clones at the front
      umap_df <- umap_df |> dplyr::arrange(desc(plot_clone))
      
      p <- ggplot(umap_df, aes(x = UMAP_1, y = UMAP_2, color = plot_clone)) +
        geom_point(size = 0.4, alpha = 0.85) +
        scale_color_manual(values = umap_colors) +
        facet_wrap(~condition) +
        labs(
          title = if (nzchar(plot_title)) plot_title else paste("UMAP Clonal Expansion Studio"),
          x = paste(red_use, "1"),
          y = paste(red_use, "2"),
          color = "Clone ID"
        )
    }
    
    p <- p + theme_fn() + theme(legend.position = legend_pos)
    p
  })
  
  output$figure_tcr_studio_plot <- renderPlot({
    tryCatch(
      .compose_tcr_studio_plot(),
      error = function(e) {
        plot.new()
        title(main = "TCR Studio Plot Error")
        text(0.5, 0.55, labels = "Could not render TCR/BCR Studio plot.", cex = 1.0)
        text(0.5, 0.45, labels = conditionMessage(e), cex = 0.8)
        invisible(NULL)
      }
    )
  })
  
  .generate_tcr_studio_script <- reactive({
    obj_name <- selected_dataset_name()
    clone_col <- input$figure_tcr_studio_clone_col %||% "vdj_tcr_clone"
    cond_col <- input$figure_tcr_studio_condition_col %||% "orig.ident"
    plot_type <- input$figure_tcr_studio_plot_type %||% "stacked_bar"
    top_n <- input$figure_tcr_studio_top_n %||% 15
    pal_name <- input$figure_tcr_studio_palette %||% "Brewer: Set2"
    theme_choice <- input$figure_tcr_studio_theme %||% "theme_classic"
    legend_pos <- input$figure_tcr_studio_legend_pos %||% "right"
    plot_title <- input$figure_tcr_studio_title %||% ""
    chain_mode <- input$figure_tcr_studio_chain %||% "tcr"
    
    lines <- c(
      "# 1) Load packages",
      "library(Seurat)",
      "library(ggplot2)",
      "library(dplyr)",
      "",
      "# 2) Resolve Seurat object from your workspace (or app shared_data)",
      .figure_code_object_lookup_lines(obj_name),
      "",
      "# 3) Configure parameters",
      sprintf("clone_col <- %s  # Clone metadata column name", .figure_code_val(clone_col)),
      sprintf("condition_col <- %s  # Condition metadata column name", .figure_code_val(cond_col)),
      sprintf("plot_type <- %s  # stacked_bar, tracking_line, or facet_umap", .figure_code_val(plot_type)),
      sprintf("top_n <- %s  # Number of top clones to show individually", .figure_code_val(top_n)),
      sprintf("theme_choice <- %s  # ggplot theme name", .figure_code_val(theme_choice)),
      sprintf("legend_pos <- %s  # Legend alignment", .figure_code_val(legend_pos)),
      sprintf("plot_title <- %s  # Custom title (empty for default)", .figure_code_val(plot_title)),
      sprintf("palette_name <- %s  # Color palette choice", .figure_code_val(pal_name)),
      "",
      "# 4) Parse and construct plotting tables",
      "md <- sobj@meta.data",
      "clones <- as.character(md[[clone_col]])",
      "conds <- as.character(md[[condition_col]])",
      "valid_idx <- which(nzchar(clones) & clones != 'unknown' & clones != '0' & !is.na(clones))",
      "if (length(valid_idx) == 0) stop('No valid VDJ clone records found in metadata.')",
      "df <- data.frame(cell = rownames(md)[valid_idx], clone = clones[valid_idx], condition = conds[valid_idx], stringsAsFactors = FALSE)",
      "clone_counts <- df |> dplyr::count(clone) |> dplyr::arrange(desc(n))",
      "top_clones <- head(clone_counts$clone, top_n)",
      "df$plot_clone <- ifelse(df$clone %in% top_clones, df$clone, 'Others')",
      "df$plot_clone <- factor(df$plot_clone, levels = c(top_clones, 'Others'))",
      "",
      "# Define color palette",
      "colors <- scales::hue_pal()(length(top_clones) + 1)",
      "colors[length(colors)] <- '#D1D5DB'  # Color Others gray",
      "names(colors) <- c(top_clones, 'Others')",
      "",
      "theme_fn <- get(theme_choice)",
      "",
      "if (plot_type == 'stacked_bar') {",
      "  plot_df <- df |> dplyr::count(condition, plot_clone) |> dplyr::group_by(condition) |> dplyr::mutate(proportion = n / sum(n)) |> dplyr::ungroup()",
      "  p <- ggplot(plot_df, aes(x = condition, y = proportion, fill = plot_clone)) +",
      "    geom_col(color = '#4D4D4D', linewidth = 0.15, width = 0.7) +",
      "    scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +",
      "    labs(title = if (nzchar(plot_title)) plot_title else paste('Clonotype Composition across', condition_col), x = condition_col, y = 'Percentage', fill = 'Clone ID') +",
      "    scale_fill_manual(values = colors)",
      "} else if (plot_type == 'tracking_line') {",
      "  plot_df <- df |> dplyr::count(condition, plot_clone) |> dplyr::group_by(condition) |> dplyr::mutate(proportion = n / sum(n)) |> dplyr::ungroup()",
      "  plot_df <- plot_df[plot_df$plot_clone != 'Others', ]",
      "  p <- ggplot(plot_df, aes(x = condition, y = proportion, group = plot_clone, color = plot_clone)) +",
      "    geom_line(linewidth = 1) + geom_point(size = 3) +",
      "    scale_y_continuous(labels = scales::percent_format(accuracy = 0.1)) +",
      "    labs(title = if (nzchar(plot_title)) plot_title else paste('Clonal Frequencies across', condition_col), x = condition_col, y = 'Frequency in VDJ repertoire', color = 'Clone ID') +",
      "    scale_color_manual(values = colors)",
      "} else {",
      "  emb <- Seurat::Embeddings(sobj, reduction = names(sobj@reductions)[[1]])",
      "  umap_df <- data.frame(cell = rownames(emb), UMAP_1 = emb[, 1], UMAP_2 = emb[, 2], condition = as.character(md[[condition_col]]), stringsAsFactors = FALSE)",
      "  umap_df$clone <- as.character(md[[clone_col]])",
      "  umap_df$plot_clone <- ifelse(umap_df$clone %in% top_clones, umap_df$clone, 'Others')",
      "  umap_df$plot_clone[umap_df$clone == 'unknown' | umap_df$clone == '0' | is.na(umap_df$clone)] <- 'No VDJ'",
      "  umap_df$plot_clone <- factor(umap_df$plot_clone, levels = c(top_clones, 'Others', 'No VDJ'))",
      "  umap_colors <- c(colors, 'No VDJ' = '#E5E7EB')",
      "  umap_df <- umap_df |> dplyr::arrange(desc(plot_clone))",
      "  p <- ggplot(umap_df, aes(x = UMAP_1, y = UMAP_2, color = plot_clone)) +",
      "    geom_point(size = 0.4, alpha = 0.85) +",
      "    scale_color_manual(values = umap_colors) +",
      "    facet_wrap(~condition) +",
      "    labs(title = if (nzchar(plot_title)) plot_title else 'UMAP Clonal Expansion Studio', x = 'UMAP 1', y = 'UMAP 2', color = 'Clone ID')",
      "}",
      "",
      "p <- p + theme_fn() + theme(legend.position = legend_pos)",
      "print(p)"
    )
    paste(lines, collapse = "\n")
  })
  
  figure_code_card_server("figure_tcr_studio_code_card", code_text_reactive = .generate_tcr_studio_script)
  
  .figure_tcr_studio_pdf_bundle <- function(kind, width_px = NULL, height_px = NULL) {
    req(kind == "tcr_studio_pdf")
    p <- .compose_tcr_studio_plot()
    req(p)
    width_in <- suppressWarnings(as.numeric(input$figure_tcr_studio_width %||% 10))
    height_in <- suppressWarnings(as.numeric(input$figure_tcr_studio_height %||% 6))
    if (!is.finite(width_in) || width_in <= 0) width_in <- 10
    if (!is.finite(height_in) || height_in <= 0) height_in <- 6
    if (is.finite(width_px) && width_px > 0) width_in <- width_px / 96
    if (is.finite(height_px) && height_px > 0) height_in <- height_px / 96
    list(
      plot = p,
      width_px = as.integer(max(320, round(width_in * 96))),
      height_px = as.integer(max(240, round(height_in * 96))),
      filename_prefix = paste0(selected_dataset_name() %||% "dataset", "_TCR_Studio_")
    )
  }
  
  .pdf_modal_server <- get0("wl_pdf_modal_server", mode = "function", ifnotfound = NULL)
  if (!is.null(.pdf_modal_server)) {
    .figure_tcr_studio_pdf_modal <- .pdf_modal_server(
      input = input,
      output = output,
      session = session,
      id_prefix = "figure_tcr_studio_pdf",
      build_bundle = .figure_tcr_studio_pdf_bundle,
      download_btn_label = FIGURE_TCR_STUDIO_UI_TEXT$t_btn_download_pdf,
      default_modal_title = "PDF export settings: TCR/BCR Studio"
    )
    observeEvent(input$open_tcr_studio_pdf_modal, {
      .figure_tcr_studio_pdf_modal$open("tcr_studio_pdf", title_txt = "PDF export settings: TCR/BCR Studio")
    }, ignoreInit = TRUE)
  }
}
