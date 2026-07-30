# R/page_data_browser_new_ui.R

# DATA BROWSER COLOR PALETTE KNOB
# Options: "Default Seurat", or any key from all_palettes (e.g. "My Lab Palette 1", "Brewer: Set2", etc.)
DATA_BROWSER_DEFAULT_PALETTE <- "Default Seurat"

RECLUSTER_NEW_UI_TEXT <- list(
  t_title = "Data Browser",
  t_subtitle = "Unified selection and metadata curation workspace (beta).",
  t_tab_selection_workspace = "Selection Workspace",
  t_tab_metadata_curation = "Metadata Curation + Import",
  t_tab_metadata_overlap = "Metadata Overlap / Rule Browser",
  t_label_select_active_dataset = "Select Active Dataset:",
  t_title_population_selection = "Population Selection",
  t_title_metadata_filters = "Metadata Filters",
  t_btn_metadata_customize_colors = "Customize colors",
  t_title_metadata_customize_colors = "Customize colors",
  t_label_metadata_population_colors = "Population colors",
  t_btn_metadata_apply_colors = "Apply colors",
  t_text_metadata_help = "Expand metadata folds and choose classes/ranges to select cells. Metadata selection clears transient manual selections.",
  t_title_saved_groups = "Saved Groups",
  t_title_expression_selection = "Expression-Based Selection",
  t_text_expression_selection_help = "Define marker groups to highlight matching cells. UMAP coloring is controlled separately.",
  t_text_expression_selection_slot_note = "Expression-based selection always uses the assay data slot. The Slot control only changes feature display plots.",
  t_label_expr_limit_population = "Limit to current population",
  t_btn_expr_add_group = "Add Expression Group",
  t_label_expr_select_all_genes = "Select all genes",
  t_label_expr_group_name = "Group name",
  t_btn_expr_rename_group = "Rename group",
  t_btn_expr_save_group_name = "Save name",
  t_label_expr_require_all = "Require all checked genes",
  t_label_expr_invert_group = "Select cells outside this group",
  t_label_expr_add_gene = "Add gene",
  t_text_expr_no_groups = "No expression groups created yet.",
  t_text_expr_no_genes = "No genes added to this group.",
  t_text_expr_select_gene_range = "Select a gene row to edit its range.",
  t_text_expr_range_unavailable = "Range unavailable for selected gene.",
  t_text_expr_range_all = "range all",
  t_text_expr_group_summary_empty = "0 genes, 0 cells",
  t_title_advanced_manual = "Advanced Manual Selection",
  t_text_advanced_manual = "Use lasso + save group, or import barcodes. Saved groups remain independent toggles.",
  t_title_recluster = "Create Recluster Subset",
  t_btn_save_selection_group = "Save Current Population as Group",
  t_btn_recluster = "Re-cluster Selected Cells",
  t_btn_create_subset = "Create and Analyze Subset",
  t_btn_delete = "Delete",
  t_label_new_group_name = "New Group Name",
  t_label_import_cell_barcodes = "Import Cell Barcodes (.txt/.csv/.tsv):",
  t_label_positive_selection_gene = "Positive Selection Gene:",
  t_label_positive_threshold = "Expression >",
  t_label_negative_selection_gene = "Negative Selection Gene:",
  t_label_negative_threshold = "Expression <",
  t_label_sidebar_barcodes = "Barcode file(s) from Data Files:",
  t_btn_import_sidebar = "Import Selected Sidebar Barcode File(s)",
  t_title_metadata_ops = "Metadata Column Operations",
  t_title_metadata_preview = "Metadata Preview",
  t_title_import_preview = "Import File Preview",
  t_title_import_match = "Import Match & Resolution",
  t_label_source_column = "Source column",
  t_label_new_column = "New metadata column",
  t_btn_duplicate_column = "Duplicate source to new column",
  t_btn_create_column = "Create empty column",
  t_label_group_by_column = "Group by column",
  t_label_group_value = "Group value",
  t_label_target_column = "Target column",
  t_label_new_label = "New label",
  t_btn_apply_group_label = "Apply to selected group",
  t_label_selected_row_label = "Label for selected rows",
  t_btn_apply_row_label = "Apply to selected rows",
  t_label_import_file = "Metadata file (.csv/.tsv/.txt)",
  t_label_import_barcode_col = "Barcode column",
  t_label_import_sample_col = "Sample column (optional)",
  t_label_import_meta_cols = "Metadata columns to import",
  t_label_import_umap_x = "UMAP X column (optional)",
  t_label_import_umap_y = "UMAP Y column (optional)",
  t_label_import_cluster = "Cluster column (optional)",
  t_btn_run_match = "Run barcode matching",
  t_btn_apply_import = "Apply matched metadata",
  t_text_import_resolution = "Edit 'chosen_cell' and set decision to accept/resolved for ambiguous rows.",
  t_text_no_groups = "No groups created yet.",
  t_text_name_subset = "Name New Subset",
  t_label_name_subset = "Enter a name for this new subset:",
  t_label_name_subset_placeholder = "e.g., CD4_T_Cells",
  t_label_suffix_for_metadata = "Suffix for non-protected metadata columns",
  t_label_unknown_keep_unsuffixed = "Unknown metadata columns to keep unsuffixed",
  t_text_suffix_help = "Protected sample-carried metadata keeps original names. Non-protected metadata will be suffixed.",
  t_text_name_conflict = "Object name already exists. Choose a different name.",
  t_text_suffix_conflict = "Metadata rename collision after suffixing. Change the suffix and retry.",
  t_text_creating_subset = "Creating subset object for analysis...",
  t_title_umap = "UMAP Plot",
  t_title_scatter = "Gene Scatter Plot",
  t_title_interactive_umap = "Interactive UMAP",
  t_text_umap_note = "Selected cells use larger violet fill. In expression selection, the active gene uses a bright orange outline.",
  t_title_controls = "Visualization Controls",
  t_label_color_umap = "Color UMAP by:",
  t_label_umap_reduction = "Embedding reduction:",
  t_label_umap_axis_x = "Embedding X axis:",
  t_label_umap_axis_y = "Embedding Y axis:",
  t_label_assay = "Assay:",
  t_label_slot = "Slot:",
  t_label_gene_shared = "Gene:",
  t_label_gene_expr_range = "Expression Range:",
  t_label_umap_display_control = "Left panel / UMAP control:",
  t_label_split_umap = "Split UMAP by:",
  t_label_gene_1 = "Gene 1 (Green Channel):",
  t_label_gene_2 = "Gene 2 (Blue Channel):",
  t_label_gene_3 = "Gene 3 (Red Channel):",
  t_btn_update_plot = "Update Plot",
  t_label_dot_size = "Dot Size:",
  t_label_dot_alpha = "Dot Transparency (Alpha):",
  t_label_dot_outline_width = "Highlight Stroke Transparency:",
  t_label_dot_outline_color = "Dot Outline Color:",
  t_label_scatter_gene_x = "Gene for X-axis:",
  t_label_scatter_gene_y = "Gene for Y-axis:",
  t_label_scatter_axis_scale = "Axis Scale:",
  t_label_scatter_color = "Color by:",
  t_title_violin = "Selected Gene Expression by Active Metadata",
  t_tab_violin_plot = "Violin Plot",
  t_tab_stacked_plot = "Stacked Bar Plot",
  t_tab_pseudobulk_table = "Pseudobulk Table",
  t_text_violin_note = "All cells shown; selected cells are overlaid.",
  t_label_violin_gene = "Gene:",
  t_text_violin_no_gene = "No gene selected. Showing cell composition by active metadata levels.",
  t_text_mode = "Control Mode:",
  t_label_display_by = "Display by:",
  t_mode_auto = "Auto",
  t_mode_category = "Category",
  t_mode_range = "Range",
  t_bucket_cluster = "Cluster-like Metadata",
  t_bucket_categorical = "Categorical Metadata",
  t_bucket_continuous = "Continuous / Consecutive Numeric Metadata",
  t_text_no_metadata = "No metadata columns available for filtering.",
  t_text_selected_total = "Total unique cells selected:",
  t_text_selected_barcodes = "Cells selected from manual barcode imports:",
  t_text_selection_source = "Active metadata filter column:",
  t_text_selection_none = "(none)",
  t_text_group_enabled = "Include",
  t_text_group_disabled = "Exclude",
  t_label_pb_compare_mode = "Comparison mode:",
  t_label_pb_level_a = "Level A:",
  t_label_pb_level_b = "Level B:",
  t_btn_pb_run = "Run pseudobulk table",
  t_btn_pb_open_analysis = "Open Analysis pseudobulk",
  t_title_rule_controls = "Rule Definitions",
  t_label_rule_a_column = "Rule A metadata column",
  t_label_rule_b_column = "Rule B metadata column",
  t_label_rule_grouping_column = "Grouping column for stacked barplot",
  t_label_rule_manual_mode = "Manual/lasso combine mode",
  t_rule_union = "union",
  t_rule_intersection = "intersection",
  t_label_rule_selected_group = "Selected overlap group",
  t_rule_group_a_only = "A_only",
  t_rule_group_b_only = "B_only",
  t_rule_group_ab = "A_B",
  t_rule_group_neither = "Neither",
  t_rule_group_missing = "Missing",
  t_rule_group_all = "All overlap groups",
  t_label_rule_umap_mode = "UMAP display mode",
  t_rule_umap_highlight = "Highlight selected group (gray background)",
  t_rule_umap_full = "Color by full overlap group",
  t_label_rule_color_preset = "Overlap color preset",
  t_rule_color_preset_default = "Default",
  t_rule_color_preset_colorblind = "Colorblind-safe",
  t_rule_color_preset_vivid = "Vivid",
  t_title_rule_umap = "Rule Overlap UMAP",
  t_title_rule_scatter = "Rule Scatter Plot",
  t_title_rule_stacked = "Overlap Group Composition (%)"
)

library(plotly)
library(dplyr)
library(ggplot2)
library(DT)

`%||%` <- function(a, b) if (is.null(a)) b else a

recluster_new_with_busy_spinner <- function(output_ui, spinner = c("other", "umap", "clustertree")) {
  spinner <- match.arg(spinner)
  fn <- tryCatch(get0("analysis_with_busy_spinner", mode = "function", inherits = TRUE), error = function(e) NULL)
  if (is.function(fn)) {
    return(fn(output_ui, spinner = spinner))
  }
  withSpinner(output_ui)
}

recluster_new_rule_browser_panel <- function(ui_text, mount_mode = c("separate_tab", "selection_workspace")) {
  mount_mode <- match.arg(mount_mode)
  # Keep a stable wrapper so this block can be mounted in either separate tab
  # or the future selection workspace location without changing child IDs.
  fluidRow(
    class = "recluster-new-main-row",
    `data-rule-browser-mount` = mount_mode,
    column(
      width = 3,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        h4(ui_text$t_title_rule_controls),
        selectInput("recluster_new_rule_a_col", ui_text$t_label_rule_a_column, choices = character(0)),
        uiOutput("recluster_new_rule_a_value_ui"),
        tags$hr(),
        selectInput("recluster_new_rule_b_col", ui_text$t_label_rule_b_column, choices = character(0)),
        uiOutput("recluster_new_rule_b_value_ui"),
        tags$hr(),
        selectInput("recluster_new_rule_group_col", ui_text$t_label_rule_grouping_column, choices = character(0)),
        selectInput(
          "recluster_new_rule_manual_mode",
          ui_text$t_label_rule_manual_mode,
          choices = stats::setNames(
            c("union", "intersection"),
            c(ui_text$t_rule_union, ui_text$t_rule_intersection)
          ),
          selected = "union"
        ),
        selectInput(
          "recluster_new_rule_selected_group",
          ui_text$t_label_rule_selected_group,
          choices = stats::setNames(
            c("A_only", "B_only", "A_B", "Neither", "Missing", "All"),
            c(
              ui_text$t_rule_group_a_only,
              ui_text$t_rule_group_b_only,
              ui_text$t_rule_group_ab,
              ui_text$t_rule_group_neither,
              ui_text$t_rule_group_missing,
              ui_text$t_rule_group_all
            )
          ),
          selected = "All"
        ),
        selectInput(
          "recluster_new_rule_umap_mode",
          ui_text$t_label_rule_umap_mode,
          choices = stats::setNames(
            c("highlight", "full"),
            c(ui_text$t_rule_umap_highlight, ui_text$t_rule_umap_full)
          ),
          selected = "highlight"
        ),
        selectInput(
          "recluster_new_rule_color_preset",
          ui_text$t_label_rule_color_preset,
          choices = stats::setNames(
            c("default", "colorblind", "vivid"),
            c(
              ui_text$t_rule_color_preset_default,
              ui_text$t_rule_color_preset_colorblind,
              ui_text$t_rule_color_preset_vivid
            )
          ),
          selected = "default"
        ),
        fluidRow(
          column(6, colourpicker::colourInput("recluster_new_rule_color_a_only", ui_text$t_rule_group_a_only, value = "#D55E00", showColour = "background", palette = "square", allowTransparent = FALSE)),
          column(6, colourpicker::colourInput("recluster_new_rule_color_b_only", ui_text$t_rule_group_b_only, value = "#0072B2", showColour = "background", palette = "square", allowTransparent = FALSE))
        ),
        fluidRow(
          column(6, colourpicker::colourInput("recluster_new_rule_color_ab", ui_text$t_rule_group_ab, value = "#009E73", showColour = "background", palette = "square", allowTransparent = FALSE)),
          column(6, colourpicker::colourInput("recluster_new_rule_color_neither", ui_text$t_rule_group_neither, value = "#9CA3AF", showColour = "background", palette = "square", allowTransparent = FALSE))
        ),
        fluidRow(
          column(12, colourpicker::colourInput("recluster_new_rule_color_missing", ui_text$t_rule_group_missing, value = "#6B7280", showColour = "background", palette = "square", allowTransparent = FALSE))
        )
      )
    ),
    column(
      width = 9,
      class = "plot_area_card_style",
      div(
        class = "wl-side",
        div(class = "recluster-new-controls-wrap", uiOutput("recluster_new_rule_viz_controls_ui")),
        div(
          class = "recluster-new-tabs-wrap",
          tabsetPanel(
            id = "recluster_new_rule_plot_tabs",
            selected = "rule_umap",
            tabPanel(ui_text$t_title_rule_umap, value = "rule_umap", div(style = "display:none;")),
            tabPanel(ui_text$t_title_rule_scatter, value = "rule_scatter", div(style = "display:none;"))
          )
        ),
        uiOutput("recluster_new_rule_plot_body_ui")
      ),
      div(
        class = "wl-side recluster-new-lower-plot-card",
        h5(ui_text$t_title_rule_stacked),
        recluster_new_with_busy_spinner(plotlyOutput("recluster_new_rule_stacked_plot", height = "360px"), spinner = "other")
      )
    )
  )
}

RECLUSTER_NEW_RULE_BROWSER_MOUNT_MODE <- "separate_tab"

recluster_new_ui <- fluidPage(
  class = "plotting-page qc-lock-left-float",
  
    div(
      class = "recluster-new-page",
      tags$style(HTML("
        .recluster-new-page .shiny-bound-output.recalculating,
        .recluster-new-page .html-widget-output.recalculating,
        .recluster-new-page .plotly.html-widget.recalculating {
          opacity: 1 !important;
        }
        .recluster-new-page .recluster-new-header-title .card-page-header {
          margin-top: 6px;
        }
        .recluster-new-fold > summary {
          display: flex;
          align-items: center;
          gap: 8px;
          font-weight: 700;
          color: #222222;
          cursor: pointer;
          list-style: none;
        }
        .recluster-new-fold > summary::-webkit-details-marker {
          display: none;
        }
        .recluster-new-fold > summary::before {
          content: '';
          width: 9px;
          height: 9px;
          border-right: 2px solid #222222;
          border-bottom: 2px solid #222222;
          transform: rotate(-45deg);
          transform-origin: 50% 50%;
          transition: transform 140ms ease;
          flex: 0 0 auto;
        }
        .recluster-new-fold[open] > summary::before {
          transform: rotate(45deg);
        }
        .plotting-left-panel .recluster-new-fold[open] > summary {
          margin-bottom: 10px;
        }
        .recluster-new-plot-card-top {
          display: grid;
          grid-template-columns: minmax(220px, 1fr) auto;
          align-items: start;
          gap: 16px;
          margin-bottom: 10px;
        }
        .recluster-new-plot-card-top .recluster-new-tabs-wrap {
          margin: 0;
          min-width: 0;
        }
        .recluster-new-plot-title h4 {
          margin-top: 0;
        }
        .recluster-new-viz-fold > summary {
          margin: 8px 0 12px;
          font-size: 16px;
        }
        .recluster-new-viz-fold[open] > summary {
          margin-bottom: 12px;
        }
        .recluster-new-viz-fold .recluster-new-controls-title {
          display: none;
        }
        .recluster-new-plot-body-reserve {
          display: block;
          min-height: var(--recluster-plot-h);
          height: var(--recluster-plot-h);
          position: relative;
          overflow: hidden;
        }
        .recluster-new-plot-body-reserve > .shiny-bound-output,
        .recluster-new-plot-body-reserve > .shiny-html-output {
          display: block;
          min-height: var(--recluster-plot-h);
          height: var(--recluster-plot-h);
          overflow: hidden;
        }
        .recluster-new-lower-tabs-wrap {
          position: relative;
          z-index: 0;
          clear: both;
        }
        .recluster-new-controls-tabs-item .control-label {
          display: block;
          margin-bottom: 6px;
          font-size: 13px;
          font-weight: 650;
        }
        .recluster-new-controls-tabs-item .recluster-new-tabs-wrap {
          margin: 0;
        }
        .recluster-new-controls-tabs-item .nav-tabs,
        .recluster-new-controls-tabs-item .nav-pills {
          width: 100%;
        }
        .plotting-page.float-left-panel .recluster-new-page .plotting-left-panel {
          height: calc(var(--app-viewport-h) - var(--app-shell-top-h, 0px) - var(--footer-h) - (2 * var(--plotting-float-gap-y))) !important;
          max-height: calc(var(--app-viewport-h) - var(--app-shell-top-h, 0px) - var(--footer-h) - (2 * var(--plotting-float-gap-y))) !important;
          overflow-y: auto !important;
          overflow-x: visible !important;
          padding-right: 6px;
          position: sticky !important;
          top: 0 !important;
          align-self: flex-start !important;
          z-index: 30;
        }
        .plotting-page.float-left-panel .recluster-new-page .plot_area_card_style {
          overflow: visible !important;
          z-index: 1;
        }
        .plotting-page.float-plot-area .recluster-new-page .plot_area_card_style {
          height: auto !important;
          max-height: none !important;
          overflow: visible !important;
          position: static !important;
          top: auto !important;
          align-self: stretch !important;
          z-index: 1;
        }
        .plotting-page.float-plot-area .recluster-new-page .plotting-left-panel {
          height: calc(var(--app-viewport-h) - var(--app-shell-top-h, 0px) - var(--footer-h) - (2 * var(--plotting-float-gap-y))) !important;
          max-height: calc(var(--app-viewport-h) - var(--app-shell-top-h, 0px) - var(--footer-h) - (2 * var(--plotting-float-gap-y))) !important;
          overflow-y: auto !important;
          overflow-x: visible !important;
          padding-right: 6px;
          position: sticky !important;
          top: 0 !important;
          align-self: flex-start !important;
          z-index: 30;
        }
        .recluster-new-display-toggle {
          display: flex;
          flex-direction: column;
          justify-content: flex-end;
          max-width: 360px;
          min-height: 62px;
        }
        .recluster-new-display-toggle .control-label {
          display: block;
          margin-bottom: 5px;
          font-size: 12px;
          font-weight: 650;
        }
        .recluster-new-display-toggle .form-group {
          margin-bottom: 0;
        }
        .recluster-new-display-toggle .shiny-options-group {
          position: relative;
          display: inline-flex;
          align-items: center;
          width: 100%;
          min-height: 34px;
          padding: 3px;
          border-radius: 999px;
          background: #eeeeee;
          border: 0;
          box-shadow: none;
          overflow: hidden;
        }
        .recluster-new-display-toggle .shiny-options-group::before {
          content: '';
          position: absolute;
          z-index: 0;
          top: 3px;
          bottom: 3px;
          left: 3px;
          width: calc(50% - 3px);
          border-radius: 999px;
          background: #ffffff;
          transition: transform 180ms ease, background-color 180ms ease;
        }
        .recluster-new-display-toggle .shiny-options-group:has(input[value='gene']:checked)::before {
          transform: translateX(100%);
          background: #34c759;
        }
        .recluster-new-display-toggle .radio,
        .recluster-new-display-toggle .radio-inline {
          position: relative;
          z-index: 1;
          flex: 1 1 0;
          margin: 0;
        }
        .recluster-new-display-toggle .radio label,
        .recluster-new-display-toggle .radio-inline {
          display: flex;
          align-items: center;
          justify-content: center;
          min-height: 28px;
          width: 100%;
          padding: 0 8px;
          border-radius: 999px;
          color: #555555;
          font-size: 11px;
          font-weight: 650;
          line-height: 1.1;
          white-space: nowrap;
          cursor: pointer;
          background: transparent;
          box-shadow: none;
          transition: color 180ms ease;
        }
        .recluster-new-display-toggle input[type='radio'] {
          position: absolute;
          opacity: 0;
          pointer-events: none;
        }
        .recluster-new-display-toggle .radio:has(input[value='gene']:checked) label,
        .recluster-new-display-toggle .radio-inline:has(input[value='gene']:checked) {
          color: #ffffff;
        }
        .recluster-new-display-toggle .radio:has(input[value='metadata']:checked) label,
        .recluster-new-display-toggle .radio-inline:has(input[value='metadata']:checked) {
          color: #333333;
        }
        .recluster-new-pb-controls {
          display: block;
          margin: 8px 0 10px;
        }
        .recluster-new-pb-visible .form-group {
          margin-bottom: 0;
        }
        .recluster-new-pb-visible .control-label {
          margin-bottom: 6px;
          font-size: 13px;
          font-weight: 650;
        }
        .recluster-new-pb-visible .shiny-options-group {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(104px, 1fr));
          column-gap: 12px;
          row-gap: 6px;
          align-items: center;
        }
        .recluster-new-pb-visible .checkbox {
          margin: 0;
          min-width: 0;
        }
        .recluster-new-pb-visible .checkbox label {
          display: flex;
          align-items: center;
          gap: 5px;
          min-width: 0;
          padding-left: 0;
          font-size: 12px;
          line-height: 1.2;
          white-space: nowrap;
        }
        .recluster-new-pb-visible .checkbox input[type='checkbox'] {
          position: static;
          margin: 0;
          width: 13px;
          height: 13px;
          flex: 0 0 auto;
        }
        .recluster-new-pb-empty-note {
          margin: 8px 0 10px;
          padding: 8px 10px;
          border-left: 3px solid #7c2d12;
          background: #fff7ed;
          color: #7c2d12;
          font-size: 12px;
          line-height: 1.35;
        }
        .recluster-new-range-legend {
          margin: 8px 0 4px;
        }
        .recluster-new-range-ramp {
          height: 18px;
          border-radius: 999px;
          background: linear-gradient(90deg, #440154 0%, #31688E 35%, #35B779 70%, #FDE725 100%);
          border: 1px solid rgba(0,0,0,0.12);
          box-shadow: inset 0 1px 1px rgba(255,255,255,0.45);
        }
        .recluster-new-range-labels {
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 8px;
          margin-top: 4px;
          font-size: 11px;
          line-height: 1.2;
          color: #4b5563;
          font-variant-numeric: tabular-nums;
        }
        .recluster-new-range-labels span {
          min-width: 0;
          max-width: 48%;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }
        .recluster-new-expression-card .checkbox {
          margin-top: 8px;
          margin-bottom: 8px;
        }
        .recluster-new-expression-card .checkbox label {
          display: inline-flex;
          align-items: center;
          gap: 8px;
          min-height: 20px;
          padding-left: 0;
          font-size: 13px;
          line-height: 1.25;
        }
        .recluster-new-expression-card .checkbox input[type='checkbox'] {
          position: static;
          margin: 0;
          width: 16px;
          height: 16px;
        }
        .recluster-new-expression-card,
        .recluster-new-expression-card .recluster-new-fold,
        .recluster-new-expression-card .recluster-new-fold[open] {
          overflow: visible;
        }
        .recluster-new-expression-card .selectize-dropdown,
        .recluster-new-expression-card .selectize-dropdown-content {
          z-index: 1030 !important;
        }
        body > .selectize-dropdown {
          z-index: 2050 !important;
        }
        .recluster-new-expression-toolbar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 8px;
          margin: 8px 0 10px;
        }
        .recluster-new-expression-toolbar .form-group {
          margin-bottom: 0;
        }
        .recluster-new-expr-group {
          border-radius: 8px;
          background: #f2f2f2;
          margin: 10px 0;
          overflow: visible;
        }
        /* Agent note: This marks the expression group supplying violet UMAP
           selection fill; keep its color aligned with the selected-cell trace. */
        .recluster-new-expr-group.is-violet-highlight-source,
        #recluster_new_advanced_manual_card.is-violet-highlight-source {
          box-shadow: 0 0 0 2px rgba(124, 58, 237, 0.72),
                      0 4px 14px rgba(124, 58, 237, 0.28) !important;
        }
        .recluster-new-level-color-swatch {
          cursor: pointer;
        }
        .recluster-new-expr-group summary {
          display: flex;
          align-items: center;
          justify-content: flex-start;
          gap: 8px;
          padding: 9px 10px;
          cursor: pointer;
          background: #f2f2f2;
          border-radius: 8px 8px 0 0;
          font-weight: 700;
          color: #333333;
        }
        .recluster-new-expr-group:not([open]) summary {
          border-radius: 8px;
        }
        .recluster-new-expr-group summary::-webkit-details-marker {
          display: none;
        }
        .recluster-new-expr-group summary::before {
          content: '';
          width: 8px;
          height: 8px;
          border-right: 2px solid #333333;
          border-bottom: 2px solid #333333;
          transform: rotate(-45deg);
          transform-origin: 50% 50%;
          transition: transform 140ms ease;
          flex: 0 0 auto;
        }
        .recluster-new-expr-group[open] summary::before {
          transform: rotate(45deg);
        }
        .recluster-new-expr-group-title {
          flex: 1 1 auto;
          min-width: 0;
          padding: 0;
          border: 0;
          background: transparent;
          text-align: left;
          font-size: 15px;
          line-height: 1.2;
          font-weight: 700;
          color: #333333;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          cursor: pointer;
        }
        .recluster-new-expr-group-summary {
          flex: 0 0 auto;
          font-size: 11px;
          font-weight: 600;
          color: #6b7280;
          white-space: nowrap;
        }
        .recluster-new-expr-group-body {
          position: relative;
          padding: 10px;
          border-radius: 0 0 8px 8px;
          background: #f2f2f2;
          overflow: visible;
        }
        .recluster-new-expr-group-body > .form-group {
          margin: 8px 0 12px;
        }
        .recluster-new-expr-select-all {
          margin: 2px 0 8px;
        }
        .recluster-new-expr-group-delete.btn {
          flex: 0 0 auto;
          width: 28px;
          height: 28px;
          min-width: 28px;
          padding: 0;
          border: 0;
          border-radius: 7px;
          background: #dc2626;
          color: #ffffff;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          line-height: 1;
          gap: 0;
        }
        .recluster-new-expr-group-actions {
          flex: 0 0 auto;
          display: inline-flex;
          align-items: center;
          gap: 6px;
        }
        .recluster-new-expr-group-rename.btn {
          flex: 0 0 auto;
          width: 28px;
          height: 28px;
          min-width: 28px;
          padding: 0;
          border: 0;
          border-radius: 7px;
          background: #e5e5e5;
          color: #333333;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          line-height: 1;
          gap: 0;
        }
        .recluster-new-expr-group-rename.btn:hover,
        .recluster-new-expr-group-rename.btn:focus {
          background: #cccccc;
          color: #111111;
        }
        #recluster_new_expr_group_name_edit::placeholder {
          color: #808080;
          opacity: 1;
        }
        .recluster-new-expr-group-delete.btn:hover,
        .recluster-new-expr-group-delete.btn:focus {
          background: #b91c1c;
          color: #ffffff;
        }
        .recluster-new-expr-group-delete .action-icon + .action-label {
          margin-left: 0;
        }
        .recluster-new-expr-group-delete .action-label:empty {
          display: none;
        }
        .recluster-new-expr-group-delete .action-icon {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          line-height: 1;
        }
        .recluster-new-expr-group-delete .fa,
        .recluster-new-expr-group-delete .fas {
          color: #ffffff;
          margin: 0;
          line-height: 1;
        }
        .recluster-new-group-row {
          display: flex;
          align-items: center;
          gap: 8px;
          min-height: 34px;
          margin: 4px 0;
        }
        .recluster-new-group-toggle {
          flex: 1 1 auto;
          min-width: 0;
        }
        .recluster-new-group-toggle .form-group {
          margin: 0;
        }
        .recluster-new-group-toggle .checkbox {
          margin: 0;
        }
        .recluster-new-group-toggle label {
          display: flex;
          align-items: center;
          gap: 6px;
          margin: 0;
          min-width: 0;
        }
        .recluster-new-group-toggle input[type='checkbox'] {
          margin-top: 0;
        }
        .recluster-new-group-meta {
          color: #6b7280;
          font-weight: 600;
        }
        .recluster-new-saved-group-delete.btn {
          flex: 0 0 auto;
          width: 28px;
          height: 28px;
          min-width: 28px;
          padding: 0;
          border: 0;
          border-radius: 7px;
          background: #dc2626;
          color: #ffffff;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          line-height: 1;
          gap: 0;
        }
        .recluster-new-saved-group-delete.btn:hover,
        .recluster-new-saved-group-delete.btn:focus {
          background: #b91c1c;
          color: #ffffff;
        }
        .recluster-new-saved-group-delete .action-icon + .action-label {
          margin-left: 0;
        }
        .recluster-new-saved-group-delete .action-label:empty {
          display: none;
        }
        .recluster-new-saved-group-delete .action-icon {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          line-height: 1;
        }
        .recluster-new-saved-group-delete .fa,
        .recluster-new-saved-group-delete .fas {
          color: #ffffff;
          margin: 0;
          line-height: 1;
        }
        .recluster-new-expr-gene-row .btn {
          padding: 3px 7px;
          line-height: 1.1;
        }
        .recluster-new-expr-gene-row {
          display: grid;
          grid-template-columns: 20px minmax(0, 1fr) auto;
          align-items: center;
          gap: 10px;
          padding: 9px 10px;
          margin: 10px 0;
          border-radius: 8px;
          background: #ffffff;
          cursor: pointer;
          box-shadow: 0 0 0 0 rgba(249, 115, 22, 0);
          transition: box-shadow 160ms ease, background-color 160ms ease;
        }
        .recluster-new-expr-gene-row.is-active {
          background: #ffffff;
          box-shadow: 0 0 0 2px rgba(249, 115, 22, 0.38), 0 8px 18px rgba(249, 115, 22, 0.16);
        }
        .recluster-new-expr-gene-actions {
          display: flex;
          align-items: center;
          gap: 4px;
        }
        .recluster-new-expr-gene-clear {
          color: #c2410c;
          border-color: rgba(249, 115, 22, 0.42);
          background: #ffffff;
        }
        .recluster-new-expr-gene-check .checkbox {
          margin: 0;
          width: 18px;
          height: 18px;
        }
        .recluster-new-expr-gene-check .checkbox label {
          display: block;
          width: 18px;
          height: 18px;
          min-height: 18px;
          padding-left: 0;
          overflow: hidden;
        }
        .recluster-new-expr-gene-check .checkbox input[type='checkbox'] {
          position: static;
          margin: 0;
          width: 18px;
          height: 18px;
        }
        .recluster-new-expr-gene-main {
          min-width: 0;
        }
        .recluster-new-expr-gene-title-row {
          display: flex;
          align-items: baseline;
          gap: 8px;
          min-width: 0;
        }
        .recluster-new-expr-gene-name {
          flex: 1 1 auto;
          min-width: 0;
          font-size: 13px;
          font-weight: 700;
          color: #333333;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }
        .recluster-new-expr-gene-count {
          flex: 0 0 auto;
          font-size: 10px;
          line-height: 1.2;
          font-weight: 650;
          color: #6b7280;
          white-space: nowrap;
        }
        .recluster-new-expr-gene-note {
          margin-top: 2px;
          font-size: 10px;
          line-height: 1.2;
          color: #777777;
          font-variant-numeric: tabular-nums;
        }
        .recluster-new-expr-add-gene .form-group,
        .recluster-new-expr-range .form-group {
          margin-bottom: 0;
        }
        .recluster-new-expr-add-gene,
        .recluster-new-expr-add-gene .selectize-control {
          overflow: visible !important;
          z-index: auto !important;
        }
        .recluster-new-expr-add-gene .selectize-dropdown {
          overflow: visible !important;
          z-index: 1030 !important;
        }
        .recluster-new-expr-add-gene .selectize-dropdown-content {
          max-height: 220px !important;
          overflow-y: auto !important;
          overflow-x: hidden !important;
          z-index: 1030 !important;
        }
        .recluster-new-expr-no-genes {
          margin: 14px 0 8px;
        }
        .recluster-new-expr-add-gene {
          margin-top: 12px;
        }
        .recluster-new-expr-range {
          margin-top: 10px;
          padding-top: 8px;
          border-top: 1px solid #eeeeee;
        }
        .recluster-new-expr-range-hint {
          margin-top: 4px;
          font-size: 10px;
          line-height: 1.2;
          color: #777777;
        }
        .recluster-new-pb-card table.dataTable thead tr:first-child th {
          background: #eeeeee;
          border-bottom: 1px solid #d0d0d0;
          color: #222222;
          font-weight: 700;
          text-align: center;
          cursor: pointer;
        }
        .recluster-new-pb-card table.dataTable thead tr:nth-child(2) th {
          background: #f7f7f7;
          color: #333333;
          font-weight: 600;
          text-align: right;
        }
        .recluster-new-pb-card table.dataTable thead th.pb-muted-col,
        .recluster-new-pb-card table.dataTable tbody td.pb-muted-col {
          color: #707070;
          font-size: 11px;
        }
        .recluster-new-pb-card table.dataTable thead tr:first-child th.pb-muted-head {
          color: #666666;
          font-size: 12px;
          background: #f2f2f2;
        }
        .recluster-new-pb-card table.dataTable thead th.pb-highlight-col,
        .recluster-new-pb-card table.dataTable tbody td.pb-highlight-col {
          background: #fff7ed;
          color: #7c2d12;
        }
        .recluster-new-pb-card table.dataTable thead th.pb-highlight-col,
        .recluster-new-pb-card table.dataTable tbody td.pb-highlight-col {
          font-size: 12px;
        }
        .recluster-new-pb-card table.dataTable tbody td .pb-na {
          color: #9a9a9a;
          font-size: 11px;
          font-style: italic;
        }
        .recluster-new-pb-card table.dataTable thead tr:first-child th.pb-highlight-head {
          background: #ffedd5;
          color: #7c2d12;
        }
        .recluster-new-pb-card table.dataTable tbody td {
          padding-top: 7px;
          padding-bottom: 7px;
          line-height: 1.35;
          vertical-align: middle;
        }
        .recluster-new-pb-card table.dataTable tbody td:first-child {
          font-weight: 600;
          text-align: left;
          color: #303030;
          background: #f7f7f7;
        }
        .recluster-new-pb-card .dataTables_scrollBody {
          border-bottom: 1px solid #d0d0d0;
        }
        
        /* Empty workspace state styling */
        @keyframes floatEmptyState {
          0% { transform: translateY(0px); }
          50% { transform: translateY(-10px); }
          100% { transform: translateY(0px); }
        }
        .recluster-new-empty-state-card {
          max-width: 600px;
          margin: 80px auto;
          padding: 40px;
          text-align: center;
          background: #ffffff;
          border-radius: 16px;
          box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
          border: 1px solid #eaeaea;
        }
        .recluster-new-empty-state-card .empty-state-icon {
          font-size: 64px;
          color: #94a3b8;
          margin-bottom: 24px;
          display: inline-block;
          animation: floatEmptyState 3s ease-in-out infinite;
        }
        .recluster-new-empty-state-card h3 {
          font-weight: 700;
          color: #1e293b;
          margin-bottom: 12px;
          font-family: 'Outfit', 'Inter', sans-serif;
        }
        .recluster-new-empty-state-card p {
          color: #64748b;
          font-size: 15px;
          line-height: 1.6;
          margin-bottom: 32px;
        }
        .recluster-new-empty-state-card .btn-empty-state-go {
          background: linear-gradient(135deg, #4f46e5 0%, #3b82f6 100%);
          color: #ffffff !important;
          border: 0;
          border-radius: 999px;
          padding: 12px 32px;
          font-weight: 600;
          font-size: 15px;
          box-shadow: 0 4px 14px rgba(59, 130, 246, 0.4);
          transition: transform 0.2s, box-shadow 0.2s;
          display: inline-flex;
          align-items: center;
          gap: 8px;
        }
        .recluster-new-empty-state-card .btn-empty-state-go:hover {
          transform: translateY(-2px);
          box-shadow: 0 6px 20px rgba(59, 130, 246, 0.6) !important;
          text-decoration: none !important;
        }
        .recluster-new-empty-state-card .btn-empty-state-go:active {
          transform: translateY(1px);
        }
      ")),
    fluidRow(
      class = "analysis-header-row",
      column(
        width = 8,
        div(
          class = "recluster-new-header-title",
          card_page_header(
            title = tagList(
              RECLUSTER_NEW_UI_TEXT$t_title,
              wl_beta_badge("New", with_icon = FALSE),
              wl_beta_badge("beta", with_icon = FALSE)
            ),
            subtitle = RECLUSTER_NEW_UI_TEXT$t_subtitle,
            icon_name = "flask"
          )
        )
      ),
      column(
        width = 4,
        div(
          class = "analysis-object-selector-wrap",
          div(
            class = "analysis-object-selector-card analysis-object-selector-card-top",
            wl_object_selector_ui(
              "recluster_new_dataset_select",
              RECLUSTER_NEW_UI_TEXT$t_label_select_active_dataset
            )
          )
        )
      )
    ),
    uiOutput("recluster_new_status_banner_ui"),
    div(
      id = "recluster_new_main_content_area",
      tabsetPanel(
        id = "recluster_new_workspace_tabs",
      tabPanel(
        RECLUSTER_NEW_UI_TEXT$t_tab_selection_workspace,
        fluidRow(
          class = "recluster-new-main-row",
          column(
            width = 3,
            class = "plotting-left-panel",
            div(
              class = "wl-side",
                tags$details(
                  class = "recluster-new-fold",
                  `data-basic-open-id` = "recluster_new_population_fold_open",
                  tags$summary(RECLUSTER_NEW_UI_TEXT$t_title_population_selection),
                tags$div(class = "recluster-new-secondary-title", RECLUSTER_NEW_UI_TEXT$t_title_metadata_filters),
                div(
                  class = "app-note-box recluster-new-meta-note control-note",
                  p(class = "recluster-new-secondary-text", RECLUSTER_NEW_UI_TEXT$t_text_metadata_help)
                ),
                uiOutput("recluster_new_metadata_selector_ui"),
                div(class = "app-secondary-status", textOutput("recluster_new_metadata_status_output"))
              )
            ),
            div(
              class = "wl-side recluster-new-expression-card",
              tags$details(
                class = "recluster-new-fold",
                tags$summary(RECLUSTER_NEW_UI_TEXT$t_title_expression_selection),
                div(
                  class = "app-note-box control-note",
                  p(class = "recluster-new-secondary-text", RECLUSTER_NEW_UI_TEXT$t_text_expression_selection_help),
                  p(class = "recluster-new-secondary-text", RECLUSTER_NEW_UI_TEXT$t_text_expression_selection_slot_note)
                ),
                checkboxInput("recluster_new_expr_limit_population", RECLUSTER_NEW_UI_TEXT$t_label_expr_limit_population, value = TRUE, width = "100%"),
                div(
                  class = "recluster-new-expression-toolbar",
                  actionButton("recluster_new_expr_add_group_btn", RECLUSTER_NEW_UI_TEXT$t_btn_expr_add_group, icon = icon("plus"), class = "btn btn-default btn-sm")
                ),
                uiOutput("recluster_new_expression_groups_ui")
              )
            ),
            div(
              id = "recluster_new_advanced_manual_card",
              class = "wl-side",
              tags$details(
                class = "recluster-new-fold",
                tags$summary(RECLUSTER_NEW_UI_TEXT$t_title_advanced_manual),
                p(RECLUSTER_NEW_UI_TEXT$t_text_advanced_manual),
                tags$hr(),
                fileInput("recluster_new_import_barcodes_file", RECLUSTER_NEW_UI_TEXT$t_label_import_cell_barcodes, accept = c(".txt", ".csv", ".tsv")),
                uiOutput("recluster_new_sidebar_barcode_source_ui"),
                actionButton("recluster_new_import_sidebar_barcodes_btn", RECLUSTER_NEW_UI_TEXT$t_btn_import_sidebar, class = "btn btn-default btn-sm"),
                div(style = "height: 6px;"),
                verbatimTextOutput("recluster_new_selected_cell_count_output")
              )
            ),
            div(
              class = "wl-side",
              tags$details(
                class = "recluster-new-fold",
                open = NA,
                tags$summary(RECLUSTER_NEW_UI_TEXT$t_title_recluster),
                verbatimTextOutput("recluster_new_final_cell_count_output"),
                tags$div(class = "recluster-new-secondary-title", RECLUSTER_NEW_UI_TEXT$t_label_new_group_name),
                textInput("recluster_new_group_name", label = NULL, placeholder = "e.g., T-cells"),
                actionButton("recluster_new_add_selection_btn", RECLUSTER_NEW_UI_TEXT$t_btn_save_selection_group, icon = icon("plus")),
                div(style = "height:10px;"),
                tags$div(class = "recluster-new-secondary-title", RECLUSTER_NEW_UI_TEXT$t_title_saved_groups),
                div(
                  class = "app-note-box control-note",
                  p(class = "recluster-new-secondary-text", "Saved group toggles are independent from metadata filters.")
                ),
                div(class = "app-secondary-status", uiOutput("recluster_new_cell_groups_ui")),
                div(style = "height:10px;"),
                actionButton("recluster_new_run_btn", RECLUSTER_NEW_UI_TEXT$t_btn_recluster, icon = icon("sync-alt"), class = "btn-success")
              )
            )
          ),
          column(
            width = 9,
            class = "plot_area_card_style",
            tags$script(HTML("
                (function () {
                  if (window.__reclusterNewTabMirrorBound) return;
                  window.__reclusterNewTabMirrorBound = true;
                  function pushTabValue(ev) {
                    if (!window.Shiny || !window.Shiny.setInputValue) return;
                    var node = ev.target && ev.target.closest && ev.target.closest('#recluster_new_tabs [data-value], #recluster_new_expr_tabs [data-value], #recluster_new_rule_plot_tabs [data-value]');
                    if (!node) return;
                    var root = node.closest('ul');
                    var val = node.getAttribute('data-value') || '';
                    if (!root || !root.id || !val) return;
                    var cur = window.Shiny.shinyapp && window.Shiny.shinyapp.$inputValues ? window.Shiny.shinyapp.$inputValues[root.id] : null;
                    if (cur === val) return;
                    Shiny.setInputValue(root.id, val, { priority: 'event' });
                    if (root.id === 'recluster_new_tabs') {
                      Shiny.setInputValue('recluster_new_tabs_click', val, { priority: 'event' });
                    } else if (root.id === 'recluster_new_expr_tabs') {
                      Shiny.setInputValue('recluster_new_expr_tabs_click', val, { priority: 'event' });
                    } else if (root.id === 'recluster_new_rule_plot_tabs') {
                      Shiny.setInputValue('recluster_new_rule_plot_tabs_click', val, { priority: 'event' });
                    }
                  }
                  document.addEventListener('click', pushTabValue, true);
                  document.addEventListener('shown.bs.tab', pushTabValue, true);
                  if (window.Shiny && window.Shiny.addCustomMessageHandler && !window.__reclusterNewSetTabBound) {
                    window.__reclusterNewSetTabBound = true;
                    window.Shiny.addCustomMessageHandler('recluster-new-set-tab', function (msg) {
                      if (!msg || !msg.id || !msg.value) return;
                      var root = document.getElementById(msg.id);
                      if (!root) return;
                      var selector = '[data-value=\"' + String(msg.value).replace(/\"/g, '\\\\\"') + '\"]';
                      var node = root.matches && root.matches(selector) ? root : root.querySelector(selector);
                      if (!node) return;
                      if (window.bootstrap && window.bootstrap.Tab) {
                        window.bootstrap.Tab.getOrCreateInstance(node).show();
                      } else if (window.jQuery && window.jQuery.fn && window.jQuery.fn.tab) {
                        window.jQuery(node).tab('show');
                      } else {
                        node.click();
                      }
                      if (window.Shiny && window.Shiny.setInputValue) {
                        window.Shiny.setInputValue(msg.id, msg.value, { priority: 'event' });
                        window.Shiny.setInputValue(msg.id + '_click', msg.value, { priority: 'event' });
                      }
                    });
                  }
                  if (window.Shiny && window.Shiny.addCustomMessageHandler && !window.__reclusterNewToggleClassBound) {
                    window.__reclusterNewToggleClassBound = true;
                    window.Shiny.addCustomMessageHandler('recluster-new-toggle-class', function (msg) {
                      if (!msg || !msg.id || !msg.className) return;
                      var node = document.getElementById(msg.id);
                      if (!node) return;
                      node.classList.toggle(msg.className, !!msg.enabled);
                    });
                  }
                  if (!window.__reclusterNewHoverLevel) {
                    window.__reclusterNewHoverLevel = (function () {
                      window.__reclusterNewHoverTimer = null;
                      window.__reclusterNewHoverLastKey = '';
                      return function (col, level) {
                        var key = String(col || '') + '\\u001f' + String(level || '');
                        if (!col || !level || key === window.__reclusterNewHoverLastKey) return;
                        if (window.__reclusterNewHoverTimer) window.clearTimeout(window.__reclusterNewHoverTimer);
                        window.__reclusterNewHoverTimer = window.setTimeout(function () {
                          window.__reclusterNewHoverLastKey = key;
                          window.__reclusterNewHoverTimer = null;
                          if (window.Shiny && window.Shiny.setInputValue) {
                            window.Shiny.setInputValue('recluster_new_meta_level_highlight', {
                              col: col,
                              level: level,
                              nonce: Date.now()
                            }, {priority: 'event'});
                          }
                        }, 1000);
                      };
                    })();
                  }
                  if (!window.__reclusterNewClearHoverLevel) {
                    window.__reclusterNewClearHoverLevel = function () {
                      if (window.__reclusterNewHoverTimer) {
                        window.clearTimeout(window.__reclusterNewHoverTimer);
                        window.__reclusterNewHoverTimer = null;
                      }
                      window.__reclusterNewHoverLastKey = '';
                      if (window.Shiny && window.Shiny.setInputValue) {
                        window.Shiny.setInputValue('recluster_new_meta_level_highlight_clear', {
                          nonce: Date.now()
                        }, {priority: 'event'});
                      }
                    };
                  }
                  if (!window.__reclusterNewExprSelectionBound) {
                    window.__reclusterNewExprSelectionBound = true;
                    window.__reclusterNewExprRangeDragging = false;
                    function shinySet(id, value) {
                      if (!id || !window.Shiny || !window.Shiny.setInputValue) return;
                      window.Shiny.setInputValue(id, value, {priority: 'event'});
                    }
                    function exprRangeInput() {
                      return document.getElementById('recluster_new_expr_active_range');
                    }
                    function parseExprRangeValue(el) {
                      if (!el || typeof el.value !== 'string') return null;
                      var parts = el.value.split(';').map(function (x) { return Number(x); });
                      if (parts.length < 2 || !isFinite(parts[0]) || !isFinite(parts[1])) return null;
                      return [parts[0], parts[1]];
                    }
                    function commitExprRange() {
                      var vals = parseExprRangeValue(exprRangeInput());
                      if (!vals) return;
                      shinySet('recluster_new_expr_active_range_commit', vals);
                    }
                    function isExprRangeEventTarget(target) {
                      return !!(target && target.closest && target.closest('#recluster_new_expr_active_range, .recluster-new-expr-range .irs, .recluster-new-expr-range .irs-bar, .recluster-new-expr-range .irs-handle, .recluster-new-expr-range .irs-slider'));
                    }
                    function startExprRangeDrag(ev) {
                      if (!isExprRangeEventTarget(ev.target)) return;
                      window.__reclusterNewExprRangeDragging = true;
                      shinySet('recluster_new_expr_slider_dragging', true);
                    }
                    function endExprRangeDrag() {
                      if (!window.__reclusterNewExprRangeDragging) return;
                      window.__reclusterNewExprRangeDragging = false;
                      shinySet('recluster_new_expr_slider_dragging', false);
                      commitExprRange();
                    }
                    document.addEventListener('pointerdown', function (ev) {
                      if (!ev.target || !ev.target.closest) return;
                      if (ev.target.closest('.recluster-new-expr-group-rename, .recluster-new-expr-group-delete')) {
                        ev.stopPropagation();
                      }
                    }, true);
                    document.addEventListener('mousedown', function (ev) {
                      if (!ev.target || !ev.target.closest) return;
                      if (ev.target.closest('.recluster-new-expr-group-rename, .recluster-new-expr-group-delete')) {
                        ev.stopPropagation();
                      }
                    }, true);
                    document.addEventListener('click', function (ev) {
                      var renameCancelBtn = ev.target && ev.target.closest && ev.target.closest('#recluster_new_expr_group_name_cancel');
                      if (renameCancelBtn) {
                        ev.preventDefault();
                        ev.stopPropagation();
                        shinySet('recluster_new_expr_group_name_cancel', { nonce: Date.now() });
                        return;
                      }
                      var renameSaveBtn = ev.target && ev.target.closest && ev.target.closest('#recluster_new_expr_group_name_save');
                      if (renameSaveBtn) {
                        ev.preventDefault();
                        ev.stopPropagation();
                        var renameNameInput = document.getElementById('recluster_new_expr_group_name_edit');
                        shinySet('recluster_new_expr_group_name_save', {
                          name: renameNameInput ? renameNameInput.value : '',
                          nonce: Date.now()
                        });
                        return;
                      }
                      var deleteBtn = ev.target && ev.target.closest && ev.target.closest('.recluster-new-expr-group-delete');
                      if (deleteBtn) {
                        ev.preventDefault();
                        ev.stopPropagation();
                        // Agent note: Summary-row propagation is intentionally
                        // blocked, so forward delete explicitly to Shiny.
                        shinySet(deleteBtn.id, Date.now());
                        return;
                      }
                      var renameBtn = ev.target && ev.target.closest && ev.target.closest('.recluster-new-expr-group-rename');
                      if (renameBtn) {
                        ev.preventDefault();
                        ev.stopPropagation();
                        shinySet('recluster_new_expr_group_rename', {
                          group_id: renameBtn.getAttribute('data-expr-rename-group-id') || '',
                          nonce: Date.now()
                        });
                        return;
                      }
                      var clearGeneBtn = ev.target && ev.target.closest && ev.target.closest('.recluster-new-expr-gene-clear[data-expr-active-id]');
                      if (clearGeneBtn) {
                        ev.preventDefault();
                        ev.stopPropagation();
                        shinySet(clearGeneBtn.getAttribute('data-expr-active-id'), Date.now());
                        return;
                      }
                      var row = ev.target && ev.target.closest && ev.target.closest('.recluster-new-expr-gene-row[data-expr-active-id]');
                      if (!row) return;
                      if (ev.target.closest('button, input, label, .checkbox, .selectize-control, .selectize-dropdown')) return;
                      shinySet(row.getAttribute('data-expr-active-id'), Date.now());
                    }, true);
                    document.addEventListener('toggle', function (ev) {
                      var details = ev.target;
                      if (!details || !details.matches) return;
                      if (details.matches('.recluster-new-fold[data-basic-open-id]')) {
                        shinySet(details.getAttribute('data-basic-open-id'), !!details.open);
                      }
                    }, true);
                    document.addEventListener('pointerdown', startExprRangeDrag, true);
                    document.addEventListener('mousedown', startExprRangeDrag, true);
                    document.addEventListener('touchstart', startExprRangeDrag, true);
                    document.addEventListener('pointerup', endExprRangeDrag, true);
                    document.addEventListener('pointercancel', endExprRangeDrag, true);
                    document.addEventListener('mouseup', endExprRangeDrag, true);
                    document.addEventListener('touchend', endExprRangeDrag, true);
                    window.addEventListener('blur', endExprRangeDrag, true);
                    document.addEventListener('change', function (ev) {
                      if (!ev.target || ev.target.id !== 'recluster_new_expr_active_range') return;
                      if (window.__reclusterNewExprRangeDragging) return;
                      commitExprRange();
                    }, true);
                  }
                  if (!window.__reclusterNewSmartFloatBound) {
                    window.__reclusterNewSmartFloatBound = true;
                    window.__reclusterNewSmartFloatRaf = 0;
                    window.__reclusterNewSmartFloat = function () {
                      var page = document.querySelector('.plotting-page .recluster-new-page');
                      if (!page) return;
                      var shell = page.closest('.plotting-page');
                      var activePane = page.querySelector('#recluster_new_workspace_tabs + .tab-content > .tab-pane.active') || page;
                      var row = activePane.querySelector('.recluster-new-main-row');
                      if (!shell || !row) return;
                      var left = row.querySelector(':scope > .plotting-left-panel');
                      var right = row.querySelector(':scope > .plot_area_card_style');
                      if (!left || !right) return;
                      shell.classList.remove('float-left-panel', 'float-plot-area');
                      var viewportLimit = Math.max(360, window.innerHeight - 120);
                      var leftH = Math.max(left.scrollHeight, left.getBoundingClientRect().height);
                      if (leftH > viewportLimit) {
                        shell.classList.add('float-left-panel');
                      }
                    };
                    window.__reclusterNewScheduleSmartFloat = function () {
                      if (window.__reclusterNewSmartFloatRaf) return;
                      window.__reclusterNewSmartFloatRaf = window.requestAnimationFrame(function () {
                        window.__reclusterNewSmartFloatRaf = 0;
                        window.__reclusterNewSmartFloat();
                        if (window.Plotly && window.Plotly.Plots && window.Plotly.Plots.resize) {
                          ['recluster_new_umap_plot', 'recluster_new_scatter_plot'].forEach(function (id) {
                            var el = document.getElementById(id);
                            if (el) {
                              var plot = el.querySelector('.js-plotly-plot') || el.querySelector('.plotly') || el;
                              try { window.Plotly.Plots.resize(plot); } catch (e) {}
                            }
                          });
                        }
                      });
                    };
                    window.addEventListener('resize', window.__reclusterNewScheduleSmartFloat, {passive: true});
                    document.addEventListener('toggle', window.__reclusterNewScheduleSmartFloat, true);
                    document.addEventListener('shown.bs.tab', window.__reclusterNewScheduleSmartFloat, true);
                    if (window.jQuery && window.jQuery(document).on) {
                      window.jQuery(document).on('shiny:value shiny:bound shiny:recalculated', window.__reclusterNewScheduleSmartFloat);
                    }
                    if (window.ResizeObserver) {
                      window.__reclusterNewSmartFloatRO = new window.ResizeObserver(window.__reclusterNewScheduleSmartFloat);
                      var root = document.querySelector('.recluster-new-page');
                      if (root) window.__reclusterNewSmartFloatRO.observe(root);
                    }
                    if (window.MutationObserver) {
                      var root2 = document.querySelector('.recluster-new-page');
                      if (root2) {
                        window.__reclusterNewSmartFloatMO = new window.MutationObserver(window.__reclusterNewScheduleSmartFloat);
                        window.__reclusterNewSmartFloatMO.observe(root2, {childList: true, subtree: true, attributes: true, attributeFilter: ['class', 'open', 'style']});
                      }
                    }
                    window.__reclusterNewScheduleSmartFloat();
                  }
                })();
              ")),
            div(
              class = "recluster-new-tabs-wrap",
              tabsetPanel(
                id = "recluster_new_tabs",
                selected = "umap",
                tabPanel(RECLUSTER_NEW_UI_TEXT$t_title_umap, value = "umap", div(style = "display:none;")),
                tabPanel(RECLUSTER_NEW_UI_TEXT$t_title_scatter, value = "scatter", div(style = "display:none;"))
              )
            ),
            div(
              class = "wl-side recluster-new-workflow-card",
              div(
                class = "recluster-new-plot-card-top",
                uiOutput("recluster_new_plot_card_header_ui"),
                actionButton("recluster_new_update_viz_btn", RECLUSTER_NEW_UI_TEXT$t_btn_update_plot, icon = icon("sync-alt"))
              ),
              tags$details(
                class = "recluster-new-fold recluster-new-viz-fold",
                open = NA,
                tags$summary(RECLUSTER_NEW_UI_TEXT$t_title_controls),
                div(class = "recluster-new-controls-wrap", uiOutput("recluster_new_viz_controls_ui"))
              ),
              div(class = "recluster-new-plot-body-reserve", uiOutput("recluster_new_plot_body_ui"))
            ),
            div(
              class = "recluster-new-tabs-wrap recluster-new-lower-tabs-wrap",
              tabsetPanel(
                id = "recluster_new_expr_tabs",
                selected = "stacked",
                tabPanel(RECLUSTER_NEW_UI_TEXT$t_tab_stacked_plot, value = "stacked", div(style = "display:none;")),
                tabPanel(RECLUSTER_NEW_UI_TEXT$t_tab_violin_plot, value = "violin", div(style = "display:none;")),
                tabPanel(RECLUSTER_NEW_UI_TEXT$t_tab_pseudobulk_table, value = "pseudobulk", div(style = "display:none;"))
              )
            ),
            div(
              class = "wl-side recluster-new-lower-plot-card",
              uiOutput("recluster_new_violin_panel_ui")
            )
          )
        ),
        if (identical(RECLUSTER_NEW_RULE_BROWSER_MOUNT_MODE, "selection_workspace")) {
          recluster_new_rule_browser_panel(
            ui_text = RECLUSTER_NEW_UI_TEXT,
            mount_mode = "selection_workspace"
          )
        }
      ),
      tabPanel(
        RECLUSTER_NEW_UI_TEXT$t_tab_metadata_curation,
        fluidRow(
          class = "recluster-new-curation-row",
          column(
            width = 3,
            class = "plotting-left-panel",
            div(
              class = "wl-side",
              h4(RECLUSTER_NEW_UI_TEXT$t_title_metadata_ops),
              uiOutput("recluster_new_source_col_ui"),
              textInput("recluster_new_new_col", RECLUSTER_NEW_UI_TEXT$t_label_new_column, value = "user_manual_label"),
              actionButton("recluster_new_duplicate_col_btn", RECLUSTER_NEW_UI_TEXT$t_btn_duplicate_column, class = "btn btn-default btn-sm"),
              tags$span(" "),
              actionButton("recluster_new_create_col_btn", RECLUSTER_NEW_UI_TEXT$t_btn_create_column, class = "btn btn-default btn-sm"),
              tags$hr(),
              uiOutput("recluster_new_group_col_ui"),
              uiOutput("recluster_new_group_level_ui"),
              uiOutput("recluster_new_relabel_target_col_ui"),
              textInput("recluster_new_relabel_value", RECLUSTER_NEW_UI_TEXT$t_label_new_label, value = ""),
              actionButton("recluster_new_apply_group_label_btn", RECLUSTER_NEW_UI_TEXT$t_btn_apply_group_label, class = "btn btn-default btn-sm"),
              tags$hr(),
              uiOutput("recluster_new_cell_target_col_ui"),
              textInput("recluster_new_cell_label_value", RECLUSTER_NEW_UI_TEXT$t_label_selected_row_label, value = ""),
              actionButton("recluster_new_apply_cell_label_btn", RECLUSTER_NEW_UI_TEXT$t_btn_apply_row_label, class = "btn btn-default btn-sm")
            )
          ),
          column(
            width = 9,
            class = "plot_area_card_style",
            div(
              class = "wl-side",
              h4(RECLUSTER_NEW_UI_TEXT$t_title_metadata_preview),
              div(class = "app-dt-horizontal-card", DTOutput("recluster_new_meta_table"))
            ),
            div(
              class = "wl-side",
              h4(RECLUSTER_NEW_UI_TEXT$t_title_import_preview),
              fluidRow(
                column(6, fileInput("recluster_new_meta_file", RECLUSTER_NEW_UI_TEXT$t_label_import_file, accept = c(".csv", ".tsv", ".txt"))),
                column(6, textInput("recluster_new_import_layer_name", RECLUSTER_NEW_UI_TEXT$t_label_new_column, value = "external_metadata"))
              ),
              uiOutput("recluster_new_import_col_selector_ui"),
              div(class = "app-dt-horizontal-card", DTOutput("recluster_new_import_preview_table"))
            ),
            div(
              class = "wl-side",
              h4(RECLUSTER_NEW_UI_TEXT$t_title_import_match),
              p(class = "text-muted", RECLUSTER_NEW_UI_TEXT$t_text_import_resolution),
              actionButton("recluster_new_run_match_btn", RECLUSTER_NEW_UI_TEXT$t_btn_run_match, class = "btn btn-primary btn-sm"),
              tags$span(" "),
              actionButton("recluster_new_apply_import_btn", RECLUSTER_NEW_UI_TEXT$t_btn_apply_import, class = "btn btn-success btn-sm"),
              tags$hr(),
              div(class = "app-dt-horizontal-card", DTOutput("recluster_new_import_resolution_table")),
              tags$hr(),
              div(class = "app-dt-horizontal-card", DTOutput("recluster_new_import_match_table"))
            )
          )
        )
      ),
      if (identical(RECLUSTER_NEW_RULE_BROWSER_MOUNT_MODE, "separate_tab")) {
        tabPanel(
          RECLUSTER_NEW_UI_TEXT$t_tab_metadata_overlap,
          recluster_new_rule_browser_panel(
            ui_text = RECLUSTER_NEW_UI_TEXT,
            mount_mode = "separate_tab"
          )
        )
      },
      tabPanel(
        "TCR/BCR Clones",
        fluidRow(
          class = "recluster-new-tcr-row",
          column(
            width = 3,
            class = "plotting-left-panel",
            div(
              class = "wl-side",
              h4("Clonotype Options"),
              radioButtons(
                "recluster_new_tcr_chain",
                "Chain Mode:",
                choices = c("TCR" = "tcr", "BCR" = "bcr"),
                selected = "tcr",
                inline = TRUE
              ),
              selectInput("recluster_new_tcr_clone_col", "Clone Column (ID):", choices = NULL),
              selectInput("recluster_new_tcr_cond_col", "Condition / Split Column:", choices = NULL),
              sliderInput("recluster_new_tcr_min_size", "Minimum Clone Size:", min = 1, max = 50, value = 1, step = 1),
              tags$hr(),
              actionButton(
                "recluster_new_tcr_select_all_btn",
                "Select Checked Clones",
                class = "btn btn-primary btn-sm",
                style = "width:100%;"
              )
            )
          ),
          column(
            width = 9,
            class = "plot_area_card_style",
            div(
              class = "wl-side",
              h4("Interactive Clone Table"),
              div(
                style = "margin-bottom:12px; color:#6b7280; font-size:12px;",
                "Select one or more rows to highlight cells carrying these clones in the main UMAP, and click 'Select Checked Clones' to load them into the Selection Workspace. Drag over the cell sequence column to view/copy."
              ),
              DT::dataTableOutput("recluster_new_tcr_table")
            ),
            div(
              class = "wl-side",
              style = "margin-top:12px;",
              h4("Clone Size Distribution by Condition"),
              plotlyOutput("recluster_new_tcr_dist_plot", height = "300px")
            )
          )
        )
      )
    ),
    div(
      id = "recluster_new_empty_workspace_state",
      style = "display: none;",
      div(
        class = "recluster-new-empty-state-card",
        div(
          class = "empty-state-icon",
          icon("database")
        ),
        h3("Data Browser is Empty"),
        p("There are no Seurat objects available in your workspace. Please import dataset files or load a saved RDS workspace to start exploring your single-cell RNA-seq datasets."),
        actionButton(
          "recluster_new_empty_state_go_to_workspace", 
          label = "Go to Workspace", 
          icon = icon("folder-open"),
          class = "btn-empty-state-go"
        )
      )
    )
  )
)
)

# R/page_recluster_new_server.R
recluster_new_server <- function(input, output, session, shared_data) {
  .db_tab_is_active <- function() {
    nav_now <- tolower(trimws(.scalar_chr(input$main_navbar, "")))
    return(nav_now %in% c("recluster_tab", "recluster_new_tab"))
  }

  observe({
    has_objs <- length(shared_data$all_seurat_objects) > 0L
    if (has_objs) {
      shinyjs::show("recluster_new_main_content_area")
      shinyjs::hide("recluster_new_empty_workspace_state")
    } else {
      shinyjs::hide("recluster_new_main_content_area")
      shinyjs::show("recluster_new_empty_workspace_state")
    }
  })

  observeEvent(input$recluster_new_empty_state_go_to_workspace, {
    updateNavbarPage(session, "main_navbar", selected = "rds_tab")
  })

  observe({
    has_objs <- length(shared_data$all_seurat_objects) > 0L
    if (has_objs) {
      shinyjs::show("recluster_new_main_content_area")
      shinyjs::hide("recluster_new_empty_workspace_state")
    } else {
      shinyjs::hide("recluster_new_main_content_area")
      shinyjs::show("recluster_new_empty_workspace_state")
    }
  })

  observeEvent(input$recluster_new_empty_state_go_to_workspace, {
    updateNavbarPage(session, "main_navbar", selected = "rds_tab")
  })
  
  recluster_new_data <- reactiveValues(
    seurat_obj = NULL,
    plot_df = NULL,
    last_load_status = "No active Seurat object selected.",
    cell_groups = list(),
    selected_cells = character(0),
    imported_barcode_sources = character(0),
    metadata_profiles = list(),
    metadata_active_column = "",
    metadata_active_cells = character(0),
    metadata_hover_active = FALSE,
    metadata_filter_state = "all",
    expr_selection = list(inherit_population = TRUE, groups = list(), next_group_index = 1L, next_gene_index = 1L),
    umap_gene_values = c("", "", ""),
    umap_color_choice = "",
    umap_display_mode = "metadata",
    umap_assay_choice = "",
    umap_reduction_choice = "",
    rule_assay_choice = "",
    rule_reduction_choice = "",
    pending_umap_assay_choice = "",
    pending_umap_reduction_choice = "",
    pending_rule_assay_choice = "",
    pending_rule_reduction_choice = "",
    pending_umap_color_choice = "",
    pending_umap_display_mode = "",
    umap_control_syncing = FALSE,
    visual_settings_by_object = list(),
    rule_definitions = list(),
    rule_active_cells = character(0),
    rule_overlap_group = NULL,
    rule_selected_group = "All",
    rule_manual_combine_mode = "union",
    debug_rule_overlap_state = "",
    metadata_open_column = "",
    metadata_open_bucket = "cluster",
    debug_meta_switch_count = 0L,
    viz_controls_cache_sig = "",
    viz_controls_cache = NULL,
    rule_viz_controls_cache_sig = "",
    rule_viz_controls_cache = NULL,
    final_plot_cache_sig = "",
    final_plot_cache = NULL,
    umap_plot_cache_sig = "",
    umap_plot_cache = NULL,
    violin_plot_cache_sig = "",
    violin_plot_cache = NULL,
    umap_color_tick = 0L,             # explicit trigger for UMAP re-render when user changes a color
    status_logs = character(0)
  )
  final_cell_count_text <- reactiveVal(paste(RECLUSTER_NEW_UI_TEXT$t_text_selected_total, 0L, "cells"))
  recluster_new_pending_population_cells <- reactiveVal(character(0))
  lasso_selected_cells_state <- reactiveVal(character(0))
  rule_lasso_cells_state <- reactiveVal(character(0))
  metadata_palette_picker <- curve_color_picker_server(
    "recluster_new_metadata_palette_picker",
    reset_trigger = reactive(input$recluster_new_metadata_palette_reset)
  )
  metadata_single_color_picker <- motion_color_picker_server(
    "recluster_new_metadata_single_color_picker",
    reset_trigger = reactive(input$recluster_new_metadata_single_color_reset)
  )

  .current_visual_settings <- function() {
    nm <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (!nzchar(nm)) nm <- .scalar_chr(shared_data$active_object_name, default = "")
    settings <- isolate(recluster_new_data$visual_settings_by_object[[nm]])
    if (!is.list(settings)) settings <- list()
    settings
  }

  .remember_visual_settings <- function(dot_size = NULL, stroke_width = NULL) {
    nm <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (!nzchar(nm)) nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(nm)) return(invisible(NULL))
    settings <- isolate(recluster_new_data$visual_settings_by_object[[nm]])
    if (!is.list(settings)) settings <- list()
    if (!is.null(dot_size)) settings$dot_size <- dot_size
    if (!is.null(stroke_width)) settings$stroke_width <- stroke_width
    recluster_new_data$visual_settings_by_object[[nm]] <- settings
    invisible(NULL)
  }

  # Agent note: Gene changes rebuild UMAP controls. Keep these values outside
  # input bindings and key them by object so rebuilding or switching objects
  # cannot reset user-selected dot size or highlight stroke setting.
  observeEvent(input$recluster_new_dot_size, {
    value <- suppressWarnings(as.numeric(input$recluster_new_dot_size))
    if (length(value) == 1L && is.finite(value) && value > 0) {
      .remember_visual_settings(dot_size = value)
    }
  }, ignoreInit = FALSE)

  observeEvent(input$recluster_new_stroke_width, {
    value <- suppressWarnings(as.numeric(input$recluster_new_stroke_width))
    if (length(value) == 1L && is.finite(value)) {
      .remember_visual_settings(stroke_width = max(0, min(1, value)))
    }
  }, ignoreInit = FALSE)

  recluster_new_object_selector <- wl_bind_active_object_selector(
    input = input,
    session = session,
    shared_data = shared_data,
    input_id = "recluster_new_dataset_select",
    choices = reactive(names(shared_data$all_seurat_objects %||% list())),
    active = reactive(.recluster_new_on_page()),
    on_user_selection = function(selected, previous) {
      loaded_now <- .scalar_chr(isolate(recluster_new_loaded_object_name()), default = "")
      .db_dbg(
        "dataset_select_user_applied",
        sprintf("value=%s prev_active=%s loaded=%s", selected, previous, loaded_now)
      )
      if (!identical(previous, selected)) {
        shared_data$active_object_name <- selected
      }
    },
    log_event = function(event, details) {
      .db_dbg(paste0("object_selector_", event), details)
    }
  )
  .rule_browser_mount_mode <- tryCatch(as.character(RECLUSTER_NEW_RULE_BROWSER_MOUNT_MODE), error = function(e) "separate_tab")
  if (!length(.rule_browser_mount_mode) || !nzchar(.rule_browser_mount_mode[[1]])) .rule_browser_mount_mode <- "separate_tab"
  .rule_browser_mount_mode <- .rule_browser_mount_mode[[1]]
  .active_plot_tab <- reactiveVal("umap")
  .active_expr_tab <- reactiveVal("stacked")
  .active_rule_plot_tab <- reactiveVal("rule_umap")
  .expr_bound_inputs <- reactiveVal(character(0))
  .gene_value_cache <- new.env(parent = emptyenv())
  .gene_value_cache_order <- character(0)
  .gene_value_cache_max <- 24L
  .clear_gene_value_cache <- function() {
    rm(list = ls(.gene_value_cache, all.names = TRUE), envir = .gene_value_cache)
    .gene_value_cache_order <<- character(0)
    invisible(NULL)
  }
  .db_dbg <- function(tag, ...) {
    ts <- format(Sys.time(), "%H:%M:%OS3")
    payload <- paste(..., collapse = " ")
    message(sprintf("[DB_UMAP_DBG][%s][%s] %s", ts, tag, payload))
  }
  .activate_gene_expression_display <- function() {
    expr_state <- .expr_state_normalize(recluster_new_data$expr_selection)
    active_group_id <- .scalar_chr(expr_state$active_group_id, default = "")
    if (nzchar(active_group_id)) {
      expr_state$active_group_id <- ""
      .expr_set_state(expr_state)
      .db_dbg("gene_mode_deactivate_expr_group", sprintf("group_id=%s", active_group_id))
    }
    recluster_new_data$umap_display_mode <- "gene"
    recluster_new_data$pending_umap_display_mode <- "gene"
    updateRadioButtons(session, "recluster_new_umap_display_mode", selected = "gene")
    .set_umap_color_choice("Single Gene Expression")
    if (!identical(.active_expr_tab(), "violin")) {
      .active_expr_tab("violin")
    }
    suppressWarnings(try(updateTabsetPanel(session, "recluster_new_expr_tabs", selected = "violin"), silent = TRUE))
    session$sendCustomMessage("recluster-new-set-tab", list(id = "recluster_new_expr_tabs", value = "violin"))
    invisible(NULL)
  }

  observeEvent(input$recluster_new_gene_expr_select_1, {
    if (isTRUE(recluster_new_data$umap_control_syncing)) return(invisible(NULL))
    old_gene <- .scalar_chr(as.character(recluster_new_data$umap_gene_values %||% c("", "", ""))[[1]], default = "")
    next_gene <- .scalar_chr(input$recluster_new_gene_expr_select_1, default = "")
    display_now <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
    if (identical(display_now, "metadata") && !nzchar(next_gene) && nzchar(old_gene)) {
      .db_dbg("gene1_ignored", sprintf("input=<empty> old=%s display=%s", old_gene, display_now))
      return(invisible(NULL))
    }
    .set_umap_gene_value(1L, next_gene)
    genes_now <- .umap_gene_selection()$genes
    if (nzchar(next_gene) && length(genes_now) && (!identical(display_now, "metadata") || !identical(next_gene, old_gene))) {
      .activate_gene_expression_display()
    }
    .db_dbg("gene1", sprintf("input=%s genes=%s color_before=%s",
      as.character(input$recluster_new_gene_expr_select_1 %||% ""),
      paste(genes_now, collapse = ","),
      as.character(recluster_new_data$umap_color_choice %||% "")
    ))
    .db_dbg("gene1", sprintf("color_after=%s", as.character(recluster_new_data$umap_color_choice %||% "")))
  }, ignoreNULL = TRUE)
  observeEvent(input$recluster_new_gene_expr_select_2, {
    if (isTRUE(recluster_new_data$umap_control_syncing)) return(invisible(NULL))
    old_vals <- as.character(recluster_new_data$umap_gene_values %||% c("", "", ""))
    length(old_vals) <- 3L
    old_gene <- .scalar_chr(old_vals[[2]], default = "")
    next_gene <- .scalar_chr(input$recluster_new_gene_expr_select_2, default = "")
    display_now <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
    if (identical(display_now, "metadata") && !nzchar(next_gene) && nzchar(old_gene)) {
      .db_dbg("gene2_ignored", sprintf("input=<empty> old=%s display=%s", old_gene, display_now))
      return(invisible(NULL))
    }
    .set_umap_gene_value(2L, next_gene)
    genes_now <- .umap_gene_selection()$genes
    if (nzchar(next_gene) && length(genes_now) && (!identical(display_now, "metadata") || !identical(next_gene, old_gene))) {
      .activate_gene_expression_display()
    }
    .db_dbg("gene2", sprintf("input=%s genes=%s color_before=%s",
      as.character(input$recluster_new_gene_expr_select_2 %||% ""),
      paste(genes_now, collapse = ","),
      as.character(recluster_new_data$umap_color_choice %||% "")
    ))
    .db_dbg("gene2", sprintf("color_after=%s", as.character(recluster_new_data$umap_color_choice %||% "")))
  }, ignoreNULL = TRUE)
  observeEvent(input$recluster_new_gene_expr_select_3, {
    if (isTRUE(recluster_new_data$umap_control_syncing)) return(invisible(NULL))
    old_vals <- as.character(recluster_new_data$umap_gene_values %||% c("", "", ""))
    length(old_vals) <- 3L
    old_gene <- .scalar_chr(old_vals[[3]], default = "")
    next_gene <- .scalar_chr(input$recluster_new_gene_expr_select_3, default = "")
    display_now <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
    if (identical(display_now, "metadata") && !nzchar(next_gene) && nzchar(old_gene)) {
      .db_dbg("gene3_ignored", sprintf("input=<empty> old=%s display=%s", old_gene, display_now))
      return(invisible(NULL))
    }
    .set_umap_gene_value(3L, next_gene)
    genes_now <- .umap_gene_selection()$genes
    if (nzchar(next_gene) && length(genes_now) && (!identical(display_now, "metadata") || !identical(next_gene, old_gene))) {
      .activate_gene_expression_display()
    }
    .db_dbg("gene3", sprintf("input=%s genes=%s color_before=%s",
      as.character(input$recluster_new_gene_expr_select_3 %||% ""),
      paste(genes_now, collapse = ","),
      as.character(recluster_new_data$umap_color_choice %||% "")
    ))
    .db_dbg("gene3", sprintf("color_after=%s", as.character(recluster_new_data$umap_color_choice %||% "")))
  }, ignoreNULL = TRUE)
  observeEvent(input$recluster_new_color_by_select, {
    if (isTRUE(recluster_new_data$umap_control_syncing)) return(invisible(NULL))
    next_choice <- .scalar_chr(input$recluster_new_color_by_select, default = "")
    if (!nzchar(next_choice)) return(invisible(NULL))
    pending_choice <- .scalar_chr(recluster_new_data$pending_umap_color_choice, default = "")
    if (nzchar(pending_choice) && identical(next_choice, pending_choice)) {
      recluster_new_data$pending_umap_color_choice <- ""
      return(invisible(NULL))
    }
    genes_now <- .umap_gene_selection()$genes
    .db_dbg("color_input", sprintf("next=%s genes=%s active_col=%s stored_before=%s",
      next_choice,
      paste(genes_now, collapse = ","),
      as.character(.active_umap_metadata_col() %||% ""),
      as.character(recluster_new_data$umap_color_choice %||% "")
    ))
    recluster_new_data$umap_color_choice <- next_choice
    recluster_new_data$umap_display_mode <- if (identical(next_choice, "Single Gene Expression")) "gene" else "metadata"
    recluster_new_data$pending_umap_display_mode <- recluster_new_data$umap_display_mode
    updateRadioButtons(session, "recluster_new_umap_display_mode", selected = recluster_new_data$umap_display_mode)
    .db_dbg("color_input_applied", sprintf(
      "stored=%s display=%s resolved=%s",
      as.character(recluster_new_data$umap_color_choice %||% ""),
      as.character(recluster_new_data$umap_display_mode %||% ""),
      as.character(.active_umap_metadata_col() %||% "")
    ))
  }, ignoreInit = TRUE)
  observeEvent(input$recluster_new_umap_display_mode, {
    mode_now <- .scalar_chr(input$recluster_new_umap_display_mode, default = "metadata")
    if (!(mode_now %in% c("metadata", "gene"))) mode_now <- "metadata"
    pending_mode <- .scalar_chr(recluster_new_data$pending_umap_display_mode, default = "")
    if (nzchar(pending_mode) && identical(mode_now, pending_mode)) {
      recluster_new_data$pending_umap_display_mode <- ""
      return(invisible(NULL))
    }
    recluster_new_data$umap_display_mode <- mode_now
    if (identical(mode_now, "gene")) {
      .set_umap_color_choice("Single Gene Expression")
    } else {
      .set_umap_color_choice(.active_umap_metadata_col())
    }
    .db_dbg("display_mode", sprintf("mode=%s color=%s", mode_now, .scalar_chr(recluster_new_data$umap_color_choice, default = "")))
  }, ignoreInit = TRUE)

  .norm_plot_tab <- function(v) {
    x <- tolower(trimws(.scalar_chr(v, default = "umap")))
    if (x %in% c("scatter", "gene scatter plot")) return("scatter")
    "umap"
  }
  .norm_expr_tab <- function(v) {
    x <- tolower(trimws(.scalar_chr(v, default = "stacked")))
    if (x %in% c("pseudobulk", "pseudobulk table")) return("pseudobulk")
    if (x %in% c("stacked", "stacked bar", "stacked bar plot")) return("stacked")
    "violin"
  }
  .norm_rule_plot_tab <- function(v) {
    x <- tolower(trimws(.scalar_chr(v, default = "rule_umap")))
    if (x %in% c("rule_scatter", "scatter", "gene scatter plot")) return("rule_scatter")
    "rule_umap"
  }
  .current_plot_tab <- reactive({ .active_plot_tab() })
  .current_expr_tab <- reactive({ .active_expr_tab() })
  .current_rule_plot_tab <- reactive({ .active_rule_plot_tab() })

  .scalar_chr <- function(x, default = "") {
    x <- as.character(x %||% default)
    x <- x[!is.na(x)]
    if (!length(x)) return(default)
    x[[1]]
  }

  .plotly_touch_zoom <- function(p) {
    plotly::config(
      p,
      scrollZoom = TRUE,
      displayModeBar = TRUE,
      doubleClick = "reset",
      responsive = TRUE
    )
  }

  .norm_key <- function(x) gsub("[^a-z0-9]", "", tolower(as.character(x %||% "")))
  .strip_suffix <- function(x) sub("([._-][0-9]+)$", "", as.character(x %||% ""), perl = TRUE)
  .embedding_reduction_choices <- function(obj) {
    if (is.null(obj) || !inherits(obj, "Seurat")) return(character(0))
    reds <- tryCatch(names(obj@reductions), error = function(e) character(0))
    if (!length(reds)) return(character(0))
    keep <- vapply(reds, function(red) {
      emb <- tryCatch(Seurat::Embeddings(obj, red), error = function(e) NULL)
      is.matrix(emb) && ncol(emb) >= 2L
    }, logical(1))
    reds[keep]
  }
  .reduction_shape_signature <- function(obj) {
    if (is.null(obj) || !inherits(obj, "Seurat")) return("")
    reds <- tryCatch(names(obj@reductions), error = function(e) character(0))
    if (!length(reds)) return("")
    parts <- vapply(reds, function(red) {
      emb <- tryCatch(Seurat::Embeddings(obj, red), error = function(e) NULL)
      if (is.null(emb) || !is.matrix(emb)) return(paste(red, "NA", sep = ":"))
      paste(red, nrow(emb), ncol(emb), sep = ":")
    }, character(1))
    paste(parts, collapse = "|")
  }
  .preferred_embedding_reduction <- function(obj, entry = NULL) {
    reds <- .embedding_reduction_choices(obj)
    if (!length(reds)) return("")
    reds_lc <- tolower(reds)
    dims_raw <- tryCatch(entry$prefs$confirmed_dims$value, error = function(e) NULL)
    dims_val <- suppressWarnings(as.integer(dims_raw))
    dims_val <- dims_val[is.finite(dims_val) & !is.na(dims_val)]
    if (length(dims_val)) {
      dims_tag <- as.character(dims_val[[1]])
      umap_dim <- which(grepl("umap", reds_lc, fixed = TRUE) & grepl(dims_tag, reds_lc, fixed = TRUE))
      if (length(umap_dim)) return(reds[[umap_dim[[1]]]])
      tsne_dim <- which(grepl("tsne", reds_lc, fixed = TRUE) & grepl(dims_tag, reds_lc, fixed = TRUE))
      if (length(tsne_dim)) return(reds[[tsne_dim[[1]]]])
    }
    if ("umap" %in% reds_lc) return(reds[[match("umap", reds_lc)]])
    umap_prefix <- which(grepl("^umap", reds_lc))
    if (length(umap_prefix)) return(reds[[umap_prefix[[1]]]])
    umap_any <- which(grepl("umap", reds_lc, fixed = TRUE))
    if (length(umap_any)) return(reds[[umap_any[[1]]]])
    reds[[1]]
  }
  .preferred_assay_choice <- function(obj) {
    assay_choices <- .safe_assay_choices(obj)
    if (!length(assay_choices)) return("")
    # Agent note: Data Browser expression must not inherit an integrated
    # DefaultAssay. Prefer biological expression assays in this fixed order.
    priority <- c("SCT", "RNA", "integrated", "ADT")
    priority_hit <- match(tolower(priority), tolower(assay_choices), nomatch = 0L)
    priority_hit <- priority_hit[priority_hit > 0L]
    if (length(priority_hit)) return(assay_choices[[priority_hit[[1]]]])
    assay_choices[[1]]
  }
  .current_umap_assay <- function(obj) {
    assay_choices <- .safe_assay_choices(obj)
    if (!length(assay_choices)) return("")
    target <- .scalar_chr(recluster_new_data$umap_assay_choice, default = "")
    if (nzchar(target) && target %in% assay_choices) return(target)
    input_val <- .scalar_chr(input$recluster_new_assay_select, default = "")
    if (nzchar(input_val) && input_val %in% assay_choices) return(input_val)
    .preferred_assay_choice(obj)
  }
  .current_rule_assay <- function(obj) {
    assay_choices <- .safe_assay_choices(obj)
    if (!length(assay_choices)) return("")
    target <- .scalar_chr(recluster_new_data$rule_assay_choice, default = "")
    if (nzchar(target) && target %in% assay_choices) return(target)
    input_val <- .scalar_chr(input$recluster_new_rule_assay_select, default = "")
    if (nzchar(input_val) && input_val %in% assay_choices) return(input_val)
    .preferred_assay_choice(obj)
  }
  .current_umap_reduction <- function(obj) {
    reduction_choices <- .embedding_reduction_choices(obj)
    if (!length(reduction_choices)) return("")
    target <- .scalar_chr(recluster_new_data$umap_reduction_choice, default = "")
    if (nzchar(target) && target %in% reduction_choices) return(target)
    input_val <- .scalar_chr(input$recluster_new_umap_reduction_select, default = "")
    if (nzchar(input_val) && input_val %in% reduction_choices) return(input_val)
    .preferred_embedding_reduction(obj)
  }
  .current_rule_reduction <- function(obj) {
    reduction_choices <- .embedding_reduction_choices(obj)
    if (!length(reduction_choices)) return("")
    target <- .scalar_chr(recluster_new_data$rule_reduction_choice, default = "")
    if (nzchar(target) && target %in% reduction_choices) return(target)
    input_val <- .scalar_chr(input$recluster_new_rule_umap_reduction_select, default = "")
    if (nzchar(input_val) && input_val %in% reduction_choices) return(input_val)
    .preferred_embedding_reduction(obj)
  }
  .pending_control_field <- function(input_id) {
    switch(
      .scalar_chr(input_id, default = ""),
      recluster_new_assay_select = "pending_umap_assay_choice",
      recluster_new_umap_reduction_select = "pending_umap_reduction_choice",
      recluster_new_rule_assay_select = "pending_rule_assay_choice",
      recluster_new_rule_umap_reduction_select = "pending_rule_reduction_choice",
      ""
    )
  }
  .set_pending_control <- function(input_id, selected) {
    fld <- .pending_control_field(input_id)
    if (!nzchar(fld)) return(invisible(NULL))
    recluster_new_data[[fld]] <- .scalar_chr(selected, default = "")
    invisible(NULL)
  }
  .consume_pending_control <- function(input_id, value) {
    fld <- .pending_control_field(input_id)
    if (!nzchar(fld)) return(FALSE)
    pending <- .scalar_chr(recluster_new_data[[fld]], default = "")
    if (!nzchar(pending)) return(FALSE)
    val <- .scalar_chr(value, default = "")
    if (identical(val, pending)) {
      recluster_new_data[[fld]] <- ""
      return(TRUE)
    }
    recluster_new_data[[fld]] <- ""
    .db_dbg("pending_control_user_value", sprintf("id=%s value=%s pending=%s", input_id, val, pending))
    FALSE
  }
  .update_control_select <- function(input_id, choices = NULL, selected = character(0)) {
    .db_dbg("update_control_select", sprintf("id=%s selected=%s choices_n=%d", input_id, paste(selected, collapse = ","), length(choices)))
    .set_pending_control(input_id, selected)
    freezeReactiveValue(input, input_id)
    if (is.null(choices)) {
      updateSelectInput(session, input_id, selected = selected)
    } else {
      updateSelectInput(session, input_id, choices = choices, selected = selected)
    }
    invisible(NULL)
  }
  .cell_set_signature <- function(cells, universe) {
    universe <- as.character(universe %||% character(0))
    universe <- universe[!is.na(universe) & nzchar(universe)]
    cells <- as.character(cells %||% character(0))
    cells <- unique(cells[!is.na(cells) & nzchar(cells)])
    if (!length(universe) || !length(cells)) return("0:0:0:0")
    mask <- universe %in% cells
    pad_n <- (8L - (length(mask) %% 8L)) %% 8L
    if (pad_n > 0L) {
      mask <- c(mask, rep(FALSE, pad_n))
    }
    raw_bits <- packBits(as.integer(mask), type = "raw")
    byte_vals <- as.integer(raw_bits)
    idx <- seq_along(byte_vals)
    paste(
      sum(mask),
      length(byte_vals),
      sum(byte_vals),
      sum(byte_vals * (idx %% 104729L)),
      sep = ":"
    )
  }
  .axis_index_choices <- function(obj, reduction_name) {
    red <- .scalar_chr(reduction_name, default = "")
    if (!nzchar(red)) return(character(0))
    emb <- tryCatch(Seurat::Embeddings(obj, red), error = function(e) NULL)
    if (is.null(emb) || !is.matrix(emb) || ncol(emb) < 2L) return(character(0))
    stats::setNames(as.character(seq_len(ncol(emb))), paste0("Dim ", seq_len(ncol(emb))))
  }
  .reduction_pca_dims_label <- function(obj, reduction_name) {
    if (is.null(obj) || !inherits(obj, "Seurat")) return("")
    red <- .scalar_chr(reduction_name, default = "")
    if (!nzchar(red) || !(red %in% names(obj@reductions))) return("")
    red_lc <- tolower(red)
    prefix <- if (grepl("tsne", red_lc, fixed = TRUE)) "TSNE" else if (grepl("umap", red_lc, fixed = TRUE)) "UMAP" else "PCA"
    dims_raw <- tryCatch(obj@reductions[[red]]@misc$cfg_signature$dims, error = function(e) NA_integer_)
    dims_val <- suppressWarnings(as.integer(dims_raw))
    dims_val <- dims_val[is.finite(dims_val) & !is.na(dims_val)]
    if (!length(dims_val)) {
      active_name <- .scalar_chr(shared_data$active_object_name, default = "")
      entry <- tryCatch(shared_data$all_seurat_objects[[active_name]], error = function(e) NULL)
      # Agent note: Analysis stores confirmed PCA dimensions on the object
      # package. Older reductions may lack cfg_signature, but their current
      # selector label must still identify the active embedding precisely.
      preferred_red <- .preferred_embedding_reduction(obj, entry = entry)
      if (identical(red, preferred_red)) {
        entry_dims <- suppressWarnings(as.integer(tryCatch(entry$prefs$confirmed_dims$value, error = function(e) NA_integer_)))
        dims_val <- entry_dims[is.finite(entry_dims) & !is.na(entry_dims)]
      }
    }
    dims_use <- if (length(dims_val)) dims_val[[1]] else NA_integer_
    if (is.finite(dims_use) && !is.na(dims_use) && dims_use >= 2L) {
      return(sprintf("%s_PCA_%d", prefix, dims_use))
    }
    m <- regexec("pca[_-]?([0-9]+)", red_lc, perl = TRUE)
    hit <- regmatches(red_lc, m)[[1]]
    if (length(hit) >= 2L && nzchar(hit[[2]])) {
      k <- suppressWarnings(as.integer(hit[[2]]))
      if (is.finite(k) && !is.na(k) && k >= 2L) return(sprintf("%s_PCA_%d", prefix, k))
    }
    sprintf("%s_PCA", prefix)
  }
  .reduction_display_label <- function(obj, reduction_name) {
    red <- .scalar_chr(reduction_name, default = "")
    if (!nzchar(red)) return("PCA")
    dims_lbl <- .reduction_pca_dims_label(obj, red)
    if (nzchar(dims_lbl)) dims_lbl else "PCA"
  }
  .embedding_axis_titles <- function(obj, reduction_name, x_idx, y_idx) {
    red <- .scalar_chr(reduction_name, default = "embedding")
    red_lbl <- .reduction_display_label(obj, red)
    x_use <- suppressWarnings(as.integer(x_idx))
    y_use <- suppressWarnings(as.integer(y_idx))
    if (!is.finite(x_use) || is.na(x_use) || x_use < 1L) x_use <- 1L
    if (!is.finite(y_use) || is.na(y_use) || y_use < 1L) y_use <- 2L
    list(
      x = sprintf("%s_%d", red_lbl, x_use),
      y = sprintf("%s_%d", red_lbl, y_use)
    )
  }

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

  .is_supported_meta_column <- function(v) {
    is.atomic(v) || is.factor(v)
  }

  .is_numeric_rule_column <- function(v) {
    if (!(is.numeric(v) || is.integer(v))) return(FALSE)
    vv <- suppressWarnings(as.numeric(v))
    any(is.finite(vv))
  }

  .likely_positive_values <- function(levels_vec, col_name = "") {
    lv <- as.character(levels_vec %||% character(0))
    lv <- lv[!is.na(lv) & nzchar(lv)]
    if (!length(lv)) return(character(0))
    key <- tolower(trimws(lv))
    pos_tokens <- c("true", "doublet", "positive", "pos", "yes", "1")
    hit <- key %in% pos_tokens
    is_doublet_col <- grepl("doublet", tolower(.scalar_chr(col_name, default = "")), fixed = TRUE)
    if (isTRUE(is_doublet_col)) hit <- hit & (key != "singlet")
    lv[hit]
  }

  .rule_color_presets <- function() {
    list(
      default = c(A_only = "#D55E00", B_only = "#0072B2", A_B = "#009E73", Neither = "#9CA3AF", Missing = "#6B7280"),
      colorblind = c(A_only = "#E69F00", B_only = "#56B4E9", A_B = "#009E73", Neither = "#999999", Missing = "#4D4D4D"),
      vivid = c(A_only = "#E64B35", B_only = "#4DBBD5", A_B = "#00A087", Neither = "#7E6148", Missing = "#3C5488")
    )
  }

  .rule_color_map_from_inputs <- function() {
    as.list(c(
      A_only = toupper(.scalar_chr(input$recluster_new_rule_color_a_only, default = "#D55E00")),
      B_only = toupper(.scalar_chr(input$recluster_new_rule_color_b_only, default = "#0072B2")),
      A_B = toupper(.scalar_chr(input$recluster_new_rule_color_ab, default = "#009E73")),
      Neither = toupper(.scalar_chr(input$recluster_new_rule_color_neither, default = "#9CA3AF")),
      Missing = toupper(.scalar_chr(input$recluster_new_rule_color_missing, default = "#6B7280"))
    ))
  }

  .classify_rule_column <- function(vec, def) {
    n <- length(vec)
    out <- rep("Missing", n)
    names(out) <- names(vec)
    if (!length(vec) || !is.list(def)) return(out)
    type_now <- .scalar_chr(def$type, default = "")
    if (identical(type_now, "numeric")) {
      rng <- suppressWarnings(as.numeric(def$range %||% c(NA_real_, NA_real_)))
      if (length(rng) != 2 || any(!is.finite(rng))) return(out)
      vv <- suppressWarnings(as.numeric(vec))
      good <- is.finite(vv)
      out[good] <- ifelse(vv[good] >= rng[[1]] & vv[good] <= rng[[2]], "TRUE", "FALSE")
      return(out)
    }
    vals <- trimws(as.character(vec %||% character(0)))
    good <- !is.na(vals) & nzchar(vals)
    selected <- as.character(def$selected %||% character(0))
    if (!length(selected)) {
      out[good] <- "FALSE"
      return(out)
    }
    out[good] <- ifelse(vals[good] %in% selected, "TRUE", "FALSE")
    out
  }

  .combine_rule_ab_overlap <- function(rule_a_state, rule_b_state) {
    n <- max(length(rule_a_state), length(rule_b_state))
    out <- rep("Missing", n)
    a <- as.character(rule_a_state %||% rep("Missing", n))
    b <- as.character(rule_b_state %||% rep("Missing", n))
    if (!length(a) || !length(b)) return(out)
    miss <- a == "Missing" | b == "Missing"
    out[miss] <- "Missing"
    a_true <- a == "TRUE"
    b_true <- b == "TRUE"
    out[!miss & a_true & b_true] <- "A_B"
    out[!miss & a_true & !b_true] <- "A_only"
    out[!miss & !a_true & b_true] <- "B_only"
    out[!miss & !a_true & !b_true] <- "Neither"
    out
  }

  .is_reasonable_discrete <- function(v) {
    if (is.factor(v) || is.character(v) || is.logical(v)) return(TRUE)
    if (is.numeric(v) || is.integer(v)) return(length(unique(stats::na.omit(v))) <= 40L)
    FALSE
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

  .sort_numeric_first <- function(v) {
    v <- as.character(v %||% character(0))
    v <- v[nzchar(v)]
    if (!length(v)) return(character(0))
    uniq <- unique(v)
    num <- suppressWarnings(as.numeric(uniq))
    ok <- is.finite(num)
    out_num <- uniq[ok][order(num[ok], uniq[ok])]
    out_chr <- sort(uniq[!ok], na.last = TRUE)
    c(out_num, out_chr)
  }

  .is_cluster_like_name <- function(col_name) {
    cn <- tolower(as.character(col_name %||% ""))
    grepl("(^|_|\\.)(cluster|seurat|res\\.|leiden|louvain|snn|nn|wsnn|wknn|ident)(_|\\.|$)", cn, perl = TRUE)
  }

  .is_continuous_metric_name <- function(col_name) {
    cn <- tolower(as.character(col_name %||% ""))
    grepl(
      "(^|_|\\.)(size|count|counts|score|scores|rate|ratio|percent|percentage|pct|freq|frequency|depth|reads|umis|umi|nfeature|ncount|total|sum|mean|median|max|min)(_|\\.|$)",
      cn,
      perl = TRUE
    )
  }

  .build_metadata_profile <- function(col_name, vec) {
    x <- vec
    x_chr <- trimws(as.character(x %||% character(0)))
    keep <- nzchar(x_chr) & !is.na(x_chr)
    x_keep <- x_chr[keep]
    parsed <- suppressWarnings(as.numeric(x_keep))
    parsed_ok <- is.finite(parsed)
    parse_rate <- if (length(x_keep)) mean(parsed_ok) else 0
    numeric_like <- parse_rate >= 0.95

    numeric_vals <- suppressWarnings(as.numeric(x_chr))
    finite_num <- numeric_vals[is.finite(numeric_vals)]
    unique_num <- sort(unique(finite_num))
    unique_n <- length(unique_num)
    integer_like <- length(unique_num) > 0 && all(abs(unique_num - round(unique_num)) < 1e-8)
    consecutive_numeric <- length(unique_num) > 1 && all(abs(diff(unique_num) - 1) < 1e-8)

    name_continuous_metric <- .is_continuous_metric_name(col_name)
    name_cluster_like <- .is_cluster_like_name(col_name) && !isTRUE(name_continuous_metric)
    behavior_cluster_like <- numeric_like && integer_like && unique_n >= 2 && unique_n <= 200 &&
      !isTRUE(name_continuous_metric) &&
      ((unique_n / max(1, length(unique(finite_num)))) <= 1.0)

    cluster_like <- isTRUE(name_cluster_like) || isTRUE(behavior_cluster_like)

    if (!numeric_like) {
      default_mode <- "category"
    } else if (unique_n > 200) {
      default_mode <- "range"
    } else if (isTRUE(name_continuous_metric)) {
      default_mode <- "range"
    } else if (cluster_like) {
      default_mode <- "category"
    } else if (consecutive_numeric) {
      default_mode <- "range"
    } else if (unique_n <= 24) {
      default_mode <- "category"
    } else {
      default_mode <- "range"
    }

    bucket <- if (cluster_like) {
      "cluster"
    } else if (numeric_like && identical(default_mode, "range")) {
      "continuous"
    } else {
      "categorical"
    }

    levels <- .sort_numeric_first(unique(x_chr[keep]))

    list(
      col_name = col_name,
      bucket = bucket,
      numeric_like = numeric_like,
      unique_numeric_count = unique_n,
      integer_like = integer_like,
      consecutive_numeric = consecutive_numeric,
      cluster_like = cluster_like,
      default_mode = default_mode,
      levels = levels,
      min_val = if (length(unique_num)) min(unique_num) else NA_real_,
      max_val = if (length(unique_num)) max(unique_num) else NA_real_
    )
  }

  .safe_key <- function(x) {
    out <- gsub("[^A-Za-z0-9]+", "_", as.character(x %||% ""), perl = TRUE)
    out <- gsub("_+", "_", out)
    out <- gsub("^_|_$", "", out)
    if (!nzchar(out)) out <- "col"
    out
  }

  .unique_metadata_col_name <- function(md, label, prefix = "saved_group") {
    base <- paste(prefix, .safe_key(label), sep = "_")
    base <- gsub("_+", "_", base)
    base <- gsub("^_|_$", "", base)
    if (!nzchar(base)) base <- prefix
    out <- base
    i <- 2L
    while (out %in% colnames(md)) {
      out <- sprintf("%s_%d", base, i)
      i <- i + 1L
    }
    out
  }

  .saved_group_metadata_col <- function(group_name, group = NULL, md = NULL) {
    stored <- .scalar_chr(group$metadata_col, default = "")
    if (nzchar(stored) && (is.null(md) || stored %in% colnames(md))) return(stored)
    if (is.null(md)) return("")
    base <- paste("saved_group", .safe_key(group_name), sep = "_")
    base <- gsub("_+", "_", base)
    base <- gsub("^_|_$", "", base)
    candidates <- colnames(md)[colnames(md) == base | grepl(paste0("^", gsub("([\\W])", "\\\\\\1", base, perl = TRUE), "_[0-9]+$"), colnames(md), perl = TRUE)]
    if (length(candidates)) candidates[[length(candidates)]] else ""
  }

  .sparsify_saved_group_metadata <- function(md, groups = list()) {
    if (is.null(md) || !ncol(md)) return(md)
    saved_cols <- colnames(md)[grepl("^saved_group_", colnames(md))]
    if (!length(saved_cols)) return(md)
    for (col in saved_cols) {
      vals <- md[[col]]
      vals_chr <- as.character(vals)
      is_bool_col <- is.logical(vals) || all(stats::na.omit(vals_chr) %in% c("TRUE", "FALSE"))
      if (!isTRUE(is_bool_col)) next
      group_label <- ""
      if (length(groups)) {
        for (nm in names(groups)) {
          if (identical(.saved_group_metadata_col(nm, groups[[nm]], md), col)) {
            group_label <- nm
            break
          }
        }
      }
      if (!nzchar(group_label)) group_label <- sub("^saved_group_", "", col)
      out <- rep(NA_character_, length(vals_chr))
      out[!is.na(vals_chr) & vals_chr == "TRUE"] <- group_label
      md[[col]] <- out
    }
    md
  }

  .profile_key <- function(col_name) paste0("k_", .safe_key(col_name), "_", sprintf("%03d", match(col_name, names(recluster_new_data$metadata_profiles))))

  .mode_input_id <- function(col_name) paste0("recluster_new_mode__", .profile_key(col_name))
  .cat_input_id <- function(col_name) paste0("recluster_new_cat__", .profile_key(col_name))
  .rng_input_id <- function(col_name) paste0("recluster_new_rng__", .profile_key(col_name))
  .cat_level_input_id <- function(col_name, level_name) paste0("recluster_new_cat_level__", .profile_key(col_name), "__", .safe_key(level_name))
  .grp_toggle_input_id <- function(group_name) paste0("recluster_new_group_enabled__", .safe_key(group_name))
  .grp_delete_input_id <- function(group_name) paste0("recluster_new_group_delete__", .safe_key(group_name))
  .expr_group_rename_input_id <- function(group_id) paste0("recluster_new_expr_group_rename__", .safe_key(group_id))
  .expr_group_open_input_id <- function(group_id) paste0("recluster_new_expr_group_open__", .safe_key(group_id))
  .expr_group_require_all_input_id <- function(group_id) paste0("recluster_new_expr_require_all__", .safe_key(group_id))
  .expr_group_invert_input_id <- function(group_id) paste0("recluster_new_expr_invert__", .safe_key(group_id))
  .expr_group_delete_input_id <- function(group_id) paste0("recluster_new_expr_group_delete__", .safe_key(group_id))
  .expr_group_add_gene_input_id <- function(group_id) paste0("recluster_new_expr_add_gene__", .safe_key(group_id))
  .expr_group_select_all_input_id <- function(group_id) paste0("recluster_new_expr_select_all__", .safe_key(group_id))
  .expr_gene_check_input_id <- function(group_id, gene_id) paste0("recluster_new_expr_gene_check__", .safe_key(group_id), "__", .safe_key(gene_id))
  .expr_gene_active_input_id <- function(group_id, gene_id) paste0("recluster_new_expr_gene_active__", .safe_key(group_id), "__", .safe_key(gene_id))
  .expr_gene_delete_input_id <- function(group_id, gene_id) paste0("recluster_new_expr_gene_delete__", .safe_key(group_id), "__", .safe_key(gene_id))

  .expr_default_state <- function() {
    list(inherit_population = TRUE, active_group_id = "", groups = list(), next_group_index = 1L, next_gene_index = 1L)
  }

  .expr_state_normalize <- function(state) {
    if (!is.list(state)) state <- .expr_default_state()
    out <- .expr_default_state()
    out$inherit_population <- isTRUE(state$inherit_population %||% TRUE)
    active_group_id <- .scalar_chr(state$active_group_id, default = "")
    out$active_group_id <- if (nzchar(active_group_id)) .safe_key(active_group_id) else ""
    out$next_group_index <- suppressWarnings(as.integer(state$next_group_index %||% 1L))
    out$next_gene_index <- suppressWarnings(as.integer(state$next_gene_index %||% 1L))
    if (!is.finite(out$next_group_index) || is.na(out$next_group_index) || out$next_group_index < 1L) out$next_group_index <- 1L
    if (!is.finite(out$next_gene_index) || is.na(out$next_gene_index) || out$next_gene_index < 1L) out$next_gene_index <- 1L
    groups <- state$groups %||% list()
    if (!is.list(groups)) groups <- list()
    out_groups <- list()
    for (i in seq_along(groups)) {
      g <- groups[[i]]
      if (!is.list(g)) next
      gid <- .scalar_chr(g$id, default = sprintf("g%03d", i))
      gid <- .safe_key(gid)
      gene_rows <- g$genes %||% list()
      if (!is.list(gene_rows)) gene_rows <- list()
      clean_genes <- list()
      for (j in seq_along(gene_rows)) {
        gr <- gene_rows[[j]]
        if (!is.list(gr)) next
        gene <- trimws(.scalar_chr(gr$gene, default = ""))
        if (!nzchar(gene)) next
        geid <- .safe_key(.scalar_chr(gr$id, default = sprintf("%s_gene_%03d", gid, j)))
        rng <- suppressWarnings(as.numeric(gr$range %||% c(NA_real_, NA_real_)))
        rng <- rng[is.finite(rng)]
        rng <- if (length(rng) >= 2L) sort(rng[seq_len(2L)]) else NULL
        clean_genes[[length(clean_genes) + 1L]] <- list(
          id = geid,
          gene = gene,
          checked = isTRUE(gr$checked %||% TRUE),
          range = rng
        )
      }
      active_gene_id <- .safe_key(.scalar_chr(g$active_gene_id, default = ""))
      gene_ids <- vapply(clean_genes, function(x) .scalar_chr(x$id, default = ""), character(1))
      # Agent note: Empty active_gene_id is intentional user state: no orange
      # active-gene outline. Only repair non-empty IDs that reference a removed gene.
      if (!length(gene_ids)) {
        active_gene_id <- ""
      } else if (nzchar(active_gene_id) && !(active_gene_id %in% gene_ids)) {
        active_gene_id <- gene_ids[[1]]
      }
      out_groups[[length(out_groups) + 1L]] <- list(
        id = gid,
        name = .scalar_chr(g$name, default = sprintf("Expression group %d", i)),
        open = isTRUE(g$open %||% FALSE),
        require_all = isTRUE(g$require_all %||% FALSE),
        invert = isTRUE(g$invert %||% FALSE),
        active_gene_id = active_gene_id,
        genes = clean_genes
      )
    }
    active_gid <- .scalar_chr(out$active_group_id, default = "")
    if (nzchar(active_gid)) active_gid <- .safe_key(active_gid)
    group_ids <- vapply(out_groups, function(g) .scalar_chr(g$id, default = ""), character(1))
    # Agent note: Empty active_group_id explicitly means expression selection
    # is inactive. Only repair a nonempty stale ID; gene mode depends on this.
    if (nzchar(active_gid) && !(active_gid %in% group_ids)) {
      active_gid <- if (length(group_ids)) group_ids[[length(group_ids)]] else ""
    }
    out$active_group_id <- active_gid
    out$groups <- out_groups
    used_g <- suppressWarnings(as.integer(gsub("[^0-9]", "", vapply(out_groups, function(g) .scalar_chr(g$id, default = ""), character(1)))))
    used_ge <- suppressWarnings(as.integer(gsub("[^0-9]", "", unlist(lapply(out_groups, function(g) vapply(g$genes %||% list(), function(x) .scalar_chr(x$id, default = ""), character(1))), use.names = FALSE))))
    if (length(used_g <- used_g[is.finite(used_g) & !is.na(used_g)])) out$next_group_index <- max(out$next_group_index, max(used_g) + 1L)
    if (length(used_ge <- used_ge[is.finite(used_ge) & !is.na(used_ge)])) out$next_gene_index <- max(out$next_gene_index, max(used_ge) + 1L)
    out
  }

  .expr_store_get <- function(sobj) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(.expr_default_state())
    misc <- tryCatch(sobj@misc, error = function(e) list())
    ana <- tryCatch(misc$analysis, error = function(e) NULL)
    dbn <- if (is.list(ana)) tryCatch(ana$data_browser_new, error = function(e) NULL) else NULL
    .expr_state_normalize(if (is.list(dbn)) dbn$expression_selection else NULL)
  }

  .expr_store_set <- function(sobj, state) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(sobj)
    misc <- tryCatch(sobj@misc, error = function(e) list())
    if (!is.list(misc$analysis)) misc$analysis <- list()
    if (!is.list(misc$analysis$data_browser_new)) misc$analysis$data_browser_new <- list()
    misc$analysis$data_browser_new$expression_selection <- .expr_state_normalize(state)
    sobj@misc <- misc
    sobj
  }

  .expr_set_state <- function(state, persist = TRUE) {
    state <- .expr_state_normalize(state)
    recluster_new_data$expr_selection <- state
    if (isTRUE(persist)) {
      obj <- recluster_new_data$seurat_obj
      if (!is.null(obj) && inherits(obj, "Seurat")) {
        obj <- .expr_store_set(obj, state)
        # Agent note: Expression state lives in Seurat misc, but replacing local
        # plot object rebuilds controls and resets user-selected assay.
        .persist_active_object(obj, update_local = FALSE)
      }
    }
    invisible(state)
  }

  .expr_group_index <- function(state, group_id) {
    groups <- state$groups %||% list()
    ids <- vapply(groups, function(g) .scalar_chr(g$id, default = ""), character(1))
    hit <- which(ids == group_id)
    if (length(hit)) hit[[1]] else NA_integer_
  }

  .expr_gene_index <- function(group, gene_id) {
    genes <- group$genes %||% list()
    ids <- vapply(genes, function(g) .scalar_chr(g$id, default = ""), character(1))
    hit <- which(ids == gene_id)
    if (length(hit)) hit[[1]] else NA_integer_
  }

  .expr_set_active_group <- function(state, group_id) {
    state <- .expr_state_normalize(state)
    group_id <- .safe_key(.scalar_chr(group_id, default = ""))
    if (!nzchar(group_id) || is.na(.expr_group_index(state, group_id))) {
      return(state)
    }
    state$active_group_id <- group_id
    for (i in seq_along(state$groups %||% list())) {
      gid <- .scalar_chr(state$groups[[i]]$id, default = "")
      state$groups[[i]]$open <- identical(gid, group_id)
    }
    state
  }

  .expr_set_active_gene_id <- function(state, group_id, gene_id) {
    state <- .expr_set_active_group(state, group_id)
    group_id <- .scalar_chr(group_id, default = "")
    gene_id <- .scalar_chr(gene_id, default = "")
    gi <- .expr_group_index(state, group_id)
    if (!is.na(gi)) {
      state$groups[[gi]]$active_gene_id <- gene_id
    }
    state
  }

  .expr_format_range <- function(rng) {
    vals <- suppressWarnings(as.numeric(rng %||% numeric(0)))
    vals <- vals[is.finite(vals)]
    if (length(vals) < 2L) return(RECLUSTER_NEW_UI_TEXT$t_text_expr_range_all)
    sprintf("range %s-%s", signif(vals[[1]], 3), signif(vals[[2]], 3))
  }

  .expr_active_group <- function(state = recluster_new_data$expr_selection) {
    state <- .expr_state_normalize(state)
    active_gid <- .scalar_chr(state$active_group_id, default = "")
    if (!nzchar(active_gid)) return(NULL)
    gi <- .expr_group_index(state, active_gid)
    if (is.na(gi)) return(NULL)
    state$groups[[gi]]
  }

  .expr_active_gene <- function(state = recluster_new_data$expr_selection) {
    g <- .expr_active_group(state)
    if (is.null(g)) return(NULL)
    active_id <- .scalar_chr(g$active_gene_id, default = "")
    genes <- g$genes %||% list()
    if (!nzchar(active_id) || !length(genes)) return(NULL)
    hit <- .expr_gene_index(g, active_id)
    if (is.na(hit)) return(NULL)
    gr <- genes[[hit]]
    list(
      group_id = .scalar_chr(g$id, default = ""),
      gene_id = .scalar_chr(gr$id, default = ""),
      gene = .scalar_chr(gr$gene, default = ""),
      range = gr$range
    )
  }

  .expr_clear_active_gene_range <- function() {
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    active <- .expr_active_gene(state)
    if (is.null(active)) return(invisible(FALSE))
    gi <- .expr_group_index(state, active$group_id)
    if (is.na(gi)) return(invisible(FALSE))
    gene_i <- .expr_gene_index(state$groups[[gi]], active$gene_id)
    if (is.na(gene_i)) return(invisible(FALSE))
    state$groups[[gi]]$genes[[gene_i]]$range <- NULL
    .expr_set_state(state)
    invisible(TRUE)
  }

  .is_hex_color <- function(x) grepl("^#[0-9A-F]{6}$", toupper(as.character(x %||% "")))

  .get_fallback_pool <- function() {
    pals <- tryCatch(get("all_palettes", envir = .GlobalEnv), error = function(e) NULL)
    if (is.null(pals)) {
      pals <- list(c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"))
    }
    custom_cols <- unlist(pals, use.names = FALSE)
    custom_cols <- toupper(unique(custom_cols[grepl("^#[0-9A-F]{6}$", toupper(as.character(custom_cols %||% character(0))))]))
    if (!length(custom_cols)) {
      custom_cols <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")
    }
    custom_cols
  }

  .seurat_discrete_palette <- function(n) {
    n <- suppressWarnings(as.integer(n %||% 0L))
    if (!is.finite(n) || n < 1L) return(character(0))
    
    palette_choice <- DATA_BROWSER_DEFAULT_PALETTE
    pal <- character(0)
    
    if (identical(palette_choice, "Default Seurat")) {
      fn <- tryCatch(getFromNamespace("DiscretePalette", "Seurat"), error = function(e) NULL)
      pal <- tryCatch(
        if (is.function(fn)) suppressWarnings(as.character(fn(n))) else character(0),
        error = function(e) character(0)
      )
    } else {
      pals <- tryCatch(get("all_palettes", envir = .GlobalEnv), error = function(e) NULL)
      base_colors <- if (is.list(pals)) pals[[palette_choice]] else NULL
      if (length(base_colors) > 0) {
        pal <- tryCatch(
          grDevices::colorRampPalette(base_colors)(n),
          error = function(e) character(0)
        )
      }
    }
    
    if (length(pal) < n) {
      pal_fallback <- grDevices::hcl.colors(max(n, 3L), palette = "Dark 3")
      if (length(pal) > 0) {
        pal <- c(pal, pal_fallback[(length(pal) + 1):max(n, 3L)])
      } else {
        pal <- pal_fallback
      }
    }
    
    fallback_pool <- .get_fallback_pool()
    res <- toupper(as.character(pal[seq_len(n)]))
    for (i in seq_len(n)) {
      if (is.na(res[i]) || !.is_hex_color(res[i])) {
        fallback_col <- fallback_pool[i]
        if (is.na(fallback_col) || !.is_hex_color(fallback_col)) {
          hcl_fallback <- grDevices::hcl.colors(max(n, 3L), palette = "Dark 3")
          fallback_col <- hcl_fallback[i] %||% "#4B5563"
        }
        res[i] <- toupper(fallback_col)
      }
    }
    res
  }

  .read_metadata_level_colors <- function(sobj, col_name) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(list())
    misc <- tryCatch(sobj@misc, error = function(e) list())
    store <- tryCatch(misc$metadata_level_colors, error = function(e) NULL)
    if (!is.list(store) || is.null(store[[col_name]]) || !is.list(store[[col_name]])) return(list())
    raw <- store[[col_name]]
    out <- lapply(raw, function(v) {
      vv <- toupper(.scalar_chr(v, default = ""))
      if (.is_hex_color(vv)) vv else NULL
    })
    out[!vapply(out, is.null, logical(1))]
  }

  .level_color_map <- function(sobj, col_name, levels_vec) {
    requested_levels <- as.character(levels_vec %||% character(0))
    requested_levels[is.na(requested_levels) | !nzchar(requested_levels)] <- "(NA)"
    object_levels <- character(0)
    if (!is.null(sobj) && inherits(sobj, "Seurat") && col_name %in% colnames(sobj@meta.data)) {
      object_levels <- as.character(sobj@meta.data[[col_name]] %||% character(0))
      object_levels[is.na(object_levels) | !nzchar(object_levels)] <- "(NA)"
    }
    # Agent note: Metadata palettes belong to full object-level universes, not
    # visible/filter subsets. Hidden populations keep reserved color positions.
    lv <- .sort_numeric_first(unique(c(object_levels, requested_levels)))
    if (!length(lv)) return(setNames(character(0), character(0)))
    fallback <- .seurat_discrete_palette(length(lv))
    names(fallback) <- lv
    stored <- .read_metadata_level_colors(sobj, col_name)
    if (!length(stored)) return(fallback)
    out <- fallback
    for (nm in lv) {
      sv <- toupper(.scalar_chr(stored[[nm]], default = ""))
      if (.is_hex_color(sv)) out[[nm]] <- sv
    }
    out
  }

  .metadata_color_as_discrete <- function(col_name) {
    profiles <- recluster_new_data$metadata_profiles
    col_name <- .scalar_chr(col_name, default = "")
    if (!nzchar(col_name) || !length(profiles) || is.null(profiles[[col_name]])) return(FALSE)
    p <- profiles[[col_name]]
    mode_now <- .resolved_mode(
      p,
      .scalar_chr(input[[.mode_input_id(col_name)]], default = p$default_mode %||% "category")
    )
    identical(mode_now, "category") || isTRUE(p$cluster_like)
  }

  .assay_feature_names <- function(obj, assay_name = NULL) {
    if (is.null(obj) || !inherits(obj, "Seurat")) return(character(0))
    assays <- .safe_assay_choices(obj)
    assay_name <- .scalar_chr(assay_name, default = "")
    if (!nzchar(assay_name) || !(assay_name %in% assays)) {
      assay_name <- if (length(assays)) assays[[1]] else ""
    }
    if (!nzchar(assay_name)) return(character(0))
    assay_obj <- tryCatch(obj[[assay_name]], error = function(e) NULL)
    feats <- tryCatch({
      out <- tryCatch(Seurat::Features(assay_obj), error = function(e) NULL)
      if (is.null(out) || !length(out)) out <- tryCatch(rownames(assay_obj), error = function(e) NULL)
      as.character(out %||% character(0))
    }, error = function(e) character(0))
    feats <- unique(feats[!is.na(feats) & nzchar(feats)])
    if (length(feats)) return(feats)

    for (layer_name in c("data", "counts", "scale.data")) {
      mat <- tryCatch(SeuratObject::GetAssayData(obj, assay = assay_name, layer = layer_name), error = function(e) NULL)
      if (is.null(mat)) {
        mat <- tryCatch(SeuratObject::GetAssayData(obj, assay = assay_name, slot = layer_name), error = function(e) NULL)
      }
      feats <- unique(as.character(rownames(mat) %||% character(0)))
      feats <- feats[!is.na(feats) & nzchar(feats)]
      if (length(feats)) return(feats)
    }
    character(0)
  }

  .fetch_gene_values <- function(obj, assay_name, gene_name, slot_name = "data") {
    if (is.null(obj) || !inherits(obj, "Seurat")) return(NULL)
    if (!nzchar(assay_name %||% "") || !nzchar(gene_name %||% "")) return(NULL)
    genes <- .assay_feature_names(obj, assay_name)
    if (!length(genes)) return(NULL)
    hit <- genes[tolower(genes) == tolower(gene_name)]
    if (!length(hit)) return(NULL)
    gene_match <- hit[[1]]
    obj_key <- .safe_key(.scalar_chr(shared_data$active_object_name, default = "active"))
    cache_key <- paste(obj_key, .safe_key(assay_name), .safe_key(slot_name), .safe_key(tolower(gene_match)), sep = "::")
    if (exists(cache_key, envir = .gene_value_cache, inherits = FALSE)) {
      return(get(cache_key, envir = .gene_value_cache, inherits = FALSE))
    }
    assay_obj <- tryCatch(obj[[assay_name]], error = function(e) NULL)
    use_layer <- inherits(assay_obj, "Assay5")
    vec <- tryCatch({
      dat <- if (isTRUE(use_layer)) {
        SeuratObject::GetAssayData(obj, assay = assay_name, layer = slot_name)
      } else {
        SeuratObject::GetAssayData(obj, assay = assay_name, slot = slot_name)
      }
      as.numeric(dat[gene_match, ])
    }, error = function(e) {
      tryCatch({
        dat <- if (isTRUE(use_layer)) {
          SeuratObject::GetAssayData(obj, assay = assay_name, slot = slot_name)
        } else {
          SeuratObject::GetAssayData(obj, assay = assay_name, layer = slot_name)
        }
        as.numeric(dat[gene_match, ])
      }, error = function(e2) NULL)
    })
    if (is.null(vec)) return(NULL)
    names(vec) <- colnames(obj)
    assign(cache_key, vec, envir = .gene_value_cache)
    .gene_value_cache_order <<- unique(c(.gene_value_cache_order, cache_key))
    if (length(.gene_value_cache_order) > .gene_value_cache_max) {
      drop_keys <- head(.gene_value_cache_order, length(.gene_value_cache_order) - .gene_value_cache_max)
      rm(list = drop_keys, envir = .gene_value_cache)
      .gene_value_cache_order <<- setdiff(.gene_value_cache_order, drop_keys)
    }
    vec
  }

  .expr_selection_slot <- function() {
    "data"
  }

  .expr_expression_range_info <- function(vals) {
    vals <- suppressWarnings(as.numeric(vals %||% numeric(0)))
    vals <- vals[is.finite(vals)]
    if (!length(vals)) return(NULL)
    full_rng <- range(vals, na.rm = TRUE)
    if (!all(is.finite(full_rng)) || full_rng[[1]] >= full_rng[[2]]) return(NULL)
    nz <- vals[vals > 0]
    min_nz <- if (length(nz)) min(nz, na.rm = TRUE) else NA_real_
    lower <- if (is.finite(min_nz)) min_nz else full_rng[[1]]
    lower <- max(full_rng[[1]], min(lower, full_rng[[2]]))
    list(
      full_range = full_rng,
      default_range = c(lower, full_rng[[2]]),
      min_nonzero = min_nz
    )
  }

  .selected_levels_for_column <- function(col_name, profile) {
    lv <- as.character(profile$levels %||% character(0))
    if (!length(lv)) return(character(0))
    keep <- vapply(lv, function(x) isTRUE(input[[.cat_level_input_id(col_name, x)]] %||% TRUE), logical(1))
    lv[keep]
  }

  .metadata_has_value <- function(vec) {
    if (is.numeric(vec) || is.integer(vec)) {
      return(is.finite(vec))
    }
    !is.na(vec) & nzchar(trimws(as.character(vec %||% "")))
  }

  .metadata_non_na_cells <- function(md, col_name) {
    if (is.null(md) || !is.data.frame(md) || !nrow(md) || !nzchar(col_name) || !(col_name %in% colnames(md))) {
      return(character(0))
    }
    keep <- .metadata_has_value(md[[col_name]])
    unique(rownames(md)[keep])
  }

  .is_metadata_color_mirror_column <- function(col_name, all_col_names) {
    col_name <- .scalar_chr(col_name, default = "")
    all_col_names <- as.character(all_col_names %||% character(0))
    if (!nzchar(col_name) || !grepl("_color$", col_name)) return(FALSE)
    base <- sub("_color$", "", col_name)
    nzchar(base) && base %in% all_col_names
  }

  .filter_browser_metadata_columns <- function(col_names) {
    col_names <- as.character(col_names %||% character(0))
    col_names <- col_names[!is.na(col_names) & nzchar(col_names)]
    if (!length(col_names)) return(character(0))
    col_names[!vapply(col_names, .is_metadata_color_mirror_column, logical(1), all_col_names = col_names)]
  }

  .resolve_metadata_browser_column <- function(col_name, available_cols) {
    col_name <- .scalar_chr(col_name, default = "")
    available_cols <- as.character(available_cols %||% character(0))
    if (!nzchar(col_name)) return("")
    if (col_name %in% available_cols) return(col_name)
    if (grepl("_color$", col_name)) {
      base <- sub("_color$", "", col_name)
      if (base %in% available_cols) return(base)
    }
    ""
  }

  .strip_metadata_color_mirror_columns <- function(sobj) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(sobj)
    md <- tryCatch(sobj@meta.data, error = function(e) NULL)
    if (is.null(md) || !is.data.frame(md) || !ncol(md)) return(sobj)
    all_cols <- colnames(md)
    drop_cols <- all_cols[vapply(all_cols, .is_metadata_color_mirror_column, logical(1), all_col_names = all_cols)]
    if (!length(drop_cols)) return(sobj)
    sobj@meta.data <- md[, setdiff(all_cols, drop_cols), drop = FALSE]
    sobj
  }

  .write_metadata_level_colors <- function(sobj, col_name, color_map) {
    if (is.null(sobj) || !inherits(sobj, "Seurat") || !is.list(color_map) || !length(color_map)) return(sobj)
    misc <- tryCatch(sobj@misc, error = function(e) list())
    if (!is.list(misc$metadata_level_colors)) misc$metadata_level_colors <- list()

    clean_map <- lapply(color_map, function(v) {
      vv <- toupper(.scalar_chr(v, default = ""))
      if (.is_hex_color(vv)) vv else NULL
    })
    clean_map <- clean_map[!vapply(clean_map, is.null, logical(1))]
    misc$metadata_level_colors[[col_name]] <- clean_map
    sobj@misc <- misc
    .strip_metadata_color_mirror_columns(sobj)
  }

  .canonical_color_map <- function(x) {
    if (!is.list(x) || !length(x)) return(list())
    out <- lapply(x, function(v) {
      vv <- toupper(.scalar_chr(v, default = ""))
      if (.is_hex_color(vv)) vv else NULL
    })
    out <- out[!vapply(out, is.null, logical(1))]
    if (!length(out)) return(list())
    out[order(names(out), method = "radix")]
  }

  .persist_active_object <- function(sobj, update_local = TRUE) {
    nm <- .recluster_new_canonical_object_name()
    if (!nzchar(nm) || is.null(sobj) || !inherits(sobj, "Seurat")) return(invisible(NULL))
    entry <- shared_data$all_seurat_objects[[nm]]
    if (is.list(entry) && !is.null(entry$obj)) {
      entry$obj <- sobj
    } else {
      entry <- sobj
    }
    shared_data$all_seurat_objects[[nm]] <- entry
    if (isTRUE(update_local)) recluster_new_data$seurat_obj <- sobj
    invisible(NULL)
  }

  .sync_metadata_profiles_from_object <- function(obj) {
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))
    obj <- .strip_metadata_color_mirror_columns(obj)
    md <- obj@meta.data
    available_cols <- colnames(md)[vapply(md, .is_supported_meta_column, logical(1))]
    available_cols <- available_cols[!is.na(available_cols) & nzchar(available_cols)]
    available_cols <- .filter_browser_metadata_columns(available_cols)
    profiles <- lapply(available_cols, function(nm) .build_metadata_profile(nm, md[[nm]]))
    names(profiles) <- available_cols

    plot_df <- data.frame(row.names = colnames(obj))
    if (length(available_cols) > 0) {
      plot_df <- cbind(plot_df, md[, available_cols, drop = FALSE])
    }
    recluster_new_data$plot_df <- plot_df
    recluster_new_data$metadata_profiles <- profiles
    recluster_new_data$seurat_obj <- obj
    invisible(profiles)
  }

  .refresh_metadata_after_object_update <- function(obj, open_col = NULL) {
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))
    profiles <- .sync_metadata_profiles_from_object(obj)
    available_cols <- names(profiles %||% list())

    target_col <- .resolve_metadata_browser_column(.scalar_chr(open_col, default = ""), available_cols)
    if (!nzchar(target_col)) {
      target_col <- .resolve_metadata_browser_column(.scalar_chr(recluster_new_data$metadata_open_column, default = ""), available_cols)
    }
    if (!nzchar(target_col) || !(target_col %in% available_cols)) {
      target_col <- if (length(available_cols)) available_cols[[1]] else ""
    }
    bucket_now <- if (nzchar(target_col) && !is.null(profiles[[target_col]])) .scalar_chr(profiles[[target_col]]$bucket, default = "categorical") else "cluster"

    open_col_now <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    bucket_now_stored <- .scalar_chr(recluster_new_data$metadata_open_bucket, default = "")
    if (!identical(open_col_now, target_col)) {
      recluster_new_data$metadata_open_column <- target_col
    }
    if (!identical(bucket_now_stored, bucket_now)) {
      recluster_new_data$metadata_open_bucket <- bucket_now
    }
    if (nzchar(target_col)) {
      if (!identical(.scalar_chr(recluster_new_data$metadata_active_column, default = ""), target_col)) {
        recluster_new_data$metadata_active_column <- target_col
      }
      .set_umap_color_choice(target_col, choices = c("Single Gene Expression", available_cols, "None"))
      updateSelectInput(session, "recluster_new_pb_meta_col", choices = available_cols, selected = target_col)
      updateSelectInput(session, "recluster_new_rule_color_by_select", choices = c("Single Gene Expression", available_cols, "None"), selected = target_col)
      updateSelectInput(session, "recluster_new_scatter_color_by", choices = c("None", available_cols), selected = target_col)
    }
    invisible(NULL)
  }

  .pb_store_get <- function(sobj) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(list())
    misc <- tryCatch(sobj@misc, error = function(e) list())
    ana <- tryCatch(misc$analysis, error = function(e) NULL)
    if (!is.list(ana)) return(list())
    pb <- tryCatch(ana$pseudobulk, error = function(e) NULL)
    if (!is.list(pb)) return(list())
    pb
  }

  .pb_store_set <- function(sobj, pb_store) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(sobj)
    misc <- tryCatch(sobj@misc, error = function(e) list())
    if (!is.list(misc$analysis)) misc$analysis <- list()
    misc$analysis$pseudobulk <- pb_store
    sobj@misc <- misc
    sobj
  }

  .pb_level_key <- function(level_a, level_b = NULL, mode = "level_vs_level") {
    if (identical(mode, "level_vs_rest")) {
      return(sprintf("A=%s__REST", .safe_key(level_a)))
    }
    sprintf("A=%s__B=%s", .safe_key(level_a), .safe_key(level_b))
  }

  .resolved_mode <- function(profile, mode_input) {
    mode_input <- .scalar_chr(mode_input, default = profile$default_mode %||% "category")
    if (!isTRUE(profile$numeric_like)) return("category")
    if (identical(mode_input, "category")) return("category")
    if (identical(mode_input, "range")) return("range")
    profile$default_mode
  }

  .umap_gene_selection <- function() {
    stored <- as.character(recluster_new_data$umap_gene_values %||% c("", "", ""))
    length(stored) <- 3L
    stored[is.na(stored)] <- ""
    g1 <- trimws(.scalar_chr(stored[[1]], default = ""))
    g2 <- trimws(.scalar_chr(stored[[2]], default = ""))
    g3 <- trimws(.scalar_chr(stored[[3]], default = ""))
    channels <- c(g1, g2, g3)
    genes <- channels
    genes <- genes[!is.na(genes) & nzchar(genes)]
    list(
      channels = channels,
      genes = unique(genes),
      multi = length(unique(genes)) > 1L
    )
  }

  .active_umap_metadata_col <- function() {
    profiles <- recluster_new_data$metadata_profiles %||% list()
    available_cols <- names(profiles)
    if (!length(available_cols)) return("None")

    # Agent note: Color UMAP selector is canonical for rendering; open/active metadata cards are fallback state only.
    selected_choice <- .scalar_chr(recluster_new_data$umap_color_choice, default = "")
    if (identical(selected_choice, "None")) return("None")
    selected_col <- .resolve_metadata_browser_column(selected_choice, available_cols)
    if (nzchar(selected_col)) return(selected_col)

    open_col <- .resolve_metadata_browser_column(.scalar_chr(recluster_new_data$metadata_open_column, default = ""), available_cols)
    if (nzchar(open_col)) return(open_col)

    active_col <- .resolve_metadata_browser_column(.scalar_chr(recluster_new_data$metadata_active_column, default = ""), available_cols)
    if (nzchar(active_col)) return(active_col)

    if ("seurat_clusters" %in% available_cols) return("seurat_clusters")
    if ("orig.ident" %in% available_cols) return("orig.ident")
    available_cols[[1]]
  }

  .set_umap_gene_value <- function(index, value) {
    vals <- as.character(recluster_new_data$umap_gene_values %||% c("", "", ""))
    length(vals) <- 3L
    vals[is.na(vals)] <- ""
    vals[[index]] <- trimws(.scalar_chr(value, default = ""))
    recluster_new_data$umap_gene_values <- vals
    invisible(vals)
  }

  .set_umap_color_choice <- function(choice, choices = NULL) {
    ch <- .scalar_chr(choice, default = "")
    if (!nzchar(ch)) return(invisible(NULL))
    if (length(choices) && !(ch %in% choices)) return(invisible(NULL))
    cur <- .scalar_chr(recluster_new_data$umap_color_choice, default = "")
    if (identical(cur, ch) && !length(choices)) return(invisible(ch))
    .db_dbg("set_color", sprintf("cur=%s next=%s", cur, ch))
    recluster_new_data$umap_color_choice <- ch
    recluster_new_data$pending_umap_color_choice <- ch
    recluster_new_data$umap_control_syncing <- TRUE
    on.exit({
      recluster_new_data$umap_control_syncing <- FALSE
    }, add = TRUE)
    updateSelectInput(session, "recluster_new_color_by_select", choices = choices %||% NULL, selected = ch)
    invisible(ch)
  }


  .sync_assay_gene_inputs <- function(force = FALSE) {
    .db_dbg("sync_assay_gene_inputs", sprintf("force=%s", as.character(force)))
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))

    assay_choices <- .safe_assay_choices(obj)
    if (!length(assay_choices)) return(invisible(NULL))

    assay_now <- .scalar_chr(input$recluster_new_assay_select, default = "")
    assay_target <- if (nzchar(assay_now) && assay_now %in% assay_choices) assay_now else assay_choices[[1]]
    if (isTRUE(force)) {
      forced_target <- .scalar_chr(recluster_new_data$umap_assay_choice, default = "")
      if (nzchar(forced_target) && forced_target %in% assay_choices) assay_target <- forced_target
    }
    recluster_new_data$umap_assay_choice <- assay_target
    if (!identical(assay_now, assay_target)) {
      .update_control_select("recluster_new_assay_select", choices = assay_choices, selected = assay_target)
    } else if (isTRUE(force)) {
      .update_control_select("recluster_new_assay_select", choices = assay_choices, selected = assay_target)
    }

    all_genes <- .assay_feature_names(obj, assay_target)
    if (length(all_genes)) {
      recluster_new_data$umap_control_syncing <- TRUE
      on.exit({
        recluster_new_data$umap_control_syncing <- FALSE
      }, add = TRUE)
      stored_umap_genes <- as.character(recluster_new_data$umap_gene_values %||% c("", "", ""))
      length(stored_umap_genes) <- 3L
      stored_umap_genes[is.na(stored_umap_genes)] <- ""
      gene_now <- .scalar_chr(stored_umap_genes[[1]], default = "")
      gene2_now <- .scalar_chr(stored_umap_genes[[2]], default = "")
      gene3_now <- .scalar_chr(stored_umap_genes[[3]], default = "")
      gene_target <- if (nzchar(gene_now) && gene_now %in% all_genes) gene_now else character(0)
      gene2_target <- if (nzchar(gene2_now) && gene2_now %in% all_genes) gene2_now else character(0)
      gene3_target <- if (nzchar(gene3_now) && gene3_now %in% all_genes) gene3_now else character(0)
      recluster_new_data$umap_gene_values <- c(
        .scalar_chr(gene_target, default = ""),
        .scalar_chr(gene2_target, default = ""),
        .scalar_chr(gene3_target, default = "")
      )
      if (isTRUE(force) || !identical(gene_now, gene_target)) {
        wl_update_gene_selectize(session, "recluster_new_gene_expr_select_1", all_genes, selected = gene_target)
      }
      if (isTRUE(force) || !identical(gene2_now, gene2_target)) {
        wl_update_gene_selectize(session, "recluster_new_gene_expr_select_2", all_genes, selected = gene2_target)
      }
      if (isTRUE(force) || !identical(gene3_now, gene3_target)) {
        wl_update_gene_selectize(session, "recluster_new_gene_expr_select_3", all_genes, selected = gene3_target)
      }
    }

    scatter_x_now <- .scalar_chr(input$recluster_new_scatter_gene_x, default = "")
    scatter_y_now <- .scalar_chr(input$recluster_new_scatter_gene_y, default = "")
    scatter_x_target <- if (nzchar(scatter_x_now) && scatter_x_now %in% all_genes) scatter_x_now else if (length(all_genes)) all_genes[[1]] else character(0)
    scatter_y_target <- if (nzchar(scatter_y_now) && scatter_y_now %in% all_genes) scatter_y_now else if (length(all_genes) >= 2) all_genes[[2]] else scatter_x_target
    if (isTRUE(force) || !identical(scatter_x_now, scatter_x_target)) {
      wl_update_gene_selectize(session, "recluster_new_scatter_gene_x", all_genes, selected = scatter_x_target)
    }
    if (isTRUE(force) || !identical(scatter_y_now, scatter_y_target)) {
      wl_update_gene_selectize(session, "recluster_new_scatter_gene_y", all_genes, selected = scatter_y_target)
    }
    invisible(NULL)
  }

  .sync_rule_assay_gene_inputs <- function(force = FALSE) {
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))

    assay_choices <- .safe_assay_choices(obj)
    if (!length(assay_choices)) return(invisible(NULL))

    assay_now <- .scalar_chr(input$recluster_new_rule_assay_select, default = "")
    assay_target <- if (nzchar(assay_now) && assay_now %in% assay_choices) assay_now else assay_choices[[1]]
    if (isTRUE(force)) {
      forced_target <- .scalar_chr(recluster_new_data$rule_assay_choice, default = "")
      if (nzchar(forced_target) && forced_target %in% assay_choices) assay_target <- forced_target
    }
    recluster_new_data$rule_assay_choice <- assay_target
    if (!identical(assay_now, assay_target)) {
      .update_control_select("recluster_new_rule_assay_select", choices = assay_choices, selected = assay_target)
    } else if (isTRUE(force)) {
      .update_control_select("recluster_new_rule_assay_select", choices = assay_choices, selected = assay_target)
    }

    all_genes <- .assay_feature_names(obj, assay_target)
    if (length(all_genes)) {
      gene_now <- .scalar_chr(input$recluster_new_rule_gene_expr_select_1, default = "")
      gene_target <- if (nzchar(gene_now) && gene_now %in% all_genes) gene_now else character(0)
      if (isTRUE(force) || !identical(gene_now, gene_target)) {
        wl_update_gene_selectize(session, "recluster_new_rule_gene_expr_select_1", all_genes, selected = gene_target)
      }
    }

    scatter_x_now <- .scalar_chr(input$recluster_new_rule_scatter_gene_x, default = "")
    scatter_y_now <- .scalar_chr(input$recluster_new_rule_scatter_gene_y, default = "")
    scatter_x_target <- if (nzchar(scatter_x_now) && scatter_x_now %in% all_genes) scatter_x_now else if (length(all_genes)) all_genes[[1]] else character(0)
    scatter_y_target <- if (nzchar(scatter_y_now) && scatter_y_now %in% all_genes) scatter_y_now else if (length(all_genes) >= 2) all_genes[[2]] else scatter_x_target
    if (isTRUE(force) || !identical(scatter_x_now, scatter_x_target)) {
      wl_update_gene_selectize(session, "recluster_new_rule_scatter_gene_x", all_genes, selected = scatter_x_target)
    }
    if (isTRUE(force) || !identical(scatter_y_now, scatter_y_target)) {
      wl_update_gene_selectize(session, "recluster_new_rule_scatter_gene_y", all_genes, selected = scatter_y_target)
    }
    invisible(NULL)
  }

  recluster_new_dataset_syncing <- reactiveVal(FALSE)
  recluster_new_loaded_object_name <- reactiveVal("")
  recluster_new_object_loading <- reactiveVal(FALSE)
  recluster_new_page_activating <- reactiveVal(FALSE)
  umap_plot_rendered <- reactiveVal(NULL)
  violin_plot_rendered <- reactiveVal(NULL)

  .recluster_new_on_page <- function() {
    .db_tab_is_active()
  }

  .recluster_new_canonical_object_name <- function() {
    loaded <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (isTRUE(.recluster_new_on_page()) && nzchar(loaded)) return(loaded)
    .scalar_chr(shared_data$active_object_name, default = "")
  }

  .final_plot_df_signature <- function() {
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return("")
    umap_gene_info <- .umap_gene_selection()
    universe <- rownames(recluster_new_data$plot_df %||% data.frame())
    paste(
      .scalar_chr(recluster_new_loaded_object_name(), default = ""),        # part 1: loaded_object_name
      .current_umap_reduction(obj),                                          # part 2: reduction
      .scalar_chr(input$recluster_new_umap_axis_x_select, default = ""),    # part 3: x_axis
      .scalar_chr(input$recluster_new_umap_axis_y_select, default = ""),    # part 4: y_axis
      .current_umap_assay(obj),                                              # part 5: assay
      .scalar_chr(input$recluster_new_slot_select, default = ""),           # part 6: slot
      .scalar_chr(recluster_new_data$umap_display_mode, default = ""),      # part 7: display_mode
      .scalar_chr(recluster_new_data$umap_color_choice, default = ""),      # part 8: color_choice
      paste(as.character(umap_gene_info$genes %||% character(0)), collapse = "|"), # part 9: gene_list
      .cell_set_signature(.visible_umap_cells(), universe),                  # part 10: visible_cells_sig
      .cell_set_signature(all_selected_cells(), universe),                   # part 11: all_selected_cells_sig
      # Agent note: Orange outline follows active gene independently from the
      # combined selection; active-gene changes must invalidate both plot caches.
      .cell_set_signature(expression_active_gene_result()$cells, universe),  # part 12: active_gene_cells_sig
      sep = "::"
    )
  }

  .clear_final_plot_cache <- function() {
    recluster_new_data$final_plot_cache_sig <- ""
    recluster_new_data$final_plot_cache <- NULL
    recluster_new_data$umap_plot_cache_sig <- ""
    recluster_new_data$umap_plot_cache <- NULL
    recluster_new_data$violin_plot_cache_sig <- ""
    recluster_new_data$violin_plot_cache <- NULL
    invisible(NULL)
  }

  .umap_plot_color_map_signature <- function() {
    # The tick is the reactive dependency; object/color reads below are isolated.
    # Keep the serialized map canonical so unchanged colors do not rebuild Plotly.
    recluster_new_data$umap_color_tick
    obj <- isolate(recluster_new_data$seurat_obj)  # isolated: color writes do NOT trigger re-render
    if (is.null(obj) || !inherits(obj, "Seurat")) return("")
    display_mode <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
    umap_gene_info <- .umap_gene_selection()
    color_by <- if (identical(display_mode, "gene") && length(umap_gene_info$genes)) "Single Gene Expression" else .active_umap_metadata_col()
    if (!isTruthy(color_by) || identical(color_by, "None") || !(color_by %in% colnames(recluster_new_data$plot_df))) return("")
    if (!.metadata_color_as_discrete(color_by)) return("")
    vals <- recluster_new_data$plot_df[[color_by]]
    vals_chr <- as.character(vals %||% character(0))
    vals_chr[is.na(vals_chr) | !nzchar(vals_chr)] <- "(NA)"
    lv <- .sort_numeric_first(unique(vals_chr))
    pal <- .level_color_map(obj, color_by, lv)
    pal_names <- as.character(names(pal))
    pal <- toupper(as.character(pal))
    names(pal) <- pal_names
    pal <- pal[order(names(pal), method = "radix")]
    paste(names(pal), pal, sep = "=", collapse = "|")
  }

  .umap_plot_cache_signature <- function() {
    # Keep the heavy Plotly cache keyed to data and plot geometry only. Metadata
    # level colors can be echoed by restored browser controls while the sidebar is
    # rebinding; using that derived palette as a cache key creates a render loop.
    paste(
      .final_plot_df_signature(),                                                                          # parts 1-12 (see .final_plot_df_signature)
      .scalar_chr(input$recluster_new_split_by_select, default = ""),                                    # part 13: split_by
      as.character(suppressWarnings(as.numeric(input$recluster_new_dot_size %||% 1.0))),                  # part 14: dot_size
      as.character(suppressWarnings(as.numeric(input$recluster_new_dot_alpha %||% 0.8))),                 # part 15: dot_alpha
      as.character(suppressWarnings(as.numeric(input$recluster_new_stroke_width %||% 0.1))),              # part 16: stroke_width
      .scalar_chr(input$recluster_new_stroke_color, default = "black"),                                   # part 17: stroke_color
      sep = "::"
    )
  }

  .finalize_umap_plotly <- function(p) {
    p <- .plotly_touch_zoom(event_register(p, "plotly_selected"))
    cache_sig <- .umap_plot_cache_signature()
    if (nzchar(cache_sig)) {
      isolate({
        recluster_new_data$umap_plot_cache_sig <- cache_sig
        recluster_new_data$umap_plot_cache <- p
      })
    }
    p
  }

  .viz_controls_cache_sig <- function(obj, tab_key) {
    paste(
      .scalar_chr(recluster_new_loaded_object_name(), default = ""),
      .scalar_chr(tab_key, default = ""),
      paste(names(recluster_new_data$metadata_profiles %||% list()), collapse = "|"),
      paste(.safe_assay_choices(obj), collapse = "|"),
      paste(.embedding_reduction_choices(obj), collapse = "|"),
      sep = "::"
    )
  }

  .clear_viz_controls_cache <- function() {
    recluster_new_data$viz_controls_cache_sig <- ""
    recluster_new_data$viz_controls_cache <- NULL
    recluster_new_data$rule_viz_controls_cache_sig <- ""
    recluster_new_data$rule_viz_controls_cache <- NULL
    .clear_final_plot_cache()
    invisible(NULL)
  }

  .load_active_recluster_new_object <- function(active_name) {
    .clear_gene_value_cache()
    .clear_viz_controls_cache()
    active_name <- .scalar_chr(active_name, default = "")
    .db_dbg(
      "load_object_start",
      sprintf(
        "active=%s loaded_before=%s input_dataset=%s",
        active_name,
        .scalar_chr(recluster_new_loaded_object_name(), default = ""),
        .scalar_chr(isolate(input$recluster_new_dataset_select), default = "")
      )
    )
    if (!nzchar(active_name)) {
      recluster_new_data$seurat_obj <- NULL
      recluster_new_data$plot_df <- NULL
      recluster_new_data$cell_groups <- list()
      recluster_new_data$selected_cells <- character(0)
      recluster_new_data$imported_barcode_sources <- character(0)
      recluster_new_data$metadata_profiles <- list()
      recluster_new_data$metadata_active_column <- ""
      recluster_new_data$metadata_active_cells <- character(0)
      recluster_new_data$metadata_filter_state <- "all"
      recluster_new_data$expr_selection <- .expr_default_state()
      .expr_bound_inputs(character(0))
      recluster_new_data$rule_definitions <- list()
      recluster_new_data$rule_active_cells <- character(0)
      recluster_new_data$rule_overlap_group <- NULL
      recluster_new_data$rule_selected_group <- "All"
      recluster_new_data$rule_manual_combine_mode <- "union"
      recluster_new_data$debug_rule_overlap_state <- ""
      recluster_new_data$last_load_status <- "No active dataset is selected."
      recluster_new_loaded_object_name("")
      return(invisible(NULL))
    }
    entry <- shared_data$all_seurat_objects[[active_name]]
    obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (is.null(obj) || !inherits(obj, "Seurat")) {
      recluster_new_data$seurat_obj <- NULL
      recluster_new_data$plot_df <- NULL
      recluster_new_data$cell_groups <- list()
      recluster_new_data$selected_cells <- character(0)
      recluster_new_data$imported_barcode_sources <- character(0)
      recluster_new_data$metadata_profiles <- list()
      recluster_new_data$metadata_active_column <- ""
      recluster_new_data$metadata_active_cells <- character(0)
      recluster_new_data$metadata_filter_state <- "all"
      recluster_new_data$expr_selection <- .expr_default_state()
      .expr_bound_inputs(character(0))
      recluster_new_data$rule_definitions <- list()
      recluster_new_data$rule_active_cells <- character(0)
      recluster_new_data$rule_overlap_group <- NULL
      recluster_new_data$rule_selected_group <- "All"
      recluster_new_data$rule_manual_combine_mode <- "union"
      recluster_new_data$debug_rule_overlap_state <- ""
      recluster_new_data$last_load_status <- sprintf("Active object '%s' is not a valid Seurat object.", active_name)
      recluster_new_loaded_object_name("")
      return(invisible(NULL))
    }
    reduction_choices <- .embedding_reduction_choices(obj)
    if (!length(reduction_choices)) {
      recluster_new_data$seurat_obj <- NULL
      recluster_new_data$plot_df <- NULL
      recluster_new_data$cell_groups <- list()
      recluster_new_data$selected_cells <- character(0)
      recluster_new_data$imported_barcode_sources <- character(0)
      recluster_new_data$metadata_profiles <- list()
      recluster_new_data$metadata_active_column <- ""
      recluster_new_data$metadata_active_cells <- character(0)
      recluster_new_data$metadata_filter_state <- "all"
      recluster_new_data$expr_selection <- .expr_default_state()
      .expr_bound_inputs(character(0))
      recluster_new_data$rule_definitions <- list()
      recluster_new_data$rule_active_cells <- character(0)
      recluster_new_data$rule_overlap_group <- NULL
      recluster_new_data$rule_selected_group <- "All"
      recluster_new_data$rule_manual_combine_mode <- "union"
      recluster_new_data$debug_rule_overlap_state <- ""
      recluster_new_data$last_load_status <- sprintf(
        "Active object '%s' has no reduction with at least 2 dimensions. Run Analysis embedding first, then reopen this page.",
        active_name
      )
      recluster_new_loaded_object_name("")
      return(invisible(NULL))
    }

    plot_df <- data.frame(row.names = colnames(obj))

    assay_choices <- .safe_assay_choices(obj)
    assay_to_use <- .preferred_assay_choice(obj)
    all_genes <- if (nzchar(assay_to_use)) .assay_feature_names(obj, assay_to_use) else character(0)

    md_ncol_before <- ncol(obj@meta.data)
    obj <- .strip_metadata_color_mirror_columns(obj)
    md <- obj@meta.data
    available_cols <- colnames(md)[vapply(md, .is_supported_meta_column, logical(1))]
    available_cols <- available_cols[!is.na(available_cols) & nzchar(available_cols)]
    available_cols <- .filter_browser_metadata_columns(available_cols)
    if (length(available_cols) > 0) {
      plot_df <- cbind(plot_df, md[, available_cols, drop = FALSE])
    }

    profiles <- lapply(available_cols, function(nm) .build_metadata_profile(nm, md[[nm]]))
    names(profiles) <- available_cols
    bucket_map <- vapply(profiles, function(p) .scalar_chr(p$bucket, default = "categorical"), character(1))
    cluster_cols <- names(bucket_map)[bucket_map == "cluster"]
    default_open_col <- if (length(cluster_cols)) cluster_cols[[1]] else if (length(available_cols)) available_cols[[1]] else ""

    recluster_new_data$seurat_obj <- obj
    if (ncol(md) < md_ncol_before) .persist_active_object(obj)
    recluster_new_data$plot_df <- plot_df
    recluster_new_data$cell_groups <- list()
    recluster_new_data$selected_cells <- character(0)
    recluster_new_data$imported_barcode_sources <- character(0)
    recluster_new_data$metadata_profiles <- profiles
    recluster_new_data$metadata_active_column <- ""
    recluster_new_data$metadata_active_cells <- character(0)
    recluster_new_data$metadata_filter_state <- "all"
    recluster_new_data$metadata_open_column <- default_open_col
    recluster_new_data$metadata_open_bucket <- if (nzchar(default_open_col)) .scalar_chr(bucket_map[[default_open_col]], default = "cluster") else "cluster"
    recluster_new_data$expr_selection <- .expr_store_get(obj)
    .expr_bound_inputs(character(0))
    recluster_new_data$rule_definitions <- list()
    recluster_new_data$rule_active_cells <- character(0)
    recluster_new_data$rule_overlap_group <- NULL
    recluster_new_data$rule_selected_group <- "All"
    recluster_new_data$rule_manual_combine_mode <- "union"
    recluster_new_data$debug_rule_overlap_state <- ""
    recluster_new_data$last_load_status <- ""

    preferred_col <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    default_color <- if (nzchar(preferred_col) && preferred_col %in% available_cols) {
      preferred_col
    } else if ("seurat_clusters" %in% available_cols) {
      "seurat_clusters"
    } else if ("orig.ident" %in% available_cols) {
      "orig.ident"
    } else if (length(available_cols)) {
      available_cols[[1]]
    } else {
      "None"
    }

    split_choices <- colnames(md)[vapply(md, .is_reasonable_discrete, logical(1))]
    split_choices <- split_choices[!is.na(split_choices) & nzchar(split_choices)]
    default_scatter <- if ("seurat_clusters" %in% available_cols) "seurat_clusters" else if (length(available_cols)) available_cols[[1]] else "None"
    red_sel <- .preferred_embedding_reduction(obj, entry = entry)
    recluster_new_data$umap_assay_choice <- assay_to_use
    recluster_new_data$rule_assay_choice <- assay_to_use
    recluster_new_data$umap_reduction_choice <- red_sel
    recluster_new_data$rule_reduction_choice <- red_sel

    recluster_new_data$umap_control_syncing <- TRUE
    on.exit({
      recluster_new_data$umap_control_syncing <- FALSE
    }, add = TRUE)

    slot_now <- .scalar_chr(input$recluster_new_slot_select, default = "data")
    if (!(slot_now %in% c("data", "counts", "scale.data"))) slot_now <- "data"
    gene_now <- .scalar_chr(input$recluster_new_gene_expr_select_1, default = "")
    gene2_now <- .scalar_chr(input$recluster_new_gene_expr_select_2, default = "")
    gene3_now <- .scalar_chr(input$recluster_new_gene_expr_select_3, default = "")

    .update_control_select("recluster_new_assay_select", choices = assay_choices, selected = if (nzchar(assay_to_use)) assay_to_use else character(0))
    updateSelectInput(session, "recluster_new_slot_select", choices = c("data", "counts", "scale.data"), selected = slot_now)
    updateCheckboxInput(session, "recluster_new_expr_limit_population", value = isTRUE(recluster_new_data$expr_selection$inherit_population %||% TRUE))
    recluster_new_data$umap_display_mode <- "metadata"
    updateRadioButtons(session, "recluster_new_umap_display_mode", selected = "metadata")
    recluster_new_data$umap_color_choice <- default_color
    .set_umap_color_choice(default_color, choices = c("Single Gene Expression", available_cols, "None"))
    updateSelectInput(session, "recluster_new_split_by_select", choices = c("None", split_choices))
    updateSelectInput(session, "recluster_new_scatter_color_by", choices = c("None", available_cols), selected = default_scatter)
    updateSelectInput(session, "recluster_new_rule_color_by_select", choices = c("Single Gene Expression", available_cols, "None"), selected = default_color)
    updateSelectInput(session, "recluster_new_rule_split_by_select", choices = c("None", split_choices))
    updateSelectInput(session, "recluster_new_rule_scatter_color_by", choices = c("None", available_cols), selected = default_scatter)
    axis_choices <- .axis_index_choices(obj, red_sel)
    axis_vals <- as.character(axis_choices)
    x_sel <- if (length(axis_vals)) axis_vals[[1]] else "1"
    y_sel <- if (length(axis_vals) >= 2L) axis_vals[[2]] else x_sel
    reduction_choice_labels <- vapply(reduction_choices, function(red) .reduction_display_label(obj, red), character(1))
    .update_control_select("recluster_new_umap_reduction_select", choices = stats::setNames(reduction_choices, reduction_choice_labels), selected = red_sel)
    updateSelectInput(session, "recluster_new_umap_axis_x_select", choices = axis_choices, selected = x_sel)
    updateSelectInput(session, "recluster_new_umap_axis_y_select", choices = axis_choices, selected = y_sel)
    .update_control_select("recluster_new_rule_umap_reduction_select", choices = stats::setNames(reduction_choices, reduction_choice_labels), selected = red_sel)
    updateSelectInput(session, "recluster_new_rule_umap_axis_x_select", choices = axis_choices, selected = x_sel)
    updateSelectInput(session, "recluster_new_rule_umap_axis_y_select", choices = axis_choices, selected = y_sel)
    updateSelectInput(session, "recluster_new_rule_slot_select", choices = c("data", "counts", "scale.data"), selected = slot_now)

    wl_update_gene_selectize(
      session,
      "recluster_new_gene_expr_select_1",
      all_genes,
      selected = if (nzchar(gene_now) && gene_now %in% all_genes) gene_now else character(0)
    )
    wl_update_gene_selectize(
      session,
      "recluster_new_gene_expr_select_2",
      all_genes,
      selected = if (nzchar(gene2_now) && gene2_now %in% all_genes) gene2_now else character(0)
    )
    wl_update_gene_selectize(
      session,
      "recluster_new_gene_expr_select_3",
      all_genes,
      selected = if (nzchar(gene3_now) && gene3_now %in% all_genes) gene3_now else character(0)
    )

    scatter_x_now <- .scalar_chr(input$recluster_new_scatter_gene_x, default = "")
    scatter_y_now <- .scalar_chr(input$recluster_new_scatter_gene_y, default = "")
    default_scatter_x <- if (nzchar(scatter_x_now) && scatter_x_now %in% all_genes) {
      scatter_x_now
    } else if (length(all_genes) >= 1) {
      all_genes[[1]]
    } else {
      character(0)
    }
    default_scatter_y <- if (nzchar(scatter_y_now) && scatter_y_now %in% all_genes) {
      scatter_y_now
    } else if (length(all_genes) >= 2) {
      all_genes[[2]]
    } else {
      default_scatter_x
    }
    wl_update_gene_selectize(session, "recluster_new_scatter_gene_x", all_genes, selected = default_scatter_x)
    wl_update_gene_selectize(session, "recluster_new_scatter_gene_y", all_genes, selected = default_scatter_y)
    recluster_new_loaded_object_name(active_name)
    .db_dbg(
      "load_object_done",
      sprintf(
        "active=%s reductions=%d metadata_cols=%d assay=%s slot=%s red=%s",
        active_name,
        length(reduction_choices),
        length(available_cols),
        assay_to_use,
        slot_now,
        red_sel
      )
    )
    invisible(NULL)
  }

  output$recluster_new_expression_groups_ui <- renderUI({
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    groups <- state$groups %||% list()
    if (!length(groups)) {
      return(tagList(
        div(class = "app-secondary-status", RECLUSTER_NEW_UI_TEXT$t_text_expr_no_groups),
        div(class = "recluster-new-expr-range app-secondary-status", RECLUSTER_NEW_UI_TEXT$t_text_expr_select_gene_range)
      ))
    }

    obj_now <- recluster_new_data$seurat_obj
    expr_base_cells <- if (!is.null(obj_now) && inherits(obj_now, "Seurat")) {
      if (isTRUE(state$inherit_population)) .expr_base_population_cells() else colnames(obj_now)
    } else {
      character(0)
    }

    active_gid <- .scalar_chr(state$active_group_id, default = "")
    group_nodes <- lapply(groups, function(g) {
      gid <- .scalar_chr(g$id, default = "")
      genes <- g$genes %||% list()
      checked_n <- sum(vapply(genes, function(gr) isTRUE(gr$checked), logical(1)))
      group_cells <- as.character((expression_group_cells_result()$group_cells %||% list())[[gid]] %||% character(0))
      summary_txt <- if (length(genes)) {
        sprintf("%d genes, %d cells", checked_n, length(group_cells))
      } else {
        RECLUSTER_NEW_UI_TEXT$t_text_expr_group_summary_empty
      }
      gene_nodes <- if (!length(genes)) {
        div(class = "app-secondary-status recluster-new-expr-no-genes", RECLUSTER_NEW_UI_TEXT$t_text_expr_no_genes)
      } else {
        lapply(genes, function(gr) {
          gene_id <- .scalar_chr(gr$id, default = "")
          gene_name <- .scalar_chr(gr$gene, default = "")
          active <- identical(.scalar_chr(g$active_gene_id, default = ""), gene_id)
          gene_cells <- .expr_gene_cells(gr, expr_base_cells, obj = obj_now)
          gene_count_txt <- sprintf("%d cells", length(gene_cells))
          div(
            class = paste("recluster-new-expr-gene-row", if (active) "is-active" else ""),
            `data-expr-active-id` = .expr_gene_active_input_id(gid, gene_id),
            div(
              class = "recluster-new-expr-gene-check",
              checkboxInput(.expr_gene_check_input_id(gid, gene_id), label = NULL, value = isTRUE(gr$checked), width = "18px")
            ),
            div(
              class = "recluster-new-expr-gene-main",
              div(
                class = "recluster-new-expr-gene-title-row",
                div(class = "recluster-new-expr-gene-name", title = gene_name, gene_name),
                div(class = "recluster-new-expr-gene-count", gene_count_txt)
              ),
              div(class = "recluster-new-expr-gene-note", .expr_format_range(gr$range))
            ),
            div(
              class = "recluster-new-expr-gene-actions",
              if (active) {
                tags$button(
                  type = "button",
                  class = "btn btn-xs recluster-new-expr-gene-clear",
                  `data-expr-active-id` = .expr_gene_active_input_id(gid, gene_id),
                  title = "Clear active gene highlight",
                  `aria-label` = sprintf("Clear %s active gene highlight", gene_name),
                  icon("times")
                )
              },
              actionButton(.expr_gene_delete_input_id(gid, gene_id), label = NULL, icon = icon("trash"), class = "btn btn-outline-danger btn-xs")
            )
          )
        })
      }
      tags$details(
        class = paste(
          "recluster-new-expr-group app-accordion",
          if (nzchar(active_gid) && identical(gid, active_gid)) "is-violet-highlight-source" else ""
        ),
        `data-accordion-group` = "recluster-new-expr-groups",
        open = if (isTRUE(g$open)) NA else NULL,
        ontoggle = sprintf(
          paste0(
            "if(event && event.isTrusted){",
            "Shiny.setInputValue('recluster_new_expr_open_group',",
            "{group_id:%s,open:this.open,nonce:Date.now()},",
            "{priority:'event'});}"
          ),
          jsonlite::toJSON(gid, auto_unbox = TRUE)
        ),
                tags$summary(
                  span(
                    class = "recluster-new-expr-group-title",
                    title = "Click to open group",
                    .scalar_chr(g$name, default = "Expression group")
                  ),
                  span(class = "recluster-new-expr-group-summary", summary_txt),
                  div(
                    class = "recluster-new-expr-group-actions",
                    tags$button(
                      type = "button",
                      id = .expr_group_rename_input_id(gid),
                      class = "btn recluster-new-expr-group-rename",
                      `data-expr-rename-group-id` = gid,
                      title = "Rename group",
                      `aria-label` = "Rename group",
                      icon("pencil")
                    ),
                    actionButton(
                      .expr_group_delete_input_id(gid),
                      label = NULL,
                      icon = icon("trash"),
                      class = "btn recluster-new-expr-group-delete"
                    )
                  )
                ),
        div(
          class = "recluster-new-expr-group-body",
          checkboxInput(.expr_group_require_all_input_id(gid), RECLUSTER_NEW_UI_TEXT$t_label_expr_require_all, value = isTRUE(g$require_all), width = "100%"),
          checkboxInput(.expr_group_invert_input_id(gid), RECLUSTER_NEW_UI_TEXT$t_label_expr_invert_group, value = isTRUE(g$invert), width = "100%"),
          div(
            class = "recluster-new-expr-select-all",
            checkboxInput(
              .expr_group_select_all_input_id(gid),
              RECLUSTER_NEW_UI_TEXT$t_label_expr_select_all_genes,
              value = length(genes) > 0 && checked_n == length(genes),
              width = "100%"
            )
          ),
          div(class = "recluster-new-expr-gene-list", gene_nodes),
          div(
            class = "recluster-new-expr-add-gene",
            wl_gene_selectize_input(.expr_group_add_gene_input_id(gid), RECLUSTER_NEW_UI_TEXT$t_label_expr_add_gene, selected = character(0), placeholder = "Type to search gene", width = "100%")
          )
        )
      )
    })

    obj_now <- recluster_new_data$seurat_obj
    assay_now <- .scalar_chr(input$recluster_new_assay_select, default = "")
    genes_now <- if (!is.null(obj_now) && inherits(obj_now, "Seurat")) .assay_feature_names(obj_now, assay_now) else character(0)
    add_ids <- vapply(groups, function(g) .expr_group_add_gene_input_id(.scalar_chr(g$id, default = "")), character(1))
    add_ids <- add_ids[nzchar(add_ids)]
    if (length(genes_now) && length(add_ids)) {
      session$onFlushed(function() {
        for (id in add_ids) {
          wl_update_gene_selectize(session, id, genes_now, selected = character(0))
        }
      }, once = TRUE)
    }

    tagList(group_nodes, uiOutput("recluster_new_expr_active_range_ui"))
  })

  output$recluster_new_expr_active_range_ui <- renderUI({
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    active <- .expr_active_gene(state)
    if (is.null(active)) {
      return(div(class = "recluster-new-expr-range app-secondary-status", RECLUSTER_NEW_UI_TEXT$t_text_expr_select_gene_range))
    }
    obj <- recluster_new_data$seurat_obj
    req(obj)
    assay_now <- .scalar_chr(input$recluster_new_assay_select, default = "")
    slot_now <- .expr_selection_slot()
    vals <- .fetch_gene_values(obj, assay_now, active$gene, slot_now)
    if (is.null(vals) || !length(vals)) {
      return(div(class = "recluster-new-expr-range app-secondary-status", RECLUSTER_NEW_UI_TEXT$t_text_expr_range_unavailable))
    }
    range_info <- .expr_expression_range_info(vals)
    if (is.null(range_info)) {
      return(div(class = "recluster-new-expr-range app-secondary-status", RECLUSTER_NEW_UI_TEXT$t_text_expr_range_unavailable))
    }
    full_rng <- range_info$full_range
    cur <- suppressWarnings(as.numeric(active$range %||% range_info$default_range))
    if (length(cur) != 2L || any(!is.finite(cur))) cur <- range_info$default_range
    cur[[1]] <- max(full_rng[[1]], min(cur[[1]], full_rng[[2]]))
    cur[[2]] <- max(cur[[1]], min(cur[[2]], full_rng[[2]]))
    div(
      class = "recluster-new-expr-range",
      sliderInput(
        "recluster_new_expr_active_range",
        sprintf("%s expression range", active$gene),
        min = full_rng[[1]],
        max = full_rng[[2]],
        value = cur,
        step = signif((full_rng[[2]] - full_rng[[1]]) / 200, 3)
      ),
      if (is.finite(range_info$min_nonzero)) {
        div(
          class = "recluster-new-expr-range-hint",
          sprintf("minimum non-zero: %s", signif(range_info$min_nonzero, 4))
        )
      }
    )
  })

  observeEvent(input$recluster_new_expr_limit_population, {
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    inherit_population <- isTRUE(input$recluster_new_expr_limit_population)
    if (identical(isTRUE(state$inherit_population), inherit_population)) {
      return(invisible(NULL))
    }
    state$inherit_population <- inherit_population
    .expr_set_state(state)
  }, ignoreInit = TRUE)

  .show_expr_group_name_modal <- function(title, value = "", placeholder = "") {
    showModal(modalDialog(
      title = title,
      textInput(
        "recluster_new_expr_group_name_edit",
        RECLUSTER_NEW_UI_TEXT$t_label_expr_group_name,
        value = value,
        placeholder = placeholder
      ),
      easyClose = FALSE,
      footer = tagList(
        tags$button(
          type = "button",
          id = "recluster_new_expr_group_name_cancel",
          class = "btn btn-default",
          "Cancel"
        ),
        tags$button(
          type = "button",
          id = "recluster_new_expr_group_name_save",
          class = "btn btn-primary",
          RECLUSTER_NEW_UI_TEXT$t_btn_expr_save_group_name
        )
      )
    ))
  }

  observeEvent(input$recluster_new_expr_add_group_btn, {
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    idx <- suppressWarnings(as.integer(state$next_group_index %||% 1L))
    if (!is.finite(idx) || is.na(idx) || idx < 1L) idx <- length(state$groups %||% list()) + 1L
    gid <- sprintf("g%03d", idx)
    default_name <- sprintf("Expression group %d", idx)
    session$userData$recluster_new_expr_group_name_context <- list(
      mode = "create",
      group_id = gid,
      index = idx,
      default_name = default_name
    )
    .show_expr_group_name_modal(
      title = RECLUSTER_NEW_UI_TEXT$t_btn_expr_add_group,
      placeholder = default_name
    )
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_expr_open_group, {
    request <- input$recluster_new_expr_open_group
    if (!is.list(request)) return(invisible(NULL))
    gid <- .safe_key(.scalar_chr(request$group_id, default = ""))
    if (!nzchar(gid)) return(invisible(NULL))
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    gi <- .expr_group_index(state, gid)
    if (is.na(gi)) return(invisible(NULL))
    # Agent note: Dynamic expression-group UI rebuilds must preserve user's
    # explicit details open/closed state; violet active state is independent.
    .db_dbg(
      "expr_open_group_event",
      sprintf("group=%s open=%s", gid, isTRUE(request$open))
    )
    if (isTRUE(request$open)) {
      state <- .expr_set_active_group(state, gid)
    } else {
      state$groups[[gi]]$open <- FALSE
    }
    .expr_set_state(state)
  }, ignoreInit = TRUE, priority = 1000)

  observeEvent(input$recluster_new_expr_active_range_commit, {
    if (isTRUE(input$recluster_new_expr_slider_dragging %||% FALSE)) return(invisible(NULL))
    rng <- suppressWarnings(as.numeric(input$recluster_new_expr_active_range_commit %||% numeric(0)))
    rng <- rng[is.finite(rng)]
    if (length(rng) < 2L) return(invisible(NULL))
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    active <- .expr_active_gene(state)
    if (is.null(active)) return(invisible(NULL))
    gi <- .expr_group_index(state, active$group_id)
    if (is.na(gi)) return(invisible(NULL))
    gene_i <- .expr_gene_index(state$groups[[gi]], active$gene_id)
    if (is.na(gene_i)) return(invisible(NULL))
    state$groups[[gi]]$genes[[gene_i]]$range <- sort(rng[seq_len(2L)])
    .expr_set_state(state)
  }, ignoreInit = TRUE)

  # Agent note: Group headers are native details toggles; keep rename separate.
  # Dynamic rename/create modal events need explicit context and nonces so every
  # group and repeated modal session remains deterministic.
  observeEvent(input$recluster_new_expr_group_rename, {
    request <- input$recluster_new_expr_group_rename
    if (!is.list(request)) return(invisible(NULL))
    gid <- .safe_key(.scalar_chr(request$group_id, default = ""))
    if (!nzchar(gid)) return(invisible(NULL))
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    gi <- .expr_group_index(state, gid)
    if (is.na(gi)) return(invisible(NULL))
    session$userData$recluster_new_expr_group_name_context <- list(
      mode = "rename",
      group_id = gid,
      default_name = sprintf("Expression group %d", gi)
    )
    .show_expr_group_name_modal(
      title = RECLUSTER_NEW_UI_TEXT$t_btn_expr_rename_group,
      value = .scalar_chr(state$groups[[gi]]$name, default = "")
    )
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_expr_group_name_save, {
    save_request <- input$recluster_new_expr_group_name_save
    if (!is.list(save_request)) return(invisible(NULL))
    context <- session$userData$recluster_new_expr_group_name_context
    if (!is.list(context)) return(invisible(NULL))
    mode <- .scalar_chr(context$mode, default = "")
    gid <- .safe_key(.scalar_chr(context$group_id, default = ""))
    if (!nzchar(gid)) return(invisible(NULL))
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    nm <- trimws(.scalar_chr(save_request$name, default = ""))
    default_name <- .scalar_chr(context$default_name, default = "Expression group")
    name_to_use <- if (nzchar(nm)) nm else default_name
    if (identical(mode, "create")) {
      idx <- suppressWarnings(as.integer(context$index))
      if (!is.finite(idx) || is.na(idx) || idx < 1L) return(invisible(NULL))
      if (!is.na(.expr_group_index(state, gid))) return(invisible(NULL))
      state$groups[[length(state$groups %||% list()) + 1L]] <- list(
        id = gid,
        name = name_to_use,
        open = FALSE,
        require_all = FALSE,
        invert = FALSE,
        active_gene_id = "",
        genes = list()
      )
      next_idx <- suppressWarnings(as.integer(state$next_group_index %||% 1L))
      if (!is.finite(next_idx) || is.na(next_idx) || next_idx < 1L) next_idx <- 1L
      state$next_group_index <- max(next_idx, idx + 1L)
      state <- .expr_set_active_group(state, gid)
    } else if (identical(mode, "rename")) {
      gi <- .expr_group_index(state, gid)
      if (is.na(gi)) return(invisible(NULL))
      state$groups[[gi]]$name <- name_to_use
    } else {
      return(invisible(NULL))
    }
    session$userData$recluster_new_expr_group_name_context <- NULL
    removeModal()
    .expr_set_state(state)
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_expr_group_name_cancel, {
    cancel_request <- input$recluster_new_expr_group_name_cancel
    if (!is.list(cancel_request)) return(invisible(NULL))
    session$userData$recluster_new_expr_group_name_context <- NULL
    removeModal()
  }, ignoreInit = TRUE)

  observe({
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    groups <- state$groups %||% list()
    all_genes <- character(0)
    obj <- recluster_new_data$seurat_obj
    if (!is.null(obj) && inherits(obj, "Seurat")) {
      assay_now <- .scalar_chr(input$recluster_new_assay_select, default = "")
      all_genes <- .assay_feature_names(obj, assay_now)
    }
    bound <- .expr_bound_inputs()
    next_bound <- bound
    for (g in groups) {
      gid <- .scalar_chr(g$id, default = "")
      if (!nzchar(gid)) next
      add_id <- .expr_group_add_gene_input_id(gid)
      if (length(all_genes)) {
        wl_update_gene_selectize(session, add_id, all_genes, selected = character(0))
      }
      input_ids <- c(
        .expr_group_open_input_id(gid),
        .expr_group_require_all_input_id(gid),
        .expr_group_invert_input_id(gid),
        .expr_group_delete_input_id(gid),
        .expr_group_select_all_input_id(gid),
        add_id
      )
      for (id in input_ids) {
        if (id %in% next_bound) next
        next_bound <- unique(c(next_bound, id))
        local({
          id_local <- id
          gid_local <- gid
          observeEvent(input[[id_local]], {
            state2 <- .expr_state_normalize(recluster_new_data$expr_selection)
            gi <- .expr_group_index(state2, gid_local)
            if (is.na(gi)) return(invisible(NULL))
            body_input <- id_local %in% c(
              .expr_group_require_all_input_id(gid_local),
              .expr_group_invert_input_id(gid_local),
              .expr_group_select_all_input_id(gid_local),
              .expr_group_add_gene_input_id(gid_local)
            )
            if (
              isTRUE(body_input) &&
              (
                !identical(.scalar_chr(state2$active_group_id, default = ""), gid_local) ||
                !isTRUE(state2$groups[[gi]]$open)
              )
            ) {
              # Agent note: Dynamic Shiny inputs emit value events again when
              # renderUI rebinds. Closed-group echoes must never steal active
              # expression ownership from the group the user just opened.
              .db_dbg(
                "expr_stale_group_input_ignored",
                sprintf("input=%s group=%s active=%s", id_local, gid_local, .scalar_chr(state2$active_group_id, default = ""))
              )
              return(invisible(NULL))
            }
            if (identical(id_local, .expr_group_open_input_id(gid_local))) {
              if (isTRUE(input[[id_local]])) {
                state2 <- .expr_set_active_group(state2, gid_local)
              }
            } else if (identical(id_local, .expr_group_require_all_input_id(gid_local))) {
              require_all <- isTRUE(input[[id_local]])
              if (identical(isTRUE(state2$groups[[gi]]$require_all), require_all)) {
                return(invisible(NULL))
              }
              state2$groups[[gi]]$require_all <- require_all
            } else if (identical(id_local, .expr_group_invert_input_id(gid_local))) {
              invert_group <- isTRUE(input[[id_local]])
              if (identical(isTRUE(state2$groups[[gi]]$invert), invert_group)) {
                return(invisible(NULL))
              }
              state2$groups[[gi]]$invert <- invert_group
            } else if (identical(id_local, .expr_group_delete_input_id(gid_local))) {
              deleted_gid <- .scalar_chr(state2$groups[[gi]]$id, default = "")
              state2$groups[[gi]] <- NULL
              if (identical(.scalar_chr(state2$active_group_id, default = ""), deleted_gid)) {
                remaining_ids <- vapply(state2$groups %||% list(), function(g) .scalar_chr(g$id, default = ""), character(1))
                remaining_ids <- remaining_ids[nzchar(remaining_ids)]
                state2$active_group_id <- if (length(remaining_ids)) remaining_ids[[length(remaining_ids)]] else ""
                if (nzchar(state2$active_group_id)) {
                  state2 <- .expr_set_active_group(state2, state2$active_group_id)
                }
              }
            } else if (identical(id_local, .expr_group_select_all_input_id(gid_local))) {
              target_checked <- isTRUE(input[[id_local]])
              genes_now <- state2$groups[[gi]]$genes %||% list()
              current_checked <- length(genes_now) > 0L &&
                all(vapply(genes_now, function(gr) isTRUE(gr$checked), logical(1)))
              if (!length(genes_now) || identical(current_checked, target_checked)) {
                return(invisible(NULL))
              }
              gene_ids_now <- vapply(state2$groups[[gi]]$genes %||% list(), function(gr) .scalar_chr(gr$id, default = ""), character(1))
              for (k in seq_along(state2$groups[[gi]]$genes %||% list())) {
                state2$groups[[gi]]$genes[[k]]$checked <- target_checked
              }
              gene_ids_now <- gene_ids_now[nzchar(gene_ids_now)]
              if (isTRUE(target_checked) && length(gene_ids_now)) state2 <- .expr_set_active_gene_id(state2, gid_local, gene_ids_now[[1]])
            } else if (identical(id_local, .expr_group_add_gene_input_id(gid_local))) {
              gene <- trimws(.scalar_chr(input[[id_local]], default = ""))
              if (!nzchar(gene)) return(invisible(NULL))
              obj_now <- recluster_new_data$seurat_obj
              all_genes_now <- character(0)
              if (!is.null(obj_now) && inherits(obj_now, "Seurat")) {
                all_genes_now <- .assay_feature_names(obj_now, .scalar_chr(input$recluster_new_assay_select, default = ""))
              }
              existing <- vapply(state2$groups[[gi]]$genes %||% list(), function(gr) tolower(.scalar_chr(gr$gene, default = "")), character(1))
              if (tolower(gene) %in% existing) {
                wl_update_gene_selectize(session, id_local, all_genes_now, selected = character(0))
                return(invisible(NULL))
              }
              gene_idx <- suppressWarnings(as.integer(state2$next_gene_index %||% 1L))
              if (!is.finite(gene_idx) || is.na(gene_idx) || gene_idx < 1L) gene_idx <- 1L
              gene_id <- sprintf("ge%03d", gene_idx)
              default_range <- NULL
              if (!is.null(obj_now) && inherits(obj_now, "Seurat")) {
                vals_now <- .fetch_gene_values(
                  obj_now,
                  .scalar_chr(input$recluster_new_assay_select, default = ""),
                  gene,
                  .expr_selection_slot()
                )
                range_info_now <- .expr_expression_range_info(vals_now)
                if (!is.null(range_info_now)) default_range <- range_info_now$default_range
              }
              state2$groups[[gi]]$genes[[length(state2$groups[[gi]]$genes %||% list()) + 1L]] <- list(
                id = gene_id,
                gene = gene,
                checked = TRUE,
                range = default_range
              )
              state2 <- .expr_set_active_gene_id(state2, gid_local, gene_id)
              state2$next_gene_index <- gene_idx + 1L
              wl_update_gene_selectize(session, id_local, all_genes_now, selected = character(0))
            }
            .expr_set_state(state2)
          }, ignoreInit = TRUE)
        })
      }
      for (gr in (g$genes %||% list())) {
        gene_id <- .scalar_chr(gr$id, default = "")
        if (!nzchar(gene_id)) next
        gene_ids <- c(
          .expr_gene_check_input_id(gid, gene_id),
          .expr_gene_active_input_id(gid, gene_id),
          .expr_gene_delete_input_id(gid, gene_id)
        )
        for (id in gene_ids) {
          if (id %in% next_bound) next
          next_bound <- unique(c(next_bound, id))
          local({
            id_local <- id
            gid_local <- gid
            gene_id_local <- gene_id
            observeEvent(input[[id_local]], {
              state2 <- .expr_state_normalize(recluster_new_data$expr_selection)
              gi <- .expr_group_index(state2, gid_local)
              if (is.na(gi)) return(invisible(NULL))
              if (
                !identical(.scalar_chr(state2$active_group_id, default = ""), gid_local) ||
                !isTRUE(state2$groups[[gi]]$open)
              ) {
                # Agent note: Gene input rebind echoes are not user actions.
                # Only current open group may mutate gene state or ownership.
                .db_dbg(
                  "expr_stale_gene_input_ignored",
                  sprintf("input=%s group=%s active=%s", id_local, gid_local, .scalar_chr(state2$active_group_id, default = ""))
                )
                return(invisible(NULL))
              }
              gene_i <- .expr_gene_index(state2$groups[[gi]], gene_id_local)
              if (is.na(gene_i)) return(invisible(NULL))
              if (identical(id_local, .expr_gene_check_input_id(gid_local, gene_id_local))) {
                gene_checked <- isTRUE(input[[id_local]])
                if (identical(isTRUE(state2$groups[[gi]]$genes[[gene_i]]$checked), gene_checked)) {
                  return(invisible(NULL))
                }
                state2$groups[[gi]]$genes[[gene_i]]$checked <- gene_checked
                state2 <- .expr_set_active_gene_id(state2, gid_local, gene_id_local)
              } else if (identical(id_local, .expr_gene_active_input_id(gid_local, gene_id_local))) {
                active_gene_id <- .scalar_chr(state2$groups[[gi]]$active_gene_id, default = "")
                state2 <- .expr_set_active_gene_id(
                  state2,
                  gid_local,
                  if (identical(active_gene_id, gene_id_local)) "" else gene_id_local
                )
                .db_dbg(
                  "expr_active_gene_toggle",
                  sprintf("group=%s gene=%s active=%s", gid_local, gene_id_local, !identical(active_gene_id, gene_id_local))
                )
              } else if (identical(id_local, .expr_gene_delete_input_id(gid_local, gene_id_local))) {
                state2$groups[[gi]]$genes[[gene_i]] <- NULL
                remaining_ids <- vapply(state2$groups[[gi]]$genes %||% list(), function(x) .scalar_chr(x$id, default = ""), character(1))
                state2$groups[[gi]]$active_gene_id <- if (length(remaining_ids)) remaining_ids[[1]] else ""
              }
              .expr_set_state(state2)
            }, ignoreInit = TRUE)
          })
        }
      }
    }
    if (!identical(sort(bound), sort(next_bound))) .expr_bound_inputs(next_bound)
  })

  observeEvent(input$recluster_new_tabs, {
    tab_key <- .norm_plot_tab(input$recluster_new_tabs)
    if (identical(.active_plot_tab(), tab_key)) return(invisible(NULL))
    .active_plot_tab(tab_key)
  }, ignoreInit = FALSE, priority = 1000)
  observeEvent(input$recluster_new_tabs_click, {
    tab_key <- .norm_plot_tab(input$recluster_new_tabs_click)
    if (identical(.active_plot_tab(), tab_key)) return(invisible(NULL))
    .active_plot_tab(tab_key)
  }, ignoreInit = TRUE, priority = 1001)

  observeEvent(input$recluster_new_expr_tabs, {
    tab_raw <- .scalar_chr(input$recluster_new_expr_tabs, default = "")
    if (!nzchar(tab_raw)) return(invisible(NULL))
    tab_key <- .norm_expr_tab(tab_raw)
    if (identical(.active_expr_tab(), tab_key)) return(invisible(NULL))
    .active_expr_tab(tab_key)
  }, ignoreInit = FALSE, priority = 1000)
  observeEvent(input$recluster_new_expr_tabs_click, {
    tab_raw <- .scalar_chr(input$recluster_new_expr_tabs_click, default = "")
    if (!nzchar(tab_raw)) return(invisible(NULL))
    tab_key <- .norm_expr_tab(tab_raw)
    if (identical(.active_expr_tab(), tab_key)) return(invisible(NULL))
    .active_expr_tab(tab_key)
  }, ignoreInit = TRUE, priority = 1001)

  observeEvent(input$recluster_new_rule_plot_tabs, {
    tab_key <- .norm_rule_plot_tab(input$recluster_new_rule_plot_tabs)
    if (identical(.active_rule_plot_tab(), tab_key)) return(invisible(NULL))
    .active_rule_plot_tab(tab_key)
  }, ignoreInit = FALSE, priority = 1000)
  observeEvent(input$recluster_new_rule_plot_tabs_click, {
    tab_key <- .norm_rule_plot_tab(input$recluster_new_rule_plot_tabs_click)
    if (identical(.active_rule_plot_tab(), tab_key)) return(invisible(NULL))
    .active_rule_plot_tab(tab_key)
  }, ignoreInit = TRUE, priority = 1001)

  output$recluster_new_plot_card_header_ui <- renderUI({
    tab_key <- .current_plot_tab()
    if (tab_key %in% c("scatter", "gene scatter plot")) {
      tagList(
        div(
          class = "recluster-new-plot-title",
          h4(RECLUSTER_NEW_UI_TEXT$t_title_scatter),
          p("Select genes for X/Y axes and click Update Plot.")
        )
      )
    } else {
      tagList(
        div(
          class = "recluster-new-plot-title",
          h4(RECLUSTER_NEW_UI_TEXT$t_title_interactive_umap),
          p(RECLUSTER_NEW_UI_TEXT$t_text_umap_note)
        )
      )
    }
  })

  output$recluster_new_plot_body_ui <- renderUI({
    tab_key <- .current_plot_tab()
    if (tab_key %in% c("scatter", "gene scatter plot")) {
      return(
        div(
          class = "recluster-new-scatter-shell",
          style = "height: var(--recluster-plot-h); min-height: var(--recluster-plot-h);",
          recluster_new_with_busy_spinner(plotlyOutput("recluster_new_scatter_plot", height = "100%"), spinner = "other")
        )
      )
    }
    div(
      class = "recluster-new-plot-shell",
      style = "height: var(--recluster-plot-h); min-height: var(--recluster-plot-h);",
      div(
        class = "recluster-new-plot-main",
        style = "height: var(--recluster-plot-h); min-height: var(--recluster-plot-h);",
        recluster_new_with_busy_spinner(plotlyOutput("recluster_new_umap_plot", height = "100%"), spinner = "umap")
      ),
      uiOutput("recluster_new_legend_panel_ui")
    )
  })

  output$recluster_new_violin_panel_ui <- renderUI({
    expr_tab <- .current_expr_tab()
    if (identical(expr_tab, "pseudobulk")) {
      return(
        div(
          class = "recluster-new-violin-wrap",
          h5(RECLUSTER_NEW_UI_TEXT$t_tab_pseudobulk_table),
          fluidRow(
            column(
              3,
              selectInput(
                "recluster_new_pb_meta_col",
                RECLUSTER_NEW_UI_TEXT$t_label_group_by_column,
                choices = names(recluster_new_data$metadata_profiles %||% list()),
                selected = .scalar_chr(recluster_new_data$metadata_open_column, default = "")
              )
            ),
            column(
              3,
              selectInput(
                "recluster_new_pb_compare_mode",
                RECLUSTER_NEW_UI_TEXT$t_label_pb_compare_mode,
                choices = c("Auto-bind from current selection context" = "auto_bind"),
                selected = "auto_bind"
              )
            ),
            column(3, uiOutput("recluster_new_pb_level_a_ui")),
            column(3, uiOutput("recluster_new_pb_level_b_ui"))
          ),
          div(
            style = "margin-bottom:8px;",
            actionButton("recluster_new_pb_run_btn", RECLUSTER_NEW_UI_TEXT$t_btn_pb_run, class = "btn btn-primary btn-sm"),
            tags$span(" "),
            actionButton("recluster_new_pb_open_analysis_btn", RECLUSTER_NEW_UI_TEXT$t_btn_pb_open_analysis, class = "btn btn-default btn-sm")
          ),
          p(
            class = "text-muted",
            "Method note: pseudobulk aggregates counts by sample (orig.ident) within each cluster group, then runs edgeR on pseudobulk replicates. p_val is the raw edgeR p-value and p_adj is the Benjamini-Hochberg false discovery rate adjusted p-value."
          ),
          uiOutput("recluster_new_pb_group_controls_ui"),
          div(class = "app-dt-horizontal-card recluster-new-pb-card", DTOutput("recluster_new_pb_table"))
        )
      )
    }
    div(
      id = "recluster_new_violin_resize_shell",
      class = "recluster-new-violin-resize app-resizable-plot",
      style = "min-height: 460px;",
      div(
        class = "recluster-new-violin-wrap",
        h5(if (identical(expr_tab, "stacked")) RECLUSTER_NEW_UI_TEXT$t_tab_stacked_plot else RECLUSTER_NEW_UI_TEXT$t_title_violin),
        p(class = "text-muted", style = "margin-top:-2px; margin-bottom:4px;", RECLUSTER_NEW_UI_TEXT$t_text_violin_note),
        div(
          class = "app-resizable-plot-body",
          recluster_new_with_busy_spinner(plotlyOutput("recluster_new_violin_plot", height = "100%"), spinner = "other")
        )
      ),
      div(
        class = "app-resize-handle",
        `data-target` = "recluster_new_violin_resize_shell",
        onmousedown = "return window.__wlResizeFromHandle && window.__wlResizeFromHandle(event, this);",
        onpointerdown = "return window.__wlResizeFromHandle && window.__wlResizeFromHandle(event, this);",
        tags$span(class = "app-resize-handle-grip"),
        tags$span(class = "app-resize-handle-text", "Drag to resize")
      )
    )
  })

  output$recluster_new_status_banner_ui <- renderUI({
    msg <- .scalar_chr(recluster_new_data$last_load_status, default = "")
    if (!nzchar(msg)) return(NULL)
    div(
      class = "recluster-new-status-banner alert alert-warning",
      icon("exclamation-triangle"),
      " ",
      msg
    )
  })

  .recluster_new_plot_output_id_from_tab <- function(tab_now = "") {
    tab_seed <- .scalar_chr(tab_now, default = "")
    if (!nzchar(tab_seed)) tab_seed <- "umap"
    tab_key <- .norm_plot_tab(tab_seed)
    if (tab_key %in% c("scatter", "gene scatter plot")) "recluster_new_scatter_plot" else "recluster_new_umap_plot"
  }

  .recluster_new_overlay_show_plot <- function(msg = "Preparing plot...", tab_now = "") {
    if (is.null(isolate(recluster_new_data$seurat_obj))) {
      try(overlay_hide(), silent = TRUE)
      return(invisible(NULL))
    }
    
    # Check if target tab is UMAP and UMAP plot is already cached.
    tab_seed <- .scalar_chr(tab_now, default = "")
    if (!nzchar(tab_seed)) tab_seed <- "umap"
    tab_key <- .norm_plot_tab(tab_seed)
    if (tab_key == "umap") {
      plot_cache_sig <- ""
      try({
        plot_cache_sig <- .umap_plot_cache_signature()
      }, silent = TRUE)
      stored_sig <- isolate(recluster_new_data$umap_plot_cache_sig)
      stored_cache <- isolate(recluster_new_data$umap_plot_cache)
      plot_cached <- nzchar(plot_cache_sig) && identical(plot_cache_sig, stored_sig) && inherits(stored_cache, "plotly")
      if (plot_cached) {
        try(overlay_hide(), silent = TRUE)
        return(invisible(NULL))
      }
    }
    
    try(overlay_show(msg), silent = TRUE)
    plot_id <- .scalar_chr(.recluster_new_plot_output_id_from_tab(tab_now), default = "")
    if (nzchar(plot_id)) {
      try(overlay_hide_when_output_ready(plot_id, timeout_ms = 120000L), silent = TRUE)
    } else {
      try(overlay_hide(), silent = TRUE)
    }
    invisible(NULL)
  }

  observeEvent(input$main_navbar, {
    if (!.db_tab_is_active()) return(invisible(NULL))
    recluster_new_page_activating(TRUE)
    recluster_new_dataset_syncing(TRUE)
    tab_now <- .scalar_chr(input$recluster_new_tabs, default = "umap")
    
    has_objs <- length(shared_data$all_seurat_objects) > 0L
    active_nm <- .scalar_chr(shared_data$active_object_name, default = "")
    loaded_now <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (has_objs && nzchar(active_nm)) {
      # Agent note: Always emit the landing overlay before page initialization; onFlushed confirms cache/output readiness and hides it.
      .db_dbg("landing_overlay_show", sprintf("active=%s loaded=%s", active_nm, loaded_now))
      try(overlay_show("Preparing Data Browser plot..."), silent = TRUE)
    } else {
      .db_dbg("landing_overlay_hide", sprintf("has_objects=%s active=%s", has_objs, active_nm))
      try(overlay_hide(), silent = TRUE)
    }
    
    try(bslib::toggle_sidebar("app_right_sidebar", open = FALSE, session = session), silent = TRUE)
    loaded_now <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    recluster_new_object_loading(TRUE)
    on.exit(recluster_new_object_loading(FALSE), add = TRUE)
    if (!identical(loaded_now, active_nm) || is.null(recluster_new_data$seurat_obj)) {
      .load_active_recluster_new_object(active_nm)
    }
    suppressWarnings(try(updateTabsetPanel(session, "recluster_new_tabs", selected = tab_now), silent = TRUE))
    session$onFlushed(function() {
      recluster_new_page_activating(FALSE)
      recluster_new_dataset_syncing(FALSE) # Safety guard: ensure syncing flag is cleared when page loads
      .recluster_new_overlay_show_plot("Preparing Data Browser plot...", tab_now = tab_now)
    }, once = TRUE)
    invisible(NULL)
  }, ignoreInit = FALSE, priority = 1000)

  # Agent note: Registry deletion and sidebar object switches are canonical.
  # Keep guard values reactive so a transition blocked during page loading is
  # retried when loading finishes; selector input may still show the old object.
  observe({
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    registry_sig <- recluster_new_object_selector$choices_signature()
    object_loading <- isTRUE(recluster_new_object_loading())
    dataset_syncing <- isTRUE(recluster_new_dataset_syncing())
    if (!isTRUE(.recluster_new_on_page())) {
      return(invisible(NULL))
    }
    if (object_loading) {
      return(invisible(NULL))
    }
    if (dataset_syncing) {
      return(invisible(NULL))
    }
    loaded_now <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (identical(nm, loaded_now)) {
      return(invisible(NULL))
    }
    .db_dbg(
      "canonical_object_transition",
      sprintf("active=%s loaded=%s registry_sig=%s", nm, loaded_now, registry_sig)
    )
    .load_active_recluster_new_object(nm)
    tab_now <- .scalar_chr(input$recluster_new_tabs, default = "umap")
    session$onFlushed(function() {
      .recluster_new_overlay_show_plot("Loading selected dataset plot...", tab_now = tab_now)
    }, once = TRUE)
    invisible(NULL)
  })

  observeEvent(input$recluster_new_umap_reduction_select, {
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))
    if (!isTRUE(.recluster_new_on_page())) return(invisible(NULL))
    red <- .scalar_chr(input$recluster_new_umap_reduction_select, default = "")
    if (isTRUE(.consume_pending_control("recluster_new_umap_reduction_select", red))) {
      .db_dbg("input_echo_ignored", sprintf("id=recluster_new_umap_reduction_select value=%s", red))
      return(invisible(NULL))
    }
    reduction_choices <- .embedding_reduction_choices(obj)
    if (nzchar(red) && red %in% reduction_choices) {
      recluster_new_data$umap_reduction_choice <- red
      recluster_new_data$final_plot_cache_sig <- ""
      recluster_new_data$final_plot_cache <- NULL
      recluster_new_data$umap_plot_cache_sig <- ""
      recluster_new_data$umap_plot_cache <- NULL
      umap_plot_rendered(NULL)
    } else {
      .db_dbg("input_echo_ignored", sprintf("id=recluster_new_umap_reduction_select stale_value=%s", red))
      return(invisible(NULL))
    }
    axis_choices <- .axis_index_choices(obj, red)
    if (!length(axis_choices)) return(invisible(NULL))
    axis_vals <- as.character(axis_choices)
    x_now <- .scalar_chr(input$recluster_new_umap_axis_x_select, default = "")
    y_now <- .scalar_chr(input$recluster_new_umap_axis_y_select, default = "")
    x_sel <- if (nzchar(x_now) && x_now %in% axis_vals) x_now else axis_vals[[1]]
    y_sel <- if (nzchar(y_now) && y_now %in% axis_vals && y_now != x_sel) y_now else if (length(axis_vals) >= 2L) axis_vals[[2]] else x_sel
    if (identical(x_now, x_sel) && identical(y_now, y_sel)) return(invisible(NULL))
    recluster_new_data$umap_control_syncing <- TRUE
    on.exit(recluster_new_data$umap_control_syncing <- FALSE, add = TRUE)
    updateSelectInput(session, "recluster_new_umap_axis_x_select", choices = axis_choices, selected = x_sel)
    updateSelectInput(session, "recluster_new_umap_axis_y_select", choices = axis_choices, selected = y_sel)
  }, ignoreInit = TRUE)

  observe({
    if (!isTRUE(.recluster_new_on_page())) return(invisible(NULL))
    if (isTRUE(recluster_new_object_loading())) return(invisible(NULL))
    if (isTRUE(recluster_new_dataset_syncing())) return(invisible(NULL))
    nm <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (!nzchar(nm)) return(invisible(NULL))
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    shared_obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    shared_sig <- .reduction_shape_signature(shared_obj)
    local_sig <- .reduction_shape_signature(recluster_new_data$seurat_obj)
    if (!nzchar(shared_sig) || identical(shared_sig, local_sig)) return(invisible(NULL))
    .db_dbg("reload_reduction_shape_changed", sprintf("object=%s shared=%s local=%s", nm, shared_sig, local_sig))
    .load_active_recluster_new_object(nm)
    invisible(NULL)
  }, priority = 900)

  observeEvent(recluster_new_loaded_object_name(), {
    .db_dbg("seurat_obj_observer", sprintf("loaded object name changed to=%s", recluster_new_loaded_object_name()))
    .sync_assay_gene_inputs(force = TRUE)
    .sync_rule_assay_gene_inputs(force = TRUE)
  }, ignoreInit = TRUE, priority = 950)

  observeEvent(input$recluster_new_assay_select, {
    assay_event <- .scalar_chr(input$recluster_new_assay_select, default = "")
    .db_dbg("assay_select_observer", sprintf("received value=%s, pending=%s", assay_event, .scalar_chr(recluster_new_data$pending_umap_assay_choice, default = "")))
    if (isTRUE(.consume_pending_control("recluster_new_assay_select", assay_event))) {
      .db_dbg("input_echo_ignored", sprintf("id=recluster_new_assay_select value=%s", assay_event))
      return(invisible(NULL))
    }
    obj <- recluster_new_data$seurat_obj
    if (!is.null(obj) && inherits(obj, "Seurat") && !isTRUE(recluster_new_data$umap_control_syncing)) {
      assay_choices <- .safe_assay_choices(obj)
      assay_now <- assay_event
      if (nzchar(assay_now) && assay_now %in% assay_choices) {
        recluster_new_data$umap_assay_choice <- assay_now
      } else {
        .db_dbg("input_echo_ignored", sprintf("id=recluster_new_assay_select stale_value=%s", assay_event))
        return(invisible(NULL))
      }
    }
    .sync_assay_gene_inputs(force = FALSE)
  }, ignoreInit = TRUE, priority = 940)

  observeEvent(input$recluster_new_rule_assay_select, {
    assay_event <- .scalar_chr(input$recluster_new_rule_assay_select, default = "")
    .db_dbg("rule_assay_select_observer", sprintf("received value=%s, pending=%s", assay_event, .scalar_chr(recluster_new_data$pending_rule_assay_choice, default = "")))
    if (isTRUE(.consume_pending_control("recluster_new_rule_assay_select", assay_event))) {
      .db_dbg("input_echo_ignored", sprintf("id=recluster_new_rule_assay_select value=%s", assay_event))
      return(invisible(NULL))
    }
    obj <- recluster_new_data$seurat_obj
    if (!is.null(obj) && inherits(obj, "Seurat") && !isTRUE(recluster_new_data$umap_control_syncing)) {
      assay_choices <- .safe_assay_choices(obj)
      assay_now <- assay_event
      if (nzchar(assay_now) && assay_now %in% assay_choices) {
        recluster_new_data$rule_assay_choice <- assay_now
      } else {
        .db_dbg("input_echo_ignored", sprintf("id=recluster_new_rule_assay_select stale_value=%s", assay_event))
        return(invisible(NULL))
      }
    }
    .sync_rule_assay_gene_inputs(force = FALSE)
  }, ignoreInit = TRUE, priority = 940)

  observeEvent(input$recluster_new_update_viz_btn, {
    tab_now <- .scalar_chr(input$recluster_new_tabs, default = "umap")
    .recluster_new_overlay_show_plot("Updating plot...", tab_now = tab_now)
  }, ignoreInit = TRUE)

  .workspace_tabs <- c(
    RECLUSTER_NEW_UI_TEXT$t_tab_selection_workspace,
    RECLUSTER_NEW_UI_TEXT$t_tab_metadata_curation,
    if (identical(.rule_browser_mount_mode, "separate_tab")) RECLUSTER_NEW_UI_TEXT$t_tab_metadata_overlap else character(0)
  )
  .last_workspace_tab <- reactiveVal({
    seed <- .scalar_chr(tryCatch(shared_data$recluster_new_last_workspace_tab, error = function(e) ""), default = "")
    if (seed %in% .workspace_tabs) seed else RECLUSTER_NEW_UI_TEXT$t_tab_selection_workspace
  })
  observeEvent(input$recluster_new_workspace_tabs, {
    tab_now <- .scalar_chr(input$recluster_new_workspace_tabs, default = "")
    if (!(tab_now %in% .workspace_tabs)) return(invisible(NULL))
    if (identical(.last_workspace_tab(), tab_now) &&
        identical(.scalar_chr(tryCatch(shared_data$recluster_new_last_workspace_tab, error = function(e) ""), default = ""), tab_now)) {
      return(invisible(NULL))
    }
    .last_workspace_tab(tab_now)
    shared_data$recluster_new_last_workspace_tab <- tab_now
    invisible(NULL)
  }, ignoreInit = TRUE)
  observeEvent(input$main_navbar, {
    if (!.db_tab_is_active()) return(invisible(NULL))
    tab_target <- .scalar_chr(.last_workspace_tab(), default = RECLUSTER_NEW_UI_TEXT$t_tab_selection_workspace)
    if (!(tab_target %in% .workspace_tabs)) tab_target <- RECLUSTER_NEW_UI_TEXT$t_tab_selection_workspace
    suppressWarnings(try(updateTabsetPanel(session, "recluster_new_workspace_tabs", selected = tab_target), silent = TRUE))
    invisible(NULL)
  }, ignoreInit = FALSE)

  .ensure_unique_col <- function(md, nm) {
    nm <- as.character(nm %||% "")
    if (!nzchar(nm)) nm <- "user_manual_label"
    if (!(nm %in% colnames(md))) return(nm)
    i <- 1L
    repeat {
      cand <- sprintf("%s_%d", nm, i)
      if (!(cand %in% colnames(md))) return(cand)
      i <- i + 1L
    }
  }

  .meta_cols <- reactive({
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj)) return(character(0))
    colnames(obj@meta.data %||% data.frame())
  })

  output$recluster_new_source_col_ui <- renderUI({
    cols <- .meta_cols()
    if (!length(cols)) return(helpText("No source metadata column available."))
    selectInput("recluster_new_source_col", RECLUSTER_NEW_UI_TEXT$t_label_source_column, choices = cols, selected = cols[[1]])
  })
  output$recluster_new_group_col_ui <- renderUI({
    cols <- .meta_cols()
    if (!length(cols)) return(helpText("No grouping column available."))
    selectInput("recluster_new_group_col", RECLUSTER_NEW_UI_TEXT$t_label_group_by_column, choices = cols, selected = cols[[1]])
  })
  output$recluster_new_group_level_ui <- renderUI({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    gc <- .scalar_chr(input$recluster_new_group_col, default = "")
    req(nzchar(gc), gc %in% colnames(obj@meta.data))
    lv <- sort(unique(as.character(obj@meta.data[[gc]] %||% character(0))), method = "radix")
    lv <- lv[nzchar(lv)]
    if (!length(lv)) return(helpText("No values in selected group column."))
    selectInput("recluster_new_group_level", RECLUSTER_NEW_UI_TEXT$t_label_group_value, choices = lv, selected = lv[[1]])
  })
  output$recluster_new_relabel_target_col_ui <- renderUI({
    cols <- .meta_cols()
    selected <- .scalar_chr(input$recluster_new_relabel_target_col, default = "user_manual_label")
    selectizeInput(
      "recluster_new_relabel_target_col",
      RECLUSTER_NEW_UI_TEXT$t_label_target_column,
      choices = unique(c("user_manual_label", cols)),
      selected = selected,
      options = list(create = TRUE, placeholder = "Pick existing column or type new name")
    )
  })
  output$recluster_new_cell_target_col_ui <- renderUI({
    cols <- .meta_cols()
    selected <- .scalar_chr(input$recluster_new_cell_target_col, default = "user_manual_label")
    selectizeInput(
      "recluster_new_cell_target_col",
      RECLUSTER_NEW_UI_TEXT$t_label_target_column,
      choices = unique(c("user_manual_label", cols)),
      selected = selected,
      options = list(create = TRUE, placeholder = "Pick existing column or type new name")
    )
  })

  output$recluster_new_viz_controls_ui <- renderUI({
    req(recluster_new_data$seurat_obj)
    obj <- recluster_new_data$seurat_obj
    cur_tab <- .current_plot_tab()
    cache_sig <- .viz_controls_cache_sig(obj, cur_tab)
    stored_sig <- isolate(recluster_new_data$viz_controls_cache_sig)
    stored_cache <- isolate(recluster_new_data$viz_controls_cache)
    if (identical(cache_sig, stored_sig) && !is.null(stored_cache)) {
      return(stored_cache)
    }
    # Freeze the managed inputs before recreating DOM nodes so that the
    # browser's echo from DOM destruction/recreation is silently discarded by
    # Shiny. This is the correct fix for renderUI-induced input echo loops.
    freezeReactiveValue(input, "recluster_new_assay_select")
    freezeReactiveValue(input, "recluster_new_umap_reduction_select")
    is_scatter_tab <- identical(cur_tab, "scatter")
    available_cols <- names(recluster_new_data$metadata_profiles %||% list())
    assay_choices <- .safe_assay_choices(obj)
    assay_sel <- isolate(.current_umap_assay(obj))
    if (!nzchar(assay_sel) || !(assay_sel %in% assay_choices)) {
      assay_sel <- if (length(assay_choices)) assay_choices[[1]] else character(0)
    }
    slot_sel <- isolate(.scalar_chr(input$recluster_new_slot_select, default = "data"))
    if (!(slot_sel %in% c("data", "counts", "scale.data"))) slot_sel <- "data"
    all_genes <- .assay_feature_names(obj, assay_sel)
    all_genes <- as.character(all_genes %||% character(0))
    all_genes <- all_genes[!is.na(all_genes) & nzchar(all_genes)]
    stored_umap_genes <- isolate(as.character(recluster_new_data$umap_gene_values %||% c("", "", "")))
    length(stored_umap_genes) <- 3L
    stored_umap_genes[is.na(stored_umap_genes)] <- ""
    gene_sel <- .scalar_chr(stored_umap_genes[[1]], default = "")
    gene2_sel <- .scalar_chr(stored_umap_genes[[2]], default = "")
    gene3_sel <- .scalar_chr(stored_umap_genes[[3]], default = "")
    display_mode_sel <- isolate(.scalar_chr(recluster_new_data$umap_display_mode, default = "metadata"))
    if (!(display_mode_sel %in% c("metadata", "gene"))) display_mode_sel <- "metadata"
    scatter_x_sel <- isolate(.scalar_chr(input$recluster_new_scatter_gene_x, default = ""))
    scatter_y_sel <- isolate(.scalar_chr(input$recluster_new_scatter_gene_y, default = ""))
    if (!(nzchar(scatter_x_sel) && scatter_x_sel %in% all_genes)) scatter_x_sel <- if (length(all_genes)) all_genes[[1]] else ""
    if (!(nzchar(scatter_y_sel) && scatter_y_sel %in% all_genes)) scatter_y_sel <- if (length(all_genes) >= 2) all_genes[[2]] else scatter_x_sel
    split_choices <- available_cols
    color_choices <- c("Single Gene Expression", available_cols, "None")
    stroke_choices <- c("black", "white", "grey50")
    reduction_choices <- .embedding_reduction_choices(obj)
    reduction_choice_labels <- if (length(reduction_choices)) {
      vapply(reduction_choices, function(red) .reduction_display_label(obj, red), character(1))
    } else {
      character(0)
    }
    red_sel_now <- isolate(.current_umap_reduction(obj))
    if (!nzchar(red_sel_now) || !(red_sel_now %in% reduction_choices)) {
      red_sel_now <- .preferred_embedding_reduction(obj)
    }
    axis_choices_now <- .axis_index_choices(obj, red_sel_now)
    axis_vals_now <- as.character(axis_choices_now)
    axis_x_now <- isolate(.scalar_chr(input$recluster_new_umap_axis_x_select, default = if (length(axis_vals_now)) axis_vals_now[[1]] else "1"))
    axis_y_seed <- if (length(axis_vals_now) >= 2L) axis_vals_now[[2]] else if (length(axis_vals_now)) axis_vals_now[[1]] else "2"
    axis_y_now <- isolate(.scalar_chr(input$recluster_new_umap_axis_y_select, default = axis_y_seed))
    if (!(axis_x_now %in% axis_vals_now)) axis_x_now <- if (length(axis_vals_now)) axis_vals_now[[1]] else "1"
    if (!(axis_y_now %in% axis_vals_now)) axis_y_now <- axis_y_seed

    color_sel <- isolate(.scalar_chr(recluster_new_data$umap_color_choice, default = .active_umap_metadata_col()))
    if (!(color_sel %in% color_choices)) color_sel <- "None"
    split_sel <- isolate(.scalar_chr(input$recluster_new_split_by_select, default = "None"))
    if (!(split_sel %in% c("None", split_choices))) split_sel <- "None"
    stroke_sel <- isolate(.scalar_chr(input$recluster_new_stroke_color, default = "black"))
    if (!(stroke_sel %in% stroke_choices)) stroke_sel <- "black"

    visual_settings <- .current_visual_settings()
    dot_size_sel <- suppressWarnings(as.numeric(visual_settings$dot_size %||% isolate(input$recluster_new_dot_size) %||% 1.0))
    dot_alpha_sel <- isolate(suppressWarnings(as.numeric(input$recluster_new_dot_alpha %||% 0.8)))
    stroke_w_sel <- suppressWarnings(as.numeric(visual_settings$stroke_width %||% isolate(input$recluster_new_stroke_width) %||% 0.1))
    if (!is.finite(dot_size_sel)) dot_size_sel <- 1.0
    if (!is.finite(dot_alpha_sel)) dot_alpha_sel <- 0.8
    if (!is.finite(stroke_w_sel)) stroke_w_sel <- 0.1
    stroke_w_sel <- max(0, min(1, stroke_w_sel))
    .db_dbg(
      "viz_controls_render",
      sprintf(
        "tab=%s sig=%s assay=%s slot=%s red=%s x=%s y=%s",
        cur_tab,
        substr(cache_sig, 1L, 160L),
        assay_sel,
        slot_sel,
        red_sel_now,
        axis_x_now,
        axis_y_now
      )
    )

    if (isTRUE(is_scatter_tab)) {
      controls_ui <- div(
        tags$div(class = "recluster-new-controls-title", RECLUSTER_NEW_UI_TEXT$t_title_controls),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_scatter_gene_x", RECLUSTER_NEW_UI_TEXT$t_label_scatter_gene_x, selected = scatter_x_sel, placeholder = "Type to search gene"))),
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_scatter_gene_y", RECLUSTER_NEW_UI_TEXT$t_label_scatter_gene_y, selected = scatter_y_sel, placeholder = "Type to search gene"))),
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_scatter_color_by", RECLUSTER_NEW_UI_TEXT$t_label_scatter_color, choices = c("None", available_cols), selected = isolate(.scalar_chr(input$recluster_new_scatter_color_by, default = if (length(available_cols)) available_cols[[1]] else "None")))))
          )
        ),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(4, div(class = "recluster-new-controls-item", checkboxGroupInput("recluster_new_scatter_log_scale", RECLUSTER_NEW_UI_TEXT$t_label_scatter_axis_scale, choices = c("Log Scale X-axis", "Log Scale Y-axis")))),
            column(4, div(class = "recluster-new-controls-item")),
            column(4, div(class = "recluster-new-controls-item"))
          )
        )
      )
    } else {
      controls_ui <- div(
        tags$div(class = "recluster-new-controls-title", RECLUSTER_NEW_UI_TEXT$t_title_controls),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_color_by_select", RECLUSTER_NEW_UI_TEXT$t_label_color_umap, choices = color_choices, selected = color_sel))),
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_split_by_select", RECLUSTER_NEW_UI_TEXT$t_label_split_umap, choices = c("None", split_choices), selected = split_sel))),
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_stroke_color", RECLUSTER_NEW_UI_TEXT$t_label_dot_outline_color, choices = stroke_choices, selected = stroke_sel)))
          )
        ),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_umap_reduction_select", RECLUSTER_NEW_UI_TEXT$t_label_umap_reduction, choices = stats::setNames(reduction_choices, reduction_choice_labels), selected = red_sel_now))),
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_umap_axis_x_select", RECLUSTER_NEW_UI_TEXT$t_label_umap_axis_x, choices = axis_choices_now, selected = axis_x_now))),
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_umap_axis_y_select", RECLUSTER_NEW_UI_TEXT$t_label_umap_axis_y, choices = axis_choices_now, selected = axis_y_now)))
          )
        ),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_assay_select", RECLUSTER_NEW_UI_TEXT$t_label_assay, choices = assay_choices, selected = assay_sel))),
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_slot_select", RECLUSTER_NEW_UI_TEXT$t_label_slot, choices = c("data", "counts", "scale.data"), selected = slot_sel))),
            column(4, div(class = "recluster-new-controls-item recluster-new-display-toggle", radioButtons("recluster_new_umap_display_mode", RECLUSTER_NEW_UI_TEXT$t_label_umap_display_control, choices = c("Metadata" = "metadata", "Gene expression" = "gene"), selected = display_mode_sel, inline = TRUE)))
          )
        ),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_gene_expr_select_1", RECLUSTER_NEW_UI_TEXT$t_label_gene_1, selected = gene_sel, placeholder = "Type to search gene"))),
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_gene_expr_select_2", RECLUSTER_NEW_UI_TEXT$t_label_gene_2, selected = gene2_sel, placeholder = "Type to search gene"))),
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_gene_expr_select_3", RECLUSTER_NEW_UI_TEXT$t_label_gene_3, selected = gene3_sel, placeholder = "Type to search gene")))
          )
        ),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(4, div(class = "recluster-new-controls-item", sliderInput("recluster_new_dot_size", RECLUSTER_NEW_UI_TEXT$t_label_dot_size, min = 0.1, max = 5, value = dot_size_sel, step = 0.1))),
            column(4, div(class = "recluster-new-controls-item", sliderInput("recluster_new_dot_alpha", RECLUSTER_NEW_UI_TEXT$t_label_dot_alpha, min = 0.1, max = 1, value = dot_alpha_sel, step = 0.1))),
            column(4, div(class = "recluster-new-controls-item", sliderInput("recluster_new_stroke_width", RECLUSTER_NEW_UI_TEXT$t_label_dot_outline_width, min = 0, max = 1, value = stroke_w_sel, step = 0.1)))
          )
        )
      )
    }
    isolate({
      recluster_new_data$viz_controls_cache_sig <- cache_sig
      recluster_new_data$viz_controls_cache <- controls_ui
    })
    if (!isTRUE(is_scatter_tab)) {
      # Agent note: renderUI replaces these server-backed selectize bindings.
      # Hydrate after Shiny binds replacement DOM; earlier updates are discarded.
      genes_after_bind <- all_genes
      selected_after_bind <- c(gene_sel, gene2_sel, gene3_sel)
      session$onFlushed(function() {
        for (i in seq_len(3L)) {
          selected_i <- selected_after_bind[[i]]
          wl_update_gene_selectize(
            session,
            sprintf("recluster_new_gene_expr_select_%d", i),
            genes_after_bind,
            selected = if (nzchar(selected_i) && selected_i %in% genes_after_bind) selected_i else character(0)
          )
        }
        .db_dbg(
          "viz_gene_selectize_hydrated",
          sprintf("assay=%s genes=%d selected=%s", assay_sel, length(genes_after_bind), paste(selected_after_bind[nzchar(selected_after_bind)], collapse = ","))
        )
      }, once = TRUE)
    }
    controls_ui
  })

  output$recluster_new_rule_viz_controls_ui <- renderUI({
    req(recluster_new_data$seurat_obj)
    obj <- recluster_new_data$seurat_obj
    cur_tab <- .current_rule_plot_tab()
    cache_sig <- .viz_controls_cache_sig(obj, paste0("rule:", cur_tab))
    stored_sig <- isolate(recluster_new_data$rule_viz_controls_cache_sig)
    stored_cache <- isolate(recluster_new_data$rule_viz_controls_cache)
    if (identical(cache_sig, stored_sig) && !is.null(stored_cache)) {
      return(stored_cache)
    }
    # Freeze the managed inputs before recreating DOM nodes (same reason as
    # in the main viz_controls_ui renderUI above).
    freezeReactiveValue(input, "recluster_new_rule_assay_select")
    freezeReactiveValue(input, "recluster_new_rule_umap_reduction_select")
    is_scatter_tab <- identical(cur_tab, "rule_scatter")
    available_cols <- names(recluster_new_data$metadata_profiles %||% list())
    assay_choices <- .safe_assay_choices(obj)
    assay_sel <- isolate(.current_rule_assay(obj))
    if (!nzchar(assay_sel) || !(assay_sel %in% assay_choices)) {
      assay_sel <- if (length(assay_choices)) assay_choices[[1]] else character(0)
    }
    rule_slot_sel <- isolate(.scalar_chr(input$recluster_new_rule_slot_select, default = "data"))
    if (!(rule_slot_sel %in% c("data", "counts", "scale.data"))) rule_slot_sel <- "data"
    all_genes <- .assay_feature_names(obj, assay_sel)
    all_genes <- as.character(all_genes %||% character(0))
    all_genes <- all_genes[!is.na(all_genes) & nzchar(all_genes)]
    gene_sel <- isolate(.scalar_chr(input$recluster_new_rule_gene_expr_select_1, default = ""))
    if (!(nzchar(gene_sel) && gene_sel %in% all_genes)) gene_sel <- ""
    scatter_x_sel <- isolate(.scalar_chr(input$recluster_new_rule_scatter_gene_x, default = ""))
    scatter_y_sel <- isolate(.scalar_chr(input$recluster_new_rule_scatter_gene_y, default = ""))
    if (!(nzchar(scatter_x_sel) && scatter_x_sel %in% all_genes)) scatter_x_sel <- if (length(all_genes)) all_genes[[1]] else ""
    if (!(nzchar(scatter_y_sel) && scatter_y_sel %in% all_genes)) scatter_y_sel <- if (length(all_genes) >= 2) all_genes[[2]] else scatter_x_sel
    split_choices <- available_cols
    color_choices <- c("Single Gene Expression", available_cols, "None")
    stroke_choices <- c("black", "white", "grey50")
    reduction_choices <- .embedding_reduction_choices(obj)
    reduction_choice_labels <- if (length(reduction_choices)) {
      vapply(reduction_choices, function(red) .reduction_display_label(obj, red), character(1))
    } else {
      character(0)
    }
    red_sel_now <- isolate(.current_rule_reduction(obj))
    if (!nzchar(red_sel_now) || !(red_sel_now %in% reduction_choices)) {
      red_sel_now <- .preferred_embedding_reduction(obj)
    }
    axis_choices_now <- .axis_index_choices(obj, red_sel_now)
    axis_vals_now <- as.character(axis_choices_now)
    axis_x_now <- isolate(.scalar_chr(input$recluster_new_rule_umap_axis_x_select, default = if (length(axis_vals_now)) axis_vals_now[[1]] else "1"))
    axis_y_seed <- if (length(axis_vals_now) >= 2L) axis_vals_now[[2]] else if (length(axis_vals_now)) axis_vals_now[[1]] else "2"
    axis_y_now <- isolate(.scalar_chr(input$recluster_new_rule_umap_axis_y_select, default = axis_y_seed))
    if (!(axis_x_now %in% axis_vals_now)) axis_x_now <- if (length(axis_vals_now)) axis_vals_now[[1]] else "1"
    if (!(axis_y_now %in% axis_vals_now)) axis_y_now <- axis_y_seed

    color_sel <- isolate(.scalar_chr(input$recluster_new_rule_color_by_select, default = {
      pref <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
      if (nzchar(pref) && pref %in% available_cols) pref else if (length(available_cols)) available_cols[[1]] else "None"
    }))
    if (!(color_sel %in% color_choices)) color_sel <- "None"
    split_sel <- isolate(.scalar_chr(input$recluster_new_rule_split_by_select, default = "None"))
    if (!(split_sel %in% c("None", split_choices))) split_sel <- "None"
    stroke_sel <- isolate(.scalar_chr(input$recluster_new_rule_stroke_color, default = "black"))
    if (!(stroke_sel %in% stroke_choices)) stroke_sel <- "black"

    dot_size_sel <- isolate(suppressWarnings(as.numeric(input$recluster_new_rule_dot_size %||% 0.6)))
    dot_alpha_sel <- isolate(suppressWarnings(as.numeric(input$recluster_new_rule_dot_alpha %||% 0.8)))
    stroke_w_sel <- isolate(suppressWarnings(as.numeric(input$recluster_new_rule_stroke_width %||% 0.1)))
    if (!is.finite(dot_size_sel)) dot_size_sel <- 0.6
    if (!is.finite(dot_alpha_sel)) dot_alpha_sel <- 0.8
    if (!is.finite(stroke_w_sel)) stroke_w_sel <- 0.1
    stroke_w_sel <- max(0, min(1, stroke_w_sel))
    .db_dbg(
      "rule_viz_controls_render",
      sprintf(
        "tab=%s sig=%s assay=%s slot=%s red=%s x=%s y=%s",
        cur_tab,
        substr(cache_sig, 1L, 160L),
        assay_sel,
        rule_slot_sel,
        red_sel_now,
        axis_x_now,
        axis_y_now
      )
    )

    if (isTRUE(is_scatter_tab)) {
      rule_controls_ui <- div(
        tags$div(class = "recluster-new-controls-title", RECLUSTER_NEW_UI_TEXT$t_title_controls),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(3, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_rule_scatter_gene_x", RECLUSTER_NEW_UI_TEXT$t_label_scatter_gene_x, selected = scatter_x_sel, placeholder = "Type to search gene"))),
            column(3, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_rule_scatter_gene_y", RECLUSTER_NEW_UI_TEXT$t_label_scatter_gene_y, selected = scatter_y_sel, placeholder = "Type to search gene"))),
            column(3, div(class = "recluster-new-controls-item", checkboxGroupInput("recluster_new_rule_scatter_log_scale", RECLUSTER_NEW_UI_TEXT$t_label_scatter_axis_scale, choices = c("Log Scale X-axis", "Log Scale Y-axis")))),
            column(3, div(class = "recluster-new-controls-item", selectInput("recluster_new_rule_scatter_color_by", RECLUSTER_NEW_UI_TEXT$t_label_scatter_color, choices = c("None", available_cols), selected = isolate(.scalar_chr(input$recluster_new_rule_scatter_color_by, default = if (length(available_cols)) available_cols[[1]] else "None")))))
          )
        )
      )
    } else {
      rule_controls_ui <- div(
        tags$div(class = "recluster-new-controls-title", RECLUSTER_NEW_UI_TEXT$t_title_controls),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(3, div(class = "recluster-new-controls-item", selectInput("recluster_new_rule_color_by_select", RECLUSTER_NEW_UI_TEXT$t_label_color_umap, choices = color_choices, selected = color_sel))),
            column(3, div(class = "recluster-new-controls-item", selectInput("recluster_new_rule_split_by_select", RECLUSTER_NEW_UI_TEXT$t_label_split_umap, choices = c("None", split_choices), selected = split_sel))),
            column(3, div(class = "recluster-new-controls-item", selectInput("recluster_new_rule_stroke_color", RECLUSTER_NEW_UI_TEXT$t_label_dot_outline_color, choices = stroke_choices, selected = stroke_sel))),
            column(3, div(class = "recluster-new-controls-item", actionButton("recluster_new_rule_update_viz_btn", RECLUSTER_NEW_UI_TEXT$t_btn_update_plot, icon = icon("sync-alt"))))
          )
        ),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_rule_umap_reduction_select", RECLUSTER_NEW_UI_TEXT$t_label_umap_reduction, choices = stats::setNames(reduction_choices, reduction_choice_labels), selected = red_sel_now))),
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_rule_umap_axis_x_select", RECLUSTER_NEW_UI_TEXT$t_label_umap_axis_x, choices = axis_choices_now, selected = axis_x_now))),
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_rule_umap_axis_y_select", RECLUSTER_NEW_UI_TEXT$t_label_umap_axis_y, choices = axis_choices_now, selected = axis_y_now)))
          )
        ),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(3, div(class = "recluster-new-controls-item", selectInput("recluster_new_rule_assay_select", RECLUSTER_NEW_UI_TEXT$t_label_assay, choices = assay_choices, selected = assay_sel))),
            column(2, div(class = "recluster-new-controls-item", selectInput("recluster_new_rule_slot_select", RECLUSTER_NEW_UI_TEXT$t_label_slot, choices = c("data", "counts", "scale.data"), selected = rule_slot_sel))),
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_rule_gene_expr_select_1", RECLUSTER_NEW_UI_TEXT$t_label_gene_shared, selected = gene_sel, placeholder = "Type to search gene"))),
            column(3, div(class = "recluster-new-controls-item", uiOutput("recluster_new_rule_gene_expr_range_ui")))
          )
        ),
        div(
          class = "recluster-new-controls-row",
          fluidRow(
            column(4, div(class = "recluster-new-controls-item", sliderInput("recluster_new_rule_dot_size", RECLUSTER_NEW_UI_TEXT$t_label_dot_size, min = 0.1, max = 5, value = dot_size_sel, step = 0.1))),
            column(4, div(class = "recluster-new-controls-item", sliderInput("recluster_new_rule_dot_alpha", RECLUSTER_NEW_UI_TEXT$t_label_dot_alpha, min = 0.1, max = 1, value = dot_alpha_sel, step = 0.1))),
            column(4, div(class = "recluster-new-controls-item", sliderInput("recluster_new_rule_stroke_width", RECLUSTER_NEW_UI_TEXT$t_label_dot_outline_width, min = 0, max = 1, value = stroke_w_sel, step = 0.1)))
          )
        )
      )
    }
    isolate({
      recluster_new_data$rule_viz_controls_cache_sig <- cache_sig
      recluster_new_data$rule_viz_controls_cache <- rule_controls_ui
    })
    rule_controls_ui
  })

  output$recluster_new_rule_gene_expr_range_ui <- renderUI({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    gene_now <- .scalar_chr(input$recluster_new_rule_gene_expr_select_1, default = "")
    assay_now <- .scalar_chr(input$recluster_new_rule_assay_select, default = "")
    slot_now <- .scalar_chr(input$recluster_new_rule_slot_select, default = "data")
    vals <- .fetch_gene_values(obj, assay_now, gene_now, slot_now)
    if (is.null(vals) || !length(vals)) {
      return(div(class = "text-muted app-secondary-status", "Select gene to enable range"))
    }
    rng <- range(vals[is.finite(vals)], na.rm = TRUE)
    if (!all(is.finite(rng)) || rng[[1]] >= rng[[2]]) {
      return(div(class = "text-muted app-secondary-status", "Range unavailable"))
    }
    cur <- suppressWarnings(as.numeric(input$recluster_new_rule_gene_expr_range %||% c(rng[[1]], rng[[2]])))
    if (length(cur) != 2 || any(!is.finite(cur))) cur <- rng
    cur[[1]] <- max(rng[[1]], min(cur[[1]], rng[[2]]))
    cur[[2]] <- max(cur[[1]], min(cur[[2]], rng[[2]]))
    sliderInput(
      "recluster_new_rule_gene_expr_range",
      RECLUSTER_NEW_UI_TEXT$t_label_gene_expr_range,
      min = rng[[1]],
      max = rng[[2]],
      value = cur,
      step = signif((rng[[2]] - rng[[1]]) / 200, 3)
    )
  })

  output$recluster_new_rule_plot_body_ui <- renderUI({
    tab_key <- .current_rule_plot_tab()
    if (identical(tab_key, "rule_scatter")) {
      return(
        div(
          class = "recluster-new-scatter-shell",
          style = "height: var(--recluster-plot-h); min-height: var(--recluster-plot-h);",
          recluster_new_with_busy_spinner(plotlyOutput("recluster_new_rule_scatter_plot", height = "100%"), spinner = "other")
        )
      )
    }
    div(
      class = "recluster-new-plot-shell",
      div(
        class = "recluster-new-plot-main",
        style = "height: var(--recluster-plot-h); min-height: var(--recluster-plot-h);",
        recluster_new_with_busy_spinner(plotlyOutput("recluster_new_rule_umap_plot", height = "100%"), spinner = "umap")
      )
    )
  })

  observeEvent(input$recluster_new_rule_update_viz_btn, {
    invisible(NULL)
  }, ignoreInit = TRUE)

  .rule_meta_cols <- reactive({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    md <- obj@meta.data
    cols <- colnames(md)[vapply(md, .is_supported_meta_column, logical(1))]
    cols[!is.na(cols) & nzchar(cols)]
  })

  observeEvent(list(recluster_new_data$seurat_obj, .rule_meta_cols()), {
    cols <- .rule_meta_cols()
    a_now <- .scalar_chr(input$recluster_new_rule_a_col, default = "")
    b_now <- .scalar_chr(input$recluster_new_rule_b_col, default = "")
    g_now <- .scalar_chr(input$recluster_new_rule_group_col, default = "")
    a_sel <- if (nzchar(a_now) && a_now %in% cols) a_now else if (length(cols)) cols[[1]] else ""
    b_sel <- if (nzchar(b_now) && b_now %in% cols) b_now else if (length(cols) >= 2) cols[[2]] else a_sel
    g_sel <- if (nzchar(g_now) && g_now %in% cols) g_now else if ("seurat_clusters" %in% cols) "seurat_clusters" else if (length(cols)) cols[[1]] else ""
    updateSelectInput(session, "recluster_new_rule_a_col", choices = cols, selected = a_sel)
    updateSelectInput(session, "recluster_new_rule_b_col", choices = cols, selected = b_sel)
    updateSelectInput(session, "recluster_new_rule_group_col", choices = cols, selected = g_sel)
    invisible(NULL)
  }, ignoreInit = FALSE)

  output$recluster_new_rule_a_value_ui <- renderUI({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    col_a <- .scalar_chr(input$recluster_new_rule_a_col, default = "")
    req(nzchar(col_a), col_a %in% colnames(obj@meta.data))
    vec <- obj@meta.data[[col_a]]
    if (.is_numeric_rule_column(vec)) {
      vv <- suppressWarnings(as.numeric(vec))
      rng <- range(vv[is.finite(vv)], na.rm = TRUE)
      if (!all(is.finite(rng))) return(helpText("No finite numeric values available."))
      cur <- suppressWarnings(as.numeric(input$recluster_new_rule_a_range %||% rng))
      if (length(cur) != 2 || any(!is.finite(cur))) cur <- rng
      sliderInput("recluster_new_rule_a_range", "Rule A range", min = rng[[1]], max = rng[[2]], value = cur, step = max((rng[[2]] - rng[[1]]) / 200, 1e-9))
    } else {
      vals <- as.character(vec %||% character(0))
      vals <- vals[!is.na(vals) & nzchar(vals)]
      lv <- .sort_numeric_first(unique(vals))
      auto <- .likely_positive_values(lv, col_name = col_a)
      selected_now <- as.character(input$recluster_new_rule_a_values %||% auto)
      if (!length(selected_now)) selected_now <- auto
      checkboxGroupInput("recluster_new_rule_a_values", "Rule A values interpreted as TRUE", choices = lv, selected = intersect(selected_now, lv))
    }
  })

  output$recluster_new_rule_b_value_ui <- renderUI({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    col_b <- .scalar_chr(input$recluster_new_rule_b_col, default = "")
    req(nzchar(col_b), col_b %in% colnames(obj@meta.data))
    vec <- obj@meta.data[[col_b]]
    if (.is_numeric_rule_column(vec)) {
      vv <- suppressWarnings(as.numeric(vec))
      rng <- range(vv[is.finite(vv)], na.rm = TRUE)
      if (!all(is.finite(rng))) return(helpText("No finite numeric values available."))
      cur <- suppressWarnings(as.numeric(input$recluster_new_rule_b_range %||% rng))
      if (length(cur) != 2 || any(!is.finite(cur))) cur <- rng
      sliderInput("recluster_new_rule_b_range", "Rule B range", min = rng[[1]], max = rng[[2]], value = cur, step = max((rng[[2]] - rng[[1]]) / 200, 1e-9))
    } else {
      vals <- as.character(vec %||% character(0))
      vals <- vals[!is.na(vals) & nzchar(vals)]
      lv <- .sort_numeric_first(unique(vals))
      auto <- .likely_positive_values(lv, col_name = col_b)
      selected_now <- as.character(input$recluster_new_rule_b_values %||% auto)
      if (!length(selected_now)) selected_now <- auto
      checkboxGroupInput("recluster_new_rule_b_values", "Rule B values interpreted as TRUE", choices = lv, selected = intersect(selected_now, lv))
    }
  })

  observeEvent(input$recluster_new_rule_color_preset, {
    preset_key <- .scalar_chr(input$recluster_new_rule_color_preset, default = "default")
    presets <- .rule_color_presets()
    pal <- presets[[preset_key]]
    if (is.null(pal)) return(invisible(NULL))
    colourpicker::updateColourInput(session, "recluster_new_rule_color_a_only", value = pal[["A_only"]])
    colourpicker::updateColourInput(session, "recluster_new_rule_color_b_only", value = pal[["B_only"]])
    colourpicker::updateColourInput(session, "recluster_new_rule_color_ab", value = pal[["A_B"]])
    colourpicker::updateColourInput(session, "recluster_new_rule_color_neither", value = pal[["Neither"]])
    colourpicker::updateColourInput(session, "recluster_new_rule_color_missing", value = pal[["Missing"]])
    invisible(NULL)
  }, ignoreInit = TRUE)

  rule_overlap_df <- reactive({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    md <- obj@meta.data
    req(is.data.frame(md), nrow(md))

    col_a <- .scalar_chr(input$recluster_new_rule_a_col, default = "")
    col_b <- .scalar_chr(input$recluster_new_rule_b_col, default = "")
    md_cols <- colnames(md)
    cols_ready <- nzchar(col_a) && nzchar(col_b) && col_a %in% md_cols && col_b %in% md_cols
    if (!isTRUE(cols_ready)) {
      diag_sig <- sprintf("A=%s|B=%s|md_cols=%d", col_a, col_b, length(md_cols))
      if (!identical(recluster_new_data$debug_rule_overlap_state, diag_sig)) {
        message(sprintf("[RULE_BROWSER][INIT_GUARD] Rule columns not ready yet: %s", diag_sig))
        recluster_new_data$debug_rule_overlap_state <- diag_sig
      }
      cell_ids <- rownames(md)
      if (!length(cell_ids)) cell_ids <- as.character(seq_len(nrow(md)))
      unresolved <- data.frame(
        cell_id = cell_ids,
        rule_a_state = rep("Missing", length(cell_ids)),
        rule_b_state = rep("Missing", length(cell_ids)),
        overlap_group = rep("Missing", length(cell_ids)),
        stringsAsFactors = FALSE
      )
      unresolved$overlap_group <- factor(unresolved$overlap_group, levels = c("A_only", "B_only", "A_B", "Neither", "Missing"))
      recluster_new_data$rule_definitions <- list(
        A = list(type = "unresolved", column = col_a),
        B = list(type = "unresolved", column = col_b)
      )
      return(unresolved)
    }
    if (nzchar(recluster_new_data$debug_rule_overlap_state %||% "")) {
      recluster_new_data$debug_rule_overlap_state <- ""
    }

    vec_a <- md[[col_a]]
    vec_b <- md[[col_b]]
    is_num_a <- .is_numeric_rule_column(vec_a)
    is_num_b <- .is_numeric_rule_column(vec_b)
    def_a <- if (is_num_a) {
      list(type = "numeric", column = col_a, range = as.numeric(input$recluster_new_rule_a_range %||% c(NA_real_, NA_real_)))
    } else {
      list(type = "categorical", column = col_a, selected = as.character(input$recluster_new_rule_a_values %||% character(0)))
    }
    def_b <- if (is_num_b) {
      list(type = "numeric", column = col_b, range = as.numeric(input$recluster_new_rule_b_range %||% c(NA_real_, NA_real_)))
    } else {
      list(type = "categorical", column = col_b, selected = as.character(input$recluster_new_rule_b_values %||% character(0)))
    }
    recluster_new_data$rule_definitions <- list(A = def_a, B = def_b)

    a_state <- .classify_rule_column(vec_a, def_a)
    b_state <- .classify_rule_column(vec_b, def_b)
    overlap <- .combine_rule_ab_overlap(a_state, b_state)
    names(overlap) <- rownames(md)

    out <- data.frame(
      cell_id = rownames(md),
      rule_a_state = as.character(a_state),
      rule_b_state = as.character(b_state),
      overlap_group = as.character(overlap),
      stringsAsFactors = FALSE
    )
    out$overlap_group <- factor(out$overlap_group, levels = c("A_only", "B_only", "A_B", "Neither", "Missing"))
    out
  })

  rule_selected_cells_base <- reactive({
    rdf <- rule_overlap_df()
    grp <- .scalar_chr(input$recluster_new_rule_selected_group, default = "All")
    if (identical(grp, "All")) return(as.character(rdf$cell_id))
    as.character(rdf$cell_id[rdf$overlap_group == grp])
  })

  .plotly_selected_keys <- function(ev, source_name) {
    if (is.null(ev) || (is.list(ev) && length(ev) == 0L)) return(character(0))
    if (!is.data.frame(ev)) {
      message(sprintf(
        "[Data Browser] Ignored malformed plotly_selected payload from %s: class=%s length=%d",
        source_name,
        paste(class(ev), collapse = "/"),
        length(ev)
      ))
      return(character(0))
    }
    if (nrow(ev) == 0L || !("key" %in% names(ev))) return(character(0))
    keys <- as.character(ev[["key"]])
    unique(keys[!is.na(keys) & nzchar(keys)])
  }

  observeEvent(event_data("plotly_selected", source = "recluster_new_rule_plot_source"), {
    ev <- event_data("plotly_selected", source = "recluster_new_rule_plot_source")
    next_cells <- .plotly_selected_keys(ev, "recluster_new_rule_plot_source")
    if (!identical(sort(next_cells), sort(isolate(rule_lasso_cells_state())))) {
      rule_lasso_cells_state(next_cells)
    }
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(event_data("plotly_selected", source = "recluster_new_plot_source"), {
    ev <- event_data("plotly_selected", source = "recluster_new_plot_source")
    next_cells <- .plotly_selected_keys(ev, "recluster_new_plot_source")
    if (length(next_cells)) {
      expr_state <- .expr_state_normalize(recluster_new_data$expr_selection)
      active_group_id <- .scalar_chr(expr_state$active_group_id, default = "")
      if (nzchar(active_group_id)) {
        # Agent note: Direct lasso is an explicit replacement selection.
        # Preserve saved group definition, but deactivate its cell contribution.
        expr_state$active_group_id <- ""
        .expr_set_state(expr_state)
        .db_dbg(
          "lasso_deactivate_expr_group",
          sprintf("group_id=%s selected_cells=%d", active_group_id, length(next_cells))
        )
      }
    }
    if (!identical(sort(next_cells), sort(isolate(lasso_selected_cells_state())))) {
      lasso_selected_cells_state(next_cells)
    }
    invisible(NULL)
  }, ignoreInit = TRUE)

  rule_lasso_cells <- reactive({
    rule_lasso_cells_state()
  })

  lasso_selected_cells <- reactive({
    lasso_selected_cells_state()
  })

  observe({
    lasso_cells <- lasso_selected_cells_state()
    expr_state <- .expr_state_normalize(recluster_new_data$expr_selection)
    active_group_id <- .scalar_chr(expr_state$active_group_id, default = "")
    if (length(lasso_cells) > 0L && nzchar(active_group_id)) {
      # Agent note: Lasso has strict precedence over expression groups. Watch
      # both states so later group activation cannot produce two active cards.
      expr_state$active_group_id <- ""
      .expr_set_state(expr_state)
      .db_dbg(
        "lasso_precedence_reconciled",
        sprintf("group_id=%s selected_cells=%d", active_group_id, length(lasso_cells))
      )
    }
    enabled <- length(lasso_cells) > 0L
    session$sendCustomMessage(
      "recluster-new-toggle-class",
      list(
        id = "recluster_new_advanced_manual_card",
        className = "is-violet-highlight-source",
        enabled = enabled
      )
    )
    .db_dbg("lasso_card_highlight", sprintf("enabled=%s", enabled))
  })

  rule_combined_cells <- reactive({
    base <- as.character(rule_selected_cells_base() %||% character(0))
    manual_rule <- as.character(rule_lasso_cells() %||% character(0))
    manual_old <- as.character(recluster_new_data$selected_cells %||% character(0))
    manual <- unique(c(manual_rule, manual_old))
    mode_now <- .scalar_chr(input$recluster_new_rule_manual_mode, default = "union")
    if (!mode_now %in% c("union", "intersection")) mode_now <- "union"
    if (identical(mode_now, "intersection")) {
      if (!length(manual)) return(character(0))
      return(intersect(base, manual))
    }
    unique(c(base, manual))
  })

  observe({
    grp <- .scalar_chr(input$recluster_new_rule_selected_group, default = "All")
    mode_now <- .scalar_chr(input$recluster_new_rule_manual_mode, default = "union")
    if (!grp %in% c("A_only", "B_only", "A_B", "Neither", "Missing", "All")) grp <- "All"
    if (!mode_now %in% c("union", "intersection")) mode_now <- "union"
    recluster_new_data$rule_selected_group <- grp
    recluster_new_data$rule_manual_combine_mode <- mode_now
    recluster_new_data$rule_active_cells <- unique(as.character(rule_combined_cells() %||% character(0)))
    invisible(NULL)
  })

  observeEvent(input$recluster_new_tabs, {
    if (!identical(.current_plot_tab(), "scatter")) return(invisible(NULL))
    obj <- recluster_new_data$seurat_obj
    req(obj)
    assay_now <- .scalar_chr(input$recluster_new_assay_select, default = as.character(DefaultAssay(obj) %||% ""))
    assay_choices <- .safe_assay_choices(obj)
    if (!nzchar(assay_now) || !(assay_now %in% assay_choices)) {
      assay_now <- if (length(assay_choices)) assay_choices[[1]] else ""
    }
    all_genes <- if (nzchar(assay_now)) .assay_feature_names(obj, assay_now) else character(0)
    scatter_x_now <- .scalar_chr(input$recluster_new_scatter_gene_x, default = "")
    scatter_y_now <- .scalar_chr(input$recluster_new_scatter_gene_y, default = "")
    x_sel <- if (nzchar(scatter_x_now) && scatter_x_now %in% all_genes) scatter_x_now else if (length(all_genes)) all_genes[[1]] else character(0)
    y_sel <- if (nzchar(scatter_y_now) && scatter_y_now %in% all_genes) scatter_y_now else if (length(all_genes) >= 2) all_genes[[2]] else x_sel
    wl_update_gene_selectize(session, "recluster_new_scatter_gene_x", all_genes, selected = x_sel)
    wl_update_gene_selectize(session, "recluster_new_scatter_gene_y", all_genes, selected = y_sel)
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_rule_plot_tabs, {
    if (!identical(.current_rule_plot_tab(), "rule_scatter")) return(invisible(NULL))
    obj <- recluster_new_data$seurat_obj
    req(obj)
    assay_now <- .scalar_chr(input$recluster_new_rule_assay_select, default = as.character(DefaultAssay(obj) %||% ""))
    assay_choices <- .safe_assay_choices(obj)
    if (!nzchar(assay_now) || !(assay_now %in% assay_choices)) {
      assay_now <- if (length(assay_choices)) assay_choices[[1]] else ""
    }
    all_genes <- if (nzchar(assay_now)) .assay_feature_names(obj, assay_now) else character(0)
    scatter_x_now <- .scalar_chr(input$recluster_new_rule_scatter_gene_x, default = "")
    scatter_y_now <- .scalar_chr(input$recluster_new_rule_scatter_gene_y, default = "")
    x_sel <- if (nzchar(scatter_x_now) && scatter_x_now %in% all_genes) scatter_x_now else if (length(all_genes)) all_genes[[1]] else character(0)
    y_sel <- if (nzchar(scatter_y_now) && scatter_y_now %in% all_genes) scatter_y_now else if (length(all_genes) >= 2) all_genes[[2]] else x_sel
    wl_update_gene_selectize(session, "recluster_new_rule_scatter_gene_x", all_genes, selected = x_sel)
    wl_update_gene_selectize(session, "recluster_new_rule_scatter_gene_y", all_genes, selected = y_sel)
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_rule_umap_reduction_select, {
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))
    red <- .scalar_chr(input$recluster_new_rule_umap_reduction_select, default = "")
    if (isTRUE(.consume_pending_control("recluster_new_rule_umap_reduction_select", red))) {
      .db_dbg("input_echo_ignored", sprintf("id=recluster_new_rule_umap_reduction_select value=%s", red))
      return(invisible(NULL))
    }
    reduction_choices <- .embedding_reduction_choices(obj)
    if (nzchar(red) && red %in% reduction_choices) {
      recluster_new_data$rule_reduction_choice <- red
    } else {
      .db_dbg("input_echo_ignored", sprintf("id=recluster_new_rule_umap_reduction_select stale_value=%s", red))
      return(invisible(NULL))
    }
    axis_choices <- .axis_index_choices(obj, red)
    if (!length(axis_choices)) return(invisible(NULL))
    axis_vals <- as.character(axis_choices)
    x_now <- .scalar_chr(input$recluster_new_rule_umap_axis_x_select, default = "")
    y_now <- .scalar_chr(input$recluster_new_rule_umap_axis_y_select, default = "")
    x_sel <- if (nzchar(x_now) && x_now %in% axis_vals) x_now else axis_vals[[1]]
    y_sel <- if (nzchar(y_now) && y_now %in% axis_vals && y_now != x_sel) y_now else if (length(axis_vals) >= 2L) axis_vals[[2]] else x_sel
    updateSelectInput(session, "recluster_new_rule_umap_axis_x_select", choices = axis_choices, selected = x_sel)
    updateSelectInput(session, "recluster_new_rule_umap_axis_y_select", choices = axis_choices, selected = y_sel)
  }, ignoreInit = TRUE)

  output$recluster_new_legend_panel_ui <- renderUI({ NULL })

  .metadata_bucket_order <- c("cluster", "categorical", "continuous")
  .bucket_label <- function(bucket) {
    switch(
      bucket,
      cluster = RECLUSTER_NEW_UI_TEXT$t_bucket_cluster,
      categorical = RECLUSTER_NEW_UI_TEXT$t_bucket_categorical,
      continuous = RECLUSTER_NEW_UI_TEXT$t_bucket_continuous,
      bucket
    )
  }

  .normalize_metadata_open_state <- function(profiles, open_col, open_bucket) {
    if (!length(profiles)) {
      return(list(open_col = "", open_bucket = "cluster"))
    }
    buckets <- split(names(profiles), vapply(profiles, function(p) p$bucket, character(1)))
    col_now <- .scalar_chr(open_col, default = "")
    if (!nzchar(col_now) || !(col_now %in% names(profiles))) {
      col_now <- if ("cluster" %in% names(buckets) && length(buckets[["cluster"]])) buckets[["cluster"]][[1]] else names(profiles)[[1]]
    }
    bucket_now <- .scalar_chr(open_bucket, default = "")
    if (!nzchar(bucket_now) || !(bucket_now %in% names(buckets))) {
      bucket_now <- .scalar_chr(vapply(profiles[col_now], function(p) p$bucket, character(1)), default = "cluster")
    }
    list(open_col = col_now, open_bucket = bucket_now)
  }

  observeEvent(recluster_new_data$metadata_profiles, {
    profiles <- recluster_new_data$metadata_profiles
    if (!length(profiles)) return(invisible(NULL))
    col_now <- .resolve_metadata_browser_column(.scalar_chr(recluster_new_data$metadata_open_column, default = ""), names(profiles))
    if (nzchar(col_now) && identical(col_now, .scalar_chr(recluster_new_data$metadata_open_column, default = ""))) {
      return(invisible(NULL))
    }
    if (nzchar(col_now)) {
      recluster_new_data$metadata_open_column <- col_now
      return(invisible(NULL))
    }
    state <- .normalize_metadata_open_state(profiles, open_col = "", open_bucket = "")
    recluster_new_data$metadata_open_column <- state$open_col
    recluster_new_data$metadata_open_bucket <- state$open_bucket
    invisible(NULL)
  }, ignoreInit = TRUE)

  output$recluster_new_metadata_selector_ui <- renderUI({
    profiles <- recluster_new_data$metadata_profiles
    if (!length(profiles)) return(helpText(RECLUSTER_NEW_UI_TEXT$t_text_no_metadata))

    buckets <- split(names(profiles), vapply(profiles, function(p) p$bucket, character(1)))
    norm_state <- .normalize_metadata_open_state(
      profiles = profiles,
      open_col = recluster_new_data$metadata_open_column,
      open_bucket = recluster_new_data$metadata_open_bucket
    )
    open_col <- norm_state$open_col
    open_bucket <- norm_state$open_bucket

    bucket_ui <- lapply(.metadata_bucket_order, function(bucket_name) {
      cols <- buckets[[bucket_name]] %||% character(0)
      if (!length(cols)) return(NULL)

      col_nodes <- lapply(cols, function(col_name) {
        p <- profiles[[col_name]]
        is_open_col <- identical(col_name, open_col)
        mode_id <- .mode_input_id(col_name)
        rng_id <- .rng_input_id(col_name)
        mode_choices <- c("category" = RECLUSTER_NEW_UI_TEXT$t_mode_category)
        if (isTRUE(p$numeric_like)) mode_choices <- c(mode_choices, "range" = RECLUSTER_NEW_UI_TEXT$t_mode_range)

        control_ui <- if (isTRUE(is_open_col)) {
          mode_choice <- isolate(.scalar_chr(input[[mode_id]], default = p$default_mode %||% "category"))
          mode_now <- .resolved_mode(p, mode_choice)
          mode_selected <- if (mode_now %in% names(mode_choices)) mode_now else "category"
          core_ui <- if (identical(mode_now, "range") && isTRUE(p$numeric_like) && is.finite(p$min_val) && is.finite(p$max_val) && (p$min_val < p$max_val)) {
            tagList(
              div(
                class = "recluster-new-range-legend",
                div(class = "recluster-new-range-ramp"),
                div(
                  class = "recluster-new-range-labels",
                  tags$span(format(signif(p$min_val, 4), trim = TRUE)),
                  tags$span(format(signif(p$max_val, 4), trim = TRUE))
                )
              ),
              sliderInput(
                rng_id,
                label = col_name,
                min = p$min_val,
                max = p$max_val,
                value = c(p$min_val, p$max_val),
                step = max((p$max_val - p$min_val) / 200, 1e-9)
              )
            )
          } else {
            level_colors <- .level_color_map(recluster_new_data$seurat_obj, col_name, p$levels)
            tagList(
              div(
                class = "recluster-new-metadata-color-toolbar",
                style = "margin-bottom:8px;",
                actionButton(
                  "recluster_new_metadata_color_popup",
                  RECLUSTER_NEW_UI_TEXT$t_btn_metadata_customize_colors,
                  icon = icon("paint-brush"),
                  class = "btn btn-default btn-sm"
                )
              ),
              lapply(p$levels, function(level_name) {
                checked_now <- isolate(isTRUE(input[[.cat_level_input_id(col_name, level_name)]] %||% TRUE))
                color_now <- toupper(.scalar_chr(level_colors[[level_name]], default = "#4B5563"))
                if (!.is_hex_color(color_now)) color_now <- "#4B5563"
                level_focus_click <- sprintf(
                  "event.preventDefault();event.stopPropagation();Shiny.setInputValue('recluster_new_meta_level_highlight',{col:%s,level:%s,nonce:Date.now()},{priority:'event'});return false;",
                  jsonlite::toJSON(col_name, auto_unbox = TRUE),
                  jsonlite::toJSON(level_name, auto_unbox = TRUE)
                )
                level_focus_hover <- sprintf(
                  "window.__reclusterNewHoverLevel && window.__reclusterNewHoverLevel(%s,%s);",
                  jsonlite::toJSON(col_name, auto_unbox = TRUE),
                  jsonlite::toJSON(level_name, auto_unbox = TRUE)
                )
                color_swatch_click <- sprintf(
                  "event.preventDefault();event.stopPropagation();Shiny.setInputValue('recluster_new_metadata_single_color_popup',{col:%s,level:%s,nonce:Date.now()},{priority:'event'});return false;",
                  jsonlite::toJSON(col_name, auto_unbox = TRUE),
                  jsonlite::toJSON(level_name, auto_unbox = TRUE)
                )
                div(
                  class = "recluster-new-level-row",
                  onmouseenter = level_focus_hover,
                  onmouseleave = "window.__reclusterNewClearHoverLevel && window.__reclusterNewClearHoverLevel();",
                  div(
                    class = "recluster-new-level-checkbox",
                    checkboxInput(
                      inputId = .cat_level_input_id(col_name, level_name),
                      label = tags$span(
                        class = "recluster-new-level-name app-text-clamp-1",
                        title = level_name,
                        onmouseenter = level_focus_hover,
                        onclick = level_focus_click,
                        level_name
                      ),
                      value = checked_now,
                      width = "100%"
                    )
                  ),
                  div(
                    class = "recluster-new-level-color",
                    tags$span(
                      class = "recluster-new-level-color-swatch",
                      style = sprintf("background-color:%s;border:1px solid #808080;border-radius:50%%;display:inline-block;height:20px;width:20px;", color_now),
                      title = sprintf("Change %s color (%s)", level_name, color_now),
                      onclick = color_swatch_click,
                      role = "button",
                      tabindex = "0",
                      `aria-label` = sprintf("%s: %s", level_name, color_now)
                    )
                  )
                )
              })
            )
          }
          tagList(
            div(
              class = "recluster-new-meta-mode",
              div(
                class = "recluster-new-meta-mode-row",
                tags$span(class = "recluster-new-meta-mode-label", RECLUSTER_NEW_UI_TEXT$t_label_display_by),
                div(
                  class = "recluster-new-meta-mode-select",
                  selectInput(mode_id, label = NULL, choices = mode_choices, selected = mode_selected)
                )
              )
            ),
            core_ui
          )
        } else {
          div(class = "text-muted app-secondary-status", "Expand to edit filters and colors.")
        }

        tags$details(
          class = "recluster-new-metadata-col app-accordion",
          `data-accordion-group` = "recluster-new-meta-cols",
          open = if (identical(col_name, open_col)) NA else NULL,
          ontoggle = sprintf(
            "if(this.open && event && event.isTrusted){Shiny.setInputValue('recluster_new_open_col', %s, {priority:'event'});}",
            jsonlite::toJSON(col_name, auto_unbox = TRUE)
          ),
          tags$summary(
            tags$span(
              class = "app-text-clamp-1",
              title = col_name,
              col_name
            )
          ),
          div(
            class = "app-accordion-body",
            control_ui
          )
        )
      })

      tags$details(
        class = "recluster-new-metadata-bucket app-accordion",
        `data-accordion-group` = "recluster-new-meta-buckets",
        open = if (identical(bucket_name, open_bucket)) NA else NULL,
        ontoggle = sprintf(
          "if(this.open && event && event.isTrusted){Shiny.setInputValue('recluster_new_open_bucket', %s, {priority:'event'});}",
          jsonlite::toJSON(bucket_name, auto_unbox = TRUE)
        ),
        tags$summary(
          tags$span(
            class = "app-text-clamp-1",
            title = .bucket_label(bucket_name),
            .bucket_label(bucket_name)
          )
        ),
        div(class = "app-accordion-body", col_nodes)
      )
    })

    tagList(bucket_ui)
  })

  observeEvent(input$recluster_new_open_col, {
    col_now <- .scalar_chr(input$recluster_new_open_col, default = "")
    profiles <- recluster_new_data$metadata_profiles
    if (!nzchar(col_now) || !length(profiles) || !(col_now %in% names(profiles))) return(invisible(NULL))
    if (identical(.scalar_chr(recluster_new_data$metadata_open_column, default = ""), col_now)) return(invisible(NULL))
    old_col <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    recluster_new_data$metadata_open_column <- col_now
    recluster_new_data$debug_meta_switch_count <- as.integer(recluster_new_data$debug_meta_switch_count %||% 0L) + 1L
    message(sprintf(
      "[DB_META_SWITCH] #%d open_col: %s -> %s",
      as.integer(recluster_new_data$debug_meta_switch_count %||% 0L),
      if (nzchar(old_col)) old_col else "<none>",
      col_now
    ))
    invisible(NULL)
  }, ignoreInit = TRUE, priority = 1000)

  observeEvent(recluster_new_data$metadata_open_column, {
    col_now <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    profiles <- recluster_new_data$metadata_profiles
    if (!nzchar(col_now) || !length(profiles) || is.null(profiles[[col_now]])) return(invisible(NULL))

    bucket_now <- .scalar_chr(profiles[[col_now]]$bucket, default = "cluster")
    if (!identical(.scalar_chr(recluster_new_data$metadata_open_bucket, default = ""), bucket_now)) {
      recluster_new_data$metadata_open_bucket <- bucket_now
    }

    # Keep active metadata column aligned with the currently opened metadata section.
    if (!identical(.scalar_chr(recluster_new_data$metadata_active_column, default = ""), col_now)) {
      recluster_new_data$metadata_active_column <- col_now
    }

    available_cols <- names(profiles)
    genes_now <- .umap_gene_selection()$genes
    color_now <- .scalar_chr(recluster_new_data$umap_color_choice, default = "")
    display_now <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
    .db_dbg("meta_open", sprintf(
      "open_col=%s genes=%s color_now=%s display=%s",
      col_now,
      paste(genes_now, collapse = ","),
      color_now,
      display_now
    ))
    if (!identical(display_now, "gene")) {
      recluster_new_data$umap_display_mode <- "metadata"
      updateRadioButtons(session, "recluster_new_umap_display_mode", selected = "metadata")
      .set_umap_color_choice(col_now, choices = c("Single Gene Expression", available_cols, "None"))
    }
    pb_col_now <- .scalar_chr(input$recluster_new_pb_meta_col, default = "")
    if (!identical(pb_col_now, col_now)) {
      updateSelectInput(
        session,
        "recluster_new_pb_meta_col",
        choices = available_cols,
        selected = col_now
      )
    }
    invisible(NULL)
  }, ignoreInit = TRUE, priority = 900)

  observeEvent(input$recluster_new_open_bucket, {
    bucket_now <- .scalar_chr(input$recluster_new_open_bucket, default = "")
    if (nzchar(bucket_now)) recluster_new_data$metadata_open_bucket <- bucket_now
    invisible(NULL)
  }, ignoreInit = TRUE, priority = 1000)

  observeEvent(input$recluster_new_meta_level_highlight, {
    payload <- input$recluster_new_meta_level_highlight
    col_now <- .scalar_chr(payload$col, default = "")
    level_now <- .scalar_chr(payload$level, default = "")
    obj <- recluster_new_data$seurat_obj
    req(obj, nzchar(col_now), nzchar(level_now))
    md <- obj@meta.data
    req(is.data.frame(md), nrow(md), col_now %in% colnames(md))
    vals <- trimws(as.character(md[[col_now]] %||% character(0)))
    vals[is.na(vals) | !nzchar(vals)] <- "(NA)"
    hit <- unique(as.character(rownames(md)[vals %in% level_now]))
    hit <- hit[!is.na(hit) & nzchar(hit)]
    recluster_new_data$metadata_active_column <- col_now
    # Level-name click is transient highlight only (does not mutate checkbox/filter state).
    recluster_new_data$metadata_hover_active <- TRUE
    recluster_new_data$selected_cells <- hit
    invisible(NULL)
  }, ignoreInit = TRUE, priority = 1100)

  observeEvent(input$recluster_new_meta_level_highlight_clear, {
    if (isTRUE(recluster_new_data$metadata_hover_active)) {
      recluster_new_data$metadata_hover_active <- FALSE
      recluster_new_data$selected_cells <- character(0)
    }
    invisible(NULL)
  }, ignoreInit = TRUE, priority = 1090)

  metadata_filter_result <- reactive({
    obj <- recluster_new_data$seurat_obj
    profiles <- recluster_new_data$metadata_profiles
    req(obj, length(profiles))

    md <- obj@meta.data
    if (is.null(md) || !nrow(md)) {
      return(list(cells = character(0), active_cols = character(0), group_col = "", filter_state = "all"))
    }

    open_col <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    if (!nzchar(open_col) || !(open_col %in% names(profiles)) || !(open_col %in% colnames(md))) {
      return(list(cells = character(0), active_cols = character(0), group_col = "", filter_state = "all"))
    }
    p <- profiles[[open_col]]
    mode_id <- .mode_input_id(open_col)
    rng_id <- .rng_input_id(open_col)
    mode_now <- .resolved_mode(p, .scalar_chr(input[[mode_id]], default = p$default_mode %||% "category"))

    if (identical(mode_now, "range") && isTRUE(p$numeric_like) && is.finite(p$min_val) && is.finite(p$max_val) && (p$min_val < p$max_val)) {
      range_val <- input[[rng_id]] %||% c(p$min_val, p$max_val)
      if (length(range_val) != 2) return(list(cells = character(0), active_cols = open_col, group_col = open_col, filter_state = "none"))
      lo <- suppressWarnings(as.numeric(range_val[[1]]))
      hi <- suppressWarnings(as.numeric(range_val[[2]]))
      if (!is.finite(lo) || !is.finite(hi)) return(list(cells = character(0), active_cols = open_col, group_col = open_col, filter_state = "none"))
      is_full <- abs(lo - p$min_val) < 1e-8 && abs(hi - p$max_val) < 1e-8
      vals <- suppressWarnings(as.numeric(as.character(md[[open_col]])))
      if (is_full) {
        keep <- is.finite(vals)
        return(list(cells = unique(rownames(md)[keep]), active_cols = open_col, group_col = open_col, filter_state = "all"))
      }
      keep <- is.finite(vals) & vals >= lo & vals <= hi
      return(list(cells = unique(rownames(md)[keep]), active_cols = open_col, group_col = open_col, filter_state = "partial"))
    }

    selected <- .selected_levels_for_column(open_col, p)
    if (!length(selected)) return(list(cells = character(0), active_cols = open_col, group_col = open_col, filter_state = "none"))
    raw <- md[[open_col]]
    has_value <- .metadata_has_value(raw)
    vals <- trimws(as.character(raw %||% ""))
    is_full <- length(selected) == length(p$levels)
    if (is_full) {
      keep <- has_value
      return(list(cells = unique(rownames(md)[keep]), active_cols = open_col, group_col = open_col, filter_state = "all"))
    }
    keep <- has_value & vals %in% selected
    list(cells = unique(rownames(md)[keep]), active_cols = open_col, group_col = open_col, filter_state = "partial")
  })

  observeEvent(metadata_filter_result(), {
    res <- metadata_filter_result()
    next_active_col <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    next_active_cells <- character(0)
    if (length(res$active_cols)) {
      open_col <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
      next_active_col <- if (nzchar(open_col)) open_col else .scalar_chr(res$group_col, "")
      next_active_cells <- as.character(res$cells %||% character(0))
    } else {
      next_active_col <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
      next_active_cells <- character(0)
    }
    if (!identical(.scalar_chr(recluster_new_data$metadata_active_column, default = ""), next_active_col)) {
      recluster_new_data$metadata_active_column <- next_active_col
    }
    if (!identical(as.character(recluster_new_data$metadata_active_cells %||% character(0)), next_active_cells)) {
      recluster_new_data$metadata_active_cells <- next_active_cells
    }
    filter_state_now <- .scalar_chr(res$filter_state, default = "all")
    if (!identical(.scalar_chr(recluster_new_data$metadata_filter_state, default = "all"), filter_state_now)) {
      recluster_new_data$metadata_filter_state <- filter_state_now
    }
    if (length(res$active_cols) && !identical(filter_state_now, "all") && length(recluster_new_data$selected_cells)) {
      recluster_new_data$selected_cells <- character(0)
    }
  }, ignoreInit = TRUE)

  checked_population_cells <- reactive({
    res <- metadata_filter_result()
    if (!length(res$active_cols) || identical(.scalar_chr(res$filter_state, default = "none"), "none")) {
      return(character(0))
    }
    cells <- unique(as.character(res$cells %||% character(0)))
    cells[nzchar(cells)]
  })

  # Agent note: Population colors use Figure Studio's popup picker. Keep the
  # metadata level order in this context so palette positions remain stable
  # if the dynamic filter UI re-renders while the modal is open.
  observeEvent(input$recluster_new_metadata_color_popup, {
    obj <- recluster_new_data$seurat_obj
    profiles <- recluster_new_data$metadata_profiles
    req(obj, length(profiles))
    col_name <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    p <- profiles[[col_name]]
    if (is.null(p)) return(invisible(NULL))
    mode_now <- .resolved_mode(
      p,
      .scalar_chr(input[[.mode_input_id(col_name)]], default = p$default_mode %||% "category")
    )
    if (!identical(mode_now, "category")) return(invisible(NULL))
    levels <- as.character(p$levels %||% character(0))
    levels <- levels[!is.na(levels) & nzchar(levels)]
    if (!length(levels)) return(invisible(NULL))

    level_map <- .level_color_map(obj, col_name, levels)
    fallback <- vapply(levels, function(level_name) {
      color_now <- toupper(.scalar_chr(level_map[[level_name]], default = "#4B5563"))
      if (.is_hex_color(color_now)) color_now else "#4B5563"
    }, character(1))
    seed <- figure_palette_seed(fallback, fallback = fallback[[1]])
    session$userData$recluster_new_metadata_palette_context <- list(
      column = col_name,
      levels = levels,
      fallback = fallback
    )

    showModal(figure_dark_modal_dialog(
      title = sprintf("%s: %s", RECLUSTER_NEW_UI_TEXT$t_title_metadata_customize_colors, col_name),
      size = "l",
      easyClose = TRUE,
      footer = figure_picker_modal_footer(
        reset_id = "recluster_new_metadata_palette_reset",
        apply_id = "recluster_new_metadata_palette_apply",
        apply_label = RECLUSTER_NEW_UI_TEXT$t_btn_metadata_apply_colors
      ),
      figure_curve_palette_modal_body(
        picker_id = "recluster_new_metadata_palette_picker",
        initial_hex = seed$initial_hex,
        palette_n = seed$palette_n,
        interpolation = "hsl",
        label = RECLUSTER_NEW_UI_TEXT$t_label_metadata_population_colors
      )
    ))
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_metadata_palette_apply, {
    context <- session$userData$recluster_new_metadata_palette_context
    if (!is.list(context)) return(invisible(NULL))
    col_name <- .scalar_chr(context$column, default = "")
    levels <- as.character(context$levels %||% character(0))
    fallback <- toupper(as.character(context$fallback %||% character(0)))
    if (!nzchar(col_name) || !length(levels)) return(invisible(NULL))

    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))
    palette <- figure_palette_from_payload(metadata_palette_picker(), fallback = fallback)
    palette <- toupper(as.character(palette %||% character(0)))
    palette <- palette[vapply(palette, .is_hex_color, logical(1))]
    if (!length(palette)) return(invisible(NULL))
    if (length(palette) != length(levels)) {
      palette <- grDevices::colorRampPalette(palette)(length(levels))
    }
    next_map <- stats::setNames(as.list(palette[seq_along(levels)]), levels)

    if (!identical(.canonical_color_map(next_map), .canonical_color_map(.read_metadata_level_colors(obj, col_name)))) {
      obj <- .write_metadata_level_colors(obj, col_name, next_map)
      recluster_new_data$seurat_obj <- obj
      .persist_active_object(obj)
      .sync_metadata_profiles_from_object(obj)
      recluster_new_data$umap_color_tick <- isolate(recluster_new_data$umap_color_tick) + 1L
    }
    session$userData$recluster_new_metadata_palette_context <- NULL
    removeModal()
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_metadata_single_color_popup, {
    payload <- input$recluster_new_metadata_single_color_popup
    col_name <- .scalar_chr(payload$col, default = "")
    level_name <- .scalar_chr(payload$level, default = "")
    obj <- recluster_new_data$seurat_obj
    profiles <- recluster_new_data$metadata_profiles
    p <- profiles[[col_name]]
    if (is.null(obj) || !inherits(obj, "Seurat") || is.null(p) || !nzchar(level_name)) {
      return(invisible(NULL))
    }
    levels <- as.character(p$levels %||% character(0))
    if (!(level_name %in% levels)) return(invisible(NULL))
    level_map <- .level_color_map(obj, col_name, levels)
    initial_hex <- toupper(.scalar_chr(level_map[[level_name]], default = "#4B5563"))
    if (!.is_hex_color(initial_hex)) initial_hex <- "#4B5563"
    session$userData$recluster_new_metadata_single_color_context <- list(
      column = col_name,
      level = level_name
    )
    showModal(figure_dark_modal_dialog(
      title = sprintf("Color: %s", level_name),
      size = "m",
      easyClose = TRUE,
      footer = figure_picker_modal_footer(
        reset_id = "recluster_new_metadata_single_color_reset",
        apply_id = "recluster_new_metadata_single_color_apply",
        apply_label = "Apply color"
      ),
          motion_color_picker_ui(
        "recluster_new_metadata_single_color_picker",
        label = level_name,
        mode = "single",
        initial_hex = initial_hex,
        initial_alpha = 1
      )
    ))
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_metadata_single_color_apply, {
    context <- session$userData$recluster_new_metadata_single_color_context
    if (!is.list(context)) return(invisible(NULL))
    col_name <- .scalar_chr(context$column, default = "")
    level_name <- .scalar_chr(context$level, default = "")
    obj <- recluster_new_data$seurat_obj
    profiles <- recluster_new_data$metadata_profiles
    p <- profiles[[col_name]]
    if (is.null(obj) || !inherits(obj, "Seurat") || is.null(p) || !nzchar(level_name)) {
      return(invisible(NULL))
    }
    levels <- as.character(p$levels %||% character(0))
    if (!(level_name %in% levels)) return(invisible(NULL))
    next_color <- toupper(.scalar_chr(metadata_single_color_picker()$hex, default = ""))
    if (!.is_hex_color(next_color)) return(invisible(NULL))
    next_map <- .level_color_map(obj, col_name, levels)
    next_map[[level_name]] <- next_color
    obj <- .write_metadata_level_colors(obj, col_name, next_map)
    recluster_new_data$seurat_obj <- obj
    .persist_active_object(obj)
    .sync_metadata_profiles_from_object(obj)
    recluster_new_data$umap_color_tick <- isolate(recluster_new_data$umap_color_tick) + 1L
    session$userData$recluster_new_metadata_single_color_context <- NULL
    removeModal()
  }, ignoreInit = TRUE)


  output$recluster_new_metadata_status_output <- renderText({
    active_col <- .scalar_chr(recluster_new_data$metadata_active_column, default = "")
    if (!nzchar(active_col)) {
      sprintf("%s %s", RECLUSTER_NEW_UI_TEXT$t_text_selection_source, RECLUSTER_NEW_UI_TEXT$t_text_selection_none)
    } else {
      sprintf("%s %s", RECLUSTER_NEW_UI_TEXT$t_text_selection_source, active_col)
    }
  })

  observeEvent(input$recluster_new_add_selection_btn, {
    group_name <- trimws(.scalar_chr(input$recluster_new_group_name, default = ""))
    cells <- unique(as.character(all_selected_cells() %||% character(0)))
    cells <- cells[nzchar(cells)]
    if (!nzchar(group_name)) {
      showNotification("Group name cannot be empty.", type = "warning", duration = 4)
      return(invisible(NULL))
    }
    if (!length(cells)) {
      showNotification("No cells are selected to save.", type = "warning", duration = 4)
      return(invisible(NULL))
    }

    obj <- recluster_new_data$seurat_obj
    new_col <- ""
    if (!is.null(obj) && inherits(obj, "Seurat")) {
      md <- obj@meta.data
      md <- .sparsify_saved_group_metadata(md, recluster_new_data$cell_groups %||% list())
      new_col <- .unique_metadata_col_name(md, group_name, prefix = "saved_group")
      md[[new_col]] <- NA_character_
      md[rownames(md) %in% cells, new_col] <- group_name
      obj@meta.data <- md
      .persist_active_object(obj)
      .refresh_metadata_after_object_update(obj, open_col = new_col)
      showNotification(sprintf("Saved group and wrote metadata column '%s'.", new_col), type = "message", duration = 4)
    }
    recluster_new_data$cell_groups[[group_name]] <- list(cells = cells, enabled = FALSE, metadata_col = new_col)
    updateTextInput(session, "recluster_new_group_name", value = "")
    runjs("Shiny.setInputValue('plotly_selected-recluster_new_plot_source', null);")
  })

  output$recluster_new_cell_groups_ui <- renderUI({
    groups <- recluster_new_data$cell_groups
    if (!length(groups)) return(p(RECLUSTER_NEW_UI_TEXT$t_text_no_groups))

    rows <- lapply(names(groups), function(name) {
      g <- groups[[name]]
      enabled_id <- .grp_toggle_input_id(name)
      delete_id <- .grp_delete_input_id(name)
      enabled <- isTRUE(g$enabled)

      div(
        class = "recluster-new-group-row",
        div(
          class = "recluster-new-group-toggle",
          checkboxInput(
            enabled_id,
            label = HTML(sprintf(
              "%s <span class='recluster-new-group-meta'>(%d cells)</span>",
              htmltools::htmlEscape(name),
              length(unique(as.character(g$cells %||% character(0))))
            )),
            value = enabled,
            width = "100%"
          )
        ),
        actionButton(delete_id, "", icon = icon("trash"), class = "btn recluster-new-saved-group-delete", title = RECLUSTER_NEW_UI_TEXT$t_btn_delete)
      )
    })

    tagList(rows)
  })

  # Agent note: Dynamic group checkboxes are re-created by renderUI. Keep one observer pair per group and ignore unchanged values; otherwise binding initialization feeds back into cell_groups and redraws the page indefinitely.
  group_toggle_observers <- list()
  observe({
    groups <- recluster_new_data$cell_groups %||% list()
    observer_registry <- group_toggle_observers
    group_names <- names(groups)

    stale_names <- setdiff(names(observer_registry), group_names)
    for (name in stale_names) {
      observer_registry[[name]]$enabled$destroy()
      observer_registry[[name]]$delete$destroy()
      observer_registry[[name]] <- NULL
    }

    new_names <- setdiff(group_names, names(observer_registry))
    for (new_name in new_names) {
      observer_registry[[new_name]] <- local({
        name <- new_name
        enabled_id <- .grp_toggle_input_id(name)
        delete_id <- .grp_delete_input_id(name)

        list(
          enabled = observeEvent(input[[enabled_id]], {
            g <- recluster_new_data$cell_groups[[name]]
            if (is.null(g)) return(invisible(NULL))
            next_enabled <- isTRUE(input[[enabled_id]])
            if (identical(isTRUE(g$enabled), next_enabled)) return(invisible(NULL))
            g$enabled <- next_enabled
            recluster_new_data$cell_groups[[name]] <- g
          }, ignoreInit = TRUE),
          delete = observeEvent(input[[delete_id]], {
            g <- recluster_new_data$cell_groups[[name]]
            obj <- recluster_new_data$seurat_obj
            if (!is.null(obj) && inherits(obj, "Seurat")) {
              md <- obj@meta.data
              meta_col <- .saved_group_metadata_col(name, g, md)
              if (nzchar(meta_col) && meta_col %in% colnames(md)) {
                md[[meta_col]] <- NULL
                obj@meta.data <- md
                .persist_active_object(obj)
                .refresh_metadata_after_object_update(obj)
                showNotification(sprintf("Deleted saved group metadata column '%s'.", meta_col), type = "message", duration = 3)
              }
            }
            recluster_new_data$cell_groups[[name]] <- NULL
          }, ignoreInit = TRUE)
        )
      })
    }

    group_toggle_observers <<- observer_registry
    session$userData$recluster_new_group_toggle_observer_count <- length(observer_registry)
  })

  .meta_preview_df <- reactive({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    md <- obj@meta.data
    md$cell <- rownames(md)
    md <- md[, c("cell", setdiff(colnames(md), "cell")), drop = FALSE]
    md
  })

  output$recluster_new_meta_table <- renderDT({
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj)) {
      return(datatable(data.frame(note = "Load data and select an active object first."), rownames = FALSE, options = list(dom = "t")))
    }
    df <- .meta_preview_df()
    if (nrow(df) > 2000) df <- df[seq_len(2000), , drop = FALSE]
    datatable(
      df,
      class = "compact nowrap",
      rownames = FALSE,
      selection = "multiple",
      options = list(
        dom = "t",
        scrollX = TRUE,
        autoWidth = TRUE,
        scrollCollapse = TRUE,
        pageLength = 25,
        lengthMenu = list(c(15, 25, 50, 100), c("15", "25", "50", "100")),
        ordering = FALSE,
        searching = FALSE,
        info = FALSE
      )
    )
  }, server = TRUE)

  observeEvent(input$recluster_new_duplicate_col_btn, {
    obj <- recluster_new_data$seurat_obj
    req(obj)
    src <- .scalar_chr(input$recluster_new_source_col, default = "")
    new_col <- .scalar_chr(input$recluster_new_new_col, default = "")
    req(nzchar(src), src %in% colnames(obj@meta.data), nzchar(new_col))
    md <- obj@meta.data
    out_col <- .ensure_unique_col(md, new_col)
    md[[out_col]] <- as.character(md[[src]])
    obj@meta.data <- md
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    entry <- shared_data$all_seurat_objects[[nm]]
    if (is.list(entry) && !is.null(entry$obj)) entry$obj <- obj else entry <- obj
    shared_data$all_seurat_objects[[nm]] <- entry
    recluster_new_data$seurat_obj <- obj
    showNotification(sprintf("Created duplicated column: %s", out_col), type = "message")
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_create_col_btn, {
    obj <- recluster_new_data$seurat_obj
    req(obj)
    new_col <- .scalar_chr(input$recluster_new_new_col, default = "")
    req(nzchar(new_col))
    md <- obj@meta.data
    out_col <- .ensure_unique_col(md, new_col)
    md[[out_col]] <- NA_character_
    obj@meta.data <- md
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    entry <- shared_data$all_seurat_objects[[nm]]
    if (is.list(entry) && !is.null(entry$obj)) entry$obj <- obj else entry <- obj
    shared_data$all_seurat_objects[[nm]] <- entry
    recluster_new_data$seurat_obj <- obj
    showNotification(sprintf("Created empty column: %s", out_col), type = "message")
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_apply_group_label_btn, {
    obj <- recluster_new_data$seurat_obj
    req(obj)
    gc <- .scalar_chr(input$recluster_new_group_col, default = "")
    gv <- .scalar_chr(input$recluster_new_group_level, default = "")
    tc <- .scalar_chr(input$recluster_new_relabel_target_col, default = "")
    tv <- .scalar_chr(input$recluster_new_relabel_value, default = "")
    req(nzchar(gc), nzchar(gv), nzchar(tc), nzchar(tv), gc %in% colnames(obj@meta.data))
    md <- obj@meta.data
    out_col <- if (tc %in% colnames(md)) tc else .ensure_unique_col(md, tc)
    if (!(out_col %in% colnames(md))) md[[out_col]] <- NA_character_
    idx <- as.character(md[[gc]] %||% "") == gv
    md[idx, out_col] <- tv
    obj@meta.data <- md
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    entry <- shared_data$all_seurat_objects[[nm]]
    if (is.list(entry) && !is.null(entry$obj)) entry$obj <- obj else entry <- obj
    shared_data$all_seurat_objects[[nm]] <- entry
    recluster_new_data$seurat_obj <- obj
    showNotification(sprintf("Updated %d cells in %s.", sum(idx), out_col), type = "message")
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_apply_cell_label_btn, {
    obj <- recluster_new_data$seurat_obj
    req(obj)
    sel <- input$recluster_new_meta_table_rows_selected
    req(length(sel) > 0)
    df <- .meta_preview_df()
    if (nrow(df) > 2000) df <- df[seq_len(2000), , drop = FALSE]
    cells <- as.character(df$cell[sel] %||% character(0))
    tc <- .scalar_chr(input$recluster_new_cell_target_col, default = "")
    tv <- .scalar_chr(input$recluster_new_cell_label_value, default = "")
    req(nzchar(tc), nzchar(tv))
    md <- obj@meta.data
    out_col <- if (tc %in% colnames(md)) tc else .ensure_unique_col(md, tc)
    if (!(out_col %in% colnames(md))) md[[out_col]] <- NA_character_
    cells <- cells[cells %in% rownames(md)]
    md[cells, out_col] <- tv
    obj@meta.data <- md
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    entry <- shared_data$all_seurat_objects[[nm]]
    if (is.list(entry) && !is.null(entry$obj)) entry$obj <- obj else entry <- obj
    shared_data$all_seurat_objects[[nm]] <- entry
    recluster_new_data$seurat_obj <- obj
    showNotification(sprintf("Updated %d selected cells in %s.", length(cells), out_col), type = "message")
  }, ignoreInit = TRUE)

  output$recluster_new_sidebar_barcode_source_ui <- renderUI({
    tab <- shared_data$imported_tabular_files
    if (is.null(tab) || !is.data.frame(tab) || !nrow(tab) || !all(c("name", "path") %in% colnames(tab))) {
      return(helpText("No imported tabular files available from Data Files."))
    }
    tab <- tab[!is.na(tab$path) & nzchar(as.character(tab$path)), , drop = FALSE]
    if (!nrow(tab)) return(helpText("No imported tabular files available from Data Files."))
    labels <- sprintf("%s (%s)", as.character(tab$name), basename(as.character(tab$path)))
    choices <- stats::setNames(as.character(tab$path), labels)
    selectizeInput(
      "recluster_new_sidebar_barcode_paths",
      RECLUSTER_NEW_UI_TEXT$t_label_sidebar_barcodes,
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
    current <- as.character(input$recluster_new_sidebar_barcode_paths %||% character(0))
    updateSelectizeInput(session, "recluster_new_sidebar_barcode_paths", selected = unique(c(current, paths)), server = TRUE)
    invisible(NULL)
  }, ignoreInit = TRUE)

  .apply_imported_barcodes <- function(barcodes, source_label = "file") {
    req(recluster_new_data$seurat_obj)
    barcodes <- unique(trimws(as.character(barcodes %||% character(0))))
    barcodes <- barcodes[nzchar(barcodes)]
    if (!length(barcodes)) {
      showNotification(sprintf("No barcode values found in %s.", source_label), type = "warning")
      return(invisible(FALSE))
    }
    all_cells <- colnames(recluster_new_data$seurat_obj)
    matched <- .match_barcodes_to_cells(barcodes, all_cells)
    recluster_new_data$selected_cells <- unique(c(recluster_new_data$selected_cells, matched))
    recluster_new_data$imported_barcode_sources <- unique(c(recluster_new_data$imported_barcode_sources, source_label))
    showNotification(sprintf("Imported %d barcodes from %s. Matched %d cell(s).", length(barcodes), source_label, length(matched)), type = "message")
    invisible(TRUE)
  }

  observeEvent(input$recluster_new_import_barcodes_file, {
    file <- input$recluster_new_import_barcodes_file
    req(file)
    tryCatch({
      barcodes <- .read_barcodes_from_path(file$datapath)
      .apply_imported_barcodes(barcodes, source_label = file$name %||% "uploaded file")
    }, error = function(e) {
      showNotification(paste("Error importing barcodes:", e$message), type = "error")
    })
  })

  observeEvent(input$recluster_new_import_sidebar_barcodes_btn, {
    req(recluster_new_data$seurat_obj)
    paths <- unique(as.character(input$recluster_new_sidebar_barcode_paths %||% character(0)))
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

  .import_df <- reactiveVal(NULL)
  .import_match <- reactiveVal(data.frame())
  recluster_new_latest_import <- reactiveVal(data.frame())

  .guess_umap_axis_cols <- function(nms) {
    nms <- as.character(nms %||% character(0))
    if (!length(nms)) return(list(x = "", y = ""))
    lc <- tolower(nms)
    idx_x <- which(
      grepl("(^|[^a-z])umap([^a-z]|$).*\\bx\\b", lc) |
      grepl("\\bx\\b.*(^|[^a-z])umap([^a-z]|$)", lc) |
      grepl("\\bumap[_\\.]?1\\b|\\bx[_\\.]?umap\\b|\\bumap[_\\.]?x\\b", lc)
    )
    idx_y <- which(
      grepl("(^|[^a-z])umap([^a-z]|$).*\\by\\b", lc) |
      grepl("\\by\\b.*(^|[^a-z])umap([^a-z]|$)", lc) |
      grepl("\\bumap[_\\.]?2\\b|\\by[_\\.]?umap\\b|\\bumap[_\\.]?y\\b", lc)
    )
    list(
      x = if (length(idx_x)) nms[[idx_x[[1]]]] else "",
      y = if (length(idx_y)) nms[[idx_y[[1]]]] else ""
    )
  }
  .guess_cluster_col <- function(nms) {
    nms <- as.character(nms %||% character(0))
    if (!length(nms)) return("")
    lc <- tolower(nms)
    idx <- which(grepl("cluster|clustering|graphcluster|louvain|leiden|seurat", lc))
    if (length(idx)) nms[[idx[[1]]]] else ""
  }

  output$recluster_new_import_col_selector_ui <- renderUI({
    df <- .import_df()
    if (is.null(df)) return(helpText("Upload a metadata file first."))
    nms <- colnames(df)
    b_guess <- grep("barcode|cell", nms, ignore.case = TRUE, value = TRUE)
    b_def <- if (length(b_guess)) b_guess[[1]] else nms[[1]]
    umap_guess <- .guess_umap_axis_cols(nms)
    cluster_guess <- .guess_cluster_col(nms)
    tagList(
      fluidRow(
        column(4, selectInput("recluster_new_import_barcode_col", RECLUSTER_NEW_UI_TEXT$t_label_import_barcode_col, choices = nms, selected = b_def)),
        column(4, selectInput("recluster_new_import_sample_col", RECLUSTER_NEW_UI_TEXT$t_label_import_sample_col, choices = c("", nms), selected = "")),
        column(4, selectizeInput("recluster_new_import_meta_cols", RECLUSTER_NEW_UI_TEXT$t_label_import_meta_cols, choices = setdiff(nms, b_def), selected = setdiff(nms, b_def), multiple = TRUE))
      ),
      fluidRow(
        column(4, selectInput("recluster_new_import_umap_x_col", RECLUSTER_NEW_UI_TEXT$t_label_import_umap_x, choices = c("None" = "", stats::setNames(nms, nms)), selected = umap_guess$x %||% "")),
        column(4, selectInput("recluster_new_import_umap_y_col", RECLUSTER_NEW_UI_TEXT$t_label_import_umap_y, choices = c("None" = "", stats::setNames(nms, nms)), selected = umap_guess$y %||% "")),
        column(4, selectInput("recluster_new_import_cluster_col", RECLUSTER_NEW_UI_TEXT$t_label_import_cluster, choices = c("None" = "", stats::setNames(nms, nms)), selected = cluster_guess %||% ""))
      )
    )
  })

  observeEvent(input$recluster_new_meta_file, {
    req(input$recluster_new_meta_file)
    fp <- input$recluster_new_meta_file$datapath
    nm <- tolower(input$recluster_new_meta_file$name %||% "")
    df <- tryCatch({
      if (grepl("\\.csv$", nm)) utils::read.csv(fp, stringsAsFactors = FALSE, check.names = FALSE)
      else utils::read.delim(fp, stringsAsFactors = FALSE, check.names = FALSE)
    }, error = function(e) NULL)
    if (is.null(df) || !nrow(df)) {
      showNotification("Could not parse metadata file.", type = "error")
      return(invisible(NULL))
    }
    .import_df(df)
    .import_match(data.frame())
    invisible(NULL)
  }, ignoreInit = TRUE)

  output$recluster_new_import_preview_table <- renderDT({
    df <- .import_df()
    if (is.null(df)) return(datatable(data.frame(note = "No import file loaded yet."), rownames = FALSE, options = list(dom = "t")))
    datatable(utils::head(df, 200), class = "compact nowrap", rownames = FALSE, options = list(dom = "t", scrollX = TRUE, autoWidth = TRUE, scrollCollapse = TRUE, pageLength = 8, ordering = FALSE, searching = FALSE, info = FALSE))
  }, server = TRUE)

  observeEvent(input$recluster_new_run_match_btn, {
    obj <- recluster_new_data$seurat_obj
    req(obj)
    df <- .import_df()
    req(df)
    bc_col <- .scalar_chr(input$recluster_new_import_barcode_col, default = "")
    req(nzchar(bc_col), bc_col %in% colnames(df))
    sample_col <- .scalar_chr(input$recluster_new_import_sample_col, default = "")
    md <- obj@meta.data
    cells <- rownames(md)
    sample_md_col <- c("orig.ident", "sample", "condition")
    sample_md_col <- sample_md_col[sample_md_col %in% colnames(md)]
    sample_md_col <- if (length(sample_md_col)) sample_md_col[[1]] else ""
    out <- vector("list", nrow(df))
    for (i in seq_len(nrow(df))) {
      bc <- as.character(df[[bc_col]][i] %||% "")
      cands <- .match_barcodes_to_cells(bc, cells)
      cands <- cands[nzchar(cands)]
      in_sample <- if (nzchar(sample_col) && sample_col %in% colnames(df)) as.character(df[[sample_col]][i] %||% "") else ""
      if (length(cands) > 1L && nzchar(in_sample) && nzchar(sample_md_col)) {
        keep <- as.character(md[cands, sample_md_col]) == in_sample
        cands <- cands[keep]
      }
      status <- if (!length(cands)) "unresolved" else if (length(cands) == 1L) "matched" else "ambiguous"
      chosen <- if (length(cands) == 1L) cands[[1]] else ""
      out[[i]] <- data.frame(
        row_id = i,
        input_barcode = bc,
        candidate_cells = paste(utils::head(cands, 8), collapse = ";"),
        chosen_cell = chosen,
        status = status,
        decision = if (identical(status, "matched")) "accept" else "review",
        stringsAsFactors = FALSE
      )
    }
    mdf <- do.call(rbind, out)
    .import_match(mdf)
    recluster_new_latest_import(mdf)
    showNotification(sprintf("Match complete: %d matched, %d ambiguous, %d unresolved.", sum(mdf$status == "matched"), sum(mdf$status == "ambiguous"), sum(mdf$status == "unresolved")), type = "message")
  }, ignoreInit = TRUE)

  output$recluster_new_import_match_table <- renderDT({
    m <- recluster_new_latest_import()
    if (!is.data.frame(m) || !nrow(m)) {
      return(datatable(data.frame(note = "No import matching has been run yet."), rownames = FALSE, options = list(dom = "t")))
    }
    datatable(m, class = "compact nowrap", rownames = FALSE, options = list(dom = "t", scrollX = TRUE, autoWidth = TRUE, scrollCollapse = TRUE, pageLength = 8, ordering = FALSE, searching = FALSE, info = FALSE))
  }, server = TRUE)

  output$recluster_new_import_resolution_table <- renderDT({
    m <- .import_match()
    if (!is.data.frame(m) || !nrow(m)) {
      return(datatable(data.frame(note = "Run barcode matching first."), rownames = FALSE, options = list(dom = "t")))
    }
    need_cols <- c("row_id", "input_barcode", "candidate_cells", "chosen_cell", "status", "decision")
    missing_cols <- setdiff(need_cols, colnames(m))
    if (length(missing_cols)) {
      for (cn in missing_cols) m[[cn]] <- NA_character_
    }
    m <- m[, need_cols, drop = FALSE]
    datatable(m, class = "compact nowrap", rownames = FALSE, editable = list(target = "cell", disable = list(columns = c(0, 1, 2, 4))), options = list(dom = "t", scrollX = TRUE, autoWidth = TRUE, scrollCollapse = TRUE, pageLength = 8, ordering = FALSE, searching = FALSE, info = FALSE))
  }, server = TRUE)

  observeEvent(input$recluster_new_import_resolution_table_cell_edit, {
    info <- input$recluster_new_import_resolution_table_cell_edit
    m <- .import_match()
    req(is.data.frame(m), nrow(m))
    i <- info$row
    j <- info$col + 1L
    cols <- c("row_id", "input_barcode", "candidate_cells", "chosen_cell", "status", "decision")
    req(i >= 1, i <= nrow(m), j >= 1, j <= length(cols))
    target <- cols[[j]]
    if (!target %in% c("chosen_cell", "decision")) return(invisible(NULL))
    val <- as.character(info$value %||% "")
    if (identical(target, "decision")) {
      allowed <- c("accept", "resolved", "drop", "review")
      if (!val %in% allowed) {
        showNotification("Decision must be one of: accept, resolved, drop, review.", type = "warning")
        return(invisible(NULL))
      }
    }
    m[i, target] <- val
    .import_match(m)
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_apply_import_btn, {
    obj <- recluster_new_data$seurat_obj
    req(obj)
    raw_df <- .import_df()
    req(raw_df)
    mdf <- .import_match()
    req(is.data.frame(mdf), nrow(mdf) > 0)
    keep <- mdf$decision %in% c("accept", "resolved")
    mdf2 <- mdf[keep, , drop = FALSE]
    mdf2 <- mdf2[nzchar(as.character(mdf2$chosen_cell)), , drop = FALSE]
    req(nrow(mdf2) > 0)
    meta_cols <- as.character(input$recluster_new_import_meta_cols %||% character(0))
    bc_col <- .scalar_chr(input$recluster_new_import_barcode_col, default = "")
    if (!length(meta_cols)) meta_cols <- setdiff(colnames(raw_df), bc_col)
    meta_cols <- meta_cols[meta_cols %in% colnames(raw_df)]
    umap_x_col <- .scalar_chr(input$recluster_new_import_umap_x_col, default = "")
    umap_y_col <- .scalar_chr(input$recluster_new_import_umap_y_col, default = "")
    cluster_col <- .scalar_chr(input$recluster_new_import_cluster_col, default = "")
    special_cols <- unique(c(if (nzchar(umap_x_col)) umap_x_col else character(0), if (nzchar(umap_y_col)) umap_y_col else character(0), if (nzchar(cluster_col)) cluster_col else character(0)))
    special_cols <- special_cols[special_cols %in% colnames(raw_df)]
    meta_cols <- unique(c(meta_cols, special_cols))
    req(length(meta_cols) > 0 || length(special_cols) > 0)
    joined <- merge(mdf2, cbind(row_id = seq_len(nrow(raw_df)), raw_df), by = "row_id", all.x = TRUE, sort = FALSE)
    md <- obj@meta.data
    for (cn in meta_cols) {
      out_col <- .ensure_unique_col(md, paste0("import_", .safe_key(cn)))
      md[[out_col]] <- NA_character_
      vec <- as.character(joined[[cn]])
      names(vec) <- as.character(joined$chosen_cell)
      vec <- vec[names(vec) %in% rownames(md)]
      md[names(vec), out_col] <- vec
    }
    if (nzchar(cluster_col) && cluster_col %in% colnames(joined)) {
      out_cluster_col <- .ensure_unique_col(md, paste0("loupe_", .safe_key(cluster_col)))
      md[[out_cluster_col]] <- NA_character_
      vec_cluster <- as.character(joined[[cluster_col]])
      names(vec_cluster) <- as.character(joined$chosen_cell)
      vec_cluster <- vec_cluster[names(vec_cluster) %in% rownames(md)]
      md[names(vec_cluster), out_cluster_col] <- vec_cluster
    }
    if (nzchar(umap_x_col) && nzchar(umap_y_col) && umap_x_col %in% colnames(joined) && umap_y_col %in% colnames(joined)) {
      out_x <- .ensure_unique_col(md, "loupe_umap_x")
      out_y <- .ensure_unique_col(md, "loupe_umap_y")
      md[[out_x]] <- NA_real_
      md[[out_y]] <- NA_real_
      vx <- suppressWarnings(as.numeric(joined[[umap_x_col]]))
      vy <- suppressWarnings(as.numeric(joined[[umap_y_col]]))
      nm_cells <- as.character(joined$chosen_cell)
      names(vx) <- nm_cells
      names(vy) <- nm_cells
      keep2 <- names(vx) %in% rownames(md)
      if (any(keep2)) {
        md[names(vx)[keep2], out_x] <- vx[keep2]
        md[names(vy)[keep2], out_y] <- vy[keep2]
      }
    }
    obj@meta.data <- md
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    entry <- shared_data$all_seurat_objects[[nm]]
    if (is.list(entry) && !is.null(entry$obj)) entry$obj <- obj else entry <- obj
    shared_data$all_seurat_objects[[nm]] <- entry
    recluster_new_data$seurat_obj <- obj
    recluster_new_latest_import(mdf)
    showNotification("Applied matched metadata import.", type = "message")
  }, ignoreInit = TRUE)

  gene_to_display_1 <- reactive({
    vals <- as.character(recluster_new_data$umap_gene_values %||% c("", "", ""))
    length(vals) <- 3L
    vals[is.na(vals)] <- ""
    vals[[1]]
  })

  enabled_group_cells <- reactive({
    groups <- recluster_new_data$cell_groups
    if (!length(groups)) return(character(0))
    out <- unlist(lapply(groups, function(g) {
      if (!isTRUE(g$enabled)) return(character(0))
      as.character(g$cells %||% character(0))
    }), use.names = FALSE)
    unique(out[nzchar(out)])
  })

  .visible_umap_cells <- function() {
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(character(0))
    all_cells <- colnames(obj)

    open_col <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    profiles <- recluster_new_data$metadata_profiles %||% list()
    if (!nzchar(open_col) || !(open_col %in% names(profiles))) {
      return(all_cells)
    }

    mstate <- .scalar_chr(recluster_new_data$metadata_filter_state, default = "all")
    if (identical(mstate, "none")) return(character(0))

    cells <- unique(as.character(recluster_new_data$metadata_active_cells %||% character(0)))
    cells <- cells[nzchar(cells)]
    if (length(cells)) {
      hit <- intersect(cells, all_cells)
      if (length(hit)) return(hit)
    }

    if (identical(mstate, "all")) {
      res <- .metadata_non_na_cells(obj@meta.data, open_col)
      if (length(res)) {
        hit <- intersect(res, all_cells)
        if (length(hit)) return(hit)
      }
    }
    all_cells
  }

  .expr_base_population_cells <- function() {
    .visible_umap_cells()
  }

  .expr_gene_cells <- function(gene_row, base_cells, obj = recluster_new_data$seurat_obj) {
    if (is.null(obj) || !inherits(obj, "Seurat") || !is.list(gene_row)) return(character(0))
    gene_name <- .scalar_chr(gene_row$gene, default = "")
    if (!nzchar(gene_name)) return(character(0))
    assay_now <- .scalar_chr(input$recluster_new_assay_select, default = "")
    slot_now <- .expr_selection_slot()
    base_cells <- unique(as.character(base_cells %||% character(0)))
    base_cells <- base_cells[nzchar(base_cells)]
    if (!length(base_cells)) return(character(0))
    vals <- .fetch_gene_values(obj, assay_now, gene_name, slot_now)
    if (is.null(vals) || !length(vals)) return(character(0))
    vals <- vals[intersect(base_cells, names(vals))]
    if (!length(vals)) return(character(0))
    rng <- suppressWarnings(as.numeric(gene_row$range %||% numeric(0)))
    rng <- rng[is.finite(rng)]
    if (length(rng) < 2L) {
      range_info <- .expr_expression_range_info(vals)
      rng <- if (!is.null(range_info)) range_info$default_range else numeric(0)
    }
    if (length(rng) >= 2L) {
      rng <- sort(rng[seq_len(2L)])
      vals <- vals[vals >= rng[[1]] & vals <= rng[[2]]]
    }
    names(vals)[is.finite(vals)]
  }

  .expr_group_cells <- function(group, base_cells) {
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat") || !is.list(group)) return(character(0))
    genes <- group$genes %||% list()
    genes <- genes[vapply(genes, function(gr) isTRUE(gr$checked) && nzchar(.scalar_chr(gr$gene, default = "")), logical(1))]
    if (!length(genes)) return(character(0))
    base_cells <- unique(as.character(base_cells %||% character(0)))
    base_cells <- base_cells[nzchar(base_cells)]
    if (!length(base_cells)) return(character(0))
    gene_hits <- lapply(genes, .expr_gene_cells, base_cells = base_cells, obj = obj)
    hit <- if (isTRUE(group$require_all) && length(gene_hits)) {
      Reduce(intersect, gene_hits)
    } else {
      unique(unlist(gene_hits, use.names = FALSE))
    }
    hit <- unique(as.character(hit %||% character(0)))
    hit <- hit[nzchar(hit)]
    if (isTRUE(group$invert)) {
      return(setdiff(base_cells, hit))
    }
    hit
  }

  expression_group_cells_result <- reactive({
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    groups <- state$groups %||% list()
    empty_counts <- stats::setNames(vector("list", length(groups)), vapply(groups, function(g) .scalar_chr(g$id, default = ""), character(1)))
    empty_counts <- empty_counts[nzchar(names(empty_counts))]
    active_group <- .expr_active_group(state)
    if (is.null(active_group)) return(list(active = FALSE, cells = character(0), group_cells = empty_counts))
    active_gid <- .scalar_chr(active_group$id, default = "")
    genes <- active_group$genes %||% list()
    has_checked <- any(vapply(genes, function(gr) isTRUE(gr$checked) && nzchar(.scalar_chr(gr$gene, default = "")), logical(1)))
    if (!has_checked) return(list(active = FALSE, cells = character(0), group_cells = empty_counts))
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) {
      return(list(active = TRUE, cells = character(0), group_cells = empty_counts))
    }
    base_cells <- if (isTRUE(state$inherit_population)) .expr_base_population_cells() else colnames(obj)
    hit_cells <- .expr_group_cells(active_group, base_cells = base_cells)
    merged_group_cells <- empty_counts
    merged_group_cells[[active_gid]] <- hit_cells
    list(active = TRUE, cells = hit_cells, group_cells = merged_group_cells)
  })

  expression_selection_result <- reactive({
    res <- expression_group_cells_result()
    list(active = isTRUE(res$active), cells = as.character(res$cells %||% character(0)))
  })

  expression_active_gene_result <- reactive({
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    active <- .expr_active_gene(state)
    if (is.null(active)) return(list(active = FALSE, cells = character(0)))
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(list(active = FALSE, cells = character(0)))
    base_cells <- if (isTRUE(state$inherit_population)) .expr_base_population_cells() else colnames(obj)
    gene_row <- list(gene = active$gene, range = active$range)
    cells <- .expr_gene_cells(gene_row, base_cells = base_cells, obj = obj)
    list(active = length(cells) > 0, cells = as.character(cells %||% character(0)), gene = active$gene)
  })

  all_selected_cells <- reactive({
    visible <- .visible_umap_cells()
    group_cells <- as.character(enabled_group_cells() %||% character(0))
    lasso_cells <- as.character(lasso_selected_cells() %||% character(0))
    manual_cells <- unique(c(lasso_cells, as.character(recluster_new_data$selected_cells %||% character(0))))
    state <- .expr_state_normalize(recluster_new_data$expr_selection)

    if (length(visible)) {
      manual_cells <- intersect(manual_cells, visible)
    } else if (isTRUE(state$inherit_population)) {
      manual_cells <- character(0)
    }

    expr_result <- expression_selection_result()
    if (isTRUE(expr_result$active)) {
      expr_cells <- unique(as.character(expr_result$cells %||% character(0)))
      if (isTRUE(state$inherit_population)) {
        core <- if (length(visible)) intersect(expr_cells, visible) else character(0)
      } else {
        core <- expr_cells
      }
      selected <- unique(c(core, group_cells, manual_cells))
    } else {
      if (length(manual_cells) > 0 || length(group_cells) > 0) {
        selected <- unique(c(group_cells, manual_cells))
      } else {
        selected <- visible
      }
    }
    selected[nzchar(selected)]
  })

  selection_highlight_cells <- reactive({
    # Agent note: Violet selection fill obscures gene-expression color. Feature
    # display owns cell fill completely; selection remains active but unpainted.
    if (identical(.scalar_chr(recluster_new_data$umap_display_mode, default = "metadata"), "gene")) {
      return(character(0))
    }
    lasso_cells <- as.character(lasso_selected_cells() %||% character(0))
    manual_cells <- as.character(recluster_new_data$selected_cells %||% character(0))
    group_cells <- as.character(enabled_group_cells() %||% character(0))
    expr_result <- expression_selection_result()
    metadata_filtered <- !identical(
      .scalar_chr(recluster_new_data$metadata_filter_state, default = "all"),
      "all"
    )
    has_explicit_selection <- length(lasso_cells) > 0L ||
      length(manual_cells) > 0L ||
      length(group_cells) > 0L ||
      isTRUE(expr_result$active) ||
      metadata_filtered

    # Agent note: all_selected_cells() falls back to the visible population for
    # subset workflows. Do not render that fallback as a UMAP selection highlight.
    if (!has_explicit_selection) return(character(0))
    as.character(all_selected_cells() %||% character(0))
  })

  final_plot_df <- reactive({
    req(recluster_new_data$plot_df, recluster_new_data$seurat_obj)
    cache_sig <- .final_plot_df_signature()
    stored_sig <- isolate(recluster_new_data$final_plot_cache_sig)
    stored_cache <- isolate(recluster_new_data$final_plot_cache)
    if (nzchar(cache_sig) &&
        identical(cache_sig, stored_sig) &&
        is.data.frame(stored_cache)) {
      return(stored_cache)
    }
    plot_df <- recluster_new_data$plot_df
    obj <- recluster_new_data$seurat_obj
    red_choices <- .embedding_reduction_choices(obj)
    req(length(red_choices))
    red_sel <- .current_umap_reduction(obj)
    if (!nzchar(red_sel) || !(red_sel %in% red_choices)) red_sel <- red_choices[[1]]
    emb <- tryCatch(Seurat::Embeddings(obj, red_sel), error = function(e) NULL)
    validate(need(!is.null(emb) && is.matrix(emb) && ncol(emb) >= 2L, sprintf("Embedding '%s' is unavailable.", red_sel)))
    axis_choices <- .axis_index_choices(obj, red_sel)
    axis_vals <- as.character(axis_choices)
    x_idx <- suppressWarnings(as.integer(.scalar_chr(input$recluster_new_umap_axis_x_select, default = if (length(axis_vals)) axis_vals[[1]] else "1")))
    y_default <- if (length(axis_vals) >= 2L) axis_vals[[2]] else if (length(axis_vals)) axis_vals[[1]] else "2"
    y_idx <- suppressWarnings(as.integer(.scalar_chr(input$recluster_new_umap_axis_y_select, default = y_default)))
    if (!is.finite(x_idx) || is.na(x_idx) || x_idx < 1L || x_idx > ncol(emb)) x_idx <- 1L
    if (!is.finite(y_idx) || is.na(y_idx) || y_idx < 1L || y_idx > ncol(emb) || y_idx == x_idx) y_idx <- if (ncol(emb) >= 2L && x_idx != 2L) 2L else min(ncol(emb), max(1L, x_idx + 1L))
    if (y_idx == x_idx && ncol(emb) >= 2L) y_idx <- if (x_idx == 1L) 2L else 1L
    emb_cells <- rownames(emb)
    common_cells <- intersect(rownames(plot_df), emb_cells)
    plot_df <- plot_df[common_cells, , drop = FALSE]
    plot_df$UMAP_1 <- as.numeric(emb[common_cells, x_idx])
    plot_df$UMAP_2 <- as.numeric(emb[common_cells, y_idx])
    axis_titles <- .embedding_axis_titles(obj, red_sel, x_idx, y_idx)
    plot_df$embedding_x_title <- axis_titles$x
    plot_df$embedding_y_title <- axis_titles$y

    umap_gene_info <- .umap_gene_selection()
    gene_input_1 <- if (length(umap_gene_info$genes)) umap_gene_info$genes[[1]] else ""
    violin_gene <- gene_input_1
    effective_gene_1 <- .scalar_chr(gene_input_1, default = violin_gene)
    display_mode <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
    effective_color_mode <- if (identical(display_mode, "gene") && length(umap_gene_info$genes)) "Single Gene Expression" else .active_umap_metadata_col()
    assay_to_use <- .current_umap_assay(recluster_new_data$seurat_obj)
    slot_to_use <- .scalar_chr(input$recluster_new_slot_select, default = "data")

    plot_df$gene1_expr <- 0
    plot_df$gene2_expr <- 0
    plot_df$gene3_expr <- 0
    plot_df$gene_rgb_color <- "#7A7A7A"
    plot_df$gene_rgb_mode <- FALSE

    if (length(umap_gene_info$genes) && !isTRUE(umap_gene_info$multi) && isTruthy(effective_gene_1) && effective_color_mode == "Single Gene Expression") {
      expression_data <- .fetch_gene_values(recluster_new_data$seurat_obj, assay_to_use, effective_gene_1, slot_to_use)
      if (!is.null(expression_data)) {
        vals <- expression_data[rownames(plot_df)]
        vals[!is.finite(vals)] <- 0
        plot_df$gene1_expr <- log1p(as.numeric(vals))
      }
    }
    if (effective_color_mode == "Single Gene Expression" && isTRUE(umap_gene_info$multi)) {
      rgb_mat <- matrix(0, nrow = nrow(plot_df), ncol = 3)
      # Agent note: Gene selector slots are fixed confocal channels: 1=green,
      # 2=blue, 3=red. Preserve empty slots; compacting shifts channel identity.
      rgb_columns <- c(2L, 3L, 1L)
      for (i in seq_along(umap_gene_info$channels)) {
        g_now <- umap_gene_info$channels[[i]]
        if (!nzchar(g_now)) next
        v_now <- .fetch_gene_values(recluster_new_data$seurat_obj, assay_to_use, g_now, slot_to_use)
        if (is.null(v_now) || !length(v_now)) next
        v <- log1p(as.numeric(v_now[rownames(plot_df)]))
        v[!is.finite(v)] <- 0
        vmin <- min(v, na.rm = TRUE)
        vmax <- max(v, na.rm = TRUE)
        if (!is.finite(vmin) || !is.finite(vmax) || vmax <= vmin) {
          scaled <- rep(0, length(v))
        } else {
          scaled <- pmax(0, pmin(1, (v - vmin) / (vmax - vmin)))
        }
        rgb_mat[, rgb_columns[[i]]] <- scaled
        if (i == 1L) plot_df$gene1_expr <- v
        if (i == 2L) plot_df$gene2_expr <- v
        if (i == 3L) plot_df$gene3_expr <- v
      }
      plot_df$gene_rgb_color <- grDevices::rgb(rgb_mat[, 1], rgb_mat[, 2], rgb_mat[, 3], maxColorValue = 1)
      plot_df$gene_rgb_mode <- TRUE
    }

    plot_df$selection_status <- "Unselected"
    plot_df$selection_selected <- FALSE
    visible_cells <- .visible_umap_cells()
    
    message(sprintf("[DB_UMAP_DBG][%s][data_browser_debug] emb_cells=%d | plot_df_rows=%d | visible_cells=%d | open_col=%s",
      format(Sys.time(), "%H:%M:%OS3"), length(emb_cells), nrow(plot_df), length(visible_cells), 
      .scalar_chr(recluster_new_data$metadata_open_column, default = "<empty>")
    ))
    
    if (!length(visible_cells)) {
      plot_df <- plot_df[FALSE, , drop = FALSE]
    } else {
      plot_df <- plot_df[rownames(plot_df) %in% visible_cells, , drop = FALSE]
    }

    if (!nrow(plot_df)) {
      plot_df$cell_id <- character(0)
      return(plot_df)
    }

    selected_cells_now <- selection_highlight_cells()
    if (length(selected_cells_now) > 0) {
      hit <- intersect(selected_cells_now, rownames(plot_df))
      plot_df[hit, "selection_status"] <- "Selected"
      plot_df[hit, "selection_selected"] <- TRUE
    }
    active_gene_now <- expression_active_gene_result()
    if (isTRUE(active_gene_now$active) && length(active_gene_now$cells)) {
      active_hit <- intersect(active_gene_now$cells, rownames(plot_df))
      plot_df[active_hit, "selection_status"] <- "ActiveGene"
    }
    plot_df$cell_id <- rownames(plot_df)
    if (nzchar(cache_sig)) {
      isolate({
        recluster_new_data$final_plot_cache_sig <- cache_sig
        recluster_new_data$final_plot_cache <- plot_df
      })
    }
    plot_df
  })

  observe({
    if (!identical(.current_plot_tab(), "umap")) {
      return(invisible(NULL))
    }
    plot_cache_sig <- .umap_plot_cache_signature()
    stored_sig <- isolate(recluster_new_data$umap_plot_cache_sig)
    stored_cache <- isolate(recluster_new_data$umap_plot_cache)
    if (!identical(plot_cache_sig, stored_sig) && nzchar(plot_cache_sig) && nzchar(stored_sig)) {
      message(sprintf("[DB_UMAP_CACHE][%s] sig_len=%d | stored_len=%d | sigs_match=%s | is_plotly=%s",
        format(Sys.time(), "%H:%M:%OS3"),
        nchar(plot_cache_sig), nchar(stored_sig),
        as.character(identical(plot_cache_sig, stored_sig)),
        as.character(inherits(stored_cache, "plotly"))
      ))
      s1 <- strsplit(plot_cache_sig, "::")[[1]]
      s2 <- strsplit(stored_sig, "::")[[1]]
      min_len <- min(length(s1), length(s2))
      diff_parts <- which(s1[seq_len(min_len)] != s2[seq_len(min_len)])
      if (length(diff_parts)) {
        idx <- diff_parts[[1]]
        message(sprintf("[DB_UMAP_CACHE] first diff at part %d: NEW='%s' | OLD='%s'",
          idx, substr(s1[[idx]], 1L, 80L), substr(s2[[idx]], 1L, 80L)))
      } else if (length(s1) != length(s2)) {
        message(sprintf("[DB_UMAP_CACHE] part count diff: NEW=%d OLD=%d", length(s1), length(s2)))
      }
    }
    # --- END CACHE DIAGNOSTICS ---
    if (nzchar(plot_cache_sig) &&
        identical(plot_cache_sig, stored_sig) &&
        inherits(stored_cache, "plotly")) {
      if (is.null(isolate(umap_plot_rendered()))) { # Prevent invalidation loop by isolating reactives
        umap_plot_rendered(stored_cache)
      }
      return(invisible(NULL))
    }
    .db_dbg("umap_render", sprintf("sig=%s", substr(plot_cache_sig, 1L, 220L)))

    plot_df <- final_plot_df()
    if (!nrow(plot_df)) {
      p_empty <- plot_ly(source = "recluster_new_plot_source") %>%
        add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
        layout(
          xaxis = list(visible = FALSE),
          yaxis = list(visible = FALSE),
          annotations = list(list(
            text = "No cells currently included by metadata filter.",
            x = 0.5, y = 0.5, xref = "paper", yref = "paper", showarrow = FALSE,
            font = list(size = 15, color = "#6b7280")
          )),
          margin = list(l = 20, r = 20, t = 40, b = 20)
        ) %>%
        .plotly_touch_zoom()
      umap_plot_rendered(p_empty)
      return(invisible(NULL))
    }

    umap_gene_info <- .umap_gene_selection()
    display_mode <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
    color_by <- if (identical(display_mode, "gene") && length(umap_gene_info$genes)) "Single Gene Expression" else .active_umap_metadata_col()
    x_title <- .scalar_chr(plot_df$embedding_x_title, default = "UMAP_1")
    y_title <- .scalar_chr(plot_df$embedding_y_title, default = "UMAP_2")
    split_by <- .scalar_chr(input$recluster_new_split_by_select, default = "None")
    violin_gene <- if (length(umap_gene_info$genes)) umap_gene_info$genes[[1]] else ""

    dot_size <- suppressWarnings(as.numeric(input$recluster_new_dot_size %||% 1.0))
    dot_alpha <- suppressWarnings(as.numeric(input$recluster_new_dot_alpha %||% 0.8))
    highlight_stroke_alpha <- suppressWarnings(as.numeric(input$recluster_new_stroke_width %||% 0.1))
    if (!is.finite(dot_size) || dot_size <= 0) dot_size <- 1.0
    if (!is.finite(dot_alpha) || dot_alpha <= 0) dot_alpha <- 0.8
    if (!is.finite(highlight_stroke_alpha)) highlight_stroke_alpha <- 0.1
    highlight_stroke_alpha <- max(0, min(1, highlight_stroke_alpha))
    dot_alpha <- max(0.05, min(1, dot_alpha))
    effective_stroke_width <- 0
    base_marker_size <- max(1.8, dot_size * 3.8)
    highlight_width <- max(1.1, base_marker_size * 0.18)
    # Agent note: Selected violet fill must remain visibly larger than base dots
    # by exactly the rendered highlight stroke width.
    highlight_size <- base_marker_size + highlight_width
    stroke_color <- .scalar_chr(input$recluster_new_stroke_color, default = "black")

    .split_values <- function(df, split_col) {
      if (!isTruthy(split_col) || identical(split_col, "None") || !(split_col %in% names(df))) {
        return(rep("All cells", nrow(df)))
      }
      vals <- as.character(df[[split_col]] %||% character(0))
      vals[is.na(vals) | !nzchar(vals)] <- "(NA)"
      vals
    }

    .panel_base_plot <- function(title_txt = NULL) {
      p <- plot_ly(source = "recluster_new_plot_source")
      if (nzchar(title_txt %||% "")) {
        p <- layout(p, title = list(text = title_txt, x = 0.02, xanchor = "left", y = 0.98, yanchor = "top", font = list(size = 12)))
      }
      p
    }

    .umap_colorbar <- function(title_txt) {
      list(
        title = list(
          text = .scalar_chr(title_txt, default = ""),
          side = "top",
          font = list(size = 11, color = "#374151")
        ),
        x = 0.985,
        xanchor = "right",
        y = 0.985,
        yanchor = "top",
        len = 0.26,
        thickness = 8,
        outlinewidth = 0,
        bgcolor = "rgba(255,255,255,0.78)",
        bordercolor = "rgba(0,0,0,0.12)",
        borderwidth = 1,
        tickfont = list(size = 10, color = "#374151"),
        ticklen = 2
      )
    }

    .continuous_color_limits <- function(values) {
      values <- suppressWarnings(as.numeric(values))
      values <- values[is.finite(values)]
      if (!length(values)) return(c(0, 1))
      limits <- range(values)
      if (!all(is.finite(limits)) || identical(limits[[1]], limits[[2]])) return(c(0, 1))
      limits
    }

    # Agent note: Split panels must share one color contract computed from the
    # complete plotted population. Per-panel palettes/ranges make identical
    # values appear with different colors and invalidate cross-panel comparison.
    gene1_color_limits <- .continuous_color_limits(plot_df$gene1_expr %||% numeric(0))
    metadata_color_is_discrete <- FALSE
    metadata_color_map <- character(0)
    metadata_color_limits <- c(0, 1)
    if (isTruthy(color_by) && color_by != "None" && color_by %in% names(plot_df)) {
      metadata_values <- plot_df[[color_by]]
      metadata_color_is_discrete <- .metadata_color_as_discrete(color_by) ||
        !(is.numeric(metadata_values) || is.integer(metadata_values))
      if (isTRUE(metadata_color_is_discrete)) {
        metadata_values_chr <- as.character(metadata_values %||% character(0))
        metadata_values_chr[is.na(metadata_values_chr) | !nzchar(metadata_values_chr)] <- "(NA)"
        metadata_levels <- .sort_numeric_first(unique(metadata_values_chr))
        metadata_color_map <- .level_color_map(recluster_new_data$seurat_obj, color_by, metadata_levels)
      } else {
        metadata_color_limits <- .continuous_color_limits(metadata_values)
      }
    }
    .db_dbg("umap_color_contract", sprintf(
      "color=%s split=%s discrete=%s levels=%d limits=%s",
      color_by,
      split_by,
      as.character(metadata_color_is_discrete),
      length(metadata_color_map),
      paste(signif(if (identical(color_by, "Single Gene Expression")) gene1_color_limits else metadata_color_limits, 6), collapse = ",")
    ))

    .add_marker_trace <- function(p, df_use, marker_list, name = NULL, show_legend = FALSE, hover = "skip", legend_group = NULL) {
      x_vals <- if ("display_x" %in% names(df_use)) df_use$display_x else df_use$UMAP_1
      y_vals <- if ("display_y" %in% names(df_use)) df_use$display_y else df_use$UMAP_2
      add_trace(
        p,
        type = "scattergl",
        mode = "markers",
        x = x_vals,
        y = y_vals,
        key = df_use$cell_id,
        hoverinfo = hover,
        marker = marker_list,
        name = name %||% "",
        legendgroup = legend_group %||% "",
        showlegend = isTRUE(show_legend)
      )
    }

    .add_panel_traces <- function(p, df_panel, show_legend = TRUE, show_scale = TRUE) {
      if (!nrow(df_panel)) return(p)

      if (identical(color_by, "Single Gene Expression")) {
        rgb_mode <- isTRUE(any(df_panel$gene_rgb_mode %||% FALSE))
        if (isTRUE(rgb_mode)) {
          p <- .add_marker_trace(
            p, df_panel,
            marker_list = list(
              color = as.character(df_panel$gene_rgb_color %||% rep("#7A7A7A", nrow(df_panel))),
              size = base_marker_size,
              # Composite colors already encode intensity. Transparency here
              # dims signal together with the gray contrast background.
              opacity = 1,
              line = list(width = effective_stroke_width, color = stroke_color)
            ),
            show_legend = FALSE
          )
        } else {
          gene_lbl <- .scalar_chr(if (isTruthy(violin_gene)) violin_gene else gene_to_display_1(), default = "Gene 1")
          p <- .add_marker_trace(
            p, df_panel,
            marker_list = list(
              color = as.numeric(df_panel$gene1_expr %||% rep(0, nrow(df_panel))),
              colorscale = "Viridis",
              cmin = gene1_color_limits[[1]],
              cmax = gene1_color_limits[[2]],
              showscale = isTRUE(show_scale),
              colorbar = .umap_colorbar(gene_lbl),
              size = base_marker_size,
              opacity = dot_alpha,
              line = list(width = effective_stroke_width, color = stroke_color)
            ),
            show_legend = FALSE
          )
        }
      } else if (isTruthy(color_by) && color_by != "None" && color_by %in% names(df_panel)) {
        vals <- df_panel[[color_by]]
        if (isTRUE(metadata_color_is_discrete)) {
          vals_chr <- as.character(vals %||% character(0))
          vals_chr[is.na(vals_chr) | !nzchar(vals_chr)] <- "(NA)"
          col_vec <- unname(metadata_color_map[vals_chr])
          col_vec[!nzchar(col_vec) | is.na(col_vec)] <- "#4B5563"
          p <- .add_marker_trace(
            p, df_panel,
            marker_list = list(
              color = as.character(col_vec),
              size = base_marker_size,
              opacity = dot_alpha,
              line = list(width = effective_stroke_width, color = stroke_color)
            ),
            show_legend = FALSE
          )
        } else if (is.numeric(vals) || is.integer(vals)) {
          vv <- suppressWarnings(as.numeric(vals))
          if (!any(is.finite(vv))) vv <- rep(0, length(vv))
          p <- .add_marker_trace(
            p, df_panel,
            marker_list = list(
              color = vv,
              colorscale = "Viridis",
              cmin = metadata_color_limits[[1]],
              cmax = metadata_color_limits[[2]],
              showscale = isTRUE(show_scale),
              colorbar = .umap_colorbar(color_by),
              size = base_marker_size,
              opacity = dot_alpha,
              line = list(width = effective_stroke_width, color = stroke_color)
            ),
            show_legend = FALSE
          )
        }
      } else {
        p <- .add_marker_trace(
          p, df_panel,
          marker_list = list(
            color = "grey55",
            size = base_marker_size,
            opacity = dot_alpha,
            line = list(width = effective_stroke_width, color = stroke_color)
          ),
          show_legend = FALSE
        )
      }

      # Agent note: Keep combined selection membership separate from active-gene
      # status so orange outlines can overlay selected violet-filled cells.
      sel_panel <- df_panel[df_panel$selection_selected %in% TRUE, , drop = FALSE]
      active_panel <- df_panel[df_panel$selection_status == "ActiveGene", , drop = FALSE]
      if (nrow(sel_panel)) {
        p <- .add_marker_trace(
          p, sel_panel,
          marker_list = list(
            symbol = "circle",
            color = "#7C3AED",
            size = highlight_size,
            opacity = 0.82,
            line = list(width = 0)
          ),
          name = "Selected",
          show_legend = FALSE
        )
      }
      if (nrow(active_panel)) {
        p <- .add_marker_trace(
          p, active_panel,
          marker_list = list(
            symbol = "circle-open",
            color = "#F97316",
            size = highlight_size,
            opacity = 0.96,
            line = list(width = highlight_width, color = sprintf("rgba(249,115,22,%.3f)", highlight_stroke_alpha))
          ),
          name = "Active gene",
          show_legend = FALSE
        )
      }

      p
    }

    split_vals <- .split_values(plot_df, split_by)
    panel_levels <- .sort_numeric_first(unique(split_vals))
    if (!length(panel_levels)) panel_levels <- "All cells"

    xr <- range(plot_df$UMAP_1, na.rm = TRUE)
    yr <- range(plot_df$UMAP_2, na.rm = TRUE)
    xpad <- if (is.finite(diff(xr)) && diff(xr) > 0) diff(xr) * 0.04 else 1
    ypad <- if (is.finite(diff(yr)) && diff(yr) > 0) diff(yr) * 0.04 else 1
    xr <- c(xr[[1]] - xpad, xr[[2]] + xpad)
    yr <- c(yr[[1]] - ypad, yr[[2]] + ypad)

    .continuous_color_active <- function(df_use) {
      if (identical(color_by, "Single Gene Expression")) return(TRUE)
      if (!isTruthy(color_by) || identical(color_by, "None") || !(color_by %in% names(df_use))) return(FALSE)
      v <- df_use[[color_by]]
      is.numeric(v) || is.integer(v)
    }

    if (length(panel_levels) > 1L) {
      n_panels <- length(panel_levels)
      .best_split_grid <- function(n) {
        n <- as.integer(max(1L, n))
        cols <- as.integer(ceiling(sqrt(n)))
        rows <- as.integer(ceiling(n / cols))
        list(rows = rows, cols = cols)
      }
      grid <- .best_split_grid(n_panels)
      nrows <- as.integer(grid$rows)
      ncols <- as.integer(grid$cols)
      panel_w <- diff(xr)
      panel_h <- diff(yr)
      if (!is.finite(panel_w) || panel_w <= 0) panel_w <- 1
      if (!is.finite(panel_h) || panel_h <= 0) panel_h <- 1
      gap_x <- panel_w * 0.16
      gap_y <- panel_h * 0.20
      p <- .panel_base_plot()
      annotations <- list()

      for (i in seq_along(panel_levels)) {
        lv <- panel_levels[[i]]
        df_panel <- plot_df[split_vals == lv, , drop = FALSE]
        col_i <- as.integer((i - 1L) %% ncols)
        row_i <- as.integer((i - 1L) %/% ncols)
        x_offset <- col_i * (panel_w + gap_x)
        y_offset <- (nrows - 1L - row_i) * (panel_h + gap_y)
        df_panel$display_x <- df_panel$UMAP_1 + x_offset
        df_panel$display_y <- df_panel$UMAP_2 + y_offset
        show_scale_i <- identical(i, 1L) && .continuous_color_active(df_panel)
        p <- .add_panel_traces(p, df_panel, show_legend = FALSE, show_scale = show_scale_i)
        annotations[[length(annotations) + 1L]] <- list(
          text = paste0(split_by, ": ", lv),
          x = mean(xr) + x_offset,
          y = yr[[2]] + y_offset + gap_y * 0.42,
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          font = list(size = 12, color = "#334155"),
          xanchor = "center"
        )
      }

      x_range <- c(xr[[1]], xr[[2]] + (ncols - 1L) * (panel_w + gap_x))
      y_range <- c(yr[[1]], yr[[2]] + (nrows - 1L) * (panel_h + gap_y) + gap_y * 0.55)
      p <- layout(
        p,
        uirevision = "recluster_new_umap_view",
        dragmode = "pan",
        xaxis = list(visible = FALSE, showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, range = x_range),
        yaxis = list(visible = FALSE, showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, range = y_range, scaleanchor = "x", scaleratio = 1),
        showlegend = FALSE,
        annotations = annotations,
        margin = list(l = 8, r = 8, t = 18, b = 12)
      )
      p_final <- .finalize_umap_plotly(p)
      umap_plot_rendered(p_final)
      return(invisible(NULL))
    }

    plot_df$display_x <- plot_df$UMAP_1
    plot_df$display_y <- plot_df$UMAP_2
    p <- .panel_base_plot()
    p <- .add_panel_traces(p, plot_df, show_legend = TRUE, show_scale = TRUE)
    p_final <- .finalize_umap_plotly(layout(
      p,
      uirevision = "recluster_new_umap_view",
      dragmode = "pan",
      xaxis = list(title = x_title),
      yaxis = list(title = y_title, scaleanchor = "x", scaleratio = 1),
      paper_bgcolor = if (identical(color_by, "Single Gene Expression") && isTRUE(any(plot_df$gene_rgb_mode %||% FALSE))) "#EFEFEF" else "rgba(0,0,0,0)",
      plot_bgcolor = if (identical(color_by, "Single Gene Expression") && isTRUE(any(plot_df$gene_rgb_mode %||% FALSE))) "#EFEFEF" else "rgba(0,0,0,0)",
      legend = list(
        orientation = "h",
        x = 0.5, xanchor = "center",
        y = -0.14, yanchor = "top"
      ),
      margin = list(l = 60, r = 30, t = 30, b = 88)
    ))
    umap_plot_rendered(p_final)
    invisible(NULL)
  })

  output$recluster_new_umap_plot <- renderPlotly({
    if (!identical(.current_plot_tab(), "umap")) {
      return(
        plot_ly(source = "recluster_new_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    req(umap_plot_rendered())
  })

  output$recluster_new_legend_plot <- renderPlotly({ NULL })

  scatter_plot_df <- reactive({
    req(recluster_new_data$seurat_obj)
    seurat_obj <- recluster_new_data$seurat_obj
    gene_x <- .scalar_chr(input$recluster_new_scatter_gene_x, default = "")
    gene_y <- .scalar_chr(input$recluster_new_scatter_gene_y, default = "")
    req(nzchar(gene_x), nzchar(gene_y))
    color_by_col <- input$recluster_new_scatter_color_by
    assay_use <- .scalar_chr(input$recluster_new_assay_select, default = as.character(DefaultAssay(seurat_obj) %||% ""))

    vars_to_fetch <- c(gene_x, gene_y)
    if (isTruthy(color_by_col) && color_by_col != "None" && color_by_col %in% colnames(seurat_obj@meta.data)) {
      vars_to_fetch <- c(vars_to_fetch, color_by_col)
    }

    plot_df <- FetchData(seurat_obj, vars = unique(vars_to_fetch), assay = assay_use)

    if ("Log Scale X-axis" %in% (input$recluster_new_scatter_log_scale %||% character(0))) {
      plot_df[[gene_x]] <- log1p(plot_df[[gene_x]])
    }
    if ("Log Scale Y-axis" %in% (input$recluster_new_scatter_log_scale %||% character(0))) {
      plot_df[[gene_y]] <- log1p(plot_df[[gene_y]])
    }
    plot_df$cell_id <- rownames(plot_df)
    plot_df
  })

  output$recluster_new_scatter_plot <- renderPlotly({
    if (!identical(.current_plot_tab(), "scatter")) {
      return(
        plot_ly(source = "recluster_new_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    gene_x_now <- .scalar_chr(input$recluster_new_scatter_gene_x, default = "")
    gene_y_now <- .scalar_chr(input$recluster_new_scatter_gene_y, default = "")
    if (!nzchar(gene_x_now) || !nzchar(gene_y_now)) {
      return(
        plot_ly() %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(
          title = "Gene Scatter Plot",
          xaxis = list(visible = FALSE),
          yaxis = list(visible = FALSE),
          annotations = list(list(
            text = "Choose genes for X/Y axes, then click Update Plot.",
            x = 0.5, y = 0.5, xref = "paper", yref = "paper", showarrow = FALSE,
            font = list(size = 16, color = "#6b7280")
          )),
          margin = list(l = 20, r = 20, t = 50, b = 20)
        ) %>%
          .plotly_touch_zoom()
      )
    }
    plot_df <- scatter_plot_df()
    req(plot_df)

    gene_x <- gene_x_now
    gene_y <- gene_y_now

    color_by <- input$recluster_new_scatter_color_by
    marker_list <- list(size = 2.3, opacity = 0.78)
    show_scale <- FALSE
    if (isTruthy(color_by) && color_by != "None") {
      req(color_by %in% names(plot_df))
      vals <- plot_df[[color_by]]
      if (is.numeric(vals) || is.integer(vals)) {
        vv <- suppressWarnings(as.numeric(vals))
        if (!any(is.finite(vv))) vv <- rep(0, length(vv))
        cmin <- min(vv, na.rm = TRUE)
        cmax <- max(vv, na.rm = TRUE)
        if (!is.finite(cmin) || !is.finite(cmax) || identical(cmin, cmax)) {
          cmin <- 0
          cmax <- 1
        }
        marker_list$color <- vv
        marker_list$colorscale <- "Viridis"
        marker_list$cmin <- cmin
        marker_list$cmax <- cmax
        marker_list$showscale <- TRUE
        marker_list$colorbar <- list(title = list(text = color_by))
        show_scale <- TRUE
      } else {
        vals_chr <- as.character(vals %||% character(0))
        vals_chr[is.na(vals_chr) | !nzchar(vals_chr)] <- "(NA)"
        lv <- .sort_numeric_first(unique(vals_chr))
        pal <- .level_color_map(recluster_new_data$seurat_obj, color_by, lv)
        col_vec <- unname(pal[vals_chr])
        col_vec[!nzchar(col_vec) | is.na(col_vec)] <- "#4B5563"
        marker_list$color <- as.character(col_vec)
      }
    } else {
      marker_list$color <- "grey55"
    }

    plot_ly(source = "recluster_new_scatter_plot_source") %>%
      add_trace(
        type = "scattergl",
        mode = "markers",
        x = plot_df[[gene_x]],
        y = plot_df[[gene_y]],
        key = plot_df$cell_id,
        hoverinfo = "skip",
        marker = marker_list,
        showlegend = FALSE
      ) %>%
      layout(
        dragmode = "lasso",
        xaxis = list(title = gene_x),
        yaxis = list(title = gene_y),
        margin = list(l = 55, r = if (isTRUE(show_scale)) 65 else 25, t = 25, b = 55)
      ) %>%
      .plotly_touch_zoom()
  })

  observeEvent(rule_overlap_df(), {
    rdf <- rule_overlap_df()
    grp <- as.character(rdf$overlap_group %||% character(0))
    names(grp) <- as.character(rdf$cell_id %||% character(0))
    recluster_new_data$rule_overlap_group <- grp
    invisible(NULL)
  }, ignoreInit = FALSE)

  .rule_selected_level <- function() {
    grp <- .scalar_chr(input$recluster_new_rule_selected_group, default = "All")
    if (!grp %in% c("A_only", "B_only", "A_B", "Neither", "Missing", "All")) grp <- "All"
    grp
  }

  .rule_color_map <- reactive({
    base <- .rule_color_presets()[["default"]]
    inp <- .rule_color_map_from_inputs()
    out <- base
    for (nm in names(base)) {
      vv <- toupper(.scalar_chr(inp[[nm]], default = base[[nm]]))
      if (.is_hex_color(vv)) out[[nm]] <- vv
    }
    out
  })

  .rule_split_values <- function(df, split_col) {
    if (!isTruthy(split_col) || identical(split_col, "None") || !(split_col %in% names(df))) {
      return(rep("All cells", nrow(df)))
    }
    vals <- as.character(df[[split_col]] %||% character(0))
    vals[is.na(vals) | !nzchar(vals)] <- "(NA)"
    vals
  }

  rule_final_plot_df <- reactive({
    req(recluster_new_data$plot_df, recluster_new_data$seurat_obj)
    plot_df <- recluster_new_data$plot_df
    obj <- recluster_new_data$seurat_obj
    red_choices <- .embedding_reduction_choices(obj)
    req(length(red_choices))
    red_sel <- .scalar_chr(input$recluster_new_rule_umap_reduction_select, default = .preferred_embedding_reduction(obj))
    if (!nzchar(red_sel) || !(red_sel %in% red_choices)) red_sel <- red_choices[[1]]
    emb <- tryCatch(Seurat::Embeddings(obj, red_sel), error = function(e) NULL)
    validate(need(!is.null(emb) && is.matrix(emb) && ncol(emb) >= 2L, sprintf("Embedding '%s' is unavailable.", red_sel)))
    axis_choices <- .axis_index_choices(obj, red_sel)
    axis_vals <- as.character(axis_choices)
    x_idx <- suppressWarnings(as.integer(.scalar_chr(input$recluster_new_rule_umap_axis_x_select, default = if (length(axis_vals)) axis_vals[[1]] else "1")))
    y_default <- if (length(axis_vals) >= 2L) axis_vals[[2]] else if (length(axis_vals)) axis_vals[[1]] else "2"
    y_idx <- suppressWarnings(as.integer(.scalar_chr(input$recluster_new_rule_umap_axis_y_select, default = y_default)))
    if (!is.finite(x_idx) || is.na(x_idx) || x_idx < 1L || x_idx > ncol(emb)) x_idx <- 1L
    if (!is.finite(y_idx) || is.na(y_idx) || y_idx < 1L || y_idx > ncol(emb) || y_idx == x_idx) y_idx <- if (ncol(emb) >= 2L && x_idx != 2L) 2L else min(ncol(emb), max(1L, x_idx + 1L))
    if (y_idx == x_idx && ncol(emb) >= 2L) y_idx <- if (x_idx == 1L) 2L else 1L
    emb_cells <- rownames(emb)
    common_cells <- intersect(rownames(plot_df), emb_cells)
    plot_df <- plot_df[common_cells, , drop = FALSE]
    plot_df$UMAP_1 <- as.numeric(emb[common_cells, x_idx])
    plot_df$UMAP_2 <- as.numeric(emb[common_cells, y_idx])
    axis_titles <- .embedding_axis_titles(obj, red_sel, x_idx, y_idx)
    plot_df$embedding_x_title <- axis_titles$x
    plot_df$embedding_y_title <- axis_titles$y
    rdf <- rule_overlap_df()
    map_group <- as.character(rdf$overlap_group %||% character(0))
    names(map_group) <- as.character(rdf$cell_id %||% character(0))

    cells <- rownames(plot_df)
    overlap_group <- map_group[cells]
    overlap_group[is.na(overlap_group) | !nzchar(overlap_group)] <- "Missing"
    plot_df$overlap_group <- factor(overlap_group, levels = c("A_only", "B_only", "A_B", "Neither", "Missing"))
    plot_df$selection_status <- ifelse(cells %in% as.character(recluster_new_data$rule_active_cells %||% character(0)), "Selected", "Unselected")

    color_mode <- .scalar_chr(input$recluster_new_rule_color_by_select, default = "None")
    gene_now <- .scalar_chr(input$recluster_new_rule_gene_expr_select_1, default = "")
    assay_to_use <- .scalar_chr(input$recluster_new_rule_assay_select, default = as.character(DefaultAssay(recluster_new_data$seurat_obj) %||% ""))
    slot_to_use <- .scalar_chr(input$recluster_new_rule_slot_select, default = "data")
    plot_df$gene1_expr <- 0
    if (identical(color_mode, "Single Gene Expression") && nzchar(gene_now)) {
      vals <- .fetch_gene_values(recluster_new_data$seurat_obj, assay_to_use, gene_now, slot_to_use)
      if (!is.null(vals)) {
        v <- vals[cells]
        v[!is.finite(v)] <- 0
        plot_df$gene1_expr <- log1p(as.numeric(v))
      }
    }
    plot_df$cell_id <- cells
    plot_df
  })

  output$recluster_new_rule_umap_plot <- renderPlotly({
    if (!identical(.current_rule_plot_tab(), "rule_umap")) {
      return(
        plot_ly(source = "recluster_new_rule_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    plot_df <- rule_final_plot_df()
    req(nrow(plot_df))

    x_title <- .scalar_chr(plot_df$embedding_x_title, default = "UMAP_1")
    y_title <- .scalar_chr(plot_df$embedding_y_title, default = "UMAP_2")
    split_by <- .scalar_chr(input$recluster_new_rule_split_by_select, default = "None")
    split_vals <- .rule_split_values(plot_df, split_by)
    panel_levels <- .sort_numeric_first(unique(split_vals))
    if (!length(panel_levels)) panel_levels <- "All cells"

    dot_size <- suppressWarnings(as.numeric(input$recluster_new_rule_dot_size %||% 0.6))
    dot_alpha <- suppressWarnings(as.numeric(input$recluster_new_rule_dot_alpha %||% 0.8))
    highlight_stroke_alpha <- suppressWarnings(as.numeric(input$recluster_new_rule_stroke_width %||% 0.1))
    if (!is.finite(dot_size) || dot_size <= 0) dot_size <- 0.6
    if (!is.finite(dot_alpha) || dot_alpha <= 0) dot_alpha <- 0.8
    if (!is.finite(highlight_stroke_alpha)) highlight_stroke_alpha <- 0.1
    highlight_stroke_alpha <- max(0, min(1, highlight_stroke_alpha))
    dot_alpha <- max(0.05, min(1, dot_alpha))
    any_selected_now <- isTRUE(length(recluster_new_data$rule_active_cells %||% character(0)) > 0L)
    effective_stroke_width <- 0
    base_marker_size <- max(1.8, dot_size * 3.8)
    highlight_size <- base_marker_size + max(0.9, base_marker_size * 0.14)
    highlight_width <- max(1.1, base_marker_size * 0.18)
    highlight_stroke_color <- sprintf("rgba(199,21,133,%.3f)", highlight_stroke_alpha)
    stroke_color <- .scalar_chr(input$recluster_new_rule_stroke_color, default = "black")

    xr <- range(plot_df$UMAP_1, na.rm = TRUE)
    yr <- range(plot_df$UMAP_2, na.rm = TRUE)
    xpad <- if (is.finite(diff(xr)) && diff(xr) > 0) diff(xr) * 0.04 else 1
    ypad <- if (is.finite(diff(yr)) && diff(yr) > 0) diff(yr) * 0.04 else 1
    xr <- c(xr[[1]] - xpad, xr[[2]] + xpad)
    yr <- c(yr[[1]] - ypad, yr[[2]] + ypad)

    plot_df$display_x <- plot_df$UMAP_1
    plot_df$display_y <- plot_df$UMAP_2
    annotations <- list()

    if (length(panel_levels) > 1L) {
      n_panels <- length(panel_levels)
      .best_split_grid <- function(n) {
        n <- as.integer(max(1L, n))
        best <- list(area = Inf, rows = n, cols = 1L)
        for (cols in seq_len(n)) {
          rows <- as.integer(ceiling(n / cols))
          area <- rows * cols
          if ((area < best$area) || (identical(area, best$area) && cols > best$cols)) {
            best <- list(area = area, rows = rows, cols = cols)
          }
        }
        best
      }
      grid <- .best_split_grid(n_panels)
      ncols <- as.integer(grid$cols)
      w <- diff(xr)
      h <- diff(yr)
      w <- if (is.finite(w) && w > 0) w else 20
      h <- if (is.finite(h) && h > 0) h else 20
      x_step <- w * 1.22
      y_step <- h * 1.22
      centers <- lapply(seq_along(panel_levels), function(i) {
        col_idx <- (i - 1L) %% ncols
        row_idx <- (i - 1L) %/% ncols
        list(x = col_idx * x_step, y = -row_idx * y_step)
      })
      for (i in seq_along(panel_levels)) {
        lv <- panel_levels[[i]]
        idx <- which(split_vals == lv)
        if (!length(idx)) next
        ctr <- centers[[i]]
        plot_df$display_x[idx] <- plot_df$UMAP_1[idx] + ctr$x
        plot_df$display_y[idx] <- plot_df$UMAP_2[idx] + ctr$y
        annotations[[length(annotations) + 1L]] <- list(
          x = ctr$x + mean(xr),
          y = ctr$y + yr[[2]] + (0.10 * h),
          xref = "x",
          yref = "y",
          text = paste0(split_by, ": ", lv),
          showarrow = FALSE,
          font = list(size = 13, color = "#334155"),
          xanchor = "center"
        )
      }
    }

    umap_mode <- .scalar_chr(input$recluster_new_rule_umap_mode, default = "highlight")
    sel_cells <- as.character(recluster_new_data$rule_active_cells %||% character(0))
    sel_mask <- plot_df$cell_id %in% sel_cells
    pal <- .rule_color_map()
    p <- plot_ly(source = "recluster_new_rule_plot_source")

    if (identical(umap_mode, "full")) {
      for (lv in c("A_only", "B_only", "A_B", "Neither", "Missing")) {
        df_lv <- plot_df[as.character(plot_df$overlap_group) == lv, , drop = FALSE]
        if (!nrow(df_lv)) next
        p <- add_trace(
          p,
          type = "scattergl",
          mode = "markers",
          x = df_lv$display_x,
          y = df_lv$display_y,
          key = df_lv$cell_id,
          marker = list(
            color = pal[[lv]] %||% "#6B7280",
            size = base_marker_size,
            opacity = dot_alpha,
            line = list(width = effective_stroke_width, color = stroke_color)
          ),
          hoverinfo = "text",
          text = paste0("Cell: ", df_lv$cell_id, "<br>Overlap: ", lv),
          name = lv,
          legendgroup = lv,
          showlegend = TRUE
        )
      }
    } else {
      bg_df <- plot_df[!sel_mask, , drop = FALSE]
      fg_df <- plot_df[sel_mask, , drop = FALSE]
      if (nrow(bg_df)) {
        p <- add_trace(
          p,
          type = "scattergl",
          mode = "markers",
          x = bg_df$display_x,
          y = bg_df$display_y,
          key = bg_df$cell_id,
          marker = list(color = "#BDBDBD", size = base_marker_size, opacity = max(0.12, dot_alpha * 0.45), line = list(width = 0)),
          hoverinfo = "skip",
          showlegend = FALSE
        )
      }
      if (nrow(fg_df)) {
        p <- add_trace(
          p,
          type = "scattergl",
          mode = "markers",
          x = fg_df$display_x,
          y = fg_df$display_y,
          key = fg_df$cell_id,
          marker = list(color = "#C71585", size = highlight_size, opacity = min(1, dot_alpha + 0.12), line = list(width = highlight_width, color = highlight_stroke_color)),
          hoverinfo = "text",
          text = paste0("Cell: ", fg_df$cell_id, "<br>Overlap: ", as.character(fg_df$overlap_group)),
          showlegend = FALSE
        )
      }
    }

    p %>% layout(
      dragmode = "pan",
      xaxis = list(title = x_title),
      yaxis = list(title = y_title, scaleanchor = "x", scaleratio = 1),
      annotations = annotations,
      margin = list(l = 60, r = 30, t = if (length(annotations)) 62 else 30, b = 65)
    ) %>%
      event_register("plotly_selected") %>%
      .plotly_touch_zoom()
  })

  rule_scatter_plot_df <- reactive({
    req(recluster_new_data$seurat_obj)
    seurat_obj <- recluster_new_data$seurat_obj
    gene_x <- .scalar_chr(input$recluster_new_rule_scatter_gene_x, default = "")
    gene_y <- .scalar_chr(input$recluster_new_rule_scatter_gene_y, default = "")
    req(nzchar(gene_x), nzchar(gene_y))
    color_by_col <- .scalar_chr(input$recluster_new_rule_scatter_color_by, default = "None")
    assay_use <- .scalar_chr(input$recluster_new_rule_assay_select, default = as.character(DefaultAssay(seurat_obj) %||% ""))

    vars_to_fetch <- c(gene_x, gene_y)
    if (isTruthy(color_by_col) && color_by_col != "None" && color_by_col %in% colnames(seurat_obj@meta.data)) {
      vars_to_fetch <- c(vars_to_fetch, color_by_col)
    }
    plot_df <- FetchData(seurat_obj, vars = unique(vars_to_fetch), assay = assay_use)
    if ("Log Scale X-axis" %in% (input$recluster_new_rule_scatter_log_scale %||% character(0))) {
      plot_df[[gene_x]] <- log1p(plot_df[[gene_x]])
    }
    if ("Log Scale Y-axis" %in% (input$recluster_new_rule_scatter_log_scale %||% character(0))) {
      plot_df[[gene_y]] <- log1p(plot_df[[gene_y]])
    }
    plot_df$cell_id <- rownames(plot_df)
    plot_df
  })

  output$recluster_new_rule_scatter_plot <- renderPlotly({
    if (!identical(.current_rule_plot_tab(), "rule_scatter")) {
      return(
        plot_ly(source = "recluster_new_rule_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    gene_x <- .scalar_chr(input$recluster_new_rule_scatter_gene_x, default = "")
    gene_y <- .scalar_chr(input$recluster_new_rule_scatter_gene_y, default = "")
    if (!nzchar(gene_x) || !nzchar(gene_y)) {
      return(
        plot_ly() %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(
            title = "Rule Scatter Plot",
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(list(
              text = "Choose genes for X/Y axes, then click Update Plot.",
              x = 0.5, y = 0.5, xref = "paper", yref = "paper", showarrow = FALSE,
              font = list(size = 16, color = "#6b7280")
            )),
            margin = list(l = 20, r = 20, t = 50, b = 20)
          ) %>%
          .plotly_touch_zoom()
      )
    }
    plot_df <- rule_scatter_plot_df()
    req(plot_df)

    color_by <- .scalar_chr(input$recluster_new_rule_scatter_color_by, default = "None")
    marker_list <- list(size = 2.3, opacity = 0.78)
    show_scale <- FALSE
    if (isTruthy(color_by) && color_by != "None") {
      req(color_by %in% names(plot_df))
      vals <- plot_df[[color_by]]
      if (is.numeric(vals) || is.integer(vals)) {
        vv <- suppressWarnings(as.numeric(vals))
        if (!any(is.finite(vv))) vv <- rep(0, length(vv))
        cmin <- min(vv, na.rm = TRUE)
        cmax <- max(vv, na.rm = TRUE)
        if (!is.finite(cmin) || !is.finite(cmax) || identical(cmin, cmax)) {
          cmin <- 0
          cmax <- 1
        }
        marker_list$color <- vv
        marker_list$colorscale <- "Viridis"
        marker_list$cmin <- cmin
        marker_list$cmax <- cmax
        marker_list$showscale <- TRUE
        marker_list$colorbar <- list(title = list(text = color_by))
        show_scale <- TRUE
      } else {
        vals_chr <- as.character(vals %||% character(0))
        vals_chr[is.na(vals_chr) | !nzchar(vals_chr)] <- "(NA)"
        lv <- .sort_numeric_first(unique(vals_chr))
        pal <- .level_color_map(recluster_new_data$seurat_obj, color_by, lv)
        col_vec <- unname(pal[vals_chr])
        col_vec[!nzchar(col_vec) | is.na(col_vec)] <- "#4B5563"
        marker_list$color <- as.character(col_vec)
      }
    } else {
      marker_list$color <- "grey55"
    }

    p <- plot_ly(source = "recluster_new_rule_plot_source") %>%
      add_trace(
        type = "scattergl",
        mode = "markers",
        x = plot_df[[gene_x]],
        y = plot_df[[gene_y]],
        key = plot_df$cell_id,
        hoverinfo = "skip",
        marker = marker_list,
        showlegend = FALSE
      )

    sel <- as.character(recluster_new_data$rule_active_cells %||% character(0))
    sel_df <- plot_df[plot_df$cell_id %in% sel, , drop = FALSE]
    if (nrow(sel_df)) {
      p <- add_trace(
        p,
        type = "scattergl",
        mode = "markers",
        x = sel_df[[gene_x]],
        y = sel_df[[gene_y]],
        key = sel_df$cell_id,
        marker = list(symbol = "circle-open", size = 5, color = "#C71585", line = list(width = 1, color = "#C71585"), opacity = 0.95),
        hoverinfo = "skip",
        showlegend = FALSE
      )
    }

    p %>% layout(
      dragmode = "lasso",
      xaxis = list(title = gene_x),
      yaxis = list(title = gene_y),
      margin = list(l = 55, r = if (isTRUE(show_scale)) 65 else 25, t = 25, b = 55)
    ) %>%
      .plotly_touch_zoom()
  })

  output$recluster_new_rule_stacked_plot <- renderPlotly({
    if (!.db_tab_is_active()) {
      return(
        plot_ly(source = "recluster_new_rule_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    if (!identical(.current_expr_tab(), "stacked")) {
      return(
        plot_ly(source = "recluster_new_rule_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    req(recluster_new_data$seurat_obj)
    obj <- recluster_new_data$seurat_obj
    rdf <- rule_overlap_df()
    group_col <- .scalar_chr(input$recluster_new_rule_group_col, default = "")
    validate(need(nzchar(group_col) && group_col %in% colnames(obj@meta.data), "Select a valid grouping column."))

    md <- obj@meta.data
    grp_vals <- as.character(md[[group_col]] %||% character(0))
    grp_vals[is.na(grp_vals) | !nzchar(grp_vals)] <- "(NA)"
    df <- data.frame(
      cell_id = rownames(md),
      group_value = grp_vals,
      stringsAsFactors = FALSE
    )
    rdf$cell_id <- as.character(rdf$cell_id)
    df <- merge(df, rdf[, c("cell_id", "overlap_group"), drop = FALSE], by = "cell_id", all.x = TRUE, sort = FALSE)
    df$overlap_group <- as.character(df$overlap_group %||% "Missing")
    df$overlap_group[is.na(df$overlap_group) | !nzchar(df$overlap_group)] <- "Missing"

    pct_df <- as.data.frame(table(df$group_value, df$overlap_group), stringsAsFactors = FALSE)
    colnames(pct_df) <- c("group_value", "overlap_group", "n")
    pct_df <- pct_df[pct_df$n > 0, , drop = FALSE]
    totals <- aggregate(n ~ group_value, data = pct_df, FUN = sum)
    pct_df <- merge(pct_df, totals, by = "group_value", suffixes = c("", "_total"), sort = FALSE)
    pct_df$percent <- ifelse(pct_df$n_total > 0, 100 * pct_df$n / pct_df$n_total, 0)
    pct_df$group_value <- factor(pct_df$group_value, levels = .sort_numeric_first(unique(as.character(pct_df$group_value))))
    pct_df$overlap_group <- factor(pct_df$overlap_group, levels = c("A_only", "B_only", "A_B", "Neither", "Missing"))
    pal <- unlist(.rule_color_map()[c("A_only", "B_only", "A_B", "Neither", "Missing")], use.names = TRUE)

    plot_ly(
      data = pct_df,
      x = ~group_value,
      y = ~percent,
      color = ~overlap_group,
      colors = pal,
      type = "bar",
      text = ~n,
      customdata = ~as.character(overlap_group),
      hovertemplate = paste0(
        group_col, ": %{x}<br>",
        "Overlap: %{customdata}<br>",
        "Percent: %{y:.2f}%<br>",
        "Count: %{text}<extra></extra>"
      )
    ) %>%
      layout(
        barmode = "stack",
        xaxis = list(title = group_col),
        yaxis = list(title = "Percent of cells", ticksuffix = "%", range = c(0, 100)),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.18, yanchor = "top"),
        margin = list(l = 60, r = 20, t = 20, b = 95)
      )
  })

  .pseudobulk_table_data <- reactiveVal(NULL)

  .pb_run_context <- reactive({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    md <- obj@meta.data
    profiles <- recluster_new_data$metadata_profiles %||% list()

    meta_col <- .scalar_chr(input$recluster_new_pb_meta_col, default = .scalar_chr(recluster_new_data$metadata_open_column, default = ""))
    open_col <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    split_by <- .scalar_chr(input$recluster_new_split_by_select, default = "None")

    if (!nzchar(meta_col) || !(meta_col %in% colnames(md))) {
      return(list(valid = FALSE, reason = "Choose a valid cluster metadata column."))
    }
    if (!identical(meta_col, open_col)) {
      return(list(valid = FALSE, reason = "Pseudobulk cluster column must match the active metadata filter column."))
    }
    profile <- profiles[[meta_col]]
    if (is.null(profile) || !identical(.scalar_chr(profile$bucket, default = "categorical"), "cluster")) {
      return(list(valid = FALSE, reason = "Selected pseudobulk metadata column must be cluster-like."))
    }
    selected_clusters <- .selected_levels_for_column(meta_col, profile)
    selected_clusters <- selected_clusters[nzchar(selected_clusters)]
    selected_clusters <- .sort_numeric_first(selected_clusters)
    all_clusters <- .sort_numeric_first(profile$levels %||% character(0))
    if (!length(selected_clusters) || length(selected_clusters) == length(all_clusters)) {
      return(list(
        valid = TRUE,
        mode = "per_cluster_vs_rest",
        meta_col = meta_col,
        split_by = split_by,
        cluster_subset = all_clusters,
        levels = character(0),
        level_label = "Cluster"
      ))
    }

    if (length(selected_clusters) == 1L) {
      return(list(
        valid = TRUE,
        mode = "cluster_set_vs_rest",
        meta_col = meta_col,
        split_by = split_by,
        cluster_subset = selected_clusters,
        levels = selected_clusters,
        level_label = "Cluster"
      ))
    }

    return(list(
      valid = TRUE,
      mode = "selected_cluster_vs_remaining",
      meta_col = meta_col,
      split_by = split_by,
      cluster_subset = selected_clusters,
      levels = selected_clusters,
      level_label = "Cluster"
    ))
  })

  output$recluster_new_pb_level_a_ui <- renderUI({
    x <- .pb_run_context()
    if (!isTRUE(x$valid)) return(helpText(x$reason %||% "Pseudobulk context is not ready."))
    if (identical(.scalar_chr(x$mode, default = ""), "per_cluster_vs_rest")) {
      return(helpText("Auto mode: all levels in current active cluster layer will run as cluster vs rest."))
    }
    if (identical(.scalar_chr(x$mode, default = ""), "selected_cluster_vs_remaining")) {
      return(helpText("Auto mode: each selected cluster will run against the remaining selected clusters."))
    }
    lbl <- paste0(RECLUSTER_NEW_UI_TEXT$t_label_pb_level_a, " (", x$level_label %||% "Level", ")")
    selectInput("recluster_new_pb_level_a", lbl, choices = x$levels, selected = x$levels[[1]])
  })

  output$recluster_new_pb_level_b_ui <- renderUI({
    x <- .pb_run_context()
    if (!isTRUE(x$valid)) return(NULL)
    if (identical(.scalar_chr(x$mode, default = ""), "cluster_set_vs_rest")) return(NULL)
    if (identical(.scalar_chr(x$mode, default = ""), "per_cluster_vs_rest")) return(NULL)
    if (identical(.scalar_chr(x$mode, default = ""), "selected_cluster_vs_remaining")) return(NULL)
    selected <- if (length(x$levels) > 1) x$levels[[2]] else x$levels[[1]]
    lbl <- paste0(RECLUSTER_NEW_UI_TEXT$t_label_pb_level_b, " (", x$level_label %||% "Level", ")")
    selectInput("recluster_new_pb_level_b", lbl, choices = x$levels, selected = selected)
  })

  observeEvent(input$recluster_new_pb_open_analysis_btn, {
    updateNavbarPage(session, "main_navbar", selected = "analysis_tab")
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_pb_run_btn, {
    obj <- recluster_new_data$seurat_obj
    req(obj)
    ctx <- .pb_run_context()
    if (!isTRUE(ctx$valid)) {
      showNotification(ctx$reason %||% "Pseudobulk context is invalid.", type = "error", duration = 8)
      return(invisible(NULL))
    }
    meta_col <- ctx$meta_col
    profile <- recluster_new_data$metadata_profiles[[meta_col]]
    bucket_id <- .scalar_chr(profile$bucket, default = "categorical")
    core_mode <- .scalar_chr(ctx$mode, default = "")
    level_a <- if (identical(core_mode, "per_cluster_vs_rest")) {
      "(all clusters)"
    } else if (identical(core_mode, "selected_cluster_vs_remaining")) {
      "(each selected cluster)"
    } else {
      .scalar_chr(input$recluster_new_pb_level_a, default = "")
    }
    if (!identical(core_mode, "per_cluster_vs_rest") &&
        !identical(core_mode, "selected_cluster_vs_remaining") &&
        (!nzchar(level_a) || !(level_a %in% (ctx$levels %||% character(0))))) {
      showNotification("Level A is not valid for current pseudobulk binding context.", type = "error", duration = 8)
      return(invisible(NULL))
    }
    level_b <- if (identical(core_mode, "cluster_set_vs_rest") || identical(core_mode, "per_cluster_vs_rest")) {
      "rest"
    } else if (identical(core_mode, "selected_cluster_vs_remaining")) {
      "remaining selected clusters"
    } else {
      .scalar_chr(input$recluster_new_pb_level_b, default = "")
    }
    if (!identical(core_mode, "cluster_set_vs_rest") &&
        !identical(core_mode, "per_cluster_vs_rest") &&
        !identical(core_mode, "selected_cluster_vs_remaining") &&
        (!nzchar(level_b) || !(level_b %in% (ctx$levels %||% character(0))) || identical(level_a, level_b))) {
      showNotification("Level B is not valid for current pseudobulk binding context.", type = "error", duration = 8)
      return(invisible(NULL))
    }
    compare_mode <- core_mode
    split_by <- .scalar_chr(ctx$split_by, default = "None")
    cluster_subset <- as.character(ctx$cluster_subset %||% character(0))
    message(
      sprintf(
        "[PB_BIND] mode=%s meta_col=%s split_by=%s cluster_subset=%s level_a=%s level_b=%s",
        core_mode, meta_col, split_by, paste(cluster_subset, collapse = ","), level_a, level_b
      )
    )
    showNotification(
      sprintf(
        "Pseudobulk binding: %s",
        if (identical(core_mode, "condition_within_clusters")) {
          "Condition A vs B within selected cluster"
        } else if (identical(core_mode, "per_cluster_vs_rest")) {
          "All clusters vs rest (one comparison per cluster)"
        } else if (identical(core_mode, "selected_cluster_vs_remaining")) {
          "Each selected cluster vs remaining selected clusters"
        } else if (identical(core_mode, "cluster_set_vs_rest")) {
          "Selected cluster vs rest"
        } else {
          "Cluster set A vs cluster set B"
        }
      ),
      type = "message",
      duration = 3
    )

    pb <- tryCatch(
      withProgress(message = "Running pseudobulk table", detail = "Preparing comparison context...", value = 0, {
        incProgress(0.25, detail = "Computing pseudobulk replicates...")
        res <- if (identical(core_mode, "condition_within_clusters")) {
        core_analysis_tab_d_compute_pseudobulk(
          seurat_obj = obj,
          resolution_col = meta_col,
          sample_col = "orig.ident",
          max_genes = 2000L,
          de_method = "edgeR",
          mode = core_mode,
          cluster_a = cluster_subset,
          group_var = split_by,
          group_a = level_a,
          group_b = level_b
        )
      } else if (identical(core_mode, "selected_cluster_vs_remaining")) {
        selected_clusters <- cluster_subset[nzchar(cluster_subset)]
        lst <- lapply(selected_clusters, function(cluster_now) {
          rest_clusters <- setdiff(selected_clusters, cluster_now)
          res_one <- core_analysis_tab_d_compute_pseudobulk(
            seurat_obj = obj,
            resolution_col = meta_col,
            sample_col = "orig.ident",
            max_genes = 2000L,
            de_method = "edgeR",
            mode = "cluster_vs_cluster",
            cluster_a = cluster_now,
            cluster_b = rest_clusters
          )
          d <- res_one$custom %||% data.frame()
          if (is.data.frame(d) && nrow(d)) {
            d$cluster <- cluster_now
            d$comparison <- sprintf(
              "Cluster %s vs selected rest (%s)",
              cluster_now,
              paste(rest_clusters, collapse = ", ")
            )
          }
          d
        })
        per_cluster <- if (length(lst)) do.call(rbind, lst) else data.frame()
        list(per_cluster = per_cluster, custom = NULL, meta = NULL)
      } else if (identical(core_mode, "cluster_set_vs_rest")) {
        core_analysis_tab_d_compute_pseudobulk(
          seurat_obj = obj,
          resolution_col = meta_col,
          sample_col = "orig.ident",
          max_genes = 2000L,
          de_method = "edgeR",
          mode = core_mode,
          cluster_a = level_a
        )
      } else if (identical(core_mode, "per_cluster_vs_rest")) {
        core_analysis_tab_d_compute_pseudobulk(
          seurat_obj = obj,
          resolution_col = meta_col,
          sample_col = "orig.ident",
          max_genes = 2000L,
          de_method = "edgeR",
          mode = core_mode
        )
      } else {
        core_analysis_tab_d_compute_pseudobulk(
          seurat_obj = obj,
          resolution_col = meta_col,
          sample_col = "orig.ident",
          max_genes = 2000L,
          de_method = "edgeR",
          mode = core_mode,
          cluster_a = level_a,
          cluster_b = level_b
        )
      }
        incProgress(0.55, detail = "Formatting table rows...")
        incProgress(0.20, detail = "Done")
        res
      }),
      error = function(e) e
    )
    if (inherits(pb, "error")) {
      msg <- conditionMessage(pb)
      .pseudobulk_table_data(data.frame(note = sprintf("Pseudobulk failed: %s", msg), stringsAsFactors = FALSE))
      showNotification(sprintf("Pseudobulk failed: %s", msg), type = "error", duration = 10)
      return(invisible(NULL))
    }
    out <- if (core_mode %in% c("per_cluster_vs_rest", "selected_cluster_vs_remaining")) (pb$per_cluster %||% data.frame()) else (pb$custom %||% data.frame())
    if (!is.data.frame(out) || !nrow(out)) {
      out <- data.frame(note = "Pseudobulk finished, but no result rows were returned. Check replicate counts for the selected comparison.", stringsAsFactors = FALSE)
    }
    if (is.data.frame(out) && nrow(out)) {
      out$metadata_column <- meta_col
      out$split_by <- split_by
      out$bucket_id <- bucket_id
      out$compare_mode <- compare_mode
      out$level_a <- level_a
      out$level_b <- level_b
      out$mode <- core_mode
      out$cluster_subset <- paste(cluster_subset, collapse = ",")
    }
    .pseudobulk_table_data(out)

    pb_store <- .pb_store_get(obj)
    if (!is.list(pb_store$custom)) pb_store$custom <- list()
    if (!is.list(pb_store$custom$by_metadata)) pb_store$custom$by_metadata <- list()
    if (!is.list(pb_store$custom$by_metadata[[meta_col]])) pb_store$custom$by_metadata[[meta_col]] <- list()
    if (!is.list(pb_store$custom$by_metadata[[meta_col]][[bucket_id]])) pb_store$custom$by_metadata[[meta_col]][[bucket_id]] <- list()
    if (!is.list(pb_store$custom$by_metadata[[meta_col]][[bucket_id]][[compare_mode]])) pb_store$custom$by_metadata[[meta_col]][[bucket_id]][[compare_mode]] <- list()
    level_key <- .pb_level_key(level_a, level_b, compare_mode)
    pb_store$custom$last <- list(
      metadata_column = meta_col,
      split_by = split_by,
      bucket_id = bucket_id,
      compare_mode = compare_mode,
      mode = core_mode,
      cluster_subset = cluster_subset,
      level_a = level_a,
      level_b = level_b,
      params = list(sample_col = "orig.ident", max_genes = 2000L, de_method = "edgeR"),
      created_at = as.character(Sys.time()),
      result = pb
    )
    pb_store$custom$by_metadata[[meta_col]][[bucket_id]][[compare_mode]][[level_key]] <- list(
      metadata_column = meta_col,
      split_by = split_by,
      bucket_id = bucket_id,
      mode = core_mode,
      cluster_subset = cluster_subset,
      level_key = level_key,
      level_a = level_a,
      level_b = level_b,
      params = list(sample_col = "orig.ident", max_genes = 2000L, de_method = "edgeR"),
      created_at = as.character(Sys.time()),
      result = pb
    )
    obj <- .pb_store_set(obj, pb_store)
    .persist_active_object(obj)
  }, ignoreInit = TRUE)

  .pb_loupe_metrics <- c(
    logFC = "log2FC",
    p_val = "p-value",
    p_adj = "FDR",
    neglog10_fdr = "-log10(FDR)"
  )

  .pb_table_group_values <- function(df) {
    if (!is.data.frame(df) || !nrow(df) || !("gene" %in% colnames(df))) return(character(0))
    if ("cluster" %in% colnames(df)) {
      vals <- as.character(df$cluster %||% character(0))
      vals <- vals[!is.na(vals) & nzchar(vals)]
      return(.sort_numeric_first(unique(vals)))
    }
    if (all(names(.pb_loupe_metrics) %in% colnames(df))) return("comparison")
    character(0)
  }

  .pb_group_label <- function(group_value) {
    group_value <- .scalar_chr(group_value, default = "")
    if (identical(group_value, "comparison")) return("Comparison")
    paste0("Cluster ", group_value)
  }

  .pb_group_choices <- function(group_values) {
    stats::setNames(as.character(group_values), vapply(group_values, .pb_group_label, character(1)))
  }

  .pb_empty_group_values <- function(df, visible_groups) {
    metric_cols <- names(.pb_loupe_metrics)
    if (!is.data.frame(df) || !nrow(df) || !("gene" %in% colnames(df)) || !("cluster" %in% colnames(df)) || !all(metric_cols %in% colnames(df))) {
      return(character(0))
    }
    visible_groups <- as.character(visible_groups %||% character(0))
    visible_groups <- visible_groups[nzchar(visible_groups)]
    if (!length(visible_groups)) return(character(0))
    empty <- vapply(visible_groups, function(group_value) {
      part <- df[as.character(df$cluster) == group_value, metric_cols, drop = FALSE]
      !nrow(part) || !any(!is.na(as.matrix(part)))
    }, logical(1))
    visible_groups[empty]
  }

  .pb_loupe_container <- function(group_values, metric_labels, highlight_group = "") {
    top_cells <- list(tags$th(rowspan = 2, "Gene"))
    bottom_cells <- list()
    for (group_value in group_values) {
      is_highlight <- identical(as.character(group_value), as.character(highlight_group))
      head_class <- if (is_highlight) "pb-highlight-head" else "pb-muted-head"
      metric_class <- if (is_highlight) "pb-highlight-col" else "pb-muted-col"
      top_cells[[length(top_cells) + 1L]] <- tags$th(
        colspan = length(metric_labels),
        class = head_class,
        `data-pb-group` = as.character(group_value),
        tabindex = "0",
        .pb_group_label(group_value)
      )
      for (metric_label in metric_labels) {
        bottom_cells[[length(bottom_cells) + 1L]] <- tags$th(
          class = metric_class,
          `data-pb-group` = as.character(group_value),
          metric_label
        )
      }
    }
    tags$table(
      class = "display compact nowrap",
      tags$thead(
        do.call(tags$tr, top_cells),
        do.call(tags$tr, bottom_cells)
      )
    )
  }

  .pb_loupe_table <- function(df, visible_groups, highlight_group = "") {
    metric_cols <- names(.pb_loupe_metrics)
    if (!is.data.frame(df) || !nrow(df) || !("gene" %in% colnames(df)) || !all(metric_cols %in% colnames(df))) {
      return(list(data = df, groups = character(0), group_cols = list(), group_targets = list(), container = NULL, loupe = FALSE))
    }

    group_col <- if ("cluster" %in% colnames(df)) "cluster" else ".__pb_group__"
    if (!identical(group_col, "cluster")) df[[group_col]] <- "comparison"

    groups <- .pb_table_group_values(df)
    visible_groups <- intersect(as.character(visible_groups %||% groups), groups)
    if (!length(groups) || !length(visible_groups)) {
      return(list(
        data = data.frame(note = "Select at least one pseudobulk group to display.", stringsAsFactors = FALSE),
        groups = groups,
        group_cols = list(),
        group_targets = list(),
        container = NULL,
        loupe = FALSE
      ))
    }
    highlight_group <- .scalar_chr(highlight_group, default = "")
    if (!(highlight_group %in% visible_groups)) highlight_group <- visible_groups[[1]]

    out <- data.frame(gene = unique(as.character(df$gene)), stringsAsFactors = FALSE, check.names = FALSE)
    group_cols <- list()
    group_targets <- list()
    for (group_value in visible_groups) {
      keep <- as.character(df[[group_col]]) == group_value
      part <- df[keep, c("gene", metric_cols), drop = FALSE]
      part$gene <- as.character(part$gene)
      part <- part[!duplicated(part$gene), , drop = FALSE]
      col_ids <- paste0("pb__", .safe_key(group_value), "__", metric_cols)
      colnames(part) <- c("gene", col_ids)
      out <- merge(out, part, by = "gene", all.x = TRUE, sort = FALSE)
      group_cols[[group_value]] <- col_ids
      group_targets[[group_value]] <- match(col_ids, colnames(out)) - 1L
    }
    metric_out_cols <- unlist(group_cols, use.names = FALSE)
    if (length(metric_out_cols)) {
      keep_rows <- rowSums(!is.na(out[, metric_out_cols, drop = FALSE])) > 0
      out <- out[keep_rows, , drop = FALSE]
    }
    if (!nrow(out)) {
      return(list(
        data = data.frame(note = "No finite pseudobulk metric values were returned for the visible groups.", stringsAsFactors = FALSE),
        groups = visible_groups,
        group_cols = group_cols,
        group_targets = group_targets,
        container = NULL,
        loupe = FALSE
      ))
    }

    list(
      data = out,
      groups = visible_groups,
      group_cols = group_cols,
      group_targets = group_targets,
      highlight_group = highlight_group,
      container = .pb_loupe_container(visible_groups, unname(.pb_loupe_metrics), highlight_group),
      loupe = TRUE
    )
  }

  output$recluster_new_pb_group_controls_ui <- renderUI({
    df <- .pseudobulk_table_data()
    groups <- .pb_table_group_values(df)
    if (!length(groups)) return(NULL)

    visible_now <- input$recluster_new_pb_visible_groups
    if (is.null(visible_now)) {
      visible_now <- groups
    } else {
      visible_now <- intersect(as.character(visible_now), groups)
    }

    div(
      class = "recluster-new-pb-controls",
      div(
        class = "recluster-new-pb-visible",
        checkboxGroupInput(
          "recluster_new_pb_visible_groups",
          "Show groups:",
          choices = .pb_group_choices(groups),
          selected = visible_now,
          inline = TRUE
        )
      ),
      uiOutput("recluster_new_pb_empty_group_note_ui"),
      tags$script(HTML(
        "(function(){
          if (window.__reclusterNewPbHeaderClickBound) return;
          window.__reclusterNewPbHeaderClickBound = true;
          function safeKey(value) {
            var out = String(value || '').replace(/[^A-Za-z0-9]+/g, '_').replace(/_+/g, '_').replace(/^_|_$/g, '');
            return out || 'col';
          }
          function applyHighlight(group) {
            var card = document.querySelector('.recluster-new-pb-card');
            if (!card || !group) return;
            card.querySelectorAll('[data-pb-group]').forEach(function(node) {
              var hit = (node.getAttribute('data-pb-group') || '') === group;
              node.classList.toggle('pb-highlight-head', hit && node.tagName === 'TH' && node.getAttribute('colspan'));
              node.classList.toggle('pb-muted-head', !hit && node.tagName === 'TH' && node.getAttribute('colspan'));
              node.classList.toggle('pb-highlight-col', hit && !node.getAttribute('colspan'));
              node.classList.toggle('pb-muted-col', !hit && !node.getAttribute('colspan'));
            });
            card.querySelectorAll('.pb-dt-group').forEach(function(node) {
              var hit = node.classList.contains('pb-dt-group-' + safeKey(group));
              node.classList.toggle('pb-highlight-col', hit);
              node.classList.toggle('pb-muted-col', !hit);
            });
          }
          function setGroup(group) {
            if (!group) return;
            applyHighlight(group);
            if (window.Shiny && window.Shiny.setInputValue) {
              Shiny.setInputValue('recluster_new_pb_highlight_group', group, {priority: 'deferred'});
            }
          }
          document.addEventListener('click', function(ev) {
            var th = ev.target && ev.target.closest && ev.target.closest('.recluster-new-pb-card table.dataTable thead th[data-pb-group]');
            if (!th) return;
            setGroup(th.getAttribute('data-pb-group') || '');
          }, true);
          document.addEventListener('keydown', function(ev) {
            if (ev.key !== 'Enter' && ev.key !== ' ') return;
            var th = ev.target && ev.target.closest && ev.target.closest('.recluster-new-pb-card table.dataTable thead th[data-pb-group]');
            if (!th) return;
            ev.preventDefault();
            setGroup(th.getAttribute('data-pb-group') || '');
          }, true);
        })();"
      ))
    )
  })

  output$recluster_new_pb_empty_group_note_ui <- renderUI({
    df <- .pseudobulk_table_data()
    groups <- .pb_table_group_values(df)
    visible_groups <- input$recluster_new_pb_visible_groups
    if (is.null(visible_groups)) visible_groups <- groups
    visible_groups <- intersect(as.character(visible_groups), groups)
    empty_groups <- .pb_empty_group_values(df, visible_groups)
    if (!length(empty_groups)) return(NULL)
    div(
      class = "recluster-new-pb-empty-note",
      sprintf(
        "No finite DE metrics were returned for %s. This usually means edgeR could not compute usable statistics for those cluster comparisons after pseudobulk replicate checks or expression filtering.",
        paste(vapply(empty_groups, .pb_group_label, character(1)), collapse = ", ")
      )
    )
  })

  output$recluster_new_pb_table <- renderDT({
    df <- .pseudobulk_table_data()
    if (!is.data.frame(df) || !nrow(df)) {
      return(datatable(data.frame(note = "Run pseudobulk table to view results."), rownames = FALSE, selection = "none", options = list(dom = "t")))
    }

    groups <- .pb_table_group_values(df)
    visible_groups <- input$recluster_new_pb_visible_groups
    if (is.null(visible_groups)) visible_groups <- groups
    visible_groups <- intersect(as.character(visible_groups), groups)
    highlight_group <- if (length(visible_groups)) visible_groups[[1]] else ""
    built <- .pb_loupe_table(df, visible_groups, highlight_group)
    if (!isTRUE(built$loupe)) {
      return(datatable(built$data, rownames = FALSE, selection = "none", options = list(dom = "t", scrollX = TRUE, paging = FALSE)))
    }

    col_defs <- list(
      list(className = "dt-left pb-gene-col", targets = 0, width = "96px")
    )
    metric_render <- DT::JS(
      "function(data, type, row, meta) {
        if (data === null || data === undefined || data === '' || (typeof data === 'number' && !isFinite(data))) {
          return type === 'display' ? '<span class=\"pb-na\">NA</span>' : data;
        }
        var num = Number(data);
        if (!isFinite(num)) {
          return type === 'display' ? '<span class=\"pb-na\">NA</span>' : data;
        }
        if (type !== 'display' && type !== 'filter') return num;
        var abs = Math.abs(num);
        if (abs > 0 && (abs < 0.001 || abs >= 1000)) return num.toExponential(2);
        return Number(num.toPrecision(3)).toString();
      }"
    )
    for (group_value in built$groups) {
      targets <- built$group_targets[[group_value]] %||% integer(0)
      if (!length(targets)) next
      is_highlight <- identical(as.character(group_value), as.character(built$highlight_group))
      group_class <- paste0("pb-dt-group pb-dt-group-", .safe_key(group_value))
      col_defs[[length(col_defs) + 1L]] <- list(
        className = paste("dt-right", group_class, if (is_highlight) "pb-highlight-col" else "pb-muted-col"),
        targets = targets,
        width = if (is_highlight) "78px" else "54px",
        render = metric_render
      )
    }

    dt <- datatable(
      built$data,
      container = built$container,
      class = "compact nowrap",
      rownames = FALSE,
      selection = "none",
      options = list(
        dom = "t",
        scrollX = TRUE,
        scrollY = "520px",
        autoWidth = FALSE,
        scrollCollapse = TRUE,
        paging = FALSE,
        ordering = TRUE,
        searching = FALSE,
        info = TRUE,
        orderClasses = FALSE,
        columnDefs = col_defs
      )
    )
    highlight_cols <- built$group_cols[[built$highlight_group]] %||% character(0)
    if (length(highlight_cols)) {
      dt <- formatStyle(
        dt,
        columns = highlight_cols,
        backgroundColor = "#fff7ed",
        color = "#7c2d12"
      )
    }
    dt
  }, server = FALSE)

  .active_violin_group_col <- reactive({
    profiles <- recluster_new_data$metadata_profiles
    if (!length(profiles)) return("")

    open_col <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    if (nzchar(open_col) && open_col %in% names(profiles)) return(open_col)

    col_now <- .scalar_chr(recluster_new_data$metadata_active_column, default = "")
    if (nzchar(col_now) && col_now %in% names(profiles)) return(col_now)

    cluster_cols <- names(profiles)[vapply(profiles, function(p) identical(p$bucket, "cluster"), logical(1))]
    if (length(cluster_cols)) return(cluster_cols[[1]])
    names(profiles)[[1]]
  })

  .violin_plot_cache_signature <- function() {
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return("")
    
    group_col <- .active_violin_group_col()
    if (!nzchar(group_col) || !(group_col %in% colnames(recluster_new_data$plot_df))) return("")
    
    plot_groups <- as.character(recluster_new_data$plot_df[[group_col]] %||% character(0))
    plot_groups[is.na(plot_groups) | !nzchar(plot_groups)] <- "(NA)"
    lv <- .sort_numeric_first(unique(plot_groups))
    
    profiles <- recluster_new_data$metadata_profiles
    selected_lv <- character(0)
    mode_now <- "category"
    if (length(profiles) && !is.null(profiles[[group_col]])) {
      p <- profiles[[group_col]]
      mode_now <- .resolved_mode(p, .scalar_chr(input[[.mode_input_id(group_col)]], default = p$default_mode %||% "category"))
      if (identical(mode_now, "category")) {
        selected_lv <- .selected_levels_for_column(group_col, p)
      }
    }
    
    pal <- .level_color_map(obj, group_col, lv)
    pal_sig <- paste(names(pal), pal, sep = "=", collapse = "|")
    
    universe <- rownames(recluster_new_data$plot_df %||% data.frame())
    
    paste(
      .scalar_chr(recluster_new_loaded_object_name(), default = ""),
      .current_expr_tab(),
      .scalar_chr(input$recluster_new_gene_expr_select_1, default = ""),
      group_col,
      mode_now,
      paste(selected_lv, collapse = "|"),
      .scalar_chr(input$recluster_new_split_by_select, default = ""),
      .scalar_chr(input$recluster_new_assay_select, default = ""),
      .scalar_chr(input$recluster_new_slot_select, default = ""),
      .cell_set_signature(all_selected_cells(), universe),
      pal_sig,
      sep = "::"
    )
  }

  observe({
    if (!.db_tab_is_active()) {
      return(invisible(NULL))
    }
    if (!(.current_expr_tab() %in% c("violin", "stacked"))) {
      p_empty <- plot_ly(source = "recluster_new_plot_source") %>%
        add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
        layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      violin_plot_rendered(p_empty)
      return(invisible(NULL))
    }
    
    plot_cache_sig <- .violin_plot_cache_signature()
    stored_sig <- isolate(recluster_new_data$violin_plot_cache_sig)
    stored_cache <- isolate(recluster_new_data$violin_plot_cache)
    if (nzchar(plot_cache_sig) &&
        identical(plot_cache_sig, stored_sig) &&
        inherits(stored_cache, "plotly")) {
      if (is.null(isolate(violin_plot_rendered()))) { # Prevent invalidation loop by isolating reactives
        violin_plot_rendered(stored_cache)
      }
      return(invisible(NULL))
    }
    
    req(recluster_new_data$seurat_obj, recluster_new_data$plot_df)

    gene_name <- .scalar_chr(input$recluster_new_gene_expr_select_1, default = "")

    group_col <- .active_violin_group_col()
    validate(need(nzchar(group_col), "No active metadata grouping is available."))
    validate(need(group_col %in% colnames(recluster_new_data$plot_df), "Active metadata grouping column is missing from plot data."))

    plot_groups <- as.character(recluster_new_data$plot_df[[group_col]] %||% character(0))
    plot_groups[is.na(plot_groups) | !nzchar(plot_groups)] <- "(NA)"
    lv <- .sort_numeric_first(unique(plot_groups))
    profiles <- recluster_new_data$metadata_profiles
    if (length(profiles) && !is.null(profiles[[group_col]])) {
      p <- profiles[[group_col]]
      mode_now <- .resolved_mode(p, .scalar_chr(input[[.mode_input_id(group_col)]], default = p$default_mode %||% "category"))
      if (identical(mode_now, "category")) {
        selected_lv <- .selected_levels_for_column(group_col, p)
        if (length(selected_lv)) lv <- lv[lv %in% selected_lv]
      }
    }
    lv <- lv[nzchar(lv)]
    if (!length(lv)) lv <- .sort_numeric_first(unique(plot_groups))

    expr_tab <- .current_expr_tab()
    if (identical(expr_tab, "pseudobulk")) {
      p_bulk <- plot_ly() %>%
        add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
        layout(
          title = "Pseudobulk table mode: use the tab below to run and view results.",
          xaxis = list(visible = FALSE),
          yaxis = list(visible = FALSE),
          annotations = list(list(
            text = "Pseudobulk table mode: use the tab below to run and view results.",
            x = 0.5, y = 0.5, xref = "paper", yref = "paper", showarrow = FALSE,
            font = list(size = 14, color = "#6b7280")
          )),
          margin = list(l = 20, r = 20, t = 55, b = 20)
        )
      recluster_new_data$violin_plot_cache_sig <- plot_cache_sig
      recluster_new_data$violin_plot_cache <- p_bulk
      violin_plot_rendered(p_bulk)
      return(invisible(NULL))
    }
    
    if (identical(expr_tab, "stacked")) {
      split_by <- .scalar_chr(input$recluster_new_split_by_select, default = "None")
      use_split <- nzchar(split_by) && !identical(split_by, "None") && (split_by %in% colnames(recluster_new_data$plot_df))
      split_vals <- if (use_split) as.character(recluster_new_data$plot_df[[split_by]] %||% character(0)) else rep("Selected levels", length(plot_groups))
      split_vals[is.na(split_vals) | !nzchar(split_vals)] <- "(NA)"
      split_levels <- .sort_numeric_first(unique(split_vals))

      pal <- .level_color_map(recluster_new_data$seurat_obj, group_col, lv)
      pbar <- plot_ly()
      for (g in lv) {
        y_vals <- vapply(split_levels, function(sv) sum(plot_groups == g & split_vals == sv), numeric(1))
        pbar <- add_trace(
          pbar,
          x = split_levels,
          y = y_vals,
          type = "bar",
          name = g,
          marker = list(color = pal[[g]] %||% "#4B5563")
        )
      }
      p_res <- pbar %>% layout(
        title = paste0(RECLUSTER_NEW_UI_TEXT$t_text_violin_no_gene, " (", group_col, ")"),
        xaxis = list(title = if (use_split) split_by else ""),
        yaxis = list(title = "Cell count"),
        barmode = "stack",
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.2, yanchor = "top"),
        margin = list(l = 55, r = 20, t = 40, b = 90)
      )
      recluster_new_data$violin_plot_cache_sig <- plot_cache_sig
      recluster_new_data$violin_plot_cache <- p_res
      violin_plot_rendered(p_res)
      return(invisible(NULL))
    }

    if (!nzchar(gene_name)) {
      p_no_gene <- plot_ly() %>%
        add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
        layout(
          title = "Choose a gene to show violin plot.",
          xaxis = list(visible = FALSE),
          yaxis = list(visible = FALSE),
          annotations = list(list(
            text = "Choose a gene to show violin plot.",
            x = 0.5, y = 0.5, xref = "paper", yref = "paper", showarrow = FALSE,
            font = list(size = 16, color = "#6b7280")
          )),
          margin = list(l = 20, r = 20, t = 60, b = 20)
        )
      recluster_new_data$violin_plot_cache_sig <- plot_cache_sig
      recluster_new_data$violin_plot_cache <- p_no_gene
      violin_plot_rendered(p_no_gene)
      return(invisible(NULL))
    }

    assay_use <- .scalar_chr(input$recluster_new_assay_select, default = as.character(DefaultAssay(recluster_new_data$seurat_obj) %||% ""))
    slot_use <- .scalar_chr(input$recluster_new_slot_select, default = "data")
    expr <- .fetch_gene_values(recluster_new_data$seurat_obj, assay_use, gene_name, slot_use)
    validate(need(!is.null(expr), sprintf("Gene '%s' is not available in assay '%s' (%s).", gene_name, assay_use, slot_use)))
    df <- data.frame(
      cell_id = names(expr),
      expr = as.numeric(expr),
      group = as.character(recluster_new_data$plot_df[names(expr), group_col, drop = TRUE]),
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
    df$group <- ifelse(is.na(df$group) | !nzchar(df$group), "(NA)", df$group)
    df <- df[df$group %in% lv, , drop = FALSE]
    df$group <- factor(df$group, levels = lv)

    sel <- all_selected_cells()
    selected_in_df <- intersect(sel, df$cell_id)
    highlight_selection <- length(selected_in_df) > 0L && length(selected_in_df) < length(unique(df$cell_id))
    df$selected <- isTRUE(highlight_selection) & df$cell_id %in% selected_in_df

    pal <- .level_color_map(recluster_new_data$seurat_obj, group_col, lv)
    .alpha_color <- function(col, alpha = 0.25) {
      tryCatch(grDevices::adjustcolor(col, alpha.f = alpha), error = function(e) col)
    }
    .cell_jitter <- function(ids, width = 0.1) {
      ids <- as.character(ids %||% character(0))
      if (!length(ids)) return(numeric(0))
      raw <- vapply(ids, function(id) {
        vals <- utf8ToInt(id)
        if (!length(vals)) return(0)
        sum(vals * seq_along(vals))
      }, numeric(1))
      (((raw %% 1000) / 999) - 0.5) * width
    }

    df$group_chr <- as.character(df$group)
    df$x_center <- match(df$group_chr, lv)
    df$x_dot <- df$x_center - 0.2 + .cell_jitter(df$cell_id)
    df$x_box <- df$x_center
    df$x_violin <- df$x_center + 0.1
    df$dot_color <- vapply(df$group_chr, function(g) .scalar_chr(pal[[g]], default = "#4B5563"), character(1))

    p <- plot_ly()
    for (g in lv) {
      sub_df <- df[df$group_chr == g, , drop = FALSE]
      if (!nrow(sub_df)) next
      col_g <- .scalar_chr(pal[[g]], default = "#4B5563")
      p <- add_trace(
        p,
        data = sub_df,
        x = ~x_violin,
        y = ~expr,
        type = "violin",
        side = "positive",
        points = FALSE,
        spanmode = "hard",
        scalemode = "width",
        width = 0.52,
        line = list(color = col_g, width = 1),
        fillcolor = .alpha_color(col_g, 0.24),
        meanline = list(visible = FALSE),
        hoverinfo = "skip",
        showlegend = FALSE,
        name = g
      )
      p <- add_boxplot(
        p,
        data = sub_df,
        x = ~x_box,
        y = ~expr,
        boxpoints = FALSE,
        width = 0.16,
        line = list(color = col_g, width = 1),
        fillcolor = .alpha_color(col_g, 0.18),
        marker = list(color = col_g),
        hoverinfo = "skip",
        showlegend = FALSE,
        name = g
      )
    }

    p <- add_trace(
      p,
      data = df,
      x = ~x_dot,
      y = ~expr,
      type = "scattergl",
      mode = "markers",
      marker = list(color = ~dot_color, size = 2.1, opacity = 0.3),
      hoverinfo = "skip",
      showlegend = FALSE,
      name = "Cells"
    )

    sel_df <- df[df$selected, , drop = FALSE]
    if (nrow(sel_df)) {
      p <- add_trace(
        p,
        data = sel_df,
        x = ~x_dot,
        y = ~expr,
        type = "scattergl",
        mode = "markers",
        name = "Selected cells",
        marker = list(color = "#C71585", size = 3.4, opacity = 0.82),
        text = ~paste0("Cell: ", cell_id, "<br>", group_col, ": ", group_chr, "<br>", gene_name, ": ", signif(expr, 4)),
        hoverinfo = "text",
        inherit = FALSE,
        showlegend = FALSE
      )
    }

    p_final <- p %>% layout(
      title = paste0(gene_name, " (grouped by ", group_col, ")"),
      xaxis = list(title = group_col, tickmode = "array", tickvals = seq_along(lv), ticktext = lv),
      yaxis = list(title = paste0(gene_name, " expression")),
      showlegend = FALSE,
      margin = list(l = 55, r = 20, t = 40, b = 65)
    )

    recluster_new_data$violin_plot_cache_sig <- plot_cache_sig
    recluster_new_data$violin_plot_cache <- p_final
    violin_plot_rendered(p_final)
    invisible(NULL)
  })

  output$recluster_new_violin_plot <- renderPlotly({
    if (!.db_tab_is_active()) {
      return(
        plot_ly(source = "recluster_new_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    req(violin_plot_rendered())
  })

  output$recluster_new_selected_cell_count_output <- renderText({
    paste(RECLUSTER_NEW_UI_TEXT$t_text_selected_barcodes, length(recluster_new_data$selected_cells), "cells")
  })

  observe({
    selected_cells_now <- checked_population_cells()
    next_text <- paste(RECLUSTER_NEW_UI_TEXT$t_text_selected_total, length(selected_cells_now), "cells")
    if (!identical(next_text, isolate(final_cell_count_text()))) {
      final_cell_count_text(next_text)
    }
    invisible(NULL)
  })

  output$recluster_new_final_cell_count_output <- renderText({
    final_cell_count_text()
  })

  observeEvent(input$recluster_new_run_btn, {
    selected_cells_now <- checked_population_cells()
    if (!length(selected_cells_now)) {
      showNotification("Select at least one population before reclustering.", type = "error")
      return(invisible(NULL))
    }
    # Agent note: Recluster object membership is defined only by checked
    # population levels. Lasso, expression, and saved-group state must not
    # silently replace this explicit population selection.
    recluster_new_pending_population_cells(selected_cells_now)
    obj <- recluster_new_data$seurat_obj
    req(obj)
    md <- tryCatch(obj@meta.data, error = function(e) data.frame())
    md_cols <- colnames(md %||% data.frame())
    unknown_cols <- md_cols[vapply(md_cols, function(nm) identical(metadata_policy_classify_column(nm), "unknown"), logical(1))]
    src_name <- .scalar_chr(shared_data$active_object_name, default = "source")
    suffix_seed <- metadata_policy_default_suffix(src_name)

    showModal(modalDialog(
      title = RECLUSTER_NEW_UI_TEXT$t_text_name_subset,
      textInput("recluster_new_subset_name", RECLUSTER_NEW_UI_TEXT$t_label_name_subset, placeholder = RECLUSTER_NEW_UI_TEXT$t_label_name_subset_placeholder),
      textInput("recluster_new_subset_suffix", RECLUSTER_NEW_UI_TEXT$t_label_suffix_for_metadata, value = suffix_seed),
      div(class = "app-note-box control-note", p(class = "recluster-new-secondary-text", RECLUSTER_NEW_UI_TEXT$t_text_suffix_help)),
      if (length(unknown_cols)) checkboxGroupInput(
        "recluster_new_unknown_keep_cols",
        RECLUSTER_NEW_UI_TEXT$t_label_unknown_keep_unsuffixed,
        choices = unknown_cols,
        selected = character(0)
      ),
      footer = tagList(
        modalButton("Cancel"),
        actionButton("recluster_new_confirm_btn", RECLUSTER_NEW_UI_TEXT$t_btn_create_subset, class = "btn-success")
      )
    ))
  })

  observeEvent(input$recluster_new_confirm_btn, {
    overlay_show(RECLUSTER_NEW_UI_TEXT$t_text_creating_subset)
    on.exit(overlay_hide(), add = TRUE)

    seurat_obj <- recluster_new_data$seurat_obj
    selected_cells <- recluster_new_pending_population_cells()
    new_name <- .scalar_chr(input$recluster_new_subset_name, default = "")
    suffix_raw <- .scalar_chr(input$recluster_new_subset_suffix, default = "")
    unknown_keep <- as.character(input$recluster_new_unknown_keep_cols %||% character(0))

    req(seurat_obj)
    if (!length(selected_cells)) {
      showNotification("Select at least one population before reclustering.", type = "error")
      return(invisible(NULL))
    }
    req(isTruthy(new_name))
    if (new_name %in% names(shared_data$all_seurat_objects)) {
      showNotification(RECLUSTER_NEW_UI_TEXT$t_text_name_conflict, type = "error")
      return(invisible(NULL))
    }

    subset_obj <- tryCatch(subset(seurat_obj, cells = selected_cells), error = function(e) NULL)
    req(subset_obj)
    rename_res <- tryCatch(
      metadata_policy_rename_for_subset(
        md = subset_obj@meta.data,
        source_object_name = .scalar_chr(shared_data$active_object_name, default = "source"),
        custom_suffix = suffix_raw,
        unknown_keep = unknown_keep
      ),
      error = function(e) e
    )
    if (inherits(rename_res, "error")) {
      showNotification(sprintf("%s %s", RECLUSTER_NEW_UI_TEXT$t_text_suffix_conflict, conditionMessage(rename_res)), type = "error")
      return(invisible(NULL))
    }
    subset_obj@meta.data <- rename_res$meta
    parent_name <- .scalar_chr(shared_data$active_object_name, default = "")
    subset_obj <- .reset_subset_analysis_state(subset_obj, source_object_name = parent_name)
    subset_obj <- metadata_policy_add_audit(
      subset_obj,
      source_module = "data_browser_new_subset_create",
      columns = colnames(subset_obj@meta.data),
      decision = "subset_create_with_suffix_policy",
      details = list(
        source_object = .scalar_chr(shared_data$active_object_name, default = ""),
        suffix = rename_res$suffix,
        unknown_keep_unsuffixed = unknown_keep
      )
    )
    removeModal()

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
        created = Sys.time(),
        source_module = "data_browser_new_subset_create"
      )
    )

    shared_data$active_object_name <- new_name
    recluster_new_loaded_object_name("")
    .load_active_recluster_new_object(new_name)

    showNotification(paste("New subset '", new_name, "' created and activated.", sep = ""), type = "message")
  })

  # Reactive values/helper for VDJ clone explorer in Data Browser
  # Populate dropdowns when Seurat object changes
  observe({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    md <- obj@meta.data
    cols <- colnames(md)
    req(length(cols) > 0)
    
    # Clone cols candidates
    clone_candidates <- c("vdj_tcr_clone", "vdj_bcr_clone", "tcr_clone", "bcr_clone", "cdr3")
    clone_hit <- clone_candidates[clone_candidates %in% cols]
    clone_sel <- if (length(clone_hit)) clone_hit[[1]] else cols[[1]]
    
    # Cond cols candidates
    cond_candidates <- c("condition", "sample", "orig.ident", "group", "treatment")
    cond_hit <- cond_candidates[cond_candidates %in% cols]
    cond_sel <- if (length(cond_hit)) cond_hit[[1]] else cols[[1]]
    
    updateSelectInput(session, "recluster_new_tcr_clone_col", choices = cols, selected = clone_sel)
    updateSelectInput(session, "recluster_new_tcr_cond_col", choices = cols, selected = cond_sel)
  })
  
  # Reactive expression to build clone table
  .tcr_clone_table_data <- reactive({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    clone_col <- input$recluster_new_tcr_clone_col
    cond_col <- input$recluster_new_tcr_cond_col
    min_size <- as.integer(input$recluster_new_tcr_min_size %||% 1)
    chain_mode <- input$recluster_new_tcr_chain %||% "tcr"
    
    req(clone_col, cond_col)
    md <- obj@meta.data
    req(clone_col %in% colnames(md), cond_col %in% colnames(md))
    
    clones <- as.character(md[[clone_col]])
    conds <- as.character(md[[cond_col]])
    
    # Filter out empty, unknown, etc.
    valid_idx <- which(nzchar(clones) & clones != "unknown" & clones != "0" & !is.na(clones))
    if (!length(valid_idx)) return(NULL)
    
    df <- data.frame(
      barcode = rownames(md)[valid_idx],
      clone = clones[valid_idx],
      condition = conds[valid_idx],
      stringsAsFactors = FALSE
    )
    
    # Group by clone to get statistics
    clone_stats <- df |>
      dplyr::group_by(clone) |>
      dplyr::summarise(
        cells = dplyr::n(),
        conditions = paste(sort(unique(condition)), collapse = ", "),
        n_cond = dplyr::n_distinct(condition),
        .groups = "drop"
      ) |>
      dplyr::filter(cells >= min_size)
    
    if (!nrow(clone_stats)) return(NULL)
    
    # Add proportion of repertoire
    total_valid <- length(valid_idx)
    clone_stats$proportion <- round((clone_stats$cells / total_valid) * 100, 2)
    clone_stats$sharing <- ifelse(clone_stats$n_cond > 1, "Shared", "Unique")
    
    # Fetch CDR3 AA and NT sequences from raw_contigs if available
    active_nm <- shared_data$active_object_name
    entry <- tryCatch(shared_data$all_seurat_objects[[active_nm]], error = function(e) NULL)
    raw_contigs <- tryCatch(entry$vdj_payload$raw_contigs, error = function(e) NULL)
    
    clone_stats$cdr3_aa <- "N/A"
    clone_stats$cdr3_nt <- "N/A"
    
    if (is.data.frame(raw_contigs) && nrow(raw_contigs)) {
      raw_clone_col_candidates <- colnames(raw_contigs)[colnames(raw_contigs) %in% c("wl_vdj_clone_input", "raw_clonotype_id", "clone_id", "clone")]
      raw_cdr3_col_candidates <- colnames(raw_contigs)[colnames(raw_contigs) %in% c("cdr3", "cdr3s_aa", "cdr3_aa")]
      raw_nt_col_candidates <- colnames(raw_contigs)[colnames(raw_contigs) %in% c("cdr3_nt", "cdr3s_nt", "cdr3_nt")]
      
      if (length(raw_clone_col_candidates) && length(raw_cdr3_col_candidates)) {
        raw_clone_col <- raw_clone_col_candidates[[1]]
        raw_cdr3_col <- raw_cdr3_col_candidates[[1]]
        raw_nt_col <- if (length(raw_nt_col_candidates)) raw_nt_col_candidates[[1]] else ""
        
        # Group by clone in raw_contigs and paste unique CDR3s
        cdr3_map <- raw_contigs |>
          dplyr::group_by(dplyr::across(dplyr::all_of(raw_clone_col))) |>
          dplyr::summarise(
            cdr3_aa = paste(unique(as.character(.data[[raw_cdr3_col]])), collapse = "; "),
            cdr3_nt = if (nzchar(raw_nt_col) && raw_nt_col %in% colnames(raw_contigs)) {
              paste(unique(as.character(.data[[raw_nt_col]])), collapse = "; ")
            } else {
              "N/A"
            },
            .groups = "drop"
          )
        
        # Merge mappings
        colnames(cdr3_map)[1] <- "clone"
        cdr3_map$clone <- as.character(cdr3_map$clone)
        clone_stats <- clone_stats |>
          dplyr::left_join(cdr3_map, by = "clone")
        
        clone_stats$cdr3_aa[is.na(clone_stats$cdr3_aa)] <- "N/A"
        clone_stats$cdr3_nt[is.na(clone_stats$cdr3_nt)] <- "N/A"
      }
    }
    
    # Sort by cell count descending
    clone_stats |> dplyr::arrange(desc(cells))
  })
  
  # Render DT Clone Table
  output$recluster_new_tcr_table <- DT::renderDataTable({
    tbl <- .tcr_clone_table_data()
    validate(need(!is.null(tbl) && nrow(tbl) > 0, "No clone statistics available. Confirm VDJ metadata is applied to this object."))
    
    # Format columns for display
    display_tbl <- tbl[, c("clone", "cells", "proportion", "sharing", "conditions", "cdr3_aa", "cdr3_nt")]
    colnames(display_tbl) <- c("Clone ID", "Total Cells", "Proportion (%)", "Sharing Status", "Conditions", "CDR3 AA", "CDR3 NT")
    
    DT::datatable(
      display_tbl,
      selection = "multiple",
      rownames = FALSE,
      options = list(
        pageLength = 10,
        dom = "lfrtip",
        order = list(list(1, 'desc'))
      )
    )
  })
  
  # React to row selection: Highlight cells in UMAP by appending to selected_cells
  observeEvent(input$recluster_new_tcr_table_rows_selected, {
    tbl <- .tcr_clone_table_data()
    req(tbl)
    selected_rows <- input$recluster_new_tcr_table_rows_selected
    
    obj <- recluster_new_data$seurat_obj
    req(obj)
    clone_col <- input$recluster_new_tcr_clone_col
    md <- obj@meta.data
    
    if (!length(selected_rows)) {
      recluster_new_data$selected_cells <- character(0)
    } else {
      selected_clones <- tbl$clone[selected_rows]
      clones_in_metadata <- as.character(md[[clone_col]])
      matched_barcodes <- rownames(md)[clones_in_metadata %in% selected_clones]
      
      recluster_new_data$selected_cells <- matched_barcodes
    }
  }, ignoreNULL = FALSE)
  
  # Select All button click
  observeEvent(input$recluster_new_tcr_select_all_btn, {
    tbl <- .tcr_clone_table_data()
    req(tbl)
    selected_rows <- input$recluster_new_tcr_table_rows_selected
    validate(need(length(selected_rows) > 0, "Select one or more clones in the table first."))
    
    selected_clones <- tbl$clone[selected_rows]
    obj <- recluster_new_data$seurat_obj
    req(obj)
    clone_col <- input$recluster_new_tcr_clone_col
    md <- obj@meta.data
    
    clones_in_metadata <- as.character(md[[clone_col]])
    matched_barcodes <- rownames(md)[clones_in_metadata %in% selected_clones]
    
    recluster_new_data$selected_cells <- unique(c(recluster_new_data$selected_cells, matched_barcodes))
    showNotification(sprintf("Added %d cells from selected clone(s) to Selection Workspace.", length(matched_barcodes)), type = "message")
  })
  
  # Clonal Distribution Plot
  output$recluster_new_tcr_dist_plot <- renderPlotly({
    tbl <- .tcr_clone_table_data()
    req(tbl)
    
    selected_rows <- input$recluster_new_tcr_table_rows_selected
    if (!length(selected_rows)) selected_rows <- seq_len(min(5, nrow(tbl)))
    
    selected_clones <- tbl$clone[selected_rows]
    
    obj <- recluster_new_data$seurat_obj
    req(obj)
    clone_col <- input$recluster_new_tcr_clone_col
    cond_col <- input$recluster_new_tcr_cond_col
    md <- obj@meta.data
    
    clones <- as.character(md[[clone_col]])
    conds <- as.character(md[[cond_col]])
    
    df <- data.frame(
      clone = clones,
      condition = conds,
      stringsAsFactors = FALSE
    )
    df <- df[df$clone %in% selected_clones, ]
    req(nrow(df) > 0)
    
    plot_df <- df |>
      dplyr::count(condition, clone)
    
    p <- ggplot(plot_df, aes(x = clone, y = n, fill = condition)) +
      geom_col(position = "dodge") +
      theme_classic(base_size = 10) +
      labs(x = "Clone ID", y = "Cell Count", fill = "Condition") +
      theme(axis.text.x = element_text(angle = 30, hjust = 1))
    
    ggplotly(p)
  })
}

# Backward-compatible naming alias: this page is the Data Browser (New)
# while keeping existing route/input contracts (`recluster_new_*`).
data_browser_new_ui <- recluster_new_ui
data_browser_new_server <- recluster_new_server
