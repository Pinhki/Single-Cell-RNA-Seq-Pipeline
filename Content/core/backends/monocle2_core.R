# monocle2_core.R

`%||%` <- function(a, b) if (is.null(a)) b else a

# Runtime compatibility shim for monocle2 on modern igraph.
# monocle2 legacy internals may call deprecated igraph helpers
# (e.g., nei/neimode/graph.neighborhood/graph.dfs) that can fail on newer igraph.
# We patch igraph + monocle import bindings in-memory so legacy calls are
# normalized to modern APIs without requiring package re-install.
.monocle2_patch_igraph_compat_runtime <- local({
  patched <- FALSE
  last_report <- list(ok = FALSE, issues = "not-run")
  .set_report <- function(rep) {
    last_report <<- rep
    options(monocle2_compat_last_report = rep)
    invisible(NULL)
  }
  .set_binding <- function(env, name, value) {
    if (!exists(name, envir = env, inherits = FALSE)) return(FALSE)
    was_locked <- FALSE
    ok <- TRUE
    tryCatch({
      was_locked <- bindingIsLocked(name, env)
      if (isTRUE(was_locked)) unlockBinding(name, env)
      assign(name, value, envir = env)
    }, error = function(e) {
      ok <<- FALSE
    }, finally = {
      if (isTRUE(was_locked)) {
        try(lockBinding(name, env), silent = TRUE)
      }
    })
    isTRUE(ok)
  }
  .legacy_pattern <- "(?<![[:alnum:]_\\.])nei\\(|\\bneimode\\s*=|(?<![[:alnum:]_\\.])graph\\.dfs\\(|(?<![[:alnum:]_\\.])graph\\.neighborhood\\("
  .rewrite_monocle_fun <- function(fun) {
    txt <- paste(deparse(body(fun)), collapse = "\n")
    if (!grepl(.legacy_pattern, txt, perl = TRUE)) {
      return(list(fun = fun, changed = FALSE, parse_error = ""))
    }
    txt2 <- txt
    txt2 <- gsub("(?<![[:alnum:]_\\.])nei\\(", ".nei(", txt2, perl = TRUE)
    txt2 <- gsub("\\bneimode\\s*=", "mode =", txt2, perl = TRUE)
    txt2 <- gsub("(?<![[:alnum:]_\\.])graph\\.dfs\\(", "dfs(", txt2, perl = TRUE)
    txt2 <- gsub("(?<![[:alnum:]_\\.])graph\\.neighborhood\\(", "neighborhood(", txt2, perl = TRUE)
    expr <- tryCatch(parse(text = txt2)[[1]], error = function(e) e)
    if (inherits(expr, "error")) {
      return(list(fun = fun, changed = FALSE, parse_error = conditionMessage(expr)))
    }
    body(fun) <- expr
    list(fun = fun, changed = TRUE, parse_error = "")
  }
  .legacy_monocle_fns <- function(ns_m) {
    nms <- ls(ns_m, all.names = TRUE)
    keep <- character(0)
    for (nm in nms) {
      fn <- get0(nm, envir = ns_m, mode = "function", inherits = FALSE)
      if (!is.function(fn)) next
      txt <- paste(deparse(body(fn)), collapse = "\n")
      if (grepl(.legacy_pattern, txt, perl = TRUE)) keep <- c(keep, nm)
    }
    sort(unique(keep))
  }
  .wrap_dfs <- function(old_fun) {
    force(old_fun)
    function(...) {
      args <- list(...)
      if (!is.null(args$neimode) && is.null(args$mode)) args$mode <- args$neimode
      args$neimode <- NULL
      do.call(old_fun, args)
    }
  }
  .wrap_neighborhood <- function(old_fun) {
    force(old_fun)
    function(...) {
      args <- list(...)
      if (!is.null(args$neimode) && is.null(args$mode)) args$mode <- args$neimode
      args$neimode <- NULL
      if (is.null(args$mindist)) args$mindist <- 0
      ns_i <- asNamespace("igraph")
      ego_fun <- get0("ego", envir = ns_i, mode = "function", inherits = FALSE)
      if (is.function(ego_fun)) return(do.call(ego_fun, args))
      do.call(old_fun, args)
    }
  }
  .compat_nei_fun <- function() {
    ns_i <- asNamespace("igraph")
    fn <- get0(".nei", envir = ns_i, mode = "function", inherits = FALSE)
    if (is.function(fn)) return(fn)
    function(...) {
      fn2 <- get0("neighbors", envir = ns_i, mode = "function", inherits = FALSE)
      if (!is.function(fn2)) stop("igraph neighbor helper is unavailable for Monocle2 compatibility.")
      do.call(fn2, list(...))
    }
  }
  .compat_smoke <- function() {
    g <- igraph::make_ring(5)
    suppressWarnings(igraph::dfs(g, root = 1, mode = "all"))
    ns_i <- asNamespace("igraph")
    neighbors_fun <- get0("neighbors", envir = ns_i, mode = "function", inherits = FALSE)
    if (!is.function(neighbors_fun)) {
      stop("igraph neighbors() helper is unavailable for compatibility smoke check.")
    }
    vv <- suppressWarnings(neighbors_fun(g, 1, mode = "all"))
    if (is.null(vv) || length(vv) < 1L) {
      stop("igraph neighbors() returned empty result in compatibility smoke check.")
    }
    TRUE
  }
  function(force = FALSE, run_smoke = TRUE) {
    if (!isTRUE(force) && isTRUE(patched)) return(invisible(TRUE))
    if (!requireNamespace("igraph", quietly = TRUE)) {
      patched <<- FALSE
      .set_report(list(ok = FALSE, issues = "igraph is unavailable"))
      return(invisible(FALSE))
    }

    ns <- asNamespace("igraph")
    patched_any <- FALSE
    issues <- character(0)
    nei_fun <- .compat_nei_fun()

    for (fname in c("dfs", "graph.dfs")) {
      if (!exists(fname, envir = ns, inherits = FALSE)) next
      old <- get(fname, envir = ns, inherits = FALSE)
      if (!is.function(old)) next
      patched_any <- .set_binding(ns, fname, .wrap_dfs(old)) || patched_any
    }

    for (fname in c("graph.neighborhood", "neighborhood")) {
      if (!exists(fname, envir = ns, inherits = FALSE)) next
      old <- get(fname, envir = ns, inherits = FALSE)
      if (!is.function(old)) next
      patched_any <- .set_binding(ns, fname, .wrap_neighborhood(old)) || patched_any
    }

    if (exists("nei", envir = ns, inherits = FALSE)) {
      ok_nei <- .set_binding(ns, "nei", nei_fun)
      patched_any <- ok_nei || patched_any
    }

    # Patch monocle namespace/import bindings when present.
    if (requireNamespace("monocle", quietly = TRUE)) {
      ns_m <- asNamespace("monocle")
      envs <- list(ns_m, parent.env(ns_m))

      for (env in envs) {
        if (exists("graph.dfs", envir = env, inherits = FALSE) && exists("dfs", envir = ns, inherits = FALSE)) {
          patched_any <- .set_binding(env, "graph.dfs", .wrap_dfs(get("dfs", envir = ns, inherits = FALSE))) || patched_any
        }
        if (exists("dfs", envir = env, inherits = FALSE) && exists("dfs", envir = ns, inherits = FALSE)) {
          patched_any <- .set_binding(env, "dfs", .wrap_dfs(get("dfs", envir = ns, inherits = FALSE))) || patched_any
        }
        if (exists("graph.neighborhood", envir = env, inherits = FALSE) && exists("neighborhood", envir = ns, inherits = FALSE)) {
          patched_any <- .set_binding(env, "graph.neighborhood", .wrap_neighborhood(get("neighborhood", envir = ns, inherits = FALSE))) || patched_any
        }
        if (exists("neighborhood", envir = env, inherits = FALSE) && exists("neighborhood", envir = ns, inherits = FALSE)) {
          patched_any <- .set_binding(env, "neighborhood", .wrap_neighborhood(get("neighborhood", envir = ns, inherits = FALSE))) || patched_any
        }
        if (exists("nei", envir = env, inherits = FALSE)) {
          patched_any <- .set_binding(env, "nei", nei_fun) || patched_any
        }
      }

      legacy_before <- .legacy_monocle_fns(ns_m)
      if (length(legacy_before)) {
        for (fname in legacy_before) {
          fn <- get(fname, envir = ns_m, inherits = FALSE)
          rw <- .rewrite_monocle_fun(fn)
          if (nzchar(rw$parse_error %||% "")) {
            issues <- c(issues, sprintf("Failed to rewrite monocle::%s (%s).", fname, rw$parse_error))
            next
          }
          if (!isTRUE(rw$changed)) next
          ok_fn <- .set_binding(ns_m, fname, rw$fun)
          patched_any <- ok_fn || patched_any
          if (!isTRUE(ok_fn)) issues <- c(issues, sprintf("Failed to update monocle::%s in namespace.", fname))
        }
      }

      legacy_after <- .legacy_monocle_fns(ns_m)
      if (length(legacy_after)) {
        issues <- c(issues, paste0("Legacy igraph calls remain in monocle namespace: ", paste(legacy_after, collapse = ", ")))
      }
    }

    if (isTRUE(run_smoke)) {
      smoke_err <- NULL
      tryCatch({
        .compat_smoke()
      }, error = function(e) {
        smoke_err <<- conditionMessage(e)
      })
      if (nzchar(smoke_err %||% "")) {
        issues <- c(issues, paste("igraph compatibility smoke test failed:", smoke_err))
      }
    }

    ok <- !length(issues)
    .set_report(list(ok = ok, issues = unique(issues), patched_any = patched_any))
    patched <<- isTRUE(ok)
    if (isTRUE(ok) && isTRUE(patched_any)) {
      message("[monocle2] Applied runtime igraph compatibility shim (nei/neimode/neighborhood).")
    }
    if (!isTRUE(ok)) {
      warning("[monocle2] igraph compatibility shim failed: ", paste(unique(issues), collapse = " | "), call. = FALSE, immediate. = TRUE)
    }
    invisible(isTRUE(ok))
  }
})

