# analysis_beta_methods_core.R
# Core helpers for beta analysis pages (CellChat / pySCENIC / Monocle2 / NicheNet / NICHES / scTenifoldKnk).
# These functions are Shiny-agnostic and operate on plain objects.

`%||%` <- function(a, b) if (is.null(a)) b else a

beta_get_object_names <- function(shared_data) {
  reg <- tryCatch(shared_data$all_seurat_objects, error = function(e) list()) %||% list()
  names(reg)
}

beta_get_registry_object <- function(shared_data, object_name = NULL) {
  reg <- tryCatch(shared_data$all_seurat_objects, error = function(e) list()) %||% list()
  nm <- as.character(object_name %||% "")
  if (!nzchar(nm)) nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
  if (!nzchar(nm)) nm <- names(reg)[1] %||% ""
  if (!nzchar(nm) || !(nm %in% names(reg))) return(NULL)
  entry <- reg[[nm]]
  if (is.list(entry) && !is.null(entry$obj)) return(entry$obj)
  entry
}

beta_meta_candidate_columns <- function(sobj, min_unique = 2L) {
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !nrow(md)) return(character(0))
  cols <- colnames(md)
  keep <- vapply(cols, function(cn) {
    v <- md[[cn]]
    sum(!is.na(v)) > 0 && length(unique(as.character(v))) >= min_unique
  }, logical(1))
  cols[keep]
}

beta_default_group_col <- function(cols) {
  pref <- c("seurat_clusters", "celltype", "cell_type", "annotation", "orig.ident", "sample", "condition", "batch")
  hit <- intersect(pref, cols)
  if (length(hit)) return(hit[[1]])
  cols[[1]] %||% ""
}

beta_get_embedding_df <- function(sobj, prefer = c("umap", "tsne", "pca")) {
  reds <- tryCatch(names(sobj@reductions), error = function(e) character(0))
  if (!length(reds)) stop("No dimensional reduction found. Run PCA/UMAP first.")
  red_lower <- tolower(reds)
  pick <- NULL
  for (p in prefer) {
    idx <- which(startsWith(red_lower, tolower(p)))
    if (length(idx)) {
      pick <- reds[[idx[[1]]]]
      break
    }
  }
  if (is.null(pick)) pick <- reds[[1]]
  emb <- tryCatch(Seurat::Embeddings(sobj, pick), error = function(e) NULL)
  if (is.null(emb) || ncol(emb) < 2) stop("Selected reduction does not have at least 2 dimensions.")
  data.frame(cell = rownames(emb), x = emb[, 1], y = emb[, 2], reduction = pick, stringsAsFactors = FALSE)
}

beta_get_assay_data <- function(sobj, assay = NULL, prefer = c("data", "counts")) {
  assay_use <- assay %||% tryCatch(Seurat::DefaultAssay(sobj), error = function(e) NULL)
  if (is.null(assay_use) || !nzchar(assay_use)) assay_use <- names(sobj@assays)[1] %||% ""
  if (!nzchar(assay_use)) stop("No assay available in Seurat object.")

  mat <- NULL
  for (slot_name in prefer) {
    mat <- tryCatch(Seurat::GetAssayData(sobj, assay = assay_use, layer = slot_name), error = function(e) NULL)
    if (!is.null(mat)) break
    mat <- tryCatch(Seurat::GetAssayData(sobj, assay = assay_use, slot = slot_name), error = function(e) NULL)
    if (!is.null(mat)) break
  }
  if (is.null(mat)) stop("Unable to extract assay matrix (data/counts).")
  mat
}

beta_extract_gene_vector <- function(sobj, gene, assay = NULL) {
  if (is.null(gene) || !nzchar(gene)) return(NULL)
  mat <- beta_get_assay_data(sobj, assay = assay)
  genes <- rownames(mat)
  if (!length(genes)) return(NULL)
  idx <- match(tolower(gene), tolower(genes))
  if (is.na(idx)) return(NULL)
  as.numeric(mat[idx, ])
}

