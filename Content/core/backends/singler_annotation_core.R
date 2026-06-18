`%||%` <- get0("%||%", mode = "function", inherits = TRUE, ifnotfound = function(a, b) if (is.null(a)) b else a)

singler_trace <- function(..., .prefix = "[SingleR]") {
  parts <- vapply(list(...), function(x) paste(as.character(x), collapse = ""), character(1))
  message(.prefix, " ", paste(parts, collapse = ""))
  invisible(NULL)
}

singler_validate_test_matrix <- function(test_mat) {
  if (is.null(test_mat)) stop("SingleR test matrix is NULL.", call. = FALSE)
  dims <- dim(test_mat)
  if (length(dims) != 2L || any(is.na(dims))) {
    stop("SingleR test matrix must be two-dimensional.", call. = FALSE)
  }
  gene_names <- rownames(test_mat)
  cell_names <- colnames(test_mat)
  if (!length(gene_names) || any(is.na(gene_names)) || any(!nzchar(gene_names))) {
    stop("SingleR test matrix must have non-empty gene row names.", call. = FALSE)
  }
  if (!length(cell_names) || any(is.na(cell_names)) || any(!nzchar(cell_names))) {
    stop("SingleR test matrix must have non-empty cell column names.", call. = FALSE)
  }
  singler_trace(
    "Test matrix validated: genes=", nrow(test_mat),
    ", cells=", ncol(test_mat),
    ", class=", paste(class(test_mat), collapse = "/"),
    ", duplicate_genes=", sum(duplicated(gene_names)),
    ", duplicate_cells=", sum(duplicated(cell_names))
  )
  invisible(test_mat)
}

singler_normalize_labels <- function(labels_ref) {
  labels_chr <- as.character(labels_ref %||% character(0))
  labels_chr[is.na(labels_chr)] <- ""
  labels_chr <- trimws(labels_chr)
  missing <- !nzchar(labels_chr)
  if (all(missing)) {
    stop("Selected reference label column is unavailable or empty.", call. = FALSE)
  }
  labels_chr[missing] <- NA_character_
  singler_trace(
    "Reference labels prepared: total=", length(labels_chr),
    ", missing=", sum(is.na(labels_chr)),
    ", unique_non_missing=", length(unique(stats::na.omit(labels_chr)))
  )
  labels_chr
}

singler_ref_gene_names <- function(ref) {
  ref_list <- ref
  if (!is.list(ref_list) || is.data.frame(ref_list)) {
    ref_list <- list(ref)
  }
  unique(unlist(lapply(ref_list, function(one) rownames(one) %||% character(0)), use.names = FALSE))
}

singler_detect_gene_id_style <- function(ids) {
  ids <- as.character(ids %||% character(0))
  ids <- ids[!is.na(ids) & nzchar(ids)]
  if (!length(ids)) return("unknown")
  probe <- utils::head(ids, 1000L)
  ensembl_hits <- mean(grepl("^ENS[A-Z]*(G|T|P)[0-9]+", probe, perl = TRUE))
  symbol_hits <- mean(grepl("^[A-Za-z0-9][A-Za-z0-9.-]{0,30}$", probe, perl = TRUE) & !grepl("^ENS[A-Z]*(G|T|P)[0-9]+", probe, perl = TRUE))
  if (is.finite(ensembl_hits) && ensembl_hits >= 0.6) return("ensembl-like")
  if (is.finite(symbol_hits) && symbol_hits >= 0.6) return("symbol-like")
  "mixed-or-other"
}

singler_collect_overlap_details <- function(test_mat, ref, ref_name = "", min_common_genes = 100L) {
  singler_validate_test_matrix(test_mat)
  ref_genes <- singler_ref_gene_names(ref)
  ref_genes <- ref_genes[!is.na(ref_genes) & nzchar(ref_genes)]
  test_genes <- rownames(test_mat)
  common_genes <- intersect(test_genes, ref_genes)
  list(
    ref_name = as.character(ref_name %||% ""),
    test_genes = length(test_genes),
    ref_genes = length(ref_genes),
    common_genes = length(common_genes),
    dropped_genes = length(test_genes) - length(common_genes),
    min_common_genes = as.integer(min_common_genes %||% 100L),
    ok = length(common_genes) >= as.integer(min_common_genes %||% 100L),
    test_id_style = singler_detect_gene_id_style(test_genes),
    ref_id_style = singler_detect_gene_id_style(ref_genes),
    test_examples = utils::head(unique(test_genes), 5L),
    ref_examples = utils::head(unique(ref_genes), 5L),
    common_examples = utils::head(common_genes, 5L)
  )
}