monocle2_beta_runtime_guard <- function(
  expected_igraph = "2.2.2",
  min_monocle = "2.34.0",
  require_core_lib = TRUE,
  run_compat_smoke = FALSE
) {
  .cmp <- function(a, b) tryCatch(utils::compareVersion(as.character(a), as.character(b)), error = function(e) NA_integer_)
  .norm_path <- function(p) {
    pv <- as.character(p)
    pv <- pv[!is.na(pv)]
    pv <- pv[nzchar(pv)]
    if (!length(pv)) return(character(0))

    out <- vapply(pv, function(x0) {
      x <- gsub("\\\\", "/", x0)
      x <- gsub("/+", "/", x)
      x <- sub("/+$", "", x)
      x <- tryCatch(normalizePath(x, winslash = "/", mustWork = FALSE), error = function(e) x)
      x <- gsub("\\\\", "/", x)
      x <- gsub("/+", "/", x)
      x <- sub("/+$", "", x)
      tolower(x)
    }, character(1))
    unique(out[nzchar(out)])
  }
  .tail_eq <- function(a, b, n = 3L) {
    sa <- unlist(strsplit(a, "/+", fixed = FALSE), use.names = FALSE)
    sb <- unlist(strsplit(b, "/+", fixed = FALSE), use.names = FALSE)
    sa <- sa[nzchar(sa)]
    sb <- sb[nzchar(sb)]
    if (length(sa) < n || length(sb) < n) return(FALSE)
    identical(tail(sa, n), tail(sb, n))
  }
  .is_core_tail <- function(p) grepl("(^|/)package_libraries/core$", p)
  .path_in_core <- function(pkg_path, core_candidates) {
    if (is.na(pkg_path) || !nzchar(pkg_path)) return(FALSE)
    pkg_path_norm <- .norm_path(pkg_path)
    if (length(pkg_path_norm)) {
      rawp <- pkg_path_norm[[1]]
      if (grepl("(^|/)package_libraries/core(/|$)", rawp)) return(TRUE)
    }
    pkg_lib <- .norm_path(dirname(pkg_path))
    if (!length(pkg_lib)) return(FALSE)
    pkg_lib <- pkg_lib[[1]]

    cand <- core_candidates
    cand <- cand[nzchar(cand)]
    cand <- unique(cand)
    if (length(cand)) {
      for (cc in cand) {
        if (identical(pkg_lib, cc) || startsWith(pkg_lib, cc)) return(TRUE)
        if (.tail_eq(pkg_lib, cc, n = 3L) && .is_core_tail(pkg_lib) && .is_core_tail(cc)) return(TRUE)
      }
    }

    # Fallback for staged/mapped runtime paths: accept canonical project-managed tail.
    .is_core_tail(pkg_lib)
  }

  core_lib <- normalizePath(file.path(getwd(), "package_libraries", "core"), winslash = "/", mustWork = FALSE)
  core_lib <- .norm_path(core_lib)
  core_lib <- if (length(core_lib)) core_lib[[1]] else ""
  core_candidates <- unique(c(
    core_lib,
    .norm_path(Sys.getenv("WANLAB_CORE_LIB_PATH", "")),
    .norm_path(Sys.getenv("WANLAB_CORE_LIB", "")),
    .norm_path(.libPaths())
  ))
  core_candidates <- core_candidates[nzchar(core_candidates)]
  core_candidates <- unique(c(core_candidates[grepl("(^|/)package_libraries/core$", core_candidates)], core_candidates))
  has_igraph <- requireNamespace("igraph", quietly = TRUE)
  has_monocle <- requireNamespace("monocle", quietly = TRUE)
  has_ddrtree <- requireNamespace("DDRTree", quietly = TRUE)

  igraph_v <- if (has_igraph) tryCatch(as.character(utils::packageVersion("igraph")), error = function(e) NA_character_) else NA_character_
  monocle_v <- if (has_monocle) tryCatch(as.character(utils::packageVersion("monocle")), error = function(e) NA_character_) else NA_character_
  igraph_path <- if (has_igraph) tryCatch(find.package("igraph"), error = function(e) NA_character_) else NA_character_
  monocle_path <- if (has_monocle) tryCatch(find.package("monocle"), error = function(e) NA_character_) else NA_character_
  igraph_lib <- if (has_igraph) .norm_path(dirname(igraph_path)) else character(0)
  monocle_lib <- if (has_monocle) .norm_path(dirname(monocle_path)) else character(0)
  igraph_lib <- if (length(igraph_lib)) igraph_lib[[1]] else ""
  monocle_lib <- if (length(monocle_lib)) monocle_lib[[1]] else ""

  issues <- character(0)
  if (!isTRUE(has_igraph)) issues <- c(issues, "Package 'igraph' is not available.")
  if (!isTRUE(has_monocle)) issues <- c(issues, "Package 'monocle' is not available.")
  if (!isTRUE(has_ddrtree)) issues <- c(issues, "Package 'DDRTree' is not available.")

  if (isTRUE(has_igraph) && nzchar(expected_igraph %||% "")) {
    if (!isTRUE(.cmp(igraph_v, expected_igraph) == 0L)) {
      issues <- c(issues, sprintf("igraph version mismatch: expected %s, loaded %s.", expected_igraph, igraph_v %||% "NA"))
    }
  }
  if (isTRUE(has_monocle) && nzchar(min_monocle %||% "")) {
    cmp_m <- .cmp(monocle_v, min_monocle)
    if (is.na(cmp_m) || cmp_m < 0L) {
      issues <- c(issues, sprintf("monocle version too old: require >= %s, loaded %s.", min_monocle, monocle_v %||% "NA"))
    }
  }

  if (isTRUE(require_core_lib)) {
    if (isTRUE(has_igraph) && !.path_in_core(igraph_path, core_candidates)) {
      issues <- c(issues, sprintf("igraph is not loaded from project core library: %s", igraph_path))
    }
    if (isTRUE(has_monocle) && !.path_in_core(monocle_path, core_candidates)) {
      issues <- c(issues, sprintf("monocle is not loaded from project core library: %s", monocle_path))
    }
    if (isTRUE(has_igraph) && isTRUE(has_monocle) && nzchar(igraph_lib) && nzchar(monocle_lib) && !identical(igraph_lib, monocle_lib)) {
      issues <- c(issues, sprintf("igraph and monocle are loaded from different libraries (%s vs %s).", igraph_lib, monocle_lib))
    }
  }

  if (!length(issues) && isTRUE(has_igraph) && isTRUE(run_compat_smoke)) {
    ok_patch <- .monocle2_patch_igraph_compat_runtime(force = TRUE, run_smoke = TRUE)
    if (!isTRUE(ok_patch)) {
      issues <- c(issues, "igraph compatibility shim could not be applied successfully.")
    }
  }

  ok <- !length(issues)
  summary <- if (ok) {
    sprintf("Runtime check passed: monocle %s + igraph %s (project core library).", monocle_v, igraph_v)
  } else {
    paste("Runtime check failed:", paste(issues, collapse = " "))
  }

  list(
    ok = ok,
    summary = summary,
    issues = issues,
    versions = list(igraph = igraph_v, monocle = monocle_v),
    paths = list(igraph = igraph_path, monocle = monocle_path, igraph_lib = igraph_lib, monocle_lib = monocle_lib, core = core_lib)
  )
}

