# sctenifoldknk_core.R

`%||%` <- function(a, b) if (is.null(a)) b else a

sctenifold_beta_object_names <- function(shared_data) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm in names(reg_flt)) if (is.null(reg[[nm]])) reg[[nm]] <- reg_flt[[nm]]

  nms <- names(reg)
  if (!length(nms)) return(character(0))
  nms <- nms[nzchar(nms)]
  if (!length(nms)) return(character(0))

  keep <- vapply(nms, function(nm) {
    x <- reg[[nm]]
    obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
    inherits(obj, "Seurat")
  }, logical(1))
  unique(nms[keep])
}

sctenifold_beta_get_object <- function(shared_data, object_name = NULL) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm0 in names(reg_flt)) if (is.null(reg[[nm0]])) reg[[nm0]] <- reg_flt[[nm0]]

  valid_nms <- sctenifold_beta_object_names(shared_data)
  nm <- as.character(object_name %||% "")
  if (!nzchar(nm)) nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
  if (!nzchar(nm) || !(nm %in% valid_nms)) nm <- if (length(valid_nms)) valid_nms[[length(valid_nms)]] else ""
  if (!nzchar(nm) || !(nm %in% names(reg))) return(NULL)

  x <- reg[[nm]]
  obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
  if (!inherits(obj, "Seurat")) return(NULL)
  obj
}

sctenifold_beta_meta_cols <- function(sobj) {
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !nrow(md)) return(character(0))
  cols <- colnames(md)
  keep <- vapply(cols, function(cn) {
    v <- md[[cn]]
    v <- v[!is.na(v)]
    if (!length(v)) return(FALSE)
    nu <- length(unique(as.character(v)))
    if (nu < 2L) return(FALSE)
    if (is.numeric(v) || is.integer(v)) {
      return(nu <= max(30L, floor(0.2 * length(v))))
    }
    TRUE
  }, logical(1))
  cols[keep]
}

sctenifold_beta_assays <- function(sobj) {
  aa <- tryCatch(names(sobj@assays), error = function(e) character(0))
  aa[nzchar(aa)]
}

sctenifold_beta_default_assay <- function(sobj) {
  aa <- sctenifold_beta_assays(sobj)
  if (!length(aa)) return("")
  if ("RNA" %in% aa) return("RNA")
  da <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "")
  if (nzchar(da) && da %in% aa) return(da)
  aa[[1]]
}

.sctenifold_get_data <- function(sobj, assay = NULL, pref = c("data", "counts")) {
  aa <- sctenifold_beta_assays(sobj)
  use_assay <- as.character(assay %||% "")
  if (!nzchar(use_assay) || !(use_assay %in% aa)) use_assay <- sctenifold_beta_default_assay(sobj)
  if (!nzchar(use_assay)) stop("No assay available for scTenifoldKnk.")

  for (pp in pref) {
    m <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, layer = pp), error = function(e) NULL)
    if (!is.null(m)) return(list(matrix = m, assay = use_assay, slot = pp))
    m <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, slot = pp), error = function(e) NULL)
    if (!is.null(m)) return(list(matrix = m, assay = use_assay, slot = pp))
  }
  stop("Could not read expression data for scTenifoldKnk.")
}

.sctenifold_pick_target <- function(m, target_gene = "") {
  tg <- trimws(as.character(target_gene %||% ""))
  if (!nzchar(tg)) stop("Target gene is empty.")
  ii <- match(tolower(tg), tolower(rownames(m)))
  if (is.na(ii)) stop("Target gene not found in expression matrix.")
  rownames(m)[ii]
}

.sctenifold_embed_cells <- function(sobj) {
  reds <- names(sobj@reductions)
  if (!length(reds)) return(data.frame(x = seq_len(ncol(sobj)), y = 0, stringsAsFactors = FALSE))
  red <- reds[tolower(reds) == "umap"][1] %||% reds[[1]]
  emb <- Seurat::Embeddings(sobj, red)
  data.frame(x = emb[, 1], y = emb[, 2], stringsAsFactors = FALSE)
}

.sctenifold_rank_from_expr <- function(m, target_gene, top_genes = 30L) {
  ii <- match(tolower(target_gene), tolower(rownames(m)))
  tvec <- as.numeric(m[ii, ])

  vf <- rownames(m)
  vf <- setdiff(vf, rownames(m)[ii])
  n_take <- min(length(vf), max(100L, as.integer(top_genes) * 4L))
  vf <- vf[seq_len(n_take)]
  if (!length(vf)) stop("No genes available for target diagnostics.")

  corr <- vapply(vf, function(g) suppressWarnings(stats::cor(as.numeric(m[g, ]), tvec, use = "pairwise.complete.obs")), numeric(1))
  corr[!is.finite(corr)] <- 0
  ord <- order(abs(corr), decreasing = TRUE)

  rank_df <- data.frame(
    gene = vf[ord[seq_len(min(length(ord), as.integer(top_genes)))]],
    score = corr[ord[seq_len(min(length(ord), as.integer(top_genes)))]],
    stringsAsFactors = FALSE
  )

  list(target_expr = tvec, rank = rank_df)
}

