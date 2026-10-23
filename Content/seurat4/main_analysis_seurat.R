library(plotly)
library(patchwork)
# MAIN ANALYSIS MODULE FOR SEURAT4 #
`%||%` <- function(a, b) if (is.null(a)) b else a

#' Run a selected normalization method on a Seurat object
#'
#' @param seurat_obj The merged, filtered Seurat object from QC.
#' @param method The method to use: "SCT" or "LogNormalize".
#' @return The normalized Seurat object, ready for downstream analysis.
run_normalization <- function(seurat_obj, method) {
  message(paste("--- Running Normalization using method:", method, "---"))
  # --- THIS IS THE FIX ---
  # Increase the maximum size for global variables in parallel processing.
  # Your object requires over 731 MiB, so we'll set the limit to 1500 MiB.
  # The value is in bytes (1500 * 1024^2).
  options(future.globals.maxSize = 1500 * 1024^2)
  # --- END OF FIX ---
  
  if (method == "SCT") {
    # SCTransform also finds variable features and can account for mitochondrial percentage
    seurat_obj <- SCTransform(seurat_obj, vars.to.regress = "percent.mt", verbose = FALSE)
    message("  - SCTransform complete.")
  } else {
    # The conventional LogNormalize workflow
    seurat_obj <- NormalizeData(seurat_obj, verbose = FALSE)
    seurat_obj <- FindVariableFeatures(seurat_obj, verbose = FALSE)
    seurat_obj <- ScaleData(seurat_obj, verbose = FALSE)
    message("  - LogNormalize, FindVariableFeatures, and ScaleData complete.")
  }
  
  # Run PCA - this is common to both workflows
  message("  - Running PCA...")
  seurat_obj <- RunPCA(seurat_obj, npcs = 50, verbose = FALSE)
  
  # Agent note: PCA remains part of normalization for downstream analysis, but
  # elbow generation is user-triggered from the missing-plot card so this run
  # never spends time rendering a plot in the background.
  return(list(
    object = seurat_obj,
    elbow_plot = NULL
  ))
}


# Ensure other necessary libraries are loaded if not already.

#' Run data integration on a Seurat object using one of several methods.
#'
#' @param seurat_obj A merged Seurat object containing multiple samples,
#'   identified by the 'sample_name' column in the metadata.
#' @param method A string indicating the integration method to use.
#'   Valid options are: "CCA", "RPCA", "SCT", "Harmony".
#' @return A single, integrated Seurat object.
library(harmony)

.sanitize_barcode_alias <- function(x, max_len = 8L) {
  y <- toupper(trimws(as.character(x %||% "")))
  y <- gsub("[^A-Z0-9]", "", y)
  if (!nzchar(y)) y <- "SMP"
  substr(y, 1L, max(1L, as.integer(max_len %||% 8L)))
}

.make_unique_barcode_aliases <- function(x, max_len = 8L) {
  max_len <- max(1L, as.integer(max_len %||% 8L))
  used <- character(0)
  out <- character(length(x))
  for (i in seq_along(x)) {
    base <- .sanitize_barcode_alias(x[[i]], max_len = max_len)
    cand <- base
    k <- 1L
    while (cand %in% used) {
      k <- k + 1L
      suffix <- as.character(k)
      keep <- max(1L, max_len - nchar(suffix))
      cand <- paste0(substr(base, 1L, keep), suffix)
    }
    out[[i]] <- cand
    used <- c(used, cand)
  }
  out
}

