`%||%` <- function(a, b) if (is.null(a)) b else a

contam_detect_gpu_available <- function() {
  nvsmi <- Sys.which("nvidia-smi")
  if (!nzchar(nvsmi)) return(FALSE)
  out <- tryCatch(system2(nvsmi, "-L", stdout = TRUE, stderr = TRUE), error = function(e) character(0))
  any(grepl("GPU", out, ignore.case = TRUE))
}

contam_build_cellbender_command <- function(raw_h5_path, output_h5_path, config = list()) {
  exe <- as.character(config$executable %||% "cellbender")
  epochs <- as.integer(config$epochs %||% 150L)
  fpr <- as.numeric(config$fpr %||% 0.01)
  cpu_threads <- as.integer(config$cpu_threads %||% 8L)

  args <- c(
    "remove-background",
    "--input", raw_h5_path,
    "--output", output_h5_path,
    "--expected-cells", as.character(as.integer(config$expected_cells %||% 3000L)),
    "--total-droplets-included", as.character(as.integer(config$total_droplets_included %||% 20000L)),
    "--fpr", as.character(fpr),
    "--epochs", as.character(epochs)
  )

  use_cuda <- isTRUE(config$use_cuda %||% TRUE)
  gpu_ok <- contam_detect_gpu_available()
  if (isTRUE(use_cuda) && isTRUE(gpu_ok)) {
    args <- c(args, "--cuda")
  } else if (isTRUE(use_cuda) && !isTRUE(gpu_ok)) {
    if (!isTRUE(config$allow_cpu_fallback %||% FALSE)) {
      stop("CellBender requested with CUDA but GPU was not detected. Set allow_cpu_fallback=TRUE to proceed on CPU.")
    }
    args <- c(args, "--cpu-threads", as.character(max(1L, cpu_threads)))
  } else {
    args <- c(args, "--cpu-threads", as.character(max(1L, cpu_threads)))
  }

  list(executable = exe, args = args, gpu_available = isTRUE(gpu_ok))
}

.contam_read_cellbender_h5 <- function(path) {
  x <- Seurat::Read10X_h5(path)
  if (is.list(x)) {
    nms <- tolower(names(x) %||% character(0))
    ridx <- which(grepl("gene expression|rna", nms))
    if (!length(ridx)) ridx <- 1
    x <- x[[ridx[[1]]]]
  }
  x
}

contam_run_cellbender_backend <- function(seurat_obj, sample_context = list(), config = list()) {
  raw_h5 <- as.character(sample_context$raw_h5_path %||% "")
  if (!nzchar(raw_h5) || !file.exists(raw_h5)) {
    stop("CellBender requires raw_h5_path to exist.")
  }

  out_dir <- as.character(config$output_dir %||% tempfile(pattern = "cellbender_"))
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  output_h5 <- file.path(out_dir, "output.h5")
  output_report <- file.path(out_dir, "output_report.html")
  output_metrics <- file.path(out_dir, "output_metrics.csv")
  run_log <- file.path(out_dir, "cellbender.log")

  cmd <- contam_build_cellbender_command(raw_h5, output_h5, config = config)

  if (isTRUE(config$execute %||% FALSE)) {
    status <- tryCatch(
      system2(cmd$executable, cmd$args, stdout = run_log, stderr = run_log),
      error = function(e) {
        writeLines(c("CellBender execution failed:", conditionMessage(e)), con = run_log)
        1L
      }
    )
    if (!identical(status, 0L)) {
      stop("CellBender command failed. Check log: ", run_log)
    }
  }

  if (!file.exists(output_h5)) {
    stop(
      "CellBender output.h5 was not found. Expected at: ", output_h5,
      ". If running externally, place outputs in this folder then re-run import mode."
    )
  }

  corrected <- .contam_read_cellbender_h5(output_h5)
  if (!inherits(corrected, "Matrix")) {
    stop("Unable to import corrected CellBender matrix from output.h5.")
  }

  list(
    corrected_counts = corrected,
    contamination_per_cell = NULL,
    contamination_global = NA_real_,
    method_meta = list(
      method = "CellBender",
      raw_h5_path = raw_h5,
      output_h5 = output_h5,
      output_report = output_report,
      output_metrics = output_metrics,
      command = paste(c(cmd$executable, cmd$args), collapse = " "),
      gpu_available = isTRUE(cmd$gpu_available),
      executed = isTRUE(config$execute %||% FALSE),
      run_log = run_log
    )
  )
}
