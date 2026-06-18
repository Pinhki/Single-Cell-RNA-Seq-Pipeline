## ---- core/backends/qc_seurat_v4.R -------------------------------------
suppressPackageStartupMessages({
  library(Seurat)
  library(Matrix)
})

.msg <- function(...) message("[qc_core:v4] ", paste0(..., collapse = ""))
`%||%` <- function(a, b) if (is.null(a)) b else a

.get_path <- function(sample_row) {
  p <- if ("path" %in% names(sample_row)) sample_row$path[[1]] else sample_row$name[[1]]
  p <- as.character(p)
  if (!nzchar(p) || !file.exists(p)) {
    stop(sprintf("file not found: %s", p))
  }
  normalizePath(p, winslash = "/")
}

.read_counts_from_delim <- function(path) {
  ext <- tolower(tools::file_ext(path))
  sep <- if (ext == "csv") "," else "\t"
  df <- utils::read.table(path, sep = sep, header = TRUE, row.names = 1, check.names = FALSE, quote = "\"'", comment.char = "")
  if (!nrow(df) || !ncol(df)) stop("Delimited file has no usable matrix dimensions: ", path)

  mat <- as.matrix(df)
  suppressWarnings(storage.mode(mat) <- "numeric")
  mat[is.na(mat)] <- 0
  Matrix::Matrix(mat, sparse = TRUE)
}

.create_assay_from_counts <- function(mat) {
  tryCatch(
    Seurat::CreateAssayObject(counts = mat),
    error = function(e) {
      if (exists("CreateAssay5Object", where = asNamespace("SeuratObject"), inherits = FALSE)) {
        SeuratObject::CreateAssay5Object(counts = mat)
      } else {
        stop(e)
      }
    }
  )
}

.create_seurat_from_counts <- function(counts, project) {
  if (inherits(counts, c("dgCMatrix", "matrix"))) {
    return(Seurat::CreateSeuratObject(counts = counts, project = project))
  }

  if (is.list(counts) && length(counts) > 0) {
    nm <- names(counts)
    if (is.null(nm)) nm <- rep("", length(counts))
    low <- tolower(nm)
    rna_idx <- which(grepl("gene expression|rna", low))
    if (!length(rna_idx)) rna_idx <- 1

    sobj <- Seurat::CreateSeuratObject(counts = counts[[rna_idx[[1]]]], assay = "RNA", project = project)

    for (i in seq_along(counts)) {
      if (i == rna_idx[[1]]) next
      mat <- counts[[i]]
      if (!inherits(mat, c("dgCMatrix", "matrix"))) next

      src <- tolower(nm[[i]] %||% paste0("assay", i))
      assay_name <- if (grepl("antibody|adt", src)) {
        "ADT"
      } else if (grepl("peak|atac|chromatin", src)) {
        "ATAC"
      } else {
        make.names(nm[[i]] %||% paste0("assay", i))
      }
      if (assay_name %in% names(sobj@assays)) assay_name <- paste0(assay_name, "_", i)

      sobj[[assay_name]] <- .create_assay_from_counts(mat)
    }
    return(sobj)
  }

  stop("Unsupported counts object from reader.")
}

.align_meta_frame <- function(df, target_names, axis_label = "cell") {
  if (is.null(df) || !is.data.frame(df)) return(data.frame(row.names = target_names, stringsAsFactors = FALSE))
  if (!length(target_names)) return(df[0, , drop = FALSE])

  rn <- rownames(df)
  has_valid_rownames <- !is.null(rn) && length(rn) == nrow(df) && all(!is.na(rn)) && !anyDuplicated(rn)
  if (isTRUE(has_valid_rownames) && all(target_names %in% rn)) {
    return(df[target_names, , drop = FALSE])
  }

  if (nrow(df) == length(target_names)) {
    rownames(df) <- target_names
    return(df)
  }

  stop(
    sprintf(
      "Cannot align h5ad %s metadata: expected %d rows, got %d rows.",
      axis_label, length(target_names), nrow(df)
    )
  )
}

.coerce_complex_meta_columns <- function(df) {
  if (is.null(df) || !is.data.frame(df) || !ncol(df)) return(df)
  out <- df
  for (cc in colnames(out)) {
    v <- out[[cc]]
    if (is.list(v)) {
      out[[cc]] <- vapply(v, function(x) {
        if (length(x) == 0 || all(is.na(x))) return(NA_character_)
        paste(as.character(unlist(x, use.names = FALSE)), collapse = ";")
      }, character(1))
    }
  }
  out
}

