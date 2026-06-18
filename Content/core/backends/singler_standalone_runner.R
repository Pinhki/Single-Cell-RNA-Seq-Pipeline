# Standalone SingleR runner (outside Shiny)
# Edit knobs below and run this file in RStudio.

`%||%` <- function(a, b) if (is.null(a)) b else a

# ========================= USER KNOBS =========================
OBJECT_FILE <- ""
OBJECT_NAME <- ""
LIST_ONLY <- FALSE

PROJECT_ROOT <- ""
LIB_MODE <- "auto"  # auto | seurat_v5 | seurat_v4 | none

RUN_MODE <- "per_cell"  # per_cell | cluster
CLUSTER_COLUMN <- ""

REFERENCE_NAME <- "ImmGenData"
LABEL_LEVEL <- "label.main"
ASSAY_NAME <- "RNA"
SLOT_NAME <- "data"
PRUNE <- TRUE
FINE_TUNE <- TRUE
NUM_THREADS <- 1L
MIN_COMMON_GENES <- 100L
ABORT_ON_LOW_OVERLAP <- TRUE
USE_SAFE_TRAIN_CLASSIFY <- TRUE
FORCE_DENSE_REF <- TRUE
AGGR_REF <- TRUE
CHECK_MISSING_REF <- TRUE
AUTO_INSTALL_MISSING <- TRUE
WRITE_SESSIONINFO_EARLY <- TRUE

OUTPUT_DIR <- "results/singler_standalone"
# =============================================================

.log <- function(...) cat("[SingleR standalone] ", paste0(...), "\n", sep = "")
.stopf <- function(...) stop(sprintf(...), call. = FALSE)

.find_project_root <- function(start_dir = getwd()) {
  if (nzchar(PROJECT_ROOT %||% "")) return(normalizePath(PROJECT_ROOT, mustWork = TRUE))
  cur <- normalizePath(start_dir, mustWork = TRUE)
  for (i in seq_len(10L)) {
    if (file.exists(file.path(cur, "Content", "run.R"))) return(cur)
    parent <- dirname(cur)
    if (identical(parent, cur)) break
    cur <- parent
  }
  .stopf("Could not detect project root from '%s'. Set PROJECT_ROOT explicitly.", start_dir)
}

.configure_libpaths <- function(project_root, lib_mode = "auto") {
  lib_mode <- tolower(trimws(as.character(lib_mode %||% "auto")))
  if (identical(lib_mode, "none")) {
    .log("LIB_MODE='none': keeping existing .libPaths()")
    return(invisible(.libPaths()))
  }
  pkg_root <- file.path(project_root, "package_libraries")
  core_lib <- file.path(pkg_root, "core")
  v4_lib <- file.path(pkg_root, "seurat_v4")
  v5_lib <- file.path(pkg_root, "seurat_v5")
  candidates <- switch(
    lib_mode,
    "seurat_v4" = c(core_lib, v4_lib),
    "seurat_v5" = c(core_lib, v5_lib),
    "auto" = c(core_lib, if (dir.exists(v5_lib)) v5_lib, if (dir.exists(v4_lib)) v4_lib),
    c(core_lib)
  )
  candidates <- unique(candidates[nzchar(candidates) & dir.exists(candidates)])
  if (!length(candidates)) .stopf("No valid project library paths found under '%s'.", pkg_root)
  .libPaths(unique(c(candidates, .libPaths())))
  .log("Using .libPaths(): ", paste(.libPaths(), collapse = " | "))
  invisible(.libPaths())
}

.require_pkgs <- function(pkgs) {
  missing <- pkgs[!vapply(pkgs, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))]
  if (length(missing)) {
    .stopf("Missing required package(s): %s. Install via Content/run.R bootstrap first.", paste(missing, collapse = ", "))
  }
}

.is_seurat_like <- function(x) {
  cls <- tryCatch(class(x), error = function(e) character(0))
  any(cls %in% "Seurat")
}

.ensure_pkg_available <- function(pkg, lib_target, auto_install = TRUE) {
  if (isTRUE(requireNamespace(pkg, quietly = TRUE))) return(invisible(TRUE))
  if (!isTRUE(auto_install)) {
    .stopf("Required package '%s' is missing. Set AUTO_INSTALL_MISSING=TRUE or install it into project libraries.", pkg)
  }
  .log("Package '", pkg, "' is missing. Attempting install into: ", lib_target)
  if (!dir.exists(lib_target)) dir.create(lib_target, recursive = TRUE, showWarnings = FALSE)

  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager", lib = lib_target, repos = "https://cloud.r-project.org")
  }
  suppressWarnings(
    BiocManager::install(
      pkg,
      ask = FALSE,
      update = FALSE,
      lib = lib_target
    )
  )
  if (!isTRUE(requireNamespace(pkg, quietly = TRUE))) {
    .stopf("Auto-install failed for package '%s'. Please run Content/run.R bootstrap/install flow.", pkg)
  }
  .log("Package '", pkg, "' installed and available.")
  invisible(TRUE)
}

