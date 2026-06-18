# scenic_core.R

`%||%` <- function(a, b) if (is.null(a)) b else a

scenic_beta_object_names <- function(shared_data) {
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

scenic_beta_get_object <- function(shared_data, object_name = NULL) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm0 in names(reg_flt)) if (is.null(reg[[nm0]])) reg[[nm0]] <- reg_flt[[nm0]]

  valid_nms <- scenic_beta_object_names(shared_data)
  nm <- as.character(object_name %||% "")
  if (!nzchar(nm)) nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
  if (!nzchar(nm) || !(nm %in% valid_nms)) nm <- if (length(valid_nms)) valid_nms[[1]] else ""
  if (!nzchar(nm) || !(nm %in% names(reg))) return(NULL)

  x <- reg[[nm]]
  obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
  if (!inherits(obj, "Seurat")) return(NULL)
  obj
}

scenic_beta_meta_cols <- function(sobj) {
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
      # Keep low-cardinality numeric metadata (encoded groups), drop continuous fields (e.g. nCount_RNA).
      return(nu <= max(30L, floor(0.2 * length(v))))
    }
    TRUE
  }, logical(1))
  cols[keep]
}

scenic_beta_default_group <- function(cols) {
  p <- c("seurat_clusters", "celltype", "orig.ident", "sample", "condition", "batch")
  h <- intersect(p, cols)
  if (length(h)) h[[1]] else if (length(cols)) cols[[1]] else ""
}

scenic_beta_assays <- function(sobj) {
  aa <- tryCatch(names(sobj@assays), error = function(e) character(0))
  aa[nzchar(aa)]
}

scenic_beta_default_assay <- function(sobj) {
  aa <- scenic_beta_assays(sobj)
  if (!length(aa)) return("")
  if ("RNA" %in% aa) return("RNA")
  da <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "")
  if (nzchar(da) && da %in% aa) return(da)
  aa[[1]]
}

scenic_beta_project_root <- function() {
  wd <- normalizePath(getwd(), winslash = "/", mustWork = FALSE)
  cands <- unique(c(
    wd,
    dirname(wd),
    dirname(dirname(wd))
  ))
  hit <- cands[file.exists(file.path(cands, "Content", "app.R"))]
  if (length(hit)) return(hit[[1]])
  dirname(wd)
}

scenic_beta_python_env_root <- function() {
  root <- trimws(Sys.getenv("WANLAB_PY_ENV_ROOT", ""))
  if (nzchar(root)) return(normalizePath(root, winslash = "/", mustWork = FALSE))
  file.path(scenic_beta_project_root(), "python_envs")
}

scenic_beta_pyscenic_env <- function() file.path(scenic_beta_python_env_root(), "pyscenic")

scenic_beta_pyscenic_bin <- function() {
  env <- scenic_beta_pyscenic_env()
  if (.Platform$OS.type == "windows") {
    file.path(env, "Scripts", "pyscenic.exe")
  } else {
    file.path(env, "bin", "pyscenic")
  }
}

scenic_beta_resources_root <- function() {
  file.path(scenic_beta_python_env_root(), "pyscenic_resources")
}

