# QC UI contract reference:
# docs/agents/qc/QC_UI_CONTRACT.md
# RNA QC is the source-of-truth page for shared QC UI/plot conventions.
# Lock-step rule: any UI/style/plot change here must trigger explicit sync decision for page_atac_qc.R.

UI_TEXT <- list(
  t_btn_apply_filters_add_workspace = "Apply filters & add to workspace",
  t_label_lower_offset_b = "Lower offset b",
  t_label_max_features = "Max Features",
  t_label_max_mito = "Max Mito %",
  t_label_max_rna_counts_cell = "Max RNA Counts/Cell",
  t_label_min_features = "Min Features",
  t_label_min_rna_counts_cell = "Min RNA Counts/Cell",
  t_label_slope_lower_coeff_b = "Slope lower (coeff_b)",
  t_label_slope_upper_coeff = "Slope upper (coeff_a)",
  t_label_upper_offset = "Upper offset a",
  t_label_viewing_object = "Viewing object",
  t_label_regression_overlay = "Regression overlay",
  t_text_regression_overlay_note = "Filter sliders follow the selected mode: linear (None), log-x (Log), log-log (Power), or saturating envelopes (Saturating).",
  t_opt_regression_none = "None",
  t_opt_regression_log = "Log model: y ~ log10(x)",
  t_opt_regression_power = "Power law: log10(y) ~ log10(x)",
  t_opt_regression_saturating = "Saturating: y ~ Vmax*x/(Km+x)",
  t_opt_regression_all = "Show all models",
  t_text_adjust_per_sample_thresholds_left_panel = "Adjust per-sample thresholds in the left panel, then apply filtering.",
  t_text_ncount_rna = "nCount_RNA",
  t_text_nfeature_rna = "nFeature_RNA",
  t_text_no_samples_loaded_yet_please_add = "No samples loaded yet â Please add files from the right sidebar â Populate sample parameters.",
  t_text_update_thresholds_all_samples = "Apply to all included samples",
  t_btn_apply_current_sample_only = "Apply to current sample only",
  t_btn_exclude = "Exclude",
  t_btn_include = "Include",
  t_btn_exclude_selected = "Exclude selected",
  t_btn_include_selected = "Include selected",
  t_btn_generate_qc_report = "Export Filter Records for All Included",
  t_text_excluded_from_final_filtering = "Excluded from final filtering list.",
  t_title_per_sample_thresholds = "Per-sample thresholds",
  t_title_qc_qc_configuration_visualization = "QC: QC Configuration & Visualization",
  t_title_qc_viewer = "QC Viewer",
  t_title_sample_qc_parameters = "Sample QC Parameters",
  t_text_adjust_sliders_then_apply_filtering_create_filtered_objects_workspace = "Adjust sliders, then apply filtering to create filtered objects in workspace.",
  t_text_viewing_object_not_available_yet = "Viewing object: not available yet."

)

library(DT)
library(shiny)
library(shinyjs)
library(plotly)
library(bslib)
library(vipor)
library(shinycssloaders)
library(shinybusy)

`%||%` <- function(a,b) if (is.null(a)) b else a

qc_ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "qc.css"),
    tags$script(HTML(
      "(function () {
         var dragging = false;
         var sliderIdRe = /^(qc_min_features|qc_max_features|qc_min_umi|qc_max_umi|qc_max_mt|qc_coeff_a|qc_upper_a|qc_coeff_b|qc_lower_b)$/;
         function setDragFlag(val) {
           if (!window.Shiny || !Shiny.setInputValue) return;
           Shiny.setInputValue('qc_slider_dragging', !!val, { priority: 'event' });
         }
         document.addEventListener('mousedown', function (ev) {
           var t = ev.target;
           if (!t || !t.closest('.qc-sidebar-panel .irs')) return;
           dragging = true;
           setDragFlag(true);
         }, true);
         document.addEventListener('touchstart', function (ev) {
           var t = ev.target;
           if (!t || !t.closest('.qc-sidebar-panel .irs')) return;
           dragging = true;
           setDragFlag(true);
         }, { passive: true, capture: true });
         document.addEventListener('mouseup', function () {
           if (!dragging) return;
           dragging = false;
           setDragFlag(false);
         }, true);
         document.addEventListener('touchend', function () {
           if (!dragging) return;
           dragging = false;
           setDragFlag(false);
         }, { passive: true, capture: true });
         document.addEventListener('pointerup', function () {
           if (!dragging) return;
           dragging = false;
           setDragFlag(false);
         }, true);
         document.addEventListener('pointercancel', function () {
           if (!dragging) return;
           dragging = false;
           setDragFlag(false);
         }, true);
         document.addEventListener('keyup', function (ev) {
           var t = ev && ev.target;
           if (!t || !t.id || !sliderIdRe.test(t.id)) return;
           var k = ev.key || '';
           if (k === 'ArrowLeft' || k === 'ArrowRight' || k === 'ArrowUp' || k === 'ArrowDown' || k === 'PageUp' || k === 'PageDown' || k === 'Home' || k === 'End') {
             // server-side observer handles commit when dragging is false
           }
         }, true);
         document.addEventListener('change', function (ev) {
           var t = ev && ev.target;
           if (!t || !t.id || !sliderIdRe.test(t.id)) return;
           if (dragging) return;
           if (!ev || ev.isTrusted !== true) return;
           if (!window.Shiny || !Shiny.setInputValue) return;
           Shiny.setInputValue('qc_slider_commit_nonce', Date.now(), { priority: 'event' });
         }, true);
         window.addEventListener('blur', function () {
           if (!dragging) return;
           dragging = false;
           setDragFlag(false);
         });
      })();"
    ))
  ),
  div(
    class = "app-page plotting-page qc-lock-left-float",
    div(
      class = "page-header",
      h2(icon("filter"), " ", UI_TEXT$t_title_qc_qc_configuration_visualization),
      p(UI_TEXT$t_text_adjust_per_sample_thresholds_left_panel)
    ),
    card_page_card(
      title = UI_TEXT$t_title_sample_qc_parameters,
      uiOutput("qc_parameter_table_box"),
      class = "qc-parameter-card"
    ),

    hr(),
    h3(UI_TEXT$t_title_qc_viewer),

    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "qc-sidebar-panel plotting-left-panel",
        div(
          class = "qc-sticky wl-side",
          h4(class = "qc-panel-title", UI_TEXT$t_title_per_sample_thresholds),
          helpText(UI_TEXT$t_text_adjust_sliders_then_apply_filtering_create_filtered_objects_workspace),
          uiOutput("qc_view_object_ui"),
          selectInput(
            "qc_regression_overlay",
            UI_TEXT$t_label_regression_overlay,
            choices = stats::setNames(
              c("none", "log", "power", "saturating", "all"),
              c(
                UI_TEXT$t_opt_regression_none %||% "None",
                UI_TEXT$t_opt_regression_log %||% "Log model: y ~ log10(x)",
                UI_TEXT$t_opt_regression_power %||% "Power law: log10(y) ~ log10(x)",
                UI_TEXT$t_opt_regression_saturating %||% "Saturating: y ~ Vmax*x/(Km+x)",
                UI_TEXT$t_opt_regression_all %||% "Show all models"
              )
            ),
            selected = "none"
          ),
          helpText(UI_TEXT$t_text_regression_overlay_note %||% "Slope sliders act in the current displayed space: linear (None/All/Saturating), log-x (Log model), or log-log (Power law)."),
          sliderInput("qc_min_features", UI_TEXT$t_label_min_features, min = 0, max = 10000, value = 200, step = 10),
          sliderInput("qc_max_features", UI_TEXT$t_label_max_features, min = 0, max = 10000, value = 5000, step = 10),
          sliderInput("qc_min_umi", UI_TEXT$t_label_min_rna_counts_cell, min = 0, max = 100000, value = 500, step = 50),
          sliderInput("qc_max_umi", UI_TEXT$t_label_max_rna_counts_cell, min = 0, max = 100000, value = 50000, step = 500),
          sliderInput("qc_max_mt", UI_TEXT$t_label_max_mito, min = 0, max = 100, value = 20, step = 1),
          tags$hr(),
          sliderInput("qc_coeff_a", UI_TEXT$t_label_slope_upper_coeff, min = 0, max = 2, value = 0.5, step = 0.01),
          sliderInput("qc_upper_a", UI_TEXT$t_label_upper_offset, min = 0, max = 20000, value = 1300, step = 50),
          sliderInput("qc_coeff_b", UI_TEXT$t_label_slope_lower_coeff_b, min = 0, max = 0.5, value = 0.05, step = 0.01),
          sliderInput("qc_lower_b", UI_TEXT$t_label_lower_offset_b, min = -5000, max = 5000, value = 0, step = 10),
          br(),
          actionButton(
            "apply_current_sample_btn",
            UI_TEXT$t_btn_apply_current_sample_only %||% "Apply to current sample only",
            class = "btn btn-default btn-block",
            icon = icon("dot-circle")
          ),
          div(style = "height:6px"),
          actionButton(
            "apply_all_samples_btn",
            UI_TEXT$t_text_update_thresholds_all_samples,
            class = "btn btn-default btn-block",
            icon = icon("clone")
          ),
          div(style = "height:6px"),
          actionButton("qc_refresh_btn", UI_TEXT$t_btn_apply_filters_add_workspace, class = "btn btn-primary btn-block", icon = icon("filter")),
          div(style = "height:6px"),
          downloadButton("qc_download_report_btn", UI_TEXT$t_btn_generate_qc_report %||% "Export Filter Record", class = "btn btn-default btn-block")
        )
      ),
      mainPanel(
        width = 9,
        class = "plot_area_card_style",
        uiOutput("qc_plot_area_ui")
      )
    )
  )
)

