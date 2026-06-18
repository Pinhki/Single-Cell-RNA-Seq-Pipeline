HTO_UI_TEXT <- list(
  t_btn_apply_filter_add_workspace = "Apply filter & add to workspace",
  t_btn_clear_selection = "Clear selection",
  t_btn_run_hashtag_demultiplexing = "Run hashtag demultiplexing",
  t_label_auto_threshold = "Auto threshold",
  t_label_auto_per_hashtag_calibration = "Auto per-hashtag calibration",
  t_label_auto_calibration_lower_quantile = "Calibration lower quantile (singlet distribution)",
  t_label_bottom_color = "Bottom color by",
  t_label_bottom_x_axis = "Bottom X axis",
  t_label_bottom_y_axis = "Bottom Y axis",
  t_label_demultiplexing_method = "Demultiplexing method",
  t_tip_method_htodemux = "HTODemux: clustering-based hashtag demultiplexing. Best when hashtag positives form clear clusters and you want robust singlet/doublet calls.",
  t_tip_method_multiseq = "MULTIseqDemux: quantile-threshold-based demultiplexing. Best when signal is more continuous and you need threshold-focused control.",
  t_label_enable_signal_based_filtering = "Enable signal-based filtering",
  t_label_hashtag_feature = "Hashtag feature",
  t_label_hto_assay = "HTO assay",
  t_label_initial_class_labels_column_optional = "Initial class labels column (optional)",
  t_label_kfunc = "kfunc",
  t_label_max_second_highest_signal_top2 = "Max second-highest signal (top2)",
  t_label_maxiter = "maxiter",
  t_label_min_delta_top1_top2 = "Min delta (top1 - top2)",
  t_label_min_highest_signal_top1 = "Min highest signal (top1)",
  t_label_normalize_hto_signal_before_demux = "Normalize HTO signal (CLR, margin=2) before demultiplexing",
  t_tip_normalize_hto = "Applies CLR normalization before demultiplexing. Best in most datasets to reduce count-depth bias between hashtags.",
  t_label_nsamples = "nsamples",
  t_label_nstarts = "nstarts",
  t_label_object = "Object",
  t_label_point_opacity = "Point opacity",
  t_label_point_size = "Point size",
  t_label_positive_quantile = "Positive quantile",
  t_label_qrange = "qrange",
  t_label_quantile = "Quantile",
  t_label_pre_demux_background_trim_quantile = "Background trim quantile (per hashtag)",
  t_label_pre_demux_robust_scaling = "Robust per-hashtag scaling before demux",
  t_label_seed = "Seed",
  t_label_show_singlets_only = "Show singlets only",
  t_label_x_axis_feature = "X axis feature",
  t_label_y_axis_feature = "Y axis feature",
  t_text_bottom_plot_axis_controls_rna_mixed = "Bottom plot axis controls (RNA/mixed)",
  t_text_cells = "Cells",
  t_text_cells_shown_heatmap = "Cells shown in heatmap",
  t_text_class_composition = "Class composition",
  t_text_class_naming_singlet_one_hashtag_e = "Class naming: Singlet = one hashtag (e.g., Mouse-1); Doublet = two strong hashtags (e.g., Mouse-1_Mouse-2); Negative = no confident hashtag. Mouse-1_Mouse-1 means same-hashtag doublet/ambiguous multiplet.",
  t_text_color_points = "Color points by",
  t_text_delta_distribution_hashtag_singlets_related_doublets = "Delta distribution by hashtag (singlets + related doublets)",
  t_text_delta_top1_top2_signal = "Delta (top1 - top2 signal)",
  t_text_demultiplex_class = "Demultiplex class",
  t_text_display_mode = "Display mode",
  t_text_each_hashtag_row_overlays_singlets_plus = "Each hashtag row overlays singlets plus related doublet classes. Doublet classes use different gray shades per row; use hover to identify exact doublet class.",
  t_text_enable_per_hashtag_minimum_top_signal = "Enable per-hashtag minimum top signal (top1)",
  t_text_filter_mode = "Filter mode",
  t_text_group_label_columns = "Group/label columns",
  t_text_hashtag_feature_scatter_controls = "Hashtag feature scatter controls",
  t_text_hashtag_color_key = "Hashtag color key",
  t_text_hashtag_signal = "Hashtag signal",
  t_text_heatmap_shows_hashtag_signal_across_cells = "Heatmap shows hashtag signal across cells, with class labels (Negative/Singlet/Doublet). Use this to confirm assignment structure at single-cell level.",
  t_text_hto_heatmap_grouped_class_subgroup_labels = "HTO heatmap grouped by class with subgroup labels",
  t_text_leave_empty_keep_all_ids_after = "Leave empty to keep all IDs after class filter",
  t_text_left_kept_vs_filtered_status_right = "Left: kept vs filtered status. Right: hashtag ID structure view (optional singlet-only filter).",
  t_text_max_top2 = "Max top2",
  t_text_min_delta = "Min delta",
  t_text_min_top1 = "Min top1",
  t_text_ncount_rna = "nCount_RNA",
  t_text_nfeature_rna = "nFeature_RNA",
  t_text_optional_keep_hashtag_ids = "Optional: keep hashtag IDs",
  t_text_per_hashtag_thresholds = "Per-hashtag thresholds",
  t_text_ridge_curves_selected_hashtag_split_kept = "Ridge curves for selected hashtag. Split by kept vs filtered status to show threshold impact directly.",
  t_text_rna_qc_scatter_ncount_rna_vs = "RNA QC scatter (nCount_RNA vs nFeature_RNA)",
  t_text_run_hashtag_demultiplexing_review_hashtag_assignment = "Run hashtag demultiplexing, review hashtag assignment, and add filtered singlets to workspace.",
  t_text_side_side_comparison_left_uses_selected = "Side-by-side comparison: left uses selected color mode; right shows kept vs filtered status for the same axes and selected populations.",
  t_text_status_show = "Status to show",
  t_text_t_sne_1 = "t-SNE 1",
  t_text_t_sne_2 = "t-SNE 2",
  t_text_three_plots_total_top_left_top = "Three plots total: top-left/top-right share HTO axis controls; bottom plot has independent RNA/mixed-axis controls.",
  t_text_upstream_signal_calibration = "Upstream signal calibration",
  t_text_top_plots_axis_controls_hto_only = "Top plots axis controls (HTO only)",
  t_text_top_row_uses_shared_hto_axes = "Top row uses shared HTO axes for two side-by-side views; bottom row uses independent RNA/mixed axes.",
  t_title_additional_signal_thresholds = "Additional signal thresholds",
  t_title_filter_add_workspace = "Filter and add to workspace",
  t_title_hashtag_assignment_table = "Hashtag assignment table",
  t_title_hashtag_demultiplexing_settings = "Hashtag demultiplexing settings",
  t_title_hashtag_diagnostics = "Hashtag diagnostics",
  t_title_hto_feature_scatter = "HTO feature scatter",
  t_title_hto_heatmap = "HTO heatmap",
  t_title_qc_hashtag_demultiplexing = "QC: Hashtag demultiplexing",
  t_title_ridge_delta = "Ridge + Delta",
  t_title_t_sne_diagnostics = "t-SNE diagnostics",
  t_text_no_seurat_objects_loaded = "No Seurat objects loaded.",
  t_text_no_assay_detected_for_hto_adt = "No assay detected for HTO/ADT.",
  t_text_run_demultiplexing_first_enable_signal_threshold_controls = "Run demultiplexing first to enable signal-based threshold controls."

)

## -----------------------------------------------------------------------------
## HTO color knobs (edit here to change palettes globally)
## -----------------------------------------------------------------------------
HTO_COLOR_KNOBS <- list(
  hashtag_deep = c("#B71C1C", "#880E4F", "#4A148C", "#311B92", "#1A237E", "#0D47A1", "#01579B", "#006064", "#004D40"),
  hashtag_light = c("#FFEBEE", "#FCE4EC", "#F3E5F5", "#EDE7F6", "#E8EAF6", "#E3F2FD", "#E1F5FE", "#E0F7FA", "#E0F2F1"),
  status = c("Kept" = "#16a34a", "Refined out" = "#f59e0b", "Filtered out" = "#9ca3af"),
  neutral_negative = "#9ca3af",
  neutral_other = "#64748b",
  context_bg = "#cbd5e1",
  linked_selection = "#111827",
  legend_dot_scale = 2.0
)

library(shiny)
library(DT)
library(plotly)
library(shinycssloaders)
library(Matrix)

`%||%` <- function(a, b) if (is.null(a)) b else a