beta_top_variable_genes <- function(sobj, n = 100L, assay = NULL) {
  vg <- tryCatch(Seurat::VariableFeatures(sobj), error = function(e) character(0))
  if (length(vg) >= n) return(vg[seq_len(n)])
  mat <- beta_get_assay_data(sobj, assay = assay)
  if (!nrow(mat)) return(character(0))
  vv <- apply(as.matrix(mat), 1, stats::var)
  names(sort(vv, decreasing = TRUE))[seq_len(min(n, length(vv)))]
}

beta_group_interaction_preview <- function(sobj, group_col) {
  md <- sobj@meta.data
  if (!(group_col %in% colnames(md))) stop("Group column not found in metadata.")
  g <- as.character(md[[group_col]])
  g[is.na(g) | !nzchar(g)] <- "Unknown"
  tab <- sort(table(g), decreasing = TRUE)
  groups <- names(tab)
  p <- as.numeric(tab) / sum(tab)
  mat <- outer(p, p)
  rownames(mat) <- groups
  colnames(mat) <- groups

  pair <- as.data.frame(as.table(mat), stringsAsFactors = FALSE)
  colnames(pair) <- c("sender", "receiver", "score")
  pair <- pair[order(pair$score, decreasing = TRUE), , drop = FALSE]

  list(
    groups = groups,
    counts = tab,
    interaction = mat,
    sender_score = data.frame(group = groups, score = rowSums(mat), stringsAsFactors = FALSE),
    receiver_score = data.frame(group = groups, score = colSums(mat), stringsAsFactors = FALSE),
    pair_df = utils::head(pair, 30)
  )
}

beta_scenic_preview <- function(sobj, group_col, tf_gene = "", top_regulons = 15L, edge_n = 60L) {
  md <- sobj@meta.data
  if (!(group_col %in% colnames(md))) stop("Group column not found in metadata.")
  emb <- beta_get_embedding_df(sobj)
  groups <- as.character(md[[group_col]])

  tf_expr <- beta_extract_gene_vector(sobj, tf_gene)
  if (is.null(tf_expr)) {
    fallback_gene <- beta_top_variable_genes(sobj, n = 1L)[1] %||% ""
    tf_expr <- beta_extract_gene_vector(sobj, fallback_gene)
    tf_gene <- fallback_gene
  }
  if (is.null(tf_expr)) stop("Could not derive TF expression vector.")

  top_genes <- beta_top_variable_genes(sobj, n = max(20L, as.integer(top_regulons)))
  mat <- beta_get_assay_data(sobj)
  top_genes <- intersect(top_genes, rownames(mat))
  if (!length(top_genes)) stop("No variable genes available for SCENIC preview.")

  group_levels <- unique(groups)
  heat <- sapply(group_levels, function(gl) {
    idx <- which(groups == gl)
    if (!length(idx)) return(rep(0, length(top_genes)))
    Matrix::rowMeans(mat[top_genes, idx, drop = FALSE])
  })
  if (is.null(dim(heat))) heat <- matrix(heat, nrow = length(top_genes))
  rownames(heat) <- top_genes
  colnames(heat) <- group_levels

  corv <- apply(as.matrix(mat[top_genes, , drop = FALSE]), 1, function(v) suppressWarnings(stats::cor(as.numeric(v), tf_expr, use = "pairwise.complete.obs")))
  corv[is.na(corv)] <- 0
  ord <- order(abs(corv), decreasing = TRUE)
  ord <- ord[seq_len(min(as.integer(edge_n), length(ord)))]

  list(
    tf_gene = tf_gene,
    emb = emb,
    tf_expr = tf_expr,
    groups = groups,
    heat = heat,
    rss = data.frame(regulon = names(corv)[seq_len(min(length(corv), 20L))], score = sort(abs(corv), decreasing = TRUE)[seq_len(min(length(corv), 20L))], stringsAsFactors = FALSE),
    target_rank = data.frame(gene = names(corv)[ord], score = as.numeric(corv[ord]), stringsAsFactors = FALSE)
  )
}

