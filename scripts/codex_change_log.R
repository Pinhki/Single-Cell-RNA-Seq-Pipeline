#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

run_capture <- function(cmd) {
  tryCatch(system(cmd, intern = TRUE, ignore.stderr = TRUE), error = function(e) character())
}

cwd <- normalizePath(getwd(), mustWork = TRUE)
git_root <- run_capture("git rev-parse --show-toplevel")
if (!length(git_root) || !nzchar(git_root[[1]])) {
  stop("Not inside a Git repository. Refusing to write project logs.", call. = FALSE)
}
repo_root <- normalizePath(git_root[[1]], mustWork = TRUE)

if (!identical(cwd, repo_root)) {
  stop(paste0(
    "Project log must be run from repo root.\n",
    "Current directory: ", cwd, "\n",
    "Repo root: ", repo_root, "\n",
    "Run: cd ", repo_root
  ), call. = FALSE)
}

project_id <- basename(repo_root)
project_root <- repo_root

log_db_path <- file.path(repo_root, "docs", "project-index", "codex_change_log.sqlite")
log_md_root <- file.path(repo_root, "docs", "project-index", "change-logs")
sqlite_bin <- Sys.which("sqlite3")

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0 || is.na(x)) y else x

usage <- function() {
  cat("Codex Change Log\n\n")
  cat("Usage:\n")
  cat("  Rscript scripts/codex_change_log.R init\n")
  cat("  Rscript scripts/codex_change_log.R recent [limit]\n")
  cat("  Rscript scripts/codex_change_log.R page <page>\n")
  cat("  Rscript scripts/codex_change_log.R function <function_name>\n")
  cat("  Rscript scripts/codex_change_log.R block <code_block>\n")
  cat("  Rscript scripts/codex_change_log.R file <file_path>\n")
  cat("  Rscript scripts/codex_change_log.R search <term>\n")
  cat("  Rscript scripts/codex_change_log.R add --summary <text> [--page <page>] [--function <name>] [--block <name>] [--file <path>] [--start <line>] [--end <line>] [--why <text>] [--verification <text>] [--tags <text>]\n")
}

if (!nzchar(sqlite_bin)) stop("sqlite3 CLI was not found.", call. = FALSE)

sql_quote <- function(x) {
  if (is.null(x) || length(x) == 0 || is.na(x)) return("NULL")
  paste0("'", gsub("'", "''", as.character(x), fixed = TRUE), "'")
}


project_filter <- paste0("project_root = ", sql_quote(project_root))

and_project <- function(where) {
  paste0("(", where, ") AND ", project_filter)
}

sql_value <- function(x) {
  if (is.null(x) || length(x) == 0 || is.na(x)) return("NULL")
  if (is.numeric(x) || is.integer(x)) return(as.character(x[[1]]))
  sql_quote(x[[1]])
}

slugify <- function(x) {
  x <- ifelse(is.na(x) || !nzchar(x), "uncategorized", x)
  x <- tolower(gsub("[^A-Za-z0-9._-]+", "-", x))
  x <- gsub("-+", "-", x)
  gsub("^-|-$", "", x)
}

