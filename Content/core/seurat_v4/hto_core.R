# hto_core.R (seurat_v4)
# HTO demultiplexing helpers used by interface/page_hto.R

`%||%` <- function(a, b) if (is.null(a)) b else a

core_hto_detect_assays <- function(sobj) {
  assays <- tryCatch(as.character(Seurat::Assays(sobj)), error = function(e) character(0))
  if (!length(assays)) return(character(0))
  low <- tolower(assays)
  pri <- which(grepl("hto|hash", low, perl = TRUE))
  sec <- which(grepl("adt|antibody", low, perl = TRUE))
  idx <- unique(c(pri, sec, seq_along(assays)))
  unique(assays[idx])
}

core_hto_feature_names <- function(sobj, assay) {
  f <- tryCatch(rownames(sobj[[assay]]), error = function(e) NULL)
  as.character(f %||% character(0))
}

core_hto_get_data <- function(sobj, assay, slot = "data") {
  tryCatch(Seurat::GetAssayData(sobj, assay = assay, slot = slot), error = function(e) NULL)
}

core_hto_set_data <- function(sobj, assay, mat, slot = "data") {
  out <- tryCatch(
    Seurat::SetAssayData(sobj, assay = assay, slot = slot, new.data = mat),
    error = function(e) NULL
  )
  if (is.null(out)) {
    stop("Failed to write updated HTO assay data.")
  }
  out
}

core_hto_prepare_assay <- function(sobj, assay) {
  Seurat::NormalizeData(
    object = sobj,
    assay = assay,
    normalization.method = "CLR",
    margin = 2,
    verbose = FALSE
  )
}

core_hto_preprocess_signal <- function(
  sobj,
  assay,
  slot = "data",
  background_quantile = 0,
  robust_scale = FALSE
) {
  mat <- core_hto_get_data(sobj, assay = assay, slot = slot)
  if (is.null(mat)) return(sobj)
  mm <- as.matrix(mat)
  if (!nrow(mm) || !ncol(mm)) return(sobj)

  bq <- suppressWarnings(as.numeric(background_quantile %||% 0))
  if (!is.finite(bq)) bq <- 0
  bq <- min(max(bq, 0), 0.49)
  do_scale <- isTRUE(robust_scale)

  for (i in seq_len(nrow(mm))) {
    v <- as.numeric(mm[i, ])
    if (bq > 0) {
      bg <- suppressWarnings(stats::quantile(v, probs = bq, na.rm = TRUE, names = FALSE, type = 8))
      if (!is.finite(bg)) bg <- 0
      v <- pmax(v - bg, 0)
    }
    if (do_scale) {
      s95 <- suppressWarnings(stats::quantile(v, probs = 0.95, na.rm = TRUE, names = FALSE, type = 8))
      if (is.finite(s95) && s95 > 0) {
        v <- v / s95
      }
    }
    v[!is.finite(v)] <- 0
    mm[i, ] <- v
  }

  core_hto_set_data(sobj, assay = assay, slot = slot, mat = mm)
}

core_hto_auto_per_feature_thresholds <- function(
  sobj,
  assay,
  class_col = NA_character_,
  id_col = NA_character_,
  slot = "data",
  lower_quantile = 0.05
) {
  mat <- core_hto_get_data(sobj, assay = assay, slot = slot)
  if (is.null(mat)) return(numeric(0))
  mm <- as.matrix(mat)
  feats <- rownames(mm)
  cells <- colnames(mm)
  if (!length(feats) || !length(cells)) return(numeric(0))

  q <- suppressWarnings(as.numeric(lower_quantile %||% 0.05))
  if (!is.finite(q)) q <- 0.05
  q <- min(max(q, 0.001), 0.5)

  md <- sobj@meta.data
  cls <- if (!is.na(class_col) && class_col %in% colnames(md)) as.character(md[cells, class_col] %||% "") else rep("", length(cells))
  ids <- if (!is.na(id_col) && id_col %in% colnames(md)) as.character(md[cells, id_col] %||% "") else rep("", length(cells))
  cls_low <- tolower(cls)
  is_negative <- grepl("neg", cls_low)
  is_doublet <- grepl("doublet", cls_low) | grepl("_", cls, fixed = TRUE)
  is_singlet <- !is_negative & !is_doublet

  top_feat <- feats[max.col(t(mm), ties.method = "first")]
  out <- stats::setNames(rep(0, length(feats)), feats)
  for (f in feats) {
    by_id <- is_singlet & !is.na(ids) & nzchar(ids) & tolower(ids) == tolower(f)
    by_cls <- is_singlet & !is.na(cls) & nzchar(cls) & tolower(cls) == tolower(f)
    by_top <- is_singlet & top_feat == f
    use <- by_id | by_cls | by_top
    if (!any(use)) next
    vals <- as.numeric(mm[f, use])
    vals <- vals[is.finite(vals)]
    if (!length(vals)) next
    thr <- suppressWarnings(stats::quantile(vals, probs = q, na.rm = TRUE, names = FALSE, type = 8))
    if (!is.finite(thr) || thr < 0) thr <- 0
    out[[f]] <- as.numeric(thr)
  }
  out
}