beta_monocle2_preview <- function(sobj, group_col, ordering_genes = 1000L) {
  md <- sobj@meta.data
  if (!(group_col %in% colnames(md))) stop("Group column not found in metadata.")
  emb <- beta_get_embedding_df(sobj)
  pt <- rank(emb$x, ties.method = "average") / nrow(emb)

  top_genes <- beta_top_variable_genes(sobj, n = max(50L, as.integer(ordering_genes)))
  mat <- beta_get_assay_data(sobj)
  top_genes <- intersect(top_genes, rownames(mat))
  top_genes <- top_genes[seq_len(min(40L, length(top_genes)))]

  if (!length(top_genes)) stop("No genes available for Monocle2 preview.")

  cors <- apply(as.matrix(mat[top_genes, , drop = FALSE]), 1, function(v) {
    ct <- suppressWarnings(stats::cor.test(as.numeric(v), pt, method = "spearman"))
    c(rho = unname(ct$estimate), p = ct$p.value)
  })
  cors <- t(cors)
  cors_df <- data.frame(gene = rownames(cors), trend = cors[, "rho"], qval = -log10(pmax(cors[, "p"], 1e-300)), stringsAsFactors = FALSE)
  cors_df <- cors_df[order(cors_df$qval, decreasing = TRUE), , drop = FALSE]

  bins <- cut(pt, breaks = 10, labels = FALSE, include.lowest = TRUE)
  heat_genes <- cors_df$gene[seq_len(min(20L, nrow(cors_df)))]
  heat <- sapply(sort(unique(bins)), function(b) Matrix::rowMeans(mat[heat_genes, bins == b, drop = FALSE]))
  if (is.null(dim(heat))) heat <- matrix(heat, nrow = length(heat_genes))
  rownames(heat) <- heat_genes

  list(
    emb = emb,
    pseudotime = pt,
    groups = as.character(md[[group_col]]),
    heat = heat,
    divergence = utils::head(cors_df, 200)
  )
}

beta_nichenet_preview <- function(sobj, group_col, sender_level, receiver_level, top_ligands = 30L, condition_col = "", condition_case = "", condition_control = "") {
  md <- sobj@meta.data
  if (!(group_col %in% colnames(md))) stop("Group column not found in metadata.")
  grp <- as.character(md[[group_col]])
  sender_idx <- which(grp == sender_level)
  receiver_idx <- which(grp == receiver_level)
  if (!length(sender_idx) || !length(receiver_idx)) stop("Sender/receiver selection has zero cells.")

  mat <- beta_get_assay_data(sobj)
  mu_sender <- Matrix::rowMeans(mat[, sender_idx, drop = FALSE])
  mu_other <- Matrix::rowMeans(mat[, setdiff(seq_len(ncol(mat)), sender_idx), drop = FALSE])
  lig_score <- as.numeric(mu_sender - mu_other)
  names(lig_score) <- rownames(mat)
  lig <- names(sort(lig_score, decreasing = TRUE))[seq_len(min(as.integer(top_ligands), length(lig_score)))]

  targets <- character(0)
  if (nzchar(condition_col) && (condition_col %in% colnames(md)) && nzchar(condition_case) && nzchar(condition_control)) {
    rc <- receiver_idx[as.character(md[[condition_col]][receiver_idx]) == condition_case]
    rt <- receiver_idx[as.character(md[[condition_col]][receiver_idx]) == condition_control]
    if (length(rc) >= 3 && length(rt) >= 3) {
      de <- Matrix::rowMeans(mat[, rc, drop = FALSE]) - Matrix::rowMeans(mat[, rt, drop = FALSE])
      targets <- names(sort(abs(de), decreasing = TRUE))[seq_len(min(30L, length(de)))]
    }
  }
  if (!length(targets)) targets <- beta_top_variable_genes(sobj, n = 30L)
  targets <- intersect(targets, rownames(mat))

  m_l <- as.matrix(mat[lig, receiver_idx, drop = FALSE])
  m_t <- as.matrix(mat[targets, receiver_idx, drop = FALSE])
  if (!nrow(m_l) || !nrow(m_t)) stop("Could not construct ligand-target matrix.")

  lt <- matrix(0, nrow = nrow(m_l), ncol = nrow(m_t), dimnames = list(rownames(m_l), rownames(m_t)))
  for (i in seq_len(nrow(m_l))) {
    for (j in seq_len(nrow(m_t))) {
      lt[i, j] <- suppressWarnings(stats::cor(m_l[i, ], m_t[j, ], use = "pairwise.complete.obs"))
    }
  }
  lt[is.na(lt)] <- 0

  pair <- beta_group_interaction_preview(sobj, group_col)
  list(
    ligand_rank = data.frame(ligand = lig, score = lig_score[lig], stringsAsFactors = FALSE),
    ligand_target = lt,
    sender_receiver_pairs = pair$pair_df,
    pathway_like = data.frame(name = paste0("P", seq_len(min(12L, length(lig)))), score = sort(abs(lig_score[lig]), decreasing = TRUE)[seq_len(min(12L, length(lig)))], stringsAsFactors = FALSE)
  )
}