scenic_beta_db_manifest <- function(species = "hg38") {
  species <- tolower(trimws(species %||% "hg38"))
  if (identical(species, "mm10")) {
    base <- "https://resources.aertslab.org/cistarget/databases/mus_musculus/mm10/refseq_r80/mc_v10_clust/gene_based"
    motif <- "https://resources.aertslab.org/cistarget/motif2tf/motifs-v10nr_clust-nr.mgi-m0.001-o0.0.tbl"
    tf_list <- "https://resources.aertslab.org/cistarget/tf_lists/allTFs_mm.txt"
    files <- list(
      list(file = "mm10_10kbp_up_10kbp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather", url = paste0(base, "/mm10_10kbp_up_10kbp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather"), size_mb = 226),
      list(file = "mm10_500bp_up_100bp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather", url = paste0(base, "/mm10_500bp_up_100bp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather"), size_mb = 227),
      list(file = "motifs-v10nr_clust-nr.mgi-m0.001-o0.0.tbl", url = motif, size_mb = 95),
      list(file = "allTFs_mm.txt", url = tf_list, size_mb = 1)
    )
  } else {
    base <- "https://resources.aertslab.org/cistarget/databases/homo_sapiens/hg38/refseq_r80/mc_v10_clust/gene_based"
    motif <- "https://resources.aertslab.org/cistarget/motif2tf/motifs-v10nr_clust-nr.hgnc-m0.001-o0.0.tbl"
    tf_list <- "https://resources.aertslab.org/cistarget/tf_lists/allTFs_hg38.txt"
    files <- list(
      list(file = "hg38_10kbp_up_10kbp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather", url = paste0(base, "/hg38_10kbp_up_10kbp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather"), size_mb = 297),
      list(file = "hg38_500bp_up_100bp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather", url = paste0(base, "/hg38_500bp_up_100bp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather"), size_mb = 298),
      list(file = "motifs-v10nr_clust-nr.hgnc-m0.001-o0.0.tbl", url = motif, size_mb = 95),
      list(file = "allTFs_hg38.txt", url = tf_list, size_mb = 1)
    )
  }
  files
}

scenic_beta_db_dir <- function(species = "hg38") {
  dir <- file.path(scenic_beta_resources_root(), tolower(trimws(species %||% "hg38")))
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  dir
}

scenic_beta_db_status <- function(species = "hg38") {
  spec <- scenic_beta_db_manifest(species)
  ddir <- scenic_beta_db_dir(species)
  local_paths <- vapply(spec, function(x) file.path(ddir, x$file), character(1))
  exists <- file.exists(local_paths)
  sizes <- vapply(spec, function(x) as.numeric(x$size_mb), numeric(1))
  list(
    species = tolower(species),
    db_dir = ddir,
    total_mb = sum(sizes),
    complete = all(exists),
    files = data.frame(
      file = vapply(spec, function(x) x$file, character(1)),
      url = vapply(spec, function(x) x$url, character(1)),
      size_mb = sizes,
      local_path = local_paths,
      exists = exists,
      stringsAsFactors = FALSE
    )
  )
}

scenic_beta_download_db <- function(species = "hg38", progress = NULL) {
  st <- scenic_beta_db_status(species)
  todo <- st$files[!st$files$exists, , drop = FALSE]
  if (!nrow(todo)) return(scenic_beta_db_status(species))
  for (i in seq_len(nrow(todo))) {
    row <- todo[i, , drop = FALSE]
    if (is.function(progress)) progress(sprintf("Downloading %s (%s MB)", row$file[[1]], as.integer(row$size_mb[[1]])))
    utils::download.file(url = row$url[[1]], destfile = row$local_path[[1]], mode = "wb", quiet = FALSE)
    fi <- suppressWarnings(file.info(row$local_path[[1]]))
    if (!isTRUE(file.exists(row$local_path[[1]])) || is.na(fi$size) || fi$size <= 0) {
      stop("Download failed or empty file: ", row$file[[1]])
    }
  }
  scenic_beta_db_status(species)
}

scenic_beta_python_status <- function() {
  pyscenic <- scenic_beta_pyscenic_bin()
  py_env <- scenic_beta_pyscenic_env()
  py_bin <- if (.Platform$OS.type == "windows") file.path(py_env, "Scripts", "python.exe") else file.path(py_env, "bin", "python")
  list(
    env_dir = py_env,
    pyscenic_bin = pyscenic,
    python_bin = py_bin,
    pyscenic_exists = file.exists(pyscenic),
    python_exists = file.exists(py_bin)
  )
}

