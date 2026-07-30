metadata_policy_sanitize_token <- function(x, default = "obj") {
  out <- gsub("[^A-Za-z0-9]+", "_", as.character(x %||% ""), perl = TRUE)
  out <- gsub("_+", "_", out)
  out <- gsub("^_|_$", "", out)
  if (!nzchar(out)) out <- default
  out
}

metadata_policy_default_suffix <- function(source_object_name) {
  metadata_policy_sanitize_token(source_object_name, default = "source")
}

metadata_policy_rules <- function() {
  list(
    protected_patterns = c(
      "^orig\\.ident$", "^sample$", "^condition$", "^batch$", "^donor$", "^patient$", "^library$", "^lane$",
      "^ncount_", "^nfeature_", "^percent[._]mt$",
      "HTO", "hashtag", "hash\\.", "classification\\.global", "classification", "multiseq",
      "vdj", "clonotype", "clone", "cdr3", "(^|_)tcr($|_)", "(^|_)bcr($|_)", "^tra", "^trb", "^trd", "^trg", "^igh", "^igk", "^igl",
      "doublet", "singlet", "multiplet", "scdblfinder", "df\\.class", "df\\.score", "pann", "scrublet",
      "^s\\.score$", "^g2m\\.score$", "^phase$", "cell.?cycle",
      "soupx", "decontx", "contam",
      "^ncount_atac$", "^nfeature_atac$", "tss", "nucleosome", "frip", "peak", "adt",
      "demuxlet", "freemuxlet", "vireo", "souporcell", "donor[_\\.]id",
      "spatial", "spot", "capture", "region", "tissue"
    ),
    non_protected_patterns = c(
      "^seurat_clusters$", "^seurat_clusters_", "^umap[0-9]+_quick_", "^saved_group_",
      "annotation", "celltype", "predicted", "label", "pseudotime", "trajectory", "latent_time", "velocity",
      "nichenet", "niches", "cellchat", "sctenifold", "monocle", "module", "score"
    )
  )
}

metadata_policy_classify_column <- function(col_name, rules = metadata_policy_rules()) {
  nm <- tolower(as.character(col_name %||% ""))
  if (!nzchar(nm)) return("unknown")
  if (any(vapply(rules$protected_patterns, function(p) grepl(p, nm, perl = TRUE), logical(1)))) return("protected")
  if (any(vapply(rules$non_protected_patterns, function(p) grepl(p, nm, perl = TRUE), logical(1)))) return("non_protected")
  "unknown"
}

metadata_policy_apply_suffix <- function(col_name, suffix) {
  base <- as.character(col_name %||% "")
  suf <- metadata_policy_sanitize_token(suffix, default = "source")
  if (!nzchar(base)) return(base)
  if (grepl(paste0("_", suf, "$"), base, ignore.case = TRUE, perl = TRUE)) return(base)
  paste0(base, "_", suf)
}

metadata_policy_analysis_colname <- function(base_col, source_object_name) {
  metadata_policy_apply_suffix(base_col, metadata_policy_default_suffix(source_object_name))
}

metadata_policy_add_audit <- function(sobj, source_module, columns, decision, details = list()) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(sobj)
  cols <- unique(as.character(columns %||% character(0)))
  cols <- cols[nzchar(cols)]
  entry <- list(
    time = as.character(Sys.time()),
    module = as.character(source_module %||% "unknown"),
    columns = cols,
    decision = as.character(decision %||% ""),
    details = details
  )
  if (is.null(sobj@misc$metadata_write_log) || !is.list(sobj@misc$metadata_write_log)) {
    sobj@misc$metadata_write_log <- list()
  }
  sobj@misc$metadata_write_log[[length(sobj@misc$metadata_write_log) + 1L]] <- entry
  sobj
}

metadata_policy_rename_for_subset <- function(md, source_object_name, custom_suffix, unknown_keep = character(0), rules = metadata_policy_rules()) {
  stopifnot(is.data.frame(md))
  nm_in <- colnames(md)
  suf <- metadata_policy_sanitize_token(if (nzchar(custom_suffix %||% "")) custom_suffix else source_object_name, default = "source")

  classes <- vapply(nm_in, function(nm) metadata_policy_classify_column(nm, rules = rules), character(1))
  out_names <- nm_in
  unknown_keep <- unique(as.character(unknown_keep %||% character(0)))

  for (i in seq_along(nm_in)) {
    nm <- nm_in[[i]]
    cls <- classes[[i]]
    keep_unsuffixed <- identical(cls, "protected") || (identical(cls, "unknown") && nm %in% unknown_keep)
    if (!keep_unsuffixed) out_names[[i]] <- metadata_policy_apply_suffix(nm, suf)
  }

  if (anyDuplicated(out_names)) {
    dups <- unique(out_names[duplicated(out_names)])
    stop(sprintf("Metadata rename collision after suffixing: %s", paste(dups, collapse = ", ")))
  }

  colnames(md) <- out_names
  list(
    meta = md,
    suffix = suf,
    name_map = stats::setNames(out_names, nm_in),
    class_map = stats::setNames(classes, nm_in)
  )
}
