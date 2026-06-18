`%||%` <- function(a, b) if (is.null(a)) b else a

beta_result_object_controls_ui <- function(id_prefix, title = "Result object") {
  div(
    class = "card p-2",
    tags$strong(title),
    uiOutput(paste0(id_prefix, "_summary_ui")),
    textInput(
      inputId = paste0(id_prefix, "_workspace_name"),
      label = "Workspace object name",
      value = ""
    ),
    uiOutput(paste0(id_prefix, "_add_workspace_ui")),
    uiOutput(paste0(id_prefix, "_write_active_ui")),
    downloadButton(
      outputId = paste0(id_prefix, "_download"),
      label = "Export current object (.rds)",
      class = "btn btn-outline-secondary btn-sm"
    ),
    tags$div(style = "height:6px;"),
    fileInput(
      inputId = paste0(id_prefix, "_import"),
      label = "Import object (.rds)",
      accept = c(".rds")
    ),
    actionButton(
      inputId = paste0(id_prefix, "_use_import"),
      label = "Use Imported Object",
      class = "btn btn-outline-primary btn-sm"
    )
  )
}

beta_result_object_controls_server <- function(
    input,
    output,
    session,
    shared_data,
    id_prefix,
    get_current_object,
    set_current_object = NULL,
    write_metadata_to_active_object = NULL,
    default_workspace_name = "analysis_result") {
  imported_obj <- reactiveVal(NULL)
  imported_label <- reactiveVal("")

  .is_seurat_compatible <- function(x) {
    !is.null(x) && inherits(x, "Seurat")
  }

  .infer_workspace_name <- function() {
    cur <- as.character(input[[paste0(id_prefix, "_workspace_name")]] %||% "")
    if (nzchar(cur)) return(cur)
    paste0(default_workspace_name, "_", format(Sys.time(), "%Y%m%d_%H%M%S"))
  }

  .put_workspace_object <- function(name, obj, stage = "analysis") {
    reg <- tryCatch(shared_data$all_seurat_objects, error = function(e) list()) %||% list()
    old <- reg[[name]]
    meta <- if (is.list(old) && !is.null(old$meta)) old$meta else list()
    meta$stage <- stage
    meta$created <- Sys.time()
    reg[[name]] <- list(obj = obj, prefs = list(), plots = list(), analysis_cache = list(), meta = meta)
    shared_data$all_seurat_objects <- reg
    shared_data$active_object_name <- name
    invisible(name)
  }
  .active_registry_get <- function() {
    reg <- tryCatch(shared_data$all_seurat_objects, error = function(e) list()) %||% list()
    nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
    if (!nzchar(nm) || !(nm %in% names(reg))) return(list(name = "", entry = NULL, obj = NULL, reg = reg))
    ent <- reg[[nm]]
    obj <- if (is.list(ent) && !is.null(ent$obj)) ent$obj else ent
    list(name = nm, entry = ent, obj = obj, reg = reg)
  }
  .active_registry_put <- function(name, obj, old_entry = NULL, reg = NULL) {
    reg2 <- reg %||% (tryCatch(shared_data$all_seurat_objects, error = function(e) list()) %||% list())
    ent <- old_entry
    if (is.list(ent) && !is.null(ent$obj)) {
      ent$obj <- obj
      if (is.null(ent$prefs) || !is.list(ent$prefs)) ent$prefs <- list()
      if (is.null(ent$plots) || !is.list(ent$plots)) ent$plots <- list()
      if (is.null(ent$analysis_cache) || !is.list(ent$analysis_cache)) ent$analysis_cache <- list()
      reg2[[name]] <- ent
    } else {
      reg2[[name]] <- list(
        obj = obj,
        prefs = list(),
        plots = list(),
        analysis_cache = list(),
        meta = list(stage = "analysis", updated = Sys.time())
      )
    }
    shared_data$all_seurat_objects <- reg2
    invisible(TRUE)
  }

  output[[paste0(id_prefix, "_summary_ui")]] <- renderUI({
    cur <- tryCatch(get_current_object(), error = function(e) NULL)
    cur_cls <- if (is.null(cur)) "none" else paste(class(cur), collapse = "/")
    imp <- imported_obj()
    imp_cls <- if (is.null(imp)) "none" else paste(class(imp), collapse = "/")
    imp_tag <- as.character(imported_label() %||% "")

    div(
      class = "small text-muted",
      tags$div(sprintf("Current object class: %s", cur_cls)),
      tags$div(sprintf("Imported object class: %s", imp_cls)),
      if (nzchar(imp_tag)) tags$div(sprintf("Imported from: %s", imp_tag))
    )
  })

  output[[paste0(id_prefix, "_add_workspace_ui")]] <- renderUI({
    cur <- tryCatch(get_current_object(), error = function(e) NULL)
    if (!.is_seurat_compatible(cur)) return(NULL)
    actionButton(
      inputId = paste0(id_prefix, "_add_workspace"),
      label = "Add Current Object To Workspace",
      class = "btn btn-success btn-sm"
    )
  })
  output[[paste0(id_prefix, "_write_active_ui")]] <- renderUI({
    cur <- tryCatch(get_current_object(), error = function(e) NULL)
    if (is.null(cur)) return(NULL)
    actionButton(
      inputId = paste0(id_prefix, "_write_active"),
      label = "Write Key Results To Active Seurat Metadata",
      class = "btn btn-primary btn-sm"
    )
  })

  observeEvent(input[[paste0(id_prefix, "_add_workspace")]], {
    obj <- tryCatch(get_current_object(), error = function(e) NULL)
    validate(need(.is_seurat_compatible(obj), "Current object is not Seurat-compatible."))
    nm <- .infer_workspace_name()
    .put_workspace_object(nm, obj, stage = "analysis")
    showNotification(sprintf("Added Seurat object to workspace: %s", nm), type = "message")
  }, ignoreInit = TRUE)

  output[[paste0(id_prefix, "_download")]] <- downloadHandler(
    filename = function() {
      paste0(default_workspace_name, "_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".rds")
    },
    content = function(file) {
      obj <- tryCatch(get_current_object(), error = function(e) NULL)
      if (is.null(obj)) stop("No current result object available to export.")
      saveRDS(obj, file = file)
    }
  )

  observeEvent(input[[paste0(id_prefix, "_import")]], {
    fi <- input[[paste0(id_prefix, "_import")]]
    req(!is.null(fi), nzchar(fi$datapath %||% ""))
    tryCatch({
      obj <- readRDS(fi$datapath)
      imported_obj(obj)
      imported_label(as.character(fi$name %||% "uploaded_file.rds"))
      showNotification("Imported object loaded. Click 'Use Imported Object' to apply.", type = "message")
    }, error = function(e) {
      showNotification(paste("Import failed:", conditionMessage(e)), type = "error", duration = NULL)
    })
  }, ignoreInit = TRUE)

  observeEvent(input[[paste0(id_prefix, "_use_import")]], {
    obj <- imported_obj()
    validate(need(!is.null(obj), "No imported object is available."))
    if (is.function(set_current_object)) {
      tryCatch({
        set_current_object(obj)
      }, error = function(e) {
        showNotification(paste("Could not apply imported object:", conditionMessage(e)), type = "error", duration = NULL)
      })
    } else {
      showNotification("Imported object loaded. This page does not support live apply.", type = "warning")
    }
  }, ignoreInit = TRUE)

  observeEvent(input[[paste0(id_prefix, "_write_active")]], {
    cur <- tryCatch(get_current_object(), error = function(e) NULL)
    validate(need(!is.null(cur), "No current result object to write back."))
    validate(need(is.function(write_metadata_to_active_object), "This page does not provide metadata write-back mapping yet."))

    st <- .active_registry_get()
    validate(need(nzchar(st$name), "No active workspace object selected."))
    validate(need(!is.null(st$obj) && inherits(st$obj, "Seurat"), "Active workspace object is not Seurat-compatible."))

    out <- tryCatch(
      write_metadata_to_active_object(cur, st$obj),
      error = function(e) stop("Write-back failed: ", conditionMessage(e), call. = FALSE)
    )
    if (is.null(out) || !is.list(out) || is.null(out$obj) || !inherits(out$obj, "Seurat")) {
      stop("Write-back function must return list(obj = <Seurat>, added_cols = character()).", call. = FALSE)
    }
    .active_registry_put(name = st$name, obj = out$obj, old_entry = st$entry, reg = st$reg)
    added_cols <- as.character(out$added_cols %||% character(0))
    msg <- if (length(added_cols)) {
      sprintf("Wrote metadata to '%s': %s", st$name, paste(added_cols, collapse = ", "))
    } else {
      sprintf("Write-back completed for '%s' (no new columns reported).", st$name)
    }
    showNotification(msg, type = "message")
  }, ignoreInit = TRUE)

  invisible(list(imported_object = reactive(imported_obj())))
}
