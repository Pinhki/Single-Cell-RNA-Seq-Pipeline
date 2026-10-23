# Disk-backed storage for large Seurat objects.
#
# Agent note: Working_Data is a disposable sidecar. Original RDS/raw inputs stay
# authoritative. Complete BPCells layers are staged, verified, then attached to
# a Seurat v5 object; partial folders are never treated as valid data.

if (!exists("%||%", mode = "function", inherits = TRUE)) {
  `%||%` <- function(x, y) if (is.null(x)) y else x
}

.wanlab_working_data_root <- function() {
  root <- Sys.getenv("WANLAB_WORKING_DATA_ROOT", unset = "")
  if (!nzchar(root)) root <- file.path(getwd(), "Working_Data")
  if (!dir.exists(root)) dir.create(root, recursive = TRUE, showWarnings = FALSE)
  normalizePath(root, winslash = "/", mustWork = TRUE)
}

.wanlab_storage_token <- function(x, fallback = "object") {
  x <- trimws(as.character(x %||% ""))
  if (!nzchar(x)) x <- fallback
  x <- gsub("[^A-Za-z0-9._-]+", "_", x, perl = TRUE)
  x <- gsub("_+", "_", x, perl = TRUE)
  x <- gsub("^[._-]+|[._-]+$", "", x, perl = TRUE)
  if (!nzchar(x)) fallback else substr(x, 1L, 96L)
}

.wanlab_emit_storage_progress <- function(progress_cb, text, pct) {
  if (!is.function(progress_cb)) return(invisible(NULL))
  try(progress_cb(text = text, pct = pct), silent = TRUE)
  invisible(NULL)
}

.wanlab_is_seurat_v5_assay <- function(assay) {
  inherits(assay, "Assay5") || inherits(assay, "StdAssay")
}

.wanlab_assay_count_layers <- function(assay) {
  if (.wanlab_is_seurat_v5_assay(assay)) {
    layers <- tryCatch(SeuratObject::Layers(assay), error = function(e) character(0))
    layers <- as.character(layers %||% character(0))
    return(layers[grepl("^counts(?:$|\\.)", layers, perl = TRUE)])
  }
  if ("counts" %in% slotNames(assay)) return("counts")
  character(0)
}

.wanlab_layer_matrix <- function(assay, layer_name) {
  if (.wanlab_is_seurat_v5_assay(assay)) {
    return(SeuratObject::LayerData(assay, layer = layer_name))
  }
  if (identical(layer_name, "counts")) return(assay@counts)
  stop("Unsupported count layer: ", layer_name)
}

.wanlab_attach_layer_matrix <- function(assay, layer_name, matrix_value) {
  if (.wanlab_is_seurat_v5_assay(assay)) {
    SeuratObject::LayerData(assay, layer = layer_name) <- matrix_value
    return(assay)
  }
  if (identical(layer_name, "counts")) {
    assay@counts <- matrix_value
    return(assay)
  }
  stop("Unsupported count layer: ", layer_name)
}

.wanlab_existing_working_data <- function(obj) {
  manifest <- tryCatch(obj@misc$wanlab_working_data, error = function(e) NULL)
  if (!is.list(manifest) || !nzchar(as.character(manifest$root %||% ""))) return(NULL)
  if (!dir.exists(manifest$root) || !file.exists(file.path(manifest$root, "manifest.rds"))) return(NULL)
  if (!requireNamespace("BPCells", quietly = TRUE)) return(NULL)
  layers <- manifest$layers
  if (!is.list(layers) || !length(layers)) return(NULL)
  valid <- vapply(layers, function(entry) {
    if (!is.list(entry)) return(FALSE)
    assay_name <- as.character(entry$assay %||% "")
    layer_name <- as.character(entry$layer %||% "")
    if (!nzchar(assay_name) || !nzchar(layer_name)) return(FALSE)
    assay <- tryCatch(obj[[assay_name]], error = function(e) NULL)
    if (is.null(assay) || !.wanlab_is_seurat_v5_assay(assay)) return(FALSE)
    current <- tryCatch(.wanlab_layer_matrix(assay, layer_name), error = function(e) NULL)
    if (is.null(current) || !inherits(current, "IterableMatrix")) return(FALSE)
    disk <- tryCatch(
      BPCells::open_matrix_dir(file.path(manifest$root, entry$directory)),
      error = function(e) NULL
    )
    if (is.null(disk)) return(FALSE)
    identical(dim(disk), dim(current)) &&
      identical(as.character(rownames(disk)), as.character(rownames(current))) &&
      identical(as.character(colnames(disk)), as.character(colnames(current)))
  }, logical(1))
  if (!all(valid)) return(NULL)
  manifest
}

