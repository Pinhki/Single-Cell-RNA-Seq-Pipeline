# State-sync contract: read docs/agents/interface/ANALYSIS_STATE_SYNC_CONTRACT.md
# before changing object, tab, selection, plot, or gene-catalog observers.
library(shiny)
library(DT)
library(ggplot2)

`%||%` <- function(a, b) if (!is.null(a)) a else b

.db_get_assay_data <- function(sobj, assay = NULL, layer = "data") {
  aa <- as.character(assay %||% "")
  if (!nzchar(aa)) aa <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
  assay_obj <- tryCatch(if (nzchar(aa)) sobj[[aa]] else NULL, error = function(e) NULL)
  use_layer <- inherits(assay_obj, "Assay5")
  args <- if (isTRUE(use_layer)) {
    list(object = sobj, layer = layer)
  } else {
    list(object = sobj, slot = layer)
  }
  if (nzchar(aa)) args$assay <- aa
  out <- tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
  if (!is.null(out)) return(out)
  alt_args <- list(object = sobj)
  alt_args[[if (isTRUE(use_layer)) "slot" else "layer"]] <- layer
  if (nzchar(aa)) alt_args$assay <- aa
  tryCatch(do.call(Seurat::GetAssayData, alt_args), error = function(e) NULL)
}
.db_get_assay_features <- function(sobj, assay = NULL) {
  aa <- as.character(assay %||% "")
  if (!nzchar(aa)) aa <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
  assays <- tryCatch(as.character(Seurat::Assays(sobj)), error = function(e) character(0))
  if (!nzchar(aa) || !(aa %in% assays)) {
    aa <- assays[[1]] %||% ""
  }
  if (!nzchar(aa)) return(character(0))

  feats <- tryCatch({
    aobj <- sobj[[aa]]
    out <- tryCatch(Seurat::Features(aobj), error = function(e) NULL)
    if (is.null(out) || !length(out)) out <- tryCatch(rownames(aobj), error = function(e) NULL)
    as.character(out %||% character(0))
  }, error = function(e) character(0))

  feats <- unique(feats[nzchar(feats)])
  if (length(feats)) return(feats)

  m <- .db_get_assay_data(sobj, assay = aa, layer = "data")
  if (is.null(m)) m <- .db_get_assay_data(sobj, assay = aa, layer = "counts")
  unique(as.character(rownames(m) %||% character(0)))
}
.db_fetch_feature_values <- function(sobj, feature, cells = NULL, assay = NULL, layer = "data") {
  feature <- as.character(feature %||% "")
  if (!nzchar(feature)) return(numeric(0))
  aa <- as.character(assay %||% "")
  if (!nzchar(aa)) aa <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
  old_assay <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
  on.exit({
    if (nzchar(old_assay)) try(Seurat::DefaultAssay(sobj) <- old_assay, silent = TRUE)
  }, add = TRUE)
  if (nzchar(aa)) try(Seurat::DefaultAssay(sobj) <- aa, silent = TRUE)
  cells <- as.character(cells %||% character(0))

  layer_candidates <- unique(c(as.character(layer %||% "data"), "counts", "scale.data"))
  .signal_ok <- function(v) {
    v <- suppressWarnings(as.numeric(v))
    v <- v[is.finite(v)]
    if (!length(v)) return(FALSE)
    rng <- range(v, na.rm = TRUE)
    is.finite(rng[1]) && is.finite(rng[2]) && (rng[2] - rng[1]) > 0
  }
  first_valid <- numeric(0)
  fd_formals <- tryCatch(names(formals(Seurat::FetchData)), error = function(e) character(0))
  for (ly in layer_candidates) {
    args <- list(object = sobj, vars = feature)
    if (length(cells)) args$cells <- cells
    if ("layer" %in% fd_formals) {
      args$layer <- ly
    } else if ("slot" %in% fd_formals) {
      args$slot <- ly
    }
    fd <- tryCatch(do.call(Seurat::FetchData, args), error = function(e) NULL)
    if (is.data.frame(fd) && nrow(fd)) {
      out <- suppressWarnings(as.numeric(fd[[1L]]))
      if (length(out) == nrow(fd)) {
        if (!length(first_valid)) first_valid <- out
        if (.signal_ok(out)) return(out)
      }
    }
    mat <- .db_get_assay_data(sobj, assay = aa, layer = ly)
    ok_mat <- is.matrix(mat) || inherits(mat, "Matrix")
    if (!is.null(mat) && ok_mat && (feature %in% rownames(mat))) {
      cells_use <- cells
      if (!length(cells_use)) cells_use <- colnames(mat)
      vals <- suppressWarnings(as.numeric(mat[feature, cells_use, drop = TRUE]))
      if (length(vals)) {
        if (!length(first_valid)) first_valid <- vals
        if (.signal_ok(vals)) return(vals)
      }
    }
  }
  first_valid
}

.db_helper_sources <- c(
  "Content/interface/analysis/data_browser_helpers.R",
  "interface/analysis/data_browser_helpers.R",
  "data_browser_helpers.R"
)
.db_helper_source <- .db_helper_sources[file.exists(.db_helper_sources)][1]
if (length(.db_helper_source) && nzchar(.db_helper_source)) {
  source(.db_helper_source, local = FALSE)
}
if (!exists("db_is_effectively_numeric", mode = "function")) {
  db_is_effectively_numeric <- function(x) {
    x_chr <- as.character(x %||% character(0))
    x_chr <- trimws(x_chr)
    x_chr[x_chr %in% c("", "NA", "NaN", "Inf", "-Inf")] <- NA_character_
    keep <- !is.na(x_chr)
    if (!any(keep)) return(FALSE)
    parsed <- suppressWarnings(as.numeric(x_chr[keep]))
    all(is.finite(parsed))
  }
}
if (!exists("db_is_cluster_like_metadata", mode = "function")) {
  db_is_cluster_like_metadata <- function(col_name, x = NULL) {
    nm <- tolower(trimws(as.character(col_name %||% "")))
    if (!nzchar(nm)) return(FALSE)
    name_hit <- grepl(
      "(^|[_\\.])(seurat_clusters|cluster|clust|louvain|leiden|graphcluster|snn_res|nn_res)([_\\.]|$)|(^|[_\\.])res\\.[0-9]+$",
      nm,
      perl = TRUE
    ) || grepl("^sweep_(nn_)?res\\.[0-9]+$", nm, perl = TRUE)
    if (isTRUE(name_hit)) return(TRUE)
    if (is.null(x)) return(FALSE)
    x_chr <- as.character(x %||% character(0))
    x_chr <- trimws(x_chr)
    x_chr[x_chr %in% c("", "NA", "NaN", "Inf", "-Inf")] <- NA_character_
    keep <- !is.na(x_chr)
    if (!any(keep)) return(FALSE)
    parsed <- suppressWarnings(as.numeric(x_chr[keep]))
    if (!all(is.finite(parsed))) return(FALSE)
    uniq_n <- length(unique(x_chr[keep]))
    n <- sum(keep)
    mostly_integer <- mean(abs(parsed - round(parsed)) < 1e-8) >= 0.98
    low_cardinality <- uniq_n <= max(60L, as.integer(ceiling(sqrt(n))))
    plausible_cluster_range <- min(parsed, na.rm = TRUE) >= -1 && max(parsed, na.rm = TRUE) <= 200
    mostly_integer && low_cardinality && plausible_cluster_range
  }
}
if (!exists("db_order_levels_for_color", mode = "function")) {
  db_order_levels_for_color <- function(x, cluster_like = FALSE) {
    lv <- unique(as.character(x %||% character(0)))
    lv <- lv[!is.na(lv)]
    if (!length(lv)) return(character(0))
    if (!isTRUE(cluster_like)) return(sort(lv, method = "radix"))
    is_num <- grepl("^-?[0-9]+(\\.[0-9]+)?$", lv)
    lv_num <- lv[is_num]
    lv_chr <- lv[!is_num]
    if (length(lv_num)) {
      ord <- order(suppressWarnings(as.numeric(lv_num)), lv_num, na.last = TRUE)
      lv_num <- lv_num[ord]
    }
    if (length(lv_chr)) lv_chr <- sort(lv_chr, method = "radix")
    c(lv_num, lv_chr)
  }
}
if (!exists("db_discrete_palette", mode = "function")) {
  db_discrete_palette <- function(n) {
    n <- as.integer(n %||% 0L)
    if (!is.finite(n) || n < 1L) return(character(0))
    fn <- tryCatch(getFromNamespace("DiscretePalette", "Seurat"), error = function(e) NULL)
    pal <- NULL
    if (is.function(fn)) pal <- tryCatch(suppressWarnings(fn(n)), error = function(e) NULL)
    if (is.null(pal) || length(pal) < n) {
      pal <- grDevices::hcl.colors(max(n, 3L), palette = "Dark 3")[seq_len(n)]
    } else {
      pal <- as.character(pal)[seq_len(n)]
    }
    pal
  }
}
if (!exists("db_colors_from_dimplot", mode = "function")) {
  db_colors_from_dimplot <- function(sobj, reduction_name, color_col, cluster_levels) {
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
    color_col <- as.character(color_col %||% "")
    if (!nzchar(color_col) || !(color_col %in% colnames(sobj@meta.data))) return(NULL)
    reds <- names(sobj@reductions %||% list())
    if (!length(reds)) return(NULL)
    red_use <- as.character(reduction_name %||% "")
    if (!nzchar(red_use) || !(red_use %in% reds)) {
      red_use <- wanlab_resolve_embedding_reduction(
        sobj,
        requested = if (nzchar(red_use)) red_use else "umap"
      )
    }
    if (!nzchar(red_use)) return(NULL)
    p_tmp <- tryCatch(
      Seurat::DimPlot(sobj, reduction = red_use, group.by = color_col),
      error = function(e) NULL
    )
    if (is.null(p_tmp) || !inherits(p_tmp, "ggplot")) return(NULL)
    d_plot <- tryCatch(p_tmp$data, error = function(e) NULL)
    d_layer <- tryCatch(ggplot2::ggplot_build(p_tmp)$data[[1]], error = function(e) NULL)
    if (is.null(d_plot) || is.null(d_layer) || !nrow(d_plot) || !nrow(d_layer)) return(NULL)
    col_key <- if (color_col %in% colnames(d_plot)) {
      color_col
    } else if ("ident" %in% colnames(d_plot)) {
      "ident"
    } else {
      ""
    }
    if (!nzchar(col_key)) return(NULL)
    vals <- as.character(d_plot[[col_key]])
    cols <- as.character(d_layer$colour)
    n <- min(length(vals), length(cols))
    if (n < 1L) return(NULL)
    vals <- vals[seq_len(n)]
    cols <- cols[seq_len(n)]
    keep <- !is.na(vals) & nzchar(vals) & !is.na(cols) & nzchar(cols)
    vals <- vals[keep]
    cols <- cols[keep]
    if (!length(vals) || !length(cols)) return(NULL)
    first_idx <- match(unique(vals), vals)
    map <- cols[first_idx]
    names(map) <- unique(vals)
    mapped <- unname(map[cluster_levels])
    names(mapped) <- cluster_levels
    if (!length(mapped) || all(is.na(mapped) | !nzchar(mapped))) return(NULL)
    mapped
  }
}
if (!exists("db_prepare_color_vector", mode = "function")) {
  db_prepare_color_vector <- function(x, col_name = NULL) {
    if (db_is_effectively_numeric(x) && !db_is_cluster_like_metadata(col_name, x)) {
      return(suppressWarnings(as.numeric(as.character(x))))
    }
    out <- as.character(x %||% character(0))
    out[is.na(out) | !nzchar(trimws(out))] <- "NA"
    out
  }
}
if (!exists("db_is_split_safe_metadata", mode = "function")) {
  db_is_split_safe_metadata <- function(col_name, x = NULL) {
    if (is.null(x)) return(FALSE)
    if (db_is_cluster_like_metadata(col_name, x)) return(TRUE)
    !db_is_effectively_numeric(x)
  }
}
if (!exists("db_split_safe_cols", mode = "function")) {
  db_split_safe_cols <- function(meta_df, exclude = character(0)) {
    if (!is.data.frame(meta_df) || !ncol(meta_df)) return(character(0))
    cols <- colnames(meta_df)
    keep <- vapply(
      cols,
      function(nm) db_is_split_safe_metadata(nm, meta_df[[nm]]),
      logical(1)
    )
    out <- cols[keep]
    if (length(exclude)) out <- setdiff(out, as.character(exclude))
    unique(as.character(out))
  }
}
if (!exists("db_build_split_choices", mode = "function")) {
  db_build_split_choices <- function(cols, exclude = character(0), meta_df = NULL) {
    cols <- unique(as.character(cols %||% character(0)))
    cols <- cols[nzchar(cols)]
    if (is.data.frame(meta_df) && nrow(meta_df) >= 0L) {
      safe_cols <- db_split_safe_cols(meta_df)
      cols <- intersect(cols, safe_cols)
    }
    if (length(exclude)) cols <- setdiff(cols, as.character(exclude))
    choices <- c("None" = "__none__")
    for (nm in cols) choices[[nm]] <- nm
    choices
  }
}

