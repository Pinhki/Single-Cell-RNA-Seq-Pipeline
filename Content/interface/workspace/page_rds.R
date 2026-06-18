# =======================================================
# R/page_rds.R — RDS Process (UI + Server)
# Safe bounded scanning + selective import + Review & Configure step
# before proceeding to Analysis. Includes navbar tab gating.
# =======================================================

RDS_UI_TEXT <- list(
  ui_badge_cell_cycle = "CellCycle",
  ui_badge_cluster_labels = "Cluster labels",
  ui_badge_dbr = "dbr",
  ui_badge_neighbor_graphs = "Neighbor graphs:",
  ui_badge_qc = "QC",
  ui_badge_reductions = "Reductions:",
  ui_badge_resolutions = "Resolutions:",
  ui_badge_samples = "Samples",
  ui_button_cancel = "Cancel",
  ui_btn_add_workspace = "Add to Workspace",
  ui_btn_discard_imported_preview = "Discard Imported Preview",
  ui_btn_download_all_datasets_rds = "Download All Datasets (.rds)",
  ui_btn_download_selected_object_rds = "Download Selected Object Bundle (.rds)",
  ui_btn_download_structure_tree_txt = "Download Full Structure Tree (.txt)",
  ui_btn_download_selected_object_structure_tree_txt = "Download Selected Object Structure Tree (.txt)",
  ui_btn_copy_usage_code = "Copy Code",
  ui_btn_download_params_session_txt = "Download Analysis Parameters + Session Info (.txt)",
  ui_btn_import_selected = "Import Selected",
  ui_label_object = "Object:",
  ui_label_fast_checkpoint = "Fast checkpoint (no compression, larger file)",
  ui_label_show_diagnostics = "Show diagnostics",
  ui_label_upload_rds = "Upload (.rds):",
  ui_text_active_environment = "Active environment: ",
  ui_text_all_tabs_enabled = "All tabs enabled",
  ui_text_analysis_date = "Analysis date: ",
  ui_text_before_adding_workspace = "Before adding to workspace",
  ui_text_bg_warning_text_dark = "bg-warning text-dark",
  ui_text_captured_package_versions = "Captured package versions: ",
  ui_text_choose_defaults_used_analysis_plotting = "Choose defaults used by analysis/plotting.",
  ui_text_configuration_applied_added_workspace = "Configuration applied. Added to workspace.",
  ui_text_confirm_default_assay_data_slot_plotting = "Confirm default assay, data slot for plotting, and identity column before proceeding.",
  ui_text_db_doublet_columns = "DBR/Doublet columns:",
  ui_text_detected_identity_column = "Detected identity column: ",
  ui_text_detected_sample_column = "Detected sample column: ",
  ui_text_detected_samples = "Detected samples: ",
  ui_text_discarded_imported_preview = "Discarded imported preview.",
  ui_text_diagnostics = "Diagnostics",
  ui_text_error_no_datasets_export = "No datasets are available to export yet. Please import data and/or run the pipeline before downloading.",
  ui_text_error_no_datasets_export_stop = "No datasets available to export.",
  ui_text_error_no_seurat_objects_found = "No Seurat objects were found in this .rds.",
  ui_text_error_no_seurat_objects_import = "No Seurat objects to import.",
  ui_text_error_rds_not_readable = "This file could not be read as RDS.",
  ui_text_examples_columns_named_like_dbr_doublet = "Examples: columns named like 'dbr', 'doublet', 'whitelist', 'blacklist', 'keep', etc.",
  ui_text_export_time = "Export time: %s",
  ui_text_export_time_line = "Export time: %s",
  ui_text_export_current_registered_seurat_objects_into = "Export current registered Seurat objects into one RDS bundle.",
  ui_text_export_single_object_into_rds = "Export one selected object as a wrapped RDS bundle (.rds) that preserves plots and preferences.",
  ui_text_export_wrap_empty = "No Seurat objects available to export yet.",
  ui_text_export_keep_bundle_note = "If you have follow-up requests that cannot be completed inside this pipeline, export your workspace now and keep the .rds file. The exported .rds file plus Session Info can be used for any further analysis in R.",
  ui_text_usage_code_note = "Use this code in RStudio when opening a workspace bundle exported from this page.",
  ui_text_exported = "Exported at: ",
  ui_text_faster_import_better_stability_add_only = "For faster import and better stability, add only the objects you currently need.",
  ui_text_force_enable_gated_tabs = "Force enable gated tabs",
  ui_text_header_analysis_parameters_by_page = "=== Analysis Parameters By Page ===",
  ui_text_header_session_info_current_runtime = "=== Session Info (Current Runtime) ===",
  ui_text_import_saved_workspace_rds_single_seurat = "Import a saved workspace RDS, single Seurat object, or list containing Seurat objects.",
  ui_text_import_wait_notice = "Once the upload progress bar is complete, object checking and unpacking will begin shortly.",
  ui_text_import_time_depends_number_size_selected = "Import time depends on the number and size of selected objects.",
  ui_text_imported_bundle_info = "Imported Bundle Info",
  ui_text_includes_object_wrappers_plots_preferences_current = "Includes object wrappers, plots, and preferences in the current workspace.",
  ui_text_includes_per_page_analysis_parameters_and_session = "Includes per-page analysis parameters (captured at run/apply time) and current R session info.",
  ui_text_key_package_versions = "Key package versions",
  ui_text_label_cluster_label_columns = "Cluster label columns:",
  ui_text_label_objects_selected = "Objects selected: %d",
  ui_text_no_captured_analysis_parameters_found = "No captured analysis parameters found.",
  ui_text_no_gating_reasons_now = "No gating reasons right now.",
  ui_text_no_rds_imported_yet = "<div>No RDS imported yet.</div>",
  ui_text_multiple_seurat_objects_found_select_which = "Multiple Seurat objects found. Select which to import.",
  ui_text_no_pipeline_metadata_found_file_likely = "No pipeline metadata found in this file (likely exported by an older version or imported as plain Seurat object).",
  ui_text_note = "Note: ",
  ui_text_page_section_prefix = "--- Page: %s ---",
  ui_text_pipeline_version = "Pipeline version: %s",
  ui_text_overlay_reading_rds_file = "Reading and inspecting .rds file...",
  ui_text_overlay_preparing_rds_bundle = "Saving RDS snapshot — this may take a while because R serializes the full Seurat workspace in one pass, and large objects make disk write + serialization slower. Waiting is normal and worth it: this checkpoint is your safest protection against losing work.",
  ui_text_fast_checkpoint_help = "Uses compress = FALSE to save faster. File size will be larger than compressed RDS.",
  ui_text_overlay_preparing_rds_structure_report = "Preparing structure tree report for download...",
  ui_text_meta_chip_cells = "Cells: %s",
  ui_text_meta_chip_meta_columns = "Meta columns: %s",
  ui_text_meta_chip_assays = "Assays: %s",
  ui_text_meta_chip_reductions = "Reductions: %s",
  ui_text_meta_chip_default_assay = "Default assay: %s",
  ui_text_meta_chip_seurat = "Seurat: %s",
  ui_text_meta_chip_target_environment = "Target env: %s",
  ui_text_prepare_rds_bundle = "Preparing RDS ...",
  ui_text_prepare_rds_structure_report = "Preparing structure tree report ...",
  ui_text_reading_inspecting_rds = "Reading and inspecting .rds ...",
  ui_text_scanning_for_seurat = "Scanning for Seurat objects ...",
  ui_text_scan_stopped_early_partial = "Scan stopped early (safety limit). Showing partial results.",
  ui_text_usage_code_copied = "Code copied to clipboard.",
  ui_text_usage_code_copy_failed = "Copy failed. Please copy the code manually.",
  ui_text_select_at_least_one = "Select at least one.",
  ui_text_object_metadata_explorer = "Object Metadata Explorer",
  ui_text_package_versions_not_found_bundle = "Package versions not found in bundle.",
  ui_text_pipeline = "Pipeline: -",
  ui_text_target_environment = "Target env: -",
  ui_text_review_configure_imported_objects = "Review & Configure Imported Objects",
  ui_text_save_processed_seurat_objects_later_sessions = "Save your processed Seurat objects for later sessions, or load previously saved ones.",
  ui_text_selective_import = "Selective Import",
  ui_text_seurat = "Seurat: -",
  ui_text_separator_colon_space = ": ",
  ui_text_mismatch_active_env_prefix = "Active environment is ",
  ui_text_mismatch_middle_but_seurat = ", but Seurat ",
  ui_text_mismatch_maps_to = " maps to ",
  ui_text_mismatch_suffix_period = ".",
  ui_text_tip_click_one_more_rows_first = "Tip: Click one or more rows. The first selected row sets the default assay for that object in Analysis/export.",
  ui_text_trigger_id = "trigger_id: %s",
  ui_text_updated_at = "updated_at: %s",
  ui_text_warning_scan_partial_results = "Scan stopped early (safety limit). Showing partial results.",
  ui_text_pipeline_chip_prefix = "Pipeline: ",
  ui_text_seurat_chip_prefix = "Seurat: ",
  ui_text_target_environment_chip_prefix = "Target env: ",
  ui_text_resolutions_label_html = "<b>Resolutions:</b> %s",
  ui_text_reductions_label_html = "<br><b>Reductions:</b> %s",
  ui_text_neighbor_graphs_label_html = "<br><b>Neighbor graphs:</b> %s",
  ui_text_dbr_columns_label_html = "<br><b>DBR/Doublet columns:</b> %s",
  ui_text_cluster_columns_label_html = "<br><b>Cluster label columns:</b> %s",
  ui_text_no_parameters = "(no parameters)",
  ui_text_use_filters_metadata_table_below_quickly = "Use filters in the metadata table below to quickly find QC, clustering, sample, and doublet-related columns.",
  ui_text_why_some_tabs_disabled = "Why are some tabs disabled?",
  ui_title_export_import_seurat_object_rds = "Export/Import Seurat Object (.rds)",
  ui_title_export_object = "Export Object",
  ui_title_export_single_object = "Export Single Object Bundle (.rds)",
  ui_title_usage_code_example = "RStudio Example (Workspace Bundle)",
  ui_title_usage_code_example_single = "RStudio Example (Single Object Bundle)",
  ui_title_usage_code_fold = "Show/Hide RStudio Example Code",
  ui_title_export_analysis_parameters_session_info = "Export Analysis Parameters + Session Info",
  ui_title_import_object = "Import Object",
  ui_title_per_object_configuration = "Per-object Configuration",
  ui_title_summary = "Summary",
  ui_label_default_assay = "Default assay:",
  ui_label_data_slot_for_plotting = "Data slot for plotting:",
  ui_label_identity_column_idents = "Identity column (Idents):",
  ui_label_meta_column_sample_names = "Meta column with sample names:",
  ui_label_meta_column_barcode_keep_drop_flags = "Meta column containing final barcode list / keep/drop flags:",
  ui_title_pipeline_stage_tab_gating = "Pipeline Stage & Tab Gating",
  ui_title_samples = "Samples",
  ui_title_final_barcode_list_optional = "Final barcode list (optional)",
  ui_text_error_file_not_read_as_rds = "This file could not be read as RDS."

)

`%||%` <- function(a, b) if (!is.null(a)) a else b

.safe_import_name <- function(x, fallback = "Imported") {
  nm <- trimws(as.character(x %||% ""))
  if (!length(nm)) return(fallback)
  nm <- nm[[1]]
  if (is.na(nm) || !nzchar(nm)) fallback else nm
}

.safe_select_cols <- function(df, cols, default = NA) {
  if (is.null(df) || !is.data.frame(df)) return(data.frame(stringsAsFactors = FALSE))
  cols <- as.character(cols %||% character(0))
  cols <- cols[!is.na(cols) & nzchar(cols)]
  if (!length(cols)) return(df[, 0, drop = FALSE])
  out <- df
  n <- nrow(out)
  for (cc in cols) {
    if (!(cc %in% colnames(out))) out[[cc]] <- rep(default, n)
  }
  out[, cols, drop = FALSE]
}

RDS_WORKSPACE_EXPORT_USAGE_CODE <- paste(
  "# 1) Read the exported workspace bundle (.rds)",
  "bundle <- readRDS(\"PATH/TO/workspace_bundle.rds\")",
  "",
  "# 2) List all object names in this bundle (one line)",
  "cat(\"Objects in bundle:\", paste(names(bundle$all_seurat_objects), collapse = \", \"), \"\\n\")",
  "",
  "# 3) See available objects in the bundle",
  "names(bundle$all_seurat_objects)",
  "",
  "# 4) Choose one object and unwrap Seurat object",
  "obj_entry <- bundle$all_seurat_objects[[\"YOUR_OBJECT_NAME\"]]",
  "sobj <- obj_entry$obj",
  "",
  "# 5) Quick checks",
  "bundle$active_object_name",
  "dim(sobj)",
  "Seurat::Assays(sobj)",
  "Seurat::DefaultAssay(sobj)",
  "head(sobj@meta.data)",
  sep = "\n"
)

RDS_SINGLE_EXPORT_USAGE_CODE <- paste(
  "# 1) Read the exported single-object bundle (.rds)",
  "bundle <- readRDS(\"PATH/TO/single_object_bundle.rds\")",
  "",
  "# 2) List object names stored in this bundle",
  "cat(\"Objects in bundle:\", paste(names(bundle$all_seurat_objects), collapse = \", \"), \"\\n\")",
  "",
  "# 3) Unwrap the active object directly",
  "obj_name <- bundle$active_object_name",
  "obj_entry <- bundle$all_seurat_objects[[obj_name]]",
  "sobj <- obj_entry$obj",
  "",
  "# 4) Quick checks",
  "obj_name",
  "dim(sobj)",
  "Seurat::Assays(sobj)",
  "Seurat::DefaultAssay(sobj)",
  "head(sobj@meta.data)",
  sep = "\n"
)

# ---- normalize imported objects to wrapper format ----
.normalize_imported_entry <- function(x) {
  if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
    fast <- tryCatch(wanlab_canonicalize_object_entry(x), error = function(e) NULL)
    if (!is.null(fast)) return(fast)
  }
  .first_seurat <- function(obj, depth = 0L, max_depth = 4L) {
    if (inherits(obj, "Seurat")) return(obj)
    if (!is.list(obj) || depth >= max_depth || !length(obj)) return(NULL)
    for (child in obj) {
      found <- .first_seurat(child, depth = depth + 1L, max_depth = max_depth)
      if (!is.null(found)) return(found)
    }
    NULL
  }
  if (is.list(x)) {
    sobj <- NULL
    for (k in c("obj", "seurat", "seurat_obj", "object", "sobj")) {
      if (!is.null(x[[k]]) && inherits(x[[k]], "Seurat")) {
        sobj <- x[[k]]
        break
      }
    }
    if (is.null(sobj)) sobj <- .first_seurat(x)
    if (!is.null(sobj)) {
      x$obj <- sobj
      if (is.null(x$plots)) x$plots <- list()
      if (is.null(x$prefs) || !is.list(x$prefs)) x$prefs <- list()
      if (is.null(x$analysis_cache) || !is.list(x$analysis_cache)) x$analysis_cache <- list()
      return(x)
    }
  }
  if (inherits(x, "Seurat")) {
    return(list(
      obj = x,
      prefs = list(),
      plots = list(),
      analysis_cache = list()
    ))
  }
  NULL
}

.normalize_tabular_imports <- function(df) {
  if (!is.data.frame(df) || !nrow(df)) {
    return(data.frame(name = character(0), path = character(0), type = character(0), stringsAsFactors = FALSE))
  }
  needed <- c("name", "path", "type")
  for (cn in needed) if (!(cn %in% colnames(df))) df[[cn]] <- ""
  out <- df[, needed, drop = FALSE]
  out$name <- as.character(out$name %||% "")
  out$path <- as.character(out$path %||% "")
  out$type <- as.character(out$type %||% "")
  out <- out[nzchar(out$path), , drop = FALSE]
  out <- out[!duplicated(out$path), , drop = FALSE]
  rownames(out) <- NULL
  out
}

.migrate_legacy_vdj_tabular_to_object_links <- function(objs, imported_tabular_files) {
  reg <- objs %||% list()
  tab <- .normalize_tabular_imports(imported_tabular_files %||% data.frame())
  if (!length(reg) || !nrow(tab)) {
    return(list(objs = reg, tabular = tab))
  }

  type_low <- tolower(as.character(tab$type %||% ""))
  name_low <- tolower(as.character(tab$name %||% ""))
  is_vdj <- grepl("^vdj_", toupper(as.character(tab$type %||% ""))) |
    grepl("_(tcr|bcr)_contigs", name_low, perl = TRUE)
  if (!any(is_vdj)) {
    return(list(objs = reg, tabular = tab))
  }

  vdj_rows <- tab[is_vdj, , drop = FALSE]
  keep_tab <- tab[!is_vdj, , drop = FALSE]
  obj_names <- names(reg %||% list())
  if (!length(obj_names)) {
    return(list(objs = reg, tabular = keep_tab))
  }
  obj_names_low <- tolower(as.character(obj_names))

  for (i in seq_len(nrow(vdj_rows))) {
    nm <- as.character(vdj_rows$name[[i]] %||% "")
    p <- as.character(vdj_rows$path[[i]] %||% "")
    if (!nzchar(nm) || !nzchar(p)) next
    chain <- if (grepl("_tcr_", tolower(nm), fixed = TRUE)) "TCR" else if (grepl("_bcr_", tolower(nm), fixed = TRUE)) "BCR" else ""
    if (!nzchar(chain)) {
      tp <- tolower(as.character(vdj_rows$type[[i]] %||% ""))
      if (grepl("tcr", tp, fixed = TRUE)) chain <- "TCR"
      if (grepl("bcr", tp, fixed = TRUE)) chain <- "BCR"
    }
    if (!nzchar(chain)) next

    sample_guess <- sub("_(tcr|bcr)_contigs.*$", "", nm, perl = TRUE, ignore.case = TRUE)
    sample_guess_low <- tolower(sample_guess)
    hit <- which(obj_names_low == sample_guess_low)
    if (!length(hit)) {
      hit <- which(startsWith(obj_names_low, paste0(sample_guess_low, "_")))
    }
    if (!length(hit)) next
    obj_name <- obj_names[[hit[[1]]]]
    entry <- reg[[obj_name]]
    if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
      entry <- tryCatch(wanlab_canonicalize_object_entry(entry), error = function(e) entry)
    }
    if (!is.list(entry)) next
    if (is.null(entry$meta) || !is.list(entry$meta)) entry$meta <- list()
    if (is.null(entry$meta$linked_files) || !is.list(entry$meta$linked_files)) entry$meta$linked_files <- list()
    cur <- entry$meta$linked_files$vdj
    if (is.null(cur) || !is.data.frame(cur)) cur <- data.frame(chain = character(0), source_name = character(0), stringsAsFactors = FALSE)
    if (!("chain" %in% names(cur))) cur$chain <- character(nrow(cur))
    if (!("source_name" %in% names(cur))) {
      if ("path" %in% names(cur)) {
        cur$source_name <- basename(as.character(cur$path %||% ""))
      } else {
        cur$source_name <- character(nrow(cur))
      }
    }
    cur <- cur[, c("chain", "source_name"), drop = FALSE]
    add <- data.frame(chain = chain, source_name = basename(p), stringsAsFactors = FALSE)
    merged <- rbind(cur, add)
    merged <- merged[!duplicated(paste0(merged$chain, "::", merged$source_name)), , drop = FALSE]
    rownames(merged) <- NULL
    entry$meta$linked_files$vdj <- merged
    reg[[obj_name]] <- entry
  }

  if (exists("wanlab_canonicalize_registry", mode = "function", inherits = TRUE)) {
    reg <- tryCatch(wanlab_canonicalize_registry(reg), error = function(e) reg)
  }
  list(objs = reg, tabular = keep_tab)
}

.propagate_vdj_links_across_object_variants <- function(objs) {
  reg <- objs %||% list()
  if (!is.list(reg) || !length(reg)) return(reg)
  .sample_key <- function(x) {
    x <- tolower(as.character(x %||% ""))
    x <- gsub("(_rna)?_filtered$", "", x, perl = TRUE)
    x <- gsub("_filtered$", "", x, perl = TRUE)
    x
  }
  by_key <- list()
  obj_names <- names(reg %||% list())
  for (nm in obj_names) {
    entry <- reg[[nm]]
    if (!is.list(entry)) next
    linked <- tryCatch(entry$meta$linked_files$vdj, error = function(e) NULL)
    if (!is.data.frame(linked) || !nrow(linked)) next
    src_col <- if ("source_name" %in% names(linked)) "source_name" else if ("path" %in% names(linked)) "path" else ""
    if (!nzchar(src_col)) next
    if (!("chain" %in% names(linked))) linked$chain <- rep("Unknown", nrow(linked))
    df <- data.frame(
      chain = as.character(linked$chain %||% "Unknown"),
      source_name = as.character(linked[[src_col]] %||% ""),
      stringsAsFactors = FALSE
    )
    df <- df[!is.na(df$source_name) & nzchar(df$source_name), , drop = FALSE]
    if (!nrow(df)) next
    k <- .sample_key(nm)
    if (!nzchar(k)) next
    prev <- by_key[[k]]
    merged <- if (is.data.frame(prev) && nrow(prev)) rbind(prev, df) else df
    dedup <- paste0(as.character(merged$chain %||% ""), "::", as.character(merged$source_name %||% ""))
    merged <- merged[!duplicated(dedup), , drop = FALSE]
    rownames(merged) <- NULL
    by_key[[k]] <- merged
  }
  if (!length(by_key)) return(reg)
  for (nm in obj_names) {
    entry <- reg[[nm]]
    if (!is.list(entry)) next
    k <- .sample_key(nm)
    bucket <- by_key[[k]]
    if (!is.data.frame(bucket) || !nrow(bucket)) next
    if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
      entry <- tryCatch(wanlab_canonicalize_object_entry(entry), error = function(e) entry)
    }
    if (!is.list(entry)) next
    if (is.null(entry$meta) || !is.list(entry$meta)) entry$meta <- list()
    if (is.null(entry$meta$linked_files) || !is.list(entry$meta$linked_files)) entry$meta$linked_files <- list()
    entry$meta$linked_files$vdj <- bucket
    reg[[nm]] <- entry
  }
  if (exists("wanlab_canonicalize_registry", mode = "function", inherits = TRUE)) {
    reg <- tryCatch(wanlab_canonicalize_registry(reg), error = function(e) reg)
  }
  reg
}

.normalize_annotation_layers_import <- function(x) {
  if (!is.list(x) || !length(x)) return(list())
  out <- x
  obj_names <- names(out)
  if (is.null(obj_names) || !length(obj_names)) return(list())
  keep_obj <- !(is.na(obj_names) | obj_names == "")
  out <- out[keep_obj]
  out <- out[vapply(out, is.list, logical(1))]
  if (!length(out)) return(list())
  lapply(out, function(bucket) {
    if (!is.list(bucket) || !length(bucket)) return(list())
    bucket_names <- names(bucket)
    if (is.null(bucket_names) || !length(bucket_names)) return(list())
    keep_bucket <- !(is.na(bucket_names) | bucket_names == "")
    bucket <- bucket[keep_bucket]
    bucket[vapply(bucket, is.list, logical(1))]
  })
}

.normalize_active_annotation_layer_import <- function(x) {
  if (!is.list(x) || !length(x)) return(list())
  obj_names <- names(x)
  if (is.null(obj_names) || !length(obj_names)) return(list())
  keep_obj <- !(is.na(obj_names) | obj_names == "")
  x <- x[keep_obj]
  out <- lapply(x, function(v) {
    vv <- as.character(v %||% "")
    vv <- vv[!is.na(vv)]
    if (!length(vv)) return("")
    vv[[1]]
  })
  out[vapply(out, nzchar, logical(1))]
}

