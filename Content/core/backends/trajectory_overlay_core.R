# Compact, object-resident records used by Figure Studio overlays.
# Agent note: Store only cell-level overlay data and graph topology. Never keep
# a full Monocle/reticulate object in Seurat @misc because workspace files must
# remain portable and the overlay must be projected onto the current embedding.
# Each source key is independent; a new run replaces only that source record.

.trajectory_overlay_or <- function(a, b) if (is.null(a)) b else a
`%||%` <- .trajectory_overlay_or

trajectory_overlay_sources <- function() c("none", "monocle2", "monocle3", "rna_velocity")

# Agent note: These are portable plotting preferences only. Keep analysis-run
# parameters separate so saved workspaces do not depend on external objects.
trajectory_plot_settings_defaults <- function() {
  list(
    schema_version = 1L,
    monocle3 = list(
      color_by = "annotation", annotation_column = "",
      label_cell_groups = FALSE, label_leaves = FALSE,
      label_branch_points = FALSE, show_trajectory_graph = TRUE,
      palette_source = "metadata", palette = list(), theme = "classic",
      width = 8, height = 7, dpi = 300
    ),
    velocity = list(
      pc_count = 11L, model = "stochastic", display_mode = "point",
      color_by = "annotation", annotation_column = "",
      point_size = 50, arrow_alpha = 0.55,
      grid_density = 0.25, grid_width = 0.003, grid_size = 1.4, grid_length = 3,
      small_grid_density = 0.25, small_width = 0.0025, small_size = 1.1, small_length = 2.5,
      stream_density = 2, stream_size = 1, stream_max_length = 4, stream_linewidth = 1,
      dpi = 300, latent_time = FALSE
    )
  )
}

trajectory_plot_settings_normalize <- function(settings = NULL) {
  defaults <- trajectory_plot_settings_defaults()
  out <- utils::modifyList(defaults, settings %||% list())
  out$schema_version <- 1L
  out$monocle3 <- utils::modifyList(defaults$monocle3, out$monocle3 %||% list())
  out$velocity <- utils::modifyList(defaults$velocity, out$velocity %||% list())
  out$monocle3$color_by <- if (out$monocle3$color_by %in% c("annotation", "pseudotime")) out$monocle3$color_by else "annotation"
  out$monocle3$palette_source <- if (out$monocle3$palette_source %in% c("metadata", "manual")) out$monocle3$palette_source else "metadata"
  out$monocle3$theme <- "classic"
  out$monocle3$annotation_column <- as.character(out$monocle3$annotation_column %||% "")[[1]]
  out$monocle3$label_cell_groups <- isTRUE(out$monocle3$label_cell_groups)
  out$monocle3$label_leaves <- isTRUE(out$monocle3$label_leaves)
  out$monocle3$label_branch_points <- isTRUE(out$monocle3$label_branch_points)
  out$monocle3$show_trajectory_graph <- isTRUE(out$monocle3$show_trajectory_graph)
  for (nm in c("width", "height", "dpi")) {
    value <- suppressWarnings(as.numeric(out$monocle3[[nm]])[[1]])
    out$monocle3[[nm]] <- if (is.finite(value) && value > 0) value else defaults$monocle3[[nm]]
  }
  out$velocity$model <- if (out$velocity$model %in% c("stochastic", "dynamical")) out$velocity$model else "stochastic"
  out$velocity$display_mode <- if (out$velocity$display_mode %in% c("point", "stream", "grid", "sparse_grid", "small_arrows")) out$velocity$display_mode else "point"
  out$velocity$color_by <- if (out$velocity$color_by %in% c("annotation", "group", "latent_time")) out$velocity$color_by else "annotation"
  out$velocity$annotation_column <- as.character(out$velocity$annotation_column %||% "")[[1]]
  pc_count <- suppressWarnings(as.numeric(out$velocity$pc_count)[[1]])
  if (!is.finite(pc_count) || pc_count < 2) pc_count <- defaults$velocity$pc_count
  out$velocity$pc_count <- as.integer(pc_count)
  out$velocity$latent_time <- isTRUE(out$velocity$latent_time)
  for (nm in setdiff(names(out$velocity), c("model", "display_mode", "color_by", "annotation_column", "pc_count", "latent_time"))) {
    value <- suppressWarnings(as.numeric(out$velocity[[nm]])[[1]])
    out$velocity[[nm]] <- if (is.finite(value) && value > 0) value else defaults$velocity[[nm]]
  }
  out
}