.apply_barcode_suffixes <- function(seurat_obj, integrate_by, barcode_suffix = list()) {
  opts <- barcode_suffix %||% list()
  if (!isTRUE(opts$enabled)) return(seurat_obj)

  delim <- as.character(opts$delimiter %||% "_")
  if (!nzchar(delim)) delim <- "_"
  alias_by <- as.character(opts$alias_by %||% integrate_by)
  max_len <- max(1L, as.integer(opts$alias_max_len %||% 10L))

  md <- seurat_obj@meta.data
  if (!alias_by %in% colnames(md)) {
    stop("barcode_suffix alias source column not found: ", alias_by)
  }

  source_vals <- as.character(md[[alias_by]])
  groups <- unique(source_vals)
  map_in <- opts$alias_map %||% list()
  if (is.atomic(map_in)) map_in <- as.list(map_in)
  if (!is.list(map_in)) map_in <- list()
  map_in <- map_in[!is.na(names(map_in)) & nzchar(names(map_in))]

  raw_aliases <- vapply(groups, function(g) {
    hit <- map_in[[g]]
    if (!is.null(hit) && length(hit)) return(as.character(hit[[1]]))
    g
  }, character(1))
  aliases <- .make_unique_barcode_aliases(raw_aliases, max_len = max_len)
  alias_lookup <- setNames(aliases, groups)
  per_cell_alias <- unname(alias_lookup[source_vals])

  old_names <- colnames(seurat_obj)
  new_names <- paste0(old_names, delim, per_cell_alias)
  if (anyDuplicated(new_names)) {
    stop("barcode_suffix generated duplicated cell names; please provide a stricter alias_map.")
  }

  # SeuratObject 4.x requires RenameCells to update all cell-keyed slots;
  # direct colnames<- assignment is not reliable for Seurat objects.
  seurat_obj <- SeuratObject::RenameCells(object = seurat_obj, new.names = new_names)
  seurat_obj$barcode_suffix_alias <- per_cell_alias
  seurat_obj$barcode_suffix_source <- source_vals
  seurat_obj@misc$barcode_suffix <- list(
    enabled = TRUE,
    delimiter = delim,
    alias_by = alias_by,
    alias_map = as.list(alias_lookup),
    applied_at = as.character(Sys.time())
  )
  seurat_obj
}

.integration_pca_features <- function(seurat_obj, max_features = 3000L) {
  feats <- VariableFeatures(seurat_obj)
  if (!length(feats)) {
    feats <- tryCatch(
      {
        all_feats <- rownames(seurat_obj)
        if (!length(all_feats)) return(character(0))
        all_feats[seq_len(min(length(all_feats), as.integer(max_features)))]
      },
      error = function(e) character(0)
    )
  }
  if (length(feats) > as.integer(max_features)) {
    feats <- feats[seq_len(as.integer(max_features))]
  }
  as.character(feats)
}

.integration_dims <- function(object_list, feature_count, maximum = 30L) {
  cell_counts <- vapply(object_list, ncol, integer(1))
  rank_limit <- min(c(cell_counts, as.integer(feature_count))) - 1L
  if (!is.finite(rank_limit) || rank_limit < 2L) {
    stop(
      "Integration requires at least three cells per group and three shared features; smallest group has ",
      min(cell_counts), " cell(s)."
    )
  }
  seq_len(min(as.integer(maximum), rank_limit))
}

.safe_pca_npcs <- function(seurat_obj, feature_count, maximum = 50L) {
  rank_limit <- min(ncol(seurat_obj), as.integer(feature_count)) - 1L
  if (!is.finite(rank_limit) || rank_limit < 2L) {
    stop("PCA requires at least three cells and three usable features.")
  }
  min(as.integer(maximum), rank_limit)
}