.normalize_imported_list <- function(lst) {
  if (is.null(lst) || length(lst) == 0) return(list())
  if (exists("wanlab_canonicalize_registry", mode = "function", inherits = TRUE)) {
    reg <- tryCatch(wanlab_canonicalize_registry(lst), error = function(e) NULL)
    if (!is.null(reg) && length(reg)) return(reg)
  }
  out <- lapply(lst, .normalize_imported_entry)
  out <- out[!vapply(out, is.null, logical(1))]
  nms <- names(out)
  if (is.null(nms) || !length(nms)) nms <- rep("", length(out))
  bad <- is.na(nms) | nms == ""
  if (any(bad)) nms[bad] <- paste0("Imported_", seq_len(sum(bad)))
  names(out) <- make.unique(nms)
  out
}

.empty_rds_review_table_df <- function() {
  data.frame(
    object = character(0),
    cell_count = integer(0),
    assay = character(0),
    n_features = integer(0),
    total_counts = numeric(0),
    median_counts_per_cell = numeric(0),
    reductions = character(0),
    stage = character(0),
    samples = character(0),
    meta_cols = integer(0),
    cluster_res = character(0),
    stringsAsFactors = FALSE
  )
}

# Return a tidy overview of meta.data
.meta_overview <- function(sobj) {
  .meta_category <- function(cn, cl) {
    lo <- tolower(cn)
    if (grepl("doublet|dbr|scrublet", lo)) return("doublet")
    if (grepl("cluster|seurat_clusters|ident|celltype|cell_type|_res\\.", lo)) return("clustering")
    if (grepl("ncount_rna|nfeature_rna|percent.mt|pct_mt|mito|percent.mito", lo)) return("qc")
    if (grepl("sample|orig.ident|batch|condition|donor|subject|library", lo)) return("sample")
    if (grepl("s.score|g2m.score|phase|cell.?cycle", lo)) return("cell_cycle")
    if (identical(cl, "numeric") || identical(cl, "integer")) return("numeric")
    "other"
  }
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || ncol(md) == 0) {
    return(data.frame(
      column = character(), category = character(), class = character(),
      n_unique = integer(), na_pct = numeric(),
      example_values = character(), stringsAsFactors = FALSE
    ))
  }
  cols <- colnames(md)
  ov <- lapply(cols, function(cn) {
    v <- md[[cn]]
    cl <- class(v)[1]
    uvals <- unique(v)
    ex <- utils::head(uvals, 3)
    data.frame(
      column = cn,
      category = .meta_category(cn, cl),
      class = cl,
      n_unique = length(uvals),
      na_pct = round(mean(is.na(v)) * 100, 2),
      example_values = paste(utils::head(as.character(ex), 3), collapse = ", "),
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, ov)
}

# Detect interesting signals in meta.data + object
# Detect interesting signals in meta.data + object
.detect_meta_signals <- function(sobj) {
  md_cols <- tryCatch(colnames(sobj@meta.data), error = function(e) character())
  reds    <- tryCatch(names(sobj@reductions),    error = function(e) character())
  graphs  <- tryCatch(names(sobj@graphs),        error = function(e) character())
  
  low <- tolower(md_cols)
  
  dbr_cols     <- md_cols[grepl("\\b(dbr|doublet|doublets|scrublet)\\b", low)]
  cluster_cols <- md_cols[grepl("\\b(seurat_clusters|cluster|celltype|cell_type|ident)\\b", low)]
  
  ## -------- resolution columns: support *_res.* plus older snn_res./leiden_res. ------
  # primary: anything like "something_res.0.4"
  res_cols <- md_cols[grepl("_res\\.[0-9]", low)]
  # fallback for old names if nothing found
  if (!length(res_cols)) {
    res_cols <- md_cols[grepl("(snn_res\\.|leiden_res\\.)[0-9]", low)]
  }
  
  if (length(res_cols)) {
    # try *_res.x pattern first
    res_values <- sub("^.*_res\\.([0-9]+(?:\\.[0-9]+)?)$", "\\1", tolower(res_cols))
    # for any that didn't match, try old snn_res./leiden_res. pattern
    bad <- is.na(res_values) | res_values == res_cols
    if (any(bad)) {
      res_values[bad] <- sub(
        "^.*(?:snn_res\\.|leiden_res\\.)([0-9]+(?:\\.[0-9]+)?)$",
        "\\1",
        tolower(res_cols[bad])
      )
    }
    res_values <- res_values[is.finite(suppressWarnings(as.numeric(res_values))) |
                               nzchar(res_values)]
  } else {
    res_values <- character(0)
  }
  ## -------------------------------------------------------------------
  
  sample_cols <- md_cols[grepl("\\b(orig\\.ident|sample|sample_id|library|batch|donor|subject)\\b", low)]
  qc_cols     <- md_cols[low %in% c("ncount_rna","nfeature_rna","percent.mt",
                                    "pct_mt","mito","percent.mito")]
  cc_cols     <- md_cols[low %in% c("s.score","g2m.score","phase")]
  
  list(
    dbr_cols      = dbr_cols,
    cluster_cols  = cluster_cols,
    res_cols      = res_cols,
    res_values    = unique(res_values),  # <- always defined now
    sample_cols   = sample_cols,
    qc_cols       = qc_cols,
    cellcycle_cols= cc_cols,
    reductions    = reds,
    graphs        = graphs
  )
}

.rds_get_assay_data <- function(sobj, assay = NULL, layer = "data") {
  aa <- as.character(assay %||% "")
  if (!nzchar(aa)) aa <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
  ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
  use_layer <- "layer" %in% ga_formals
  args <- if (isTRUE(use_layer)) {
    list(object = sobj, layer = layer)
  } else {
    list(object = sobj, slot = layer)
  }
  if (nzchar(aa)) args$assay <- aa
  out <- tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
  if (!is.null(out)) return(out)
  alt_args <- list(object = sobj)
  alt_args[[if (isTRUE(use_layer)) "slot" else "layer"]] <- layer
  if (nzchar(aa)) alt_args$assay <- aa
  tryCatch(do.call(Seurat::GetAssayData, alt_args), error = function(e) NULL)
}

.rds_build_elbow_plot <- function(sobj) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
  stdev <- tryCatch({
    red <- sobj[["pca"]]
    if (is.null(red)) return(numeric())
    as.numeric(slot(red, "stdev"))
  }, error = function(e) numeric())
  stdev <- stdev[is.finite(stdev) & !is.na(stdev)]
  if (!length(stdev)) return(NULL)
  df <- data.frame(
    PC = seq_along(stdev),
    Standard.Deviation = stdev,
    stringsAsFactors = FALSE
  )
  ggplot2::ggplot(df, ggplot2::aes(x = PC, y = Standard.Deviation)) +
    ggplot2::geom_line(color = "#2c7fb8", linewidth = 0.6) +
    ggplot2::geom_point(color = "#2c7fb8", size = 1.4) +
    ggplot2::labs(x = "PC", y = "Standard Deviation") +
    ggplot2::theme_minimal(base_size = 11)
}

# Ensure plotting prereqs exist on a Seurat object and return {sobj, plots}
.ensure_plot_prereqs <- function(sobj, desired_slot = "data") {
  reds <- tryCatch(names(sobj@reductions), error = function(e) character())
  reds_low <- tolower(reds)
  have_umap <- "umap" %in% reds_low
  have_tsne <- "tsne" %in% reds_low
  have_pca  <- "pca"  %in% reds_low
  
  default_red <- if (have_umap) {
    "umap"
  } else if (have_tsne) {
    "tsne"
  } else if (have_pca) {
    "pca"
  } else {
    NA_character_
  }

  slot_pref <- if (desired_slot %in% c("counts","data","scale.data")) desired_slot else "data"
  list(
    sobj = sobj,
      plots = list(
      default_reduction   = default_red,
      available_reductions= tolower(tryCatch(names(sobj@reductions), error=function(e) character())),
      feature_slot        = slot_pref,
      elbow               = .rds_build_elbow_plot(sobj)
    )
  )
}

