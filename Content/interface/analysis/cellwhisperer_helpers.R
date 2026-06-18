`%||%` <- get0("%||%", mode = "function", inherits = TRUE, ifnotfound = function(a, b) if (is.null(a)) b else a)

cw_normalize_plugin_url <- function(plugin_url) {
  url <- trimws(as.character(plugin_url %||% ""))
  if (!nzchar(url)) stop("Plugin URL is required.", call. = FALSE)
  if (!grepl("^https?://", url, ignore.case = TRUE, perl = TRUE)) {
    stop("Plugin URL must start with http:// or https://", call. = FALSE)
  }
  sub("/+$", "", url, perl = TRUE)
}

cw_make_cache_key <- function(object_name, query, model = "cellwhisperer_clip_v1") {
  nm <- trimws(as.character(object_name %||% ""))
  qq <- trimws(as.character(query %||% ""))
  mm <- trimws(as.character(model %||% "cellwhisperer_clip_v1"))
  raw <- tolower(paste(nm, qq, mm, sep = "||"))
  safe <- gsub("[^a-z0-9]+", "_", raw, perl = TRUE)
  safe <- gsub("^_+|_+$", "", safe, perl = TRUE)
  if (!nzchar(safe)) safe <- "cw_query"
  if (nchar(safe) > 120) safe <- paste0(substr(safe, 1L, 100L), "_", as.integer(nchar(safe)))
  paste0("cw_", safe)
}

cw_safe_score_col <- function(query, prefix = "cw") {
  qq <- tolower(trimws(as.character(query %||% "")))
  qq <- gsub("[^a-z0-9]+", "_", qq, perl = TRUE)
  qq <- gsub("^_+|_+$", "", qq, perl = TRUE)
  if (!nzchar(qq)) qq <- "query"
  qq <- substr(qq, 1L, 60L)
  paste0(prefix, "_", qq)
}

cw_call_plugin_sync <- function(plugin_url, dataset_id, query, cell_ids,
                                model = "cellwhisperer_clip_v1", timeout_sec = 120,
                                score_type = "logit", token = "") {
  req <- list(
    dataset_id = as.character(dataset_id %||% ""),
    query = as.character(query %||% ""),
    cell_ids = as.character(cell_ids %||% character(0)),
    options = list(
      model = as.character(model %||% "cellwhisperer_clip_v1"),
      score_type = as.character(score_type %||% "logit"),
      return_only_requested_cells = TRUE
    )
  )

  url <- paste0(cw_normalize_plugin_url(plugin_url), "/score")
  h <- c("Content-Type" = "application/json")
  if (nzchar(token %||% "")) h[["Authorization"]] <- paste("Bearer", token)

  res <- httr::POST(
    url = url,
    body = jsonlite::toJSON(req, auto_unbox = TRUE, null = "null"),
    encode = "raw",
    httr::timeout(as.numeric(timeout_sec %||% 120)),
    httr::add_headers(.headers = h)
  )

  status <- httr::status_code(res)
  txt <- httr::content(res, as = "text", encoding = "UTF-8")
  if (status < 200 || status >= 300) {
    stop(sprintf("Plugin /score HTTP %s: %s", status, substr(txt, 1L, 500L)), call. = FALSE)
  }
  jsonlite::fromJSON(txt, simplifyVector = FALSE)
}

