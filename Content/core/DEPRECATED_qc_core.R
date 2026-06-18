# DEPRECATED FILE
# This file is no longer used by app routing.
# Use versioned core modules instead:
# - core/seurat_v4/*
# - core/seurat_v5/*
# Kept only for historical reference.

# qc_core.R
# QC step core entry point: app-safe functions + standalone RStudio execution.

# ------------------------------
# Standalone knobs (RStudio)
# ------------------------------
# Set TRUE, then select-all-and-run this file in RStudio.
QC_CORE_AUTORUN <- FALSE

# Name of in-memory Seurat object in .GlobalEnv (used if sample sheet is NULL).
QC_CORE_INPUT_OBJECT_NAME <- "seurat_obj"

# Optional sample sheet data.frame. If NULL, the in-memory object route is used.
# Required columns when provided: name, path
QC_CORE_INPUT_SAMPLE_SHEET <- NULL

# Seurat major version hint for standalone mode: "auto", "4", or "5".
# "auto" uses whichever Seurat major is currently available in this R session.
QC_CORE_SEURAT_VERSION <- "auto"

# Apply filter thresholds if present in sheet columns.
QC_CORE_APPLY_FILTERS <- FALSE

# Render default QC plots in RStudio Plots pane during autorun.
QC_CORE_PRINT_PLOTS <- TRUE

# Optional sample name for plotting when multiple samples are loaded.
QC_CORE_PLOT_SAMPLE_NAME <- NULL

# Result object name written to .GlobalEnv when autorun is enabled.
QC_CORE_OUTPUT_OBJECT_NAME <- "qc_core_result"


# ------------------------------
# Internal helpers
# ------------------------------
`%||%` <- function(a, b) if (is.null(a)) b else a

.core_qc_ensure_backend_utils <- function() {
  if (!exists("core_resolve_qc_backend", mode = "function")) {
    source(file.path("core", "utils_seurat_backend.R"), local = FALSE)
  }
}

.core_qc_backend_from_version <- function(seurat_version = "auto", lib_path = NULL) {
  .core_qc_ensure_backend_utils()

  if (!is.null(lib_path) && dir.exists(lib_path)) {
    return(core_resolve_qc_backend(lib_path = lib_path))
  }

  sv <- tolower(as.character(seurat_version %||% "auto"))
  if (!sv %in% c("auto", "4", "5")) {
    stop("seurat_version must be one of: 'auto', '4', '5'.")
  }

  if (sv == "auto") {
    return(core_resolve_qc_backend(lib_path = NULL))
  }

  candidate <- if (sv == "5") {
    file.path("core", "backends", "qc_seurat_v5.R")
  } else {
    file.path("core", "backends", "qc_seurat_v4.R")
  }

  if (!file.exists(candidate)) {
    stop("QC backend file missing: ", candidate)
  }

  list(major = suppressWarnings(as.integer(sv)), file = candidate)
}

.core_qc_default_row <- function(name, path) {
  data.frame(
    name = as.character(name),
    path = as.character(path),
    type = "rds",
    condition = "Unknown",
    batch = "Batch1",
    qc_status = "Pending",
    use_in_analysis = TRUE,
    min_features = 200,
    max_features = 5000,
    min_umi_counts = 500,
    max_umi_counts = 50000,
    max_mt_percent = 20,
    stringsAsFactors = FALSE
  )
}

.core_qc_normalize_sheet <- function(sample_info_df) {
  if (!is.data.frame(sample_info_df) || nrow(sample_info_df) == 0) {
    stop("sample_info_df must be a non-empty data.frame.")
  }

  required <- c("name", "path")
  missing <- setdiff(required, names(sample_info_df))
  if (length(missing)) {
    stop("sample_info_df missing required columns: ", paste(missing, collapse = ", "))
  }

  defaults <- .core_qc_default_row("sample", "path")[1, , drop = FALSE]
  for (nm in setdiff(names(defaults), names(sample_info_df))) {
    sample_info_df[[nm]] <- defaults[[nm]][[1]]
  }

  sample_info_df
}

.core_qc_pick_plot_object <- function(objects, sample_name = NULL) {
  nm <- names(objects)
  if (!length(nm)) return(NULL)

  target <- if (!is.null(sample_name) && nzchar(sample_name) && sample_name %in% nm) {
    sample_name
  } else {
    nm[[1]]
  }

  objects[[target]]
}

