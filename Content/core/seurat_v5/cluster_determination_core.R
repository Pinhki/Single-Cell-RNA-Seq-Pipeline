# analysis_tab_d_core.R
# Tab D: cluster determination (Seurat v5 variant)
`%||%` <- function(a, b) if (!is.null(a)) a else b

.analysis_v5_backend_script <- function() {
  candidates <- c(
    file.path("seurat5", "main_analysis_seurat.R"),
    file.path("seurat4", "main_analysis_seurat.R"),
    file.path("Content", "seurat5", "main_analysis_seurat.R"),
    file.path("Content", "seurat4", "main_analysis_seurat.R"),
    file.path("..", "..", "seurat5", "main_analysis_seurat.R"),
    file.path("..", "..", "seurat4", "main_analysis_seurat.R"),
    file.path("..", "..", "..", "Content", "seurat5", "main_analysis_seurat.R"),
    file.path("..", "..", "..", "Content", "seurat4", "main_analysis_seurat.R")
  )
  hit <- candidates[file.exists(candidates)][1]
  if (is.na(hit) || !nzchar(hit)) {
    stop("No analysis backend script found (expected seurat5/main_analysis_seurat.R or seurat4/main_analysis_seurat.R).")
  }
  hit
}

.analysis_v5_source_main <- function() {
  src <- .analysis_v5_backend_script()
  env <- new.env(parent = .GlobalEnv)
  source(src, local = env, chdir = TRUE)
  if (!exists("run_heatmap", envir = env, mode = "function", inherits = FALSE)) {
    stop("Missing required function in backend script: run_heatmap")
  }
  env
}

core_analysis_tab_d_run_heatmap <- function(seurat_obj, heatmap_params = list(num_genes = 5)) {
  backend <- .analysis_v5_source_main()
  backend$run_heatmap(seurat_obj = seurat_obj, heatmap_params = heatmap_params)
}

.core_tab_d_try_counts <- function(seurat_obj, assay) {
  if (is.null(assay) || !nzchar(assay)) return(NULL)
  m <- tryCatch(
    Seurat::GetAssayData(seurat_obj, assay = assay, layer = "counts"),
    error = function(e) NULL
  )
  if (is.null(m)) {
    m <- tryCatch(
      Seurat::GetAssayData(seurat_obj, assay = assay, slot = "counts"),
      error = function(e) NULL
    )
  }
  if (is.null(m) || nrow(m) == 0 || ncol(m) == 0) return(NULL)
  m
}

.core_tab_d_get_counts <- function(seurat_obj) {
  assays <- tryCatch(Seurat::Assays(seurat_obj), error = function(e) character())
  assays <- unique(as.character(assays))
  default_assay <- tryCatch(Seurat::DefaultAssay(seurat_obj), error = function(e) NULL)
  assay_order <- unique(c(
    "RNA",
    default_assay,
    assays,
    "SCT",
    "integrated"
  ))
  assay_order <- assay_order[nzchar(assay_order)]

  for (assay in assay_order) {
    m <- .core_tab_d_try_counts(seurat_obj, assay)
    if (!is.null(m)) return(m)
  }

  stop(
    "No assay with a non-empty counts layer was found. ",
    "Pseudobulk DEG needs raw counts (usually from the RNA assay)."
  )
}

.core_tab_d_pb_aggregate_counts <- function(mat, meta_df, sample_col, cluster_col, group_col = NULL) {
  group_keys <- if (!is.null(group_col) && nzchar(group_col) && group_col %in% colnames(meta_df)) {
    paste(meta_df[[sample_col]], meta_df[[cluster_col]], meta_df[[group_col]], sep = "||")
  } else {
    paste(meta_df[[sample_col]], meta_df[[cluster_col]], sep = "||")
  }
  uniq <- unique(group_keys)
  pb <- vapply(uniq, function(k) {
    idx <- which(group_keys == k)
    Matrix::rowSums(mat[, idx, drop = FALSE])
  }, FUN.VALUE = numeric(nrow(mat)))
  pb <- as.matrix(pb)
  rownames(pb) <- rownames(mat)
  colnames(pb) <- uniq

  sp <- strsplit(uniq, "\\|\\|")
  out <- data.frame(
    key = uniq,
    sample = vapply(sp, `[`, character(1), 1),
    cluster = vapply(sp, `[`, character(1), 2),
    stringsAsFactors = FALSE
  )
  if (!is.null(group_col) && nzchar(group_col) && group_col %in% colnames(meta_df)) {
    out[[group_col]] <- vapply(sp, `[`, character(1), 3)
  }
  list(mat = pb, meta = out)
}