monocle2_beta_last_compat_report <- function() {
  rep <- getOption("monocle2_compat_last_report", NULL)
  if (is.null(rep)) {
    return(list(ok = NA, issues = "compatibility patch report unavailable", patched_any = NA))
  }
  rep
}

monocle2_beta_object_names <- function(shared_data) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm in names(reg_flt)) if (is.null(reg[[nm]])) reg[[nm]] <- reg_flt[[nm]]

  nms <- names(reg)
  if (!length(nms)) return(character(0))
  nms <- nms[nzchar(nms)]
  if (!length(nms)) return(character(0))

  keep <- vapply(nms, function(nm) {
    x <- reg[[nm]]
    obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
    inherits(obj, "Seurat")
  }, logical(1))
  unique(nms[keep])
}

monocle2_beta_get_object <- function(shared_data, object_name = NULL) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm0 in names(reg_flt)) if (is.null(reg[[nm0]])) reg[[nm0]] <- reg_flt[[nm0]]

  valid_nms <- monocle2_beta_object_names(shared_data)
  nm <- as.character(object_name %||% "")
  if (!nzchar(nm)) nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
  if (!nzchar(nm) || !(nm %in% valid_nms)) nm <- if (length(valid_nms)) valid_nms[[1]] else ""
  if (!nzchar(nm) || !(nm %in% names(reg))) return(NULL)

  x <- reg[[nm]]
  obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
  if (!inherits(obj, "Seurat")) return(NULL)
  obj
}

