# nichenet_core.R

`%||%` <- function(a, b) if (is.null(a)) b else a

nichenet_beta_object_names <- function(shared_data) {
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

nichenet_beta_get_object <- function(shared_data, object_name = NULL) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm0 in names(reg_flt)) if (is.null(reg[[nm0]])) reg[[nm0]] <- reg_flt[[nm0]]

  valid_nms <- nichenet_beta_object_names(shared_data)
  nm <- as.character(object_name %||% "")
  if (!nzchar(nm)) nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
  if (!nzchar(nm) || !(nm %in% valid_nms)) nm <- if (length(valid_nms)) valid_nms[[1]] else ""
  if (!nzchar(nm) || !(nm %in% names(reg))) return(NULL)

  x <- reg[[nm]]
  obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
  if (!inherits(obj, "Seurat")) return(NULL)
  obj
}

nichenet_beta_meta_cols <- function(sobj) {
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

nichenet_beta_default_group <- function(cols) {
  p <- c("seurat_clusters", "celltype", "orig.ident", "sample", "condition", "batch")
  h <- intersect(p, cols)
  if (length(h)) h[[1]] else if (length(cols)) cols[[1]] else ""
}

nichenet_beta_assays <- function(sobj) {
  aa <- tryCatch(names(sobj@assays), error = function(e) character(0))
  aa[nzchar(aa)]
}

nichenet_beta_default_assay <- function(sobj) {
  aa <- nichenet_beta_assays(sobj)
  if (!length(aa)) return("")
  if ("RNA" %in% aa) return("RNA")
  da <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "")
  if (nzchar(da) && da %in% aa) return(da)
  aa[[1]]
}

nichenet_beta_project_root <- function() {
  wd <- normalizePath(getwd(), winslash = "/", mustWork = FALSE)
  cands <- unique(c(wd, dirname(wd), dirname(dirname(wd))))
  hit <- cands[file.exists(file.path(cands, "Content", "app.R"))]
  if (length(hit)) return(hit[[1]])
  dirname(wd)
}

nichenet_beta_resource_root <- function() {
  file.path(nichenet_beta_project_root(), "analysis_resources", "nichenet")
}

nichenet_beta_resource_manifest <- function(species = "human") {
  sp <- tolower(trimws(species %||% "human"))
  base <- "https://zenodo.org/records/7074291/files"
  if (sp %in% c("mouse", "mm", "mm10")) {
    files <- list(
      list(file = "ligand_target_matrix_nsga2r_final_mouse.rds", size_mb = 191.0),
      list(file = "lr_network_mouse_21122021.rds", size_mb = 0.03),
      list(file = "weighted_networks_nsga2r_final_mouse.rds", size_mb = 77.4)
    )
    sp <- "mouse"
  } else {
    files <- list(
      list(file = "ligand_target_matrix_nsga2r_final.rds", size_mb = 262.1),
      list(file = "lr_network_human_21122021.rds", size_mb = 0.03),
      list(file = "weighted_networks_nsga2r_final.rds", size_mb = 73.7)
    )
    sp <- "human"
  }
  for (i in seq_along(files)) {
    files[[i]]$url <- paste0(base, "/", files[[i]]$file)
  }
  list(species = sp, files = files)
}

nichenet_beta_resource_dir <- function(species = "human") {
  sp <- nichenet_beta_resource_manifest(species)$species
  d <- file.path(nichenet_beta_resource_root(), sp)
  dir.create(d, recursive = TRUE, showWarnings = FALSE)
  d
}

nichenet_beta_resource_status <- function(species = "human") {
  man <- nichenet_beta_resource_manifest(species)
  d <- nichenet_beta_resource_dir(species)
  files <- do.call(rbind, lapply(man$files, function(x) {
    lp <- file.path(d, x$file)
    data.frame(
      file = x$file,
      url = x$url,
      size_mb = as.numeric(x$size_mb),
      local_path = lp,
      exists = file.exists(lp),
      stringsAsFactors = FALSE
    )
  }))
  list(
    species = man$species,
    dir = d,
    total_mb = sum(files$size_mb),
    complete = all(files$exists),
    files = files
  )
}