.integration_k_weight <- function(anchorset, default = 100L) {
  anchors <- tryCatch(anchorset@anchors, error = function(e) NULL)
  required <- c("cell1", "cell2", "dataset1", "dataset2")
  if (is.null(anchors) || !is.data.frame(anchors) || !all(required %in% colnames(anchors))) {
    stop("Integration anchors are missing dataset-pair metadata required to choose k.weight safely.")
  }
  if (!nrow(anchors)) stop("Integration found no usable anchors between selected groups.")

  pair_id <- paste(anchors$dataset1, anchors$dataset2, sep = ":")
  pair_anchor_cells <- vapply(split(anchors, pair_id), function(pair) {
    min(length(unique(pair$cell1)), length(unique(pair$cell2)))
  }, integer(1))
  min_pair_anchor_cells <- min(pair_anchor_cells)
  if (!is.finite(min_pair_anchor_cells) || min_pair_anchor_cells < 2L) {
    stop("Integration found fewer than two unique anchor cells for at least one dataset pair.")
  }

  # Agent note: Seurat weights unique anchor cells, not anchor rows. Duplicate
  # anchor rows can otherwise overstate capacity and reproduce idx replacement
  # errors even after k.weight is bounded by the raw anchor-row count.
  selected <- min(as.integer(default), min_pair_anchor_cells - 1L)
  message(
    "  - Anchor-cell capacity by dataset pair: ",
    paste(names(pair_anchor_cells), pair_anchor_cells, sep = "=", collapse = ", "),
    "; selected k.weight=", selected
  )
  selected
}

.integration_progress_report <- function(progress_cb,
                                         stage,
                                         completed = NULL,
                                         total = NULL,
                                         detail = NULL) {
  if (!is.function(progress_cb)) return(invisible(NULL))
  progress_cb(
    stage = as.character(stage),
    completed = completed,
    total = total,
    detail = detail
  )
  invisible(NULL)
}