trajectory_velocity_display_diagnostic <- function(record, display_mode = NULL) {
  mode <- as.character(display_mode %||% record$plotting$velocity$display_mode %||% "point")[[1]]
  if (!(mode %in% c("point", "stream", "grid", "sparse_grid", "small_arrows"))) return("Velocity display mode is invalid.")
  if (mode %in% c("point", "small_arrows")) return("")
  field <- (record$field_data %||% list())[[mode]]
  if (is.null(field) || !is.data.frame(field) || !nrow(field)) return(sprintf("Velocity display mode '%s' requires saved field data; vector arrows are not substituted.", mode))
  required <- if (identical(mode, "stream")) c("x", "y", "xend", "yend") else c("x", "y", "vx", "vy")
  if (!all(required %in% colnames(field))) return(sprintf("Velocity display mode '%s' has incomplete field data.", mode))
  ""
}

trajectory_overlay_validate_record <- function(record, source = NULL) {
  if (!is.list(record)) stop("Trajectory overlay record must be a list.", call. = FALSE)
  src <- as.character(source %||% record$source %||% "")[[1]]
  if (!(src %in% c("monocle2", "monocle3", "rna_velocity"))) stop("Trajectory overlay source is invalid.", call. = FALSE)
  cells <- as.character(record$cells %||% character(0))
  if (!length(cells) || anyNA(cells) || any(!nzchar(cells)) || anyDuplicated(cells)) stop("Trajectory overlay cells must be unique, non-empty identifiers.", call. = FALSE)
  if (src == "rna_velocity") {
    vec <- as.data.frame(record$vectors %||% data.frame(), stringsAsFactors = FALSE)
    required <- c("cell", "x", "y", "vx", "vy")
    if (!all(required %in% colnames(vec))) stop("RNA velocity overlay is missing vector columns.", call. = FALSE)
    if (!identical(as.character(vec$cell), cells)) stop("RNA velocity overlay cells do not match vector rows.", call. = FALSE)
    if (any(!is.finite(as.numeric(vec$x))) || any(!is.finite(as.numeric(vec$y))) || any(!is.finite(as.numeric(vec$vx))) || any(!is.finite(as.numeric(vec$vy)))) stop("RNA velocity overlay contains non-finite vector coordinates.", call. = FALSE)
    if (!is.null(record$field_data) && !is.list(record$field_data)) stop("RNA velocity field data must be a list.", call. = FALSE)
  }
  if (src %in% c("monocle2", "monocle3")) {
    for (nm in c("pseudotime", "state", "group", "annotation")) {
      if (!is.null(record[[nm]]) && length(record[[nm]]) != length(cells)) stop(sprintf("Monocle trajectory overlay field '%s' does not match cells.", nm), call. = FALSE)
    }
    graph <- record$graph
    if (!is.null(graph)) {
      if (!is.list(graph) || is.null(graph$edges) || is.null(graph$cell_node)) stop("Monocle trajectory overlay graph is incomplete.", call. = FALSE)
      edges <- as.data.frame(graph$edges, stringsAsFactors = FALSE)
      if (!all(c("from", "to") %in% colnames(edges))) stop("Monocle trajectory overlay graph edges need from and to columns.", call. = FALSE)
      mapping <- as.character(graph$cell_node)
      if (is.null(names(graph$cell_node)) || !all(cells %in% names(graph$cell_node))) stop("Monocle trajectory overlay graph cell mapping is incomplete.", call. = FALSE)
      if (any(!nzchar(mapping[names(mapping) %in% cells]))) stop("Monocle trajectory overlay graph contains empty cell nodes.", call. = FALSE)
    }
  }
  invisible(TRUE)
}

