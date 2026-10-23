#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3L) {
  stop("Usage: loupe_export_worker.R <setup|export-simple|export-vdj-safe> <input> <result>")
}

mode <- args[[1]]
input_path <- normalizePath(args[[2]], mustWork = TRUE)
result_path <- args[[3]]

`%||%` <- function(x, y) if (is.null(x) || !length(x)) y else x

# Agent note: Parent process polls result_path while streaming worker.log;
# publish result atomically so it never reads a partially written RDS file.
.write_result <- function(value) {
  tmp_path <- paste0(result_path, ".tmp-", Sys.getpid())
  saveRDS(value, tmp_path)
  if (isTRUE(file.rename(tmp_path, result_path))) return(invisible(TRUE))
  copied <- file.copy(tmp_path, result_path, overwrite = TRUE)
  unlink(tmp_path, force = TRUE)
  if (!isTRUE(copied)) stop("Unable to publish loupeR worker result.")
  invisible(TRUE)
}

.worker_lib_paths <- function(prefer_lib) {
  prefer_lib <- normalizePath(prefer_lib, mustWork = TRUE)
  core_lib <- file.path(dirname(prefer_lib), "core")
  unique(c(prefer_lib, core_lib[dir.exists(core_lib)], .Library.site, .Library))
}

.save_failure <- function(e) {
  try(.write_result(list(ok = FALSE, error = conditionMessage(e))), silent = TRUE)
  quit(save = "no", status = 1L)
}

tryCatch({
  if (identical(mode, "setup")) {
    lib_path <- input_path
    .libPaths(.worker_lib_paths(lib_path))
    Sys.setenv(AUTO_ACCEPT_EULA = "true")
    suppressPackageStartupMessages(library("loupeR", lib.loc = .libPaths(), character.only = TRUE))
    loupeR::setup()
    find_executable <- get("find_executable", envir = asNamespace("loupeR"))
    executable <- find_executable()
    .write_result(list(ok = TRUE, executable = executable))
  } else {
    # BPCells objects store external on-disk matrix references. Add the managed
    # core library before unserializing the payload so those references resolve.
    worker_core_candidates <- c(
      file.path(getwd(), "package_libraries", "core"),
      file.path(dirname(getwd()), "package_libraries", "core")
    )
    .libPaths(unique(c(worker_core_candidates[dir.exists(worker_core_candidates)], .libPaths())))
    payload <- readRDS(input_path)
    progress_path <- trimws(as.character(payload$progress_path %||% ""))
    .emit_progress_message <- function(msg) {
      if (!nzchar(progress_path)) return(invisible(NULL))
      try(cat(as.character(msg %||% ""), "\n", file = progress_path, append = TRUE), silent = TRUE)
      invisible(NULL)
    }
    .with_progress_messages <- function(expr) {
      withCallingHandlers(
        expr,
        message = function(condition) .emit_progress_message(conditionMessage(condition))
      )
    }
    .libPaths(.worker_lib_paths(payload$prefer_lib))
    Sys.setenv(AUTO_ACCEPT_EULA = "true", WANLAB_LOUPER_WORKER = "1")
    if (requireNamespace("BPCells", quietly = TRUE)) {
      suppressPackageStartupMessages(library("BPCells", lib.loc = .libPaths(), character.only = TRUE))
    }
    suppressPackageStartupMessages(library(shiny))

    source(payload$page_export_path, local = .GlobalEnv)
    if (identical(mode, "export-simple")) {
      value <- .with_progress_messages({
        .export_to_loupe_simple_in_process(
          sel = payload$sel,
          sel_entry = payload$sel_entry %||% payload$sel,
          out_path = payload$out_path,
          sel_name = payload$sel_name,
          shared_data = payload$shared_data,
          prefer_lib = payload$prefer_lib,
          assay_name = payload$assay_name,
          drop_invalid_cells = payload$drop_invalid_cells
        )
      })
    } else if (identical(mode, "export-vdj-safe")) {
      source(payload$page_vdj_path, local = .GlobalEnv)
      value <- .with_progress_messages({
        .vdj_safe_export_to_loupe_in_process(
          sel = payload$sel,
          out_path = payload$out_path,
          sample_mode = payload$sample_mode,
          split_sample = payload$split_sample,
          assay_name = payload$assay_name
        )
      })
    } else {
      stop("Unknown loupeR worker mode: ", mode)
    }
    .write_result(list(ok = TRUE, value = value))
  }
}, error = .save_failure)
