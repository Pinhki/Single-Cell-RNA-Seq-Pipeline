# R/page_recluster_ui.R
RECLUSTER_UI_TEXT <- list(
  t_btn_create_analyze_subset = "Create and Analyze Subset",
  t_btn_re_cluster_selected_cells = "Re-cluster Selected Cells",
  t_btn_save_selection_group = "Save Selection as Group",
  t_btn_update_plot = "Update Plot",
  t_label_axis_scale = "Axis Scale:",
  t_label_color = "Color by:",
  t_label_color_umap = "Color UMAP by:",
  t_label_dot_outline_color = "Dot Outline Color:",
  t_label_dot_outline_width = "Dot Outline Width:",
  t_label_dot_size = "Dot Size:",
  t_label_dot_transparency_alpha = "Dot Transparency (Alpha):",
  t_label_e_g_cd4 = "e.g., CD4",
  t_label_e_g_cd8a = "e.g., CD8A",
  t_label_e_g_t_cells = "e.g., T-cells",
  t_label_enter_name_new_subset = "Enter a name for this new subset:",
  t_label_expression = "Expression >",
  t_label_expression_2 = "Expression ==",
  t_label_gene_1_green_channel = "Gene 1 (Green Channel):",
  t_label_gene_2_blue_channel = "Gene 2 (Blue Channel):",
  t_label_gene_x_axis = "Gene for X-axis:",
  t_label_gene_y_axis = "Gene for Y-axis:",
  t_label_highlight_dot_size = "Highlight Dot Size:",
  t_label_import_cell_barcodes_txt_csv = "Import Cell Barcodes (.txt/.csv):",
  t_label_negative_selection_gene = "Negative Selection Gene:",
  t_label_new_group_name = "New Group Name:",
  t_label_positive_selection_gene = "Positive Selection Gene:",
  t_label_select_active_dataset = "Select Active Dataset:",
  t_label_select_assay_visualization = "Select Assay for Visualization:",
  t_label_split_umap = "Split UMAP by:",
  t_text_cells = " cells)",
  t_text_define_rules_select_cells_based_expression = "Define rules to select cells based on expression levels.",
  t_text_e_g_cd4_t_cells = "e.g., CD4_T_Cells",
  t_text_creating_subset_object_for_analysis = "Creating subset object for analysis…",
  t_text_expression_visualized_gene_shown_yellow_all = "Expression of the visualized gene is shown in yellow. All currently selected cells are highlighted in red.",
  t_text_name_new_subset = "Name New Subset",
  t_text_no_groups_created_yet = "No groups created yet.",
  t_text_rownames_plot_df = "rownames(plot_df)",
  t_text_use_lasso_select_tool_then_name = "Use the 'Lasso Select' tool, then name and save the selection.",
  t_text_use_lasso_select_tool_umap_upload = "Use the 'Lasso Select' tool on the UMAP, OR upload a list of cell barcodes below.",
  t_text_use_tools_below_select_specific_population = "Use the tools below to select a specific population of cells for a more focused analysis. You can filter by gene expression, manually select cells on the UMAP, or both.",
  t_text_use_tools_below_select_specific_population_2 = "Use the tools below to select a specific population of cells...",
  t_text_will_take_final_subset_cells_send = "This will take the final subset of cells and send them back to the Analysis page for re-integration and re-clustering.",
  t_title_1_filter_gene_expression = "1. Filter by Gene Expression",
  t_title_2_filter_manual_selection = "2. Filter by Manual Selection",
  t_title_3_re_cluster_selected_population = "3. Re-cluster Selected Population",
  t_title_analysis_interactive_subsetting_re_clustering = "Analysis: Interactive Subsetting and Re-clustering",
  t_title_cell_group_management = "Cell Group Management",
  t_title_gene_scatter_plot = "Gene Scatter Plot",
  t_title_interactive_umap = "Interactive UMAP",
  t_title_saved_groups = "Saved Groups:",
  t_title_scatter_plot_visualization = "Scatter Plot Visualization",
  t_title_subset_controls = "Subset Controls",
  t_title_umap_plot = "UMAP Plot",
  t_title_umap_visualization = "UMAP Visualization",
  t_title_visualization_controls = "Visualization Controls",
  t_btn_delete = "Delete"

)

library(plotly)

recluster_with_busy_spinner <- function(output_ui, spinner = c("other", "umap", "clustertree")) {
  spinner <- match.arg(spinner)
  fn <- tryCatch(get0("analysis_with_busy_spinner", mode = "function", inherits = TRUE), error = function(e) NULL)
  if (is.function(fn)) {
    return(fn(output_ui, spinner = spinner))
  }
  withSpinner(output_ui)
}

