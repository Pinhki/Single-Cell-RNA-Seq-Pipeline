# Canonical reset for subset-derived analysis objects.
# Agent note: This mutates scientific object state. Keep it in core and preserve
# parent reduction layers for reclustering while QC-only resets remove defaults.

wanlab_reset_subset_analysis_state <- function(sobj, source_object_name = "") {
  if (is.null(sobj)) return(sobj)

  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (!is.null(md) && nrow(md)) {
    cols <- colnames(md)
    lower_cols <- tolower(cols)
    drop_patterns <- c(
      "^anno_",
      "^annotation_",
      "^singler_",
      "^markergene_",
      "^celltypist_",
      "^db_",
      "^monocle2_",
      "^nichenet_",
      "^niches_",
      "^cellchat_",
      "^scenic_",
      "^rv052_",
      "^sctenifoldknk_"
    )
    drop_by_pattern <- vapply(
      lower_cols,
      function(cc) any(vapply(
        drop_patterns,
        function(pp) grepl(pp, cc, ignore.case = TRUE, perl = TRUE),
        logical(1)
      )),
      logical(1)
    )
    drop_meta <- cols[
      lower_cols %in% c("seurat_clusters") |
        grepl("(^|_)(snn|nn|wsnn|wknn)_res\\.[0-9]+", cols, ignore.case = TRUE) |
        grepl("(^|_)(snn|nn|wsnn|wknn)\\.res\\.[0-9]+", cols, ignore.case = TRUE) |
        grepl("(^|_)leiden_res\\.[0-9]+", cols, ignore.case = TRUE) |
        grepl("^seurat_clusters_res\\.[0-9]+", cols, ignore.case = TRUE) |
        grepl("^sweep_(nn_)?res\\.[0-9]+", cols, ignore.case = TRUE) |
        drop_by_pattern
    ]
    sobj@meta.data <- md[, setdiff(cols, unique(drop_meta)), drop = FALSE]
  }

  tryCatch({
    md2 <- sobj@meta.data
    if (!is.null(md2) && "orig.ident" %in% colnames(md2)) {
      Seurat::Idents(sobj) <- factor(as.character(md2$orig.ident))
    } else if (!is.null(md2) && nrow(md2)) {
      Seurat::Idents(sobj) <- factor(rep("subset", nrow(md2)), levels = "subset")
    }
  }, error = function(e) NULL)

  tryCatch({
    if (!is.null(sobj@graphs) && length(sobj@graphs)) sobj@graphs <- list()
  }, error = function(e) NULL)
  tryCatch({
    if (!is.null(sobj@neighbors) && length(sobj@neighbors)) sobj@neighbors <- list()
  }, error = function(e) NULL)

  source_object_name <- .wanlab_first_chr(source_object_name)
  if (nzchar(source_object_name)) {
    sobj <- wanlab_suffix_inherited_reductions(sobj, source_object_name)
  } else {
    tryCatch({
      reduction_names <- names(sobj@reductions)
      drop_reductions <- reduction_names[
        tolower(reduction_names) %in% c("pca", "umap", "tsne", "umap3d", "tsne3d")
      ]
      sobj@reductions <- sobj@reductions[setdiff(reduction_names, drop_reductions)]
    }, error = function(e) NULL)
  }

  tryCatch({
    cmd_names <- names(sobj@commands)
    if (length(cmd_names)) {
      drop_cmd <- cmd_names[
        grepl("runpca|runumap|runtsne|findneighbors|findclusters", cmd_names, ignore.case = TRUE)
      ]
      sobj@commands <- sobj@commands[setdiff(cmd_names, drop_cmd)]
    }
  }, error = function(e) NULL)

  sobj
}