singler_overlap_message <- function(details, label_level = "") {
  ref_name <- as.character(details$ref_name %||% "selected reference")
  label_level <- as.character(label_level %||% "")
  label_txt <- if (nzchar(label_level)) paste0(" using label column '", label_level, "'") else ""
  common_examples <- if (length(details$common_examples)) {
    paste(details$common_examples, collapse = ", ")
  } else {
    "none"
  }
  paste0(
    "SingleR aborted before running. Only ", details$common_genes,
    " common genes were found between the active RNA assay and ", ref_name, label_txt,
    " (minimum required: ", details$min_common_genes, "). ",
    "This reference/object pair is not compatible for reliable SingleR annotation. ",
    "This usually means the assay row names do not match the reference gene identifiers, such as Ensembl IDs vs gene symbols, species mismatch, or renamed feature IDs. ",
    "Test gene ID style: ", details$test_id_style, ". ",
    "Reference gene ID style: ", details$ref_id_style, ". ",
    "Example test genes: ", paste(details$test_examples, collapse = ", "), ". ",
    "Example reference genes: ", paste(details$ref_examples, collapse = ", "), ". ",
    "Example overlapping genes: ", common_examples, "."
  )
}

singler_assert_reference_overlap <- function(test_mat, ref, ref_name = "", label_level = "", min_common_genes = 100L) {
  details <- singler_collect_overlap_details(
    test_mat = test_mat,
    ref = ref,
    ref_name = ref_name,
    min_common_genes = min_common_genes
  )
  singler_trace(
    "Gene overlap prepared: test_genes=", details$test_genes,
    ", ref_genes=", details$ref_genes,
    ", common_genes=", details$common_genes,
    ", dropped_genes=", details$dropped_genes,
    ", min_required=", details$min_common_genes,
    ", test_id_style=", details$test_id_style,
    ", ref_id_style=", details$ref_id_style
  )
  if (!isTRUE(details$ok)) {
    stop(singler_overlap_message(details, label_level = label_level), call. = FALSE)
  }
  details
}

#' Build a validated custom SingleR reference
#'
#' @param ref_data Reference input. Supports \code{SingleCellExperiment},
#'   \code{SummarizedExperiment}, matrix-like objects, or a list containing
#'   expression and metadata.
#' @param metadata Optional metadata for matrix-like references.
#' @param label_columns Character vector of label columns to keep.
#' @param primary_label Primary label column used for SingleR.
#' @param assay_name Preferred assay name for SE/SCE references.
#' @param check_non_empty Require at least one non-empty label.
#'
#' @return A list with normalized reference content and diagnostics.
#' @export
build_custom_singler_ref <- function(
  ref_data,
  metadata = NULL,
  label_columns = NULL,
  primary_label = NULL,
  assay_name = "logcounts",
  check_non_empty = TRUE
) {
  ref_norm <- singler_ref_as_standard(
    ref_data = ref_data,
    metadata = metadata,
    assay_name = assay_name
  )
  label_columns <- singler_choose_label_columns(
    metadata = ref_norm$metadata,
    requested = label_columns,
    primary = primary_label
  )
  validated <- validate_singler_ref(
    ref = ref_norm$ref,
    metadata = ref_norm$metadata,
    label_columns = label_columns,
    check_non_empty = check_non_empty
  )
  list(
    ref = ref_norm$ref,
    metadata = ref_norm$metadata,
    label_columns = validated$label_columns,
    primary_label = validated$primary_label,
    diagnostics = validated$diagnostics
  )
}