beta_niches_preview <- function(sobj, group_col, top_pairs = 80L) {
  inter <- beta_group_interaction_preview(sobj, group_col)
  mat <- inter$interaction
  if (nrow(mat) >= 2) {
    pc <- stats::prcomp(mat, scale. = TRUE)
    emb <- data.frame(group = rownames(mat), x = pc$x[, 1], y = pc$x[, 2], stringsAsFactors = FALSE)
  } else {
    emb <- data.frame(group = rownames(mat), x = seq_len(nrow(mat)), y = 0, stringsAsFactors = FALSE)
  }
  list(
    emb = emb,
    interaction = mat,
    pair_df = utils::head(inter$pair_df, as.integer(top_pairs)),
    sender = inter$sender_score
  )
}

beta_sctenifold_preview <- function(sobj, target_gene, top_genes = 30L, group_col = "") {
  mat <- beta_get_assay_data(sobj)
  if (!nzchar(target_gene)) stop("Target gene is required.")
  idx <- match(tolower(target_gene), tolower(rownames(mat)))
  if (is.na(idx)) stop("Target gene not found in expression matrix.")

  target_vec <- as.numeric(mat[idx, ])
  genes <- beta_top_variable_genes(sobj, n = max(200L, as.integer(top_genes) * 3L))
  genes <- setdiff(intersect(genes, rownames(mat)), rownames(mat)[idx])
  if (!length(genes)) stop("No genes available for perturbation ranking.")

  corr <- vapply(genes, function(g) suppressWarnings(stats::cor(as.numeric(mat[g, ]), target_vec, use = "pairwise.complete.obs")), numeric(1))
  corr[is.na(corr)] <- 0
  ord <- order(abs(corr), decreasing = TRUE)
  ord <- ord[seq_len(min(length(ord), 250L))]
  g2 <- genes[ord]
  c2 <- corr[ord]

  n <- ncol(mat)
  tval <- abs(c2) * sqrt((n - 2) / pmax(1e-12, 1 - c2^2))
  pval <- 2 * stats::pt(-tval, df = max(1, n - 2))

  emb <- beta_get_embedding_df(sobj)
  out <- list(
    emb = emb,
    target_expr = target_vec,
    rank = data.frame(gene = g2[seq_len(min(as.integer(top_genes), length(g2)))], score = c2[seq_len(min(as.integer(top_genes), length(c2)))], stringsAsFactors = FALSE),
    volcano = data.frame(gene = g2, effect = c2, nlp = -log10(pmax(pval, 1e-300)), stringsAsFactors = FALSE)
  )

  if (nzchar(group_col) && (group_col %in% colnames(sobj@meta.data))) {
    grp <- as.character(sobj@meta.data[[group_col]])
    levels <- unique(grp)
    topg <- out$rank$gene
    impact <- sapply(levels, function(gl) {
      idxg <- which(grp == gl)
      if (!length(idxg)) return(0)
      mean(abs(Matrix::rowMeans(mat[topg, idxg, drop = FALSE])), na.rm = TRUE)
    })
    out$pathway_like <- data.frame(name = levels, score = as.numeric(impact), stringsAsFactors = FALSE)
  } else {
    out$pathway_like <- data.frame(name = out$rank$gene[seq_len(min(12L, nrow(out$rank)))], score = abs(out$rank$score[seq_len(min(12L, nrow(out$rank)))]), stringsAsFactors = FALSE)
  }
  out
}