.append_metadata_columns <- function(base_df, add_df, prefix = "h5ad_") {
  out <- base_df
  if (is.null(add_df) || !is.data.frame(add_df) || !ncol(add_df)) return(out)

  add_df <- .coerce_complex_meta_columns(add_df)
  for (cc in colnames(add_df)) {
    target <- cc
    if (target %in% colnames(out)) {
      target <- make.unique(c(colnames(out), paste0(prefix, cc)))
      target <- target[[length(target)]]
    }
    out[[target]] <- add_df[[cc]]
  }
  out
}

.read_h5ad_as_seurat <- function(path, project) {
  if (!requireNamespace("zellkonverter", quietly = TRUE)) {
    stop("Missing dependency 'zellkonverter' for .h5ad import. Please bootstrap packages via Content/run.R.")
  }
  if (!requireNamespace("SummarizedExperiment", quietly = TRUE)) {
    stop("Missing dependency 'SummarizedExperiment' for .h5ad import. Please bootstrap packages via Content/run.R.")
  }

  sce <- tryCatch(
    zellkonverter::readH5AD(path),
    error = function(e) stop("Failed to read .h5ad file: ", conditionMessage(e))
  )
  if (is.null(sce)) {
    stop("Failed to read .h5ad file: zellkonverter::readH5AD returned NULL.")
  }

  assay_names <- as.character(SummarizedExperiment::assayNames(sce) %||% character(0))
  if (!length(assay_names)) stop(".h5ad file has no assay matrices.")

  low_assay <- tolower(assay_names)
  pref_counts <- c("counts", "raw_counts", "raw", "x", "data", "logcounts")
  idx_counts <- match(pref_counts, low_assay)
  idx_counts <- idx_counts[!is.na(idx_counts)]
  counts_assay <- if (length(idx_counts)) assay_names[idx_counts[[1]]] else assay_names[[1]]

  pref_data <- c("logcounts", "data", "x")
  idx_data <- match(pref_data, low_assay)
  idx_data <- idx_data[!is.na(idx_data)]
  data_assay <- if (length(idx_data)) assay_names[idx_data[[1]]] else ""
  if (nzchar(data_assay) && identical(tolower(data_assay), tolower(counts_assay))) data_assay <- ""

  sobj <- tryCatch(
    {
      if (nzchar(data_assay)) {
        Seurat::as.Seurat(sce, counts = counts_assay, data = data_assay, project = project)
      } else {
        Seurat::as.Seurat(sce, counts = counts_assay, project = project)
      }
    },
    error = function(e) {
      counts <- SummarizedExperiment::assay(sce, counts_assay)
      .create_seurat_from_counts(counts = counts, project = project)
    }
  )

  cell_meta <- tryCatch(as.data.frame(SummarizedExperiment::colData(sce)), error = function(e) data.frame())
  if (is.data.frame(cell_meta) && nrow(cell_meta)) {
    cell_meta <- .align_meta_frame(cell_meta, target_names = colnames(sobj), axis_label = "cell")
    sobj@meta.data <- .append_metadata_columns(sobj@meta.data, cell_meta, prefix = "h5ad_")
  }

  if ("RNA" %in% names(sobj@assays)) {
    feature_meta <- tryCatch(as.data.frame(SummarizedExperiment::rowData(sce)), error = function(e) data.frame())
    if (is.data.frame(feature_meta) && nrow(feature_meta) && nrow(sobj[["RNA"]]@meta.features)) {
      feature_meta <- .align_meta_frame(feature_meta, target_names = rownames(sobj[["RNA"]]), axis_label = "feature")
      sobj[["RNA"]]@meta.features <- .append_metadata_columns(
        sobj[["RNA"]]@meta.features,
        feature_meta,
        prefix = "h5ad_"
      )
    }
  }

  sobj@misc$h5ad_import <- list(
    source_file = normalizePath(path, winslash = "/", mustWork = FALSE),
    imported_at = as.character(Sys.time()),
    assays_detected = assay_names,
    counts_assay = counts_assay,
    data_assay = if (nzchar(data_assay)) data_assay else NA_character_
  )

  sobj
}

