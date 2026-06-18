# contamination_core.R
# Core ambient contamination routing/evaluation for QC hidden page.

`%||%` <- function(a, b) if (is.null(a)) b else a

.core_contam_require_backends <- function() {
  srcs <- c(
    file.path("core", "backends", "contam_soupx_backend.R"),
    file.path("core", "backends", "contam_decontx_backend.R"),
    file.path("core", "backends", "contam_cellbender_backend.R")
  )
  for (p in srcs) {
    if (!file.exists(p)) stop("Missing contamination backend file: ", p)
    source(p, local = FALSE)
  }
}

.core_contam_extract_assay_counts <- function(sobj, assay = "RNA") {
  ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
  args <- list(object = sobj, assay = assay)
  if ("layer" %in% ga_formals) args$layer <- "counts" else args$slot <- "counts"
  m <- tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
  if (is.null(m)) stop("Unable to extract counts from assay: ", assay)
  m
}

.core_contam_make_assay <- function(mat) {
  tryCatch(
    Seurat::CreateAssayObject(counts = mat),
    error = function(e) {
      if (exists("CreateAssay5Object", where = asNamespace("SeuratObject"), inherits = FALSE)) {
        SeuratObject::CreateAssay5Object(counts = mat)
      } else {
        stop(e)
      }
    }
  )
}

.core_contam_sample_name <- function(sample_row, seurat_obj = NULL) {
  nm <- as.character(sample_row$name[[1]] %||% "")
  if (nzchar(nm)) return(nm)
  nm2 <- tryCatch(as.character(seurat_obj$orig.ident[[1]]), error = function(e) "")
  if (nzchar(nm2)) return(nm2)
  "sample"
}

.core_contam_find_outs_root <- function(path) {
  p <- as.character(path %||% "")
  if (!nzchar(p)) return("")
  cur <- if (isTRUE(file.info(p)$isdir)) p else dirname(p)
  cur <- normalizePath(cur, winslash = "/", mustWork = FALSE)
  for (i in seq_len(12)) {
    if (basename(cur) == "outs") return(cur)
    c_outs <- file.path(cur, "outs")
    if (dir.exists(c_outs)) return(normalizePath(c_outs, winslash = "/", mustWork = FALSE))
    parent <- dirname(cur)
    if (!nzchar(parent) || identical(parent, cur)) break
    cur <- parent
  }
  ""
}

.core_contam_detect_input_files <- function(sample_path) {
  p <- as.character(sample_path %||% "")
  outs <- .core_contam_find_outs_root(p)

  raw_h5 <- ""
  filtered_h5 <- ""
  raw_matrix <- ""
  filtered_matrix <- ""

  if (nzchar(outs)) {
    raw_h5_c <- file.path(outs, "raw_feature_bc_matrix.h5")
    fil_h5_c <- file.path(outs, "filtered_feature_bc_matrix.h5")
    raw_m_c <- file.path(outs, "raw_feature_bc_matrix")
    fil_m_c <- file.path(outs, "filtered_feature_bc_matrix")

    if (file.exists(raw_h5_c)) raw_h5 <- normalizePath(raw_h5_c, winslash = "/", mustWork = FALSE)
    if (file.exists(fil_h5_c)) filtered_h5 <- normalizePath(fil_h5_c, winslash = "/", mustWork = FALSE)
    if (dir.exists(raw_m_c)) raw_matrix <- normalizePath(raw_m_c, winslash = "/", mustWork = FALSE)
    if (dir.exists(fil_m_c)) filtered_matrix <- normalizePath(fil_m_c, winslash = "/", mustWork = FALSE)
  }

  list(
    sample_input_path = p,
    outs_root = outs,
    raw_h5_path = raw_h5,
    filtered_h5_path = filtered_h5,
    raw_matrix_path = if (nzchar(raw_matrix)) raw_matrix else raw_h5,
    filtered_matrix_path = if (nzchar(filtered_matrix)) filtered_matrix else filtered_h5
  )
}