#' Validate custom SingleR reference inputs
#'
#' @param ref Reference object for SingleR (SE/SCE/matrix-like).
#' @param metadata Data frame with one row per reference column.
#' @param label_columns Candidate label columns.
#' @param check_non_empty Whether to enforce non-empty labels.
#'
#' @return A list containing resolved label columns and diagnostics.
#' @export
validate_singler_ref <- function(
  ref,
  metadata,
  label_columns,
  check_non_empty = TRUE
) {
  if (is.null(ref)) {
    stop("Reference is NULL. Provide a valid expression reference.", call. = FALSE)
  }
  ref_genes <- rownames(ref) %||% character(0)
  ref_cells <- colnames(ref) %||% character(0)
  if (!length(ref_genes) || any(!nzchar(ref_genes))) {
    stop("Reference must include non-empty gene row names.", call. = FALSE)
  }
  if (!length(ref_cells) || any(!nzchar(ref_cells))) {
    stop("Reference must include non-empty column names (cells/samples).", call. = FALSE)
  }
  if (!is.data.frame(metadata)) {
    stop("Reference metadata must be a data.frame.", call. = FALSE)
  }
  if (nrow(metadata) != length(ref_cells)) {
    stop(
      sprintf(
        "Reference metadata row count (%d) does not match reference columns (%d).",
        nrow(metadata), length(ref_cells)
      ),
      call. = FALSE
    )
  }
  label_columns <- unique(as.character(label_columns %||% character(0)))
  label_columns <- label_columns[nzchar(label_columns)]
  if (!length(label_columns)) {
    stop("No label column selected for reference.", call. = FALSE)
  }
  missing_cols <- setdiff(label_columns, colnames(metadata))
  if (length(missing_cols)) {
    stop(
      sprintf("Selected label column(s) not found in reference metadata: %s", paste(missing_cols, collapse = ", ")),
      call. = FALSE
    )
  }
  for (col in label_columns) {
    vals <- as.character(metadata[[col]] %||% "")
    vals[is.na(vals)] <- ""
    vals <- trimws(vals)
    if (isTRUE(check_non_empty) && !any(nzchar(vals))) {
      stop(
        sprintf("Reference label column '%s' has no non-empty labels.", col),
        call. = FALSE
      )
    }
  }
  primary_label <- label_columns[[1]]
  primary_vals <- as.character(metadata[[primary_label]] %||% "")
  primary_vals[is.na(primary_vals)] <- ""
  primary_vals <- trimws(primary_vals)
  primary_non_empty <- primary_vals[nzchar(primary_vals)]
  label_counts <- sort(table(primary_non_empty), decreasing = TRUE)
  diagnostics <- list(
    n_genes = length(ref_genes),
    n_samples = length(ref_cells),
    label_columns = label_columns,
    primary_label = primary_label,
    label_distribution = label_counts
  )
  singler_trace(
    "Custom reference validated: genes=", diagnostics$n_genes,
    ", samples=", diagnostics$n_samples,
    ", primary_label=", diagnostics$primary_label,
    ", unique_labels=", length(label_counts)
  )
  list(
    label_columns = label_columns,
    primary_label = primary_label,
    diagnostics = diagnostics
  )
}

