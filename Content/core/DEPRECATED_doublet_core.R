# DEPRECATED FILE
# This file is no longer used by app routing.
# Use versioned core modules instead:
# - core/seurat_v4/*
# - core/seurat_v5/*
# Kept only for historical reference.

# doublet_core.R
# Doublet step core entry point: app-safe functions + standalone RStudio execution.

# ------------------------------
# Standalone knobs (RStudio)
# ------------------------------
# Set TRUE, then select-all-and-run this file in RStudio.
DOUBLET_CORE_AUTORUN <- FALSE

# Name of in-memory Seurat object in .GlobalEnv.
DOUBLET_CORE_INPUT_OBJECT_NAME <- "seurat_obj"

# Optional: explicit object passed directly when calling core_run_doublet_step().
DOUBLET_CORE_INPUT_OBJECT <- NULL

# Include scDblFinder auto run.
DOUBLET_CORE_INCLUDE_AUTO <- TRUE

# DBR grid.
DOUBLET_CORE_DBR_MIN <- 0.05
DOUBLET_CORE_DBR_MAX <- 0.20
DOUBLET_CORE_DBR_STEP <- 0.05

# scDblFinder run params.
DOUBLET_CORE_DIMS <- 30
DOUBLET_CORE_SEED <- 777

# Optional quick UMAP cache into meta.data.
DOUBLET_CORE_CACHE_UMAP <- TRUE
DOUBLET_CORE_UMAP_DIMS_FAST <- 20
DOUBLET_CORE_UMAP_NEIGHBORS <- 15
DOUBLET_CORE_UMAP_MIN_DIST <- 0.30

# Result object name written to .GlobalEnv when autorun is enabled.
DOUBLET_CORE_OUTPUT_OBJECT_NAME <- "doublet_core_result"


# ------------------------------
# Internal helpers
# ------------------------------
`%||%` <- function(a, b) if (is.null(a)) b else a

.core_doublet_require_pkgs <- function() {
  req <- c("Seurat", "scDblFinder", "SingleCellExperiment", "SummarizedExperiment")
  miss <- req[!vapply(req, requireNamespace, logical(1), quietly = TRUE)]
  if (length(miss)) {
    stop("Missing required package(s): ", paste(miss, collapse = ", "))
  }
}

.core_doublet_dbr_tag <- function(d) sprintf("%03d", as.integer(round(as.numeric(d) * 100)))
.core_doublet_col_class_dbr <- function(d) paste0("DF.class_dbr", .core_doublet_dbr_tag(d))
.core_doublet_col_score_dbr <- function(d) paste0("DF.score_dbr", .core_doublet_dbr_tag(d))
.core_doublet_col_class_auto <- function() "DF.class_auto"

.core_doublet_sample_col <- function(md) {
  if ("sample" %in% names(md)) "sample" else "orig.ident"
}

.core_doublet_rates <- function(dbr_min = 0.05, dbr_max = 0.20, dbr_step = 0.05) {
  r <- seq(dbr_min, dbr_max, by = dbr_step)
  r <- r[is.finite(r) & r > 0 & r < 1]
  unique(round(r, 6))
}

.core_doublet_collect_summary <- function(md) {
  cls_cols <- grep("^DF\\.class_(?:dbr\\d+|auto)$", colnames(md), value = TRUE)
  if (!length(cls_cols)) return(data.frame())
  do.call(rbind, lapply(cls_cols, function(cl) {
    tag <- sub("^DF\\.class_", "", cl)
    dbr <- if (tag == "auto") NA_real_ else as.numeric(sub("^dbr", "", tag)) / 100
    vals <- as.character(md[[cl]])
    n_tot <- sum(!is.na(vals))
    n_dbl <- sum(tolower(vals) == "doublet", na.rm = TRUE)
    rate <- if (n_tot > 0) n_dbl / n_tot else NA_real_
    data.frame(tag = tag, dbr = dbr, observed_rate = rate, stringsAsFactors = FALSE)
  }))
}

.core_doublet_update_registry <- function(so, dbr_runs, has_auto, seed, sample_col) {
  if (is.null(so@misc$scDblFinder)) so@misc$scDblFinder <- list()
  so@misc$scDblFinder$dbr_runs <- sort(unique(as.numeric(dbr_runs)))
  so@misc$scDblFinder$has_auto <- isTRUE(has_auto)
  so@misc$scDblFinder$timestamp <- Sys.time()
  so@misc$scDblFinder$version <- tryCatch(as.character(utils::packageVersion("scDblFinder")), error = function(e) NA_character_)
  so@misc$scDblFinder$seed <- seed
  so@misc$scDblFinder$sample_col <- sample_col
  so
}