nichenet_beta_download_resources <- function(species = "human", progress = NULL) {
  st <- nichenet_beta_resource_status(species)
  todo <- st$files[!st$files$exists, , drop = FALSE]
  if (!nrow(todo)) return(st)
  for (i in seq_len(nrow(todo))) {
    row <- todo[i, , drop = FALSE]
    if (is.function(progress)) progress(sprintf("Downloading %s (~%s MB)", row$file[[1]], row$size_mb[[1]]))
    utils::download.file(row$url[[1]], destfile = row$local_path[[1]], mode = "wb", quiet = FALSE)
    fi <- suppressWarnings(file.info(row$local_path[[1]]))
    if (!isTRUE(file.exists(row$local_path[[1]])) || is.na(fi$size) || fi$size <= 0) {
      stop("Download failed or empty file: ", row$file[[1]])
    }
  }
  nichenet_beta_resource_status(species)
}

nichenet_beta_load_resources <- function(species = "human") {
  st <- nichenet_beta_resource_status(species)
  if (!isTRUE(st$complete)) {
    miss <- st$files$file[!st$files$exists]
    stop("NicheNet resources missing: ", paste(miss, collapse = ", "))
  }
  files <- st$files
  lt_file <- files$local_path[grepl("ligand_target_matrix", files$file)][1]
  lr_file <- files$local_path[grepl("lr_network", files$file)][1]
  wn_file <- files$local_path[grepl("weighted_networks", files$file)][1]
  if (!all(file.exists(c(lt_file, lr_file, wn_file)))) stop("NicheNet resource files not found after status check.")

  list(
    ligand_target_matrix = readRDS(lt_file),
    lr_network = readRDS(lr_file),
    weighted_networks = readRDS(wn_file),
    status = st
  )
}

.nichenet_group_counts <- function(sobj, group_col, sender_level, receiver_level) {
  grp <- as.character(sobj@meta.data[[group_col]])
  grp[is.na(grp) | !nzchar(grp)] <- "Unknown"
  tab <- sort(table(grp), decreasing = TRUE)
  sr <- data.frame(
    label = c("Sender", "Receiver"),
    count = c(sum(grp == sender_level, na.rm = TRUE), sum(grp == receiver_level, na.rm = TRUE)),
    stringsAsFactors = FALSE
  )
  list(
    group_counts = data.frame(group = names(tab), n = as.numeric(tab), stringsAsFactors = FALSE),
    sr_counts = sr
  )
}

.nichenet_safe_df <- function(x) {
  if (is.null(x)) return(data.frame())
  out <- tryCatch(BiocGenerics::as.data.frame(x), error = function(e) tryCatch(as.data.frame(x), error = function(e2) data.frame()))
  out
}

.nichenet_lr_matrix_from_df <- function(df) {
  if (is.null(df) || !nrow(df)) {
    return(matrix(0, nrow = 1, ncol = 1, dimnames = list("NoReceptor", "NoLigand")))
  }
  dd <- data.frame(
    receptor = as.character(df$to %||% character(0)),
    ligand = as.character(df$from %||% character(0)),
    weight = suppressWarnings(as.numeric(df$weight %||% NA_real_)),
    stringsAsFactors = FALSE
  )
  dd <- dd[is.finite(dd$weight), , drop = FALSE]
  dd <- dd[nzchar(dd$ligand) & nzchar(dd$receptor), , drop = FALSE]
  if (!nrow(dd)) {
    return(matrix(0, nrow = 1, ncol = 1, dimnames = list("NoReceptor", "NoLigand")))
  }

  dd <- stats::aggregate(weight ~ receptor + ligand, data = dd, FUN = mean, na.rm = TRUE)
  receptor_levels <- unique(dd$receptor)
  ligand_levels <- unique(dd$ligand)
  dd$receptor <- factor(dd$receptor, levels = receptor_levels)
  dd$ligand <- factor(dd$ligand, levels = ligand_levels)

  as.matrix(stats::xtabs(weight ~ receptor + ligand, data = dd))
}