append_markdown_log <- function(entry) {
  dir.create(log_md_root, recursive = TRUE, showWarnings = FALSE)
  stamp <- entry$timestamp
  block <- c(
    paste0("## ", stamp, " - ", entry$summary),
    "",
    paste0("- Page: `", entry$page %||% "NA", "`"),
    paste0("- Function: `", entry$function_name %||% "NA", "`"),
    paste0("- Code block: `", entry$code_block %||% "NA", "`"),
    paste0("- File: `", entry$file_path %||% "NA", "`"),
    paste0("- Lines: `", entry$start_line %||% "NA", "-", entry$end_line %||% "NA", "`"),
    paste0("- Type: `", entry$change_type %||% "change", "`"),
    paste0("- Related IDs: `", entry$related_ids %||% "NA", "`"),
    paste0("- Tags: `", entry$tags %||% "NA", "`"),
    "",
    "### Why",
    entry$rationale %||% "NA",
    "",
    "### Verification",
    entry$verification %||% "NA",
    ""
  )
  append_to <- function(path, title) {
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
    if (!file.exists(path)) {
      writeLines(c(paste0("# ", title), "", "Codex change log. Entries are append-only and categorized for future agent reference.", ""), path, useBytes = TRUE)
    }
    cat(paste(block, collapse = "\n"), "\n", file = path, append = TRUE)
  }
  append_to(file.path(log_md_root, "CHANGELOG.md"), "Codex Change Log")
  append_to(file.path(log_md_root, "by-page", paste0(slugify(entry$page), ".md")), paste("Changes by page:", entry$page %||% "uncategorized"))
  append_to(file.path(log_md_root, "by-function", paste0(slugify(entry$function_name), ".md")), paste("Changes by function:", entry$function_name %||% "uncategorized"))
  append_to(file.path(log_md_root, "by-block", paste0(slugify(entry$code_block), ".md")), paste("Changes by code block:", entry$code_block %||% "uncategorized"))
  invisible(TRUE)
}

run_sql <- function(sql, mode = "column") {
  dir.create(dirname(log_db_path), recursive = TRUE, showWarnings = FALSE)
  sql_file <- tempfile(fileext = ".sql")
  writeLines(sql, sql_file, useBytes = TRUE)
  out <- system2(sqlite_bin, c("-header", paste0("-", mode), log_db_path), stdin = sql_file, stdout = TRUE, stderr = TRUE)
  status <- attr(out, "status")
  if (!is.null(status) && status != 0) stop(paste(out, collapse = "\n"), call. = FALSE)
  cat(paste(out, collapse = "\n"))
  if (length(out)) cat("\n")
}

query_sql <- function(sql, mode = "list") {
  sql_file <- tempfile(fileext = ".sql")
  writeLines(sql, sql_file, useBytes = TRUE)
  out <- system2(sqlite_bin, c("-noheader", paste0("-", mode), log_db_path), stdin = sql_file, stdout = TRUE, stderr = TRUE)
  status <- attr(out, "status")
  if (!is.null(status) && status != 0) stop(paste(out, collapse = "\n"), call. = FALSE)
  out
}

