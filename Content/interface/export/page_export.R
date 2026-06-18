# R/page_loupe_ui.R

# ---------- helpers ----------

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
  ui_label_drop_invalid_cells = "If needed, remove cells without valid 10x barcodes before export",
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

.valid_10x_barcode <- function(x) {
  grepl("^[ACGT]{16}(?:-[0-9]+)?$", as.character(x %||% ""), perl = TRUE)
}

.dedupe_tokens <- function(x) {
  x <- trimws(as.character(x %||% character(0)))
  x <- x[nzchar(x)]
  if (!length(x)) return(character(0))
  x[!duplicated(toupper(x))]
}

.normalize_louper_barcode_label <- function(x) {
  x <- trimws(as.character(x %||% ""))
  if (!nzchar(x)) return("")
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
    core <- .extract_raw_10x_barcode(x)
    if (!nzchar(core)) return("")
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

.valid_louper_barcode <- function(x) {
  x <- as.character(x %||% "")
  nzchar(trimws(x)) & !grepl("\\s", x, perl = TRUE)
}

.find_best_10x_barcode_column <- function(md, cells) {
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
    vals <- toupper(trimws(vals))
    ok <- .valid_10x_barcode(vals)
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

.derive_export_barcodes <- function(obj, cells, drop_invalid_cells = FALSE) {
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
    picked <- .find_best_10x_barcode_column(md, cells)
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
  raw <- toupper(trimws(as.character(raw)))
  ok <- .valid_10x_barcode(raw)
  if (any(!ok)) {
    bad <- unique(cells[!ok])
    diag_txt <- ""
    if (!is.null(barcode_col_diag) && is.data.frame(barcode_col_diag$diag) && nrow(barcode_col_diag$diag)) {
      top <- barcode_col_diag$diag[order(-barcode_col_diag$diag$n_valid, -barcode_col_diag$diag$n_unique_valid), , drop = FALSE]
      top <- head(top, 5)
      pieces <- sprintf("%s(valid=%d, unique_valid=%d)", top$col, top$n_valid, top$n_unique_valid)
      diag_txt <- paste0(" Metadata barcode column probe: ", paste(pieces, collapse = "; "), ".")
    } else if (is.data.frame(md)) {
      md_cols <- colnames(md)
      md_preview <- if (length(md_cols)) paste(head(md_cols, 12), collapse = ", ") else "<none>"
      diag_txt <- paste0(" Metadata barcode column probe: no barcode/cell-like column with valid 10x values found. Meta columns preview: ", md_preview, ".")
    } else {
      diag_txt <- " Metadata barcode column probe: meta.data unavailable."
    }
    if (!isTRUE(drop_invalid_cells)) {
      stop(
        sprintf(
          "Invalid 10x barcode candidates for %d cell(s). Example cell names: %s.%s Enable 'remove cells without valid 10x barcodes' to export the remaining valid cells.",
          sum(!ok),
          paste(head(bad, 5), collapse = ", "),
          diag_txt
        )
      )
    }
  }
  keep <- ok
  if (!any(keep)) stop("No cells with valid 10x barcodes are available for export.")
  exp_bc <- canon
  exp_bc[!nzchar(exp_bc)] <- raw[!nzchar(exp_bc)]
  exp_bc <- trimws(as.character(exp_bc))
  exp_bc <- exp_bc[keep]
  kept_cells <- cells[keep]
  exp_ok <- .valid_louper_barcode(exp_bc)
  if (any(!exp_ok)) {
    bad <- unique(exp_bc[!exp_ok])
    stop(
      sprintf(
        "Invalid Loupe barcode label formatting for %d cell(s). Example values: %s",
        sum(!exp_ok),
        paste(head(bad, 5), collapse = ", ")
      )
    )
  }
  dup_mask <- duplicated(exp_bc) | duplicated(exp_bc, fromLast = TRUE)
  if (any(dup_mask) && !isTRUE(drop_invalid_cells)) {
    dup_vals <- unique(exp_bc[dup_mask])
    stop(
      sprintf(
        "Export requires unique barcodes, but found %d duplicated barcode label(s). Example duplicates: %s. Enable 'remove cells without valid 10x barcodes' to drop conflicting cells and continue.",
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

.extract_feature_ids <- function(obj, sel_name = NULL, sel_entry = NULL, shared_data = NULL, assay_name = NULL) {
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
  target_n <- nrow(loupeR::counts_matrix_from_assay(assay_obj))
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
.export_to_loupe_simple <- function(sel, out_path, sel_name = NULL, shared_data = NULL, prefer_lib = NULL, assay_name = NULL, drop_invalid_cells = FALSE) {
  # Self-heal loupeR availability at export time (handles libpath/environment drift).
  .ensure_louper_runtime(prefer_lib = prefer_lib)
  if (!requireNamespace("Seurat", quietly = TRUE)) stop("Please install 'Seurat'.")
  if (!requireNamespace("SeuratObject", quietly = TRUE)) stop("Please install 'SeuratObject'.")
  
  sel_entry <- sel
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
  kept_old_cells <- old_cells[keep_idx]
  new_barcodes <- bc$barcodes

  # Root-cause fix: subset object once, then derive all export components from the same cell universe.
  obj <- tryCatch(subset(obj, cells = kept_old_cells), error = function(e) {
    stop("Failed to subset export object to valid barcode cells: ", conditionMessage(e))
  })
  counts <- loupeR::counts_matrix_from_assay(obj[[assay_name]])
  colnames(counts) <- new_barcodes
  barcode_count <- ncol(counts)
  
  # Sanitize metadata and collect their names
  sm <- .sanitize_metadata(obj)
  obj <- sm$obj
  md_cols <- sm$md_cols
  
  clusters <- .select_valid_clusters(obj, barcode_count = barcode_count, metadata_cols = md_cols)
  if (!length(clusters)) stop("No valid grouping columns found for Loupe export.")
  clusters <- lapply(clusters, function(f) {
    if (!is.factor(f)) return(f)
    if (length(f) != length(new_barcodes)) stop("Cluster vector length does not match assay count matrix columns.")
    names(f) <- new_barcodes
    f
  })
  
  projections <- .select_valid_projections(obj, barcode_count = barcode_count)
  if (!length(projections)) {
    stop("No valid 2D projections found. Please run at least one 2D reduction (e.g., UMAP or tSNE).")
  }
  projections <- lapply(projections, function(emb) {
    idx <- match(rownames(emb), colnames(obj))
    if (any(is.na(idx))) stop("Projection rownames do not align with subset export cells.")
    rownames(emb) <- new_barcodes[idx]
    emb
  })
  
  feature_ids <- .extract_feature_ids(
    obj,
    sel_name = sel_name,
    sel_entry = sel_entry,
    shared_data = shared_data,
    assay_name = assay_name
  )
  
  out_dir  <- dirname(out_path)
  out_name <- tools::file_path_sans_ext(basename(out_path))
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  
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

# ---------- UI ----------

export_ui <- fluidPage(
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
          checkboxInput("export_drop_invalid_barcodes", EXPORT_UI_TEXT$ui_label_drop_invalid_cells, value = FALSE)
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
      # Log collector for the modal (optional)
      log_lines <- character()
      append_log <- function(...) {
        ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
        log_lines <<- c(log_lines, paste0("[", ts, "] ", paste0(..., collapse = "")))
      }
      
      # Run the export
      tmp_dir <- tempdir()
      tryCatch({
        sel_name <- if (length(input$export_object_name_input)) {
          trimws(as.character(input$export_object_name_input[[1]]))
        } else {
          ""
        }
        sel <- .export_selected_entry(shared_data, sel_name)
        append_log("Selected dataset: ", sel_name)
        
        showNotification(EXPORT_UI_TEXT$ui_notification_generating_cloupe, type = "message", duration = NULL, id = "loupe_notification")
        overlay_show(EXPORT_UI_TEXT$ui_notification_generating_cloupe)
        on.exit(removeNotification("loupe_notification"), add = TRUE)
        on.exit(overlay_hide(), add = TRUE)
        
        tmp_out <- file.path(tmp_dir, "export.cloupe")
        append_log("Writing temporary export to: ", tmp_out)
        actual  <- .export_to_loupe_simple(
          sel = sel,
          out_path = tmp_out,
          sel_name = sel_name,
          shared_data = shared_data,
          prefer_lib = tryCatch(shared_data$active_environment$path, error = function(e) NULL),
          assay_name = input$export_assay_input %||% "",
          drop_invalid_cells = isTRUE(input$export_drop_invalid_barcodes)
        )
        if (!file.exists(actual)) stop("Exporter did not write a .cloupe file.")
        append_log("Generated file: ", actual)
        copied <- file.copy(actual, file, overwrite = TRUE)
        if (!isTRUE(copied)) stop("Failed to copy the generated .cloupe file to the browser download location.")
      }, error = function(e) {
        removeNotification("loupe_notification")
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
        overlay_show(EXPORT_UI_TEXT$ui_notification_generating_h5ad)
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