core_hto_pick_class_col <- function(md) {
  if (is.null(md) || !nrow(md)) return(NA_character_)
  nms <- colnames(md)
  low <- tolower(nms)
  pref <- c("hto_classification.global", "multi_id", "classification.global", "hto_classification", "hash_classification")
  hit <- match(pref, low, nomatch = 0L)
  if (any(hit > 0)) return(nms[hit[hit > 0][1]])
  idx <- grep("class|demux|multi.*id", low, perl = TRUE)
  if (!length(idx)) return(NA_character_)
  nms[idx[1]]
}

core_hto_pick_id_col <- function(md) {
  if (is.null(md) || !nrow(md)) return(NA_character_)
  nms <- colnames(md)
  low <- tolower(nms)
  pref <- c("hash.id", "hto_maxid", "multi_id", "classification")
  hit <- match(pref, low, nomatch = 0L)
  if (any(hit > 0)) return(nms[hit[hit > 0][1]])
  idx <- grep("hash|hto|maxid|multi.*id", low, perl = TRUE)
  if (!length(idx)) return(NA_character_)
  nms[idx[1]]
}

core_hto_run_demux <- function(
  sobj,
  assay,
  method = c("HTODemux", "MULTIseqDemux"),
  positive_quantile = 0.99,
  multi_quantile = 0.7,
  auto_thresh = TRUE,
  normalize_before_demux = TRUE,
  init = "",
  nstarts = 100L,
  kfunc = "clara",
  nsamples = 100L,
  maxiter = 5L,
  qrange = c(0.1, 0.9),
  preprocess_background_quantile = 0,
  preprocess_robust_scale = FALSE,
  seed = 42
) {
  method <- match.arg(method)
  set.seed(as.integer(seed %||% 42))
  if (isTRUE(normalize_before_demux)) {
    sobj <- core_hto_prepare_assay(sobj, assay = assay)
  }
  sobj <- core_hto_preprocess_signal(
    sobj = sobj,
    assay = assay,
    slot = "data",
    background_quantile = preprocess_background_quantile %||% 0,
    robust_scale = isTRUE(preprocess_robust_scale)
  )

  init <- trimws(as.character(init %||% ""))
  init <- if (nzchar(init)) init else NULL
  nstarts <- max(1L, as.integer(nstarts %||% 100L))
  nsamples <- max(1L, as.integer(nsamples %||% 100L))
  maxiter <- max(1L, as.integer(maxiter %||% 5L))
  kfunc <- as.character(kfunc %||% "clara")
  qrange <- suppressWarnings(as.numeric(qrange %||% c(0.1, 0.9)))
  if (length(qrange) != 2L || any(!is.finite(qrange))) {
    qrange <- c(0.1, 0.9)
  }
  qrange <- sort(pmax(0, pmin(1, qrange)))

  sobj <- if (identical(method, "MULTIseqDemux")) {
    .f <- Seurat::MULTIseqDemux
    .args <- list(
      object = sobj,
      assay = assay,
      quantile = as.numeric(multi_quantile %||% 0.7),
      verbose = FALSE
    )
    .fml <- names(formals(.f))
    if ("autoThresh" %in% .fml) .args$autoThresh <- isTRUE(auto_thresh)
    if ("maxiter" %in% .fml) .args$maxiter <- maxiter
    if ("qrange" %in% .fml) .args$qrange <- qrange
    do.call(.f, .args)
  } else {
    .f <- Seurat::HTODemux
    .args <- list(
      object = sobj,
      assay = assay,
      positive.quantile = as.numeric(positive_quantile %||% 0.99),
      verbose = FALSE
    )
    .fml <- names(formals(.f))
    if ("init" %in% .fml && !is.null(init)) .args$init <- init
    if ("nstarts" %in% .fml) .args$nstarts <- nstarts
    if ("kfunc" %in% .fml) .args$kfunc <- kfunc
    if ("nsamples" %in% .fml) .args$nsamples <- nsamples
    do.call(.f, .args)
  }

  md <- sobj@meta.data
  class_col <- core_hto_pick_class_col(md)
  id_col <- core_hto_pick_id_col(md)

  if (is.na(class_col)) {
    stop("Demux completed but classification column was not found in metadata.")
  }

  cls <- as.character(md[[class_col]] %||% "")
  ids <- if (!is.na(id_col)) as.character(md[[id_col]] %||% "") else rep("", length(cls))
  out <- as.data.frame(table(class = cls), stringsAsFactors = FALSE)
  out <- out[order(out$Freq, decreasing = TRUE), , drop = FALSE]
  names(out) <- c("class", "cells")

  list(
    object = sobj,
    class_col = class_col,
    id_col = id_col,
    summary = out,
    mapped_ids = sort(unique(ids[nzchar(ids)]))
  )
}

