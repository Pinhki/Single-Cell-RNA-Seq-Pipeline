`%||%` <- get0("%||%", mode = "function", inherits = TRUE, ifnotfound = function(a, b) if (is.null(a)) b else a)

annotation_parse_res_value <- function(colname) {
  txt <- as.character(colname %||% "")
  m <- regexpr("([0-9]+\\.?[0-9]*)$", txt, perl = TRUE)
  if (m[1] < 0) return(NA_real_)
  suppressWarnings(as.numeric(substr(txt, m[1], m[1] + attr(m, "match.length")[1] - 1L)))
}

annotation_sanitize_layer_name <- function(x) {
  y <- gsub("[^A-Za-z0-9_]+", "_", as.character(x %||% "layer"))
  y <- gsub("_+", "_", y)
  y <- gsub("^_|_$", "", y)
  if (!nzchar(y)) y <- "layer"
  y
}

annotation_default_layer_base <- function(tool_name = "singleR", requested_name = "") {
  tool_name_raw <- trimws(as.character(tool_name %||% "singleR"))
  tool_name_low <- tolower(tool_name_raw)
  tool_id <- switch(
    tool_name_low,
    "singler" = "singleR",
    "celltypist" = "celltypist",
    "markergene" = "markerGene",
    if (nzchar(tool_name_raw)) tool_name_raw else "annotation"
  )
  requested <- trimws(as.character(requested_name %||% ""))
  if (!nzchar(requested) || identical(requested, "tool_annotation")) {
    return(paste0(tool_id, "_annotation"))
  }
  requested <- sub("^tool_", paste0(tool_id, "_"), requested)
  if (!grepl("_annotation", requested, fixed = TRUE)) {
    requested <- paste0(requested, "_annotation")
  }
  requested
}

annotation_resolution_suffix <- function(cluster_col) {
  rv <- annotation_parse_res_value(cluster_col)
  if (is.finite(rv)) {
    txt <- format(rv, trim = TRUE, scientific = FALSE)
    txt <- sub("\\.?0+$", "", txt)
    if (!nzchar(txt)) txt <- "0"
    return(paste0("res_", txt))
  }
  paste0("res_", tolower(annotation_sanitize_layer_name(cluster_col)))
}

annotation_singler_layer_name <- function(base_name, cluster_col) {
  base <- annotation_default_layer_base("singleR", base_name)
  suffix <- annotation_resolution_suffix(cluster_col)
  paste0(base, "_", suffix)
}

annotation_markergene_layer_name <- function(base_name, cluster_col) {
  base <- annotation_default_layer_base("markerGene", base_name)
  suffix <- annotation_resolution_suffix(cluster_col)
  paste0(base, "_", suffix)
}

annotation_layer_params <- function(layer) {
  if (is.list(layer$params)) return(layer$params)
  raw <- as.character(layer$params_json %||% "")
  if (!nzchar(raw)) return(list())
  out <- tryCatch(jsonlite::fromJSON(raw, simplifyVector = FALSE), error = function(e) list())
  if (is.list(out)) out else list()
}

annotation_singler_resolution_choices <- function(bucket) {
  if (is.null(bucket) || !length(bucket)) return(setNames(character(0), character(0)))
  keep_layers <- names(bucket)[vapply(names(bucket), function(nm) {
    layer <- bucket[[nm]]
    if (!identical(as.character(layer$tool_name %||% ""), "SingleR")) return(FALSE)
    if (!grepl("_annotation", nm, fixed = TRUE)) return(FALSE)
    params <- annotation_layer_params(layer)
    identical(as.character(params$run_mode %||% ""), "multi_resolution")
  }, logical(1))]
  if (!length(keep_layers)) return(setNames(character(0), character(0)))

  info <- lapply(keep_layers, function(nm) {
    params <- annotation_layer_params(bucket[[nm]])
    cl_col <- as.character(params$cluster_column %||% "")
    rv <- annotation_parse_res_value(cl_col)
    ref_name <- as.character(params$reference %||% "")
    label <- if (is.finite(rv)) {
      paste0("Resolution ", format(rv, trim = TRUE, scientific = FALSE))
    } else if (nzchar(cl_col)) {
      cl_col
    } else {
      nm
    }
    list(
      layer_name = nm,
      cluster_column = cl_col,
      resolution_value = rv,
      label = label,
      reference = ref_name
    )
  })

  ord <- order(
    vapply(info, function(x) if (is.finite(x$resolution_value)) x$resolution_value else Inf, numeric(1)),
    vapply(info, function(x) x$label, character(1))
  )
  info <- info[ord]
  labels <- vapply(info, function(x) x$label, character(1))
  if (anyDuplicated(labels)) {
    labels <- vapply(info, function(x) {
      ref_txt <- if (nzchar(x$reference)) paste0(" [", x$reference, "]") else ""
      paste0(x$label, ref_txt)
    }, character(1))
  }
  values <- vapply(info, function(x) x$layer_name, character(1))
  stats::setNames(values, labels)
}

annotation_markergene_resolution_choices <- function(bucket) {
  if (is.null(bucket) || !length(bucket)) return(setNames(character(0), character(0)))
  keep_layers <- names(bucket)[vapply(names(bucket), function(nm) {
    layer <- bucket[[nm]]
    if (!identical(as.character(layer$tool_name %||% ""), "markerGene")) return(FALSE)
    if (!grepl("_annotation", nm, fixed = TRUE)) return(FALSE)
    params <- annotation_layer_params(layer)
    identical(as.character(params$run_mode %||% ""), "multi_resolution")
  }, logical(1))]
  if (!length(keep_layers)) return(setNames(character(0), character(0)))

  info <- lapply(keep_layers, function(nm) {
    params <- annotation_layer_params(bucket[[nm]])
    cl_col <- as.character(params$cluster_column %||% "")
    rv <- annotation_parse_res_value(cl_col)
    method <- as.character(params$scoring_method %||% "module+enrichment")
    label <- if (is.finite(rv)) {
      paste0("Resolution ", format(rv, trim = TRUE, scientific = FALSE))
    } else if (nzchar(cl_col)) {
      cl_col
    } else {
      nm
    }
    list(
      layer_name = nm,
      cluster_column = cl_col,
      resolution_value = rv,
      label = label,
      method = method
    )
  })

  ord <- order(
    vapply(info, function(x) if (is.finite(x$resolution_value)) x$resolution_value else Inf, numeric(1)),
    vapply(info, function(x) x$label, character(1))
  )
  info <- info[ord]
  labels <- vapply(info, function(x) x$label, character(1))
  if (anyDuplicated(labels)) {
    labels <- vapply(info, function(x) paste0(x$label, " [", x$method, "]"), character(1))
  }
  values <- vapply(info, function(x) x$layer_name, character(1))
  stats::setNames(values, labels)
}