recluster_ui <- fluidPage(
  class = "plotting-page",
  tags$head(
    tags$style(HTML("
      .recluster-page {
        --plot-scroll-box-h: calc(var(--app-viewport-h) - var(--nav-h) - var(--footer-h));
        --recluster-umap-offset: 190px;
        --recluster-scatter-offset: 150px;
      }
      .recluster-page .recluster-object-selector .card-page-content {
        padding-top: 8px;
      }
      .recluster-page .analysis-object-selector-wrap{
        display:flex;
        justify-content:flex-end;
      }
      .recluster-page .analysis-object-selector-card{
        width:min(100%, 520px);
        margin:0 0 0 auto;
        padding:10px 12px;
      }
      .recluster-page .analysis-object-selector-card-top{
        padding:0;
        background:transparent;
        border:0;
        box-shadow:none;
      }
      .recluster-page .analysis-object-selector-card .form-group,
      .recluster-page .analysis-object-selector-card .shiny-input-container{
        margin-bottom:0;
      }
      .recluster-page .analysis-object-selector-card .control-label{
        margin-bottom:6px;
      }
      .recluster-page .analysis-object-selector-card-top .shiny-input-container{
        width:min(100%, 420px);
        margin-left:auto;
      }
      .recluster-page .recluster-header-row {
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
        gap: 12px;
        margin-bottom: 8px;
      }
      .recluster-page .recluster-header-main {
        min-width: 0;
        flex: 1 1 auto;
      }
      .recluster-page .recluster-header-main .card-page-header {
        margin-bottom: 0;
      }
      .recluster-page .recluster-header-selector {
        width: min(100%, 520px);
        margin-left: auto;
        flex: 0 0 auto;
      }
      @media (max-width: 991px) {
        .recluster-page .recluster-header-row {
          flex-direction: row !important;
          align-items: center !important;
          flex-wrap: nowrap !important;
          gap: 12px;
        }
        .recluster-page .recluster-header-main {
          flex: 1 1 auto !important;
          width: auto !important;
          min-width: 0;
        }
        .recluster-page .recluster-header-selector {
          flex: 0 0 auto !important;
          width: auto !important;
          max-width: 320px !important;
          margin-left: auto;
        }
        .recluster-page .analysis-object-selector-wrap {
          justify-content: flex-end;
          margin-top: 0;
        }
        .recluster-page .analysis-object-selector-card {
          width: 100%;
          min-width: 200px;
          margin: 0;
        }
        .recluster-page .analysis-object-selector-card-top .shiny-input-container {
          width: 100%;
          margin-left: 0;
        }
      }
      .recluster-page .recluster-fold {
        border-radius: 10px;
        border: 0;
        padding: 10px 12px;
        background: var(--card);
        box-shadow: 0 10px 34px rgba(15, 23, 42, 0.035), 0 2px 8px rgba(15, 23, 42, 0.018);
      }
      .recluster-page .plotting-left-panel > .wl-side{
        background: transparent !important;
        border: 0 !important;
        box-shadow: none !important;
        padding: 0 !important;
      }
      .recluster-page .plotting-left-panel{
        background: transparent !important;
        border: 0 !important;
        box-shadow: none !important;
      }
      .recluster-page .recluster-fold + .recluster-fold {
        margin-top: 10px;
      }
      .recluster-page .recluster-fold > summary {
        font-weight: 700;
        cursor: pointer;
        list-style: none;
        outline: none;
      }
      .recluster-page .recluster-fold > summary::-webkit-details-marker {
        display: none;
      }
      .recluster-page .recluster-fold[open] > summary {
        margin-bottom: 8px;
      }
      .recluster-page .recluster-plot-shell {
        height: auto;
        min-height: 0;
        display: grid;
        grid-template-columns: minmax(0, 1fr) 180px;
        gap: 12px;
        align-items: stretch;
      }
      .recluster-page .recluster-plot-main {
        height: auto;
        min-height: 0;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .recluster-page .recluster-plot-main .analysis-load-wrap,
      .recluster-page .recluster-scatter-shell .analysis-load-wrap {
        height: auto;
      }
      .recluster-page .recluster-plot-main .plotly,
      .recluster-page .recluster-plot-main .js-plotly-plot,
      .recluster-page .recluster-plot-main .shiny-plot-output {
        width: 100% !important;
        height: auto !important;
      }
      .recluster-page .recluster-plot-legend {
        height: auto;
      }
      .recluster-page .recluster-plot-legend .plotly,
      .recluster-page .recluster-plot-legend .js-plotly-plot,
      .recluster-page .recluster-plot-legend .shiny-plot-output {
        width: 100% !important;
        height: auto !important;
      }
      .recluster-page .recluster-scatter-shell {
        height: auto;
        min-height: 0;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .recluster-page .recluster-scatter-shell .plotly,
      .recluster-page .recluster-scatter-shell .js-plotly-plot,
      .recluster-page .recluster-scatter-shell .shiny-plot-output {
        width: 100% !important;
        height: auto !important;
      }
      .recluster-page #recluster_legend_plot {
        height: 140px !important;
      }
      .recluster-page #recluster_umap_plot {
        height: calc(var(--plot-scroll-box-h) - var(--recluster-umap-offset)) !important;
        min-height: 460px !important;
        margin: 0 auto !important;
      }
      .recluster-page #recluster_scatter_plot {
        height: calc(var(--plot-scroll-box-h) - var(--recluster-scatter-offset)) !important;
        min-height: 460px !important;
        margin: 0 auto !important;
      }
      @media (max-width: 991px) {
        .recluster-page {
          --recluster-umap-offset: 240px;
          --recluster-scatter-offset: 220px;
        }
        .recluster-page .recluster-plot-shell{
          grid-template-columns: 1fr;
          gap: 10px;
        }
        .recluster-page .recluster-scatter-shell{
          min-height: 420px;
        }
        .recluster-page #recluster_umap_plot,
        .recluster-page #recluster_scatter_plot{
          min-height: 420px !important;
        }
      }
      .recluster-page .recluster-delete-btn{
        min-width: 88px;
      }
    "))
  ),
  div(
    class = "recluster-page",
    div(
      class = "recluster-header-row",
      div(
        class = "recluster-header-main",
        card_page_header(
          title = RECLUSTER_UI_TEXT$t_title_analysis_interactive_subsetting_re_clustering,
          subtitle = RECLUSTER_UI_TEXT$t_text_use_tools_below_select_specific_population,
          icon_name = "object-group"
        )
      ),
      div(
        class = "recluster-header-selector",
        div(
          class = "analysis-object-selector-wrap",
          uiOutput("recluster_object_selector_ui")
        )
      )
    ),
    fluidRow(
      column(
        width = 3,
        class = "plotting-left-panel",
        div(
          class = "wl-side",
          tags$details(
            class = "recluster-fold",
            open = NA,
            tags$summary(RECLUSTER_UI_TEXT$t_title_visualization_controls),
            div(
              id = "umap_controls",
              selectInput("assay_select", RECLUSTER_UI_TEXT$t_label_select_assay_visualization, choices = NULL),
              selectInput("color_by_select", RECLUSTER_UI_TEXT$t_label_color_umap,
                          choices = c("None", "Single Gene Expression", "Two-Gene Overlay")),
              selectInput("split_by_select", RECLUSTER_UI_TEXT$t_label_split_umap, choices = c("None")),
              conditionalPanel(
                condition = "input.color_by_select == 'Single Gene Expression' || input.color_by_select == 'Two-Gene Overlay'",
                wl_gene_selectize_input("gene_expr_select_1", RECLUSTER_UI_TEXT$t_label_gene_1_green_channel),
                conditionalPanel(
                  condition = "input.color_by_select == 'Two-Gene Overlay'",
                  wl_gene_selectize_input("gene_expr_select_2", RECLUSTER_UI_TEXT$t_label_gene_2_blue_channel)
                )
              ),
              actionButton("update_viz_btn", RECLUSTER_UI_TEXT$t_btn_update_plot, icon = icon("sync-alt")),
              hr(),
              sliderInput("dot_size", RECLUSTER_UI_TEXT$t_label_dot_size, min = 0.1, max = 5, value = 0.5, step = 0.1),
              sliderInput("dot_alpha", RECLUSTER_UI_TEXT$t_label_dot_transparency_alpha, min = 0.1, max = 1, value = 0.8, step = 0.1),
              sliderInput("stroke_width", RECLUSTER_UI_TEXT$t_label_dot_outline_width, min = 0, max = 2, value = 0.0, step = 0.1),
              sliderInput("highlight_width", RECLUSTER_UI_TEXT$t_label_highlight_dot_size, min = 0, max = 2, value = 0.4, step = 0.1),
              selectInput("stroke_color", RECLUSTER_UI_TEXT$t_label_dot_outline_color,
                          choices = c("black", "white", "grey50"), selected = "black")
            ),
            shinyjs::hidden(
              div(
                id = "scatter_controls",
                selectInput("scatter_assay_select", RECLUSTER_UI_TEXT$t_label_select_assay_visualization, choices = NULL),
                wl_gene_selectize_input("scatter_gene_x", RECLUSTER_UI_TEXT$t_label_gene_x_axis),
                wl_gene_selectize_input("scatter_gene_y", RECLUSTER_UI_TEXT$t_label_gene_y_axis),
                checkboxGroupInput("scatter_log_scale", RECLUSTER_UI_TEXT$t_label_axis_scale, choices = c("Log Scale X-axis", "Log Scale Y-axis")),
                hr(),
                selectInput("scatter_color_by", RECLUSTER_UI_TEXT$t_label_color, choices = NULL)
              )
            )
          ),
          tags$details(
            class = "recluster-fold",
            open = NA,
            tags$summary(RECLUSTER_UI_TEXT$t_title_cell_group_management),
            p(RECLUSTER_UI_TEXT$t_text_use_lasso_select_tool_then_name),
            textInput("new_group_name", RECLUSTER_UI_TEXT$t_label_new_group_name, placeholder = RECLUSTER_UI_TEXT$t_label_e_g_t_cells),
            actionButton("add_selection_btn", RECLUSTER_UI_TEXT$t_btn_save_selection_group, icon = icon("plus")),
            hr(),
            h5(RECLUSTER_UI_TEXT$t_title_saved_groups),
            uiOutput("cell_groups_ui")
          ),
          tags$details(
            class = "recluster-fold",
            open = NA,
            tags$summary(RECLUSTER_UI_TEXT$t_title_1_filter_gene_expression),
            p(RECLUSTER_UI_TEXT$t_text_define_rules_select_cells_based_expression),
            textInput("gene_pos_select", RECLUSTER_UI_TEXT$t_label_positive_selection_gene, placeholder = RECLUSTER_UI_TEXT$t_label_e_g_cd4),
            numericInput("gene_pos_thresh", RECLUSTER_UI_TEXT$t_label_expression, value = 0, min = 0),
            textInput("gene_neg_select", RECLUSTER_UI_TEXT$t_label_negative_selection_gene, placeholder = RECLUSTER_UI_TEXT$t_label_e_g_cd8a),
            numericInput("gene_neg_thresh", RECLUSTER_UI_TEXT$t_label_expression_2, value = 0, min = 0)
          ),
          tags$details(
            class = "recluster-fold",
            open = NA,
            tags$summary("Filter by Selected Clusters"),
            selectInput("cluster_filter_column", "Cluster metadata column:", choices = NULL),
            selectizeInput(
              "cluster_filter_values",
              "Filter by selected clusters:",
              choices = NULL,
              multiple = TRUE,
              options = list(
                plugins = list("remove_button"),
                placeholder = "Select cluster values"
              )
            )
          ),
          tags$details(
            class = "recluster-fold",
            open = NA,
            tags$summary(RECLUSTER_UI_TEXT$t_title_2_filter_manual_selection),
            p(RECLUSTER_UI_TEXT$t_text_use_lasso_select_tool_umap_upload),
            fileInput("import_barcodes_file", RECLUSTER_UI_TEXT$t_label_import_cell_barcodes_txt_csv, accept = c(".txt", ".csv", ".tsv")),
            uiOutput("recluster_sidebar_barcode_source_ui"),
            actionButton("import_sidebar_barcodes_btn", "Import Selected Sidebar Barcode File(s)", class = "btn btn-default btn-sm"),
            div(style = "height: 6px;"),
            verbatimTextOutput("selected_cell_count_output")
          ),
          tags$details(
            class = "recluster-fold",
            open = NA,
            tags$summary(RECLUSTER_UI_TEXT$t_title_3_re_cluster_selected_population),
            p(RECLUSTER_UI_TEXT$t_text_will_take_final_subset_cells_send),
            verbatimTextOutput("final_cell_count_output"),
            actionButton("run_recluster_btn", RECLUSTER_UI_TEXT$t_btn_re_cluster_selected_cells, icon = icon("sync-alt"), class = "btn-success")
          )
        )
      ),
      column(
        width = 9,
        class = "plot_area_card_style",
        div(
          class = "wl-side",
          h4(RECLUSTER_UI_TEXT$t_title_interactive_umap),
          p(RECLUSTER_UI_TEXT$t_text_expression_visualized_gene_shown_yellow_all),
          tabsetPanel(
            id = "recluster_tabs",
            tabPanel(
              RECLUSTER_UI_TEXT$t_title_umap_plot,
              div(
                class = "recluster-plot-shell",
                div(class = "recluster-plot-main", recluster_with_busy_spinner(plotlyOutput("recluster_umap_plot", height = "100%"), spinner = "umap")),
                div(class = "recluster-plot-legend", recluster_with_busy_spinner(plotlyOutput("recluster_legend_plot", height = "150px"), spinner = "other"))
              )
            ),
            tabPanel(
              RECLUSTER_UI_TEXT$t_title_gene_scatter_plot,
              div(class = "recluster-scatter-shell", recluster_with_busy_spinner(plotlyOutput("recluster_scatter_plot", height = "100%"), spinner = "other"))
            )
          )
        )
      )
    )
  )
)