#' Harmonize genes between query and reference
#'
#' @param query_mat Query expression matrix with genes as rows.
#' @param ref Reference object accepted by SingleR.
#' @param min_common_genes Minimum required overlap.
#' @param gene_map_hook Optional function(ids, side) returning mapped IDs.
#'
#' @return A list with harmonized \code{query}, \code{ref}, and \code{details}.
#' @export
harmonize_query_ref_genes <- function(
  query_mat,
  ref,
  min_common_genes = 100L,
  gene_map_hook = NULL
) {
  singler_validate_test_matrix(query_mat)
  ref_genes <- rownames(ref) %||% character(0)
  if (!length(ref_genes)) {
    stop("Reference has no gene row names.", call. = FALSE)
  }
  q_ids <- rownames(query_mat)
  r_ids <- ref_genes
  if (is.function(gene_map_hook)) {
    q_ids <- as.character(gene_map_hook(q_ids, "query") %||% q_ids)
    r_ids <- as.character(gene_map_hook(r_ids, "reference") %||% r_ids)
  }
  q_ids <- as.character(q_ids %||% character(0))
  r_ids <- as.character(r_ids %||% character(0))
  q_ids[is.na(q_ids)] <- ""
  r_ids[is.na(r_ids)] <- ""
  common <- intersect(q_ids[nzchar(q_ids)], r_ids[nzchar(r_ids)])
  details <- list(
    query_genes = nrow(query_mat),
    reference_genes = length(ref_genes),
    common_genes = length(common),
    dropped_query_genes = nrow(query_mat) - length(common),
    min_common_genes = as.integer(min_common_genes),
    ok = length(common) >= as.integer(min_common_genes),
    query_id_style = singler_detect_gene_id_style(q_ids),
    reference_id_style = singler_detect_gene_id_style(r_ids),
    common_examples = utils::head(common, 5L)
  )
  singler_trace(
    "Gene harmonization: query_genes=", details$query_genes,
    ", ref_genes=", details$reference_genes,
    ", common_genes=", details$common_genes,
    ", min_required=", details$min_common_genes
  )
  if (!isTRUE(details$ok)) {
    stop(
      paste0(
        "Insufficient overlap between query and reference genes: ",
        details$common_genes, " common genes (minimum ", details$min_common_genes, ")."
      ),
      call. = FALSE
    )
  }

  q_match <- match(common, q_ids)
  r_match <- match(common, r_ids)
  q_h <- query_mat[q_match, , drop = FALSE]
  r_h <- ref[r_match, , drop = FALSE]
  rownames(q_h) <- common
  rownames(r_h) <- common
  list(query = q_h, ref = r_h, details = details)
}

