# DEPRECATED FILE
# This file is no longer used by app routing.
# Use versioned core modules instead:
# - core/seurat_v4/*
# - core/seurat_v5/*
# Kept only for historical reference.

# utils_seurat_backend.R
# Shared Seurat version detection helpers for core modules.

core_detect_seurat_major <- function(lib_path = NULL) {
  v <- NA_character_

  if (!is.null(lib_path) && dir.exists(lib_path)) {
    v <- tryCatch(as.character(utils::packageVersion("Seurat", lib.loc = lib_path)), error = function(e) NA_character_)
  }

  if (is.na(v)) {
    v <- tryCatch(as.character(utils::packageVersion("Seurat")), error = function(e) NA_character_)
  }

  if (is.na(v)) return(NA_integer_)

  parts <- strsplit(v, "\\.", fixed = FALSE)[[1]]
  major <- suppressWarnings(as.integer(parts[1]))
  major
}

core_resolve_qc_backend <- function(lib_path = NULL) {
  major <- core_detect_seurat_major(lib_path = lib_path)

  candidate <- switch(
    as.character(major),
    "5" = file.path("core", "backends", "qc_seurat_v5.R"),
    "4" = file.path("core", "backends", "qc_seurat_v4.R"),
    file.path("core", "backends", "qc_seurat_v4.R")
  )

  if (!file.exists(candidate)) {
    stop("QC backend file missing: ", candidate)
  }

  list(major = major, file = candidate)
}
