
ANALYSIS_UI_TEXT <- list(
  t_btn_download = "Download",
  t_btn_download_pdf = "Download PDF",
  t_btn_download_freq_pdf = "Download Frequency PDF",
  t_btn_open_pdf_settings = "PDF export settings",
  t_btn_next_umap_configuration = "Next: UMAP configuration ->",
  t_btn_import_csv_from_loupe = "Import csv from loupe",
  t_btn_refresh_pseudobulk_view = "Load pseudobulk overview",
  t_btn_run_custom_comparison = "Run custom comparison",
  t_btn_run_heatmap_resolution = "Run heatmap (by resolution)",
  t_btn_run_integration = "Run Integration",
  t_btn_run_normalization = "Run Normalization",
  t_btn_run_resolution_sweep = "Run resolution sweep",
  t_btn_generate_elbow_plot = "Generate elbow plot",
  t_btn_unlock_elbow_preview = "Click to re-enable embedding updates",
  t_btn_save_parameters_continue = "Save parameters & continue",
  t_label_cluster_set = "Cluster set A:",
  t_label_cluster_set_b = "Cluster set B:",
  t_label_color = "Color by:",
  t_label_comparison_mode = "Comparison mode:",
  t_label_de_method = "DE method:",
  t_label_facet_sample_if_available = "Facet by sample (if available)",
  t_label_genes_used_top_variable = "Genes used (top variable)",
  t_label_graph = "Graph:",
  t_label_group = "Group A:",
  t_label_group_b = "Group B:",
  t_label_grouping_column = "Grouping column:",
  t_label_integrate = "Integrate by:",
  t_label_logfc_threshold = "logfc.threshold",
  t_label_max_resolution = "Max resolution",
  t_label_min_pct = "min.pct",
  t_label_min_resolution = "Min resolution",
  t_label_normalization_method = "Normalization Method:",
  t_label_inte_cca_title = "Seurat CCA",
  t_label_inte_cca_note = "stronger correction, higher over-integration risk",
  t_label_inte_rpca_title = "Seurat RPCA",
  t_label_inte_rpca_note = "conservative default for large similar datasets",
  t_label_inte_sct_title = "Seurat SCT",
  t_label_inte_sct_note = "use when samples were SCT-normalized",
  t_label_inte_harmony_title = "Harmony",
  t_label_inte_harmony_note = "fast embedding correction for many batches",
  t_label_inte_merge_title = "No Integration",
  t_label_inte_merge_note = "merge only",
  t_hover_inte_cca = "Best for datasets expected to share the same cell types but with substantial batch-driven expression shifts; use cautiously because CCA can aggressively align datasets and may obscure real condition-, genotype-, or disease-specific biology.",
  t_hover_inte_rpca = "Recommended for large datasets with broadly overlapping cell types, because RPCA is faster and less aggressive than CCA; it reduces batch effects while better preserving real biological differences, though it may under-correct strongly divergent batches.",
  t_hover_inte_sct = "Best when each dataset was processed with SCTransform, especially for UMI-based data; it improves normalization of sequencing-depth effects but still requires integration checks because regression choices can remove biology if technical covariates are confounded with condition.",
  t_hover_inte_harmony = "Useful for rapid correction across many samples or donors in PCA space, especially for exploratory clustering and visualization; interpret cautiously when batch overlaps with biological condition, because Harmony may remove true group differences along with technical effects.",
  t_label_number_pcs_dims_use = "Number of PCs (dims) to use:",
  t_label_pick_final_resolution = "Pick final resolution:",
  t_label_plot_format = "Plot format:",
  t_label_pb_custom_label_genes = "Label top differential genes",
  t_label_pb_custom_top_n_genes = "Top N genes to label",
  t_label_pb_custom_prelog_threshold = "FDR threshold (pre-log10)",
  t_label_pseudobulk_replicate_column = "Pseudobulk replicate column:",
  t_label_de_cluster_metadata_column = "Cluster metadata column:",
  t_label_random_seed = "Random Seed:",
  t_label_reduction = "Reduction:",
  t_label_resolution = "Resolution:",
  t_label_resolution_display = "Resolution to display:",
  t_label_split = "Split by:",
  t_label_split_secondary = "Secondary split by:",
  t_label_freq_group_by = "Frequency group by:",
  t_label_dot_size = "Dot size:",
  t_label_step = "Step",
  t_label_t_sne_iterations = "t-SNE iterations",
  t_label_t_sne_learning_rate = "t-SNE learning rate",
  t_label_t_sne_perplexity = "t-SNE perplexity",
  t_label_t_sne_speed_preset = "t-SNE speed preset:",
  t_choice_t_sne_speed_fast = "Fast (default)",
  t_choice_t_sne_speed_balanced = "Balanced",
  t_choice_t_sne_speed_quality = "High quality",
  t_label_t_sne_theta = "t-SNE theta",
  t_label_test_use = "test.use",
  t_label_top_n_markers_per_cluster = "Top N markers per cluster",
  t_label_umap_min_distance = "UMAP min distance",
  t_label_umap_neighbors = "UMAP neighbors",
  t_label_umap_spread = "UMAP spread",
  t_label_umap_legend_position = "Legend position:",
  t_label_umap_legend_columns = "Legend columns (top/bottom):",
  t_label_use_cluster_column = "Use cluster column:",
  t_label_umap3d_color = "3D color by:",
  t_label_umap3d_embedding_type = "3D embedding type:",
  t_label_umap3d_split_by = "3D split by:",
  t_label_umap3d_split_value = "3D split value:",
  t_label_umap3d_dot_size = "3D dot size:",
  t_label_umap3d_dot_alpha = "3D dot opacity:",
  t_label_umap3d_export_filename = "Export filename:",
  t_btn_generate_3d_umap_preview = "Generate 3D embedding preview",
  t_text_umap3d_generate_hint = "Click to generate/update a 3D embedding from the latest confirmed embedding configuration.",
  t_btn_download_3d_umap_bundle = "Download 3D UMAP bundle (.zip)",
  t_text_umap3d_export_hint = "Download a bundle (.zip) containing the interactive HTML and required assets.",
  t_text_click_heatmap_image_zoom = "Click the heatmap image to zoom in.",
  t_text_cluster = "Cluster",
  t_text_controls_overall_spacing_between_clusters = "Controls overall spacing between clusters.",
  t_text_default_view_per_cluster_volcano_fdr = "Default view: per-cluster volcano (FDR vs fold change).",
  t_text_cluster_determination_workflow = "Step 1: load the pseudobulk overview. Step 2: review the per-cluster overview. Step 3: optionally run a custom comparison or heatmap.",
  t_text_pseudobulk_idle = "Choose a cluster metadata column and replicate column, then click 'Load pseudobulk overview'.",
  t_text_pseudobulk_umap_not_ready = "UMAP not ready yet. Click 'Load pseudobulk overview'.",
  t_text_custom_idle = "Choose a custom comparison, then click 'Run custom comparison'.",
  t_text_jj_workflow = "Step 1: choose the biological settings. Step 2: click 'Run jjvolcano'. Step 3: adjust labels and styling without recomputing DEG.",
  t_text_higher_theta_faster_but_less_precise = "Higher theta is faster but less precise.",
  t_text_higher_values_emphasize_global_structure_lower = "Higher values emphasize global structure; lower values emphasize local neighborhoods.",
  t_text_lower_values_make_clusters_tighter_higher = "Lower values make clusters tighter; higher values spread cells more evenly.",
  t_text_min_max_step_define_which_resolution = "Min/Max/Step define which resolution values will be tested in ClusterTree sweep.",
  t_text_more_than_one_condition_sample_detected = "More than one condition/sample detected. Choose an integration strategy.",
  t_text_now_lets_start_getting_result_data = "Now lets start getting the result! Data from the QC step is loaded. If multiple samples are detected, an integration step will be recommended.",
  t_text_per_cluster_volcano_cluster_vs_rest = "Per-cluster volcano (cluster vs rest)",
  t_text_please_complete_qc_step_click_apply = "Please complete the QC step and click 'Apply Filters & Proceed to Analysis' to load data onto this page.",
  t_text_preset = "Preset",
  t_text_roughly_reflects_neighborhood_size_considered_t = "Roughly reflects neighborhood size considered by t-SNE.",
  t_text_select_active_dataset_s_analysis = "Select Active Dataset(s) for Analysis:",
  t_text_select_one_more_objects = "Select one or more objects",
  t_text_replace_active_dataset_analysis = "Replace Active Dataset for Analysis:",
  t_text_add_datasets_analysis = "Add Dataset(s) for Analysis:",
  t_text_add_one_more_objects = "Add one or more objects",
  t_text_enable_reintegration = "Click to enable re-integration.",
  t_text_cancel_reintegration = "Click to cancel re-integration.",
  t_text_reintegration_unavailable = "Re-integration is unavailable because no non-integrated source datasets are loaded.",
  t_title_reintegration_confirm = "Enable re-integration?",
  t_text_reintegration_confirm = "This will temporarily disable the replace-object selector and let you choose multiple source samples again.",
  t_btn_enable_reintegration = "Enable re-integration",
  t_title_reenable_pca_confirm = "Re-enable PCA selection?",
  t_text_reenable_pca_confirm = "This will clear the confirmed PCA dims for this object and re-enable PCA controls in Normalize / Integrate.",
  t_btn_reenable_pca = "Re-enable PCA",
  t_text_pca_reenabled = "PCA selection has been re-enabled for this object.",
  t_text_tip_after_finishing_normalization_integration_setting = "Tip: After finishing normalization or integration and setting the PCA (dims), switch to the ",
  t_text_top_marker_genes = "Top Marker Genes",
  t_text_umap_configuration = "UMAP configuration",
  t_text_elbow_missing_generate_integration = "Elbow data is missing for this object. Generate it to unlock PCA dims and elbow preview.",
  t_text_elbow_locked_reenable = "PCA has been set for UMAP. Please move to other tabs.",
  t_text_elbow_missing_click_generate = "Elbow data is missing for this imported object. Click below to generate it from the current active dataset.",
  t_text_used_reproducible_umap_t_sne_embedding = "Used for reproducible UMAP/t-SNE embedding.",
  t_text_uses_pca_dims_set_normalize_integrate = "Uses the PCA dims set in Normalize/Integrate tab. This is shared with UMAP/t-SNE and clustering.",
  t_text_umap_pca_dims_current = "Current UMAP PCA dims: %d",
  t_text_umap_pca_dims_not_set = "Current UMAP PCA dims: not set yet.",
  t_text_loupe_import_shortcut_note = "If you want to skip umap running and have umap projections and clustering from loupe",
  t_text_value_used_umap_t_sne_configuration = "This value is used for: UMAP/t-SNE configuration preview, ClusterTree sweep, and final resolution application.",
  t_text_you_have_1_condition_sample_choose = "You have 1 condition/sample or choose not to integrate. Select a normalization method for your data.",
  t_text_zoomed_heatmap = "Zoomed Heatmap",
  t_title_1_integration = "1. Integration",
  t_title_1_normalization = "1. Normalization",
  t_title_2_set_pca_dims_downstream_steps = "2. Set PCA (dims) for downstream steps",
  t_title_analysis_integration_normalization_analysis = "Analysis: Integration, Normalization, and Analysis",
  t_btn_apply_final_resolution = "Apply final resolution",
  t_title_cluster_determination = "Differential Expression Analysis",
  t_title_clustering_resolution = "Clustering Resolution",
  t_title_clustertree = "ClusterTree",
  t_title_custom_comparison_volcano = "Custom comparison volcano",
  t_title_custom_pseudobulk_comparison = "Custom pseudobulk comparison",
  t_title_embedding_configuration = "Embedding configuration",
  t_title_embedding_preview = "Embedding preview",
  t_title_cluster_frequency = "Cell frequency by cluster",
  t_title_heatmap = "Heatmap",
  t_title_heatmap_settings = "Heatmap settings",
  t_title_normalize_integrate = "Normalize / Integrate",
  t_title_pca_elbow_preview = "PCA Elbow (Preview)",
  t_title_pseudobulk_overview = "Pseudobulk overview",
  t_title_pseudobulk_settings = "Pseudobulk settings",
  t_title_resolution_sweep_per_seurat_presets = "Resolution sweep (per Seurat presets)",
  t_title_umap = "UMAP",
  t_title_umap3d = "3D UMAP",
  t_title_umap3d_preview = "3D UMAP preview",
  t_title_umap3d_controls = "3D UMAP controls",
  t_title_umap_configuration = "UMAP Configuration",
  t_title_umap_visualization = "UMAP Visualization",
  t_title_umap_display = "UMAP display",
  t_title_waiting_data = "Waiting for Data...",
  t_text_no_stored_neighbor_graphs_will_compute_needed = "No stored neighbor graphs; will compute as needed.",
  t_text_no_resolution_available_yet_run_clustering_resolution_sweep_first = "No resolution available yet. Run clustering resolution sweep first.",
  t_text_no_resolutions_found_run_sweep_first = "No resolutions found; run a sweep first.",
  t_text_no_metadata_columns_available = "No metadata columns are available for DE grouping.",
  t_title_integration_suffix_confirm = "Confirm barcode suffix mapping before integration",
  t_text_integration_suffix_explain = "To avoid barcode collisions across samples, each cell barcode will be renamed as: original_barcode_SUFFIX.",
  t_text_integration_suffix_warning = "Please confirm or edit each suffix. This affects downstream files and external barcode-based joins.",
  t_text_integration_suffix_rules = "Format rules: 2-10 characters, uppercase letters/numbers only (A-Z, 0-9), no spaces or special characters.",
  t_label_integration_suffix = "Suffix",
  t_btn_integration_suffix_apply = "Apply suffixes and continue integration",
  t_text_integration_suffix_autoupper = "Suffixes were converted to uppercase automatically.",
  t_text_integration_suffix_empty = "Suffix cannot be empty.",
  t_text_integration_suffix_length = "Each suffix must be %d-%d characters.",
  t_text_integration_suffix_charset = "Suffixes must contain only uppercase letters and numbers (A-Z, 0-9).",
  t_text_integration_suffix_unique = "Suffixes must be unique across selected samples.",
  t_label_inobject_reintegration_switch = "Use in-object re-integration",
  t_text_inobject_reintegration_hint = "Integrated object detected. Re-integration will run inside this object using the selected metadata column.",
  t_text_integration_mixed_selection_error = "Mixed selection detected (integrated + non-integrated). Use either one integrated object only, or non-integrated objects only.",
  t_text_integration_integrated_multi_error = "Multiple integrated objects selected. Choose exactly one integrated object for in-object re-integration.",
  t_text_integration_integrated_switch_required = "Enable 'Use in-object re-integration' to run integration from the selected integrated object.",
  t_text_integration_no_selected = "No selected object available for integration.",
  t_text_integration_invalid_suffix_map = "Invalid barcode suffix mapping for integration.",
  t_text_integration_data_invalid = "Data invalid for integration.",
  t_title_jjvolcano_settings = "jjvolcano settings",
  t_title_jjvolcano_plot = "jjvolcano",
  t_title_jjvolcano_tab = "Differential Expression Analysis",
  t_btn_run_jjvolcano = "Run jjvolcano",
  t_label_jj_resolution = "Resolution:",
  t_label_jj_top_n = "Top N genes to label",
  t_label_jj_ns_fc_threshold = "NS |log2FC| threshold",
  t_btn_jj_apply_display = "Apply display settings",
  t_btn_jj_download_pdf = "Download jjvolcano PDF",
  t_label_jj_cluster = "Cluster to display:",
  t_label_jj_dot_size = "Dot size",
  t_label_jj_alpha = "Dot alpha",
  t_label_jj_up_color = "Up color",
  t_label_jj_down_color = "Down color",
  t_label_jj_fdr_cutoff = "FDR cutoff",
  t_label_jj_logfc_cutoff = "Absolute logFC cutoff",
  t_label_jj_title = "Plot title",
  t_label_jj_subtitle = "Plot subtitle",
  t_text_jj_all_clusters = "All clusters are displayed together.",
  t_label_jj_legend_position = "Legend position",
  t_text_jj_cache_idle = "No jjvolcano cache yet. Click 'Run jjvolcano'.",
  t_text_jj_cache_hit = "jjvolcano: cache hit (DEG reused).",
  t_text_jj_cache_miss = "jjvolcano: DEG recomputed and cached.",
  t_text_jj_ready = "jjvolcano ready.",
  t_text_jj_error_prefix = "jjvolcano error:",
  t_text_jj_no_finite = "No finite volcano values for this cluster.",
  t_text_jj_status_cache_hit = "cache hit",
  t_text_jj_status_recomputed = "recomputed",
  t_text_jj_advanced_controls = "Advanced parameters",
  t_text_jj_package_required = "Package 'scRNAtoolVis' with function 'jjVolcano' is required. Please run bootstrap from run.R.",
  t_label_annotation_cluster_column = "Cluster resolution column:",
  t_text_annotation_no_cluster_columns = "No cluster resolution columns found in meta.data. Run clustering resolution first.",
  t_text_annotation_celltypist_external_only = "CellTypist does not run inside this app yet. Run CellTypist in Python/Jupyter first, then import prediction table here.",
  t_text_annotation_celltypist_expected_cols = "Expected columns: barcode/cell plus predicted_labels (or majority_voting). Optional confidence: conf_score/probability/max_probability.",
  t_text_annotation_celltypist_format_note = "Accepted file types: .csv/.tsv/.txt. Header row required.",
  t_text_annotation_markergene_intro = "Use literature marker genes to annotate clusters across one or more resolutions.",
  t_label_annotation_markergene_file = "Marker table (.csv/.tsv/.txt)",
  t_text_annotation_markergene_file_note = "Marker file format: required columns 'label' and 'gene' (case-insensitive). Optional columns like source/weight are allowed.",
  t_label_annotation_markergene_paste = "Manual marker input (label: gene1, gene2, ...)",
  t_text_annotation_markergene_paste_hint = "Lines without ':' are ignored. You can mix uploaded + pasted markers.",
  t_label_annotation_markergene_min_genes = "Minimum genes per label",
  t_label_annotation_markergene_max_genes = "Maximum genes per label (0 = no limit)",
  t_label_annotation_markergene_margin = "Ambiguity margin (top1 - top2)",
  t_btn_annotation_markergene_run = "Run Marker Annotation",
  t_title_annotation_markergene_validation = "Marker validation",
  t_title_annotation_markergene_ranking = "MarkerGene resolution ranking",
  t_btn_annotation_markergene_apply_best = "Set best as active layer",
  t_text_annotation_markergene_no_ranking = "No MarkerGene ranking yet. Run marker annotation first.",
  t_text_annotation_markergene_no_markers = "No valid marker labels found. Provide marker table and/or manual marker input.",
  t_text_annotation_run_first_note = "No annotation layer results yet. Run SingleR/MarkerGene first, or import CellTypist predictions.",
  t_label_annotation_markergene_cluster_column = "Cluster resolution column(s):",
  t_text_annotation_markergene_cluster_hint = "Select one or more cluster/resolution columns. One annotation layer is saved per selected column.",
  t_title_annotation_markergene_resolution_view = "MarkerGene resolution view",
  t_text_annotation_ref_note_prefix = "Reference guidance:",
  t_text_annotation_ref_hpc = "HumanPrimaryCellAtlasData - Pros: broad human primary-cell coverage across many tissues; good default. Cons: can be coarse for fine immune subtypes and newer states.",
  t_text_annotation_ref_monaco = "MonacoImmuneData - Pros: detailed human blood immune labels. Cons: blood/immune-focused; weaker for non-immune or solid-tissue populations.",
  t_text_annotation_ref_immgen = "ImmGenData - Pros: strong mouse immune reference with rich immune-state detail. Cons: mouse-only and mostly immune; not suitable for human-focused datasets.",
  t_text_annotation_ref_mouserna = "MouseRNAseqData - Pros: broader mouse tissue coverage beyond immune lineages. Cons: labels can be coarser and less immune-specific than ImmGen.",
  t_btn_annotation_import_custom_ref = "Import custom reference",
  t_title_annotation_import_custom_ref = "Import custom SingleR reference",
  t_text_annotation_import_custom_ref_help = "Upload a .rds reference (SingleCellExperiment/SummarizedExperiment/matrix/list). If matrix-like, add metadata table with one row per reference cell/sample.",
  t_text_annotation_import_custom_ref_format_note = "If metadata is provided: one row per reference column, with label columns such as label.main or label.fine.",
  t_label_annotation_custom_ref_name = "Reference name",
  t_label_annotation_custom_ref_file = "Reference object (.rds)",
  t_label_annotation_custom_ref_meta_file = "Optional metadata (.csv/.tsv/.txt)",
  t_label_annotation_custom_ref_label_cols = "Label columns (optional, comma-separated)",
  t_text_annotation_custom_ref_loaded_prefix = "Custom references loaded:",
  t_text_annotation_custom_ref_none = "none",
  t_text_annotation_custom_ref_ready_prefix = "Selected custom reference:",
  t_text_annotation_custom_ref_default_note = "Choose built-in or import custom references.",
  t_btn_annotation_custom_ref_load = "Load reference",
  t_title_annotation_singler_advanced = "Advanced SingleR parameters",
  t_label_annotation_singler_de_method = "Marker DE method",
  t_label_annotation_singler_de_n = "Markers per label (de.n)",
  t_label_annotation_singler_sd_thresh = "Marker SD threshold (sd.thresh)",
  t_label_annotation_singler_quantile = "Score quantile",
  t_label_annotation_singler_aggr_ref = "Aggregate reference (aggr.ref)",
  t_label_annotation_singler_restrict = "Restrict labels (comma-separated)",
  t_label_annotation_singler_check_missing = "Check missing genes (reference)",
  t_label_annotation_singler_num_threads = "Threads (num.threads)",
  t_text_annotation_cluster_column_hint = "Used when 'Run by cluster (faster)' is enabled.",
  t_label_annotation_umap_card_layout = "UMAP card layout",
  t_choice_annotation_umap_card_layout_split = "Split view (two cards in one row)",
  t_choice_annotation_umap_card_layout_stacked = "Stacked view (full width, two rows)",
  t_title_cellmarker_helper = "CellMarker helper",
  t_text_cellmarker_helper = "Reference helper for known marker genes. This does not overwrite SingleR/CellTypist outputs.",
  t_text_cellmarker_fold_hint = "Expand helper",
  t_text_cellmarker_open_new_window = "This will open a new browser window. Your browser may block popups; please allow popups for this app if the page does not open.",
  t_label_cellmarker_species = "CellMarker species",
  t_label_cellmarker_tissue = "Tissue keyword",
  t_label_cellmarker_celltype = "Cell-type keyword",
  t_label_immgen_query = "ImmGen search keyword",
  t_btn_cellmarker_open = "Open CellMarker",
  t_btn_immgen_open = "Open ImmGen search",
  t_title_cellmarker_metadata_import = "Metadata import (optional)",
  t_label_cellmarker_file = "Optional CellMarker table (.csv/.tsv/.txt)",
  t_btn_cellmarker_import = "Import CellMarker table",
  t_title_cellmarker_preview = "CellMarker preview",
  t_text_cellmarker_no_table = "No CellMarker table loaded yet."

)

SPINNER_OVERLAY_MESSAGE_RUN_NORM_BTN <- "Running normalization..."
SPINNER_OVERLAY_MESSAGE_RUN_INTE_BTN <- "Running integration... The duration of this process is unpredictable and depends on the complexity of the dataset."
SPINNER_OVERLAY_MESSAGE_RUN_SWEEP_BTN <- "Finding clusters based on selected resolution range..."
SPINNER_OVERLAY_MESSAGE_GENERATE_ELBOW <- "Generating elbow plot..."
.analysis_pdf_modal_assets_ui <- local({
  fn <- tryCatch(get0("wl_pdf_modal_assets", mode = "function", inherits = TRUE), error = function(e) NULL)
  if (!is.function(fn)) return(NULL)
  tryCatch(fn(), error = function(e) NULL)
})

ANALYSIS_SPINNER_COLOR <- "#d3d3d3"
analysis_spinner_style <- "position: relative; height: 52px; width: 52px;"

analysis_with_busy_spinner <- function(output_ui, spinner = c("other", "umap", "clustertree")) {
  spinner <- match.arg(spinner)
  spin_tag <- switch(
    spinner,
    umap = shinybusy::spin_kit(
      spin = "bounce",
      color = ANALYSIS_SPINNER_COLOR,
      style = analysis_spinner_style
    ),
    clustertree = shinybusy::spin_epic(
      spin = "looping-rhombuses",
      color = ANALYSIS_SPINNER_COLOR
    ),
    shinybusy::spin_epic(
      spin = "self-building-square",
      color = ANALYSIS_SPINNER_COLOR
    )
  )

  shiny::div(
    class = "analysis-load-wrap",
    output_ui,
    shiny::div(class = "analysis-load-indicator", spin_tag)
  )
}

analysis_ui <- fluidPage(
  class = "plotting-page",
  shinyjs::useShinyjs(),
  tags$head( 
    tags$style(HTML("
      .analysis-load-wrap{
        position: relative;
        width: 100%;
      }
      .analysis-load-wrap.analysis-elbow-load-wrap{
        min-height: 480px;
      }
      .analysis-load-indicator{
        display: flex;
        position: absolute;
        inset: 0;
        z-index: 11;
        align-items: center;
        justify-content: center;
        pointer-events: none;
        background: rgba(255, 255, 255, 0.70);
        opacity: 0;
        visibility: hidden;
        transition: opacity 160ms ease-in-out, visibility 0s linear 160ms;
      }
      .analysis-load-wrap > .recalculating + .analysis-load-indicator{
        opacity: 1;
        visibility: visible;
        transition-delay: 0s;
      }
      .analysis-load-wrap > .recalculating{
        opacity: 0.30;
      }
      .anno-conf-header-row{
        display:flex;
        align-items:center;
        gap:10px;
        margin-bottom:8px;
      }
      .anno-conf-header-title{
        margin:0 !important;
        line-height:1 !important;
        white-space:nowrap;
        min-height:42px;
        display:flex;
        align-items:center;
      }
      .anno-conf-header-row .form-group{
        margin:0 !important;
      }
      .anno-conf-header-row .shiny-input-container{
        margin-top:0 !important;
        margin-bottom:0 !important;
      }
      .anno-conf-header-row select.form-control{
        height:42px !important;
        min-height:42px !important;
        padding:4px 34px 4px 12px !important;
        font-size:18px !important;
        line-height:1.2 !important;
        margin-top:0 !important;
        margin-bottom:0 !important;
      }
      .wl-side{
        background:#f8f9fa; border:1px solid #e5e7eb; border-radius:12px;
        padding:14px; margin-bottom:14px; box-shadow:0 2px 4px rgba(0,0,0,.04);
      }
      .plotting-left-panel .wl-side{
        border:0 !important;
      }
      .plotting-left-panel .well.analysis-object-selector-card-inline{
        border:0 !important;
      }
      #analysis_prep_row.analysis-integration-locked > #analysis_prep_left_col{
        position: relative;
        display: block !important;
      }
      #analysis_prep_row.analysis-integration-locked #normalization_block,
      #analysis_prep_row.analysis-integration-locked #integration_block{
        display: block !important;
      }
      #analysis_prep_row.analysis-integration-locked > #analysis_prep_left_col > *{
        opacity: 0.52;
        pointer-events: none;
        filter: saturate(0.85);
      }
      #analysis_prep_row.analysis-integration-locked > #analysis_prep_left_col::after{
        content: 'Locked until re-integration is enabled';
        position: absolute;
        inset: 10px 12px auto 12px;
        z-index: 9;
        display: inline-block;
        padding: 6px 10px;
        border-radius: 999px;
        background: rgba(255,255,255,0.96);
        border: 1px solid #d1d5db;
        color: #374151;
        font-weight: 600;
        font-size: 0.92rem;
        text-align: center;
      }

      .analysis-object-selector-wrap{
        display:flex;
        justify-content:flex-end;
      }

      .analysis-object-selector-card{
        width:min(100%, 540px);
        margin:0 0 0 auto;
        padding:12px 14px 10px;
      }

      .analysis-object-selector-card-top{
        padding:0;
        background:transparent;
        border:0;
        box-shadow:none;
      }

      .analysis-object-selector-card-inline{
        width:100%;
        margin-bottom:14px;
      }
      .analysis-object-selector-card-inline .selectize-control.multi .selectize-input{
        display:flex;
        flex-wrap:wrap;
        align-items:flex-start;
        align-content:flex-start;
        gap:4px;
        min-height:44px;
        max-height:180px;
        overflow-y:auto;
        padding-top:6px;
        padding-bottom:6px;
      }
      .analysis-object-selector-card-inline .selectize-control.multi .selectize-input > div.item{
        white-space:normal;
        max-width:100%;
      }
      .analysis-object-selector-card-inline .selectize-control.multi .selectize-input > input{
        min-width:120px !important;
      }
      .analysis-object-selector-card .form-group,
      .analysis-object-selector-card .shiny-input-container{
        margin-bottom:0;
      }

      .analysis-object-selector-card .control-label{
        margin-bottom:6px;
      }

      .analysis-object-selector-card-top .shiny-input-container{
        width:min(100%, 420px);
        margin-left:auto;
      }

      @media (max-width: 991px){
        .analysis-object-selector-wrap{
          justify-content:flex-start;
          margin-top:8px;
        }
        .analysis-object-selector-card{
          margin:0;
          width:100%;
        }
        .analysis-object-selector-card-top .shiny-input-container{
          width:100%;
          margin-left:0;
        }
      }

      .square-plot{
        position: relative;
        width: min(100%, calc(var(--plot-scroll-box-h) - 220px));
        aspect-ratio: 1 / 1;
        margin: 0 auto;
        overflow: hidden;
      }

      /* kill old padding-top hack */
      .square-plot::before{
        content: none !important;
        padding-top: 0 !important;
        display: none !important;
      }

      /* force all descendant drawing elements to stretch */
      .square-plot img,
      .square-plot canvas,
      .square-plot svg {
        width: 100% !important;
        height: 100% !important;
        object-fit: contain !important;
      }

      .square-plot > .shiny-plot-output,
      .square-plot > .plotly,
      .square-plot > .shiny-image-output {
        position: absolute;
        inset: 0;
        width: 100% !important;
        height: 100% !important;
      }

      .embedding-preview-plot {
        min-height: 0;
      }

      .elbow-preview-box {
        width: 100%;
        height: calc(var(--plot-scroll-box-h) - 96px);
        min-height: 480px;
        overflow: hidden;
      }
      .elbow-preview-shell {
        min-height: 480px;
      }
      .elbow-preview-placeholder {
        width: 100%;
        height: 100%;
        min-height: 480px;
      }
      .elbow-preview-box .plotly,
      .elbow-preview-box .js-plotly-plot,
      .elbow-preview-box .shiny-plot-output {
        height: 100% !important;
        min-height: 100% !important;
      }

      .elbow-missing-warning-card {
        background: #fff8db;
        border: 1px solid #f1d98a;
        border-radius: 12px;
      }
      .elbow-missing-warning-card .text-muted {
        color: #5a4a00 !important;
      }
      .elbow-missing-warning-card .elbow-note {
        display: flex;
        align-items: flex-start;
        gap: 8px;
        color: #5a4a00;
      }
      .elbow-missing-warning-card .elbow-note .fa {
        color: #a57b00;
        margin-top: 2px;
      }
      .elbow-missing-warning-card .elbow-warning-btn {
        background: #f6dea2;
        border-color: #d2ad47;
        color: #5a4a00;
      }
      .elbow-missing-warning-card .elbow-warning-btn:hover,
      .elbow-missing-warning-card .elbow-warning-btn:focus {
        background: #f1d38b;
        border-color: #bd9737;
        color: #4a3a00;
      }
      .elbow-missing-warning-card .elbow-warning-btn:disabled,
      .elbow-missing-warning-card .elbow-warning-btn.disabled {
        background: #f3e5bd;
        border-color: #d2ad47;
        color: #7a6730;
        opacity: 1;
      }

      .umap-cluster-freq-card{
        overflow: visible;
      }
      .umap-cluster-freq-card .analysis-load-wrap,
      .umap-cluster-freq-card .shiny-plot-output{
        width: 100% !important;
        max-width: 100%;
        overflow: visible !important;
      }
      .umap-cluster-freq-card .shiny-plot-output{
        min-height: 0;
      }
      .umap-cluster-freq-card .shiny-plot-output img{
        display: block;
        max-width: 100% !important;
      }

      .jjvolcano-scroll {
        width: 100%;
        overflow-x: auto;
        overflow-y: visible;
      }

      .jjvolcano-scroll .shiny-plot-output {
        height: auto !important;
      }

      .clustering-umap-side .load-container,
      .clustering-umap-side .load-container > :not(.load-overlay),
      .clustering-umap-side .shiny-html-output {
        min-height: 0 !important;
        height: auto !important;
      }

      .integration-method-cards .radio {
        margin: 0 0 8px 0;
      }
      .integration-method-cards .radio > label {
        display: flex;
        align-items: center;
        gap: 8px;
        width: 100%;
        border: 1px solid #cfd6df;
        border-radius: 12px;
        background: #f5f5f5;
        color: #1f2937;
        padding: 8px 10px;
        transition: border-color 160ms ease, background-color 160ms ease, box-shadow 160ms ease;
        cursor: pointer;
      }
      .integration-method-cards .radio > label:hover {
        border-color: #bfc7d1;
        background: #f0f0f0;
      }
      .integration-method-cards .radio input[type='radio'] {
        position: static;
        flex: 0 0 auto;
        margin: 0;
        vertical-align: unset;
      }
      .integration-method-cards .radio input[type='radio']:checked + .inte-method-card {
        border-color: #22c55e;
        background: #ecfdf3;
      }
      .integration-method-cards .radio > label:has(input[type='radio']:checked) {
        border-color: #22c55e;
        background: #ecfdf3;
        box-shadow: 0 0 0 1px rgba(34, 197, 94, 0.25);
      }
      .integration-method-cards .inte-method-card {
        display: grid;
        grid-template-columns: minmax(74px, max-content) minmax(0, 1fr) 16px;
        align-items: center;
        column-gap: 8px;
        margin-left: 0;
        width: 100%;
        min-width: 0;
      }
      .integration-method-cards .inte-method-row1,
      .integration-method-cards .inte-method-row2 {
        display: contents;
      }
      .integration-method-cards .inte-method-title {
        font-weight: 700;
        font-size: 11.5px;
        line-height: 1.2;
        color: #4b5563;
        white-space: nowrap;
        flex: 0 0 auto;
      }
      .integration-method-cards .inte-method-note {
        font-size: 11px;
        line-height: 1.25;
        color: #6b7280;
        margin-left: 0;
        min-width: 0;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
      .integration-method-cards .inte-method-info {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin-left: 0;
        width: 14px;
        height: 14px;
        min-width: 14px;
        border-radius: 999px;
        border: 1px solid #9ca3af;
        color: #6b7280;
        font-size: 10px;
        line-height: 12px;
        font-weight: 700;
        user-select: none;
        flex: 0 0 auto;
      }

  ")),
    .analysis_pdf_modal_assets_ui,
    tags$script(HTML(sprintf("
      (function() {
        // Manual preview policy: do not auto-show overlay on config edits.
      })();

      // Robustly seed/forward plot tab state even if Shiny tab binding lags.
      (function() {
        var DIAG = %s;
        var lastDiagSig = '';
        var lastSentPlotTab = '';
        var lastNonEmptyPlotTab = 'normalize / integrate';
        function emitPlotTabEvent(val, source, visible, activeValue, values) {
          if (!DIAG || !window.Shiny || !Shiny.setInputValue) return;
          try {
            Shiny.setInputValue('analysis_plot_tabs_emit', {
              value: val || '',
              source: source || '',
              visible: !!visible,
              active_dom: activeValue || '',
              last_nonempty: lastNonEmptyPlotTab || '',
              tabs_n: (values || []).length,
              ts_ms: Date.now()
            }, {priority: 'event'});
          } catch(e) {}
        }
        function pushPlotTabFromDom() {
          try {
            var root = document.getElementById('analysis_tabs_by_type');
            if (!root) return;
            var active = root.querySelector('ul.nav li.active a[data-value], ul.nav a.active[data-value], ul.nav-link.active[data-value]');
            var allTabs = Array.prototype.slice.call(root.querySelectorAll('ul.nav a[data-value], ul.nav-link[data-value]'));
            var values = allTabs.map(function(a){ return a.getAttribute('data-value') || ''; }).filter(Boolean);
            var visible = !!(root.offsetParent !== null);
            var activeValue = active ? (active.getAttribute('data-value') || '') : '';
            if (activeValue) {
              lastNonEmptyPlotTab = activeValue;
            }
            var activeForInput = activeValue || lastNonEmptyPlotTab || '';
            var sig = [activeForInput, visible ? '1' : '0', values.join(',')].join('|');
            if (window.Shiny && Shiny.setInputValue && sig !== lastDiagSig) {
              lastDiagSig = sig;
              Shiny.setInputValue('plot_tabs_dom_diag', {
                active: activeForInput,
                visible: visible,
                tabs_n: values.length,
                tabs: values
              }, {priority: 'event'});
            }
            if (activeForInput && window.Shiny && Shiny.setInputValue && activeForInput !== lastSentPlotTab) {
              lastSentPlotTab = activeForInput;
              Shiny.setInputValue('plot_tabs', activeForInput, {priority: 'event'});
              emitPlotTabEvent(activeForInput, 'dom_sync', visible, activeValue, values);
            } else if (!activeForInput) {
              emitPlotTabEvent('', 'dom_sync_drop_empty', visible, activeValue, values);
            }
          } catch (e) {}
        }

        document.addEventListener('shown.bs.tab', function(ev) {
          var el = ev && ev.target ? ev.target : null;
          if (!el) return;
          var root = document.getElementById('analysis_tabs_by_type');
          if (!root || !root.contains(el)) return;
          var v = el.getAttribute('data-value') || '';
          if (!v) return;
          lastNonEmptyPlotTab = v;
          if (window.Shiny && Shiny.setInputValue) {
            Shiny.setInputValue('plot_tabs', v, {priority: 'event'});
            emitPlotTabEvent(v, 'shown_bs_tab', true, v, []);
          }
        }, true);

        function bindRootObserver() {
          var root = document.getElementById('analysis_tabs_by_type');
          if (!root || typeof MutationObserver === 'undefined') return;
          var mo = new MutationObserver(function() { pushPlotTabFromDom(); });
          mo.observe(root, { attributes: true, childList: true, subtree: true });
        }

        function startSync() {
          pushPlotTabFromDom();
          bindRootObserver();
          document.addEventListener('visibilitychange', function() {
            pushPlotTabFromDom();
          });
          window.addEventListener('focus', function() {
            pushPlotTabFromDom();
          });
        }

        if (window.Shiny && window.Shiny.addCustomMessageHandler && !window.__analysisSetPlotTabBound) {
          window.__analysisSetPlotTabBound = true;
          window.Shiny.addCustomMessageHandler('analysis-set-plot-tab', function(msg) {
            var val = msg && msg.value ? String(msg.value) : '';
            if (!val) return;
            var root = document.getElementById('analysis_tabs_by_type');
            if (!root) return;
            var links = root.querySelectorAll('a[data-value]');
            var node = null;
            for (var i = 0; i < links.length; i++) {
              if ((links[i].getAttribute('data-value') || '') === val) {
                node = links[i];
                break;
              }
            }
            if (!node) return;
            lastNonEmptyPlotTab = val;
            lastSentPlotTab = val;
            if (window.bootstrap && window.bootstrap.Tab) {
              try { window.bootstrap.Tab.getOrCreateInstance(node).show(); } catch (e) { node.click(); }
            } else if (window.jQuery && window.jQuery.fn && window.jQuery.fn.tab) {
              window.jQuery(node).tab('show');
            } else {
              node.click();
            }
            if (window.Shiny && window.Shiny.setInputValue) {
              window.Shiny.setInputValue('plot_tabs', val, {priority: 'event'});
            }
          });
        }

        if (document.readyState === 'loading') {
          document.addEventListener('DOMContentLoaded', startSync, { once: true });
        } else {
          startSync();
        }
      })();
    ", if (isTRUE(get0("WANLAB_DIAG_MODE", ifnotfound = FALSE))) "true" else "false")))
  ),
  
  fluidRow(
    column(
      width = 8,
      div(
        class = "page-header",
        h2(icon("chart-line"), " ", ANALYSIS_UI_TEXT$t_title_analysis_integration_normalization_analysis),
        p(ANALYSIS_UI_TEXT$t_text_now_lets_start_getting_result_data)
      )
    ),
    column(
      width = 4,
      div(
        class = "analysis-object-selector-wrap",
        div(
          class = "analysis-object-selector-card analysis-object-selector-card-top",
          selectInput(
            "active_object_name_input",
            ANALYSIS_UI_TEXT$t_text_replace_active_dataset_analysis,
            choices = character(0),
            selected = character(0)
          )
        )
      )
    )
  ),
  
  div(
    id = "analysis_ready_gate",
      div(
        id = "analysis_tabs_by_type",
        class = "app-tabs-wrap",
        
        tabsetPanel(
          id = "plot_tabs",
          selected = "normalize / integrate",
          
          # -------- NORMALIZE / INTEGRATE (includes SCT/scale reminder + ELBOW)
          tabPanel(
            ANALYSIS_UI_TEXT$t_title_normalize_integrate,
            value = "normalize / integrate",

            fluidRow(
              id = "analysis_prep_row",
              # LEFT: only the controls (never empty)
              column(
                id = "analysis_prep_left_col",
                3,
                class = "plotting-left-panel",

                div(
                  class = "well analysis-object-selector-card analysis-object-selector-card-inline",
                  uiOutput("analysis_object_selector_inline_ui")
                ),
                
                # NORMALIZATION block (hidden/shown as a whole)
                div(
                  id = "normalization_block",
                  class = "wl-side",
                  h4(ANALYSIS_UI_TEXT$t_title_1_normalization),
                  p(ANALYSIS_UI_TEXT$t_text_you_have_1_condition_sample_choose),
                  radioButtons("norm_method", ANALYSIS_UI_TEXT$t_label_normalization_method,
                               choices = c("SCTransform (Recommended)" = "SCT",
                                           "LogNormalize (Conventional)" = "LogNormalize"),
                               selected = "SCT"),
                  actionButton("run_norm_btn", ANALYSIS_UI_TEXT$t_btn_run_normalization, icon = icon("cogs"), class = "btn-primary")
                ),
                conditionalPanel(
                  condition = "output.elbow_ready",
                  div(
                    class = "analysis-selector-overlay-wrap",
                    div(
                      class = "wl-side",
                      h4(ANALYSIS_UI_TEXT$t_title_2_set_pca_dims_downstream_steps),
                      sliderInput("prep_dims_slider", ANALYSIS_UI_TEXT$t_label_number_pcs_dims_use, min = 5, max = 50, value = 30),
                      p(tags$em(ANALYSIS_UI_TEXT$t_text_value_used_umap_t_sne_configuration)),
                      div(style="text-align:right; margin-top:6px;",
                          actionButton(
                            "to_umap_config_btn",
                            ANALYSIS_UI_TEXT$t_btn_next_umap_configuration,
                            class = "btn btn-success btn-sm pull-right",
                            onclick = "if(window.WLSpinnerOverlay){window.WLSpinnerOverlay.show({id:'global_overlay', text:'Preparing embedding preview...'});}"
                          ))
                    ),
                    conditionalPanel(
                      condition = "output.elbow_locked",
                      actionLink(
                        "analysis_enable_reintegrate_dims_overlay",
                        label = span(class = "analysis-selector-overlay-note", ANALYSIS_UI_TEXT$t_text_elbow_locked_reenable),
                        class = "analysis-selector-overlay-link"
                      )
                    )
                  )
                ),
                conditionalPanel(
                  condition = "output.elbow_ready",
                  div(
                    class = "wl-side",
                    p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_loupe_import_shortcut_note),
                    actionButton("to_data_browser_loupe_import_btn", ANALYSIS_UI_TEXT$t_btn_import_csv_from_loupe, class = "btn btn-default btn-sm")
                  )
                ),
                conditionalPanel(
                  condition = "!output.elbow_ready && !output.elbow_locked",
                  div(
                    class = "wl-side elbow-missing-warning-card",
                    div(
                      class = "elbow-note",
                      icon("exclamation-triangle"),
                      p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_elbow_missing_generate_integration)
                    ),
                    actionButton("prep_generate_elbow_btn", ANALYSIS_UI_TEXT$t_btn_generate_elbow_plot, class = "btn btn-sm elbow-warning-btn")
                  )
                ),
                
                # INTEGRATION block (hidden/shown as a whole)
                div(
                  id = "integration_block",
                  class = "wl-side",
                  h4(ANALYSIS_UI_TEXT$t_title_1_integration),
                  p(ANALYSIS_UI_TEXT$t_text_more_than_one_condition_sample_detected),
                  uiOutput("integrate_by_var_ui"),
                  div(
                    class = "integration-method-cards",
                    radioButtons(
                      "inte_method",
                      ANALYSIS_UI_TEXT$t_label_normalization_method,
                      choiceNames = list(
                        tags$span(
                          class = "inte-method-card",
                          tags$span(class = "inte-method-row1", tags$span(class = "inte-method-title", ANALYSIS_UI_TEXT$t_label_inte_cca_title)),
                          tags$span(
                            class = "inte-method-row2",
                            tags$span(class = "inte-method-note", ANALYSIS_UI_TEXT$t_label_inte_cca_note),
                            tags$span(class = "inte-method-info", title = ANALYSIS_UI_TEXT$t_hover_inte_cca, "i")
                          )
                        ),
                        tags$span(
                          class = "inte-method-card",
                          tags$span(class = "inte-method-row1", tags$span(class = "inte-method-title", ANALYSIS_UI_TEXT$t_label_inte_rpca_title)),
                          tags$span(
                            class = "inte-method-row2",
                            tags$span(class = "inte-method-note", ANALYSIS_UI_TEXT$t_label_inte_rpca_note),
                            tags$span(class = "inte-method-info", title = ANALYSIS_UI_TEXT$t_hover_inte_rpca, "i")
                          )
                        ),
                        tags$span(
                          class = "inte-method-card",
                          tags$span(class = "inte-method-row1", tags$span(class = "inte-method-title", ANALYSIS_UI_TEXT$t_label_inte_sct_title)),
                          tags$span(
                            class = "inte-method-row2",
                            tags$span(class = "inte-method-note", ANALYSIS_UI_TEXT$t_label_inte_sct_note),
                            tags$span(class = "inte-method-info", title = ANALYSIS_UI_TEXT$t_hover_inte_sct, "i")
                          )
                        ),
                        tags$span(
                          class = "inte-method-card",
                          tags$span(class = "inte-method-row1", tags$span(class = "inte-method-title", ANALYSIS_UI_TEXT$t_label_inte_harmony_title)),
                          tags$span(
                            class = "inte-method-row2",
                            tags$span(class = "inte-method-note", ANALYSIS_UI_TEXT$t_label_inte_harmony_note),
                            tags$span(class = "inte-method-info", title = ANALYSIS_UI_TEXT$t_hover_inte_harmony, "i")
                          )
                        ),
                        tags$span(
                          class = "inte-method-card",
                          tags$span(class = "inte-method-row1", tags$span(class = "inte-method-title", ANALYSIS_UI_TEXT$t_label_inte_merge_title)),
                          tags$span(class = "inte-method-row2", tags$span(class = "inte-method-note", ANALYSIS_UI_TEXT$t_label_inte_merge_note))
                        )
                      ),
                      choiceValues = c("CCA", "RPCA", "SCT", "Harmony", "merge"),
                      selected = "CCA"
                    )
                  ),
                  actionButton("run_inte_btn", ANALYSIS_UI_TEXT$t_btn_run_integration, icon = icon("cogs"), class = "btn-primary"),
                  div(style = "margin-top:10px;", uiOutput("integration_timing_ribbon"))
                )
              ),
              
              # RIGHT: elbow preview
              column(
                id = "analysis_prep_right_col",
                9,
                class = "plot_area_card_style",
                # render in plot area (NULL when not needed)
                uiOutput("prep_sct_scale_reminder"),
                conditionalPanel(
                  condition = "output.elbow_ready",
                  div(
                      class = "analysis-selector-overlay-wrap",
                      div(class="wl-side",
                          h4(ANALYSIS_UI_TEXT$t_title_pca_elbow_preview),
                          analysis_with_busy_spinner(
                            div(class = "analysis-elbow-load-wrap", uiOutput("prep_elbow_ui")),
                            spinner = "other"
                          )
                      ),
                      conditionalPanel(
                        condition = "output.elbow_locked",
                        actionLink(
                          "analysis_enable_reintegrate_elbow_overlay",
                          label = span(class = "analysis-selector-overlay-note", ANALYSIS_UI_TEXT$t_text_elbow_locked_reenable),
                          class = "analysis-selector-overlay-link"
                        )
                      )
                  )
                )
              )
            ),
            
            
          ),
          
          tabPanel(
            ANALYSIS_UI_TEXT$t_title_umap_configuration,
            value = "umap configuration",
            fluidRow(
              column(
                3,
                class = "plotting-left-panel",
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_embedding_configuration),
                    uiOutput("cfg_plot_format_ui"),
                    numericInput("cfg_seed_input", ANALYSIS_UI_TEXT$t_label_random_seed, value = 42, min = 1, step = 1),
                    p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_used_reproducible_umap_t_sne_embedding),
                    conditionalPanel(
                      condition = "!(/tsne/i.test(input.cfg_plot_format || ''))",
                      sliderInput("cfg_umap_neighbors", ANALYSIS_UI_TEXT$t_label_umap_neighbors, min = 5, max = 100, value = 30, step = 1),
                      p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_higher_values_emphasize_global_structure_lower),
                      sliderInput("cfg_umap_min_dist", ANALYSIS_UI_TEXT$t_label_umap_min_distance, min = 0.01, max = 0.99, value = 0.30, step = 0.01),
                      p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_lower_values_make_clusters_tighter_higher),
                      sliderInput("cfg_umap_spread", ANALYSIS_UI_TEXT$t_label_umap_spread, min = 0.5, max = 5.0, value = 1.0, step = 0.1),
                      p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_controls_overall_spacing_between_clusters)
                    ),
                    conditionalPanel(
                      condition = "(/tsne/i.test(input.cfg_plot_format || ''))",
                      selectInput(
                        "cfg_tsne_speed_preset",
                        ANALYSIS_UI_TEXT$t_label_t_sne_speed_preset,
                        choices = stats::setNames(
                          c("fast", "balanced", "quality"),
                          c(
                            ANALYSIS_UI_TEXT$t_choice_t_sne_speed_fast,
                            ANALYSIS_UI_TEXT$t_choice_t_sne_speed_balanced,
                            ANALYSIS_UI_TEXT$t_choice_t_sne_speed_quality
                          )
                        ),
                        selected = "fast",
                        selectize = FALSE
                      ),
                      sliderInput("cfg_tsne_perplexity", ANALYSIS_UI_TEXT$t_label_t_sne_perplexity, min = 5, max = 100, value = 20, step = 1),
                      p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_roughly_reflects_neighborhood_size_considered_t),
                      sliderInput("cfg_tsne_theta", ANALYSIS_UI_TEXT$t_label_t_sne_theta, min = 0.0, max = 0.9, value = 0.8, step = 0.05),
                      p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_higher_theta_faster_but_less_precise),
                      sliderInput("cfg_tsne_eta", ANALYSIS_UI_TEXT$t_label_t_sne_learning_rate, min = 50, max = 2000, value = 200, step = 50),
                      sliderInput("cfg_tsne_iter", ANALYSIS_UI_TEXT$t_label_t_sne_iterations, min = 250, max = 5000, value = 500, step = 50)
                    ),
                    actionButton(
                      "cfg_apply_btn",
                      ANALYSIS_UI_TEXT$t_btn_save_parameters_continue,
                      class = "btn btn-primary btn-sm",
                      onclick = "if(window.WLSpinnerOverlay){window.WLSpinnerOverlay.show({id:'global_overlay', text:'Preparing embedding preview...'});}"
                    )
                )
              ),
              column(
                9,
                class = "plot_area_card_style",
                div(class="wl-side embedding-preview-plot",
                    h4(ANALYSIS_UI_TEXT$t_title_embedding_preview),
                    analysis_with_busy_spinner(
                      plotOutput("umap_config_static_plot", height = "calc(var(--plot-scroll-box-h) - 96px)", width = "100%"),
                      spinner = "umap"
                    )
                )
              )
            )
          ),

          tabPanel(
            ANALYSIS_UI_TEXT$t_title_clustering_resolution,
            value = "clustering resolution",
            fluidRow(
              column(
                3,
                class = "plotting-left-panel",
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_umap_display),
                    uiOutput("umap_reduction_ui"),
                    uiOutput("umap_pca_status_ui"),
                    uiOutput("umap_colorby_ui"),
                    uiOutput("umap_res_selector_ui"),
                    checkboxInput("umap_split_by_sample", ANALYSIS_UI_TEXT$t_label_facet_sample_if_available, value = FALSE),
                    selectInput(
                      "umap_legend_position",
                      ANALYSIS_UI_TEXT$t_label_umap_legend_position,
                      choices = c("Top" = "top", "Bottom" = "bottom", "Right" = "right", "None" = "none"),
                      selected = "top"
                    ),
                    conditionalPanel(
                      condition = "input.umap_legend_position == 'top' || input.umap_legend_position == 'bottom'",
                      sliderInput(
                        "umap_legend_cols",
                        ANALYSIS_UI_TEXT$t_label_umap_legend_columns,
                        min = 1,
                        max = 8,
                        value = 4,
                        step = 1
                      )
                    )
                ),
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_resolution_sweep_per_seurat_presets),
                    radioButtons(
                      "sweep_preset", ANALYSIS_UI_TEXT$t_text_preset,
                      choices = c("Typical (0.4–1.2, step 0.2)" = "typ",
                                  "Broad (0.2–3.0, step 0.2)"   = "broad",
                                  "Fine (0.2–1.2, step 0.1)"    = "fine",
                                  "Custom"                      = "custom"),
                      selected = "typ"
                    ),
                    sliderInput("sweep_res_min", ANALYSIS_UI_TEXT$t_label_min_resolution, min = 0.1, max = 3.0, value = 0.4, step = 0.1),
                    sliderInput("sweep_res_max", ANALYSIS_UI_TEXT$t_label_max_resolution, min = 0.1, max = 3.0, value = 1.2, step = 0.1),
                    sliderInput("sweep_res_step",ANALYSIS_UI_TEXT$t_label_step,            min = 0.05, max = 1.0, value = 0.2, step = 0.05),
                    p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_uses_pca_dims_set_normalize_integrate),
                    p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_min_max_step_define_which_resolution),
                    uiOutput("sweep_graph_ui"),
                    actionButton("run_sweep_btn", ANALYSIS_UI_TEXT$t_btn_run_resolution_sweep, class = "btn btn-primary btn-sm"),
                    conditionalPanel(
                      condition = "output.sweep_ready",
                      tags$hr(),
                      h5(ANALYSIS_UI_TEXT$t_btn_apply_final_resolution),
                      uiOutput("final_res_picker_ui"),
                      actionButton("apply_final_res_btn", ANALYSIS_UI_TEXT$t_btn_apply_final_resolution, class = "btn btn-success btn-sm")
                    )
                )
              ),
              column(
                9,
                class = "plot_area_card_style",
                conditionalPanel(
                  condition = "output.sweep_ready",
                  uiOutput("clustertree_umap_layout_ui"),
                  div(class="wl-side",
                      DT::dataTableOutput("clustertree_summary_dt")
                  )
                ),
                conditionalPanel(
                  condition = "!output.sweep_ready",
                  div(class="wl-side clustering-umap-side",
                      h4(ANALYSIS_UI_TEXT$t_title_umap),
                      uiOutput("umap_plot_ui_pre_sweep")
                  )
                )
              )
            )
          ),

          # -------- ANNOTATION
          tabPanel(
            "Annotation",
            value = "annotation tools",
            fluidRow(
              column(
                3,
                class = "plotting-left-panel",
                div(class = "wl-side",
                    h4("Tool controls"),
                    radioButtons("anno_tool", "Annotation tool",
                                 choices = c("SingleR" = "singleR", "CellTypist" = "celltypist", "MarkerGene" = "markerGene"),
                                 selected = "singleR"),
                    textInput("anno_layer_name", "Layer name", value = "singleR_annotation"),
                    conditionalPanel(
                      condition = "input.anno_tool == 'singleR'",
                      selectInput("anno_singler_ref", "SingleR reference",
                                  choices = c("HumanPrimaryCellAtlasData", "MonacoImmuneData", "ImmGenData", "MouseRNAseqData"),
                                  selected = "HumanPrimaryCellAtlasData"),
                      uiOutput("anno_singler_ref_note_ui"),
                      actionButton("anno_singler_custom_ref_btn", ANALYSIS_UI_TEXT$t_btn_annotation_import_custom_ref, class = "btn btn-default btn-sm"),
                      uiOutput("anno_singler_custom_ref_status_ui"),
                      selectInput("anno_singler_label_level", "Label level",
                                  choices = c("label.main", "label.fine"),
                                  selected = "label.main"),
                      checkboxInput("anno_singler_prune", "Prune ambiguous labels", value = TRUE),
                      checkboxInput("anno_singler_finetune", "Fine tune labels", value = TRUE),
                      checkboxInput("anno_singler_cluster_mode", "Run by cluster (faster)", value = TRUE),
                      conditionalPanel(
                        condition = "input.anno_singler_cluster_mode",
                        uiOutput("anno_singler_cluster_cols_ui")
                      ),
                      tags$details(
                        tags$summary(tags$strong(ANALYSIS_UI_TEXT$t_title_annotation_singler_advanced)),
                        selectInput(
                          "anno_singler_de_method",
                          ANALYSIS_UI_TEXT$t_label_annotation_singler_de_method,
                          choices = c("classic", "wilcox", "t"),
                          selected = "classic"
                        ),
                        helpText("How marker genes are selected between labels. 'classic' is robust and usually a good default."),
                        numericInput(
                          "anno_singler_de_n",
                          ANALYSIS_UI_TEXT$t_label_annotation_singler_de_n,
                          value = 10,
                          min = 1,
                          step = 1
                        ),
                        helpText("Number of top marker genes kept per label. Higher values can improve recall but increase runtime."),
                        numericInput(
                          "anno_singler_sd_thresh",
                          ANALYSIS_UI_TEXT$t_label_annotation_singler_sd_thresh,
                          value = 1,
                          min = 0,
                          step = 0.1
                        ),
                        helpText("Minimum standard deviation filter for candidate markers. Increase to keep only more variable genes."),
                        numericInput(
                          "anno_singler_quantile",
                          ANALYSIS_UI_TEXT$t_label_annotation_singler_quantile,
                          value = 0.8,
                          min = 0.05,
                          max = 1,
                          step = 0.05
                        ),
                        helpText("Quantile used to summarize marker scores. Higher values emphasize top-matching marker signal."),
                        checkboxInput(
                          "anno_singler_aggr_ref",
                          ANALYSIS_UI_TEXT$t_label_annotation_singler_aggr_ref,
                          value = FALSE
                        ),
                        helpText("Aggregate reference profiles by label before scoring. Faster and often more stable, but may smooth rare subtypes."),
                        textInput(
                          "anno_singler_restrict_labels",
                          ANALYSIS_UI_TEXT$t_label_annotation_singler_restrict,
                          value = ""
                        ),
                        helpText("Optional whitelist of labels (comma-separated). Only these labels will be considered during annotation."),
                        checkboxInput(
                          "anno_singler_check_missing_ref",
                          ANALYSIS_UI_TEXT$t_label_annotation_singler_check_missing,
                          value = TRUE
                        ),
                        helpText("Fail early if requested genes are missing in the reference. Keep enabled for safer diagnostics."),
                        numericInput(
                          "anno_singler_num_threads",
                          ANALYSIS_UI_TEXT$t_label_annotation_singler_num_threads,
                          value = 1,
                          min = 1,
                          step = 1
                        ),
                        helpText("CPU threads for SingleR internals. Use 1 for maximum stability; increase for speed after validation.")
                      ),
                      actionButton("anno_run_singler_btn", "Run SingleR", class = "btn btn-primary btn-sm")
                    ),
                    conditionalPanel(
                      condition = "input.anno_tool == 'celltypist'",
                      tags$div(class = "alert alert-warning", style = "margin-bottom:8px; padding:8px 10px;",
                               ANALYSIS_UI_TEXT$t_text_annotation_celltypist_external_only),
                      p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_annotation_celltypist_expected_cols),
                      p(class = "text-muted", style = "margin-top:-6px;", ANALYSIS_UI_TEXT$t_text_annotation_celltypist_format_note),
                      textInput("anno_celltypist_model", "Model name", value = "Immune_All_Low.pkl"),
                      selectInput("anno_celltypist_mode", "Mode", choices = c("best match", "prob match"), selected = "best match"),
                      numericInput("anno_celltypist_p_thres", "Probability threshold", value = 0.5, min = 0, max = 1, step = 0.05),
                      checkboxInput("anno_celltypist_majority", "Use majority voting column when present", value = TRUE),
                      fileInput("anno_celltypist_file", "CellTypist result table (.csv/.tsv/.txt)", accept = c(".csv", ".tsv", ".txt")),
                      actionButton("anno_import_celltypist_btn", "Import CellTypist results", class = "btn btn-primary btn-sm")
                    ),
                    conditionalPanel(
                      condition = "input.anno_tool == 'markerGene'",
                      p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_annotation_markergene_intro),
                      fileInput("anno_markergene_file", ANALYSIS_UI_TEXT$t_label_annotation_markergene_file, accept = c(".csv", ".tsv", ".txt")),
                      p(class = "text-muted", style = "margin-top:-8px;", ANALYSIS_UI_TEXT$t_text_annotation_markergene_file_note),
                      textAreaInput(
                        "anno_markergene_paste",
                        ANALYSIS_UI_TEXT$t_label_annotation_markergene_paste,
                        value = "",
                        rows = 5,
                        placeholder = "T_cell: CD3D, CD3E, TRBC1\nB_cell: CD79A, MS4A1, CD74"
                      ),
                      p(class = "text-muted", style = "margin-top:-8px;", ANALYSIS_UI_TEXT$t_text_annotation_markergene_paste_hint),
                      uiOutput("anno_markergene_validation_ui"),
                      uiOutput("anno_markergene_cluster_cols_ui"),
                      numericInput("anno_markergene_min_genes", ANALYSIS_UI_TEXT$t_label_annotation_markergene_min_genes, value = 3, min = 1, step = 1),
                      numericInput("anno_markergene_max_genes", ANALYSIS_UI_TEXT$t_label_annotation_markergene_max_genes, value = 50, min = 0, step = 1),
                      numericInput("anno_markergene_margin", ANALYSIS_UI_TEXT$t_label_annotation_markergene_margin, value = 0.02, min = 0, step = 0.01),
                      actionButton("anno_run_markergene_btn", ANALYSIS_UI_TEXT$t_btn_annotation_markergene_run, class = "btn btn-primary btn-sm")
                    ),
                    tags$hr(),
                    tags$details(
                      tags$summary(tags$strong(ANALYSIS_UI_TEXT$t_title_cellmarker_helper), tags$span(" • "), tags$span(ANALYSIS_UI_TEXT$t_text_cellmarker_fold_hint)),
                      p(class = "text-muted", style = "margin-top:8px;", ANALYSIS_UI_TEXT$t_text_cellmarker_helper),
                      p(class = "text-muted", style = "margin-top:-4px; margin-bottom:8px;", ANALYSIS_UI_TEXT$t_text_cellmarker_open_new_window),
                      selectInput(
                        "anno_cellmarker_species",
                        ANALYSIS_UI_TEXT$t_label_cellmarker_species,
                        choices = c("Human" = "human", "Mouse" = "mouse"),
                        selected = "human"
                      ),
                      textInput("anno_cellmarker_tissue", ANALYSIS_UI_TEXT$t_label_cellmarker_tissue, value = ""),
                      textInput("anno_cellmarker_celltype", ANALYSIS_UI_TEXT$t_label_cellmarker_celltype, value = ""),
                      textInput("anno_immgen_query", ANALYSIS_UI_TEXT$t_label_immgen_query, value = ""),
                      fluidRow(
                        column(6, actionButton("anno_cellmarker_open_btn", ANALYSIS_UI_TEXT$t_btn_cellmarker_open, class = "btn btn-default btn-sm")),
                        column(6, actionButton("anno_immgen_open_btn", ANALYSIS_UI_TEXT$t_btn_immgen_open, class = "btn btn-default btn-sm"))
                      ),
                      tags$h5(ANALYSIS_UI_TEXT$t_title_cellmarker_metadata_import, style = "margin-top:10px;"),
                      fileInput("anno_cellmarker_file", ANALYSIS_UI_TEXT$t_label_cellmarker_file, accept = c(".csv", ".tsv", ".txt")),
                      actionButton("anno_cellmarker_import_btn", ANALYSIS_UI_TEXT$t_btn_cellmarker_import, class = "btn btn-primary btn-sm")
                    ),
                    tags$hr(),
                    uiOutput("anno_singler_resolution_switcher_ui"),
                    uiOutput("anno_markergene_resolution_switcher_ui"),
                    uiOutput("anno_active_layer_ui"),
                    actionButton("anno_apply_active_layer_btn", "Apply active layer as metadata", class = "btn btn-success btn-sm")
                )
              ),
              column(
                9,
                class = "plot_area_card_style",
                div(
                  class = "wl-side",
                  selectInput(
                    "anno_umap_card_layout",
                    ANALYSIS_UI_TEXT$t_label_annotation_umap_card_layout,
                    choices = stats::setNames(
                      c("split", "stacked"),
                      c(
                        ANALYSIS_UI_TEXT$t_choice_annotation_umap_card_layout_split,
                        ANALYSIS_UI_TEXT$t_choice_annotation_umap_card_layout_stacked
                      )
                    ),
                    selected = "split",
                    width = "380px"
                  )
                ),
                uiOutput("anno_umap_pair_ui"),
                div(class = "wl-side",
                    h4("Composition"),
                    uiOutput("anno_composition_plot_ui")
                ),
                conditionalPanel(
                  condition = "input.anno_tool == 'markerGene'",
                  div(
                    class = "wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_annotation_markergene_ranking),
                    DT::dataTableOutput("anno_markergene_ranking_table"),
                    tags$div(style = "margin-top:8px;",
                             actionButton("anno_markergene_apply_best_btn", ANALYSIS_UI_TEXT$t_btn_annotation_markergene_apply_best, class = "btn btn-success btn-sm"))
                  )
                ),
                div(class = "wl-side",
                    h4("Per-cell results"),
                    DT::dataTableOutput("anno_results_table")
                ),
                div(class = "wl-side",
                    h4("Agreement panel"),
                    DT::dataTableOutput("anno_agreement_table")
                ),
                div(class = "wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_cellmarker_preview),
                    DT::dataTableOutput("anno_cellmarker_table")
                )
              )
            )
          ),
          tabPanel(
            ANALYSIS_UI_TEXT$t_title_cluster_determination,
            value = "differential expression analysis",
            fluidRow(
              column(
                3,
                class = "plotting-left-panel",
                div(class="wl-side",
                    h4("Shared DEG settings"),
                    uiOutput("de_res_select_ui"),
                    uiOutput("de_sample_col_ui"),
                    selectInput("de_de_method", ANALYSIS_UI_TEXT$t_label_de_method, choices = c("edgeR", "DESeq2"), selected = "edgeR"),
                    sliderInput("de_max_genes", ANALYSIS_UI_TEXT$t_label_genes_used_top_variable, min = 500, max = 5000, value = 2000, step = 100)
                ),
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_jjvolcano_settings),
                    actionButton("jj_run_btn", ANALYSIS_UI_TEXT$t_btn_run_jjvolcano, class = "btn btn-primary btn-sm"),
                    tags$div(style = "margin-top:8px;", textOutput("jj_cache_status_text"))
                ),
                div(class="wl-side",
                    h4("Display"),
                    numericInput("jj_top_n", ANALYSIS_UI_TEXT$t_label_jj_top_n, value = 10, min = 1, step = 1),
                    numericInput("jj_ns_fc_threshold", ANALYSIS_UI_TEXT$t_label_jj_ns_fc_threshold, value = 0.25, min = 0, step = 0.05),
                    p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_jj_all_clusters),
                    tags$details(
                      tags$summary(ANALYSIS_UI_TEXT$t_text_jj_advanced_controls),
                      numericInput("jj_fdr_cutoff", ANALYSIS_UI_TEXT$t_label_jj_fdr_cutoff, value = 0.05, min = 0, max = 1, step = 0.01),
                      numericInput("jj_logfc_cutoff", ANALYSIS_UI_TEXT$t_label_jj_logfc_cutoff, value = 0.25, min = 0, step = 0.05),
                      sliderInput("jj_dot_size", ANALYSIS_UI_TEXT$t_label_jj_dot_size, min = 0.3, max = 3.0, value = 0.9, step = 0.1),
                      sliderInput("jj_alpha", ANALYSIS_UI_TEXT$t_label_jj_alpha, min = 0.1, max = 1.0, value = 0.75, step = 0.05),
                      colourpicker::colourInput("jj_up_color", ANALYSIS_UI_TEXT$t_label_jj_up_color, value = "#d73027"),
                      colourpicker::colourInput("jj_down_color", ANALYSIS_UI_TEXT$t_label_jj_down_color, value = "#4575b4"),
                      selectInput("jj_legend_position", ANALYSIS_UI_TEXT$t_label_jj_legend_position, choices = c("right", "bottom", "none"), selected = "right"),
                      textInput("jj_plot_title", ANALYSIS_UI_TEXT$t_label_jj_title, value = "jjvolcano (per-cluster vs rest)"),
                      textInput("jj_plot_subtitle", ANALYSIS_UI_TEXT$t_label_jj_subtitle, value = "Cached DEG reused unless biological settings change")
                    ),
                    tags$div(style = "margin-top:10px;", actionButton("jj_apply_display_btn", ANALYSIS_UI_TEXT$t_btn_jj_apply_display, class = "btn btn-default btn-sm")),
                    tags$div(style = "margin-top:8px;", actionButton("open_jjvolcano_pdf_modal", ANALYSIS_UI_TEXT$t_btn_jj_download_pdf, class = "btn btn-success btn-sm"))
                ),
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_pseudobulk_settings),
                    p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_pseudobulk_idle),
                    p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_default_view_per_cluster_volcano_fdr),
                    actionButton("pb_refresh_btn", ANALYSIS_UI_TEXT$t_btn_refresh_pseudobulk_view, class = "btn btn-primary btn-sm")
                ),
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_custom_pseudobulk_comparison),
                    p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_custom_idle),
                    selectInput("pb_custom_mode", ANALYSIS_UI_TEXT$t_label_comparison_mode,
                                choices = c("Cluster set A vs cluster set B" = "cluster_vs_cluster",
                                            "Cluster set A vs rest" = "cluster_set_vs_rest",
                                            "Condition A vs B within selected cluster set" = "condition_within_clusters"),
                                selected = "cluster_vs_cluster"),
                    uiOutput("pb_cluster_a_ui"),
                    conditionalPanel(
                      condition = "input.pb_custom_mode == 'cluster_vs_cluster'",
                      uiOutput("pb_cluster_b_ui")
                    ),
                    conditionalPanel(
                      condition = "input.pb_custom_mode == 'condition_within_clusters'",
                      uiOutput("pb_group_var_ui"),
                      uiOutput("pb_group_a_ui"),
                      uiOutput("pb_group_b_ui")
                    ),
                    checkboxInput("pb_custom_label_genes", ANALYSIS_UI_TEXT$t_label_pb_custom_label_genes, value = TRUE),
                    numericInput("pb_custom_top_n", ANALYSIS_UI_TEXT$t_label_pb_custom_top_n_genes, value = 12, min = 1, step = 1),
                    numericInput("pb_custom_prelog_threshold", ANALYSIS_UI_TEXT$t_label_pb_custom_prelog_threshold, value = 0.05, min = 0, max = 1, step = 0.01),
                    actionButton("pb_run_custom_btn", ANALYSIS_UI_TEXT$t_btn_run_custom_comparison, class = "btn btn-default btn-sm")
                ),
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_heatmap_settings),
                    numericInput("heatmap_topn", ANALYSIS_UI_TEXT$t_label_top_n_markers_per_cluster, value = 5, min = 1, step = 1),
                    numericInput("heatmap_minpct", ANALYSIS_UI_TEXT$t_label_min_pct, value = 0.1, min = 0, max = 1, step = 0.05),
                    numericInput("heatmap_logfc", ANALYSIS_UI_TEXT$t_label_logfc_threshold, value = 0.25, step = 0.05),
                    selectInput("heatmap_testuse", ANALYSIS_UI_TEXT$t_label_test_use,
                                choices = c("wilcox","t","bimod","LR","MAST","DESeq2"),
                                selected = "wilcox"),
                    actionButton("run_heatmap_btn2", ANALYSIS_UI_TEXT$t_btn_run_heatmap_resolution, class = "btn btn-primary btn-sm"),
                    tags$hr(),
                    shinyjs::hidden(downloadButton("download_heatmap_btn", ANALYSIS_UI_TEXT$t_btn_download, class = "btn-success"))
                )
              ),
              column(
                9,
                class = "plot_area_card_style",
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_jjvolcano_plot),
                    div(class = "jjvolcano-scroll",
                        analysis_with_busy_spinner(uiOutput("jjvolcano_plot_ui"), spinner = "other")
                    )
                ),
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_pseudobulk_overview),
                    fluidRow(
                      column(5, analysis_with_busy_spinner(uiOutput("pb_umap_plot_ui"), spinner = "umap")),
                      column(7, analysis_with_busy_spinner(uiOutput("pb_volcano_grid_plot_ui"), spinner = "other"))
                    )
                ),
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_custom_comparison_volcano),
                    analysis_with_busy_spinner(uiOutput("pb_custom_volcano_plot_ui"), spinner = "other")
                ),
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_heatmap),
                    p(em(ANALYSIS_UI_TEXT$t_text_click_heatmap_image_zoom)),
                    tags$div(id = "heatmap_zoom_wrapper", style = "cursor: zoom-in;",
                             imageOutput("static_heatmap_plot", height = "auto"))
                )
              )
            )
          ),
          tabPanel(
            wl_deprecated_label("Data Browser"),
            value = "data browser",
            {
              .db_ui <- get0("data_browser_tab_content", mode = "function", ifnotfound = NULL)
              if (is.function(.db_ui)) {
                .db_ui(include_header = FALSE)
              } else {
                div(class = "alert alert-warning", "Data Browser UI is unavailable. Please ensure page_data_browser.R is sourced.")
              }
            }
          ),
          tabPanel(
            ANALYSIS_UI_TEXT$t_title_umap_visualization,
            value = "umap visualization",
            fluidRow(
              column(
                3,
                class = "plotting-left-panel",
                div(class="wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_umap_display),
                    uiOutput("cfg_color_by_ui"),
                    uiOutput("cfg_split_by_ui"),
                    uiOutput("cfg_split_by_secondary_ui"),
                    selectInput(
                      "cfg_freq_group_by",
                      ANALYSIS_UI_TEXT$t_label_freq_group_by,
                      choices = c("Auto" = "auto", "Column split" = "column", "Row split" = "row"),
                      selected = "auto"
                    ),
                    sliderInput("cfg_dot_size", ANALYSIS_UI_TEXT$t_label_dot_size, min = 0.05, max = 2.5, value = 0.85, step = 0.01),
                    actionButton("open_umap_viz_pdf_modal", ANALYSIS_UI_TEXT$t_btn_download_pdf, class = "btn btn-default btn-sm")
                )
              ),
              column(
                9,
                class = "plot_area_card_style",
                div(class="wl-side embedding-preview-plot",
                    h4(ANALYSIS_UI_TEXT$t_title_embedding_preview),
                    analysis_with_busy_spinner(uiOutput("umap_viz_plot_ui"), spinner = "umap")
                ),
                div(class="wl-side umap-cluster-freq-card",
                    h4(ANALYSIS_UI_TEXT$t_title_cluster_frequency),
                    analysis_with_busy_spinner(uiOutput("umap_cluster_freq_plot_ui"), spinner = "other"),
                    actionButton("open_umap_freq_pdf_modal", ANALYSIS_UI_TEXT$t_btn_download_freq_pdf, class = "btn btn-default btn-sm")
                )
              )
            )
          ),
          tabPanel(
            ANALYSIS_UI_TEXT$t_title_umap3d,
            value = "umap3d_tab",
            fluidRow(
              column(
                3,
                class = "plotting-left-panel",
                div(class = "wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_umap3d_controls),
                    selectInput(
                      "umap3d_embedding_type",
                      ANALYSIS_UI_TEXT$t_label_umap3d_embedding_type,
                      choices = c("UMAP" = "UMAP", "tSNE" = "TSNE"),
                      selected = "UMAP",
                      selectize = FALSE
                    ),
                    actionButton("umap3d_generate_btn", ANALYSIS_UI_TEXT$t_btn_generate_3d_umap_preview, class = "btn btn-primary btn-sm"),
                    p(class = "text-muted", style = "margin-top:8px;", ANALYSIS_UI_TEXT$t_text_umap3d_generate_hint),
                    uiOutput("umap3d_colorby_ui"),
                    uiOutput("umap3d_splitby_ui"),
                    uiOutput("umap3d_splitvalue_ui"),
                    sliderInput("umap3d_point_size", ANALYSIS_UI_TEXT$t_label_umap3d_dot_size,
                                min = 0.2, max = 6.0, value = 1.2, step = 0.1),
                    sliderInput("umap3d_alpha", ANALYSIS_UI_TEXT$t_label_umap3d_dot_alpha,
                                min = 0.1, max = 1.0, value = 0.85, step = 0.05),
                    textInput("umap3d_export_name", ANALYSIS_UI_TEXT$t_label_umap3d_export_filename, value = "umap3d_interactive"),
                    p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_umap3d_export_hint),
                    downloadButton(
                      "download_umap3d_bundle",
                      ANALYSIS_UI_TEXT$t_btn_download_3d_umap_bundle,
                      class = "btn btn-success btn-sm",
                      onclick = "if(window.WLSpinnerOverlay){window.WLSpinnerOverlay.show({id:'global_overlay', text:'Building 3D UMAP bundle...'});}"
                    )
                )
              ),
              column(
                9,
                class = "plot_area_card_style",
                div(class = "wl-side",
                    h4(ANALYSIS_UI_TEXT$t_title_umap3d_preview),
                    uiOutput("umap3d_plot_ui")
                )
              )
            )
          )
        )
      )
  ),

  div(
    id = "analysis_waiting_gate",
    div(
      class = "alert alert-info",
      tags$strong(ANALYSIS_UI_TEXT$t_title_waiting_data),
      tags$br(),
      ANALYSIS_UI_TEXT$t_text_please_complete_qc_step_click_apply
    )
  )
)

.analysis_preview_result_matches_active <- function(preview_result, active_object_name) {
  if (!is.list(preview_result)) return(FALSE)
  if (length(active_object_name) != 1) return(FALSE)
  active_chr <- as.character(active_object_name)
  if (is.na(active_chr) || !nzchar(active_chr)) return(FALSE)
  preview_name <- preview_result$object_name
  if (length(preview_name) != 1) return(FALSE)
  preview_chr <- as.character(preview_name)
  !is.na(preview_chr) && nzchar(preview_chr) && identical(preview_chr, active_chr)
}

.analysis_table_has_required_cols <- function(tbl, cols) {
  if (!is.data.frame(tbl)) return(FALSE)
  cols <- as.character(cols %||% character(0))
  cols <- cols[!is.na(cols) & nzchar(cols)]
  length(cols) > 0L && all(cols %in% colnames(tbl))
}

.analysis_select_cols_fill <- function(tbl, cols, default = NA) {
  if (!is.data.frame(tbl)) return(data.frame(stringsAsFactors = FALSE))
  cols <- as.character(cols %||% character(0))
  cols <- cols[!is.na(cols) & nzchar(cols)]
  if (!length(cols)) return(tbl[, 0, drop = FALSE])
  out <- tbl
  nr <- nrow(out)
  for (cn in cols) {
    if (!(cn %in% colnames(out))) out[[cn]] <- rep(default, nr)
  }
  out[, cols, drop = FALSE]
}

.analysis_pca_stdev <- function(sobj) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(numeric())
  stdev <- tryCatch({
    red <- sobj[["pca"]]
    if (is.null(red)) return(numeric())
    as.numeric(slot(red, "stdev"))
  }, error = function(e) numeric())
  stdev[is.finite(stdev) & !is.na(stdev)]
}

.analysis_build_elbow_plot <- function(sobj) {
  stdev <- .analysis_pca_stdev(sobj)
  if (!length(stdev)) return(NULL)
  df <- data.frame(
    PC = seq_along(stdev),
    Standard.Deviation = stdev,
    stringsAsFactors = FALSE
  )
  ggplot2::ggplot(df, ggplot2::aes(x = PC, y = Standard.Deviation)) +
    ggplot2::geom_point(size = 2.6, color = "black") +
    ggplot2::labs(x = "PC", y = "Standard Deviation") +
    ggplot2::theme_minimal(base_size = 12)
}


analysis_server <- function(input, output, session, shared_data) {
  options(shiny.progress.showAfter = 0)   # show right away
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  .db_server_fn <- get0("data_browser_server", mode = "function", ifnotfound = NULL)
  if (is.function(.db_server_fn)) {
    .db_server_fn(input, output, session, shared_data)
  }
  .analysis_get_assay_data <- function(sobj, assay = NULL, layer = "data") {
    aa <- as.character(assay %||% "")
    if (!nzchar(aa)) aa <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
    assay_obj <- tryCatch(if (nzchar(aa)) sobj[[aa]] else NULL, error = function(e) NULL)
    use_layer <- inherits(assay_obj, "Assay5")
    args <- if (isTRUE(use_layer)) {
      list(object = sobj, layer = layer)
    } else {
      list(object = sobj, slot = layer)
    }
    if (nzchar(aa)) args$assay <- aa
    out <- tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
    if (!is.null(out)) return(out)
    # Final fallback across Seurat v4/v5 signatures.
    alt_args <- list(object = sobj)
    alt_args[[if (isTRUE(use_layer)) "slot" else "layer"]] <- layer
    if (nzchar(aa)) alt_args$assay <- aa
    tryCatch(do.call(Seurat::GetAssayData, alt_args), error = function(e) NULL)
  }
  .analysis_get_assay_features <- function(sobj, assay = NULL, layer_preference = c("data", "counts", "scale.data")) {
    aa <- as.character(assay %||% "")
    if (!nzchar(aa)) aa <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
    assay_obj <- tryCatch({
      if (nzchar(aa)) Seurat::GetAssay(sobj, assay = aa) else Seurat::GetAssay(sobj)
    }, error = function(e) NULL)
    feats <- tryCatch(rownames(assay_obj), error = function(e) NULL)
    feats <- as.character(feats %||% character(0))
    feats <- feats[nzchar(feats)]
    if (length(feats)) return(feats)
    for (ly in as.character(layer_preference %||% character(0))) {
      mat <- .analysis_get_assay_data(sobj, assay = aa, layer = ly)
      rn <- as.character(rownames(mat) %||% character(0))
      rn <- rn[nzchar(rn)]
      if (length(rn)) return(rn)
    }
    character(0)
  }
  .analysis_fetch_feature_values <- function(sobj, feature, cells = NULL, assay = "RNA", layer = "data") {
    feature <- .scalar_chr(feature, default = "")
    if (!nzchar(feature)) return(numeric(0))
    cells <- as.character(cells %||% character(0))
    old_assay <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
    on.exit({
      if (nzchar(old_assay)) try(Seurat::DefaultAssay(sobj) <- old_assay, silent = TRUE)
    }, add = TRUE)
    if (nzchar(assay)) try(Seurat::DefaultAssay(sobj) <- assay, silent = TRUE)
    layer_candidates <- unique(c(as.character(layer %||% "data"), "counts", "scale.data"))
    .signal_ok <- function(v) {
      v <- suppressWarnings(as.numeric(v))
      v <- v[is.finite(v)]
      if (!length(v)) return(FALSE)
      rng <- range(v, na.rm = TRUE)
      is.finite(rng[1]) && is.finite(rng[2]) && (rng[2] - rng[1]) > 0
    }
    first_valid <- numeric(0)
    fd_formals <- tryCatch(names(formals(Seurat::FetchData)), error = function(e) character(0))
    for (ly in layer_candidates) {
      args <- list(object = sobj, vars = feature)
      if (length(cells)) args$cells <- cells
      if ("layer" %in% fd_formals) {
        args$layer <- ly
      } else if ("slot" %in% fd_formals) {
        args$slot <- ly
      }
      fd <- tryCatch(do.call(Seurat::FetchData, args), error = function(e) NULL)
      if (is.data.frame(fd) && nrow(fd)) {
        out <- suppressWarnings(as.numeric(fd[[1L]]))
        if (length(out) == nrow(fd)) {
          if (!length(first_valid)) first_valid <- out
          if (.signal_ok(out)) return(out)
        }
      }
      mat <- .analysis_get_assay_data(sobj, assay = assay, layer = ly)
      ok_mat <- is.matrix(mat) || inherits(mat, "Matrix")
      if (!is.null(mat) && ok_mat && (feature %in% rownames(mat))) {
        cells_use <- cells
        if (!length(cells_use)) cells_use <- colnames(mat)
        vals <- suppressWarnings(as.numeric(mat[feature, cells_use, drop = TRUE]))
        if (length(vals)) {
          if (!length(first_valid)) first_valid <- vals
          if (.signal_ok(vals)) return(vals)
        }
      }
    }
    first_valid
  }
  .analysis_active_assay_name <- function(sobj, fallback = "RNA") {
    aa <- .scalar_chr(tryCatch(Seurat::DefaultAssay(sobj), error = function(e) ""), default = "")
    assays <- tryCatch(as.character(Seurat::Assays(sobj)), error = function(e) character(0))
    assays <- assays[nzchar(assays)]
    if (nzchar(aa) && aa %in% assays) return(aa)
    if (nzchar(fallback) && fallback %in% assays) return(fallback)
    assays[[1]] %||% fallback
  }
  .perf_now <- function() proc.time()[["elapsed"]]
  .wall_now <- function() as.numeric(Sys.time())
  .perf_log <- function(stage, t0 = NULL, details = NULL) {
    ts <- format(Sys.time(), "%H:%M:%OS3")
    dt <- if (!is.null(t0) && is.finite(as.numeric(t0))) {
      sprintf(" | +%.3fs", .perf_now() - as.numeric(t0))
    } else {
      ""
    }
    suffix <- ""
    if (!is.null(details)) {
      txt <- tryCatch(as.character(details), error = function(e) "")
      txt <- txt[nzchar(txt)]
      if (length(txt)) suffix <- paste0(" | ", paste(txt, collapse = " | "))
    }
    message(sprintf("[ANALYSIS PERF][%s] %s%s%s", ts, stage, dt, suffix))
  }
  .scalar_chr <- function(x, default = "") {
    if (is.null(x) || length(x) == 0) return(default)
    y <- as.character(x)
    if (!length(y)) return(default)
    y <- y[!is.na(y)]
    if (!length(y)) return(default)
    y[[1]]
  }
  .analysis_diag_last <- reactiveVal("")
  .get_active_entry <- function(sd) {
    nm <- .scalar_chr(sd$active_object_name, default = "")
    if (!nzchar(nm)) return(NULL)
    raw <- sd$all_seurat_objects[[nm]]
    if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
      can <- tryCatch(wanlab_canonicalize_object_entry(raw), error = function(e) NULL)
      if (!is.null(can)) {
        sd$all_seurat_objects[[nm]] <- can
        return(can)
      }
    }
    raw
  }
  .get_active_sobj  <- function(sd) { e <- .get_active_entry(sd); if (is.null(e)) return(NULL); if (is.list(e) && !is.null(e$obj)) e$obj else e }
  .set_active_sobj <- function(sd, sobj) {
    nm <- .scalar_chr(sd$active_object_name, default = "")
    if (!nzchar(nm) || is.null(sobj)) return(invisible(FALSE))
    entry <- sd$all_seurat_objects[[nm]]
    if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
      can <- tryCatch(
        wanlab_canonicalize_object_entry(utils::modifyList(as.list(entry %||% list()), list(obj = sobj))),
        error = function(e) NULL
      )
      if (!is.null(can)) {
        sd$all_seurat_objects[[nm]] <- can
        return(invisible(TRUE))
      }
    }
    if (is.list(entry) && !is.null(entry$obj)) entry$obj <- sobj else entry <- list(obj = sobj)
    if (is.null(entry$prefs) || !is.list(entry$prefs)) entry$prefs <- list()
    if (is.null(entry$plots) || !is.list(entry$plots)) entry$plots <- list()
    if (is.null(entry$analysis_cache) || !is.list(entry$analysis_cache)) entry$analysis_cache <- list()
    sd$all_seurat_objects[[nm]] <- entry
    invisible(TRUE)
  }
  analysis_selected_names <- reactiveVal(character(0))
  analysis_reintegration_enabled <- reactiveVal(FALSE)
  analysis_prefer_integrated_boot_pending <- reactiveVal(TRUE)
  analysis_registry_names_seen <- reactiveVal("")
  selector_sync_in_progress <- reactiveVal(FALSE)
  analysis_object_switch_overlay_pending <- reactiveVal(FALSE)
  analysis_active_elbow_preview <- reactiveVal(list(object_name = "", plot = NULL, ready = FALSE))
  .umap3d_error <- reactiveVal(NULL)
  .umap3d_requested <- reactiveVal(FALSE)
  .cfg_keeper_dirty <- reactiveVal(FALSE)
  analysis_route_trace <- reactiveVal(list(
    active = FALSE,
    token = 0L,
    started_at = NA_real_,
    last_heartbeat = NA_real_,
    ensure_attempts = 0L
  ))
  analysis_plot_tabs_initialized <- reactiveVal(FALSE)
  analysis_last_nonempty_plot_tab <- reactiveVal("normalize / integrate")
  analysis_last_dom_tab_restore <- reactiveVal("")
  analysis_last_dom_tab_restore_at <- reactiveVal(0)
  analysis_selector_sync_heartbeat <- reactiveVal(0L)
  analysis_selector_bind_attempts <- reactiveVal(0L)
  analysis_last_overlay_signature <- reactiveVal("")
  umap_viz_global_overlay_active <- reactiveVal(FALSE)
  umap_viz_overlay_shown_at <- reactiveVal(as.numeric(NA))
  umap_cfg_global_overlay_active <- reactiveVal(FALSE)
  umap_cfg_overlay_shown_at <- reactiveVal(as.numeric(NA))
  .umap3d_active_object_name <- reactive({
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (nzchar(nm)) return(nm)
    registry <- names(shared_data$all_seurat_objects %||% list())
    registry <- as.character(registry %||% character(0))
    registry <- registry[!is.na(registry) & nzchar(registry)]
    if (!length(registry)) return("")
    selected <- intersect(as.character(analysis_selected_names() %||% character(0)), registry)
    if (length(selected)) return(selected[[1]])
    registry[[1]]
  })
  
  .get_obj_from_entry <- function(entry) {
    if (is.null(entry)) return(NULL)
    if (is.list(entry) && !is.null(entry$obj)) return(entry$obj)
    entry
  }
  .entry_has_elbow_plot <- function(entry) {
    if (is.null(entry) || !is.list(entry)) return(FALSE)
    !is.null(tryCatch(entry$plots$elbow, error = function(e) NULL))
  }
  .sync_active_elbow_preview <- function(nm = shared_data$active_object_name, entry = NULL) {
    nm <- .scalar_chr(nm, default = "")
    if (!nzchar(nm)) {
      analysis_active_elbow_preview(list(object_name = "", plot = NULL, ready = FALSE))
      return(invisible(NULL))
    }
    if (is.null(entry)) {
      entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    }
    # Elbow preview must come from an explicitly stored analysis/manual elbow,
    # not reconstructed from incidental PCA created by other workflows.
    plot_obj <- tryCatch(entry$plots$elbow, error = function(e) NULL)
    analysis_active_elbow_preview(list(
      object_name = nm,
      plot = plot_obj,
      ready = !is.null(plot_obj)
    ))
    invisible(plot_obj)
  }
  .entry_has_analysis_embedding_state <- function(entry) {
    if (is.null(entry) || !is.list(entry)) return(FALSE)
    if (.entry_has_elbow_plot(entry)) return(TRUE)
    stage_now <- tolower(.scalar_chr(tryCatch(entry$meta$stage, error = function(e) ""), default = ""))
    if (identical(stage_now, "integrated")) return(TRUE)
    dims_now <- suppressWarnings(as.integer(tryCatch(entry$prefs$confirmed_dims$value, error = function(e) NULL)))
    if (length(dims_now) && is.finite(dims_now[[1]]) && !is.na(dims_now[[1]])) return(TRUE)
    sweep_cache <- tryCatch(entry$analysis_cache$cluster_sweep, error = function(e) NULL)
    if (is.list(sweep_cache) && length(suppressWarnings(as.numeric(sweep_cache$resolutions %||% numeric()))) > 0L) return(TRUE)
    params_now <- tryCatch(entry$prefs$embedding_params, error = function(e) NULL)
    is.list(params_now) && length(params_now) > 0
  }
  .analysis_should_lock_elbow_preview <- function(entry = NULL) {
    if (isTRUE(analysis_reintegration_enabled())) return(FALSE)
    if (!isTRUE(.analysis_show_reintegrate_entry())) return(FALSE)
    if (is.null(entry)) {
      nm <- .scalar_chr(shared_data$active_object_name, default = "")
      if (!nzchar(nm)) return(FALSE)
      entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    }
    # Lock only after user has explicitly confirmed PCA dims for downstream steps.
    # Presence of temporary PCA/UMAP reductions alone (e.g., imported/workflow side-effects)
    # must not lock Normalize/Integrate controls.
    confirmed_dims <- suppressWarnings(as.integer(tryCatch(entry$prefs$confirmed_dims$value, error = function(e) NULL)))
    has_confirmed_dims <- length(confirmed_dims) >= 1L &&
      is.finite(confirmed_dims[[1]]) &&
      !is.na(confirmed_dims[[1]]) &&
      confirmed_dims[[1]] >= 2L
    if (!isTRUE(has_confirmed_dims)) return(FALSE)
    sobj <- .get_obj_from_entry(entry)
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(FALSE)
    reds <- tolower(tryCatch(names(sobj@reductions), error = function(e) character(0)))
    has_umap <- "umap" %in% reds
    has_pca <- "pca" %in% reds
    isTRUE(has_umap && has_pca)
  }
  
  .analysis_selectable_choices <- reactive({
    names(shared_data$all_seurat_objects %||% list())
  })
  observe({
    .perf_log("trace:ui_state", details = c(
      sprintf("main_navbar=%s", .scalar_chr(input$main_navbar, default = "<empty>")),
      sprintf("plot_tabs=%s", .scalar_chr(input$plot_tabs, default = "<empty>")),
      sprintf("active=%s", .scalar_chr(shared_data$active_object_name, default = "<empty>")),
      sprintf("selector_main=%s", .scalar_chr(input$active_object_name_input, default = "<empty>")),
      sprintf("selector_inline=%s", .scalar_chr(input$active_object_name_input_inline, default = "<empty>"))
    ))
    invisible(NULL)
  })
  observeEvent(input$plot_tabs, {
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    if (nzchar(tab_now)) analysis_last_nonempty_plot_tab(tab_now)
    .perf_log("plot_tabs:changed", details = c(
      sprintf("value=%s", if (nzchar(tab_now)) tab_now else "<empty>"),
      sprintf("effective=%s", .scalar_chr(analysis_last_nonempty_plot_tab(), default = "<empty>")),
      sprintf("main_navbar=%s", .scalar_chr(input$main_navbar, default = "<empty>"))
    ))
  }, ignoreInit = FALSE)
  observeEvent(input$analysis_plot_tabs_emit, {
    if (!isTRUE(get0("WANLAB_DIAG_MODE", ifnotfound = FALSE))) return(invisible(NULL))
    ev <- input$analysis_plot_tabs_emit
    .perf_log("plot_tabs:emit", details = c(
      sprintf("value=%s", .scalar_chr(ev$value, default = "<empty>")),
      sprintf("source=%s", .scalar_chr(ev$source, default = "<empty>")),
      sprintf("visible=%s", as.character(isTRUE(ev$visible))),
      sprintf("active_dom=%s", .scalar_chr(ev$active_dom, default = "<empty>")),
      sprintf("last_nonempty=%s", .scalar_chr(ev$last_nonempty, default = "<empty>")),
      sprintf("tabs_n=%s", as.character(ev$tabs_n %||% NA)),
      sprintf("ts_ms=%s", as.character(ev$ts_ms %||% NA))
    ))
    invisible(NULL)
  }, ignoreInit = FALSE)
  observeEvent(input$plot_tabs_dom_diag, {
    d <- input$plot_tabs_dom_diag
    if (is.null(d)) return(invisible(NULL))
    active <- .scalar_chr(d$active, "<empty>")
    visible <- isTRUE(d$visible)
    tabs <- as.character(d$tabs %||% character(0))
    tabs <- tabs[nzchar(tabs)]
    sig <- paste(active, as.character(visible), paste(tabs, collapse = ","), sep = "|")
    if (identical(sig, .analysis_diag_last())) return(invisible(NULL))
    .analysis_diag_last(sig)
    .perf_log("dom:plot_tabs_diag", details = c(
      sprintf("active=%s", active),
      sprintf("visible=%s", as.character(visible)),
      sprintf("tabs_n=%d", length(tabs)),
      sprintf("tabs=%s", if (length(tabs)) paste(tabs, collapse = ",") else "<none>")
    ))
    invisible(NULL)
  }, ignoreInit = FALSE)
  .current_plot_tab <- function() {
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    if (nzchar(tab_now)) return(tab_now)
    d <- input$plot_tabs_dom_diag
    if (!is.null(d)) {
      dtab <- .scalar_chr(d$active, default = "")
      if (nzchar(dtab)) return(dtab)
    }
    .scalar_chr(analysis_last_nonempty_plot_tab(), default = "normalize / integrate")
  }
  .analysis_plot_tab_active <- function(tab_label) {
    identical(.scalar_chr(.current_plot_tab(), default = ""), .scalar_chr(tab_label, default = ""))
  }
  .analysis_overlay_target_for_plot_tab <- function(tab_now) {
    tab_now <- .scalar_chr(tab_now, default = "")
    if (!nzchar(tab_now)) return("")
    switch(
      tab_now,
      "normalize / integrate" = "prep_elbow_ui",
      "umap configuration" = "umap_config_static_plot",
      "clustering resolution" = "clustertree_umap_layout_ui",
      "annotation tools" = "anno_results_table",
      "differential expression analysis" = "jjvolcano_plot_ui",
      "data browser" = "db_plot_group",
      "umap visualization" = "umap_viz_plot",
      "umap3d_tab" = "umap3d_plot_ui",
      ""
    )
  }
  .analysis_default_landing_tab <- function() {
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(nm)) return("normalize / integrate")
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    dims_now <- suppressWarnings(as.integer(tryCatch(entry$prefs$confirmed_dims$value, error = function(e) NULL)))
    has_confirmed_dims <- length(dims_now) >= 1L && is.finite(dims_now[[1]]) && !is.na(dims_now[[1]]) && dims_now[[1]] >= 2L
    if (isTRUE(has_confirmed_dims)) return("umap configuration")
    "normalize / integrate"
  }
  observe({
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) return(invisible(NULL))
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    if (nzchar(tab_now)) return(invisible(NULL))
    d <- input$plot_tabs_dom_diag
    if (is.null(d)) return(invisible(NULL))
    dtab <- .scalar_chr(d$active, default = "")
    if (!nzchar(dtab)) return(invisible(NULL))
    now_ts <- as.numeric(Sys.time())
    last_tab <- .scalar_chr(analysis_last_dom_tab_restore(), default = "")
    last_ts <- suppressWarnings(as.numeric(analysis_last_dom_tab_restore_at() %||% 0))
    if (identical(dtab, last_tab) && is.finite(last_ts) && (now_ts - last_ts) < 1.0) {
      return(invisible(NULL))
    }
    dtab_js <- gsub("'", "\\\\'", dtab, fixed = TRUE)
    suppressWarnings(try(shinyjs::runjs(sprintf(
      "if(window.Shiny){Shiny.setInputValue('plot_tabs','%s',{priority:'event'});}",
      dtab_js
    )), silent = TRUE))
    analysis_last_dom_tab_restore(dtab)
    analysis_last_dom_tab_restore_at(now_ts)
    .perf_log("plot_tabs:restored_from_dom", details = c(
      sprintf("active=%s", dtab),
      "reason=input_plot_tabs_empty"
    ))
    invisible(NULL)
  })

  observeEvent(input$main_navbar, {
    tab_now <- .scalar_chr(input$main_navbar, default = "")
    if (!identical(tab_now, "analysis_tab")) return(invisible(NULL))
    st <- isolate(analysis_route_trace())
    token <- as.integer(st$token %||% 0L) + 1L
    now <- .wall_now()
    analysis_route_trace(list(
      active = TRUE,
      token = token,
      started_at = now,
      last_heartbeat = now,
      ensure_attempts = 0L
    ))
    analysis_plot_tabs_initialized(FALSE)
    analysis_selector_bind_attempts(0L)
    .perf_log("route_enter", details = c(
      sprintf("token=%d", token),
      sprintf("active=%s", .scalar_chr(shared_data$active_object_name, default = "<empty>")),
      sprintf("plot_tabs=%s", .scalar_chr(input$plot_tabs, default = "<empty>"))
    ))
    overlay_show("Loading Analysis page...")
    nm_enter <- .scalar_chr(shared_data$active_object_name, default = "")
    if (nzchar(nm_enter)) {
      .cfg_preview_cache(list(key = NULL, result = NULL))
      .sync_active_elbow_preview(nm_enter)
      entry_enter <- shared_data$all_seurat_objects[[nm_enter]]
      preferred_fmt_enter <- .preferred_cfg_plot_format(entry_enter)
      updateSelectInput(session, "cfg_plot_format", selected = preferred_fmt_enter)
      .seed_cfg_preview_cache(nm_enter)
    }
    landing_tab_now <- .analysis_default_landing_tab()
    # Force one post-flush tab seed after the Analysis DOM is fully bound.
    session$onFlushed(function() {
      .go_plot_tab(landing_tab_now)
    }, once = TRUE)
  }, ignoreInit = FALSE)

  route_heartbeat_tick <- reactiveTimer(1000, session)
  route_ensure_tick <- reactiveTimer(500, session)

  observeEvent(route_heartbeat_tick(), {
    st <- isolate(analysis_route_trace())
    if (!isTRUE(st$active)) return(invisible(NULL))
    isolate({
      now <- .wall_now()
      started <- suppressWarnings(as.numeric(st$started_at %||% NA_real_))
      elapsed <- if (is.finite(started)) now - started else NA_real_
      .perf_log("route_heartbeat", details = c(
        sprintf("token=%s", as.character(st$token %||% NA_integer_)),
        sprintf("elapsed=%.3fs", if (is.finite(elapsed)) elapsed else NA_real_),
        sprintf("main_navbar=%s", .scalar_chr(input$main_navbar, default = "<empty>")),
        sprintf("plot_tabs=%s", .scalar_chr(.current_plot_tab(), default = "<empty>")),
        sprintf("active=%s", .scalar_chr(shared_data$active_object_name, default = "<empty>")),
        sprintf("ready=%s", as.character(isTRUE(.analysis_data_is_ready_flag())))
      ))
      if (is.finite(elapsed) && elapsed > 8 && (round(elapsed) %% 5L) == 0L) {
        .perf_log("route_waiting", details = c(
          sprintf("token=%s", as.character(st$token %||% NA_integer_)),
          sprintf("elapsed=%.1fs", elapsed),
          sprintf("plot_tabs=%s", .scalar_chr(.current_plot_tab(), default = "<empty>")),
          "status=still_waiting_for_plot_tabs_bind"
        ))
      }
    })
    invisible(NULL)
  }, ignoreInit = FALSE)

  observeEvent(route_ensure_tick(), {
    st <- isolate(analysis_route_trace())
    if (!isTRUE(st$active)) return(invisible(NULL))
    tab_now <- isolate(.scalar_chr(input$main_navbar, default = ""))
    if (!identical(tab_now, "analysis_tab")) return(invisible(NULL))
    if (isTRUE(isolate(analysis_plot_tabs_initialized()))) return(invisible(NULL))
    plot_tab_input <- isolate(.scalar_chr(input$plot_tabs, default = ""))
    if (nzchar(plot_tab_input)) return(invisible(NULL))

    attempts <- as.integer(st$ensure_attempts %||% 0L)
    should_probe <- (attempts < 40L) || ((attempts %% 5L) == 0L)
    landing_tab <- .analysis_default_landing_tab()
    if (isTRUE(should_probe)) {
      .go_plot_tab(landing_tab)
    }
    if ((attempts %% 10L) == 0L) {
      .perf_log("route_ensure_plot_tab", details = c(
        sprintf("token=%s", as.character(st$token %||% NA_integer_)),
        sprintf("attempt=%d", attempts + 1L),
        sprintf("selected=%s", landing_tab),
        sprintf("probe=%s", as.character(isTRUE(should_probe)))
      ))
    }
    analysis_route_trace(modifyList(st, list(ensure_attempts = attempts + 1L)))
    invisible(NULL)
  }, ignoreInit = FALSE)

  observe({
    st <- analysis_route_trace()
    if (!isTRUE(st$active)) return(invisible(NULL))
    plot_tab_input_now <- .scalar_chr(input$plot_tabs, default = "")
    plot_tab_effective_now <- .scalar_chr(.current_plot_tab(), default = "")
    selector_main_now <- .scalar_chr(input$active_object_name_input, default = "")
    selector_inline_now <- .scalar_chr(input$active_object_name_input_inline, default = "")
    selector_umap_inline_now <- .scalar_chr(input$active_object_name_input_umap_inline, default = "")
    selector_ready <- nzchar(selector_main_now) || nzchar(selector_inline_now) || nzchar(selector_umap_inline_now)
    route_ready <- isTRUE(.analysis_data_is_ready_flag()) &&
      identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab") &&
      isTRUE(analysis_plot_tabs_initialized()) &&
      nzchar(plot_tab_effective_now) &&
      isTRUE(selector_ready) &&
      nzchar(.scalar_chr(shared_data$active_object_name, default = ""))
    if (!isTRUE(route_ready)) return(invisible(NULL))
    now <- .wall_now()
    started <- suppressWarnings(as.numeric(st$started_at %||% NA_real_))
    elapsed <- if (is.finite(started)) now - started else NA_real_
    .perf_log("route_settled", details = c(
      sprintf("token=%s", as.character(st$token %||% NA_integer_)),
      sprintf("elapsed=%.3fs", if (is.finite(elapsed)) elapsed else NA_real_),
      sprintf("plot_tabs=%s", .scalar_chr(.current_plot_tab(), default = "<empty>")),
      sprintf("active=%s", .scalar_chr(shared_data$active_object_name, default = "<empty>")),
      sprintf("selector_main=%s", .scalar_chr(input$active_object_name_input, default = "<empty>")),
      sprintf("selector_inline=%s", .scalar_chr(input$active_object_name_input_inline, default = "<empty>"))
    ))
    try(overlay_hide(), silent = TRUE)
    showNotification("Analysis page is ready.", type = "message", duration = 2)
    analysis_route_trace(modifyList(st, list(active = FALSE, last_heartbeat = now)))
    invisible(NULL)
  })

  observeEvent(input$plot_tabs, {
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) return(invisible(NULL))
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    if (nzchar(tab_now)) {
      analysis_plot_tabs_initialized(TRUE)
      analysis_last_nonempty_plot_tab(tab_now)
    }
    invisible(NULL)
  }, ignoreInit = FALSE)

  observeEvent(input$plot_tabs, {
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) return(invisible(NULL))
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    if (!nzchar(tab_now)) return(invisible(NULL))
    target_output <- .analysis_overlay_target_for_plot_tab(tab_now)
    if (!nzchar(target_output)) return(invisible(NULL))
    active_now <- .scalar_chr(shared_data$active_object_name, default = "")
    sig_now <- paste(tab_now, active_now, sep = "||")
    if (identical(sig_now, .scalar_chr(analysis_last_overlay_signature(), default = ""))) {
      .perf_log("analysis_tab_overlay:skip_duplicate", details = c(
        sprintf("tab=%s", tab_now),
        sprintf("active=%s", if (nzchar(active_now)) active_now else "<empty>")
      ))
      return(invisible(NULL))
    }
    analysis_last_overlay_signature(sig_now)
    .perf_log("analysis_tab_overlay", details = c(
      sprintf("tab=%s", tab_now),
      sprintf("target_output=%s", target_output)
    ))
    try(overlay_show(sprintf("Loading %s...", tab_now)), silent = TRUE)
    try(overlay_hide_when_output_ready(target_output, timeout_ms = 120000L), silent = TRUE)
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$active_object_name_input, {
    if (nzchar(.scalar_chr(input$active_object_name_input, default = ""))) {
      analysis_selector_bind_attempts(0L)
    }
    invisible(NULL)
  }, ignoreInit = FALSE)

  observeEvent(input$plot_tabs_dom_diag, {
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) return(invisible(NULL))
    dtab <- .scalar_chr(input$plot_tabs_dom_diag$active, default = "")
    if (!nzchar(dtab)) return(invisible(NULL))
    analysis_plot_tabs_initialized(TRUE)
    analysis_last_nonempty_plot_tab(dtab)
    invisible(NULL)
  }, ignoreInit = FALSE)

  observeEvent(route_heartbeat_tick(), {
    st <- isolate(analysis_route_trace())
    if (!isTRUE(st$active)) return(invisible(NULL))
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) return(invisible(NULL))
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(nm)) return(invisible(NULL))
    selector_main_now <- .scalar_chr(input$active_object_name_input, default = "")
    selector_inline_now <- .scalar_chr(input$active_object_name_input_inline, default = "")
    selector_umap_inline_now <- .scalar_chr(input$active_object_name_input_umap_inline, default = "")
    selector_ready <- nzchar(selector_main_now) || nzchar(selector_inline_now) || nzchar(selector_umap_inline_now)
    if (isTRUE(selector_ready)) return(invisible(NULL))
    hb <- as.integer(isolate(analysis_selector_sync_heartbeat()) %||% 0L) + 1L
    analysis_selector_sync_heartbeat(hb)
    if ((hb %% 5L) == 0L) {
      .sync_analysis_selector_inputs(nm)
      .force_seed_selector_inputs(nm)
    }
    if ((hb %% 10L) != 0L) return(invisible(NULL))
    .perf_log("route_waiting_selector_bind", details = c(
      sprintf("token=%s", as.character(st$token %||% NA_integer_)),
      sprintf("active=%s", nm),
      sprintf("plot_tabs=%s", .scalar_chr(.current_plot_tab(), default = "<empty>"))
    ))
    invisible(NULL)
  }, ignoreInit = FALSE)

  observeEvent(route_heartbeat_tick(), {
    st <- isolate(analysis_route_trace())
    if (!isTRUE(st$active)) return(invisible(NULL))
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) return(invisible(NULL))
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(nm)) return(invisible(NULL))
    selector_main_now <- .scalar_chr(input$active_object_name_input, default = "")
    if (nzchar(selector_main_now)) return(invisible(NULL))
    tries <- as.integer(isolate(analysis_selector_bind_attempts()) %||% 0L) + 1L
    analysis_selector_bind_attempts(tries)
    if (tries > 90L) return(invisible(NULL))
    .sync_analysis_selector_inputs(nm)
    .force_seed_selector_inputs(nm)
    if ((tries %% 10L) == 0L) {
      .perf_log("selector_bind_retry", details = c(
        sprintf("try=%d", tries),
        sprintf("active=%s", nm),
        sprintf("plot_tabs=%s", .scalar_chr(.current_plot_tab(), default = "<empty>"))
      ))
    }
    invisible(NULL)
  }, ignoreInit = FALSE)
  .analysis_integrated_choices <- reactive({
    analysis_integrated_object_names(shared_data$all_seurat_objects %||% list())
  })
  .analysis_source_choices <- reactive({
    analysis_registry_object_names(shared_data$all_seurat_objects %||% list())
  })
  .analysis_selector_mode <- reactive({
    analysis_selector_mode_for_registry(
      shared_data$all_seurat_objects %||% list(),
      reintegration_enabled = isTRUE(analysis_reintegration_enabled())
    )
  })
  .analysis_replace_selector_enabled <- reactive({
    identical(.analysis_selector_mode(), "replace")
  })
  .analysis_multiselect_enabled <- reactive({
    identical(.analysis_selector_mode(), "multi")
  })
  .analysis_normalize_multiselect_enabled <- reactive({
    (.analysis_selector_mode() %in% c("multi", "reintegrate")) ||
      isTRUE(.analysis_selection_profile()$non_integrated_only)
  })
  .analysis_show_reintegrate_entry <- reactive({
    identical(.analysis_selector_mode(), "replace") && length(.analysis_source_choices()) > 0
  })
  .analysis_show_cancel_reintegrate_entry <- reactive({
    identical(.analysis_selector_mode(), "reintegrate")
  })
  .analysis_selection_profile <- reactive({
    reg <- shared_data$all_seurat_objects %||% list()
    reg_names <- names(reg)
    .is_integrated_for_lock <- function(nm) {
      entry <- reg[[nm]]
      isTRUE(tryCatch(analysis_object_is_integrated(nm, entry), error = function(e) FALSE))
    }
    .integrated_reason <- function(nm) {
      entry <- reg[[nm]]
      stage_now <- tolower(.scalar_chr(tryCatch(entry$meta$stage, error = function(e) ""), default = ""))
      assay_names <- tryCatch(analysis_selector_assay_names(entry), error = function(e) character(0))
      assay_names <- tolower(as.character(assay_names %||% character(0)))
      assay_names <- assay_names[!is.na(assay_names) & nzchar(assay_names)]
      parents <- tryCatch(entry$meta$parents, error = function(e) NULL)
      parents <- as.character(parents %||% character(0))
      parents <- parents[!is.na(parents) & nzchar(parents)]
      c(
        sprintf("%s:stage=%s", nm, if (nzchar(stage_now)) stage_now else "<empty>"),
        sprintf("%s:assays=%s", nm, if (length(assay_names)) paste(assay_names, collapse = "|") else "<none>"),
        sprintf("%s:name_flag=%s", nm, if (isTRUE(analysis_selector_name_looks_integrated(nm))) "TRUE" else "FALSE"),
        sprintf("%s:parents_n=%d", nm, length(parents))
      )
    }
    sel <- intersect(as.character(analysis_selected_names() %||% character(0)), reg_names)
    if (!length(sel)) {
      mode_now <- .analysis_selector_mode()
      if (identical(mode_now, "multi") || identical(mode_now, "reintegrate")) {
        sel <- c(
          as.character(input$active_object_name_input_inline %||% character(0)),
          as.character(input$active_object_name_input_umap_inline %||% character(0))
        )
      }
      sel <- unique(intersect(sel[nzchar(sel)], reg_names))
    }
    if (!length(sel)) {
      active_nm <- .scalar_chr(shared_data$active_object_name, default = "")
      if (nzchar(active_nm) && active_nm %in% reg_names) sel <- active_nm
    }
    integrated_sel <- sel[vapply(sel, .is_integrated_for_lock, logical(1))]
    nonintegrated_sel <- setdiff(sel, integrated_sel)
    if (length(sel) > 0L) {
      .perf_log("analysis_selector:selection_profile", details = c(
        sprintf("selected=%s", paste(sel, collapse = ",")),
        sprintf("integrated=%s", paste(integrated_sel, collapse = ",")),
        sprintf("nonintegrated=%s", paste(nonintegrated_sel, collapse = ",")),
        unlist(lapply(sel, .integrated_reason), use.names = FALSE)
      ))
    }
    list(
      selected = sel,
      integrated = integrated_sel,
      non_integrated = nonintegrated_sel,
      mixed = length(integrated_sel) > 0L && length(nonintegrated_sel) > 0L,
      integrated_only = length(sel) > 0L && length(nonintegrated_sel) == 0L,
      integrated_single = length(sel) == 1L && length(integrated_sel) == 1L,
      integrated_multi = length(integrated_sel) > 1L && length(nonintegrated_sel) == 0L,
      non_integrated_only = length(sel) > 0L && length(integrated_sel) == 0L
    )
  })
  .analysis_inobject_reintegrate_active <- reactive({
    prof <- .analysis_selection_profile()
    if (!isTRUE(prof$integrated_single)) return(FALSE)
    !identical(.scalar_chr(input$analysis_inobject_reintegrate_switch, default = "TRUE"), "FALSE")
  })
  .refresh_normalize_integration_visibility <- function() {
    mode_now <- .analysis_selector_mode()
    prof <- .analysis_selection_profile()
    sel <- prof$selected
    sobj <- .get_active_sobj(shared_data)
    num_samples <- max(length(sel), if (!is.null(sobj)) length(unique(sobj$orig.ident)) else 1L)
    inobject_active <- isTRUE(.analysis_inobject_reintegrate_active())
    hide_preprocess_cards <- identical(mode_now, "replace") &&
      !isTRUE(analysis_reintegration_enabled()) &&
      !isTRUE(inobject_active) &&
      !isTRUE(prof$non_integrated_only)
    if (isTRUE(hide_preprocess_cards)) {
      shinyjs::hide("normalization_block")
      shinyjs::hide("integration_block")
      return(invisible(FALSE))
    }
    integration_allowed <- (mode_now %in% c("multi", "reintegrate")) ||
      isTRUE(inobject_active) ||
      isTRUE(prof$non_integrated_only)
    method_now <- .scalar_chr(input$inte_method, default = "CCA")
    reintegrate_mode <- identical(mode_now, "reintegrate")
    show_integration <- (num_samples > 1L) &&
      isTRUE(integration_allowed) &&
      !identical(method_now, "merge") &&
      (isTRUE(reintegrate_mode) || (!isTRUE(prof$mixed) && !isTRUE(prof$integrated_multi)))
    if (isTRUE(show_integration)) {
      shinyjs::show("integration_block")
      shinyjs::hide("normalization_block")
    } else {
      shinyjs::show("normalization_block")
      shinyjs::hide("integration_block")
    }
    invisible(show_integration)
  }
  .integration_target_entries <- reactive({
    reg <- shared_data$all_seurat_objects %||% list()
    sel <- intersect(as.character(.integration_target_selection() %||% character(0)), names(reg))
    if (!length(sel)) {
      active_nm <- .scalar_chr(shared_data$active_object_name, default = "")
      if (nzchar(active_nm) && active_nm %in% names(reg)) sel <- active_nm
    }
    if (!length(sel)) return(list())
    reg[sel]
  })
  .integration_grouping_choices <- reactive({
    entries <- .integration_target_entries()
    if (!length(entries)) return(character(0))
    objs <- lapply(entries, .get_obj_from_entry)
    objs <- objs[vapply(objs, function(x) !is.null(x) && inherits(x, "Seurat"), logical(1))]
    if (!length(objs)) return(character(0))
    meta_list <- lapply(objs, function(obj) tryCatch(obj@meta.data, error = function(e) NULL))
    meta_list <- meta_list[vapply(meta_list, function(md) is.data.frame(md), logical(1))]
    if (!length(meta_list)) return(character(0))
    common_cols <- Reduce(intersect, lapply(meta_list, colnames))
    common_cols <- as.character(common_cols %||% character(0))
    common_cols <- common_cols[!is.na(common_cols) & nzchar(common_cols)]
    if (!length(common_cols)) return(character(0))
    .is_valid_group_col <- function(col) {
      vals <- unlist(lapply(meta_list, function(md) as.character(md[[col]])), use.names = FALSE)
      vals <- vals[!is.na(vals) & nzchar(vals)]
      if (length(unique(vals)) < 2L) return(FALSE)
      numeric_vals <- suppressWarnings(as.numeric(vals))
      is_num <- length(numeric_vals) == length(vals) && all(is.finite(numeric_vals))
      if (isTRUE(is_num) && length(unique(vals)) > 80L) return(FALSE)
      TRUE
    }
    usable <- common_cols[vapply(common_cols, .is_valid_group_col, logical(1))]
    if (!length(usable)) return(character(0))
    pref <- c("orig.ident", "condition", "batch", "sample", "sample_name")
    ordered <- unique(c(pref[pref %in% usable], sort(setdiff(usable, pref))))
    labels <- vapply(ordered, function(col) {
      if (identical(col, "orig.ident")) return("Sample (orig.ident)")
      if (identical(col, "condition")) return("Condition")
      if (identical(col, "batch")) return("Batch")
      col
    }, character(1))
    stats::setNames(ordered, labels)
  })
  output$integrate_by_var_ui <- renderUI({
    choices <- .integration_grouping_choices()
    if (!length(choices)) {
      return(helpText("No valid metadata grouping column is available for integration."))
    }
    current <- .scalar_chr(input$integrate_by_var, default = "")
    selected <- if (nzchar(current) && current %in% unname(choices)) {
      current
    } else {
      unname(choices[[1]])
    }
    .perf_log("integration_grouping_choices", details = c(
      sprintf("selected=%s", selected),
      sprintf("choices=%s", paste(unname(choices), collapse = ","))
    ))
    selected_label <- names(choices)[match(selected, unname(choices))]
    selected_label <- .scalar_chr(selected_label, default = selected)
    width_ch <- max(16L, nchar(selected_label, type = "width", allowNA = TRUE, keepNA = FALSE) + 6L)
    tags$div(
      style = "display:inline-block; width:auto; max-width:none;",
      selectInput(
        "integrate_by_var",
        ANALYSIS_UI_TEXT$t_label_integrate,
        choices = choices,
        selected = selected,
        selectize = FALSE,
        width = paste0(width_ch, "ch")
      )
    )
  })
  
  .db_server <- get0("data_browser_server", mode = "function", ifnotfound = NULL)
  if (is.function(.db_server)) {
    .db_server(input, output, session, shared_data)
  }
  
  .selected_analysis_names <- reactive({
    sel <- analysis_selected_names()
    choices <- .analysis_selectable_choices()
    sel <- intersect(sel, choices)
    if (!length(sel) && !is.null(shared_data$active_object_name) && shared_data$active_object_name %in% choices) {
      sel <- shared_data$active_object_name
    }
    sel
  })
  .analysis_subtab_is_active <- function(tab_name) {
    identical(.scalar_chr(.current_plot_tab(), default = ""), .scalar_chr(tab_name, default = ""))
  }
  .go_plot_tab <- function(tab_name) {
    tab_name <- .scalar_chr(tab_name, default = "")
    if (!nzchar(tab_name)) return(invisible(NULL))
    analysis_last_nonempty_plot_tab(tab_name)
    suppressWarnings(try(
      updateTabsetPanel(session, inputId = "plot_tabs", selected = tab_name),
      silent = TRUE
    ))
    session$sendCustomMessage("analysis-set-plot-tab", list(value = tab_name))
    invisible(NULL)
  }
  .analysis_selection_for_choices <- function(object_choices, allow_empty = FALSE, fallback_to_active = TRUE) {
    object_choices <- intersect(as.character(object_choices %||% character(0)), .analysis_selectable_choices())
    if (!length(object_choices)) return(character(0))
    selected <- intersect(as.character(isolate(analysis_selected_names()) %||% character(0)), object_choices)
    if (!length(selected) && isTRUE(fallback_to_active)) {
      active_selected <- .scalar_chr(shared_data$active_object_name, default = "")
      if (nzchar(active_selected) && active_selected %in% object_choices) {
        selected <- active_selected
      }
    }
    if (!length(selected) && !isTRUE(allow_empty)) selected <- object_choices[[1]]
    selected
  }
  .normalize_selector_selection <- reactive({
    mode_now <- .analysis_selector_mode()
    object_choices <- if (identical(mode_now, "reintegrate")) .analysis_source_choices() else .analysis_selectable_choices()
    persisted_sel <- intersect(as.character(analysis_selected_names() %||% character(0)), object_choices)
    if (length(persisted_sel)) return(persisted_sel)
    .analysis_selection_for_choices(
      object_choices = object_choices,
      allow_empty = identical(mode_now, "reintegrate"),
      fallback_to_active = !identical(mode_now, "reintegrate")
    )
  })
  .selector_overlay <- function(control_ui, overlay_id, overlay_text) {
    div(
      class = "analysis-selector-overlay-wrap",
      control_ui,
      actionLink(
        overlay_id,
        label = span(class = "analysis-selector-overlay-note", overlay_text),
        class = "analysis-selector-overlay-link"
      )
    )
  }
  .sync_analysis_selector_inputs <- function(sel) {
    choices <- .analysis_selectable_choices()
    sel <- intersect(as.character(sel %||% character(0)), choices)
    if (!length(sel)) return(invisible(NULL))
    active_sel <- .scalar_chr(sel[[1]], default = "")
    selector_sync_in_progress(TRUE)
    on.exit(selector_sync_in_progress(FALSE), add = TRUE)
    try(updateSelectInput(session, "active_object_name_input", choices = choices, selected = active_sel), silent = TRUE)
    # Do not write into inline selectize controls here.
    # Inline selector state must remain user-owned to avoid multi-select reset.
    invisible(sel)
  }
  .force_seed_selector_inputs <- function(sel) {
    choices <- .analysis_selectable_choices()
    sel <- intersect(as.character(sel %||% character(0)), choices)
    if (!length(sel)) return(invisible(NULL))
    target <- .scalar_chr(sel[[1]], default = "")
    if (!nzchar(target)) return(invisible(NULL))
    target_js <- gsub("'", "\\\\'", target, fixed = TRUE)
    suppressWarnings(try(shinyjs::runjs(sprintf(
      "(function(){var i=document.getElementById('active_object_name_input');if(i){i.value='%s';}})();",
      target_js
    )), silent = TRUE))
    invisible(target)
  }
  
  # flag that the sweep has produced something we can show
  .sweep_ready <- reactiveVal(FALSE)
  .cfg_preview_cache <- reactiveVal(list(key = NULL, result = NULL))
  .cfg_preview_pending_key <- reactiveVal(NULL)
  
  .coerce_dims <- function(x, default = 30L) {
    d <- suppressWarnings(as.integer(x %||% default))
    if (!length(d)) d <- as.integer(default)
    d <- d[1]
    if (!length(d) || is.na(d) || !is.finite(d)) d <- as.integer(default)
    d <- max(5L, min(50L, d))
    as.integer(d)
  }
  .get_confirmed_dims <- function(nm = shared_data$active_object_name) {
    if (is.null(nm)) return(NULL)
    suppressWarnings(as.integer(tryCatch(
      shared_data$all_seurat_objects[[nm]]$prefs$confirmed_dims$value,
      error = function(e) NULL
    )))
  }
  .effective_dims <- function(nm = shared_data$active_object_name, allow_slider_fallback = TRUE) {
    d <- .get_confirmed_dims(nm)
    if (length(d) && is.finite(d[1]) && !is.na(d[1])) return(.coerce_dims(d[1]))
    if (isTRUE(allow_slider_fallback)) return(.coerce_dims(input$prep_dims_slider %||% 30L))
    .coerce_dims(30L)
  }
  .commit_dims_for_object <- function(nm, dims, source = "normalize_integrate_next") {
    req(nm)
    if (is.null(shared_data$all_seurat_objects[[nm]]$prefs)) {
      shared_data$all_seurat_objects[[nm]]$prefs <- list()
    }
    shared_data$all_seurat_objects[[nm]]$prefs$confirmed_dims <- list(
      value = .coerce_dims(dims),
      source = as.character(source %||% "manual"),
      updated_at = Sys.time()
    )
  }

  .ct_plot_height_from_cache <- function(cache) {
    if (inherits(cache, "try-error") || is.null(cache$summary) || !is.data.frame(cache$summary)) {
      return(620L)
    }
    sm <- cache$summary
    max_res <- suppressWarnings(max(as.numeric(sm$resolution), na.rm = TRUE))
    at_max <- sm[is.finite(as.numeric(sm$resolution)) & as.numeric(sm$resolution) == max_res, , drop = FALSE]
    n_at_max <- suppressWarnings(as.integer(at_max$n_clusters[1]))
    if (!is.finite(n_at_max) || is.na(n_at_max) || n_at_max <= 0) {
      n_at_max <- suppressWarnings(max(as.integer(sm$n_clusters), na.rm = TRUE))
    }
    if (!is.finite(n_at_max) || is.na(n_at_max) || n_at_max <= 0) {
      return(620L)
    }
    h <- 560 + (max(0L, n_at_max - 12L) * 26L)
    as.integer(max(560L, min(760L, h)))
  }
  .cluster_sweep_resolution_count <- function(cache) {
    if (is.null(cache) || inherits(cache, "try-error")) return(0L)
    vals <- suppressWarnings(as.numeric(cache$resolutions %||% numeric()))
    vals <- sort(unique(vals[is.finite(vals)]))
    if (length(vals)) return(as.integer(length(vals)))
    sm <- cache$summary
    if (is.data.frame(sm) && "resolution" %in% colnames(sm)) {
      vals_sm <- suppressWarnings(as.numeric(sm$resolution))
      vals_sm <- sort(unique(vals_sm[is.finite(vals_sm)]))
      return(as.integer(length(vals_sm)))
    }
    0L
  }
  .clustertree_umap_layout_mode <- function(cache, threshold = 10L) {
    threshold <- suppressWarnings(as.integer(threshold))
    if (!is.finite(threshold) || is.na(threshold)) threshold <- 10L
    if (.cluster_sweep_resolution_count(cache) > as.integer(threshold)) "stacked" else "side_by_side"
  }

  .compact_clustertree_plot <- function(plt) {
    if (is.null(plt) || !inherits(plt, "ggplot")) return(plt)
    .cap_numeric_param <- function(x, cap = NULL, floor = NULL, fallback = NULL) {
      v <- suppressWarnings(as.numeric(x))
      if (!length(v) || all(!is.finite(v))) {
        if (is.null(fallback)) return(x)
        return(fallback)
      }
      if (is.finite(floor %||% NA_real_)) v[is.finite(v)] <- pmax(v[is.finite(v)], floor)
      if (is.finite(cap %||% NA_real_)) v[is.finite(v)] <- pmin(v[is.finite(v)], cap)
      v
    }
    if (length(plt$layers)) {
      for (i in seq_along(plt$layers)) {
        lyr <- plt$layers[[i]]
        gcls <- class(lyr$geom)[1] %||% ""
        if (grepl("GeomPoint", gcls, fixed = TRUE)) {
          # Keep ClusterTree dots legible while avoiding overlaps from extreme sizes.
          lyr$aes_params$size <- .cap_numeric_param(
            lyr$aes_params$size %||% NA_real_,
            floor = 2.4,
            cap = 5.2,
            fallback = 3.4
          )
          lyr$aes_params$stroke <- .cap_numeric_param(
            lyr$aes_params$stroke %||% NA_real_,
            floor = 0.30,
            cap = 0.55,
            fallback = 0.40
          )
        } else if (grepl("GeomTextRepel", gcls, fixed = TRUE) || grepl("GeomLabelRepel", gcls, fixed = TRUE)) {
          lyr$aes_params$size <- .cap_numeric_param(
            lyr$aes_params$size %||% NA_real_,
            floor = 2.3,
            cap = 3.4,
            fallback = 2.7
          )
          if (is.null(lyr$aes_params$min.segment.length)) lyr$aes_params$min.segment.length <- 0
        } else if (grepl("GeomText", gcls, fixed = TRUE) || grepl("GeomLabel", gcls, fixed = TRUE)) {
          lyr$aes_params$size <- .cap_numeric_param(
            lyr$aes_params$size %||% NA_real_,
            floor = 2.2,
            cap = 4.2,
            fallback = 2.8
          )
          lyr$aes_params$check_overlap <- TRUE
        }
        plt$layers[[i]] <- lyr
      }
    }

    plt + ggplot2::theme(
      text = ggplot2::element_text(size = 9),
      axis.text = ggplot2::element_text(size = 8),
      axis.title = ggplot2::element_text(size = 9),
      plot.title = ggplot2::element_text(size = 11)
    )
  }

  .umap_point_size_from_plot <- function(p, fallback = 0.85) {
    if (!inherits(p, "ggplot") || !length(p$layers)) return(as.numeric(fallback))
    for (lyr in p$layers) {
      gcls <- class(lyr$geom)[1] %||% ""
      if (!grepl("GeomPoint", gcls, fixed = TRUE)) next
      sz <- suppressWarnings(as.numeric(lyr$aes_params$size %||% NA_real_))
      if (is.finite(sz) && !is.na(sz) && sz > 0) return(sz)
    }
    as.numeric(fallback)
  }

  .umap_legend_dot_size <- function(dot_size = NULL, text_size = 10) {
    ds <- suppressWarnings(as.numeric(dot_size))
    if (!is.finite(ds) || is.na(ds) || ds <= 0) ds <- 0.85
    ts <- suppressWarnings(as.numeric(text_size))
    if (!is.finite(ts) || is.na(ts) || ts <= 0) ts <- 10
    as.numeric(max(ds * 3, ts * 0.32))
  }
  
  # helper: if levels are all digits, order them numerically (0,1,2,...,10,11)
  .factor_numeric_first <- function(x) {
    if (is.null(x)) return(x)
    f <- if (is.factor(x)) x else factor(as.character(x))
    lv <- levels(f)
    if (length(lv) && all(grepl("^-?[0-9]+$", lv))) {
      lv_ord <- lv[order(as.numeric(lv))]
      f <- factor(f, levels = lv_ord)
    }
    f
  }

  .label_wrap_plotly <- function(x, width = 18L) {
    txt <- gsub("_", " ", as.character(x %||% "NA"), fixed = TRUE)
    wrapped <- strwrap(txt, width = max(6L, as.integer(width %||% 18L)))
    if (!length(wrapped)) return(txt)
    paste(wrapped, collapse = "<br>")
  }

  .sort_facet_levels <- function(v) {
    lv <- .sort_levels_natural(v)
    if (!length(lv)) return(lv)
    # If all labels end with an integer suffix (e.g. Mouse-1, Mouse-2), enforce numeric suffix order.
    sfx <- suppressWarnings(as.numeric(sub("^.*?([0-9]+)$", "\\1", lv)))
    if (length(sfx) == length(lv) && all(is.finite(sfx))) {
      return(lv[order(sfx)])
    }
    lv
  }

  .zero_base_labels_if_needed <- function(values, column_name = NULL) {
    vals <- as.character(values %||% character())
    vals[is.na(vals) | !nzchar(vals)] <- "NA"
    if (!length(vals)) return(vals)
    nm <- tolower(as.character(column_name %||% ""))
    is_cluster_like <- identical(nm, ".ident") || grepl("(cluster|snn_res\\.|leiden_res\\.|_res\\.)", nm)
    if (!is_cluster_like) return(vals)
    if (!all(grepl("^-?[0-9]+$", vals))) return(vals)
    nums <- suppressWarnings(as.integer(vals))
    if (!length(nums) || any(!is.finite(nums))) return(vals)
    if (min(nums, na.rm = TRUE) != 1L) return(vals)
    as.character(nums - 1L)
  }

  .safe_meta_col <- function(md, x) {
    if (is.null(md) || !is.data.frame(md)) return(NULL)
    nm <- .scalar_chr(x, default = "")
    if (!nzchar(nm) || identical(nm, "__none__")) return(NULL)
    if (!(nm %in% colnames(md))) return(NULL)
    nm
  }

  .is_effectively_numeric <- function(x) {
    if (is.numeric(x)) {
      finite_n <- sum(is.finite(x), na.rm = TRUE)
      return(finite_n > 0L)
    }
    x_chr <- as.character(x %||% character(0))
    x_chr <- trimws(x_chr)
    x_chr[x_chr %in% c("", "NA", "NaN", "Inf", "-Inf")] <- NA_character_
    keep <- !is.na(x_chr)
    if (!any(keep)) return(FALSE)
    parsed <- suppressWarnings(as.numeric(x_chr[keep]))
    all(is.finite(parsed))
  }

  .is_cluster_like_metadata <- function(col_name, x = NULL) {
    nm <- tolower(trimws(as.character(col_name %||% "")))
    if (!nzchar(nm)) return(FALSE)
    name_hit <- grepl(
      "(^|[_\\.])(seurat_clusters|cluster|clust|louvain|leiden|graphcluster|snn_res|nn_res)([_\\.]|$)|(^|[_\\.])res\\.[0-9]+$",
      nm,
      perl = TRUE
    ) || grepl("^sweep_(nn_)?res\\.[0-9]+$", nm, perl = TRUE)
    if (isTRUE(name_hit)) return(TRUE)
    if (is.null(x)) return(FALSE)
    x_chr <- as.character(x %||% character(0))
    x_chr <- trimws(x_chr)
    x_chr[x_chr %in% c("", "NA", "NaN", "Inf", "-Inf")] <- NA_character_
    keep <- !is.na(x_chr)
    if (!any(keep)) return(FALSE)
    parsed <- suppressWarnings(as.numeric(x_chr[keep]))
    if (!all(is.finite(parsed))) return(FALSE)
    uniq_n <- length(unique(x_chr[keep]))
    n <- sum(keep)
    mostly_integer <- mean(abs(parsed - round(parsed)) < 1e-8) >= 0.98
    low_cardinality <- uniq_n <= max(60L, as.integer(ceiling(sqrt(n))))
    plausible_cluster_range <- min(parsed, na.rm = TRUE) >= -1 && max(parsed, na.rm = TRUE) <= 200
    mostly_integer && low_cardinality && plausible_cluster_range
  }

  .analysis_discrete_palette <- function(n) {
    n <- suppressWarnings(as.integer(n))
    if (!is.finite(n) || n < 1L) return(character(0))
    fn <- tryCatch(getFromNamespace("DiscretePalette", "Seurat"), error = function(e) NULL)
    pal <- tryCatch(
      if (is.function(fn)) suppressWarnings(as.character(fn(n))) else character(0),
      error = function(e) character(0)
    )
    if (length(pal) < n) pal <- grDevices::hcl.colors(max(n, 3L), palette = "Dark 3")
    pal[seq_len(n)]
  }

  .metadata_color_candidates <- function(col_name) {
    nm <- as.character(col_name %||% "")
    if (!nzchar(nm)) return(character(0))
    unique(c(
      paste0(nm, "_color"),
      paste0(nm, "_colour"),
      paste0(nm, ".color"),
      paste0(nm, ".colour"),
      paste0(nm, " color"),
      paste0(nm, " colour")
    ))
  }

  .match_colname_ci <- function(all_cols, targets) {
    all_cols <- as.character(all_cols %||% character(0))
    targets <- as.character(targets %||% character(0))
    if (!length(all_cols) || !length(targets)) return(character(0))
    all_l <- tolower(all_cols)
    out <- character(0)
    for (tgt in targets) {
      idx <- which(all_l %in% tolower(tgt))
      if (length(idx)) out <- c(out, all_cols[idx[[1]]])
    }
    unique(out)
  }

  .is_hex_color <- function(x) {
    grepl("^#[0-9A-F]{6}$", toupper(as.character(x %||% "")))
  }

  .palette_from_metadata_color_column <- function(md, label_col, levels_vec) {
    if (is.null(md) || !is.data.frame(md) || !nzchar(label_col) || !(label_col %in% colnames(md))) return(NULL)
    lv <- as.character(levels_vec %||% character(0))
    if (!length(lv)) return(NULL)
    color_col <- .match_colname_ci(colnames(md), .metadata_color_candidates(label_col))
    if (!length(color_col)) return(NULL)
    color_col <- color_col[[1]]

    labels <- as.character(md[[label_col]])
    labels[is.na(labels) | !nzchar(labels)] <- "NA"
    labels <- .zero_base_labels_if_needed(labels, label_col)
    cols <- toupper(as.character(md[[color_col]]))
    cols[! .is_hex_color(cols)] <- NA_character_

    pal <- setNames(rep(NA_character_, length(lv)), lv)
    for (nm in lv) {
      idx <- which(labels == nm & !is.na(cols))
      if (length(idx)) pal[[nm]] <- cols[idx[[1]]]
    }
    if (all(is.na(pal) | !nzchar(pal))) return(NULL)
    pal
  }

  .palette_from_object_misc_level_colors <- function(sobj, label_col, levels_vec) {
    if (is.null(sobj) || !inherits(sobj, "Seurat") || !nzchar(label_col)) return(NULL)
    lv <- as.character(levels_vec %||% character(0))
    if (!length(lv)) return(NULL)
    misc <- tryCatch(sobj@misc, error = function(e) NULL)
    store <- tryCatch(misc$metadata_level_colors, error = function(e) NULL)
    if (!is.list(store) || is.null(store[[label_col]]) || !is.list(store[[label_col]])) return(NULL)
    raw <- store[[label_col]]
    pal <- vapply(lv, function(nm) {
      cv <- toupper(.scalar_chr(raw[[nm]], default = ""))
      if (.is_hex_color(cv)) cv else NA_character_
    }, character(1))
    names(pal) <- lv
    if (all(is.na(pal) | !nzchar(pal))) return(NULL)
    pal
  }

  .palette_from_dimplot <- function(sobj, reduction_name, group_col, levels_vec) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
    if (!nzchar(group_col) || !(group_col %in% colnames(sobj@meta.data))) return(NULL)
    lv <- as.character(levels_vec %||% character(0))
    if (!length(lv)) return(NULL)

    reds <- tryCatch(names(sobj@reductions), error = function(e) character(0))
    if (!length(reds)) return(NULL)
    red_use <- as.character(reduction_name %||% "")
    if (!nzchar(red_use) || !(red_use %in% reds)) {
      red_l <- tolower(reds)
      red_use <- if ("umap" %in% red_l) reds[[match("umap", red_l)]] else reds[[1]]
    }

    p_tmp <- tryCatch(Seurat::DimPlot(sobj, reduction = red_use, group.by = group_col), error = function(e) NULL)
    if (is.null(p_tmp) || !inherits(p_tmp, "ggplot")) return(NULL)
    d_plot <- tryCatch(p_tmp$data, error = function(e) NULL)
    d_layer <- tryCatch(ggplot2::ggplot_build(p_tmp)$data[[1]], error = function(e) NULL)
    if (is.null(d_plot) || is.null(d_layer) || !nrow(d_plot) || !nrow(d_layer)) return(NULL)
    if (!(group_col %in% colnames(d_plot))) return(NULL)

    vals <- as.character(d_plot[[group_col]])
    vals[is.na(vals) | !nzchar(vals)] <- "NA"
    vals <- .zero_base_labels_if_needed(vals, group_col)
    cols <- toupper(as.character(d_layer$colour))
    cols[! .is_hex_color(cols)] <- NA_character_
    n <- min(length(vals), length(cols))
    if (n < 1L) return(NULL)
    vals <- vals[seq_len(n)]
    cols <- cols[seq_len(n)]
    keep <- !is.na(vals) & nzchar(vals) & !is.na(cols)
    vals <- vals[keep]
    cols <- cols[keep]
    if (!length(vals) || !length(cols)) return(NULL)
    first_idx <- match(unique(vals), vals)
    map <- cols[first_idx]
    names(map) <- unique(vals)
    mapped <- unname(map[lv])
    names(mapped) <- lv
    if (all(is.na(mapped) | !nzchar(mapped))) return(NULL)
    mapped
  }

  .palette_for_metadata_levels <- function(sobj, reduction_name, color_col, levels_vec) {
    lv <- as.character(levels_vec %||% character(0))
    if (!length(lv)) return(setNames(character(0), character(0)))
    fallback <- .analysis_discrete_palette(length(lv))
    names(fallback) <- lv

    from_misc <- .palette_from_object_misc_level_colors(sobj, color_col, lv)
    if (!is.null(from_misc) && length(from_misc)) {
      bad <- is.na(from_misc) | !nzchar(from_misc)
      from_misc[bad] <- fallback[bad]
      return(from_misc)
    }

    md <- tryCatch(sobj@meta.data, error = function(e) NULL)
    from_meta <- .palette_from_metadata_color_column(md, color_col, lv)
    if (!is.null(from_meta) && length(from_meta)) {
      bad <- is.na(from_meta) | !nzchar(from_meta)
      from_meta[bad] <- fallback[bad]
      return(from_meta)
    }

    from_dimplot <- .palette_from_dimplot(sobj, reduction_name = reduction_name, group_col = color_col, levels_vec = lv)
    if (!is.null(from_dimplot) && length(from_dimplot)) {
      bad <- is.na(from_dimplot) | !nzchar(from_dimplot)
      from_dimplot[bad] <- fallback[bad]
      return(from_dimplot)
    }

    fallback
  }

  .is_split_safe_metadata <- function(col_name, x = NULL) {
    if (is.null(x)) return(FALSE)
    if (.is_cluster_like_metadata(col_name, x)) return(TRUE)
    !.is_effectively_numeric(x)
  }

  .smart_short_labels <- function(values, column_name = NULL, keep_prefix_tokens = 1L) {
    vals <- as.character(values %||% character())
    vals[is.na(vals) | !nzchar(vals)] <- "NA"
    uniq <- unique(vals)
    out <- uniq
    names(out) <- uniq
    if (!length(uniq) || !identical(as.character(column_name %||% ""), "orig.ident") || length(uniq) < 2L) {
      return(out)
    }

    parts <- strsplit(uniq, "_", fixed = TRUE)
    min_len <- suppressWarnings(min(lengths(parts)))
    if (!is.finite(min_len) || min_len < 2L) return(out)

    prefix_len <- 0L
    while (prefix_len < min_len) {
      tok <- vapply(parts, function(p) p[[prefix_len + 1L]], character(1))
      if (length(unique(tok)) != 1L) break
      prefix_len <- prefix_len + 1L
    }

    suffix_len <- 0L
    while (suffix_len < (min_len - prefix_len)) {
      tok <- vapply(parts, function(p) p[[length(p) - suffix_len]], character(1))
      if (length(unique(tok)) != 1L) break
      suffix_len <- suffix_len + 1L
    }

    keep_prefix_tokens <- max(0L, as.integer(keep_prefix_tokens %||% 1L))
    start_idx <- max(1L, prefix_len - keep_prefix_tokens + 1L)

    short <- vapply(parts, function(p) {
      end_idx <- length(p) - suffix_len
      if (end_idx < start_idx) return(paste(p, collapse = "_"))
      paste(p[start_idx:end_idx], collapse = "_")
    }, character(1))

    dup <- duplicated(short) | duplicated(short, fromLast = TRUE)
    short[dup] <- uniq[dup]
    out <- short
    names(out) <- uniq
    out
  }

  .embedding_preview_levels <- function(sobj, split_by = NULL, split_by_secondary = NULL) {
    md <- tryCatch(sobj@meta.data, error = function(e) NULL)
    if (is.null(md) || !is.data.frame(md) || !nrow(md)) {
      return(list(col_levels = "All cells", row_levels = "All cells"))
    }

    col_levels <- "All cells"
    row_levels <- "All cells"
    split_by <- .safe_meta_col(md, split_by)
    split_by_secondary <- .safe_meta_col(md, split_by_secondary)

    if (!is.null(split_by)) {
      v <- as.character(md[[split_by]])
      v[is.na(v) | !nzchar(v)] <- "NA"
      v <- .zero_base_labels_if_needed(v, split_by)
      lv <- .sort_facet_levels(v)
      short_map <- .smart_short_labels(lv, column_name = split_by, keep_prefix_tokens = 1L)
      col_levels <- unname(short_map[lv])
    }
    if (!is.null(split_by_secondary) && !identical(split_by_secondary, split_by)) {
      v2 <- as.character(md[[split_by_secondary]])
      v2[is.na(v2) | !nzchar(v2)] <- "NA"
      v2 <- .zero_base_labels_if_needed(v2, split_by_secondary)
      lv2 <- .sort_facet_levels(v2)
      short_map2 <- .smart_short_labels(lv2, column_name = split_by_secondary, keep_prefix_tokens = 1L)
      row_levels <- unname(short_map2[lv2])
    }

    list(
      col_levels = col_levels %||% "All cells",
      row_levels = row_levels %||% "All cells"
    )
  }

  .embedding_preview_layout <- function(width_px, col_levels, row_levels) {
    width_px <- suppressWarnings(as.numeric(width_px))
    if (!is.finite(width_px) || is.na(width_px) || width_px <= 0) width_px <- 1050
    width_px <- max(420, width_px)

    n_cols <- max(1L, length(col_levels %||% "All cells"))
    n_rows <- max(1L, length(row_levels %||% "All cells"))
    panel_width <- width_px / n_cols

    max_col_chars <- max(nchar(as.character(col_levels %||% "All cells")), na.rm = TRUE)
    max_row_chars <- max(nchar(as.character(row_levels %||% "All cells")), na.rm = TRUE)

    chars_per_line <- max(8, floor(panel_width / 8))
    overflow_ratio <- max_col_chars / chars_per_line
    col_angle <- if (overflow_ratio > 1.10 || panel_width < 240) 30 else 0
    row_angle <- 0

    base_col_font <- if (panel_width < 180) 10 else if (panel_width < 260) 11 else 13
    col_font <- as.integer(max(8, round(base_col_font / max(1, overflow_ratio * 0.95))))
    row_slot <- (width_px / n_cols)
    row_font <- if (row_slot < 180) 10 else if (row_slot < 260) 11 else 13

    left_margin <- if (row_angle == 0) {
      as.integer(max(95, min(230, 24 + max_row_chars * 6)))
    } else {
      120L
    }
    top_margin <- as.integer(
      max(
        95L,
        min(
          300L,
          70 + if (col_angle == 0) 0 else 28 + max(0, max_col_chars - 16) * 2
        )
      )
    )

    panel_height <- width_px / n_cols
    total_height <- panel_height * n_rows + 80 + top_margin + if (n_cols * n_rows > 1L) 40 else 0
    total_height <- as.integer(max(420, min(3200, total_height)))

    list(
      width = width_px,
      height = total_height,
      n_cols = n_cols,
      n_rows = n_rows,
      panel_width = panel_width,
      col_angle = col_angle,
      row_angle = row_angle,
      col_font = col_font,
      row_font = row_font,
      left_margin = left_margin,
      top_margin = top_margin
    )
  }

  .sync_preview_metadata <- function(preview_sobj, ref_sobj, cols = character()) {
    if (is.null(preview_sobj) || is.null(ref_sobj) || !inherits(preview_sobj, "Seurat") || !inherits(ref_sobj, "Seurat")) {
      return(preview_sobj)
    }
    cols <- unique(as.character(cols %||% character()))
    cols <- cols[nzchar(cols)]

    md_preview <- tryCatch(preview_sobj@meta.data, error = function(e) NULL)
    md_ref <- tryCatch(ref_sobj@meta.data, error = function(e) NULL)
    if (is.null(md_preview) || is.null(md_ref) || !is.data.frame(md_preview) || !is.data.frame(md_ref)) return(preview_sobj)

    cells <- rownames(md_preview)
    if (!length(cells)) return(preview_sobj)
    common <- intersect(cells, rownames(md_ref))
    if (!length(common)) return(preview_sobj)

    if (length(cols)) {
      for (nm in cols) {
        if (!nm %in% colnames(md_ref)) next
        if (!nm %in% colnames(md_preview)) {
          md_preview[[nm]] <- NA
        }
        md_preview[common, nm] <- md_ref[common, nm, drop = TRUE]
      }
    }

    preview_sobj@meta.data <- md_preview
    ref_ids <- tryCatch(Seurat::Idents(ref_sobj), error = function(e) NULL)
    preview_ids <- tryCatch(Seurat::Idents(preview_sobj), error = function(e) NULL)
    if (!is.null(ref_ids) && !is.null(preview_ids)) {
      ref_ids_chr <- as.character(ref_ids)
      names(ref_ids_chr) <- names(ref_ids)
      preview_ids_chr <- as.character(preview_ids)
      names(preview_ids_chr) <- names(preview_ids)
      common_ids <- intersect(common, intersect(names(ref_ids_chr), names(preview_ids_chr)))
      if (length(common_ids)) {
        preview_ids_chr[common_ids] <- ref_ids_chr[common_ids]
        preview_levels <- .sort_levels_natural(preview_ids_chr)
        Seurat::Idents(preview_sobj) <- factor(preview_ids_chr, levels = preview_levels)
      }
    }
    preview_sobj
  }
  
  output$sweep_ready <- reactive({
    isTRUE(.sweep_ready())
  })
  outputOptions(output, "sweep_ready", suspendWhenHidden = FALSE)
  
  # --- ClusterTree: load user's script in a sandbox to avoid name clashes ---
  .reload_clustertree <- function() {
    # create env if missing
    if (!exists(".ct_env", inherits = FALSE)) {
      assign(".ct_env", new.env(parent = .GlobalEnv), envir = parent.env(environment()))
    }
    # wipe old symbols and (re)source
    rm(list = ls(.ct_env, all.names = TRUE), envir = .ct_env)
    try(source("interface/analysis/analysis_clustertree.R", local = .ct_env, chdir = TRUE), silent = TRUE)
  }
  
  .reload_clustertree()  # <-- call once at startup
  
  .run_clustertree <- function(sobj, res_vec, graph_name = NULL, dims = 30) {
    for (fn in c("ClusterTreeCloseToParents","cluster_tree_close_to_parents","manual_cluster_tree")) {
      if (exists(fn, envir = .ct_env, mode = "function", inherits = FALSE)) {
        return(get(fn, envir = .ct_env)(sobj, res_vec, graph = graph_name, dims = dims))
      }
    }
    NULL
  }
  
  # Find any resolution-like columns in meta.data
  # supports: integrated_snn_res.0.4, RNA_snn_res.0.4, seurat_clusters_res.0.4, etc.
  .find_resolution_columns <- function(sobj) {
    cn <- tryCatch(colnames(sobj@meta.data), error = function(e) character())
    if (!length(cn)) return(character())
    
    # 1) candidates by name: *_res.<number>
    cand <- cn[grepl("_res\\.[0-9]", cn, ignore.case = TRUE) &
                 !grepl("^seurat_", tolower(cn))]
    if (!length(cand)) return(character())
    
    # 2) keep only those whose levels look like Seurat clusters: "0","1","2",...
    is_cluster_col <- vapply(cand, function(nm) {
      v <- sobj@meta.data[[nm]]
      if (is.null(v)) return(FALSE)
      f <- .factor_numeric_first(v)
      lv <- levels(f)
      # must be >1 cluster and all levels purely digits
      length(lv) > 1 && all(grepl("^[0-9]+$", lv))
    }, logical(1))
    
    cand[is_cluster_col]
  }
  
  # Parse numeric resolution value from a column name
  # e.g. "seurat_clusters_res.0.4" → 0.4
  .parse_res_value <- function(colname) {
    as.numeric(sub("^.*_res\\.([0-9]+(?:\\.[0-9]+)?)$", "\\1", tolower(colname)))
  }
  
  # Ensure clustering exists at given resolution and materialize a column
  # Ensure clustering exists at given resolution and materialize a column
  # Ensure clustering exists at given resolution and materialize a column
  .ensure_clusters_at_resolution <- function(sobj, res, graph_name = NULL, dims = 30) {
    res_num <- as.numeric(res)
    
    # 1) Reuse any existing resolution-like cluster column at the same value.
    #    This avoids repeatedly recomputing neighbors/clusters for custom columns
    #    such as sweep_nn_res.* generated by this page.
    present_all   <- .find_resolution_columns(sobj)
    present_reuse <- present_all
    
    if (length(present_reuse)) {
      vals <- suppressWarnings(vapply(present_reuse, .parse_res_value, numeric(1)))
      if (any(is.finite(vals))) {
        idx <- which.min(abs(vals - res_num))
        if (!is.na(vals[idx]) && abs(vals[idx] - res_num) < 1e-8) {
          col <- present_reuse[idx]
          # Reuse existing clustering, but sort levels numerically
          f <- .factor_numeric_first(sobj@meta.data[[col]])
          sobj@meta.data[[col]] <- f
          Seurat::Idents(sobj)  <- f
          return(list(sobj = sobj, colname = col, created = FALSE))
        }
      }
    }
    
    # 2) Otherwise, compute neighbors + clusters at this resolution
    if (!"pca" %in% tolower(names(sobj@reductions))) {
      sobj <- tryCatch(Seurat::RunPCA(sobj, npcs = 50, verbose = FALSE), error = function(e) sobj)
    }
    
    dims <- as.integer(dims)
    sobj <- tryCatch(
      Seurat::FindNeighbors(sobj, dims = seq_len(dims),
                            graph.name = graph_name, verbose = FALSE),
      error = function(e) sobj
    )
    sobj <- tryCatch(
      Seurat::FindClusters(sobj, resolution = res_num,
                           graph.name = graph_name, verbose = FALSE),
      error = function(e) sobj
    )
    
    # 3) Try to pick the column Seurat just created that looks like *_res.<res>
    all_cols <- .find_resolution_columns(sobj)
    new_cols <- setdiff(all_cols, present_all)   # <- fixed: use present_all
    
    target_col <- NA_character_
    
    if (length(new_cols)) {
      vals_new <- suppressWarnings(vapply(new_cols, .parse_res_value, numeric(1)))
      if (any(is.finite(vals_new))) {
        idx <- which.min(abs(vals_new - res_num))
        target_col <- new_cols[idx]
      }
    }
    
    # 4) If Seurat didn't make a *_res.<res> column, create our own NON-seurat_* name
    if (is.na(target_col) || !nzchar(target_col)) {
      base <- if (!is.null(graph_name) && nzchar(graph_name)) {
        paste0(graph_name, "_res.")
      } else {
        "sweep_res."
      }
      target_col <- sprintf("%s%.2f", base, res_num)
      f <- .factor_numeric_first(Seurat::Idents(sobj))
      sobj@meta.data[[target_col]] <- f
    } else {
      # ensure it's a factor, with numeric ordering if appropriate
      sobj@meta.data[[target_col]] <- .factor_numeric_first(sobj@meta.data[[target_col]])
    }
    
    # 5) Sync Idents to the chosen column
    Seurat::Idents(sobj) <- sobj@meta.data[[target_col]]
    
    list(
      sobj    = sobj,
      colname = target_col,
      created = TRUE
    )
  }
  
  .meta_columns_for_color <- function(sobj) {
    cols <- tryCatch(colnames(sobj@meta.data), error = function(e) character())
    if (!length(cols)) return(character())
    clus <- cols[grepl("(seurat_clusters|cluster|celltype|cell_type|snn_res\\.|leiden_res\\.)", tolower(cols))]
    other <- setdiff(cols, clus)
    c(clus, other)
  }
  .reduction_choices <- function(sobj) {
    r <- tolower(tryCatch(names(sobj@reductions), error = function(e) character()))
    if (!length(r)) r <- character()
    r <- setdiff(r, c("umap3d"))
    unique(c(r, "umap","tsne","pca"))
  }
  .resolve_reduction_name_ci <- function(sobj, reduction_name) {
    red <- .scalar_chr(reduction_name, default = "")
    if (!nzchar(red)) return("")
    reds <- tryCatch(names(sobj@reductions), error = function(e) character(0))
    if (!length(reds)) return("")
    reds_lc <- tolower(reds)
    idx <- match(tolower(red), reds_lc)
    if (is.na(idx)) return("")
    reds[[idx]]
  }
  .reduction_pca_dims_label <- function(sobj, reduction_name) {
    real_red <- .resolve_reduction_name_ci(sobj, reduction_name)
    red_seed <- tolower(.scalar_chr(reduction_name, default = ""))
    if (!nzchar(real_red)) real_red <- .scalar_chr(reduction_name, default = "")
    red_lc <- tolower(real_red %||% red_seed)
    prefix <- if (grepl("tsne", red_lc, fixed = TRUE)) "TSNE" else if (grepl("umap", red_lc, fixed = TRUE)) "UMAP" else "PCA"
    if (!nzchar(real_red)) return(sprintf("%s_PCA", prefix))
    dims_raw <- tryCatch(sobj@reductions[[real_red]]@misc$cfg_signature$dims, error = function(e) NA_integer_)
    dims_val <- suppressWarnings(as.integer(dims_raw))
    dims_val <- dims_val[is.finite(dims_val) & !is.na(dims_val)]
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
  .cfg_plot_format_method <- function(sel) {
    x <- tolower(.scalar_chr(sel, default = ""))
    if (grepl("tsne", x, fixed = TRUE)) "tSNE" else "UMAP"
  }
  .cfg_plot_reduction_choices <- function(sobj) {
    reds <- tryCatch(names(sobj@reductions), error = function(e) character(0))
    if (!length(reds)) return(character(0))
    keep <- vapply(reds, function(red) {
      emb <- tryCatch(Seurat::Embeddings(sobj, red), error = function(e) NULL)
      is.matrix(emb) && ncol(emb) >= 2L && grepl("(umap|tsne)", tolower(red))
    }, logical(1))
    reds[keep]
  }
  .grouping_columns <- function(sobj) {
    cols <- tryCatch(colnames(sobj@meta.data), error = function(e) character())
    pref <- c("condition", "batch", "orig.ident", "sample", "sample_name")
    unique(c(pref[pref %in% cols], cols))
  }
  .de_cluster_metadata_columns <- function(sobj) {
    cols <- tryCatch(colnames(sobj@meta.data), error = function(e) character())
    cols <- as.character(cols %||% character())
    cols <- cols[!is.na(cols) & nzchar(cols)]
    if (!length(cols)) return(character())
    preferred <- c(
      "annotation", "celltype", "cell_type", "celltypes", "cell_types",
      "final_label", "predicted_labels", "majority_voting",
      "seurat_clusters", "orig.ident", "sample", "sample_name", "condition", "batch"
    )
    unique(c(preferred[preferred %in% cols], cols))
  }
  .meta_has_multiple_values <- function(sobj, col) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(FALSE)
    col <- .scalar_chr(col, default = "")
    if (!nzchar(col)) return(FALSE)
    md <- tryCatch(sobj@meta.data, error = function(e) NULL)
    if (is.null(md) || !is.data.frame(md) || !col %in% colnames(md)) return(FALSE)
    vals <- as.character(md[[col]])
    vals <- vals[!is.na(vals) & nzchar(vals)]
    length(unique(vals)) > 1L
  }
  .cfg_preview_default_color_by <- function(sobj) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
    preferred <- c(
      "seurat_clusters",
      "sweep_nn_res.0.1", "sweep_nn_res.0.2", "sweep_nn_res.0.3",
      "orig.ident", "sample", "sample_name", "condition", "batch"
    )
    for (nm in preferred) {
      if (.meta_has_multiple_values(sobj, nm)) return(nm)
    }
    cols <- .meta_columns_for_color(sobj)
    for (nm in cols) {
      if (.meta_has_multiple_values(sobj, nm)) return(nm)
    }
    NULL
  }
  .cfg_clustering_reference_color <- function(sobj) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
    md_cols <- tryCatch(colnames(sobj@meta.data), error = function(e) character(0))
    md_cols <- as.character(md_cols %||% character(0))
    md_cols <- md_cols[nzchar(md_cols)]
    if (!length(md_cols)) return(NULL)
    candidates <- c(
      .scalar_chr(input$umap_colorby_rescol, default = ""),
      .scalar_chr(input$umap_colorby, default = "")
    )
    for (cn in candidates) {
      if (nzchar(cn) && cn %in% md_cols && .meta_has_multiple_values(sobj, cn)) return(cn)
    }
    NULL
  }
  .cfg_object_signature <- function(sobj, object_name = NULL) {
    pca_dim <- tryCatch(ncol(Seurat::Embeddings(sobj, "pca")), error = function(e) NA_integer_)
    paste(
      object_name %||% "",
      nrow(sobj@meta.data %||% data.frame()),
      ncol(sobj),
      pca_dim %||% NA_integer_,
      sep = "::"
    )
  }
  .analysis_reduction_signature <- function(sobj, reduction_name = "umap") {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return("")
    red <- .scalar_chr(reduction_name, default = "umap")
    if (!nzchar(red)) red <- "umap"
    emb <- tryCatch(Seurat::Embeddings(sobj, reduction = red), error = function(e) NULL)
    if (is.null(emb) || !is.matrix(emb) || !nrow(emb) || !ncol(emb)) return("")
    misc_sig <- tryCatch(sobj@reductions[[red]]@misc$cfg_signature, error = function(e) NULL)
    n_sample <- min(200L, nrow(emb))
    d_sample <- min(2L, ncol(emb))
    checksum <- suppressWarnings(signif(sum(emb[seq_len(n_sample), seq_len(d_sample), drop = FALSE], na.rm = TRUE), 12))
    paste(
      as.integer(nrow(emb)),
      as.integer(ncol(emb)),
      paste(unlist(misc_sig %||% list()), collapse = "|"),
      as.character(checksum),
      sep = "::"
    )
  }
  .cfg_reduction_for_display <- function(sobj, params = NULL, fallback = "umap") {
    sobj <- sobj %||% NULL
    reds_real <- tryCatch(names(sobj@reductions), error = function(e) character(0))
    reds <- tolower(reds_real)
    if (!length(reds)) return("")
    explicit_red <- tolower(.scalar_chr(params$reduction_name %||% "", default = ""))
    if (nzchar(explicit_red) && explicit_red %in% reds) return(reds_real[[match(explicit_red, reds)]])
    fmt <- toupper(.scalar_chr(params$plot_format %||% "", default = ""))
    prefer <- if (identical(fmt, "TSNE")) "tsne" else if (identical(fmt, "UMAP")) "umap" else ""
    fb <- tolower(.scalar_chr(fallback, default = "umap"))
    if (nzchar(prefer)) {
      prefer_idx <- which(startsWith(reds, prefer))
      if (length(prefer_idx)) return(reds_real[[prefer_idx[[1]]]])
    }
    if (nzchar(fb)) {
      fb_idx <- which(startsWith(reds, fb))
      if (length(fb_idx)) return(reds_real[[fb_idx[[1]]]])
    }
    if (any(startsWith(reds, "umap"))) return(reds_real[[which(startsWith(reds, "umap"))[[1]]]])
    if (any(startsWith(reds, "tsne"))) return(reds_real[[which(startsWith(reds, "tsne"))[[1]]]])
    ""
  }
  .resolution_values <- function(sobj, cache_res = NULL) {
    present_cols <- .find_resolution_columns(sobj)
    present_vals <- if (length(present_cols)) sort(unique(vapply(present_cols, .parse_res_value, numeric(1)))) else numeric()
    unique(sort(c(cache_res %||% numeric(), present_vals)))
  }

  .build_cluster_sweep_summary <- function(sobj, resolutions) {
    ran <- sort(unique(suppressWarnings(as.numeric(resolutions %||% numeric()))))
    ran <- ran[is.finite(ran)]
    if (!length(ran)) {
      return(data.frame(
        resolution = numeric(0),
        colname = character(0),
        n_clusters = integer(0),
        created = logical(0),
        stringsAsFactors = FALSE
      ))
    }
    cols <- .find_resolution_columns(sobj)
    col_vals <- if (length(cols)) suppressWarnings(vapply(cols, .parse_res_value, numeric(1))) else numeric()
    rows <- lapply(ran, function(r) {
      col_use <- NA_character_
      n_clusters <- NA_integer_
      if (length(cols) && any(is.finite(col_vals))) {
        idx <- which.min(abs(col_vals - r))
        if (length(idx) && is.finite(col_vals[idx])) {
          col_use <- cols[[idx]]
          vals <- tryCatch(as.character(sobj@meta.data[[col_use]]), error = function(e) character(0))
          vals <- vals[!is.na(vals) & nzchar(vals)]
          if (length(vals)) n_clusters <- length(unique(vals))
        }
      }
      data.frame(
        resolution = as.numeric(r),
        colname = as.character(col_use %||% NA_character_),
        n_clusters = as.integer(n_clusters %||% NA_integer_),
        created = FALSE,
        stringsAsFactors = FALSE
      )
    })
    do.call(rbind, rows)
  }

  .ensure_cluster_sweep_cache_for_object <- function(nm, sobj = NULL) {
    nm <- .scalar_chr(nm, default = "")
    if (!nzchar(nm)) return(FALSE)
    entry <- shared_data$all_seurat_objects[[nm]]
    if (is.null(sobj)) sobj <- .get_obj_from_entry(entry)
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(FALSE)

    cache <- tryCatch(entry$analysis_cache$cluster_sweep, error = function(e) NULL)
    if (!is.list(cache)) cache <- list()
    cache_res <- suppressWarnings(as.numeric(cache$resolutions %||% numeric()))
    cache_res <- cache_res[is.finite(cache_res)]
    ran <- .resolution_values(sobj, cache_res = cache_res)
    if (!length(ran)) return(FALSE)

    cache$resolutions <- ran
    if (is.null(cache$summary) || !is.data.frame(cache$summary) || !nrow(cache$summary)) {
      cache$summary <- .build_cluster_sweep_summary(sobj, ran)
    }
    if (is.null(cache$dims) || !is.finite(suppressWarnings(as.numeric(cache$dims)))) {
      cache$dims <- .effective_dims(nm = nm, allow_slider_fallback = FALSE)
    }

    if (is.null(shared_data$all_seurat_objects[[nm]]$analysis_cache)) {
      shared_data$all_seurat_objects[[nm]]$analysis_cache <- list()
    }
    shared_data$all_seurat_objects[[nm]]$analysis_cache$cluster_sweep <- cache
    TRUE
  }

  .sort_levels_natural <- function(v) {
    lv <- unique(as.character(v))
    lv[is.na(lv) | !nzchar(lv)] <- "NA"
    if (!length(lv)) return(character())

    tokens <- lapply(lv, function(s) regmatches(s, gregexpr("([0-9]+|[^0-9]+)", s, perl = TRUE))[[1]])
    max_len <- max(lengths(tokens))
    if (!is.finite(max_len) || max_len < 1) {
      return(lv[order(tolower(lv), lv, method = "radix")])
    }

    ord_args <- list()
    for (j in seq_len(max_len)) {
      tok_j <- vapply(tokens, function(tt) if (length(tt) >= j) tt[[j]] else "", character(1))
      is_num <- grepl("^[0-9]+$", tok_j)
      chr_j <- ifelse(is_num, "", tolower(tok_j))
      num_j <- ifelse(is_num, suppressWarnings(as.numeric(tok_j)), Inf)
      ord_args <- c(ord_args, list(chr_j, num_j))
    }
    ord <- do.call(order, c(ord_args, list(method = "radix", na.last = TRUE)))
    lv[ord]
  }

  .normalize_reduction_keys <- function(sobj) {
    reds <- tryCatch(names(sobj@reductions), error = function(e) character())
    if (!length(reds)) return(sobj)

    used_keys <- character()
    for (nm in reds) {
      red <- tryCatch(sobj@reductions[[nm]], error = function(e) NULL)
      if (is.null(red)) next

      key_now <- tryCatch(red@key, error = function(e) "")
      key_now <- as.character(key_now %||% "")
      key_lc <- tolower(key_now)
      nm_lc <- tolower(nm)

      preferred <- if (identical(nm_lc, "umap")) {
        "UMAP_"
      } else if (identical(nm_lc, "umap_cfg")) {
        "umapcfg_"
      } else if (identical(nm_lc, "umap3d")) {
        "UMAP3D_"
      } else if (identical(nm_lc, "tsne")) {
        "tSNE_"
      } else if (identical(nm_lc, "tsne_cfg")) {
        "tsnecfg_"
      } else if (startsWith(key_lc, "umcfg_")) {
        "umapcfg_"
      } else if (startsWith(key_lc, "umap_cfg_")) {
        "umapcfg_"
      } else if (startsWith(key_lc, "tscfg_")) {
        "tsnecfg_"
      } else if (startsWith(key_lc, "tsne_cfg_")) {
        "tsnecfg_"
      } else {
        key_now
      }

      if (!nzchar(preferred)) preferred <- paste0(gsub("[^A-Za-z0-9]+", "", nm), "_")
      key_use <- preferred
      if (key_use %in% used_keys) key_use <- paste0(gsub("[^A-Za-z0-9]+", "_", nm), "_")
      if (key_use %in% used_keys) key_use <- paste0(gsub("[^A-Za-z0-9]+", "_", nm), "_", match(nm, reds), "_")

      if (!identical(key_now, key_use)) {
        try(red@key <- key_use, silent = TRUE)
        try(sobj@reductions[[nm]] <- red, silent = TRUE)
      }
      used_keys <- c(used_keys, key_use)
    }
    sobj
  }

  .sanitize_export_stem <- function(x, fallback = "umap3d_interactive") {
    stem <- trimws(as.character(x %||% ""))
    stem <- gsub("\\.[A-Za-z0-9]+$", "", stem)
    stem <- gsub("[^A-Za-z0-9._-]+", "_", stem)
    stem <- gsub("_+", "_", stem)
    stem <- gsub("^_+|_+$", "", stem)
    if (!nzchar(stem)) stem <- fallback
    stem
  }

  .ensure_umap3d <- function(
    sobj,
    dims = 30L,
    seed = 42L,
    umap_neighbors = 30L,
    umap_min_dist = 0.30,
    umap_spread = 1.0
  ) {
    sobj <- .normalize_reduction_keys(sobj)
    reds <- tolower(tryCatch(names(sobj@reductions), error = function(e) character()))

    if (!"pca" %in% reds) {
      sobj <- tryCatch(Seurat::RunPCA(sobj, npcs = 50, verbose = FALSE), error = function(e) sobj)
    }
    pca_emb <- tryCatch(Seurat::Embeddings(sobj, "pca"), error = function(e) NULL)
    if (is.null(pca_emb) || !is.matrix(pca_emb) || ncol(pca_emb) < 2) {
      return(list(object = sobj, error = "PCA embeddings are unavailable for 3D UMAP.", created = FALSE))
    }

    dims_use <- suppressWarnings(as.integer(dims))
    if (!is.finite(dims_use) || is.na(dims_use) || dims_use < 2L) dims_use <- min(30L, ncol(pca_emb))
    dims_use <- min(dims_use, ncol(pca_emb))
    seed_use <- suppressWarnings(as.integer(seed))
    if (!is.finite(seed_use) || is.na(seed_use) || seed_use < 1L) seed_use <- 42L

    neigh_use <- suppressWarnings(as.integer(umap_neighbors))
    if (!is.finite(neigh_use) || is.na(neigh_use) || neigh_use < 2L) neigh_use <- 30L
    min_dist_use <- suppressWarnings(as.numeric(umap_min_dist))
    if (!is.finite(min_dist_use) || is.na(min_dist_use) || min_dist_use <= 0) min_dist_use <- 0.30
    spread_use <- suppressWarnings(as.numeric(umap_spread))
    if (!is.finite(spread_use) || is.na(spread_use) || spread_use <= 0) spread_use <- 1.0

    sig <- list(
      dims = dims_use,
      seed = seed_use,
      umap_neighbors = neigh_use,
      umap_min_dist = min_dist_use,
      umap_spread = spread_use
    )
    if ("umap3d" %in% reds) {
      old_sig <- tryCatch(sobj@reductions[["umap3d"]]@misc$cfg_signature, error = function(e) NULL)
      if (isTRUE(identical(old_sig, sig))) {
        return(list(object = sobj, error = NULL, created = FALSE))
      }
    }

    obj3d <- tryCatch(
      Seurat::RunUMAP(
        sobj,
        reduction = "pca",
        dims = seq_len(dims_use),
        n.components = 3L,
        reduction.name = "umap3d",
        reduction.key = "UMAP3D_",
        n.neighbors = neigh_use,
        min.dist = min_dist_use,
        spread = spread_use,
        seed.use = seed_use,
        verbose = FALSE
      ),
      error = function(e) {
        message("[3D UMAP] RunUMAP error: ", conditionMessage(e))
        list(object = sobj, error = conditionMessage(e), created = FALSE)
      }
    )
    if (is.list(obj3d) && !inherits(obj3d, "Seurat")) return(obj3d)
    try(obj3d@reductions[["umap3d"]]@misc$cfg_signature <- sig, silent = TRUE)
    list(object = obj3d, error = NULL, created = TRUE)
  }

  .ensure_tsne3d <- function(
    sobj,
    dims = 30L,
    seed = 42L,
    tsne_perplexity = 30,
    tsne_theta = 0.5,
    tsne_eta = 200,
    tsne_iter = 1000L
  ) {
    sobj <- .normalize_reduction_keys(sobj)
    reds <- tolower(tryCatch(names(sobj@reductions), error = function(e) character()))

    if (!"pca" %in% reds) {
      sobj <- tryCatch(Seurat::RunPCA(sobj, npcs = 50, verbose = FALSE), error = function(e) sobj)
    }
    pca_emb <- tryCatch(Seurat::Embeddings(sobj, "pca"), error = function(e) NULL)
    if (is.null(pca_emb) || !is.matrix(pca_emb) || ncol(pca_emb) < 2) {
      return(list(object = sobj, error = "PCA embeddings are unavailable for 3D tSNE.", created = FALSE))
    }

    dims_use <- suppressWarnings(as.integer(dims))
    if (!is.finite(dims_use) || is.na(dims_use) || dims_use < 2L) dims_use <- min(30L, ncol(pca_emb))
    dims_use <- min(dims_use, ncol(pca_emb))
    seed_use <- suppressWarnings(as.integer(seed))
    if (!is.finite(seed_use) || is.na(seed_use) || seed_use < 1L) seed_use <- 42L
    perplexity_use <- suppressWarnings(as.numeric(tsne_perplexity))
    if (!is.finite(perplexity_use) || is.na(perplexity_use) || perplexity_use <= 0) perplexity_use <- 30
    theta_use <- suppressWarnings(as.numeric(tsne_theta))
    if (!is.finite(theta_use) || is.na(theta_use) || theta_use < 0) theta_use <- 0.5
    eta_use <- suppressWarnings(as.numeric(tsne_eta))
    if (!is.finite(eta_use) || is.na(eta_use) || eta_use <= 0) eta_use <- 200
    iter_use <- suppressWarnings(as.integer(tsne_iter))
    if (!is.finite(iter_use) || is.na(iter_use) || iter_use < 250L) iter_use <- 1000L

    sig <- list(
      dims = dims_use,
      seed = seed_use,
      tsne_perplexity = perplexity_use,
      tsne_theta = theta_use,
      tsne_eta = eta_use,
      tsne_iter = iter_use
    )
    if ("tsne3d" %in% reds) {
      old_sig <- tryCatch(sobj@reductions[["tsne3d"]]@misc$cfg_signature, error = function(e) NULL)
      if (isTRUE(identical(old_sig, sig))) {
        return(list(object = sobj, error = NULL, created = FALSE))
      }
    }

    obj3d <- tryCatch(
      Seurat::RunTSNE(
        sobj,
        reduction = "pca",
        dims = seq_len(dims_use),
        dim.embed = 3L,
        reduction.name = "tsne3d",
        reduction.key = "tSNE3D_",
        seed.use = seed_use,
        perplexity = perplexity_use,
        theta = theta_use,
        eta = eta_use,
        max_iter = iter_use,
        check_duplicates = FALSE,
        verbose = FALSE
      ),
      error = function(e) {
        message("[3D tSNE] RunTSNE error: ", conditionMessage(e))
        list(object = sobj, error = conditionMessage(e), created = FALSE)
      }
    )
    if (is.list(obj3d) && !inherits(obj3d, "Seurat")) return(obj3d)
    try(obj3d@reductions[["tsne3d"]]@misc$cfg_signature <- sig, silent = TRUE)
    list(object = obj3d, error = NULL, created = TRUE)
  }

  .build_umap3d_plot <- function(df, color_by, point_size = 1.2, alpha = 0.85, title = "3D UMAP", seurat_obj = NULL, axis_prefix = "UMAP") {
    if (!is.data.frame(df) || nrow(df) == 0) stop("No cells available for 3D UMAP.")
    if (!color_by %in% colnames(df)) stop("Selected color column is unavailable.")
    if (!all(c("UMAP_1", "UMAP_2", "UMAP_3") %in% colnames(df))) {
      stop("3D UMAP coordinate columns are missing.")
    }

    point_size <- suppressWarnings(as.numeric(point_size))
    if (!is.finite(point_size) || is.na(point_size) || point_size <= 0) point_size <- 1.2
    alpha <- suppressWarnings(as.numeric(alpha))
    if (!is.finite(alpha) || is.na(alpha) || alpha <= 0) alpha <- 0.85

    df <- df[, unique(c("cell_id", "UMAP_1", "UMAP_2", "UMAP_3", color_by)), drop = FALSE]
    df$UMAP_1 <- suppressWarnings(as.numeric(df$UMAP_1))
    df$UMAP_2 <- suppressWarnings(as.numeric(df$UMAP_2))
    df$UMAP_3 <- suppressWarnings(as.numeric(df$UMAP_3))
    keep <- is.finite(df$UMAP_1) & is.finite(df$UMAP_2) & is.finite(df$UMAP_3)
    df <- df[keep, , drop = FALSE]
    if (!nrow(df)) stop("3D UMAP coordinates are all non-finite.")

    raw_vals <- df[[color_by]]
    cluster_like <- .is_cluster_like_metadata(color_by, raw_vals)
    is_continuous <- .is_effectively_numeric(raw_vals) && !isTRUE(cluster_like)
    vals <- as.character(raw_vals)
    vals[is.na(vals) | !nzchar(vals)] <- "NA"
    lv <- .sort_levels_natural(vals)

    .seurat_discrete_palette <- function(n) {
      n <- as.integer(n %||% 0L)
      if (!is.finite(n) || n < 1L) return(character())
      fn <- tryCatch(getFromNamespace("DiscretePalette", "Seurat"), error = function(e) NULL)
      pal <- NULL
      if (is.function(fn)) pal <- tryCatch(suppressWarnings(fn(n)), error = function(e) NULL)
      if (is.null(pal) || length(pal) < n) {
        pal <- grDevices::hcl.colors(max(n, 3L), palette = "Dark 3")[seq_len(n)]
      } else {
        pal <- as.character(pal)[seq_len(n)]
      }
      pal
    }

    pal <- .palette_for_metadata_levels(
      sobj = seurat_obj,
      reduction_name = "umap",
      color_col = color_by,
      levels_vec = lv
    )
    if (!length(pal)) pal <- grDevices::hcl.colors(max(length(lv), 3L), palette = "Dark 3")[seq_along(lv)]

    if (isTRUE(is_continuous)) {
      num_vals <- suppressWarnings(as.numeric(as.character(raw_vals)))
      keep_num <- is.finite(num_vals)
      p <- plotly::plot_ly(type = "scatter3d", mode = "markers")
      if (any(keep_num)) {
        p <- plotly::add_trace(
          p,
          data = df[keep_num, , drop = FALSE],
          x = ~UMAP_1,
          y = ~UMAP_2,
          z = ~UMAP_3,
          text = ~cell_id,
          type = "scatter3d",
          mode = "markers",
          name = color_by,
          showlegend = FALSE,
          marker = list(
            size = point_size,
            opacity = alpha,
            color = num_vals[keep_num],
            colorscale = "Viridis",
            showscale = TRUE,
            colorbar = list(title = color_by)
          ),
          hovertemplate = paste0(
            "Cell: %{text}<br>",
            color_by, ": %{marker.color:.4g}",
            "<br>", axis_prefix, "_1: %{x:.3f}<br>", axis_prefix, "_2: %{y:.3f}<br>", axis_prefix, "_3: %{z:.3f}<extra></extra>"
          )
        )
      }
      if (any(!keep_num)) {
        p <- plotly::add_trace(
          p,
          data = df[!keep_num, , drop = FALSE],
          x = ~UMAP_1,
          y = ~UMAP_2,
          z = ~UMAP_3,
          text = ~cell_id,
          type = "scatter3d",
          mode = "markers",
          name = "NA",
          showlegend = TRUE,
          marker = list(size = point_size, opacity = alpha, color = "#9CA3AF"),
          hovertemplate = paste0(
            "Cell: %{text}<br>",
            color_by, ": NA",
            "<br>", axis_prefix, "_1: %{x:.3f}<br>", axis_prefix, "_2: %{y:.3f}<br>", axis_prefix, "_3: %{z:.3f}<extra></extra>"
          )
        )
      }
      return(
        p |>
          plotly::layout(
            title = list(text = title),
            legend = list(
              orientation = "v",
              itemsizing = "trace",
              x = 0.99,
              xanchor = "right",
              y = 0.99,
              yanchor = "top"
            ),
            scene = list(
              xaxis = list(title = paste0(axis_prefix, "_1")),
              yaxis = list(title = paste0(axis_prefix, "_2")),
              zaxis = list(title = paste0(axis_prefix, "_3")),
              aspectmode = "data"
            ),
            margin = list(l = 0, r = 16, b = 0, t = 40)
          ) |>
          plotly::config(displaylogo = FALSE, responsive = TRUE)
      )
    }

    p <- plotly::plot_ly(type = "scatter3d", mode = "markers")
    legend_marker_size <- 12
    for (i in seq_along(lv)) {
      idx <- which(vals == lv[i])
      if (!length(idx)) next
      p <- plotly::add_trace(
        p,
        data = df[idx, , drop = FALSE],
        x = ~UMAP_1,
        y = ~UMAP_2,
        z = ~UMAP_3,
        text = ~cell_id,
        type = "scatter3d",
        mode = "markers",
        name = lv[i],
        showlegend = FALSE,
        marker = list(size = point_size, opacity = alpha, color = pal[i]),
        hovertemplate = paste0(
          "Cell: %{text}<br>",
          color_by, ": ", lv[i],
          "<br>", axis_prefix, "_1: %{x:.3f}<br>", axis_prefix, "_2: %{y:.3f}<br>", axis_prefix, "_3: %{z:.3f}<extra></extra>"
        )
      )
      # Dedicated legend trace keeps legend swatches readable without enlarging points in the plot.
      p <- plotly::add_trace(
        p,
        x = 0,
        y = 0,
        z = 0,
        type = "scatter3d",
        mode = "markers",
        name = lv[i],
        hoverinfo = "skip",
        showlegend = TRUE,
        visible = "legendonly",
        marker = list(size = legend_marker_size, opacity = 1, color = pal[i])
      )
    }

    p |>
      plotly::layout(
        title = list(text = title),
        legend = list(
          orientation = "v",
          itemsizing = "trace",
          x = 0.99,
          xanchor = "right",
          y = 0.99,
          yanchor = "top"
        ),
        scene = list(
          xaxis = list(title = paste0(axis_prefix, "_1")),
          yaxis = list(title = paste0(axis_prefix, "_2")),
          zaxis = list(title = paste0(axis_prefix, "_3")),
          aspectmode = "data"
        ),
        margin = list(l = 0, r = 16, b = 0, t = 40)
      ) |>
      plotly::config(displaylogo = FALSE, responsive = TRUE)
  }

  .attach_umap3d_gl_diag <- function(widget, input_id = "umap3d_gl_diag") {
    htmlwidgets::onRender(
      widget,
      sprintf(
        "
function(el, x) {
  if (!el) return;
  function report(status, detail) {
    if (!window.Shiny || !Shiny.setInputValue) return;
    try {
      Shiny.setInputValue('%s', {
        status: status,
        detail: detail || '',
        traces: (x && x.data && x.data.length) ? x.data.length : 0,
        ts: Date.now()
      }, {priority: 'event'});
    } catch (e) {}
  }
  function checkCanvas() {
    try {
      var cv = el.querySelector('.gl-container canvas');
      if (!cv) {
        report('no_webgl_canvas', 'Plotly scene exists but no WebGL canvas was created');
      } else {
        report('ok', '');
      }
    } catch (e) {
      report('diag_error', String(e && e.message ? e.message : e));
    }
  }
  setTimeout(checkCanvas, 0);
  setTimeout(checkCanvas, 250);
  setTimeout(function() {
    try {
      if (window.Plotly && Plotly.Plots && typeof Plotly.Plots.resize === 'function') {
        Plotly.Plots.resize(el);
      }
      if (window.Plotly && typeof Plotly.redraw === 'function') {
        Plotly.redraw(el);
      }
    } catch (e) {}
  }, 80);
  setTimeout(function() {
    try {
      if (window.Plotly && Plotly.Plots && typeof Plotly.Plots.resize === 'function') {
        Plotly.Plots.resize(el);
      }
    } catch (e) {}
  }, 320);
  if (el.on) {
    el.on('plotly_webglcontextlost', function() {
      report('webgl_context_lost', 'plotly_webglcontextlost');
    });
    el.on('plotly_afterplot', function() {
      checkCanvas();
    });
  }
}
",
        input_id
      )
    )
  }

  .build_embedding_preview_plot <- function(sobj, reduction_name, color_by = NULL, split_by = NULL, split_by_secondary = NULL, plot_format = "UMAP", container_width = NULL, dot_size = 0.85) {
    emb <- tryCatch(Seurat::Embeddings(sobj, reduction_name), error = function(e) NULL)
    validate(need(!is.null(emb) && is.matrix(emb) && ncol(emb) >= 2, "Embedding preview unavailable."))

    axis_prefix <- .reduction_pca_dims_label(sobj, reduction_name)
    if (!nzchar(axis_prefix)) {
      axis_prefix <- if (identical(toupper(as.character(plot_format %||% "UMAP")), "TSNE")) "TSNE_PCA" else "UMAP_PCA"
    }
    x_title <- paste0(axis_prefix, "_1")
    y_title <- paste0(axis_prefix, "_2")
    cell_ids <- rownames(emb)
    md <- sobj@meta.data
    validate(need(all(cell_ids %in% rownames(md)), "Cell metadata mismatch for embedding preview."))

    df <- data.frame(
      cell_id = cell_ids,
      dim1 = as.numeric(emb[, 1]),
      dim2 = as.numeric(emb[, 2]),
      stringsAsFactors = FALSE,
      check.names = FALSE
    )

    color_col <- .safe_meta_col(md, color_by)
    color_label <- color_col %||% "ident"
    if (is.null(color_col)) {
      raw_vals <- as.character(Seurat::Idents(sobj))
      color_col <- ".ident"
      color_label <- "ident"
    } else {
      raw_vals <- md[cell_ids, color_col, drop = TRUE]
    }
    num_try <- suppressWarnings(as.numeric(raw_vals))
    finite_n <- sum(is.finite(num_try))
    color_is_numeric <- !is.null(color_by) && !is.null(color_col) && finite_n > 0 && finite_n >= max(5L, as.integer(length(num_try) * 0.5))
    if (isTRUE(color_is_numeric)) {
      df$color_numeric <- as.numeric(num_try)
      color_label <- if (identical(color_col, "cw_active_score")) "CellWhisperer score" else color_col
    } else {
      vals <- as.character(raw_vals)
      vals[is.na(vals) | !nzchar(vals)] <- "NA"
      vals <- .zero_base_labels_if_needed(vals, color_col)
      df$color_value <- vals
    }

    split_col <- .safe_meta_col(md, split_by)
    if (is.null(split_col)) {
      df$split_value <- "All cells"
    } else {
      sp <- as.character(md[cell_ids, split_col, drop = TRUE])
      sp[is.na(sp) | !nzchar(sp)] <- "NA"
      sp <- .zero_base_labels_if_needed(sp, split_col)
      df$split_value <- sp
    }

    split_col_secondary <- .safe_meta_col(md, split_by_secondary)
    if (!is.null(split_col_secondary) && identical(split_col_secondary, split_col)) split_col_secondary <- NULL
    if (is.null(split_col_secondary)) {
      df$split_value_secondary <- "All cells"
    } else {
      sp2 <- as.character(md[cell_ids, split_col_secondary, drop = TRUE])
      sp2[is.na(sp2) | !nzchar(sp2)] <- "NA"
      sp2 <- .zero_base_labels_if_needed(sp2, split_col_secondary)
      df$split_value_secondary <- sp2
    }

    lv <- character(0)
    pal <- character(0)
    if (!isTRUE(color_is_numeric)) {
      lv <- .sort_levels_natural(df$color_value)
      pal <- .palette_for_metadata_levels(
        sobj = sobj,
        reduction_name = reduction_name,
        color_col = color_col,
        levels_vec = lv
      )
    }

    split_levels_raw <- .sort_facet_levels(df$split_value)
    split_levels_secondary_raw <- .sort_facet_levels(df$split_value_secondary)
    split_map <- setNames(split_levels_raw, split_levels_raw)
    split_map_secondary <- setNames(split_levels_secondary_raw, split_levels_secondary_raw)
    if (!is.null(split_col) && identical(split_col, "orig.ident")) {
      split_map <- .smart_short_labels(split_levels_raw, column_name = split_col, keep_prefix_tokens = 1L)
    }
    if (!is.null(split_col_secondary) && identical(split_col_secondary, "orig.ident")) {
      split_map_secondary <- .smart_short_labels(split_levels_secondary_raw, column_name = split_col_secondary, keep_prefix_tokens = 1L)
    }
    split_levels <- unname(split_map[split_levels_raw])
    split_levels_secondary <- unname(split_map_secondary[split_levels_secondary_raw])
    df$split_value <- factor(unname(split_map[df$split_value]), levels = split_levels)
    df$split_value_secondary <- factor(unname(split_map_secondary[df$split_value_secondary]), levels = split_levels_secondary)
    if (!isTRUE(color_is_numeric)) {
      df$color_value <- factor(df$color_value, levels = lv)
    }

    layout_spec <- .embedding_preview_layout(
      width_px = container_width %||% 1050,
      col_levels = split_levels,
      row_levels = split_levels_secondary
    )
    dot_size <- suppressWarnings(as.numeric(dot_size))
    if (!is.finite(dot_size) || is.na(dot_size) || dot_size <= 0) dot_size <- 0.85

    xr <- range(df$dim1, finite = TRUE)
    yr <- range(df$dim2, finite = TRUE)
    x_span <- diff(xr)
    y_span <- diff(yr)
    if (!is.finite(x_span) || x_span <= 0) x_span <- max(abs(xr), 1)
    if (!is.finite(y_span) || y_span <= 0) y_span <- max(abs(yr), 1)
    square_span <- max(x_span, y_span) * 1.08
    x_mid <- mean(xr)
    y_mid <- mean(yr)
    half_span <- square_span / 2
    x_range <- c(x_mid - half_span, x_mid + half_span)
    y_range <- c(y_mid - half_span, y_mid + half_span)

    container_w <- as.numeric(container_width %||% 1050)
    if (!is.finite(container_w) || is.na(container_w) || container_w <= 0) container_w <- 1050
    p <- if (isTRUE(color_is_numeric)) {
      ggplot2::ggplot(df, ggplot2::aes(dim1, dim2, color = color_numeric)) +
        ggplot2::geom_point(size = dot_size, alpha = 0.8) +
        ggplot2::scale_color_gradientn(
          colors = c("#2b8cbe", "#a1dab4", "#fee08b", "#f46d43", "#d7301f"),
          na.value = "#bdbdbd"
        )
    } else {
      # Guard legend from horizontal overflow with explicit left/right gutters.
      legend_usable_w <- max(280, container_w - 260)
      lv_nchar <- nchar(as.character(lv %||% character(0)))
      if (!length(lv_nchar)) lv_nchar <- 10L
      label_nchar_p90 <- as.numeric(stats::quantile(lv_nchar, probs = 0.90, na.rm = TRUE, type = 7))
      if (!is.finite(label_nchar_p90) || is.na(label_nchar_p90) || label_nchar_p90 < 4) label_nchar_p90 <- 10
      # Dot + gap + average label width in pixels (clamped for stability across devices).
      legend_item_px <- max(82, min(220, 28 + 7.0 * label_nchar_p90))
      items_per_row <- max(2L, min(12L, floor(legend_usable_w / legend_item_px)))
      legend_rows <- max(1L, ceiling(length(lv) / max(1L, items_per_row)))
      ggplot2::ggplot(df, ggplot2::aes(dim1, dim2, color = color_value)) +
        ggplot2::geom_point(size = dot_size, alpha = 0.8) +
        ggplot2::scale_color_manual(values = pal, drop = FALSE) +
        ggplot2::guides(
          color = ggplot2::guide_legend(
            ncol = max(1L, items_per_row),
            nrow = legend_rows,
            byrow = TRUE,
            override.aes = list(size = .umap_legend_dot_size(dot_size, 10), alpha = 1)
          ),
          colour = ggplot2::guide_legend(
            ncol = max(1L, items_per_row),
            nrow = legend_rows,
            byrow = TRUE,
            override.aes = list(size = .umap_legend_dot_size(dot_size, 10), alpha = 1)
          )
        )
    }
    p <- p +
      ggplot2::coord_fixed(xlim = x_range, ylim = y_range, expand = FALSE) +
      ggplot2::labs(x = x_title, y = y_title, color = color_label) +
      ggplot2::theme_classic(base_size = 12) +
      ggplot2::theme(
        plot.margin = ggplot2::margin(8, 24, 8, 24),
        legend.position = "top",
        legend.justification = "center",
        legend.direction = "horizontal",
        legend.box = "horizontal",
        legend.title = ggplot2::element_text(face = "bold", hjust = 0.5),
        strip.background = ggplot2::element_blank(),
        strip.background.x = ggplot2::element_blank(),
        strip.background.y = ggplot2::element_blank(),
        strip.placement = "outside",
        strip.text.x = ggplot2::element_text(face = "bold", size = layout_spec$col_font, angle = layout_spec$col_angle, hjust = if (layout_spec$col_angle == 0) 0.5 else 0, vjust = if (layout_spec$col_angle == 0) 0.5 else 1),
        strip.text.y = ggplot2::element_text(face = "bold", size = layout_spec$row_font, angle = 0),
        strip.text.y.left = ggplot2::element_text(face = "bold", size = layout_spec$row_font, angle = 0),
        strip.text.y.right = ggplot2::element_text(face = "bold", size = layout_spec$row_font, angle = 0),
        panel.grid.major = ggplot2::element_blank(),
        panel.grid.minor = ggplot2::element_blank(),
        axis.line = ggplot2::element_line(color = "#2f2f2f", linewidth = 0.45, linetype = "solid"),
        axis.line.x = ggplot2::element_line(color = "#2f2f2f", linewidth = 0.45, linetype = "solid"),
        axis.line.y = ggplot2::element_line(color = "#2f2f2f", linewidth = 0.45, linetype = "solid"),
        legend.key = ggplot2::element_blank(),
        legend.text = ggplot2::element_text(size = 10),
        legend.title.position = "top",
        legend.box.margin = ggplot2::margin(2, 10, 0, 10),
        legend.margin = ggplot2::margin(0, 8, 0, 8),
        legend.spacing.x = grid::unit(4, "pt"),
        panel.spacing.x = grid::unit(0.8, "lines"),
        panel.spacing.y = grid::unit(0.8, "lines")
      )

    has_col_facet <- length(split_levels) > 1L || !identical(split_levels[[1]], "All cells")
    has_row_facet <- length(split_levels_secondary) > 1L || !identical(split_levels_secondary[[1]], "All cells")
    if (has_col_facet && has_row_facet) {
      p <- p + ggplot2::facet_grid(rows = ggplot2::vars(split_value_secondary), cols = ggplot2::vars(split_value), drop = FALSE)
    } else if (has_col_facet) {
      p <- p + ggplot2::facet_wrap(ggplot2::vars(split_value), nrow = 1, drop = FALSE)
    } else if (has_row_facet) {
      p <- p + ggplot2::facet_wrap(ggplot2::vars(split_value_secondary), ncol = 1, drop = FALSE)
    }

    p
  }

  .choose_frequency_group <- function(split_col, sp, split_col_secondary, sp2, mode = "auto") {
    mode <- tolower(as.character(mode %||% "auto"))
    n_col <- length(unique(as.character(sp %||% "All cells")))
    n_row <- length(unique(as.character(sp2 %||% "All cells")))
    has_col <- !is.null(split_col) && n_col > 1L
    has_row <- !is.null(split_col_secondary) && n_row > 1L

    # both split dimensions exist: choose which one is "outer" (facet group) vs "inner" (bars within group)
    if (has_col && has_row) {
      if (identical(mode, "row")) {
        return(list(outer_var = "split_value_secondary", outer_label = split_col_secondary, outer_n = n_row,
                    inner_var = "split_value", inner_label = split_col, inner_n = n_col))
      }
      return(list(outer_var = "split_value", outer_label = split_col, outer_n = n_col,
                  inner_var = "split_value_secondary", inner_label = split_col_secondary, inner_n = n_row))
    }

    # single split dimension available: keep one panel and use that split as bars.
    if (identical(mode, "column")) {
      if (has_col) return(list(outer_var = ".all", outer_label = "All cells", outer_n = 1L,
                               inner_var = "split_value", inner_label = split_col, inner_n = n_col))
      return(list(outer_var = ".all", outer_label = "All cells", outer_n = 1L,
                  inner_var = ".all", inner_label = "All cells", inner_n = 1L))
    }
    if (identical(mode, "row")) {
      if (has_row) return(list(outer_var = ".all", outer_label = "All cells", outer_n = 1L,
                               inner_var = "split_value_secondary", inner_label = split_col_secondary, inner_n = n_row))
      return(list(outer_var = ".all", outer_label = "All cells", outer_n = 1L,
                  inner_var = ".all", inner_label = "All cells", inner_n = 1L))
    }
    if (has_col) return(list(outer_var = ".all", outer_label = "All cells", outer_n = 1L,
                             inner_var = "split_value", inner_label = split_col, inner_n = n_col))
    if (has_row) return(list(outer_var = ".all", outer_label = "All cells", outer_n = 1L,
                             inner_var = "split_value_secondary", inner_label = split_col_secondary, inner_n = n_row))
    list(outer_var = ".all", outer_label = "All cells", outer_n = 1L,
         inner_var = ".all", inner_label = "All cells", inner_n = 1L)
  }

  .umap_cluster_freq_layout_metrics <- function(sobj_plot, color_by = NULL, split_by = NULL, split_by_secondary = NULL, freq_group_by = "auto", container_width = NULL) {
    md <- tryCatch(sobj_plot@meta.data, error = function(e) NULL)
    validate(need(!is.null(md) && is.data.frame(md), "Cell metadata is unavailable."))

    color_col <- .safe_meta_col(md, color_by)
    vals <- if (is.null(color_col)) {
      as.character(tryCatch(Seurat::Idents(sobj_plot), error = function(e) character()))
    } else {
      as.character(md[[color_col]])
    }
    vals[is.na(vals) | !nzchar(vals)] <- "NA"
    vals <- .zero_base_labels_if_needed(vals, if (is.null(color_col)) ".ident" else color_col)
    cluster_count <- max(1L, length(.sort_levels_natural(vals)))

    split_col <- .safe_meta_col(md, split_by)
    split_col2 <- .safe_meta_col(md, split_by_secondary)
    if (!is.null(split_col2) && identical(split_col2, split_col)) split_col2 <- NULL

    vv <- "All cells"
    if (!is.null(split_col) && split_col %in% colnames(md)) {
      vv <- as.character(md[[split_col]])
      vv[is.na(vv) | !nzchar(vv)] <- "NA"
      vv <- .zero_base_labels_if_needed(vv, split_col)
      if (identical(split_col, "orig.ident")) {
        lv <- .sort_facet_levels(vv)
        vv <- unname(.smart_short_labels(lv, column_name = split_col, keep_prefix_tokens = 1L)[vv])
      }
    }

    vv2 <- "All cells"
    if (!is.null(split_col2) && split_col2 %in% colnames(md)) {
      vv2 <- as.character(md[[split_col2]])
      vv2[is.na(vv2) | !nzchar(vv2)] <- "NA"
      vv2 <- .zero_base_labels_if_needed(vv2, split_col2)
      if (identical(split_col2, "orig.ident")) {
        lv2 <- .sort_facet_levels(vv2)
        vv2 <- unname(.smart_short_labels(lv2, column_name = split_col2, keep_prefix_tokens = 1L)[vv2])
      }
    }

    grp <- .choose_frequency_group(split_col, vv, split_col2, vv2, mode = freq_group_by)
    width_px <- suppressWarnings(as.numeric(container_width %||% 1050))
    if (!is.finite(width_px) || width_px <= 0) width_px <- 1050

    list(
      cluster_count = cluster_count,
      outer_n = max(1L, as.integer(grp$outer_n %||% 1L)),
      inner_n = max(1L, as.integer(grp$inner_n %||% 1L)),
      width_px = width_px,
      height_px = analysis_umap_frequency_plot_height_px(
        cluster_count = cluster_count,
        container_width = width_px,
        outer_n = grp$outer_n %||% 1L,
        inner_n = grp$inner_n %||% 1L
      )
    )
  }

  .build_embedding_cluster_freq_plot <- function(sobj, reduction_name, color_by = NULL, split_by = NULL, split_by_secondary = NULL, container_width = NULL, freq_group_by = "auto") {
    emb <- tryCatch(Seurat::Embeddings(sobj, reduction_name), error = function(e) NULL)
    validate(need(!is.null(emb) && is.matrix(emb) && ncol(emb) >= 2, "Embedding preview unavailable."))
    md <- sobj@meta.data
    validate(need(!is.null(md) && is.data.frame(md), "Cell metadata is unavailable."))
    cell_ids <- rownames(emb)
    validate(need(all(cell_ids %in% rownames(md)), "Cell metadata mismatch for embedding preview."))

    color_col <- .safe_meta_col(md, color_by)
    if (is.null(color_col)) {
      vals <- as.character(Seurat::Idents(sobj))
      color_col <- ".ident"
    } else {
      vals <- as.character(md[cell_ids, color_col, drop = TRUE])
    }
    vals[is.na(vals) | !nzchar(vals)] <- "NA"
    vals <- .zero_base_labels_if_needed(vals, color_col)

    split_col <- .safe_meta_col(md, split_by)
    split_col_secondary <- .safe_meta_col(md, split_by_secondary)
    if (!is.null(split_col_secondary) && identical(split_col_secondary, split_col)) split_col_secondary <- NULL

    sp <- rep("All cells", length(cell_ids))
    if (!is.null(split_col)) {
      sp <- as.character(md[cell_ids, split_col, drop = TRUE])
      sp[is.na(sp) | !nzchar(sp)] <- "NA"
      sp <- .zero_base_labels_if_needed(sp, split_col)
      if (identical(split_col, "orig.ident")) {
        lv <- .sort_facet_levels(sp)
        map <- .smart_short_labels(lv, column_name = split_col, keep_prefix_tokens = 1L)
        sp <- unname(map[sp])
      }
    }

    sp2 <- rep("All cells", length(cell_ids))
    if (!is.null(split_col_secondary)) {
      sp2 <- as.character(md[cell_ids, split_col_secondary, drop = TRUE])
      sp2[is.na(sp2) | !nzchar(sp2)] <- "NA"
      sp2 <- .zero_base_labels_if_needed(sp2, split_col_secondary)
      if (identical(split_col_secondary, "orig.ident")) {
        lv2 <- .sort_facet_levels(sp2)
        map2 <- .smart_short_labels(lv2, column_name = split_col_secondary, keep_prefix_tokens = 1L)
        sp2 <- unname(map2[sp2])
      }
    }

    lv_color <- .sort_levels_natural(vals)
    pal <- .palette_for_metadata_levels(
      sobj = sobj,
      reduction_name = reduction_name,
      color_col = color_col,
      levels_vec = lv_color
    )

    df <- data.frame(
      color_value = vals,
      split_value = sp,
      split_value_secondary = sp2,
      stringsAsFactors = FALSE
    )

    grp <- .choose_frequency_group(
      split_col = split_col,
      sp = df$split_value,
      split_col_secondary = split_col_secondary,
      sp2 = df$split_value_secondary,
      mode = freq_group_by
    )
    if (identical(grp$outer_var, ".all")) df$.outer <- "All cells" else df$.outer <- df[[grp$outer_var]]
    if (identical(grp$inner_var, ".all")) df$.inner <- "All cells" else df$.inner <- df[[grp$inner_var]]

    freq <- as.data.frame(table(outer = df$.outer, inner = df$.inner, cluster = df$color_value), stringsAsFactors = FALSE)
    names(freq) <- c("outer", "inner", "cluster", "n")
    freq <- freq[freq$n > 0, , drop = FALSE]
    validate(need(nrow(freq) > 0, "No cells available for frequency plot."))

    totals <- stats::aggregate(n ~ outer + inner, data = freq, FUN = sum)
    names(totals)[3] <- "total"
    freq <- merge(freq, totals, by = c("outer", "inner"), all.x = TRUE, sort = FALSE)
    freq$pct <- ifelse(freq$total > 0, freq$n / freq$total, 0)
    outer_levels <- .sort_facet_levels(as.character(freq$outer))
    inner_levels <- .sort_facet_levels(as.character(freq$inner))
    freq$outer <- factor(freq$outer, levels = outer_levels)
    freq$inner <- factor(freq$inner, levels = inner_levels)
    freq$cluster <- factor(as.character(freq$cluster), levels = lv_color)

    width_px <- as.numeric(container_width %||% 1050)
    legend_rows <- analysis_umap_frequency_legend_rows(
      cluster_count = length(lv_color),
      container_width = width_px
    )
    outer_n <- max(1L, length(outer_levels))
    inner_n <- max(1L, length(inner_levels))
    x_angle <- if (outer_n >= 7L || inner_n >= 7L) 25 else 0

    # Build true grouped + stacked bars by drawing each stack segment as a rectangle.
    freq <- freq[order(freq$outer, freq$inner, freq$cluster), , drop = FALSE]
    stack_key <- interaction(freq$outer, freq$inner, drop = TRUE)
    freq$ymax <- ave(freq$pct, stack_key, FUN = cumsum)
    freq$ymax <- ave(freq$ymax, stack_key, FUN = function(v) {
      vmax <- suppressWarnings(max(v, na.rm = TRUE))
      if (!is.finite(vmax) || vmax <= 0) return(v)
      v / vmax
    })
    freq$ymin <- ave(freq$ymax, stack_key, FUN = function(v) c(0, head(v, -1)))

    if (outer_n == 1L && inner_n > 1L) {
      # One split dimension: plain stacked bars across inner groups.
      freq$xcenter <- as.numeric(freq$inner)
      bar_w <- 0.72
      x_breaks <- seq_len(inner_n)
      x_labels <- inner_levels
      x_title <- if (identical(grp$inner_var, ".all")) NULL else grp$inner_label
    } else {
      # Two split dimensions (or many outer groups): grouped stacked bars.
      outer_idx <- as.numeric(freq$outer)
      if (inner_n > 1L) {
        dodge_w <- 0.90
        slot_w <- dodge_w / inner_n
        offsets <- (seq_len(inner_n) - (inner_n + 1) / 2) * slot_w
        bar_w <- max(0.04, min(0.20, slot_w * 0.90))
        freq$xcenter <- outer_idx + offsets[as.numeric(freq$inner)]
      } else {
        bar_w <- 0.72
        freq$xcenter <- outer_idx
      }
      x_breaks <- seq_len(outer_n)
      x_labels <- outer_levels
      x_title <- grp$outer_label
    }

    p <- ggplot2::ggplot(freq) +
      ggplot2::geom_rect(
        ggplot2::aes(
          xmin = xcenter - bar_w / 2,
          xmax = xcenter + bar_w / 2,
          ymin = ymin,
          ymax = ymax,
          fill = cluster
        ),
        color = "black",
        linewidth = 0.22,
        linetype = "solid"
      ) +
      ggplot2::scale_fill_manual(values = pal, drop = FALSE) +
      ggplot2::scale_x_continuous(
        breaks = x_breaks,
        labels = x_labels,
        expand = ggplot2::expansion(mult = c(0.06, 0.06))
      ) +
      ggplot2::scale_y_continuous(
        limits = c(0, 1),
        expand = c(0, 0),
        labels = function(x) paste0(round(100 * x), "%")
      ) +
      ggplot2::labs(
        x = x_title,
        y = "Cell frequency",
        fill = color_col %||% "ident"
      ) +
      ggplot2::theme_classic(base_size = 12) +
      ggplot2::theme(
        plot.margin = ggplot2::margin(8, 6, 8, 8),
        legend.position = "bottom",
        legend.justification = "center",
        legend.direction = "horizontal",
        legend.box = "vertical",
        legend.title = ggplot2::element_text(face = "bold", hjust = 0.5),
        legend.title.position = "top",
        legend.key = ggplot2::element_blank(),
        legend.text = ggplot2::element_text(size = 10),
        legend.box.margin = ggplot2::margin(2, 0, 0, 0),
        legend.margin = ggplot2::margin(0, 0, 0, 0),
        panel.grid.major = ggplot2::element_blank(),
        panel.grid.minor = ggplot2::element_blank(),
        axis.line = ggplot2::element_line(color = "#2f2f2f", linewidth = 0.45, linetype = "solid"),
        axis.text.x = ggplot2::element_text(angle = x_angle, hjust = if (x_angle == 0) 0.5 else 1)
      ) +
      ggplot2::guides(fill = ggplot2::guide_legend(nrow = legend_rows, byrow = TRUE, override.aes = list(alpha = 1)))

    p
  }

  .analysis_pdf_bundle <- function(kind, width_px = NULL, height_px = NULL) {
    kind <- .scalar_chr(kind, default = "")
    validate(need(nzchar(kind), "No PDF export target selected."))

    if (identical(kind, "umap_viz")) {
      out <- .cfg_preview_or_saved()
      validate(need(!is.null(out), "No embedding preview available. Click 'Generate embedding preview' first."))
      params <- c(.cfg_compute_params_raw(), .cfg_display_params())
      split_by <- if (identical(params$split_by %||% "__none__", "__none__")) NULL else params$split_by
      split_by_secondary <- if (identical(params$split_by_secondary %||% "__none__", "__none__")) NULL else params$split_by_secondary
      ref_sobj <- .get_active_sobj(shared_data)
      sobj_plot <- .sync_preview_metadata(
        preview_sobj = out$object,
        ref_sobj = ref_sobj,
        cols = c(params$color_by %||% character(), split_by %||% character(), split_by_secondary %||% character())
      )
      output_w <- suppressWarnings(as.numeric(width_px %||% session$clientData$output_umap_viz_plot_width %||% session$clientData$output_umap_viz_plot_ui_width %||% 1050))
      if (!is.finite(output_w) || output_w <= 0) output_w <- 1050

      lv <- .embedding_preview_levels(sobj_plot, split_by = split_by, split_by_secondary = split_by_secondary)
      spec <- .embedding_preview_layout(output_w, lv$col_levels, lv$row_levels)
      md <- tryCatch(sobj_plot@meta.data, error = function(e) NULL)
      color_by <- params$color_by %||% NULL
      vals <- if (!is.null(color_by) && nzchar(color_by) && !is.null(md) && color_by %in% colnames(md)) {
        as.character(md[[color_by]])
      } else {
        as.character(tryCatch(Seurat::Idents(sobj_plot), error = function(e) character()))
      }
      vals[is.na(vals) | !nzchar(vals)] <- "NA"
      n_lv <- max(1L, length(.sort_levels_natural(vals)))
      items_per_row <- max(6L, floor((output_w - 140) / 66))
      legend_rows <- max(1L, ceiling(n_lv / items_per_row))
      legend_extra <- 20L + max(0L, legend_rows - 1L) * 24L
      output_h <- suppressWarnings(as.numeric(height_px %||% session$clientData$output_umap_viz_plot_height))
      if (!is.finite(output_h) || output_h <= 0) output_h <- as.integer(spec$height + legend_extra)

      p <- .build_embedding_preview_plot(
        sobj = sobj_plot,
        reduction_name = out$reduction,
        color_by = params$color_by %||% NULL,
        split_by = split_by,
        split_by_secondary = split_by_secondary,
        plot_format = params$plot_format %||% "UMAP",
        container_width = output_w,
        dot_size = params$dot_size %||% 0.85
      )
      return(list(
        plot = p,
        width_px = output_w,
        height_px = output_h,
        filename_prefix = "embedding_preview_"
      ))
    }

    if (identical(kind, "umap_freq")) {
      out <- .cfg_preview_or_saved()
      validate(need(!is.null(out), "No embedding preview available. Click 'Generate embedding preview' first."))
      params <- c(.cfg_compute_params_raw(), .cfg_display_params())
      split_by <- if (identical(params$split_by %||% "__none__", "__none__")) NULL else params$split_by
      split_by_secondary <- if (identical(params$split_by_secondary %||% "__none__", "__none__")) NULL else params$split_by_secondary
      freq_group_by <- .scalar_chr(params$freq_group_by %||% "auto", default = "auto")
      ref_sobj <- .get_active_sobj(shared_data)
      sobj_plot <- .sync_preview_metadata(
        preview_sobj = out$object,
        ref_sobj = ref_sobj,
        cols = c(params$color_by %||% character(), split_by %||% character(), split_by_secondary %||% character())
      )
      output_w <- suppressWarnings(as.numeric(width_px %||% session$clientData$output_umap_cluster_freq_plot_width %||% session$clientData$output_umap_viz_plot_width %||% 1050))
      if (!is.finite(output_w) || output_w <= 0) output_w <- 1050
      freq_metrics <- .umap_cluster_freq_layout_metrics(
        sobj_plot = sobj_plot,
        color_by = params$color_by %||% NULL,
        split_by = split_by,
        split_by_secondary = split_by_secondary,
        freq_group_by = freq_group_by,
        container_width = output_w
      )
      output_h <- suppressWarnings(as.numeric(height_px %||% session$clientData$output_umap_cluster_freq_plot_height %||% freq_metrics$height_px))
      if (!is.finite(output_h) || output_h <= 0) {
        output_h <- freq_metrics$height_px
      } else {
        output_h <- as.integer(max(output_h, freq_metrics$height_px))
      }

      p <- .build_embedding_cluster_freq_plot(
        sobj = sobj_plot,
        reduction_name = out$reduction,
        color_by = params$color_by %||% NULL,
        split_by = split_by,
        split_by_secondary = split_by_secondary,
        container_width = output_w,
        freq_group_by = freq_group_by
      )
      return(list(
        plot = p,
        width_px = output_w,
        height_px = output_h,
        filename_prefix = "embedding_cluster_frequency_"
      ))
    }

    if (identical(kind, "jjvolcano")) {
      p <- jj_last_plot()
      validate(need(!is.null(p), "No jjvolcano plot is available yet. Click 'Run jjvolcano' first."))
      output_w <- suppressWarnings(as.numeric(width_px %||% session$clientData$output_jjvolcano_plot_width))
      output_h <- suppressWarnings(as.numeric(height_px %||% session$clientData$output_jjvolcano_plot_height))
      if (!is.finite(output_w) || output_w <= 0) output_w <- 2200
      if (!is.finite(output_h) || output_h <= 0) output_h <- 720
      return(list(
        plot = p,
        width_px = output_w,
        height_px = output_h,
        filename_prefix = "jjvolcano_"
      ))
    }

    validate(need(FALSE, "Unknown PDF export target."))
  }

  .build_embedding_preview_static_plot <- function(sobj, reduction_name, plot_format = "UMAP", color_by = NULL) {
    emb <- tryCatch(Seurat::Embeddings(sobj, reduction_name), error = function(e) NULL)
    validate(need(!is.null(emb) && is.matrix(emb) && ncol(emb) >= 2, "Embedding preview unavailable."))
    axis_prefix <- .reduction_pca_dims_label(sobj, reduction_name)
    if (!nzchar(axis_prefix)) {
      axis_prefix <- if (identical(toupper(as.character(plot_format %||% "UMAP")), "TSNE")) "TSNE_PCA" else "UMAP_PCA"
    }
    x_title <- paste0(axis_prefix, "_1")
    y_title <- paste0(axis_prefix, "_2")

    p <- tryCatch(
      .build_embedding_preview_plot(
        sobj = sobj,
        reduction_name = reduction_name,
        color_by = color_by,
        split_by = NULL,
        split_by_secondary = NULL,
        plot_format = plot_format,
        container_width = 1050,
        dot_size = 0.85
      ),
      error = function(e) ggplot2::ggplot() + ggplot2::ggtitle("Embedding preview unavailable")
    )
    dot_lg <- .umap_legend_dot_size(.umap_point_size_from_plot(p, 0.85), 10)
    p +
      ggplot2::labs(x = x_title, y = y_title) +
      ggplot2::theme(
        legend.position = "top",
        legend.direction = "horizontal",
        legend.box = "horizontal",
        plot.margin = ggplot2::margin(10, 10, 10, 10)
      ) +
      ggplot2::guides(
        colour = ggplot2::guide_legend(override.aes = list(size = dot_lg, alpha = 1)),
        color = ggplot2::guide_legend(override.aes = list(size = dot_lg, alpha = 1))
      )
  }

  .decorate_umap3d_export_widget <- function(widget, df, color_cols, default_color, default_size, default_alpha, state_key, axis_prefix = "UMAP", plot_title = "3D UMAP") {
    control_ids <- list(
      root = "umap3d-export-root",
      color = "umap3d-export-color",
      size = "umap3d-export-size",
      size_val = "umap3d-export-size-val",
      alpha = "umap3d-export-alpha",
      alpha_val = "umap3d-export-alpha-val",
      plot = "umap3d-export-plot"
    )
    palette <- unname(grDevices::hcl.colors(32L, palette = "Dark 3"))
    color_cols <- unique(as.character(color_cols))
    if (!length(color_cols)) color_cols <- default_color
    if (!default_color %in% color_cols) default_color <- color_cols[1]

    meta <- lapply(color_cols, function(nm) {
      v <- as.character(df[[nm]] %||% rep("NA", nrow(df)))
      v[is.na(v) | !nzchar(v)] <- "NA"
      v
    })
    names(meta) <- color_cols
    cluster_like <- vapply(
      color_cols,
      function(nm) isTRUE(.is_cluster_like_metadata(nm, df[[nm]])),
      logical(1)
    )

    controls <- htmltools::tags$div(
      id = control_ids$root,
      class = "wan-squircle",
      style = "width:95vw;max-width:95vw;margin:0 auto 12px auto;padding:10px 12px;background:#f8fafc;border:1px solid #d1d5db;border-radius:10px;display:flex;gap:14px;align-items:center;flex-wrap:wrap;",
      htmltools::tags$strong("3D UMAP Controls"),
      htmltools::tags$label(`for` = control_ids$color, style = "margin:0;", "Color by"),
      htmltools::tags$select(
        id = control_ids$color,
        style = "min-width:220px;",
        lapply(color_cols, function(nm) htmltools::tags$option(value = nm, selected = identical(nm, default_color), nm))
      ),
      htmltools::tags$label(`for` = control_ids$size, style = "margin:0 0 0 4px;", "Dot size"),
      htmltools::tags$input(id = control_ids$size, type = "range", min = "0.2", max = "6.0", step = "0.1", value = format(default_size, nsmall = 1)),
      htmltools::tags$span(id = control_ids$size_val, sprintf("%.1f", as.numeric(default_size))),
      htmltools::tags$label(`for` = control_ids$alpha, style = "margin:0 0 0 4px;", "Opacity"),
      htmltools::tags$input(id = control_ids$alpha, type = "range", min = "0.1", max = "1.0", step = "0.05", value = format(default_alpha, nsmall = 2)),
      htmltools::tags$span(id = control_ids$alpha_val, sprintf("%.2f", as.numeric(default_alpha)))
    )
    css <- htmltools::tags$style(htmltools::HTML(
      sprintf("#%s{width:95vw!important;height:90vh!important;max-width:none!important;margin:0 auto;}", control_ids$plot)
    ))

    widget <- htmlwidgets::prependContent(widget, css, controls)
    widget$elementId <- control_ids$plot

    js_code <- "
function(el, x, data) {
  var gd = document.getElementById(data.ids.plot) || el;
  if (!gd || !window.Plotly) return;

  var colorSel = document.getElementById(data.ids.color);
  var sizeInput = document.getElementById(data.ids.size);
  var sizeVal = document.getElementById(data.ids.size_val);
  var alphaInput = document.getElementById(data.ids.alpha);
  var alphaVal = document.getElementById(data.ids.alpha_val);
  if (!colorSel || !sizeInput || !alphaInput) return;

  function safe(v) {
    if (v === null || v === undefined || v === '') return 'NA';
    return String(v);
  }
  function toNum(v, dflt) {
    var out = parseFloat(v);
    return Number.isFinite(out) ? out : dflt;
  }
  function sortNatural(a, b) {
    return String(a).localeCompare(String(b), undefined, { numeric: true, sensitivity: 'base' });
  }
  function pickColor(i) {
    return data.palette[i % data.palette.length];
  }
  function isFiniteNumericStrict(txt) {
    if (txt === null || txt === undefined) return false;
    var s = String(txt).trim();
    if (!s || s === 'NA' || s === 'NaN' || s === 'Inf' || s === '-Inf') return false;
    if (!/^[-+]?(?:\\d+\\.?\\d*|\\.\\d+)(?:[eE][-+]?\\d+)?$/.test(s)) return false;
    var n = Number(s);
    return Number.isFinite(n);
  }
  function isContinuousColor(colorBy, metaCol) {
    if (!metaCol || !metaCol.length) return false;
    if (data.cluster_like && data.cluster_like[colorBy]) return false;
    var hasNumeric = false;
    for (var i = 0; i < metaCol.length; i++) {
      var s = safe(metaCol[i]);
      if (s === 'NA' || s === 'NaN' || s === 'Inf' || s === '-Inf' || !String(s).trim()) continue;
      if (!isFiniteNumericStrict(s)) return false;
      hasNumeric = true;
    }
    return hasNumeric;
  }
  function hashRead() {
    try {
      var raw = window.location.hash || '';
      if (raw.indexOf('#umap3d=') !== 0) return null;
      return JSON.parse(decodeURIComponent(raw.slice(8)));
    } catch (e) { return null; }
  }
  function hashWrite(state) {
    try {
      var enc = encodeURIComponent(JSON.stringify(state));
      if (window.history && window.history.replaceState) {
        window.history.replaceState(null, '', '#umap3d=' + enc);
      } else {
        window.location.hash = 'umap3d=' + enc;
      }
    } catch (e) {}
  }
  function loadStored() {
    try {
      var raw = localStorage.getItem(data.state_key);
      if (!raw) return null;
      return JSON.parse(raw);
    } catch (e) { return null; }
  }
  function saveStored(state) {
    try {
      localStorage.setItem(data.state_key, JSON.stringify(state));
    } catch (e) {}
  }

  function buildTraces(colorBy, pointSize, alpha) {
    var metaCol = data.meta[colorBy] || data.meta[data.default_color] || [];
    if (isContinuousColor(colorBy, metaCol)) {
      var xNum = [], yNum = [], zNum = [], txtNum = [], colNum = [];
      var xNa = [], yNa = [], zNa = [], txtNa = [];
      for (var ii = 0; ii < data.x.length; ii++) {
        var raw = safe(metaCol[ii]);
        if (isFiniteNumericStrict(raw)) {
          xNum.push(data.x[ii]); yNum.push(data.y[ii]); zNum.push(data.z[ii]); txtNum.push(data.cell_id[ii]); colNum.push(Number(raw));
        } else {
          xNa.push(data.x[ii]); yNa.push(data.y[ii]); zNa.push(data.z[ii]); txtNa.push(data.cell_id[ii]);
        }
      }
      var tracesContinuous = [];
      if (xNum.length) {
        tracesContinuous.push({
          type: 'scatter3d',
          mode: 'markers',
          name: colorBy,
          showlegend: false,
          x: xNum, y: yNum, z: zNum, text: txtNum,
          marker: {
            size: pointSize,
            opacity: alpha,
            color: colNum,
            colorscale: 'Viridis',
            showscale: true,
            colorbar: { title: colorBy }
          },
          hovertemplate: 'Cell: %{text}<br>' + colorBy + ': %{marker.color:.4g}<br>' + data.axis_prefix + '_1: %{x:.3f}<br>' + data.axis_prefix + '_2: %{y:.3f}<br>' + data.axis_prefix + '_3: %{z:.3f}<extra></extra>'
        });
      }
      if (xNa.length) {
        tracesContinuous.push({
          type: 'scatter3d',
          mode: 'markers',
          name: 'NA',
          showlegend: true,
          x: xNa, y: yNa, z: zNa, text: txtNa,
          marker: { size: pointSize, opacity: alpha, color: '#9CA3AF' },
          hovertemplate: 'Cell: %{text}<br>' + colorBy + ': NA<br>' + data.axis_prefix + '_1: %{x:.3f}<br>' + data.axis_prefix + '_2: %{y:.3f}<br>' + data.axis_prefix + '_3: %{z:.3f}<extra></extra>'
        });
      }
      return tracesContinuous;
    }
    var groups = {};
    for (var i = 0; i < data.x.length; i++) {
      var key = safe(metaCol[i]);
      if (!groups[key]) groups[key] = [];
      groups[key].push(i);
    }
    var keys = Object.keys(groups).sort(sortNatural);
    var traces = [];
    for (var j = 0; j < keys.length; j++) {
      var key = keys[j];
      var idx = groups[key];
      var x = [], y = [], z = [], txt = [];
      for (var k = 0; k < idx.length; k++) {
        var id = idx[k];
        x.push(data.x[id]); y.push(data.y[id]); z.push(data.z[id]); txt.push(data.cell_id[id]);
      }
      traces.push({
        type: 'scatter3d',
        mode: 'markers',
        name: key,
        x: x, y: y, z: z, text: txt,
        marker: { size: pointSize, opacity: alpha, color: pickColor(j) },
        hovertemplate: 'Cell: %{text}<br>' + colorBy + ': ' + key + '<br>' + data.axis_prefix + '_1: %{x:.3f}<br>' + data.axis_prefix + '_2: %{y:.3f}<br>' + data.axis_prefix + '_3: %{z:.3f}<extra></extra>'
      });
    }
    return traces;
  }

  function applyState(state, persist) {
    var next = {
      colorBy: state.colorBy || data.default_color,
      size: toNum(state.size, data.default_size),
      alpha: toNum(state.alpha, data.default_alpha)
    };
    if (!data.meta[next.colorBy]) next.colorBy = data.default_color;
    if (next.size < 0.2) next.size = 0.2;
    if (next.size > 6.0) next.size = 6.0;
    if (next.alpha < 0.1) next.alpha = 0.1;
    if (next.alpha > 1.0) next.alpha = 1.0;

    colorSel.value = next.colorBy;
    sizeInput.value = String(next.size);
    alphaInput.value = String(next.alpha);
    if (sizeVal) sizeVal.textContent = next.size.toFixed(1);
    if (alphaVal) alphaVal.textContent = next.alpha.toFixed(2);

    Plotly.react(gd, buildTraces(next.colorBy, next.size, next.alpha), data.layout, data.config);
    if (persist) {
      saveStored(next);
      hashWrite(next);
    }
  }

  var init = { colorBy: data.default_color, size: data.default_size, alpha: data.default_alpha };
  var localState = loadStored();
  if (localState) init = Object.assign(init, localState);
  var hashState = hashRead();
  if (hashState) init = Object.assign(init, hashState);

  applyState(init, false);
  colorSel.addEventListener('change', function() { applyState({ colorBy: colorSel.value, size: sizeInput.value, alpha: alphaInput.value }, true); });
  sizeInput.addEventListener('input', function() { applyState({ colorBy: colorSel.value, size: sizeInput.value, alpha: alphaInput.value }, true); });
  alphaInput.addEventListener('input', function() { applyState({ colorBy: colorSel.value, size: sizeInput.value, alpha: alphaInput.value }, true); });
}
"

    htmlwidgets::onRender(
      widget,
      js_code,
      data = list(
        ids = control_ids,
        x = unname(df$UMAP_1),
        y = unname(df$UMAP_2),
        z = unname(df$UMAP_3),
        cell_id = unname(df$cell_id),
        meta = meta,
        cluster_like = as.list(cluster_like),
        palette = palette,
        layout = list(
          title = list(text = plot_title),
          legend = list(orientation = "v"),
          scene = list(
            xaxis = list(title = paste0(axis_prefix, "_1")),
            yaxis = list(title = paste0(axis_prefix, "_2")),
            zaxis = list(title = paste0(axis_prefix, "_3")),
            aspectmode = "data"
          ),
          margin = list(l = 0, r = 0, b = 0, t = 44)
        ),
        config = list(displaylogo = FALSE, responsive = TRUE),
        default_color = default_color,
        default_size = as.numeric(default_size),
        default_alpha = as.numeric(default_alpha),
        state_key = state_key,
        axis_prefix = as.character(axis_prefix)
      )
    )
  }
  
  .analysis_entry_has_seurat <- function(entry) {
    if (is.null(entry)) return(FALSE)
    obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    !is.null(obj) && inherits(obj, "Seurat")
  }

  .analysis_data_is_ready_flag <- reactive({
    reg <- shared_data$all_seurat_objects %||% list()
    if (!length(reg)) return(FALSE)
    has_any_seurat <- any(vapply(reg, .analysis_entry_has_seurat, logical(1)))
    if (!isTRUE(has_any_seurat)) return(FALSE)

    nm <- trimws(.scalar_chr(shared_data$active_object_name, default = ""))
    if (nzchar(nm) && !is.null(reg[[nm]])) return(TRUE)
    TRUE
  })

  output$analysis_data_is_ready <- renderText({
    if (isTRUE(.analysis_data_is_ready_flag())) "true" else "false"
  })
  outputOptions(output, "analysis_data_is_ready", suspendWhenHidden = FALSE)

  .analysis_gate_log_once <- reactiveVal(FALSE)
  .analysis_gate_visible <- reactiveVal(NA)
  observe({
    reg <- shared_data$all_seurat_objects %||% list()
    active_nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!isTRUE(.analysis_gate_log_once())) {
      reg_names <- names(reg)
      reg_names <- as.character(reg_names %||% character(0))
      reg_names <- reg_names[!is.na(reg_names) & nzchar(reg_names)]
      reg_classes <- if (length(reg_names)) {
        vapply(reg_names, function(nm) {
          entry <- reg[[nm]]
          obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
          cls <- class(obj)
          if (!length(cls)) "NULL" else as.character(cls[[1]])
        }, character(1))
      } else {
        character(0)
      }
      cat(sprintf(
        "[ANALYSIS GATE] ready=%s active=%s reg_n=%d reg_names=%s reg_classes=%s\n",
        as.character(isTRUE(.analysis_data_is_ready_flag())),
        if (nzchar(active_nm)) active_nm else "<empty>",
        length(reg),
        paste(reg_names, collapse = ","),
        paste(reg_classes, collapse = ",")
      ))
      .analysis_gate_log_once(TRUE)
    }

    ready_now <- isTRUE(.analysis_data_is_ready_flag())
    last_ready <- .analysis_gate_visible()
    if (!identical(last_ready, ready_now)) {
      if (isTRUE(ready_now)) {
        shinyjs::show("analysis_ready_gate")
        shinyjs::hide("analysis_waiting_gate")
      } else {
        shinyjs::hide("analysis_ready_gate")
        shinyjs::show("analysis_waiting_gate")
      }
      .analysis_gate_visible(ready_now)
    }
    invisible(NULL)
  })

  observe({
    reg <- shared_data$all_seurat_objects %||% list()
    if (!length(reg)) return(invisible(NULL))
    current_active <- .scalar_chr(shared_data$active_object_name, default = "")
    if (nzchar(current_active) && !is.null(reg[[current_active]])) return(invisible(NULL))

    fallback_active <- tryCatch(
      analysis_preferred_loaded_object_name(registry = reg),
      error = function(e) ""
    )
    if (!nzchar(fallback_active) || is.null(reg[[fallback_active]])) {
      reg_names <- names(reg)
      reg_names <- reg_names[!is.na(reg_names) & nzchar(reg_names)]
      if (length(reg_names)) fallback_active <- reg_names[[1]]
    }
    if (nzchar(fallback_active) && !identical(current_active, fallback_active)) {
      shared_data$active_object_name <- fallback_active
    }
    invisible(NULL)
  })

  observe({
    tab_now <- .scalar_chr(input$main_navbar, default = "")
    if (!identical(tab_now, "analysis_tab")) return(invisible(NULL))
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(nm)) return(invisible(NULL))
    plot_tab_input_now <- .scalar_chr(input$plot_tabs, default = "")
    if (!nzchar(plot_tab_input_now)) return(invisible(NULL))
    plot_tab_now <- .scalar_chr(.current_plot_tab(), default = "<empty>")
    entry <- shared_data$all_seurat_objects[[nm]]
    if (is.null(entry)) return(invisible(NULL))
    sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(invisible(NULL))
    route_active <- isTRUE(isolate(analysis_route_trace()$active))
    if (isTRUE(route_active)) return(invisible(NULL))
    if (!isTRUE(.analysis_data_is_ready_flag())) return(invisible(NULL))
    if (!nzchar(plot_tab_now) || identical(plot_tab_now, "<empty>")) return(invisible(NULL))
    # Avoid stealing overlay ownership from active sub-tabs that manage their
    # own render lifecycle (Data Browser / UMAP pages).
    if (plot_tab_now %in% c("data browser", "umap configuration", "umap visualization")) {
      return(invisible(NULL))
    }
    session$onFlushed(function() {
      .perf_log("route_flush_hide_overlay", details = c(
        sprintf("active=%s", nm),
        sprintf("plot_tabs=%s", plot_tab_now)
      ))
      try(overlay_hide(), silent = TRUE)
    }, once = TRUE)
  })
  
  # drives visibility of the right pane
  output$elbow_ready <- reactive({
    snapshot <- analysis_active_elbow_preview()
    isTRUE(snapshot$ready)
  })
  outputOptions(output, "elbow_ready", suspendWhenHidden = FALSE)
  output$elbow_locked <- reactive({
    isTRUE(.analysis_should_lock_elbow_preview())
  })
  outputOptions(output, "elbow_locked", suspendWhenHidden = FALSE)
  .sync_integration_lock_layout <- function() {
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    lock_now <- isTRUE(.analysis_should_lock_elbow_preview())
    if (identical(tab_now, "normalize / integrate") && isTRUE(lock_now)) {
      shinyjs::addClass(id = "analysis_prep_row", class = "analysis-integration-locked")
    } else {
      shinyjs::removeClass(id = "analysis_prep_row", class = "analysis-integration-locked")
    }
    invisible(NULL)
  }
  observe({ .analysis_should_lock_elbow_preview(); .sync_integration_lock_layout() })
  observeEvent(input$plot_tabs, { .sync_integration_lock_layout() }, ignoreInit = FALSE)
  
  observeEvent(input$to_umap_config_btn, {
    t_btn <- .perf_now()
    .perf_log("to_umap_config_btn:start")
    nm <- .scalar_chr(shared_data$active_object_name, "")
    if (!nzchar(nm) || is.null(shared_data$all_seurat_objects[[nm]])) {
      .perf_log("to_umap_config_btn:abort_no_active_object", t0 = t_btn)
      showNotification("No active analysis object is available. Please select/add an object first.", type = "error")
      return()
    }
    dims_now <- .coerce_dims(input$prep_dims_slider %||% 30L)
    .perf_log("to_umap_config_btn:committing_dims", t0 = t_btn, details = c(
      sprintf("object=%s", nm),
      sprintf("dims=%d", dims_now)
    ))
    ok <- tryCatch({
      .commit_dims_for_object(nm, dims_now, source = "normalize_integrate_next")
      TRUE
    }, error = function(e) {
      .perf_log("to_umap_config_btn:commit_failed", t0 = t_btn, details = conditionMessage(e))
      showNotification(paste("Unable to continue to UMAP configuration:", conditionMessage(e)), type = "error", duration = NULL)
      FALSE
    })
    if (!isTRUE(ok)) return()
    showNotification(sprintf("Confirmed PCA dims: %d", dims_now), type = "message", duration = 2)
    .perf_log("to_umap_config_btn:go_plot_tab", t0 = t_btn, details = "target=umap configuration")
    .go_plot_tab("umap configuration")
    sobj_now <- tryCatch(isolate(.get_active_sobj(shared_data)), error = function(e) NULL)
    params_now <- tryCatch(isolate(.cfg_compute_params_raw()), error = function(e) NULL)
    if (is.null(sobj_now) || is.null(params_now)) {
      .perf_log("to_umap_config_btn:abort_snapshot_failed", t0 = t_btn)
      showNotification("Unable to prepare embedding preview inputs.", type = "error", duration = 8)
      return(invisible(NULL))
    }
    .perf_log("to_umap_config_btn:queue_cfg_preview", t0 = t_btn)
    # Defer heavy preview until after tab switch flushes to avoid blocking
    # navigation responsiveness.
    session$onFlushed(function() {
      shiny::withReactiveDomain(session, {
        .perf_log("to_umap_config_btn:deferred_preview_dispatch", t0 = t_btn)
        .queue_cfg_preview_run(
          tab_now = "umap configuration",
          nm = nm,
          sobj = sobj_now,
          params = params_now,
          t0 = t_btn,
          source_tag = "to_umap_config_btn",
          pre_shown = FALSE
        )
      })
    }, once = TRUE)
    # do NOT set .sweep_ready(TRUE) here – it should only be TRUE after a sweep
  }, ignoreInit = TRUE)

  observeEvent(input$to_data_browser_loupe_import_btn, {
    .go_plot_tab("data browser")
    session$onFlushed(function() {
      try(shinyjs::runjs("var b=document.getElementById('db_open_import_modal'); if(b){b.click();}"), silent = TRUE)
    }, once = TRUE)
  }, ignoreInit = TRUE)
  observe({
    sel <- .scalar_chr(input$cfg_plot_format, default = "")
    if (!nzchar(sel)) return(invisible(NULL))
    invisible(NULL)
  })
  .seed_cfg_preview_cache <- function(nm) {
    if (is.null(nm) || !nzchar(as.character(nm))) return(invisible(NULL))
    nm_chr <- .scalar_chr(nm, default = "")
    if (!nzchar(nm_chr)) return(invisible(NULL))
    entry <- shared_data$all_seurat_objects[[nm_chr]]
    sobj <- .get_obj_from_entry(entry)
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(invisible(NULL))
    reds <- tolower(tryCatch(names(sobj@reductions), error = function(e) character()))
    if (!length(reds)) return(invisible(NULL))

    p <- tryCatch(entry$prefs$embedding_params, error = function(e) NULL)
    if (!is.list(p)) p <- list()
    fmt <- toupper(as.character(p$plot_format %||% ""))
    red <- if (identical(fmt, "TSNE")) {
      if (any(startsWith(reds, "tsne"))) reds[[which(startsWith(reds, "tsne"))[[1]]]] else NULL
    } else if (identical(fmt, "UMAP")) {
      if (any(startsWith(reds, "umap"))) reds[[which(startsWith(reds, "umap"))[[1]]]] else NULL
    } else NULL
    if (is.null(red)) {
      if (any(startsWith(reds, "umap"))) red <- reds[[which(startsWith(reds, "umap"))[[1]]]]
      else if (any(startsWith(reds, "tsne"))) red <- reds[[which(startsWith(reds, "tsne"))[[1]]]]
    }
    if (is.null(red) || !red %in% reds) return(invisible(NULL))

    params <- list(
      plot_format = if (identical(red, "tsne")) "tSNE" else "UMAP",
      dims = .coerce_dims(p$dims %||% 30L),
      seed = suppressWarnings(as.integer(p$seed %||% 42L)),
      umap_neighbors = suppressWarnings(as.integer(p$umap_neighbors %||% 30L)),
      umap_min_dist = suppressWarnings(as.numeric(p$umap_min_dist %||% 0.3)),
      umap_spread = suppressWarnings(as.numeric(p$umap_spread %||% 1.0)),
      tsne_perplexity = suppressWarnings(as.numeric(p$tsne_perplexity %||% 30)),
      tsne_theta = suppressWarnings(as.numeric(p$tsne_theta %||% 0.5)),
      tsne_eta = suppressWarnings(as.numeric(p$tsne_eta %||% 200)),
      tsne_iter = suppressWarnings(as.integer(p$tsne_iter %||% 1000))
    )
    cache_key <- paste(
      .cfg_object_signature(sobj, object_name = nm),
      paste(unlist(params), collapse = "::"),
      sep = "||"
    )
    .cfg_preview_cache(list(
      key = cache_key,
      result = list(object_name = nm, object = sobj, plot = NULL, reduction = red)
    ))
    invisible(NULL)
  }
  .preferred_cfg_plot_format <- function(entry) {
    sobj <- .get_obj_from_entry(entry)
    reds <- tryCatch(names(sobj@reductions), error = function(e) character())
    reds_lc <- tolower(reds)
    prefs <- tryCatch(entry$prefs$embedding_params, error = function(e) NULL)
    pref_fmt <- toupper(as.character(prefs$plot_format %||% ""))
    if (identical(pref_fmt, "TSNE") && any(startsWith(reds_lc, "tsne"))) return(reds[[which(startsWith(reds_lc, "tsne"))[[1]]]])
    if (identical(pref_fmt, "UMAP") && any(startsWith(reds_lc, "umap"))) return(reds[[which(startsWith(reds_lc, "umap"))[[1]]]])
    if (any(startsWith(reds_lc, "umap"))) return(reds[[which(startsWith(reds_lc, "umap"))[[1]]]])
    if (any(startsWith(reds_lc, "tsne"))) return(reds[[which(startsWith(reds_lc, "tsne"))[[1]]]])
    if (length(reds)) return(reds[[1]])
    "umap"
  }
  .is_umap3d_tab <- function(x) {
    tab <- tolower(trimws(.scalar_chr(x, default = "")))
    tab %in% c("umap3d_tab", "3d umap")
  }
  observeEvent(shared_data$active_object_name, {
    if (!identical(.scalar_chr(isolate(input$main_navbar), default = ""), "analysis_tab")) {
      return(invisible(NULL))
    }
    t_active <- .perf_now()
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    .perf_log("active_object_name:reset_preview_state", details = sprintf("object=%s", if (nzchar(nm)) nm else "<empty>"))
    .cfg_preview_cache(list(key = NULL, result = NULL))
    .cfg_keeper_dirty(FALSE)
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    .sync_active_elbow_preview(nm)
    if (!nzchar(nm)) {
      .sweep_ready(FALSE)
      return()
    }
    # IMPORTANT: do not force selector reseed from active-object changes.
    # This previously collapsed multi-selection back to one item.
    dims_saved <- .get_confirmed_dims(nm)
    if (length(dims_saved) == 1 && is.finite(dims_saved) && !is.na(dims_saved)) {
      updateSliderInput(session, "prep_dims_slider", value = .coerce_dims(dims_saved))
    }
    entry <- shared_data$all_seurat_objects[[nm]]
    preferred_fmt <- .preferred_cfg_plot_format(entry)
    updateSelectInput(session, "cfg_plot_format", selected = preferred_fmt)
    sobj_now <- .get_obj_from_entry(entry)
    cache_now <- tryCatch(entry$analysis_cache$cluster_sweep, error = function(e) NULL)
    cache_res_now <- suppressWarnings(as.numeric(cache_now$resolutions %||% numeric()))
    cache_res_now <- cache_res_now[is.finite(cache_res_now)]
    has_any_resolution <- length(.resolution_values(sobj_now, cache_res = cache_res_now)) > 0L
    needs_sweep_bootstrap <- .analysis_subtab_is_active("clustering resolution") ||
      .analysis_subtab_is_active("differential expression analysis")
    sweep_ready_bootstrapped <- if (isTRUE(needs_sweep_bootstrap)) {
      isTRUE(.ensure_cluster_sweep_cache_for_object(nm, sobj = sobj_now))
    } else {
      isTRUE(has_any_resolution)
    }
    .sweep_ready(sweep_ready_bootstrapped)
    .seed_cfg_preview_cache(nm)
    .perf_log("active_object_name:seed_cfg_preview_cache_done", t0 = t_active, details = c(
      sprintf("object=%s", nm),
      sprintf("dims_saved=%s", if (length(dims_saved)) as.character(dims_saved[[1]]) else "NA"),
      sprintf("sweep_ready=%s", as.character(sweep_ready_bootstrapped))
    ))
    if (isTRUE(isolate(analysis_object_switch_overlay_pending()))) {
      session$onFlushed(function() {
        try(overlay_hide(), silent = TRUE)
        analysis_object_switch_overlay_pending(FALSE)
      }, once = TRUE)
    }
  })
  observe({
    name_sig <- paste(.analysis_selectable_choices(), collapse = "\r")
    prev_sig <- isolate(analysis_registry_names_seen())
    if (!identical(name_sig, prev_sig)) {
      analysis_registry_names_seen(name_sig)
      analysis_prefer_integrated_boot_pending(TRUE)
    }
    invisible(NULL)
  })
  observe({
    registry <- shared_data$all_seurat_objects %||% list()
    choices <- .analysis_selectable_choices()
    if (!length(choices)) return(invisible(NULL))
    current_sel <- intersect(as.character(isolate(analysis_selected_names()) %||% character(0)), choices)
    current_active <- .scalar_chr(shared_data$active_object_name, default = "")
    if (isTRUE(analysis_prefer_integrated_boot_pending()) && !isTRUE(analysis_reintegration_enabled()) && length(.analysis_integrated_choices())) {
      target_active <- analysis_preferred_integrated_name(registry, active_name = current_active)
      target_sel <- if (nzchar(target_active)) target_active else character(0)
      if (length(target_sel) && !identical(current_sel, target_sel)) {
        analysis_selected_names(target_sel)
        .sync_analysis_selector_inputs(target_sel)
        .force_seed_selector_inputs(target_sel)
        .perf_log("analysis_selector:bootstrap_integrated_default", details = sprintf("selected=%s", target_active))
      }
      if (nzchar(target_active) && !identical(current_active, target_active)) {
        shared_data$active_object_name <- target_active
        return(invisible(NULL))
      }
      analysis_prefer_integrated_boot_pending(FALSE)
      return(invisible(NULL))
    }
    if (length(current_sel)) return(invisible(NULL))
    if (nzchar(current_active) && current_active %in% choices) {
      analysis_selected_names(current_active)
      .sync_analysis_selector_inputs(current_active)
      .force_seed_selector_inputs(current_active)
      .perf_log("analysis_selector:bootstrap_active", details = sprintf("selected=%s", current_active))
      return(invisible(NULL))
    }
    analysis_selected_names(choices[[1]])
    .sync_analysis_selector_inputs(choices[[1]])
    .force_seed_selector_inputs(choices[[1]])
    .perf_log("analysis_selector:bootstrap_first_choice", details = sprintf("selected=%s", choices[[1]]))
    invisible(NULL)
  })
  observe({
    reg_now <- shared_data$all_seurat_objects %||% list()
    base_mode <- analysis_selector_mode_for_registry(
      reg_now,
      reintegration_enabled = FALSE
    )
    has_source_choices <- length(analysis_registry_object_names(reg_now)) > 1L
    should_disable_reintegration <- isTRUE(analysis_reintegration_enabled()) &&
      (!identical(base_mode, "replace") || !isTRUE(has_source_choices))
    if (isTRUE(should_disable_reintegration)) {
      analysis_reintegration_enabled(FALSE)
    }
  })
  observeEvent(input$analysis_enable_reintegrate_overlay, {
    if (!isTRUE(.analysis_show_reintegrate_entry())) return(invisible(NULL))
    showModal(modalDialog(
      title = ANALYSIS_UI_TEXT$t_title_reintegration_confirm,
      easyClose = TRUE,
      footer = tagList(
        modalButton("Cancel"),
        actionButton("analysis_confirm_reintegrate_btn", ANALYSIS_UI_TEXT$t_btn_enable_reintegration, class = "btn-primary")
      ),
      p(ANALYSIS_UI_TEXT$t_text_reintegration_confirm)
    ))
  }, ignoreInit = TRUE)
  observeEvent(input$analysis_enable_reintegrate_dims_overlay, {
    if (!isTRUE(.analysis_should_lock_elbow_preview())) return(invisible(NULL))
    showModal(modalDialog(
      title = ANALYSIS_UI_TEXT$t_title_reenable_pca_confirm,
      easyClose = TRUE,
      footer = tagList(
        modalButton("Cancel"),
        actionButton("analysis_confirm_reenable_pca_btn", ANALYSIS_UI_TEXT$t_btn_reenable_pca, class = "btn-primary")
      ),
      p(ANALYSIS_UI_TEXT$t_text_reenable_pca_confirm)
    ))
  }, ignoreInit = TRUE)
  observeEvent(input$analysis_enable_reintegrate_elbow_overlay, {
    if (!isTRUE(.analysis_should_lock_elbow_preview())) return(invisible(NULL))
    showModal(modalDialog(
      title = ANALYSIS_UI_TEXT$t_title_reenable_pca_confirm,
      easyClose = TRUE,
      footer = tagList(
        modalButton("Cancel"),
        actionButton("analysis_confirm_reenable_pca_btn", ANALYSIS_UI_TEXT$t_btn_reenable_pca, class = "btn-primary")
      ),
      p(ANALYSIS_UI_TEXT$t_text_reenable_pca_confirm)
    ))
  }, ignoreInit = TRUE)
  observeEvent(input$analysis_confirm_reenable_pca_btn, {
    removeModal()
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(nm)) return(invisible(NULL))
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    if (is.null(entry) || !is.list(entry)) return(invisible(NULL))
    if (is.null(entry$prefs)) entry$prefs <- list()
    entry$prefs$confirmed_dims <- NULL
    shared_data$all_seurat_objects[[nm]] <- entry
    showNotification(ANALYSIS_UI_TEXT$t_text_pca_reenabled, type = "message", duration = 3)
  }, ignoreInit = TRUE)
  observeEvent(input$analysis_confirm_reintegrate_btn, {
    removeModal()
    analysis_reintegration_enabled(TRUE)
  }, ignoreInit = TRUE)
  observeEvent(input$analysis_cancel_reintegrate_overlay, {
    if (!isTRUE(.analysis_show_cancel_reintegrate_entry())) return(invisible(NULL))
    analysis_reintegration_enabled(FALSE)
  }, ignoreInit = TRUE)
  observeEvent(input$run_norm_btn, {
    .cfg_preview_cache(list(key = NULL, result = NULL))
    .cfg_keeper_dirty(TRUE)
  }, ignoreInit = TRUE)
  observeEvent(input$run_inte_btn, {
    .cfg_preview_cache(list(key = NULL, result = NULL))
    .cfg_keeper_dirty(TRUE)
  }, ignoreInit = TRUE)
  observeEvent(list(
    input$cfg_plot_format,
    input$cfg_seed_input,
    input$cfg_umap_neighbors,
    input$cfg_umap_min_dist,
    input$cfg_umap_spread,
    input$cfg_tsne_perplexity,
    input$cfg_tsne_theta,
    input$cfg_tsne_eta,
    input$cfg_tsne_iter,
    input$prep_dims_slider
  ), {
    tab_now <- input$plot_tabs %||% ""
    if (identical(tab_now, "umap configuration")) {
      .cfg_keeper_dirty(TRUE)
    }
  }, ignoreInit = TRUE)
  observeEvent(input$cfg_plot_format, {
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    if (!identical(tab_now, "umap configuration")) return(invisible(NULL))
    nm_now <- .scalar_chr(shared_data$active_object_name, default = "")
    sobj_now <- tryCatch(.get_active_sobj(shared_data), error = function(e) NULL)
    if (!nzchar(nm_now) || is.null(sobj_now) || !inherits(sobj_now, "Seurat")) return(invisible(NULL))
    params_now <- tryCatch(isolate(.cfg_compute_params_raw()), error = function(e) NULL)
    if (!is.list(params_now)) return(invisible(NULL))
    .perf_log("cfg_plot_format:auto_preview_queue", details = c(
      sprintf("object=%s", nm_now),
      sprintf("plot_format=%s", .scalar_chr(params_now$plot_format, default = "<empty>"))
    ))
    .queue_cfg_preview_run(
      tab_now = tab_now,
      nm = nm_now,
      sobj = sobj_now,
      params = params_now,
      t0 = .perf_now(),
      source_tag = "cfg_plot_format_auto",
      pre_shown = FALSE
    )
    invisible(NULL)
  }, ignoreInit = TRUE)
  observeEvent(input$cfg_tsne_speed_preset, {
    preset <- .scalar_chr(input$cfg_tsne_speed_preset, default = "fast")
    vals <- switch(
      preset,
      fast = list(perplexity = 20, theta = 0.8, iter = 500L),
      balanced = list(perplexity = 30, theta = 0.6, iter = 1000L),
      quality = list(perplexity = 30, theta = 0.3, iter = 1500L),
      list(perplexity = 20, theta = 0.8, iter = 500L)
    )
    updateSliderInput(session, "cfg_tsne_perplexity", value = vals$perplexity)
    updateSliderInput(session, "cfg_tsne_theta", value = vals$theta)
    updateSliderInput(session, "cfg_tsne_iter", value = vals$iter)
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$umap3d_generate_btn, {
    .umap3d_error(NULL)
    .umap3d_requested(TRUE)
    mode_now <- toupper(.scalar_chr(input$umap3d_embedding_type %||% "UMAP", default = "UMAP"))
    label_now <- if (identical(mode_now, "TSNE")) "3D tSNE" else "3D UMAP"
    showNotification(sprintf("Generating %s preview...", label_now), type = "message", duration = 2)
  }, ignoreInit = TRUE)

  observeEvent(input$umap3d_embedding_type, {
    if (!isTRUE(.umap3d_requested())) return(invisible(NULL))
    mode_now <- toupper(.scalar_chr(input$umap3d_embedding_type %||% "UMAP", default = "UMAP"))
    label_now <- if (identical(mode_now, "TSNE")) "3D tSNE" else "3D UMAP"
    .umap3d_error(NULL)
    # Force a full recompute/render cycle when embedding type changes.
    .umap3d_requested(FALSE)
    .umap3d_requested(TRUE)
    showNotification(sprintf("Switched to %s. Regenerating preview...", label_now), type = "message", duration = 2)
  }, ignoreInit = TRUE)
  
  observeEvent(shared_data$active_object_name, {
    boot <- shared_data$analysis_boot
    active <- .scalar_chr(boot$active_object %||% shared_data$active_object_name, default = "")
    if (!nzchar(active)) return(invisible(NULL))
    
    entry <- shared_data$all_seurat_objects[[active]]
    if (is.null(entry)) return(invisible(NULL))
    sobj  <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(invisible(NULL))
    
    shinyjs::show("analysis_tabs_by_type")
  }, ignoreInit = FALSE)
  
  active_seurat_object <- reactive({
    req(shared_data$active_object_name)
    shared_data$all_seurat_objects[[shared_data$active_object_name]]
  })
  
  observe({
    method <- .scalar_chr(input$inte_method, default = "")
    prof <- .analysis_selection_profile()
    inobject_active <- isTRUE(.analysis_inobject_reintegrate_active())
    reintegrate_mode <- identical(.analysis_selector_mode(), "reintegrate")
    should_disable <- identical(method, "merge") ||
      (!isTRUE(reintegrate_mode) && isTRUE(prof$mixed)) ||
      (!isTRUE(reintegrate_mode) && isTRUE(prof$integrated_multi)) ||
      (isTRUE(prof$integrated_single) && !isTRUE(inobject_active))
    if (isTRUE(should_disable)) {
      shinyjs::disable("run_inte_btn")
    } else {
      shinyjs::enable("run_inte_btn")
    }
    .refresh_normalize_integration_visibility()
  })
  
  
  .render_analysis_object_selector_input <- function(input_id, multiple = TRUE, enabled = TRUE, object_choices = NULL, allow_empty_selection = FALSE, selected_override = NULL) {
    object_choices <- object_choices %||% .analysis_selectable_choices()
    object_choices <- intersect(as.character(object_choices %||% character(0)), .analysis_selectable_choices())
    if (!length(object_choices)) {
      return(helpText("No objects loaded for analysis."))
    }
    selected <- if (!is.null(selected_override)) {
      intersect(as.character(selected_override %||% character(0)), object_choices)
    } else {
      .analysis_selection_for_choices(
        object_choices = object_choices,
        allow_empty = allow_empty_selection,
        fallback_to_active = TRUE
      )
    }
    if (!isTRUE(multiple)) {
      active_selected <- .scalar_chr(shared_data$active_object_name, default = "")
      if (!nzchar(active_selected) || !active_selected %in% object_choices) {
        active_selected <- .scalar_chr(selected[[1]], default = object_choices[[1]])
      }
      control <- (
        selectInput(
          input_id,
          ANALYSIS_UI_TEXT$t_text_replace_active_dataset_analysis,
          choices = object_choices,
          selected = active_selected
        )
      )
      if (!isTRUE(enabled)) control <- shinyjs::disabled(control)
      return(control)
    }
    control <- selectizeInput(
      input_id,
      ANALYSIS_UI_TEXT$t_text_add_datasets_analysis,
      choices = object_choices,
      selected = selected,
      multiple = TRUE,
      options = list(
        placeholder = ANALYSIS_UI_TEXT$t_text_add_one_more_objects,
        plugins = list("remove_button")
      )
    )
    if (!isTRUE(enabled)) control <- shinyjs::disabled(control)
    control
  }

  observe({
    choices <- .analysis_selectable_choices()
    if (!length(choices)) {
      selector_sync_in_progress(TRUE)
      on.exit(selector_sync_in_progress(FALSE), add = TRUE)
      try(updateSelectInput(session, "active_object_name_input", choices = character(0), selected = character(0)), silent = TRUE)
      shinyjs::disable("active_object_name_input")
      return(invisible(NULL))
    }
    active_sel <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(active_sel) || !active_sel %in% choices) active_sel <- choices[[1]]
    selector_sync_in_progress(TRUE)
    on.exit(selector_sync_in_progress(FALSE), add = TRUE)
    try(updateSelectInput(session, "active_object_name_input", choices = choices, selected = active_sel), silent = TRUE)
    if (isTRUE(.analysis_replace_selector_enabled())) {
      shinyjs::enable("active_object_name_input")
    } else {
      shinyjs::disable("active_object_name_input")
    }
    .perf_log("render:analysis_object_selector_ui", details = c(
      sprintf("choices_n=%d", length(choices)),
      sprintf("mode=%s", .analysis_selector_mode())
    ))
    invisible(NULL)
  })

  output$analysis_object_selector_inline_ui <- renderUI({
    mode_now <- .analysis_selector_mode()
    prof <- .analysis_selection_profile()
    .state_note <- function() {
      if (isTRUE(prof$mixed) && !identical(mode_now, "reintegrate")) {
        return(div(class = "alert alert-danger", style = "margin-top:8px; margin-bottom:0; padding:8px 10px;",
                   ANALYSIS_UI_TEXT$t_text_integration_mixed_selection_error))
      }
      if (isTRUE(prof$integrated_multi)) {
        return(div(class = "alert alert-danger", style = "margin-top:8px; margin-bottom:0; padding:8px 10px;",
                   ANALYSIS_UI_TEXT$t_text_integration_integrated_multi_error))
      }
      if (isTRUE(prof$integrated_single)) {
        return(tagList(
          checkboxInput(
            "analysis_inobject_reintegrate_switch",
            ANALYSIS_UI_TEXT$t_label_inobject_reintegration_switch,
            value = isTRUE(.analysis_inobject_reintegrate_active())
          ),
          div(class = "alert alert-info", style = "margin-top:8px; margin-bottom:0; padding:8px 10px;",
              ANALYSIS_UI_TEXT$t_text_inobject_reintegration_hint)
        ))
      }
      NULL
    }
    if (identical(mode_now, "replace")) {
      control <- .render_analysis_object_selector_input(
        "active_object_name_input_inline",
        enabled = TRUE,
        object_choices = .analysis_selectable_choices(),
        selected_override = .normalize_selector_selection()
      )
      return(tagList(
        control,
        .state_note(),
        if (isTRUE(.analysis_show_reintegrate_entry())) {
          div(
            class = "text-muted",
            style = "margin-top:6px; font-size:12px;",
            actionLink(
              "analysis_enable_reintegrate_overlay",
              label = span(class = "analysis-selector-overlay-note", ANALYSIS_UI_TEXT$t_text_enable_reintegration),
              class = "analysis-selector-overlay-link"
            )
          )
        },
        div(
          class = "text-muted",
          style = "margin-top:6px; font-size:12px;",
          ANALYSIS_UI_TEXT$t_text_reintegration_unavailable
        )
      ))
    }
    tagList(
      .render_analysis_object_selector_input(
        "active_object_name_input_inline",
        enabled = isTRUE(.analysis_normalize_multiselect_enabled()),
        object_choices = if (identical(mode_now, "reintegrate")) .analysis_source_choices() else .analysis_selectable_choices(),
        allow_empty_selection = identical(mode_now, "reintegrate"),
        selected_override = .normalize_selector_selection()
      ),
      .state_note()
    )
  })
  outputOptions(output, "analysis_object_selector_inline_ui", suspendWhenHidden = FALSE)

  .apply_analysis_selection <- function(sel, replace_all = FALSE) {
    if (is.null(sel) || !length(sel)) return(invisible(NULL))
    sel <- intersect(as.character(sel), .analysis_selectable_choices())
    if (!length(sel)) return(invisible(NULL))
    if (isTRUE(replace_all)) {
      sel <- sel[[1]]
    }
    prev_sel <- analysis_selected_names()
    prev_active <- .scalar_chr(shared_data$active_object_name, default = "")
    target_active <- if (length(sel) > 1 && nzchar(prev_active) && prev_active %in% sel) {
      prev_active
    } else {
      sel[[1]]
    }
    if (identical(prev_sel, sel) && identical(prev_active, target_active)) {
      return(invisible(NULL))
    }
    .perf_log("apply_analysis_selection", details = c(
      sprintf("selected=%s", paste(sel, collapse = ",")),
      sprintf("prev_active=%s", prev_active)
    ))
    analysis_prefer_integrated_boot_pending(FALSE)
    if (!identical(prev_sel, sel)) {
      analysis_selected_names(sel)
    }
    if (!identical(prev_active, target_active)) {
      analysis_object_switch_overlay_pending(TRUE)
      overlay_show("Switching analysis object...")
      shared_data$active_object_name <- target_active
    }
    .sync_analysis_selector_inputs(sel)
    if (!identical(prev_sel, sel) && length(sel) > 1) {
      showNotification(sprintf("%d objects selected. Integration will use all selected objects.", length(sel)), type = "message", duration = 3)
    }
    invisible(NULL)
  }

  .integration_target_selection <- function() {
    reg_names <- names(shared_data$all_seurat_objects %||% list())
    mode_now <- .analysis_selector_mode()
    # Canonical source is shared_data/all_objects + active object state.
    cand <- character(0)
    if (identical(mode_now, "multi") || identical(mode_now, "reintegrate")) {
      cand <- c(
        as.character(input$active_object_name_input_inline %||% character(0)),
        as.character(input$active_object_name_input_umap_inline %||% character(0))
      )
    }
    cand <- unique(cand[nzchar(cand)])
    cand <- intersect(cand, reg_names)
    if (length(cand)) return(cand)

    # Fallback to persisted analysis selection state.
    cand <- intersect(as.character(analysis_selected_names() %||% character(0)), reg_names)
    if (length(cand)) return(cand)

    # Final fallback to active object only.
    active_nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (nzchar(active_nm) && active_nm %in% reg_names) return(active_nm)
    character(0)
  }

  observeEvent(input$active_object_name_input, {
    if (isTRUE(selector_sync_in_progress())) {
      .perf_log("top_selector_change:ignored_sync_in_progress")
      return(invisible(NULL))
    }
    # When inline multi-select is active, never let the top single selector
    # collapse the selected object set back to one item.
    if (isTRUE(.analysis_normalize_multiselect_enabled())) {
      .perf_log("top_selector_change:ignored_multiselect_mode", details = sprintf("mode=%s", .analysis_selector_mode()))
      return(invisible(NULL))
    }
    if (!isTRUE(.analysis_replace_selector_enabled())) {
      .perf_log("top_selector_change:ignored_non_replace_mode", details = sprintf("mode=%s", .analysis_selector_mode()))
      return(invisible(NULL))
    }
    .perf_log("top_selector_change:apply", details = sprintf(
      "selected=%s",
      .scalar_chr(input$active_object_name_input, default = "<empty>")
    ))
    .apply_analysis_selection(input$active_object_name_input, replace_all = TRUE)
  }, ignoreInit = TRUE)

  observeEvent(input$plot_tabs, {
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) return(invisible(NULL))
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    if (nzchar(tab_now)) return(invisible(NULL))
    d <- input$plot_tabs_dom_diag
    d_active <- .scalar_chr(d$active, default = "")
    if (!is.null(d) && isTRUE(d$visible) && nzchar(d_active)) {
      return(invisible(NULL))
    }
    fallback_tab <- .scalar_chr(analysis_last_nonempty_plot_tab(), default = "normalize / integrate")
    if (!nzchar(fallback_tab)) fallback_tab <- "normalize / integrate"
    .perf_log("plot_tabs:empty_restore", details = c(
      sprintf("fallback=%s", fallback_tab),
      sprintf("active=%s", .scalar_chr(shared_data$active_object_name, default = "<empty>"))
    ))
    .go_plot_tab(fallback_tab)
    invisible(NULL)
  }, ignoreInit = FALSE)

  observeEvent(input$active_object_name_input_inline, {
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) {
      return(invisible(NULL))
    }
    if (isTRUE(selector_sync_in_progress())) {
      return(invisible(NULL))
    }
    .apply_analysis_selection(input$active_object_name_input_inline)
  }, ignoreInit = TRUE)

  observeEvent(input$active_object_name_input_umap_inline, {
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) {
      return(invisible(NULL))
    }
    if (isTRUE(selector_sync_in_progress())) {
      return(invisible(NULL))
    }
    .apply_analysis_selection(input$active_object_name_input_umap_inline)
  }, ignoreInit = TRUE)
  INTE_SUFFIX_MIN_LEN <- 2L
  INTE_SUFFIX_MAX_LEN <- 10L
  integration_pending_sel <- reactiveVal(character(0))
  integration_preflight_pending_sel <- reactiveVal(character(0))
  integration_timing <- reactiveVal(list(
    start = NULL,
    end = NULL,
    duration_sec = NULL,
    status = "idle"
  ))
  
  .fmt_ts <- function(x) {
    if (is.null(x) || length(x) == 0 || is.na(x)) return("--")
    format(as.POSIXct(x), "%Y-%m-%d %H:%M:%S")
  }
  
  .fmt_duration <- function(sec) {
    if (is.null(sec) || length(sec) == 0 || is.na(sec)) return("--")
    sec <- max(0, as.integer(round(as.numeric(sec))))
    hh <- sec %/% 3600
    mm <- (sec %% 3600) %/% 60
    ss <- sec %% 60
    sprintf("%02d:%02d:%02d", hh, mm, ss)
  }
  
  output$integration_timing_ribbon <- renderUI({
    ti <- integration_timing()
    st <- as.character(ti$status %||% "idle")
    st_label <- switch(
      st,
      running = "Running",
      success = "Completed",
      error = "Failed",
      "Not started"
    )
    div(
      class = "alert alert-info",
      style = "padding:8px 10px; margin-bottom:0;",
      tags$div(
        style = "font-size:12px;",
        tags$b("Integration timing"),
        tags$br(),
        sprintf(
          "Start: %s | End: %s | Total: %s | Status: %s",
          .fmt_ts(ti$start),
          .fmt_ts(ti$end),
          .fmt_duration(ti$duration_sec),
          st_label
        )
      )
    )
  })
  
  .inte_alias_from_name <- function(sample_name) {
    sample_txt <- toupper(as.character(sample_name %||% ""))
    gsm_hit <- regmatches(sample_txt, regexpr("GSM[0-9]+", sample_txt, perl = TRUE))
    if (length(gsm_hit) == 1L && is.character(gsm_hit) && nzchar(gsm_hit) && gsm_hit != "-1") {
      return(substr(gsm_hit, 1, INTE_SUFFIX_MAX_LEN))
    }

    tok <- unlist(strsplit(as.character(sample_name %||% ""), "_", fixed = TRUE), use.names = FALSE)
    tok <- tok[nzchar(tok)]
    if (length(tok) && grepl("^SR[0-9]+$", toupper(tok[[1]]))) tok <- tok[-1]
    if (!length(tok)) tok <- "SMP"
    enc <- vapply(tok, function(x) {
      y <- toupper(gsub("[^A-Z0-9]", "", as.character(x)))
      if (!nzchar(y)) return("")
      if (grepl("^[0-9]+$", y)) return(y)
      if (nchar(y) <= 3) return(y)
      paste0(substr(y, 1, 2), substr(y, nchar(y), nchar(y)))
    }, character(1))
    out <- paste0(enc, collapse = "")
    out <- gsub("[^A-Z0-9]", "", out)
    if (!nzchar(out)) out <- "SMP"
    substr(out, 1, INTE_SUFFIX_MAX_LEN)
  }
  
  .inte_make_unique_aliases <- function(samples) {
    raw <- vapply(samples, .inte_alias_from_name, character(1))
    used <- character(0)
    out <- character(length(raw))
    for (i in seq_along(raw)) {
      base <- raw[[i]]
      if (!nzchar(base)) base <- "SMP"
      cand <- base
      k <- 1L
      while (cand %in% used) {
        k <- k + 1L
        suffix <- as.character(k)
        keep <- max(1L, INTE_SUFFIX_MAX_LEN - nchar(suffix))
        cand <- paste0(substr(base, 1, keep), suffix)
      }
      out[[i]] <- cand
      used <- c(used, cand)
    }
    names(out) <- samples
    out
  }
  
  .inte_run <- function(sel, alias_map = NULL) {
    start_ts <- Sys.time()
    integration_timing(list(start = start_ts, end = NULL, duration_sec = NULL, status = "running"))
    .inte_overlay <- function(msg = SPINNER_OVERLAY_MESSAGE_RUN_INTE_BTN, pct = NULL) {
      overlay_show(text = msg, pct = pct)
    }
    .inte_overlay(SPINNER_OVERLAY_MESSAGE_RUN_INTE_BTN, pct = 1)
    on.exit(overlay_hide(), add = TRUE)
    
    updateTabsetPanel(session, inputId = "plot_tabs", selected = "normalize / integrate")
    reg <- shared_data$all_seurat_objects %||% list()
    sel <- intersect(as.character(sel), names(reg))
    if (!length(sel)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_no_selected, type = "error")
      return(invisible(NULL))
    }
    contam_flags <- vapply(sel, function(nm) {
      e <- reg[[nm]]
      md <- if (is.list(e)) e$meta %||% list() else list()
      isTRUE((md$stage %||% "") == "contamination_corrected") || is.list(md$contamination)
    }, logical(1))
    if (any(!contam_flags)) {
      showNotification(
        paste0(
          "Integration note: ",
          sum(contam_flags), "/", length(contam_flags),
          " selected object(s) are contamination-corrected."
        ),
        type = "message",
        duration = 8
      )
    }
    
    seurat_obj <- NULL
    if (length(sel) == 1) {
      seurat_obj <- .get_obj_from_entry(reg[[sel[[1]]]])
    } else {
      objs <- lapply(sel, function(nm) .get_obj_from_entry(reg[[nm]]))
      if (any(!vapply(objs, inherits, logical(1), what = "Seurat"))) {
        showNotification("Some selected entries are not valid Seurat objects.", type = "error")
        return(invisible(NULL))
      }
      ids <- sel
      if (!is.null(alias_map)) {
        ids <- unname(alias_map[sel])
      }
      if (!length(ids) || length(ids) != length(sel) || any(!nzchar(ids)) || anyDuplicated(ids)) {
        showNotification(ANALYSIS_UI_TEXT$t_text_integration_invalid_suffix_map, type = "error")
        return(invisible(NULL))
      }
      seurat_obj <- tryCatch({
        objs <- Map(function(obj, nm) {
          obj$orig.ident <- nm
          obj
        }, objs, sel)
        if (length(objs) == 2L) {
          merge(x = objs[[1]], y = objs[[2]], add.cell.ids = ids, project = "analysis_temp")
        } else {
          merge(x = objs[[1]], y = objs[-1], add.cell.ids = ids, project = "analysis_temp")
        }
      }, error = function(e) {
        showNotification(paste("Failed to combine selected objects for integration:", e$message), type = "error", duration = 8)
        NULL
      })
      if (is.null(seurat_obj)) return(invisible(NULL))
    }
    if (is.null(seurat_obj)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_data_invalid, type = "error")
      return(invisible(NULL))
    }
    .count_groups <- function(obj, col_name) {
      col_name <- .scalar_chr(col_name, default = "")
      md <- tryCatch(obj@meta.data, error = function(e) NULL)
      if (!nzchar(col_name) || is.null(md) || !is.data.frame(md) || !col_name %in% colnames(md)) {
        return(list(ok = FALSE, n = 0L, levels = character(0)))
      }
      vals <- as.character(md[[col_name]])
      vals[is.na(vals) | !nzchar(vals)] <- "NA"
      lv <- sort(unique(vals))
      list(ok = TRUE, n = length(lv), levels = lv)
    }
    integrate_by_now <- .scalar_chr(input$integrate_by_var, default = "")
    grp_diag <- .count_groups(seurat_obj, integrate_by_now)
    if (!isTRUE(grp_diag$ok)) {
      showNotification(
        sprintf(
          "Integration precheck failed: selected %d object(s), but metadata column '%s' is missing.",
          length(sel),
          integrate_by_now
        ),
        type = "error",
        duration = NULL
      )
      return(invisible(NULL))
    }
    if (grp_diag$n < 2L) {
      showNotification(
        sprintf(
          "Integration precheck failed: selected %d object(s) [%s], '%s' has %d group (%s).",
          length(sel),
          paste(sel, collapse = ", "),
          integrate_by_now,
          grp_diag$n,
          paste(head(grp_diag$levels, 5), collapse = ", ")
        ),
        type = "error",
        duration = NULL
      )
      return(invisible(NULL))
    }
    
    original_lib_paths <- .libPaths(); .libPaths(c(shared_data$active_environment$path, original_lib_paths))
    on.exit({ .libPaths(original_lib_paths) }, add = TRUE)
    
    prog <- NULL
    on.exit({
      if (!is.null(prog)) prog$close()
    }, add = TRUE)
    prog_val <- 0L
    .open_prog <- function() {
      if (is.null(prog)) {
        prog <<- shiny::Progress$new(session, min = 0, max = 100)
        prog_val <<- 1L
        .inte_overlay(sprintf("Integrating (%s)…", input$inte_method), pct = prog_val)
        prog$set(
          message = sprintf("Integrating (%s)…", input$inte_method),
          detail = "Running…",
          value = prog_val
        )
      }
    }
    .advance <- function(detail_txt, add = 2L) {
      .open_prog()
      prog_val <<- min(99L, prog_val + as.integer(add))
      .inte_overlay(sprintf("Integrating (%s)… %s", input$inte_method, detail_txt), pct = prog_val)
      prog$set(message = sprintf("Integrating (%s)…", input$inte_method),
               detail  = detail_txt,
               value   = prog_val)
    }
    
    tryCatch({
      env_name <- tolower(as.character(shared_data$active_environment$name %||% ""))
      if (!(env_name %in% c("seurat4", "seurat5"))) {
        stop("Active environment must be either 'seurat4' or 'seurat5'.")
      }
      
      integrated_obj <- withCallingHandlers(
        core_analysis_tab_a_run_integration(
          seurat_obj   = seurat_obj,
          method       = input$inte_method,
          integrate_by = input$integrate_by_var,
          barcode_suffix = list(enabled = FALSE, delimiter = "_")
        ),
        message = function(m) {
          .advance(conditionMessage(m), add = 2L)
          invokeRestart("muffleMessage")
        }
      )
      
      if (length(sel) > 1) {
        out_base <- paste0("integrated_", format(Sys.time(), "%Y%m%d_%H%M%S"))
        out_name <- out_base
        idx <- 1L
        while (out_name %in% names(shared_data$all_seurat_objects)) {
          out_name <- paste0(out_base, "_", idx)
          idx <- idx + 1L
        }
        shared_data$all_seurat_objects[[out_name]] <- list(
          obj = integrated_obj$object,
          prefs = list(),
          plots = list(elbow = integrated_obj$elbow_plot),
          analysis_cache = list(),
          meta = list(
            stage = "integrated",
            parents = sel,
            barcode_suffix_map = if (is.null(alias_map)) NULL else as.list(alias_map[sel]),
            barcode_suffix_delimiter = "_",
            created = Sys.time()
          )
        )
        shared_data$active_object_name <- out_name
        analysis_selected_names(out_name)
      } else {
        nm <- sel[[1]]
        if (is.null(shared_data$all_seurat_objects[[nm]]$plots) || !is.list(shared_data$all_seurat_objects[[nm]]$plots)) {
          shared_data$all_seurat_objects[[nm]]$plots <- list()
        }
        if (is.null(shared_data$all_seurat_objects[[nm]]$prefs) || !is.list(shared_data$all_seurat_objects[[nm]]$prefs)) {
          shared_data$all_seurat_objects[[nm]]$prefs <- list()
        }
        if (is.null(shared_data$all_seurat_objects[[nm]]$analysis_cache) || !is.list(shared_data$all_seurat_objects[[nm]]$analysis_cache)) {
          shared_data$all_seurat_objects[[nm]]$analysis_cache <- list()
        }
        shared_data$all_seurat_objects[[nm]]$obj         <- integrated_obj$object
        shared_data$all_seurat_objects[[nm]]$plots$elbow <- integrated_obj$elbow_plot
        .sync_active_elbow_preview(nm, shared_data$all_seurat_objects[[nm]])
        shared_data$active_object_name <- nm
      }
      analysis_reintegration_enabled(FALSE)
      
      if (!is.null(prog)) prog$set(detail = "Integration complete. Updating elbow…", value = 100)
      .inte_overlay("Integration complete. Updating elbow…", pct = 100)
      end_ts <- Sys.time()
      integration_timing(list(
        start = start_ts,
        end = end_ts,
        duration_sec = as.numeric(difftime(end_ts, start_ts, units = "secs")),
        status = "success"
      ))
      showNotification("Integration complete. Elbow plot updated.", type = "message")
    }, error = function(e) {
      if (!is.null(prog)) prog$set(detail = paste("Integration error:", e$message), value = 100)
      .inte_overlay("Integration failed.", pct = 100)
      end_ts <- Sys.time()
      integration_timing(list(
        start = start_ts,
        end = end_ts,
        duration_sec = as.numeric(difftime(end_ts, start_ts, units = "secs")),
        status = "error"
      ))
      showNotification(paste("Integration error:", e$message), type = "error", duration = NULL)
    })
    
    invisible(NULL)
  }

  .integration_total_cells <- function(sel, reg) {
    vals <- vapply(sel, function(nm) {
      obj <- tryCatch(.get_obj_from_entry(reg[[nm]]), error = function(e) NULL)
      if (inherits(obj, "Seurat")) {
        nc <- tryCatch(ncol(obj), error = function(e) NA_integer_)
        if (is.finite(nc)) return(as.integer(nc))
      }
      0L
    }, integer(1))
    sum(as.integer(vals), na.rm = TRUE)
  }

  .integration_begin_suffix_or_run <- function(sel, reg) {
    sel <- intersect(as.character(sel %||% character(0)), names(reg %||% list()))
    if (!length(sel)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_no_selected, type = "error")
      return(invisible(NULL))
    }
    if (length(sel) == 1L) {
      .inte_run(sel = sel, alias_map = NULL)
      return(invisible(NULL))
    }

    proposed <- .inte_make_unique_aliases(sel)
    preview <- vapply(sel, function(nm) {
      obj <- .get_obj_from_entry(reg[[nm]])
      x <- tryCatch(colnames(obj)[1], error = function(e) NA_character_)
      if (!is.character(x) || is.na(x) || !nzchar(x)) return("AAACCTGAGTAC")
      x
    }, character(1))
    integration_pending_sel(sel)

    showModal(modalDialog(
      title = ANALYSIS_UI_TEXT$t_title_integration_suffix_confirm,
      size = "l",
      easyClose = FALSE,
      class = "analysis-integration-suffix-modal",
      tagList(
        tags$style(HTML("
          .analysis-integration-suffix-modal .modal-dialog{
            width: min(1600px, 96vw);
            max-width: min(1600px, 96vw);
          }
          .analysis-integration-suffix-modal .modal-body{
            max-height: 72vh;
            overflow-y: auto;
          }
          .analysis-integration-suffix-modal code{
            white-space: normal;
            word-break: break-all;
          }
        ")),
        p(ANALYSIS_UI_TEXT$t_text_integration_suffix_explain),
        p(ANALYSIS_UI_TEXT$t_text_integration_suffix_warning),
        p(ANALYSIS_UI_TEXT$t_text_integration_suffix_rules),
        tags$hr(),
        do.call(tagList, lapply(seq_along(sel), function(i) {
          nm <- sel[[i]]
          input_id <- paste0("integration_suffix_", i)
          fluidRow(
            column(5, tags$strong(nm)),
            column(3, textInput(input_id, ANALYSIS_UI_TEXT$t_label_integration_suffix, value = proposed[[nm]])),
            column(4, tags$code(sprintf("%s_%s", preview[[nm]], proposed[[nm]])))
          )
        }))
      ),
      footer = tagList(
        modalButton("Cancel"),
        actionButton("confirm_integration_suffix_btn", ANALYSIS_UI_TEXT$t_btn_integration_suffix_apply, class = "btn btn-primary")
      )
    ))

    suffix_ids <- paste0("integration_suffix_", seq_along(sel))
    shinyjs::runjs(sprintf(
      "['%s'].forEach(function(id){var el=document.getElementById(id); if(el){el.maxLength=%d;}});",
      paste(suffix_ids, collapse = "','"),
      INTE_SUFFIX_MAX_LEN
    ))
    invisible(NULL)
  }
  
  # ================== ACTIONS (overlay + toasts) ==================
  
  observeEvent(input$run_norm_btn, {
    overlay_show(SPINNER_OVERLAY_MESSAGE_RUN_NORM_BTN); on.exit(overlay_hide(), add = TRUE)
    
    updateTabsetPanel(session, inputId = "plot_tabs", selected = "normalize / integrate")
    seurat_obj <- active_seurat_object()$obj
    if (is.null(seurat_obj)) showNotification("Data invalid for normalization.", type = "error")
    req(seurat_obj)
    
    showNotification("Running normalization…", type = "message", duration = 5)
    original_lib_paths <- .libPaths(); .libPaths(c(shared_data$active_environment$path, original_lib_paths))
    tryCatch({
      norm_results <- core_analysis_tab_a_run_normalization(seurat_obj = seurat_obj, method = input$norm_method)
      nm <- shared_data$active_object_name
      shared_data$all_seurat_objects[[nm]]$obj <- norm_results$object
      shared_data$all_seurat_objects[[nm]]$plots$elbow <- norm_results$elbow_plot
      .sync_active_elbow_preview(nm, shared_data$all_seurat_objects[[nm]])
      showNotification("Normalization complete. Check the Elbow above.", type = "message")
    }, error = function(e) {
      showNotification(paste("Normalization error:", e$message), type = "error", duration = NULL)
    }, finally = { .libPaths(original_lib_paths) })
  })
  
  observeEvent(input$run_inte_btn, {
    reg <- shared_data$all_seurat_objects %||% list()
    prof <- .analysis_selection_profile()
    inobject_active <- isTRUE(.analysis_inobject_reintegrate_active())
    reintegrate_mode <- identical(.analysis_selector_mode(), "reintegrate")
    if (!isTRUE(reintegrate_mode) && isTRUE(prof$mixed)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_mixed_selection_error, type = "error", duration = NULL)
      return()
    }
    if (!isTRUE(reintegrate_mode) && isTRUE(prof$integrated_multi)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_integrated_multi_error, type = "error", duration = NULL)
      return()
    }
    if (isTRUE(prof$integrated_single) && !isTRUE(inobject_active)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_integrated_switch_required, type = "warning", duration = NULL)
      return()
    }
    if (identical(.analysis_selector_mode(), "replace") &&
        isTRUE(.analysis_show_reintegrate_entry()) &&
        !isTRUE(prof$non_integrated_only) &&
        !isTRUE(inobject_active)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_enable_reintegration, type = "warning")
      return()
    }
    sel <- .integration_target_selection()
    sel <- intersect(as.character(sel), names(reg))
    if (!length(sel)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_no_selected, type = "error")
      return()
    }
    method_now <- .scalar_chr(input$inte_method, default = "CCA")
    total_cells <- .integration_total_cells(sel, reg)
    n_objs <- length(sel)
    .perf_log("integration_preflight", details = c(
      sprintf("method=%s", method_now),
      sprintf("objects=%d", n_objs),
      sprintf("cells=%d", total_cells),
      sprintf("selected=%s", paste(sel, collapse = ","))
    ))

    if (identical(method_now, "SCT") && total_cells >= 220000L) {
      showNotification(
        paste0(
          "Integration preflight blocked: SCT selected ", n_objs, " object(s), ",
          format(total_cells, big.mark = ","), " cells. This exceeds the safe memory range for this workflow. ",
          "Use RPCA/Harmony or integrate in smaller batches."
        ),
        type = "error",
        duration = NULL
      )
      return()
    }

    if (identical(method_now, "SCT") && (n_objs >= 10L || total_cells >= 120000L)) {
      integration_preflight_pending_sel(sel)
      showModal(modalDialog(
        title = "High-memory integration preflight",
        easyClose = FALSE,
        footer = tagList(
          modalButton("Cancel"),
          actionButton("confirm_integration_preflight_btn", "Continue anyway", class = "btn btn-warning")
        ),
        p(sprintf("Method: %s", method_now)),
        p(sprintf("Selected objects: %d", n_objs)),
        p(sprintf("Estimated total cells: %s", format(total_cells, big.mark = ","))),
        p("Risk: this run may be killed by macOS under memory pressure (exit 137 / Killed:9)."),
        p("Recommendation: switch to RPCA/Harmony or split into smaller batches.")
      ))
      return()
    }

    .integration_begin_suffix_or_run(sel = sel, reg = reg)
  }, ignoreInit = TRUE)

  observeEvent(input$confirm_integration_preflight_btn, {
    sel <- integration_preflight_pending_sel()
    integration_preflight_pending_sel(character(0))
    removeModal()
    reg <- shared_data$all_seurat_objects %||% list()
    .integration_begin_suffix_or_run(sel = sel, reg = reg)
  }, ignoreInit = TRUE)
  
  observeEvent(input$confirm_integration_suffix_btn, {
    sel <- integration_pending_sel()
    req(length(sel) > 1)
    
    raw_aliases <- vapply(seq_along(sel), function(i) {
      trimws(as.character(input[[paste0("integration_suffix_", i)]] %||% ""))
    }, character(1))
    aliases <- toupper(raw_aliases)
    if (any(raw_aliases != aliases)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_suffix_autoupper, type = "message", duration = 3)
    }
    
    if (any(!nzchar(aliases))) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_suffix_empty, type = "error", duration = 6)
      return()
    }
    if (any(nchar(aliases) < INTE_SUFFIX_MIN_LEN | nchar(aliases) > INTE_SUFFIX_MAX_LEN)) {
      showNotification(sprintf(ANALYSIS_UI_TEXT$t_text_integration_suffix_length, INTE_SUFFIX_MIN_LEN, INTE_SUFFIX_MAX_LEN), type = "error", duration = 6)
      return()
    }
    if (any(!grepl("^[A-Z0-9]+$", aliases))) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_suffix_charset, type = "error", duration = 6)
      return()
    }
    if (anyDuplicated(aliases)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_integration_suffix_unique, type = "error", duration = 6)
      return()
    }
    
    alias_map <- setNames(aliases, sel)
    removeModal()
    integration_pending_sel(character(0))
    .inte_run(sel = sel, alias_map = alias_map)
  }, ignoreInit = TRUE)

  output$clustertree_plot <- renderPlot({
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    req(nzchar(nm))
    sobj <- .get_active_sobj(shared_data)
    req(!is.null(sobj))
    .ensure_cluster_sweep_cache_for_object(nm, sobj = sobj)
    cache <- tryCatch(shared_data$all_seurat_objects[[nm]]$analysis_cache$cluster_sweep, error = function(e) NULL)

    if (!is.list(cache) || is.null(cache$resolutions) || !length(cache$resolutions)) {
      grid::grid.newpage()
      grid::grid.text("ClusterTree not available yet", x = 0.02, y = 0.98, just = c("left","top"))
      return(invisible(NULL))
    }

    ran <- sort(unique(suppressWarnings(as.numeric(cache$resolutions %||% numeric()))))
    ran <- ran[is.finite(ran)]
    if (!length(ran)) {
      grid::grid.newpage()
      grid::grid.text("ClusterTree not available yet", x = 0.02, y = 0.98, just = c("left","top"))
      return(invisible(NULL))
    }
    gname <- cache$graph
    dims <- suppressWarnings(as.integer(cache$dims %||% .effective_dims(nm = nm, allow_slider_fallback = FALSE)))
    if (!is.finite(dims) || is.na(dims) || dims < 2L) dims <- .effective_dims(nm = nm, allow_slider_fallback = FALSE)

    plt <- cache$plot
    if (is.null(plt)) {
      plt <- tryCatch(
        {
          options(ct_debug_dump = TRUE)
          .compact_clustertree_plot(.run_clustertree(sobj, res_vec = ran, graph_name = gname, dims = dims))
        },
        error = function(e) {
          message("[ClusterTree] error in .run_clustertree: ", conditionMessage(e))
          NULL
        }
      )
      shared_data$all_seurat_objects[[nm]]$analysis_cache$cluster_sweep$plot <- plt
    }

    if (is.null(plt)) {
      grid::grid.newpage()
      grid::grid.text("ClusterTree error – see R console/log", x = 0.02, y = 0.98, just = c("left","top"))
      return(invisible(NULL))
    }
    .compact_clustertree_plot(plt)
  }, height = function() {
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    cache <- tryCatch(shared_data$all_seurat_objects[[nm]]$analysis_cache$cluster_sweep, error = function(e) NULL)
    .ct_plot_height_from_cache(cache)
  })

  output$clustertree_plot_ui <- renderUI({
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    cache <- tryCatch(shared_data$all_seurat_objects[[nm]]$analysis_cache$cluster_sweep, error = function(e) NULL)
    h <- .ct_plot_height_from_cache(cache)
    plotOutput("clustertree_plot", height = paste0(h, "px"), width = "100%")
  })

  output$clustertree_summary_dt <- DT::renderDataTable({
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(nm)) {
      return(DT::datatable(data.frame(note = "No active object."), rownames = FALSE, options = list(dom = "t")))
    }
    sobj <- .get_active_sobj(shared_data)
    req(!is.null(sobj))
    .ensure_cluster_sweep_cache_for_object(nm, sobj = sobj)
    cache <- tryCatch(shared_data$all_seurat_objects[[nm]]$analysis_cache$cluster_sweep, error = function(e) NULL)
    sm <- if (is.list(cache) && is.data.frame(cache$summary) && nrow(cache$summary)) cache$summary else .build_cluster_sweep_summary(sobj, cache$resolutions %||% numeric())
    if (is.null(sm) || !is.data.frame(sm) || !nrow(sm)) {
      return(DT::datatable(data.frame(note = "No sweep summary available yet."), rownames = FALSE, options = list(dom = "t")))
    }
    DT::datatable(sm, options = list(dom = "t", paging = FALSE), rownames = FALSE)
  }, server = FALSE)

  output$final_res_picker_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data)
    if (is.null(sobj)) return(NULL)
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    cache_res <- tryCatch(shared_data$all_seurat_objects[[nm]]$analysis_cache$cluster_sweep$resolutions, error = function(e) NULL)
    choices <- .resolution_values(sobj, cache_res = cache_res)
    if (!length(choices)) return(helpText(ANALYSIS_UI_TEXT$t_text_no_resolution_available_yet_run_clustering_resolution_sweep_first))
    selected <- .scalar_chr(input$final_res_select %||% tail(choices, 1), default = as.character(tail(choices, 1)))
    if (!selected %in% as.character(choices)) selected <- as.character(tail(choices, 1))
    selectInput("final_res_select", ANALYSIS_UI_TEXT$t_label_pick_final_resolution, choices = choices, selected = selected)
  })
  
  observeEvent(input$run_sweep_btn, {
    .sweep_overlay <- function(msg = SPINNER_OVERLAY_MESSAGE_RUN_SWEEP_BTN, pct = NULL) {
      overlay_show(text = msg, pct = pct)
    }
    .sweep_overlay(SPINNER_OVERLAY_MESSAGE_RUN_SWEEP_BTN, pct = 1)
    on.exit(overlay_hide(), add = TRUE)
    
    sobj <- .get_active_sobj(shared_data); req(sobj)
    # Recompute UMAP config only when user explicitly runs sweep.
    sobj <- .sync_umap_for_current_cfg(sobj)
    ran <- seq(from = input$sweep_res_min, to = input$sweep_res_max, by = input$sweep_res_step)
    ran <- unique(round(ran, 2))
    
    have_cols <- .find_resolution_columns(sobj)
    if (length(have_cols)) {
      have_vals <- sort(unique(vapply(have_cols, .parse_res_value, numeric(1))))
      ran <- sort(unique(c(ran, have_vals)))
    }
    
    gname <- input$sweep_graph %||% NULL
    # if no graph was selected / no graphs existed yet, create a dedicated sweep graph
    if (is.null(gname) || !nzchar(gname)) {
      gname <- "sweep_nn"
    }
    
    dims  <- .effective_dims()
    
    # --- progress (top-right) ------------------------------------------
    p <- shiny::Progress$new(session, min = 0, max = 100)
    on.exit(p$close(), add = TRUE)
    bump <- function(i, of, txt) {
      # keep some headroom for the clustertree build
      val <- min(95, round((i / of) * 85))
      .sweep_overlay(sprintf("Resolution sweep… %s", txt), pct = val)
      p$set(value = val, message = "Resolution sweep…", detail = txt)
      session$sendCustomMessage("dummy", list())  # lightweight yield hack
    }
    .sweep_overlay("Resolution sweep… Starting…", pct = 1)
    p$set(message = "Resolution sweep…", detail = "Starting…", value = 0)
    
    # --- run sweep (FOR loop so we can message each step) --------------
    info <- vector("list", length(ran))
    for (i in seq_along(ran)) {
      r <- ran[i]
      bump(i, length(ran), sprintf("res = %.2f → neighbors + clusters", r))
      message(sprintf("sweep: computing neighbors/clusters at res=%.2f", r))
      showNotification(sprintf("Sweeping resolution %.2f…", r), type = "message", duration = 2)
      res <- .ensure_clusters_at_resolution(sobj, r, graph_name = gname, dims = dims)
      sobj <- res$sobj
      
      nclu <- tryCatch(length(levels(Seurat::Idents(sobj))), error = function(e) NA_integer_)
      info[[i]] <- data.frame(resolution = r, colname = res$colname, n_clusters = nclu, created = res$created)
    }
    
    summary_df <- do.call(rbind, info)
    
    p$set(message = "Resolution sweep…", detail = "Building ClusterTree…", value = 95)
    .sweep_overlay("Resolution sweep… Building ClusterTree…", pct = 95)
    # build plot (using your single-source clustertree file)
    
    ct_plot <- tryCatch(
      {
        options(ct_debug_dump = TRUE)
        .compact_clustertree_plot(.run_clustertree(sobj, res_vec = ran, graph_name = gname, dims = dims))
      },
      error = function(e) {
        message("[ClusterTree] error during sweep build: ", conditionMessage(e))
        NULL
      }
    )
    
    nm <- shared_data$active_object_name
    shared_data$all_seurat_objects[[nm]]$obj <- sobj
    shared_data$all_seurat_objects[[nm]]$analysis_cache$cluster_sweep <- list(
      resolutions = ran, graph = gname, dims = dims, summary = summary_df, plot = ct_plot
    )

    # mark sweep ready (if you use the guard)
    .sweep_ready(TRUE)
    
    p$set(detail = "Done.", value = 100)
    .sweep_overlay("Resolution sweep… Done.", pct = 100)
    showNotification("Resolution sweep finished.", type = "message")
  })
  
  observeEvent(input$apply_final_res_btn, {
    overlay_show(); on.exit(overlay_hide(), add = TRUE)
    
    sobj <- .get_active_sobj(shared_data); req(sobj, input$final_res_select)
    gname <- input$sweep_graph %||% NULL
    dims  <- .effective_dims()
    res   <- as.numeric(input$final_res_select)
    ensured <- .ensure_clusters_at_resolution(sobj, res, graph_name = gname, dims = dims)
    sobj <- ensured$sobj
    if (!"umap" %in% tolower(names(sobj@reductions))) {
      sobj <- tryCatch(Seurat::RunUMAP(sobj, dims = 1:dims, verbose = FALSE), error = function(e) sobj)
    }
    nm <- shared_data$active_object_name
    shared_data$all_seurat_objects[[nm]]$obj <- sobj
    shared_data$all_seurat_objects[[nm]]$prefs$final_resolution <- res
    shared_data$all_seurat_objects[[nm]]$plots$default_reduction <- "umap"
    showNotification(sprintf("Applied final resolution: %.2f", res), type = "message")
  })
  
  observeEvent(input$run_main_analysis_btn, {
    overlay_show(); on.exit(overlay_hide(), add = TRUE)
    
    seurat_obj <- active_seurat_object()$obj
    if (is.null(seurat_obj)) showNotification("Data invalid for clustering.", type = "error")
    req(seurat_obj)
    
    seed_value <- suppressWarnings(as.numeric(input$cfg_seed_input %||% 42))
    if (is.na(seed_value) || seed_value <= 0 || floor(seed_value) != seed_value) {
      showNotification("UMAP seed must be a positive whole number.", type = "error"); return()
    }
    updateTabsetPanel(session, inputId = "plot_tabs", selected = "clustering resolution")
    
    analysis_params <- list(
      num_pcs   = input$cluster_num_pcs,
      resolution= input$cluster_resolution,
      umap_seed = seed_value
    )
    
    original_lib_paths <- .libPaths(); .libPaths(c(shared_data$active_environment$path, original_lib_paths))
    tryCatch({
      final_results <- core_analysis_tab_c_run_main_analysis(seurat_obj = seurat_obj, analysis_params = analysis_params)
      nm <- shared_data$active_object_name
      shared_data$all_seurat_objects[[nm]]$obj <- final_results$final_object
      shared_data$all_seurat_objects[[nm]]$plots$clusters   <- final_results$clusters
      shared_data$all_seurat_objects[[nm]]$plots$conditions <- final_results$conditions
      shared_data$all_seurat_objects[[nm]]$plots$default_reduction <- "umap"
      showNotification("UMAP analysis complete.", type = "message")
    }, error = function(e) {
      showNotification(paste("Clustering/UMAP error:", e$message), type="error", duration = NULL)
    }, finally = { .libPaths(original_lib_paths) })
  })
  
  # -------- SCT/scale reminder (in normalize tab)
  output$prep_sct_scale_reminder <- renderUI({
    entry <- .get_active_entry(shared_data)
    if (!isTRUE(.entry_has_analysis_embedding_state(entry))) return(NULL)
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    
    .has_nonempty_matrix <- function(m) {
      ok <- is.matrix(m) || inherits(m, "Matrix")
      if (!ok) return(FALSE)
      if (nrow(m) == 0 || ncol(m) == 0) return(FALSE)
      nz <- tryCatch({
        if (inherits(m, "Matrix")) Matrix::nnzero(m) > 0 else any(m != 0)
      }, error = function(...) FALSE)
      nz
    }
    
    assays <- tryCatch(Seurat::Assays(sobj), error = function(e) character())
    def_assay <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) NA_character_)
    analysis_assays <- c("RNA", "SCT", "integrated")
    if (!is.na(def_assay) && nzchar(def_assay) && !def_assay %in% assays) {
      def_assay <- NA_character_
    }
    if (is.na(def_assay) || !nzchar(def_assay) || !tolower(def_assay) %in% tolower(analysis_assays)) {
      fallback <- analysis_assays[tolower(analysis_assays) %in% tolower(assays)]
      def_assay <- if (length(fallback)) fallback[[1]] else def_assay
    }
    has_scaled <- FALSE
    if (is.character(def_assay) && nzchar(def_assay)) {
      has_scaled <- tryCatch({
        m <- .analysis_get_assay_data(sobj, assay = def_assay, layer = "scale.data")
        .has_nonempty_matrix(m)
      }, error = function(e) FALSE)
    }
    
    has_sct_populated <- FALSE
    if ("SCT" %in% assays) {
      has_sct_populated <- tryCatch({
        md <- .analysis_get_assay_data(sobj, assay = "SCT", layer = "data")
        mv <- tryCatch(length(Seurat::VariableFeatures(sobj[["SCT"]])) > 0, error = function(e) FALSE)
        .has_nonempty_matrix(md) || mv
      }, error = function(e) FALSE)
    }
    
    if (!(has_scaled || has_sct_populated)) return(NULL)
    
    div(
      class = "alert alert-info", role = "alert",
      HTML(paste0(
        "<b>Heads up:</b> Detected ",
        paste0(c(
          if (has_scaled) "non-empty <code>scale.data</code> in the default assay",
          if (has_sct_populated) "a populated <code>SCT</code> assay"
        ), collapse = " and "),
        ". You might not need to re-run Normalize/Scale. Proceed only if you intend to overwrite."
      ))
    )
  })
  
  # render elbow UI (returns NULL when not ready → no placeholder)
  output$prep_elbow_ui <- renderUI({
    snapshot <- analysis_active_elbow_preview()
    div(
      class = "elbow-preview-box elbow-preview-shell",
      if (isTRUE(snapshot$ready)) {
        plotOutput("prep_elbow_plot", height = "100%", width = "100%")
      } else {
        div(class = "elbow-preview-placeholder")
      }
    )
  })
  output$prep_elbow_plot <- renderPlot({
    snapshot <- analysis_active_elbow_preview()
    nm <- .scalar_chr(snapshot$object_name, default = "")
    .perf_log("prep_elbow_plot:render", details = sprintf("object=%s", .scalar_chr(nm, default = "<empty>")))
    p <- snapshot$plot
    if (is.null(p)) {
      .perf_log("prep_elbow_plot:unavailable", details = sprintf("object=%s", .scalar_chr(nm, default = "<empty>")))
      plot.new()
      title("PCA elbow preview unavailable.")
      return(invisible(NULL))
    }
    p_final <- tryCatch({
      p +
        ggplot2::scale_x_continuous(
          breaks = scales::pretty_breaks(n = 10),
          minor_breaks = function(lims) seq(floor(lims[1]), ceiling(lims[2]), by = 1)
        ) +
        ggplot2::theme(
          panel.grid.major = ggplot2::element_line(color = "#d1d5db", linewidth = 0.45),
          panel.grid.minor = ggplot2::element_line(color = "#e5e7eb", linewidth = 0.3)
        )
    }, error = function(e) {
      .perf_log("prep_elbow_plot:error", details = c(
        sprintf("object=%s", .scalar_chr(nm, default = "<empty>")),
        sprintf("message=%s", conditionMessage(e))
      ))
      NULL
    })
    if (is.null(p_final)) {
      plot.new()
      title("PCA elbow preview unavailable.")
      return(invisible(NULL))
    }
    suppressWarnings(print(p_final))
  })
  .generate_elbow_for_active <- function() {
    nm <- shared_data$active_object_name
    req(nm)
    entry <- shared_data$all_seurat_objects[[nm]]
    req(entry)
    
    sobj <- .get_obj_from_entry(entry)
    req(sobj)
    overlay_show(SPINNER_OVERLAY_MESSAGE_GENERATE_ELBOW)
    on.exit({
      try(overlay_hide_when_output_ready("prep_elbow_plot", timeout_ms = 120000L), silent = TRUE)
    }, add = TRUE)
    
    tryCatch({
      reds <- tolower(tryCatch(names(sobj@reductions), error = function(e) character()))
      have_pca <- "pca" %in% reds
      
      if (!have_pca) {
        vf <- tryCatch(Seurat::VariableFeatures(sobj), error = function(e) character())
        if (!length(vf)) {
          mat <- .analysis_get_assay_data(sobj, layer = "data")
          if (is.null(mat)) mat <- .analysis_get_assay_data(sobj, layer = "counts")
          if (!is.null(mat) && nrow(mat) > 0) vf <- rownames(mat)[seq_len(min(2000L, nrow(mat)))]
        }
        if (!length(vf)) stop("No features available to run PCA for elbow generation.")
        npcs <- min(50L, max(20L, as.integer(.effective_dims() %||% 30L)))
        sobj <- Seurat::RunPCA(sobj, features = vf, npcs = npcs, verbose = FALSE)
      }
      
      elbow_plot <- .analysis_build_elbow_plot(sobj)
      if (is.null(elbow_plot)) stop("Unable to generate elbow plot from PCA standard deviations.")
      
      if (is.list(entry) && !is.null(entry$obj)) {
        shared_data$all_seurat_objects[[nm]]$obj <- sobj
        if (is.null(shared_data$all_seurat_objects[[nm]]$plots)) {
          shared_data$all_seurat_objects[[nm]]$plots <- list()
        }
        shared_data$all_seurat_objects[[nm]]$plots$elbow <- elbow_plot
        .sync_active_elbow_preview(nm, shared_data$all_seurat_objects[[nm]])
      } else {
        shared_data$all_seurat_objects[[nm]] <- list(
          obj = sobj,
          prefs = list(),
          plots = list(elbow = elbow_plot),
          analysis_cache = list()
        )
        .sync_active_elbow_preview(nm, shared_data$all_seurat_objects[[nm]])
      }
      
      showNotification("Elbow plot generated. You can adjust dims again.", type = "message")
    }, error = function(e) {
      showNotification(paste("Failed to generate elbow plot:", e$message), type = "error", duration = NULL)
    })
  }
  
  observeEvent(input$prep_generate_elbow_btn, {
    .generate_elbow_for_active()
  }, ignoreInit = TRUE)
  
  # 2) Toggle by selector mode + sample count (which card should exist at all)
  observe({
    .refresh_normalize_integration_visibility()
  })
  
  # -------- ClusterTree/UMAP helpers and outputs
  observeEvent(input$sweep_preset, {
    switch(input$sweep_preset,
           typ   = { updateSliderInput(session, "sweep_res_min", value = 0.4);
             updateSliderInput(session, "sweep_res_max", value = 1.2);
             updateSliderInput(session, "sweep_res_step", value = 0.2) },
           broad = { updateSliderInput(session, "sweep_res_min", value = 0.2);
             updateSliderInput(session, "sweep_res_max", value = 3.0);
             updateSliderInput(session, "sweep_res_step", value = 0.2) },
           fine  = { updateSliderInput(session, "sweep_res_min", value = 0.2);
             updateSliderInput(session, "sweep_res_max", value = 1.2);
             updateSliderInput(session, "sweep_res_step", value = 0.1) },
           custom = {})
  })
  
  output$sweep_graph_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    g <- tryCatch(names(sobj@graphs), error = function(e) character())
    if (!length(g)) return(helpText(ANALYSIS_UI_TEXT$t_text_no_stored_neighbor_graphs_will_compute_needed))
    selectInput("sweep_graph", ANALYSIS_UI_TEXT$t_label_graph, choices = g, selected = g[1])
  })
  output$cfg_plot_format_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data)
    sel_now <- .scalar_chr(input$cfg_plot_format, default = "")
    reds <- if (!is.null(sobj) && inherits(sobj, "Seurat")) .cfg_plot_reduction_choices(sobj) else character(0)
    if (!length(reds)) reds <- c("umap", "tsne")
    labels <- if (!is.null(sobj) && inherits(sobj, "Seurat")) {
      vapply(reds, function(red) .reduction_pca_dims_label(sobj, red), character(1))
    } else {
      vapply(reds, function(red) if (grepl("tsne", tolower(red), fixed = TRUE)) "TSNE_PCA" else "UMAP_PCA", character(1))
    }
    if (!nzchar(sel_now) || !(sel_now %in% reds)) sel_now <- reds[[1]]
    selectInput(
      "cfg_plot_format",
      ANALYSIS_UI_TEXT$t_label_plot_format,
      choices = stats::setNames(reds, labels),
      selected = sel_now,
      selectize = FALSE
    )
  })

  output$cfg_color_by_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    cols <- .meta_columns_for_color(sobj)
    if (!length(cols)) return(NULL)
    selectInput("cfg_color_by", ANALYSIS_UI_TEXT$t_label_color, choices = cols, selected = cols[1])
  })

  output$cfg_split_by_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    cols <- colnames(sobj@meta.data)
    preferred <- c("condition", "orig.ident", "batch", "sample", "sample_name")
    keep <- unique(c(preferred[preferred %in% cols], cols))
    choices <- c("None" = "__none__")
    for (nm in keep) choices[[nm]] <- nm
    selectInput("cfg_split_by", ANALYSIS_UI_TEXT$t_label_split, choices = choices, selected = "__none__")
  })
  output$cfg_split_by_secondary_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    cols <- colnames(sobj@meta.data)
    preferred <- c("condition", "orig.ident", "batch", "sample", "sample_name")
    keep <- unique(c(preferred[preferred %in% cols], cols))
    primary <- input$cfg_split_by %||% "__none__"
    keep <- setdiff(keep, primary[primary != "__none__"])
    choices <- c("None" = "__none__")
    for (nm in keep) choices[[nm]] <- nm
    selectInput("cfg_split_by_secondary", ANALYSIS_UI_TEXT$t_label_split_secondary, choices = choices, selected = "__none__")
  })

  .cfg_compute_params_raw <- reactive({
    red_sel <- .scalar_chr(input$cfg_plot_format, default = "umap")
    fmt <- .cfg_plot_format_method(red_sel)
    list(
      reduction_name = red_sel,
      plot_format = fmt,
      dims = .effective_dims(),
      seed = as.integer(input$cfg_seed_input %||% 42),
      umap_neighbors = as.integer(input$cfg_umap_neighbors %||% 30),
      umap_min_dist = as.numeric(input$cfg_umap_min_dist %||% 0.3),
      umap_spread = as.numeric(input$cfg_umap_spread %||% 1.0),
      tsne_perplexity = as.numeric(input$cfg_tsne_perplexity %||% 20),
      tsne_theta = as.numeric(input$cfg_tsne_theta %||% 0.8),
      tsne_eta = as.numeric(input$cfg_tsne_eta %||% 200),
      tsne_iter = as.integer(input$cfg_tsne_iter %||% 500)
    )
  })
  .cfg_display_params <- reactive({
    list(
      color_by = .scalar_chr(input$cfg_color_by, default = ""),
      split_by = .scalar_chr(input$cfg_split_by, default = "__none__"),
      split_by_secondary = .scalar_chr(input$cfg_split_by_secondary, default = "__none__"),
      freq_group_by = .scalar_chr(input$cfg_freq_group_by, default = "auto"),
      dot_size = as.numeric(input$cfg_dot_size %||% 0.85)
    )
  })
  .run_cfg_preview_now <- function(tab_now = "umap configuration", sobj = NULL, nm = "", params = NULL, t0 = NULL, manage_overlay = TRUE) {
    if (!tab_now %in% c("umap configuration", "umap visualization")) return(FALSE)
    if (is.null(sobj)) sobj <- isolate(.get_active_sobj(shared_data))
    if (is.null(sobj)) return(FALSE)
    nm <- .scalar_chr(nm %||% isolate(shared_data$active_object_name), default = "")
    if (is.null(params)) params <- isolate(.cfg_compute_params_raw())
    .perf_log("cfg_preview:begin", t0 = t0, details = c(
      sprintf("tab=%s", tab_now),
      sprintf("object=%s", if (nzchar(nm)) nm else "<empty>"),
      sprintf("plot_format=%s", .scalar_chr(params$plot_format, default = "UMAP")),
      sprintf("dims=%s", as.character(params$dims %||% NA))
    ))
    cache_key <- paste(
      .cfg_object_signature(sobj, object_name = nm),
      paste(unlist(params), collapse = "::"),
      sep = "||"
    )
    pending_key <- tryCatch(isolate(.cfg_preview_pending_key()), error = function(e) NULL)
    if (identical(pending_key, cache_key)) {
      .perf_log("cfg_preview:pending_same_key_skip_compute", t0 = t0)
      return(TRUE)
    }
    cache <- tryCatch(isolate(.cfg_preview_cache()), error = function(e) list(key = NULL, result = NULL))
    if (is.list(cache) && identical(cache$key, cache_key) && !is.null(cache$result)) {
      .perf_log("cfg_preview:cache_hit_skip_compute", t0 = t0)
      return(TRUE)
    }
    .cfg_preview_pending_key(cache_key)
    on.exit(try(.cfg_preview_pending_key(NULL), silent = TRUE), add = TRUE)
    if (isTRUE(manage_overlay)) {
      overlay_show("Computing embedding preview...")
      on.exit(overlay_hide(), add = TRUE)
    }
    t_compute <- .perf_now()
    out <- tryCatch(
      core_analysis_tab_b_compute_plot(sobj, params = params, persist = TRUE),
      error = function(e) {
        .perf_log("cfg_preview:compute_error", t0 = t_compute, details = conditionMessage(e))
        showNotification(paste("Embedding preview error:", e$message), type = "error", duration = 8)
        NULL
      }
    )
    .perf_log("cfg_preview:compute_done", t0 = t_compute, details = sprintf("success=%s", as.character(!is.null(out))))
    if (!is.null(out) && nzchar(nm)) {
      reg_now <- tryCatch(isolate(shared_data$all_seurat_objects), error = function(e) NULL)
      if (is.null(reg_now) || !is.list(reg_now)) reg_now <- list()
      entry_now <- reg_now[[nm]]
      if (is.null(entry_now) || !is.list(entry_now)) entry_now <- list()
      entry_now$obj <- out$object
      if (is.null(entry_now$prefs) || !is.list(entry_now$prefs)) entry_now$prefs <- list()
      if (is.null(entry_now$plots) || !is.list(entry_now$plots)) entry_now$plots <- list()
      entry_now$prefs$embedding_params <- params
      entry_now$plots$default_reduction <- tolower(params$plot_format %||% "umap")
      reg_now[[nm]] <- entry_now
      shared_data$all_seurat_objects <- reg_now
      .cfg_keeper_dirty(FALSE)
      .perf_log("cfg_preview:stored_results", t0 = t0, details = sprintf("object=%s", nm))
    }
    if (!is.null(out)) {
      out$object_name <- nm
      out$params <- params
    }
    try(isolate(.cfg_preview_cache(list(key = cache_key, result = out))), silent = TRUE)
    isTRUE(!is.null(out))
  }

  .cfg_preview_output_id <- function(tab_now = "umap configuration") {
    if (identical(tab_now, "umap visualization")) return("umap_viz_plot")
    "umap_config_static_plot"
  }

  .queue_cfg_preview_run <- function(tab_now, nm, sobj, params, t0, source_tag = "cfg_apply_btn", pre_shown = FALSE) {
    preview_ok <- FALSE
    shinyjs::disable("cfg_apply_btn")
    if (!isTRUE(pre_shown)) overlay_show("Computing embedding preview...")
    .perf_log(paste0(source_tag, ":preview_start"), t0 = t0)
    tryCatch(
      preview_ok <- isTRUE(.run_cfg_preview_now(
        tab_now = tab_now,
        sobj = sobj,
        nm = nm,
        params = params,
        t0 = t0,
        manage_overlay = FALSE
      )),
      error = function(e) {
        preview_ok <<- FALSE
        .perf_log(paste0(source_tag, ":preview_error"), t0 = t0, details = conditionMessage(e))
        showNotification(paste("Embedding preview error:", conditionMessage(e)), type = "error", duration = 8)
      },
      finally = {
        if (isTRUE(preview_ok)) {
          overlay_hide_when_output_ready(.cfg_preview_output_id(tab_now), timeout_ms = 120000L)
        } else {
          overlay_hide()
        }
        shinyjs::enable("cfg_apply_btn")
        .perf_log(paste0(source_tag, ":preview_done"), t0 = t0)
      }
    )
    invisible(NULL)
  }

  observeEvent(input$cfg_apply_btn, {
    t_apply <- .perf_now()
    queued <- FALSE
    overlay_show("Preparing embedding preview...")
    on.exit(if (!isTRUE(queued)) overlay_hide(), add = TRUE)
    tab_now <- input$plot_tabs %||% "umap configuration"
    nm_now <- .scalar_chr(isolate(shared_data$active_object_name), default = "")
    sobj_now <- tryCatch(isolate(.get_active_sobj(shared_data)), error = function(e) NULL)
    params_now <- tryCatch(isolate(.cfg_compute_params_raw()), error = function(e) NULL)
    .perf_log("cfg_apply_btn:clicked", details = c(
      sprintf("tab=%s", tab_now),
      sprintf("object=%s", if (nzchar(nm_now)) nm_now else "<empty>")
    ))
    if (is.null(sobj_now)) {
      .perf_log("cfg_apply_btn:abort_no_active_object", t0 = t_apply)
      showNotification("No active analysis object is available. Please select/add an object first.", type = "error")
      return(invisible(NULL))
    }
    if (is.null(params_now)) {
      .perf_log("cfg_apply_btn:abort_params_snapshot_failed", t0 = t_apply)
      showNotification("Unable to read embedding parameters for preview.", type = "error", duration = 8)
      return(invisible(NULL))
    }
    showNotification("Starting embedding preview...", type = "message", duration = 1.5)
    .perf_log("cfg_apply_btn:queue_preview", t0 = t_apply, details = c(
      sprintf("tab=%s", tab_now),
      sprintf("object=%s", if (nzchar(nm_now)) nm_now else "<empty>")
    ))
    queued <- TRUE
    .queue_cfg_preview_run(
      tab_now = tab_now,
      nm = nm_now,
      sobj = sobj_now,
      params = params_now,
      t0 = t_apply,
      source_tag = "cfg_apply_btn",
      pre_shown = TRUE
    )
  }, ignoreInit = TRUE)

  .cfg_preview_or_saved <- reactive({
    cache <- .cfg_preview_cache()
    active_nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (is.list(cache) && !is.null(cache$result) &&
        isTRUE(.analysis_preview_result_matches_active(cache$result, active_nm))) {
      active_sobj <- tryCatch(.get_active_sobj(shared_data), error = function(e) NULL)
      cache_sobj <- tryCatch(cache$result$object, error = function(e) NULL)
      red <- .scalar_chr(cache$result$reduction, default = "umap")
      if (!is.null(active_sobj) && inherits(active_sobj, "Seurat")) {
        sig_active <- .analysis_reduction_signature(active_sobj, reduction_name = red)
        sig_cache <- .analysis_reduction_signature(cache_sobj, reduction_name = red)
        if (!nzchar(sig_cache) || !identical(sig_active, sig_cache)) {
          cache_params <- tryCatch(cache$result$params, error = function(e) NULL)
          if (!is.list(cache_params)) cache_params <- list(plot_format = "UMAP")
          return(list(
            object_name = active_nm,
            object = active_sobj,
            reduction = .cfg_reduction_for_display(active_sobj, params = cache_params, fallback = red),
            params = cache_params
          ))
        }
      }
      return(cache$result)
    }
    NULL
  })

  output$umap_config_static_plot <- renderPlot({
    tab_now <- .scalar_chr(.current_plot_tab(), default = "")
    if (!identical(tab_now, "umap configuration")) return(invisible(NULL))
    out <- .cfg_preview_or_saved()
    if (is.null(out)) {
      plot.new()
      title("Click 'Save parameters & continue' to generate embedding preview.")
      return(invisible(NULL))
    }
    ref_sobj <- .get_active_sobj(shared_data)
    color_by_static <- .cfg_clustering_reference_color(ref_sobj)
    if (is.null(color_by_static) || !nzchar(as.character(color_by_static %||% ""))) {
      color_by_static <- .cfg_preview_default_color_by(ref_sobj)
    }
    sobj_plot <- .sync_preview_metadata(
      preview_sobj = ref_sobj %||% out$object,
      ref_sobj = ref_sobj,
      cols = color_by_static %||% character()
    )
    out_params <- tryCatch(out$params, error = function(e) NULL)
    if (!is.list(out_params)) out_params <- list(plot_format = "UMAP")
    requested_fmt <- toupper(.cfg_plot_format_method(input$cfg_plot_format %||% "umap"))
    cached_red <- tolower(.scalar_chr(out$reduction, default = ""))
    red_expected <- if (identical(requested_fmt, "TSNE")) "tsne" else "umap"
    if (nzchar(cached_red) && !startsWith(cached_red, red_expected)) {
      .perf_log("umap_config_static_plot:format_mismatch_cached_preview", details = c(
        sprintf("object=%s", .scalar_chr(shared_data$active_object_name, default = "<empty>")),
        sprintf("requested_format=%s", requested_fmt),
        sprintf("cached_reduction=%s", cached_red)
      ))
      plot.new()
      title(sprintf(
        "%s preview not generated yet for this object. Click 'Save parameters & continue'.",
        if (identical(requested_fmt, "TSNE")) "t-SNE" else "UMAP"
      ))
      return(invisible(NULL))
    }
    red_use <- .cfg_reduction_for_display(sobj_plot, params = out_params, fallback = out$reduction)
    if (!nzchar(red_use)) {
      .perf_log("umap_config_static_plot:missing_reduction", details = c(
        sprintf("object=%s", .scalar_chr(shared_data$active_object_name, default = "<empty>")),
        sprintf("requested=%s", .scalar_chr(out$reduction, default = "<empty>")),
        sprintf("format=%s", .scalar_chr(out_params$plot_format, default = "<empty>"))
      ))
      plot.new()
      title("Embedding preview unavailable for this object (no UMAP/tSNE reduction).")
      return(invisible(NULL))
    }
    .build_embedding_preview_static_plot(
      sobj = sobj_plot,
      reduction_name = red_use,
      plot_format = (out_params$plot_format %||% "UMAP"),
      color_by = color_by_static
    )
  })

  output$umap_viz_plot_ui <- renderUI({
    out <- .cfg_preview_or_saved()
    if (is.null(out)) {
      return(plotOutput("umap_viz_plot", height = "620px", width = "100%"))
    }
    params <- c(.cfg_compute_params_raw(), .cfg_display_params())
    split_by <- if (identical(params$split_by %||% "__none__", "__none__")) NULL else params$split_by
    split_by_secondary <- if (identical(params$split_by_secondary %||% "__none__", "__none__")) NULL else params$split_by_secondary
    lv <- .embedding_preview_levels(out$object, split_by = split_by, split_by_secondary = split_by_secondary)
    output_w <- suppressWarnings(as.numeric(session$clientData$output_umap_viz_plot_ui_width %||% session$clientData$output_umap_viz_plot_width %||% 1050))
    spec <- .embedding_preview_layout(output_w, lv$col_levels, lv$row_levels)
    ref_sobj <- .get_active_sobj(shared_data)
    sobj_plot <- .sync_preview_metadata(
      preview_sobj = ref_sobj %||% out$object,
      ref_sobj = ref_sobj,
      cols = c(params$color_by %||% character(), split_by %||% character(), split_by_secondary %||% character())
    )
    red_use <- .cfg_reduction_for_display(sobj_plot, params = params, fallback = out$reduction)
    md <- tryCatch(sobj_plot@meta.data, error = function(e) NULL)
    color_by <- params$color_by %||% NULL
    vals <- if (!is.null(color_by) && nzchar(color_by) && !is.null(md) && color_by %in% colnames(md)) {
      as.character(md[[color_by]])
    } else {
      as.character(tryCatch(Seurat::Idents(sobj_plot), error = function(e) character()))
    }
    vals[is.na(vals) | !nzchar(vals)] <- "NA"
    n_lv_vec <- .sort_levels_natural(vals)
    n_lv <- max(1L, length(n_lv_vec))
    legend_usable_w <- max(280, output_w - 260)
    lv_nchar <- nchar(as.character(n_lv_vec %||% character(0)))
    if (!length(lv_nchar)) lv_nchar <- 10L
    label_nchar_p90 <- as.numeric(stats::quantile(lv_nchar, probs = 0.90, na.rm = TRUE, type = 7))
    if (!is.finite(label_nchar_p90) || is.na(label_nchar_p90) || label_nchar_p90 < 4) label_nchar_p90 <- 10
    legend_item_px <- max(82, min(220, 28 + 7.0 * label_nchar_p90))
    items_per_row <- max(2L, min(12L, floor(legend_usable_w / legend_item_px)))
    legend_rows <- max(1L, ceiling(n_lv / max(1L, items_per_row)))
    legend_extra <- 20L + max(0L, legend_rows - 1L) * 24L
    h <- as.integer(max(620, spec$height + legend_extra))
    plotOutput("umap_viz_plot", height = paste0(h, "px"), width = "100%")
  })

  .umap_cluster_freq_plot_height_px <- function(width_override = NULL) {
    out <- .cfg_preview_or_saved()
    if (is.null(out)) return(280L)

    params <- c(.cfg_compute_params_raw(), .cfg_display_params())
    split_by <- if (identical(params$split_by %||% "__none__", "__none__")) NULL else params$split_by
    split_by_secondary <- if (identical(params$split_by_secondary %||% "__none__", "__none__")) NULL else params$split_by_secondary
    freq_group_by <- .scalar_chr(params$freq_group_by %||% "auto", default = "auto")
    ref_sobj <- .get_active_sobj(shared_data)
    sobj_plot <- .sync_preview_metadata(
      preview_sobj = out$object,
      ref_sobj = ref_sobj,
      cols = c(params$color_by %||% character(), split_by %||% character(), split_by_secondary %||% character())
    )

    width_px <- suppressWarnings(as.numeric(
      width_override %||%
        session$clientData$output_umap_cluster_freq_plot_ui_width %||%
        session$clientData$output_umap_cluster_freq_plot_width %||%
        session$clientData$output_umap_viz_plot_width %||%
        1050
    ))
    metrics <- .umap_cluster_freq_layout_metrics(
      sobj_plot = sobj_plot,
      color_by = params$color_by %||% NULL,
      split_by = split_by,
      split_by_secondary = split_by_secondary,
      freq_group_by = freq_group_by,
      container_width = width_px
    )
    as.integer(metrics$height_px %||% 620L)
  }

  output$umap_cluster_freq_plot_ui <- renderUI({
    plotOutput(
      "umap_cluster_freq_plot",
      width = "100%",
      height = paste0(.umap_cluster_freq_plot_height_px(), "px")
    )
  })

  .umap_viz_context <- reactive({
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    req(identical(tab_now, "umap visualization"))
    t_ctx <- .perf_now()
    out <- .cfg_preview_or_saved()
    req(!is.null(out))
    params <- c(.cfg_compute_params_raw(), .cfg_display_params())
    split_by <- if (identical(params$split_by %||% "__none__", "__none__")) NULL else params$split_by
    split_by_secondary <- if (identical(params$split_by_secondary %||% "__none__", "__none__")) NULL else params$split_by_secondary
    ref_sobj <- .get_active_sobj(shared_data)
    sobj_plot <- .sync_preview_metadata(
      preview_sobj = ref_sobj %||% out$object,
      ref_sobj = ref_sobj,
      cols = c(params$color_by %||% character(), split_by %||% character(), split_by_secondary %||% character())
    )
    red_use <- .cfg_reduction_for_display(sobj_plot, params = params, fallback = out$reduction)
    .perf_log("umap_viz:context_ready", t0 = t_ctx, details = c(
      sprintf("object=%s", .scalar_chr(out$object_name, default = "<empty>")),
      sprintf("reduction=%s", .scalar_chr(red_use, default = "<empty>"))
    ))
    list(
      out = out,
      params = params,
      split_by = split_by,
      split_by_secondary = split_by_secondary,
      sobj_plot = sobj_plot,
      red_use = red_use
    )
  })

  .pdf_modal_server <- get0("wl_pdf_modal_server", mode = "function", ifnotfound = NULL)
  if (is.null(.pdf_modal_server)) stop("Shared PDF modal helper is unavailable. Please source interface/shared/shared_pdf_export_modal.R first.")
  .analysis_pdf_modal <- .pdf_modal_server(
    input = input,
    output = output,
    session = session,
    id_prefix = "analysis_pdf",
    build_bundle = .analysis_pdf_bundle,
    download_btn_label = ANALYSIS_UI_TEXT$t_btn_download_pdf,
    default_modal_title = "PDF export settings"
  )

  observeEvent(input$open_umap_viz_pdf_modal, {
    .analysis_pdf_modal$open("umap_viz", title_txt = "PDF export settings: Embedding preview")
  }, ignoreInit = TRUE)

  observeEvent(input$open_umap_freq_pdf_modal, {
    .analysis_pdf_modal$open("umap_freq", title_txt = "PDF export settings: Cell frequency")
  }, ignoreInit = TRUE)

  observeEvent(input$open_jjvolcano_pdf_modal, {
    .analysis_pdf_modal$open("jjvolcano", title_txt = "PDF export settings: jjvolcano")
  }, ignoreInit = TRUE)

  .umap_cfg_request_overlay <- function(msg = "Loading embedding preview...") {
    if (!isTRUE(.analysis_plot_tab_active("umap configuration"))) return(invisible(NULL))
    try(overlay_show(msg), silent = TRUE)
    try(overlay_hide_when_output_ready("umap_config_static_plot", timeout_ms = 120000L), silent = TRUE)
    invisible(NULL)
  }
  .umap_viz_request_overlay <- function(msg = "Loading UMAP visualization...") {
    if (!isTRUE(.analysis_plot_tab_active("umap visualization"))) return(invisible(NULL))
    try(overlay_show(msg), silent = TRUE)
    try(overlay_hide_when_output_ready("umap_viz_plot", timeout_ms = 120000L), silent = TRUE)
    invisible(NULL)
  }
  observeEvent(input$plot_tabs, {
    if (!isTRUE(.analysis_plot_tab_active("umap configuration"))) return(invisible(NULL))
    .umap_cfg_request_overlay("Loading embedding preview...")
  }, ignoreInit = TRUE)
  observeEvent(shared_data$active_object_name, {
    if (!isTRUE(.analysis_plot_tab_active("umap configuration"))) return(invisible(NULL))
    .umap_cfg_request_overlay("Switching embedding preview object...")
  }, ignoreInit = TRUE)
  observeEvent(input$plot_tabs, {
    if (!isTRUE(.analysis_plot_tab_active("umap visualization"))) return(invisible(NULL))
    .umap_viz_request_overlay("Loading UMAP visualization...")
  }, ignoreInit = TRUE)
  observeEvent(input$cfg_color_by, {
    if (!isTRUE(.analysis_plot_tab_active("umap visualization"))) return(invisible(NULL))
    .umap_viz_request_overlay("Updating UMAP colors...")
  }, ignoreInit = TRUE)
  observeEvent(input$cfg_split_by, {
    if (!isTRUE(.analysis_plot_tab_active("umap visualization"))) return(invisible(NULL))
    .umap_viz_request_overlay("Updating UMAP split...")
  }, ignoreInit = TRUE)
  observeEvent(input$cfg_split_by_secondary, {
    if (!isTRUE(.analysis_plot_tab_active("umap visualization"))) return(invisible(NULL))
    .umap_viz_request_overlay("Updating UMAP split...")
  }, ignoreInit = TRUE)
  observeEvent(input$cfg_dot_size, {
    if (!isTRUE(.analysis_plot_tab_active("umap visualization"))) return(invisible(NULL))
    .umap_viz_request_overlay("Updating UMAP point size...")
  }, ignoreInit = TRUE)

  output$umap_viz_plot <- renderPlot({
    tab_now <- .scalar_chr(.current_plot_tab(), default = "")
    if (!identical(tab_now, "umap visualization")) return(invisible(NULL))
    ctx <- .umap_viz_context()
    if (is.null(ctx) || is.null(ctx$out)) {
      plot.new()
      title("Click 'Generate embedding preview' to render.")
      return(invisible(NULL))
    }
    output_w <- suppressWarnings(as.numeric(session$clientData$output_umap_viz_plot_width %||% session$clientData$output_umap_viz_plot_ui_width %||% 1050))
    .build_embedding_preview_plot(
      sobj = ctx$sobj_plot,
      reduction_name = ctx$red_use,
      color_by = ctx$params$color_by %||% NULL,
      split_by = ctx$split_by,
      split_by_secondary = ctx$split_by_secondary,
      plot_format = ctx$params$plot_format %||% "UMAP",
      container_width = output_w,
      dot_size = ctx$params$dot_size %||% 0.85
    )
  }, res = 110)

  output$umap_cluster_freq_plot <- renderPlot({
    tab_now <- .scalar_chr(.current_plot_tab(), default = "")
    if (!identical(tab_now, "umap visualization")) return(invisible(NULL))
    ctx <- .umap_viz_context()
    if (is.null(ctx) || is.null(ctx$out)) {
      plot.new()
      title("Click 'Generate embedding preview' to render.")
      return(invisible(NULL))
    }
    output_w <- suppressWarnings(as.numeric(session$clientData$output_umap_cluster_freq_plot_width %||% session$clientData$output_umap_viz_plot_width %||% 1050))
    .build_embedding_cluster_freq_plot(
      sobj = ctx$sobj_plot,
      reduction_name = ctx$red_use,
      color_by = ctx$params$color_by %||% NULL,
      split_by = ctx$split_by,
      split_by_secondary = ctx$split_by_secondary,
      container_width = output_w,
      freq_group_by = .scalar_chr(ctx$params$freq_group_by %||% "auto", default = "auto")
    )
  }, height = function() {
    .umap_cluster_freq_plot_height_px()
  }, res = 110)

  output$umap_reduction_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    reds <- .reduction_choices(sobj)
    # Always default to UMAP; if it's missing we'll compute it on the fly
    if (!"umap" %in% reds) reds <- unique(c("umap", reds))
    reds <- unique(reds)
    labels <- vapply(reds, function(red) .reduction_pca_dims_label(sobj, red), character(1))
    selectInput("umap_reduction", ANALYSIS_UI_TEXT$t_label_reduction, choices = stats::setNames(reds, labels), selected = "umap")
  })
  output$umap_pca_status_ui <- renderUI({
    nm <- shared_data$active_object_name
    dims_now <- .get_confirmed_dims(nm)
    has_dims <- length(dims_now) >= 1L &&
      is.finite(dims_now[[1]]) &&
      !is.na(dims_now[[1]]) &&
      dims_now[[1]] >= 2L
    msg <- if (isTRUE(has_dims)) {
      sprintf(ANALYSIS_UI_TEXT$t_text_umap_pca_dims_current, as.integer(dims_now[[1]]))
    } else {
      ANALYSIS_UI_TEXT$t_text_umap_pca_dims_not_set
    }
    tags$p(class = "text-muted", style = "margin:4px 0 8px 0;", msg)
  })
  output$umap_colorby_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    cols <- .meta_columns_for_color(sobj)
    selectInput("umap_colorby", ANALYSIS_UI_TEXT$t_label_color, choices = cols, selected = cols[1])
  })
  output$umap_res_selector_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    chosen <- input$umap_colorby; if (is.null(chosen)) return(NULL)
    cand <- .find_resolution_columns(sobj)
    if (!length(cand)) return(NULL)
    if (grepl("(snn_res\\.|leiden_res\\.)", tolower(chosen))) return(NULL)
    selectInput("umap_colorby_rescol", ANALYSIS_UI_TEXT$t_label_use_cluster_column, choices = cand, selected = cand[1])
  })
  .umap_plot_height_px <- function() {
    tab_now <- input$plot_tabs %||% "clustering resolution"
    if (!identical(tab_now, "clustering resolution")) return(480L)
    sobj <- tryCatch(.get_active_sobj(shared_data), error = function(e) NULL)
    if (is.null(sobj)) return(560L)
    sweep_ready_now <- isTRUE(.sweep_ready())

    entry <- tryCatch(.get_active_entry(shared_data), error = function(e) NULL)
    sample_col <- tryCatch(entry$prefs$sample_col %||% NULL, error = function(e) NULL)
    split_by <- NULL
    if (isTRUE(input$umap_split_by_sample) && !is.null(sample_col) && sample_col %in% colnames(sobj@meta.data)) {
      split_by <- sample_col
    }

    plot_w <- suppressWarnings(as.numeric(
      session$clientData$output_umap_plot_width %||%
      session$clientData$output_umap_plot_pre_sweep_width %||%
      session$clientData$output_umap_plot_ui_width %||%
      session$clientData$output_umap_plot_ui_pre_sweep_width %||%
      1000
    ))
    if (!is.finite(plot_w) || is.na(plot_w) || plot_w <= 0) plot_w <- 1000

    if (is.null(split_by)) {
      # Keep pre-sweep adaptive (not fixed), but capped to avoid oversized empty frames.
      if (!isTRUE(sweep_ready_now)) {
        h0 <- plot_w * 0.42 + 78
        return(as.integer(max(400, min(520, h0))))
      }
      h <- plot_w * 0.55 + 96
      return(as.integer(max(460, min(640, h))))
    }

    split_vals <- as.character(sobj@meta.data[[split_by]])
    split_vals[is.na(split_vals) | !nzchar(split_vals)] <- "NA"
    split_levels <- .sort_levels_natural(split_vals)
    n_facets <- max(1L, length(split_levels))
    n_cols <- max(1L, min(n_facets, floor(plot_w / 320)))
    n_rows <- max(1L, ceiling(n_facets / n_cols))
    h <- (plot_w / n_cols) * n_rows * 0.82 + 160
    h_cap <- if (isTRUE(sweep_ready_now)) 860 else 640
    as.integer(max(460, min(h_cap, h)))
  }

  .umap_cfg_signature <- function(cfg) {
    if (is.null(cfg) || !is.list(cfg)) return("")
    paste(
      as.integer(cfg$dims %||% 30L),
      as.integer(cfg$seed %||% 42L),
      as.integer(cfg$umap_neighbors %||% 30L),
      signif(as.numeric(cfg$umap_min_dist %||% 0.30), 6),
      signif(as.numeric(cfg$umap_spread %||% 1.0), 6),
      sep = "::"
    )
  }
  .tsne_cfg_signature <- function(cfg) {
    if (is.null(cfg) || !is.list(cfg)) return("")
    paste(
      as.integer(cfg$dims %||% 30L),
      as.integer(cfg$seed %||% 42L),
      as.numeric(cfg$tsne_perplexity %||% 30),
      as.numeric(cfg$tsne_theta %||% 0.5),
      as.numeric(cfg$tsne_eta %||% 200),
      as.integer(cfg$tsne_iter %||% 1000L),
      sep = "::"
    )
  }

  output$umap_plot_ui <- renderUI({
    h <- .umap_plot_height_px()
    plotOutput("umap_plot", width = "100%", height = paste0(h, "px"))
  })
  output$clustertree_umap_layout_ui <- renderUI({
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    cache <- tryCatch(shared_data$all_seurat_objects[[nm]]$analysis_cache$cluster_sweep, error = function(e) NULL)
    layout_mode <- .clustertree_umap_layout_mode(cache, threshold = 10L)

    clustertree_card <- div(
      class = "wl-side",
      h4(ANALYSIS_UI_TEXT$t_title_clustertree),
      analysis_with_busy_spinner(uiOutput("clustertree_plot_ui"), spinner = "clustertree")
    )
    umap_card <- div(
      class = "wl-side clustering-umap-side",
      h4(ANALYSIS_UI_TEXT$t_title_umap),
      uiOutput("umap_plot_ui")
    )

    if (identical(layout_mode, "stacked")) {
      return(tagList(
        fluidRow(column(12, clustertree_card)),
        fluidRow(column(12, umap_card))
      ))
    }

    fluidRow(
      column(6, clustertree_card),
      column(6, umap_card)
    )
  })
  output$umap_plot_ui_pre_sweep <- renderUI({
    h <- .umap_plot_height_px()
    plotOutput("umap_plot_pre_sweep", width = "100%", height = paste0(h, "px"))
  })

  .sync_umap_for_current_cfg <- function(sobj) {
    if (is.null(sobj)) return(sobj)
    if (isTRUE(.analysis_should_lock_elbow_preview(.get_active_entry(shared_data)))) return(sobj)

    entry <- .get_active_entry(shared_data)
    saved_raw <- tryCatch(entry$prefs$embedding_params, error = function(e) NULL)
    cfg <- if (is.list(saved_raw) && identical(toupper(as.character(saved_raw$plot_format %||% "UMAP")), "UMAP")) {
      list(
        dims = as.integer(saved_raw$dims %||% .effective_dims()),
        seed = as.integer(saved_raw$seed %||% 42L),
        umap_neighbors = as.integer(saved_raw$umap_neighbors %||% 30L),
        umap_min_dist = as.numeric(saved_raw$umap_min_dist %||% 0.30),
        umap_spread = as.numeric(saved_raw$umap_spread %||% 1.0),
        tsne_perplexity = as.numeric(saved_raw$tsne_perplexity %||% 30),
        tsne_theta = as.numeric(saved_raw$tsne_theta %||% 0.5),
        tsne_eta = as.numeric(saved_raw$tsne_eta %||% 200),
        tsne_iter = as.integer(saved_raw$tsne_iter %||% 1000L)
      )
    } else {
      list(
        dims = as.integer(.effective_dims()),
        seed = as.integer(input$cfg_seed_input %||% 42L),
        umap_neighbors = as.integer(input$cfg_umap_neighbors %||% 30L),
        umap_min_dist = as.numeric(input$cfg_umap_min_dist %||% 0.30),
        umap_spread = as.numeric(input$cfg_umap_spread %||% 1.0),
        tsne_perplexity = as.numeric(input$cfg_tsne_perplexity %||% 20),
        tsne_theta = as.numeric(input$cfg_tsne_theta %||% 0.8),
        tsne_eta = as.numeric(input$cfg_tsne_eta %||% 200),
        tsne_iter = as.integer(input$cfg_tsne_iter %||% 500L)
      )
    }

    dims_use <- as.integer(max(2L, cfg$dims %||% .effective_dims()))
    umap_red <- sprintf("umap_pca_%d", dims_use)
    tsne_red <- sprintf("tsne_pca_%d", dims_use)
    sig_new <- .umap_cfg_signature(cfg)
    sig_old <- .scalar_chr(
      tryCatch(sobj@reductions[[umap_red]]@misc$cfg_signature, error = function(e) ""),
      default = ""
    )
    tsne_sig_new <- .tsne_cfg_signature(cfg)
    tsne_sig_old <- .scalar_chr(
      tryCatch(sobj@reductions[[tsne_red]]@misc$cfg_signature, error = function(e) ""),
      default = ""
    )
    has_umap <- umap_red %in% tolower(names(sobj@reductions))
    has_tsne <- tsne_red %in% tolower(names(sobj@reductions))
    has_pca <- "pca" %in% tolower(names(sobj@reductions))
    has_cfg_signature <- nzchar(sig_old)
    has_analysis_state <- isTRUE(.entry_has_analysis_embedding_state(entry))

    # Skip auto-sync on non-analysis objects (temporary QC UMAP/PCA can exist).
    if (!has_analysis_state && (!has_cfg_signature || !has_umap)) return(sobj)
    if (!has_pca) return(sobj)

    # Recompute only when UMAP is missing or effective UMAP params changed.
    # A generic "dirty" UI flag (e.g. unsaved preview edits) should not force
    # an expensive recompute here if signature is identical.
    need_umap <- (!has_umap) || !identical(sig_old, sig_new)
    need_tsne <- (!has_tsne) || !identical(tsne_sig_old, tsne_sig_new)
    if (!isTRUE(need_umap) && !isTRUE(need_tsne)) return(sobj)

    sobj2 <- tryCatch(
      Seurat::RunUMAP(
        sobj,
        dims = seq_len(dims_use),
        reduction.name = umap_red,
        reduction.key = "UMAPPCA_",
        seed.use = as.integer(cfg$seed %||% 42L),
        n.neighbors = as.integer(cfg$umap_neighbors %||% 30L),
        min.dist = as.numeric(cfg$umap_min_dist %||% 0.30),
        spread = as.numeric(cfg$umap_spread %||% 1.0),
        verbose = FALSE
      ),
      error = function(e) {
        showNotification(paste("UMAP recompute error:", conditionMessage(e)), type = "error", duration = 8)
        sobj
      }
    )

    try(sobj2@reductions[[umap_red]]@misc$cfg_signature <- sig_new, silent = TRUE)
    sobj2 <- tryCatch(
      Seurat::RunTSNE(
        sobj2,
        dims = seq_len(dims_use),
        reduction.name = tsne_red,
        reduction.key = "TSNEPCA_",
        seed.use = as.integer(cfg$seed %||% 42L),
        perplexity = as.numeric(cfg$tsne_perplexity %||% 30),
        theta = as.numeric(cfg$tsne_theta %||% 0.5),
        eta = as.numeric(cfg$tsne_eta %||% 200),
        max_iter = as.integer(cfg$tsne_iter %||% 1000L),
        check_duplicates = FALSE,
        verbose = FALSE
      ),
      error = function(e) {
        showNotification(paste("t-SNE recompute error:", conditionMessage(e)), type = "error", duration = 8)
        sobj2
      }
    )
    try(sobj2@reductions[[tsne_red]]@misc$cfg_signature <- tsne_sig_new, silent = TRUE)
    .cfg_keeper_dirty(FALSE)
    sobj2
  }

  observe({
    tab_now <- input$plot_tabs %||% "clustering resolution"
    if (!identical(tab_now, "clustering resolution")) return()
    sobj <- .get_active_sobj(shared_data)
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return()

    cfg_local <- list(dims = as.integer(.effective_dims()))
    dims_local <- as.integer(max(2L, cfg_local$dims %||% .effective_dims()))
    umap_red_local <- sprintf("umap_pca_%d", dims_local)
    has_umap_before <- umap_red_local %in% tolower(names(sobj@reductions))
    sig_before <- tryCatch(as.character(sobj@reductions[[umap_red_local]]@misc$cfg_signature), error = function(e) "")

    sobj2 <- .sync_umap_for_current_cfg(sobj)

    has_umap_after <- umap_red_local %in% tolower(names(sobj2@reductions))
    sig_after <- tryCatch(as.character(sobj2@reductions[[umap_red_local]]@misc$cfg_signature), error = function(e) "")
    if ((!isTRUE(has_umap_before) && isTRUE(has_umap_after)) || !identical(sig_before, sig_after)) {
      .set_active_sobj(shared_data, sobj2)
    }
  })

  .render_clustering_umap <- function() {
    sobj <- .get_active_sobj(shared_data); req(sobj)
    red <- input$umap_reduction %||% "umap"
    if (identical(tolower(red), "umap3d")) red <- "umap"
    col_by <- .scalar_chr(input$umap_colorby, default = "")
    col_by_res <- .scalar_chr(input$umap_colorby_rescol, default = "")
    if (nzchar(col_by_res)) col_by <- col_by_res
    if (!nzchar(col_by)) col_by <- NULL
    
    available_reductions <- tolower(tryCatch(names(sobj@reductions), error = function(e) character(0)))
    red <- tolower(.scalar_chr(red, default = ""))
    if (nzchar(red) && !(red %in% available_reductions) && red %in% c("umap", "tsne")) {
      sobj2 <- .sync_umap_for_current_cfg(sobj)
      if (!identical(sobj2, sobj)) {
        .set_active_sobj(shared_data, sobj2)
        sobj <- sobj2
        available_reductions <- tolower(tryCatch(names(sobj@reductions), error = function(e) character(0)))
      }
    }
    if (!nzchar(red) || !red %in% available_reductions) {
      .perf_log("clustering_umap:missing_reduction", details = c(
        sprintf("object=%s", .scalar_chr(shared_data$active_object_name, default = "<empty>")),
        sprintf("requested=%s", if (nzchar(red)) red else "<empty>"),
        sprintf("available=%s", if (length(available_reductions)) paste(available_reductions, collapse = ",") else "<none>")
      ))
      return(ggplot2::ggplot() + ggplot2::ggtitle("Embedding not available for this object."))
    }
    
    entry <- .get_active_entry(shared_data)
    split_by <- NULL
    sample_col <- .scalar_chr(entry$prefs$sample_col %||% "", default = "")
    if (isTRUE(input$umap_split_by_sample) && nzchar(sample_col) && sample_col %in% colnames(sobj@meta.data))
      split_by <- sample_col
    
    split_levels <- "All cells"
    facet_ncol <- NULL
    strip_angle <- 0
    strip_size <- 11
    legend_position <- .scalar_chr(input$umap_legend_position, default = "top")
    if (!(legend_position %in% c("top", "bottom", "right", "none"))) legend_position <- "top"
    legend_cols <- suppressWarnings(as.integer(input$umap_legend_cols %||% 4L))
    if (!is.finite(legend_cols) || legend_cols < 1L) legend_cols <- 4L
    legend_cols <- max(1L, min(8L, legend_cols))
    legend_is_horizontal <- legend_position %in% c("top", "bottom")
    if (!is.null(split_by)) {
      split_vals <- as.character(sobj@meta.data[[split_by]])
      split_vals[is.na(split_vals) | !nzchar(split_vals)] <- "NA"
      split_levels <- .sort_levels_natural(split_vals)
      plot_w <- suppressWarnings(as.numeric(
        session$clientData$output_umap_plot_width %||%
          session$clientData$output_umap_plot_pre_sweep_width %||%
          1000
      ))
      layout_spec <- .embedding_preview_layout(plot_w, split_levels, "All cells")
      facet_ncol <- max(1L, min(length(split_levels), floor(plot_w / 320)))
      strip_angle <- layout_spec$col_angle
      strip_size <- layout_spec$col_font
    }
    
    # ensure cluster factors are numerically ordered for legend
    if (nzchar(.scalar_chr(col_by, default = "")) && col_by %in% colnames(sobj@meta.data)) {
      sobj@meta.data[[col_by]] <- .factor_numeric_first(sobj@meta.data[[col_by]])
    } else {
      Seurat::Idents(sobj) <- .factor_numeric_first(Seurat::Idents(sobj))
    }
    
    p <- tryCatch({
      if (nzchar(.scalar_chr(col_by, default = "")) && col_by %in% colnames(sobj@meta.data))
        Seurat::DimPlot(sobj, reduction = red, group.by = col_by, split.by = split_by, ncol = facet_ncol)
      else
        Seurat::DimPlot(sobj, reduction = red, split.by = split_by, ncol = facet_ncol)
    }, error = function(e) ggplot2::ggplot() + ggplot2::ggtitle("UMAP not available yet"))
    
    emb_limits <- tryCatch({
      emb <- Seurat::Embeddings(sobj, reduction = red)
      analysis_umap_axis_limits(x = emb[, 1], y = emb[, 2])
    }, error = function(e) NULL)

    # Use explicit padded limits so edge clusters are not clipped at the axes.
    p <- p +
      if (is.list(emb_limits) && length(emb_limits$x) == 2 && length(emb_limits$y) == 2) {
        ggplot2::coord_fixed(xlim = emb_limits$x, ylim = emb_limits$y, expand = FALSE)
      } else {
        ggplot2::coord_fixed(expand = FALSE)
      } +
      ggplot2::theme(
        plot.margin   = ggplot2::margin(10, 10, 10, 10),
        legend.position = legend_position,
        legend.direction = if (isTRUE(legend_is_horizontal)) "horizontal" else "vertical",
        legend.box = if (isTRUE(legend_is_horizontal)) "horizontal" else "vertical",
        strip.text.x = ggplot2::element_text(face = "bold", size = strip_size, angle = strip_angle, hjust = if (strip_angle == 0) 0.5 else 1),
        strip.text.y = ggplot2::element_text(face = "bold"),
        strip.text.y.left = ggplot2::element_text(face = "bold", angle = 0),
        strip.background = ggplot2::element_rect(fill = "#f3f4f6", color = "#d1d5db"),
        panel.spacing.x = grid::unit(1.1, "lines"),
        panel.spacing.y = grid::unit(1.1, "lines")
      )
    lg_dot <- .umap_legend_dot_size(.umap_point_size_from_plot(p, 0.85), 10)
    legend_vals <- if (!is.null(col_by) && col_by %in% colnames(sobj@meta.data)) {
      as.character(sobj@meta.data[[col_by]])
    } else {
      as.character(Seurat::Idents(sobj))
    }
    legend_vals[is.na(legend_vals) | !nzchar(legend_vals)] <- "NA"
    legend_n_levels <- length(unique(legend_vals))
    legend_cols_use <- if (isTRUE(legend_is_horizontal)) max(1L, min(legend_cols, legend_n_levels)) else NULL
    legend_rows_use <- if (isTRUE(legend_is_horizontal)) max(1L, ceiling(legend_n_levels / max(1L, legend_cols_use))) else NULL
    
    # Apply legend guide layout based on selected legend position.
    if (identical(legend_position, "none")) {
      p <- p + ggplot2::theme(legend.position = "none")
    } else if (!is.null(split_by) && isTRUE(legend_is_horizontal)) {
      p <- p +
        ggplot2::guides(
          colour = ggplot2::guide_legend(ncol = legend_cols_use, nrow = legend_rows_use, byrow = TRUE, override.aes = list(size = lg_dot, alpha = 1)),
          color  = ggplot2::guide_legend(ncol = legend_cols_use, nrow = legend_rows_use, byrow = TRUE, override.aes = list(size = lg_dot, alpha = 1)),
          shape  = ggplot2::guide_legend(ncol = legend_cols_use, nrow = legend_rows_use, byrow = TRUE, override.aes = list(size = lg_dot, alpha = 1))
        )
    } else if (isTRUE(legend_is_horizontal)) {
      p <- p + ggplot2::guides(
        colour = ggplot2::guide_legend(ncol = legend_cols_use, nrow = legend_rows_use, byrow = TRUE, override.aes = list(size = lg_dot, alpha = 1)),
        color  = ggplot2::guide_legend(ncol = legend_cols_use, nrow = legend_rows_use, byrow = TRUE, override.aes = list(size = lg_dot, alpha = 1))
      )
    } else {
      p <- p + ggplot2::guides(
        colour = ggplot2::guide_legend(override.aes = list(size = lg_dot, alpha = 1)),
        color  = ggplot2::guide_legend(override.aes = list(size = lg_dot, alpha = 1))
      )
    }
    
    p
  }
  
  output$umap_plot <- renderPlot({
    tab_now <- input$plot_tabs %||% "clustering resolution"
    if (!identical(tab_now, "clustering resolution")) return(invisible(NULL))
    .render_clustering_umap()
  }, height = function() .umap_plot_height_px())
  output$umap_plot_pre_sweep <- renderPlot({
    tab_now <- input$plot_tabs %||% "clustering resolution"
    if (!identical(tab_now, "clustering resolution")) return(invisible(NULL))
    .render_clustering_umap()
  }, height = function() .umap_plot_height_px())

  .umap3d_prepared <- reactive({
    .umap3d_error(NULL)
    embedding_type <- toupper(.scalar_chr(input$umap3d_embedding_type %||% "UMAP", default = "UMAP"))
    if (!embedding_type %in% c("UMAP", "TSNE")) embedding_type <- "UMAP"
    red3d_name <- if (identical(embedding_type, "TSNE")) "tsne3d" else "umap3d"
    red2d_name <- if (identical(embedding_type, "TSNE")) "tsne" else "umap"
    axis_prefix <- if (identical(embedding_type, "TSNE")) "tSNE" else "UMAP"
    mode_label <- if (identical(embedding_type, "TSNE")) "3D tSNE" else "3D UMAP"

    nm <- .scalar_chr(.umap3d_active_object_name(), default = "")
    if (!nzchar(nm)) {
      .umap3d_error("No active analysis object is selected. Please choose a dataset in the analysis selector.")
      return(NULL)
    }
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    sobj <- .get_obj_from_entry(entry)
    if (is.null(sobj) || !inherits(sobj, "Seurat")) {
      .umap3d_error(sprintf("Active object '%s' is unavailable or not a valid Seurat object.", nm))
      return(NULL)
    }

    .as_cfg <- function(x) {
      list(
        plot_format = toupper(as.character(x$plot_format %||% "UMAP")),
        dims = suppressWarnings(as.integer(x$dims %||% 30L)),
        seed = suppressWarnings(as.integer(x$seed %||% 42L)),
        umap_neighbors = suppressWarnings(as.integer(x$umap_neighbors %||% 30L)),
        umap_min_dist = suppressWarnings(as.numeric(x$umap_min_dist %||% 0.30)),
        umap_spread = suppressWarnings(as.numeric(x$umap_spread %||% 1.0)),
        tsne_perplexity = suppressWarnings(as.numeric(x$tsne_perplexity %||% 30)),
        tsne_theta = suppressWarnings(as.numeric(x$tsne_theta %||% 0.5)),
        tsne_eta = suppressWarnings(as.numeric(x$tsne_eta %||% 200)),
        tsne_iter = suppressWarnings(as.integer(x$tsne_iter %||% 1000L))
      )
    }
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    saved_raw <- tryCatch(entry$prefs$embedding_params, error = function(e) NULL)
    saved_cfg <- if (is.list(saved_raw)) .as_cfg(saved_raw) else NULL
    reds_now <- tolower(tryCatch(names(sobj@reductions), error = function(e) character()))
    has_umap_now <- "umap" %in% reds_now
    umap_sig <- tryCatch(sobj@reductions[["umap"]]@misc$cfg_signature, error = function(e) NULL)
    inferred_cfg <- if (is.list(umap_sig)) {
      list(
        plot_format = "UMAP",
        dims = suppressWarnings(as.integer(umap_sig$dims %||% .effective_dims())),
        seed = suppressWarnings(as.integer(umap_sig$seed %||% 42L)),
        umap_neighbors = suppressWarnings(as.integer(umap_sig$umap_neighbors %||% 30L)),
        umap_min_dist = suppressWarnings(as.numeric(umap_sig$umap_min_dist %||% 0.30)),
        umap_spread = suppressWarnings(as.numeric(umap_sig$umap_spread %||% 1.0)),
        tsne_perplexity = suppressWarnings(as.numeric(umap_sig$tsne_perplexity %||% 30)),
        tsne_theta = suppressWarnings(as.numeric(umap_sig$tsne_theta %||% 0.5)),
        tsne_eta = suppressWarnings(as.numeric(umap_sig$tsne_eta %||% 200)),
        tsne_iter = suppressWarnings(as.integer(umap_sig$tsne_iter %||% 1000L))
      )
    } else {
      list(
        plot_format = "UMAP",
        dims = suppressWarnings(as.integer(.effective_dims())),
        seed = suppressWarnings(as.integer(input$cfg_seed_input %||% 42L)),
        umap_neighbors = suppressWarnings(as.integer(input$cfg_umap_neighbors %||% 30L)),
        umap_min_dist = suppressWarnings(as.numeric(input$cfg_umap_min_dist %||% 0.30)),
        umap_spread = suppressWarnings(as.numeric(input$cfg_umap_spread %||% 1.0)),
        tsne_perplexity = suppressWarnings(as.numeric(input$cfg_tsne_perplexity %||% 20)),
        tsne_theta = suppressWarnings(as.numeric(input$cfg_tsne_theta %||% 0.8)),
        tsne_eta = suppressWarnings(as.numeric(input$cfg_tsne_eta %||% 200)),
        tsne_iter = suppressWarnings(as.integer(input$cfg_tsne_iter %||% 500L))
      )
    }
    cfg_from_keeper <- is.list(saved_cfg) && identical(saved_cfg$plot_format, "UMAP")
    cfg_use <- if (isTRUE(cfg_from_keeper)) saved_cfg else if (isTRUE(has_umap_now)) inferred_cfg else NULL

    if (is.null(cfg_use)) {
      msg <- "3D UMAP keeper: no saved UMAP configuration found and no UMAP reduction exists in this object. Please generate embedding preview in 'umap configuration' first."
      .umap3d_error(msg)
      return(NULL)
    }
    if (isTRUE(cfg_from_keeper) && isTRUE(.cfg_keeper_dirty())) {
      msg <- "3D UMAP keeper: UMAP configuration was edited after last preview. Please click 'Generate embedding preview' in 'umap configuration' first."
      .umap3d_error(msg)
      return(NULL)
    }

    overlay_show("Computing embedding preview...")
    on.exit(overlay_hide(), add = TRUE)

    message(sprintf("[%s] keeper pass object=%s dims=%s seed=%s", mode_label, nm, cfg_use$dims, cfg_use$seed))
    reds_before <- tolower(tryCatch(names(sobj@reductions), error = function(e) character()))
    prep3d <- if (identical(embedding_type, "TSNE")) {
      .ensure_tsne3d(
        sobj,
        dims = cfg_use$dims,
        seed = cfg_use$seed,
        tsne_perplexity = cfg_use$tsne_perplexity,
        tsne_theta = cfg_use$tsne_theta,
        tsne_eta = cfg_use$tsne_eta,
        tsne_iter = cfg_use$tsne_iter
      )
    } else {
      .ensure_umap3d(
        sobj,
        dims = cfg_use$dims,
        seed = cfg_use$seed,
        umap_neighbors = cfg_use$umap_neighbors,
        umap_min_dist = cfg_use$umap_min_dist,
        umap_spread = cfg_use$umap_spread
      )
    }
    if (!is.null(prep3d$error)) {
      msg <- paste(mode_label, "error:", prep3d$error)
      .umap3d_error(msg)
      return(NULL)
    }
    sobj2 <- prep3d$object %||% sobj
    reds_after <- tolower(tryCatch(names(sobj2@reductions), error = function(e) character()))
    if (!(red3d_name %in% reds_before) || prep3d$created) {
      shared_data$all_seurat_objects[[nm]]$obj <- sobj2
      sobj <- sobj2
    }

    emb <- tryCatch(Seurat::Embeddings(sobj, red3d_name), error = function(e) NULL)
    if (is.null(emb) || !is.matrix(emb) || ncol(emb) < 3) {
      msg <- paste0(mode_label, " is unavailable. Please run normalization/integration and PCA first.")
      .umap3d_error(msg)
      message(sprintf("[%s] embeddings missing or invalid after compute.", mode_label))
      return(NULL)
    }
    message(sprintf("[%s] embeddings ready: cells=%s dims=%s", mode_label, nrow(emb), ncol(emb)))

    cell_ids <- rownames(emb)
    md <- sobj@meta.data
    if (is.null(cell_ids) || length(cell_ids) == 0) {
      msg <- "No cells found for 3D UMAP."
      .umap3d_error(msg)
      return(NULL)
    }
    if (!all(cell_ids %in% rownames(md))) {
      msg <- "Cell metadata mismatch for 3D UMAP."
      .umap3d_error(msg)
      return(NULL)
    }

    all_cols <- colnames(md)
    res_cols <- .find_resolution_columns(sobj)
    preferred <- c("seurat_clusters", "orig.ident", "condition", "batch", "sample", "sample_name")
    group_cols <- unique(c(res_cols, preferred[preferred %in% all_cols], all_cols))
    if (!length(group_cols)) {
      msg <- "No metadata columns are available for 3D UMAP controls."
      .umap3d_error(msg)
      return(NULL)
    }

    df <- data.frame(
      cell_id = cell_ids,
      UMAP_1 = as.numeric(emb[, 1]),
      UMAP_2 = as.numeric(emb[, 2]),
      UMAP_3 = as.numeric(emb[, 3]),
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
    for (col in group_cols) {
      v <- as.character(md[cell_ids, col, drop = TRUE])
      v[is.na(v) | !nzchar(v)] <- "NA"
      df[[col]] <- v
    }

    split_cols <- group_cols[vapply(
      group_cols,
      function(col) .is_split_safe_metadata(col, md[cell_ids, col, drop = TRUE]),
      logical(1)
    )]
    split_cols <- unique(as.character(split_cols %||% character(0)))

    message(sprintf(
      "[3D UMAP] prepared dataframe rows=%s color_cols=%s split_cols=%s",
      nrow(df), length(group_cols), length(split_cols)
    ))
    list(
      df = df,
      color_cols = group_cols,
      split_cols = split_cols,
      object_name = nm,
      sobj = sobj,
      axis_prefix = axis_prefix,
      mode_label = mode_label,
      red3d_name = red3d_name,
      red2d_name = red2d_name
    )
  })

  output$umap3d_error_ui <- renderUI({
    if (!isTRUE(.umap3d_requested())) {
      return(div(
        class = "alert alert-info",
        style = "margin-bottom:10px;",
        span("3D preview is idle. Click 'Generate 3D embedding preview' to start.")
      ))
    }
    msg <- .umap3d_error()
    if (is.null(msg) || !nzchar(msg)) return(NULL)
    div(
      class = "alert alert-danger",
      style = "margin-bottom:10px;",
      strong("3D embedding render failed: "),
      span(msg)
    )
  })

  output$umap3d_colorby_ui <- renderUI({
    if (!isTRUE(.umap3d_requested())) return(NULL)
    prep <- .umap3d_prepared()
    if (is.null(prep)) return(NULL)
    choices <- prep$color_cols %||% character()
    req(length(choices) > 0)
    selected <- if ("seurat_clusters" %in% choices) "seurat_clusters" else choices[1]
    if (!is.null(input$umap3d_colorby) && input$umap3d_colorby %in% choices) selected <- input$umap3d_colorby
    selectizeInput("umap3d_colorby", ANALYSIS_UI_TEXT$t_label_umap3d_color, choices = choices, selected = selected, multiple = FALSE)
  })

  output$umap3d_splitby_ui <- renderUI({
    if (!isTRUE(.umap3d_requested())) return(NULL)
    prep <- .umap3d_prepared()
    if (is.null(prep)) return(NULL)
    choices <- prep$split_cols %||% character()
    choices <- c("None" = "__none__", stats::setNames(choices, choices))
    selected <- input$umap3d_splitby %||% "__none__"
    if (!selected %in% choices) selected <- "__none__"
    selectizeInput("umap3d_splitby", ANALYSIS_UI_TEXT$t_label_umap3d_split_by, choices = choices, selected = selected, multiple = FALSE)
  })

  output$umap3d_splitvalue_ui <- renderUI({
    if (!isTRUE(.umap3d_requested())) return(NULL)
    prep <- .umap3d_prepared()
    if (is.null(prep)) return(NULL)
    split_by <- input$umap3d_splitby %||% "__none__"
    if (identical(split_by, "__none__") || !split_by %in% colnames(prep$df)) return(NULL)
    vals <- .sort_levels_natural(prep$df[[split_by]])
    selected <- input$umap3d_split_value %||% vals
    selected <- intersect(as.character(selected), vals)
    if (!length(selected)) selected <- vals
    selectizeInput(
      "umap3d_split_value",
      ANALYSIS_UI_TEXT$t_label_umap3d_split_value,
      choices = vals,
      selected = selected,
      multiple = TRUE,
      options = list(plugins = list("remove_button"))
    )
  })

  .normalize_umap3d_split_by <- function(df, split_by) {
    out <- as.character(split_by %||% "__none__")
    if (!nzchar(out) || identical(out, "__none__") || !out %in% colnames(df)) return("__none__")
    if (!isTRUE(.is_split_safe_metadata(out, df[[out]]))) return("__none__")
    out
  }

  .notify_umap3d_split_guard <- function(col_name) {
    showNotification(
      sprintf(
        "3D split blocked for '%s': continuous/consecutive numeric metadata is not allowed for split. Use this column in '3D color by' to get a gradient legend.",
        as.character(col_name %||% "")
      ),
      type = "warning",
      duration = 7
    )
    invisible(NULL)
  }

  output$umap3d_plot_ui <- renderUI({
    tab_now <- input$plot_tabs %||% "clustering resolution"
    if (!identical(tab_now, "umap3d_tab")) return(NULL)
    if (!isTRUE(.umap3d_requested())) {
      return(plot_card_not_ready_ui(
        note = "3D preview is idle. Click 'Generate 3D embedding preview' to start.",
        height_px = 620L
      ))
    }
    prep <- .umap3d_prepared()
    if (is.null(prep)) {
      msg <- .scalar_chr(.umap3d_error(), default = "3D UMAP preview is not ready. Please confirm active dataset and generate preview again.")
      return(plot_card_not_ready_ui(
        note = msg,
        height_px = 620L
      ))
    }
    div(class = "umap3d-plot-host", plotlyOutput("umap3d_plot", height = "82vh"))
  })

  output$umap3d_plot <- renderPlotly({
    tab_now <- input$plot_tabs %||% "clustering resolution"
    hidden_now <- tryCatch(isTRUE(session$clientData$output_umap3d_plot_hidden), error = function(e) NA)
    message(sprintf("[3D UMAP] renderPlotly entered, active tab='%s', hidden=%s", as.character(tab_now), as.character(hidden_now)))
    .empty_3d <- function() {
      plotly::plot_ly(
        x = numeric(0),
        y = numeric(0),
        z = numeric(0),
        type = "scatter3d",
        mode = "markers"
      ) |>
        plotly::layout(
          scene = list(
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            zaxis = list(visible = FALSE)
          ),
          margin = list(l = 0, r = 0, b = 0, t = 0)
        ) |>
        plotly::config(displayModeBar = FALSE, displaylogo = FALSE)
    }
    if (isTRUE(hidden_now)) return(.empty_3d())
    if (!isTRUE(.umap3d_requested())) return(.empty_3d())
    tryCatch({
      prep <- .umap3d_prepared()
      if (is.null(prep)) {
        if (is.null(.umap3d_error()) || !nzchar(.umap3d_error())) {
          .umap3d_error("3D UMAP preview is not ready. Please confirm active dataset and generate preview again.")
        }
        return(.empty_3d())
      }
      .umap3d_error(NULL)
      df <- prep$df
      color_by <- input$umap3d_colorby %||% prep$color_cols[1]
      if (!color_by %in% prep$color_cols) color_by <- prep$color_cols[1]
      split_by_raw <- input$umap3d_splitby %||% "__none__"
      split_by <- .normalize_umap3d_split_by(df, split_by_raw)
      if (!identical(split_by_raw, "__none__") && !identical(split_by, split_by_raw)) {
        updateSelectizeInput(session, "umap3d_splitby", selected = "__none__")
        updateSelectizeInput(session, "umap3d_split_value", selected = character(0))
        .notify_umap3d_split_guard(split_by_raw)
      }
      split_value <- input$umap3d_split_value %||% character()
      if (!identical(split_by, "__none__") && split_by %in% colnames(df) && length(split_value)) {
        df <- df[df[[split_by]] %in% split_value, , drop = FALSE]
      }
      validate(need(nrow(df) > 0, "No cells remain after applying the 3D split filter."))
      point_size <- as.numeric(input$umap3d_point_size %||% 1.2)
      alpha <- as.numeric(input$umap3d_alpha %||% 0.85)
      message(sprintf("[%s] rendering rows=%s color_by=%s split_by=%s split_value=%s point_size=%.2f alpha=%.2f",
                      prep$mode_label %||% "3D embedding",
                      nrow(df), color_by, split_by, paste(split_value, collapse = ","), point_size, alpha))
      if (!identical(split_by, "__none__") && split_by %in% colnames(df)) {
        split_levels <- .sort_levels_natural(df[[split_by]])
        split_levels <- split_levels[nzchar(split_levels)]
        max_panels <- 12L
        if (length(split_levels) > max_panels) {
          showNotification(sprintf("Showing first %d split panels (of %d). Narrow split values to view specific groups.", max_panels, length(split_levels)),
                           type = "message", duration = 6)
          split_levels <- split_levels[seq_len(max_panels)]
        }
        p_list <- lapply(split_levels, function(lv) {
          p_sub <- .build_umap3d_plot(
            df = df[df[[split_by]] == lv, , drop = FALSE],
            color_by = color_by,
            point_size = point_size,
            alpha = alpha,
            title = paste0(split_by, " = ", lv),
            seurat_obj = prep$sobj,
            axis_prefix = prep$axis_prefix %||% "UMAP"
          )
          p_sub <- plotly::layout(p_sub, showlegend = FALSE)
          p_sub
        })
        p_list <- p_list[vapply(p_list, function(p) !is.null(p), logical(1))]
        n_panels <- length(p_list)
        validate(need(n_panels > 0, "No split panels remain after applying the 3D split filter."))
        nrows <- max(1L, ceiling(n_panels / 2L))
        p_grid <- plotly::subplot(p_list, nrows = nrows, margin = 0.02, shareX = FALSE, shareY = FALSE, titleX = TRUE, titleY = TRUE)
        scene_ids <- c("scene", if (n_panels > 1L) paste0("scene", 2:n_panels) else character())
        p_grid <- htmlwidgets::onRender(
          p_grid,
          "
function(el, x, data) {
  if (!window.Plotly || !el || !el.on) return;
  var syncing = false;
  el.on('plotly_relayout', function(ev) {
    if (syncing || !ev) return;
    var cam = null;
    var keys = Object.keys(ev);
    for (var i = 0; i < keys.length; i++) {
      var k = keys[i];
      if (/^scene[0-9]*\\.camera$/.test(k)) {
        cam = ev[k];
        break;
      }
    }
    if (!cam) return;
    syncing = true;
    var upd = {};
    for (var j = 0; j < data.scenes.length; j++) {
      upd[data.scenes[j] + '.camera'] = cam;
    }
    Plotly.relayout(el, upd).then(function() { syncing = false; }).catch(function() { syncing = false; });
  });
}
",
          data = list(scenes = scene_ids)
        )
        p_grid <- .attach_umap3d_gl_diag(p_grid)
        trace_n <- tryCatch(length(p_grid$x$data), error = function(e) NA_integer_)
        message(sprintf("[%s] plot ready (split): traces=%s panels=%s", prep$mode_label %||% "3D embedding", as.character(trace_n), n_panels))
        p_grid
      } else {
        p_main <- .build_umap3d_plot(
          df = df,
          color_by = color_by,
          point_size = point_size,
          alpha = alpha,
          title = sprintf("%s - %s", prep$mode_label %||% "3D embedding", prep$object_name),
          seurat_obj = prep$sobj,
          axis_prefix = prep$axis_prefix %||% "UMAP"
        )
        p_main <- .attach_umap3d_gl_diag(p_main)
        trace_n <- tryCatch(length(p_main$x$data), error = function(e) NA_integer_)
        message(sprintf("[%s] plot ready: traces=%s", prep$mode_label %||% "3D embedding", as.character(trace_n)))
        p_main
      }
    }, error = function(e) {
      msg <- paste("3D embedding render error:", conditionMessage(e))
      .umap3d_error(msg)
      message("[3D UMAP] renderPlotly error: ", conditionMessage(e))
      showNotification(msg, type = "error", duration = 8)
      .empty_3d()
    })
  })
  outputOptions(output, "umap3d_plot", suspendWhenHidden = TRUE)

  observeEvent(input$umap3d_gl_diag, {
    info <- input$umap3d_gl_diag
    st <- .scalar_chr(info$status, default = "")
    tr <- suppressWarnings(as.integer(info$traces %||% NA_integer_))
    webgl_unavailable_msg <- "3D embedding WebGL context is unavailable. Close other heavy Plotly views/tabs and retry. If using Safari, ensure WebGL is enabled."
    if (identical(st, "ok")) {
      cur_msg <- .scalar_chr(.umap3d_error(), default = "")
      if (nzchar(cur_msg) && identical(cur_msg, webgl_unavailable_msg)) {
        .umap3d_error(NULL)
      }
      message(sprintf("[3D UMAP] webgl diag: ok traces=%s", as.character(tr)))
      return(invisible(NULL))
    }
    detail <- .scalar_chr(info$detail, default = "")
    message(sprintf("[3D UMAP] webgl diag: status=%s traces=%s detail=%s", st, as.character(tr), detail))
    if (identical(st, "webgl_context_lost")) {
      .umap3d_error(webgl_unavailable_msg)
      showNotification(webgl_unavailable_msg, type = "error", duration = 8)
      return(invisible(NULL))
    }
    if (identical(st, "no_webgl_canvas")) {
      # Startup timing can transiently report no canvas before Plotly fully mounts.
      # Ignore this signal and rely on explicit context-lost events for hard failures.
      return(invisible(NULL))
    }
  }, ignoreInit = TRUE)

  observeEvent(input$download_umap3d_bundle, {
    overlay_show("Building 3D embedding bundle...")
  }, ignoreInit = TRUE)

  output$download_umap3d_bundle <- downloadHandler(
    filename = function() {
      paste0(.sanitize_export_stem(input$umap3d_export_name), "_bundle.zip")
    },
    content = function(file) {
      on.exit(overlay_hide(), add = TRUE)
      if (!isTRUE(.umap3d_requested())) {
        stop("3D embedding bundle is unavailable. Click 'Generate 3D embedding preview' first.")
      }
      prep <- .umap3d_prepared()
      if (is.null(prep)) {
        stop("3D embedding preview is not prepared yet. Please generate embedding preview in 'umap configuration' first.")
      }
      df <- prep$df
      color_by <- input$umap3d_colorby %||% prep$color_cols[1]
      if (!color_by %in% prep$color_cols) color_by <- prep$color_cols[1]
      split_by_raw <- input$umap3d_splitby %||% "__none__"
      split_by <- .normalize_umap3d_split_by(df, split_by_raw)
      split_value <- input$umap3d_split_value %||% character()
      if (!identical(split_by, "__none__") && split_by %in% colnames(df) && length(split_value)) {
        df <- df[df[[split_by]] %in% split_value, , drop = FALSE]
      }
      validate(need(nrow(df) > 0, "No cells remain after applying the 3D split filter."))
      point_size <- as.numeric(input$umap3d_point_size %||% 1.2)
      alpha <- as.numeric(input$umap3d_alpha %||% 0.85)
      stem <- .sanitize_export_stem(input$umap3d_export_name)

      base_widget <- .build_umap3d_plot(
        df = df,
        color_by = color_by,
        point_size = point_size,
        alpha = alpha,
        title = sprintf("%s - %s", prep$mode_label %||% "3D embedding", prep$object_name),
        seurat_obj = prep$sobj,
        axis_prefix = prep$axis_prefix %||% "UMAP"
      )
      state_key <- paste0("umap3d_export_", tolower(prep$axis_prefix %||% "umap"), "_", gsub("[^A-Za-z0-9_.-]+", "_", prep$object_name %||% "dataset"))
      final_widget <- .decorate_umap3d_export_widget(
        widget = base_widget,
        df = df,
        color_cols = prep$color_cols,
        default_color = color_by,
        default_size = point_size,
        default_alpha = alpha,
        state_key = state_key,
        axis_prefix = prep$axis_prefix %||% "UMAP",
        plot_title = sprintf("%s - %s", prep$mode_label %||% "3D embedding", prep$object_name)
      )

      out_dir <- tempfile(pattern = "umap3d_bundle_")
      dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
      html_path <- file.path(out_dir, paste0(stem, ".html"))
      htmlwidgets::saveWidget(final_widget, file = html_path, selfcontained = FALSE, title = sprintf("%s - %s", prep$mode_label %||% "3D embedding", prep$object_name))

      old_wd <- getwd()
      on.exit(setwd(old_wd), add = TRUE)
      setwd(out_dir)
      bundle_items <- c(basename(html_path), paste0(stem, "_files"))
      bundle_items <- bundle_items[file.exists(bundle_items)]
      utils::zip(zipfile = file, files = bundle_items)
    }
  )

  static_heatmap_path <- reactiveVal(NULL)
  pb_overview_cache <- reactiveVal(NULL)
  pb_custom_cache <- reactiveVal(NULL)
  jj_active_key <- reactiveVal(NULL)
  jj_cache_status <- reactiveVal(ANALYSIS_UI_TEXT$t_text_jj_cache_idle)
  jj_display_cfg <- reactiveVal(list(top_n = 10L, ns_fc = 0.25))
  jj_style_cfg <- reactiveVal(list(
    dot_size = 0.9,
    alpha = 0.75,
    up_color = "#d73027",
    down_color = "#4575b4",
    legend_position = "right",
    title = "jjvolcano (per-cluster vs rest)",
    subtitle = "Cached DEG reused unless biological settings change"
  ))
  jj_last_plot <- reactiveVal(NULL)

  observeEvent(shared_data$active_object_name, {
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(nm)) {
      static_heatmap_path(NULL)
      return(invisible(NULL))
    }
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    hp <- tryCatch(entry$plots$heatmap_plot_path, error = function(e) NULL)
    if (!is.null(hp) && nzchar(as.character(hp)) && file.exists(hp)) {
      static_heatmap_path(hp)
    } else {
      static_heatmap_path(NULL)
    }
  }, ignoreInit = FALSE)

  .analysis_cache_get <- function(nm, key, default = NULL) {
    nm <- .scalar_chr(nm, default = "")
    key <- .scalar_chr(key, default = "")
    if (!nzchar(nm) || !nzchar(key)) return(default)
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    if (is.null(entry) || !is.list(entry)) return(default)
    cache <- entry$analysis_cache
    if (is.null(cache) || !is.list(cache) || is.null(cache[[key]])) return(default)
    cache[[key]]
  }

  .analysis_cache_set <- function(nm, key, value) {
    nm <- .scalar_chr(nm, default = "")
    key <- .scalar_chr(key, default = "")
    if (!nzchar(nm) || !nzchar(key)) return(invisible(NULL))
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    if (is.null(entry)) return(invisible(NULL))
    if (!is.list(entry)) entry <- list(obj = entry)
    if (is.null(entry$prefs) || !is.list(entry$prefs)) entry$prefs <- list()
    if (is.null(entry$plots) || !is.list(entry$plots)) entry$plots <- list()
    if (is.null(entry$analysis_cache) || !is.list(entry$analysis_cache)) entry$analysis_cache <- list()
    entry$analysis_cache[[key]] <- value
    shared_data$all_seurat_objects[[nm]] <- entry
    invisible(value)
  }

  .pb_obj_store_get <- function(nm) {
    nm <- .scalar_chr(nm, default = "")
    if (!nzchar(nm)) return(NULL)
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    sobj <- .get_active_sobj(shared_data)
    if (!inherits(sobj, "Seurat")) {
      sobj <- tryCatch(if (is.list(entry) && inherits(entry$obj, "Seurat")) entry$obj else entry, error = function(e) NULL)
    }
    if (!inherits(sobj, "Seurat")) return(NULL)
    misc <- tryCatch(sobj@misc, error = function(e) list())
    ana <- tryCatch(misc$analysis, error = function(e) NULL)
    if (!is.list(ana)) return(list())
    pb <- tryCatch(ana$pseudobulk, error = function(e) NULL)
    if (!is.list(pb)) return(list())
    pb
  }

  .pb_obj_store_set <- function(nm, pb_store) {
    nm <- .scalar_chr(nm, default = "")
    if (!nzchar(nm)) return(invisible(NULL))
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    sobj <- tryCatch(if (is.list(entry) && inherits(entry$obj, "Seurat")) entry$obj else entry, error = function(e) NULL)
    if (!inherits(sobj, "Seurat")) return(invisible(NULL))
    misc <- tryCatch(sobj@misc, error = function(e) list())
    if (!is.list(misc$analysis)) misc$analysis <- list()
    misc$analysis$pseudobulk <- pb_store
    sobj@misc <- misc
    if (is.list(entry) && !is.null(entry$obj)) {
      entry$obj <- sobj
      shared_data$all_seurat_objects[[nm]] <- entry
    } else {
      shared_data$all_seurat_objects[[nm]] <- sobj
    }
    invisible(pb_store)
  }

  .pb_obj_branch_get <- function(nm, branch = c("overview", "custom"), default = NULL) {
    branch <- match.arg(branch)
    pb <- .pb_obj_store_get(nm)
    if (!is.list(pb) || is.null(pb[[branch]])) return(default)
    pb[[branch]]
  }

  .pb_obj_branch_set <- function(nm, branch = c("overview", "custom"), value) {
    branch <- match.arg(branch)
    pb <- .pb_obj_store_get(nm)
    if (!is.list(pb)) pb <- list()
    pb[[branch]] <- value
    .pb_obj_store_set(nm, pb)
    invisible(value)
  }

  .pb_overview_key_from_inputs <- function(nm, sobj = NULL) {
    nm <- .scalar_chr(nm, default = "")
    if (!nzchar(nm)) return(NULL)
    if (is.null(sobj)) sobj <- .get_active_sobj(shared_data)
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
    paste(
      .cfg_object_signature(sobj, object_name = nm),
      as.character(input$de_res_select %||% ""),
      as.character(input$de_sample_col %||% "orig.ident"),
      as.character(input$de_de_method %||% "edgeR"),
      as.character(as.integer(input$de_max_genes %||% 2000L)),
      sep = "|"
    )
  }

  .pb_custom_key_from_inputs <- function(nm, sobj = NULL) {
    nm <- .scalar_chr(nm, default = "")
    if (!nzchar(nm)) return(NULL)
    if (is.null(sobj)) sobj <- .get_active_sobj(shared_data)
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
    paste(
      .cfg_object_signature(sobj, object_name = nm),
      as.character(input$de_res_select %||% ""),
      as.character(input$de_sample_col %||% "orig.ident"),
      as.character(input$de_de_method %||% "edgeR"),
      as.character(as.integer(input$de_max_genes %||% 2000L)),
      as.character(input$pb_custom_mode %||% "cluster_vs_cluster"),
      as.character(input$pb_cluster_a %||% ""),
      as.character(input$pb_cluster_b %||% ""),
      as.character(input$pb_group_var %||% ""),
      as.character(input$pb_group_a %||% ""),
      as.character(input$pb_group_b %||% ""),
      sep = "|"
    )
  }

  .restore_pb_caches <- function() {
    nm <- shared_data$active_object_name
    sobj <- .get_active_sobj(shared_data)
    nm <- .scalar_chr(nm, default = "")
    if (!nzchar(nm) || is.null(sobj) || !inherits(sobj, "Seurat")) {
      pb_overview_cache(NULL)
      pb_custom_cache(NULL)
      return(invisible(NULL))
    }
    k_over <- .pb_overview_key_from_inputs(nm, sobj = sobj)
    k_custom <- .pb_custom_key_from_inputs(nm, sobj = sobj)

    over_payload <- .pb_obj_branch_get(nm, "overview", default = NULL)
    if (is.list(over_payload) && identical(over_payload$key %||% NULL, k_over) && !is.null(over_payload$result)) {
      pb_overview_cache(over_payload$result)
    } else {
      pb_overview_cache(NULL)
    }

    custom_payload <- .pb_obj_branch_get(nm, "custom", default = NULL)
    if (is.list(custom_payload) && identical(custom_payload$key %||% NULL, k_custom) && !is.null(custom_payload$result)) {
      pb_custom_cache(custom_payload$result)
    } else {
      pb_custom_cache(NULL)
    }
    invisible(NULL)
  }
  
  .jj_get_bucket <- function(nm) {
    bucket <- tryCatch(shared_data$all_seurat_objects[[nm]]$analysis_cache$jjvolcano, error = function(e) NULL)
    if (is.null(bucket) || !is.list(bucket)) {
      return(list(entries = list(), last_key = NULL, last_hit = FALSE, last_run = NULL))
    }
    bucket$entries <- bucket$entries %||% list()
    bucket$last_key <- bucket$last_key %||% NULL
    bucket$last_hit <- isTRUE(bucket$last_hit)
    bucket$last_run <- bucket$last_run %||% NULL
    bucket
  }
  
  .jj_set_bucket <- function(nm, bucket) {
    shared_data$all_seurat_objects[[nm]]$analysis_cache$jjvolcano <- bucket
    invisible(bucket)
  }
  
  .jj_build_bio_key <- function(nm, resolution_col) {
    paste(
      as.character(nm %||% ""),
      as.character(input$de_res_select %||% ""),
      as.character(resolution_col %||% ""),
      as.character(input$de_de_method %||% "edgeR"),
      as.character(input$de_sample_col %||% "orig.ident"),
      as.character(as.integer(input$de_max_genes %||% 2000)),
      sep = "|"
    )
  }

  .jj_error_text <- function(e, fallback = "Unknown jjvolcano error.") {
    msg <- tryCatch(conditionMessage(e), error = function(err) "")
    if (is.null(msg) || !nzchar(trimws(msg))) {
      msg <- tryCatch(as.character(e), error = function(err) "")
    }
    if (length(msg) > 1L) msg <- msg[[1L]]
    if (is.null(msg) || !nzchar(trimws(msg)) || identical(msg, "[object Object]")) {
      cls <- tryCatch(paste(class(e), collapse = "/"), error = function(err) "unknown")
      msg <- paste0(fallback, " (", cls, ")")
    }
    msg
  }

  .jj_palette_seurat <- function(n) {
    n <- as.integer(n %||% 0L)
    if (!is.finite(n) || n < 1L) return(character())
    fn <- tryCatch(getFromNamespace("DiscretePalette", "Seurat"), error = function(e) NULL)
    pal <- NULL
    if (is.function(fn)) {
      pal <- tryCatch(suppressWarnings(fn(n)), error = function(e) NULL)
    }
    if (is.null(pal) || length(pal) < n) {
      pal <- grDevices::hcl.colors(max(n, 3L), palette = "Dark 3")[seq_len(n)]
    } else {
      pal <- as.character(pal)[seq_len(n)]
    }
    pal
  }

  .jj_colors_from_dimplot <- function(sobj, resolution_col, cluster_levels) {
    if (is.null(sobj) || !nzchar(as.character(resolution_col))) return(NULL)
    if (!resolution_col %in% colnames(sobj@meta.data)) return(NULL)
    reds <- tryCatch(tolower(names(sobj@reductions)), error = function(e) character())
    red_use <- if ("umap" %in% reds) names(sobj@reductions)[match("umap", reds)] else NULL
    if (is.null(red_use) && length(names(sobj@reductions))) red_use <- names(sobj@reductions)[1]
    if (is.null(red_use) || !nzchar(red_use)) return(NULL)

    p_tmp <- tryCatch(
      Seurat::DimPlot(sobj, reduction = red_use, group.by = resolution_col),
      error = function(e) NULL
    )
    if (is.null(p_tmp) || !inherits(p_tmp, "ggplot")) return(NULL)

    d_plot <- tryCatch(p_tmp$data, error = function(e) NULL)
    d_layer <- tryCatch(ggplot2::ggplot_build(p_tmp)$data[[1]], error = function(e) NULL)
    if (is.null(d_plot) || is.null(d_layer) || !nrow(d_plot) || !nrow(d_layer)) return(NULL)
    if (!resolution_col %in% colnames(d_plot)) return(NULL)

    vals <- as.character(d_plot[[resolution_col]])
    cols <- as.character(d_layer$colour)
    n <- min(length(vals), length(cols))
    if (n < 1) return(NULL)
    vals <- vals[seq_len(n)]
    cols <- cols[seq_len(n)]
    keep <- !is.na(vals) & nzchar(vals) & !is.na(cols) & nzchar(cols)
    vals <- vals[keep]
    cols <- cols[keep]
    if (!length(vals) || !length(cols)) return(NULL)

    first_idx <- match(unique(vals), vals)
    map <- cols[first_idx]
    names(map) <- unique(vals)
    mapped <- unname(map[cluster_levels])
    names(mapped) <- cluster_levels
    if (!length(mapped) || all(is.na(mapped) | !nzchar(mapped))) return(NULL)
    mapped
  }

  .jj_all_cluster_levels <- function(sobj, resolution_col, fallback = character()) {
    if (is.null(sobj) || !nzchar(as.character(resolution_col))) return(as.character(fallback))
    if (!resolution_col %in% colnames(sobj@meta.data)) return(as.character(fallback))
    vals <- sobj@meta.data[[resolution_col]]
    vals <- .factor_numeric_first(vals)
    lv <- tryCatch(levels(vals), error = function(e) NULL)
    if (!is.null(lv) && length(lv)) return(as.character(lv))
    uniq <- sort(unique(as.character(vals)), method = "radix")
    uniq[!is.na(uniq) & nzchar(uniq)]
  }
  
  .jj_current_entry <- reactive({
    nm <- shared_data$active_object_name
    key <- jj_active_key()
    req(nm, key)
    bucket <- .jj_get_bucket(nm)
    bucket$entries[[key]]
  })

  .select_pref_or_last <- function(choices, current = NULL) {
    vals <- as.character(choices %||% character())
    vals <- vals[!is.na(vals) & nzchar(vals)]
    if (!length(vals)) return("")
    cur <- as.character(current %||% "")
    if (length(cur) && nzchar(cur) && cur %in% vals) return(cur[[1]])
    vals[[length(vals)]]
  }

  .select_pref_or_first <- function(choices, preferred = character(), current = NULL) {
    vals <- as.character(choices %||% character())
    vals <- vals[!is.na(vals) & nzchar(vals)]
    if (!length(vals)) return("")
    cur <- as.character(current %||% "")
    if (length(cur) && nzchar(cur) && cur %in% vals) return(cur[[1]])
    hit <- preferred[preferred %in% vals][1]
    if (!is.na(hit) && nzchar(hit)) return(hit)
    vals[[1]]
  }
  
  .run_jjvolcano <- function(force = FALSE) {
    sobj <- .get_active_sobj(shared_data)
    if (is.null(sobj)) stop("No active object is available for jjvolcano.")
    nm <- shared_data$active_object_name
    nm <- .scalar_chr(nm, default = "")
    if (!nzchar(nm)) stop("No active object name is set.")
    cluster_col <- as.character(input$de_res_select %||% "")
    if (!nzchar(cluster_col)) stop("Select a metadata column before running jjvolcano.")
    if (!cluster_col %in% colnames(sobj@meta.data)) {
      stop("Selected metadata column was not found in active object.")
    }

    key <- .jj_build_bio_key(nm = nm, resolution_col = cluster_col)
    bucket <- .jj_get_bucket(nm)
    hit <- (!isTRUE(force)) && !is.null(bucket$entries[[key]])
    if (!hit) {
      env_path <- tryCatch(shared_data$active_environment$path, error = function(e) NULL)
      original_lib_paths <- .libPaths()
      if (!is.null(env_path) && nzchar(as.character(env_path))) {
        .libPaths(c(env_path, original_lib_paths))
      } else {
        .libPaths(original_lib_paths)
      }
      on.exit(.libPaths(original_lib_paths), add = TRUE)
      pb <- core_analysis_tab_d_compute_pseudobulk(
        seurat_obj = sobj,
        resolution_col = cluster_col,
        sample_col = input$de_sample_col %||% "orig.ident",
        max_genes = as.integer(input$de_max_genes %||% 2000),
        de_method = input$de_de_method %||% "edgeR",
        mode = "per_cluster_vs_rest"
      )
      pb$resolution_col <- cluster_col
      bucket$entries[[key]] <- list(
        pb = pb,
        resolution = NA_real_,
        resolution_col = cluster_col,
        params = list(
          de_method = input$de_de_method %||% "edgeR",
          sample_col = input$de_sample_col %||% "orig.ident",
          max_genes = as.integer(input$de_max_genes %||% 2000)
        ),
        created_at = as.character(Sys.time())
      )
    }
    bucket$last_key <- key
    bucket$last_hit <- hit
    bucket$last_run <- as.character(Sys.time())
    .jj_set_bucket(nm, bucket)
    jj_active_key(key)
    jj_cache_status(if (hit) ANALYSIS_UI_TEXT$t_text_jj_cache_hit else ANALYSIS_UI_TEXT$t_text_jj_cache_miss)
    invisible(bucket$entries[[key]])
  }
  
  # ---------------- PSEUDOBULK (cluster determination)
  output$de_res_select_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    choices <- .de_cluster_metadata_columns(sobj)
    if (!length(choices)) return(helpText(ANALYSIS_UI_TEXT$t_text_no_metadata_columns_available))
    preferred <- c(
      "annotation", "celltype", "cell_type", "celltypes", "cell_types",
      "final_label", "predicted_labels", "majority_voting", "seurat_clusters"
    )
    selected <- .select_pref_or_first(choices, preferred = preferred, current = input$de_res_select)
    selectInput("de_res_select", ANALYSIS_UI_TEXT$t_label_de_cluster_metadata_column, choices = choices, selected = selected)
  })
  
  output$de_sample_col_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    cols <- .grouping_columns(sobj)
    sample_pref <- c("orig.ident", "sample", "sample_name", "condition", "batch")
    default <- .select_pref_or_first(cols, preferred = sample_pref, current = input$de_sample_col)
    selectInput("de_sample_col", ANALYSIS_UI_TEXT$t_label_pseudobulk_replicate_column, choices = cols, selected = default)
  })
  
  output$jj_cluster_select_ui <- renderUI({
    entry <- .jj_current_entry()
    if (is.null(entry) || is.null(entry$pb) || is.null(entry$pb$per_cluster) || !nrow(entry$pb$per_cluster)) {
      return(helpText(ANALYSIS_UI_TEXT$t_text_jj_cache_idle))
    }
    clusters <- sort(unique(as.character(entry$pb$per_cluster$cluster)))
    selectInput("jj_cluster_select", ANALYSIS_UI_TEXT$t_label_jj_cluster, choices = clusters, selected = clusters[[1]])
  })
  
  output$jj_cache_status_text <- renderText({
    jj_cache_status()
  })
  
  .pb_cluster_choices <- reactive({
    pb <- pb_overview_cache()
    if (!is.null(pb) && !is.null(pb$meta) && nrow(pb$meta)) {
      return(sort(unique(as.character(pb$meta$cluster))))
    }
    sobj <- .get_active_sobj(shared_data); req(sobj)
    cluster_col <- as.character(input$de_res_select %||% "")
    req(nzchar(cluster_col), cluster_col %in% colnames(sobj@meta.data))
    sort(unique(as.character(sobj@meta.data[[cluster_col]])))
  })
  
  output$pb_cluster_a_ui <- renderUI({
    cl <- .pb_cluster_choices()
    selectizeInput("pb_cluster_a", ANALYSIS_UI_TEXT$t_label_cluster_set, choices = cl, selected = head(cl, 1), multiple = TRUE)
  })
  output$pb_cluster_b_ui <- renderUI({
    cl <- .pb_cluster_choices()
    selected_b <- if (length(cl) > 1) cl[2] else cl[1]
    selectizeInput("pb_cluster_b", ANALYSIS_UI_TEXT$t_label_cluster_set_b, choices = cl, selected = selected_b, multiple = TRUE)
  })
  
  output$pb_group_var_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    cols <- .grouping_columns(sobj)
    group_pref <- c("condition", "batch", "orig.ident", "sample")
    default <- group_pref[group_pref %in% cols][1] %||% cols[1]
    selectInput("pb_group_var", ANALYSIS_UI_TEXT$t_label_grouping_column, choices = cols, selected = default)
  })
  
  .pb_group_levels <- reactive({
    sobj <- .get_active_sobj(shared_data); req(sobj)
    gv <- input$pb_group_var %||% "condition"
    req(gv %in% colnames(sobj@meta.data))
    sort(unique(as.character(sobj@meta.data[[gv]])))
  })
  
  output$pb_group_a_ui <- renderUI({
    lv <- .pb_group_levels()
    selectInput("pb_group_a", ANALYSIS_UI_TEXT$t_label_group, choices = lv, selected = lv[1])
  })
  output$pb_group_b_ui <- renderUI({
    lv <- .pb_group_levels()
    selected_b <- if (length(lv) > 1) lv[2] else lv[1]
    selectInput("pb_group_b", ANALYSIS_UI_TEXT$t_label_group_b, choices = lv, selected = selected_b)
  })
  
  .run_pb_overview <- function() {
    sobj <- .get_active_sobj(shared_data); req(sobj)
    nm <- shared_data$active_object_name %||% ""
    req(nzchar(nm))
    cluster_col <- as.character(input$de_res_select %||% "")
    req(nzchar(cluster_col), cluster_col %in% colnames(sobj@meta.data))
    cache_key <- .pb_overview_key_from_inputs(nm, sobj = sobj)
    payload <- .pb_obj_branch_get(nm, "overview", default = NULL)
    if (is.list(payload) && identical(payload$key %||% NULL, cache_key) && !is.null(payload$result)) {
      pb_overview_cache(payload$result)
      return(payload$result)
    }
    sobj2 <- sobj
    if (!"umap" %in% tolower(names(sobj2@reductions))) {
      sobj2 <- Seurat::RunUMAP(
        sobj2,
        dims = seq_len(.effective_dims()),
        seed.use = as.integer(input$cfg_seed_input %||% 42),
        verbose = FALSE
      )
    }
    nm <- shared_data$active_object_name
    shared_data$all_seurat_objects[[nm]]$obj <- sobj2
    
    pb <- core_analysis_tab_d_compute_pseudobulk(
      seurat_obj = sobj2,
      resolution_col = cluster_col,
      sample_col = input$de_sample_col %||% "orig.ident",
      max_genes = as.integer(input$de_max_genes %||% 2000),
      de_method = input$de_de_method %||% "edgeR",
      mode = "per_cluster_vs_rest"
    )
    pb$resolution_col <- cluster_col
    pb_overview_cache(pb)
    .pb_obj_branch_set(nm, "overview", list(
      key = cache_key,
      result = pb,
      metadata_column = cluster_col,
      compare_mode = "per_cluster_vs_rest",
      params = list(
        sample_col = input$de_sample_col %||% "orig.ident",
        max_genes = as.integer(input$de_max_genes %||% 2000),
        de_method = input$de_de_method %||% "edgeR"
      ),
      updated_at = as.character(Sys.time())
    ))
    invisible(pb)
  }

  observeEvent(list(shared_data$active_object_name, input$de_res_select, input$de_sample_col, input$de_de_method, input$de_max_genes), {
    .restore_pb_caches()
  }, ignoreInit = TRUE)

  observeEvent(list(input$pb_custom_mode, input$pb_cluster_a, input$pb_cluster_b, input$pb_group_var, input$pb_group_a, input$pb_group_b), {
    .restore_pb_caches()
  }, ignoreInit = TRUE)

  observeEvent(shared_data$active_object_name, {
    .restore_pb_caches()
  }, ignoreInit = FALSE)
  
  observeEvent(input$pb_refresh_btn, {
    tryCatch({
      overlay_show("Loading pseudobulk overview...")
      on.exit(overlay_hide(), add = TRUE)
      .run_pb_overview()
      showNotification("Pseudobulk overview refreshed.", type = "message", duration = 2)
    }, error = function(e) {
      showNotification(paste("Pseudobulk refresh failed:", e$message), type = "error", duration = 5)
    })
  }, ignoreInit = TRUE)
  
  observeEvent(input$pb_run_custom_btn, {
    overlay_show("Running custom pseudobulk comparison...")
    on.exit(overlay_hide(), add = TRUE)
    sobj <- .get_active_sobj(shared_data); req(sobj)
    nm <- shared_data$active_object_name %||% ""
    req(nzchar(nm))
    cluster_col <- as.character(input$de_res_select %||% "")
    req(nzchar(cluster_col), cluster_col %in% colnames(sobj@meta.data))
    cache_key <- .pb_custom_key_from_inputs(nm, sobj = sobj)
    payload <- .pb_obj_branch_get(nm, "custom", default = NULL)
    if (is.list(payload) && identical(payload$key %||% NULL, cache_key) && !is.null(payload$result)) {
      pb_custom_cache(payload$result)
      showNotification("Loaded cached custom pseudobulk result.", type = "message", duration = 2)
      return(invisible(NULL))
    }
    sobj2 <- sobj
    
    mode <- input$pb_custom_mode %||% "cluster_vs_cluster"
    result <- tryCatch(
      core_analysis_tab_d_compute_pseudobulk(
        seurat_obj = sobj2,
        resolution_col = cluster_col,
        sample_col = input$de_sample_col %||% "orig.ident",
        max_genes = as.integer(input$de_max_genes %||% 2000),
        de_method = input$de_de_method %||% "edgeR",
        mode = mode,
        cluster_a = input$pb_cluster_a %||% character(),
        cluster_b = input$pb_cluster_b %||% character(),
        group_var = input$pb_group_var %||% NULL,
        group_a = input$pb_group_a %||% NULL,
        group_b = input$pb_group_b %||% NULL
      ),
      error = function(e) {
        showNotification(paste("Custom pseudobulk error:", e$message), type = "error", duration = 8)
        NULL
      }
    )
    pb_custom_cache(result)
    if (!is.null(result)) {
      .pb_obj_branch_set(nm, "custom", list(
        key = cache_key,
        result = result,
        metadata_column = cluster_col,
        compare_mode = mode,
        params = list(
          sample_col = input$de_sample_col %||% "orig.ident",
          max_genes = as.integer(input$de_max_genes %||% 2000),
          de_method = input$de_de_method %||% "edgeR",
          cluster_a = input$pb_cluster_a %||% character(),
          cluster_b = input$pb_cluster_b %||% character(),
          group_var = input$pb_group_var %||% NULL,
          group_a = input$pb_group_a %||% NULL,
          group_b = input$pb_group_b %||% NULL
        ),
        updated_at = as.character(Sys.time())
      ))
    }
  }, ignoreInit = TRUE)
  
  .jj_not_ready_note <- function() {
    has_pkg <- requireNamespace("scRNAtoolVis", quietly = TRUE)
    has_fun <- FALSE
    if (isTRUE(has_pkg)) {
      has_fun <- is.function(
        tryCatch(getExportedValue("scRNAtoolVis", "jjVolcano"), error = function(e) NULL)
      )
    }
    if (!isTRUE(has_pkg) || !isTRUE(has_fun)) return(ANALYSIS_UI_TEXT$t_text_jj_package_required)
    nm <- .scalar_chr(shared_data$active_object_name, "")
    key <- .scalar_chr(jj_active_key(), "")
    if (!nzchar(nm) || !nzchar(key)) return(ANALYSIS_UI_TEXT$t_text_jj_cache_idle)
    bucket <- .jj_get_bucket(nm)
    entry <- bucket$entries[[key]]
    if (!is.list(entry) || is.null(entry$pb) || is.null(entry$pb$per_cluster) || nrow(entry$pb$per_cluster) < 1L) {
      return(ANALYSIS_UI_TEXT$t_text_jj_cache_idle)
    }
    d <- entry$pb$per_cluster
    has_plot_rows <- FALSE
    if (is.data.frame(d) && all(c("logFC", "p_adj") %in% colnames(d))) {
      keep <- is.finite(d$logFC) & !is.na(d$p_adj)
      has_plot_rows <- isTRUE(any(keep))
    }
    if (!isTRUE(has_plot_rows)) return(ANALYSIS_UI_TEXT$t_text_jj_no_finite)
    NULL
  }

  output$jjvolcano_plot_ui <- renderUI({
    tab_now <- input$plot_tabs %||% "differential expression analysis"
    if (!identical(tab_now, "differential expression analysis")) return(NULL)
    note <- .jj_not_ready_note()
    if (nzchar(note %||% "")) return(plot_card_not_ready_ui(note = note, height_px = 360L))
    plotOutput("jjvolcano_plot", width = "100%", height = "620px")
  })

  output$pb_umap_plot_ui <- renderUI({
    tab_now <- input$plot_tabs %||% "differential expression analysis"
    if (!identical(tab_now, "differential expression analysis")) return(NULL)
    pb <- pb_overview_cache()
    if (is.null(pb)) {
      return(plot_card_not_ready_ui(note = ANALYSIS_UI_TEXT$t_text_pseudobulk_idle, height_px = 360L))
    }
    sobj <- .get_active_sobj(shared_data)
    has_umap <- !is.null(sobj) && any(tolower(names(sobj@reductions)) %in% "umap")
    if (!isTRUE(has_umap)) {
      return(plot_card_not_ready_ui(note = ANALYSIS_UI_TEXT$t_text_pseudobulk_umap_not_ready, height_px = 360L))
    }
    plotOutput("pb_umap_plot", width = "100%")
  })

  output$pb_volcano_grid_plot_ui <- renderUI({
    tab_now <- input$plot_tabs %||% "differential expression analysis"
    if (!identical(tab_now, "differential expression analysis")) return(NULL)
    pb <- pb_overview_cache()
    if (is.null(pb) || is.null(pb$per_cluster) || !nrow(pb$per_cluster)) {
      return(plot_card_not_ready_ui(note = ANALYSIS_UI_TEXT$t_text_pseudobulk_idle, height_px = 360L))
    }
    plotOutput("pb_volcano_grid_plot", width = "100%")
  })

  output$pb_custom_volcano_plot_ui <- renderUI({
    tab_now <- input$plot_tabs %||% "differential expression analysis"
    if (!identical(tab_now, "differential expression analysis")) return(NULL)
    pb <- pb_custom_cache()
    if (is.null(pb) || is.null(pb$custom) || !nrow(pb$custom)) {
      return(plot_card_not_ready_ui(note = ANALYSIS_UI_TEXT$t_text_custom_idle, height_px = 360L))
    }
    plotOutput("pb_custom_volcano_plot", width = "100%")
  })

  output$pb_umap_plot <- renderPlot({
    tab_now <- input$plot_tabs %||% "differential expression analysis"
    if (!identical(tab_now, "differential expression analysis")) return(invisible(NULL))
    pb <- pb_overview_cache()
    req(!is.null(pb))
    sobj <- .get_active_sobj(shared_data); req(sobj, input$de_res_select)
    cluster_col <- as.character(input$de_res_select %||% "")
    req(nzchar(cluster_col), cluster_col %in% colnames(sobj@meta.data))
    sobj2 <- sobj
    req("umap" %in% tolower(names(sobj2@reductions)))
    p <- Seurat::DimPlot(sobj2, reduction = "umap", group.by = cluster_col) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(legend.position = "top", legend.direction = "horizontal", legend.box = "horizontal") +
      ggplot2::labs(title = sprintf("UMAP grouped by %s", cluster_col)) +
      ggplot2::coord_equal()
    lg_dot <- .umap_legend_dot_size(.umap_point_size_from_plot(p, 0.85), 10)
    p <- p + ggplot2::guides(
      colour = ggplot2::guide_legend(override.aes = list(size = lg_dot, alpha = 1)),
      color  = ggplot2::guide_legend(override.aes = list(size = lg_dot, alpha = 1))
    )
    print(p)
  })
  
  output$pb_volcano_grid_plot <- renderPlot({
    tab_now <- input$plot_tabs %||% "differential expression analysis"
    if (!identical(tab_now, "differential expression analysis")) return(invisible(NULL))
    pb <- pb_overview_cache()
    req(!is.null(pb), !is.null(pb$per_cluster), nrow(pb$per_cluster) > 0)
    df <- pb$per_cluster
    df <- df[is.finite(df$logFC) & is.finite(df$neglog10_fdr), , drop = FALSE]
    req(nrow(df) > 0)
    ggplot2::ggplot(df, ggplot2::aes(x = logFC, y = neglog10_fdr)) +
      ggplot2::geom_point(size = 0.55, alpha = 0.5, color = "#2f3e4e") +
      ggplot2::geom_vline(xintercept = 0, linetype = 2, color = "#9ca3af") +
      ggplot2::facet_wrap(~cluster, ncol = 4, scales = "free_y") +
      ggplot2::theme_minimal(base_size = 11) +
      ggplot2::labs(
        title = ANALYSIS_UI_TEXT$t_text_per_cluster_volcano_cluster_vs_rest,
        x = "Fold change (pseudobulk mean difference)",
        y = "-log10(FDR)"
      )
  })
  
  output$pb_custom_volcano_plot <- renderPlot({
    tab_now <- input$plot_tabs %||% "differential expression analysis"
    if (!identical(tab_now, "differential expression analysis")) return(invisible(NULL))
    pb <- pb_custom_cache()
    req(!is.null(pb), !is.null(pb$custom), nrow(pb$custom) > 0)
    df <- pb$custom
    df <- df[is.finite(df$logFC) & is.finite(df$neglog10_fdr), , drop = FALSE]
    req(nrow(df) > 0)
    prelog_thr <- suppressWarnings(as.numeric(input$pb_custom_prelog_threshold %||% 0.05))
    if (!is.finite(prelog_thr) || is.na(prelog_thr) || prelog_thr <= 0 || prelog_thr >= 1) prelog_thr <- 0.05
    y_cut <- -log10(pmax(prelog_thr, 1e-300))
    top_n <- suppressWarnings(as.integer(input$pb_custom_top_n %||% 12L))
    if (!is.finite(top_n) || is.na(top_n) || top_n < 1L) top_n <- 12L

    df$is_sig <- FALSE
    if ("p_adj" %in% colnames(df)) {
      padj <- suppressWarnings(as.numeric(df$p_adj))
      df$is_sig <- is.finite(padj) & (padj <= prelog_thr)
    } else {
      df$is_sig <- is.finite(df$neglog10_fdr) & (df$neglog10_fdr >= y_cut)
    }

    gene_col <- c("gene", "gene_symbol", "symbol", "feature", "features")
    gene_col <- gene_col[gene_col %in% colnames(df)][1]
    label_df <- NULL
    if (isTRUE(input$pb_custom_label_genes) && !is.na(gene_col) && nzchar(gene_col)) {
      cand <- df[df$is_sig & is.finite(df$logFC) & is.finite(df$neglog10_fdr), , drop = FALSE]
      if (nrow(cand)) {
        padj_ord <- if ("p_adj" %in% colnames(cand)) suppressWarnings(as.numeric(cand$p_adj)) else rep(NA_real_, nrow(cand))
        cand <- cand[order(padj_ord, -abs(cand$logFC), na.last = NA), , drop = FALSE]
        label_df <- head(cand, top_n)
      }
    }

    ttl <- unique(df$comparison %||% "Custom comparison")
    p <- ggplot2::ggplot(df, ggplot2::aes(x = logFC, y = neglog10_fdr)) +
      ggplot2::geom_point(ggplot2::aes(color = is_sig), size = 0.85, alpha = 0.62) +
      ggplot2::scale_color_manual(values = c(`TRUE` = "#c2410c", `FALSE` = "#9ca3af"), guide = "none") +
      ggplot2::geom_vline(xintercept = 0, linetype = 2, color = "#9ca3af") +
      ggplot2::geom_hline(yintercept = y_cut, linetype = 3, color = "#6b7280") +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::labs(
        title = ttl[1],
        x = "Fold change (pseudobulk mean difference)",
        y = "-log10(FDR)"
      )
    if (!is.null(label_df) && nrow(label_df)) {
      label_df$label_gene <- as.character(label_df[[gene_col]])
      if (requireNamespace("ggrepel", quietly = TRUE)) {
        p <- p + ggrepel::geom_text_repel(
          data = label_df,
          ggplot2::aes(label = label_gene),
          size = 3.0,
          max.overlaps = Inf,
          box.padding = 0.3,
          point.padding = 0.15,
          segment.alpha = 0.4,
          min.segment.length = 0
        )
      } else {
        p <- p + ggplot2::geom_text(
          data = label_df,
          ggplot2::aes(label = label_gene),
          size = 3.0,
          check_overlap = TRUE,
          vjust = -0.35
        )
      }
    }
    p
  })
  
  observeEvent(input$jj_run_btn, {
    tryCatch({
      overlay_show("Running jjvolcano...")
      on.exit(overlay_hide(), add = TRUE)
      .run_jjvolcano(force = FALSE)
      showNotification(ANALYSIS_UI_TEXT$t_text_jj_ready, type = "message", duration = 2)
    }, error = function(e) {
      showNotification(
        paste(ANALYSIS_UI_TEXT$t_text_jj_error_prefix, .jj_error_text(e)),
        type = "error",
        duration = 10
      )
    })
  }, ignoreInit = TRUE)
  
  observeEvent(shared_data$active_object_name, {
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    if (!nzchar(nm)) {
      jj_active_key(NULL)
      jj_cache_status(ANALYSIS_UI_TEXT$t_text_jj_cache_idle)
      return(invisible(NULL))
    }
    bucket <- .jj_get_bucket(nm)
    last_key <- bucket$last_key %||% NULL
    if (!is.null(last_key) && nzchar(as.character(last_key)) && !is.null(bucket$entries[[last_key]])) {
      jj_active_key(last_key)
      jj_cache_status(ANALYSIS_UI_TEXT$t_text_jj_cache_hit)
    } else {
      jj_active_key(NULL)
      jj_cache_status(ANALYSIS_UI_TEXT$t_text_jj_cache_idle)
    }
  }, ignoreInit = FALSE)

  observeEvent(list(input$de_res_select, input$de_sample_col, input$de_de_method, input$de_max_genes), {
    # Do not clear active cache on control refresh; only mark stale so users can
    # keep viewing the last rendered result and rerun when ready.
    if (!is.null(jj_active_key())) {
      jj_cache_status("jjvolcano settings changed. Click 'Run jjvolcano' to refresh.")
    } else {
      jj_cache_status(ANALYSIS_UI_TEXT$t_text_jj_cache_idle)
    }
  }, ignoreInit = TRUE)

  observeEvent(input$jj_apply_display_btn, {
    top_n <- suppressWarnings(as.integer(input$jj_top_n %||% 10L))
    if (!is.finite(top_n) || is.na(top_n) || top_n < 1L) top_n <- 10L
    ns_fc <- suppressWarnings(as.numeric(input$jj_ns_fc_threshold %||% 0.25))
    if (!is.finite(ns_fc) || is.na(ns_fc) || ns_fc < 0) ns_fc <- 0.25
    jj_display_cfg(list(top_n = top_n, ns_fc = ns_fc))
    dot_size <- suppressWarnings(as.numeric(input$jj_dot_size %||% 0.9))
    if (!is.finite(dot_size) || is.na(dot_size) || dot_size <= 0) dot_size <- 0.9
    alpha <- suppressWarnings(as.numeric(input$jj_alpha %||% 0.75))
    if (!is.finite(alpha) || is.na(alpha) || alpha <= 0 || alpha > 1) alpha <- 0.75
    up_color <- as.character(input$jj_up_color %||% "#d73027")
    down_color <- as.character(input$jj_down_color %||% "#4575b4")
    legend_pos <- as.character(input$jj_legend_position %||% "right")
    if (!legend_pos %in% c("right", "bottom", "none")) legend_pos <- "right"
    ttl <- as.character(input$jj_plot_title %||% "jjvolcano (per-cluster vs rest)")
    subttl <- as.character(input$jj_plot_subtitle %||% "Cached DEG reused unless biological settings change")
    jj_style_cfg(list(
      dot_size = dot_size,
      alpha = alpha,
      up_color = up_color,
      down_color = down_color,
      legend_position = legend_pos,
      title = ttl,
      subtitle = subttl
    ))
    showNotification("Display settings applied.", type = "message", duration = 2)
  }, ignoreInit = TRUE)
  
  output$jjvolcano_plot <- renderPlot({
    tab_now <- input$plot_tabs %||% "differential expression analysis"
    if (!identical(tab_now, "differential expression analysis")) return(invisible(NULL))
    note <- .jj_not_ready_note()
    if (nzchar(note %||% "")) return(invisible(NULL))
    entry <- .jj_current_entry()
    req(!is.null(entry), !is.null(entry$pb), !is.null(entry$pb$per_cluster), nrow(entry$pb$per_cluster) > 0)
    withProgress(message = "Rendering jjvolcano panels...", value = 0, {
      incProgress(0.15, detail = "Preparing data")
      d <- entry$pb$per_cluster
      d <- d[is.finite(d$logFC) & !is.na(d$p_adj), , drop = FALSE]
      req(nrow(d) > 0)
      disp_cfg <- jj_display_cfg() %||% list(top_n = 10L, ns_fc = 0.25)
      sty_cfg <- jj_style_cfg() %||% list(
        dot_size = 0.9,
        alpha = 0.75,
        up_color = "#d73027",
        down_color = "#4575b4",
        legend_position = "right",
        title = "jjvolcano (per-cluster vs rest)",
        subtitle = "Cached DEG reused unless biological settings change"
      )
      fc_cut <- suppressWarnings(as.numeric(disp_cfg$ns_fc %||% 0.25))
      if (!is.finite(fc_cut) || is.na(fc_cut) || fc_cut < 0) fc_cut <- 0.25
      d$cluster <- as.character(d$cluster)
      invalid_cluster_idx <- is.na(d$cluster) | !nzchar(d$cluster)
      if (any(invalid_cluster_idx)) {
        .perf_log("diag:jjvolcano_cluster_state_invalid", details = c(
          sprintf("active=%s", .scalar_chr(shared_data$active_object_name, "<empty>")),
          sprintf("resolution=%s", .scalar_chr(entry$resolution_col, "<empty>")),
          sprintf("invalid_rows=%d", sum(invalid_cluster_idx)),
          sprintf("total_rows=%d", nrow(d))
        ))
        stop("jjvolcano state invalid: per-cluster DEG table contains missing/empty cluster IDs.")
      }
      d$direction <- "NS"
      d$direction[d$logFC >= fc_cut] <- "UP"
      d$direction[d$logFC <= -fc_cut] <- "DOWN"
      d$direction <- factor(d$direction, levels = c("UP", "DOWN", "NS"))

      top_n <- suppressWarnings(as.integer(disp_cfg$top_n %||% 10L))
      if (!is.finite(top_n) || is.na(top_n) || top_n < 1L) top_n <- 10L
      d$label <- ""

      incProgress(0.35, detail = "Selecting labels")
      by_cluster <- split(seq_len(nrow(d)), d$cluster)
      for (idx in by_cluster) {
        up_idx <- idx[d$direction[idx] == "UP"]
        down_idx <- idx[d$direction[idx] == "DOWN"]
        if (length(up_idx)) {
          up_ord <- up_idx[order(d$p_adj[up_idx], -d$logFC[up_idx], decreasing = FALSE, na.last = TRUE)]
          keep_up <- up_ord[seq_len(min(top_n, length(up_ord)))]
          d$label[keep_up] <- as.character(d$gene[keep_up])
        }
        if (length(down_idx)) {
          down_ord <- down_idx[order(d$p_adj[down_idx], d$logFC[down_idx], decreasing = FALSE, na.last = TRUE)]
          keep_down <- down_ord[seq_len(min(top_n, length(down_ord)))]
          d$label[keep_down] <- as.character(d$gene[keep_down])
        }
      }

      data_clusters <- unique(as.character(d$cluster))
      data_clusters <- data_clusters[!is.na(data_clusters) & nzchar(data_clusters)]
      if (!length(data_clusters)) {
        .perf_log("diag:jjvolcano_cluster_state_invalid", details = c(
          sprintf("active=%s", .scalar_chr(shared_data$active_object_name, "<empty>")),
          sprintf("resolution=%s", .scalar_chr(entry$resolution_col, "<empty>")),
          "reason=no_data_clusters"
        ))
        stop("jjvolcano state invalid: no non-empty cluster IDs found in per-cluster DEG table.")
      }

      sobj_now <- .get_active_sobj(shared_data)
      res_col <- as.character(entry$resolution_col %||% "")
      meta_clusters <- as.character(.jj_all_cluster_levels(sobj_now, res_col, fallback = character()))
      meta_clusters <- meta_clusters[!is.na(meta_clusters) & nzchar(meta_clusters)]
      if (!length(meta_clusters)) {
        panel_levels <- data_clusters
        if (length(panel_levels) && all(grepl("^-?[0-9]+$", panel_levels))) {
          panel_levels <- panel_levels[order(as.numeric(panel_levels))]
        } else if (length(panel_levels)) {
          panel_levels <- sort(panel_levels, method = "radix")
        }
      } else {
        data_only <- setdiff(data_clusters, meta_clusters)
        if (length(data_only) && all(grepl("^-?[0-9]+$", data_only))) {
          data_only <- data_only[order(as.numeric(data_only))]
        } else if (length(data_only)) {
          data_only <- sort(data_only, method = "radix")
        }
        panel_levels <- c(meta_clusters, data_only)
      }
      panel_levels <- unique(panel_levels)
      panel_levels <- panel_levels[!is.na(panel_levels) & nzchar(panel_levels)]
      if (!length(panel_levels)) {
        .perf_log("diag:jjvolcano_cluster_state_invalid", details = c(
          sprintf("active=%s", .scalar_chr(shared_data$active_object_name, "<empty>")),
          sprintf("resolution=%s", .scalar_chr(res_col, "<empty>")),
          "reason=no_panel_levels"
        ))
        stop("jjvolcano state invalid: unable to resolve plot panel clusters.")
      }
      data_only <- setdiff(data_clusters, meta_clusters)
      meta_only <- setdiff(meta_clusters, data_clusters)
      if (length(data_only) || length(meta_only)) {
        .perf_log("diag:jjvolcano_cluster_sync", details = c(
          sprintf("active=%s", .scalar_chr(shared_data$active_object_name, "<empty>")),
          sprintf("resolution=%s", .scalar_chr(res_col, "<empty>")),
          sprintf("n_data=%d", length(data_clusters)),
          sprintf("n_meta=%d", length(meta_clusters)),
          sprintf("n_panels=%d", length(panel_levels)),
          sprintf("data_only=%s", if (length(data_only)) paste(utils::head(data_only, 12), collapse = ",") else "<none>"),
          sprintf("meta_only=%s", if (length(meta_only)) paste(utils::head(meta_only, 12), collapse = ",") else "<none>")
        ))
      }
      fallback_colors <- .jj_palette_seurat(length(panel_levels))
      names(fallback_colors) <- panel_levels

      # Match UMAP cluster colors from the active Seurat object/resolution.
      cluster_colors <- fallback_colors
      if (!is.null(sobj_now) && nzchar(res_col) && res_col %in% colnames(sobj_now@meta.data)) {
        vals <- sobj_now@meta.data[[res_col]]
        vals <- .factor_numeric_first(vals)
        lv <- levels(vals)
        if (length(lv) > 0) {
          lv <- as.character(lv)
          present <- lv[lv %in% panel_levels]
          missing <- setdiff(panel_levels, present)
          if (length(missing) && all(grepl("^-?[0-9]+$", missing))) {
            missing <- missing[order(as.numeric(missing))]
          } else if (length(missing)) {
            missing <- sort(missing, method = "radix")
          }
          panel_levels <- c(present, missing)
          pal_lv <- .jj_palette_seurat(length(lv))
          names(pal_lv) <- lv
          mapped <- unname(pal_lv[panel_levels])
          na_idx <- is.na(mapped) | !nzchar(mapped)
          mapped[na_idx] <- unname(fallback_colors[panel_levels][na_idx])
          cluster_colors <- mapped
          names(cluster_colors) <- panel_levels
        }
      } else {
        if (length(panel_levels) && all(grepl("^-?[0-9]+$", panel_levels))) {
          panel_levels <- panel_levels[order(as.numeric(panel_levels))]
        } else {
          panel_levels <- sort(panel_levels, method = "radix")
        }
        cluster_colors <- unname(fallback_colors[panel_levels])
        names(cluster_colors) <- panel_levels
      }
      from_umap <- .jj_colors_from_dimplot(sobj_now, res_col, panel_levels)
      if (!is.null(from_umap)) {
        na_idx <- is.na(from_umap) | !nzchar(from_umap)
        if (any(na_idx)) from_umap[na_idx] <- cluster_colors[na_idx]
        cluster_colors <- from_umap
      }
      d$cluster <- factor(d$cluster, levels = panel_levels)
      if (any(is.na(d$cluster))) {
        bad_vals <- unique(as.character(d$cluster[is.na(d$cluster)]))
        .perf_log("diag:jjvolcano_cluster_state_invalid", details = c(
          sprintf("active=%s", .scalar_chr(shared_data$active_object_name, "<empty>")),
          sprintf("resolution=%s", .scalar_chr(res_col, "<empty>")),
          sprintf("reason=unmapped_after_factor"),
          sprintf("unmapped=%s", if (length(bad_vals)) paste(utils::head(bad_vals, 12), collapse = ",") else "<unknown>")
        ))
        stop("jjvolcano state invalid: one or more DEG clusters could not be mapped to panel levels.")
      }
      facet_cols <- max(1L, length(panel_levels))

      y_rng <- range(d$logFC, finite = TRUE)
      y_span <- diff(y_rng)
      if (!is.finite(y_span) || y_span <= 0) y_span <- max(1, abs(y_rng[2]))
      y_pad <- y_span * 0.05
      y_lim <- c(y_rng[1] - y_pad, y_rng[2] + y_pad)
      band_h <- y_span * 0.08
      band_h <- max(band_h, 0.12)
      ribbon_ymin <- -band_h * 0.5
      ribbon_ymax <- band_h * 0.5
      y_lim <- c(min(y_lim[1], ribbon_ymin), max(y_lim[2], ribbon_ymax))
      annot_df <- data.frame(
        cluster = factor(panel_levels, levels = panel_levels),
        x = 1,
        y = 0,
        ymin = ribbon_ymin,
        ymax = ribbon_ymax,
        label = panel_levels,
        stringsAsFactors = FALSE
      )
      # Gray backdrop per cluster to show the main spread/range of points.
      shadow_df <- do.call(rbind, lapply(panel_levels, function(cl) {
        yv <- d$logFC[d$cluster == cl]
        yv <- yv[is.finite(yv)]
        if (!length(yv)) return(NULL)
        q <- stats::quantile(yv, probs = c(0.03, 0.97), na.rm = TRUE, names = FALSE)
        if (!all(is.finite(q))) return(NULL)
        pad <- max(0.15, 0.08 * (q[2] - q[1]))
        data.frame(
          cluster = factor(cl, levels = panel_levels),
          xmin = 0.72,
          xmax = 1.28,
          ymin = q[1] - pad,
          ymax = q[2] + pad,
          stringsAsFactors = FALSE
        )
      }))

      incProgress(0.85, detail = "Building plot")
      p <- ggplot2::ggplot(d, ggplot2::aes(x = 1, y = logFC, color = direction)) +
        ggplot2::geom_rect(
          data = shadow_df,
          ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
          inherit.aes = FALSE,
          fill = "#d1d5db",
          alpha = 0.35,
          color = NA
        ) +
        ggplot2::geom_hline(yintercept = 0, color = "#4b5563", linewidth = 0.5, show.legend = FALSE) +
        ggplot2::geom_hline(yintercept = c(-fc_cut, fc_cut), color = "#9ca3af", linewidth = 0.4, linetype = 2, show.legend = FALSE) +
        ggplot2::geom_jitter(width = 0.28, height = 0, size = as.numeric(sty_cfg$dot_size %||% 0.9), alpha = as.numeric(sty_cfg$alpha %||% 0.75)) +
        {
          if (requireNamespace("ggrepel", quietly = TRUE)) {
            ggrepel::geom_label_repel(
              data = d[d$label != "", , drop = FALSE],
              ggplot2::aes(label = label),
              size = 2.6,
              max.overlaps = Inf,
              min.segment.length = 0,
              segment.alpha = 0.45,
              box.padding = 0.35,
              point.padding = 0.25,
              force = 1.3,
              force_pull = 0.2,
              label.size = 0,
              fill = grDevices::adjustcolor("white", alpha.f = 0.72),
              label.padding = grid::unit(0.12, "lines"),
              show.legend = FALSE
            )
          } else {
            ggplot2::geom_text(
              data = d[d$label != "", , drop = FALSE],
              ggplot2::aes(label = label),
              size = 3,
              check_overlap = TRUE,
              show.legend = FALSE
            )
          }
        } +
        ggplot2::geom_rect(
          data = annot_df,
          ggplot2::aes(xmin = -Inf, xmax = Inf, ymin = ymin, ymax = ymax, fill = cluster),
          inherit.aes = FALSE,
          alpha = 1,
          color = NA
        ) +
        ggplot2::geom_text(
          data = annot_df,
          ggplot2::aes(x = x, y = y, label = label),
          inherit.aes = FALSE,
          color = "#0f172a",
          size = 3.1,
          fontface = "bold"
        ) +
        ggplot2::facet_wrap(~cluster, nrow = 1, ncol = facet_cols, drop = FALSE) +
        ggplot2::scale_color_manual(values = c(
          UP = as.character(sty_cfg$up_color %||% "#d73027"),
          DOWN = as.character(sty_cfg$down_color %||% "#4575b4"),
          NS = "#9ca3af"
        )) +
        ggplot2::scale_fill_manual(values = cluster_colors, guide = "none") +
        ggplot2::coord_cartesian(ylim = y_lim) +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::labs(
          title = sty_cfg$title %||% "jjvolcano (all clusters)",
          subtitle = sprintf("%s | %s",
                             sty_cfg$subtitle %||% "Cached DEG reused unless biological settings change",
                             if (isTRUE(.jj_get_bucket(shared_data$active_object_name)$last_hit)) ANALYSIS_UI_TEXT$t_text_jj_status_cache_hit else ANALYSIS_UI_TEXT$t_text_jj_status_recomputed),
          x = "Clusters",
          y = "Average log2FoldChange",
          color = "Direction"
        ) +
        ggplot2::theme(
          legend.position = as.character(sty_cfg$legend_position %||% "right"),
          axis.text.x = ggplot2::element_blank(),
          axis.ticks.x = ggplot2::element_blank(),
          panel.grid.major.x = ggplot2::element_blank(),
          strip.background = ggplot2::element_rect(fill = "#f3f4f6", color = NA),
          strip.text = ggplot2::element_blank()
        )
      incProgress(1, detail = "Done")
      jj_last_plot(p)
      print(p)
    })
  }, height = function() {
    h <- suppressWarnings(as.numeric(session$clientData$output_jjvolcano_plot_height))
    if (!is.finite(h) || h < 720) h <- 720
    as.integer(h)
  }, width = function() {
    entry <- tryCatch(.jj_current_entry(), error = function(e) NULL)
    sobj_now <- .get_active_sobj(shared_data)
    res_col <- tryCatch(as.character(entry$resolution_col %||% ""), error = function(e) "")
    all_levels <- .jj_all_cluster_levels(sobj_now, res_col, fallback = character())
    if (length(all_levels)) {
      n_clusters <- length(all_levels)
    } else {
      if (is.null(entry) || is.null(entry$pb) || is.null(entry$pb$per_cluster) || !nrow(entry$pb$per_cluster)) return(2200)
      n_clusters <- length(unique(as.character(entry$pb$per_cluster$cluster)))
    }
    if (!is.finite(n_clusters) || n_clusters < 1) n_clusters <- 1L
    # Keep single-row facets and make each panel ~20% narrower than the prior 200px baseline.
    panel_w <- 72L
    legend_pad <- 260L
    as.integer(max(1800L, n_clusters * panel_w + legend_pad))
  })

  # ---------------- UNIFIED TOOL ANNOTATION (SingleR / CellTypist)
  cellmarker_tbl <- reactiveVal(data.frame())

  .ensure_annotation_store <- function() {
    if (is.null(shared_data$annotation_layers) || !is.list(shared_data$annotation_layers)) {
      shared_data$annotation_layers <- list()
    }
    if (is.null(shared_data$active_annotation_layer) || !is.list(shared_data$active_annotation_layer)) {
      shared_data$active_annotation_layer <- list()
    }
    if (is.null(shared_data$annotation_refresh_token)) {
      shared_data$annotation_refresh_token <- ""
    }
  }
  .touch_annotation_store <- function() {
    shared_data$annotation_refresh_token <- sprintf(
      "%0.6f_%06d",
      as.numeric(Sys.time()),
      sample.int(999999L, 1L)
    )
  }
  .set_active_annotation_layer <- function(object_name, layer_name, update_inputs = TRUE) {
    .ensure_annotation_store()
    object_name <- .scalar_chr(object_name, "")
    layer_name <- .scalar_chr(layer_name, "")
    if (!nzchar(object_name) || !nzchar(layer_name)) return(invisible(FALSE))
    bucket <- shared_data$annotation_layers[[object_name]]
    if (is.null(bucket) || !length(bucket) || is.null(bucket[[layer_name]])) return(invisible(FALSE))
    active_map <- shared_data$active_annotation_layer
    if (is.null(active_map) || !is.list(active_map)) active_map <- list()
    active_map[[object_name]] <- layer_name
    shared_data$active_annotation_layer <- active_map
    .touch_annotation_store()
    if (isTRUE(update_inputs)) {
      try(updateSelectInput(session, "anno_active_layer", selected = layer_name), silent = TRUE)
      try(updateSelectInput(session, "anno_singler_resolution_switcher", selected = layer_name), silent = TRUE)
      try(updateSelectInput(session, "anno_markergene_resolution_switcher", selected = layer_name), silent = TRUE)
    }
    invisible(TRUE)
  }
  .sanitize_layer_id <- function(x) {
    y <- gsub("[^A-Za-z0-9_]+", "_", as.character(x %||% "layer"))
    y <- gsub("_+", "_", y)
    y <- gsub("^_|_$", "", y)
    if (!nzchar(y)) y <- "layer"
    tolower(y)
  }
  .extract_raw_barcode <- function(x) {
    x <- as.character(x %||% "")
    m <- regexpr("[ACGTNacgtn]+-[0-9]+", x, perl = TRUE)
    out <- rep("", length(x))
    ok <- m > 0
    if (any(ok)) out[ok] <- substring(x[ok], m[ok], m[ok] + attr(m, "match.length")[ok] - 1)
    out
  }
  .anno_discrete_palette <- function(n) {
    n <- suppressWarnings(as.integer(n))
    if (!is.finite(n) || n < 1L) return(character(0))
    fn <- tryCatch(getFromNamespace("DiscretePalette", "Seurat"), error = function(e) NULL)
    if (is.function(fn)) {
      pal <- tryCatch(suppressWarnings(fn(n)), error = function(e) NULL)
      if (!is.null(pal) && length(pal) >= n) return(as.character(pal)[seq_len(n)])
    }
    scales::hue_pal()(n)
  }
  .anno_label_color_map <- function(labels) {
    lv <- as.character(labels %||% character(0))
    lv[is.na(lv) | !nzchar(lv)] <- "Unassigned"
    lv <- .sort_levels_natural(lv)
    lv <- unique(lv)
    if (!length(lv)) return(setNames(character(0), character(0)))
    pal <- .anno_discrete_palette(length(lv))
    names(pal) <- lv
    if ("Unassigned" %in% names(pal)) pal["Unassigned"] <- "#9ca3af"
    pal
  }
  .store_tool_layer <- function(object_name, layer_name, tool_name, result_df, params = list()) {
    .ensure_annotation_store()
    layers_all <- shared_data$annotation_layers
    if (is.null(layers_all) || !is.list(layers_all)) layers_all <- list()
    bucket <- layers_all[[object_name]]
    if (is.null(bucket) || !is.list(bucket)) bucket <- list()
    layer <- list(
      layer_name = layer_name,
      layer_type = "tool",
      tool_name = tool_name,
      source = "main_analysis_annotation_tab",
      params = params,
      params_json = jsonlite::toJSON(params, auto_unbox = TRUE, null = "null"),
      created_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"),
      active = TRUE,
      n_cells = nrow(result_df %||% data.frame()),
      n_assigned = sum(nzchar(as.character(result_df$final_label %||% "")), na.rm = TRUE),
      n_ambiguous = sum(as.character(result_df$status %||% "") %in% c("ambiguous", "unresolved"), na.rm = TRUE),
      table = result_df
    )
    bucket[[layer_name]] <- layer
    layers_all[[object_name]] <- bucket
    shared_data$annotation_layers <- layers_all
    .set_active_annotation_layer(object_name, layer_name, update_inputs = FALSE)
    invisible(layer)
  }
  .get_active_layer_table <- reactive({
    .ensure_annotation_store()
    shared_data$annotation_refresh_token
    nm <- .scalar_chr(shared_data$active_object_name, "")
    if (!nzchar(nm)) return(NULL)
    bucket <- shared_data$annotation_layers[[nm]]
    if (is.null(bucket) || !length(bucket)) return(NULL)
    is_tool <- vapply(bucket, function(x) identical(as.character(x$layer_type %||% ""), "tool"), logical(1))
    bucket <- bucket[is_tool]
    if (!length(bucket)) return(NULL)
    lyr <- .scalar_chr((shared_data$active_annotation_layer %||% list())[[nm]], "")
    if (!nzchar(lyr) || is.null(bucket[[lyr]])) lyr <- names(bucket)[[1]]
    bucket[[lyr]]$table
  })
  .apply_tool_layer_to_metadata <- function(object_name, layer_name) {
    .ensure_annotation_store()
    bucket <- shared_data$annotation_layers[[object_name]]
    if (is.null(bucket) || !length(bucket) || is.null(bucket[[layer_name]])) stop("Selected layer is unavailable.")
    tbl <- as.data.frame(bucket[[layer_name]]$table %||% data.frame(), stringsAsFactors = FALSE)
    if (!nrow(tbl) || !all(c("cell", "final_label", "raw_label", "confidence", "tool") %in% colnames(tbl))) {
      stop("Layer table is missing required columns.")
    }
    entry <- shared_data$all_seurat_objects[[object_name]]
    if (is.null(entry)) stop("Active object is unavailable.")
    sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    md <- sobj@meta.data
    if (is.null(md) || !nrow(md)) stop("No metadata available.")
    cells <- as.character(tbl$cell)
    keep <- nzchar(cells) & cells %in% rownames(md)
    tbl <- tbl[keep, , drop = FALSE]
    if (!nrow(tbl)) stop("No matching cells between layer and metadata.")

    lid <- .sanitize_layer_id(layer_name)
    out_cols <- c(
      final_label = sprintf("anno_%s_final_label", lid),
      raw_label = sprintf("anno_%s_raw_label", lid),
      confidence = sprintf("anno_%s_confidence", lid),
      tool = sprintf("anno_%s_tool", lid),
      status = sprintf("anno_%s_status", lid)
    )
    for (nm_col in out_cols) {
      if (!(nm_col %in% colnames(md))) md[[nm_col]] <- NA_character_
    }
    md[tbl$cell, out_cols[["final_label"]]] <- as.character(tbl$final_label)
    md[tbl$cell, out_cols[["raw_label"]]] <- as.character(tbl$raw_label)
    md[tbl$cell, out_cols[["confidence"]]] <- as.character(tbl$confidence)
    md[tbl$cell, out_cols[["tool"]]] <- as.character(tbl$tool)
    md[tbl$cell, out_cols[["status"]]] <- as.character(tbl$status)
    sobj@meta.data <- md

    if (is.list(entry) && !is.null(entry$obj)) {
      entry$obj <- sobj
      shared_data$all_seurat_objects[[object_name]] <- entry
    } else {
      shared_data$all_seurat_objects[[object_name]] <- list(
        obj = sobj,
        prefs = list(),
        plots = list(),
        analysis_cache = list()
      )
    }
  }
  .anno_lib_paths <- function() {
    .canon <- function(p) {
      p <- as.character(p %||% "")
      if (!nzchar(p)) return("")
      p <- gsub("\\\\", "/", p)
      p <- sub("(^|/)package_libraries_user(/|$)", "\\1package_libraries\\2", p, perl = TRUE)
      tryCatch(normalizePath(p, winslash = "/", mustWork = FALSE), error = function(e) p)
    }
    env <- shared_data$active_environment %||% list()
    core_paths <- env$core_paths %||% character(0)
    core_paths <- as.character(unlist(core_paths, use.names = FALSE))
    core_paths <- vapply(core_paths, .canon, character(1))
    core_paths <- core_paths[nzchar(core_paths) & dir.exists(core_paths)]
    env_path <- as.character(env$path %||% "")
    env_path <- vapply(env_path, .canon, character(1))
    env_path <- env_path[nzchar(env_path) & dir.exists(env_path)]
    # Backward-compatible fallback for sessions activated before core_paths was recorded.
    project_root <- tryCatch(normalizePath(here::here(".."), mustWork = FALSE), error = function(e) "")
    fallback_core <- unique(c(
      if (length(env_path)) file.path(dirname(env_path), "core") else character(0),
      if (nzchar(project_root)) file.path(project_root, "package_libraries", "core") else character(0)
    ))
    fallback_core <- fallback_core[nzchar(fallback_core) & dir.exists(fallback_core)]
    core_paths <- unique(c(core_paths, fallback_core))
    current <- .libPaths()
    keep <- current[!grepl("package_libraries(_user)?[/\\\\](core|seurat_v[45])$", current)]
    unique(c(core_paths, env_path, keep))
  }
  .with_anno_libpaths <- function(expr) {
    old <- .libPaths()
    on.exit(.libPaths(old), add = TRUE)
    .libPaths(.anno_lib_paths())
    force(expr)
  }
  .anno_pick_lib_for_pkgs <- function(pkgs = c("SingleR", "celldex")) {
    libs <- .anno_lib_paths()
    libs <- libs[nzchar(libs) & dir.exists(libs)]
    if (!length(libs)) return("")
    for (lib in libs) {
      ok <- vapply(pkgs, function(pkg) {
        isTRUE(tryCatch(requireNamespace(pkg, quietly = TRUE, lib.loc = lib), error = function(e) FALSE))
      }, logical(1))
      if (all(ok)) return(lib)
    }
    ""
  }
  .anno_check_pkgs <- function(pkgs = c("SingleR", "celldex")) {
    libs <- .anno_lib_paths()
    libs <- libs[nzchar(libs) & dir.exists(libs)]
    if (!length(libs)) {
      return(list(found = FALSE, lib = "", load_ok = FALSE, error = "No candidate library paths found.", libs = character(0)))
    }
    for (lib in libs) {
      have <- tryCatch(rownames(installed.packages(lib.loc = lib)), error = function(e) character(0))
      if (!all(pkgs %in% have)) next
      old <- .libPaths()
      on.exit(.libPaths(old), add = TRUE)
      .libPaths(unique(c(lib, old)))
      ok <- TRUE
      err <- ""
      for (pkg in pkgs) {
        one_ok <- tryCatch({
          suppressPackageStartupMessages(library(pkg, character.only = TRUE, lib.loc = lib))
          TRUE
        }, error = function(e) {
          err <<- conditionMessage(e)
          FALSE
        })
        if (!isTRUE(one_ok)) {
          ok <- FALSE
          break
        }
      }
      return(list(found = TRUE, lib = lib, load_ok = isTRUE(ok), error = err, libs = libs))
    }
    list(found = FALSE, lib = "", load_ok = FALSE, error = "Package directories not found in candidate libraries.", libs = libs)
  }
  .anno_cluster_columns <- function(sobj) {
    cols <- tryCatch(colnames(sobj@meta.data), error = function(e) character(0))
    if (!length(cols)) return(character(0))
    res_cols <- .find_resolution_columns(sobj)
    cluster_like <- cols[grepl("(seurat_clusters|cluster|clust|snn_res\\.|leiden_res\\.|_res\\.)", tolower(cols))]
    unique(c(res_cols, cluster_like))
  }
  .anno_init_markergene_ranking_store <- function() {
    if (is.null(shared_data$annotation_marker_rankings) || !is.list(shared_data$annotation_marker_rankings)) {
      shared_data$annotation_marker_rankings <- list()
    }
  }
  .anno_markergene_read_file <- function(fi) {
    if (is.null(fi) || is.null(fi$datapath) || !nzchar(fi$datapath) || !file.exists(fi$datapath)) return(NULL)
    ext <- tolower(tools::file_ext(fi$name %||% ""))
    if (ext %in% c("csv")) {
      return(utils::read.csv(fi$datapath, stringsAsFactors = FALSE, check.names = FALSE))
    }
    utils::read.delim(fi$datapath, stringsAsFactors = FALSE, check.names = FALSE)
  }
  .anno_markergene_parse_paste <- function(txt) {
    txt <- as.character(txt %||% "")
    if (!nzchar(txt)) return(data.frame(label = character(0), gene = character(0), source = character(0), stringsAsFactors = FALSE))
    lines <- trimws(unlist(strsplit(txt, "\\r?\\n"), use.names = FALSE))
    lines <- lines[nzchar(lines)]
    if (!length(lines)) return(data.frame(label = character(0), gene = character(0), source = character(0), stringsAsFactors = FALSE))
    out <- lapply(lines, function(line) {
      if (!grepl(":", line, fixed = TRUE)) return(NULL)
      parts <- strsplit(line, ":", fixed = TRUE)[[1]]
      if (length(parts) < 2L) return(NULL)
      label <- trimws(parts[[1]])
      genes_txt <- paste(parts[-1], collapse = ":")
      genes <- trimws(unlist(strsplit(genes_txt, ",", fixed = TRUE), use.names = FALSE))
      genes <- genes[nzchar(genes)]
      if (!nzchar(label) || !length(genes)) return(NULL)
      data.frame(label = rep(label, length(genes)), gene = genes, source = "paste", stringsAsFactors = FALSE)
    })
    out <- Filter(Negate(is.null), out)
    if (!length(out)) return(data.frame(label = character(0), gene = character(0), source = character(0), stringsAsFactors = FALSE))
    do.call(rbind, out)
  }
  .anno_markergene_collect_pairs <- function() {
    raw_file <- .anno_markergene_read_file(input$anno_markergene_file)
    file_pairs <- data.frame(label = character(0), gene = character(0), source = character(0), stringsAsFactors = FALSE)
    issues <- character(0)
    if (is.data.frame(raw_file) && nrow(raw_file)) {
      cn <- colnames(raw_file)
      low <- tolower(cn)
      lbl_idx <- match("label", low)
      gene_idx <- match("gene", low)
      if (!is.finite(lbl_idx) || !is.finite(gene_idx)) {
        issues <- c(issues, "Marker file should contain columns 'label' and 'gene'.")
      } else {
        file_pairs <- data.frame(
          label = as.character(raw_file[[lbl_idx]] %||% ""),
          gene = as.character(raw_file[[gene_idx]] %||% ""),
          source = "file",
          stringsAsFactors = FALSE
        )
      }
    }
    paste_pairs <- .anno_markergene_parse_paste(input$anno_markergene_paste)
    pairs <- rbind(file_pairs, paste_pairs)
    if (!nrow(pairs)) {
      return(list(
        pairs = data.frame(label = character(0), gene = character(0), source = character(0), stringsAsFactors = FALSE),
        issues = unique(issues)
      ))
    }
    pairs$label <- trimws(as.character(pairs$label %||% ""))
    pairs$gene <- trimws(as.character(pairs$gene %||% ""))
    pairs <- pairs[nzchar(pairs$label) & nzchar(pairs$gene), c("label", "gene", "source"), drop = FALSE]
    pairs$label <- gsub("\\s+", " ", pairs$label)
    pairs <- unique(pairs)
    list(pairs = pairs, issues = unique(issues))
  }
  .anno_markergene_prepare <- function(sobj = NULL) {
    pairs_info <- .anno_markergene_collect_pairs()
    pairs <- pairs_info$pairs
    issues <- as.character(pairs_info$issues %||% character(0))
    min_genes <- suppressWarnings(as.integer(input$anno_markergene_min_genes %||% 3L))
    if (!is.finite(min_genes) || min_genes < 1L) min_genes <- 1L
    max_genes <- suppressWarnings(as.integer(input$anno_markergene_max_genes %||% 50L))
    if (!is.finite(max_genes) || max_genes < 0L) max_genes <- 0L

    if (!nrow(pairs)) {
      return(list(
        marker_sets = list(),
        diagnostics = list(
          issues = unique(c(issues, ANALYSIS_UI_TEXT$t_text_annotation_markergene_no_markers)),
          n_labels = 0L,
          n_pairs = 0L,
          n_genes_matched = 0L
        )
      ))
    }

    raw_gene_dups <- sum(duplicated(tolower(pairs$gene)))
    cross_label <- aggregate(label ~ gene, data = unique(pairs[, c("label", "gene"), drop = FALSE]), FUN = function(x) length(unique(as.character(x))))
    cross_label_dup_n <- sum(cross_label$label > 1L, na.rm = TRUE)

    marker_sets <- split(pairs$gene, pairs$label)
    marker_sets <- lapply(marker_sets, function(gs) unique(trimws(as.character(gs %||% character(0)))))
    marker_sets <- marker_sets[vapply(marker_sets, length, integer(1)) > 0L]

    matched_gene_total <- 0L
    if (!is.null(sobj)) {
      expr <- .analysis_get_assay_data(sobj, assay = "RNA", layer = "data")
      query_genes <- as.character(rownames(expr %||% matrix(nrow = 0, ncol = 0)))
      if (length(query_genes)) {
        q_map <- setNames(query_genes, tolower(query_genes))
        marker_sets <- lapply(marker_sets, function(gs) {
          x <- q_map[tolower(gs)]
          x <- as.character(x[!is.na(x) & nzchar(x)])
          unique(x)
        })
        matched_gene_total <- sum(vapply(marker_sets, length, integer(1)))
      }
    }

    marker_sets <- marker_sets[vapply(marker_sets, length, integer(1)) >= min_genes]
    if (max_genes > 0L) {
      marker_sets <- lapply(marker_sets, function(gs) gs[seq_len(min(length(gs), max_genes))])
    }

    raw_genes <- unique(as.character(pairs$gene %||% character(0)))
    frac_upper <- if (length(raw_genes)) mean(grepl("^[A-Z0-9\\-\\.]+$", raw_genes)) else NA_real_
    frac_title <- if (length(raw_genes)) mean(grepl("^[A-Z][a-z0-9]+$", raw_genes)) else NA_real_
    style_warning <- if (is.finite(frac_upper) && is.finite(frac_title) && frac_upper > 0.25 && frac_title > 0.25) {
      "Marker gene symbols include mixed naming styles (upper + title case). Verify species/ID style consistency."
    } else {
      ""
    }

    if (!length(marker_sets)) {
      issues <- c(issues, "No marker labels passed min/max gene filters after matching to the active object.")
    }
    diagnostics <- list(
      issues = unique(issues[nzchar(issues)]),
      style_warning = style_warning,
      n_labels = length(marker_sets),
      n_pairs = nrow(pairs),
      n_genes_matched = matched_gene_total,
      duplicate_gene_rows = raw_gene_dups,
      genes_shared_by_multiple_labels = cross_label_dup_n,
      min_genes = min_genes,
      max_genes = max_genes
    )
    list(marker_sets = marker_sets, diagnostics = diagnostics)
  }
  .anno_markergene_cell_scores <- function(expr, marker_sets) {
    labels <- names(marker_sets %||% list())
    if (!length(labels) || ncol(expr) < 1L) {
      return(matrix(numeric(0), nrow = ncol(expr), ncol = 0, dimnames = list(colnames(expr), character(0))))
    }
    out <- vapply(labels, function(lbl) {
      genes <- marker_sets[[lbl]] %||% character(0)
      genes <- genes[nzchar(genes) & genes %in% rownames(expr)]
      if (!length(genes)) return(rep(0, ncol(expr)))
      suppressWarnings(as.numeric(Matrix::colMeans(expr[genes, , drop = FALSE])))
    }, numeric(ncol(expr)))
    if (is.null(dim(out))) out <- matrix(out, ncol = length(labels))
    rownames(out) <- colnames(expr)
    colnames(out) <- labels
    out
  }
  .anno_markergene_cluster_markers <- function(expr, cluster_values, cluster_id, top_n = 200L) {
    idx_in <- which(cluster_values == cluster_id)
    idx_out <- which(cluster_values != cluster_id)
    if (!length(idx_in) || !length(idx_out)) return(character(0))
    mu_in <- suppressWarnings(as.numeric(Matrix::rowMeans(expr[, idx_in, drop = FALSE])))
    mu_out <- suppressWarnings(as.numeric(Matrix::rowMeans(expr[, idx_out, drop = FALSE])))
    logfc <- mu_in - mu_out
    names(logfc) <- rownames(expr)
    keep <- is.finite(logfc) & !is.na(names(logfc)) & nzchar(names(logfc))
    logfc <- logfc[keep]
    if (!length(logfc)) return(character(0))
    logfc <- sort(logfc, decreasing = TRUE)
    logfc <- logfc[logfc > 0]
    if (!length(logfc)) return(character(0))
    names(logfc)[seq_len(min(length(logfc), as.integer(top_n)))]
  }
  .anno_markergene_best_enrichment <- function(cluster_markers, marker_sets, universe_genes) {
    if (!length(cluster_markers) || !length(marker_sets) || length(universe_genes) < 10L) {
      return(list(label = "ambiguous", score = 0, p_value = NA_real_, overlap = 0L))
    }
    cluster_markers <- unique(cluster_markers[cluster_markers %in% universe_genes])
    if (!length(cluster_markers)) return(list(label = "ambiguous", score = 0, p_value = NA_real_, overlap = 0L))
    u <- length(universe_genes)
    lab_scores <- lapply(names(marker_sets), function(lbl) {
      s <- unique(marker_sets[[lbl]] %||% character(0))
      s <- s[s %in% universe_genes]
      if (!length(s)) return(list(label = lbl, score = 0, p_value = 1, overlap = 0L))
      a <- length(intersect(cluster_markers, s))
      b <- length(cluster_markers) - a
      c <- length(s) - a
      d <- max(0L, u - a - b - c)
      mat <- matrix(c(a, b, c, d), nrow = 2, byrow = TRUE)
      p <- tryCatch(stats::fisher.test(mat, alternative = "greater")$p.value, error = function(e) 1)
      score <- -log10(max(p, 1e-300))
      list(label = lbl, score = score, p_value = p, overlap = a)
    })
    ord <- order(vapply(lab_scores, function(x) x$score, numeric(1)), decreasing = TRUE)
    best <- lab_scores[[ord[[1]]]]
    list(
      label = as.character(best$label %||% "ambiguous"),
      score = as.numeric(best$score %||% 0),
      p_value = as.numeric(best$p_value %||% NA_real_),
      overlap = as.integer(best$overlap %||% 0L)
    )
  }
  .anno_markergene_score_resolution <- function(sobj, cluster_col, marker_sets, margin_thresh = 0.02) {
    expr <- .analysis_get_assay_data(sobj, assay = "RNA", layer = "data")
    if (!("RNA" %in% Seurat::Assays(sobj))) stop("MarkerGene requires RNA assay.")
    if (is.null(expr) || nrow(expr) < 1L || ncol(expr) < 1L) stop("RNA expression matrix is empty.")
    cluster_values <- as.character(sobj@meta.data[[cluster_col]] %||% "")
    cluster_values[is.na(cluster_values) | !nzchar(cluster_values)] <- "NA_CLUSTER"
    names(cluster_values) <- rownames(sobj@meta.data)
    common_cells <- intersect(colnames(expr), names(cluster_values))
    if (!length(common_cells)) stop("No overlapping cells between expression matrix and metadata cluster column.")
    expr <- expr[, common_cells, drop = FALSE]
    cluster_values <- cluster_values[common_cells]

    score_mat <- .anno_markergene_cell_scores(expr, marker_sets)
    if (ncol(score_mat) < 1L) stop("No marker labels could be scored after gene matching.")
    cls <- unique(cluster_values)
    cls <- cls[nzchar(cls)]
    cl_rows <- lapply(cls, function(cl) {
      idx <- which(cluster_values == cl)
      cl_scores <- colMeans(score_mat[idx, , drop = FALSE], na.rm = TRUE)
      cl_scores[!is.finite(cl_scores)] <- 0
      ord <- order(cl_scores, decreasing = TRUE)
      top1 <- names(cl_scores)[ord[[1]]]
      top2 <- if (length(ord) > 1L) names(cl_scores)[ord[[2]]] else ""
      s1 <- as.numeric(cl_scores[ord[[1]]])
      s2 <- if (length(ord) > 1L) as.numeric(cl_scores[ord[[2]]]) else 0
      margin <- s1 - s2
      module_label <- if (is.finite(margin) && margin >= margin_thresh) top1 else "ambiguous"
      cl_markers <- .anno_markergene_cluster_markers(expr, cluster_values, cl, top_n = 200L)
      enrich <- .anno_markergene_best_enrichment(cl_markers, marker_sets, rownames(expr))
      enrich_label <- if (is.finite(enrich$score) && enrich$score > 0) as.character(enrich$label) else "ambiguous"
      final_label <- if (!identical(module_label, "ambiguous")) {
        module_label
      } else if (!identical(enrich_label, "ambiguous")) {
        enrich_label
      } else {
        "ambiguous"
      }
      conf <- if (!identical(module_label, "ambiguous")) {
        max(0, as.numeric(margin))
      } else {
        as.numeric(enrich$score / (enrich$score + 1))
      }
      agree <- !identical(module_label, "ambiguous") && !identical(enrich_label, "ambiguous") && identical(module_label, enrich_label)
      data.frame(
        cluster = cl,
        module_label = as.character(module_label),
        enrich_label = as.character(enrich_label),
        final_label = as.character(final_label),
        confidence = as.numeric(conf),
        module_margin = as.numeric(margin),
        enrich_score = as.numeric(enrich$score %||% 0),
        enrich_overlap = as.integer(enrich$overlap %||% 0L),
        agreement = isTRUE(agree),
        stringsAsFactors = FALSE
      )
    })
    cluster_map <- do.call(rbind, cl_rows)
    out <- data.frame(
      cell = common_cells,
      cluster = as.character(cluster_values),
      stringsAsFactors = FALSE
    )
    out <- merge(out, cluster_map, by = "cluster", all.x = TRUE, sort = FALSE)
    out$raw_label <- paste0("module=", out$module_label, "; enrichment=", out$enrich_label)
    out$status <- ifelse(is.na(out$final_label) | !nzchar(out$final_label) | out$final_label == "ambiguous", "unresolved", "matched")
    out$tool <- "markerGene"
    out <- .analysis_select_cols_fill(out, c("cell", "final_label", "raw_label", "confidence", "tool", "status"))
    cov <- if (nrow(out)) mean(out$status == "matched", na.rm = TRUE) else 0
    mean_conf <- if (any(out$status == "matched")) mean(suppressWarnings(as.numeric(out$confidence[out$status == "matched"])), na.rm = TRUE) else 0
    amb_frac <- if (nrow(cluster_map)) mean(cluster_map$final_label == "ambiguous", na.rm = TRUE) else 1
    agree_rate <- if (nrow(cluster_map)) mean(cluster_map$agreement, na.rm = TRUE) else 0
    list(
      table = out,
      cluster_map = cluster_map,
      metrics = list(
        coverage = as.numeric(cov),
        mean_confidence = as.numeric(ifelse(is.finite(mean_conf), mean_conf, 0)),
        ambiguous_cluster_fraction = as.numeric(ifelse(is.finite(amb_frac), amb_frac, 1)),
        agreement_rate = as.numeric(ifelse(is.finite(agree_rate), agree_rate, 0))
      )
    )
  }

  output$anno_markergene_cluster_cols_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data)
    if (is.null(sobj)) return(NULL)
    cols <- .anno_cluster_columns(sobj)
    if (!length(cols)) return(helpText(ANALYSIS_UI_TEXT$t_text_annotation_no_cluster_columns))
    sel <- as.character(input$anno_markergene_cluster_cols %||% character(0))
    sel <- sel[nzchar(sel) & sel %in% cols]
    if (!length(sel)) {
      from_umap <- .scalar_chr(input$umap_colorby_rescol, "")
      sel <- if (nzchar(from_umap) && from_umap %in% cols) from_umap else cols[[1]]
    }
    tagList(
      selectizeInput(
        "anno_markergene_cluster_cols",
        ANALYSIS_UI_TEXT$t_label_annotation_markergene_cluster_column,
        choices = cols,
        selected = sel,
        multiple = TRUE,
        options = list(plugins = list("remove_button"), placeholder = "Select one or more resolution columns")
      ),
      p(
        class = "text-muted",
        style = "margin-top:-6px; margin-bottom:8px; font-size:12px;",
        ANALYSIS_UI_TEXT$t_text_annotation_markergene_cluster_hint
      )
    )
  })
  output$anno_markergene_validation_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data)
    prep <- .anno_markergene_prepare(sobj)
    diag <- prep$diagnostics %||% list()
    issues <- as.character(diag$issues %||% character(0))
    style_warning <- as.character(diag$style_warning %||% "")
    tagList(
      tags$h5(ANALYSIS_UI_TEXT$t_title_annotation_markergene_validation, style = "margin-top:8px; margin-bottom:4px;"),
      tags$div(
        class = "text-muted",
        style = "font-size:12px; margin-bottom:6px;",
        sprintf("Labels: %d | Marker rows: %d | Matched genes: %d", as.integer(diag$n_labels %||% 0L), as.integer(diag$n_pairs %||% 0L), as.integer(diag$n_genes_matched %||% 0L))
      ),
      if (isTRUE(as.integer(diag$duplicate_gene_rows %||% 0L) > 0L)) tags$div(class = "text-warning", style = "font-size:12px;", sprintf("Duplicate gene rows removed: %d", as.integer(diag$duplicate_gene_rows %||% 0L))),
      if (isTRUE(as.integer(diag$genes_shared_by_multiple_labels %||% 0L) > 0L)) tags$div(class = "text-warning", style = "font-size:12px;", sprintf("Genes shared across labels: %d", as.integer(diag$genes_shared_by_multiple_labels %||% 0L))),
      if (nzchar(style_warning)) tags$div(class = "text-warning", style = "font-size:12px;", style_warning),
      if (length(issues)) tags$div(class = "text-danger", style = "font-size:12px;", paste(issues, collapse = " "))
    )
  })

  output$anno_active_layer_ui <- renderUI({
    .ensure_annotation_store()
    nm <- .scalar_chr(shared_data$active_object_name, "")
    if (!nzchar(nm)) return(helpText("No active object."))
    bucket <- shared_data$annotation_layers[[nm]]
    if (is.null(bucket) || !length(bucket)) return(helpText("No annotation layer yet."))
    is_tool <- vapply(bucket, function(x) identical(as.character(x$layer_type %||% ""), "tool"), logical(1))
    bucket <- bucket[is_tool]
    if (!length(bucket)) return(helpText("No annotation layer yet."))
    choices <- names(bucket)
    cur <- .scalar_chr((shared_data$active_annotation_layer %||% list())[[nm]], choices[[1]])
    selectInput("anno_active_layer", "Active annotation layer", choices = choices, selected = cur)
  })
  output$anno_singler_resolution_switcher_ui <- renderUI({
    .ensure_annotation_store()
    nm <- .scalar_chr(shared_data$active_object_name, "")
    if (!nzchar(nm)) return(NULL)
    bucket <- shared_data$annotation_layers[[nm]]
    choices <- annotation_singler_resolution_choices(bucket)
    if (!length(choices)) return(NULL)
    cur <- .scalar_chr((shared_data$active_annotation_layer %||% list())[[nm]], "")
    selected <- if (nzchar(cur) && cur %in% unname(choices)) cur else unname(choices)[[1]]
    selectInput(
      "anno_singler_resolution_switcher",
      "SingleR resolution view",
      choices = choices,
      selected = selected
    )
  })
  observeEvent(input$anno_singler_resolution_switcher, {
    nm <- .scalar_chr(shared_data$active_object_name, "")
    lyr <- .scalar_chr(input$anno_singler_resolution_switcher, "")
    if (nzchar(nm) && nzchar(lyr)) .set_active_annotation_layer(nm, lyr, update_inputs = TRUE)
  }, ignoreInit = TRUE)
  output$anno_markergene_resolution_switcher_ui <- renderUI({
    .ensure_annotation_store()
    nm <- .scalar_chr(shared_data$active_object_name, "")
    if (!nzchar(nm)) return(NULL)
    bucket <- shared_data$annotation_layers[[nm]]
    choices <- annotation_markergene_resolution_choices(bucket)
    if (!length(choices)) return(NULL)
    cur <- .scalar_chr((shared_data$active_annotation_layer %||% list())[[nm]], "")
    selected <- if (nzchar(cur) && cur %in% unname(choices)) cur else unname(choices)[[1]]
    selectInput(
      "anno_markergene_resolution_switcher",
      ANALYSIS_UI_TEXT$t_title_annotation_markergene_resolution_view,
      choices = choices,
      selected = selected
    )
  })
  observeEvent(input$anno_markergene_resolution_switcher, {
    nm <- .scalar_chr(shared_data$active_object_name, "")
    lyr <- .scalar_chr(input$anno_markergene_resolution_switcher, "")
    if (nzchar(nm) && nzchar(lyr)) .set_active_annotation_layer(nm, lyr, update_inputs = TRUE)
  }, ignoreInit = TRUE)
  observeEvent(input$anno_active_layer, {
    nm <- .scalar_chr(shared_data$active_object_name, "")
    lyr <- .scalar_chr(input$anno_active_layer, "")
    if (nzchar(nm) && nzchar(lyr)) .set_active_annotation_layer(nm, lyr, update_inputs = TRUE)
  }, ignoreInit = TRUE)

  observeEvent(input$anno_tool, {
    cur <- trimws(as.character(input$anno_layer_name %||% ""))
    defaults <- c("tool_annotation", "singleR_annotation", "celltypist_annotation", "markerGene_annotation")
    if (!nzchar(cur) || cur %in% defaults) {
      updateTextInput(
        session,
        "anno_layer_name",
        value = annotation_default_layer_base(as.character(input$anno_tool %||% "singleR"), cur)
      )
    }
  }, ignoreInit = FALSE)

  output$anno_singler_cluster_cols_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data)
    if (is.null(sobj)) return(NULL)
    cols <- .anno_cluster_columns(sobj)
    if (!length(cols)) return(helpText(ANALYSIS_UI_TEXT$t_text_annotation_no_cluster_columns))
    sel <- as.character(input$anno_singler_cluster_cols %||% character(0))
    sel <- sel[nzchar(sel) & sel %in% cols]
    if (!length(sel)) {
      from_umap <- .scalar_chr(input$umap_colorby_rescol, "")
      sel <- if (nzchar(from_umap) && from_umap %in% cols) from_umap else cols[[1]]
    }
    tagList(
      selectizeInput(
        "anno_singler_cluster_cols",
        ANALYSIS_UI_TEXT$t_label_annotation_cluster_column,
        choices = cols,
        selected = sel,
        multiple = TRUE,
        options = list(plugins = list("remove_button"), placeholder = "Select one or more resolution columns")
      ),
      p(
        class = "text-muted",
        style = "margin-top:-6px; margin-bottom:8px; font-size:12px;",
        "Select one or more cluster or resolution columns. SingleR will save one annotation layer per selection."
      )
    )
  })

  .anno_builtin_ref_choices <- function() {
    c(
      "HumanPrimaryCellAtlasData" = "HumanPrimaryCellAtlasData",
      "MonacoImmuneData" = "MonacoImmuneData",
      "ImmGenData" = "ImmGenData",
      "MouseRNAseqData" = "MouseRNAseqData"
    )
  }
  .anno_init_custom_ref_store <- function() {
    if (is.null(shared_data$custom_singler_refs) || !is.list(shared_data$custom_singler_refs)) {
      shared_data$custom_singler_refs <- list()
    }
  }
  .anno_custom_ref_choices <- function() {
    .anno_init_custom_ref_store()
    refs <- shared_data$custom_singler_refs %||% list()
    if (!length(refs)) return(character(0))
    vals <- paste0("custom::", names(refs))
    nms <- vapply(refs, function(x) {
      nm <- as.character(x$display_name %||% "")
      if (!nzchar(nm)) nm <- as.character(x$id %||% "custom_ref")
      paste0("Custom: ", nm)
    }, character(1))
    stats::setNames(vals, nms)
  }
  .anno_is_custom_ref_value <- function(ref_value) {
    startsWith(as.character(ref_value %||% ""), "custom::")
  }
  .anno_get_selected_custom_ref <- function(ref_value = NULL) {
    .anno_init_custom_ref_store()
    ref_value <- as.character(ref_value %||% input$anno_singler_ref %||% "")
    if (!.anno_is_custom_ref_value(ref_value)) return(NULL)
    id <- sub("^custom::", "", ref_value)
    shared_data$custom_singler_refs[[id]] %||% NULL
  }
  .anno_refresh_singler_ref_choices <- function(selected = NULL) {
    builtins <- .anno_builtin_ref_choices()
    customs <- .anno_custom_ref_choices()
    choices <- c(builtins, customs)
    if (!length(choices)) choices <- builtins
    selected <- as.character(selected %||% input$anno_singler_ref %||% names(builtins)[[1]])
    if (!(selected %in% unname(choices))) selected <- unname(choices)[[1]]
    freezeReactiveValue(input, "anno_singler_ref")
    updateSelectInput(session, "anno_singler_ref", choices = choices, selected = selected)
  }
  .anno_refresh_singler_label_choices <- function(ref_value = NULL) {
    ref_value <- as.character(ref_value %||% input$anno_singler_ref %||% "HumanPrimaryCellAtlasData")
    custom <- .anno_get_selected_custom_ref(ref_value)
    choices <- if (!is.null(custom) && length(custom$label_columns)) {
      as.character(custom$label_columns)
    } else {
      c("label.main", "label.fine")
    }
    choices <- unique(as.character(choices %||% character(0)))
    choices <- choices[nzchar(choices)]
    if (!length(choices)) choices <- c("label.main", "label.fine")
    selected <- as.character(input$anno_singler_label_level %||% choices[[1]])
    if (!(selected %in% choices)) selected <- choices[[1]]
    freezeReactiveValue(input, "anno_singler_label_level")
    updateSelectInput(session, "anno_singler_label_level", choices = choices, selected = selected)
  }
  .anno_parse_label_cols_input <- function(x) {
    x <- as.character(x %||% "")
    if (!nzchar(x)) return(character(0))
    vals <- trimws(unlist(strsplit(x, ",", fixed = TRUE), use.names = FALSE))
    unique(vals[nzchar(vals)])
  }
  .anno_parse_restrict_labels <- function(x) {
    x <- as.character(x %||% "")
    if (!nzchar(x)) return(NULL)
    vals <- trimws(unlist(strsplit(x, ",", fixed = TRUE), use.names = FALSE))
    vals <- unique(vals[nzchar(vals)])
    if (!length(vals)) return(NULL)
    vals
  }
  .anno_collect_singler_advanced_params <- function() {
    quant <- suppressWarnings(as.numeric(input$anno_singler_quantile %||% 0.8))
    if (!is.finite(quant)) quant <- 0.8
    quant <- max(0.05, min(1, quant))
    de_n <- suppressWarnings(as.integer(input$anno_singler_de_n %||% 10L))
    if (!is.finite(de_n) || de_n < 1L) de_n <- 10L
    sd_thresh <- suppressWarnings(as.numeric(input$anno_singler_sd_thresh %||% 1))
    if (!is.finite(sd_thresh) || sd_thresh < 0) sd_thresh <- 1
    num_threads <- suppressWarnings(as.integer(input$anno_singler_num_threads %||% 1L))
    if (!is.finite(num_threads) || num_threads < 1L) num_threads <- 1L
    list(
      de_method = as.character(input$anno_singler_de_method %||% "classic"),
      de_n = de_n,
      sd_thresh = sd_thresh,
      quantile = quant,
      aggr_ref = isTRUE(input$anno_singler_aggr_ref),
      restrict = .anno_parse_restrict_labels(input$anno_singler_restrict_labels),
      check_missing_ref = isTRUE(input$anno_singler_check_missing_ref),
      num_threads = num_threads
    )
  }
  .anno_read_custom_meta_file <- function(fi) {
    if (is.null(fi) || is.null(fi$datapath) || !nzchar(fi$datapath) || !file.exists(fi$datapath)) return(NULL)
    ext <- tolower(tools::file_ext(fi$name %||% ""))
    if (ext %in% c("csv")) {
      return(utils::read.csv(fi$datapath, stringsAsFactors = FALSE, check.names = FALSE))
    }
    utils::read.delim(fi$datapath, stringsAsFactors = FALSE, check.names = FALSE)
  }
  .anno_ref_display_name <- function(ref_value = NULL) {
    ref_value <- as.character(ref_value %||% input$anno_singler_ref %||% "")
    custom <- .anno_get_selected_custom_ref(ref_value)
    if (!is.null(custom)) return(as.character(custom$display_name %||% custom$id %||% "custom_reference"))
    ref_value
  }

  output$anno_singler_ref_note_ui <- renderUI({
    ref <- as.character(input$anno_singler_ref %||% "HumanPrimaryCellAtlasData")
    custom <- .anno_get_selected_custom_ref(ref)
    if (!is.null(custom)) {
      diag <- custom$diagnostics %||% list()
      return(tags$div(
        class = "text-muted",
        style = "margin-top:-6px; margin-bottom:8px; font-size:12px;",
        tags$strong(ANALYSIS_UI_TEXT$t_text_annotation_ref_note_prefix),
        tags$span(" "),
        tags$span(.anno_ref_display_name(ref)),
        tags$br(),
        tags$strong("Genes:"),
        tags$span(" "),
        tags$span(as.character(diag$n_genes %||% NA)),
        tags$span(" | "),
        tags$strong("Samples:"),
        tags$span(" "),
        tags$span(as.character(diag$n_samples %||% NA)),
        tags$span(" | "),
        tags$strong("Labels:"),
        tags$span(" "),
        tags$span(paste(as.character(custom$label_columns %||% character(0)), collapse = ", "))
      ))
    }

    note <- switch(
      ref,
      "HumanPrimaryCellAtlasData" = ANALYSIS_UI_TEXT$t_text_annotation_ref_hpc,
      "MonacoImmuneData" = ANALYSIS_UI_TEXT$t_text_annotation_ref_monaco,
      "ImmGenData" = ANALYSIS_UI_TEXT$t_text_annotation_ref_immgen,
      "MouseRNAseqData" = ANALYSIS_UI_TEXT$t_text_annotation_ref_mouserna,
      ANALYSIS_UI_TEXT$t_text_annotation_ref_hpc
    )
    ref_name <- sub("\\s*-\\s*Pros:.*$", "", note, perl = TRUE)
    pros <- sub("^.*?Pros:\\s*", "", note, perl = TRUE)
    pros <- sub("\\s*Cons:.*$", "", pros, perl = TRUE)
    cons <- sub("^.*?Cons:\\s*", "", note, perl = TRUE)
    if (identical(ref_name, note)) ref_name <- ref
    if (identical(pros, note)) pros <- ""
    if (identical(cons, note)) cons <- ""
    tags$div(
      class = "text-muted",
      style = "margin-top:-6px; margin-bottom:8px; font-size:12px;",
      tags$strong(ANALYSIS_UI_TEXT$t_text_annotation_ref_note_prefix),
      tags$span(" "),
      tags$span(ref_name),
      tags$br(),
      tags$strong("Pros:"),
      tags$span(" "),
      tags$span(pros),
      tags$br(),
      tags$strong("Cons:"),
      tags$span(" "),
      tags$span(cons)
    )
  })

  output$anno_singler_custom_ref_status_ui <- renderUI({
    .anno_init_custom_ref_store()
    refs <- shared_data$custom_singler_refs %||% list()
    ref_txt <- if (length(refs)) {
      paste(vapply(refs, function(x) as.character(x$display_name %||% x$id %||% "custom_reference"), character(1)), collapse = ", ")
    } else {
      ANALYSIS_UI_TEXT$t_text_annotation_custom_ref_none
    }
    active_txt <- .anno_ref_display_name()
    tags$div(
      class = "text-muted",
      style = "margin-top:6px; margin-bottom:8px; font-size:12px;",
      tags$strong(ANALYSIS_UI_TEXT$t_text_annotation_custom_ref_loaded_prefix),
      tags$span(" "),
      tags$span(ref_txt),
      tags$br(),
      tags$strong(ANALYSIS_UI_TEXT$t_text_annotation_custom_ref_ready_prefix),
      tags$span(" "),
      tags$span(active_txt %||% ANALYSIS_UI_TEXT$t_text_annotation_custom_ref_default_note)
    )
  })

  observeEvent(input$anno_tool, {
    if (!identical(as.character(input$anno_tool %||% ""), "singleR")) return(invisible(NULL))
    .anno_refresh_singler_ref_choices()
    .anno_refresh_singler_label_choices()
  }, ignoreInit = FALSE)

  observeEvent(input$anno_singler_ref, {
    .anno_refresh_singler_label_choices(input$anno_singler_ref)
  }, ignoreInit = TRUE)

  observeEvent(input$anno_singler_custom_ref_btn, {
    showModal(modalDialog(
      title = ANALYSIS_UI_TEXT$t_title_annotation_import_custom_ref,
      easyClose = TRUE,
      size = "l",
      tags$p(class = "text-muted", ANALYSIS_UI_TEXT$t_text_annotation_import_custom_ref_help),
      tags$p(class = "text-muted", style = "margin-top:-8px;", ANALYSIS_UI_TEXT$t_text_annotation_import_custom_ref_format_note),
      textInput("anno_custom_ref_name", ANALYSIS_UI_TEXT$t_label_annotation_custom_ref_name, value = ""),
      fileInput("anno_custom_ref_file", ANALYSIS_UI_TEXT$t_label_annotation_custom_ref_file, accept = c(".rds")),
      fileInput("anno_custom_ref_meta_file", ANALYSIS_UI_TEXT$t_label_annotation_custom_ref_meta_file, accept = c(".csv", ".tsv", ".txt")),
      textInput("anno_custom_ref_label_cols", ANALYSIS_UI_TEXT$t_label_annotation_custom_ref_label_cols, value = "label.main,label.fine"),
      footer = tagList(
        modalButton("Cancel"),
        actionButton("anno_custom_ref_load_btn", ANALYSIS_UI_TEXT$t_btn_annotation_custom_ref_load, class = "btn btn-primary")
      )
    ))
  }, ignoreInit = TRUE)

  observeEvent(input$anno_custom_ref_load_btn, {
    fi <- input$anno_custom_ref_file
    req(!is.null(fi), file.exists(fi$datapath))
    overlay_show("Loading custom SingleR reference...")
    on.exit(overlay_hide(), add = TRUE)
    tryCatch({
      .anno_init_custom_ref_store()
      ref_obj <- readRDS(fi$datapath)
      md <- .anno_read_custom_meta_file(input$anno_custom_ref_meta_file)
      requested_cols <- .anno_parse_label_cols_input(input$anno_custom_ref_label_cols)
      built <- build_custom_singler_ref(
        ref_data = ref_obj,
        metadata = md,
        label_columns = requested_cols
      )
      display_name <- .scalar_chr(input$anno_custom_ref_name, "")
      if (!nzchar(display_name)) {
        display_name <- gsub("\\.rds$", "", basename(fi$name %||% "custom_reference"), ignore.case = TRUE)
      }
      if (!nzchar(display_name)) display_name <- "custom_reference"
      id <- tolower(gsub("[^A-Za-z0-9_]+", "_", display_name))
      id <- gsub("^_+|_+$", "", id)
      if (!nzchar(id)) id <- "custom_ref"
      refs <- shared_data$custom_singler_refs %||% list()
      base_id <- id
      i <- 1L
      while (!is.null(refs[[id]])) {
        i <- i + 1L
        id <- paste0(base_id, "_", i)
      }
      refs[[id]] <- list(
        id = id,
        display_name = display_name,
        ref = built$ref,
        metadata = built$metadata,
        label_columns = built$label_columns,
        primary_label = built$primary_label,
        diagnostics = built$diagnostics,
        imported_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")
      )
      shared_data$custom_singler_refs <- refs
      selected <- paste0("custom::", id)
      .anno_refresh_singler_ref_choices(selected = selected)
      .anno_refresh_singler_label_choices(ref_value = selected)
      removeModal()
      singler_trace(
        "Custom reference imported: id=", id,
        ", display_name=", display_name,
        ", genes=", built$diagnostics$n_genes,
        ", samples=", built$diagnostics$n_samples,
        ", labels=", paste(built$label_columns, collapse = ", ")
      )
      showNotification(
        sprintf("Custom reference '%s' loaded (%d genes, %d samples).", display_name, built$diagnostics$n_genes, built$diagnostics$n_samples),
        type = "message"
      )
    }, error = function(e) {
      showNotification(paste("Custom reference import error:", conditionMessage(e)), type = "error", duration = NULL)
    })
  }, ignoreInit = TRUE)

  observeEvent(input$anno_cellmarker_open_btn, {
    species <- as.character(input$anno_cellmarker_species %||% "human")
    tissue <- utils::URLencode(as.character(input$anno_cellmarker_tissue %||% ""), reserved = TRUE)
    celltype <- utils::URLencode(as.character(input$anno_cellmarker_celltype %||% ""), reserved = TRUE)
    url <- sprintf("http://xteam.xbio.top/CellMarker/search.jsp?species=%s&tissue=%s&cellType=%s", species, tissue, celltype)
    shinyjs::runjs(sprintf("window.open(%s, '_blank');", jsonlite::toJSON(url, auto_unbox = TRUE)))
  }, ignoreInit = TRUE)

  observeEvent(input$anno_immgen_open_btn, {
    species <- as.character(input$anno_cellmarker_species %||% "human")
    tissue <- as.character(input$anno_cellmarker_tissue %||% "")
    celltype <- as.character(input$anno_cellmarker_celltype %||% "")
    immgen_q <- as.character(input$anno_immgen_query %||% "")
    query <- trimws(paste(immgen_q, tissue, celltype, species, sep = " "))
    if (!nzchar(query)) query <- "ImmGen"
    q_enc <- utils::URLencode(query, reserved = TRUE)
    url <- sprintf("https://www.google.com/search?q=site%%3Aimmgen.org+%s", q_enc)
    shinyjs::runjs(sprintf("window.open(%s, '_blank');", jsonlite::toJSON(url, auto_unbox = TRUE)))
  }, ignoreInit = TRUE)

  observeEvent(input$anno_cellmarker_import_btn, {
    fi <- input$anno_cellmarker_file
    req(!is.null(fi), file.exists(fi$datapath))
    tryCatch({
      ext <- tolower(tools::file_ext(fi$name %||% ""))
      df <- if (ext %in% c("csv")) {
        utils::read.csv(fi$datapath, stringsAsFactors = FALSE, check.names = FALSE)
      } else {
        utils::read.delim(fi$datapath, stringsAsFactors = FALSE, check.names = FALSE)
      }
      if (!is.data.frame(df) || !nrow(df)) stop("CellMarker table is empty.")
      cellmarker_tbl(df)
      showNotification(sprintf("CellMarker table imported: %d rows.", nrow(df)), type = "message")
    }, error = function(e) {
      showNotification(paste("CellMarker import error:", conditionMessage(e)), type = "error", duration = NULL)
    })
  }, ignoreInit = TRUE)

  output$anno_cellmarker_table <- DT::renderDataTable({
    df <- cellmarker_tbl()
    if (!is.data.frame(df) || !nrow(df)) {
      return(DT::datatable(data.frame(note = ANALYSIS_UI_TEXT$t_text_cellmarker_no_table), rownames = FALSE, options = list(dom = "t")))
    }
    DT::datatable(df, rownames = FALSE, options = list(pageLength = 8, scrollX = TRUE))
  }, server = FALSE)

  output$anno_conf_card_controls_ui <- renderUI({
    mode <- .scalar_chr(input$anno_conf_view_mode, "confidence")
    ctrl <- list(
      tags$div(
        class = "anno-conf-header-row",
        tags$h4(class = "anno-conf-header-title", "UMAP by:"),
        selectInput(
          "anno_conf_view_mode",
          label = NULL,
          choices = c("Confidence" = "confidence", "RGB confocal (3 genes)" = "rgb"),
          selected = mode,
          width = "250px"
        )
      )
    )
    if (identical(mode, "rgb")) {
      ctrl <- c(ctrl, list(
        fluidRow(
          column(
            4,
            wl_gene_selectize_input(
              "anno_conf_gene_r",
              "R",
              placeholder = "Type to search gene"
            )
          ),
          column(
            4,
            wl_gene_selectize_input(
              "anno_conf_gene_g",
              "G",
              placeholder = "Type to search gene"
            )
          ),
          column(
            4,
            wl_gene_selectize_input(
              "anno_conf_gene_b",
              "B",
              placeholder = "Type to search gene"
            )
          )
        )
      ))
    }
    do.call(tagList, ctrl)
  })

  output$anno_umap_pair_ui <- renderUI({
    layout_mode <- .scalar_chr(input$anno_umap_card_layout, "split")
    split_mode <- identical(layout_mode, "split")
    left_w <- if (split_mode) 6 else 12
    right_w <- if (split_mode) 6 else 12
    fluidRow(
      column(
        left_w,
        div(
          class = "wl-side",
          h4("UMAP by final label"),
          uiOutput("anno_umap_label_plot_ui")
        )
      ),
      column(
        right_w,
        div(
          class = "wl-side",
          uiOutput("anno_conf_card_controls_ui"),
          uiOutput("anno_umap_conf_plot_ui")
        )
      )
    )
  })

  observeEvent(
    list(shared_data$active_object_name, input$anno_conf_view_mode),
    {
      if (!identical(.scalar_chr(input$plot_tabs, default = ""), "annotation tools")) return(invisible(NULL))
      if (!identical(.scalar_chr(input$anno_conf_view_mode, "confidence"), "rgb")) return(invisible(NULL))
      sobj <- .get_active_sobj(shared_data)
      if (is.null(sobj)) return(invisible(NULL))
      assay_use <- .analysis_active_assay_name(sobj, fallback = "RNA")
      if (!(assay_use %in% Seurat::Assays(sobj))) return(invisible(NULL))
      genes <- .analysis_get_assay_features(sobj, assay = assay_use)
      genes <- as.character(genes %||% character(0))
      if (!length(genes)) return(invisible(NULL))

      pick_gene <- function(cur, fallback_idx) {
        cur <- .scalar_chr(cur, "")
        if (nzchar(cur) && cur %in% genes) return(cur)
        genes[[min(fallback_idx, length(genes))]]
      }
      r0 <- pick_gene(input$anno_conf_gene_r, 1L)
      g0 <- pick_gene(input$anno_conf_gene_g, 2L)
      b0 <- pick_gene(input$anno_conf_gene_b, 3L)
      if (identical(g0, r0) && length(genes) > 1L) g0 <- genes[[2L]]
      if (identical(b0, r0) && length(genes) > 2L) b0 <- genes[[3L]]
      if (identical(b0, g0) && length(genes) > 3L) b0 <- genes[[4L]]

      freezeReactiveValue(input, "anno_conf_gene_r")
      freezeReactiveValue(input, "anno_conf_gene_g")
      freezeReactiveValue(input, "anno_conf_gene_b")
      wl_update_gene_selectize(session, "anno_conf_gene_r", genes, selected = r0)
      wl_update_gene_selectize(session, "anno_conf_gene_g", genes, selected = g0)
      wl_update_gene_selectize(session, "anno_conf_gene_b", genes, selected = b0)
    },
    ignoreInit = FALSE
  )

  observeEvent(input$anno_run_singler_btn, {
    overlay_show("Running SingleR...")
    on.exit(overlay_hide(), add = TRUE)
    sobj <- .get_active_sobj(shared_data); req(sobj)
    nm <- .scalar_chr(shared_data$active_object_name, ""); req(nzchar(nm))
    .with_anno_libpaths({
      ref_value <- as.character(input$anno_singler_ref %||% "HumanPrimaryCellAtlasData")
      is_custom_ref <- .anno_is_custom_ref_value(ref_value)
      req_pkgs <- if (isTRUE(is_custom_ref)) c("SingleR") else c("SingleR", "celldex")
      chk <- .anno_check_pkgs(req_pkgs)
      if (!isTRUE(chk$found)) {
        showNotification(
          paste0(
            paste(req_pkgs, collapse = "/"), " is not available in current environment. Checked: ",
            paste(as.character(chk$libs %||% character(0)), collapse = " | ")
          ),
          type = "error",
          duration = NULL,
          id = "anno_singler_pkg_check"
        )
        return(invisible(NULL))
      }
      if (!isTRUE(chk$load_ok)) {
        showNotification(
          paste0(paste(req_pkgs, collapse = "/"), " found but failed to load from ", chk$lib, ". Error: ", chk$error),
          type = "error",
          duration = NULL,
          id = "anno_singler_pkg_check"
        )
        return(invisible(NULL))
      }
      .libPaths(unique(c(chk$lib, .libPaths())))
      if (!("RNA" %in% Seurat::Assays(sobj))) {
        showNotification("SingleR expects an RNA assay with expression values.", type = "error")
        return(invisible(NULL))
      }
      ref_name <- ref_value
      custom_ref <- .anno_get_selected_custom_ref(ref_value)
      reference_display_name <- if (!is.null(custom_ref)) as.character(custom_ref$display_name %||% custom_ref$id %||% ref_value) else ref_value
      label_level <- as.character(input$anno_singler_label_level %||% "label.main")
      adv <- .anno_collect_singler_advanced_params()
      layer_name <- annotation_default_layer_base("singleR", .scalar_chr(input$anno_layer_name, "singleR_annotation"))
      use_cluster <- isTRUE(input$anno_singler_cluster_mode)
      singler_trace(
        "Run requested: object=", nm,
        ", reference=", reference_display_name,
        ", reference_type=", if (isTRUE(is_custom_ref)) "custom" else "builtin",
        ", label_level=", label_level,
        ", de_method=", adv$de_method,
        ", de_n=", adv$de_n,
        ", sd_thresh=", adv$sd_thresh,
        ", quantile=", adv$quantile,
        ", aggr_ref=", adv$aggr_ref,
        ", restrict_n=", length(adv$restrict %||% character(0)),
        ", check_missing_ref=", adv$check_missing_ref,
        ", num_threads=", adv$num_threads,
        ", cluster_mode=", use_cluster,
        ", layer=", layer_name
      )

      showNotification("Running SingleR...", type = "message")
      tryCatch({
        if (isTRUE(is_custom_ref)) {
          if (is.null(custom_ref) || is.null(custom_ref$ref) || is.null(custom_ref$metadata)) {
            stop("Selected custom reference is unavailable. Re-import and try again.")
          }
          ref <- custom_ref$ref
          labels_src <- as.data.frame(custom_ref$metadata, stringsAsFactors = FALSE)
          if (!(label_level %in% colnames(labels_src))) {
            stop(
              sprintf(
                "Label column '%s' not found in custom reference metadata. Available: %s",
                label_level,
                paste(colnames(labels_src), collapse = ", ")
              )
            )
          }
          singler_trace("Using custom reference: ", reference_display_name)
        } else {
          ref_fun <- get(ref_name, envir = asNamespace("celldex"))
          singler_trace("Fetching celldex reference: ", ref_name)
          ref <- ref_fun()
          labels_src <- as.data.frame(SummarizedExperiment::colData(ref), stringsAsFactors = FALSE)
        }
        test_mat <- .analysis_get_assay_data(sobj, assay = "RNA", layer = "data")
        singler_validate_test_matrix(test_mat)
        singler_trace(
          "Reference fetched: class=", paste(class(ref), collapse = "/"),
          ", genes=", nrow(ref),
          ", samples=", ncol(ref)
        )
        labels_ref <- singler_normalize_labels(labels_src[[label_level]])
        overlap_details <- singler_collect_overlap_details(
          test_mat = test_mat,
          ref = ref,
          ref_name = reference_display_name,
          min_common_genes = 100L
        )
        singler_trace(
          "Reference/object compatibility summary: common_genes=", overlap_details$common_genes,
          ", min_required=", overlap_details$min_common_genes,
          ", ok=", isTRUE(overlap_details$ok)
        )

        if (use_cluster) {
          cluster_cols <- .anno_cluster_columns(sobj)
          requested_cols <- as.character(input$anno_singler_cluster_cols %||% character(0))
          run_cols <- unique(requested_cols[nzchar(requested_cols) & requested_cols %in% cluster_cols])
          if (!length(run_cols) && length(cluster_cols)) run_cols <- cluster_cols[[1]]
          if (!length(run_cols)) stop("Cluster mode requires at least one available cluster metadata column.")
          missing_cols <- setdiff(run_cols, colnames(sobj@meta.data))
          if (length(missing_cols)) {
            stop(sprintf("Cluster mode requires valid metadata columns. Missing: %s", paste(missing_cols, collapse = ", ")))
          }

          singler_trace(
            "Cluster mode start: cluster_columns=", paste(run_cols, collapse = ", "),
            ", runs=", length(run_cols)
          )
          md <- sobj@meta.data
          saved_layers <- character(0)

          for (cl_col in run_cols) {
            cluster_values <- as.character(md[[cl_col]])
            singler_trace(
              "Cluster run start: cluster_column=", cl_col,
              ", cluster_count=", length(unique(cluster_values))
            )
            pred <- SingleR::SingleR(
              test = test_mat,
              ref = ref,
              labels = labels_ref,
              clusters = cluster_values,
              fine.tune = isTRUE(input$anno_singler_finetune),
              prune = isTRUE(input$anno_singler_prune),
              de.method = adv$de_method,
              de.n = adv$de_n,
              sd.thresh = adv$sd_thresh,
              quantile = adv$quantile,
              aggr.ref = adv$aggr_ref,
              restrict = adv$restrict,
              check.missing = adv$check_missing_ref,
              num.threads = adv$num_threads
            )
            pred_df <- as.data.frame(pred)
            cl_map <- data.frame(cluster = rownames(pred_df), stringsAsFactors = FALSE)
            cl_map$final_label <- as.character(pred_df$pruned.labels %||% pred_df$labels %||% "")
            cl_map$raw_label <- as.character(pred_df$labels %||% "")
            cl_map$confidence <- as.numeric(pred_df$delta.next %||% NA_real_)
            out <- data.frame(cell = rownames(md), cluster = cluster_values, stringsAsFactors = FALSE)
            out <- merge(out, cl_map, by = "cluster", all.x = TRUE, sort = FALSE)
            out$tool <- "SingleR"
            out$status <- ifelse(is.na(out$final_label) | !nzchar(out$final_label), "unresolved", "matched")
            out$confidence <- as.numeric(out$confidence)
            out <- .analysis_select_cols_fill(out, c("cell", "final_label", "raw_label", "confidence", "tool", "status"))

            layer_name_one <- if (length(run_cols) > 1L) annotation_singler_layer_name(layer_name, cl_col) else layer_name
            singler_trace(
              "Cluster run complete: cluster_column=", cl_col,
              ", prediction_rows=", nrow(pred_df),
              ", mapped_cells=", nrow(out),
              ", saving_layer=", layer_name_one
            )
            .store_tool_layer(
              object_name = nm,
              layer_name = layer_name_one,
              tool_name = "SingleR",
              result_df = out,
              params = list(
                reference = reference_display_name,
                reference_value = ref_name,
                reference_type = if (isTRUE(is_custom_ref)) "custom" else "builtin",
                label_level = label_level,
                prune = isTRUE(input$anno_singler_prune),
                fine_tune = isTRUE(input$anno_singler_finetune),
                de_method = adv$de_method,
                de_n = adv$de_n,
                sd_thresh = adv$sd_thresh,
                quantile = adv$quantile,
                aggr_ref = adv$aggr_ref,
                restrict = adv$restrict %||% character(0),
                check_missing_ref = adv$check_missing_ref,
                num_threads = adv$num_threads,
                cluster_mode = isTRUE(use_cluster),
                cluster_column = cl_col,
                resolution_value = annotation_parse_res_value(cl_col),
                run_mode = if (length(run_cols) > 1L) "multi_resolution" else "single_resolution"
              )
            )
            saved_layers <- c(saved_layers, layer_name_one)
          }
          if (length(saved_layers)) .set_active_annotation_layer(nm, saved_layers[[1]], update_inputs = TRUE)
          singler_trace("Cluster mode complete: saved_layers=", paste(saved_layers, collapse = ", "))
        } else {
          singler_trace("Per-cell mode start: official SingleR::SingleR call")
          pred <- SingleR::SingleR(
            test = test_mat,
            ref = ref,
            labels = labels_ref,
            fine.tune = isTRUE(input$anno_singler_finetune),
            prune = isTRUE(input$anno_singler_prune),
            de.method = adv$de_method,
            de.n = adv$de_n,
            sd.thresh = adv$sd_thresh,
            quantile = adv$quantile,
            aggr.ref = adv$aggr_ref,
            restrict = adv$restrict,
            check.missing = adv$check_missing_ref,
            num.threads = adv$num_threads
          )
          pred_df <- as.data.frame(pred)
          out <- data.frame(
            cell = rownames(pred_df),
            final_label = as.character(pred_df$pruned.labels %||% pred_df$labels %||% ""),
            raw_label = as.character(pred_df$labels %||% ""),
            confidence = as.numeric(pred_df$delta.next %||% NA_real_),
            stringsAsFactors = FALSE
          )
          singler_trace(
            "Per-cell mode complete: prediction_rows=", nrow(pred_df),
            ", matched=", sum(nzchar(out$final_label), na.rm = TRUE)
          )
        }
        if (!isTRUE(use_cluster)) {
          out$tool <- "SingleR"
          out$status <- ifelse(is.na(out$final_label) | !nzchar(out$final_label), "unresolved", "matched")
          out$confidence <- as.numeric(out$confidence)
          out <- .analysis_select_cols_fill(out, c("cell", "final_label", "raw_label", "confidence", "tool", "status"))
          singler_trace(
            "Saving layer: rows=", nrow(out),
            ", matched=", sum(out$status == "matched", na.rm = TRUE),
            ", unresolved=", sum(out$status != "matched", na.rm = TRUE)
          )
          .store_tool_layer(
            object_name = nm,
            layer_name = layer_name,
            tool_name = "SingleR",
            result_df = out,
            params = list(
              reference = reference_display_name,
              reference_value = ref_name,
              reference_type = if (isTRUE(is_custom_ref)) "custom" else "builtin",
              label_level = label_level,
              prune = isTRUE(input$anno_singler_prune),
              fine_tune = isTRUE(input$anno_singler_finetune),
              de_method = adv$de_method,
              de_n = adv$de_n,
              sd_thresh = adv$sd_thresh,
              quantile = adv$quantile,
              aggr_ref = adv$aggr_ref,
              restrict = adv$restrict %||% character(0),
              check_missing_ref = adv$check_missing_ref,
              num_threads = adv$num_threads,
              cluster_mode = use_cluster,
              cluster_column = ""
            )
          )
          singler_trace("Run complete: layer saved as ", layer_name)
          showNotification(sprintf("SingleR completed. Layer '%s' saved.", layer_name), type = "message")
        } else {
          showNotification(
            sprintf("SingleR completed. Saved %d layer%s.", length(run_cols), if (length(run_cols) == 1L) "" else "s"),
            type = "message"
          )
        }
      }, error = function(e) {
        singler_trace("Run failed: ", conditionMessage(e))
        showNotification(paste("SingleR error:", conditionMessage(e)), type = "error", duration = NULL)
      })
    })
  }, ignoreInit = TRUE)

  observeEvent(input$anno_run_markergene_btn, {
    overlay_show("Running MarkerGene annotation...")
    on.exit(overlay_hide(), add = TRUE)
    sobj <- .get_active_sobj(shared_data); req(sobj)
    nm <- .scalar_chr(shared_data$active_object_name, ""); req(nzchar(nm))
    if (!("RNA" %in% Seurat::Assays(sobj))) {
      showNotification("MarkerGene requires an RNA assay with expression values.", type = "error")
      return(invisible(NULL))
    }
    prep <- .anno_markergene_prepare(sobj)
    marker_sets <- prep$marker_sets %||% list()
    if (!length(marker_sets)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_annotation_markergene_no_markers, type = "error", duration = NULL)
      return(invisible(NULL))
    }
    cluster_cols <- .anno_cluster_columns(sobj)
    requested_cols <- as.character(input$anno_markergene_cluster_cols %||% character(0))
    run_cols <- unique(requested_cols[nzchar(requested_cols) & requested_cols %in% cluster_cols])
    if (!length(run_cols) && length(cluster_cols)) run_cols <- cluster_cols[[1]]
    if (!length(run_cols)) {
      showNotification("MarkerGene requires at least one valid cluster/resolution column.", type = "error", duration = NULL)
      return(invisible(NULL))
    }
    margin_thresh <- suppressWarnings(as.numeric(input$anno_markergene_margin %||% 0.02))
    if (!is.finite(margin_thresh) || margin_thresh < 0) margin_thresh <- 0.02
    base_layer <- annotation_default_layer_base("markerGene", .scalar_chr(input$anno_layer_name, "markerGene_annotation"))

    .anno_init_markergene_ranking_store()
    ranking_rows <- list()
    saved_layers <- character(0)
    tryCatch({
      for (cl_col in run_cols) {
        singler_trace("MarkerGene run start: object=", nm, ", cluster_column=", cl_col, ", labels=", length(marker_sets))
        res <- .anno_markergene_score_resolution(
          sobj = sobj,
          cluster_col = cl_col,
          marker_sets = marker_sets,
          margin_thresh = margin_thresh
        )
        layer_name_one <- if (length(run_cols) > 1L) annotation_markergene_layer_name(base_layer, cl_col) else base_layer
        .store_tool_layer(
          object_name = nm,
          layer_name = layer_name_one,
          tool_name = "markerGene",
          result_df = res$table,
          params = list(
            scoring_method = "module+fisher",
            margin_threshold = margin_thresh,
            marker_labels = names(marker_sets),
            marker_label_count = length(marker_sets),
            min_genes = as.integer(prep$diagnostics$min_genes %||% NA_integer_),
            max_genes = as.integer(prep$diagnostics$max_genes %||% NA_integer_),
            cluster_mode = TRUE,
            cluster_column = cl_col,
            resolution_value = annotation_parse_res_value(cl_col),
            run_mode = if (length(run_cols) > 1L) "multi_resolution" else "single_resolution"
          )
        )
        saved_layers <- c(saved_layers, layer_name_one)
        ranking_rows[[length(ranking_rows) + 1L]] <- data.frame(
          layer_name = layer_name_one,
          cluster_column = cl_col,
          resolution_value = annotation_parse_res_value(cl_col),
          coverage = as.numeric(res$metrics$coverage %||% 0),
          mean_confidence = as.numeric(res$metrics$mean_confidence %||% 0),
          ambiguous_cluster_fraction = as.numeric(res$metrics$ambiguous_cluster_fraction %||% 1),
          agreement_rate = as.numeric(res$metrics$agreement_rate %||% 0),
          stringsAsFactors = FALSE
        )
      }
      rank_df <- do.call(rbind, ranking_rows)
      if (!is.data.frame(rank_df) || !nrow(rank_df)) stop("MarkerGene produced no ranking rows.")
      max_conf <- suppressWarnings(max(as.numeric(rank_df$mean_confidence), na.rm = TRUE))
      if (!is.finite(max_conf) || max_conf <= 0) max_conf <- 1
      rank_df$confidence_norm <- pmax(0, pmin(1, as.numeric(rank_df$mean_confidence) / max_conf))
      rank_df$composite_score <- (0.55 * as.numeric(rank_df$coverage)) +
        (0.35 * as.numeric(rank_df$confidence_norm)) +
        (0.10 * as.numeric(rank_df$agreement_rate)) -
        (0.20 * as.numeric(rank_df$ambiguous_cluster_fraction))
      rank_df$composite_score <- pmax(0, pmin(1, rank_df$composite_score))
      ord <- order(rank_df$composite_score, rank_df$coverage, rank_df$agreement_rate, decreasing = TRUE)
      rank_df <- rank_df[ord, , drop = FALSE]
      rank_df$rank <- seq_len(nrow(rank_df))
      rank_df <- rank_df[, c("rank", "layer_name", "cluster_column", "resolution_value", "coverage", "mean_confidence", "ambiguous_cluster_fraction", "agreement_rate", "composite_score"), drop = FALSE]
      best_layer <- as.character(rank_df$layer_name[[1]] %||% "")
      shared_data$annotation_marker_rankings[[nm]] <- list(
        table = rank_df,
        best_layer = best_layer,
        created_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"),
        marker_label_count = length(marker_sets)
      )
      .touch_annotation_store()
      if (nzchar(best_layer)) .set_active_annotation_layer(nm, best_layer, update_inputs = TRUE)
      singler_trace(
        "MarkerGene run complete: object=", nm,
        ", layers=", paste(saved_layers, collapse = ", "),
        ", best_layer=", best_layer
      )
      showNotification(
        sprintf("MarkerGene completed. Saved %d layer%s; best resolution set active.", length(saved_layers), if (length(saved_layers) == 1L) "" else "s"),
        type = "message"
      )
    }, error = function(e) {
      singler_trace("MarkerGene run failed: ", conditionMessage(e))
      showNotification(paste("MarkerGene error:", conditionMessage(e)), type = "error", duration = NULL)
    })
  }, ignoreInit = TRUE)

  output$anno_markergene_ranking_table <- DT::renderDataTable({
    .anno_init_markergene_ranking_store()
    nm <- .scalar_chr(shared_data$active_object_name, "")
    if (!nzchar(nm)) {
      return(DT::datatable(data.frame(note = "No active object."), rownames = FALSE, options = list(dom = "t")))
    }
    rk <- shared_data$annotation_marker_rankings[[nm]] %||% list()
    tbl <- as.data.frame(rk$table %||% data.frame(), stringsAsFactors = FALSE)
    if (!nrow(tbl)) {
      return(DT::datatable(data.frame(note = ANALYSIS_UI_TEXT$t_text_annotation_markergene_no_ranking), rownames = FALSE, options = list(dom = "t")))
    }
    num_cols <- intersect(c("resolution_value", "coverage", "mean_confidence", "ambiguous_cluster_fraction", "agreement_rate", "composite_score"), colnames(tbl))
    for (cn in num_cols) tbl[[cn]] <- suppressWarnings(as.numeric(tbl[[cn]]))
    DT::datatable(
      tbl,
      rownames = FALSE,
      options = list(scrollX = TRUE, pageLength = 6),
      selection = "single"
    )
  }, server = FALSE)

  observeEvent(input$anno_markergene_apply_best_btn, {
    .anno_init_markergene_ranking_store()
    nm <- .scalar_chr(shared_data$active_object_name, "")
    req(nzchar(nm))
    rk <- shared_data$annotation_marker_rankings[[nm]] %||% list()
    best_layer <- .scalar_chr(rk$best_layer, "")
    if (!nzchar(best_layer)) {
      showNotification(ANALYSIS_UI_TEXT$t_text_annotation_markergene_no_ranking, type = "warning")
      return(invisible(NULL))
    }
    ok <- .set_active_annotation_layer(nm, best_layer, update_inputs = TRUE)
    if (!isTRUE(ok)) {
      showNotification("Best MarkerGene layer is unavailable.", type = "error")
      return(invisible(NULL))
    }
    showNotification(sprintf("Active layer switched to best MarkerGene result: %s", best_layer), type = "message")
  }, ignoreInit = TRUE)

  observeEvent(input$anno_import_celltypist_btn, {
    overlay_show("Importing CellTypist results...")
    on.exit(overlay_hide(), add = TRUE)
    sobj <- .get_active_sobj(shared_data); req(sobj)
    nm <- .scalar_chr(shared_data$active_object_name, ""); req(nzchar(nm))
    fi <- input$anno_celltypist_file
    req(!is.null(fi), file.exists(fi$datapath))
    layer_name <- annotation_default_layer_base("celltypist", .scalar_chr(input$anno_layer_name, "celltypist_annotation"))

    tryCatch({
      ext <- tolower(tools::file_ext(fi$name %||% ""))
      df <- if (ext %in% c("csv")) {
        utils::read.csv(fi$datapath, stringsAsFactors = FALSE, check.names = FALSE)
      } else {
        utils::read.delim(fi$datapath, stringsAsFactors = FALSE, check.names = FALSE)
      }
      if (!is.data.frame(df) || !nrow(df)) stop("CellTypist file is empty.")

      nms <- colnames(df)
      pick_col <- function(cands) {
        idx <- match(tolower(cands), tolower(nms))
        idx <- idx[is.finite(idx) & idx > 0]
        if (!length(idx)) return("")
        nms[idx[[1]]]
      }
      cell_col <- pick_col(c("cell", "barcode", "cell_id", "barcodes"))
      raw_col <- pick_col(c("predicted_labels", "predicted_label", "best_match", "label"))
      mv_col <- pick_col(c("majority_voting", "majority_vote"))
      conf_col <- pick_col(c("conf_score", "probability", "max_probability", "score"))
      if (!nzchar(cell_col) || (!nzchar(raw_col) && !nzchar(mv_col))) {
        stop("Required columns are missing. Need barcode/cell and at least one label column.")
      }

      md_cells <- rownames(sobj@meta.data)
      md_raw <- .extract_raw_barcode(md_cells)
      raw_map <- split(md_cells, md_raw)

      in_cells <- as.character(df[[cell_col]])
      in_raw <- .extract_raw_barcode(in_cells)
      in_raw[!nzchar(in_raw)] <- in_cells[!nzchar(in_raw)]
      matched <- vapply(in_raw, function(bc) {
        cands <- as.character(raw_map[[bc]] %||% character(0))
        if (!length(cands)) return(NA_character_)
        cands[[1]]
      }, character(1))

      final_lbl <- if (isTRUE(input$anno_celltypist_majority) && nzchar(mv_col)) as.character(df[[mv_col]]) else if (nzchar(raw_col)) as.character(df[[raw_col]]) else as.character(df[[mv_col]])
      raw_lbl <- if (nzchar(raw_col)) as.character(df[[raw_col]]) else as.character(final_lbl)
      conf_v <- if (nzchar(conf_col)) suppressWarnings(as.numeric(df[[conf_col]])) else rep(NA_real_, nrow(df))
      status <- ifelse(is.na(matched), "unresolved", "matched")

      out <- data.frame(
        cell = matched,
        final_label = final_lbl,
        raw_label = raw_lbl,
        confidence = conf_v,
        tool = "CellTypist",
        status = status,
        stringsAsFactors = FALSE
      )
      out <- out[!is.na(out$cell) & nzchar(out$cell), , drop = FALSE]
      if (!nrow(out)) stop("No rows could be matched to current object barcodes.")
      .store_tool_layer(
        object_name = nm,
        layer_name = layer_name,
        tool_name = "CellTypist",
        result_df = out,
        params = list(model = as.character(input$anno_celltypist_model %||% ""), mode = as.character(input$anno_celltypist_mode %||% ""), p_thres = as.numeric(input$anno_celltypist_p_thres %||% NA_real_), majority = isTRUE(input$anno_celltypist_majority))
      )
      showNotification(sprintf("Imported CellTypist layer '%s' (%d rows matched).", layer_name, nrow(out)), type = "message")
    }, error = function(e) {
      showNotification(paste("CellTypist import error:", conditionMessage(e)), type = "error", duration = NULL)
    })
  }, ignoreInit = TRUE)

  observeEvent(input$anno_apply_active_layer_btn, {
    nm <- .scalar_chr(shared_data$active_object_name, "")
    lyr <- .scalar_chr(input$anno_active_layer, "")
    req(nzchar(nm), nzchar(lyr))
    tryCatch({
      .apply_tool_layer_to_metadata(nm, lyr)
      showNotification(sprintf("Applied annotation layer '%s' into metadata.", lyr), type = "message")
    }, error = function(e) {
      showNotification(paste("Apply layer error:", conditionMessage(e)), type = "error", duration = NULL)
    })
  }, ignoreInit = TRUE)

  output$anno_results_table <- DT::renderDataTable({
    tbl <- .get_active_layer_table()
    if (is.null(tbl) || !nrow(tbl)) {
      return(DT::datatable(data.frame(note = "No annotation results yet."), rownames = FALSE, options = list(dom = "t")))
    }
    DT::datatable(tbl, rownames = FALSE, options = list(scrollX = TRUE, pageLength = 12))
  }, server = FALSE)

  output$anno_umap_label_plot_ui <- renderUI({
    w <- suppressWarnings(as.numeric(session$clientData$output_anno_umap_label_plot_ui_width %||% NA_real_))
    if (!is.finite(w) || w <= 0) w <- 720
    tbl <- .get_active_layer_table()
    if (!is.data.frame(tbl) || nrow(tbl) < 1L) {
      return(plot_card_not_ready_ui(
        note = ANALYSIS_UI_TEXT$t_text_annotation_run_first_note,
        height_px = 520L
      ))
    }
    n_labels <- 1L
    if (is.data.frame(tbl) && nrow(tbl) && ("final_label" %in% colnames(tbl))) {
      labs <- as.character(tbl$final_label %||% character(0))
      labs[is.na(labs) | !nzchar(labs)] <- "Unassigned"
      n_labels <- max(1L, length(unique(labs)))
    }
    legend_cols_fixed <- min(3L, n_labels)
    legend_rows <- max(1L, ceiling(n_labels / max(1L, legend_cols_fixed)))
    base_scatter_h <- as.integer(round(w * 0.68))
    legend_h <- as.integer(28 + legend_rows * 28)
    h <- as.integer(max(620L, min(980L, base_scatter_h + legend_h + 8L)))
    div(
      style = "padding-left:26px; padding-right:26px;",
      plotOutput("anno_umap_label_plot", width = "100%", height = paste0(h, "px"))
    )
  })

  output$anno_umap_conf_plot_ui <- renderUI({
    tbl <- .get_active_layer_table()
    if (!is.data.frame(tbl) || nrow(tbl) < 1L) {
      return(plot_card_not_ready_ui(
        note = ANALYSIS_UI_TEXT$t_text_annotation_run_first_note,
        height_px = 520L
      ))
    }
    div(class = "square-plot", plotOutput("anno_umap_conf_plot", width = "100%", height = "100%"))
  })

  output$anno_umap_label_plot <- renderPlot({
    sobj <- .get_active_sobj(shared_data); req(sobj)
    tbl <- .get_active_layer_table(); req(!is.null(tbl), nrow(tbl))
    validate(need(
      .analysis_table_has_required_cols(tbl, c("cell", "final_label")),
      "Selected annotation layer is missing required columns for label preview."
    ))
    red <- if ("umap" %in% names(sobj@reductions)) "umap" else names(sobj@reductions)[1]
    req(!is.null(red), nzchar(red))
    emb <- as.data.frame(Seurat::Embeddings(sobj, reduction = red))
    colnames(emb)[1:2] <- c("dim1", "dim2")
    emb$cell <- rownames(emb)
    d <- merge(emb, .analysis_select_cols_fill(tbl, c("cell", "final_label")), by = "cell", all.x = TRUE, sort = FALSE)
    d$final_label[is.na(d$final_label) | !nzchar(d$final_label)] <- "Unassigned"
    pal <- .anno_label_color_map(d$final_label)
    d$final_label <- factor(as.character(d$final_label), levels = names(pal))
    w <- suppressWarnings(as.numeric(session$clientData$output_anno_umap_label_plot_width %||% session$clientData$output_anno_umap_label_plot_ui_width %||% NA_real_))
    if (!is.finite(w) || w <= 0) w <- 720
    n_labels <- length(names(pal))
    legend_cols <- min(3L, n_labels)
    legend_rows <- max(1L, ceiling(n_labels / max(1L, legend_cols)))
    lg_dot <- .umap_legend_dot_size(0.45, 10)
    ggplot2::ggplot(d, ggplot2::aes(dim1, dim2, color = final_label)) +
      ggplot2::geom_point(size = 0.45, alpha = 0.9) +
      ggplot2::scale_color_manual(values = pal, drop = FALSE) +
      ggplot2::coord_fixed() +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        legend.position = "bottom",
        legend.direction = "horizontal",
        legend.box = "vertical",
        legend.title.position = "top",
        legend.title = ggplot2::element_text(face = "bold", hjust = 0.5),
        legend.text = ggplot2::element_text(size = 10),
        legend.box.margin = ggplot2::margin(0, 22, 0, 22),
        legend.margin = ggplot2::margin(0, 18, 0, 18),
        plot.margin = ggplot2::margin(2, 18, 2, 18)
      ) +
      ggplot2::guides(
        colour = ggplot2::guide_legend(
          ncol = legend_cols,
          nrow = legend_rows,
          byrow = TRUE,
          title.position = "top",
          title.hjust = 0.5,
          override.aes = list(size = lg_dot, alpha = 1)
        ),
        color = ggplot2::guide_legend(
          ncol = legend_cols,
          nrow = legend_rows,
          byrow = TRUE,
          title.position = "top",
          title.hjust = 0.5,
          override.aes = list(size = lg_dot, alpha = 1)
        )
      ) +
      ggplot2::labs(x = paste0(red, "_1"), y = paste0(red, "_2"), color = "final_label")
  })

  output$anno_umap_conf_plot <- renderPlot({
    tab_now <- .scalar_chr(input$plot_tabs, default = "")
    if (!identical(tab_now, "annotation tools")) return(invisible(NULL))
    sobj <- .get_active_sobj(shared_data); req(sobj)
    tbl <- .get_active_layer_table(); req(!is.null(tbl), nrow(tbl))
    red <- if ("umap" %in% names(sobj@reductions)) "umap" else names(sobj@reductions)[1]
    req(!is.null(red), nzchar(red))
    emb <- as.data.frame(Seurat::Embeddings(sobj, reduction = red))
    colnames(emb)[1:2] <- c("dim1", "dim2")
    emb$cell <- rownames(emb)
    mode <- .scalar_chr(input$anno_conf_view_mode, "confidence")
    if (identical(mode, "rgb")) {
      t_rgb <- .perf_now()
      assay_use <- .analysis_active_assay_name(sobj, fallback = "RNA")
      validate(need(assay_use %in% Seurat::Assays(sobj), "RGB confocal view requires a valid active assay."))
      genes <- .analysis_get_assay_features(sobj, assay = assay_use)
      resolve_gene <- function(cur, fallback_idx) {
        cur <- .scalar_chr(cur, "")
        if (nzchar(cur) && cur %in% genes) return(cur)
        genes[[min(fallback_idx, length(genes))]]
      }
      req(length(genes) >= 1L)
      r_gene <- resolve_gene(input$anno_conf_gene_r, 1L)
      g_gene <- resolve_gene(input$anno_conf_gene_g, 2L)
      b_gene <- resolve_gene(input$anno_conf_gene_b, 3L)
      raw_sel <- c(
        .scalar_chr(input$anno_conf_gene_r, ""),
        .scalar_chr(input$anno_conf_gene_g, ""),
        .scalar_chr(input$anno_conf_gene_b, "")
      )
      missing_sel <- unique(raw_sel[nzchar(raw_sel) & !(raw_sel %in% genes)])
      validate(need(
        !length(missing_sel),
        sprintf(
          "RGB confocal error: gene(s) not found in current assay '%s': %s",
          assay_use,
          paste(missing_sel, collapse = ", ")
        )
      ))
      fetch_gene <- function(gene) {
        if (!nzchar(gene) || !(gene %in% genes)) return(rep(0, nrow(emb)))
        out <- suppressWarnings(.analysis_fetch_feature_values(
          sobj = sobj,
          feature = gene,
          cells = emb$cell,
          assay = assay_use,
          layer = "data"
        ))
        if (!length(out)) out <- rep(0, nrow(emb))
        out[!is.finite(out)] <- 0
        out
      }
      scale01 <- function(x) {
        x <- suppressWarnings(as.numeric(x))
        x[!is.finite(x)] <- 0
        if (!length(x)) return(numeric(0))
        if (!any(x > 0, na.rm = TRUE)) return(rep(0, length(x)))
        nz <- x[x > 0 & is.finite(x)]
        hi <- if (length(nz) >= 16L) {
          suppressWarnings(as.numeric(stats::quantile(nz, 0.99, na.rm = TRUE)))
        } else {
          suppressWarnings(max(nz, na.rm = TRUE))
        }
        if (!is.finite(hi) || hi <= 0) hi <- suppressWarnings(max(x, na.rm = TRUE))
        if (!is.finite(hi) || hi <= 0) return(rep(0, length(x)))
        y <- x / hi
        pmax(0, pmin(1, y))
      }
      rv <- scale01(fetch_gene(r_gene))
      gv <- scale01(fetch_gene(g_gene))
      bv <- scale01(fetch_gene(b_gene))
      d <- emb
      d$rgb_col <- grDevices::rgb(rv, gv, bv)
      .perf_log("anno_conf_rgb:render_done", t0 = t_rgb, details = c(
        sprintf("cells=%d", nrow(emb)),
        sprintf("assay=%s", assay_use),
        sprintf("genes=%s/%s/%s", r_gene, g_gene, b_gene)
      ))
      ggplot2::ggplot(d, ggplot2::aes(dim1, dim2, color = rgb_col)) +
        ggplot2::geom_point(size = 0.45, alpha = 0.9) +
        ggplot2::coord_fixed() +
        ggplot2::scale_color_identity() +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::labs(
          x = paste0(red, "_1"),
          y = paste0(red, "_2"),
          subtitle = paste0("RGB: R=", r_gene, " | G=", g_gene, " | B=", b_gene)
        )
    } else {
      validate(need(
        .analysis_table_has_required_cols(tbl, c("cell", "confidence")),
        "Selected annotation layer is missing required columns for confidence preview."
      ))
      d <- merge(emb, .analysis_select_cols_fill(tbl, c("cell", "confidence")), by = "cell", all.x = TRUE, sort = FALSE)
      d$confidence <- suppressWarnings(as.numeric(d$confidence))
      ggplot2::ggplot(d, ggplot2::aes(dim1, dim2, color = confidence)) +
        ggplot2::geom_point(size = 0.45, alpha = 0.9) +
        ggplot2::coord_fixed() +
        ggplot2::scale_color_viridis_c(option = "C", na.value = "#d1d5db") +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(legend.position = "top", legend.direction = "horizontal", legend.box = "horizontal") +
        ggplot2::labs(x = paste0(red, "_1"), y = paste0(red, "_2"), color = "confidence")
    }
  })

  output$anno_composition_plot_ui <- renderUI({
    tbl <- .get_active_layer_table()
    if (!is.data.frame(tbl) || nrow(tbl) < 1L) {
      return(plot_card_not_ready_ui(
        note = ANALYSIS_UI_TEXT$t_text_annotation_run_first_note,
        height_px = 360L
      ))
    }
    w <- suppressWarnings(as.numeric(session$clientData$output_anno_composition_plot_ui_width %||% NA_real_))
    h <- if (is.finite(w) && w > 0) {
      max(340L, min(760L, as.integer(round(w * 0.48))))
    } else {
      420L
    }
    plotlyOutput("anno_composition_plot", width = "100%", height = paste0(h, "px"))
  })

  output$anno_composition_plot <- renderPlotly({
    tbl <- .get_active_layer_table()
    req(!is.null(tbl), nrow(tbl))
    labels <- as.character(tbl$final_label %||% "Unassigned")
    labels[is.na(labels) | !nzchar(labels)] <- "Unassigned"
    pal <- .anno_label_color_map(labels)
    d <- as.data.frame(table(factor(labels, levels = names(pal))), stringsAsFactors = FALSE)
    colnames(d) <- c("label", "n")
    d$label[!nzchar(d$label)] <- "Unassigned"
    d <- d[order(-d$n), , drop = FALSE]
    d$label <- factor(d$label, levels = d$label)
    bar_cols <- unname(pal[as.character(d$label)])
    plotly::plot_ly(
      data = d,
      x = ~label,
      y = ~n,
      type = "bar",
      marker = list(color = bar_cols),
      text = ~paste0("Label: ", label, "<br>Cells: ", scales::comma(n)),
      hoverinfo = "text",
      showlegend = FALSE
    ) %>%
      plotly::layout(
        autosize = TRUE,
        xaxis = list(
          title = "final_label",
          tickangle = -45,
          categoryorder = "array",
          categoryarray = as.character(d$label)
        ),
        yaxis = list(title = "Cells"),
        margin = list(l = 55, r = 20, b = 95, t = 10)
      ) %>%
      plotly::config(displaylogo = FALSE)
  })

  output$anno_agreement_table <- DT::renderDataTable({
    .ensure_annotation_store()
    nm <- .scalar_chr(shared_data$active_object_name, "")
    if (!nzchar(nm)) {
      return(DT::datatable(data.frame(note = "No active object."), rownames = FALSE, options = list(dom = "t")))
    }
    bucket <- shared_data$annotation_layers[[nm]]
    if (is.null(bucket) || !length(bucket)) {
      return(DT::datatable(data.frame(note = "No annotation layers yet."), rownames = FALSE, options = list(dom = "t")))
    }
    layers <- names(bucket)
    sr <- layers[vapply(layers, function(k) identical(bucket[[k]]$tool_name, "SingleR"), logical(1))]
    ct <- layers[vapply(layers, function(k) identical(bucket[[k]]$tool_name, "CellTypist"), logical(1))]
    if (!length(sr) || !length(ct)) {
      return(DT::datatable(data.frame(note = "Agreement panel appears after both SingleR and CellTypist layers exist."), rownames = FALSE, options = list(dom = "t")))
    }
    d1 <- bucket[[sr[[length(sr)]]]]$table
    d2 <- bucket[[ct[[length(ct)]]]]$table
    if (!.analysis_table_has_required_cols(d1, c("cell", "final_label", "confidence")) ||
        !.analysis_table_has_required_cols(d2, c("cell", "final_label", "confidence"))) {
      return(DT::datatable(
        data.frame(note = "Agreement panel requires both layers to include cell, final_label, and confidence columns."),
        rownames = FALSE,
        options = list(dom = "t")
      ))
    }
    m <- merge(
      .analysis_select_cols_fill(d1, c("cell", "final_label", "confidence")),
      .analysis_select_cols_fill(d2, c("cell", "final_label", "confidence")),
      by = "cell", all = FALSE, suffixes = c("_singleR", "_celltypist")
    )
    m$agree <- as.character(m$final_label_singleR) == as.character(m$final_label_celltypist)
    m$review_flag <- ifelse(m$agree, "", "review")
    DT::datatable(m, rownames = FALSE, options = list(scrollX = TRUE, pageLength = 10))
  }, server = FALSE)

  # ---------------- HEATMAP
  
  output$heatmap_res_select_ui <- renderUI({
    sobj <- .get_active_sobj(shared_data); if (is.null(sobj)) return(NULL)
    nm <- shared_data$active_object_name
    cache_res <- tryCatch(shared_data$all_seurat_objects[[nm]]$analysis_cache$cluster_sweep$resolutions, error=function(e) NULL)
    present_cols <- .find_resolution_columns(sobj)
    present_vals <- if (length(present_cols)) sort(unique(vapply(present_cols, .parse_res_value, numeric(1)))) else numeric()
    choices <- unique(sort(c(cache_res %||% numeric(), present_vals)))
    if (!length(choices)) return(helpText(ANALYSIS_UI_TEXT$t_text_no_resolutions_found_run_sweep_first))
    selectInput("heatmap_res_select", ANALYSIS_UI_TEXT$t_label_resolution, choices = choices, selected = tail(choices, 1))
  })
  
  observeEvent(input$run_heatmap_btn2, {
    overlay_show(); on.exit(overlay_hide(), add = TRUE)
    
    sobj <- .get_active_sobj(shared_data); req(sobj, input$heatmap_res_select)
    nm <- shared_data$active_object_name
    res <- as.numeric(input$heatmap_res_select)
    ensured <- .ensure_clusters_at_resolution(
      sobj,
      res,
      graph_name = input$sweep_graph %||% NULL,
      dims = .effective_dims()
    )
    seurat_obj <- ensured$sobj
    shared_data$all_seurat_objects[[nm]]$obj <- seurat_obj
    if (is.null(seurat_obj$seurat_clusters)) showNotification("Heatmap requires finished clustering.", type = "message")
    req(seurat_obj$seurat_clusters)
    updateTabsetPanel(session, inputId = "plot_tabs", selected = "differential expression analysis")
    
    showNotification("Running heatmap…", type = "message", duration = 5)
    original_lib_paths <- .libPaths(); .libPaths(c(shared_data$active_environment$path, original_lib_paths))
    tryCatch({
      heatmap_results <- core_analysis_tab_d_run_heatmap(
        seurat_obj = seurat_obj,
        heatmap_params = list(
          num_genes = as.integer(input$heatmap_topn %||% 5L),
          min_pct = as.numeric(input$heatmap_minpct %||% 0.1),
          logfc_threshold = as.numeric(input$heatmap_logfc %||% 0.25),
          test_use = as.character(input$heatmap_testuse %||% "wilcox")
        )
      )
      shared_data$all_seurat_objects[[nm]]$plots$heatmap <- heatmap_results$avg_expression
      shared_data$all_seurat_objects[[nm]]$plots$heatmap_gene_table <- heatmap_results$heatmap_gene_table
      shared_data$all_seurat_objects[[nm]]$plots$heatmap_plot_path <- heatmap_results$heatmap_plot_path
      static_heatmap_path(shared_data$all_seurat_objects[[nm]]$plots$heatmap_plot_path)
      shinyjs::show("download_heatmap_btn")
      showNotification("Heatmap complete.", type = "message")
    }, error = function(e) {
      showNotification(paste("Heatmap error:", e$message), type="error", duration = NULL)
    }, finally = { .libPaths(original_lib_paths) })
  }, ignoreInit = TRUE)
  
  # -------- Remaining plotly renders
  output$static_heatmap_plot <- renderImage({
    path <- static_heatmap_path(); req(path, file.exists(path))
    list(src = path, contentType = 'image/png', width = "100%", height = "auto")
  }, deleteFile = FALSE)
  output$elbow_plot <- renderPlotly({
    req(shared_data$active_object_name)
    nm <- .scalar_chr(shared_data$active_object_name, default = "")
    plot_obj <- if (nzchar(nm)) tryCatch(shared_data$all_seurat_objects[[nm]]$plots$elbow, error = function(e) NULL) else NULL
    req(plot_obj)
    p <- plot_obj +
      ggplot2::scale_x_continuous(
        breaks = scales::pretty_breaks(n = 10),
        minor_breaks = function(lims) seq(floor(lims[1]), ceiling(lims[2]), by = 1)
      ) +
      ggplot2::theme(
        panel.grid.major = ggplot2::element_line(color = "#d1d5db", linewidth = 0.45),
        panel.grid.minor = ggplot2::element_line(color = "#e5e7eb", linewidth = 0.3)
      )
    suppressWarnings(ggplotly(p) %>% config(displaylogo = FALSE))
  })
  output$final_heatmap_plot <- renderPlotly({
    plot_obj <- shared_data$all_seurat_objects[[shared_data$active_object_name]]$plots$heatmap
    req(plot_obj)
    plot_ly(
      x = colnames(plot_obj), y = rownames(plot_obj), z = as.matrix(plot_obj),
      type = "heatmap", colorscale = Seurat:::PurpleAndYellow()
    ) %>% layout(xaxis = list(title = ANALYSIS_UI_TEXT$t_text_cluster),
                 yaxis = list(title = ANALYSIS_UI_TEXT$t_text_top_marker_genes, tickfont = list(size = 8)))
  })
  output$download_heatmap_btn <- downloadHandler(
    filename = function() { path <- static_heatmap_path(); req(path); basename(path) },
    content  = function(file) { path <- static_heatmap_path(); req(path); file.copy(path, file) }
  )
  shinyjs::onclick("heatmap_zoom_wrapper", {
    path <- static_heatmap_path(); req(path)
    showModal(modalDialog(title = ANALYSIS_UI_TEXT$t_text_zoomed_heatmap,
                          imageOutput("zoomed_static_heatmap", height = "100%"),
                          footer = modalButton("Close"), size = "xl", easyClose = TRUE))
  })
  output$zoomed_static_heatmap <- renderImage({
    path <- static_heatmap_path(); req(path, file.exists(path))
    list(src = path, contentType = 'image/png')
  }, deleteFile = FALSE)
}

cellwhisperer_ui <- fluidPage(
  class = "plotting-page",
  div(
    class = "card-page-wrap",
    div(
      class = "wl-side focus_card_style",
      h3(icon("brain"), " CellWhisperer (Admin)"),
      p("Run text-query cell scoring through an external CellWhisperer-compatible plugin service."),
      p(class = "text-muted", "Environment setup required: establish a separate CellWhisperer Python environment/service first, then paste plugin URL below.")
    ),
    fluidRow(
      column(
        width = 4,
        div(
          class = "wl-side plotting-left-panel",
          textInput("cw_plugin_url", "Plugin URL", value = "http://127.0.0.1:8000", placeholder = "http://127.0.0.1:8000"),
          selectInput("cw_model", "Model", choices = c("cellwhisperer_clip_v1"), selected = "cellwhisperer_clip_v1"),
          textInput("cw_query", "Query", value = "", placeholder = "e.g. CD8 cytotoxic T cells"),
          actionButton("cw_run", "Run query", class = "btn btn-primary"),
          br(), br(),
          selectInput("cw_cached_query_select", "Cached query history", choices = c("(none)" = ""), selected = ""),
          actionButton("cw_load_cached", "Load cached", class = "btn btn-default"),
          br(), br(),
          actionButton("cw_save_score_to_metadata", "Save current score to metadata", class = "btn btn-success"),
          hr(),
          tags$strong("Status"),
          verbatimTextOutput("cw_status", placeholder = TRUE)
        )
      ),
      column(
        width = 8,
        div(
          class = "wl-side plot_area_card_style",
          h4("UMAP overlay (cw_active_score)"),
          plotOutput("cw_umap_plot", height = "560px", width = "100%"),
          hr(),
          h4("Cluster summary"),
          DT::DTOutput("cw_cluster_summary")
        )
      )
    )
  )
)

cellwhisperer_server <- function(input, output, session, shared_data) {
  `%||%` <- get0("%||%", mode = "function", inherits = TRUE, ifnotfound = function(a, b) if (is.null(a)) b else a)

  cw_status <- reactiveVal("idle")
  cw_last_cache_key <- reactiveVal("")

  .get_active_entry <- function() {
    nm <- as.character(shared_data$active_object_name %||% "")
    if (!nzchar(nm)) return(list(name = "", entry = NULL, obj = NULL))
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    list(name = nm, entry = entry, obj = obj)
  }

  .get_cluster_col <- function(obj) {
    if (is.null(obj) || !inherits(obj, "Seurat")) return("")
    md <- tryCatch(obj@meta.data, error = function(e) NULL)
    if (is.null(md) || !is.data.frame(md)) return("")
    if ("seurat_clusters" %in% colnames(md)) return("seurat_clusters")
    cand <- colnames(md)[grepl("cluster|_res\\.|ident", colnames(md), ignore.case = TRUE, perl = TRUE)]
    if (!length(cand)) return("")
    cand[[1]]
  }

  .refresh_cache_choices <- function() {
    ctx <- .get_active_entry()
    obj_name <- ctx$name
    entry <- ctx$entry
    if (!nzchar(obj_name) || is.null(entry) || !is.list(entry)) {
      updateSelectInput(session, "cw_cached_query_select", choices = c("(none)" = ""), selected = "")
      return(invisible(NULL))
    }
    cache <- entry$analysis_cache %||% list()
    keys <- cw_cache_list_keys(cache)
    if (!length(keys)) {
      updateSelectInput(session, "cw_cached_query_select", choices = c("(none)" = ""), selected = "")
      return(invisible(NULL))
    }
    cw_bucket <- cache$cellwhisperer %||% list()
    labels <- vapply(keys, function(k) {
      one <- cw_bucket[[k]] %||% list()
      q <- as.character(one$query %||% "")
      m <- as.character(one$model %||% "")
      ts <- as.character(one$timestamp %||% "")
      paste0(if (nzchar(q)) q else k, if (nzchar(m)) paste0(" [", m, "]") else "", if (nzchar(ts)) paste0(" @ ", ts) else "")
    }, character(1))
    choices <- stats::setNames(keys, labels)
    sel <- as.character(input$cw_cached_query_select %||% "")
    if (!nzchar(sel) || !(sel %in% keys)) sel <- keys[[length(keys)]]
    updateSelectInput(session, "cw_cached_query_select", choices = choices, selected = sel)
  }

  observeEvent(list(shared_data$active_object_name, shared_data$all_seurat_objects), {
    .refresh_cache_choices()
  }, ignoreInit = FALSE)

  output$cw_status <- renderText({
    as.character(cw_status() %||% "idle")
  })

  observeEvent(input$cw_run, {
    ctx <- .get_active_entry()
    nm <- ctx$name
    entry <- ctx$entry
    obj <- ctx$obj

    if (!nzchar(nm) || is.null(obj) || !inherits(obj, "Seurat")) {
      cw_status("error: No active Seurat object available.")
      return(invisible(NULL))
    }

    query <- trimws(as.character(input$cw_query %||% ""))
    if (!nzchar(query)) {
      cw_status("error: Query is required.")
      return(invisible(NULL))
    }

    plugin_url <- as.character(input$cw_plugin_url %||% "")
    model <- as.character(input$cw_model %||% "cellwhisperer_clip_v1")
    token <- as.character(Sys.getenv("CELLWHISPERER_API_TOKEN", ""))

    plugin_url_norm <- tryCatch(cw_normalize_plugin_url(plugin_url), error = function(e) e)
    if (inherits(plugin_url_norm, "error")) {
      cw_status(paste0("error: ", conditionMessage(plugin_url_norm)))
      return(invisible(NULL))
    }

    if (cw_is_nonlocal_http(plugin_url_norm) && !nzchar(token)) {
      cw_status("warning: non-local plugin URL without CELLWHISPERER_API_TOKEN.")
    } else {
      cw_status("running")
    }

    cell_ids <- tryCatch(rownames(obj@meta.data), error = function(e) character(0))
    if (!length(cell_ids)) {
      cw_status("error: Active object has no cells/meta.data rownames.")
      return(invisible(NULL))
    }

    cache_key <- cw_make_cache_key(object_name = nm, query = query, model = model)
    cache <- entry$analysis_cache %||% list()
    cached <- cw_cache_get(cache, cache_key)

    if (is.list(cached) && length(cached$scores %||% list())) {
      aligned <- tryCatch(cw_validate_scores(cached$scores, cell_ids), error = function(e) e)
      if (!inherits(aligned, "error")) {
        obj2 <- tryCatch(cw_attach_scores_to_object(obj, aligned, score_col = "cw_active_score"), error = function(e) e)
        if (!inherits(obj2, "error")) {
          shared_data$all_seurat_objects[[nm]]$obj <- obj2
          cw_status("loaded from cache")
          cw_last_cache_key(cache_key)
          return(invisible(NULL))
        }
      }
    }

    result <- tryCatch({
      cw_call_plugin(
        plugin_url = plugin_url_norm,
        dataset_id = nm,
        query = query,
        cell_ids = cell_ids,
        model = model,
        timeout_sec = 120,
        score_type = "logit",
        token = token,
        prefer_async = TRUE,
        poll_interval_sec = 2,
        max_poll_sec = 180
      )
    }, error = function(e) e)

    if (inherits(result, "error")) {
      cw_status(paste0("error: ", conditionMessage(result)))
      return(invisible(NULL))
    }

    parsed <- tryCatch(cw_parse_scores(result, expected_cell_ids = cell_ids), error = function(e) e)
    if (inherits(parsed, "error")) {
      cw_status(paste0("error: ", conditionMessage(parsed)))
      return(invisible(NULL))
    }

    aligned <- tryCatch(cw_validate_scores(parsed, cell_ids), error = function(e) e)
    if (inherits(aligned, "error")) {
      cw_status(paste0("error: ", conditionMessage(aligned)))
      return(invisible(NULL))
    }

    obj2 <- tryCatch(cw_attach_scores_to_object(obj, aligned, score_col = "cw_active_score"), error = function(e) e)
    if (inherits(obj2, "error")) {
      cw_status(paste0("error: ", conditionMessage(obj2)))
      return(invisible(NULL))
    }

    payload <- list(
      query = query,
      model = model,
      scores = as.list(aligned),
      metadata = result$metadata %||% list(),
      timestamp = as.character(Sys.time()),
      score_col = "cw_active_score",
      dataset_id = nm,
      source = "plugin"
    )

    cache2 <- cw_cache_set(shared_data$all_seurat_objects[[nm]]$analysis_cache %||% list(), cache_key, payload)
    shared_data$all_seurat_objects[[nm]]$obj <- obj2
    shared_data$all_seurat_objects[[nm]]$analysis_cache <- cache2

    cw_last_cache_key(cache_key)
    cw_status("success")
    .refresh_cache_choices()
  }, ignoreInit = TRUE)

  observeEvent(input$cw_load_cached, {
    ctx <- .get_active_entry()
    nm <- ctx$name
    entry <- ctx$entry
    obj <- ctx$obj
    if (!nzchar(nm) || is.null(entry) || is.null(obj) || !inherits(obj, "Seurat")) {
      cw_status("error: No active Seurat object available.")
      return(invisible(NULL))
    }
    key <- as.character(input$cw_cached_query_select %||% "")
    if (!nzchar(key)) {
      cw_status("error: Select a cached query first.")
      return(invisible(NULL))
    }
    one <- cw_cache_get(entry$analysis_cache %||% list(), key)
    if (is.null(one)) {
      cw_status("error: Cached payload not found.")
      return(invisible(NULL))
    }

    cells <- rownames(obj@meta.data)
    sc <- tryCatch(cw_validate_scores(unlist(one$scores %||% list(), use.names = TRUE), cells), error = function(e) e)
    if (inherits(sc, "error")) {
      cw_status(paste0("error: ", conditionMessage(sc)))
      return(invisible(NULL))
    }

    obj2 <- tryCatch(cw_attach_scores_to_object(obj, sc, score_col = "cw_active_score"), error = function(e) e)
    if (inherits(obj2, "error")) {
      cw_status(paste0("error: ", conditionMessage(obj2)))
      return(invisible(NULL))
    }

    shared_data$all_seurat_objects[[nm]]$obj <- obj2
    cw_last_cache_key(key)
    cw_status("loaded from cache")
  }, ignoreInit = TRUE)

  observeEvent(input$cw_save_score_to_metadata, {
    ctx <- .get_active_entry()
    nm <- ctx$name
    obj <- ctx$obj
    if (!nzchar(nm) || is.null(obj) || !inherits(obj, "Seurat")) {
      cw_status("error: No active Seurat object available.")
      return(invisible(NULL))
    }
    md <- tryCatch(obj@meta.data, error = function(e) NULL)
    if (is.null(md) || !("cw_active_score" %in% colnames(md))) {
      cw_status("error: Run a query first; cw_active_score is unavailable.")
      return(invisible(NULL))
    }

    q <- trimws(as.character(input$cw_query %||% ""))
    base_col <- cw_safe_score_col(q, prefix = "cw")
    col_nm <- base_col
    idx <- 2L
    while (col_nm %in% colnames(md)) {
      col_nm <- paste0(base_col, "_", idx)
      idx <- idx + 1L
    }

    md[[col_nm]] <- md$cw_active_score
    obj@meta.data <- md
    shared_data$all_seurat_objects[[nm]]$obj <- obj

    ac <- shared_data$all_seurat_objects[[nm]]$analysis_cache %||% list()
    saved <- ac$cellwhisperer_saved_columns %||% list()
    saved[[as.character(Sys.time())]] <- list(
      query = q,
      score_col = col_nm,
      from_col = "cw_active_score",
      cache_key = as.character(cw_last_cache_key() %||% "")
    )
    ac$cellwhisperer_saved_columns <- saved
    shared_data$all_seurat_objects[[nm]]$analysis_cache <- ac

    cw_status(sprintf("success: saved to metadata column '%s'", col_nm))
  }, ignoreInit = TRUE)

  output$cw_umap_plot <- renderPlot({
    ctx <- .get_active_entry()
    obj <- ctx$obj
    req(!is.null(obj), inherits(obj, "Seurat"))
    md <- obj@meta.data
    validate(need("cw_active_score" %in% colnames(md), "Run a query to create cw_active_score."))

    red_name <- if ("umap" %in% names(obj@reductions)) "umap" else names(obj@reductions)[1]
    validate(need(!is.null(red_name) && nzchar(red_name), "No embedding reduction available."))
    emb <- Seurat::Embeddings(obj, reduction = red_name)
    validate(need(!is.null(emb) && ncol(emb) >= 2, "Embedding preview unavailable."))

    df <- data.frame(
      cell_id = rownames(emb),
      dim1 = as.numeric(emb[, 1]),
      dim2 = as.numeric(emb[, 2]),
      cw_active_score = as.numeric(md[rownames(emb), "cw_active_score", drop = TRUE]),
      stringsAsFactors = FALSE
    )

    ggplot2::ggplot(df, ggplot2::aes(dim1, dim2, color = cw_active_score)) +
      ggplot2::geom_point(size = 0.85, alpha = 0.85) +
      ggplot2::scale_color_gradientn(
        colors = c("#2b8cbe", "#a1dab4", "#fee08b", "#f46d43", "#d7301f"),
        na.value = "#bdbdbd"
      ) +
      ggplot2::coord_fixed() +
      ggplot2::theme_classic(base_size = 12) +
      ggplot2::labs(x = "UMAP_1", y = "UMAP_2", color = "CellWhisperer score", title = "CellWhisperer score overlay")
  }, res = 110)

  output$cw_cluster_summary <- DT::renderDT({
    ctx <- .get_active_entry()
    obj <- ctx$obj
    req(!is.null(obj), inherits(obj, "Seurat"))
    cluster_col <- .get_cluster_col(obj)
    out <- cw_cluster_score_summary(obj, score_col = "cw_active_score", cluster_col = cluster_col)
    if (!is.data.frame(out) || !nrow(out)) {
      out <- data.frame(note = "Run a query to populate summary.", stringsAsFactors = FALSE)
      return(DT::datatable(out, rownames = FALSE, options = list(dom = "t")))
    }
    DT::datatable(out, rownames = FALSE, options = list(pageLength = 8, scrollX = TRUE))
  }, server = FALSE)
}