monocle2_beta_meta_cols <- function(sobj) {
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !nrow(md)) return(character(0))
  cols <- colnames(md)
  keep <- vapply(cols, function(cn) {
    v <- md[[cn]]
    v <- v[!is.na(v)]
    if (!length(v)) return(FALSE)
    nu <- length(unique(as.character(v)))
    if (nu < 2L) return(FALSE)
    if (is.numeric(v) || is.integer(v)) {
      return(nu <= max(30L, floor(0.2 * length(v))))
    }
    TRUE
  }, logical(1))
  cols[keep]
}

monocle2_beta_default_group <- function(cols) {
  p <- c("seurat_clusters", "celltype", "orig.ident", "sample", "condition", "batch")
  h <- intersect(p, cols)
  if (length(h)) h[[1]] else if (length(cols)) cols[[1]] else ""
}

monocle2_beta_assays <- function(sobj) {
  aa <- tryCatch(names(sobj@assays), error = function(e) character(0))
  aa[nzchar(aa)]
}

monocle2_beta_default_assay <- function(sobj) {
  aa <- monocle2_beta_assays(sobj)
  if (!length(aa)) return("")
  if ("RNA" %in% aa) return("RNA")
  da <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "")
  if (nzchar(da) && da %in% aa) return(da)
  aa[[1]]
}

