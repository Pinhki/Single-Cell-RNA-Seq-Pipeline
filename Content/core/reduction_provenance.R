# Canonical reduction ownership and PCA-pairing contract.
# Agent note: Keep all provenance reads/writes and recluster name binding here;
# Analysis UI and versioned Seurat cores must not duplicate this schema.

.wanlab_first_chr <- function(x, default = "") {
  x <- as.character(if (is.null(x)) character() else x)
  x <- x[!is.na(x)]
  if (length(x)) x[[1]] else default
}

.wanlab_valid_dims <- function(x) {
  dims <- suppressWarnings(as.integer(if (is.null(x)) NA_integer_ else x))
  dims <- dims[is.finite(dims) & !is.na(dims) & dims >= 1L]
  if (length(dims)) dims[[1]] else NA_integer_
}

wanlab_reduction_owner_token <- function(object_name) {
  token <- gsub("[^A-Za-z0-9]+", "_", .wanlab_first_chr(object_name))
  token <- gsub("^_+|_+$", "", token)
  if (nzchar(token)) token else "object"
}

wanlab_get_reduction_provenance <- function(sobj, reduction_name) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
  reduction_name <- .wanlab_first_chr(reduction_name)
  if (!nzchar(reduction_name) || !reduction_name %in% names(sobj@reductions)) return(NULL)
  provenance <- tryCatch(
    sobj@reductions[[reduction_name]]@misc$wanlab_provenance,
    error = function(e) NULL
  )
  if (is.list(provenance)) provenance else NULL
}

wanlab_set_reduction_provenance <- function(
  sobj,
  reduction_name,
  owner_object,
  pca_reduction = NULL,
  pca_dims = NULL
) {
  reduction_name <- .wanlab_first_chr(reduction_name)
  if (
    is.null(sobj) ||
      !inherits(sobj, "Seurat") ||
      !nzchar(reduction_name) ||
      !reduction_name %in% names(sobj@reductions)
  ) {
    return(sobj)
  }

  red <- sobj@reductions[[reduction_name]]
  misc <- tryCatch(red@misc, error = function(e) list())
  if (!is.list(misc)) misc <- list()
  provenance <- wanlab_get_reduction_provenance(sobj, reduction_name)
  if (!is.list(provenance)) provenance <- list()
  provenance$owner_object <- .wanlab_first_chr(owner_object)

  pca_name <- .wanlab_first_chr(pca_reduction)
  if (nzchar(pca_name)) provenance$pca_reduction <- pca_name

  dims <- .wanlab_valid_dims(pca_dims)
  if (!is.na(dims)) provenance$pca_dims <- dims

  misc$wanlab_provenance <- provenance
  red@misc <- misc
  sobj@reductions[[reduction_name]] <- red
  sobj
}

wanlab_suffix_inherited_reductions <- function(sobj, source_object_name) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(sobj)
  old_names <- names(sobj@reductions)
  if (!length(old_names)) return(sobj)

  source_name <- .wanlab_first_chr(source_object_name)
  suffix <- paste0("__from_", wanlab_reduction_owner_token(source_name))
  already_bound <- grepl("__from_[A-Za-z0-9_]+$", old_names, perl = TRUE)
  new_names <- ifelse(already_bound, old_names, paste0(old_names, suffix))
  if (anyDuplicated(new_names)) {
    stop("Inherited reduction names are not unique after object binding.")
  }

  rename_map <- stats::setNames(new_names, old_names)
  names(sobj@reductions) <- new_names

  for (i in seq_along(new_names)) {
    old_name <- old_names[[i]]
    new_name <- new_names[[i]]
    red <- sobj@reductions[[new_name]]
    misc <- tryCatch(red@misc, error = function(e) list())
    if (!is.list(misc)) misc <- list()
    provenance <- misc$wanlab_provenance
    if (!is.list(provenance)) provenance <- list()
    if (!nzchar(.wanlab_first_chr(provenance$owner_object))) {
      provenance$owner_object <- source_name
    }

    is_pca <- startsWith(tolower(old_name), "pca")
    is_embedding <- grepl("umap|tsne", tolower(old_name))
    if (is_pca) {
      provenance$pca_reduction <- new_name
      provenance$pca_dims <- ncol(tryCatch(
        red@cell.embeddings,
        error = function(e) matrix(nrow = 0, ncol = 0)
      ))
    } else if (is_embedding) {
      pca_name <- .wanlab_first_chr(provenance$pca_reduction, default = "pca")
      if (pca_name %in% names(rename_map)) {
        pca_name <- unname(rename_map[[pca_name]])
      }
      provenance$pca_reduction <- pca_name
      dims <- .wanlab_valid_dims(
        if (!is.null(provenance$pca_dims)) provenance$pca_dims else misc$cfg_signature$dims
      )
      if (!is.na(dims)) provenance$pca_dims <- dims
    }

    misc$wanlab_provenance <- provenance
    red@misc <- misc
    sobj@reductions[[new_name]] <- red
  }
  sobj
}
