library(shiny)
library(bslib)
library(shinyFiles)
library(shinyWidgets)
library(shinyjs)
library(DT)

`%||%` <- function(a, b) if (is.null(a)) b else a

# --- UI Module ---
right_sidebar_ui <- function(id) {
  ns <- NS(id)

  tagList(
    tags$script(HTML("
      (function(){
        if (window.__wanlab_shinyfiles_sort_safe_ready_v4) return;
        window.__wanlab_shinyfiles_sort_safe_ready_v4 = true;
        var STORE_KEY = 'wanlab_shinyfiles_sort_v4';

        function normState(s){
          var col = (s && s.column) ? String(s.column) : 'Created';
          var dir = (s && s.dir) ? String(s.dir) : 'descending';
          if (!/^(Name|Type|Size|Created|Modified)$/.test(col)) col = 'Created';
          if (!(dir === 'ascending' || dir === 'descending')) dir = 'descending';
          return { column: col, dir: dir };
        }
        function loadSortState(){
          try {
            var raw = window.localStorage.getItem(STORE_KEY);
            if (!raw) return { column: 'Created', dir: 'descending' };
            return normState(JSON.parse(raw));
          } catch(e){ return { column: 'Created', dir: 'descending' }; }
        }
        function saveSortState(s){
          try { window.localStorage.setItem(STORE_KEY, JSON.stringify(normState(s))); } catch(e){}
        }
        function applySort(modal, state){
          if (!modal || !modal.length) return;
          var st = normState(state || loadSortState());
          if (modal.data('wanlabSortApplying') === 1) return;
          modal.data('wanlabSortApplying', 1);
          try {
            var btn = modal.data('button');
            if (btn) $(btn).data('sort', st.column).data('sortDir', st.dir);
            modal.trigger('fileSort', [st.column, st.dir]);
          } catch(e) {}
          setTimeout(function(){ modal.data('wanlabSortApplying', 0); }, 20);
        }
        function bindModal(modal){
          if (!modal || !modal.length || modal.data('wanlabSortBound') === 1) return;
          modal.data('wanlabSortBound', 1);
          modal.on('shown.wanlab', function(){ applySort(modal); });
          modal.on('change.wanlab', function(){
            clearTimeout(modal.data('wanlabSortTimer'));
            var t = setTimeout(function(){ applySort(modal); }, 80);
            modal.data('wanlabSortTimer', t);
          });
          modal.on('click.wanlab', '.sF-sort ul li.sortAttr, .sF-sort ul li.sortDir', function(){
            setTimeout(function(){
              var a = (modal.find('.sF-sort ul li.sortAttr.selected a').first().text().trim() || 'Created');
              var d = (modal.find('.sF-sort ul li.sortDir a').first().hasClass('ascending') ? 'ascending' : 'descending');
              saveSortState({ column: a, dir: d });
              applySort(modal, { column: a, dir: d });
            }, 0);
          });
          modal.on('click.wanlab', 'table.files td.name, table.files td.created, table.files td.modified, table.files td.size, table.files td.type', function(){
            clearTimeout(modal.data('wanlabSortTimer2'));
            var t2 = setTimeout(function(){ applySort(modal); }, 60);
            modal.data('wanlabSortTimer2', t2);
          });
          applySort(modal);
        }
        function bindVisibleModals() {
          $('.sF-modalContainer:visible').each(function(){ bindModal($(this)); });
        }

        if (!window.localStorage.getItem(STORE_KEY)) {
          saveSortState({ column: 'Created', dir: 'descending' });
        }

        // Avoid perpetual polling (Safari memory pressure): bind on concrete DOM events.
        bindVisibleModals();
        $(document).on('shown.bs.modal shown.wanlab', '.sF-modalContainer', function() {
          bindModal($(this));
        });

        // Robust delegated handler for sidebar delete buttons inside DT-rendered HTML.
        if (!window.__wanlab_sidebar_remove_bind_v1) {
          window.__wanlab_sidebar_remove_bind_v1 = true;
          document.addEventListener('click', function(ev) {
            var btn = ev.target && ev.target.closest ? ev.target.closest('.sidebar-remove-btn') : null;
            if (!btn) return;
            ev.preventDefault();
            ev.stopPropagation();
            var key = btn.getAttribute('data-remove-key') || '';
            var inputId = btn.getAttribute('data-remove-input') || '';
            if (!key || !inputId || !(window.Shiny && Shiny.setInputValue)) return;
            Shiny.setInputValue(inputId, key, { priority: 'event' });
          }, true);
        }
      })();
    ")),
    div(
      style = "position:absolute; left:-99999px; top:auto; width:1px; height:1px; overflow:hidden; opacity:0;",
      shinyFilesButton(ns("real_h5_file_btn"), "Hidden H5/H5AD", "Select H5/H5AD", multiple = TRUE),
      shinyDirButton(ns("real_matrix_dir_btn"), "Hidden Dir", "Select Dir"),
      shinyFilesButton(ns("real_csv_file_btn"), "Hidden CSV", "Select CSV", multiple = TRUE),
      shinyFilesButton(ns("real_metadata_file_btn"), "Hidden Metadata List", "Select metadata list", multiple = FALSE),
      shinyDirButton(ns("real_metadata_root_btn"), "Hidden Metadata Root", "Select metadata root"),
      shinyFilesButton(ns("real_atac_file_btn"), "Hidden ATAC", "Select ATAC fragment file(s)", multiple = TRUE)
    ),

    div(
      class = "right-sidebar-stack",
      div(
        class = "sidebar-section sidebar-env-section",
        style = "padding-bottom: 10px; border-bottom: 1px solid #ddd; margin-bottom: 10px;",
        div(
          class = "sidebar-env-row",
          div(
            class = "sidebar-env-right",
            tags$span(id = ns("env_admin_label"), class = "sidebar-env-label", "Environment:"),
            uiOutput(ns("env_status_ui"), inline = TRUE)
          )
        )
      ),

      div(
        class = "sidebar-section sidebar-data-section",
        h5("Data Files", style = "margin-top: 0; font-size: 0.9rem; color: #666;"),
        div(
          class = "sidebar-file-actions",
          actionButton(ns("btn_import_modal"), "Import New Data", icon = icon("plus"), class = "btn-primary btn-sm w-100", style = "margin-bottom: 5px;")
        ),
        div(
          class = "sidebar-data-scroll Pinhki-scroll-fade",
          DTOutput(ns("data_registry_table"))
        ),
        div(style = "height:6px"),
        actionButton(ns("btn_edit_metadata"), "Edit Name/Condition/Batch", icon = icon("edit"), class = "btn-outline-secondary btn-sm w-100")
      ),

      div(
        class = "sidebar-bottom-actions",
        uiOutput(ns("workspace_tip_ui")),
        actionButton(ns("btn_save_workspace"), "Save Workspace", icon = icon("save"), class = "btn btn-sm w-100 workspace-btn workspace-btn-disabled"),
        uiOutput(ns("memory_usage_ui"))
      )
    )
  )
}

import_modal_content <- function(ns) {
  htmltools::tagAppendAttributes(
    modalDialog(
    title = "Import Samples",
    size = "l",
    easyClose = FALSE,
    footer = tagList(
      modalButton("Cancel"),
      actionButton(ns("btn_confirm_import"), "Add Samples", class = "btn-success", icon = icon("check"))
    ),

    tags$style(HTML("
      .import-samples-modal .modal-dialog { max-width: 94vw !important; width: 94vw !important; }
      .import-samples-modal .modal-content { background: #ffffff; color: #1f2937; border: 1px solid #dbe3ea; }
      .import-samples-modal .modal-header,
      .import-samples-modal .modal-body,
      .import-samples-modal .modal-footer { background: #ffffff; color: #1f2937; border-color: #e5e7eb; }
      .import-samples-modal .modal-body { padding-top: 0.5rem; }
      .import-samples-modal .form-control,
      .import-samples-modal .form-select,
      .import-samples-modal .selectize-input { background: #ffffff; color: #1f2937; border-color: #d1d5db; }
      .import-samples-modal .help-block,
      .import-samples-modal p,
      .import-samples-modal h4 { color: #1f2937; }
      .import-samples-modal #staged_samples_container { min-height: 260px !important; }
      .import-samples-modal .import-left-col { max-width: 300px; }
      .import-samples-modal .import-yellow-note {
        margin-top: 8px;
        margin-bottom: 12px;
        background: #fff8db;
        border: 1px solid #f2d57a;
        color: #5c4300;
        border-radius: 8px;
        padding: 10px 12px;
        font-size: 12px;
        line-height: 1.35;
      }
    ")),
    div(
      class = "import-yellow-note",
      "Note: Please keep and download the entire Cell Ranger sample/run folder, not only the matrix file.",
      tags$br(),
      "Start at the upper-level folder that contains ",
      tags$code("outs/"),
      " (example: ",
      tags$code("/lab_share/projects/CRC_Study/Run_2026_03/Sample_A01/"),
      ", with ",
      tags$code("/lab_share/projects/CRC_Study/Run_2026_03/Sample_A01/outs/"),
      " inside).",
      tags$br(),
      "Then import ",
      tags$code("filtered_feature_bc_matrix.h5"),
      ", ",
      tags$code("*.h5ad"),
      ", or ",
      tags$code("filtered_feature_bc_matrix/"),
      ".",
      tags$br(),
      "Keeping the full folder lets the pipeline automatically detect supplementary files (such as VDJ annotations) and assign better sample names."
    ),
    fluidRow(
      column(
        2,
        class = "import-left-col",
        h4("Add Files"),
        p("Select files from server storage:"),

        actionButton(ns("proxy_h5_btn"), "Add H5/H5AD File(s)", icon = icon("file-code"), class = "btn-outline-primary btn-sm w-100 mb-2"),
        div(style = "height:5px"),
        actionButton(ns("proxy_dir_btn"), "Add Matrix Folder", icon = icon("folder-open"), class = "btn-outline-primary btn-sm w-100 mb-2"),
        div(style = "height:5px"),
        actionButton(ns("proxy_csv_btn"), "Add CSV File(s)", icon = icon("file-csv"), class = "btn-outline-primary btn-sm w-100 mb-2"),
        div(style = "height:5px"),
        actionButton(ns("proxy_metadata_btn"), "Import Metadata List", icon = icon("table"), class = "btn-outline-primary btn-sm w-100 mb-2"),
        div(style = "height:5px"),
        actionButton(ns("proxy_atac_btn"), "Add ATAC Fragments", icon = icon("project-diagram"), class = "btn-outline-primary btn-sm w-100 mb-2"),
        div(style = "height:5px"),
        actionButton(ns("btn_add_demo"), "Quick Add Demo", icon = icon("flask"), class = "btn-outline-secondary btn-sm w-100"),

        hr()
      ),
      column(
        10,
        h4("Staged Samples"),
        p("Review and edit Name / Condition / Batch before loading:"),
        div(
          id = ns("staged_samples_container"),
          class = "wan-squircle",
          style = "min-height: 220px; border: 1px solid #eee; padding: 10px; border-radius: 4px; background: #f9f9f9;",
          DTOutput(ns("staged_samples_table"))
        ),
        div(style = "height:6px"),
        actionButton(ns("btn_remove_staged_selected"), "Remove Selected Staged Row(s)", icon = icon("trash"), class = "btn-outline-danger btn-sm w-100"),
        div(style = "height:14px"),
        h4("ATAC Fragment Pairing"),
        p("Deterministic token match with newest-file tiebreak. Mark rows ignored when needed."),
        div(
          id = ns("atac_pairing_container"),
          class = "wan-squircle",
          style = "min-height: 170px; border: 1px solid #eee; padding: 10px; border-radius: 4px; background: #f9f9f9;",
          DTOutput(ns("atac_pairing_table"))
        ),
        div(style = "height:6px"),
        actionButton(ns("btn_atac_ignore_selected"), "Mark Selected Pairing Row(s) Ignored", class = "btn-outline-secondary btn-sm w-100")
      )
    )
    ),
    class = "import-samples-modal"
  )
}

metadata_manifest_modal_content <- function(ns, root_path = "") {
  htmltools::tagAppendAttributes(
    modalDialog(
      title = "Import Metadata List",
      size = "l",
      easyClose = FALSE,
      tags$style(HTML("
        .metadata-manifest-modal .modal-dialog {
          width: 98vw !important;
          max-width: 98vw !important;
          margin: 1rem auto !important;
        }
        .metadata-manifest-modal .modal-content { max-height: 92vh; }
        .metadata-manifest-modal .modal-body { overflow-x: auto; overflow-y: auto; }
        .metadata-manifest-modal .manifest-table-wrap {
          width: 100%;
          overflow-x: auto;
          overflow-y: hidden;
          border: 1px solid #e5e7eb;
          border-radius: 6px;
          padding: 6px;
        }
        .metadata-manifest-modal .manifest-table-wrap table.dataTable {
          width: max-content !important;
          min-width: 100% !important;
        }
        .metadata-manifest-modal .manifest-table-wrap table.dataTable th,
        .metadata-manifest-modal .manifest-table-wrap table.dataTable td {
          white-space: nowrap !important;
          min-width: 110px;
        }
        .metadata-manifest-modal table.dataTable tbody tr.manifest-row-invalid td {
          opacity: 0.55;
          background-color: #f7f7f7 !important;
        }
        .metadata-manifest-modal table.dataTable tbody tr.manifest-row-excluded td {
          opacity: 0.55;
          background-color: #f7f7f7 !important;
        }
        .metadata-manifest-modal .manifest-controls {
          display: flex;
          gap: 12px;
          align-items: flex-end;
          margin-bottom: 10px;
        }
        .metadata-manifest-modal .manifest-control-group {
          flex: 1 1 0;
          min-width: 260px;
        }
        .metadata-manifest-modal .manifest-inline-row {
          display: flex;
          align-items: center;
          gap: 8px;
        }
        .metadata-manifest-modal .manifest-inline-row .form-group {
          flex: 1 1 auto;
          margin-bottom: 0 !important;
        }
        .metadata-manifest-modal .manifest-status {
          margin: 6px 0 10px;
          color: #475569;
          font-size: 12px;
          line-height: 1.4;
        }
        @media (max-width: 1200px) {
          .metadata-manifest-modal .manifest-controls { flex-direction: column; align-items: stretch; }
          .metadata-manifest-modal .manifest-control-group { min-width: 0; width: 100%; }
        }
      ")),
      tags$p(
        "Review one row per sample. Choose the input source and cell set per row. Sidecar files are summarized only; their cell rows are not inserted into this table."
      ),
      div(
        class = "manifest-controls",
        div(
          class = "manifest-control-group",
          textInput(ns("metadata_manifest_root_path"), "Root folder for relative paths", value = root_path, width = "100%")
        ),
        div(
          class = "manifest-control-group",
          tags$label("Root folder actions"),
          div(
            class = "manifest-inline-row",
            actionButton(ns("metadata_manifest_apply_root_btn"), "Use Root", class = "btn btn-outline-secondary"),
            actionButton(ns("metadata_manifest_choose_root_btn"), "Choose Folder", class = "btn btn-outline-primary")
          )
        )
      ),
      div(class = "manifest-status", uiOutput(ns("metadata_manifest_status_ui"))),
      div(
        class = "manifest-controls",
        div(
          class = "manifest-control-group",
          tags$label(`for` = ns("metadata_manifest_new_col_name"), "Add metadata column"),
          div(
            class = "manifest-inline-row",
            textInput(ns("metadata_manifest_new_col_name"), NULL, value = "", placeholder = "e.g., cohort, donor_group, platform"),
            actionButton(ns("metadata_manifest_add_col_btn"), "Add Column", class = "btn btn-default")
          )
        ),
        div(
          class = "manifest-control-group",
          tags$label("Remove metadata column"),
          uiOutput(ns("metadata_manifest_remove_col_ui"))
        )
      ),
      div(class = "manifest-table-wrap", DTOutput(ns("metadata_manifest_table"))),
      footer = tagList(
        actionButton(ns("metadata_manifest_remove_rows_btn"), "Remove Selected Rows", class = "btn btn-outline-danger"),
        modalButton("Cancel"),
        actionButton(ns("metadata_manifest_confirm_btn"), "Import Selected", class = "btn btn-success", icon = icon("check"))
      )
    ),
    class = "metadata-manifest-modal"
  )
}

metadata_manifest_conflict_modal_content <- function(ns) {
  htmltools::tagAppendAttributes(
    modalDialog(
      title = "Review Metadata Name Conflicts",
      size = "m",
      easyClose = FALSE,
      tags$p("Some imported metadata names already exist in the target object. Rename or skip each conflicting column. Existing values will not be overwritten."),
      DTOutput(ns("metadata_manifest_conflict_table")),
      footer = tagList(
        actionButton(ns("metadata_manifest_conflict_cancel_btn"), "Return to Metadata List", class = "btn btn-outline-secondary"),
        actionButton(ns("metadata_manifest_conflict_apply_btn"), "Apply Decisions", class = "btn btn-primary")
      )
    ),
    class = "metadata-manifest-conflict-modal"
  )
}

metadata_manifest_result_modal_content <- function(ns) {
  htmltools::tagAppendAttributes(
    modalDialog(
      title = "Batch Import Results",
      size = "l",
      easyClose = FALSE,
      tags$style(HTML("
        .metadata-manifest-result-modal .modal-dialog {
          width: 96vw !important;
          max-width: 96vw !important;
          margin: 1rem auto !important;
        }
        .metadata-manifest-result-modal .modal-content {
          max-height: 92vh;
        }
        .metadata-manifest-result-modal .modal-body {
          overflow-x: auto;
          overflow-y: auto;
        }
        .metadata-manifest-result-modal .metadata-manifest-result-table-wrap {
          width: 100%;
          max-width: 100%;
          overflow-x: auto;
          overflow-y: hidden;
          border: 1px solid #e5e7eb;
          border-radius: 6px;
          padding: 6px;
        }
        .metadata-manifest-result-modal .metadata-manifest-result-table-wrap table.dataTable {
          width: max-content !important;
          min-width: 100% !important;
        }
        .metadata-manifest-result-modal .metadata-manifest-result-table-wrap th,
        .metadata-manifest-result-modal .metadata-manifest-result-table-wrap td {
          white-space: nowrap !important;
          min-width: 110px;
        }
      ")),
      tags$p("Import completed. Review each row before closing this report."),
      div(
        class = "metadata-manifest-result-table-wrap",
        DTOutput(ns("metadata_manifest_result_table"))
      ),
      footer = modalButton("Close")
    ),
    class = "metadata-manifest-result-modal"
  )
}

right_sidebar_server <- function(id, shared_data, parent_session) {
  registry_helper_env <- environment(right_sidebar_server)
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    registry_build_error <- reactiveVal("")
    required_registry_helpers <- c(
      "sidebar_registry_safe_object_row",
      "sidebar_registry_fmt_size",
      "sidebar_registry_fmt_time",
      "sidebar_registry_default_meta_line_html",
      "sidebar_registry_obj_cell_count",
      "sidebar_registry_obj_assay_count",
      "sidebar_registry_obj_sample_count",
      "sidebar_registry_entry_umap_pca_dims"
    )
    missing_registry_helpers <- required_registry_helpers[
      !vapply(
        required_registry_helpers,
        function(helper_name) {
          exists(helper_name, envir = registry_helper_env, mode = "function", inherits = TRUE)
        },
        logical(1)
      )
    ]
    if (length(missing_registry_helpers)) {
      stop(
        "Right-sidebar registry helpers were not loaded: ",
        paste(missing_registry_helpers, collapse = ", ")
      )
    }
    # Agent note: app.R sources right_sidebar_registry_helpers.R before this module.
    # Validate against this function's lexical environment; exists() without envir can
    # inspect Shiny's module call frame and falsely report every loaded helper missing.
    .fmt_size <- sidebar_registry_fmt_size
    .fmt_time <- sidebar_registry_fmt_time
    .meta_line_html <- sidebar_registry_default_meta_line_html
    .obj_cell_count <- sidebar_registry_obj_cell_count
    .obj_assay_count <- sidebar_registry_obj_assay_count
    .obj_sample_count <- sidebar_registry_obj_sample_count
    .entry_umap_pca_dims <- sidebar_registry_entry_umap_pca_dims
    .sidebar_debug <- isTRUE(getOption("wanlab.sidebar_debug", FALSE)) ||
      identical(tolower(Sys.getenv("WANLAB_SIDEBAR_DEBUG", "false")), "true")
    .sidebar_dbg <- function(...) {
      if (!isTRUE(.sidebar_debug)) return(invisible(NULL))
      msg <- paste(..., collapse = " ")
      cat(sprintf("[SIDEBAR][%s] %s\n", format(Sys.time(), "%H:%M:%S"), msg))
      flush.console()
      invisible(NULL)
    }
    admin_file <- file.path("interface", "components", "admin_hidden_panel.R")
    admin_enabled <- FALSE
    if (file.exists(admin_file)) {
      ok <- tryCatch({
        source(admin_file, local = TRUE)
        TRUE
      }, error = function(e) FALSE)
      admin_enabled <- isTRUE(ok) &&
        exists("admin_hidden_modal_ui", mode = "function", inherits = FALSE) &&
        exists("admin_hidden_handle_action", mode = "function", inherits = FALSE)
    }
    .safe_select_cols <- function(df, cols, default = NA) {
      if (is.null(df) || !is.data.frame(df)) return(data.frame(stringsAsFactors = FALSE))
      out <- df
      n <- nrow(out)
      for (cc in cols) {
        if (!(cc %in% colnames(out))) out[[cc]] <- rep(default, n)
      }
      out[, cols, drop = FALSE]
    }
    .coerce_registry_list <- function(x) {
      if (is.null(x)) return(list())
      if (is.list(x)) {
        if (exists("wanlab_canonicalize_registry", mode = "function", inherits = TRUE)) {
          return(tryCatch(wanlab_canonicalize_registry(x, sample_sheet = shared_data$full_sample_sheet), error = function(e) x))
        }
        return(x)
      }
      if (inherits(x, "reactivevalues")) {
        out <- tryCatch(reactiveValuesToList(x), error = function(e) list())
        if (exists("wanlab_canonicalize_registry", mode = "function", inherits = TRUE)) {
          return(tryCatch(wanlab_canonicalize_registry(out, sample_sheet = shared_data$full_sample_sheet), error = function(e) out))
        }
        return(out)
      }
      if (is.environment(x)) {
        out <- tryCatch(as.list(x), error = function(e) list())
        if (exists("wanlab_canonicalize_registry", mode = "function", inherits = TRUE)) {
          return(tryCatch(wanlab_canonicalize_registry(out, sample_sheet = shared_data$full_sample_sheet), error = function(e) out))
        }
        return(out)
      }
      out <- tryCatch(as.list(x), error = function(e) list())
      if (exists("wanlab_canonicalize_registry", mode = "function", inherits = TRUE)) {
        return(tryCatch(wanlab_canonicalize_registry(out, sample_sheet = shared_data$full_sample_sheet), error = function(e) out))
      }
      out
    }
    .vdj_debug <- isTRUE(getOption("wanlab.vdj_debug", FALSE)) ||
      identical(tolower(Sys.getenv("WANLAB_VDJ_DEBUG", "false")), "true")
    .vdj_log <- function(...) {
      if (!isTRUE(.vdj_debug)) return(invisible(NULL))
      msg <- paste(..., collapse = " ")
      cat(sprintf("[VDJ-DEBUG][sidebar][%s] %s\n", format(Sys.time(), "%H:%M:%S"), msg))
      flush.console()
      invisible(NULL)
    }
    .fast_mode_active <- function() {
      identical(as.character(shared_data$workflow_mode %||% "manual"), "fast")
    }
    output$env_status_ui <- renderUI({
      env <- shared_data$active_environment
      if (is.null(env$name)) span(class = "sidebar-env-status status-missing", icon("exclamation-circle"), " No Env Selected")
      else span(class = "sidebar-env-status status-ready", icon("check-circle"), paste0(" ", env$name))
    })
    if (isTRUE(admin_enabled)) {
      session$onFlushed(function() {
        shinyjs::runjs(sprintf(
          "(function(){ var el=document.getElementById('%s'); if(!el||el.dataset.adminBound==='1') return; el.dataset.adminBound='1'; var c=0; var timer=null; el.addEventListener('click', function(){ c++; if(timer) clearTimeout(timer); timer=setTimeout(function(){ c=0; }, 1200); if(c>=5){ c=0; if(window.Shiny){ Shiny.setInputValue('%s', Date.now(), {priority:'event'}); } } }); })();",
          ns("env_admin_label"),
          ns("env_admin_click5")
        ))
      }, once = TRUE)

      observeEvent(input$env_admin_click5, {
        test_mode_state <- tryCatch(admin_hidden_test_version_state(), error = function(e) {
          list(ok = FALSE, value = NA, message = conditionMessage(e))
        })
        locked_tabs <- unique(as.character(shared_data$admin_locked_nav_values %||% character(0)))
        showModal(admin_hidden_modal_ui(
          ns,
          test_mode_state = test_mode_state,
          locked_tabs = locked_tabs
        ))
      }, ignoreInit = TRUE)

      observeEvent(input$admin_enable_all_menu_btn, {
        admin_hidden_handle_action(action = "enable_all_menu_items", shared_data = shared_data)
        removeModal()
        showNotification("Admin: all menu gating disabled for this session.", type = "message")
      }, ignoreInit = TRUE)

      observeEvent(input$admin_enable_seurat5_btn, {
        admin_hidden_handle_action(action = "enable_seurat5_selection", shared_data = shared_data)
        removeModal()
        showNotification("Admin: Seurat v5 selection enabled for this session.", type = "message")
      }, ignoreInit = TRUE)

      page_defs <- tryCatch(.admin_hidden_page_defs(), error = function(e) data.frame())
      if (is.data.frame(page_defs) && nrow(page_defs)) {
        lapply(seq_len(nrow(page_defs)), function(i) {
          row <- page_defs[i, , drop = FALSE]
          btn_id <- as.character(row$button_id %||% "")
          tab_id <- as.character(row$tab %||% "")
          tab_label <- as.character(row$label %||% tab_id)
          if (!nzchar(btn_id) || !nzchar(tab_id)) return(invisible(NULL))

          observeEvent(input[[btn_id]], {
            admin_hidden_handle_action(action = paste0("unlock_tab::", tab_id), shared_data = shared_data)
            removeModal()
            updateNavbarPage(parent_session, inputId = "main_navbar", selected = tab_id)
            showNotification(sprintf("Admin: opened and unlocked '%s' for this session.", tab_label), type = "message")
          }, ignoreInit = TRUE)
          invisible(NULL)
        })
      }

      observeEvent(input$admin_toggle_test_version_btn, {
        res <- tryCatch(
          admin_hidden_handle_action(action = "toggle_test_version_mode", shared_data = shared_data),
          error = function(e) list(ok = FALSE, message = conditionMessage(e), restart_required = FALSE)
        )

        if (is.list(res) && isTRUE(res$ok)) {
          removeModal()
          showModal(modalDialog(
            title = "Restart Required",
            easyClose = FALSE,
            footer = modalButton("Close"),
            tags$p(res$message %||% "TEST_VERSION was updated."),
            tags$p("Please close this pipeline session, then restart and rerun run.R to apply the new dev mode setting."),
            tags$p(tags$strong("Current session will continue using the old mode until restart."))
          ))
        } else {
          msg <- if (is.list(res) && nzchar(as.character(res$message %||% ""))) {
            as.character(res$message)
          } else {
            "Could not toggle TEST_VERSION."
          }
          showNotification(paste("Admin:", msg), type = "error", duration = NULL)
        }
      }, ignoreInit = TRUE)

    }

    output$memory_usage_ui <- renderUI({
      reg <- shared_data$all_seurat_objects %||% list()
      tab <- shared_data$imported_tabular_files

      obj_bytes <- if (!length(reg)) 0 else sum(vapply(reg, function(entry) {
        obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
        as.numeric(utils::object.size(obj))
      }, numeric(1)), na.rm = TRUE)

      tab_bytes <- 0
      if (is.data.frame(tab) && nrow(tab) && "path" %in% names(tab)) {
        fi <- suppressWarnings(file.info(as.character(tab$path)))
        if (NROW(fi)) tab_bytes <- sum(as.numeric(fi$size), na.rm = TRUE)
      }

      total_bytes <- obj_bytes + tab_bytes
      div(
        style = "font-size:11px; color:#64748b; line-height:1.22; margin-top:10px;",
        div(
          style = "display:flex; align-items:center; gap:6px;",
          tags$b(sprintf("Memory in this app session: %s", .fmt_size(total_bytes))),
          tags$span(
            icon("info-circle"),
            title = "R-session memory estimate only. OS/RAM can read higher and may exceed physical RAM (swap/compression, temp copies, cache).",
            style = "cursor:help; color:#7b8798; font-size:11px;"
          )
        ),
        div(sprintf("Seurat objects: %s | Tabular files: %s", .fmt_size(obj_bytes), .fmt_size(tab_bytes)))
      )
    })

    .empty_registry <- function() {
      data.frame(
        name = character(0),
        kind = character(0),
        status = character(0),
        key = character(0),
        size_text = character(0),
        type_text = character(0),
        time_text = character(0),
        display = character(0),
        stringsAsFactors = FALSE
      )
    }
    .fallback_object_registry <- function(reg_objs) {
      nms <- as.character(names(reg_objs %||% list()))
      nms <- nms[!is.na(nms) & nzchar(nms)]
      if (!length(nms)) return(.empty_registry())
      sample_sheet <- shared_data$full_sample_sheet
      sample_path_map <- character(0)
      if (!is.null(sample_sheet) && is.data.frame(sample_sheet) && nrow(sample_sheet) &&
          all(c("name", "path") %in% names(sample_sheet))) {
        sample_path_map <- stats::setNames(as.character(sample_sheet$path), as.character(sample_sheet$name))
      }
      rows <- lapply(nms, function(nm) {
        sidebar_registry_safe_object_row(
          name = nm,
          entry = reg_objs[[nm]],
          sample_path_map = sample_path_map,
          remove_btn_html = .remove_btn_html,
          meta_line_html = .meta_line_html
        )
      })
      do.call(rbind, rows)
    }

    .bind_rows_safe <- function(x, y) {
      if (is.null(x) || !is.data.frame(x)) x <- data.frame(stringsAsFactors = FALSE)
      if (is.null(y) || !is.data.frame(y)) y <- data.frame(stringsAsFactors = FALSE)
      cols <- union(names(x), names(y))
      if (!length(cols)) return(data.frame(stringsAsFactors = FALSE))
      for (nm in setdiff(cols, names(x))) x[[nm]] <- rep(NA, nrow(x))
      for (nm in setdiff(cols, names(y))) y[[nm]] <- rep(NA, nrow(y))
      x <- x[, cols, drop = FALSE]
      y <- y[, cols, drop = FALSE]
      out <- rbind(x, y)
      rownames(out) <- NULL
      out
    }

    .ensure_detected_vdj_rows <- function() invisible(FALSE)

    .attach_vdj_links_to_objects <- function(vdj_df) {
      if (is.null(vdj_df) || !is.data.frame(vdj_df) || !nrow(vdj_df)) return(invisible(FALSE))
      if (!all(c("sample_name", "chain", "file_path") %in% colnames(vdj_df))) return(invisible(FALSE))
      reg <- .coerce_registry_list(shared_data$all_seurat_objects)
      if (!length(reg)) return(invisible(FALSE))
      changed <- FALSE
      for (nm in unique(as.character(vdj_df$sample_name))) {
        if (!nzchar(nm) || is.null(reg[[nm]])) next
        entry <- reg[[nm]]
        if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
          entry <- tryCatch(wanlab_canonicalize_object_entry(entry), error = function(e) entry)
        }
        if (is.null(entry) || !is.list(entry)) next
        if (is.null(entry$meta) || !is.list(entry$meta)) entry$meta <- list()
        if (is.null(entry$meta$linked_files) || !is.list(entry$meta$linked_files)) entry$meta$linked_files <- list()
        cur <- entry$meta$linked_files$vdj
        if (is.null(cur) || !is.data.frame(cur)) cur <- data.frame(chain = character(0), source_name = character(0), stringsAsFactors = FALSE)
        if (!("chain" %in% names(cur))) cur$chain <- character(nrow(cur))
        if (!("source_name" %in% names(cur))) {
          if ("path" %in% names(cur)) {
            cur$source_name <- basename(as.character(cur$path %||% ""))
          } else {
            cur$source_name <- character(nrow(cur))
          }
        }
        cur <- cur[, c("chain", "source_name"), drop = FALSE]
        add <- vdj_df[as.character(vdj_df$sample_name) == nm, c("chain", "file_path"), drop = FALSE]
        add$chain <- toupper(as.character(add$chain %||% ""))
        add$source_name <- basename(as.character(add$file_path %||% ""))
        add <- add[nzchar(add$chain) & nzchar(add$source_name), c("chain", "source_name"), drop = FALSE]
        if (!nrow(add)) next
        merged <- rbind(cur, add)
        merged <- merged[!duplicated(paste0(merged$chain, "::", merged$source_name)), , drop = FALSE]
        rownames(merged) <- NULL
        if (!identical(cur, merged)) {
          entry$meta$linked_files$vdj <- merged
          reg[[nm]] <- entry
          changed <- TRUE
        }
      }
      if (isTRUE(changed)) {
        if (exists("wanlab_canonicalize_registry", mode = "function", inherits = TRUE)) {
          reg <- tryCatch(wanlab_canonicalize_registry(reg, sample_sheet = shared_data$full_sample_sheet), error = function(e) reg)
        }
        shared_data$all_seurat_objects <- reg
      }
      invisible(changed)
    }

    .js_quote <- function(x) {
      out <- as.character(x %||% "")
      out <- gsub("\\\\", "\\\\\\\\", out, perl = TRUE)
      out <- gsub("'", "\\\\'", out, fixed = TRUE)
      out
    }

    .remove_btn_html <- function(key) {
      k <- as.character(key %||% "")
      if (!nzchar(k)) return("")
      input_id <- ns("sidebar_remove_key")
      k_attr <- htmltools::htmlEscape(k, attribute = TRUE)
      id_attr <- htmltools::htmlEscape(input_id, attribute = TRUE)
      sprintf(
        "<button type='button' class='sidebar-remove-btn' title='Remove this item' aria-label='Remove this item' data-remove-key='%s' data-remove-input='%s' onclick=\"event.preventDefault();event.stopPropagation();if(window.Shiny&&Shiny.setInputValue){Shiny.setInputValue('%s','%s',{priority:'event'});}\"><i class='fa fa-trash'></i></button>",
        k_attr, id_attr, input_id, .js_quote(k)
      )
    }

    .file_line_count <- function(path) {
      p <- as.character(path %||% "")
      if (!nzchar(p) || !file.exists(p) || dir.exists(p)) return(NA_real_)
      con <- file(p, open = "r")
      on.exit(try(close(con), silent = TRUE), add = TRUE)
      total <- 0L
      repeat {
        chunk <- readLines(con, n = 50000L, warn = FALSE)
        if (!length(chunk)) break
        total <- total + length(chunk)
      }
      as.numeric(total)
    }

    .entry_vdj_payload <- function(entry, obj) {
      # Primary: workspace entry payload (not Seurat slot).
      if (is.list(entry) && is.list(entry$vdj_payload)) return(entry$vdj_payload)
      # Backward compatibility for old saved workspaces.
      p <- tryCatch(obj@tools$vdj_payload, error = function(e) NULL)
      if (is.list(p)) return(p)
      legacy <- tryCatch(obj@misc$vdj, error = function(e) NULL)
      if (is.list(legacy)) return(legacy)
      list()
    }

    .build_registry <- reactive({
      registry_build_error("")
      reg_objs <- .coerce_registry_list(shared_data$all_seurat_objects)
      .normalize_registry_names <- function(registry, sheet_df = NULL) {
        if (is.null(registry) || !is.list(registry) || !length(registry)) return(list())
        nms <- names(registry)
        if (is.null(nms)) nms <- rep("", length(registry))
        nms <- as.character(nms %||% character(0))
        if (length(nms) < length(registry)) nms <- c(nms, rep("", length(registry) - length(nms)))

        if (all(nzchar(nms))) return(registry)

        sheet_names <- character(0)
        if (is.data.frame(sheet_df) && nrow(sheet_df) && "name" %in% colnames(sheet_df)) {
          sheet_names <- as.character(sheet_df$name %||% character(0))
          sheet_names <- sheet_names[!is.na(sheet_names) & nzchar(sheet_names)]
        }
        sheet_names <- unique(sheet_names)

        used <- nms[nzchar(nms)]
        for (i in seq_along(nms)) {
          if (nzchar(nms[[i]])) next
          candidate <- ""
          if (i <= length(sheet_names) && nzchar(sheet_names[[i]]) && !(sheet_names[[i]] %in% used)) {
            candidate <- sheet_names[[i]]
          } else {
            for (nm in sheet_names) {
              if (!(nm %in% used)) {
                candidate <- nm
                break
              }
            }
          }
          if (!nzchar(candidate)) candidate <- paste0("Imported_", i)
          nms[[i]] <- candidate
          used <- c(used, candidate)
        }
        names(registry) <- nms
        registry
      }
      sample_sheet <- shared_data$full_sample_sheet
      reg_objs <- .normalize_registry_names(reg_objs, sample_sheet)
      .sidebar_dbg(
        "build_registry start:",
        "reg_len=", length(reg_objs),
        "reg_names=", paste(head(names(reg_objs) %||% character(0), 8), collapse = ",")
      )
      sample_path_map <- character(0)
      if (!is.null(sample_sheet) && is.data.frame(sample_sheet) && nrow(sample_sheet) &&
          all(c("name", "path") %in% names(sample_sheet))) {
        sample_path_map <- stats::setNames(as.character(sample_sheet$path), as.character(sample_sheet$name))
      }

      obj_names <- names(reg_objs %||% list())
      obj_df <- tryCatch({
        if (length(obj_names)) {
          obj_rows <- lapply(obj_names, function(nm) {
            sidebar_registry_safe_object_row(
              name = nm,
              entry = reg_objs[[nm]],
              sample_path_map = sample_path_map,
              remove_btn_html = .remove_btn_html,
              meta_line_html = .meta_line_html
            )
          })
          do.call(rbind, obj_rows)
        } else {
          .empty_registry()
        }
      }, error = function(e) {
        registry_build_error(paste0("Object registry error: ", conditionMessage(e)))
        .sidebar_dbg("object registry error:", conditionMessage(e))
        .empty_registry()
      })
      if (length(reg_objs) > 0 && (!is.data.frame(obj_df) || nrow(obj_df) == 0)) {
        .sidebar_dbg("object registry fallback engaged for non-empty workspace.")
        obj_df <- .fallback_object_registry(reg_objs)
      }

      csv_df <- shared_data$imported_tabular_files
      csv_df <- tryCatch({
        if (is.null(csv_df) || !is.data.frame(csv_df) || !nrow(csv_df)) {
          return(.empty_registry())
        }

        csv_df$name <- as.character(csv_df$name %||% "")
        csv_df$path <- as.character(csv_df$path %||% "")
        # VDJ rows must be represented by workspace object state, not file-path registry rows.
        is_vdj_tabular <- grepl("^VDJ_", toupper(as.character(csv_df$type %||% "")))
        keep_csv <- !is_vdj_tabular & !is.na(csv_df$path) & nzchar(csv_df$path) & file.exists(as.character(csv_df$path))
        csv_df <- csv_df[keep_csv, , drop = FALSE]
        if (is.data.frame(shared_data$imported_tabular_files)) {
          current_paths <- as.character(shared_data$imported_tabular_files$path %||% character(0))
          valid_paths <- as.character(csv_df$path %||% character(0))
          if (!identical(sort(unique(current_paths)), sort(unique(valid_paths)))) {
            shared_data$imported_tabular_files <- csv_df
          }
        }
        if (!nrow(csv_df)) {
          return(.empty_registry())
        }

        missing_name <- is.na(csv_df$name) | !nzchar(csv_df$name)
        if (any(missing_name)) csv_df$name[missing_name] <- basename(csv_df$path[missing_name])

        csv_paths <- as.character(csv_df$path)
        finfo <- suppressWarnings(file.info(csv_paths))
        line_n <- vapply(csv_paths, .file_line_count, numeric(1))
        type_txt <- "Tabular data"
        if ("type" %in% names(csv_df)) {
          raw_t <- toupper(as.character(csv_df$type))
          type_txt <- ifelse(nzchar(raw_t), paste0(raw_t, " data"), "Tabular data")
        }
        row_cls <- ifelse(grepl("^VDJ_", toupper(as.character(csv_df$type %||% ""))), "sfi-vdj", "sfi-tabular")
        remove_btn <- vapply(
          as.character(csv_df$path),
          function(p) .remove_btn_html(paste0("csv::", p)),
          character(1)
        )
        size_txt <- vapply(finfo$size, .fmt_size, character(1))
        line_txt <- ifelse(is.finite(line_n), paste0(format(line_n, big.mark = ","), " lines"), "Lines: NA")
        time_txt <- vapply(finfo$mtime, .fmt_time, character(1))
        file_ok <- is.finite(suppressWarnings(as.numeric(finfo$size))) & is.finite(line_n)
        warn_cls <- ifelse(file_ok, "", " sfi-warning")
        row_cls <- paste0(row_cls, warn_cls)
        status_txt <- ifelse(file_ok, "Available", "Warning: File missing/unreadable")
        detail_txt <- ifelse(file_ok, time_txt, "Warning: File missing/unreadable from saved path")
        disp <- sprintf(
          "<div class='sidebar-file-item %s'>%s<div class='sfi-title' title='%s'><span class='sfi-title-text'>%s</span></div><div class='sfi-meta1'>%s</div><div class='sfi-meta2'>%s</div></div>",
          row_cls,
          remove_btn,
          htmltools::htmlEscape(as.character(csv_df$name)),
          htmltools::htmlEscape(as.character(csv_df$name)),
          .meta_line_html(paste(type_txt, size_txt, line_txt, sep = " | ")),
          .meta_line_html(detail_txt)
        )

        data.frame(
          name = as.character(csv_df$name),
          kind = "CSV data",
          status = status_txt,
          key = paste0("csv::", as.character(csv_df$path)),
          object_name = NA_character_,
          size_text = size_txt,
          type_text = type_txt,
          time_text = time_txt,
          display = disp,
          stringsAsFactors = FALSE
        )
      }, error = function(e) {
        registry_build_error(paste0("Tabular registry error: ", conditionMessage(e)))
        .sidebar_dbg("tabular registry error:", conditionMessage(e))
        .empty_registry()
      })

      vdj_obj_df <- tryCatch({
        if (length(obj_names)) {
          vdj_rows <- lapply(obj_names, function(nm) {
            entry <- reg_objs[[nm]]
            obj <- .entry_obj(entry)
            if (is.null(obj) || !inherits(obj, "Seurat")) return(NULL)

            md <- tryCatch(obj@meta.data, error = function(e) NULL)
            has_md <- is.data.frame(md) && nrow(md)
            has_vdj_cols <- has_md && all(c("vdj_tcr_pos", "vdj_bcr_pos", "vdj_tcr_clone", "vdj_bcr_clone", "vdj_tcr_clone_size", "vdj_bcr_clone_size") %in% colnames(md))
            .is_detected_clone <- function(x) {
              xx <- tolower(trimws(as.character(x %||% "")))
              !(is.na(xx) | xx == "" | xx == "0" | xx == "unknown")
            }
            tcr_pos <- if (has_vdj_cols) (as.logical(md$vdj_tcr_pos %||% FALSE) & .is_detected_clone(md$vdj_tcr_clone %||% "")) else rep(FALSE, if (has_md) nrow(md) else 0L)
            bcr_pos <- if (has_vdj_cols) (as.logical(md$vdj_bcr_pos %||% FALSE) & .is_detected_clone(md$vdj_bcr_clone %||% "")) else rep(FALSE, if (has_md) nrow(md) else 0L)
            tcr_n <- sum(tcr_pos, na.rm = TRUE)
            bcr_n <- sum(bcr_pos, na.rm = TRUE)
            both_n <- sum((tcr_pos | bcr_pos), na.rm = TRUE)

            payload <- .entry_vdj_payload(entry, obj)
            rec <- payload$records %||% NULL
            rec_n <- if (is.data.frame(rec)) nrow(rec) else 0L
            linked <- tryCatch(entry$meta$linked_files$vdj, error = function(e) NULL)
            has_link_rows <- is.data.frame(linked) && nrow(linked) > 0L
            has_payload <- isTRUE(has_vdj_cols || rec_n > 0L || has_link_rows || both_n > 0L || tcr_n > 0L || bcr_n > 0L)
            if (!has_payload) return(NULL)

            src_tag <- as.character(payload$source_tag %||% "")
            imported_at <- payload$imported_at %||% NA
            t_txt <- .fmt_time(imported_at)
            type_txt <- "VDJ metadata (in object)"
            size_txt <- paste0(format(as.integer(rec_n), big.mark = ","), " records")
            detail_1 <- sprintf("TCR+ %d | BCR+ %d | VDJ+ %d", as.integer(tcr_n), as.integer(bcr_n), as.integer(both_n))
            if (isTRUE(has_vdj_cols) && as.integer(both_n) == 0L) {
              detail_1 <- paste0(detail_1, " | no VDJ detected")
            }
            detail_2 <- if (nzchar(src_tag)) sprintf("Source: %s | %s", src_tag, t_txt) else t_txt
            card_name <- paste0("VDJ | ", nm)
            disp <- sprintf(
              "<div class='sidebar-file-item sfi-vdj'>%s<div class='sfi-title' title='%s'><span class='sfi-title-text'>%s</span></div><div class='sfi-meta1'>%s</div><div class='sfi-meta2'>%s</div></div>",
              .remove_btn_html(paste0("vdjobj::", nm)),
              htmltools::htmlEscape(card_name),
              htmltools::htmlEscape(card_name),
              .meta_line_html(paste(type_txt, detail_1, sep = " | ")),
              .meta_line_html(detail_2)
            )
            data.frame(
              name = card_name,
              kind = "VDJ payload",
              status = "In object",
              key = paste0("vdjobj::", nm),
              object_name = nm,
              size_text = size_txt,
              type_text = type_txt,
              time_text = t_txt,
              display = disp,
              stringsAsFactors = FALSE
            )
          })
          vdj_link_rows <- lapply(obj_names, function(nm) {
            entry <- reg_objs[[nm]]
            linked <- tryCatch(entry$meta$linked_files$vdj, error = function(e) NULL)
            if (is.null(linked) || !is.data.frame(linked) || !nrow(linked)) return(NULL)
            if (!all(c("chain", "source_name") %in% names(linked))) {
              if ("path" %in% names(linked)) linked$source_name <- basename(as.character(linked$path %||% ""))
            }
            if (!all(c("chain", "source_name") %in% names(linked))) return(NULL)
            linked <- linked[nzchar(as.character(linked$source_name %||% "")), , drop = FALSE]
            if (!nrow(linked)) return(NULL)
            linked$chain <- toupper(as.character(linked$chain %||% ""))
            linked$type <- ifelse(linked$chain == "TCR", "VDJ_TCR data", ifelse(linked$chain == "BCR", "VDJ_BCR data", "VDJ data"))
            size_txt <- rep("Embedded", nrow(linked))
            line_txt <- rep("Lines: Embedded", nrow(linked))
            time_txt <- rep("Time: Embedded", nrow(linked))
            chain_label <- ifelse(linked$chain %in% c("TCR", "BCR"), linked$chain, "Unknown")
            base_label <- as.character(linked$source_name)
            fallback_label <- paste0(nm, "_", tolower(ifelse(nzchar(linked$chain), linked$chain, "vdj")), "_contigs")
            display_label <- ifelse(nzchar(base_label), base_label, fallback_label)
            item_name <- paste0("VDJ file | ", nm, " | ", chain_label, " | ", display_label)
            disp <- sprintf(
              "<div class='sidebar-file-item sfi-vdj'>%s<div class='sfi-title' title='%s'><span class='sfi-title-text'>%s</span></div><div class='sfi-meta1'>%s</div><div class='sfi-meta2'>%s</div></div>",
              .remove_btn_html(paste0("vdjlink::", nm, "::", as.character(linked$chain), "::", as.character(linked$source_name))),
              htmltools::htmlEscape(as.character(item_name)),
              htmltools::htmlEscape(as.character(item_name)),
              .meta_line_html(paste(linked$type, size_txt, line_txt, sep = " | ")),
              .meta_line_html(time_txt)
            )
            data.frame(
              name = as.character(item_name),
              kind = "VDJ payload",
              status = "Linked to object",
              key = paste0("vdjlink::", nm, "::", as.character(linked$chain), "::", as.character(linked$source_name)),
              object_name = nm,
              size_text = size_txt,
              type_text = as.character(linked$type),
              time_text = time_txt,
              display = disp,
              stringsAsFactors = FALSE
            )
          })
          vdj_payload_rows <- lapply(obj_names, function(nm) {
            entry <- reg_objs[[nm]]
            payload <- tryCatch(entry$vdj_payload, error = function(e) NULL)
            if (!is.list(payload)) return(NULL)
            src <- as.character(payload$source_file %||% character(0))
            src <- src[!is.na(src) & nzchar(src)]
            src <- unique(src)
            if (!length(src)) return(NULL)
            disp_name <- paste0("VDJ payload | ", nm)
            meta1 <- paste0("VDJ payload data | Embedded | Files: ", format(length(src), big.mark = ","))
            meta2 <- paste0("Time: ", ifelse(is.null(payload$imported_at) || is.na(payload$imported_at), "Unknown", as.character(payload$imported_at)))
            disp <- sprintf(
              "<div class='sidebar-file-item sfi-vdj'>%s<div class='sfi-title' title='%s'><span class='sfi-title-text'>%s</span></div><div class='sfi-meta1'>%s</div><div class='sfi-meta2'>%s</div></div>",
              .remove_btn_html(paste0("vdjpayload::", nm)),
              htmltools::htmlEscape(as.character(disp_name)),
              htmltools::htmlEscape(as.character(disp_name)),
              .meta_line_html(meta1),
              .meta_line_html(meta2)
            )
            data.frame(
              name = as.character(disp_name),
              kind = "VDJ payload",
              status = "In object payload",
              key = paste0("vdjpayload::", nm),
              object_name = nm,
              size_text = "Embedded",
              type_text = "VDJ payload data",
              time_text = meta2,
              display = disp,
              stringsAsFactors = FALSE
            )
          })
          vdj_rows <- vdj_rows[!vapply(vdj_rows, is.null, logical(1))]
          vdj_link_rows <- vdj_link_rows[!vapply(vdj_link_rows, is.null, logical(1))]
          vdj_payload_rows <- vdj_payload_rows[!vapply(vdj_payload_rows, is.null, logical(1))]
          merged_vdj <- .bind_rows_safe(
            .bind_rows_safe(
              if (length(vdj_rows)) do.call(rbind, vdj_rows) else .empty_registry(),
              if (length(vdj_link_rows)) do.call(rbind, vdj_link_rows) else .empty_registry()
            ),
            if (length(vdj_payload_rows)) do.call(rbind, vdj_payload_rows) else .empty_registry()
          )
          if (!nrow(merged_vdj)) .empty_registry() else merged_vdj[!duplicated(as.character(merged_vdj$key)), , drop = FALSE]
        } else {
          .empty_registry()
        }
      }, error = function(e) {
        registry_build_error(paste0("VDJ registry error: ", conditionMessage(e)))
        .sidebar_dbg("vdj registry error:", conditionMessage(e))
        .empty_registry()
      })

      out <- .bind_rows_safe(.bind_rows_safe(obj_df, csv_df), vdj_obj_df)
      if (length(reg_objs) > 0 && (!is.data.frame(out) || nrow(out) == 0)) {
        .sidebar_dbg("merged registry fallback engaged for non-empty workspace.")
        out <- .fallback_object_registry(reg_objs)
      }
      .vdj_log(
        "build_registry counts.",
        "obj_n=", nrow(obj_df),
        "csv_n=", if (is.data.frame(csv_df)) nrow(csv_df) else 0L,
        "vdj_obj_n=", if (is.data.frame(vdj_obj_df)) nrow(vdj_obj_df) else 0L,
        "out_n=", nrow(out)
      )
      if (!nrow(out)) {
        if (length(reg_objs) > 0 && !nzchar(registry_build_error())) {
          registry_build_error(sprintf("Registry is empty, but %d object(s) exist in workspace.", length(reg_objs)))
        }
        .sidebar_dbg("registry merged empty; err=", registry_build_error() %||% "")
        if (length(reg_objs) > 0) return(.fallback_object_registry(reg_objs))
        return(.empty_registry())
      }
      out$key <- as.character(out$key %||% "")
      out$display <- as.character(out$display %||% "")
      valid <- !is.na(out$key) & nzchar(out$key) & !is.na(out$display) & nzchar(trimws(out$display))
      out <- out[valid, , drop = FALSE]
      if (!nrow(out)) {
        if (length(reg_objs) > 0 && !nzchar(registry_build_error())) {
          registry_build_error(sprintf("Registry rows were filtered out, while %d object(s) exist in workspace.", length(reg_objs)))
        }
        .sidebar_dbg("registry valid-filter empty; err=", registry_build_error() %||% "")
        if (length(reg_objs) > 0) return(.fallback_object_registry(reg_objs))
        return(.empty_registry())
      }
      .sidebar_dbg(
        "build_registry done:",
        "obj_n=", if (is.data.frame(obj_df)) nrow(obj_df) else 0,
        "csv_n=", if (is.data.frame(csv_df)) nrow(csv_df) else 0,
        "vdj_n=", if (is.data.frame(vdj_obj_df)) nrow(vdj_obj_df) else 0,
        "out_n=", nrow(out)
      )
      out[!duplicated(out$key), , drop = FALSE]
    })

    output$data_registry_table <- renderDT({
      reg <- .build_registry()
      reg_objs_now <- .coerce_registry_list(shared_data$all_seurat_objects)
      if ((!is.data.frame(reg) || !nrow(reg)) && length(reg_objs_now) > 0) {
        .sidebar_dbg(
          "renderDT fallback:",
          "reg_rows=", if (is.data.frame(reg)) nrow(reg) else 0,
          "reg_obj_len=", length(reg_objs_now),
          "err=", registry_build_error() %||% ""
        )
        reg <- .fallback_object_registry(reg_objs_now)
      }
      if (!nrow(reg)) {
        err_msg <- as.character(registry_build_error() %||% "")
        empty_html <- if (nzchar(err_msg)) {
          sprintf(
            "<div class='sidebar-file-empty'><strong>Data registry unavailable</strong><br>%s</div>",
            htmltools::htmlEscape(err_msg)
          )
        } else {
          "<div class='sidebar-file-empty'>No data loaded</div>"
        }
        reg <- data.frame(
          display = empty_html,
          stringsAsFactors = FALSE
        )
        return(datatable(
          reg, rownames = FALSE, selection = "none", escape = FALSE,
          class = "compact hover sidebar-data-menu",
          options = list(dom = "t", paging = FALSE, ordering = FALSE, searching = FALSE, info = FALSE),
          colnames = c("")
        ))
      }

      sidebar_table <- .safe_select_cols(reg, c("display"), default = "")
      datatable(
        sidebar_table,
        rownames = FALSE,
        selection = "multiple",
        class = "compact hover sidebar-data-menu",
        escape = FALSE,
        options = list(
          dom = "t",
          paging = FALSE,
          scrollX = FALSE,
          autoWidth = FALSE,
          ordering = FALSE,
          columnDefs = list(
            list(width = "100%", targets = 0),
            list(className = "sidebar-file-card-cell", targets = 0)
          )
        ),
        colnames = c("")
      )
    }, server = FALSE)

    observeEvent(input$btn_add_selected_to_page, {
      reg <- .build_registry()
      sel <- input$data_registry_table_rows_selected
      if (is.null(sel) || !length(sel) || !nrow(reg)) {
        showNotification("Select one or more files/objects first.", type = "warning")
        return()
      }

      chosen <- reg[sel, , drop = FALSE]
      shared_data$selected_sidebar_items <- chosen

      obj_rows <- chosen[chosen$kind == "Seurat object", , drop = FALSE]
      if (nrow(obj_rows) && nzchar(as.character(obj_rows$name[[1]] %||% ""))) {
        shared_data$active_object_name <- as.character(obj_rows$name[[1]])
      } else {
        vdj_rows <- chosen[chosen$kind == "VDJ payload", , drop = FALSE]
        obj_hint <- as.character(vdj_rows$object_name %||% "")
        obj_hint <- obj_hint[nzchar(obj_hint)]
        if (length(obj_hint)) {
          shared_data$active_object_name <- obj_hint[[1]]
        }
      }

      showNotification(sprintf("Added %d selected item(s) to current page context.", nrow(chosen)), type = "message")
    })

    pending_sidebar_remove <- reactiveVal(NULL)

    observeEvent(input$sidebar_remove_key, {
      key <- as.character(input$sidebar_remove_key %||% "")
      if (!nzchar(key)) return(invisible(NULL))
      reg <- .build_registry()
      hit <- reg[reg$key == key, , drop = FALSE]
      if (nrow(hit)) {
        item_name <- as.character(hit$name[[1]] %||% "selected item")
        item_kind <- as.character(hit$kind[[1]] %||% "Item")
      } else {
        if (startsWith(key, "obj::")) {
          item_name <- sub("^obj::", "", key)
          item_kind <- "Seurat object"
        } else if (startsWith(key, "csv::")) {
          item_name <- basename(sub("^csv::", "", key))
          item_kind <- "CSV data"
        } else if (startsWith(key, "vdjobj::")) {
          item_name <- sub("^vdjobj::", "", key)
          item_kind <- "VDJ payload"
        } else if (startsWith(key, "vdjlink::")) {
          item_name <- sub("^vdjlink::", "", key)
          item_kind <- "VDJ payload"
        } else if (startsWith(key, "vdjpayload::")) {
          item_name <- sub("^vdjpayload::", "", key)
          item_kind <- "VDJ payload"
        } else {
          item_name <- "selected item"
          item_kind <- "Item"
        }
      }
      pending_sidebar_remove(list(key = key, name = item_name, kind = item_kind))

      showModal(modalDialog(
        title = "Confirm Permanent Remove",
        easyClose = TRUE,
        size = "m",
        div(
          class = "alert alert-danger",
          tags$b("Warning: this will remove data from the current workspace session.")
        ),
        p(sprintf("Remove \"%s\" from Data Files?", item_name)),
        tags$small(sprintf("Type: %s", item_kind)),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(ns("confirm_sidebar_remove_btn"), "Remove", class = "btn btn-danger")
        )
      ))
    }, ignoreInit = TRUE)

    observeEvent(input$confirm_sidebar_remove_btn, {
      pending <- pending_sidebar_remove()
      req(!is.null(pending), nzchar(as.character(pending$key %||% "")))
      key <- as.character(pending$key)

      if (startsWith(key, "obj::")) {
        nm <- sub("^obj::", "", key)
        reg <- shared_data$all_seurat_objects %||% list()
        before_names <- names(reg %||% list())
        hit_names <- intersect(before_names, nm)
        if (length(hit_names)) reg[hit_names] <- NULL
        shared_data$all_seurat_objects <- reg

        ss <- shared_data$full_sample_sheet
        if (is.data.frame(ss) && nrow(ss) && "name" %in% names(ss)) {
          keep <- as.character(ss$name) != nm
          shared_data$full_sample_sheet <- ss[keep, , drop = FALSE]
        }

        prefs <- shared_data$object_prefs
        if (is.list(prefs) && length(prefs)) {
          keep_pref <- setdiff(names(prefs), nm)
          shared_data$object_prefs <- prefs[keep_pref]
        }
        ann_layers <- shared_data$annotation_layers
        if (is.list(ann_layers) && length(ann_layers)) {
          keep_ann <- setdiff(names(ann_layers), nm)
          shared_data$annotation_layers <- ann_layers[keep_ann]
        }
        ann_active <- shared_data$active_annotation_layer
        if (is.list(ann_active) && length(ann_active)) {
          keep_act <- setdiff(names(ann_active), nm)
          shared_data$active_annotation_layer <- ann_active[keep_act]
        }

        cur_active <- as.character(shared_data$active_object_name %||% "")
        if (!nzchar(cur_active) || identical(cur_active, nm) || is.null((shared_data$all_seurat_objects %||% list())[[cur_active]])) {
          remain <- names(shared_data$all_seurat_objects %||% list())
          shared_data$active_object_name <- if (length(remain)) remain[[length(remain)]] else NULL
        }
        removed_n <- length(intersect(before_names, nm))
        if (!removed_n) {
          showNotification(sprintf("Object \"%s\" was not found in workspace registry.", nm), type = "error")
        } else {
          showNotification(sprintf("Removed object: %s", nm), type = "message")
        }
      } else if (startsWith(key, "csv::")) {
        p <- sub("^csv::", "", key)
        tab <- shared_data$imported_tabular_files
        if (is.data.frame(tab) && nrow(tab) && "path" %in% names(tab)) {
          keep <- as.character(tab$path) != p
          shared_data$imported_tabular_files <- tab[keep, , drop = FALSE]
        }
      } else if (startsWith(key, "vdjobj::")) {
        nm <- sub("^vdjobj::", "", key)
        reg <- shared_data$all_seurat_objects %||% list()
        entry <- reg[[nm]]
        obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry

        if (!is.null(obj) && inherits(obj, "Seurat")) {
          md <- tryCatch(obj@meta.data, error = function(e) NULL)
          if (is.data.frame(md) && nrow(md)) {
            drop_cols <- intersect(c("vdj_tcr_pos", "vdj_bcr_pos", "vdj_clone_id", "vdj_clonotype_id"), colnames(md))
            if (length(drop_cols)) obj@meta.data <- md[, setdiff(colnames(md), drop_cols), drop = FALSE]
          }
          try(obj@tools$vdj_payload <- NULL, silent = TRUE)
          try(obj@misc$vdj <- NULL, silent = TRUE)
        }

        if (is.list(entry) && !is.null(entry$obj)) {
          entry$obj <- obj
          entry$vdj_payload <- NULL
          reg[[nm]] <- entry
        } else {
          reg[[nm]] <- obj
        }
        shared_data$all_seurat_objects <- reg
      }

      pending_sidebar_remove(NULL)
      removeModal()
      if (!startsWith(key, "obj::")) {
        showNotification(sprintf("Removed: %s", as.character(pending$name %||% "item")), type = "message")
      }
    })

    staged_samples <- reactiveVal(data.frame(
      id = character(0),
      name = character(0),
      path = character(0),
      type = character(0),
      condition = character(0),
      batch = character(0),
      stringsAsFactors = FALSE
    ))
    # Agent note: Manifest rows stay compact and sample-level. Per-cell sidecars are
    # attached only during commit; never expand them into this preview table. Keep
    # long import result reports in their own scrollable viewport and update the
    # overlay from the sample-loading loop so batch imports remain visibly active.
    metadata_manifest_df <- reactiveVal(data.frame())
    metadata_manifest_info <- reactiveVal(list())
    metadata_manifest_conflicts <- reactiveVal(data.frame())
    metadata_manifest_pending_commit <- reactiveVal(NULL)
    metadata_manifest_result <- reactiveVal(data.frame())
    vdj_detect_candidates <- reactiveVal(data.frame())
    vdj_prompt_pending <- reactiveVal(NULL)
    h5ad_import_pending <- reactiveVal(NULL)
    h5ad_import_map_df <- reactiveVal(data.frame())
    h5ad_last_selected_keys <- reactiveVal(character(0))
    atac_pairing_df <- reactiveVal(data.frame())
    atac_pairing_ignore <- reactiveVal(character(0))
    atac_pending_index_build <- reactiveVal(NULL)
    atac_pending_conflict <- reactiveVal(NULL)
    .h5ad_map_core_cols <- c(
      "import_key", "include_sample", "object_name", "sample_name", "condition", "batch", "tissue", "species",
      "split_col", "split_value", "path",
      "gsm_col", "condition_col", "tissue_col", "species_col", "batch_col"
    )
    .h5ad_map_noneditable_cols <- c("split_col", "split_value", "path")

    .path_stem <- function(path) {
      b <- basename(as.character(path %||% ""))
      b <- sub("\\.tsv\\.gz$", "", b, ignore.case = TRUE)
      b <- sub("\\.tsv\\.bgz$", "", b, ignore.case = TRUE)
      b <- sub("\\.gz$", "", b, ignore.case = TRUE)
      b <- sub("\\.tsv$", "", b, ignore.case = TRUE)
      b
    }
    .atac_norm_token <- function(x) {
      v <- tolower(as.character(x %||% ""))
      v <- gsub("gsm[0-9]+_", "", v, perl = TRUE)
      v <- gsub("_multiome_atac_fragments$", "", v, perl = TRUE)
      v <- gsub("_atac_fragments$", "", v, perl = TRUE)
      v <- gsub("(^|_)filtered_feature_bc_matrix$", "", v, perl = TRUE)
      v <- gsub("[^a-z0-9]+", "", v, perl = TRUE)
      v
    }
    .atac_is_fragment_file <- function(path) {
      b <- tolower(basename(as.character(path %||% "")))
      grepl("_atac_fragments\\.tsv\\.(gz|bgz)$", b, perl = TRUE)
    }
    .atac_index_path <- function(path) {
      paste0(as.character(path %||% ""), ".tbi")
    }
    .atac_build_pairing_df <- function(df_staged) {
      out <- data.frame()
      if (is.null(df_staged) || !is.data.frame(df_staged) || !nrow(df_staged)) return(out)
      type_norm <- tolower(as.character(df_staged$type %||% ""))
      obj_rows <- df_staged[type_norm %in% c("h5", "hdf5", "matrix", "h5ad"), , drop = FALSE]
      frag_rows <- df_staged[type_norm %in% c("atac_fragment"), , drop = FALSE]
      if (!nrow(obj_rows) || !nrow(frag_rows)) return(out)

      frag_rows$token <- vapply(frag_rows$name, .atac_norm_token, character(1))
      frag_rows$mtime <- suppressWarnings(as.numeric(file.info(frag_rows$path)$mtime))
      obj_rows$token <- vapply(obj_rows$name, .atac_norm_token, character(1))
      for (i in seq_len(nrow(obj_rows))) {
        nm <- as.character(obj_rows$name[[i]] %||% "")
        tok <- as.character(obj_rows$token[[i]] %||% "")
        cands <- frag_rows[frag_rows$token == tok & nzchar(tok), , drop = FALSE]
        status <- "unmatched"
        chosen <- ""
        if (nrow(cands)) {
          ord <- order(cands$mtime, decreasing = TRUE, na.last = TRUE)
          cands <- cands[ord, , drop = FALSE]
          chosen <- as.character(cands$path[[1]] %||% "")
          status <- if (nrow(cands) > 1) "auto_tiebreak" else "matched"
        }
        one <- data.frame(
          object_name = nm,
          object_path = as.character(obj_rows$path[[i]] %||% ""),
          object_type = as.character(obj_rows$type[[i]] %||% ""),
          object_token = tok,
          fragment_path = chosen,
          fragment_name = if (nzchar(chosen)) basename(chosen) else "",
          status = status,
          ignored = FALSE,
          stringsAsFactors = FALSE
        )
        out <- .bind_rows_safe(out, one)
      }
      out
    }

    .append_staged <- function(new_entries) {
      if (is.null(new_entries) || !nrow(new_entries)) return(invisible(NULL))
      if (!"condition" %in% names(new_entries)) new_entries$condition <- "Unknown"
      if (!"batch" %in% names(new_entries)) new_entries$batch <- "Batch1"
      cur <- staged_samples()
      out <- .bind_rows_safe(cur, new_entries)
      out <- out[!duplicated(out$path), , drop = FALSE]
      if ("name" %in% names(out) && nrow(out)) out$name <- make.unique(as.character(out$name))
      staged_samples(out)
      invisible(NULL)
    }

    .sanitize_sample_name <- function(x, allow_empty = FALSE) {
      x <- as.character(x %||% "")
      x <- sub("^\\s+", "", x)
      x <- sub("\\s+$", "", x)
      x <- gsub("[/\\\\]", "_", x)
      x <- gsub("[^A-Za-z0-9._-]+", "_", x)
      x <- gsub("_+", "_", x)
      x <- gsub("^[_\\.-]+", "", x)
      x <- gsub("[_\\.-]+$", "", x)
      if (!nzchar(x)) {
        if (isTRUE(allow_empty)) "" else "sample"
      } else {
        x
      }
    }

    .sanitize_meta_column_name <- function(x, allow_empty = FALSE) {
      x <- as.character(x %||% "")
      x <- sub("^\\s+", "", x)
      x <- sub("\\s+$", "", x)
      x <- gsub("[^A-Za-z0-9]+", "_", x)
      x <- gsub("_+", "_", x)
      x <- gsub("^_+", "", x)
      x <- gsub("_+$", "", x)
      if (!nzchar(x) && isTRUE(allow_empty)) return("")
      if (!nzchar(x)) x <- "meta"
      if (grepl("^[0-9]", x)) x <- paste0("meta_", x)
      tolower(x)
    }

    .metadata_manifest_norm_col <- function(x) {
      x <- tolower(trimws(as.character(x %||% "")))
      x <- gsub("[^a-z0-9]+", "_", x)
      x <- gsub("_+", "_", x)
      x <- gsub("^_|_$", "", x)
      x
    }

    .metadata_manifest_find_col <- function(df, aliases = character(0), pattern = NULL) {
      if (is.null(df) || !is.data.frame(df) || !ncol(df)) return("")
      raw <- colnames(df)
      norm <- vapply(raw, .metadata_manifest_norm_col, character(1))
      alias_norm <- unique(vapply(as.character(aliases %||% character(0)), .metadata_manifest_norm_col, character(1)))
      alias_norm <- alias_norm[nzchar(alias_norm)]
      for (aa in alias_norm) {
        idx <- which(norm == aa)
        if (length(idx)) return(raw[[idx[[1]]]])
      }
      if (!is.null(pattern) && nzchar(as.character(pattern %||% ""))) {
        idx <- which(grepl(pattern, norm, perl = TRUE))
        if (length(idx)) return(raw[[idx[[1]]]])
      }
      ""
    }

    .metadata_manifest_read_table <- function(path) {
      p <- normalizePath(as.character(path %||% ""), winslash = "/", mustWork = FALSE)
      if (!file.exists(p) || dir.exists(p)) stop("Metadata list file was not found.")
      ext <- tolower(tools::file_ext(p))
      try_one <- function(sep) {
        tryCatch(
          utils::read.table(
            p,
            header = TRUE,
            sep = sep,
            quote = "\"'",
            comment.char = "",
            fill = FALSE,
            stringsAsFactors = FALSE,
            check.names = FALSE,
            na.strings = c("", "NA", "N/A", "na"),
            strip.white = TRUE
          ),
          error = function(e) NULL
        )
      }
      tab <- try_one("\t")
      csv <- try_one(",")
      valid <- list()
      if (is.data.frame(tab) && ncol(tab) > 1L) valid$tsv <- tab
      if (is.data.frame(csv) && ncol(csv) > 1L) valid$csv <- csv
      if (!length(valid)) stop("Could not detect a tab-separated or comma-separated table with multiple columns.")
      chosen <- ""
      if (ext %in% c("tsv", "tab") && !is.null(valid$tsv)) chosen <- "tsv"
      if (ext %in% c("csv") && !is.null(valid$csv)) chosen <- "csv"
      if (!nzchar(chosen) && length(valid) == 1L) chosen <- names(valid)[[1]]
      if (!nzchar(chosen)) {
        n_tsv <- if (!is.null(valid$tsv)) ncol(valid$tsv) else 0L
        n_csv <- if (!is.null(valid$csv)) ncol(valid$csv) else 0L
        if (n_tsv != n_csv) {
          chosen <- if (n_tsv > n_csv) "tsv" else "csv"
        } else {
          stop("Table delimiter is ambiguous. Save the file as .tsv or .csv and try again.")
        }
      }
      out <- valid[[chosen]]
      if (!nrow(out)) stop("Metadata list contains no sample rows.")
      if (is.null(colnames(out)) || any(!nzchar(trimws(colnames(out))))) {
        stop("Metadata list must have a non-empty header row.")
      }
      colnames(out) <- make.unique(trimws(colnames(out)), sep = "_")
      list(data = out, delimiter = chosen, path = p)
    }

    .metadata_manifest_resolve_path <- function(raw_path, root_path = "") {
      raw <- trimws(as.character(raw_path %||% ""))
      root <- trimws(as.character(root_path %||% ""))
      if (!nzchar(raw)) return("")
      raw_norm <- gsub("\\\\", "/", raw)
      root_norm <- if (nzchar(root)) normalizePath(root, winslash = "/", mustWork = FALSE) else ""
      candidates <- character(0)
      candidates <- c(candidates, raw_norm)
      if (nzchar(root_norm) && !grepl("^([A-Za-z]:/|/)", raw_norm)) {
        candidates <- c(candidates, file.path(root_norm, raw_norm))
      }
      if (nzchar(root_norm)) {
        root_base <- basename(root_norm)
        parts <- strsplit(raw_norm, "/", fixed = TRUE)[[1]]
        hit <- which(parts == root_base)
        if (length(hit) && hit[[length(hit)]] < length(parts)) {
          suffix <- paste(parts[(hit[[length(hit)]] + 1L):length(parts)], collapse = "/")
          candidates <- c(candidates, file.path(root_norm, suffix))
        }
      }
      for (candidate in unique(candidates)) {
        if (file.exists(candidate) || dir.exists(candidate)) {
          return(normalizePath(candidate, winslash = "/", mustWork = FALSE))
        }
      }
      ""
    }

    .metadata_manifest_is_matrix_dir <- function(path) {
      p <- as.character(path %||% "")
      if (!nzchar(p) || !dir.exists(p)) return(FALSE)
      has_matrix <- file.exists(file.path(p, "matrix.mtx")) || file.exists(file.path(p, "matrix.mtx.gz"))
      has_barcodes <- file.exists(file.path(p, "barcodes.tsv")) || file.exists(file.path(p, "barcodes.tsv.gz"))
      has_features <- file.exists(file.path(p, "features.tsv")) || file.exists(file.path(p, "features.tsv.gz")) ||
        file.exists(file.path(p, "genes.tsv")) || file.exists(file.path(p, "genes.tsv.gz"))
      isTRUE(has_matrix && has_barcodes && has_features)
    }

    .metadata_manifest_find_matrix_dir <- function(path, cell_set = "filtered") {
      p <- as.character(path %||% "")
      if (!nzchar(p)) return("")
      if (file.exists(p) && grepl("(^|/)matrix\\.mtx(\\.gz)?$", gsub("\\\\", "/", p), ignore.case = TRUE, perl = TRUE)) {
        p <- dirname(p)
      }
      if (.metadata_manifest_is_matrix_dir(p)) return(normalizePath(p, winslash = "/", mustWork = FALSE))
      if (!dir.exists(p)) return("")
      wanted <- if (identical(cell_set, "all_cells")) {
        c("all_cells", "all", "raw_feature_bc_matrix", "raw_gene_barcodes")
      } else {
        c("filtered", "filtered_feature_bc_matrix", "filtered_gene_barcodes")
      }
      for (nm in wanted) {
        candidate <- file.path(p, nm)
        if (.metadata_manifest_is_matrix_dir(candidate)) {
          return(normalizePath(candidate, winslash = "/", mustWork = FALSE))
        }
      }
      ""
    }

    .metadata_manifest_matrix_candidate <- function(raw_path, root_path, cell_set) {
      p <- .metadata_manifest_resolve_path(raw_path, root_path)
      if (!nzchar(p)) return("")
      .metadata_manifest_find_matrix_dir(p, cell_set = cell_set)
    }

    .metadata_manifest_path_map <- function(df) {
      nms <- colnames(df)
      norm <- vapply(nms, .metadata_manifest_norm_col, character(1))
      pick <- function(aliases = character(0), pattern = NULL) {
        .metadata_manifest_find_col(df, aliases = aliases, pattern = pattern)
      }
      h5 <- pick(
        aliases = c("h5_path", "hdf5_path", "h5_archive_path", "input_h5_path"),
        pattern = "(^|_)h(5|df5)(_|$).*path|(^|_)path(_|$).*h(5|df5)"
      )
      filtered <- pick(
        aliases = c("filtered_matrix_path", "filtered_matrix_archive_path", "filtered_input_path"),
        pattern = "filtered.*matrix.*path|matrix.*filtered.*path"
      )
      all_cells <- pick(
        aliases = c("all_matrix_path", "all_matrix_archive_path", "all_cells_path", "all_cells_matrix_path"),
        pattern = "all.*(matrix|cell).*path|(matrix|cell).*all.*path"
      )
      generic <- pick(
        aliases = c("relative_input_path", "input_path", "source_path", "matrix_or_h5_path", "path"),
        pattern = "(^|_)relative.*path$|(^|_)input.*path$|(^|_)source.*path$"
      )
      path_cols <- nms[grepl("path|url|archive", norm, perl = TRUE)]
      list(
        h5 = h5,
        filtered = filtered,
        all_cells = all_cells,
        generic = generic,
        path_cols = unique(path_cols)
      )
    }

    .metadata_manifest_sidecar <- function(path, file_name) {
      p <- as.character(path %||% "")
      if (!nzchar(p)) return("")
      current <- if (dir.exists(p)) p else dirname(p)
      current <- normalizePath(current, winslash = "/", mustWork = FALSE)
      for (i in seq_len(6L)) {
        for (candidate_name in c(file_name, paste0(file_name, ".gz"))) {
          candidate <- file.path(current, candidate_name)
          if (file.exists(candidate) && !dir.exists(candidate)) {
            return(normalizePath(candidate, winslash = "/", mustWork = FALSE))
          }
        }
        parent <- dirname(current)
        if (!nzchar(parent) || identical(parent, current)) break
        current <- parent
      }
      ""
    }

    .metadata_manifest_value <- function(df, row, col, default = "") {
      if (!nzchar(as.character(col %||% "")) || !(col %in% colnames(df))) return(default)
      value <- df[[col]][[row]]
      if (length(value) == 0L || is.na(value)) return(default)
      trimws(as.character(value))
    }

    .metadata_manifest_normalize_technology <- function(value, source_path = "") {
      raw <- trimws(as.character(value %||% ""))
      low <- tolower(gsub("[^a-z0-9]+", "_", raw))
      if (grepl("smart.*seq|ssq", low, perl = TRUE)) return("smartseq2")
      if (grepl("fluidigm|c1", low, perl = TRUE)) return("fluidigm_c1")
      if (grepl("10x|cell.?ranger|chromium", low, perl = TRUE)) return("10x")
      path_low <- tolower(gsub("\\\\", "/", as.character(source_path %||% "")))
      if (grepl("smartseq2|smart_seq2|ssq2", path_low, perl = TRUE)) return("smartseq2")
      if (grepl("fluidigm|c1", path_low, perl = TRUE)) return("fluidigm_c1")
      if (grepl("\\.(h5|hdf5)$", path_low, perl = TRUE)) return("10x")
      if (nzchar(raw)) return(raw)
      "unknown"
    }

    .metadata_manifest_normalize_cell_set <- function(value, default = "filtered") {
      low <- tolower(gsub("[^a-z0-9]+", "_", trimws(as.character(value %||% ""))))
      if (low %in% c("all", "all_cells", "all_cell", "raw", "raw_cells")) return("all_cells")
      if (low %in% c("filtered", "filter", "filtered_cells")) return("filtered")
      default
    }

    .metadata_manifest_normalize_input_type <- function(value, default = "") {
      low <- tolower(trimws(as.character(value %||% "")))
      if (low %in% c("h5", "hdf5", "cellranger_h5", "10x_h5")) return("h5")
      if (low %in% c("matrix", "mtx", "matrix_market", "matrixmarket")) return("matrix")
      if (low %in% c("h5ad", "anndata")) return("h5ad")
      default
    }

    .metadata_manifest_prepare <- function(table_path, root_path = "") {
      parsed <- .metadata_manifest_read_table(table_path)
      df <- parsed$data
      path_map <- .metadata_manifest_path_map(df)
      donor_col <- .metadata_manifest_find_col(
        df,
        aliases = c("donor_id", "donorid", "donor", "sample_id", "sampleid", "sample_name", "sample", "subject_id", "subjectid", "subject")
      )
      if (!nzchar(donor_col)) stop("Metadata list needs a donor or sample identifier column.")
      technology_col <- .metadata_manifest_find_col(
        df,
        aliases = c("technology", "platform", "library_type", "sequencing_technology", "assay")
      )
      if (!nzchar(technology_col)) {
        technology_col <- "Technology"
        df[[technology_col]] <- rep(NA_character_, nrow(df))
      }
      condition_col <- .metadata_manifest_find_col(
        df,
        aliases = c("condition", "group", "treatment", "disease_status", "disease", "status")
      )
      if (!nzchar(condition_col)) {
        condition_col <- "Condition"
        df[[condition_col]] <- rep(NA_character_, nrow(df))
      }
      batch_col <- .metadata_manifest_find_col(df, aliases = c("batch", "batch_id", "batch_name", "run_batch"))
      if (!nzchar(batch_col)) {
        batch_col <- "Batch"
        df[[batch_col]] <- rep(NA_character_, nrow(df))
      }
      path_map <- .metadata_manifest_path_map(df)
      original_cols <- colnames(df)
      metadata_cols <- setdiff(original_cols, path_map$path_cols)
      metadata_cols <- unique(metadata_cols[nzchar(metadata_cols)])
      info <- list(
        source_path = normalizePath(as.character(table_path), winslash = "/", mustWork = FALSE),
        delimiter = parsed$delimiter,
        donor_col = donor_col,
        technology_col = technology_col,
        condition_col = condition_col,
        batch_col = batch_col,
        path_map = path_map,
        original_cols = original_cols,
        metadata_cols = metadata_cols,
        path_cols = path_map$path_cols,
        skipped_meta_cols = character(0)
      )
      internal <- list(
        `__manifest_row` = seq_len(nrow(df)),
        `__include_sample` = rep(TRUE, nrow(df)),
        `__object_name` = rep("", nrow(df)),
        `__object_name_auto` = rep(TRUE, nrow(df)),
        `__donor_id` = rep("", nrow(df)),
        `__technology` = rep("", nrow(df)),
        `__cell_set` = rep("filtered", nrow(df)),
        `__input_type` = rep("", nrow(df)),
        `__selected_path` = rep("", nrow(df)),
        `__source_h5` = rep("", nrow(df)),
        `__source_filtered` = rep("", nrow(df)),
        `__source_all` = rep("", nrow(df)),
        `__cell_metadata_path` = rep("", nrow(df)),
        `__qc_metrics_path` = rep("", nrow(df)),
        `__status` = rep("", nrow(df)),
        `__status_detail` = rep("", nrow(df)),
        `__sidecar_status` = rep("", nrow(df)),
        `__source_signature` = rep("", nrow(df)),
        `__auto_duplicate` = rep(FALSE, nrow(df)),
        `__ready` = rep(FALSE, nrow(df))
      )
      for (nm in names(internal)) df[[nm]] <- internal[[nm]]
      list(data = df, info = info)
    }

    .metadata_manifest_row_signature <- function(df, row, info) {
      vals <- vapply(info$metadata_cols, function(cc) {
        if (!(cc %in% colnames(df))) return("")
        value <- df[[cc]][[row]]
        if (length(value) == 0L || is.na(value)) "" else as.character(value)
      }, character(1))
      paste(c(vals, df$`__cell_set`[[row]], df$`__input_type`[[row]], df$`__selected_path`[[row]]), collapse = "\036")
    }

    .metadata_manifest_refresh <- function(df, info, root_path = "") {
      if (is.null(df) || !is.data.frame(df) || !nrow(df)) return(df)
      map <- info$path_map
      for (i in seq_len(nrow(df))) {
        donor <- .metadata_manifest_value(df, i, info$donor_col, default = paste0("sample_", i))
        raw_tech <- .metadata_manifest_value(df, i, info$technology_col, default = "")
        raw_h5 <- if (nzchar(map$h5)) .metadata_manifest_value(df, i, map$h5) else ""
        raw_filtered <- if (nzchar(map$filtered)) .metadata_manifest_value(df, i, map$filtered) else ""
        raw_all <- if (nzchar(map$all_cells)) .metadata_manifest_value(df, i, map$all_cells) else ""
        raw_generic <- if (nzchar(map$generic)) .metadata_manifest_value(df, i, map$generic) else ""
        h5 <- .metadata_manifest_resolve_path(raw_h5, root_path)
        filtered <- .metadata_manifest_matrix_candidate(raw_filtered, root_path, "filtered")
        all_cells <- .metadata_manifest_matrix_candidate(raw_all, root_path, "all_cells")
        generic <- .metadata_manifest_resolve_path(raw_generic, root_path)
        if (nzchar(generic)) {
          g_low <- tolower(generic)
          if (grepl("\\.(h5|hdf5)$", g_low, perl = TRUE)) h5 <- if (nzchar(h5)) h5 else generic
          if (grepl("\\.h5ad$", g_low, perl = TRUE)) h5 <- if (nzchar(h5)) h5 else generic
          if (!nzchar(filtered)) filtered <- .metadata_manifest_find_matrix_dir(generic, "filtered")
          if (!nzchar(all_cells)) all_cells <- .metadata_manifest_find_matrix_dir(generic, "all_cells")
          if (!nzchar(filtered) && !nzchar(all_cells) && .metadata_manifest_is_matrix_dir(generic)) {
            if (grepl("all_cells|raw_", tolower(basename(generic)), perl = TRUE)) all_cells <- generic else filtered <- generic
          }
        }
        tech <- .metadata_manifest_normalize_technology(raw_tech, source_path = paste(c(h5, filtered, all_cells, generic), collapse = " "))
        current_type <- .metadata_manifest_normalize_input_type(df$`__input_type`[[i]], default = "")
        if (!nzchar(current_type)) {
          if (identical(tech, "10x") && nzchar(h5)) current_type <- "h5"
          else if (nzchar(filtered) || nzchar(all_cells)) current_type <- "matrix"
          else if (nzchar(h5)) current_type <- "h5"
          else if (nzchar(generic) && grepl("\\.h5ad$", tolower(generic), perl = TRUE)) current_type <- "h5ad"
        }
        current_set <- .metadata_manifest_normalize_cell_set(df$`__cell_set`[[i]], default = "")
        if (!nzchar(current_set) || !(current_set %in% c("filtered", "all_cells"))) {
          current_set <- if (nzchar(filtered)) "filtered" else if (nzchar(all_cells)) "all_cells" else "filtered"
        }
        selected <- ""
        if (identical(current_type, "h5")) {
          selected <- h5
          current_set <- "filtered"
        } else if (identical(current_type, "matrix")) {
          selected <- if (identical(current_set, "all_cells")) all_cells else filtered
        }
        df$`__donor_id`[[i]] <- donor
        df$`__technology`[[i]] <- tech
        if (isTRUE(df$`__object_name_auto`[[i]]) || !nzchar(as.character(df$`__object_name`[[i]] %||% ""))) {
          df$`__object_name`[[i]] <- .sanitize_sample_name(paste(donor, tech, sep = "__"))
          df$`__object_name_auto`[[i]] <- TRUE
        }
        df$`__cell_set`[[i]] <- current_set
        df$`__input_type`[[i]] <- current_type
        df$`__source_h5`[[i]] <- h5
        df$`__source_filtered`[[i]] <- filtered
        df$`__source_all`[[i]] <- all_cells
        df$`__selected_path`[[i]] <- selected
        df$`__source_signature`[[i]] <- if (nzchar(selected)) normalizePath(selected, winslash = "/", mustWork = FALSE) else ""
        df$`__cell_metadata_path`[[i]] <- .metadata_manifest_sidecar(selected, "cell_metadata.tsv")
        df$`__qc_metrics_path`[[i]] <- .metadata_manifest_sidecar(selected, "qc_metrics.tsv")
        sidecars <- c(
          if (nzchar(df$`__cell_metadata_path`[[i]])) "cell metadata found" else "cell metadata absent",
          if (nzchar(df$`__qc_metrics_path`[[i]])) "QC report found" else "QC report absent"
        )
        df$`__sidecar_status`[[i]] <- paste(sidecars, collapse = "; ")
        base_status <- ""
        if (identical(current_type, "h5ad")) base_status <- "Unsupported in metadata list; use Add H5/H5AD"
        else if (!identical(current_type, "h5") && !identical(current_type, "matrix")) base_status <- "Input type not detected"
        else if (!nzchar(selected)) base_status <- "Selected input path not found"
        else if (identical(current_type, "matrix") && !.metadata_manifest_is_matrix_dir(selected)) base_status <- "Matrix folder is incomplete"
        else if (identical(current_type, "h5") && !file.exists(selected)) base_status <- "H5 file not found"
        df$`__status`[[i]] <- base_status
        df$`__status_detail`[[i]] <- base_status
        df$`__ready`[[i]] <- nzchar(selected) && !nzchar(base_status)
      }

      df$`__auto_duplicate` <- FALSE
      source_keys <- as.character(df$`__source_signature` %||% character(0))
      source_keys <- source_keys[nzchar(source_keys)]
      if (length(source_keys)) {
        for (source in unique(source_keys)) {
          idx <- which(df$`__source_signature` == source)
          if (length(idx) < 2L) next
          signatures <- vapply(idx, function(i) .metadata_manifest_row_signature(df, i, info), character(1))
          if (length(unique(signatures)) == 1L) {
            keep_idx <- idx[[1]]
            for (drop_idx in idx[-1]) {
              df$`__include_sample`[[drop_idx]] <- FALSE
              df$`__auto_duplicate`[[drop_idx]] <- TRUE
              df$`__ready`[[drop_idx]] <- FALSE
              df$`__status`[[drop_idx]] <- sprintf("Exact duplicate; row %d retained", keep_idx)
            }
          } else {
            for (conflict_idx in idx) {
              if (!nzchar(df$`__status`[[conflict_idx]])) {
                df$`__status`[[conflict_idx]] <- "Same source with different metadata; review"
              }
            }
          }
        }
      }

      existing_names <- names(shared_data$all_seurat_objects %||% list())
      active_names <- character(0)
      for (i in seq_len(nrow(df))) {
        if (!isTRUE(df$`__include_sample`[[i]]) || isTRUE(df$`__auto_duplicate`[[i]])) next
        nm <- .sanitize_sample_name(df$`__object_name`[[i]], allow_empty = TRUE)
        if (!nzchar(nm)) {
          df$`__ready`[[i]] <- FALSE
          df$`__status`[[i]] <- "Object name required"
          next
        }
        if (nm %in% existing_names) {
          df$`__ready`[[i]] <- FALSE
          df$`__status`[[i]] <- "Object name already exists; rename or exclude"
        }
        if (nm %in% active_names) {
          df$`__ready`[[i]] <- FALSE
          df$`__status`[[i]] <- "Duplicate object name; rename or exclude"
        }
        active_names <- c(active_names, nm)
      }
      for (i in seq_len(nrow(df))) {
        if (!isTRUE(df$`__include_sample`[[i]]) && !isTRUE(df$`__auto_duplicate`[[i]])) {
          df$`__status`[[i]] <- "Excluded by user"
        }
        if (isTRUE(df$`__include_sample`[[i]]) && isTRUE(df$`__ready`[[i]]) && !nzchar(df$`__status`[[i]])) {
          df$`__status`[[i]] <- "Ready"
        }
      }
      df
    }

    .metadata_manifest_display_cols <- function(df, info) {
      internal <- c(
        "__include_sample", "__object_name", "__donor_id", "__technology", "__cell_set",
        "__input_type", "__selected_path", "__sidecar_status", "__status"
      )
      internal <- internal[internal %in% colnames(df)]
      meta <- as.character(info$metadata_cols %||% character(0))
      paths <- as.character(info$path_cols %||% character(0))
      unique(c(internal, meta[meta %in% colnames(df)], paths[paths %in% colnames(df)]))
    }

    .metadata_manifest_display_frame <- function(df, info) {
      cols <- .metadata_manifest_display_cols(df, info)
      out <- df[, cols, drop = FALSE]
      if ("__selected_path" %in% colnames(out)) out$`__selected_path` <- vapply(out$`__selected_path`, .display_staged_path, character(1))
      for (cc in colnames(out)) {
        if (is.logical(out[[cc]])) out[[cc]][is.na(out[[cc]])] <- FALSE
        if (is.character(out[[cc]])) out[[cc]][is.na(out[[cc]])] <- ""
      }
      out
    }

    .metadata_manifest_col_label <- function(col) {
      labels <- c(
        `__include_sample` = "Include",
        `__object_name` = "Object Name",
        `__donor_id` = "Donor ID",
        `__technology` = "Technology",
        `__cell_set` = "Cell Set",
        `__input_type` = "Input Type",
        `__selected_path` = "Resolved Input",
        `__sidecar_status` = "Sidecars",
        `__status` = "Status"
      )
      if (col %in% names(labels)) unname(labels[[col]]) else tools::toTitleCase(gsub("_", " ", col))
    }

    .h5ad_map_extra_cols <- function(df) {
      if (is.null(df) || !is.data.frame(df) || !ncol(df)) return(character(0))
      cols <- setdiff(colnames(df), .h5ad_map_core_cols)
      cols <- as.character(cols %||% character(0))
      cols[!is.na(cols) & nzchar(cols)]
    }

    .h5ad_map_display_cols <- function(df) {
      preferred <- c("include_sample", "object_name", "sample_name", "condition", "batch", "tissue", "species")
      fixed_tail <- c("split_col", "split_value", "path")
      extras <- .h5ad_map_extra_cols(df)
      extras <- setdiff(extras, c(preferred, fixed_tail))
      extras <- sort(extras)
      out <- c(preferred, extras, fixed_tail)
      out[out %in% colnames(df)]
    }

    .h5ad_detect_group_level_cols <- function(obs, split_vals, reserved_cols = character(0), max_cols = 40L) {
      if (is.null(obs) || !is.data.frame(obs) || !nrow(obs) || !length(split_vals)) return(character(0))
      reserved_norm <- tolower(as.character(reserved_cols %||% character(0)))
      split_levels <- unique(as.character(split_vals %||% character(0)))
      out <- character(0)
      for (cc in colnames(obs)) {
        if (tolower(cc) %in% reserved_norm) next
        ok <- TRUE
        informative <- FALSE
        for (grp in split_levels) {
          idx <- which(as.character(split_vals) == grp)
          vals <- as.character(obs[[cc]][idx] %||% character(0))
          vals <- vals[!is.na(vals) & nzchar(vals)]
          vals <- unique(vals)
          if (length(vals) > 1L) {
            ok <- FALSE
            break
          }
          if (length(vals) == 1L) informative <- TRUE
        }
        if (!ok || !informative) next
        out <- c(out, cc)
        if (length(out) >= as.integer(max_cols)) break
      }
      unique(out)
    }

    .metadata_col_by_alias <- function(df, aliases = character(0), value_pattern = NULL) {
      if (is.null(df) || !is.data.frame(df) || !ncol(df)) return("")
      raw_cols <- colnames(df)
      norm_cols <- tolower(gsub("[^a-z0-9]", "", raw_cols))
      alias_norm <- unique(tolower(gsub("[^a-z0-9]", "", as.character(aliases %||% character(0)))))
      alias_norm <- alias_norm[nzchar(alias_norm)]
      if (length(alias_norm)) {
        for (a in alias_norm) {
          hit <- which(norm_cols == a)
          if (length(hit)) return(raw_cols[[hit[[1]]]])
        }
      }
      if (is.null(value_pattern) || !nzchar(as.character(value_pattern %||% ""))) return("")
      for (cc in raw_cols) {
        vals <- as.character(df[[cc]] %||% character(0))
        vals <- vals[!is.na(vals) & nzchar(vals)]
        if (!length(vals)) next
        if (any(grepl(value_pattern, vals, perl = TRUE, ignore.case = TRUE))) return(cc)
      }
      ""
    }

    .metadata_value_for_group <- function(df, col_name, idx, fallback = "") {
      if (is.null(df) || !is.data.frame(df) || !nrow(df) || !nzchar(as.character(col_name %||% ""))) {
        return(as.character(fallback %||% ""))
      }
      if (!(col_name %in% colnames(df))) return(as.character(fallback %||% ""))
      vals <- as.character(df[[col_name]][idx] %||% character(0))
      vals <- vals[!is.na(vals) & nzchar(vals)]
      vals <- unique(vals)
      if (!length(vals)) return(as.character(fallback %||% ""))
      if (length(vals) == 1L) return(vals[[1]])
      paste(vals, collapse = ";")
    }

    .h5ad_name_composite <- function(gsm = "", condition = "", tissue = "", species = "", fallback = "sample") {
      segs <- c(gsm, condition, tissue, species)
      segs <- vapply(segs, .sanitize_sample_name, character(1), allow_empty = TRUE)
      segs <- segs[nzchar(segs)]
      if (!length(segs)) return(.sanitize_sample_name(fallback))
      .sanitize_sample_name(paste(segs, collapse = "_"))
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
      if (is.null(df) || !is.data.frame(df) || !ncol(df)) return(list(df = df, converted_cols = character(0)))
      out <- df
      converted <- character(0)
      for (cc in colnames(out)) {
        v <- out[[cc]]
        if (is.list(v)) {
          converted <- c(converted, cc)
          out[[cc]] <- vapply(v, function(x) {
            if (length(x) == 0 || all(is.na(x))) return(NA_character_)
            paste(as.character(unlist(x, use.names = FALSE)), collapse = ";")
          }, character(1))
        }
      }
      list(df = out, converted_cols = unique(converted))
    }

    .append_metadata_columns <- function(base_df, add_df, prefix = "h5ad_") {
      out <- base_df
      if (is.null(add_df) || !is.data.frame(add_df) || !ncol(add_df)) return(list(df = out, converted_cols = character(0)))
      coerced <- .coerce_complex_meta_columns(add_df)
      add2 <- coerced$df
      for (cc in colnames(add2)) {
        target <- cc
        if (target %in% colnames(out)) {
          target <- make.unique(c(colnames(out), paste0(prefix, cc)))
          target <- target[[length(target)]]
        }
        out[[target]] <- add2[[cc]]
      }
      list(df = out, converted_cols = coerced$converted_cols)
    }

    .wanlab_seurat_v5_runtime <- function() {
      if (!requireNamespace("SeuratObject", quietly = TRUE)) return(FALSE)
      if (!exists("CreateAssay5Object", where = asNamespace("SeuratObject"), inherits = FALSE)) return(FALSE)
      isTRUE(tryCatch(utils::compareVersion(as.character(utils::packageVersion("SeuratObject")), "5.0.0") >= 0, error = function(e) FALSE))
    }

    .wanlab_open_10x_h5_counts <- function(path) {
      if (!requireNamespace("BPCells", quietly = TRUE)) stop("BPCells is required for direct 10x HDF5 import.")
      if (!requireNamespace("hdf5r", quietly = TRUE)) stop("hdf5r is required for direct 10x HDF5 import.")
      h5 <- hdf5r::H5File$new(path, mode = "r")
      on.exit(try(h5$close_all(), silent = TRUE), add = TRUE)
      feature_types <- tryCatch(
        as.character(h5[["matrix/features/feature_type"]]$read()),
        error = function(e) character(0)
      )
      feature_types <- unique(feature_types[!is.na(feature_types) & nzchar(feature_types)])
      if (!length(feature_types)) feature_types <- NA_character_
      mats <- lapply(feature_types, function(feature_type) {
        BPCells::open_matrix_10x_hdf5(
          path = path,
          feature_type = if (is.na(feature_type)) NULL else feature_type
        )
      })
      if (length(mats) == 1L) return(mats[[1]])
      names(mats) <- feature_types
      mats
    }

    .create_assay_from_counts <- function(mat) {
      if (.wanlab_seurat_v5_runtime()) {
        return(SeuratObject::CreateAssay5Object(counts = mat))
      }
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
      if (inherits(counts, c("dgCMatrix", "matrix", "IterableMatrix"))) {
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
          if (!inherits(mat, c("dgCMatrix", "matrix", "IterableMatrix"))) next
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

    .ensure_qc_metrics_on_import <- function(sobj) {
      if (is.null(sobj) || !inherits(sobj, "Seurat")) return(sobj)
      if (!("RNA" %in% names(sobj@assays))) return(sobj)

      md <- sobj@meta.data
      n_cells <- ncol(sobj)
      if (!is.data.frame(md) || nrow(md) != n_cells) {
        md <- data.frame(row.names = colnames(sobj), stringsAsFactors = FALSE)
      }

      if (!("nCount_RNA" %in% colnames(md))) {
        md$nCount_RNA <- suppressWarnings(as.numeric(sobj$nCount_RNA))
      }
      if (!("nFeature_RNA" %in% colnames(md))) {
        md$nFeature_RNA <- suppressWarnings(as.numeric(sobj$nFeature_RNA))
      }
      if (!("percent.mt" %in% colnames(md))) {
        counts <- tryCatch(Seurat::GetAssayData(sobj, assay = "RNA", slot = "counts"), error = function(e) NULL)
        feat_names <- rownames(sobj)
        mt_rows <- rep(FALSE, length(feat_names))
        if (length(feat_names)) {
          mt_rows <- grepl("^(MT-|mt-)", feat_names)
        }
        feat_md <- tryCatch(sobj[["RNA"]]@meta.features, error = function(e) NULL)
        if (is.data.frame(feat_md) && nrow(feat_md) == length(feat_names) && ncol(feat_md)) {
          for (cc in colnames(feat_md)) {
            vv <- feat_md[[cc]]
            if (!(is.character(vv) || is.factor(vv))) next
            vv <- as.character(vv)
            if (length(vv) != length(feat_names)) next
            mt_rows <- mt_rows | grepl("^(MT-|mt-)", vv)
          }
        }
        if (!is.null(counts) && length(mt_rows) == nrow(counts) && any(mt_rows)) {
          mt_counts <- Matrix::colSums(counts[mt_rows, , drop = FALSE])
          total_counts <- Matrix::colSums(counts)
          pct <- ifelse(total_counts > 0, (mt_counts / total_counts) * 100, 0)
          md$percent.mt <- as.numeric(pct)
        } else {
          md$percent.mt <- rep(0, n_cells)
        }
      }

      if (length(md$nCount_RNA) != n_cells) md$nCount_RNA <- suppressWarnings(as.numeric(sobj$nCount_RNA))
      if (length(md$nFeature_RNA) != n_cells) md$nFeature_RNA <- suppressWarnings(as.numeric(sobj$nFeature_RNA))
      if (length(md$percent.mt) != n_cells) md$percent.mt <- rep(0, n_cells)
      sobj@meta.data <- md
      sobj
    }

    .sidebar_load_one_object <- function(path, type, fallback_name) {
      p <- normalizePath(as.character(path), winslash = "/", mustWork = FALSE)
      tp <- tolower(trimws(as.character(type %||% "")))
      nm <- .sanitize_sample_name(fallback_name)
      if (tp %in% c("h5", "hdf5")) {
        counts <- if (.wanlab_seurat_v5_runtime()) {
          .wanlab_open_10x_h5_counts(p)
        } else {
          Seurat::Read10X_h5(p)
        }
        sobj <- .create_seurat_from_counts(counts = counts, project = nm)
        sobj <- .ensure_qc_metrics_on_import(sobj)
        disk_prep <- .wanlab_prepare_disk_backed_object(sobj, object_name = nm, source_tag = p)
        return(disk_prep$obj)
      }
      if (tp == "matrix") {
        counts <- Seurat::Read10X(p)
        sobj <- .create_seurat_from_counts(counts = counts, project = nm)
        sobj <- .ensure_qc_metrics_on_import(sobj)
        disk_prep <- .wanlab_prepare_disk_backed_object(sobj, object_name = nm, source_tag = p)
        return(disk_prep$obj)
      }
      stop("Unsupported sidebar Seurat import type: ", tp)
    }

    .sidebar_load_h5ad_split <- function(path, staged_name, staged_condition, staged_batch) {
      if (!requireNamespace("zellkonverter", quietly = TRUE)) {
        stop("Missing dependency 'zellkonverter' for .h5ad import. Run Content/run.R bootstrap first.")
      }
      if (!requireNamespace("SummarizedExperiment", quietly = TRUE)) {
        stop("Missing dependency 'SummarizedExperiment' for .h5ad import. Run Content/run.R bootstrap first.")
      }

      p <- normalizePath(as.character(path), winslash = "/", mustWork = FALSE)
      sce <- tryCatch(zellkonverter::readH5AD(p), error = function(e) stop("Failed to read .h5ad file: ", conditionMessage(e)))
      if (is.null(sce)) stop("Failed to read .h5ad file: zellkonverter::readH5AD returned NULL.")

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

      obs <- tryCatch(as.data.frame(SummarizedExperiment::colData(sce)), error = function(e) data.frame())
      if (nrow(obs) != ncol(sce)) obs <- data.frame(row.names = colnames(sce), stringsAsFactors = FALSE)
      if (is.null(rownames(obs)) || length(rownames(obs)) != nrow(obs)) rownames(obs) <- colnames(sce)

      split_col <- .metadata_col_by_alias(
        obs,
        aliases = c("sample", "sample_id", "sampleid", "orig.ident", "orig_ident", "gsm", "geo_accession", "accession")
      )
      if (!nzchar(split_col)) {
        split_col <- .metadata_col_by_alias(obs, aliases = character(0), value_pattern = "^GSM[0-9]+")
      }

      split_vals <- if (nzchar(split_col) && split_col %in% colnames(obs)) {
        as.character(obs[[split_col]] %||% character(nrow(obs)))
      } else {
        rep(as.character(staged_name %||% "sample"), nrow(obs))
      }
      split_vals[is.na(split_vals) | !nzchar(split_vals)] <- as.character(staged_name %||% "sample")
      split_vals <- vapply(split_vals, .sanitize_sample_name, character(1), allow_empty = FALSE)
      split_levels <- unique(split_vals)
      split_idx <- lapply(split_levels, function(v) which(split_vals == v))

      gsm_col <- .metadata_col_by_alias(obs, aliases = c("gsm", "geo_accession", "accession"), value_pattern = "^GSM[0-9]+")
      condition_col <- .metadata_col_by_alias(obs, aliases = c("condition", "group", "treatment", "status", "disease", "phenotype"))
      tissue_col <- .metadata_col_by_alias(obs, aliases = c("tissue", "organ", "region", "site", "anatomy"))
      species_col <- .metadata_col_by_alias(obs, aliases = c("species", "organism", "organism_name", "taxon", "taxon_name"))
      batch_col <- .metadata_col_by_alias(obs, aliases = c("batch", "batch_id", "lane", "library", "library_id", "run", "dataset"))
      reserved_obs <- unique(c(split_col, gsm_col, condition_col, tissue_col, species_col, batch_col))
      extra_group_cols <- .h5ad_detect_group_level_cols(
        obs = obs,
        split_vals = split_vals,
        reserved_cols = reserved_obs
      )
      extra_col_key_map <- setNames(character(0), character(0))
      used_meta_keys <- c(.h5ad_map_core_cols, "name", "type", "qc_status")
      if (length(extra_group_cols)) {
        for (src_col in extra_group_cols) {
          key <- .sanitize_meta_column_name(src_col)
          if (!nzchar(key)) next
          if (key %in% used_meta_keys) key <- paste0("meta_", key)
          key <- make.unique(c(used_meta_keys, key))
          key <- key[[length(key)]]
          used_meta_keys <- c(used_meta_keys, key)
          extra_col_key_map[[key]] <- src_col
        }
      }

      entries <- list()
      map_rows <- list()
      warnings <- character(0)
      for (i in seq_along(split_levels)) {
        grp <- split_levels[[i]]
        idx <- split_idx[[i]]
        sce_sub <- sce[, idx]
        project_name <- .sanitize_sample_name(paste0(staged_name, "_", grp))
        sobj <- tryCatch(
          {
            if (nzchar(data_assay)) {
              Seurat::as.Seurat(sce_sub, counts = counts_assay, data = data_assay, project = project_name)
            } else {
              Seurat::as.Seurat(sce_sub, counts = counts_assay, project = project_name)
            }
          },
          error = function(e) {
            counts <- SummarizedExperiment::assay(sce_sub, counts_assay)
            .create_seurat_from_counts(counts = counts, project = project_name)
          }
        )

        cell_meta <- tryCatch(as.data.frame(SummarizedExperiment::colData(sce_sub)), error = function(e) data.frame())
        if (is.data.frame(cell_meta) && nrow(cell_meta)) {
          cell_meta <- .align_meta_frame(cell_meta, target_names = colnames(sobj), axis_label = "cell")
          appended <- .append_metadata_columns(sobj@meta.data, cell_meta, prefix = "h5ad_")
          sobj@meta.data <- appended$df
          if (length(appended$converted_cols)) {
            warnings <- c(warnings, sprintf("%s: converted complex cell columns -> %s", grp, paste(appended$converted_cols, collapse = ",")))
          }
        }

        if ("RNA" %in% names(sobj@assays)) {
          feature_meta <- tryCatch(as.data.frame(SummarizedExperiment::rowData(sce_sub)), error = function(e) data.frame())
          if (is.data.frame(feature_meta) && nrow(feature_meta) && nrow(sobj[["RNA"]]@meta.features)) {
            feature_meta <- .align_meta_frame(feature_meta, target_names = rownames(sobj[["RNA"]]), axis_label = "feature")
            appended_f <- .append_metadata_columns(sobj[["RNA"]]@meta.features, feature_meta, prefix = "h5ad_")
            sobj[["RNA"]]@meta.features <- appended_f$df
            if (length(appended_f$converted_cols)) {
              warnings <- c(warnings, sprintf("%s: converted complex feature columns -> %s", grp, paste(appended_f$converted_cols, collapse = ",")))
            }
          }
        }

        gsm_val <- .metadata_value_for_group(obs, gsm_col, idx, fallback = "")
        cond_val <- .metadata_value_for_group(obs, condition_col, idx, fallback = as.character(staged_condition %||% "Unknown"))
        tissue_val <- .metadata_value_for_group(obs, tissue_col, idx, fallback = "")
        species_val <- .metadata_value_for_group(obs, species_col, idx, fallback = "")
        batch_val <- .metadata_value_for_group(obs, batch_col, idx, fallback = as.character(staged_batch %||% "Batch1"))
        split_label <- .sanitize_sample_name(grp, allow_empty = FALSE)
        auto_name <- .h5ad_name_composite(
          gsm = gsm_val,
          condition = cond_val,
          tissue = tissue_val,
          species = species_val,
          fallback = paste0(staged_name, "_", split_label)
        )

        key <- paste0("h5ad_", .sanitize_sample_name(staged_name), "_", i)
        sobj <- .ensure_qc_metrics_on_import(sobj)
        disk_prep <- .wanlab_prepare_disk_backed_object(sobj, object_name = project_name, source_tag = p)
        entries[[key]] <- list(
          import_key = key,
          name = auto_name,
          path = p,
          type = "h5ad",
          condition = cond_val,
          batch = batch_val,
          tissue = tissue_val,
          species = species_val,
          split_col = split_col,
          split_value = grp,
          source_cols = list(gsm = gsm_col, condition = condition_col, tissue = tissue_col, species = species_col, batch = batch_col),
          obj = disk_prep$obj
        )

        map_rows[[length(map_rows) + 1L]] <- data.frame(
          import_key = key,
          include_sample = TRUE,
          object_name = auto_name,
          sample_name = auto_name,
          condition = cond_val,
          batch = batch_val,
          tissue = tissue_val,
          species = species_val,
          split_col = as.character(split_col %||% ""),
          split_value = as.character(grp),
          gsm_col = as.character(gsm_col %||% ""),
          condition_col = as.character(condition_col %||% ""),
          tissue_col = as.character(tissue_col %||% ""),
          species_col = as.character(species_col %||% ""),
          batch_col = as.character(batch_col %||% ""),
          path = p,
          stringsAsFactors = FALSE
        )
        if (length(extra_col_key_map)) {
          for (meta_key in names(extra_col_key_map)) {
            src_col <- as.character(extra_col_key_map[[meta_key]] %||% "")
            meta_val <- .metadata_value_for_group(obs, src_col, idx, fallback = "")
            map_rows[[length(map_rows)]][[meta_key]] <- as.character(meta_val %||% "")
          }
        }
      }

      map_df <- if (length(map_rows)) do.call(rbind, map_rows) else data.frame()
      list(
        entries = entries,
        map_df = map_df,
        warnings = unique(warnings),
        counts_assay = counts_assay,
        data_assay = if (nzchar(data_assay)) data_assay else NA_character_,
        split_col = split_col
      )
    }

    .sidebar_build_seurat_entries <- function(seurat_rows, progress = NULL) {
      entries <- list()
      map_df <- data.frame()
      errs <- character(0)
      warnings <- character(0)
      if (is.null(seurat_rows) || !is.data.frame(seurat_rows) || !nrow(seurat_rows)) {
        return(list(entries = entries, map_df = map_df, errors = errs, warnings = warnings))
      }

      total_rows <- nrow(seurat_rows)
      emit_progress <- function(index, label) {
        if (!is.function(progress)) return(invisible(NULL))
        try(progress(index = index, total = total_rows, label = label), silent = TRUE)
        invisible(NULL)
      }

      for (i in seq_len(total_rows)) {
        r <- seurat_rows[i, , drop = FALSE]
        nm <- .sanitize_sample_name(as.character(r$name[[1]] %||% paste0("sample_", i)))
        p <- as.character(r$path[[1]] %||% "")
        tp <- tolower(as.character(r$type[[1]] %||% ""))
        cond <- as.character(r$condition[[1]] %||% "Unknown")
        bat <- as.character(r$batch[[1]] %||% "Batch1")
        emit_progress(
          i - 1L,
          sprintf("Loading sample %d of %d: %s", i, total_rows, nm)
        )
        one <- tryCatch({
          if (tp == "h5ad") {
            .sidebar_load_h5ad_split(
              path = p,
              staged_name = nm,
              staged_condition = cond,
              staged_batch = bat
            )
          } else {
            obj <- .sidebar_load_one_object(path = p, type = tp, fallback_name = nm)
            key <- paste0("std_", nm, "_", i)
            list(
              entries = list(
                list(
                  import_key = key,
                  name = nm,
                  path = p,
                  type = tp,
                  condition = cond,
                  batch = bat,
                  tissue = "",
                  species = "",
                  split_col = "",
                  split_value = "",
                  source_cols = list(),
                  manifest_row_index = if ("manifest_row_index" %in% colnames(r)) as.integer(r$manifest_row_index[[1]] %||% NA_integer_) else NA_integer_,
                  manifest_meta = if ("manifest_meta" %in% colnames(r) && is.list(r$manifest_meta[[1]])) r$manifest_meta[[1]] else list(),
                  manifest_paths = if ("manifest_paths" %in% colnames(r) && is.list(r$manifest_paths[[1]])) r$manifest_paths[[1]] else list(),
                  cell_metadata_path = if ("cell_metadata_path" %in% colnames(r)) as.character(r$cell_metadata_path[[1]] %||% "") else "",
                  qc_metrics_path = if ("qc_metrics_path" %in% colnames(r)) as.character(r$qc_metrics_path[[1]] %||% "") else "",
                  obj = obj
                )
              ),
              map_df = data.frame(),
              warnings = character(0)
            )
          }
        }, error = function(e) {
          errs <<- c(errs, sprintf("%s -> %s", nm, conditionMessage(e)))
          NULL
        })
        if (is.null(one)) {
          emit_progress(
            i,
            sprintf("Sample %d of %d failed: %s", i, total_rows, nm)
          )
          next
        }

        if (is.list(one$entries) && length(one$entries)) {
          cur <- one$entries
          if (tp == "h5ad") {
            names(cur) <- vapply(cur, function(x) as.character(x$import_key %||% ""), character(1))
          } else {
            names(cur) <- vapply(cur, function(x) as.character(x$import_key %||% ""), character(1))
          }
          entries <- c(entries, cur)
        }
        if (is.data.frame(one$map_df) && nrow(one$map_df)) {
          map_df <- .bind_rows_safe(map_df, one$map_df)
        }
        warnings <- c(warnings, as.character(one$warnings %||% character(0)))
        emit_progress(
          i,
          sprintf("Loaded sample %d of %d: %s", i, total_rows, nm)
        )
      }
      list(
        entries = entries,
        map_df = map_df,
        errors = unique(errs),
        warnings = unique(as.character(warnings %||% character(0)))
      )
    }

    .ensure_unique_object_name <- function(base_name, reg, used_names) {
      nm <- .sanitize_sample_name(base_name)
      if (!nzchar(nm)) nm <- "sample"
      cand <- nm
      i <- 1L
      while (!is.null(reg[[cand]]) || cand %in% used_names) {
        i <- i + 1L
        cand <- paste0(nm, "_", i)
      }
      cand
    }

    .show_h5ad_mapping_modal <- function(map_df) {
      if (is.null(map_df) || !is.data.frame(map_df) || !nrow(map_df)) return(invisible(NULL))
      h5ad_last_selected_keys(character(0))
      showModal(htmltools::tagAppendAttributes(modalDialog(
        title = "Review .h5ad sample mapping",
        size = "l",
        easyClose = FALSE,
        tags$style(HTML("
          .h5ad-map-modal .modal-dialog {
            width: 98vw !important;
            max-width: 98vw !important;
            margin: 1rem auto !important;
          }
          .h5ad-map-modal .modal-content {
            max-height: 92vh;
          }
          .h5ad-map-modal .modal-body {
            overflow-x: auto;
            overflow-y: auto;
          }
          .h5ad-map-modal .h5ad-map-table-wrap {
            width: 100%;
            overflow-x: auto;
            overflow-y: hidden;
          }
          .h5ad-map-modal .h5ad-map-table-wrap table.dataTable {
            width: max-content !important;
            min-width: 100% !important;
          }
          .h5ad-map-modal .h5ad-map-table-wrap table.dataTable thead th,
          .h5ad-map-modal .h5ad-map-table-wrap table.dataTable tbody td {
            white-space: nowrap !important;
            word-break: normal !important;
            min-width: 110px;
          }
          .h5ad-map-modal .h5ad-include-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.2px;
          }
          .h5ad-map-modal .h5ad-include-yes {
            color: #0f5132;
            background: #d1e7dd;
            border: 1px solid #badbcc;
          }
          .h5ad-map-modal .h5ad-include-no {
            color: #842029;
            background: #f8d7da;
            border: 1px solid #f5c2c7;
          }
          .h5ad-map-modal table.dataTable tbody tr.h5ad-row-excluded td {
            opacity: 0.55;
            background-color: #f7f7f7 !important;
          }
          .h5ad-map-modal .h5ad-map-controls {
            display: flex;
            gap: 20px;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 10px;
          }
          .h5ad-map-modal .h5ad-map-control-group {
            flex: 1 1 0;
            min-width: 360px;
          }
          .h5ad-map-modal .h5ad-map-control-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
          }
          .h5ad-map-modal .h5ad-map-inline-row {
            display: flex;
            align-items: center;
            gap: 10px;
          }
          .h5ad-map-modal .h5ad-map-inline-row .form-group {
            margin-bottom: 0 !important;
            flex: 1 1 auto;
          }
          .h5ad-map-modal .h5ad-map-inline-row .btn {
            white-space: nowrap;
          }
          @media (max-width: 1200px) {
            .h5ad-map-modal .h5ad-map-controls {
              flex-direction: column;
              align-items: stretch;
            }
            .h5ad-map-modal .h5ad-map-control-group {
              min-width: 0;
              width: 100%;
            }
          }
        ")),
        tags$p("Imported .h5ad contains sample-level splits. Review and edit naming/metadata before commit."),
        tags$p(style = "margin-top:-6px; color:#64748b; font-size:12px;", "Tip: click the Include cell to toggle a sample on/off."),
        div(
          class = "h5ad-map-controls",
          div(
            class = "h5ad-map-control-group",
            tags$label(`for` = ns("h5ad_new_col_name"), "Add metadata column"),
            div(
              class = "h5ad-map-inline-row",
              textInput(ns("h5ad_new_col_name"), NULL, value = "", placeholder = "e.g., donor, cohort, platform"),
              actionButton(ns("h5ad_add_col_btn"), "Add Column", class = "btn btn-default")
            )
          ),
          div(
            class = "h5ad-map-control-group",
            tags$label("Remove metadata column"),
            uiOutput(ns("h5ad_remove_col_ui"))
          )
        ),
        div(class = "h5ad-map-table-wrap", DTOutput(ns("h5ad_import_map_table"))),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(ns("h5ad_import_confirm_btn"), "Confirm Import", class = "btn btn-primary")
        )
      ), class = "h5ad-map-modal"))
      invisible(NULL)
    }

    .generic_cellranger_token <- function(x) {
      x <- tolower(as.character(x %||% ""))
      generic <- c(
        "outs", "count", "counts", "filtered_feature_bc_matrix", "raw_feature_bc_matrix",
        "filtered_gene_bc_matrices", "raw_gene_bc_matrices", "filtered_gene_bc_matrix",
        "raw_gene_bc_matrix", "matrix", "matrices", "sample_filtered_feature_bc_matrix",
        "sample_raw_feature_bc_matrix", "feature_bc_matrix", "cellranger", "multi",
        "per_sample_outs", "analysis", "tmp", "temp"
      )
      x %in% generic
    }

    .sample_name_from_path <- function(path, type = "h5") {
      p <- as.character(path %||% "")
      if (!nzchar(p)) return("sample")
      p_norm <- gsub("\\\\", "/", p)
      parts <- strsplit(p_norm, "/", fixed = TRUE)[[1]]
      parts <- parts[nzchar(parts)]
      base_raw <- if (length(parts)) parts[[length(parts)]] else p_norm
      base_noext <- tools::file_path_sans_ext(base_raw)
      low <- tolower(base_noext)

      # Known Cell Ranger core names; keep user-provided prefix/suffix around them.
      pat <- "(filtered_feature_bc_matrix|raw_feature_bc_matrix|filtered_gene_bc_matrices|raw_gene_bc_matrices|filtered_gene_bc_matrix|raw_gene_bc_matrix|feature_bc_matrix)"
      m <- regexec(pat, low, perl = TRUE)
      reg <- regmatches(low, m)[[1]]
      candidate <- ""
      if (length(reg) > 0) {
        core <- reg[[1]]
        loc <- regexpr(core, low, fixed = TRUE)
        st <- as.integer(loc)
        en <- st + nchar(core) - 1L
        pre <- if (st > 1L) substr(base_noext, 1L, st - 1L) else ""
        suf <- if (en < nchar(base_noext)) substr(base_noext, en + 1L, nchar(base_noext)) else ""
        candidate <- paste0(pre, "_", suf)
      } else {
        candidate <- base_noext
      }

      candidate <- .sanitize_sample_name(candidate, allow_empty = TRUE)
      if (nzchar(candidate) && !.generic_cellranger_token(candidate)) return(candidate)

      # Fall back to nearest non-CellRanger parent folder.
      if (length(parts) >= 2) {
        for (k in seq(length(parts) - 1L, 1L, by = -1L)) {
          nm <- .sanitize_sample_name(parts[[k]], allow_empty = TRUE)
          if (nzchar(nm) && !.generic_cellranger_token(nm)) return(nm)
        }
      }
      "sample"
    }

    .display_staged_path <- function(path) {
      p <- as.character(path %||% "")
      if (!nzchar(p)) return("")
      b <- basename(p)
      b2 <- sub("^[0-9]{8}_[0-9]{6}_[A-Za-z0-9]+_", "", b, perl = TRUE)
      if (nzchar(b2) && !identical(b2, b)) {
        return(paste0("[uploaded] ", b2))
      }
      p
    }

    .find_outs_root <- function(path) {
      p <- as.character(path %||% "")
      if (!nzchar(p)) return("")
      cur <- if (dir.exists(p)) p else dirname(p)
      cur <- normalizePath(cur, winslash = "/", mustWork = FALSE)
      if (basename(cur) == "outs" && dir.exists(cur)) return(cur)

      for (i in seq_len(10)) {
        c_outs <- file.path(cur, "outs")
        if (dir.exists(c_outs)) return(normalizePath(c_outs, winslash = "/", mustWork = FALSE))
        if (basename(cur) == "outs" && dir.exists(cur)) return(cur)
        parent <- dirname(cur)
        if (!nzchar(parent) || identical(parent, cur)) break
        cur <- parent
      }
      ""
    }

    .extract_per_sample_hint <- function(path) {
      p <- gsub("\\\\", "/", as.character(path %||% ""))
      parts <- strsplit(p, "/", fixed = TRUE)[[1]]
      parts <- parts[nzchar(parts)]
      idx <- match("per_sample_outs", parts)
      if (is.na(idx) || idx >= length(parts)) return("")
      as.character(parts[[idx + 1]])
    }

    .pick_vdj_annotation_file <- function(vdj_dir) {
      if (!dir.exists(vdj_dir)) return(list(path = "", picked = "", reason = "missing_dir"))
      .read_vdj_df <- function(path) {
        ext <- tolower(tools::file_ext(path))
        if (identical(ext, "csv")) return(utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE))
        utils::read.delim(path, stringsAsFactors = FALSE, check.names = FALSE)
      }
      .has_required_cols <- function(df) {
        if (is.null(df) || !is.data.frame(df) || !nrow(df)) return(FALSE)
        lo <- tolower(colnames(df))
        has_bc <- any(lo %in% c("barcode", "cell", "cell_id", "barcodes", "bc", "cell_barcode", "barcode_id"))
        has_clone <- any(lo %in% c("raw_clonotype_id", "clonotype_id", "clone_id", "cdr3", "cdr3s_aa", "cdr3_aa"))
        isTRUE(has_bc && has_clone)
      }
      cands <- c("filtered_contig_annotations.csv", "all_contig_annotations.csv")
      invalid <- character(0)
      for (nm in cands) {
        p <- file.path(vdj_dir, nm)
        if (!file.exists(p)) next
        df <- tryCatch(.read_vdj_df(p), error = function(e) NULL)
        if (.has_required_cols(df)) {
          return(list(
            path = normalizePath(p, winslash = "/", mustWork = FALSE),
            picked = nm,
            reason = "valid"
          ))
        }
        invalid <- c(invalid, nm)
      }
      list(path = "", picked = "", reason = if (length(invalid)) paste0("invalid_or_empty:", paste(invalid, collapse = ",")) else "not_found")
    }

    .collect_vdj_candidates_for_sample <- function(sample_name, sample_path) {
      outs_root <- .find_outs_root(sample_path)
      if (!nzchar(outs_root) || !dir.exists(outs_root)) return(data.frame())

      .norm_name <- function(x) {
        x <- tolower(as.character(x %||% ""))
        gsub("[^a-z0-9]", "", x)
      }

      rows <- list()
      invalid_reasons <- character(0)
      push_row <- function(chain, pick_obj, source_level, source_dir) {
        file_path <- as.character(pick_obj$path %||% "")
        if (!nzchar(file_path) || !file.exists(file_path)) {
          rsn <- as.character(pick_obj$reason %||% "")
          if (nzchar(rsn) && !identical(rsn, "missing_dir") && !identical(rsn, "not_found")) {
            invalid_reasons <<- c(invalid_reasons, sprintf("%s %s (%s)", as.character(sample_name), as.character(chain), rsn))
          }
          return(invisible(NULL))
        }
        rows[[length(rows) + 1L]] <<- data.frame(
          sample_name = as.character(sample_name),
          chain = as.character(chain),
          file_path = as.character(file_path),
          source_level = as.integer(source_level),
          source_dir = as.character(source_dir),
          picked_name = as.character(pick_obj$picked %||% ""),
          stringsAsFactors = FALSE
        )
      }

      # Per-sample outputs are preferred when available.
      per_sample_root <- file.path(outs_root, "per_sample_outs")
      if (dir.exists(per_sample_root)) {
        hint <- .extract_per_sample_hint(sample_path)
        hint_pool_raw <- unique(c(
          as.character(hint),
          as.character(sample_name),
          basename(dirname(as.character(sample_path %||% "")))
        ))
        hint_pool <- hint_pool_raw[nzchar(hint_pool_raw)]

        sample_dirs <- character(0)
        for (h in hint_pool) {
          p <- file.path(per_sample_root, h)
          if (dir.exists(p)) sample_dirs <- c(sample_dirs, normalizePath(p, winslash = "/", mustWork = FALSE))
        }
        if (!length(sample_dirs)) {
          all_dirs <- list.dirs(per_sample_root, recursive = FALSE, full.names = TRUE)
          all_dirs <- all_dirs[file.info(all_dirs)$isdir %in% TRUE]
          if (length(all_dirs)) {
            dir_keys <- .norm_name(basename(all_dirs))
            hint_keys <- unique(.norm_name(hint_pool_raw))
            hint_keys <- hint_keys[nzchar(hint_keys)]
            hit_idx <- integer(0)
            for (i in seq_along(dir_keys)) {
              dk <- dir_keys[[i]]
              if (!nzchar(dk)) next
              matched <- FALSE
              for (hk in hint_keys) {
                if (!nzchar(hk)) next
                if (identical(dk, hk) || grepl(hk, dk, fixed = TRUE) || grepl(dk, hk, fixed = TRUE)) {
                  matched <- TRUE
                  break
                }
              }
              if (matched) hit_idx <- c(hit_idx, i)
            }
            hit_idx <- unique(hit_idx)
            if (length(hit_idx) == 1L) {
              sample_dirs <- normalizePath(all_dirs[[hit_idx]], winslash = "/", mustWork = FALSE)
            }
          }
        }
        sample_dirs <- unique(sample_dirs)

        for (sd in sample_dirs) {
          t1 <- .pick_vdj_annotation_file(file.path(sd, "vdj_t"))
          t2 <- .pick_vdj_annotation_file(file.path(sd, "vdj_t_gd"))
          b1 <- .pick_vdj_annotation_file(file.path(sd, "vdj_b"))
          push_row("TCR", t1, 1L, file.path(sd, "vdj_t"))
          push_row("TCR", t2, 1L, file.path(sd, "vdj_t_gd"))
          push_row("BCR", b1, 1L, file.path(sd, "vdj_b"))
        }
      }

      # Run-level outputs are only used when per_sample_outs is not present.
      # This avoids assigning the same run-level VDJ file to multiple samples.
      if (!dir.exists(per_sample_root)) {
        push_row("TCR", .pick_vdj_annotation_file(file.path(outs_root, "vdj_t")), 2L, file.path(outs_root, "vdj_t"))
        push_row("TCR", .pick_vdj_annotation_file(file.path(outs_root, "vdj_t_gd")), 2L, file.path(outs_root, "vdj_t_gd"))
        push_row("BCR", .pick_vdj_annotation_file(file.path(outs_root, "vdj_b")), 2L, file.path(outs_root, "vdj_b"))
      }

      if (!length(rows)) return(data.frame())
      out <- do.call(rbind, rows)
      out <- out[order(out$source_level, out$sample_name, out$chain), , drop = FALSE]
      # Keep best candidate per sample+chain.
      key <- paste(out$sample_name, out$chain, sep = "::")
      out <- out[!duplicated(key), , drop = FALSE]
      if (length(invalid_reasons)) {
        shared_data$vdj_detect_invalid_reasons <- unique(c(as.character(shared_data$vdj_detect_invalid_reasons %||% character(0)), invalid_reasons))
      }
      out
    }

    .detect_vdj_candidates <- function(seurat_rows) {
      if (is.null(seurat_rows) || !is.data.frame(seurat_rows) || !nrow(seurat_rows)) return(data.frame())
      rows <- lapply(seq_len(nrow(seurat_rows)), function(i) {
        .collect_vdj_candidates_for_sample(
          sample_name = as.character(seurat_rows$name[[i]] %||% ""),
          sample_path = as.character(seurat_rows$path[[i]] %||% "")
        )
      })
      rows <- Filter(function(x) is.data.frame(x) && nrow(x) > 0, rows)
      if (!length(rows)) return(data.frame())
      out <- do.call(rbind, rows)
      out <- out[!duplicated(paste(out$sample_name, out$chain, out$file_path, sep = "::")), , drop = FALSE]
      out$id <- paste0("vdj_", seq_len(nrow(out)))
      out$label <- sprintf(
        "%s - %s (%s)",
        out$sample_name, out$chain, ifelse(nzchar(as.character(out$picked_name %||% "")), as.character(out$picked_name), basename(out$file_path))
      )
      out
    }

    .show_vdj_detect_modal <- function(cands) {
      if (is.null(cands) || !is.data.frame(cands) || !nrow(cands)) return(invisible(NULL))
      choice_names <- lapply(seq_len(nrow(cands)), function(i) {
        tags$div(
          class = "vdj-choice-box",
          tags$div(class = "vdj-choice-main", sprintf("%s - %s", cands$sample_name[[i]], cands$chain[[i]])),
          tags$div(class = "vdj-choice-sub", basename(cands$file_path[[i]]))
        )
      })
      choice_values <- as.character(cands$id)
      showModal(modalDialog(
        title = "VDJ files detected",
        easyClose = FALSE,
        size = "l",
        tags$style(HTML("
          .vdj-detect-modal .shiny-input-checkboxgroup {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 8px 10px;
            align-items: stretch;
          }
          .vdj-detect-modal .checkbox { margin: 0 0 8px 0; }
          .vdj-detect-modal .checkbox:last-child { margin-bottom: 8px; }
          .vdj-detect-modal .checkbox label {
            width: 100%;
            display: flex;
            align-items: flex-start;
            gap: 8px;
            border: 1px solid #cfd8e3;
            border-radius: 8px;
            padding: 8px 10px;
            background: #f8fbff;
            font-weight: 500;
            color: #0f172a;
            font-size: 14px;
          }
          .vdj-detect-modal .checkbox input[type='checkbox'] {
            margin-top: 2px;
            position: static;
            width: 18px;
            height: 18px;
            min-width: 18px;
            min-height: 18px;
            flex: 0 0 18px;
          }
          .vdj-detect-modal .checkbox input[type='checkbox']:checked + .vdj-choice-box {
            font-weight: 600;
          }
          .vdj-detect-modal .vdj-choice-box { display: block; flex: 1 1 auto; }
          .vdj-detect-modal .vdj-choice-main {
            font-weight: 700;
            color: #0f172a;
            line-height: 1.2;
          }
          .vdj-detect-modal .vdj-choice-sub {
            margin-top: 2px;
            color: #475569;
            font-size: 12px;
            line-height: 1.2;
          }
          @media (max-width: 900px) {
            .vdj-detect-modal .shiny-input-checkboxgroup {
              grid-template-columns: 1fr;
            }
          }
        ")),
        p("Cell Ranger VDJ result files were found near imported samples. Select which chains to incorporate."),
        div(
          class = "vdj-detect-modal",
          checkboxGroupInput(
            ns("vdj_detect_select"),
            "Include chains",
            choiceNames = choice_names,
            choiceValues = choice_values,
            selected = choice_values
          )
        ),
        tags$small("Detected files: prefer filtered_contig_annotations.csv; fallback all_contig_annotations.csv only when filtered is empty/invalid."),
        footer = tagList(
          modalButton("Skip"),
          actionButton(ns("vdj_detect_confirm"), "Incorporate Selected", class = "btn btn-primary")
        )
      ))
      invisible(NULL)
    }

    roots <- c(Home = fs::path_home(), Root = "/")
    if (.Platform$OS.type == "windows") {
      roots <- c(Home = fs::path_home(), C = "C:/")
      win_dl <- file.path(Sys.getenv("USERPROFILE", unset = ""), "Downloads")
      if (nzchar(win_dl) && dir.exists(win_dl)) roots <- c(roots, Downloads = win_dl)
      win_docs <- file.path(Sys.getenv("USERPROFILE", unset = ""), "Documents")
      if (nzchar(win_docs) && dir.exists(win_docs)) roots <- c(roots, Documents = win_docs)
      win_desktop <- file.path(Sys.getenv("USERPROFILE", unset = ""), "Desktop")
      if (nzchar(win_desktop) && dir.exists(win_desktop)) roots <- c(roots, Desktop = win_desktop)
      drv <- tryCatch(list.files("/", pattern = "^[A-Za-z]:$", full.names = TRUE), error = function(e) character(0))
      if (length(drv)) {
        drv <- drv[dir.exists(drv)]
        if (length(drv)) roots <- c(roots, stats::setNames(drv, gsub("[/\\\\]$", "", toupper(basename(drv)))))
      }
    } else {
      unix_dl <- file.path(fs::path_home(), "Downloads")
      if (dir.exists(unix_dl)) roots <- c(roots, Downloads = unix_dl)
      unix_docs <- file.path(fs::path_home(), "Documents")
      if (dir.exists(unix_docs)) roots <- c(roots, Documents = unix_docs)
      unix_desktop <- file.path(fs::path_home(), "Desktop")
      if (dir.exists(unix_desktop)) roots <- c(roots, Desktop = unix_desktop)
      if (dir.exists("/Volumes")) roots <- c(roots, Volumes = "/Volumes")
      if (dir.exists("/mnt")) roots <- c(roots, mnt = "/mnt")
    }

    volumes <- getOption("shiny_app_volumes", default = roots)
    volumes <- as.character(volumes)
    vol_names <- names(volumes)
    keep_vol <- nzchar(volumes) & dir.exists(volumes)
    volumes <- volumes[keep_vol]
    if (!is.null(vol_names) && length(vol_names) >= length(keep_vol)) {
      names(volumes) <- vol_names[keep_vol]
    }
    if (!length(volumes)) {
      volumes <- c(Home = fs::path_home())
    }

    .label_volume <- function(path, idx) {
      p <- as.character(path %||% "")
      if (!nzchar(p)) return(paste0("Volume", idx))
      if (.Platform$OS.type == "windows" && grepl("^[A-Za-z]:[/\\]?$", p)) {
        return(sub("[/\\]$", "", toupper(p)))
      }
      hp <- tryCatch(normalizePath(fs::path_home(), winslash = "/", mustWork = FALSE), error = function(e) "")
      np <- tryCatch(normalizePath(p, winslash = "/", mustWork = FALSE), error = function(e) p)
      if (nzchar(hp) && identical(np, hp)) return("Home")
      if (np == "/") return("Root")
      b <- basename(np)
      if (!nzchar(b) || identical(b, ".") || identical(b, "/")) b <- np
      b
    }

    nm <- names(volumes)
    if (is.null(nm) || any(!nzchar(nm))) {
      names(volumes) <- vapply(seq_along(volumes), function(i) .label_volume(volumes[[i]], i), character(1))
      names(volumes) <- make.unique(names(volumes))
    }

    demo_from_here <- tryCatch(here::here("demo"), error = function(e) "")
    demo_candidates <- c(
      getOption("shiny_demo_root", default = ""),
      Sys.getenv("SHINY_DEMO_ROOT", unset = ""),
      demo_from_here,
      file.path(getwd(), "demo"),
      file.path(getwd(), "Content", "demo")
    )
    demo_candidates <- unique(demo_candidates[nzchar(demo_candidates)])
    demo_dirs <- demo_candidates[dir.exists(demo_candidates)]
    demo_root <- if (length(demo_dirs)) normalizePath(demo_dirs[[1]], mustWork = TRUE) else NULL

    has_demo <- "Demo" %in% names(volumes)
    if (!is.null(demo_root) && !has_demo) volumes <- c(volumes, Demo = demo_root)

    shinyFileChoose(input, "real_h5_file_btn", roots = volumes, session = session, filetypes = c("h5", "hdf5", "h5ad"))
    shinyDirChoose(input, "real_matrix_dir_btn", roots = volumes, session = session)
    shinyFileChoose(input, "real_csv_file_btn", roots = volumes, session = session, filetypes = c("csv", "tsv", "txt"))
    shinyFileChoose(input, "real_metadata_file_btn", roots = volumes, session = session, filetypes = c("csv", "tsv", "txt"))
    shinyDirChoose(input, "real_metadata_root_btn", roots = volumes, session = session)
    shinyFileChoose(input, "real_atac_file_btn", roots = volumes, session = session, filetypes = c("tsv", "gz", "bgz", "tbi"))

    observeEvent(input$proxy_h5_btn, {
      shinyjs::runjs(sprintf(
        "var el=document.getElementById('%s'); if(el){ try{ var st=JSON.parse(localStorage.getItem('wanlab_shinyfiles_sort_v4')||'{\\\"column\\\":\\\"Created\\\",\\\"dir\\\":\\\"descending\\\"}'); $(el).data('sort',st.column||'Created').data('sortDir',st.dir||'descending'); }catch(e){} el.click(); }",
        ns("real_h5_file_btn")
      ))
    })
    observeEvent(input$proxy_dir_btn, {
      shinyjs::runjs(sprintf("var el=document.getElementById('%s'); if(el){ try{ var st=JSON.parse(localStorage.getItem('wanlab_shinyfiles_sort_v4')||'{\\\"column\\\":\\\"Created\\\",\\\"dir\\\":\\\"descending\\\"}'); $(el).data('sort',st.column||'Created').data('sortDir',st.dir||'descending'); }catch(e){} el.click(); }", ns("real_matrix_dir_btn")))
    })
    observeEvent(input$proxy_csv_btn, {
      shinyjs::runjs(sprintf(
        "var el=document.getElementById('%s'); if(el){ try{ var st=JSON.parse(localStorage.getItem('wanlab_shinyfiles_sort_v4')||'{\\\"column\\\":\\\"Created\\\",\\\"dir\\\":\\\"descending\\\"}'); $(el).data('sort',st.column||'Created').data('sortDir',st.dir||'descending'); }catch(e){} el.click(); }",
        ns("real_csv_file_btn")
      ))
    })
    observeEvent(input$proxy_metadata_btn, {
      shinyjs::runjs(sprintf(
        "var el=document.getElementById('%s'); if(el){ try{ var st=JSON.parse(localStorage.getItem('wanlab_shinyfiles_sort_v4')||'{\\\"column\\\":\\\"Created\\\",\\\"dir\\\":\\\"descending\\\"}'); $(el).data('sort',st.column||'Created').data('sortDir',st.dir||'descending'); }catch(e){} el.click(); }",
        ns("real_metadata_file_btn")
      ))
    })
    observeEvent(input$metadata_manifest_choose_root_btn, {
      shinyjs::runjs(sprintf("var el=document.getElementById('%s'); if(el){ el.click(); }", ns("real_metadata_root_btn")))
    })
    observeEvent(input$proxy_atac_btn, {
      shinyjs::runjs(sprintf(
        "var el=document.getElementById('%s'); if(el){ try{ var st=JSON.parse(localStorage.getItem('wanlab_shinyfiles_sort_v4')||'{\\\"column\\\":\\\"Created\\\",\\\"dir\\\":\\\"descending\\\"}'); $(el).data('sort',st.column||'Created').data('sortDir',st.dir||'descending'); }catch(e){} el.click(); }",
        ns("real_atac_file_btn")
      ))
    })

    observe({
      has_env <- !is.null(shared_data$active_environment$name) && nzchar(shared_data$active_environment$name)
      import_btn <- paste0("#", ns("btn_import_modal"))
      save_btn <- paste0("#", ns("btn_save_workspace"))
      if (has_env) {
        shinyjs::enable(selector = import_btn)
        shinyjs::enable(selector = save_btn)
        shinyjs::removeClass(selector = save_btn, class = "workspace-btn-disabled")
        shinyjs::addClass(selector = save_btn, class = "workspace-btn-ready")
      } else {
        shinyjs::disable(selector = import_btn)
        shinyjs::disable(selector = save_btn)
        shinyjs::removeClass(selector = save_btn, class = "workspace-btn-ready")
        shinyjs::addClass(selector = save_btn, class = "workspace-btn-disabled")
      }
    })

    observe({
      ss <- shared_data$full_sample_sheet
      if (is.null(ss) || !is.data.frame(ss) || !nrow(ss)) return(invisible(NULL))
      if (!all(c("name", "path") %in% colnames(ss))) return(invisible(NULL))

      cands <- .detect_vdj_candidates(.safe_select_cols(ss, c("name", "path"), default = ""))
      if (is.null(cands) || !is.data.frame(cands) || !nrow(cands)) {
        .vdj_log("auto-detect from full_sample_sheet: no VDJ candidates.",
                 "sample_n=", nrow(ss),
                 "sample_names=", paste(head(as.character(ss$name), 6), collapse = ","))
        return(invisible(NULL))
      }
      .vdj_log("auto-detect from full_sample_sheet: found candidates.",
               "cand_n=", nrow(cands),
               "samples=", paste(unique(as.character(cands$sample_name)), collapse = ","),
               "paths=", paste(head(as.character(cands$file_path), 4), collapse = " | "))
      vdj_detect_candidates(cands)
      .vdj_log("auto-detect cached candidates in-session only.", "n=", nrow(cands))
      invisible(NULL)
    })

    observe({
      reg <- shared_data$all_seurat_objects %||% list()
      tab <- shared_data$imported_tabular_files
      has_objects <- length(reg) > 0
      has_tabular <- is.data.frame(tab) && nrow(tab) > 0
      is_empty <- !(has_objects || has_tabular)
      updateActionButton(
        session,
        "btn_save_workspace",
        label = if (is_empty) "Load Workspace" else "Save Workspace",
        icon = icon(if (is_empty) "folder-open" else "save")
      )
    })

    output$workspace_tip_ui <- renderUI({
      reg <- shared_data$all_seurat_objects %||% list()
      tab <- shared_data$imported_tabular_files
      has_env <- !is.null(shared_data$active_environment$name) && nzchar(shared_data$active_environment$name)
      has_objects <- length(reg) > 0
      has_tabular <- is.data.frame(tab) && nrow(tab) > 0
      is_empty <- !(has_objects || has_tabular)

      tip <- if (!has_env) {
        "Please set up an environment before loading a workspace."
      } else if (is_empty) {
        "Load a previous workspace (.rds) file here."
      } else {
        tagList(
          tags$b("REMEMBER TO SAVE YOUR WORKSPACE HERE."),
          " Loupe files cannot be edited after export."
        )
      }

      div(class = "workspace-tip", tip)
    })

    .open_import_modal <- function() {
      env_name <- shared_data$active_environment$name
      if (is.null(env_name) || !nzchar(env_name)) {
        showNotification("Please select and prepare environment first.", type = "error")
        return(invisible(FALSE))
      }
      showModal(import_modal_content(ns))
      invisible(TRUE)
    }

    observeEvent(input$btn_import_modal, {
      .open_import_modal()
    })

    observeEvent(shared_data$request_import_modal, {
      .open_import_modal()
    }, ignoreInit = TRUE)

    .persist_uploads <- function(upload_df) {
      if (is.null(upload_df) || !is.data.frame(upload_df) || !nrow(upload_df)) {
        return(data.frame(name = character(0), datapath = character(0), stringsAsFactors = FALSE))
      }
      up_root <- file.path(tempdir(), "wanlab_uploads")
      dir.create(up_root, recursive = TRUE, showWarnings = FALSE)
      out_paths <- character(nrow(upload_df))
      out_names <- as.character(upload_df$name %||% basename(as.character(upload_df$datapath)))
      for (i in seq_len(nrow(upload_df))) {
        src <- as.character(upload_df$datapath[i] %||% "")
        nm <- as.character(upload_df$name[i] %||% basename(src))
        if (!nzchar(src) || !file.exists(src)) {
          out_paths[i] <- ""
          next
        }
        stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
        token <- paste0(sample(c(letters, LETTERS, 0:9), 8, replace = TRUE), collapse = "")
        dst <- file.path(up_root, paste0(stamp, "_", token, "_", nm))
        ok <- tryCatch(file.copy(src, dst, overwrite = TRUE), error = function(e) FALSE)
        out_paths[i] <- if (isTRUE(ok) && file.exists(dst)) normalizePath(dst, mustWork = TRUE) else ""
      }
      keep <- nzchar(out_paths)
      data.frame(name = out_names[keep], datapath = out_paths[keep], stringsAsFactors = FALSE)
    }

    observeEvent(input$real_h5_file_btn, {
      overlay_show("Processing selected H5/H5AD file(s)…", loader = "import")
      on.exit(overlay_hide(), add = TRUE)
      sel <- input$real_h5_file_btn
      req(!is.null(sel))
      files <- parseFilePaths(volumes, sel)
      req(is.data.frame(files), nrow(files) > 0)
      ext <- tolower(tools::file_ext(as.character(files$datapath)))
      keep <- ext %in% c("h5", "hdf5", "h5ad")
      if (!any(keep)) {
        showNotification("No .h5/.hdf5/.h5ad file selected.", type = "warning")
        return()
      }
      files <- files[keep, , drop = FALSE]
      nm <- vapply(files$datapath, .sample_name_from_path, character(1), type = "h5")
      file_type <- ifelse(ext[keep] == "h5ad", "h5ad", "h5")
      .append_staged(data.frame(
        id = paste0("s_", as.integer(Sys.time()), "_", seq_len(nrow(files))),
        name = nm,
        path = as.character(files$datapath),
        type = file_type,
        condition = "Unknown",
        batch = "Batch1",
        stringsAsFactors = FALSE
      ))
    })

    observeEvent(input$real_matrix_dir_btn, {
      overlay_show("Processing selected matrix folder…", loader = "import")
      on.exit(overlay_hide(), add = TRUE)
      req(is.list(input$real_matrix_dir_btn))
      dirs <- parseDirPath(volumes, input$real_matrix_dir_btn)
      if (length(dirs) > 0) {
        nm <- vapply(dirs, .sample_name_from_path, character(1), type = "matrix")
        .append_staged(data.frame(
          id = paste0("s_", as.integer(Sys.time()), "_", seq_along(dirs)),
          name = nm,
          path = dirs,
          type = "matrix",
          condition = "Unknown",
          batch = "Batch1",
          stringsAsFactors = FALSE
        ))
      }
    })

    observeEvent(input$real_csv_file_btn, {
      overlay_show("Processing selected tabular file(s)…", loader = "parse")
      on.exit(overlay_hide(), add = TRUE)
      sel <- input$real_csv_file_btn
      req(!is.null(sel))
      files <- parseFilePaths(volumes, sel)
      req(is.data.frame(files), nrow(files) > 0)
      ext <- tolower(tools::file_ext(as.character(files$datapath)))
      keep <- ext %in% c("csv", "tsv", "txt")
      if (!any(keep)) {
        showNotification("No .csv/.tsv/.txt file selected.", type = "warning")
        return()
      }
      files <- files[keep, , drop = FALSE]
      nm <- vapply(files$datapath, .sample_name_from_path, character(1), type = "csv")
      .append_staged(data.frame(
        id = paste0("s_", as.integer(Sys.time()), "_", seq_len(nrow(files))),
        name = nm,
        path = as.character(files$datapath),
        type = "csv",
        condition = "Unknown",
        batch = "Batch1",
        stringsAsFactors = FALSE
      ))
    })

    .metadata_manifest_show <- function() {
      info <- metadata_manifest_info()
      showModal(metadata_manifest_modal_content(ns, root_path = as.character(info$root_path %||% "")))
      invisible(NULL)
    }

    .metadata_manifest_recompute <- function(df = metadata_manifest_df(), info = metadata_manifest_info()) {
      if (!is.data.frame(df) || !nrow(df) || !is.list(info) || !length(info)) return(invisible(NULL))
      root <- as.character(info$root_path %||% "")
      df <- .metadata_manifest_refresh(df, info, root_path = root)
      metadata_manifest_info(info)
      metadata_manifest_df(df)
      invisible(df)
    }

    observeEvent(input$real_metadata_file_btn, {
      overlay_show("Reading metadata list...", loader = "parse")
      on.exit(overlay_hide(), add = TRUE)
      sel <- input$real_metadata_file_btn
      req(!is.null(sel))
      files <- parseFilePaths(volumes, sel)
      req(is.data.frame(files), nrow(files) > 0)
      p <- as.character(files$datapath[[1]] %||% "")
      if (!nzchar(p) || !file.exists(p)) {
        showNotification("Metadata list file was not found.", type = "error")
        return(invisible(NULL))
      }
      prepared <- tryCatch(
        .metadata_manifest_prepare(p, root_path = dirname(p)),
        error = function(e) {
          showNotification(conditionMessage(e), type = "error", duration = 10)
          NULL
        }
      )
      if (is.null(prepared)) return(invisible(NULL))
      prepared$info$root_path <- normalizePath(dirname(p), winslash = "/", mustWork = FALSE)
      prepared$data <- .metadata_manifest_refresh(prepared$data, prepared$info, prepared$info$root_path)
      metadata_manifest_info(prepared$info)
      metadata_manifest_df(prepared$data)
      .metadata_manifest_show()
      invisible(NULL)
    })

    observeEvent(input$metadata_manifest_apply_root_btn, {
      info <- metadata_manifest_info()
      req(is.list(info), length(info))
      root <- trimws(as.character(input$metadata_manifest_root_path %||% ""))
      if (!nzchar(root) || !dir.exists(root)) {
        showNotification("Root folder is missing or invalid.", type = "warning")
        return(invisible(NULL))
      }
      info$root_path <- normalizePath(root, winslash = "/", mustWork = FALSE)
      metadata_manifest_info(info)
      .metadata_manifest_recompute()
      updateTextInput(session, "metadata_manifest_root_path", value = info$root_path)
      showNotification("Resolved manifest paths against the selected root folder.", type = "message")
      invisible(NULL)
    })

    observeEvent(input$real_metadata_root_btn, {
      sel <- input$real_metadata_root_btn
      req(!is.null(sel))
      dirs <- parseDirPath(volumes, sel)
      if (!length(dirs) || !dir.exists(dirs[[1]])) {
        showNotification("Metadata root folder was not found.", type = "warning")
        return(invisible(NULL))
      }
      info <- metadata_manifest_info()
      req(is.list(info), length(info))
      info$root_path <- normalizePath(dirs[[1]], winslash = "/", mustWork = FALSE)
      metadata_manifest_info(info)
      .metadata_manifest_recompute()
      updateTextInput(session, "metadata_manifest_root_path", value = info$root_path)
      showNotification("Resolved manifest paths against the selected root folder.", type = "message")
      invisible(NULL)
    })

    output$metadata_manifest_status_ui <- renderUI({
      df <- metadata_manifest_df()
      info <- metadata_manifest_info()
      if (!is.data.frame(df) || !nrow(df) || !is.list(info) || !length(info)) return(tags$span("No metadata list loaded."))
      selected <- sum(as.logical(df$`__include_sample`), na.rm = TRUE)
      ready <- sum(as.logical(df$`__include_sample`) & as.logical(df$`__ready`), na.rm = TRUE)
      cell_sidecars <- sum(nzchar(as.character(df$`__cell_metadata_path` %||% character(0))))
      qc_reports <- sum(nzchar(as.character(df$`__qc_metrics_path` %||% character(0))))
      tags$span(
        sprintf(
          "Detected %s delimiter. Rows: %d. Included: %d. Ready: %d. Cell metadata sidecars: %d. QC reports: %d. Root: %s",
          toupper(as.character(info$delimiter %||% "")), nrow(df), selected, ready, cell_sidecars, qc_reports,
          as.character(info$root_path %||% "not set")
        )
      )
    })

    output$metadata_manifest_remove_col_ui <- renderUI({
      info <- metadata_manifest_info()
      df <- metadata_manifest_df()
      if (!is.list(info) || !length(info) || !is.data.frame(df) || !nrow(df)) return(tags$span())
      protected <- c(info$donor_col, info$technology_col, info$condition_col, info$batch_col)
      removable <- setdiff(as.character(info$metadata_cols %||% character(0)), protected)
      removable <- removable[removable %in% colnames(df)]
      if (!length(removable)) return(tags$span("No removable metadata columns."))
      div(
        class = "manifest-inline-row",
        selectInput(ns("metadata_manifest_remove_col_name"), NULL, choices = removable, selected = removable[[1]], width = "100%"),
        actionButton(ns("metadata_manifest_remove_col_btn"), "Remove Column", class = "btn btn-outline-secondary")
      )
    })

    output$metadata_manifest_table <- renderDT({
      df <- metadata_manifest_df()
      info <- metadata_manifest_info()
      req(is.data.frame(df), nrow(df) > 0, is.list(info), length(info))
      display <- .metadata_manifest_display_frame(df, info)
      disp_cols <- colnames(display)
      labels <- unname(vapply(disp_cols, .metadata_manifest_col_label, character(1)))
      editable_cols <- setdiff(
        disp_cols,
        c("__donor_id", "__technology", "__selected_path", "__sidecar_status", "__status", info$path_cols)
      )
      editable_idx <- which(disp_cols %in% editable_cols) - 1L
      include_idx <- match("__include_sample", disp_cols) - 1L
      status_idx <- match("__status", disp_cols) - 1L
      created_js <- sprintf(
        "function(row, data){ var inc = String(data[%d] || '').toLowerCase(); var st = String(data[%d] || '').toLowerCase(); if(inc === 'false' || st !== 'ready'){ $(row).addClass('manifest-row-invalid'); } else { $(row).removeClass('manifest-row-invalid'); } }",
        include_idx, status_idx
      )
      datatable(
        display,
        rownames = FALSE,
        selection = "multiple",
        editable = list(target = "cell", disable = list(columns = setdiff(seq_along(disp_cols) - 1L, editable_idx))),
        class = "compact stripe hover",
        escape = TRUE,
        options = list(
          dom = "t",
          paging = FALSE,
          scrollX = TRUE,
          scrollCollapse = TRUE,
          autoWidth = FALSE,
          orderClasses = FALSE,
          createdRow = DT::JS(created_js)
        ),
        colnames = labels
      )
    }, server = FALSE)

    observeEvent(input$metadata_manifest_table_cell_edit, {
      info <- metadata_manifest_info()
      df <- metadata_manifest_df()
      req(is.data.frame(df), nrow(df) > 0, is.list(info), length(info))
      edit <- input$metadata_manifest_table_cell_edit
      row <- as.integer(edit$row %||% 0L)
      display_cols <- .metadata_manifest_display_cols(df, info)
      col_idx <- as.integer(edit$col %||% -1L) + 1L
      if (row < 1L || row > nrow(df) || col_idx < 1L || col_idx > length(display_cols)) return(invisible(NULL))
      col <- display_cols[[col_idx]]
      value <- as.character(edit$value %||% "")
      if (col %in% c(info$path_cols, "__donor_id", "__technology", "__selected_path", "__sidecar_status", "__status")) return(invisible(NULL))
      if (identical(col, "__include_sample")) {
        yes <- tolower(trimws(value)) %in% c("true", "t", "1", "yes", "y")
        if (isTRUE(yes) && isTRUE(df$`__auto_duplicate`[[row]])) {
          showNotification("Exact duplicate remains excluded. Remove the duplicate row or edit its metadata.", type = "warning")
          return(invisible(NULL))
        }
        df$`__include_sample`[[row]] <- yes
      } else if (identical(col, "__object_name")) {
        df$`__object_name`[[row]] <- trimws(value)
        df$`__object_name_auto`[[row]] <- FALSE
      } else if (identical(col, "__cell_set")) {
        normalized <- .metadata_manifest_normalize_cell_set(value, default = "")
        if (!(normalized %in% c("filtered", "all_cells"))) {
          showNotification("Cell Set must be filtered or all_cells.", type = "warning")
          return(invisible(NULL))
        }
        df$`__cell_set`[[row]] <- normalized
      } else if (identical(col, "__input_type")) {
        normalized <- .metadata_manifest_normalize_input_type(value, default = "")
        if (!(normalized %in% c("h5", "matrix"))) {
          showNotification("Input Type must be h5 or matrix.", type = "warning")
          return(invisible(NULL))
        }
        df$`__input_type`[[row]] <- normalized
      } else if (col %in% info$metadata_cols) {
        df[[col]][[row]] <- if (nzchar(trimws(value))) value else NA_character_
      } else {
        return(invisible(NULL))
      }
      metadata_manifest_df(.metadata_manifest_refresh(df, info, root_path = as.character(info$root_path %||% "")))
      invisible(NULL)
    })

    observeEvent(input$metadata_manifest_add_col_btn, {
      info <- metadata_manifest_info()
      df <- metadata_manifest_df()
      req(is.data.frame(df), nrow(df) > 0, is.list(info), length(info))
      raw <- as.character(input$metadata_manifest_new_col_name %||% "")
      col_name <- .sanitize_meta_column_name(raw, allow_empty = TRUE)
      if (!nzchar(col_name)) {
        showNotification("Enter a metadata column name first.", type = "warning")
        return(invisible(NULL))
      }
      norm_existing <- vapply(colnames(df), .metadata_manifest_norm_col, character(1))
      if (col_name %in% norm_existing || col_name %in% vapply(colnames(df), .sanitize_meta_column_name, character(1))) {
        showNotification("That metadata column already exists.", type = "warning")
        return(invisible(NULL))
      }
      df[[col_name]] <- rep(NA_character_, nrow(df))
      info$metadata_cols <- c(info$metadata_cols, col_name)
      info$original_cols <- c(info$original_cols, col_name)
      metadata_manifest_info(info)
      metadata_manifest_df(.metadata_manifest_refresh(df, info, root_path = as.character(info$root_path %||% "")))
      updateTextInput(session, "metadata_manifest_new_col_name", value = "")
    })

    observeEvent(input$metadata_manifest_remove_col_btn, {
      info <- metadata_manifest_info()
      df <- metadata_manifest_df()
      req(is.data.frame(df), nrow(df) > 0, is.list(info), length(info))
      col_name <- as.character(input$metadata_manifest_remove_col_name %||% "")
      if (!nzchar(col_name) || !(col_name %in% info$metadata_cols)) return(invisible(NULL))
      if (col_name %in% c(info$donor_col, info$technology_col, info$condition_col, info$batch_col)) {
        showNotification("Donor ID, Technology, Condition, and Batch columns are required.", type = "warning")
        return(invisible(NULL))
      }
      df[[col_name]] <- NULL
      info$metadata_cols <- setdiff(info$metadata_cols, col_name)
      info$original_cols <- setdiff(info$original_cols, col_name)
      metadata_manifest_info(info)
      metadata_manifest_df(.metadata_manifest_refresh(df, info, root_path = as.character(info$root_path %||% "")))
    })

    observeEvent(input$metadata_manifest_remove_rows_btn, {
      df <- metadata_manifest_df()
      req(is.data.frame(df), nrow(df) > 0)
      selected <- as.integer(input$metadata_manifest_table_rows_selected %||% integer(0))
      selected <- selected[is.finite(selected) & selected >= 1L & selected <= nrow(df)]
      if (!length(selected)) {
        showNotification("Select rows to remove.", type = "warning")
        return(invisible(NULL))
      }
      info <- metadata_manifest_info()
      df <- df[-selected, , drop = FALSE]
      if (!nrow(df)) {
        metadata_manifest_df(df)
        showNotification("All manifest rows were removed.", type = "message")
        return(invisible(NULL))
      }
      metadata_manifest_df(.metadata_manifest_refresh(df, info, root_path = as.character(info$root_path %||% "")))
    })

    .metadata_manifest_row_meta <- function(df, row, info) {
      out <- list()
      skipped <- as.character(info$skipped_meta_cols %||% character(0))
      for (cc in as.character(info$metadata_cols %||% character(0))) {
        if (!(cc %in% colnames(df)) || cc %in% skipped) next
        key <- .sanitize_meta_column_name(cc, allow_empty = TRUE)
        if (!nzchar(key)) next
        value <- df[[cc]][[row]]
        out[[key]] <- if (length(value) == 0L || is.na(value)) NA_character_ else as.character(value)
      }
      out
    }

    .metadata_manifest_row_paths <- function(df, row, info) {
      out <- list()
      for (cc in as.character(info$path_cols %||% character(0))) {
        if (!(cc %in% colnames(df))) next
        key <- .sanitize_meta_column_name(cc, allow_empty = TRUE)
        if (!nzchar(key) || identical(key, "path")) key <- paste0("manifest_", key)
        value <- df[[cc]][[row]]
        out[[key]] <- if (length(value) == 0L || is.na(value)) NA_character_ else as.character(value)
      }
      out
    }

    .metadata_manifest_build_rows <- function(df, info) {
      if (is.null(df) || !is.data.frame(df) || !nrow(df)) return(list(rows = data.frame(), result = data.frame()))
      included <- as.logical(df$`__include_sample`)
      ready <- as.logical(df$`__ready`)
      result <- data.frame(
        row = as.integer(df$`__manifest_row`),
        object = as.character(df$`__object_name`),
        source = as.character(df$`__selected_path`),
        status = ifelse(included & ready, "Pending", "Skipped"),
        reason = as.character(df$`__status`),
        stringsAsFactors = FALSE
      )
      rows <- df[included & ready, , drop = FALSE]
      if (!nrow(rows)) return(list(rows = data.frame(), result = result))
      out <- data.frame(
        id = paste0("manifest_", as.integer(rows$`__manifest_row`), "_", seq_len(nrow(rows))),
        name = as.character(rows$`__object_name`),
        path = as.character(rows$`__selected_path`),
        type = as.character(rows$`__input_type`),
        condition = as.character(rows[[info$condition_col]]),
        batch = as.character(rows[[info$batch_col]]),
        manifest_row_index = as.integer(rows$`__manifest_row`),
        cell_metadata_path = as.character(rows$`__cell_metadata_path`),
        qc_metrics_path = as.character(rows$`__qc_metrics_path`),
        stringsAsFactors = FALSE
      )
      out$condition[is.na(out$condition) | !nzchar(trimws(out$condition))] <- NA_character_
      out$batch[is.na(out$batch) | !nzchar(trimws(out$batch))] <- NA_character_
      out$manifest_meta <- I(lapply(seq_len(nrow(rows)), function(i) {
        .metadata_manifest_row_meta(rows, i, info)
      }))
      out$manifest_paths <- I(lapply(seq_len(nrow(rows)), function(i) {
        .metadata_manifest_row_paths(rows, i, info)
      }))
      list(rows = out, result = result)
    }

    .metadata_manifest_conflict_cols <- function(entries) {
      out <- data.frame(column = character(0), existing = character(0), action = character(0), new_name = character(0), stringsAsFactors = FALSE)
      if (!is.list(entries) || !length(entries)) return(out)
      for (ent in entries) {
        obj <- ent$obj
        if (is.null(obj) || !inherits(obj, "Seurat") || !is.list(ent$manifest_meta)) next
        md_cols <- colnames(obj@meta.data %||% data.frame())
        md_norm <- vapply(md_cols, .metadata_manifest_norm_col, character(1))
        for (cc in names(ent$manifest_meta)) {
          hit <- which(md_norm == .metadata_manifest_norm_col(cc))
          if (!length(hit)) next
          out <- rbind(out, data.frame(
            column = cc,
            existing = md_cols[[hit[[1]]]],
            action = "rename",
            new_name = paste0("imported_", cc),
            stringsAsFactors = FALSE
          ))
        }
      }
      if (!nrow(out)) return(out)
      out <- out[!duplicated(out$column), , drop = FALSE]
      rownames(out) <- NULL
      out
    }

    output$metadata_manifest_conflict_table <- renderDT({
      df <- metadata_manifest_conflicts()
      req(is.data.frame(df), nrow(df) > 0)
      datatable(
        df[, c("column", "action", "new_name"), drop = FALSE],
        rownames = FALSE,
        selection = "none",
        editable = list(target = "cell", disable = list(columns = 0)),
        class = "compact stripe hover",
        options = list(dom = "t", paging = FALSE, scrollX = TRUE, autoWidth = FALSE),
        colnames = c("Imported Column", "Action (rename or skip)", "New Name")
      )
    }, server = FALSE)

    observeEvent(input$metadata_manifest_conflict_table_cell_edit, {
      info <- metadata_manifest_conflicts()
      req(is.data.frame(info), nrow(info) > 0)
      edit <- input$metadata_manifest_conflict_table_cell_edit
      row <- as.integer(edit$row %||% 0L)
      col <- as.integer(edit$col %||% -1L) + 1L
      if (row < 1L || row > nrow(info) || col < 1L || col > 3L) return(invisible(NULL))
      if (col == 2L) info$action[[row]] <- tolower(trimws(as.character(edit$value %||% "")))
      if (col == 3L) info$new_name[[row]] <- trimws(as.character(edit$value %||% ""))
      metadata_manifest_conflicts(info)
    })

    output$metadata_manifest_result_table <- renderDT({
      df <- metadata_manifest_result()
      req(is.data.frame(df), nrow(df) > 0)
      datatable(
        df,
        rownames = FALSE,
        selection = "none",
        class = "compact stripe hover",
        options = list(
          dom = "t",
          paging = FALSE,
          scrollX = TRUE,
          scrollY = "55vh",
          scrollCollapse = TRUE,
          autoWidth = FALSE,
          columnDefs = list(
            list(width = "90px", targets = 0),
            list(width = "220px", targets = 1),
            list(width = "520px", targets = 2),
            list(width = "110px", targets = 3),
            list(width = "360px", targets = 4)
          )
        ),
        colnames = c("Manifest Row", "Object", "Source", "Status", "Reason")
      )
    }, server = FALSE)

    .metadata_manifest_commit_build <- function(build, result_seed) {
      entries <- build$entries %||% list()
      errs <- as.character(build$errors %||% character(0))
      if (is.data.frame(result_seed) && nrow(result_seed) && length(errs)) {
        for (err in errs) {
          nm <- sub("\\s*->.*$", "", err)
          hit <- which(result_seed$object == nm & result_seed$status == "Pending")
          if (!length(hit)) hit <- which(grepl(nm, result_seed$object, fixed = TRUE) & result_seed$status == "Pending")
          if (length(hit)) {
            result_seed$status[[hit[[1]]]] <- "Failed"
            result_seed$reason[[hit[[1]]]] <- sub("^[^>]*->\\s*", "", err)
          }
        }
      }
      attr(entries, "batch_manifest") <- TRUE
      attr(entries, "batch_result_seed") <- result_seed
      build$entries <- entries
      conflicts <- .metadata_manifest_conflict_cols(entries)
      if (is.data.frame(conflicts) && nrow(conflicts)) {
        metadata_manifest_conflicts(conflicts)
        metadata_manifest_pending_commit(list(build = build, result_seed = result_seed))
        removeModal()
        showModal(metadata_manifest_conflict_modal_content(ns))
        return(invisible(NULL))
      }
      .run_commit_with_options(build, data.frame(), FALSE, data.frame(), conflict_mode = "replace")
      invisible(NULL)
    }

    observeEvent(input$metadata_manifest_conflict_cancel_btn, {
      removeModal()
      .metadata_manifest_show()
    })

    observeEvent(input$metadata_manifest_conflict_apply_btn, {
      pending <- metadata_manifest_pending_commit()
      conflicts <- metadata_manifest_conflicts()
      req(is.list(pending), is.data.frame(conflicts), nrow(conflicts) > 0)
      actions <- tolower(trimws(as.character(conflicts$action %||% "")))
      if (any(!actions %in% c("rename", "skip"))) {
        showNotification("Each conflict action must be rename or skip.", type = "warning")
        return(invisible(NULL))
      }
      entries <- pending$build$entries %||% list()
      existing <- character(0)
      for (ent in entries) {
        obj <- ent$obj
        if (inherits(obj, "Seurat")) existing <- c(existing, colnames(obj@meta.data))
      }
      existing_norm <- vapply(existing, .metadata_manifest_norm_col, character(1))
      target_names <- character(0)
      for (i in seq_len(nrow(conflicts))) {
        old <- as.character(conflicts$column[[i]])
        if (identical(actions[[i]], "skip")) next
        new <- .sanitize_meta_column_name(conflicts$new_name[[i]], allow_empty = TRUE)
        if (!nzchar(new)) {
          showNotification(sprintf("Enter a new name for %s or choose skip.", old), type = "warning")
          return(invisible(NULL))
        }
        if (.metadata_manifest_norm_col(new) %in% existing_norm ||
            .metadata_manifest_norm_col(new) %in% vapply(target_names, .metadata_manifest_norm_col, character(1)) ||
            .metadata_manifest_norm_col(new) %in% vapply(as.character(conflicts$column), .metadata_manifest_norm_col, character(1))) {
          showNotification(sprintf("New metadata name is still conflicting: %s", new), type = "warning")
          return(invisible(NULL))
        }
        target_names <- c(target_names, new)
      }
      for (i in seq_len(nrow(conflicts))) {
        old <- as.character(conflicts$column[[i]])
        for (key in names(entries)) {
          meta <- entries[[key]]$manifest_meta
          if (!is.list(meta) || !(old %in% names(meta))) next
          if (identical(actions[[i]], "skip")) {
            meta[[old]] <- NULL
          } else {
            new <- .sanitize_meta_column_name(conflicts$new_name[[i]], allow_empty = TRUE)
            meta[[new]] <- meta[[old]]
            meta[[old]] <- NULL
          }
          entries[[key]]$manifest_meta <- meta
        }
      }
      pending$build$entries <- entries
      metadata_manifest_pending_commit(NULL)
      metadata_manifest_conflicts(data.frame())
      removeModal()
      .run_commit_with_options(pending$build, data.frame(), FALSE, data.frame(), conflict_mode = "replace")
    })

    observeEvent(input$real_atac_file_btn, {
      overlay_show("Processing selected ATAC fragment file(s)…", loader = "import")
      on.exit(overlay_hide(), add = TRUE)
      sel <- input$real_atac_file_btn
      req(!is.null(sel))
      files <- parseFilePaths(volumes, sel)
      req(is.data.frame(files), nrow(files) > 0)
      paths <- as.character(files$datapath %||% character(0))
      keep <- vapply(paths, .atac_is_fragment_file, logical(1))
      if (!any(keep)) {
        showNotification("No *_atac_fragments.tsv.gz file selected.", type = "warning")
        return(invisible(NULL))
      }
      paths <- paths[keep]
      nm <- vapply(paths, function(p) .sample_name_from_path(.path_stem(p), type = "h5"), character(1))
      .append_staged(data.frame(
        id = paste0("s_", as.integer(Sys.time()), "_", seq_along(paths)),
        name = nm,
        path = paths,
        type = "atac_fragment",
        condition = "Unknown",
        batch = "Batch1",
        stringsAsFactors = FALSE
      ))
    })

    .add_demo_from_dir <- function(selected_demo_dir, demo_label = NULL) {
      if (is.null(selected_demo_dir) || !dir.exists(selected_demo_dir)) {
        showNotification("Selected demo folder was not found.", type = "warning")
        return(invisible(NULL))
      }

      h5_files <- list.files(selected_demo_dir, pattern = "\\.(h5|hdf5|h5ad)$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
      csv_files <- list.files(selected_demo_dir, pattern = "\\.(csv|tsv)$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
      mtx_files <- list.files(selected_demo_dir, pattern = "matrix\\.mtx(\\.gz)?$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
      # Keep only canonical 10x filenames, not GEO-prefixed "*_matrix.mtx.gz".
      mtx_files <- mtx_files[tolower(basename(mtx_files)) %in% c("matrix.mtx", "matrix.mtx.gz")]
      matrix_dirs <- unique(dirname(mtx_files))

      demo_paths <- c(h5_files, matrix_dirs, csv_files)
      if (!length(demo_paths)) {
        showNotification("No demo-compatible files found.", type = "warning")
        return(invisible(NULL))
      }

      h5_types <- ifelse(tolower(tools::file_ext(h5_files)) == "h5ad", "h5ad", "h5")
      entries <- data.frame(
        id = paste0("demo_", seq_along(demo_paths), "_", as.integer(Sys.time())),
        name = vapply(demo_paths, .sample_name_from_path, character(1)),
        path = demo_paths,
        type = c(h5_types, rep("matrix", length(matrix_dirs)), rep("csv", length(csv_files))),
        condition = "Unknown",
        batch = "Batch1",
        stringsAsFactors = FALSE
      )

      .append_staged(entries)
      if (is.null(demo_label) || !nzchar(demo_label)) {
        showNotification(sprintf("Added %d demo item(s).", nrow(entries)), type = "message")
      } else {
        showNotification(sprintf("Added %d demo item(s) from '%s'.", nrow(entries), demo_label), type = "message")
      }
      invisible(entries)
    }

    observeEvent(input$btn_add_demo, {
      if (is.null(demo_root) || !dir.exists(demo_root)) {
        showNotification("Demo folder not found.", type = "warning")
        return()
      }

      demo_subdirs <- list.dirs(demo_root, full.names = TRUE, recursive = FALSE)
      demo_subdirs <- demo_subdirs[file.info(demo_subdirs)$isdir %in% TRUE]

      if (length(demo_subdirs)) {
        demo_names <- basename(demo_subdirs)
        showModal(modalDialog(
          title = "Choose Demo Dataset",
          easyClose = TRUE,
          size = "m",
          selectInput(
            ns("demo_dataset_choice"),
            "Demo group",
            choices = stats::setNames(demo_subdirs, demo_names),
            selected = demo_subdirs[[1]]
          ),
          footer = tagList(
            modalButton("Cancel"),
            actionButton(ns("demo_dataset_load"), "Load Selected Demo", class = "btn btn-primary")
          )
        ))
      } else {
        .add_demo_from_dir(demo_root, demo_label = basename(demo_root))
      }
    })

    observeEvent(input$demo_dataset_load, {
      req(input$demo_dataset_choice)
      removeModal()
      .add_demo_from_dir(
        selected_demo_dir = input$demo_dataset_choice,
        demo_label = basename(input$demo_dataset_choice)
      )
      # Return user to the staging table so they can review/edit pending rows.
      showModal(import_modal_content(ns))
    })

    output$staged_samples_table <- renderDT({
      df <- staged_samples()
      if (!nrow(df)) {
        return(datatable(
          data.frame(name = "No files selected", type = "-", condition = "-", batch = "-", stringsAsFactors = FALSE),
          rownames = FALSE,
          selection = "none",
          options = list(dom = "t", paging = FALSE),
          colnames = c("Name", "Type", "Condition", "Batch")
        ))
      }

      df_show <- df
      df_show$path <- vapply(df_show$path, .display_staged_path, character(1))

      datatable(
        .safe_select_cols(df_show, c("name", "type", "condition", "batch", "path"), default = ""),
        rownames = FALSE,
        selection = "multiple",
        editable = list(target = "cell", disable = list(columns = c(1, 4))),
        class = "compact stripe hover",
        escape = FALSE,
        options = list(
          dom = "t",
          paging = FALSE,
          scrollX = TRUE,
          scrollCollapse = TRUE,
          autoWidth = FALSE,
          orderClasses = FALSE,
          columnDefs = list(
            list(targets = 0, width = "22%"),
            list(targets = 1, width = "8%"),
            list(targets = 2, width = "12%"),
            list(targets = 3, width = "10%"),
            list(
              targets = 4,
              width = "48%",
              render = DT::JS("function(data,type,row){ if(type==='display'){ return '<div style=\"font-size:11px; line-height:1.2; white-space:normal; word-break:break-all;\">'+data+'</div>'; } return data; }")
            )
          )
        ),
        colnames = c("Name", "Type", "Condition", "Batch", "Path")
      )
    }, server = FALSE)

    observeEvent(input$staged_samples_table_cell_edit, {
      info <- input$staged_samples_table_cell_edit
      df <- staged_samples()
      i <- info$row
      display_cols <- c("name", "type", "condition", "batch", "path")
      j <- info$col + 1
      if (!nrow(df) || i < 1 || i > nrow(df) || j < 1 || j > length(display_cols)) return()
      col_name <- display_cols[j]
      if (!col_name %in% c("name", "condition", "batch")) return()
      df[i, col_name] <- as.character(info$value)
      staged_samples(df)
    })

    observeEvent(input$btn_remove_staged_selected, {
      current <- staged_samples()
      sel <- input$staged_samples_table_rows_selected
      if (is.null(sel) || !length(sel) || !nrow(current)) {
        showNotification("Select staged rows to remove.", type = "warning")
        return()
      }
      staged_samples(current[-sel, , drop = FALSE])
    })

    observe({
      df <- staged_samples()
      atac_pairing_df(.atac_build_pairing_df(df))
    })

    output$atac_pairing_table <- renderDT({
      df <- atac_pairing_df()
      if (is.null(df) || !is.data.frame(df) || !nrow(df)) {
        return(datatable(
          data.frame(object_name = "No ATAC pairing candidates", status = "-", fragment_name = "-", ignored = "-", stringsAsFactors = FALSE),
          rownames = FALSE,
          selection = "none",
          options = list(dom = "t", paging = FALSE),
          colnames = c("Object", "Status", "Fragment", "Ignored")
        ))
      }
      datatable(
        .safe_select_cols(df, c("object_name", "status", "fragment_name", "ignored"), default = ""),
        rownames = FALSE,
        selection = "multiple",
        class = "compact stripe hover",
        options = list(dom = "t", paging = FALSE, scrollX = TRUE, autoWidth = FALSE),
        colnames = c("Object", "Status", "Fragment", "Ignored")
      )
    }, server = FALSE)

    observeEvent(input$btn_atac_ignore_selected, {
      df <- atac_pairing_df()
      sel <- as.integer(input$atac_pairing_table_rows_selected %||% integer(0))
      if (!is.data.frame(df) || !nrow(df) || !length(sel)) {
        showNotification("Select ATAC pairing rows first.", type = "warning")
        return(invisible(NULL))
      }
      sel <- sel[sel >= 1 & sel <= nrow(df)]
      if (!length(sel)) return(invisible(NULL))
      df$ignored[sel] <- TRUE
      df$status[sel] <- "ignored"
      atac_pairing_df(df)
      showNotification(sprintf("Marked %d ATAC pairing row(s) ignored.", length(sel)), type = "message")
    })

    output$h5ad_import_map_table <- renderDT({
      df <- h5ad_import_map_df()
      req(is.data.frame(df), nrow(df) > 0)
      disp_cols <- .h5ad_map_display_cols(df)
      req(length(disp_cols) > 0)
      editable_cols <- setdiff(disp_cols, .h5ad_map_noneditable_cols)
      editable_idx <- which(disp_cols %in% editable_cols) - 1L
      include_idx <- which(disp_cols == "include_sample") - 1L
      pretty_colnames <- unname(vapply(disp_cols, function(cc) {
        if (cc == "include_sample") return("Include")
        if (cc == "object_name") return("Object Name")
        if (cc == "sample_name") return("Sample Name")
        if (cc == "split_col") return("Split Column")
        if (cc == "split_value") return("Split Value")
        tools::toTitleCase(gsub("_", " ", cc))
      }, character(1)))
      datatable(
        .safe_select_cols(df, disp_cols, default = ""),
        rownames = FALSE,
        selection = list(mode = "multiple"),
        escape = TRUE,
        editable = list(target = "cell", disable = list(columns = setdiff(seq_along(disp_cols) - 1L, editable_idx))),
        class = "compact stripe hover nowrap",
        options = list(
          dom = "t",
          paging = FALSE,
          scrollX = TRUE,
          scrollCollapse = TRUE,
          autoWidth = FALSE,
          columnDefs = list(
            list(targets = "_all", className = "dt-nowrap", width = "110px"),
            list(
              targets = include_idx,
              className = "h5ad-include-toggle",
              render = DT::JS(
                "function(data,type,row,meta){
                   if(type !== 'display') return data;
                   var v = String(data).toLowerCase();
                   var yes = (v === 'true' || v === '1' || v === 'yes' || v === 'y' || v === 't');
                   var cls = yes ? 'h5ad-include-badge h5ad-include-yes' : 'h5ad-include-badge h5ad-include-no';
                   var txt = yes ? 'Included' : 'Excluded';
                   return '<span class=\"'+cls+'\">'+txt+'</span>';
                 }"
              )
            )
          ),
          createdRow = DT::JS(
            sprintf(
              "function(row, data){
                 var idx = %d;
                 var v = (data[idx] || '').toString().toLowerCase();
                 var yes = (v === 'true' || v === '1' || v === 'yes' || v === 'y' || v === 't');
                 if(!yes){ $(row).addClass('h5ad-row-excluded'); } else { $(row).removeClass('h5ad-row-excluded'); }
               }",
              include_idx
            )
          )
        ),
        colnames = pretty_colnames
      )
    }, server = FALSE)
    observeEvent(input$h5ad_import_map_table_rows_selected, {
      # Persist non-empty row selections by stable import_key so they survive
      # redraws before confirm.
      df <- h5ad_import_map_df()
      if (!is.data.frame(df) || !nrow(df) || !("import_key" %in% colnames(df))) return(invisible(NULL))
      sel <- as.integer(input$h5ad_import_map_table_rows_selected %||% integer(0))
      sel <- sel[is.finite(sel) & sel >= 1 & sel <= nrow(df)]
      if (length(sel)) {
        keys <- unique(as.character(df$import_key[sel] %||% character(0)))
        keys <- keys[nzchar(keys)]
        if (length(keys)) h5ad_last_selected_keys(keys)
      }
      invisible(NULL)
    }, ignoreInit = TRUE)

    output$h5ad_remove_col_ui <- renderUI({
      df <- h5ad_import_map_df()
      req(is.data.frame(df), nrow(df) > 0)
      extra_cols <- .h5ad_map_extra_cols(df)
      if (!length(extra_cols)) return(tags$span())
      div(
        class = "h5ad-map-inline-row",
        selectInput(
          ns("h5ad_remove_col_name"),
          NULL,
          choices = extra_cols,
          selected = extra_cols[[1]],
          width = "100%"
        ),
        actionButton(ns("h5ad_remove_col_btn"), "Remove Column", class = "btn btn-outline-secondary")
      )
    })

    observeEvent(input$h5ad_add_col_btn, {
      df <- h5ad_import_map_df()
      req(is.data.frame(df), nrow(df) > 0)
      raw_name <- as.character(input$h5ad_new_col_name %||% "")
      col_name <- .sanitize_meta_column_name(raw_name, allow_empty = TRUE)
      if (!nzchar(col_name)) {
        showNotification("Enter a column name first.", type = "warning")
        return()
      }
      if (col_name %in% .h5ad_map_core_cols || col_name %in% .h5ad_map_noneditable_cols) {
        showNotification("This column name is reserved. Use a different name.", type = "warning")
        return()
      }
      if (col_name %in% colnames(df)) {
        showNotification("Column already exists.", type = "message")
        return()
      }
      df[[col_name]] <- rep("", nrow(df))
      h5ad_import_map_df(df)
      updateTextInput(session, "h5ad_new_col_name", value = "")
    })

    observeEvent(input$h5ad_remove_col_btn, {
      df <- h5ad_import_map_df()
      req(is.data.frame(df), nrow(df) > 0)
      col_name <- as.character(input$h5ad_remove_col_name %||% "")
      if (!nzchar(col_name) || !(col_name %in% colnames(df))) return()
      if (col_name %in% .h5ad_map_core_cols) return()
      df[[col_name]] <- NULL
      h5ad_import_map_df(df)
    })

    observeEvent(input$h5ad_import_map_table_cell_edit, {
      info <- input$h5ad_import_map_table_cell_edit
      df <- h5ad_import_map_df()
      i <- info$row
      display_cols <- .h5ad_map_display_cols(df)
      j <- info$col + 1L
      if (!nrow(df) || i < 1 || i > nrow(df) || j < 1 || j > length(display_cols)) return()
      col_name <- display_cols[[j]]
      if (col_name %in% .h5ad_map_noneditable_cols) return()
      if (identical(col_name, "include_sample")) {
        raw <- tolower(trimws(as.character(info$value %||% "")))
        df[i, col_name] <- isTRUE(raw %in% c("true", "t", "1", "yes", "y"))
      } else {
        df[i, col_name] <- as.character(info$value %||% "")
      }
      h5ad_import_map_df(df)
    })

    .detect_atac_assay <- function(obj) {
      assays <- tryCatch(as.character(names(obj@assays)), error = function(e) character(0))
      if (!length(assays)) return("")
      low <- tolower(assays)
      idx_atac <- which(low == "atac")
      if (length(idx_atac)) return(assays[[idx_atac[[1]]]])
      idx_alt <- which(grepl("atac|peak|chromatin", low, perl = TRUE))
      if (length(idx_alt)) return(assays[[idx_alt[[1]]]])
      ""
    }

    .promote_atac_assay <- function(obj, conflict_mode = "replace") {
      aa <- .detect_atac_assay(obj)
      if (!nzchar(aa)) return(obj)
      if (identical(aa, "ATAC")) return(obj)
      if (identical(conflict_mode, "keep_both") && ("ATAC" %in% names(obj@assays))) {
        keep_name <- paste0("ATAC_imported_", format(Sys.time(), "%H%M%S"))
        obj[[keep_name]] <- obj[[aa]]
        try(Seurat::DefaultAssay(obj) <- keep_name, silent = TRUE)
        return(obj)
      }
      obj[["ATAC"]] <- obj[[aa]]
      try(Seurat::DefaultAssay(obj) <- "ATAC", silent = TRUE)
      obj
    }

    .atac_rows_for_confirm <- function() {
      df <- atac_pairing_df()
      if (is.null(df) || !is.data.frame(df) || !nrow(df)) return(data.frame())
      keep <- !isTRUE(df$ignored) & nzchar(as.character(df$fragment_path %||% ""))
      keep <- keep & as.character(df$status %||% "") %in% c("matched", "auto_tiebreak")
      df[keep, , drop = FALSE]
    }

    .attach_manifest_cell_metadata <- function(obj, cell_metadata_path = "", qc_metrics_path = "") {
      out <- list(
        obj = obj,
        cell_status = if (nzchar(as.character(cell_metadata_path %||% ""))) "not imported" else "absent",
        cell_matched = 0L,
        cell_total = tryCatch(ncol(obj), error = function(e) 0L),
        imported_columns = character(0),
        skipped_columns = character(0),
        qc_report_status = if (nzchar(as.character(qc_metrics_path %||% ""))) "report retained" else "absent"
      )
      if (is.null(obj) || !inherits(obj, "Seurat")) return(out)
      if (!is.null(obj@misc) && !is.list(obj@misc)) obj@misc <- list()
      if (is.null(obj@misc)) obj@misc <- list()
      obj@misc$batch_import_qc_report <- list(
        path = as.character(qc_metrics_path %||% ""),
        status = out$qc_report_status,
        imported_as_cell_metadata = FALSE
      )
      path <- as.character(cell_metadata_path %||% "")
      if (!nzchar(path) || !file.exists(path)) {
        out$obj <- obj
        return(out)
      }
      sidecar <- tryCatch(.metadata_manifest_read_table(path)$data, error = function(e) NULL)
      if (!is.data.frame(sidecar) || !nrow(sidecar)) {
        out$cell_status <- "unreadable"
        out$obj <- obj
        return(out)
      }
      id_col <- .metadata_manifest_find_col(
        sidecar,
        aliases = c("cell_id", "cell", "barcode", "cell_barcode", "barcode_id", "cell_name")
      )
      if (!nzchar(id_col)) {
        sidecar_ids <- rownames(sidecar)
        if (!is.null(sidecar_ids) && length(sidecar_ids) == nrow(sidecar) && any(nzchar(sidecar_ids)) &&
            !all(grepl("^[0-9]+$", sidecar_ids))) {
          id_col <- "__rownames__"
          sidecar[[id_col]] <- sidecar_ids
        }
      }
      if (!nzchar(id_col)) {
        out$cell_status <- "no cell ID column"
        out$obj <- obj
        return(out)
      }
      ids <- trimws(as.character(sidecar[[id_col]] %||% character(0)))
      valid_ids <- nzchar(ids) & !is.na(ids)
      if (!any(valid_ids) || anyDuplicated(ids[valid_ids])) {
        out$cell_status <- "invalid or duplicated cell IDs"
        out$obj <- obj
        return(out)
      }
      target_ids <- as.character(colnames(obj) %||% character(0))
      match_idx <- match(target_ids, ids)
      matched <- sum(!is.na(match_idx))
      out$cell_matched <- matched
      out$cell_total <- length(target_ids)
      if (!matched) {
        out$cell_status <- "0 cell IDs matched"
        out$obj <- obj
        return(out)
      }
      aligned <- sidecar[match_idx, , drop = FALSE]
      md <- tryCatch(obj@meta.data, error = function(e) data.frame(row.names = target_ids))
      if (!is.data.frame(md) || nrow(md) != length(target_ids)) md <- data.frame(row.names = target_ids)
      exclude_cols <- c(id_col, "__rownames__")
      source_cols <- setdiff(colnames(sidecar), exclude_cols)
      source_cols <- source_cols[!grepl("path|url|read1|read2|processed_txt", vapply(source_cols, .metadata_manifest_norm_col, character(1)), perl = TRUE)]
      existing_norm <- vapply(colnames(md), .metadata_manifest_norm_col, character(1))
      for (cc in source_cols) {
        if (cc %in% colnames(md) || .metadata_manifest_norm_col(cc) %in% existing_norm) {
          out$skipped_columns <- c(out$skipped_columns, cc)
          next
        }
        values <- aligned[[cc]]
        if (is.list(values)) {
          values <- vapply(values, function(x) if (!length(x) || all(is.na(x))) NA_character_ else paste(as.character(unlist(x, use.names = FALSE)), collapse = ";"), character(1))
        }
        md[[cc]] <- values
        out$imported_columns <- c(out$imported_columns, cc)
      }
      rownames(md) <- target_ids
      obj@meta.data <- md
      out$cell_status <- sprintf("%d/%d cell IDs matched", matched, length(target_ids))
      out$obj <- obj
      out
    }

    .run_commit_with_options <- function(build, csv_rows, has_vdj_cands, vdj_cands, conflict_mode = "replace") {
      entries <- build$entries %||% list()
      attr(entries, "atac_conflict_mode") <- as.character(conflict_mode %||% "replace")
      .commit_sidebar_import(
        entries = entries,
        map_df = build$map_df %||% data.frame(),
        csv_rows = csv_rows,
        has_vdj_cands = has_vdj_cands,
        vdj_cands = vdj_cands
      )
    }

    .commit_sidebar_import <- function(entries, map_df, csv_rows, has_vdj_cands = FALSE, vdj_cands = data.frame()) {
      reg <- shared_data$all_seurat_objects %||% list()
      used <- character(0)
      imported_names <- character(0)
      failed_names <- character(0)
      sample_rows <- list()
      batch_manifest <- isTRUE(attr(entries, "batch_manifest"))
      batch_results <- attr(entries, "batch_result_seed")
      if (batch_manifest && (!is.data.frame(batch_results) || !nrow(batch_results))) {
        batch_results <- data.frame(
          row = integer(0), object = character(0), source = character(0), status = character(0), reason = character(0),
          stringsAsFactors = FALSE
        )
      }
      conflict_mode <- as.character(attr(entries, "atac_conflict_mode") %||% "replace")
      atac_rows <- .atac_rows_for_confirm()
      map_df <- if (is.data.frame(map_df)) map_df else data.frame()
      allowed_keys <- character(0)
      if (is.data.frame(map_df) && nrow(map_df) && ("import_key" %in% colnames(map_df))) {
        allowed_keys <- unique(as.character(map_df$import_key %||% character(0)))
        allowed_keys <- allowed_keys[nzchar(allowed_keys)]
      }

      if (is.list(entries) && length(entries)) {
        for (key in names(entries)) {
          if (length(allowed_keys) && !(as.character(key) %in% allowed_keys)) next
          ent <- entries[[key]]
          obj <- ent$obj
          if (is.null(obj) || !inherits(obj, "Seurat")) next

          row_map <- if (nrow(map_df) && "import_key" %in% colnames(map_df)) {
            map_df[as.character(map_df$import_key) == as.character(key), , drop = FALSE]
          } else {
            data.frame()
          }

          base_obj_name <- if (nrow(row_map)) as.character(row_map$object_name[[1]] %||% "") else as.character(ent$name %||% "")
          if (batch_manifest) {
            final_name <- .sanitize_sample_name(base_obj_name, allow_empty = TRUE)
            if (!nzchar(final_name) || !is.null(reg[[final_name]]) || final_name %in% used) {
              failed_names <- c(failed_names, base_obj_name)
              next
            }
          } else {
            final_name <- .ensure_unique_object_name(base_obj_name, reg = reg, used_names = used)
          }
          used <- c(used, final_name)
          imported_names <- c(imported_names, final_name)

          final_condition <- if (nrow(row_map)) as.character(row_map$condition[[1]] %||% "") else as.character(ent$condition %||% "")
          final_batch <- if (nrow(row_map)) as.character(row_map$batch[[1]] %||% "") else as.character(ent$batch %||% "")
          final_tissue <- if (nrow(row_map)) as.character(row_map$tissue[[1]] %||% "") else as.character(ent$tissue %||% "")
          final_species <- if (nrow(row_map)) as.character(row_map$species[[1]] %||% "") else as.character(ent$species %||% "")
          final_sample_name <- if (nrow(row_map)) as.character(row_map$sample_name[[1]] %||% "") else final_name
          if (is.na(final_sample_name) || !nzchar(trimws(final_sample_name))) final_sample_name <- final_name
          if (isTRUE(batch_manifest)) {
            if (is.na(final_condition) || !nzchar(trimws(final_condition))) final_condition <- NA_character_
            if (is.na(final_batch) || !nzchar(trimws(final_batch))) final_batch <- NA_character_
          } else {
            if (is.na(final_condition) || !nzchar(trimws(final_condition))) final_condition <- "Unknown"
            if (is.na(final_batch) || !nzchar(trimws(final_batch))) final_batch <- "Batch1"
          }
          extra_meta <- list()
          if (batch_manifest && is.list(ent$manifest_meta)) {
            extra_meta <- ent$manifest_meta
          } else if (nrow(row_map)) {
            extra_cols <- setdiff(colnames(row_map), .h5ad_map_core_cols)
            for (cc in extra_cols) {
              key <- .sanitize_meta_column_name(cc, allow_empty = TRUE)
              if (!nzchar(key) || key %in% .h5ad_map_core_cols) next
              extra_meta[[key]] <- as.character(row_map[[cc]][[1]] %||% "")
            }
          }

          if (identical(as.character(ent$type %||% ""), "h5ad")) {
            obj@misc$h5ad_split_mapping <- list(
              object_name = final_name,
              sample_name = final_sample_name,
              condition = final_condition,
              batch = final_batch,
              tissue = final_tissue,
              species = final_species,
              extra_meta = extra_meta,
              split_col = as.character(ent$split_col %||% ""),
              split_value = as.character(ent$split_value %||% ""),
              mapped_at = as.character(Sys.time())
            )
          }
          if (length(extra_meta) && is.data.frame(obj@meta.data) && nrow(obj@meta.data)) {
            for (cc in names(extra_meta)) {
              if (!nzchar(cc)) next
              if (batch_manifest && (cc %in% colnames(obj@meta.data) ||
                                     .metadata_manifest_norm_col(cc) %in% vapply(colnames(obj@meta.data), .metadata_manifest_norm_col, character(1)))) next
              val <- extra_meta[[cc]]
              if (length(val) == 0L || is.na(val[[1]])) val <- NA_character_ else val <- as.character(val[[1]])
              obj@meta.data[[cc]] <- rep(val, nrow(obj@meta.data))
            }
          }

          manifest_cell_status <- "not applicable"
          manifest_qc_status <- "not applicable"
          manifest_cell_cols <- character(0)
          manifest_cell_skipped <- character(0)
          if (batch_manifest) {
            attached <- .attach_manifest_cell_metadata(
              obj = obj,
              cell_metadata_path = as.character(ent$cell_metadata_path %||% ""),
              qc_metrics_path = as.character(ent$qc_metrics_path %||% "")
            )
            obj <- attached$obj
            manifest_cell_status <- as.character(attached$cell_status %||% "absent")
            manifest_qc_status <- as.character(attached$qc_report_status %||% "absent")
            manifest_cell_cols <- as.character(attached$imported_columns %||% character(0))
            manifest_cell_skipped <- as.character(attached$skipped_columns %||% character(0))
          }

          # ATAC full carry-through policy: keep peak-usable assay in-object and canonicalize to ATAC.
          atac_match <- data.frame()
          if (is.data.frame(atac_rows) && nrow(atac_rows)) {
            tok <- .atac_norm_token(base_obj_name)
            atac_match <- atac_rows[.atac_norm_token(as.character(atac_rows$object_name %||% "")) == tok, , drop = FALSE]
          }
          if (nrow(atac_match)) {
            aa <- .detect_atac_assay(obj)
            if (!nzchar(aa)) {
              failed_names <- c(failed_names, final_name)
              next
            }
            obj <- .promote_atac_assay(obj, conflict_mode = conflict_mode)
            atac_cells <- tryCatch(colnames(obj[["ATAC"]]), error = function(e) NULL)
            obj_cells <- tryCatch(colnames(obj), error = function(e) NULL)
            if (is.null(atac_cells) || is.null(obj_cells) || length(atac_cells) != length(obj_cells) ||
                !all(as.character(atac_cells) == as.character(obj_cells))) {
              failed_names <- c(failed_names, final_name)
              next
            }
            if (is.null(obj@misc) || !is.list(obj@misc)) obj@misc <- list()
            obj@misc$atac_fragment_sources <- unique(as.character(atac_match$fragment_name %||% character(0)))
            obj@misc$atac_payload_mode <- "object_resident_full"
            obj@misc$atac_payload_imported_at <- as.character(Sys.time())
          }

          reg[[final_name]] <- list(
            obj = obj,
            plots = list(),
            meta = list(
              stage = "raw",
              parent = NULL,
              parents = character(0),
              params = list(),
              created = Sys.time()
            )
          )

          sample_rows[[length(sample_rows) + 1L]] <- data.frame(
            name = final_name,
            path = as.character(ent$path %||% ""),
            type = as.character(ent$type %||% ""),
            condition = final_condition,
            batch = final_batch,
            qc_status = "Pending",
            use_in_analysis = TRUE,
            min_features = 200,
            max_features = 5000,
            min_umi_counts = 500,
            max_umi_counts = 50000,
            max_mt_percent = 20,
            sample_name = final_sample_name,
            tissue = final_tissue,
            species = final_species,
            stringsAsFactors = FALSE
          )
          if (length(extra_meta)) {
            for (cc in names(extra_meta)) {
              sample_rows[[length(sample_rows)]][[cc]] <- as.character(extra_meta[[cc]] %||% "")
            }
          }
          if (batch_manifest) {
            if (is.list(ent$manifest_paths)) {
              for (cc in names(ent$manifest_paths)) {
                value <- ent$manifest_paths[[cc]]
                sample_rows[[length(sample_rows)]][[cc]] <- if (length(value) == 0L || is.na(value[[1]])) NA_character_ else as.character(value[[1]])
              }
            }
            sample_rows[[length(sample_rows)]]$cell_metadata_path <- as.character(ent$cell_metadata_path %||% "")
            sample_rows[[length(sample_rows)]]$cell_metadata_status <- manifest_cell_status
            sample_rows[[length(sample_rows)]]$qc_metrics_status <- manifest_qc_status
            sample_rows[[length(sample_rows)]]$cell_metadata_columns <- paste(manifest_cell_cols, collapse = ";")
            sample_rows[[length(sample_rows)]]$cell_metadata_skipped_columns <- paste(manifest_cell_skipped, collapse = ";")
            sample_rows[[length(sample_rows)]]$qc_metrics_path <- as.character(ent$qc_metrics_path %||% "")
          }
          if (batch_manifest && is.data.frame(batch_results) && nrow(batch_results)) {
            row_idx <- suppressWarnings(as.integer(ent$manifest_row_index %||% NA_integer_))
            hit <- which(batch_results$row == row_idx)
            if (length(hit)) {
              batch_results$status[hit[[1]]] <- "Imported"
              batch_results$object[hit[[1]]] <- final_name
              batch_results$reason[hit[[1]]] <- paste(
                manifest_cell_status,
                manifest_qc_status,
                sep = "; "
              )
            }
          }
        }
      }

      if (batch_manifest && is.data.frame(batch_results) && nrow(batch_results) && length(failed_names)) {
        for (failed_name in unique(failed_names)) {
          hit <- which(batch_results$object == failed_name & batch_results$status %in% c("Pending", "Imported"))
          if (length(hit)) {
            batch_results$status[[hit[[1]]]] <- "Failed"
            batch_results$reason[[hit[[1]]]] <- "Object validation failed during commit"
          }
        }
      }

      incoming <- data.frame()
      if (length(sample_rows)) {
        incoming <- Reduce(
          f = function(acc, one) .bind_rows_safe(acc, one),
          x = sample_rows,
          init = data.frame(stringsAsFactors = FALSE)
        )
        current <- shared_data$full_sample_sheet
        if (is.null(current) || !is.data.frame(current)) current <- data.frame(stringsAsFactors = FALSE)
        merged <- .bind_rows_safe(current, incoming)
        merged <- merged[!duplicated(as.character(merged$name), fromLast = TRUE), , drop = FALSE]
        shared_data$full_sample_sheet <- merged
      }
      shared_data$all_seurat_objects <- reg
      # This import action creates a new object set. Make its final created
      # object canonical immediately; landing must not retain an older valid
      # active object merely because it still exists in the registry.
      if (length(imported_names)) {
        shared_data$active_object_name <- imported_names[[length(imported_names)]]
      }

      if (is.data.frame(csv_rows) && nrow(csv_rows)) {
        existing_csv <- shared_data$imported_tabular_files
        if (is.null(existing_csv) || !is.data.frame(existing_csv)) {
          existing_csv <- data.frame(name = character(0), path = character(0), type = character(0), stringsAsFactors = FALSE)
        }
        combined_csv <- .bind_rows_safe(existing_csv, csv_rows)
        shared_data$imported_tabular_files <- combined_csv[!duplicated(combined_csv$path), , drop = FALSE]
      }

      staged_samples(data.frame(
        id = character(0), name = character(0), path = character(0), type = character(0),
        condition = character(0), batch = character(0), stringsAsFactors = FALSE
      ))
      if (batch_manifest) {
        metadata_manifest_result(batch_results)
        metadata_manifest_df(data.frame())
        metadata_manifest_info(list())
        metadata_manifest_conflicts(data.frame())
        metadata_manifest_pending_commit(NULL)
      }
      h5ad_import_map_df(data.frame())
      h5ad_import_pending(NULL)
      removeModal()

      if (batch_manifest) {
        showModal(metadata_manifest_result_modal_content(ns))
      }

      showNotification(
        sprintf(
          "Imported: %d Seurat object(s), %d tabular file(s).",
          length(imported_names),
          if (is.data.frame(csv_rows)) nrow(csv_rows) else 0L
        ),
        type = "message"
      )
      if (length(failed_names)) {
        showNotification(
          sprintf("ATAC pairing failed for %d object(s): %s", length(failed_names), paste(unique(failed_names), collapse = ", ")),
          type = "error",
          duration = 10
        )
      }

      if (length(imported_names)) {
        shared_data$pending_import_auto_route <- list(
          sample_names = unique(imported_names),
          has_vdj_candidates = if (isTRUE(.fast_mode_active())) FALSE else isTRUE(has_vdj_cands),
          created_at = Sys.time()
        )
        if (isTRUE(.fast_mode_active())) {
          st <- shared_data$fast_loupe %||% list()
          st$imported_names <- unique(imported_names)
          shared_data$fast_loupe <- st
        }
      } else {
        showNotification(
          "Import finished, but no Seurat object was created from selected inputs.",
          type = "warning",
          duration = 8
        )
      }

      if (!isTRUE(.fast_mode_active()) && isTRUE(has_vdj_cands) && is.data.frame(incoming) && nrow(incoming)) {
        vdj_rows <- data.frame(
          name = as.character(incoming$name %||% ""),
          path = as.character(incoming$path %||% ""),
          stringsAsFactors = FALSE
        )
        vdj_rows <- vdj_rows[nzchar(vdj_rows$name) & nzchar(vdj_rows$path), , drop = FALSE]
        vdj_cands2 <- .detect_vdj_candidates(vdj_rows)
        if (is.data.frame(vdj_cands2) && nrow(vdj_cands2)) {
          vdj_detect_candidates(vdj_cands2)
          vdj_prompt_pending(list(
            sample_names = unique(imported_names),
            candidates = vdj_cands2,
            created_at = Sys.time()
          ))
        } else if (is.data.frame(vdj_cands) && nrow(vdj_cands)) {
          vdj_detect_candidates(vdj_cands)
          vdj_prompt_pending(list(
            sample_names = unique(imported_names),
            candidates = vdj_cands,
            created_at = Sys.time()
          ))
        }
      }
      invisible(list(imported_names = imported_names, failed_names = failed_names, batch_results = batch_results))
    }

    .run_atac_conflict_prompt_or_commit <- function(build, csv_rows, has_vdj_cands, vdj_cands) {
      entries <- build$entries %||% list()
      has_conflict <- FALSE
      if (is.list(entries) && length(entries)) {
        for (one in entries) {
          obj <- one$obj
          if (is.null(obj) || !inherits(obj, "Seurat")) next
          assays <- tryCatch(tolower(as.character(names(obj@assays))), error = function(e) character(0))
          if (any(assays == "atac")) {
            has_conflict <- TRUE
            break
          }
        }
      }
      if (!isTRUE(has_conflict)) {
        .run_commit_with_options(build, csv_rows, has_vdj_cands, vdj_cands, conflict_mode = "replace")
        return(invisible(NULL))
      }
      atac_pending_conflict(list(build = build, csv_rows = csv_rows, has_vdj_cands = has_vdj_cands, vdj_cands = vdj_cands))
      showModal(modalDialog(
        title = "ATAC assay already exists",
        easyClose = FALSE,
        p("Imported object(s) already contain an ATAC assay."),
        p("Default action is Replace existing ATAC. You can choose Keep both."),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(ns("atac_conflict_replace_btn"), "Replace existing", class = "btn btn-danger"),
          actionButton(ns("atac_conflict_keep_both_btn"), "Keep both", class = "btn btn-outline-secondary")
        )
      ))
      invisible(NULL)
    }

    .run_atac_preflight_commit <- function(build, csv_rows, has_vdj_cands, vdj_cands) {
      pair_df <- .atac_rows_for_confirm()
      if (!is.data.frame(pair_df) || !nrow(pair_df)) {
        .run_atac_conflict_prompt_or_commit(build, csv_rows, has_vdj_cands, vdj_cands)
        return(invisible(NULL))
      }
      miss_idx <- pair_df[!file.exists(vapply(pair_df$fragment_path, .atac_index_path, character(1))), , drop = FALSE]
      if (!nrow(miss_idx)) {
        .run_atac_conflict_prompt_or_commit(build, csv_rows, has_vdj_cands, vdj_cands)
        return(invisible(NULL))
      }
      atac_pending_index_build(list(
        build = build,
        csv_rows = csv_rows,
        has_vdj_cands = has_vdj_cands,
        vdj_cands = vdj_cands,
        missing_idx = miss_idx
      ))
      default_out <- dirname(as.character(miss_idx$fragment_path[[1]] %||% ""))
      showModal(modalDialog(
        title = "ATAC index (.tbi) missing",
        easyClose = FALSE,
        p("Some selected ATAC fragment files are missing .tbi index."),
        p("Auto-build is recommended before confirming import."),
        textInput(ns("atac_index_output_dir"), "Index output directory", value = default_out),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(ns("atac_index_build_btn"), "Auto-build now", class = "btn btn-primary")
        )
      ))
      invisible(NULL)
    }

    observeEvent(input$btn_confirm_import, {
      df <- staged_samples()
      req(nrow(df) > 0)
      .vdj_log("btn_confirm_import clicked.", "staged_n=", nrow(df))
      overlay_show("Importing selected files…", loader = "import")
      on.exit(overlay_hide(), add = TRUE)

      type_norm <- tolower(trimws(as.character(df$type)))
      valid_file <- vapply(seq_len(nrow(df)), function(i) {
        p <- as.character(df$path[i])
        tp <- type_norm[i]
        if (!nzchar(p)) return(FALSE)
        if (tp == "matrix") return(dir.exists(p))
        file.exists(p)
      }, logical(1))

      if (any(!valid_file)) {
        dropped <- sum(!valid_file)
        showNotification(sprintf("Skipped %d staged row(s): missing file/folder.", dropped), type = "warning")
      }
      df <- df[valid_file, , drop = FALSE]
      type_norm <- type_norm[valid_file]
      req(nrow(df) > 0)

      seurat_rows <- df[type_norm %in% c("h5", "hdf5", "h5ad", "matrix"), , drop = FALSE]
      csv_rows <- df[type_norm %in% c("csv", "tsv", "txt"), c("name", "path", "type"), drop = FALSE]

      build <- .sidebar_build_seurat_entries(seurat_rows)
      errs <- as.character(build$errors %||% character(0))
      errs <- errs[nzchar(errs)]
      if (length(errs)) {
        showNotification(
          paste("Some staged Seurat inputs failed:", paste(head(errs, 4), collapse = " | ")),
          type = "warning",
          duration = 12
        )
      }

      warns <- as.character(build$warnings %||% character(0))
      warns <- warns[nzchar(warns)]
      if (length(warns)) {
        showNotification(
          paste("Metadata conversion notes:", paste(head(warns, 3), collapse = " | ")),
          type = "message",
          duration = 10
        )
      }

      loaded_names <- vapply(build$entries %||% list(), function(e) as.character(e$name %||% ""), character(1))
      loaded_names <- loaded_names[nzchar(loaded_names)]
      seurat_rows_for_vdj <- if (length(loaded_names)) {
        data.frame(
          name = loaded_names,
          path = vapply(build$entries %||% list(), function(e) as.character(e$path %||% ""), character(1)),
          stringsAsFactors = FALSE
        )
      } else {
        data.frame()
      }
      vdj_cands <- .detect_vdj_candidates(seurat_rows_for_vdj)
      has_vdj_cands <- is.data.frame(vdj_cands) && nrow(vdj_cands) > 0

      map_df <- build$map_df
      if (is.data.frame(map_df) && nrow(map_df)) {
        h5ad_import_pending(list(
          entries = build$entries,
          csv_rows = csv_rows,
          has_vdj_cands = has_vdj_cands,
          vdj_cands = vdj_cands
        ))
        h5ad_import_map_df(map_df)
        .show_h5ad_mapping_modal(map_df)
        return()
      }

      .run_atac_preflight_commit(build, csv_rows, has_vdj_cands, vdj_cands)
    })

    observeEvent(input$h5ad_import_confirm_btn, {
      pending <- h5ad_import_pending()
      req(is.list(pending), is.list(pending$entries))
      map_now <- h5ad_import_map_df()
      persisted_keys <- as.character(h5ad_last_selected_keys() %||% character(0))
      persisted_keys <- unique(persisted_keys[nzchar(persisted_keys)])
      sel <- as.integer(input$h5ad_import_map_table_rows_selected %||% integer(0))
      sel <- sel[is.finite(sel)]
      used_row_selection <- FALSE
      if (is.data.frame(map_now) && nrow(map_now) && length(sel)) {
        sel <- sel[sel >= 1 & sel <= nrow(map_now)]
        if (length(sel)) {
          map_now <- map_now[sel, , drop = FALSE]
          if ("import_key" %in% colnames(map_now)) {
            keys_now <- unique(as.character(map_now$import_key %||% character(0)))
            keys_now <- keys_now[nzchar(keys_now)]
            if (length(keys_now)) h5ad_last_selected_keys(keys_now)
          }
          used_row_selection <- TRUE
        }
      }
      if (!isTRUE(used_row_selection) && is.data.frame(map_now) && nrow(map_now) &&
          "import_key" %in% colnames(map_now) && length(persisted_keys)) {
        keep_persisted <- as.character(map_now$import_key %||% "") %in% persisted_keys
        if (any(keep_persisted)) {
          map_now <- map_now[keep_persisted, , drop = FALSE]
          used_row_selection <- TRUE
        }
      }
      if (!is.data.frame(map_now) || !nrow(map_now)) {
        showNotification("No samples selected. Choose at least one row to import.", type = "warning")
        return()
      }
      build <- list(entries = pending$entries, map_df = map_now)
      .run_atac_preflight_commit(
        build = build,
        csv_rows = pending$csv_rows %||% data.frame(),
        has_vdj_cands = isTRUE(pending$has_vdj_cands),
        vdj_cands = pending$vdj_cands %||% data.frame()
      )
    })

    observeEvent(input$atac_index_build_btn, {
      pending <- atac_pending_index_build()
      req(is.list(pending), is.data.frame(pending$missing_idx), nrow(pending$missing_idx) > 0)
      out_dir <- as.character(input$atac_index_output_dir %||% "")
      if (!nzchar(out_dir) || !dir.exists(out_dir)) {
        showNotification("Index output directory is missing or invalid.", type = "error")
        return(invisible(NULL))
      }
      if (!requireNamespace("Rsamtools", quietly = TRUE)) {
        showNotification("Missing package 'Rsamtools'; cannot auto-build .tbi index.", type = "error")
        return(invisible(NULL))
      }
      ok_n <- 0L
      fail_n <- 0L
      for (i in seq_len(nrow(pending$missing_idx))) {
        fp <- as.character(pending$missing_idx$fragment_path[[i]] %||% "")
        if (!nzchar(fp) || !file.exists(fp)) {
          fail_n <- fail_n + 1L
          next
        }
        res <- tryCatch({
          idx_path <- Rsamtools::indexTabix(fp, format = "bed")
          TRUE
        }, error = function(e) FALSE)
        if (!isTRUE(res)) {
          fail_n <- fail_n + 1L
          next
        }
        src_idx <- .atac_index_path(fp)
        if (file.exists(src_idx)) {
          try(file.copy(src_idx, file.path(out_dir, basename(src_idx)), overwrite = TRUE), silent = TRUE)
        }
        ok_n <- ok_n + 1L
      }
      removeModal()
      if (fail_n > 0L) {
        showNotification(sprintf("Built %d index file(s), %d failed.", ok_n, fail_n), type = "warning")
      } else {
        showNotification(sprintf("Built %d index file(s).", ok_n), type = "message")
      }
      .run_atac_conflict_prompt_or_commit(
        build = pending$build,
        csv_rows = pending$csv_rows %||% data.frame(),
        has_vdj_cands = isTRUE(pending$has_vdj_cands),
        vdj_cands = pending$vdj_cands %||% data.frame()
      )
      atac_pending_index_build(NULL)
    })

    observeEvent(input$atac_conflict_replace_btn, {
      pending <- atac_pending_conflict()
      req(is.list(pending), is.list(pending$build))
      removeModal()
      .run_commit_with_options(
        build = pending$build,
        csv_rows = pending$csv_rows %||% data.frame(),
        has_vdj_cands = isTRUE(pending$has_vdj_cands),
        vdj_cands = pending$vdj_cands %||% data.frame(),
        conflict_mode = "replace"
      )
      atac_pending_conflict(NULL)
    })

    observeEvent(input$atac_conflict_keep_both_btn, {
      pending <- atac_pending_conflict()
      req(is.list(pending), is.list(pending$build))
      removeModal()
      .run_commit_with_options(
        build = pending$build,
        csv_rows = pending$csv_rows %||% data.frame(),
        has_vdj_cands = isTRUE(pending$has_vdj_cands),
        vdj_cands = pending$vdj_cands %||% data.frame(),
        conflict_mode = "keep_both"
      )
      atac_pending_conflict(NULL)
    })

    observeEvent(input$metadata_manifest_confirm_btn, {
      df <- metadata_manifest_df()
      info <- metadata_manifest_info()
      req(is.data.frame(df), nrow(df) > 0, is.list(info), length(info))
      df <- .metadata_manifest_refresh(df, info, root_path = as.character(info$root_path %||% ""))
      metadata_manifest_df(df)
      included <- as.logical(df$`__include_sample`)
      invalid_included <- which(included & !as.logical(df$`__ready`))
      if (length(invalid_included)) {
        showNotification(
          sprintf("Resolve or exclude %d included row(s) before importing. Gray rows show the reason.", length(invalid_included)),
          type = "warning",
          duration = 10
        )
        return(invisible(NULL))
      }
      built <- .metadata_manifest_build_rows(df, info)
      if (!is.data.frame(built$result) || !nrow(built$result)) {
        showNotification("No manifest rows are available.", type = "warning")
        return(invisible(NULL))
      }
      if (!is.data.frame(built$rows) || !nrow(built$rows)) {
        metadata_manifest_result(built$result)
        metadata_manifest_df(data.frame())
        metadata_manifest_info(list())
        removeModal()
        showModal(metadata_manifest_result_modal_content(ns))
        return(invisible(NULL))
      }
      selected_total <- nrow(built$rows)
      overlay_show(
        sprintf("Loading sample 0 of %d...", selected_total),
        pct = 5,
        loader = "import"
      )
      on.exit(overlay_hide(), add = TRUE)
      manifest_progress <- function(index = 0L, total = selected_total, label = "") {
        total_use <- max(1L, as.integer(total %||% selected_total))
        index_use <- suppressWarnings(as.integer(index %||% 0L))
        if (!is.finite(index_use)) index_use <- 0L
        index_use <- max(0L, min(total_use, index_use))
        pct <- 5 + (80 * index_use / total_use)
        overlay_show(
          text = if (nzchar(as.character(label %||% ""))) as.character(label) else "Loading selected manifest inputs...",
          pct = pct,
          loader = "import"
        )
        invisible(NULL)
      }
      manifest_progress(
        0L,
        selected_total,
        sprintf("Preparing %d selected sample(s)...", selected_total)
      )
      build <- .sidebar_build_seurat_entries(built$rows, progress = manifest_progress)
      overlay_show("Saving imported records...", pct = 90, loader = "package")
      errs <- as.character(build$errors %||% character(0))
      if (length(errs)) {
        showNotification(
          paste("Some manifest rows failed:", paste(head(errs, 4), collapse = " | ")),
          type = "warning",
          duration = 12
        )
      }
      warns <- as.character(build$warnings %||% character(0))
      if (length(warns)) {
        showNotification(
          paste("Manifest metadata notes:", paste(head(warns, 3), collapse = " | ")),
          type = "message",
          duration = 10
        )
      }
      overlay_show("Finalizing import results...", pct = 98, loader = "package")
      .metadata_manifest_commit_build(build, built$result)
      invisible(NULL)
    })

    .flush_pending_import_route <- function() {
      pending <- shared_data$pending_import_auto_route
      if (is.null(pending)) return(invisible(FALSE))

      target_names <- unique(as.character(pending$sample_names %||% character(0)))
      if (!length(target_names)) {
        shared_data$pending_import_auto_route <- NULL
        return(invisible(FALSE))
      }

      reg <- shared_data$all_seurat_objects %||% list()
      loaded <- target_names[target_names %in% names(reg)]
      if (!length(loaded)) {
        .vdj_log(
          "pending route waiting for object creation.",
          "targets=", paste(target_names, collapse = ","),
          "registry_n=", length(reg)
        )
        return(invisible(FALSE))
      }

      has_hto <- FALSE
      has_atac <- FALSE
      if (length(loaded)) {
        for (nm in loaded) {
          entry <- reg[[nm]]
          obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
          assays <- tryCatch(tolower(as.character(names(obj@assays))), error = function(e) character(0))
          if (length(assays) &&
              (any(assays %in% c("adt", "hto")) || any(grepl("hash|hashtag|adt|hto|antibody|cite", assays, perl = TRUE)))) {
            has_hto <- TRUE
            break
          }
          if (length(assays) &&
              (any(assays %in% c("atac", "peaks", "chromatin")) || any(grepl("atac|peak|chromatin", assays, perl = TRUE)))) {
            has_atac <- TRUE
          }
        }
      }

      route_tab <- if (isTRUE(.fast_mode_active())) {
        "analysis_tab"
      } else if (isTRUE(has_hto)) {
        "hto_tab"
      } else if (isTRUE(pending$has_vdj_candidates)) {
        "vdj_tab"
      } else if (isTRUE(has_atac)) {
        "atac_qc_tab"
      } else {
        "qc_tab"
      }

      shared_data$pending_import_auto_route <- NULL
      session$onFlushed(function() {
        updateNavbarPage(parent_session, "main_navbar", selected = route_tab)
      }, once = TRUE)
      invisible(TRUE)
    }

    observeEvent(shared_data$pending_import_auto_route, {
      .flush_pending_import_route()
      invisible(NULL)
    }, ignoreInit = TRUE)

    observeEvent(shared_data$all_seurat_objects, {
      .flush_pending_import_route()
      invisible(NULL)
    }, ignoreInit = TRUE)

    observeEvent(shared_data$all_seurat_objects, {
      if (isTRUE(.fast_mode_active())) return(invisible(NULL))
      pending <- vdj_prompt_pending()
      req(!is.null(pending))

      target_names <- unique(as.character(pending$sample_names %||% character(0)))
      cands <- pending$candidates
      if (!length(target_names) || is.null(cands) || !is.data.frame(cands) || !nrow(cands)) {
        vdj_prompt_pending(NULL)
        return(invisible(NULL))
      }

      reg <- shared_data$all_seurat_objects %||% list()
      loaded <- target_names[target_names %in% names(reg)]
      if (!length(loaded)) return(invisible(NULL))

      all_loaded <- length(loaded) >= length(target_names)
      age_secs <- as.numeric(difftime(Sys.time(), as.POSIXct(pending$created_at %||% Sys.time()), units = "secs"))
      if (!is.finite(age_secs)) age_secs <- 0

      # Show prompt only after object loading is effectively complete (or timeout fallback).
      if (!all_loaded && age_secs < 12) return(invisible(NULL))

      vdj_prompt_pending(NULL)
      session$onFlushed(function() {
        .show_vdj_detect_modal(cands)
      }, once = TRUE)
    }, ignoreInit = TRUE)

    observeEvent(input$vdj_detect_confirm, {
      cands <- vdj_detect_candidates()
      req(is.data.frame(cands), nrow(cands) > 0)
      sel <- as.character(input$vdj_detect_select %||% character(0))
      .vdj_log("vdj_detect_confirm clicked.", "candidate_n=", nrow(cands), "selected_n=", length(sel))
      if (!length(sel)) {
        showNotification("No VDJ chain selected.", type = "warning")
        return()
      }
      chosen <- cands[cands$id %in% sel, , drop = FALSE]
      if (!nrow(chosen)) {
        showNotification("No VDJ file matched your selection.", type = "warning")
        return()
      }

      .attach_vdj_links_to_objects(chosen)
      .vdj_log("vdj_detect_confirm object-link attach.",
               "chosen_n=", nrow(chosen),
               "chosen_sources=", paste(head(basename(as.character(chosen$file_path)), 4), collapse = " | "))
      removeModal()
      showNotification(
        sprintf("Incorporated %d VDJ file(s): %d TCR, %d BCR.",
                nrow(chosen), sum(chosen$chain == "TCR"), sum(chosen$chain == "BCR")),
        type = "message"
      )
      session$onFlushed(function() {
        updateNavbarPage(parent_session, "main_navbar", selected = "vdj_tab")
      }, once = TRUE)
    })

    .entry_obj <- function(entry) {
      if (is.null(entry)) return(NULL)
      if (is.list(entry) && !is.null(entry$obj)) return(entry$obj)
      entry
    }

    .assay_names <- function(obj) {
      tryCatch(as.character(names(obj@assays)), error = function(e) character(0))
    }

    .has_hto_assay <- function(obj) {
      assays <- tolower(.assay_names(obj))
      if (!length(assays)) return(FALSE)
      isTRUE(
        any(assays %in% c("adt", "hto")) ||
          any(grepl("hash|hashtag|adt|hto|antibody|cite", assays, perl = TRUE))
      )
    }

    .has_rna_assay <- function(obj) {
      assays <- tolower(.assay_names(obj))
      if (!length(assays)) return(FALSE)
      isTRUE(any(assays == "rna") || any(grepl("rna", assays, perl = TRUE)))
    }

    metadata_edit_df <- reactiveVal(data.frame())

    output$metadata_edit_table <- renderDT({
      df <- metadata_edit_df()
      req(is.data.frame(df), nrow(df) > 0)
      datatable(
        .safe_select_cols(df, c("name", "condition", "batch", "path"), default = ""),
        rownames = FALSE,
        selection = "none",
        editable = list(target = "cell", disable = list(columns = c(3))),
        options = list(dom = "t", paging = FALSE, scrollX = TRUE, autoWidth = TRUE),
        colnames = c("Name", "Condition", "Batch", "Path")
      )
    }, server = FALSE)

    observeEvent(input$metadata_edit_table_cell_edit, {
      info <- input$metadata_edit_table_cell_edit
      df <- metadata_edit_df()
      i <- info$row
      display_cols <- c("name", "condition", "batch", "path")
      j <- info$col + 1
      if (!nrow(df) || i < 1 || i > nrow(df) || j < 1 || j > length(display_cols)) return()
      col_name <- display_cols[j]
      if (!col_name %in% c("name", "condition", "batch")) return()
      df[i, col_name] <- as.character(info$value)
      metadata_edit_df(df)
    })

    observeEvent(input$btn_edit_metadata, {
      reg <- .build_registry()
      sel <- input$data_registry_table_rows_selected
      sample_df <- shared_data$full_sample_sheet
      if (is.null(sample_df) || !is.data.frame(sample_df) || !nrow(sample_df)) {
        showNotification("No sample metadata is available to edit.", type = "warning")
        return()
      }
      idx <- seq_len(nrow(sample_df))
      if (!is.null(sel) && length(sel) && nrow(reg)) {
        chosen <- reg[sel, , drop = FALSE]
        chosen_names <- as.character(chosen$name[chosen$kind == "Seurat object"] %||% character(0))
        chosen_names <- chosen_names[!is.na(chosen_names) & nzchar(chosen_names)]
        if (length(chosen_names)) {
          idx <- which(as.character(sample_df$name %||% character(0)) %in% chosen_names)
        }
      }
      if (!length(idx)) {
        showNotification("No matching sample rows found for current selection.", type = "warning")
        return()
      }

      metadata_edit_df(sample_df[idx, , drop = FALSE])
      showModal(modalDialog(
        title = "Edit Sample Metadata",
        size = "l",
        easyClose = FALSE,
        DTOutput(ns("metadata_edit_table")),
        footer = tagList(
          modalButton("Cancel"),
          actionButton(ns("btn_save_metadata_edit"), "Save Metadata", class = "btn-primary", icon = icon("save"))
        )
      ))
    })

    observeEvent(input$btn_save_metadata_edit, {
      edits <- metadata_edit_df()
      req(is.data.frame(edits), nrow(edits) > 0)
      sample_df <- shared_data$full_sample_sheet
      req(is.data.frame(sample_df), nrow(sample_df) > 0)

      reg <- shared_data$all_seurat_objects %||% list()
      for (i in seq_len(nrow(edits))) {
        idx <- match(as.character(edits$name[i] %||% ""), as.character(sample_df$name %||% ""))
        if (is.na(idx)) idx <- match(as.character(edits$path[i] %||% ""), as.character(sample_df$path %||% ""))
        if (is.na(idx)) next

        old_name <- as.character(sample_df$name[idx])
        new_name <- as.character(edits$name[i])

        sample_df$name[idx] <- new_name
        sample_df$condition[idx] <- as.character(edits$condition[i])
        sample_df$batch[idx] <- as.character(edits$batch[i])

        if (!identical(old_name, new_name) && nzchar(old_name) && nzchar(new_name)) {
          if (!is.null(reg[[old_name]]) && is.null(reg[[new_name]])) {
            reg[[new_name]] <- reg[[old_name]]
            reg[[old_name]] <- NULL
          }

          old_filtered <- paste0(old_name, "_filtered")
          new_filtered <- paste0(new_name, "_filtered")
          if (!is.null(reg[[old_filtered]]) && is.null(reg[[new_filtered]])) {
            reg[[new_filtered]] <- reg[[old_filtered]]
            reg[[old_filtered]] <- NULL
          }
        }
      }

      shared_data$full_sample_sheet <- sample_df
      shared_data$all_seurat_objects <- reg
      removeModal()
      showNotification("Sample metadata updated.", type = "message")
    })

    observeEvent(input$btn_save_workspace, {
      env_name <- shared_data$active_environment$name %||% ""
      if (!nzchar(env_name)) {
        showNotification("Select an environment first.", type = "warning")
        return()
      }
      updateNavbarPage(parent_session, "main_navbar", selected = "rds_tab")
    })
  })
}