.monocle2_get_counts <- function(sobj, assay = NULL) {
  aa <- monocle2_beta_assays(sobj)
  use_assay <- as.character(assay %||% "")
  if (!nzchar(use_assay) || !(use_assay %in% aa)) use_assay <- monocle2_beta_default_assay(sobj)
  if (!nzchar(use_assay)) stop("No assay available for Monocle2.")

  Seurat::DefaultAssay(sobj) <- use_assay
  m <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, layer = "counts"), error = function(e) NULL)
  if (is.null(m)) m <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, slot = "counts"), error = function(e) NULL)
  if (is.null(m)) m <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, layer = "data"), error = function(e) NULL)
  if (is.null(m)) m <- tryCatch(Seurat::GetAssayData(sobj, assay = use_assay, slot = "data"), error = function(e) NULL)
  if (is.null(m)) stop("Could not read expression matrix for Monocle2.")

  if (!inherits(m, "dgCMatrix")) {
    m <- tryCatch(Matrix::Matrix(m, sparse = TRUE), error = function(e) as.matrix(m))
  }
  m <- m[rowSums(m) > 0, , drop = FALSE]
  if (!nrow(m) || !ncol(m)) stop("Expression matrix is empty after filtering zero rows.")
  list(matrix = m, assay = use_assay)
}