core_contam_detect_inputs <- function(sample_row, seurat_obj = NULL, ...) {
  if (!is.data.frame(sample_row) || nrow(sample_row) != 1) {
    stop("sample_row must be a one-row data.frame.")
  }
  path <- as.character(sample_row$path[[1]] %||% "")
  if (!nzchar(path)) stop("sample_row$path is required.")

  files <- .core_contam_detect_input_files(path)

  has_raw <- nzchar(files$raw_h5_path) || nzchar(files$raw_matrix_path)
  has_filtered <- nzchar(files$filtered_h5_path) || nzchar(files$filtered_matrix_path)

  feasible <- c("none")
  if (has_raw) feasible <- c(feasible, "CellBender")
  if (has_raw && has_filtered) feasible <- c(feasible, "SoupX")
  feasible <- c(feasible, "DecontX")

  list(
    sample_name = .core_contam_sample_name(sample_row, seurat_obj = seurat_obj),
    files = files,
    has_raw = has_raw,
    has_filtered = has_filtered,
    feasible_methods = unique(feasible)
  )
}

.core_contam_pick_cluster_column <- function(sobj) {
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !is.data.frame(md) || !nrow(md)) return("")
  if ("seurat_clusters" %in% colnames(md)) return("seurat_clusters")
  res_cols <- grep("(snn|wsnn|nn)[._]res", colnames(md), ignore.case = TRUE, value = TRUE)
  if (length(res_cols)) return(res_cols[[length(res_cols)]])
  ""
}

.core_contam_as_expr_matrix <- function(sobj, assay = "RNA", layer = "data") {
  ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
  args <- list(object = sobj, assay = assay)
  if ("layer" %in% ga_formals) args$layer <- layer else args$slot <- layer
  tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
}

.core_contam_pct_expr_table <- function(sobj, genes, cluster_col, assay = "RNA") {
  genes <- unique(as.character(genes))
  genes <- genes[genes %in% rownames(sobj)]
  if (!length(genes) || !nzchar(cluster_col) || !(cluster_col %in% colnames(sobj@meta.data))) {
    return(data.frame())
  }
  cnt <- .core_contam_as_expr_matrix(sobj, assay = assay, layer = "counts")
  if (is.null(cnt)) return(data.frame())

  cl <- as.character(sobj@meta.data[[cluster_col]])
  cl[is.na(cl) | !nzchar(cl)] <- "NA"
  lev <- sort(unique(cl))

  out <- lapply(genes, function(g) {
    x <- as.numeric(cnt[g, , drop = TRUE] > 0)
    stats <- tapply(x, cl, mean)
    data.frame(gene = g, cluster = names(stats), pct_expressing = 100 * as.numeric(stats), stringsAsFactors = FALSE)
  })
  do.call(rbind, out)
}

.core_contam_avg_expr_table <- function(sobj, genes, cluster_col, assay = "RNA") {
  genes <- unique(as.character(genes))
  genes <- genes[genes %in% rownames(sobj)]
  if (!length(genes) || !nzchar(cluster_col) || !(cluster_col %in% colnames(sobj@meta.data))) {
    return(data.frame())
  }
  expr <- .core_contam_as_expr_matrix(sobj, assay = assay, layer = "data")
  if (is.null(expr)) expr <- .core_contam_as_expr_matrix(sobj, assay = assay, layer = "counts")
  if (is.null(expr)) return(data.frame())

  cl <- as.character(sobj@meta.data[[cluster_col]])
  cl[is.na(cl) | !nzchar(cl)] <- "NA"

  out <- lapply(genes, function(g) {
    x <- as.numeric(expr[g, , drop = TRUE])
    stats <- tapply(x, cl, mean)
    data.frame(gene = g, cluster = names(stats), avg_expression = as.numeric(stats), stringsAsFactors = FALSE)
  })
  do.call(rbind, out)
}