run_integration <- function(
  seurat_obj,
  method,
  integrate_by,
  barcode_suffix = list(enabled = FALSE, delimiter = "_"),
  progress_cb = NULL,
  reference_datasets = character(0)
) {
  reference_datasets <- unique(as.character(reference_datasets %||% character(0)))
  reference_datasets <- reference_datasets[!is.na(reference_datasets) & nzchar(reference_datasets)]
  if (length(reference_datasets) && !identical(method, "RPCA")) {
    stop("Selected reference datasets are supported only for RPCA integration.")
  }
  
  .integration_progress_report(
    progress_cb,
    stage = "starting",
    completed = 0L,
    total = 1L,
    detail = paste("Starting data integration using method:", method)
  )
  message(paste("--- Starting data integration using method:", method, "---"))
  
  # Increase the parallel processing memory limit, as integration can be memory-intensive.
  options(future.globals.maxSize = 2000 * 1024^2) # 2000 MiB limit
  if (!(integrate_by %in% colnames(seurat_obj@meta.data))) {
    stop(paste0("Integration column '", integrate_by, "' was not found in metadata."))
  }
  if (length(unique(seurat_obj[[integrate_by, drop = TRUE]])) < 2) {
    stop(paste0(
      "Integration requires at least two groups in '",
      integrate_by,
      "'."
    ))
  }
  seurat_obj <- .apply_barcode_suffixes(
    seurat_obj = seurat_obj,
    integrate_by = integrate_by,
    barcode_suffix = barcode_suffix
  )
  
  # The SCT workflow is different and must be handled first.
  if (method == "SCT") {
    if (!("RNA" %in% Assays(seurat_obj))) {
      stop("SCT integration requires an RNA assay containing source counts.")
    }
    # Agent note: Re-integration may receive an object whose DefaultAssay is
    # integrated. SCT must always restart from RNA counts, never corrected data.
    DefaultAssay(seurat_obj) <- "RNA"
    
    message("  - Splitting object by sample for SCTransform...")
    .integration_progress_report(
      progress_cb,
      stage = "split",
      completed = 0L,
      total = 1L,
      detail = "Splitting object by sample."
    )
    obj_list <- SplitObject(seurat_obj, split.by = integrate_by)
    .integration_progress_report(
      progress_cb,
      stage = "split",
      completed = 1L,
      total = 1L,
      detail = sprintf("Split object into %d samples.", length(obj_list))
    )
    
    message("  - Performing SCTransform on each sample...")
    sample_total <- length(obj_list)
    .integration_progress_report(
      progress_cb,
      stage = "sample_preprocessing",
      completed = 0L,
      total = sample_total,
      detail = sprintf("Preparing %d samples with SCTransform.", sample_total)
    )
    obj_list <- lapply(seq_along(obj_list), function(i) {
      x <- obj_list[[i]]
      DefaultAssay(x) <- "RNA"
      x <- SCTransform(x, assay = "RNA", verbose = FALSE)
      .integration_progress_report(
        progress_cb,
        stage = "sample_preprocessing",
        completed = i,
        total = sample_total,
        detail = sprintf("SCTransform sample %d of %d.", i, sample_total)
      )
      x
    })
    
    message("  - Selecting integration features and preparing anchors...")
    .integration_progress_report(
      progress_cb,
      stage = "feature_setup",
      completed = 0L,
      total = 2L,
      detail = "Selecting integration features."
    )
    integ_features <- SelectIntegrationFeatures(object.list = obj_list, nfeatures = 3000)
    .integration_progress_report(
      progress_cb,
      stage = "feature_setup",
      completed = 1L,
      total = 2L,
      detail = "Preparing SCTransform integration anchors."
    )
    obj_list <- PrepSCTIntegration(object.list = obj_list, anchor.features = integ_features)
    integration_dims <- .integration_dims(obj_list, length(integ_features))
    .integration_progress_report(
      progress_cb,
      stage = "feature_setup",
      completed = 2L,
      total = 2L,
      detail = "Integration features and anchor preparation complete."
    )
    
    message("  - Finding integration anchors...")
    .integration_progress_report(
      progress_cb,
      stage = "anchor_search",
      completed = 0L,
      total = 1L,
      detail = "Finding integration anchors."
    )
    integ_anchors <- FindIntegrationAnchors(
      object.list = obj_list,
      normalization.method = "SCT",
      anchor.features = integ_features,
      dims = integration_dims
    )
    .integration_progress_report(
      progress_cb,
      stage = "anchor_search",
      completed = 1L,
      total = 1L,
      detail = "Integration anchors found."
    )
    
    message("  - Integrating data...")
    .integration_progress_report(
      progress_cb,
      stage = "integration_data",
      completed = 0L,
      total = 1L,
      detail = "Integrating data."
    )
    k_weight <- .integration_k_weight(integ_anchors)
    message("  - Using integration k.weight: ", k_weight)
    seurat_integrated <- tryCatch(
      IntegrateData(
        anchorset = integ_anchors,
        normalization.method = "SCT",
        dims = integration_dims,
        k.weight = k_weight
      ),
      error = function(e) {
        stop("IntegrateData failed with adaptive k.weight=", k_weight, ": ", conditionMessage(e))
      }
    )
    .integration_progress_report(
      progress_cb,
      stage = "integration_data",
      completed = 1L,
      total = 1L,
      detail = "Integrated data."
    )
    
    # Set the default assay to the new 'integrated' assay for downstream steps
    DefaultAssay(seurat_integrated) <- "integrated"
    
  } else {
    # This block handles CCA, RPCA, and Harmony, which share a similar starting point.
    # Set the default assay to "RNA" to ensure we work on raw counts.
    DefaultAssay(seurat_obj) <- "RNA"
    
    message("  - Splitting object by sample...")
    .integration_progress_report(
      progress_cb,
      stage = "split",
      completed = 0L,
      total = 1L,
      detail = "Splitting object by sample."
    )
    obj_list <- SplitObject(seurat_obj, split.by = integrate_by)
    .integration_progress_report(
      progress_cb,
      stage = "split",
      completed = 1L,
      total = 1L,
      detail = sprintf("Split object into %d samples.", length(obj_list))
    )
    
    message("  - Performing standard normalization and feature selection for each sample...")
    sample_total <- length(obj_list)
    .integration_progress_report(
      progress_cb,
      stage = "sample_preprocessing",
      completed = 0L,
      total = sample_total,
      detail = sprintf("Normalizing and selecting features for %d samples.", sample_total)
    )
    obj_list <- lapply(seq_along(obj_list), function(i) {
      x <- obj_list[[i]]
      x <- NormalizeData(x, verbose = FALSE)
      x <- FindVariableFeatures(x, selection.method = "vst", nfeatures = 2000, verbose = FALSE)
      .integration_progress_report(
        progress_cb,
        stage = "sample_preprocessing",
        completed = i,
        total = sample_total,
        detail = sprintf("Normalized and selected features for sample %d of %d.", i, sample_total)
      )
      x
    })
    
    if (method %in% c("CCA", "RPCA")) {
      
      message("  - Selecting integration features...")
      .integration_progress_report(
        progress_cb,
        stage = "feature_setup",
        completed = 0L,
        total = 1L,
        detail = "Selecting integration features."
      )
      integ_features <- SelectIntegrationFeatures(object.list = obj_list)
      integration_dims <- .integration_dims(obj_list, length(integ_features))
      .integration_progress_report(
        progress_cb,
        stage = "feature_setup",
        completed = 1L,
        total = 1L,
        detail = "Integration features selected."
      )
      if (method == "RPCA") {
        message("  - Running per-sample scaling/PCA required by RPCA anchors...")
        .integration_progress_report(
          progress_cb,
          stage = "method_preparation",
          completed = 0L,
          total = sample_total,
          detail = sprintf("Scaling and running PCA for %d samples.", sample_total)
        )
        obj_list <- lapply(seq_along(obj_list), function(i) {
          x <- obj_list[[i]]
          x <- ScaleData(x, features = integ_features, verbose = FALSE)
          x <- RunPCA(
            x,
            features = integ_features,
            npcs = max(integration_dims),
            verbose = FALSE
          )
          .integration_progress_report(
            progress_cb,
            stage = "method_preparation",
            completed = i,
            total = sample_total,
            detail = sprintf("Scaled and ran PCA for sample %d of %d.", i, sample_total)
          )
          x
        })
      }
      
      # Determine the correct reduction method for FindIntegrationAnchors
      reduction_method <- if (method == "RPCA") "rpca" else "cca"
      message(paste("  - Finding integration anchors using method:", reduction_method, "..."))
      # Agent note: Seurat expects reference dataset indices after SplitObject;
      # leave this NULL for the existing all-pairwise behavior.
      reference_indices <- NULL
      if (length(reference_datasets)) {
        missing_references <- setdiff(reference_datasets, names(obj_list))
        if (length(missing_references)) {
          stop(
            "Selected reference dataset(s) were not found after splitting by '",
            integrate_by,
            "': ",
            paste(missing_references, collapse = ", ")
          )
        }
        reference_indices <- match(reference_datasets, names(obj_list))
        if (length(reference_indices) < 2L) {
          stop("RPCA reference integration requires at least two reference datasets.")
        }
        message("  - Using selected RPCA reference datasets: ", paste(reference_datasets, collapse = ", "))
      }
      .integration_progress_report(
        progress_cb,
        stage = "anchor_search",
        completed = 0L,
        total = 1L,
        detail = sprintf("Finding integration anchors using %s.", toupper(reduction_method))
      )
      integ_anchors <- FindIntegrationAnchors(
        object.list = obj_list,
        anchor.features = integ_features,
        reduction = reduction_method,
        dims = integration_dims,
        reference = reference_indices
      )
      .integration_progress_report(
        progress_cb,
        stage = "anchor_search",
        completed = 1L,
        total = 1L,
        detail = "Integration anchors found."
      )
      
      message("  - Integrating data...")
      .integration_progress_report(
        progress_cb,
        stage = "integration_data",
        completed = 0L,
        total = 1L,
        detail = "Integrating data."
      )
      k_weight <- .integration_k_weight(integ_anchors)
      message("  - Using integration k.weight: ", k_weight)
      seurat_integrated <- tryCatch(
        IntegrateData(
          anchorset = integ_anchors,
          dims = integration_dims,
          k.weight = k_weight
        ),
        error = function(e) {
          stop("IntegrateData failed with adaptive k.weight=", k_weight, ": ", conditionMessage(e))
        }
      )
      .integration_progress_report(
        progress_cb,
        stage = "integration_data",
        completed = 1L,
        total = 1L,
        detail = "Integrated data."
      )
      
      DefaultAssay(seurat_integrated) <- "integrated"
      
    } else if (method == "Harmony") {
      
      # Harmony requires a single, merged object with PCA run first.
      message("  - Merging objects and running initial PCA for Harmony...")
      .integration_progress_report(
        progress_cb,
        stage = "method_preparation",
        completed = 0L,
        total = 4L,
        detail = "Preparing PCA for Harmony."
      )
      # We can use the original object as it has all the cells
      seurat_obj <- NormalizeData(seurat_obj, verbose = FALSE)
      .integration_progress_report(progress_cb, "method_preparation", 1L, 4L, "Normalized data for Harmony.")
      seurat_obj <- FindVariableFeatures(seurat_obj, verbose = FALSE)
      .integration_progress_report(progress_cb, "method_preparation", 2L, 4L, "Selected variable features for Harmony.")
      h_feats <- .integration_pca_features(seurat_obj, max_features = 3000L)
      if (!length(h_feats)) stop("No features available for Harmony PCA.")
      seurat_obj <- ScaleData(seurat_obj, features = h_feats, verbose = FALSE)
      .integration_progress_report(progress_cb, "method_preparation", 3L, 4L, "Scaled data for Harmony PCA.")
      harmony_npcs <- .safe_pca_npcs(seurat_obj, length(h_feats))
      seurat_obj <- RunPCA(seurat_obj, features = h_feats, npcs = harmony_npcs, verbose = FALSE)
      .integration_progress_report(progress_cb, "method_preparation", 4L, 4L, "Initial PCA for Harmony complete.")
      
      message("  - Running Harmony algorithm...")
      .integration_progress_report(
        progress_cb,
        stage = "harmony_run",
        completed = 0L,
        total = 1L,
        detail = "Running Harmony algorithm."
      )
      # Run Harmony on the selected integration grouping variable.
      seurat_integrated <- RunHarmony(seurat_obj, group.by.vars = integrate_by, assay.use = "RNA")
      .integration_progress_report(
        progress_cb,
        stage = "harmony_run",
        completed = 1L,
        total = 1L,
        detail = "Harmony algorithm complete."
      )
      # For Harmony, you typically proceed with the original "RNA" assay for downstream analysis,
      # but use the new "harmony" reduction for UMAP and clustering.
      DefaultAssay(seurat_integrated) <- "RNA"
    }
  }
  
  if (is.null(seurat_integrated)) {
    stop("The integration process failed and did not produce a valid Seurat object.")
  }
  
  # Final common steps for all methods except Harmony (which already did this)
  if (method != "Harmony") {
    message("  - Scaling data and running PCA on integrated assay...")
    .integration_progress_report(
      progress_cb,
      stage = "post_integration_pca",
      completed = 0L,
      total = 2L,
      detail = "Scaling integrated data."
    )
    pca_feats <- .integration_pca_features(seurat_integrated, max_features = 3000L)
    if (!length(pca_feats)) stop("No features available for post-integration PCA.")
    seurat_integrated <- ScaleData(seurat_integrated, features = pca_feats, verbose = FALSE)
    .integration_progress_report(
      progress_cb,
      stage = "post_integration_pca",
      completed = 1L,
      total = 2L,
      detail = "Scaled integrated data."
    )
    post_npcs <- .safe_pca_npcs(seurat_integrated, length(pca_feats))
    seurat_integrated <- RunPCA(
      seurat_integrated,
      features = pca_feats,
      npcs = post_npcs,
      verbose = FALSE
    )
    .integration_progress_report(
      progress_cb,
      stage = "post_integration_pca",
      completed = 2L,
      total = 2L,
      detail = "Integrated PCA complete."
    )
  } else {
    .integration_progress_report(
      progress_cb,
      stage = "post_integration_pca",
      completed = 2L,
      total = 2L,
      detail = "Harmony output is ready."
    )
  }
  
  .integration_progress_report(
    progress_cb,
    stage = "complete",
    completed = 1L,
    total = 1L,
    detail = "Integration complete."
  )
  message("--- Integration complete! ---")
  return(list(
    object = seurat_integrated,
    # Agent note: Keep integration output plot-free; the Analysis page owns
    # the explicit Generate elbow plot action and creates it only on click.
    elbow_plot = NULL
  ))
}