qc_server <- function(input, output, session, shared_data) {
  qc_tab_visited <- reactiveVal(FALSE)
  .qc_should_log <- function() {
    # This helper is called from both reactive and non-reactive paths.
    # Guard reads so startup cannot fail on missing reactive context.
    visited <- tryCatch(shiny::isolate(qc_tab_visited()), error = function(e) FALSE)
    if (isTRUE(visited)) return(TRUE)
    tab_now <- tryCatch(shiny::isolate(input$main_navbar %||% ""), error = function(e) "")
    identical(tab_now, "qc_tab")
  }
  .qc_log <- function(...) {
    if (!.qc_should_log()) return(invisible(NULL))
    message(...)
    invisible(NULL)
  }
  .safe_select_cols <- function(df, cols, default = NA) {
    if (is.null(df) || !is.data.frame(df)) return(data.frame(stringsAsFactors = FALSE))
    n <- nrow(df)
    out <- setNames(vector("list", length(cols)), cols)
    for (cc in cols) {
      if (cc %in% colnames(df)) {
        v <- df[[cc]]
        if (length(v) == 0 && n > 0) v <- rep(default, n)
        if (length(v) != n) v <- rep(v, length.out = n)
        out[[cc]] <- v
      } else {
        out[[cc]] <- rep(default, n)
      }
    }
    as.data.frame(out, stringsAsFactors = FALSE, check.names = FALSE)
  }
  # return the Seurat object from a registry entry or raw Seurat if already one
  .get_entry_obj <- function(entry) {
    if (is.null(entry)) return(NULL)
    if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
  }

  .unwrap_seurat_candidate <- function(x, depth = 0L) {
    if (is.null(x)) return(NULL)
    if (inherits(x, "Seurat")) return(x)
    if (depth > 4L || !is.list(x)) return(NULL)

    for (nm in c("obj", "object", "seurat", "sobj", "data")) {
      if (!is.null(x[[nm]]) && inherits(x[[nm]], "Seurat")) return(x[[nm]])
    }
    for (nm in c("obj", "object", "seurat", "sobj", "data")) {
      if (!is.null(x[[nm]]) && is.list(x[[nm]])) {
        y <- .unwrap_seurat_candidate(x[[nm]], depth = depth + 1L)
        if (inherits(y, "Seurat")) return(y)
      }
    }
    for (i in seq_along(x)) {
      y <- x[[i]]
      if (inherits(y, "Seurat")) return(y)
      if (is.list(y)) {
        z <- .unwrap_seurat_candidate(y, depth = depth + 1L)
        if (inherits(z, "Seurat")) return(z)
      }
    }
    NULL
  }
  
  # pick the best entry name for a sample: filtered if present, else raw
  .pick_best_entry_name <- function(nm, registry) {
    fn_rna <- paste0(nm, "_rna_filtered")
    if (!is.null(registry[[fn_rna]])) return(fn_rna)
    fn <- paste0(nm, "_filtered")
    if (!is.null(registry[[fn]])) return(fn)
    nm
  }
  
  # choose which samples to send to Analysis
  .pick_samples_for_analysis <- function(df, selected_rows) {
    keep_mask <- !(as.logical(df$excluded_from_final %||% FALSE))
    keep_idx <- which(keep_mask)
    if (!length(keep_idx)) return(character(0))
    if (!is.null(selected_rows) && length(selected_rows) > 0) {
      sel <- unique(as.integer(selected_rows))
      sel <- sel[is.finite(sel) & sel >= 1 & sel <= nrow(df)]
      sel <- sel[keep_mask[sel]]
      if (length(sel)) return(df$name[sel])
    }
    flagged <- df$name[which(as.logical(df$use_in_analysis %||% FALSE) & keep_mask)]
    if (length(flagged) > 0) return(flagged)
    df$name[[keep_idx[[1]]]]
  }
  .ensure_qc_table_cols <- function(df) {
    if (is.null(df) || !is.data.frame(df)) return(data.frame(stringsAsFactors = FALSE))
    n <- nrow(df)
    add_col <- function(nm, value) {
      if (nm %in% colnames(df)) return(invisible(NULL))
      vv <- value
      if (length(vv) == 0) {
        vv <- rep(NA, n)
      } else if (length(vv) == 1) {
        vv <- rep(vv, n)
      } else if (length(vv) != n) {
        vv <- rep(vv, length.out = n)
      }
      df[[nm]] <<- vv
    }
    add_col("name", "")
    add_col("condition", "Unknown")
    add_col("batch", "Batch1")
    add_col("min_features", 200)
    add_col("max_features", 5000)
    add_col("min_umi_counts", 500)
    add_col("max_umi_counts", 50000)
    add_col("max_mt_percent", 20)
    add_col("use_in_analysis", TRUE)
    add_col("qc_status", "Pending")
    add_col("excluded_from_final", FALSE)
    add_col("source_object", as.character(df$name %||% rep("", n)))
    add_col("path", "")
    df$name <- as.character(df$name %||% "")
    df$condition <- as.character(df$condition %||% "Unknown")
    df$batch <- as.character(df$batch %||% "Batch1")
    src <- as.character(df$source_object %||% df$name)
    nmv <- as.character(df$name %||% "")
    bad_src <- is.na(src) | !nzchar(trimws(src))
    src[bad_src] <- nmv[bad_src]
    df$source_object <- src
    .as_logical_flag <- function(x, default = FALSE) {
      if (is.logical(x)) {
        out <- x
      } else if (is.numeric(x)) {
        out <- x != 0
      } else {
        sx <- tolower(trimws(as.character(x %||% "")))
        out <- ifelse(
          sx %in% c("true", "t", "1", "yes", "y"),
          TRUE,
          ifelse(sx %in% c("false", "f", "0", "no", "n", ""), FALSE, NA)
        )
      }
      out <- as.logical(out)
      out[is.na(out)] <- isTRUE(default)
      out
    }
    df$qc_status <- as.character(df$qc_status %||% "Pending")
    df$excluded_from_final <- .as_logical_flag(df$excluded_from_final %||% FALSE, default = FALSE)
    df$use_in_analysis <- .as_logical_flag(df$use_in_analysis %||% TRUE, default = TRUE)
    num_cols <- c("min_features", "max_features", "min_umi_counts", "max_umi_counts", "max_mt_percent")
    for (nm in num_cols) {
      vv <- suppressWarnings(as.numeric(df[[nm]]))
      if (all(!is.finite(vv))) vv <- rep(0, n)
      vv[!is.finite(vv)] <- stats::median(vv[is.finite(vv)], na.rm = TRUE)
      vv[!is.finite(vv)] <- 0
      df[[nm]] <- vv
    }
    df
  }
  .rbind_align <- function(a, b) {
    if (is.null(a) || !is.data.frame(a)) a <- data.frame(stringsAsFactors = FALSE)
    if (is.null(b) || !is.data.frame(b)) b <- data.frame(stringsAsFactors = FALSE)
    cols <- union(colnames(a), colnames(b))
    if (!length(cols)) return(data.frame(stringsAsFactors = FALSE))
    for (nm in setdiff(cols, colnames(a))) a[[nm]] <- rep(NA, nrow(a))
    for (nm in setdiff(cols, colnames(b))) b[[nm]] <- rep(NA, nrow(b))
    a <- a[, cols, drop = FALSE]
    b <- b[, cols, drop = FALSE]
    rbind(a, b)
  }
  
  active_name     <- reactiveVal(NULL)
  viewer_object_name <- reactiveVal(NULL)
  qc_table_data   <- reactiveVal(NULL)
  qc_preload_errors <- reactiveVal(NULL)
  threshold_cache <- reactiveVal(list())
  qc_committed_slope_space <- reactiveVal("linear")
  qc_mode_pending <- reactiveVal(FALSE)
  qc_plot_cache   <- reactiveVal(list())
  qc_diag_text    <- reactiveVal("")
  qc_overlay_on   <- reactiveVal(FALSE)
  qc_render_pending <- reactiveVal(FALSE)
  qc_render_targets <- c("qc_vln_plot_nfeature", "qc_vln_plot_ncount", "qc_vln_plot_mt", "qc_scatter_main")
  qc_render_epoch <- reactiveVal(0L)
  qc_render_status <- reactiveVal(stats::setNames(rep(FALSE, length(qc_render_targets)), qc_render_targets))
  qc_current_threshold_sample <- reactiveVal(NULL)

  .set_qc_diag <- function(...) {
    txt <- paste(..., collapse = "")
    qc_diag_text(txt)
    if (nzchar(txt)) .qc_log("[QC-DIAG] ", txt)
    invisible(NULL)
  }

  .show_qc_overlay <- function(text = "Preparing QC plots...") {
    overlay_show(text, loader = "metrics")
    qc_overlay_on(TRUE)
    invisible(NULL)
  }

  .hide_qc_overlay <- function() {
    overlay_hide()
    qc_overlay_on(FALSE)
    invisible(NULL)
  }

  .reset_qc_render_cycle <- function(invalidate = FALSE) {
    if (isTRUE(invalidate)) {
      qc_render_epoch(as.integer(isolate(qc_render_epoch())) + 1L)
    }
    qc_render_status(stats::setNames(rep(FALSE, length(qc_render_targets)), qc_render_targets))
    qc_render_pending(FALSE)
    invisible(NULL)
  }

  .begin_qc_render_cycle <- function(text = "Preparing QC plots...") {
    qc_render_epoch(as.integer(isolate(qc_render_epoch())) + 1L)
    qc_render_status(stats::setNames(rep(FALSE, length(qc_render_targets)), qc_render_targets))
    qc_render_pending(TRUE)
    .show_qc_overlay(text)
    invisible(as.integer(isolate(qc_render_epoch())))
  }

  .mark_qc_output_ready <- function(output_id, epoch = NULL) {
    if (!isTRUE(qc_render_pending())) return(invisible(FALSE))
    output_id <- as.character(output_id %||% "")
    if (!nzchar(output_id)) return(invisible(FALSE))
    if (!output_id %in% qc_render_targets) return(invisible(FALSE))
    if (!is.null(epoch) && !identical(as.integer(epoch), as.integer(isolate(qc_render_epoch())))) {
      return(invisible(FALSE))
    }
    st <- isolate(qc_render_status())
    if (!is.logical(st) || is.null(names(st))) {
      st <- stats::setNames(rep(FALSE, length(qc_render_targets)), qc_render_targets)
    }
    st[setdiff(qc_render_targets, names(st))] <- FALSE
    st <- st[qc_render_targets]
    st[[output_id]] <- TRUE
    qc_render_status(st)
    if (all(isTRUE(st[[qc_render_targets[[1]]]]),
            isTRUE(st[[qc_render_targets[[2]]]]),
            isTRUE(st[[qc_render_targets[[3]]]]),
            isTRUE(st[[qc_render_targets[[4]]]]))) {
      .hide_qc_overlay()
      .reset_qc_render_cycle(invalidate = FALSE)
    }
    invisible(TRUE)
  }

  .ensure_qc_render_overlay <- function(text = "Preparing QC plots...") {
    if (!isTRUE(qc_render_pending())) {
      .begin_qc_render_cycle(text)
      return(invisible(NULL))
    }
    if (!isTRUE(qc_overlay_on())) .show_qc_overlay(text)
    invisible(NULL)
  }

  .thresholds_from_row <- function(row) {
    list(
      min_features = suppressWarnings(as.numeric(row$min_features)) %||% 200,
      max_features = suppressWarnings(as.numeric(row$max_features)) %||% 5000,
      min_umi      = suppressWarnings(as.numeric(row$min_umi_counts)) %||% 500,
      max_umi      = suppressWarnings(as.numeric(row$max_umi_counts)) %||% 50000,
      max_mt       = suppressWarnings(as.numeric(row$max_mt_percent)) %||% 20,
      coeff_a      = 0.5,
      a            = 1300,
      coeff_b      = 0.05,
      b            = 0
    )
  }

  .save_thresholds <- function(sample_name, th) {
    cache <- threshold_cache()
    cache[[sample_name]] <- th
    threshold_cache(cache)
    invisible(th)
  }

  .base_sample_name <- function(x) {
    x <- as.character(x %||% "")
    if (!nzchar(x)) return("")
    x <- sub("_rna_filtered(?:_[0-9]+)?$", "", x, ignore.case = TRUE)
    x <- sub("_filtered(?:_[0-9]+)?$", "", x, ignore.case = TRUE)
    x
  }
  .norm_key <- function(x) {
    tolower(trimws(as.character(x %||% "")))
  }

  .match_threshold_row <- function(df, key = "", active = "") {
    if (is.null(df) || !nrow(df)) return(NA_integer_)
    key_col <- if ("source_object" %in% colnames(df)) "source_object" else "name"
    src <- as.character(df[[key_col]] %||% rep("", nrow(df)))
    nmv <- as.character(df$name %||% rep("", nrow(df)))
    src_n <- .norm_key(src)
    nmv_n <- .norm_key(nmv)
    key <- as.character(key %||% "")
    active <- as.character(active %||% "")
    key_n <- .norm_key(key)
    active_n <- .norm_key(active)

    i <- if (nzchar(key_n)) match(key_n, src_n) else NA_integer_
    if (is.na(i) && nzchar(key_n)) i <- match(key_n, nmv_n)

    if (is.na(i) && nzchar(key_n)) {
      key_base <- .norm_key(.base_sample_name(key_n))
      if (nzchar(key_base)) {
        src_base <- .norm_key(vapply(src, .base_sample_name, character(1)))
        nm_base <- .norm_key(vapply(nmv, .base_sample_name, character(1)))
        i <- match(key_base, src_base)
        if (is.na(i)) i <- match(key_base, nm_base)
      }
    }

    if (is.na(i) && nzchar(active_n)) i <- match(active_n, nmv_n)
    if (is.na(i) && nzchar(active_n)) {
      active_base <- .norm_key(.base_sample_name(active_n))
      if (nzchar(active_base)) {
        nm_base <- .norm_key(vapply(nmv, .base_sample_name, character(1)))
        i <- match(active_base, nm_base)
      }
    }

    if (is.na(i) || !is.finite(i) || i < 1 || i > nrow(df)) return(NA_integer_)
    as.integer(i)
  }
  .row_is_excluded <- function(df, i) {
    if (is.null(df) || !nrow(df) || is.na(i) || !is.finite(i) || i < 1 || i > nrow(df)) return(FALSE)
    ex <- as.logical(df$excluded_from_final %||% FALSE)
    ex[is.na(ex)] <- FALSE
    isTRUE(ex[[i]])
  }
  .first_included_row <- function(df) {
    if (is.null(df) || !nrow(df)) return(NA_integer_)
    ex <- as.logical(df$excluded_from_final %||% FALSE)
    ex[is.na(ex)] <- FALSE
    keep <- which(!ex)
    if (!length(keep)) return(NA_integer_)
    as.integer(keep[[1]])
  }

  .get_thresholds <- function(sample_name) {
    df <- isolate(qc_table_data())
    cache <- isolate(threshold_cache())
    if (!is.null(cache[[sample_name]])) return(cache[[sample_name]])
    if (!is.null(df) && nrow(df) > 0) {
      i <- match(sample_name, df$name)
      if (!is.na(i)) return(.thresholds_from_row(df[i, , drop = FALSE]))
    }
    .thresholds_from_row(data.frame(min_features=200,max_features=5000,min_umi_counts=500,max_umi_counts=50000,max_mt_percent=20))
  }

  .sync_threshold_cache_with_sheet <- function(df) {
    cache <- isolate(threshold_cache())
    if (is.null(df) || !nrow(df)) { threshold_cache(list()); return(invisible(NULL)) }
    nm <- as.character(df$name)
    cache <- cache[nm]
    for (i in seq_len(nrow(df))) {
      sname <- nm[[i]]
      if (is.null(cache[[sname]])) cache[[sname]] <- .thresholds_from_row(df[i, , drop = FALSE])
    }
    threshold_cache(cache)
    invisible(NULL)
  }

  .qc_cache_get <- function(key) {
    cache <- isolate(qc_plot_cache())
    cache[[key]]
  }

  .qc_cache_set <- function(key, value) {
    cache <- isolate(qc_plot_cache())
    cache[[key]] <- value
    qc_plot_cache(cache)
    invisible(value)
  }

  .qc_cache_clear <- function() {
    qc_plot_cache(list())
    invisible(NULL)
  }

  .qc_error_plot <- function(msg, x_title = "", y_title = "") {
    # Use an explicit empty scatter trace to avoid plotly warnings about missing trace type.
    plotly::plot_ly(
      x = 0, y = 0, type = "scatter", mode = "markers",
      marker = list(size = 1, opacity = 0), hoverinfo = "skip", showlegend = FALSE
    ) |>
      plotly::layout(
        xaxis = list(title = x_title, visible = FALSE),
        yaxis = list(title = y_title, visible = FALSE),
        annotations = list(list(
          x = 0.5, y = 0.5, xref = "paper", yref = "paper",
          text = paste0("QC plot unavailable: ", msg),
          showarrow = FALSE,
          font = list(size = 14, color = "#6b7280")
        )),
        margin = list(l = 40, r = 40, t = 40, b = 40)
      ) |>
      plotly::config(displaylogo = FALSE)
  }

  .safe_assay_data <- function(sobj, assay, layer = "counts") {
    ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
    use_layer <- "layer" %in% ga_formals
    args <- list(object = sobj, assay = assay)
    if (use_layer) args$layer <- layer else args$slot <- layer
    m <- tryCatch({
      do.call(Seurat::GetAssayData, args)
    }, warning = function(w) NULL, error = function(e1) NULL)
    if (!is.null(m)) return(m)

    alt_args <- list(object = sobj, assay = assay)
    if (use_layer) alt_args$slot <- layer else alt_args$layer <- layer
    m <- tryCatch({
      do.call(Seurat::GetAssayData, alt_args)
    }, warning = function(w) NULL, error = function(e2) NULL)
    if (!is.null(m)) return(m)

    # SeuratObject LayerData fallback (handles assays with layer names like counts.1)
    assay_obj <- tryCatch(sobj[[assay]], error = function(e) NULL)
    layer_candidates <- layer
    layer_names <- tryCatch({
      if (!is.null(assay_obj) && exists("Layers", where = asNamespace("SeuratObject"), mode = "function")) {
        as.character(SeuratObject::Layers(assay_obj))
      } else character(0)
    }, error = function(e) character(0))
    if (length(layer_names)) {
      layer_candidates <- unique(c(
        layer,
        grep(paste0("^", layer), layer_names, value = TRUE),
        layer_names
      ))
    }
    for (ly in layer_candidates) {
      mm <- tryCatch({
        if (exists("LayerData", where = asNamespace("SeuratObject"), mode = "function")) {
          SeuratObject::LayerData(sobj, assay = assay, layer = ly)
        } else NULL
      }, error = function(e) NULL)
      if (!is.null(mm)) return(mm)
    }

    NULL
  }

  .ensure_qc_md <- function(sobj) {
    if (is.null(sobj)) return(NULL)

    # Support list-like payloads (e.g., multi-modal matrix lists) by synthesizing QC md.
    if (!inherits(sobj, "Seurat")) {
      if (is.list(sobj) && !is.null(sobj$obj)) return(.ensure_qc_md(sobj$obj))
      if (is.list(sobj)) {
        is_mat <- function(x) inherits(x, c("matrix", "dgCMatrix", "dgTMatrix"))
        mats <- Filter(is_mat, sobj)
        if (!length(mats)) return(NULL)
        nms <- names(mats) %||% rep("", length(mats))
        pref <- which(tolower(nms) %in% c("gene expression", "rna"))
        idx <- if (length(pref)) pref[[1]] else which.max(vapply(mats, nrow, numeric(1)))
        mat <- mats[[idx]]
        nc <- tryCatch(Matrix::colSums(mat), error = function(e) NULL)
        nf <- tryCatch(Matrix::colSums(mat > 0), error = function(e) NULL)
        if (is.null(nc) || is.null(nf)) return(NULL)
        ids <- colnames(mat) %||% names(nc) %||% as.character(seq_along(nc))
        ids <- as.character(ids)
        out <- data.frame(
          nCount_RNA = suppressWarnings(as.numeric(nc)),
          nFeature_RNA = suppressWarnings(as.numeric(nf)),
          percent.mt = rep(0, length(ids)),
          row.names = ids,
          stringsAsFactors = FALSE
        )
        return(out)
      }
      return(NULL)
    }

    md <- tryCatch(sobj@meta.data, error = function(e) NULL)
    if (is.null(md) || !is.data.frame(md)) {
      md <- tryCatch(as.data.frame(sobj[[]], stringsAsFactors = FALSE), error = function(e) NULL)
    }
    if (is.null(md) || !is.data.frame(md)) md <- data.frame(stringsAsFactors = FALSE)

    assay_names <- tryCatch(names(Seurat::Assays(sobj)), error = function(e) character(0))
    if (!length(assay_names)) {
      assay_names <- tryCatch(names(sobj@assays), error = function(e) character(0))
    }
    assay_names <- as.character(assay_names %||% character(0))

    target_assay <- NULL
    for (cand in c("RNA", "Gene Expression", "gene_expression", "SCT")) {
      if (cand %in% assay_names) {
        target_assay <- cand
        break
      }
    }
    if (is.null(target_assay) && length(assay_names)) target_assay <- assay_names[[1]]
    if (is.null(target_assay) || !nzchar(target_assay)) return(NULL)

    sobj_ids <- tryCatch(colnames(sobj), error = function(e) character(0))
    sobj_ids <- as.character(sobj_ids %||% character(0))
    cell_ids <- rownames(md)
    if (!length(cell_ids)) cell_ids <- sobj_ids
    if (!length(cell_ids)) return(NULL)
    cell_ids <- as.character(cell_ids)
    if (!nrow(md)) md <- data.frame(row.names = cell_ids, stringsAsFactors = FALSE)
    if (nrow(md) != length(cell_ids)) {
      # preserve existing metadata when possible, otherwise reset with valid row ids
      md <- md[seq_len(min(nrow(md), length(cell_ids))), , drop = FALSE]
      rownames(md) <- cell_ids[seq_len(nrow(md))]
      if (!nrow(md)) md <- data.frame(row.names = cell_ids, stringsAsFactors = FALSE)
    }

    .col_as_num <- function(col_name) {
      if (!col_name %in% colnames(md)) return(rep(NA_real_, nrow(md)))
      vv <- suppressWarnings(as.numeric(md[[col_name]]))
      if (length(vv) != nrow(md)) return(rep(NA_real_, nrow(md)))
      vv
    }

    .is_valid_percent_mt <- function(x, n_expected) {
      if (is.null(x)) return(FALSE)
      xx <- suppressWarnings(as.numeric(x))
      if (length(xx) != n_expected) return(FALSE)
      if (!any(is.finite(xx))) return(FALSE)
      if (all(xx == 0, na.rm = TRUE)) return(FALSE)
      if (any(xx < 0, na.rm = TRUE)) return(FALSE)
      if (any(xx > 100, na.rm = TRUE)) return(FALSE)
      TRUE
    }

    .recompute_percent_mt <- function(obj) {
      if (is.null(obj) || !inherits(obj, "Seurat")) return(rep(NA_real_, 0))
      if (!("RNA" %in% names(obj@assays))) return(rep(NA_real_, ncol(obj)))
      counts <- tryCatch(.safe_assay_data(obj, assay = "RNA", layer = "counts"), error = function(e) NULL)
      if (is.null(counts)) return(rep(NA_real_, ncol(obj)))

      feat_names <- rownames(obj)
      mt_rows <- if (length(feat_names)) grepl("^(MT-|mt-)", feat_names) else rep(FALSE, nrow(counts))
      feat_md <- tryCatch(obj[["RNA"]]@meta.features, error = function(e) NULL)
      if (is.data.frame(feat_md) && nrow(feat_md) == length(mt_rows) && ncol(feat_md)) {
        for (cc in colnames(feat_md)) {
          vv <- feat_md[[cc]]
          if (!(is.character(vv) || is.factor(vv))) next
          vv <- as.character(vv)
          if (length(vv) != length(mt_rows)) next
          mt_rows <- mt_rows | grepl("^(MT-|mt-)", vv)
        }
      }

      if (!any(mt_rows)) return(rep(NA_real_, ncol(obj)))
      mt_counts <- Matrix::colSums(counts[mt_rows, , drop = FALSE])
      total_counts <- Matrix::colSums(counts)
      as.numeric(ifelse(total_counts > 0, (mt_counts / total_counts) * 100, 0))
    }

    # Strict source contract: no fallback/heuristics.
    # 1) canonical RNA pair if present
    # 2) exact assay pair nCount_<assay> + nFeature_<assay>
    aligned_nc <- .col_as_num("nCount_RNA")
    aligned_nf <- .col_as_num("nFeature_RNA")
    has_pair <- any(is.finite(aligned_nc)) && any(is.finite(aligned_nf))
    if (!has_pair) {
      assay_count_col <- paste0("nCount_", target_assay)
      assay_feat_col <- paste0("nFeature_", target_assay)
      aligned_nc <- .col_as_num(assay_count_col)
      aligned_nf <- .col_as_num(assay_feat_col)
      has_pair <- any(is.finite(aligned_nc)) && any(is.finite(aligned_nf))
    }
    if (!has_pair) return(NULL)

    # Hard integrity check: if selected pair is inconsistent, fail instead of fallback.
    ok_pair <- is.finite(aligned_nc) & is.finite(aligned_nf) & (aligned_nc >= 0) & (aligned_nf >= 0)
    if (sum(ok_pair) < 50) return(NULL)
    bad_rate <- mean(aligned_nf[ok_pair] > aligned_nc[ok_pair])
    if (is.finite(bad_rate) && bad_rate > 0.01) return(NULL)

    md$nCount_RNA <- aligned_nc
    md$nFeature_RNA <- aligned_nf

    pm <- if ("percent.mt" %in% colnames(md)) suppressWarnings(as.numeric(md$percent.mt)) else rep(NA_real_, nrow(md))
    if (!.is_valid_percent_mt(pm, nrow(md))) {
      pm_new <- .recompute_percent_mt(sobj)
      if (length(pm_new) == nrow(md) && any(is.finite(pm_new))) {
        pm <- pm_new
      }
      .qc_log(
        "[QC-DIAG] percent.mt status for object '",
        as.character(tryCatch(sobj@project.name, error = function(e) "")),
        "': prior_valid=", .is_valid_percent_mt(if ("percent.mt" %in% colnames(md)) md$percent.mt else NULL, nrow(md)),
        ", recomputed_finite=", any(is.finite(pm)),
        ", recomputed_nonzero=", any(pm > 0, na.rm = TRUE)
      )
    }
    if (length(pm) != nrow(md)) pm <- rep(NA_real_, nrow(md))
    md$percent.mt <- pm

    if (!any(is.finite(md$nCount_RNA)) || !any(is.finite(md$nFeature_RNA))) return(NULL)
    md
  }
  # Object creation responsibility is owned by right-sidebar / workspace import flows.
  # QC consumes shared_data$all_seurat_objects and must not auto-create objects from sheet rows.

  .append_sidebar_objects_to_qc <- function(selected_items, show_notice = TRUE, switch_focus = TRUE) {
    if (is.null(selected_items) || !is.data.frame(selected_items) || !nrow(selected_items)) return(invisible(FALSE))
    if (!("name" %in% colnames(selected_items)) || !("kind" %in% colnames(selected_items))) return(invisible(FALSE))

    pick <- selected_items[grepl("^Seurat object", as.character(selected_items$kind %||% "")), , drop = FALSE]
    if (!nrow(pick)) return(invisible(FALSE))

    reg <- isolate(shared_data$all_seurat_objects %||% list())
    if (!length(reg)) return(invisible(FALSE))

    df <- .ensure_qc_table_cols(isolate(qc_table_data()))
    if (is.null(df) || !nrow(df)) {
      base_df <- isolate(shared_data$full_sample_sheet)
      df <- .ensure_qc_table_cols(base_df)
    }
    if (is.null(df)) df <- .ensure_qc_table_cols(data.frame(stringsAsFactors = FALSE))

    sheet <- isolate(shared_data$full_sample_sheet)
    if (!is.data.frame(sheet)) sheet <- data.frame(stringsAsFactors = FALSE)

    added <- character(0)
    for (nm in unique(as.character(pick$name))) {
      if (!nzchar(nm) || is.null(reg[[nm]])) next
      if (any(as.character(df$source_object) == nm) || any(as.character(df$name) == nm)) next

      parent_nm <- if (grepl("_rna_filtered(?:_[0-9]+)?$", nm, ignore.case = TRUE)) {
        sub("_rna_filtered(?:_[0-9]+)?$", "", nm, ignore.case = TRUE)
      } else {
        sub("_filtered(?:_[0-9]+)?$", "", nm, ignore.case = TRUE)
      }
      parent_i <- match(parent_nm, as.character(df$name))
      if (is.na(parent_i)) parent_i <- match(parent_nm, as.character(df$source_object))

      sheet_i <- match(nm, as.character(sheet$name %||% character()))
      if (is.na(sheet_i)) sheet_i <- match(parent_nm, as.character(sheet$name %||% character()))

      if (!is.na(parent_i)) {
        row <- df[parent_i, , drop = FALSE]
        row$name <- nm
        row$source_object <- nm
        row$qc_status <- if (grepl("_filtered$", nm, ignore.case = TRUE)) "Filtered" else "Pending"
        row$path <- row$path %||% ""
      } else {
        row <- data.frame(
          name = nm,
          condition = if (!is.na(sheet_i) && ("condition" %in% colnames(sheet))) as.character(sheet$condition[[sheet_i]] %||% "Unknown") else "Unknown",
          batch = if (!is.na(sheet_i) && ("batch" %in% colnames(sheet))) as.character(sheet$batch[[sheet_i]] %||% "Batch1") else "Batch1",
          min_features = 200,
          max_features = 5000,
          min_umi_counts = 500,
          max_umi_counts = 50000,
          max_mt_percent = 20,
          use_in_analysis = TRUE,
          qc_status = if (grepl("_filtered$", nm, ignore.case = TRUE)) "Filtered" else "Pending",
          source_object = nm,
          path = if (!is.na(sheet_i) && ("path" %in% colnames(sheet))) as.character(sheet$path[[sheet_i]] %||% "") else "",
          stringsAsFactors = FALSE
        )
      }

      df <- .ensure_qc_table_cols(.rbind_align(df, row))
      if (!is.na(parent_i)) {
        th <- .get_thresholds(parent_nm)
        .save_thresholds(nm, th)
      } else {
        .save_thresholds(nm, .thresholds_from_row(row))
      }
      added <- c(added, nm)
    }

    if (!length(added)) return(invisible(FALSE))
    qc_table_data(.ensure_qc_table_cols(df))
    if (is.null(active_name()) || !nzchar(active_name() %||% "")) active_name(added[[1]])
    if (isTRUE(switch_focus) || is.null(viewer_object_name()) || !nzchar(viewer_object_name() %||% "")) {
      viewer_object_name(added[[1]])
    }
    if (isTRUE(show_notice)) {
      showNotification(sprintf("Added %d Seurat object(s) to QC table.", length(added)), type = "message")
    }
    invisible(TRUE)
  }

  observeEvent(shared_data$selected_sidebar_items, {
    # Do not auto-switch current QC view when new objects are added from sidebar.
    # This avoids surprising jumps to unrelated small/subset objects.
    .append_sidebar_objects_to_qc(shared_data$selected_sidebar_items, show_notice = TRUE, switch_focus = FALSE)
  }, ignoreInit = TRUE)

  observeEvent(shared_data$all_seurat_objects, {
    reg <- shared_data$all_seurat_objects %||% list()
    if (!length(reg)) return(invisible(NULL))
    filtered_nms <- names(reg)[grepl("(_rna_filtered|_filtered)(?:_[0-9]+)?$", names(reg), ignore.case = TRUE)]
    if (!length(filtered_nms)) return(invisible(NULL))
    auto_items <- data.frame(
      name = filtered_nms,
      kind = rep("Seurat object", length(filtered_nms)),
      stringsAsFactors = FALSE
    )
    .append_sidebar_objects_to_qc(auto_items, show_notice = FALSE, switch_focus = FALSE)
    invisible(NULL)
  }, ignoreInit = FALSE)

  .compute_qc_view_choices <- function(df, reg = NULL) {
    df <- .ensure_qc_table_cols(df)
    if (is.null(df) || !nrow(df)) return(setNames(character(0), character(0)))
    keep <- !as.logical(df$excluded_from_final %||% FALSE)
    keep[is.na(keep)] <- TRUE
    df <- df[keep, , drop = FALSE]
    if (!nrow(df)) return(setNames(character(0), character(0)))
    vals <- as.character(df$name)
    names(vals) <- vals
    vals
  }
  .resolve_object_key_for_sample <- function(sample_name, df = NULL, reg = NULL) {
    sample_name <- as.character(sample_name %||% "")
    if (!nzchar(sample_name)) return("")
    if (is.null(df)) df <- isolate(.ensure_qc_table_cols(qc_table_data()))
    if (is.null(reg)) reg <- isolate(shared_data$all_seurat_objects %||% list())
    if (is.null(df) || !nrow(df)) return("")
    i <- match(sample_name, as.character(df$name))
    if (!is.na(i) && i >= 1 && i <= nrow(df)) {
      src <- as.character(df$source_object[[i]] %||% "")
      if (nzchar(src) && !is.null(reg[[src]])) return(src)
    }
    if (!is.null(reg[[sample_name]])) return(sample_name)
    ""
  }

  .qc_view_choices <- reactive({
    df <- .ensure_qc_table_cols(qc_table_data()); req(df, nrow(df) > 0)
    .compute_qc_view_choices(df, reg = isolate(shared_data$all_seurat_objects %||% list()))
  })

  output$qc_view_object_ui <- renderUI({
    ch <- .qc_view_choices()
    if (!length(ch)) return(helpText(UI_TEXT$t_text_viewing_object_not_available_yet))
    sel <- isolate(input$qc_view_object_name) %||% active_name()
    vals <- unname(ch)
    if (is.null(sel) || !nzchar(sel) || !(sel %in% vals)) sel <- character(0)
    selectInput("qc_view_object_name", UI_TEXT$t_label_viewing_object, choices = ch, selected = sel)
  })

  observeEvent(input$qc_view_object_name, {
    sel_sample <- as.character(input$qc_view_object_name %||% "")
    if (!nzchar(sel_sample)) return(invisible(NULL))
    df <- isolate(qc_table_data())
    if (!is.null(df) && nrow(df)) {
      reg <- isolate(shared_data$all_seurat_objects %||% list())
      i <- match(sel_sample, as.character(df$name))
      if (is.na(i)) i <- .match_threshold_row(df, key = sel_sample, active = sel_sample)
      if (!is.na(i)) {
        nm <- as.character(df$name[[i]])
        obj_key <- .resolve_object_key_for_sample(nm, df = df, reg = reg)
        viewer_old <- isolate(viewer_object_name()) %||% ""
        active_old <- isolate(active_name()) %||% ""
        thresh_old <- isolate(qc_current_threshold_sample()) %||% ""
        if (!identical(isolate(viewer_object_name()) %||% "", obj_key %||% "")) {
          viewer_object_name(obj_key)
        }
        if (!identical(isolate(active_name()) %||% "", nm %||% "")) {
          active_name(nm)
        }
        qc_current_threshold_sample(nm)
        .update_sidebar_sliders(nm)
        changed <- !identical(viewer_old, obj_key %||% "") ||
          !identical(active_old, nm %||% "") ||
          !identical(thresh_old, nm %||% "")
        if (isTRUE(changed)) {
          session$onFlushed(function() {
            .queue_qc_recalc(force = FALSE)
          }, once = TRUE)
        }
      }
    }
  }, ignoreInit = TRUE)

  observeEvent(input$qc_parameter_table_rows_selected, {
    # Row selection is for table operations only (batch include/exclude).
    # Do not switch active/view object here, to avoid unintended plot recompute.
    invisible(NULL)
  }, ignoreInit = TRUE)
  
  get_active_obj <- reactive({
    df <- qc_table_data(); req(df)
    target <- as.character(viewer_object_name() %||% "")
    validate(need(nzchar(target), "No QC object is selected."))
    e <- shared_data$all_seurat_objects[[target]]
    validate(need(!is.null(e), sprintf("Object entry missing for '%s'.", target)))
    if (is.list(e) && !is.null(e$obj)) e$obj else e
  })

  .get_raw_md_for_sample <- function(sample_name) {
    entry <- shared_data$all_seurat_objects[[sample_name]]
    if (is.null(entry)) return(NULL)
    sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (is.null(sobj)) return(NULL)
    sobj@meta.data
  }

  observe({
    req(shared_data$full_sample_sheet)
    incoming <- .ensure_qc_table_cols(shared_data$full_sample_sheet)

    current <- .ensure_qc_table_cols(isolate(qc_table_data()))
    if (is.null(current) || !nrow(current)) {
      qc_table_data(incoming)
      .sync_threshold_cache_with_sheet(incoming)
      return(invisible(NULL))
    }

    new_keys <- setdiff(as.character(incoming$source_object), as.character(current$source_object))
    if (length(new_keys)) {
      add_df <- incoming[incoming$source_object %in% new_keys, , drop = FALSE]
      merged <- .ensure_qc_table_cols(.rbind_align(current, add_df))
      qc_table_data(merged)
      .sync_threshold_cache_with_sheet(merged)
    }
  })

  output$qc_parameter_table_box <- renderUI({
    df <- qc_table_data()
    if (is.null(df) || !nrow(df)) {
      return(div(
        class = "alert alert-info",
        UI_TEXT$t_text_no_samples_loaded_yet_please_add
      ))
    }
    tagList(
      DTOutput("qc_parameter_table"),
      div(
        style = "display:flex; gap:8px; justify-content:flex-end; margin-top:10px;",
        actionButton(
          "qc_exclude_selected_btn",
          UI_TEXT$t_btn_exclude_selected %||% "Exclude selected",
          class = "btn btn-xs btn-outline-danger",
          icon = icon("ban")
        ),
        actionButton(
          "qc_include_selected_btn",
          UI_TEXT$t_btn_include_selected %||% "Include selected",
          class = "btn btn-xs btn-outline-success",
          icon = icon("plus")
        )
      )
    )
  })

  output$qc_plot_area_ui <- renderUI({
    df <- qc_table_data()
    if (is.null(df) || !nrow(df)) {
      return(div(
        class = "alert alert-info",
        style = "margin-top: 8px;",
        "No samples available for QC plots → Add files from the right sidebar first."
      ))
    }

    tagList(
      div(
        class = "wl-side",
        uiOutput("qc_diag_ui"),
        fluidRow(
          column(
            12,
            div(class = "qc-violins",
                div(class = "qc-vln", plotlyOutput("qc_vln_plot_nfeature", height = "320px")),
                div(class = "qc-vln", plotlyOutput("qc_vln_plot_ncount", height = "320px")),
                div(class = "qc-vln", plotlyOutput("qc_vln_plot_mt", height = "320px"))
            )
          )
        )
      ),
      div(
        class = "wl-side qc-scatter-card",
        fluidRow(
          column(
            12,
            div(class = "qc-scatters",
                div(
                  class = "qc-square",
                  plotlyOutput("qc_scatter_main", height = "100%", width = "100%")
                )
            )
          )
        )
      )
    )
  })

  output$qc_diag_ui <- renderUI({
    txt <- qc_diag_text() %||% ""
    if (!nzchar(txt)) return(NULL)
    div(
      class = "alert alert-warning",
      style = "margin-top:8px; margin-bottom:10px; white-space:pre-wrap;",
      tags$b("QC diagnostics: "),
      txt
    )
  })
  output$qc_parameter_table <- renderDT({
    df <- .ensure_qc_table_cols(qc_table_data()); req(df)
    display_df <- .safe_select_cols(df, c("name","condition","batch",
                                          "min_features","max_features",
                                          "min_umi_counts","max_umi_counts",
                                          "max_mt_percent","use_in_analysis","qc_status"))
    excluded <- as.logical(df$excluded_from_final %||% FALSE)
    display_df$remove <- vapply(
      seq_len(nrow(display_df)),
      function(i) {
        if (isTRUE(excluded[[i]])) {
          sprintf(
            '<button type="button" class="btn btn-xs btn-outline-success qc-toggle-row"><i class="fa fa-plus" style="margin-right:4px;"></i>%s</button>',
            UI_TEXT$t_btn_include %||% "Include"
          )
        } else {
          sprintf(
            '<button type="button" class="btn btn-xs btn-outline-danger qc-toggle-row"><i class="fa fa-ban" style="margin-right:4px;"></i>%s</button>',
            UI_TEXT$t_btn_exclude %||% "Exclude"
          )
        }
      },
      character(1)
    )
    display_df$excluded_from_final <- excluded
    datatable(
      display_df,
      editable = list(target="cell", disable=list(columns=c(0,1,2,10,11))),
      selection = "multiple",
      class = "compact stripe hover",
      escape = FALSE,
      callback = DT::JS(
        "table.on('click', 'button.qc-toggle-row', function(){",
        "  var idx = table.row($(this).closest('tr')).index();",
        "  if (idx !== undefined && idx !== null) {",
        "    Shiny.setInputValue('qc_toggle_row', idx + 1, {priority: 'event'});",
        "  }",
        "});"
      ),
      options = list(dom = 't', pageLength = nrow(display_df), scrollX = TRUE, autoWidth = FALSE,
                     columnDefs = list(
                       list(width = '230px', targets = 0, className = "qc-col-name"),
                       list(width = '80px', targets = c(1,2,8,9), className = "dt-center"),
                       list(width = '90px', targets = c(3,4,5,6,7), className = "dt-center"),
                       list(width = '82px', targets = 10, className = "dt-center"),
                       list(visible = FALSE, searchable = FALSE, targets = 11)
                     ),
                     rowCallback = DT::JS(
                       "function(row, data){",
                       "  var ex = String(data[11]).toLowerCase() === 'true';",
                       "  if (ex) $(row).addClass('qc-row-excluded'); else $(row).removeClass('qc-row-excluded');",
                       "}"
                     )),
      colnames = c(
        "Name", "Condition", "Batch",
        "Min Features", "Max Features",
        "Min UMI", "Max UMI",
        "Max MT%", "Use", "Status", "", "excluded_from_final"
      ),
      rownames  = FALSE
    )
  }, server = FALSE)

  .toggle_sample_row <- function(sel) {
    df <- qc_table_data(); req(df, nrow(df) > 0)
    sel <- unique(as.integer(sel))
    sel <- sel[is.finite(sel) & sel >= 1 & sel <= nrow(df)]
    if (!length(sel)) return(invisible(FALSE))
    df <- .ensure_qc_table_cols(df)
    idx <- sel[[1]]
    is_excluded <- isTRUE(as.logical(df$excluded_from_final[[idx]] %||% FALSE))
    if (is_excluded) {
      df$excluded_from_final[[idx]] <- FALSE
      df$use_in_analysis[[idx]] <- TRUE
      if ("qc_status" %in% colnames(df)) {
        nm <- as.character(df$name[[idx]])
        is_filtered <- grepl("(_rna_filtered|_filtered)(?:_[0-9]+)?$", nm, ignore.case = TRUE)
        df$qc_status[[idx]] <- ifelse(is_filtered, "Filtered", "Pending")
      }
      qc_table_data(df)
      showNotification(sprintf("Included '%s' back into final filtering list.", as.character(df$name[[idx]])), type = "message")
      return(invisible(TRUE))
    }
    df$excluded_from_final[[idx]] <- TRUE
    df$use_in_analysis[[idx]] <- FALSE
    if ("qc_status" %in% colnames(df)) {
      df$qc_status[[idx]] <- UI_TEXT$t_text_excluded_from_final_filtering %||% "Excluded from final filtering list."
    }
    qc_table_data(df)
    showNotification(sprintf("Excluded '%s' from final filtering list.", as.character(df$name[[idx]])), type = "message")
    invisible(TRUE)
  }

  .set_selected_rows_excluded <- function(sel, excluded_flag = TRUE) {
    df <- qc_table_data(); req(df, nrow(df) > 0)
    df <- .ensure_qc_table_cols(df)
    sel <- unique(as.integer(sel))
    sel <- sel[is.finite(sel) & sel >= 1 & sel <= nrow(df)]
    if (!length(sel)) {
      showNotification("No rows selected.", type = "warning", duration = 3)
      return(invisible(FALSE))
    }
    excluded_now <- as.logical(df$excluded_from_final[sel])
    excluded_now[is.na(excluded_now)] <- FALSE
    if (isTRUE(excluded_flag)) {
      target <- sel[!excluded_now]
      if (!length(target)) return(invisible(FALSE))
      df$excluded_from_final[target] <- TRUE
      df$use_in_analysis[target] <- FALSE
      if ("qc_status" %in% colnames(df)) {
        df$qc_status[target] <- UI_TEXT$t_text_excluded_from_final_filtering %||% "Excluded from final filtering list."
      }
      qc_table_data(df)
      showNotification(sprintf("Excluded %d selected sample(s).", length(target)), type = "message")
      return(invisible(TRUE))
    }
    target <- sel[excluded_now]
    if (!length(target)) return(invisible(FALSE))
    df$excluded_from_final[target] <- FALSE
    df$use_in_analysis[target] <- TRUE
    if ("qc_status" %in% colnames(df)) {
      nm <- as.character(df$name[target])
      is_filtered <- grepl("(_rna_filtered|_filtered)(?:_[0-9]+)?$", nm, ignore.case = TRUE)
      df$qc_status[target] <- ifelse(is_filtered, "Filtered", "Pending")
    }
    qc_table_data(df)
    showNotification(sprintf("Included %d selected sample(s).", length(target)), type = "message")
    invisible(TRUE)
  }

  .reconcile_view_after_table_change <- function() {
    df <- isolate(.ensure_qc_table_cols(qc_table_data()))
    if (is.null(df) || !nrow(df)) return(invisible(NULL))
    reg <- isolate(shared_data$all_seurat_objects %||% list())
    ch <- .compute_qc_view_choices(df, reg = reg)
    vals <- unname(ch)
    if (!length(vals)) return(invisible(NULL))

    current_view <- isolate(input$qc_view_object_name) %||% isolate(active_name()) %||% ""
    next_view <- if (nzchar(current_view) && (current_view %in% vals)) current_view else as.character(vals[[1]])
    updateSelectInput(session, "qc_view_object_name", choices = ch, selected = next_view)

    i <- match(next_view, as.character(df$name))
    if (is.na(i)) i <- .match_threshold_row(df, key = next_view, active = isolate(active_name()) %||% "")
    if (.row_is_excluded(df, i)) i <- NA_integer_
    if (is.na(i)) i <- .first_included_row(df)
    if (is.na(i)) i <- 1L
    nm <- as.character(df$name[[i]])
    obj_key <- .resolve_object_key_for_sample(nm, df = df, reg = reg)
    viewer_old <- isolate(viewer_object_name()) %||% ""
    active_old <- isolate(active_name()) %||% ""
    if (!identical(isolate(viewer_object_name()) %||% "", obj_key %||% "")) viewer_object_name(obj_key)
    if (!identical(isolate(active_name()) %||% "", nm %||% "")) active_name(nm)
    viewer_new <- isolate(viewer_object_name()) %||% ""
    active_new <- isolate(active_name()) %||% ""
    thresh_old <- isolate(qc_current_threshold_sample()) %||% ""
    qc_current_threshold_sample(nm)
    .update_sidebar_sliders(nm)
    changed <- !identical(viewer_old, viewer_new) ||
      !identical(active_old, active_new) ||
      !identical(thresh_old, nm %||% "")
    if (isTRUE(changed)) {
      session$onFlushed(function() {
        .queue_qc_recalc(force = FALSE)
      }, once = TRUE)
    }
    invisible(NULL)
  }

  .bootstrap_qc_state <- function() {
    df <- isolate(.ensure_qc_table_cols(qc_table_data()))
    if (is.null(df) || !nrow(df)) {
      incoming <- isolate(.ensure_qc_table_cols(shared_data$full_sample_sheet))
      if (!is.null(incoming) && nrow(incoming)) {
        qc_table_data(incoming)
        .sync_threshold_cache_with_sheet(incoming)
        df <- incoming
      }
    }
    if (is.null(df) || !nrow(df)) return(invisible(FALSE))
    reg <- isolate(shared_data$all_seurat_objects %||% list())
    ch <- .compute_qc_view_choices(df, reg = reg)
    vals <- unname(ch)
    if (!length(vals)) return(invisible(FALSE))
    current <- as.character(isolate(input$qc_view_object_name) %||% isolate(active_name()) %||% "")
    next_view <- if (nzchar(current) && current %in% vals) current else as.character(vals[[1]])
    updateSelectInput(session, "qc_view_object_name", choices = ch, selected = next_view)
    i <- match(next_view, as.character(df$name))
    if (is.na(i)) i <- .match_threshold_row(df, key = next_view, active = isolate(active_name()) %||% "")
    if (.row_is_excluded(df, i)) i <- .first_included_row(df)
    if (is.na(i) || !is.finite(i) || i < 1 || i > nrow(df)) return(invisible(FALSE))
    nm <- as.character(df$name[[i]])
    obj_key <- .resolve_object_key_for_sample(nm, df = df, reg = reg)
    if (!nzchar(obj_key) || is.null(reg[[obj_key]])) return(invisible(FALSE))
    if (!identical(isolate(viewer_object_name()) %||% "", obj_key %||% "")) viewer_object_name(obj_key)
    if (!identical(isolate(active_name()) %||% "", nm %||% "")) active_name(nm)
    if (!identical(isolate(qc_current_threshold_sample()) %||% "", nm %||% "")) qc_current_threshold_sample(nm)
    .update_sidebar_sliders(nm)
    invisible(TRUE)
  }

  observeEvent(input$qc_toggle_row, {
    .toggle_sample_row(input$qc_toggle_row)
    .reconcile_view_after_table_change()
  }, ignoreInit = TRUE)

  observeEvent(input$qc_exclude_selected_btn, {
    .set_selected_rows_excluded(input$qc_parameter_table_rows_selected, excluded_flag = TRUE)
    .reconcile_view_after_table_change()
  }, ignoreInit = TRUE)

  observeEvent(input$qc_include_selected_btn, {
    .set_selected_rows_excluded(input$qc_parameter_table_rows_selected, excluded_flag = FALSE)
    .reconcile_view_after_table_change()
  }, ignoreInit = TRUE)

  observeEvent(input$apply_current_sample_btn, {
    df <- qc_table_data(); req(df, nrow(df) > 0)
    nm <- .current_threshold_sample_name()
    if (is.null(nm) || !nzchar(nm)) {
      showNotification("No current sample selected.", type = "warning")
      return(invisible(NULL))
    }
    i <- match(nm, as.character(df$name))
    if (is.na(i) || .row_is_excluded(df, i)) {
      showNotification("Current sample is excluded or unavailable.", type = "warning")
      return(invisible(NULL))
    }
    th <- read_thresholds(nm)
    cache <- threshold_cache()
    df$min_features[i]   <- th$min_features
    df$max_features[i]   <- th$max_features
    df$min_umi_counts[i] <- th$min_umi
    df$max_umi_counts[i] <- th$max_umi
    df$max_mt_percent[i] <- th$max_mt
    cache[[as.character(df$name[i])]] <- th
    threshold_cache(cache)
    qc_table_data(df)
    showNotification(sprintf("Thresholds applied to current sample: %s", as.character(df$name[i])), type = "message")
    session$onFlushed(function() {
      .queue_qc_recalc(force = TRUE)
    }, once = TRUE)
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$apply_all_samples_btn, {
    df <- qc_table_data(); req(df, nrow(df) > 0)
    nm <- active_name() %||% df$name[[1]]
    th <- read_thresholds(nm)

    cache <- threshold_cache()
    included <- which(!as.logical(df$excluded_from_final %||% FALSE))
    included <- included[is.finite(included) & included >= 1 & included <= nrow(df)]
    if (!length(included)) {
      showNotification("No included samples available.", type = "warning")
      return(invisible(NULL))
    }
    for (i in included) {
      df$min_features[i]   <- th$min_features
      df$max_features[i]   <- th$max_features
      df$min_umi_counts[i] <- th$min_umi
      df$max_umi_counts[i] <- th$max_umi
      df$max_mt_percent[i] <- th$max_mt
      cache[[as.character(df$name[i])]] <- th
    }
    threshold_cache(cache)

    qc_table_data(df)
    showNotification(sprintf("Current sample thresholds applied to all included samples (%d).", length(included)), type = "message")
    session$onFlushed(function() {
      .queue_qc_recalc(force = TRUE)
    }, once = TRUE)
    invisible(NULL)
  }, ignoreInit = TRUE)
  
  observe({
    df <- qc_table_data(); req(df, nrow(df) > 0)
    prev_active <- isolate(active_name())
    prev_viewer <- isolate(viewer_object_name())

    if (is.null(active_name()) || !(active_name() %in% as.character(df$name))) {
      active_name(as.character(df$name[[1]]))
    }
    ch <- .qc_view_choices()
    vals <- unname(ch)
    if (length(vals)) {
      selected_sample <- as.character(isolate(input$qc_view_object_name) %||% "")
      sample_for_view <- if (nzchar(selected_sample) && (selected_sample %in% vals)) {
        selected_sample
      } else {
        as.character(vals[[1]])
      }
      reg <- isolate(shared_data$all_seurat_objects %||% list())
      obj_key <- .resolve_object_key_for_sample(sample_for_view, df = df, reg = reg)
      if (!identical(isolate(viewer_object_name()) %||% "", obj_key %||% "")) {
        viewer_object_name(obj_key)
      }
      if (!identical(isolate(active_name()) %||% "", sample_for_view %||% "")) {
        active_name(sample_for_view)
      }
      if (!identical(isolate(qc_current_threshold_sample()) %||% "", sample_for_view %||% "")) {
        qc_current_threshold_sample(sample_for_view)
      }
    }

    # Performance: avoid re-pushing all slider inputs on every table mutation
    # (e.g. single-row remove), because that fans out into expensive plot re-renders.
    active_now <- isolate(active_name())
    viewer_now <- isolate(viewer_object_name())
    first_init <- is.null(input$qc_min_features)
    active_changed <- !identical(prev_active %||% "", active_now %||% "")
    viewer_changed <- !identical(prev_viewer %||% "", viewer_now %||% "")
    if (isTRUE(first_init) || isTRUE(active_changed) || isTRUE(viewer_changed)) {
      .update_sidebar_sliders(active_now)
    }
  })
  
  get_active_md <- reactive({
    sobj <- get_active_obj()
    validate(need(!is.null(sobj), "Seurat objects are still loading…"))
    sobj@meta.data
  })
  
  read_thresholds <- function(sample_name){
    old <- .get_thresholds(sample_name)
    .pick_num <- function(input_val, old_val) {
      v_in <- suppressWarnings(as.numeric(input_val))
      if (length(v_in) == 1 && is.finite(v_in)) return(v_in)
      old_val
    }
    # Important: isolate slider reads so plot rendering does not subscribe
    # directly to live drag events. Recalc is release-gated elsewhere.
    th <- list(
      min_features = .pick_num(isolate(input$qc_min_features), old$min_features),
      max_features = .pick_num(isolate(input$qc_max_features), old$max_features),
      min_umi      = .pick_num(isolate(input$qc_min_umi), old$min_umi),
      max_umi      = .pick_num(isolate(input$qc_max_umi), old$max_umi),
      max_mt       = .pick_num(isolate(input$qc_max_mt), old$max_mt),
      coeff_a      = .pick_num(isolate(input$qc_coeff_a), old$coeff_a),
      a            = .pick_num(isolate(input$qc_upper_a), old$a),
      coeff_b      = .pick_num(isolate(input$qc_coeff_b), old$coeff_b),
      b            = .pick_num(isolate(input$qc_lower_b), old$b)
    )
    .save_thresholds(sample_name, th)
    th
  }

  .qc_live_slider_state <- reactive({
    list(
      min_features = input$qc_min_features,
      max_features = input$qc_max_features,
      min_umi = input$qc_min_umi,
      max_umi = input$qc_max_umi,
      max_mt = input$qc_max_mt,
      coeff_a = input$qc_coeff_a,
      a = input$qc_upper_a,
      coeff_b = input$qc_coeff_b,
      b = input$qc_lower_b
    )
  })

  qc_slider_dirty <- reactiveVal(FALSE)
  qc_programmatic_slider_update <- reactiveVal(FALSE)
  qc_slider_last_change_ms <- reactiveVal(0)
  qc_slider_commit_suppress_until_ms <- reactiveVal(0)
  qc_last_recalc_signature <- reactiveVal("")
  .current_threshold_sample_name <- function() {
    df <- isolate(.ensure_qc_table_cols(qc_table_data()))
    if (is.null(df) || !nrow(df)) return(NULL)
    pinned <- as.character(isolate(qc_current_threshold_sample()) %||% "")
    if (nzchar(pinned)) {
      j <- match(pinned, as.character(df$name))
      if (!is.na(j) && !.row_is_excluded(df, j)) return(as.character(df$name[[j]]))
    }
    vkey <- isolate(input$qc_view_object_name) %||% isolate(viewer_object_name()) %||% ""
    an <- isolate(active_name()) %||% ""
    i <- .match_threshold_row(df, key = vkey, active = an)
    if (.row_is_excluded(df, i)) i <- NA_integer_
    if (is.na(i) && nzchar(an)) {
      i <- match(an, as.character(df$name))
      if (.row_is_excluded(df, i)) i <- NA_integer_
    }
    if (is.na(i) || !is.finite(i) || i < 1 || i > nrow(df)) i <- .first_included_row(df)
    if (is.na(i) || !is.finite(i) || i < 1 || i > nrow(df)) i <- 1L
    as.character(df$name[[i]])
  }
  .persist_thresholds_to_table <- function(sample_name, th, object_key = NULL) {
    df <- isolate(.ensure_qc_table_cols(qc_table_data()))
    if (is.null(df) || !nrow(df)) return(invisible(NULL))
    key_col <- if ("source_object" %in% colnames(df)) "source_object" else "name"
    idx <- match(as.character(sample_name %||% ""), as.character(df$name))
    if (is.na(idx) && nzchar(as.character(object_key %||% ""))) {
      idx <- match(as.character(object_key), as.character(df[[key_col]]))
    }
    if (is.na(idx)) {
      idx <- .match_threshold_row(
        df,
        key = as.character(object_key %||% isolate(input$qc_view_object_name) %||% isolate(viewer_object_name()) %||% ""),
        active = as.character(sample_name %||% isolate(active_name()) %||% "")
      )
    }
    if (.row_is_excluded(df, idx)) idx <- .first_included_row(df)
    if (is.na(idx) || !is.finite(idx) || idx < 1 || idx > nrow(df)) return(invisible(NULL))
    df$min_features[[idx]] <- suppressWarnings(as.numeric(th$min_features %||% df$min_features[[idx]]))
    df$max_features[[idx]] <- suppressWarnings(as.numeric(th$max_features %||% df$max_features[[idx]]))
    df$min_umi_counts[[idx]] <- suppressWarnings(as.numeric(th$min_umi %||% df$min_umi_counts[[idx]]))
    df$max_umi_counts[[idx]] <- suppressWarnings(as.numeric(th$max_umi %||% df$max_umi_counts[[idx]]))
    df$max_mt_percent[[idx]] <- suppressWarnings(as.numeric(th$max_mt %||% df$max_mt_percent[[idx]]))
    qc_table_data(df)
    invisible(NULL)
  }
  .commit_slider_thresholds_and_recalc <- function(force_recalc = FALSE, require_dirty = TRUE) {
    if (!identical(isolate(input$main_navbar %||% ""), "qc_tab")) return(invisible(NULL))
    if (isTRUE(require_dirty) && !isTRUE(qc_slider_dirty())) return(invisible(NULL))
    nm <- .current_threshold_sample_name()
    if (is.null(nm) || !nzchar(nm)) return(invisible(NULL))
    th_now <- read_thresholds(nm)
    .qc_log(
      "[QC-DEBUG] committed thresholds | sample=", nm,
      " | applied(coeff_a,a,coeff_b,b,max_mt)=(",
      paste(
        as.character(th_now$coeff_a %||% NA),
        as.character(th_now$a %||% NA),
        as.character(th_now$coeff_b %||% NA),
        as.character(th_now$b %||% NA),
        as.character(th_now$max_mt %||% NA),
        sep = ","
      ),
      ")"
    )
    resolved_key <- .resolve_object_key_for_sample(
      nm,
      df = isolate(.ensure_qc_table_cols(qc_table_data())),
      reg = isolate(shared_data$all_seurat_objects %||% list())
    )
    .persist_thresholds_to_table(nm, th_now, object_key = resolved_key)
    qc_committed_slope_space(.selected_slope_space())
    qc_mode_pending(FALSE)
    .queue_qc_recalc(force = isTRUE(force_recalc))
    qc_slider_dirty(FALSE)
    invisible(NULL)
  }
  .current_recalc_signature <- function() {
    nm <- as.character(isolate(.current_threshold_sample_name()) %||% "")
    key <- as.character(isolate(viewer_object_name()) %||% "")
    th <- if (nzchar(nm)) .get_thresholds(nm) else NULL
    th_sig <- if (!is.null(th)) .qc_threshold_signature(th) else "no_thresholds"
    reg <- as.character(isolate(.selected_regression_overlay()) %||% "none")
    slope <- as.character(isolate(qc_committed_slope_space()) %||% isolate(.selected_slope_space()) %||% "linear")
    paste(nm, key, reg, slope, th_sig, sep = "::")
  }
  .queue_qc_recalc <- function(force = FALSE) {
    tryCatch({
      if (!identical(isolate(input$main_navbar %||% ""), "qc_tab")) return(invisible(NULL))
      if (!isTRUE(force) && isTRUE(isolate(input$qc_slider_dragging %||% FALSE))) return(invisible(NULL))
      df <- isolate(qc_table_data())
      if (is.null(df) || !nrow(df)) return(invisible(NULL))
      sig <- .current_recalc_signature()
      pending_now <- isTRUE(isolate(qc_render_pending()))
      if (!pending_now && identical(sig, isolate(qc_last_recalc_signature()))) {
        .qc_log("[QC-DEBUG] skip duplicate recalc cycle | signature=", sig)
        return(invisible(NULL))
      }
      qc_last_recalc_signature(sig)
      .qc_log("[QC-DEBUG] begin recalc cycle | pending_now=", pending_now, " | signature=", sig)
      .begin_qc_render_cycle("Recalculating QC plots...")
      .qc_cache_clear()
      invisible(NULL)
    }, error = function(e) {
      .qc_log("[QC-ERROR] .queue_qc_recalc failed: ", conditionMessage(e))
      .qc_log("[QC-ERROR] call tail:\n", paste(tail(vapply(sys.calls(), function(cl) paste(deparse(cl), collapse = " "), character(1)), 12L), collapse = "\n"))
      stop(e)
    })
  }

  observeEvent(
    list(
      input$qc_min_features, input$qc_max_features,
      input$qc_min_umi, input$qc_max_umi, input$qc_max_mt,
      input$qc_coeff_a, input$qc_upper_a, input$qc_coeff_b, input$qc_lower_b
    ),
    {
      if (!identical(input$main_navbar %||% "", "qc_tab")) return(invisible(NULL))
      if (isTRUE(qc_programmatic_slider_update())) return(invisible(NULL))
      # Recalc is release-gated server-side by drag state.
      qc_slider_dirty(TRUE)
      qc_slider_last_change_ms(as.numeric(Sys.time()) * 1000)
      qc_committed_slope_space(.selected_slope_space())
      qc_mode_pending(FALSE)
      invisible(NULL)
    },
    ignoreInit = TRUE
  )

  observeEvent(input$qc_slider_dragging, {
    if (!identical(input$main_navbar %||% "", "qc_tab")) return(invisible(NULL))
    if (isTRUE(input$qc_slider_dragging %||% FALSE)) return(invisible(NULL))
    .commit_slider_thresholds_and_recalc(force_recalc = TRUE, require_dirty = TRUE)
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$qc_slider_commit_nonce, {
    if (!identical(input$main_navbar %||% "", "qc_tab")) return(invisible(NULL))
    if (isTRUE(qc_programmatic_slider_update())) return(invisible(NULL))
    if (isTRUE(input$qc_slider_dragging %||% FALSE)) return(invisible(NULL))
    now_ms <- as.numeric(Sys.time()) * 1000
    if (is.finite(now_ms) && now_ms < as.numeric(isolate(qc_slider_commit_suppress_until_ms()) %||% 0)) {
      return(invisible(NULL))
    }
    .commit_slider_thresholds_and_recalc(force_recalc = TRUE, require_dirty = TRUE)
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$qc_regression_overlay, {
    if (!identical(input$main_navbar %||% "", "qc_tab")) return(invisible(NULL))
    qc_slider_dirty(FALSE)
    qc_programmatic_slider_update(TRUE)
    on.exit(qc_programmatic_slider_update(FALSE), add = TRUE)
    mode_now <- .selected_slope_space()
    qc_mode_pending(TRUE)
    .update_slope_slider_domain(mode = mode_now, reset_values = TRUE)
    invisible(NULL)
  }, ignoreInit = TRUE)

  .update_sidebar_sliders <- function(sample_name) {
    req(sample_name)
    qc_programmatic_slider_update(TRUE)
    on.exit(qc_programmatic_slider_update(FALSE), add = TRUE)
    qc_slider_commit_suppress_until_ms(as.numeric(Sys.time()) * 1000 + 1500)
    df <- isolate(qc_table_data()); req(df, nrow(df) > 0)
    i <- match(sample_name, as.character(df$name))
    req(!is.na(i))
    qc_current_threshold_sample(as.character(df$name[[i]]))
    row <- df[i, , drop = FALSE]
    th0 <- .get_thresholds(sample_name)
    .num <- function(x, default) {
      y <- suppressWarnings(as.numeric(gsub(",", "", x)))
      if (length(y) == 1 && !is.na(y)) y else default
    }
    .clamp <- function(x, lo, hi) {
      x <- suppressWarnings(as.numeric(x))
      if (!is.finite(x)) x <- lo
      min(hi, max(lo, x))
    }

    reg <- isolate(shared_data$all_seurat_objects %||% list())
    source_key <- as.character(row$source_object[[1]] %||% sample_name)
    resolved_key <- .resolve_object_key_for_sample(sample_name, df = df, reg = reg)
    obj_entry <- if (nzchar(resolved_key)) reg[[resolved_key]] else NULL
    if (is.null(obj_entry)) obj_entry <- reg[[source_key]]
    if (is.null(obj_entry)) obj_entry <- reg[[sample_name]]
    if (is.null(obj_entry) && nzchar(isolate(viewer_object_name()) %||% "")) {
      obj_entry <- reg[[isolate(viewer_object_name())]]
    }
    if (is.null(obj_entry)) {
      best <- .pick_best_entry_name(sample_name, reg)
      obj_entry <- reg[[best]]
    }
    sobj <- .unwrap_seurat_candidate(obj_entry)
    md <- if (inherits(sobj, "Seurat")) .ensure_qc_md(sobj) else NULL

    data_nf <- suppressWarnings(as.numeric(md[["nFeature_RNA"]]))
    data_nc <- suppressWarnings(as.numeric(md[["nCount_RNA"]]))
    data_mt <- suppressWarnings(as.numeric(md[["percent.mt"]]))
    data_nf <- data_nf[is.finite(data_nf)]
    data_nc <- data_nc[is.finite(data_nc)]
    data_mt <- data_mt[is.finite(data_mt)]

    nf_cap <- if (length(data_nf)) ceiling(max(data_nf) * 1.2) else .num(row$max_features, 5000)
    nc_cap <- if (length(data_nc)) ceiling(max(data_nc) * 1.2) else .num(row$max_umi_counts, 50000)
    mt_cap <- if (length(data_mt)) ceiling(max(data_mt) * 1.2) else .num(row$max_mt_percent, 20)
    mt_cap <- .clamp(mt_cap, 1, 100)

    nf_slider_max <- max(1000, nf_cap)
    nc_slider_max <- max(10000, nc_cap)

    min_features_val <- .clamp(.num(th0$min_features, .num(row$min_features, 200)), 0, nf_slider_max)
    max_features_val <- .clamp(.num(th0$max_features, .num(row$max_features, 5000)), 0, nf_slider_max)
    min_umi_val <- .clamp(.num(th0$min_umi, .num(row$min_umi_counts, 500)), 0, nc_slider_max)
    max_umi_val <- .clamp(.num(th0$max_umi, .num(row$max_umi_counts, 50000)), 0, nc_slider_max)
    max_mt_val <- .clamp(.num(th0$max_mt, .num(row$max_mt_percent, 20)), 0, mt_cap)

    updateSliderInput(session, "qc_min_features",
      min = 0, max = nf_slider_max,
      value = min_features_val, step = 10
    )
    updateSliderInput(session, "qc_max_features",
      min = 0, max = nf_slider_max,
      value = max_features_val, step = 10
    )
    updateSliderInput(session, "qc_min_umi",
      min = 0, max = nc_slider_max,
      value = min_umi_val, step = 50
    )
    updateSliderInput(session, "qc_max_umi",
      min = 0, max = nc_slider_max,
      value = max_umi_val, step = 500
    )
    updateSliderInput(session, "qc_max_mt",
      min = 0, max = mt_cap, value = max_mt_val, step = 1
    )
    updateSliderInput(session, "qc_coeff_a", min = 0, max = 2, value = .num(th0$coeff_a, 0.5), step = 0.01)
    updateSliderInput(session, "qc_upper_a", min = 0, max = 20000, value = .num(th0$a, 1300), step = 50)
    updateSliderInput(session, "qc_coeff_b", min = 0, max = 0.5, value = .num(th0$coeff_b, 0.05), step = 0.01)
    b_val <- .num(th0$b, 0)
    b_val <- max(-5000, min(5000, b_val))
    updateSliderInput(session, "qc_lower_b", min = -5000, max = 5000, value = b_val, step = 10)
    .update_slope_slider_domain(mode = .selected_slope_space(), reset_values = FALSE)
  }

  .init_sliders_include_all <- function(session, sid, df) {
    `%||%` <- function(a,b) if (is.null(a)) b else a
    nf <- df[["nFeature_RNA"]] %||% df[["nFeature"]] %||% df[["features"]]
    nc <- df[["nCount_RNA"]]   %||% df[["nCount"]]   %||% df[["counts"]]
    mt <- df[["percent.mt"]]   %||% df[["percent.mito"]] %||% df[["mito"]]
    nf <- nf[is.finite(nf)]; nc <- nc[is.finite(nc)]; mt <- mt[is.finite(mt)]
    if (!length(mt)) mt <- 0
    
    nf_min <- floor(min(nf)); nf_max <- ceiling(max(nf))
    nc_min <- floor(min(nc)); nc_max <- ceiling(max(nc))
    mt_max <- ceiling(max(mt))
    
    nc_safe <- pmax(nc, 1)
    r <- nf / nc_safe
    r <- r[is.finite(r)]
    if (!length(r)) r <- 0
    rmin <- min(r); rmax <- max(r)
    
    updateSliderInput(session, paste0("s_",sid,"_min_features"),
                      min = 0, max = max(1000, nf_max), value = nf_min, step = 10)
    updateSliderInput(session, paste0("s_",sid,"_max_features"),
                      min = 0, max = max(10000, nf_max), value = nf_max, step = 10)
    updateSliderInput(session, paste0("s_",sid,"_min_umi"),
                      min = 0, max = max(1e4, nc_max), value = nc_min, step = 50)
    updateSliderInput(session, paste0("s_",sid,"_max_umi"),
                      min = 0, max = max(1e5, nc_max), value = nc_max, step = 500)
    updateSliderInput(session, paste0("s_",sid,"_max_mt"),
                      min = 0, max = max(100, mt_max), value = mt_max, step = 1)
    
    updateSliderInput(session, paste0("s_",sid,"_coeff_a"), value = rmax)
    updateSliderInput(session, paste0("s_",sid,"_a"),       value = 0)
    updateSliderInput(
      session, paste0("s_",sid,"_coeff_b"),
      min = 0, max = 0.5,
      value = max(0, min(0.5, rmin)),
      step = 0.01
    )
    updateSliderInput(session, paste0("s_",sid,"_b"),       value = 0)
  }
  
  .sliders_exist <- function(sid) {
    !is.null(shiny::isolate(input[[paste0("s_", sid, "_min_features")]]))
  }
  
  .get_active_md_safe <- function() {
    df <- isolate(qc_table_data())
    if (is.null(df) || !nrow(df)) return(NULL)
    nm <- isolate(active_name()) %||% df$name[[1]]
    entry <- isolate(shared_data$all_seurat_objects[[ nm ]])
    if (is.null(entry)) return(NULL)
    
    sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (is.null(sobj)) return(NULL)
    sobj@meta.data
  }
  
  mask_points <- function(df, th, slope_space = "linear", sat_fit = NULL) {
    nf <- df[["nFeature_RNA"]] %||% df[["nFeature"]] %||% df[["features"]]
    nc <- df[["nCount_RNA"]]   %||% df[["nCount"]]   %||% df[["counts"]]
    mt <- df[["percent.mt"]]   %||% df[["percent.mito"]] %||% df[["mito"]]
    if (is.null(mt)) mt <- rep(0, length(nf))
    
    keep <- is.finite(nf) & is.finite(nc) & is.finite(mt)
    
    if (!is.null(th$min_features)) keep <- keep & nf >= as.numeric(th$min_features)
    if (!is.null(th$max_features)) keep <- keep & nf <= as.numeric(th$max_features)
    if (!is.null(th$min_umi))      keep <- keep & nc >= as.numeric(th$min_umi)
    if (!is.null(th$max_umi))      keep <- keep & nc <= as.numeric(th$max_umi)
    if (!is.null(th$max_mt))       keep <- keep & mt <= as.numeric(th$max_mt)

    slope_space <- as.character(slope_space %||% "linear")
    if (!slope_space %in% c("linear", "logx", "loglog", "saturating")) slope_space <- "linear"

    c_b <- suppressWarnings(as.numeric(th$coeff_b))
    b_b <- suppressWarnings(as.numeric(th$b))
    c_a <- suppressWarnings(as.numeric(th$coeff_a))
    b_a <- suppressWarnings(as.numeric(th$a))

    sat <- sat_fit
    if (identical(slope_space, "saturating")) {
      if (is.null(sat)) sat <- .compute_saturating_fit(nc, nf)
      if (!is.null(sat)) {
        y_base <- sat$predict(nc)
        if (is.finite(c_b) && is.finite(b_b)) keep <- keep & is.finite(y_base) & (nf >= (c_b * y_base + b_b))
        if (is.finite(c_a) && is.finite(b_a)) keep <- keep & is.finite(y_base) & (nf <= (c_a * y_base + b_a))
      }
    } else if (is.finite(c_b) && is.finite(b_b)) {
      if (identical(slope_space, "logx")) {
        lx <- ifelse(is.finite(nc) & (nc >= 0), log10(nc + 1), NA_real_)
        keep <- keep & is.finite(lx) & (nf >= (c_b * lx + b_b))
      } else if (identical(slope_space, "loglog")) {
        lx <- ifelse(is.finite(nc) & (nc >= 0), log10(nc + 1), NA_real_)
        ly <- ifelse(is.finite(nf) & (nf >= 0), log10(nf + 1), NA_real_)
        keep <- keep & is.finite(lx) & is.finite(ly) & (ly >= (c_b * lx + b_b))
      } else {
        keep <- keep & (nf >= (c_b * nc + b_b))
      }
    }
    if (!identical(slope_space, "saturating") && is.finite(c_a) && is.finite(b_a)) {
      if (identical(slope_space, "logx")) {
        lx <- ifelse(is.finite(nc) & (nc >= 0), log10(nc + 1), NA_real_)
        keep <- keep & is.finite(lx) & (nf <= (c_a * lx + b_a))
      } else if (identical(slope_space, "loglog")) {
        lx <- ifelse(is.finite(nc) & (nc >= 0), log10(nc + 1), NA_real_)
        ly <- ifelse(is.finite(nf) & (nf >= 0), log10(nf + 1), NA_real_)
        keep <- keep & is.finite(lx) & is.finite(ly) & (ly <= (c_a * lx + b_a))
      } else {
        keep <- keep & (nf <= (c_a * nc + b_a))
      }
    }
    
    list(keep = keep, nf = nf, nc = nc, mt = mt, sat_fit = sat)
  }
  
  build_violin_with_dots <- function(
    vec, label,
    dots = c("right","normal","none"),
    normal_width = 0.04,
    violin_scale = c("count","density"),
    vln_ticks = c("auto","count","total","none"),
    panel_gutter = 0.01,
    seam = c("classic","seamless"),
    nbins = 80, smooth = TRUE,
    dot_panel_w = 0.20, box_panel_w = 0.10, vln_panel_w = 0.28,
    mask = NULL,
    th   = NULL
  ){
    dots         <- match.arg(dots)
    violin_scale <- match.arg(violin_scale)
    vln_ticks    <- match.arg(vln_ticks)
    seam         <- match.arg(seam)
    p_left <- NULL
    p_box  <- plotly::plot_ly()
    p_vln  <- plotly::plot_ly()
    
    y <- as.numeric(vec); y <- y[is.finite(y)]
    if (!length(y)) return(NULL)
    N <- length(y)
    kept <- if (!is.null(mask) && length(mask) == length(vec)) mask[is.finite(vec)] else rep(FALSE, length(y))
    y_kept <- y[kept]
    
    # ---- make sure panels always exist ----
    p_left <- NULL
    p_box  <- NULL
    p_vln  <- NULL
    
    dot_half_width <- 0.14
    dot_size <- 3; dot_alpha <- 0.55
    box_width <- 0.12
    
    u <- sort(unique(y)); step <- stats::median(diff(u))
    if (!is.finite(step)) step <- diff(range(y))/1000
    eps <- as.numeric(step)*0.15
    yj  <- if (eps > 0) y + stats::runif(length(y), -eps, eps) else y
    
    x_axis_no_ticks <- function(xrng = NULL, show_grid = TRUE){
      rng <- NULL
      if (!is.null(xrng)) {
        xs <- xrng[is.finite(xrng)]
        if (length(xs) >= 2) {
          lo <- min(xs); hi <- max(xs)
          if (is.finite(lo) && is.finite(hi) && hi > lo) rng <- c(lo, hi)
        }
      }
      ax <- list(
        type="linear",
        ticks="",
        showticklabels=FALSE,
        showgrid=isTRUE(show_grid),
        zeroline=FALSE,
        showline=TRUE,
        linecolor="rgba(0,0,0,0.35)", linewidth=1
      )
      if (!is.null(rng)) ax$range <- rng
      ax
    }
    
    y_axis_left <- list(
      title=label, automargin=TRUE, tickformat=",d",
      ticks="outside", showticklabels=TRUE,
      showgrid=TRUE, gridcolor="rgba(0,0,0,0.06)",
      zeroline=FALSE, showline=TRUE,
      linecolor="rgba(0,0,0,0.45)", linewidth=1
    )
    y_axis_overlay <- list(overlaying="y", showticklabels=FALSE,
                           showgrid=FALSE, showline=TRUE)
    
    # ---- DOTS (grey filtered + green kept) ----
    x_rng <- NULL
    if (dots == "right") {
      if (!requireNamespace("vipor", quietly = TRUE))
        stop("Please install 'vipor': install.packages('vipor')")
      off <- vipor::offsetX(y = yj, x = rep(1,length(yj)), width = dot_half_width, varwidth = TRUE)
      x_off <- pmin(0, -abs(off)); x_rng <- c(-dot_half_width - 0.03, 0.02)
      
      p_left <- plotly::plot_ly()
      if (length(kept) == length(yj)) {
        idx_f <- which(!kept); idx_k <- which(kept)
        if (length(idx_f)) p_left <- p_left |> plotly::add_trace(
          type = "scattergl", mode = "markers",
          x = x_off[idx_f], y = yj[idx_f],
          marker = list(size=dot_size, color="rgba(150,150,150,0.35)"),
          hoverinfo = "skip", showlegend = FALSE
        )
        if (length(idx_k)) p_left <- p_left |> plotly::add_trace(
          type = "scattergl", mode = "markers",
          x = x_off[idx_k], y = yj[idx_k],
          marker = list(size=dot_size, color="rgba(36,160,72,0.95)", opacity=0.9),
          hoverinfo = "skip", showlegend = FALSE
        )
      } else {
        p_left <- p_left |> plotly::add_trace(
          type = "scattergl", mode = "markers",
          x = x_off, y = yj,
          marker = list(size=dot_size, opacity=dot_alpha, color="rgba(50,100,200,1)"),
          hoverinfo = "skip", showlegend = FALSE
        )
      }
      p_left <- p_left |>
        plotly::layout(xaxis = x_axis_no_ticks(x_rng, show_grid = (seam=="classic")),
                       yaxis = y_axis_left,
                       margin = list(l=64, r=0, t=4, b=28))
    } else if (dots == "normal") {
      hw <- max(0.01, as.numeric(normal_width))
      x_off <- stats::runif(length(yj), -hw, hw)
      x_rng <- c(-hw - 0.03, hw)
      
      p_left <- plotly::plot_ly()
      if (length(kept) == length(yj)) {
        idx_f <- which(!kept); idx_k <- which(kept)
        if (length(idx_f)) p_left <- p_left |> plotly::add_trace(
          type = "scattergl", mode = "markers",
          x = x_off[idx_f], y = yj[idx_f],
          marker = list(size=dot_size, color="rgba(150,150,150,0.35)"),
          hoverinfo = "skip", showlegend = FALSE
        )
        if (length(idx_k)) p_left <- p_left |> plotly::add_trace(
          type = "scattergl", mode = "markers",
          x = x_off[idx_k], y = yj[idx_k],
          marker = list(size=dot_size, color="rgba(36,160,72,0.95)", opacity=0.9),
          hoverinfo = "skip", showlegend = FALSE
        )
      } else {
        p_left <- p_left |> plotly::add_trace(
          type = "scattergl", mode = "markers",
          x = x_off, y = yj,
          marker = list(size=dot_size, opacity=dot_alpha, color="rgba(50,100,200,1)"),
          hoverinfo = "skip", showlegend = FALSE
        )
      }
      p_left <- p_left |>
        plotly::layout(xaxis = x_axis_no_ticks(x_rng, show_grid = (seam=="classic")),
                       yaxis = y_axis_left,
                       margin = list(l=64, r=0, t=4, b=28))
    }
    # if dots == "none" => p_left stays NULL (subplot handles that)
    
    # ---- BOX ----
    p_box <- plotly::plot_ly() |>
      plotly::add_boxplot(
        y = y, boxpoints = FALSE, width = box_width,
        line = list(width = 1, color = "rgba(255,140,0,1)"),
        fillcolor = "rgba(255,140,0,0.15)", whiskerwidth = 0.6,
        name = "", hoverinfo = "skip", showlegend = FALSE
      ) |>
      plotly::layout(xaxis = x_axis_no_ticks(NULL, show_grid = (seam == "classic")),
                     yaxis = y_axis_overlay,
                     margin = list(l = 0, r = 0, t = 4, b = 28))
    
    # ---- VIOLIN(S) + cutoff lines ----
    add_cut_lines <- function(plt, x_range) {
      if (is.null(th)) return(plt)
      y_lines <- numeric(0)
      if (identical(label, "percent.mt") && !is.null(th$max_mt)) {
        y_lines <- c(as.numeric(th$max_mt))
      }
      if (identical(label, "nFeature_RNA")) {
        if (!is.null(th$min_features)) y_lines <- c(y_lines, as.numeric(th$min_features))
        if (!is.null(th$max_features)) y_lines <- c(y_lines, as.numeric(th$max_features))
      }
      if (identical(label, "nCount_RNA")) {
        if (!is.null(th$min_umi)) y_lines <- c(y_lines, as.numeric(th$min_umi))
        if (!is.null(th$max_umi)) y_lines <- c(y_lines, as.numeric(th$max_umi))
      }
      if (!length(y_lines)) return(plt)
      for (y0 in y_lines) {
        plt <- plt |> plotly::add_trace(
          x = x_range, y = c(y0, y0),
          type="scatter", mode="lines",
          line = list(color="rgba(80,80,80,0.8)", dash="dash", width=1),
          hoverinfo="skip", showlegend=FALSE, inherit=FALSE
        )
      }
      plt
    }
    
    if (violin_scale == "density") {
      tv <- pretty(c(0, 1), 3)*dot_half_width
      tt <- format(round(tv/dot_half_width * N), big.mark=",")
      ax_v <- list(type="linear", showgrid=TRUE, tickmode="array", tickvals=tv, ticktext=tt,
                   zeroline=FALSE, showline=TRUE, linecolor="rgba(0,0,0,0.35)", linewidth=1)
      
      p_vln <- plotly::plot_ly() |>
        plotly::add_trace(
          x = rep(0, N), y = y, type = "violin", side = "positive", points = "false",
          line = list(color="rgba(44,98,160,0.95)", width=1),
          fillcolor = "rgba(44,98,160,0.30)", scalemode="width",
          meanline = list(visible=FALSE), width=0.5, showlegend=FALSE
        )
      
      if (length(y_kept)) {
        p_vln <- p_vln |>
          plotly::add_trace(
            x = rep(0, length(y_kept)), y = y_kept, type = "violin", side = "positive", points = "false",
            line = list(color="rgba(36,160,72,1)", width=1),
            fillcolor = "rgba(36,160,72,0.35)", scalemode="width",
            meanline = list(visible=FALSE), width=0.5, showlegend=FALSE, inherit=FALSE
          )
      }
      
      p_vln <- p_vln |>
        plotly::layout(xaxis=ax_v, yaxis=y_axis_overlay, margin=list(l=0, r=0, t=4, b=28)) |>
        add_cut_lines(x_range = c(0, dot_half_width))
      
    } else { # "count"
      rng <- range(y, na.rm = TRUE)
      if (!is.finite(rng[1]) || !is.finite(rng[2]) || rng[1] == rng[2]) {
        eps <- if (is.finite(rng[1])) (abs(rng[1]) * 1e-6 + 1e-6) else 1e-6
        rng[2] <- rng[1] + eps
      }
      brks <- seq(rng[1], rng[2], length.out = nbins + 1)
      mids <- (brks[-1] + brks[-length(brks)]) / 2
      cnt  <- as.numeric(table(cut(y, brks, include.lowest = TRUE)))
      if (smooth && length(cnt) > 2) { cnt <- as.numeric(stats::filter(cnt, rep(1,3)/3, sides=2)); cnt[is.na(cnt)] <- 0 }
      max_cnt <- max(cnt, na.rm=TRUE); if (max_cnt < 1) max_cnt <- 1
      
      if (vln_ticks %in% c("auto","count")) { tv <- pretty(c(0, max_cnt), 4); tt <- format(tv, big.mark=",") }
      else if (vln_ticks == "total") { tv <- c(0, max_cnt); tt <- c("0", format(length(y), big.mark=",")) }
      else { tv <- NULL; tt <- NULL }
      ax_v <- if (is.null(tv)) {
        list(type="linear", showgrid=TRUE, ticks="", showticklabels=FALSE,
             zeroline=FALSE, showline=TRUE, linecolor="rgba(0,0,0,0.35)", linewidth=1)
      } else {
        list(type="linear", showgrid=TRUE, tickmode="array", tickvals=tv, ticktext=tt,
             zeroline=FALSE, showline=TRUE, linecolor="rgba(0,0,0,0.35)", linewidth=1)
      }
      
      p_vln <- plotly::plot_ly() |>
        plotly::add_trace(
          x = cnt, y = mids, type="scatter", mode="lines",
          fill="tozerox",
          line=list(color="rgba(44,98,160,0.95)", width=1),
          fillcolor="rgba(44,98,160,0.30)",
          customdata = round(cnt),
          hovertemplate="y: %{y:.0f}<br>count: %{customdata}<extra></extra>",
          showlegend=FALSE
        )
      
      if (length(y_kept)) {
        cnt_k <- as.numeric(table(cut(y_kept, brks, include.lowest = TRUE)))
        if (smooth && length(cnt_k) > 2) { cnt_k <- as.numeric(stats::filter(cnt_k, rep(1,3)/3, sides=2)); cnt_k[is.na(cnt_k)] <- 0 }
        p_vln <- p_vln |>
          plotly::add_trace(
            x = cnt_k, y = mids, type="scatter", mode="lines",
            fill="tozerox",
            line=list(color="rgba(36,160,72,1)", width=1),
            fillcolor="rgba(36,160,72,0.35)",
            hoverinfo="skip", showlegend=FALSE, inherit=FALSE
          )
      }
      
      p_vln <- p_vln |>
        plotly::layout(xaxis=ax_v, yaxis=y_axis_overlay, margin=list(l=0, r=0, t=4, b=28)) |>
        add_cut_lines(x_range = c(0, max_cnt))
    }
    
    # ---- assemble (p_left optional) ----
    out <- if (is.null(p_left)) {
      plotly::subplot(p_box, p_vln, nrows=1, shareY=TRUE,
                      widths=c(box_panel_w, vln_panel_w),
                      margin = if (seam=="seamless") 0 else panel_gutter)
    } else {
      plotly::subplot(p_left, p_box, p_vln, nrows=1, shareY=TRUE,
                      widths=c(dot_panel_w, box_panel_w, vln_panel_w),
                      margin = if (seam=="seamless") 0 else panel_gutter)
    }
    
    out |>
      plotly::layout(yaxis = y_axis_left, hovermode = "closest") |>
      plotly::config(displaylogo = FALSE)
  }
  
  output$qc_vln_plot_nfeature <- renderPlotly({
    if (!identical(input$main_navbar %||% "", "qc_tab")) {
      return(
        plot_ly() %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    render_epoch <- qc_render_epoch()
    tryCatch({
      viewer_object_name()
      pending <- isTRUE(qc_render_pending())
      if (pending) {
        .ensure_qc_render_overlay("Recalculating QC plots...")
        render_epoch <- isolate(qc_render_epoch())
      }
      ctx <- .build_qc_plot_bundle(use_input_thresholds = TRUE)
      if (is.null(ctx)) {
        .mark_qc_output_ready("qc_vln_plot_nfeature", epoch = render_epoch)
        return(.qc_error_plot(
          paste0("missing QC metadata for selected object. ", qc_diag_text() %||% ""),
          "", "nFeature_RNA"
        ))
      }
      key <- .qc_cache_key("vln_nfeature", ctx$object_key, ctx$md, ctx$th)
      cached <- .qc_cache_get(key)
      if (!pending && !is.null(cached)) {
        .mark_qc_output_ready("qc_vln_plot_nfeature", epoch = render_epoch)
        return(cached)
      }
      p <- build_violin_with_dots(
        ctx$ms$nf, "nFeature_RNA",
        dots = "normal", violin_scale = "count", vln_ticks = "auto",
        seam = "classic", mask = ctx$ms$keep, th = ctx$th
      )
      if (is.null(p)) {
        .mark_qc_output_ready("qc_vln_plot_nfeature", epoch = render_epoch)
        return(.qc_error_plot("no finite nFeature values", "", "nFeature_RNA"))
      }
      .qc_cache_set(key, p)
      .mark_qc_output_ready("qc_vln_plot_nfeature", epoch = render_epoch)
      p
    }, error = function(e) {
      .qc_log("[QC] vln nFeature render error: ", conditionMessage(e))
      .mark_qc_output_ready("qc_vln_plot_nfeature", epoch = render_epoch)
      .qc_error_plot(conditionMessage(e), "", "nFeature_RNA")
    })
  })

  output$qc_vln_plot_ncount <- renderPlotly({
    if (!identical(input$main_navbar %||% "", "qc_tab")) {
      return(
        plot_ly() %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    render_epoch <- qc_render_epoch()
    tryCatch({
      viewer_object_name()
      pending <- isTRUE(qc_render_pending())
      if (pending) {
        .ensure_qc_render_overlay("Recalculating QC plots...")
        render_epoch <- isolate(qc_render_epoch())
      }
      ctx <- .build_qc_plot_bundle(use_input_thresholds = TRUE)
      if (is.null(ctx)) {
        .mark_qc_output_ready("qc_vln_plot_ncount", epoch = render_epoch)
        return(.qc_error_plot(
          paste0("missing QC metadata for selected object. ", qc_diag_text() %||% ""),
          "", "nCount_RNA"
        ))
      }
      key <- .qc_cache_key("vln_ncount", ctx$object_key, ctx$md, ctx$th)
      cached <- .qc_cache_get(key)
      if (!pending && !is.null(cached)) {
        .mark_qc_output_ready("qc_vln_plot_ncount", epoch = render_epoch)
        return(cached)
      }
      p <- build_violin_with_dots(
        ctx$ms$nc, "nCount_RNA",
        dots = "normal", violin_scale = "count", vln_ticks = "auto",
        seam = "classic", mask = ctx$ms$keep, th = ctx$th
      )
      if (is.null(p)) {
        .mark_qc_output_ready("qc_vln_plot_ncount", epoch = render_epoch)
        return(.qc_error_plot("no finite nCount values", "", "nCount_RNA"))
      }
      .qc_cache_set(key, p)
      .mark_qc_output_ready("qc_vln_plot_ncount", epoch = render_epoch)
      p
    }, error = function(e) {
      .qc_log("[QC] vln nCount render error: ", conditionMessage(e))
      .mark_qc_output_ready("qc_vln_plot_ncount", epoch = render_epoch)
      .qc_error_plot(conditionMessage(e), "", "nCount_RNA")
    })
  })

  output$qc_vln_plot_mt <- renderPlotly({
    if (!identical(input$main_navbar %||% "", "qc_tab")) {
      return(
        plot_ly() %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    render_epoch <- qc_render_epoch()
    tryCatch({
      viewer_object_name()
      pending <- isTRUE(qc_render_pending())
      if (pending) {
        .ensure_qc_render_overlay("Recalculating QC plots...")
        render_epoch <- isolate(qc_render_epoch())
      }
      ctx <- .build_qc_plot_bundle(use_input_thresholds = TRUE)
      if (is.null(ctx)) {
        .mark_qc_output_ready("qc_vln_plot_mt", epoch = render_epoch)
        return(.qc_error_plot(
          paste0("missing QC metadata for selected object. ", qc_diag_text() %||% ""),
          "", "percent.mt"
        ))
      }
      key <- .qc_cache_key("vln_mt", ctx$object_key, ctx$md, ctx$th)
      cached <- .qc_cache_get(key)
      if (!pending && !is.null(cached)) {
        .mark_qc_output_ready("qc_vln_plot_mt", epoch = render_epoch)
        return(cached)
      }
      p <- build_violin_with_dots(
        ctx$ms$mt, "percent.mt",
        dots = "normal", violin_scale = "count", vln_ticks = "auto",
        seam = "classic", mask = ctx$ms$keep, th = ctx$th
      )
      if (is.null(p)) {
        .mark_qc_output_ready("qc_vln_plot_mt", epoch = render_epoch)
        return(.qc_error_plot("no finite percent.mt values", "", "percent.mt"))
      }
      .qc_cache_set(key, p)
      .mark_qc_output_ready("qc_vln_plot_mt", epoch = render_epoch)
      p
    }, error = function(e) {
      .qc_log("[QC] vln percent.mt render error: ", conditionMessage(e))
      .mark_qc_output_ready("qc_vln_plot_mt", epoch = render_epoch)
      .qc_error_plot(conditionMessage(e), "", "percent.mt")
    })
  })
  
  read_thresholds_for_active <- function(){
    df <- qc_table_data(); req(df)
    nm <- active_name() %||% df$name[[1]]
    .get_thresholds(nm)
  }

  .qc_data_signature <- function(md) {
    if (is.null(md) || !nrow(md)) return("empty")
    rn <- rownames(md)
    first_id <- if (length(rn)) rn[[1]] else ""
    last_id  <- if (length(rn)) rn[[length(rn)]] else ""
    paste0(nrow(md), "::", first_id, "::", last_id)
  }

  .qc_threshold_signature <- function(th) {
    vals <- c(
      th$min_features, th$max_features,
      th$min_umi, th$max_umi,
      th$max_mt,
      th$coeff_a, th$a,
      th$coeff_b, th$b
    )
    paste(format(signif(as.numeric(vals), 8), scientific = FALSE, trim = TRUE), collapse = "|")
  }

  .qc_cache_key <- function(plot_id, object_key, md, th, extra = NULL) {
    key <- paste(
      plot_id,
      object_key %||% "no_object",
      .qc_data_signature(md),
      .qc_threshold_signature(th),
      sep = "::"
    )
    if (!is.null(extra) && nzchar(extra %||% "")) {
      key <- paste(key, as.character(extra), sep = "::")
    }
    key
  }

  .selected_regression_overlay <- function() {
    val <- as.character(isolate(input$qc_regression_overlay %||% "none"))
    if (!val %in% c("none", "log", "power", "saturating", "all")) val <- "none"
    val
  }

  .selected_slope_space <- function() {
    reg <- .selected_regression_overlay()
    if (identical(reg, "log")) return("logx")
    if (identical(reg, "power")) return("loglog")
    if (identical(reg, "saturating")) return("saturating")
    "linear"
  }

  .slope_mode_label <- function(space) {
    if (identical(space, "saturating")) return("saturating")
    if (identical(space, "loglog")) return("log10-log10")
    if (identical(space, "logx")) return("log10-x")
    "linear"
  }

  .transform_xy_for_space <- function(x, y, space = "linear") {
    space <- as.character(space %||% "linear")
    if (!space %in% c("linear", "logx", "loglog", "saturating")) space <- "linear"
    x <- as.numeric(x)
    y <- as.numeric(y)
    if (identical(space, "logx")) {
      xt <- ifelse(is.finite(x) & (x >= 0), log10(x + 1), NA_real_)
      yt <- y
    } else if (identical(space, "loglog")) {
      xt <- ifelse(is.finite(x) & (x >= 0), log10(x + 1), NA_real_)
      yt <- ifelse(is.finite(y) & (y >= 0), log10(y + 1), NA_real_)
    } else {
      xt <- x
      yt <- y
    }
    list(x = xt, y = yt, valid = is.finite(xt) & is.finite(yt))
  }

  .transform_x_threshold <- function(v, space = "linear") {
    z <- suppressWarnings(as.numeric(v))
    if (length(z) != 1 || !is.finite(z)) return(NA_real_)
    if (space %in% c("linear", "saturating")) return(z)
    if (z < 0) return(NA_real_)
    log10(z + 1)
  }

  .transform_y_threshold <- function(v, space = "linear") {
    z <- suppressWarnings(as.numeric(v))
    if (length(z) != 1 || !is.finite(z)) return(NA_real_)
    if (identical(space, "loglog")) {
      if (z < 0) return(NA_real_)
      return(log10(z + 1))
    }
    z
  }

  .compute_saturating_fit <- function(x, y) {
    x <- suppressWarnings(as.numeric(x))
    y <- suppressWarnings(as.numeric(y))
    valid <- is.finite(x) & is.finite(y) & (x > 0) & (y > 0)
    if (sum(valid) < 20) return(NULL)
    xv <- x[valid]
    yv <- y[valid]
    # Robust fit on x-binned medians to avoid density bias and unstable steep fits.
    probs <- seq(0, 1, length.out = 61)
    br <- suppressWarnings(stats::quantile(xv, probs = probs, na.rm = TRUE, names = FALSE))
    br <- unique(br[is.finite(br)])
    use_binned <- length(br) >= 8
    if (use_binned) {
      grp <- cut(xv, breaks = br, include.lowest = TRUE)
      x_fit <- as.numeric(stats::aggregate(xv, list(grp), stats::median)$x)
      y_fit <- as.numeric(stats::aggregate(yv, list(grp), stats::median)$x)
      w_fit <- as.numeric(stats::aggregate(yv, list(grp), length)$x)
      ok <- is.finite(x_fit) & is.finite(y_fit) & is.finite(w_fit) & (x_fit > 0) & (y_fit > 0) & (w_fit > 0)
      x_fit <- x_fit[ok]; y_fit <- y_fit[ok]; w_fit <- sqrt(w_fit[ok])
      if (length(x_fit) < 8) use_binned <- FALSE
    }
    if (!use_binned) {
      x_fit <- xv
      y_fit <- yv
      w_fit <- rep(1, length(x_fit))
    }
    start_vmax <- suppressWarnings(stats::quantile(y_fit, probs = 0.98, na.rm = TRUE, names = FALSE))
    if (!is.finite(start_vmax) || start_vmax <= 0) start_vmax <- max(y_fit, na.rm = TRUE)
    y_half <- start_vmax * 0.5
    start_km <- x_fit[which.min(abs(y_fit - y_half))]
    if (!is.finite(start_km) || start_km <= 0) start_km <- suppressWarnings(stats::median(x_fit, na.rm = TRUE))
    if (!is.finite(start_km) || start_km <= 0) start_km <- max(1, min(x_fit, na.rm = TRUE))
    vmax_hi <- max(y_fit, na.rm = TRUE) * 5
    vmax_lo <- max(1, max(y_fit, na.rm = TRUE) * 0.5)
    km_lo <- max(1, suppressWarnings(stats::quantile(x_fit, probs = 0.01, na.rm = TRUE, names = FALSE)) * 0.25)
    km_hi <- max(km_lo + 1, suppressWarnings(stats::quantile(x_fit, probs = 0.99, na.rm = TRUE, names = FALSE)) * 5)
    fit <- tryCatch(
      stats::nls(
        y_fit ~ Vmax * x_fit / (Km + x_fit),
        start = list(Vmax = as.numeric(start_vmax), Km = as.numeric(start_km)),
        algorithm = "port",
        lower = c(Vmax = vmax_lo, Km = km_lo),
        upper = c(Vmax = vmax_hi, Km = km_hi),
        weights = w_fit,
        control = list(warnOnly = TRUE, maxiter = 200)
      ),
      error = function(e) NULL
    )
    if (is.null(fit)) {
      fit <- tryCatch(
        stats::nls(
          yv ~ Vmax * xv / (Km + xv),
          start = list(Vmax = as.numeric(start_vmax), Km = as.numeric(start_km)),
          algorithm = "port",
          lower = c(Vmax = 0, Km = 0),
          control = list(warnOnly = TRUE, maxiter = 200)
        ),
        error = function(e) NULL
      )
    }
    if (is.null(fit)) return(NULL)
    list(
      fit = fit,
      predict = function(xnew) {
        xx <- suppressWarnings(as.numeric(xnew))
        out <- rep(NA_real_, length(xx))
        idx <- is.finite(xx) & (xx > 0)
        if (any(idx)) {
          out[idx] <- tryCatch(
            suppressWarnings(stats::predict(fit, newdata = data.frame(x_fit = xx[idx]))),
            error = function(e) rep(NA_real_, sum(idx))
          )
        }
        out
      }
    )
  }

  .update_slope_slider_domain <- function(mode = .selected_slope_space(), reset_values = FALSE) {
    mode <- as.character(mode %||% "linear")
    if (!mode %in% c("linear", "logx", "loglog", "saturating")) mode <- "linear"
    qc_slider_commit_suppress_until_ms(as.numeric(Sys.time()) * 1000 + 1500)
    base_label_coeff_a <- "Upper boundary slope (coeff_a)"
    base_label_coeff_b <- "Lower boundary slope (coeff_b)"
    base_label_upper_a <- "Upper boundary offset (a)"
    base_label_lower_b <- "Lower boundary offset (b)"
    mode_tag <- .slope_mode_label(mode)

    if (identical(mode, "saturating")) {
      label_coeff_a <- "Upper envelope scale (coeff_a)"
      label_coeff_b <- "Lower envelope scale (coeff_b)"
      label_upper_a <- "Upper envelope offset (a)"
      label_lower_b <- "Lower envelope offset (b)"
    } else if (identical(mode, "linear")) {
      label_coeff_a <- base_label_coeff_a
      label_coeff_b <- base_label_coeff_b
      label_upper_a <- base_label_upper_a
      label_lower_b <- base_label_lower_b
    } else {
      label_coeff_a <- sprintf("%s [%s]", base_label_coeff_a, mode_tag)
      label_coeff_b <- sprintf("%s [%s]", base_label_coeff_b, mode_tag)
      label_upper_a <- sprintf("%s [%s]", base_label_upper_a, mode_tag)
      label_lower_b <- sprintf("%s [%s]", base_label_lower_b, mode_tag)
    }

    if (identical(mode, "linear")) {
      cur_ca <- suppressWarnings(as.numeric(input$qc_coeff_a %||% NA_real_))
      cur_cb <- suppressWarnings(as.numeric(input$qc_coeff_b %||% NA_real_))
      cur_a <- suppressWarnings(as.numeric(input$qc_upper_a %||% NA_real_))
      cur_b <- suppressWarnings(as.numeric(input$qc_lower_b %||% NA_real_))
      use_ca <- if (!reset_values && is.finite(cur_ca)) min(2, max(0, cur_ca)) else 0.5
      use_cb <- if (!reset_values && is.finite(cur_cb)) min(0.5, max(0, cur_cb)) else 0.05
      use_a <- if (!reset_values && is.finite(cur_a)) min(20000, max(0, cur_a)) else 1300
      use_b <- if (!reset_values && is.finite(cur_b)) min(5000, max(-5000, cur_b)) else 0
      updateSliderInput(session, "qc_coeff_a", label = label_coeff_a, min = 0, max = 2, step = 0.01)
      updateSliderInput(session, "qc_coeff_b", label = label_coeff_b, min = 0, max = 0.5, step = 0.01)
      updateSliderInput(session, "qc_upper_a", label = label_upper_a, min = 0, max = 20000, step = 50)
      updateSliderInput(session, "qc_lower_b", label = label_lower_b, min = -5000, max = 5000, step = 10)
      return(invisible(list(coeff_a = use_ca, coeff_b = use_cb, a = use_a, b = use_b)))
    }

    md <- tryCatch(.get_active_md_safe(), error = function(e) NULL)
    nc <- suppressWarnings(as.numeric(md[["nCount_RNA"]] %||% md[["nCount"]] %||% md[["counts"]]))
    nf <- suppressWarnings(as.numeric(md[["nFeature_RNA"]] %||% md[["nFeature"]] %||% md[["features"]]))
    tf <- .transform_xy_for_space(nc, nf, mode)
    valid <- tf$valid

    if (!any(valid)) {
      cur_ca <- suppressWarnings(as.numeric(input$qc_coeff_a %||% NA_real_))
      cur_cb <- suppressWarnings(as.numeric(input$qc_coeff_b %||% NA_real_))
      cur_a <- suppressWarnings(as.numeric(input$qc_upper_a %||% NA_real_))
      cur_b <- suppressWarnings(as.numeric(input$qc_lower_b %||% NA_real_))
      use_ca <- if (is.finite(cur_ca)) cur_ca else 1
      use_cb <- if (is.finite(cur_cb)) cur_cb else 0.5
      use_a <- if (is.finite(cur_a)) cur_a else 0
      use_b <- if (is.finite(cur_b)) cur_b else 0
      updateSliderInput(session, "qc_coeff_a", label = label_coeff_a, min = 0, max = 3, step = 0.01)
      updateSliderInput(session, "qc_coeff_b", label = label_coeff_b, min = 0, max = 3, step = 0.01)
      updateSliderInput(session, "qc_upper_a", label = label_upper_a, min = -5, max = 10, step = 0.01)
      updateSliderInput(session, "qc_lower_b", label = label_lower_b, min = -5, max = 10, step = 0.01)
      return(invisible(list(coeff_a = use_ca, coeff_b = use_cb, a = use_a, b = use_b)))
    }

    x <- tf$x[valid]
    y <- tf$y[valid]
    xr <- range(x, na.rm = TRUE)
    yr <- range(y, na.rm = TRUE)
    dx <- max(1e-6, diff(xr))
    dy <- max(1e-6, diff(yr))
    slope_guess <- max(0.01, dy / dx)
    slope_max <- max(1.5, slope_guess * 3)
    y_pad <- max(0.2, dy * 0.3)
    b_min <- yr[1] - y_pad
    b_max <- yr[2] + y_pad
    if (identical(mode, "saturating")) {
      slope_max <- 2
      c_up_def <- 1.10
      c_lo_def <- 0.90
      b_min <- -max(50, dy * 0.5)
      b_max <- max(50, dy * 0.5)
      b_up_def <- 0
      b_lo_def <- 0
    } else {
      c_up_def <- min(slope_max, slope_guess * 1.1)
      c_lo_def <- min(slope_max, max(0, slope_guess * 0.6))
      b_up_def <- yr[2] - c_up_def * xr[2]
      b_lo_def <- yr[1] - c_lo_def * xr[1]
    }

    cur_ca <- suppressWarnings(as.numeric(input$qc_coeff_a %||% NA_real_))
    cur_cb <- suppressWarnings(as.numeric(input$qc_coeff_b %||% NA_real_))
    cur_a <- suppressWarnings(as.numeric(input$qc_upper_a %||% NA_real_))
    cur_b <- suppressWarnings(as.numeric(input$qc_lower_b %||% NA_real_))
    use_ca <- if (!reset_values && is.finite(cur_ca)) min(slope_max, max(0, cur_ca)) else c_up_def
    use_cb <- if (!reset_values && is.finite(cur_cb)) min(slope_max, max(0, cur_cb)) else c_lo_def
    use_a <- if (!reset_values && is.finite(cur_a)) min(b_max, max(b_min, cur_a)) else b_up_def
    use_b <- if (!reset_values && is.finite(cur_b)) min(b_max, max(b_min, cur_b)) else b_lo_def

    updateSliderInput(session, "qc_coeff_a",
      label = label_coeff_a,
      min = 0, max = slope_max, value = use_ca, step = 0.01
    )
    updateSliderInput(session, "qc_coeff_b",
      label = label_coeff_b,
      min = 0, max = slope_max, value = use_cb, step = 0.01
    )
    updateSliderInput(session, "qc_upper_a",
      label = label_upper_a,
      min = b_min, max = b_max, value = use_a, step = 0.01
    )
    updateSliderInput(session, "qc_lower_b",
      label = label_lower_b,
      min = b_min, max = b_max, value = use_b, step = 0.01
    )
    invisible(list(coeff_a = use_ca, coeff_b = use_cb, a = use_a, b = use_b))
  }

  .compute_regression_traces <- function(xvec, yvec, choice = "none", n_points = 220L, sat_fit = NULL) {
    choice <- as.character(choice %||% "none")
    if (identical(choice, "none")) return(list())

    valid <- is.finite(xvec) & is.finite(yvec) & (xvec >= 0)
    if (sum(valid) < 10) return(list())
    x <- as.numeric(xvec[valid]); y <- as.numeric(yvec[valid])
    xg <- seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE), length.out = max(60L, as.integer(n_points)))
    xg <- xg[is.finite(xg) & (xg >= 0)]
    if (!length(xg)) return(list())

    mk_trace <- function(name, xx, yy, color) {
      idx <- is.finite(xx) & is.finite(yy)
      if (!any(idx)) return(NULL)
      list(
        name = name,
        x = xx[idx],
        y = yy[idx],
        mode = "lines",
        type = "scatter",
        line = list(width = 2, color = color, dash = "dash"),
        hovertemplate = paste0(name, "<extra></extra>"),
        showlegend = TRUE
      )
    }

    traces <- list()
    want <- if (identical(choice, "all")) c("log", "power", "saturating") else choice

    if ("log" %in% want) {
      fit <- tryCatch(stats::lm(y ~ log10(x + 1)), error = function(e) NULL)
      if (!is.null(fit)) {
        yhat <- tryCatch(stats::predict(fit, newdata = data.frame(x = xg)), error = function(e) rep(NA_real_, length(xg)))
        tr <- mk_trace("Log model", xg, yhat, "rgba(31,119,180,0.95)")
        if (!is.null(tr)) traces[[length(traces) + 1L]] <- tr
      }
    }

    if ("power" %in% want) {
      valid_p <- is.finite(y) & (y >= 0)
      if (sum(valid_p) >= 10) {
        xp <- x[valid_p]
        yp <- y[valid_p]
        fit <- tryCatch(stats::lm(log10(yp + 1) ~ log10(xp + 1)), error = function(e) NULL)
        if (!is.null(fit)) {
          pred <- tryCatch(stats::predict(fit, newdata = data.frame(xp = xg)), error = function(e) rep(NA_real_, length(xg)))
          yhat <- pmax(0, 10^pred - 1)
          tr <- mk_trace("Power-law model", xg, yhat, "rgba(255,127,14,0.95)")
          if (!is.null(tr)) traces[[length(traces) + 1L]] <- tr
        }
      }
    }

    if ("saturating" %in% want) {
      sat <- sat_fit
      if (is.null(sat)) sat <- .compute_saturating_fit(x, y)
      if (!is.null(sat)) {
        yhat <- sat$predict(xg)
        tr <- mk_trace("Saturating model", xg, yhat, "rgba(214,39,40,0.95)")
        if (!is.null(tr)) traces[[length(traces) + 1L]] <- tr
      }
    }

    traces
  }

  .build_qc_scatter_plot <- function(ctx, regression_choice = "none") {
    x_raw <- ctx$ms$nc
    y_raw <- ctx$ms$nf
    slope_space <- .selected_slope_space()
    tf <- .transform_xy_for_space(x_raw, y_raw, slope_space)
    xvec <- tf$x
    yvec <- tf$y
    keep <- as.logical(ctx$ms$keep %||% FALSE)
    if (length(keep) != length(xvec)) keep <- rep(FALSE, length(xvec))
    keep[is.na(keep)] <- FALSE

    valid_all <- tf$valid
    valid_keep <- keep & valid_all
    n_all <- sum(valid_all, na.rm = TRUE)
    n_keep <- sum(valid_keep, na.rm = TRUE)

    r_all <- if (sum(valid_all, na.rm = TRUE) >= 3) suppressWarnings(stats::cor(xvec[valid_all], yvec[valid_all], method = "pearson")) else NA_real_
    r_keep <- if (sum(valid_keep, na.rm = TRUE) >= 3) suppressWarnings(stats::cor(xvec[valid_keep], yvec[valid_keep], method = "pearson")) else NA_real_
    r_all_txt <- if (is.finite(r_all)) sprintf("Unfiltered Pearson r = %.3f", r_all) else "Unfiltered Pearson r = NA"
    r_keep_txt <- if (is.finite(r_keep)) sprintf("Filtered Pearson r = %.3f", r_keep) else "Filtered Pearson r = NA"
    n_keep_txt <- sprintf("Filtered cells: %s / %s", format(n_keep, big.mark = ","), format(n_all, big.mark = ","))

    corr_ann <- list(
      list(x = 0.98, y = 0.28, xref = "paper", yref = "paper", xanchor = "right", yanchor = "bottom", text = r_all_txt, showarrow = FALSE, font = list(size = 13, color = "rgba(120,120,120,0.95)")),
      list(x = 0.98, y = 0.23, xref = "paper", yref = "paper", xanchor = "right", yanchor = "bottom", text = r_keep_txt, showarrow = FALSE, font = list(size = 13, color = "rgba(36,160,72,1)")),
      list(x = 0.98, y = 0.18, xref = "paper", yref = "paper", xanchor = "right", yanchor = "bottom", text = n_keep_txt, showarrow = FALSE, font = list(size = 13, color = "rgba(36,160,72,1)"))
    )

    sat_fit_ctx <- ctx$ms$sat_fit %||% NULL
    reg_traces <- .compute_regression_traces(x_raw, y_raw, choice = regression_choice, sat_fit = sat_fit_ctx)
    sat_filter_traces <- list()

    rng_pad <- function(v, pad = 0.02) {
      v <- v[is.finite(v)]
      if (!length(v)) return(c(0, 1))
      r <- range(v)
      w <- diff(r)
      if (!is.finite(w) || w == 0) w <- abs(r[1]) * 0.1 + 1
      c(r[1] - w * pad, r[2] + w * pad)
    }

    .num1 <- function(v, default = NA_real_) {
      y <- suppressWarnings(as.numeric(v))
      if (length(y) != 1 || !is.finite(y)) return(default)
      y
    }

    seg <- function(m, b, xr, yr) {
      m <- .num1(m, NA_real_)
      b <- .num1(b, NA_real_)
      if (!is.finite(m) || !is.finite(b)) return(NULL)
      if (isTRUE(all.equal(m, 0))) return(list(type = "line", x0 = xr[1], x1 = xr[2], y0 = b, y1 = b, line = list(dash = "dash", width = 1, color = "#888")))
      x0 <- max(xr[1], (yr[1] - b) / m)
      x1 <- min(xr[2], (yr[2] - b) / m)
      if (x1 < x0) return(NULL)
      list(type = "line", x0 = x0, x1 = x1, y0 = m * x0 + b, y1 = m * x1 + b, line = list(dash = "dash", width = 1, color = "#888"))
    }

    th <- ctx$th
    min_umi <- .transform_x_threshold(.num1(th$min_umi, NA_real_), slope_space)
    max_umi <- .transform_x_threshold(.num1(th$max_umi, NA_real_), slope_space)
    min_features <- .transform_y_threshold(.num1(th$min_features, NA_real_), slope_space)
    max_features <- .transform_y_threshold(.num1(th$max_features, NA_real_), slope_space)

    x_candidates <- xvec[valid_all]
    y_candidates <- yvec[valid_all]

    if (length(reg_traces)) {
      for (tr in reg_traces) {
        tr_tf <- .transform_xy_for_space(tr$x, tr$y, slope_space)
        idx_tr <- which(tr_tf$valid)
        if (!length(idx_tr)) next
        x_candidates <- c(x_candidates, tr_tf$x[idx_tr])
        y_candidates <- c(y_candidates, tr_tf$y[idx_tr])
      }
    }

    if (identical(slope_space, "saturating")) {
      sat <- sat_fit_ctx
      if (is.null(sat)) sat <- .compute_saturating_fit(x_raw, y_raw)
      if (!is.null(sat)) {
        x_line_raw <- seq(max(1, min(x_raw[is.finite(x_raw)], na.rm = TRUE)), max(x_raw[is.finite(x_raw)], na.rm = TRUE), length.out = 220L)
        y_base <- sat$predict(x_line_raw)
        c_up <- .num1(th$coeff_a, 1.10)
        c_lo <- .num1(th$coeff_b, 0.90)
        b_up <- .num1(th$a, 0)
        b_lo <- .num1(th$b, 0)
        y_up <- c_up * y_base + b_up
        y_lo <- c_lo * y_base + b_lo
        tr_up <- .transform_xy_for_space(x_line_raw, y_up, slope_space)
        tr_lo <- .transform_xy_for_space(x_line_raw, y_lo, slope_space)
        idx_up <- which(tr_up$valid)
        idx_lo <- which(tr_lo$valid)
        if (length(idx_up)) {
          sat_filter_traces[[length(sat_filter_traces) + 1L]] <- list(
            name = "Upper filter",
            x = tr_up$x[idx_up],
            y = tr_up$y[idx_up],
            mode = "lines",
            type = "scatter",
            line = list(width = 1.5, color = "rgba(120,120,120,0.95)", dash = "dash")
          )
          x_candidates <- c(x_candidates, tr_up$x[idx_up])
          y_candidates <- c(y_candidates, tr_up$y[idx_up])
        }
        if (length(idx_lo)) {
          sat_filter_traces[[length(sat_filter_traces) + 1L]] <- list(
            name = "Lower filter",
            x = tr_lo$x[idx_lo],
            y = tr_lo$y[idx_lo],
            mode = "lines",
            type = "scatter",
            line = list(width = 1.5, color = "rgba(120,120,120,0.95)", dash = "dash")
          )
          x_candidates <- c(x_candidates, tr_lo$x[idx_lo])
          y_candidates <- c(y_candidates, tr_lo$y[idx_lo])
        }
      }
    }

    # Autoscale from data + model/envelope traces only.
    # Threshold guide lines are overlays and should not force huge empty axes.

    xr <- rng_pad(x_candidates, 0.04)
    yr <- rng_pad(y_candidates, 0.08)
    # Extra display headroom so dashed guides/overlays do not appear clipped.
    # Keep this purely visual; filtering logic is unchanged.
    xw <- diff(xr); if (!is.finite(xw) || xw <= 0) xw <- 1
    yw <- diff(yr); if (!is.finite(yw) || yw <= 0) yw <- 1
    if (identical(slope_space, "logx") || identical(slope_space, "loglog")) {
      xr <- c(xr[1] - 0.10 * xw, xr[2] + 0.04 * xw)
      yr <- c(yr[1] - 0.03 * yw, yr[2] + 0.20 * yw)
    } else {
      xr <- c(xr[1] - 0.02 * xw, xr[2] + 0.02 * xw)
      yr <- c(yr[1] - 0.04 * yw, yr[2] + 0.08 * yw)
    }

    # Keep true left/bottom data visible. In log modes, avoid forcing a zero
    # origin because that creates large empty left space and a clipped-looking wall.
    x_data_min <- suppressWarnings(min(xvec[valid_all], na.rm = TRUE))
    y_data_min <- suppressWarnings(min(yvec[valid_all], na.rm = TRUE))
    if (is.finite(x_data_min)) xr[1] <- min(xr[1], x_data_min - 0.02 * xw)
    if (is.finite(y_data_min)) yr[1] <- min(yr[1], y_data_min - 0.02 * yw)
    xr[1] <- min(xr[1], 0)
    yr[1] <- min(yr[1], 0)
    if (!is.finite(xr[2]) || xr[2] <= xr[1]) xr[2] <- xr[1] + 1
    if (!is.finite(yr[2]) || yr[2] <= yr[1]) yr[2] <- yr[1] + 1

    xw_shape <- diff(xr); if (!is.finite(xw_shape) || xw_shape <= 0) xw_shape <- 1
    yw_shape <- diff(yr); if (!is.finite(yw_shape) || yw_shape <= 0) yw_shape <- 1
    shape_inset <- if (identical(slope_space, "logx") || identical(slope_space, "loglog")) 0.060 else 0.025
    xr_shape <- c(xr[1] + shape_inset * xw_shape, xr[2] - shape_inset * xw_shape)
    yr_shape <- c(yr[1] + shape_inset * yw_shape, yr[2] - shape_inset * yw_shape)
    if (!is.finite(xr_shape[1]) || !is.finite(xr_shape[2]) || xr_shape[2] <= xr_shape[1]) xr_shape <- xr
    if (!is.finite(yr_shape[1]) || !is.finite(yr_shape[2]) || yr_shape[2] <= yr_shape[1]) yr_shape <- yr

    shapes <- Filter(Negate(is.null), list(
      if (is.finite(min_umi)) list(type = "line", x0 = min_umi, x1 = min_umi, y0 = yr_shape[1], y1 = yr_shape[2], line = list(dash = "dash", width = 1, color = "#888")) else NULL,
      if (is.finite(max_umi)) list(type = "line", x0 = max_umi, x1 = max_umi, y0 = yr_shape[1], y1 = yr_shape[2], line = list(dash = "dash", width = 1, color = "#888")) else NULL,
      if (is.finite(min_features)) list(type = "line", y0 = min_features, y1 = min_features, x0 = xr_shape[1], x1 = xr_shape[2], line = list(dash = "dash", width = 1, color = "#888")) else NULL,
      if (is.finite(max_features)) list(type = "line", y0 = max_features, y1 = max_features, x0 = xr_shape[1], x1 = xr_shape[2], line = list(dash = "dash", width = 1, color = "#888")) else NULL,
      if (!identical(slope_space, "saturating")) seg(th$coeff_b, th$b, xr_shape, yr_shape) else NULL,
      if (!identical(slope_space, "saturating")) seg(th$coeff_a, th$a, xr_shape, yr_shape) else NULL
    ))

    if (identical(slope_space, "loglog")) {
      x_title <- "log10(nCount_RNA + 1)"
      y_title <- "log10(nFeature_RNA + 1)"
    } else if (identical(slope_space, "logx")) {
      x_title <- "log10(nCount_RNA + 1)"
      y_title <- UI_TEXT$t_text_nfeature_rna %||% "nFeature_RNA"
    } else {
      x_title <- UI_TEXT$t_text_ncount_rna %||% "nCount_RNA"
      y_title <- UI_TEXT$t_text_nfeature_rna %||% "nFeature_RNA"
    }

    show_reg_legend <- length(reg_traces) > 0

    idx_drop <- which(valid_all & !keep)
    idx_keep <- which(valid_all & keep)
    p <- plotly::plot_ly(type = "scattergl", mode = "markers") |>
      plotly::add_trace(x = xvec[idx_drop], y = yvec[idx_drop], marker = list(size = 4, color = "rgba(150,150,150,0.35)"), hoverinfo = "skip", showlegend = FALSE) |>
      plotly::add_trace(x = xvec[idx_keep], y = yvec[idx_keep], marker = list(size = 4, color = "rgba(36,160,72,0.95)", opacity = 0.9), showlegend = FALSE)

    if (show_reg_legend) {
      for (tr in reg_traces) {
        tr_tf <- .transform_xy_for_space(tr$x, tr$y, slope_space)
        idx_tr <- which(tr_tf$valid)
        if (!length(idx_tr)) next
        p <- p |>
          plotly::add_trace(
            x = tr_tf$x[idx_tr],
            y = tr_tf$y[idx_tr],
            type = tr$type %||% "scatter",
            mode = tr$mode %||% "lines",
            name = tr$name %||% "",
            line = tr$line %||% list(width = 2),
            hovertemplate = tr$hovertemplate %||% "<extra></extra>",
            showlegend = TRUE,
            inherit = FALSE
          )
      }
    }
    if (length(sat_filter_traces)) {
      for (tr in sat_filter_traces) {
        p <- p |>
          plotly::add_trace(
            x = tr$x, y = tr$y, type = tr$type, mode = tr$mode,
            line = tr$line, hoverinfo = "skip", showlegend = FALSE, inherit = FALSE
          )
      }
    }

    p |>
      plotly::layout(
        xaxis = list(title = list(text = x_title, standoff = 12), range = xr, automargin = TRUE),
        yaxis = list(title = list(text = y_title, standoff = 10), range = yr, automargin = TRUE),
        shapes = shapes,
        annotations = corr_ann,
        legend = list(orientation = "h", x = 0.01, y = 1.10, bgcolor = "rgba(255,255,255,0.7)"),
        margin = list(l = 84, r = 40, t = if (show_reg_legend) 60 else 30, b = 88)
      ) |>
      plotly::config(displaylogo = FALSE)
  }

  .build_qc_plot_bundle <- function(sample_name = NULL, object_key = NULL, use_input_thresholds = FALSE) {
    tryCatch({
    df_tab <- .ensure_qc_table_cols(isolate(qc_table_data()))
    if (is.null(df_tab) || !nrow(df_tab)) {
      .set_qc_diag("qc_table_data is empty.")
      return(NULL)
    }
    .first_nonempty <- function(...) {
      vals <- unlist(list(...), use.names = FALSE)
      vals <- as.character(vals %||% character(0))
      vals <- vals[nzchar(trimws(vals))]
      if (length(vals)) vals[[1]] else ""
    }
    selected_sample <- as.character(isolate(input$qc_view_object_name) %||% "")
    nm <- .first_nonempty(
      sample_name,
      selected_sample,
      isolate(qc_current_threshold_sample()),
      isolate(active_name()),
      as.character(df_tab$name[[1]] %||% "")
    )
    if (!nzchar(nm)) nm <- as.character(df_tab$name[[1]] %||% "")
    # Always align threshold source row with selected viewer object key.
    key_col <- if ("source_object" %in% colnames(df_tab)) "source_object" else "name"
    i_key <- .match_threshold_row(df_tab, key = nm, active = nm)
    if (.row_is_excluded(df_tab, i_key)) i_key <- .first_included_row(df_tab)
    if (!is.na(i_key)) nm <- as.character(df_tab$name[[i_key]])
    reg <- isolate(shared_data$all_seurat_objects %||% list())
    if (!length(reg)) {
      .set_qc_diag("shared_data$all_seurat_objects is empty.")
      return(NULL)
    }
    key <- .first_nonempty(
      object_key,
      .resolve_object_key_for_sample(nm, df = df_tab, reg = reg),
      if (!is.na(i_key) && i_key >= 1 && i_key <= nrow(df_tab)) as.character(df_tab[[key_col]][[i_key]] %||% "") else "",
      isolate(viewer_object_name()),
      nm
    )
    entry <- reg[[key]]
    if (is.null(entry)) {
      i <- match(key, as.character(df_tab[[key_col]]))
      if (is.na(i)) i <- match(key, as.character(df_tab$name))
      if (!is.na(i)) {
        nm2 <- as.character(df_tab$name[[i]])
        src_key <- as.character(df_tab[[key_col]][[i]] %||% "")
        if (nzchar(src_key) && !is.null(reg[[src_key]])) {
          key <- src_key
          nm <- nm2
          entry <- reg[[key]]
        } else if (!is.null(reg[[nm2]])) {
          key <- nm2
          nm <- nm2
          entry <- reg[[key]]
        }
      }
    }
    if (is.null(entry)) {
      best <- .pick_best_entry_name(nm, reg)
      if (!is.null(reg[[best]])) {
        key <- best
        entry <- reg[[best]]
      } else if (!is.null(reg[[nm]])) {
        key <- nm
        entry <- reg[[nm]]
      }
    }
    if (is.null(entry)) {
      .set_qc_diag(
        "No registry entry for selected key/sample.\n",
        "sample_name=", nm, " | object_key=", key, "\n",
        "registry_names=", paste(head(names(reg), 20), collapse = ", ")
      )
      return(NULL)
    }
    sobj <- .unwrap_seurat_candidate(entry)
    if (!inherits(sobj, "Seurat")) {
      .set_qc_diag(
        "Selected registry entry is not a Seurat object.\n",
        "sample_name=", nm, " | object_key=", key, "\n",
        "entry_class=", paste(class(entry), collapse = "/")
      )
      .qc_log(
        "[QC] .build_qc_plot_bundle: non-Seurat entry for key=",
        key,
        " class=", paste(class(entry), collapse = "/")
      )
      return(NULL)
    }
    sobj_class <- paste(class(sobj), collapse = "/")
    assay_names0 <- tryCatch(as.character(names(sobj@assays)), error = function(e) character(0))
    md0 <- tryCatch({
      m <- sobj@meta.data
      if (!is.data.frame(m)) data.frame(stringsAsFactors = FALSE) else m
    }, error = function(e) data.frame(stringsAsFactors = FALSE))
    .qc_log(
      "[QC] .build_qc_plot_bundle request: sample=", nm,
        " key=", key,
        " sobj_class=", sobj_class,
      " assays=[", paste(assay_names0, collapse = ","), "]",
      " md_nrow=", nrow(md0),
      " md_ncol=", ncol(md0)
    )
    md <- .ensure_qc_md(sobj)
    if (is.null(md) || !nrow(md)) {
      assay_names <- assay_names0
      .qc_log(
        "[QC] .build_qc_plot_bundle: metadata unavailable for object_key=",
        key,
        " sample_name=", nm,
        " assays=[", paste(assay_names, collapse = ","), "]"
      )
      .set_qc_diag(
        "Failed to build QC metadata.\n",
        "sample_name=", nm, " | object_key=", key, "\n",
        "object_class=", sobj_class, "\n",
        "assays=[", paste(assay_names, collapse = ","), "]\n",
        "meta_nrow=", nrow(md0), " | meta_cols=[", paste(head(colnames(md0), 30), collapse = ","), "]"
      )
      return(NULL)
    }
    .set_qc_diag("")
    mode_locked <- isTRUE(isolate(qc_mode_pending()))
    th <- .get_thresholds(nm)
    slope_space <- as.character(isolate(qc_committed_slope_space()) %||% .selected_slope_space())
    sat_fit <- NULL
    if (identical(slope_space, "saturating")) {
      sat_fit <- .compute_saturating_fit(
        suppressWarnings(as.numeric(md[["nCount_RNA"]])),
        suppressWarnings(as.numeric(md[["nFeature_RNA"]]))
      )
    }
    ms <- mask_points(md, th, slope_space = slope_space, sat_fit = sat_fit)
    list(sample_name = nm, object_key = key, md = md, th = th, ms = ms)
    }, error = function(e) {
      .set_qc_diag(
        "QC bundle error: ", conditionMessage(e), "\n",
        "sample_name=", sample_name %||% "", " | object_key=", object_key %||% ""
      )
      .qc_log("[QC] .build_qc_plot_bundle ERROR: ", conditionMessage(e))
      NULL
    })
  }

  .warmup_qc_plots <- function(sample_name = NULL, object_key = NULL, use_input_thresholds = FALSE) {
    ctx <- tryCatch(
      .build_qc_plot_bundle(sample_name = sample_name, object_key = object_key, use_input_thresholds = use_input_thresholds),
      error = function(e) {
        .qc_log("[QC] warmup bundle error: ", conditionMessage(e))
        NULL
      }
    )
    if (is.null(ctx)) return(invisible(NULL))
    key_nf <- .qc_cache_key("vln_nfeature", ctx$object_key, ctx$md, ctx$th)
    key_nc <- .qc_cache_key("vln_ncount", ctx$object_key, ctx$md, ctx$th)
    key_mt <- .qc_cache_key("vln_mt", ctx$object_key, ctx$md, ctx$th)
    reg_choice <- isolate(.selected_regression_overlay())
    key_sc <- .qc_cache_key("scatter_main", ctx$object_key, ctx$md, ctx$th, extra = reg_choice)

    if (is.null(.qc_cache_get(key_nf))) {
      p <- tryCatch(
        build_violin_with_dots(
          ctx$ms$nf, "nFeature_RNA",
          dots = "normal", violin_scale = "count", vln_ticks = "auto",
          seam = "classic", mask = ctx$ms$keep, th = ctx$th
        ),
        error = function(e) .qc_error_plot(conditionMessage(e), "", "nFeature_RNA")
      )
      .qc_cache_set(key_nf, p %||% .qc_error_plot("no finite nFeature values", "", "nFeature_RNA"))
    }
    if (is.null(.qc_cache_get(key_nc))) {
      p <- tryCatch(
        build_violin_with_dots(
          ctx$ms$nc, "nCount_RNA",
          dots = "normal", violin_scale = "count", vln_ticks = "auto",
          seam = "classic", mask = ctx$ms$keep, th = ctx$th
        ),
        error = function(e) .qc_error_plot(conditionMessage(e), "", "nCount_RNA")
      )
      .qc_cache_set(key_nc, p %||% .qc_error_plot("no finite nCount values", "", "nCount_RNA"))
    }
    if (is.null(.qc_cache_get(key_mt))) {
      p <- tryCatch(
        build_violin_with_dots(
          ctx$ms$mt, "percent.mt",
          dots = "normal", violin_scale = "count", vln_ticks = "auto",
          seam = "classic", mask = ctx$ms$keep, th = ctx$th
        ),
        error = function(e) .qc_error_plot(conditionMessage(e), "", "percent.mt")
      )
      .qc_cache_set(key_mt, p %||% .qc_error_plot("no finite percent.mt values", "", "percent.mt"))
    }
    if (is.null(.qc_cache_get(key_sc))) {
      p_sc <- .build_qc_scatter_plot(ctx, regression_choice = reg_choice)
      .qc_cache_set(key_sc, p_sc)
    }
    invisible(NULL)
  }
  
  output$qc_scatter_main <- renderPlotly({
    if (!identical(input$main_navbar %||% "", "qc_tab")) {
      return(
        plot_ly() %>%
          add_trace(type = "scattergl", mode = "markers", x = numeric(0), y = numeric(0), hoverinfo = "skip", showlegend = FALSE) %>%
          layout(xaxis = list(visible = FALSE), yaxis = list(visible = FALSE), margin = list(l = 0, r = 0, t = 0, b = 0))
      )
    }
    render_epoch <- qc_render_epoch()
    tryCatch({
      viewer_object_name()
      pending <- isTRUE(qc_render_pending())
      if (pending) {
        .ensure_qc_render_overlay("Recalculating QC plots...")
        render_epoch <- isolate(qc_render_epoch())
      }
      ctx <- .build_qc_plot_bundle(use_input_thresholds = TRUE)
      if (is.null(ctx)) {
        .mark_qc_output_ready("qc_scatter_main", epoch = render_epoch)
        return(.qc_error_plot(
          paste0("missing QC metadata for selected object. ", qc_diag_text() %||% ""),
          UI_TEXT$t_text_ncount_rna, UI_TEXT$t_text_nfeature_rna
        ))
      }
      reg_choice <- .selected_regression_overlay()
      key <- .qc_cache_key("scatter_main", ctx$object_key, ctx$md, ctx$th, extra = reg_choice)
      cached <- .qc_cache_get(key)
      if (!pending && !is.null(cached)) {
        .mark_qc_output_ready("qc_scatter_main", epoch = render_epoch)
        return(cached)
      }
      p <- .build_qc_scatter_plot(ctx, regression_choice = reg_choice)
      .qc_cache_set(key, p)
      .mark_qc_output_ready("qc_scatter_main", epoch = render_epoch)
      p
    }, error = function(e) {
      .qc_log("[QC] scatter render error: ", conditionMessage(e))
      .mark_qc_output_ready("qc_scatter_main", epoch = render_epoch)
      .qc_error_plot(conditionMessage(e), UI_TEXT$t_text_ncount_rna, UI_TEXT$t_text_nfeature_rna)
    })
  })

  .sanitize_export_stem <- function(x) {
    x <- as.character(x %||% "")
    x <- gsub("[^A-Za-z0-9._-]+", "_", x)
    x <- gsub("_+", "_", x)
    x <- gsub("^_+|_+$", "", x)
    if (!nzchar(x)) "qc_report" else x
  }

  .write_plot_widget <- function(p, file, title = "QC plot") {
    w <- if (inherits(p, "htmlwidget")) p else plotly::as_widget(p)
    htmlwidgets::saveWidget(w, file = file, selfcontained = FALSE, title = title)
    invisible(file)
  }

  output$qc_download_report_btn <- downloadHandler(
    filename = function() {
      paste0(
        .sanitize_export_stem(paste("qc_filter_records_non_excluded", format(Sys.time(), "%Y%m%d_%H%M%S"), sep = "_")),
        ".zip"
      )
    },
    content = function(file) {
      .show_qc_overlay("Preparing QC export records package…")
      on.exit(.hide_qc_overlay(), add = TRUE)
      df <- .ensure_qc_table_cols(isolate(qc_table_data()))
      if (is.null(df) || !nrow(df)) stop("QC record export failed: no samples available.")
      excluded <- as.logical(df$excluded_from_final %||% FALSE)
      excluded[is.na(excluded)] <- FALSE
      keep_idx <- which(!excluded)
      if (!length(keep_idx)) stop("QC record export failed: no non-excluded samples to export.")
      export_df <- df[keep_idx, , drop = FALSE]
      reg_choice <- isolate(.selected_regression_overlay())
      slope_space <- isolate(.selected_slope_space())
      report_dir <- file.path(tempdir(), paste0("qc_filter_records_", as.integer(as.numeric(Sys.time()))))
      dir.create(report_dir, recursive = TRUE, showWarnings = FALSE)
      plot_dir <- file.path(report_dir, "plots")
      dir.create(plot_dir, recursive = TRUE, showWarnings = FALSE)

      rows <- lapply(seq_len(nrow(export_df)), function(i) {
        sample_name <- as.character(export_df$name[[i]] %||% "")
        source_key <- as.character(export_df$source_object[[i]] %||% sample_name)
        th <- .get_thresholds(sample_name)
        data.frame(
          sample_name = sample_name,
          source_object = source_key,
          regression_overlay = reg_choice,
          slope_space = slope_space,
          min_features = th$min_features %||% NA_real_,
          max_features = th$max_features %||% NA_real_,
          min_umi = th$min_umi %||% NA_real_,
          max_umi = th$max_umi %||% NA_real_,
          max_mt = th$max_mt %||% NA_real_,
          coeff_a = th$coeff_a %||% NA_real_,
          a = th$a %||% NA_real_,
          coeff_b = th$coeff_b %||% NA_real_,
          b = th$b %||% NA_real_,
          use_in_analysis = as.logical(export_df$use_in_analysis[[i]] %||% FALSE),
          qc_status = as.character(export_df$qc_status[[i]] %||% ""),
          excluded_from_final = FALSE,
          stringsAsFactors = FALSE
        )
      })
      th_df <- do.call(rbind, rows)
      utils::write.csv(th_df, file.path(report_dir, "qc_filter_records_non_excluded.csv"), row.names = FALSE)

      export_fail <- list()
      for (i in seq_len(nrow(export_df))) {
        sample_name <- as.character(export_df$name[[i]] %||% "")
        source_key <- as.character(export_df$source_object[[i]] %||% sample_name)
        tryCatch({
          ctx <- .build_qc_plot_bundle(sample_name = sample_name, object_key = source_key, use_input_thresholds = FALSE)
          if (is.null(ctx)) stop("Unable to build QC context for this sample/object.")

          sample_stem <- .sanitize_export_stem(ctx$sample_name %||% sample_name)
          obj_stem <- .sanitize_export_stem(ctx$object_key %||% source_key)
          mode_stem <- .sanitize_export_stem(reg_choice %||% "none")
          sample_plot_dir <- file.path(plot_dir, paste0(sample_stem, "__", obj_stem))
          dir.create(sample_plot_dir, recursive = TRUE, showWarnings = FALSE)

          p_sc <- .build_qc_scatter_plot(ctx, regression_choice = reg_choice)
          p_nf <- build_violin_with_dots(ctx$ms$nf, "nFeature_RNA", dots = "normal", violin_scale = "count", vln_ticks = "auto", seam = "classic", mask = ctx$ms$keep, th = ctx$th)
          p_nc <- build_violin_with_dots(ctx$ms$nc, "nCount_RNA", dots = "normal", violin_scale = "count", vln_ticks = "auto", seam = "classic", mask = ctx$ms$keep, th = ctx$th)
          p_mt <- build_violin_with_dots(ctx$ms$mt, "percent.mt", dots = "normal", violin_scale = "count", vln_ticks = "auto", seam = "classic", mask = ctx$ms$keep, th = ctx$th)

          .write_plot_widget(p_sc, file.path(sample_plot_dir, sprintf("qc_scatter_%s_%s_%s.html", sample_stem, obj_stem, mode_stem)), title = "QC scatter")
          .write_plot_widget(p_nf, file.path(sample_plot_dir, sprintf("qc_violin_nFeature_%s_%s.html", sample_stem, obj_stem)), title = "QC violin nFeature_RNA")
          .write_plot_widget(p_nc, file.path(sample_plot_dir, sprintf("qc_violin_nCount_%s_%s.html", sample_stem, obj_stem)), title = "QC violin nCount_RNA")
          .write_plot_widget(p_mt, file.path(sample_plot_dir, sprintf("qc_violin_percent_mt_%s_%s.html", sample_stem, obj_stem)), title = "QC violin percent.mt")

          layer_df <- data.frame(
            cell = rownames(ctx$md),
            nCount_RNA = suppressWarnings(as.numeric(ctx$ms$nc)),
            nFeature_RNA = suppressWarnings(as.numeric(ctx$ms$nf)),
            percent_mt = suppressWarnings(as.numeric(ctx$ms$mt)),
            layer = ifelse(as.logical(ctx$ms$keep %||% FALSE), "filtered", "unfiltered"),
            stringsAsFactors = FALSE
          )
          utils::write.csv(layer_df, file.path(sample_plot_dir, sprintf("qc_point_layers_%s_%s.csv", sample_stem, obj_stem)), row.names = FALSE)
        }, error = function(e) {
          export_fail[[length(export_fail) + 1L]] <<- data.frame(
            sample_name = sample_name,
            source_object = source_key,
            reason = conditionMessage(e),
            stringsAsFactors = FALSE
          )
          invisible(NULL)
        })
      }
      if (length(export_fail)) {
        fail_df <- do.call(rbind, export_fail)
        utils::write.csv(fail_df, file.path(report_dir, "qc_export_plot_failures.csv"), row.names = FALSE)
      }

      summary_df <- data.frame(
        exported_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
        non_excluded_sample_count = nrow(export_df),
        plotted_samples = nrow(export_df) - length(export_fail),
        plot_failures = length(export_fail),
        regression_overlay = reg_choice,
        slope_space = slope_space,
        stringsAsFactors = FALSE
      )
      utils::write.csv(summary_df, file.path(report_dir, "qc_filter_records_summary.csv"), row.names = FALSE)

      oldwd <- getwd()
      on.exit(setwd(oldwd), add = TRUE)
      setwd(report_dir)
      zip_files <- list.files(".", recursive = TRUE, all.files = FALSE, include.dirs = FALSE)
      utils::zip(zipfile = file, files = zip_files)
    }
  )

  observeEvent(input$qc_download_report_btn, {
    if (!identical(input$main_navbar %||% "", "qc_tab")) return(invisible(NULL))
    .show_qc_overlay("Preparing QC export records package…")
    invisible(NULL)
  }, ignoreInit = TRUE)
  
  observeEvent(shared_data$all_seurat_objects, {
    .qc_cache_clear()
  }, ignoreInit = TRUE)

  observeEvent(input$main_navbar, {
    if (identical(input$main_navbar %||% "", "qc_tab")) {
      qc_tab_visited(TRUE)
      boot_ok <- isTRUE(.bootstrap_qc_state())
      if (boot_ok) {
        session$onFlushed(function() {
          .queue_qc_recalc(force = FALSE)
        }, once = TRUE)
      } else {
        .hide_qc_overlay()
      }
    }
    invisible(NULL)
  }, ignoreInit = FALSE)

  observeEvent(input$main_navbar, {
    if (identical(input$main_navbar %||% "", "qc_tab")) return(invisible(NULL))
    if (isTRUE(qc_render_pending()) || isTRUE(qc_overlay_on())) {
      .hide_qc_overlay()
      .reset_qc_render_cycle(invalidate = TRUE)
    }
    invisible(NULL)
  }, ignoreInit = TRUE)

  .apply_filter_to_sample <- function(sample_name, th, slope_space = "linear") {
    raw_entry <- shared_data$all_seurat_objects[[sample_name]]
    if (is.null(raw_entry)) return(list(ok = FALSE, reason = "missing_raw"))
    ao <- if (is.list(raw_entry) && !is.null(raw_entry$obj)) raw_entry$obj else raw_entry
    if (is.null(ao) || is.null(ao@meta.data) || !nrow(ao@meta.data)) return(list(ok = FALSE, reason = "empty_meta"))

    md <- ao@meta.data
    ms <- mask_points(md, th, slope_space = slope_space)
    if (!any(ms$keep)) return(list(ok = FALSE, reason = "empty_after_filter"))

    sobj_filtered <- subset(x = ao, cells = rownames(md)[ms$keep])
    sobj_filtered <- wanlab_reset_subset_analysis_state(sobj_filtered)
    reg <- shared_data$all_seurat_objects %||% list()
    make_unique_filtered_name <- function(base_name, registry) {
      root <- if (grepl("_rna_filtered(?:_[0-9]+)?$", base_name, ignore.case = TRUE)) {
        sub("_rna_filtered(?:_[0-9]+)?$", "", base_name, ignore.case = TRUE)
      } else if (grepl("_filtered(?:_[0-9]+)?$", base_name, ignore.case = TRUE)) {
        sub("_filtered(?:_[0-9]+)?$", "", base_name, ignore.case = TRUE)
      } else {
        base_name
      }
      cand <- paste0(root, "_rna_filtered")
      if (is.null(registry[[cand]])) return(cand)
      k <- 2L
      repeat {
        cand_k <- paste0(root, "_rna_filtered_", k)
        if (is.null(registry[[cand_k]])) return(cand_k)
        k <- k + 1L
      }
    }
    filt_name <- make_unique_filtered_name(sample_name, reg)
    parent_name <- if (grepl("(_rna_filtered|_filtered)(?:_[0-9]+)?$", sample_name, ignore.case = TRUE)) {
      raw_entry$meta$parent %||% sample_name
    } else {
      sample_name
    }
    shared_data$all_seurat_objects[[filt_name]] <- list(
      obj   = sobj_filtered,
      prefs = list(),
      plots = list(),
      analysis_cache = list(),
      meta  = list(
        stage   = "filtered",
        parent  = parent_name,
        parents = parent_name,
        params  = list(
          min_features = th$min_features,
          max_features = th$max_features,
          min_umi      = th$min_umi,
          max_umi      = th$max_umi,
          max_mt       = th$max_mt,
          coeff_a      = th$coeff_a, a = th$a,
          coeff_b      = th$coeff_b, b = th$b
        ),
        created = Sys.time()
      )
    )
    list(ok = TRUE, name = filt_name, source = sample_name)
  }

  observeEvent(input$qc_refresh_btn, {
    df <- qc_table_data(); req(df, nrow(df) > 0)
    overlay_show("Applying filters and adding filtered samples to workspace…", loader = "filter")
    on.exit(overlay_hide(), add = TRUE)

    applied <- character(0)
    skipped <- character(0)
    excluded <- character(0)
    key_col <- if ("source_object" %in% colnames(df)) "source_object" else "name"
            slope_space <- .selected_slope_space()
            for (i in seq_len(nrow(df))) {
      nm <- as.character(df$name[[i]])
      if (isTRUE(as.logical(df$excluded_from_final[[i]] %||% FALSE))) {
        excluded <- c(excluded, nm)
        next
      }
      source_key <- as.character(df[[key_col]][[i]])
      th <- read_thresholds(nm)
                res <- .apply_filter_to_sample(source_key, th, slope_space = slope_space)
      if (isTRUE(res$ok)) {
        applied <- c(applied, nm)
        new_name <- as.character(res$name)
        if (!("source_object" %in% colnames(df))) df$source_object <- as.character(df$name)
        df$name[[i]] <- new_name
        df$source_object[[i]] <- new_name
        if ("qc_status" %in% colnames(df)) df$qc_status[[i]] <- "Filtered"
        cache <- threshold_cache()
        cache[[new_name]] <- th
        if (!identical(new_name, nm)) cache[[nm]] <- NULL
        threshold_cache(cache)
        if (identical(active_name(), nm)) {
          active_name(new_name)
          viewer_object_name(new_name)
        }
      } else {
        skipped <- c(skipped, nm)
      }

      df$min_features[[i]]   <- th$min_features
      df$max_features[[i]]   <- th$max_features
      df$min_umi_counts[[i]] <- th$min_umi
      df$max_umi_counts[[i]] <- th$max_umi
      df$max_mt_percent[[i]] <- th$max_mt
    }
    qc_table_data(df)

    if (length(applied)) {
      showNotification(
        sprintf("Applied filters and added %d filtered sample(s) to workspace.", length(applied)),
        type = "message"
      )
    }
    if (length(skipped)) {
      showNotification(
        sprintf("Skipped %d sample(s) because filters produced empty output or raw object was missing.", length(skipped)),
        type = "warning", duration = 8
      )
    }
    if (length(excluded)) {
      showNotification(
        sprintf("Excluded %d sample(s) from final filtering (not processed).", length(excluded)),
        type = "message", duration = 6
      )
    }
  })
  
  
  observeEvent(input$apply_filters_btn, {
    df <- qc_table_data(); req(df, nrow(df) > 0)
    sel <- input$qc_parameter_table_rows_selected
    if (is.null(sel) || length(sel) == 0) sel <- seq_len(nrow(df))

    samples <- .pick_samples_for_analysis(df, sel)
    if (is.null(samples) || !length(samples)) {
      showNotification("No samples resolved from your selection.", type = "error")
      return()
    }
    
    reg <- shared_data$all_seurat_objects
    entry_names <- vapply(samples, .pick_best_entry_name, character(1), registry = reg)
    objs <- lapply(entry_names, function(en) .get_entry_obj(reg[[en]]))
    
    missing_idx <- which(vapply(objs, is.null, logical(1)))
    if (length(missing_idx)) {
      miss <- paste(samples[missing_idx], collapse = ", ")
      showNotification(sprintf("Skipping missing samples: %s", miss), type = "warning", duration = 8)
      keep <- setdiff(seq_along(objs), missing_idx)
      objs <- objs[keep]; entry_names <- entry_names[keep]; samples <- samples[keep]
    }
    if (!length(objs)) {
      showNotification("No valid samples to proceed.", type = "error")
      return()
    }
    
    # QC completed when proceeding to Analysis directly
    shared_data$qc_completed <- TRUE

    # Filtering preserves creation/result order. Landing on newest result
    # keeps startup consistent with the canonical active-object contract.
    shared_data$active_object_name <- entry_names[[length(entry_names)]]
    showNotification(
      sprintf("Filtering complete: %d sample(s) ready. Select one or more objects on the Analysis page.",
              length(entry_names)),
      type = "message"
    )
  })
  
}