scenic_beta_expr_matrix <- function(sobj, assay = NULL, max_cells = 3000L, max_genes = 4000L) {
  aa <- scenic_beta_assays(sobj)
  assay_use <- as.character(assay %||% "")
  if (!nzchar(assay_use) || !(assay_use %in% aa)) assay_use <- scenic_beta_default_assay(sobj)
  if (!nzchar(assay_use)) stop("Could not determine assay for pySCENIC input.")
  Seurat::DefaultAssay(sobj) <- assay_use

  m <- tryCatch(Seurat::GetAssayData(sobj, assay = assay_use, layer = "counts"), error = function(e) NULL)
  if (is.null(m)) m <- tryCatch(Seurat::GetAssayData(sobj, assay = assay_use, slot = "counts"), error = function(e) NULL)
  if (is.null(m)) m <- tryCatch(Seurat::GetAssayData(sobj, assay = assay_use, layer = "data"), error = function(e) NULL)
  if (is.null(m)) m <- tryCatch(Seurat::GetAssayData(sobj, assay = assay_use, slot = "data"), error = function(e) NULL)
  if (is.null(m)) stop("Could not read assay matrix for pySCENIC input.")

  nc <- ncol(m)
  if (is.finite(max_cells) && max_cells > 0L && nc > max_cells) {
    set.seed(1)
    keep <- sample(colnames(m), max_cells)
    m <- m[, keep, drop = FALSE]
  }

  vf <- tryCatch(Seurat::VariableFeatures(sobj), error = function(e) character(0))
  if (!length(vf)) vf <- rownames(m)
  vf <- intersect(vf, rownames(m))
  if (is.finite(max_genes) && max_genes > 0L) vf <- vf[seq_len(min(length(vf), max_genes))]
  if (!length(vf)) stop("No genes available after pySCENIC input filtering.")

  m <- m[vf, , drop = FALSE]
  x <- as.matrix(Matrix::t(m))
  storage.mode(x) <- "numeric"
  list(matrix = x, assay = assay_use)
}

scenic_beta_prepare_inputs <- function(sobj, species = "hg38", assay = NULL, max_cells = 3000L, max_genes = 4000L) {
  st <- scenic_beta_db_status(species)
  if (!isTRUE(st$complete)) {
    missing <- st$files$file[!st$files$exists]
    stop("pySCENIC DB files are missing. Download first: ", paste(missing, collapse = ", "))
  }
  prj <- scenic_beta_project_root()
  run_dir <- file.path(prj, "python_envs", "pyscenic_runs", format(Sys.time(), "%Y%m%d_%H%M%S"))
  dir.create(run_dir, recursive = TRUE, showWarnings = FALSE)

  expr_info <- scenic_beta_expr_matrix(sobj, assay = assay, max_cells = max_cells, max_genes = max_genes)
  expr <- expr_info$matrix
  expr_file <- file.path(run_dir, "expr.tsv")
  utils::write.table(expr, file = expr_file, sep = "\t", quote = FALSE, col.names = NA)

  db_files <- st$files$local_path[grepl("\\.feather$", st$files$file, ignore.case = TRUE)]
  motif_file <- st$files$local_path[grepl("\\.tbl$", st$files$file, ignore.case = TRUE)][1]
  tf_file <- st$files$local_path[grepl("^allTFs_.*\\.txt$", st$files$file)]
  if (!length(tf_file)) tf_file <- st$files$local_path[grepl("allTFs", st$files$file)][1]

  list(
    run_dir = run_dir,
    expr_file = expr_file,
    adj_file = file.path(run_dir, "adj.tsv"),
    regulons_file = file.path(run_dir, "regulons.csv"),
    auc_file = file.path(run_dir, "aucell.csv"),
    db_files = db_files,
    motif_file = motif_file,
    tf_file = tf_file,
    cell_names = rownames(expr),
    assay = expr_info$assay
  )
}

scenic_beta_run_cmd <- function(bin, args, wd = NULL) {
  out <- NULL
  if (!is.null(wd) && nzchar(as.character(wd))) {
    old <- getwd()
    on.exit(setwd(old), add = TRUE)
    setwd(wd)
  }
  out <- system2(bin, args = args, stdout = TRUE, stderr = TRUE, wait = TRUE)
  status <- attr(out, "status")
  if (is.null(status)) status <- 0L
  if (!identical(as.integer(status), 0L)) {
    tail_msg <- paste(utils::tail(out, 20), collapse = "\n")
    stop("pySCENIC command failed (status=", status, ").\n", tail_msg)
  }
  invisible(out)
}