#' Run downstream analysis (clustering, UMAP) on a normalized object
#'
#' @param seurat_obj A Seurat object that has already been normalized and had PCA run.
#' @param analysis_params A list of parameters from the UI (PCs, resolution).
#' @param output_dir Directory to save the final plot.
#' @return A list containing the final object and the plot path.
run_main_analysis <- function(seurat_obj, analysis_params) {
  message("--- Running Clustering and UMAP ---")
  
  # The object is already scaled and has PCA, so we proceed to clustering
  message("  - Finding neighbors and clusters...")
  seurat_obj <- FindNeighbors(seurat_obj, dims = 1:analysis_params$num_pcs)
  seurat_obj <- FindClusters(seurat_obj, resolution = analysis_params$resolution)
  
  message("  - Running UMAP...")
  seurat_obj <- RunUMAP(seurat_obj, dims = 1:analysis_params$num_pcs,seed.use = analysis_params$umap_seed)
  plot_title_suffix <- paste("(Seed:", analysis_params$umap_seed, ")")
  message("  - Generating final UMAP plot object...")
  # Create the plot object. We can group by seurat_clusters, sample_name, or condition.
  # Let's create two plots and combine them.
  clusters <- DimPlot(seurat_obj, reduction = "umap", label = TRUE, group.by = "seurat_clusters") + ggtitle("UMAP by Cluster")+ 
    ggtitle("UMAP by Cluster", subtitle = plot_title_suffix)
  conditions <- DimPlot(seurat_obj, reduction = "umap", group.by = "orig.ident") + ggtitle("UMAP by Sample")+ 
    ggtitle("UMAP by Condition", subtitle = plot_title_suffix)
  
  message("--- Main analysis complete! ---")
  return(list(
    clusters = clusters,
    conditions = conditions,
    final_object = seurat_obj
  ))
}