.write_session_report <- function(path, note = "") {
  con <- file(path, open = "wt")
  on.exit(close(con), add = TRUE)
  cat("singleR standalone diagnostic report\n", file = con)
  cat("note: ", note, "\n", sep = "", file = con)
  cat("timestamp: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"), "\n\n", sep = "", file = con)
  cat(".libPaths():\n", file = con)
  for (p in .libPaths()) cat(" - ", p, "\n", sep = "", file = con)
  cat("\npackage versions:\n", file = con)
  pkgs <- c("SingleR", "celldex", "scrapper", "Seurat", "SummarizedExperiment", "Matrix", "BiocParallel")
  for (pkg in pkgs) {
    if (isTRUE(requireNamespace(pkg, quietly = TRUE))) {
      cat(" - ", pkg, ": ", as.character(utils::packageVersion(pkg)), "\n", sep = "", file = con)
    } else {
      cat(" - ", pkg, ": MISSING\n", sep = "", file = con)
    }
  }
  cat("\nsessionInfo():\n", file = con)
  si <- capture.output(sessionInfo())
  cat(paste(si, collapse = "\n"), "\n", file = con, sep = "")
  invisible(path)
}

.collect_seurat_candidates <- function(obj_any) {
  out <- list()
  if (.is_seurat_like(obj_any)) {
    out[["(root)"]] <- obj_any
    return(out)
  }
  if (!is.list(obj_any)) return(out)
  for (nm in names(obj_any)) {
    cand <- obj_any[[nm]]
    if (.is_seurat_like(cand)) out[[nm]] <- cand
    if (is.list(cand) && !is.null(cand[["obj"]]) && .is_seurat_like(cand[["obj"]])) out[[nm]] <- cand[["obj"]]
  }
  if (!length(out) && !is.null(obj_any[["all_seurat_objects"]]) && is.list(obj_any[["all_seurat_objects"]])) {
    aso <- obj_any[["all_seurat_objects"]]
    for (nm in names(aso)) {
      cand <- aso[[nm]]
      cand_obj <- if (is.list(cand) && !is.null(cand[["obj"]])) cand[["obj"]] else cand
      if (.is_seurat_like(cand_obj)) out[[nm]] <- cand_obj
    }
  }
  out
}

.print_candidates <- function(candidates, object_file) {
  .log("Available Seurat objects in: ", object_file)
  if (!length(candidates)) {
    .log("  (none found)")
    return(invisible(NULL))
  }
  for (nm in names(candidates)) {
    obj <- candidates[[nm]]
    genes <- tryCatch(nrow(obj), error = function(e) NA_integer_)
    cells <- tryCatch(ncol(obj), error = function(e) NA_integer_)
    .log("  - ", nm, " | genes=", genes, ", cells=", cells)
  }
  invisible(NULL)
}

.load_object <- function(path, object_name = "", list_only = FALSE) {
  if (!nzchar(path)) .stopf("OBJECT_FILE is empty. Please set OBJECT_FILE.")
  path <- normalizePath(path, mustWork = TRUE)
  ext <- tolower(tools::file_ext(path))
  obj <- NULL
  candidates <- list()

  if (ext %in% c("rds")) {
    obj_any <- readRDS(path)
    candidates <- .collect_seurat_candidates(obj_any)
  } else if (ext %in% c("rdata", "rda")) {
    env <- new.env(parent = emptyenv())
    loaded <- load(path, envir = env)
    for (one in loaded) {
      cand <- get(one, envir = env, inherits = FALSE)
      if (.is_seurat_like(cand)) candidates[[one]] <- cand
      if (is.list(cand) && !length(candidates)) {
        extra <- .collect_seurat_candidates(cand)
        if (length(extra)) for (nm in names(extra)) candidates[[nm]] <- extra[[nm]]
      }
    }
  } else {
    .stopf("Unsupported OBJECT_FILE extension: %s", ext)
  }

  .print_candidates(candidates, path)
  if (isTRUE(list_only)) return(invisible(NULL))

  nm <- trimws(as.character(object_name %||% ""))
  if (nzchar(nm)) {
    obj <- candidates[[nm]]
    if (is.null(obj)) .stopf("OBJECT_NAME '%s' was not found in %s", nm, path)
  } else if (length(candidates)) {
    obj <- candidates[[1]]
    .log("OBJECT_NAME not provided, selected first Seurat object: ", names(candidates)[[1]])
  }

  if (is.null(obj) || !.is_seurat_like(obj)) {
    .stopf("Could not find a Seurat object in '%s'. Set OBJECT_NAME if needed.", path)
  }
  obj
}

