# Guarded Monocle3 adapter. Package-specific calls stay here so page code can
# remain navigable when Monocle3 is unavailable or its API is incompatible.

`%||%` <- function(a, b) if (is.null(a)) b else a

monocle3_beta_runtime_guard <- function() {
  has_pkg <- requireNamespace("monocle3", quietly = TRUE)
  version <- if (has_pkg) tryCatch(as.character(utils::packageVersion("monocle3")), error = function(e) NA_character_) else NA_character_
  path <- if (has_pkg) tryCatch(find.package("monocle3"), error = function(e) "") else ""
  issues <- character(0)
  if (!has_pkg) issues <- c(issues, "Package 'monocle3' is not available in the active project environment.")
  list(
    ok = !length(issues),
    summary = if (length(issues)) paste(issues, collapse = " ") else sprintf("Monocle3 runtime is available (version %s).", version %||% "NA"),
    issues = issues,
    versions = list(monocle3 = version),
    paths = list(monocle3 = path)
  )
}

monocle3_beta_object_names <- function(shared_data) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm in names(reg_flt)) if (is.null(reg[[nm]])) reg[[nm]] <- reg_flt[[nm]]
  nms <- names(reg)
  if (!length(nms)) return(character(0))
  nms <- nms[nzchar(nms)]
  keep <- vapply(nms, function(nm) {
    entry <- reg[[nm]]
    obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    inherits(obj, "Seurat")
  }, logical(1))
  unique(nms[keep])
}

monocle3_beta_get_object <- function(shared_data, object_name = NULL) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm in names(reg_flt)) if (is.null(reg[[nm]])) reg[[nm]] <- reg_flt[[nm]]
  valid <- monocle3_beta_object_names(shared_data)
  nm <- as.character(object_name %||% "")[[1]]
  if (!nzchar(nm)) nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")[[1]]
  if (!nzchar(nm) || !(nm %in% valid)) nm <- if (length(valid)) valid[[length(valid)]] else ""
  if (!nzchar(nm) || is.null(reg[[nm]])) return(NULL)
  entry <- reg[[nm]]
  obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
  if (!inherits(obj, "Seurat")) return(NULL)
  obj
}

monocle3_beta_assays <- function(sobj) {
  aa <- tryCatch(names(sobj@assays), error = function(e) character(0))
  aa[nzchar(aa)]
}

monocle3_beta_default_assay <- function(sobj) {
  aa <- monocle3_beta_assays(sobj)
  if (!length(aa)) return("")
  if ("RNA" %in% aa) return("RNA")
  da <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
  if (nzchar(da) && da %in% aa) da else aa[[1L]]
}

monocle3_beta_meta_cols <- function(sobj) {
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !nrow(md)) return(character(0))
  cols <- colnames(md)
  keep <- vapply(cols, function(cn) {
    v <- md[[cn]]
    v <- v[!is.na(v)]
    length(unique(as.character(v))) >= 2L
  }, logical(1))
  cols[keep]
}

monocle3_beta_default_group <- function(cols) {
  preferred <- intersect(c("seurat_clusters", "celltype", "orig.ident", "sample", "condition", "batch"), cols)
  if (length(preferred)) preferred[[1L]] else if (length(cols)) cols[[1L]] else ""
}

.monocle3_expression_matrix <- function(sobj, assay = NULL) {
  assays <- monocle3_beta_assays(sobj)
  use_assay <- as.character(assay %||% "")[[1]]
  if (!nzchar(use_assay) || !(use_assay %in% assays)) use_assay <- monocle3_beta_default_assay(sobj)
  if (!nzchar(use_assay)) stop("No assay is available for Monocle3.", call. = FALSE)
  mat <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, layer = "counts"), error = function(e) NULL)
  if (is.null(mat)) mat <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, slot = "counts"), error = function(e) NULL)
  if (is.null(mat)) mat <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, layer = "data"), error = function(e) NULL)
  if (is.null(mat)) mat <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, slot = "data"), error = function(e) NULL)
  if (is.null(mat)) stop(sprintf("Assay '%s' has no usable counts or data layer for Monocle3.", use_assay), call. = FALSE)
  # Keep the sparse representation. Densifying a real scRNA-seq assay here
  # can multiply memory use before Monocle3 has even started preprocessing.
  if (!inherits(mat, "Matrix")) {
    mat <- tryCatch(Matrix::Matrix(mat, sparse = TRUE), error = function(e) mat)
  }
  mat <- mat[Matrix::rowSums(mat) > 0, , drop = FALSE]
  if (!nrow(mat) || !ncol(mat)) stop("Expression matrix is empty after removing zero-expression genes.", call. = FALSE)
  list(matrix = mat, assay = use_assay)
}