cw_call_plugin_async <- function(plugin_url, dataset_id, query, cell_ids,
                                 model = "cellwhisperer_clip_v1", timeout_sec = 120,
                                 poll_interval_sec = 2, max_poll_sec = 180,
                                 score_type = "logit", token = "") {
  req <- list(
    dataset_id = as.character(dataset_id %||% ""),
    query = as.character(query %||% ""),
    cell_ids = as.character(cell_ids %||% character(0)),
    options = list(
      model = as.character(model %||% "cellwhisperer_clip_v1"),
      score_type = as.character(score_type %||% "logit"),
      return_only_requested_cells = TRUE
    )
  )

  base <- cw_normalize_plugin_url(plugin_url)
  async_url <- paste0(base, "/score_async")
  h <- c("Content-Type" = "application/json")
  if (nzchar(token %||% "")) h[["Authorization"]] <- paste("Bearer", token)

  res <- httr::POST(
    url = async_url,
    body = jsonlite::toJSON(req, auto_unbox = TRUE, null = "null"),
    encode = "raw",
    httr::timeout(as.numeric(timeout_sec %||% 120)),
    httr::add_headers(.headers = h)
  )
  status <- httr::status_code(res)
  txt <- httr::content(res, as = "text", encoding = "UTF-8")

  if (status == 404L) return(NULL)
  if (status < 200 || status >= 300) {
    stop(sprintf("Plugin /score_async HTTP %s: %s", status, substr(txt, 1L, 500L)), call. = FALSE)
  }

  start_payload <- jsonlite::fromJSON(txt, simplifyVector = FALSE)
  job_id <- as.character(start_payload$job_id %||% "")
  if (!nzchar(job_id)) stop("Async response missing job_id.", call. = FALSE)

  poll_interval_sec <- max(1, as.integer(poll_interval_sec %||% 2L))
  max_poll_sec <- max(1, as.integer(max_poll_sec %||% 180L))
  t0 <- Sys.time()

  repeat {
    elapsed <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
    if (!is.finite(elapsed)) elapsed <- 0
    if (elapsed > max_poll_sec) stop("Timed out waiting for async CellWhisperer result.", call. = FALSE)

    poll_url <- paste0(base, "/jobs/", utils::URLencode(job_id, reserved = TRUE))
    poll_res <- httr::GET(
      url = poll_url,
      httr::timeout(as.numeric(timeout_sec %||% 120)),
      httr::add_headers(.headers = h)
    )
    poll_status <- httr::status_code(poll_res)
    poll_txt <- httr::content(poll_res, as = "text", encoding = "UTF-8")
    if (poll_status < 200 || poll_status >= 300) {
      stop(sprintf("Plugin job poll HTTP %s: %s", poll_status, substr(poll_txt, 1L, 500L)), call. = FALSE)
    }
    payload <- jsonlite::fromJSON(poll_txt, simplifyVector = FALSE)
    st <- tolower(as.character(payload$status %||% ""))

    if (st %in% c("completed", "succeeded", "success", "done", "finished")) {
      out <- payload$result %||% payload
      return(out)
    }
    if (st %in% c("error", "failed", "cancelled", "canceled")) {
      msg <- as.character(payload$error %||% payload$message %||% "Async job failed")
      stop(msg, call. = FALSE)
    }
    Sys.sleep(poll_interval_sec)
  }
}

cw_call_plugin <- function(plugin_url, dataset_id, query, cell_ids,
                           model = "cellwhisperer_clip_v1", timeout_sec = 120,
                           score_type = "logit", token = "",
                           prefer_async = TRUE, poll_interval_sec = 2,
                           max_poll_sec = 180) {
  if (isTRUE(prefer_async)) {
    async_result <- tryCatch(
      cw_call_plugin_async(
        plugin_url = plugin_url,
        dataset_id = dataset_id,
        query = query,
        cell_ids = cell_ids,
        model = model,
        timeout_sec = timeout_sec,
        poll_interval_sec = poll_interval_sec,
        max_poll_sec = max_poll_sec,
        score_type = score_type,
        token = token
      ),
      error = function(e) {
        msg <- conditionMessage(e)
        if (grepl("HTTP 404|missing job_id", msg, ignore.case = TRUE, perl = TRUE)) return(NULL)
        stop(e)
      }
    )
    if (!is.null(async_result)) return(async_result)
  }

  cw_call_plugin_sync(
    plugin_url = plugin_url,
    dataset_id = dataset_id,
    query = query,
    cell_ids = cell_ids,
    model = model,
    timeout_sec = timeout_sec,
    score_type = score_type,
    token = token
  )
}

cw_parse_scores <- function(response, expected_cell_ids) {
  if (!is.list(response)) stop("Invalid plugin response format.", call. = FALSE)
  sc <- response$scores
  if (is.null(sc)) stop("Plugin response missing 'scores'.", call. = FALSE)

  if (is.data.frame(sc) && all(c("cell_id", "score") %in% colnames(sc))) {
    vals <- suppressWarnings(as.numeric(sc$score))
    nms <- as.character(sc$cell_id)
    names(vals) <- nms
    return(vals)
  }

  if (!is.null(names(sc)) && length(sc)) {
    vals <- suppressWarnings(as.numeric(unlist(sc, use.names = FALSE)))
    nms <- as.character(names(sc))
    names(vals) <- nms
    return(vals)
  }

  stop("Unable to parse 'scores' from plugin response.", call. = FALSE)
}