.monocle2_pick_ordering_genes <- function(sobj, mat, n_genes = 1000L) {
  n_genes <- max(50L, as.integer(n_genes %||% 1000L))
  vf <- tryCatch(Seurat::VariableFeatures(sobj), error = function(e) character(0))
  vf <- intersect(vf, rownames(mat))
  if (length(vf) >= 50L) {
    return(utils::head(vf, n_genes))
  }
  m <- as.matrix(mat)
  rv <- if (requireNamespace("matrixStats", quietly = TRUE)) {
    matrixStats::rowVars(m)
  } else {
    if (ncol(m) <= 1L) {
      rep(0, nrow(m))
    } else {
      mu <- rowMeans(m, na.rm = TRUE)
      rowMeans((m - mu)^2, na.rm = TRUE)
    }
  }
  rv[!is.finite(rv)] <- 0
  ord <- order(rv, decreasing = TRUE)
  rownames(mat)[utils::head(ord, min(n_genes, length(ord)))]
}

.monocle2_embeddings_from_cds <- function(cds) {
  rs <- tryCatch(monocle::reducedDimS(cds), error = function(e) NULL)
  if (is.null(rs)) stop("Monocle2 reduced dimension matrix is missing.")
  if (nrow(rs) < 2L) stop("Monocle2 reduced dimension has fewer than 2 components.")
  emb <- data.frame(
    cell = colnames(rs),
    x = as.numeric(rs[1, ]),
    y = as.numeric(rs[2, ]),
    stringsAsFactors = FALSE
  )
  emb
}

