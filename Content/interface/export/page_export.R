# R/page_loupe_ui.R

# ---------- helpers ----------

if (!exists(".wanlab_prepare_disk_backed_selection", mode = "function", inherits = TRUE)) {
  .wanlab_storage_helper_candidates <- c(
    file.path(getwd(), "interface", "shared", "large_data_storage_helpers.R"),
    file.path(getwd(), "Content", "interface", "shared", "large_data_storage_helpers.R"),
    file.path(dirname(getwd()), "Content", "interface", "shared", "large_data_storage_helpers.R")
  )
  .wanlab_storage_helper_path <- .wanlab_storage_helper_candidates[file.exists(.wanlab_storage_helper_candidates)][1]
  if (!is.na(.wanlab_storage_helper_path) && nzchar(.wanlab_storage_helper_path)) {
    source(.wanlab_storage_helper_path, local = .GlobalEnv)
  }
}

# Modal to show errors/logs (optional but handy)
EXPORT_UI_TEXT <- list(
  # Page title and intro
  ui_title_export = "Export to Loupe Browser",
  ui_title_export_loupe_section = "Loupe Browser",
  ui_title_loupe_browser = "To Loupe Browser",
  ui_text_select_dataset_export_format_you_can = "Select a dataset and an export format. You can generate a .cloupe file for visualization in the Loupe Browser or save the processed Seurat object as an .rds file for future R sessions.",
  ui_text_select_dataset_export = "Select Dataset to Export:",
  ui_text_export_selected_object_class_prefix = "Selected object class:",
  ui_text_export_selected_object_class_prefix_h5ad = "Selected h5ad object class:",

  # Sidebar controls
  ui_title_download_options = "Download Options",
  ui_text_generated_file_will_contain_umap_coordinates = "The generated file will include all valid 2D embeddings (UMAP/tSNE/etc.) and all valid sanitized metadata as Loupe groupings.",
  ui_label_assay_select = "Assay to export:",
  ui_text_enter_desired_filename_cloupe = "Enter desired filename (.cloupe):",
  ui_text_default_export_filename_prefix = "seurat_analysis_",
  ui_text_generate_download_cloupe_file = "Generate and Download .cloupe File",
  ui_text_generate_download_h5ad_file = "Generate and Download .h5ad File",
  ui_label_drop_invalid_cells = "If needed, remove Loupe-incompatible or duplicate barcode labels before export",
  ui_text_barcode_check_passed = "Barcode check passed: all %d cell labels are accepted by LoupeR.",
  ui_text_barcode_check_warning = "Warning: %d cell(s) have barcode labels that LoupeR will reject.",
  ui_text_barcode_duplicate_warning = "Warning: %d cell(s) create %d duplicated barcode label(s).",
  ui_text_barcode_check_retained = "Export will retain %d of %d cells.",
  ui_text_barcode_check_examples = "Examples: %s",
  ui_text_barcode_check_enable_option = "Enable the checkbox above to remove incompatible or duplicate cells before export.",
  ui_text_barcode_check_ready_after_removal = "The checkbox is enabled. These cells will be removed before export.",
  ui_text_barcode_check_error_prefix = "Barcode check could not run:",
  ui_text_enter_desired_filename_h5ad = "Enter desired filename (.h5ad):",
  ui_text_default_export_h5ad_filename_prefix = "seurat_cellxgene_",
  ui_title_h5ad_export = "h5ad Export for Cellxgene",
  ui_title_h5ad_export_section = "h5ad (CELLxGENE)",
  ui_title_h5ad_download_options = "h5ad Download Options",
  ui_title_h5ad_compatibility_notes = "Cellxgene Compatibility Notes",
  ui_text_h5ad_section_intro = "Export an h5ad file for Cellxgene workflows. This section uses its own object selector and does not change Loupe export settings.",
  ui_label_h5ad_profile_select = "h5ad export profile:",
  ui_choice_h5ad_profile_strict = "Cellxgene strict",
  ui_choice_h5ad_profile_minimal = "Minimal generic h5ad",
  ui_text_h5ad_notes_strict_1 = "Strict profile includes full metadata from the selected object.",
  ui_text_h5ad_notes_strict_2 = "Strict profile adds UMAP as X_umap when UMAP is available.",
  ui_text_h5ad_notes_strict_3 = "Strict profile includes available 2D reductions and raw counts when present.",
  ui_text_h5ad_notes_minimal_1 = "Minimal profile writes a broadly valid h5ad with core expression data.",
  ui_title_assay_notes = "Assay Selection Notes",
  ui_note_title_selection = "Assay selection for Loupe export",
  ui_note_assay_rna = "RNA: Best when you want raw-count-oriented expression context and straightforward biological interpretation.",
  ui_note_assay_sct = "SCT: Useful for variance-stabilized expression and can improve separation of subtle structure in some datasets.",
  ui_note_title_tasks = "How this relates to common tasks",
  ui_note_task_feature = "Feature Plot: SCT is often preferred for cleaner visualization, but it is not required; compare with RNA when needed.",
  ui_note_task_deg = "For DEG: Prefer RNA-based expression for marker interpretation and reporting.",
  ui_note_task_recluster = "For reclustering: SCT can be helpful when technical noise is high or clusters are weakly separated.",
  ui_note_title_recluster = "Reclustering basics",
  ui_note_recluster_1 = "Reclustering means subsetting a population, recomputing neighbors/UMAP, and finding finer subclusters.",
  ui_note_recluster_2 = "Use it when a broad cluster appears to contain mixed cell states/lineages.",
  ui_note_recluster_3 = "Validate reclustered groups with marker genes, sample composition, and metadata consistency.",
  ui_note_recluster_4 = "Avoid over-clustering; very high resolution can produce unstable or weakly supported groups.",

  # Instructions block
  ui_title_instructions = "Instructions",
  ui_text_enter_your_desired_filename_text_box = "Enter your desired filename in the text box.",
  ui_text_click_generate_download_button = "Click the 'Generate and Download' button.",
  ui_text_process_may_take_several_minutes_large_datasets = "The process may take several minutes for large datasets.",
  ui_text_browser_will_prompt_choose_location_save_file = "Your browser will prompt you to choose a location to save the file.",
  ui_text_download_install_loupe_browser_10x_genomics_website_view_file = "Download and install the Loupe Browser from the 10x Genomics website to view the file.",

  # Figure Studio cross-link
  ui_title_publishable_pdfs = "Publishable PDF Export",
  ui_title_figure_studio_access = "Figure Studio Access",
  ui_text_publishable_pdf_available_in_figure_studio = "Publishable PDF export is now available in Figure Studio.",
  ui_text_pdf_launch_card_intro = "Launch Figure Studio to build and export publication-ready PDF figures.",
  ui_text_pdf_instruction_open_figure_studio = "Click the 'Open Figure Studio' button.",
  ui_text_pdf_instruction_select_plot_type = "Choose your figure type (UMAP, Feature, or DotPlot).",
  ui_text_pdf_instruction_style_plot = "Adjust labels, colors, and layout for your publication format.",
  ui_text_pdf_instruction_export_pdf = "Use the export controls in Figure Studio to generate your PDF.",
  ui_text_pdf_instruction_repeat = "Repeat for additional panels if you are preparing a multi-figure set.",
  ui_button_open_figure_studio = "Open Figure Studio",
  ui_error_no_datasets_available = "No datasets are available to export.",
  ui_error_registry_invalid = "Export datasets are temporarily unavailable because the workspace registry is not a valid object list.",
  ui_error_select_dataset = "Please select a dataset to export.",
  ui_error_selected_dataset_missing = "Selected dataset is no longer available. Please reselect a dataset and try again.",

  # Notifications and modal text
  ui_notification_generating_cloupe = "Generating .cloupe file...",
  ui_progress_starting_loupe = "Starting Loupe export...",
  ui_progress_preparing_loupe = "Preparing Loupe export...",
  ui_progress_preparing_disk_backed = "Preparing disk-backed count data...",
  ui_progress_validating_barcodes = "Checking barcode labels...",
  ui_progress_extracting_loupe = "Preparing matrix, clusters, and projections...",
  ui_progress_validating_count_matrix = "Validating count matrix...",
  ui_progress_validating_clusters = "Validating clusters...",
  ui_progress_validating_projections = "Validating projections...",
  ui_progress_writing_hdf5 = "Writing temporary export data...",
  ui_progress_building_loupe = "Building .cloupe file...",
  ui_progress_validating_loupe_input = "Validating Loupe input...",
  ui_progress_initializing_loupe_file = "Initializing .cloupe file...",
  ui_progress_converting_loupe_counts = "Writing count data...",
  ui_progress_converting_loupe_projections = "Writing projections...",
  ui_progress_converting_loupe_clusters = "Writing groupings...",
  ui_progress_finishing_loupe = "Finishing .cloupe file...",
  ui_progress_copying_loupe = "Copying .cloupe file...",
  ui_progress_finalizing_loupe = "Finalizing Loupe export...",
  ui_notification_generating_h5ad = "Generating .h5ad file...",
  ui_notification_error_generating_file_prefix = "Error generating file:",
  ui_text_export_failed_title_details = "Export failed - details",
  ui_text_export_failed_debug_info = "The export failed. Copy any info below if you need to debug further.",
  ui_text_export_failed_modal_separator = "-------------------------------------------------------------------",
  ui_text_error_prefix = "ERROR: ",
  ui_button_close = "Close"
)

.show_export_error_modal <- function(title, lines) {
  shiny::showModal(
    shiny::modalDialog(
      title = title,
      easyClose = TRUE,
      size = "l",
      footer = tagList(shiny::modalButton(EXPORT_UI_TEXT$ui_button_close)),
      tags$div(
        style = "max-height: 60vh; overflow-y: auto;",
        tags$pre(paste(lines, collapse = "\n"))
      )
    )
  )
}

.export_registry_entries <- function(shared_data) {
  reg <- tryCatch(shared_data$all_seurat_objects, error = function(e) NULL)
  if (is.null(reg)) return(list())
  if (!is.list(reg) || is.data.frame(reg)) {
    stop(EXPORT_UI_TEXT$ui_error_registry_invalid)
  }
  reg
}