scenic_beta_run_full <- function(
  sobj,
  group_col,
  tf_gene = "",
  species = "hg38",
  assay = NULL,
  n_workers = 4L,
  max_cells = 3000L,
  max_genes = 4000L,
  top_regulons = 15L,
  edge_n = 60L
) {
  if (!(group_col %in% colnames(sobj@meta.data))) stop("Group column not found in metadata.")
  py <- scenic_beta_python_status()
  if (!isTRUE(py$pyscenic_exists)) stop("pySCENIC CLI not found in managed env: ", py$pyscenic_bin)

  inp <- scenic_beta_prepare_inputs(sobj, species = species, assay = assay, max_cells = max_cells, max_genes = max_genes)
  nw <- as.integer(max(1L, n_workers))

  scenic_beta_run_cmd(
    py$pyscenic_bin,
    c("grn", inp$expr_file, inp$tf_file, "-o", inp$adj_file, "--num_workers", nw),
    wd = inp$run_dir
  )

  scenic_beta_run_cmd(
    py$pyscenic_bin,
    c(
      "ctx",
      inp$adj_file,
      inp$db_files,
      "--annotations_fname", inp$motif_file,
      "--expression_mtx_fname", inp$expr_file,
      "--output", inp$regulons_file,
      "--num_workers", nw
    ),
    wd = inp$run_dir
  )

  scenic_beta_run_cmd(
    py$pyscenic_bin,
    c("aucell", inp$expr_file, inp$regulons_file, "-o", inp$auc_file, "--num_workers", nw),
    wd = inp$run_dir
  )

  scenic_beta_collect_outputs(
    sobj = sobj,
    group_col = group_col,
    tf_gene = tf_gene,
    top_regulons = top_regulons,
    edge_n = edge_n,
    run_dir = inp$run_dir,
    auc_file = inp$auc_file,
    adj_file = inp$adj_file,
    assay = inp$assay
  )
}