.core_contam_top_changed <- function(before_tbl, after_tbl) {
  if (!is.data.frame(before_tbl) || !is.data.frame(after_tbl) || !nrow(before_tbl) || !nrow(after_tbl)) return(data.frame())
  b <- before_tbl
  a <- after_tbl
  names(b)[names(b) == "avg_expression"] <- "avg_before"
  names(a)[names(a) == "avg_expression"] <- "avg_after"
  m <- merge(b, a, by = c("gene", "cluster"), all = FALSE)
  if (!nrow(m)) return(data.frame())
  m$delta <- m$avg_after - m$avg_before
  m$abs_delta <- abs(m$delta)
  m[order(-m$abs_delta), , drop = FALSE]
}

.core_contam_markers_safe <- function(sobj, assay = "RNA") {
  out <- tryCatch({
    Seurat::DefaultAssay(sobj) <- assay
    suppressWarnings(Seurat::FindAllMarkers(sobj, only.pos = FALSE, logfc.threshold = 0.25, min.pct = 0.1, verbose = FALSE))
  }, error = function(e) data.frame())
  out
}

.core_contam_source_cluster <- function(avg_tbl) {
  if (!is.data.frame(avg_tbl) || !nrow(avg_tbl)) return(data.frame())
  split(avg_tbl, avg_tbl$gene) |>
    lapply(function(df) {
      d <- df[order(-df$avg_expression), , drop = FALSE]
      data.frame(gene = d$gene[[1]], source_cluster = as.character(d$cluster[[1]]), source_avg = as.numeric(d$avg_expression[[1]]), stringsAsFactors = FALSE)
    }) |>
    do.call(what = rbind)
}

core_contam_run_sample <- function(method, seurat_obj, sample_context, config = list()) {
  .core_contam_require_backends()
  if (!inherits(seurat_obj, "Seurat")) stop("seurat_obj must be a Seurat object.")

  method <- as.character(method %||% "none")
  method <- if (method %in% c("SoupX", "DecontX", "CellBender", "none")) method else stop("Invalid method.")

  if (identical(method, "none")) {
    return(list(object = seurat_obj, method = "none", backend = list(), corrected_assay = "RNA", run_log = "No correction applied."))
  }

  assay_in <- as.character(config$assay %||% "RNA")
  if (!(assay_in %in% names(seurat_obj@assays))) assay_in <- names(seurat_obj@assays)[[1]]

  backend_res <- switch(
    method,
    SoupX = contam_run_soupx_backend(seurat_obj, sample_context = sample_context$files, config = config),
    DecontX = contam_run_decontx_backend(seurat_obj, sample_context = sample_context$files, config = config),
    CellBender = contam_run_cellbender_backend(seurat_obj, sample_context = sample_context$files, config = config),
    stop("Unsupported method.")
  )

  corrected <- backend_res$corrected_counts
  if (is.null(corrected)) stop("Backend did not return corrected_counts.")

  common_cells <- intersect(colnames(seurat_obj), colnames(corrected))
  if (!length(common_cells)) stop("No overlapping cells between corrected counts and Seurat object.")
  corrected <- corrected[, common_cells, drop = FALSE]

  sobj2 <- subset(seurat_obj, cells = common_cells)

  method_lower <- tolower(method)
  new_assay <- paste0("RNA_", method_lower)
  sobj2[[new_assay]] <- .core_contam_make_assay(corrected)

  sobj2@misc$contamination <- list(
    method = method,
    corrected_assay = new_assay,
    created_at = as.character(Sys.time()),
    sample_name = as.character(sample_context$sample_name %||% ""),
    backend_meta = backend_res$method_meta
  )
  if (!is.null(backend_res$contamination_per_cell)) {
    contam_vec <- backend_res$contamination_per_cell
    contam_vec <- contam_vec[colnames(sobj2)]
    sobj2$contam_estimate <- as.numeric(contam_vec)
  }

  list(
    object = sobj2,
    method = method,
    corrected_assay = new_assay,
    backend = backend_res,
    run_log = paste0("Method=", method, "; cells=", ncol(sobj2), "; assay=", new_assay)
  )
}