.export_object_choices <- function(shared_data) {
  reg <- .export_registry_entries(shared_data)
  nm <- names(reg)
  if (is.null(nm)) return(character(0))
  nm <- as.character(nm)
  unique(nm[!is.na(nm) & nzchar(nm)])
}

.export_selected_entry <- function(shared_data, object_name) {
  object_name <- if (length(object_name)) as.character(object_name[[1]]) else ""
  object_name <- trimws(object_name)
  if (!nzchar(object_name)) stop(EXPORT_UI_TEXT$ui_error_select_dataset)
  
  reg <- .export_registry_entries(shared_data)
  if (!length(reg)) stop(EXPORT_UI_TEXT$ui_error_no_datasets_available)
  
  idx <- match(object_name, names(reg))
  if (is.na(idx)) stop(EXPORT_UI_TEXT$ui_error_selected_dataset_missing)
  reg[[idx]]
}

# Unwrap whatever we got into a Seurat object
.as_seurat_or_fail <- function(x) {
  if (inherits(x, "Seurat")) return(x)
  
  if (is.list(x)) {
    # common names first
    for (nm in c("seurat", "seurat_obj", "object", "obj", "data", "dataset")) {
      if (!is.null(x[[nm]]) && inherits(x[[nm]], "Seurat")) return(x[[nm]])
    }
    # otherwise first Seurat in list
    idx <- which(vapply(x, function(e) inherits(e, "Seurat"), logical(1)))
    if (length(idx)) return(x[[idx[1]]])
  }
  
  if (is.function(x)) {
    y <- try(x(), silent = TRUE)
    if (!inherits(y, "try-error")) return(.as_seurat_or_fail(y))
  }
  
  stop("Selected item is not (or does not contain) a Seurat object.")
}

# Pick an assay that actually has counts with dimnames
.assays_with_counts <- function(obj) {
  has_counts <- function(o, assay) {
    m <- try(Seurat::GetAssayData(o, assay = assay, slot = "counts"), silent = TRUE)
    !inherits(m, "try-error") && nrow(m) > 0 && ncol(m) > 0 &&
      !is.null(rownames(m)) && !is.null(colnames(m))
  }
  assays <- SeuratObject::Assays(obj)
  ordered <- unique(c("RNA", "SCT", assays))
  keep <- vapply(ordered, function(a) a %in% assays && has_counts(obj, a), logical(1))
  ordered[keep]
}

.loupe_export_assay_cells <- function(obj, assay_name) {
  assay_name <- trimws(as.character(assay_name %||% ""))
  assays <- tryCatch(SeuratObject::Assays(obj), error = function(e) character(0))
  if (!nzchar(assay_name) || !(assay_name %in% assays)) {
    stop("Selected assay is unavailable for Loupe barcode checking: ", assay_name)
  }
  cells <- tryCatch(colnames(obj[[assay_name]]), error = function(e) NULL)
  cells <- as.character(cells %||% character(0))
  if (!length(cells)) {
    counts <- tryCatch(Seurat::GetAssayData(obj, assay = assay_name, slot = "counts"), error = function(e) NULL)
    cells <- as.character(colnames(counts) %||% character(0))
  }
  if (!length(cells)) stop("Selected assay has no cell names for Loupe barcode checking.")
  cells
}

.pick_assay_with_counts <- function(obj) {
  picks <- .assays_with_counts(obj)
  if (!length(picks)) return(NULL)
  picks[[1]]
}

# Sanitize ALL metadata: keep atomic/factor, coerce to character where needed,
# replace blanks/NA with "Unknown", and produce safe column names.
.sanitize_metadata <- function(obj) {
  md <- obj@meta.data
  
  if (!"seurat_clusters" %in% colnames(md)) {
    obj$seurat_clusters <- SeuratObject::Idents(obj)
    md <- obj@meta.data
  }
  
  keep_cols <- names(md)[vapply(md, function(v) is.atomic(v) || is.factor(v), logical(1))]
  md2 <- if (length(keep_cols)) {
    md[, keep_cols, drop = FALSE]
  } else {
    md[, 0, drop = FALSE]
  }
  
  md2[] <- lapply(md2, function(v) {
    if (is.factor(v)) v <- as.character(v)
    if (inherits(v, "POSIXt") || inherits(v, "Date")) v <- as.character(v)
    if (is.logical(v)) v <- ifelse(v, "TRUE", "FALSE")
    if (is.numeric(v)) v <- as.character(v)
    v[is.na(v) | trimws(v) == ""] <- "Unknown"
    v
  })
  
  safe <- make.unique(gsub("[^A-Za-z0-9_]+", "_", colnames(md2)), sep = "_")
  
  # attach the sanitized columns back to the object under safe names
  for (i in seq_along(safe)) obj[[ safe[i] ]] <- md2[[ i ]]
  
  list(obj = obj, md_cols = safe)
}

.extract_raw_10x_barcode <- function(x) {
  x <- as.character(x %||% "")
  x <- trimws(x)
  out <- rep(NA_character_, length(x))
  for (i in seq_along(x)) {
    xi <- x[[i]]
    if (!nzchar(xi)) next
    m <- regexec("(?i)(?:^|[_:])([ACGT]{16}(?:-[0-9]+)?)(?=$|[_:])", xi, perl = TRUE)
    reg <- regmatches(xi, m)[[1]]
    if (length(reg) >= 2 && nzchar(reg[[2]])) {
      out[[i]] <- toupper(reg[[2]])
      next
    }
    m2 <- regexec("(?i)([ACGT]{16}(?:-[0-9]+)?)", xi, perl = TRUE)
    reg2 <- regmatches(xi, m2)[[1]]
    if (length(reg2) >= 2 && nzchar(reg2[[2]])) out[[i]] <- toupper(reg2[[2]])
  }
  out
}


# Agent note: These patterns mirror loupeR 1.1.5 validate_barcodes() in both
# managed Seurat v4/v5 environments. Keep preflight and worker validation on
# same final labels so valid non-10x modalities do not trigger false warnings.
.LOUPE_R_BARCODE_PATTERNS <- c(
  dna = "^(.*[:_])?([ACGT]{14,})([:_].*)?$",
  dna_gem = "^(.*[:_])?([ACGT]{14,})-([0-9]+)([:_].*)?$",
  visium_hd = "^(.*[:_])?(s_[0-9]{3}um_[0-9]{5}_[0-9]{5})([:_].*)?$",
  visium_hd_gem = "^(.*[:_])?(s_[0-9]{3}um_[0-9]{5}_[0-9]{5})-([0-9]+)([:_].*)?$",
  xenium = "^(.*[:_])?([a-p]{1,8})-([0-9]+)([:_].*)?$",
  loupe_cell = "^(.*[:_])?(cellid_[0-9]{9})([:_].*)?$",
  loupe_cell_gem = "^(.*[:_])?(cellid_[0-9]{9})-([0-9]+)([:_].*)?$"
)

.valid_louper_barcode <- function(x) {
  vals <- as.character(x %||% character(0))
  vapply(vals, function(value) {
    if (is.na(value) || !nzchar(value)) return(FALSE)
    any(vapply(.LOUPE_R_BARCODE_PATTERNS, function(pattern) {
      isTRUE(grepl(pattern, value, perl = TRUE))
    }, logical(1)))
  }, logical(1))
}

.dedupe_tokens <- function(x) {
  x <- trimws(as.character(x %||% character(0)))
  x <- x[nzchar(x)]
  if (!length(x)) return(character(0))
  x[!duplicated(toupper(x))]
}

.normalize_louper_barcode_label <- function(x) {
  x <- trimws(as.character(x %||% ""))
  if (is.na(x) || !nzchar(x)) return("")
  parts <- unlist(strsplit(x, "[_:]+", perl = TRUE), use.names = FALSE)
  parts <- trimws(as.character(parts))
  parts <- parts[nzchar(parts)]
  if (!length(parts)) return("")

  core_idx <- NA_integer_
  core <- NA_character_
  extra_numeric_suffix <- character(0)
  for (i in seq_along(parts)) {
    token <- parts[[i]]
    m <- regexec("(?i)^([ACGT]{16}(?:-[0-9]+)?)(?:-([0-9]+))?$", token, perl = TRUE)
    reg <- regmatches(token, m)[[1]]
    if (length(reg) >= 2 && nzchar(reg[[2]])) {
      core_idx <- i
      core <- toupper(reg[[2]])
      if (length(reg) >= 3 && nzchar(reg[[3]])) extra_numeric_suffix <- reg[[3]]
      break
    }
  }
  if (is.na(core_idx) || !nzchar(core)) {
    if (isTRUE(.valid_louper_barcode(x))) return(x)
    core <- .extract_raw_10x_barcode(x)
    if (!length(core) || is.na(core[[1]]) || !nzchar(core[[1]])) return("")
    core <- core[[1]]
    return(core)
  }

  prefix_tokens <- parts[seq_len(core_idx - 1L)]
  suffix_tokens <- if (core_idx < length(parts)) parts[(core_idx + 1L):length(parts)] else character(0)
  suffix_tokens <- c(suffix_tokens, extra_numeric_suffix)
  prefix_tokens <- .dedupe_tokens(prefix_tokens)
  suffix_tokens <- .dedupe_tokens(suffix_tokens)

  # User rule: move prefix to suffix and keep duplicate tokens only once.
  moved_suffix <- .dedupe_tokens(c(prefix_tokens, suffix_tokens))
  if (!length(moved_suffix)) return(core)
  paste0(core, "_", paste0(moved_suffix, collapse = "_"))
}

