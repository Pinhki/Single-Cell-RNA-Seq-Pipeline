core_feature_get_assay_data <- function(sobj, assay = NULL, layer = "data") {
  assay <- as.character(assay %||% "")[[1]]
  if (!nzchar(assay)) assay <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
  get_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
  use_layer <- "layer" %in% get_formals
  args <- list(object = sobj)
  args[[if (use_layer) "layer" else "slot"]] <- layer
  if (nzchar(assay)) args$assay <- assay
  out <- tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
  if (!is.null(out)) return(out)

  alternate <- list(object = sobj)
  alternate[[if (use_layer) "slot" else "layer"]] <- layer
  if (nzchar(assay)) alternate$assay <- assay
  tryCatch(do.call(Seurat::GetAssayData, alternate), error = function(e) NULL)
}

core_feature_quantile_scale <- function(values, upper_quantile = 0.99) {
  values <- suppressWarnings(as.numeric(values))
  values[!is.finite(values)] <- 0
  values <- pmax(values, 0)
  upper <- suppressWarnings(stats::quantile(values, upper_quantile, na.rm = TRUE, names = FALSE))
  if (!is.finite(upper) || upper <= 0) return(rep(0, length(values)))
  pmin(values / upper, 1)
}

core_feature_rgb_data <- function(sobj,
                                  genes,
                                  assay = NULL,
                                  reduction = "umap",
                                  column_split = "__none__",
                                  row_split = "__none__",
                                  upper_quantile = 0.99,
                                  seed = 42L) {
  genes <- trimws(as.character(genes %||% character(0)))
  if (length(genes) != 3L || any(!nzchar(genes)) || anyDuplicated(genes)) {
    stop("Select three different genes for RGB Gene Expression.")
  }
  data_mat <- core_feature_get_assay_data(sobj, assay = assay, layer = "data")
  if (is.null(data_mat)) stop("Assay data layer is not available.")
  missing <- setdiff(genes, rownames(data_mat))
  if (length(missing)) stop("Genes not found: ", paste(missing, collapse = ", "))

  reductions <- tryCatch(names(sobj@reductions), error = function(e) character(0))
  if (!(reduction %in% reductions)) stop("Reduction is not available: ", reduction)
  emb <- Seurat::Embeddings(sobj, reduction = reduction)
  cells <- intersect(rownames(emb), colnames(data_mat))
  if (!length(cells)) stop("Reduction and assay have no matching cells.")
  emb <- emb[cells, , drop = FALSE]
  values <- as.matrix(data_mat[genes, cells, drop = FALSE])
  red <- core_feature_quantile_scale(values[1, ], upper_quantile)
  green <- core_feature_quantile_scale(values[2, ], upper_quantile)
  blue <- core_feature_quantile_scale(values[3, ], upper_quantile)

  md <- sobj@meta.data
  clean_group <- function(column) {
    if (identical(column, "__none__")) return(rep("All", length(cells)))
    if (!(column %in% colnames(md))) stop("Split column is not available: ", column)
    out <- trimws(as.character(md[cells, column]))
    out[is.na(out) | !nzchar(out)] <- "(NA)"
    out
  }

  # Agent note: Strong RGB signal must draw last. Seeded tie ordering keeps
  # equal-signal cells deterministic without changing global random state.
  had_seed <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  old_seed <- if (had_seed) get(".Random.seed", envir = .GlobalEnv, inherits = FALSE) else NULL
  on.exit({
    if (had_seed) {
      assign(".Random.seed", old_seed, envir = .GlobalEnv)
    } else if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)) {
      rm(".Random.seed", envir = .GlobalEnv)
    }
  }, add = TRUE)
  set.seed(as.integer(seed))
  tie_order <- stats::runif(length(cells))

  out <- data.frame(
    cell = cells,
    Dim_1 = emb[, 1],
    Dim_2 = emb[, 2],
    red = red,
    green = green,
    blue = blue,
    signal = red + green + blue,
    tie_order = tie_order,
    column_group = clean_group(column_split),
    row_group = clean_group(row_split),
    stringsAsFactors = FALSE
  )
  out$rgb <- grDevices::rgb(out$red, out$green, out$blue)
  out[order(out$signal, out$tie_order), , drop = FALSE]
}

core_feature_program_score <- function(sobj,
                                       genes,
                                       assay = NULL,
                                       method = c("add_module_score", "mean_expression"),
                                       control_genes = NULL,
                                       expression_bins = 24L,
                                       seed = 42L) {
  method <- match.arg(method)
  genes <- unique(trimws(as.character(genes %||% character(0))))
  genes <- genes[nzchar(genes)]
  if (!length(genes)) stop("Select at least one gene for Gene Program.")
  data_mat <- core_feature_get_assay_data(sobj, assay = assay, layer = "data")
  if (is.null(data_mat)) stop("Assay data layer is not available.")
  missing <- setdiff(genes, rownames(data_mat))
  if (length(missing)) stop("Genes not found: ", paste(missing, collapse = ", "))

  if (identical(method, "mean_expression")) {
    score <- Matrix::colMeans(data_mat[genes, , drop = FALSE])
    return(stats::setNames(as.numeric(score), names(score)))
  }

  args <- list(
    object = sobj,
    features = list(genes),
    assay = assay,
    name = ".wanlab_program_score",
    nbin = as.integer(expression_bins)
  )
  if (is.null(control_genes)) {
    available <- max(1L, nrow(data_mat) - length(genes))
    control_genes <- min(100L, max(1L, floor(available / (2L * as.integer(expression_bins)))))
  }
  args$ctrl <- as.integer(control_genes)
  add_formals <- tryCatch(names(formals(Seurat::AddModuleScore)), error = function(e) character(0))
  if ("seed" %in% add_formals) args$seed <- as.integer(seed)
  if ("search" %in% add_formals) args$search <- FALSE
  scored <- do.call(Seurat::AddModuleScore, args)
  score_cols <- grep("^\\.wanlab_program_score", colnames(scored@meta.data), value = TRUE)
  if (!length(score_cols)) stop("Seurat did not return a program-score column.")
  score <- scored@meta.data[[score_cols[[length(score_cols)]]]]
  stats::setNames(as.numeric(score), rownames(scored@meta.data))
}