.core_tab_d_empty_de <- function(genes) {
  data.frame(
    gene = genes,
    logFC = NA_real_,
    p_val = NA_real_,
    p_adj = NA_real_,
    neglog10_fdr = NA_real_,
    stringsAsFactors = FALSE
  )
}

.core_tab_d_pb_compare_edger <- function(pb_mat, idx_a, idx_b, min_reps = 2L) {
  genes <- rownames(pb_mat)
  idx_a <- as.integer(idx_a)
  idx_b <- as.integer(idx_b)
  if (length(idx_a) < min_reps || length(idx_b) < min_reps) return(.core_tab_d_empty_de(genes))

  sel <- c(idx_a, idx_b)
  grp <- factor(c(rep("A", length(idx_a)), rep("B", length(idx_b))))
  y <- edgeR::DGEList(counts = round(pb_mat[, sel, drop = FALSE]), group = grp)
  keep <- edgeR::filterByExpr(y, group = grp)
  if (!any(keep)) return(.core_tab_d_empty_de(genes))
  y <- y[keep, , keep.lib.sizes = FALSE]
  y <- edgeR::calcNormFactors(y)
  design <- stats::model.matrix(~ grp)
  y <- edgeR::estimateDisp(y, design)
  fit <- edgeR::glmQLFit(y, design, robust = TRUE)
  qlf <- edgeR::glmQLFTest(fit, coef = 2)
  tt <- edgeR::topTags(qlf, n = Inf, sort.by = "none")$table

  out <- .core_tab_d_empty_de(genes)
  m <- match(rownames(tt), out$gene)
  out$logFC[m] <- as.numeric(tt$logFC)
  out$p_val[m] <- as.numeric(tt$PValue)
  out$p_adj[m] <- as.numeric(tt$FDR)
  out$neglog10_fdr <- -log10(pmax(out$p_adj, 1e-300))
  out
}

.core_tab_d_pb_compare_deseq2 <- function(pb_mat, idx_a, idx_b, min_reps = 2L) {
  genes <- rownames(pb_mat)
  idx_a <- as.integer(idx_a)
  idx_b <- as.integer(idx_b)
  if (length(idx_a) < min_reps || length(idx_b) < min_reps) return(.core_tab_d_empty_de(genes))

  sel <- c(idx_a, idx_b)
  grp <- factor(c(rep("A", length(idx_a)), rep("B", length(idx_b))), levels = c("B", "A"))
  counts <- round(pb_mat[, sel, drop = FALSE])
  col_data <- S4Vectors::DataFrame(group = grp)
  dds <- DESeq2::DESeqDataSetFromMatrix(countData = counts, colData = col_data, design = ~ group)
  keep <- rowSums(DESeq2::counts(dds)) >= 10
  if (!any(keep)) return(.core_tab_d_empty_de(genes))
  dds <- dds[keep, ]
  dds <- DESeq2::DESeq(dds, quiet = TRUE)
  rs <- as.data.frame(DESeq2::results(dds, contrast = c("group", "A", "B")))

  out <- .core_tab_d_empty_de(genes)
  m <- match(rownames(rs), out$gene)
  out$logFC[m] <- as.numeric(rs$log2FoldChange)
  out$p_val[m] <- as.numeric(rs$pvalue)
  out$p_adj[m] <- as.numeric(rs$padj)
  out$neglog10_fdr <- -log10(pmax(out$p_adj, 1e-300))
  out
}

.core_tab_d_pb_compare <- function(pb_mat, idx_a, idx_b, de_method = c("edgeR", "DESeq2"), min_reps = 2L) {
  de_method <- match.arg(de_method)
  if (identical(de_method, "edgeR")) {
    if (!requireNamespace("edgeR", quietly = TRUE)) stop("edgeR is required but not installed in the active environment.")
    return(.core_tab_d_pb_compare_edger(pb_mat, idx_a, idx_b, min_reps = min_reps))
  }
  if (!requireNamespace("DESeq2", quietly = TRUE)) stop("DESeq2 is required but not installed in the active environment.")
  if (!requireNamespace("S4Vectors", quietly = TRUE)) stop("S4Vectors is required for DESeq2 pseudobulk.")
  .core_tab_d_pb_compare_deseq2(pb_mat, idx_a, idx_b, min_reps = min_reps)
}

