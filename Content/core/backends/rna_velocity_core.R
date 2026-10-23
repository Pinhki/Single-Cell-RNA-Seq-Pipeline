`%||%` <- function(a, b) if (is.null(a)) b else a

rna_velocity_beta_object_names <- function(shared_data) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm in names(reg_flt)) if (is.null(reg[[nm]])) reg[[nm]] <- reg_flt[[nm]]

  nms <- names(reg)
  if (!length(nms)) return(character(0))
  nms <- nms[nzchar(nms)]
  keep <- vapply(nms, function(nm) {
    x <- reg[[nm]]
    obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
    inherits(obj, "Seurat")
  }, logical(1))
  unique(nms[keep])
}

rna_velocity_beta_get_object <- function(shared_data, object_name = NULL) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm0 in names(reg_flt)) if (is.null(reg[[nm0]])) reg[[nm0]] <- reg_flt[[nm0]]

  valid_nms <- rna_velocity_beta_object_names(shared_data)
  nm <- as.character(object_name %||% "")
  if (!nzchar(nm)) nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
  if (!nzchar(nm) || !(nm %in% valid_nms)) nm <- if (length(valid_nms)) valid_nms[[length(valid_nms)]] else ""
  if (!nzchar(nm) || !(nm %in% names(reg))) return(NULL)

  x <- reg[[nm]]
  obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
  if (!inherits(obj, "Seurat")) return(NULL)
  obj
}

rna_velocity_beta_meta_cols <- function(sobj) {
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !nrow(md)) return(character(0))
  cols <- colnames(md)
  keep <- vapply(cols, function(cn) {
    v <- md[[cn]]
    v <- v[!is.na(v)]
    if (!length(v)) return(FALSE)
    nu <- length(unique(as.character(v)))
    if (nu < 2L) return(FALSE)
    if (is.numeric(v) || is.integer(v)) return(nu <= max(50L, floor(0.25 * length(v))))
    TRUE
  }, logical(1))
  cols[keep]
}

rna_velocity_beta_reductions <- function(sobj) {
  reds <- tryCatch(names(sobj@reductions), error = function(e) character(0))
  reds[nzchar(reds)]
}

rna_velocity_beta_default_reduction <- function(sobj) {
  reds <- rna_velocity_beta_reductions(sobj)
  if (!length(reds)) return("")
  low <- tolower(reds)
  um_idx <- which(low %in% c("umap", "umap_harmony", "umap_integrated"))
  if (length(um_idx)) return(reds[[um_idx[[1]]]])
  reds[[1]]
}

rna_velocity_beta_python_status <- function(
  python_path = "",
  require_modules = c("scanpy", "scvelo", "anndata", "loompy"),
  module_checker = NULL,
  reticulate_installed = requireNamespace("reticulate", quietly = TRUE)
) {
  if (!isTRUE(reticulate_installed)) {
    return(list(
      ok = FALSE,
      summary = "reticulate is not installed in this R environment.",
      python = "",
      modules = setNames(as.list(rep(FALSE, length(require_modules))), require_modules)
    ))
  }

  py <- trimws(as.character(python_path %||% ""))
  if (nzchar(py) && file.exists(py)) {
    try(reticulate::use_python(py, required = FALSE), silent = TRUE)
  }

  checker <- module_checker
  if (!is.function(checker)) {
    checker <- function(modules, python_path = "") {
      out <- vapply(modules, function(m) isTRUE(reticulate::py_module_available(m)), logical(1))
      names(out) <- modules
      out
    }
  }

  mod_ok <- checker(require_modules, python_path = py)
  mod_ok <- as.logical(mod_ok)
  if (length(mod_ok) != length(require_modules)) {
    mod_ok <- rep(FALSE, length(require_modules))
  }
  names(mod_ok) <- require_modules

  py_cfg <- tryCatch(reticulate::py_config(), error = function(e) NULL)
  py_bin <- as.character(py_cfg$python %||% py)
  missing <- require_modules[!mod_ok]
  summary <- if (!length(missing)) {
    sprintf("Runtime ready. Python: %s", if (nzchar(py_bin)) py_bin else "detected")
  } else {
    sprintf("Missing Python module(s): %s", paste(missing, collapse = ", "))
  }

  list(
    ok = !length(missing),
    summary = summary,
    python = py_bin,
    modules = as.list(mod_ok)
  )
}