.find_best_louper_barcode_column <- function(md, cells) {
  if (is.null(md) || !is.data.frame(md) || !length(cells)) return(NULL)
  cn <- colnames(md)
  if (is.null(cn) || !length(cn)) return(NULL)
  preferred <- c("barcode_10x_raw", "cell_barcode", "barcode", "barcodes", "cell_id", "cell")
  candidate <- unique(c(preferred[preferred %in% cn], cn[grepl("barcode|cell", cn, ignore.case = TRUE)]))
  candidate <- candidate[candidate %in% cn]
  if (!length(candidate)) return(NULL)

  best <- NULL
  diag_rows <- vector("list", length(candidate))
  for (i in seq_along(candidate)) {
    col <- candidate[[i]]
    vals <- tryCatch(as.character(md[cells, col]), error = function(e) rep("", length(cells)))
    vals <- vapply(vals, .normalize_louper_barcode_label, character(1))
    ok <- .valid_louper_barcode(vals)
    n_valid <- sum(ok, na.rm = TRUE)
    n_unique_valid <- length(unique(vals[ok]))
    diag_rows[[i]] <- data.frame(col = col, n_valid = n_valid, n_unique_valid = n_unique_valid, stringsAsFactors = FALSE)
    if (is.null(best)) {
      best <- list(col = col, vals = vals, n_valid = n_valid, n_unique_valid = n_unique_valid)
    } else if (n_valid > best$n_valid || (n_valid == best$n_valid && n_unique_valid > best$n_unique_valid)) {
      best <- list(col = col, vals = vals, n_valid = n_valid, n_unique_valid = n_unique_valid)
    }
  }
  list(best = best, diag = do.call(rbind, diag_rows))
}

.derive_export_barcodes <- function(obj, cells, drop_invalid_cells = FALSE, diagnose_only = FALSE) {
  cells <- as.character(cells %||% character(0))
  if (!length(cells)) stop("Export aborted: no cells found in selected assay count matrix.")
  md <- tryCatch(obj@meta.data, error = function(e) NULL)
  raw <- rep(NA_character_, length(cells))
  canon <- rep("", length(cells))
  if (is.data.frame(md) && "barcode_10x_raw" %in% colnames(md)) {
    raw_md <- tryCatch(as.character(md[cells, "barcode_10x_raw"]), error = function(e) rep(NA_character_, length(cells)))
    raw <- raw_md
  }
  if (is.data.frame(md) && "barcode_current" %in% colnames(md)) {
    current_md <- tryCatch(as.character(md[cells, "barcode_current"]), error = function(e) rep("", length(cells)))
    canon <- vapply(current_md, .normalize_louper_barcode_label, character(1))
  }
  canon_miss <- !nzchar(canon)
  if (any(canon_miss)) canon[canon_miss] <- vapply(cells[canon_miss], .normalize_louper_barcode_label, character(1))
  miss <- is.na(raw) | !nzchar(trimws(raw))
  barcode_col_diag <- NULL
  if (any(miss) && is.data.frame(md)) {
    picked <- .find_best_louper_barcode_column(md, cells)
    if (!is.null(picked) && !is.null(picked$best) && isTRUE(picked$best$n_valid > 0L)) {
      raw[miss] <- picked$best$vals[miss]
      barcode_col_diag <- picked
    } else {
      barcode_col_diag <- picked
    }
  }
  miss <- is.na(raw) | !nzchar(trimws(raw))
  if (any(miss)) raw[miss] <- .extract_raw_10x_barcode(canon[miss])
  miss2 <- is.na(raw) | !nzchar(trimws(raw))
  if (any(miss2)) raw[miss2] <- .extract_raw_10x_barcode(cells[miss2])
  raw <- vapply(raw, .normalize_louper_barcode_label, character(1))
  exp_bc <- canon
  missing_canon <- is.na(exp_bc) | !nzchar(trimws(exp_bc))
  exp_bc[missing_canon] <- raw[missing_canon]
  exp_bc <- trimws(as.character(exp_bc))
  ok <- .valid_louper_barcode(exp_bc)
  duplicate_mask <- rep(FALSE, length(exp_bc))
  valid_idx <- which(ok)
  if (length(valid_idx)) {
    valid_labels <- exp_bc[valid_idx]
    duplicate_mask[valid_idx] <- duplicated(valid_labels) | duplicated(valid_labels, fromLast = TRUE)
  }
  duplicate_drop <- rep(FALSE, length(exp_bc))
  if (length(valid_idx)) duplicate_drop[valid_idx] <- duplicated(exp_bc[valid_idx])
  if (isTRUE(diagnose_only)) {
    return(list(
      cells = cells,
      labels = exp_bc,
      compatible = ok,
      duplicate = duplicate_mask,
      keep = ok & !duplicate_drop,
      invalid_examples = unique(head(exp_bc[!ok], 5)),
      duplicate_examples = unique(head(exp_bc[duplicate_mask], 5)),
      barcode_col_diag = barcode_col_diag
    ))
  }
  if (any(!ok) && !isTRUE(drop_invalid_cells)) {
    stop(
      sprintf(
        "Loupe-incompatible barcode labels for %d cell(s). Example values: %s. Enable 'remove cells with Loupe-incompatible barcode labels before export' to continue.",
        sum(!ok),
        paste(head(exp_bc[!ok], 5), collapse = ", ")
      )
    )
  }
  keep <- ok
  if (!any(keep)) stop("No cells with Loupe-compatible barcode labels are available for export.")
  exp_bc <- exp_bc[keep]
  kept_cells <- cells[keep]
  dup_mask <- duplicated(exp_bc) | duplicated(exp_bc, fromLast = TRUE)
  if (any(dup_mask) && !isTRUE(drop_invalid_cells)) {
    dup_vals <- unique(exp_bc[dup_mask])
    stop(
      sprintf(
        "Export requires unique barcode labels, but found %d duplicated label(s). Example duplicates: %s. Enable 'remove cells with Loupe-incompatible barcode labels before export' to drop conflicting cells and continue.",
        length(dup_vals),
        paste(head(dup_vals, 5), collapse = ", ")
      )
    )
  }
  if (any(dup_mask) && isTRUE(drop_invalid_cells)) {
    keep_unique <- !duplicated(exp_bc)
    exp_bc <- exp_bc[keep_unique]
    kept_cells <- kept_cells[keep_unique]
  }
  list(
    barcodes = exp_bc,
    kept_cells = kept_cells
  )
}

.loupe_export_barcode_issue_lines <- function(preview) {
  lines <- character(0)
  n_invalid <- sum(!preview$compatible)
  if (n_invalid > 0L) {
    lines <- c(
      lines,
      sprintf(EXPORT_UI_TEXT$ui_text_barcode_check_warning, n_invalid),
      sprintf(
        EXPORT_UI_TEXT$ui_text_barcode_check_examples,
        paste(preview$invalid_examples, collapse = ", ")
      )
    )
  }
  duplicate_labels <- unique(preview$labels[preview$duplicate])
  n_duplicate_cells <- sum(preview$duplicate)
  if (n_duplicate_cells > 0L) {
    lines <- c(
      lines,
      sprintf(EXPORT_UI_TEXT$ui_text_barcode_duplicate_warning, n_duplicate_cells, length(duplicate_labels)),
      sprintf(
        EXPORT_UI_TEXT$ui_text_barcode_check_examples,
        paste(head(duplicate_labels, 5), collapse = ", ")
      )
    )
  }
  lines <- c(
    lines,
    sprintf(EXPORT_UI_TEXT$ui_text_barcode_check_retained, sum(preview$keep), length(preview$labels))
  )
  lines
}

# Candidate feature TSV paths near 10x imports.
.candidate_feature_tsv_paths <- function(path) {
  p <- trimws(as.character(path %||% ""))
  if (!nzchar(p)) return(character(0))
  dirs <- character(0)
  if (dir.exists(p)) {
    dirs <- c(dirs, p)
  } else if (file.exists(p)) {
    d1 <- dirname(p)
    d2 <- dirname(d1)
    dirs <- c(dirs, d1, d2)
  }
  dirs <- unique(normalizePath(dirs[dir.exists(dirs)], mustWork = FALSE))
  if (!length(dirs)) return(character(0))
  
  leafs <- c(
    "",
    "filtered_feature_bc_matrix",
    "raw_feature_bc_matrix",
    "outs",
    file.path("outs", "filtered_feature_bc_matrix"),
    file.path("outs", "raw_feature_bc_matrix")
  )
  names_try <- c("features.tsv.gz", "features.tsv", "genes.tsv.gz", "genes.tsv")
  
  out <- character(0)
  for (d in dirs) {
    for (leaf in leafs) {
      dd <- if (nzchar(leaf)) file.path(d, leaf) else d
      for (nm in names_try) out <- c(out, file.path(dd, nm))
    }
  }
  unique(out)
}

.extract_feature_ids <- function(obj, sel_name = NULL, sel_entry = NULL, shared_data = NULL, assay_name = NULL, target_feature_count = NULL) {
  if (!requireNamespace("loupeR", quietly = TRUE)) return(NULL)
  
  src_paths <- character(0)
  entry_meta <- list()
  if (is.list(sel_entry)) {
    meta <- sel_entry$meta %||% list()
    entry_meta <- meta
    src_paths <- c(
      src_paths,
      as.character(meta$source_path %||% ""),
      as.character(meta$path %||% ""),
      as.character(meta$input_path %||% "")
    )
  }
  
  if (is.list(shared_data) || inherits(shared_data, "reactivevalues")) {
    ss <- tryCatch(shared_data$full_sample_sheet, error = function(e) NULL)
    if (is.data.frame(ss) && nrow(ss) && all(c("name", "path") %in% colnames(ss))) {
      wanted <- unique(c(
        as.character(sel_name %||% ""),
        as.character(entry_meta$parent %||% ""),
        as.character(entry_meta$parents %||% "")
      ))
      wanted <- wanted[nzchar(wanted)]
      if (length(wanted)) {
        hit <- ss[as.character(ss$name) %in% wanted, , drop = FALSE]
        src_paths <- c(src_paths, as.character(hit$path %||% character(0)))
      }
    }
  }
  
  misc <- tryCatch(obj@misc, error = function(e) NULL)
  if (is.list(misc)) {
    src_paths <- c(
      src_paths,
      as.character(misc$source_path %||% ""),
      as.character(misc$input_path %||% ""),
      as.character(misc$matrix_dir %||% "")
    )
  }
  
  src_paths <- unique(src_paths[nzchar(src_paths)])
  if (!length(src_paths)) return(NULL)
  
  cand_files <- unique(unlist(lapply(src_paths, .candidate_feature_tsv_paths), use.names = FALSE))
  cand_files <- cand_files[file.exists(cand_files)]
  if (!length(cand_files)) return(NULL)
  
  assay_name <- trimws(as.character(assay_name %||% ""))
  assay_obj <- if (nzchar(assay_name) && assay_name %in% SeuratObject::Assays(obj)) {
    obj[[assay_name]]
  } else {
    picked <- loupeR::select_assay(obj)
    if (is.null(picked)) NULL else picked[[1]]
  }
  if (is.null(assay_obj)) return(NULL)
  # Agent note: Reuse the already extracted count-matrix row count when the
  # caller has it. Re-extracting a large matrix here creates an avoidable peak.
  target_n <- suppressWarnings(as.numeric(target_feature_count))
  if (length(target_n) != 1L || is.na(target_n) || !is.finite(target_n) || target_n < 1) {
    target_n <- nrow(loupeR::counts_matrix_from_assay(assay_obj))
  }
  target_n <- as.integer(target_n)
  for (f in cand_files) {
    ids <- tryCatch(loupeR::read_feature_ids_from_tsv(f), error = function(e) NULL)
    if (is.null(ids)) next
    ids <- as.character(ids)
    if (length(ids) != target_n) next
    if (length(unique(ids)) != length(ids)) next
    if (!all(nzchar(ids))) next
    return(ids)
  }
  NULL
}