.wanlab_write_bpcells_layer <- function(matrix_value, target_dir) {
  if (!requireNamespace("BPCells", quietly = TRUE)) {
    stop("BPCells is required for disk-backed large-data storage. Run project bootstrap first.")
  }
  if (dir.exists(target_dir)) {
    stop("Refusing to overwrite existing Working_Data layer: ", target_dir)
  }
  dir.create(target_dir, recursive = TRUE, showWarnings = FALSE)
  iterable <- if (inherits(matrix_value, "IterableMatrix")) {
    matrix_value
  } else {
    tryCatch(
      methods::as(matrix_value, "IterableMatrix"),
      error = function(e) stop("Could not create an IterableMatrix for disk-backed storage: ", conditionMessage(e))
    )
  }
  BPCells::write_matrix_dir(mat = iterable, dir = target_dir, overwrite = TRUE)
  disk_matrix <- BPCells::open_matrix_dir(dir = target_dir)
  if (nrow(disk_matrix) != nrow(matrix_value) || ncol(disk_matrix) != ncol(matrix_value)) {
    stop("Working_Data matrix dimensions do not match source matrix.")
  }
  if (!identical(as.character(rownames(disk_matrix)), as.character(rownames(matrix_value)))) {
    stop("Working_Data feature names do not match source matrix.")
  }
  if (!identical(as.character(colnames(disk_matrix)), as.character(colnames(matrix_value)))) {
    stop("Working_Data cell names do not match source matrix.")
  }
  disk_matrix
}