trajectory_overlay_record_from_velocity <- function(result, plotting = NULL, provenance = NULL) {
  if (!is.list(result) || is.null(result$vectors)) stop("RNA velocity result is missing vectors.", call. = FALSE)
  vec <- as.data.frame(result$vectors, stringsAsFactors = FALSE)
  if (!nrow(vec)) stop("RNA velocity result has no vectors.", call. = FALSE)
  cells <- as.character(vec$cell)
  if (anyNA(cells) || any(!nzchar(cells)) || anyDuplicated(cells)) stop("RNA velocity result has invalid cell identifiers.", call. = FALSE)
  optional <- function(nm, fallback) if (nm %in% colnames(vec)) suppressWarnings(as.numeric(vec[[nm]])) else rep(fallback, nrow(vec))
  out <- list(
    schema_version = 2L,
    source = "rna_velocity",
    reduction = as.character(result$reduction %||% "")[[1]],
    mode = as.character(result$mode %||% "stochastic")[[1]],
    pc_count = suppressWarnings(as.integer(result$pc_count %||% result$n_pcs %||% NA_integer_)),
    plotting = trajectory_plot_settings_normalize(list(velocity = plotting %||% list(model = result$mode %||% "stochastic", pc_count = result$pc_count %||% result$n_pcs %||% 11L))),
    provenance = provenance %||% result$provenance %||% list(source = "app_run"),
    field_data = result$field_data %||% result$fields %||% list(),
    cells = cells,
    vectors = data.frame(
      cell = cells,
      x = suppressWarnings(as.numeric(vec$x)),
      y = suppressWarnings(as.numeric(vec$y)),
      vx = suppressWarnings(as.numeric(vec$vx)),
      vy = suppressWarnings(as.numeric(vec$vy)),
      speed = optional("speed", NA_real_),
      group = if ("group" %in% colnames(vec)) as.character(vec$group) else rep("All cells", nrow(vec)),
      confidence = optional("confidence", NA_real_),
      latent_time = optional("latent_time", NA_real_),
      stringsAsFactors = FALSE
    )
  )
  trajectory_overlay_validate_record(out)
  out
}

.trajectory_overlay_graph_data <- function(cds, method = "monocle2", reduction = "DDRTree") {
  method <- as.character(method %||% "monocle2")[[1]]
  reduction <- as.character(reduction %||% "DDRTree")[[1]]
  branch <- NULL
  tree <- NULL
  if (identical(method, "monocle3")) {
    if (!requireNamespace("monocle3", quietly = TRUE)) return(NULL)
    tree <- tryCatch(monocle3::principal_graph(cds)[[reduction]], error = function(e) NULL)
    branch <- tryCatch(monocle3::principal_graph_aux(cds)[[reduction]], error = function(e) NULL)
  } else {
    aux <- tryCatch(if (methods::is(cds, "CellDataSet")) cds@auxOrderingData else cds$auxOrderingData, error = function(e) NULL)
    if (!is.list(aux) || !length(aux)) return(NULL)
    branch <- aux[[reduction]] %||% aux[[1L]]
    if (!is.list(branch)) return(NULL)
    tree <- branch$pr_graph_cell_proj_tree %||% branch$minSpanningTree
  }
  edges <- NULL
  if (!is.null(tree) && requireNamespace("igraph", quietly = TRUE) && inherits(tree, "igraph")) {
    edges <- tryCatch(igraph::as_data_frame(tree, what = "edges"), error = function(e) NULL)
  } else if (is.data.frame(tree)) {
    edges <- tree
  } else if (is.matrix(tree) && ncol(tree) >= 2L) {
    edges <- data.frame(from = tree[, 1], to = tree[, 2], stringsAsFactors = FALSE)
  }
  if (is.null(edges) || !nrow(edges) || !all(c("from", "to") %in% colnames(edges))) return(NULL)
  closest <- branch$pr_graph_cell_proj_closest_vertex
  if (is.null(closest)) return(NULL)
  closest <- as.matrix(closest)
  if (nrow(closest) == 1L && ncol(closest) > 1L) {
    mapping <- as.character(closest[1L, ])
    cells <- colnames(closest)
  } else {
    mapping <- as.character(closest[, 1L])
    cells <- rownames(closest)
  }
  if (is.null(cells) || length(cells) != length(mapping)) return(NULL)
  names(mapping) <- as.character(cells)
  list(
    nodes = unique(c(as.character(edges$from), as.character(edges$to))),
    edges = data.frame(from = as.character(edges$from), to = as.character(edges$to), stringsAsFactors = FALSE),
    cell_node = mapping
  )
}