.nichenet_manual_fallback <- function(
  sobj,
  group_col,
  sender_level,
  receiver_level,
  assay_use,
  ligand_target_matrix,
  lr_network,
  weighted_networks,
  top_ligands = 30L,
  top_targets = 200L,
  expression_pct = 0.1,
  lfc_cutoff = 0.25
) {
  obj <- sobj
  Seurat::DefaultAssay(obj) <- assay_use
  obj <- Seurat::SetIdent(obj, value = obj[[group_col, drop = TRUE]])

  expressed_sender <- nichenetr::get_expressed_genes(sender_level, obj, pct = expression_pct, assay_oi = assay_use)
  expressed_receiver <- nichenetr::get_expressed_genes(receiver_level, obj, pct = expression_pct, assay_oi = assay_use)

  ligands <- unique(as.character(lr_network$from))
  receptors <- unique(as.character(lr_network$to))

  expressed_ligands <- intersect(ligands, expressed_sender)
  expressed_receptors <- intersect(receptors, expressed_receiver)

  if (!length(expressed_ligands)) stop("No ligands expressed in selected sender group.")
  if (!length(expressed_receptors)) stop("No receptors expressed in selected receiver group.")

  potential_ligands <- unique(as.character(lr_network$from[lr_network$from %in% expressed_ligands & lr_network$to %in% expressed_receptors]))
  if (!length(potential_ligands)) stop("No potential ligands found for the selected sender/receiver pair.")

  de <- Seurat::FindMarkers(
    object = obj,
    ident.1 = receiver_level,
    group.by = group_col,
    min.pct = expression_pct,
    assay = assay_use
  )
  de$gene <- rownames(de)

  fc_col <- if ("avg_log2FC" %in% colnames(de)) "avg_log2FC" else if ("avg_logFC" %in% colnames(de)) "avg_logFC" else colnames(de)[1]
  geneset_oi <- as.character(de$gene[de$p_val_adj <= 0.05 & abs(de[[fc_col]]) >= lfc_cutoff])
  geneset_oi <- intersect(geneset_oi, rownames(ligand_target_matrix))
  if (!length(geneset_oi)) {
    vf <- tryCatch(Seurat::VariableFeatures(obj), error = function(e) character(0))
    geneset_oi <- intersect(vf, rownames(ligand_target_matrix))
  }
  if (!length(geneset_oi)) stop("No geneset available for NicheNet ligand activity analysis.")

  background_expressed_genes <- intersect(expressed_receiver, rownames(ligand_target_matrix))
  if (!length(background_expressed_genes)) stop("No receiver background genes overlap with NicheNet ligand-target matrix.")

  ligand_activities <- nichenetr::predict_ligand_activities(
    geneset = geneset_oi,
    background_expressed_genes = background_expressed_genes,
    ligand_target_matrix = ligand_target_matrix,
    potential_ligands = potential_ligands
  )
  ligand_activities <- ligand_activities[order(ligand_activities$aupr_corrected, decreasing = TRUE), , drop = FALSE]

  best_upstream_ligands <- unique(utils::head(as.character(ligand_activities$test_ligand), max(1L, as.integer(top_ligands))))

  active_ligand_target_links_df <- do.call(rbind, lapply(best_upstream_ligands, function(lg) {
    nichenetr::get_weighted_ligand_target_links(
      ligand = lg,
      geneset = geneset_oi,
      ligand_target_matrix = ligand_target_matrix,
      n = max(50L, as.integer(top_targets))
    )
  }))
  active_ligand_target_links_df <- .nichenet_safe_df(active_ligand_target_links_df)

  vis_ligand_target <- NULL
  if (nrow(active_ligand_target_links_df)) {
    active_ligand_target_links_df <- active_ligand_target_links_df[stats::complete.cases(active_ligand_target_links_df), , drop = FALSE]
    if (nrow(active_ligand_target_links_df)) {
      vis_ligand_target <- nichenetr::prepare_ligand_target_visualization(
        ligand_target_df = active_ligand_target_links_df,
        ligand_target_matrix = ligand_target_matrix,
        cutoff = 0.33
      )
    }
  }
  if (is.null(vis_ligand_target) || !is.matrix(vis_ligand_target)) {
    vis_ligand_target <- matrix(0, nrow = 1, ncol = 1, dimnames = list("NoTarget", "NoLigand"))
  }

  weighted_networks_lr <- weighted_networks$lr_sig
  if (!is.null(weighted_networks_lr)) {
    weighted_networks_lr <- dplyr::inner_join(weighted_networks_lr, dplyr::distinct(lr_network, from, to), by = c("from", "to"))
  } else {
    weighted_networks_lr <- data.frame(from = character(0), to = character(0), weight = numeric(0), stringsAsFactors = FALSE)
  }

  lr_network_top_df_large <- dplyr::filter(weighted_networks_lr, from %in% best_upstream_ligands, to %in% expressed_receptors)
  if (!nrow(lr_network_top_df_large)) {
    lr_network_top_df_large <- data.frame(from = best_upstream_ligands, to = rep(receiver_level, length(best_upstream_ligands)), weight = 1, stringsAsFactors = FALSE)
  }

  lr_top <- .nichenet_lr_matrix_from_df(lr_network_top_df_large)

  list(
    ligand_activities = ligand_activities,
    top_ligands = best_upstream_ligands,
    top_targets = unique(as.character(active_ligand_target_links_df$target %||% character(0))),
    top_receptors = unique(as.character(lr_network_top_df_large$to)),
    ligand_target_matrix = vis_ligand_target,
    ligand_target_df = active_ligand_target_links_df,
    ligand_receptor_matrix = lr_top,
    ligand_receptor_df = data.frame(ligand = as.character(lr_network_top_df_large$from), receptor = as.character(lr_network_top_df_large$to), weight = as.numeric(lr_network_top_df_large$weight), stringsAsFactors = FALSE),
    geneset_oi = geneset_oi,
    background_expressed_genes = background_expressed_genes
  )
}