#' Run SingleR using a custom reference
#'
#' @param query Query as Seurat/SCE/matrix-like object.
#' @param custom_ref Built custom reference list from \code{build_custom_singler_ref}
#'   or compatible list with \code{ref} and \code{metadata}.
#' @param label_column Metadata column used as labels.
#' @param fine_tune Enable SingleR fine tuning.
#' @param prune Enable SingleR pruning.
#' @param aggregate_ref Aggregate reference by labels before training.
#' @param aggregate_by Label column used for aggregation (defaults to label_column).
#' @param assay_type_query Query assay type for SCE.
#' @param assay_type_ref Reference assay type for SCE/SE.
#' @param check_missing_ref Pass-through to SingleR::trainSingleR.
#' @param min_common_genes Minimum required shared genes.
#' @param num_threads Number of threads for SingleR.
#' @param normalize_query Normalize query before SingleR.
#' @param normalize_ref Normalize reference before SingleR.
#'
#' @return A list containing SingleR output, table, summaries, and diagnostics.
#' @export
run_singler_custom_ref <- function(
  query,
  custom_ref,
  label_column,
  fine_tune = TRUE,
  prune = TRUE,
  aggregate_ref = FALSE,
  aggregate_by = NULL,
  assay_type_query = "logcounts",
  assay_type_ref = "logcounts",
  check_missing_ref = TRUE,
  min_common_genes = 100L,
  num_threads = 1L,
  normalize_query = FALSE,
  normalize_ref = FALSE
) {
  if (is.null(custom_ref) || !is.list(custom_ref) || is.null(custom_ref$ref) || is.null(custom_ref$metadata)) {
    stop("custom_ref must be a list from build_custom_singler_ref().", call. = FALSE)
  }
  q_mat <- singler_query_as_matrix(query, assay_type = assay_type_query)
  r_mat <- singler_query_as_matrix(custom_ref$ref, assay_type = assay_type_ref)
  md <- as.data.frame(custom_ref$metadata, stringsAsFactors = FALSE)
  if (!(label_column %in% colnames(md))) {
    stop(sprintf("Label column '%s' was not found in custom reference metadata.", label_column), call. = FALSE)
  }
  labels_ref <- singler_normalize_labels(md[[label_column]])
  if (isTRUE(normalize_query)) q_mat <- singler_simple_log_norm(q_mat)
  if (isTRUE(normalize_ref)) r_mat <- singler_simple_log_norm(r_mat)
  harm <- harmonize_query_ref_genes(
    query_mat = q_mat,
    ref = r_mat,
    min_common_genes = min_common_genes
  )
  q_h <- harm$query
  r_h <- harm$ref
  agg_col <- as.character(aggregate_by %||% label_column)
  if (isTRUE(aggregate_ref)) {
    agg_vals <- as.character(md[[agg_col]] %||% "")
    agg_vals[is.na(agg_vals)] <- ""
    agg_vals <- trimws(agg_vals)
    keep <- nzchar(agg_vals)
    if (!any(keep)) {
      stop(sprintf("Cannot aggregate reference: label column '%s' has no non-empty values.", agg_col), call. = FALSE)
    }
    r_h <- r_h[, keep, drop = FALSE]
    labels_ref <- agg_vals[keep]
    u_labels <- unique(labels_ref)
    agg_list <- lapply(u_labels, function(lbl) {
      m <- r_h[, labels_ref == lbl, drop = FALSE]
      if (ncol(m) == 1L) {
        as.numeric(m[, 1L, drop = TRUE])
      } else {
        as.numeric(Matrix::rowMeans(m))
      }
    })
    r_h <- do.call(cbind, agg_list)
    rownames(r_h) <- rownames(harm$ref)
    colnames(r_h) <- u_labels
    labels_ref <- u_labels
    singler_trace(
      "Reference aggregated: groups=", length(unique(labels_ref)),
      ", aggregated_samples=", ncol(r_h)
    )
  }

  if (!requireNamespace("BiocParallel", quietly = TRUE)) {
    stop("Package 'BiocParallel' is required for SingleR custom-reference run.", call. = FALSE)
  }
  serial_param <- BiocParallel::SerialParam(progressbar = FALSE)
  trained <- SingleR::trainSingleR(
    ref = r_h,
    labels = labels_ref,
    test.genes = rownames(q_h),
    check.missing = isTRUE(check_missing_ref),
    num.threads = as.integer(num_threads %||% 1L),
    BPPARAM = serial_param
  )
  pred <- SingleR::classifySingleR(
    test = q_h,
    trained = trained,
    fine.tune = isTRUE(fine_tune),
    prune = isTRUE(prune),
    num.threads = as.integer(num_threads %||% 1L),
    BPPARAM = serial_param
  )
  pred_df <- as.data.frame(pred, stringsAsFactors = FALSE)
  out <- data.frame(
    cell = rownames(pred_df),
    final_label = as.character(pred_df$pruned.labels %||% pred_df$labels %||% ""),
    raw_label = as.character(pred_df$labels %||% ""),
    confidence = as.numeric(pred_df$delta.next %||% NA_real_),
    stringsAsFactors = FALSE
  )
  out$status <- ifelse(is.na(out$final_label) | !nzchar(out$final_label), "unresolved", "matched")
  summary_list <- summarize_singler_results(
    result_table = out,
    score_matrix = pred$scores %||% NULL
  )
  list(
    singleR = pred,
    trained = trained,
    table = out,
    scores = pred$scores %||% NULL,
    diagnostics = list(
      query_cells = ncol(q_h),
      query_genes = nrow(q_h),
      reference_samples = ncol(r_h),
      reference_genes = nrow(r_h),
      overlap = harm$details
    ),
    settings = list(
      label_column = label_column,
      fine_tune = isTRUE(fine_tune),
      prune = isTRUE(prune),
      aggregate_ref = isTRUE(aggregate_ref),
      aggregate_by = agg_col,
      normalize_query = isTRUE(normalize_query),
      normalize_ref = isTRUE(normalize_ref),
      num_threads = as.integer(num_threads %||% 1L)
    ),
    summary = summary_list
  )
}