# R/page_recluster_server.R
library(plotly)
library(dplyr)
library(ggplot2)
`%||%` <- function(a, b) if (is.null(a)) b else a

recluster_server <- function(input, output, session, shared_data) {
  
  recluster_data <- reactiveValues(
    seurat_obj = NULL,
    plot_df = NULL,
    cell_groups = list(),
    selected_cells = character(0),
    imported_barcode_sources = character(0)
  )

  .norm_key <- function(x) gsub("[^a-z0-9]", "", tolower(as.character(x %||% "")))
  .strip_suffix <- function(x) sub("([._-][0-9]+)$", "", as.character(x %||% ""), perl = TRUE)
  .barcode_keys <- function(x) {
    x <- trimws(as.character(x %||% ""))
    if (!nzchar(x)) return(character(0))
    no_suffix <- .strip_suffix(x)
    tokens <- unlist(strsplit(no_suffix, "[^A-Za-z0-9]+", perl = TRUE), use.names = FALSE)
    dna <- regmatches(no_suffix, gregexpr("[ACGTNacgtn]{8,}", no_suffix, perl = TRUE))[[1]]
    cand <- unique(c(x, no_suffix, tokens, dna))
    keys <- .norm_key(cand)
    keys <- unique(keys[nzchar(keys)])
    long_keys <- keys[nchar(keys) >= 6]
    if (length(long_keys)) return(long_keys)
    keys
  }
  .pick_barcode_col <- function(nms) {
    nms <- as.character(nms %||% character(0))
    if (!length(nms)) return(NA_character_)
    hit <- grep("barcode|cell", nms, ignore.case = TRUE, value = TRUE)[1]
    if (!is.na(hit) && nzchar(hit)) return(hit)
    nms[[1]]
  }
  .read_barcodes_from_path <- function(path) {
    p <- as.character(path %||% "")
    if (!nzchar(p) || !file.exists(p) || dir.exists(p)) return(character(0))
    ext <- tolower(tools::file_ext(p))
    if (identical(ext, "txt")) {
      vals <- readLines(p, warn = FALSE)
      vals <- trimws(vals)
      return(unique(vals[nzchar(vals)]))
    }
    read_fun <- if (identical(ext, "csv")) utils::read.csv else utils::read.delim
    df <- tryCatch(read_fun(p, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE), error = function(e) NULL)
    if (is.null(df) || !is.data.frame(df) || !nrow(df)) {
      df <- tryCatch(read_fun(p, header = FALSE, stringsAsFactors = FALSE, check.names = FALSE), error = function(e) NULL)
    }
    if (is.null(df) || !is.data.frame(df) || !nrow(df) || !ncol(df)) return(character(0))
    bc_col <- .pick_barcode_col(colnames(df))
    vals <- trimws(as.character(df[[bc_col]] %||% character(0)))
    unique(vals[nzchar(vals)])
  }
  .match_barcodes_to_cells <- function(barcodes, all_cells) {
    barcodes <- unique(trimws(as.character(barcodes %||% character(0))))
    barcodes <- barcodes[nzchar(barcodes)]
    all_cells <- as.character(all_cells %||% character(0))
    if (!length(barcodes) || !length(all_cells)) return(character(0))

    key_rows <- lapply(seq_along(all_cells), function(i) {
      ks <- .barcode_keys(all_cells[[i]])
      if (!length(ks)) return(NULL)
      data.frame(row = rep.int(i, length(ks)), key = ks, stringsAsFactors = FALSE)
    })
    key_rows <- key_rows[!vapply(key_rows, is.null, logical(1))]
    key_lookup <- if (!length(key_rows)) list() else split(do.call(rbind, key_rows)$row, do.call(rbind, key_rows)$key)

    hit_rows <- integer(0)
    for (bc in barcodes) {
      keys <- .barcode_keys(bc)
      cand <- unique(unlist(key_lookup[keys], use.names = FALSE))
      if (!length(cand)) {
        base <- .strip_suffix(bc)
        if (nzchar(base)) {
          cand <- which(.strip_suffix(all_cells) == base | grepl(base, all_cells, fixed = TRUE))
        }
      }
      if (!length(cand)) next
      score <- integer(length(cand))
      score[all_cells[cand] == bc] <- score[all_cells[cand] == bc] + 4L
      score[.strip_suffix(all_cells[cand]) == .strip_suffix(bc)] <- score[.strip_suffix(all_cells[cand]) == .strip_suffix(bc)] + 2L
      score[grepl(bc, all_cells[cand], fixed = TRUE)] <- score[grepl(bc, all_cells[cand], fixed = TRUE)] + 1L
      best <- cand[score == max(score)]
      hit_rows <- c(hit_rows, best)
    }
    unique(all_cells[unique(hit_rows)])
  }
  
  gene_to_display_1 <- eventReactive(input$update_viz_btn, {
    input$gene_expr_select_1
  }, ignoreNULL = FALSE)
  
  # This captures the value from the second gene selector
  gene_to_display_2 <- eventReactive(input$update_viz_btn, {
    input$gene_expr_select_2
  }, ignoreNULL = FALSE)
  
  # 1. This renders the dataset selector dropdown UI
  output$recluster_object_selector_ui <- renderUI({
    object_choices <- names(shared_data$all_seurat_objects)
    req(length(object_choices) > 0)
    
    div(
      class = "analysis-object-selector-card analysis-object-selector-card-top",
      `data-canonical-value` = shared_data$active_object_name,
      tags$label(class = "control-label", RECLUSTER_UI_TEXT$t_label_select_active_dataset),
      selectInput(
        "recluster_dataset_select",
        label = NULL,
        choices = object_choices,
        selected = shared_data$active_object_name
      )
    )
  })
  
  # 2. This observer updates the active dataset when the user changes the dropdown
  observeEvent(input$recluster_dataset_select, {
    req(input$recluster_dataset_select)
    shared_data$active_object_name <- input$recluster_dataset_select
  })
  
  observeEvent(input$recluster_tabs, {
    if (input$recluster_tabs == "UMAP Plot") {
      shinyjs::show("umap_controls")
      shinyjs::hide("scatter_controls")
    } else {
      shinyjs::hide("umap_controls")
      shinyjs::show("scatter_controls")
    }
  })
  
  # Observer to SAVE a new cell group
  observeEvent(input$add_selection_btn, {
    selected <- event_data("plotly_selected", source = "recluster_plot_source")
    req(selected, nrow(selected) > 0, isTruthy(input$new_group_name))
    
    group_name <- input$new_group_name
    recluster_data$cell_groups[[group_name]] <- selected$key
    updateTextInput(session, "new_group_name", value = "")
    runjs("Shiny.setInputValue('plotly_selected-recluster_plot_source', null);")
  })
  
  # Renders the dynamic list of groups with delete buttons
  output$cell_groups_ui <- renderUI({
    groups <- names(recluster_data$cell_groups)
    if (length(groups) == 0) return(p(RECLUSTER_UI_TEXT$t_text_no_groups_created_yet))
    
    lapply(groups, function(name) {
      fluidRow(
        column(8, p(strong(name), paste0("(", length(recluster_data$cell_groups[[name]]), RECLUSTER_UI_TEXT$t_text_cells))),
        column(4, actionButton(
          inputId = paste0("delete_", name),
          label = RECLUSTER_UI_TEXT$t_btn_delete,
          icon = icon("trash"),
          class = "btn btn-outline-danger btn-sm recluster-delete-btn"
        ))
      )
    })
  })
  
  # Creates an observer for EACH delete button that appears
  observe({
    lapply(names(recluster_data$cell_groups), function(name) {
      observeEvent(input[[paste0("delete_", name)]], {
        recluster_data$cell_groups[[name]] <- NULL
      })
    })
  })
  .is_reasonable_discrete <- function(v) {
    if (is.factor(v) || is.character(v) || is.logical(v)) return(TRUE)
    if (is.numeric(v) || is.integer(v)) return(length(unique(stats::na.omit(v))) <= 40L)
    FALSE
  }

  .is_supported_meta_column <- function(v) {
    is.atomic(v) || is.factor(v)
  }

  .safe_assay_choices <- function(obj) {
    assays_raw <- tryCatch(SeuratObject::Assays(obj), error = function(e) NULL)
    if (is.null(assays_raw)) assays_raw <- tryCatch(Assays(obj), error = function(e) NULL)

    assays_chr <- character(0)
    if (is.character(assays_raw) || is.factor(assays_raw)) {
      assays_chr <- as.character(assays_raw)
    } else if (is.list(assays_raw)) {
      named <- names(assays_raw) %||% character(0)
      named <- named[nzchar(named)]
      if (length(named)) assays_chr <- named
    } else {
      named <- tryCatch(names(assays_raw), error = function(e) character(0))
      named <- as.character(named %||% character(0))
      named <- named[nzchar(named)]
      if (length(named)) assays_chr <- named
    }

    assays_chr <- assays_chr[!is.na(assays_chr) & nzchar(assays_chr)]
    assays_chr <- unique(assays_chr)
    if (length(assays_chr)) return(assays_chr)

    fallback <- tryCatch(names(obj@assays), error = function(e) character(0))
    fallback <- as.character(fallback %||% character(0))
    fallback <- fallback[!is.na(fallback) & nzchar(fallback)]
    unique(fallback)
  }

  .load_active_recluster_object <- function(active_name) {
    if (!nzchar(active_name %||% "")) return(invisible(NULL))
    entry <- shared_data$all_seurat_objects[[active_name]]
    obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (is.null(obj) || !inherits(obj, "Seurat") || !("umap" %in% names(obj@reductions))) {
      recluster_data$seurat_obj <- NULL
      recluster_data$plot_df <- NULL
      recluster_data$cell_groups <- list()
      recluster_data$selected_cells <- character(0)
      recluster_data$imported_barcode_sources <- character(0)
      return(invisible(NULL))
    }

    plot_df <- data.frame(
      UMAP_1 = obj@reductions$umap@cell.embeddings[, 1],
      UMAP_2 = obj@reductions$umap@cell.embeddings[, 2],
      row.names = colnames(obj)
    )

    assay_choices <- .safe_assay_choices(obj)
    assay_to_use <- as.character(DefaultAssay(obj) %||% "")
    if (!nzchar(assay_to_use) || !(assay_to_use %in% assay_choices)) {
      assay_to_use <- if (length(assay_choices)) assay_choices[[1]] else ""
    }
    all_genes <- if (nzchar(assay_to_use)) rownames(obj[[assay_to_use]]) else character(0)
    wl_update_gene_selectize(session, "gene_expr_select_1", all_genes)
    wl_update_gene_selectize(session, "gene_expr_select_2", all_genes)
    wl_update_gene_selectize(session, "scatter_gene_x", all_genes)
    wl_update_gene_selectize(session, "scatter_gene_y", all_genes)
    updateSelectInput(session, "assay_select", choices = assay_choices, selected = if (nzchar(assay_to_use)) assay_to_use else character(0))
    updateSelectInput(session, "scatter_assay_select", choices = assay_choices, selected = if (nzchar(assay_to_use)) assay_to_use else character(0))

    md <- obj@meta.data
    available_cols <- colnames(md)[vapply(md, .is_supported_meta_column, logical(1))]
    available_cols <- available_cols[!is.na(available_cols) & nzchar(available_cols)]
    if (length(available_cols) > 0) {
      plot_df <- cbind(plot_df, md[, available_cols, drop = FALSE])
    }

    recluster_data$seurat_obj <- obj
    recluster_data$plot_df <- plot_df
    recluster_data$cell_groups <- list()
    recluster_data$selected_cells <- character(0)
    recluster_data$imported_barcode_sources <- character(0)

    default_color <- if ("seurat_clusters" %in% available_cols) {
      "seurat_clusters"
    } else if ("orig.ident" %in% available_cols) {
      "orig.ident"
    } else if (length(available_cols)) {
      available_cols[[1]]
    } else {
      "None"
    }
    updateSelectInput(session, "color_by_select", choices = c("None", "Single Gene Expression", "Two-Gene Overlay", available_cols), selected = default_color)
    split_choices <- colnames(md)[vapply(md, .is_reasonable_discrete, logical(1))]
    split_choices <- split_choices[!is.na(split_choices) & nzchar(split_choices)]
    updateSelectInput(session, "split_by_select", choices = c("None", split_choices))
    default_scatter <- if ("seurat_clusters" %in% available_cols) "seurat_clusters" else if (length(available_cols)) available_cols[[1]] else "None"
    updateSelectInput(session, "scatter_color_by", choices = c("None", available_cols), selected = default_scatter)
    discrete_cols <- colnames(md)[vapply(md, .is_reasonable_discrete, logical(1))]
    default_cluster_col <- if ("seurat_clusters" %in% discrete_cols) "seurat_clusters" else if (length(discrete_cols)) discrete_cols[[1]] else "None"
    cluster_choices <- c("None", discrete_cols)
    updateSelectInput(session, "cluster_filter_column", choices = cluster_choices, selected = default_cluster_col)
    if (!identical(default_cluster_col, "None") && default_cluster_col %in% colnames(md)) {
      vals <- sort(unique(as.character(md[[default_cluster_col]])))
      vals <- vals[nzchar(vals)]
      updateSelectizeInput(session, "cluster_filter_values", choices = vals, selected = character(0), server = TRUE)
    } else {
      updateSelectizeInput(session, "cluster_filter_values", choices = character(0), selected = character(0), server = TRUE)
    }
    invisible(NULL)
  }

  observeEvent(input$main_navbar, {
    if (identical(input$main_navbar %||% "", "recluster_tab")) {
      .load_active_recluster_object(shared_data$active_object_name %||% "")
    }
  }, ignoreInit = FALSE)

  observeEvent(shared_data$active_object_name, {
    if (identical(input$main_navbar %||% "", "recluster_tab")) {
      .load_active_recluster_object(shared_data$active_object_name %||% "")
    }
  }, ignoreInit = TRUE)

  observeEvent(input$cluster_filter_column, {
    obj <- recluster_data$seurat_obj
    req(obj)
    col_name <- as.character(input$cluster_filter_column %||% "None")
    if (!nzchar(col_name) || identical(col_name, "None") || !(col_name %in% colnames(obj@meta.data))) {
      updateSelectizeInput(session, "cluster_filter_values", choices = character(0), selected = character(0), server = TRUE)
      return(invisible(NULL))
    }
    vals <- sort(unique(as.character(obj@meta.data[[col_name]])))
    vals <- vals[nzchar(vals)]
    updateSelectizeInput(session, "cluster_filter_values", choices = vals, selected = character(0), server = TRUE)
    invisible(NULL)
  }, ignoreInit = TRUE)

  output$recluster_sidebar_barcode_source_ui <- renderUI({
    tab <- shared_data$imported_tabular_files
    if (is.null(tab) || !is.data.frame(tab) || !nrow(tab) || !all(c("name", "path") %in% colnames(tab))) {
      return(helpText("No imported tabular files available from Data Files."))
    }
    tab <- tab[!is.na(tab$path) & nzchar(as.character(tab$path)), , drop = FALSE]
    if (!nrow(tab)) return(helpText("No imported tabular files available from Data Files."))
    labels <- sprintf("%s (%s)", as.character(tab$name), basename(as.character(tab$path)))
    choices <- stats::setNames(as.character(tab$path), labels)
    selectizeInput(
      "recluster_sidebar_barcode_paths",
      "Barcode file(s) from Data Files:",
      choices = choices,
      selected = character(0),
      multiple = TRUE,
      options = list(plugins = list("remove_button"), placeholder = "Choose imported barcode files")
    )
  })

  observeEvent(shared_data$selected_sidebar_items, {
    items <- shared_data$selected_sidebar_items
    if (is.null(items) || !is.data.frame(items) || !nrow(items)) return(invisible(NULL))
    keys <- as.character(items$key %||% character(0))
    paths <- sub("^csv::", "", keys[grepl("^csv::", keys)])
    if (!length(paths)) return(invisible(NULL))
    current <- as.character(input$recluster_sidebar_barcode_paths %||% character(0))
    updateSelectizeInput(
      session,
      "recluster_sidebar_barcode_paths",
      selected = unique(c(current, paths)),
      server = TRUE
    )
    invisible(NULL)
  }, ignoreInit = TRUE)

  cluster_selected_cells <- reactive({
    obj <- recluster_data$seurat_obj
    req(obj)
    col_name <- as.character(input$cluster_filter_column %||% "None")
    vals <- as.character(input$cluster_filter_values %||% character(0))
    if (!nzchar(col_name) || identical(col_name, "None") || !length(vals) || !(col_name %in% colnames(obj@meta.data))) {
      return(character(0))
    }
    md_vals <- as.character(obj@meta.data[[col_name]])
    rownames(obj@meta.data)[md_vals %in% vals]
  })

  all_selected_cells <- reactive({
    group_cells <- unique(unlist(recluster_data$cell_groups))
    barcode_cells <- as.character(recluster_data$selected_cells %||% character(0))
    cluster_cells <- as.character(cluster_selected_cells() %||% character(0))
    selected <- unique(c(group_cells, barcode_cells, cluster_cells))
    selected[nzchar(selected)]
  })
  
  # --- This observer updates the plot data frame for highlighting ---
  final_plot_df <- reactive({
    req(recluster_data$plot_df, recluster_data$seurat_obj)
    
    plot_df <- recluster_data$plot_df
    
    gene_input_1 <- gene_to_display_1() # We will create this reactive next
    gene_input_2 <- gene_to_display_2()
    color_mode <- input$color_by_select
    plot_df$gene1_expr <- 0
    plot_df$gene2_expr <- 0
    #plot_df$gene_to_viz <- 0 # Default to 0 expression
    
    
    if (isTruthy(gene_input_1) && (color_mode == "Single Gene Expression" || color_mode == "Two-Gene Overlay")) {
      # Determine the correct assay to use for visualization
      assay_to_use <- DefaultAssay(recluster_data$seurat_obj)
      all_genes <- rownames(recluster_data$seurat_obj[[assay_to_use]])
      
      # Perform a case-insensitive search
      gene_match <- all_genes[tolower(all_genes) == tolower(gene_input_1)]
      
      if (length(gene_match) == 1) {
        # Fetch data from the correct assay
        expression_data <- FetchData(
          recluster_data$seurat_obj,
          vars = gene_match,
          assay = input$assay_select # Use the selected assay
        )[[1]]
        
        # Apply log transform for better visualization
        plot_df$gene1_expr <- log1p(expression_data)
      } else {
        showNotification(paste("Gene '", gene_input_1, "' not found in the", assay_to_use, "assay."), type = "warning")
      }
    }
    
    if (isTruthy(gene_input_2) && color_mode == "Two-Gene Overlay") {
      # Determine the correct assay to use for visualization
      assay_to_use <- DefaultAssay(recluster_data$seurat_obj)
      all_genes <- rownames(recluster_data$seurat_obj[[assay_to_use]])
      
      # Perform a case-insensitive search
      gene_match <- all_genes[tolower(all_genes) == tolower(gene_input_2)]
      
      if (length(gene_match) == 1) {
        # Fetch data from the correct assay
        plot_df$gene2_expr <- FetchData(
          recluster_data$seurat_obj,
          vars = gene_match,
          assay = input$assay_select
        )[[1]]
      } else {
        showNotification(paste("Gene '", gene_input_2, "' not found in the", assay_to_use, "assay."), type = "warning")
      }
    }
    
    # --- Overlay Color Logic ---
    # Create the overlay_color column if in that mode
    if (color_mode == "Two-Gene Overlay") {
      
      scale_expr <- function(x) {
        # log1p(x) is equivalent to log(x + 1), a standard transformation
        # for scRNA-seq data that handles zeros correctly.
        log_transformed <- log1p(x)
        
        # Rescale the log-transformed data to the 0-1 range for coloring
        return(scales::rescale(log_transformed, to = c(0, 1)))
      }
      
      plot_df$gene1_scaled <- scale_expr(plot_df$gene1_expr)
      
      if (isTruthy(gene_input_2) && any(plot_df$gene2_expr > 0)) {
        plot_df$gene2_scaled <- scale_expr(plot_df$gene2_expr)
        plot_df$overlay_color <- rgb(red = plot_df$gene2_scaled, green = plot_df$gene1_scaled, blue = plot_df$gene2_scaled)
      } else {
        plot_df$overlay_color <- rgb(red = 0, green = plot_df$gene1_scaled, blue = 0)
      }
    }
    
    # --- Selection Logic ---
    plot_df$selection_status <- "Unselected"
    selected_cells_now <- all_selected_cells()
    if (length(selected_cells_now) > 0) {
      hit <- intersect(selected_cells_now, rownames(plot_df))
      plot_df[hit, "selection_status"] <- "Selected"
    }
    plot_df$cell_id <- rownames(plot_df)
    return(plot_df)
  })
  
  # --- Render the interactive UMAP plot (Completely Rewritten) ---
  output$recluster_umap_plot <- renderPlotly({
    plot_df <- final_plot_df()
    req(plot_df)
    req(nrow(plot_df) > 0) # 
    # Base plot
    # --- This is the NEW, robust line ---
    p <- ggplot(
      plot_df, 
      aes(
        x = UMAP_1, 
        y = UMAP_2, 
        key = .data[["cell_id"]], 
        text = .data[["cell_id"]]
      )
    )
    
    # Determine color mapping based on mode
    color_by <- input$color_by_select
    
    if (color_by == "Two-Gene Overlay") {
      '
      # Always scale Gene 1 for the green channel
      plot_df$gene1_scaled <- scales::rescale(plot_df$gene1_expr, to = c(0, 1))
      
      # Check if a second gene is provided and has expression data
      if (isTruthy(gene_to_display_2()) && any(plot_df$gene2_expr > 0)) {
        # If yes, create the two-color overlay
        plot_df$gene2_scaled <- scales::rescale(plot_df$gene2_expr, to = c(0, 1))
        plot_df$overlay_color <- rgb(
          red = plot_df$gene2_scaled,
          green = plot_df$gene1_scaled,
          blue = plot_df$gene2_scaled
        )
      } else {
        # If no second gene, create a single-color (green) map for Gene 1
        plot_df$overlay_color <- rgb(
          red = 0,
          green = plot_df$gene1_scaled,
          blue = 0
        )
      }
      
      p <- p + geom_point(aes(color = .data[["overlay_color"]]), size = input$dot_size, alpha = input$dot_alpha, show.legend = FALSE) +
        scale_color_identity()
      '
      
      # This now ONLY returns the main UMAP plot
      return(
        plot_ly(
          data = plot_df, x = ~UMAP_1, y = ~UMAP_2,
          type = 'scattergl', mode = 'markers',
          key = ~cell_id, text = ~cell_id,
          marker = list(color = ~overlay_color, size = input$dot_size * 4, opacity = input$dot_alpha),
          source = "recluster_plot_source", # Keep source for lasso
          hoverinfo = 'text'
        ) %>% layout(
          dragmode = "lasso",
          showlegend = FALSE,
          xaxis = list(title = "UMAP_1"),
          yaxis = list(title = "UMAP_2", scaleanchor = "x", scaleratio = 1)
        )
      )
      
    } else if (color_by == "Single Gene Expression") {
      p <- p + geom_point(aes(fill = .data[["gene1_expr"]]), shape = 21, size = input$dot_size, alpha = input$dot_alpha,  stroke = input$stroke_width,
                          color = input$stroke_color) +
        scale_fill_viridis_c(name = gene_to_display_1())
    } else if (isTruthy(color_by) && color_by != "None") {
      req(color_by %in% names(plot_df))
      color_vals <- plot_df[[color_by]]
      if (is.numeric(color_vals) || is.integer(color_vals)) {
        p <- p + geom_point(
          aes(fill = .data[[color_by]], text = rownames(plot_df), key = rownames(plot_df)),
          shape = 21,
          size = input$dot_size,
          alpha = input$dot_alpha,
          stroke = input$stroke_width,
          color = input$stroke_color
        ) +
          scale_fill_viridis_c(name = color_by, guide = guide_colorbar())
      } else {
        p <- p + geom_point(
          aes(fill = .data[[color_by]], text = rownames(plot_df), key = rownames(plot_df)),
          shape = 21,
          size = input$dot_size,
          alpha = input$dot_alpha,
          stroke = input$stroke_width,
          color = input$stroke_color
        ) +
          scale_fill_discrete(name = color_by)
      }
    } else {
      p <- p + geom_point(
        aes(text = rownames(plot_df), key = rownames(plot_df)),
        shape = 21,
        fill = "grey50", # Default fill color if "None"
        size = input$dot_size,
        alpha = input$dot_alpha,
        stroke = input$stroke_width,
        color = input$stroke_color
      )
    }
    
    
    
    # Add a second layer for the red selection outline (this is unchanged)
    p <- p + geom_point(
      data = subset(plot_df, selection_status == "Selected"),
      aes(x = UMAP_1, y = UMAP_2, key = .data[["cell_id"]], text = .data[["cell_id"]]), # <-- ADD THIS
      color = "#C71585",
      shape = 1,
      size = input$dot_size + 0.2, 
      stroke = 1
    )
    
    
    # Apply splitting (faceting) if selected
    split_by <- input$split_by_select
    if (isTruthy(split_by) && split_by != "None") {
      req(split_by %in% names(plot_df))
      p <- p + facet_wrap(vars(.data[[split_by]]))
    }
    
    # Apply a clean theme
    p <- p + theme_bw() + coord_equal()
    
    # Convert the final ggplot object to a plotly object
    ggplotly(p, source = "recluster_plot_source") %>%
      event_register("plotly_selected") %>%
      layout(
        dragmode = "lasso",
        yaxis = list(scaleanchor = "x", scaleratio = 1)
      )
  })
  
  # --- ADD THIS ENTIRE NEW BLOCK ---
  output$recluster_legend_plot <- renderPlotly({
    # Only render this plot if the two-gene overlay is selected
    req(input$color_by_select == "Two-Gene Overlay")
    gene1 <- gene_to_display_1()
    gene2 <- gene_to_display_2()
    req(gene1, gene2)
    
    # 1. Create the color matrix (this part is fast)
    legend_size <- 50
    legend_matrix <- array(dim = c(legend_size, legend_size, 3))
    g1_scaled <- scales::rescale(1:legend_size, to = c(0, 1))
    g2_scaled <- scales::rescale(1:legend_size, to = c(0, 1))
    
    for (i in 1:legend_size) {
      for (j in 1:legend_size) {
        rgb_val <- col2rgb(rgb(red = g2_scaled[j], green = g1_scaled[i], blue = g2_scaled[j]))
        legend_matrix[i, j, ] <- rgb_val / 255
      }
    }
    
    # 2. Create an empty ggplot and add the color matrix as a single raster image
    #    This is much faster than drawing thousands of tiles.
    p_legend_gg <- ggplot() +
      annotation_raster(legend_matrix, xmin = 0, xmax = 1, ymin = 0, ymax = 1) +
      labs(x = gene2, y = gene1) +
      theme_classic() +
      coord_fixed()
    
    # 3. Convert the simplified ggplot object to plotly
    ggplotly(p_legend_gg, tooltip = "none") %>%
      config(displayModeBar = FALSE) # Hide the plotly toolbar
  })
  
  # --- Display the count of selected cells ---
  output$selected_cell_count_output <- renderText({
    paste("Cells selected from barcode imports:", length(recluster_data$selected_cells), "cells")
  })
  
  # --- ADD THIS ENTIRE BLOCK ---
  # This reactive prepares the data specifically for the scatter plot
  # --- This reactive prepares the data specifically for the scatter plot ---
  scatter_plot_df <- reactive({
    # Require the main seurat object and the two gene inputs
    req(recluster_data$seurat_obj, input$scatter_gene_x, input$scatter_gene_y)
    
    seurat_obj <- recluster_data$seurat_obj
    gene_x <- input$scatter_gene_x
    gene_y <- input$scatter_gene_y
    color_by_col <- input$scatter_color_by
    
    # 1. Start with a clean list of variables to fetch
    vars_to_fetch <- c(gene_x, gene_y)
    
    # 2. Add the color-by variable to the list ONLY if it's a valid metadata column
    if (isTruthy(color_by_col) && color_by_col != "None" && color_by_col %in% colnames(seurat_obj@meta.data)) {
      vars_to_fetch <- c(vars_to_fetch, color_by_col)
    }
    
    # 3. Fetch all required data in a single, safe call.
    #    The unique() function is the key fix that prevents duplicate columns.
    assay_use <- .scalar_chr(input$scatter_assay_select, default = as.character(DefaultAssay(seurat_obj) %||% ""))
    plot_df <- FetchData(seurat_obj, vars = unique(vars_to_fetch), assay = assay_use)
    
    # Handle log scaling
    if ("Log Scale X-axis" %in% input$scatter_log_scale) {
      plot_df[[gene_x]] <- log1p(plot_df[[gene_x]])
    }
    if ("Log Scale Y-axis" %in% input$scatter_log_scale) {
      plot_df[[gene_y]] <- log1p(plot_df[[gene_y]])
    }

    return(plot_df)
  })
  
  output$recluster_scatter_plot <- renderPlotly({
    plot_df <- scatter_plot_df()
    req(plot_df)
    
    # Define the genes for the axes from the inputs
    gene_x <- input$scatter_gene_x
    gene_y <- input$scatter_gene_y
    
    # Build the ggplot object
    p <- ggplot(plot_df, aes_string(x = paste0("`", gene_x, "`"), 
                                    y = paste0("`", gene_y, "`"),
                                    key = "rownames(plot_df)", 
                                    text = RECLUSTER_UI_TEXT$t_text_rownames_plot_df))
    
    color_by <- input$scatter_color_by
    if (isTruthy(color_by) && color_by != "None") {
      req(color_by %in% names(plot_df))
      # Use fixed values for size and alpha instead of input$
      p <- p + geom_point(aes_string(color = color_by), size = 1.5, alpha = 0.8)
    } else {
      # Use fixed values here as well
      p <- p + geom_point(size = 1.5, alpha = 0.8)
    }
    
    p <- p + theme_bw()
    
    # Convert to a plotly object with lasso select enabled
    ggplotly(p, source = "scatter_plot_source") %>% layout(dragmode = "lasso")
  })
  
  
  
  .apply_imported_barcodes <- function(barcodes, source_label = "file") {
    req(recluster_data$seurat_obj)
    barcodes <- unique(trimws(as.character(barcodes %||% character(0))))
    barcodes <- barcodes[nzchar(barcodes)]
    if (!length(barcodes)) {
      showNotification(sprintf("No barcode values found in %s.", source_label), type = "warning")
      return(invisible(FALSE))
    }
    all_cells <- colnames(recluster_data$seurat_obj)
    matched <- .match_barcodes_to_cells(barcodes, all_cells)
    recluster_data$selected_cells <- unique(c(recluster_data$selected_cells, matched))
    recluster_data$imported_barcode_sources <- unique(c(recluster_data$imported_barcode_sources, source_label))
    showNotification(
      sprintf("Imported %d barcodes from %s. Matched %d cell(s).", length(barcodes), source_label, length(matched)),
      type = "message"
    )
    invisible(TRUE)
  }

  observeEvent(input$import_barcodes_file, {
    file <- input$import_barcodes_file
    req(file)
    tryCatch({
      barcodes <- .read_barcodes_from_path(file$datapath)
      .apply_imported_barcodes(barcodes, source_label = file$name %||% "uploaded file")
    }, error = function(e) {
      showNotification(paste("Error importing barcodes:", e$message), type = "error")
    })
  })

  observeEvent(input$import_sidebar_barcodes_btn, {
    req(recluster_data$seurat_obj)
    paths <- unique(as.character(input$recluster_sidebar_barcode_paths %||% character(0)))
    if (!length(paths)) {
      showNotification("Please choose at least one sidebar barcode file.", type = "warning")
      return(invisible(NULL))
    }
    total_imported <- 0L
    for (p in paths) {
      barcodes <- tryCatch(.read_barcodes_from_path(p), error = function(e) character(0))
      if (!length(barcodes)) next
      total_imported <- total_imported + length(barcodes)
      .apply_imported_barcodes(barcodes, source_label = basename(p))
    }
    if (!total_imported) {
      showNotification("No readable barcode values found in the selected sidebar files.", type = "warning")
    }
    invisible(NULL)
  })
  
  ##### --- Observer for the final "Re-cluster" button ---
  observeEvent(input$run_recluster_btn, {
    # This button no longer runs the pipeline directly.
    # It now opens a modal dialog to ask for a name.
    
    selected_cells_now <- all_selected_cells()
    req(length(selected_cells_now) > 0)
    
    showModal(modalDialog(
      title = RECLUSTER_UI_TEXT$t_text_name_new_subset,
      textInput("new_subset_name", RECLUSTER_UI_TEXT$t_label_enter_name_new_subset, 
                placeholder = RECLUSTER_UI_TEXT$t_text_e_g_cd4_t_cells),
      footer = tagList(
        modalButton("Cancel"),
        actionButton("confirm_recluster_btn", RECLUSTER_UI_TEXT$t_btn_create_analyze_subset, class = "btn-success")
      )
    ))
  })
  
  output$final_cell_count_output <- renderText({
    
    # Combine manual groups + imported barcodes + cluster filter
    selected_cells_now <- all_selected_cells()
    
    # Display the total count
    paste("Total unique cells to re-cluster:", length(selected_cells_now))
  })
  
  observeEvent(input$confirm_recluster_btn, {
    overlay_show(RECLUSTER_UI_TEXT$t_text_creating_subset_object_for_analysis)
    on.exit(overlay_hide(), add = TRUE)
    
    seurat_obj <- recluster_data$seurat_obj
    selected_cells <- all_selected_cells()
    new_name <- input$new_subset_name
    
    req(seurat_obj, length(selected_cells) > 0, isTruthy(new_name))
    
    removeModal()
    
    # Create a new Seurat object containing only the selected cells
    parent_name <- .scalar_chr(shared_data$active_object_name, default = "")
    subset_obj <- subset(seurat_obj, cells = selected_cells)
    subset_obj <- .reset_subset_analysis_state(subset_obj, source_object_name = parent_name)
    
    # --- Pass this subset object BACK to the Analysis page ---
    
    # Add the new object to our main list
    parent_entry <- if (nzchar(parent_name)) shared_data$all_seurat_objects[[parent_name]] else NULL
    subset_stage <- "recluster_subset"
    shared_data$all_seurat_objects[[new_name]] <- list(
      obj = subset_obj,
      prefs = list(),
      plots = list(
        elbow = NULL,
        clusters = NULL,
        conditions = NULL,
        heatmap = NULL,
        heatmap_plot_path = NULL,
        heatmap_gene_table = NULL
      ),
      analysis_cache = list(),
      meta = list(
        stage = subset_stage,
        parents = if (nzchar(parent_name)) parent_name else character(0),
        created = Sys.time()
      )
    )
    
    # Set this new object as the active one
    shared_data$active_object_name <- new_name
    
    showNotification(paste("New subset '", new_name, "' created. Returning to Analysis page."), type = "message")
    
    # Navigate the user back to the Analysis page to work on this new object
    updateNavbarPage(session, "main_navbar", selected = "analysis_tab")
  })
}
