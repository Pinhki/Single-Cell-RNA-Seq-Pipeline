# R/page_export_vdj_safe.R

VDJ_SAFE_EXPORT_UI_TEXT <- list(
  ui_title_export = "VDJ-safe Export",
  ui_title_loupe_browser = "To Loupe Browser (.cloupe)",
  ui_text_intro = "Create a Loupe file using raw 10x-style barcode candidates for better VDJ interoperability. This page does not modify your stored Seurat object.",
  ui_text_select_dataset_export = "Select Dataset to Export:",
  ui_text_export_selected_object_class_prefix = "Selected object class:",
  ui_title_download_options = "Download Options",
  ui_text_generated_file = "The generated file contains UMAP coordinates and sanitized metadata. Barcode handling is applied only in a temporary export object.",
  ui_label_assay_select = "Assay to export:",
  ui_text_enter_filename = "Enter desired filename (.cloupe):",
  ui_text_default_filename_prefix = "vdj_safe_export_",
  ui_text_generate_download = "Generate and Download VDJ-safe .cloupe",
  ui_label_sample_mode = "Barcode handling mode:",
  ui_mode_auto = "Strict auto (stop on duplicate/overlap)",
  ui_mode_single = "Treat as one pooled sample (require unique barcodes)",
  ui_mode_split = "Split by sample metadata",
  ui_label_split_sample = "Sample to export (split mode):",
  ui_title_validation = "VDJ-safe validation",
  ui_title_instructions = "Instructions",
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
  ui_text_instruction_1 = "Choose the dataset to export.",
  ui_text_instruction_2 = "Set barcode handling mode based on your sample structure.",
  ui_text_instruction_3 = "Review validation counts and resolve any barcode conflicts.",
  ui_text_instruction_4 = "Enter output filename and click generate/download.",
  ui_text_instruction_5 = "The source Seurat object remains unchanged.",
  ui_status_no_object = "No object selected.",
  ui_status_missing_sample = "Split mode requires choosing a sample.",
  ui_status_cells_prefix = "Cells:",
  ui_status_candidates_prefix = "Raw-barcode candidates found:",
  ui_status_valid_prefix = "Valid 10x barcodes:",
  ui_status_duplicated_prefix = "Duplicated valid barcodes (conflicts):",
  ui_status_sample_col_prefix = "Sample column:",
  ui_status_overlap_prefix = "Cross-sample barcode overlap:",
  ui_text_yes = "YES",
  ui_text_no = "NO",
  ui_text_none = "<none>",
  ui_notification_generating = "Generating VDJ-safe .cloupe file...",
  ui_notification_error_prefix = "Error generating file:",
  ui_text_modal_title_failed = "VDJ-safe export failed - details",
  ui_text_modal_debug_intro = "VDJ-safe export failed. Copy any info below if needed for debugging.",
  ui_text_modal_separator = "-------------------------------------------------------------------",
  ui_text_error_prefix = "ERROR: ",
  ui_button_close = "Close"
)

.show_vdj_safe_export_error_modal <- function(title, lines) {
  shiny::showModal(
    shiny::modalDialog(
      title = title,
      easyClose = TRUE,
      size = "l",
      footer = tagList(shiny::modalButton(VDJ_SAFE_EXPORT_UI_TEXT$ui_button_close)),
      tags$div(
        style = "max-height: 60vh; overflow-y: auto;",
        tags$pre(paste(lines, collapse = "\n"))
      )
    )
  )
}

.vdj_safe_as_seurat_or_fail <- function(x) {
  if (inherits(x, "Seurat")) return(x)

  if (is.list(x)) {
    for (nm in c("seurat", "seurat_obj", "object", "obj", "data", "dataset")) {
      if (!is.null(x[[nm]]) && inherits(x[[nm]], "Seurat")) return(x[[nm]])
    }
    idx <- which(vapply(x, function(e) inherits(e, "Seurat"), logical(1)))
    if (length(idx)) return(x[[idx[1]]])
  }

  if (is.function(x)) {
    y <- try(x(), silent = TRUE)
    if (!inherits(y, "try-error")) return(.vdj_safe_as_seurat_or_fail(y))
  }

  stop("Selected item is not (or does not contain) a Seurat object.")
}