#' Summarize SingleR outputs for QC and plotting
#'
#' @param result_table Standardized SingleR result table.
#' @param score_matrix Optional score matrix from SingleR.
#' @param compare_labels Optional secondary labels for confusion-style summary.
#'
#' @return A list of summary tables and warning flags.
#' @export
summarize_singler_results <- function(
  result_table,
  score_matrix = NULL,
  compare_labels = NULL
) {
  if (!is.data.frame(result_table) || !nrow(result_table)) {
    stop("result_table must be a non-empty data.frame.", call. = FALSE)
  }
  final_label <- as.character(result_table$final_label %||% "")
  final_label[is.na(final_label) | !nzchar(final_label)] <- "Unassigned"
  label_counts <- sort(table(final_label), decreasing = TRUE)
  n_total <- nrow(result_table)
  n_pruned <- sum(as.character(result_table$status %||% "") != "matched", na.rm = TRUE)
  prune_rate <- if (n_total > 0) n_pruned / n_total else 0
  dominant_rate <- if (length(label_counts)) as.numeric(label_counts[[1]]) / n_total else 0
  warnings <- character(0)
  if (is.finite(dominant_rate) && dominant_rate >= 0.8) {
    warnings <- c(warnings, sprintf("One label dominates assignments (%.1f%%).", 100 * dominant_rate))
  }
  if (is.finite(prune_rate) && prune_rate >= 0.4) {
    warnings <- c(warnings, sprintf("High unresolved/pruned fraction (%.1f%%).", 100 * prune_rate))
  }
  conf_tbl <- NULL
  if (!is.null(compare_labels)) {
    comp <- as.character(compare_labels %||% "")
    if (length(comp) == n_total) {
      comp[is.na(comp) | !nzchar(comp)] <- "Unassigned"
      conf_tbl <- as.data.frame.matrix(table(predicted = final_label, reference = comp))
    }
  }
  list(
    label_counts = as.data.frame(label_counts, stringsAsFactors = FALSE),
    total_cells = n_total,
    pruned_cells = n_pruned,
    pruned_fraction = prune_rate,
    warnings = unique(warnings),
    score_matrix = score_matrix,
    confusion = conf_tbl
  )
}

singler_choose_label_columns <- function(metadata, requested = NULL, primary = NULL) {
  md <- as.data.frame(metadata %||% data.frame(), stringsAsFactors = FALSE)
  if (!ncol(md)) stop("Reference metadata has no columns.", call. = FALSE)
  req <- unique(as.character(requested %||% character(0)))
  req <- req[nzchar(req)]
  pri <- as.character(primary %||% "")
  pri <- pri[nzchar(pri)]
  if (!length(req)) {
    candidates <- c("label.main", "label.fine", "cell_type", "celltype", "annotation", "label")
    found <- intersect(candidates, colnames(md))
    if (length(found)) {
      req <- found
    } else {
      req <- colnames(md)[[1]]
    }
  }
  if (length(pri) && !(pri[[1]] %in% req)) req <- c(pri[[1]], req)
  unique(req)
}

singler_ref_as_standard <- function(ref_data, metadata = NULL, assay_name = "logcounts") {
  is_sce <- inherits(ref_data, "SingleCellExperiment")
  is_se <- inherits(ref_data, "SummarizedExperiment")
  if (is_sce || is_se) {
    ref <- ref_data
    md <- tryCatch(as.data.frame(SummarizedExperiment::colData(ref), stringsAsFactors = FALSE), error = function(e) NULL)
    if (is.null(md)) md <- data.frame(row.names = colnames(ref))
    return(list(ref = ref, metadata = md))
  }
  if (is.list(ref_data) && !is.data.frame(ref_data)) {
    if (!is.null(ref_data$ref) && (inherits(ref_data$ref, "SingleCellExperiment") || inherits(ref_data$ref, "SummarizedExperiment"))) {
      ref <- ref_data$ref
      md <- as.data.frame(SummarizedExperiment::colData(ref), stringsAsFactors = FALSE)
      return(list(ref = ref, metadata = md))
    }
    mat <- ref_data$expr %||% ref_data$counts %||% ref_data$matrix %||% NULL
    md <- ref_data$metadata %||% ref_data$meta %||% metadata
    if (is.null(mat)) stop("Reference list input must include expr/counts/matrix.", call. = FALSE)
    ref <- singler_matrix_to_sce(mat, assay_name = assay_name)
    md <- singler_align_metadata(md, colnames(ref))
    SummarizedExperiment::colData(ref) <- S4Vectors::DataFrame(md)
    return(list(ref = ref, metadata = md))
  }
  ref <- singler_matrix_to_sce(ref_data, assay_name = assay_name)
  md <- singler_align_metadata(metadata, colnames(ref))
  SummarizedExperiment::colData(ref) <- S4Vectors::DataFrame(md)
  list(ref = ref, metadata = md)
}