.core_qc_make_default_plots <- function(sobj) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) {
    return(list())
  }

  plots <- list()

  plots$vln <- tryCatch({
    Seurat::VlnPlot(
      sobj,
      features = c("nFeature_RNA", "nCount_RNA", "percent.mt"),
      ncol = 3,
      pt.size = 0.01
    )
  }, error = function(e) NULL)

  plots$scatter_counts_features <- tryCatch({
    Seurat::FeatureScatter(sobj, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
  }, error = function(e) NULL)

  plots$scatter_counts_mt <- tryCatch({
    Seurat::FeatureScatter(sobj, feature1 = "nCount_RNA", feature2 = "percent.mt")
  }, error = function(e) NULL)

  Filter(Negate(is.null), plots)
}


# ------------------------------
# Public API for app + script
# ------------------------------
core_build_qc_objects <- function(sample_info_df, lib_path = NULL) {
  backend <- .core_qc_backend_from_version(seurat_version = "auto", lib_path = lib_path)
  message(
    "[qc_core] Using Seurat backend v",
    ifelse(is.na(backend$major), "unknown", backend$major),
    " from ", backend$file
  )

  env <- new.env(parent = baseenv())
  source(backend$file, local = env)

  if (!exists("build_qc_objects", envir = env, inherits = FALSE)) {
    stop("QC backend did not define build_qc_objects(): ", backend$file)
  }

  get("build_qc_objects", envir = env, inherits = FALSE)(sample_info_df)
}

core_run_qc_step <- function(
  sample_info_df = NULL,
  seurat_object = NULL,
  sample_name = "sample_1",
  seurat_version = "auto",
  lib_path = NULL,
  apply_filters = FALSE,
  temp_dir = tempdir(),
  cleanup_temp = TRUE
) {
  temp_rds <- NULL
  on.exit({
    if (isTRUE(cleanup_temp) && !is.null(temp_rds) && file.exists(temp_rds)) {
      unlink(temp_rds, force = TRUE)
    }
  }, add = TRUE)

  if (is.null(sample_info_df)) {
    if (is.null(seurat_object)) {
      stop("Provide either sample_info_df or seurat_object.")
    }
    if (!inherits(seurat_object, "Seurat")) {
      stop("seurat_object must be a Seurat object.")
    }

    dir.create(temp_dir, recursive = TRUE, showWarnings = FALSE)
    temp_rds <- file.path(temp_dir, paste0("qc_core_", format(Sys.time(), "%Y%m%d_%H%M%S"), "_", sample_name, ".rds"))
    saveRDS(seurat_object, temp_rds)
    sample_info_df <- .core_qc_default_row(sample_name, temp_rds)
  } else {
    sample_info_df <- .core_qc_normalize_sheet(sample_info_df)
  }

  backend <- .core_qc_backend_from_version(seurat_version = seurat_version, lib_path = lib_path)
  env <- new.env(parent = baseenv())
  source(backend$file, local = env)

  if (isTRUE(apply_filters) && exists("run_qc_for_all_samples", envir = env, inherits = FALSE)) {
    runner <- get("run_qc_for_all_samples", envir = env, inherits = FALSE)
    objects <- runner(sample_info_df, apply_filters = TRUE)
  } else {
    runner <- get("build_qc_objects", envir = env, inherits = FALSE)
    objects <- runner(sample_info_df)
  }

  plot_obj <- .core_qc_pick_plot_object(objects, sample_name = sample_name)
  plots <- .core_qc_make_default_plots(plot_obj)

  list(
    objects = objects,
    sample_sheet = sample_info_df,
    backend = backend,
    plots = plots,
    errors = attr(objects, "errors") %||% character(0)
  )
}


# ------------------------------
# Optional standalone autorun
# ------------------------------
if (isTRUE(QC_CORE_AUTORUN)) {
  seurat_obj <- NULL
  if (exists(QC_CORE_INPUT_OBJECT_NAME, envir = .GlobalEnv, inherits = FALSE)) {
    seurat_obj <- get(QC_CORE_INPUT_OBJECT_NAME, envir = .GlobalEnv, inherits = FALSE)
  }

  result <- core_run_qc_step(
    sample_info_df = QC_CORE_INPUT_SAMPLE_SHEET,
    seurat_object = seurat_obj,
    sample_name = QC_CORE_PLOT_SAMPLE_NAME %||% QC_CORE_INPUT_OBJECT_NAME,
    seurat_version = QC_CORE_SEURAT_VERSION,
    apply_filters = QC_CORE_APPLY_FILTERS
  )

  assign(QC_CORE_OUTPUT_OBJECT_NAME, result, envir = .GlobalEnv)
  message("[qc_core] Wrote result to .GlobalEnv$", QC_CORE_OUTPUT_OBJECT_NAME)
  message("[qc_core] Loaded objects: ", paste(names(result$objects), collapse = ", "))

  if (isTRUE(QC_CORE_PRINT_PLOTS) && length(result$plots)) {
    for (p in result$plots) {
      try(print(p), silent = TRUE)
    }
  }
}
