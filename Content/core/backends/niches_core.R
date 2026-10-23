# niches_core.R

`%||%` <- function(a, b) if (is.null(a)) b else a

niches_beta_object_names <- function(shared_data) {
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

niches_beta_get_object <- function(shared_data, object_name = NULL) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm0 in names(reg_flt)) if (is.null(reg[[nm0]])) reg[[nm0]] <- reg_flt[[nm0]]

  valid_nms <- niches_beta_object_names(shared_data)
  nm <- as.character(object_name %||% "")
  if (!nzchar(nm)) nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
  if (!nzchar(nm) || !(nm %in% valid_nms)) nm <- if (length(valid_nms)) valid_nms[[length(valid_nms)]] else ""
  if (!nzchar(nm) || !(nm %in% names(reg))) return(NULL)

  x <- reg[[nm]]
  obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
  if (!inherits(obj, "Seurat")) return(NULL)
  obj
}

niches_beta_meta_cols <- function(sobj) {
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

niches_beta_default_group <- function(cols) {
  p <- c("seurat_clusters", "celltype", "orig.ident", "sample", "condition", "batch")
  h <- intersect(p, cols)
  if (length(h)) h[[1]] else if (length(cols)) cols[[1]] else ""
}

niches_beta_assays <- function(sobj) {
  aa <- tryCatch(names(sobj@assays), error = function(e) character(0))
  aa[nzchar(aa)]
}

niches_beta_default_assay <- function(sobj) {
  aa <- niches_beta_assays(sobj)
  if (!length(aa)) return("")
  if ("RNA" %in% aa) return("RNA")
  da <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "")
  if (nzchar(da) && da %in% aa) return(da)
  aa[[1]]
}

.niches_get_assay_data <- function(sobj, assay = NULL, pref = c("data", "counts")) {
  aa <- names(sobj@assays)
  use_assay <- as.character(assay %||% "")
  if (!nzchar(use_assay) || !(use_assay %in% aa)) use_assay <- aa[[1]] %||% ""
  if (!nzchar(use_assay)) stop("No assay found in NICHES output object.")

  for (pp in pref) {
    m <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, layer = pp), error = function(e) NULL)
    if (!is.null(m)) return(list(matrix = m, assay = use_assay, slot = pp))
    m <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, slot = pp), error = function(e) NULL)
    if (!is.null(m)) return(list(matrix = m, assay = use_assay, slot = pp))
  }
  stop("Could not read assay data from NICHES output object.")
}

.niches_pair_from_meta <- function(meta, edge_score) {
  sender <- as.character(meta$SendingType %||% rep("Unknown", nrow(meta)))
  receiver <- as.character(meta$ReceivingType %||% rep("Unknown", nrow(meta)))
  sender[is.na(sender) | !nzchar(sender)] <- "Unknown"
  receiver[is.na(receiver) | !nzchar(receiver)] <- "Unknown"

  dd <- data.frame(sender = sender, receiver = receiver, score = as.numeric(edge_score), stringsAsFactors = FALSE)
  dd <- dd[is.finite(dd$score), , drop = FALSE]
  agg <- stats::aggregate(score ~ sender + receiver, data = dd, FUN = mean, na.rm = TRUE)
  agg <- agg[order(agg$score, decreasing = TRUE), , drop = FALSE]
  list(edge_df = dd, pair_df = agg)
}

.niches_interaction_matrix <- function(pair_df) {
  if (!nrow(pair_df)) {
    return(matrix(0, nrow = 1, ncol = 1, dimnames = list("Unknown", "Unknown")))
  }
  m <- xtabs(score ~ sender + receiver, data = pair_df)
  as.matrix(m)
}