singler_align_metadata <- function(metadata, col_names) {
  if (is.null(metadata)) {
    stop("Metadata is required for matrix-like custom references.", call. = FALSE)
  }
  md <- as.data.frame(metadata, stringsAsFactors = FALSE, check.names = FALSE)
  if (!nrow(md)) {
    stop("Reference metadata is empty.", call. = FALSE)
  }
  if (is.null(rownames(md)) || any(!nzchar(rownames(md)))) {
    rownames(md) <- as.character(md[[1]] %||% "")
  }
  rn <- as.character(rownames(md) %||% character(0))
  if (length(rn) == length(col_names) && all(!is.na(rn)) && all(rn %in% col_names)) {
    md <- md[col_names, , drop = FALSE]
  } else if (nrow(md) == length(col_names)) {
    rownames(md) <- col_names
  } else {
    stop(
      sprintf("Reference metadata rows (%d) do not match reference columns (%d).", nrow(md), length(col_names)),
      call. = FALSE
    )
  }
  md
}

singler_matrix_to_sce <- function(mat, assay_name = "logcounts") {
  if (is.null(mat)) stop("Expression matrix is NULL.", call. = FALSE)
  if (!is.matrix(mat) && !inherits(mat, "Matrix")) mat <- as.matrix(mat)
  if (!is.matrix(mat) && !inherits(mat, "Matrix")) {
    stop("Expression input must be matrix-like.", call. = FALSE)
  }
  gene_names <- rownames(mat) %||% character(0)
  cell_names <- colnames(mat) %||% character(0)
  if (!length(gene_names) || any(!nzchar(gene_names))) {
    stop("Expression matrix must have non-empty gene row names.", call. = FALSE)
  }
  if (!length(cell_names) || any(!nzchar(cell_names))) {
    stop("Expression matrix must have non-empty cell/sample column names.", call. = FALSE)
  }
  SingleCellExperiment::SingleCellExperiment(assays = setNames(list(mat), assay_name))
}

singler_query_as_matrix <- function(query, assay_type = "logcounts") {
  if (inherits(query, "Seurat")) {
    if (!("RNA" %in% Seurat::Assays(query))) {
      stop("Query Seurat object must contain RNA assay.", call. = FALSE)
    }
    return(Seurat::GetAssayData(query, assay = "RNA", slot = "data"))
  }
  if (inherits(query, "SingleCellExperiment")) {
    if (!is.null(assay_type) && nzchar(assay_type) && assay_type %in% SummarizedExperiment::assayNames(query)) {
      return(SummarizedExperiment::assay(query, assay_type))
    }
    return(SummarizedExperiment::assay(query, 1L))
  }
  if (inherits(query, "SummarizedExperiment")) {
    if (!is.null(assay_type) && nzchar(assay_type) && assay_type %in% SummarizedExperiment::assayNames(query)) {
      return(SummarizedExperiment::assay(query, assay_type))
    }
    return(SummarizedExperiment::assay(query, 1L))
  }
  if (is.matrix(query) || inherits(query, "Matrix")) return(query)
  if (is.data.frame(query)) return(as.matrix(query))
  stop("Unsupported query type. Use Seurat, SingleCellExperiment, SummarizedExperiment, or matrix.", call. = FALSE)
}

singler_simple_log_norm <- function(mat) {
  if (!is.matrix(mat) && !inherits(mat, "Matrix")) mat <- as.matrix(mat)
  cs <- suppressWarnings(Matrix::colSums(mat))
  cs[!is.finite(cs) | cs <= 0] <- 1
  scale_fac <- cs / stats::median(cs, na.rm = TRUE)
  scale_fac[!is.finite(scale_fac) | scale_fac <= 0] <- 1
  if (inherits(mat, "dgCMatrix")) {
    norm <- mat
    for (j in seq_len(ncol(norm))) {
      idx <- (norm@p[[j]] + 1L):norm@p[[j + 1L]]
      if (length(idx)) norm@x[idx] <- log1p(norm@x[idx] / scale_fac[[j]])
    }
    return(norm)
  }
  if (inherits(mat, "Matrix")) {
    return(log1p(as.matrix(sweep(as.matrix(mat), 2, scale_fac, "/"))))
  }
  log1p(sweep(mat, 2, scale_fac, "/"))
}