init_db <- function() {
  run_sql("
CREATE TABLE IF NOT EXISTS codex_change_logs (
  log_id INTEGER PRIMARY KEY AUTOINCREMENT,
  timestamp TEXT NOT NULL,
  agent TEXT,
  page TEXT,
  function_name TEXT,
  code_block TEXT,
  file_path TEXT,
  start_line INTEGER,
  end_line INTEGER,
  change_type TEXT,
  summary TEXT NOT NULL,
  rationale TEXT,
  verification TEXT,
  related_ids TEXT,
  tags TEXT,
  project_id TEXT,
  project_root TEXT
);
CREATE INDEX IF NOT EXISTS idx_codex_logs_page ON codex_change_logs(page);
CREATE INDEX IF NOT EXISTS idx_codex_logs_function ON codex_change_logs(function_name);
CREATE INDEX IF NOT EXISTS idx_codex_logs_block ON codex_change_logs(code_block);
CREATE INDEX IF NOT EXISTS idx_codex_logs_file ON codex_change_logs(file_path);
CREATE INDEX IF NOT EXISTS idx_codex_logs_timestamp ON codex_change_logs(timestamp);
", mode = "list")

  columns <- query_sql("SELECT name FROM pragma_table_info('codex_change_logs');")
  if (!"project_id" %in% columns) {
    run_sql("ALTER TABLE codex_change_logs ADD COLUMN project_id TEXT;", mode = "list")
  }
  if (!"project_root" %in% columns) {
    run_sql("ALTER TABLE codex_change_logs ADD COLUMN project_root TEXT;", mode = "list")
  }
  run_sql(paste0(
    "UPDATE codex_change_logs SET ",
    "project_id = COALESCE(project_id, ", sql_quote(project_id), "), ",
    "project_root = COALESCE(project_root, ", sql_quote(project_root), ") ",
    "WHERE project_id IS NULL OR project_root IS NULL;"
  ), mode = "list")
}

get_arg <- function(flag, default = NA_character_) {
  hit <- which(args == flag)
  if (!length(hit) || hit[length(hit)] >= length(args)) return(default)
  args[[hit[length(hit)] + 1L]]
}

cmd <- args[[1]] %||% "help"
term <- if (length(args) >= 2) paste(args[-1], collapse = " ") else ""

if (cmd %in% c("help", "-h", "--help")) {
  usage()
} else if (cmd == "init") {
  init_db()
  cat("Codex change log database:", log_db_path, "\n")
} else if (cmd == "add") {
  init_db()
  summary <- get_arg("--summary", "")
  if (!nzchar(summary)) stop("add requires --summary.", call. = FALSE)
  entry <- list(
    timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    agent = "Codex",
    page = get_arg("--page"),
    function_name = get_arg("--function"),
    code_block = get_arg("--block"),
    file_path = get_arg("--file"),
    start_line = suppressWarnings(as.integer(get_arg("--start", NA_character_))),
    end_line = suppressWarnings(as.integer(get_arg("--end", NA_character_))),
    change_type = get_arg("--type", "change"),
    summary = summary,
    rationale = get_arg("--why"),
    verification = get_arg("--verification"),
    related_ids = get_arg("--ids"),
    tags = get_arg("--tags")
  )
  entry$project_id <- project_id
  entry$project_root <- project_root

  vals <- c(
    sql_value(entry$timestamp),
    sql_value(entry$agent),
    sql_value(entry$page),
    sql_value(entry$function_name),
    sql_value(entry$code_block),
    sql_value(entry$file_path),
    sql_value(entry$start_line),
    sql_value(entry$end_line),
    sql_value(entry$change_type),
    sql_value(entry$summary),
    sql_value(entry$rationale),
    sql_value(entry$verification),
    sql_value(entry$related_ids),
    sql_value(entry$tags),
    sql_value(entry$project_id),
    sql_value(entry$project_root)
  )
  run_sql(paste0("
INSERT INTO codex_change_logs
(timestamp, agent, page, function_name, code_block, file_path, start_line, end_line, change_type, summary, rationale, verification, related_ids, tags, project_id, project_root)
VALUES (", paste(vals, collapse = ","), ");
SELECT last_insert_rowid() AS log_id;
"))
  append_markdown_log(entry)
} else if (cmd == "recent") {
  init_db()
  limit <- suppressWarnings(as.integer(ifelse(nzchar(term), term, "25")))
  if (is.na(limit) || limit <= 0) limit <- 25L
  run_sql(paste0("SELECT log_id, timestamp, page, function_name, code_block, file_path, start_line, change_type, summary, verification FROM codex_change_logs WHERE ", project_filter, " ORDER BY timestamp DESC, log_id DESC LIMIT ", limit, ";"))
} else if (cmd %in% c("page", "function", "block", "file", "search")) {
  init_db()
  if (!nzchar(term)) stop(paste(cmd, "requires a term."), call. = FALSE)
  q <- sql_quote(term)
  like <- sql_quote(paste0("%", term, "%"))
  where <- switch(cmd,
    page = paste0("page = ", q),
    "function" = paste0("function_name = ", q),
    block = paste0("code_block = ", q),
    file = paste0("file_path LIKE ", like),
    search = paste0("summary LIKE ", like, " OR rationale LIKE ", like, " OR verification LIKE ", like, " OR tags LIKE ", like, " OR page LIKE ", like, " OR function_name LIKE ", like, " OR code_block LIKE ", like, " OR file_path LIKE ", like)
  )
  run_sql(paste0("SELECT log_id, timestamp, page, function_name, code_block, file_path, start_line, end_line, change_type, summary, rationale, verification, tags FROM codex_change_logs WHERE ", and_project(where), " ORDER BY timestamp DESC, log_id DESC LIMIT 100;"))
} else {
  usage()
  stop(paste("Unknown command:", cmd), call. = FALSE)
}