scenic_beta_collect_outputs <- function(
  sobj,
  group_col,
  tf_gene = "",
  top_regulons = 15L,
  edge_n = 60L,
  run_dir = "",
  auc_file = "",
  adj_file = "",
  assay = NULL
) {
  aa <- scenic_beta_assays(sobj)
  assay_use <- as.character(assay %||% "")
  if (!nzchar(assay_use) || !(assay_use %in% aa)) assay_use <- scenic_beta_default_assay(sobj)
  if (nzchar(assay_use)) {
    try(Seurat::DefaultAssay(sobj) <- assay_use, silent = TRUE)
  }

  md <- sobj@meta.data
  groups <- as.character(md[[group_col]])
  names(groups) <- rownames(md)
  groups[is.na(groups) | !nzchar(groups)] <- "Unknown"

  reds <- names(sobj@reductions)
  red <- reds[tolower(reds) == "umap"][1] %||% reds[[1]]
  emb <- Seurat::Embeddings(sobj, red)
  emb_df <- data.frame(cell = rownames(emb), x = emb[, 1], y = emb[, 2], stringsAsFactors = FALSE)

  auc <- utils::read.csv(auc_file, row.names = 1, check.names = FALSE)
  auc <- as.matrix(auc)
  common_cells <- intersect(rownames(auc), emb_df$cell)
  if (!length(common_cells)) {
    common_cells <- intersect(colnames(auc), emb_df$cell)
    if (length(common_cells)) auc <- t(auc)
  }
  common_cells <- intersect(rownames(auc), emb_df$cell)
  if (!length(common_cells)) stop("Could not align AUCell output with Seurat cells.")
  auc <- auc[common_cells, , drop = FALSE]

  emb_df <- emb_df[match(common_cells, emb_df$cell), , drop = FALSE]
  grp <- groups[common_cells]

  reg_names <- colnames(auc)
  if (!length(reg_names)) stop("No regulons found in AUCell matrix.")
  tf_in <- trimws(tf_gene %||% "")
  pick <- NA_integer_
  if (nzchar(tf_in)) {
    hit <- grep(paste0("^", gsub("([.|()\\[\\]{}+*?^$\\\\])", "\\\\\\1", tf_in), "(\\b|\\()"), reg_names, ignore.case = TRUE)
    if (length(hit)) pick <- hit[[1]]
  }
  if (is.na(pick)) pick <- 1L
  tf_reg <- reg_names[[pick]]
  tf_auc <- as.numeric(auc[, pick])

  glev <- unique(grp)
  reg_ord <- order(apply(auc, 2, function(x) stats::sd(as.numeric(x), na.rm = TRUE)), decreasing = TRUE)
  reg_take <- reg_names[reg_ord[seq_len(min(as.integer(top_regulons), length(reg_ord)))]]
  heat <- sapply(glev, function(gl) {
    ii <- which(grp == gl)
    if (!length(ii)) return(rep(0, length(reg_take)))
    colMeans(auc[ii, reg_take, drop = FALSE], na.rm = TRUE)
  })
  if (is.null(dim(heat))) heat <- matrix(heat, nrow = length(reg_take))
  rownames(heat) <- reg_take
  colnames(heat) <- glev

  rss_score <- apply(auc, 2, function(x) {
    ss <- tapply(as.numeric(x), grp, mean, na.rm = TRUE)
    max(ss, na.rm = TRUE) - min(ss, na.rm = TRUE)
  })
  rss_score[is.na(rss_score)] <- 0
  rss_ord <- order(rss_score, decreasing = TRUE)
  rss <- data.frame(
    regulon = names(rss_score)[rss_ord[seq_len(min(20, length(rss_ord)))]],
    score = as.numeric(rss_score[rss_ord[seq_len(min(20, length(rss_ord)))] ]),
    stringsAsFactors = FALSE
  )

  adj <- utils::read.delim(adj_file, check.names = FALSE, stringsAsFactors = FALSE)
  nms <- tolower(colnames(adj))
  tf_col <- colnames(adj)[match(TRUE, nms %in% c("tf", "regulator", "source"))]
  tg_col <- colnames(adj)[match(TRUE, nms %in% c("target", "targetgene", "gene", "target_genes"))]
  sc_col <- colnames(adj)[match(TRUE, nms %in% c("importance", "weight", "score"))]
  if (is.na(tf_col) || is.na(tg_col)) stop("Unexpected GRN adjacency format.")
  if (is.na(sc_col)) {
    sc_col <- tg_col
    adj[[sc_col]] <- 1
  }
  adj_tf <- adj[tolower(adj[[tf_col]]) == tolower(tf_in %||% tf_reg), , drop = FALSE]
  if (!nrow(adj_tf)) adj_tf <- adj[tolower(adj[[tf_col]]) == tolower(gsub("\\(.*$", "", tf_reg)), , drop = FALSE]
  if (!nrow(adj_tf)) adj_tf <- adj
  adj_tf <- adj_tf[order(adj_tf[[sc_col]], decreasing = TRUE), , drop = FALSE]
  adj_tf <- adj_tf[seq_len(min(as.integer(edge_n), nrow(adj_tf))), , drop = FALSE]
  target_rank <- data.frame(
    gene = as.character(adj_tf[[tg_col]]),
    score = as.numeric(adj_tf[[sc_col]]),
    stringsAsFactors = FALSE
  )

  list(
    assay = assay_use,
    tf_gene = gsub("\\(.*$", "", tf_reg),
    tf_regulon = tf_reg,
    emb = emb_df[, c("x", "y"), drop = FALSE],
    tf_expr = tf_auc,
    groups = grp,
    heat = heat,
    rss = rss,
    target_rank = target_rank,
    run_dir = run_dir
  )
}