monocle2_beta_run_trajectory <- function(
  sobj,
  group_col,
  assay = NULL,
  ordering_genes = 1000L,
  max_components = 2L,
  reduction_method = "DDRTree",
  min_expr = 0.1,
  root_state = NULL,
  reverse = FALSE
) {
  if (!requireNamespace("monocle", quietly = TRUE)) stop("Package 'monocle' is not available in the active environment.")
  if (!requireNamespace("VGAM", quietly = TRUE)) stop("Package 'VGAM' is required for Monocle2.")
  if (!requireNamespace("DDRTree", quietly = TRUE)) stop("Package 'DDRTree' is required for Monocle2 trajectory reduction.")
  if (!isTRUE(.monocle2_patch_igraph_compat_runtime(force = TRUE, run_smoke = TRUE))) {
    rep <- monocle2_beta_last_compat_report()
    msg <- paste(
      "Monocle2 igraph compatibility patch failed.",
      paste(as.character(rep$issues %||% "unknown"), collapse = " | ")
    )
    stop(msg)
  }
  if (!inherits(sobj, "Seurat")) stop("Input object must be a Seurat object.")

  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !(group_col %in% colnames(md))) stop("Group column not found in metadata.")

  cts <- .monocle2_get_counts(sobj, assay = assay)
  m <- cts$matrix
  assay_use <- cts$assay

  cell_ids <- colnames(m)
  md_use <- md[cell_ids, , drop = FALSE]
  md_use[[group_col]] <- as.character(md_use[[group_col]])
  md_use[[group_col]][is.na(md_use[[group_col]]) | !nzchar(md_use[[group_col]])] <- "Unknown"

  if (length(unique(md_use[[group_col]])) > 80L) {
    stop("Selected grouping column has too many unique values (>80). Choose a categorical metadata column.")
  }

  pd <- methods::new("AnnotatedDataFrame", data = md_use)
  fd <- methods::new(
    "AnnotatedDataFrame",
    data = data.frame(gene_short_name = rownames(m), row.names = rownames(m), stringsAsFactors = FALSE)
  )

  cds <- tryCatch(
    monocle::newCellDataSet(m, phenoData = pd, featureData = fd, lowerDetectionLimit = min_expr, expressionFamily = VGAM::negbinomial.size()),
    error = function(e) monocle::newCellDataSet(m, phenoData = pd, featureData = fd, lowerDetectionLimit = min_expr, expressionFamily = VGAM::tobit())
  )

  cds <- tryCatch(BiocGenerics::estimateSizeFactors(cds), error = function(e) cds)
  cds <- tryCatch(BiocGenerics::estimateDispersions(cds), error = function(e) cds)
  cds <- tryCatch(monocle::detectGenes(cds, min_expr = min_expr), error = function(e) cds)

  ord_genes <- .monocle2_pick_ordering_genes(sobj, m, n_genes = ordering_genes)
  ord_genes <- intersect(ord_genes, rownames(cds))
  if (!length(ord_genes)) stop("No ordering genes available for Monocle2 trajectory.")

  cds <- monocle::setOrderingFilter(cds, ord_genes)
  cds <- monocle::reduceDimension(
    cds,
    max_components = max(2L, as.integer(max_components %||% 2L)),
    reduction_method = as.character(reduction_method %||% "DDRTree")
  )
  cds <- monocle::orderCells(cds)

  rs <- tryCatch(as.character(root_state), error = function(e) "")
  if (nzchar(rs)) {
    cds <- tryCatch(monocle::orderCells(cds, root_state = rs), error = function(e) cds)
  }
  if (isTRUE(reverse)) {
    cds <- tryCatch(monocle::orderCells(cds, reverse = TRUE), error = function(e) cds)
  }

  emb <- .monocle2_embeddings_from_cds(cds)
  pdat <- Biobase::pData(cds)

  pt <- as.numeric(pdat$Pseudotime %||% rep(NA_real_, nrow(pdat)))
  st <- as.character(pdat$State %||% rep("", nrow(pdat)))
  grp <- as.character(pdat[[group_col]] %||% rep("", nrow(pdat)))

  emb <- emb[match(rownames(pdat), emb$cell), , drop = FALSE]

  list(
    cds = cds,
    assay = assay_use,
    group_col = group_col,
    ordering_genes = ord_genes,
    emb = data.frame(cell = emb$cell, x = emb$x, y = emb$y, stringsAsFactors = FALSE),
    meta = data.frame(pdat, stringsAsFactors = FALSE),
    pseudotime = pt,
    state = st,
    group = grp,
    state_levels = sort(unique(st[nzchar(st)]))
  )
}

monocle2_beta_state_levels <- function(traj_dat) {
  lv <- as.character(traj_dat$state_levels %||% character(0))
  lv[nzchar(lv)]
}