.core_doublet_cache_umap_into_meta <- function(seu, dims_fast = 20, n_neighbors = 15, min_dist = 0.30) {
  if (all(c("UMAP1_quick", "UMAP2_quick") %in% colnames(seu@meta.data))) return(seu)

  ok_uwot <- requireNamespace("uwot", quietly = TRUE)
  emb <- NULL

  if (!is.null(seu@reductions$umap)) {
    emb <- Seurat::Embeddings(seu, "umap")
  } else if (!is.null(seu@reductions$pca)) {
    pcs <- Seurat::Embeddings(seu, "pca")
    k <- min(dims_fast, ncol(pcs))
    mat <- pcs[, seq_len(k), drop = FALSE]
    if (ok_uwot) {
      set.seed(777)
      emb <- uwot::umap(mat, n_neighbors = n_neighbors, min_dist = min_dist,
                        verbose = FALSE, ret_model = FALSE, fast_sgd = TRUE)
      rownames(emb) <- rownames(mat)
      colnames(emb) <- c("UMAP_1", "UMAP_2")
    } else {
      seu <- Seurat::RunUMAP(seu, reduction = "pca", dims = seq_len(k), verbose = FALSE)
      emb <- Seurat::Embeddings(seu, "umap")
    }
  } else {
    def_assay <- Seurat::DefaultAssay(seu)
    if ("integrated" %in% names(seu@assays)) Seurat::DefaultAssay(seu) <- "integrated"
    seu <- Seurat::NormalizeData(seu, verbose = FALSE)
    seu <- Seurat::FindVariableFeatures(seu, verbose = FALSE)
    seu <- Seurat::ScaleData(seu, verbose = FALSE)
    seu <- Seurat::RunPCA(seu, npcs = max(20, dims_fast), verbose = FALSE)
    Seurat::DefaultAssay(seu) <- def_assay

    pcs <- Seurat::Embeddings(seu, "pca")
    k <- min(dims_fast, ncol(pcs))
    mat <- pcs[, seq_len(k), drop = FALSE]
    if (ok_uwot) {
      set.seed(777)
      emb <- uwot::umap(mat, n_neighbors = n_neighbors, min_dist = min_dist,
                        verbose = FALSE, ret_model = FALSE, fast_sgd = TRUE)
      rownames(emb) <- rownames(mat)
      colnames(emb) <- c("UMAP_1", "UMAP_2")
    } else {
      seu <- Seurat::RunUMAP(seu, reduction = "pca", dims = seq_len(k), verbose = FALSE)
      emb <- Seurat::Embeddings(seu, "umap")
    }
  }

  seu@misc$umap_quick <- emb
  emb <- emb[colnames(seu), , drop = FALSE]
  seu@meta.data$UMAP1_quick <- emb[, 1]
  seu@meta.data$UMAP2_quick <- emb[, 2]
  seu
}

.core_doublet_run_one_dbr <- function(seu, dbr = NULL, dims = 30) {
  md <- seu@meta.data
  sample_col <- .core_doublet_sample_col(md)
  samp_vec <- as.character(md[[sample_col]])
  samples <- sort(unique(samp_vec[!is.na(samp_vec)]))

  df_class <- setNames(rep(NA_character_, ncol(seu)), colnames(seu))
  df_score <- setNames(rep(NA_real_, ncol(seu)), colnames(seu))

  for (s in samples) {
    cells_s <- rownames(md)[samp_vec == s]
    sub <- subset(seu, cells = cells_s)
    sce <- try(Seurat::as.SingleCellExperiment(sub, assay = "SCT"), silent = TRUE)
    if (inherits(sce, "try-error")) sce <- Seurat::as.SingleCellExperiment(sub, assay = "RNA")

    if (is.null(dbr)) sce <- scDblFinder::scDblFinder(sce, dims = dims)
    else sce <- scDblFinder::scDblFinder(sce, dbr = dbr, dims = dims)

    lab <- as.character(SummarizedExperiment::colData(sce)$scDblFinder.class)
    scr <- as.numeric(SummarizedExperiment::colData(sce)$scDblFinder.score)
    lab <- ifelse(tolower(lab) == "doublet", "Doublet",
                  ifelse(tolower(lab) == "singlet", "Singlet", NA_character_))
    names(lab) <- colnames(sce)
    names(scr) <- colnames(sce)
    df_class[cells_s] <- lab[cells_s]
    df_score[cells_s] <- scr[cells_s]
  }

  list(class = df_class, score = df_score, sample_col = sample_col)
}