core_contam_generate_evaluation <- function(before_obj, after_obj, genes = NULL, config = list()) {
  if (!inherits(before_obj, "Seurat") || !inherits(after_obj, "Seurat")) {
    stop("before_obj and after_obj must be Seurat objects.")
  }
  shared_cells <- intersect(colnames(before_obj), colnames(after_obj))
  if (!length(shared_cells)) stop("No shared cells between before/after objects.")

  before <- subset(before_obj, cells = shared_cells)
  after <- subset(after_obj, cells = shared_cells)

  before_assay <- as.character(config$before_assay %||% "RNA")
  after_assay <- as.character(config$after_assay %||% before_assay)
  if (!(before_assay %in% names(before@assays))) before_assay <- names(before@assays)[[1]]
  if (!(after_assay %in% names(after@assays))) after_assay <- names(after@assays)[[1]]

  if (is.null(genes) || !length(genes)) {
    base_genes <- tryCatch(Seurat::VariableFeatures(before), error = function(e) character(0))
    genes <- head(unique(base_genes), 20)
  }
  genes <- unique(as.character(genes))
  genes <- genes[genes %in% intersect(rownames(before), rownames(after))]
  if (!length(genes)) stop("No valid genes available for evaluation.")

  cluster_col <- .core_contam_pick_cluster_column(after)
  if (!nzchar(cluster_col)) cluster_col <- .core_contam_pick_cluster_column(before)

  before_pct <- .core_contam_pct_expr_table(before, genes, cluster_col, assay = before_assay)
  after_pct <- .core_contam_pct_expr_table(after, genes, cluster_col, assay = after_assay)
  before_avg <- .core_contam_avg_expr_table(before, genes, cluster_col, assay = before_assay)
  after_avg <- .core_contam_avg_expr_table(after, genes, cluster_col, assay = after_assay)

  changed <- .core_contam_top_changed(before_avg, after_avg)

  markers_before <- .core_contam_markers_safe(before, assay = before_assay)
  markers_after <- .core_contam_markers_safe(after, assay = after_assay)

  source_clusters <- .core_contam_source_cluster(before_avg)
  pct_merge <- merge(before_pct, after_pct, by = c("gene", "cluster"), suffixes = c("_before", "_after"), all = TRUE)
  avg_merge <- merge(before_avg, after_avg, by = c("gene", "cluster"), suffixes = c("_before", "_after"), all = TRUE)
  summary_tbl <- merge(pct_merge, avg_merge, by = c("gene", "cluster"), all = TRUE)
  summary_tbl <- merge(summary_tbl, source_clusters, by = "gene", all.x = TRUE)

  summary_tbl$off_target <- !is.na(summary_tbl$source_cluster) & (as.character(summary_tbl$cluster) != as.character(summary_tbl$source_cluster))
  summary_tbl$pct_drop <- as.numeric(summary_tbl$pct_expressing_before) - as.numeric(summary_tbl$pct_expressing_after)
  summary_tbl$source_retained <- ifelse(
    as.character(summary_tbl$cluster) == as.character(summary_tbl$source_cluster),
    as.numeric(summary_tbl$avg_expression_after) >= 0.5 * as.numeric(summary_tbl$avg_expression_before),
    NA
  )
  summary_tbl$contam_suspect <- isTRUE(summary_tbl$off_target) & is.finite(summary_tbl$pct_drop) & (summary_tbl$pct_drop > as.numeric(config$off_target_drop_threshold %||% 5))

  # Plots
  Seurat::DefaultAssay(before) <- before_assay
  Seurat::DefaultAssay(after) <- after_assay
  p_feature_before <- tryCatch(Seurat::FeaturePlot(before, features = head(genes, 4), combine = TRUE), error = function(e) NULL)
  p_feature_after <- tryCatch(Seurat::FeaturePlot(after, features = head(genes, 4), combine = TRUE), error = function(e) NULL)
  p_dot_before <- tryCatch(Seurat::DotPlot(before, features = genes) + ggplot2::ggtitle("Before"), error = function(e) NULL)
  p_dot_after <- tryCatch(Seurat::DotPlot(after, features = genes) + ggplot2::ggtitle("After"), error = function(e) NULL)
  p_vln_before <- tryCatch(Seurat::VlnPlot(before, features = head(genes, 6), ncol = 3), error = function(e) NULL)
  p_vln_after <- tryCatch(Seurat::VlnPlot(after, features = head(genes, 6), ncol = 3), error = function(e) NULL)
  heat_df_before <- before_avg
  heat_df_before$state <- "before"
  names(heat_df_before)[names(heat_df_before) == "avg_expression"] <- "avg_expr"
  heat_df_after <- after_avg
  heat_df_after$state <- "after"
  names(heat_df_after)[names(heat_df_after) == "avg_expression"] <- "avg_expr"
  heat_df <- rbind(heat_df_before, heat_df_after)
  p_heatmap <- tryCatch({
    ggplot2::ggplot(heat_df, ggplot2::aes(x = cluster, y = gene, fill = avg_expr)) +
      ggplot2::geom_tile() +
      ggplot2::facet_wrap(~state, ncol = 2) +
      ggplot2::scale_fill_viridis_c(option = "C") +
      ggplot2::theme_minimal(base_size = 11) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1)) +
      ggplot2::ggtitle("Suspicious gene heatmap before/after")
  }, error = function(e) NULL)

  list(
    genes = genes,
    cluster_column = cluster_col,
    pct_before = before_pct,
    pct_after = after_pct,
    avg_before = before_avg,
    avg_after = after_avg,
    marker_before = markers_before,
    marker_after = markers_after,
    top_changed = changed,
    summary = summary_tbl,
    plots = list(
      feature_before = p_feature_before,
      feature_after = p_feature_after,
      dot_before = p_dot_before,
      dot_after = p_dot_after,
      vln_before = p_vln_before,
      vln_after = p_vln_after,
      heatmap_before_after = p_heatmap
    )
  )
}

