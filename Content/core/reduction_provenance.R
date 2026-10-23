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

# Canonical active PCA-dimension record for cross-page embedding selection.
# Keep this in the object package; UI inputs are only views of this value.
wanlab_get_active_embedding_dims <- function(entry) {
  dims <- .wanlab_valid_dims(tryCatch(
    entry$prefs$confirmed_dims$value,
    error = function(e) NULL
  ))
  if (is.na(dims)) integer(0) else as.integer(dims)
}

wanlab_set_active_embedding_dims <- function(entry, dims, source = "manual") {
  if (!is.list(entry)) stop("Object entry must be a list.")
  dims <- .wanlab_valid_dims(dims)
  if (is.na(dims)) stop("Active embedding dimensions must be a valid integer.")
  if (is.null(entry$prefs)) entry$prefs <- list()
  if (!is.list(entry$prefs)) stop("Object entry preferences must be a list.")
  source <- .wanlab_first_chr(source, default = "manual")
  entry$prefs$confirmed_dims <- list(
    value = as.integer(dims),
    source = source,
    updated_at = Sys.time()
  )
  entry
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

# Agent note: Consumers may receive objects whose designated embedding keeps its
# configuration-specific key (for example `umap_pca_30`) without a canonical
# alias. Resolve only to an existing, dimension-valid UMAP/t-SNE key; never
# substitute a different embedding family or mutate the object while reading.
wanlab_resolve_embedding_reduction <- function(
  sobj,
  requested = "umap",
  preferred_dims = NULL
) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return("")

  red_names <- tryCatch(names(sobj@reductions), error = function(e) character(0))
  if (!length(red_names)) return("")
  valid <- vapply(red_names, function(red) {
    emb <- tryCatch(Seurat::Embeddings(sobj, red), error = function(e) NULL)
    is.matrix(emb) && ncol(emb) >= 2L
  }, logical(1))
  red_names <- red_names[valid]
  if (!length(red_names)) return("")

  requested <- .wanlab_first_chr(requested)
  if (!nzchar(requested)) return("")
  red_lc <- tolower(red_names)
  requested_lc <- tolower(requested)
  is_family_alias <- requested_lc %in% c("umap", "tsne")
  if (!is_family_alias) {
    exact_idx <- match(requested_lc, red_lc)
    return(if (!is.na(exact_idx)) red_names[[exact_idx]] else "")
  }

  family_idx <- which(grepl(sprintf("^%s($|_)", requested_lc), red_lc))
  if (!length(family_idx)) return("")

  dims_pref <- .wanlab_valid_dims(preferred_dims)
  if (!is.na(dims_pref)) {
    dims_tag <- sprintf("%s_pca_%d", requested_lc, dims_pref)
    named_idx <- which(red_lc[family_idx] == dims_tag)
    if (length(named_idx)) return(red_names[[family_idx[[named_idx[[1L]]]]]])

    provenance_idx <- which(vapply(family_idx, function(i) {
      red <- red_names[[i]]
      provenance <- wanlab_get_reduction_provenance(sobj, red)
      prov_dims <- .wanlab_valid_dims(
        if (!is.null(provenance$pca_dims)) provenance$pca_dims else NA_integer_
      )
      if (is.na(prov_dims)) {
        prov_dims <- .wanlab_valid_dims(
          tryCatch(sobj@reductions[[red]]@misc$cfg_signature$dims, error = function(e) NA_integer_)
        )
      }
      isTRUE(!is.na(prov_dims) && identical(as.integer(prov_dims), as.integer(dims_pref)))
    }, logical(1)))
    if (length(provenance_idx)) return(red_names[[family_idx[[provenance_idx[[1L]]]]]])

    # Confirmed dimensions make a named mismatch invalid. A canonical alias is
    # retained as legacy state because its key does not encode PCA dimensions;
    # never silently select a different named embedding instead.
    canonical_idx <- match(requested_lc, red_lc[family_idx])
    if (!is.na(canonical_idx)) return(red_names[[family_idx[[canonical_idx]]]])
    return("")
  }

  canonical_idx <- match(requested_lc, red_lc[family_idx])
  if (!is.na(canonical_idx)) return(red_names[[family_idx[[canonical_idx]]]])
  red_names[[family_idx[[1L]]]]
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

# Agent note: Named embeddings (for example, `umap_pca_30`) are the persistent
# configuration-specific reductions; keep canonical `umap`/`tsne` aliases so
# legacy analysis pages receive the same coordinates and provenance.
wanlab_bind_canonical_embedding_aliases <- function(
  sobj,
  object_name = "",
  preferred_dims = NULL
) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(sobj)

  dims_pref <- .wanlab_valid_dims(preferred_dims)
  bind_alias <- function(obj, kind, canonical) {
    red_names <- tryCatch(names(obj@reductions), error = function(e) character(0))
    if (!length(red_names)) return(obj)
    red_lc <- tolower(red_names)
    valid <- vapply(red_names, function(red) {
      emb <- tryCatch(Seurat::Embeddings(obj, red), error = function(e) NULL)
      is.matrix(emb) && ncol(emb) >= 2L
    }, logical(1))
    candidates <- which(valid & grepl(sprintf("^%s($|_)", kind), red_lc))
    if (!length(candidates)) return(obj)

    preferred_name <- if (!is.na(dims_pref)) sprintf("%s_pca_%d", kind, dims_pref) else ""
    preferred_idx <- if (nzchar(preferred_name)) match(preferred_name, red_lc[candidates]) else NA_integer_
    canonical_idx <- match(canonical, red_lc[candidates])
    source_idx <- if (!is.na(preferred_idx)) {
      candidates[[preferred_idx]]
    } else if (!is.na(canonical_idx)) {
      candidates[[canonical_idx]]
    } else {
      candidates[[1L]]
    }
    source_name <- red_names[[source_idx]]

    provenance <- wanlab_get_reduction_provenance(obj, source_name)
    pca_name <- .wanlab_first_chr(provenance$pca_reduction, default = "pca")
    pca_dims <- .wanlab_valid_dims(provenance$pca_dims)
    if (is.na(pca_dims)) pca_dims <- dims_pref
    owner <- .wanlab_first_chr(object_name, default = .wanlab_first_chr(provenance$owner_object, default = ""))

    if (nzchar(owner)) {
      obj <- wanlab_set_reduction_provenance(
        obj,
        reduction_name = source_name,
        owner_object = owner,
        pca_reduction = pca_name,
        pca_dims = pca_dims
      )
    }
    if (!identical(source_name, canonical)) {
      obj@reductions[[canonical]] <- obj@reductions[[source_name]]
      try(obj@reductions[[canonical]]@key <- if (identical(kind, "umap")) "UMAP_" else "tSNE_", silent = TRUE)
    }

    if (nzchar(owner)) {
      obj <- wanlab_set_reduction_provenance(
        obj,
        reduction_name = canonical,
        owner_object = owner,
        pca_reduction = pca_name,
        pca_dims = pca_dims
      )
    }
    obj
  }

  bind_alias(sobj, "umap", "umap") |>
    bind_alias("tsne", "tsne")
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