.loupe_worker_entry <- function(sel) {
  if (!is.list(sel) || !is.list(sel$meta)) return(NULL)
  keep <- intersect(
    names(sel$meta),
    c("source_path", "path", "input_path", "parent", "parents")
  )
  list(meta = sel$meta[keep])
}

.loupe_worker_object <- function(sel, assay_name = NULL, progress_cb = NULL) {
  emit_progress <- function(text, pct) {
    if (!is.function(progress_cb)) return(invisible(NULL))
    try(progress_cb(text = text, pct = pct), silent = TRUE)
    invisible(NULL)
  }
  obj <- .as_seurat_or_fail(sel)
  assay_choices <- .assays_with_counts(obj)
  if (!length(assay_choices)) stop("No assay with usable count matrix found.")
  assay_name <- trimws(as.character(assay_name %||% ""))
  if (!nzchar(assay_name)) assay_name <- assay_choices[[1]]
  if (!(assay_name %in% assay_choices)) {
    stop("Selected assay is unavailable for Loupe export: ", assay_name)
  }
  emit_progress("Preparing lightweight Loupe worker payload...", 21)

  assay_obj <- obj[[assay_name]]
  is_v5_assay <- inherits(assay_obj, c("Assay5", "StdAssay"))
  counts <- tryCatch(
    if (isTRUE(is_v5_assay)) assay_obj$counts else assay_obj@counts,
    error = function(e) NULL
  )
  if (is.null(counts) || nrow(counts) < 1L || ncol(counts) < 1L) {
    stop("Selected assay has no usable count matrix.")
  }
  old_cells <- as.character(colnames(counts) %||% character(0))
  if (!length(old_cells) || anyNA(old_cells)) stop("Selected assay has invalid cell names.")

  # Agent note: Worker object intentionally contains only export inputs. Keep
  # original object authoritative; this copy prevents unused assays, layers,
  # graphs, commands, and high-dimensional loadings from crossing the process
  # boundary and causing avoidable vector-size/memory peaks.
  metadata <- tryCatch(obj@meta.data, error = function(e) NULL)
  if (!is.data.frame(metadata)) stop("Selected object has invalid metadata.")
  if (!"seurat_clusters" %in% colnames(metadata)) {
    source_ident <- tryCatch(SeuratObject::Idents(obj), error = function(e) NULL)
    if (!is.null(source_ident) && length(source_ident) == nrow(metadata)) {
      ident_names <- names(source_ident)
      if (is.null(ident_names)) ident_names <- rownames(metadata)
      ident_idx <- match(rownames(metadata), ident_names)
      if (!anyNA(ident_idx)) metadata$seurat_clusters <- source_ident[ident_idx]
    }
  }
  keep_cols <- names(metadata)[vapply(metadata, function(v) is.atomic(v) || is.factor(v), logical(1))]
  metadata <- if (length(keep_cols)) metadata[, keep_cols, drop = FALSE] else metadata[, 0, drop = FALSE]
  metadata[] <- lapply(metadata, function(v) {
    if (is.factor(v)) v <- as.character(v)
    if (inherits(v, "POSIXt") || inherits(v, "Date")) v <- as.character(v)
    if (is.logical(v)) v <- ifelse(v, "TRUE", "FALSE")
    if (is.numeric(v)) v <- as.character(v)
    v[is.na(v) | trimws(v) == ""] <- "Unknown"
    v
  })
  colnames(metadata) <- make.unique(gsub("[^A-Za-z0-9_]+", "_", colnames(metadata)), sep = "_")
  if (nrow(metadata) != length(old_cells)) {
    stop("Metadata row count does not match selected assay cells.")
  }
  metadata <- metadata[old_cells, , drop = FALSE]
  project_name <- tryCatch(as.character(obj@project.name), error = function(e) "")
  project_name <- project_name[1]
  if (!length(project_name) || is.na(project_name) || !nzchar(project_name)) {
    project_name <- "LoupeExport"
  }
  worker_obj <- Seurat::CreateSeuratObject(
    counts = counts,
    assay = assay_name,
    meta.data = metadata,
    project = project_name
  )
  if (!identical(as.character(colnames(worker_obj)), old_cells)) {
    stop("Worker object cell names do not match selected assay cells.")
  }
  SeuratObject::DefaultAssay(worker_obj) <- assay_name
  emit_progress("Packaging Loupe metadata...", 22)

  ident <- tryCatch(SeuratObject::Idents(obj), error = function(e) NULL)
  if (!is.null(ident) && length(ident) == length(old_cells)) {
    ident_names <- names(ident)
    if (is.null(ident_names)) ident_names <- tryCatch(colnames(obj), error = function(e) old_cells)
    ident_idx <- match(old_cells, ident_names)
    if (!anyNA(ident_idx)) SeuratObject::Idents(worker_obj) <- ident[ident_idx]
  }

  reduction_names <- tryCatch(SeuratObject::Reductions(obj), error = function(e) character(0))
  worker_reductions <- list()
  for (reduction_name in reduction_names) {
    reduction <- tryCatch(obj[[reduction_name]], error = function(e) NULL)
    embeddings <- tryCatch(reduction@cell.embeddings, error = function(e) NULL)
    if (!is.matrix(embeddings) || ncol(embeddings) != 2L) next
    idx <- match(old_cells, rownames(embeddings))
    if (anyNA(idx)) next
    embeddings <- embeddings[idx, , drop = FALSE]
    if (any(!is.finite(embeddings))) next
    key <- tryCatch(as.character(reduction@key), error = function(e) "")
    key <- key[1]
    if (!length(key) || is.na(key) || !grepl("^[A-Za-z][A-Za-z0-9]*_$", key)) {
      key <- paste0(gsub("[^A-Za-z0-9]", "", reduction_name), "_")
      if (!grepl("^[A-Za-z]", key)) key <- paste0("dr_", key)
      if (!grepl("_$", key)) key <- paste0(key, "_")
    }
    worker_reductions[[reduction_name]] <- tryCatch(
      SeuratObject::CreateDimReducObject(
        embeddings = embeddings,
        assay = assay_name,
        key = key
      ),
      error = function(e) NULL
    )
  }
  worker_obj@reductions <- worker_reductions
  emit_progress("Packaging Loupe projections...", 24)

  misc <- tryCatch(obj@misc, error = function(e) NULL)
  if (is.list(misc) && length(misc)) {
    keep_misc <- intersect(names(misc), c("source_path", "input_path", "matrix_dir"))
    worker_obj@misc <- misc[keep_misc]
  }
  emit_progress("Loupe worker payload is ready.", 25)
  list(object = worker_obj, assay_name = assay_name)
}

.select_valid_projections <- function(obj, barcode_count, cells_keep = NULL) {
  reds <- tryCatch(SeuratObject::Reductions(obj), error = function(e) character(0))
  out <- list()
  cells_keep <- as.character(cells_keep %||% character(0))
  for (nm in reds) {
    emb <- tryCatch(obj[[nm]]@cell.embeddings, error = function(e) NULL)
    if (is.null(emb) || !is.matrix(emb)) next
    if (length(cells_keep)) {
      idx <- match(cells_keep, rownames(emb))
      if (any(is.na(idx))) next
      emb <- emb[idx, , drop = FALSE]
    }
    if (nrow(emb) != barcode_count || ncol(emb) != 2) next
    if (any(is.na(emb)) || any(is.nan(emb)) || any(is.infinite(emb))) next
    out[[nm]] <- emb
  }
  out
}

.select_valid_clusters <- function(obj, barcode_count, metadata_cols = NULL, cells_keep = NULL) {
  # Keep all cluster/grouping columns as-is; do not deduplicate.
  # Different resolutions can legitimately produce identical partitions, and users
  # still expect every resolution column to appear in Loupe.
  clusters <- loupeR::select_clusters(obj, dedup = FALSE, metadata_cols = metadata_cols)
  if (!is.list(clusters) || !length(clusters)) return(list())
  cells_keep <- as.character(cells_keep %||% character(0))
  obj_cells <- tryCatch(colnames(obj), error = function(e) character(0))
  
  keep <- vapply(clusters, function(f) {
    if (!is.factor(f)) return(FALSE)
    if (length(cells_keep)) {
      if (!is.null(names(f))) {
        idx <- match(cells_keep, names(f))
        if (any(is.na(idx))) return(FALSE)
        f <- f[idx]
      } else {
        if (!length(obj_cells) || length(f) != length(obj_cells)) return(FALSE)
        idx <- match(cells_keep, obj_cells)
        if (any(is.na(idx))) return(FALSE)
        f <- f[idx]
      }
    }
    if (length(f) != barcode_count) return(FALSE)
    lv <- levels(f)
    if (!length(lv) || length(lv) > 32768) return(FALSE)
    all(nzchar(as.character(lv)))
  }, logical(1))
  
  out <- clusters[keep]
  if (!length(out) || !length(cells_keep)) return(out)
  lapply(out, function(f) {
    if (!is.factor(f)) return(f)
    if (!is.null(names(f))) {
      idx <- match(cells_keep, names(f))
      f <- f[idx]
    } else {
      idx <- match(cells_keep, obj_cells)
      f <- f[idx]
    }
    f
  })
}

