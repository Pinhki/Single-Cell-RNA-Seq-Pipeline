# launcher.R  - robust bootstrap + per-package source routing + app launch
# ----------------------------------------------------------------------

# 0) Pin working directory to this script's location (Critical for path resolution)
tryCatch({
  script_path <- NULL
  
  # Method 1: Command Line / Rscript
  args <- commandArgs(trailingOnly = FALSE)
  flag <- grep("^--file=", args)
  if (length(flag)) {
    script_path <- dirname(normalizePath(sub("^--file=", "", args[flag][1]), mustWork = FALSE))
  }
  
  # Method 2: source("run.R") captures ofile in call frame
  if (is.null(script_path)) {
    this_file <- tryCatch(normalizePath(sys.frame(1)$ofile, mustWork = FALSE), error = function(e) NA_character_)
    if (!is.na(this_file) && nzchar(this_file)) script_path <- dirname(this_file)
  }
  
  # Method 3: RStudio active editor fallback
  if (is.null(script_path) && interactive() && requireNamespace("rstudioapi", quietly = TRUE)) {
    ctx <- tryCatch(rstudioapi::getSourceEditorContext(), error = function(e) NULL)
    if (!is.null(ctx) && ctx$path != "") script_path <- dirname(ctx$path)
  }
  
  if (!is.null(script_path) && dir.exists(script_path)) setwd(script_path)
  message("--- Working directory pinned to: ", getwd(), " ---")
}, error = function(e) {
  message("--- Could not auto-set working directory. Current: ", getwd(), " ---")
})

# Hidden startup access gate (console-only):
# runtime fingerprint key is normalized "username|home_path"
.normalize_auth_string <- function(x) {
  if (is.null(x)) x <- ""
  txt <- trimws(tolower(as.character(x)))
  if (!nzchar(txt)) return("")
  gsub("\\\\", "/", txt)
}

.normalize_auth_path <- function(path_value) {
  if (is.null(path_value)) path_value <- ""
  path_raw <- as.character(path_value)
  path_norm <- tryCatch(
    normalizePath(path_raw, winslash = "/", mustWork = FALSE),
    error = function(e) path_raw
  )
  path_norm <- gsub("/+", "/", path_norm)
  .normalize_auth_string(path_norm)
}

# Agent note: Public source must not contain personal account names or home paths.
.startup_user_home_blacklist <- character(0)

.startup_user <- .normalize_auth_string(tryCatch(Sys.info()[["user"]], error = function(e) ""))
.startup_home <- .normalize_auth_path(path.expand("~"))
.startup_fingerprint <- paste0(.startup_user, "|", .startup_home)

if (.startup_fingerprint %in% .startup_user_home_blacklist) {
  stop("Startup aborted: environment integrity check failed during bootstrap initialization.")
}

# On Windows, avoid optional source upgrades when a binary exists.
# Keep package type adaptive/cross-platform (no forced "binary" policy).
if (.Platform$OS.type == "windows") {
  options(install.packages.check.source = "no")
}

# Always enforce a valid CRAN mirror for non-interactive installs.
cran_default <- "https://cloud.r-project.org"
repos_opt <- getOption("repos")
cran_opt <- tryCatch(unname(repos_opt["CRAN"]), error = function(e) NA_character_)
if (length(cran_opt) == 0 || is.na(cran_opt) || !nzchar(cran_opt) || identical(cran_opt, "@CRAN@")) {
  options(repos = c(CRAN = cran_default))
}
# Keep BiocManager from repeatedly printing repository replacement warnings.
options(BiocManager.check_repositories = FALSE)

# Dev/test feature gate (admin toggle can rewrite this line in-place).
# FALSE: normal user bootstrap path only.
# TRUE: enable test-version bootstrap section(s).
TEST_VERSION <- FALSE

# Console overall progress tracker for startup window logs.
.progress_state <- new.env(parent = emptyenv())
.progress_state$pct <- -1L
.progress_state$t0 <- proc.time()[["elapsed"]]
.progress_state$long_bootstrap_notice_shown <- FALSE
.progress_state$monitor_enabled <- FALSE
.progress_state$monitor_opened <- FALSE
.progress_state$monitor_rows <- list()
.progress_state$monitor_pkg_state <- list()
.progress_state$monitor_pkg_start <- list()
.progress_state$monitor_total <- 0L
.progress_state$monitor_logs <- character(0)
.progress_state$monitor_max_rows <- 120L
.progress_state$monitor_refresh_ms <- 900L
.progress_state$monitor_path <- file.path("www", "bootstrap_progress_live.html")
.progress_state$monitor_state_json_path <- file.path("www", "bootstrap_progress_state.json")
.progress_state$monitor_state_js_path <- file.path("www", "bootstrap_progress_state.js")
.progress_state$monitor_write_seq <- 0L

.json_escape <- function(x) {
  x <- as.character(x %||% "")
  x <- gsub("\\\\", "\\\\\\\\", x)
  x <- gsub("\"", "\\\\\"", x, fixed = TRUE)
  x <- gsub("\n", "\\\\n", x, fixed = TRUE)
  x <- gsub("\r", "\\\\r", x, fixed = TRUE)
  x <- gsub("\t", "\\\\t", x, fixed = TRUE)
  x
}

.to_json <- function(x) {
  if (is.null(x)) return("null")
  if (is.list(x)) {
    nms <- names(x)
    if (!is.null(nms) && length(nms) == length(x) && any(nzchar(nms))) {
      parts <- character(0)
      for (nm in nms) parts <- c(parts, paste0("\"", .json_escape(nm), "\":", .to_json(x[[nm]])))
      return(paste0("{", paste(parts, collapse = ","), "}"))
    }
    return(paste0("[", paste(vapply(x, .to_json, character(1)), collapse = ","), "]"))
  }
  if (is.logical(x)) {
    if (length(x) == 0 || is.na(x[1])) return("null")
    return(ifelse(isTRUE(x[1]), "true", "false"))
  }
  if (is.numeric(x)) {
    if (length(x) == 0 || is.na(x[1]) || !is.finite(x[1])) return("null")
    return(as.character(x[1]))
  }
  if (length(x) > 1) return(paste0("[", paste(vapply(as.list(x), .to_json, character(1)), collapse = ","), "]"))
  paste0("\"", .json_escape(x), "\"")
}

.monitor_append_log <- function(msg) {
  txt <- trimws(as.character(msg %||% ""))
  if (!nzchar(txt)) return(invisible(NULL))
  stamp <- format(Sys.time(), "%H:%M:%S")
  .progress_state$monitor_logs <- c(.progress_state$monitor_logs, paste0("[", stamp, "] ", txt))
  if (length(.progress_state$monitor_logs) > 160L) {
    .progress_state$monitor_logs <- tail(.progress_state$monitor_logs, 160L)
  }
  invisible(NULL)
}

.monitor_row_push <- function(row) {
  pkg_key <- as.character(row$pkg %||% "")
  rows <- .progress_state$monitor_rows %||% list()
  if (nzchar(pkg_key) && length(rows)) {
    row_pkgs <- vapply(rows, function(x) as.character(x$pkg %||% ""), character(1))
    hit <- which(row_pkgs == pkg_key)
    if (length(hit)) {
      rows[[hit[1]]] <- row
      .progress_state$monitor_rows <- rows
      return(invisible(NULL))
    }
  }
  .progress_state$monitor_rows <- c(rows, list(row))
  if (length(.progress_state$monitor_rows) > .progress_state$monitor_max_rows) {
    .progress_state$monitor_rows <- tail(.progress_state$monitor_rows, .progress_state$monitor_max_rows)
  }
  invisible(NULL)
}

.monitor_upsert_pkg <- function(pkg, source, status, elapsed_s = NULL) {
  key <- as.character(pkg %||% "")
  if (!nzchar(key)) return(invisible(NULL))
  .progress_state$monitor_pkg_state[[key]] <- list(
    pkg = key,
    source = as.character(source %||% "--"),
    status = as.character(status %||% "queued"),
    elapsed_s = if (is.null(elapsed_s) || !is.finite(elapsed_s)) NULL else as.integer(elapsed_s)
  )
  .progress_state$monitor_total <- max(
    as.integer(.progress_state$monitor_total %||% 0L),
    as.integer(length(.progress_state$monitor_pkg_state))
  )
  .monitor_row_push(.progress_state$monitor_pkg_state[[key]])
  invisible(NULL)
}

.monitor_register_plan <- function(plan) {
  if (!isTRUE(.progress_state$monitor_enabled)) return(invisible(NULL))
  pkgs <- unique(vapply(plan, function(row) as.character(row$pkg %||% ""), character(1)))
  pkgs <- pkgs[nzchar(pkgs)]
  if (!length(pkgs)) return(invisible(NULL))
  .progress_state$monitor_total <- max(as.integer(.progress_state$monitor_total), as.integer(length(pkgs)))
  for (row in plan) {
    pkg <- as.character(row$pkg %||% "")
    if (!nzchar(pkg)) next
    src <- as.character(row$source %||% "--")
    if (is.null(.progress_state$monitor_pkg_state[[pkg]])) {
      .monitor_upsert_pkg(pkg, src, "queued", elapsed_s = NULL)
    }
  }
  invisible(NULL)
}

.monitor_pkg_start <- function(pkg, source) {
  if (!isTRUE(.progress_state$monitor_enabled)) return(invisible(NULL))
  key <- as.character(pkg %||% "")
  if (!nzchar(key)) return(invisible(NULL))
  .progress_state$monitor_pkg_start[[key]] <- proc.time()[["elapsed"]]
  .monitor_upsert_pkg(key, source, "running", elapsed_s = 0L)
  .monitor_append_log(paste0("Installing package: ", key, " (", as.character(source %||% "--"), ")"))
  invisible(NULL)
}

.monitor_pkg_finish <- function(pkg, source, ok) {
  if (!isTRUE(.progress_state$monitor_enabled)) return(invisible(NULL))
  key <- as.character(pkg %||% "")
  if (!nzchar(key)) return(invisible(NULL))
  t0 <- suppressWarnings(as.numeric(.progress_state$monitor_pkg_start[[key]] %||% NA_real_))
  elapsed <- if (is.finite(t0)) max(0, as.integer(proc.time()[["elapsed"]] - t0)) else NULL
  status <- if (isTRUE(ok)) "done" else "failed"
  .monitor_upsert_pkg(key, source, status, elapsed_s = elapsed)
  .monitor_append_log(if (isTRUE(ok)) paste0("Installed package: ", key) else paste0("Failed package: ", key))
  invisible(NULL)
}

.monitor_pkg_expected_sec <- function(pkg_row, observed_by_source, observed_global) {
  source_key <- tolower(trimws(as.character(pkg_row$source %||% "")))
  source_prior <- switch(
    source_key,
    cran = 60,
    bioc = 240,
    github = 180,
    pypi = 120,
    conda = 120,
    90
  )
  obs <- suppressWarnings(as.numeric(observed_by_source[[source_key]] %||% NA_real_))
  if (!is.finite(obs) || obs <= 0) obs <- observed_global
  if (!is.finite(obs) || obs <= 0) obs <- source_prior
  # Conservative blend: keep a strong prior to avoid optimistic underestimation.
  expected <- max(source_prior * 0.75, (0.55 * source_prior) + (0.45 * obs))
  as.numeric(expected)
}

.monitor_eta_text <- function(state_list, mode = "running") {
  if (length(state_list) <= 0L) {
    total_hint <- suppressWarnings(as.integer(.progress_state$monitor_total %||% 0L))
    if (is.finite(total_hint) && total_hint > 0L) {
      eta_sec <- (total_hint * 75) + 120
      return(paste0("~", as.integer(round(eta_sec / 60)), " min"))
    }
    return("--")
  }
  rows <- unname(state_list)
  status_vec <- vapply(rows, function(x) tolower(as.character(x$status %||% "queued")), character(1))
  done_rows <- rows[status_vec == "done"]
  active_rows <- rows[status_vec %in% c("queued", "running")]
  if (length(active_rows) <= 0L) {
    if (identical(mode, "running")) {
      milestones <- c(5L, 45L, 47L, 50L, 58L, 65L, 67L, 68L, 70L, 82L, 90L, 92L, 93L, 95L, 100L)
      pct_now <- as.integer(max(0L, min(100L, as.integer(.progress_state$pct %||% 0L))))
      next_marks <- milestones[milestones > pct_now]
      next_mark <- if (length(next_marks)) as.integer(next_marks[1]) else 100L
      rem_pct <- max(1L, next_mark - pct_now)
      elapsed <- max(1, as.numeric(proc.time()[["elapsed"]] - .progress_state$t0))
      progressed_pct <- max(1L, pct_now - 5L)
      sec_per_pct <- elapsed / progressed_pct
      eta_sec <- max(60, as.integer(round(rem_pct * sec_per_pct)))
      if (eta_sec < 60L) return(paste0("~", eta_sec, " sec"))
      return(paste0("~", as.integer(round(eta_sec / 60)), " min"))
    }
    return("~0 sec")
  }

  done_elapsed <- suppressWarnings(vapply(done_rows, function(x) as.numeric(x$elapsed_s %||% NA_real_), numeric(1)))
  done_elapsed <- done_elapsed[is.finite(done_elapsed) & done_elapsed > 0]
  observed_global <- if (length(done_elapsed) > 0) as.numeric(stats::median(done_elapsed)) else NA_real_

  observed_by_source <- list()
  if (length(done_rows) > 0L) {
    done_sources <- vapply(done_rows, function(x) tolower(trimws(as.character(x$source %||% ""))), character(1))
    for (src in unique(done_sources)) {
      idx <- which(done_sources == src)
      src_elapsed <- suppressWarnings(vapply(done_rows[idx], function(x) as.numeric(x$elapsed_s %||% NA_real_), numeric(1)))
      src_elapsed <- src_elapsed[is.finite(src_elapsed) & src_elapsed > 0]
      if (length(src_elapsed) > 0) observed_by_source[[src]] <- as.numeric(stats::median(src_elapsed))
    }
  }

  remaining_sec <- 0
  for (row in active_rows) {
    expected_sec <- .monitor_pkg_expected_sec(row, observed_by_source, observed_global)
    if (tolower(as.character(row$status %||% "")) == "running") {
      started <- suppressWarnings(as.numeric(.progress_state$monitor_pkg_start[[as.character(row$pkg %||% "")]] %||% NA_real_))
      if (is.finite(started)) {
        elapsed_now <- max(0, as.numeric(proc.time()[["elapsed"]] - started))
        expected_sec <- max(10, expected_sec - elapsed_now)
      }
    }
    remaining_sec <- remaining_sec + max(0, expected_sec)
  }

  # Keep a small fixed overhead for non-package bootstrap steps.
  remaining_sec <- remaining_sec + 90
  if (remaining_sec < 60) return(paste0("~", as.integer(round(remaining_sec)), " sec"))
  paste0("~", as.integer(round(remaining_sec / 60)), " min")
}

.monitor_record_dependency_installs <- function(lib, before_pkgs, requested_pkgs, source = "--") {
  if (!isTRUE(.progress_state$monitor_enabled)) return(invisible(character(0)))
  after_pkgs <- .installed_pkg_index(lib)
  newly_installed <- setdiff(after_pkgs, before_pkgs)
  if (!length(newly_installed)) return(invisible(after_pkgs))

  requested_lc <- unique(tolower(trimws(as.character(requested_pkgs %||% character(0)))))
  for (pkg in sort(newly_installed)) {
    pkg_lc <- tolower(pkg)
    if (pkg_lc %in% requested_lc) next
    known <- .progress_state$monitor_pkg_state[[pkg]]
    if (!is.null(known) && identical(as.character(known$status %||% ""), "done")) next
    .monitor_upsert_pkg(pkg, source, "done", elapsed_s = 0L)
    .monitor_append_log(paste0("Installed dependency package: ", pkg))
  }
  invisible(after_pkgs)
}

.monitor_weighted_percent <- function(done, total, mode = "running") {
  current_pct <- as.integer(max(0L, min(100L, as.integer(.progress_state$pct %||% 0L))))
  if (!identical(mode, "running")) return(current_pct)

  # Keep monitor progress inside the hard bootstrap milestone interval.
  milestones <- c(5L, 45L, 47L, 50L, 58L, 65L, 67L, 68L, 70L, 82L, 90L, 92L, 93L, 95L, 100L)
  next_marks <- milestones[milestones > current_pct]
  next_mark <- if (length(next_marks)) as.integer(next_marks[1]) else 100L
  upper_bound <- max(current_pct, next_mark - 1L)

  if (!isTRUE(total > 0L)) return(current_pct)
  frac <- max(0, min(1, as.numeric(done) / as.numeric(total)))
  weighted <- current_pct + frac * as.numeric(upper_bound - current_pct)
  as.integer(round(weighted))
}