monocle2_beta_run_beam <- function(
  traj_dat,
  branch_state_a = "",
  branch_state_b = "",
  branch_point = 1L,
  top_genes = 50L,
  num_clusters = 6L,
  cores = 1L
) {
  if (is.null(traj_dat$cds)) stop("Trajectory object is missing. Run Step 1 first.")
  if (!isTRUE(.monocle2_patch_igraph_compat_runtime(force = TRUE, run_smoke = TRUE))) {
    rep <- monocle2_beta_last_compat_report()
    msg <- paste(
      "Monocle2 igraph compatibility patch failed before BEAM run.",
      paste(as.character(rep$issues %||% "unknown"), collapse = " | ")
    )
    stop(msg)
  }
  cds <- traj_dat$cds

  states <- unique(as.character(Biobase::pData(cds)$State %||% character(0)))
  states <- states[nzchar(states)]

  sa <- as.character(branch_state_a %||% "")
  sb <- as.character(branch_state_b %||% "")
  use_states <- if (nzchar(sa) && nzchar(sb) && !identical(sa, sb) && all(c(sa, sb) %in% states)) c(sa, sb) else NULL

  cores <- max(1L, as.integer(cores %||% 1L))

  beam_res <- if (!is.null(use_states)) {
    monocle::BEAM(cds, branch_states = use_states, cores = cores)
  } else {
    monocle::BEAM(cds, branch_point = max(1L, as.integer(branch_point %||% 1L)), cores = cores)
  }

  beam_res <- BiocGenerics::as.data.frame(beam_res)
  beam_res$gene <- rownames(beam_res)
  if ("qval" %in% colnames(beam_res)) {
    beam_res <- beam_res[order(beam_res$qval, beam_res$pval), , drop = FALSE]
  } else if ("pval" %in% colnames(beam_res)) {
    beam_res <- beam_res[order(beam_res$pval), , drop = FALSE]
  }

  top_n <- max(10L, as.integer(top_genes %||% 50L))
  topg <- utils::head(as.character(beam_res$gene), top_n)
  topg <- intersect(topg, rownames(cds))
  if (!length(topg)) stop("No BEAM genes available for heatmap plotting.")

  cds_sub <- cds[topg, ]

  hm_obj <- if (!is.null(use_states)) {
    monocle::plot_genes_branched_heatmap(
      cds_sub,
      branch_states = use_states,
      num_clusters = max(2L, as.integer(num_clusters %||% 6L)),
      return_heatmap = TRUE,
      cores = cores
    )
  } else {
    monocle::plot_genes_branched_heatmap(
      cds_sub,
      branch_point = max(1L, as.integer(branch_point %||% 1L)),
      num_clusters = max(2L, as.integer(num_clusters %||% 6L)),
      return_heatmap = TRUE,
      cores = cores
    )
  }

  heat <- hm_obj$heatmap_matrix %||% hm_obj[[1]] %||% NULL
  if (is.null(heat)) {
    stop("Monocle2 did not return a BEAM heatmap matrix.")
  }
  heat <- as.matrix(heat)

  out <- beam_res
  if (!"qval" %in% colnames(out)) out$qval <- NA_real_
  if (!"pval" %in% colnames(out)) out$pval <- NA_real_
  out$qval_plot <- -log10(pmax(as.numeric(out$qval), 1e-300))
  out$effect_plot <- if ("status" %in% colnames(out)) as.numeric(as.factor(out$status)) else seq_len(nrow(out))
  out_branch_a <- if (!is.null(use_states) && length(use_states) >= 1L) as.character(use_states[[1]]) else ""
  out_branch_b <- if (!is.null(use_states) && length(use_states) >= 2L) as.character(use_states[[2]]) else ""

  list(
    heat = heat,
    divergence = out,
    branch_state_a = out_branch_a,
    branch_state_b = out_branch_b,
    branch_point = max(1L, as.integer(branch_point %||% 1L))
  )
}

# Backward-compatible alias retained for existing interface calls.
monocle2_beta_preview <- function(sobj, group_col, ordering_genes = 1000L, assay = NULL) {
  monocle2_beta_run_trajectory(
    sobj = sobj,
    group_col = group_col,
    assay = assay,
    ordering_genes = ordering_genes
  )
}