.louper_worker_path <- function() {
  candidates <- c(
    file.path(getwd(), "interface", "export", "loupe_export_worker.R"),
    file.path(getwd(), "Content", "interface", "export", "loupe_export_worker.R"),
    file.path(dirname(getwd()), "Content", "interface", "export", "loupe_export_worker.R")
  )
  hit <- candidates[file.exists(candidates)]
  if (!length(hit)) stop("loupeR subprocess worker was not found.")
  normalizePath(hit[[1]], mustWork = TRUE)
}

.louper_page_path <- function(filename) {
  path <- file.path(dirname(.louper_worker_path()), filename)
  normalizePath(path, mustWork = TRUE)
}

.louper_progress_event <- function(line) {
  line <- trimws(as.character(line %||% ""))
  if (!nzchar(line)) return(NULL)
  line_lower <- tolower(line)

  if (grepl("extracting matrix, clusters, and projections", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_extracting_loupe, pct = 8))
  }
  if (grepl("validating count matrix", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_validating_count_matrix, pct = 18))
  }
  if (grepl("validating clusters", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_validating_clusters, pct = 28))
  }
  if (grepl("validating projections", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_validating_projections, pct = 38))
  }
  if (grepl("creating temporary hdf5 file", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_writing_hdf5, pct = 58))
  }
  if (grepl("invoking louper executable", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_building_loupe, pct = 80))
  }
  if (grepl("running command", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_building_loupe, pct = 81))
  }
  if (grepl("validating input file", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_validating_loupe_input, pct = 83))
  }
  if (grepl("initializing loupe file", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_initializing_loupe_file, pct = 85))
  }
  if (grepl("converting count matrix", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_converting_loupe_counts, pct = 88))
  }
  if (grepl("converting projections", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_converting_loupe_projections, pct = 92))
  }
  if (grepl("converting clusters", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_converting_loupe_clusters, pct = 95))
  }
  if (grepl("finished loupe file", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_finishing_loupe, pct = 98))
  }
  if (grepl("copying loupe file", line_lower, fixed = TRUE)) {
    return(list(text = EXPORT_UI_TEXT$ui_progress_copying_loupe, pct = 99))
  }

  # Some Louper builds report a percentage or completed/total count while
  # creating the final file. Keep that signal inside final-build range so
  # stage progress remains monotonic and never claims completion early.
  if (grepl("progress|percent|complete|write|convert|create|build|process", line, ignore.case = TRUE)) {
    pct_match <- regexec("(?i)([0-9]{1,3})\\s*%", line, perl = TRUE)
    pct_parts <- regmatches(line, pct_match)[[1]]
    if (length(pct_parts) >= 2 && nzchar(pct_parts[[2]])) {
      raw_pct <- as.numeric(pct_parts[[2]])
      if (is.finite(raw_pct) && raw_pct >= 0 && raw_pct <= 100) {
        return(list(
          text = EXPORT_UI_TEXT$ui_progress_building_loupe,
          pct = 80 + (raw_pct * 0.18)
        ))
      }
    }

    ratio_match <- regexec("(?<![0-9])([0-9]+)\\s*(?:/|of)\\s*([0-9]+)(?![0-9])", line, perl = TRUE)
    ratio_parts <- regmatches(line, ratio_match)[[1]]
    if (length(ratio_parts) >= 3 && nzchar(ratio_parts[[2]]) && nzchar(ratio_parts[[3]])) {
      completed <- as.numeric(ratio_parts[[2]])
      total <- as.numeric(ratio_parts[[3]])
      if (is.finite(completed) && is.finite(total) && total > 0 && completed >= 0 && completed <= total) {
        return(list(
          text = EXPORT_UI_TEXT$ui_progress_building_loupe,
          pct = 80 + (18 * completed / total)
        ))
      }
    }
  }

  NULL
}

.run_loupe_export_subprocess <- function(mode, payload, progress_cb = NULL) {
  rscript <- Sys.which("Rscript")
  if (!nzchar(rscript)) stop("Rscript is required for isolated loupeR export.")

  work_dir <- tempfile("wanlab_louper_")
  dir.create(work_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(work_dir, recursive = TRUE, force = TRUE), add = TRUE)
  input_path <- file.path(work_dir, "input.rds")
  result_path <- file.path(work_dir, "result.rds")
  log_path <- file.path(work_dir, "worker.log")
  progress_path <- file.path(work_dir, "worker.progress")
  if (is.list(payload)) payload$progress_path <- progress_path
  saveRDS(payload, input_path)
  # The worker has its own serialized payload. Release the parent-side list
  # before waiting so it does not keep an extra export reference alive.
  rm(payload)
  invisible(gc(verbose = FALSE))

  # Agent note: loupeR must run in a fresh R process so Seurat v4/v5 can load their
  # own future namespace; loading it in the long-running Shiny process recreates the version collision.
  # Agent note: Result file is completion sentinel; log polling is only used to
  # stream LoupeR's existing stage messages to the busy overlay while worker runs.
  launch <- tryCatch(
    system2(
      rscript,
      c("--vanilla", shQuote(.louper_worker_path()), mode, shQuote(input_path), shQuote(result_path)),
      stdout = log_path,
      stderr = log_path,
      wait = FALSE
    ),
    error = function(e) e
  )
  if (inherits(launch, "condition")) stop("Failed to start isolated loupeR worker: ", conditionMessage(launch))

  if (!is.function(progress_cb)) progress_cb <- function(...) invisible(NULL)
  progress_paths <- c(progress_path, log_path)
  seen_lines <- integer(length(progress_paths))
  last_pct <- 0
  last_text <- ""
  read_progress <- function() {
    for (i in seq_along(progress_paths)) {
      path <- progress_paths[[i]]
      if (!file.exists(path)) next
      lines <- tryCatch(readLines(path, warn = FALSE), error = function(e) character(0))
      if (length(lines) < seen_lines[[i]]) seen_lines[[i]] <<- 0L
      if (length(lines) <= seen_lines[[i]]) next
      new_lines <- lines[seq.int(seen_lines[[i]] + 1L, length(lines))]
      seen_lines[[i]] <<- length(lines)
      for (line in new_lines) {
        event <- .louper_progress_event(line)
        if (is.null(event)) next
        pct <- max(last_pct, as.numeric(event$pct))
        if (!is.finite(pct)) pct <- last_pct
        text <- as.character(event$text %||% "")
        if (identical(text, last_text) && identical(pct, last_pct)) next
        last_text <<- text
        last_pct <<- pct
        try(progress_cb(text = text, pct = pct), silent = TRUE)
      }
    }
    invisible(NULL)
  }

  repeat {
    read_progress()
    if (file.exists(result_path)) break
    Sys.sleep(0.1)
  }
  read_progress()

  result <- if (file.exists(result_path)) readRDS(result_path) else NULL
  if (!is.list(result) || !isTRUE(result$ok)) {
    worker_log <- if (file.exists(log_path)) readLines(log_path, warn = FALSE) else character(0)
    detail <- result$error %||% paste(tail(worker_log, 20L), collapse = "\n")
    stop("Isolated loupeR worker failed: ", detail)
  }
  result$value
}

.ensure_louper_runtime <- function(prefer_lib = NULL) {
  # Add likely bootstrap library roots so an already-installed loupeR can be discovered.
  project_dir <- tryCatch(normalizePath(getwd(), mustWork = FALSE), error = function(e) getwd())
  cand_libs <- c(
    prefer_lib,
    file.path(dirname(project_dir), "package_libraries", "core"),
    file.path(project_dir, "package_libraries", "core")
  )
  cand_libs <- unique(cand_libs[nzchar(cand_libs) & dir.exists(cand_libs)])
  if (length(cand_libs)) .libPaths(unique(c(cand_libs, .libPaths())))
  
  if (!requireNamespace("loupeR", quietly = TRUE)) {
    lib_target <- prefer_lib %||% .libPaths()[1]
    if (!dir.exists(lib_target)) dir.create(lib_target, recursive = TRUE, showWarnings = FALSE)
    if (!requireNamespace("remotes", quietly = TRUE)) {
      install.packages("remotes", repos = "https://cloud.r-project.org", lib = lib_target, type = "both")
    }
    remotes::install_github("10XGenomics/loupeR", lib = lib_target, dependencies = TRUE, upgrade = "never")
    if (!requireNamespace("loupeR", quietly = TRUE)) {
      message("loupeR is still unavailable after non-forced install; retrying with force=TRUE.")
      remotes::install_github("10XGenomics/loupeR", lib = lib_target, dependencies = TRUE, upgrade = "never", force = TRUE)
    }
    if (!requireNamespace("loupeR", quietly = TRUE)) {
      stop("loupeR installation attempted but package is still unavailable.")
    }
  }
  
  old_auto_accept <- Sys.getenv("AUTO_ACCEPT_EULA", unset = NA_character_)
  on.exit({
    if (is.na(old_auto_accept)) Sys.unsetenv("AUTO_ACCEPT_EULA") else Sys.setenv(AUTO_ACCEPT_EULA = old_auto_accept)
  }, add = TRUE)
  Sys.setenv(AUTO_ACCEPT_EULA = "true")
  loupeR::setup()
  
  invisible(TRUE)
}