.vdj_safe_get_assay_data <- function(sobj, assay = NULL, layer = "counts") {
  aa <- as.character(assay %||% "")
  if (!nzchar(aa)) aa <- tryCatch(as.character(SeuratObject::DefaultAssay(sobj)), error = function(e) "")
  ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
  args <- list(object = sobj)
  if (nzchar(aa)) args$assay <- aa
  if ("layer" %in% ga_formals) args$layer <- layer else args$slot <- layer
  out <- tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
  if (!is.null(out)) return(out)
  if ("layer" %in% ga_formals) {
    args$slot <- layer
    args$layer <- NULL
  } else {
    args$layer <- layer
    args$slot <- NULL
  }
  tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
}

.vdj_safe_pick_assay_with_counts <- function(obj) {
  has_counts <- function(o, assay) {
    m <- .vdj_safe_get_assay_data(o, assay = assay, layer = "counts")
    !is.null(m) && nrow(m) > 0 && ncol(m) > 0 &&
      !is.null(rownames(m)) && !is.null(colnames(m))
  }
  assays <- SeuratObject::Assays(obj)
  ordered <- unique(c("RNA", "SCT", assays))
  keep <- vapply(ordered, function(a) a %in% assays && has_counts(obj, a), logical(1))
  picks <- ordered[keep]
  if (!length(picks)) return(NULL)
  picks[[1]]
}

.vdj_safe_assays_with_counts <- function(obj) {
  has_counts <- function(o, assay) {
    m <- .vdj_safe_get_assay_data(o, assay = assay, layer = "counts")
    !is.null(m) && nrow(m) > 0 && ncol(m) > 0 &&
      !is.null(rownames(m)) && !is.null(colnames(m))
  }
  assays <- SeuratObject::Assays(obj)
  ordered <- unique(c("RNA", "SCT", assays))
  keep <- vapply(ordered, function(a) a %in% assays && has_counts(obj, a), logical(1))
  ordered[keep]
}

.vdj_safe_sanitize_metadata <- function(obj) {
  md <- obj@meta.data

  if (!"seurat_clusters" %in% colnames(md)) {
    obj$seurat_clusters <- SeuratObject::Idents(obj)
    md <- obj@meta.data
  }

  keep <- vapply(md, function(v) is.atomic(v) || is.factor(v), logical(1))
  md2  <- md[, keep, drop = FALSE]

  md2[] <- lapply(md2, function(v) {
    if (is.factor(v)) v <- as.character(v)
    if (inherits(v, "POSIXt") || inherits(v, "Date")) v <- as.character(v)
    if (is.logical(v)) v <- ifelse(v, "TRUE", "FALSE")
    if (is.numeric(v)) v <- as.character(v)
    v[is.na(v) | trimws(v) == ""] <- "Unknown"
    v
  })

  safe <- make.unique(gsub("[^A-Za-z0-9_]+", "_", colnames(md2)), sep = "_")

  for (i in seq_along(safe)) obj[[ safe[i] ]] <- md2[[ i ]]

  list(obj = obj, md_cols = safe)
}

.vdj_safe_extract_raw_barcode <- function(x) {
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
    if (length(reg2) >= 2 && nzchar(reg2[[2]])) {
      out[[i]] <- toupper(reg2[[2]])
    }
  }
  out
}

.vdj_safe_valid_10x_barcode <- function(x) {
  grepl("^[ACGT]{16}(?:-[0-9]+)?$", as.character(x %||% ""), perl = TRUE)
}

.vdj_safe_detect_sample_col <- function(md) {
  if (is.null(md) || !is.data.frame(md)) return("")
  cand <- c("orig.ident", "sample", "sample_name", "batch", "library", "library_id", "donor")
  hit <- cand[cand %in% colnames(md)]
  if (!length(hit)) return("")
  hit[[1]]
}