.wanlab_prepare_disk_backed_object <- function(
  obj,
  object_name = "object",
  source_tag = "",
  progress_cb = NULL,
  storage_root = NULL
) {
  if (!inherits(obj, "Seurat")) stop("Disk-backed preparation requires a Seurat object.")
  assays <- tryCatch(SeuratObject::Assays(obj), error = function(e) character(0))
  v5_assays <- assays[vapply(assays, function(nm) .wanlab_is_seurat_v5_assay(obj[[nm]]), logical(1))]
  if (!length(v5_assays)) {
    return(list(
      obj = obj,
      changed = FALSE,
      supported = FALSE,
      reason = "Selected object has no Seurat v5 assay.",
      manifest = NULL
    ))
  }
  existing_manifest <- .wanlab_existing_working_data(obj)
  if (is.list(existing_manifest)) {
    .wanlab_emit_storage_progress(progress_cb, "Disk-backed count data is already ready.", 20)
    return(list(
      obj = obj,
      changed = FALSE,
      supported = TRUE,
      reason = "",
      root = existing_manifest$root,
      manifest = existing_manifest
    ))
  }
  if (!requireNamespace("BPCells", quietly = TRUE)) {
    stop("BPCells is required for disk-backed large-data storage. Run project bootstrap first.")
  }

  root <- storage_root %||% .wanlab_working_data_root()
  if (!dir.exists(root)) dir.create(root, recursive = TRUE, showWarnings = FALSE)
  token <- paste(
    .wanlab_storage_token(object_name),
    format(Sys.time(), "%Y%m%d%H%M%S"),
    Sys.getpid(),
    sep = "_"
  )
  staging_root <- tempfile(paste0(".staging_", token, "_"), tmpdir = root)
  final_root <- file.path(root, paste0("object_", token))
  dir.create(staging_root, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(staging_root, recursive = TRUE, force = TRUE), add = TRUE)

  layer_manifest <- list()
  disk_layers <- list()
  count_layer_total <- 0L
  count_layer_done <- 0L

  for (assay_name in v5_assays) {
    layers <- .wanlab_assay_count_layers(obj[[assay_name]])
    if (!length(layers)) next
    count_layer_total <- count_layer_total + length(layers)
  }
  if (!count_layer_total) {
    return(list(
      obj = obj,
      changed = FALSE,
      supported = FALSE,
      reason = "Selected object has no v5 counts layers.",
      manifest = NULL
    ))
  }

  .wanlab_emit_storage_progress(progress_cb, "Preparing disk-backed count data...", 8)
  for (assay_name in v5_assays) {
    assay <- obj[[assay_name]]
    layers <- .wanlab_assay_count_layers(assay)
    if (!length(layers)) next
    for (layer_name in layers) {
      count_layer_done <- count_layer_done + 1L
      .wanlab_emit_storage_progress(
        progress_cb,
        sprintf("Writing %s/%s count layer...", assay_name, layer_name),
        8 + (12 * count_layer_done / count_layer_total)
      )
      matrix_value <- .wanlab_layer_matrix(assay, layer_name)
      target_dir <- file.path(
        staging_root,
        paste0("assay_", .wanlab_storage_token(assay_name)),
        paste0("layer_", .wanlab_storage_token(layer_name))
      )
      disk_matrix <- .wanlab_write_bpcells_layer(matrix_value, target_dir)
      disk_layers[[paste(assay_name, layer_name, sep = "::")]] <- disk_matrix
      layer_manifest[[length(layer_manifest) + 1L]] <- list(
        assay = assay_name,
        layer = layer_name,
        directory = file.path(
          paste0("assay_", .wanlab_storage_token(assay_name)),
          paste0("layer_", .wanlab_storage_token(layer_name))
        ),
        nrow = nrow(disk_matrix),
        ncol = ncol(disk_matrix)
      )
    }
  }

  manifest <- list(
    format_version = 1L,
    object_name = as.character(object_name %||% "object"),
    source_tag = as.character(source_tag %||% ""),
    created_at = Sys.time(),
    layers = layer_manifest
  )
  saveRDS(manifest, file.path(staging_root, "manifest.rds"))
  if (!file.rename(staging_root, final_root)) {
    stop("Could not finalize Working_Data directory: ", final_root)
  }
  staging_root <- ""

  disk_layers <- lapply(layer_manifest, function(entry) {
    BPCells::open_matrix_dir(file.path(final_root, entry$directory))
  })
  names(disk_layers) <- vapply(layer_manifest, function(entry) {
    paste(entry$assay, entry$layer, sep = "::")
  }, character(1))

  obj2 <- obj
  for (entry in layer_manifest) {
    key <- paste(entry$assay, entry$layer, sep = "::")
    assay2 <- obj2[[entry$assay]]
    assay2 <- .wanlab_attach_layer_matrix(assay2, entry$layer, disk_layers[[key]])
    obj2[[entry$assay]] <- assay2
  }
  misc <- tryCatch(obj2@misc, error = function(e) list())
  if (!is.list(misc)) misc <- list()
  manifest$root <- final_root
  misc$wanlab_working_data <- manifest
  obj2@misc <- misc
  saveRDS(manifest, file.path(final_root, "manifest.rds"))

  .wanlab_emit_storage_progress(progress_cb, "Disk-backed count data is ready.", 20)
  list(
    obj = obj2,
    changed = TRUE,
    supported = TRUE,
    reason = "",
    root = final_root,
    manifest = manifest
  )
}

.wanlab_prepare_disk_backed_selection <- function(
  selection,
  object_name = "object",
  source_tag = "",
  progress_cb = NULL,
  storage_root = NULL
) {
  if (inherits(selection, "Seurat")) {
    prepared <- .wanlab_prepare_disk_backed_object(
      selection,
      object_name = object_name,
      source_tag = source_tag,
      progress_cb = progress_cb,
      storage_root = storage_root
    )
    prepared$selection <- prepared$obj
    return(prepared)
  }
  if (!is.list(selection)) stop("Selected item is not a Seurat object or object package.")
  candidate_names <- c("obj", "seurat", "seurat_obj", "object", "data", "dataset")
  slot_name <- candidate_names[vapply(candidate_names, function(nm) inherits(selection[[nm]], "Seurat"), logical(1))][1]
  if (is.na(slot_name) || !nzchar(slot_name)) {
    idx <- which(vapply(selection, function(x) inherits(x, "Seurat"), logical(1)))
    if (!length(idx)) stop("Selected package does not contain a Seurat object.")
    slot_name <- names(selection)[idx[[1]]]
  }
  prepared <- .wanlab_prepare_disk_backed_object(
    selection[[slot_name]],
    object_name = object_name,
    source_tag = source_tag,
    progress_cb = progress_cb,
    storage_root = storage_root
  )
  selection2 <- selection
  selection2[[slot_name]] <- prepared$obj
  prepared$selection <- selection2
  prepared
}