# Compatibility-first export: preserve all valid metadata + all valid 2D embeddings.
.export_to_loupe_simple_in_process <- function(sel, out_path, sel_name = NULL, shared_data = NULL, prefer_lib = NULL, assay_name = NULL, drop_invalid_cells = FALSE, sel_entry = NULL) {
  # Self-heal loupeR availability at export time (handles libpath/environment drift).
  .ensure_louper_runtime(prefer_lib = prefer_lib)
  if (!requireNamespace("Seurat", quietly = TRUE)) stop("Please install 'Seurat'.")
  if (!requireNamespace("SeuratObject", quietly = TRUE)) stop("Please install 'SeuratObject'.")
  
  sel_entry <- sel_entry %||% sel
  obj <- .as_seurat_or_fail(sel)
  assay_choices <- .assays_with_counts(obj)
  if (!length(assay_choices)) stop("No assay with usable count matrix found.")
  assay_name <- trimws(as.character(assay_name %||% ""))
  if (!nzchar(assay_name)) assay_name <- assay_choices[[1]]
  if (!(assay_name %in% assay_choices)) {
    stop("Selected assay is unavailable for Loupe export: ", assay_name)
  }
  assay_obj <- obj[[assay_name]]
  SeuratObject::DefaultAssay(obj) <- assay_name
  counts <- loupeR::counts_matrix_from_assay(assay_obj)
  barcode_count <- ncol(counts)
  old_cells <- colnames(counts)
  bc <- .derive_export_barcodes(obj, old_cells, drop_invalid_cells = drop_invalid_cells)
  keep_idx <- match(bc$kept_cells, old_cells)
  if (any(is.na(keep_idx))) stop("Barcode preprocessing produced cell names not found in assay counts.")
  if (!length(keep_idx)) stop("No cells remain after barcode preprocessing.")
  kept_old_cells <- old_cells[keep_idx]
  new_barcodes <- bc$barcodes

  # Agent note: Keep Seurat object intact. Filter only count columns, while
  # cluster and projection helpers apply same cell index. This avoids a full
  # Seurat copy for large datasets and preserves every retained cell/feature.
  if (length(keep_idx) != length(old_cells) || any(keep_idx != seq_along(old_cells))) {
    counts <- counts[, keep_idx, drop = FALSE]
  }
  if (ncol(counts) != length(new_barcodes)) {
    stop("Filtered assay count matrix does not match exported barcode count.")
  }
  colnames(counts) <- new_barcodes
  barcode_count <- ncol(counts)
  
  # Sanitize metadata and collect their names
  sm <- .sanitize_metadata(obj)
  obj <- sm$obj
  md_cols <- sm$md_cols
  
  clusters <- .select_valid_clusters(
    obj,
    barcode_count = barcode_count,
    metadata_cols = md_cols,
    cells_keep = kept_old_cells
  )
  if (!length(clusters)) stop("No valid grouping columns found for Loupe export.")
  clusters <- lapply(clusters, function(f) {
    if (!is.factor(f)) return(f)
    if (length(f) != length(new_barcodes)) stop("Cluster vector length does not match assay count matrix columns.")
    names(f) <- new_barcodes
    f
  })
  
  projections <- .select_valid_projections(obj, barcode_count = barcode_count, cells_keep = kept_old_cells)
  if (!length(projections)) {
    stop("No valid 2D projections found. Please run at least one 2D reduction (e.g., UMAP or tSNE).")
  }
  projections <- lapply(projections, function(emb) {
    idx <- match(rownames(emb), kept_old_cells)
    if (any(is.na(idx))) stop("Projection rownames do not align with subset export cells.")
    rownames(emb) <- new_barcodes[idx]
    emb
  })
  
  feature_ids <- .extract_feature_ids(
    obj,
    sel_name = sel_name,
    sel_entry = sel_entry,
    shared_data = shared_data,
    assay_name = assay_name,
    target_feature_count = nrow(counts)
  )
  
  out_dir  <- dirname(out_path)
  out_name <- tools::file_path_sans_ext(basename(out_path))
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

  # Agent note: LoupeR only needs count/cluster/projection payloads from here.
  # Release Seurat references before HDF5/Louper work to lower peak resident
  # memory; do not remove any exported component.
  rm(sel, sel_entry, obj, assay_obj, sm, old_cells, bc, keep_idx, kept_old_cells, new_barcodes, md_cols)
  invisible(gc(verbose = FALSE))
  
  loupeR::create_loupe(
    count_mat      = counts,
    clusters       = clusters,
    projections    = projections,
    output_dir     = out_dir,
    output_name    = out_name,
    feature_ids    = feature_ids,
    force          = TRUE
  )
  
  file.path(out_dir, paste0(out_name, ".cloupe"))
}

.export_to_loupe_simple <- function(sel, out_path, sel_name = NULL, shared_data = NULL, prefer_lib = NULL, assay_name = NULL, drop_invalid_cells = FALSE, progress_cb = NULL, sel_entry = NULL) {
  prefer_lib <- normalizePath(prefer_lib %||% "", mustWork = FALSE)
  if (!nzchar(prefer_lib) || !dir.exists(prefer_lib)) {
    stop("The active Seurat environment is unavailable for isolated Loupe export.")
  }
  shared_snapshot <- list(
    full_sample_sheet = tryCatch(shared_data$full_sample_sheet, error = function(e) NULL)
  )
  worker <- .loupe_worker_object(sel, assay_name = assay_name, progress_cb = progress_cb)
  worker_entry <- sel_entry %||% .loupe_worker_entry(sel)
  payload <- list(
    sel = worker$object,
    sel_entry = worker_entry,
    out_path = out_path,
    sel_name = sel_name,
    shared_data = shared_snapshot,
    prefer_lib = prefer_lib,
    assay_name = worker$assay_name,
    drop_invalid_cells = drop_invalid_cells,
    page_export_path = .louper_page_path("page_export.R")
  )
  result <- .run_loupe_export_subprocess("export-simple", payload, progress_cb = progress_cb)
  rm(payload, worker, sel, shared_snapshot)
  invisible(gc(verbose = FALSE))
  result
}

# ---------- UI ----------