run_heatmap <- function(seurat_obj, heatmap_params) {
  message("--- Finding all markers to prepare for heatmap... ---")
  # Ensure the default assay is set correctly for finding markers.
  if ("integrated" %in% Assays(seurat_obj)) {
    DefaultAssay(seurat_obj) <- "integrated"
  } else if ("SCT" %in% Assays(seurat_obj)) {
    DefaultAssay(seurat_obj) <- "SCT"
  } else if ("RNA" %in% Assays(seurat_obj)) {
    DefaultAssay(seurat_obj) <- "RNA"
  } else {
    stop("No suitable assay found for heatmap marker detection (expected integrated, SCT, or RNA).")
  }
  default.assay <- DefaultAssay(seurat_obj)

  HEATMAP_NumGenes <- max(1L, as.integer(heatmap_params$num_genes %||% 5L))
  HEATMAP_MinPct <- as.numeric(heatmap_params$min_pct %||% 0.25)
  HEATMAP_LogFC <- as.numeric(heatmap_params$logfc_threshold %||% 0.25)
  HEATMAP_TestUse <- as.character(heatmap_params$test_use %||% "wilcox")

  library(dplyr) # for the %>%
  library(ggplot2) # for theme()
  all.genes <- rownames(seurat_obj)
  seurat_obj <- ScaleData(seurat_obj, features = all.genes, verbose = FALSE)
  all.markers <- FindAllMarkers(
    seurat_obj,
    only.pos = TRUE,
    min.pct = HEATMAP_MinPct,
    logfc.threshold = HEATMAP_LogFC,
    test.use = HEATMAP_TestUse
  )
  if (!nrow(all.markers)) {
    stop("No marker genes were found with current heatmap settings. Try lowering min.pct or logfc.threshold.")
  }
  all.markers %>%
    group_by(cluster) %>%
    slice_max(n = HEATMAP_NumGenes, order_by = avg_log2FC) -> TopGeneList
  all.markers %>%
    group_by(cluster) %>%
    slice_max(n = HEATMAP_NumGenes, order_by = avg_log2FC) -> topGenes

  heatmap_genes <- unique(topGenes$gene)
  heatmap_plot <- DoHeatmap(seurat_obj, features = heatmap_genes, raster = FALSE) +
    #NoLegend() +
    theme(text = element_text(size = 8))
  
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  output_dir <- file.path(here::here("../results","heatmaps_", timestamp))
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
  
  heatmap_path <- file.path(output_dir, paste0("Heatmap", timestamp, ".png"))
  message(paste("  - Saving heatmap to:", heatmap_path))
  heatmap_height <- length(unique(seurat_obj$seurat_clusters))*HEATMAP_NumGenes/10
  ggsave(heatmap_path, plot = heatmap_plot, width = heatmap_height*1.5, height = heatmap_height, dpi = 300, limitsize = FALSE)
  
  # --- Step 5: Manually calculate the average of the SCALED data ---
  # This is the definitive fix. We bypass AverageExpression entirely.
  message("  - Manually averaging scaled data for interactive heatmap...")
  
  # Get the scaled data for our top genes without passing v5-only args into v4 calls.
  ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
  scaled_data <- if ("layer" %in% ga_formals) {
    GetAssayData(seurat_obj, layer = "scale.data", assay = default.assay)
  } else {
    GetAssayData(seurat_obj, slot = "scale.data", assay = default.assay)
  }
  scaled_data <- scaled_data[heatmap_genes, , drop = FALSE]
  # Get the cluster identity for each cell
  cell_clusters <- seurat_obj$seurat_clusters
  
  # Use tapply to calculate the mean expression for each gene within each cluster
  avg_expression_list <- tapply(
    X = 1:ncol(scaled_data), 
    INDEX = cell_clusters, 
    FUN = function(i) rowMeans(scaled_data[, i, drop = FALSE])
  )
  
  # Combine the results into a matrix
  avg_expression <- do.call(cbind, avg_expression_list)
  return(list(
    heatmap_plot_path = heatmap_path,
    heatmap_gene_table = TopGeneList,
    avg_expression = avg_expression
  ))
}