rna_velocity_beta_normalize_cell_names <- function(x) {
  xx <- as.character(x %||% character(0))
  xx <- trimws(xx)
  xx <- gsub("^.*:", "", xx)
  xx <- gsub("-[0-9]+$", "", xx)
  toupper(xx)
}

rna_velocity_beta_match_cells <- function(seurat_cells, loom_cells) {
  sc <- as.character(seurat_cells %||% character(0))
  lc <- as.character(loom_cells %||% character(0))
  if (!length(sc) || !length(lc)) {
    return(data.frame(seurat_cell = character(0), loom_cell = character(0), match_type = character(0), stringsAsFactors = FALSE))
  }

  exact <- sc[sc %in% lc]
  exact_df <- data.frame(
    seurat_cell = exact,
    loom_cell = exact,
    match_type = rep("exact", length(exact)),
    stringsAsFactors = FALSE
  )

  sc_left <- setdiff(sc, exact)
  lc_left <- setdiff(lc, exact)
  if (!length(sc_left) || !length(lc_left)) {
    return(exact_df)
  }

  sc_norm <- rna_velocity_beta_normalize_cell_names(sc_left)
  lc_norm <- rna_velocity_beta_normalize_cell_names(lc_left)

  lc_map <- split(lc_left, lc_norm)
  out <- lapply(seq_along(sc_left), function(i) {
    key <- sc_norm[[i]]
    cands <- lc_map[[key]]
    if (is.null(cands) || !length(cands)) return(NULL)
    data.frame(
      seurat_cell = sc_left[[i]],
      loom_cell = cands[[1]],
      match_type = "normalized",
      stringsAsFactors = FALSE
    )
  })
  norm_df <- do.call(rbind, out)
  if (is.null(norm_df)) norm_df <- data.frame(seurat_cell = character(0), loom_cell = character(0), match_type = character(0), stringsAsFactors = FALSE)

  all_df <- rbind(exact_df, norm_df)
  if (!nrow(all_df)) return(all_df)
  all_df <- all_df[!duplicated(all_df$loom_cell), , drop = FALSE]
  all_df <- all_df[!duplicated(all_df$seurat_cell), , drop = FALSE]
  all_df <- all_df[match(sc[sc %in% all_df$seurat_cell], all_df$seurat_cell), , drop = FALSE]
  rownames(all_df) <- NULL
  all_df
}