# Agent note: the isolated loupeR worker sources this file for helper functions only;
# UI/server construction depends on parent-app helpers that intentionally are not loaded there.
if (!identical(Sys.getenv("WANLAB_LOUPER_WORKER"), "1")) {
export_ui <- fluidPage(
  # Agent note: downloadHandler content starts after the browser download
  # request reaches Shiny. Keep this capture listener so users see an immediate
  # click/start state while that request is being established; do not replace it
  # with a delay or a second Shiny input contract.
  tags$script(HTML(sprintf(
     "(function() {
       if (window.__wanlabLoupeClickBound) return;
       window.__wanlabLoupeClickBound = true;
       window.__wanlabLoupeExportInFlight = window.__wanlabLoupeExportInFlight === true;
       function setButtonBusy(busy) {
         var button = document.getElementById('download_loupe_file_btn');
         if (!button) return;
         if (busy) {
           button.setAttribute('aria-busy', 'true');
           button.setAttribute('aria-disabled', 'true');
           button.setAttribute('data-loupe-export-in-flight', 'true');
         } else {
           button.removeAttribute('aria-busy');
           button.removeAttribute('aria-disabled');
           button.removeAttribute('data-loupe-export-in-flight');
         }
       }
       function handleLoupeState(payload) {
         var state = String(payload && payload.state || '').toLowerCase();
         if (state === 'started') {
           window.__wanlabLoupeExportInFlight = true;
           setButtonBusy(true);
           return;
         }
         if (state === 'completed' || state === 'failed') {
           window.__wanlabLoupeExportInFlight = false;
           setButtonBusy(false);
           return;
         }
         if (state === 'duplicate' && window.console && typeof window.console.warn === 'function') {
           window.console.warn('[Loupe] Duplicate export request ignored; an export is already running.');
         }
       }
       function bindStateHandler() {
         if (window.__wanlabLoupeStateHandlerBound) return;
         if (!window.Shiny || typeof window.Shiny.addCustomMessageHandler !== 'function') return;
         window.Shiny.addCustomMessageHandler('wanlab-loupe-export-state', handleLoupeState);
         window.__wanlabLoupeStateHandlerBound = true;
       }
       bindStateHandler();
       document.addEventListener('shiny:connected', bindStateHandler);
       document.addEventListener('click', function(event) {
         var target = event && event.target;
         var button = target && target.closest ? target.closest('#download_loupe_file_btn') : null;
         if (!button) return;
         if (window.__wanlabLoupeExportInFlight === true) {
           event.preventDefault();
           if (typeof event.stopImmediatePropagation === 'function') event.stopImmediatePropagation();
           if (window.console && typeof window.console.warn === 'function') {
             window.console.warn('[Loupe] Duplicate click ignored; an export is already running.');
           }
           return;
         }
         window.__wanlabLoupeExportInFlight = true;
         setButtonBusy(true);
         function valueOf(id) {
           var el = document.getElementById(id);
           return el ? String(el.value || '') : '';
         }
         var details = {
           object: valueOf('export_object_name_input'),
           assay: valueOf('export_assay_input'),
           filename: valueOf('loupe_filename_input')
         };
         if (window.console && typeof window.console.info === 'function') {
           window.console.info('[Loupe] Generate button clicked; export request starting.', details);
         }
         if (window.WLSpinnerOverlay && typeof window.WLSpinnerOverlay.show === 'function') {
           window.WLSpinnerOverlay.show({
             id: 'global_overlay',
             text: %s,
             pct: 0,
             lock: true,
             lightweight: true
           });
         } else if (window.console && typeof window.console.warn === 'function') {
           window.console.warn('[Loupe] Busy overlay API is not ready at click time.');
         }
       }, true);
     })();",
    jsonlite::toJSON(EXPORT_UI_TEXT$ui_progress_starting_loupe, auto_unbox = TRUE)
  ))),
  div(
    class = "card-page-wrap export-page-wrap",
    div(
      class = "page-header",
      h2(
        icon("download"), " ",
        EXPORT_UI_TEXT$ui_title_export,
        tags$img(
          src = "logos/loupe_browser.png",
          alt = "Loupe Browser icon",
          style = "height:20px; width:20px; margin-left:4px; vertical-align:middle; border-radius:4px;"
        )
      ),
      p(EXPORT_UI_TEXT$ui_text_select_dataset_export_format_you_can)
    ),
    fluidRow(
      column(
        width = 4,
        card_page_card(
          title = EXPORT_UI_TEXT$ui_title_download_options,
          icon_name = "file-arrow-down",
          uiOutput("export_object_selector_ui"),
          uiOutput("export_assay_selector_ui"),
          tags$p(style = "color:#666;", textOutput("export_selected_class")),
          p(EXPORT_UI_TEXT$ui_text_generated_file_will_contain_umap_coordinates),
          textInput(
            "loupe_filename_input",
            label = EXPORT_UI_TEXT$ui_text_enter_desired_filename_cloupe,
            value = paste0(EXPORT_UI_TEXT$ui_text_default_export_filename_prefix, format(Sys.time(), "%Y%m%d"), ".cloupe")
          ),
          downloadButton(
            outputId = "download_loupe_file_btn",
            label = EXPORT_UI_TEXT$ui_text_generate_download_cloupe_file,
            class = "btn-success btn-lg",
            icon = icon("download")
          ),
          checkboxInput("export_drop_invalid_barcodes", EXPORT_UI_TEXT$ui_label_drop_invalid_cells, value = FALSE),
          uiOutput("loupe_barcode_warning_ui")
        )
      ),
      column(
        width = 8,
        card_page_card(
          title = EXPORT_UI_TEXT$ui_title_instructions,
          icon_name = "list-check",
          tags$ol(
            tags$li(EXPORT_UI_TEXT$ui_text_enter_your_desired_filename_text_box),
            tags$li(EXPORT_UI_TEXT$ui_text_click_generate_download_button),
            tags$li(EXPORT_UI_TEXT$ui_text_process_may_take_several_minutes_large_datasets),
            tags$li(EXPORT_UI_TEXT$ui_text_browser_will_prompt_choose_location_save_file),
            tags$li(EXPORT_UI_TEXT$ui_text_download_install_loupe_browser_10x_genomics_website_view_file)
          )
        ),
        card_page_card(
          title = EXPORT_UI_TEXT$ui_title_assay_notes,
          icon_name = "book-open",
          tags$p(tags$strong(EXPORT_UI_TEXT$ui_note_title_selection)),
          tags$ul(
            tags$li(EXPORT_UI_TEXT$ui_note_assay_rna),
            tags$li(EXPORT_UI_TEXT$ui_note_assay_sct)
          ),
          tags$p(tags$strong(EXPORT_UI_TEXT$ui_note_title_tasks)),
          tags$ul(
            tags$li(EXPORT_UI_TEXT$ui_note_task_feature),
            tags$li(EXPORT_UI_TEXT$ui_note_task_deg),
            tags$li(EXPORT_UI_TEXT$ui_note_task_recluster)
          ),
          tags$p(tags$strong(EXPORT_UI_TEXT$ui_note_title_recluster)),
          tags$ul(
            tags$li(EXPORT_UI_TEXT$ui_note_recluster_1),
            tags$li(EXPORT_UI_TEXT$ui_note_recluster_2),
            tags$li(EXPORT_UI_TEXT$ui_note_recluster_3),
            tags$li(EXPORT_UI_TEXT$ui_note_recluster_4)
          )
        )
      )
    ),
    tags$hr(style = "margin: 40px 0 48px 0; border-top: 1px solid #d5d9df;"),
    card_page_header(
      title = tagList(
        EXPORT_UI_TEXT$ui_title_h5ad_export_section,
        tags$img(
          src = "logos/cellxgene_discover_logo.svg",
          alt = "CELLxGENE logo",
          style = "height:20px; width:auto; margin-left:4px; vertical-align:middle;"
        )
      ),
      subtitle = "Export h5ad files for CELLxGENE-compatible workflows.",
      icon_name = "download"
    ),
    fluidRow(
      column(
        width = 4,
        card_page_card(
          title = EXPORT_UI_TEXT$ui_title_h5ad_download_options,
          icon_name = "file-arrow-down",
          p(EXPORT_UI_TEXT$ui_text_h5ad_section_intro),
          uiOutput("h5ad_export_object_selector_ui"),
          selectInput(
            inputId = "h5ad_export_profile_input",
            label = EXPORT_UI_TEXT$ui_label_h5ad_profile_select,
            choices = stats::setNames(
              c("cellxgene_strict", "minimal_generic"),
              c(EXPORT_UI_TEXT$ui_choice_h5ad_profile_strict, EXPORT_UI_TEXT$ui_choice_h5ad_profile_minimal)
            ),
            selected = "cellxgene_strict"
          ),
          tags$p(style = "color:#666;", textOutput("h5ad_export_selected_class")),
          textInput(
            "h5ad_filename_input",
            label = EXPORT_UI_TEXT$ui_text_enter_desired_filename_h5ad,
            value = paste0(EXPORT_UI_TEXT$ui_text_default_export_h5ad_filename_prefix, format(Sys.time(), "%Y%m%d"), ".h5ad")
          ),
          downloadButton(
            outputId = "download_h5ad_file_btn",
            label = EXPORT_UI_TEXT$ui_text_generate_download_h5ad_file,
            class = "btn-success btn-lg",
            icon = icon("download")
          )
        )
      ),
      column(
        width = 8,
        card_page_card(
          title = EXPORT_UI_TEXT$ui_title_h5ad_compatibility_notes,
          icon_name = "circle-info",
          tags$ul(
            tags$li(EXPORT_UI_TEXT$ui_text_h5ad_notes_strict_1),
            tags$li(EXPORT_UI_TEXT$ui_text_h5ad_notes_strict_2),
            tags$li(EXPORT_UI_TEXT$ui_text_h5ad_notes_strict_3),
            tags$li(EXPORT_UI_TEXT$ui_text_h5ad_notes_minimal_1)
          )
        )
      )
    ),
    tags$hr(style = "margin: 40px 0 48px 0; border-top: 1px solid #d5d9df;"),
    card_page_header(
      title = EXPORT_UI_TEXT$ui_title_publishable_pdfs,
      subtitle = EXPORT_UI_TEXT$ui_text_publishable_pdf_available_in_figure_studio,
      icon_name = "download"
    ),
    fluidRow(
      column(
        width = 4,
        card_page_card(
          title = EXPORT_UI_TEXT$ui_title_figure_studio_access,
          icon_name = "folder-open",
          p(EXPORT_UI_TEXT$ui_text_pdf_launch_card_intro),
          actionButton(
            "export_open_figure_studio_btn",
            EXPORT_UI_TEXT$ui_button_open_figure_studio,
            icon = icon("folder-open"),
            class = "btn-primary btn-lg"
          )
        )
      ),
      column(
        width = 8,
        card_page_card(
          title = EXPORT_UI_TEXT$ui_title_instructions,
          icon_name = "list-check",
          tags$ol(
            tags$li(EXPORT_UI_TEXT$ui_text_pdf_instruction_open_figure_studio),
            tags$li(EXPORT_UI_TEXT$ui_text_pdf_instruction_select_plot_type),
            tags$li(EXPORT_UI_TEXT$ui_text_pdf_instruction_style_plot),
            tags$li(EXPORT_UI_TEXT$ui_text_pdf_instruction_export_pdf),
            tags$li(EXPORT_UI_TEXT$ui_text_pdf_instruction_repeat)
          )
        )
      )
    )
  )
)

# ---------- server ----------