trajectory_overlay_record_from_monocle <- function(result, source = "monocle2", reduction = "DDRTree") {
  source <- as.character(source %||% "monocle2")[[1]]
  if (!(source %in% c("monocle2", "monocle3"))) stop("Monocle trajectory overlay source is invalid.", call. = FALSE)
  if (!is.list(result) || is.null(result$emb)) stop(sprintf("%s result is missing the trajectory embedding.", source), call. = FALSE)
  emb <- as.data.frame(result$emb, stringsAsFactors = FALSE)
  cells <- as.character(emb$cell %||% rownames(emb))
  if (!length(cells) || anyNA(cells) || any(!nzchar(cells)) || anyDuplicated(cells)) stop(sprintf("%s result has invalid cell identifiers.", source), call. = FALSE)
  n <- length(cells)
  aligned <- function(value, fallback) {
    out <- value %||% rep(fallback, n)
    out <- out[seq_len(min(length(out), n))]
    if (length(out) < n) out <- c(out, rep(fallback, n - length(out)))
    out
  }
  graph <- result$graph %||% .trajectory_overlay_graph_data(result$cds, method = source, reduction = reduction)
  out <- list(
    schema_version = 2L,
    source = source,
    reduction = if (identical(source, "monocle3")) tolower(as.character(reduction %||% "UMAP")[[1]]) else "",
    cells = cells,
    pseudotime = suppressWarnings(as.numeric(aligned(result$pseudotime, NA_real_))),
    state = as.character(aligned(result$state, "")),
    group = as.character(aligned(result$group, "")),
    annotation = as.character(aligned(result$annotation, "")),
    annotation_column = as.character(result$annotation_column %||% "")[[1]],
    palette = result$palette %||% list(),
    plotting = trajectory_plot_settings_normalize(result$plotting %||% list(monocle3 = list(annotation_column = result$annotation_column %||% ""))),
    provenance = result$provenance %||% list(source = "app_run"),
    graph = graph,
    graph_diagnostic = if (is.null(graph)) sprintf("%s result did not expose a usable principal graph and cell-to-node mapping.", source) else ""
  )
  trajectory_overlay_validate_record(out)
  out
}

trajectory_overlay_record_from_monocle3 <- function(result, reduction = "UMAP") {
  trajectory_overlay_record_from_monocle(result, source = "monocle3", reduction = reduction)
}

trajectory_overlay_read <- function(seurat_object, source) {
  src <- as.character(source %||% "")[[1]]
  if (!(src %in% c("monocle2", "monocle3", "rna_velocity"))) return(NULL)
  overlays <- tryCatch(seurat_object@misc$analysis$trajectory_overlays, error = function(e) NULL)
  record <- if (is.list(overlays)) overlays[[src]] else NULL
  if (is.null(record)) return(NULL)
  tryCatch({ trajectory_overlay_validate_record(record, src); record }, error = function(e) stop(sprintf("Stored %s overlay is invalid: %s", src, conditionMessage(e)), call. = FALSE))
}

