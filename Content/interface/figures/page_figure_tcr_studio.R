# R/page_figure_tcr_studio.R
FIGURE_TCR_STUDIO_UI_TEXT <- list(
  t_btn_copy_code = "Copy Code",
  t_btn_download_pdf = "Download PDF",
  t_btn_download_svg = "Download SVG",
  t_btn_download_full_csv = "Full CSV",
  t_btn_download_selected_csv = "Selected CSV",
  t_btn_select_visible = "Select visible",
  t_btn_clear_selection = "Clear",
  t_label_1_select_dataset = "1. Select Dataset:",
  t_label_2_chain = "2. Chain Mode:",
  t_label_3_clone_column = "3. Clone column (ID):",
  t_label_4_condition_column = "4. Column split / group:",
  t_label_5_row_split = "5. Row split:",
  t_label_6_plot_type = "6. Plot Type:",
  t_label_ranking_metric = "Rank clones by:",
  t_label_show_top_clonotypes = "Show top clonotypes (N):",
  t_label_color_mode = "UMAP color mode:",
  t_label_clone_size_scope = "Clone-size scope:",
  t_label_abundance_unit = "Abundance unit:",
  t_label_table_numbers = "Show rank and cell count in table",
  t_label_bar_numbers = "Show numbers on bar columns",
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
  t_title_ranked_clones = "Ranked Clones",
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
        selectInput("figure_tcr_studio_row_split", FIGURE_TCR_STUDIO_UI_TEXT$t_label_5_row_split, choices = c("None" = "__none__")),
        selectInput(
          "figure_tcr_studio_plot_type",
          FIGURE_TCR_STUDIO_UI_TEXT$t_label_6_plot_type,
          choices = c(
            "Selected Clone UMAP" = "facet_umap",
            "Stacked Bar Plot" = "stacked_bar",
            "Clone Frequency Tracking" = "tracking_line",
            "Alluvial Flow" = "alluvial",
            "UMAP + Abundance" = "combined"
          ),
          selected = "facet_umap"
        ),
        selectInput(
          "figure_tcr_studio_ranking",
          FIGURE_TCR_STUDIO_UI_TEXT$t_label_ranking_metric,
          choices = c("Cell count" = "cell_count", "Percent of VDJ-positive cells" = "percent"),
          selected = "cell_count"
        ),
        sliderInput("figure_tcr_studio_top_n", FIGURE_TCR_STUDIO_UI_TEXT$t_label_show_top_clonotypes, min = 5, max = 50, value = 10, step = 1),
        h5(FIGURE_TCR_STUDIO_UI_TEXT$t_title_ranked_clones),
        fluidRow(
          column(7, actionButton("figure_tcr_studio_select_visible", FIGURE_TCR_STUDIO_UI_TEXT$t_btn_select_visible, class = "btn btn-default btn-sm", style = "width:100%;")),
          column(5, actionButton("figure_tcr_studio_clear_selection", FIGURE_TCR_STUDIO_UI_TEXT$t_btn_clear_selection, class = "btn btn-default btn-sm", style = "width:100%;"))
        ),
        tags$div(
          class = "text-muted",
          style = "font-size:11px; line-height:1.25; margin:6px 0;",
          "Identical clonotype ID text is pooled across samples. Select rows to control plots. Double-click Label to edit it."
        ),
        div(
          style = "max-height:280px; overflow-y:auto; overflow-x:auto;",
          DT::DTOutput("figure_tcr_studio_clone_table")
        ),
        tags$details(
          tags$summary("Optional table columns"),
          checkboxGroupInput(
            "figure_tcr_studio_extra_columns",
            label = NULL,
            choices = c("Percent" = "percent", "Receptor" = "receptor"),
            selected = character(0)
          )
        ),
        checkboxInput("figure_tcr_studio_table_numbers", FIGURE_TCR_STUDIO_UI_TEXT$t_label_table_numbers, value = TRUE),
        checkboxInput("figure_tcr_studio_bar_numbers", FIGURE_TCR_STUDIO_UI_TEXT$t_label_bar_numbers, value = FALSE),
        selectInput(
          "figure_tcr_studio_color_mode",
          FIGURE_TCR_STUDIO_UI_TEXT$t_label_color_mode,
          choices = c("Clonotype colors" = "clonotype", "Clone-size colors" = "clone_size"),
          selected = "clonotype"
        ),
        selectInput(
          "figure_tcr_studio_clone_size_scope",
          FIGURE_TCR_STUDIO_UI_TEXT$t_label_clone_size_scope,
          choices = c("Pooled object count" = "pooled", "Count within each facet" = "facet"),
          selected = "pooled"
        ),
        selectInput(
          "figure_tcr_studio_abundance_unit",
          FIGURE_TCR_STUDIO_UI_TEXT$t_label_abundance_unit,
          choices = c("Cell count" = "count", "Percent of VDJ-positive cells" = "percent"),
          selected = "count"
        ),
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
          choices = c(
            "Light publication" = "light",
            "Dark confocal" = "dark",
            "Classic" = "theme_classic",
            "Minimal" = "theme_minimal",
            "Black and White" = "theme_bw"
          ),
          selected = "light"
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
        fluidRow(
          column(6, actionButton("open_tcr_studio_pdf_modal", FIGURE_TCR_STUDIO_UI_TEXT$t_btn_download_pdf, class = "btn btn-default", style = "width:100%;")),
          column(6, downloadButton("download_tcr_studio_svg", FIGURE_TCR_STUDIO_UI_TEXT$t_btn_download_svg, class = "btn btn-default", style = "width:100%;"))
        ),
        div(style = "height:6px;"),
        fluidRow(
          column(6, downloadButton("download_tcr_studio_full_csv", FIGURE_TCR_STUDIO_UI_TEXT$t_btn_download_full_csv, class = "btn btn-default btn-sm", style = "width:100%;")),
          column(6, downloadButton("download_tcr_studio_selected_csv", FIGURE_TCR_STUDIO_UI_TEXT$t_btn_download_selected_csv, class = "btn btn-default btn-sm", style = "width:100%;"))
        ),
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
  row_split_select_signature <- reactiveVal("")
  clone_state_version <- reactiveVal(0L)
  
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

  observeEvent(input$figure_tcr_studio_chain, {
    obj <- active_object()
    req(obj)
    preferred <- .preferred_clone_col(obj@meta.data, input$figure_tcr_studio_chain %||% "tcr")
    req(nzchar(preferred))
    clone_select_signature("")
    shiny::freezeReactiveValue(input, "figure_tcr_studio_clone_col")
    updateSelectInput(session, "figure_tcr_studio_clone_col", selected = preferred)
  }, ignoreInit = TRUE, priority = 1000)
  
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

    row_choices <- c("None" = "__none__", stats::setNames(choices, choices))
    selected_row <- input$figure_tcr_studio_row_split %||% "__none__"
    if (!(selected_row %in% unname(row_choices))) selected_row <- "__none__"
    if (figure_select_input_needs_update(row_split_select_signature(), row_choices, selected_row)) {
      row_split_select_signature(figure_select_input_signature(row_choices, selected_row))
      shiny::freezeReactiveValue(input, "figure_tcr_studio_row_split")
      updateSelectInput(session, "figure_tcr_studio_row_split", choices = row_choices, selected = selected_row)
    }
  })

  .clone_state <- reactive({
    clone_state_version()
    vdj_clone_state_get(
      session,
      selected_dataset_name(),
      input$figure_tcr_studio_chain %||% "tcr"
    )
  })

  .write_clone_state <- function(selected = NULL, labels = NULL, initialized = TRUE) {
    current <- vdj_clone_state_get(
      session,
      selected_dataset_name(),
      input$figure_tcr_studio_chain %||% "tcr"
    )
    next_selected <- if (is.null(selected)) current$selected %||% character(0) else selected
    next_labels <- if (is.null(labels)) current$labels %||% character(0) else labels
    changed <- !identical(as.character(current$selected %||% character(0)), as.character(next_selected %||% character(0))) ||
      !identical(current$labels %||% character(0), next_labels %||% character(0)) ||
      !identical(isTRUE(current$initialized), isTRUE(initialized))
    if (!changed) return(invisible(NULL))
    vdj_clone_state_set(
      session,
      selected_dataset_name(),
      input$figure_tcr_studio_chain %||% "tcr",
      selected = next_selected,
      labels = next_labels,
      initialized = initialized
    )
    clone_state_version(clone_state_version() + 1L)
    invisible(NULL)
  }

  .clone_rank_table <- reactive({
    obj <- active_object()
    req(obj)
    state <- .clone_state()
    vdj_clone_rank_table(
      obj@meta.data,
      feature = input$figure_tcr_studio_chain %||% "tcr",
      clone_col = input$figure_tcr_studio_clone_col,
      ranking = input$figure_tcr_studio_ranking %||% "cell_count",
      label_map = state$labels %||% character(0)
    )
  })

  .visible_clone_table <- reactive({
    ranked <- .clone_rank_table()
    top_n <- suppressWarnings(as.integer(input$figure_tcr_studio_top_n %||% 10L))
    if (!is.finite(top_n) || top_n < 1L) top_n <- 10L
    utils::head(ranked, top_n)
  })

  observe({
    ranked <- .clone_rank_table()
    req(nrow(ranked) > 0)
    state <- .clone_state()
    if (isTRUE(state$initialized)) return(invisible(NULL))
    .write_clone_state(selected = utils::head(ranked$clonotype_id, 10L), initialized = TRUE)
  })

  .clone_table_display <- reactive({
    visible <- .visible_clone_table()
    selected <- .clone_state()$selected %||% character(0)
    show_numbers <- isTRUE(input$figure_tcr_studio_table_numbers %||% TRUE)
    out <- data.frame(
      Select = ifelse(visible$clonotype_id %in% selected, "[x]", "[ ]"),
      Rank = visible$rank,
      Label = visible$label,
      `Cell count` = visible$cell_count,
      `Clonotype ID` = visible$clonotype_id,
      check.names = FALSE,
      stringsAsFactors = FALSE
    )
    if (!show_numbers) out <- out[, !names(out) %in% c("Rank", "Cell count"), drop = FALSE]
    extra <- input$figure_tcr_studio_extra_columns %||% character(0)
    if ("percent" %in% extra) out$Percent <- sprintf("%.2f%%", visible$percent)
    if ("receptor" %in% extra) out$Receptor <- visible$receptor
    out
  })

  output$figure_tcr_studio_clone_table <- DT::renderDT({
    display <- .clone_table_display()
    visible <- .visible_clone_table()
    selected_rows <- which(visible$clonotype_id %in% (.clone_state()$selected %||% character(0)))
    label_col <- match("Label", names(display)) - 1L
    disabled_cols <- setdiff(seq_along(display) - 1L, label_col)
    DT::datatable(
      display,
      rownames = FALSE,
      escape = TRUE,
      selection = list(mode = "multiple", target = "row", selected = selected_rows),
      editable = list(target = "cell", disable = list(columns = disabled_cols)),
      options = list(
        dom = "t",
        paging = FALSE,
        ordering = FALSE,
        scrollX = TRUE,
        scrollY = "220px",
        scrollCollapse = TRUE,
        autoWidth = FALSE,
        columnDefs = list(
          list(width = "42px", targets = 0),
          list(width = "52px", targets = which(names(display) == "Rank") - 1L),
          list(width = "92px", targets = which(names(display) == "Cell count") - 1L)
        )
      )
    )
  }, server = FALSE)

  observeEvent(input$figure_tcr_studio_clone_table_rows_selected, {
    visible <- .visible_clone_table()
    selected_rows <- as.integer(input$figure_tcr_studio_clone_table_rows_selected %||% integer(0))
    selected_rows <- selected_rows[selected_rows >= 1L & selected_rows <= nrow(visible)]
    current <- .clone_state()$selected %||% character(0)
    hidden <- setdiff(current, visible$clonotype_id)
    .write_clone_state(selected = unique(c(hidden, visible$clonotype_id[selected_rows])))
  }, ignoreInit = TRUE)

  observeEvent(input$figure_tcr_studio_select_visible, {
    current <- .clone_state()$selected %||% character(0)
    .write_clone_state(selected = unique(c(current, .visible_clone_table()$clonotype_id)))
  })

  observeEvent(input$figure_tcr_studio_clear_selection, {
    .write_clone_state(selected = character(0))
  })

  observeEvent(input$figure_tcr_studio_clone_table_cell_edit, {
    info <- input$figure_tcr_studio_clone_table_cell_edit
    display <- .clone_table_display()
    visible <- .visible_clone_table()
    row_index <- suppressWarnings(as.integer(info$row %||% NA_integer_))
    col_index <- suppressWarnings(as.integer(info$col %||% NA_integer_)) + 1L
    req(is.finite(row_index), row_index >= 1L, row_index <= nrow(visible))
    req(is.finite(col_index), col_index >= 1L, col_index <= ncol(display))
    req(identical(names(display)[[col_index]], "Label"))
    next_label <- trimws(as.character(info$value %||% ""))
    req(nzchar(next_label))
    state <- .clone_state()
    labels <- state$labels %||% character(0)
    labels[visible$clonotype_id[[row_index]]] <- next_label
    .write_clone_state(labels = labels)
  }, ignoreInit = TRUE)
  
  .compose_tcr_studio_plot <- reactive({
    obj <- active_object()
    req(obj)
    md <- obj@meta.data
    validate(need(is.data.frame(md) && nrow(md) > 0, "Selected object has no metadata rows."))

    clone_col <- input$figure_tcr_studio_clone_col
    cond_col <- input$figure_tcr_studio_condition_col
    row_col <- input$figure_tcr_studio_row_split %||% "__none__"
    plot_type <- input$figure_tcr_studio_plot_type %||% "facet_umap"
    abundance_unit <- input$figure_tcr_studio_abundance_unit %||% "count"
    color_mode <- input$figure_tcr_studio_color_mode %||% "clonotype"
    size_scope <- input$figure_tcr_studio_clone_size_scope %||% "pooled"

    validate(need(nzchar(clone_col) && clone_col %in% colnames(md), "Clone column is not available in this object."))
    validate(need(nzchar(cond_col) && cond_col %in% colnames(md), "Condition column is not available in this object."))
    validate(need(identical(row_col, "__none__") || row_col %in% colnames(md), "Row split column is not available in this object."))

    rank_table <- .clone_rank_table()
    selected_ids <- intersect(.clone_state()$selected %||% character(0), rank_table$clonotype_id)
    validate(need(length(selected_ids) > 0, "Select at least one clone from the ranked table."))
    label_lookup <- stats::setNames(rank_table$label, rank_table$clonotype_id)

    clones <- vdj_clone_valid_ids(md[[clone_col]])
    valid_idx <- which(!is.na(clones))
    validate(need(length(valid_idx) > 0, "No cells with valid TCR/BCR clone annotations found."))

    .clean_group <- function(x) {
      out <- trimws(as.character(x %||% ""))
      out[is.na(out) | !nzchar(out)] <- "(NA)"
      out
    }
    df <- data.frame(
      cell = rownames(md)[valid_idx],
      clone = clones[valid_idx],
      column_group = .clean_group(md[[cond_col]])[valid_idx],
      row_group = if (identical(row_col, "__none__")) "All" else .clean_group(md[[row_col]])[valid_idx],
      stringsAsFactors = FALSE
    )
    df$is_selected <- df$clone %in% selected_ids
    df$plot_clone <- ifelse(df$is_selected, unname(label_lookup[df$clone]), "Other VDJ")
    selected_labels <- unname(label_lookup[selected_ids])
    validate(need(!anyDuplicated(selected_labels), "Selected clone labels must be unique."))
    df$plot_clone <- factor(df$plot_clone, levels = c(selected_labels, "Other VDJ"))

    pal_name <- input$figure_tcr_studio_palette %||% "Brewer: Set2"
    selected_colors <- if (identical(pal_name, "Default Seurat")) {
      scales::hue_pal()(length(selected_labels))
    } else {
      base_pal <- all_palettes[[pal_name]]
      if (length(base_pal) < length(selected_labels)) {
        grDevices::colorRampPalette(base_pal)(length(selected_labels))
      } else {
        base_pal[seq_len(length(selected_labels))]
      }
    }
    names(selected_colors) <- selected_labels

    theme_choice <- input$figure_tcr_studio_theme %||% "light"
    legend_pos <- input$figure_tcr_studio_legend_pos %||% "right"
    plot_title <- input$figure_tcr_studio_title %||% ""

    is_dark <- identical(theme_choice, "dark")
    background_color <- if (is_dark) "#000000" else "#FFFFFF"
    text_color <- if (is_dark) "#FFFFFF" else "#111111"
    other_color <- if (is_dark) "#666666" else "#BDBDBD"
    no_vdj_color <- if (is_dark) "#333333" else "#E5E5E5"
    discrete_colors <- c(selected_colors, "Other VDJ" = other_color)

    .apply_theme <- function(p) {
      base <- if (is_dark) {
        ggplot2::theme_void()
      } else if (identical(theme_choice, "light")) {
        ggplot2::theme_classic()
      } else {
        theme_fn <- get0(theme_choice, envir = asNamespace("ggplot2"), ifnotfound = ggplot2::theme_classic)
        theme_fn()
      }
      p + base + ggplot2::theme(
        legend.position = legend_pos,
        plot.background = ggplot2::element_rect(fill = background_color, color = NA),
        panel.background = ggplot2::element_rect(fill = background_color, color = NA),
        legend.background = ggplot2::element_rect(fill = background_color, color = NA),
        legend.key = ggplot2::element_rect(fill = background_color, color = NA),
        text = ggplot2::element_text(color = text_color),
        axis.text = ggplot2::element_text(color = text_color),
        strip.text = ggplot2::element_text(color = text_color, face = "bold"),
        strip.background = ggplot2::element_rect(fill = background_color, color = if (is_dark) "#FFFFFF" else "#D0D0D0")
      )
    }

    .add_facets <- function(p) {
      if (identical(row_col, "__none__")) {
        p + ggplot2::facet_wrap(~column_group)
      } else {
        p + ggplot2::facet_grid(row_group ~ column_group)
      }
    }

    plot_df <- df |>
      dplyr::count(row_group, column_group, plot_clone, name = "cell_count") |>
      dplyr::group_by(row_group, column_group) |>
      dplyr::mutate(percent = 100 * cell_count / sum(cell_count)) |>
      dplyr::ungroup()
    plot_df$value <- if (identical(abundance_unit, "percent")) plot_df$percent else plot_df$cell_count
    value_label <- if (identical(abundance_unit, "percent")) "Percent of VDJ-positive cells" else "Cell count"

    .build_abundance_plot <- function(kind = "stacked_bar") {
      if (identical(kind, "alluvial")) {
        validate(need(requireNamespace("ggalluvial", quietly = TRUE), "Package ggalluvial is required for alluvial plots."))
        selected_df <- plot_df[as.character(plot_df$plot_clone) != "Other VDJ", , drop = FALSE]
        p <- ggplot2::ggplot(
          selected_df,
          ggplot2::aes(x = column_group, stratum = plot_clone, alluvium = plot_clone, y = value, fill = plot_clone)
        ) +
          ggalluvial::geom_alluvium(alpha = 0.72, width = 0.18) +
          ggalluvial::geom_stratum(width = 0.18, color = if (is_dark) "#FFFFFF" else "#444444", linewidth = 0.2) +
          ggplot2::scale_fill_manual(values = selected_colors, drop = FALSE) +
          ggplot2::labs(x = cond_col, y = value_label, fill = "Clone", title = if (nzchar(plot_title)) plot_title else "Clonal abundance flow")
      } else {
        p <- ggplot2::ggplot(plot_df, ggplot2::aes(x = column_group, y = value, fill = plot_clone)) +
          ggplot2::geom_col(color = if (is_dark) "#FFFFFF" else "#4D4D4D", linewidth = 0.15, width = 0.7) +
          ggplot2::scale_fill_manual(values = discrete_colors, drop = FALSE) +
          ggplot2::labs(x = cond_col, y = value_label, fill = "Clone", title = if (nzchar(plot_title)) plot_title else "Clonotype composition")
        if (isTRUE(input$figure_tcr_studio_bar_numbers)) {
          totals <- stats::aggregate(value ~ row_group + column_group, data = plot_df, FUN = sum)
          totals$label <- if (identical(abundance_unit, "percent")) sprintf("%.0f%%", totals$value) else as.character(totals$value)
          p <- p + ggplot2::geom_text(data = totals, ggplot2::aes(x = column_group, y = value, label = label), inherit.aes = FALSE, vjust = -0.3, color = text_color, size = 3)
        }
      }
      if (!identical(row_col, "__none__")) p <- p + ggplot2::facet_wrap(~row_group, scales = "free_x")
      .apply_theme(p)
    }

    .build_tracking_plot <- function() {
      selected_df <- plot_df[as.character(plot_df$plot_clone) != "Other VDJ", , drop = FALSE]
      p <- ggplot2::ggplot(selected_df, ggplot2::aes(x = column_group, y = value, group = plot_clone, color = plot_clone)) +
        ggplot2::geom_line(linewidth = 1) +
        ggplot2::geom_point(size = 2.8) +
        ggplot2::scale_color_manual(values = selected_colors, drop = FALSE) +
        ggplot2::labs(x = cond_col, y = value_label, color = "Clone", title = if (nzchar(plot_title)) plot_title else "Clonal abundance tracking")
      if (!identical(row_col, "__none__")) p <- p + ggplot2::facet_wrap(~row_group, scales = "free_x")
      .apply_theme(p)
    }

    .build_umap_plot <- function(show_title = TRUE) {
      red_use <- figure_resolve_reduction_name(obj, "umap")
      validate(need(nzchar(red_use), "Active object has no embedding reductions (UMAP/TSNE) for visualization."))
      emb <- Seurat::Embeddings(obj, reduction = red_use)
      emb_cells <- rownames(emb)
      umap_df <- data.frame(
        cell = emb_cells,
        UMAP_1 = emb[, 1],
        UMAP_2 = emb[, 2],
        column_group = .clean_group(md[emb_cells, cond_col]),
        row_group = if (identical(row_col, "__none__")) "All" else .clean_group(md[emb_cells, row_col]),
        stringsAsFactors = FALSE
      )
      umap_df$clone <- vdj_clone_valid_ids(md[emb_cells, clone_col])
      umap_df$is_selected <- !is.na(umap_df$clone) & umap_df$clone %in% selected_ids
      umap_df$plot_clone <- ifelse(umap_df$is_selected, unname(label_lookup[umap_df$clone]), "Background")
      pooled_counts <- table(clones[!is.na(clones)])
      umap_df$clone_size <- as.numeric(pooled_counts[umap_df$clone])
      if (identical(size_scope, "facet")) {
        valid_size <- !is.na(umap_df$clone)
        facet_key <- interaction(umap_df$clone, umap_df$row_group, umap_df$column_group, drop = TRUE)
        umap_df$clone_size[valid_size] <- ave(rep(1, sum(valid_size)), facet_key[valid_size], FUN = sum)
      }
      umap_df$clone_size[!is.finite(umap_df$clone_size)] <- 0
      umap_df <- umap_df[order(umap_df$is_selected, umap_df$clone_size), , drop = FALSE]

      if (identical(color_mode, "clone_size")) {
        p <- ggplot2::ggplot(umap_df, ggplot2::aes(x = UMAP_1, y = UMAP_2)) +
          ggplot2::geom_point(data = umap_df[!umap_df$is_selected, , drop = FALSE], color = no_vdj_color, size = 0.42, alpha = 0.55) +
          ggplot2::geom_point(data = umap_df[umap_df$is_selected, , drop = FALSE], ggplot2::aes(color = clone_size), size = 0.5, alpha = 0.95) +
          ggplot2::scale_color_viridis_c(trans = "log1p", name = "Clone size")
      } else {
        umap_colors <- c(selected_colors, "Background" = no_vdj_color)
        p <- ggplot2::ggplot(umap_df, ggplot2::aes(x = UMAP_1, y = UMAP_2, color = plot_clone)) +
          ggplot2::geom_point(size = 0.48, alpha = 0.9) +
          ggplot2::scale_color_manual(values = umap_colors, drop = FALSE, name = "Clone")
      }
      p <- .add_facets(p) +
        ggplot2::coord_fixed() +
        ggplot2::labs(
          title = if (show_title) if (nzchar(plot_title)) plot_title else "Selected clone UMAP" else NULL,
          x = paste(red_use, "1"),
          y = paste(red_use, "2")
        )
      .apply_theme(p)
    }

    if (identical(plot_type, "stacked_bar")) return(.build_abundance_plot("stacked_bar"))
    if (identical(plot_type, "alluvial")) return(.build_abundance_plot("alluvial"))
    if (identical(plot_type, "tracking_line")) return(.build_tracking_plot())
    if (identical(plot_type, "combined")) {
      umap_plot <- .build_umap_plot(show_title = FALSE)
      abundance_plot <- .build_abundance_plot("stacked_bar") + ggplot2::labs(title = NULL)
      return(patchwork::wrap_plots(umap_plot, abundance_plot, ncol = 1, heights = c(3, 1)) +
        patchwork::plot_annotation(title = if (nzchar(plot_title)) plot_title else "VDJ clone expansion"))
    }
    .build_umap_plot(show_title = TRUE)
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

  .clone_export_table <- reactive({
    ranked <- .clone_rank_table()
    selected <- .clone_state()$selected %||% character(0)
    ranked$selected <- ranked$clonotype_id %in% selected
    ranked
  })

  output$download_tcr_studio_full_csv <- downloadHandler(
    filename = function() paste0(selected_dataset_name() %||% "dataset", "_VDJ_clone_ranking.csv"),
    content = function(file) utils::write.csv(.clone_export_table(), file, row.names = FALSE, na = "")
  )

  output$download_tcr_studio_selected_csv <- downloadHandler(
    filename = function() paste0(selected_dataset_name() %||% "dataset", "_VDJ_selected_clones.csv"),
    content = function(file) {
      out <- .clone_export_table()
      out <- out[out$selected, , drop = FALSE]
      utils::write.csv(out, file, row.names = FALSE, na = "")
    }
  )

  output$download_tcr_studio_svg <- downloadHandler(
    filename = function() paste0(selected_dataset_name() %||% "dataset", "_VDJ_Studio.svg"),
    content = function(file) {
      ggplot2::ggsave(
        filename = file,
        plot = .compose_tcr_studio_plot(),
        device = "svg",
        width = input$figure_tcr_studio_width %||% 10,
        height = input$figure_tcr_studio_height %||% 6,
        units = "in",
        bg = if (identical(input$figure_tcr_studio_theme %||% "light", "dark")) "black" else "white"
      )
    }
  )
  
  .tcr_analysis_recipe <- reactive({
    ranked <- .clone_rank_table()
    selected_ids <- intersect(.clone_state()$selected %||% character(0), ranked$clonotype_id)
    selected_rows <- ranked[match(selected_ids, ranked$clonotype_id), , drop = FALSE]
    list(
      recipe_type = "vdj_clone_analysis",
      recipe_version = 1L,
      object_name = selected_dataset_name(),
      receptor = input$figure_tcr_studio_chain %||% "tcr",
      clone_column = input$figure_tcr_studio_clone_col %||% "",
      ranking = input$figure_tcr_studio_ranking %||% "cell_count",
      selected_clonotypes = selected_ids,
      clone_labels = stats::setNames(selected_rows$label, selected_rows$clonotype_id),
      clone_size_scope = input$figure_tcr_studio_clone_size_scope %||% "pooled"
    )
  })

  .tcr_figure_recipe <- reactive({
    list(
      recipe_type = "vdj_figure",
      recipe_version = 1L,
      studio = "TCR/BCR Studio",
      plot_type = input$figure_tcr_studio_plot_type %||% "facet_umap",
      column_split = input$figure_tcr_studio_condition_col %||% "",
      row_split = input$figure_tcr_studio_row_split %||% "__none__",
      color_mode = input$figure_tcr_studio_color_mode %||% "clonotype",
      abundance_unit = input$figure_tcr_studio_abundance_unit %||% "count",
      palette = input$figure_tcr_studio_palette %||% "Brewer: Set2",
      theme = input$figure_tcr_studio_theme %||% "light",
      legend_position = input$figure_tcr_studio_legend_pos %||% "right",
      title = input$figure_tcr_studio_title %||% "",
      show_table_numbers = isTRUE(input$figure_tcr_studio_table_numbers %||% TRUE),
      show_bar_numbers = isTRUE(input$figure_tcr_studio_bar_numbers),
      width_in = suppressWarnings(as.numeric(input$figure_tcr_studio_width %||% 10)),
      height_in = suppressWarnings(as.numeric(input$figure_tcr_studio_height %||% 6))
    )
  })

  .generate_tcr_studio_script <- reactive({
    obj_name <- selected_dataset_name()
    obj <- active_object()
    red_use <- figure_resolve_reduction_name(obj, "umap")
    validate(need(nzchar(red_use), "Selected dataset has no UMAP reduction."))
    analysis_recipe <- .tcr_analysis_recipe()
    figure_recipe <- .tcr_figure_recipe()

    lines <- c(
      figure_recipe_code_lines(analysis_recipe, figure_recipe),
      "# 1) Load packages",
      "library(Seurat)",
      "library(ggplot2)",
      "library(dplyr)",
      "library(patchwork)",
      "if (figure_recipe$plot_type == 'alluvial') library(ggalluvial)",
      "",
      "# 2) Resolve Seurat object from your workspace (or app shared_data)",
      .figure_code_object_lookup_lines(obj_name),
      "",
      "# 3) Build selected-clone data",
      sprintf("reduction_name <- %s", .figure_code_val(red_use)),
      "md <- sobj@meta.data",
      "clone_col <- analysis_recipe$clone_column",
      "condition_col <- figure_recipe$column_split",
      "row_col <- figure_recipe$row_split",
      "selected_ids <- analysis_recipe$selected_clonotypes",
      "label_lookup <- analysis_recipe$clone_labels",
      "clean_clone <- function(x) {",
      "  x <- trimws(as.character(x))",
      "  x[is.na(x) | !nzchar(x) | tolower(x) %in% c('unknown', 'na', 'none') | x == '0'] <- NA_character_",
      "  x",
      "}",
      "clean_group <- function(x) {",
      "  x <- trimws(as.character(x))",
      "  x[is.na(x) | !nzchar(x)] <- '(NA)'",
      "  x",
      "}",
      "clones <- clean_clone(md[[clone_col]])",
      "valid_idx <- which(!is.na(clones))",
      "if (length(valid_idx) == 0) stop('No valid VDJ clone records found in metadata.')",
      "df <- data.frame(",
      "  cell = rownames(md)[valid_idx],",
      "  clone = clones[valid_idx],",
      "  column_group = clean_group(md[[condition_col]])[valid_idx],",
      "  row_group = if (identical(row_col, '__none__')) 'All' else clean_group(md[[row_col]])[valid_idx],",
      "  stringsAsFactors = FALSE",
      ")",
      "df$is_selected <- df$clone %in% selected_ids",
      "selected_labels <- unname(label_lookup[selected_ids])",
      "if (anyDuplicated(selected_labels)) stop('Selected clone labels must be unique.')",
      "df$plot_clone <- ifelse(df$is_selected, unname(label_lookup[df$clone]), 'Other VDJ')",
      "df$plot_clone <- factor(df$plot_clone, levels = c(selected_labels, 'Other VDJ'))",
      "",
      "# 4) Colors and shared style",
      "selected_colors <- scales::hue_pal()(length(selected_labels))",
      "names(selected_colors) <- selected_labels",
      "is_dark <- identical(figure_recipe$theme, 'dark')",
      "background_color <- if (is_dark) '#000000' else '#FFFFFF'",
      "text_color <- if (is_dark) '#FFFFFF' else '#111111'",
      "background_point <- if (is_dark) '#333333' else '#E5E5E5'",
      "other_color <- if (is_dark) '#666666' else '#BDBDBD'",
      "discrete_colors <- c(selected_colors, 'Other VDJ' = other_color)",
      "apply_style <- function(p) {",
      "  base <- if (is_dark) theme_void() else theme_classic()",
      "  p + base + theme(",
      "    legend.position = figure_recipe$legend_position,",
      "    plot.background = element_rect(fill = background_color, color = NA),",
      "    panel.background = element_rect(fill = background_color, color = NA),",
      "    legend.background = element_rect(fill = background_color, color = NA),",
      "    legend.key = element_rect(fill = background_color, color = NA),",
      "    text = element_text(color = text_color),",
      "    axis.text = element_text(color = text_color),",
      "    strip.text = element_text(color = text_color, face = 'bold'),",
      "    strip.background = element_rect(fill = background_color, color = if (is_dark) '#FFFFFF' else '#D0D0D0')",
      "  )",
      "}",
      "add_facets <- function(p) {",
      "  if (identical(row_col, '__none__')) p + facet_wrap(~column_group) else p + facet_grid(row_group ~ column_group)",
      "}",
      "",
      "# 5) Abundance tables",
      "plot_df <- df |>",
      "  count(row_group, column_group, plot_clone, name = 'cell_count') |>",
      "  group_by(row_group, column_group) |>",
      "  mutate(percent = 100 * cell_count / sum(cell_count)) |>",
      "  ungroup()",
      "plot_df$value <- if (identical(figure_recipe$abundance_unit, 'percent')) plot_df$percent else plot_df$cell_count",
      "value_label <- if (identical(figure_recipe$abundance_unit, 'percent')) 'Percent of VDJ-positive cells' else 'Cell count'",
      "",
      "build_bar <- function() {",
      "  p <- ggplot(plot_df, aes(x = column_group, y = value, fill = plot_clone)) +",
      "    geom_col(color = if (is_dark) '#FFFFFF' else '#4D4D4D', linewidth = 0.15, width = 0.7) +",
      "    scale_fill_manual(values = discrete_colors, drop = FALSE) +",
      "    labs(x = condition_col, y = value_label, fill = 'Clone', title = if (nzchar(figure_recipe$title)) figure_recipe$title else 'Clonotype composition')",
      "  if (!identical(row_col, '__none__')) p <- p + facet_wrap(~row_group, scales = 'free_x')",
      "  apply_style(p)",
      "}",
      "build_tracking <- function() {",
      "  d <- plot_df[as.character(plot_df$plot_clone) != 'Other VDJ', , drop = FALSE]",
      "  p <- ggplot(d, aes(x = column_group, y = value, group = plot_clone, color = plot_clone)) +",
      "    geom_line(linewidth = 1) + geom_point(size = 2.8) +",
      "    scale_color_manual(values = selected_colors, drop = FALSE) +",
      "    labs(x = condition_col, y = value_label, color = 'Clone', title = if (nzchar(figure_recipe$title)) figure_recipe$title else 'Clonal abundance tracking')",
      "  if (!identical(row_col, '__none__')) p <- p + facet_wrap(~row_group, scales = 'free_x')",
      "  apply_style(p)",
      "}",
      "build_alluvial <- function() {",
      "  d <- plot_df[as.character(plot_df$plot_clone) != 'Other VDJ', , drop = FALSE]",
      "  p <- ggplot(d, aes(x = column_group, stratum = plot_clone, alluvium = plot_clone, y = value, fill = plot_clone)) +",
      "    ggalluvial::geom_alluvium(alpha = 0.72, width = 0.18) +",
      "    ggalluvial::geom_stratum(width = 0.18, linewidth = 0.2) +",
      "    scale_fill_manual(values = selected_colors, drop = FALSE) +",
      "    labs(x = condition_col, y = value_label, fill = 'Clone', title = if (nzchar(figure_recipe$title)) figure_recipe$title else 'Clonal abundance flow')",
      "  if (!identical(row_col, '__none__')) p <- p + facet_wrap(~row_group, scales = 'free_x')",
      "  apply_style(p)",
      "}",
      "build_umap <- function(show_title = TRUE) {",
      "  emb <- Seurat::Embeddings(sobj, reduction = reduction_name)",
      "  cells <- rownames(emb)",
      "  d <- data.frame(cell = cells, UMAP_1 = emb[, 1], UMAP_2 = emb[, 2], column_group = clean_group(md[cells, condition_col]), row_group = if (identical(row_col, '__none__')) 'All' else clean_group(md[cells, row_col]), stringsAsFactors = FALSE)",
      "  d$clone <- clean_clone(md[cells, clone_col])",
      "  d$is_selected <- !is.na(d$clone) & d$clone %in% selected_ids",
      "  d$plot_clone <- ifelse(d$is_selected, unname(label_lookup[d$clone]), 'Background')",
      "  pooled_counts <- table(clones[!is.na(clones)])",
      "  d$clone_size <- as.numeric(pooled_counts[d$clone])",
      "  if (identical(analysis_recipe$clone_size_scope, 'facet')) {",
      "    ok <- !is.na(d$clone)",
      "    key <- interaction(d$clone, d$row_group, d$column_group, drop = TRUE)",
      "    d$clone_size[ok] <- ave(rep(1, sum(ok)), key[ok], FUN = sum)",
      "  }",
      "  d$clone_size[!is.finite(d$clone_size)] <- 0",
      "  d <- d[order(d$is_selected, d$clone_size), , drop = FALSE]",
      "  if (identical(figure_recipe$color_mode, 'clone_size')) {",
      "    p <- ggplot(d, aes(UMAP_1, UMAP_2)) +",
      "      geom_point(data = d[!d$is_selected, ], color = background_point, size = 0.42, alpha = 0.55) +",
      "      geom_point(data = d[d$is_selected, ], aes(color = clone_size), size = 0.5, alpha = 0.95) +",
      "      scale_color_viridis_c(trans = 'log1p', name = 'Clone size')",
      "  } else {",
      "    p <- ggplot(d, aes(UMAP_1, UMAP_2, color = plot_clone)) + geom_point(size = 0.48, alpha = 0.9) +",
      "      scale_color_manual(values = c(selected_colors, 'Background' = background_point), drop = FALSE, name = 'Clone')",
      "  }",
      "  p <- add_facets(p) + coord_fixed() + labs(title = if (show_title) if (nzchar(figure_recipe$title)) figure_recipe$title else 'Selected clone UMAP' else NULL, x = paste(reduction_name, '1'), y = paste(reduction_name, '2'))",
      "  apply_style(p)",
      "}",
      "",
      "# 6) Build selected output",
      "plot_type <- figure_recipe$plot_type",
      "if (plot_type == 'stacked_bar') p <- build_bar()",
      "if (plot_type == 'tracking_line') p <- build_tracking()",
      "if (plot_type == 'alluvial') p <- build_alluvial()",
      "if (plot_type == 'facet_umap') p <- build_umap(TRUE)",
      "if (plot_type == 'combined') p <- wrap_plots(build_umap(FALSE), build_bar() + labs(title = NULL), ncol = 1, heights = c(3, 1)) + plot_annotation(title = if (nzchar(figure_recipe$title)) figure_recipe$title else 'VDJ clone expansion')",
      "print(p)"
    )
    paste(lines, collapse = "\n")
  })
  
  figure_code_card_server(
    "figure_tcr_studio_code_card",
    code_text_reactive = .generate_tcr_studio_script,
    shared_data = shared_data,
    object_name_reactive = selected_dataset_name,
    studio_name = "TCR/BCR Studio"
  )
  
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