hto_ui <- fluidPage(
  tags$style(HTML("
    .hto-panel-stack > .well { margin-bottom: 12px; }
    .hto-panel-stack > .well:last-child { margin-bottom: 0; }
    .hto-scatter-controls {
      background: #ffffff;
      border: 1px solid #dbe5f3;
      border-radius: 12px;
      padding: 12px 14px 8px 14px;
      margin-bottom: 10px;
    }
    .hto-scatter-controls .control-label {
      font-weight: 600;
      color: #0f172a;
    }
    .hto-scatter-title {
      font-weight: 700;
      color: #0f172a;
      margin-bottom: 6px;
    }
    .hto-scatter-hint {
      color: #334155;
      font-size: 0.92em;
      margin-bottom: 10px;
    }
    .hto-pop-grid .well {
      display: none;
    }
    .hto-pop-grid .control-label {
      font-weight: 600;
      color: #0f172a;
    }
    .hto-pop-grid .checkbox {
      margin-top: 0;
      margin-bottom: 2px;
    }
    .hto-pop-grid .checkbox label {
      font-size: 12px;
      line-height: 1.15;
      font-weight: 500;
      padding-left: 18px;
    }
    .hto-pop-grid .checkbox input[type='checkbox'] {
      margin-top: 1px;
    }
    .hto-pop-grid details {
      margin-top: 6px;
      padding: 6px 8px;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      background: #f8fafc;
    }
    .hto-pop-grid summary {
      font-weight: 700;
      color: #0f172a;
      cursor: pointer;
    }
    .hto-pop-grid .doublet-grid {
      columns: 2;
      column-gap: 16px;
      margin-top: 6px;
      max-height: 180px;
      overflow-y: auto;
    }
    .hto-pop-grid .pop-summary {
      font-weight: 700;
      font-size: 1.05em;
      color: #0f172a;
    }
    .hto-heatmap-caption {
      display: block !important;
      color: #111827 !important;
      font-weight: 600 !important;
      font-size: 13px !important;
      margin-bottom: 4px !important;
    }
    .hto-color-key {
      display: flex;
      flex-wrap: wrap;
      gap: 10px 14px;
      align-items: center;
      margin-top: 2px;
      margin-bottom: 2px;
    }
    .hto-color-key .item {
      display: inline-flex;
      align-items: center;
      font-size: 12px;
      color: #1f2937;
    }
    .hto-color-key .sw {
      width: 12px;
      height: 12px;
      border-radius: 2px;
      margin-right: 6px;
      border: 1px solid rgba(0,0,0,0.18);
    }
    .hto-tsne-opts .checkbox { margin: 0; }
    .hto-tsne-opts .checkbox label {
      color: #111827 !important;
      font-weight: 600 !important;
      font-size: 15px !important;
    }
    .hto-tsne-opts .checkbox input[type='checkbox'] { margin-top: 2px; }
    .hto-tsne-opts {
      margin: 10px 0 12px 0;
      padding: 8px 10px;
      border: 1px solid #dbe5f3;
      border-radius: 8px;
      background: #f8fbff;
      display: inline-block;
    }
    .hto-heatmap-box {
      border: 1px solid #dbe5f3;
      border-radius: 10px;
      background: #ffffff;
      padding: 10px 12px 8px 12px;
      margin-top: 6px;
      margin-bottom: 8px;
    }
    .hto-per-feature-wrap {
      margin-top: 8px;
      margin-bottom: 10px;
    }
    .hto-per-feature-box { margin-top: 8px; }
    .hto-method-picker { margin-bottom: 8px; }
    .hto-method-picker .control-label {
      font-weight: 600;
      color: #111827;
      margin-bottom: 10px;
    }
    .hto-method-picker .radio {
      margin: 0 0 8px 0;
    }
    .hto-method-picker .radio:last-child {
      margin-bottom: 0;
    }
    .hto-method-picker .radio label {
      width: 100%;
      display: flex;
      align-items: flex-start;
      gap: 8px;
      border: 1px solid #cfd8e3;
      border-radius: 8px;
      padding: 8px 10px;
      background: #f8fbff;
      font-weight: 500;
      font-size: 14px;
    }
    .hto-method-picker .radio input[type='radio'] {
      margin-top: 2px;
      position: static;
      width: 18px;
      height: 18px;
      min-width: 18px;
      min-height: 18px;
      flex: 0 0 18px;
    }
    .hto-method-choice {
      display: block;
      flex: 1 1 auto;
    }
    .hto-method-head {
      display: flex;
      align-items: center;
      gap: 6px;
      font-weight: 700;
      color: #0f172a;
      line-height: 1.2;
    }
    .hto-method-note {
      margin-top: 2px;
      color: #475569;
      font-size: 11px;
      line-height: 1.25;
    }
    .hto-method-info {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 15px;
      height: 15px;
      border-radius: 999px;
      background: #0ea5a5;
      color: #ffffff;
      font-size: 10px;
      font-weight: 700;
      cursor: help;
    }
    .hto-normalize-picker { margin-bottom: 8px; }
    .hto-normalize-picker .checkbox { margin: 0; }
    .hto-normalize-picker .checkbox label {
      width: 100%;
      display: flex;
      align-items: flex-start;
      gap: 8px;
      border: 1px solid #d9d5ff;
      border-radius: 8px;
      padding: 8px 10px;
      background: #f5f3ff;
      font-weight: 500;
      color: #0f172a;
      font-size: 14px;
    }
    .hto-normalize-picker .checkbox input[type='checkbox'] {
      margin-top: 2px;
      position: static;
      width: 18px;
      height: 18px;
      min-width: 18px;
      min-height: 18px;
      flex: 0 0 18px;
    }
    .hto-normalize-choice {
      display: block;
      flex: 1 1 auto;
    }
    .hto-normalize-head {
      display: block;
      font-weight: 700;
      color: #1f1147;
      line-height: 1.2;
    }
    .hto-normalize-note {
      margin-top: 2px;
      color: #5b4f84;
      font-size: 11px;
      line-height: 1.25;
    }
    .hto-tabs-wrap .tab-content { padding-top: 4px; }
  ")),
  div(
    class = "page-header",
    h2(icon("tags"), " ", HTO_UI_TEXT$t_title_qc_hashtag_demultiplexing),
    p(HTO_UI_TEXT$t_text_run_hashtag_demultiplexing_review_hashtag_assignment)
  ),
  uiOutput("hto_status_ui"),
  fluidRow(
    column(
      3,
      class = "hto-panel-stack",
      wellPanel(
        h4(HTO_UI_TEXT$t_title_hashtag_demultiplexing_settings),
        uiOutput("hto_object_ui"),
        uiOutput("hto_assay_ui"),
        div(
          class = "hto-method-picker",
          tags$div(class = "control-label", HTO_UI_TEXT$t_label_demultiplexing_method),
          radioButtons(
            "hto_method",
            label = NULL,
            choiceNames = list(
              tags$div(
                class = "hto-method-choice",
                tags$div(
                  class = "hto-method-head",
                  tags$span(class = "hto-method-info", title = HTO_UI_TEXT$t_tip_method_htodemux, `aria-label` = HTO_UI_TEXT$t_tip_method_htodemux, "i"),
                  tags$span("HTODemux")
                ),
                tags$div(class = "hto-method-note", "Best for clear hashtag-positive clusters and stable singlet/doublet separation.")
              ),
              tags$div(
                class = "hto-method-choice",
                tags$div(
                  class = "hto-method-head",
                  tags$span(class = "hto-method-info", title = HTO_UI_TEXT$t_tip_method_multiseq, `aria-label` = HTO_UI_TEXT$t_tip_method_multiseq, "i"),
                  tags$span("MULTIseqDemux")
                ),
                tags$div(class = "hto-method-note", "Best for threshold-based tuning when hashtag signals are continuous or imbalanced.")
              )
            ),
            choiceValues = c("HTODemux", "MULTIseqDemux"),
            selected = "HTODemux"
          )
        ),
        div(
          class = "hto-normalize-picker",
          checkboxInput(
            "hto_normalize_before_demux",
            tags$span(
              class = "hto-normalize-choice",
              tags$span(class = "hto-normalize-head", HTO_UI_TEXT$t_label_normalize_hto_signal_before_demux),
              tags$span(class = "hto-normalize-note", "Best default for most runs; disable only if you already normalized HTO upstream.")
            ),
            value = TRUE
          )
        ),
        conditionalPanel(
          condition = "input.hto_method == 'HTODemux'",
          sliderInput("hto_positive_quantile", HTO_UI_TEXT$t_label_positive_quantile, min = 0.5, max = 0.999, value = 0.99, step = 0.001)
        ),
        conditionalPanel(
          condition = "input.hto_method == 'MULTIseqDemux'",
          sliderInput("hto_multi_quantile", HTO_UI_TEXT$t_label_quantile, min = 0.1, max = 0.99, value = 0.7, step = 0.01)
        ),
        tags$details(
          tags$summary("Advanced parameters"),
          tags$div(style = "margin-top:8px;"),
          conditionalPanel(
            condition = "input.hto_method == 'HTODemux'",
            textInput("hto_adv_init", HTO_UI_TEXT$t_label_initial_class_labels_column_optional, value = ""),
            sliderInput("hto_adv_nstarts", HTO_UI_TEXT$t_label_nstarts, min = 10, max = 500, value = 100, step = 5),
            selectInput("hto_adv_kfunc", HTO_UI_TEXT$t_label_kfunc, choices = c("clara", "kmeans"), selected = "clara"),
            sliderInput("hto_adv_nsamples", HTO_UI_TEXT$t_label_nsamples, min = 10, max = 500, value = 100, step = 5)
          ),
          conditionalPanel(
            condition = "input.hto_method == 'MULTIseqDemux'",
            checkboxInput("hto_auto_thresh", HTO_UI_TEXT$t_label_auto_threshold, value = TRUE),
            sliderInput("hto_adv_maxiter", HTO_UI_TEXT$t_label_maxiter, min = 1, max = 20, value = 5, step = 1),
            sliderInput("hto_adv_qrange", HTO_UI_TEXT$t_label_qrange, min = 0, max = 1, value = c(0.1, 0.9), step = 0.01)
          ),
          tags$hr(style = "margin:8px 0;"),
          tags$div(style = "font-weight:600; margin-bottom:4px;", HTO_UI_TEXT$t_text_upstream_signal_calibration),
          checkboxInput("hto_preprocess_robust_scale", HTO_UI_TEXT$t_label_pre_demux_robust_scaling, value = FALSE),
          sliderInput("hto_preprocess_background_quantile", HTO_UI_TEXT$t_label_pre_demux_background_trim_quantile, min = 0, max = 0.25, value = 0.02, step = 0.01),
          textInput("hto_seed", HTO_UI_TEXT$t_label_seed, value = "42")
        ),
        tags$div(
          style = "margin-top:12px;",
          actionButton("hto_run_btn", HTO_UI_TEXT$t_btn_run_hashtag_demultiplexing, icon = icon("tags"), class = "btn btn-primary btn-sm")
        )
      ),
      wellPanel(
        h4(HTO_UI_TEXT$t_title_filter_add_workspace),
        selectInput(
          "hto_filter_mode",
          HTO_UI_TEXT$t_text_filter_mode,
          choices = c(
            "Keep singlets only" = "singlet_only",
            "Keep all (no class filter)" = "all",
            "Remove negatives" = "remove_negative",
            "Remove doublets" = "remove_doublet"
          ),
          selected = "singlet_only"
        ),
        selectizeInput(
          "hto_keep_ids",
          HTO_UI_TEXT$t_text_optional_keep_hashtag_ids,
          choices = NULL,
          selected = NULL,
          multiple = TRUE,
          options = list(placeholder = HTO_UI_TEXT$t_text_leave_empty_keep_all_ids_after)
        ),
        uiOutput("hto_signal_filter_ui"),
        uiOutput("hto_per_feature_threshold_ui"),
        actionButton("hto_apply_btn", HTO_UI_TEXT$t_btn_apply_filter_add_workspace, icon = icon("filter"), class = "btn btn-success btn-sm")
      )
    ),
    column(
      9,
      class = "plot_area_card_style",
      h4(HTO_UI_TEXT$t_title_hashtag_diagnostics),
      div(
        class = "hto-tabs-wrap app-tabs-wrap",
        tabsetPanel(
          id = "hto_plot_tabs",
        tabPanel(
          HTO_UI_TEXT$t_title_t_sne_diagnostics,
          tags$div(
            class = "hto-tsne-opts",
            checkboxInput("hto_tsne_id_singlets_only", HTO_UI_TEXT$t_label_show_singlets_only, value = TRUE)
          ),
          fluidRow(
            column(6, qc_with_busy_spinner(plotlyOutput("hto_tsne_plot", height = "560px"))),
            column(6, qc_with_busy_spinner(plotlyOutput("hto_tsne_id_plot", height = "560px")))
          ),
          p(class = "text-muted", style = "margin-top:8px;",
            HTO_UI_TEXT$t_text_left_kept_vs_filtered_status_right)
        ),
        tabPanel(
          HTO_UI_TEXT$t_title_hto_heatmap,
          tags$div(
            class = "hto-heatmap-box",
            uiOutput("hto_heatmap_ui")
          ),
          qc_with_busy_spinner(plotOutput("hto_heatmap_plot", height = "640px")),
          p(class = "text-muted", style = "margin-top:8px;",
            HTO_UI_TEXT$t_text_heatmap_shows_hashtag_signal_across_cells)
        ),
        tabPanel(
          HTO_UI_TEXT$t_title_hto_feature_scatter,
          uiOutput("hto_feature_scatter_ui"),
          qc_with_busy_spinner(plotlyOutput("hto_feature_scatter_plot", height = "560px")),
          qc_with_busy_spinner(plotlyOutput("hto_feature_scatter_bottom_plot", height = "500px")),
          p(class = "text-muted", style = "margin-top:8px;",
            HTO_UI_TEXT$t_text_three_plots_total_top_left_top)
        ),
        tabPanel(
          HTO_UI_TEXT$t_title_ridge_delta,
          uiOutput("hto_ridge_feature_ui"),
          qc_with_busy_spinner(plotlyOutput("hto_ridge_plot", height = "620px")),
          p(class = "text-muted", style = "margin-top:8px;",
            HTO_UI_TEXT$t_text_ridge_curves_selected_hashtag_split_kept),
          qc_with_busy_spinner(plotlyOutput("hto_delta_dist_plot", height = "620px")),
          p(class = "text-muted", style = "margin-top:8px;",
            HTO_UI_TEXT$t_text_each_hashtag_row_overlays_singlets_plus)
        ),
        tabPanel(
          "Borderline diagnostics",
          qc_with_busy_spinner(plotlyOutput("hto_borderline_scatter_plot", height = "560px")),
          qc_with_busy_spinner(plotlyOutput("hto_borderline_margin_plot", height = "420px")),
          p(class = "text-muted", style = "margin-top:8px;",
            "Top: decision boundary map (top2 vs top1) with threshold lines. Bottom: decision-margin distribution around cutoff 0; values near 0 are borderline.")
        ),
        tabPanel(
          HTO_UI_TEXT$t_text_class_composition,
          qc_with_busy_spinner(plotlyOutput("hto_class_comp_plot", height = "560px")),
          p(class = "text-muted", style = "margin-top:8px;",
            HTO_UI_TEXT$t_text_class_naming_singlet_one_hashtag_e)
        )
        )
      ),
      div(style = "height: 10px;"),
      tags$hr(style = "margin: 8px 0 14px 0; border-top: 1px solid #d1d5db;"),
      fluidRow(
        column(
          12,
          h4(HTO_UI_TEXT$t_title_hashtag_assignment_table),
          DTOutput("hto_assignment_table")
        )
      )
    )
  )
)

hto_server <- function(input, output, session, shared_data) {
  .scalar_chr <- function(x, default = NA_character_) {
    if (is.null(x) || length(x) == 0) return(default)
    y <- as.character(x)
    y <- y[!is.na(y)]
    if (!length(y)) return(default)
    y[[1]]
  }
  .get_entry <- function(nm) {
    key <- .scalar_chr(nm, default = "")
    if (!nzchar(key)) return(NULL)
    (shared_data$all_seurat_objects %||% list())[[key]]
  }
  .get_obj <- function(entry) {
    if (is.null(entry)) return(NULL)
    if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
  }
  .resolve_class_col <- function(info, md) {
    if (is.null(info) || is.null(md)) return(NA_character_)
    cc <- as.character(info$class_col %||% NA_character_)
    if (!length(cc)) return(NA_character_)
    cc <- unique(cc[!is.na(cc) & nzchar(cc)])
    if (!length(cc)) return(NA_character_)
    cc <- cc[cc %in% colnames(md)]
    if (!length(cc)) return(NA_character_)
    cc[[1]]
  }
  .safe_class_values <- function(md, rows, info, fallback = "unknown") {
    cc <- .resolve_class_col(info, md)
    if (is.na(cc)) return(rep(fallback, length(rows)))
    vals <- as.character(md[rows, cc, drop = TRUE] %||% fallback)
    vals[is.na(vals)] <- fallback
    vals
  }
  .safe_id_col <- function(info, md) {
    if (is.null(info) || is.null(md)) return(NA_character_)
    cc <- .scalar_chr(info$id_col, default = NA_character_)
    if (is.na(cc) || !nzchar(cc) || !(cc %in% colnames(md))) return(NA_character_)
    cc
  }
  .is_valid_choice <- function(x, choices) {
    y <- .scalar_chr(x, default = "")
    nzchar(y) && (y %in% as.character(choices %||% character()))
  }

  hto_info <- reactiveVal(NULL)
  hto_status <- reactiveVal(list(type = "info", msg = "Run hashtag demultiplexing to generate class assignments and hashtag t-SNE."))
  hto_scatter_linked_cells <- reactiveVal(character(0))
  hto_selected_object <- reactiveVal(NULL)

  .selected_cells_from_event <- function(ed) {
    out <- tryCatch({
      if (is.null(ed)) return(character(0))
      vals <- NULL
      if (is.data.frame(ed)) {
        if (NROW(ed) == 0) return(character(0))
        if ("key" %in% colnames(ed)) vals <- ed$key
        if ((is.null(vals) || length(vals) == 0) && "customdata" %in% colnames(ed)) vals <- ed$customdata
      } else if (is.list(ed)) {
        if (!is.null(ed$key)) vals <- ed$key
        if ((is.null(vals) || length(vals) == 0) && !is.null(ed$customdata)) vals <- ed$customdata
        if ((is.null(vals) || length(vals) == 0) && !is.null(ed$points) && length(ed$points) > 0) {
          vals <- unlist(lapply(ed$points, function(pt) {
            if (!is.list(pt)) return(NULL)
            pt$key %||% pt$customdata %||% NULL
          }), recursive = TRUE, use.names = FALSE)
        }
      } else {
        return(character(0))
      }
      if (is.null(vals)) return(character(0))
      if (is.data.frame(vals)) vals <- vals[[1]]
      if (is.list(vals)) vals <- unlist(vals, recursive = TRUE, use.names = FALSE)
      if (!is.atomic(vals)) return(character(0))
      vals_chr <- as.character(vals)
      if (!length(vals_chr)) return(character(0))
      keep <- which(!is.na(vals_chr) & nzchar(vals_chr))
      if (!length(keep)) return(character(0))
      unique(vals_chr[keep])
    }, error = function(e) character(0))
    out
  }

  output$hto_object_ui <- renderUI({
    reg <- shared_data$all_seurat_objects %||% list()
    nms <- names(reg)
    if (!length(nms)) return(helpText(HTO_UI_TEXT$t_text_no_seurat_objects_loaded))
    sel <- .scalar_chr(hto_selected_object() %||% input$hto_object_name %||% shared_data$active_object_name %||% nms[[1]], default = nms[[1]])
    if (!.is_valid_choice(sel, nms)) sel <- nms[[1]]
    selectInput("hto_object_name", HTO_UI_TEXT$t_label_object, choices = nms, selected = sel)
  })

  output$hto_assay_ui <- renderUI({
    nm <- input$hto_object_name %||% shared_data$active_object_name
    obj <- .get_obj(.get_entry(nm))
    req(!is.null(obj))
    assays <- core_hto_detect_assays(obj)
    if (!length(assays)) return(helpText(HTO_UI_TEXT$t_text_no_assay_detected_for_hto_adt))
    sel <- .scalar_chr(input$hto_assay_name, default = assays[[1]])
    if (!.is_valid_choice(sel, assays)) sel <- assays[[1]]
    selectInput("hto_assay_name", HTO_UI_TEXT$t_label_hto_assay, choices = assays, selected = sel)
  })

  output$hto_status_ui <- renderUI({
    st <- hto_status()
    cls <- if (identical(st$type, "error")) "alert alert-danger" else if (identical(st$type, "warn")) "alert alert-warning" else "alert alert-info"
    div(class = cls, st$msg)
  })

  observeEvent(shared_data$all_seurat_objects, {
    reg <- shared_data$all_seurat_objects %||% list()
    nms <- names(reg)
    if (!length(nms)) {
      hto_selected_object(NULL)
      return(invisible(NULL))
    }
    cur <- .scalar_chr(hto_selected_object() %||% input$hto_object_name %||% shared_data$active_object_name, default = "")
    if (!nzchar(cur) || !(cur %in% nms)) cur <- nms[[1]]
    if (!identical(cur, hto_selected_object())) hto_selected_object(cur)
  }, ignoreInit = FALSE)

  observeEvent(input$hto_object_name, {
    nm <- .scalar_chr(input$hto_object_name, default = "")
    if (nzchar(nm)) {
      hto_selected_object(nm)
      shared_data$active_object_name <- nm
    }
  }, ignoreInit = TRUE)

  observeEvent(
    list(input$hto_object_name, input$hto_assay_name, shared_data$all_seurat_objects),
    {
      tryCatch({
        reg <- shared_data$all_seurat_objects %||% list()
        nms <- names(reg)
        if (!length(nms)) {
          hto_info(NULL)
          updateSelectizeInput(session, "hto_keep_ids", choices = character(0), selected = character(0), server = TRUE)
          hto_status(list(type = "info", msg = HTO_UI_TEXT$t_text_no_seurat_objects_loaded))
          return(invisible(NULL))
        }

        nm <- .scalar_chr(hto_selected_object() %||% input$hto_object_name %||% shared_data$active_object_name %||% nms[[1]], default = nms[[1]])
        if (!(nm %in% nms)) nm <- nms[[1]]
        if (!identical(nm, hto_selected_object())) hto_selected_object(nm)
        entry <- .get_entry(nm)
        obj <- .get_obj(entry)
        if (is.null(obj)) {
          hto_info(NULL)
          updateSelectizeInput(session, "hto_keep_ids", choices = character(0), selected = character(0), server = TRUE)
          hto_status(list(type = "warn", msg = sprintf("Object '%s' is unavailable. Select another object.", nm)))
          return(invisible(NULL))
        }

        assays <- core_hto_detect_assays(obj)
        assay <- input$hto_assay_name
        if (!length(assays)) {
          hto_info(NULL)
          updateSelectizeInput(session, "hto_keep_ids", choices = character(0), selected = character(0), server = TRUE)
          hto_status(list(type = "warn", msg = sprintf("Object '%s': no HTO/ADT assay detected yet.", nm)))
          return(invisible(NULL))
        }
        if (is.null(assay) || !nzchar(assay) || !(assay %in% assays)) assay <- assays[[1]]

        md <- obj@meta.data
        class_col <- .scalar_chr(core_hto_pick_class_col(md), default = NA_character_)
        id_col <- .scalar_chr(core_hto_pick_id_col(md), default = NA_character_)
        has_demux <- !is.na(class_col) && nzchar(class_col) && (class_col %in% colnames(md))

        if (!has_demux) {
          hto_info(NULL)
          hto_scatter_linked_cells(character(0))
          updateSelectizeInput(session, "hto_keep_ids", choices = character(0), selected = character(0), server = TRUE)
          hto_status(list(type = "info", msg = sprintf("Object: %s. No hashtag demultiplexing results found yet for this sample. Click '%s'.", nm, HTO_UI_TEXT$t_btn_run_hashtag_demultiplexing)))
          return(invisible(NULL))
        }

        cls <- as.character(md[[class_col]] %||% "")
        sm <- as.data.frame(table(class = cls), stringsAsFactors = FALSE)
        if (nrow(sm)) {
          sm <- sm[order(sm$Freq, decreasing = TRUE), , drop = FALSE]
          names(sm) <- c("class", "cells")
        }

        mapped_ids <- character(0)
        if (!is.na(id_col) && nzchar(id_col) && id_col %in% colnames(md)) {
          ids <- as.character(md[[id_col]] %||% "")
          mapped_ids <- sort(unique(ids[nzchar(ids)]))
        }

        hto_info(list(
          object_name = nm,
          assay = assay,
          class_col = class_col,
          id_col = id_col,
          summary = sm
        ))
        hto_scatter_linked_cells(character(0))
        updateSelectizeInput(session, "hto_keep_ids", choices = mapped_ids, selected = character(0), server = TRUE)
        hto_status(list(
          type = "info",
          msg = sprintf(
            "Object: %s | Ready. Using existing hashtag assignments (%s%s).",
            nm,
            class_col,
            ifelse(is.na(id_col), "", paste0(" | ID: ", id_col))
          )
        ))
      }, error = function(e) {
        hto_info(NULL)
        hto_scatter_linked_cells(character(0))
        updateSelectizeInput(session, "hto_keep_ids", choices = character(0), selected = character(0), server = TRUE)
        hto_status(list(type = "error", msg = paste("Failed to refresh HTO sample context:", conditionMessage(e))))
      })
      invisible(NULL)
    },
    ignoreInit = FALSE
  )

  output$hto_signal_filter_ui <- renderUI({
    info <- hto_info()
    if (is.null(info)) {
      return(helpText(HTO_UI_TEXT$t_text_run_demultiplexing_first_enable_signal_threshold_controls))
    }
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    mat <- as.matrix(mat)
    req(nrow(mat) >= 2, ncol(mat) > 0)

    top1 <- apply(mat, 2, max)
    top2 <- apply(mat, 2, function(v) sort(v, decreasing = TRUE)[2])
    delta <- top1 - top2

    max_top1 <- suppressWarnings(max(top1, na.rm = TRUE))
    max_top2 <- suppressWarnings(max(top2, na.rm = TRUE))
    max_delta <- suppressWarnings(max(delta, na.rm = TRUE))
    if (!is.finite(max_top1) || max_top1 <= 0) max_top1 <- 1
    if (!is.finite(max_top2) || max_top2 <= 0) max_top2 <- 1
    if (!is.finite(max_delta) || max_delta <= 0) max_delta <- 1

    .nice_upper <- function(v) {
      b <- suppressWarnings(pretty(c(0, as.numeric(v)), n = 7))
      b <- b[is.finite(b)]
      out <- if (length(b)) max(b) else as.numeric(v)
      if (!is.finite(out) || out <= 0) out <- 1
      out
    }
    .nice_step <- function(v) {
      s <- suppressWarnings(pretty(c(0, as.numeric(v)), n = 60))
      s <- s[is.finite(s)]
      if (length(s) >= 2) return(max(0.001, s[2] - s[1]))
      max(0.001, as.numeric(v) / 120)
    }
    up_delta <- .nice_upper(max_delta)
    up_top1 <- .nice_upper(max_top1)
    up_top2 <- .nice_upper(max_top2)
    .lbl <- function(v, fallback) {
      x <- as.character(v %||% "")
      if (!nzchar(trimws(x))) fallback else x
    }

    tagList(
      hr(),
      h5(.lbl(HTO_UI_TEXT$t_title_additional_signal_thresholds, "Additional signal thresholds")),
      checkboxInput("hto_enable_signal_thresholds", .lbl(HTO_UI_TEXT$t_label_enable_signal_based_filtering, "Enable signal-based filtering"), value = FALSE),
      sliderInput("hto_min_delta", .lbl(HTO_UI_TEXT$t_label_min_delta_top1_top2, "Min delta (top1 - top2)"), min = 0, max = up_delta, value = 0, step = .nice_step(up_delta)),
      sliderInput("hto_min_top1", .lbl(HTO_UI_TEXT$t_label_min_highest_signal_top1, "Min highest signal (top1)"), min = 0, max = up_top1, value = 0, step = .nice_step(up_top1)),
      sliderInput("hto_max_top2", .lbl(HTO_UI_TEXT$t_label_max_second_highest_signal_top2, "Max second-highest signal (top2)"), min = 0, max = up_top2, value = up_top2, step = .nice_step(up_top2)),
      tags$div(
        class = "text-muted",
        style = "font-size:0.92em; margin-top:6px;",
        "Tuning guide: increase ",
        tags$b(.lbl(HTO_UI_TEXT$t_text_min_delta, "Min delta")),
        " and/or ",
        tags$b(.lbl(HTO_UI_TEXT$t_text_min_top1, "Min top1")),
        " for stricter singlet calls; decrease ",
        tags$b(.lbl(HTO_UI_TEXT$t_text_max_top2, "Max top2")),
        " to remove ambiguous cells with strong second hashtag."
      )
    )
  })

  observeEvent(input$hto_run_btn, {
    nm <- input$hto_object_name %||% shared_data$active_object_name
    assay <- input$hto_assay_name
    req(nm, assay)

    entry <- .get_entry(nm)
    obj <- .get_obj(entry)
    req(!is.null(obj))

    overlay_show("Running hashtag demultiplexing and hashtag t-SNE…")
    on.exit(overlay_hide(), add = TRUE)

    seed_val <- suppressWarnings(as.integer(trimws(as.character(input$hto_seed %||% ""))))
    if (!is.finite(seed_val) || seed_val <= 0) seed_val <- 42L

    out <- tryCatch(
      core_hto_run_demux(
        sobj = obj,
        assay = assay,
        method = input$hto_method %||% "HTODemux",
        positive_quantile = input$hto_positive_quantile %||% 0.99,
        multi_quantile = input$hto_multi_quantile %||% 0.7,
        auto_thresh = isTRUE(input$hto_auto_thresh),
        normalize_before_demux = isTRUE(input$hto_normalize_before_demux),
        init = trimws(as.character(input$hto_adv_init %||% "")),
        nstarts = as.integer(input$hto_adv_nstarts %||% 100L),
        kfunc = as.character(input$hto_adv_kfunc %||% "clara"),
        nsamples = as.integer(input$hto_adv_nsamples %||% 100L),
        maxiter = as.integer(input$hto_adv_maxiter %||% 5L),
        qrange = as.numeric(input$hto_adv_qrange %||% c(0.1, 0.9)),
        preprocess_background_quantile = as.numeric(input$hto_preprocess_background_quantile %||% 0),
        preprocess_robust_scale = isTRUE(input$hto_preprocess_robust_scale),
        seed = seed_val
      ),
      error = function(e) e
    )

    if (inherits(out, "error")) {
      hto_status(list(type = "error", msg = paste("Demux failed:", conditionMessage(out))))
      return()
    }

    obj_after <- tryCatch(
      core_hto_ensure_tsne(out$object, assay = assay, seed = seed_val, reduction_name = "hto.tsne"),
      error = function(e) out$object
    )

    if (is.list(entry) && !is.null(entry$obj)) {
      entry$obj <- obj_after
      if (is.null(entry$prefs) || !is.list(entry$prefs)) entry$prefs <- list()
      if (is.null(entry$plots) || !is.list(entry$plots)) entry$plots <- list()
      if (is.null(entry$analysis_cache) || !is.list(entry$analysis_cache)) entry$analysis_cache <- list()
      entry$meta$hto <- list(
        assay = assay,
        method = input$hto_method %||% "HTODemux",
        normalize_before_demux = isTRUE(input$hto_normalize_before_demux),
        class_col = out$class_col,
        id_col = out$id_col,
        ran_at = Sys.time()
      )
      shared_data$all_seurat_objects[[nm]] <- entry
    } else {
      shared_data$all_seurat_objects[[nm]] <- list(
        obj = obj_after,
        prefs = list(),
        plots = list(),
        analysis_cache = list()
      )
    }

    hto_info(list(
      object_name = nm,
      assay = assay,
      class_col = out$class_col,
      id_col = out$id_col,
      summary = out$summary
    ))
    updateSelectizeInput(session, "hto_keep_ids", choices = out$mapped_ids, selected = character(0), server = TRUE)
    hto_status(list(type = "info", msg = sprintf("Hashtag demultiplexing complete. Class column: %s%s",
                                                 out$class_col,
                                                 ifelse(is.na(out$id_col), "", paste0(" | ID column: ", out$id_col)))))
  })

  output$hto_assignment_table <- renderDT({
    info <- hto_info()
    if (is.null(info)) {
      return(datatable(data.frame(Message = "Run demultiplexing to populate assignment details."), options = list(dom = "t"), rownames = FALSE))
    }
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    tbl <- core_hto_build_assignment_table(obj, class_col = info$class_col, id_col = info$id_col)
    if (is.null(tbl) || !nrow(tbl)) {
      return(datatable(data.frame(Message = "No assignment rows available."), options = list(dom = "t"), rownames = FALSE))
    }
    datatable(tbl, rownames = FALSE, options = list(pageLength = 10, scrollX = TRUE))
  }, server = FALSE)

  output$hto_tsne_plot <- renderPlotly({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    md <- obj@meta.data
    class_col <- .resolve_class_col(info, md)
    validate(need(!is.na(class_col), "No hashtag classification column found for selected object."))

    red_names <- names(obj@reductions)
    ridx <- which(tolower(red_names) %in% c("hto.tsne", "hto_tsne", "tsne"))
    validate(need(length(ridx) > 0, "No hashtag t-SNE found. Run hashtag demultiplexing first."))
    red <- red_names[ridx[1]]
    emb <- as.matrix(Seurat::Embeddings(obj, red))
    validate(need(ncol(emb) >= 2, "HTO t-SNE requires two embedding dimensions (TSNE_1/TSNE_2)."))
    cls <- .safe_class_values(md, rownames(emb), info, fallback = "unknown")
    keep_df <- .keep_mask_from_inputs()
    keep_map <- keep_df$status
    names(keep_map) <- .hto_diag_df()$cell
    status <- as.character(keep_map[rownames(emb)] %||% "Filtered out")
    status[is.na(status)] <- "Filtered out"

    df <- data.frame(
      cell = rownames(emb),
      TSNE_1 = emb[, 1],
      TSNE_2 = emb[, 2],
      class = cls,
      status = status,
      stringsAsFactors = FALSE
    )

    p <- plot_ly()
    st_pal <- HTO_COLOR_KNOBS$status
    status_specs <- list(
      list(lbl = "Filtered out", col = st_pal[["Filtered out"]] %||% "#9ca3af", sz = 4, op = 0.55),
      list(lbl = "Refined out", col = st_pal[["Refined out"]] %||% "#f59e0b", sz = 3, op = 0.72),
      list(lbl = "Kept", col = st_pal[["Kept"]] %||% "#16a34a", sz = 3, op = 0.80)
    )
    for (sp in status_specs) {
      dd <- df[df$status == sp$lbl, , drop = FALSE]
      if (!nrow(dd)) next
      p <- p %>% add_trace(
        data = dd,
        x = ~TSNE_1, y = ~TSNE_2,
        type = "scattergl", mode = "markers",
        name = sp$lbl,
        marker = list(size = sp$sz, color = sp$col, opacity = sp$op),
        text = ~paste0("Cell: ", cell, "<br>Status: ", sp$lbl, "<br>Class: ", class),
        hoverinfo = "text",
        showlegend = FALSE
      ) %>%
        add_trace(
          x = 0, y = 0,
          type = "scatter", mode = "markers",
          name = sp$lbl,
          marker = list(size = .legend_dot_size(sp$sz), color = sp$col, opacity = 0.95),
          hoverinfo = "skip",
          visible = "legendonly",
          inherit = FALSE,
          showlegend = TRUE
        )
    }
    p %>% layout(
        title = list(text = sprintf("%s (kept vs filtered)", red), x = 0.5, y = 0.985),
        xaxis = list(title = HTO_UI_TEXT$t_text_t_sne_1, constrain = "domain", zeroline = FALSE, showline = TRUE, linecolor = "#64748b"),
        yaxis = list(title = HTO_UI_TEXT$t_text_t_sne_2, scaleanchor = "x", scaleratio = 1, zeroline = FALSE, showline = TRUE, linecolor = "#64748b"),
        legend = list(orientation = "h", x = 0.01, y = 1.02, xanchor = "left", yanchor = "bottom", font = list(size = 11)),
        margin = list(l = 60, r = 20, t = 92, b = 55)
      )
  })

  .hto_ridge_features <- reactive({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    mm <- as.matrix(mat)
    req(nrow(mm) > 0)
    ord <- order(rowMeans(mm, na.rm = TRUE), decreasing = TRUE)
    feats <- rownames(mm)[ord]
    feats[seq_len(min(length(feats), 8))]
  })

  .hto_scatter_features <- reactive({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    mm <- as.matrix(mat)
    req(nrow(mm) > 0)
    ord <- order(rowMeans(mm, na.rm = TRUE), decreasing = TRUE)
    rownames(mm)[ord]
  })

  .scatter_axis_choices <- reactive({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    mm <- as.matrix(mat)
    hto_feats <- rownames(mm)
    hto_feats <- as.character(hto_feats %||% character(0))
    hto_feats <- hto_feats[nzchar(hto_feats)]
    hto_named <- stats::setNames(paste0("hto::", hto_feats), paste0("HTO: ", hto_feats))

    md <- obj@meta.data
    rna_candidates <- c("nCount_RNA", "nFeature_RNA", "percent.mt", "pct.mt", "nCount_SCT", "nFeature_SCT")
    rna_candidates <- rna_candidates[rna_candidates %in% colnames(md)]
    keep_num <- vapply(rna_candidates, function(cc) is.numeric(md[[cc]]) || is.integer(md[[cc]]), logical(1))
    rna_cols <- rna_candidates[keep_num]
    rna_named <- if (length(rna_cols)) {
      stats::setNames(paste0("meta::", rna_cols), paste0("RNA: ", rna_cols))
    } else {
      character(0)
    }
    c(hto_named, rna_named)
  })

  .scatter_axis_values <- function(axis_id, mat, md, cells) {
    id <- as.character(axis_id %||% "")
    if (!nzchar(id)) return(rep(NA_real_, length(cells)))
    if (startsWith(id, "hto::")) {
      feat <- sub("^hto::", "", id)
      if (feat %in% rownames(mat)) return(as.numeric(mat[feat, cells]))
      return(rep(NA_real_, length(cells)))
    }
    if (startsWith(id, "meta::")) {
      col_nm <- sub("^meta::", "", id)
      if (length(col_nm) == 1 && nzchar(col_nm) && (col_nm %in% colnames(md))) return(as.numeric(md[cells, col_nm]))
      return(rep(NA_real_, length(cells)))
    }
    rep(NA_real_, length(cells))
  }

  .axis_min_top1_threshold <- function(axis_id) {
    id <- as.character(axis_id %||% "")
    if (!startsWith(id, "hto::")) return(NA_real_)
    feat <- sub("^hto::", "", id)
    thr <- 0
    if (isTRUE(input$hto_enable_signal_thresholds)) {
      gthr <- suppressWarnings(as.numeric(input$hto_min_top1 %||% 0))
      if (is.finite(gthr)) thr <- max(thr, gthr)
    }
    if (isTRUE(input$hto_enable_per_feature_thresholds)) {
      per_feat <- .per_feature_min_thresholds()
      fthr <- suppressWarnings(as.numeric(per_feat[feat] %||% 0))
      if (is.finite(fthr)) thr <- max(thr, fthr)
    }
    if (!is.finite(thr) || thr <= 0) return(NA_real_)
    thr
  }

  .as_plotly_qc <- function(p) {
    plotly::ggplotly(p, tooltip = "text") |>
      plotly::layout(hovermode = "closest") |>
      plotly::config(displaylogo = FALSE)
  }

  .legend_dot_size <- function(point_size) {
    sc <- suppressWarnings(as.numeric(HTO_COLOR_KNOBS$legend_dot_scale %||% 2))
    if (!is.finite(sc) || sc <= 0) sc <- 2
    max(6, as.numeric(point_size) * sc)
  }

  output$hto_ridge_feature_ui <- renderUI({
    feats <- .hto_ridge_features()
    req(length(feats) > 0)
    sel <- input$hto_ridge_feature
    if (!.is_valid_choice(sel, feats)) sel <- feats[[1]]
    tagList(
      selectInput("hto_ridge_feature", HTO_UI_TEXT$t_label_hashtag_feature, choices = feats, selected = sel),
      tags$div(
        class = "text-muted",
        style = "font-size:0.92em;",
        "Each row uses that row hashtag's own signal (all cells = gray).",
        "Green overlays cells assigned+kept for that same hashtag.",
        "Selected hashtag row singlet subset is highlighted in yellow."
      )
    )
  })

  .threshold_input_id <- function(feat) {
    paste0("hto_min_top1_by_", gsub("[^A-Za-z0-9]+", "_", as.character(feat %||% "")))
  }

  .manual_per_feature_min_thresholds <- reactive({
    info <- hto_info()
    if (is.null(info)) return(numeric(0))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    feats <- rownames(as.matrix(mat))
    req(length(feats) > 0)
    out <- stats::setNames(rep(0, length(feats)), feats)
    for (f in feats) {
      v <- suppressWarnings(as.numeric(input[[.threshold_input_id(f)]] %||% 0))
      if (is.finite(v) && v > 0) out[[f]] <- v
    }
    out
  })

  .auto_per_feature_min_thresholds <- reactive({
    if (!isTRUE(input$hto_auto_per_feature_calibration)) return(numeric(0))
    info <- hto_info()
    if (is.null(info)) return(numeric(0))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    q <- suppressWarnings(as.numeric(input$hto_auto_per_feature_quantile %||% 0.05))
    if (!is.finite(q)) q <- 0.05
    q <- min(max(q, 0.001), 0.5)
    tryCatch(
      core_hto_auto_per_feature_thresholds(
        sobj = obj,
        assay = info$assay,
        class_col = info$class_col,
        id_col = info$id_col,
        lower_quantile = q
      ),
      error = function(e) numeric(0)
    )
  })

  .per_feature_min_thresholds <- reactive({
    man <- .manual_per_feature_min_thresholds()
    auto <- .auto_per_feature_min_thresholds()
    if (!length(man) && !length(auto)) return(numeric(0))
    all_feats <- unique(c(names(man), names(auto)))
    if (!length(all_feats)) return(numeric(0))
    out <- stats::setNames(rep(0, length(all_feats)), all_feats)
    if (length(auto)) {
      a <- suppressWarnings(as.numeric(auto[all_feats]))
      a[!is.finite(a)] <- 0
      out <- pmax(out, a)
    }
    if (length(man)) {
      m <- suppressWarnings(as.numeric(man[all_feats]))
      m[!is.finite(m)] <- 0
      out <- pmax(out, m)
    }
    out
  })

  output$hto_per_feature_threshold_ui <- renderUI({
    info <- hto_info()
    if (is.null(info)) return(NULL)
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    mm <- as.matrix(mat)
    feats <- rownames(mm)
    req(length(feats) > 0)
    feat_max <- suppressWarnings(apply(mm, 1, function(v) max(as.numeric(v), na.rm = TRUE)))
    feat_max[!is.finite(feat_max) | feat_max <= 0] <- 1
    auto_vals <- .auto_per_feature_min_thresholds()

    enable_cur <- isTRUE(isolate(input$hto_enable_per_feature_thresholds %||% FALSE))
    auto_cur <- isTRUE(isolate(input$hto_auto_per_feature_calibration %||% TRUE))
    q_cur <- suppressWarnings(as.numeric(isolate(input$hto_auto_per_feature_quantile %||% 0.05)))
    if (!is.finite(q_cur)) q_cur <- 0.05
    q_cur <- min(max(q_cur, 0.001), 0.5)
    tags$details(
      class = "hto-per-feature-wrap",
      tags$summary("Per-hashtag thresholds"),
      tags$div(
        class = "hto-per-feature-box",
        checkboxInput(
          "hto_enable_per_feature_thresholds",
          HTO_UI_TEXT$t_text_enable_per_hashtag_minimum_top_signal %||% "Enable per-hashtag minimum top signal (top1)",
          value = enable_cur
        ),
        checkboxInput(
          "hto_auto_per_feature_calibration",
          HTO_UI_TEXT$t_label_auto_per_hashtag_calibration %||% "Auto per-hashtag calibration",
          value = auto_cur
        ),
        sliderInput(
          "hto_auto_per_feature_quantile",
          HTO_UI_TEXT$t_label_auto_calibration_lower_quantile %||% "Calibration lower quantile (singlet distribution)",
          min = 0.001, max = 0.5, value = q_cur, step = 0.005
        ),
        tags$div(
          class = "text-muted",
          style = "font-size:0.9em; margin-bottom:6px;",
          "Use different minimum top-signal cutoffs for each hashtag ID when strengths differ. Auto calibration uses singlet distributions; manual slider values can tighten thresholds further."
        ),
        lapply(feats, function(f) {
          sid <- .threshold_input_id(f)
          vmax <- as.numeric(signif(feat_max[f], 4))
          if (!is.finite(vmax) || vmax <= 0) vmax <- 1
          step <- max(0.01, signif(vmax / 150, 2))
          auto_base <- suppressWarnings(as.numeric(auto_vals[f] %||% 0))
          if (!is.finite(auto_base) || auto_base < 0) auto_base <- 0
          cur <- suppressWarnings(as.numeric(isolate(input[[sid]] %||% auto_base)))
          if (!is.finite(cur)) cur <- 0
          cur <- min(max(cur, 0), vmax)
          sliderInput(
            inputId = sid,
            label = paste0(f, " min top1"),
            min = 0,
            max = vmax,
            value = cur,
            step = step
          )
        })
      )
    )
  })

  output$hto_heatmap_ui <- renderUI({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    max_cells <- max(1000L, min(15000L, ncol(obj)))
    .lbl <- function(v, fallback) {
      x <- as.character(v %||% "")
      if (!nzchar(trimws(x))) fallback else x
    }
    tags$div(
      class = "hto-heatmap-controls",
      style = "margin-top:0; margin-bottom:0;",
      fluidRow(
        column(
          6,
          tags$div(style = "display:block !important; color:#111827 !important; font-weight:700 !important; font-size:14px !important; margin-bottom:4px !important; visibility:visible !important; opacity:1 !important;", .lbl(HTO_UI_TEXT$t_text_group_label_columns, "Group/label columns")),
          selectInput(
            "hto_heatmap_group_by",
            label = NULL,
            choices = c(
              "Detailed demultiplex class (recommended)" = "class",
              "Hashtag ID (if available)" = "id"
            ),
            selected = "class"
          )
        ),
        column(
          6,
          tags$div(style = "display:block !important; color:#111827 !important; font-weight:700 !important; font-size:14px !important; margin-bottom:4px !important; visibility:visible !important; opacity:1 !important;", .lbl(HTO_UI_TEXT$t_text_cells_shown_heatmap, "Cells shown in heatmap")),
          sliderInput(
            "hto_heatmap_ncells",
            label = NULL,
            min = 500,
            max = max_cells,
            value = min(2500L, max_cells),
            step = 250
          )
        )
      ),
      fluidRow(
        column(
          12,
          tags$div(style = "display:block; color:#111827; font-weight:700; font-size:13px; margin-top:2px; margin-bottom:2px;",
                   HTO_UI_TEXT$t_text_hashtag_color_key %||% "Hashtag color key"),
          uiOutput("hto_heatmap_palette_ui")
        )
      )
    )
  })

  output$hto_heatmap_palette_ui <- renderUI({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    htags <- rownames(as.matrix(mat))
    pal <- .hashtag_palette(htags)
    if (!length(pal)) return(NULL)
    tags$div(
      class = "hto-color-key",
      lapply(names(pal), function(nm) {
        tags$span(class = "item",
          tags$span(class = "sw", style = paste0("background:", pal[[nm]], ";")),
          tags$span(nm)
        )
      })
    )
  })

  output$hto_feature_scatter_ui <- renderUI({
    feats <- .hto_scatter_features()
    req(length(feats) >= 2)
    hto_axis_choices <- stats::setNames(paste0("hto::", feats), feats)
    axis_choices <- .scatter_axis_choices()
    req(length(axis_choices) >= 2)
    default_x <- paste0("hto::", feats[[1]])
    default_y <- paste0("hto::", feats[[min(2, length(feats))]])
    xsel <- input$hto_scatter_x
    ysel <- input$hto_scatter_y
    if (!.is_valid_choice(xsel, hto_axis_choices)) xsel <- default_x
    if (!.is_valid_choice(ysel, hto_axis_choices) || identical(ysel, xsel)) {
      ysel <- default_y
      if (identical(ysel, xsel) && length(hto_axis_choices) > 1) {
        ysel <- hto_axis_choices[[2]]
      }
    }
    bottom_x <- input$hto_scatter_bottom_x
    bottom_y <- input$hto_scatter_bottom_y
    rna_vals <- as.character(axis_choices[startsWith(as.character(axis_choices), "meta::")])
    if (length(rna_vals) >= 2) {
      default_bottom_x <- rna_vals[[1]]
      default_bottom_y <- rna_vals[[2]]
    } else if (length(rna_vals) == 1) {
      default_bottom_x <- rna_vals[[1]]
      default_bottom_y <- axis_choices[[1]]
      if (identical(default_bottom_y, default_bottom_x) && length(axis_choices) > 1) default_bottom_y <- axis_choices[[2]]
    } else {
      default_bottom_x <- axis_choices[[1]]
      default_bottom_y <- axis_choices[[min(2, length(axis_choices))]]
    }
    if (!.is_valid_choice(bottom_x, axis_choices)) bottom_x <- default_bottom_x
    if (!.is_valid_choice(bottom_y, axis_choices) || identical(bottom_y, bottom_x)) {
      bottom_y <- default_bottom_y
      if (identical(bottom_y, bottom_x) && length(axis_choices) > 1) bottom_y <- axis_choices[[2]]
    }
    xhtag <- if (startsWith(xsel, "hto::")) sub("^hto::", "", xsel) else ""
    yhtag <- if (startsWith(ysel, "hto::")) sub("^hto::", "", ysel) else ""
    focus_default <- unique(c(xhtag, yhtag))
    focus_default <- focus_default[nzchar(focus_default)]

    tags$div(
      class = "hto-scatter-controls",
      tags$div(class = "hto-scatter-title", HTO_UI_TEXT$t_text_hashtag_feature_scatter_controls),
      tags$div(class = "hto-scatter-hint", HTO_UI_TEXT$t_text_top_row_uses_shared_hto_axes),
      tags$div(class = "control-label", style = "margin-bottom:4px;", HTO_UI_TEXT$t_text_top_plots_axis_controls_hto_only),
      fluidRow(
        column(6, selectInput("hto_scatter_x", HTO_UI_TEXT$t_label_x_axis_feature, choices = hto_axis_choices, selected = xsel)),
        column(6, selectInput("hto_scatter_y", HTO_UI_TEXT$t_label_y_axis_feature, choices = hto_axis_choices, selected = ysel))
      ),
      fluidRow(
        column(
          6,
          selectInput(
            "hto_scatter_view_mode",
            HTO_UI_TEXT$t_text_display_mode,
            choices = c(
              "Selected hashtags only" = "selected_only",
              "Selected hashtags + gray context" = "selected_plus_bg",
              "All cells" = "all"
            ),
            selected = "selected_plus_bg"
          )
        )
      ),
      fluidRow(
        column(
          4,
          selectInput(
            "hto_scatter_color_by",
            HTO_UI_TEXT$t_text_color_points,
            choices = c(
              "Demultiplex class" = "class",
              "Top hashtag (dominant signal)" = "top_feature",
              "Keep status (kept vs filtered)" = "status"
            ),
            selected = "class"
          )
        ),
        column(4, sliderInput("hto_scatter_point_size", HTO_UI_TEXT$t_label_point_size, min = 2, max = 8, value = 4, step = 1)),
        column(4, sliderInput("hto_scatter_alpha", HTO_UI_TEXT$t_label_point_opacity, min = 0.20, max = 1.00, value = 0.78, step = 0.02))
      ),
      fluidRow(
        column(
          8,
          checkboxGroupInput(
            "hto_scatter_status_show",
            HTO_UI_TEXT$t_text_status_show,
            choices = c("Kept" = "Kept", "Refined out" = "Refined out", "Filtered out" = "Filtered out"),
            selected = c("Kept", "Refined out", "Filtered out"),
            inline = TRUE
          )
        ),
        column(
          4,
          tags$div(style = "margin-top:22px; text-align:right;",
            actionButton("hto_scatter_clear_sel", HTO_UI_TEXT$t_btn_clear_selection, icon = icon("times-circle"), class = "btn btn-default btn-sm")
          )
        )
      ),
      tags$hr(style = "margin:10px 0;"),
      tags$div(class = "control-label", style = "margin-bottom:4px;", HTO_UI_TEXT$t_text_bottom_plot_axis_controls_rna_mixed),
      fluidRow(
        column(6, selectInput("hto_scatter_bottom_x", HTO_UI_TEXT$t_label_bottom_x_axis, choices = axis_choices, selected = bottom_x)),
        column(6, selectInput("hto_scatter_bottom_y", HTO_UI_TEXT$t_label_bottom_y_axis, choices = axis_choices, selected = bottom_y))
      ),
      fluidRow(
        column(
          6,
          selectInput(
            "hto_scatter_bottom_color_by",
            HTO_UI_TEXT$t_label_bottom_color,
            choices = c(
              "Demultiplex class" = "class",
              "Top hashtag (dominant signal)" = "top_feature",
              "Keep status (kept vs filtered)" = "status"
            ),
            selected = "status"
          )
        )
      ),
      {
        pop_opts <- .scatter_population_options(focus_default)
        labs <- names(pop_opts$choices)
        vals <- as.character(unname(pop_opts$choices))
        is_doublet <- grepl("^Doublet:", labs)
        is_other <- labs %in% c("Negative", "Unknown/other")
        sing_vals <- vals[!is_doublet & !is_other]
        dbl_vals <- vals[is_doublet]
        oth_vals <- vals[is_other]
        sel <- as.character(pop_opts$selected %||% character(0))
        tags$div(
          class = "hto-pop-grid",
          tags$details(
            tags$summary("Show populations (individual classes)"),
            tags$div(
              class = "pop-summary",
              style = "margin:6px 0 4px 0;",
              "Singlets"
            ),
            checkboxGroupInput(
              "hto_scatter_cls_singlets",
              NULL,
              choices = stats::setNames(sing_vals, labs[!is_doublet & !is_other]),
              selected = intersect(sel, sing_vals),
              inline = TRUE
            ),
            tags$div(
              class = "pop-summary",
              style = "margin:4px 0;",
              "Other"
            ),
            checkboxGroupInput(
              "hto_scatter_cls_other",
              NULL,
              choices = stats::setNames(oth_vals, labs[is_other]),
              selected = intersect(sel, oth_vals),
              inline = TRUE
            ),
            tags$div(
              class = "pop-summary",
              style = "margin:4px 0;",
              "Doublets"
            ),
            tags$div(
              class = "doublet-grid",
              checkboxGroupInput(
                "hto_scatter_cls_doublets",
                NULL,
                choices = stats::setNames(dbl_vals, labs[is_doublet]),
                selected = intersect(sel, dbl_vals),
                inline = FALSE
              )
            )
          )
        )
      }
    )
  })

  .class_contains_hashtag <- function(class_label, tag) {
    cl <- as.character(class_label %||% "")
    if (!nzchar(cl) || !nzchar(tag)) return(FALSE)
    if (identical(cl, tag)) return(TRUE)
    parts <- unlist(strsplit(cl, "_", fixed = TRUE), use.names = FALSE)
    any(parts == tag)
  }

  .scatter_population_label <- function(class_value) {
    cl <- as.character(class_value %||% "")
    if (!nzchar(cl)) return("Unknown/other")
    if (identical(cl, "Unknown/other")) return("Unknown/other")
    kind <- .class_kind(cl)
    if (identical(kind, "doublet")) return(paste0("Doublet: ", gsub("_", " + ", cl, fixed = TRUE)))
    if (identical(kind, "negative")) return("Negative")
    cl
  }

  .scatter_population_options <- function(selected_tags = character(0)) {
    info <- hto_info()
    if (is.null(info)) return(list(choices = character(0), selected = character(0)))
    obj <- .get_obj(.get_entry(info$object_name))
    if (is.null(obj)) return(list(choices = character(0), selected = character(0)))
    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    if (is.null(mat)) return(list(choices = character(0), selected = character(0)))
    md <- obj@meta.data
    cc <- .resolve_class_col(info, md)
    if (is.na(cc)) return(list(choices = character(0), selected = character(0)))
    cls <- as.character(md[colnames(mat), cc, drop = TRUE] %||% "")
    is_unknown <- !nzchar(cls) | tolower(cls) %in% c("unknown", "na", "n/a", "unassigned")
    cls[is_unknown] <- "Unknown/other"
    cls <- unique(cls)
    cls <- cls[nzchar(cls)]
    if (!length(cls)) return(list(choices = character(0), selected = character(0)))

    known <- setdiff(cls, "Unknown/other")
    ordered <- character(0)
    if (length(known)) ordered <- .ordered_classes(known)
    if ("Unknown/other" %in% cls) ordered <- c(ordered, "Unknown/other")

    labels <- vapply(ordered, .scatter_population_label, character(1))
    choices <- stats::setNames(ordered, labels)

    selected_tags <- as.character(selected_tags %||% character(0))
    selected_tags <- selected_tags[nzchar(selected_tags)]
    preselected <- ordered[vapply(
      ordered,
      function(cl) {
        if (identical(cl, "Unknown/other")) return(FALSE)
        any(vapply(selected_tags, function(tag) .class_contains_hashtag(cl, tag), logical(1)))
      },
      logical(1)
    )]
    if (!length(preselected)) preselected <- ordered
    list(choices = choices, selected = preselected)
  }

  .make_ridge_df <- function(mat, keep_df, diag_df, selected_feature) {
    feats <- rownames(mat)
    cells <- colnames(mat)
    if (is.null(feats) || !length(feats) || is.null(cells) || !length(cells)) {
      return(list(raw = data.frame(), selected = data.frame(), kept = data.frame(), features = character(0)))
    }

    raw_df <- do.call(rbind, lapply(feats, function(f) {
      data.frame(feature = f, value = as.numeric(mat[f, ]), stringsAsFactors = FALSE)
    }))
    raw_df <- raw_df[is.finite(raw_df$value), , drop = FALSE]

    keep_final <- rep(FALSE, length(cells))
    keep_class <- rep(TRUE, length(cells))
    top_feature <- rep("", length(cells))
    is_singlet <- rep(FALSE, length(cells))
    if (!is.null(keep_df) && !is.null(diag_df) && nrow(keep_df) == nrow(diag_df)) {
      keep_final <- as.logical(keep_df$keep_final)
      keep_final[is.na(keep_final)] <- FALSE
      keep_class <- as.logical(keep_df$keep_class)
      keep_class[is.na(keep_class)] <- FALSE
      top_feature <- as.character(diag_df$top_feature %||% "")
      cls <- as.character(diag_df$class %||% "")
      is_singlet <- vapply(cls, function(cl) identical(.class_kind(cl), "singlet"), logical(1))
      is_singlet[is.na(is_singlet)] <- FALSE
    }

    selected_df <- data.frame(feature = character(0), value = numeric(0), stringsAsFactors = FALSE)
    if (!is.null(selected_feature) && nzchar(selected_feature) && selected_feature %in% feats) {
      idx <- which(top_feature == selected_feature & is_singlet & keep_class)
      if (length(idx)) {
        selected_df <- data.frame(
          feature = selected_feature,
          value = as.numeric(mat[selected_feature, idx]),
          stringsAsFactors = FALSE
        )
        selected_df <- selected_df[is.finite(selected_df$value), , drop = FALSE]
      }
    }

    kept_df <- do.call(rbind, lapply(feats, function(f) {
      idx <- which(top_feature == f & keep_final)
      if (!length(idx)) return(NULL)
      data.frame(feature = f, value = as.numeric(mat[f, idx]), stringsAsFactors = FALSE)
    }))
    if (is.null(kept_df)) {
      kept_df <- data.frame(feature = character(0), value = numeric(0), stringsAsFactors = FALSE)
    } else {
      kept_df <- kept_df[is.finite(kept_df$value), , drop = FALSE]
    }

    list(raw = raw_df, selected = selected_df, kept = kept_df, features = feats)
  }

  output$hto_ridge_plot <- renderPlotly({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    feat <- input$hto_ridge_feature
    validate(need(!is.null(feat) && nzchar(feat), "Pick a hashtag feature."))
    validate(need(feat %in% .hto_ridge_features(), "Selected hashtag feature is not available."))
    keep_df <- .keep_mask_from_inputs()
    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    diag_df <- .hto_diag_df()
    mm <- as.matrix(mat)
    feats <- rownames(mm)
    cells <- colnames(mm)
    validate(need(length(feats) > 0 && length(cells) > 0, "Not enough cells to draw ridge plot."))

    keep_final <- rep(FALSE, length(cells))
    keep_class <- rep(TRUE, length(cells))
    top_feature <- rep("", length(cells))
    is_singlet <- rep(FALSE, length(cells))
    if (!is.null(keep_df) && !is.null(diag_df) && nrow(keep_df) == nrow(diag_df)) {
      keep_final <- as.logical(keep_df$keep_final)
      keep_final[is.na(keep_final)] <- FALSE
      keep_class <- as.logical(keep_df$keep_class)
      keep_class[is.na(keep_class)] <- FALSE
      top_feature <- as.character(diag_df$top_feature %||% "")
      cls <- as.character(diag_df$class %||% "")
      is_singlet <- vapply(cls, function(cl) identical(.class_kind(cl), "singlet"), logical(1))
      is_singlet[is.na(is_singlet)] <- FALSE
    }

    .bins <- 140
    subplots <- lapply(seq_along(feats), function(i) {
      f <- feats[[i]]
      raw_vals <- as.numeric(mm[f, ])
      raw_vals <- raw_vals[is.finite(raw_vals)]
      kept_idx <- which(top_feature == f & keep_final)
      kept_vals <- as.numeric(mm[f, kept_idx])
      kept_vals <- kept_vals[is.finite(kept_vals)]
      sel_vals <- numeric(0)
      if (identical(f, feat)) {
        sel_idx <- which(top_feature == f & is_singlet & keep_class)
        sel_vals <- as.numeric(mm[f, sel_idx])
        sel_vals <- sel_vals[is.finite(sel_vals)]
      }
      min_top1_thr <- 0
      if (isTRUE(input$hto_enable_signal_thresholds)) {
        v <- suppressWarnings(as.numeric(input$hto_min_top1 %||% 0))
        if (is.finite(v)) min_top1_thr <- max(min_top1_thr, v)
      }
      if (isTRUE(input$hto_enable_per_feature_thresholds)) {
        per_feat <- .per_feature_min_thresholds()
        v <- suppressWarnings(as.numeric(per_feat[f] %||% 0))
        if (is.finite(v)) min_top1_thr <- max(min_top1_thr, v)
      }

      p <- plot_ly()
      if (length(raw_vals)) {
        p <- p %>% add_histogram(
          x = raw_vals,
          nbinsx = .bins,
          name = "Raw",
          marker = list(color = "#9ca3af"),
          opacity = 0.28,
          legendgroup = "ridge_raw",
          showlegend = FALSE,
          hovertemplate = paste0("Feature: ", f, "<br>Status: Raw<br>Signal: %{x:.3f}<br>Cells: %{y}<extra></extra>")
        )
      }
      if (length(kept_vals)) {
        p <- p %>% add_histogram(
          x = kept_vals,
          nbinsx = .bins,
          name = "Assigned kept",
          marker = list(color = "#16a34a"),
          opacity = 0.34,
          legendgroup = "ridge_kept",
          showlegend = FALSE,
          hovertemplate = paste0("Feature: ", f, "<br>Status: Assigned kept<br>Signal: %{x:.3f}<br>Cells: %{y}<extra></extra>")
        )
      }
      if (length(sel_vals)) {
        p <- p %>% add_histogram(
          x = sel_vals,
          nbinsx = .bins,
          name = "Selected row singlets",
          marker = list(color = "#facc15"),
          opacity = 0.36,
          legendgroup = "ridge_selected",
          showlegend = FALSE,
          hovertemplate = paste0("Feature: ", f, "<br>Status: Selected row singlets<br>Signal: %{x:.3f}<br>Cells: %{y}<extra></extra>")
        )
      }
      if (is.finite(min_top1_thr) && min_top1_thr > 0) {
        ytop <- 1
        if (length(raw_vals)) ytop <- max(ytop, max(hist(raw_vals, breaks = .bins, plot = FALSE)$counts, na.rm = TRUE))
        if (length(kept_vals)) ytop <- max(ytop, max(hist(kept_vals, breaks = .bins, plot = FALSE)$counts, na.rm = TRUE))
        if (length(sel_vals)) ytop <- max(ytop, max(hist(sel_vals, breaks = .bins, plot = FALSE)$counts, na.rm = TRUE))
        p <- p %>% add_segments(
          x = min_top1_thr, xend = min_top1_thr,
          y = 1, yend = max(2, ytop),
          inherit = FALSE,
          showlegend = FALSE,
          line = list(color = "#ef4444", dash = "dash", width = 1.1),
          hoverinfo = "skip"
        )
      }
      p %>% layout(
        barmode = "overlay",
        yaxis = list(
          title = NULL,
          type = "log",
          side = "right",
          showticklabels = TRUE,
          tickvals = c(1, 10, 100, 1000, 10000),
          ticktext = c("1", "10", "100", "1k", "10k"),
          tickfont = list(size = 10, color = "#475569"),
          automargin = TRUE
        ),
        xaxis = list(title = NULL, automargin = TRUE),
        margin = list(l = 10, r = 10, t = 3, b = 2)
      )
    })

    n_panels <- length(feats)
    ann_left <- lapply(seq_len(n_panels), function(i) {
      list(
        x = -0.03,
        y = (n_panels - i + 0.5) / n_panels,
        xref = "paper",
        yref = "paper",
        text = feats[[i]],
        showarrow = FALSE,
        xanchor = "right",
        yanchor = "middle",
        align = "right",
        font = list(size = 11, color = "#374151")
      )
    })
    ann_right <- list(
      list(
        x = 0.985,
        y = 1.02,
        xref = "paper",
        yref = "paper",
        text = paste0(
          "<span style='color:#9ca3af'>&#9632;</span> Raw",
          "<br><span style='color:#16a34a'>&#9632;</span> Assigned kept",
          "<br><span style='color:#facc15'>&#9632;</span> Selected row singlets"
        ),
        showarrow = FALSE,
        xanchor = "right",
        yanchor = "top",
        align = "right",
        font = list(size = 10, color = "#334155")
      )
    )
    ann <- c(ann_left, ann_right)

    subplot(subplots, nrows = n_panels, shareX = TRUE, titleY = TRUE, margin = 0.01) %>%
      layout(
        title = list(text = paste0("Ridge plot by hashtag signal (selected: ", feat, ")"), x = 0.5),
        xaxis = list(title = HTO_UI_TEXT$t_text_hashtag_signal, automargin = TRUE),
        plot_bgcolor = "#ffffff",
        paper_bgcolor = "#ffffff",
        showlegend = FALSE,
        margin = list(l = 120, r = 70, t = 70, b = 55),
        annotations = ann
      ) %>%
      config(displaylogo = FALSE)
  })

  output$hto_heatmap_plot <- renderPlot({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    md <- obj@meta.data
    class_col <- .resolve_class_col(info, md)
    validate(need(!is.na(class_col), "No hashtag classification column found for selected object."))

    simple_col <- ".hto_class_simple"
    md[[simple_col]] <- vapply(md[[class_col]], function(v) {
      kind <- .class_kind(v)
      if (identical(kind, "negative")) return("Negative")
      if (identical(kind, "doublet")) return("Doublet")
      "Singlet"
    }, character(1))
    obj@meta.data <- md

    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    mat <- as.matrix(mat)
    req(nrow(mat) > 0, ncol(mat) > 0)

    group_mode <- input$hto_heatmap_group_by %||% "class"
    id_col <- .safe_id_col(info, md)
    if (is.na(id_col) || !nzchar(id_col)) id_col <- NULL
    detail_col <- if (identical(group_mode, "id") && !is.null(id_col)) id_col else class_col
    req(detail_col %in% colnames(md))

    cells_all <- intersect(colnames(mat), rownames(md))
    req(length(cells_all) > 0)

    # Downsample while preserving Negative/Singlet/Doublet mix for readability.
    n_show <- min(as.integer(input$hto_heatmap_ncells %||% 2500L), length(cells_all))
    smp <- md[cells_all, , drop = FALSE]
    smp$.simple <- as.character(smp[[simple_col]])
    set.seed(42L)
    if (n_show < nrow(smp)) {
      pick <- unlist(lapply(split(rownames(smp), smp$.simple), function(v) {
        k <- max(1L, round(n_show * (length(v) / nrow(smp))))
        sample(v, min(k, length(v)))
      }), use.names = FALSE)
      if (length(pick) < n_show) {
        rest <- setdiff(rownames(smp), pick)
        pick <- c(pick, sample(rest, min(n_show - length(pick), length(rest))))
      } else if (length(pick) > n_show) {
        pick <- sample(pick, n_show)
      }
      cells <- unique(pick)
    } else {
      cells <- rownames(smp)
    }

    sub_md <- md[cells, , drop = FALSE]
    sub_simple <- as.character(sub_md[[simple_col]])
    sub_detail <- as.character(sub_md[[detail_col]])
    sub_mat <- mat[, cells, drop = FALSE]
    max_signal <- apply(sub_mat, 2, max, na.rm = TRUE)

    # Order columns by broad class, then subgroup label, then signal.
    simple_levels <- c("Negative", "Singlet", "Doublet")
    ord <- order(factor(sub_simple, levels = simple_levels), tolower(sub_detail), -max_signal, na.last = TRUE)
    cells_ord <- cells[ord]
    sub_simple <- sub_simple[ord]
    sub_detail <- sub_detail[ord]
    sub_mat <- sub_mat[, cells_ord, drop = FALSE]

    df <- as.data.frame(as.table(sub_mat), stringsAsFactors = FALSE)
    colnames(df) <- c("feature", "cell", "value")
    df$value <- as.numeric(df$value)

    cell_map <- data.frame(
      cell = cells_ord,
      x = seq_along(cells_ord),
      simple = sub_simple,
      detail = sub_detail,
      stringsAsFactors = FALSE
    )
    df <- merge(df, cell_map, by = "cell", all.x = TRUE, sort = FALSE)
    df$feature <- factor(df$feature, levels = rev(rownames(sub_mat)))
    df$feature_chr <- as.character(df$feature)
    df$simple <- factor(df$simple, levels = simple_levels)
    clip_hi <- suppressWarnings(stats::quantile(df$value, probs = 0.995, na.rm = TRUE))
    if (!is.finite(clip_hi) || clip_hi <= 0) clip_hi <- suppressWarnings(max(df$value, na.rm = TRUE))
    if (!is.finite(clip_hi) || clip_hi <= 0) clip_hi <- 1
    df$value_clip <- pmax(0, pmin(df$value, clip_hi))
    feat_pal_deep <- .hashtag_palette(rownames(sub_mat), shade = "deep")
    feat_pal_light <- .hashtag_palette(rownames(sub_mat), shade = "light")
    df$fill_hex <- "#dbe4ee"
    for (f in names(feat_pal_deep)) {
      idx <- which(df$feature_chr == f)
      if (!length(idx)) next
      vv <- df$value_clip[idx]
      vv[!is.finite(vv)] <- 0
      rr <- pmax(0, pmin(1, vv / clip_hi))
      low_col <- feat_pal_light[[f]] %||% "#e5edf6"
      high_col <- feat_pal_deep[[f]] %||% "#334155"
      pfun <- grDevices::colorRampPalette(c(low_col, high_col))
      pvec <- pfun(256)
      pick <- 1L + floor(rr * 255)
      pick[pick < 1L] <- 1L
      pick[pick > 256L] <- 256L
      df$fill_hex[idx] <- pvec[pick]
    }

    # Boundaries and subgroup labels.
    runs <- rle(paste(cell_map$simple, cell_map$detail, sep = "|||"))
    ends <- cumsum(runs$lengths)
    starts <- c(1, head(ends, -1) + 1)
    grp <- do.call(rbind, strsplit(runs$values, "\\|\\|\\|"))
    if (is.null(dim(grp))) grp <- matrix(grp, nrow = 1)
    if (ncol(grp) < 2) grp <- cbind(grp, rep("NA", nrow(grp)))
    grp_df <- data.frame(
      simple = grp[, 1],
      detail = grp[, 2],
      x_start = starts,
      x_end = ends,
      n = runs$lengths,
      x_mid = (starts + ends) / 2,
      stringsAsFactors = FALSE
    )
    grp_df$simple <- factor(grp_df$simple, levels = simple_levels)
    vline_df <- grp_df[grp_df$x_end < max(cell_map$x), , drop = FALSE]
    grp_label_df <- grp_df[grp_df$n >= max(15, round(n_show * 0.01)), , drop = FALSE]

    p <- ggplot2::ggplot(df, ggplot2::aes(x = x, y = feature, fill = fill_hex)) +
      ggplot2::geom_raster() +
      ggplot2::facet_grid(~simple, scales = "free_x", space = "free_x") +
      ggplot2::scale_fill_identity() +
      ggplot2::geom_vline(
        data = vline_df,
        ggplot2::aes(xintercept = x_end + 0.5),
        inherit.aes = FALSE,
        color = "#cbd5e1",
        linewidth = 0.4
      ) +
      ggplot2::geom_text(
        data = grp_label_df,
        ggplot2::aes(x = x_mid, y = -Inf, label = detail),
        inherit.aes = FALSE,
        angle = 38,
        vjust = 1.05,
        hjust = 1,
        size = 2.35,
        color = "#1f2937",
        fontface = "bold"
      ) +
      ggplot2::coord_cartesian(clip = "off") +
      ggplot2::theme_minimal(base_family = "Arial") +
      ggplot2::theme(
        plot.title = ggplot2::element_text(face = "bold", size = 14, color = "#0f172a"),
        strip.text = ggplot2::element_text(face = "bold", color = "#0f172a", size = 10.5),
        strip.background = ggplot2::element_rect(fill = "#f1f5f9", color = "#dbe3ec"),
        panel.grid = ggplot2::element_blank(),
        axis.title.x = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_text(face = "bold", color = "#111827"),
        axis.text.y = ggplot2::element_text(color = "#374151"),
        axis.text.x = ggplot2::element_blank(),
        axis.ticks.x = ggplot2::element_blank(),
        legend.title = ggplot2::element_text(face = "bold"),
        plot.margin = grid::unit(c(10, 8, 38, 8), "pt")
      ) +
      ggplot2::labs(
        title = HTO_UI_TEXT$t_text_hto_heatmap_grouped_class_subgroup_labels,
        y = "Hashtag feature"
      )
    print(p)
  })

  .hto_diag_df <- reactive({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))

    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    if (inherits(mat, "dgCMatrix")) {
      mat <- as.matrix(mat)
    } else {
      mat <- as.matrix(mat)
    }
    req(nrow(mat) >= 2, ncol(mat) > 0)

    md <- obj@meta.data
    cls <- .safe_class_values(md, colnames(mat), info, fallback = "unknown")
    id_col <- .safe_id_col(info, md)
    ids <- if (!is.na(id_col) && nzchar(id_col)) {
      as.character(md[colnames(mat), id_col] %||% "")
    } else {
      rep("", ncol(mat))
    }

    top1 <- numeric(ncol(mat))
    top2 <- numeric(ncol(mat))
    top1_feature <- character(ncol(mat))
    for (i in seq_len(ncol(mat))) {
      v <- mat[, i]
      ord <- order(v, decreasing = TRUE)
      top1[i] <- v[ord[1]]
      top2[i] <- v[ord[2]]
      top1_feature[i] <- rownames(mat)[ord[1]]
    }

    data.frame(
      cell = colnames(mat),
      class = cls,
      hash_id = ids,
      top1 = top1,
      top2 = top2,
      delta = top1 - top2,
      top_feature = top1_feature,
      stringsAsFactors = FALSE
    )
  })

  .class_kind <- function(x) {
    lx <- tolower(as.character(x %||% ""))
    if (grepl("neg", lx)) return("negative")
    if (grepl("doublet", lx) || grepl("_", as.character(x %||% ""), fixed = TRUE)) return("doublet")
    "singlet"
  }

  .ordered_classes <- function(cls_vec) {
    cls <- unique(as.character(cls_vec %||% "unknown"))
    kind <- vapply(cls, .class_kind, character(1))
    rank <- ifelse(kind == "singlet", 1L, ifelse(kind == "doublet", 2L, ifelse(kind == "negative", 3L, 4L)))
    key <- ifelse(kind == "doublet",
                  vapply(strsplit(cls, "_", fixed = TRUE), function(parts) paste(sort(parts), collapse = "_"), character(1)),
                  cls)
    cls[order(rank, tolower(key))]
  }

  .class_palette <- function(class_levels) {
    tag_pal <- .hashtag_palette(.hto_scatter_features())
    mix_cols <- function(cols) {
      cols <- cols[nzchar(cols)]
      if (!length(cols)) return(HTO_COLOR_KNOBS$neutral_other)
      rgb <- grDevices::col2rgb(cols)
      m <- round(rowMeans(rgb))
      grDevices::rgb(m[1], m[2], m[3], maxColorValue = 255)
    }
    out <- stats::setNames(rep(HTO_COLOR_KNOBS$neutral_other, length(class_levels)), class_levels)
    for (cl in class_levels) {
      kind <- .class_kind(cl)
      if (identical(kind, "negative")) {
        out[[cl]] <- HTO_COLOR_KNOBS$neutral_negative
      } else if (identical(kind, "singlet")) {
        key <- names(tag_pal)[tolower(names(tag_pal)) == tolower(cl)][1]
        out[[cl]] <- if (!is.na(key)) tag_pal[[key]] else HTO_COLOR_KNOBS$neutral_other
      } else {
        parts <- unlist(strsplit(cl, "_", fixed = TRUE))
        part_cols <- vapply(parts, function(p) {
          key <- names(tag_pal)[tolower(names(tag_pal)) == tolower(p)][1]
          if (is.na(key)) HTO_COLOR_KNOBS$neutral_other else tag_pal[[key]]
        }, character(1))
        out[[cl]] <- mix_cols(part_cols)
      }
    }
    out
  }

  .hashtag_palette <- function(tags, shade = c("deep", "light")) {
    shade <- match.arg(shade)
    tags <- unique(as.character(tags %||% character(0)))
    tags <- tags[nzchar(tags)]
    if (!length(tags)) return(stats::setNames(character(0), character(0)))
    tags <- tags[order(tolower(tags))]
    deep9 <- HTO_COLOR_KNOBS$hashtag_deep %||% character(0)
    light9 <- HTO_COLOR_KNOBS$hashtag_light %||% character(0)
    base <- if (identical(shade, "deep")) deep9 else light9
    if (length(tags) <= length(base)) {
      cols <- base[seq_along(tags)]
      return(stats::setNames(cols, tags))
    }
    extra_n <- length(tags) - length(base)
    extra <- grDevices::hcl.colors(extra_n + 2L, palette = if (identical(shade, "deep")) "Dark 3" else "Pastel 1")
    extra <- extra[seq_len(extra_n)]
    if (identical(shade, "light")) {
      extra <- vapply(extra, function(cl) {
        rgb <- grDevices::col2rgb(cl)
        m <- round(rgb + (255 - rgb) * 0.55)
        grDevices::rgb(m[1], m[2], m[3], maxColorValue = 255)
      }, character(1))
    }
    cols <- c(base, extra)
    stats::setNames(cols[seq_along(tags)], tags)
  }

  .color_for_hashtagish <- function(label, tag_pal) {
    lb <- as.character(label %||% "")
    if (!nzchar(lb)) return(HTO_COLOR_KNOBS$neutral_other)
    if (grepl("neg", tolower(lb))) return(HTO_COLOR_KNOBS$neutral_negative)
    key <- names(tag_pal)[tolower(names(tag_pal)) == tolower(lb)][1]
    if (!is.na(key)) return(tag_pal[[key]])
    if (grepl("_", lb, fixed = TRUE)) {
      parts <- unlist(strsplit(lb, "_", fixed = TRUE))
      cols <- vapply(parts, function(p) {
        k <- names(tag_pal)[tolower(names(tag_pal)) == tolower(p)][1]
        if (is.na(k)) HTO_COLOR_KNOBS$neutral_other else tag_pal[[k]]
      }, character(1))
      rgb <- grDevices::col2rgb(cols)
      m <- round(rowMeans(rgb))
      return(grDevices::rgb(m[1], m[2], m[3], maxColorValue = 255))
    }
    HTO_COLOR_KNOBS$neutral_other
  }

  .class_display_label <- function(x) {
    cls <- as.character(x %||% "unknown")
    kind <- .class_kind(cls)
    if (kind == "singlet") return(paste0("Singlet: ", cls))
    if (kind == "negative") return("Negative")
    parts <- unlist(strsplit(cls, "_", fixed = TRUE))
    if (length(parts) >= 2 && identical(parts[1], parts[2])) {
      return(paste0("Doublet (same): ", paste(parts[1], parts[2], sep = " + ")))
    }
    paste0("Doublet: ", gsub("_", " + ", cls, fixed = TRUE))
  }

  .keep_mask_from_inputs <- reactive({
    df <- .hto_diag_df()
    req(nrow(df) > 0)

    cls <- as.character(df$class %||% "")
    cls_low <- tolower(cls)
    is_negative <- grepl("neg", cls_low)
    is_doublet <- grepl("doublet", cls_low) | grepl("_", cls, fixed = TRUE)
    is_singlet <- !is_negative & !is_doublet

    mode <- input$hto_filter_mode %||% "singlet_only"
    keep_class <- switch(
      mode,
      singlet_only = is_singlet,
      all = rep(TRUE, length(cls)),
      remove_negative = !is_negative,
      remove_doublet = !is_doublet,
      is_singlet
    )

    keep_ids <- input$hto_keep_ids %||% character(0)
    if (length(keep_ids)) {
      keep_ids <- as.character(keep_ids)
      id_hit <- as.character(df$hash_id %||% "") %in% keep_ids
      cls_hit <- cls %in% keep_ids
      keep_class <- keep_class & (id_hit | cls_hit)
    }

    keep_signal <- rep(TRUE, nrow(df))
    if (isTRUE(input$hto_enable_signal_thresholds)) {
      min_delta <- as.numeric(input$hto_min_delta %||% 0)
      min_top1 <- as.numeric(input$hto_min_top1 %||% 0)
      max_top2 <- as.numeric(input$hto_max_top2 %||% Inf)
      keep_signal <- is.finite(df$delta) & is.finite(df$top1) & is.finite(df$top2) &
        df$delta >= min_delta &
        df$top1 >= min_top1 &
        df$top2 <= max_top2
    }

    if (isTRUE(input$hto_enable_per_feature_thresholds)) {
      thresholds <- .per_feature_min_thresholds()
      if (length(thresholds)) {
        per_feat_min <- as.numeric(thresholds[df$top_feature])
        per_feat_min[!is.finite(per_feat_min)] <- 0
        keep_signal <- keep_signal & is.finite(df$top1) & (df$top1 >= per_feat_min)
      }
    }

    keep_final <- keep_class & keep_signal
    status <- ifelse(keep_final, "Kept", ifelse(keep_class & !keep_signal, "Refined out", "Filtered out"))
    data.frame(
      keep_class = keep_class,
      keep_signal = keep_signal,
      keep_final = keep_final,
      status = status,
      stringsAsFactors = FALSE
    )
  })

  output$hto_tsne_id_plot <- renderPlotly({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    md <- obj@meta.data
    class_col <- .resolve_class_col(info, md)
    validate(need(!is.na(class_col), "No hashtag classification column found for selected object."))

    red_names <- names(obj@reductions)
    ridx <- which(tolower(red_names) %in% c("hto.tsne", "hto_tsne", "tsne"))
    validate(need(length(ridx) > 0, "No hashtag t-SNE found. Run hashtag demultiplexing first."))
    red <- red_names[ridx[1]]
    emb <- Seurat::Embeddings(obj, red)
    id_col <- .safe_id_col(info, md)
    ids <- if (!is.na(id_col) && nzchar(id_col)) as.character(md[rownames(emb), id_col]) else rep("NA", nrow(emb))
    cls <- .safe_class_values(md, rownames(emb), info, fallback = "unknown")

    keep_rows <- rep(TRUE, length(ids))
    if (isTRUE(input$hto_tsne_id_singlets_only)) {
      keep_rows <- !grepl("neg", tolower(cls)) & !grepl("doublet", tolower(cls)) & !grepl("_", cls, fixed = TRUE)
    }

    df <- data.frame(
      cell = rownames(emb)[keep_rows],
      TSNE_1 = emb[keep_rows, 1],
      TSNE_2 = emb[keep_rows, 2],
      hash_id = ids[keep_rows],
      class = cls[keep_rows],
      stringsAsFactors = FALSE
    )
    validate(need(nrow(df) > 0, "No cells left after current selection."))

    lv <- unique(df$hash_id)
    lv <- lv[order(tolower(lv))]
    tag_pal <- .hashtag_palette(.hto_scatter_features())
    pal <- stats::setNames(vapply(lv, function(v) .color_for_hashtagish(v, tag_pal), character(1)), lv)

    p <- plot_ly()
    for (idv in lv) {
      colv <- pal[[idv]]
      p <- p %>%
        add_trace(
          data = df[df$hash_id %in% idv, , drop = FALSE],
          x = ~TSNE_1, y = ~TSNE_2,
          type = "scattergl", mode = "markers",
          name = idv,
          marker = list(size = 4, color = colv, opacity = 0.82),
          text = ~paste0("Cell: ", cell, "<br>Hashtag ID: ", hash_id, "<br>Class: ", class),
          hoverinfo = "text",
          showlegend = FALSE
        ) %>%
        add_trace(
          x = 0, y = 0,
          type = "scatter", mode = "markers",
          name = idv,
          marker = list(size = .legend_dot_size(4), color = colv, opacity = 0.95),
          hoverinfo = "skip",
          visible = "legendonly",
          inherit = FALSE,
          showlegend = TRUE
        )
    }

    p %>%
      layout(
        title = list(
          text = if (isTRUE(input$hto_tsne_id_singlets_only)) "t-SNE by hashtag ID (singlets only, batch-check view)" else "t-SNE by hashtag ID (all cells)",
          x = 0.5, y = 0.985
        ),
        xaxis = list(title = HTO_UI_TEXT$t_text_t_sne_1, constrain = "domain", zeroline = FALSE, showline = TRUE, linecolor = "#64748b"),
        yaxis = list(title = HTO_UI_TEXT$t_text_t_sne_2, scaleanchor = "x", scaleratio = 1, zeroline = FALSE, showline = TRUE, linecolor = "#64748b"),
        legend = list(orientation = "h", x = 0.01, y = 1.02, xanchor = "left", yanchor = "bottom", font = list(size = 11)),
        margin = list(l = 60, r = 20, t = 92, b = 55)
      )
  })

  output$hto_feature_scatter_plot <- renderPlotly({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    xaxis_id <- input$hto_scatter_x
    yaxis_id <- input$hto_scatter_y
    validate(need(!is.null(xaxis_id) && !is.null(yaxis_id) && nzchar(xaxis_id) && nzchar(yaxis_id), "Pick both scatter axes."))
    validate(need(!identical(xaxis_id, yaxis_id), "Please choose two different axis features."))
    axis_choices <- .scatter_axis_choices()
    validate(need(xaxis_id %in% axis_choices && yaxis_id %in% axis_choices, "Selected axis feature is not available."))
    x_label <- names(axis_choices)[match(xaxis_id, axis_choices)]
    y_label <- names(axis_choices)[match(yaxis_id, axis_choices)]
    if (is.na(x_label) || !nzchar(x_label)) x_label <- sub("^(hto|meta)::", "", xaxis_id)
    if (is.na(y_label) || !nzchar(y_label)) y_label <- sub("^(hto|meta)::", "", yaxis_id)
    x_label <- sub("^HTO:\\s*", "", x_label)
    y_label <- sub("^HTO:\\s*", "", y_label)
    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    feats <- rownames(mat)
    md <- obj@meta.data
    cells <- colnames(mat)
    cls <- .safe_class_values(md, cells, info, fallback = "unknown")
    keep_df <- .keep_mask_from_inputs()
    diag_df <- .hto_diag_df()

    df <- data.frame(
      cell = cells,
      x = .scatter_axis_values(xaxis_id, mat = mat, md = md, cells = cells),
      y = .scatter_axis_values(yaxis_id, mat = mat, md = md, cells = cells),
      class = cls,
      class_kind = vapply(cls, .class_kind, character(1)),
      class_low = tolower(cls),
      top_feature = as.character(diag_df$top_feature[match(cells, diag_df$cell)] %||% ""),
      status = as.character(keep_df$status[match(cells, diag_df$cell)] %||% "Filtered out"),
      stringsAsFactors = FALSE
    )
    df <- df[is.finite(df$x) & is.finite(df$y), , drop = FALSE]
    validate(need(nrow(df) > 0, "No finite points available for selected axis features."))

    is_unknown <- !nzchar(df$class) | df$class_low %in% c("unknown", "na", "n/a", "unassigned")
    df$class[is_unknown] <- "Unknown/other"
    df$class_ui <- ifelse(is_unknown, "Unknown/other", df$class)
    visible_classes <- unique(c(
      as.character(input$hto_scatter_cls_singlets %||% character(0)),
      as.character(input$hto_scatter_cls_doublets %||% character(0)),
      as.character(input$hto_scatter_cls_other %||% character(0))
    ))
    if (!length(visible_classes)) {
      validate(need(FALSE, "Select at least one population class to display."))
    }
    df <- df[df$class_ui %in% visible_classes, , drop = FALSE]
    validate(need(nrow(df) > 0, "No cells left after current population class selection."))
    status_keep <- as.character(input$hto_scatter_status_show %||% c("Kept", "Refined out", "Filtered out"))
    status_keep <- unique(status_keep[nzchar(status_keep)])
    validate(need(length(status_keep) > 0, "Select at least one status: Kept, Refined out, or Filtered out."))
    df <- df[df$status %in% status_keep, , drop = FALSE]
    validate(need(nrow(df) > 0, "No cells left after current status filter."))

    selected_tags <- unique(c(
      if (startsWith(xaxis_id, "hto::")) sub("^hto::", "", xaxis_id) else "",
      if (startsWith(yaxis_id, "hto::")) sub("^hto::", "", yaxis_id) else ""
    ))
    selected_tags <- selected_tags[nzchar(selected_tags)]

    if (length(selected_tags)) {
      in_selected <- vapply(
        df$class,
        function(cl) any(vapply(selected_tags, function(tag) .class_contains_hashtag(cl, tag), logical(1))),
        logical(1)
      )
      in_selected <- in_selected | (df$top_feature %in% selected_tags)
    } else {
      in_selected <- rep(TRUE, nrow(df))
    }
    view_mode <- as.character(input$hto_scatter_view_mode %||% "selected_plus_bg")
    df_main <- switch(
      view_mode,
      selected_only = df[in_selected, , drop = FALSE],
      selected_plus_bg = df[in_selected, , drop = FALSE],
      all = df,
      df[in_selected, , drop = FALSE]
    )
    df_bg <- if (identical(view_mode, "selected_plus_bg")) df[!in_selected, , drop = FALSE] else df[0, , drop = FALSE]
    validate(need(nrow(df_main) > 0, "No cells match selected hashtags under current display mode."))
    linked_cells <- as.character(hto_scatter_linked_cells() %||% character(0))

    color_by <- as.character(input$hto_scatter_color_by %||% "class")
    point_size <- as.numeric(input$hto_scatter_point_size %||% 4)
    point_alpha <- as.numeric(input$hto_scatter_alpha %||% 0.78)
    if (!is.finite(point_size)) point_size <- 4
    if (!is.finite(point_alpha)) point_alpha <- 0.78
    point_size <- max(1, min(12, point_size))
    point_alpha <- max(0.1, min(1.0, point_alpha))
    draw_size <- max(4, point_size)
    if (startsWith(xaxis_id, "hto::")) draw_size <- max(3, point_size)

    if (startsWith(xaxis_id, "hto::")) draw_size <- max(3, point_size)

    build_scatter_panel <- function(color_mode = c("class", "top_feature", "status"), panel_title = "") {
      color_mode <- match.arg(color_mode)
      dd <- df_main
      if (identical(color_mode, "status")) {
        color_col <- "status"
        color_levels <- c("Kept", "Refined out", "Filtered out")
        pal <- HTO_COLOR_KNOBS$status
      } else if (identical(color_mode, "top_feature")) {
        color_col <- "top_feature"
        color_levels <- feats
        pal <- .hashtag_palette(color_levels)
      } else {
        color_col <- "class"
        color_levels <- .ordered_classes(dd$class)
        pal <- .class_palette(color_levels)
      }
      pp <- plot_ly(source = "hto_scatter_top")
      if (nrow(df_bg) > 0) {
        pp <- pp %>% add_trace(
          data = df_bg,
          x = ~x, y = ~y,
          type = "scattergl", mode = "markers",
          name = "Context background",
          marker = list(size = 3, color = HTO_COLOR_KNOBS$context_bg %||% "#cbd5e1", opacity = 0.28),
          key = ~cell,
          customdata = ~cell,
          text = ~paste0("Cell: ", cell, "<br>Class: ", class, "<br>", x_label, ": ", signif(x, 4), "<br>", y_label, ": ", signif(y, 4)),
          hoverinfo = "text",
          showlegend = FALSE
        )
      }
      for (lv in color_levels) {
        dsub <- dd[as.character(dd[[color_col]]) %in% lv, , drop = FALSE]
        if (!nrow(dsub)) next
        colv <- pal[[lv]] %||% HTO_COLOR_KNOBS$neutral_other
        pp <- pp %>% add_trace(
          data = dsub,
          x = ~x, y = ~y,
          type = "scattergl", mode = "markers",
          name = lv,
          marker = list(size = draw_size, opacity = point_alpha, color = colv),
          key = ~cell,
          customdata = ~cell,
          text = ~paste0(
            "Cell: ", cell,
            "<br>Class: ", class,
            "<br>Top hashtag: ", top_feature,
            "<br>Status: ", status,
            "<br>", x_label, ": ", signif(x, 4),
            "<br>", y_label, ": ", signif(y, 4)
          ),
          hoverinfo = "text",
          showlegend = FALSE
        ) %>%
          add_trace(
            x = 0, y = 0,
            type = "scatter", mode = "markers",
            name = lv,
            marker = list(size = .legend_dot_size(draw_size), color = colv, opacity = 0.95),
            hoverinfo = "skip",
            visible = "legendonly",
            inherit = FALSE,
            showlegend = TRUE
          )
      }
      if (length(linked_cells)) {
        dd_sel <- dd[dd$cell %in% linked_cells, , drop = FALSE]
        if (nrow(dd_sel) > 0) {
          pp <- pp %>% add_trace(
            data = dd_sel,
            x = ~x, y = ~y,
            type = "scattergl", mode = "markers",
            name = "Linked selection",
            marker = list(size = draw_size + 2, color = HTO_COLOR_KNOBS$linked_selection %||% "#111827", opacity = 0.95, symbol = "circle-open", line = list(color = HTO_COLOR_KNOBS$linked_selection %||% "#111827", width = 1.4)),
            key = ~cell,
            customdata = ~cell,
            text = ~paste0("Cell: ", cell, "<br>Class: ", class, "<br>Status: ", status),
            hoverinfo = "text",
            showlegend = FALSE,
            inherit = FALSE
          )
        }
      }
      shape_list <- list()
      xthr <- .axis_min_top1_threshold(xaxis_id)
      ythr <- .axis_min_top1_threshold(yaxis_id)
      if (is.finite(xthr)) {
        shape_list <- c(shape_list, list(list(
          type = "line",
          x0 = xthr, x1 = xthr,
          y0 = 0, y1 = 1, yref = "paper",
          line = list(color = "#ef4444", dash = "dash", width = 1.1)
        )))
      }
      if (is.finite(ythr)) {
        shape_list <- c(shape_list, list(list(
          type = "line",
          y0 = ythr, y1 = ythr,
          x0 = 0, x1 = 1, xref = "paper",
          line = list(color = "#ef4444", dash = "dash", width = 1.1)
        )))
      }

      pp %>% layout(
          title = list(text = panel_title, x = 0.5, xanchor = "center", font = list(size = 13)),
          xaxis = list(title = x_label),
          yaxis = list(title = y_label),
          plot_bgcolor = "#ffffff",
          paper_bgcolor = "#ffffff",
          margin = list(l = 55, r = 10, t = 64, b = 60),
          shapes = shape_list
        )
    }

    color_mode_main <- if (identical(color_by, "status")) "status" else if (identical(color_by, "top_feature")) "top_feature" else "class"
    left_title <- switch(color_mode_main,
      class = "Color by class",
      top_feature = "Color by top hashtag",
      status = "Color by status",
      "Color by class"
    )
    p_left <- build_scatter_panel(color_mode = color_mode_main, panel_title = left_title)
    p_right <- build_scatter_panel(color_mode = "status", panel_title = "Status view (kept vs filtered)")

    p_top <- subplot(
      p_left, p_right,
      nrows = 1,
      shareX = TRUE,
      shareY = TRUE,
      titleX = TRUE,
      titleY = TRUE,
      margin = 0.05
    ) %>%
      layout(
        title = list(text = paste0("Feature scatter: ", x_label, " vs ", y_label), x = 0.5, y = 0.985),
        plot_bgcolor = "#ffffff",
        paper_bgcolor = "#ffffff",
        legend = list(orientation = "h", x = 0.01, y = 1.08, xanchor = "left", yanchor = "bottom", font = list(size = 11), itemsizing = "constant"),
        margin = list(l = 40, r = 20, t = 110, b = 50)
      ) %>%
      event_register("plotly_selected") %>%
      event_register("plotly_deselect") %>%
      event_register("plotly_doubleclick") %>%
      config(displaylogo = FALSE)
    p_top
  })

  output$hto_feature_scatter_bottom_plot <- renderPlotly({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    xaxis_id <- input$hto_scatter_bottom_x
    yaxis_id <- input$hto_scatter_bottom_y
    validate(need(!is.null(xaxis_id) && !is.null(yaxis_id) && nzchar(xaxis_id) && nzchar(yaxis_id), "Pick both bottom scatter axes."))
    validate(need(!identical(xaxis_id, yaxis_id), "Please choose two different bottom axis features."))
    axis_choices <- .scatter_axis_choices()
    validate(need(xaxis_id %in% axis_choices && yaxis_id %in% axis_choices, "Selected bottom axis feature is not available."))
    x_label <- names(axis_choices)[match(xaxis_id, axis_choices)]
    y_label <- names(axis_choices)[match(yaxis_id, axis_choices)]
    if (is.na(x_label) || !nzchar(x_label)) x_label <- sub("^(hto|meta)::", "", xaxis_id)
    if (is.na(y_label) || !nzchar(y_label)) y_label <- sub("^(hto|meta)::", "", yaxis_id)

    mat <- core_hto_get_data(obj, assay = info$assay, slot = "data")
    req(!is.null(mat))
    md <- obj@meta.data
    cells <- colnames(mat)
    cls <- .safe_class_values(md, cells, info, fallback = "unknown")
    keep_df <- .keep_mask_from_inputs()
    diag_df <- .hto_diag_df()

    df <- data.frame(
      cell = cells,
      x = .scatter_axis_values(xaxis_id, mat = mat, md = md, cells = cells),
      y = .scatter_axis_values(yaxis_id, mat = mat, md = md, cells = cells),
      class = cls,
      class_low = tolower(cls),
      top_feature = as.character(diag_df$top_feature[match(cells, diag_df$cell)] %||% ""),
      status = as.character(keep_df$status[match(cells, diag_df$cell)] %||% "Filtered out"),
      stringsAsFactors = FALSE
    )
    df <- df[is.finite(df$x) & is.finite(df$y), , drop = FALSE]
    validate(need(nrow(df) > 0, "No finite points available for selected bottom axis features."))

    is_unknown <- !nzchar(df$class) | df$class_low %in% c("unknown", "na", "n/a", "unassigned")
    df$class[is_unknown] <- "Unknown/other"
    df$class_ui <- ifelse(is_unknown, "Unknown/other", df$class)
    visible_classes <- unique(c(
      as.character(input$hto_scatter_cls_singlets %||% character(0)),
      as.character(input$hto_scatter_cls_doublets %||% character(0)),
      as.character(input$hto_scatter_cls_other %||% character(0))
    ))
    if (!length(visible_classes)) validate(need(FALSE, "Select at least one population class to display."))
    df <- df[df$class_ui %in% visible_classes, , drop = FALSE]
    validate(need(nrow(df) > 0, "No cells left after current population class selection."))
    status_keep <- as.character(input$hto_scatter_status_show %||% c("Kept", "Refined out", "Filtered out"))
    status_keep <- unique(status_keep[nzchar(status_keep)])
    validate(need(length(status_keep) > 0, "Select at least one status: Kept, Refined out, or Filtered out."))
    df <- df[df$status %in% status_keep, , drop = FALSE]
    validate(need(nrow(df) > 0, "No cells left after current status filter."))

    selected_tags <- unique(c(
      if (startsWith(xaxis_id, "hto::")) sub("^hto::", "", xaxis_id) else "",
      if (startsWith(yaxis_id, "hto::")) sub("^hto::", "", yaxis_id) else ""
    ))
    selected_tags <- selected_tags[nzchar(selected_tags)]
    if (length(selected_tags)) {
      in_selected <- vapply(
        df$class,
        function(cl) any(vapply(selected_tags, function(tag) .class_contains_hashtag(cl, tag), logical(1))),
        logical(1)
      )
      in_selected <- in_selected | (df$top_feature %in% selected_tags)
    } else {
      in_selected <- rep(TRUE, nrow(df))
    }
    view_mode <- as.character(input$hto_scatter_view_mode %||% "selected_plus_bg")
    df_main <- switch(
      view_mode,
      selected_only = df[in_selected, , drop = FALSE],
      selected_plus_bg = df[in_selected, , drop = FALSE],
      all = df,
      df[in_selected, , drop = FALSE]
    )
    df_bg <- if (identical(view_mode, "selected_plus_bg")) df[!in_selected, , drop = FALSE] else df[0, , drop = FALSE]
    validate(need(nrow(df_main) > 0, "No cells match selected signals under current display mode (bottom plot)."))
    linked_cells <- as.character(hto_scatter_linked_cells() %||% character(0))

    point_size <- as.numeric(input$hto_scatter_point_size %||% 4)
    point_alpha <- as.numeric(input$hto_scatter_alpha %||% 0.78)
    if (!is.finite(point_size)) point_size <- 4
    if (!is.finite(point_alpha)) point_alpha <- 0.78
    point_size <- max(1, min(12, point_size))
    point_alpha <- max(0.1, min(1.0, point_alpha))
    draw_size <- max(4, point_size)

    color_by <- as.character(input$hto_scatter_bottom_color_by %||% "status")
    if (identical(color_by, "top_feature")) {
      color_col <- "top_feature"
      color_levels <- .hto_scatter_features()
      pal <- .hashtag_palette(color_levels)
      panel_title <- "Bottom RNA/mixed scatter (color by top hashtag)"
    } else if (identical(color_by, "class")) {
      color_col <- "class"
      color_levels <- .ordered_classes(df_main$class)
      pal <- .class_palette(color_levels)
      panel_title <- "Bottom RNA/mixed scatter (color by class)"
    } else {
      color_col <- "status"
      color_levels <- c("Kept", "Refined out", "Filtered out")
      pal <- HTO_COLOR_KNOBS$status
      panel_title <- "Bottom RNA/mixed scatter (color by status)"
    }
    p <- plot_ly(source = "hto_scatter_bottom")
    if (nrow(df_bg) > 0) {
      p <- p %>% add_trace(
        data = df_bg,
        x = ~x, y = ~y,
        type = "scattergl", mode = "markers",
        name = "Context background",
        marker = list(size = 3, color = HTO_COLOR_KNOBS$context_bg %||% "#cbd5e1", opacity = 0.28),
        key = ~cell,
        customdata = ~cell,
        text = ~paste0("Cell: ", cell, "<br>Class: ", class, "<br>", x_label, ": ", signif(x, 4), "<br>", y_label, ": ", signif(y, 4)),
        hoverinfo = "text",
        showlegend = FALSE
      )
    }
    for (lv in color_levels) {
      dsub <- df_main[as.character(df_main[[color_col]]) %in% lv, , drop = FALSE]
      if (!nrow(dsub)) next
      colv <- pal[[lv]] %||% HTO_COLOR_KNOBS$neutral_other
      p <- p %>% add_trace(
        data = dsub,
        x = ~x, y = ~y,
        type = "scattergl", mode = "markers",
        name = lv,
        marker = list(size = draw_size, opacity = point_alpha, color = colv),
        key = ~cell,
        customdata = ~cell,
        text = ~paste0(
          "Cell: ", cell,
          "<br>Class: ", class,
          "<br>Top hashtag: ", top_feature,
          "<br>Status: ", status,
          "<br>", x_label, ": ", signif(x, 4),
          "<br>", y_label, ": ", signif(y, 4)
        ),
        hoverinfo = "text",
        showlegend = FALSE
      ) %>%
        add_trace(
          x = 0, y = 0,
          type = "scatter", mode = "markers",
          name = lv,
          marker = list(size = .legend_dot_size(draw_size), color = colv, opacity = 0.95),
          hoverinfo = "skip",
          visible = "legendonly",
          inherit = FALSE,
          showlegend = TRUE
        )
    }
    if (length(linked_cells)) {
      df_sel <- df_main[df_main$cell %in% linked_cells, , drop = FALSE]
      if (nrow(df_sel) > 0) {
        p <- p %>% add_trace(
          data = df_sel,
          x = ~x, y = ~y,
          type = "scattergl", mode = "markers",
          name = "Linked selection",
          marker = list(size = draw_size + 2, color = HTO_COLOR_KNOBS$linked_selection %||% "#111827", opacity = 0.95, symbol = "circle-open", line = list(color = HTO_COLOR_KNOBS$linked_selection %||% "#111827", width = 1.4)),
          key = ~cell,
          customdata = ~cell,
          text = ~paste0("Cell: ", cell, "<br>Class: ", class, "<br>Status: ", status),
          hoverinfo = "text",
          showlegend = FALSE,
          inherit = FALSE
        )
      }
    }
    shape_list <- list()
    xthr <- .axis_min_top1_threshold(xaxis_id)
    ythr <- .axis_min_top1_threshold(yaxis_id)
    if (is.finite(xthr)) {
      shape_list <- c(shape_list, list(list(
        type = "line",
        x0 = xthr, x1 = xthr,
        y0 = 0, y1 = 1, yref = "paper",
        line = list(color = "#ef4444", dash = "dash", width = 1.1)
      )))
    }
    if (is.finite(ythr)) {
      shape_list <- c(shape_list, list(list(
        type = "line",
        y0 = ythr, y1 = ythr,
        x0 = 0, x1 = 1, xref = "paper",
        line = list(color = "#ef4444", dash = "dash", width = 1.1)
      )))
    }

    p <- p %>%
      layout(
        title = list(text = paste0(panel_title, ": ", x_label, " vs ", y_label), x = 0.5, y = 0.985),
        xaxis = list(title = x_label),
        yaxis = list(title = y_label),
        plot_bgcolor = "#ffffff",
        paper_bgcolor = "#ffffff",
        legend = list(orientation = "h", x = 0.01, y = 1.06, xanchor = "left", yanchor = "bottom", font = list(size = 11), itemsizing = "constant"),
        margin = list(l = 60, r = 20, t = 96, b = 56),
        shapes = shape_list
      ) %>%
      event_register("plotly_selected") %>%
      event_register("plotly_deselect") %>%
      event_register("plotly_doubleclick") %>%
      config(displaylogo = FALSE)
    p
  })

  observeEvent(suppressWarnings(event_data("plotly_selected", source = "hto_scatter_top")), {
    sel <- .selected_cells_from_event(suppressWarnings(event_data("plotly_selected", source = "hto_scatter_top")))
    if (length(sel)) hto_scatter_linked_cells(sel) else hto_scatter_linked_cells(character(0))
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  observeEvent(suppressWarnings(event_data("plotly_selected", source = "hto_scatter_bottom")), {
    sel <- .selected_cells_from_event(suppressWarnings(event_data("plotly_selected", source = "hto_scatter_bottom")))
    if (length(sel)) hto_scatter_linked_cells(sel) else hto_scatter_linked_cells(character(0))
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  observeEvent(suppressWarnings(event_data("plotly_deselect", source = "hto_scatter_top")), {
    hto_scatter_linked_cells(character(0))
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  observeEvent(suppressWarnings(event_data("plotly_deselect", source = "hto_scatter_bottom")), {
    hto_scatter_linked_cells(character(0))
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  observeEvent(suppressWarnings(event_data("plotly_doubleclick", source = "hto_scatter_top")), {
    hto_scatter_linked_cells(character(0))
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  observeEvent(suppressWarnings(event_data("plotly_doubleclick", source = "hto_scatter_bottom")), {
    hto_scatter_linked_cells(character(0))
  }, ignoreInit = TRUE, ignoreNULL = TRUE)

  observeEvent(input$hto_scatter_clear_sel, {
    hto_scatter_linked_cells(character(0))
  }, ignoreInit = TRUE)

  output$hto_rna_qc_scatter <- renderPlotly({
    info <- hto_info()
    req(!is.null(info))
    obj <- .get_obj(.get_entry(info$object_name))
    req(!is.null(obj))
    md <- obj@meta.data
    validate(need(all(c("nCount_RNA", "nFeature_RNA") %in% colnames(md)), "nCount_RNA and nFeature_RNA are required in metadata for this view."))
    keep_df <- .keep_mask_from_inputs()
    cells <- rownames(md)
    d <- data.frame(
      cell = cells,
      nCount_RNA = as.numeric(md$nCount_RNA),
      nFeature_RNA = as.numeric(md$nFeature_RNA),
      status = keep_df$status[match(cells, .hto_diag_df()$cell)],
      stringsAsFactors = FALSE
    )
    d$status[is.na(d$status)] <- "Filtered out"
    d <- d[is.finite(d$nCount_RNA) & is.finite(d$nFeature_RNA), , drop = FALSE]
    validate(need(nrow(d) > 0, "No finite RNA QC points available."))

    st_pal <- HTO_COLOR_KNOBS$status
    p <- plot_ly()
    spec <- list(
      list(lbl = "Filtered out", col = st_pal[["Filtered out"]] %||% "#9ca3af"),
      list(lbl = "Kept", col = st_pal[["Kept"]] %||% "#16a34a")
    )
    for (sp in spec) {
      dd <- d[d$status == sp$lbl, , drop = FALSE]
      if (!nrow(dd)) next
      p <- p %>% add_trace(
        data = dd, x = ~nCount_RNA, y = ~nFeature_RNA, type = "scattergl", mode = "markers",
        name = sp$lbl, marker = list(size = 4, color = sp$col, opacity = if (identical(sp$lbl, "Kept")) 0.8 else 0.55),
        text = ~paste0("Cell: ", cell, "<br>nCount_RNA: ", format(nCount_RNA, big.mark = ","), "<br>nFeature_RNA: ", format(nFeature_RNA, big.mark = ",")),
        hoverinfo = "text", showlegend = FALSE
      ) %>%
        add_trace(
          x = 0, y = 0, type = "scatter", mode = "markers",
          name = sp$lbl, marker = list(size = .legend_dot_size(4), color = sp$col, opacity = 0.95),
          hoverinfo = "skip", visible = "legendonly", inherit = FALSE, showlegend = TRUE
        )
    }
    p %>% layout(
        title = HTO_UI_TEXT$t_text_rna_qc_scatter_ncount_rna_vs,
        xaxis = list(title = HTO_UI_TEXT$t_text_ncount_rna),
        yaxis = list(title = HTO_UI_TEXT$t_text_nfeature_rna),
        legend = list(orientation = "h", x = 0, y = 1.12)
      )
  })

  output$hto_class_comp_plot <- renderPlotly({
    df <- .hto_diag_df()
    req(nrow(df) > 0)
    cls <- as.character(df$class %||% "unknown")
    class_levels <- .ordered_classes(cls)
    agg <- as.data.frame(table(class = factor(cls, levels = class_levels)), stringsAsFactors = FALSE)
    names(agg) <- c("class", "cells")
    agg$class <- as.character(agg$class)
    agg <- agg[agg$cells > 0, , drop = FALSE]
    agg$class_display <- vapply(agg$class, .class_display_label, character(1))
    pal <- .class_palette(agg$class)
    bar_cols <- unname(pal[agg$class])

    plot_ly(
      agg,
      x = ~class_display,
      y = ~cells,
      type = "bar",
      marker = list(color = bar_cols),
      text = ~cells,
      textposition = "outside",
      hovertemplate = paste0("Class: %{x}<br>Cells: %{y}<extra></extra>")
    ) %>%
      layout(
        title = list(text = HTO_UI_TEXT$t_text_class_composition, y = 0.97),
        xaxis = list(title = HTO_UI_TEXT$t_text_demultiplex_class, tickangle = -30, automargin = TRUE, categoryorder = "array", categoryarray = agg$class_display),
        yaxis = list(title = HTO_UI_TEXT$t_text_cells),
        showlegend = FALSE,
        margin = list(t = 70, b = 140, l = 70, r = 20)
      )
  })

  output$hto_delta_dist_plot <- renderPlotly({
    df <- .hto_diag_df()
    req(nrow(df) > 0)
    keep_df <- .keep_mask_from_inputs()
    cls <- as.character(df$class %||% "")
    ddf <- data.frame(
      class = cls,
      hash_id = as.character(df$hash_id %||% ""),
      class_kind = vapply(cls, .class_kind, character(1)),
      delta = as.numeric(df$delta),
      kept = as.logical(keep_df$keep_final),
      stringsAsFactors = FALSE
    )
    ddf <- ddf[is.finite(ddf$delta), , drop = FALSE]
    req(nrow(ddf) > 0)

    tags <- .hto_scatter_features()
    tags <- as.character(tags %||% character(0))
    tags <- tags[nzchar(tags)]
    req(length(tags) > 0)

    min_delta <- as.numeric(input$hto_min_delta %||% 0)
    show_thresholds <- isTRUE(input$hto_enable_signal_thresholds)

    .bins <- 140
    .singlet_kept_col <- HTO_COLOR_KNOBS$status[["Kept"]] %||% "#16a34a"
    .singlet_raw_col <- {
      rgb <- grDevices::col2rgb(.singlet_kept_col)
      out <- round(rgb + (255 - rgb) * 0.55)
      grDevices::rgb(out[1], out[2], out[3], maxColorValue = 255)
    }
    tag_row_cols <- .hashtag_palette(tags, shade = "deep")
    .lighten_hex <- function(col, frac = 0.22) {
      rgb <- grDevices::col2rgb(col)
      out <- round(rgb + (255 - rgb) * frac)
      grDevices::rgb(out[1], out[2], out[3], maxColorValue = 255)
    }
    .max_hist_count <- function(v, bins) {
      v <- as.numeric(v)
      v <- v[is.finite(v)]
      if (!length(v)) return(0)
      suppressWarnings(max(hist(v, plot = FALSE, breaks = bins)$counts, na.rm = TRUE))
    }

    subplots <- lapply(seq_along(tags), function(i) {
      tag <- tags[[i]]
      singlet_hit <- ddf$class_kind == "singlet" & (ddf$class == tag | ddf$hash_id == tag)
      related_doublet_hit <- ddf$class_kind == "doublet" &
        vapply(ddf$class, function(cl) .class_contains_hashtag(cl, tag), logical(1))

      sdf <- ddf[singlet_hit, , drop = FALSE]
      ddf_rel <- ddf[related_doublet_hit, , drop = FALSE]
      skf <- sdf[sdf$kept %in% TRUE, , drop = FALSE]
      rel_dbl_levels <- .ordered_classes(unique(ddf_rel$class))
      rel_label <- "none"
      if (length(rel_dbl_levels)) rel_label <- paste(gsub("_", " + ", rel_dbl_levels, fixed = TRUE), collapse = ", ")
      row_col <- tag_row_cols[[tag]] %||% "#9ca3af"

      p <- plot_ly()
      if (nrow(sdf) > 0) {
        p <- p %>% add_histogram(
          data = sdf,
          x = ~delta,
          nbinsx = .bins,
          name = paste0("[", tag, "] Singlet raw"),
          marker = list(color = .singlet_raw_col),
          opacity = 0.20,
          legendgroup = paste0("row_", tag),
          showlegend = FALSE,
          hovertemplate = paste0(
            "Hashtag: ", tag,
            "<br>Group: Singlet (raw)",
            "<br>Delta: %{x:.3f}",
            "<br>Cells: %{y}<extra></extra>"
          )
        )
      }
      if (nrow(ddf_rel) > 0) {
        row_col_kept <- .lighten_hex(row_col, frac = 0.10)
        p <- p %>% add_histogram(
          data = ddf_rel,
          x = ~delta,
          nbinsx = .bins,
          name = paste0("Related doublets (", tag, "): ", rel_label),
          marker = list(color = row_col),
          opacity = 0.24,
          legendgroup = paste0("row_", tag),
          showlegend = FALSE,
          hovertemplate = paste0(
            "Hashtag row: ", tag,
            "<br>Group: Related doublets (raw)",
            "<br>Delta: %{x:.3f}",
            "<br>Cells: %{y}<extra></extra>"
          )
        )
        d_kept_row <- ddf_rel[ddf_rel$kept %in% TRUE, , drop = FALSE]
        if (nrow(d_kept_row) > 0) {
          p <- p %>% add_histogram(
            data = d_kept_row,
            x = ~delta,
            nbinsx = .bins,
            name = paste0("Related doublets kept (", tag, ")"),
            marker = list(color = row_col_kept),
            opacity = 0.40,
            legendgroup = paste0("doublet_row_kept_", tag),
            showlegend = FALSE,
            hovertemplate = paste0(
              "Hashtag row: ", tag,
              "<br>Group: Related doublets (kept)",
              "<br>Delta: %{x:.3f}",
              "<br>Cells: %{y}<extra></extra>"
            )
          )
        }
      }
      if (nrow(skf) > 0) {
        p <- p %>% add_histogram(
          data = skf,
          x = ~delta,
          nbinsx = .bins,
          name = paste0("[", tag, "] Singlet kept"),
          marker = list(color = .singlet_kept_col),
          opacity = 0.38,
          legendgroup = paste0("row_", tag),
          showlegend = FALSE,
          hovertemplate = paste0(
            "Hashtag: ", tag,
            "<br>Group: Singlet (kept)",
            "<br>Delta: %{x:.3f}",
            "<br>Cells: %{y}<extra></extra>"
          )
        )
      }

      ymax <- max(
        .max_hist_count(sdf$delta, .bins),
        .max_hist_count(ddf_rel$delta, .bins),
        .max_hist_count(skf$delta, .bins),
        .max_hist_count(ddf_rel$delta[ddf_rel$kept %in% TRUE], .bins),
        na.rm = TRUE
      )
      if (!is.finite(ymax) || ymax <= 0) ymax <- 1
      if (show_thresholds) {
        p <- p %>% add_segments(
          x = min_delta, xend = min_delta,
          y = 0, yend = ymax,
          inherit = FALSE,
          name = if (i == 1) "Min delta threshold" else NULL,
          showlegend = FALSE,
          line = list(color = "#ef4444", dash = "dash", width = 1.1),
          hoverinfo = "skip"
        )
      }
      p %>% layout(
        barmode = "overlay",
        yaxis = list(title = if (i == 1) "Cells" else NULL, showticklabels = TRUE, automargin = TRUE, tickfont = list(size = 10, color = "#475569")),
        xaxis = list(title = NULL, automargin = TRUE),
        margin = list(l = 8, r = 15, t = 5, b = 2)
      )
    })

    n_panels <- length(tags)
    ann_left <- lapply(seq_len(n_panels), function(i) {
      list(
        x = -0.01,
        y = (n_panels - i + 0.5) / n_panels,
        xref = "paper",
        yref = "paper",
        text = paste0("Hashtag: ", tags[[i]]),
        showarrow = FALSE,
        xanchor = "right",
        yanchor = "middle",
        align = "right",
        font = list(size = 11, color = "#374151")
      )
    })
    ann_right <- lapply(seq_len(n_panels), function(i) {
      tag <- tags[[i]]
      rel_dbl_levels <- .ordered_classes(unique(ddf$class[
        ddf$class_kind == "doublet" &
          vapply(ddf$class, function(cl) .class_contains_hashtag(cl, tag), logical(1))
      ]))
      rel_label <- if (length(rel_dbl_levels)) {
        paste(gsub("_", " + ", rel_dbl_levels, fixed = TRUE), collapse = ", ")
      } else {
        "none"
      }
      row_col <- tag_row_cols[[tag]] %||% "#9ca3af"
      list(
        x = 0.985,
        y = (n_panels - i + 0.5) / n_panels,
        xref = "paper",
        yref = "paper",
        text = paste0(
          "<span style='color:", .singlet_raw_col, "'>&#9632;</span> Singlet raw",
          "<br><span style='color:", .singlet_kept_col, "'>&#9632;</span> Singlet kept",
          "<br><span style='color:", row_col, "'>&#9632;</span> Related dblts: ", rel_label
        ),
        showarrow = FALSE,
        xanchor = "right",
        yanchor = "middle",
        align = "right",
        font = list(size = 9, color = "#334155")
      )
    })
    ann <- c(ann_left, ann_right)
    pp <- subplot(subplots, nrows = length(subplots), shareX = TRUE, titleY = TRUE, margin = 0.01) %>%
      layout(
        title = list(text = HTO_UI_TEXT$t_text_delta_distribution_hashtag_singlets_related_doublets, x = 0.5),
        xaxis = list(title = HTO_UI_TEXT$t_text_delta_top1_top2_signal, automargin = TRUE),
        plot_bgcolor = "#ffffff",
        paper_bgcolor = "#ffffff",
        showlegend = FALSE,
        margin = list(l = 130, r = 40, t = 70, b = 55),
        annotations = ann
      ) %>%
      config(displaylogo = FALSE)
    pp
  })

  output$hto_borderline_scatter_plot <- renderPlotly({
    df <- .hto_diag_df()
    req(nrow(df) > 0)
    keep_df <- .keep_mask_from_inputs()
    d <- data.frame(
      cell = as.character(df$cell),
      class = as.character(df$class),
      top_feature = as.character(df$top_feature),
      top1 = as.numeric(df$top1),
      top2 = as.numeric(df$top2),
      delta = as.numeric(df$delta),
      status = as.character(keep_df$status),
      stringsAsFactors = FALSE
    )
    d <- d[is.finite(d$top1) & is.finite(d$top2) & is.finite(d$delta), , drop = FALSE]
    req(nrow(d) > 0)

    min_delta <- suppressWarnings(as.numeric(input$hto_min_delta %||% 0))
    min_top1 <- suppressWarnings(as.numeric(input$hto_min_top1 %||% 0))
    max_top2 <- suppressWarnings(as.numeric(input$hto_max_top2 %||% Inf))
    if (!is.finite(min_delta)) min_delta <- 0
    if (!is.finite(min_top1)) min_top1 <- 0
    if (!is.finite(max_top2)) max_top2 <- Inf

    per_thr <- rep(min_top1, nrow(d))
    if (isTRUE(input$hto_enable_per_feature_thresholds)) {
      per_map <- .per_feature_min_thresholds()
      pv <- suppressWarnings(as.numeric(per_map[d$top_feature]))
      pv[!is.finite(pv)] <- min_top1
      per_thr <- pmax(per_thr, pv)
    }

    eps_delta <- max(0.05, 0.05 * diff(range(d$delta, na.rm = TRUE)))
    eps_top1 <- max(0.05, 0.05 * diff(range(d$top1, na.rm = TRUE)))
    eps_top2 <- max(0.05, 0.05 * diff(range(d$top2, na.rm = TRUE)))
    near_delta <- abs(d$delta - min_delta) <= eps_delta
    near_top1 <- abs(d$top1 - per_thr) <= eps_top1
    near_top2 <- if (is.finite(max_top2)) abs(d$top2 - max_top2) <= eps_top2 else rep(FALSE, nrow(d))
    d$borderline <- near_delta | near_top1 | near_top2

    pal <- HTO_COLOR_KNOBS$status
    d$status[!d$status %in% names(pal)] <- "Filtered out"
    d$status <- factor(d$status, levels = c("Kept", "Refined out", "Filtered out"))

    p <- plot_ly()
    p <- p %>% add_trace(
      data = d,
      x = ~top2, y = ~top1,
      type = "scattergl", mode = "markers",
      color = ~status, colors = unname(pal),
      marker = list(size = 4, opacity = 0.65),
      text = ~paste0(
        "Cell: ", cell,
        "<br>Class: ", class,
        "<br>Top feature: ", top_feature,
        "<br>top1: ", signif(top1, 4),
        "<br>top2: ", signif(top2, 4),
        "<br>delta: ", signif(delta, 4),
        "<br>Status: ", status
      ),
      hoverinfo = "text"
    )
    bd <- d[d$borderline %in% TRUE, , drop = FALSE]
    if (nrow(bd) > 0) {
      p <- p %>% add_trace(
        data = bd,
        x = ~top2, y = ~top1,
        type = "scattergl", mode = "markers",
        name = "Borderline",
        marker = list(size = 7, color = "#ef4444", opacity = 0.85, symbol = "circle-open", line = list(color = "#ef4444", width = 1.2)),
        text = ~paste0("Cell: ", cell, "<br>Borderline near threshold"),
        hoverinfo = "text",
        inherit = FALSE
      )
    }

    xmax <- suppressWarnings(max(d$top2, na.rm = TRUE))
    ymax <- suppressWarnings(max(d$top1, na.rm = TRUE))
    if (!is.finite(xmax) || xmax <= 0) xmax <- 1
    if (!is.finite(ymax) || ymax <= 0) ymax <- 1
    xline <- c(0, xmax)
    ydiag <- xline + min_delta

    shapes <- list(
      list(type = "line", x0 = 0, x1 = xmax, y0 = min_top1, y1 = min_top1, line = list(color = "#ef4444", dash = "dash", width = 1.1)),
      list(type = "line", x0 = 0, x1 = xmax, y0 = ydiag[1], y1 = ydiag[2], line = list(color = "#7c3aed", dash = "dash", width = 1.1))
    )
    if (is.finite(max_top2)) {
      shapes <- c(shapes, list(list(type = "line", x0 = max_top2, x1 = max_top2, y0 = 0, y1 = ymax, line = list(color = "#ea580c", dash = "dash", width = 1.1))))
    }

    p %>% layout(
      title = list(text = "Borderline map: top2 vs top1", x = 0.5),
      xaxis = list(title = "top2 (second-highest hashtag signal)"),
      yaxis = list(title = "top1 (highest hashtag signal)"),
      legend = list(orientation = "h", x = 0.01, y = 1.08, xanchor = "left", yanchor = "bottom"),
      plot_bgcolor = "#ffffff",
      paper_bgcolor = "#ffffff",
      margin = list(l = 60, r = 20, t = 90, b = 60),
      shapes = shapes,
      annotations = list(
        list(x = 0.99, y = 1.06, xref = "paper", yref = "paper", showarrow = FALSE, xanchor = "right",
             text = "Red: min top1 | Purple: delta boundary | Orange: max top2")
      )
    ) %>% config(displaylogo = FALSE)
  })

  output$hto_borderline_margin_plot <- renderPlotly({
    df <- .hto_diag_df()
    req(nrow(df) > 0)
    keep_df <- .keep_mask_from_inputs()
    d <- data.frame(
      top_feature = as.character(df$top_feature),
      top1 = as.numeric(df$top1),
      top2 = as.numeric(df$top2),
      delta = as.numeric(df$delta),
      status = as.character(keep_df$status),
      stringsAsFactors = FALSE
    )
    d <- d[is.finite(d$top1) & is.finite(d$top2) & is.finite(d$delta), , drop = FALSE]
    req(nrow(d) > 0)

    min_delta <- suppressWarnings(as.numeric(input$hto_min_delta %||% 0))
    min_top1 <- suppressWarnings(as.numeric(input$hto_min_top1 %||% 0))
    max_top2 <- suppressWarnings(as.numeric(input$hto_max_top2 %||% Inf))
    if (!is.finite(min_delta)) min_delta <- 0
    if (!is.finite(min_top1)) min_top1 <- 0
    if (!is.finite(max_top2)) max_top2 <- Inf

    per_thr <- rep(min_top1, nrow(d))
    if (isTRUE(input$hto_enable_per_feature_thresholds)) {
      per_map <- .per_feature_min_thresholds()
      pv <- suppressWarnings(as.numeric(per_map[d$top_feature]))
      pv[!is.finite(pv)] <- min_top1
      per_thr <- pmax(per_thr, pv)
    }

    m1 <- d$delta - min_delta
    m2 <- d$top1 - per_thr
    m3 <- if (is.finite(max_top2)) (max_top2 - d$top2) else rep(Inf, nrow(d))
    d$decision_margin <- pmin(m1, m2, m3, na.rm = TRUE)

    pal <- HTO_COLOR_KNOBS$status
    d$status[!d$status %in% names(pal)] <- "Filtered out"
    d$kept_flag <- d$status == "Kept"
    d$decision_margin <- as.numeric(d$decision_margin)
    d <- d[is.finite(d$decision_margin), , drop = FALSE]
    req(nrow(d) > 0)

    x_min <- suppressWarnings(min(d$decision_margin, na.rm = TRUE))
    x_max <- suppressWarnings(max(d$decision_margin, na.rm = TRUE))
    if (!is.finite(x_min) || !is.finite(x_max) || x_max <= x_min) {
      x_min <- -1
      x_max <- 1
    }
    if (x_min > 0) x_min <- 0
    if (x_max < 0) x_max <- 0
    nb <- 60L
    breaks <- seq(x_min, x_max, length.out = nb + 1L)
    mids <- (head(breaks, -1) + tail(breaks, -1)) / 2
    bin <- findInterval(d$decision_margin, vec = breaks, all.inside = TRUE)
    cnt_total <- tabulate(bin, nbins = nb)
    cnt_kept <- tabulate(bin[d$kept_flag %in% TRUE], nbins = nb)
    cnt_nonkept <- pmax(0L, cnt_total - cnt_kept)
    pass_rate <- ifelse(cnt_total > 0, cnt_kept / cnt_total, NA_real_)

    df_bin <- data.frame(
      mid = mids,
      kept = cnt_kept,
      nonkept = cnt_nonkept,
      total = cnt_total,
      pass_rate = pass_rate,
      stringsAsFactors = FALSE
    )

    p_top <- plot_ly() %>%
      add_bars(
        data = df_bin,
        x = ~mid, y = ~nonkept,
        name = "Filtered/refined out",
        marker = list(color = "#9ca3af"),
        opacity = 0.8,
        hovertemplate = "Margin bin center: %{x:.3f}<br>Filtered/refined out: %{y}<extra></extra>"
      ) %>%
      add_bars(
        data = df_bin,
        x = ~mid, y = ~kept,
        name = "Kept",
        marker = list(color = "#16a34a"),
        opacity = 0.8,
        hovertemplate = "Margin bin center: %{x:.3f}<br>Kept: %{y}<extra></extra>"
      ) %>%
      layout(
        barmode = "stack",
        xaxis = list(title = NULL, zeroline = FALSE),
        yaxis = list(title = "Cells"),
        showlegend = TRUE,
        plot_bgcolor = "#ffffff",
        paper_bgcolor = "#ffffff",
        margin = list(l = 60, r = 20, t = 35, b = 20),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 0, y0 = 0, y1 = 1, yref = "paper", line = list(color = "#ef4444", dash = "dash", width = 1.2))
        )
      )

    p_bottom <- plot_ly() %>%
      add_lines(
        data = df_bin[df_bin$total > 0, , drop = FALSE],
        x = ~mid, y = ~pass_rate,
        name = "Pass rate",
        line = list(color = "#2563eb", width = 2),
        hovertemplate = "Margin bin center: %{x:.3f}<br>Pass rate: %{y:.2%}<extra></extra>",
        showlegend = FALSE
      ) %>%
      add_markers(
        data = df_bin[df_bin$total > 0, , drop = FALSE],
        x = ~mid, y = ~pass_rate,
        marker = list(color = "#2563eb", size = 5, opacity = 0.9),
        hoverinfo = "skip",
        showlegend = FALSE
      ) %>%
      layout(
        xaxis = list(title = "Decision margin = min(delta-min_delta, top1-min_top1, max_top2-top2)", zeroline = FALSE),
        yaxis = list(title = "Pass rate", range = c(0, 1)),
        plot_bgcolor = "#ffffff",
        paper_bgcolor = "#ffffff",
        margin = list(l = 60, r = 20, t = 18, b = 60),
        shapes = list(
          list(type = "line", x0 = 0, x1 = 0, y0 = 0, y1 = 1, yref = "paper", line = list(color = "#ef4444", dash = "dash", width = 1.2))
        ),
        annotations = list(
          list(x = 0.99, y = 1.05, xref = "paper", yref = "paper", showarrow = FALSE, xanchor = "right",
               text = "x < 0 fails; x near 0 is borderline")
        )
      )

    subplot(p_top, p_bottom, nrows = 2, shareX = TRUE, titleX = TRUE, margin = 0.04) %>%
      layout(
        title = list(text = "Decision-margin diagnostics (distribution + pass rate)", x = 0.5),
        yaxis = list(title = "Cells", automargin = TRUE),
        yaxis2 = list(title = "Pass rate", range = c(0, 1), tickformat = ".0%", automargin = TRUE),
        legend = list(orientation = "h", x = 0.01, y = 1.06, xanchor = "left", yanchor = "bottom"),
        plot_bgcolor = "#ffffff",
        paper_bgcolor = "#ffffff",
        margin = list(l = 40, r = 10, t = 90, b = 40)
      ) %>%
      config(displaylogo = FALSE)
  })

  observeEvent(input$hto_apply_btn, {
    info <- hto_info()
    req(!is.null(info))
    nm <- info$object_name
    obj <- .get_obj(.get_entry(nm))
    req(!is.null(obj))

    overlay_show("Applying HTO filter and creating workspace object…")
    on.exit(overlay_hide(), add = TRUE)

    diag <- tryCatch(.hto_diag_df(), error = function(e) NULL)
    if (is.null(diag) || !nrow(diag)) {
      hto_status(list(type = "error", msg = "Cannot compute filter mask from HTO diagnostics. Run demultiplexing first."))
      return()
    }
    keep_df <- tryCatch(.keep_mask_from_inputs(), error = function(e) NULL)
    if (is.null(keep_df) || !nrow(keep_df)) {
      hto_status(list(type = "error", msg = "Failed to compute keep/remove mask from current settings."))
      return()
    }
    keep_cells <- diag$cell[which(keep_df$keep_final)]
    if (!length(keep_cells)) {
      hto_status(list(type = "error", msg = "Current class/signal/per-hashtag thresholds removed all cells. Relax thresholds and retry."))
      return()
    }
    out <- list(
      object = .reset_subset_analysis_state(subset(obj, cells = keep_cells)),
      n_keep = length(keep_cells),
      n_total = nrow(obj@meta.data)
    )

    base <- paste0(nm, "_hto_filtered")
    new_nm <- base
    i <- 1L
    while (!is.null((shared_data$all_seurat_objects %||% list())[[new_nm]])) {
      new_nm <- paste0(base, "_", i)
      i <- i + 1L
    }

    shared_data$all_seurat_objects[[new_nm]] <- list(
      obj = out$object,
      prefs = list(),
      plots = list(),
      analysis_cache = list(),
      meta = list(
        stage = "filtered",
        parent = nm,
        method = "hto_filter",
        class_col = info$class_col,
        id_col = info$id_col,
        filter_mode = input$hto_filter_mode %||% "singlet_only",
        keep_ids = input$hto_keep_ids %||% character(0),
        use_signal_thresholds = isTRUE(input$hto_enable_signal_thresholds),
        min_delta = as.numeric(input$hto_min_delta %||% 0),
        min_top1 = as.numeric(input$hto_min_top1 %||% 0),
        max_top2 = as.numeric(input$hto_max_top2 %||% Inf),
        use_per_feature_thresholds = isTRUE(input$hto_enable_per_feature_thresholds),
        per_feature_min_top1 = as.list(.per_feature_min_thresholds()),
        created = Sys.time()
      )
    )
    shared_data$active_object_name <- new_nm
    hto_status(list(type = "info", msg = sprintf("Created %s (%d/%d cells kept).", new_nm, out$n_keep, out$n_total)))
  })
}