# ---------------------------
# UI
# ---------------------------
rds_ui <- shiny::fluidPage(
  shinyjs::useShinyjs(),
  
  tags$style(HTML("
    .navbar-nav .disabled { pointer-events: none; opacity: 0.5; }
    .cfg-card .form-select, .cfg-card .selectize-control { max-width: 420px; }
    .cfg-help { color:#666; font-size: 0.92em; }
    .rds-top-card { min-height: 190px; }
    .rds-top-card .card-page-content {
      min-height: 220px;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
    }
    .rds-meta-chip {
      display:inline-block; padding:5px 9px; border-radius:999px;
      font-size:12px; font-weight:600; margin:0 6px 6px 0;
      color:#334155; background:#e2e8f0;
    }
    .rds-kv { margin-bottom: 4px; color:#334155; }
    .rds-kv b { color:#0f172a; }
    .rds-muted { color:#64748b; font-size: 12px; }
    .rds-obj-select { min-width: 420px; width: 36vw; max-width: 700px; }
    .rds-obj-select .form-group,
    .rds-obj-select .selectize-control,
    .rds-obj-select .form-control { width: 100% !important; max-width: none !important; }
    .rds-vdj-relink-select .selectize-control.single .selectize-input {
      padding-right: 34px !important;
    }
    .rds-vdj-relink-select .selectize-control.single .selectize-input > .item,
    .rds-vdj-relink-select .selectize-control.single .selectize-input > input {
      max-width: 100%;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .rds-vdj-relink-root {
      max-height: 72vh;
      overflow-y: auto;
      overflow-x: hidden;
      padding-right: 2px;
    }
    .rds-vdj-summary-wrap {
      overflow-x: auto;
    }
    .rds-vdj-summary-wrap table {
      font-size: 0.92em;
      white-space: nowrap;
      width: 100%;
    }
    #rds_review_card .dataTables_wrapper { width: 100% !important; }
    #rds_review_card .dataTables_scrollBody { overflow-x: auto !important; }
    #rds_review_card table.rds-review-dt thead th {
      font-size: 10.5px !important;
      line-height: 1.1;
      padding: 4px 6px;
      white-space: normal;
      word-break: break-word;
    }
    #rds_review_card table.rds-review-dt tbody td {
      font-size: 11.5px !important;
      line-height: 1.2;
      padding: 5px 6px;
    }
    #rds_review_card table.rds-review-dt tbody td.dt-type-numeric,
    #rds_review_card table.rds-review-dt tbody td.dt-right,
    #rds_review_card table.rds-review-dt tbody td.dt-body-right {
      font-size: 10.8px !important;
      font-variant-numeric: tabular-nums;
      letter-spacing: -0.01em;
    }
    #rds_review_card table.rds-review-dt tbody td.rds-num-nowrap,
    #rds_review_card table.rds-review-dt thead th.rds-num-nowrap {
      white-space: nowrap !important;
      overflow-wrap: normal !important;
      word-break: normal !important;
      font-variant-numeric: tabular-nums;
      text-align: center !important;
    }
    #rds_review_card table.rds-review-dt tbody td.rds-object-strong,
    #rds_review_card table.rds-review-dt tbody td.rds-cell-count-strong {
      font-weight: 700 !important;
    }
    #rds_review_card table.rds-review-dt thead th.rds-assay-nowrap,
    #rds_review_card table.rds-review-dt tbody td.rds-assay-nowrap {
      white-space: nowrap !important;
      overflow-wrap: normal !important;
      word-break: normal !important;
      min-width: 64px;
    }
    #rds_review_card table.rds-review-dt thead th:nth-child(3),
    #rds_review_card table.rds-review-dt tbody td:nth-child(3) {
      white-space: nowrap !important;
      overflow-wrap: normal !important;
      word-break: normal !important;
      min-width: 72px;
    }
    #rds_review_card table.rds-review-dt tbody td.rds-delim-wrap {
      white-space: normal !important;
      overflow-wrap: normal !important;
      word-break: normal !important;
    }
    #rds_review_card table.rds-review-dt tbody td.rds-res-wrap {
      white-space: normal !important;
      overflow-wrap: normal !important;
      word-break: normal !important;
    }
    #rds_meta_panel .dataTables_wrapper,
    #rds_meta_panel table.dataTable { width: 100% !important; }
    #rds_meta_panel table.dataTable td { vertical-align: top; }
    .rds-export-wrap {
      position: relative;
      border-radius: 8px;
      min-height: 150px;
      flex: 1 1 auto;
    }
    .rds-export-wrap.disabled {
      background: #f1f5f9;
      border: 1px solid #d8e0ea;
      opacity: 0.9;
    }
    .rds-export-empty-msg {
      position: absolute;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      text-align: center;
      padding: 10px 14px;
      color: #64748b;
      font-weight: 600;
      font-size: 0.95rem;
      pointer-events: none;
      border-radius: 8px;
      background: rgba(241, 245, 249, 0.72);
      z-index: 3;
    }
    .rds-bundle-wrap { display: flex; flex-direction: column; gap: 10px; }
    .rds-bundle-chiprow { display: flex; flex-wrap: wrap; gap: 8px; }
    .rds-bundle-chip {
      display:inline-block; padding:6px 12px; border-radius:999px;
      font-size: 0.95rem; font-weight: 700; color:#334155; background:#e2e8f0;
      border: 1px solid #d5dde8;
    }
    .rds-bundle-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap: 6px 14px;
    }
    .rds-bundle-kv { color:#334155; font-size: 1.02rem; }
    .rds-bundle-kv b { color:#0f172a; }
    .rds-bundle-note {
      color:#6b7280; font-size: 0.92rem; background:#f8fafc;
      border:1px solid #e5e7eb; border-radius:8px; padding:8px 10px;
    }
    .rds-bundle-details summary { cursor:pointer; color:#0f172a; }
    .rds-important-note {
      margin-top: 8px;
      margin-bottom: 8px;
      padding: 5px 7px;
      border-radius: 8px;
      border: 1px solid #f5c26b;
      background: #fff7e6;
      color: #7c2d12;
      font-size: 0.76rem;
      line-height: 1.25;
    }
    .rds-important-note b {
      color: #9a3412;
    }
    .rds-import-note {
      margin-top: 2px;
      padding: 8px 10px;
      border-radius: 8px;
      border: 1px solid #bfdbfe;
      background: #eff6ff;
      color: #1e3a8a;
      font-size: 0.84rem;
      line-height: 1.35;
      box-shadow: 0 1px 2px rgba(30, 64, 175, 0.08);
    }
    .rds-import-note b {
      color: #1d4ed8;
    }
    .rds-import-card .form-group {
      margin-bottom: 6px;
    }
    .rds-fast-checkpoint-row .checkbox {
      margin-top: 0;
      margin-bottom: 0;
    }
    .rds-fast-checkpoint-row .checkbox label {
      white-space: nowrap;
    }
    .rds-code-details {
      margin-top: 8px;
    }
    .rds-code-details > summary {
      cursor: pointer;
      color: #0f172a;
      font-weight: 700;
      margin-bottom: 6px;
      list-style: none;
    }
    .rds-code-details > summary::-webkit-details-marker { display: none; }
    .rds-code-details > summary::before {
      content: '▸';
      display: inline-block;
      margin-right: 6px;
      color: #475569;
    }
    .rds-code-details[open] > summary::before {
      content: '▾';
    }
  ")),
  wl_code_block_assets(),
  tags$script(HTML(sprintf("
    (function() {
      var bound = false;
      var overlayMessage = %s;
      function showRdsUploadOverlay() {
        if (window.WLSpinnerOverlay && typeof window.WLSpinnerOverlay.show === 'function') {
          window.WLSpinnerOverlay.show({
            id: 'global_overlay',
            text: overlayMessage
          });
        }
      }
      function bindRdsUploadOverlay() {
        if (bound || !window.jQuery) return;
        bound = true;
        window.jQuery(document).on('shiny:inputchanged.rdsUploadOverlay', function(evt) {
          if (!evt || evt.name !== 'import_rds_file') return;
          if (evt.inputType !== 'shiny.fileupload') return;
          if (!Array.isArray(evt.value) || evt.value.length === 0) return;
          showRdsUploadOverlay();
        });
      }
      document.addEventListener('DOMContentLoaded', bindRdsUploadOverlay);
      document.addEventListener('shiny:connected', bindRdsUploadOverlay);
    })();
  ", jsonlite::toJSON(RDS_UI_TEXT$ui_text_overlay_reading_rds_file, auto_unbox = TRUE)))),
  
  div(
    class = "card-page-wrap",
    div(
      class = "page-header",
      h2(icon("database"), " ", RDS_UI_TEXT$ui_title_export_import_seurat_object_rds),
      p(RDS_UI_TEXT$ui_text_save_processed_seurat_objects_later_sessions)
    ),

    # ==== Review & Configure (shown AFTER import) ====
    card_page_card(
      title = RDS_UI_TEXT$ui_text_review_configure_imported_objects,
      icon_name = "sliders",
      subtitle = RDS_UI_TEXT$ui_text_confirm_default_assay_data_slot_plotting,
      id = "rds_review_card",
      class = "mb-3 cfg-card focus_card_style",
      style = "display:none;",
      h5(RDS_UI_TEXT$ui_title_summary),
      DT::dataTableOutput("rds_review_table"),
      tags$p(
        class = "cfg-help",
        RDS_UI_TEXT$ui_text_tip_click_one_more_rows_first
      ),
      tags$hr(),
      h5(RDS_UI_TEXT$ui_title_per_object_configuration),
      div(id = "rds_config_panels_placeholder"),
      tags$div(
        class = "mt-3 d-flex gap-2",
        actionButton("rds_apply_and_proceed", RDS_UI_TEXT$ui_btn_add_workspace, class = "btn btn-primary"),
        actionButton("rds_discard_pending", RDS_UI_TEXT$ui_btn_discard_imported_preview, class = "btn btn-outline-secondary")
      )
    ),
    
    fluidRow(
      column(
        6,
        card_page_card(
          title = RDS_UI_TEXT$ui_title_export_object,
          icon_name = "file-export",
          class = "mb-3 rds-top-card",
          div(
            id = "rds_export_wrap",
            class = "rds-export-wrap disabled",
            p(RDS_UI_TEXT$ui_text_export_current_registered_seurat_objects_into),
            div(
              class = "app-control-stack",
              div(
                class = "rds-fast-checkpoint-row",
                checkboxInput("rds_export_fast_checkpoint", RDS_UI_TEXT$ui_label_fast_checkpoint, value = FALSE)
              ),
              div(class = "rds-muted app-control-note", RDS_UI_TEXT$ui_text_fast_checkpoint_help),
              shinyjs::disabled(downloadButton("download_rds_btn", RDS_UI_TEXT$ui_btn_download_all_datasets_rds, class = "btn-primary")),
              shinyjs::disabled(downloadButton("download_rds_structure_txt_btn", RDS_UI_TEXT$ui_btn_download_structure_tree_txt, class = "btn-secondary"))
            ),
            div(class = "rds-muted mt-2", RDS_UI_TEXT$ui_text_includes_object_wrappers_plots_preferences_current),
            div(
              class = "app-note-box rds-important-note",
              RDS_UI_TEXT$ui_text_export_keep_bundle_note
            ),
            div(
              class = "mt-3",
              tags$details(
                class = "rds-code-details",
                tags$summary(RDS_UI_TEXT$ui_title_usage_code_example),
                div(
                  class = "mb-2",
                  actionButton("rds_copy_usage_code_btn", RDS_UI_TEXT$ui_btn_copy_usage_code, class = "btn btn-sm btn-outline-secondary rds-code-copy-btn")
                ),
                div(
                  id = "rds_export_usage_code",
                  class = "rds-code-block-wrap",
                  tags$pre(class = "rds-code-block", tags$code(class = "rds-r-code", RDS_WORKSPACE_EXPORT_USAGE_CODE))
                ),
                div(class = "rds-muted mt-1", RDS_UI_TEXT$ui_text_usage_code_note)
              )
            ),
            div(
              id = "rds_export_empty_msg",
              class = "rds-export-empty-msg",
              RDS_UI_TEXT$ui_text_export_wrap_empty
            )
          )
        )
      ),
      column(
        6,
        card_page_card(
          title = RDS_UI_TEXT$ui_title_import_object,
          icon_name = "file-import",
          class = "mb-3 rds-top-card rds-import-card",
          p(RDS_UI_TEXT$ui_text_import_saved_workspace_rds_single_seurat),
          fileInput("import_rds_file", RDS_UI_TEXT$ui_label_upload_rds, accept = c(".rds", ".RDS")),
          div(
            class = "app-note-box rds-import-note",
            RDS_UI_TEXT$ui_text_import_wait_notice
          )
        )
      )
    ),

    fluidRow(
      column(
        6,
        card_page_card(
          title = RDS_UI_TEXT$ui_title_export_single_object,
          icon_name = "download",
          class = "mb-3",
          p(RDS_UI_TEXT$ui_text_export_single_object_into_rds),
          div(
            class = "app-control-stack",
            div(
              class = "rds-fast-checkpoint-row",
              checkboxInput("rds_single_export_fast_checkpoint", RDS_UI_TEXT$ui_label_fast_checkpoint, value = FALSE)
            ),
            div(class = "rds-muted app-control-note", RDS_UI_TEXT$ui_text_fast_checkpoint_help),
            uiOutput("rds_single_export_object_ui"),
            downloadButton("download_single_object_rds_btn", RDS_UI_TEXT$ui_btn_download_selected_object_rds, class = "btn-secondary"),
            downloadButton("download_single_object_structure_txt_btn", RDS_UI_TEXT$ui_btn_download_selected_object_structure_tree_txt, class = "btn-secondary")
          ),
          div(class = "rds-muted mt-2", RDS_UI_TEXT$ui_text_includes_object_wrappers_plots_preferences_current),
          div(
            class = "app-note-box rds-important-note",
            RDS_UI_TEXT$ui_text_export_keep_bundle_note
          ),
          div(
            class = "mt-3",
            tags$details(
              class = "rds-code-details",
              tags$summary(RDS_UI_TEXT$ui_title_usage_code_example_single),
              div(
                class = "mb-2",
                actionButton("rds_single_copy_usage_code_btn", RDS_UI_TEXT$ui_btn_copy_usage_code, class = "btn btn-sm btn-outline-secondary rds-code-copy-btn")
              ),
              div(
                id = "rds_single_export_usage_code",
                class = "rds-code-block-wrap",
                tags$pre(class = "rds-code-block", tags$code(class = "rds-r-code", RDS_SINGLE_EXPORT_USAGE_CODE))
              ),
              div(class = "rds-muted mt-1", RDS_UI_TEXT$ui_text_usage_code_note)
            )
          )
        )
      ),
      column(
        6,
        card_page_card(
          title = RDS_UI_TEXT$ui_title_export_analysis_parameters_session_info,
          icon_name = "file-alt",
          class = "mb-3",
          p(RDS_UI_TEXT$ui_text_includes_per_page_analysis_parameters_and_session),
          downloadButton("download_params_session_txt_btn", RDS_UI_TEXT$ui_btn_download_params_session_txt, class = "btn-secondary")
        )
      )
    ),
    
    # ==== Review & Configure (shown AFTER import) ====
    card_page_card(
      title = RDS_UI_TEXT$ui_text_imported_bundle_info,
      icon_name = "box-open",
      id = "rds_bundle_info_panel",
      class = "mb-3",
      style = "display:none;",
      htmlOutput("rds_bundle_info_html")
    ),
    
    # ==== Metadata Explorer ====
    card_page_card(
      title = RDS_UI_TEXT$ui_text_object_metadata_explorer,
      icon_name = "table",
      id = "rds_meta_panel",
      class = "mb-3",
      title_right = div(
        class = "rds-obj-select",
        selectInput("rds_meta_obj", RDS_UI_TEXT$ui_label_object, choices = NULL, width = "100%")
      ),
      fluidRow(
        column(
          12,
          uiOutput("rds_meta_snapshot_ui"),
          tags$hr(),
          htmlOutput("rds_meta_signals_html"),
          tags$hr(),
          div(style = "width:100%;", DT::dataTableOutput("rds_meta_table"))
        )
      )
    ),
    
    # ==== Diagnostics (collapsed) + Stage & Tab Gating (UI) ====
    card_page_card(
      title = RDS_UI_TEXT$ui_text_diagnostics,
      icon_name = "stethoscope",
      id = "rds_diag_panel",
      class = "mb-3",
      title_right = div(
        checkboxInput("rds_show_diag", RDS_UI_TEXT$ui_label_show_diagnostics, value = FALSE, width = "180px"),
        shinyWidgets::materialSwitch(
          inputId = "rds_gate_force_enable",
          label = RDS_UI_TEXT$ui_text_force_enable_gated_tabs,
          status = "primary", value = FALSE
        )
      ),
      div(
        id = "rds_diag_body",
        style = "display:none;",
        h6(RDS_UI_TEXT$ui_title_pipeline_stage_tab_gating),
        htmlOutput("rds_gate_legend_html"),
        DT::dataTableOutput("rds_gate_stages_table")
      )
    )
  )
)

# Keep workspace bundle active-object intent round-trippable across export/import.
.extract_bundle_active_object_name <- function(bundle) {
  if (!is.list(bundle)) return("")

  candidates <- list(
    if ("active_object_name" %in% names(bundle)) bundle$active_object_name else NULL,
    if (is.list(bundle$pipeline_info) && "active_object_name" %in% names(bundle$pipeline_info)) {
      bundle$pipeline_info$active_object_name
    } else {
      NULL
    }
  )

  for (candidate in candidates) {
    if (length(candidate) != 1) next
    candidate_chr <- as.character(candidate)
    if (!is.na(candidate_chr) && nzchar(candidate_chr)) return(candidate_chr)
  }

  ""
}

.resolve_rds_import_active_object_name <- function(object_names, focus = NULL, imported_active_name = NULL, registry = NULL) {
  object_names <- as.character(object_names)
  object_names <- object_names[!is.na(object_names) & nzchar(object_names)]
  if (!length(object_names)) return("")

  focus_name <- ""
  if (is.list(focus) && length(focus$object) == 1) {
    focus_chr <- as.character(focus$object)
    if (!is.na(focus_chr) && nzchar(focus_chr) && focus_chr %in% object_names) {
      focus_name <- focus_chr
    }
  }

  imported_active_chr <- ""
  if (length(imported_active_name) == 1) {
    imported_active_chr <- as.character(imported_active_name)
    if (is.na(imported_active_chr) || !nzchar(imported_active_chr) || !imported_active_chr %in% object_names) {
      imported_active_chr <- ""
    }
  }

  preferred_loaded_name <- get0("analysis_preferred_loaded_object_name", mode = "function", inherits = TRUE)
  if (is.function(preferred_loaded_name) && is.list(registry) && length(registry)) {
    preferred_name <- tryCatch(
      preferred_loaded_name(
        registry,
        focus_name = focus_name,
        imported_active_name = imported_active_chr
      ),
      error = function(e) ""
    )
    if (nzchar(preferred_name) && preferred_name %in% object_names) {
      return(preferred_name)
    }
  }

  if (nzchar(focus_name)) {
    return(focus_name)
  }

  if (nzchar(imported_active_chr)) {
    return(imported_active_chr)
  }

  object_names[[1]]
}

# ---------------------------
# SERVER
# ---------------------------
rds_server <- function(input, output, session,
                       shared_data,
                       APP_VERSION,
                       MINIMUM_COMPATIBLE_VERSION,
                       MAXIMUM_COMPATIBLE_VERSION) {
  
  # ---------- overlay + DT state helpers ----------
  rds_review_df     <- reactiveVal(NULL)    # current Summary DF
  rds_default_focus <- reactiveVal(NULL)    # list(object, assay) from DT
  rds_bundle_info   <- reactiveVal(NULL)    # parsed pipeline info from imported bundle
  
  .show_overlay <- function(msg = NULL) {
    # Uses overlay_show() from spinner_overlay.R
    if (is.null(msg) || !nzchar(msg)) {
      overlay_show()
    } else {
      overlay_show(text = msg)
    }
  }
  .hide_overlay <- function() {
    overlay_hide()
  }
  
  # Enable/disable export button (UI state)
  observe({
    has_objs <- !is.null(shared_data$all_seurat_objects) && length(shared_data$all_seurat_objects) > 0
    if (has_objs) {
      shinyjs::enable("download_rds_btn")
      shinyjs::enable("download_rds_structure_txt_btn")
      shinyjs::removeClass("rds_export_wrap", "disabled")
      shinyjs::hide("rds_export_empty_msg")
    } else {
      shinyjs::disable("download_rds_btn")
      shinyjs::disable("download_rds_structure_txt_btn")
      shinyjs::addClass("rds_export_wrap", "disabled")
      shinyjs::show("rds_export_empty_msg")
    }
  })

  observe({
    if (is.null(rds_bundle_info()) && is.null(rds_pending())) {
      shinyjs::hide("rds_bundle_info_panel")
    } else {
      shinyjs::show("rds_bundle_info_panel")
    }
  })

  # --- helpers ---
  .is_seurat <- function(x) inherits(x, "Seurat")
  .scalar_chr <- function(x, default = "") {
    if (is.null(x) || length(x) == 0) return(default)
    y <- as.character(x)
    y <- y[is.finite(nchar(y)) & !is.na(y)]
    if (!length(y)) return(default)
    y[[1]]
  }
  .env_from_seurat_version <- function(ver) {
    v <- .scalar_chr(ver %||% "", default = "")
    if (startsWith(v, "4.")) return("seurat4")
    if (startsWith(v, "5.")) return("seurat5")
    "unknown"
  }
  .pkg_version_lookup <- function(pkgs, pkg_name) {
    if (is.null(pkgs) || length(pkgs) == 0) return(NA_character_)
    if (is.list(pkgs) && !is.null(pkgs[[pkg_name]])) {
      return(.scalar_chr(pkgs[[pkg_name]], default = NA_character_))
    }
    nms <- names(pkgs) %||% character()
    if (length(nms) && pkg_name %in% nms) {
      return(.scalar_chr(unname(pkgs[[pkg_name]]), default = NA_character_))
    }
    NA_character_
  }
  .detect_seurat_object_version <- function(sobj) {
    vslot <- tryCatch(.scalar_chr(slot(sobj, "version"), default = NA_character_), error = function(e) NA_character_)
    if (!is.na(vslot) && nzchar(vslot)) return(list(version = vslot, env = .env_from_seurat_version(vslot)))
    an <- tryCatch(Seurat::Assays(sobj), error = function(e) character())
    acls <- unname(vapply(an, function(a) tryCatch(class(sobj[[a]])[1], error = function(e) ""), character(1)))
    if (any(grepl("Assay5", acls, fixed = TRUE))) return(list(version = "5.x (detected)", env = "seurat5"))
    if (any(grepl("^Assay$", acls))) return(list(version = "4.x (detected)", env = "seurat4"))
    list(version = "unknown", env = "unknown")
  }
  .build_sample_sheet_from_registry <- function(objs) {
    entries <- .normalize_imported_list(objs)
    if (!length(entries)) {
      return(data.frame(
        name = character(0), path = character(0), type = character(0),
        condition = character(0), batch = character(0), qc_status = character(0),
        use_in_analysis = logical(0),
        min_features = numeric(0), max_features = numeric(0),
        min_umi_counts = numeric(0), max_umi_counts = numeric(0),
        max_mt_percent = numeric(0),
        stringsAsFactors = FALSE
      ))
    }

    nm_all <- names(entries)
    nm_use <- nm_all[!grepl("_filtered$", nm_all, ignore.case = TRUE)]
    if (!length(nm_use)) nm_use <- nm_all

    .pick_md_value <- function(md, candidates, default = "Unknown") {
      if (is.null(md) || !is.data.frame(md) || NROW(md) == 0) return(default)
      cols <- colnames(md)
      if (is.null(cols) || !length(cols)) return(default)
      low_cols <- tolower(as.character(cols))
      low_cands <- tolower(as.character(candidates))
      col_idx <- NA_integer_
      for (cand in low_cands) {
        i <- match(cand, low_cols)
        if (!is.na(i)) { col_idx <- i; break }
      }
      if (is.na(col_idx)) return(default)
      vals <- unique(trimws(as.character(md[[col_idx]])))
      vals <- vals[!is.na(vals) & nzchar(vals)]
      if (!length(vals)) return(default)
      if (length(vals) == 1) return(vals[[1]])
      "Mixed"
    }

    rows <- lapply(nm_use, function(nm) {
      ent <- entries[[nm]]
      sobj <- if (is.list(ent) && !is.null(ent$obj)) ent$obj else ent
      md <- tryCatch(sobj@meta.data, error = function(e) NULL)
      cond <- .pick_md_value(md, c("condition", "group", "orig.ident", "sample"), default = "Unknown")
      bat <- .pick_md_value(md, c("batch", "library"), default = "Batch1")
      data.frame(
        name = nm,
        path = paste0("rds::", nm),
        type = "rds",
        condition = cond,
        batch = bat,
        qc_status = "Pending",
        use_in_analysis = TRUE,
        min_features = 200,
        max_features = 5000,
        min_umi_counts = 500,
        max_umi_counts = 50000,
        max_mt_percent = 20,
        stringsAsFactors = FALSE
      )
    })
    do.call(rbind, rows)
  }
  
  .summarize_seurat <- function(sobj) {
    assay_vec <- tryCatch(Seurat::Assays(sobj), error = function(e) character())
    reds      <- tryCatch(names(sobj@reductions), error = function(e) character())
    n_cells   <- tryCatch(ncol(sobj), error = function(e) NA_integer_)
    md_cols   <- tryCatch(colnames(sobj@meta.data), error = function(e) character())
    res_cols <- md_cols[grepl("_res\\.[0-9]", tolower(md_cols), perl = TRUE)]
    
    # extract the number after *_res.
    res_vals <- sub("^.*_res\\.([0-9]+(?:\\.[0-9]+)?)$",
                    "\\1",
                    tolower(res_cols))
    
    md_low  <- tolower(md_cols)
    qc      <- any(md_low %in% c("ncount_rna","nfeature_rna","percent.mt","pct_mt","mito","percent.mito"))
    dbl     <- any(grepl("doublet|dbr", md_low))
    gnames  <- tryCatch(tolower(names(sobj@graphs)), error = function(e) character())
    neigh   <- any(grepl("snn|knn|neighbors", gnames))
    has_umap<- any(tolower(reds) == "umap")
    idents_ok <- tryCatch({ ids <- Seurat::Idents(sobj); !is.null(ids) && length(levels(ids)) > 1 }, error = function(e) FALSE)
    stage <- if (isTRUE(neigh) || isTRUE(has_umap) || isTRUE(idents_ok)) "clustered_analyzed"
    else if (isTRUE(dbl)) "post_doublet"
    else if (isTRUE(qc))  "qc_or_post_qc"
    else "raw_or_unknown"
    
    # per-assay metrics
    .is_matrix_like <- function(x) {
      d <- tryCatch(dim(x), error = function(e) NULL)
      !is.null(d) && length(d) == 2L
    }
    .scalar_int_or_na <- function(x) {
      if (length(x) == 0L || is.null(x)) return(NA_integer_)
      v <- suppressWarnings(as.integer(x[[1]]))
      if (!length(v) || is.na(v)) return(NA_integer_)
      v
    }
    .scalar_num_or_na <- function(x) {
      if (length(x) == 0L || is.null(x)) return(NA_real_)
      v <- suppressWarnings(as.numeric(x[[1]]))
      if (!length(v) || is.na(v)) return(NA_real_)
      v
    }
    .assay_name_or_unknown <- function(x) {
      nm <- as.character(x %||% "")
      nm <- nm[!is.na(nm) & nzchar(nm)]
      if (!length(nm)) "unknown_assay" else nm[[1]]
    }

    assay_rows <- lapply(assay_vec, function(a) {
      assay_name <- .assay_name_or_unknown(a)
      counts_mat <- .rds_get_assay_data(sobj, assay = assay_name, layer = "counts")
      data_mat   <- .rds_get_assay_data(sobj, assay = assay_name, layer = "data")
      scale_mat  <- .rds_get_assay_data(sobj, assay = assay_name, layer = "scale.data")

      has_counts <- .is_matrix_like(counts_mat)
      has_data   <- .is_matrix_like(data_mat)
      has_scale  <- .is_matrix_like(scale_mat)

      if (!has_counts && !is.null(counts_mat)) {
        message(sprintf("[RDS IMPORT DIAG] assay=%s layer=counts returned non-2D object (class=%s)", assay_name, paste(class(counts_mat), collapse = ",")))
      }
      if (!has_data && !is.null(data_mat)) {
        message(sprintf("[RDS IMPORT DIAG] assay=%s layer=data returned non-2D object (class=%s)", assay_name, paste(class(data_mat), collapse = ",")))
      }
      if (!has_scale && !is.null(scale_mat)) {
        message(sprintf("[RDS IMPORT DIAG] assay=%s layer=scale.data returned non-2D object (class=%s)", assay_name, paste(class(scale_mat), collapse = ",")))
      }

      n_feat <- tryCatch({
        if (has_counts) .scalar_int_or_na(nrow(counts_mat))
        else if (has_data) .scalar_int_or_na(nrow(data_mat))
        else if (has_scale) .scalar_int_or_na(nrow(scale_mat))
        else NA_integer_
      }, error = function(e) NA_integer_)

      total_counts <- tryCatch({
        if (has_counts) .scalar_num_or_na(sum(counts_mat)) else NA_real_
      }, error = function(e) NA_real_)
      median_counts <- tryCatch({
        if (has_counts) .scalar_num_or_na(stats::median(Matrix::colSums(counts_mat))) else NA_real_
      }, error = function(e) NA_real_)

      data.frame(
        assay = assay_name,
        slot_counts = isTRUE(has_counts),
        slot_data   = isTRUE(has_data),
        slot_scale  = isTRUE(has_scale),
        n_features  = .scalar_int_or_na(n_feat),
        total_counts = .scalar_num_or_na(total_counts),
        median_counts_per_cell = .scalar_num_or_na(median_counts),
        stringsAsFactors = FALSE
      )
    })
    
    assay_table <- if (length(assay_rows)) do.call(rbind, assay_rows) else
      data.frame(assay=character(), slot_counts=logical(), slot_data=logical(),
                 slot_scale=logical(), n_features=integer(), total_counts=double(),
                 median_counts_per_cell=double())
    
    # sample column guess + samples
    guess_sample_col <- {
      candidates <- c("orig.ident","sample","Sample","sample_id","library","batch","donor","subject")
      hit <- candidates[match(tolower(candidates), tolower(md_cols), nomatch = 0)]
      if (length(hit)) hit[1] else if (length(md_cols)) md_cols[1] else NA_character_
    }
    sample_values <- tryCatch({
      col <- guess_sample_col
      if (!is.na(col) && col %in% md_cols) unique(as.character(sobj@meta.data[[col]])) else character()
    }, error = function(e) character())
    
    current_ident <- tryCatch({ as.character(colnames(model.matrix(~ 0 + Seurat::Idents(sobj))))[1] }, error = function(e) NULL)
    guess_ident <- current_ident %||% {
      cand <- md_cols
      cand[match(tolower(c("seurat_clusters","cluster","celltype","cell_type","ident","group")),
                 tolower(cand), nomatch = 0)]
    }
    barcode_like <- md_cols[grepl("barcode|cell.*list|keep|filter|whitelist|blacklist|dbr|doublet", tolower(md_cols))]
    
    list(
      reductions   = reds,
      n_cells      = n_cells,
      stage        = stage,
      assay_table  = assay_table,
      md_cols      = md_cols,
      sample_guess = guess_sample_col,
      sample_names = sample_values,
      ident_guess  = (guess_ident[1] %||% NA_character_),
      barcode_cols = barcode_like,
      meta_ncols   = length(md_cols),
      resolutions  = unique(res_vals)
    )
  }
  
  # SAFE bounded scanner
  .scan_for_seurat <- function(x, base = "root", max_nodes = 2000, max_depth = 6, time_limit_sec = 3) {
    t0 <- proc.time()[["elapsed"]]
    results <- list()
    queue <- list(list(obj = x, path = base, depth = 0))
    qh <- 1L
    nodes <- 0L
    while (qh <= length(queue)) {
      if ((proc.time()[["elapsed"]] - t0) > time_limit_sec || nodes > max_nodes) break
      cur <- queue[[qh]]; qh <- qh + 1L; obj <- cur$obj; path <- cur$path; d <- cur$depth
      nodes <- nodes + 1L
      if (is.list(obj) && !is.null(obj$obj) && .is_seurat(obj$obj)) {
        results[[length(results) + 1L]] <- list(path = path, name = basename(path), obj = obj$obj, entry = obj)
        next
      }
      if (.is_seurat(obj)) {
        results[[length(results) + 1L]] <- list(path = path, name = basename(path), obj = obj, entry = obj)
        next
      }
      if (!is.list(obj) || d >= max_depth) next
      nm <- names(obj)
      for (i in seq_along(obj)) {
        child <- obj[[i]]
        label <- if (!is.null(nm) && nzchar(nm[i])) nm[i] else paste0("[[", i, "]]")
        queue[[length(queue) + 1L]] <- list(obj = child, path = paste0(path, "$", label), depth = d + 1L)
      }
    }
    attr(results, "truncated") <- (nodes > max_nodes) || ((proc.time()[["elapsed"]] - t0) > time_limit_sec)
    results
  }
  
  # ====== state for Review & Configure ======
  rds_pending <- reactiveVal(NULL)
  rds_selective_candidates <- reactiveVal(NULL)
  rds_missing_vdj_prompt_sig <- reactiveVal("")
  rds_vdj_relink_target_obj <- reactiveVal("")
  rds_vdj_relink_uploaded <- reactiveVal(data.frame())

  .rds_vdj_norm_bc <- function(x) {
    x <- toupper(as.character(x %||% ""))
    x <- gsub("\\s+", "", x, perl = TRUE)
    x <- gsub("-\\d+$", "", x, perl = TRUE)
    x <- gsub("[^A-Z0-9]", "", x, perl = TRUE)
    x
  }
  .rds_vdj_pick_barcode_col <- function(df) {
    if (is.null(df) || !is.data.frame(df) || !nrow(df)) return(NA_character_)
    nms <- colnames(df)
    lo <- tolower(nms)
    cand <- c("barcode", "barcodes", "cell", "cell_barcode", "barcode_id")
    hit <- cand[cand %in% lo]
    if (length(hit)) return(nms[match(hit[[1]], lo)])
    NA_character_
  }
  .rds_vdj_read_df <- function(path) {
    ext <- tolower(tools::file_ext(path))
    if (identical(ext, "csv")) return(utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE))
    utils::read.delim(path, stringsAsFactors = FALSE, check.names = FALSE)
  }
  .rds_vdj_infer_chain <- function(file_name = "", file_path = "", declared_type = "") {
    tp <- toupper(as.character(declared_type %||% ""))
    if (tp %in% c("TCR", "BCR")) return(tp)
    token <- tolower(paste(as.character(file_name %||% ""), as.character(file_path %||% ""), sep = " "))
    if (grepl("(^|[^a-z])tcr([^a-z]|$)|vdj_t|tra|trb|trg|trd", token, perl = TRUE)) return("TCR")
    if (grepl("(^|[^a-z])bcr([^a-z]|$)|vdj_b|igh|igk|igl", token, perl = TRUE)) return("BCR")
    if (nzchar(file_path) && file.exists(file_path)) {
      df <- tryCatch(.rds_vdj_read_df(file_path), error = function(e) NULL)
      if (is.data.frame(df) && nrow(df)) {
        nms <- tolower(colnames(df))
        ccol_idx <- match(TRUE, nms %in% c("chain", "locus"), nomatch = 0L)
        if (ccol_idx > 0L) {
          vals <- toupper(as.character(df[[ccol_idx]] %||% ""))
          vals <- vals[!is.na(vals) & nzchar(vals)]
          if (length(vals)) {
            if (any(grepl("TRA|TRB|TRG|TRD|TCR", vals, perl = TRUE))) return("TCR")
            if (any(grepl("IGH|IGK|IGL|BCR", vals, perl = TRUE))) return("BCR")
          }
        }
      }
    }
    "Unknown"
  }
  .rds_vdj_barcode_overlap <- function(path, object_cells_norm) {
    if (!nzchar(path) || !file.exists(path) || !length(object_cells_norm)) {
      return(list(n_overlap = 0L, n_file = 0L, pct = 0))
    }
    df <- tryCatch(.rds_vdj_read_df(path), error = function(e) NULL)
    if (is.null(df) || !is.data.frame(df) || !nrow(df)) {
      return(list(n_overlap = 0L, n_file = 0L, pct = 0))
    }
    bc_col <- .rds_vdj_pick_barcode_col(df)
    if (is.na(bc_col) || !nzchar(bc_col)) {
      return(list(n_overlap = 0L, n_file = 0L, pct = 0))
    }
    bcs <- .rds_vdj_norm_bc(df[[bc_col]])
    bcs <- unique(bcs[nzchar(bcs)])
    if (!length(bcs)) return(list(n_overlap = 0L, n_file = 0L, pct = 0))
    ov <- sum(bcs %in% object_cells_norm, na.rm = TRUE)
    list(n_overlap = as.integer(ov), n_file = as.integer(length(bcs)), pct = ifelse(length(bcs) > 0, 100 * ov / length(bcs), 0))
  }
  .rds_vdj_unmatched_examples <- function(path, object_cells_norm, max_n = 8L) {
    if (!nzchar(path) || !file.exists(path)) return(character(0))
    df <- tryCatch(.rds_vdj_read_df(path), error = function(e) NULL)
    if (is.null(df) || !is.data.frame(df) || !nrow(df)) return(character(0))
    bc_col <- .rds_vdj_pick_barcode_col(df)
    if (is.na(bc_col) || !nzchar(bc_col)) return(character(0))
    raw <- as.character(df[[bc_col]] %||% "")
    norm <- .rds_vdj_norm_bc(raw)
    keep <- nzchar(norm)
    raw <- raw[keep]
    norm <- norm[keep]
    if (!length(norm)) return(character(0))
    miss_idx <- which(!(norm %in% object_cells_norm))
    if (!length(miss_idx)) return(character(0))
    vals <- raw[miss_idx]
    vals <- vals[!is.na(vals) & nzchar(vals)]
    unique(head(vals, max_n))
  }
  .rds_vdj_pick_col <- function(nm, candidates) {
    lo <- tolower(as.character(nm %||% character(0)))
    hit <- candidates[candidates %in% lo]
    if (!length(hit)) return(NA_character_)
    as.character(nm[[match(hit[[1]], lo)]])
  }
  .rds_vdj_classify_chain <- function(x, fallback = "UNKNOWN") {
    up <- toupper(as.character(x %||% ""))
    out <- rep(toupper(as.character(fallback %||% "UNKNOWN")), length(up))
    out[grepl("^(TRA|TRB|TRD|TRG)|TCR", up)] <- "TCR"
    out[grepl("^(IGH|IGK|IGL)|BCR", up)] <- "BCR"
    out
  }
  .rds_import_vdj_into_entry <- function(entry, relink_df) {
    if (!is.list(entry) || is.null(entry$obj) || !inherits(entry$obj, "Seurat")) return(entry)
    if (!is.data.frame(relink_df) || !nrow(relink_df)) stop("No relink rows were provided for VDJ import.")
    sobj <- entry$obj
    md <- tryCatch(sobj@meta.data, error = function(e) NULL)
    if (!is.data.frame(md) || !nrow(md)) stop("Object has no meta.data rows; cannot import VDJ.")
    cells <- rownames(md) %||% colnames(sobj) %||% character(0)
    cells <- as.character(cells %||% character(0))
    if (!length(cells)) stop("Object has no cell names; cannot import VDJ.")
    cell_norm <- .rds_vdj_norm_bc(cells)
    cell_lookup <- setNames(cells, cell_norm)
    parsed <- list()
    matched_cell_blocks <- list()
    for (i in seq_len(nrow(relink_df))) {
      p <- as.character(relink_df$source_path[[i]] %||% "")
      if (!nzchar(p) || !file.exists(p)) next
      df <- tryCatch(.rds_vdj_read_df(p), error = function(e) NULL)
      if (is.null(df) || !is.data.frame(df) || !nrow(df)) next
      nms <- colnames(df)
      bc_col <- .rds_vdj_pick_col(nms, c("barcode", "cell", "cell_id", "barcodes", "bc", "cell_barcode", "barcode_id"))
      clone_col <- .rds_vdj_pick_col(nms, c("raw_clonotype_id", "clonotype_id", "clone_id", "cdr3", "cdr3s_aa", "cdr3_aa"))
      chain_col <- .rds_vdj_pick_col(nms, c("chain", "locus", "v_gene", "gene"))
      if (is.na(bc_col) || !nzchar(bc_col) || is.na(clone_col) || !nzchar(clone_col)) next
      bc <- as.character(df[[bc_col]] %||% "")
      cl <- as.character(df[[clone_col]] %||% "")
      use <- nzchar(bc) & nzchar(cl) & !is.na(bc) & !is.na(cl)
      if (!any(use)) next
      bc <- bc[use]
      cl <- cl[use]
      if (!is.na(chain_col) && nzchar(chain_col)) {
        ch <- .rds_vdj_classify_chain(df[[chain_col]][use])
      } else {
        fallback <- as.character(relink_df$expected_chain[[i]] %||% .rds_vdj_infer_chain(file_name = as.character(relink_df$source_name[[i]] %||% basename(p)), file_path = p))
        ch <- .rds_vdj_classify_chain(rep(fallback, length(bc)), fallback = fallback)
      }
      keep_ch <- ch %in% c("TCR", "BCR")
      if (!any(keep_ch)) next
      bc <- bc[keep_ch]
      cl <- cl[keep_ch]
      ch <- ch[keep_ch]
      mapped <- cell_lookup[.rds_vdj_norm_bc(bc)]
      mapped <- as.character(mapped %||% "")
      keep_map <- nzchar(mapped) & !is.na(mapped)
      mapped_keep <- mapped[keep_map]
      if (length(mapped_keep)) {
        matched_cell_blocks[[length(matched_cell_blocks) + 1L]] <- unique(as.character(mapped_keep))
      }
      if (!any(keep_map)) next
      parsed[[length(parsed) + 1L]] <- data.frame(
        cell = mapped_keep,
        chain = ch[keep_map],
        clone = cl[keep_map],
        sample = as.character(entry$obj@project.name %||% ""),
        source_file = as.character(relink_df$source_name[[i]] %||% basename(p)),
        source_path = p,
        stringsAsFactors = FALSE
      )
    }
    if (!length(parsed)) stop("Uploaded file(s) produced zero usable VDJ rows for this object.")
    d <- do.call(rbind, parsed)
    if (!nrow(d)) stop("Uploaded file(s) produced zero usable VDJ rows for this object.")
    # Keep dominant clone per cell+chain.
    key <- paste(d$cell, d$chain, sep = "::")
    keep <- !duplicated(key)
    d <- d[keep, , drop = FALSE]
    tcr_sizes <- table(d$clone[d$chain == "TCR"])
    bcr_sizes <- table(d$clone[d$chain == "BCR"])
    md$vdj_tcr_pos <- FALSE
    md$vdj_bcr_pos <- FALSE
    md$vdj_tcr_clone <- "unknown"
    md$vdj_bcr_clone <- "unknown"
    md$vdj_tcr_clone_size <- 0L
    md$vdj_bcr_clone_size <- 0L
    md$vdj_barcode_match_status <- "unknown"
    matched_cells <- unique(unlist(matched_cell_blocks, use.names = FALSE))
    matched_cells <- matched_cells[nzchar(matched_cells)]
    if (length(matched_cells)) {
      m_idx <- match(matched_cells, rownames(md))
      m_idx <- m_idx[!is.na(m_idx)]
      if (length(m_idx)) {
        md$vdj_barcode_match_status[m_idx] <- "matched"
        md$vdj_tcr_clone[m_idx] <- "0"
        md$vdj_bcr_clone[m_idx] <- "0"
      }
    }
    tcr_added <- 0L
    bcr_added <- 0L
    if (any(d$chain == "TCR")) {
      t <- d[d$chain == "TCR", , drop = FALSE]
      idx <- match(t$cell, rownames(md))
      idx <- idx[!is.na(idx)]
      md$vdj_tcr_pos[idx] <- TRUE
      md$vdj_tcr_clone[idx] <- t$clone[match(rownames(md)[idx], t$cell)]
      md$vdj_tcr_clone_size[idx] <- as.integer(tcr_sizes[md$vdj_tcr_clone[idx]] %||% 1)
      tcr_added <- sum(md$vdj_tcr_pos, na.rm = TRUE)
    }
    if (any(d$chain == "BCR")) {
      b <- d[d$chain == "BCR", , drop = FALSE]
      idx <- match(b$cell, rownames(md))
      idx <- idx[!is.na(idx)]
      md$vdj_bcr_pos[idx] <- TRUE
      md$vdj_bcr_clone[idx] <- b$clone[match(rownames(md)[idx], b$cell)]
      md$vdj_bcr_clone_size[idx] <- as.integer(bcr_sizes[md$vdj_bcr_clone[idx]] %||% 1)
      bcr_added <- sum(md$vdj_bcr_pos, na.rm = TRUE)
    }
    expected_chains <- unique(toupper(as.character(relink_df$expected_chain %||% character(0))))
    expected_chains <- expected_chains[expected_chains %in% c("TCR", "BCR")]
    if ("TCR" %in% expected_chains && tcr_added <= 0L) {
      stop("TCR was selected/matched, but zero TCR cells were imported into this object.")
    }
    if ("BCR" %in% expected_chains && bcr_added <= 0L) {
      stop("BCR was selected/matched, but zero BCR cells were imported into this object.")
    }
    sobj@meta.data <- md
    payload <- entry$vdj_payload
    if (!is.list(payload)) payload <- list()
    payload$records <- data.frame(
      barcode = as.character(d$cell),
      chain = as.character(d$chain),
      clone = as.character(d$clone),
      sample = as.character(d$sample),
      source_file = as.character(d$source_file),
      stringsAsFactors = FALSE
    )
    payload$n_rows <- nrow(payload$records)
    payload$source_tag <- "rds_relink_apply"
    payload$imported_at <- Sys.time()
    payload$last_import_diag <- list(
      total_rows = nrow(d),
      tcr_cells_added = as.integer(tcr_added),
      bcr_cells_added = as.integer(bcr_added),
      expected_chains = expected_chains
    )
    entry$obj <- sobj
    entry$vdj_payload <- payload
    entry
  }
  .rds_vdj_uploaded_df <- function() {
    up <- rds_vdj_relink_uploaded()
    if (!is.data.frame(up) || !nrow(up)) return(data.frame(name = character(0), datapath = character(0), stringsAsFactors = FALSE))
    if (!all(c("name", "datapath") %in% names(up))) return(data.frame(name = character(0), datapath = character(0), stringsAsFactors = FALSE))
    out <- up[, c("name", "datapath"), drop = FALSE]
    out$name <- as.character(out$name %||% "")
    out$datapath <- as.character(out$datapath %||% "")
    out <- out[nzchar(out$name) & nzchar(out$datapath), , drop = FALSE]
    if (!nrow(out)) return(out)
    # Keep insertion order while removing exact duplicates of (name + datapath).
    key <- paste0(out$name, "::", out$datapath)
    out[!duplicated(key), , drop = FALSE]
  }

  .collect_missing_vdj_sources <- function(registry) {
    .norm_src <- function(x) tolower(gsub("\\\\", "/", as.character(x %||% "")))
    .chain_from_source <- function(source_raw, chain_hint = "") {
      ch <- toupper(as.character(chain_hint %||% ""))
      if (ch %in% c("TCR", "BCR")) return(ch)
      s <- tolower(as.character(source_raw %||% ""))
      if (grepl("(^|/)(vdj_t|vdj_t_gd)(/|$)|(^|[^a-z])tcr([^a-z]|$)|tra|trb|trg|trd", s, perl = TRUE)) return("TCR")
      if (grepl("(^|/)(vdj_b)(/|$)|(^|[^a-z])bcr([^a-z]|$)|igh|igk|igl", s, perl = TRUE)) return("BCR")
      "Unknown"
    }
    reg <- registry %||% list()
    if (!is.list(reg) || !length(reg)) return(list())
    names_reg <- names(reg)
    if (!length(names_reg)) return(list())

    out <- list()
    for (nm in names_reg) {
      entry <- reg[[nm]]
      if (!is.list(entry)) next
      linked <- tryCatch(entry$meta$linked_files$vdj, error = function(e) NULL)
      if (!is.data.frame(linked) || !nrow(linked)) next
      src_col <- if ("source_name" %in% names(linked)) "source_name" else if ("path" %in% names(linked)) "path" else ""
      if (!nzchar(src_col)) next
      expected_raw <- as.character(linked[[src_col]] %||% character(0))
      expected_raw <- expected_raw[!is.na(expected_raw) & nzchar(expected_raw)]
      if (!length(expected_raw)) next
      expected_name <- basename(expected_raw)
      ch_hint <- if ("chain" %in% names(linked)) as.character(linked$chain %||% character(0)) else rep("", length(expected_raw))
      if (length(ch_hint) < length(expected_raw)) ch_hint <- c(ch_hint, rep("", length(expected_raw) - length(ch_hint)))
      expected_df <- data.frame(
        expected_key = as.character(.norm_src(expected_raw)),
        expected_name = as.character(expected_name),
        expected_source = as.character(expected_raw),
        expected_chain = as.character(vapply(seq_along(expected_raw), function(ii) .chain_from_source(expected_raw[[ii]], ch_hint[[ii]]), character(1))),
        stringsAsFactors = FALSE
      )
      expected_df <- expected_df[nzchar(as.character(expected_df$expected_name %||% "")), , drop = FALSE]
      if (!nrow(expected_df)) next

      payload <- tryCatch(entry$vdj_payload, error = function(e) NULL)
      has_payload_records <- is.list(payload) && is.data.frame(payload$records) && nrow(payload$records) > 0
      loaded <- as.character(payload$source_file %||% character(0))
      loaded <- loaded[!is.na(loaded) & nzchar(loaded)]
      loaded_name <- basename(loaded)
      resolved <- as.character(payload$resolved_expected_sources %||% character(0))
      resolved <- resolved[!is.na(resolved) & nzchar(resolved)]
      lost <- as.character(payload$missing_sources_lost %||% character(0))
      lost <- lost[!is.na(lost) & nzchar(lost)]
      empty_ok <- as.character(payload$missing_sources_empty_ok %||% character(0))
      empty_ok <- empty_ok[!is.na(empty_ok) & nzchar(empty_ok)]
      resolved_name <- basename(.norm_src(resolved))
      lost_name <- basename(.norm_src(lost))
      empty_name <- basename(.norm_src(empty_ok))

      sobj <- if (is.list(entry) && !is.null(entry$obj) && inherits(entry$obj, "Seurat")) entry$obj else NULL
      md <- tryCatch(if (!is.null(sobj)) sobj@meta.data else NULL, error = function(e) NULL)
      has_vdj_cols <- is.data.frame(md) && nrow(md) && all(c("vdj_tcr_pos", "vdj_bcr_pos", "vdj_tcr_clone", "vdj_bcr_clone", "vdj_tcr_clone_size", "vdj_bcr_clone_size") %in% colnames(md))
      if (isTRUE(has_vdj_cols)) next
      expected_name <- as.character(expected_df$expected_name %||% character(0))
      expected_key <- basename(.norm_src(expected_name))
      is_loaded <- expected_name %in% loaded_name
      is_resolved <- expected_key %in% resolved_name
      is_lost <- expected_key %in% lost_name
      is_empty_ok <- expected_key %in% empty_name
      # Guard alignment: link-only state is not sufficient.
      # If object has no real VDJ metadata columns and no payload records, any
      # non-lost/non-empty expected VDJ source must remain missing.
      if (!isTRUE(has_vdj_cols) && !isTRUE(has_payload_records)) {
        is_loaded <- rep(FALSE, length(is_loaded))
      }
      miss_idx <- which(!is_loaded & !is_resolved & !is_lost & !is_empty_ok)
      miss_idx <- miss_idx[!is.na(miss_idx) & miss_idx >= 1L & miss_idx <= nrow(expected_df)]
      if (!length(miss_idx)) next
      miss_df <- expected_df[miss_idx, c("expected_key", "expected_name", "expected_source", "expected_chain"), drop = FALSE]
      dedup_key <- paste0(
        ifelse(is.na(miss_df$expected_chain), "Unknown", as.character(miss_df$expected_chain)),
        "::",
        ifelse(is.na(miss_df$expected_key), "", as.character(miss_df$expected_key))
      )
      miss_df <- miss_df[!duplicated(dedup_key), , drop = FALSE]
      keep_idx <- !is.na(miss_df$expected_key) & nzchar(as.character(miss_df$expected_key))
      miss_df <- miss_df[keep_idx, , drop = FALSE]
      if (!nrow(miss_df)) next
      rownames(miss_df) <- NULL
      out[[nm]] <- miss_df
    }
    out
  }
  .rds_object_has_vdj_ready_state <- function(entry) {
    if (!is.list(entry)) return(FALSE)
    sobj <- if (!is.null(entry$obj) && inherits(entry$obj, "Seurat")) entry$obj else NULL
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(FALSE)
    md <- tryCatch(sobj@meta.data, error = function(e) NULL)
    has_vdj_cols <- is.data.frame(md) && nrow(md) && all(c("vdj_tcr_pos", "vdj_bcr_pos", "vdj_tcr_clone", "vdj_bcr_clone", "vdj_tcr_clone_size", "vdj_bcr_clone_size") %in% colnames(md))
    linked <- tryCatch(entry$meta$linked_files$vdj, error = function(e) NULL)
    has_link_rows <- is.data.frame(linked) && nrow(linked) > 0
    payload <- tryCatch(entry$vdj_payload, error = function(e) NULL)
    has_payload_records <- is.list(payload) && is.data.frame(payload$records) && nrow(payload$records) > 0
    isTRUE(has_vdj_cols || (has_link_rows && has_payload_records))
  }
  .rds_vdj_no_payload_key <- function(nm) {
    paste0("__no_vdj_payload__::", tolower(as.character(nm %||% "")))
  }
  .rds_expand_missing_rows <- function(miss_df) {
    if (!is.data.frame(miss_df) || !nrow(miss_df)) return(miss_df)
    out <- list()
    jj <- 0L
    for (i in seq_len(nrow(miss_df))) {
      rr <- miss_df[i, , drop = FALSE]
      ek <- as.character(rr$expected_key[[1]] %||% "")
      ch <- as.character(rr$expected_chain[[1]] %||% "")
      if (identical(ch, "Unknown") || (startsWith(ek, "__no_vdj_payload__::") && identical(ch, "TCR/BCR"))) {
        for (ch2 in c("TCR", "BCR")) {
          jj <- jj + 1L
          rr2 <- rr
          rr2$expected_chain <- ch2
          rr2$expected_name <- paste0(as.character(rr$expected_name[[1]] %||% "Missing expected VDJ source"), " [", ch2, "]")
          out[[jj]] <- rr2
        }
      } else {
        jj <- jj + 1L
        out[[jj]] <- rr
      }
    }
    out_df <- do.call(rbind, out)
    rownames(out_df) <- NULL
    out_df
  }
  .rds_collect_vdj_gate_map <- function(registry) {
    # Strict-but-accurate guard:
    # only flag objects that explicitly declare expected VDJ sources and still
    # have unresolved entries. Do not flag samples that never had VDJ.
    .collect_missing_vdj_sources(registry)
  }
  
  # --- Import handler ---
  observeEvent(input$import_rds_file, {
    file <- input$import_rds_file; req(file)
    
    .show_overlay(RDS_UI_TEXT$ui_text_overlay_reading_rds_file)
    on.exit(.hide_overlay(), add = TRUE)
    
    showNotification(RDS_UI_TEXT$ui_text_reading_inspecting_rds, type = "message", id = "rds_import_note")
    on.exit(removeNotification("rds_import_note"), add = TRUE)
    
    ok <- TRUE
    obj <- tryCatch(readRDS(file$datapath), error = function(e){ ok <<- FALSE; NULL })
    if (!ok) {
      showNotification(RDS_UI_TEXT$ui_text_error_file_not_read_as_rds, type = "error")
      return()
    }
    
    # Case A: bundled workspace
    if (is.list(obj) && "app_version" %in% names(obj)) {
      pinfo <- obj$pipeline_info %||% list()
      pkgs  <- pinfo$package_versions %||% obj$package_versions %||% c()
      seurat_bundle_ver <- .scalar_chr(pinfo$seurat_version %||% NA_character_, default = NA_character_)
      if (is.na(seurat_bundle_ver) || !nzchar(seurat_bundle_ver)) {
        seurat_bundle_ver <- .pkg_version_lookup(pkgs, "Seurat")
      }
      rds_bundle_info(list(
        pipeline_version = pinfo$pipeline_version %||% obj$app_version %||% NA_character_,
        analysis_date = pinfo$analysis_date %||% pinfo$exported_at %||% obj$exported_at %||% NA_character_,
        exported_at = pinfo$exported_at %||% obj$exported_at %||% NA_character_,
        seurat_version = seurat_bundle_ver %||% NA_character_,
        active_environment = pinfo$active_environment %||% NA_character_,
        package_versions = pkgs
      ))
      imported_list <- obj$all_seurat_objects %||% NULL
      if ((is.null(imported_list) || !length(imported_list)) && is.list(obj$filtered_objects)) {
        imported_list <- obj$filtered_objects
      }
      if (is.list(imported_list) && length(imported_list) &&
          length(.normalize_imported_list(imported_list)) < length(imported_list)) {
        extra_entries <- .scan_for_seurat(imported_list, base = "bundle$all_seurat_objects")
        if (length(extra_entries)) {
          extra_names <- make.unique(vapply(extra_entries, function(e) .safe_import_name(e$name, "Imported"), character(1)))
          extra_list <- setNames(lapply(extra_entries, function(e) e$entry %||% e$obj), extra_names)
          imported_list <- c(imported_list, extra_list)
        }
      }
      imported_params <- obj$analysis_params_by_page %||% list()
      imported_session_info <- obj$session_info %||% character(0)
      imported_active_object_name <- .extract_bundle_active_object_name(obj)
      imported_tabular <- .normalize_tabular_imports(obj$imported_tabular_files %||% data.frame())
      imported_annotation_layers <- .normalize_annotation_layers_import(obj$annotation_layers %||% list())
      imported_active_annotation_layer <- .normalize_active_annotation_layer_import(obj$active_annotation_layer %||% list())
      .prepare_review(
        imported_list,
        imported_params = imported_params,
        imported_session_info = imported_session_info,
        imported_tabular_files = imported_tabular,
        imported_active_object_name = imported_active_object_name,
        imported_annotation_layers = imported_annotation_layers,
        imported_active_annotation_layer = imported_active_annotation_layer
      )
      return()
    }
    
    rds_bundle_info(NULL)
    
    # Case B: list of Seurat
    if (is.list(obj) && length(obj) > 0 && all(vapply(obj, .is_seurat, logical(1)))) {
      .prepare_review(obj, imported_params = list(), imported_session_info = character(0)); return()
    }
    
    # Case C: single Seurat
    if (.is_seurat(obj)) { .prepare_review(list(Imported = obj), imported_params = list(), imported_session_info = character(0)); return() }
    
    # Case D: unknown → scan
    showNotification(RDS_UI_TEXT$ui_text_scanning_for_seurat, id = "rds_scan", type = "message")
    on.exit(removeNotification("rds_scan"), add = TRUE)
    entries <- .scan_for_seurat(obj, base = "root")
    if (length(entries) == 0) {
      showNotification(RDS_UI_TEXT$ui_text_error_no_seurat_objects_found, type = "error")
      return()
    }
    if (isTRUE(attr(entries, "truncated")))
      showNotification(RDS_UI_TEXT$ui_text_warning_scan_partial_results, type = "warning")
    
    if (length(entries) == 1) {
      nm <- .safe_import_name(entries[[1]]$name, "Imported_1")
      .prepare_review(setNames(list(entries[[1]]$entry %||% entries[[1]]$obj), nm), imported_params = list(), imported_session_info = character(0))
      return()
    }
    
    # Multiple → selective import
    df <- do.call(rbind, lapply(entries, function(e){
      s <- .summarize_seurat(e$obj)
      data.frame(
        path = e$path,
        name = e$name,
        assays = paste(unique(s$assay_table$assay), collapse = ","),
        reductions = paste(s$reductions, collapse = ","),
        cells = s$n_cells,
        features = if (nrow(s$assay_table)) max(s$assay_table$n_features, na.rm = TRUE) else NA_integer_,
        stage = s$stage
      )
    }))
    rds_selective_candidates(list(entries = entries, table = df))
    showModal(modalDialog(
      title = RDS_UI_TEXT$ui_text_selective_import,
      p(RDS_UI_TEXT$ui_text_multiple_seurat_objects_found_select_which),
      DT::dataTableOutput("rds_selective_dt"),
      footer = tagList(
        modalButton(RDS_UI_TEXT$ui_button_cancel),
        actionButton("rds_selective_import_btn", RDS_UI_TEXT$ui_btn_import_selected, class = "btn-primary")
      ),
      size = "l", easyClose = TRUE
    ))
  })
  
  output$rds_selective_dt <- DT::renderDataTable({
    cand <- rds_selective_candidates(); if (is.null(cand)) return(NULL)
    DT::datatable(cand$table, selection = "multiple",
                  options = list(paging = FALSE, dom = "t", autoWidth = TRUE, scrollX = TRUE))
  }, server = FALSE)
  
  observeEvent(input$rds_selective_import_btn, {
    cand <- rds_selective_candidates(); req(cand)
    sel <- input$rds_selective_dt_rows_selected
    if (length(sel) == 0) {
      showNotification(RDS_UI_TEXT$ui_text_select_at_least_one, type = "warning")
      return()
    }
    chosen <- cand$entries[sel]
    names_vec <- make.unique(vapply(chosen, function(e) .safe_import_name(e$name, "Imported"), character(1)))
    .prepare_review(setNames(lapply(chosen, function(e) e$entry %||% e$obj), names_vec), imported_params = list(), imported_session_info = character(0))
    removeModal()
  })
  
  # ====== Build Review & Configure UI ======
  .prepare_review <- function(imported_list,
                              imported_params = list(),
                              imported_session_info = character(0),
                              imported_tabular_files = data.frame(),
                              imported_active_object_name = "",
                              imported_annotation_layers = list(),
                              imported_active_annotation_layer = list()) {
    normalized <- .normalize_imported_list(imported_list)
    migrated_bundle <- .migrate_legacy_vdj_tabular_to_object_links(
      objs = normalized,
      imported_tabular_files = imported_tabular_files %||% data.frame()
    )
    normalized <- migrated_bundle$objs %||% normalized
    imported_tabular_files <- migrated_bundle$tabular %||% imported_tabular_files
    if (length(normalized) == 0) {
      showNotification(RDS_UI_TEXT$ui_text_error_no_seurat_objects_import, type = "error")
      return()
    }
    
    nm <- names(normalized)
    meta <- lapply(nm, function(n) {
      sobj <- normalized[[n]]$obj
      smry <- .summarize_seurat(sobj)
      at   <- smry$assay_table
      
      assays <- unique(at$assay)
      # default to "bundle" when present, then "RNA", else first assay
      def_assay <- if ("bundle" %in% assays) {
        "bundle"
      } else if ("RNA" %in% assays) {
        "RNA"
      } else {
        assays[1] %||% NA_character_
      }
      
      slot_flags <- c(
        counts     = any(at$slot_counts),
        data       = any(at$slot_data),
        scale.data = any(at$slot_scale)
      )
      slot_opts <- names(slot_flags)[slot_flags]
      def_slot <- if ("data" %in% slot_opts) {
        "data"
      } else if ("counts" %in% slot_opts) {
        "counts"
      } else if ("scale.data" %in% slot_opts) {
        "scale.data"
      } else {
        NA_character_
      }
      
      list(
        summary = smry,
        defaults = list(
          assay = def_assay,
          slot  = def_slot,
          ident = smry$ident_guess %||% NA_character_
        )
      )
    })
    names(meta) <- nm

    imported_active_object_name <- .resolve_rds_import_active_object_name(
      object_names = nm,
      focus = NULL,
      imported_active_name = imported_active_object_name,
      registry = normalized
    )

    if (nzchar(imported_active_object_name)) {
      rds_default_focus(list(
        object = imported_active_object_name,
        assay = meta[[imported_active_object_name]]$defaults$assay %||% NA_character_
      ))
    } else {
      rds_default_focus(NULL)
    }
    
    rds_pending(list(
      objs = normalized,
      meta = meta,
      analysis_params_by_page = imported_params %||% list(),
      session_info = imported_session_info %||% character(0),
      imported_tabular_files = .normalize_tabular_imports(imported_tabular_files),
      imported_active_object_name = imported_active_object_name,
      annotation_layers = .normalize_annotation_layers_import(imported_annotation_layers),
      active_annotation_layer = .normalize_active_annotation_layer_import(imported_active_annotation_layer)
    ))
    shinyjs::show("rds_review_card")
    .render_review_table()
    .render_config_panels()
  }
  
  .render_review_table <- function() {
    pend <- rds_pending()
    if (is.null(pend)) {
      empty_df <- .empty_rds_review_table_df()
      rds_review_df(empty_df)
      output$rds_review_table <- DT::renderDataTable({
        DT::datatable(
          empty_df,
          rownames = FALSE,
          class = "rds-review-dt",
          selection = "none",
          options = list(
            paging = FALSE,
            dom = "t",
            autoWidth = FALSE,
            scrollX = TRUE,
            ordering = FALSE,
            searching = FALSE,
            info = FALSE
          )
        )
      }, server = FALSE)
      return()
    }
    nm <- names(pend$objs)
    
    df_list <- lapply(nm, function(n) {
      sm <- pend$meta[[n]]$summary
      at <- sm$assay_table
      if (!nrow(at)) {
        data.frame(
          object = n,
          cell_count = sm$n_cells,
          assay = NA_character_,
          n_features = NA_integer_,
          total_counts = NA_real_,
          median_counts_per_cell = NA_real_,
          reductions = paste(sm$reductions, collapse=","),
          stage = sm$stage,
          samples = paste(sm$sample_names, collapse="; "),
          meta_cols = sm$meta_ncols,
          cluster_res = if (length(sm$resolutions)) paste(sm$resolutions, collapse = ",") else "",
          stringsAsFactors = FALSE
        )
      } else {
        cbind(
          object = n,
          cell_count = sm$n_cells,
          .safe_select_cols(
            at,
            c("assay",
              "n_features","total_counts","median_counts_per_cell"),
            default = NA
          ),
          reductions = paste(sm$reductions, collapse=","),
          stage = sm$stage,
          samples = paste(sm$sample_names, collapse="; "),
          meta_cols = sm$meta_ncols,
          cluster_res = if (length(sm$resolutions)) paste(sm$resolutions, collapse = ",") else "",
          stringsAsFactors = FALSE
        )
      }
    })
    df <- do.call(rbind, df_list)
    rds_review_df(df)
    rds_review_prev_sel(integer(0))
    
    output$rds_review_table <- DT::renderDataTable({
      DT::datatable(
        df,
        rownames = FALSE,
        class = "rds-review-dt",
        selection = "multiple",
        options = list(
          paging = FALSE,
          dom = "t",
          autoWidth = FALSE,
          scrollX = TRUE,
          initComplete = DT::JS(
            "function() {",
            "  var api = this.api();",
            "  var $ths = $(api.table().header()).find('th');",
            "  $ths.each(function(){",
            "    var $th = $(this);",
            "    if ($th.data('rdsUnderscoreWbr') === 1) return;",
            "    var txt = $.trim($th.text() || '');",
            "    if (!txt) return;",
            "    $th.html(txt.replace(/_/g, '_<wbr>'));",
            "    $th.data('rdsUnderscoreWbr', 1);",
            "  });",
            "  setTimeout(function(){ api.columns.adjust(); }, 0);",
            "}"
          ),
          columnDefs = list(
            list(targets = 0, className = "dt-body-nowrap rds-object-strong"),
            list(targets = 1, className = "dt-body-nowrap dt-body-center rds-num-nowrap rds-cell-count-strong"),
            list(targets = 2, width = "72px", className = "dt-body-nowrap rds-assay-nowrap"),
            list(targets = "_all", className = "dt-body-nowrap"),
            list(targets = c(1, 3, 4, 5, 9), className = "dt-body-nowrap dt-body-center rds-num-nowrap"),
            list(
              targets = 7,
              className = "dt-body-nowrap rds-delim-wrap",
              render = DT::JS(
                "function(data, type, row, meta){",
                "  if (type !== 'display' || data == null) return data;",
                "  var txt = $('<div/>').text(String(data)).html();",
                "  return txt.replace(/([_,])/g, '$1<wbr>');",
                "}"
              )
            ),
            list(
              targets = 5,
              className = "dt-body-nowrap rds-delim-wrap",
              render = DT::JS(
                "function(data, type, row, meta){",
                "  if (type !== 'display' || data == null) return data;",
                "  var txt = $('<div/>').text(String(data)).html();",
                "  return txt.replace(/,/g, ',<wbr>');",
                "}"
              )
            ),
            list(
              targets = 10,
              className = "rds-res-wrap",
              render = DT::JS(
                "function(data, type, row, meta){",
                "  if (type !== 'display' || data == null) return data;",
                "  var txt = $('<div/>').text(String(data)).html();",
                "  txt = txt.replace(/,/g, ',<wbr>');",
                "  return '<div class=\"rds-res-container\" style=\"white-space: normal !important; word-break: normal; overflow-wrap: normal;\">' + txt + '</div>';",
                "}"
              )
            ),
            list(
              targets = 8,
              className = "dt-body-nowrap rds-delim-wrap",
              createdCell = DT::JS(
                "function(td, cellData, rowData, row, col){",
                "  var txt = $('<div/>').text(String(cellData == null ? '' : cellData)).html();",
                "  txt = txt.replace(/\\s*;\\s*/g, ';<br>');",
                "  txt = txt.replace(/([_,])/g, '$1<wbr>');",
                "  $(td).html(txt);",
                "}"
              )
            )
          )
        ),
        escape = FALSE
      )
    }, server = FALSE)
  }
  
  # Summary DT row selection/grouping state
  rds_review_autoselecting <- reactiveVal(FALSE)
  rds_review_prev_sel <- reactiveVal(integer(0))
  
  .rds_norm_group_id <- function(x) {
    y <- tolower(trimws(as.character(x %||% "")))
    y[!is.na(y) & nzchar(y)]
  }

  # Shared object-group selection state machine.
  observeEvent(input$rds_review_table_rows_selected, {
    if (isTRUE(rds_review_autoselecting())) {
      rds_review_autoselecting(FALSE)
      rds_review_prev_sel(as.integer(input$rds_review_table_rows_selected %||% integer(0)))
      return()
    }
    
    sel <- as.integer(input$rds_review_table_rows_selected %||% integer(0))
    sel <- sel[is.finite(sel)]
    df <- rds_review_df()
    if (is.null(df) || !nrow(df)) {
      rds_review_prev_sel(integer(0))
      return()
    }
    if (!length(sel)) {
      rds_review_prev_sel(integer(0))
      return()
    }
    sel <- sel[sel >= 1 & sel <= nrow(df)]
    if (!length(sel)) {
      rds_review_prev_sel(integer(0))
      return()
    }
    
    group_id <- .rds_norm_group_id(df$object)
    prev <- as.integer(rds_review_prev_sel() %||% integer(0))
    prev <- prev[is.finite(prev) & prev >= 1 & prev <= nrow(df)]
    
    changed_groups <- unique(c(group_id[prev], group_id[sel]))
    changed_groups <- changed_groups[nzchar(changed_groups)]
    target_groups <- unique(group_id[prev])
    target_groups <- target_groups[nzchar(target_groups)]
    
    for (g in changed_groups) {
      idx_g <- which(group_id == g)
      n_g <- length(idx_g)
      if (!n_g) next
      prev_n <- sum(prev %in% idx_g)
      new_n  <- sum(sel %in% idx_g)
      
      if (prev_n == 0L && new_n > 0L) {
        # unselected -> any click means select whole group
        target_groups <- unique(c(target_groups, g))
      } else if (prev_n == n_g && new_n < n_g) {
        # fully selected -> any deselect inside group means unselect whole group
        target_groups <- setdiff(target_groups, g)
      } else if (new_n == n_g) {
        target_groups <- unique(c(target_groups, g))
      } else if (new_n == 0L) {
        target_groups <- setdiff(target_groups, g)
      } else {
        # partial/ambiguous: choose direction by delta
        if (new_n >= prev_n) {
          target_groups <- unique(c(target_groups, g))
        } else {
          target_groups <- setdiff(target_groups, g)
        }
      }
    }
    
    expanded <- which(group_id %in% target_groups)
    
    # Keep default object/assay focus from the user's current selection intent.
    focus_idx <- sel[[1]]
    if (is.finite(focus_idx) && focus_idx >= 1 && focus_idx <= nrow(df)) {
      row <- df[focus_idx, , drop = FALSE]
      obj <- as.character(row$object %||% "")
      assay <- as.character(row$assay %||% "")
      if (nzchar(obj) && nzchar(assay)) {
        pend <- rds_pending()
        if (!is.null(pend) && (obj %in% names(pend$meta))) {
          rds_default_focus(list(object = obj, assay = assay))
          cfg_id <- paste0("cfg_", obj, "_assay")
          try(updateSelectInput(session, cfg_id, selected = assay), silent = TRUE)
        }
      }
    }
    
    if (!setequal(sel, expanded)) {
      rds_review_autoselecting(TRUE)
      proxy <- DT::dataTableProxy("rds_review_table", session = session)
      if (length(expanded)) {
        suppressWarnings(try(DT::selectRows(proxy, expanded), silent = TRUE))
      } else {
        suppressWarnings(try(DT::selectRows(proxy, NULL), silent = TRUE))
      }
      rds_review_prev_sel(as.integer(expanded))
      return()
    }
    
    rds_review_prev_sel(as.integer(sel))
  })
  
  .render_config_panels <- function() {
    pend <- rds_pending()
    if (is.null(pend)) {
      output$rds_config_panels_placeholder <- shiny::renderUI(NULL)
      return()
    }
    nm <- names(pend$objs)
    ui_list <- lapply(nm, function(n) {
      sm   <- pend$meta[[n]]$summary
      defs <- pend$meta[[n]]$defaults
      assay_choices <- unique(sm$assay_table$assay)
      slot_choices  <- c("counts","data","scale.data")[c(any(sm$assay_table$slot_counts),
                                                         any(sm$assay_table$slot_data),
                                                         any(sm$assay_table$slot_scale))]
      md_cols <- sm$md_cols
      
      wellPanel(
        h5(n),
        div(class="cfg-help", RDS_UI_TEXT$ui_text_choose_defaults_used_analysis_plotting),
        selectInput(paste0("cfg_", n, "_assay"), RDS_UI_TEXT$ui_label_default_assay,
                    choices = assay_choices,
                    selected = defs$assay %||% assay_choices[1]),
        selectInput(paste0("cfg_", n, "_slot"),  RDS_UI_TEXT$ui_label_data_slot_for_plotting,
                    choices = slot_choices,
                    selected = defs$slot %||% slot_choices[1]),
        selectInput(paste0("cfg_", n, "_ident"), RDS_UI_TEXT$ui_label_identity_column_idents,
                    choices = c("", md_cols),
                    selected = defs$ident %||% ""),
        tags$hr(),
        h6(RDS_UI_TEXT$ui_title_samples),
        selectInput(paste0("cfg_", n, "_sample_col"), RDS_UI_TEXT$ui_label_meta_column_sample_names,
                    choices = md_cols, selected = sm$sample_guess, width = "420px"),
        div(class="cfg-help", paste0(RDS_UI_TEXT$ui_text_detected_samples,
                                     if (length(sm$sample_names)) paste(sm$sample_names, collapse = ", ") else "—")),
        tags$hr(),
        h6(RDS_UI_TEXT$ui_title_final_barcode_list_optional),
        selectInput(paste0("cfg_", n, "_barcode_col"),
                    RDS_UI_TEXT$ui_label_meta_column_barcode_keep_drop_flags,
                    choices = c("", sm$barcode_cols),
                    selected = "",
                    width = "420px"),
        div(class="cfg-help",
            RDS_UI_TEXT$ui_text_examples_columns_named_like_dbr_doublet)
      )
    })
    output$rds_config_panels_placeholder <- shiny::renderUI({ ui_list })
  }
  
  observeEvent(rds_pending(), {
    .render_review_table()
    .render_config_panels()
    pend <- rds_pending()
    if (is.null(pend) || is.null(pend$objs) || !length(pend$objs)) return(invisible(NULL))
    missing <- .rds_collect_vdj_gate_map(pend$objs)
    if (!length(missing)) return(invisible(NULL))
    sig_parts <- unlist(lapply(names(missing), function(nm) {
      mm <- missing[[nm]]
      ids <- if (is.data.frame(mm) && nrow(mm)) as.character(mm$expected_name %||% character(0)) else as.character(mm %||% character(0))
      paste0(nm, "::", paste(ids, collapse = "|"))
    }), use.names = FALSE)
    sig <- paste(sort(sig_parts), collapse = ";;")
    if (identical(sig, rds_missing_vdj_prompt_sig())) return(invisible(NULL))
    rds_missing_vdj_prompt_sig(sig)
    .show_rds_missing_vdj_modal <- function(missing_map, title_text = "RDS import requires VDJ relink", banner_text = "Loaded workspace contains unresolved VDJ sources. Relink/import these VDJ files before VDJ-dependent operations.") {
      details <- tagList(lapply(names(missing_map), function(nm) {
        jump_btn <- tags$button(
          type = "button",
          class = "btn btn-danger btn-sm",
          style = "margin: 0;",
          onclick = sprintf("Shiny.setInputValue('rds_vdj_relink_target', '%s', {priority:'event'});", gsub("'", "\\\\'", as.character(nm), fixed = TRUE)),
          paste0("Import/Relink for ", nm)
        )
        tags$div(
          class = "rds-vdj-missing-object-row",
          style = "display:flex; justify-content:space-between; align-items:flex-start; gap:16px; margin:10px 0 14px 0;",
          tags$div(
            style = "flex:1; min-width:0;",
            tags$b(nm),
            tags$ul(lapply(
              if (is.data.frame(missing_map[[nm]]) && nrow(missing_map[[nm]])) {
                paste0(as.character(missing_map[[nm]]$expected_name), " (", as.character(missing_map[[nm]]$expected_chain), ")")
              } else as.character(missing_map[[nm]]),
              tags$li
            ))
          ),
          tags$div(style = "flex:0 0 auto; padding-top:2px;", jump_btn)
        )
      }))
      showModal(modalDialog(
        title = title_text,
        div(class = "alert alert-danger", banner_text),
        {
          bad <- as.character(shared_data$vdj_detect_invalid_reasons %||% character(0))
          bad <- bad[nzchar(bad)]
          if (length(bad)) {
            div(
              class = "alert alert-warning",
              tags$b("Auto-detected VDJ file(s) were empty/invalid."),
              tags$div("Please relink valid files."),
              tags$details(
                tags$summary("Show detection issues"),
                tags$ul(lapply(head(unique(bad), 8), tags$li))
              )
            )
          }
        },
        tags$p(tags$b("Missing VDJ source files by object:")),
        details,
        footer = modalButton("OK"),
        easyClose = TRUE,
        size = "l"
      ))
    }
    .show_rds_missing_vdj_modal(missing)
  }, ignoreInit = TRUE)

  observeEvent(input$rds_vdj_relink_target, {
    nm <- as.character(input$rds_vdj_relink_target %||% "")
    if (!nzchar(nm)) return(invisible(NULL))
    rds_vdj_relink_target_obj(nm)
    rds_vdj_relink_uploaded(data.frame())
    removeModal()
    showModal(modalDialog(
      title = paste0("Relink VDJ files: ", nm),
      div(
        class = "rds-vdj-relink-root",
        tags$p("Upload candidate VDJ file(s), then match each missing expected filename."),
        tags$p(tags$small("Use 'There is no data for this slot' only if this expected slot truly has no data.")),
        tags$p(tags$small("If a sample truly has no VDJ clonotypes, use 'Mark matched cells as no VDJ detected'.")),
        fileInput("rds_vdj_relink_files", "Upload VDJ file(s) (.csv/.tsv)", multiple = TRUE, accept = c(".csv", ".tsv", ".txt")),
        uiOutput("rds_vdj_relink_match_ui")
      ),
      footer = tagList(
        actionButton("rds_vdj_relink_cancel_back", "Cancel", class = "btn btn-secondary"),
        actionButton("rds_vdj_relink_mark_empty", "Mark matched cells as no VDJ detected", class = "btn btn-info"),
        actionButton("rds_vdj_relink_skip_missing", "There is no data for this slot", class = "btn btn-warning"),
        actionButton("rds_vdj_relink_apply", "Confirm Relink", class = "btn btn-danger")
      ),
      easyClose = TRUE,
      size = "l"
    ))
  }, ignoreInit = TRUE)

  observeEvent(input$rds_vdj_relink_cancel_back, {
    removeModal()
    pend <- rds_pending()
    if (is.null(pend) || is.null(pend$objs) || !length(pend$objs)) return(invisible(NULL))
    missing <- .rds_collect_vdj_gate_map(pend$objs)
    if (!length(missing)) return(invisible(NULL))
    showModal(modalDialog(
      title = "RDS import requires VDJ relink",
      div(class = "alert alert-danger", "Loaded workspace contains unresolved VDJ sources. Relink/import these VDJ files before VDJ-dependent operations."),
      tags$p(tags$b("Missing VDJ source files by object:")),
      tagList(lapply(names(missing), function(nm) {
        jump_btn <- tags$button(
          type = "button",
          class = "btn btn-danger btn-sm",
          style = "margin: 0;",
          onclick = sprintf("Shiny.setInputValue('rds_vdj_relink_target', '%s', {priority:'event'});", gsub("'", "\\\\'", as.character(nm), fixed = TRUE)),
          paste0("Import/Relink for ", nm)
        )
        tags$div(
          class = "rds-vdj-missing-object-row",
          style = "display:flex; justify-content:space-between; align-items:flex-start; gap:16px; margin:10px 0 14px 0;",
          tags$div(
            style = "flex:1; min-width:0;",
            tags$b(nm),
            tags$ul(lapply(paste0(as.character(missing[[nm]]$expected_name), " (", as.character(missing[[nm]]$expected_chain), ")"), tags$li))
          ),
          tags$div(style = "flex:0 0 auto; padding-top:2px;", jump_btn)
        )
      })),
      footer = modalButton("OK"),
      easyClose = TRUE,
      size = "l"
    ))
  }, ignoreInit = TRUE)

  observeEvent(input$rds_vdj_relink_files, {
    up_new <- input$rds_vdj_relink_files
    if (!is.data.frame(up_new) || !nrow(up_new)) return(invisible(NULL))
    if (!all(c("name", "datapath") %in% names(up_new))) return(invisible(NULL))
    cur <- .rds_vdj_uploaded_df()
    add <- up_new[, c("name", "datapath"), drop = FALSE]
    add$name <- as.character(add$name %||% "")
    add$datapath <- as.character(add$datapath %||% "")
    add <- add[nzchar(add$name) & nzchar(add$datapath), , drop = FALSE]
    if (!nrow(add)) return(invisible(NULL))
    merged <- rbind(cur, add)
    key <- paste0(as.character(merged$name), "::", as.character(merged$datapath))
    merged <- merged[!duplicated(key), , drop = FALSE]
    rds_vdj_relink_uploaded(merged)
    showNotification(paste0("VDJ upload queue: ", nrow(merged), " file(s)."), type = "message", duration = 3)
  }, ignoreInit = TRUE)

  output$rds_vdj_relink_match_ui <- renderUI({
    nm <- rds_vdj_relink_target_obj() %||% ""
    req(nzchar(nm))
    pend <- rds_pending()
    req(!is.null(pend), !is.null(pend$objs))
    missing_map <- .rds_collect_vdj_gate_map(pend$objs)
    miss_df <- missing_map[[nm]]
    if (is.data.frame(miss_df) && nrow(miss_df)) miss_df <- .rds_expand_missing_rows(miss_df)
    miss <- if (is.data.frame(miss_df) && nrow(miss_df)) as.character(miss_df$expected_name %||% character(0)) else as.character(miss_df %||% character(0))
    if (!length(miss)) {
      return(div(class = "text-success", tags$b("No missing VDJ files remain for this object.")))
    }
    up <- .rds_vdj_uploaded_df()
    files <- if (is.data.frame(up) && nrow(up)) as.character(up$name %||% character(0)) else character(0)
    file_paths <- if (is.data.frame(up) && nrow(up)) as.character(up$datapath %||% character(0)) else character(0)
    keep_files <- nzchar(files) & nzchar(file_paths)
    files <- files[keep_files]
    file_paths <- file_paths[keep_files]
    file_ids <- if (length(files)) paste0("__file_", seq_along(files)) else character(0)
    file_meta <- if (length(files)) data.frame(
      file_id = file_ids,
      file_name = files,
      file_path = file_paths,
      stringsAsFactors = FALSE
    ) else data.frame(file_id = character(0), file_name = character(0), file_path = character(0), stringsAsFactors = FALSE)
    inferred_by_file <- if (nrow(file_meta)) {
      stats::setNames(vapply(seq_len(nrow(file_meta)), function(i) {
        .rds_vdj_infer_chain(file_name = file_meta$file_name[[i]], file_path = file_meta$file_path[[i]])
      }, character(1)), file_meta$file_id)
    } else setNames(character(0), character(0))
    entry <- pend$objs[[nm]]
    sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else NULL
    obj_cells <- if (!is.null(sobj) && inherits(sobj, "Seurat")) rownames(sobj@meta.data) %||% colnames(sobj) %||% character(0) else character(0)
    obj_cells_norm <- unique(.rds_vdj_norm_bc(obj_cells))

    choices <- c(
      "Keep missing (notify me later)" = "__keep_missing__",
      "No data for this slot (allow continue)" = "__no_data__"
    )
    if (nrow(file_meta)) {
      file_labels <- vapply(seq_len(nrow(file_meta)), function(i) {
        fid <- file_meta$file_id[[i]]
        fnm <- file_meta$file_name[[i]]
        ov <- .rds_vdj_barcode_overlap(file_meta$file_path[[i]], obj_cells_norm)
        paste0(
          "[", inferred_by_file[[fid]] %||% "Unknown", "] ",
          fnm,
          " | upload#", i,
          " | barcode overlap: ", ov$n_overlap, "/", ov$n_file, sprintf(" (%.1f%%)", ov$pct)
        )
      }, character(1))
      choices <- c(choices, stats::setNames(file_meta$file_id, file_labels))
    }
    summary_rows <- if (nrow(file_meta)) {
      do.call(rbind, lapply(seq_len(nrow(file_meta)), function(i) {
        fid <- file_meta$file_id[[i]]
        ov <- .rds_vdj_barcode_overlap(file_meta$file_path[[i]], obj_cells_norm)
        data.frame(
          upload_id = paste0("upload#", i),
          uploaded_file = file_meta$file_name[[i]],
          inferred_type = inferred_by_file[[fid]] %||% "Unknown",
          matched_barcodes = ov$n_overlap,
          file_barcodes = ov$n_file,
          overlap_pct = sprintf("%.1f%%", ov$pct),
          stringsAsFactors = FALSE
        )
      }))
    } else data.frame()

    rows <- lapply(seq_along(miss), function(i) {
      expected <- miss[[i]]
      expected_chain <- if (is.data.frame(miss_df) && nrow(miss_df)) as.character(miss_df$expected_chain[[i]] %||% .rds_vdj_infer_chain(file_name = expected)) else .rds_vdj_infer_chain(file_name = expected)
      expected_source <- if (is.data.frame(miss_df) && nrow(miss_df)) as.character(miss_df$expected_source[[i]] %||% expected) else expected
      sid <- paste0("rds_vdj_match_", i)
      cid <- paste0("rds_vdj_expected_chain_", i)
      selected <- "__keep_missing__"
      if (nrow(file_meta)) {
        chain_ids <- file_meta$file_id[vapply(file_meta$file_id, function(fid) identical(inferred_by_file[[fid]] %||% "Unknown", expected_chain), logical(1))]
        candidate_ids <- if (length(chain_ids)) chain_ids else file_meta$file_id
        best <- "__keep_missing__"
        best_score <- -1
        for (fid in candidate_ids) {
          row_i <- match(fid, file_meta$file_id)
          ov <- .rds_vdj_barcode_overlap(file_meta$file_path[[row_i]], obj_cells_norm)
          score <- ov$n_overlap
          if (score > best_score) {
            best_score <- score
            best <- fid
          }
        }
        if (!identical(best, "__keep_missing__")) selected <- best
      }
      fluidRow(
        column(6, tags$div(
          tags$b("Missing expected file:"),
          tags$code(expected),
          tags$div(tags$small(paste0("Expected type: ", expected_chain))),
          tags$div(tags$small(paste0("Expected source context: ", expected_source))),
          if (identical(expected_chain, "Unknown")) {
            selectInput(
              cid,
              "Specify expected type (required)",
              choices = c("Select type..." = "__unknown__", "TCR" = "TCR", "BCR" = "BCR"),
              selected = "__unknown__",
              width = "100%"
            )
          }
        )),
        column(6, div(class = "rds-vdj-relink-select", selectInput(sid, "Match to uploaded file", choices = choices, selected = selected, width = "100%")))
      )
    })
    tagList(
      if (is.data.frame(up) && nrow(up)) {
        tags$p(tags$small(paste0("Queued uploads: ", nrow(up), " file(s). You can click Browse again to add more files; previous uploads stay queued.")))
      },
      if (is.data.frame(summary_rows) && nrow(summary_rows)) {
        tagList(
          tags$p(tags$b("Barcode Matching Summary (auto-refreshes when you upload new files):")),
          div(class = "rds-vdj-summary-wrap", tableOutput("rds_vdj_barcode_summary_tbl")),
          uiOutput("rds_vdj_unmatched_examples_ui")
        )
      },
      tags$p(tags$b("Match each missing expected filename")),
      do.call(tagList, rows)
    )
  })

  output$rds_vdj_barcode_summary_tbl <- renderTable({
    nm <- rds_vdj_relink_target_obj() %||% ""
    req(nzchar(nm))
    up <- .rds_vdj_uploaded_df()
    req(is.data.frame(up), nrow(up) > 0)
    pend <- rds_pending()
    req(!is.null(pend), !is.null(pend$objs), !is.null(pend$objs[[nm]]))
    entry <- pend$objs[[nm]]
    sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else NULL
    req(!is.null(sobj), inherits(sobj, "Seurat"))
    obj_cells <- rownames(sobj@meta.data) %||% colnames(sobj) %||% character(0)
    obj_cells_norm <- unique(.rds_vdj_norm_bc(obj_cells))
    files <- as.character(up$name %||% character(0))
    paths <- as.character(up$datapath %||% character(0))
    keep <- nzchar(files) & nzchar(paths)
    files <- files[keep]
    paths <- paths[keep]
    if (!length(files)) return(data.frame())
    df <- do.call(rbind, lapply(seq_along(files), function(i) {
      ov <- .rds_vdj_barcode_overlap(paths[[i]], obj_cells_norm)
      inferred <- .rds_vdj_infer_chain(file_name = files[[i]], file_path = paths[[i]])
      data.frame(
        upload_id = paste0("upload#", i),
        uploaded_file = files[[i]],
        inferred_type = inferred,
        matched_barcodes = ov$n_overlap,
        file_barcodes = ov$n_file,
        overlap_pct = sprintf("%.1f%%", ov$pct),
        stringsAsFactors = FALSE
      )
    }))
    df
  }, striped = TRUE, bordered = TRUE, spacing = "s", na = "")

  output$rds_vdj_unmatched_examples_ui <- renderUI({
    nm <- rds_vdj_relink_target_obj() %||% ""
    req(nzchar(nm))
    up <- .rds_vdj_uploaded_df()
    req(is.data.frame(up), nrow(up) > 0)
    pend <- rds_pending()
    req(!is.null(pend), !is.null(pend$objs), !is.null(pend$objs[[nm]]))
    entry <- pend$objs[[nm]]
    sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else NULL
    req(!is.null(sobj), inherits(sobj, "Seurat"))
    obj_cells <- rownames(sobj@meta.data) %||% colnames(sobj) %||% character(0)
    obj_cells_norm <- unique(.rds_vdj_norm_bc(obj_cells))
    files <- as.character(up$name %||% character(0))
    paths <- as.character(up$datapath %||% character(0))
    keep <- nzchar(files) & nzchar(paths)
    files <- files[keep]
    paths <- paths[keep]
    if (!length(files)) return(NULL)
    blocks <- lapply(seq_along(files), function(i) {
      ex <- .rds_vdj_unmatched_examples(paths[[i]], obj_cells_norm, max_n = 8L)
      if (!length(ex)) return(NULL)
      tags$details(
        style = "margin-top:6px;",
        tags$summary(tags$small(paste0("Unmatched barcode examples for upload#", i, ": ", files[[i]], " (show/hide)"))),
        tags$div(
          style = "padding:6px 0 0 14px;",
          tags$ul(style = "margin:0;", lapply(ex, tags$li))
        )
      )
    })
    blocks <- blocks[!vapply(blocks, is.null, logical(1))]
    if (!length(blocks)) {
      return(tags$div(tags$small(class = "text-muted", "No unmatched barcode examples found in current queued files.")))
    }
    do.call(tagList, blocks)
  })

  observeEvent(input$rds_vdj_relink_apply, {
    nm <- rds_vdj_relink_target_obj() %||% ""
    req(nzchar(nm))
    pend <- rds_pending()
    req(!is.null(pend), !is.null(pend$objs), !is.null(pend$objs[[nm]]))
    missing_map <- .rds_collect_vdj_gate_map(pend$objs)
    miss_df <- missing_map[[nm]]
    if (is.data.frame(miss_df) && nrow(miss_df)) miss_df <- .rds_expand_missing_rows(miss_df)
    miss <- if (is.data.frame(miss_df) && nrow(miss_df)) as.character(miss_df$expected_name %||% character(0)) else as.character(missing_map[[nm]] %||% character(0))
    if (!length(miss)) {
      removeModal()
      return(invisible(NULL))
    }
    up <- .rds_vdj_uploaded_df()
    if (is.null(up) || !is.data.frame(up) || !nrow(up)) {
      showNotification("Upload at least one VDJ file before applying relink.", type = "warning")
      return(invisible(NULL))
    }
    files <- as.character(up$name %||% character(0))
    paths <- as.character(up$datapath %||% character(0))
    keep <- nzchar(files) & nzchar(paths)
    files <- files[keep]
    paths <- paths[keep]
    file_ids <- if (length(files)) paste0("__file_", seq_along(files)) else character(0)
    if (!length(file_ids)) {
      showNotification("No valid uploaded file names found.", type = "warning")
      return(invisible(NULL))
    }
    chosen <- character(0)
    chosen_labels <- character(0)
    resolved_expected_keys <- character(0)
    relink_rows <- list()
    unknown_expected <- character(0)
    for (i in seq_along(miss)) {
      pick <- as.character(input[[paste0("rds_vdj_match_", i)]] %||% "__skip__")
      expected <- miss[[i]]
      exp_chain <- if (is.data.frame(miss_df) && nrow(miss_df)) as.character(miss_df$expected_chain[[i]] %||% "Unknown") else "Unknown"
      if (identical(exp_chain, "Unknown")) {
        ch <- as.character(input[[paste0("rds_vdj_expected_chain_", i)]] %||% "__unknown__")
        if (!ch %in% c("TCR", "BCR")) unknown_expected <- c(unknown_expected, expected)
      }
      if (!identical(pick, "__keep_missing__") && !identical(pick, "__no_data__") && nzchar(pick) && pick %in% file_ids) {
        row_i <- match(pick, file_ids)
        chosen <- c(chosen, paths[[row_i]])
        infer0 <- .rds_vdj_infer_chain(file_name = files[[row_i]], file_path = paths[[row_i]])
        f0 <- as.character(files[[row_i]] %||% "")
        is_tmp_like <- grepl("^[0-9]+\\.(csv|tsv|txt)$", tolower(f0), perl = TRUE)
        pretty <- if (nzchar(f0) && !is_tmp_like) f0 else paste0("upload#", row_i)
        chosen_labels <- c(chosen_labels, paste0(pretty, " [", infer0, "]"))
        exp_key <- if (is.data.frame(miss_df) && nrow(miss_df) >= i && "expected_key" %in% names(miss_df)) as.character(miss_df$expected_key[[i]] %||% "") else ""
        exp_name <- if (is.data.frame(miss_df) && nrow(miss_df) >= i && "expected_name" %in% names(miss_df)) as.character(miss_df$expected_name[[i]] %||% expected) else as.character(expected)
        exp_chain2 <- if (is.data.frame(miss_df) && nrow(miss_df) >= i && "expected_chain" %in% names(miss_df)) as.character(miss_df$expected_chain[[i]] %||% "Unknown") else as.character(exp_chain)
        if (nzchar(exp_key)) resolved_expected_keys <- c(resolved_expected_keys, exp_key)
        relink_rows[[length(relink_rows) + 1L]] <- data.frame(
          expected_key = exp_key,
          expected_name = exp_name,
          expected_chain = exp_chain2,
          source_name = as.character(files[[row_i]] %||% ""),
          source_path = as.character(paths[[row_i]] %||% ""),
          stringsAsFactors = FALSE
        )
      }
    }
    if (length(unknown_expected)) {
      showNotification(
        paste0("Specify TCR/BCR for: ", paste(unique(unknown_expected), collapse = ", ")),
        type = "error",
        duration = 8
      )
      return(invisible(NULL))
    }
    no_data_expected_keys <- character(0)
    keep_missing_n <- 0L
    if (is.data.frame(miss_df) && nrow(miss_df)) {
      for (i in seq_along(miss)) {
        pick <- as.character(input[[paste0("rds_vdj_match_", i)]] %||% "__keep_missing__")
        if (identical(pick, "__keep_missing__")) {
          keep_missing_n <- keep_missing_n + 1L
          next
        }
        if (identical(pick, "__no_data__")) {
          ek <- as.character(miss_df$expected_key[[i]] %||% "")
          if (nzchar(ek)) no_data_expected_keys <- c(no_data_expected_keys, ek)
        }
      }
    }
    if (!length(chosen) && !length(no_data_expected_keys)) {
      showNotification("No relink mapping selected. You can keep slots missing to be reminded later.", type = "warning")
      return(invisible(NULL))
    }
    entry <- pend$objs[[nm]]
    if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
      entry <- tryCatch(wanlab_canonicalize_object_entry(entry), error = function(e) entry)
    }
    if (!is.list(entry)) return(invisible(NULL))
    payload <- entry$vdj_payload
    if (!is.list(payload)) payload <- list()
    if (length(no_data_expected_keys)) {
      empty_ok <- as.character(payload$missing_sources_empty_ok %||% character(0))
      payload$missing_sources_empty_ok <- unique(c(empty_ok, no_data_expected_keys[nzchar(no_data_expected_keys)]))
      payload$empty_vdj_confirmed_at <- Sys.time()
    }
    if (length(relink_rows)) {
      relink_df <- do.call(rbind, relink_rows)
      entry <- tryCatch(
        .rds_import_vdj_into_entry(entry, relink_df),
        error = function(e) {
          showModal(modalDialog(
            title = "VDJ import failed for matched file(s)",
            div(class = "alert alert-danger", paste0("Relink match was selected, but import into object failed: ", conditionMessage(e))),
            tags$p("Please verify the uploaded file content/columns and barcode compatibility, then retry."),
            tags$p(tags$small("If this sample truly has no VDJ clonotypes, choose 'Mark matched cells as no VDJ detected'.")),
            footer = tagList(
              modalButton("Cancel"),
              actionButton("rds_vdj_relink_mark_empty", "Mark matched cells as no VDJ detected", class = "btn btn-info")
            ),
            easyClose = TRUE,
            size = "m"
          ))
          return(NULL)
        }
      )
      if (is.null(entry) || !is.list(entry)) return(invisible(NULL))
    }
    # Refresh payload after import: .rds_import_vdj_into_entry() may have already
    # written records/metadata, so never overwrite with stale pre-import payload.
    payload <- entry$vdj_payload
    if (!is.list(payload)) payload <- list()
    cur <- as.character(payload$source_file %||% character(0))
    chosen_source_names <- if (length(relink_rows)) as.character(vapply(relink_rows, function(x) as.character(x$source_name[[1]] %||% ""), character(1))) else character(0)
    chosen_source_names <- chosen_source_names[nzchar(chosen_source_names)]
    payload$source_file <- unique(c(cur, chosen_source_names))
    cur_resolved <- as.character(payload$resolved_expected_sources %||% character(0))
    payload$resolved_expected_sources <- unique(c(cur_resolved, resolved_expected_keys[nzchar(resolved_expected_keys)]))
    old_relinked <- payload$relinked_files
    if (!is.data.frame(old_relinked)) old_relinked <- data.frame()
    new_relinked <- if (length(relink_rows)) do.call(rbind, relink_rows) else data.frame()
    if (is.data.frame(new_relinked) && nrow(new_relinked)) {
      merged_relinked <- if (is.data.frame(old_relinked) && nrow(old_relinked)) rbind(old_relinked, new_relinked) else new_relinked
      if (all(c("expected_key", "source_path") %in% names(merged_relinked))) {
        dedup_key <- paste0(as.character(merged_relinked$expected_key %||% ""), "::", as.character(merged_relinked$source_path %||% ""))
        merged_relinked <- merged_relinked[!duplicated(dedup_key), , drop = FALSE]
      }
      payload$relinked_files <- merged_relinked
    }
    if (length(resolved_expected_keys)) {
      resolved_keys_norm <- unique(tolower(gsub("\\\\", "/", as.character(resolved_expected_keys[nzchar(resolved_expected_keys)]))))
      drop_resolved <- function(x) {
        x <- as.character(x %||% character(0))
        if (!length(x)) return(x)
        x_norm <- tolower(gsub("\\\\", "/", x))
        x[!(x_norm %in% resolved_keys_norm)]
      }
      payload$missing_sources_lost <- drop_resolved(payload$missing_sources_lost)
      payload$missing_sources_empty_ok <- drop_resolved(payload$missing_sources_empty_ok)
    }
    # Canonicalize linked VDJ source map for this object to prevent stale/legacy
    # expected names from re-triggering relink prompts.
    if (is.null(entry$meta) || !is.list(entry$meta)) entry$meta <- list()
    if (is.null(entry$meta$linked_files) || !is.list(entry$meta$linked_files)) entry$meta$linked_files <- list()
    if (length(relink_rows)) {
      link_df <- do.call(rbind, lapply(relink_rows, function(x) {
        data.frame(
          chain = as.character(x$expected_chain[[1]] %||% "Unknown"),
          source_name = as.character(x$source_name[[1]] %||% ""),
          path = as.character(x$source_path[[1]] %||% ""),
          stringsAsFactors = FALSE
        )
      }))
      link_df <- link_df[nzchar(as.character(link_df$source_name %||% "")), , drop = FALSE]
      if (nrow(link_df)) {
        key <- paste0(toupper(as.character(link_df$chain %||% "")), "::", tolower(as.character(link_df$source_name %||% "")))
        link_df <- link_df[!duplicated(key), , drop = FALSE]
      }
      entry$meta$linked_files$vdj <- link_df
    }
    entry$vdj_payload <- payload
    pend$objs[[nm]] <- entry
    rds_pending(pend)
    removeModal()
    updated_missing <- .rds_collect_vdj_gate_map(pend$objs)
    remaining_df <- updated_missing[[nm]]
    remaining <- if (is.data.frame(remaining_df) && nrow(remaining_df)) {
      paste0(as.character(remaining_df$expected_name), " (", as.character(remaining_df$expected_chain), ")")
    } else as.character(updated_missing[[nm]] %||% character(0))
    matched_txt <- if (length(chosen_labels)) paste(unique(chosen_labels), collapse = ", ") else "none"
    if (length(remaining)) {
      showNotification(
        paste0(
          "Relink updated for ", nm, ". ",
          "Imported and recalculated: VDJ flags, clone IDs, clone sizes. ",
          "Matched files: ", matched_txt, ". ",
          "Still missing for this object: ",
          paste(remaining, collapse = ", ")
        ),
        type = "warning",
        duration = 9
      )
    } else {
      msg_tail <- if (keep_missing_n > 0L) paste0(" ", keep_missing_n, " slot(s) kept missing for future reminders.") else ""
      showNotification(
        paste0(
          "Relink updated for ", nm, ". ",
          "Imported and recalculated: VDJ flags, clone IDs, clone sizes. ",
          "Matched files: ", matched_txt, ". ",
          "All missing VDJ sources are resolved for this object.", msg_tail
        ),
        type = "message",
        duration = 8
      )
    }
  }, ignoreInit = TRUE)

  observeEvent(input$rds_vdj_relink_skip_missing, {
    nm <- rds_vdj_relink_target_obj() %||% ""
    req(nzchar(nm))
    pend <- rds_pending()
    req(!is.null(pend), !is.null(pend$objs), !is.null(pend$objs[[nm]]))
    missing_map <- .rds_collect_vdj_gate_map(pend$objs)
    miss_df <- missing_map[[nm]]
    miss <- if (is.data.frame(miss_df) && nrow(miss_df)) as.character(miss_df$expected_name %||% character(0)) else as.character(missing_map[[nm]] %||% character(0))
    if (!length(miss)) {
      removeModal()
      return(invisible(NULL))
    }
    unknown_expected <- character(0)
    for (i in seq_along(miss)) {
      expected <- miss[[i]]
      exp_chain <- if (is.data.frame(miss_df) && nrow(miss_df)) as.character(miss_df$expected_chain[[i]] %||% "Unknown") else "Unknown"
      if (identical(exp_chain, "Unknown")) {
        ch <- as.character(input[[paste0("rds_vdj_expected_chain_", i)]] %||% "__unknown__")
        if (!ch %in% c("TCR", "BCR")) unknown_expected <- c(unknown_expected, expected)
      }
    }
    if (length(unknown_expected)) {
      showNotification(
        paste0("Specify TCR/BCR before marking no-data slot for: ", paste(unique(unknown_expected), collapse = ", ")),
        type = "error",
        duration = 8
      )
      return(invisible(NULL))
    }
    entry <- pend$objs[[nm]]
    if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
      entry <- tryCatch(wanlab_canonicalize_object_entry(entry), error = function(e) entry)
    }
    if (!is.list(entry)) return(invisible(NULL))
    payload <- entry$vdj_payload
    if (!is.list(payload)) payload <- list()
    lost <- as.character(payload$missing_sources_lost %||% character(0))
    miss_keys <- if (is.data.frame(miss_df) && nrow(miss_df) && "expected_key" %in% names(miss_df)) {
      keys <- as.character(miss_df$expected_key %||% character(0))
      ifelse(nzchar(keys), keys, paste0("__missing__", seq_along(keys)))
    } else miss
    gate_key <- .rds_vdj_no_payload_key(nm)
    payload$missing_sources_lost <- unique(c(lost, miss_keys[nzchar(miss_keys)], gate_key))
    entry$vdj_payload <- payload
    pend$objs[[nm]] <- entry
    rds_pending(pend)
    removeModal()
    showNotification(
      paste0(
        "Marked ", length(miss), " VDJ slot(s) as no data for ", nm,
        ". You can relink later if data becomes available."
      ),
      type = "warning",
      duration = 8
    )
  }, ignoreInit = TRUE)

  observeEvent(input$rds_vdj_relink_mark_empty, {
    nm <- rds_vdj_relink_target_obj() %||% ""
    req(nzchar(nm))
    pend <- rds_pending()
    req(!is.null(pend), !is.null(pend$objs), !is.null(pend$objs[[nm]]))
    missing_map <- .rds_collect_vdj_gate_map(pend$objs)
    miss_df <- missing_map[[nm]]
    miss <- if (is.data.frame(miss_df) && nrow(miss_df)) as.character(miss_df$expected_name %||% character(0)) else as.character(missing_map[[nm]] %||% character(0))
    if (!length(miss)) {
      removeModal()
      return(invisible(NULL))
    }
    entry <- pend$objs[[nm]]
    if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
      entry <- tryCatch(wanlab_canonicalize_object_entry(entry), error = function(e) entry)
    }
    if (!is.list(entry)) return(invisible(NULL))
    payload <- entry$vdj_payload
    if (!is.list(payload)) payload <- list()
    empty_ok <- as.character(payload$missing_sources_empty_ok %||% character(0))
    miss_keys <- if (is.data.frame(miss_df) && nrow(miss_df) && "expected_key" %in% names(miss_df)) {
      keys <- as.character(miss_df$expected_key %||% character(0))
      ifelse(nzchar(keys), keys, paste0("__missing__", seq_along(keys)))
    } else miss
    gate_key <- .rds_vdj_no_payload_key(nm)
    payload$missing_sources_empty_ok <- unique(c(empty_ok, miss_keys[nzchar(miss_keys)], gate_key))
    payload$empty_vdj_confirmed_at <- Sys.time()
    entry$vdj_payload <- payload
    pend$objs[[nm]] <- entry
    rds_pending(pend)
    removeModal()
    showNotification(
      paste0(
        "Marked ", length(miss), " expected VDJ source(s) for ", nm,
        " as no VDJ detected for matched cells. This object can continue."
      ),
      type = "message",
      duration = 8
    )
  }, ignoreInit = TRUE)

  .selected_object_names <- function(pend) {
    if (is.null(pend) || is.null(pend$objs) || !length(pend$objs)) return(character(0))
    all_objs <- names(pend$objs)
    df <- rds_review_df()
    sel <- input$rds_review_table_rows_selected %||% integer(0)
    if (is.null(df) || !nrow(df) || !length(sel)) return(all_objs)
    sel <- as.integer(sel)
    sel <- sel[is.finite(sel) & sel >= 1 & sel <= nrow(df)]
    if (!length(sel)) return(all_objs)
    picked <- unique(as.character(df$object[sel] %||% character(0)))
    picked <- picked[nzchar(picked) & picked %in% all_objs]
    if (!length(picked)) all_objs else picked
  }
  
  # Discard preview
  observeEvent(input$rds_discard_pending, {
    rds_pending(NULL)
    rds_default_focus(NULL)
    shinyjs::hide("rds_review_card")
    showNotification(RDS_UI_TEXT$ui_text_discarded_imported_preview, type = "message")
  })
  
  .commit_rds_to_workspace <- function() {
    pend <- rds_pending(); req(pend)

    keep_overlay_until_analysis_ready <- FALSE
    .show_overlay("Applying configuration and preparing objects for analysis…")
    on.exit({
      if (!isTRUE(keep_overlay_until_analysis_ready)) .hide_overlay()
    }, add = TRUE)
    
    keep_names <- .selected_object_names(pend)
    if (!length(keep_names)) {
      showNotification(RDS_UI_TEXT$ui_text_select_at_least_one, type = "warning")
      return(invisible(NULL))
    }
    objs <- pend$objs[keep_names]
    nm <- names(objs)
    
    for (n in nm) {
      sobj <- objs[[n]]$obj
      
      assay_id   <- input[[paste0("cfg_", n, "_assay")]]   %||% pend$meta[[n]]$defaults$assay
      slot_id    <- input[[paste0("cfg_", n, "_slot")]]    %||% pend$meta[[n]]$defaults$slot
      ident_id   <- input[[paste0("cfg_", n, "_ident")]]   %||% pend$meta[[n]]$defaults$ident
      sample_col <- input[[paste0("cfg_", n, "_sample_col")]] %||% pend$meta[[n]]$summary$sample_guess
      barcode_col<- input[[paste0("cfg_", n, "_barcode_col")]] %||% ""
      
      # DefaultAssay (will be "bundle" by default if present)
      if (!is.null(assay_id) && nzchar(assay_id) &&
          assay_id %in% tryCatch(Seurat::Assays(sobj), error=function(e) character())) {
        try({ Seurat::DefaultAssay(sobj) <- assay_id }, silent = TRUE)
      }
      
      # Idents
      if (!is.null(ident_id) && nzchar(ident_id) && ident_id %in% colnames(sobj@meta.data)) {
        try({ Seurat::Idents(sobj) <- sobj@meta.data[[ident_id]] }, silent = TRUE)
      } else {
        # Do NOT overwrite Idents with a single 'All' level; just keep whatever is already there.
        # (If the object has no identities yet, the clustering step will set them.)
      }
      
      # Ensure plotting prereqs
      prep <- .ensure_plot_prereqs(sobj, desired_slot = slot_id)
      sobj <- prep$sobj
      plots_list <- objs[[n]]$plots %||% list()
      plots_list$default_reduction    <- prep$plots$default_reduction
      plots_list$available_reductions <- prep$plots$available_reductions
      plots_list$feature_slot         <- prep$plots$feature_slot
      if (is.null(plots_list$elbow)) plots_list$elbow <- prep$plots$elbow
      
      existing_prefs <- objs[[n]]$prefs %||% list()
      if (!is.list(existing_prefs)) existing_prefs <- list()
      existing_prefs$default_assay <- tryCatch(Seurat::DefaultAssay(sobj), error=function(e) assay_id)
      existing_prefs$plot_slot <- plots_list$feature_slot
      existing_prefs$ident_col <- if (!is.null(ident_id) && nzchar(ident_id)) ident_id else NULL
      existing_prefs$sample_col <- if (!is.null(sample_col) && nzchar(sample_col)) sample_col else NULL
      existing_prefs$barcode_col <- if (!is.null(barcode_col) && nzchar(barcode_col)) barcode_col else NULL
      objs[[n]]$prefs <- existing_prefs
      objs[[n]]$obj   <- sobj
      objs[[n]]$plots <- plots_list
    }
    
    migrated_bundle <- .migrate_legacy_vdj_tabular_to_object_links(
      objs = objs,
      imported_tabular_files = pend$imported_tabular_files %||% data.frame()
    )
    objs <- migrated_bundle$objs %||% objs
    migrated_tabular <- migrated_bundle$tabular %||% data.frame()
    missing_now <- .rds_collect_vdj_gate_map(objs)
    if (length(missing_now)) {
      details <- tagList(lapply(names(missing_now), function(obj_name) {
        jump_btn <- tags$button(
          type = "button",
          class = "btn btn-danger btn-sm",
          style = "margin: 0;",
          onclick = sprintf("Shiny.setInputValue('rds_vdj_relink_target', '%s', {priority:'event'});", gsub("'", "\\\\'", as.character(obj_name), fixed = TRUE)),
          paste0("Import/Relink for ", obj_name)
        )
        tags$div(
          class = "rds-vdj-missing-object-row",
          style = "display:flex; justify-content:space-between; align-items:flex-start; gap:16px; margin:10px 0 14px 0;",
          tags$div(
            style = "flex:1; min-width:0;",
            tags$b(obj_name),
            tags$ul(lapply(
              paste0(as.character(missing_now[[obj_name]]$expected_name), " (", as.character(missing_now[[obj_name]]$expected_chain), ")"),
              tags$li
            ))
          ),
          tags$div(style = "flex:0 0 auto; padding-top:2px;", jump_btn)
        )
      }))
      showModal(modalDialog(
        title = "Cannot add to workspace: unresolved VDJ remains",
        div(class = "alert alert-danger", "Some objects still have unresolved or not-yet-imported VDJ sources. Relink/import before adding to workspace."),
        tags$p(tags$b("Still unresolved by object:")),
        details,
        footer = modalButton("OK"),
        easyClose = TRUE,
        size = "l"
      ))
      return(invisible(NULL))
    }

    # Commit to shared_data and proceed
    if (exists("wanlab_canonicalize_registry", mode = "function", inherits = TRUE)) {
      objs <- tryCatch(wanlab_canonicalize_registry(objs), error = function(e) objs)
    }
    shared_data$all_seurat_objects <- objs
    shared_data$full_sample_sheet <- .build_sample_sheet_from_registry(objs)
    
    focus <- rds_default_focus()
    shared_data$active_object_name <- .resolve_rds_import_active_object_name(
      object_names = nm,
      focus = focus,
      imported_active_name = pend$imported_active_object_name %||% "",
      registry = objs
    )
    # Guarantee a valid active object right after import commit.
    active_nm <- as.character(shared_data$active_object_name %||% "")
    if (!nzchar(active_nm) || !(active_nm %in% nm)) {
      shared_data$active_object_name <- nm[[1]]
    }
    # Seed analysis boot active object explicitly so Analysis page hydration
    # does not wait on delayed selector/bootstrap reconciliation.
    try({
      shared_data$analysis_boot$active_object <- .scalar_chr(shared_data$active_object_name, default = nm[[1]])
    }, silent = TRUE)
    
    shared_data$object_prefs <- lapply(nm, function(nm1) objs[[nm1]]$prefs)
    names(shared_data$object_prefs) <- nm
    shared_data$analysis_params_by_page <- pend$analysis_params_by_page %||% list()
    shared_data$imported_session_info <- pend$session_info %||% character(0)
    shared_data$imported_tabular_files <- .normalize_tabular_imports(migrated_tabular)
    ann_layers <- .normalize_annotation_layers_import(pend$annotation_layers %||% list())
    ann_layers <- ann_layers[nm]
    ann_layers <- ann_layers[!vapply(ann_layers, function(bucket) is.null(bucket) || !length(bucket), logical(1))]
    shared_data$annotation_layers <- ann_layers
    ann_active <- .normalize_active_annotation_layer_import(pend$active_annotation_layer %||% list())
    if (length(ann_active)) {
      ann_active <- ann_active[nm]
      valid <- vapply(names(ann_active), function(obj_name) {
        lyr <- ann_active[[obj_name]] %||% ""
        nzchar(lyr) && !is.null(ann_layers[[obj_name]]) && !is.null(ann_layers[[obj_name]][[lyr]])
      }, logical(1))
      ann_active <- ann_active[valid]
    }
    shared_data$active_annotation_layer <- ann_active
    
    has_rna_filtered_name <- any(tolower(nm) == "rna_filtered")
    has_integrated_assay <- any(vapply(objs, function(entry) {
      sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else NULL
      if (is.null(sobj) || !inherits(sobj, "Seurat")) return(FALSE)
      assays_low <- tryCatch(tolower(Seurat::Assays(sobj)), error = function(e) character())
      "integrated" %in% assays_low
    }, logical(1)))
    route_tab <- if (!has_rna_filtered_name && !has_integrated_assay) "qc_tab" else "analysis_tab"

    rds_pending(NULL)
    rds_default_focus(NULL)
    shinyjs::hide("rds_review_card")
    showNotification(RDS_UI_TEXT$ui_text_configuration_applied_added_workspace, type = "message")
    keep_overlay_until_analysis_ready <- TRUE
    .show_overlay("Opening Analysis page and finalizing data readiness…")
    updateNavbarPage(session, "main_navbar", selected = route_tab)
    session$sendCustomMessage("setActiveNav", route_tab)
    if (identical(route_tab, "qc_tab")) {
      try(overlay_hide_when_output_ready("qc_scatter_main", timeout_ms = 120000L), silent = TRUE)
    }
  }

  # Apply & Proceed (with confirmation notice)
  observeEvent(input$rds_apply_and_proceed, {
    pend <- rds_pending(); req(pend)
    n_obj <- length(.selected_object_names(pend))
    showModal(modalDialog(
      title = RDS_UI_TEXT$ui_text_before_adding_workspace,
      easyClose = TRUE,
      footer = tagList(
        modalButton(RDS_UI_TEXT$ui_button_cancel),
        actionButton("rds_confirm_add_workspace_btn", RDS_UI_TEXT$ui_btn_add_workspace, class = "btn-primary")
      ),
      tags$p(
        RDS_UI_TEXT$ui_text_import_time_depends_number_size_selected
      ),
      tags$p(
        RDS_UI_TEXT$ui_text_faster_import_better_stability_add_only
      ),
      tags$p(tags$b(sprintf(RDS_UI_TEXT$ui_text_label_objects_selected, n_obj)))
    ))
  })

  observeEvent(input$rds_confirm_add_workspace_btn, {
    removeModal()
    .commit_rds_to_workspace()
  })

  .copy_usage_code_to_clipboard <- function(code_raw) {
    code_txt <- gsub("\\\\", "\\\\\\\\", code_raw)
    code_txt <- gsub("'", "\\\\'", code_txt, fixed = TRUE)
    code_txt <- gsub("\\n", "\\\\n", code_txt, fixed = TRUE)
    shinyjs::runjs(sprintf("
      (function(){
        var txt = '%s';
        function fallbackCopy(t) {
          var ta = document.createElement('textarea');
          ta.value = t;
          ta.style.position = 'fixed';
          ta.style.opacity = '0';
          document.body.appendChild(ta);
          ta.focus();
          ta.select();
          try {
            var copied = document.execCommand('copy');
            return copied === true;
          } catch(e) { return false; }
          finally { document.body.removeChild(ta); }
        }
        if (navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(txt).then(function(){
            Shiny.setInputValue('rds_usage_code_copy_status', 'ok_' + Date.now(), {priority: 'event'});
          }).catch(function(){
            var ok = fallbackCopy(txt);
            Shiny.setInputValue('rds_usage_code_copy_status', (ok ? 'ok_' : 'fail_') + Date.now(), {priority: 'event'});
          });
        } else {
          var ok = fallbackCopy(txt);
          Shiny.setInputValue('rds_usage_code_copy_status', (ok ? 'ok_' : 'fail_') + Date.now(), {priority: 'event'});
        }
      })();
    ", code_txt))
  }

  observeEvent(input$rds_copy_usage_code_btn, {
    .copy_usage_code_to_clipboard(RDS_WORKSPACE_EXPORT_USAGE_CODE)
  })

  observeEvent(input$rds_single_copy_usage_code_btn, {
    .copy_usage_code_to_clipboard(RDS_SINGLE_EXPORT_USAGE_CODE)
  })

  observeEvent(input$rds_usage_code_copy_status, {
    val <- as.character(input$rds_usage_code_copy_status %||% "")
    if (startsWith(val, "ok_")) {
      showNotification(RDS_UI_TEXT$ui_text_usage_code_copied, type = "message")
    } else if (startsWith(val, "fail_")) {
      showNotification(RDS_UI_TEXT$ui_text_usage_code_copy_failed, type = "warning")
    }
  })

  .rds_tree_escape <- function(x) {
    y <- as.character(x %||% "")
    y <- gsub("\\\\", "\\\\\\\\", y)
    gsub("\"", "\\\\\"", y)
  }

  .rds_tree_safe_name <- function(x) {
    x <- as.character(x %||% "")
    grepl("^[A-Za-z.][A-Za-z0-9._]*$", x)
  }

  .rds_tree_has_nonempty_names <- function(nms) {
    if (is.null(nms) || !length(nms)) return(FALSE)
    any(!is.na(nms) & nzchar(nms))
  }

  .rds_tree_append_name_expr <- function(expr, name) {
    nm <- as.character(name %||% "")
    if (.rds_tree_safe_name(nm)) {
      paste0(expr, "$", nm)
    } else {
      paste0(expr, "[[\"", .rds_tree_escape(nm), "\"]]")
    }
  }

  .rds_tree_truncate <- function(x, max_chars = 150L) {
    txt <- as.character(x %||% "")
    if (!length(txt) || is.na(txt[[1]]) || !nzchar(txt[[1]])) return("")
    val <- txt[[1]]
    if (nchar(val, type = "chars", allowNA = FALSE, keepNA = FALSE) <= max_chars) return(val)
    paste0(substr(val, 1L, max_chars - 3L), "...")
  }

  .rds_tree_atomic_preview <- function(x, n = 3L) {
    if (length(x) == 0) return("<empty>")
    h <- utils::head(x, n)
    if (is.factor(h)) h <- as.character(h)
    vals <- vapply(h, function(v) {
      if (is.numeric(v)) {
        format(signif(as.numeric(v), 6), trim = TRUE, scientific = FALSE)
      } else if (is.logical(v)) {
        if (is.na(v)) "NA" else if (isTRUE(v)) "TRUE" else "FALSE"
      } else {
        if (is.null(v) || length(v) == 0 || is.na(v)) "NA" else as.character(v)
      }
    }, character(1), USE.NAMES = FALSE)
    nms <- names(h)
    if (.rds_tree_has_nonempty_names(nms)) {
      vals <- paste0(ifelse(nzchar(nms), nms, paste0("[", seq_along(vals), "]")), "=", vals)
    }
    suffix <- if (length(x) > n) ", ..." else ""
    paste0(paste(vals, collapse = ", "), suffix)
  }

  .rds_tree_preview <- function(x) {
    if (is.null(x)) return("NULL")
    if (isS4(x)) {
      slots <- slotNames(x)
      if (!length(slots)) return("slot names: <none>")
      suffix <- if (length(slots) > 6L) ", ..." else ""
      return(paste0("slot names: ", paste(utils::head(slots, 6L), collapse = ", "), suffix))
    }
    if (is.data.frame(x)) {
      nr <- nrow(x); nc <- ncol(x)
      cols <- colnames(x) %||% character(0)
      col_txt <- if (length(cols)) {
        paste(utils::head(cols, 6L), collapse = ", ")
      } else {
        "<none>"
      }
      if (length(cols) > 6L) col_txt <- paste0(col_txt, ", ...")
      if (!nr || !nc) return(sprintf("%d rows x %d cols; cols: %s", nr, nc, col_txt))
      pick <- seq_len(min(3L, nc))
      first_row <- x[1, pick, drop = FALSE]
      kv <- paste0(names(first_row), "=", vapply(first_row, function(v) as.character(v[[1]] %||% "NA"), character(1)))
      return(sprintf("%d rows x %d cols; cols: %s; row1: %s", nr, nc, col_txt, paste(kv, collapse = ", ")))
    }
    if (is.matrix(x)) {
      vals <- .rds_tree_atomic_preview(as.vector(x), n = 4L)
      return(sprintf("%d x %d; head: %s", nrow(x), ncol(x), vals))
    }
    if (is.list(x)) {
      nms <- names(x)
      if (!length(x)) return("length=0")
      if (.rds_tree_has_nonempty_names(nms)) {
        keep <- !is.na(nms) & nzchar(nms)
        show <- utils::head(nms[keep], 6L)
        if (!length(show)) return(sprintf("length=%d", length(x)))
        suffix <- if (sum(keep) > 6L) ", ..." else ""
        return(paste0("head names: ", paste(show, collapse = ", "), suffix))
      }
      return(sprintf("length=%d", length(x)))
    }
    if (is.character(x) || is.factor(x) || is.numeric(x) || is.integer(x) || is.logical(x)) {
      return(.rds_tree_atomic_preview(x, n = 3L))
    }
    if (is.function(x)) return("<function>")
    ""
  }

  .rds_tree_type_label <- function(x) {
    if (is.null(x)) return("NULL")
    if (isS4(x)) return(paste0(class(x)[1], " S4"))
    if (is.data.frame(x)) return("data.frame")
    if (is.matrix(x)) return(paste0(class(x)[1], " matrix"))
    if (is.list(x)) {
      nms <- names(x)
      if (.rds_tree_has_nonempty_names(nms)) return("named list")
      return("list")
    }
    if (is.character(x)) {
      if (.rds_tree_has_nonempty_names(names(x))) return("named chr vector")
      if (length(x) == 1L) return("chr(1)")
      return("chr vector")
    }
    if (is.integer(x)) {
      if (.rds_tree_has_nonempty_names(names(x))) return("named int vector")
      if (length(x) == 1L) return("int(1)")
      return("int vector")
    }
    if (is.numeric(x)) {
      if (.rds_tree_has_nonempty_names(names(x))) return("named dbl vector")
      if (length(x) == 1L) return("dbl(1)")
      return("dbl vector")
    }
    if (is.logical(x)) {
      if (.rds_tree_has_nonempty_names(names(x))) return("named lgl vector")
      if (length(x) == 1L) return("lgl(1)")
      return("lgl vector")
    }
    if (is.factor(x)) return("factor")
    if (is.function(x)) return("function")
    as.character(class(x)[1] %||% typeof(x))
  }

  .rds_tree_children <- function(x) {
    if (isS4(x)) {
      slots <- slotNames(x)
      vals <- lapply(slots, function(sn) {
        tryCatch(slot(x, sn), error = function(e) NULL)
      })
      return(list(labels = slots, values = vals, kinds = rep("slot", length(slots))))
    }
    if (is.data.frame(x)) {
      cols <- colnames(x) %||% character(0)
      vals <- lapply(seq_along(cols), function(i) x[[i]])
      return(list(labels = cols, values = vals, kinds = rep("name", length(cols))))
    }
    if (is.list(x)) {
      n <- length(x)
      if (!n) return(list(labels = character(0), values = list(), kinds = character(0)))
      nms <- names(x)
      if (is.null(nms)) nms <- rep("", n)
      named <- !is.na(nms) & nzchar(nms)
      labels <- ifelse(named, nms, paste0("[[", seq_len(n), "]]"))
      kinds <- ifelse(named, "name", "index")
      vals <- lapply(seq_len(n), function(i) x[[i]])
      return(list(labels = labels, values = vals, kinds = kinds))
    }
    list(labels = character(0), values = list(), kinds = character(0))
  }

  .rds_tree_build_lines <- function(x, label, expr, prefix = "", is_last = TRUE, is_root = FALSE, depth = 0L, state = NULL) {
    if (is.null(state)) {
      state <- new.env(parent = emptyenv())
      state$nodes <- 0L
      state$max_nodes <- 50000L
      state$max_depth <- 40L
    }

    state$nodes <- state$nodes + 1L
    if (state$nodes > state$max_nodes) {
      branch_cap <- if (is_root) "" else if (is_last) "└── " else "├── "
      return(paste0(prefix, branch_cap, "<truncated: node limit reached>"))
    }

    branch <- if (is_root) "" else if (is_last) "└── " else "├── "
    type_label <- .rds_tree_type_label(x)
    access_txt <- if (is_root) {
      if (isS4(x)) "use @" else if (is.list(x) || is.data.frame(x)) "use $" else expr
    } else {
      expr
    }
    preview_txt <- .rds_tree_truncate(.rds_tree_preview(x), max_chars = 180L)
    line <- sprintf("%s%s%-34s [%-20s] -> %s", prefix, branch, label, type_label, access_txt)
    if (nzchar(preview_txt)) line <- paste0(line, " | head: ", preview_txt)
    lines <- c(line)

    if (depth >= state$max_depth) {
      child_prefix <- if (is_root) "" else paste0(prefix, if (is_last) "    " else "│   ")
      lines <- c(lines, paste0(child_prefix, "└── <truncated: depth limit reached>"))
      return(lines)
    }

    kids <- .rds_tree_children(x)
    n_kids <- length(kids$labels)
    if (!n_kids) return(lines)

    child_prefix <- if (is_root) "" else paste0(prefix, if (is_last) "    " else "│   ")
    for (i in seq_len(n_kids)) {
      child_label <- kids$labels[[i]]
      child_value <- kids$values[[i]]
      kind <- kids$kinds[[i]]
      child_expr <- if (identical(kind, "slot")) {
        paste0(expr, "@", child_label)
      } else if (identical(kind, "index")) {
        idx <- as.integer(gsub("[^0-9]", "", child_label))
        paste0(expr, "[[", idx, "]]")
      } else {
        .rds_tree_append_name_expr(expr, child_label)
      }
      lines <- c(
        lines,
        .rds_tree_build_lines(
          x = child_value,
          label = child_label,
          expr = child_expr,
          prefix = child_prefix,
          is_last = (i == n_kids),
          is_root = FALSE,
          depth = depth + 1L,
          state = state
        )
      )
    }
    lines
  }

  .rds_tree_report_lines <- function(bundle) {
    c(
      .rds_tree_build_lines(
        x = bundle,
        label = "bundle",
        expr = "bundle",
        is_root = TRUE
      )
    )
  }
  
  # --- Export handler (guard against empty) ---
  output$download_rds_btn <- downloadHandler(
    filename = function() paste0("Seurat_Session_v", APP_VERSION, "_", format(Sys.time(), "%Y%m%d"), ".rds"),
    content = function(file) {
      if (is.null(shared_data$all_seurat_objects) || !length(shared_data$all_seurat_objects)) {
        showNotification(
          RDS_UI_TEXT$ui_text_error_no_datasets_export,
          type = "error"
        )
        stop(RDS_UI_TEXT$ui_text_error_no_datasets_export_stop)
      }
      
      .show_overlay(RDS_UI_TEXT$ui_text_overlay_preparing_rds_bundle)
      on.exit(.hide_overlay(), add = TRUE)
      
      showNotification(RDS_UI_TEXT$ui_text_prepare_rds_bundle, id = "rds_save_note", type = "message")
      on.exit(removeNotification("rds_save_note"), add = TRUE)
      fast_checkpoint <- isTRUE(input$rds_export_fast_checkpoint %||% FALSE)
      
      saveRDS(
        .build_workspace_bundle_payload(
          all_objects = shared_data$all_seurat_objects,
          active_object_name = isolate(shared_data$active_object_name %||% NA_character_)
        ),
        file = file,
        compress = !fast_checkpoint
      )
    }
  )

  output$download_rds_structure_txt_btn <- downloadHandler(
    filename = function() paste0("Seurat_Session_Structure_Tree_v", APP_VERSION, "_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".txt"),
    content = function(file) {
      if (is.null(shared_data$all_seurat_objects) || !length(shared_data$all_seurat_objects)) {
        showNotification(
          RDS_UI_TEXT$ui_text_error_no_datasets_export,
          type = "error"
        )
        stop(RDS_UI_TEXT$ui_text_error_no_datasets_export_stop)
      }

      .show_overlay(RDS_UI_TEXT$ui_text_overlay_preparing_rds_structure_report)
      on.exit(.hide_overlay(), add = TRUE)

      showNotification(RDS_UI_TEXT$ui_text_prepare_rds_structure_report, id = "rds_structure_note", type = "message")
      on.exit(removeNotification("rds_structure_note"), add = TRUE)

      bundle <- .build_workspace_bundle_payload(
        all_objects = shared_data$all_seurat_objects,
        active_object_name = isolate(shared_data$active_object_name %||% NA_character_)
      )
      writeLines(.rds_tree_report_lines(bundle), con = file, useBytes = TRUE)
    }
  )

  output$download_params_session_txt_btn <- downloadHandler(
    filename = function() paste0("analysis_params_session_info_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".txt"),
    content = function(file) {
      params <- isolate(shared_data$analysis_params_by_page %||% list())
      lines <- c(
        sprintf(RDS_UI_TEXT$ui_text_pipeline_version, APP_VERSION),
        sprintf(RDS_UI_TEXT$ui_text_export_time_line, format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
        "",
        "=== Analysis Parameters By Page ==="
      )

      if (!length(params)) {
        lines <- c(lines, RDS_UI_TEXT$ui_text_no_captured_analysis_parameters_found, "")
      } else {
        page_ids <- sort(names(params))
        for (pid in page_ids) {
          rec <- params[[pid]] %||% list()
          page_params <- rec$last_used_params %||% rec
          lines <- c(lines, sprintf(RDS_UI_TEXT$ui_text_page_section_prefix, pid))
          if (!is.null(rec$updated_at) && nzchar(as.character(rec$updated_at))) {
            lines <- c(lines, sprintf(RDS_UI_TEXT$ui_text_updated_at, as.character(rec$updated_at)))
          }
          if (!is.null(rec$trigger_id) && nzchar(as.character(rec$trigger_id))) {
            lines <- c(lines, sprintf(RDS_UI_TEXT$ui_text_trigger_id, as.character(rec$trigger_id)))
          }
          if (!length(page_params)) {
            lines <- c(lines, RDS_UI_TEXT$ui_text_no_parameters)
          } else {
            lines <- c(lines, capture.output(str(page_params, max.level = 2, give.attr = FALSE)))
          }
          lines <- c(lines, "")
        }
      }

      lines <- c(lines, RDS_UI_TEXT$ui_text_header_session_info_current_runtime, capture.output(utils::sessionInfo()))
      writeLines(lines, con = file, useBytes = TRUE)
    }
  )

  output$rds_single_export_object_ui <- renderUI({
    objs <- shared_data$all_seurat_objects %||% list()
    nms <- names(objs)
    if (!length(nms)) return(tags$div(class = "rds-muted", RDS_UI_TEXT$ui_text_export_wrap_empty))
    cur <- isolate(input$rds_single_export_object_name %||% "")
    if (!nzchar(cur) || !(cur %in% nms)) cur <- nms[[1]]
    selectInput("rds_single_export_object_name", RDS_UI_TEXT$ui_label_object, choices = nms, selected = cur, width = "460px")
  })

  .current_single_export_name <- function() {
    objs <- shared_data$all_seurat_objects %||% list()
    nms <- names(objs)
    if (!length(nms)) return("")
    nm <- as.character(input$rds_single_export_object_name %||% "")
    if (!nzchar(nm) || !(nm %in% nms)) nm <- nms[[1]]
    nm
  }

  .build_workspace_bundle_payload <- function(all_objects, active_object_name) {
    all_objects <- .normalize_imported_list(all_objects)
    if (length(all_objects)) {
      for (nm in names(all_objects)) {
        entry <- all_objects[[nm]]
        sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else NULL
        if (is.null(sobj) || !inherits(sobj, "Seurat")) next
        plots <- entry$plots %||% list()
        if (is.null(plots$elbow)) {
          plots$elbow <- .rds_build_elbow_plot(sobj)
        }
        entry$plots <- plots
        all_objects[[nm]] <- entry
      }
    }
    s_info <- sessionInfo()
    all_pkgs <- c(s_info$otherPkgs, s_info$loadedOnly)
    pkg_versions <- sapply(all_pkgs, function(pkg) pkg$Version)
    pkg_versions <- pkg_versions[order(names(pkg_versions))]
    seurat_ver <- tryCatch({
      lp <- shared_data$active_library_path %||% ""
      if (nzchar(lp) && dir.exists(lp)) as.character(utils::packageVersion("Seurat", lib.loc = lp))
      else as.character(utils::packageVersion("Seurat"))
    }, error = function(e) NA_character_)
    export_time <- format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")
    pipeline_info <- list(
      pipeline_version = APP_VERSION,
      analysis_date = export_time,
      exported_at = export_time,
      active_environment = shared_data$active_environment$name %||% NA_character_,
      active_object_name = active_object_name %||% NA_character_,
      seurat_version = seurat_ver,
      package_versions = pkg_versions
    )
    list(
      app_version = APP_VERSION,
      exported_at = export_time,
      pipeline_info = pipeline_info,
      package_versions = pkg_versions,
      active_object_name = active_object_name %||% NA_character_,
      all_seurat_objects = all_objects,
      imported_tabular_files = isolate(.normalize_tabular_imports(shared_data$imported_tabular_files %||% data.frame())),
      annotation_layers = isolate(.normalize_annotation_layers_import(shared_data$annotation_layers %||% list())),
      active_annotation_layer = isolate(.normalize_active_annotation_layer_import(shared_data$active_annotation_layer %||% list())),
      analysis_params_by_page = isolate(shared_data$analysis_params_by_page %||% list()),
      session_info = capture.output(utils::sessionInfo())
    )
  }

  output$download_single_object_rds_btn <- downloadHandler(
    filename = function() {
      nm <- .current_single_export_name()
      if (!nzchar(nm)) nm <- "selected_object"
      nm_safe <- gsub("[^A-Za-z0-9_]+", "_", nm)
      nm_safe <- gsub("^_+|_+$", "", nm_safe)
      if (!nzchar(nm_safe)) nm_safe <- "selected_object"
      paste0("Seurat_Object_Bundle_", nm_safe, "_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".rds")
    },
    content = function(file) {
      objs <- shared_data$all_seurat_objects %||% list()
      .show_overlay(RDS_UI_TEXT$ui_text_overlay_preparing_rds_bundle)
      on.exit(.hide_overlay(), add = TRUE)
      showNotification(RDS_UI_TEXT$ui_text_prepare_rds_bundle, id = "rds_single_save_note", type = "message")
      on.exit(removeNotification("rds_single_save_note"), add = TRUE)
      fast_checkpoint <- isTRUE(input$rds_single_export_fast_checkpoint %||% FALSE)
      if (!length(objs)) {
        showNotification(RDS_UI_TEXT$ui_text_error_no_datasets_export, type = "error")
        stop(RDS_UI_TEXT$ui_text_error_no_datasets_export_stop)
      }
      nm <- .current_single_export_name()
      if (!nzchar(nm) || is.null(objs[[nm]])) {
        showNotification(RDS_UI_TEXT$ui_text_select_at_least_one, type = "warning")
        stop("No valid object selected.")
      }
      entry <- .normalize_imported_entry(objs[[nm]])
      sobj <- if (is.list(entry)) entry$obj %||% NULL else NULL
      if (is.null(entry) || is.null(sobj) || !inherits(sobj, "Seurat")) {
        showNotification("Selected object is not a valid Seurat object.", type = "error")
        stop("Selected object is not Seurat.")
      }
      saveRDS(
        .build_workspace_bundle_payload(
          all_objects = setNames(list(entry), nm),
          active_object_name = nm
        ),
        file = file,
        compress = !fast_checkpoint
      )
    }
  )

  output$download_single_object_structure_txt_btn <- downloadHandler(
    filename = function() {
      nm <- .current_single_export_name()
      if (!nzchar(nm)) nm <- "selected_object"
      nm_safe <- gsub("[^A-Za-z0-9_]+", "_", nm)
      nm_safe <- gsub("^_+|_+$", "", nm_safe)
      if (!nzchar(nm_safe)) nm_safe <- "selected_object"
      paste0("Seurat_Object_Structure_Tree_", nm_safe, "_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".txt")
    },
    content = function(file) {
      objs <- shared_data$all_seurat_objects %||% list()
      .show_overlay(RDS_UI_TEXT$ui_text_overlay_preparing_rds_structure_report)
      on.exit(.hide_overlay(), add = TRUE)
      showNotification(RDS_UI_TEXT$ui_text_prepare_rds_structure_report, id = "rds_single_structure_note", type = "message")
      on.exit(removeNotification("rds_single_structure_note"), add = TRUE)
      if (!length(objs)) {
        showNotification(RDS_UI_TEXT$ui_text_error_no_datasets_export, type = "error")
        stop(RDS_UI_TEXT$ui_text_error_no_datasets_export_stop)
      }
      nm <- .current_single_export_name()
      if (!nzchar(nm) || is.null(objs[[nm]])) {
        showNotification(RDS_UI_TEXT$ui_text_select_at_least_one, type = "warning")
        stop("No valid object selected.")
      }
      entry <- .normalize_imported_entry(objs[[nm]])
      sobj <- if (is.list(entry)) entry$obj %||% NULL else NULL
      if (is.null(entry) || is.null(sobj) || !inherits(sobj, "Seurat")) {
        showNotification("Selected object is not a valid Seurat object.", type = "error")
        stop("Selected object is not Seurat.")
      }
      bundle <- .build_workspace_bundle_payload(
        all_objects = setNames(list(entry), nm),
        active_object_name = nm
      )
      writeLines(.rds_tree_report_lines(bundle), con = file, useBytes = TRUE)
    }
  )
  
  # =======================================================
  # Stage inference + Navbar Tab Gating
  # =======================================================
  .rds_gate_extract_seurat <- function(entry) {
    if (.is_seurat(entry)) return(entry)
    if (is.list(entry) && !is.null(entry$obj) && .is_seurat(entry$obj)) return(entry$obj)
    NULL
  }
  .rds_gate_detect_signals <- function(sobj) {
    assays <- tryCatch(Seurat::Assays(sobj), error = function(e) character())
    has_rna <- "RNA" %in% assays
    reds_low <- tryCatch(tolower(names(sobj@reductions)), error = function(e) character())
    has_umap <- "umap" %in% reds_low
    gnames_low <- tryCatch(tolower(names(sobj@graphs)), error = function(e) character())
    has_neighbors <- any(grepl("snn|knn|neighbors", gnames_low))
    idents_ok <- tryCatch({ ids <- Seurat::Idents(sobj); !is.null(ids) && length(levels(ids)) > 1 }, error = function(e) FALSE)
    md_low <- tryCatch(tolower(colnames(sobj@meta.data)), error = function(e) character())
    has_qc <- any(md_low %in% c("ncount_rna","nfeature_rna","percent.mt","pct_mt","mito","percent.mito"))
    has_doublet <- any(md_low %in% c("doublet_score","doublet_class","doublet_call","is_doublet"))
    list(reductions = list(umap = has_umap),
         neighbors = has_neighbors, idents = idents_ok,
         meta = list(qc = has_qc, doublet = has_doublet),
         assays = assays, has_rna = has_rna)
  }
  .rds_gate_infer_stage <- function(sig) {
    if (isTRUE(sig$neighbors) || isTRUE(sig$idents) || isTRUE(sig$reductions$umap)) return("clustered_analyzed")
    if (isTRUE(sig$meta$doublet)) return("post_doublet")
    if (isTRUE(sig$meta$qc)) return("qc_done")
    "raw_or_pre_qc"
  }
  .rds_gate_reduce_gates <- function(stages, force_enable = FALSE) {
    has_any <- length(stages) > 0
    gates <- list(
      rds_tab       = TRUE,
      qc_tab        = has_any,
      doublet_tab   = has_any,
      analysis_tab  = has_any,
      recluster_tab = has_any,
      export_tab    = has_any,
      export_vdj_safe_tab = has_any
    )
    if (force_enable) gates <- lapply(gates, function(x) TRUE)
    list(gates = gates, reasons = list())
  }
  
  .disable_tab <- function(id) shinyjs::runjs(sprintf(
    "$('a[data-value=%s]').addClass('disabled').on('click.rds_gate_block',function(e){e.preventDefault();return false;});",
    jsonlite::toJSON(id, auto_unbox = TRUE)
  ))
  .enable_tab <- function(id) shinyjs::runjs(sprintf(
    "$('a[data-value=%s]').removeClass('disabled').off('click.rds_gate_block');",
    jsonlite::toJSON(id, auto_unbox = TRUE)
  ))
  
  tab_ids <- list(
    rds_tab="rds_tab", qc_tab="qc_tab", doublet_tab="doublet_tab",
    analysis_tab="analysis_tab", recluster_tab="recluster_tab",
    export_tab="export_tab", export_vdj_safe_tab="export_vdj_safe_tab"
  )
  
  rds_gate_stages_rv <- reactiveVal(setNames(character(), character()))
  
  observe({
    # prefer committed objects; fall back to pending ones
    objs <- shared_data$all_seurat_objects
    if ((is.null(objs) || !length(objs)) && !is.null(rds_pending())) {
      objs <- rds_pending()$objs
    }
    if (is.null(objs) || !length(objs)) {
      rds_gate_stages_rv(setNames(character(), character()))
      return()
    }
    nm <- names(objs)
    st <- vapply(nm, function(n){
      sobj <- .rds_gate_extract_seurat(objs[[n]])
      if (is.null(sobj)) "uncertain" else .rds_gate_infer_stage(.rds_gate_detect_signals(sobj))
    }, FUN.VALUE = character(1))
    names(st) <- nm
    rds_gate_stages_rv(st)
  })
  
  rds_gate_gates <- reactive({
    .rds_gate_reduce_gates(rds_gate_stages_rv(), isTRUE(input$rds_gate_force_enable))
  })
  
  observe({
    g <- rds_gate_gates()$gates
    for (k in names(tab_ids)) {
      if (isTRUE(g[[k]])) .enable_tab(tab_ids[[k]]) else .disable_tab(tab_ids[[k]])
    }
  })
  
  output$rds_gate_legend_html <- renderUI({
    st <- rds_gate_stages_rv()
    if (!length(st)) return(HTML(RDS_UI_TEXT$ui_text_no_rds_imported_yet))
    levs <- c("raw_or_pre_qc","qc_done","post_doublet","clustered_analyzed","uncertain")
    counts <- table(factor(unname(st), levels = levs))
    val <- function(k) { x <- counts[[k]]; if (is.null(x) || is.na(x)) 0L else as.integer(x) }
    HTML(sprintf(
      "<div>
        <span class='badge bg-secondary me-1'>Raw: %d</span>
        <span class='badge bg-info me-1'>QC: %d</span>
        <span class='badge bg-primary me-1'>Doublet: %d</span>
        <span class='badge bg-success me-1'>Analyzed: %d</span>
        <span class='badge bg-dark'>Uncertain: %d</span>
      </div>",
      val("raw_or_pre_qc"), val("qc_done"), val("post_doublet"),
      val("clustered_analyzed"), val("uncertain")
    ))
  })
  
  output$rds_gate_stages_table <- DT::renderDataTable({
    st <- rds_gate_stages_rv()
    if (!length(st)) return(DT::datatable(data.frame(Object = character(), Stage = character())))
    df <- data.frame(Object = names(st), Stage = unname(st), check.names = FALSE)
    DT::datatable(df, rownames = FALSE, selection = "none",
                  options = list(dom = "t", paging = FALSE))
  }, server = FALSE)
  
  observeEvent(input$rds_gate_why_disabled, {
    rsn <- list()
    if (!length(rsn)) {
      showModal(modalDialog(title = RDS_UI_TEXT$ui_text_all_tabs_enabled, RDS_UI_TEXT$ui_text_no_gating_reasons_now, easyClose = TRUE))
    } else {
      msg <- paste(sprintf("<li><b>%s</b>: %s</li>", names(rsn), unlist(rsn)), collapse = "")
      showModal(modalDialog(title = RDS_UI_TEXT$ui_text_why_some_tabs_disabled,
                            HTML(sprintf("<ul>%s</ul>", msg)),
                            easyClose = TRUE))
    }
  })
  
  observeEvent(input$rds_show_diag, {
    if (isTRUE(input$rds_show_diag)) shinyjs::show("rds_diag_body") else shinyjs::hide("rds_diag_body")
  })
  
  # Metadata explorer sources
  .meta_source_objects <- reactive({
    objs <- shared_data$all_seurat_objects
    if ((is.null(objs) || !length(objs)) && !is.null(rds_pending())) objs <- rds_pending()$objs
    objs
  })
  
  observe({
    objs <- .meta_source_objects()
    if (is.null(objs) || !length(objs)) {
      updateSelectInput(session, "rds_meta_obj", choices = character(0), selected = NULL)
      return()
    }
    nm <- names(objs)
    cur <- isolate(input$rds_meta_obj)
    updateSelectInput(session, "rds_meta_obj", choices = nm,
                      selected = if (is.null(cur) || !(cur %in% nm)) nm[1] else cur)
  })
  
  output$rds_meta_table <- DT::renderDataTable({
    objs <- .meta_source_objects(); req(objs)
    nm <- input$rds_meta_obj; req(nm, nm %in% names(objs))
    sobj <- if (is.list(objs[[nm]]) && !is.null(objs[[nm]]$obj)) objs[[nm]]$obj else objs[[nm]]
    df <- .meta_overview(sobj)
    DT::datatable(
      df,
      rownames = FALSE,
      options = list(
        paging = FALSE,
        dom = "t",
        autoWidth = FALSE,
        scrollX = TRUE,
        columnDefs = list(
          list(targets = 5, render = DT::JS("function(data,type,row){ if(type==='display' && data!=null){ return '<div style=\"white-space:normal; line-height:1.3; max-width:900px;\">'+data+'</div>'; } return data; }"))
          )
        )
      )
  }, server = FALSE)
  
  output$rds_meta_snapshot_ui <- renderUI({
    objs <- .meta_source_objects(); req(objs)
    nm <- input$rds_meta_obj; req(nm, nm %in% names(objs))
    ent <- objs[[nm]]
    sobj <- if (is.list(ent) && !is.null(ent$obj)) ent$obj else ent
    sm <- .summarize_seurat(sobj)
    def_assay <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "—")
    obj_ver <- .detect_seurat_object_version(sobj)
    seurat_ver <- .scalar_chr(obj_ver$version %||% "unknown", default = "unknown")
    env_reco <- .scalar_chr(obj_ver$env %||% .env_from_seurat_version(seurat_ver), default = "unknown")
    sample_col <- sm$sample_guess %||% "—"
    samples <- if (length(sm$sample_names)) sm$sample_names else character(0)
    id_col <- sm$ident_guess %||% "—"
    
    div(
      div(
        span(class = "rds-meta-chip", sprintf(RDS_UI_TEXT$ui_text_meta_chip_cells, format(sm$n_cells, big.mark = ","))),
        span(class = "rds-meta-chip", sprintf(RDS_UI_TEXT$ui_text_meta_chip_meta_columns, sm$meta_ncols)),
        span(class = "rds-meta-chip", sprintf(RDS_UI_TEXT$ui_text_meta_chip_assays, nrow(sm$assay_table))),
        span(class = "rds-meta-chip", sprintf(RDS_UI_TEXT$ui_text_meta_chip_reductions, if (length(sm$reductions)) paste(sm$reductions, collapse = ", ") else "—")),
        span(class = "rds-meta-chip", sprintf(RDS_UI_TEXT$ui_text_meta_chip_default_assay, def_assay)),
        span(class = "rds-meta-chip", sprintf(RDS_UI_TEXT$ui_text_meta_chip_seurat, seurat_ver %||% "—")),
        span(class = "rds-meta-chip", sprintf(RDS_UI_TEXT$ui_text_meta_chip_target_environment, env_reco))
      ),
      div(class = "rds-kv", tags$b(RDS_UI_TEXT$ui_text_detected_sample_column), sample_col),
      div(class = "rds-kv", tags$b(RDS_UI_TEXT$ui_text_detected_identity_column), id_col),
      div(class = "rds-kv", tags$b(RDS_UI_TEXT$ui_text_detected_samples), if (length(samples)) paste(samples, collapse = ", ") else "—"),
      div(class = "rds-muted", RDS_UI_TEXT$ui_text_use_filters_metadata_table_below_quickly)
    )
  })
  
  output$rds_meta_signals_html <- renderUI({
    objs <- .meta_source_objects(); req(objs)
    nm <- input$rds_meta_obj; req(nm, nm %in% names(objs))
    sobj <- if (is.list(objs[[nm]]) && !is.null(objs[[nm]]$obj)) objs[[nm]]$obj else objs[[nm]]
    s <- .detect_meta_signals(sobj)
    
    badge <- function(lbl, n, cls) {
      tags$span(class = paste("badge", cls, "me-1"),
                sprintf("%s: %s", lbl, if (length(n)) length(n) else 0))
    }
    tagList(
      div(
        badge(RDS_UI_TEXT$ui_badge_dbr, s$dbr_cols, RDS_UI_TEXT$ui_text_bg_warning_text_dark),
        badge(RDS_UI_TEXT$ui_badge_cluster_labels, s$cluster_cols, "bg-secondary"),
        badge(RDS_UI_TEXT$ui_badge_resolutions, s$res_cols, "bg-info"),
        badge(RDS_UI_TEXT$ui_badge_samples, s$sample_cols, "bg-primary"),
        badge(RDS_UI_TEXT$ui_badge_qc, s$qc_cols, "bg-success"),
        badge(RDS_UI_TEXT$ui_badge_cell_cycle, s$cellcycle_cols, "bg-dark")
      ),
      tags$div(class="mt-2",
               HTML(sprintf(RDS_UI_TEXT$ui_text_resolutions_label_html,
                            if (length(s$res_values)) paste(sort(unique(s$res_values)), collapse = ", ") else "—")),
               HTML(sprintf(RDS_UI_TEXT$ui_text_reductions_label_html,
                            if (length(s$reductions)) paste(s$reductions, collapse = ", ") else "—")),
               HTML(sprintf(RDS_UI_TEXT$ui_text_neighbor_graphs_label_html,
                            if (length(s$graphs)) paste(s$graphs, collapse = ", ") else "—")),
               HTML(sprintf(RDS_UI_TEXT$ui_text_dbr_columns_label_html,
                            if (length(s$dbr_cols)) paste(s$dbr_cols, collapse = ", ") else "—")),
               HTML(sprintf(RDS_UI_TEXT$ui_text_cluster_columns_label_html,
                            if (length(s$cluster_cols)) paste(s$cluster_cols, collapse = ", ") else "—"))
      )
    )
  })
  
  output$rds_bundle_info_html <- renderUI({
    info <- rds_bundle_info()
    if (is.null(info)) {
      return(
        div(
          class = "rds-bundle-wrap",
          div(
            class = "rds-bundle-chiprow",
            span(class = "rds-bundle-chip", RDS_UI_TEXT$ui_text_pipeline),
            span(class = "rds-bundle-chip", RDS_UI_TEXT$ui_text_seurat),
            span(class = "rds-bundle-chip", RDS_UI_TEXT$ui_text_target_environment)
          ),
          div(class = "rds-bundle-note",
              RDS_UI_TEXT$ui_text_no_pipeline_metadata_found_file_likely)
        )
      )
    }
    pkgs <- info$package_versions %||% c()
    seurat_ver <- .scalar_chr(info$seurat_version %||% NA_character_, default = NA_character_)
    if (is.na(seurat_ver) || !nzchar(seurat_ver)) {
      seurat_ver <- .pkg_version_lookup(pkgs, "Seurat")
    }
    seurat_ver <- .scalar_chr(seurat_ver, default = "—")
    active_env <- .scalar_chr(info$active_environment %||% "unknown", default = "unknown")
    env_from_ver <- .env_from_seurat_version(seurat_ver)
    env_reco <- if (nzchar(active_env) && !identical(active_env, "unknown")) active_env else env_from_ver
    if (!nzchar(env_reco) || identical(env_reco, "unknown")) env_reco <- "unknown"
    mismatch_note <- !identical(active_env, "unknown") &&
      !identical(env_from_ver, "unknown") &&
      !identical(active_env, env_from_ver)
    pkg_names <- names(pkgs)
    if (is.null(pkg_names)) pkg_names <- character()
    
    core_pkg <- c("Seurat", "SeuratObject", "dplyr", "ggplot2", "edgeR", "DESeq2")
    core_present <- core_pkg[core_pkg %in% pkg_names]

    details_list <- if (length(core_present)) {
      tags$ul(
        lapply(core_present, function(pkg) tags$li(tags$b(paste0(pkg, RDS_UI_TEXT$ui_text_separator_colon_space)), as.character(pkgs[[pkg]])))
      )
    } else {
      tags$div(class = "rds-muted", RDS_UI_TEXT$ui_text_package_versions_not_found_bundle)
    }

    div(
      class = "rds-bundle-wrap",
      div(
        class = "rds-bundle-chiprow",
        span(class = "rds-bundle-chip", paste0(RDS_UI_TEXT$ui_text_pipeline_chip_prefix, .scalar_chr(info$pipeline_version %||% "—", default = "—"))),
        span(class = "rds-bundle-chip", paste0(RDS_UI_TEXT$ui_text_seurat_chip_prefix, seurat_ver)),
        span(class = "rds-bundle-chip", paste0(RDS_UI_TEXT$ui_text_target_environment_chip_prefix, env_reco))
      ),
      div(
        class = "rds-bundle-grid",
        div(class = "rds-bundle-kv", tags$b(RDS_UI_TEXT$ui_text_analysis_date), .scalar_chr(info$analysis_date %||% "—", default = "—")),
        div(class = "rds-bundle-kv", tags$b(RDS_UI_TEXT$ui_text_exported), .scalar_chr(info$exported_at %||% "—", default = "—")),
        div(class = "rds-bundle-kv", tags$b(RDS_UI_TEXT$ui_text_active_environment), .scalar_chr(info$active_environment %||% "—", default = "—")),
        div(class = "rds-bundle-kv", tags$b(RDS_UI_TEXT$ui_text_captured_package_versions), length(pkgs))
      ),
      if (isTRUE(mismatch_note)) {
        div(
          class = "rds-bundle-note",
          tags$b(RDS_UI_TEXT$ui_text_note),
          paste0(
            RDS_UI_TEXT$ui_text_mismatch_active_env_prefix,
            active_env,
            RDS_UI_TEXT$ui_text_mismatch_middle_but_seurat,
            seurat_ver,
            RDS_UI_TEXT$ui_text_mismatch_maps_to,
            env_from_ver,
            RDS_UI_TEXT$ui_text_mismatch_suffix_period
          )
        )
      },
      tags$details(
        class = "rds-bundle-details",
        tags$summary(tags$b(RDS_UI_TEXT$ui_text_key_package_versions)),
        details_list
      )
    )
  })
}