nichenet_beta_run <- function(
  sobj,
  group_col,
  sender_level,
  receiver_level,
  species = "human",
  assay = NULL,
  condition_col = "",
  condition_case = "",
  condition_control = "",
  top_ligands = 30L,
  top_targets = 200L,
  expression_pct = 0.1,
  lfc_cutoff = 0.25
) {
  if (!requireNamespace("nichenetr", quietly = TRUE)) stop("Package 'nichenetr' is not available in the active environment.")
  if (!inherits(sobj, "Seurat")) stop("Input object must be a Seurat object.")

  md <- sobj@meta.data
  if (!(group_col %in% colnames(md))) stop("Group column not found in metadata.")
  grp <- as.character(md[[group_col]])
  grp[is.na(grp) | !nzchar(grp)] <- "Unknown"
  if (!(sender_level %in% grp)) stop("Selected sender group has zero cells.")
  if (!(receiver_level %in% grp)) stop("Selected receiver group has zero cells.")

  resources <- nichenet_beta_load_resources(species)

  assay_use <- as.character(assay %||% "")
  aa <- nichenet_beta_assays(sobj)
  if (!nzchar(assay_use) || !(assay_use %in% aa)) assay_use <- nichenet_beta_default_assay(sobj)
  if (!nzchar(assay_use)) stop("Could not determine assay for NicheNet.")

  obj <- sobj
  Seurat::DefaultAssay(obj) <- assay_use
  obj <- Seurat::SetIdent(obj, value = obj[[group_col, drop = TRUE]])

  cond_ok <- nzchar(condition_col) && condition_col %in% colnames(obj@meta.data) && nzchar(condition_case) && nzchar(condition_control) && !identical(condition_case, condition_control)

  res <- if (isTRUE(cond_ok)) {
    nichenetr::nichenet_seuratobj_aggregate(
      receiver = receiver_level,
      seurat_obj = obj,
      condition_colname = condition_col,
      condition_oi = condition_case,
      condition_reference = condition_control,
      sender = sender_level,
      ligand_target_matrix = resources$ligand_target_matrix,
      lr_network = resources$lr_network,
      weighted_networks = resources$weighted_networks,
      assay_oi = assay_use,
      expression_pct = as.numeric(expression_pct %||% 0.1),
      lfc_cutoff = as.numeric(lfc_cutoff %||% 0.25),
      top_n_ligands = max(1L, as.integer(top_ligands %||% 30L)),
      top_n_targets = max(20L, as.integer(top_targets %||% 200L)),
      verbose = FALSE
    )
  } else {
    .nichenet_manual_fallback(
      sobj = obj,
      group_col = group_col,
      sender_level = sender_level,
      receiver_level = receiver_level,
      assay_use = assay_use,
      ligand_target_matrix = resources$ligand_target_matrix,
      lr_network = resources$lr_network,
      weighted_networks = resources$weighted_networks,
      top_ligands = top_ligands,
      top_targets = top_targets,
      expression_pct = expression_pct,
      lfc_cutoff = lfc_cutoff
    )
  }

  lig <- .nichenet_safe_df(res$ligand_activities)
  if (!nrow(lig) && !is.null(res$top_ligands)) {
    lig <- data.frame(test_ligand = as.character(res$top_ligands), aupr_corrected = seq_along(res$top_ligands), stringsAsFactors = FALSE)
  }

  lig_col <- if ("test_ligand" %in% colnames(lig)) "test_ligand" else if ("ligand" %in% colnames(lig)) "ligand" else colnames(lig)[1]
  sc_col <- if ("aupr_corrected" %in% colnames(lig)) "aupr_corrected" else if ("pearson" %in% colnames(lig)) "pearson" else colnames(lig)[2]
  ligand_rank <- data.frame(
    ligand = as.character(lig[[lig_col]]),
    score = suppressWarnings(as.numeric(lig[[sc_col]])),
    stringsAsFactors = FALSE
  )
  ligand_rank <- ligand_rank[is.finite(ligand_rank$score), , drop = FALSE]
  ligand_rank <- ligand_rank[order(ligand_rank$score, decreasing = TRUE), , drop = FALSE]
  ligand_rank <- utils::head(ligand_rank, max(1L, as.integer(top_ligands %||% 30L)))

  lt <- res$ligand_target_matrix
  if (is.null(lt) || !is.matrix(lt)) {
    lt <- matrix(0, nrow = 1, ncol = 1, dimnames = list("NoTarget", "NoLigand"))
  }

  lrd <- .nichenet_safe_df(res$ligand_receptor_df)
  if (!nrow(lrd)) {
    lrd <- data.frame(ligand = ligand_rank$ligand, receptor = receiver_level, weight = ligand_rank$score, stringsAsFactors = FALSE)
  }

  sender_receiver_pairs <- data.frame(
    sender = sender_level,
    receiver = receiver_level,
    score = as.numeric(lrd$weight %||% rep(1, nrow(lrd))),
    ligand = as.character(lrd$ligand %||% rep("", nrow(lrd))),
    receptor = as.character(lrd$receptor %||% rep("", nrow(lrd))),
    stringsAsFactors = FALSE
  )
  sender_receiver_pairs <- sender_receiver_pairs[order(sender_receiver_pairs$score, decreasing = TRUE), , drop = FALSE]
  sender_receiver_pairs <- utils::head(sender_receiver_pairs, 60)

  pathway_like <- if (nrow(lrd)) {
    agg <- stats::aggregate(weight ~ receptor, data = data.frame(receptor = as.character(lrd$receptor), weight = as.numeric(lrd$weight)), FUN = sum, na.rm = TRUE)
    colnames(agg) <- c("name", "score")
    agg <- agg[order(agg$score, decreasing = TRUE), , drop = FALSE]
    utils::head(agg, 20)
  } else {
    data.frame(name = character(0), score = numeric(0), stringsAsFactors = FALSE)
  }

  setup <- .nichenet_group_counts(sobj, group_col, sender_level, receiver_level)

  list(
    assay = assay_use,
    species = species,
    group_col = group_col,
    sender = sender_level,
    receiver = receiver_level,
    condition_mode = if (isTRUE(cond_ok)) "condition_contrast" else "receiver_vs_rest",
    resources = resources$status,
    setup = setup,
    ligand_rank = ligand_rank,
    ligand_target = lt,
    sender_receiver_pairs = sender_receiver_pairs,
    pathway_like = pathway_like,
    raw_result = res
  )
}

# Backward-compatible alias retained for existing interface calls.
nichenet_beta_preview <- function(sobj, group_col, sender_level, receiver_level, top_ligands = 30L, condition_col = "", condition_case = "", condition_control = "", species = "human", assay = NULL) {
  nichenet_beta_run(
    sobj = sobj,
    group_col = group_col,
    sender_level = sender_level,
    receiver_level = receiver_level,
    species = species,
    assay = assay,
    condition_col = condition_col,
    condition_case = condition_case,
    condition_control = condition_control,
    top_ligands = top_ligands
  )
}