run_heatmap_backup <- function(seurat_obj, n_top_genes = 10) {
  message("--- Finding all markers to prepare for interactive heatmap... ---")
  
  DefaultAssay(seurat_obj) <- "RNA"
  
  all_markers <- FindAllMarkers(seurat_obj, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25, verbose = FALSE)
  
  if (nrow(all_markers) == 0) {
    message("--- WARNING: No marker genes were found. Cannot generate heatmap. ---")
    return(NULL)
  }
  
  top_markers <- all_markers %>%
    group_by(cluster) %>%
    top_n(n = n_top_genes, wt = avg_log2FC)
  
  top_genes <- unique(top_markers$gene)
  message(paste("  - Found", length(top_genes), "unique top marker genes for average heatmap."))
  
  # Use the scaled data for the heatmap visualization
  assay_to_use <- if ("integrated" %in% Assays(seurat_obj)) "integrated" else if ("SCT" %in% Assays(seurat_obj)) "SCT" else "RNA"
  message(paste("  - Calculating average expression from the '", assay_to_use, "' assay's scaled data.", sep=""))
  
  ae_formals <- tryCatch(names(formals(Seurat::AverageExpression)), error = function(e) character(0))
  ae_args <- list(
    object = seurat_obj,
    features = top_genes,
    group.by = "seurat_clusters",
    assay = assay_to_use
  )
  if ("layer" %in% ae_formals) {
    ae_args$layer <- "scale.data"
  } else {
    ae_args$slot <- "scale.data"
  }
  avg_expression <- do.call(Seurat::AverageExpression, ae_args)[[assay_to_use]]
  
  message("--- Interactive heatmap data prepared successfully. ---")
  
  return(avg_expression)
}