sctenifold_beta_preview <- function(sobj, target_gene, top_genes = 30L, group_col = "", assay = NULL) {
  dat <- .sctenifold_get_data(sobj, assay = assay, pref = c("data", "counts"))
  m <- dat$matrix
  if (!inherits(m, "matrix")) m <- as.matrix(m)

  tg <- .sctenifold_pick_target(m, target_gene)
  rr <- .sctenifold_rank_from_expr(m, tg, top_genes = top_genes)

  emb <- .sctenifold_embed_cells(sobj)
  out <- list(
    assay = dat$assay,
    target_gene = tg,
    emb = emb,
    target_expr = rr$target_expr,
    rank = rr$rank,
    volcano = data.frame(gene = rr$rank$gene, effect = rr$rank$score, nlp = -log10(pmax(abs(rr$rank$score), 1e-8)), stringsAsFactors = FALSE)
  )

  if (nzchar(group_col) && (group_col %in% colnames(sobj@meta.data))) {
    grp <- as.character(sobj@meta.data[[group_col]])
    lv <- unique(grp)
    impact <- sapply(lv, function(gl) {
      jj <- which(grp == gl)
      if (!length(jj)) return(0)
      mean(abs(rr$target_expr[jj]), na.rm = TRUE)
    })
    out$pathway_like <- data.frame(name = lv, score = as.numeric(impact), stringsAsFactors = FALSE)
  } else {
    out$pathway_like <- data.frame(name = rr$rank$gene, score = abs(rr$rank$score), stringsAsFactors = FALSE)
  }

  out
}

.sctenifold_parse_shift <- function(ma, top_n = 100L) {
  if (is.null(ma) || !is.matrix(ma)) return(data.frame(gene = character(0), wt1 = numeric(0), wt2 = numeric(0), ko1 = numeric(0), ko2 = numeric(0), shift = numeric(0), stringsAsFactors = FALSE))
  xr <- grep("^X_", rownames(ma))
  yr <- grep("^Y_", rownames(ma))
  if (!length(xr) || !length(yr)) return(data.frame(gene = character(0), wt1 = numeric(0), wt2 = numeric(0), ko1 = numeric(0), ko2 = numeric(0), shift = numeric(0), stringsAsFactors = FALSE))

  gx <- gsub("^X_", "", rownames(ma)[xr])
  gy <- gsub("^Y_", "", rownames(ma)[yr])
  g <- intersect(gx, gy)
  if (!length(g)) return(data.frame(gene = character(0), wt1 = numeric(0), wt2 = numeric(0), ko1 = numeric(0), ko2 = numeric(0), shift = numeric(0), stringsAsFactors = FALSE))

  x_map <- setNames(xr[match(g, gx)], g)
  y_map <- setNames(yr[match(g, gy)], g)

  wt <- ma[x_map, , drop = FALSE]
  ko <- ma[y_map, , drop = FALSE]
  if (ncol(wt) < 2L) {
    wt <- cbind(wt, 0)
    ko <- cbind(ko, 0)
  }

  out <- data.frame(
    gene = g,
    wt1 = as.numeric(wt[, 1]),
    wt2 = as.numeric(wt[, 2]),
    ko1 = as.numeric(ko[, 1]),
    ko2 = as.numeric(ko[, 2]),
    stringsAsFactors = FALSE
  )
  out$shift <- sqrt((out$ko1 - out$wt1)^2 + (out$ko2 - out$wt2)^2)
  out <- out[order(out$shift, decreasing = TRUE), , drop = FALSE]
  utils::head(out, max(20L, as.integer(top_n)))
}