.ensure_out_dir <- function(project_root, out_dir) {
  out_path <- if (grepl("^(/|[A-Za-z]:[/\\\\])", out_dir)) out_dir else file.path(project_root, out_dir)
  dir.create(out_path, recursive = TRUE, showWarnings = FALSE)
  normalizePath(out_path, mustWork = TRUE)
}

.build_result_df <- function(pred, cells, cluster_values = NULL) {
  pred_df <- as.data.frame(pred)
  if (is.null(cluster_values)) {
    out <- data.frame(
      cell = rownames(pred_df),
      final_label = as.character(pred_df$pruned.labels %||% pred_df$labels %||% ""),
      raw_label = as.character(pred_df$labels %||% ""),
      confidence = as.numeric(pred_df$delta.next %||% NA_real_),
      stringsAsFactors = FALSE
    )
  } else {
    cl_map <- data.frame(cluster = rownames(pred_df), stringsAsFactors = FALSE)
    cl_map$final_label <- as.character(pred_df$pruned.labels %||% pred_df$labels %||% "")
    cl_map$raw_label <- as.character(pred_df$labels %||% "")
    cl_map$confidence <- as.numeric(pred_df$delta.next %||% NA_real_)
    out <- data.frame(cell = cells, cluster = cluster_values, stringsAsFactors = FALSE)
    out <- merge(out, cl_map, by = "cluster", all.x = TRUE, sort = FALSE)
  }
  out$tool <- "SingleR"
  out$status <- ifelse(is.na(out$final_label) | !nzchar(out$final_label), "unresolved", "matched")
  out$confidence <- as.numeric(out$confidence)
  out[, c("cell", "final_label", "raw_label", "confidence", "tool", "status"), drop = FALSE]
}

.ref_matrix_for_training <- function(ref, force_dense = TRUE) {
  assay_name <- if ("logcounts" %in% SummarizedExperiment::assayNames(ref)) "logcounts" else SummarizedExperiment::assayNames(ref)[[1]]
  ref_mat <- SummarizedExperiment::assay(ref, assay_name)
  if (isTRUE(force_dense)) ref_mat <- as.matrix(ref_mat)
  rownames(ref_mat) <- rownames(ref)
  list(mat = ref_mat, assay_name = assay_name, dense = isTRUE(force_dense))
}

# ----------------------- MAIN -----------------------
project_root <- .find_project_root()
.log("Project root: ", project_root)

obj <- .load_object(OBJECT_FILE, OBJECT_NAME, list_only = isTRUE(LIST_ONLY))
if (isTRUE(LIST_ONLY)) {
  .log("LIST_ONLY=TRUE. Exiting after object listing.")
  if (!interactive()) {
    quit(save = "no", status = 0L)
  } else {
    .log("Interactive session detected; skipping SingleR run.")
  }
}