data_browser_tab_content <- function(include_header = TRUE) {
  tagList(
    tags$head(
      tags$style(HTML("
        :root {
          --db-window-available-h: 760px;
        }
        .db-max-height-frame {
          min-height: 420px;
        }
        #db_embedding_preview_ui,
        #db_quantification_ui {
          width: 100%;
          max-width: 100%;
          min-width: 0;
          overflow-x: hidden;
        }
        .db-main-row {
          margin-left: 0 !important;
          margin-right: 0 !important;
        }
        .db-main-row > [class*='col-'] {
          min-width: 0;
          padding-left: 8px;
          padding-right: 8px;
        }
        #db_ready_gate .plot_area_card_style {
          min-width: 0;
          max-width: 100%;
        }
        #db_ready_gate .plot_area_card_style > .wl-side {
          width: 100%;
          max-width: 100%;
          min-width: 0;
        }
        .db-layer-pair-card {
          border: 0;
          border-radius: 0;
          background: transparent;
          box-shadow: none;
          padding: 0;
          margin-bottom: 12px;
        }
        .db-layer-pair-card:last-child {
          margin-bottom: 0;
        }
        /* Agent note: Portrait CSS forces plot outputs to height:100%; keep an
           explicit parent height so Data Browser cards retain document flow. */
        .db-plot-height-frame {
          width: 100%;
          max-width: 100%;
          min-width: 0;
          flex: 0 0 auto;
        }
        #db_ready_gate .plot_area_card_style {
          overflow-x: hidden;
        }
        #db_embedding_preview_ui .html-widget,
        #db_quantification_ui .html-widget,
        #db_embedding_preview_ui .plotly,
        #db_quantification_ui .plotly,
        #db_embedding_preview_ui .shiny-plot-output,
        #db_quantification_ui .shiny-plot-output {
          width: 100% !important;
          max-width: 100% !important;
          min-width: 0 !important;
          overflow-x: hidden !important;
        }
        #db_plot_group.html-fill-item,
        #db_plot_layer_1.html-fill-item,
        #db_plot_layer_2.html-fill-item,
        #db_quant_plot_group.html-fill-item,
        #db_quant_plot_1.html-fill-item,
        #db_quant_plot_2.html-fill-item {
          flex: 0 0 auto !important;
          width: 100% !important;
          max-width: 100% !important;
          min-width: 0 !important;
        }
        /* Dense metadata table style (Data Browser only) */
        #db_meta_table,
        #db_import_match_table,
        #db_meta_table .dataTables_wrapper,
        #db_import_match_table .dataTables_wrapper,
        #db_meta_table .dataTables_scroll,
        #db_import_match_table .dataTables_scroll,
        #db_meta_table .dataTables_scrollBody,
        #db_import_match_table .dataTables_scrollBody {
          width: 100% !important;
          max-width: 100% !important;
          min-width: 0 !important;
        }
        #db_meta_table table.dataTable thead th,
        #db_meta_table table.dataTable tbody td,
        #db_import_match_table table.dataTable thead th,
        #db_import_match_table table.dataTable tbody td {
          font-size: 0.92rem;
          padding: 6px 10px !important;
          line-height: 1.25;
          white-space: nowrap !important;
          overflow-wrap: normal !important;
          word-break: normal !important;
        }
        #db_meta_table .dataTables_wrapper,
        #db_import_match_table .dataTables_wrapper {
          overflow-x: auto !important;
        }
        #db_meta_table .dataTables_scrollHead table,
        #db_meta_table .dataTables_scrollBody table,
        #db_import_match_table .dataTables_scrollHead table,
        #db_import_match_table .dataTables_scrollBody table {
          width: 100% !important;
          min-width: max-content !important;
        }
        #db_meta_table .dataTables_filter input,
        #db_meta_table .dataTables_length select,
        #db_meta_table table.dataTable thead input {
          font-size: 0.9rem;
          padding: 4px 8px;
          height: 30px;
        }
      ")),
      tags$script(HTML("
        (function() {
          function dbComputeAvailableHeight() {
            var vh = window.innerHeight || document.documentElement.clientHeight || 900;
            var nav = 0;
            var footer = 0;
            var navEl = document.querySelector('.navbar');
            if (navEl) nav = navEl.getBoundingClientRect().height || 0;
            var footerEl = document.querySelector('#app-footer, .app-footer, footer');
            if (footerEl) footer = footerEl.getBoundingClientRect().height || 0;
            var avail = Math.max(420, Math.floor(vh - nav - footer));
            document.documentElement.style.setProperty('--db-window-available-h', avail + 'px');
          }
          window.addEventListener('load', dbComputeAvailableHeight);
          window.addEventListener('resize', dbComputeAvailableHeight);
          dbComputeAvailableHeight();
        })();
      "))
    ),
    if (isTRUE(include_header)) {
      div(
        class = "page-header",
        h2(icon("database"), " Data Browser"),
        p("User annotation and metadata curation workspace. Tool-generated annotation stays in Main Analysis.")
      )
    },
  div(
    id = "db_ready_gate",
      fluidRow(
      class = "db-main-row",
      column(
        3,
        class = "plotting-left-panel",
              div(class = "wl-side",
                h4("Object"),
                tags$p(class = "text-muted", "Active object (from Analysis selector)"),
                tags$div(
                  class = "form-control",
                  style = "height:auto; min-height:34px; display:flex; align-items:center;",
                  textOutput("db_active_object_text", container = span)
                )
              ),
              div(class = "wl-side",
                h4("Display"),
                selectInput(
                  "db_reduction",
                  "Reduction",
                  choices = character(0),
                  selected = character(0),
                  selectize = FALSE
                ),
                selectInput(
                  "db_color_col",
                  "Color by metadata",
                  choices = character(0),
                  selected = character(0),
                  selectize = FALSE
                ),
                selectInput(
                  "db_legend_position",
                  "Legend position",
                  choices = c("Top" = "top", "Bottom" = "bottom", "Right" = "right", "None" = "none"),
                  selected = "top",
                  selectize = FALSE
                ),
                conditionalPanel(
                  condition = "input.db_legend_position == 'top' || input.db_legend_position == 'bottom'",
                  sliderInput("db_legend_cols", "Legend columns (top/bottom)", min = 1, max = 8, value = 4, step = 1)
                ),
                uiOutput("db_split_mode_ui"),
                uiOutput("db_split_controls_ui"),
                uiOutput("db_quant_split_ui"),
                uiOutput("db_active_layer_ui")
              ),
        div(class = "wl-side",
            h4("Import Metadata"),
            actionButton("db_open_import_modal", "Import Metadata", class = "btn btn-primary btn-sm")
        ),
        div(class = "wl-side",
            h4("Duplicate / Create Column"),
            uiOutput("db_source_col_ui"),
            textInput("db_new_col", "New metadata column", value = "user_manual_label"),
            actionButton("db_duplicate_col_btn", "Duplicate source to new column", class = "btn btn-default btn-sm"),
            tags$span(" "),
            actionButton("db_create_col_btn", "Create empty column", class = "btn btn-default btn-sm")
        ),
        div(class = "wl-side",
            h4("Cluster-level Relabel"),
            uiOutput("db_group_col_ui"),
            uiOutput("db_group_level_ui"),
            uiOutput("db_relabel_target_col_ui"),
            textInput("db_relabel_value", "New label", value = ""),
            actionButton("db_apply_group_label_btn", "Apply to selected group", class = "btn btn-default btn-sm")
        ),
        div(class = "wl-side",
            h4("Selected-cell Relabel"),
            p(class = "text-muted", "Select rows in the metadata table, then apply a label."),
            uiOutput("db_cell_target_col_ui"),
            textInput("db_cell_label_value", "Label for selected rows", value = ""),
            actionButton("db_apply_cell_label_btn", "Apply to selected rows", class = "btn btn-default btn-sm")
        )
      ),
      column(
        9,
        class = "plot_area_card_style",
        div(class = "wl-side",
            h4("Embedding preview"),
            uiOutput("db_embedding_preview_ui")
        ),
        uiOutput("db_quantification_card_ui"),
        div(class = "wl-side",
            h4("Metadata preview"),
            DTOutput("db_meta_table")
        ),
        div(class = "wl-side",
            h4("Latest import match summary"),
            DTOutput("db_import_match_table")
        )
      )
      )
  )
  )
}

data_browser_ui <- fluidPage(
  class = "plotting-page",
  data_browser_tab_content(include_header = TRUE)
)