.sctenifold_enrichment <- function(genes, n_terms = 20L) {
  genes <- unique(as.character(genes))
  genes <- genes[nzchar(genes)]
  if (!length(genes)) return(data.frame(name = character(0), score = numeric(0), stringsAsFactors = FALSE))
  if (!requireNamespace("enrichR", quietly = TRUE)) {
    return(data.frame(name = character(0), score = numeric(0), stringsAsFactors = FALSE))
  }

  dbs <- c("KEGG_2019_Human", "WikiPathways_2019_Human", "Reactome_2016")
  rr <- tryCatch(enrichR::enrichr(genes, dbs), error = function(e) NULL)
  if (is.null(rr) || !length(rr)) return(data.frame(name = character(0), score = numeric(0), stringsAsFactors = FALSE))

  out <- do.call(rbind, lapply(names(rr), function(nm) {
    tb <- rr[[nm]]
    if (is.null(tb) || !nrow(tb)) return(NULL)
    data.frame(
      name = paste0(nm, ": ", as.character(tb$Term)),
      score = -log10(pmax(as.numeric(tb$Adjusted.P.value), 1e-300)),
      stringsAsFactors = FALSE
    )
  }))

  if (is.null(out) || !nrow(out)) return(data.frame(name = character(0), score = numeric(0), stringsAsFactors = FALSE))
  out <- out[is.finite(out$score), , drop = FALSE]
  out <- out[order(out$score, decreasing = TRUE), , drop = FALSE]
  utils::head(out, max(5L, as.integer(n_terms)))
}

sctenifold_beta_run <- function(
  sobj,
  target_gene,
  nsubsamp = 80L,
  top_genes = 30L,
  assay = NULL,
  qc = TRUE,
  qc_minLSize = 1000L,
  qc_minCells = 25L,
  max_cells = 3000L,
  ncores = 1L
) {
  if (!requireNamespace("scTenifoldKnk", quietly = TRUE)) stop("Package 'scTenifoldKnk' is not available in the active environment.")
  if (!inherits(sobj, "Seurat")) stop("Input object must be a Seurat object.")

  cnt <- .sctenifold_get_data(sobj, assay = assay, pref = c("counts", "data"))
  m <- cnt$matrix
  if (!inherits(m, "matrix")) m <- as.matrix(m)

  tg <- .sctenifold_pick_target(m, target_gene)

  nc <- ncol(m)
  if (is.finite(max_cells) && max_cells > 0L && nc > max_cells) {
    set.seed(1)
    keep <- sample(colnames(m), max_cells)
    m <- m[, keep, drop = FALSE]
  }

  m <- m[rowSums(m) > 0, , drop = FALSE]
  if (!(tg %in% rownames(m))) stop("Target gene was dropped after filtering/subsampling.")

  res <- scTenifoldKnk::scTenifoldKnk(
    countMatrix = m,
    qc = isTRUE(qc),
    gKO = tg,
    qc_minLSize = max(0L, as.integer(qc_minLSize %||% 1000L)),
    qc_minCells = max(1L, as.integer(qc_minCells %||% 25L)),
    nc_nNet = max(2L, as.integer(nsubsamp %||% 80L)),
    nCores = max(1L, as.integer(ncores %||% 1L))
  )

  .safe_df <- function(x) {
    if (is.null(x)) return(data.frame())
    tryCatch(as.data.frame(x), error = function(e) data.frame())
  }
  dr <- .safe_df(res$diffRegulation)
  if (!nrow(dr)) stop("scTenifoldKnk did not return diffRegulation results.")

  if (!"gene" %in% colnames(dr)) dr$gene <- rownames(dr)
  if (!"distance" %in% colnames(dr)) dr$distance <- 0
  if (!"p.adj" %in% colnames(dr)) dr$p.adj <- if ("p.value" %in% colnames(dr)) stats::p.adjust(dr$p.value, method = "fdr") else 1

  dr <- dr[order(dr$distance, decreasing = TRUE), , drop = FALSE]

  shift_df <- .sctenifold_parse_shift(res$manifoldAlignment, top_n = max(50L, as.integer(top_genes) * 5L))

  rank <- data.frame(
    gene = as.character(dr$gene),
    score = as.numeric(dr$distance),
    stringsAsFactors = FALSE
  )
  rank <- rank[is.finite(rank$score), , drop = FALSE]
  rank <- utils::head(rank, max(10L, as.integer(top_genes)))

  volcano <- data.frame(
    gene = as.character(dr$gene),
    effect = as.numeric(dr$distance),
    nlp = -log10(pmax(as.numeric(dr$p.adj), 1e-300)),
    stringsAsFactors = FALSE
  )
  volcano <- volcano[is.finite(volcano$effect) & is.finite(volcano$nlp), , drop = FALSE]

  pathway_like <- .sctenifold_enrichment(rank$gene, n_terms = 20L)
  if (!nrow(pathway_like)) {
    pathway_like <- data.frame(
      name = rank$gene,
      score = abs(rank$score),
      stringsAsFactors = FALSE
    )
  }

  list(
    assay = cnt$assay,
    target_gene = tg,
    shift_df = shift_df,
    rank = rank,
    volcano = volcano,
    pathway_like = pathway_like,
    raw_result = res
  )
}