cw_validate_scores <- function(scores_named, expected_cell_ids) {
  if (is.null(scores_named) || !length(scores_named)) stop("No scores returned.", call. = FALSE)
  if (is.null(names(scores_named)) || !length(names(scores_named))) {
    stop("Scores must be a named vector keyed by cell barcode.", call. = FALSE)
  }
  if (!is.numeric(scores_named)) stop("Scores must be numeric.", call. = FALSE)

  bad <- !is.finite(scores_named)
  if (any(bad)) {
    bad_nm <- unique(as.character(names(scores_named)[bad]))
    stop(sprintf("Scores include non-finite values (e.g., %s).", paste(utils::head(bad_nm, 5), collapse = ", ")), call. = FALSE)
  }

  exp_ids <- as.character(expected_cell_ids %||% character(0))
  got_ids <- as.character(names(scores_named) %||% character(0))
  missing_ids <- setdiff(exp_ids, got_ids)
  if (length(missing_ids)) {
    stop(sprintf(
      "Plugin scores missing %d/%d requested cells (examples: %s)",
      length(missing_ids), length(exp_ids), paste(utils::head(missing_ids, 5), collapse = ", ")
    ), call. = FALSE)
  }

  extra_ids <- setdiff(got_ids, exp_ids)
  if (length(extra_ids)) {
    warning(sprintf("Plugin returned %d extra cells; extras ignored.", length(extra_ids)), call. = FALSE)
  }

  aligned <- scores_named[exp_ids]
  if (any(!is.finite(aligned))) {
    stop("Aligned scores include invalid values.", call. = FALSE)
  }
  aligned
}

cw_attach_scores_to_object <- function(sobj, scores, score_col = "cw_active_score") {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) stop("Invalid Seurat object.", call. = FALSE)
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !is.data.frame(md) || !nrow(md)) stop("Seurat object has no meta.data.", call. = FALSE)

  cells <- rownames(md)
  aligned <- cw_validate_scores(scores_named = scores, expected_cell_ids = cells)
  md[[as.character(score_col %||% "cw_active_score")]] <- as.numeric(aligned)
  sobj@meta.data <- md
  sobj
}

cw_cluster_score_summary <- function(sobj, score_col = "cw_active_score", cluster_col = "seurat_clusters") {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(data.frame())
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !is.data.frame(md) || !nrow(md)) return(data.frame())
  if (!(score_col %in% colnames(md))) return(data.frame())

  score <- suppressWarnings(as.numeric(md[[score_col]]))
  cl_col <- if (cluster_col %in% colnames(md)) cluster_col else ""
  if (!nzchar(cl_col)) {
    cand <- colnames(md)[grepl("seurat_clusters|cluster|_res\\.|ident", colnames(md), ignore.case = TRUE, perl = TRUE)]
    if (length(cand)) cl_col <- cand[[1]]
  }
  if (!nzchar(cl_col) || !(cl_col %in% colnames(md))) return(data.frame())

  cl <- as.character(md[[cl_col]])
  cl[is.na(cl) | !nzchar(cl)] <- "NA"
  keep <- is.finite(score)
  if (!any(keep)) return(data.frame())

  df <- data.frame(cluster = cl[keep], score = score[keep], stringsAsFactors = FALSE)
  sp <- split(df$score, df$cluster)
  out <- data.frame(
    cluster = names(sp),
    n_cells = as.integer(vapply(sp, length, integer(1))),
    mean_score = as.numeric(vapply(sp, mean, numeric(1), na.rm = TRUE)),
    median_score = as.numeric(vapply(sp, stats::median, numeric(1), na.rm = TRUE)),
    max_score = as.numeric(vapply(sp, max, numeric(1), na.rm = TRUE)),
    min_score = as.numeric(vapply(sp, min, numeric(1), na.rm = TRUE)),
    stringsAsFactors = FALSE
  )
  out[order(-out$median_score, out$cluster), , drop = FALSE]
}

cw_cache_get <- function(analysis_cache, cache_key) {
  ac <- analysis_cache %||% list()
  cw <- ac$cellwhisperer %||% list()
  cw[[as.character(cache_key %||% "")]] %||% NULL
}

cw_cache_set <- function(analysis_cache, cache_key, payload) {
  ac <- analysis_cache %||% list()
  if (is.null(ac$cellwhisperer) || !is.list(ac$cellwhisperer)) ac$cellwhisperer <- list()
  ac$cellwhisperer[[as.character(cache_key %||% "")]] <- payload
  ac
}

cw_cache_list_keys <- function(analysis_cache) {
  ac <- analysis_cache %||% list()
  cw <- ac$cellwhisperer %||% list()
  keys <- names(cw) %||% character(0)
  keys[!is.na(keys) & nzchar(keys)]
}

cw_is_nonlocal_http <- function(url) {
  uu <- tolower(trimws(as.character(url %||% "")))
  if (!grepl("^https?://", uu)) return(FALSE)
  host <- sub("^https?://", "", uu)
  host <- sub("[:/].*$", "", host)
  !(host %in% c("127.0.0.1", "localhost", "::1"))
}