.monocle3_root_cells <- function(cds, sobj, group_col, root_mode, root_value, reduction) {
  cells <- colnames(cds)
  mode <- as.character(root_mode %||% "first_cell")[[1]]
  if (identical(mode, "metadata_group")) {
    md <- sobj@meta.data
    if (!nzchar(group_col) || !(group_col %in% colnames(md))) stop("Choose a valid metadata grouping column for Monocle3 roots.", call. = FALSE)
    value <- as.character(root_value %||% "")[[1]]
    if (!nzchar(value)) stop("Choose a metadata value for Monocle3 root cells.", call. = FALSE)
    selected <- rownames(md)[as.character(md[[group_col]]) == value]
    selected <- intersect(selected, cells)
    if (!length(selected)) stop("Selected Monocle3 root metadata value has no cells in the trajectory.", call. = FALSE)
    return(selected)
  }
  if (identical(mode, "first_cell")) return(cells[[1L]])
  if (identical(mode, "unrooted")) return(character(0))
  if (identical(mode, "graph_node")) return(NULL)
  stop(sprintf("Unsupported Monocle3 root mode '%s'.", mode), call. = FALSE)
}

monocle3_beta_run_trajectory <- function(
  sobj,
  assay = NULL,
  num_dim = 50L,
  group_col = "",
  root_mode = "first_cell",
  root_value = "",
  reduction = "UMAP"
) {
  guard <- monocle3_beta_runtime_guard()
  if (!isTRUE(guard$ok)) stop(guard$summary, call. = FALSE)
  if (!inherits(sobj, "Seurat")) stop("Input object must be a Seurat object.", call. = FALSE)
  reduction <- as.character(reduction %||% "UMAP")[[1]]
  if (!(toupper(reduction) %in% c("UMAP", "TSNE"))) stop("Monocle3 adapter currently supports UMAP or tSNE reduction.", call. = FALSE)
  matrix_info <- .monocle3_expression_matrix(sobj, assay = assay)
  md <- as.data.frame(sobj@meta.data, stringsAsFactors = FALSE)
  gene_names <- rownames(matrix_info$matrix)
  gene_md <- data.frame(gene_id = gene_names, gene_short_name = gene_names, row.names = gene_names, stringsAsFactors = FALSE)
  cds <- tryCatch(
    monocle3::new_cell_data_set(matrix_info$matrix, cell_metadata = md[colnames(matrix_info$matrix), , drop = FALSE], gene_metadata = gene_md),
    error = function(e) stop(sprintf("Monocle3 new_cell_data_set failed: %s", conditionMessage(e)), call. = FALSE)
  )
  dims <- suppressWarnings(as.integer(num_dim)[[1]])
  if (!is.finite(dims) || dims < 2L) stop("Monocle3 dimensions must be an integer of at least 2.", call. = FALSE)
  cds <- tryCatch(monocle3::preprocess_cds(cds, num_dim = dims), error = function(e) stop(sprintf("Monocle3 preprocess_cds failed: %s", conditionMessage(e)), call. = FALSE))
  cds <- tryCatch(monocle3::reduce_dimension(cds, reduction_method = reduction), error = function(e) stop(sprintf("Monocle3 reduce_dimension failed for %s: %s", reduction, conditionMessage(e)), call. = FALSE))
  cds <- tryCatch(monocle3::cluster_cells(cds, reduction_method = reduction), error = function(e) stop(sprintf("Monocle3 cluster_cells failed: %s", conditionMessage(e)), call. = FALSE))
  cds <- tryCatch(monocle3::learn_graph(cds, use_partition = TRUE), error = function(e) stop(sprintf("Monocle3 learn_graph failed: %s", conditionMessage(e)), call. = FALSE))

  root_cells <- .monocle3_root_cells(cds, sobj, group_col, root_mode, root_value, reduction)
  root_nodes <- NULL
  if (identical(root_cells, NULL)) {
    graph <- tryCatch(monocle3::principal_graph(cds)[[reduction]], error = function(e) NULL)
    if (is.null(graph) || !requireNamespace("igraph", quietly = TRUE)) stop("Monocle3 graph-node root mode requires a learned principal graph and igraph.", call. = FALSE)
    root_nodes <- igraph::V(graph)$name[[1L]]
  }
  if (!identical(root_mode, "unrooted")) {
    cds <- tryCatch(
      if (!is.null(root_nodes)) monocle3::order_cells(cds, reduction_method = reduction, root_pr_nodes = root_nodes) else monocle3::order_cells(cds, reduction_method = reduction, root_cells = root_cells),
      error = function(e) stop(sprintf("Monocle3 order_cells failed: %s", conditionMessage(e)), call. = FALSE)
    )
  }
  emb <- tryCatch(monocle3::reducedDims(cds)[[reduction]], error = function(e) NULL)
  if (is.null(emb) || ncol(emb) < 2L) stop(sprintf("Monocle3 did not return a two-dimensional %s embedding.", reduction), call. = FALSE)
  emb <- as.matrix(emb)
  cells <- rownames(emb) %||% colnames(cds)
  if (is.null(cells) || length(cells) != nrow(emb)) stop("Monocle3 embedding has no usable cell identifiers.", call. = FALSE)
  pt_raw <- if (identical(root_mode, "unrooted")) rep(NA_real_, length(cells)) else tryCatch(monocle3::pseudotime(cds, reduction_method = reduction), error = function(e) stop(sprintf("Monocle3 pseudotime extraction failed: %s", conditionMessage(e)), call. = FALSE))
  pt <- as.numeric(pt_raw)
  names(pt) <- names(pt_raw) %||% cells
  state_raw <- tryCatch(monocle3::clusters(cds, reduction_method = reduction), error = function(e) rep("", length(cells)))
  state <- as.character(state_raw)
  if (!is.null(names(state_raw))) state <- unname(as.character(state_raw)[match(cells, names(state_raw))])
  if (length(state) != length(cells)) state <- rep("", length(cells))
  state[is.na(state)] <- ""
  group <- if (nzchar(group_col) && group_col %in% colnames(md)) as.character(md[cells, group_col]) else rep("", length(cells))
  group[is.na(group)] <- ""
  annotation <- group
  list(
    cds = cds,
    assay = matrix_info$assay,
    group_col = as.character(group_col %||% "")[[1]],
    reduction = reduction,
    root_mode = as.character(root_mode %||% "first_cell")[[1]],
    root_value = as.character(root_value %||% "")[[1]],
    emb = data.frame(cell = cells, x = as.numeric(emb[, 1L]), y = as.numeric(emb[, 2L]), stringsAsFactors = FALSE),
    meta = md[cells, , drop = FALSE],
    pseudotime = pt[cells],
    state = state,
    annotation = annotation,
    annotation_column = as.character(group_col %||% "")[[1]],
    palette = list(),
    plotting = trajectory_plot_settings_normalize(list(monocle3 = list(annotation_column = group_col %||% ""))),
    provenance = list(source = "app_run"),
    group = group,
    state_levels = sort(unique(state[nzchar(state)]))
  )
}

monocle3_beta_record_overlay <- function(result) {
  trajectory_overlay_record_from_monocle3(result, reduction = result$reduction %||% "UMAP")
}