.ensure_qc_columns <- function(sobj) {
  if (!"nFeature_RNA" %in% names(sobj@meta.data)) {
    sobj[["nFeature_RNA"]] <- Matrix::colSums(Seurat::GetAssayData(sobj, slot = "counts") > 0)
  }
  if (!"nCount_RNA" %in% names(sobj@meta.data)) {
    sobj[["nCount_RNA"]] <- Matrix::colSums(Seurat::GetAssayData(sobj, slot = "counts"))
  }

  if (!any(c("percent.mt", "percent.mito", "mito") %in% names(sobj@meta.data))) {
    rn <- rownames(sobj)
    has_MT <- any(grepl("^MT-", rn))
    has_mt <- any(grepl("^mt-", rn))
    pat <- if (has_MT && !has_mt) "^MT-" else if (has_mt && !has_MT) "^mt-" else "^(MT-|mt-)"
    sobj[["percent.mt"]] <- Seurat::PercentageFeatureSet(sobj, pattern = pat)
  }

  sobj
}

.apply_filters <- function(sobj, sample_row) {
  md <- sobj@meta.data
  nf <- md[["nFeature_RNA"]]
  nc <- md[["nCount_RNA"]]
  mt <- md[["percent.mt"]] %||% md[["percent.mito"]] %||% md[["mito"]]

  keep <- rep(TRUE, ncol(sobj))

  if (!is.null(sample_row$min_features)) keep <- keep & nf >= as.numeric(sample_row$min_features)
  if (!is.null(sample_row$max_features)) keep <- keep & nf <= as.numeric(sample_row$max_features)
  if (!is.null(sample_row$min_umi_counts)) keep <- keep & nc >= as.numeric(sample_row$min_umi_counts)
  if (!is.null(sample_row$max_umi_counts)) keep <- keep & nc <= as.numeric(sample_row$max_umi_counts)
  if (!is.null(sample_row$max_mt_percent) && !is.null(mt)) keep <- keep & mt <= as.numeric(sample_row$max_mt_percent)

  subset(sobj, cells = colnames(sobj)[keep])
}

run_qc_for_sample <- function(sample_row, apply_filters = FALSE) {
  stopifnot(is.data.frame(sample_row), nrow(sample_row) == 1)

  path <- .get_path(sample_row)
  ext <- tolower(tools::file_ext(path))
  .msg("loading: ", basename(path), " (", ext, ")\n")

  sobj <- NULL
  if (ext %in% c("rds", "rda", "rdata")) {
    obj <- if (ext == "rds") {
      readRDS(path)
    } else {
      e <- new.env(parent = emptyenv()); on.exit(rm(e), add = TRUE)
      load(path, envir = e)
      Filter(function(x) inherits(x, "Seurat"), as.list(e))[[1]]
    }
    if (!inherits(obj, "Seurat")) stop("file did not contain a Seurat object: ", path)
    sobj <- obj
  } else if (ext %in% c("h5ad")) {
    sobj <- .read_h5ad_as_seurat(path = path, project = tools::file_path_sans_ext(basename(path)))
  } else if (ext %in% c("h5", "hdf5")) {
    counts <- Seurat::Read10X_h5(path)
    sobj <- .create_seurat_from_counts(counts = counts, project = basename(path))
  } else if (ext %in% c("csv", "tsv", "txt")) {
    counts <- .read_counts_from_delim(path)
    sobj <- .create_seurat_from_counts(counts = counts, project = basename(path))
  } else if (isTRUE(file.info(path)$isdir)) {
    counts <- Seurat::Read10X(path)
    sobj <- .create_seurat_from_counts(counts = counts, project = basename(path))
  } else {
    stop("unsupported input: ", path)
  }

  sobj <- .ensure_qc_columns(sobj)

  if (isTRUE(apply_filters)) {
    sobj <- .apply_filters(sobj, sample_row)
  }

  sobj
}

run_qc_for_all_samples <- function(sample_info_df, apply_filters = FALSE) {
  stopifnot(is.data.frame(sample_info_df), nrow(sample_info_df) >= 1)
  out <- stats::setNames(vector("list", nrow(sample_info_df)), as.character(sample_info_df$name))
  errs <- character(0)

  for (i in seq_len(nrow(sample_info_df))) {
    row <- sample_info_df[i, , drop = FALSE]
    nm <- as.character(row$name[[1]])
    out[[nm]] <- tryCatch(
      run_qc_for_sample(row, apply_filters = apply_filters),
      error = function(e) { errs <<- c(errs, sprintf("%s -> %s", nm, conditionMessage(e))); NULL }
    )
  }
  attr(out, "errors") <- errs
  out
}

build_qc_objects <- function(sample_info_df) {
  run_qc_for_all_samples(sample_info_df, apply_filters = FALSE)
}