.vdj_safe_diag_object <- function(sel) {
  obj <- .vdj_safe_as_seurat_or_fail(sel)
  md <- obj@meta.data
  cells <- colnames(obj)
  n <- length(cells)

  raw <- rep(NA_character_, n)
  if ("barcode_10x_raw" %in% colnames(md)) {
    raw <- as.character(md[cells, "barcode_10x_raw"])
  }
  miss <- is.na(raw) | !nzchar(raw)
  if (any(miss)) raw[miss] <- .vdj_safe_extract_raw_barcode(cells[miss])

  valid <- .vdj_safe_valid_10x_barcode(raw)
  sample_col <- .vdj_safe_detect_sample_col(md)
  sample_vals <- if (nzchar(sample_col)) as.character(md[cells, sample_col]) else rep("all", n)
  sample_vals[is.na(sample_vals) | !nzchar(sample_vals)] <- "unknown"

  by_raw <- split(sample_vals, raw)
  by_raw <- by_raw[nzchar(names(by_raw))]
  ambiguous_cross_sample <- any(vapply(by_raw, function(z) length(unique(z)) > 1L, logical(1)))

  list(
    n_cells = n,
    n_recovered = sum(!is.na(raw) & nzchar(raw)),
    n_valid = sum(valid),
    n_invalid = sum(!valid),
    n_unique_raw = length(unique(raw[valid])),
    n_duplicated_valid = sum(duplicated(raw[valid]) | duplicated(raw[valid], fromLast = TRUE)),
    ambiguous_cross_sample = isTRUE(ambiguous_cross_sample),
    sample_col = sample_col,
    sample_levels = sort(unique(sample_vals)),
    raw = raw,
    sample_vals = sample_vals,
    cells = cells
  )
}

.vdj_safe_prepare_export_obj <- function(sel, sample_mode = "auto", split_sample = "") {
  obj <- .vdj_safe_as_seurat_or_fail(sel)
  md <- obj@meta.data
  cells <- colnames(obj)

  diag <- .vdj_safe_diag_object(obj)
  raw <- as.character(diag$raw)
  sample_vals <- as.character(diag$sample_vals)
  current <- as.character(diag$cells)

  valid <- .vdj_safe_valid_10x_barcode(raw)
  if (any(!valid)) {
    bad_show <- head(unique(current[!valid]), 5)
    stop(
      sprintf(
        "Could not find valid 10x barcode candidates for %d cell(s). Example current cell names: %s",
        sum(!valid),
        paste(bad_show, collapse = ", ")
      )
    )
  }

  keep <- rep(TRUE, length(cells))
  if (identical(sample_mode, "split")) {
    if (!nzchar(diag$sample_col)) {
      stop("Split mode requires a sample metadata column (e.g., orig.ident/sample).")
    }
    if (!nzchar(split_sample)) {
      stop("Split mode requires selecting a sample.")
    }
    keep <- sample_vals == split_sample
    if (!any(keep)) {
      stop("No cells found for selected split sample: ", split_sample)
    }
  }

  obj2 <- if (all(keep)) obj else Seurat::subset(obj, cells = cells[keep])
  cells2 <- colnames(obj2)

  idx <- match(cells2, current)
  raw2 <- raw[idx]
  sample2 <- sample_vals[idx]
  current2 <- current[idx]

  if (identical(sample_mode, "auto")) {
    if (isTRUE(diag$ambiguous_cross_sample)) {
      stop(
        "Strict auto mode found raw barcode overlaps across multiple samples. Use pooled mode if appropriate, or split-by-sample mode."
      )
    }
    if (anyDuplicated(raw2)) {
      stop("Strict auto mode found duplicated valid barcodes. Use split mode or verify barcode naming.")
    }
  } else if (identical(sample_mode, "single")) {
    if (anyDuplicated(raw2)) {
      stop("Pooled mode requires unique valid barcodes in the selected object.")
    }
  } else if (identical(sample_mode, "split")) {
    if (anyDuplicated(raw2)) {
      stop("Split mode still has duplicated valid barcodes within the selected sample.")
    }
  } else {
    stop("Unknown sample_mode: ", sample_mode)
  }

  colnames(obj2) <- raw2
  md2 <- obj2@meta.data
  md2$barcode_current <- current2
  md2$barcode_10x_raw <- raw2
  md2$barcode_sample_id <- sample2
  obj2@meta.data <- md2

  list(
    obj = obj2,
    sample_col = diag$sample_col,
    sample_levels = diag$sample_levels,
    n_cells = length(raw2)
  )
}

