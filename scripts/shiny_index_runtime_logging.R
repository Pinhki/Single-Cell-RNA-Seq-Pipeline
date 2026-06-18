# Local structured runtime logging helpers for the project index SQLite backend.
# Source this file from Shiny code only where runtime instrumentation is wanted.

shiny_index_runtime_db_path <- function(repo_root = getwd()) {
  file.path(normalizePath(repo_root, mustWork = TRUE), "docs", "project-index", "project_index.sqlite")
}

shiny_index_sql_quote <- function(x) {
  if (is.null(x) || length(x) == 0 || is.na(x)) return("NULL")
  paste0("'", gsub("'", "''", as.character(x), fixed = TRUE), "'")
}

shiny_index_sql_value <- function(x) {
  if (is.null(x) || length(x) == 0 || is.na(x)) return("NULL")
  if (is.numeric(x) || is.integer(x)) return(as.character(x[[1]]))
  shiny_index_sql_quote(x[[1]])
}

shiny_index_now <- function() {
  format(Sys.time(), "%Y-%m-%d %H:%M:%S")
}

shiny_index_trace_id <- function(prefix = "trace") {
  paste(prefix, format(Sys.time(), "%Y%m%d%H%M%OS3"), sprintf("%06d", sample.int(999999L, 1L)), sep = "-")
}

shiny_index_payload_json <- function(payload = NULL, max_chars = 1200L) {
  if (is.null(payload)) return(NA_character_)
  safe <- tryCatch({
    txt <- paste(capture.output(str(payload, max.level = 2L, give.attr = FALSE)), collapse = "\\n")
    if (nchar(txt) > max_chars) paste0(substr(txt, 1L, max_chars), "\\n...")
    else txt
  }, error = function(e) paste("payload_summary_error:", conditionMessage(e)))
  safe
}

shiny_index_exec_sql <- function(sql, repo_root = getwd()) {
  sqlite_bin <- Sys.which("sqlite3")
  if (!nzchar(sqlite_bin)) stop("sqlite3 CLI was not found.", call. = FALSE)
  db_path <- shiny_index_runtime_db_path(repo_root)
  sql_file <- tempfile(fileext = ".sql")
  writeLines(sql, sql_file, useBytes = TRUE)
  out <- system2(sqlite_bin, db_path, stdin = sql_file, stdout = TRUE, stderr = TRUE)
  status <- attr(out, "status")
  if (!is.null(status) && status != 0) stop(paste(out, collapse = "\n"), call. = FALSE)
  invisible(out)
}

shiny_index_init_runtime_db <- function(repo_root = getwd()) {
  sql <- "
CREATE TABLE IF NOT EXISTS runtime_sessions (session_id TEXT PRIMARY KEY, user_id_hash TEXT, started_at TEXT, ended_at TEXT, app_version TEXT, git_commit TEXT, environment TEXT);
CREATE TABLE IF NOT EXISTS runtime_events (event_id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp TEXT, trace_id TEXT, session_id TEXT, page TEXT, module_id TEXT, function_name TEXT, event_type TEXT, input_id TEXT, output_id TEXT, duration_ms REAL, status TEXT, message TEXT, payload_json TEXT);
CREATE TABLE IF NOT EXISTS runtime_errors (error_id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp TEXT, trace_id TEXT, session_id TEXT, page TEXT, module_id TEXT, function_name TEXT, error_class TEXT, message TEXT, stack_summary TEXT, payload_json TEXT);
CREATE TABLE IF NOT EXISTS function_calls (call_event_id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp TEXT, trace_id TEXT, session_id TEXT, function_name TEXT, file_path TEXT, duration_ms REAL, status TEXT, input_summary TEXT, output_summary TEXT, warning_summary TEXT, error_summary TEXT);
CREATE INDEX IF NOT EXISTS idx_runtime_events_trace ON runtime_events(trace_id);
CREATE INDEX IF NOT EXISTS idx_runtime_errors_trace ON runtime_errors(trace_id);
CREATE INDEX IF NOT EXISTS idx_function_calls_name ON function_calls(function_name);
"
  shiny_index_exec_sql(sql, repo_root)
}