export_server <- function(input, output, session, shared_data) {
  loupe_export_in_flight <- shiny::reactiveVal(FALSE)
  send_loupe_export_state <- function(state) {
    try(session$sendCustomMessage(
      "wanlab-loupe-export-state",
      list(state = as.character(state))
    ), silent = TRUE)
    invisible(NULL)
  }

  observeEvent(input$export_open_figure_studio_btn, {
    updateNavbarPage(session, inputId = "main_navbar", selected = "figure_studio_umap")
  }, ignoreInit = TRUE)
  
  output$export_object_selector_ui <- renderUI({
    object_choices <- tryCatch(.export_object_choices(shared_data), error = function(e) character(0))
    req(length(object_choices) > 0)
    active_name <- tryCatch(shared_data$active_object_name, error = function(e) NULL)
    active_name <- if (length(active_name)) trimws(as.character(active_name[[1]])) else ""
    if (!nzchar(active_name) || !(active_name %in% object_choices)) {
      active_name <- object_choices[[1]]
    }
    
    wellPanel(
      selectInput("export_object_name_input",
                  label = EXPORT_UI_TEXT$ui_text_select_dataset_export,
                  choices = object_choices,
                  selected = active_name)
    )
  })
  
  selected_object_to_export <- reactive({
    .export_selected_entry(shared_data, input$export_object_name_input)
  })

  output$export_assay_selector_ui <- renderUI({
    sel <- tryCatch(selected_object_to_export(), error = function(e) NULL)
    req(!is.null(sel))
    obj <- tryCatch(.as_seurat_or_fail(sel), error = function(e) NULL)
    req(!is.null(obj))
    assay_choices <- .assays_with_counts(obj)
    req(length(assay_choices) > 0)
    selectInput(
      "export_assay_input",
      label = EXPORT_UI_TEXT$ui_label_assay_select,
      choices = assay_choices,
      selected = assay_choices[[1]]
    )
  })

  loupe_barcode_preview <- reactive({
    object_name <- trimws(as.character(input$export_object_name_input %||% ""))
    assay_name <- trimws(as.character(input$export_assay_input %||% ""))
    if (!nzchar(object_name) || !nzchar(assay_name)) return(NULL)
    sel <- selected_object_to_export()
    obj <- .as_seurat_or_fail(sel)
    cells <- .loupe_export_assay_cells(obj, assay_name)
    .derive_export_barcodes(obj, cells, diagnose_only = TRUE)
  })

  output$loupe_barcode_warning_ui <- renderUI({
    preview <- tryCatch(loupe_barcode_preview(), error = function(e) {
      list(error = conditionMessage(e))
    })
    if (is.null(preview)) return(NULL)
    if (!is.null(preview$error)) {
      return(
        div(
          class = "alert alert-danger",
          tags$strong(EXPORT_UI_TEXT$ui_text_barcode_check_error_prefix),
          " ",
          preview$error
        )
      )
    }

    n_invalid <- sum(!preview$compatible)
    n_duplicate_cells <- sum(preview$duplicate)
    if (n_invalid == 0L && n_duplicate_cells == 0L) {
      return(
        div(
          class = "alert alert-success",
          sprintf(EXPORT_UI_TEXT$ui_text_barcode_check_passed, length(preview$labels))
        )
      )
    }

    lines <- .loupe_export_barcode_issue_lines(preview)
    if (isTRUE(input$export_drop_invalid_barcodes)) {
      lines <- c(lines, EXPORT_UI_TEXT$ui_text_barcode_check_ready_after_removal)
      alert_class <- "alert alert-warning"
    } else {
      lines <- c(lines, EXPORT_UI_TEXT$ui_text_barcode_check_enable_option)
      alert_class <- "alert alert-danger"
    }
    div(
      class = alert_class,
      lapply(lines, function(line) tags$p(style = "margin:0 0 4px 0;", line))
    )
  })
  
  output$export_selected_class <- renderText({
    tryCatch({
      obj <- selected_object_to_export()
      paste(EXPORT_UI_TEXT$ui_text_export_selected_object_class_prefix, paste(class(obj), collapse = ", "))
    }, error = function(e) {
      conditionMessage(e)
    })
  })

  output$h5ad_export_object_selector_ui <- renderUI({
    object_choices <- tryCatch(.export_object_choices(shared_data), error = function(e) character(0))
    req(length(object_choices) > 0)
    active_name <- tryCatch(shared_data$active_object_name, error = function(e) NULL)
    active_name <- if (length(active_name)) trimws(as.character(active_name[[1]])) else ""
    if (!nzchar(active_name) || !(active_name %in% object_choices)) {
      active_name <- object_choices[[1]]
    }

    wellPanel(
      selectInput(
        "h5ad_export_object_name_input",
        label = EXPORT_UI_TEXT$ui_text_select_dataset_export,
        choices = object_choices,
        selected = active_name
      )
    )
  })

  selected_h5ad_object_to_export <- reactive({
    .export_selected_entry(shared_data, input$h5ad_export_object_name_input)
  })

  output$h5ad_export_selected_class <- renderText({
    tryCatch({
      obj <- selected_h5ad_object_to_export()
      paste(EXPORT_UI_TEXT$ui_text_export_selected_object_class_prefix_h5ad, paste(class(obj), collapse = ", "))
    }, error = function(e) {
      conditionMessage(e)
    })
  })
  
  output$download_loupe_file_btn <- downloadHandler(
    filename = function() {
      fname <- input$loupe_filename_input
      if (!endsWith(fname, ".cloupe")) fname <- paste0(fname, ".cloupe")
      fname
    },
    content = function(file) {
      if (isTRUE(shiny::isolate(loupe_export_in_flight()))) {
        message("[Loupe] duplicate export request ignored.")
        send_loupe_export_state("duplicate")
        stop("A Loupe export is already running.")
      }
      loupe_export_in_flight(TRUE)
      loupe_export_final_state <- "failed"
      send_loupe_export_state("started")
      on.exit({
        loupe_export_in_flight(FALSE)
        send_loupe_export_state(loupe_export_final_state)
      }, add = TRUE)
      message("[Loupe] download handler content started.")
      # Log collector for the modal (optional)
      log_lines <- character()
      append_log <- function(...) {
        ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
        log_lines <<- c(log_lines, paste0("[", ts, "] ", paste0(..., collapse = "")))
      }
      
      # Run the export
      tmp_dir <- tempdir()
      last_loupe_pct <- 0
      loupe_progress <- function(text = NULL, pct = NULL) {
        msg <- as.character(text %||% "")
        if (!nzchar(trimws(msg))) msg <- EXPORT_UI_TEXT$ui_progress_preparing_loupe
        pct_num <- suppressWarnings(as.numeric(pct))
        if (length(pct_num) != 1L || !is.finite(pct_num)) pct_num <- last_loupe_pct
        pct_num <- max(last_loupe_pct, min(100, pct_num))
        last_loupe_pct <<- pct_num
        try(overlay_show(text = msg, pct = pct_num, session = session, lock = TRUE, loader = "export"), silent = TRUE)
      }
      showNotification(EXPORT_UI_TEXT$ui_notification_generating_cloupe, type = "message", duration = NULL, id = "loupe_notification")
      loupe_progress(EXPORT_UI_TEXT$ui_progress_preparing_loupe, pct = 0)
      on.exit(removeNotification("loupe_notification"), add = TRUE)
      on.exit(overlay_hide(session = session), add = TRUE)

      tryCatch({
        sel_name <- if (length(input$export_object_name_input)) {
          trimws(as.character(input$export_object_name_input[[1]]))
        } else {
          ""
        }
        sel <- .export_selected_entry(shared_data, sel_name)
        append_log("Selected dataset: ", sel_name)
        message("[Loupe] selected dataset: ", sel_name)
        obj <- .as_seurat_or_fail(sel)
        assay_name <- trimws(as.character(input$export_assay_input %||% ""))
        req(nzchar(assay_name))
        loupe_progress(EXPORT_UI_TEXT$ui_progress_validating_barcodes, pct = 5)
        barcode_preview <- .derive_export_barcodes(
          obj,
          .loupe_export_assay_cells(obj, assay_name),
          diagnose_only = TRUE
        )
        barcode_has_issues <- any(!barcode_preview$compatible) || any(barcode_preview$duplicate)
        if (barcode_has_issues) {
          append_log(
            "Barcode preflight: invalid=", sum(!barcode_preview$compatible),
            " duplicate_cells=", sum(barcode_preview$duplicate),
            " retained=", sum(barcode_preview$keep),
            "/", length(barcode_preview$labels)
          )
          if (!isTRUE(input$export_drop_invalid_barcodes)) {
            stop(
              paste(
                c(
                  .loupe_export_barcode_issue_lines(barcode_preview),
                  EXPORT_UI_TEXT$ui_text_barcode_check_enable_option
                ),
                collapse = " "
              )
            )
          }
        }

        loupe_progress(EXPORT_UI_TEXT$ui_progress_preparing_disk_backed, pct = 7)
        prepared <- .wanlab_prepare_disk_backed_selection(
          selection = sel,
          object_name = sel_name,
          source_tag = sel_name,
          progress_cb = loupe_progress
        )
        sel <- prepared$selection
        append_log(
          "Disk-backed preparation: changed=", isTRUE(prepared$changed),
          " supported=", isTRUE(prepared$supported),
          if (!is.null(prepared$root)) paste0(" root=", prepared$root) else ""
        )
        
        tmp_out <- file.path(tmp_dir, "export.cloupe")
        append_log("Writing temporary export to: ", tmp_out)
        actual  <- .export_to_loupe_simple(
          sel = sel,
          out_path = tmp_out,
          sel_name = sel_name,
          shared_data = shared_data,
          prefer_lib = tryCatch(shared_data$active_environment$path, error = function(e) NULL),
          assay_name = input$export_assay_input %||% "",
          drop_invalid_cells = isTRUE(input$export_drop_invalid_barcodes),
          progress_cb = loupe_progress
        )
        if (!file.exists(actual)) stop("Exporter did not write a .cloupe file.")
        append_log("Generated file: ", actual)
        copied <- file.copy(actual, file, overwrite = TRUE)
        if (!isTRUE(copied)) stop("Failed to copy the generated .cloupe file to the browser download location.")
        loupe_progress(EXPORT_UI_TEXT$ui_progress_finalizing_loupe, pct = 100)
        loupe_export_final_state <- "completed"
        message("[Loupe] export completed.")
      }, error = function(e) {
        removeNotification("loupe_notification")
        overlay_hide(session = session)
        message("[Loupe] export failed: ", conditionMessage(e))
        showNotification(paste(EXPORT_UI_TEXT$ui_notification_error_generating_file_prefix, conditionMessage(e)), type = "error")
        if (exists(".show_export_error_modal")) {
          .show_export_error_modal(
            EXPORT_UI_TEXT$ui_text_export_failed_title_details,
            c(
              EXPORT_UI_TEXT$ui_text_export_failed_debug_info,
              EXPORT_UI_TEXT$ui_text_export_failed_modal_separator,
              log_lines,
              paste0(EXPORT_UI_TEXT$ui_text_error_prefix, conditionMessage(e))
            )
          )
        }
      })
    }
  )

  output$download_h5ad_file_btn <- downloadHandler(
    filename = function() {
      fname <- input$h5ad_filename_input %||% ""
      fname <- trimws(as.character(fname))
      if (!nzchar(fname)) fname <- paste0(EXPORT_UI_TEXT$ui_text_default_export_h5ad_filename_prefix, format(Sys.time(), "%Y%m%d"), ".h5ad")
      if (!endsWith(fname, ".h5ad")) fname <- paste0(fname, ".h5ad")
      fname
    },
    content = function(file) {
      log_lines <- character()
      append_log <- function(...) {
        ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
        log_lines <<- c(log_lines, paste0("[", ts, "] ", paste0(..., collapse = "")))
      }

      tmp_dir <- tempdir()
      tryCatch({
        sel_name <- if (length(input$h5ad_export_object_name_input)) {
          trimws(as.character(input$h5ad_export_object_name_input[[1]]))
        } else {
          ""
        }
        profile <- trimws(as.character(input$h5ad_export_profile_input %||% "cellxgene_strict"))
        if (!(profile %in% c("cellxgene_strict", "minimal_generic"))) {
          stop("Invalid h5ad export profile selected.")
        }
        sel <- .export_selected_entry(shared_data, sel_name)
        obj <- .as_seurat_or_fail(sel)
        append_log("Selected dataset: ", sel_name)
        append_log("Selected profile: ", profile)

        showNotification(EXPORT_UI_TEXT$ui_notification_generating_h5ad, type = "message", duration = NULL, id = "h5ad_notification")
        overlay_show(EXPORT_UI_TEXT$ui_notification_generating_h5ad, loader = "export")
        on.exit(removeNotification("h5ad_notification"), add = TRUE)
        on.exit(overlay_hide(), add = TRUE)

        tmp_out <- file.path(tmp_dir, "export.h5ad")
        append_log("Writing temporary export to: ", tmp_out)
        actual <- .export_to_h5ad(
          seurat_object = obj,
          out_path = tmp_out,
          profile = profile,
          object_name = sel_name
        )
        if (!file.exists(actual)) stop("Exporter did not write a .h5ad file.")
        append_log("Generated file: ", actual)
        copied <- file.copy(actual, file, overwrite = TRUE)
        if (!isTRUE(copied)) stop("Failed to copy the generated .h5ad file to the browser download location.")
      }, error = function(e) {
        removeNotification("h5ad_notification")
        overlay_hide()
        showNotification(paste(EXPORT_UI_TEXT$ui_notification_error_generating_file_prefix, conditionMessage(e)), type = "error")
        if (exists(".show_export_error_modal")) {
          .show_export_error_modal(
            EXPORT_UI_TEXT$ui_text_export_failed_title_details,
            c(
              EXPORT_UI_TEXT$ui_text_export_failed_debug_info,
              EXPORT_UI_TEXT$ui_text_export_failed_modal_separator,
              log_lines,
              paste0(EXPORT_UI_TEXT$ui_text_error_prefix, conditionMessage(e))
            )
          )
        }
      })
    }
  )
}
}