rna_velocity_beta_run_from_loom <- function(
  sobj,
  loom_path,
  reduction = "",
  group_col = "",
  python_path = "",
  mode = "stochastic",
  n_top_genes = 2000L,
  n_pcs = 30L,
  pc_count = NULL,
  n_neighbors = 30L,
  min_shared_counts = 20L
) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) stop("A valid Seurat object is required.")
  lp <- as.character(loom_path %||% "")
  if (!nzchar(lp) || !file.exists(lp)) stop("Loom file not found.")

  reduction_use <- as.character(reduction %||% "")
  reds <- rna_velocity_beta_reductions(sobj)
  if (!nzchar(reduction_use) || !(reduction_use %in% reds)) reduction_use <- rna_velocity_beta_default_reduction(sobj)
  if (!nzchar(reduction_use)) stop("No reduction found. Please compute UMAP before running RNA velocity.")

  emb <- tryCatch(Seurat::Embeddings(sobj, reduction = reduction_use), error = function(e) NULL)
  if (is.null(emb) || ncol(emb) < 2L) stop("Selected reduction does not have at least 2 dimensions.")

  py_st <- rna_velocity_beta_python_status(python_path = python_path)
  if (!isTRUE(py_st$ok)) stop(py_st$summary)

  py <- trimws(as.character(python_path %||% ""))
  if (nzchar(py) && file.exists(py)) {
    try(reticulate::use_python(py, required = FALSE), silent = TRUE)
  }

  scv <- reticulate::import("scvelo", delay_load = TRUE)
  np <- reticulate::import("numpy", delay_load = TRUE)

  adata <- scv$read(lp, cache = FALSE)
  loom_cells <- tryCatch(reticulate::py_to_r(adata$obs_names$to_list()), error = function(e) character(0))
  seurat_cells <- rownames(emb)

  mt <- rna_velocity_beta_match_cells(seurat_cells = seurat_cells, loom_cells = loom_cells)
  if (!nrow(mt)) {
    stop("No overlapping barcodes found between Seurat object and loom file.")
  }

  mt <- mt[match(mt$seurat_cell, seurat_cells), , drop = FALSE]
  mt <- mt[!is.na(mt$seurat_cell), , drop = FALSE]
  mt <- mt[!duplicated(mt$seurat_cell), , drop = FALSE]

  adata <- adata[mt$loom_cell, ]$copy()
  emb_sub <- emb[mt$seurat_cell, 1:2, drop = FALSE]
  adata$obsm[["X_umap"]] <- np$array(unname(as.matrix(emb_sub)), dtype = "float64")

  scv$pp$filter_and_normalize(
    adata,
    min_shared_counts = as.integer(max(1L, min_shared_counts)),
    n_top_genes = as.integer(max(200L, n_top_genes))
  )
  pc_count_use <- as.integer(pc_count %||% n_pcs)
  if (!is.finite(pc_count_use) || pc_count_use < 2L) stop("Velocity PC count must be at least 2.")
  scv$pp$moments(
    adata,
    n_pcs = as.integer(pc_count_use),
    n_neighbors = as.integer(max(2L, n_neighbors))
  )
  scv$tl$velocity(adata, mode = as.character(mode %||% "stochastic"))
  scv$tl$velocity_graph(adata)
  scv$tl$velocity_embedding(adata, basis = "umap")

  x_umap <- tryCatch(reticulate::py_to_r(adata$obsm$get("X_umap")), error = function(e) NULL)
  v_umap <- tryCatch(reticulate::py_to_r(adata$obsm$get("velocity_umap")), error = function(e) NULL)
  obs <- tryCatch(reticulate::py_to_r(adata$obs), error = function(e) data.frame())

  if (is.null(x_umap) || is.null(v_umap)) stop("Velocity embedding output missing from scVelo run.")
  x_umap <- as.matrix(x_umap)
  v_umap <- as.matrix(v_umap)
  if (ncol(x_umap) < 2L || ncol(v_umap) < 2L) stop("Velocity embedding does not have 2 dimensions.")

  vx <- as.numeric(v_umap[, 1])
  vy <- as.numeric(v_umap[, 2])
  speed <- sqrt(vx^2 + vy^2)

  md <- tryCatch(sobj@meta.data, error = function(e) data.frame())
  groups <- rep("All cells", nrow(mt))
  gcol <- as.character(group_col %||% "")
  if (nzchar(gcol) && nrow(md) && gcol %in% colnames(md)) {
    gv <- as.character(md[mt$seurat_cell, gcol])
    gv[is.na(gv) | !nzchar(gv)] <- "Unknown"
    groups <- gv
  }

  conf <- rep(NA_real_, nrow(mt))
  lat <- rep(NA_real_, nrow(mt))
  if (is.data.frame(obs) && nrow(obs) == nrow(mt)) {
    if ("velocity_confidence" %in% colnames(obs)) conf <- suppressWarnings(as.numeric(obs$velocity_confidence))
    if ("latent_time" %in% colnames(obs)) lat <- suppressWarnings(as.numeric(obs$latent_time))
  }

  vec <- data.frame(
    cell = as.character(mt$seurat_cell),
    x = as.numeric(x_umap[, 1]),
    y = as.numeric(x_umap[, 2]),
    vx = vx,
    vy = vy,
    speed = speed,
    group = as.character(groups),
    confidence = conf,
    latent_time = lat,
    stringsAsFactors = FALSE
  )

  list(
    vectors = vec,
    match_table = mt,
    reduction = reduction_use,
    group_col = gcol,
    annotation = as.character(groups),
    annotation_column = gcol,
    mode = as.character(mode %||% "stochastic"),
    pc_count = pc_count_use,
    python = as.character(py_st$python %||% ""),
    summary = list(
      n_cells = nrow(vec),
      n_exact = sum(mt$match_type %in% "exact", na.rm = TRUE),
      n_normalized = sum(mt$match_type %in% "normalized", na.rm = TRUE),
      speed_median = stats::median(vec$speed, na.rm = TRUE)
    )
  )
}