trajectory_overlay_write <- function(seurat_object, record) {
  trajectory_overlay_validate_record(record)
  if (is.null(seurat_object) || !inherits(seurat_object, "Seurat")) stop("Overlay write-back requires a Seurat object.", call. = FALSE)
  misc <- tryCatch(seurat_object@misc, error = function(e) list())
  if (!is.list(misc)) misc <- list()
  if (!is.list(misc$analysis)) misc$analysis <- list()
  if (!is.list(misc$analysis$trajectory_overlays)) misc$analysis$trajectory_overlays <- list()
  misc$analysis$trajectory_overlays[[record$source]] <- record
  seurat_object@misc <- misc
  seurat_object
}

trajectory_overlay_remove <- function(seurat_object, source) {
  src <- as.character(source %||% "")[[1]]
  if (!(src %in% c("monocle2", "monocle3", "rna_velocity"))) stop("Trajectory overlay source is invalid.", call. = FALSE)
  if (is.null(seurat_object) || !inherits(seurat_object, "Seurat")) stop("Overlay removal requires a Seurat object.", call. = FALSE)
  misc <- tryCatch(seurat_object@misc, error = function(e) list())
  if (is.list(misc) && is.list(misc$analysis) && is.list(misc$analysis$trajectory_overlays)) {
    misc$analysis$trajectory_overlays[[src]] <- NULL
    seurat_object@misc <- misc
  }
  seurat_object
}

trajectory_overlay_project <- function(record, embedding, reduction = "") {
  trajectory_overlay_validate_record(record)
  emb <- as.matrix(embedding)
  if (is.null(rownames(emb)) || ncol(emb) < 2L) stop("Current embedding needs cell names and at least two dimensions.", call. = FALSE)
  rec_red <- as.character(record$reduction %||% "")[[1]]
  use_red <- as.character(reduction %||% "")[[1]]
  if (nzchar(rec_red) && nzchar(use_red) && !identical(rec_red, use_red)) stop(sprintf("Overlay source uses reduction '%s', but current figure uses '%s'. Re-run the overlay source on the selected reduction.", rec_red, use_red), call. = FALSE)
  cells <- intersect(rownames(emb), record$cells)
  if (!length(cells)) stop("Overlay source has no cells matching current embedding.", call. = FALSE)
  out <- list(source = record$source, cells = cells, x = emb[cells, 1L], y = emb[cells, 2L])
  out$plotting <- record$plotting %||% list()
  out$provenance <- record$provenance %||% list()
  if (ncol(emb) >= 3L) out$z <- emb[cells, 3L]
  if (identical(record$source, "rna_velocity")) {
    vec <- record$vectors[match(cells, record$vectors$cell), , drop = FALSE]
    out$vectors <- vec
    out$vectors$x <- as.numeric(out$x)
    out$vectors$y <- as.numeric(out$y)
    out$vectors$xend <- out$vectors$x + as.numeric(vec$vx)
    out$vectors$yend <- out$vectors$y + as.numeric(vec$vy)
    out$field_data <- record$field_data %||% list()
    return(out)
  }
  out$pseudotime <- as.numeric(record$pseudotime[match(cells, record$cells)])
  out$state <- as.character(record$state[match(cells, record$cells)])
  out$group <- as.character(record$group[match(cells, record$cells)])
  out$annotation <- as.character(record$annotation[match(cells, record$cells)] %||% out$group)
  out$palette <- record$palette %||% list()
  graph <- record$graph
  if (!is.null(graph)) {
    mapping <- as.character(graph$cell_node[cells])
    names(mapping) <- cells
    nodes <- unique(mapping[nzchar(mapping)])
    node_xy <- do.call(rbind, lapply(nodes, function(node) {
      use <- cells[mapping == node]
      c(x = mean(out$x[use], na.rm = TRUE), y = mean(out$y[use], na.rm = TRUE))
    }))
    if (length(nodes) && nrow(node_xy)) {
      rownames(node_xy) <- nodes
      edges <- as.data.frame(graph$edges, stringsAsFactors = FALSE)
      keep <- edges$from %in% nodes & edges$to %in% nodes
      out$graph_edges <- edges[keep, c("from", "to"), drop = FALSE]
      out$graph_nodes <- node_xy
      out$graph_cell_node <- mapping
    }
  }
  out
}