core_analysis_tab_d_compute_pseudobulk <- function(
  seurat_obj,
  resolution_col,
  sample_col = "orig.ident",
  max_genes = 2000L,
  de_method = c("edgeR", "DESeq2"),
  mode = c("per_cluster_vs_rest", "cluster_vs_cluster", "cluster_set_vs_rest", "condition_within_clusters"),
  cluster_a = NULL,
  cluster_b = NULL,
  group_var = NULL,
  group_a = NULL,
  group_b = NULL
) {
  mode <- match.arg(mode)
  de_method <- match.arg(de_method)
  md <- seurat_obj@meta.data
  if (!resolution_col %in% colnames(md)) stop("Selected resolution column not found in metadata.")
  if (!sample_col %in% colnames(md)) stop("Selected sample column not found in metadata.")

  mat <- .core_tab_d_get_counts(seurat_obj)
  var_genes <- tryCatch(Seurat::VariableFeatures(seurat_obj), error = function(e) character())
  keep <- intersect(var_genes, rownames(mat))
  if (!length(keep)) keep <- rownames(mat)
  max_genes <- max(200L, as.integer(max_genes))
  if (length(keep) > max_genes) keep <- keep[seq_len(max_genes)]
  mat <- mat[keep, , drop = FALSE]

  needed <- unique(c(sample_col, resolution_col, group_var))
  needed <- needed[!is.na(needed) & nzchar(needed) & needed %in% colnames(md)]
  meta_df <- md[, needed, drop = FALSE]
  colnames(meta_df)[colnames(meta_df) == resolution_col] <- ".__cluster__"
  colnames(meta_df)[colnames(meta_df) == sample_col] <- ".__sample__"
  if (!is.null(group_var) && nzchar(group_var) && group_var %in% colnames(md)) {
    colnames(meta_df)[colnames(meta_df) == group_var] <- ".__group__"
    group_key <- ".__group__"
  } else {
    group_key <- NULL
  }

  agg <- .core_tab_d_pb_aggregate_counts(
    mat = mat,
    meta_df = meta_df,
    sample_col = ".__sample__",
    cluster_col = ".__cluster__",
    group_col = group_key
  )
  pb_mat <- agg$mat
  pb_meta <- agg$meta
  pb_meta$cluster <- as.character(pb_meta$cluster)

  out <- list(per_cluster = NULL, custom = NULL, meta = pb_meta)

  if (identical(mode, "per_cluster_vs_rest")) {
    cl <- sort(unique(pb_meta$cluster))
    lst <- lapply(cl, function(cc) {
      ia <- which(pb_meta$cluster == cc)
      ib <- which(pb_meta$cluster != cc)
      d <- .core_tab_d_pb_compare(pb_mat, ia, ib, de_method = de_method, min_reps = 2L)
      d$cluster <- cc
      d
    })
    out$per_cluster <- do.call(rbind, lst)
    return(out)
  }

  if (identical(mode, "cluster_vs_cluster")) {
    cluster_a <- as.character(cluster_a %||% character())
    cluster_b <- as.character(cluster_b %||% character())
    ia <- which(pb_meta$cluster %in% cluster_a)
    ib <- which(pb_meta$cluster %in% cluster_b)
    d <- .core_tab_d_pb_compare(pb_mat, ia, ib, de_method = de_method, min_reps = 2L)
    d$comparison <- sprintf("Clusters (%s) vs (%s)",
                            paste(cluster_a, collapse = ", "),
                            paste(cluster_b, collapse = ", "))
    out$custom <- d
    return(out)
  }

  if (identical(mode, "cluster_set_vs_rest")) {
    cluster_a <- as.character(cluster_a %||% character())
    ia <- which(pb_meta$cluster %in% cluster_a)
    ib <- which(!(pb_meta$cluster %in% cluster_a))
    d <- .core_tab_d_pb_compare(pb_mat, ia, ib, de_method = de_method, min_reps = 2L)
    d$comparison <- sprintf(
      "Cluster set (%s) vs rest",
      paste(cluster_a, collapse = ", ")
    )
    out$custom <- d
    return(out)
  }

  if (identical(mode, "condition_within_clusters")) {
    if (is.null(group_key) || !group_key %in% colnames(pb_meta)) {
      stop("A valid grouping column is required for condition comparison.")
    }
    cluster_a <- as.character(cluster_a %||% character())
    ia <- which(pb_meta$cluster %in% cluster_a & pb_meta[[group_key]] %in% as.character(group_a))
    ib <- which(pb_meta$cluster %in% cluster_a & pb_meta[[group_key]] %in% as.character(group_b))
    d <- .core_tab_d_pb_compare(pb_mat, ia, ib, de_method = de_method, min_reps = 2L)
    d$comparison <- sprintf("%s: %s vs %s | clusters: %s",
                            group_var,
                            as.character(group_a),
                            as.character(group_b),
                            paste(cluster_a, collapse = ", "))
    out$custom <- d
    return(out)
  }

  out
}