niches_beta_run <- function(
  sobj,
  group_col,
  assay = NULL,
  species = "human",
  lr_database = "fantom5",
  neighbors = 15L,
  top_pairs = 80L,
  min_cells_per_ident = NULL,
  min_cells_per_gene = NULL
) {
  if (!requireNamespace("NICHES", quietly = TRUE)) stop("Package 'NICHES' is not available in the active environment.")
  if (!inherits(sobj, "Seurat")) stop("Input object must be a Seurat object.")

  md <- sobj@meta.data
  if (!(group_col %in% colnames(md))) stop("Grouping column not found in metadata.")

  grp <- as.character(md[[group_col]])
  grp[is.na(grp) | !nzchar(grp)] <- "Unknown"
  if (length(unique(grp)) > 80L) {
    stop("Selected grouping column has too many unique values (>80). Choose a categorical metadata column.")
  }

  obj <- sobj
  obj[[group_col]] <- grp
  obj <- Seurat::SetIdent(obj, value = obj[[group_col, drop = TRUE]])

  assay_use <- as.character(assay %||% "")
  aa <- niches_beta_assays(obj)
  if (!nzchar(assay_use) || !(assay_use %in% aa)) assay_use <- niches_beta_default_assay(obj)
  if (!nzchar(assay_use)) stop("Could not determine assay for NICHES.")

  nn <- NICHES::RunNICHES(
    object = obj,
    assay = assay_use,
    LR.database = as.character(lr_database %||% "fantom5"),
    species = tolower(trimws(species %||% "human")),
    min.cells.per.ident = if (is.null(min_cells_per_ident)) NULL else as.integer(min_cells_per_ident),
    min.cells.per.gene = if (is.null(min_cells_per_gene)) NULL else as.integer(min_cells_per_gene),
    meta.data.to.map = group_col,
    k = max(1L, as.integer(neighbors %||% 15L)),
    CellToCell = TRUE,
    CellToSystem = TRUE,
    SystemToCell = TRUE,
    CellToCellSpatial = FALSE,
    CellToNeighborhood = FALSE,
    NeighborhoodToCell = FALSE,
    output_format = "seurat"
  )

  c2c <- nn$CellToCell %||% nn[[1]]
  if (is.null(c2c) || !inherits(c2c, "Seurat")) {
    stop("NICHES did not return a CellToCell Seurat object.")
  }

  mat_info <- .niches_get_assay_data(c2c, pref = c("data", "counts"))
  mat <- mat_info$matrix
  if (!inherits(mat, "matrix")) mat <- as.matrix(mat)

  meta <- c2c@meta.data
  edge_score <- Matrix::colMeans(mat)
  pair_pack <- .niches_pair_from_meta(meta, edge_score)
  pair_df <- pair_pack$pair_df
  interaction <- .niches_interaction_matrix(pair_df)

  nfeat <- min(500L, nrow(mat))
  feat_mean <- Matrix::rowMeans(mat)
  ord <- order(feat_mean, decreasing = TRUE)
  top_feat_idx <- ord[seq_len(min(nfeat, length(ord)))]
  mm <- t(as.matrix(mat[top_feat_idx, , drop = FALSE]))
  emb <- if (nrow(mm) >= 2L && ncol(mm) >= 2L) {
    pc <- stats::prcomp(mm, center = TRUE, scale. = TRUE)
    data.frame(
      x = pc$x[, 1],
      y = pc$x[, 2],
      vector = rownames(mm),
      sender = as.character(meta$SendingType %||% "Unknown"),
      receiver = as.character(meta$ReceivingType %||% "Unknown"),
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(
      x = seq_len(ncol(mat)),
      y = rep(0, ncol(mat)),
      vector = colnames(mat),
      sender = as.character(meta$SendingType %||% "Unknown"),
      receiver = as.character(meta$ReceivingType %||% "Unknown"),
      stringsAsFactors = FALSE
    )
  }

  sender <- data.frame(group = rownames(interaction), score = rowSums(interaction, na.rm = TRUE), stringsAsFactors = FALSE)

  feature_rank <- data.frame(
    feature = rownames(mat),
    score = as.numeric(Matrix::rowMeans(mat)),
    stringsAsFactors = FALSE
  )
  feature_rank <- feature_rank[order(feature_rank$score, decreasing = TRUE), , drop = FALSE]
  feature_rank <- utils::head(feature_rank, max(20L, as.integer(top_pairs %||% 80L)))

  map_df <- pair_pack$edge_df
  map_df <- map_df[order(map_df$score, decreasing = TRUE), , drop = FALSE]
  map_df <- utils::head(map_df, 200)

  list(
    assay = assay_use,
    species = tolower(trimws(species %||% "human")),
    lr_database = lr_database,
    run_object = nn,
    c2c_object = c2c,
    emb = emb,
    interaction = interaction,
    pair_df = pair_df,
    sender = sender,
    feature_rank = feature_rank,
    map_df = map_df
  )
}

# Backward-compatible alias retained for existing interface calls.
niches_beta_preview <- function(sobj, group_col, top_pairs = 80L, assay = NULL, species = "human", neighbors = 15L, lr_database = "fantom5") {
  niches_beta_run(
    sobj = sobj,
    group_col = group_col,
    assay = assay,
    species = species,
    lr_database = lr_database,
    neighbors = neighbors,
    top_pairs = top_pairs
  )
}