# ------------------------------
# Public API for app + script
# ------------------------------
core_run_doublet_step <- function(
  seurat_object,
  include_auto = TRUE,
  dbr_runs = NULL,
  dbr_min = 0.05,
  dbr_max = 0.20,
  dbr_step = 0.05,
  dims = 30,
  seed = 777,
  cache_umap = TRUE,
  umap_dims_fast = 20,
  umap_neighbors = 15,
  umap_min_dist = 0.30
) {
  .core_doublet_require_pkgs()
  if (!inherits(seurat_object, "Seurat")) {
    stop("seurat_object must be a Seurat object.")
  }

  rates <- if (is.null(dbr_runs)) {
    .core_doublet_rates(dbr_min = dbr_min, dbr_max = dbr_max, dbr_step = dbr_step)
  } else {
    rr <- as.numeric(dbr_runs)
    rr <- rr[is.finite(rr) & rr > 0 & rr < 1]
    unique(round(rr, 6))
  }

  if (!length(rates) && !isTRUE(include_auto)) {
    stop("No valid DBR runs. Provide dbr_runs or enable include_auto.")
  }

  set.seed(seed)
  seu <- seurat_object
  done_tags <- character(0)
  has_auto <- FALSE
  sample_col <- .core_doublet_sample_col(seu@meta.data)

  if (isTRUE(include_auto)) {
    res_auto <- .core_doublet_run_one_dbr(seu, dbr = NULL, dims = dims)
    seu@meta.data[[.core_doublet_col_class_auto()]] <- res_auto$class
    has_auto <- TRUE
    done_tags <- c(done_tags, "auto")
    sample_col <- res_auto$sample_col %||% sample_col
  }

  for (r in rates) {
    res <- .core_doublet_run_one_dbr(seu, dbr = r, dims = dims)
    cls_col <- .core_doublet_col_class_dbr(r)
    scr_col <- .core_doublet_col_score_dbr(r)
    seu@meta.data[[cls_col]] <- res$class
    seu@meta.data[[scr_col]] <- res$score
    done_tags <- c(done_tags, paste0("dbr", .core_doublet_dbr_tag(r)))
    sample_col <- res$sample_col %||% sample_col
  }

  if (isTRUE(cache_umap)) {
    seu <- .core_doublet_cache_umap_into_meta(
      seu,
      dims_fast = umap_dims_fast,
      n_neighbors = umap_neighbors,
      min_dist = umap_min_dist
    )
  }

  seu <- .core_doublet_update_registry(
    so = seu,
    dbr_runs = rates,
    has_auto = has_auto,
    seed = seed,
    sample_col = sample_col
  )

  summary_df <- .core_doublet_collect_summary(seu@meta.data)

  list(
    object = seu,
    summary = summary_df,
    dbr_runs = rates,
    has_auto = has_auto,
    done_tags = done_tags,
    sample_col = sample_col
  )
}


# ------------------------------
# Optional standalone autorun
# ------------------------------
if (isTRUE(DOUBLET_CORE_AUTORUN)) {
  seurat_obj <- DOUBLET_CORE_INPUT_OBJECT
  if (is.null(seurat_obj) && exists(DOUBLET_CORE_INPUT_OBJECT_NAME, envir = .GlobalEnv, inherits = FALSE)) {
    seurat_obj <- get(DOUBLET_CORE_INPUT_OBJECT_NAME, envir = .GlobalEnv, inherits = FALSE)
  }
  if (is.null(seurat_obj)) {
    stop("No input object found. Set DOUBLET_CORE_INPUT_OBJECT or define .GlobalEnv$", DOUBLET_CORE_INPUT_OBJECT_NAME)
  }

  result <- core_run_doublet_step(
    seurat_object = seurat_obj,
    include_auto = DOUBLET_CORE_INCLUDE_AUTO,
    dbr_min = DOUBLET_CORE_DBR_MIN,
    dbr_max = DOUBLET_CORE_DBR_MAX,
    dbr_step = DOUBLET_CORE_DBR_STEP,
    dims = DOUBLET_CORE_DIMS,
    seed = DOUBLET_CORE_SEED,
    cache_umap = DOUBLET_CORE_CACHE_UMAP,
    umap_dims_fast = DOUBLET_CORE_UMAP_DIMS_FAST,
    umap_neighbors = DOUBLET_CORE_UMAP_NEIGHBORS,
    umap_min_dist = DOUBLET_CORE_UMAP_MIN_DIST
  )

  assign(DOUBLET_CORE_OUTPUT_OBJECT_NAME, result, envir = .GlobalEnv)
  message("[doublet_core] Wrote result to .GlobalEnv$", DOUBLET_CORE_OUTPUT_OBJECT_NAME)
  message("[doublet_core] Completed tags: ", paste(result$done_tags, collapse = ", "))
}
