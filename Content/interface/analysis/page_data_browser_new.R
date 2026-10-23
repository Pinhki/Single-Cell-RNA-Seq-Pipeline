# R/page_data_browser_new_ui.R
# State-sync contract: read docs/agents/interface/ANALYSIS_STATE_SYNC_CONTRACT.md
# before changing Data Browser observers, object transitions, or update inputs.
# Persistable state belongs to the active Seurat object's @misc; UI inputs are views.

# DATA BROWSER COLOR PALETTE KNOB
# Options: "Default Seurat", or any key from all_palettes (e.g. "My Lab Palette 1", "Brewer: Set2", etc.)
DATA_BROWSER_DEFAULT_PALETTE <- "Default Seurat"

# Agent note: Keep Data Browser rename and palette controls on one Bootstrap
# SVG icon source so their small toolbar glyphs remain visually consistent.
.recluster_new_bootstrap_icon <- function(name, class = "recluster-new-bootstrap-icon") {
  if (identical(name, "palette")) {
    return(tags$svg(
      class = class,
      viewBox = "0 0 16 16",
      fill = "currentColor",
      `aria-hidden` = "true",
      tags$path(d = "M8 5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3m4 3a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3M5.5 7a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0m.5 6a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3"),
      tags$path(d = "M16 8c0 3.15-1.866 2.585-3.567 2.07C11.42 9.763 10.465 9.473 10 10c-.603.683-.475 1.819-.351 2.92C9.826 14.495 9.996 16 8 16a8 8 0 1 1 8-8m-8 7c.611 0 .654-.171.655-.176.078-.146.124-.464.07-1.119-.014-.168-.037-.37-.061-.591-.052-.464-.112-1.005-.118-1.462-.01-.707.083-1.61.704-2.314.369-.417.845-.578 1.272-.618.404-.038.812.026 1.16.104.343.077.702.186 1.025.284l.028.008c.346.105.658.199.953.266.653.148.904.083.991.024C14.717 9.38 15 9.161 15 8a7 7 0 1 0-7 7")
    ))
  }
  if (identical(name, "input-cursor-text")) {
    return(tags$svg(
      class = class,
      viewBox = "0 0 16 16",
      fill = "currentColor",
      `aria-hidden` = "true",
      tags$path(d = "M5 2a.5.5 0 0 1 .5-.5c.862 0 1.573.287 2.06.566.174.099.321.198.44.286.119-.088.266-.187.44-.286A4.17 4.17 0 0 1 10.5 1.5a.5.5 0 0 1 0 1c-.638 0-1.177.213-1.564.434a3.5 3.5 0 0 0-.436.294V7.5H9a.5.5 0 0 1 0 1h-.5v4.272c.1.08.248.187.436.294.387.221.926.434 1.564.434a.5.5 0 0 1 0 1 4.17 4.17 0 0 1-2.06-.566A5 5 0 0 1 8 13.65a5 5 0 0 1-.44.285 4.17 4.17 0 0 1-2.06.566.5.5 0 0 1 0-1c.638-.107 1.177-.214 1.564-.434.188-.107.335-.214.436-.294V8.5H7a.5.5 0 0 1 0-1h.5V3.228a3.5 3.5 0 0 0-.436-.294A3.17 3.17 0 0 0 5.5 2.5.5.5 0 0 1 5 2m2.648 10.645"),
      tags$path(d = "M10 5h4a1 1 0 0 1 1 1v4a1 1 0 0 1-1 1h-4v1h4a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2h-4zM6 5V4H2a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h4v-1H2a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1z")
    ))
  }
  stop(sprintf("Unsupported Data Browser icon: %s", name))
}

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
  t_btn_metadata_rename = "Rename",
  t_btn_metadata_save_rename = "Save rename",
  t_btn_metadata_undo_rename = "Undo rename",
  t_text_metadata_rename_empty = "Enter a new metadata label.",
  t_text_metadata_rename_ascii = "Use ASCII characters for metadata labels.",
  t_text_metadata_rename_duplicate = "That metadata label already exists in this column.",
  t_text_metadata_rename_invalid = "Metadata label or column is no longer valid.",
  t_text_metadata_rename_saved = "Renamed '%s' to '%s' in %s.",
  t_text_metadata_rename_no_undo = "No metadata rename is available to undo.",
  t_text_metadata_rename_wrong_object = "Open the dataset where the last rename was made before undo.",
  t_text_metadata_rename_undone = "Restored the previous labels in %s.",
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
  t_text_advanced_manual = "Import cell barcodes for manual selection. Lasso selection is managed in the separate Lasso Selection card.",
  t_title_recluster = "Create New Object",
  t_btn_save_selection_group = "Save Current Population as Group",
  t_btn_recluster = "Create New Object from Checked Population",
  t_btn_create_subset = "Create New Object",
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
  t_text_name_subset = "Name New Object",
  t_label_name_subset = "Enter a name for this new object:",
  t_label_name_subset_placeholder = "e.g., CD4_T_Cells",
  t_text_subset_note = "This creates a new object only. It does not automatically run re-integration or re-clustering. You may need to run those steps afterward.",
  t_label_suffix_for_metadata = "Suffix for non-protected metadata columns",
  t_label_unknown_keep_unsuffixed = "Unknown metadata columns to keep unsuffixed",
  t_text_suffix_help = "Protected sample-carried metadata keeps original names. Non-protected metadata will be suffixed.",
  t_text_name_conflict = "Object name already exists. Choose a different name.",
  t_text_suffix_conflict = "Metadata rename collision after suffixing. Change the suffix and retry.",
  t_text_preparing_subset = "Preparing object creation...",
  t_text_creating_subset = "Creating new object for analysis...",
  t_title_umap = "UMAP Plot",
  t_title_scatter = "Gene Scatter Plot",
  t_title_interactive_umap = "Interactive UMAP",
  t_text_umap_note = "Saved-group cells use larger cyan fill. Lasso, expression, and advanced manual selections use larger violet fill. In expression selection, the active gene uses a bright orange outline. Normal plot dots keep current metadata or gene expression colors.",
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
  t_text_selected_total = "Cells selected for new object:",
  t_text_selected_barcodes = "Cells selected manually:",
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
          recluster_new_with_busy_spinner(plotlyOutput("recluster_new_rule_stacked_plot", height = "420px"), spinner = "other")
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
          font-size: 11px;
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
          width: 100%;
          /* Neighboring Data Browser controls resolve to a 300px content box
             in this responsive left panel. Keep the radio wrapper on that
             same contract; percentage width alone expands its flex column. */
          max-width: 300px;
          min-width: 0;
          box-sizing: border-box;
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
          width: 100%;
          max-width: 300px;
          box-sizing: border-box;
        }
        .recluster-new-display-toggle .shiny-options-group {
          position: relative;
          display: inline-flex;
          align-items: center;
          width: 100%;
          max-width: 100%;
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
        /* Agent note: Saved-group selection uses cyan so its card cannot be
           confused with violet expression/lasso/manual selection cards. */
        #recluster_new_saved_groups_card.is-cyan-highlight-source {
          box-shadow: 0 0 0 2px rgba(6, 182, 212, 0.72),
                      0 4px 14px rgba(6, 182, 212, 0.28) !important;
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
          font-size: 12px;
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
          min-height: 38px;
          margin: 5px 0;
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
          gap: 8px;
          margin: 0;
          min-width: 0;
          font-size: 16px;
          font-weight: 600;
        }
        .recluster-new-group-toggle input[type='checkbox'] {
          margin-top: 0;
          width: 18px;
          height: 18px;
          flex: 0 0 18px;
        }
        #recluster_new_saved_groups_card .recluster-new-group-toggle input[type='checkbox'] {
          accent-color: #06b6d4;
        }
        .recluster-new-group-meta {
          color: #6b7280;
          font-size: 10px;
          font-weight: 700;
        }
        .recluster-new-saved-group-delete.btn {
          flex: 0 0 auto;
          width: 22px;
          height: 22px;
          min-width: 22px;
          min-height: 22px;
          padding: 0;
          border: 1px solid rgba(220, 38, 38, 0.62);
          border-radius: 5px;
          background: transparent;
          color: rgba(220, 38, 38, 0.62);
          display: inline-flex;
          align-items: center;
          justify-content: center;
          line-height: 1;
          gap: 0;
        }
        .recluster-new-saved-group-delete.btn:hover,
        .recluster-new-saved-group-delete.btn:focus {
          border-color: rgba(185, 28, 28, 0.72);
          background: rgba(254, 226, 226, 0.65);
          color: rgba(185, 28, 28, 0.72);
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
          width: 1em;
          height: 1em;
          flex: 0 0 auto;
          line-height: 1;
        }
        .recluster-new-saved-group-delete .fa,
        .recluster-new-saved-group-delete .fas {
          color: rgba(220, 38, 38, 0.62);
          font-size: 9px;
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
          width: 100%;
        }
        .recluster-new-expr-range .form-group,
        .recluster-new-expr-range .irs,
        .recluster-new-expr-range .recluster-new-expr-distribution,
        .recluster-new-expr-range .recluster-new-expr-distribution .html-widget,
        .recluster-new-expr-range .recluster-new-expr-distribution .plotly {
          width: 100% !important;
          max-width: 100%;
          min-width: 0;
          margin-left: 0 !important;
          margin-right: 0 !important;
          padding-left: 0 !important;
          padding-right: 0 !important;
        }
        .recluster-new-expr-range {
          overflow: visible !important;
        }
        .recluster-new-expr-distribution {
          display: block !important;
          flex: 0 0 148px !important;
          height: 148px !important;
          min-height: 0 !important;
          max-height: 148px !important;
          margin: 0 0 2px;
          overflow: hidden !important;
        }
        /* global.css reserves 260px for generic Plotly outputs. This compact
           QC-style distribution owns a taller bounded box so its density,
           dots, and upper-right title cannot be clipped by the generic rule. */
        .recluster-new-expr-range .shiny-plot-output,
        .recluster-new-expr-range .recluster-new-expr-distribution .html-widget,
        .recluster-new-expr-range .recluster-new-expr-distribution .plotly,
        .recluster-new-expr-range .recluster-new-expr-distribution .js-plotly-plot {
          display: block !important;
          flex: 0 0 148px !important;
          height: 148px !important;
          min-height: 0 !important;
          max-height: 148px !important;
          overflow: hidden !important;
        }
        .recluster-new-expr-range .irs-grid-text {
          font-size: 10px !important;
          white-space: nowrap;
        }
        /* Keep distribution paper and Ion.RangeSlider track on one exact
           content box. Bootstrap/widget horizontal padding must not create a
           few-pixel drift inside the narrow left panel. */
        .recluster-new-expr-range .shiny-plot-output,
        .recluster-new-expr-range .recluster-new-expr-distribution .html-widget,
        .recluster-new-expr-range .recluster-new-expr-distribution .plotly,
        .recluster-new-expr-range .irs {
          box-sizing: border-box;
        }
        /* Keep widget geometry stable. Plotly measures this box when binding;
           changing its CSS width afterward leaves a stale SVG and clips the
           right endpoint. Numeric alignment belongs in Plotly layout margins. */
        .recluster-new-expr-range .recluster-new-expr-distribution {
          width: 100% !important;
          margin-left: 0 !important;
          margin-right: 0 !important;
        }
        .recluster-new-expr-range .irs,
        .recluster-new-expr-range .irs-grid {
          overflow: visible !important;
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
              id = "recluster_new_lasso_selection_card",
              class = "wl-side",
              tags$details(
                class = "recluster-new-fold",
                open = NA,
                tags$summary("Lasso Selection"),
                div(class = "app-secondary-status", textOutput("recluster_new_lasso_selection_count")),
                actionButton(
                  "recluster_new_clear_lasso_btn",
                  "Clear Lasso Selection",
                  icon = icon("times"),
                  class = "btn btn-default btn-sm"
                )
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
              id = "recluster_new_saved_groups_card",
              class = "wl-side recluster-new-saved-groups-card",
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
                actionButton("recluster_new_run_btn", RECLUSTER_NEW_UI_TEXT$t_btn_recluster, icon = icon("plus"), class = "btn-success")
              )
            )
          ),
          column(
            width = 9,
            class = "plot_area_card_style",
            # Agent note: Button feedback starts in capture phase because a
            # server overlay message cannot paint until the current observer
            # yields. Keep each client start paired with a server terminal
            # state; do not replace that pair with a timer or idle heuristic.
            tags$script(HTML(sprintf(
              "(function () {
                if (window.__reclusterNewCreateFeedbackBound) return;
                window.__reclusterNewCreateFeedbackBound = true;
                var state = window.__reclusterNewCreateFeedbackState || {
                  opening: false,
                  creating: false
                };
                window.__reclusterNewCreateFeedbackState = state;
                var openingLabel = %s;
                var creatingLabel = %s;
                function traceCreateFeedback(eventName, details) {
                  if (typeof window.__reclusterNewDataBrowserTrace === 'function') {
                    window.__reclusterNewDataBrowserTrace(eventName, details || {});
                  }
                }
                function buttonFor(id) {
                  return document.getElementById(id);
                }
                function rememberButton(button) {
                  if (!button) return;
                  if (!Object.prototype.hasOwnProperty.call(button, '__reclusterNewOriginalHtml')) {
                    button.__reclusterNewOriginalHtml = button.innerHTML;
                  }
                }
                function setButtonBusy(id, busy, label) {
                  var button = buttonFor(id);
                  if (!button) return;
                  if (busy) {
                    rememberButton(button);
                    button.disabled = true;
                    button.setAttribute('aria-busy', 'true');
                    button.setAttribute('aria-disabled', 'true');
                    button.setAttribute('data-recluster-create-pending', 'true');
                    var labelNode = button.querySelector('.action-label');
                    if (labelNode) labelNode.textContent = label;
                    else button.textContent = label;
                    return;
                  }
                  if (Object.prototype.hasOwnProperty.call(button, '__reclusterNewOriginalHtml')) {
                    button.innerHTML = button.__reclusterNewOriginalHtml;
                  }
                  button.disabled = false;
                  button.removeAttribute('aria-busy');
                  button.removeAttribute('aria-disabled');
                  button.removeAttribute('data-recluster-create-pending');
                }
                function showCreateOverlay(text) {
                  if (window.WLSpinnerOverlay && typeof window.WLSpinnerOverlay.show === 'function') {
                    window.WLSpinnerOverlay.show({
                      id: 'global_overlay',
                      text: text,
                      lightweight: true,
                      lock: true
                    });
                    return;
                  }
                  if (window.console && typeof window.console.warn === 'function') {
                    window.console.warn('[DATA_BROWSER_TRACE] Create-object overlay API is not ready.');
                  }
                }
                function hideCreateOverlay() {
                  if (window.WLSpinnerOverlay && typeof window.WLSpinnerOverlay.hide === 'function') {
                    window.WLSpinnerOverlay.hide({id: 'global_overlay'});
                  }
                }
                function startOpening(event) {
                  if (state.opening) {
                    event.preventDefault();
                    if (typeof event.stopImmediatePropagation === 'function') event.stopImmediatePropagation();
                    traceCreateFeedback('create_object_duplicate_click', {button_id: 'recluster_new_run_btn', phase: 'opening'});
                    return false;
                  }
                  state.opening = true;
                  setButtonBusy('recluster_new_run_btn', true, openingLabel);
                  traceCreateFeedback('create_object_click', {button_id: 'recluster_new_run_btn', phase: 'opening'});
                  showCreateOverlay(openingLabel);
                  return true;
                }
                function startCreating(event) {
                  if (state.creating) {
                    event.preventDefault();
                    if (typeof event.stopImmediatePropagation === 'function') event.stopImmediatePropagation();
                    traceCreateFeedback('create_object_duplicate_click', {button_id: 'recluster_new_confirm_btn', phase: 'creating'});
                    return false;
                  }
                  state.creating = true;
                  setButtonBusy('recluster_new_confirm_btn', true, creatingLabel);
                  traceCreateFeedback('create_object_click', {button_id: 'recluster_new_confirm_btn', phase: 'creating'});
                  showCreateOverlay(creatingLabel);
                  return true;
                }
                function finishOpening() {
                  state.opening = false;
                  setButtonBusy('recluster_new_run_btn', false, openingLabel);
                  hideCreateOverlay();
                  traceCreateFeedback('create_object_terminal', {button_id: 'recluster_new_run_btn', phase: 'opening'});
                }
                function finishCreating() {
                  state.creating = false;
                  setButtonBusy('recluster_new_confirm_btn', false, creatingLabel);
                  hideCreateOverlay();
                  traceCreateFeedback('create_object_terminal', {button_id: 'recluster_new_confirm_btn', phase: 'creating'});
                }
                function handleServerState(payload) {
                  var serverState = String(payload && payload.state || '').toLowerCase();
                  if (serverState === 'open_finished') finishOpening();
                  if (serverState === 'create_finished') finishCreating();
                }
                function bindStateHandler() {
                  if (!window.Shiny || typeof window.Shiny.addCustomMessageHandler !== 'function') return;
                  if (window.__reclusterNewCreateFeedbackHandlerBound) return;
                  window.Shiny.addCustomMessageHandler('recluster-new-create-feedback', handleServerState);
                  window.__reclusterNewCreateFeedbackHandlerBound = true;
                }
                bindStateHandler();
                document.addEventListener('shiny:connected', bindStateHandler, true);
                document.addEventListener('click', function (event) {
                  var target = event && event.target;
                  var confirmButton = target && target.closest ? target.closest('#recluster_new_confirm_btn') : null;
                  if (confirmButton) {
                    startCreating(event);
                    return;
                  }
                  var openingButton = target && target.closest ? target.closest('#recluster_new_run_btn') : null;
                  if (openingButton) startOpening(event);
                }, true);
              })();",
              jsonlite::toJSON(RECLUSTER_NEW_UI_TEXT$t_text_preparing_subset, auto_unbox = TRUE),
              jsonlite::toJSON(RECLUSTER_NEW_UI_TEXT$t_text_creating_subset, auto_unbox = TRUE)
            ))),
            tags$script(HTML("
                (function () {
                  if (window.__reclusterNewTabMirrorBound) return;
                  window.__reclusterNewTabMirrorBound = true;
                  function publishTabValue(id, value) {
                    if (!id || !value || !window.Shiny || !window.Shiny.setInputValue) return false;
                    var root = document.getElementById(id);
                    if (!root) return false;
                    // One completed DOM transition owns one Shiny input
                    // publication. Internal Shiny input state can lag during
                    // rebind; polling it here creates duplicate input storms.
                    if (root.__reclusterNewLastPublishedTab === value) return false;
                    root.__reclusterNewLastPublishedTab = value;
                    Shiny.setInputValue(id, value, { priority: 'event' });
                    return true;
                  }
                  var reclusterNewTabRootSelector = 'ul#recluster_new_tabs, ul#recluster_new_expr_tabs, ul#recluster_new_rule_plot_tabs';
                  function reclusterNewCurrentTabValue(root) {
                    if (!root) return '';
                    var node = root.querySelector('li.active [data-value], [data-value].active, [data-value][aria-selected=\"true\"]');
                    return node ? (node.getAttribute('data-value') || '') : '';
                  }
                  function syncReclusterNewTabRoot(root) {
                    var val = reclusterNewCurrentTabValue(root);
                    if (!root || !root.id || !val) return;
                    publishTabValue(root.id, val);
                  }
                  function syncReclusterNewTabsForTarget(target) {
                    if (!target || !target.matches || !target.matches(reclusterNewTabRootSelector)) return;
                    syncReclusterNewTabRoot(target);
                  }
                  function syncAllReclusterNewTabs() {
                    if (!document.querySelectorAll) return;
                    Array.prototype.forEach.call(
                      document.querySelectorAll(reclusterNewTabRootSelector),
                      function (root) {
                        syncReclusterNewTabRoot(root);
                      }
                    );
                  }
                  function pushTabValue(ev) {
                    if (!window.Shiny || !window.Shiny.setInputValue) return;
                    var node = ev.target && ev.target.closest && ev.target.closest('#recluster_new_tabs [data-value], #recluster_new_expr_tabs [data-value], #recluster_new_rule_plot_tabs [data-value]');
                    if (!node) return;
                    var root = node.closest('ul');
                    var val = node.getAttribute('data-value') || '';
                    if (!root || !root.id || !val) return;
                    publishTabValue(root.id, val);
                  }
                  document.addEventListener('shown.bs.tab', pushTabValue, true);
                  document.addEventListener('shiny:value', function (ev) {
                    syncReclusterNewTabsForTarget(ev.target);
                  }, true);
                  document.addEventListener('shiny:bound', function (ev) {
                    syncReclusterNewTabsForTarget(ev.target);
                  }, true);
                  document.addEventListener('shiny:connected', function () {
                    syncAllReclusterNewTabs();
                  }, true);
                  if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', syncAllReclusterNewTabs, { once: true });
                  } else {
                    syncAllReclusterNewTabs();
                  }
                  if (window.jQuery) {
                    window.jQuery(document)
                      .off('shown.bs.tab.reclusterNewTabMirror')
                      .on('shown.bs.tab.reclusterNewTabMirror', '#recluster_new_tabs [data-value], #recluster_new_expr_tabs [data-value], #recluster_new_rule_plot_tabs [data-value]', pushTabValue);
                  }
                  function reclusterNewCurrentObjectContext() {
                    var roots = document.querySelectorAll('[data-recluster-object-context]');
                    var selected = null;
                    var selectedRevision = -Infinity;
                    for (var i = 0; i < roots.length; i++) {
                      var revisionText = roots[i].getAttribute('data-recluster-object-context-revision');
                      var revision = revisionText === null || revisionText === '' ? NaN : Number(revisionText);
                      if (!selected || (isFinite(revision) && revision >= selectedRevision)) {
                        selected = roots[i];
                        selectedRevision = isFinite(revision) ? revision : selectedRevision;
                      }
                    }
                    if (!selected) return {object: '', context_revision: null};
                    var selectedRevisionText = selected.getAttribute('data-recluster-object-context-revision');
                    return {
                      object: selected.getAttribute('data-recluster-object-context') || '',
                      context_revision: selectedRevisionText === null || selectedRevisionText === '' ? null : Number(selectedRevisionText)
                    };
                  }
                  // Agent note: Keep this trace narrow and bounded. It must expose
                  // browser/Shiny event provenance for delayed saved-group changes
                  // without adding another state writer or a DOM polling loop.
                  if (!window.__reclusterNewDataBrowserTrace) {
                    var dbTraceState = window.__reclusterNewDataBrowserTraceState || {
                      enabled: true,
                      maxEvents: 500,
                      events: []
                    };
                    window.__reclusterNewDataBrowserTraceState = dbTraceState;
                    window.__reclusterNewDataBrowserTrace = function (eventName, details) {
                      if (dbTraceState.enabled !== true) return;
                      var context = reclusterNewCurrentObjectContext();
                      var entry = {
                        timestamp: new Date().toISOString(),
                        event: eventName || '',
                        page: 'data_browser_new',
                        object: context.object || '',
                        context_revision: context.context_revision
                      };
                      if (details && typeof details === 'object') {
                        Object.keys(details).forEach(function (key) {
                          entry[key] = details[key];
                        });
                      }
                      dbTraceState.events.push(entry);
                      if (dbTraceState.events.length > dbTraceState.maxEvents) {
                        dbTraceState.events.splice(0, dbTraceState.events.length - dbTraceState.maxEvents);
                      }
                      if (window.console && typeof window.console.info === 'function') {
                        window.console.info('[DATA_BROWSER_TRACE]', entry);
                      }
                    };
                    window.__reclusterNewDataBrowserTraceDump = function () {
                      return dbTraceState.events.slice();
                    };
                  }
                  var reclusterNewTrace = window.__reclusterNewDataBrowserTrace;
                  if (!window.__reclusterNewDataBrowserTraceListenersBound) {
                    window.__reclusterNewDataBrowserTraceListenersBound = true;
                    var dbTraceOutputPattern = /^recluster_new_(cell_groups_ui|umap_plot|scatter_plot|violin_plot|rule_stacked_plot|rule_scatter_plot|rule_umap_plot|expr_active_distribution|tcr_dist_plot)$/;
                    var traceDataBrowserLifecycleEvent = function (ev) {
                      var target = ev && ev.target;
                      var id = target && target.id ? target.id : '';
                      var isBusyEvent = ev.type === 'shiny:busy' || ev.type === 'shiny:idle';
                      var pagePresent = !!document.querySelector('.recluster-new-page');
                      if (isBusyEvent && !pagePresent) return;
                      if (!isBusyEvent && !dbTraceOutputPattern.test(id)) return;
                      reclusterNewTrace('lifecycle_' + ev.type.replace(':', '_'), {
                        target_id: id,
                        recalculating: !!(target && target.classList && target.classList.contains('recalculating')),
                        saved_group_count: document.querySelectorAll('input[type=checkbox][id^=recluster_new_group_enabled__]').length,
                        page_present: pagePresent
                      });
                    };
                    ['shiny:value', 'shiny:bound', 'shiny:recalculating', 'shiny:recalculated', 'shiny:busy', 'shiny:idle'].forEach(function (eventName) {
                      document.addEventListener(eventName, traceDataBrowserLifecycleEvent, true);
                    });
                    document.addEventListener('shiny:inputchanged', function (ev) {
                      var detail = ev && ev.detail ? ev.detail : {};
                      var inputName = detail.name || (ev && ev.name) || '';
                      if (inputName !== 'recluster_new_saved_group_toggle_event') return;
                      reclusterNewTrace('inputchanged_saved_group_toggle', {
                        input_name: inputName,
                        value: detail.value === undefined ? null : detail.value
                      });
                    }, true);
                  }
                  if (!window.__reclusterNewDataBrowserTraceReady) {
                    window.__reclusterNewDataBrowserTraceReady = true;
                    reclusterNewTrace('trace_ready', {
                      saved_group_selector: 'input[type=checkbox][id^=recluster_new_group_enabled__]',
                      output_scope: 'recluster_new_*plot and recluster_new_cell_groups_ui'
                    });
                  }
                  if (!window.__reclusterNewSavedGroupCheckboxGuardBound) {
                    window.__reclusterNewSavedGroupCheckboxGuardBound = true;
                    var savedGroupCheckboxSelector = 'input[type=checkbox][id^=recluster_new_group_enabled__]';
                    var physicalSavedGroupChanges = window.__reclusterNewPhysicalSavedGroupChanges || new WeakSet();
                    window.__reclusterNewPhysicalSavedGroupChanges = physicalSavedGroupChanges;
                    var savedGroupCheckboxDiag = window.__reclusterNewSavedGroupCheckboxDiag || {
                      allowed: 0,
                      sanitized: 0,
                      server_updates: 0,
                      last: null
                    };
                    window.__reclusterNewSavedGroupCheckboxDiag = savedGroupCheckboxDiag;
                    function traceSavedGroupCheckbox(eventName, node, details) {
                      var payload = {
                        input_id: node && node.id ? node.id : '',
                        checked: node ? !!node.checked : null,
                        default_checked: node ? !!node.defaultChecked : null,
                        canonical: node ? savedGroupCanonicalEnabled(node) : null
                      };
                      if (details && typeof details === 'object') {
                        Object.keys(details).forEach(function (key) {
                          payload[key] = details[key];
                        });
                      }
                      reclusterNewTrace(eventName, payload);
                    }
                    function savedGroupCheckboxFromTarget(target) {
                      if (!target) return null;
                      if (target.matches && target.matches(savedGroupCheckboxSelector)) return target;
                      var toggle = target.closest && target.closest('.recluster-new-group-toggle');
                      return toggle ? toggle.querySelector(savedGroupCheckboxSelector) : null;
                    }
                    function savedGroupCheckboxWrapper(node) {
                      return node && node.closest
                        ? node.closest('[data-recluster-saved-group-canonical-enabled]')
                        : null;
                    }
                    function hardenSavedGroupCheckbox(node) {
                      if (!node || !node.setAttribute) return;
                      node.setAttribute('autocomplete', 'off');
                      node.setAttribute('data-wl-autofill-guard', 'true');
                      if (node.form) node.form.setAttribute('autocomplete', 'off');
                    }
                    function savedGroupCanonicalEnabled(node) {
                      var wrapper = savedGroupCheckboxWrapper(node);
                      if (!wrapper) return null;
                      return wrapper.getAttribute('data-recluster-saved-group-canonical-enabled') === '1';
                    }
                    function recordSavedGroupCheckboxDiagnostic(reason, node) {
                      traceSavedGroupCheckbox(reason || 'saved_group_diagnostic', node);
                      if (!window.__WANLAB_DB_DIAG_MODE) return;
                      savedGroupCheckboxDiag.last = {
                        reason: reason || '',
                        id: node && node.id ? node.id : '',
                        checked: !!(node && node.checked),
                        canonical: savedGroupCanonicalEnabled(node)
                      };
                    }
                    function markPhysicalSavedGroupChange(ev) {
                      if (!ev.isTrusted) return;
                      if (ev.type === 'mousedown' && ev.button !== 0) return;
                      if (ev.type === 'keydown' && ev.key !== ' ' && ev.key !== 'Spacebar' && ev.key !== 'Enter') return;
                      var node = savedGroupCheckboxFromTarget(ev.target);
                      if (node) {
                        physicalSavedGroupChanges.add(node);
                        traceSavedGroupCheckbox('physical_intent_marked', node, {
                          source_event: ev.type,
                          key: ev.key || '',
                          trusted: !!ev.isTrusted
                        });
                      }
                    }
                    document.addEventListener('mousedown', markPhysicalSavedGroupChange, true);
                    document.addEventListener('keydown', markPhysicalSavedGroupChange, true);
                    document.addEventListener('touchstart', markPhysicalSavedGroupChange, true);
                    function sanitizeSavedGroupCheckboxes(root, reason) {
                      var nodes = [];
                      if (root && root.matches && root.matches(savedGroupCheckboxSelector)) nodes.push(root);
                      if (root && root.querySelectorAll) {
                        Array.prototype.forEach.call(root.querySelectorAll(savedGroupCheckboxSelector), function (node) {
                          nodes.push(node);
                        });
                      }
                      nodes.forEach(hardenSavedGroupCheckbox);
                      if (nodes.length) {
                        traceSavedGroupCheckbox('saved_group_dom_scan', null, {
                          reason: reason || '',
                          node_count: nodes.length,
                          states: nodes.map(function (node) {
                            return {
                              id: node.id || '',
                              checked: !!node.checked,
                              default_checked: !!node.defaultChecked,
                              canonical: savedGroupCanonicalEnabled(node)
                            };
                          })
                        });
                      }
                      nodes.forEach(function (node) {
                        if (savedGroupCanonicalEnabled(node) !== false || physicalSavedGroupChanges.has(node)) return;
                        if (!node.checked) return;
                        node.checked = false;
                        node.defaultChecked = false;
                        savedGroupCheckboxDiag.sanitized += 1;
                        recordSavedGroupCheckboxDiagnostic(reason || 'sanitize', node);
                      });
                    }
                    document.addEventListener('change', function (ev) {
                      var node = savedGroupCheckboxFromTarget(ev.target);
                      if (!node) return;
                      var isPhysical = physicalSavedGroupChanges.has(node);
                      traceSavedGroupCheckbox('native_change_seen', node, {
                        physical: isPhysical,
                        trusted: !!ev.isTrusted
                      });
                      if (isPhysical) {
                        physicalSavedGroupChanges.delete(node);
                        var physicalWrapper = savedGroupCheckboxWrapper(node);
                        if (physicalWrapper) {
                          physicalWrapper.setAttribute(
                            'data-recluster-saved-group-canonical-enabled',
                            node.checked ? '1' : '0'
                          );
                        }
                        savedGroupCheckboxDiag.allowed += 1;
                        recordSavedGroupCheckboxDiagnostic('physical_change', node);
                        if (window.Shiny && window.Shiny.setInputValue) {
                          var physicalContext = reclusterNewCurrentObjectContext();
                          window.Shiny.setInputValue('recluster_new_saved_group_toggle_event', {
                            id: node.id,
                            enabled: !!node.checked,
                            object: physicalContext.object,
                            context_revision: physicalContext.context_revision,
                            nonce: Date.now()
                          }, {priority: 'event'});
                          traceSavedGroupCheckbox('custom_toggle_sent', node, {
                            object: physicalContext.object,
                            context_revision: physicalContext.context_revision,
                            enabled: !!node.checked
                          });
                        }
                        ev.preventDefault();
                        ev.stopImmediatePropagation();
                        ev.stopPropagation();
                        return;
                      }
                      if (savedGroupCanonicalEnabled(node) !== false || !node.checked) {
                        traceSavedGroupCheckbox('native_change_ignored', node, {
                          reason: savedGroupCanonicalEnabled(node) !== false ? 'canonical_enabled' : 'unchecked'
                        });
                        return;
                      }
                      node.checked = false;
                      node.defaultChecked = false;
                      ev.preventDefault();
                      ev.stopImmediatePropagation();
                      ev.stopPropagation();
                      savedGroupCheckboxDiag.sanitized += 1;
                      recordSavedGroupCheckboxDiagnostic('blocked_restoration_change', node);
                    }, true);
                    function applySavedGroupServerUpdate(ev) {
                      var message = ev && (ev.message || ev.detail && (ev.detail.message || ev.detail));
                      if (!message || !message.id || message.value === undefined) return;
                      var node = document.getElementById(message.id);
                      if (!node || !node.matches || !node.matches(savedGroupCheckboxSelector)) return;
                      traceSavedGroupCheckbox('server_update_seen', node, {
                        message_value: message.value
                      });
                      var wrapper = savedGroupCheckboxWrapper(node);
                      if (wrapper) {
                        var enabled = message.value === true || message.value === 1 ||
                          message.value === 'true' || message.value === '1';
                        wrapper.setAttribute(
                          'data-recluster-saved-group-canonical-enabled',
                          enabled ? '1' : '0'
                        );
                      }
                      physicalSavedGroupChanges.delete(node);
                      savedGroupCheckboxDiag.server_updates += 1;
                      recordSavedGroupCheckboxDiagnostic('server_update', node);
                      sanitizeSavedGroupCheckboxes(node, 'server_update');
                    }
                    document.addEventListener('shiny:updateinput', applySavedGroupServerUpdate, true);
                    document.addEventListener('shiny:value', function (ev) {
                      sanitizeSavedGroupCheckboxes(ev.target, 'shiny_value');
                    }, true);
                    document.addEventListener('shiny:bound', function (ev) {
                      sanitizeSavedGroupCheckboxes(ev.target, 'shiny_bound');
                    }, true);
                    if (window.jQuery) {
                      window.jQuery(document)
                        .off('shiny:updateinput.reclusterNewSavedGroupGuard')
                        .on('shiny:updateinput.reclusterNewSavedGroupGuard', applySavedGroupServerUpdate);
                    }
                    sanitizeSavedGroupCheckboxes(document, 'initial');
                    reclusterNewTrace('saved_group_guard_bound', null, {
                      selector: savedGroupCheckboxSelector
                    });
                  }
                  document.addEventListener('shiny:bound', function (ev) {
                    var node = ev.target;
                    if (!node || !node.id || !window.Shiny || !window.Shiny.setInputValue) return;
                    if (!/^recluster_new_(gene_expr_select_[1-3]|scatter_gene_[xy]|rule_gene_expr_select_1|rule_scatter_gene_[xy]|expr_add_gene__.+)$/.test(node.id)) return;
                    var boundContext = reclusterNewCurrentObjectContext();
                    var boundRevision = boundContext.context_revision === null || boundContext.context_revision === undefined
                      ? ''
                      : String(boundContext.context_revision);
                    var boundKey = String(boundContext.object || '') + '::' + boundRevision;
                    // Selectize updates can rebind the same node. Publish only
                    // once per node/context; replacement nodes still publish.
                    if (node.__reclusterNewGeneSelectizeBoundKey === boundKey) return;
                    node.__reclusterNewGeneSelectizeBoundKey = boundKey;
                    Shiny.setInputValue('recluster_new_gene_selectize_bound', {
                      id: node.id,
                      object: boundContext.object,
                      context_revision: boundContext.context_revision,
                      key: boundKey
                    }, {priority: 'event'});
                  }, true);
                  function formatExpressionRangeTicks(node) {
                    if (!node || node.id !== 'recluster_new_expr_active_range' || !window.jQuery) return;
                    var host = window.jQuery(node).closest('.form-group').find('.irs').first();
                    if (!host.length) return;
                    var slider = window.jQuery(node).data('ionRangeSlider');
                    var options = slider && slider.options ? slider.options : {};
                    var minValue = Number(options.min);
                    var maxValue = Number(options.max);
                    var hasFiniteDomain = isFinite(minValue) && isFinite(maxValue) && maxValue > minValue;
                    // Handle labels already show selected bounds. Ion's gray
                    // domain labels duplicate them and expose display-only
                    // negative padding as if it were a selectable threshold.
                    host.find('.irs-min, .irs-max').css({ visibility: 'hidden' });
                    var ticks = host.find('.irs-grid-text');
                    var zeroGridTick = null;
                    var zeroGridNumeric = -Infinity;
                    ticks.each(function () {
                      var tick = window.jQuery(this);
                      var storedRaw = tick.attr('data-recluster-new-raw-value');
                      var raw = String(storedRaw === undefined ? tick.text() : storedRaw).replace(/,/g, '').trim();
                      if (!raw.length) return;
                      if (storedRaw === undefined) tick.attr('data-recluster-new-raw-value', raw);
                      var numeric = Number(raw);
                      if (!isFinite(numeric)) return;
                      // Negative display padding belongs to chart breathing
                      // room. Keep first visible numeric tick at zero.
                      if (numeric < 0) {
                        tick.text('').css({ visibility: 'hidden' });
                        if (numeric > zeroGridNumeric) {
                          zeroGridNumeric = numeric;
                          zeroGridTick = tick;
                        }
                      } else {
                        tick.text(numeric.toFixed(2)).css({ visibility: 'visible' });
                      }
                    });
                    // Endpoint handle labels already show the exact bounds;
                    // suppress duplicate grid text at the right edge so it
                    // cannot collide with or overflow past the handle.
                    if (ticks.length > 1) {
                      window.jQuery(ticks[ticks.length - 1]).text('').css({ visibility: 'hidden' });
                    }
                    var fromHandle = host.find('.irs-handle.from').first();
                    var toHandle = host.find('.irs-handle.to').first();
                    var handleParent = fromHandle.parent();
                    host.find('.recluster-new-expr-zero-tick').remove();
                    if (hasFiniteDomain && minValue < 0 && maxValue > 0) {
                      var fromValue = Number(slider && slider.result ? slider.result.from : NaN);
                      var toValue = Number(slider && slider.result ? slider.result.to : NaN);
                      if (!fromHandle.length || !toHandle.length || !handleParent.length ||
                          !isFinite(fromValue) || !isFinite(toValue) || toValue <= fromValue) return;
                      // Ion maps values between actual handle centers, not the
                      // full .irs-grid width. Interpolate in that same physical
                      // coordinate system so zero aligns with Plotly x = 0.
                      var fromCenter = fromHandle.position().left + fromHandle.outerWidth() / 2;
                      var toCenter = toHandle.position().left + toHandle.outerWidth() / 2;
                      var zeroLeft = fromCenter + ((0 - fromValue) / (toValue - fromValue)) * (toCenter - fromCenter);
                      var grid = host.find('.irs-grid').first();
                      if (!grid.length || !zeroGridTick || !zeroGridTick.length) return;
                      var zeroGridLeft = zeroLeft - grid.position().left;
                      zeroGridTick.text('0.00').css({
                        left: zeroGridLeft + 'px',
                        marginLeft: -(zeroGridTick.outerWidth() / 2) + 'px',
                        visibility: 'visible',
                        transform: 'none',
                        textAlign: 'center'
                      });
                      var zeroGridIndex = ticks.index(zeroGridTick);
                      grid.find('.irs-grid-pol:not(.small)').eq(zeroGridIndex).css({ left: zeroGridLeft + 'px' });
                    }
                  }
                  function configureExpressionRangeDisplay(node) {
                    if (!node || node.id !== 'recluster_new_expr_active_range' || !window.jQuery) return;
                    var slider = window.jQuery(node).data('ionRangeSlider');
                    if (!slider || !slider.options || typeof slider.drawHandles !== 'function') return;
                    // Display-only settings. Keep full-precision slider values in
                    // Shiny state; never round thresholds or emit another input.
                    slider.options.prettify_enabled = true;
                    slider.options.prettify = function (value) {
                      var numeric = Number(value);
                      return isFinite(numeric) ? numeric.toFixed(2) : String(value);
                    };
                    // IonRangeSlider shifts endpoint labels inside the track while
                    // preserving their handle values when force_edges is enabled.
                    slider.options.force_edges = true;
                    if (!slider.__reclusterNewCutoffSyncBound) {
                      slider.__reclusterNewCutoffSyncBound = true;
                      var previousOnChange = slider.options.onChange;
                      slider.options.onChange = function (data) {
                        if (typeof previousOnChange === 'function') previousOnChange(data);
                        var root = document.getElementById('recluster_new_expr_active_distribution');
                        var plot = root && root.classList.contains('js-plotly-plot')
                          ? root
                          : root && root.querySelector('.js-plotly-plot');
                        if (!plot || !window.Plotly || !plot.layout || !Array.isArray(plot.layout.shapes)) return;
                        var update = {};
                        plot.layout.shapes.forEach(function (shape, index) {
                          if (shape.name === 'expr-lower-cutoff') {
                            update['shapes[' + index + '].x0'] = Number(data.from);
                            update['shapes[' + index + '].x1'] = Number(data.from);
                          } else if (shape.name === 'expr-upper-cutoff') {
                            update['shapes[' + index + '].x0'] = Number(data.to);
                            update['shapes[' + index + '].x1'] = Number(data.to);
                          }
                        });
                        if (Object.keys(update).length) window.Plotly.relayout(plot, update);
                      };
                    }
                    slider.force_redraw = true;
                    slider.drawHandles();
                    formatExpressionRangeTicks(node);
                  }
                  document.addEventListener('shiny:bound', function (ev) {
                    configureExpressionRangeDisplay(ev.target);
                  }, true);
                  if (window.jQuery) {
                    window.jQuery(document)
                      .off('shiny:bound.reclusterNewExprRangeDisplay')
                      .on('shiny:bound.reclusterNewExprRangeDisplay', function (ev) {
                        configureExpressionRangeDisplay(ev.target);
                      });
                    window.jQuery(document)
                      .off('shiny:updateinput.reclusterNewExprRangeDisplay')
                      .on('shiny:updateinput.reclusterNewExprRangeDisplay', function (ev) {
                        var id = ev.message && ev.message.id;
                        if (id === 'recluster_new_expr_active_range') {
                          formatExpressionRangeTicks(document.getElementById(id));
                        }
                      });
                  }
                  function reclusterNewObjectContextMatches(objectName, contextRevision) {
                    if (!objectName) return false;
                    var expectedRevision = contextRevision === undefined || contextRevision === null
                      ? null
                      : String(contextRevision);
                    var roots = document.querySelectorAll('[data-recluster-object-context]');
                    for (var i = 0; i < roots.length; i++) {
                      if (roots[i].getAttribute('data-recluster-object-context') !== String(objectName)) continue;
                      if (expectedRevision === null || roots[i].getAttribute('data-recluster-object-context-revision') === expectedRevision) return true;
                    }
                    return false;
                  }
                  if (window.Shiny && window.Shiny.addCustomMessageHandler && !window.__reclusterNewToggleClassBound) {
                    window.__reclusterNewToggleClassBound = true;
                    window.Shiny.addCustomMessageHandler('recluster-new-toggle-class', function (msg) {
                      if (!msg || !msg.id || !msg.className) return;
                      if (!reclusterNewObjectContextMatches(msg.object, msg.context_revision)) return;
                      var node = document.getElementById(msg.id);
                      if (!node) return;
                      node.classList.toggle(msg.className, !!msg.enabled);
                    });
                  }
                  if (!window.__reclusterNewHoverLevel) {
                    window.__reclusterNewHoverLevel = (function () {
                      window.__reclusterNewHoverLastKey = '';
                      window.__reclusterNewHoverObject = '';
                      window.__reclusterNewHoverRevision = null;
                      return function (col, level, objectName, contextRevision) {
                        var key = String(objectName || '') + '\\u001f' + String(contextRevision == null ? '' : contextRevision) + '\\u001f' + String(col || '') + '\\u001f' + String(level || '');
                        if (!col || !level || !objectName || key === window.__reclusterNewHoverLastKey) return;
                        window.__reclusterNewHoverLastKey = key;
                        window.__reclusterNewHoverObject = objectName;
                        window.__reclusterNewHoverRevision = contextRevision;
                        if (window.Shiny && window.Shiny.setInputValue) {
                          window.Shiny.setInputValue('recluster_new_meta_level_highlight', {
                            col: col,
                            level: level,
                            object: objectName,
                            context_revision: contextRevision,
                            nonce: Date.now()
                          }, {priority: 'event'});
                        }
                      };
                    })();
                  }
                  if (!window.__reclusterNewClearHoverLevel) {
                    window.__reclusterNewClearHoverLevel = function () {
                      window.__reclusterNewHoverLastKey = '';
                      if (window.Shiny && window.Shiny.setInputValue) {
                        window.Shiny.setInputValue('recluster_new_meta_level_highlight_clear', {
                          object: window.__reclusterNewHoverObject || '',
                          context_revision: window.__reclusterNewHoverRevision,
                          nonce: Date.now()
                        }, {priority: 'event'});
                      }
                      window.__reclusterNewHoverObject = '';
                      window.__reclusterNewHoverRevision = null;
                    };
                  }
                  if (!window.__reclusterNewExprSelectionBound) {
                    window.__reclusterNewExprSelectionBound = true;
                    function shinySet(id, value) {
                      if (!id || !window.Shiny || !window.Shiny.setInputValue) return;
                      window.Shiny.setInputValue(id, value, {priority: 'event'});
                    }
                    function currentReclusterObjectContext() {
                      var context = reclusterNewCurrentObjectContext();
                      var contextKey = String(context.object || '') + '\\u001f' + String(context.context_revision == null ? '' : context.context_revision);
                      if (window.__reclusterNewExpressionContextKey !== contextKey) {
                        window.__reclusterNewExpressionExpectedOpen = {};
                        window.__reclusterNewExpressionContextKey = contextKey;
                      }
                      return context;
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
                      var context = currentReclusterObjectContext();
                      shinySet('recluster_new_expr_active_range_commit', {
                        range: vals,
                        object: context.object,
                        context_revision: context.context_revision,
                        nonce: Date.now()
                      });
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
                        var cancelContext = currentReclusterObjectContext();
                        shinySet('recluster_new_expr_group_name_cancel', {
                          object: cancelContext.object,
                          context_revision: cancelContext.context_revision,
                          nonce: Date.now()
                        });
                        return;
                      }
                      var renameSaveBtn = ev.target && ev.target.closest && ev.target.closest('#recluster_new_expr_group_name_save');
                      if (renameSaveBtn) {
                        ev.preventDefault();
                        ev.stopPropagation();
                        var renameNameInput = document.getElementById('recluster_new_expr_group_name_edit');
                        var saveContext = currentReclusterObjectContext();
                        shinySet('recluster_new_expr_group_name_save', {
                          name: renameNameInput ? renameNameInput.value : '',
                          object: saveContext.object,
                          context_revision: saveContext.context_revision,
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
                      var geneDeleteBtn = ev.target && ev.target.closest && ev.target.closest('button[id^=\"recluster_new_expr_gene_delete__\"]');
                      if (geneDeleteBtn) {
                        ev.preventDefault();
                        ev.stopPropagation();
                        // Agent note: Gene rows are rendered inside a dynamic
                        // output. Use one stable input for every delete click;
                        // never depend on a per-gene Shiny observer surviving
                        // a UI replacement.
                        var deleteContext = currentReclusterObjectContext();
                        shinySet('recluster_new_expr_gene_delete_event', {
                          group_id: geneDeleteBtn.getAttribute('data-expr-delete-group-id') || '',
                          gene_id: geneDeleteBtn.getAttribute('data-expr-delete-gene-id') || '',
                          object: deleteContext.object,
                          context_revision: deleteContext.context_revision,
                          nonce: Date.now()
                        });
                        return;
                      }
                      var renameBtn = ev.target && ev.target.closest && ev.target.closest('.recluster-new-expr-group-rename');
                      if (renameBtn) {
                        ev.preventDefault();
                        ev.stopPropagation();
                        shinySet('recluster_new_expr_group_rename', {
                          group_id: renameBtn.getAttribute('data-expr-rename-group-id') || '',
                          object: currentReclusterObjectContext().object,
                          context_revision: currentReclusterObjectContext().context_revision,
                          nonce: Date.now()
                        });
                        return;
                      }
                      var row = ev.target && ev.target.closest && ev.target.closest('.recluster-new-expr-gene-row[data-expr-active-id]');
                      if (!row) return;
                      if (ev.target.closest('button, input, label, .checkbox, .selectize-control, .selectize-dropdown')) return;
                      shinySet(row.getAttribute('data-expr-active-id'), Date.now());
                    }, true);
                    window.__reclusterNewExpressionExpectedOpen = window.__reclusterNewExpressionExpectedOpen || {};
                    // Agent note: Native details toggle events are trusted even
                    // when Chrome restores or rebuilds a dynamic details node.
                    // Keep canonical open state owned by physical summary
                    // gestures only; a server-rendered details node must never
                    // publish its restored `open` attribute back to Shiny.
                    var physicalDetailsToggle = window.__reclusterNewPhysicalDetailsToggle || {
                      node: null,
                      beforeOpen: null
                    };
                    window.__reclusterNewPhysicalDetailsToggle = physicalDetailsToggle;
                    function detailsFromPhysicalTarget(target) {
                      if (!target || !target.closest) return null;
                      var summary = target.closest('summary');
                      var details = summary && summary.parentElement;
                      if (!details || details.tagName !== 'DETAILS') return null;
                      if (!details.matches('.recluster-new-expr-group[data-expr-group-id], .recluster-new-metadata-col[data-metadata-open-column], .recluster-new-metadata-bucket[data-metadata-open-bucket], .recluster-new-fold[data-basic-open-id]')) return null;
                      return details;
                    }
                    function markPhysicalDetailsToggle(ev) {
                      if (!ev.isTrusted) return;
                      var details = detailsFromPhysicalTarget(ev.target);
                      if (!details) return;
                      if (ev.type === 'mousedown' && ev.button !== 0) return;
                      if (ev.type === 'keydown' && ev.key !== 'Enter' && ev.key !== ' ' && ev.key !== 'Spacebar') return;
                      physicalDetailsToggle.node = details;
                      physicalDetailsToggle.beforeOpen = !!details.open;
                    }
                    document.addEventListener('mousedown', markPhysicalDetailsToggle, true);
                    document.addEventListener('keydown', markPhysicalDetailsToggle, true);
                    document.addEventListener('touchstart', markPhysicalDetailsToggle, true);
                    function consumePhysicalDetailsToggle(details) {
                      var wasPhysical = physicalDetailsToggle.node === details &&
                        physicalDetailsToggle.beforeOpen !== !!details.open;
                      if (physicalDetailsToggle.node === details) {
                        physicalDetailsToggle.node = null;
                        physicalDetailsToggle.beforeOpen = null;
                      }
                      return wasPhysical;
                    }
                    function recordDetailsToggleDiagnostic(kind, accepted, reason) {
                      if (!window.__WANLAB_DB_DIAG_MODE) return;
                      var diag = window.__reclusterNewDetailsToggleDiag || {
                        total: 0,
                        accepted: 0,
                        ignored: 0,
                        last: null
                      };
                      diag.total += 1;
                      diag[accepted ? 'accepted' : 'ignored'] += 1;
                      diag.last = {
                        kind: kind,
                        accepted: !!accepted,
                        reason: reason || ''
                      };
                      window.__reclusterNewDetailsToggleDiag = diag;
                    }
                    document.addEventListener('toggle', function (ev) {
                      var details = ev.target;
                      if (!details || !details.matches) return;
                      if (details.matches('.recluster-new-expr-group[data-expr-group-id]')) {
                        var exprGroupId = details.getAttribute('data-expr-group-id') || '';
                        var expectedOpen = window.__reclusterNewExpressionExpectedOpen[exprGroupId];
                        var exprToggleIsPhysical = consumePhysicalDetailsToggle(details);
                        if (expectedOpen !== undefined && expectedOpen === !!details.open && !exprToggleIsPhysical) {
                          delete window.__reclusterNewExpressionExpectedOpen[exprGroupId];
                          recordDetailsToggleDiagnostic('expression', false, 'expected_server_state');
                          return;
                        }
                        if (!ev.isTrusted || !exprToggleIsPhysical || !exprGroupId) {
                          recordDetailsToggleDiagnostic('expression', false, 'not_physical');
                          return;
                        }
                        recordDetailsToggleDiagnostic('expression', true, 'physical_summary');
                        shinySet('recluster_new_expr_open_group', {
                          group_id: exprGroupId,
                          open: !!details.open,
                          object: currentReclusterObjectContext().object,
                          context_revision: currentReclusterObjectContext().context_revision,
                          nonce: Date.now()
                        });
                        return;
                      }
                      if (details.matches('.recluster-new-metadata-col[data-metadata-open-column]')) {
                        var colToggleIsPhysical = consumePhysicalDetailsToggle(details);
                        if (!ev.isTrusted || !colToggleIsPhysical || !details.open) {
                          recordDetailsToggleDiagnostic('metadata_col', false, 'not_physical_or_closed');
                          return;
                        }
                        recordDetailsToggleDiagnostic('metadata_col', true, 'physical_summary');
                        var colContext = currentReclusterObjectContext();
                        shinySet('recluster_new_open_col', {
                          value: details.getAttribute('data-metadata-open-column') || '',
                          object: colContext.object,
                          context_revision: colContext.context_revision,
                          nonce: Date.now()
                        });
                        return;
                      }
                      if (details.matches('.recluster-new-metadata-bucket[data-metadata-open-bucket]')) {
                        var bucketToggleIsPhysical = consumePhysicalDetailsToggle(details);
                        if (!ev.isTrusted || !bucketToggleIsPhysical || !details.open) {
                          recordDetailsToggleDiagnostic('metadata_bucket', false, 'not_physical_or_closed');
                          return;
                        }
                        recordDetailsToggleDiagnostic('metadata_bucket', true, 'physical_summary');
                        var bucketContext = currentReclusterObjectContext();
                        shinySet('recluster_new_open_bucket', {
                          value: details.getAttribute('data-metadata-open-bucket') || '',
                          object: bucketContext.object,
                          context_revision: bucketContext.context_revision,
                          nonce: Date.now()
                        });
                        return;
                      }
                      if (details.matches('.recluster-new-fold[data-basic-open-id]')) {
                        var foldToggleIsPhysical = consumePhysicalDetailsToggle(details);
                        if (!ev.isTrusted || !foldToggleIsPhysical) {
                          recordDetailsToggleDiagnostic('basic_fold', false, 'not_physical');
                          return;
                        }
                        recordDetailsToggleDiagnostic('basic_fold', true, 'physical_summary');
                        shinySet(details.getAttribute('data-basic-open-id'), !!details.open);
                      }
                    }, true);
                    document.addEventListener('change', function (ev) {
                      if (!ev.target || ev.target.id !== 'recluster_new_expr_active_range') return;
                      commitExprRange();
                    }, true);
                  }
                  if (!window.__reclusterNewContextualModalButtonsBound) {
                    window.__reclusterNewContextualModalButtonsBound = true;
                    document.addEventListener('click', function (ev) {
                      var button = ev.target && ev.target.closest && ev.target.closest('.recluster-new-contextual-modal-action');
                      if (!button || !button.id || !window.Shiny || !window.Shiny.setInputValue) return;
                      ev.preventDefault();
                      ev.stopImmediatePropagation();
                      var revision = button.getAttribute('data-recluster-modal-revision');
                      window.Shiny.setInputValue(button.id, {
                        object: button.getAttribute('data-recluster-modal-object') || '',
                        context_revision: revision === null || revision === '' ? null : Number(revision),
                        nonce: Date.now()
                      }, {priority: 'event'});
                    }, true);
                  }
                  if (!window.__reclusterNewExpressionStateSyncBound) {
                    window.__reclusterNewExpressionStateSyncBound = true;
                    function exprStateSetChecked(id, value) {
                      var node = id && document.getElementById(id);
                      if (node && node.type === 'checkbox') node.checked = !!value;
                    }
                    function applyExpressionState(payload) {
                      currentReclusterObjectContext();
                      if (!payload || !payload.groups || !reclusterNewObjectContextMatches(payload.object, payload.context_revision)) return;
                      var details = document.querySelectorAll('[data-expr-group-id]');
                      Array.prototype.forEach.call(details, function (node) {
                        var gid = node.getAttribute('data-expr-group-id') || '';
                        var group = payload.groups[gid];
                        if (!group) return;
                        var nextOpen = !!group.open;
                        if (node.open !== nextOpen) {
                          window.__reclusterNewExpressionExpectedOpen[gid] = nextOpen;
                          node.open = nextOpen;
                        }
                        node.classList.toggle('is-violet-highlight-source', gid === (payload.active_group_id || ''));
                        exprStateSetChecked(group.require_all_id, group.require_all);
                        exprStateSetChecked(group.invert_id, group.invert);
                        exprStateSetChecked(group.select_all_id, group.select_all);
                        (group.genes || []).forEach(function (gene) {
                          exprStateSetChecked(gene.check_id, gene.checked);
                        });
                      });
                      var activeRange = payload.active_range || [];
                      if (activeRange.length === 2 && window.jQuery) {
                        var rangeNode = document.getElementById('recluster_new_expr_active_range');
                        var slider = rangeNode ? window.jQuery(rangeNode).data('ionRangeSlider') : null;
                        if (slider && slider.update) {
                          slider.update({
                            from: Number(activeRange[0]),
                            to: Number(activeRange[1])
                          });
                        }
                      }
                      var rows = document.querySelectorAll('.recluster-new-expr-gene-row');
                      Array.prototype.forEach.call(rows, function (row) {
                        row.classList.remove('is-active');
                      });
                      Object.keys(payload.groups).forEach(function (gid) {
                        var group = payload.groups[gid];
                        (group.genes || []).forEach(function (gene) {
                          if (!gene.active_id || !gene.active) return;
                          Array.prototype.forEach.call(rows, function (row) {
                            if (row.getAttribute('data-expr-active-id') === gene.active_id) {
                              row.classList.add('is-active');
                            }
                          });
                        });
                      });
                    }
                    function applyExpressionSummaries(payload) {
                      if (!payload || !reclusterNewObjectContextMatches(payload.object, payload.context_revision)) return;
                      var summaries = payload.summaries || {};
                      var nodes = document.querySelectorAll('[data-expr-summary-id]');
                      Array.prototype.forEach.call(nodes, function (node) {
                        var gid = node.getAttribute('data-expr-summary-id') || '';
                        if (summaries[gid] !== undefined) node.textContent = summaries[gid];
                      });
                    }
                    function applyExpressionGeneDetails(payload) {
                      if (!payload || !reclusterNewObjectContextMatches(payload.object, payload.context_revision)) return;
                      var details = payload.details || {};
                      Object.keys(details).forEach(function (detailId) {
                        var detail = details[detailId] || {};
                        var countNode = null;
                        var rangeNode = null;
                        Array.prototype.forEach.call(document.querySelectorAll('[data-expr-gene-count-id]'), function (node) {
                          if (node.getAttribute('data-expr-gene-count-id') === detailId) countNode = node;
                        });
                        Array.prototype.forEach.call(document.querySelectorAll('[data-expr-gene-note-id]'), function (node) {
                          if (node.getAttribute('data-expr-gene-note-id') === detailId) rangeNode = node;
                        });
                        if (countNode && detail.count_text !== undefined) countNode.textContent = detail.count_text;
                        if (rangeNode && detail.range_text !== undefined) rangeNode.textContent = detail.range_text;
                      });
                    }
                    function applyMetadataColors(payload) {
                      if (!payload || !payload.column || !payload.colors || !reclusterNewObjectContextMatches(payload.object, payload.context_revision)) return;
                      var nodes = document.querySelectorAll('[data-metadata-color-column]');
                      Array.prototype.forEach.call(nodes, function (node) {
                        if (node.getAttribute('data-metadata-color-column') !== String(payload.column)) return;
                        var level = node.getAttribute('data-metadata-color-level') || '';
                        var color = payload.colors[level];
                        if (!color) return;
                        node.style.backgroundColor = color;
                        node.title = 'Change ' + level + ' color (' + color + ')';
                        node.setAttribute('aria-label', level + ': ' + color);
                      });
                    }
                    function bindExpressionStateHandlers() {
                      if (!window.Shiny || !window.Shiny.addCustomMessageHandler) return false;
                      window.Shiny.addCustomMessageHandler('recluster-new-expression-state', applyExpressionState);
                      window.Shiny.addCustomMessageHandler('recluster-new-expression-summaries', applyExpressionSummaries);
                      window.Shiny.addCustomMessageHandler('recluster-new-expression-gene-details', applyExpressionGeneDetails);
                      window.Shiny.addCustomMessageHandler('recluster-new-metadata-colors', applyMetadataColors);
                      return true;
                    }
                    if (!bindExpressionStateHandlers()) {
                      document.addEventListener('shiny:connected', bindExpressionStateHandlers, { once: true });
                    }
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
  required_data_browser_helpers <- c(
    "db_scalar_chr", "db_norm_plot_tab", "db_norm_expr_tab",
    "db_norm_rule_plot_tab", "db_norm_key", "db_strip_suffix",
    "db_embedding_reduction_choices", "db_reduction_shape_signature",
    "db_preferred_embedding_reduction", "db_safe_assay_choices",
    "db_preferred_assay_choice", "db_cell_set_signature",
    "db_axis_index_choices", "db_barcode_keys", "db_pick_barcode_col",
    "db_read_barcodes_from_path", "db_match_barcodes_to_cells",
    "db_is_supported_meta_column", "db_is_numeric_rule_column",
    "db_likely_positive_values", "db_rule_color_presets",
    "db_classify_rule_column", "db_combine_rule_ab_overlap",
    "db_is_reasonable_discrete", "db_sort_numeric_first",
    "db_is_cluster_like_name", "db_is_continuous_metric_name",
    "db_build_metadata_profile", "db_safe_key",
    "db_unique_metadata_col_name"
  )
  missing_data_browser_helpers <- required_data_browser_helpers[
    !vapply(required_data_browser_helpers, exists, logical(1), mode = "function")
  ]
  if (length(missing_data_browser_helpers)) {
    stop(
      "Data Browser helper source is incomplete: ",
      paste(missing_data_browser_helpers, collapse = ", ")
    )
  }

  # Agent note: Local aliases preserve existing server call sites while pure,
  # version-neutral logic remains testable outside Shiny.
  .scalar_chr <- db_scalar_chr
  .norm_plot_tab <- db_norm_plot_tab
  .norm_expr_tab <- db_norm_expr_tab
  .norm_rule_plot_tab <- db_norm_rule_plot_tab
  .norm_key <- db_norm_key
  .strip_suffix <- db_strip_suffix
  .embedding_reduction_choices <- db_embedding_reduction_choices
  .reduction_shape_signature <- db_reduction_shape_signature
  .preferred_embedding_reduction <- db_preferred_embedding_reduction
  .safe_assay_choices <- db_safe_assay_choices
  .preferred_assay_choice <- db_preferred_assay_choice
  .cell_set_signature <- db_cell_set_signature
  .axis_index_choices <- db_axis_index_choices
  .barcode_keys <- db_barcode_keys
  .pick_barcode_col <- db_pick_barcode_col
  .read_barcodes_from_path <- db_read_barcodes_from_path
  .match_barcodes_to_cells <- db_match_barcodes_to_cells
  .is_supported_meta_column <- db_is_supported_meta_column
  .is_numeric_rule_column <- db_is_numeric_rule_column
  .likely_positive_values <- db_likely_positive_values
  .rule_color_presets <- db_rule_color_presets
  .classify_rule_column <- db_classify_rule_column
  .combine_rule_ab_overlap <- db_combine_rule_ab_overlap
  .is_reasonable_discrete <- db_is_reasonable_discrete
  .sort_numeric_first <- db_sort_numeric_first
  .is_cluster_like_name <- db_is_cluster_like_name
  .is_continuous_metric_name <- db_is_continuous_metric_name
  .build_metadata_profile <- db_build_metadata_profile
  .safe_key <- db_safe_key
  .unique_metadata_col_name <- db_unique_metadata_col_name

  .db_tab_is_active <- function() {
    nav_now <- tolower(trimws(.scalar_chr(input$main_navbar, "")))
    return(identical(nav_now, "recluster_new_tab"))
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
    umap_color_choices_sig = "",
    expr_ui_structure_key = "",
    expr_ui_staged_state = NULL,
    # Incremented only when an object transition has settled. Dynamic
    # expression UI must have a post-settlement render even when its output
    # was suspended while the Analysis tab was hidden.
    expr_ui_render_revision = 0L,
    expr_active_range_structure_key = "",
    expr_active_range_data_revision = 0L,
    # Set only by exact post-load flush confirming object, revision, and data slot.
    confirmed_plot_context_key = "",
    rule_definitions = list(),
    rule_active_cells = character(0),
    rule_overlap_group = NULL,
    rule_selected_group = "All",
    rule_manual_combine_mode = "union",
    debug_rule_overlap_state = "",
    metadata_open_column = "",
    metadata_open_bucket = "cluster",
    metadata_selector_structure_key = "",
    metadata_filter_definition_signature = "",
    metadata_filter_data_revision = 0L,
    cell_groups_structure_key = "",
    debug_meta_switch_count = 0L,
    rule_meta_choices_sig = "",
    tcr_choices_sig = "",
    viz_controls_structure_key = "",
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
  # Global overlay ownership is transient session state. The server releases
  # it when the requested plot object is ready or has failed explicitly; do
  # not make page interaction depend on a client DOM polling timeout.
  recluster_new_overlay_request_id <- reactiveVal(0L)
  recluster_new_overlay_state <- reactiveVal(list(
    pending = FALSE,
    request_id = 0L,
    object = "",
    revision = 0L,
    tab = "",
    status = "idle"
  ))
  recluster_new_pending_population_cells <- reactiveVal(character(0))
  recluster_new_pending_population_object <- reactiveVal("")
  recluster_new_pending_population_revision <- reactiveVal(NA_integer_)
  recluster_new_import_match_object <- reactiveVal("")
  recluster_new_import_match_revision <- reactiveVal(NA_integer_)
  lasso_selected_cells_state <- reactiveVal(character(0))
  rule_lasso_cells_state <- reactiveVal(character(0))
  # Selection sources are independent state. This owner records which source
  # most recently received explicit user intent; derived plots must never use
  # it to write back into either source.
  selection_owner_state <- reactiveVal("none")
  metadata_palette_picker <- curve_color_picker_server(
    "recluster_new_metadata_palette_picker",
    reset_trigger = reactive(input$recluster_new_metadata_palette_reset)
  )
  metadata_single_color_picker <- motion_color_picker_server(
    "recluster_new_metadata_single_color_picker",
    reset_trigger = reactive(input$recluster_new_metadata_single_color_reset)
  )

  .visual_settings_normalize <- function(settings) {
    if (!is.list(settings)) settings <- list()
    out <- list()
    text_fields <- c(
      "umap_color_choice",
      "umap_display_mode",
      "umap_assay_choice",
      "umap_reduction_choice",
      "rule_assay_choice",
      "rule_reduction_choice"
    )
    for (field in text_fields) {
      value <- trimws(.scalar_chr(settings[[field]], default = ""))
      if (nzchar(value)) out[[field]] <- value
    }
    gene_values <- as.character(settings$umap_gene_values %||% c("", "", ""))
    length(gene_values) <- 3L
    gene_values[is.na(gene_values)] <- ""
    out$umap_gene_values <- trimws(gene_values)
    dot_size <- suppressWarnings(as.numeric(settings$dot_size %||% NA_real_))
    if (length(dot_size) == 1L && is.finite(dot_size) && dot_size > 0) {
      out$dot_size <- dot_size
    }
    stroke_width <- suppressWarnings(as.numeric(settings$stroke_width %||% NA_real_))
    if (length(stroke_width) == 1L && is.finite(stroke_width)) {
      out$stroke_width <- max(0, min(1, stroke_width))
    }
    out
  }

  .visual_settings_store_get <- function(sobj) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(list())
    misc <- tryCatch(sobj@misc, error = function(e) list())
    ana <- tryCatch(misc$analysis, error = function(e) NULL)
    dbn <- if (is.list(ana)) tryCatch(ana$data_browser_new, error = function(e) NULL) else NULL
    stored <- if (is.list(dbn)) dbn$visual_settings else NULL
    .visual_settings_normalize(stored)
  }

  .visual_settings_store_set <- function(sobj, settings) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(sobj)
    misc <- tryCatch(sobj@misc, error = function(e) list())
    if (!is.list(misc$analysis)) misc$analysis <- list()
    if (!is.list(misc$analysis$data_browser_new)) misc$analysis$data_browser_new <- list()
    misc$analysis$data_browser_new$visual_settings <- .visual_settings_normalize(settings)
    sobj@misc <- misc
    sobj
  }

  .current_visual_settings <- function() {
    .visual_settings_store_get(isolate(recluster_new_data$seurat_obj))
  }

  .remember_visual_settings <- function(dot_size = NULL, stroke_width = NULL, ...) {
    values <- list(...)
    obj <- isolate(recluster_new_data$seurat_obj)
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))
    settings <- .visual_settings_store_get(obj)
    if (!is.null(dot_size)) settings$dot_size <- dot_size
    if (!is.null(stroke_width)) settings$stroke_width <- stroke_width
    if (length(values)) {
      if (is.null(names(values)) || any(!nzchar(names(values)))) {
        stop("Data Browser visual settings require named values.", call. = FALSE)
      }
      settings[names(values)] <- values
    }
    next_settings <- .visual_settings_normalize(settings)
    if (identical(.visual_settings_normalize(.visual_settings_store_get(obj)), next_settings)) {
      return(invisible(NULL))
    }
    obj <- .visual_settings_store_set(obj, next_settings)
    .persist_active_object(obj, update_local = TRUE)
    invisible(NULL)
  }

  # Agent note: Gene changes rebuild UMAP controls. Keep these values outside
  # input bindings and key them by object so rebuilding or switching objects
  # cannot reset user-selected dot size or highlight stroke setting.
  observeEvent(input$recluster_new_dot_size, {
    if (!.recluster_new_event_allowed("dot_size")) return(invisible(NULL))
    value <- suppressWarnings(as.numeric(input$recluster_new_dot_size))
    if (length(value) == 1L && is.finite(value) && value > 0) {
      .remember_visual_settings(dot_size = value)
    }
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_stroke_width, {
    if (!.recluster_new_event_allowed("stroke_width")) return(invisible(NULL))
    value <- suppressWarnings(as.numeric(input$recluster_new_stroke_width))
    if (length(value) == 1L && is.finite(value)) {
      .remember_visual_settings(stroke_width = max(0, min(1, value)))
    }
  }, ignoreInit = TRUE)

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
  # Agent note: Keep dynamic expression inputs bound once per stable ID. Do not
  # destroy/recreate observers on each UI-state redraw; that loses gene delete
  # clicks while Shiny replaces or synchronizes expression rows.
  .expr_bound_inputs <- reactiveVal(character(0))
  .gene_value_cache <- new.env(parent = emptyenv())
  .gene_value_cache_order <- character(0)
  .gene_value_cache_max <- 24L
  .clear_gene_value_cache <- function() {
    rm(list = ls(.gene_value_cache, all.names = TRUE), envir = .gene_value_cache)
    .gene_value_cache_order <<- character(0)
    invisible(NULL)
  }
  .db_diag_enabled <- isTRUE(get0(
    "WANLAB_DB_DIAG_MODE",
    ifnotfound = identical(Sys.getenv("WANLAB_DB_DIAG_MODE", "0"), "1")
  ))
  .db_dbg <- function(tag, ...) {
    if (!isTRUE(.db_diag_enabled)) return(invisible(NULL))
    ts <- format(Sys.time(), "%H:%M:%OS3")
    payload <- paste(..., collapse = " ")
    message(sprintf("[DB_UMAP_DBG][%s][%s] %s", ts, tag, payload))
  }
  # Keep active-object gene catalogs in Selectize's server-side store. Sending
  # the full catalog through updateSelectInput serializes thousands of option
  # nodes on every hydration and can freeze the browser during object/tab
  # transitions. Server-side Selectize keeps catalog ownership in R while the
  # client receives only query results.
  .db_update_gene_selectize <- function(input_id, genes, selected = character(0)) {
    wl_update_gene_selectize(
      session,
      input_id,
      genes,
      selected = selected,
      server = TRUE
    )
  }
  # Gene selectors own gene values only. Selectize hydration is a view update,
  # not a command to change UMAP coloring or the lower plot tab.
  observeEvent(input$recluster_new_gene_expr_select_1, {
    if (!.recluster_new_event_allowed("gene_expr_select_1")) return(invisible(NULL))
    next_gene <- .scalar_chr(input$recluster_new_gene_expr_select_1, default = "")
    .set_umap_gene_value(1L, next_gene)
    genes_now <- .umap_gene_selection()$genes
    .db_dbg("gene1", sprintf("input=%s genes=%s color_before=%s",
      as.character(input$recluster_new_gene_expr_select_1 %||% ""),
      paste(genes_now, collapse = ","),
      as.character(recluster_new_data$umap_color_choice %||% "")
    ))
    .db_dbg("gene1", sprintf("color_after=%s", as.character(recluster_new_data$umap_color_choice %||% "")))
  }, ignoreNULL = TRUE)
  observeEvent(input$recluster_new_gene_expr_select_2, {
    if (!.recluster_new_event_allowed("gene_expr_select_2")) return(invisible(NULL))
    next_gene <- .scalar_chr(input$recluster_new_gene_expr_select_2, default = "")
    .set_umap_gene_value(2L, next_gene)
    genes_now <- .umap_gene_selection()$genes
    .db_dbg("gene2", sprintf("input=%s genes=%s color_before=%s",
      as.character(input$recluster_new_gene_expr_select_2 %||% ""),
      paste(genes_now, collapse = ","),
      as.character(recluster_new_data$umap_color_choice %||% "")
    ))
    .db_dbg("gene2", sprintf("color_after=%s", as.character(recluster_new_data$umap_color_choice %||% "")))
  }, ignoreNULL = TRUE)
  observeEvent(input$recluster_new_gene_expr_select_3, {
    if (!.recluster_new_event_allowed("gene_expr_select_3")) return(invisible(NULL))
    next_gene <- .scalar_chr(input$recluster_new_gene_expr_select_3, default = "")
    .set_umap_gene_value(3L, next_gene)
    genes_now <- .umap_gene_selection()$genes
    .db_dbg("gene3", sprintf("input=%s genes=%s color_before=%s",
      as.character(input$recluster_new_gene_expr_select_3 %||% ""),
      paste(genes_now, collapse = ","),
      as.character(recluster_new_data$umap_color_choice %||% "")
    ))
    .db_dbg("gene3", sprintf("color_after=%s", as.character(recluster_new_data$umap_color_choice %||% "")))
  }, ignoreNULL = TRUE)
  observeEvent(input$recluster_new_color_by_select, {
    if (!.recluster_new_event_allowed("color_by")) return(invisible(NULL))
    next_choice <- .scalar_chr(input$recluster_new_color_by_select, default = "")
    if (!nzchar(next_choice)) return(invisible(NULL))
    current_choice <- .scalar_chr(recluster_new_data$umap_color_choice, default = "")
    if (identical(next_choice, current_choice)) return(invisible(NULL))
    genes_now <- .umap_gene_selection()$genes
    .db_dbg("color_input", sprintf("next=%s genes=%s active_col=%s stored_before=%s",
      next_choice,
      paste(genes_now, collapse = ","),
      as.character(.active_umap_metadata_col() %||% ""),
      as.character(recluster_new_data$umap_color_choice %||% "")
    ))
    recluster_new_data$umap_color_choice <- next_choice
    recluster_new_data$umap_display_mode <- if (identical(next_choice, "Single Gene Expression")) "gene" else "metadata"
    .remember_visual_settings(
      umap_color_choice = next_choice,
      umap_display_mode = recluster_new_data$umap_display_mode
    )
    if (!identical(.scalar_chr(input$recluster_new_umap_display_mode, default = ""), recluster_new_data$umap_display_mode)) {
      updateRadioButtons(session, "recluster_new_umap_display_mode", selected = recluster_new_data$umap_display_mode)
    }
    .db_dbg("color_input_applied", sprintf(
      "stored=%s display=%s resolved=%s",
      as.character(recluster_new_data$umap_color_choice %||% ""),
      as.character(recluster_new_data$umap_display_mode %||% ""),
      as.character(.active_umap_metadata_col() %||% "")
    ))
  }, ignoreInit = TRUE)
  observeEvent(input$recluster_new_umap_display_mode, {
    if (!.recluster_new_event_allowed("umap_display_mode")) return(invisible(NULL))
    mode_now <- .scalar_chr(input$recluster_new_umap_display_mode, default = "metadata")
    if (!(mode_now %in% c("metadata", "gene"))) mode_now <- "metadata"
    if (identical(mode_now, .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata"))) {
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

  .current_plot_tab <- reactive({ .active_plot_tab() })
  .current_expr_tab <- reactive({ .active_expr_tab() })
  .current_rule_plot_tab <- reactive({ .active_rule_plot_tab() })

  .plotly_register_selection_events <- function(p) {
    # Agent note: plotly_deselect is also emitted by ordinary redraw/rebind and
    # is not physical user intent. Register selection and explicit clear only.
    for (event_name in c("plotly_selected", "plotly_doubleclick")) {
      p <- plotly::event_register(p, event_name)
    }
    p
  }

  .plotly_interactive_tools <- function(p) {
    # Agent note: only expression-distribution histograms suppress Plotly tools.
    # UMAP and other interactive plots keep Plotly's full default modebar.
    plotly::config(
      p,
      displayModeBar = TRUE,
      modeBarButtonsToAdd = c("lasso2d", "select2d"),
      responsive = TRUE
    )
  }

  .plotly_touch_zoom <- function(p) {
    # Register events on every placeholder and rendered state for each source.
    # event_data() is installed before the first browser flush; an unregistered
    # placeholder otherwise emits warnings and leaves a noisy startup path.
    p <- .plotly_register_selection_events(p)
    .plotly_interactive_tools(p)
  }

  .plotly_selection_event_data <- function(event_name, source) {
    # Agent note: subscribe directly to Plotly. Navigation inputs are UI views
    # and must not gate physical selection events; revision-prefixed cell keys
    # below provide deterministic object-context validation.
    plotly::event_data(event_name, source = source)
  }

  .recluster_new_empty_plot <- function(source = "recluster_new_plot_source") {
    plot_ly(source = source) %>%
      add_trace(
        type = "scattergl",
        mode = "markers",
        x = numeric(0),
        y = numeric(0),
        hoverinfo = "skip",
        showlegend = FALSE
      ) %>%
      layout(
        xaxis = list(visible = FALSE),
        yaxis = list(visible = FALSE),
        margin = list(l = 0, r = 0, t = 0, b = 0)
      ) %>%
      .plotly_touch_zoom()
  }

  .recluster_new_error_plot <- function(message_text, source = "recluster_new_plot_source") {
    message_text <- as.character(message_text %||% character(0))
    if (!length(message_text) || is.na(message_text[[1L]]) || !nzchar(message_text[[1L]])) {
      message_text <- "Unknown Data Browser plot error."
    } else {
      message_text <- message_text[[1L]]
    }
    message_text <- paste0("Data Browser plot error: ", substr(message_text, 1L, 500L))
    plot_ly(source = source) %>%
      add_trace(
        type = "scattergl",
        mode = "markers",
        x = numeric(0),
        y = numeric(0),
        hoverinfo = "skip",
        showlegend = FALSE
      ) %>%
      layout(
        xaxis = list(visible = FALSE),
        yaxis = list(visible = FALSE),
        annotations = list(list(
          text = message_text,
          x = 0.5,
          y = 0.5,
          xref = "paper",
          yref = "paper",
          showarrow = FALSE,
          font = list(size = 14, color = "#b91c1c")
        )),
        margin = list(l = 20, r = 20, t = 30, b = 20)
      ) %>%
      .plotly_touch_zoom()
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
  .current_reduction_entry <- function() {
    nm <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (!nzchar(nm)) nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(nm)) return(NULL)
    tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
  }
  .saved_embedding_reduction <- function(obj, requested) {
    dims <- wanlab_get_active_embedding_dims(.current_reduction_entry())
    if (!length(dims)) return("")
    wanlab_resolve_embedding_reduction(obj, requested, preferred_dims = dims)
  }
  .current_umap_reduction <- function(obj) {
    reduction_choices <- .embedding_reduction_choices(obj)
    if (!length(reduction_choices)) return("")
    target <- .scalar_chr(recluster_new_data$umap_reduction_choice, default = "")
    target_lc <- tolower(target)
    target_family <- if (grepl("^tsne($|_)", target_lc)) "tsne" else if (grepl("^umap($|_)", target_lc)) "umap" else ""
    if (nzchar(target_family)) {
      preferred <- .saved_embedding_reduction(obj, target_family)
      if (nzchar(preferred)) return(preferred)
    }
    if (nzchar(target) && target %in% reduction_choices) return(target)
    input_val <- .scalar_chr(input$recluster_new_umap_reduction_select, default = "")
    input_lc <- tolower(input_val)
    input_family <- if (grepl("^tsne($|_)", input_lc)) "tsne" else if (grepl("^umap($|_)", input_lc)) "umap" else ""
    if (nzchar(input_family)) {
      preferred <- .saved_embedding_reduction(obj, input_family)
      if (nzchar(preferred)) return(preferred)
    }
    if (nzchar(input_val) && input_val %in% reduction_choices) return(input_val)
    .preferred_embedding_reduction(obj, entry = .current_reduction_entry())
  }
  .current_rule_reduction <- function(obj) {
    reduction_choices <- .embedding_reduction_choices(obj)
    if (!length(reduction_choices)) return("")
    target <- .scalar_chr(recluster_new_data$rule_reduction_choice, default = "")
    target_lc <- tolower(target)
    target_family <- if (grepl("^tsne($|_)", target_lc)) "tsne" else if (grepl("^umap($|_)", target_lc)) "umap" else ""
    if (nzchar(target_family)) {
      preferred <- .saved_embedding_reduction(obj, target_family)
      if (nzchar(preferred)) return(preferred)
    }
    if (nzchar(target) && target %in% reduction_choices) return(target)
    input_val <- .scalar_chr(input$recluster_new_rule_umap_reduction_select, default = "")
    input_lc <- tolower(input_val)
    input_family <- if (grepl("^tsne($|_)", input_lc)) "tsne" else if (grepl("^umap($|_)", input_lc)) "umap" else ""
    if (nzchar(input_family)) {
      preferred <- .saved_embedding_reduction(obj, input_family)
      if (nzchar(preferred)) return(preferred)
    }
    if (nzchar(input_val) && input_val %in% reduction_choices) return(input_val)
    .preferred_embedding_reduction(obj, entry = .current_reduction_entry())
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
        dims_val <- wanlab_get_active_embedding_dims(entry)
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

  .rule_color_map_from_inputs <- function() {
    as.list(c(
      A_only = toupper(.scalar_chr(input$recluster_new_rule_color_a_only, default = "#D55E00")),
      B_only = toupper(.scalar_chr(input$recluster_new_rule_color_b_only, default = "#0072B2")),
      A_B = toupper(.scalar_chr(input$recluster_new_rule_color_ab, default = "#009E73")),
      Neither = toupper(.scalar_chr(input$recluster_new_rule_color_neither, default = "#9CA3AF")),
      Missing = toupper(.scalar_chr(input$recluster_new_rule_color_missing, default = "#6B7280"))
    ))
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
  # Agent note: Dynamic metadata controls can unbind during UI remounts. Keep
  # last-known checkbox state outside Shiny input so an absent input cannot
  # silently turn an unchecked population back on.
  .metadata_level_checked_state <- new.env(parent = emptyenv())
  .metadata_level_state_key <- function(col_name, level_name) {
    paste(
      .recluster_new_canonical_object_name(),
      .recluster_new_context_revision(),
      .profile_key(col_name),
      .safe_key(level_name),
      sep = "\u001f"
    )
  }
  .metadata_level_checked <- function(col_name, level_name, isolate_input = FALSE) {
    input_id <- .cat_level_input_id(col_name, level_name)
    input_value <- if (isTRUE(isolate_input)) isolate(input[[input_id]]) else input[[input_id]]
    if (!is.null(input_value)) return(isTRUE(input_value))
    state_key <- .metadata_level_state_key(col_name, level_name)
    if (exists(state_key, envir = .metadata_level_checked_state, inherits = FALSE)) {
      return(isTRUE(get(state_key, envir = .metadata_level_checked_state, inherits = FALSE)))
    }
    TRUE
  }
  .metadata_level_rename_input_id <- function(col_name, level_name, level_index) {
    paste0("recluster_new_level_rename__", .profile_key(col_name), "__", sprintf("%03d", level_index), "__", .safe_key(level_name))
  }
  .grp_toggle_input_id <- function(group_name) paste0("recluster_new_group_enabled__", .safe_key(group_name))
  .grp_delete_input_id <- function(group_name) paste0("recluster_new_group_delete__", .safe_key(group_name))
  .cell_groups_structure_signature <- function(groups) {
    groups <- groups %||% list()
    if (!is.list(groups) || !length(groups)) return("")
    names_now <- names(groups) %||% character(0)
    vapply(seq_along(groups), function(i) {
      group <- groups[[i]] %||% list()
      group_name <- .scalar_chr(names_now[[i]] %||% group$name, default = sprintf("group_%03d", i))
      cells <- unique(as.character(group$cells %||% character(0)))
      cells <- sort(cells[!is.na(cells) & nzchar(cells)], method = "radix")
      metadata_col <- .scalar_chr(group$metadata_col, default = "")
      paste(group_name, metadata_col, paste(cells, collapse = "\u001f"), sep = "=")
    }, character(1)) |>
      paste(collapse = "\u001e")
  }
  .set_cell_groups_structure <- function(groups, object_name = NULL) {
    if (!is.list(groups)) groups <- list()
    recluster_new_data$cell_groups <- groups
    object_name <- .scalar_chr(
      object_name,
      default = .scalar_chr(recluster_new_loaded_object_name(), default = .scalar_chr(shared_data$active_object_name, default = ""))
    )
    next_key <- paste(object_name, .cell_groups_structure_signature(groups), sep = "::")
    if (!identical(.scalar_chr(recluster_new_data$cell_groups_structure_key, default = ""), next_key)) {
      recluster_new_data$cell_groups_structure_key <- next_key
    }
    invisible(groups)
  }
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
  .expr_gene_delete_event_id <- function() "recluster_new_expr_gene_delete_event"
  .expr_gene_detail_id <- function(group_id, gene_id) paste(.safe_key(group_id), .safe_key(gene_id), sep = "__")

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
      active_gene_raw <- .scalar_chr(g$active_gene_id, default = "")
      active_gene_id <- if (nzchar(active_gene_raw)) .safe_key(active_gene_raw) else ""
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

  .expr_structure_signature <- function(state) {
    state <- .expr_state_normalize(state)
    groups <- vapply(state$groups %||% list(), function(g) {
      genes <- vapply(g$genes %||% list(), function(gr) {
        paste(
          .scalar_chr(gr$id, default = ""),
          .scalar_chr(gr$gene, default = ""),
          sep = "="
        )
      }, character(1))
      paste(c(
        .scalar_chr(g$id, default = ""),
        .scalar_chr(g$name, default = ""),
        genes
      ), collapse = "|")
    }, character(1))
    paste(groups, collapse = "||")
  }

  .expr_ui_structure_key <- function(state, object_name = "", assay_name = "") {
    paste(
      .scalar_chr(object_name, default = ""),
      .scalar_chr(assay_name, default = ""),
      .expr_structure_signature(state),
      sep = "::"
    )
  }

  .expr_active_range_structure_key <- function(state, object_name = "", assay_name = "") {
    active <- .expr_active_gene(state)
    paste(
      .scalar_chr(object_name, default = ""),
      .scalar_chr(assay_name, default = ""),
      if (is.null(active)) "" else .scalar_chr(active$group_id, default = ""),
      if (is.null(active)) "" else .scalar_chr(active$gene_id, default = ""),
      if (is.null(active)) "" else .scalar_chr(active$gene, default = ""),
      sep = "::"
    )
  }

  .expr_store_get <- function(sobj) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(.expr_default_state())
    misc <- tryCatch(sobj@misc, error = function(e) list())
    ana <- tryCatch(misc$analysis, error = function(e) NULL)
    dbn <- if (is.list(ana)) tryCatch(ana$data_browser_new, error = function(e) NULL) else NULL
    .expr_without_active_gene_focus(
      .expr_state_normalize(if (is.list(dbn)) dbn$expression_selection else NULL)
    )
  }

  .expr_without_active_gene_focus <- function(state) {
    state <- .expr_state_normalize(state)
    state$groups <- lapply(state$groups %||% list(), function(group) {
      group$active_gene_id <- ""
      group
    })
    state
  }

  .expr_store_set <- function(sobj, state) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(sobj)
    misc <- tryCatch(sobj@misc, error = function(e) list())
    if (!is.list(misc$analysis)) misc$analysis <- list()
    if (!is.list(misc$analysis$data_browser_new)) misc$analysis$data_browser_new <- list()
    # Active gene is transient UI focus, not object-owned scientific/session
    # state. Persist groups, checks, and thresholds; require a physical gene-row
    # click before orange focus and the range distribution appear each visit.
    misc$analysis$data_browser_new$expression_selection <- .expr_without_active_gene_focus(state)
    sobj@misc <- misc
    sobj
  }

  .saved_group_state_normalize <- function(groups, obj = NULL) {
    if (!is.list(groups) || !length(groups)) return(list())
    object_cells <- if (!is.null(obj) && inherits(obj, "Seurat")) colnames(obj) else character(0)
    names_now <- names(groups) %||% character(0)
    out <- list()
    for (i in seq_along(groups)) {
      group <- groups[[i]]
      if (!is.list(group)) next
      group_name <- .scalar_chr(names_now[[i]] %||% group$name, default = sprintf("Saved group %d", i))
      if (!nzchar(group_name)) next
      cells <- unique(as.character(group$cells %||% character(0)))
      cells <- cells[!is.na(cells) & nzchar(cells)]
      if (length(object_cells)) cells <- intersect(cells, object_cells)
      metadata_col <- .scalar_chr(group$metadata_col, default = "")
      out_name <- group_name
      if (out_name %in% names(out)) out_name <- make.unique(c(names(out), out_name))[length(names(out)) + 1L]
      out[[out_name]] <- list(
        cells = cells,
        enabled = isTRUE(group$enabled),
        metadata_col = metadata_col
      )
    }
    out
  }

  .saved_group_store_get <- function(sobj) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(list())
    misc <- tryCatch(sobj@misc, error = function(e) list())
    ana <- tryCatch(misc$analysis, error = function(e) NULL)
    dbn <- if (is.list(ana)) tryCatch(ana$data_browser_new, error = function(e) NULL) else NULL
    stored <- if (is.list(dbn)) dbn$saved_groups else NULL
    groups <- .saved_group_state_normalize(stored, obj = sobj)
    if (length(groups)) return(groups)

    # Reconstruct legacy saved-group metadata rows once when older objects do
    # not yet carry the object-owned UI state.
    md <- tryCatch(sobj@meta.data, error = function(e) NULL)
    if (is.null(md) || !is.data.frame(md)) return(groups)
    saved_cols <- colnames(md)[grepl("^saved_group_", colnames(md))]
    if (!length(saved_cols)) return(groups)
    for (col_name in saved_cols) {
      vals <- as.character(md[[col_name]])
      vals[is.na(vals) | !nzchar(vals)] <- ""
      labels <- unique(vals[nzchar(vals)])
      if (!length(labels)) next
      group_name <- labels[[1L]]
      if (group_name %in% names(groups)) group_name <- make.unique(c(names(groups), group_name))[length(names(groups)) + 1L]
      groups[[group_name]] <- list(
        cells = rownames(md)[vals == labels[[1L]]],
        enabled = FALSE,
        metadata_col = col_name
      )
    }
    .saved_group_state_normalize(groups, obj = sobj)
  }

  .saved_group_store_set <- function(sobj, groups) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(sobj)
    misc <- tryCatch(sobj@misc, error = function(e) list())
    if (!is.list(misc$analysis)) misc$analysis <- list()
    if (!is.list(misc$analysis$data_browser_new)) misc$analysis$data_browser_new <- list()
    misc$analysis$data_browser_new$saved_groups <- .saved_group_state_normalize(groups, obj = sobj)
    sobj@misc <- misc
    sobj
  }

  .metadata_color_store_get <- function(sobj) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(list())
    misc <- tryCatch(sobj@misc, error = function(e) list())
    stored <- tryCatch(misc$metadata_level_colors, error = function(e) NULL)
    if (!is.list(stored) || !length(stored)) return(list())
    stored_names <- names(stored)
    if (is.null(stored_names) || length(stored_names) != length(stored)) {
      stored_names <- as.character(seq_along(stored))
    }
    ord <- order(stored_names)
    stored <- stored[ord]
    stored_names <- stored_names[ord]
    normalized <- lapply(stored, function(color_map) {
      vals <- tryCatch(as.character(color_map), error = function(e) character(0))
      nms <- names(color_map) %||% character(0)
      if (length(vals) != length(nms)) return(character(0))
      keep <- !is.na(nms) & nzchar(nms) & !is.na(vals) & nzchar(vals)
      vals <- vals[keep]
      nms <- nms[keep]
      map_order <- order(nms)
      stats::setNames(vals[map_order], nms[map_order])
    })
    stats::setNames(normalized, stored_names)
  }

  # Object-owned state is one comparison unit during same-name workspace
  # replacement. Comparing this record prevents a replacement with identical
  # reduction dimensions from leaving old controls mounted in the session.
  .object_owned_state <- function(sobj) {
    list(
      expression_selection = .expr_store_get(sobj),
      saved_groups = .saved_group_store_get(sobj),
      visual_settings = .visual_settings_store_get(sobj),
      metadata_level_colors = .metadata_color_store_get(sobj)
    )
  }

  .expr_set_state <- function(state, persist = TRUE) {
    state <- .expr_state_normalize(state)
    old_state <- .expr_state_normalize(isolate(recluster_new_data$expr_selection))
    if (identical(old_state, state)) return(invisible(old_state))
    # Agent note: Expression buttons are direct user edits to object-owned
    # state. Do not discard them because plot settlement is still in progress;
    # plot readiness and state persistence are separate transactions.
    # Agent note: staged UI exists only for the add-gene post-flush handoff.
    # Any later edit, including delete, must render canonical object state;
    # leaving this snapshot mounted can resurrect a deleted gene.
    recluster_new_data$expr_ui_staged_state <- NULL
    old_structure_key <- .scalar_chr(recluster_new_data$expr_ui_structure_key, default = "")
    recluster_new_data$expr_selection <- state
    object_name <- .recluster_new_canonical_object_name()
    assay_name <- .scalar_chr(
      recluster_new_data$umap_assay_choice,
      default = .scalar_chr(input$recluster_new_assay_select, default = "")
    )
    next_structure_key <- .expr_ui_structure_key(state, object_name, assay_name)
    if (!identical(old_structure_key, next_structure_key)) {
      .db_dbg(
        "expr_ui_structure_change",
        sprintf("object=%s assay=%s old=%s new=%s", object_name, assay_name, substr(old_structure_key, 1L, 120L), substr(next_structure_key, 1L, 120L))
      )
      recluster_new_data$expr_ui_structure_key <- next_structure_key
    }
    recluster_new_data$expr_active_range_structure_key <- .expr_active_range_structure_key(
      state,
      object_name,
      assay_name
    )
    if (isTRUE(persist)) {
      obj <- recluster_new_data$seurat_obj
      if (!is.null(obj) && inherits(obj, "Seurat")) {
        obj <- .expr_store_set(obj, state)
        # Agent note: Keep local and registry object-owned state identical after
        # every expression edit. Leaving the local copy stale makes the shared
        # object reconciliation observer misclassify a normal checkbox/gene/
        # range edit as an external workspace replacement and reload the page.
        # The local visual controls preserve their canonical selections while
        # the object copy is updated, so this is a state sync, not a reload.
        .persist_active_object(obj, update_local = TRUE)
      }
    }
    .expr_send_state_to_ui(state)
    invisible(state)
  }

  .expr_ui_render_state <- function() {
    staged <- isolate(recluster_new_data$expr_ui_staged_state)
    if (is.list(staged)) staged else isolate(recluster_new_data$expr_selection)
  }

  .expr_stage_added_gene_ui <- function(state) {
    state <- .expr_state_normalize(state)
    object_name <- .recluster_new_canonical_object_name()
    assay_name <- .scalar_chr(
      recluster_new_data$umap_assay_choice,
      default = .scalar_chr(input$recluster_new_assay_select, default = "")
    )
    recluster_new_data$expr_ui_staged_state <- state
    recluster_new_data$expr_ui_structure_key <- .expr_ui_structure_key(state, object_name, assay_name)
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

  .expr_controls_payload <- function(state) {
    state <- .expr_state_normalize(state)
    owner_now <- .scalar_chr(selection_owner_state(), default = "none")
    active_gene <- .expr_active_gene(state)
    groups <- list()
    for (g in state$groups %||% list()) {
      gid <- .scalar_chr(g$id, default = "")
      if (!nzchar(gid)) next
      genes <- lapply(g$genes %||% list(), function(gr) {
        gene_id <- .scalar_chr(gr$id, default = "")
        list(
          check_id = .expr_gene_check_input_id(gid, gene_id),
          active_id = .expr_gene_active_input_id(gid, gene_id),
          checked = isTRUE(gr$checked),
          active = identical(.scalar_chr(g$active_gene_id, default = ""), gene_id)
        )
      })
      groups[[gid]] <- list(
        open = isTRUE(g$open),
        require_all_id = .expr_group_require_all_input_id(gid),
        require_all = isTRUE(g$require_all),
        invert_id = .expr_group_invert_input_id(gid),
        invert = isTRUE(g$invert),
        select_all_id = .expr_group_select_all_input_id(gid),
        select_all = length(g$genes %||% list()) > 0L && all(vapply(g$genes %||% list(), function(gr) isTRUE(gr$checked), logical(1))),
        genes = genes
      )
    }
    list(
      object = .recluster_new_canonical_object_name(),
      context_revision = .recluster_new_context_revision(),
      active_group_id = if (identical(owner_now, "expression")) {
        .scalar_chr(state$active_group_id, default = "")
      } else {
        ""
      },
      active_range = if (!is.null(active_gene)) {
        suppressWarnings(as.numeric(active_gene$range %||% numeric(0)))
      } else {
        numeric(0)
      },
      groups = groups
    )
  }

  .expr_send_state_to_ui <- function(state) {
    session$sendCustomMessage("recluster-new-expression-state", .expr_controls_payload(state))
    invisible(NULL)
  }

  .set_selection_owner <- function(next_owner, source = "") {
    next_owner <- .scalar_chr(next_owner, default = "none")
    if (!(next_owner %in% c("none", "expression", "manual"))) {
      stop(sprintf("Invalid Data Browser selection owner: %s", next_owner), call. = FALSE)
    }
    previous_owner <- .scalar_chr(selection_owner_state(), default = "none")
    if (!isTRUE(.recluster_new_context_is_settled())) {
      .db_dbg(
        "selection_owner_commit_ignored_unsettled_context",
        sprintf("from=%s requested=%s source=%s", previous_owner, next_owner, .scalar_chr(source, default = ""))
      )
      return(invisible(previous_owner))
    }
    if (identical(previous_owner, next_owner)) return(invisible(next_owner))
    selection_owner_state(next_owner)
    .db_dbg(
      "selection_owner_transition",
      sprintf("from=%s to=%s source=%s", previous_owner, next_owner, .scalar_chr(source, default = ""))
    )
    # Expression DOM is a view of canonical state. Push owner changes through
    # one custom-message path; never synthesize another Shiny input.
    .expr_send_state_to_ui(recluster_new_data$expr_selection)
    invisible(next_owner)
  }

  .restore_selection_owner_after_manual_clear <- function(source = "") {
    if (!identical(.scalar_chr(selection_owner_state(), default = "none"), "manual")) {
      return(invisible(NULL))
    }
    remaining_manual <- unique(c(
      as.character(lasso_selected_cells_state() %||% character(0)),
      as.character(recluster_new_data$selected_cells %||% character(0)),
      as.character(enabled_group_cells() %||% character(0))
    ))
    if (length(remaining_manual[nzchar(remaining_manual)])) return(invisible("manual"))
    expr_state <- .expr_state_normalize(recluster_new_data$expr_selection)
    next_owner <- if (nzchar(.scalar_chr(expr_state$active_group_id, default = ""))) "expression" else "none"
    .set_selection_owner(next_owner, source)
    invisible(next_owner)
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
      pal <- tryCatch(
        as.character(scales::hue_pal()(n)),
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
    # Agent note: Preserve carried object colors first. When no carried color
    # exists, use actual Seurat DimPlot default hues, not DiscretePalette().
    fallback <- tryCatch(
      figure_resolve_metadata_palette(
        sobj = sobj,
        reduction_name = .current_umap_reduction(sobj),
        color_col = col_name,
        label_values = object_levels,
        levels_vec = lv
      ),
      error = function(e) NULL
    )
    if (!is.character(fallback) || length(fallback) != length(lv)) {
      fallback <- scales::hue_pal()(length(lv))
    } else {
      fallback <- toupper(as.character(fallback))
      bad <- is.na(fallback) | !vapply(fallback, .is_hex_color, logical(1))
      if (any(bad)) fallback[bad] <- scales::hue_pal()(length(lv))[bad]
    }
    fallback <- stats::setNames(fallback, lv)
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

  .expr_assay_name <- function(obj = recluster_new_data$seurat_obj) {
    assay_choices <- .safe_assay_choices(obj)
    if (!length(assay_choices)) return("")
    canonical <- .scalar_chr(recluster_new_data$umap_assay_choice, default = "")
    if (nzchar(canonical) && canonical %in% assay_choices) return(canonical)
    input_value <- .scalar_chr(input$recluster_new_assay_select, default = "")
    if (nzchar(input_value) && input_value %in% assay_choices) return(input_value)
    .preferred_assay_choice(obj)
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

  .expr_distribution_display_range <- function(full_rng) {
    full_rng <- suppressWarnings(as.numeric(full_rng %||% numeric(0)))
    full_rng <- sort(full_rng[is.finite(full_rng)])
    if (length(full_rng) < 2L || !is.finite(diff(full_rng)) || diff(full_rng) <= 0) {
      return(full_rng)
    }
    # Keep only enough negative display space to show the zero-density tail.
    # Plot and slider share this range, so larger padding wastes panel width.
    x_padding <- max(diff(full_rng) * 0.005, .Machine$double.eps)
    c(min(full_rng[[1L]], 0) - x_padding, full_rng[[2L]])
  }

  .selected_levels_for_column <- function(col_name, profile) {
    lv <- as.character(profile$levels %||% character(0))
    if (!length(lv)) return(character(0))
    keep <- vapply(lv, function(x) .metadata_level_checked(col_name, x), logical(1))
    lv[keep]
  }

  observe({
    if (!.recluster_new_event_allowed("metadata_level_state_capture")) return(invisible(NULL))
    profiles <- recluster_new_data$metadata_profiles
    if (!length(profiles)) return(invisible(NULL))
    for (col_name in names(profiles)) {
      levels_now <- as.character(profiles[[col_name]]$levels %||% character(0))
      if (!length(levels_now)) next
      for (level_name in levels_now) {
        input_value <- input[[.cat_level_input_id(col_name, level_name)]]
        if (is.null(input_value)) next
        state_key <- .metadata_level_state_key(col_name, level_name)
        state_value <- isTRUE(input_value)
        if (!exists(state_key, envir = .metadata_level_checked_state, inherits = FALSE) ||
            !identical(get(state_key, envir = .metadata_level_checked_state, inherits = FALSE), state_value)) {
          assign(state_key, state_value, envir = .metadata_level_checked_state)
        }
      }
    }
    invisible(NULL)
  }, priority = 1200)

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
    if (is.null(sobj) || !inherits(sobj, "Seurat") || is.null(color_map) || !length(color_map)) return(sobj)
    if (!is.list(color_map)) color_map <- as.list(color_map)
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

  .send_metadata_colors_to_ui <- function(obj, col_name, levels_vec = NULL) {
    if (is.null(obj) || !inherits(obj, "Seurat") || !nzchar(.scalar_chr(col_name, default = ""))) {
      return(invisible(NULL))
    }
    if (is.null(levels_vec)) {
      profile <- (recluster_new_data$metadata_profiles %||% list())[[col_name]]
      levels_vec <- if (is.list(profile)) profile$levels else character(0)
    }
    levels_vec <- as.character(levels_vec %||% character(0))
    levels_vec <- levels_vec[!is.na(levels_vec) & nzchar(levels_vec)]
    if (!length(levels_vec)) return(invisible(NULL))
    color_map <- .level_color_map(obj, col_name, levels_vec)
    colors <- as.list(unname(as.character(color_map)))
    names(colors) <- names(color_map)
    .db_dbg(
      "metadata_colors_ui",
      sprintf("column=%s levels=%d colors=%s", col_name, length(colors), paste(unname(as.character(color_map)), collapse = ","))
    )
    session$sendCustomMessage(
      "recluster-new-metadata-colors",
      list(
        object = .recluster_new_canonical_object_name(),
        context_revision = .recluster_new_context_revision(),
        column = col_name,
        colors = colors
      )
    )
    invisible(NULL)
  }

  .persist_active_object <- function(sobj, update_local = TRUE) {
    nm <- .recluster_new_canonical_object_name()
    if (!nzchar(nm) || is.null(sobj) || !inherits(sobj, "Seurat")) return(invisible(NULL))
    if (!isTRUE(.recluster_new_context_is_settled())) {
      .db_dbg(
        "persist_ignored_unsettled_context",
        sprintf(
          "target=%s active=%s loaded=%s loading=%s syncing=%s activating=%s",
          nm,
          .scalar_chr(shared_data$active_object_name, default = ""),
          .scalar_chr(recluster_new_loaded_object_name(), default = ""),
          as.character(isTRUE(recluster_new_object_loading())),
          as.character(isTRUE(recluster_new_dataset_syncing())),
          as.character(isTRUE(recluster_new_page_activating()))
        )
      )
      return(invisible(NULL))
    }
    loaded_name <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    active_name <- .scalar_chr(shared_data$active_object_name, default = "")
    # Expression selection is object-owned. Reattach current loaded-object
    # state before unrelated object writes, because local plot objects can lag
    # behind the canonical object after a group edit.
    if (nzchar(loaded_name) && identical(nm, loaded_name) && identical(nm, active_name)) {
      expr_state <- tryCatch(recluster_new_data$expr_selection, error = function(e) NULL)
      if (is.list(expr_state)) sobj <- .expr_store_set(sobj, expr_state)
      saved_groups <- tryCatch(recluster_new_data$cell_groups, error = function(e) list())
      sobj <- .saved_group_store_set(sobj, saved_groups)
    }
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
    recluster_new_data$metadata_filter_data_revision <-
      as.integer(recluster_new_data$metadata_filter_data_revision %||% 0L) + 1L
    loaded_name <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    active_name <- .scalar_chr(shared_data$active_object_name, default = "")
    if (nzchar(loaded_name) && identical(loaded_name, active_name)) {
      obj <- .expr_store_set(obj, recluster_new_data$expr_selection)
      obj <- .saved_group_store_set(obj, recluster_new_data$cell_groups)
    }
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
    next_metadata_key <- .metadata_selector_structure_key(profiles)
    if (!identical(.scalar_chr(recluster_new_data$metadata_selector_structure_key, default = ""), next_metadata_key)) {
      .db_dbg(
        "metadata_ui_structure_change",
        sprintf("old=%s new=%s", substr(.scalar_chr(recluster_new_data$metadata_selector_structure_key, default = ""), 1L, 120L), substr(next_metadata_key, 1L, 120L))
      )
      recluster_new_data$metadata_selector_structure_key <- next_metadata_key
    }
    next_controls_key <- .viz_controls_structure_key(obj)
    if (!identical(.scalar_chr(recluster_new_data$viz_controls_structure_key, default = ""), next_controls_key)) {
      recluster_new_data$viz_controls_structure_key <- next_controls_key
    }
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

      color_choices <- c("Single Gene Expression", available_cols, "None")
      color_now <- .scalar_chr(recluster_new_data$umap_color_choice, default = "")
      display_now <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
      if (!(color_now %in% color_choices)) {
        color_now <- if (identical(display_now, "gene") && length(.umap_gene_selection()$genes)) {
          "Single Gene Expression"
        } else {
          target_col
        }
      }
      # Metadata writes must not change independent UMAP display state. Only
      # repair color choice when its previous value no longer exists.
      .set_umap_color_choice(color_now, choices = color_choices)

      preserve_choice <- function(input_id, choices, fallback) {
        current <- .scalar_chr(isolate(input[[input_id]]), default = "")
        selected <- if (nzchar(current) && current %in% choices) current else fallback
        if (!identical(current, selected)) {
          updateSelectInput(session, input_id, choices = choices, selected = selected)
        }
        selected
      }
      preserve_choice(
        "recluster_new_pb_meta_col",
        available_cols,
        if (target_col %in% available_cols) target_col else if (length(available_cols)) available_cols[[1]] else ""
      )
      preserve_choice(
        "recluster_new_rule_color_by_select",
        color_choices,
        if (target_col %in% available_cols) target_col else "None"
      )
      preserve_choice(
        "recluster_new_scatter_color_by",
        c("None", available_cols),
        if (target_col %in% available_cols) target_col else "None"
      )
    }
    invisible(NULL)
  }

  # All metadata/object mutations use this path. It reattaches expression
  # state before replacing the registry entry, then refreshes dependent
  # metadata views without resetting unrelated controls.
  .commit_metadata_object_update <- function(obj, open_col = NULL) {
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))
    .persist_active_object(obj)
    .refresh_metadata_after_object_update(obj, open_col = open_col)
    .db_dbg(
      "metadata_object_commit",
      sprintf(
        "object=%s open_col=%s metadata_cols=%d expr_groups=%d",
        .recluster_new_canonical_object_name(),
        .scalar_chr(open_col, default = ""),
        ncol(obj@meta.data),
        length(.expr_state_normalize(recluster_new_data$expr_selection)$groups %||% list())
      )
    )
    invisible(obj)
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
    next_value <- trimws(.scalar_chr(value, default = ""))
    if (identical(vals[[index]], next_value)) return(invisible(vals))
    vals[[index]] <- next_value
    recluster_new_data$umap_gene_values <- vals
    .remember_visual_settings(umap_gene_values = vals)
    invisible(vals)
  }

  .set_umap_color_choice <- function(choice, choices = NULL, update_ui = TRUE, persist = TRUE) {
    ch <- .scalar_chr(choice, default = "")
    if (!nzchar(ch)) return(invisible(NULL))
    if (length(choices) && !(ch %in% choices)) return(invisible(NULL))
    cur <- .scalar_chr(recluster_new_data$umap_color_choice, default = "")
    choices_sig <- if (length(choices)) paste(as.character(choices), collapse = "\u001f") else ""
    choices_changed <- length(choices) && !identical(
      .scalar_chr(recluster_new_data$umap_color_choices_sig, default = ""),
      choices_sig
    )
    if (identical(cur, ch) && !isTRUE(choices_changed)) return(invisible(ch))
    .db_dbg("set_color", sprintf("cur=%s next=%s", cur, ch))
    recluster_new_data$umap_color_choice <- ch
    if (length(choices)) recluster_new_data$umap_color_choices_sig <- choices_sig
    if (isTRUE(persist)) {
      .remember_visual_settings(
        umap_color_choice = ch,
        umap_display_mode = if (identical(ch, "Single Gene Expression")) "gene" else "metadata"
      )
    }
    if (isTRUE(update_ui)) {
      updateSelectInput(session, "recluster_new_color_by_select", choices = choices %||% NULL, selected = ch)
    }
    invisible(ch)
  }


  .sync_assay_gene_inputs <- function(force = FALSE) {
    .db_dbg("sync_assay_gene_inputs", sprintf("force=%s", as.character(force)))
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))

    assay_choices <- .safe_assay_choices(obj)
    if (!length(assay_choices)) return(invisible(NULL))

    assay_state_before <- .scalar_chr(recluster_new_data$umap_assay_choice, default = "")
    assay_now <- .expr_assay_name(obj)
    assay_target <- if (nzchar(assay_now) && assay_now %in% assay_choices) assay_now else assay_choices[[1]]
    if (isTRUE(force)) {
      forced_target <- .scalar_chr(recluster_new_data$umap_assay_choice, default = "")
      if (nzchar(forced_target) && forced_target %in% assay_choices) assay_target <- forced_target
    }
    if (!identical(.scalar_chr(recluster_new_data$umap_assay_choice, default = ""), assay_target)) {
      recluster_new_data$umap_assay_choice <- assay_target
    }
    if (!identical(assay_now, assay_target)) {
      updateSelectInput(session, "recluster_new_assay_select", choices = assay_choices, selected = assay_target)
    }

    all_genes <- .assay_feature_names(obj, assay_target)
    if (length(all_genes)) {
      stored_umap_genes <- as.character(recluster_new_data$umap_gene_values %||% c("", "", ""))
      length(stored_umap_genes) <- 3L
      stored_umap_genes[is.na(stored_umap_genes)] <- ""
      gene_now <- .scalar_chr(stored_umap_genes[[1]], default = "")
      gene2_now <- .scalar_chr(stored_umap_genes[[2]], default = "")
      gene3_now <- .scalar_chr(stored_umap_genes[[3]], default = "")
      gene_target <- if (nzchar(gene_now) && gene_now %in% all_genes) gene_now else ""
      gene2_target <- if (nzchar(gene2_now) && gene2_now %in% all_genes) gene2_now else ""
      gene3_target <- if (nzchar(gene3_now) && gene3_now %in% all_genes) gene3_now else ""
      next_gene_values <- c(
        .scalar_chr(gene_target, default = ""),
        .scalar_chr(gene2_target, default = ""),
        .scalar_chr(gene3_target, default = "")
      )
      current_gene_values <- as.character(recluster_new_data$umap_gene_values %||% c("", "", ""))
      length(current_gene_values) <- 3L
      current_gene_values[is.na(current_gene_values)] <- ""
      if (!identical(current_gene_values, next_gene_values)) {
        recluster_new_data$umap_gene_values <- next_gene_values
      }
      if (isTRUE(force) || !identical(assay_state_before, assay_target) || !identical(gene_now, gene_target)) {
        selected_gene <- if (nzchar(gene_target)) gene_target else character(0)
        .db_update_gene_selectize("recluster_new_gene_expr_select_1", all_genes, selected = selected_gene)
      }
      if (isTRUE(force) || !identical(assay_state_before, assay_target) || !identical(gene2_now, gene2_target)) {
        selected_gene <- if (nzchar(gene2_target)) gene2_target else character(0)
        .db_update_gene_selectize("recluster_new_gene_expr_select_2", all_genes, selected = selected_gene)
      }
      if (isTRUE(force) || !identical(assay_state_before, assay_target) || !identical(gene3_now, gene3_target)) {
        selected_gene <- if (nzchar(gene3_target)) gene3_target else character(0)
        .db_update_gene_selectize("recluster_new_gene_expr_select_3", all_genes, selected = selected_gene)
      }
    }

    scatter_x_now <- .scalar_chr(input$recluster_new_scatter_gene_x, default = "")
    scatter_y_now <- .scalar_chr(input$recluster_new_scatter_gene_y, default = "")
    scatter_x_target <- if (nzchar(scatter_x_now) && scatter_x_now %in% all_genes) scatter_x_now else if (length(all_genes)) all_genes[[1]] else character(0)
    scatter_y_target <- if (nzchar(scatter_y_now) && scatter_y_now %in% all_genes) scatter_y_now else if (length(all_genes) >= 2) all_genes[[2]] else scatter_x_target
    if (isTRUE(force) || !identical(assay_state_before, assay_target) || !identical(scatter_x_now, scatter_x_target)) {
      .db_update_gene_selectize("recluster_new_scatter_gene_x", all_genes, selected = scatter_x_target)
    }
    if (isTRUE(force) || !identical(assay_state_before, assay_target) || !identical(scatter_y_now, scatter_y_target)) {
      .db_update_gene_selectize("recluster_new_scatter_gene_y", all_genes, selected = scatter_y_target)
    }
    next_expr_key <- .expr_ui_structure_key(
      recluster_new_data$expr_selection,
      .recluster_new_canonical_object_name(),
      assay_target
    )
    if (!identical(.scalar_chr(recluster_new_data$expr_ui_structure_key, default = ""), next_expr_key)) {
      recluster_new_data$expr_ui_structure_key <- next_expr_key
    }
    recluster_new_data$expr_active_range_structure_key <- .expr_active_range_structure_key(
      recluster_new_data$expr_selection,
      .recluster_new_canonical_object_name(),
      assay_target
    )
    invisible(NULL)
  }

  .sync_rule_assay_gene_inputs <- function(force = FALSE) {
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))

    assay_choices <- .safe_assay_choices(obj)
    if (!length(assay_choices)) return(invisible(NULL))

    assay_state_before <- .scalar_chr(recluster_new_data$rule_assay_choice, default = "")
    assay_now <- .scalar_chr(input$recluster_new_rule_assay_select, default = "")
    assay_target <- if (nzchar(assay_now) && assay_now %in% assay_choices) assay_now else assay_choices[[1]]
    if (isTRUE(force)) {
      forced_target <- .scalar_chr(recluster_new_data$rule_assay_choice, default = "")
      if (nzchar(forced_target) && forced_target %in% assay_choices) assay_target <- forced_target
    }
    if (!identical(.scalar_chr(recluster_new_data$rule_assay_choice, default = ""), assay_target)) {
      recluster_new_data$rule_assay_choice <- assay_target
    }
    if (!identical(assay_now, assay_target)) {
      updateSelectInput(session, "recluster_new_rule_assay_select", choices = assay_choices, selected = assay_target)
    }

    all_genes <- .assay_feature_names(obj, assay_target)
    if (length(all_genes)) {
      gene_now <- .scalar_chr(input$recluster_new_rule_gene_expr_select_1, default = "")
      gene_target <- if (nzchar(gene_now) && gene_now %in% all_genes) gene_now else ""
      if (isTRUE(force) || !identical(assay_state_before, assay_target) || !identical(gene_now, gene_target)) {
        selected_gene <- if (nzchar(gene_target)) gene_target else character(0)
        .db_update_gene_selectize("recluster_new_rule_gene_expr_select_1", all_genes, selected = selected_gene)
      }
    }

    scatter_x_now <- .scalar_chr(input$recluster_new_rule_scatter_gene_x, default = "")
    scatter_y_now <- .scalar_chr(input$recluster_new_rule_scatter_gene_y, default = "")
    scatter_x_target <- if (nzchar(scatter_x_now) && scatter_x_now %in% all_genes) scatter_x_now else if (length(all_genes)) all_genes[[1]] else character(0)
    scatter_y_target <- if (nzchar(scatter_y_now) && scatter_y_now %in% all_genes) scatter_y_now else if (length(all_genes) >= 2) all_genes[[2]] else scatter_x_target
    if (isTRUE(force) || !identical(assay_state_before, assay_target) || !identical(scatter_x_now, scatter_x_target)) {
      .db_update_gene_selectize("recluster_new_rule_scatter_gene_x", all_genes, selected = scatter_x_target)
    }
    if (isTRUE(force) || !identical(assay_state_before, assay_target) || !identical(scatter_y_now, scatter_y_target)) {
      .db_update_gene_selectize("recluster_new_rule_scatter_gene_y", all_genes, selected = scatter_y_target)
    }
    invisible(NULL)
  }

  # Dynamic selectize controls report their actual shiny:bound lifecycle event
  # from the browser. Hydrate only after that binding exists; this removes the
  # old flush-order dependency and also covers cached renderUI reuse.
  .hydrate_bound_gene_selectize <- function(input_id) {
    input_id <- .scalar_chr(input_id, default = "")
    obj <- recluster_new_data$seurat_obj
    if (!nzchar(input_id) || is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))

    assay_name <- ""
    all_genes <- character(0)
    selected_gene <- character(0)
    if (grepl("^recluster_new_gene_expr_select_[1-3]$", input_id)) {
      assay_name <- .current_umap_assay(obj)
      all_genes <- .assay_feature_names(obj, assay_name)
      values <- as.character(recluster_new_data$umap_gene_values %||% c("", "", ""))
      length(values) <- 3L
      values[is.na(values)] <- ""
      index <- suppressWarnings(as.integer(sub("^recluster_new_gene_expr_select_", "", input_id)))
      selected_gene <- if (is.finite(index) && index >= 1L && index <= 3L) values[[index]] else ""
    } else if (input_id %in% c("recluster_new_scatter_gene_x", "recluster_new_scatter_gene_y")) {
      assay_name <- .current_umap_assay(obj)
      all_genes <- .assay_feature_names(obj, assay_name)
      selected_gene <- .scalar_chr(input[[input_id]], default = "")
    } else if (input_id %in% c("recluster_new_rule_gene_expr_select_1", "recluster_new_rule_scatter_gene_x", "recluster_new_rule_scatter_gene_y")) {
      assay_name <- .current_rule_assay(obj)
      all_genes <- .assay_feature_names(obj, assay_name)
      selected_gene <- .scalar_chr(input[[input_id]], default = "")
    } else if (grepl("^recluster_new_expr_add_gene__", input_id)) {
      assay_name <- .expr_assay_name(obj)
      all_genes <- .assay_feature_names(obj, assay_name)
      selected_gene <- character(0)
    } else {
      return(invisible(NULL))
    }

    all_genes <- unique(as.character(all_genes %||% character(0)))
    all_genes <- all_genes[!is.na(all_genes) & nzchar(all_genes)]
    selected_gene <- if (nzchar(selected_gene) && selected_gene %in% all_genes) selected_gene else character(0)
    .db_dbg(
      "gene_selectize_bound",
      sprintf("id=%s assay=%s genes=%d selected=%s", input_id, assay_name, length(all_genes), paste(selected_gene, collapse = ","))
    )
    .db_update_gene_selectize(input_id, all_genes, selected = selected_gene)
    invisible(NULL)
  }

  observeEvent(input$recluster_new_gene_selectize_bound, {
    if (!.recluster_new_event_allowed("gene_selectize_bound")) return(invisible(NULL))
    payload <- input$recluster_new_gene_selectize_bound
    if (!is.list(payload)) return(invisible(NULL))
    if (!.recluster_new_payload_context_matches(payload)) return(invisible(NULL))
    .hydrate_bound_gene_selectize(payload$id)
  }, ignoreInit = TRUE, priority = 1050)

  # Dynamic gene controls need one common post-render hydration contract.
  # Bound events cover reused nodes, while this callback covers newly rendered
  # nodes whose earlier bound event belonged to an unsettled object flush.
  # Only captured immutable values cross the non-reactive callback boundary;
  # all current-context validation reads stay inside isolate().
  .schedule_gene_selectize_hydration <- function(input_ids, genes, object_name, context_revision, source = "") {
    input_ids <- unique(as.character(input_ids %||% character(0)))
    input_ids <- input_ids[!is.na(input_ids) & nzchar(input_ids)]
    genes <- unique(as.character(genes %||% character(0)))
    genes <- genes[!is.na(genes) & nzchar(genes)]
    object_name <- .scalar_chr(object_name, default = "")
    context_revision <- suppressWarnings(as.integer(context_revision %||% NA_integer_))
    if (!length(input_ids) || !length(genes) || !nzchar(object_name) ||
        !is.finite(context_revision) || is.na(context_revision)) {
      return(invisible(NULL))
    }
    session$onFlushed(function() {
      # Agent note: onFlushed is imperative, not a reactive consumer. Keep the
      # complete callback transaction isolated, including helper calls.
      isolate({
      snapshot <- list(
        active = .scalar_chr(shared_data$active_object_name, default = ""),
        loaded = .scalar_chr(recluster_new_loaded_object_name(), default = ""),
        revision = .recluster_new_context_revision(),
        settled = .recluster_new_context_is_settled()
      )
      if (!isTRUE(snapshot$settled) ||
          !identical(snapshot$active, object_name) ||
          !identical(snapshot$loaded, object_name) ||
          !identical(snapshot$revision, context_revision)) {
        .db_dbg(
          "gene_catalog_flush_ignored_stale",
          sprintf(
            "source=%s rendered_object=%s rendered_revision=%d active=%s loaded=%s revision=%s settled=%s",
            .scalar_chr(source, default = ""),
            object_name,
            context_revision,
            snapshot$active,
            snapshot$loaded,
            as.character(snapshot$revision),
            as.character(snapshot$settled)
          )
        )
        return(invisible(NULL))
      }
      .db_dbg(
        "gene_catalog_flush_hydrate",
        sprintf(
          "source=%s object=%s revision=%d controls=%d genes=%d",
          .scalar_chr(source, default = ""),
          object_name,
          context_revision,
          length(input_ids),
          length(genes)
        )
      )
      for (input_id in input_ids) {
        .db_update_gene_selectize(input_id, genes, selected = character(0))
      }
      invisible(NULL)
      })
    }, once = TRUE)
    invisible(NULL)
  }

  recluster_new_dataset_syncing <- reactiveVal(FALSE)
  recluster_new_loaded_object_name <- reactiveVal("")
  recluster_new_object_loading <- reactiveVal(FALSE)
  recluster_new_page_activating <- reactiveVal(FALSE)
  # A failed object load is terminal for this exact registry source. Keep the
  # failure visible instead of retrying the same invalid object on every flush.
  # A changed object entry produces a new source signature and can retry.
  recluster_new_load_failure_source_signature <- reactiveVal("")
  # Monotonic object-context token. Object names are not sufficient when a
  # workspace import replaces an object under the same name; custom messages
  # and mounted DOM must also belong to this exact load transaction.
  recluster_new_object_context_revision <- reactiveVal(0L)
  # Only this revision may release object-transition isolation after the next
  # Shiny flush. Older onFlushed callbacks must never settle a newer load.
  recluster_new_transition_flush_revision <- reactiveVal(NA_integer_)
  recluster_new_transition_flush_token <- reactiveVal(0L)
  umap_plot_rendered <- reactiveVal(NULL)
  violin_plot_rendered <- reactiveVal(NULL)

  .recluster_new_on_page <- function() {
    .db_tab_is_active()
  }

  .recluster_new_canonical_object_name <- function() {
    # Canonical identity always comes from shared state. The loaded name is a
    # transaction-local view and must not mask a newer active object during
    # page entry or object switching.
    .scalar_chr(shared_data$active_object_name, default = "")
  }

  # Plot consumers may render only after one exact object/data-slot
  # transaction has been confirmed. This key is a lifecycle fact, not a
  # timeout or a browser-side readiness guess.
  .recluster_new_expected_plot_context_key <- function(
    active_name = NULL,
    loaded_name = NULL,
    revision = NULL
  ) {
    if (is.null(active_name)) active_name <- .recluster_new_canonical_object_name()
    if (is.null(loaded_name)) loaded_name <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (is.null(revision)) revision <- .recluster_new_context_revision()
    active_name <- .scalar_chr(active_name, default = "")
    loaded_name <- .scalar_chr(loaded_name, default = "")
    revision <- suppressWarnings(as.integer(revision %||% NA_integer_))
    if (!nzchar(active_name) || !identical(active_name, loaded_name) ||
        !is.finite(revision) || is.na(revision)) {
      return("")
    }
    paste(active_name, loaded_name, revision, .expr_selection_slot(), sep = "::")
  }

  .recluster_new_clear_page_context <- function(reason = "page_left") {
    recluster_new_data$confirmed_plot_context_key <- ""
    loaded <- .scalar_chr(isolate(recluster_new_loaded_object_name()), default = "")
    has_local_object <- !is.null(isolate(recluster_new_data$seurat_obj))
    if (!nzchar(loaded) && !has_local_object) return(invisible(NULL))
    .db_dbg(
      "page_context_clear",
      sprintf("reason=%s loaded=%s", .scalar_chr(reason, default = "page_left"), loaded)
    )
    # Do not let a hidden page retain a renderable object from its previous
    # route. Re-entry must load only current shared canonical state.
    recluster_new_loaded_object_name("")
    recluster_new_data$seurat_obj <- NULL
    recluster_new_data$plot_df <- NULL
    .clear_viz_controls_cache()
    umap_plot_rendered(NULL)
    violin_plot_rendered(NULL)
    recluster_new_object_loading(FALSE)
    recluster_new_dataset_syncing(FALSE)
    recluster_new_page_activating(FALSE)
    recluster_new_transition_flush_token(0L)
    recluster_new_transition_flush_revision(NA_integer_)
    invisible(NULL)
  }

  # Every input event must be processed against one settled object context.
  # During a canonical-object transition, old DOM bindings can still deliver
  # one final event in the same Shiny flush. Rejecting that event by context is
  # deterministic; elapsed-time waits would only hide the ordering defect.
  .recluster_new_context_is_settled <- function() {
    active <- .scalar_chr(shared_data$active_object_name, default = "")
    loaded <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    confirmed_key <- .scalar_chr(recluster_new_data$confirmed_plot_context_key, default = "")
    expected_key <- .recluster_new_expected_plot_context_key(
      active_name = active,
      loaded_name = loaded,
      revision = .recluster_new_context_revision()
    )
    isTRUE(.recluster_new_on_page()) && nzchar(active) && identical(active, loaded) &&
      !isTRUE(recluster_new_object_loading()) &&
      !isTRUE(recluster_new_dataset_syncing()) &&
      !isTRUE(recluster_new_page_activating()) &&
      nzchar(confirmed_key) && identical(confirmed_key, expected_key)
  }

  .recluster_new_event_allowed <- function(source = "") {
    if (isTRUE(.recluster_new_context_is_settled())) return(TRUE)
    .db_dbg(
      "event_ignored_unsettled_context",
      sprintf(
        "source=%s active=%s loaded=%s loading=%s syncing=%s activating=%s %s",
        .scalar_chr(source, default = ""),
        .scalar_chr(shared_data$active_object_name, default = ""),
        .scalar_chr(recluster_new_loaded_object_name(), default = ""),
        as.character(isTRUE(recluster_new_object_loading())),
        as.character(isTRUE(recluster_new_dataset_syncing())),
        as.character(isTRUE(recluster_new_page_activating())),
        paste0("confirmed=", substr(.scalar_chr(recluster_new_data$confirmed_plot_context_key, default = ""), 1L, 120L))
      )
    )
    FALSE
  }

  .recluster_new_context_revision <- function() {
    value <- suppressWarnings(as.integer(recluster_new_object_context_revision() %||% 0L))
    if (!is.finite(value) || is.na(value) || value < 0L) 0L else value
  }

  .recluster_new_begin_object_transition <- function(active_name) {
    next_revision <- .recluster_new_context_revision() + 1L
    recluster_new_object_context_revision(next_revision)
    recluster_new_data$confirmed_plot_context_key <- ""
    .db_dbg(
      "object_context_begin",
      sprintf("revision=%d active=%s loaded=%s", next_revision, active_name, .scalar_chr(recluster_new_loaded_object_name(), default = ""))
    )
    next_revision
  }

  .recluster_new_payload_context_matches <- function(payload, allow_empty = FALSE) {
    if (!is.list(payload)) return(FALSE)
    object_name <- .scalar_chr(payload$object, default = "")
    revision <- suppressWarnings(as.integer(payload$context_revision %||% NA_integer_))
    if (isTRUE(allow_empty) && !nzchar(object_name) && (is.na(revision) || !is.finite(revision))) {
      return(TRUE)
    }
    nzchar(object_name) && identical(object_name, .recluster_new_canonical_object_name()) &&
      is.finite(revision) && !is.na(revision) && identical(revision, .recluster_new_context_revision())
  }

  .recluster_new_expression_state_needs_reload <- function(object_name = "") {
    object_name <- .scalar_chr(object_name, default = "")
    if (!nzchar(object_name)) return(FALSE)
    entry <- tryCatch(shared_data$all_seurat_objects[[object_name]], error = function(e) NULL)
    shared_obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (is.null(shared_obj) || !inherits(shared_obj, "Seurat")) return(FALSE)
    !identical(
      .expr_store_get(shared_obj),
      .expr_without_active_gene_focus(recluster_new_data$expr_selection)
    )
  }

  .final_plot_df_signature <- function() {
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return("")
    display_mode <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
    # Gene selectors do not belong to the metadata-colored UMAP cache. This
    # keeps catalog hydration and lower expression-tab edits from launching a
    # full-cell UMAP rebuild when gene coloring is not selected.
    umap_gene_info <- if (identical(display_mode, "gene")) {
      .umap_gene_selection()
    } else {
      list(genes = character(0))
    }
    universe <- rownames(recluster_new_data$plot_df %||% data.frame())
    paste(
      .scalar_chr(recluster_new_loaded_object_name(), default = ""),        # part 1: loaded_object_name
      .current_umap_reduction(obj),                                          # part 2: reduction
      .scalar_chr(input$recluster_new_umap_axis_x_select, default = ""),    # part 3: x_axis
      .scalar_chr(input$recluster_new_umap_axis_y_select, default = ""),    # part 4: y_axis
      .current_umap_assay(obj),                                              # part 5: assay
      .scalar_chr(input$recluster_new_slot_select, default = ""),           # part 6: slot
      display_mode,                                                          # part 7: display_mode
      .scalar_chr(recluster_new_data$umap_color_choice, default = ""),      # part 8: color_choice
      paste(as.character(umap_gene_info$genes %||% character(0)), collapse = "|"), # part 9: gene_list
      .cell_set_signature(.visible_umap_cells(), universe),                  # part 10: visible_cells_sig
      .cell_set_signature(all_selected_cells(), universe),                   # part 11: all_selected_cells_sig
      # Agent note: Orange outline follows active gene independently from the
      # combined selection; active-gene changes must invalidate both plot caches.
      .cell_set_signature(expression_active_gene_result()$cells, universe),  # part 12: active_gene_cells_sig
      # Agent note: Paint membership and paint source are separate from subset
      # membership. Keep both sets in the cache key so saved-group cyan and
      # other-selection violet traces cannot remain stale after a toggle.
      .cell_set_signature(saved_group_highlight_cells(), universe),            # part 13: saved_group_highlight_cells_sig
      .cell_set_signature(violet_selection_highlight_cells(), universe),       # part 14: violet_selection_highlight_cells_sig
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
    # Keep the heavy Plotly cache keyed to data and plot geometry. The explicit
    # color tick invalidates this cache after a palette write without reading the
    # derived palette during cache evaluation.
    visual_settings <- .current_visual_settings()
    paste(
      .final_plot_df_signature(),                                                                          # parts 1-12 (see .final_plot_df_signature)
      .scalar_chr(input$recluster_new_split_by_select, default = ""),                                    # part 13: split_by
      as.character(suppressWarnings(as.numeric(visual_settings$dot_size %||% input$recluster_new_dot_size %||% 1.0))), # part 14: dot_size
      as.character(suppressWarnings(as.numeric(input$recluster_new_dot_alpha %||% 0.8))),                 # part 15: dot_alpha
      as.character(suppressWarnings(as.numeric(visual_settings$stroke_width %||% input$recluster_new_stroke_width %||% 0.1))), # part 16: stroke_width
      .scalar_chr(input$recluster_new_stroke_color, default = "black"),                                   # part 17: stroke_color
      as.character(suppressWarnings(as.integer(recluster_new_data$umap_color_tick %||% 0L))),              # part 18: color_tick
      sep = "::"
    )
  }

  .finalize_umap_plotly <- function(p) {
    p <- event_register(p, "plotly_selected")
    p <- event_register(p, "plotly_doubleclick")
    p <- .plotly_touch_zoom(p)
    cache_sig <- .umap_plot_cache_signature()
    if (nzchar(cache_sig)) {
      isolate({
        recluster_new_data$umap_plot_cache_sig <- cache_sig
        recluster_new_data$umap_plot_cache <- p
      })
    }
    p
  }

  .viz_controls_structure_key <- function(obj, object_name = "") {
    nm <- .scalar_chr(object_name, default = "")
    if (!nzchar(nm)) nm <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (!nzchar(nm)) nm <- .scalar_chr(shared_data$active_object_name, default = "")
    dims <- wanlab_get_active_embedding_dims(tryCatch(
      shared_data$all_seurat_objects[[nm]],
      error = function(e) NULL
    ))
    paste(
      nm,
      paste(dims, collapse = ","),
      paste(names(recluster_new_data$metadata_profiles %||% list()), collapse = "|"),
      paste(.safe_assay_choices(obj), collapse = "|"),
      paste(.embedding_reduction_choices(obj), collapse = "|"),
      sep = "::"
    )
  }

  .metadata_selector_structure_key <- function(profiles, object_name = "") {
    nm <- .scalar_chr(object_name, default = "")
    if (!nzchar(nm)) nm <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (!nzchar(nm)) nm <- .scalar_chr(shared_data$active_object_name, default = "")
    profiles <- profiles %||% list()
    profile_sig <- vapply(names(profiles), function(col_name) {
      profile <- profiles[[col_name]] %||% list()
      levels <- as.character(profile$levels %||% character(0))
      paste(
        col_name,
        .scalar_chr(profile$bucket, default = ""),
        as.character(isTRUE(profile$numeric_like)),
        paste(levels, collapse = "\u001f"),
        sep = "="
      )
    }, character(1))
    paste(nm, paste(profile_sig, collapse = "\u001e"), sep = "::")
  }

  .clear_viz_controls_cache <- function() {
    recluster_new_data$viz_controls_structure_key <- ""
    recluster_new_data$metadata_selector_structure_key <- ""
    recluster_new_data$viz_controls_cache_sig <- ""
    recluster_new_data$viz_controls_cache <- NULL
    recluster_new_data$rule_viz_controls_cache_sig <- ""
    recluster_new_data$rule_viz_controls_cache <- NULL
    .clear_final_plot_cache()
    invisible(NULL)
  }

  .recluster_new_load_source_signature <- function(active_name = "") {
    active_name <- .scalar_chr(active_name, default = "")
    if (!nzchar(active_name)) return("")
    entry <- tryCatch(shared_data$all_seurat_objects[[active_name]], error = function(e) NULL)
    obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (is.null(obj)) return(paste(active_name, "missing", sep = "::"))
    if (!inherits(obj, "Seurat")) {
      return(paste(active_name, "class", paste(class(obj), collapse = "|"), sep = "::"))
    }
    reductions <- tryCatch(.embedding_reduction_choices(obj), error = function(e) character(0))
    shape_signature <- if (length(reductions)) {
      tryCatch(.reduction_shape_signature(obj), error = function(e) "")
    } else {
      ""
    }
    paste(active_name, paste(reductions, collapse = "|"), shape_signature, sep = "::")
  }

  .recluster_new_schedule_context_settle <- function(revision, message = "Loading selected dataset plot...", tab_now = "") {
    revision <- suppressWarnings(as.integer(revision %||% NA_integer_))
    if (!is.finite(revision) || is.na(revision)) return(invisible(NULL))
    previous_token <- suppressWarnings(as.integer(isolate(recluster_new_transition_flush_token()) %||% 0L))
    if (!is.finite(previous_token) || is.na(previous_token) || previous_token < 0L) previous_token <- 0L
    settle_token <- previous_token + 1L
    recluster_new_transition_flush_token(settle_token)
    recluster_new_transition_flush_revision(revision)
    session$onFlushed(function() {
      # Agent note: later settlement helpers also inspect reactive state, so
      # isolating only the initial snapshot is insufficient.
      isolate({
      context_snapshot <- list(
        current_revision = .recluster_new_context_revision(),
        pending_token = suppressWarnings(as.integer(recluster_new_transition_flush_token()) %||% NA_integer_),
        pending_revision = suppressWarnings(as.integer(recluster_new_transition_flush_revision()) %||% NA_integer_),
        active_object = .recluster_new_canonical_object_name(),
        loaded_object = .scalar_chr(recluster_new_loaded_object_name(), default = ""),
        object_ready = inherits(recluster_new_data$seurat_obj, "Seurat"),
        plot_data_ready = is.data.frame(recluster_new_data$plot_df)
      )
      current_revision <- context_snapshot$current_revision
      pending_token <- context_snapshot$pending_token
      pending_revision <- context_snapshot$pending_revision
      if (!is.finite(pending_revision) || is.na(pending_revision) ||
          !is.finite(pending_token) || is.na(pending_token) ||
          !identical(pending_token, settle_token) ||
          !identical(pending_revision, revision) || !identical(current_revision, revision)) {
        .db_dbg(
          "transition_flush_ignored_stale",
          sprintf(
            "token=%d pending_token=%s revision=%d pending_revision=%s current=%d",
            settle_token,
            as.character(pending_token),
            revision,
            as.character(pending_revision),
            current_revision
          )
        )
        return(invisible(NULL))
      }
      recluster_new_transition_flush_token(0L)
      recluster_new_transition_flush_revision(NA_integer_)
      recluster_new_dataset_syncing(FALSE)
      recluster_new_page_activating(FALSE)
      if (!isTRUE(context_snapshot$object_ready) ||
          !isTRUE(context_snapshot$plot_data_ready) ||
          !identical(context_snapshot$active_object, context_snapshot$loaded_object)) {
        recluster_new_data$confirmed_plot_context_key <- ""
        .db_dbg(
          "transition_flush_not_ready",
          sprintf(
            "revision=%d active=%s loaded=%s object_ready=%s plot_data_ready=%s",
            revision,
            context_snapshot$active_object,
            context_snapshot$loaded_object,
            as.character(isTRUE(context_snapshot$object_ready)),
            as.character(isTRUE(context_snapshot$plot_data_ready))
          )
        )
        .recluster_new_overlay_cancel("context_not_ready")
        return(invisible(NULL))
      }
      # The loaded-object observer may have run while syncing was still TRUE
      # and was therefore required to reject its event. Hydrate every gene
      # catalog only after this exact revision becomes settled; otherwise a
      # workspace/object switch can leave the three RGB controls bound but
      # visibly empty until an unrelated control change happens.
      isolate({
        .sync_assay_gene_inputs(force = TRUE)
        .sync_rule_assay_gene_inputs(force = TRUE)
      })
      expr_ui_revision <- suppressWarnings(as.integer(isolate(recluster_new_data$expr_ui_render_revision) %||% 0L))
      if (!is.finite(expr_ui_revision) || is.na(expr_ui_revision) || expr_ui_revision < 0L) expr_ui_revision <- 0L
      recluster_new_data$expr_ui_render_revision <- expr_ui_revision + 1L
      confirmed_key <- .recluster_new_expected_plot_context_key(
        active_name = context_snapshot$active_object,
        loaded_name = context_snapshot$loaded_object,
        revision = revision
      )
      if (!nzchar(confirmed_key)) {
        recluster_new_data$confirmed_plot_context_key <- ""
        .db_dbg("transition_flush_not_confirmed", sprintf("revision=%d active=%s", revision, context_snapshot$active_object))
        .recluster_new_overlay_cancel("context_not_confirmed")
        return(invisible(NULL))
      }
      recluster_new_data$confirmed_plot_context_key <- confirmed_key
      .db_dbg("plot_context_confirmed", sprintf("revision=%d key=%s", revision, confirmed_key))
      .db_dbg("object_context_settled", sprintf("revision=%d active=%s", revision, context_snapshot$active_object))
      .recluster_new_overlay_show_plot(message, tab_now = tab_now)
      invisible(NULL)
      })
    }, once = TRUE)
    invisible(NULL)
  }

  .load_active_recluster_new_object <- function(active_name, settle_message = "Loading selected dataset plot...") {
    transition_revision <- .recluster_new_begin_object_transition(.scalar_chr(active_name, default = ""))
    transition_tab <- .scalar_chr(isolate(input$recluster_new_tabs), default = "umap")
    recluster_new_dataset_syncing(TRUE)
    owns_loading_state <- !isTRUE(recluster_new_object_loading())
    if (owns_loading_state) recluster_new_object_loading(TRUE)
    if (owns_loading_state) on.exit(recluster_new_object_loading(FALSE), add = TRUE)
    on.exit(
      .recluster_new_schedule_context_settle(
        transition_revision,
        message = settle_message,
        tab_now = transition_tab
      ),
      add = TRUE
    )
    # Object-scoped dialogs/results cannot cross a context boundary. Clear
    # them before any new object-derived UI is allowed to settle.
    session$userData$recluster_new_expr_group_name_context <- NULL
    session$userData$recluster_new_metadata_palette_context <- NULL
    session$userData$recluster_new_metadata_single_color_context <- NULL
    session$userData$recluster_new_metadata_rename_history <- list()
    try(removeModal(), silent = TRUE)
    .clear_gene_value_cache()
    .clear_viz_controls_cache()
    rm(list = ls(envir = .metadata_level_checked_state, all.names = TRUE), envir = .metadata_level_checked_state)
    # Object-scoped workflows cannot survive an object transition. Clear
    # pending match/subset transactions before loading new canonical data;
    # their dialogs/tables otherwise retain cell IDs from the old object.
    recluster_new_pending_population_cells(character(0))
    recluster_new_pending_population_object("")
    recluster_new_pending_population_revision(NA_integer_)
    recluster_new_import_match_object("")
    recluster_new_import_match_revision(NA_integer_)
    .import_match(data.frame())
    recluster_new_latest_import(data.frame())
    .pseudobulk_table_data(NULL)
    final_cell_count_text(paste(RECLUSTER_NEW_UI_TEXT$t_text_selected_total, 0L, "cells"))
    umap_plot_rendered(NULL)
    violin_plot_rendered(NULL)
    recluster_new_data$metadata_hover_active <- FALSE
    recluster_new_data$expr_active_range_data_revision <-
      as.integer(recluster_new_data$expr_active_range_data_revision %||% 0L) + 1L
    recluster_new_data$metadata_filter_data_revision <-
      as.integer(recluster_new_data$metadata_filter_data_revision %||% 0L) + 1L
    active_name <- .scalar_chr(active_name, default = "")
    # Selection and view state cannot cross object boundaries. Reset source
    # state before loading the next canonical object, then derive expression
    # owner from that object's persisted expression state below.
    lasso_selected_cells_state(character(0))
    rule_lasso_cells_state(character(0))
    selection_owner_state("none")
    recluster_new_data$rule_meta_choices_sig <- ""
    recluster_new_data$tcr_choices_sig <- ""
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
      recluster_new_load_failure_source_signature("")
      recluster_new_data$seurat_obj <- NULL
      recluster_new_data$plot_df <- NULL
      .set_cell_groups_structure(list(), object_name = active_name)
      recluster_new_data$selected_cells <- character(0)
      recluster_new_data$imported_barcode_sources <- character(0)
      recluster_new_data$metadata_profiles <- list()
      recluster_new_data$metadata_selector_structure_key <- ""
      recluster_new_data$metadata_active_column <- ""
      recluster_new_data$metadata_active_cells <- character(0)
      recluster_new_data$metadata_filter_state <- "all"
      recluster_new_data$metadata_filter_definition_signature <- ""
      recluster_new_data$expr_selection <- .expr_default_state()
      .expr_bound_inputs(character(0))
      recluster_new_data$expr_ui_structure_key <- ""
      recluster_new_data$expr_active_range_structure_key <- ""
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
      failure_signature <- .recluster_new_load_source_signature(active_name)
      recluster_new_load_failure_source_signature(failure_signature)
      .db_dbg(
        "load_object_terminal_failure",
        sprintf("active=%s source=%s reason=invalid_seurat", active_name, failure_signature)
      )
      recluster_new_data$seurat_obj <- NULL
      recluster_new_data$plot_df <- NULL
      .set_cell_groups_structure(list(), object_name = active_name)
      recluster_new_data$selected_cells <- character(0)
      recluster_new_data$imported_barcode_sources <- character(0)
      recluster_new_data$metadata_profiles <- list()
      recluster_new_data$metadata_selector_structure_key <- ""
      recluster_new_data$metadata_active_column <- ""
      recluster_new_data$metadata_active_cells <- character(0)
      recluster_new_data$metadata_filter_state <- "all"
      recluster_new_data$metadata_filter_definition_signature <- ""
      recluster_new_data$expr_selection <- .expr_default_state()
      .expr_bound_inputs(character(0))
      recluster_new_data$expr_ui_structure_key <- ""
      recluster_new_data$expr_active_range_structure_key <- ""
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
      failure_signature <- .recluster_new_load_source_signature(active_name)
      recluster_new_load_failure_source_signature(failure_signature)
      .db_dbg(
        "load_object_terminal_failure",
        sprintf("active=%s source=%s reason=no_reduction", active_name, failure_signature)
      )
      recluster_new_data$seurat_obj <- NULL
      recluster_new_data$plot_df <- NULL
      .set_cell_groups_structure(list(), object_name = active_name)
      recluster_new_data$selected_cells <- character(0)
      recluster_new_data$imported_barcode_sources <- character(0)
      recluster_new_data$metadata_profiles <- list()
      recluster_new_data$metadata_selector_structure_key <- ""
      recluster_new_data$metadata_active_column <- ""
      recluster_new_data$metadata_active_cells <- character(0)
      recluster_new_data$metadata_filter_state <- "all"
      recluster_new_data$metadata_filter_definition_signature <- ""
      recluster_new_data$expr_selection <- .expr_default_state()
      .expr_bound_inputs(character(0))
      recluster_new_data$expr_ui_structure_key <- ""
      recluster_new_data$expr_active_range_structure_key <- ""
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

    visual_settings_loaded <- .visual_settings_store_get(obj)
    assay_choices_loaded <- .safe_assay_choices(obj)
    stored_umap_assay <- .scalar_chr(visual_settings_loaded$umap_assay_choice, default = "")
    assay_to_use <- if (nzchar(stored_umap_assay) && stored_umap_assay %in% assay_choices_loaded) {
      stored_umap_assay
    } else {
      .preferred_assay_choice(obj)
    }
    stored_rule_assay <- .scalar_chr(visual_settings_loaded$rule_assay_choice, default = "")
    rule_assay_to_use <- if (nzchar(stored_rule_assay) && stored_rule_assay %in% assay_choices_loaded) {
      stored_rule_assay
    } else {
      assay_to_use
    }
    # Read object-owned expression state before any metadata cleanup can write
    # this object back. This matters when workspace import replaces an object
    # under the same name while this page still has an older local object.
    expr_state_loaded <- .expr_store_get(obj)
    saved_groups_loaded <- .saved_group_store_get(obj)
    # Agent note: Saved-group membership persists, but enabled checkboxes are
    # landing-only selection state. Start every object landing unchecked so a
    # stale prior selection cannot repaint UMAP without new user intent.
    saved_groups_loaded <- lapply(saved_groups_loaded, function(group) {
      group$enabled <- FALSE
      group
    })
    saved_groups_loaded <- .saved_group_state_normalize(saved_groups_loaded, obj = obj)
    # Normalize legacy objects into their object-owned slots during load. A
    # workspace may import only this object, so waiting for a later group edit
    # would lose the migrated state when the user switches away immediately.
    obj <- .expr_store_set(obj, expr_state_loaded)
    obj <- .saved_group_store_set(obj, saved_groups_loaded)
    recluster_new_data$expr_selection <- expr_state_loaded
    .expr_bound_inputs(character(0))
    recluster_new_data$expr_ui_structure_key <- .expr_ui_structure_key(expr_state_loaded, active_name, assay_to_use)
    recluster_new_data$expr_active_range_structure_key <- .expr_active_range_structure_key(
      expr_state_loaded,
      active_name,
      assay_to_use
    )

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
    recluster_new_load_failure_source_signature("")
    # This is still inside object-load transaction. The generic persistence
    # helper intentionally resolves through loaded_object_name, which still
    # names the previous object until the transaction commits. Write the
    # complete normalized object explicitly to active_name so incoming data
    # can never overwrite the previous object's registry slot.
    active_entry <- shared_data$all_seurat_objects[[active_name]]
    if (is.list(active_entry) && !is.null(active_entry$obj)) {
      active_entry$obj <- obj
    } else {
      active_entry <- obj
    }
    shared_data$all_seurat_objects[[active_name]] <- active_entry
    if (ncol(md) < md_ncol_before) {
      .db_dbg(
        "load_object_cleanup_persisted",
        sprintf("active=%s removed_mirror_columns=%d", active_name, md_ncol_before - ncol(md))
      )
    }
    recluster_new_data$plot_df <- plot_df
    .set_cell_groups_structure(saved_groups_loaded, object_name = active_name)
    recluster_new_data$selected_cells <- character(0)
    recluster_new_data$imported_barcode_sources <- character(0)
    recluster_new_data$metadata_profiles <- profiles
    recluster_new_data$metadata_selector_structure_key <- .metadata_selector_structure_key(profiles, active_name)
    recluster_new_data$metadata_active_column <- ""
    recluster_new_data$metadata_active_cells <- character(0)
    recluster_new_data$metadata_filter_state <- "all"
    recluster_new_data$metadata_filter_definition_signature <- ""
    recluster_new_data$metadata_open_column <- default_open_col
    recluster_new_data$metadata_open_bucket <- if (nzchar(default_open_col)) .scalar_chr(bucket_map[[default_open_col]], default = "cluster") else "cluster"
    if (nzchar(.scalar_chr(expr_state_loaded$active_group_id, default = ""))) {
      selection_owner_state("expression")
    }
    .db_dbg(
      "selection_owner_load",
      sprintf(
        "object=%s expr_active=%s enabled_saved_groups=%d owner=%s",
        active_name,
        .scalar_chr(expr_state_loaded$active_group_id, default = ""),
        sum(vapply(saved_groups_loaded, function(group) {
          is.list(group) && isTRUE(group$enabled) && length(group$cells %||% character(0)) > 0L
        }, logical(1))),
        .scalar_chr(selection_owner_state(), default = "none")
      )
    )
    recluster_new_data$rule_definitions <- list()
    recluster_new_data$rule_active_cells <- character(0)
    recluster_new_data$rule_overlap_group <- NULL
    recluster_new_data$rule_selected_group <- "All"
    recluster_new_data$rule_manual_combine_mode <- "union"
    recluster_new_data$debug_rule_overlap_state <- ""
    recluster_new_data$last_load_status <- ""

    default_color <- if (nzchar(default_open_col)) default_open_col else "None"
    stored_genes <- as.character(visual_settings_loaded$umap_gene_values %||% c("", "", ""))
    length(stored_genes) <- 3L
    stored_genes[is.na(stored_genes)] <- ""
    all_genes_for_state <- .assay_feature_names(obj, assay_to_use)
    stored_genes <- vapply(stored_genes, function(gene) {
      hit <- all_genes_for_state[tolower(all_genes_for_state) == tolower(trimws(gene))]
      if (length(hit)) hit[[1L]] else ""
    }, character(1))
    stored_display_mode <- .scalar_chr(visual_settings_loaded$umap_display_mode, default = "metadata")
    if (!(stored_display_mode %in% c("metadata", "gene"))) stored_display_mode <- "metadata"
    stored_color <- .scalar_chr(visual_settings_loaded$umap_color_choice, default = "")
    color_choices_loaded <- c("Single Gene Expression", available_cols, "None")
    if (identical(stored_display_mode, "gene") && length(unique(stored_genes[nzchar(stored_genes)]))) {
      stored_color <- "Single Gene Expression"
    } else {
      stored_display_mode <- "metadata"
      if (!nzchar(stored_color) || !(stored_color %in% color_choices_loaded) || identical(stored_color, "Single Gene Expression")) {
        stored_color <- default_color
      }
    }
    recluster_new_data$umap_gene_values <- stored_genes
    recluster_new_data$umap_display_mode <- stored_display_mode
    .set_umap_color_choice(
      stored_color,
      choices = color_choices_loaded,
      update_ui = FALSE,
      persist = FALSE
    )
    reduction_choices_loaded <- .embedding_reduction_choices(obj)
    stored_umap_reduction <- .scalar_chr(visual_settings_loaded$umap_reduction_choice, default = "")
    red_sel <- if (nzchar(stored_umap_reduction) && stored_umap_reduction %in% reduction_choices_loaded) {
      stored_umap_reduction
    } else {
      .preferred_embedding_reduction(obj, entry = entry)
    }
    stored_rule_reduction <- .scalar_chr(visual_settings_loaded$rule_reduction_choice, default = "")
    rule_red_sel <- if (nzchar(stored_rule_reduction) && stored_rule_reduction %in% reduction_choices_loaded) {
      stored_rule_reduction
    } else {
      red_sel
    }
    recluster_new_data$umap_assay_choice <- assay_to_use
    recluster_new_data$rule_assay_choice <- rule_assay_to_use
    recluster_new_data$umap_reduction_choice <- red_sel
    recluster_new_data$rule_reduction_choice <- rule_red_sel

    inherit_population_target <- isTRUE(recluster_new_data$expr_selection$inherit_population %||% TRUE)
    if (!identical(isTRUE(input$recluster_new_expr_limit_population), inherit_population_target)) {
      updateCheckboxInput(session, "recluster_new_expr_limit_population", value = inherit_population_target)
    }
    recluster_new_loaded_object_name(active_name)
    # Existing mounted controls receive restored checked/open/active state
    # without synthesizing Shiny input events.
    .expr_send_state_to_ui(expr_state_loaded)
    recluster_new_data$viz_controls_structure_key <- .viz_controls_structure_key(obj, active_name)
    .db_dbg(
      "load_object_done",
      sprintf(
        "active=%s reductions=%d metadata_cols=%d assay=%s slot=data red=%s expr_groups=%d expr_active=%s",
        active_name,
        length(reduction_choices),
        length(available_cols),
        assay_to_use,
        red_sel,
        length(expr_state_loaded$groups %||% list()),
        .scalar_chr(expr_state_loaded$active_group_id, default = "")
      )
    )
    invisible(NULL)
  }

  output$recluster_new_expression_groups_ui <- renderUI({
    # Read before the settled check so this output is invalidated by the
    # explicit post-settlement render transaction, including when the output
    # was initially suspended by a hidden navbar page.
    ui_render_revision <- recluster_new_data$expr_ui_render_revision
    if (!.recluster_new_context_is_settled()) return(NULL)
    # Structure key is sole reactive dependency. Checkbox, active-gene, and
    # open-state changes update existing DOM through custom messages; replacing
    # this tree for every value change recreates inputs and causes feedback.
    structure_key <- recluster_new_data$expr_ui_structure_key
    staged_ui <- is.list(isolate(recluster_new_data$expr_ui_staged_state))
    state <- .expr_state_normalize(.expr_ui_render_state())
    object_name_now <- .recluster_new_canonical_object_name()
    groups <- state$groups %||% list()
    .db_dbg(
      "expression_groups_ui_render",
      sprintf(
        "object=%s context_revision=%d ui_revision=%s groups=%d",
        object_name_now,
        .recluster_new_context_revision(),
        as.character(ui_render_revision),
        length(groups)
      )
    )
    if (!length(groups)) {
      return(
        div(
          class = "recluster-new-expression-state-root",
          `data-recluster-object-context` = object_name_now,
          `data-recluster-object-context-revision` = .recluster_new_context_revision(),
          div(class = "app-secondary-status", RECLUSTER_NEW_UI_TEXT$t_text_expr_no_groups),
          div(class = "recluster-new-expr-range app-secondary-status", RECLUSTER_NEW_UI_TEXT$t_text_expr_select_gene_range)
        )
      )
    }

    obj_now <- isolate(recluster_new_data$seurat_obj)
    assay_now <- isolate(.expr_assay_name(obj_now))
    genes_now <- if (!is.null(obj_now) && inherits(obj_now, "Seurat")) {
      .assay_feature_names(obj_now, assay_now)
    } else {
      character(0)
    }
    .db_dbg(
      "expression_gene_catalog",
      sprintf(
        "object=%s context_revision=%d assay=%s genes=%d groups=%d",
        object_name_now,
        .recluster_new_context_revision(),
        assay_now,
        length(genes_now),
        length(groups)
      )
    )
    expr_base_cells <- isolate(if (!is.null(obj_now) && inherits(obj_now, "Seurat")) {
      if (isTRUE(state$inherit_population)) .expr_base_population_cells() else colnames(obj_now)
    } else {
      character(0)
    })
    group_cells_by_id <- if (isTRUE(staged_ui)) {
      list()
    } else {
      isolate(expression_group_cells_result()$group_cells %||% list())
    }

    active_gid <- if (identical(.scalar_chr(isolate(selection_owner_state()), default = "none"), "expression")) {
      .scalar_chr(state$active_group_id, default = "")
    } else {
      ""
    }
    group_nodes <- lapply(groups, function(g) {
      gid <- .scalar_chr(g$id, default = "")
      genes <- g$genes %||% list()
      checked_n <- sum(vapply(genes, function(gr) isTRUE(gr$checked), logical(1)))
      group_cells <- as.character(group_cells_by_id[[gid]] %||% character(0))
      summary_txt <- if (isTRUE(staged_ui)) {
        "Calculating..."
      } else if (length(genes)) {
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
          gene_count_txt <- if (isTRUE(staged_ui)) {
            "Calculating..."
          } else {
            gene_cells <- isolate(.expr_gene_cells(gr, expr_base_cells, obj = obj_now))
            sprintf("%d cells", length(gene_cells))
          }
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
                div(
                  class = "recluster-new-expr-gene-count",
                  `data-expr-gene-count-id` = .expr_gene_detail_id(gid, gene_id),
                  gene_count_txt
                )
              ),
              div(
                class = "recluster-new-expr-gene-note",
                `data-expr-gene-note-id` = .expr_gene_detail_id(gid, gene_id),
                .expr_format_range(gr$range)
              )
            ),
            div(
              class = "recluster-new-expr-gene-actions",
              actionButton(
                .expr_gene_delete_input_id(gid, gene_id),
                label = NULL,
                icon = icon("trash"),
                class = "btn btn-outline-danger btn-xs",
                `data-expr-delete-group-id` = gid,
                `data-expr-delete-gene-id` = gene_id
              )
            )
          )
        })
      }
        tags$details(
          class = paste(
            "recluster-new-expr-group app-accordion",
            if (nzchar(active_gid) && identical(gid, active_gid)) "is-violet-highlight-source" else ""
          ),
          `data-expr-group-id` = gid,
          `data-accordion-group` = "recluster-new-expr-groups",
          open = if (isTRUE(g$open)) NA else NULL,
                tags$summary(
                  span(
                    class = "recluster-new-expr-group-title",
                    title = "Click to open group",
                    .scalar_chr(g$name, default = "Expression group")
                  ),
                  span(class = "recluster-new-expr-group-summary", `data-expr-summary-id` = gid, summary_txt),
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
            wl_gene_selectize_input(
              .expr_group_add_gene_input_id(gid),
              RECLUSTER_NEW_UI_TEXT$t_label_expr_add_gene,
              selected = character(0),
              placeholder = "Type to search gene",
              width = "100%",
              min_chars = 0L,
              open_on_focus = TRUE,
              preload = TRUE,
              choices = genes_now,
              defer_choices = TRUE
            )
          )
        )
      )
    })

    add_gene_ids <- vapply(
      groups,
      function(g) .expr_group_add_gene_input_id(.scalar_chr(g$id, default = "")),
      character(1)
    )
    add_gene_ids <- add_gene_ids[nzchar(add_gene_ids)]
    .schedule_gene_selectize_hydration(
      add_gene_ids,
      genes_now,
      object_name_now,
      .recluster_new_context_revision(),
      source = "expression_groups_ui"
    )

    div(
      class = "recluster-new-expression-state-root",
      `data-recluster-object-context` = object_name_now,
      `data-recluster-object-context-revision` = .recluster_new_context_revision(),
      tagList(group_nodes, uiOutput("recluster_new_expr_active_range_ui"))
    )
  })

  outputOptions(output, "recluster_new_expression_groups_ui", suspendWhenHidden = FALSE)

  output$recluster_new_expr_active_range_ui <- renderUI({
    # This revision increments only after the exact object transition settles.
    # It invalidates a range UI that previously returned NULL while its parent
    # output was hidden or still loading, without polling or delayed retries.
    post_settlement_revision <- recluster_new_data$expr_ui_render_revision
    if (!.recluster_new_context_is_settled()) return(NULL)
    # Active gene/object/assay changes rebuild this structure. Range and
    # population value changes update the mounted slider/plot without remounting
    # Shiny inputs, preventing value-only feedback loops.
    structure_key <- recluster_new_data$expr_active_range_structure_key
    data_revision <- recluster_new_data$expr_active_range_data_revision
    render_key <- paste(
      structure_key,
      as.character(data_revision %||% 0L),
      as.character(post_settlement_revision %||% 0L),
      sep = "::"
    )
    if (!nzchar(render_key)) return(NULL)
    state <- .expr_state_normalize(.expr_ui_render_state())
    active <- .expr_active_gene(state)
    if (is.null(active)) {
      return(div(class = "recluster-new-expr-range app-secondary-status", RECLUSTER_NEW_UI_TEXT$t_text_expr_select_gene_range))
    }
    # Metadata/palette writes replace local Seurat object identity but do not
    # change expression values. Keep this UI mounted until object load or
    # active assay/gene structure explicitly changes.
    obj <- isolate(recluster_new_data$seurat_obj)
    req(obj)
    assay_now <- .expr_assay_name(obj)
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
    display_rng <- .expr_distribution_display_range(full_rng)
    cur <- suppressWarnings(as.numeric(active$range %||% range_info$default_range))
    if (length(cur) != 2L || any(!is.finite(cur))) cur <- range_info$default_range
    cur[[1]] <- max(full_rng[[1]], min(cur[[1]], full_rng[[2]]))
    cur[[2]] <- max(cur[[1]], min(cur[[2]], full_rng[[2]]))
    # Keep full-precision numeric values here. Label formatting and endpoint
    # alignment are applied after the slider input binding is initialized.
    expr_range_slider <- sliderInput(
      "recluster_new_expr_active_range",
      label = NULL,
      min = display_rng[[1]],
      max = display_rng[[2]],
      value = cur,
      step = signif(diff(display_rng) / 200, 3)
    )
    expr_range_slider <- htmltools::tagQuery(expr_range_slider)$
      find("input#recluster_new_expr_active_range")$
      addAttrs(`data-force-edges` = "true")$
      allTags()
    div(
      class = "recluster-new-expr-range",
      div(
        class = "recluster-new-expr-distribution",
        plotlyOutput("recluster_new_expr_active_distribution", height = "148px", width = "100%")
      ),
      expr_range_slider,
      if (is.finite(range_info$min_nonzero)) {
        div(
          class = "recluster-new-expr-range-hint",
          sprintf("minimum non-zero: %s", signif(range_info$min_nonzero, 4))
        )
      }
    )
  })

  outputOptions(output, "recluster_new_expr_active_range_ui", suspendWhenHidden = FALSE)

  .empty_expr_distribution_plot <- function() {
    # Keep pre-settlement output schema-valid. A layout-only widget causes
    # Plotly to emit a missing-trace warning before the object context settles.
    plotly::plot_ly() %>%
      plotly::add_trace(
        x = numeric(0),
        y = numeric(0),
        type = "scatter",
        mode = "markers",
        hoverinfo = "skip",
        showlegend = FALSE
      ) %>%
      plotly::layout(
        xaxis = list(visible = FALSE),
        yaxis = list(visible = FALSE),
        margin = list(l = 0, r = 0, t = 0, b = 0),
        plot_bgcolor = "#ffffff",
        paper_bgcolor = "#ffffff"
      ) %>%
      plotly::config(
        # Agent note: tool suppression belongs only to this expression-range
        # distribution. Never move it into shared interactive Plotly helpers.
        displayModeBar = FALSE,
        scrollZoom = FALSE,
        doubleClick = FALSE,
        staticPlot = TRUE,
        responsive = TRUE
      )
  }

  output$recluster_new_expr_active_distribution <- renderPlotly({
    # Force one render after object-context settlement when the initial
    # placeholder was evaluated before the active gene became available.
    post_settlement_revision <- recluster_new_data$expr_ui_render_revision
    range_structure_key <- recluster_new_data$expr_active_range_structure_key
    range_data_revision <- recluster_new_data$expr_active_range_data_revision
    confirmed_context_key <- recluster_new_data$confirmed_plot_context_key
    expression_state_signal <- recluster_new_data$expr_selection
    expression_render_key <- paste(
      as.character(post_settlement_revision %||% 0L),
      .scalar_chr(range_structure_key, default = ""),
      as.character(range_data_revision %||% 0L),
      .scalar_chr(confirmed_context_key, default = ""),
      sep = "::"
    )
    if (!nzchar(expression_render_key)) return(.empty_expr_distribution_plot())
    if (!.recluster_new_context_is_settled()) return(.empty_expr_distribution_plot())
    state <- .expr_state_normalize(expression_state_signal)
    active <- .expr_active_gene(state)
    obj <- recluster_new_data$seurat_obj
    if (is.null(active) || is.null(obj) || !inherits(obj, "Seurat")) {
      return(.empty_expr_distribution_plot())
    }

    vals <- .fetch_gene_values(
      obj,
      .expr_assay_name(obj),
      active$gene,
      .expr_selection_slot()
    )
    if (is.null(vals) || !length(vals)) return(.empty_expr_distribution_plot())

    all_vals <- vals[is.finite(vals)]
    full_rng <- range(all_vals, na.rm = TRUE)
    if (!all(is.finite(full_rng)) || full_rng[[1]] >= full_rng[[2]]) {
      return(.empty_expr_distribution_plot())
    }
    base_cells <- if (isTRUE(state$inherit_population)) .expr_base_population_cells() else colnames(obj)
    vals <- vals[intersect(base_cells, names(vals))]
    vals <- vals[is.finite(vals)]
    if (!length(vals)) return(.empty_expr_distribution_plot())
    .db_dbg(
      "expression_distribution_data",
      sprintf(
        "object=%s gene=%s all_cells=%d plotted_cells=%d zero_cells=%d range=%s",
        .recluster_new_canonical_object_name(),
        active$gene,
        length(all_vals),
        length(vals),
        sum(vals == 0),
        paste(signif(full_rng, 5), collapse = "-")
      )
    )

    display_rng <- .expr_distribution_display_range(full_rng)
    cur <- suppressWarnings(as.numeric(active$range %||% full_rng))
    cur <- cur[is.finite(cur)]
    if (length(cur) < 2L) cur <- full_rng
    cur <- sort(cur[seq_len(2L)])
    cur[[1]] <- max(full_rng[[1]], min(cur[[1]], full_rng[[2]]))
    cur[[2]] <- max(cur[[1]], min(cur[[2]], full_rng[[2]]))

    # Match QC's horizontal violin contract: expression runs on x, a smooth
    # density envelope rises above the x-axis, and every cell is a
    # deterministic rug dot at the baseline. Keep a small display-only x
    # domain below zero so the kernel tail is not cut at the data boundary and
    # the zero tick shares the same coordinate as the slider.
    density_grid <- seq(display_rng[[1]], display_rng[[2]], length.out = 1024L)
    density_from_values <- function(values, grid) {
      values <- as.numeric(values)
      values <- values[is.finite(values)]
      if (!length(values)) return(numeric(length(grid)))
      if (length(unique(values)) < 2L) {
        bandwidth <- max(
          diff(range(grid)) / 128,
          if (length(grid) > 1L) diff(grid)[[1L]] * 2 else 1e-6
        )
        return(exp(-0.5 * ((grid - values[[1L]]) / bandwidth)^2))
      }
      estimate <- stats::density(
        values,
        from = grid[[1L]],
        to = grid[[length(grid)]],
        n = length(grid),
        cut = 0,
        kernel = "gaussian",
        # Agent note: Keep local expression-distribution structure visible;
        # stronger smoothing can imply cutoffs unsupported by cell density.
        adjust = 0.8,
        na.rm = TRUE
      )
      if (length(estimate$y) != length(grid) || any(!is.finite(estimate$y))) {
        return(numeric(length(grid)))
      }
      pmax(as.numeric(estimate$y), 0)
    }
    density_width <- density_from_values(vals, density_grid)
    selected_mask <- vals >= cur[[1]] & vals <= cur[[2]]
    selected_vals <- vals[selected_mask]
    selected_width <- density_from_values(selected_vals, density_grid)
    max_density_width <- max(c(density_width, selected_width), na.rm = TRUE)
    if (!is.finite(max_density_width) || max_density_width <= 0) max_density_width <- 1
    # Tied values (especially zeros) otherwise occupy the same seven lanes and
    # look under-counted. Keep raw values in `value`; `plot_value` is a small,
    # deterministic display-only tie jitter for visible dot separation.
    dot_band <- max(1.4, max_density_width * 0.48)
    dot_lane_count <- max(24L, min(48L, ceiling(sqrt(length(vals)) * 1.8)))
    dot_y <- dot_band * (
      0.04 + (((seq_along(vals) - 1L) %% dot_lane_count) /
        max(1, dot_lane_count - 1L)) * 0.92
    )
    value_rank <- ave(seq_along(vals), vals, FUN = seq_along)
    value_count <- ave(seq_along(vals), vals, FUN = length)
    tie_unit <- ((value_rank - 1L) %% 11L) / 10 - 0.5
    tie_jitter <- ifelse(value_count > 1L, tie_unit, 0)
    at_left_edge <- vals == full_rng[[1]]
    at_right_edge <- vals == full_rng[[2]]
    tie_jitter <- ifelse(at_left_edge, abs(tie_jitter), tie_jitter)
    tie_jitter <- ifelse(at_right_edge, -abs(tie_jitter), tie_jitter)
    jitter_span <- diff(full_rng) * 0.018
    plot_values <- pmax(
      full_rng[[1]],
      pmin(full_rng[[2]], vals + tie_jitter * jitter_span)
    )
    density_df <- data.frame(
      value = as.numeric(density_grid),
      width = as.numeric(density_width),
      stringsAsFactors = FALSE
    )
    selected_density_df <- data.frame(
      value = as.numeric(density_grid),
      width = as.numeric(selected_width),
      stringsAsFactors = FALSE
    )
    dot_df <- data.frame(
      value = as.numeric(vals),
      plot_value = as.numeric(plot_values),
      y = as.numeric(dot_y),
      selected = selected_mask,
      stringsAsFactors = FALSE
    )
    dot_unselected_df <- dot_df[!dot_df$selected, c("plot_value", "y"), drop = FALSE]
    dot_selected_df <- dot_df[dot_df$selected, c("plot_value", "y"), drop = FALSE]
    .db_dbg(
      "expression_distribution_violin",
      sprintf(
        "grid_points=%d density_peak=%.3f selected=%d dots=%d",
        nrow(density_df),
        max_density_width,
        sum(selected_mask),
        nrow(dot_df)
      )
    )
    plot_y_max <- max(max_density_width * 1.12, dot_band * 1.2)
    zero_shape <- if (display_rng[[1]] < 0 && display_rng[[2]] > 0) {
      list(list(
        type = "line",
        xref = "x",
        yref = "y",
        x0 = 0,
        x1 = 0,
        y0 = 0,
        y1 = plot_y_max,
        line = list(color = "#94a3b8", dash = "dot", width = 1),
        layer = "below"
      ))
    } else {
      list()
    }
    cutoff_shapes <- list(
      list(
        name = "expr-lower-cutoff",
        type = "line",
        xref = "x",
        yref = "y",
        x0 = cur[[1]],
        x1 = cur[[1]],
        y0 = 0,
        y1 = plot_y_max,
        line = list(color = "#2F80B7", dash = "dash", width = 1),
        layer = "above"
      ),
      list(
        name = "expr-upper-cutoff",
        type = "line",
        xref = "x",
        yref = "y",
        x0 = cur[[2]],
        x1 = cur[[2]],
        y0 = 0,
        y1 = plot_y_max,
        line = list(color = "#2F80B7", dash = "dash", width = 1),
        layer = "above"
      )
    )

    p <- plotly::plot_ly() %>%
      plotly::add_trace(
        data = density_df,
        x = ~value,
        y = ~width,
        type = "scatter",
        mode = "lines",
        fill = "tozeroy",
        line = list(color = "#69B3E7", width = 1.2),
        fillcolor = "rgba(105,179,231,0.28)",
        hoverinfo = "skip",
        showlegend = FALSE,
        inherit = FALSE
      )
    if (any(selected_width > 0)) {
      p <- p %>% plotly::add_trace(
        data = selected_density_df,
        x = ~value,
        y = ~width,
        type = "scatter",
        mode = "lines",
        fill = "tozeroy",
        line = list(color = "#2F80B7", width = 1.1),
        fillcolor = "rgba(47,128,183,0.24)",
        hoverinfo = "skip",
        showlegend = FALSE,
        inherit = FALSE
      )
    }
    if (nrow(dot_unselected_df)) {
      p <- p %>% plotly::add_trace(
        data = dot_unselected_df,
        x = ~plot_value,
        y = ~y,
        # This compact chart is intentionally SVG-only. Full cell-level data
        # remains present, while avoiding a WebGL layer that can cover the
        # horizontal density trace in a static, height-constrained widget.
        type = "scatter",
        mode = "markers",
        marker = list(color = "rgba(47,128,183,0.42)", size = 2),
        hoverinfo = "skip",
        showlegend = FALSE,
        inherit = FALSE
      )
    }
    if (nrow(dot_selected_df)) {
      p <- p %>% plotly::add_trace(
        data = dot_selected_df,
        x = ~plot_value,
        y = ~y,
        type = "scatter",
        mode = "markers",
        marker = list(color = "#2F80B7", size = 2.25),
        hoverinfo = "skip",
        showlegend = FALSE,
        inherit = FALSE
      )
    }

    p %>%
      plotly::layout(
        xaxis = list(
          # Formula-mapped traces otherwise make Plotly infer an x/y title
          # from the data-frame column names. Slider owns visible values.
          title = "",
          range = display_rng,
          showgrid = FALSE,
          zeroline = FALSE,
          ticks = "",
          showticklabels = FALSE,
          nticks = 6L,
          automargin = FALSE,
          tickfont = list(size = 9)
        ),
        yaxis = list(
          title = "",
          range = c(-plot_y_max * 0.08, plot_y_max),
          showgrid = FALSE,
          showticklabels = FALSE,
          zeroline = FALSE
        ),
        annotations = list(list(
          text = sprintf("%s expression range", active$gene),
          x = 0.995,
          y = 0.93,
          xref = "paper",
          yref = "paper",
          xanchor = "right",
          yanchor = "top",
          align = "right",
          showarrow = FALSE,
          bgcolor = "rgba(255,255,255,0.72)",
          borderpad = 2,
          font = list(size = 12, color = "#6b7280")
        )),
        shapes = c(zero_shape, cutoff_shapes),
        # Zero plot margins are intentional: the plot and slider share the
        # same full-width range box, so their value endpoints stay aligned.
        # IonRangeSlider maps numeric values between handle centers, which are
        # inset by half the 20 px handle width from the visible rail edges.
        margin = list(l = 10, r = 10, t = 16, b = 8, pad = 0, autoexpand = FALSE),
        showlegend = FALSE,
        plot_bgcolor = "#ffffff",
        paper_bgcolor = "#ffffff"
      ) %>%
      plotly::config(
        # Agent note: this histogram is intentionally static. UMAP, scatter,
        # rule, TCR, and other Plotly outputs must retain their full toolbars.
        displayModeBar = FALSE,
        scrollZoom = FALSE,
        doubleClick = FALSE,
        staticPlot = TRUE,
        responsive = TRUE
      )
  })

  # The distribution is mounted dynamically inside an expression group. Keep
  # its server render alive while its parent details/card changes visibility so
  # first landing cannot retain the schema-valid empty placeholder.
  outputOptions(output, "recluster_new_expr_active_distribution", suspendWhenHidden = FALSE)

  observeEvent(input$recluster_new_expr_limit_population, {
    if (!.recluster_new_event_allowed("expr_limit_population")) return(invisible(NULL))
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    inherit_population <- isTRUE(input$recluster_new_expr_limit_population)
    if (identical(isTRUE(state$inherit_population), inherit_population)) {
      return(invisible(NULL))
    }
    state$inherit_population <- inherit_population
    if (nzchar(.scalar_chr(state$active_group_id, default = ""))) {
      .set_selection_owner("expression", "expr_population_limit")
    }
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

  .recluster_new_contextual_picker_footer <- function(reset_id, apply_id, apply_label, object_name, context_revision) {
    contextual_attrs <- list(
      class = "recluster-new-contextual-modal-action",
      `data-recluster-modal-object` = .scalar_chr(object_name, default = ""),
      `data-recluster-modal-revision` = as.character(context_revision %||% "")
    )
    append_attrs <- function(tag) {
      do.call(htmltools::tagAppendAttributes, c(list(tag), contextual_attrs))
    }
    tagList(
      append_attrs(actionButton(reset_id, "Reset", class = "btn btn-outline-secondary")),
      modalButton("Cancel"),
      append_attrs(actionButton(apply_id, apply_label, class = "btn btn-primary"))
    )
  }

  observeEvent(input$recluster_new_expr_add_group_btn, {
    if (!.recluster_new_event_allowed("expr_add_group")) return(invisible(NULL))
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    idx <- suppressWarnings(as.integer(state$next_group_index %||% 1L))
    if (!is.finite(idx) || is.na(idx) || idx < 1L) idx <- length(state$groups %||% list()) + 1L
    gid <- sprintf("g%03d", idx)
    default_name <- sprintf("Expression group %d", idx)
    state$groups[[length(state$groups %||% list()) + 1L]] <- list(
      id = gid,
      name = default_name,
      open = FALSE,
      require_all = FALSE,
      invert = FALSE,
      active_gene_id = "",
      genes = list()
    )
    state$next_group_index <- idx + 1L
    state <- .expr_set_active_group(state, gid)
    .set_selection_owner("expression", "expr_group_created")
    object_name <- .recluster_new_canonical_object_name()
    persisted <- !is.null(recluster_new_data$seurat_obj) &&
      inherits(recluster_new_data$seurat_obj, "Seurat") &&
      nzchar(object_name)
    .expr_set_state(state)
    .db_dbg(
      "expr_group_created",
      sprintf(
        "object=%s group=%s name=%s groups=%d persisted=%s",
        object_name,
        gid,
        default_name,
        length(state$groups %||% list()),
        as.character(persisted)
      )
    )
    session$userData$recluster_new_expr_group_name_context <- list(
      mode = "rename",
      group_id = gid,
      default_name = default_name,
      object_name = object_name,
      context_revision = .recluster_new_context_revision()
    )
    .show_expr_group_name_modal(
      title = RECLUSTER_NEW_UI_TEXT$t_btn_expr_add_group,
      value = default_name,
      placeholder = default_name
    )
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_expr_open_group, {
    if (!.recluster_new_event_allowed("expr_open_group")) return(invisible(NULL))
    request <- input$recluster_new_expr_open_group
    if (!is.list(request)) return(invisible(NULL))
    if (!.recluster_new_payload_context_matches(request)) return(invisible(NULL))
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
      .set_selection_owner("expression", "expr_group_open")
    } else {
      state$groups[[gi]]$open <- FALSE
    }
    .expr_set_state(state)
  }, ignoreInit = TRUE, priority = 1000)

  observeEvent(input$recluster_new_expr_active_range_commit, {
    if (!.recluster_new_event_allowed("expr_active_range")) return(invisible(NULL))
    request <- input$recluster_new_expr_active_range_commit
    if (!.recluster_new_payload_context_matches(request)) return(invisible(NULL))
    rng <- suppressWarnings(as.numeric(request$range %||% numeric(0)))
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
    .set_selection_owner("expression", "expr_range_commit")
    .db_dbg(
      "expr_range_commit",
      sprintf(
        "object=%s group=%s gene=%s range=%s",
        .recluster_new_canonical_object_name(),
        active$group_id,
        active$gene,
        paste(signif(sort(rng[seq_len(2L)]), 6), collapse = ",")
      )
    )
    .expr_set_state(state)
  }, ignoreInit = TRUE)

  # Agent note: Group headers are native details toggles; keep rename separate.
  # Dynamic rename modal events need explicit object context and nonces so every
  # group and repeated modal session remains deterministic.
  observeEvent(input$recluster_new_expr_group_rename, {
    if (!.recluster_new_event_allowed("expr_group_rename_open")) return(invisible(NULL))
    request <- input$recluster_new_expr_group_rename
    if (!is.list(request)) return(invisible(NULL))
    if (!.recluster_new_payload_context_matches(request)) return(invisible(NULL))
    gid <- .safe_key(.scalar_chr(request$group_id, default = ""))
    if (!nzchar(gid)) return(invisible(NULL))
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    gi <- .expr_group_index(state, gid)
    if (is.na(gi)) return(invisible(NULL))
    session$userData$recluster_new_expr_group_name_context <- list(
      mode = "rename",
      group_id = gid,
      default_name = sprintf("Expression group %d", gi),
      object_name = .recluster_new_canonical_object_name(),
      context_revision = .recluster_new_context_revision()
    )
    .show_expr_group_name_modal(
      title = RECLUSTER_NEW_UI_TEXT$t_btn_expr_rename_group,
      value = .scalar_chr(state$groups[[gi]]$name, default = "")
    )
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_expr_group_name_save, {
    if (!.recluster_new_event_allowed("expr_group_name_save")) return(invisible(NULL))
    save_request <- input$recluster_new_expr_group_name_save
    if (!is.list(save_request)) return(invisible(NULL))
    if (!.recluster_new_payload_context_matches(save_request)) return(invisible(NULL))
    context <- session$userData$recluster_new_expr_group_name_context
    if (!is.list(context)) return(invisible(NULL))
    mode <- .scalar_chr(context$mode, default = "")
    gid <- .safe_key(.scalar_chr(context$group_id, default = ""))
    if (!nzchar(gid)) return(invisible(NULL))
    context_object <- .scalar_chr(context$object_name, default = "")
    context_revision <- suppressWarnings(as.integer(context$context_revision %||% NA_integer_))
    current_revision <- .recluster_new_context_revision()
    current_object <- .recluster_new_canonical_object_name()
    active_object <- .scalar_chr(shared_data$active_object_name, default = "")
    wrong_active_object <- nzchar(active_object) && !identical(context_object, active_object)
    wrong_revision <- !is.finite(context_revision) || is.na(context_revision) || !identical(context_revision, current_revision)
    if (nzchar(context_object) && (!identical(context_object, current_object) || wrong_active_object || wrong_revision)) {
      .db_dbg(
        "expr_group_name_save_ignored_wrong_object",
        sprintf(
          "group=%s context_object=%s current_object=%s active_object=%s context_revision=%s current_revision=%s",
          gid,
          context_object,
          current_object,
          active_object,
          as.character(context_revision),
          as.character(current_revision)
        )
      )
      session$userData$recluster_new_expr_group_name_context <- NULL
      removeModal()
      return(invisible(NULL))
    }
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    nm <- trimws(.scalar_chr(save_request$name, default = ""))
    default_name <- .scalar_chr(context$default_name, default = "Expression group")
    name_to_use <- if (nzchar(nm)) nm else default_name
    if (identical(mode, "rename")) {
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
    if (!.recluster_new_event_allowed("expr_group_name_cancel")) return(invisible(NULL))
    cancel_request <- input$recluster_new_expr_group_name_cancel
    if (!is.list(cancel_request)) return(invisible(NULL))
    if (!.recluster_new_payload_context_matches(cancel_request)) return(invisible(NULL))
    session$userData$recluster_new_expr_group_name_context <- NULL
    removeModal()
  }, ignoreInit = TRUE)

  observeEvent(input[[.expr_gene_delete_event_id()]], {
    request <- input[[.expr_gene_delete_event_id()]]
    if (!is.list(request)) return(invisible(NULL))
    if (!.recluster_new_payload_context_matches(request)) {
      .db_dbg("expr_gene_delete_ignored_context", "payload context does not match current object")
      return(invisible(NULL))
    }
    gid <- .safe_key(.scalar_chr(request$group_id, default = ""))
    gene_id <- .safe_key(.scalar_chr(request$gene_id, default = ""))
    if (!nzchar(gid) || !nzchar(gene_id)) return(invisible(NULL))
    state2 <- .expr_state_normalize(recluster_new_data$expr_selection)
    gi <- .expr_group_index(state2, gid)
    if (is.na(gi)) return(invisible(NULL))
    gene_i <- .expr_gene_index(state2$groups[[gi]], gene_id)
    if (is.na(gene_i)) return(invisible(NULL))
    .db_dbg(
      "expr_gene_delete_received",
      sprintf("group=%s gene=%s", gid, gene_id)
    )
    state2$groups[[gi]]$genes[[gene_i]] <- NULL
    if (identical(
      .scalar_chr(state2$groups[[gi]]$active_gene_id, default = ""),
      gene_id
    )) state2$groups[[gi]]$active_gene_id <- ""
    active_gid2 <- .scalar_chr(state2$active_group_id, default = "")
    if (nzchar(active_gid2)) {
      .set_selection_owner("expression", paste0("expr_control:", .expr_gene_delete_event_id()))
    } else if (identical(.scalar_chr(selection_owner_state(), default = "none"), "expression")) {
      .set_selection_owner("none", paste0("expr_control:", .expr_gene_delete_event_id()))
    }
    .expr_set_state(state2)
  }, ignoreInit = TRUE, priority = 1000)

  observe({
    structure_key <- recluster_new_data$expr_ui_structure_key
    if (!nzchar(structure_key)) return(invisible(NULL))
    state <- .expr_state_normalize(isolate(recluster_new_data$expr_selection))
    groups <- state$groups %||% list()
    bound <- isolate(.expr_bound_inputs())
    next_bound <- bound
    for (g in groups) {
      gid <- .scalar_chr(g$id, default = "")
      if (!nzchar(gid)) next
      add_id <- .expr_group_add_gene_input_id(gid)
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
            stage_added_gene <- FALSE
            gi <- .expr_group_index(state2, gid_local)
            if (is.na(gi)) return(invisible(NULL))
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
            } else if (identical(id_local, .expr_group_add_gene_input_id(gid_local))) {
              gene <- trimws(.scalar_chr(input[[id_local]], default = ""))
              if (!nzchar(gene)) return(invisible(NULL))
              obj_now <- recluster_new_data$seurat_obj
              all_genes_now <- character(0)
              if (!is.null(obj_now) && inherits(obj_now, "Seurat")) {
                all_genes_now <- .assay_feature_names(obj_now, .expr_assay_name(obj_now))
              }
              existing <- vapply(state2$groups[[gi]]$genes %||% list(), function(gr) tolower(.scalar_chr(gr$gene, default = "")), character(1))
              if (tolower(gene) %in% existing) {
                .db_update_gene_selectize(id_local, all_genes_now, selected = character(0))
                return(invisible(NULL))
              }
              gene_idx <- suppressWarnings(as.integer(state2$next_gene_index %||% 1L))
              if (!is.finite(gene_idx) || is.na(gene_idx) || gene_idx < 1L) gene_idx <- 1L
              gene_id <- sprintf("ge%03d", gene_idx)
              default_range <- NULL
              if (!is.null(obj_now) && inherits(obj_now, "Seurat")) {
                vals_now <- .fetch_gene_values(
                  obj_now,
                  .expr_assay_name(obj_now),
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
              # Agent note: A newly added gene owns expression focus so its
              # orange UMAP outline and range distribution appear immediately.
              state2$groups[[gi]]$active_gene_id <- gene_id
              state2$next_gene_index <- gene_idx + 1L
              .db_update_gene_selectize(id_local, all_genes_now, selected = character(0))
              stage_added_gene <- TRUE
            }
            active_gid2 <- .scalar_chr(state2$active_group_id, default = "")
            if (nzchar(active_gid2)) {
              .set_selection_owner("expression", paste0("expr_control:", id_local))
            } else if (identical(.scalar_chr(selection_owner_state(), default = "none"), "expression")) {
              .set_selection_owner("none", paste0("expr_control:", id_local))
            }
            if (isTRUE(stage_added_gene)) {
              staged_object <- .recluster_new_canonical_object_name()
              staged_revision <- .recluster_new_context_revision()
              .expr_stage_added_gene_ui(state2)
              .db_dbg(
                "expr_add_gene_ui_staged",
                sprintf("object=%s revision=%d group=%s", staged_object, staged_revision, gid_local)
              )
              session$onFlushed(function() {
                isolate({
                if (!identical(staged_object, .recluster_new_canonical_object_name()) ||
                    !identical(staged_revision, .recluster_new_context_revision())) {
                  stop("Expression gene commit context changed before post-flush persistence.", call. = FALSE)
                }
                recluster_new_data$expr_ui_staged_state <- NULL
                .expr_set_state(state2)
                .db_dbg(
                  "expr_add_gene_state_committed",
                  sprintf("object=%s revision=%d group=%s", staged_object, staged_revision, gid_local)
                )
                })
              }, once = TRUE)
            } else {
              .expr_set_state(state2)
            }
          }, ignoreInit = TRUE)
        })
      }
      for (gr in (g$genes %||% list())) {
        gene_id <- .scalar_chr(gr$id, default = "")
        if (!nzchar(gene_id)) next
        gene_ids <- c(
          .expr_gene_check_input_id(gid, gene_id),
          .expr_gene_active_input_id(gid, gene_id)
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
              gene_i <- .expr_gene_index(state2$groups[[gi]], gene_id_local)
              if (is.na(gene_i)) return(invisible(NULL))
              if (identical(id_local, .expr_gene_check_input_id(gid_local, gene_id_local))) {
                gene_checked <- isTRUE(input[[id_local]])
                if (identical(isTRUE(state2$groups[[gi]]$genes[[gene_i]]$checked), gene_checked)) {
                  return(invisible(NULL))
                }
                state2$groups[[gi]]$genes[[gene_i]]$checked <- gene_checked
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
              }
              active_gid2 <- .scalar_chr(state2$active_group_id, default = "")
              if (nzchar(active_gid2)) {
                .set_selection_owner("expression", paste0("expr_control:", id_local))
              } else if (identical(.scalar_chr(selection_owner_state(), default = "none"), "expression")) {
                .set_selection_owner("none", paste0("expr_control:", id_local))
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
    if (!.recluster_new_event_allowed("plot_tabs")) return(invisible(NULL))
    tab_key <- .norm_plot_tab(input$recluster_new_tabs)
    if (identical(.active_plot_tab(), tab_key)) return(invisible(NULL))
    .recluster_new_overlay_cancel("plot_tab_changed")
    .active_plot_tab(tab_key)
  }, ignoreInit = FALSE, priority = 1000)
  observeEvent(input$recluster_new_tabs_click, {
    if (!.recluster_new_event_allowed("plot_tabs_click")) return(invisible(NULL))
    tab_key <- .norm_plot_tab(input$recluster_new_tabs_click)
    if (identical(.active_plot_tab(), tab_key)) return(invisible(NULL))
    .recluster_new_overlay_cancel("plot_tab_changed")
    .active_plot_tab(tab_key)
  }, ignoreInit = TRUE, priority = 1001)

  observeEvent(input$recluster_new_expr_tabs, {
    if (!.recluster_new_event_allowed("expr_tabs")) return(invisible(NULL))
    tab_raw <- .scalar_chr(input$recluster_new_expr_tabs, default = "")
    if (!nzchar(tab_raw)) return(invisible(NULL))
    tab_key <- .norm_expr_tab(tab_raw)
    if (identical(.active_expr_tab(), tab_key)) return(invisible(NULL))
    .active_expr_tab(tab_key)
  }, ignoreInit = FALSE, priority = 1000)
  observeEvent(input$recluster_new_expr_tabs_click, {
    if (!.recluster_new_event_allowed("expr_tabs_click")) return(invisible(NULL))
    tab_raw <- .scalar_chr(input$recluster_new_expr_tabs_click, default = "")
    if (!nzchar(tab_raw)) return(invisible(NULL))
    tab_key <- .norm_expr_tab(tab_raw)
    if (identical(.active_expr_tab(), tab_key)) return(invisible(NULL))
    .active_expr_tab(tab_key)
  }, ignoreInit = TRUE, priority = 1001)

  observeEvent(input$recluster_new_rule_plot_tabs, {
    if (!.recluster_new_event_allowed("rule_plot_tabs")) return(invisible(NULL))
    tab_key <- .norm_rule_plot_tab(input$recluster_new_rule_plot_tabs)
    if (identical(.active_rule_plot_tab(), tab_key)) return(invisible(NULL))
    .active_rule_plot_tab(tab_key)
  }, ignoreInit = FALSE, priority = 1000)
  observeEvent(input$recluster_new_rule_plot_tabs_click, {
    if (!.recluster_new_event_allowed("rule_plot_tabs_click")) return(invisible(NULL))
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
    if (!.recluster_new_context_is_settled()) return(NULL)
    expr_tab <- .current_expr_tab()
    if (identical(expr_tab, "pseudobulk")) {
      pb_choices <- names(recluster_new_data$metadata_profiles %||% list())
      pb_selected <- .scalar_chr(isolate(input$recluster_new_pb_meta_col), default = "")
      if (!(pb_selected %in% pb_choices)) {
        pb_selected <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
      }
      if (!(pb_selected %in% pb_choices)) {
        pb_selected <- if (length(pb_choices)) pb_choices[[1]] else ""
      }
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
                choices = pb_choices,
                selected = pb_selected
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

  .recluster_new_overlay_context <- function(tab_now = "") {
    isolate({
      tab_seed <- .scalar_chr(tab_now, default = "")
      if (!nzchar(tab_seed)) tab_seed <- .scalar_chr(input$recluster_new_tabs, default = "umap")
      tab_key <- .norm_plot_tab(tab_seed)
      if (!nzchar(tab_key)) tab_key <- "umap"
      list(
        active = .db_tab_is_active(),
        object = .recluster_new_canonical_object_name(),
        revision = .recluster_new_context_revision(),
        tab = tab_key
      )
    })
  }

  .recluster_new_overlay_begin <- function(msg = "Preparing plot...", tab_now = "", reason = "") {
    context <- .recluster_new_overlay_context(tab_now)
    if (!isTRUE(context$active) || !nzchar(context$object)) return(invisible(FALSE))
    current_state <- isolate(recluster_new_overlay_state())
    if (is.list(current_state) && isTRUE(current_state$pending) &&
        identical(.scalar_chr(current_state$object, default = ""), context$object) &&
        identical(as.integer(current_state$revision %||% NA_integer_), as.integer(context$revision)) &&
        identical(.scalar_chr(current_state$tab, default = ""), context$tab)) {
      # Landing activation and post-flush settlement can both announce the
      # same request. Keep one request identity so that announcement itself
      # cannot schedule duplicate heavy plot renders.
      .db_dbg(
        "overlay_begin_reused",
        sprintf("request=%s object=%s revision=%d tab=%s reason=%s", as.character(current_state$request_id %||% ""), context$object, context$revision, context$tab, .scalar_chr(reason, default = ""))
      )
      try(overlay_show(msg), silent = TRUE)
      return(invisible(TRUE))
    }
    request_id <- suppressWarnings(as.integer(isolate(recluster_new_overlay_request_id()) %||% 0L))
    if (!is.finite(request_id) || is.na(request_id) || request_id < 0L) request_id <- 0L
    request_id <- request_id + 1L
    recluster_new_overlay_request_id(request_id)
    recluster_new_overlay_state(list(
      pending = TRUE,
      request_id = request_id,
      object = context$object,
      revision = context$revision,
      tab = context$tab,
      status = "pending"
    ))
    .db_dbg(
      "overlay_begin",
      sprintf("request=%d object=%s revision=%d tab=%s reason=%s", request_id, context$object, context$revision, context$tab, .scalar_chr(reason, default = ""))
    )
    try(overlay_show(msg), silent = TRUE)
    invisible(TRUE)
  }

  .recluster_new_overlay_cancel <- function(reason = "") {
    state <- isolate(recluster_new_overlay_state())
    if (!is.list(state) || !isTRUE(state$pending)) return(invisible(FALSE))
    .db_dbg(
      "overlay_cancel",
      sprintf("request=%s reason=%s", as.character(state$request_id %||% ""), .scalar_chr(reason, default = ""))
    )
    recluster_new_overlay_state(modifyList(state, list(pending = FALSE, status = "cancelled")))
    try(overlay_hide(), silent = TRUE)
    invisible(TRUE)
  }

  .recluster_new_overlay_finish <- function(tab_now = "", status = "ready", reason = "") {
    state <- isolate(recluster_new_overlay_state())
    if (!is.list(state) || !isTRUE(state$pending)) return(invisible(FALSE))
    context <- .recluster_new_overlay_context(tab_now)
    if (!isTRUE(context$active) ||
        !identical(.scalar_chr(state$object, default = ""), context$object) ||
        !identical(as.integer(state$revision %||% NA_integer_), as.integer(context$revision)) ||
        !identical(.scalar_chr(state$tab, default = ""), context$tab)) {
      return(invisible(FALSE))
    }
    status <- .scalar_chr(status, default = "ready")
    recluster_new_overlay_state(modifyList(state, list(pending = FALSE, status = status)))
    .db_dbg(
      "overlay_finish",
      sprintf("request=%s object=%s revision=%d tab=%s status=%s reason=%s", as.character(state$request_id %||% ""), context$object, context$revision, context$tab, status, .scalar_chr(reason, default = ""))
    )
    try(overlay_hide(), silent = TRUE)
    invisible(TRUE)
  }

  .recluster_new_overlay_show_plot <- function(msg = "Preparing plot...", tab_now = "") {
    if (is.null(isolate(recluster_new_data$seurat_obj))) {
      .recluster_new_overlay_cancel("no_object")
      return(invisible(NULL))
    }

    tab_seed <- .scalar_chr(tab_now, default = "")
    if (!nzchar(tab_seed)) tab_seed <- "umap"
    tab_key <- .norm_plot_tab(tab_seed)
    if (!nzchar(tab_key)) tab_key <- "umap"
    .recluster_new_overlay_begin(msg, tab_key, reason = "plot_request")

    if (tab_key == "umap") {
      # This helper is also called by the onFlushed settlement callback. Keep
      # its cache inspection outside reactive dependency tracking so first-page
      # activation cannot abort while checking whether a plot is already ready.
      plot_cache_sig <- isolate(.umap_plot_cache_signature())
      stored_sig <- isolate(recluster_new_data$umap_plot_cache_sig)
      stored_cache <- isolate(recluster_new_data$umap_plot_cache)
      plot_cached <- nzchar(plot_cache_sig) && identical(plot_cache_sig, stored_sig) && inherits(stored_cache, "plotly")
      if (plot_cached) {
        .recluster_new_overlay_finish(tab_key, status = "ready", reason = "cache_hit")
      }
    }
    invisible(NULL)
  }

  observeEvent(input$main_navbar, {
    if (!.db_tab_is_active()) {
      .recluster_new_overlay_cancel("page_left")
      .recluster_new_clear_page_context("page_left")
      return(invisible(NULL))
    }
    recluster_new_page_activating(TRUE)
    recluster_new_dataset_syncing(TRUE)
    tab_now <- .scalar_chr(input$recluster_new_tabs, default = "umap")
    
    has_objs <- length(shared_data$all_seurat_objects) > 0L
    active_nm <- .scalar_chr(shared_data$active_object_name, default = "")
    loaded_now <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    load_failure_signature <- recluster_new_load_failure_source_signature()
    load_failure_matches <- nzchar(load_failure_signature) &&
      identical(.recluster_new_load_source_signature(active_nm), load_failure_signature)
    if (has_objs && nzchar(active_nm)) {
      if (isTRUE(load_failure_matches)) {
        .db_dbg(
          "landing_overlay_suppressed_terminal_failure",
          sprintf("active=%s source=%s", active_nm, load_failure_signature)
        )
        .recluster_new_overlay_cancel("terminal_load_failure")
      } else {
        # Agent note: Always emit the landing overlay before page initialization;
        # server plot completion owns its release after the next settled render.
        .db_dbg("landing_overlay_show", sprintf("active=%s loaded=%s", active_nm, loaded_now))
        .recluster_new_overlay_begin("Preparing Data Browser plot...", tab_now, reason = "page_activation")
      }
    } else {
      .db_dbg("landing_overlay_hide", sprintf("has_objects=%s active=%s", has_objs, active_nm))
      .recluster_new_overlay_cancel("empty_workspace")
    }
    
    try(bslib::toggle_sidebar("app_right_sidebar", open = FALSE, session = session), silent = TRUE)
    loaded_now <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    recluster_new_object_loading(TRUE)
    on.exit(recluster_new_object_loading(FALSE), add = TRUE)
    needs_object_load <- !identical(loaded_now, active_nm) || is.null(recluster_new_data$seurat_obj)
    if (!needs_object_load && nzchar(active_nm)) {
      needs_object_load <- .recluster_new_expression_state_needs_reload(active_nm)
    }
    if (isTRUE(needs_object_load) && identical(loaded_now, active_nm) && nzchar(active_nm)) {
      .db_dbg(
        "workspace_expression_state_reload",
        sprintf("object=%s local_groups=%d", active_nm, length(recluster_new_data$expr_selection$groups %||% list()))
      )
    }
    if (isTRUE(needs_object_load)) {
      if (isTRUE(load_failure_matches)) {
        .db_dbg(
          "object_load_blocked_terminal_failure",
          sprintf("active=%s source=%s", active_nm, load_failure_signature)
        )
        .recluster_new_schedule_context_settle(
          .recluster_new_context_revision(),
          message = "Preparing Data Browser plot...",
          tab_now = tab_now
        )
      } else {
        .load_active_recluster_new_object(active_nm, settle_message = "Preparing Data Browser plot...")
      }
    } else {
      .recluster_new_schedule_context_settle(
        .recluster_new_context_revision(),
        message = "Preparing Data Browser plot...",
        tab_now = tab_now
      )
    }
    if (!identical(.scalar_chr(input$recluster_new_tabs, default = ""), tab_now)) {
      suppressWarnings(try(updateTabsetPanel(session, "recluster_new_tabs", selected = tab_now), silent = TRUE))
    }
    invisible(NULL)
  }, ignoreInit = FALSE, priority = 1000)

  # Agent note: Registry deletion and sidebar object switches are canonical.
  # Reconcile only after explicit object-loading transition completes; selector
  # input is a view and may still show its previous value during that transition.
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
    load_failure_signature <- recluster_new_load_failure_source_signature()
    if (nzchar(load_failure_signature) &&
        identical(.recluster_new_load_source_signature(nm), load_failure_signature)) {
      .db_dbg(
        "canonical_object_load_blocked_terminal_failure",
        sprintf("active=%s source=%s", nm, load_failure_signature)
      )
      return(invisible(NULL))
    }
    .db_dbg(
      "canonical_object_transition",
      sprintf("active=%s loaded=%s registry_sig=%s", nm, loaded_now, registry_sig)
    )
    .load_active_recluster_new_object(nm)
    invisible(NULL)
  })

  observeEvent(input$recluster_new_umap_reduction_select, {
    if (!.recluster_new_event_allowed("umap_reduction")) return(invisible(NULL))
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))
    if (!isTRUE(.recluster_new_on_page())) return(invisible(NULL))
    red <- .scalar_chr(input$recluster_new_umap_reduction_select, default = "")
    reduction_choices <- .embedding_reduction_choices(obj)
    if (!(nzchar(red) && red %in% reduction_choices)) return(invisible(NULL))
    if (identical(red, .scalar_chr(recluster_new_data$umap_reduction_choice, default = ""))) {
      return(invisible(NULL))
    }
    recluster_new_data$umap_reduction_choice <- red
    .remember_visual_settings(umap_reduction_choice = red)
    recluster_new_data$final_plot_cache_sig <- ""
    recluster_new_data$final_plot_cache <- NULL
    recluster_new_data$umap_plot_cache_sig <- ""
    recluster_new_data$umap_plot_cache <- NULL
    umap_plot_rendered(NULL)
    axis_choices <- .axis_index_choices(obj, red)
    if (!length(axis_choices)) return(invisible(NULL))
    axis_vals <- as.character(axis_choices)
    x_now <- .scalar_chr(input$recluster_new_umap_axis_x_select, default = "")
    y_now <- .scalar_chr(input$recluster_new_umap_axis_y_select, default = "")
    x_sel <- if (nzchar(x_now) && x_now %in% axis_vals) x_now else axis_vals[[1]]
    y_sel <- if (nzchar(y_now) && y_now %in% axis_vals && y_now != x_sel) y_now else if (length(axis_vals) >= 2L) axis_vals[[2]] else x_sel
    if (identical(x_now, x_sel) && identical(y_now, y_sel)) return(invisible(NULL))
    if (!identical(x_now, x_sel)) {
      updateSelectInput(session, "recluster_new_umap_axis_x_select", choices = axis_choices, selected = x_sel)
    }
    if (!identical(y_now, y_sel)) {
      updateSelectInput(session, "recluster_new_umap_axis_y_select", choices = axis_choices, selected = y_sel)
    }
  }, ignoreInit = TRUE)

  observe({
    if (!isTRUE(.recluster_new_on_page())) return(invisible(NULL))
    if (isTRUE(recluster_new_object_loading())) return(invisible(NULL))
    if (isTRUE(recluster_new_dataset_syncing())) return(invisible(NULL))
    nm <- .scalar_chr(recluster_new_loaded_object_name(), default = "")
    if (!nzchar(nm)) return(invisible(NULL))
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    shared_obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    shared_object_state <- .object_owned_state(shared_obj)
    local_object_state <- .object_owned_state(recluster_new_data$seurat_obj)
    if (!identical(shared_object_state, local_object_state)) {
      .db_dbg(
        "reload_object_owned_state_changed",
        sprintf(
          "object=%s shared_expr_groups=%d local_expr_groups=%d shared_active=%s local_active=%s",
          nm,
          length(shared_object_state$expression_selection$groups %||% list()),
          length(local_object_state$expression_selection$groups %||% list()),
          .scalar_chr(shared_object_state$expression_selection$active_group_id, default = ""),
          .scalar_chr(local_object_state$expression_selection$active_group_id, default = "")
        )
      )
      .load_active_recluster_new_object(nm)
      return(invisible(NULL))
    }
    shared_controls_key <- .viz_controls_structure_key(shared_obj, nm)
    local_controls_key <- .scalar_chr(recluster_new_data$viz_controls_structure_key, default = "")
    if (nzchar(shared_controls_key) && !identical(shared_controls_key, local_controls_key)) {
      .db_dbg(
        "reload_embedding_state_changed",
        sprintf("object=%s shared=%s local=%s", nm, shared_controls_key, local_controls_key)
      )
      .load_active_recluster_new_object(nm)
      return(invisible(NULL))
    }
    shared_sig <- .reduction_shape_signature(shared_obj)
    local_sig <- .reduction_shape_signature(recluster_new_data$seurat_obj)
    if (!nzchar(shared_sig) || identical(shared_sig, local_sig)) return(invisible(NULL))
    .db_dbg("reload_reduction_shape_changed", sprintf("object=%s shared=%s local=%s", nm, shared_sig, local_sig))
    .load_active_recluster_new_object(nm)
    invisible(NULL)
  }, priority = 900)

  observe({
    loaded_now <- recluster_new_loaded_object_name()
    if (!.recluster_new_event_allowed("loaded_object_sync")) return(invisible(NULL))
    .db_dbg("seurat_obj_observer", sprintf("loaded object name changed to=%s", loaded_now))
    # Track only context settlement here. Catalog reads/writes stay isolated so
    # selecting a gene or changing a plot control cannot re-enter this loader.
    isolate({
      .sync_assay_gene_inputs(force = TRUE)
      .sync_rule_assay_gene_inputs(force = TRUE)
    })
  }, priority = 950)

  observeEvent(input$recluster_new_assay_select, {
    if (!.recluster_new_event_allowed("umap_assay")) return(invisible(NULL))
    assay_event <- .scalar_chr(input$recluster_new_assay_select, default = "")
    assay_changed <- FALSE
    obj <- recluster_new_data$seurat_obj
    if (!is.null(obj) && inherits(obj, "Seurat")) {
      assay_choices <- .safe_assay_choices(obj)
      assay_now <- assay_event
      if (nzchar(assay_now) && assay_now %in% assay_choices) {
        assay_stored <- .scalar_chr(recluster_new_data$umap_assay_choice, default = "")
        assay_changed <- !identical(assay_now, assay_stored)
        if (isTRUE(assay_changed)) {
          recluster_new_data$umap_assay_choice <- assay_now
        }
      } else {
        return(invisible(NULL))
      }
    }
    .sync_assay_gene_inputs(force = assay_changed)
    .remember_visual_settings(
      umap_assay_choice = .scalar_chr(recluster_new_data$umap_assay_choice, default = assay_event)
    )
  }, ignoreInit = TRUE, priority = 940)

  observeEvent(input$recluster_new_rule_assay_select, {
    if (!.recluster_new_event_allowed("rule_assay")) return(invisible(NULL))
    assay_event <- .scalar_chr(input$recluster_new_rule_assay_select, default = "")
    assay_changed <- FALSE
    obj <- recluster_new_data$seurat_obj
    if (!is.null(obj) && inherits(obj, "Seurat")) {
      assay_choices <- .safe_assay_choices(obj)
      assay_now <- assay_event
      if (nzchar(assay_now) && assay_now %in% assay_choices) {
        assay_stored <- .scalar_chr(recluster_new_data$rule_assay_choice, default = "")
        assay_changed <- !identical(assay_now, assay_stored)
        if (isTRUE(assay_changed)) {
          recluster_new_data$rule_assay_choice <- assay_now
        }
      } else {
        return(invisible(NULL))
      }
    }
    .sync_rule_assay_gene_inputs(force = assay_changed)
    .remember_visual_settings(
      rule_assay_choice = .scalar_chr(recluster_new_data$rule_assay_choice, default = assay_event)
    )
  }, ignoreInit = TRUE, priority = 940)

  observeEvent(input$recluster_new_update_viz_btn, {
    if (!.recluster_new_event_allowed("update_viz")) return(invisible(NULL))
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
    if (!.recluster_new_event_allowed("workspace_tabs")) return(invisible(NULL))
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
    if (!identical(.scalar_chr(input$recluster_new_workspace_tabs, default = ""), tab_target)) {
      suppressWarnings(try(updateTabsetPanel(session, "recluster_new_workspace_tabs", selected = tab_target), silent = TRUE))
    }
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
    if (!.recluster_new_context_is_settled()) return(NULL)
    cols <- .meta_cols()
    if (!length(cols)) return(helpText("No source metadata column available."))
    selected <- .scalar_chr(isolate(input$recluster_new_source_col), default = "")
    if (!(selected %in% cols)) selected <- cols[[1]]
    selectInput("recluster_new_source_col", RECLUSTER_NEW_UI_TEXT$t_label_source_column, choices = cols, selected = selected)
  })
  output$recluster_new_group_col_ui <- renderUI({
    if (!.recluster_new_context_is_settled()) return(NULL)
    cols <- .meta_cols()
    if (!length(cols)) return(helpText("No grouping column available."))
    selected <- .scalar_chr(isolate(input$recluster_new_group_col), default = "")
    if (!(selected %in% cols)) selected <- cols[[1]]
    selectInput("recluster_new_group_col", RECLUSTER_NEW_UI_TEXT$t_label_group_by_column, choices = cols, selected = selected)
  })
  output$recluster_new_group_level_ui <- renderUI({
    if (!.recluster_new_context_is_settled()) return(NULL)
    obj <- recluster_new_data$seurat_obj
    req(obj)
    gc <- .scalar_chr(input$recluster_new_group_col, default = "")
    req(nzchar(gc), gc %in% colnames(obj@meta.data))
    lv <- sort(unique(as.character(obj@meta.data[[gc]] %||% character(0))), method = "radix")
    lv <- lv[nzchar(lv)]
    if (!length(lv)) return(helpText("No values in selected group column."))
    selected <- .scalar_chr(isolate(input$recluster_new_group_level), default = "")
    if (!(selected %in% lv)) selected <- lv[[1]]
    selectInput("recluster_new_group_level", RECLUSTER_NEW_UI_TEXT$t_label_group_value, choices = lv, selected = selected)
  })
  output$recluster_new_relabel_target_col_ui <- renderUI({
    if (!.recluster_new_context_is_settled()) return(NULL)
    cols <- .meta_cols()
    selected <- .scalar_chr(isolate(input$recluster_new_relabel_target_col), default = "user_manual_label")
    selectizeInput(
      "recluster_new_relabel_target_col",
      RECLUSTER_NEW_UI_TEXT$t_label_target_column,
      choices = unique(c("user_manual_label", cols)),
      selected = selected,
      options = list(create = TRUE, placeholder = "Pick existing column or type new name")
    )
  })
  output$recluster_new_cell_target_col_ui <- renderUI({
    if (!.recluster_new_context_is_settled()) return(NULL)
    cols <- .meta_cols()
    selected <- .scalar_chr(isolate(input$recluster_new_cell_target_col), default = "user_manual_label")
    selectizeInput(
      "recluster_new_cell_target_col",
      RECLUSTER_NEW_UI_TEXT$t_label_target_column,
      choices = unique(c("user_manual_label", cols)),
      selected = selected,
      options = list(create = TRUE, placeholder = "Pick existing column or type new name")
    )
  })

  output$recluster_new_viz_controls_ui <- renderUI({
    if (!.recluster_new_context_is_settled()) return(NULL)
    structure_key <- recluster_new_data$viz_controls_structure_key
    if (!nzchar(structure_key)) return(NULL)
    obj <- isolate(recluster_new_data$seurat_obj)
    if (is.null(obj) || !inherits(obj, "Seurat")) return(NULL)
    cur_tab <- .current_plot_tab()
    cache_sig <- paste(structure_key, .scalar_chr(cur_tab, default = ""), sep = "::")
    stored_sig <- isolate(recluster_new_data$viz_controls_cache_sig)
    stored_cache <- isolate(recluster_new_data$viz_controls_cache)
    # Controls rebuild only when their object/assay/reduction structure changes.
    is_scatter_tab <- identical(cur_tab, "scatter")
    available_cols <- names(isolate(recluster_new_data$metadata_profiles) %||% list())
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
    .schedule_gene_selectize_hydration(
      if (is_scatter_tab) {
        c("recluster_new_scatter_gene_x", "recluster_new_scatter_gene_y")
      } else {
        c(
          "recluster_new_gene_expr_select_1",
          "recluster_new_gene_expr_select_2",
          "recluster_new_gene_expr_select_3"
        )
      },
      all_genes,
      .recluster_new_canonical_object_name(),
      .recluster_new_context_revision(),
      source = "viz_controls_ui"
    )
    if (identical(cache_sig, stored_sig) && !is.null(stored_cache)) {
      return(stored_cache)
    }
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
    scatter_color_choices <- c("None", available_cols)
    scatter_color_sel <- isolate(.scalar_chr(input$recluster_new_scatter_color_by, default = ""))
    if (!(scatter_color_sel %in% scatter_color_choices)) {
      scatter_color_sel <- if (length(available_cols)) available_cols[[1]] else "None"
    }
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
      red_sel_now <- .preferred_embedding_reduction(obj, entry = .current_reduction_entry())
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

    visual_settings <- isolate(.current_visual_settings())
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
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_scatter_gene_x", RECLUSTER_NEW_UI_TEXT$t_label_scatter_gene_x, selected = scatter_x_sel, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = all_genes, defer_choices = TRUE))),
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_scatter_gene_y", RECLUSTER_NEW_UI_TEXT$t_label_scatter_gene_y, selected = scatter_y_sel, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = all_genes, defer_choices = TRUE))),
            column(4, div(class = "recluster-new-controls-item", selectInput("recluster_new_scatter_color_by", RECLUSTER_NEW_UI_TEXT$t_label_scatter_color, choices = scatter_color_choices, selected = scatter_color_sel)))
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
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_gene_expr_select_1", RECLUSTER_NEW_UI_TEXT$t_label_gene_1, selected = gene_sel, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = all_genes, defer_choices = TRUE))),
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_gene_expr_select_2", RECLUSTER_NEW_UI_TEXT$t_label_gene_2, selected = gene2_sel, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = all_genes, defer_choices = TRUE))),
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_gene_expr_select_3", RECLUSTER_NEW_UI_TEXT$t_label_gene_3, selected = gene3_sel, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = all_genes, defer_choices = TRUE)))
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
    controls_ui
  })

  output$recluster_new_rule_viz_controls_ui <- renderUI({
    if (!.recluster_new_context_is_settled()) return(NULL)
    structure_key <- recluster_new_data$viz_controls_structure_key
    if (!nzchar(structure_key)) return(NULL)
    obj <- isolate(recluster_new_data$seurat_obj)
    if (is.null(obj) || !inherits(obj, "Seurat")) return(NULL)
    cur_tab <- .current_rule_plot_tab()
    cache_sig <- paste(structure_key, paste0("rule:", .scalar_chr(cur_tab, default = "")), sep = "::")
    stored_sig <- isolate(recluster_new_data$rule_viz_controls_cache_sig)
    stored_cache <- isolate(recluster_new_data$rule_viz_controls_cache)
    # Controls rebuild only when their object/assay/reduction structure changes.
    is_scatter_tab <- identical(cur_tab, "rule_scatter")
    available_cols <- names(isolate(recluster_new_data$metadata_profiles) %||% list())
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
    .schedule_gene_selectize_hydration(
      if (is_scatter_tab) {
        c("recluster_new_rule_scatter_gene_x", "recluster_new_rule_scatter_gene_y")
      } else {
        "recluster_new_rule_gene_expr_select_1"
      },
      all_genes,
      .recluster_new_canonical_object_name(),
      .recluster_new_context_revision(),
      source = "rule_viz_controls_ui"
    )
    if (identical(cache_sig, stored_sig) && !is.null(stored_cache)) {
      return(stored_cache)
    }
    gene_sel <- isolate(.scalar_chr(input$recluster_new_rule_gene_expr_select_1, default = ""))
    if (!(nzchar(gene_sel) && gene_sel %in% all_genes)) gene_sel <- ""
    scatter_x_sel <- isolate(.scalar_chr(input$recluster_new_rule_scatter_gene_x, default = ""))
    scatter_y_sel <- isolate(.scalar_chr(input$recluster_new_rule_scatter_gene_y, default = ""))
    if (!(nzchar(scatter_x_sel) && scatter_x_sel %in% all_genes)) scatter_x_sel <- if (length(all_genes)) all_genes[[1]] else ""
    if (!(nzchar(scatter_y_sel) && scatter_y_sel %in% all_genes)) scatter_y_sel <- if (length(all_genes) >= 2) all_genes[[2]] else scatter_x_sel
    split_choices <- available_cols
    rule_scatter_color_choices <- c("None", available_cols)
    rule_scatter_color_sel <- isolate(.scalar_chr(input$recluster_new_rule_scatter_color_by, default = ""))
    if (!(rule_scatter_color_sel %in% rule_scatter_color_choices)) {
      rule_scatter_color_sel <- if (length(available_cols)) available_cols[[1]] else "None"
    }
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
      red_sel_now <- .preferred_embedding_reduction(obj, entry = .current_reduction_entry())
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
            column(3, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_rule_scatter_gene_x", RECLUSTER_NEW_UI_TEXT$t_label_scatter_gene_x, selected = scatter_x_sel, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = all_genes, defer_choices = TRUE))),
            column(3, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_rule_scatter_gene_y", RECLUSTER_NEW_UI_TEXT$t_label_scatter_gene_y, selected = scatter_y_sel, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = all_genes, defer_choices = TRUE))),
            column(3, div(class = "recluster-new-controls-item", checkboxGroupInput("recluster_new_rule_scatter_log_scale", RECLUSTER_NEW_UI_TEXT$t_label_scatter_axis_scale, choices = c("Log Scale X-axis", "Log Scale Y-axis")))),
            column(3, div(class = "recluster-new-controls-item", selectInput("recluster_new_rule_scatter_color_by", RECLUSTER_NEW_UI_TEXT$t_label_scatter_color, choices = rule_scatter_color_choices, selected = rule_scatter_color_sel)))
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
            column(4, div(class = "recluster-new-controls-item", wl_gene_selectize_input("recluster_new_rule_gene_expr_select_1", RECLUSTER_NEW_UI_TEXT$t_label_gene_shared, selected = gene_sel, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = all_genes, defer_choices = TRUE))),
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
    if (!.recluster_new_context_is_settled()) return(NULL)
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
    cur <- suppressWarnings(as.numeric(isolate(input$recluster_new_rule_gene_expr_range) %||% c(rng[[1]], rng[[2]])))
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
    if (!.recluster_new_event_allowed("rule_update_viz")) return(invisible(NULL))
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
    if (!.recluster_new_event_allowed("rule_metadata_choices")) return(invisible(NULL))
    cols <- .rule_meta_cols()
    a_now <- .scalar_chr(isolate(input$recluster_new_rule_a_col), default = "")
    b_now <- .scalar_chr(isolate(input$recluster_new_rule_b_col), default = "")
    g_now <- .scalar_chr(isolate(input$recluster_new_rule_group_col), default = "")
    a_sel <- if (nzchar(a_now) && a_now %in% cols) a_now else if (length(cols)) cols[[1]] else ""
    b_sel <- if (nzchar(b_now) && b_now %in% cols) b_now else if (length(cols) >= 2) cols[[2]] else a_sel
    g_sel <- if (nzchar(g_now) && g_now %in% cols) g_now else if ("seurat_clusters" %in% cols) "seurat_clusters" else if (length(cols)) cols[[1]] else ""
    choices_sig <- paste(c(cols, a_sel, b_sel, g_sel), collapse = "\u001f")
    if (identical(.scalar_chr(recluster_new_data$rule_meta_choices_sig, default = ""), choices_sig)) {
      return(invisible(NULL))
    }
    recluster_new_data$rule_meta_choices_sig <- choices_sig
    updateSelectInput(session, "recluster_new_rule_a_col", choices = cols, selected = a_sel)
    updateSelectInput(session, "recluster_new_rule_b_col", choices = cols, selected = b_sel)
    updateSelectInput(session, "recluster_new_rule_group_col", choices = cols, selected = g_sel)
    invisible(NULL)
  }, ignoreInit = FALSE)

  output$recluster_new_rule_a_value_ui <- renderUI({
    if (!.recluster_new_context_is_settled()) return(NULL)
    obj <- recluster_new_data$seurat_obj
    req(obj)
    col_a <- .scalar_chr(input$recluster_new_rule_a_col, default = "")
    req(nzchar(col_a), col_a %in% colnames(obj@meta.data))
    vec <- obj@meta.data[[col_a]]
    if (.is_numeric_rule_column(vec)) {
      vv <- suppressWarnings(as.numeric(vec))
      rng <- range(vv[is.finite(vv)], na.rm = TRUE)
      if (!all(is.finite(rng))) return(helpText("No finite numeric values available."))
      cur <- suppressWarnings(as.numeric(isolate(input$recluster_new_rule_a_range) %||% rng))
      if (length(cur) != 2 || any(!is.finite(cur))) cur <- rng
      sliderInput("recluster_new_rule_a_range", "Rule A range", min = rng[[1]], max = rng[[2]], value = cur, step = max((rng[[2]] - rng[[1]]) / 200, 1e-9))
    } else {
      vals <- as.character(vec %||% character(0))
      vals <- vals[!is.na(vals) & nzchar(vals)]
      lv <- .sort_numeric_first(unique(vals))
      auto <- .likely_positive_values(lv, col_name = col_a)
      selected_now <- as.character(isolate(input$recluster_new_rule_a_values) %||% auto)
      if (!length(selected_now)) selected_now <- auto
      checkboxGroupInput("recluster_new_rule_a_values", "Rule A values interpreted as TRUE", choices = lv, selected = intersect(selected_now, lv))
    }
  })

  output$recluster_new_rule_b_value_ui <- renderUI({
    if (!.recluster_new_context_is_settled()) return(NULL)
    obj <- recluster_new_data$seurat_obj
    req(obj)
    col_b <- .scalar_chr(input$recluster_new_rule_b_col, default = "")
    req(nzchar(col_b), col_b %in% colnames(obj@meta.data))
    vec <- obj@meta.data[[col_b]]
    if (.is_numeric_rule_column(vec)) {
      vv <- suppressWarnings(as.numeric(vec))
      rng <- range(vv[is.finite(vv)], na.rm = TRUE)
      if (!all(is.finite(rng))) return(helpText("No finite numeric values available."))
      cur <- suppressWarnings(as.numeric(isolate(input$recluster_new_rule_b_range) %||% rng))
      if (length(cur) != 2 || any(!is.finite(cur))) cur <- rng
      sliderInput("recluster_new_rule_b_range", "Rule B range", min = rng[[1]], max = rng[[2]], value = cur, step = max((rng[[2]] - rng[[1]]) / 200, 1e-9))
    } else {
      vals <- as.character(vec %||% character(0))
      vals <- vals[!is.na(vals) & nzchar(vals)]
      lv <- .sort_numeric_first(unique(vals))
      auto <- .likely_positive_values(lv, col_name = col_b)
      selected_now <- as.character(isolate(input$recluster_new_rule_b_values) %||% auto)
      if (!length(selected_now)) selected_now <- auto
      checkboxGroupInput("recluster_new_rule_b_values", "Rule B values interpreted as TRUE", choices = lv, selected = intersect(selected_now, lv))
    }
  })

  observeEvent(input$recluster_new_rule_color_preset, {
    if (!.recluster_new_event_allowed("rule_color_preset")) return(invisible(NULL))
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

  .rule_definition_state <- reactive({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    md <- obj@meta.data
    req(is.data.frame(md), nrow(md))

    col_a <- .scalar_chr(input$recluster_new_rule_a_col, default = "")
    col_b <- .scalar_chr(input$recluster_new_rule_b_col, default = "")
    md_cols <- colnames(md)
    cols_ready <- nzchar(col_a) && nzchar(col_b) && col_a %in% md_cols && col_b %in% md_cols
    if (!isTRUE(cols_ready)) {
      return(list(
        ready = FALSE,
        definitions = list(
          A = list(type = "unresolved", column = col_a),
          B = list(type = "unresolved", column = col_b)
        ),
        diagnostic = sprintf("A=%s|B=%s|md_cols=%d", col_a, col_b, length(md_cols))
      ))
    }

    vec_a <- md[[col_a]]
    vec_b <- md[[col_b]]
    def_a <- if (.is_numeric_rule_column(vec_a)) {
      list(type = "numeric", column = col_a, range = as.numeric(input$recluster_new_rule_a_range %||% c(NA_real_, NA_real_)))
    } else {
      list(type = "categorical", column = col_a, selected = as.character(input$recluster_new_rule_a_values %||% character(0)))
    }
    def_b <- if (.is_numeric_rule_column(vec_b)) {
      list(type = "numeric", column = col_b, range = as.numeric(input$recluster_new_rule_b_range %||% c(NA_real_, NA_real_)))
    } else {
      list(type = "categorical", column = col_b, selected = as.character(input$recluster_new_rule_b_values %||% character(0)))
    }
    list(
      ready = TRUE,
      definitions = list(A = def_a, B = def_b),
      diagnostic = ""
    )
  })

  observeEvent(.rule_definition_state(), {
    if (!.recluster_new_event_allowed("rule_definition")) return(invisible(NULL))
    state_now <- .rule_definition_state()
    definitions_now <- state_now$definitions %||% list()
    if (!identical(recluster_new_data$rule_definitions, definitions_now)) {
      recluster_new_data$rule_definitions <- definitions_now
    }
    diagnostic_now <- .scalar_chr(state_now$diagnostic, default = "")
    if (!identical(recluster_new_data$debug_rule_overlap_state, diagnostic_now)) {
      if (nzchar(diagnostic_now)) {
        .db_dbg("rule_columns_not_ready", diagnostic_now)
      }
      recluster_new_data$debug_rule_overlap_state <- diagnostic_now
    }
  }, ignoreInit = FALSE)

  rule_overlap_df <- reactive({
    obj <- recluster_new_data$seurat_obj
    req(obj)
    md <- obj@meta.data
    req(is.data.frame(md), nrow(md))

    definition_state <- .rule_definition_state()
    if (!isTRUE(definition_state$ready)) {
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
      return(unresolved)
    }

    definitions <- definition_state$definitions
    col_a <- .scalar_chr(definitions$A$column, default = "")
    col_b <- .scalar_chr(definitions$B$column, default = "")
    vec_a <- md[[col_a]]
    vec_b <- md[[col_b]]
    def_a <- definitions$A
    def_b <- definitions$B

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

  .plotly_selection_key_prefix <- function() {
    paste0("dbctx:", .recluster_new_context_revision(), "::")
  }

  .plotly_selection_keys <- function(cell_ids) {
    paste0(.plotly_selection_key_prefix(), as.character(cell_ids %||% character(0)))
  }

  .plotly_selected_keys <- function(ev, source_name) {
    if (is.null(ev) || (is.list(ev) && length(ev) == 0L)) return(character(0))
    if (!is.data.frame(ev)) {
      .db_dbg(
        "plotly_selected_malformed",
        sprintf(
          "source=%s class=%s length=%d",
          source_name,
          paste(class(ev), collapse = "/"),
          length(ev)
        )
      )
      return(character(0))
    }
    # Plotly emits an empty data frame or a payload without keys while a graph
    # is being rebound/redrawn. That is transport state, not explicit user
    # deselection; only explicit double-click or workflow actions clear state.
    if (nrow(ev) == 0L || !("key" %in% names(ev))) return(NULL)
    keys <- as.character(ev[["key"]])
    keys <- keys[!is.na(keys) & nzchar(keys)]
    if (!length(keys)) return(NULL)
    prefix <- .plotly_selection_key_prefix()
    if (any(substr(keys, 1L, nchar(prefix)) != prefix)) {
      .db_dbg(
        "plotly_selected_stale",
        sprintf("source=%s expected_context=%s", source_name, prefix)
      )
      return(NULL)
    }
    keys <- substr(keys, nchar(prefix) + 1L, nchar(keys))
    unique(keys[!is.na(keys) & nzchar(keys)])
  }

  .clear_main_plot_selection <- function(source = "") {
    if (!.recluster_new_event_allowed(source)) return(invisible(NULL))
    previous <- isolate(lasso_selected_cells_state())
    if (length(previous)) lasso_selected_cells_state(character(0))
    if (identical(.scalar_chr(selection_owner_state(), default = "none"), "manual")) {
      .restore_selection_owner_after_manual_clear(source)
    }
    .db_dbg("manual_selection_clear", sprintf("source=%s cells=%d", source, length(previous)))
    invisible(NULL)
  }

  .clear_rule_plot_selection <- function(source = "") {
    if (!.recluster_new_event_allowed(source)) return(invisible(NULL))
    previous <- isolate(rule_lasso_cells_state())
    if (length(previous)) rule_lasso_cells_state(character(0))
    .db_dbg("rule_selection_clear", sprintf("source=%s cells=%d", source, length(previous)))
    invisible(NULL)
  }

  observeEvent(.plotly_selection_event_data("plotly_selected", "recluster_new_rule_plot_source"), {
    if (!.recluster_new_event_allowed("rule_plot_selection")) return(invisible(NULL))
    ev <- .plotly_selection_event_data("plotly_selected", "recluster_new_rule_plot_source")
    next_cells <- .plotly_selected_keys(ev, "recluster_new_rule_plot_source")
    if (is.null(next_cells)) return(invisible(NULL))
    if (!identical(sort(next_cells), sort(isolate(rule_lasso_cells_state())))) {
      rule_lasso_cells_state(next_cells)
    }
    invisible(NULL)
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  observeEvent(.plotly_selection_event_data("plotly_doubleclick", "recluster_new_rule_plot_source"), {
    .clear_rule_plot_selection("rule_plot_doubleclick")
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  observeEvent(.plotly_selection_event_data("plotly_selected", "recluster_new_plot_source"), {
    if (!.recluster_new_event_allowed("plot_selection")) return(invisible(NULL))
    ev <- .plotly_selection_event_data("plotly_selected", "recluster_new_plot_source")
    next_cells <- .plotly_selected_keys(ev, "recluster_new_plot_source")
    if (is.null(next_cells)) return(invisible(NULL))
    if (!identical(sort(next_cells), sort(isolate(lasso_selected_cells_state())))) {
      lasso_selected_cells_state(next_cells)
    }
    if (length(next_cells)) {
      .set_selection_owner("manual", "plotly_selected")
    } else if (identical(.scalar_chr(selection_owner_state(), default = "none"), "manual")) {
      remaining_manual <- unique(c(
        as.character(recluster_new_data$selected_cells %||% character(0)),
        as.character(enabled_group_cells() %||% character(0))
      ))
      remaining_manual <- remaining_manual[nzchar(remaining_manual)]
      if (!length(remaining_manual)) .restore_selection_owner_after_manual_clear("plotly_deselected")
    }
    .db_dbg(
      "manual_selection_event",
      sprintf("source=plotly_selected cells=%d expression_active=%s", length(next_cells),
              nzchar(.scalar_chr(recluster_new_data$expr_selection$active_group_id, default = "")))
    )
    invisible(NULL)
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  observeEvent(.plotly_selection_event_data("plotly_doubleclick", "recluster_new_plot_source"), {
    .clear_main_plot_selection("plot_doubleclick")
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  rule_lasso_cells <- reactive({
    rule_lasso_cells_state()
  })

  lasso_selected_cells <- reactive({
    lasso_selected_cells_state()
  })

  output$recluster_new_lasso_selection_count <- renderText({
    sprintf("%d cells selected by lasso", length(lasso_selected_cells()))
  })
  outputOptions(output, "recluster_new_lasso_selection_count", suspendWhenHidden = FALSE)

  observeEvent(input$recluster_new_clear_lasso_btn, {
    .clear_main_plot_selection("clear_lasso_button")
  }, ignoreInit = TRUE)

  observe({
    if (!.recluster_new_event_allowed("manual_card_highlight")) return(invisible(NULL))
    lasso_cells <- lasso_selected_cells_state()
    owner_now <- .scalar_chr(selection_owner_state(), default = "none")
    enabled <- identical(owner_now, "manual") && length(lasso_cells) > 0L
    session$sendCustomMessage(
      "recluster-new-toggle-class",
      list(
        object = .recluster_new_canonical_object_name(),
        context_revision = .recluster_new_context_revision(),
        id = "recluster_new_lasso_selection_card",
        className = "is-violet-highlight-source",
        enabled = enabled
      )
    )
    .db_dbg("lasso_card_highlight", sprintf("enabled=%s owner=%s lasso_cells=%d", enabled, owner_now, length(lasso_cells)))
  })

  observe({
    if (!.recluster_new_event_allowed("saved_group_card_highlight")) return(invisible(NULL))
    owner_now <- .scalar_chr(selection_owner_state(), default = "none")
    group_cells <- as.character(enabled_group_cells() %||% character(0))
    lasso_cells <- as.character(lasso_selected_cells_state() %||% character(0))
    enabled <- identical(owner_now, "manual") && length(group_cells) > 0L && !length(lasso_cells)
    class_message <- list(
      object = .recluster_new_canonical_object_name(),
      context_revision = .recluster_new_context_revision(),
      id = "recluster_new_saved_groups_card",
      className = "is-cyan-highlight-source",
      enabled = enabled
    )
    session$sendCustomMessage("recluster-new-toggle-class", class_message)
    if (isTRUE(enabled)) {
      # Saved-group ownership is exclusive with violet manual-card emphasis.
      session$sendCustomMessage(
        "recluster-new-toggle-class",
        modifyList(class_message, list(
          id = "recluster_new_lasso_selection_card",
          className = "is-violet-highlight-source",
          enabled = FALSE
        ))
      )
      session$sendCustomMessage(
        "recluster-new-toggle-class",
        modifyList(class_message, list(
          id = "recluster_new_advanced_manual_card",
          className = "is-violet-highlight-source",
          enabled = FALSE
        ))
      )
    }
    .db_dbg(
      "saved_group_card_highlight",
      sprintf("enabled=%s owner=%s group_cells=%d lasso_cells=%d", enabled, owner_now, length(group_cells), length(lasso_cells))
    )
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
    if (!.recluster_new_event_allowed("rule_selection_state")) return(invisible(NULL))
    grp <- .scalar_chr(input$recluster_new_rule_selected_group, default = "All")
    mode_now <- .scalar_chr(input$recluster_new_rule_manual_mode, default = "union")
    if (!grp %in% c("A_only", "B_only", "A_B", "Neither", "Missing", "All")) grp <- "All"
    if (!mode_now %in% c("union", "intersection")) mode_now <- "union"
    if (!identical(.scalar_chr(recluster_new_data$rule_selected_group, default = "All"), grp)) {
      recluster_new_data$rule_selected_group <- grp
    }
    if (!identical(.scalar_chr(recluster_new_data$rule_manual_combine_mode, default = "union"), mode_now)) {
      recluster_new_data$rule_manual_combine_mode <- mode_now
    }
    next_active_cells <- unique(as.character(rule_combined_cells() %||% character(0)))
    if (!identical(as.character(recluster_new_data$rule_active_cells %||% character(0)), next_active_cells)) {
      recluster_new_data$rule_active_cells <- next_active_cells
    }
    invisible(NULL)
  })

  observeEvent(input$recluster_new_tabs, {
    if (!.recluster_new_event_allowed("scatter_tab_hydrate")) return(invisible(NULL))
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
    if (!identical(scatter_x_now, x_sel)) {
      .db_update_gene_selectize("recluster_new_scatter_gene_x", all_genes, selected = x_sel)
    }
    if (!identical(scatter_y_now, y_sel)) {
      .db_update_gene_selectize("recluster_new_scatter_gene_y", all_genes, selected = y_sel)
    }
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_rule_plot_tabs, {
    if (!.recluster_new_event_allowed("rule_scatter_tab_hydrate")) return(invisible(NULL))
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
    if (!identical(scatter_x_now, x_sel)) {
      .db_update_gene_selectize("recluster_new_rule_scatter_gene_x", all_genes, selected = x_sel)
    }
    if (!identical(scatter_y_now, y_sel)) {
      .db_update_gene_selectize("recluster_new_rule_scatter_gene_y", all_genes, selected = y_sel)
    }
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_rule_umap_reduction_select, {
    if (!.recluster_new_event_allowed("rule_reduction")) return(invisible(NULL))
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return(invisible(NULL))
    red <- .scalar_chr(input$recluster_new_rule_umap_reduction_select, default = "")
    reduction_choices <- .embedding_reduction_choices(obj)
    if (!(nzchar(red) && red %in% reduction_choices)) return(invisible(NULL))
    if (identical(red, .scalar_chr(recluster_new_data$rule_reduction_choice, default = ""))) {
      return(invisible(NULL))
    }
    recluster_new_data$rule_reduction_choice <- red
    .remember_visual_settings(rule_reduction_choice = red)
    axis_choices <- .axis_index_choices(obj, red)
    if (!length(axis_choices)) return(invisible(NULL))
    axis_vals <- as.character(axis_choices)
    x_now <- .scalar_chr(input$recluster_new_rule_umap_axis_x_select, default = "")
    y_now <- .scalar_chr(input$recluster_new_rule_umap_axis_y_select, default = "")
    x_sel <- if (nzchar(x_now) && x_now %in% axis_vals) x_now else axis_vals[[1]]
    y_sel <- if (nzchar(y_now) && y_now %in% axis_vals && y_now != x_sel) y_now else if (length(axis_vals) >= 2L) axis_vals[[2]] else x_sel
    if (!identical(x_now, x_sel)) {
      updateSelectInput(session, "recluster_new_rule_umap_axis_x_select", choices = axis_choices, selected = x_sel)
    }
    if (!identical(y_now, y_sel)) {
      updateSelectInput(session, "recluster_new_rule_umap_axis_y_select", choices = axis_choices, selected = y_sel)
    }
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
    if (!.recluster_new_event_allowed("metadata_profiles")) return(invisible(NULL))
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
    if (!.recluster_new_context_is_settled()) return(NULL)
    structure_key <- recluster_new_data$metadata_selector_structure_key
    if (!nzchar(structure_key)) return(NULL)
    profiles <- isolate(recluster_new_data$metadata_profiles)
    obj_for_colors <- isolate(recluster_new_data$seurat_obj)
    if (!length(profiles)) return(helpText(RECLUSTER_NEW_UI_TEXT$t_text_no_metadata))
    object_name_now <- .recluster_new_canonical_object_name()

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
          # Mode changes alter control shape (category checkboxes vs range
          # slider). Keep mode as a direct dependency so this UI remounts only
          # for that structural transition; range/checkbox values stay
          # isolated and therefore do not remount on every value change.
          mode_choice <- .scalar_chr(input[[mode_id]], default = p$default_mode %||% "category")
          mode_now <- .resolved_mode(p, mode_choice)
          mode_selected <- if (mode_now %in% names(mode_choices)) mode_now else "category"
          core_ui <- if (identical(mode_now, "range") && isTRUE(p$numeric_like) && is.finite(p$min_val) && is.finite(p$max_val) && (p$min_val < p$max_val)) {
            range_now <- suppressWarnings(as.numeric(isolate(input[[rng_id]]) %||% c(p$min_val, p$max_val)))
            if (length(range_now) != 2L || any(!is.finite(range_now))) range_now <- c(p$min_val, p$max_val)
            range_now <- sort(pmax(p$min_val, pmin(p$max_val, range_now[seq_len(2L)])))
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
                value = range_now,
                step = max((p$max_val - p$min_val) / 200, 1e-9)
              )
            )
          } else {
            level_colors <- .level_color_map(obj_for_colors, col_name, p$levels)
            tagList(
              div(
                class = "recluster-new-metadata-color-toolbar",
                style = "display:flex;gap:6px;margin-bottom:8px;",
                actionButton(
                  "recluster_new_metadata_color_popup",
                  RECLUSTER_NEW_UI_TEXT$t_btn_metadata_customize_colors,
                  icon = .recluster_new_bootstrap_icon(
                    "palette",
                    class = "recluster-new-bootstrap-icon recluster-new-palette-icon"
                  ),
                  class = "btn btn-default btn-sm"
                ),
                actionButton(
                  "recluster_new_metadata_undo_rename",
                  RECLUSTER_NEW_UI_TEXT$t_btn_metadata_undo_rename,
                  icon = icon("undo"),
                  class = "btn btn-default btn-sm"
                )
              ),
              lapply(seq_along(p$levels), function(level_index) {
                level_name <- p$levels[[level_index]]
                checked_now <- .metadata_level_checked(col_name, level_name, isolate_input = TRUE)
                color_now <- toupper(.scalar_chr(level_colors[[level_name]], default = "#4B5563"))
                if (!.is_hex_color(color_now)) color_now <- "#4B5563"
                rename_input_id <- .metadata_level_rename_input_id(col_name, level_name, level_index)
                rename_editor_id <- paste0(rename_input_id, "__editor")
                level_focus_click <- sprintf(
                  "event.preventDefault();event.stopPropagation();Shiny.setInputValue('recluster_new_meta_level_highlight',{col:%s,level:%s,object:%s,context_revision:%s,nonce:Date.now()},{priority:'event'});return false;",
                  jsonlite::toJSON(col_name, auto_unbox = TRUE),
                  jsonlite::toJSON(level_name, auto_unbox = TRUE),
                  jsonlite::toJSON(object_name_now, auto_unbox = TRUE),
                  jsonlite::toJSON(.recluster_new_context_revision(), auto_unbox = TRUE)
                )
                level_focus_hover <- sprintf(
                  "window.__reclusterNewHoverLevel && window.__reclusterNewHoverLevel(%s,%s,%s,%s);",
                  jsonlite::toJSON(col_name, auto_unbox = TRUE),
                  jsonlite::toJSON(level_name, auto_unbox = TRUE),
                  jsonlite::toJSON(object_name_now, auto_unbox = TRUE),
                  jsonlite::toJSON(.recluster_new_context_revision(), auto_unbox = TRUE)
                )
                color_swatch_click <- sprintf(
                  "event.preventDefault();event.stopPropagation();Shiny.setInputValue('recluster_new_metadata_single_color_popup',{col:%s,level:%s,object:%s,context_revision:%s,nonce:Date.now()},{priority:'event'});return false;",
                  jsonlite::toJSON(col_name, auto_unbox = TRUE),
                  jsonlite::toJSON(level_name, auto_unbox = TRUE),
                  jsonlite::toJSON(object_name_now, auto_unbox = TRUE),
                  jsonlite::toJSON(.recluster_new_context_revision(), auto_unbox = TRUE)
                )
                rename_toggle_click <- sprintf(
                  "event.preventDefault();event.stopPropagation();var x=document.getElementById(%s);if(x){x.hidden=!x.hidden;if(!x.hidden){var i=document.getElementById(%s);if(i){i.focus();i.select();}}}return false;",
                  jsonlite::toJSON(rename_editor_id, auto_unbox = TRUE),
                  jsonlite::toJSON(rename_input_id, auto_unbox = TRUE)
                )
                rename_save_click <- sprintf(
                  "event.preventDefault();event.stopPropagation();var i=document.getElementById(%s);if(i){Shiny.setInputValue('recluster_new_metadata_level_rename',{col:%s,level:%s,value:i.value,object:%s,context_revision:%s,nonce:Date.now()},{priority:'event'});}return false;",
                  jsonlite::toJSON(rename_input_id, auto_unbox = TRUE),
                  jsonlite::toJSON(col_name, auto_unbox = TRUE),
                  jsonlite::toJSON(level_name, auto_unbox = TRUE),
                  jsonlite::toJSON(object_name_now, auto_unbox = TRUE),
                  jsonlite::toJSON(.recluster_new_context_revision(), auto_unbox = TRUE)
                )
                div(
                  class = "recluster-new-level-row",
                  style = "grid-template-columns:minmax(0,1fr) 22px;",
                  onmouseenter = level_focus_hover,
                  onmouseleave = "window.__reclusterNewClearHoverLevel && window.__reclusterNewClearHoverLevel();",
                  div(
                    class = "recluster-new-level-main",
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
                      class = "recluster-new-level-rename",
                      tags$button(
                        type = "button",
                        class = "recluster-new-level-rename-button",
                        title = RECLUSTER_NEW_UI_TEXT$t_btn_metadata_rename,
                        `aria-label` = sprintf("%s: %s", RECLUSTER_NEW_UI_TEXT$t_btn_metadata_rename, level_name),
                        onclick = rename_toggle_click,
                        .recluster_new_bootstrap_icon("input-cursor-text")
                      )
                    )
                  ),
                  div(
                    class = "recluster-new-level-color",
                    tags$span(
                      class = "recluster-new-level-color-swatch",
                      `data-metadata-color-column` = col_name,
                      `data-metadata-color-level` = level_name,
                      style = sprintf("background-color:%s;border:0;border-radius:50%%;display:inline-block;height:20px;width:20px;", color_now),
                      title = sprintf("Change %s color (%s)", level_name, color_now),
                      onclick = color_swatch_click,
                      role = "button",
                      tabindex = "0",
                      `aria-label` = sprintf("%s: %s", level_name, color_now)
                    )
                  ),
                  div(
                    id = rename_editor_id,
                    hidden = NA,
                    style = "grid-column:1 / -1;display:grid;grid-template-columns:minmax(0,1fr) auto;gap:6px;padding:3px 0 6px 26px;",
                    tags$input(
                      id = rename_input_id,
                      type = "text",
                      value = level_name,
                      class = "form-control input-sm",
                      `aria-label` = sprintf("New name for %s", level_name)
                    ),
                    tags$button(
                      type = "button",
                      class = "btn btn-primary btn-sm",
                      onclick = rename_save_click,
                      RECLUSTER_NEW_UI_TEXT$t_btn_metadata_save_rename
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
          `data-metadata-open-column` = col_name,
          open = if (identical(col_name, open_col)) NA else NULL,
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
        `data-metadata-open-bucket` = bucket_name,
        open = if (identical(bucket_name, open_bucket)) NA else NULL,
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

    div(
      class = "recluster-new-metadata-selector-root",
      `data-recluster-object-context` = object_name_now,
      `data-recluster-object-context-revision` = .recluster_new_context_revision(),
      tagList(bucket_ui)
    )
  })

  # Agent note: These outputs live inside native details. Keep them rendered
  # while collapsed so opening the fold cannot leave a blank recalculating UI.
  outputOptions(output, "recluster_new_metadata_selector_ui", suspendWhenHidden = FALSE)

  observeEvent(input$recluster_new_open_col, {
    if (!.recluster_new_event_allowed("metadata_open_column")) return(invisible(NULL))
    request <- input$recluster_new_open_col
    if (!.recluster_new_payload_context_matches(request)) return(invisible(NULL))
    col_now <- .scalar_chr(request$value, default = "")
    profiles <- recluster_new_data$metadata_profiles
    if (!nzchar(col_now) || !length(profiles) || !(col_now %in% names(profiles))) return(invisible(NULL))
    if (identical(.scalar_chr(recluster_new_data$metadata_open_column, default = ""), col_now)) return(invisible(NULL))
    old_col <- .scalar_chr(recluster_new_data$metadata_open_column, default = "")
    recluster_new_data$metadata_open_column <- col_now
    recluster_new_data$debug_meta_switch_count <- as.integer(recluster_new_data$debug_meta_switch_count %||% 0L) + 1L
    .db_dbg(
      "meta_switch",
      sprintf(
        "#%d open_col: %s -> %s",
        as.integer(recluster_new_data$debug_meta_switch_count %||% 0L),
        if (nzchar(old_col)) old_col else "<none>",
        col_now
      )
    )
    invisible(NULL)
  }, ignoreInit = TRUE, priority = 1000)

  observeEvent(recluster_new_data$metadata_open_column, {
    if (!.recluster_new_event_allowed("metadata_open_state")) return(invisible(NULL))
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
    # Metadata accordion state is independent from UMAP display/color state.
    # Opening a metadata section must never force gene expression back to
    # category coloring or rewrite the user's UMAP radio selection.
    .db_dbg("meta_open", sprintf("open_col=%s display=%s color=%s", col_now,
      .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata"),
      .scalar_chr(recluster_new_data$umap_color_choice, default = "")
    ))
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
    if (!.recluster_new_event_allowed("metadata_open_bucket")) return(invisible(NULL))
    request <- input$recluster_new_open_bucket
    if (!.recluster_new_payload_context_matches(request)) return(invisible(NULL))
    bucket_now <- .scalar_chr(request$value, default = "")
    if (nzchar(bucket_now) && !identical(.scalar_chr(recluster_new_data$metadata_open_bucket, default = ""), bucket_now)) {
      recluster_new_data$metadata_open_bucket <- bucket_now
    }
    invisible(NULL)
  }, ignoreInit = TRUE, priority = 1000)

  .metadata_filter_definition_signature <- function() {
    profiles <- isolate(recluster_new_data$metadata_profiles)
    open_col <- .scalar_chr(isolate(recluster_new_data$metadata_open_column), default = "")
    if (!length(profiles) || !nzchar(open_col) || is.null(profiles[[open_col]])) {
      return(paste("empty", open_col, sep = "::"))
    }
    profile <- profiles[[open_col]]
    mode_id <- .mode_input_id(open_col)
    mode_now <- .resolved_mode(
      profile,
      .scalar_chr(isolate(input[[mode_id]]), default = profile$default_mode %||% "category")
    )
    if (identical(mode_now, "range") && isTRUE(profile$numeric_like)) {
      range_id <- .rng_input_id(open_col)
      range_now <- suppressWarnings(as.numeric(isolate(input[[range_id]]) %||% c(profile$min_val, profile$max_val)))
      if (length(range_now) != 2L || any(!is.finite(range_now))) {
        range_now <- c(profile$min_val, profile$max_val)
      }
      return(paste(open_col, mode_now, paste(range_now, collapse = ","), sep = "::"))
    }
    levels <- as.character(profile$levels %||% character(0))
    checked <- vapply(
      levels,
      function(level_name) .metadata_level_checked(open_col, level_name, isolate_input = TRUE),
      logical(1)
    )
    paste(open_col, mode_now, paste(levels[checked], collapse = "\u001f"), sep = "::")
  }

  observeEvent(input$recluster_new_meta_level_highlight, {
    if (!.recluster_new_event_allowed("metadata_level_highlight")) return(invisible(NULL))
    payload <- input$recluster_new_meta_level_highlight
    if (!.recluster_new_payload_context_matches(payload)) return(invisible(NULL))
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
    .set_selection_owner("manual", "metadata_level_highlight")
    invisible(NULL)
  }, ignoreInit = TRUE, priority = 1100)

  observeEvent(input$recluster_new_meta_level_highlight_clear, {
    if (!.recluster_new_event_allowed("metadata_level_highlight_clear")) return(invisible(NULL))
    if (!.recluster_new_payload_context_matches(input$recluster_new_meta_level_highlight_clear, allow_empty = TRUE)) {
      return(invisible(NULL))
    }
    if (isTRUE(recluster_new_data$metadata_hover_active)) {
      recluster_new_data$metadata_hover_active <- FALSE
      recluster_new_data$selected_cells <- character(0)
      if (identical(.scalar_chr(selection_owner_state(), default = "none"), "manual") &&
          !length(lasso_selected_cells_state())) {
        .restore_selection_owner_after_manual_clear("metadata_level_highlight_clear")
      }
    }
    invisible(NULL)
  }, ignoreInit = TRUE, priority = 1090)

  metadata_filter_result <- reactive({
    structure_key <- recluster_new_data$metadata_selector_structure_key
    data_revision <- recluster_new_data$metadata_filter_data_revision
    if (!nzchar(structure_key)) return(list(cells = character(0), active_cols = character(0), group_col = "", filter_state = "all"))
    obj <- isolate(recluster_new_data$seurat_obj)
    profiles <- isolate(recluster_new_data$metadata_profiles)
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
    if (!.recluster_new_event_allowed("metadata_filter_result")) return(invisible(NULL))
    res <- metadata_filter_result()
    filter_definition_sig <- .metadata_filter_definition_signature()
    previous_filter_definition_sig <- .scalar_chr(
      isolate(recluster_new_data$metadata_filter_definition_signature),
      default = ""
    )
    filter_definition_changed <- !identical(filter_definition_sig, previous_filter_definition_sig)
    if (filter_definition_changed) {
      recluster_new_data$metadata_filter_definition_signature <- filter_definition_sig
    }
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
    if (filter_definition_changed && length(res$active_cols) &&
        !identical(filter_state_now, "all") && length(recluster_new_data$selected_cells)) {
      recluster_new_data$selected_cells <- character(0)
      .restore_selection_owner_after_manual_clear("metadata_filter_changed")
    }
  }, ignoreInit = TRUE)

  checked_population_cells <- reactive({
    # Agent note: New-object membership comes only from cyan checked saved
    # groups. Violet cells are the staging selection for saving a group and
    # must never enter a new object until that group is checked.
    selected <- unique(as.character(enabled_group_cells() %||% character(0)))
    selected <- selected[!is.na(selected) & nzchar(selected)]
    obj <- recluster_new_data$seurat_obj
    if (!is.null(obj) && inherits(obj, "Seurat")) {
      selected <- intersect(selected, colnames(obj))
    }
    selected
  })

  # Agent note: Save-group membership is intentionally limited to violet
  # highlight cells. Cyan saved-group cells are an existing display source and
  # must never become new membership merely because their checkbox is checked.
  .saved_group_capture_cells <- function() {
    selected <- unique(as.character(violet_selection_highlight_cells() %||% character(0)))
    selected <- selected[!is.na(selected) & nzchar(selected)]
    .db_dbg(
      "saved_group_capture_source",
      sprintf(
        "source=violet_highlight owner=%s cells=%d cyan_cells=%d",
        .scalar_chr(selection_owner_state(), default = "none"),
        length(selected),
        length(saved_group_highlight_cells())
      )
    )
    selected
  }

  # Agent note: Population colors use Figure Studio's popup picker. Keep the
  # metadata level order in this context so palette positions remain stable
  # if the dynamic filter UI re-renders while the modal is open.
  observeEvent(input$recluster_new_metadata_color_popup, {
    if (!.recluster_new_event_allowed("metadata_palette_open")) return(invisible(NULL))
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
      object_name = .recluster_new_canonical_object_name(),
      context_revision = .recluster_new_context_revision(),
      column = col_name,
      levels = levels,
      fallback = fallback
    )

    showModal(figure_dark_modal_dialog(
      title = sprintf("%s: %s", RECLUSTER_NEW_UI_TEXT$t_title_metadata_customize_colors, col_name),
      size = "l",
      easyClose = TRUE,
      footer = .recluster_new_contextual_picker_footer(
        reset_id = "recluster_new_metadata_palette_reset",
        apply_id = "recluster_new_metadata_palette_apply",
        apply_label = RECLUSTER_NEW_UI_TEXT$t_btn_metadata_apply_colors,
        object_name = .recluster_new_canonical_object_name(),
        context_revision = .recluster_new_context_revision()
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
    if (!.recluster_new_event_allowed("metadata_palette_apply")) return(invisible(NULL))
    apply_payload <- input$recluster_new_metadata_palette_apply
    if (!.recluster_new_payload_context_matches(apply_payload)) return(invisible(NULL))
    context <- session$userData$recluster_new_metadata_palette_context
    if (!is.list(context)) return(invisible(NULL))
    col_name <- .scalar_chr(context$column, default = "")
    levels <- as.character(context$levels %||% character(0))
    fallback <- toupper(as.character(context$fallback %||% character(0)))
    if (!nzchar(col_name) || !length(levels)) return(invisible(NULL))
    context_payload <- list(
      object = context$object_name,
      context_revision = context$context_revision
    )
    if (!.recluster_new_payload_context_matches(context_payload)) {
      showNotification("Dataset changed while color editor was open. Reopen it for current dataset.", type = "warning", duration = 6)
      session$userData$recluster_new_metadata_palette_context <- NULL
      removeModal()
      return(invisible(NULL))
    }

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
      .send_metadata_colors_to_ui(obj, col_name, levels)
      recluster_new_data$umap_color_tick <- isolate(recluster_new_data$umap_color_tick) + 1L
    }
    session$userData$recluster_new_metadata_palette_context <- NULL
    removeModal()
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_metadata_single_color_popup, {
    if (!.recluster_new_event_allowed("metadata_single_color_open")) return(invisible(NULL))
    payload <- input$recluster_new_metadata_single_color_popup
    if (!.recluster_new_payload_context_matches(payload)) return(invisible(NULL))
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
      object_name = .recluster_new_canonical_object_name(),
      context_revision = .recluster_new_context_revision(),
      column = col_name,
      level = level_name
    )
    showModal(figure_dark_modal_dialog(
      title = sprintf("Color: %s", level_name),
      size = "m",
      easyClose = TRUE,
      footer = .recluster_new_contextual_picker_footer(
        reset_id = "recluster_new_metadata_single_color_reset",
        apply_id = "recluster_new_metadata_single_color_apply",
        apply_label = "Apply color",
        object_name = .recluster_new_canonical_object_name(),
        context_revision = .recluster_new_context_revision()
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
    if (!.recluster_new_event_allowed("metadata_single_color_apply")) return(invisible(NULL))
    apply_payload <- input$recluster_new_metadata_single_color_apply
    if (!.recluster_new_payload_context_matches(apply_payload)) return(invisible(NULL))
    context <- session$userData$recluster_new_metadata_single_color_context
    if (!is.list(context)) return(invisible(NULL))
    col_name <- .scalar_chr(context$column, default = "")
    level_name <- .scalar_chr(context$level, default = "")
    context_payload <- list(
      object = context$object_name,
      context_revision = context$context_revision
    )
    if (!.recluster_new_payload_context_matches(context_payload)) {
      showNotification("Dataset changed while color editor was open. Reopen it for current dataset.", type = "warning", duration = 6)
      session$userData$recluster_new_metadata_single_color_context <- NULL
      removeModal()
      return(invisible(NULL))
    }
    obj <- recluster_new_data$seurat_obj
    profiles <- recluster_new_data$metadata_profiles
    p <- profiles[[col_name]]
    if (is.null(obj) || !inherits(obj, "Seurat") || is.null(p) || !nzchar(level_name)) {
      return(invisible(NULL))
    }
    levels <- as.character(p$levels %||% character(0))
    if (!(level_name %in% levels)) return(invisible(NULL))
    picker_payload <- metadata_single_color_picker()
    next_color <- toupper(.scalar_chr(picker_payload$hex, default = ""))
    .db_dbg(
      "metadata_single_color_apply",
      sprintf(
        "column=%s level=%s picker_hex=%s valid=%s",
        col_name,
        level_name,
        next_color,
        as.character(.is_hex_color(next_color))
      )
    )
    if (!.is_hex_color(next_color)) return(invisible(NULL))
    next_map <- .level_color_map(obj, col_name, levels)
    next_map[[level_name]] <- next_color
    obj <- .write_metadata_level_colors(obj, col_name, next_map)
    recluster_new_data$seurat_obj <- obj
    .persist_active_object(obj)
    .sync_metadata_profiles_from_object(obj)
    .send_metadata_colors_to_ui(obj, col_name, levels)
    persisted_obj <- tryCatch(shared_data$all_seurat_objects[[.recluster_new_canonical_object_name()]], error = function(e) NULL)
    persisted_obj <- if (is.list(persisted_obj) && !is.null(persisted_obj$obj)) persisted_obj$obj else persisted_obj
    persisted_map <- tryCatch(.read_metadata_level_colors(persisted_obj, col_name), error = function(e) list())
    .db_dbg(
      "metadata_single_color_persisted",
      sprintf(
        "column=%s level=%s stored=%s",
        col_name,
        level_name,
        .scalar_chr(persisted_map[[level_name]], default = "")
      )
    )
    recluster_new_data$umap_color_tick <- isolate(recluster_new_data$umap_color_tick) + 1L
    session$userData$recluster_new_metadata_single_color_context <- NULL
    removeModal()
  }, ignoreInit = TRUE)

  # Agent note: Rename history stores exact column vectors and palette entries.
  # This makes session undo deterministic without adding backup metadata columns.
  observeEvent(input$recluster_new_metadata_level_rename, {
    if (!.recluster_new_event_allowed("metadata_level_rename")) return(invisible(NULL))
    payload <- input$recluster_new_metadata_level_rename
    if (!.recluster_new_payload_context_matches(payload)) return(invisible(NULL))
    col_name <- .scalar_chr(payload$col, default = "")
    old_label <- .scalar_chr(payload$level, default = "")
    new_label <- trimws(.scalar_chr(payload$value, default = ""))
    obj <- recluster_new_data$seurat_obj

    if (!nzchar(new_label)) {
      showNotification(RECLUSTER_NEW_UI_TEXT$t_text_metadata_rename_empty, type = "warning", duration = 4)
      return(invisible(NULL))
    }
    if (!grepl("^[ -~]+$", new_label)) {
      showNotification(RECLUSTER_NEW_UI_TEXT$t_text_metadata_rename_ascii, type = "warning", duration = 4)
      return(invisible(NULL))
    }
    if (is.null(obj) || !inherits(obj, "Seurat") || !nzchar(col_name) ||
        !(col_name %in% colnames(obj@meta.data)) || !nzchar(old_label)) {
      showNotification(RECLUSTER_NEW_UI_TEXT$t_text_metadata_rename_invalid, type = "error", duration = 5)
      return(invisible(NULL))
    }
    if (identical(old_label, new_label)) return(invisible(NULL))

    old_column <- obj@meta.data[[col_name]]
    old_values <- as.character(old_column)
    old_match <- !is.na(old_values) & old_values == old_label
    if (!any(old_match)) {
      showNotification(RECLUSTER_NEW_UI_TEXT$t_text_metadata_rename_invalid, type = "error", duration = 5)
      return(invisible(NULL))
    }
    existing_labels <- unique(old_values[!is.na(old_values) & nzchar(old_values)])
    if (new_label %in% setdiff(existing_labels, old_label)) {
      showNotification(RECLUSTER_NEW_UI_TEXT$t_text_metadata_rename_duplicate, type = "warning", duration = 5)
      return(invisible(NULL))
    }

    misc_before <- tryCatch(obj@misc, error = function(e) list())
    color_store_before <- misc_before$metadata_level_colors
    had_color_entry <- is.list(color_store_before) && !is.null(color_store_before[[col_name]])
    color_entry_before <- if (had_color_entry) color_store_before[[col_name]] else NULL
    object_name <- .recluster_new_canonical_object_name()

    next_values <- old_values
    next_values[old_match] <- new_label
    if (is.factor(old_column)) {
      next_levels <- levels(old_column)
      next_levels[next_levels == old_label] <- new_label
      next_column <- factor(next_values, levels = unique(next_levels), ordered = is.ordered(old_column))
    } else {
      next_column <- next_values
    }
    obj@meta.data[[col_name]] <- next_column

    displayed_levels <- unique(old_values[!is.na(old_values) & nzchar(old_values)])
    next_colors <- .level_color_map(obj, col_name, displayed_levels)
    if (old_label %in% names(next_colors)) {
      next_colors[[new_label]] <- next_colors[[old_label]]
      next_colors[[old_label]] <- NULL
    }
    obj <- .write_metadata_level_colors(obj, col_name, next_colors)

    history <- session$userData$recluster_new_metadata_rename_history %||% list()
    history[[length(history) + 1L]] <- list(
      object_name = object_name,
      context_revision = .recluster_new_context_revision(),
      column = col_name,
      column_before = old_column,
      had_color_entry = had_color_entry,
      color_entry_before = color_entry_before
    )
    if (length(history) > 20L) history <- tail(history, 20L)
    session$userData$recluster_new_metadata_rename_history <- history

    .commit_metadata_object_update(obj, open_col = col_name)
    recluster_new_data$umap_color_tick <- isolate(recluster_new_data$umap_color_tick) + 1L
    showNotification(
      sprintf(RECLUSTER_NEW_UI_TEXT$t_text_metadata_rename_saved, old_label, new_label, col_name),
      type = "message",
      duration = 4
    )
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_metadata_undo_rename, {
    if (!.recluster_new_event_allowed("metadata_undo_rename")) return(invisible(NULL))
    history <- session$userData$recluster_new_metadata_rename_history %||% list()
    if (!length(history)) {
      showNotification(RECLUSTER_NEW_UI_TEXT$t_text_metadata_rename_no_undo, type = "message", duration = 3)
      return(invisible(NULL))
    }
    item <- history[[length(history)]]
    object_name <- .recluster_new_canonical_object_name()
    item_revision <- suppressWarnings(as.integer(item$context_revision %||% NA_integer_))
    if (!identical(.scalar_chr(item$object_name, default = ""), object_name) ||
        !is.finite(item_revision) || is.na(item_revision) ||
        !identical(item_revision, .recluster_new_context_revision())) {
      showNotification(RECLUSTER_NEW_UI_TEXT$t_text_metadata_rename_wrong_object, type = "warning", duration = 5)
      return(invisible(NULL))
    }
    obj <- recluster_new_data$seurat_obj
    col_name <- .scalar_chr(item$column, default = "")
    if (is.null(obj) || !inherits(obj, "Seurat") || !(col_name %in% colnames(obj@meta.data)) ||
        length(item$column_before) != nrow(obj@meta.data)) {
      showNotification(RECLUSTER_NEW_UI_TEXT$t_text_metadata_rename_invalid, type = "error", duration = 5)
      return(invisible(NULL))
    }

    obj@meta.data[[col_name]] <- item$column_before
    misc <- tryCatch(obj@misc, error = function(e) list())
    if (!is.list(misc$metadata_level_colors)) misc$metadata_level_colors <- list()
    if (isTRUE(item$had_color_entry)) {
      misc$metadata_level_colors[[col_name]] <- item$color_entry_before
    } else {
      misc$metadata_level_colors[[col_name]] <- NULL
    }
    obj@misc <- misc
    obj <- .strip_metadata_color_mirror_columns(obj)

    session$userData$recluster_new_metadata_rename_history <- history[-length(history)]
    .commit_metadata_object_update(obj, open_col = col_name)
    recluster_new_data$umap_color_tick <- isolate(recluster_new_data$umap_color_tick) + 1L
    showNotification(
      sprintf(RECLUSTER_NEW_UI_TEXT$t_text_metadata_rename_undone, col_name),
      type = "message",
      duration = 4
    )
  }, ignoreInit = TRUE)


  output$recluster_new_metadata_status_output <- renderText({
    active_col <- .scalar_chr(recluster_new_data$metadata_active_column, default = "")
    if (!nzchar(active_col)) {
      sprintf("%s %s", RECLUSTER_NEW_UI_TEXT$t_text_selection_source, RECLUSTER_NEW_UI_TEXT$t_text_selection_none)
    } else {
      sprintf("%s %s", RECLUSTER_NEW_UI_TEXT$t_text_selection_source, active_col)
    }
  })
  outputOptions(output, "recluster_new_metadata_status_output", suspendWhenHidden = FALSE)

  observeEvent(input$recluster_new_add_selection_btn, {
    if (!.recluster_new_event_allowed("saved_group_add")) return(invisible(NULL))
    group_name <- trimws(.scalar_chr(input$recluster_new_group_name, default = ""))
    if (!nzchar(group_name)) {
      showNotification("Group name cannot be empty.", type = "warning", duration = 4)
      return(invisible(NULL))
    }

    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) {
      .db_dbg(
        "saved_group_add_rejected",
        sprintf("object=%s reason=missing_seurat", .recluster_new_canonical_object_name())
      )
      showNotification("Selected dataset is not ready. Wait for the plot to finish loading, then try again.", type = "error", duration = 6)
      return(invisible(NULL))
    }

    cells <- intersect(.saved_group_capture_cells(), colnames(obj))
    if (!length(cells)) {
      showNotification("Select violet cells before saving a group.", type = "warning", duration = 4)
      return(invisible(NULL))
    }

    render_pending <- FALSE
    try(overlay_show("Saving population group and updating plot..."), silent = TRUE)
    on.exit({
      if (!isTRUE(render_pending)) try(overlay_hide(), silent = TRUE)
    }, add = TRUE)

    .db_dbg(
      "saved_group_add_start",
      sprintf(
        "object=%s name=%s cells=%d lasso=%d checked=%d",
        .recluster_new_canonical_object_name(),
        group_name,
        length(cells),
        length(lasso_selected_cells_state()),
        length(checked_population_cells())
      )
    )

    # Agent note: Save metadata and group state as one object transaction.
    # Set local group state before persistence so shared and local object-owned
    # state remain identical; otherwise reconciliation reloads the object and
    # clears the selection before the new group can be displayed.
    groups_now <- recluster_new_data$cell_groups %||% list()
    groups_now <- lapply(groups_now, function(group) {
      group$enabled <- FALSE
      group
    })
    md <- obj@meta.data
    md <- .sparsify_saved_group_metadata(md, groups_now)
    new_col <- .unique_metadata_col_name(md, group_name, prefix = "saved_group")
    md[[new_col]] <- NA_character_
    md[rownames(md) %in% cells, new_col] <- group_name
    obj@meta.data <- md
    groups_now[[group_name]] <- list(cells = cells, enabled = TRUE, metadata_col = new_col)
    .set_cell_groups_structure(groups_now)
    .commit_metadata_object_update(obj, open_col = new_col)
    .clear_final_plot_cache()
    plot_tab_now <- .norm_plot_tab(.current_plot_tab())
    if (plot_tab_now %in% c("umap", "scatter")) {
      render_pending <- isTRUE(.recluster_new_overlay_begin(
        "Updating plot after saving population group...",
        tab_now = plot_tab_now,
        reason = "saved_group_add"
      ))
    }
    .db_dbg(
      "saved_group_add_commit",
      sprintf(
        "object=%s name=%s metadata_col=%s cells=%d previous_groups_disabled=%d",
        .recluster_new_canonical_object_name(),
        group_name,
        new_col,
        length(cells),
        length(groups_now) - 1L
      )
    )
    showNotification(sprintf("Saved group and wrote metadata column '%s'.", new_col), type = "message", duration = 4)
    updateTextInput(session, "recluster_new_group_name", value = "")
    # Saving transfers transient selection into the new cyan group. Clear
    # transient manual state explicitly; do not depend on Plotly sending a
    # NULL selection event, because NULL also occurs during ordinary redraws.
    .set_selection_owner("manual", "saved_group_add")
    lasso_selected_cells_state(character(0))
    recluster_new_data$selected_cells <- character(0)
    recluster_new_data$metadata_hover_active <- FALSE
    runjs("Shiny.setInputValue('plotly_selected-recluster_new_plot_source', null);")
  })

  output$recluster_new_cell_groups_ui <- renderUI({
    if (!.recluster_new_context_is_settled()) return(NULL)
    structure_key <- recluster_new_data$cell_groups_structure_key
    groups <- isolate(recluster_new_data$cell_groups)
    if (!length(groups)) return(p(RECLUSTER_NEW_UI_TEXT$t_text_no_groups))

    rows <- lapply(names(groups), function(name) {
      g <- groups[[name]]
      enabled_id <- .grp_toggle_input_id(name)
      delete_id <- .grp_delete_input_id(name)
      enabled <- isTRUE(g$enabled)
      enabled_checkbox <- htmltools::tagQuery(
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
      )$find("input")$addAttrs(
        autocomplete = "off",
        `data-wl-autofill-guard` = "true"
      )$allTags()

      div(
        class = "recluster-new-group-row",
        div(
          class = "recluster-new-group-toggle",
          `data-recluster-saved-group-canonical-enabled` = if (enabled) "1" else "0",
          enabled_checkbox
        ),
        actionButton(delete_id, "", icon = icon("trash"), class = "btn recluster-new-saved-group-delete", title = RECLUSTER_NEW_UI_TEXT$t_btn_delete)
      )
    })

    tagList(rows)
  })

  # Agent note: Checkbox enabled state is value-only state. Keep group DOM
  # mounted while it changes; only add/delete/cell membership changes update
  # cell_groups_structure_key and rebuild this UI.
  group_toggle_observers <- list()
  observe({
    if (!.recluster_new_event_allowed("saved_group_observer_sync")) return(invisible(NULL))
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
          enabled = observeEvent(input$recluster_new_saved_group_toggle_event, {
            if (!.recluster_new_event_allowed(paste0("saved_group_toggle:", name))) return(invisible(NULL))
            payload <- input$recluster_new_saved_group_toggle_event
            if (!is.list(payload) || !identical(.scalar_chr(payload$id, default = ""), enabled_id)) {
              return(invisible(NULL))
            }
            if (!.recluster_new_payload_context_matches(payload, allow_empty = TRUE)) {
              .db_dbg(
                "saved_group_toggle_ignored_context",
                sprintf("name=%s id=%s", name, .scalar_chr(payload$id, default = ""))
              )
              return(invisible(NULL))
            }
            g <- recluster_new_data$cell_groups[[name]]
            if (is.null(g)) return(invisible(NULL))
            next_enabled <- isTRUE(payload$enabled)
            if (identical(isTRUE(g$enabled), next_enabled)) return(invisible(NULL))
            g$enabled <- next_enabled
            groups_now <- recluster_new_data$cell_groups %||% list()
            groups_now[[name]] <- g
            recluster_new_data$cell_groups <- groups_now
            if (!is.null(recluster_new_data$seurat_obj) && inherits(recluster_new_data$seurat_obj, "Seurat")) {
              .persist_active_object(recluster_new_data$seurat_obj, update_local = TRUE)
            }
            if (next_enabled) {
              .set_selection_owner("manual", paste0("saved_group_toggle:", name))
            } else {
              .restore_selection_owner_after_manual_clear(paste0("saved_group_toggle:", name))
            }
          }, ignoreInit = TRUE),
          delete = observeEvent(input[[delete_id]], {
            if (!.recluster_new_event_allowed(paste0("saved_group_delete:", name))) return(invisible(NULL))
            g <- recluster_new_data$cell_groups[[name]]
            groups_now <- recluster_new_data$cell_groups %||% list()
            groups_now[[name]] <- NULL
            .set_cell_groups_structure(groups_now)
            obj <- recluster_new_data$seurat_obj
            persisted_by_metadata_commit <- FALSE
            if (!is.null(obj) && inherits(obj, "Seurat")) {
              md <- obj@meta.data
              meta_col <- .saved_group_metadata_col(name, g, md)
              if (nzchar(meta_col) && meta_col %in% colnames(md)) {
                md[[meta_col]] <- NULL
                obj@meta.data <- md
                .commit_metadata_object_update(obj)
                persisted_by_metadata_commit <- TRUE
                showNotification(sprintf("Deleted saved group metadata column '%s'.", meta_col), type = "message", duration = 3)
              }
              # A group can be object-owned without a legacy metadata mirror.
              # Persist deletion in that case too; otherwise the group returns
              # after the next object reload/workspace import.
              if (!isTRUE(persisted_by_metadata_commit)) {
                .persist_active_object(obj, update_local = TRUE)
              }
            }
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
    if (!.recluster_new_context_is_settled()) {
      return(datatable(data.frame(note = "Loading selected dataset..."), rownames = FALSE, options = list(dom = "t")))
    }
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
    if (!.recluster_new_event_allowed("metadata_duplicate_column")) return(invisible(NULL))
    obj <- recluster_new_data$seurat_obj
    req(obj)
    src <- .scalar_chr(input$recluster_new_source_col, default = "")
    new_col <- .scalar_chr(input$recluster_new_new_col, default = "")
    req(nzchar(src), src %in% colnames(obj@meta.data), nzchar(new_col))
    md <- obj@meta.data
    out_col <- .ensure_unique_col(md, new_col)
    md[[out_col]] <- as.character(md[[src]])
    obj@meta.data <- md
    .commit_metadata_object_update(obj, open_col = out_col)
    showNotification(sprintf("Created duplicated column: %s", out_col), type = "message")
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_create_col_btn, {
    if (!.recluster_new_event_allowed("metadata_create_column")) return(invisible(NULL))
    obj <- recluster_new_data$seurat_obj
    req(obj)
    new_col <- .scalar_chr(input$recluster_new_new_col, default = "")
    req(nzchar(new_col))
    md <- obj@meta.data
    out_col <- .ensure_unique_col(md, new_col)
    md[[out_col]] <- NA_character_
    obj@meta.data <- md
    .commit_metadata_object_update(obj, open_col = out_col)
    showNotification(sprintf("Created empty column: %s", out_col), type = "message")
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_apply_group_label_btn, {
    if (!.recluster_new_event_allowed("metadata_apply_group_label")) return(invisible(NULL))
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
    .commit_metadata_object_update(obj, open_col = out_col)
    showNotification(sprintf("Updated %d cells in %s.", sum(idx), out_col), type = "message")
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_apply_cell_label_btn, {
    if (!.recluster_new_event_allowed("metadata_apply_cell_label")) return(invisible(NULL))
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
    .commit_metadata_object_update(obj, open_col = out_col)
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
    selected_now <- as.character(isolate(input$recluster_new_sidebar_barcode_paths) %||% character(0))
    selected_now <- intersect(selected_now, unname(choices))
    selectizeInput(
      "recluster_new_sidebar_barcode_paths",
      RECLUSTER_NEW_UI_TEXT$t_label_sidebar_barcodes,
      choices = choices,
      selected = selected_now,
      multiple = TRUE,
      options = list(plugins = list("remove_button"), placeholder = "Choose imported barcode files")
    )
  })

  observeEvent(shared_data$selected_sidebar_items, {
    if (!.recluster_new_event_allowed("sidebar_selection_import")) return(invisible(NULL))
    items <- shared_data$selected_sidebar_items
    if (is.null(items) || !is.data.frame(items) || !nrow(items)) return(invisible(NULL))
    keys <- as.character(items$key %||% character(0))
    paths <- sub("^csv::", "", keys[grepl("^csv::", keys)])
    if (!length(paths)) return(invisible(NULL))
    current <- as.character(input$recluster_new_sidebar_barcode_paths %||% character(0))
    next_selected <- unique(c(current, paths))
    if (!identical(current, next_selected)) {
      # This control already owns its complete choices in the mounted UI.
      # Updating only its selected values must not clear the catalog and start
      # an asynchronous server-side Selectize reload.
      updateSelectizeInput(session, "recluster_new_sidebar_barcode_paths", selected = next_selected, server = FALSE)
    }
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
    .set_selection_owner("manual", "barcode_import")
    showNotification(sprintf("Imported %d barcodes from %s. Matched %d cell(s).", length(barcodes), source_label, length(matched)), type = "message")
    invisible(TRUE)
  }

  observeEvent(input$recluster_new_import_barcodes_file, {
    if (!.recluster_new_event_allowed("sidebar_barcode_file")) return(invisible(NULL))
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
    if (!.recluster_new_event_allowed("sidebar_barcode_import")) return(invisible(NULL))
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
    if (!.recluster_new_event_allowed("metadata_file")) return(invisible(NULL))
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
    recluster_new_latest_import(data.frame())
    recluster_new_import_match_object("")
    recluster_new_import_match_revision(NA_integer_)
    invisible(NULL)
  }, ignoreInit = TRUE)

  output$recluster_new_import_preview_table <- renderDT({
    df <- .import_df()
    if (is.null(df)) return(datatable(data.frame(note = "No import file loaded yet."), rownames = FALSE, options = list(dom = "t")))
    datatable(utils::head(df, 200), class = "compact nowrap", rownames = FALSE, options = list(dom = "t", scrollX = TRUE, autoWidth = TRUE, scrollCollapse = TRUE, pageLength = 8, ordering = FALSE, searching = FALSE, info = FALSE))
  }, server = TRUE)

  observeEvent(input$recluster_new_run_match_btn, {
    if (!.recluster_new_event_allowed("metadata_match")) return(invisible(NULL))
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
    recluster_new_import_match_object(.recluster_new_canonical_object_name())
    recluster_new_import_match_revision(.recluster_new_context_revision())
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
    if (!.recluster_new_event_allowed("metadata_match_edit")) return(invisible(NULL))
    info <- input$recluster_new_import_resolution_table_cell_edit
    match_object <- .scalar_chr(recluster_new_import_match_object(), default = "")
    match_revision <- suppressWarnings(as.integer(recluster_new_import_match_revision() %||% NA_integer_))
    if (!nzchar(match_object) || !identical(match_object, .recluster_new_canonical_object_name()) ||
        is.na(match_revision) || !is.finite(match_revision) ||
        !identical(match_revision, .recluster_new_context_revision())) {
      showNotification("Dataset changed since barcode matching. Run matching again for current dataset.", type = "warning", duration = 6)
      return(invisible(NULL))
    }
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
    if (!.recluster_new_event_allowed("metadata_import_apply")) return(invisible(NULL))
    obj <- recluster_new_data$seurat_obj
    req(obj)
    raw_df <- .import_df()
    req(raw_df)
    mdf <- .import_match()
    req(is.data.frame(mdf), nrow(mdf) > 0)
    match_object <- .scalar_chr(recluster_new_import_match_object(), default = "")
    match_revision <- suppressWarnings(as.integer(recluster_new_import_match_revision() %||% NA_integer_))
    current_object <- .recluster_new_canonical_object_name()
    if (!nzchar(match_object) || !identical(match_object, current_object) ||
        is.na(match_revision) || !is.finite(match_revision) ||
        !identical(match_revision, .recluster_new_context_revision())) {
      showNotification("Dataset changed since barcode matching. Run matching again for current dataset.", type = "error", duration = 8)
      return(invisible(NULL))
    }
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
    .commit_metadata_object_update(obj)
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

  manual_selection_cells <- reactive({
    unique(c(
      as.character(lasso_selected_cells_state() %||% character(0)),
      as.character(recluster_new_data$selected_cells %||% character(0)),
      as.character(enabled_group_cells() %||% character(0))
    ))
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
    assay_now <- .expr_assay_name(obj)
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

  observe({
    if (!.recluster_new_event_allowed("expression_summary_sync")) return(invisible(NULL))
    state <- .expr_state_normalize(recluster_new_data$expr_selection)
    result <- expression_group_cells_result()
    group_cells <- result$group_cells %||% list()
    summaries <- list()
    gene_details <- list()
    obj <- recluster_new_data$seurat_obj
    base_cells <- if (!is.null(obj) && inherits(obj, "Seurat")) {
      if (isTRUE(state$inherit_population)) .expr_base_population_cells() else colnames(obj)
    } else {
      character(0)
    }
    for (g in state$groups %||% list()) {
      gid <- .scalar_chr(g$id, default = "")
      if (!nzchar(gid)) next
      genes <- g$genes %||% list()
      checked_n <- sum(vapply(genes, function(gr) isTRUE(gr$checked), logical(1)))
      summaries[[gid]] <- if (length(genes)) {
        sprintf("%d genes, %d cells", checked_n, length(group_cells[[gid]] %||% character(0)))
      } else {
        RECLUSTER_NEW_UI_TEXT$t_text_expr_group_summary_empty
      }
      for (gr in genes) {
        gene_id <- .scalar_chr(gr$id, default = "")
        if (!nzchar(gene_id)) next
        gene_cells <- if (!length(base_cells)) {
          character(0)
        } else {
          .expr_gene_cells(gr, base_cells = base_cells, obj = obj)
        }
        gene_details[[.expr_gene_detail_id(gid, gene_id)]] <- list(
          count_text = sprintf("%d cells", length(gene_cells)),
          range_text = .expr_format_range(gr$range)
        )
      }
    }
    object_name_now <- .recluster_new_canonical_object_name()
    session$sendCustomMessage(
      "recluster-new-expression-summaries",
      list(
        object = object_name_now,
        context_revision = .recluster_new_context_revision(),
        summaries = summaries
      )
    )
    session$sendCustomMessage(
      "recluster-new-expression-gene-details",
      list(
        object = object_name_now,
        context_revision = .recluster_new_context_revision(),
        details = gene_details
      )
    )
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
    owner_now <- .scalar_chr(selection_owner_state(), default = "none")

    if (length(visible)) {
      manual_cells <- intersect(manual_cells, visible)
    } else if (isTRUE(state$inherit_population)) {
      manual_cells <- character(0)
    }

    expr_result <- expression_selection_result()
    if (identical(owner_now, "expression")) {
      expr_cells <- unique(as.character(expr_result$cells %||% character(0)))
      if (isTRUE(state$inherit_population)) {
        selected <- if (length(visible)) intersect(expr_cells, visible) else character(0)
      } else {
        selected <- expr_cells
      }
    } else if (identical(owner_now, "manual")) {
      # Agent note: Manual selection sources are additive. A checked saved
      # group and a lasso/manual selection must both remain available for
      # highlighting and for the new-object payload.
      selected <- unique(c(group_cells, manual_cells))
    } else {
      selected <- visible
    }
    selected[nzchar(selected)]
  })

  saved_group_highlight_cells <- reactive({
    if (identical(.scalar_chr(recluster_new_data$umap_display_mode, default = "metadata"), "gene")) {
      return(character(0))
    }
    cells <- unique(as.character(enabled_group_cells() %||% character(0)))
    cells[!is.na(cells) & nzchar(cells)]
  })

  violet_selection_highlight_cells <- reactive({
    if (identical(.scalar_chr(recluster_new_data$umap_display_mode, default = "metadata"), "gene")) {
      return(character(0))
    }
    lasso_cells <- as.character(lasso_selected_cells() %||% character(0))
    manual_cells <- as.character(recluster_new_data$selected_cells %||% character(0))
    owner_now <- .scalar_chr(selection_owner_state(), default = "none")
    expr_state <- .expr_state_normalize(recluster_new_data$expr_selection)
    cells <- if (identical(owner_now, "expression")) {
      expr_cells <- as.character(expression_selection_result()$cells %||% character(0))
      if (isTRUE(expr_state$inherit_population)) {
        visible <- .visible_umap_cells()
        if (length(visible)) intersect(expr_cells, visible) else character(0)
      } else {
        expr_cells
      }
    } else if (identical(owner_now, "manual")) {
      unique(c(lasso_cells, manual_cells))
    } else if (identical(
      .scalar_chr(recluster_new_data$metadata_filter_state, default = "all"),
      "partial"
    )) {
      as.character(metadata_filter_result()$cells %||% character(0))
    } else {
      character(0)
    }
    cells <- unique(as.character(cells %||% character(0)))
    cells[!is.na(cells) & nzchar(cells)]
  })

  selection_highlight_cells <- reactive({
    unique(c(saved_group_highlight_cells(), violet_selection_highlight_cells()))
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

    display_mode <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
    umap_gene_info <- if (identical(display_mode, "gene")) {
      .umap_gene_selection()
    } else {
      list(channels = c("", "", ""), genes = character(0), multi = FALSE)
    }
    gene_input_1 <- if (length(umap_gene_info$genes)) umap_gene_info$genes[[1]] else ""
    violin_gene <- gene_input_1
    effective_gene_1 <- .scalar_chr(gene_input_1, default = violin_gene)
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
    plot_df$selection_saved_group <- FALSE
    plot_df$selection_violet <- FALSE
    population_cells <- .visible_umap_cells()

    # Agent note: Keep every embedding cell in the plot. Metadata checkboxes
    # define the highlighted population and the subset payload; removing all
    # unchecked cells makes a checked population look like an ordinary plot and
    # prevents users from visually verifying what will enter the new object.
    if (isTRUE(.db_diag_enabled)) {
      message(sprintf("[DB_UMAP_DBG][%s][data_browser_population_overlay] emb_cells=%d | plot_df_rows=%d | checked_cells=%d | open_col=%s",
        format(Sys.time(), "%H:%M:%OS3"), length(emb_cells), nrow(plot_df), length(population_cells),
        .scalar_chr(recluster_new_data$metadata_open_column, default = "<empty>")
      ))
    }

    if (!nrow(plot_df)) {
      plot_df$cell_id <- character(0)
      return(plot_df)
    }

    saved_group_cells_now <- saved_group_highlight_cells()
    violet_cells_now <- violet_selection_highlight_cells()
    saved_group_hit <- intersect(saved_group_cells_now, rownames(plot_df))
    violet_hit <- intersect(violet_cells_now, rownames(plot_df))
    selected_cells_now <- unique(c(saved_group_hit, violet_hit))
    if (length(saved_group_hit)) {
      plot_df[saved_group_hit, "selection_saved_group"] <- TRUE
    }
    if (length(violet_hit)) {
      plot_df[violet_hit, "selection_violet"] <- TRUE
    }
    if (length(selected_cells_now)) {
      plot_df[selected_cells_now, "selection_status"] <- "Selected"
      plot_df[selected_cells_now, "selection_selected"] <- TRUE
    }
    .db_dbg(
      "umap_selection_overlay",
      sprintf(
        "owner=%s cyan_cells=%d violet_cells=%d combined_cells=%d",
        .scalar_chr(selection_owner_state(), default = "none"),
        length(saved_group_hit),
        length(violet_hit),
        length(selected_cells_now)
      )
    )
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
    tryCatch({
      if (!.recluster_new_event_allowed("umap_cache_render")) return(invisible(NULL))
      # Overlay requests are explicit invalidation events. This guarantees a
      # post-settlement request reruns the renderer even when plot inputs did
      # not otherwise change during the page transition.
      overlay_request_id <- recluster_new_overlay_request_id()
      if (!identical(.current_plot_tab(), "umap")) {
        return(invisible(NULL))
      }
      plot_cache_sig <- .umap_plot_cache_signature()
      stored_sig <- isolate(recluster_new_data$umap_plot_cache_sig)
      stored_cache <- isolate(recluster_new_data$umap_plot_cache)
      if (isTRUE(.db_diag_enabled) && !identical(plot_cache_sig, stored_sig) && nzchar(plot_cache_sig) && nzchar(stored_sig)) {
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
        .recluster_new_overlay_finish("umap", status = "ready", reason = "cache_render")
        return(invisible(NULL))
      }
      .db_dbg("umap_render", sprintf("request=%s sig=%s", as.character(overlay_request_id), substr(plot_cache_sig, 1L, 220L)))

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
        .recluster_new_overlay_finish("umap", status = "ready", reason = "empty_render")
        return(invisible(NULL))
      }

    umap_gene_info <- .umap_gene_selection()
    display_mode <- .scalar_chr(recluster_new_data$umap_display_mode, default = "metadata")
    color_by <- if (identical(display_mode, "gene") && length(umap_gene_info$genes)) "Single Gene Expression" else .active_umap_metadata_col()
    x_title <- .scalar_chr(plot_df$embedding_x_title, default = "UMAP_1")
    y_title <- .scalar_chr(plot_df$embedding_y_title, default = "UMAP_2")
    split_by <- .scalar_chr(input$recluster_new_split_by_select, default = "None")
    violin_gene <- if (length(umap_gene_info$genes)) umap_gene_info$genes[[1]] else ""

    visual_settings <- .current_visual_settings()
    dot_size <- suppressWarnings(as.numeric(visual_settings$dot_size %||% input$recluster_new_dot_size %||% 1.0))
    dot_alpha <- suppressWarnings(as.numeric(input$recluster_new_dot_alpha %||% 0.8))
    highlight_stroke_alpha <- suppressWarnings(as.numeric(visual_settings$stroke_width %||% input$recluster_new_stroke_width %||% 0.1))
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
    saved_group_highlight_color <- "#06B6D4"
    violet_selection_highlight_color <- "#7C3AED"

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
        key = .plotly_selection_keys(df_use$cell_id),
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

      # Agent note: Keep saved-group cyan and other-selection violet in separate
      # traces. Violet is drawn second when cell sets overlap so an active lasso
      # or expression selection remains visible without changing saved membership.
      saved_group_panel <- df_panel[df_panel$selection_saved_group %in% TRUE, , drop = FALSE]
      violet_panel <- df_panel[df_panel$selection_violet %in% TRUE, , drop = FALSE]
      active_panel <- df_panel[df_panel$selection_status == "ActiveGene", , drop = FALSE]
      if (nrow(saved_group_panel)) {
        p <- .add_marker_trace(
          p, saved_group_panel,
          marker_list = list(
            symbol = "circle",
            color = saved_group_highlight_color,
            size = highlight_size,
            opacity = 0.82,
            line = list(width = 0)
          ),
          name = "Saved group",
          show_legend = FALSE
        )
      }
      if (nrow(violet_panel)) {
        p <- .add_marker_trace(
          p, violet_panel,
          marker_list = list(
            symbol = "circle",
            color = violet_selection_highlight_color,
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
        .recluster_new_overlay_finish("umap", status = "ready", reason = "split_render")
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
      .recluster_new_overlay_finish("umap", status = "ready", reason = "render")
      invisible(NULL)
    }, error = function(e) {
      error_text <- conditionMessage(e)
      if (inherits(e, "shiny.silent.error")) {
        .db_dbg("umap_render_validation_return", sprintf("message=%s", substr(error_text, 1L, 500L)))
        .recluster_new_overlay_finish("umap", status = "cancelled", reason = "validation_return")
        return(invisible(NULL))
      }
      .db_dbg("umap_render_error", sprintf("message=%s", substr(error_text, 1L, 500L)))
      message(sprintf("[DB_UMAP_ERR][%s] %s", format(Sys.time(), "%H:%M:%OS3"), error_text))
      umap_plot_rendered(.recluster_new_error_plot(error_text, source = "recluster_new_plot_source"))
      .recluster_new_overlay_finish("umap", status = "error", reason = "umap_render_error")
      invisible(NULL)
    })
  })

  output$recluster_new_umap_plot <- renderPlotly({
    if (!identical(.current_plot_tab(), "umap")) {
      return(
        plot_ly(source = "recluster_new_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0)) %>%
          .plotly_touch_zoom()
      )
    }
    if (!.recluster_new_context_is_settled()) return(.recluster_new_empty_plot("recluster_new_plot_source"))
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
    # Release page-level lock from server render completion. DOM polling cannot
    # distinguish hidden outputs from failed outputs and can freeze interaction.
    on.exit({
      if (isTRUE(.recluster_new_context_is_settled()) &&
          identical(.current_plot_tab(), "scatter")) {
        .recluster_new_overlay_finish("scatter", status = "ready", reason = "scatter_render")
      }
    }, add = TRUE)
    if (!identical(.current_plot_tab(), "scatter")) {
      return(
        plot_ly(source = "recluster_new_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0)) %>%
          .plotly_touch_zoom()
      )
    }
    if (!.recluster_new_context_is_settled()) return(.recluster_new_empty_plot("recluster_new_plot_source"))
    gene_x_now <- .scalar_chr(input$recluster_new_scatter_gene_x, default = "")
    gene_y_now <- .scalar_chr(input$recluster_new_scatter_gene_y, default = "")
    if (!nzchar(gene_x_now) || !nzchar(gene_y_now)) {
      return(
        plot_ly(source = "recluster_new_plot_source") %>%
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

    plot_ly(source = "recluster_new_plot_source") %>%
      add_trace(
        type = "scattergl",
        mode = "markers",
        x = plot_df[[gene_x]],
        y = plot_df[[gene_y]],
        key = .plotly_selection_keys(plot_df$cell_id),
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
    if (!.recluster_new_event_allowed("rule_overlap_state")) return(invisible(NULL))
    rdf <- rule_overlap_df()
    grp <- as.character(rdf$overlap_group %||% character(0))
    names(grp) <- as.character(rdf$cell_id %||% character(0))
    if (!identical(recluster_new_data$rule_overlap_group, grp)) {
      recluster_new_data$rule_overlap_group <- grp
    }
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
    red_sel <- .current_rule_reduction(obj)
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
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0)) %>%
          .plotly_touch_zoom()
      )
    }
    if (!.recluster_new_context_is_settled()) return(.recluster_new_empty_plot("recluster_new_rule_plot_source"))
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
          key = .plotly_selection_keys(df_lv$cell_id),
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
          key = .plotly_selection_keys(bg_df$cell_id),
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
          key = .plotly_selection_keys(fg_df$cell_id),
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
      event_register("plotly_doubleclick") %>%
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
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0)) %>%
          .plotly_touch_zoom()
      )
    }
    if (!.recluster_new_context_is_settled()) return(.recluster_new_empty_plot("recluster_new_rule_plot_source"))
    gene_x <- .scalar_chr(input$recluster_new_rule_scatter_gene_x, default = "")
    gene_y <- .scalar_chr(input$recluster_new_rule_scatter_gene_y, default = "")
    if (!nzchar(gene_x) || !nzchar(gene_y)) {
      return(
        plot_ly(source = "recluster_new_rule_plot_source") %>%
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
        key = .plotly_selection_keys(plot_df$cell_id),
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
        key = .plotly_selection_keys(sel_df$cell_id),
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
      event_register("plotly_selected") %>%
      event_register("plotly_doubleclick") %>%
      .plotly_touch_zoom()
  })

  output$recluster_new_rule_stacked_plot <- renderPlotly({
    if (!.db_tab_is_active()) {
      return(
        plot_ly(source = "recluster_new_rule_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0)) %>%
          .plotly_touch_zoom()
      )
    }
    if (!identical(.current_expr_tab(), "stacked")) {
      return(
        plot_ly(source = "recluster_new_rule_plot_source") %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0)) %>%
          .plotly_touch_zoom()
      )
    }
    if (!.recluster_new_context_is_settled()) return(.recluster_new_empty_plot("recluster_new_rule_plot_source"))
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
      source = "recluster_new_rule_plot_source",
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
        xaxis = list(title = group_col, automargin = TRUE, tickangle = -45),
        yaxis = list(title = "Percent of cells", ticksuffix = "%", range = c(0, 100)),
        legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.32, yanchor = "top"),
        margin = list(l = 60, r = 20, t = 20, b = 145)
      ) %>%
      .plotly_touch_zoom()
  })

  .pseudobulk_table_data <- reactiveVal(NULL)

  .pb_run_context <- reactive({
    if (!.recluster_new_context_is_settled()) {
      return(list(valid = FALSE, reason = "Selected dataset is still loading."))
    }
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
    if (!.recluster_new_context_is_settled()) return(NULL)
    x <- .pb_run_context()
    if (!isTRUE(x$valid)) return(helpText(x$reason %||% "Pseudobulk context is not ready."))
    if (identical(.scalar_chr(x$mode, default = ""), "per_cluster_vs_rest")) {
      return(helpText("Auto mode: all levels in current active cluster layer will run as cluster vs rest."))
    }
    if (identical(.scalar_chr(x$mode, default = ""), "selected_cluster_vs_remaining")) {
      return(helpText("Auto mode: each selected cluster will run against the remaining selected clusters."))
    }
    lbl <- paste0(RECLUSTER_NEW_UI_TEXT$t_label_pb_level_a, " (", x$level_label %||% "Level", ")")
    selected <- .scalar_chr(isolate(input$recluster_new_pb_level_a), default = "")
    if (!(selected %in% x$levels)) selected <- x$levels[[1]]
    selectInput("recluster_new_pb_level_a", lbl, choices = x$levels, selected = selected)
  })

  output$recluster_new_pb_level_b_ui <- renderUI({
    if (!.recluster_new_context_is_settled()) return(NULL)
    x <- .pb_run_context()
    if (!isTRUE(x$valid)) return(NULL)
    if (identical(.scalar_chr(x$mode, default = ""), "cluster_set_vs_rest")) return(NULL)
    if (identical(.scalar_chr(x$mode, default = ""), "per_cluster_vs_rest")) return(NULL)
    if (identical(.scalar_chr(x$mode, default = ""), "selected_cluster_vs_remaining")) return(NULL)
    selected <- if (length(x$levels) > 1) x$levels[[2]] else x$levels[[1]]
    current <- .scalar_chr(isolate(input$recluster_new_pb_level_b), default = "")
    if (current %in% x$levels && !identical(current, selected)) selected <- current
    lbl <- paste0(RECLUSTER_NEW_UI_TEXT$t_label_pb_level_b, " (", x$level_label %||% "Level", ")")
    selectInput("recluster_new_pb_level_b", lbl, choices = x$levels, selected = selected)
  })

  observeEvent(input$recluster_new_pb_open_analysis_btn, {
    if (!.recluster_new_event_allowed("pseudobulk_open_analysis")) return(invisible(NULL))
    updateNavbarPage(session, "main_navbar", selected = "analysis_tab")
  }, ignoreInit = TRUE)

  observeEvent(input$recluster_new_pb_run_btn, {
    if (!.recluster_new_event_allowed("pseudobulk_run")) return(invisible(NULL))
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
    .db_dbg(
      "pseudobulk_bind",
      sprintf(
        "mode=%s meta_col=%s split_by=%s cluster_subset=%s level_a=%s level_b=%s",
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
    if (!.recluster_new_context_is_settled()) return(NULL)
    df <- .pseudobulk_table_data()
    groups <- .pb_table_group_values(df)
    if (!length(groups)) return(NULL)

    visible_now <- isolate(input$recluster_new_pb_visible_groups)
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
    if (!.recluster_new_context_is_settled()) return(NULL)
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
    if (!.recluster_new_context_is_settled()) {
      return(datatable(data.frame(note = "Loading selected dataset..."), rownames = FALSE, selection = "none", options = list(dom = "t")))
    }
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

  # Agent note: Stacked-bar segments must use same metadata column and palette
  # as UMAP color selector. Keep violin grouping independent because expression
  # violin mode is driven by metadata operation state, not UMAP display state.
  .active_stacked_group_col <- reactive({
    selected_col <- .active_umap_metadata_col()
    if (!nzchar(selected_col) || identical(selected_col, "None")) return("")
    selected_col
  })

  .violin_plot_cache_signature <- function() {
    obj <- recluster_new_data$seurat_obj
    if (is.null(obj) || !inherits(obj, "Seurat")) return("")

    expr_tab <- .current_expr_tab()
    group_col <- if (identical(expr_tab, "stacked")) {
      .active_stacked_group_col()
    } else {
      .active_violin_group_col()
    }
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
      expr_tab,
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
    if (!.recluster_new_event_allowed("violin_cache_render")) return(invisible(NULL))
    if (!.db_tab_is_active()) {
      return(invisible(NULL))
    }
    if (!(.current_expr_tab() %in% c("violin", "stacked"))) {
      p_empty <- plot_ly(source = "recluster_new_plot_source") %>%
        add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
        layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0)) %>%
        .plotly_touch_zoom()
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

    expr_tab <- .current_expr_tab()
    group_col <- if (identical(expr_tab, "stacked")) {
      .active_stacked_group_col()
    } else {
      .active_violin_group_col()
    }
    group_error <- if (identical(expr_tab, "stacked")) {
      "Stacked bar plot follows UMAP color selection. Choose a metadata column first."
    } else {
      "No active metadata grouping is available."
    }
    validate(need(nzchar(group_col), group_error))
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

    if (identical(expr_tab, "pseudobulk")) {
      p_bulk <- plot_ly(source = "recluster_new_plot_source") %>%
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
        ) %>%
        .plotly_touch_zoom()
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
      pbar <- plot_ly(source = "recluster_new_plot_source")
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
        xaxis = list(
          title = if (use_split) split_by else "",
          automargin = TRUE,
          tickangle = "auto"
        ),
        yaxis = list(title = "Cell count"),
        barmode = "stack",
        legend = list(orientation = "h", traceorder = "reversed", x = 0.5, xanchor = "center", y = -0.18, yanchor = "top"),
        margin = list(l = 55, r = 20, t = 40, b = 90)
      ) %>%
      .plotly_touch_zoom()
      recluster_new_data$violin_plot_cache_sig <- plot_cache_sig
      recluster_new_data$violin_plot_cache <- p_res
      violin_plot_rendered(p_res)
      return(invisible(NULL))
    }

    if (!nzchar(gene_name)) {
      p_no_gene <- plot_ly(source = "recluster_new_plot_source") %>%
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
        ) %>%
        .plotly_touch_zoom()
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

    p <- plot_ly(source = "recluster_new_plot_source")
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
    ) %>%
      .plotly_touch_zoom()

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
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0)) %>%
          .plotly_touch_zoom()
      )
    }
    if (!.recluster_new_context_is_settled()) return(.recluster_new_empty_plot("recluster_new_plot_source"))
    req(violin_plot_rendered())
  })

  output$recluster_new_selected_cell_count_output <- renderText({
    paste(RECLUSTER_NEW_UI_TEXT$t_text_selected_barcodes, length(manual_selection_cells()), "cells")
  })

  observe({
    if (!.recluster_new_event_allowed("final_cell_count")) return(invisible(NULL))
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

  .recluster_new_send_create_feedback <- function(state) {
    try(
      session$sendCustomMessage(
        "recluster-new-create-feedback",
        list(state = as.character(state))
      ),
      silent = TRUE
    )
    invisible(NULL)
  }

  observeEvent(input$recluster_new_run_btn, {
    on.exit(.recluster_new_send_create_feedback("open_finished"), add = TRUE)
    if (!.recluster_new_event_allowed("subset_open")) return(invisible(NULL))
    obj <- recluster_new_data$seurat_obj
    req(obj)
    selected_cells_now <- unique(as.character(checked_population_cells() %||% character(0)))
    selected_cells_now <- selected_cells_now[!is.na(selected_cells_now) & nzchar(selected_cells_now)]
    missing_cells <- setdiff(selected_cells_now, colnames(obj))
    if (length(missing_cells)) {
      .db_dbg(
        "subset_open_rejected_stale_cells",
        sprintf("object=%s missing=%d checked=%d", .recluster_new_canonical_object_name(), length(missing_cells), length(selected_cells_now))
      )
      showNotification("Population selection is out of date. Reopen it before creating a new object.", type = "error", duration = 8)
      return(invisible(NULL))
    }
    .db_dbg(
      "subset_open",
      sprintf(
        "object=%s revision=%s column=%s filter=%s cells=%d",
        .recluster_new_canonical_object_name(),
        .recluster_new_context_revision(),
        .scalar_chr(recluster_new_data$metadata_active_column, default = ""),
        .scalar_chr(recluster_new_data$metadata_filter_state, default = ""),
        length(selected_cells_now)
      )
    )
    if (!length(selected_cells_now)) {
      showNotification("Select at least one population before creating a new object.", type = "error")
      return(invisible(NULL))
    }
    # Agent note: Recluster object membership is defined only by checked
    # population levels. Lasso, expression, and saved-group state must not
    # silently replace this explicit population selection.
    recluster_new_pending_population_cells(selected_cells_now)
    recluster_new_pending_population_object(.recluster_new_canonical_object_name())
    recluster_new_pending_population_revision(.recluster_new_context_revision())
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
      div(class = "app-note-box control-note", p(class = "recluster-new-secondary-text", RECLUSTER_NEW_UI_TEXT$t_text_subset_note)),
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
    on.exit(.recluster_new_send_create_feedback("create_finished"), add = TRUE)
    if (!.recluster_new_event_allowed("subset_confirm")) return(invisible(NULL))
    overlay_show(RECLUSTER_NEW_UI_TEXT$t_text_creating_subset)
    on.exit(overlay_hide(), add = TRUE)

    seurat_obj <- recluster_new_data$seurat_obj
    selected_cells <- recluster_new_pending_population_cells()
    pending_object <- .scalar_chr(recluster_new_pending_population_object(), default = "")
    pending_revision <- suppressWarnings(as.integer(recluster_new_pending_population_revision() %||% NA_integer_))
    current_object <- .recluster_new_canonical_object_name()
    if (!nzchar(pending_object) || !identical(pending_object, current_object) ||
        !is.finite(pending_revision) || is.na(pending_revision) ||
        !identical(pending_revision, .recluster_new_context_revision())) {
      showNotification("Dataset changed while subset dialog was open. Reopen subset creation for current dataset.", type = "error", duration = 8)
      recluster_new_pending_population_cells(character(0))
      recluster_new_pending_population_object("")
      recluster_new_pending_population_revision(NA_integer_)
      removeModal()
      return(invisible(NULL))
    }
    new_name <- .scalar_chr(input$recluster_new_subset_name, default = "")
    suffix_raw <- .scalar_chr(input$recluster_new_subset_suffix, default = "")
    unknown_keep <- as.character(input$recluster_new_unknown_keep_cols %||% character(0))

    req(seurat_obj)
    selected_cells <- unique(as.character(selected_cells %||% character(0)))
    selected_cells <- selected_cells[!is.na(selected_cells) & nzchar(selected_cells)]
    missing_cells <- setdiff(selected_cells, colnames(seurat_obj))
    if (length(missing_cells)) {
      .db_dbg(
        "subset_confirm_rejected_stale_cells",
        sprintf("object=%s missing=%d pending=%d", current_object, length(missing_cells), length(selected_cells))
      )
      showNotification("Population selection changed while dialog was open. Reopen object creation.", type = "error", duration = 8)
      recluster_new_pending_population_cells(character(0))
      recluster_new_pending_population_object("")
      recluster_new_pending_population_revision(NA_integer_)
      removeModal()
      return(invisible(NULL))
    }
    .db_dbg(
      "subset_confirm",
      sprintf("source=%s revision=%s cells=%d", current_object, pending_revision, length(selected_cells))
    )
    if (!length(selected_cells)) {
      showNotification("Select at least one population before creating a new object.", type = "error")
      return(invisible(NULL))
    }
    req(isTruthy(new_name))
    if (new_name %in% names(shared_data$all_seurat_objects)) {
      showNotification(RECLUSTER_NEW_UI_TEXT$t_text_name_conflict, type = "error")
      return(invisible(NULL))
    }

    subset_obj <- tryCatch(subset(seurat_obj, cells = selected_cells), error = function(e) NULL)
    req(subset_obj)
    .db_dbg(
      "subset_created",
      sprintf("source=%s new=%s cells=%d", current_object, new_name, ncol(subset_obj))
    )
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
    subset_obj <- wanlab_reset_subset_analysis_state(subset_obj, source_object_name = parent_name)
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
    recluster_new_pending_population_cells(character(0))
    recluster_new_pending_population_object("")
    recluster_new_pending_population_revision(NA_integer_)

    showNotification(paste("New object '", new_name, "' created and activated.", sep = ""), type = "message")
  })

  # Reactive values/helper for VDJ clone explorer in Data Browser
  # Populate dropdowns when Seurat object changes
  observe({
    if (!.recluster_new_event_allowed("tcr_choice_sync")) return(invisible(NULL))
    obj <- recluster_new_data$seurat_obj
    req(obj)
    md <- obj@meta.data
    cols <- colnames(md)
    req(length(cols) > 0)
    
    # Clone cols candidates
    clone_candidates <- c("vdj_tcr_clone", "vdj_bcr_clone", "tcr_clone", "bcr_clone", "cdr3")
    clone_hit <- clone_candidates[clone_candidates %in% cols]
    clone_default <- if (length(clone_hit)) clone_hit[[1]] else cols[[1]]
    clone_current <- .scalar_chr(isolate(input$recluster_new_tcr_clone_col), default = "")
    clone_sel <- if (clone_current %in% cols) clone_current else clone_default
    
    # Cond cols candidates
    cond_candidates <- c("condition", "sample", "orig.ident", "group", "treatment")
    cond_hit <- cond_candidates[cond_candidates %in% cols]
    cond_default <- if (length(cond_hit)) cond_hit[[1]] else cols[[1]]
    cond_current <- .scalar_chr(isolate(input$recluster_new_tcr_cond_col), default = "")
    cond_sel <- if (cond_current %in% cols) cond_current else cond_default

    choices_sig <- paste(c(cols, clone_sel, cond_sel), collapse = "\u001f")
    if (identical(.scalar_chr(recluster_new_data$tcr_choices_sig, default = ""), choices_sig)) {
      return(invisible(NULL))
    }
    recluster_new_data$tcr_choices_sig <- choices_sig
    updateSelectInput(session, "recluster_new_tcr_clone_col", choices = cols, selected = clone_sel)
    updateSelectInput(session, "recluster_new_tcr_cond_col", choices = cols, selected = cond_sel)
  })
  
  # Reactive expression to build clone table
  .tcr_clone_table_data <- reactive({
    if (!.recluster_new_context_is_settled()) return(NULL)
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
    if (!.recluster_new_context_is_settled()) {
      return(DT::datatable(data.frame(note = "Loading selected dataset..."), rownames = FALSE, selection = "none", options = list(dom = "t")))
    }
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
    if (!.recluster_new_event_allowed("tcr_table_selection")) return(invisible(NULL))
    tbl <- .tcr_clone_table_data()
    req(tbl)
    selected_rows <- input$recluster_new_tcr_table_rows_selected
    # DT sends NULL while table binding/rebinding. That is not a user clear
    # event and must not erase selections from metadata, lasso, or expression
    # controls during object/table transitions.
    if (is.null(selected_rows)) return(invisible(NULL))

    obj <- recluster_new_data$seurat_obj
    req(obj)
    clone_col <- input$recluster_new_tcr_clone_col
    md <- obj@meta.data
    
    if (!length(selected_rows)) {
      recluster_new_data$selected_cells <- character(0)
      if (identical(.scalar_chr(selection_owner_state(), default = "none"), "manual") &&
          !length(lasso_selected_cells_state())) {
        .restore_selection_owner_after_manual_clear("tcr_rows_cleared")
      }
    } else {
      selected_clones <- tbl$clone[selected_rows]
      clones_in_metadata <- as.character(md[[clone_col]])
      matched_barcodes <- rownames(md)[clones_in_metadata %in% selected_clones]
      
      recluster_new_data$selected_cells <- matched_barcodes
      .set_selection_owner("manual", "tcr_rows_selected")
    }
  }, ignoreNULL = FALSE)
  
  # Select All button click
  observeEvent(input$recluster_new_tcr_select_all_btn, {
    if (!.recluster_new_event_allowed("tcr_select_all")) return(invisible(NULL))
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
    .set_selection_owner("manual", "tcr_select_all")
    showNotification(sprintf("Added %d cells from selected clone(s) to Selection Workspace.", length(matched_barcodes)), type = "message")
  })
  
  # Clonal Distribution Plot
  output$recluster_new_tcr_dist_plot <- renderPlotly({
    if (!.recluster_new_context_is_settled()) return(.recluster_new_empty_plot("recluster_new_tcr_plot_source"))
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
    
    ggplotly(p) %>%
      .plotly_interactive_tools()
  })
}

# Backward-compatible naming alias: this page is the Data Browser (New)
# while keeping existing route/input contracts (`recluster_new_*`).
data_browser_new_ui <- recluster_new_ui
data_browser_new_server <- recluster_new_server
