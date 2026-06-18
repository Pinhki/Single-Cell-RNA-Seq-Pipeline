`%||%` <- function(a, b) if (is.null(a)) b else a

.admin_hidden_find_run_r <- function() {
  candidates <- c(
    "run.R",
    file.path("Content", "run.R"),
    file.path("..", "run.R")
  )
  existing <- candidates[file.exists(candidates)]
  if (!length(existing)) return("")
  normalizePath(existing[[1]], winslash = "/", mustWork = FALSE)
}

admin_hidden_test_version_state <- function() {
  run_r <- .admin_hidden_find_run_r()
  if (!nzchar(run_r) || !file.exists(run_r)) {
    return(list(ok = FALSE, value = NA, line = NA_integer_, path = run_r, message = "Could not find run.R."))
  }
  lines <- tryCatch(readLines(run_r, warn = FALSE), error = function(e) character(0))
  if (!length(lines)) {
    return(list(ok = FALSE, value = NA, line = NA_integer_, path = run_r, message = "run.R is empty or unreadable."))
  }
  idx <- grep("^\\s*TEST_VERSION\\s*<-\\s*(TRUE|FALSE)\\s*(#.*)?$", lines, perl = TRUE)
  if (!length(idx)) {
    return(list(ok = FALSE, value = NA, line = NA_integer_, path = run_r, message = "TEST_VERSION knob not found in run.R."))
  }
  ln <- idx[[1]]
  line_txt <- lines[[ln]]
  val <- if (grepl("TRUE", line_txt, ignore.case = FALSE)) TRUE else FALSE
  list(ok = TRUE, value = isTRUE(val), line = ln, path = run_r, message = "")
}

admin_hidden_toggle_test_version <- function() {
  st <- admin_hidden_test_version_state()
  if (!isTRUE(st$ok)) {
    return(list(ok = FALSE, path = st$path %||% "", old = NA, new = NA, restart_required = FALSE, message = st$message %||% "Unable to read TEST_VERSION state."))
  }

  run_r <- as.character(st$path %||% "")
  lines <- tryCatch(readLines(run_r, warn = FALSE), error = function(e) character(0))
  if (!length(lines)) {
    return(list(ok = FALSE, path = run_r, old = st$value, new = NA, restart_required = FALSE, message = "run.R is empty or unreadable."))
  }

  old_val <- isTRUE(st$value)
  new_val <- !old_val
  replacement <- paste0("TEST_VERSION <- ", if (isTRUE(new_val)) "TRUE" else "FALSE")
  lines[[st$line]] <- replacement

  ok_write <- tryCatch({
    writeLines(lines, con = run_r, useBytes = TRUE)
    TRUE
  }, error = function(e) FALSE)
  if (!isTRUE(ok_write)) {
    return(list(ok = FALSE, path = run_r, old = old_val, new = old_val, restart_required = FALSE, message = "Failed to update run.R TEST_VERSION line."))
  }

  list(
    ok = TRUE,
    path = run_r,
    old = old_val,
    new = new_val,
    restart_required = TRUE,
    message = sprintf("TEST_VERSION switched to %s in run.R.", if (isTRUE(new_val)) "TRUE" else "FALSE")
  )
}

.admin_hidden_page_defs <- function() {
  defs <- tryCatch(wanlab_admin_gated_pages(), error = function(e) NULL)
  if (is.null(defs) || !is.data.frame(defs) || !nrow(defs)) {
    defs <- data.frame(
      tab = c("rna_velocity_v052_tab", "contam_tab", "figure_studio_pseudobulk_volcano_hidden"),
      label = c("v0.5.2 RNA velocity page", "Hidden contamination page", "Hidden pseudobulk volcano page"),
      button_id = c("admin_open_rna_velocity_v052_btn", "admin_open_contamination_tab_btn", "admin_open_figure_pbv_hidden_tab_btn"),
      icon = c("flask", "shield-virus", "chart-line"),
      class = c("btn btn-outline-primary", "btn btn-outline-warning", "btn btn-outline-secondary"),
      stringsAsFactors = FALSE
    )
  }
  defs
}