.vdj_safe_export_to_loupe <- function(sel, out_path, sample_mode = "auto", split_sample = "", assay_name = NULL) {
  if (!requireNamespace("loupeR", quietly = TRUE)) stop("Please install 'loupeR'.")
  if (!requireNamespace("Seurat", quietly = TRUE)) stop("Please install 'Seurat'.")
  if (!requireNamespace("SeuratObject", quietly = TRUE)) stop("Please install 'SeuratObject'.")

  prep <- .vdj_safe_prepare_export_obj(sel, sample_mode = sample_mode, split_sample = split_sample)
  obj <- prep$obj

  picks <- .vdj_safe_assays_with_counts(obj)
  pick <- trimws(as.character(assay_name %||% ""))
  if (!nzchar(pick)) pick <- if (length(picks)) picks[[1]] else NULL
  if (!is.null(pick) && !is.na(pick) && !(pick %in% picks)) {
    stop("Selected assay is unavailable for Loupe export: ", pick)
  }
  if (is.null(pick)) stop("No assay with non-empty counts + dimnames found (RNA/SCT/etc.).")
  SeuratObject::DefaultAssay(obj) <- pick

  if (!("umap" %in% SeuratObject::Reductions(obj))) {
    stop("UMAP reduction not found. Please run UMAP first.")
  }

  sm <- .vdj_safe_sanitize_metadata(obj)
  obj <- sm$obj
  md_cols <- sm$md_cols

  out_dir  <- dirname(out_path)
  out_name <- tools::file_path_sans_ext(basename(out_path))
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

  loupeR::create_loupe_from_seurat(
    obj            = obj,
    output_dir     = out_dir,
    output_name    = out_name,
    metadata_cols  = md_cols,
    dedup_clusters = TRUE,
    force          = TRUE
  )

  list(
    path = file.path(out_dir, paste0(out_name, ".cloupe")),
    n_cells = prep$n_cells,
    sample_col = prep$sample_col
  )
}

export_vdj_safe_ui <- fluidPage(
  div(
    class = "card-page-wrap",
    div(
      class = "page-header",
      h2(icon("shield"), " ", VDJ_SAFE_EXPORT_UI_TEXT$ui_title_export),
      h4(VDJ_SAFE_EXPORT_UI_TEXT$ui_title_loupe_browser),
      p(VDJ_SAFE_EXPORT_UI_TEXT$ui_text_intro)
    ),
    fluidRow(
      column(
        width = 4,
        card_page_card(
          title = VDJ_SAFE_EXPORT_UI_TEXT$ui_title_download_options,
          icon_name = "file-arrow-down",
          uiOutput("vdj_safe_export_object_selector_ui"),
          uiOutput("vdj_safe_export_assay_selector_ui"),
          tags$p(style = "color:#666;", textOutput("vdj_safe_export_selected_class")),
          p(VDJ_SAFE_EXPORT_UI_TEXT$ui_text_generated_file),
          selectInput(
            "vdj_safe_sample_mode",
            label = VDJ_SAFE_EXPORT_UI_TEXT$ui_label_sample_mode,
            choices = setNames(
              c("auto", "single", "split"),
              c(
                VDJ_SAFE_EXPORT_UI_TEXT$ui_mode_auto,
                VDJ_SAFE_EXPORT_UI_TEXT$ui_mode_single,
                VDJ_SAFE_EXPORT_UI_TEXT$ui_mode_split
              )
            ),
            selected = "auto"
          ),
          uiOutput("vdj_safe_split_sample_ui"),
          textInput(
            "vdj_safe_loupe_filename_input",
            label = VDJ_SAFE_EXPORT_UI_TEXT$ui_text_enter_filename,
            value = paste0(VDJ_SAFE_EXPORT_UI_TEXT$ui_text_default_filename_prefix, format(Sys.time(), "%Y%m%d"), ".cloupe")
          ),
          downloadButton(
            outputId = "vdj_safe_download_loupe_file_btn",
            label = VDJ_SAFE_EXPORT_UI_TEXT$ui_text_generate_download,
            class = "btn-success btn-lg",
            icon = icon("download")
          )
        )
      ),
      column(
        width = 8,
        card_page_card(
          title = VDJ_SAFE_EXPORT_UI_TEXT$ui_title_validation,
          icon_name = "list-check",
          uiOutput("vdj_safe_validation_status_ui")
        ),
        card_page_card(
          title = VDJ_SAFE_EXPORT_UI_TEXT$ui_title_instructions,
          icon_name = "info-circle",
          tags$ol(
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_text_instruction_1),
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_text_instruction_2),
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_text_instruction_3),
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_text_instruction_4),
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_text_instruction_5)
          )
        ),
        card_page_card(
          title = VDJ_SAFE_EXPORT_UI_TEXT$ui_title_assay_notes,
          icon_name = "book-open",
          tags$p(tags$strong(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_title_selection)),
          tags$ul(
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_assay_rna),
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_assay_sct)
          ),
          tags$p(tags$strong(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_title_tasks)),
          tags$ul(
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_task_feature),
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_task_deg),
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_task_recluster)
          ),
          tags$p(tags$strong(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_title_recluster)),
          tags$ul(
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_recluster_1),
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_recluster_2),
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_recluster_3),
            tags$li(VDJ_SAFE_EXPORT_UI_TEXT$ui_note_recluster_4)
          )
        )
      )
    )
  )
)

