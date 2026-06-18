library(plotly)
library(patchwork)
# MAIN ANALYSIS MODULE FOR SEURAT4 #
`%||%` <- function(a, b) if (is.null(a)) b else a

.analysis_build_elbow_plot <- function(seurat_obj) {
  pca_dims <- suppressWarnings(tryCatch(
    ncol(Embeddings(seurat_obj, reduction = "pca")),
    error = function(e) NA_integer_
  ))
  if (is.finite(pca_dims) && !is.na(pca_dims) && pca_dims >= 1L) {
    return(ElbowPlot(seurat_obj, ndims = as.integer(pca_dims)))
  }
  ElbowPlot(seurat_obj)
}

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
  
  elbow_plot <- .analysis_build_elbow_plot(seurat_obj)
  return(list(
    object = seurat_obj,
    elbow_plot = elbow_plot
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
  max_len <- max(1L, as.integer(opts$alias_max_len %||% 8L))

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

  colnames(seurat_obj) <- new_names
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

run_integration <- function(seurat_obj, method, integrate_by, barcode_suffix = list(enabled = FALSE, delimiter = "_")) {
  
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
    
    message("  - Splitting object by sample for SCTransform...")
    obj_list <- SplitObject(seurat_obj, split.by = integrate_by)
    
    message("  - Performing SCTransform on each sample...")
    obj_list <- lapply(X = obj_list, FUN = SCTransform, verbose = FALSE)
    
    message("  - Selecting integration features and preparing anchors...")
    integ_features <- SelectIntegrationFeatures(object.list = obj_list, nfeatures = 3000)
    obj_list <- PrepSCTIntegration(object.list = obj_list, anchor.features = integ_features)
    
    message("  - Finding integration anchors...")
    integ_anchors <- FindIntegrationAnchors(object.list = obj_list, normalization.method = "SCT", anchor.features = integ_features)
    
    message("  - Integrating data...")
    seurat_integrated <- IntegrateData(anchorset = integ_anchors, normalization.method = "SCT")
    
    # Set the default assay to the new 'integrated' assay for downstream steps
    DefaultAssay(seurat_integrated) <- "integrated"
    
  } else {
    # This block handles CCA, RPCA, and Harmony, which share a similar starting point.
    # Set the default assay to "RNA" to ensure we work on raw counts.
    DefaultAssay(seurat_obj) <- "RNA"
    
    message("  - Splitting object by sample...")
    obj_list <- SplitObject(seurat_obj, split.by = integrate_by)
    
    message("  - Performing standard normalization and feature selection for each sample...")
    obj_list <- lapply(X = obj_list, FUN = function(x) {
      x <- NormalizeData(x, verbose = FALSE)
      x <- FindVariableFeatures(x, selection.method = "vst", nfeatures = 2000, verbose = FALSE)
      return(x)
    })
    
    if (method %in% c("CCA", "RPCA")) {
      
      message("  - Selecting integration features...")
      integ_features <- SelectIntegrationFeatures(object.list = obj_list)
      if (method == "RPCA") {
        message("  - Running per-sample scaling/PCA required by RPCA anchors...")
        obj_list <- lapply(X = obj_list, FUN = function(x) {
          x <- ScaleData(x, features = integ_features, verbose = FALSE)
          x <- RunPCA(x, features = integ_features, npcs = 50, verbose = FALSE)
          x
        })
      }
      
      # Determine the correct reduction method for FindIntegrationAnchors
      reduction_method <- if (method == "RPCA") "rpca" else "cca"
      message(paste("  - Finding integration anchors using method:", reduction_method, "..."))
      integ_anchors <- FindIntegrationAnchors(
        object.list = obj_list,
        anchor.features = integ_features,
        reduction = reduction_method
      )
      
      message("  - Integrating data...")
      seurat_integrated <- IntegrateData(anchorset = integ_anchors)
      
      DefaultAssay(seurat_integrated) <- "integrated"
      
    } else if (method == "Harmony") {
      
      # Harmony requires a single, merged object with PCA run first.
      message("  - Merging objects and running initial PCA for Harmony...")
      # We can use the original object as it has all the cells
      seurat_obj <- NormalizeData(seurat_obj, verbose = FALSE)
      seurat_obj <- FindVariableFeatures(seurat_obj, verbose = FALSE)
      h_feats <- .integration_pca_features(seurat_obj, max_features = 3000L)
      if (!length(h_feats)) stop("No features available for Harmony PCA.")
      seurat_obj <- ScaleData(seurat_obj, features = h_feats, verbose = FALSE)
      seurat_obj <- RunPCA(seurat_obj, features = h_feats, npcs = 50, verbose = FALSE)
      
      message("  - Running Harmony algorithm...")
      # Run Harmony on the selected integration grouping variable.
      seurat_integrated <- RunHarmony(seurat_obj, group.by.vars = integrate_by, assay.use = "RNA")
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
    pca_feats <- .integration_pca_features(seurat_integrated, max_features = 3000L)
    if (!length(pca_feats)) stop("No features available for post-integration PCA.")
    seurat_integrated <- ScaleData(seurat_integrated, features = pca_feats, verbose = FALSE)
    seurat_integrated <- RunPCA(seurat_integrated, features = pca_feats, npcs = 50, verbose = FALSE)
  }
  
  message("--- Integration complete! ---")
  elbow_plot <- .analysis_build_elbow_plot(seurat_integrated)
  return(list(
    object = seurat_integrated,
    elbow_plot = elbow_plot
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