shiny_index_log_event <- function(trace_id = NA_character_, session_id = NA_character_,
                                  page = NA_character_, module_id = NA_character_,
                                  function_name = NA_character_, event_type = NA_character_,
                                  input_id = NA_character_, output_id = NA_character_,
                                  duration_ms = NA_real_, status = "ok",
                                  message = NA_character_, payload = NULL,
                                  repo_root = getwd()) {
  shiny_index_init_runtime_db(repo_root)
  vals <- c(
    shiny_index_sql_value(shiny_index_now()), shiny_index_sql_value(trace_id),
    shiny_index_sql_value(session_id), shiny_index_sql_value(page),
    shiny_index_sql_value(module_id), shiny_index_sql_value(function_name),
    shiny_index_sql_value(event_type), shiny_index_sql_value(input_id),
    shiny_index_sql_value(output_id), shiny_index_sql_value(duration_ms),
    shiny_index_sql_value(status), shiny_index_sql_value(message),
    shiny_index_sql_value(shiny_index_payload_json(payload))
  )
  shiny_index_exec_sql(paste0(
    "INSERT INTO runtime_events (timestamp, trace_id, session_id, page, module_id, function_name, event_type, input_id, output_id, duration_ms, status, message, payload_json) VALUES (",
    paste(vals, collapse = ","), ");"
  ), repo_root)
}

shiny_index_log_error <- function(error, trace_id = NA_character_, session_id = NA_character_,
                                  page = NA_character_, module_id = NA_character_,
                                  function_name = NA_character_, payload = NULL,
                                  repo_root = getwd()) {
  shiny_index_init_runtime_db(repo_root)
  vals <- c(
    shiny_index_sql_value(shiny_index_now()), shiny_index_sql_value(trace_id),
    shiny_index_sql_value(session_id), shiny_index_sql_value(page),
    shiny_index_sql_value(module_id), shiny_index_sql_value(function_name),
    shiny_index_sql_value(class(error)[[1]] %||% "error"),
    shiny_index_sql_value(conditionMessage(error)),
    shiny_index_sql_value(paste(capture.output(traceback(10)), collapse = "\\n")),
    shiny_index_sql_value(shiny_index_payload_json(payload))
  )
  shiny_index_exec_sql(paste0(
    "INSERT INTO runtime_errors (timestamp, trace_id, session_id, page, module_id, function_name, error_class, message, stack_summary, payload_json) VALUES (",
    paste(vals, collapse = ","), ");"
  ), repo_root)
}

shiny_index_log_function_call <- function(trace_id = NA_character_, session_id = NA_character_,
                                          function_name = NA_character_, file_path = NA_character_,
                                          duration_ms = NA_real_, status = "ok",
                                          input_summary = NA_character_, output_summary = NA_character_,
                                          warning_summary = NA_character_, error_summary = NA_character_,
                                          repo_root = getwd()) {
  shiny_index_init_runtime_db(repo_root)
  vals <- c(
    shiny_index_sql_value(shiny_index_now()), shiny_index_sql_value(trace_id),
    shiny_index_sql_value(session_id), shiny_index_sql_value(function_name),
    shiny_index_sql_value(file_path), shiny_index_sql_value(duration_ms),
    shiny_index_sql_value(status), shiny_index_sql_value(input_summary),
    shiny_index_sql_value(output_summary), shiny_index_sql_value(warning_summary),
    shiny_index_sql_value(error_summary)
  )
  shiny_index_exec_sql(paste0(
    "INSERT INTO function_calls (timestamp, trace_id, session_id, function_name, file_path, duration_ms, status, input_summary, output_summary, warning_summary, error_summary) VALUES (",
    paste(vals, collapse = ","), ");"
  ), repo_root)
}

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0 || is.na(x)) y else x