export_vdj_safe_server <- function(input, output, session, shared_data) {
  output$vdj_safe_export_object_selector_ui <- renderUI({
    object_choices <- names(shared_data$all_seurat_objects)
    req(length(object_choices) > 0)

    wellPanel(
      selectInput(
        "vdj_safe_export_object_name_input",
        label = VDJ_SAFE_EXPORT_UI_TEXT$ui_text_select_dataset_export,
        choices = object_choices,
        selected = shared_data$active_object_name
      )
    )
  })

  vdj_safe_selected_object_to_export <- reactive({
    req(input$vdj_safe_export_object_name_input)
    shared_data$all_seurat_objects[[input$vdj_safe_export_object_name_input]]
  })

  output$vdj_safe_export_assay_selector_ui <- renderUI({
    sel <- vdj_safe_selected_object_to_export()
    req(sel)
    obj <- tryCatch(.vdj_safe_as_seurat_or_fail(sel), error = function(e) NULL)
    req(!is.null(obj))
    assay_choices <- .vdj_safe_assays_with_counts(obj)
    req(length(assay_choices) > 0)
    selectInput(
      "vdj_safe_export_assay_input",
      label = VDJ_SAFE_EXPORT_UI_TEXT$ui_label_assay_select,
      choices = assay_choices,
      selected = assay_choices[[1]]
    )
  })

  output$vdj_safe_export_selected_class <- renderText({
    obj <- vdj_safe_selected_object_to_export()
    paste(VDJ_SAFE_EXPORT_UI_TEXT$ui_text_export_selected_object_class_prefix, paste(class(obj), collapse = ", "))
  })

  vdj_safe_diag <- reactive({
    sel <- vdj_safe_selected_object_to_export()
    tryCatch(.vdj_safe_diag_object(sel), error = function(e) NULL)
  })

  output$vdj_safe_split_sample_ui <- renderUI({
    req(identical(input$vdj_safe_sample_mode %||% "auto", "split"))
    d <- vdj_safe_diag()
    lev <- if (is.null(d)) character(0) else as.character(d$sample_levels %||% character(0))
    selectInput(
      "vdj_safe_split_sample",
      label = VDJ_SAFE_EXPORT_UI_TEXT$ui_label_split_sample,
      choices = lev,
      selected = if (length(lev)) lev[[1]] else NULL
    )
  })

  output$vdj_safe_validation_status_ui <- renderUI({
    d <- vdj_safe_diag()
    if (is.null(d)) return(div(class = "alert alert-warning", VDJ_SAFE_EXPORT_UI_TEXT$ui_status_no_object))

    mode <- input$vdj_safe_sample_mode %||% "auto"
    split_sample <- input$vdj_safe_split_sample %||% ""

    msgs <- c(
      sprintf("%s %d", VDJ_SAFE_EXPORT_UI_TEXT$ui_status_cells_prefix, d$n_cells),
      sprintf("%s %d", VDJ_SAFE_EXPORT_UI_TEXT$ui_status_candidates_prefix, d$n_recovered),
      sprintf("%s %d", VDJ_SAFE_EXPORT_UI_TEXT$ui_status_valid_prefix, d$n_valid),
      sprintf("%s %d", VDJ_SAFE_EXPORT_UI_TEXT$ui_status_duplicated_prefix, d$n_duplicated_valid),
      sprintf(
        "%s %s",
        VDJ_SAFE_EXPORT_UI_TEXT$ui_status_sample_col_prefix,
        ifelse(nzchar(d$sample_col), d$sample_col, VDJ_SAFE_EXPORT_UI_TEXT$ui_text_none)
      ),
      sprintf(
        "%s %s",
        VDJ_SAFE_EXPORT_UI_TEXT$ui_status_overlap_prefix,
        ifelse(isTRUE(d$ambiguous_cross_sample), VDJ_SAFE_EXPORT_UI_TEXT$ui_text_yes, VDJ_SAFE_EXPORT_UI_TEXT$ui_text_no)
      )
    )

    if (identical(mode, "split") && !nzchar(split_sample)) {
      return(div(class = "alert alert-warning", paste(c(msgs, VDJ_SAFE_EXPORT_UI_TEXT$ui_status_missing_sample), collapse = "\n")))
    }

    status_class <- "alert alert-info"
    if (d$n_invalid > 0) status_class <- "alert alert-danger"
    if (identical(mode, "auto") && isTRUE(d$ambiguous_cross_sample)) status_class <- "alert alert-warning"

    div(class = status_class, tags$pre(style = "margin:0;", paste(msgs, collapse = "\n")))
  })

  output$vdj_safe_download_loupe_file_btn <- downloadHandler(
    filename = function() {
      fname <- input$vdj_safe_loupe_filename_input
      if (!endsWith(fname, ".cloupe")) fname <- paste0(fname, ".cloupe")
      fname
    },
    content = function(file) {
      sel <- vdj_safe_selected_object_to_export()
      req(sel)

      mode <- input$vdj_safe_sample_mode %||% "auto"
      split_sample <- input$vdj_safe_split_sample %||% ""

      showNotification(
        VDJ_SAFE_EXPORT_UI_TEXT$ui_notification_generating,
        type = "message", duration = NULL, id = "vdj_safe_loupe_notification"
      )

      log_lines <- character()
      append_log <- function(...) {
        ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
        log_lines <<- c(log_lines, paste0("[", ts, "] ", paste0(..., collapse = "")))
      }

      tmp_dir <- tempdir()
      tryCatch({
        append_log("Starting VDJ-safe export. mode=", mode, " split_sample=", split_sample)
        tmp_out <- file.path(tmp_dir, "vdj_safe_export.cloupe")
        res <- .vdj_safe_export_to_loupe(
          sel,
          tmp_out,
          sample_mode = mode,
          split_sample = split_sample,
          assay_name = input$vdj_safe_export_assay_input %||% ""
        )
        append_log("Prepared export with ", res$n_cells, " cells.")
        actual <- res$path
        if (!file.exists(actual)) stop("Exporter did not write a .cloupe file.")
        file.copy(actual, file, overwrite = TRUE)
        removeNotification("vdj_safe_loupe_notification")
      }, error = function(e) {
        removeNotification("vdj_safe_loupe_notification")
        showNotification(
          paste(VDJ_SAFE_EXPORT_UI_TEXT$ui_notification_error_prefix, conditionMessage(e)),
          type = "error"
        )
        .show_vdj_safe_export_error_modal(
          VDJ_SAFE_EXPORT_UI_TEXT$ui_text_modal_title_failed,
          c(
            VDJ_SAFE_EXPORT_UI_TEXT$ui_text_modal_debug_intro,
            VDJ_SAFE_EXPORT_UI_TEXT$ui_text_modal_separator,
            log_lines,
            paste0(VDJ_SAFE_EXPORT_UI_TEXT$ui_text_error_prefix, conditionMessage(e))
          )
        )
      })
    }
  )
}