core_hto_build_assignment_table <- function(sobj, class_col, id_col = NA_character_) {
  md <- sobj@meta.data
  if (is.null(md) || !nrow(md) || is.na(class_col) || !(class_col %in% colnames(md))) {
    return(data.frame())
  }
  cls <- as.character(md[[class_col]] %||% "")
  ids <- if (!is.na(id_col) && id_col %in% colnames(md)) as.character(md[[id_col]] %||% "") else rep("N/A", length(cls))
  df <- data.frame(class = cls, hashtag = ids, stringsAsFactors = FALSE)
  agg <- aggregate(rep(1L, nrow(df)), by = list(class = df$class, hashtag = df$hashtag), FUN = sum)
  names(agg)[3] <- "cells"
  agg[order(agg$cells, decreasing = TRUE), , drop = FALSE]
}

core_hto_filter_cells <- function(sobj, class_col, id_col = NA_character_, filter_mode = "singlet_only", keep_ids = character(0)) {
  md <- sobj@meta.data
  if (is.null(md) || !nrow(md) || !(class_col %in% colnames(md))) {
    stop("Classification metadata not found. Run demultiplexing first.")
  }
  cls <- tolower(as.character(md[[class_col]] %||% ""))
  ids <- if (!is.na(id_col) && id_col %in% colnames(md)) as.character(md[[id_col]] %||% "") else rep("", length(cls))

  keep <- rep(TRUE, length(cls))
  if (identical(filter_mode, "singlet_only")) {
    keep <- grepl("singlet", cls, fixed = TRUE)
  } else if (identical(filter_mode, "remove_negative")) {
    keep <- !grepl("negative", cls, fixed = TRUE)
  } else if (identical(filter_mode, "remove_doublet")) {
    keep <- !grepl("doublet", cls, fixed = TRUE)
  }

  keep_ids <- as.character(keep_ids %||% character(0))
  keep_ids <- keep_ids[nzchar(keep_ids)]
  if (length(keep_ids) && !is.na(id_col) && id_col %in% colnames(md)) {
    keep <- keep & (ids %in% keep_ids)
  }

  cells_keep <- rownames(md)[which(keep)]
  if (!length(cells_keep)) stop("Filter removed all cells.")
  list(
    object = subset(sobj, cells = cells_keep),
    n_keep = length(cells_keep),
    n_total = nrow(md)
  )
}


core_hto_ensure_umap <- function(sobj, assay, seed = 42, reduction_name = "hto.umap") {
  if (is.null(sobj) || is.null(assay) || !nzchar(assay)) return(sobj)
  set.seed(as.integer(seed %||% 42))

  red_names <- tryCatch(names(sobj@reductions), error = function(e) character(0))
  if (length(red_names) && reduction_name %in% red_names) return(sobj)

  feats <- core_hto_feature_names(sobj, assay)
  if (!length(feats)) return(sobj)

  sobj <- tryCatch(
    Seurat::ScaleData(sobj, assay = assay, features = feats, verbose = FALSE),
    error = function(e) sobj
  )

  pca_name <- paste0(assay, "_pca")
  sobj <- tryCatch(
    Seurat::RunPCA(
      object = sobj,
      assay = assay,
      features = feats,
      npcs = min(20, max(5, length(feats))),
      reduction.name = pca_name,
      verbose = FALSE
    ),
    error = function(e) sobj
  )

  if (!(pca_name %in% tryCatch(names(sobj@reductions), error = function(e) character(0)))) {
    return(sobj)
  }

  sobj <- tryCatch(
    Seurat::RunUMAP(
      object = sobj,
      reduction = pca_name,
      dims = seq_len(min(10, ncol(Seurat::Embeddings(sobj, pca_name)))),
      reduction.name = reduction_name,
      seed.use = as.integer(seed %||% 42),
      verbose = FALSE
    ),
    error = function(e) sobj
  )

  sobj
}

core_hto_ensure_tsne <- function(sobj, assay, seed = 42, reduction_name = "hto.tsne") {
  if (is.null(sobj) || is.null(assay) || !nzchar(assay)) return(sobj)
  set.seed(as.integer(seed %||% 42))

  red_names <- tryCatch(names(sobj@reductions), error = function(e) character(0))
  if (length(red_names) && reduction_name %in% red_names) return(sobj)

  feats <- core_hto_feature_names(sobj, assay)
  if (!length(feats)) return(sobj)

  sobj <- tryCatch(
    Seurat::ScaleData(sobj, assay = assay, features = feats, verbose = FALSE),
    error = function(e) sobj
  )

  pca_name <- paste0(assay, "_pca")
  sobj <- tryCatch(
    Seurat::RunPCA(
      object = sobj,
      assay = assay,
      features = feats,
      npcs = min(20, max(5, length(feats))),
      reduction.name = pca_name,
      verbose = FALSE
    ),
    error = function(e) sobj
  )

  if (!(pca_name %in% tryCatch(names(sobj@reductions), error = function(e) character(0)))) {
    return(sobj)
  }

  sobj <- tryCatch(
    Seurat::RunTSNE(
      object = sobj,
      reduction = pca_name,
      dims = seq_len(min(10, ncol(Seurat::Embeddings(sobj, pca_name)))),
      reduction.name = reduction_name,
      seed.use = as.integer(seed %||% 42),
      check_duplicates = FALSE,
      verbose = FALSE
    ),
    error = function(e) sobj
  )

  sobj
}