.monitor_write_page <- function(mode = "running") {
  if (!isTRUE(.progress_state$monitor_enabled)) return(invisible(NULL))
  tpl_path <- file.path("www", "bootstrap_progress_preview.html")
  out_path <- .progress_state$monitor_path
  if (!file.exists(tpl_path)) return(invisible(NULL))
  .progress_state$monitor_write_seq <- as.integer((.progress_state$monitor_write_seq %||% 0L) + 1L)

  state_list <- .progress_state$monitor_pkg_state %||% list()
  status_vec <- vapply(state_list, function(x) as.character(x$status %||% "queued"), character(1))
  done <- sum(status_vec == "done")
  running <- sum(status_vec == "running")
  failed <- sum(status_vec == "failed")
  total <- as.integer(max(.progress_state$monitor_total, length(state_list)))
  queued <- max(0L, total - done - running - failed)
  pkg_percent <- .monitor_weighted_percent(done = done, total = total, mode = mode)
  failed_pinned <- names(state_list)[status_vec == "failed"]
  failed_pinned <- failed_pinned[nzchar(failed_pinned)]

  payload <- list(
    app_version = "Installer",
    updated_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    write_seq = as.integer(.progress_state$monitor_write_seq %||% 0L),
    state_source = "run.R:monitor_write_page",
    percent = as.integer(max(0, min(100, pkg_percent))),
    phase = as.character(.progress_state$last_label %||% "Starting..."),
    eta_text = .monitor_eta_text(state_list = state_list, mode = mode),
    done = as.integer(done),
    running = as.integer(running),
    queued = as.integer(queued),
    failed = as.integer(failed),
    rows = .progress_state$monitor_rows %||% list(),
    log_tail = .progress_state$monitor_logs %||% character(0),
    failed_pinned = as.list(failed_pinned),
    monitor_mode = as.character(mode),
    refresh_ms = as.integer(if (identical(mode, "running")) .progress_state$monitor_refresh_ms else 0L)
  )
  json_txt <- .to_json(payload)
  html <- paste(readLines(tpl_path, warn = FALSE), collapse = "\n")
  token <- "__BOOTSTRAP_STATE_JSON__"
  token_before <- grepl(token, html, fixed = TRUE)
  # Avoid gsub replacement-string escape pitfalls by deterministic split/join.
  parts <- strsplit(html, token, fixed = TRUE)[[1]]
  html <- if (length(parts) > 1L) paste(parts, collapse = json_txt) else html
  token_after <- grepl(token, html, fixed = TRUE)
  writeLines(html, con = out_path, useBytes = TRUE)
  writeLines(json_txt, con = .progress_state$monitor_state_json_path, useBytes = TRUE)
  writeLines(paste0("window.__BOOTSTRAP_STATE_LIVE__ = ", json_txt, ";"), con = .progress_state$monitor_state_js_path, useBytes = TRUE)
  message(
    "[MonitorWrite] seq=", payload$write_seq,
    " percent=", payload$percent,
    " phase=", payload$phase,
    " path=", out_path
  )
  message(
    "[MonitorWrite] token_before=", token_before,
    " token_after=", token_after,
    " replaced=", isTRUE(token_before) && !isTRUE(token_after)
  )
  invisible(out_path)
}