admin_hidden_modal_ui <- function(ns, test_mode_state = NULL, presenter_mode_state = FALSE, locked_tabs = character(0)) {
  state_txt <- "Unknown"
  state_cls <- "text-muted"
  if (is.list(test_mode_state) && isTRUE(test_mode_state$ok)) {
    if (isTRUE(test_mode_state$value)) {
      state_txt <- "Enabled (TRUE)"
      state_cls <- "text-success"
    } else {
      state_txt <- "Disabled (FALSE)"
      state_cls <- "text-danger"
    }
  } else if (is.list(test_mode_state)) {
    state_txt <- as.character(test_mode_state$message %||% "Not detected")
    state_cls <- "text-warning"
  }

  defs <- .admin_hidden_page_defs()
  locked_tabs <- unique(as.character(locked_tabs %||% character(0)))
  page_btns <- lapply(seq_len(nrow(defs)), function(i) {
    row <- defs[i, , drop = FALSE]
    tab <- as.character(row$tab %||% "")
    label <- as.character(row$label %||% tab)
    is_locked <- tab %in% locked_tabs
    btn_label <- if (is_locked) paste0("Open & Unlock: ", label) else paste0("Open: ", label)
    div(
      style = "margin-bottom:8px;",
      actionButton(
        ns(as.character(row$button_id)),
        btn_label,
        icon = icon(as.character(row$icon %||% "flask")),
        class = paste(as.character(row$class %||% "btn btn-outline-primary"), "w-100")
      )
    )
  })

  modalDialog(
    title = "Administrator Options",
    easyClose = TRUE,
    size = "l",
    p("Use with caution. These options affect session-level navigation gating."),
    div(
      style = "display:flex; flex-direction:column; gap:8px;",
      actionButton(
        ns("admin_enable_seurat5_btn"),
        "Enable Seurat v5 Selection",
        icon = icon("flask"),
        class = "btn btn-primary"
      ),
      actionButton(
        ns("admin_enable_all_menu_btn"),
        "Enable All Disabled Menu Items",
        icon = icon("unlock"),
        class = "btn btn-warning"
      ),
      tags$hr(),
      tags$strong("Admin-unlock Pages"),
      div(
        style = "display:grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 8px 10px; margin-top:8px;",
        page_btns
      ),
      # Presenter Mode toggle:
      # session-only, no routing side-effects, busy-overlay media swap only.
      # Contract doc: docs/agents/interface/PRESENTER_MODE.md
      actionButton(
        ns("admin_toggle_presenter_mode_btn"),
        sprintf("Presenter Mode: %s", if (isTRUE(presenter_mode_state)) "ON" else "OFF"),
        icon = icon("chalkboard-teacher"),
        class = if (isTRUE(presenter_mode_state)) "btn btn-success" else "btn btn-outline-success"
      ),
      tags$hr(),
      div(
        tags$strong("Dev/Test Mode"),
        tags$div(class = state_cls, paste0("Current TEST_VERSION: ", state_txt)),
        tags$small("Toggle this to switch hidden/testing bootstrap code in run.R. Restart is required.")
      ),
      actionButton(
        ns("admin_toggle_test_version_btn"),
        "Enable / Disable Dev Mode (Toggle TEST_VERSION)",
        icon = icon("code-branch"),
        class = "btn btn-danger"
      )
    ),
    footer = modalButton("Close")
  )
}

admin_hidden_handle_action <- function(action, shared_data) {
  act <- as.character(action %||% "")
  if (!nzchar(act)) return(invisible(FALSE))
  if (identical(act, "enable_seurat5_selection")) {
    shared_data$admin_enable_seurat5 <- TRUE
    return(invisible(TRUE))
  }
  if (identical(act, "enable_all_menu_items")) {
    shared_data$admin_force_enable_all_menus <- TRUE
    shared_data$admin_locked_nav_values <- character(0)
    all_tabs <- tryCatch(wanlab_admin_gated_tabs(), error = function(e) character(0))
    shared_data$admin_unlocked_tabs <- unique(c(as.character(shared_data$admin_unlocked_tabs %||% character(0)), all_tabs))
    return(invisible(TRUE))
  }
  if (grepl("^unlock_tab::", act, perl = TRUE)) {
    tab <- sub("^unlock_tab::", "", act, perl = TRUE)
    tab <- as.character(tab %||% "")
    if (!nzchar(tab)) return(invisible(FALSE))
    locked <- unique(as.character(shared_data$admin_locked_nav_values %||% character(0)))
    shared_data$admin_locked_nav_values <- setdiff(locked, tab)
    unlocked <- unique(as.character(shared_data$admin_unlocked_tabs %||% character(0)))
    shared_data$admin_unlocked_tabs <- unique(c(unlocked, tab))
    return(invisible(TRUE))
  }
  if (identical(act, "toggle_test_version_mode")) {
    return(admin_hidden_toggle_test_version())
  }
  invisible(FALSE)
}