if (!isTRUE(LIST_ONLY)) {
  out_dir <- .ensure_out_dir(project_root, OUTPUT_DIR)
  diag_stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  diag_session_path <- file.path(out_dir, paste0("singleR_diag_", diag_stamp, "_sessionInfo.txt"))

  .configure_libpaths(project_root, LIB_MODE)
  if (isTRUE(WRITE_SESSIONINFO_EARLY)) {
    .write_session_report(diag_session_path, note = "startup-after-libpaths-before-dependency-check")
    .log("Session report written: ", diag_session_path)
  }
  pkgs <- c("SingleR", "celldex", "scrapper", "Seurat", "SummarizedExperiment", "Matrix", "BiocParallel")
  for (pkg in pkgs) {
    ver <- if (isTRUE(requireNamespace(pkg, quietly = TRUE))) as.character(utils::packageVersion(pkg)) else "MISSING"
    .log("Package check: ", pkg, "=", ver)
  }
  .require_pkgs(c("SingleR", "celldex", "Seurat", "SummarizedExperiment"))

  helper_path <- file.path(project_root, "Content", "core", "backends", "singler_annotation_core.R")
  if (file.exists(helper_path)) source(helper_path)

  if (isTRUE(USE_SAFE_TRAIN_CLASSIFY) && isTRUE(AGGR_REF)) {
    core_lib <- file.path(project_root, "package_libraries", "core")
    .ensure_pkg_available("scrapper", lib_target = core_lib, auto_install = isTRUE(AUTO_INSTALL_MISSING))
    .libPaths(unique(c(core_lib, .libPaths())))
    if (isTRUE(WRITE_SESSIONINFO_EARLY)) {
      .write_session_report(diag_session_path, note = "startup-after-scrapper-install")
      .log("Session report refreshed: ", diag_session_path)
    }
  }

.log("Loaded object class: ", paste(class(obj), collapse = "/"))
if (!(ASSAY_NAME %in% Seurat::Assays(obj))) {
  .stopf("Assay '%s' not found. Available: %s", ASSAY_NAME, paste(Seurat::Assays(obj), collapse = ", "))
}

test_mat <- Seurat::GetAssayData(obj, assay = ASSAY_NAME, slot = SLOT_NAME)
if (exists("singler_validate_test_matrix", mode = "function")) {
  singler_validate_test_matrix(test_mat)
} else {
  if (is.null(rownames(test_mat)) || is.null(colnames(test_mat))) .stopf("test_mat must have row/col names.")
}
.log("Test matrix dims: genes=", nrow(test_mat), ", cells=", ncol(test_mat), ", class=", paste(class(test_mat), collapse = "/"))

ref_fun <- get(REFERENCE_NAME, envir = asNamespace("celldex"))
ref <- ref_fun()
.log("Reference loaded: ", REFERENCE_NAME, " | genes=", nrow(ref), ", samples=", ncol(ref))

labels_ref <- as.character(SummarizedExperiment::colData(ref)[[LABEL_LEVEL]])
if (!length(labels_ref)) .stopf("Label level '%s' is unavailable in reference.", LABEL_LEVEL)
labels_ref[is.na(labels_ref)] <- ""
.log("Reference labels: total=", length(labels_ref), ", unique_non_missing=", length(unique(labels_ref[nzchar(labels_ref)])))

overlap_details <- if (exists("singler_collect_overlap_details", mode = "function")) {
  singler_collect_overlap_details(
    test_mat = test_mat,
    ref = ref,
    ref_name = REFERENCE_NAME,
    min_common_genes = as.integer(MIN_COMMON_GENES)
  )
} else {
  tg <- rownames(test_mat)
  rg <- rownames(ref)
  list(
    test_genes = length(tg),
    ref_genes = length(rg),
    common_genes = length(intersect(tg, rg)),
    min_common_genes = as.integer(MIN_COMMON_GENES),
    ok = length(intersect(tg, rg)) >= as.integer(MIN_COMMON_GENES)
  )
}
.log(
  "Overlap summary: common_genes=", overlap_details$common_genes,
  ", min_required=", overlap_details$min_common_genes,
  ", ok=", isTRUE(overlap_details$ok)
)
if (!isTRUE(overlap_details$ok) && isTRUE(ABORT_ON_LOW_OVERLAP)) {
  if (exists("singler_overlap_message", mode = "function")) {
    stop(singler_overlap_message(overlap_details, label_level = LABEL_LEVEL), call. = FALSE)
  } else {
    .stopf("Low overlap: only %d common genes.", overlap_details$common_genes)
  }
}

run_mode <- tolower(trimws(as.character(RUN_MODE %||% "per_cell")))
if (!(run_mode %in% c("per_cell", "cluster"))) {
  .stopf("RUN_MODE must be 'per_cell' or 'cluster'. Got: %s", RUN_MODE)
}

serial_param <- NULL
if (requireNamespace("BiocParallel", quietly = TRUE)) {
  serial_param <- BiocParallel::SerialParam(progressbar = TRUE)
}

.log(
  "SingleR run start: mode=", run_mode,
  ", prune=", PRUNE,
  ", fine_tune=", FINE_TUNE,
  ", num_threads=", as.integer(NUM_THREADS),
  ", safe_train_classify=", isTRUE(USE_SAFE_TRAIN_CLASSIFY)
)

pred <- if (identical(run_mode, "cluster")) {
  if (!nzchar(CLUSTER_COLUMN)) .stopf("CLUSTER_COLUMN is required when RUN_MODE='cluster'.")
  md <- obj@meta.data
  if (!(CLUSTER_COLUMN %in% colnames(md))) .stopf("CLUSTER_COLUMN '%s' not found in metadata.", CLUSTER_COLUMN)
  clusters <- as.character(md[[CLUSTER_COLUMN]])
  .log("Cluster mode: column=", CLUSTER_COLUMN, ", unique_clusters=", length(unique(clusters)))
  SingleR::SingleR(
    test = test_mat, ref = ref, labels = labels_ref,
    clusters = clusters,
    fine.tune = isTRUE(FINE_TUNE), prune = isTRUE(PRUNE),
    num.threads = as.integer(NUM_THREADS), BPPARAM = serial_param
  )
} else {
  if (isTRUE(USE_SAFE_TRAIN_CLASSIFY)) {
    ref_info <- .ref_matrix_for_training(ref, force_dense = isTRUE(FORCE_DENSE_REF))
    .log(
      "Safe train/classify path: ref_assay=", ref_info$assay_name,
      ", force_dense_ref=", isTRUE(FORCE_DENSE_REF),
      ", aggr_ref=", isTRUE(AGGR_REF),
      ", check_missing_ref=", isTRUE(CHECK_MISSING_REF)
    )
    trained <- SingleR::trainSingleR(
      ref = ref_info$mat,
      labels = labels_ref,
      test.genes = rownames(test_mat),
      check.missing = isTRUE(CHECK_MISSING_REF),
      aggr.ref = isTRUE(AGGR_REF),
      num.threads = as.integer(NUM_THREADS),
      BPPARAM = serial_param
    )
    SingleR::classifySingleR(
      test = test_mat,
      trained = trained,
      fine.tune = isTRUE(FINE_TUNE),
      prune = isTRUE(PRUNE),
      num.threads = as.integer(NUM_THREADS),
      BPPARAM = serial_param
    )
  } else {
    SingleR::SingleR(
      test = test_mat, ref = ref, labels = labels_ref,
      fine.tune = isTRUE(FINE_TUNE), prune = isTRUE(PRUNE),
      num.threads = as.integer(NUM_THREADS), BPPARAM = serial_param
    )
  }
}

cells <- colnames(test_mat)
cluster_values <- if (identical(run_mode, "cluster")) as.character(obj@meta.data[[CLUSTER_COLUMN]]) else NULL
out <- .build_result_df(pred = pred, cells = cells, cluster_values = cluster_values)

stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
base <- paste0("singleR_", run_mode, "_", REFERENCE_NAME, "_", stamp)
csv_path <- file.path(out_dir, paste0(base, ".csv"))
rds_path <- file.path(out_dir, paste0(base, ".rds"))
meta_path <- diag_session_path

utils::write.csv(out, csv_path, row.names = FALSE)
saveRDS(
  list(
    result = out,
    pred = pred,
    params = list(
      object_file = normalizePath(OBJECT_FILE, mustWork = TRUE),
      object_name = OBJECT_NAME,
      run_mode = run_mode,
      cluster_column = CLUSTER_COLUMN,
      reference = REFERENCE_NAME,
      label_level = LABEL_LEVEL,
      assay = ASSAY_NAME,
      slot = SLOT_NAME,
      prune = isTRUE(PRUNE),
      fine_tune = isTRUE(FINE_TUNE),
      num_threads = as.integer(NUM_THREADS),
      min_common_genes = as.integer(MIN_COMMON_GENES),
      abort_on_low_overlap = isTRUE(ABORT_ON_LOW_OVERLAP),
      use_safe_train_classify = isTRUE(USE_SAFE_TRAIN_CLASSIFY),
      force_dense_ref = isTRUE(FORCE_DENSE_REF),
      aggr_ref = isTRUE(AGGR_REF),
      check_missing_ref = isTRUE(CHECK_MISSING_REF),
      auto_install_missing = isTRUE(AUTO_INSTALL_MISSING),
      overlap = overlap_details,
      lib_paths = .libPaths(),
      timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")
    )
  ),
  rds_path
)
.write_session_report(meta_path, note = "completed")

  .log("Run complete.")
  .log("Rows: ", nrow(out), " | matched=", sum(out$status == "matched", na.rm = TRUE), " | unresolved=", sum(out$status != "matched", na.rm = TRUE))
  .log("CSV: ", csv_path)
  .log("RDS: ", rds_path)
  .log("Session info: ", meta_path)
  print(utils::head(out, n = 8))
  invisible(out)
}