.core_contam_project_root <- function(sample_input_path) {
  outs <- .core_contam_find_outs_root(sample_input_path)
  if (nzchar(outs)) return(dirname(outs))
  p <- as.character(sample_input_path %||% "")
  if (!nzchar(p)) return(getwd())
  if (isTRUE(file.info(p)$isdir)) return(p)
  dirname(p)
}

.core_contam_write_matrix <- function(mat, out_dir, prefix = "corrected") {
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  mm <- file.path(out_dir, paste0(prefix, "_matrix.mtx"))
  Matrix::writeMM(mat, file = mm)
  writeLines(rownames(mat), con = file.path(out_dir, paste0(prefix, "_features.tsv")))
  writeLines(colnames(mat), con = file.path(out_dir, paste0(prefix, "_barcodes.tsv")))
}

core_contam_write_outputs <- function(result, output_root, run_id, overwrite = FALSE) {
  if (is.null(result) || is.null(result$object)) stop("result$object is required.")
  if (!nzchar(output_root)) stop("output_root is required.")
  if (!nzchar(run_id)) stop("run_id is required.")

  out_dir <- file.path(output_root, run_id)
  if (dir.exists(out_dir) && !isTRUE(overwrite)) {
    stop("Output path already exists and overwrite=FALSE: ", out_dir)
  }
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

  obj_path <- file.path(out_dir, "corrected_object.rds")
  saveRDS(result$object, obj_path)

  assay <- as.character(result$corrected_assay %||% "RNA")
  cnt <- .core_contam_extract_assay_counts(result$object, assay = assay)
  .core_contam_write_matrix(cnt, out_dir = out_dir, prefix = "corrected")

  meta <- list(
    run_id = run_id,
    method = as.character(result$method %||% ""),
    corrected_assay = assay,
    created_at = as.character(Sys.time()),
    backend = result$backend$method_meta %||% list()
  )
  jsonlite::write_json(meta, path = file.path(out_dir, "config.json"), auto_unbox = TRUE, pretty = TRUE)

  writeLines(as.character(result$run_log %||% ""), con = file.path(out_dir, "run.log"))

  if (is.list(result$evaluation)) {
    ev <- result$evaluation
    write.csv(ev$pct_before %||% data.frame(), file = file.path(out_dir, "pct_expressing_before.csv"), row.names = FALSE)
    write.csv(ev$pct_after %||% data.frame(), file = file.path(out_dir, "pct_expressing_after.csv"), row.names = FALSE)
    write.csv(ev$avg_before %||% data.frame(), file = file.path(out_dir, "avg_expression_before.csv"), row.names = FALSE)
    write.csv(ev$avg_after %||% data.frame(), file = file.path(out_dir, "avg_expression_after.csv"), row.names = FALSE)
    write.csv(ev$marker_before %||% data.frame(), file = file.path(out_dir, "markers_before.csv"), row.names = FALSE)
    write.csv(ev$marker_after %||% data.frame(), file = file.path(out_dir, "markers_after.csv"), row.names = FALSE)
    write.csv(ev$top_changed %||% data.frame(), file = file.path(out_dir, "top_changed_genes.csv"), row.names = FALSE)
    write.csv(ev$summary %||% data.frame(), file = file.path(out_dir, "summary_metrics.csv"), row.names = FALSE)

    plots <- ev$plots %||% list()
    for (nm in names(plots)) {
      p <- plots[[nm]]
      if (is.null(p)) next
      fp <- file.path(out_dir, paste0(nm, ".png"))
      try(ggplot2::ggsave(filename = fp, plot = p, width = 10, height = 7, dpi = 140), silent = TRUE)
    }

    report_lines <- c(
      "# Contamination Correction Summary",
      "",
      paste0("Run ID: ", run_id),
      paste0("Method: ", as.character(result$method %||% "")),
      "",
      "## Interpretation",
      "- Off-target weak haze that drops after correction while source-cluster expression is retained suggests contamination.",
      "- Persistent broad, coherent signal after correction suggests true broad biology.",
      "",
      "## Data Files",
      "- summary_metrics.csv",
      "- top_changed_genes.csv",
      "- markers_before.csv / markers_after.csv"
    )
    writeLines(report_lines, con = file.path(out_dir, "summary_report.md"))
  }

  if (identical(as.character(result$method %||% ""), "CellBender")) {
    cb <- result$backend$method_meta %||% list()
    cb_files <- c("output_h5", "output_report", "output_metrics")
    for (key in cb_files) {
      src <- as.character(cb[[key]] %||% "")
      if (nzchar(src) && file.exists(src)) {
        file.copy(src, file.path(out_dir, basename(src)), overwrite = TRUE)
      }
    }
  }

  contam_per_cell <- result$backend$contamination_per_cell %||% NULL
  if (!is.null(contam_per_cell) && length(contam_per_cell)) {
    df_cell <- data.frame(cell = names(contam_per_cell), contamination = as.numeric(contam_per_cell), stringsAsFactors = FALSE)
    write.csv(df_cell, file = file.path(out_dir, "contamination_per_cell.csv"), row.names = FALSE)
    cl_col <- .core_contam_pick_cluster_column(result$object)
    if (nzchar(cl_col) && cl_col %in% colnames(result$object@meta.data)) {
      md <- result$object@meta.data
      rownames(md) <- colnames(result$object)
      df_cell$cluster <- as.character(md[df_cell$cell, cl_col, drop = TRUE])
      cl_sum <- stats::aggregate(contamination ~ cluster, data = df_cell, FUN = mean)
      write.csv(cl_sum, file = file.path(out_dir, "contamination_per_cluster.csv"), row.names = FALSE)
    }
  }

  list(output_dir = out_dir, object_path = obj_path)
}