scenic_beta_preview <- function(sobj, group_col, tf_gene = "", top_regulons = 15L, edge_n = 60L, assay = NULL) {
  # Fast fallback preview (no pySCENIC run) used for initial rendering.
  md <- sobj@meta.data
  if (!(group_col %in% colnames(md))) stop("Group column not found in metadata.")
  aa <- scenic_beta_assays(sobj)
  assay_use <- as.character(assay %||% "")
  if (!nzchar(assay_use) || !(assay_use %in% aa)) assay_use <- scenic_beta_default_assay(sobj)
  if (nzchar(assay_use)) {
    try(Seurat::DefaultAssay(sobj) <- assay_use, silent = TRUE)
  }
  reds <- names(sobj@reductions)
  red <- reds[tolower(reds) == "umap"][1] %||% reds[[1]]
  emb <- Seurat::Embeddings(sobj, red)
  m <- tryCatch(Seurat::GetAssayData(sobj, assay = assay_use, layer = "data"), error = function(e) NULL)
  if (is.null(m)) m <- tryCatch(Seurat::GetAssayData(sobj, assay = assay_use, slot = "data"), error = function(e) NULL)
  if (is.null(m)) m <- tryCatch(Seurat::GetAssayData(sobj, assay = assay_use, layer = "counts"), error = function(e) NULL)
  if (is.null(m)) m <- tryCatch(Seurat::GetAssayData(sobj, assay = assay_use, slot = "counts"), error = function(e) NULL)
  if (is.null(m)) stop("Could not read assay data.")

  genes <- rownames(m)
  idx_tf <- match(tolower(tf_gene), tolower(genes))
  if (is.na(idx_tf)) {
    vf <- tryCatch(Seurat::VariableFeatures(sobj), error = function(e) character(0))
    tf_gene <- vf[[1]] %||% genes[[1]]
    idx_tf <- match(tolower(tf_gene), tolower(genes))
  }
  tf_expr <- as.numeric(m[idx_tf, ])
  vf <- tryCatch(Seurat::VariableFeatures(sobj), error = function(e) character(0))
  if (!length(vf)) vf <- genes
  vf <- vf[seq_len(min(max(20L, as.integer(top_regulons)), length(vf)))]

  groups <- as.character(md[[group_col]])
  if (length(unique(groups[!is.na(groups)])) > 80L) {
    stop("Selected group column has too many unique values (>80). Choose a categorical metadata column (e.g., seurat_clusters/celltype/sample).")
  }
  levels <- unique(groups)
  heat <- sapply(levels, function(gl) {
    ii <- which(groups == gl)
    if (!length(ii)) return(rep(0, length(vf)))
    Matrix::rowMeans(m[vf, ii, drop = FALSE])
  })
  if (is.null(dim(heat))) heat <- matrix(heat, nrow = length(vf))
  rownames(heat) <- vf
  colnames(heat) <- levels

  corv <- apply(as.matrix(m[vf, , drop = FALSE]), 1, function(v) suppressWarnings(stats::cor(as.numeric(v), tf_expr, use = "pairwise.complete.obs")))
  corv[is.na(corv)] <- 0
  ord <- order(abs(corv), decreasing = TRUE)
  ord <- ord[seq_len(min(as.integer(edge_n), length(ord)))]

  list(
    assay = assay_use,
    tf_gene = tf_gene,
    tf_regulon = tf_gene,
    emb = data.frame(x = emb[, 1], y = emb[, 2], stringsAsFactors = FALSE),
    tf_expr = tf_expr,
    groups = groups,
    heat = heat,
    rss = data.frame(regulon = names(sort(abs(corv), decreasing = TRUE))[seq_len(min(20, length(corv)))], score = sort(abs(corv), decreasing = TRUE)[seq_len(min(20, length(corv)))], stringsAsFactors = FALSE),
    target_rank = data.frame(gene = names(corv)[ord], score = as.numeric(corv[ord]), stringsAsFactors = FALSE),
    run_dir = ""
  )
}