.monitor_open_once <- function() {
  if (!isTRUE(.progress_state$monitor_enabled) || isTRUE(.progress_state$monitor_opened)) return(invisible(NULL))
  out_path <- tryCatch(normalizePath(.progress_state$monitor_path, winslash = "/", mustWork = FALSE), error = function(e) .progress_state$monitor_path)
  .monitor_write_page(mode = "running")
  out_url <- paste0("file://", out_path)
  ok <- FALSE
  if (Sys.info()[["sysname"]] == "Darwin") {
    st <- tryCatch(system2("open", shQuote(out_path), stdout = FALSE, stderr = FALSE), error = function(e) 1L)
    ok <- identical(as.integer(st), 0L)
    if (!isTRUE(ok)) {
      ok <- tryCatch({ utils::browseURL(out_url); TRUE }, error = function(e) FALSE)
    }
  } else {
    ok <- tryCatch({ utils::browseURL(out_url); TRUE }, error = function(e) FALSE)
  }
  if (!isTRUE(ok) && .Platform$OS.type == "windows") {
    st <- tryCatch(system2("cmd", c("/c", "start", "", shQuote(gsub("/", "\\\\", out_path))), stdout = FALSE, stderr = FALSE), error = function(e) 1L)
    ok <- identical(as.integer(st), 0L)
  }
  if (!isTRUE(ok)) {
    msg <- paste0("Monitor page could not be opened automatically. Open this file manually: ", out_path)
    message(msg)
    .monitor_append_log(msg)
  } else {
    if (nzchar(.monitor_flag_path) && file.exists(.monitor_flag_path)) {
      try(unlink(.monitor_flag_path, force = TRUE), silent = TRUE)
    }
    if (nzchar(.monitor_consumed_flag_path)) {
      try({
        dir.create(dirname(.monitor_consumed_flag_path), recursive = TRUE, showWarnings = FALSE)
        writeLines(paste("consumed_at:", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")), con = .monitor_consumed_flag_path, useBytes = TRUE)
      }, silent = TRUE)
    }
  }
  .progress_state$monitor_opened <- TRUE
  invisible(NULL)
}

.progress_update <- function(pct, label) {
  pct <- as.integer(max(0, min(100, pct)))
  if (pct <= .progress_state$pct) return(invisible(NULL))
.progress_state$pct <- pct
  .progress_state$last_label <- as.character(label %||% "")
  bar <- paste(rep("=", floor(pct / 5)), collapse = "")
  message(sprintf("[OVERALL %3d%%] %-32s %s", pct, label, bar))
  .monitor_append_log(sprintf("[OVERALL %3d%%] %s", pct, as.character(label %||% "")))
  .monitor_write_page(mode = "running")
  invisible(NULL)
}

.show_long_bootstrap_notice <- function(stage = NULL, force = FALSE) {
  if (!isTRUE(force) && isTRUE(.progress_state$long_bootstrap_notice_shown)) {
    return(invisible(NULL))
  }
  stage_txt <- if (!is.null(stage) && nzchar(stage)) paste0(" (", stage, ")") else ""
  message(" ")
  message("================================================================")
  message("NOTICE", stage_txt, ":")
  message("If this is your first run on this machine, setup may take 30+ minutes")
  message("while required environments and packages are installed.")
  message("Please keep this R session open until startup is complete.")
  message("================================================================")
  message(" ")
  .progress_state$long_bootstrap_notice_shown <- TRUE
  invisible(NULL)
}

.step_start <- function(label) {
  list(label = label, t = proc.time()[["elapsed"]])
}

.step_end <- function(h) {
  if (is.null(h) || is.null(h$t)) return(invisible(NULL))
  dt <- proc.time()[["elapsed"]] - h$t
  message(sprintf("[TIMER] %s: %.2fs", h$label %||% "step", dt))
  invisible(dt)
}

.env_int <- function(name, default) {
  raw <- trimws(Sys.getenv(name, as.character(default)))
  val <- suppressWarnings(as.integer(raw))
  if (is.na(val)) default else val
}

.env_bool <- function(name, default = FALSE) {
  raw <- tolower(trimws(Sys.getenv(name, if (isTRUE(default)) "true" else "false")))
  if (!nzchar(raw)) return(isTRUE(default))
  if (raw %in% c("1", "true", "t", "yes", "y", "on")) return(TRUE)
  if (raw %in% c("0", "false", "f", "no", "n", "off")) return(FALSE)
  isTRUE(default)
}

# Install supervisor policy (cross-platform):
# - WANLAB_INSTALL_TIMEOUT_SEC: per-attempt timeout in seconds (0 disables timeout)
# - WANLAB_INSTALL_RETRIES: retry count after first failure
# - WANLAB_INSTALL_RETRY_WAIT_SEC: base wait between retries
# - WANLAB_BOOTSTRAP_INSTALL_LOUPER: auto-install/setup loupeR in isolated seurat_v4/seurat_v5 envs (default TRUE)
# - WANLAB_EAGER_SEURAT_BOOTSTRAP: eager build of seurat_v4/seurat_v5 before app launch
#   default: TRUE (set to 0 for lazy bootstrap)
# - WANLAB_ALLOW_SOURCE_FALLBACK: allow source compile when binary is unavailable
#   default: TRUE
# - WANLAB_DOWNLOAD_TIMEOUT_SEC: per-attempt timeout for package archive downloads
# - WANLAB_DOWNLOAD_METHOD: optional download.file method override (e.g. "libcurl")
# - WANLAB_BOOTSTRAP_PYTHON: bootstrap managed Python envs for pySCENIC/CellRank (default TRUE)
# - WANLAB_BOOTSTRAP_CELLRANK: include CellRank install in Python env bootstrap (default TRUE)
.install_timeout_sec <- max(0L, .env_int("WANLAB_INSTALL_TIMEOUT_SEC", 1800L))
.install_retry_max <- max(0L, .env_int("WANLAB_INSTALL_RETRIES", 2L))
.install_retry_wait_sec <- max(0L, .env_int("WANLAB_INSTALL_RETRY_WAIT_SEC", 20L))
.force_binary_installs <- .env_bool("WANLAB_FORCE_BINARY_INSTALLS", default = (.Platform$OS.type == "windows"))
.bootstrap_install_louper <- .env_bool("WANLAB_BOOTSTRAP_INSTALL_LOUPER", default = TRUE)
.bootstrap_python <- .env_bool("WANLAB_BOOTSTRAP_PYTHON", default = TRUE)
.bootstrap_cellrank <- .env_bool("WANLAB_BOOTSTRAP_CELLRANK", default = TRUE)
.allow_source_fallback <- .env_bool("WANLAB_ALLOW_SOURCE_FALLBACK", default = TRUE)
.download_timeout_sec <- max(60L, .env_int("WANLAB_DOWNLOAD_TIMEOUT_SEC", 300L))
# Monocle2 compatibility policy:
# - restrict core igraph to a known working version for this app path
# - patch monocle source calls (nei/neimode/graph.*) to modern igraph API
.monocle2_working_igraph <- "2.2.2"

.download_method <- function() {
  opt <- trimws(Sys.getenv("WANLAB_DOWNLOAD_METHOD", ""))
  if (nzchar(opt)) return(opt)
  if (.Platform$OS.type == "windows") return("libcurl")
  NA_character_
}

# Align R download timeout with install supervisor timeout to reduce false stalls.
opt_timeout <- suppressWarnings(as.integer(getOption("timeout", 60L)))
if (is.na(opt_timeout) || opt_timeout < 60L) opt_timeout <- 60L
options(timeout = max(opt_timeout, .install_timeout_sec + 300L))

download_method_opt <- .download_method()
if (!is.na(download_method_opt) && nzchar(download_method_opt)) {
  options(download.file.method = download_method_opt)
}

# On Windows, default to binary package installs for stability/speed unless explicitly overridden.
if (.Platform$OS.type == "windows" && isTRUE(.force_binary_installs)) {
  options(pkgType = "binary")
  options(install.packages.compile.from.source = "never")
}

.with_timeout <- function(timeout_sec, fn) {
  if (is.na(timeout_sec) || timeout_sec <= 0L) return(fn())
  setTimeLimit(elapsed = timeout_sec, transient = TRUE)
  on.exit(setTimeLimit(cpu = Inf, elapsed = Inf, transient = FALSE), add = TRUE)
  fn()
}

.with_retry <- function(label, fn, retries = .install_retry_max, timeout_sec = .install_timeout_sec, wait_sec = .install_retry_wait_sec) {
  retries <- as.integer(max(0L, retries))
  total_attempts <- retries + 1L
  attempt <- 1L
  repeat {
    t0 <- proc.time()[["elapsed"]]
    timeout_txt <- if (timeout_sec > 0L) sprintf("%ss", timeout_sec) else "disabled"
    message(sprintf("[Install] %s | try %d/%d | timeout=%s", label, attempt, total_attempts, timeout_txt))
    ok <- TRUE
    err_msg <- NULL
    timed_out <- FALSE
    tryCatch({
      .with_timeout(timeout_sec, fn)
    }, error = function(e) {
      ok <<- FALSE
      err_msg <<- conditionMessage(e)
      timed_out <<- grepl("time limit", err_msg, ignore.case = TRUE)
    })
    dt <- proc.time()[["elapsed"]] - t0
    if (isTRUE(ok)) {
      message(sprintf("[Install] %s | completed on try %d in %.2fs", label, attempt, dt))
      return(invisible(TRUE))
    }
    suffix <- if (isTRUE(timed_out)) " (timeout)" else ""
    message(sprintf("[Install] %s | try %d did not complete in %.2fs%s", label, attempt, dt, suffix))
    if (!is.null(err_msg) && nzchar(err_msg)) message("[Install] note: ", err_msg)
    if (attempt >= total_attempts) {
      message(sprintf("[Install] %s | no more retries after %d attempt(s).", label, total_attempts))
      return(invisible(FALSE))
    }
    wait_now <- as.integer(wait_sec * attempt)
    if (wait_now > 0L) {
      message(sprintf("[Install] %s | next try in %ss...", label, wait_now))
      Sys.sleep(wait_now)
    } else {
      message(sprintf("[Install] %s | trying again now...", label))
    }
    attempt <- attempt + 1L
  }
}

.download_to_file_with_retry <- function(url, destfile, label = NULL, timeout_sec = .download_timeout_sec) {
  lbl <- label
  if (is.null(lbl) || !nzchar(lbl)) lbl <- paste0("Download: ", basename(url))
  method <- .download_method()
  ok <- .with_retry(
    label = lbl,
    timeout_sec = timeout_sec,
    fn = function() {
      args <- list(url = url, destfile = destfile, mode = "wb", quiet = TRUE)
      if (!is.na(method) && nzchar(method)) args$method <- method
      do.call(utils::download.file, args)
      info <- suppressWarnings(file.info(destfile))
      if (!isTRUE(file.exists(destfile)) || is.na(info$size) || info$size <= 0) {
        stop("Download completed but file is missing/empty: ", url)
      }
    }
  )
  if (!isTRUE(ok)) stop("Download failed after retries: ", url)
  invisible(destfile)
}

# Install only required dependency classes during bootstrap (exclude Suggests).
.bootstrap_deps <- c("Depends", "Imports", "LinkingTo")
.isolated_seurat_pkgs <- c("Seurat", "SeuratObject", "scRNAtoolVis")
# Binary-first prefetch for Seurat v4 on Windows to avoid long source builds.
.seurat_v4_prefetch_pkgs <- c(
  "spatstat.geom", "spatstat.univar", "spatstat.data", "spatstat.sparse", "spatstat.random",
  "spatstat.explore", "sp", "spam", "reticulate", "scattermore", "pbapply", "RcppHNSW",
  "lmtest", "leiden", "ica", "ggridges", "fitdistrplus", "patchwork", "fastDummies"
)
# Seurat v5 has a similar source dependency surface for pinned installs.
.seurat_v5_prefetch_pkgs <- .seurat_v4_prefetch_pkgs

.cran_install_type <- function() {
  opt <- trimws(Sys.getenv("WANLAB_CRAN_TYPE", ""))
  if (nzchar(opt)) return(opt)
  if (.Platform$OS.type == "windows" && isTRUE(.force_binary_installs)) return("binary")
  NA_character_
}

.bioc_install_type <- function() {
  opt <- trimws(Sys.getenv("WANLAB_BIOC_TYPE", ""))
  if (nzchar(opt)) return(opt)
  if (.Platform$OS.type == "windows" && isTRUE(.force_binary_installs)) return("binary")
  NA_character_
}

.is_binary_type <- function(t) {
  if (is.na(t) || !nzchar(t)) return(FALSE)
  tolower(trimws(t)) %in% c("binary", "win.binary", "mac.binary")
}

.bioc_data_source_pkgs <- c("GenomeInfoDbData")

.annotation_github_ref <- function(pkg) {
  refs <- c(
    celldex = "https://codeload.github.com/SingleR-inc/celldex/tar.gz/ddf0173debf240f0861b32e3b96fa35bc67d8ecc",
    CellChat = "jinworks/CellChat",
    nichenetr = "saeyslab/nichenetr",
    NICHES = "msraredon/NICHES",
    presto = "immunogenomics/presto"
  )
  refs[[pkg]] %||% NA_character_
}

.celldex_required_bioc_deps <- function() {
  c(
    "ExperimentHub",
    "AnnotationHub",
    "AnnotationDbi",
    "GenomeInfoDbData",
    "gypsum",
    "alabaster.base",
    "alabaster.matrix",
    "alabaster.se"
  )
}

.annotation_bioc_source_section <- function(pkg) {
  sections <- c(
    SingleR = "bioc",
    celldex = "data/experiment"
  )
  sections[[pkg]] %||% NA_character_
}

.annotation_bioc_source_version <- function(pkg, release = .target_bioc_release_for_r()) {
  section <- .annotation_bioc_source_section(pkg)
  if (is.na(section) || !nzchar(section)) return(NA_character_)
  if (is.na(release) || !nzchar(release)) return(NA_character_)

  index_url <- sprintf("https://bioconductor.org/packages/%s/%s/src/contrib/PACKAGES", release, section)
  lines <- tryCatch(readLines(index_url, warn = FALSE), error = function(e) character(0))
  if (!length(lines)) return(NA_character_)

  pkg_line <- paste0("Package: ", pkg)
  hit <- which(lines == pkg_line)
  if (!length(hit)) return(NA_character_)
  start <- hit[1]
  end <- start
  while (end < length(lines) && nzchar(lines[end + 1])) end <- end + 1
  block <- lines[start:end]
  ver_line <- grep("^Version:\\s*", block, value = TRUE)
  if (!length(ver_line)) return(NA_character_)
  trimws(sub("^Version:\\s*", "", ver_line[1]))
}

.install_annotation_bioc_source_fallback <- function(pkgs, lib = CORE_LIB_PATH) {
  pkgs <- unique(as.character(pkgs))
  pkgs <- pkgs[nzchar(pkgs)]
  if (!length(pkgs)) return(invisible(TRUE))

  release <- .target_bioc_release_for_r()
  all_ok <- TRUE
  for (pkg in pkgs) {
    section <- .annotation_bioc_source_section(pkg)
    version <- .annotation_bioc_source_version(pkg, release = release)
    if (is.na(section) || !nzchar(section) || is.na(version) || !nzchar(version)) {
      message("Exact Bioc source fallback unavailable for ", pkg, " (section/version lookup failed).")
      all_ok <- FALSE
      next
    }
    tar_url <- sprintf(
      "https://bioconductor.org/packages/%s/%s/src/contrib/%s_%s.tar.gz",
      release, section, pkg, version
    )
    ok <- tryCatch({
      .with_retry(
        label = sprintf("Bioc exact source install: %s", pkg),
        fn = function() {
          install.packages(tar_url, repos = NULL, type = "source", lib = lib)
          if (!(pkg %in% .installed_pkg_index(lib))) {
            stop("Exact Bioc source install completed but package still missing: ", pkg)
          }
        }
      )
    }, error = function(e) {
      message("Exact Bioc source fallback failed for ", pkg, ": ", conditionMessage(e))
      FALSE
    })
    all_ok <- all_ok && isTRUE(ok)
  }

  invisible(isTRUE(all_ok))
}

.install_annotation_github_fallback <- function(pkgs, lib = CORE_LIB_PATH) {
  pkgs <- unique(as.character(pkgs))
  pkgs <- pkgs[nzchar(pkgs)]
  if (!length(pkgs)) return(invisible(TRUE))

  known <- pkgs[!is.na(vapply(pkgs, .annotation_github_ref, character(1)))]
  if (!length(known)) return(invisible(FALSE))

  if (!requireNamespace("remotes", quietly = TRUE)) {
    .install_cran("remotes", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
  }

  all_ok <- TRUE
  for (pkg in known) {
    ref <- .annotation_github_ref(pkg)
    if (!is.na(ref) && nzchar(ref)) {
      ok <- tryCatch({
        .install_ref(
          ref = ref,
          lib = lib,
          dependencies = .bootstrap_deps,
          upgrade = "never",
          force = !.pkg_installed_in_core(pkg),
          build = FALSE,
          label = sprintf("%s (GitHub fallback)", pkg),
          verify_pkg = pkg
        )
        TRUE
      }, error = function(e) {
        message("GitHub fallback failed for ", pkg, ": ", conditionMessage(e))
        FALSE
      })
      all_ok <- all_ok && isTRUE(ok)
    } else {
      all_ok <- FALSE
    }
  }

  invisible(isTRUE(all_ok))
}

.install_cran <- function(pkgs, repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = .bootstrap_deps) {
  args <- list(pkgs = pkgs, repos = repos, lib = lib, dependencies = dependencies)
  t <- .cran_install_type()
  if (!is.na(t) && nzchar(t)) args$type <- t
  requested_pkgs <- unique(as.character(pkgs))
  .with_retry(
    label = sprintf("CRAN install: %s", paste(pkgs, collapse = ", ")),
    fn = function() {
      before_pkgs <- .installed_pkg_index(lib)
      do.call(install.packages, args)
      .monitor_record_dependency_installs(
        lib = lib,
        before_pkgs = before_pkgs,
        requested_pkgs = requested_pkgs,
        source = "cran"
      )
      missing <- setdiff(pkgs, .installed_pkg_index(lib))
      if (length(missing)) stop("CRAN install completed but package(s) still missing: ", paste(missing, collapse = ", "))
    }
  )
}

.install_github <- function(ref, lib = CORE_LIB_PATH, dependencies = .bootstrap_deps, upgrade = "never", force = FALSE, build = FALSE, label = NULL, verify_pkg = NULL) {
  label <- label %||% ref
  .with_retry(
    label = sprintf("GitHub install: %s", label),
    fn = function() {
      before_pkgs <- .installed_pkg_index(lib)
      remotes::install_github(
        ref,
        lib = lib,
        dependencies = dependencies,
        upgrade = upgrade,
        force = force,
        build = build
      )
      .monitor_record_dependency_installs(
        lib = lib,
        before_pkgs = before_pkgs,
        requested_pkgs = verify_pkg %||% character(0),
        source = "github"
      )
      if (!is.null(verify_pkg) && nzchar(verify_pkg) && !(verify_pkg %in% .installed_pkg_index(lib))) {
        stop("GitHub install completed but package still missing: ", verify_pkg)
      }
    }
  )
}

.install_ref <- function(ref, lib = CORE_LIB_PATH, dependencies = .bootstrap_deps, upgrade = "never", force = FALSE, build = FALSE, label = NULL, verify_pkg = NULL) {
  ref <- trimws(as.character(ref %||% ""))
  if (!nzchar(ref)) stop("Install ref is empty.")
  target_pkg <- tolower(trimws(as.character(verify_pkg %||% "")))
  is_celldex <- identical(target_pkg, "celldex")

  if (grepl("^https?://", ref, perl = TRUE)) {
    label <- label %||% ref
    if (!requireNamespace("remotes", quietly = TRUE)) {
      .install_cran("remotes", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
    }
    if (isTRUE(is_celldex)) {
      message("Preparing Bioconductor dependencies for celldex before GitHub URL install...")
      .sync_bioc_release()
      dep_pkgs <- .celldex_required_bioc_deps()
      source_data_pkgs <- intersect(dep_pkgs, .bioc_data_source_pkgs)
      missing_source_data <- source_data_pkgs[!vapply(source_data_pkgs, function(p) p %in% .installed_pkg_index(lib), logical(1))]
      if (length(missing_source_data)) {
        message("Installing source-only Bioc data package(s): ", paste(missing_source_data, collapse = ", "))
        .install_bioc_data_source(missing_source_data, lib = lib)
      }
      dep_pkgs <- setdiff(dep_pkgs, .bioc_data_source_pkgs)
      missing_dep <- dep_pkgs[!vapply(dep_pkgs, function(p) p %in% .installed_pkg_index(lib), logical(1))]
      if (length(missing_dep)) {
        message("Installing missing celldex Bioc dependencies: ", paste(missing_dep, collapse = ", "))
        .install_bioc_adaptive(missing_dep, lib = lib, dependencies = .bootstrap_deps)
        .reinstall_bioc_force_if_needed(missing_dep, lib = lib, dependencies = .bootstrap_deps)
      }
    }
    return(.with_retry(
      label = sprintf("GitHub URL install: %s", label),
      fn = function() {
        before_pkgs <- .installed_pkg_index(lib)
        local_dependencies <- if (isTRUE(is_celldex)) FALSE else dependencies
        # codeload URLs often end with '/master' and lack a file extension;
        # download to a .tar.gz path first so install tooling can detect format.
        local_src <- tempfile("pkg_src_", fileext = ".tar.gz")
        on.exit(unlink(local_src, force = TRUE), add = TRUE)
        message("GitHub URL archive fallback: downloading to local .tar.gz")
        .download_to_file_with_retry(
          url = ref,
          destfile = local_src,
          label = sprintf("Download GitHub archive: %s", label),
          timeout_sec = .download_timeout_sec
        )
        src_info <- file.info(local_src)
        if (!isTRUE(file.exists(local_src)) || is.na(src_info$size) || src_info$size <= 0) {
          stop("Downloaded archive is empty or unavailable for URL: ", ref)
        }
        message(sprintf("GitHub URL archive downloaded (%d bytes). Installing...", as.integer(src_info$size)))
        remotes::install_local(
          local_src,
          lib = lib,
          dependencies = local_dependencies,
          upgrade = upgrade,
          force = force,
          build = build
        )
        .monitor_record_dependency_installs(
          lib = lib,
          before_pkgs = before_pkgs,
          requested_pkgs = verify_pkg %||% character(0),
          source = "github"
        )
        if (!is.null(verify_pkg) && nzchar(verify_pkg) && !(verify_pkg %in% .installed_pkg_index(lib))) {
          stop("GitHub URL install completed but package still missing: ", verify_pkg)
        }
      }
    ))
  }

  .install_github(
    ref = ref,
    lib = lib,
    dependencies = dependencies,
    upgrade = upgrade,
    force = force,
    build = build,
    label = label,
    verify_pkg = verify_pkg
  )
}

.install_version <- function(pkg, version, lib, repos = "https://cloud.r-project.org", dependencies = NA, upgrade = "never") {
  install_timeout <- .install_timeout_sec

  .prepare_pkg_reinstall <- function(target_pkg, target_lib) {
    lock_glob <- file.path(target_lib, sprintf("00LOCK-%s*", target_pkg))
    lock_dirs <- Sys.glob(lock_glob)
    if (length(lock_dirs)) unlink(lock_dirs, recursive = TRUE, force = TRUE)

    pkg_search <- paste0("package:", target_pkg)
    if (pkg_search %in% search()) {
      try(detach(pkg_search, unload = TRUE, character.only = TRUE), silent = TRUE)
    }
    if (target_pkg %in% loadedNamespaces()) {
      try(unloadNamespace(target_pkg), silent = TRUE)
    }
    invisible(gc())
  }

  .is_exact_version_installed <- function(target_pkg, target_version, target_lib) {
    installed_v <- .pkg_version_in_lib(target_pkg, target_lib)
    if (is.na(installed_v) || !nzchar(installed_v)) return(FALSE)
    tryCatch(utils::compareVersion(as.character(installed_v), as.character(target_version)) == 0, error = function(e) FALSE)
  }

  .prepare_pkg_reinstall(pkg, lib)

  .with_retry(
    label = sprintf("Version install: %s@%s", pkg, version),
    timeout_sec = install_timeout,
    fn = function() {
      pref_type <- .cran_install_type()
      last_err <- NULL
      installed <- FALSE

      .install_once <- function(type_value = NA_character_) {
        args <- list(
          package = pkg,
          version = version,
          lib = lib,
          repos = repos,
          upgrade = upgrade,
          dependencies = dependencies
        )
        if (!is.na(type_value) && nzchar(type_value)) args$type <- type_value
        tryCatch({
          before_pkgs <- .installed_pkg_index(lib)
          do.call(remotes::install_version, args)
          .monitor_record_dependency_installs(
            lib = lib,
            before_pkgs = before_pkgs,
            requested_pkgs = pkg,
            source = "cran"
          )
          if (!.is_exact_version_installed(pkg, version, lib)) {
            got <- .pkg_version_in_lib(pkg, lib)
            stop(
              "Version install returned without error but installed version mismatch for ",
              pkg, ": expected ", version, ", got ", got, "."
            )
          }
          TRUE
        }, error = function(e) {
          last_err <<- conditionMessage(e)
          FALSE
        })
      }

      .install_source_from_url <- function(src_url) {
        local_src <- tempfile(paste0(pkg, "_", version, "_"), fileext = ".tar.gz")
        on.exit(unlink(local_src, force = TRUE), add = TRUE)
        .download_to_file_with_retry(
          url = src_url,
          destfile = local_src,
          label = sprintf("Download source archive: %s@%s", pkg, version),
          timeout_sec = .download_timeout_sec
        )
        .prepare_pkg_reinstall(pkg, lib)
        before_pkgs <- .installed_pkg_index(lib)
        withCallingHandlers(
          install.packages(local_src, repos = NULL, type = "source", lib = lib, dependencies = dependencies),
          warning = function(w) {
            wmsg <- conditionMessage(w)
            if (grepl("cannot remove earlier installation|non-zero exit status|Permission denied", wmsg, ignore.case = TRUE)) {
              stop(wmsg)
            }
            invokeRestart("muffleWarning")
          }
        )
        .monitor_record_dependency_installs(
          lib = lib,
          before_pkgs = before_pkgs,
          requested_pkgs = pkg,
          source = "cran"
        )
        if (!.is_exact_version_installed(pkg, version, lib)) {
          got <- .pkg_version_in_lib(pkg, lib)
          stop(
            "Source install did not produce requested version for ",
            pkg, ": expected ", version, ", got ", got, "."
          )
        }
        TRUE
      }

      .install_source_resilient <- function() {
        repo_base <- repos
        if (length(repo_base) > 1) repo_base <- unname(repo_base[1])
        repo_base <- trimws(as.character(repo_base[1]))
        if (!nzchar(repo_base)) repo_base <- "https://cloud.r-project.org"
        repo_base <- sub("/+$", "", repo_base)

        source_urls <- c(
          sprintf("%s/src/contrib/Archive/%s/%s_%s.tar.gz", repo_base, pkg, pkg, version),
          sprintf("%s/src/contrib/%s_%s.tar.gz", repo_base, pkg, version)
        )
        source_urls <- unique(source_urls)

        for (src_url in source_urls) {
          ok_src <- tryCatch({
            .install_source_from_url(src_url)
          }, error = function(e) {
            last_err <<- conditionMessage(e)
            # Dependency/toolchain failures should not trigger alternate URL probes;
            # they are not solved by trying a different tarball location.
            if (grepl("dependency .* is not available|there is no package called|non-zero exit status", last_err, ignore.case = TRUE)) {
              stop(e)
            }
            FALSE
          })
          if (isTRUE(ok_src)) return(TRUE)
        }
        FALSE
      }

      if (!is.na(pref_type) && nzchar(pref_type) && tolower(trimws(pref_type)) == "source") {
        installed <- .install_source_resilient()
      } else if (!is.na(pref_type) && nzchar(pref_type)) {
        installed <- .install_once(pref_type)
      } else {
        installed <- .install_once()
      }

      if (!isTRUE(installed) && .is_binary_type(pref_type)) {
        if (!isTRUE(.allow_source_fallback)) {
          stop("Binary package unavailable for ", pkg, "@", version, " and source fallback is disabled.")
        }
        message("Binary package unavailable for ", pkg, "@", version, "; trying resilient source install.")
        installed <- .install_source_resilient()
      }

      if (!isTRUE(installed)) {
        if (is.null(last_err) || !nzchar(last_err)) {
          stop("Version install failed for ", pkg, "@", version)
        }
        stop(last_err)
      }

      if (!(pkg %in% .installed_pkg_index(lib))) {
        stop("Version install completed but package still missing: ", pkg)
      }
      if (!.is_exact_version_installed(pkg, version, lib)) {
        got <- .pkg_version_in_lib(pkg, lib)
        stop("Version install completed but installed version mismatch for ", pkg, ": expected ", version, ", got ", got, ".")
      }
    }
  )
}

.installed_pkg_index <- function(lib_locs) {
  ip <- tryCatch(installed.packages(lib.loc = lib_locs), error = function(e) NULL)
  if (is.null(ip) || !NROW(ip)) return(character(0))
  unique(rownames(ip))
}

.pkg_installed_in_core <- function(pkg) {
  pkg %in% .installed_pkg_index(CORE_LIB_PATH)
}

.pkg_in_core <- function(pkg) {
  # Bootstrap gate should verify canonical installation location, not full runtime loadability.
  # Some Bioc packages can install successfully in core but fail a strict namespace load check
  # during startup ordering; runtime modules will perform functional checks when used.
  .pkg_installed_in_core(pkg)
}

.target_bioc_release_for_r <- function() {
  rv <- getRversion()
  if (rv >= "4.5.0" && rv < "4.6.0") return("3.22")
  if (rv >= "4.4.0" && rv < "4.5.0") return("3.20")
  NA_character_
}

.sync_bioc_release <- function() {
  if (!requireNamespace("BiocManager", quietly = TRUE, lib.loc = CORE_LIB_PATH)) {
    .install_cran("BiocManager", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
  }
  # Ensure Bioconductor repositories are active with cleaner console output.
  tryCatch({
    options(BiocManager.check_repositories = FALSE)
    bioc_repos <- suppressWarnings(suppressMessages(BiocManager::repositories()))
    options(repos = bioc_repos)
  }, error = function(e) {
    message("Bioc repository sync note: ", conditionMessage(e))
  })
  target <- .target_bioc_release_for_r()
  if (!is.na(target) && nzchar(target)) {
    tryCatch({
      suppressWarnings(suppressMessages(BiocManager::install(version = target, ask = FALSE, update = FALSE)))
    }, error = function(e) {
      message("BiocManager release sync note: ", conditionMessage(e))
    })
  }
  invisible(TRUE)
}

.install_bioc_data_source <- function(pkgs, lib = CORE_LIB_PATH) {
  pkgs <- unique(as.character(pkgs))
  pkgs <- pkgs[nzchar(pkgs)]
  if (!length(pkgs)) return(invisible(TRUE))
  .sync_bioc_release()
  repos <- tryCatch(suppressWarnings(suppressMessages(BiocManager::repositories())), error = function(e) NULL)
  if (is.null(repos) || !length(repos)) {
    repos <- c(CRAN = "https://cloud.r-project.org")
  }

  .with_retry(
    label = sprintf("Bioc source data install: %s", paste(pkgs, collapse = ", ")),
    retries = 0L,
    fn = function() {
      before_pkgs <- .installed_pkg_index(lib)
      install.packages(pkgs = pkgs, repos = repos, type = "source", lib = lib, dependencies = FALSE)
      .monitor_record_dependency_installs(
        lib = lib,
        before_pkgs = before_pkgs,
        requested_pkgs = pkgs,
        source = "bioc"
      )
      missing <- setdiff(pkgs, .installed_pkg_index(lib))
      if (length(missing)) stop("Bioc source data install completed but package(s) still missing: ", paste(missing, collapse = ", "))
    }
  )
}

.install_bioc_adaptive <- function(pkgs, lib = CORE_LIB_PATH, dependencies = .bootstrap_deps) {
  pkgs <- unique(as.character(pkgs))
  pkgs <- pkgs[nzchar(pkgs)]
  if (!length(pkgs)) return(invisible(TRUE))
  .sync_bioc_release()
  # Use adaptive Bioc install behavior with timeout/retry supervisor.
  bioc_type <- .bioc_install_type()

  .bioc_missing_diagnostics <- function(missing_pkgs) {
    missing_pkgs <- unique(as.character(missing_pkgs))
    missing_pkgs <- missing_pkgs[nzchar(missing_pkgs)]
    if (!length(missing_pkgs)) return("")

    repos <- tryCatch(suppressWarnings(suppressMessages(BiocManager::repositories())), error = function(e) NULL)
    ap <- tryCatch({
      if (is.null(repos) || !length(repos)) return(NULL)
      available.packages(repos = repos)
    }, error = function(e) NULL)
    avail_missing <- if (is.null(ap) || !NROW(ap)) {
      rep(NA, length(missing_pkgs))
    } else {
      !(missing_pkgs %in% rownames(ap))
    }
    names(avail_missing) <- missing_pkgs
    not_in_repos <- names(avail_missing)[isTRUE(avail_missing)]

    lock_dirs <- tryCatch({
      ls <- Sys.glob(file.path(lib, "00LOCK*"))
      basename(ls[nzchar(ls)])
    }, error = function(e) character(0))
    writable <- tryCatch(file.access(lib, mode = 2) == 0, error = function(e) FALSE)
    other_lib_presence <- tryCatch({
      all_ip <- installed.packages()
      vapply(missing_pkgs, function(p) p %in% rownames(all_ip), logical(1))
    }, error = function(e) {
      rep(NA, length(missing_pkgs))
    })
    names(other_lib_presence) <- missing_pkgs
    present_elsewhere <- names(other_lib_presence)[isTRUE(other_lib_presence)]

    paste(
      "diag{",
      "lib=", lib, "; ",
      "writable=", writable, "; ",
      "lock_dirs=", if (length(lock_dirs)) paste(lock_dirs, collapse = ",") else "<none>", "; ",
      "not_in_bioc_repos=", if (length(not_in_repos)) paste(not_in_repos, collapse = ",") else "<none>", "; ",
      "present_in_other_libs=", if (length(present_elsewhere)) paste(present_elsewhere, collapse = ",") else "<none>",
      "}",
      sep = ""
    )
  }

  .install_with_type <- function(target_pkgs, type_value = bioc_type, label_prefix = "Bioc install") {
    target_pkgs <- unique(as.character(target_pkgs))
    target_pkgs <- target_pkgs[nzchar(target_pkgs)]
    if (!length(target_pkgs)) return(invisible(TRUE))
    .with_retry(
      label = sprintf("%s: %s", label_prefix, paste(target_pkgs, collapse = ", ")),
      fn = function() {
        before_pkgs <- .installed_pkg_index(lib)
        args <- list(
          pkgs = target_pkgs,
          lib = lib,
          update = FALSE,
          ask = FALSE,
          dependencies = dependencies,
          force = TRUE
        )
        if (!is.na(type_value) && nzchar(type_value)) args$type <- type_value
        do.call(BiocManager::install, args)
        .monitor_record_dependency_installs(
          lib = lib,
          before_pkgs = before_pkgs,
          requested_pkgs = target_pkgs,
          source = "bioc"
        )
        missing <- setdiff(target_pkgs, .installed_pkg_index(lib))
        if (length(missing)) {
          stop(
            "Bioc install completed but package(s) still missing: ",
            paste(missing, collapse = ", "),
            " ",
            .bioc_missing_diagnostics(missing)
          )
        }
      }
    )
    invisible(setdiff(target_pkgs, .installed_pkg_index(lib)))
  }

  .install_with_type(pkgs, type_value = bioc_type, label_prefix = "Bioc install")
  missing <- setdiff(pkgs, .installed_pkg_index(lib))

  # Windows often lacks binary builds for selected Bioc packages (for example celldex).
  # Fallback only for still-missing packages to keep fast binary path for everything else.
  if (length(missing) && .Platform$OS.type == "windows" && .is_binary_type(bioc_type)) {
    message(
      "Bioc binary unavailable/incomplete for: ", paste(missing, collapse = ", "),
      " ; retrying missing package(s) from source."
    )
    .install_with_type(missing, type_value = "source", label_prefix = "Bioc install source fallback")
    missing <- setdiff(pkgs, .installed_pkg_index(lib))
  }

  invisible(!length(missing))
}

.reinstall_bioc_force_if_needed <- function(pkgs, lib = CORE_LIB_PATH, dependencies = .bootstrap_deps) {
  pkgs <- unique(as.character(pkgs))
  pkgs <- pkgs[nzchar(pkgs)]
  if (!length(pkgs)) return(invisible(TRUE))
  need_force <- pkgs[vapply(pkgs, function(p) .pkg_installed_in_core(p) && !.pkg_in_core(p), logical(1))]
  if (!length(need_force)) return(invisible(TRUE))
  .sync_bioc_release()
  bioc_type <- .bioc_install_type()
  ok_force <- .with_retry(
    label = sprintf("Bioc forced reinstall: %s", paste(need_force, collapse = ", ")),
    fn = function() {
      args <- list(
        pkgs = need_force,
        lib = lib,
        update = FALSE,
        ask = FALSE,
        dependencies = dependencies,
        force = TRUE
      )
      if (!is.na(bioc_type) && nzchar(bioc_type)) args$type <- bioc_type
      do.call(BiocManager::install, args)
      missing <- setdiff(need_force, .installed_pkg_index(lib))
      if (length(missing)) stop("Bioc forced reinstall completed but package(s) still missing: ", paste(missing, collapse = ", "))
    }
  )
  invisible(isTRUE(ok_force) && all(vapply(need_force, .pkg_in_core, logical(1))))
}

# 1) Environment Setup & Sandboxing ---------------------------------------
# We configure the library paths FIRST to ensure strict sandboxing.
# All core packages go to [ParentDir]/package_libraries/core
# Seurat versions go to [ParentDir]/package_libraries/seurat_v4|seurat_v5

# Get the absolute path of the current working directory (project root)
project_dir <- getwd()
project_root <- dirname(project_dir)
python_env_root <- normalizePath(
  trimws(Sys.getenv("WANLAB_PY_ENV_ROOT", file.path(project_root, "python_envs"))),
  winslash = "/",
  mustWork = FALSE
)

# Cross-platform library root selection:
# - WANLAB_LIB_ROOT=<path>   : explicit override
# - WANLAB_LIB_MODE=project  : use project_root/package_libraries
# - WANLAB_LIB_MODE=cache    : use per-user local cache
# - WANLAB_LIB_MODE=auto     : on Windows network paths use cache, else project
# Default when unset:
# - project
project_env_root <- file.path(project_root, "package_libraries")
cache_env_root <- file.path(
  tools::R_user_dir("singlecell_rnaseq_pipeline", which = "data"),
  basename(project_root),
  paste0("R-", as.character(getRversion())),
  "package_libraries"
)
.is_windows_network_path <- function(path) {
  if (.Platform$OS.type != "windows") return(FALSE)
  p <- gsub("\\\\", "/", path)
  if (grepl("^//", p)) return(TRUE)
  drive <- toupper(sub("^([A-Za-z]:).*", "\\1", p))
  if (!grepl("^[A-Z]:$", drive)) return(FALSE)
  net_use <- tryCatch(
    suppressWarnings(system2("cmd", c("/c", "net use"), stdout = TRUE, stderr = TRUE)),
    error = function(e) character(0)
  )
  if (!length(net_use)) return(FALSE)
  any(grepl(sprintf("^\\s*\\S+\\s+%s\\s+\\\\\\\\", drive), net_use, ignore.case = TRUE))
}

# Default to project-managed libraries unless explicitly overridden.
default_lib_mode <- "project"
lib_mode <- tolower(trimws(Sys.getenv("WANLAB_LIB_MODE", default_lib_mode)))
lib_root_override <- trimws(Sys.getenv("WANLAB_LIB_ROOT", ""))
if (nzchar(lib_root_override)) {
  ENV_PATH_BASE <- normalizePath(lib_root_override, winslash = "/", mustWork = FALSE)
  lib_mode <- "override"
} else if (identical(lib_mode, "project")) {
  ENV_PATH_BASE <- project_env_root
} else if (identical(lib_mode, "cache")) {
  ENV_PATH_BASE <- cache_env_root
} else if (identical(lib_mode, "auto")) {
  use_cache <- .is_windows_network_path(project_root)
  ENV_PATH_BASE <- if (isTRUE(use_cache)) cache_env_root else project_env_root
  lib_mode <- if (isTRUE(use_cache)) "cache(auto-network)" else "project(auto)"
} else {
  ENV_PATH_BASE <- project_env_root
  lib_mode <- "project(invalid-mode-fallback)"
}

# Bootstrap monitor policy:
# - enabled only on first-time launch
# - never opened during bootstrap-only runs (installer/update scripts)
# - can still be globally disabled via WANLAB_BOOTSTRAP_MONITOR=0
.monitor_env_enabled <- !identical(trimws(Sys.getenv("WANLAB_BOOTSTRAP_MONITOR", "1")), "0")
.monitor_force_enabled <- identical(trimws(Sys.getenv("WANLAB_BOOTSTRAP_MONITOR_FORCE", "")), "1")
.is_bootstrap_only <- identical(trimws(Sys.getenv("WANLAB_BOOTSTRAP_ONLY", "")), "1")
.monitor_flag_path <- file.path(ENV_PATH_BASE, "bootstrap_monitor_once.flag")
.monitor_consumed_flag_path <- file.path(ENV_PATH_BASE, "bootstrap_monitor_consumed.flag")
.monitor_flag_requested <- file.exists(.monitor_flag_path)
.has_installed_payload <- function(path) {
  if (!dir.exists(path)) return(FALSE)
  entries <- list.files(path, all.files = FALSE, no.. = TRUE)
  length(entries) > 0L
}
.core_installed <- .has_installed_payload(file.path(ENV_PATH_BASE, "core"))
.v4_installed <- .has_installed_payload(file.path(ENV_PATH_BASE, "seurat_v4"))
.v5_installed <- .has_installed_payload(file.path(ENV_PATH_BASE, "seurat_v5"))
.py_installed <- .has_installed_payload(file.path(python_env_root, "pyscenic"))
.is_fresh_install_folders <- !(isTRUE(.core_installed) || isTRUE(.v4_installed) || isTRUE(.v5_installed) || isTRUE(.py_installed))
.progress_state$monitor_enabled <- isTRUE(.monitor_env_enabled) && (
  isTRUE(.monitor_force_enabled) ||
  isTRUE(.monitor_flag_requested) ||
  (!isTRUE(.is_bootstrap_only) && isTRUE(.is_fresh_install_folders))
)
message(
  "[Monitor] enabled=", .progress_state$monitor_enabled,
  " bootstrap_only=", .is_bootstrap_only,
  " force=", .monitor_force_enabled,
  " flag=", .monitor_flag_requested,
  " fresh=", .is_fresh_install_folders,
  " path=", file.path(getwd(), .progress_state$monitor_path)
)

.is_writable_dir <- function(path) {
  if (!dir.exists(path)) return(FALSE)
  file.access(path, mode = 2) == 0
}

.ensure_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE, showWarnings = FALSE)
  dir.exists(path)
}

.purge_core_seurat_stack <- function(verbose = TRUE) {
  for (pkg in .isolated_seurat_pkgs) {
    pkg_dir <- file.path(CORE_LIB_PATH, pkg)
    if (dir.exists(pkg_dir) || pkg %in% .installed_pkg_index(CORE_LIB_PATH)) {
      if (isTRUE(verbose)) message("Removing ", pkg, " from core library: ", CORE_LIB_PATH)
      try(remove.packages(pkg, lib = CORE_LIB_PATH), silent = TRUE)
      try(unlink(pkg_dir, recursive = TRUE, force = TRUE), silent = TRUE)
    }
  }
  invisible(TRUE)
}

CORE_LIB_PATH <- file.path(ENV_PATH_BASE, "core")
if (!.ensure_dir(ENV_PATH_BASE) || !.is_writable_dir(ENV_PATH_BASE)) {
  stop("Package root is not writable: ", ENV_PATH_BASE, ". Fix folder permissions for package_libraries.")
}
if (!.ensure_dir(CORE_LIB_PATH) || !.is_writable_dir(CORE_LIB_PATH)) {
  stop("Core package library is not writable: ", CORE_LIB_PATH, ". Check ownership/permissions.")
}
if (!.ensure_dir(python_env_root) || !.is_writable_dir(python_env_root)) {
  stop("Python env root is not writable: ", python_env_root, ". Check folder permissions.")
}

.advanced_request_marker <- file.path(ENV_PATH_BASE, "advanced_packages.requested")
.advanced_enabled_marker <- file.path(ENV_PATH_BASE, "advanced_packages.enabled")
.advanced_env_flag <- .env_bool("WANLAB_BOOTSTRAP_ADVANCED", default = FALSE)
.advanced_marker_exists <- function(path) {
  nzchar(path) && file.exists(path)
}
.write_marker <- function(path, value = "true") {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  writeLines(as.character(value), con = path, useBytes = TRUE)
  invisible(path)
}
.clear_marker <- function(path) {
  if (nzchar(path) && file.exists(path)) unlink(path, force = TRUE)
  invisible(TRUE)
}
.advanced_requested <- isTRUE(.advanced_env_flag) || .advanced_marker_exists(.advanced_request_marker) || .advanced_marker_exists(.advanced_enabled_marker)

# Clean stale lock dirs from interrupted installs in core.
core_lock_dirs <- Sys.glob(file.path(CORE_LIB_PATH, "00LOCK*"))
if (length(core_lock_dirs)) unlink(core_lock_dirs, recursive = TRUE, force = TRUE)

# Force R to use ONLY our core library + the system base libraries.
# We explicitly exclude the user's personal library to prevent "skipping" installation.
# .Library contains base packages (base, stats, utils, etc.)
sys_libs <- unique(c(.Library, .Library.site))
sys_libs <- sys_libs[dir.exists(sys_libs)] # Ensure they exist

.libPaths(c(CORE_LIB_PATH, sys_libs))

.progress_update(5, "Sandbox ready")
.monitor_open_once()
message("--- Sandboxed Library Paths Configured ---")
message("Lib Mode: ", lib_mode)
message("Env Root: ", ENV_PATH_BASE)
message("Core Lib: ", CORE_LIB_PATH)
message("Python Env Root: ", python_env_root)
message("System Libs: ", paste(sys_libs, collapse=", "))
if (startsWith(lib_mode, "cache")) {
  message("NOTE: package libraries are in user cache (not project folder) because Lib Mode is ", lib_mode, ".")
}
message(
  "Install Supervisor: retries=",
  .install_retry_max,
  ", timeout=",
  if (.install_timeout_sec > 0L) paste0(.install_timeout_sec, "s") else "disabled",
  ", retry_wait_base=",
  .install_retry_wait_sec,
  "s"
)
try({
  pointer_file <- file.path(project_root, "package_libraries_location.txt")
  writeLines(
    c(
      paste("lib_mode:", lib_mode),
      paste("env_root:", ENV_PATH_BASE),
      paste("core_lib:", CORE_LIB_PATH),
      paste("seurat_v4_lib:", file.path(ENV_PATH_BASE, "seurat_v4")),
      paste("seurat_v5_lib:", file.path(ENV_PATH_BASE, "seurat_v5")),
      paste("python_env_root:", python_env_root)
    ),
    con = pointer_file
  )
  message("Library location pointer: ", pointer_file)
}, silent = TRUE)

# Keep Seurat stack isolated from core.
try(.purge_core_seurat_stack(verbose = TRUE), silent = TRUE)

# 2) Install helpers ----------------------------------------------------
.ensure_pkg <- function(pkg,
                        source = c("cran","bioc","github","universe"),
                        ref = NULL,       # for GitHub: "owner/repo[@ref]"
                        universe = NULL,  # for R-universe: e.g. "jlmelville"
                        cran_repos = getOption("repos"),
                        quiet_load = TRUE) {
  source <- match.arg(source)

  if (pkg %in% .isolated_seurat_pkgs) {
    warning("Refusing to install ", pkg, " into core library; this package is isolated to seurat_v4/seurat_v5.")
    return(invisible(FALSE))
  }
  
  # Check if package exists IN CANONICAL CORE ONLY.
  if (isTRUE(.pkg_in_core(pkg)) && isTRUE(tryCatch(requireNamespace(pkg, quietly = quiet_load, lib.loc = CORE_LIB_PATH), error = function(e) FALSE))) {
    return(invisible(TRUE))
  }
  
  # Ensure base installers exist within the sandbox
  if (source %in% c("github","universe") && !requireNamespace("remotes", quietly = TRUE)) {
    .install_cran("remotes", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
  }
  if (source == "bioc" && !requireNamespace("BiocManager", quietly = TRUE, lib.loc = CORE_LIB_PATH)) {
    .install_cran("BiocManager", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
  }
  
  # pick repos
  cran_cran <- tryCatch(unname(cran_repos["CRAN"]), error = function(e) NA_character_)
  if (is.null(cran_repos) || length(cran_repos) == 0 || length(cran_cran) == 0 || is.na(cran_cran) || !nzchar(cran_cran) || identical(cran_cran, "@CRAN@")) {
    cran_repos <- c(CRAN = "https://cloud.r-project.org")
  }
  
  msg <- sprintf("Installing %s from %s...", pkg, source)
  if (!is.null(ref))      msg <- sprintf("%s ref=%s", msg, ref)
  if (!is.null(universe)) msg <- sprintf("%s universe=%s", msg, universe)
  message(msg)
  
  tryCatch({
    switch(source,
           cran = .install_cran(pkg, repos = cran_repos, lib = CORE_LIB_PATH, dependencies = .bootstrap_deps),
           bioc = {
             if (pkg %in% .bioc_data_source_pkgs) {
               .install_bioc_data_source(pkg, lib = CORE_LIB_PATH)
             } else {
               .install_bioc_adaptive(pkg, lib = CORE_LIB_PATH, dependencies = .bootstrap_deps)
             }
           },
           github = .install_ref(
             ref = ref %||% stop("GitHub install needs 'ref'"),
             lib = CORE_LIB_PATH,
             dependencies = .bootstrap_deps,
             upgrade = "never",
             force = !.pkg_installed_in_core(pkg),
             label = pkg,
             verify_pkg = pkg
           ),
           universe = {
             repo <- c(sprintf("https://%s.r-universe.dev", universe %||% stop("Need 'universe'")), CRAN = cran_repos[1])
             .install_cran(pkg, repos = repo, lib = CORE_LIB_PATH, dependencies = .bootstrap_deps)
           }
    )
  }, error = function(e) {
    warning(sprintf("!! Failed to install %s: %s", pkg, conditionMessage(e)))
    return(invisible(FALSE))
  })

  # Enforce isolation even if any dependency unexpectedly pulled Seurat into core.
  try(.purge_core_seurat_stack(verbose = FALSE), silent = TRUE)
  
  ok <- isTRUE(.pkg_in_core(pkg)) && isTRUE(tryCatch(requireNamespace(pkg, quietly = TRUE, lib.loc = CORE_LIB_PATH), error = function(e) FALSE))
  if (!ok) warning(sprintf("!! %s still not available after install", pkg))
  invisible(ok)
}

.ensure_many <- function(plan) {
  all_ok <- TRUE
  .monitor_register_plan(plan)
  for (row in plan) {
    pkg <- as.character(row$pkg %||% "")
    src <- as.character(row$source %||% "--")
    .monitor_pkg_start(pkg, src)
    ok <- do.call(.ensure_pkg, row)
    .monitor_pkg_finish(pkg, src, ok)
    .monitor_write_page(mode = "running")
    all_ok <- all_ok && isTRUE(ok)
  }
  try(.purge_core_seurat_stack(verbose = FALSE), silent = TRUE)
  invisible(all_ok)
}

.normalize_exec_path <- function(x) {
  x <- trimws(as.character(x %||% ""))
  if (!nzchar(x)) return("")
  x <- sub("^'(.+)'$", "\\1", x, perl = TRUE)
  x <- sub('^"(.+)"$', "\\1", x, perl = TRUE)
  x <- path.expand(x)
  x
}

.python_cmd <- function() {
  # Prefer concrete Python executables that can import venv.
  # On Windows, PATH may point to Microsoft Store shims that fail immediately.
  cands <- list()
  py_override <- .normalize_exec_path(Sys.getenv("WANLAB_PYTHON", ""))
  py3 <- .normalize_exec_path(unname(Sys.which("python3")[[1]] %||% ""))
  py <- .normalize_exec_path(unname(Sys.which("python")[[1]] %||% ""))
  pyl <- .normalize_exec_path(unname(Sys.which("py")[[1]] %||% ""))
  if (nzchar(py_override)) cands[[length(cands) + 1L]] <- list(bin = py_override, prefix = character(0), label = "WANLAB_PYTHON")
  if (nzchar(py3)) cands[[length(cands) + 1L]] <- list(bin = py3, prefix = character(0), label = "python3")
  if (nzchar(py)) cands[[length(cands) + 1L]] <- list(bin = py, prefix = character(0), label = "python")
  if (nzchar(pyl) && .Platform$OS.type == "windows") cands[[length(cands) + 1L]] <- list(bin = pyl, prefix = c("-3"), label = "py -3")

  if (!length(cands)) return(NULL)

  for (cc in cands) {
    cc$bin <- .normalize_exec_path(cc$bin)
    if (!nzchar(cc$bin)) next
    probe_file <- tempfile("wan_py_probe_", fileext = ".py")
    writeLines(c("import sys", "import venv", "print(sys.executable)"), con = probe_file, useBytes = TRUE)
    on.exit(unlink(probe_file, force = TRUE), add = TRUE)
    probe <- c(cc$prefix, probe_file)
    out <- tryCatch(system2(cc$bin, probe, stdout = TRUE, stderr = TRUE), error = function(e) structure(conditionMessage(e), status = 1L))
    st <- attr(out, "status")
    if (is.null(st) || identical(as.integer(st), 0L)) return(cc)
  }
  NULL
}

.venv_bindir <- function(venv_path) {
  if (.Platform$OS.type == "windows") file.path(venv_path, "Scripts") else file.path(venv_path, "bin")
}

.venv_python <- function(venv_path) {
  b <- .venv_bindir(venv_path)
  if (.Platform$OS.type == "windows") file.path(b, "python.exe") else file.path(b, "python")
}

.venv_pip <- function(venv_path) {
  b <- .venv_bindir(venv_path)
  if (.Platform$OS.type == "windows") file.path(b, "pip.exe") else file.path(b, "pip")
}

.ensure_python_venv <- function(venv_path) {
  py_cmd <- .python_cmd()
  if (is.null(py_cmd) || !nzchar(py_cmd$bin %||% "")) {
    warning("Python bootstrap skipped: no usable Python runtime with venv support found on PATH.")
    return(invisible(FALSE))
  }
  py_cmd$bin <- .normalize_exec_path(py_cmd$bin)
  if (!nzchar(py_cmd$bin)) {
    warning("Python bootstrap skipped: resolved Python executable path is empty after normalization.")
    return(invisible(FALSE))
  }
  # Agent note: interrupted venv creation can leave python without pip; that
  # directory is invalid for this app and must be rebuilt deterministically.
  if (dir.exists(venv_path) &&
      (!file.exists(.venv_python(venv_path)) || !file.exists(.venv_pip(venv_path)))) {
    unlink(venv_path, recursive = TRUE, force = TRUE)
  }
  if (!file.exists(.venv_python(venv_path))) {
    ok <- .with_retry(
      label = sprintf("Create Python venv: %s", venv_path),
      fn = function() {
        args <- c(py_cmd$prefix %||% character(0), "-m", "venv", venv_path)
        out <- system2(py_cmd$bin, args, stdout = TRUE, stderr = TRUE)
        st <- attr(out, "status")
        if (!is.null(st) && as.integer(st) != 0L) {
          msg <- paste(utils::tail(out, 20), collapse = "\n")
          if (!nzchar(msg)) msg <- sprintf("exit status %s", as.integer(st))
          stop(
            sprintf(
              "python venv creation failed (%s, %s): %s",
              py_cmd$label %||% "python",
              py_cmd$bin,
              msg
            )
          )
        }
        if (!file.exists(.venv_python(venv_path))) stop("venv python not found after creation")
      }
    )
    if (!isTRUE(ok)) return(invisible(FALSE))
  }
  invisible(TRUE)
}

.pip_install <- function(venv_path, pkgs) {
  pip <- .venv_pip(venv_path)
  py <- .venv_python(venv_path)
  if (!file.exists(py) || !file.exists(pip)) return(invisible(FALSE))
  ok_pip <- .with_retry(
    label = sprintf("Upgrade pip in %s", basename(venv_path)),
    fn = function() {
      status <- system2(py, c("-m", "pip", "install", "--upgrade", "pip", "wheel", shQuote("setuptools<81")), stdout = TRUE, stderr = TRUE)
      if (!identical(attr(status, "status"), NULL) && attr(status, "status") != 0) stop("pip bootstrap failed")
    }
  )
  if (!isTRUE(ok_pip)) return(invisible(FALSE))
  ok <- .with_retry(
    label = sprintf("Install python packages in %s", basename(venv_path)),
    timeout_sec = max(1800L, .install_timeout_sec),
    fn = function() {
      args <- c("install", pkgs)
      status <- system2(pip, args, stdout = TRUE, stderr = TRUE)
      if (!identical(attr(status, "status"), NULL) && attr(status, "status") != 0) {
        stop("pip install failed for: ", paste(pkgs, collapse = ", "))
      }
    }
  )
  invisible(isTRUE(ok))
}

.bootstrap_python_envs <- function() {
  if (!isTRUE(.bootstrap_python)) {
    message("Python bootstrap disabled by WANLAB_BOOTSTRAP_PYTHON.")
    return(invisible(FALSE))
  }
  pyscenic_env <- file.path(python_env_root, "pyscenic")
  if (!.ensure_python_venv(pyscenic_env)) return(invisible(FALSE))
  py_pkgs <- c("pyscenic", "scanpy", "anndata", "loompy", "ctxcore")
  if (isTRUE(TEST_VERSION)) {
    # Test-version only package set for hidden/dev analysis pages.
    py_pkgs <- c(py_pkgs, "scvelo")
    message("[TEST_VERSION] Enabled: including hidden-page Python package bootstrap (scvelo).")
  }
  if (isTRUE(.bootstrap_cellrank)) py_pkgs <- c(py_pkgs, "cellrank")
  ok <- .pip_install(pyscenic_env, py_pkgs)
  if (isTRUE(ok)) {
    message("Python bootstrap ready: ", pyscenic_env)
  } else {
    warning("Python bootstrap incomplete: ", pyscenic_env)
  }
  invisible(isTRUE(ok))
}

.patch_monocle2_igraph_api_calls <- function(lib = CORE_LIB_PATH) {
  pkg_dir <- file.path(lib, "monocle")
  if (!dir.exists(pkg_dir)) return(invisible(FALSE))
  r_dir <- file.path(pkg_dir, "R")
  r_files <- unique(c(
    list.files(pkg_dir, pattern = "\\.[Rr]$", recursive = TRUE, full.names = TRUE),
    if (dir.exists(r_dir)) list.files(r_dir, recursive = TRUE, full.names = TRUE) else character(0)
  ))
  r_files <- r_files[file.exists(r_files)]
  r_files <- r_files[!grepl("\\.(rdb|rdx|rds|dll|so|dylib)$", tolower(r_files))]
  if (!length(r_files)) return(invisible(FALSE))
  patched <- 0L
  patched_nei <- 0L
  patched_neimode <- 0L
  patched_graphdfs <- 0L
  patched_graphneigh <- 0L
  for (f in r_files) {
    txt <- tryCatch(readLines(f, warn = FALSE), error = function(e) character(0))
    if (!length(txt)) next
    old <- txt
    txt <- gsub("\\bnei\\(", ".nei(", txt, perl = TRUE)
    txt <- gsub("\\bneimode\\s*=", "mode =", txt, perl = TRUE)
    txt <- gsub("\\bgraph\\.dfs\\(", "dfs(", txt, perl = TRUE)
    txt <- gsub("\\bgraph\\.neighborhood\\(", "neighborhood(", txt, perl = TRUE)
    if (!identical(old, txt)) {
      patched_nei <- patched_nei + sum(grepl("\\bnei\\(", old, perl = TRUE))
      patched_neimode <- patched_neimode + sum(grepl("\\bneimode\\s*=", old, perl = TRUE))
      patched_graphdfs <- patched_graphdfs + sum(grepl("\\bgraph\\.dfs\\(", old, perl = TRUE))
      patched_graphneigh <- patched_graphneigh + sum(grepl("\\bgraph\\.neighborhood\\(", old, perl = TRUE))
      writeLines(txt, f, useBytes = TRUE)
      patched <- patched + 1L
    }
  }
  message(
    "Monocle2 compatibility patch: updated ", patched, " file(s)",
    " [nei->.nei: ", patched_nei,
    ", neimode->mode: ", patched_neimode,
    ", graph.dfs->dfs: ", patched_graphdfs,
    ", graph.neighborhood->neighborhood: ", patched_graphneigh, "]."
  )
  if (patched == 0L) {
    message("Monocle2 compatibility patch note: no editable source files required patching in installed package layout; runtime namespace shim will still apply at analysis runtime.")
  }
  invisible(patched > 0L)
}

.monocle2_compat_smoke <- function(lib = CORE_LIB_PATH) {
  ok <- tryCatch({
    old <- .libPaths()
    on.exit(.libPaths(old), add = TRUE)
    .libPaths(c(lib, .libPaths()))
    suppressPackageStartupMessages(library("igraph", lib.loc = lib, character.only = TRUE))
    suppressPackageStartupMessages(library("monocle", lib.loc = lib, character.only = TRUE))
    g <- igraph::make_ring(5)
    suppressWarnings(igraph::dfs(g, root = 1, mode = "all"))
    suppressWarnings({
      nei_fun <- get0("neighbors", envir = asNamespace("igraph"), mode = "function", inherits = FALSE)
      if (!is.function(nei_fun)) stop("igraph neighbors() is unavailable in compatibility smoke check")
      vv <- nei_fun(g, 1, mode = "all")
      if (is.null(vv) || length(vv) < 1L) stop("igraph neighbors() returned empty result in compatibility smoke check")
    })
    TRUE
  }, error = function(e) {
    message("Monocle2 compatibility smoke check failed: ", conditionMessage(e))
    FALSE
  })
  invisible(isTRUE(ok))
}

.enforce_monocle2_working_igraph <- function(lib = CORE_LIB_PATH, expected = .monocle2_working_igraph) {
  if (!("igraph" %in% .installed_pkg_index(lib))) {
    message("Monocle2 compatibility: igraph missing in core; installing ", expected, ".")
    .install_version("igraph", version = expected, lib = lib, repos = "https://cloud.r-project.org", dependencies = .bootstrap_deps, upgrade = "never")
  }

  cur <- .pkg_version_in_lib("igraph", lib)
  same <- tryCatch(utils::compareVersion(as.character(cur), as.character(expected)) == 0L, error = function(e) FALSE)
  if (!isTRUE(same)) {
    message("Monocle2 compatibility: enforcing igraph ", expected, " (current ", cur, ").")
    .install_version("igraph", version = expected, lib = lib, repos = "https://cloud.r-project.org", dependencies = .bootstrap_deps, upgrade = "never")
    cur <- .pkg_version_in_lib("igraph", lib)
    same <- tryCatch(utils::compareVersion(as.character(cur), as.character(expected)) == 0L, error = function(e) FALSE)
    if (!isTRUE(same)) stop("Failed to enforce igraph ", expected, " for Monocle2 compatibility. Current: ", cur)
  }
  invisible(TRUE)
}

.ensure_monocle2_compat <- function(lib = CORE_LIB_PATH) {
  if (!("monocle" %in% .installed_pkg_index(lib))) return(invisible(FALSE))
  .enforce_monocle2_working_igraph(lib = lib, expected = .monocle2_working_igraph)
  ig_v <- .pkg_version_in_lib("igraph", lib)

  message("Monocle2 compatibility: igraph ", ig_v, " detected; applying patch workflow.")

  # Monocle2 may need this data package available to load cleanly.
  if (!("HSMMSingleCell" %in% .installed_pkg_index(lib))) {
    tryCatch({
      .install_bioc_data_source("HSMMSingleCell", lib = lib)
    }, error = function(e) {
      message("Monocle2 dependency note (HSMMSingleCell): ", conditionMessage(e))
    })
  }

  .patch_monocle2_igraph_api_calls(lib = lib)
  .monocle2_compat_smoke(lib = lib)
}

`%||%` <- function(a,b) if (is.null(a)) b else a

.unload_ns <- function(pkg) {
  pkg <- as.character(pkg %||% "")
  if (!nzchar(pkg)) return(invisible(TRUE))
  pkg_search <- paste0("package:", pkg)
  if (pkg_search %in% search()) {
    try(detach(pkg_search, unload = TRUE, character.only = TRUE), silent = TRUE)
  }
  if (pkg %in% loadedNamespaces()) {
    try(unloadNamespace(pkg), silent = TRUE)
  }
  invisible(!(pkg %in% loadedNamespaces()))
}

.base_namespaces <- function() {
  c(
    "base", "compiler", "datasets", "graphics", "grDevices",
    "grid", "methods", "stats", "tools", "utils"
  )
}

.namespace_importers <- function(target, namespaces = loadedNamespaces()) {
  target <- as.character(target %||% "")
  if (!nzchar(target)) return(character(0))
  pool <- setdiff(unique(as.character(namespaces)), c(.base_namespaces(), target))
  sort(unique(pool[vapply(pool, function(nm) {
    target %in% tryCatch(names(getNamespaceImports(nm)), error = function(e) character(0))
  }, logical(1))]))
}

.unload_importers_of <- function(target, max_pass = 8L) {
  target <- as.character(target %||% "")
  if (!nzchar(target)) return(invisible(TRUE))
  for (i in seq_len(max(1L, as.integer(max_pass)))) {
    importers <- .namespace_importers(target)
    if (!length(importers)) break
    for (pkg in rev(importers)) .unload_ns(pkg)
    .unload_ns(target)
    if (!(target %in% loadedNamespaces())) break
  }
  invisible(!(target %in% loadedNamespaces()))
}

.unload_seurat_stack <- function() {
  # Aggressively unload Seurat stack and importers to avoid namespace lock errors
  # during cross-version installs in isolated env bootstraps.
  .unload_ns("loupeR")
  .unload_ns("scRNAtoolVis")
  for (i in seq_len(8L)) {
    blocking_before <- intersect(c("Seurat", "SeuratObject"), loadedNamespaces())
    if (!length(blocking_before)) break
    .unload_importers_of("Seurat", max_pass = 1L)
    .unload_importers_of("SeuratObject", max_pass = 1L)
    .unload_ns("Seurat")
    .unload_ns("SeuratObject")
    .unload_ns("loupeR")
    .unload_ns("scRNAtoolVis")
    blocking_after <- intersect(c("Seurat", "SeuratObject"), loadedNamespaces())
    if (!length(blocking_after) || identical(blocking_after, blocking_before)) break
  }
  invisible(gc())
}

.pkg_version_in_lib <- function(pkg, lib_path) {
  tryCatch(as.character(utils::packageVersion(pkg, lib.loc = lib_path)), error = function(e) NA_character_)
}

.version_ge <- function(v, min_v) {
  if (is.na(v) || !nzchar(v)) return(FALSE)
  tryCatch(utils::compareVersion(as.character(v), as.character(min_v)) >= 0, error = function(e) FALSE)
}

.ensure_scrnatoolvis_in_env <- function(lib_path) {
  if (requireNamespace("scRNAtoolVis", lib.loc = lib_path, quietly = TRUE)) return(invisible(TRUE))
  message("Ensuring scRNAtoolVis in env: ", lib_path)
  current_paths <- .libPaths()
  on.exit(.libPaths(current_paths), add = TRUE)
  .libPaths(c(lib_path, CORE_LIB_PATH, sys_libs))
  tryCatch({
    # scRNAtoolVis imports ComplexHeatmap (Bioconductor). Ensure it exists in
    # the target isolated Seurat environment before GitHub install.
    .ensure_bioc_pkg_in_env("ComplexHeatmap", lib_path)

    if (!requireNamespace("remotes", quietly = TRUE)) {
      .install_cran("remotes", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
    }
    .install_github(
      ref = "junjunlab/scRNAtoolVis",
      lib = lib_path,
      dependencies = NA,
      upgrade = "never",
      build = FALSE,
      label = "scRNAtoolVis",
      verify_pkg = "scRNAtoolVis"
    )
  }, error = function(e) {
    warning("Failed to install scRNAtoolVis in env ", lib_path, ": ", conditionMessage(e))
  })
  invisible(requireNamespace("scRNAtoolVis", lib.loc = lib_path, quietly = TRUE))
}

.ensure_bioc_pkg_in_env <- function(pkg, lib_path) {
  if (requireNamespace(pkg, lib.loc = c(lib_path, CORE_LIB_PATH, sys_libs), quietly = TRUE)) {
    return(invisible(TRUE))
  }
  message("Ensuring ", pkg, " in env: ", lib_path)
  current_paths <- .libPaths()
  on.exit(.libPaths(current_paths), add = TRUE)
  .libPaths(c(lib_path, CORE_LIB_PATH, sys_libs))
  tryCatch({
    if (!requireNamespace("BiocManager", quietly = TRUE)) {
      .install_cran("BiocManager", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
    }

    # Keep Bioconductor repositories aligned to the current R/Bioc release
    # before attempting env-scoped installs.
    .sync_bioc_release()

    bioc_type <- .bioc_install_type()
    .install_env_with_type <- function(type_value = bioc_type, label_prefix = "Bioc env install") {
      .with_retry(
        label = sprintf("%s: %s", label_prefix, pkg),
        fn = function() {
          before_pkgs <- .installed_pkg_index(lib_path)
          args <- list(
            pkgs = pkg,
            lib = lib_path,
            update = FALSE,
            ask = FALSE,
            dependencies = .bootstrap_deps
          )
          if (!is.na(type_value) && nzchar(type_value)) args$type <- type_value
          do.call(BiocManager::install, args)
          .monitor_record_dependency_installs(
            lib = lib_path,
            before_pkgs = before_pkgs,
            requested_pkgs = pkg,
            source = "bioc"
          )
          if (!(pkg %in% .installed_pkg_index(lib_path))) {
            stop("Bioc env install completed but package still missing: ", pkg)
          }
        }
      )
      invisible(pkg %in% .installed_pkg_index(lib_path))
    }

    ok <- .install_env_with_type(type_value = bioc_type, label_prefix = "Bioc env install")
    if (!isTRUE(ok) && .Platform$OS.type == "windows" && .is_binary_type(bioc_type)) {
      message("Bioc env binary unavailable for ", pkg, "; retrying from source.")
      ok <- .install_env_with_type(type_value = "source", label_prefix = "Bioc env install source fallback")
    }
    if (!isTRUE(ok)) stop("Bioc env install completed but package still missing: ", pkg)
  }, error = function(e) {
    warning("Failed to install ", pkg, " in env ", lib_path, ": ", conditionMessage(e))
  })
  invisible(requireNamespace(pkg, lib.loc = c(lib_path, CORE_LIB_PATH, sys_libs), quietly = TRUE))
}

.ensure_cran_pkg_in_env <- function(pkg, lib_path, min_version = NA_character_) {
  installed <- pkg %in% .installed_pkg_index(lib_path)
  if (isTRUE(installed) && !is.na(min_version) && nzchar(min_version)) {
    installed <- .version_ge(.pkg_version_in_lib(pkg, lib_path), min_version)
  }
  if (isTRUE(installed)) return(invisible(TRUE))

  message("Ensuring ", pkg, " in env: ", lib_path)
  current_paths <- .libPaths()
  on.exit(.libPaths(current_paths), add = TRUE)
  .libPaths(c(lib_path, CORE_LIB_PATH, sys_libs))

  .install_cran(pkg, repos = "https://cloud.r-project.org", lib = lib_path, dependencies = .bootstrap_deps)
  ok <- pkg %in% .installed_pkg_index(lib_path)
  if (!isTRUE(ok)) stop("CRAN env install completed but package still missing: ", pkg)
  if (!is.na(min_version) && nzchar(min_version) && !.version_ge(.pkg_version_in_lib(pkg, lib_path), min_version)) {
    stop("CRAN env install completed but ", pkg, " version is below required ", min_version)
  }
  invisible(TRUE)
}

.ensure_louper_in_env <- function(lib_path) {
  if (!isTRUE(.bootstrap_install_louper)) return(invisible(FALSE))
  pkg_in_env <- "loupeR" %in% .installed_pkg_index(lib_path)

  if (isTRUE(pkg_in_env)) {
    message("Ensuring loupeR runtime setup in env: ", lib_path)
  } else {
    message("Ensuring loupeR in env: ", lib_path)
  }

  current_paths <- .libPaths()
  on.exit(.libPaths(current_paths), add = TRUE)
  .libPaths(c(lib_path, CORE_LIB_PATH, sys_libs))

  ok_pkg <- TRUE
  if (!isTRUE(pkg_in_env)) {
    ok_pkg <- tryCatch({
      if (!requireNamespace("remotes", quietly = TRUE)) {
        .install_cran("remotes", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
      }
      .install_github(
        ref = "10XGenomics/loupeR",
        lib = lib_path,
        # Seurat/hdf5r should already be available from isolated env + core; avoid pulling extra dependency trees here.
        dependencies = FALSE,
        upgrade = "never",
        build = FALSE,
        label = sprintf("loupeR (%s)", basename(lib_path)),
        verify_pkg = "loupeR"
      )
      # Root-cause guard: remotes can skip unchanged SHA while loupeR is still absent in this lib.
      if (!("loupeR" %in% .installed_pkg_index(lib_path))) {
        message("loupeR still missing after non-forced GitHub install in ", lib_path, "; retrying with force=TRUE.")
        .install_github(
          ref = "10XGenomics/loupeR",
          lib = lib_path,
          dependencies = FALSE,
          upgrade = "never",
          force = TRUE,
          build = FALSE,
          label = sprintf("loupeR (%s, forced)", basename(lib_path)),
          verify_pkg = "loupeR"
        )
      }
      "loupeR" %in% .installed_pkg_index(lib_path)
    }, error = function(e) {
      warning("Failed to install loupeR in env ", lib_path, ": ", conditionMessage(e))
      FALSE
    })
    pkg_in_env <- isTRUE(ok_pkg)
  }

  if (!isTRUE(pkg_in_env)) {
    return(invisible(FALSE))
  }

  worker_path <- file.path(getwd(), "interface", "export", "loupe_export_worker.R")
  rscript <- Sys.which("Rscript")
  if (!file.exists(worker_path) || !nzchar(rscript)) {
    warning("loupeR subprocess prerequisites are unavailable for env ", lib_path)
    return(invisible(FALSE))
  }

  result_path <- tempfile("wanlab_louper_setup_", fileext = ".rds")
  log_path <- tempfile("wanlab_louper_setup_", fileext = ".log")
  on.exit(unlink(c(result_path, log_path), force = TRUE), add = TRUE)

  # Agent note: keep loupeR setup outside the bootstrap process. R can load only one
  # future namespace, while the isolated Seurat libraries intentionally retain their own version.
  status <- system2(
    rscript,
    c("--vanilla", shQuote(worker_path), "setup", shQuote(lib_path), shQuote(result_path)),
    stdout = log_path,
    stderr = log_path
  )
  result <- if (file.exists(result_path)) readRDS(result_path) else NULL
  ok_setup <- identical(status, 0L) && is.list(result) && isTRUE(result$ok)
  if (!isTRUE(ok_setup)) {
    worker_log <- if (file.exists(log_path)) readLines(log_path, warn = FALSE) else character(0)
    detail <- result$error %||% paste(tail(worker_log, 20L), collapse = "\n")
    warning("loupeR isolated setup failed in env ", lib_path, ": ", detail)
    return(invisible(FALSE))
  }

  ok_exe <- length(result$executable %||% character(0)) > 0L
  if (isFALSE(ok_exe)) {
    warning("loupeR executable not verified in env ", lib_path, "; .cloupe export may fail.")
    return(invisible(FALSE))
  }

  invisible(TRUE)
}

# 3) Environment Manager: Seurat v4/v5 Isolation Logic
# These functions create isolated library folders (siblings to 'core')

.seurat_env_requirements <- function(major) {
  if (is.null(major)) major <- NA_integer_
  major_chr <- as.character(suppressWarnings(as.integer(major)))
  switch(
    major_chr,
    "4" = list(
      seurat_prefix = "4.",
      seuratobject_prefix = "4.",
      sctransform_min = "0.4.1"
    ),
    "5" = list(
      seurat_prefix = "5.",
      seuratobject_prefix = "5.",
      sctransform_min = "0.4.1"
    ),
    stop("Unsupported Seurat major version for isolated environment: ", major)
  )
}

.seurat_env_is_ready <- function(major, seurat_version, seuratobject_version, sctransform_version) {
  reqs <- .seurat_env_requirements(major)
  version_ge_local <- function(v, min_v) {
    if (is.na(v) || !nzchar(v)) return(FALSE)
    tryCatch(utils::compareVersion(as.character(v), as.character(min_v)) >= 0, error = function(e) FALSE)
  }
  !is.na(seurat_version) &&
    startsWith(as.character(seurat_version), reqs$seurat_prefix) &&
    !is.na(seuratobject_version) &&
    startsWith(as.character(seuratobject_version), reqs$seuratobject_prefix) &&
    version_ge_local(as.character(sctransform_version), reqs$sctransform_min)
}

#' Install/Load Seurat v4 into an isolated library
setup_seurat_v4 <- function() {
  lib_path <- file.path(ENV_PATH_BASE, "seurat_v4")
  if (!dir.exists(lib_path)) dir.create(lib_path, recursive = TRUE)
  
  # Temporarily prepend this path to check/install packages
  current_paths <- .libPaths()
  on.exit(.libPaths(current_paths)) # Reset after check
  .libPaths(c(lib_path, CORE_LIB_PATH, sys_libs))

  # Clean stale lock dirs from interrupted installs.
  lock_dirs <- Sys.glob(file.path(lib_path, "00LOCK*"))
  if (length(lock_dirs)) unlink(lock_dirs, recursive = TRUE, force = TRUE)

  if (!requireNamespace("remotes", quietly = TRUE)) .install_cran("remotes", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
  .ensure_cran_pkg_in_env("sp", lib_path, min_version = "1.5.0")
  .ensure_cran_pkg_in_env("spam", lib_path)

  v <- .pkg_version_in_lib("Seurat", lib_path)
  v_sct <- tryCatch(
    as.character(utils::packageVersion("sctransform", lib.loc = c(lib_path, CORE_LIB_PATH, sys_libs))),
    error = function(e) NA_character_
  )
  v_obj <- .pkg_version_in_lib("SeuratObject", lib_path)
  v4_ok <- .seurat_env_is_ready(
    major = 4L,
    seurat_version = v,
    seuratobject_version = v_obj,
    sctransform_version = v_sct
  )
  if (isTRUE(v4_ok)) {
    # Fast path: exact env already present, avoid heavy load/unload.
    .ensure_scrnatoolvis_in_env(lib_path)
    .ensure_bioc_pkg_in_env("DESeq2", lib_path)
    .ensure_louper_in_env(lib_path)
    return(lib_path)
  }
  
  if (!v4_ok) {
    reqs <- .seurat_env_requirements(4L)
    .show_long_bootstrap_notice(stage = "Seurat v4 environment", force = TRUE)
    message("--- Setting up Seurat v4 Environment ---")
    need_sct <- !.version_ge(v_sct, reqs$sctransform_min)
    need_obj <- (is.na(v_obj) || !startsWith(v_obj, reqs$seuratobject_prefix))
    need_seu <- (is.na(v) || !startsWith(v, reqs$seurat_prefix))

    # Install only missing pieces to avoid repeating long source builds on retries.
    if (need_sct) {
      .install_cran("sctransform", lib = lib_path, repos = "https://cloud.r-project.org", dependencies = .bootstrap_deps)
    }
    if (need_obj) {
      .install_version("SeuratObject", version = "4.1.4", lib = lib_path, repos = "https://cloud.r-project.org", upgrade = "never", dependencies = NA)
    }
    if (need_seu) {
      # For source installs, dependency checks happen against the target env context.
      # Ensure these packages are physically present in the env lib (not just core).
      dep_missing <- .seurat_v4_prefetch_pkgs[
        !vapply(
          .seurat_v4_prefetch_pkgs,
          function(p) p %in% .installed_pkg_index(lib_path),
          logical(1)
        )
      ]
      # Seurat requires leiden >= 0.3.1; force refresh in env if missing/too old.
      if (!.version_ge(.pkg_version_in_lib("leiden", lib_path), "0.3.1")) {
        dep_missing <- unique(c(dep_missing, "leiden"))
      }
      if (length(dep_missing)) {
        message("Preparing Seurat v4 dependency bundle (binary-first): ", paste(dep_missing, collapse = ", "))
        .install_cran(dep_missing, lib = lib_path, repos = "https://cloud.r-project.org", dependencies = NA)
      }
      .install_version("Seurat", version = "4.4.0", lib = lib_path, repos = "https://cloud.r-project.org", upgrade = "never", dependencies = FALSE)
    }
  }
  
  # Smoke test: ensure v4 loads from its isolated environment
  .libPaths(c(lib_path, CORE_LIB_PATH, sys_libs))
  .unload_seurat_stack()
  suppressPackageStartupMessages(library("Seurat", lib.loc = lib_path, character.only = TRUE))
  loaded_v <- as.character(utils::packageVersion("Seurat"))
  if (!startsWith(loaded_v, "4.")) {
    stop("Seurat v4 environment check failed: loaded Seurat is not v4 (loaded ", loaded_v, ").")
  }
  .ensure_scrnatoolvis_in_env(lib_path)
  .ensure_bioc_pkg_in_env("DESeq2", lib_path)
  .ensure_louper_in_env(lib_path)
  
  return(lib_path)
}

#' Install/Load Seurat v5 into an isolated library
setup_seurat_v5 <- function() {
  lib_path <- file.path(ENV_PATH_BASE, "seurat_v5")
  if (!dir.exists(lib_path)) dir.create(lib_path, recursive = TRUE)
  
  current_paths <- .libPaths()
  on.exit(.libPaths(current_paths))
  .libPaths(c(lib_path, CORE_LIB_PATH, sys_libs))

  # Clean stale lock dirs from interrupted installs.
  lock_dirs <- Sys.glob(file.path(lib_path, "00LOCK*"))
  if (length(lock_dirs)) unlink(lock_dirs, recursive = TRUE, force = TRUE)

  if (!requireNamespace("remotes", quietly = TRUE)) .install_cran("remotes", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
  .ensure_cran_pkg_in_env("sp", lib_path, min_version = "1.5.0")
  .ensure_cran_pkg_in_env("spam", lib_path)

  v <- .pkg_version_in_lib("Seurat", lib_path)
  v_obj <- .pkg_version_in_lib("SeuratObject", lib_path)
  v_sct <- tryCatch(
    as.character(utils::packageVersion("sctransform", lib.loc = c(lib_path, CORE_LIB_PATH, sys_libs))),
    error = function(e) NA_character_
  )
  v5_ok <- .seurat_env_is_ready(
    major = 5L,
    seurat_version = v,
    seuratobject_version = v_obj,
    sctransform_version = v_sct
  )
  if (isTRUE(v5_ok)) {
    # Fast path: exact env already present, avoid heavy load/unload.
    .ensure_scrnatoolvis_in_env(lib_path)
    .ensure_bioc_pkg_in_env("DESeq2", lib_path)
    .ensure_louper_in_env(lib_path)
    return(lib_path)
  }
  
  if (!v5_ok) {
    reqs <- .seurat_env_requirements(5L)
    .show_long_bootstrap_notice(stage = "Seurat v5 environment", force = TRUE)
    message("--- Setting up Seurat v5 Environment ---")
    need_sct <- !.version_ge(v_sct, reqs$sctransform_min)
    need_obj <- (is.na(v_obj) || !startsWith(v_obj, reqs$seuratobject_prefix))
    need_seu <- (is.na(v) || !startsWith(v, reqs$seurat_prefix))

    # Install only missing pieces to avoid repeating long source builds on retries.
    if (need_sct) {
      .install_cran("sctransform", lib = lib_path, repos = "https://cloud.r-project.org", dependencies = .bootstrap_deps)
    }
    if (need_obj) {
      .install_version("SeuratObject", version = "5.0.2", lib = lib_path, repos = "https://cloud.r-project.org", upgrade = "never", dependencies = NA)
    }
    if (need_seu) {
      # For source installs, dependency checks happen against the target env context.
      # Ensure these packages are physically present in the env lib (not just core).
      dep_missing <- .seurat_v5_prefetch_pkgs[
        !vapply(
          .seurat_v5_prefetch_pkgs,
          function(p) p %in% .installed_pkg_index(lib_path),
          logical(1)
        )
      ]
      # Seurat requires leiden >= 0.3.1; force refresh in env if missing/too old.
      if (!.version_ge(.pkg_version_in_lib("leiden", lib_path), "0.3.1")) {
        dep_missing <- unique(c(dep_missing, "leiden"))
      }
      if (length(dep_missing)) {
        message("Preparing Seurat v5 dependency bundle (binary-first): ", paste(dep_missing, collapse = ", "))
        .install_cran(dep_missing, lib = lib_path, repos = "https://cloud.r-project.org", dependencies = NA)
      }
      .install_version("Seurat", version = "5.0.3", lib = lib_path, repos = "https://cloud.r-project.org", upgrade = "never", dependencies = FALSE)
    }
  }
  
  # Smoke test: ensure v5 loads from its isolated environment
  .libPaths(c(lib_path, CORE_LIB_PATH, sys_libs))
  .unload_seurat_stack()
  suppressPackageStartupMessages(library("Seurat", lib.loc = lib_path, character.only = TRUE))
  loaded_v <- as.character(utils::packageVersion("Seurat"))
  if (!startsWith(loaded_v, "5.")) {
    stop("Seurat v5 environment check failed: loaded Seurat is not v5 (loaded ", loaded_v, ").")
  }
  .ensure_scrnatoolvis_in_env(lib_path)
  .ensure_bioc_pkg_in_env("DESeq2", lib_path)
  .ensure_louper_in_env(lib_path)
  
  return(lib_path)
}

.with_libpaths <- function(paths, fn) {
  current_paths <- .libPaths()
  on.exit(.libPaths(current_paths), add = TRUE)
  target_paths <- unique(as.character(paths))
  target_paths <- target_paths[nzchar(target_paths)]
  .libPaths(target_paths)
  fn()
}

.seurat_bootstrap_lib_paths <- function() {
  list(
    v4 = file.path(ENV_PATH_BASE, "seurat_v4"),
    v5 = file.path(ENV_PATH_BASE, "seurat_v5")
  )
}

.advanced_bootstrap_lib_paths <- function() {
  seurat_paths <- .seurat_bootstrap_lib_paths()
  unique(c(seurat_paths$v5, seurat_paths$v4, CORE_LIB_PATH, sys_libs))
}

.prepare_advanced_analysis_bootstrap_context <- function(plan_missing) {
  seurat_paths <- .seurat_bootstrap_lib_paths()
  if (!dir.exists(seurat_paths$v4)) dir.create(seurat_paths$v4, recursive = TRUE, showWarnings = FALSE)
  if (!dir.exists(seurat_paths$v5)) dir.create(seurat_paths$v5, recursive = TRUE, showWarnings = FALSE)

  if (!length(plan_missing)) return(invisible(seurat_paths))

  message("--- Preparing isolated Seurat environments before advanced analysis packages ---")
  tm_pre_adv_v4 <- .step_start("Advanced bootstrap Seurat v4")
  seurat_paths$v4 <- setup_seurat_v4()
  .step_end(tm_pre_adv_v4)
  .unload_seurat_stack()
  tm_pre_adv_v5 <- .step_start("Advanced bootstrap Seurat v5")
  seurat_paths$v5 <- setup_seurat_v5()
  .step_end(tm_pre_adv_v5)
  .unload_seurat_stack()
  try(.purge_core_seurat_stack(verbose = FALSE), silent = TRUE)

  invisible(seurat_paths)
}

.install_missing_advanced_analysis_pkgs <- function(plan_missing) {
  if (!length(plan_missing)) return(invisible(TRUE))
  .with_libpaths(
    .advanced_bootstrap_lib_paths(),
    function() .ensure_many(plan_missing)
  )
}
 
# 4) Package Plan (RESTORED FROM ORIGINAL)
PKG_PLAN_CORE <- list(
  # CRAN UI shell
  list(pkg="here",              source="cran"),
  list(pkg="hdf5r",             source="cran"),
  # Agent note: BPCells provides lossless on-disk IterableMatrix storage for
  # Seurat v5 large-data workflows. Keep it in the managed core library so the
  # RDS/import/export paths never install packages ad hoc.
  list(pkg="BPCells",           source="github", ref="bnprks/BPCells/r"),
  list(pkg="remotes",           source="cran"),
  list(pkg="RSpectra",          source="cran"),
  list(pkg="future",            source="cran"),
  list(pkg="shiny",             source="cran"),
  list(pkg="shinyjs",           source="cran"),
  list(pkg="shinybusy",         source="cran"),
  list(pkg="bslib",             source="cran"),
  list(pkg="shinyFiles",        source="cran"),
  list(pkg="shinycssloaders",   source="cran"),
  list(pkg="readr",             source="cran"),
  list(pkg="DT",                source="cran"),
  list(pkg="rhandsontable",     source="cran"),
  list(pkg="plotly",            source="cran"),
  list(pkg="shinyWidgets",      source="cran"),
  list(pkg="sortable",          source="cran"),
  list(pkg="jsonlite",          source="cran"),
  list(pkg="quarto",            source="cran"),
  list(pkg="qs2",               source="cran"),
  list(pkg="httr",              source="cran"),
  list(pkg="dplyr",             source="cran"),
  list(pkg="ggplot2",           source="cran"),
  list(pkg="ggalluvial",        source="cran"),
  list(pkg="ggnewscale",        source="cran"),
  list(pkg="ggrepel",           source="cran"),
  list(pkg="ggraph",            source="cran"),
  list(pkg="igraph",            source="cran"),
  list(pkg="viridis",           source="cran"),
  list(pkg="RcppEigen",         source="cran"),
  list(pkg="RANN",              source="cran"),
  list(pkg="ROCR",              source="cran"),
  list(pkg="harmony",           source="cran"),
  list(pkg="colourpicker",      source="cran"),
  list(pkg="vipor",             source="cran"),
  list(pkg="fs",                source="cran"),
  
  # Bioconductor packages
  list(pkg="GenomeInfoDbData",  source="bioc"),
  list(pkg="scDblFinder",       source="bioc"),
  list(pkg="UCell",             source="bioc"), # Needed for Flowgate
  list(pkg="SingleR",           source="bioc"),
  list(pkg="zellkonverter",     source="bioc"),
  list(pkg="celldex",           source="github", ref=.annotation_github_ref("celldex")),
  list(pkg="DESeq2",            source="bioc"),
  list(pkg="SingleCellExperiment", source="bioc"),
  list(pkg="SummarizedExperiment", source="bioc"),
  list(pkg="BiocGenerics",      source="bioc"),
  list(pkg="S4Vectors",         source="bioc"),
  list(pkg="MatrixGenerics",    source="bioc"),
  list(pkg="DelayedArray",      source="bioc"),
  list(pkg="BiocParallel",      source="bioc")
)

PKG_PLAN_ADVANCED_ANALYSIS <- list(
  list(pkg="NMF",               source="cran"),
  list(pkg="VGAM",              source="cran"),
  list(pkg="DDRTree",           source="bioc"),
  list(pkg="matrixStats",       source="cran"),
  list(pkg="enrichR",           source="cran"),
  list(pkg="reshape2",          source="cran"),
  list(pkg="scTenifoldKnk",     source="cran"),
  list(pkg="monocle",           source="bioc"),
  list(pkg="monocle3",          source="bioc"),
  list(pkg="AUCell",            source="bioc"),
  list(pkg="RcisTarget",        source="bioc"),
  list(pkg="GENIE3",            source="bioc"),
  list(pkg="ComplexHeatmap",    source="bioc"),
  list(pkg="CellChat",          source="github", ref=.annotation_github_ref("CellChat")),
  list(pkg="nichenetr",         source="github", ref=.annotation_github_ref("nichenetr")),
  list(pkg="NICHES",            source="github", ref=.annotation_github_ref("NICHES")),
  list(pkg="SCENIC",            source="github", ref="aertslab/SCENIC")
)

PKG_PLAN_ACCELERATORS <- list(
  list(pkg="presto",            source="github", ref=.annotation_github_ref("presto"))
)

# Hidden/test-only dependencies for pre-release pages.
PKG_PLAN_HIDDEN_TEST <- list(
  list(pkg="SoupX",             source="cran"),
  list(pkg="celda",             source="bioc"),
  list(
    pkg = "ggmagnify",
    source = "universe",
    universe = "hughjonesd",
    cran_repos = c(CRAN = "https://cloud.r-project.org")
  )
)

## 5) Install core packages now
.progress_update(5, "Installing core packages")
.show_long_bootstrap_notice(stage = "Core bootstrap")
message("--- Checking/Installing core UI & analysis packages ---")
tm_core_pkgs <- .step_start("Core package bootstrap")
.core_pkg_ready <- function(row) {
  pkg <- as.character(row$pkg %||% "")
  src <- tolower(as.character(row$source %||% ""))
  if (!nzchar(pkg) || !isTRUE(.pkg_in_core(pkg))) return(FALSE)
  # For user-facing/runtime-critical packages, enforce namespace loadability,
  # not only package-folder presence.
  if (src %in% c("cran", "github", "universe")) {
    return(isTRUE(tryCatch(requireNamespace(pkg, quietly = TRUE, lib.loc = CORE_LIB_PATH), error = function(e) FALSE)))
  }
  TRUE
}
plan_missing <- !vapply(PKG_PLAN_CORE, .core_pkg_ready, logical(1))
PKG_PLAN_MISSING <- PKG_PLAN_CORE[plan_missing]
if (!length(PKG_PLAN_MISSING)) {
  message("All planned core packages already available; skipping installs.")
} else {
  message("Missing packages to install/check: ", length(PKG_PLAN_MISSING))
}
tryCatch(
  .ensure_many(PKG_PLAN_MISSING),
  error = function(e) {
    message("Core package bootstrap reported an error: ", conditionMessage(e))
    FALSE
  }
)
missing_after_bootstrap <- !vapply(PKG_PLAN_CORE, .core_pkg_ready, logical(1))
if (any(missing_after_bootstrap)) {
  missing_pkgs <- unique(vapply(PKG_PLAN_CORE[missing_after_bootstrap], function(row) row$pkg, character(1)))
  stop(
    "Bootstrap package readiness failed before app start. Missing package(s): ",
    paste(missing_pkgs, collapse = ", "),
    "."
  )
}
.step_end(tm_core_pkgs)
message("--- Package bootstrap done ---")
.progress_update(45, "Core package bootstrap complete")

if (isTRUE(TEST_VERSION)) {
  message("--- TEST_VERSION enabled: checking hidden-page test dependencies ---")
  hidden_missing <- !vapply(PKG_PLAN_HIDDEN_TEST, function(row) .pkg_in_core(row$pkg), logical(1))
  PKG_PLAN_HIDDEN_MISSING <- PKG_PLAN_HIDDEN_TEST[hidden_missing]
  if (length(PKG_PLAN_HIDDEN_MISSING)) {
    tryCatch(
      .ensure_many(PKG_PLAN_HIDDEN_MISSING),
      error = function(e) {
        message("[TEST_VERSION] Hidden dependency bootstrap warning: ", conditionMessage(e))
      }
    )
  }
  hidden_still_missing <- !vapply(PKG_PLAN_HIDDEN_TEST, function(row) .pkg_in_core(row$pkg), logical(1))
  if (any(hidden_still_missing)) {
    hidden_missing_pkgs <- unique(vapply(PKG_PLAN_HIDDEN_TEST[hidden_still_missing], function(row) row$pkg, character(1)))
    stop(
      "[TEST_VERSION] Hidden dependency bootstrap failed. Missing hidden package(s): ",
      paste(hidden_missing_pkgs, collapse = ", "),
      ". Rerun run.R after restoring network/package install readiness."
    )
  }
}

advanced_bootstrap_prepared_seurat <- FALSE
advanced_bundle_installed <- FALSE

if (isTRUE(.advanced_requested)) {
  tm_adv_pkgs <- .step_start("Advanced analysis package bootstrap")
  advanced_missing <- !vapply(PKG_PLAN_ADVANCED_ANALYSIS, function(row) .pkg_in_core(row$pkg), logical(1))
  PKG_PLAN_ADVANCED_MISSING <- PKG_PLAN_ADVANCED_ANALYSIS[advanced_missing]
  advanced_seurat_paths <- .prepare_advanced_analysis_bootstrap_context(PKG_PLAN_ADVANCED_MISSING)
  advanced_bootstrap_prepared_seurat <- length(PKG_PLAN_ADVANCED_MISSING) > 0L
  SEURAT_V4_LIB_PATH <- advanced_seurat_paths$v4
  SEURAT_V5_LIB_PATH <- advanced_seurat_paths$v5
  if (!length(PKG_PLAN_ADVANCED_MISSING)) {
    message("Advanced package marker enabled and all advanced packages are already available.")
  } else {
    .progress_update(47, "Installing advanced analysis packages")
    message("--- Installing advanced analysis packages (requested) ---")
    message("Missing advanced analysis packages to install/check: ", length(PKG_PLAN_ADVANCED_MISSING))
  }
  tryCatch(
    .install_missing_advanced_analysis_pkgs(PKG_PLAN_ADVANCED_MISSING),
    error = function(e) {
      stop("Advanced analysis package bootstrap failed: ", conditionMessage(e))
    }
  )
  missing_after_advanced <- vapply(PKG_PLAN_ADVANCED_ANALYSIS, function(row) !isTRUE(.pkg_in_core(row$pkg)), logical(1))
  if (any(missing_after_advanced)) {
    missing_adv <- unique(vapply(PKG_PLAN_ADVANCED_ANALYSIS[missing_after_advanced], function(row) row$pkg, character(1)))
    stop(
      "Advanced analysis bundle was requested but package(s) are still missing: ",
      paste(missing_adv, collapse = ", "),
      "."
    )
  }
  tryCatch({
    .ensure_monocle2_compat(lib = CORE_LIB_PATH)
  }, error = function(e) {
    stop("Advanced analysis bootstrap failed in Monocle2 compatibility stage: ", conditionMessage(e))
  })
  .write_marker(.advanced_enabled_marker, value = paste("installed_at:", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")))
  .clear_marker(.advanced_request_marker)
  advanced_bundle_installed <- TRUE
  .step_end(tm_adv_pkgs)
  .progress_update(50, "Advanced analysis packages ready")
} else {
  message("--- Advanced analysis bundle is disabled for this launch; core startup only. ---")
  .progress_update(50, "Advanced analysis bundle deferred")
}

# Optional accelerators (best-effort; never block app startup).
acc_missing <- !vapply(PKG_PLAN_ACCELERATORS, function(row) .pkg_in_core(row$pkg), logical(1))
PKG_PLAN_ACCEL_MISSING <- PKG_PLAN_ACCELERATORS[acc_missing]
if (length(PKG_PLAN_ACCEL_MISSING)) {
  message("--- Installing optional accelerators (best effort) ---")
  tryCatch({
    .ensure_many(PKG_PLAN_ACCEL_MISSING)
  }, error = function(e) {
    message("Optional accelerator bootstrap warning: ", conditionMessage(e))
  })
  still_missing_acc <- vapply(PKG_PLAN_ACCELERATORS, function(row) !isTRUE(.pkg_in_core(row$pkg)), logical(1))
  if (any(still_missing_acc)) {
    missing_acc <- unique(vapply(PKG_PLAN_ACCELERATORS[still_missing_acc], function(row) row$pkg, character(1)))
    message("Optional accelerators not ready: ", paste(missing_acc, collapse = ", "))
  } else {
    message("Optional accelerators ready.")
  }
}
# Hard gate: ensure app-critical packages exist before launching Shiny.
APP_CRITICAL_PKGS <- c("shiny", "shinyjs", "bslib", "shinybusy", "shinycssloaders", "DT", "plotly", "shinyWidgets", "sortable", "shinyFiles", "rhandsontable", "colourpicker", "patchwork", "scales", "RColorBrewer")
critical_failures <- character(0)
for (pkg in APP_CRITICAL_PKGS) {
  if (!.pkg_in_core(pkg)) {
    message("Critical package missing after bootstrap: ", pkg, " (retrying once)")
    ok <- tryCatch({
      .ensure_pkg(pkg, source = "cran", cran_repos = c(CRAN = "https://cloud.r-project.org"))
      isTRUE(.pkg_in_core(pkg))
    }, error = function(e) {
      message("Critical package install error for ", pkg, ": ", conditionMessage(e))
      FALSE
    })
    if (!isTRUE(ok)) critical_failures <- c(critical_failures, pkg)
  }
}
missing_critical <- APP_CRITICAL_PKGS[!vapply(APP_CRITICAL_PKGS, .pkg_in_core, logical(1))]
missing_critical <- unique(c(missing_critical, critical_failures))
if (length(missing_critical)) {
  stop("Critical app packages missing from core library: ", paste(missing_critical, collapse = ", "), ". Check install warnings above (network/toolchain/permissions).")
}
.progress_update(58, "Critical startup packages verified")

## 6) Optional: confirm availability of scDblFinder early
if (!.pkg_in_core("scDblFinder")) {
  message("scDblFinder missing after package plan; retrying from Bioconductor...")
  tryCatch({
    .sync_bioc_release()
    if (!requireNamespace("BiocManager", quietly = TRUE, lib.loc = CORE_LIB_PATH)) {
      .install_cran("BiocManager", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
    }
    .install_bioc_adaptive("scDblFinder", lib = CORE_LIB_PATH, dependencies = .bootstrap_deps)
    .reinstall_bioc_force_if_needed("scDblFinder", lib = CORE_LIB_PATH, dependencies = .bootstrap_deps)
  }, error = function(e) {
    message("Retry install for scDblFinder failed: ", conditionMessage(e))
  })
}
if (!.pkg_in_core("scDblFinder")) {
  message("NOTE: scDblFinder is unavailable. Doublet Finder needs scDblFinder plus SingleCellExperiment in core library.")
}
.progress_update(65, "Doublet dependencies checked")

## 6a) Ensure annotation dependencies for SingleR workflow
if (!.pkg_in_core("SingleR")) {
  message("SingleR missing after package plan; retrying from Bioconductor...")
  tryCatch({
    .sync_bioc_release()
    if (!requireNamespace("BiocManager", quietly = TRUE, lib.loc = CORE_LIB_PATH)) {
      .install_cran("BiocManager", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = NA)
    }
    .install_bioc_adaptive("SingleR", lib = CORE_LIB_PATH, dependencies = .bootstrap_deps)
    .reinstall_bioc_force_if_needed("SingleR", lib = CORE_LIB_PATH, dependencies = .bootstrap_deps)
  }, error = function(e) {
    message("Retry install for SingleR failed: ", conditionMessage(e))
  })
}
if (!.pkg_in_core("celldex")) {
  message("celldex missing after package plan; retrying from GitHub URL...")
  tryCatch({
    .install_annotation_github_fallback("celldex", lib = CORE_LIB_PATH)
  }, error = function(e) {
    message("Retry install for celldex failed: ", conditionMessage(e))
  })
}
missing_anno <- c("SingleR", "celldex")[!vapply(c("SingleR", "celldex"), .pkg_in_core, logical(1))]
missing_github_anno <- intersect(missing_anno, "celldex")
if (length(missing_github_anno)) {
  message(
    "Annotation package(s) still missing after initial retries (",
    paste(missing_github_anno, collapse = ", "),
    "); retrying GitHub with force=TRUE."
  )
  tryCatch({
    for (pkg in missing_github_anno) {
      ref <- .annotation_github_ref(pkg)
      if (!is.na(ref) && nzchar(ref)) {
        .install_ref(
          ref = ref,
          lib = CORE_LIB_PATH,
          dependencies = .bootstrap_deps,
          upgrade = "never",
          force = TRUE,
          build = FALSE,
          label = sprintf("%s (GitHub forced retry)", pkg),
          verify_pkg = pkg
        )
      }
    }
  }, error = function(e) {
    message("GitHub fallback for annotation packages failed: ", conditionMessage(e))
  })
  missing_anno <- c("SingleR", "celldex")[!vapply(c("SingleR", "celldex"), .pkg_in_core, logical(1))]
}
if (length(missing_anno)) {
  stop(
    "Annotation dependencies missing after bootstrap: ",
    paste(missing_anno, collapse = ", "),
    ". This launcher requires these packages in core library before app startup."
  )
}
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  message("jsonlite missing after package plan; retrying from CRAN...")
  tryCatch({
    .install_cran("jsonlite", repos = "https://cloud.r-project.org", lib = CORE_LIB_PATH, dependencies = .bootstrap_deps)
  }, error = function(e) {
    message("Retry install for jsonlite failed: ", conditionMessage(e))
  })
}
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("jsonlite is missing after bootstrap. Layer registry/provenance depends on jsonlite.")
}
.progress_update(67, "Annotation dependencies checked")

## 6b) loupeR policy (isolated env only; never core)
.progress_update(68, "Checking loupeR export dependency")
if (isTRUE(.bootstrap_install_louper)) {
  message(
    "--- loupeR auto-install is enabled and scoped to isolated Seurat environments ",
    "(seurat_v4/seurat_v5); core library will not be used. ---"
  )
} else {
  message("--- loupeR auto-install disabled by WANLAB_BOOTSTRAP_INSTALL_LOUPER=0. ---")
}

## 7) Prepare Seurat v4/v5 isolated environments -------------------------
.progress_update(70, "Preparing Seurat v4/v5")
message("--- Ensuring isolated Seurat environments (v4 + v5) ---")
SEURAT_V4_LIB_PATH <- file.path(ENV_PATH_BASE, "seurat_v4")
SEURAT_V5_LIB_PATH <- file.path(ENV_PATH_BASE, "seurat_v5")
if (!dir.exists(SEURAT_V4_LIB_PATH)) dir.create(SEURAT_V4_LIB_PATH, recursive = TRUE, showWarnings = FALSE)
if (!dir.exists(SEURAT_V5_LIB_PATH)) dir.create(SEURAT_V5_LIB_PATH, recursive = TRUE, showWarnings = FALSE)

# Default to eager Seurat bootstrap so required packages are ready before app launch.
# Set WANLAB_EAGER_SEURAT_BOOTSTRAP=0 to opt into lazy environment bootstrap.
lazy_seurat_bootstrap <- identical(Sys.getenv("WANLAB_EAGER_SEURAT_BOOTSTRAP", "1"), "0")
if (!lazy_seurat_bootstrap) {
  tm_seu4 <- .step_start("Seurat v4 environment")
  SEURAT_V4_LIB_PATH <- tryCatch(setup_seurat_v4(), error = function(e) {
    warning("Seurat v4 bootstrap deferred after startup error: ", conditionMessage(e))
    SEURAT_V4_LIB_PATH
  })
  .step_end(tm_seu4)
  tm_seu5 <- .step_start("Seurat v5 environment")
  SEURAT_V5_LIB_PATH <- tryCatch(setup_seurat_v5(), error = function(e) {
    warning("Seurat v5 bootstrap deferred after startup error: ", conditionMessage(e))
    SEURAT_V5_LIB_PATH
  })
  .step_end(tm_seu5)
  try(.purge_core_seurat_stack(verbose = FALSE), silent = TRUE)
} else if (isTRUE(advanced_bootstrap_prepared_seurat)) {
  message("Mandatory advanced analysis bootstrap already prepared Seurat v4/v5 environments.")
} else {
  message("Lazy Seurat bootstrap enabled by WANLAB_EAGER_SEURAT_BOOTSTRAP=0: deferring Seurat v4/v5 environment builds until needed.")
}
message("Seurat v4 library: ", SEURAT_V4_LIB_PATH)
.progress_update(82, "Seurat v4 ready")
message("Seurat v5 library: ", SEURAT_V5_LIB_PATH)
.progress_update(90, "Seurat v5 ready")

.ensure_louper_if_env_ready <- function(env_label, lib_path) {
  seurat_v <- .pkg_version_in_lib("Seurat", lib_path)
  if (is.na(seurat_v) || !nzchar(seurat_v)) {
    message("loupeR deferred for ", env_label, ": Seurat is not installed in ", lib_path)
    return(invisible(FALSE))
  }
  ok <- .ensure_louper_in_env(lib_path)
  if (!isTRUE(ok)) {
    message("NOTE: loupeR is not ready in ", env_label, " (", lib_path, "); export workflow may retry on demand.")
  }
  invisible(isTRUE(ok))
}

if (isTRUE(.bootstrap_install_louper)) {
  .progress_update(92, "Ensuring loupeR in isolated envs")
  message("--- Ensuring loupeR in isolated Seurat environments ---")
  .ensure_louper_if_env_ready("seurat_v4", SEURAT_V4_LIB_PATH)
  .ensure_louper_if_env_ready("seurat_v5", SEURAT_V5_LIB_PATH)
}

.progress_update(93, "Bootstrapping Python envs")
tryCatch({
  .bootstrap_python_envs()
}, error = function(e) {
  message("Python bootstrap warning: ", conditionMessage(e))
})

# Write a status file so users can verify bootstrap output path/version quickly.
try({
  status_file <- file.path(ENV_PATH_BASE, "bootstrap_status.txt")
  writeLines(
    c(
      paste("timestamp:", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
      paste("env_root:", ENV_PATH_BASE),
      paste("core_lib:", CORE_LIB_PATH),
      paste("seurat_v4_lib:", SEURAT_V4_LIB_PATH),
      paste("seurat_v5_lib:", SEURAT_V5_LIB_PATH),
      paste("python_env_root:", python_env_root),
      paste("python_pyscenic_env:", file.path(python_env_root, "pyscenic")),
      paste("advanced_requested:", isTRUE(.advanced_requested)),
      paste("advanced_request_marker:", .advanced_request_marker),
      paste("advanced_enabled_marker:", .advanced_enabled_marker),
      paste("advanced_bundle_installed_this_run:", isTRUE(advanced_bundle_installed)),
      paste("advanced_bundle_enabled:", file.exists(.advanced_enabled_marker)),
      paste("seurat_v4_version:", as.character(packageVersion("Seurat", lib.loc = SEURAT_V4_LIB_PATH))),
      paste("seurat_v5_version:", as.character(packageVersion("Seurat", lib.loc = SEURAT_V5_LIB_PATH)))
    ),
    con = status_file
  )
  Sys.setenv(WANLAB_BOOTSTRAP_STATUS_FILE = status_file)
  message("Bootstrap status: ", status_file)
.progress_update(95, "Bootstrap status written")
}, silent = TRUE)

## 8) Launch the app -----------------------------------------------------
if (identical(Sys.getenv("WANLAB_BOOTSTRAP_ONLY"), "1")) {
  .progress_update(100, "Bootstrap-only complete")
  .progress_state$monitor_logs <- c(.progress_state$monitor_logs, "Bootstrap-only mode finished successfully.")
  .monitor_write_page(mode = "completed_wait_click")
  message("Bootstrap-only mode enabled. Skipping shiny::runApp().")
  quit(save = "no", status = 0)
}

.libPaths(c(CORE_LIB_PATH, sys_libs))
.progress_update(100, "Launching Shiny app")
.progress_state$monitor_logs <- c(.progress_state$monitor_logs, "Bootstrap complete. Launching the app now.")
.monitor_write_page(mode = "completed_wait_click")
total_bootstrap_sec <- proc.time()[["elapsed"]] - .progress_state$t0
message(sprintf("[TIMER] Total bootstrap time: %.2fs", total_bootstrap_sec))
message("Starting the application... Your web browser should open shortly.")

# Preflight parse check to surface exact file/line for syntax or encoding issues
# in shipped/copied installs (instead of a generic "unexpected end of input").
.preflight_parse_check <- function(root = ".", skip = FALSE) {
  if (isTRUE(skip)) return(invisible(TRUE))
  r_files <- list.files(root, pattern = "[.]R$", recursive = TRUE, full.names = TRUE)
  if (!length(r_files)) return(invisible(TRUE))
  bad <- list()
  for (f in r_files) {
    err <- NULL
    tryCatch(parse(file = f), error = function(e) err <<- conditionMessage(e))
    if (!is.null(err)) bad[[length(bad) + 1L]] <- list(file = f, error = err)
  }
  if (!length(bad)) return(invisible(TRUE))
  message("Preflight parse check failed for ", length(bad), " file(s).")
  for (i in seq_len(min(10L, length(bad)))) {
    rel <- sub(paste0("^", normalizePath(root, winslash = "/", mustWork = FALSE), "/?"), "", normalizePath(bad[[i]]$file, winslash = "/", mustWork = FALSE))
    message(sprintf("  [%d] %s :: %s", i, rel, bad[[i]]$error))
  }
  stop("Startup blocked by R syntax/encoding errors in app files.")
}

tryCatch({
  .preflight_parse_check(
    root = ".",
    skip = identical(Sys.getenv("WANLAB_SKIP_PREFLIGHT_PARSE", "0"), "1")
  )
}, error = function(e) {
  stop(conditionMessage(e))
})

tryCatch({
  .shiny_host <- trimws(Sys.getenv("WANLAB_SHINY_HOST", "127.0.0.1"))
  if (!nzchar(.shiny_host)) {
    stop("WANLAB_SHINY_HOST must not be empty.")
  }
  .preferred_shiny_ports <- c(8817L, 8816L, 8815L, 8814L, 8813L)
  .env_port <- suppressWarnings(as.integer(Sys.getenv("WANLAB_SHINY_PORT", "")))
  if (is.finite(.env_port) && !is.na(.env_port) && .env_port > 0L) {
    .preferred_shiny_ports <- unique(c(.env_port, .preferred_shiny_ports))
  }
  .random_port <- tryCatch(
    if (requireNamespace("httpuv", quietly = TRUE)) as.integer(httpuv::randomPort()) else NA_integer_,
    error = function(e) NA_integer_
  )
  .candidate_ports <- unique(c(.preferred_shiny_ports, .random_port))
  .candidate_ports <- .candidate_ports[is.finite(.candidate_ports) & !is.na(.candidate_ports) & .candidate_ports > 0L]
  .port_available <- function(host, port) {
    # Agent note: Probe with httpuv on the exact Shiny bind host. base::serverSocket()
    # can bind a different address family and falsely report an occupied IPv4 port free.
    probe <- tryCatch(
      httpuv::startServer(
        host = host,
        port = as.integer(port),
        app = list(call = function(req) list(status = 204L, headers = list(), body = ""))
      ),
      error = function(e) NULL
    )
    if (is.null(probe)) return(FALSE)
    try(probe$stop(), silent = TRUE)
    TRUE
  }
  .selected_port <- NA_integer_
  for (.candidate_port in .candidate_ports) {
    message(sprintf("Checking Shiny app bind: %s:%d", .shiny_host, .candidate_port))
    if (isTRUE(.port_available(.shiny_host, .candidate_port))) {
      .selected_port <- as.integer(.candidate_port)
      break
    }
    message(sprintf("Port %d is occupied on %s; trying next fallback.", .candidate_port, .shiny_host))
  }
  if (!is.finite(.selected_port) || is.na(.selected_port) || .selected_port <= 0L) {
    stop("Unable to find an available Shiny app port.")
  }
  .browser_host <- if (identical(.shiny_host, "0.0.0.0")) "127.0.0.1" else .shiny_host
  .launch_url <- sprintf("http://%s:%d", .browser_host, .selected_port)
  message(sprintf("Shiny bind address: %s:%d", .shiny_host, .selected_port))
  message(sprintf("Shiny app running at: %s", .launch_url))
  .launch_browser <- function(url) {
    browseURL(.launch_url)
  }
  shiny::runApp(appDir = ".", host = .shiny_host, port = .selected_port, launch.browser = .launch_browser)
}, error = function(e) {
  message("\n======================= FATAL ERROR ========================")
  message("The application failed to start. The specific error was:")
  message(conditionMessage(e))
  message("\nTraceback (most recent calls):")
  tryCatch(traceback(20), error = function(.e) message("Traceback unavailable: ", conditionMessage(.e)))
  message("\n==========================================================")
  message("Please review the error above (likely in app.R or sourced modules).")
})