data_browser_server <- function(input, output, session, shared_data) {
  .db_log <- function(...) {
    msg <- paste(..., collapse = " ")
    message(sprintf("[ANALYSIS DB][%s] %s", format(Sys.time(), "%H:%M:%OS3"), msg))
    invisible(NULL)
  }
  .coerce_registry_list <- function(x) {
    if (is.null(x)) return(list())
    if (is.list(x)) return(x)
    if (inherits(x, "reactivevalues")) {
      return(tryCatch(reactiveValuesToList(x), error = function(e) list()))
    }
    if (is.environment(x)) {
      return(tryCatch(as.list(x), error = function(e) list()))
    }
    tryCatch(as.list(x), error = function(e) list())
  }
  .normalize_registry_names <- function(registry, sample_sheet = NULL) {
    if (!is.list(registry)) return(list())
    if (!length(registry)) return(registry)
    nms <- names(registry) %||% character(length(registry))
    nms <- as.character(nms)
    if (length(nms) < length(registry)) nms <- c(nms, rep("", length(registry) - length(nms)))
    if (!length(nms)) nms <- rep("", length(registry))
    nms[is.na(nms)] <- ""
    nms <- trimws(nms)
    if (all(nzchar(nms))) {
      names(registry) <- make.unique(nms)
      return(registry)
    }
    sheet_names <- character(0)
    if (is.data.frame(sample_sheet) && nrow(sample_sheet) && ("name" %in% names(sample_sheet))) {
      sheet_names <- as.character(sample_sheet$name %||% character(0))
      sheet_names <- trimws(sheet_names)
      sheet_names <- sheet_names[nzchar(sheet_names)]
      sheet_names <- unique(sheet_names)
    }
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
    names(registry) <- make.unique(nms)
    registry
  }
  .registry_list <- reactive({
    if (exists("wanlab_canonicalize_registry", mode = "function", inherits = TRUE)) {
      tryCatch(
        wanlab_canonicalize_registry(shared_data$all_seurat_objects, sample_sheet = shared_data$full_sample_sheet),
        error = function(e) .normalize_registry_names(
          .coerce_registry_list(shared_data$all_seurat_objects),
          sample_sheet = shared_data$full_sample_sheet
        )
      )
    } else {
      .normalize_registry_names(
        .coerce_registry_list(shared_data$all_seurat_objects),
        sample_sheet = shared_data$full_sample_sheet
      )
    }
  })
  .scalar_chr <- function(x, default = "") {
    if (is.null(x) || !length(x)) return(default)
    y <- as.character(x)
    y <- y[!is.na(y)]
    if (!length(y)) return(default)
    y[[1]]
  }
  .db_tab_is_active <- function() {
    tab_now <- tolower(trimws(.scalar_chr(input$plot_tabs, "")))
    tab_now %in% c("data browser", "databrowser")
  }

  .active_name <- reactive({
    reg_names <- names(.registry_list() %||% list())
    reg_names <- as.character(reg_names %||% character(0))
    reg_names <- reg_names[!is.na(reg_names) & nzchar(reg_names)]
    if (!length(reg_names)) return("")
    # Agent note: Inner Data Browser follows canonical shared state only;
    # header selector input is a view and must not become a second source.
    candidates <- .scalar_chr(shared_data$active_object_name, "")
    candidates <- unique(as.character(candidates %||% character(0)))
    candidates <- candidates[!is.na(candidates) & nzchar(candidates)]
    candidates <- intersect(candidates, reg_names)
    if (length(candidates)) return(candidates[[1]])
    reg_names[[length(reg_names)]]
  })
  .active_entry <- reactive({
    nm <- .active_name()
    if (!nzchar(nm)) return(NULL)
    reg <- .registry_list()
    reg[[nm]]
  })
  .active_obj <- reactive({
    e <- .active_entry()
    if (is.null(e)) return(NULL)
    if (is.list(e) && !is.null(e$obj)) return(e$obj)
    e
  })
  .as_canonical_entry <- function(entry, sobj = NULL) {
    if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
      candidate <- if (is.null(sobj)) entry else utils::modifyList(as.list(entry %||% list()), list(obj = sobj))
      out <- tryCatch(wanlab_canonicalize_object_entry(candidate), error = function(e) NULL)
      if (!is.null(out)) return(out)
    }
    obj <- sobj
    if (is.null(obj)) {
      obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    }
    out <- if (is.list(entry) && !is.null(entry$obj)) entry else list(obj = obj)
    out$obj <- obj
    if (is.null(out$prefs) || !is.list(out$prefs)) out$prefs <- list()
    if (is.null(out$plots) || !is.list(out$plots)) out$plots <- list()
    if (is.null(out$analysis_cache) || !is.list(out$analysis_cache)) out$analysis_cache <- list()
    out
  }
  observe({
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) {
      return(invisible(NULL))
    }
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    nm <- .active_name()
    sobj <- .active_obj()
    .db_log(
      "state:",
      "tab=", .scalar_chr(input$plot_tabs, "<empty>"),
      "active_name=", if (nzchar(nm)) nm else "<empty>",
      "obj_class=", paste(class(sobj) %||% "<null>", collapse = "|")
    )
    invisible(NULL)
  })
  output$db_active_object_text <- renderText({
    nm <- .active_name()
    if (!nzchar(nm)) "No active object" else nm
  })

  .ensure_layers_store <- function() {
    if (is.null(shared_data$annotation_layers) || !is.list(shared_data$annotation_layers)) {
      shared_data$annotation_layers <- list()
    }
  }
  .sanitize_id <- function(x) {
    y <- gsub("[^A-Za-z0-9_]+", "_", as.character(x %||% "layer"))
    y <- gsub("_+", "_", y)
    y <- gsub("^_|_$", "", y)
    if (!nzchar(y)) y <- "layer"
    tolower(y)
  }
  .ensure_unique_col <- function(md, nm) {
    nm <- as.character(nm %||% "")
    if (!nzchar(nm)) nm <- "user_manual_label"
    if (!(nm %in% colnames(md))) return(nm)
    i <- 1L
    repeat {
      cand <- sprintf("%s_%d", nm, i)
      if (!(cand %in% colnames(md))) return(cand)
      i <- i + 1L
    }
  }
  .extract_raw_barcode <- function(x) {
    x <- as.character(x %||% "")
    m <- regexpr("[ACGTNacgtn]+-[0-9]+", x, perl = TRUE)
    out <- rep("", length(x))
    ok <- m > 0
    if (any(ok)) out[ok] <- substring(x[ok], m[ok], m[ok] + attr(m, "match.length")[ok] - 1)
    out
  }
  .norm_key <- function(x) {
    gsub("[^a-z0-9]", "", tolower(as.character(x %||% "")))
  }
  .strip_suffix <- function(x) {
    sub("([._-][0-9]+)$", "", as.character(x %||% ""), perl = TRUE)
  }
  .barcode_match_keys <- function(x) {
    x <- trimws(as.character(x %||% ""))
    if (!nzchar(x)) return(character(0))
    no_suffix <- .strip_suffix(x)
    tokens <- unlist(strsplit(no_suffix, "[^A-Za-z0-9]+", perl = TRUE), use.names = FALSE)
    dna <- regmatches(no_suffix, gregexpr("[ACGTNacgtn]{8,}", no_suffix, perl = TRUE))[[1]]
    cand <- unique(c(x, no_suffix, tokens, dna, .extract_raw_barcode(x)))
    keys <- .norm_key(cand)
    keys <- unique(keys[nzchar(keys)])
    long_keys <- keys[nchar(keys) >= 6]
    if (length(long_keys)) return(long_keys)
    keys
  }
  .guess_umap_axis_cols <- function(nms) {
    nms <- as.character(nms %||% character(0))
    if (!length(nms)) return(list(x = "", y = ""))
    lc <- tolower(nms)
    idx_x <- which(
      grepl("(^|[^a-z])umap([^a-z]|$).*\\bx\\b", lc) |
      grepl("\\bx\\b.*(^|[^a-z])umap([^a-z]|$)", lc) |
      grepl("\\bumap[_\\.]?1\\b|\\bx[_\\.]?umap\\b|\\bumap[_\\.]?x\\b", lc)
    )
    idx_y <- which(
      grepl("(^|[^a-z])umap([^a-z]|$).*\\by\\b", lc) |
      grepl("\\by\\b.*(^|[^a-z])umap([^a-z]|$)", lc) |
      grepl("\\bumap[_\\.]?2\\b|\\by[_\\.]?umap\\b|\\bumap[_\\.]?y\\b", lc)
    )
    list(
      x = if (length(idx_x)) nms[[idx_x[[1]]]] else "",
      y = if (length(idx_y)) nms[[idx_y[[1]]]] else ""
    )
  }
  .guess_cluster_col <- function(nms) {
    nms <- as.character(nms %||% character(0))
    if (!length(nms)) return("")
    lc <- tolower(nms)
    idx <- which(grepl("cluster|clustering|graphcluster|louvain|leiden|seurat", lc))
    if (length(idx)) nms[[idx[[1]]]] else ""
  }
  .set_active_layer <- function(object_name, layer_name) {
    if (is.null(shared_data$active_annotation_layer) || !is.list(shared_data$active_annotation_layer)) {
      shared_data$active_annotation_layer <- list()
    }
    shared_data$active_annotation_layer[[object_name]] <- layer_name
  }

  .register_layer <- function(object_name, layer) {
    .ensure_layers_store()
    bucket <- shared_data$annotation_layers[[object_name]]
    if (is.null(bucket) || !is.list(bucket)) bucket <- list()
    bucket[[layer$layer_name]] <- layer
    shared_data$annotation_layers[[object_name]] <- bucket
    .set_active_layer(object_name, layer$layer_name)
  }

  .apply_user_layer <- function(object_name, layer_name, cell_df, source = "manual", params = list()) {
    entry <- shared_data$all_seurat_objects[[object_name]]
    if (is.null(entry)) stop("Active object is missing.")
    sobj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
    if (is.null(sobj) || !inherits(sobj, "Seurat")) stop("Active object is not a Seurat object.")
    md <- sobj@meta.data
    if (is.null(md) || !nrow(md)) stop("Metadata is empty.")

    cell_df <- as.data.frame(cell_df, stringsAsFactors = FALSE)
    if (!all(c("cell", "status") %in% colnames(cell_df))) stop("Layer table requires 'cell' and 'status' columns.")
    keep_cells <- as.character(cell_df$cell)
    keep_cells <- keep_cells[nzchar(keep_cells)]
    keep_cells <- keep_cells[keep_cells %in% rownames(md)]
    if (!length(keep_cells)) stop("No valid cells to apply.")

    layer_id <- .sanitize_id(layer_name)
    names_map <- c()
    value_cols <- setdiff(colnames(cell_df), c("cell"))
    for (cn in value_cols) {
      out_col <- sprintf("user_%s_%s", layer_id, .sanitize_id(cn))
      out_col <- .ensure_unique_col(md, out_col)
      names_map[[cn]] <- out_col
      md[[out_col]] <- md[[out_col]] %||% rep(NA_character_, nrow(md))
      vec <- as.character(cell_df[[cn]])
      names(vec) <- as.character(cell_df$cell)
      md[names(vec), out_col] <- vec
    }

    sobj@meta.data <- md
    shared_data$all_seurat_objects[[object_name]] <- .as_canonical_entry(entry, sobj = sobj)

    .register_layer(object_name, list(
      layer_name = layer_name,
      layer_type = "user",
      tool_name = "",
      source = source,
      params_json = jsonlite::toJSON(params, auto_unbox = TRUE, null = "null"),
      created_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"),
      active = TRUE,
      n_cells = nrow(md),
      n_assigned = length(unique(keep_cells)),
      n_ambiguous = sum(as.character(cell_df$status %||% "") %in% c("ambiguous", "unresolved"), na.rm = TRUE),
      names_map = names_map,
      preview = utils::head(cell_df, 200)
    ))
  }

  db_latest_import <- reactiveVal(data.frame())
  db_selector_state_sig <- reactiveVal(list(red_choices = "", col_choices = ""))
  db_global_overlay_active <- reactiveVal(FALSE)
  db_overlay_signature <- reactiveVal("")
  db_overlay_request_id <- reactiveVal(0L)

  .db_overlay_show <- function(msg = "Rendering Data Browser plot...") {
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    db_global_overlay_active(TRUE)
    try(overlay_show(msg), silent = TRUE)
    invisible(NULL)
  }

  .db_overlay_hide <- function(tab_active = NULL, reason = "") {
    request_id_now <- suppressWarnings(as.integer(isolate(db_overlay_request_id()) %||% 0L))
    if (!is.finite(request_id_now) || is.na(request_id_now) || request_id_now < 0L) request_id_now <- 0L
    db_overlay_request_id(request_id_now + 1L)
    db_overlay_signature("")
    if (!isTRUE(isolate(db_global_overlay_active()))) return(invisible(NULL))
    db_global_overlay_active(FALSE)
    # Do not force-hide global overlay when DB is not active; another page
    # route/render may currently own it.
    if (is.null(tab_active)) tab_active <- isTRUE(.db_tab_is_active())
    if (isTRUE(tab_active)) {
      try(overlay_hide(), silent = TRUE)
    }
    .db_log("overlay:finish", "reason=", .scalar_chr(reason, "explicit"))
    invisible(NULL)
  }
  .db_request_overlay <- function(msg = "Loading Data Browser...") {
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    active_now <- .scalar_chr(isolate(.active_name()), "")
    tab_now <- tolower(trimws(.scalar_chr(input$plot_tabs, "")))
    signature <- paste(
      active_now,
      tab_now,
      .scalar_chr(input$db_reduction, ""),
      .scalar_chr(input$db_color_col, ""),
      .scalar_chr(input$db_split_mode, ""),
      .scalar_chr(input$db_split_by_primary, ""),
      .scalar_chr(input$db_split_by_secondary, ""),
      .scalar_chr(input$db_dot_size, ""),
      sep = "\u001f"
    )
    request_id_now <- suppressWarnings(as.integer(isolate(db_overlay_request_id()) %||% 0L))
    if (!is.finite(request_id_now) || is.na(request_id_now) || request_id_now < 0L) request_id_now <- 0L
    request_id <- request_id_now + 1L
    db_overlay_request_id(request_id)
    db_overlay_signature(signature)
    .db_overlay_show(msg)
    .db_log("overlay:request", "id=", request_id, "signature=", signature)
    # Server flush is the deterministic terminal boundary. Capture request
    # identity before registering; every reactive read in this deferred
    # callback is isolated. Never wait for a DOM output marker or timeout.
    try(session$onFlushed(function() {
      id_after <- suppressWarnings(as.integer(isolate(db_overlay_request_id()) %||% 0L))
      signature_after <- .scalar_chr(isolate(db_overlay_signature()), "")
      active_after <- .scalar_chr(isolate(.active_name()), "")
      navbar_after <- tolower(trimws(.scalar_chr(isolate(input$main_navbar), "")))
      plot_tab_after <- tolower(trimws(.scalar_chr(isolate(input$plot_tabs), "")))
      page_active_after <- identical(navbar_after, "analysis_tab") &&
        plot_tab_after %in% c("data browser", "databrowser")
      if (identical(id_after, request_id) &&
          identical(signature_after, signature) &&
          identical(active_after, active_now) &&
          isTRUE(page_active_after)) {
        .db_overlay_hide(tab_active = TRUE, reason = "server_flush")
      }
    }, once = TRUE), silent = TRUE)
    invisible(NULL)
  }

  observe({
    if (!identical(.scalar_chr(input$main_navbar, default = ""), "analysis_tab")) {
      return(invisible(NULL))
    }
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    reg <- .registry_list()
    reg_names <- names(reg %||% list())
    reg_names <- as.character(reg_names %||% character(0))
    reg_names <- reg_names[!is.na(reg_names) & nzchar(reg_names)]
    if (!length(reg_names)) return(invisible(NULL))
    target <- .active_name()
    if (!nzchar(target) || !(target %in% reg_names)) target <- reg_names[[length(reg_names)]]
    current <- .scalar_chr(shared_data$active_object_name, "")
    if (!identical(current, target)) shared_data$active_object_name <- target
    invisible(NULL)
  })

  .refresh_db_static_selectors <- function(reason = "reactive") {
    reg <- .registry_list() %||% list()
    objs <- names(reg)
    .db_log(
      "render:db_object_selector_ui",
      "objs_n=", length(objs),
      "reason=", reason
    )
    sobj <- .active_obj()
    sig_prev <- db_selector_state_sig()
    red_choices_sig <- .scalar_chr(sig_prev$red_choices, "")
    col_choices_sig <- .scalar_chr(sig_prev$col_choices, "")
    if (is.null(sobj)) {
      .db_log("render:db_reduction_ui null active object", "reason=", reason)
      red_sig_next <- "EMPTY|"
      col_sig_next <- "EMPTY|"
      if (!identical(red_choices_sig, red_sig_next)) {
        try(updateSelectInput(session, "db_reduction", choices = character(0), selected = character(0)), silent = TRUE)
      }
      if (!identical(col_choices_sig, col_sig_next)) {
        try(updateSelectInput(session, "db_color_col", choices = character(0), selected = character(0)), silent = TRUE)
      }
      db_selector_state_sig(list(red_choices = red_sig_next, col_choices = col_sig_next))
      shinyjs::disable("db_reduction")
      shinyjs::disable("db_color_col")
      return(invisible(NULL))
    }

    reds <- names(sobj@reductions %||% list())
    .db_log("render:db_reduction_ui", "reds_n=", length(reds), "reason=", reason)
    entry <- .active_entry()
    dims_pref <- wanlab_get_active_embedding_dims(entry)
    selected_red <- .scalar_chr(input$db_reduction, default = "")
    if (!length(reds)) {
      red_sig_next <- "EMPTY|"
      if (!identical(red_choices_sig, red_sig_next)) {
        try(updateSelectInput(session, "db_reduction", choices = character(0), selected = character(0)), silent = TRUE)
      }
      red_choices_sig <- red_sig_next
      shinyjs::disable("db_reduction")
    } else {
      red_choices_next <- paste(
        c(reds, if (length(dims_pref)) paste0("active_dims=", dims_pref[[1L]]) else "active_dims="),
        collapse = "||"
      )
      selected_lc <- tolower(selected_red)
      selected_family <- if (grepl("^tsne($|_)", selected_lc)) {
        "tsne"
      } else if (!nzchar(selected_lc) || grepl("^umap($|_)", selected_lc)) {
        "umap"
      } else {
        ""
      }
      if (nzchar(selected_family) && length(dims_pref)) {
        preferred_red <- wanlab_resolve_embedding_reduction(
          sobj,
          selected_family,
          preferred_dims = dims_pref
        )
        if (nzchar(preferred_red)) selected_red <- preferred_red
      }
      if (!nzchar(selected_red) || !(selected_red %in% reds)) {
        umap_name <- wanlab_resolve_embedding_reduction(
          sobj,
          "umap",
          preferred_dims = if (length(dims_pref)) dims_pref else NULL
        )
        selected_red <- if (nzchar(umap_name)) umap_name else reds[[1]]
      }
      if (!identical(.scalar_chr(input$db_reduction, default = ""), selected_red) ||
          !identical(red_choices_sig, red_choices_next)) {
        try(updateSelectInput(session, "db_reduction", choices = reds, selected = selected_red), silent = TRUE)
      }
      red_choices_sig <- red_choices_next
      shinyjs::enable("db_reduction")
    }

    cols <- .meta_cols()
    .db_log("render:db_color_col_ui", "meta_cols_n=", length(cols), "reason=", reason)
    selected_col <- .scalar_chr(input$db_color_col, default = "")
    if (!length(cols)) {
      col_sig_next <- "EMPTY|"
      if (!identical(col_choices_sig, col_sig_next)) {
        try(updateSelectInput(session, "db_color_col", choices = character(0), selected = character(0)), silent = TRUE)
      }
      col_choices_sig <- col_sig_next
      shinyjs::disable("db_color_col")
    } else {
      col_choices_next <- paste(cols, collapse = "||")
      if (!nzchar(selected_col) || !(selected_col %in% cols)) selected_col <- cols[[1]]
      if (!nzchar(.scalar_chr(input$db_color_col, default = "")) || !(.scalar_chr(input$db_color_col, default = "") %in% cols)) {
        try(updateSelectInput(session, "db_color_col", choices = cols, selected = selected_col), silent = TRUE)
      } else if (!identical(col_choices_sig, col_choices_next)) {
        try(updateSelectInput(session, "db_color_col", choices = cols, selected = selected_col), silent = TRUE)
      }
      col_choices_sig <- col_choices_next
      shinyjs::enable("db_color_col")
    }
    db_selector_state_sig(list(red_choices = red_choices_sig, col_choices = col_choices_sig))
    invisible(NULL)
  }

  observe({
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    .refresh_db_static_selectors(reason = "reactive")
  })

  observe({
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    reg <- .registry_list() %||% list()
    objs <- names(reg)
    if (!length(objs)) return(invisible(NULL))
    active_nm <- .active_name()
    active_obj <- .active_obj()
    if (nzchar(active_nm) && !is.null(active_obj)) return(invisible(NULL))
    fallback_nm <- objs[[length(objs)]]
    if (!identical(.scalar_chr(shared_data$active_object_name, ""), fallback_nm)) {
      shared_data$active_object_name <- fallback_nm
    }
    .db_log("heal:db_active_fallback", "selected=", fallback_nm)
    invisible(NULL)
  })

  .meta_cols <- reactive({
    sobj <- .active_obj(); if (is.null(sobj)) return(character())
    colnames(sobj@meta.data %||% data.frame())
  })
  .split_col_status <- function(col_name) {
    sobj <- .active_obj()
    if (is.null(sobj)) return("missing")
    md <- sobj@meta.data %||% data.frame()
    col_name <- as.character(col_name %||% "")
    if (!nzchar(col_name) || identical(col_name, "__none__")) return("none")
    if (!(col_name %in% colnames(md))) return("missing")
    if (isTRUE(db_is_split_safe_metadata(col_name, md[[col_name]]))) "safe" else "unsafe"
  }
  .notify_split_guard <- function(col_name) {
    showNotification(
      sprintf(
        "Split blocked for '%s': continuous/consecutive numeric metadata is not allowed for split. Please use a categorical or cluster-like column.",
        as.character(col_name %||% "")
      ),
      type = "warning"
    )
    invisible(NULL)
  }

  observeEvent(input$db_split_by_primary, {
    col_name <- as.character(input$db_split_by_primary %||% "__none__")
    status <- .split_col_status(col_name)
    if (!status %in% c("unsafe", "missing")) return(invisible(NULL))
    updateSelectInput(session, "db_split_by_primary", selected = "__none__")
    if (identical(status, "unsafe")) .notify_split_guard(col_name)
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$db_split_by_secondary, {
    col_name <- as.character(input$db_split_by_secondary %||% "__none__")
    status <- .split_col_status(col_name)
    if (!status %in% c("unsafe", "missing")) return(invisible(NULL))
    updateSelectInput(session, "db_split_by_secondary", selected = "__none__")
    if (identical(status, "unsafe")) .notify_split_guard(col_name)
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$db_quant_split_by, {
    col_name <- as.character(input$db_quant_split_by %||% "__none__")
    status <- .split_col_status(col_name)
    if (!status %in% c("unsafe", "missing")) return(invisible(NULL))
    updateSelectInput(session, "db_quant_split_by", selected = "__none__")
    if (identical(status, "unsafe")) .notify_split_guard(col_name)
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$plot_tabs, {
    if (!isTRUE(.db_tab_is_active())) {
      .db_overlay_hide()
      return(invisible(NULL))
    }
    .db_request_overlay("Loading Data Browser...")
    .refresh_db_static_selectors(reason = "tab_enter")
    invisible(NULL)
  }, ignoreInit = FALSE)
  observeEvent(input$db_reduction, {
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    .db_request_overlay("Updating Data Browser embedding...")
  }, ignoreInit = TRUE)
  observeEvent(input$db_color_col, {
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    .db_request_overlay("Updating Data Browser colors...")
  }, ignoreInit = TRUE)
  observeEvent(input$db_split_by_primary, {
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    .db_request_overlay("Updating Data Browser split...")
  }, ignoreInit = TRUE)
  observeEvent(input$db_split_by_secondary, {
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    .db_request_overlay("Updating Data Browser split...")
  }, ignoreInit = TRUE)
  observeEvent(input$db_dot_size, {
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    .db_request_overlay("Updating Data Browser point size...")
  }, ignoreInit = TRUE)
  observeEvent(shared_data$active_object_name, {
    if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
    .db_request_overlay("Loading Data Browser object...")
  }, ignoreInit = TRUE)
  observeEvent(
    list(input$db_reduction, input$db_color_col, shared_data$active_object_name),
    {
      if (!isTRUE(.db_tab_is_active())) return(invisible(NULL))
      red_ok <- nzchar(.scalar_chr(input$db_reduction, ""))
      col_ok <- nzchar(.scalar_chr(input$db_color_col, ""))
      active_ok <- nzchar(.active_name())
      if (isTRUE(active_ok) && isTRUE(red_ok) && isTRUE(col_ok)) {
        .db_log("bind_state:ready", "active=", .active_name(), "reduction=", .scalar_chr(input$db_reduction, ""), "color=", .scalar_chr(input$db_color_col, ""))
      }
      invisible(NULL)
    },
    ignoreInit = FALSE
  )
  output$db_split_mode_ui <- renderUI({
    split_mode_selected <- as.character(input$db_split_mode %||% "group_split")
    if (!split_mode_selected %in% c("group_split", "metadata_layers")) split_mode_selected <- "group_split"
    selectInput(
      "db_split_mode",
      "Advanced split mode",
      choices = c(
        "Group split (single full card)" = "group_split",
        "Metadata layers (max 2 cards)" = "metadata_layers"
      ),
      selected = split_mode_selected
    )
  })
  output$db_split_controls_ui <- renderUI({
    sobj <- .active_obj(); req(sobj)
    meta_df <- sobj@meta.data %||% data.frame()
    cols <- colnames(meta_df)
    assays <- Seurat::Assays(sobj)
    assay_choices <- c("Auto (default assay)" = "__default__")
    if (length(assays)) assay_choices <- c(assay_choices, stats::setNames(assays, assays))
      mode <- as.character(input$db_split_mode %||% "group_split")
      if (identical(mode, "metadata_layers")) {
        feature_choice <- c("Feature plot (3 genes)" = "__feature_plot__")
        layer_layout_selected <- as.character(input$db_layer_layout %||% "split")
        if (!layer_layout_selected %in% c("split", "stacked")) layer_layout_selected <- "split"
        layer_1_choices <- c("None" = "__none__", feature_choice, setNames(cols, cols))
        layer_2_choices <- c("None" = "__none__", feature_choice, setNames(cols, cols))
        layer_1_selected <- as.character(input$db_layer_1 %||% "__none__")
        layer_2_selected <- as.character(input$db_layer_2 %||% "__none__")
        layer_1_assay_selected <- as.character(input$db_layer_1_assay %||% "__default__")
        layer_2_assay_selected <- as.character(input$db_layer_2_assay %||% "__default__")
        if (!layer_1_selected %in% unname(layer_1_choices)) layer_1_selected <- "__none__"
        if (!layer_2_selected %in% unname(layer_2_choices)) layer_2_selected <- "__none__"
        if (!layer_1_assay_selected %in% unname(assay_choices)) layer_1_assay_selected <- "__default__"
        if (!layer_2_assay_selected %in% unname(assay_choices)) layer_2_assay_selected <- "__default__"
        feature_gene_choices <- character(0)
        if (identical(layer_1_selected, "__feature_plot__") || identical(layer_2_selected, "__feature_plot__")) {
          default_assay <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
          resolve_feature_assay <- function(choice) {
            choice <- as.character(choice %||% "__default__")
            if (!nzchar(choice) || identical(choice, "__default__") || !(choice %in% assays)) {
              choice <- if (nzchar(default_assay) && default_assay %in% assays) {
                default_assay
              } else if (length(assays)) {
                assays[[1]]
              } else {
                ""
              }
            }
            choice
          }
          feature_assays <- character(0)
          if (identical(layer_1_selected, "__feature_plot__")) {
            feature_assays <- c(feature_assays, resolve_feature_assay(layer_1_assay_selected))
          }
          if (identical(layer_2_selected, "__feature_plot__")) {
            feature_assays <- c(feature_assays, resolve_feature_assay(layer_2_assay_selected))
          }
          feature_assays <- unique(feature_assays[nzchar(feature_assays)])
          feature_gene_choices <- unique(unlist(lapply(feature_assays, function(assay_name) {
            .db_get_assay_features(sobj, assay = assay_name)
          }), use.names = FALSE))
          feature_gene_choices <- feature_gene_choices[!is.na(feature_gene_choices) & nzchar(feature_gene_choices)]
        }
        tagList(
          selectInput(
            "db_layer_layout",
            "Metadata card layout",
            choices = c(
              "Split view (two cards in one row)" = "split",
              "Stacked view (full width, two rows)" = "stacked"
            ),
            selected = layer_layout_selected
          ),
          selectInput("db_layer_1", "Metadata layer 1", choices = layer_1_choices, selected = layer_1_selected),
          selectInput("db_layer_1_assay", "Layer 1 assay (feature plot)", choices = assay_choices, selected = layer_1_assay_selected),
          selectInput("db_layer_2", "Metadata layer 2", choices = layer_2_choices, selected = layer_2_selected),
          selectInput("db_layer_2_assay", "Layer 2 assay (feature plot)", choices = assay_choices, selected = layer_2_assay_selected),
        conditionalPanel(
          condition = "input.db_layer_1 == '__feature_plot__' || input.db_layer_2 == '__feature_plot__'",
          h5("Feature plot genes (optional)"),
          fluidRow(
            column(4, wl_gene_selectize_input("db_feature_gene_r", "R", placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = feature_gene_choices, defer_choices = TRUE)),
            column(4, wl_gene_selectize_input("db_feature_gene_g", "G", placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = feature_gene_choices, defer_choices = TRUE)),
            column(4, wl_gene_selectize_input("db_feature_gene_b", "B", placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, choices = feature_gene_choices, defer_choices = TRUE))
          )
        )
      )
    } else {
      selected_primary <- as.character(input$db_split_by_primary %||% "__none__")
      if (!selected_primary %in% names(meta_df)) selected_primary <- "__none__"
      primary_choices <- db_build_split_choices(cols, meta_df = meta_df)
      if (!selected_primary %in% unname(primary_choices)) selected_primary <- "__none__"
      secondary_choices <- db_build_split_choices(
        cols,
        exclude = setdiff(selected_primary, "__none__"),
        meta_df = meta_df
      )
      selected_secondary <- as.character(input$db_split_by_secondary %||% "__none__")
      if (!selected_secondary %in% unname(secondary_choices)) selected_secondary <- "__none__"
      tagList(
        p(
          class = "text-muted",
          "Split guard: only categorical/cluster-like metadata can be used for split. Continuous or consecutive numeric columns are blocked."
        ),
        selectInput("db_split_by_primary", "Column split", choices = primary_choices, selected = selected_primary),
        selectInput("db_split_by_secondary", "Row split", choices = secondary_choices, selected = selected_secondary)
      )
    }
  })
  output$db_quant_split_ui <- renderUI({
    sobj <- .active_obj(); req(sobj)
    meta_df <- sobj@meta.data %||% data.frame()
    cols <- colnames(meta_df)
    choices <- db_build_split_choices(cols, meta_df = meta_df)
    selected_quant_split <- as.character(input$db_quant_split_by %||% "__none__")
    if (!selected_quant_split %in% unname(choices)) selected_quant_split <- "__none__"
    selectInput("db_quant_split_by", "Quantification split by", choices = choices, selected = selected_quant_split)
  })
  output$db_source_col_ui <- renderUI({
    cols <- .meta_cols()
    if (!length(cols)) return(helpText("No source metadata column available."))
    selectInput("db_source_col", "Source column", choices = cols, selected = cols[1])
  })
  output$db_group_col_ui <- renderUI({
    cols <- .meta_cols()
    if (!length(cols)) return(helpText("No grouping column available."))
    selectInput("db_group_col", "Group by column", choices = cols, selected = cols[1])
  })
  output$db_group_level_ui <- renderUI({
    sobj <- .active_obj(); req(sobj)
    gc <- as.character(input$db_group_col %||% "")
    req(nzchar(gc), gc %in% colnames(sobj@meta.data))
    lv <- sort(unique(as.character(sobj@meta.data[[gc]])))
    selectInput("db_group_level", "Group value", choices = lv, selected = lv[1])
  })
  output$db_relabel_target_col_ui <- renderUI({
    cols <- .meta_cols()
    selected <- as.character(input$db_relabel_target_col %||% "user_manual_label")
    selectizeInput(
      "db_relabel_target_col",
      "Target column",
      choices = unique(c("user_manual_label", cols)),
      selected = selected,
      options = list(create = TRUE, placeholder = "Pick existing column or type new name")
    )
  })
  output$db_cell_target_col_ui <- renderUI({
    cols <- .meta_cols()
    selected <- as.character(input$db_cell_target_col %||% "user_manual_label")
    selectizeInput(
      "db_cell_target_col",
      "Target column",
      choices = unique(c("user_manual_label", cols)),
      selected = selected,
      options = list(create = TRUE, placeholder = "Pick existing column or type new name")
    )
  })

  output$db_active_layer_ui <- renderUI({
    .ensure_layers_store()
    nm <- .active_name()
    layers <- shared_data$annotation_layers[[nm]]
    if (is.null(layers) || !length(layers)) return(helpText("No annotation layers yet."))
    choices <- names(layers)
    cur <- as.character((shared_data$active_annotation_layer %||% list())[[nm]] %||% choices[1])
    selectInput("db_active_layer", "Active annotation layer", choices = choices, selected = cur)
  })

  observeEvent(input$db_active_layer, {
    nm <- .active_name(); req(nzchar(nm))
    lyr <- as.character(input$db_active_layer %||% "")
    if (nzchar(lyr)) .set_active_layer(nm, lyr)
  }, ignoreInit = TRUE)

  observeEvent(input$db_duplicate_col_btn, {
    sobj <- .active_obj(); req(sobj)
    src <- as.character(input$db_source_col %||% "")
    new_col <- as.character(input$db_new_col %||% "")
    req(nzchar(src), nzchar(new_col), src %in% colnames(sobj@meta.data))

    md <- sobj@meta.data
    out_col <- .ensure_unique_col(md, new_col)
    md[[out_col]] <- as.character(md[[src]])
    sobj@meta.data <- md

    nm <- .active_name()
    entry <- shared_data$all_seurat_objects[[nm]]
    shared_data$all_seurat_objects[[nm]] <- .as_canonical_entry(entry, sobj = sobj)
    showNotification(sprintf("Created duplicated column: %s", out_col), type = "message")
  }, ignoreInit = TRUE)

  observeEvent(input$db_create_col_btn, {
    sobj <- .active_obj(); req(sobj)
    new_col <- as.character(input$db_new_col %||% "")
    req(nzchar(new_col))
    md <- sobj@meta.data
    out_col <- .ensure_unique_col(md, new_col)
    md[[out_col]] <- NA_character_
    sobj@meta.data <- md
    nm <- .active_name()
    entry <- shared_data$all_seurat_objects[[nm]]
    shared_data$all_seurat_objects[[nm]] <- .as_canonical_entry(entry, sobj = sobj)
    showNotification(sprintf("Created empty column: %s", out_col), type = "message")
  }, ignoreInit = TRUE)

  observeEvent(input$db_apply_group_label_btn, {
    sobj <- .active_obj(); req(sobj)
    gc <- as.character(input$db_group_col %||% "")
    gv <- as.character(input$db_group_level %||% "")
    tc <- as.character(input$db_relabel_target_col %||% "")
    tv <- as.character(input$db_relabel_value %||% "")
    req(nzchar(gc), nzchar(gv), nzchar(tc), nzchar(tv), gc %in% colnames(sobj@meta.data))

    md <- sobj@meta.data
    out_col <- if (tc %in% colnames(md)) tc else .ensure_unique_col(md, tc)
    if (!(out_col %in% colnames(md))) md[[out_col]] <- NA_character_
    idx <- as.character(md[[gc]]) == gv
    md[idx, out_col] <- tv
    sobj@meta.data <- md

    nm <- .active_name()
    entry <- shared_data$all_seurat_objects[[nm]]
    shared_data$all_seurat_objects[[nm]] <- .as_canonical_entry(entry, sobj = sobj)

    layer_df <- data.frame(cell = rownames(md)[idx], value = rep(tv, sum(idx)), status = "manual", stringsAsFactors = FALSE)
    .apply_user_layer(nm, layer_name = paste0("group_", out_col), cell_df = layer_df, source = "manual_group", params = list(group_col = gc, group_value = gv, target_col = out_col))

    showNotification(sprintf("Updated %d cells in %s.", sum(idx), out_col), type = "message")
  }, ignoreInit = TRUE)

  .db_preview_df <- reactive({
    sobj <- .active_obj(); req(sobj)
    md <- sobj@meta.data
    md$cell <- rownames(md)
    md <- md[, c("cell", setdiff(colnames(md), "cell")), drop = FALSE]
    md
  })

  output$db_meta_table <- renderDT({
    sobj <- .active_obj()
    if (is.null(sobj)) {
      return(datatable(data.frame(note = "Load data and select an active object first."), rownames = FALSE, options = list(dom = "t")))
    }
    df <- .db_preview_df()
    if (nrow(df) > 2000) df <- df[seq_len(2000), , drop = FALSE]
    datatable(
      df,
      rownames = FALSE,
      selection = "multiple",
      options = list(
        dom = "t",
        scrollX = TRUE,
        pageLength = 25,
        lengthMenu = list(c(15, 25, 50, 100), c("15", "25", "50", "100")),
        ordering = FALSE,
        searching = FALSE,
        info = FALSE
      )
    )
  }, server = TRUE)

  observeEvent(input$db_apply_cell_label_btn, {
    sobj <- .active_obj(); req(sobj)
    sel <- input$db_meta_table_rows_selected
    req(length(sel) > 0)
    df <- .db_preview_df()
    if (nrow(df) > 2000) df <- df[seq_len(2000), , drop = FALSE]
    cells <- as.character(df$cell[sel])

    tc <- as.character(input$db_cell_target_col %||% "")
    tv <- as.character(input$db_cell_label_value %||% "")
    req(nzchar(tc), nzchar(tv))

    md <- sobj@meta.data
    out_col <- if (tc %in% colnames(md)) tc else .ensure_unique_col(md, tc)
    if (!(out_col %in% colnames(md))) md[[out_col]] <- NA_character_
    cells <- cells[cells %in% rownames(md)]
    md[cells, out_col] <- tv
    sobj@meta.data <- md

    nm <- .active_name()
    entry <- shared_data$all_seurat_objects[[nm]]
    shared_data$all_seurat_objects[[nm]] <- .as_canonical_entry(entry, sobj = sobj)

    layer_df <- data.frame(cell = cells, value = rep(tv, length(cells)), status = "manual", stringsAsFactors = FALSE)
    .apply_user_layer(nm, layer_name = paste0("cells_", out_col), cell_df = layer_df, source = "manual_cells", params = list(target_col = out_col))

    showNotification(sprintf("Updated %d selected cells in %s.", length(cells), out_col), type = "message")
  }, ignoreInit = TRUE)

  .db_plot_height_px <- function(output_id = "db_plot_group", min_px = 500L) {
    width_key <- paste0("output_", output_id, "_width")
    plot_w <- suppressWarnings(as.numeric(session$clientData[[width_key]] %||% 1000))
    if (!is.finite(plot_w) || is.na(plot_w) || plot_w <= 0) plot_w <- 1000
    h <- plot_w * 0.72 + 140
    as.integer(max(min_px, min(1700, h)))
  }
  .db_output_width_px <- function(output_id, fallback_px = 960L, min_px = 320L, pad_px = 0L) {
    key <- paste0("output_", output_id, "_width")
    w <- suppressWarnings(as.numeric(session$clientData[[key]] %||% NA_real_))
    if (!is.finite(w) || w <= 0) w <- as.numeric(fallback_px)
    as.integer(max(as.numeric(min_px), w - as.numeric(pad_px)))
  }
  .db_embedding_df <- function(sobj, red) {
    t0 <- Sys.time()
    emb <- as.data.frame(Seurat::Embeddings(sobj, reduction = red))
    validate(need(ncol(emb) >= 2, "Embedding needs at least 2 dimensions."))
    colnames(emb)[1:2] <- c("dim1", "dim2")
    emb$cell <- rownames(emb)
    md <- sobj@meta.data
    idx <- match(emb$cell, rownames(md))
    md_aligned <- md[idx, , drop = FALSE]
    out <- cbind(emb, md_aligned, stringsAsFactors = FALSE)
    .db_log(
      "perf:db_embedding_df",
      "reduction=", red,
      "cells=", nrow(out),
      "elapsed_ms=", as.integer(round(as.numeric(difftime(Sys.time(), t0, units = "secs")) * 1000))
    )
    out
  }
  .db_split_var <- function(df, col_name) {
    if (!nzchar(col_name) || identical(col_name, "__none__") || !(col_name %in% colnames(df))) return(rep("All cells", nrow(df)))
    out <- as.character(df[[col_name]])
    out[is.na(out) | !nzchar(out)] <- "NA"
    out
  }
  .db_rgb_hex <- function(a, b, c) {
    .scale <- function(x) {
      x <- suppressWarnings(as.numeric(x))
      x[!is.finite(x)] <- 0
      if (!length(x)) return(numeric(0))
      if (!any(x > 0, na.rm = TRUE)) return(rep(0, length(x)))
      nz <- x[x > 0 & is.finite(x)]
      hi <- if (length(nz) >= 16L) {
        suppressWarnings(as.numeric(stats::quantile(nz, 0.99, na.rm = TRUE)))
      } else {
        suppressWarnings(max(nz, na.rm = TRUE))
      }
      if (!is.finite(hi) || hi <= 0) hi <- suppressWarnings(max(x, na.rm = TRUE))
      if (!is.finite(hi) || hi <= 0) return(rep(0, length(x)))
      y <- x / hi
      pmax(0, pmin(1, y))
    }
    R <- .scale(a); G <- .scale(b); B <- .scale(c)
    cols <- grDevices::rgb(R, G, B, alpha = 0.9)
    cols[!is.finite(R) | !is.finite(G) | !is.finite(B)] <- "#00000012"
    cols
  }
  .db_build_color_plot <- function(df, red, color_col, split_primary = "__none__", split_secondary = "__none__", title = NULL, sobj = NULL, legend_position = "top", legend_columns = 4) {
    t0 <- Sys.time()
    if (!nzchar(color_col) || !(color_col %in% colnames(df))) {
      color_col <- colnames(df)[!colnames(df) %in% c("cell", "dim1", "dim2")][1] %||% ""
    }
    if (!nzchar(color_col) || !(color_col %in% colnames(df))) {
      color_col <- "group"
      df[[color_col]] <- "All cells"
    }
    cluster_like <- db_is_cluster_like_metadata(color_col, df[[color_col]])
    color_vec <- db_prepare_color_vector(df[[color_col]], col_name = color_col)
    df$color_value <- color_vec
    df$split_value <- .db_split_var(df, split_primary)
    df$split_value_secondary <- .db_split_var(df, split_secondary)
    df$split_value <- factor(df$split_value, levels = sort(unique(df$split_value)))
    df$split_value_secondary <- factor(df$split_value_secondary, levels = sort(unique(df$split_value_secondary)))

    legend_position <- tolower(as.character(legend_position %||% "top"))
    if (!legend_position %in% c("top", "bottom", "right", "none")) legend_position <- "top"
    legend_is_horizontal <- legend_position %in% c("top", "bottom")
    legend_columns <- suppressWarnings(as.integer(legend_columns %||% 4L))
    if (!is.finite(legend_columns) || legend_columns < 1L) legend_columns <- 4L
    legend_columns <- max(1L, min(8L, legend_columns))

    p <- ggplot2::ggplot(df, ggplot2::aes(x = dim1, y = dim2, color = color_value)) +
      ggplot2::geom_point(size = 0.45, alpha = 0.9) +
      ggplot2::coord_fixed() +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        legend.position = legend_position,
        legend.direction = if (isTRUE(legend_is_horizontal)) "horizontal" else "vertical",
        legend.box = if (isTRUE(legend_is_horizontal)) "horizontal" else "vertical",
        legend.title.position = "top",
        legend.title = ggplot2::element_text(face = "bold", hjust = 0.5)
      ) +
      ggplot2::labs(x = paste0(red, "_1"), y = paste0(red, "_2"), color = color_col, title = title %||% NULL)
    if (is.numeric(color_vec)) {
      p <- p + ggplot2::scale_color_viridis_c(option = "C", na.value = "#D9D9D9")
    } else {
      lv <- db_order_levels_for_color(color_vec, cluster_like = cluster_like)
      pal <- db_discrete_palette(length(lv))
      names(pal) <- lv
      if (isTRUE(cluster_like)) {
        from_umap <- db_colors_from_dimplot(sobj, red, color_col, lv)
        if (!is.null(from_umap)) {
          na_idx <- is.na(from_umap) | !nzchar(from_umap)
          if (any(na_idx)) from_umap[na_idx] <- pal[na_idx]
          pal <- from_umap
        }
      }
      n_lv <- length(lv)
      legend_cols <- if (isTRUE(legend_is_horizontal)) max(1L, min(legend_columns, n_lv)) else NULL
      legend_rows <- if (isTRUE(legend_is_horizontal)) max(1L, as.integer(ceiling(n_lv / max(1L, legend_cols)))) else NULL
      p <- p + ggplot2::scale_color_manual(values = pal, breaks = lv, drop = FALSE) +
        ggplot2::guides(
          colour = ggplot2::guide_legend(
            ncol = legend_cols,
            nrow = legend_rows,
            byrow = isTRUE(legend_is_horizontal),
            title.position = "top",
            title.hjust = 0.5,
            override.aes = list(size = max(0.45 * 3, 10 * 0.32), alpha = 1)
          )
        )
    }

    has_col_facet <- length(levels(df$split_value)) > 1L || !identical(levels(df$split_value)[1], "All cells")
    has_row_facet <- length(levels(df$split_value_secondary)) > 1L || !identical(levels(df$split_value_secondary)[1], "All cells")
    if (has_col_facet && has_row_facet) {
      p <- p + ggplot2::facet_grid(rows = ggplot2::vars(split_value_secondary), cols = ggplot2::vars(split_value), drop = FALSE)
    } else if (has_col_facet) {
      p <- p + ggplot2::facet_wrap(ggplot2::vars(split_value), nrow = 1, drop = FALSE)
    } else if (has_row_facet) {
      p <- p + ggplot2::facet_wrap(ggplot2::vars(split_value_secondary), ncol = 1, drop = FALSE)
    }
    .db_log(
      "perf:db_build_color_plot",
      "reduction=", red,
      "color_col=", color_col,
      "levels=", if (is.numeric(color_vec)) "numeric" else length(unique(as.character(color_vec))),
      "elapsed_ms=", as.integer(round(as.numeric(difftime(Sys.time(), t0, units = "secs")) * 1000))
    )
    p
  }
  .db_build_quant_plot <- function(df, red, layer_choice, card_title, split_by = "__none__", sobj = NULL) {
    choice <- as.character(layer_choice %||% "__none__")
    if (identical(choice, "__none__") || !nzchar(choice)) {
      return(
        ggplot2::ggplot(data.frame(x = 1, y = 1), ggplot2::aes(x = x, y = y)) +
          ggplot2::geom_blank() +
          ggplot2::theme_void() +
          ggplot2::labs(title = paste0(card_title, ": None selected"))
      )
    }
    if (identical(choice, "__feature_plot__")) {
      return(
        ggplot2::ggplot(data.frame(x = 1, y = 1), ggplot2::aes(x = x, y = y)) +
          ggplot2::geom_blank() +
          ggplot2::theme_void() +
          ggplot2::labs(title = paste0(card_title, ": Feature plot has no metadata quantification"))
      )
    }
    if (!(choice %in% colnames(df))) {
      return(
        ggplot2::ggplot(data.frame(x = 1, y = 1), ggplot2::aes(x = x, y = y)) +
          ggplot2::geom_blank() +
          ggplot2::theme_void() +
          ggplot2::labs(title = paste0(card_title, ": Column not found"))
      )
    }

    cluster_like <- db_is_cluster_like_metadata(choice, df[[choice]])
    is_continuous <- db_is_effectively_numeric(df[[choice]]) && !isTRUE(cluster_like)
    split_col <- as.character(split_by %||% "__none__")
    split_enabled <- nzchar(split_col) && !identical(split_col, "__none__") && (split_col %in% colnames(df))

    if (isTRUE(is_continuous)) {
      val <- suppressWarnings(as.numeric(as.character(df[[choice]])))
      group <- if (split_enabled) as.character(df[[split_col]]) else rep("All cells", length(val))
      group[is.na(group) | !nzchar(trimws(group))] <- "NA"
      qdf <- data.frame(group = group, value = val, stringsAsFactors = FALSE)
      qdf <- qdf[is.finite(qdf$value), , drop = FALSE]
      if (!nrow(qdf)) {
        return(
          ggplot2::ggplot(data.frame(x = 1, y = 1), ggplot2::aes(x = x, y = y)) +
            ggplot2::geom_blank() +
            ggplot2::theme_void() +
            ggplot2::labs(title = paste0(card_title, ": No finite numeric values"))
        )
      }
      qdf$group <- factor(qdf$group, levels = sort(unique(qdf$group)))
      return(
        ggplot2::ggplot(qdf, ggplot2::aes(x = group, y = value, fill = group)) +
          ggplot2::geom_violin(scale = "width", trim = TRUE, alpha = 0.8, color = "#374151") +
          ggplot2::geom_boxplot(width = 0.14, outlier.size = 0.3, alpha = 0.45, color = "#111827") +
          ggplot2::theme_minimal(base_size = 11) +
          ggplot2::theme(
            legend.position = "none",
            axis.text.x = ggplot2::element_text(angle = 30, hjust = 1)
          ) +
          ggplot2::labs(
            x = if (split_enabled) split_col else "",
            y = choice,
            title = paste0(card_title, " quantification (violin)")
          )
      )
    }

    cat_vals <- as.character(df[[choice]])
    cat_vals[is.na(cat_vals) | !nzchar(trimws(cat_vals))] <- "NA"
    lv <- db_order_levels_for_color(cat_vals, cluster_like = cluster_like)
    cdf <- data.frame(category = factor(cat_vals, levels = lv), stringsAsFactors = FALSE)
    if (split_enabled) {
      split_vals <- as.character(df[[split_col]])
      split_vals[is.na(split_vals) | !nzchar(trimws(split_vals))] <- "NA"
      cdf$split <- factor(split_vals, levels = sort(unique(split_vals)))
      cnt <- as.data.frame(table(split = cdf$split, category = cdf$category), stringsAsFactors = FALSE)
      cnt <- cnt[cnt$Freq > 0, , drop = FALSE]
      cnt$pct <- ave(cnt$Freq, cnt$split, FUN = function(x) if (sum(x) > 0) x / sum(x) else 0)
      cnt$hover <- sprintf(
        "%s: %s<br>%s: %s<br>Cells: %d<br>Percent: %.2f%%",
        split_col, as.character(cnt$split),
        choice, as.character(cnt$category),
        as.integer(cnt$Freq),
        100 * cnt$pct
      )
      p <- ggplot2::ggplot(cnt, ggplot2::aes(x = split, y = Freq, fill = category, text = hover)) +
        ggplot2::geom_col(position = "stack", alpha = 0.9) +
        ggplot2::theme_minimal(base_size = 11) +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 30, hjust = 1)) +
        ggplot2::labs(
          x = split_col,
          y = "Cells",
          fill = choice,
          title = paste0(card_title, " quantification (bar)")
        )
      if (length(lv)) {
        pal <- db_discrete_palette(length(lv))
        names(pal) <- lv
        if (isTRUE(cluster_like)) {
          from_umap <- db_colors_from_dimplot(sobj, red, choice, lv)
          if (!is.null(from_umap)) {
            na_idx <- is.na(from_umap) | !nzchar(from_umap)
            if (any(na_idx)) from_umap[na_idx] <- pal[na_idx]
            pal <- from_umap
          }
        }
        p <- p + ggplot2::scale_fill_manual(values = pal, breaks = lv, drop = FALSE)
      }
      return(p)
    }

    cnt <- as.data.frame(table(category = cdf$category), stringsAsFactors = FALSE)
    cnt <- cnt[cnt$Freq > 0, , drop = FALSE]
    total_n <- sum(cnt$Freq)
    cnt$pct <- if (total_n > 0) cnt$Freq / total_n else 0
    cnt$hover <- sprintf(
      "%s: %s<br>Cells: %d<br>Percent: %.2f%%",
      choice, as.character(cnt$category),
      as.integer(cnt$Freq),
      100 * cnt$pct
    )
    p <- ggplot2::ggplot(cnt, ggplot2::aes(x = category, y = Freq, fill = category, text = hover)) +
      ggplot2::geom_col(alpha = 0.9) +
      ggplot2::theme_minimal(base_size = 11) +
      ggplot2::theme(
        legend.position = "none",
        axis.text.x = ggplot2::element_text(angle = 30, hjust = 1)
      ) +
      ggplot2::labs(
        x = choice,
        y = "Cells",
        title = paste0(card_title, " quantification (bar)")
      )
    if (length(lv)) {
      pal <- db_discrete_palette(length(lv))
      names(pal) <- lv
      if (isTRUE(cluster_like)) {
        from_umap <- db_colors_from_dimplot(sobj, red, choice, lv)
        if (!is.null(from_umap)) {
          na_idx <- is.na(from_umap) | !nzchar(from_umap)
          if (any(na_idx)) from_umap[na_idx] <- pal[na_idx]
          pal <- from_umap
        }
      }
      p <- p + ggplot2::scale_fill_manual(values = pal, breaks = lv, drop = FALSE)
    }
    p
  }
  .db_build_feature_plot <- function(sobj, df, red, assay_choice = "__default__") {
    assays <- Seurat::Assays(sobj)
    validate(need(length(assays) > 0, "Feature plot mode requires at least one assay."))
    default_assay <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "")
    assay_use <- as.character(assay_choice %||% "__default__")
    if (!nzchar(assay_use) || identical(assay_use, "__default__") || !(assay_use %in% assays)) {
      assay_use <- if (nzchar(default_assay) && default_assay %in% assays) default_assay else assays[[1]]
    }
    m <- .db_get_assay_data(sobj, assay = assay_use, layer = "data")
    if (is.null(m)) {
      m <- .db_get_assay_data(sobj, assay = assay_use, layer = "counts")
    }
    validate(need(!is.null(m), sprintf("Assay '%s' has no accessible data for feature plotting.", assay_use)))
    genes <- rownames(m)
    genes <- as.character(genes %||% character(0))
    raw_r <- as.character(input$db_feature_gene_r %||% "")
    raw_g <- as.character(input$db_feature_gene_g %||% "")
    raw_b <- as.character(input$db_feature_gene_b %||% "")
    missing_sel <- unique(c(raw_r, raw_g, raw_b))
    missing_sel <- missing_sel[nzchar(missing_sel) & !(missing_sel %in% genes)]
    if (length(missing_sel)) {
      return(
        ggplot2::ggplot(data.frame(x = 1, y = 1), ggplot2::aes(x = x, y = y)) +
          ggplot2::geom_blank() +
          ggplot2::theme_void() +
          ggplot2::labs(title = sprintf(
            "Feature plot error: gene(s) not found in assay '%s': %s",
            assay_use,
            paste(missing_sel, collapse = ", ")
          ))
      )
    }
    pick <- function(g) {
      g <- as.character(g %||% "")
      if (nzchar(g) && g %in% genes) g else ""
    }
    r_gene <- pick(input$db_feature_gene_r)
    g_gene <- pick(input$db_feature_gene_g)
    b_gene <- pick(input$db_feature_gene_b)
    if (!nzchar(r_gene) && !nzchar(g_gene) && !nzchar(b_gene)) {
      return(
        ggplot2::ggplot(data.frame(x = 1, y = 1), ggplot2::aes(x = x, y = y)) +
          ggplot2::geom_blank() +
          ggplot2::theme_void() +
          ggplot2::labs(title = "Feature plot (RGB): select at least one gene (R/G/B)")
      )
    }
    max_plot_cells <- 80000L
    df_plot <- df
    downsampled <- FALSE
    if (nrow(df_plot) > max_plot_cells) {
      keep_idx <- unique(as.integer(round(seq(1, nrow(df_plot), length.out = max_plot_cells))))
      keep_idx <- keep_idx[keep_idx >= 1L & keep_idx <= nrow(df_plot)]
      df_plot <- df_plot[keep_idx, , drop = FALSE]
      downsampled <- TRUE
    }

    get_expr <- function(gene_name) {
      if (!nzchar(gene_name)) return(rep(0, nrow(df_plot)))
      out <- suppressWarnings(.db_fetch_feature_values(
        sobj = sobj,
        feature = gene_name,
        cells = df_plot$cell,
        assay = assay_use,
        layer = "data"
      ))
      if (!length(out)) out <- rep(0, nrow(df_plot))
      out[!is.finite(out)] <- 0
      out
    }
    expr_r <- get_expr(r_gene)
    expr_g <- get_expr(g_gene)
    expr_b <- get_expr(b_gene)
    df_plot$rgb_color <- .db_rgb_hex(expr_r, expr_g, expr_b)

    ggplot2::ggplot(df_plot, ggplot2::aes(x = dim1, y = dim2)) +
      ggplot2::geom_point(size = 0.45, alpha = 0.9, color = df_plot$rgb_color) +
      ggplot2::coord_fixed() +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::labs(
        x = paste0(red, "_1"),
        y = paste0(red, "_2"),
        title = sprintf(
          "Feature plot RGB (%s): R=%s, G=%s, B=%s%s",
          assay_use,
          if (nzchar(r_gene)) r_gene else "none",
          if (nzchar(g_gene)) g_gene else "none",
          if (nzchar(b_gene)) b_gene else "none",
          if (isTRUE(downsampled)) sprintf(" [downsampled to %s cells]", format(nrow(df_plot), big.mark = ",")) else ""
        )
      )
  }
  .db_build_layer_plot <- function(sobj, df, red, layer_choice, card_title, assay_choice = "__default__", legend_position = "top", legend_columns = 4) {
    choice <- as.character(layer_choice %||% "__none__")
    if (identical(choice, "__none__") || !nzchar(choice)) {
      return(
        ggplot2::ggplot(df, ggplot2::aes(dim1, dim2)) +
          ggplot2::geom_point(size = 0.45, alpha = 0.22, color = "#9CA3AF") +
          ggplot2::coord_fixed() +
          ggplot2::theme_minimal(base_size = 12) +
          ggplot2::labs(x = paste0(red, "_1"), y = paste0(red, "_2"), title = paste0(card_title, ": None selected"))
      )
    }
    if (identical(choice, "__feature_plot__")) return(.db_build_feature_plot(sobj, df, red, assay_choice = assay_choice))
    .db_build_color_plot(
      df,
      red = red,
      color_col = choice,
      title = card_title,
      sobj = sobj,
      legend_position = legend_position,
      legend_columns = legend_columns
    )
  }
  .db_embedding_cached <- reactive({
    sobj <- .active_obj(); req(sobj)
    red <- as.character(input$db_reduction %||% "")
    req(nzchar(red), red %in% names(sobj@reductions))
    .db_embedding_df(sobj, red)
  })

  observeEvent(
    list(shared_data$active_object_name, input$db_layer_1, input$db_layer_2, input$db_layer_1_assay, input$db_layer_2_assay),
    {
      mode <- as.character(input$db_split_mode %||% "group_split")
      if (!identical(mode, "metadata_layers")) return(invisible(NULL))
      if (!identical(as.character(input$db_layer_1 %||% ""), "__feature_plot__") &&
          !identical(as.character(input$db_layer_2 %||% ""), "__feature_plot__")) return(invisible(NULL))
      sobj <- .active_obj()
      if (is.null(sobj)) return(invisible(NULL))
      assays <- Seurat::Assays(sobj)
      if (!length(assays)) return(invisible(NULL))
      default_assay <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "")
      .resolve_assay <- function(choice) {
        aa <- as.character(choice %||% "__default__")
        if (!nzchar(aa) || identical(aa, "__default__") || !(aa %in% assays)) {
          aa <- if (nzchar(default_assay) && default_assay %in% assays) default_assay else assays[[1]]
        }
        aa
      }
      assays_for_feature <- character(0)
      if (identical(as.character(input$db_layer_1 %||% ""), "__feature_plot__")) {
        assays_for_feature <- c(assays_for_feature, .resolve_assay(input$db_layer_1_assay))
      }
      if (identical(as.character(input$db_layer_2 %||% ""), "__feature_plot__")) {
        assays_for_feature <- c(assays_for_feature, .resolve_assay(input$db_layer_2_assay))
      }
      assays_for_feature <- unique(assays_for_feature[nzchar(assays_for_feature)])
      if (!length(assays_for_feature)) return(invisible(NULL))
      gene_sets <- lapply(assays_for_feature, function(assay_name) {
        .db_get_assay_features(sobj, assay = assay_name)
      })
      genes <- unique(unlist(gene_sets, use.names = FALSE))
      if (!length(genes)) return(invisible(NULL))
      keep_r <- as.character(input$db_feature_gene_r %||% "")
      keep_g <- as.character(input$db_feature_gene_g %||% "")
      keep_b <- as.character(input$db_feature_gene_b %||% "")
      if (!keep_r %in% genes) keep_r <- ""
      if (!keep_g %in% genes) keep_g <- ""
      if (!keep_b %in% genes) keep_b <- ""
      wl_update_gene_selectize(session, "db_feature_gene_r", genes, selected = keep_r, server = TRUE)
      wl_update_gene_selectize(session, "db_feature_gene_g", genes, selected = keep_g, server = TRUE)
      wl_update_gene_selectize(session, "db_feature_gene_b", genes, selected = keep_b, server = TRUE)
    },
    ignoreInit = FALSE
  )

  output$db_embedding_preview_ui <- renderUI({
    sobj <- .active_obj()
    if (is.null(sobj)) {
      .db_log("render:db_embedding_preview_ui null active object")
      return(helpText("No active object available."))
    }
    mode <- as.character(input$db_split_mode %||% "group_split")
    if (identical(mode, "metadata_layers")) {
      panel_w <- .db_output_width_px("db_embedding_preview_ui", fallback_px = 960L, min_px = 560L, pad_px = 8L)
      layout_mode <- as.character(input$db_layer_layout %||% "split")
      split_mode <- identical(layout_mode, "split")
      card_w <- if (split_mode) as.integer(max(280L, floor((panel_w - 20L) / 2L))) else as.integer(max(320L, panel_w - 8L))
      h <- as.integer(max(420L, min(1200L, round(card_w * 0.72 + 140L))))
      qh <- max(300L, as.integer(min(900L, round(card_w * 0.52 + 140L))))
      layer1_card <- div(
        class = "db-layer-pair-card",
        tags$h5("Metadata layer 1", style = "margin-top:0;"),
        div(
          class = "db-plot-height-frame",
          style = paste0("height:", h, "px;"),
          plotOutput("db_plot_layer_1", width = "100%", height = "100%")
        ),
        tags$h5("Composition", style = "margin-top:8px;"),
        div(
          class = "db-plot-height-frame",
          style = paste0("height:", qh, "px;"),
          plotly::plotlyOutput("db_quant_plot_1", width = "100%", height = "100%")
        )
      )
      layer2_card <- div(
        class = "db-layer-pair-card",
        tags$h5("Metadata layer 2", style = "margin-top:0;"),
        div(
          class = "db-plot-height-frame",
          style = paste0("height:", h, "px;"),
          plotOutput("db_plot_layer_2", width = "100%", height = "100%")
        ),
        tags$h5("Composition", style = "margin-top:8px;"),
        div(
          class = "db-plot-height-frame",
          style = paste0("height:", qh, "px;"),
          plotly::plotlyOutput("db_quant_plot_2", width = "100%", height = "100%")
        )
      )
      return(
        div(
          class = "db-max-height-frame",
          if (split_mode) {
            fluidRow(
              column(6, layer1_card),
              column(6, layer2_card)
            )
          } else {
            tagList(layer1_card, layer2_card)
          }
        )
      )
    }
    h <- .db_plot_height_px("db_plot_group", min_px = 620L)
    div(
      class = "db-plot-height-frame",
      style = paste0("height:", h, "px;"),
      plotOutput("db_plot_group", width = "100%", height = "100%")
    )
  })

  output$db_quantification_card_ui <- renderUI({
    mode <- as.character(input$db_split_mode %||% "group_split")
    if (identical(mode, "metadata_layers")) return(NULL)
    div(
      class = "wl-side",
      h4("Quantification"),
      uiOutput("db_quantification_ui")
    )
  })

  output$db_quantification_ui <- renderUI({
    sobj <- .active_obj()
    if (is.null(sobj)) {
      .db_log("render:db_quantification_ui null active object")
      return(helpText("No active object available."))
    }
    mode <- as.character(input$db_split_mode %||% "group_split")
    if (identical(mode, "metadata_layers")) {
      helpText("In 'Metadata layers' mode, each layer card includes its own composition plot under the corresponding UMAP.")
    } else {
      plotly::plotlyOutput("db_quant_plot_group", width = "100%", height = "360px")
    }
  })

  output$db_plot_group <- renderPlot({
    w <- session$clientData$output_db_plot_group_width
    h <- session$clientData$output_db_plot_group_height
    req(is.numeric(w), is.numeric(h), w > 20, h > 20)
    req(isTRUE(.db_tab_is_active()))
    t0 <- Sys.time()
    sobj <- .active_obj(); req(sobj)
    red <- as.character(input$db_reduction %||% "")
    req(nzchar(red), red %in% names(sobj@reductions))
    df <- .db_embedding_cached()
    p <- .db_build_color_plot(
      df = df,
      red = red,
      color_col = as.character(input$db_color_col %||% ""),
      split_primary = as.character(input$db_split_by_primary %||% "__none__"),
      split_secondary = as.character(input$db_split_by_secondary %||% "__none__"),
      title = "Group split view",
      sobj = sobj,
      legend_position = as.character(input$db_legend_position %||% "top"),
      legend_columns = suppressWarnings(as.integer(input$db_legend_cols %||% 4L))
    )
    .db_log(
      "perf:db_plot_group",
      "reduction=", red,
      "cells=", nrow(df),
      "elapsed_ms=", as.integer(round(as.numeric(difftime(Sys.time(), t0, units = "secs")) * 1000))
    )
    p
  }, width = .safe_plot_width(session, "db_plot_group"),
     height = .safe_plot_height(session, "db_plot_group"))

  output$db_plot_layer_1 <- renderPlot({
    w <- session$clientData$output_db_plot_layer_1_width
    h <- session$clientData$output_db_plot_layer_1_height
    req(is.numeric(w), is.numeric(h), w > 20, h > 20)
    req(isTRUE(.db_tab_is_active()))
    sobj <- .active_obj(); req(sobj)
    red <- as.character(input$db_reduction %||% "")
    req(nzchar(red), red %in% names(sobj@reductions))
    df <- .db_embedding_cached()
    .db_build_layer_plot(
      sobj, df, red,
      layer_choice = input$db_layer_1,
      card_title = "Metadata layer 1",
      assay_choice = input$db_layer_1_assay,
      legend_position = as.character(input$db_legend_position %||% "top"),
      legend_columns = suppressWarnings(as.integer(input$db_legend_cols %||% 4L))
    )
  }, width = .safe_plot_width(session, "db_plot_layer_1"),
     height = .safe_plot_height(session, "db_plot_layer_1"))

  output$db_plot_layer_2 <- renderPlot({
    w <- session$clientData$output_db_plot_layer_2_width
    h <- session$clientData$output_db_plot_layer_2_height
    req(is.numeric(w), is.numeric(h), w > 20, h > 20)
    req(isTRUE(.db_tab_is_active()))
    sobj <- .active_obj(); req(sobj)
    red <- as.character(input$db_reduction %||% "")
    req(nzchar(red), red %in% names(sobj@reductions))
    df <- .db_embedding_cached()
    .db_build_layer_plot(
      sobj, df, red,
      layer_choice = input$db_layer_2,
      card_title = "Metadata layer 2",
      assay_choice = input$db_layer_2_assay,
      legend_position = as.character(input$db_legend_position %||% "top"),
      legend_columns = suppressWarnings(as.integer(input$db_legend_cols %||% 4L))
    )
  }, width = .safe_plot_width(session, "db_plot_layer_2"),
     height = .safe_plot_height(session, "db_plot_layer_2"))

  output$db_quant_plot_group <- plotly::renderPlotly({
    sobj <- .active_obj(); req(sobj)
    validate(need(requireNamespace("plotly", quietly = TRUE), "Package 'plotly' is required for interactive quantification."))
    red <- as.character(input$db_reduction %||% "")
    req(nzchar(red), red %in% names(sobj@reductions))
    md <- sobj@meta.data
    md$cell <- rownames(md)
    p <- .db_build_quant_plot(
      df = md,
      red = red,
      layer_choice = as.character(input$db_color_col %||% ""),
      card_title = "Group view",
      split_by = as.character(input$db_quant_split_by %||% "__none__"),
      sobj = sobj
    )
    plotly::ggplotly(p, tooltip = c("text", "x", "y")) %>%
      plotly::config(displaylogo = FALSE)
  })

  output$db_quant_plot_1 <- plotly::renderPlotly({
    sobj <- .active_obj(); req(sobj)
    validate(need(requireNamespace("plotly", quietly = TRUE), "Package 'plotly' is required for interactive quantification."))
    red <- as.character(input$db_reduction %||% "")
    req(nzchar(red), red %in% names(sobj@reductions))
    md <- sobj@meta.data
    md$cell <- rownames(md)
    p <- .db_build_quant_plot(
      df = md,
      red = red,
      layer_choice = as.character(input$db_layer_1 %||% "__none__"),
      card_title = "Metadata layer 1",
      split_by = as.character(input$db_quant_split_by %||% "__none__"),
      sobj = sobj
    )
    plotly::ggplotly(p, tooltip = c("text", "x", "y")) %>%
      plotly::config(displaylogo = FALSE)
  })

  output$db_quant_plot_2 <- plotly::renderPlotly({
    sobj <- .active_obj(); req(sobj)
    validate(need(requireNamespace("plotly", quietly = TRUE), "Package 'plotly' is required for interactive quantification."))
    red <- as.character(input$db_reduction %||% "")
    req(nzchar(red), red %in% names(sobj@reductions))
    md <- sobj@meta.data
    md$cell <- rownames(md)
    p <- .db_build_quant_plot(
      df = md,
      red = red,
      layer_choice = as.character(input$db_layer_2 %||% "__none__"),
      card_title = "Metadata layer 2",
      split_by = as.character(input$db_quant_split_by %||% "__none__"),
      sobj = sobj
    )
    plotly::ggplotly(p, tooltip = c("text", "x", "y")) %>%
      plotly::config(displaylogo = FALSE)
  })

  .import_df <- reactiveVal(NULL)
  .import_match <- reactiveVal(data.frame())

  observeEvent(input$db_open_import_modal, {
    showModal(modalDialog(
      title = "Import external metadata",
      size = "l",
      fluidRow(
        column(6, fileInput("db_meta_file", "Metadata file (.csv/.tsv/.txt)", accept = c(".csv", ".tsv", ".txt"))),
        column(6, textInput("db_import_layer_name", "Layer name", value = "external_metadata"))
      ),
      uiOutput("db_import_col_selector_ui"),
      DTOutput("db_import_preview_table"),
      tags$hr(),
      h5("Ambiguity resolution"),
      p(class = "text-muted", "After matching, edit 'chosen_cell' and set decision to accept/resolved for ambiguous rows."),
      DTOutput("db_import_resolution_table"),
      tags$hr(),
      actionButton("db_run_match_btn", "Run barcode matching", class = "btn btn-primary"),
      tags$span(" "),
      actionButton("db_apply_import_btn", "Apply matched metadata", class = "btn btn-success"),
      footer = modalButton("Close"),
      easyClose = TRUE
    ))
  })

  observeEvent(input$db_meta_file, {
    req(input$db_meta_file)
    fp <- input$db_meta_file$datapath
    nm <- tolower(input$db_meta_file$name %||% "")
    df <- tryCatch({
      if (grepl("\\.csv$", nm)) utils::read.csv(fp, stringsAsFactors = FALSE, check.names = FALSE)
      else utils::read.delim(fp, stringsAsFactors = FALSE, check.names = FALSE)
    }, error = function(e) NULL)
    if (is.null(df) || !nrow(df)) {
      showNotification("Could not parse metadata file.", type = "error")
      return()
    }
    .import_df(df)
    .import_match(data.frame())
  }, ignoreInit = TRUE)

  output$db_import_col_selector_ui <- renderUI({
    df <- .import_df()
    if (is.null(df)) return(helpText("Upload a metadata file first."))
    nms <- colnames(df)
    b_guess <- grep("barcode|cell", nms, ignore.case = TRUE, value = TRUE)
    b_def <- if (length(b_guess)) b_guess[[1]] else nms[[1]]
    umap_guess <- .guess_umap_axis_cols(nms)
    cluster_guess <- .guess_cluster_col(nms)
    tagList(
      fluidRow(
        column(4, selectInput("db_import_barcode_col", "Barcode column", choices = nms, selected = b_def)),
        column(4, selectInput("db_import_sample_col", "Sample column (optional)", choices = c("", nms), selected = "")),
        column(4, selectizeInput("db_import_meta_cols", "Metadata columns to import", choices = setdiff(nms, b_def), selected = setdiff(nms, b_def), multiple = TRUE))
      ),
      fluidRow(
        column(4, selectInput("db_import_umap_x_col", "UMAP X column (optional)", choices = c("None" = "", stats::setNames(nms, nms)), selected = umap_guess$x %||% "")),
        column(4, selectInput("db_import_umap_y_col", "UMAP Y column (optional)", choices = c("None" = "", stats::setNames(nms, nms)), selected = umap_guess$y %||% "")),
        column(4, selectInput("db_import_cluster_col", "Cluster column (optional)", choices = c("None" = "", stats::setNames(nms, nms)), selected = cluster_guess %||% ""))
      )
    )
  })

  output$db_import_preview_table <- renderDT({
    df <- .import_df()
    if (is.null(df)) return(datatable(data.frame(note = "No import file loaded yet."), rownames = FALSE, options = list(dom = "t")))
    datatable(
      utils::head(df, 200),
      rownames = FALSE,
      options = list(dom = "t", scrollX = TRUE, pageLength = 8, ordering = FALSE, searching = FALSE, info = FALSE)
    )
  }, server = TRUE)

  observeEvent(input$db_run_match_btn, {
    sobj <- .active_obj(); req(sobj)
    df <- .import_df(); req(df)
    bc_col <- as.character(input$db_import_barcode_col %||% "")
    req(nzchar(bc_col), bc_col %in% colnames(df))

    sample_col <- as.character(input$db_import_sample_col %||% "")
    md <- sobj@meta.data
    cells <- rownames(md)
    key_rows <- lapply(seq_along(cells), function(i) {
      kk <- .barcode_match_keys(cells[[i]])
      if (!length(kk)) return(NULL)
      data.frame(key = kk, cell = cells[[i]], stringsAsFactors = FALSE)
    })
    key_rows <- key_rows[!vapply(key_rows, is.null, logical(1))]
    key_df <- if (length(key_rows)) do.call(rbind, key_rows) else data.frame(key = character(0), cell = character(0), stringsAsFactors = FALSE)
    key_index <- if (nrow(key_df)) split(key_df$cell, key_df$key) else list()

    sample_md_col <- c("orig.ident", "sample", "condition")
    sample_md_col <- sample_md_col[sample_md_col %in% colnames(md)]
    sample_md_col <- if (length(sample_md_col)) sample_md_col[[1]] else ""

    out <- vector("list", nrow(df))
    for (i in seq_len(nrow(df))) {
      bc <- as.character(df[[bc_col]][i] %||% "")
      keys <- .barcode_match_keys(bc)
      raw <- .extract_raw_barcode(bc)
      if (!nzchar(raw)) raw <- bc
      cands <- unique(unlist(lapply(keys, function(k) as.character(key_index[[k]] %||% character(0))), use.names = FALSE))
      cands <- cands[nzchar(cands)]
      if (length(cands)) {
        score <- rep(0L, length(cands))
        score[cands == bc] <- score[cands == bc] + 4L
        score[.strip_suffix(cands) == .strip_suffix(bc)] <- score[.strip_suffix(cands) == .strip_suffix(bc)] + 2L
        cands <- cands[order(score, cands, decreasing = TRUE)]
      }

      in_sample <- if (nzchar(sample_col) && sample_col %in% colnames(df)) as.character(df[[sample_col]][i] %||% "") else ""
      if (length(cands) > 1L && nzchar(sample_col) && sample_col %in% colnames(df) && nzchar(in_sample) && nzchar(sample_md_col)) {
        keep <- as.character(md[cands, sample_md_col]) == in_sample
        cands <- cands[keep]
      }

      status <- if (!length(cands)) "unresolved" else if (length(cands) == 1L) "matched" else "ambiguous"
      chosen <- if (length(cands) == 1L) cands[[1]] else ""
      out[[i]] <- data.frame(
        row_id = i,
        input_barcode = bc,
        barcode_raw = raw,
        candidate_cells = paste(utils::head(cands, 8), collapse = ";"),
        chosen_cell = chosen,
        status = status,
        decision = if (identical(status, "matched")) "accept" else "review",
        stringsAsFactors = FALSE
      )
    }

    mdf <- do.call(rbind, out)
    .import_match(mdf)
    db_latest_import(mdf)
    showNotification(sprintf("Match complete: %d matched, %d ambiguous, %d unresolved.",
                             sum(mdf$status == "matched"),
                             sum(mdf$status == "ambiguous"),
                             sum(mdf$status == "unresolved")), type = "message")
  }, ignoreInit = TRUE)

  output$db_import_match_table <- renderDT({
    m <- db_latest_import()
    if (!is.data.frame(m) || !nrow(m)) {
      return(datatable(data.frame(note = "No import matching has been run yet."), rownames = FALSE, options = list(dom = "t")))
    }
    datatable(
      m,
      rownames = FALSE,
      options = list(dom = "t", scrollX = TRUE, pageLength = 8, ordering = FALSE, searching = FALSE, info = FALSE)
    )
  }, server = TRUE)

  output$db_import_resolution_table <- renderDT({
    m <- .import_match()
    if (!is.data.frame(m) || !nrow(m)) {
      return(datatable(data.frame(note = "Run barcode matching first."), rownames = FALSE, options = list(dom = "t")))
    }
    need_cols <- c("row_id", "input_barcode", "candidate_cells", "chosen_cell", "status", "decision")
    missing_cols <- setdiff(need_cols, colnames(m))
    if (length(missing_cols)) {
      for (cn in missing_cols) m[[cn]] <- NA_character_
      .db_log("render:db_import_resolution_table repaired_missing_cols", paste(missing_cols, collapse = ","))
    }
    m <- m[, need_cols, drop = FALSE]
    datatable(
      m,
      rownames = FALSE,
      editable = list(target = "cell", disable = list(columns = c(0, 1, 2, 4))),
      options = list(dom = "t", scrollX = TRUE, pageLength = 8, ordering = FALSE, searching = FALSE, info = FALSE)
    )
  }, server = TRUE)

  observeEvent(input$db_import_resolution_table_cell_edit, {
    info <- input$db_import_resolution_table_cell_edit
    m <- .import_match(); req(is.data.frame(m), nrow(m))
    i <- info$row
    j <- info$col + 1L
    cols <- c("row_id", "input_barcode", "candidate_cells", "chosen_cell", "status", "decision")
    req(i >= 1, i <= nrow(m), j >= 1, j <= length(cols))
    target <- cols[[j]]
    if (!target %in% c("chosen_cell", "decision")) return(invisible(NULL))
    val <- as.character(info$value %||% "")
    if (identical(target, "decision")) {
      allowed <- c("accept", "resolved", "drop", "review")
      if (!val %in% allowed) {
        showNotification("Decision must be one of: accept, resolved, drop, review.", type = "warning")
        return(invisible(NULL))
      }
    }
    m[i, target] <- val
    .import_match(m)
  }, ignoreInit = TRUE)

  observeEvent(input$db_apply_import_btn, {
    sobj <- .active_obj(); req(sobj)
    nm <- .active_name(); req(nzchar(nm))
    raw_df <- .import_df(); req(raw_df)
    mdf <- .import_match(); req(is.data.frame(mdf), nrow(mdf) > 0)

    # Strict mode: only explicitly accepted/resolved rows are applied.
    keep <- mdf$decision %in% c("accept", "resolved")
    mdf2 <- mdf[keep, , drop = FALSE]
    mdf2 <- mdf2[nzchar(as.character(mdf2$chosen_cell)), , drop = FALSE]
    req(nrow(mdf2) > 0)

    meta_cols <- as.character(input$db_import_meta_cols %||% character(0))
    if (!length(meta_cols)) {
      meta_cols <- setdiff(colnames(raw_df), as.character(input$db_import_barcode_col %||% ""))
    }
    meta_cols <- meta_cols[meta_cols %in% colnames(raw_df)]

    umap_x_col <- .scalar_chr(input$db_import_umap_x_col, default = "")
    umap_y_col <- .scalar_chr(input$db_import_umap_y_col, default = "")
    cluster_col <- .scalar_chr(input$db_import_cluster_col, default = "")
    special_cols <- unique(c(
      if (nzchar(umap_x_col)) umap_x_col else character(0),
      if (nzchar(umap_y_col)) umap_y_col else character(0),
      if (nzchar(cluster_col)) cluster_col else character(0)
    ))
    special_cols <- special_cols[special_cols %in% colnames(raw_df)]
    meta_cols <- unique(c(meta_cols, special_cols))
    req(length(meta_cols) > 0 || length(special_cols) > 0)

    joined <- merge(mdf2, cbind(row_id = seq_len(nrow(raw_df)), raw_df), by = "row_id", all.x = TRUE, sort = FALSE)
    layer_df <- data.frame(cell = as.character(joined$chosen_cell), status = as.character(joined$status), stringsAsFactors = FALSE)
    for (cn in meta_cols) layer_df[[cn]] <- as.character(joined[[cn]])

    # Promote Loupe-exported columns into directly usable metadata/reduction slots.
    md <- sobj@meta.data
    applied_bits <- character(0)
    if (nzchar(cluster_col) && cluster_col %in% colnames(joined)) {
      out_cluster_col <- .ensure_unique_col(md, paste0("loupe_", .sanitize_id(cluster_col)))
      md[[out_cluster_col]] <- NA_character_
      vec_cluster <- as.character(joined[[cluster_col]])
      names(vec_cluster) <- as.character(joined$chosen_cell)
      vec_cluster <- vec_cluster[names(vec_cluster) %in% rownames(md)]
      md[names(vec_cluster), out_cluster_col] <- vec_cluster
      applied_bits <- c(applied_bits, sprintf("cluster -> %s", out_cluster_col))
    }
    if (nzchar(umap_x_col) && nzchar(umap_y_col) && umap_x_col %in% colnames(joined) && umap_y_col %in% colnames(joined)) {
      out_x <- .ensure_unique_col(md, "loupe_umap_x")
      out_y <- .ensure_unique_col(md, "loupe_umap_y")
      md[[out_x]] <- NA_real_
      md[[out_y]] <- NA_real_
      vx <- suppressWarnings(as.numeric(joined[[umap_x_col]]))
      vy <- suppressWarnings(as.numeric(joined[[umap_y_col]]))
      nm_cells <- as.character(joined$chosen_cell)
      names(vx) <- nm_cells
      names(vy) <- nm_cells
      keep <- names(vx) %in% rownames(md)
      if (any(keep)) {
        md[names(vx)[keep], out_x] <- vx[keep]
        md[names(vy)[keep], out_y] <- vy[keep]
      }

      emb_df <- data.frame(cell = nm_cells, x = vx, y = vy, stringsAsFactors = FALSE)
      emb_df <- emb_df[is.finite(emb_df$x) & is.finite(emb_df$y) & emb_df$cell %in% rownames(md), , drop = FALSE]
      emb_df <- emb_df[!duplicated(emb_df$cell), , drop = FALSE]
      if (nrow(emb_df) >= 2) {
        emb <- as.matrix(emb_df[, c("x", "y"), drop = FALSE])
        rownames(emb) <- emb_df$cell
        colnames(emb) <- c("LOUPEUMAP_1", "LOUPEUMAP_2")
        def_assay <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "RNA")
        sobj[["loupe_umap"]] <- Seurat::CreateDimReducObject(
          embeddings = emb,
          key = "LOUPEUMAP_",
          assay = def_assay
        )
        applied_bits <- c(applied_bits, "reduction -> loupe_umap")
      }
    }
    sobj@meta.data <- md
    entry <- shared_data$all_seurat_objects[[nm]]
    shared_data$all_seurat_objects[[nm]] <- .as_canonical_entry(entry, sobj = sobj)

    layer_name <- as.character(input$db_import_layer_name %||% "external_metadata")
    .apply_user_layer(
      nm,
      layer_name = layer_name,
      cell_df = layer_df,
      source = "import",
      params = list(
        meta_cols = meta_cols,
        umap_x_col = umap_x_col,
        umap_y_col = umap_y_col,
        cluster_col = cluster_col,
        applied = applied_bits
      )
    )
    db_latest_import(mdf)
    extra <- if (length(applied_bits)) paste0(" (", paste(applied_bits, collapse = "; "), ")") else ""
    showNotification(sprintf("Applied import layer '%s' with %d matched rows%s.", layer_name, nrow(layer_df), extra), type = "message")
    removeModal()
  }, ignoreInit = TRUE)
  for (id in c(
    "db_embedding_preview_ui",
    "db_quantification_ui",
    "db_meta_table"
  )) {
    outputOptions(output, id, suspendWhenHidden = FALSE)
  }
}
