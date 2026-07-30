UI_TEXT <- list(
  t_btn_apply_filter_add_workspace = "Apply filter & add to workspace",
  t_btn_import_vdj = "Import VDJ",
  t_btn_view_diagnostics = "View diagnostics",
  t_label_blue_channel = "Blue channel",
  t_label_feature = "Feature:",
  t_label_green_channel = "Green channel",
  t_label_minimum_clone_size = "Minimum clone size",
  t_label_object = "Object:",
  t_label_operation = "Operation:",
  t_label_red_channel = "Red channel",
  t_label_upload_vdj_file_s_csv_tsv = "Upload VDJ file(s) (.csv/.tsv)",
  t_text_import_vdj_sequencing_results_map_expanded = "Import VDJ sequencing results, map expanded clones to cells, visualize with confocal UMAP, and filter by TCR/BCR clone expansion.",
  t_text_type_gene = "Type gene...",
  t_text_umap_1 = "UMAP 1",
  t_text_umap_2 = "UMAP 2",
  t_title_confocal_rgb_umap = "Confocal RGB UMAP",
  t_title_confocal_umap = "Confocal UMAP",
  t_title_file_sample_matching = "File-to-sample matching",
  t_title_filtering = "Filtering",
  t_title_qc_vdj_integration_tcr_bcr = "QC: VDJ Integration (TCR/BCR)",
  t_title_vdj_clone_overlay = "VDJ clone overlay",
  t_title_vdj_input = "VDJ Input",
  t_text_applying_vdj_filter_and_creating_workspace_object = "Applying VDJ filter and creating workspace object…",
  t_text_all_object_samples_matched_imported_vdj_files = "All object samples are matched by imported VDJ files.",
  t_text_diagnostics_note = "Diagnostics reflect the currently selected object and its attached VDJ metadata.",
  t_title_vdj_relink_required = "VDJ relink required",
  t_text_vdj_relink_required_prefix = "This object has no linked VDJ package data: ",
  t_text_vdj_relink_required_suffix = ". Import/relink VDJ now to continue VDJ-specific operations.",
  t_text_unmatched_samples_prefix = "Unmatched samples: ",
  t_text_no_genes_available = "No genes available.",
  t_title_per_sample_vdj_summary = "Per-sample VDJ Summary",
  t_title_vdj_barcode_diagnostics = "VDJ/Barcode Diagnostics"

)

library(shiny)
library(shinyjs)
library(plotly)
library(shinycssloaders)

`%||%` <- function(a, b) if (is.null(a)) b else a

.vdj_get_assay_data <- function(sobj, assay = NULL, layer = "data") {
  aa <- as.character(assay %||% "")
  if (!nzchar(aa)) aa <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
  ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
  use_layer <- "layer" %in% ga_formals
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

.vdj_rgb_hex <- function(a, b, c) {
  .scale <- function(x) {
    x <- suppressWarnings(as.numeric(x))
    x[!is.finite(x)] <- NA_real_
    q <- suppressWarnings(stats::quantile(x, 0.99, na.rm = TRUE))
    if (is.finite(q)) x <- pmin(x, q)
    rng <- range(x, na.rm = TRUE)
    if (!all(is.finite(rng)) || diff(rng) == 0) return(rep(0, length(x)))
    (x - rng[1]) / diff(rng)
  }
  R <- .scale(a); G <- .scale(b); B <- .scale(c)
  cols <- grDevices::rgb(R, G, B, alpha = 0.9)
  cols[!is.finite(R) | !is.finite(G) | !is.finite(B)] <- "#00000012"
  cols
}

vdj_ui <- fluidPage(
  tags$head(tags$style(HTML("
    .vdj-panel-stack .well { margin-bottom: 14px; }
    .vdj-panel-stack .well {
      padding: 19px 19px 16px 19px;
      border-radius: 10px;
    }
    .vdj-panel-stack h4 { margin-top: 0; margin-bottom: 10px; }
    .vdj-panel-stack h5 { margin-top: 8px; margin-bottom: 8px; }
    .vdj-panel-stack .control-label { font-size: 14px; margin-bottom: 4px; }
    .vdj-panel-stack .form-control,
    .vdj-panel-stack .selectize-input,
    .vdj-panel-stack .btn { font-size: 14px; }
    .vdj-panel-stack .selectize-input { min-height: 34px; padding-top: 5px; padding-bottom: 5px; }
    .vdj-main-row { margin-bottom: 14px; }
    .vdj-status-wrap { margin-bottom: 6px; }
    .vdj-top-gap { margin-top: 10px; }
    .vdj-plot-row {
      margin-top: 6px;
      display: flex;
      flex-wrap: wrap;
      align-items: stretch;
    }
    .vdj-plot-col {
      margin-bottom: 10px;
      display: flex;
      float: none !important;
    }
    .vdj-plot-box {
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
    }
    .vdj-plot-canvas { flex: 1 1 auto; }
    .vdj-plot-title { margin: 0 0 6px 0; font-size: 24px; }
    .vdj-no-box { background: transparent !important; border: 0 !important; box-shadow: none !important; padding: 0 !important; }
    .vdj-param-shell { margin-bottom: 8px; }
    .vdj-param-title { margin: 0 0 8px 0; }
    .vdj-param-row {
      display: flex;
      flex-wrap: wrap;
      align-items: stretch;
      margin-left: -10px;
      margin-right: -10px;
    }
    .vdj-param-col {
      float: none !important;
      display: flex;
      padding-left: 10px;
      padding-right: 10px;
    }
    .vdj-param-right { border-left: 0 !important; }
    .vdj-param-box {
      width: 100%;
      margin: 0;
      min-height: 100%;
    }
    .vdj-param-box .control-label { font-weight: 600; color: #111827; }
    .vdj-object-picker .form-group { margin-bottom: 0 !important; }
    .vdj-notes { margin-top: 0 !important; margin-bottom: 10px; }
    .vdj-match-title { margin-top: 10px; margin-bottom: 8px; }
    .vdj-match-cards { margin-bottom: 8px; }
    .vdj-file-card { margin-bottom: 8px; }
    .vdj-file-card:last-child { margin-bottom: 0; }
    .vdj-file-kv { margin: 2px 0; color: #334155; font-size: 13px; }
    .vdj-import-label { margin-top: 8px; margin-bottom: 6px; }
    .vdj-import-group { margin-top: 8px; }
    .vdj-import-group .form-group { margin-bottom: 6px !important; }
    .vdj-import-btn-wrap { margin-top: 0 !important; }
    .vdj-import-btn {
      width: 100%;
      min-height: 40px;
      padding: 8px 12px;
      font-size: 16px;
      font-weight: 600;
    }
    .vdj-confocal-note { margin: 0 0 6px 0; color: #6b7280; font-size: 11px; line-height: 1.3; }
    .vdj-overlay-controls { margin-bottom: 4px; }
    .vdj-overlay-controls .form-group { margin-bottom: 6px; }
    .vdj-controls-equal {
      min-height: 132px;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
    }
    .vdj-small-slider { max-width: 280px; }
    .vdj-small-slider .irs--shiny { margin-top: 2px; margin-bottom: 0; }
    .vdj-small-slider .irs--shiny .irs { height: 30px; }
    .vdj-small-slider .irs--shiny .irs-line { top: 18px; }
    .vdj-small-slider .irs--shiny .irs-bar { top: 18px; }
    .vdj-small-slider .irs--shiny .irs-handle { top: 10px; }
    .vdj-small-slider .irs--shiny .irs-single {
      top: -8px;
      z-index: 6;
    }
    .vdj-small-slider .irs--shiny .irs-grid { display: none !important; }
    .vdj-overlay-controls .control-label { font-size: 16px; margin-bottom: 3px; }
    .vdj-overlay-controls .radio { margin-top: 1px; margin-bottom: 2px; }
    .vdj-overlay-controls .radio label { font-size: 14px; line-height: 1.25; }
    .vdj-plot-box .control-label { font-size: 14px; margin-bottom: 3px; }
    .vdj-plot-box .selectize-input { min-height: 34px; padding: 5px 10px; }
    .vdj-plot-box .selectize-input > input,
    .vdj-plot-box .selectize-input .item { font-size: 14px; line-height: 18px; }
    .vdj-plot-box .selectize-dropdown { font-size: 13px; }
    .vdj-match-title { font-size: 20px; }
    .vdj-file-card > div:first-child { font-size: 13px; line-height: 1.2; word-break: break-word; overflow-wrap: anywhere; }
    .vdj-file-kv { font-size: 11px; line-height: 1.2; }
    .vdj-file-card { padding: 7px 9px; margin-bottom: 6px; }
    .vdj-notes { font-size: 11px; margin-bottom: 6px; }
    .vdj-import-label { font-size: 12px; margin-top: 4px; margin-bottom: 3px; }
    .vdj-overlay-note { margin: -2px 0 6px 0; color: #6b7280; font-size: 11px; line-height: 1.3; }
    .vdj-import-help { margin-top: 4px; margin-bottom: 4px; color: #6b7280; font-size: 11px; line-height: 1.22; }
    .vdj-import-help-line { margin: 0 0 2px 0; }
    .vdj-import-help-line:last-child { margin-bottom: 0; }
    .vdj-unmatched-fold { margin-top: 6px; }
    .vdj-unmatched-fold summary { cursor: pointer; color: #a16207; font-size: 12px; }
    .vdj-upload-map-row { margin-bottom: 8px; }
    .vdj-upload-map-file { font-size: 13px; color: #0f172a; word-break: break-word; }
  "))),
  div(
    class = "page-header",
    h2(icon("database"), " ", UI_TEXT$t_title_qc_vdj_integration_tcr_bcr),
    p(UI_TEXT$t_text_import_vdj_sequencing_results_map_expanded)
  ),
  div(class = "vdj-status-wrap", uiOutput("vdj_import_status_ui")),
  fluidRow(
    column(
      3,
      class = "vdj-panel-stack",
      wellPanel(
        h4(UI_TEXT$t_title_vdj_input),
        div(class = "vdj-object-picker", uiOutput("vdj_object_picker_ui")),
        div(
          class = "text-muted vdj-notes",
          tags$small(
            "Expected columns: barcode + clonotype (raw_clonotype_id/clonotype_id/clone_id/cdr3). ",
            "Optional: chain/locus and sample/orig.ident."
          )
        ),
        h5(class = "vdj-match-title", UI_TEXT$t_title_file_sample_matching),
        uiOutput("vdj_edit_match_btn_ui"),
        tags$hr(style = "margin:10px 0;"),
        h5("Import VDJ"),
        div(class = "vdj-import-label", UI_TEXT$t_label_upload_vdj_file_s_csv_tsv),
        div(
          class = "vdj-import-help",
          tags$div(class = "vdj-import-help-line", tags$small("Typical file names: filtered_contig_annotations.csv or all_contig_annotations.csv.")),
          tags$div(class = "vdj-import-help-line", tags$small("Also accepted: *_tcr_contigs and *_bcr_contigs.")),
          tags$div(class = "vdj-import-help-line", tags$small("Matching order: sample/orig.ident column, then right-panel sample tag/path (per_sample_outs/<sample>), then filename token.")),
          tags$div(class = "vdj-import-help-line", tags$small("Files can come from different paths.")),
          tags$div(class = "vdj-import-help-line", tags$small("To control matching, include a sample column or use the Edit matching button after import."))
        ),
        div(class = "vdj-import-group", fileInput("vdj_file", NULL, accept = c(".csv", ".tsv", ".txt"), multiple = TRUE)),
        div(class = "vdj-import-btn-wrap", actionButton("vdj_import_btn", UI_TEXT$t_btn_import_vdj, class = "btn btn-primary vdj-import-btn")),
        tags$hr(style = "margin:10px 0;"),
        h5("Prefix/Suffix-aware VDJ Rewrite"),
        uiOutput("vdj_rewrite_file_picker_ui"),
        actionButton("vdj_rewrite_btn", "Rewrite + Import to Object", class = "btn btn-default btn-sm", style = "width:100%;"),
        div(style = "margin-top:8px;", uiOutput("vdj_rewrite_status_ui")),
        div(style = "margin-top:8px;", uiOutput("vdj_rewrite_cards_ui")),
        actionButton("vdj_show_diagnostics_btn", UI_TEXT$t_btn_view_diagnostics, class = "btn btn-default btn-sm", style = "width:100%; margin-top:8px;")
      ),
      wellPanel(
        h4(UI_TEXT$t_title_filtering),
        actionButton("vdj_apply_meta_btn", "Apply VDJ metadata to selected object", class = "btn btn-primary btn-sm", style = "width:100%; min-height:42px; font-weight:700; margin-bottom:8px;"),
        radioButtons("vdj_filter_mode", UI_TEXT$t_label_operation, choices = c("Keep cells with expanded clones" = "keep", "Remove cells with expanded clones" = "remove"), selected = "keep"),
        actionButton("vdj_apply_filter_btn", UI_TEXT$t_btn_apply_filter_add_workspace, class = "btn btn-success btn-sm", style = "width:100%; min-height:42px; font-weight:700;")
      ),
      div(class = "vdj-top-gap")
    ),
    column(
      9,
      class = "plot_area_card_style",
      fluidRow(
        class = "vdj-main-row",
        column(
          12,
          fluidRow(
            class = "vdj-plot-row",
            column(
              6,
              class = "vdj-plot-col",
              div(class = "hto-heatmap-box vdj-plot-box",
                  h4(class = "vdj-plot-title", UI_TEXT$t_title_vdj_clone_overlay),
                  div(
                    class = "vdj-controls-equal",
                    div(class = "vdj-overlay-note", "Please verify the gene-expression pattern in the panel on the right to confirm that the correct VDJ files are attached."),
                    fluidRow(
                      class = "vdj-overlay-controls",
                      column(
                        6,
                        radioButtons(
                          "vdj_filter_feature",
                          UI_TEXT$t_label_feature,
                          choices = c("TCR expanded clones" = "tcr", "BCR expanded clones" = "bcr"),
                          selected = "tcr"
                        )
                      ),
                      column(
                        6,
                        div(
                          class = "vdj-small-slider",
                          sliderInput("vdj_clone_threshold", UI_TEXT$t_label_minimum_clone_size, min = 1, max = 50, value = 2, step = 1)
                        )
                      )
                    )
                  ),
                  div(class = "vdj-plot-canvas", qc_with_busy_spinner(plotlyOutput("vdj_feature_umap_plot", height = "410px"))))
            ),
            column(
              6,
              class = "vdj-plot-col",
              div(class = "hto-heatmap-box vdj-plot-box",
                  h4(class = "vdj-plot-title", UI_TEXT$t_title_confocal_rgb_umap),
                  div(
                    class = "vdj-controls-equal",
                    uiOutput("vdj_confocal_note_ui"),
                    fluidRow(
                      column(
                        4,
                        wl_gene_selectize_input("vdj_gene_r", UI_TEXT$t_label_red_channel, placeholder = UI_TEXT$t_text_type_gene)
                      ),
                      column(
                        4,
                        wl_gene_selectize_input("vdj_gene_g", UI_TEXT$t_label_green_channel, placeholder = UI_TEXT$t_text_type_gene)
                      ),
                      column(
                        4,
                        wl_gene_selectize_input("vdj_gene_b", UI_TEXT$t_label_blue_channel, placeholder = UI_TEXT$t_text_type_gene)
                      )
                    )
                  ),
                  div(class = "vdj-plot-canvas", qc_with_busy_spinner(plotlyOutput("vdj_confocal_umap_plot", height = "410px"))))
            )
          )
        ),
        column(
          12,
          div(
            class = "hto-heatmap-box",
            h4("File-to-sample matching"),
            tableOutput("vdj_match_table"),
            uiOutput("vdj_unmatched_samples_ui"),
            tags$div(
              class = "text-muted",
              style = "font-size:12px; margin-top:8px;",
              "Barcode match status guide: ",
              tags$b("unknown"), " = barcode was not found in this object; ",
              tags$b("0"), " = barcode matched this object but no clonotype was detected for that chain."
            )
          )
        )
      )
    )
  )
)

vdj_server <- function(input, output, session, shared_data) {
  .vdj_debug <- TRUE
  .vdj_log <- function(...) {
    if (!isTRUE(.vdj_debug)) return(invisible(NULL))
    msg <- paste(..., collapse = " ")
    cat(sprintf("[VDJ-DEBUG][page][%s] %s\n", format(Sys.time(), "%H:%M:%S"), msg))
    flush.console()
    invisible(NULL)
  }

  .get_entry <- reactive({
    nm <- input$vdj_object_name %||% shared_data$active_object_name
    req(nm)
    shared_data$all_seurat_objects[[nm]]
  })
  .get_obj <- reactive({
    e <- .get_entry(); req(e)
    if (inherits(e, "Seurat")) return(e)
    if (is.list(e) && !is.null(e$obj) && inherits(e$obj, "Seurat")) return(e$obj)
    if (is.list(e) && !is.null(e$seurat_obj) && inherits(e$seurat_obj, "Seurat")) return(e$seurat_obj)
    if (is.list(e) && !is.null(e$seurat) && inherits(e$seurat, "Seurat")) return(e$seurat)
    if (is.list(e) && !is.null(e$object) && inherits(e$object, "Seurat")) return(e$object)
    NULL
  })

  .get_workspace_vdj_payload <- function(nm, sobj = NULL) {
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    if (is.list(entry) && is.list(entry$vdj_payload)) return(entry$vdj_payload)
    # Backward compatibility for old sessions:
    # 1) Seurat tools slot
    if (!is.null(sobj)) {
      p <- tryCatch(sobj@tools$vdj_payload, error = function(e) NULL)
      if (is.list(p)) return(p)
      # 2) legacy misc slot
      legacy <- tryCatch(sobj@misc$vdj, error = function(e) NULL)
      if (is.list(legacy)) return(legacy)
    }
    list()
  }

  .set_workspace_entry <- function(nm, sobj, vdj_payload = NULL) {
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    if (is.null(entry) || inherits(entry, "Seurat")) {
      entry <- list(obj = sobj)
    } else {
      if (!is.list(entry)) entry <- list(obj = sobj)
      entry$obj <- sobj
    }
    if (exists("wanlab_canonicalize_object_entry", mode = "function", inherits = TRUE)) {
      entry <- tryCatch(wanlab_canonicalize_object_entry(entry), error = function(e) entry)
    }
    if (is.null(entry) || !is.list(entry)) {
      entry <- list(obj = sobj, prefs = list(), plots = list(), analysis_cache = list())
      if (is.null(entry$meta) || !is.list(entry$meta)) entry$meta <- list()
      if (is.null(entry$meta$linked_files) || !is.list(entry$meta$linked_files)) entry$meta$linked_files <- list()
      if (is.null(entry$meta$linked_files$vdj) || !is.data.frame(entry$meta$linked_files$vdj)) {
        entry$meta$linked_files$vdj <- data.frame(chain = character(0), source_name = character(0), stringsAsFactors = FALSE)
      }
    }
    if (is.list(vdj_payload)) entry$vdj_payload <- vdj_payload
    shared_data$all_seurat_objects[[nm]] <- entry
    invisible(NULL)
  }
  .object_has_vdj_links <- function(nm) {
    if (!nzchar(as.character(nm %||% ""))) return(FALSE)
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    if (is.null(entry)) return(FALSE)
    sobj <- NULL
    if (inherits(entry, "Seurat")) sobj <- entry
    if (is.null(sobj) && is.list(entry) && !is.null(entry$obj) && inherits(entry$obj, "Seurat")) sobj <- entry$obj
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(FALSE)

    linked <- tryCatch(entry$meta$linked_files$vdj, error = function(e) NULL)
    has_link_rows <- is.data.frame(linked) && nrow(linked) > 0

    md <- tryCatch(sobj@meta.data, error = function(e) NULL)
    has_vdj_cols <- is.data.frame(md) && nrow(md) && all(c("vdj_tcr_pos", "vdj_bcr_pos", "vdj_tcr_clone", "vdj_bcr_clone", "vdj_tcr_clone_size", "vdj_bcr_clone_size") %in% colnames(md))

    payload <- tryCatch(entry$vdj_payload, error = function(e) NULL)
    has_payload_records <- is.list(payload) && is.data.frame(payload$records) && nrow(payload$records) > 0

    # Real metadata columns are authoritative, even when values are all zero.
    isTRUE(has_vdj_cols || (has_link_rows && has_payload_records))
  }
  .object_missing_vdj_sources <- function(nm) {
    if (!nzchar(as.character(nm %||% ""))) return(character(0))
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    if (!is.list(entry)) return(character(0))
    sobj <- tryCatch(if (is.list(entry) && !is.null(entry$obj)) entry$obj else NULL, error = function(e) NULL)
    md <- tryCatch(if (!is.null(sobj) && inherits(sobj, "Seurat")) sobj@meta.data else NULL, error = function(e) NULL)
    has_vdj_cols <- is.data.frame(md) && nrow(md) && all(c("vdj_tcr_pos", "vdj_bcr_pos", "vdj_tcr_clone", "vdj_bcr_clone", "vdj_tcr_clone_size", "vdj_bcr_clone_size") %in% colnames(md))
    if (isTRUE(has_vdj_cols)) return(character(0))
    linked <- tryCatch(entry$meta$linked_files$vdj, error = function(e) NULL)
    if (!is.data.frame(linked) || !nrow(linked)) return(character(0))
    src_col <- if ("source_name" %in% names(linked)) "source_name" else if ("path" %in% names(linked)) "path" else ""
    if (!nzchar(src_col)) return(character(0))
    expected <- as.character(linked[[src_col]] %||% character(0))
    expected <- basename(expected[!is.na(expected) & nzchar(expected)])
    if (!length(expected)) return(character(0))
    payload <- tryCatch(entry$vdj_payload, error = function(e) NULL)
    loaded <- as.character(payload$source_file %||% character(0))
    loaded <- basename(loaded[!is.na(loaded) & nzchar(loaded)])
    if (!length(loaded) && is.data.frame(payload$records) && nrow(payload$records) && "source_file" %in% names(payload$records)) {
      loaded <- basename(as.character(payload$records$source_file %||% character(0)))
      loaded <- loaded[!is.na(loaded) & nzchar(loaded)]
    }
    resolved <- as.character(payload$resolved_expected_sources %||% character(0))
    resolved <- resolved[!is.na(resolved) & nzchar(resolved)]
    empty_ok <- as.character(payload$missing_sources_empty_ok %||% character(0))
    empty_ok <- empty_ok[!is.na(empty_ok) & nzchar(empty_ok)]
    expected_key <- tolower(gsub("\\\\", "/", expected))
    expected_name <- basename(expected)
    resolved_name <- basename(tolower(gsub("\\\\", "/", resolved)))
    empty_name <- basename(tolower(gsub("\\\\", "/", empty_ok)))
    keep <- !(expected_key %in% resolved | expected_name %in% resolved_name | expected_key %in% tolower(gsub("\\\\", "/", empty_ok)) | expected_name %in% empty_name)
    expected <- expected[keep]
    if (!length(expected)) return(character(0))
    missing <- setdiff(unique(expected), unique(loaded))
    missing[nzchar(missing)]
  }
  .vdj_try_auto_import_from_relink <- function(nm) {
    if (!nzchar(as.character(nm %||% ""))) return(invisible(FALSE))
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    if (!is.list(entry)) return(invisible(FALSE))
    sobj <- .get_obj()
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(invisible(FALSE))
    payload <- tryCatch(entry$vdj_payload, error = function(e) NULL)
    if (!is.list(payload)) return(invisible(FALSE))
    if (is.data.frame(payload$records) && nrow(payload$records)) return(invisible(FALSE))
    relinked <- payload$relinked_files
    if (!is.data.frame(relinked) || !nrow(relinked)) return(invisible(FALSE))
    if (!all(c("source_path", "source_name") %in% names(relinked))) return(invisible(FALSE))
    relinked$source_path <- as.character(relinked$source_path %||% "")
    relinked$source_name <- as.character(relinked$source_name %||% "")
    relinked <- relinked[nzchar(relinked$source_path) & file.exists(relinked$source_path), , drop = FALSE]
    if (!nrow(relinked)) return(invisible(FALSE))
    file_df <- data.frame(
      name = ifelse(nzchar(relinked$source_name), relinked$source_name, basename(relinked$source_path)),
      datapath = relinked$source_path,
      sample_hint = character(nrow(relinked)),
      force_sample = character(nrow(relinked)),
      stringsAsFactors = FALSE
    )
    ok <- tryCatch(.import_vdj_files(file_df, source_tag = "rds_relink_auto"), error = function(e) FALSE)
    if (isTRUE(ok)) {
      showNotification("Auto-imported relinked VDJ files from workspace metadata.", type = "message", duration = 6)
      return(invisible(TRUE))
    }
    invisible(FALSE)
  }
  .cleanup_vdj_temp_state <- function(nm) {
    entry <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    if (is.null(entry)) return(invisible(FALSE))
    sobj <- NULL
    if (inherits(entry, "Seurat")) sobj <- entry
    if (is.null(sobj) && is.list(entry) && !is.null(entry$obj) && inherits(entry$obj, "Seurat")) sobj <- entry$obj
    if (is.null(sobj) || !inherits(sobj, "Seurat")) return(invisible(FALSE))
    md <- tryCatch(sobj@meta.data, error = function(e) NULL)
    if (is.null(md) || !is.data.frame(md) || !nrow(md)) return(invisible(FALSE))

    drop_cols <- grepl("^(vdj_tmp_|barcode_tmp_)", colnames(md)) |
      colnames(md) %in% c("barcode_core_tmp", "barcode_norm_tmp", "vdj_match_tmp")
    if (!any(drop_cols)) return(invisible(FALSE))
    md <- md[, !drop_cols, drop = FALSE]
    sobj@meta.data <- md
    .set_workspace_entry(nm, sobj)
    invisible(TRUE)
  }
  .obj_names <- reactive({
    names(shared_data$all_seurat_objects %||% list())
  })

  output$vdj_object_picker_ui <- renderUI({
    nms <- .obj_names(); req(length(nms) > 0)
    sel <- input$vdj_object_name %||% shared_data$active_object_name %||% nms[[1]]
    if (!(sel %in% nms)) sel <- nms[[1]]
    selectInput("vdj_object_name", UI_TEXT$t_label_object, choices = nms, selected = sel)
  })

  .read_vdj_table <- function(path) {
    ext <- tolower(tools::file_ext(path))
    if (identical(ext, "csv")) return(utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE))
    utils::read.delim(path, stringsAsFactors = FALSE, check.names = FALSE)
  }

  .pick_col <- function(nm, candidates) {
    lo <- tolower(nm)
    hit <- candidates[candidates %in% lo]
    if (!length(hit)) return(NA_character_)
    nm[match(hit[[1]], lo)]
  }

  .classify_chain <- function(chain_vals) {
    x <- toupper(as.character(chain_vals %||% ""))
    out <- rep("UNKNOWN", length(x))
    out[grepl("^(TRA|TRB|TRD|TRG)", x)] <- "TCR"
    out[grepl("^(IGH|IGK|IGL)", x)] <- "BCR"
    out
  }

  .canon_bc <- function(x) {
    x <- as.character(x %||% "")
    x <- sub("_[0-9]+$", "", x)
    x <- sub("-[0-9]+$", "", x)
    x
  }

  .core_bc <- function(x) {
    x <- as.character(x %||% "")
    x <- sub("^.*_", "", x)
    x <- sub("-[0-9]+$", "", x)
    tolower(x)
  }

  .extract_10x_bc <- function(x) {
    x <- as.character(x %||% "")
    m <- regexpr("[ACGTNacgtn]+-[0-9]+", x, perl = TRUE)
    out <- rep("", length(x))
    hit <- m > 0
    if (any(hit)) out[hit] <- regmatches(x, m)
    out
  }

  .norm_key <- function(x) {
    x <- tolower(as.character(x %||% ""))
    gsub("[^a-z0-9]", "", x)
  }

  .detect_sample_from_file <- function(df, filename, sample_levels, object_name = "", file_path = "", sample_hint = "") {
    sample_levels <- unique(as.character(sample_levels %||% character(0)))
    sample_levels <- sample_levels[nzchar(sample_levels)]
    if (!length(sample_levels)) return(NA_character_)
    sample_keys <- .norm_key(sample_levels)

    .match_hint <- function(txt) {
      k <- .norm_key(txt)
      if (!nzchar(k)) return(NA_character_)
      contains_sk_in_k <- vapply(sample_keys, function(sk) nzchar(sk) && grepl(sk, k, fixed = TRUE), logical(1))
      contains_k_in_sk <- vapply(sample_keys, function(sk) nzchar(sk) && grepl(k, sk, fixed = TRUE), logical(1))
      idx <- which(nzchar(sample_keys) & (sample_keys == k | contains_sk_in_k | contains_k_in_sk))
      idx <- unique(idx)
      if (length(idx) == 1L) return(sample_levels[[idx]])
      NA_character_
    }

    nms <- colnames(df)
    lo <- tolower(nms)
    sample_col <- nms[match(TRUE, lo %in% c("sample", "orig.ident", "orig_ident", "library", "library_id", "donor"), nomatch = 0)]
    if (length(sample_col) && nzchar(sample_col[[1]])) {
      vals <- unique(as.character(df[[sample_col[[1]]]]))
      vals <- vals[nzchar(vals)]
      if (length(vals) == 1L) {
        hit <- sample_levels[tolower(sample_levels) == tolower(vals[[1]])]
        if (length(hit) == 1L) return(hit[[1]])
        # File has explicit sample-like metadata but it does not match object samples.
        return(NA_character_)
      }
    }

    # Prefer explicit sample hint propagated from right-sidebar auto-detection.
    hit <- .match_hint(sample_hint)
    if (nzchar(hit %||% "")) return(hit)

    # Use full file path (including per_sample_outs/<sample>) before filename-only guessing.
    fp <- gsub("\\\\", "/", as.character(file_path %||% ""))
    if (nzchar(fp)) {
      parts <- strsplit(fp, "/", fixed = TRUE)[[1]]
      parts <- parts[nzchar(parts)]
      j <- match("per_sample_outs", parts)
      if (!is.na(j) && j < length(parts)) {
        hit <- .match_hint(parts[[j + 1L]])
        if (nzchar(hit %||% "")) return(hit)
      }
      hit <- .match_hint(fp)
      if (nzchar(hit %||% "")) return(hit)
    }

    fn <- .norm_key(tools::file_path_sans_ext(basename(filename)))
    idx <- which(nzchar(sample_keys) & vapply(sample_keys, function(sk) grepl(sk, fn, fixed = TRUE), logical(1)))
    if (length(idx) == 1L) return(sample_levels[[idx]])

    # Fallback to object-name hint for single-object workflows where orig.ident
    # may be generic (e.g., "filtered_feature_bc_matrix.h5").
    onm <- .norm_key(object_name)
    if (nzchar(onm) && grepl(onm, fn, fixed = TRUE) && length(sample_levels) == 1L) {
      return(sample_levels[[1]])
    }

    # Do not force-assignment for single-sample objects without an explicit hint.
    NA_character_
  }

  .feature_names <- function(sobj) {
    g <- tryCatch(rownames(sobj), error = function(e) NULL)
    if (length(g)) return(as.character(g))
    g <- tryCatch(Seurat::Features(sobj), error = function(e) NULL)
    if (length(g)) return(as.character(g))
    g <- tryCatch({
      aa <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) NULL)
      if (is.null(aa) || !nzchar(aa)) return(NULL)
      rownames(.vdj_get_assay_data(sobj, assay = aa, layer = "data"))
    }, error = function(e) NULL)
    if (length(g)) return(as.character(g))
    character(0)
  }

  .resolve_gene <- function(sel, genes, fallback = NA_character_) {
    if (!length(genes)) return(NA_character_)
    s <- as.character(sel %||% "")
    if (!nzchar(s)) s <- as.character(fallback %||% "")
    if (nzchar(s) && s %in% genes) return(s)
    if (nzchar(s)) {
      m <- match(tolower(s), tolower(genes))
      if (!is.na(m)) return(genes[[m]])
    }
    if (!is.na(fallback) && nzchar(fallback)) {
      m <- match(tolower(fallback), tolower(genes))
      if (!is.na(m)) return(genes[[m]])
    }
    NA_character_
  }

  vdj_status <- reactiveVal(list(msg = "No VDJ file imported yet.", type = "info"))
  vdj_match_summary <- reactiveVal(data.frame(
    file = character(0),
    detected_sample = character(0),
    status = character(0),
    mapped_cells = integer(0),
    stringsAsFactors = FALSE
  ))
  .vdj_last_import_files <- reactiveVal(data.frame())
  .vdj_manual_upload_pending <- reactiveVal(data.frame())
  .vdj_manual_edit_pending <- reactiveVal(data.frame())
  vdj_rewrite_status <- reactiveVal(list(msg = "No rewrite executed yet.", type = "info"))
  vdj_rewrite_summary <- reactiveVal(data.frame())

  output$vdj_import_status_ui <- renderUI({
    st <- vdj_status()
    cls <- if (identical(st$type, "error")) "alert alert-danger" else if (identical(st$type, "warn")) "alert alert-warning" else "alert alert-info"
    div(class = cls, st$msg)
  })

  output$vdj_match_table <- renderTable({
    vdj_match_summary()
  }, striped = TRUE, bordered = TRUE, spacing = "xs", width = "100%")

  output$vdj_rewrite_status_ui <- renderUI({
    st <- vdj_rewrite_status()
    cls <- if (identical(st$type, "error")) "alert alert-danger" else if (identical(st$type, "warn")) "alert alert-warning" else "alert alert-info"
    div(class = cls, st$msg)
  })

  output$vdj_rewrite_cards_ui <- renderUI({
    sm <- vdj_rewrite_summary()
    if (is.null(sm) || !is.data.frame(sm) || !nrow(sm)) return(NULL)
    cards <- lapply(seq_len(nrow(sm)), function(i) {
      r <- sm[i, , drop = FALSE]
      status <- as.character(r$status[[1]] %||% "")
      st_cls <- if (identical(status, "ok")) "text-success" else "text-warning"
      div(
        class = "hto-heatmap-box vdj-file-card",
        div(style = "font-weight:700; color:#0f172a;", as.character(r$file[[1]] %||% "(unnamed file)")),
        div(class = "vdj-file-kv", paste0("Sample: ", as.character(r$detected_sample[[1]] %||% "NA"))),
        div(class = "vdj-file-kv", paste0("Template: ", as.character(r$template[[1]] %||% "NA"))),
        div(class = "vdj-file-kv", paste0("Rows: ", as.integer(r$rows[[1]] %||% 0L), " | Changed: ", as.integer(r$changed[[1]] %||% 0L))),
        div(class = "vdj-file-kv", paste0("Overlap: ", as.integer(r$overlap_n[[1]] %||% 0L), " (", as.numeric(r$overlap_pct[[1]] %||% 0), "%)")),
        div(class = paste("vdj-file-kv", st_cls), paste0("Status: ", status)),
        div(class = "vdj-file-kv", paste0("Example: ", as.character(r$example_before[[1]] %||% ""), " -> ", as.character(r$example_after[[1]] %||% "")))
      )
    })
    do.call(tagList, cards)
  })

  output$vdj_match_cards_ui <- renderUI({
    sm <- vdj_match_summary()
    if (is.null(sm) || !is.data.frame(sm) || !nrow(sm)) {
      return(div(class = "text-muted", tags$small("No VDJ files matched yet.")))
    }
    idx_matched <- which(as.character(sm$status %||% "") == "matched")
    idx_other <- setdiff(seq_len(nrow(sm)), idx_matched)
    matched_cards <- lapply(idx_matched, function(i) {
      r <- sm[i, , drop = FALSE]
      status <- as.character(r$status[[1]] %||% "")
      st_cls <- if (identical(status, "matched")) "text-success" else "text-warning"
      div(
        class = "hto-heatmap-box vdj-file-card",
        div(style = "font-weight:700; color:#0f172a;", as.character(r$file[[1]] %||% "(unnamed file)")),
        div(class = "vdj-file-kv", paste0("Detected sample: ", as.character(r$detected_sample[[1]] %||% "NA"))),
        div(class = paste("vdj-file-kv", st_cls), paste0("Status: ", status)),
        div(class = "vdj-file-kv", paste0("Mapped cells: ", as.integer(r$mapped_cells[[1]] %||% 0L)))
      )
    })
    other_cards <- lapply(idx_other, function(i) {
      r <- sm[i, , drop = FALSE]
      status <- as.character(r$status[[1]] %||% "")
      st_cls <- if (identical(status, "matched")) "text-success" else "text-warning"
      div(
        class = "hto-heatmap-box vdj-file-card",
        div(style = "font-weight:700; color:#0f172a;", as.character(r$file[[1]] %||% "(unnamed file)")),
        div(class = "vdj-file-kv", paste0("Detected sample: ", as.character(r$detected_sample[[1]] %||% "NA"))),
        div(class = paste("vdj-file-kv", st_cls), paste0("Status: ", status)),
        div(class = "vdj-file-kv", paste0("Mapped cells: ", as.integer(r$mapped_cells[[1]] %||% 0L)))
      )
    })
    out <- list()
    if (length(matched_cards)) out <- c(out, matched_cards)
    if (length(other_cards)) {
      out <- c(
        out,
        list(
          tags$details(
            class = "vdj-unmatched-fold",
            tags$summary(sprintf("Show %d unmatched/problem file(s)", length(other_cards))),
            do.call(tagList, other_cards)
          )
        )
      )
    }
    do.call(tagList, out)
  })

  output$vdj_edit_match_btn_ui <- renderUI({
    last <- .vdj_last_import_files()
    if (is.null(last) || !is.data.frame(last) || !nrow(last)) return(NULL)
    actionButton("vdj_edit_match_btn", "Edit matching", class = "btn btn-default btn-sm", style = "margin-top:6px;")
  })

  output$vdj_unmatched_samples_ui <- renderUI({
    sm <- vdj_match_summary()
    sobj <- .get_obj(); req(sobj)
    md <- sobj@meta.data
    sample_levels <- if ("orig.ident" %in% colnames(md)) unique(as.character(md$orig.ident)) else character(0)
    sample_levels <- sample_levels[nzchar(sample_levels)]
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% "selected_object"
    generic_tokens <- c(
      "filtered_feature_bc_matrix.h5", "filtered_feature_bc_matrix",
      "raw_feature_bc_matrix.h5", "raw_feature_bc_matrix",
      "filtered_feature_bc_matrix.h5.gz", "sample", "outs"
    )
    if (length(sample_levels) == 1L && tolower(sample_levels[[1]]) %in% generic_tokens) {
      sample_levels <- as.character(nm)
    }
    if (!length(sample_levels)) return(NULL)

    matched <- unique(sm$detected_sample[sm$status == "matched"])
    remaining <- setdiff(sample_levels, matched)
    if (!length(remaining)) {
      div(class = "text-success", tags$small(UI_TEXT$t_text_all_object_samples_matched_imported_vdj_files))
    } else {
      div(class = "text-warning", tags$small(UI_TEXT$t_text_unmatched_samples_prefix, paste(remaining, collapse = ", ")))
    }
  })

  output$vdj_confocal_note_ui <- renderUI({
    sobj <- .get_obj(); req(sobj)
    aa <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "")
    if (identical(toupper(as.character(aa %||% "")), "RNA")) {
      div(class = "vdj-confocal-note", "Gene expression values are not yet normalized. This UMAP view is intended for population identification only.")
    } else {
      NULL
    }
  })

  .vdj_diag_data <- reactive({
    sobj <- .get_obj(); req(sobj)
    md <- sobj@meta.data
    cells <- colnames(sobj) %||% rownames(md) %||% character(0)
    cells <- as.character(cells %||% character(0))
    n_cells <- length(cells)
    n_features <- tryCatch(nrow(sobj), error = function(e) NA_integer_)

    tcr_pos <- sum(as.logical(md$vdj_tcr_pos %||% FALSE), na.rm = TRUE)
    bcr_pos <- sum(as.logical(md$vdj_bcr_pos %||% FALSE), na.rm = TRUE)
    both_pos <- sum(as.logical((md$vdj_tcr_pos %||% FALSE) | (md$vdj_bcr_pos %||% FALSE)), na.rm = TRUE)

    has_orig <- "orig.ident" %in% colnames(md)
    n_samples <- if (has_orig) length(unique(as.character(md$orig.ident))) else 0L

    is_prefix <- grepl("^[^_]+_[ACGTNacgtn]+-[0-9]+$", cells, perl = TRUE)
    is_suffix <- grepl("^[ACGTNacgtn]+-[0-9]+_[A-Za-z0-9]+$", cells, perl = TRUE)
    is_pref_suf <- grepl("^[^_]+_[ACGTNacgtn]+-[0-9]+_[A-Za-z0-9]+$", cells, perl = TRUE)

    data.frame(
      metric = c(
        "Cells",
        "Features",
        "orig.ident present",
        "Sample count",
        "VDJ-positive cells (TCR or BCR)",
        "TCR-positive cells",
        "BCR-positive cells",
        "Prefix-style barcode ids",
        "Suffix-style barcode ids",
        "Prefix+suffix barcode ids",
        "Has barcode suffix metadata"
      ),
      value = c(
        as.character(n_cells),
        as.character(n_features),
        ifelse(has_orig, "yes", "no"),
        as.character(n_samples),
        as.character(both_pos),
        as.character(tcr_pos),
        as.character(bcr_pos),
        sprintf("%d (%.1f%%)", sum(is_prefix), 100 * sum(is_prefix) / max(1, n_cells)),
        sprintf("%d (%.1f%%)", sum(is_suffix), 100 * sum(is_suffix) / max(1, n_cells)),
        sprintf("%d (%.1f%%)", sum(is_pref_suf), 100 * sum(is_pref_suf) / max(1, n_cells)),
        ifelse(all(c("barcode_suffix_alias", "barcode_suffix_source") %in% colnames(md)), "yes", "no")
      ),
      stringsAsFactors = FALSE
    )
  })

  output$vdj_diag_table <- renderTable({
    .vdj_diag_data()
  }, striped = TRUE, bordered = TRUE, spacing = "xs", width = "100%")

  output$vdj_sample_table <- renderTable({
    sobj <- .get_obj(); req(sobj)
    md <- sobj@meta.data
    if (!("orig.ident" %in% colnames(md))) {
      return(data.frame(note = "orig.ident metadata is not available for this object.", stringsAsFactors = FALSE))
    }
    sm <- as.character(md$orig.ident %||% "")
    sm[!nzchar(sm)] <- "(empty)"
    tcr <- as.logical(md$vdj_tcr_pos %||% FALSE)
    bcr <- as.logical(md$vdj_bcr_pos %||% FALSE)
    df <- data.frame(sample = sm, tcr = tcr, bcr = bcr, stringsAsFactors = FALSE)
    u <- unique(df$sample)
    out <- do.call(rbind, lapply(u, function(s) {
      ii <- which(df$sample == s)
      data.frame(
        sample = s,
        cells = length(ii),
        tcr_pos = sum(df$tcr[ii], na.rm = TRUE),
        bcr_pos = sum(df$bcr[ii], na.rm = TRUE),
        vdj_pos = sum((df$tcr[ii] | df$bcr[ii]), na.rm = TRUE),
        stringsAsFactors = FALSE
      )
    }))
    out[order(out$sample), , drop = FALSE]
  }, striped = TRUE, bordered = TRUE, spacing = "xs", width = "100%")

  .object_sample_levels <- function(sobj, object_name = "") {
    md <- sobj@meta.data
    sample_levels <- if ("orig.ident" %in% colnames(md)) unique(as.character(md$orig.ident)) else character(0)
    sample_levels <- sample_levels[nzchar(sample_levels)]
    generic_tokens <- c(
      "filtered_feature_bc_matrix.h5", "filtered_feature_bc_matrix",
      "raw_feature_bc_matrix.h5", "raw_feature_bc_matrix",
      "filtered_feature_bc_matrix.h5.gz", "sample", "outs"
    )
    if (length(sample_levels) == 1L && tolower(sample_levels[[1]]) %in% generic_tokens) {
      sample_levels <- as.character(object_name %||% "selected_object")
    }
    unique(sample_levels[nzchar(sample_levels)])
  }

  .infer_sample_template <- function(cells) {
    cells <- as.character(cells %||% character(0))
    cells <- cells[nzchar(cells)]
    if (!length(cells)) return("{raw}")
    raw <- .extract_10x_bc(cells)
    ok <- nzchar(raw)
    if (!any(ok)) return("{raw}")
    cells <- cells[ok]
    raw <- raw[ok]
    tmpl <- mapply(function(cell, r) {
      m <- regexpr(r, cell, fixed = TRUE)
      if (m <= 0) return("{raw}")
      pre <- if (m > 1) substr(cell, 1L, m - 1L) else ""
      post_start <- m + nchar(r)
      post <- if (post_start <= nchar(cell)) substr(cell, post_start, nchar(cell)) else ""
      paste0(pre, "{raw}", post)
    }, cells, raw, USE.NAMES = FALSE)
    tt <- sort(table(tmpl), decreasing = TRUE)
    if (!length(tt)) "{raw}" else names(tt)[[1]]
  }

  .template_parts <- function(template) {
    t <- as.character(template %||% "{raw}")
    i <- regexpr("\\{raw\\}", t, perl = TRUE)
    if (i <= 0) return(list(prefix = "", suffix = ""))
    pre <- if (i > 1) substr(t, 1L, i - 1L) else ""
    post_start <- i + attr(i, "match.length")
    suf <- if (post_start <= nchar(t)) substr(t, post_start, nchar(t)) else ""
    list(prefix = pre, suffix = suf)
  }

  .rewrite_barcodes_with_template <- function(barcodes, template) {
    barcodes <- as.character(barcodes %||% character(0))
    raw <- .extract_10x_bc(barcodes)
    raw[!nzchar(raw)] <- barcodes[!nzchar(raw)]
    tp <- .template_parts(template)
    paste0(tp$prefix, raw, tp$suffix)
  }

  .detect_sample_from_row <- function(row_df, sample_levels) {
    sample_levels <- as.character(sample_levels %||% character(0))
    sample_levels <- sample_levels[nzchar(sample_levels)]
    if (!length(sample_levels)) return(NA_character_)
    sample_keys <- .norm_key(sample_levels)
    .match <- function(txt) {
      k <- .norm_key(txt)
      if (!nzchar(k)) return(NA_character_)
      contains_sk_in_k <- vapply(sample_keys, function(sk) nzchar(sk) && grepl(sk, k, fixed = TRUE), logical(1))
      contains_k_in_sk <- vapply(sample_keys, function(sk) nzchar(sk) && grepl(k, sk, fixed = TRUE), logical(1))
      idx <- which(nzchar(sample_keys) & (sample_keys == k | contains_sk_in_k | contains_k_in_sk))
      idx <- unique(idx)
      if (length(idx) == 1L) sample_levels[[idx]] else NA_character_
    }
    if ("sample_name" %in% colnames(row_df)) {
      h <- .match(as.character(row_df$sample_name[[1]] %||% ""))
      if (nzchar(h %||% "")) return(h)
    }
    p <- gsub("\\\\", "/", as.character(row_df$path[[1]] %||% ""))
    if (nzchar(p)) {
      parts <- strsplit(p, "/", fixed = TRUE)[[1]]
      parts <- parts[nzchar(parts)]
      j <- match("per_sample_outs", parts)
      if (!is.na(j) && j < length(parts)) {
        h <- .match(parts[[j + 1L]])
        if (nzchar(h %||% "")) return(h)
      }
      h <- .match(p)
      if (nzchar(h %||% "")) return(h)
    }
    h <- .match(as.character(row_df$name[[1]] %||% ""))
    if (nzchar(h %||% "")) return(h)
    NA_character_
  }

  .infer_chain_tag <- function(df, file_name = "", file_path = "", declared_type = "") {
    t0 <- tolower(as.character(declared_type %||% ""))
    if (t0 %in% c("vdj_tcr", "vdj_bcr")) return(sub("^vdj_", "", t0))
    token <- tolower(paste(as.character(file_name %||% ""), as.character(file_path %||% ""), sep = " "))
    if (grepl("(^|[^a-z])tcr([^a-z]|$)|vdj_t", token, perl = TRUE)) return("tcr")
    if (grepl("(^|[^a-z])bcr([^a-z]|$)|vdj_b", token, perl = TRUE)) return("bcr")
    nms <- colnames(df)
    ccol <- .pick_col(nms, c("chain", "locus"))
    gcol <- .pick_col(nms, c("v_gene", "gene"))
    vals <- character(0)
    if (!is.na(ccol) && nzchar(ccol)) {
      vals <- as.character(df[[ccol]] %||% "")
    } else if (!is.na(gcol) && nzchar(gcol)) {
      vals <- as.character(df[[gcol]] %||% "")
    }
    if (length(vals)) {
      up <- toupper(vals)
      t_n <- sum(grepl("^(TRA|TRB|TRD|TRG)", up), na.rm = TRUE)
      b_n <- sum(grepl("^(IGH|IGK|IGL)", up), na.rm = TRUE)
      if (t_n > b_n) return("tcr")
      if (b_n > t_n) return("bcr")
    }
    "vdj"
  }

  .map_to_allowed_cells_quick <- function(barcodes, allowed_cells) {
    allowed_cells <- as.character(allowed_cells %||% character(0))
    barcodes <- as.character(barcodes %||% character(0))
    if (!length(barcodes) || !length(allowed_cells)) return(rep(NA_character_, length(barcodes)))
    map_from <- function(keys, cells) {
      keys <- as.character(keys %||% "")
      cells <- as.character(cells %||% "")
      ok <- nzchar(keys) & nzchar(cells)
      keys <- keys[ok]
      cells <- cells[ok]
      if (!length(keys)) return(setNames(character(0), character(0)))
      dup <- duplicated(keys)
      setNames(cells[!dup], keys[!dup])
    }
    map_lookup <- function(map, keys) {
      keys <- as.character(keys %||% "")
      out <- rep(NA_character_, length(keys))
      if (!length(map) || !length(keys)) return(out)
      hit <- keys %in% names(map)
      if (any(hit)) out[hit] <- unname(map[keys[hit]])
      out
    }
    allowed_10x <- .extract_10x_bc(allowed_cells)
    map_exact <- map_from(allowed_cells, allowed_cells)
    map_canon <- map_from(.canon_bc(allowed_cells), allowed_cells)
    map_core <- map_from(.core_bc(allowed_cells), allowed_cells)
    map_10x <- map_from(allowed_10x, allowed_cells)
    map_10x_core <- map_from(.core_bc(allowed_10x), allowed_cells)

    bc_exact <- barcodes
    bc_canon <- .canon_bc(barcodes)
    bc_core <- .core_bc(barcodes)
    bc_10x <- .extract_10x_bc(barcodes)
    bc_10x_core <- .core_bc(bc_10x)

    out <- map_lookup(map_exact, bc_exact)
    miss <- is.na(out) | !nzchar(out)
    if (any(miss)) out[miss] <- map_lookup(map_10x, bc_exact[miss])
    miss <- is.na(out) | !nzchar(out)
    if (any(miss)) out[miss] <- map_lookup(map_10x, bc_10x[miss])
    miss <- is.na(out) | !nzchar(out)
    if (any(miss)) out[miss] <- map_lookup(map_10x_core, bc_10x_core[miss])
    miss <- is.na(out) | !nzchar(out)
    if (any(miss)) out[miss] <- map_lookup(map_canon, bc_canon[miss])
    miss <- is.na(out) | !nzchar(out)
    if (any(miss)) out[miss] <- map_lookup(map_core, bc_core[miss])
    out
  }

  .upload_row_preview <- function(path, name, sample_levels, object_name, sample_map) {
    out <- list(chain = "vdj", prefill_sample = NA_character_, overlap_n = 0L, barcode_n = 0L)
    if (!nzchar(as.character(path %||% "")) || !file.exists(path)) return(out)
    df <- tryCatch(.read_vdj_table(path), error = function(e) NULL)
    if (is.null(df) || !is.data.frame(df) || !nrow(df)) return(out)
    out$chain <- .infer_chain_tag(df, file_name = name, file_path = path, declared_type = "")
    out$prefill_sample <- tryCatch(
      .detect_sample_from_file(
        df = df,
        filename = name,
        sample_levels = sample_levels,
        object_name = object_name,
        file_path = path,
        sample_hint = ""
      ),
      error = function(e) NA_character_
    )
    nms <- colnames(df)
    bc_col <- .pick_col(nms, c("barcode", "cell", "cell_id", "barcodes", "bc"))
    if (is.na(bc_col) || !nzchar(bc_col)) return(out)
    bc <- as.character(df[[bc_col]] %||% "")
    bc <- bc[!is.na(bc) & nzchar(bc)]
    out$barcode_n <- length(unique(bc))
    if (!length(bc)) return(out)
    sid <- as.character(out$prefill_sample %||% "")
    if (nzchar(sid)) {
      allowed <- as.character(sample_map$cell[sample_map$sample == sid] %||% character(0))
    } else {
      allowed <- as.character(sample_map$cell %||% character(0))
    }
    mapped <- .map_to_allowed_cells_quick(bc, allowed)
    out$overlap_n <- as.integer(sum(!is.na(mapped) & nzchar(mapped)))
    out
  }

  .rewrite_source_rows <- reactive({
    last <- .vdj_last_import_files()
    if (!is.data.frame(last) || !nrow(last)) return(data.frame())
    out <- last
    if (!("name" %in% colnames(out))) out$name <- basename(as.character(out$datapath %||% ""))
    if (!("datapath" %in% colnames(out)) && "path" %in% colnames(out)) out$datapath <- out$path
    if (!("datapath" %in% colnames(out))) return(data.frame())
    out <- out[nzchar(as.character(out$datapath %||% "")) & file.exists(as.character(out$datapath %||% "")), , drop = FALSE]
    out
  })

  output$vdj_rewrite_file_picker_ui <- renderUI({
    df <- .rewrite_source_rows()
    if (!is.data.frame(df) || !nrow(df)) return(div(class = "text-muted", tags$small("No source VDJ files found for rewrite.")))
    ids <- if ("datapath" %in% colnames(df)) as.character(df$datapath %||% "") else if ("path" %in% colnames(df)) as.character(df$path %||% "") else character(0)
    ids <- ids[!is.na(ids) & nzchar(ids)]
    if (!length(ids)) return(div(class = "text-muted", tags$small("No source VDJ files found for rewrite.")))
    labels <- if ("name" %in% colnames(df)) as.character(df$name %||% basename(ids)) else basename(ids)
    labels <- labels[seq_len(min(length(labels), length(ids)))]
    ids <- ids[seq_len(length(labels))]
    names(ids) <- labels
    checkboxGroupInput("vdj_rewrite_selected_paths", "VDJ files to rewrite:", choices = ids, selected = ids)
  })

  .prefill_uploaded_sample <- function(path, filename, sample_levels, object_name = "") {
    if (!length(sample_levels) || !nzchar(path) || !file.exists(path)) return(NA_character_)
    df <- tryCatch(.read_vdj_table(path), error = function(e) NULL)
    if (is.null(df) || !is.data.frame(df) || nrow(df) == 0) return(NA_character_)
    tryCatch(
      .detect_sample_from_file(
        df = df,
        filename = filename,
        sample_levels = sample_levels,
        object_name = object_name,
        file_path = path,
        sample_hint = ""
      ),
      error = function(e) NA_character_
    )
  }

  output$vdj_upload_map_ui <- renderUI({
    pending <- .vdj_manual_upload_pending()
    if (is.null(pending) || !is.data.frame(pending) || !nrow(pending)) return(NULL)
    sobj <- .get_obj(); req(sobj)
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% "selected_object"
    sample_levels <- .object_sample_levels(sobj, nm)
    choices <- c("Skip (do not import)" = "__skip__", sample_levels)

    rows <- lapply(seq_len(nrow(pending)), function(i) {
      r <- pending[i, , drop = FALSE]
      fid <- paste0("vdj_upload_match_", i)
      pre <- as.character(r$prefill_sample[[1]] %||% "")
      sel <- if (nzchar(pre) && pre %in% sample_levels) pre else "__skip__"
      chain_tag <- toupper(as.character(r$inferred_chain[[1]] %||% "VDJ"))
      ov_n <- as.integer(r$overlap_n[[1]] %||% 0L)
      bc_n <- as.integer(r$barcode_n[[1]] %||% 0L)
      fluidRow(
        class = "vdj-upload-map-row",
        column(
          7,
          div(class = "vdj-upload-map-file", paste0(as.character(r$name[[1]] %||% "(unnamed file)"), " [", chain_tag, "]")),
          div(class = "text-muted", style = "font-size:12px;",
              paste0("Detected sample hint: ", ifelse(nzchar(pre), pre, "NA"), " | Barcode overlap: ", ov_n, "/", bc_n))
        ),
        column(5, selectInput(fid, "Match to sample", choices = choices, selected = sel, width = "100%"))
      )
    })

    tagList(
      tags$p(tags$b("Confirm sample matching for uploaded VDJ file(s)")),
      tags$p(class = "text-muted", tags$small("Set files to Skip if they were uploaded by mistake.")),
      do.call(tagList, rows)
    )
  })

  output$vdj_edit_map_ui <- renderUI({
    pending <- .vdj_manual_edit_pending()
    if (is.null(pending) || !is.data.frame(pending) || !nrow(pending)) return(NULL)
    sobj <- .get_obj(); req(sobj)
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% "selected_object"
    sample_levels <- .object_sample_levels(sobj, nm)
    choices <- c("Skip (do not import)" = "__skip__", sample_levels)

    rows <- lapply(seq_len(nrow(pending)), function(i) {
      r <- pending[i, , drop = FALSE]
      fid <- paste0("vdj_edit_match_", i)
      pre <- as.character(r$detected_sample[[1]] %||% "")
      sel <- if (nzchar(pre) && pre %in% sample_levels) pre else "__skip__"
      fluidRow(
        class = "vdj-upload-map-row",
        column(7, div(class = "vdj-upload-map-file", as.character(r$name[[1]] %||% "(unnamed file)"))),
        column(5, selectInput(fid, "Match to sample", choices = choices, selected = sel, width = "100%"))
      )
    })

    tagList(
      tags$p(tags$b("Modify file-to-sample matching")),
      tags$p(class = "text-muted", tags$small("Use this to correct matching after import. Files set to Skip will be excluded and the object will be rebuilt.")),
      do.call(tagList, rows)
    )
  })

  observe({
    sobj <- .get_obj()
    req(sobj)
    md <- sobj@meta.data
    feat <- input$vdj_filter_feature %||% "tcr"
    cfg <- .vdj_clone_threshold_config(
      md,
      feature = feat,
      current = isolate(input$vdj_clone_threshold %||% 2)
    )
    updateSliderInput(session, "vdj_clone_threshold", min = cfg$min, max = cfg$max, value = cfg$value)
  })

  .apply_vdj_payload_to_metadata <- function(sobj, vdj_payload) {
    rec <- vdj_payload$records %||% NULL
    if (!is.data.frame(rec) || !nrow(rec)) stop("No VDJ records are available to apply.")
    cell_col <- if ("cell" %in% colnames(rec)) "cell" else if ("barcode" %in% colnames(rec)) "barcode" else ""
    if (!nzchar(cell_col) || !all(c("chain", "clone") %in% colnames(rec))) stop("VDJ records are missing required columns (cell/barcode, chain, clone).")
    d_all <- rec
    d_all$cell <- as.character(d_all[[cell_col]] %||% "")
    d_all$chain <- as.character(d_all$chain %||% "")
    d_all$clone <- as.character(d_all$clone %||% "")
    d_all <- d_all[nzchar(d_all$cell) & nzchar(d_all$chain) & nzchar(d_all$clone), , drop = FALSE]
    d_all <- d_all[d_all$chain %in% c("TCR", "BCR"), , drop = FALSE]
    if (!nrow(d_all)) stop("No usable TCR/BCR records are available to apply.")

    d_all$clone_key <- paste(d_all$sample %||% "", d_all$clone, sep = "::")
    cell_chain <- aggregate(clone_key ~ cell + chain, d_all, function(x) names(sort(table(x), decreasing = TRUE))[1])
    names(cell_chain)[names(cell_chain) == "clone_key"] <- "top_clone"

    tcr_clone_sizes <- table(cell_chain$top_clone[cell_chain$chain == "TCR"])
    bcr_clone_sizes <- table(cell_chain$top_clone[cell_chain$chain == "BCR"])

    md <- sobj@meta.data
    md$vdj_tcr_pos <- FALSE
    md$vdj_bcr_pos <- FALSE
    md$vdj_tcr_clone <- "unknown"
    md$vdj_bcr_clone <- "unknown"
    md$vdj_tcr_clone_size <- 0L
    md$vdj_bcr_clone_size <- 0L
    md$vdj_barcode_match_status <- "unknown"

    raw <- vdj_payload$raw_contigs %||% NULL
    matched_cells <- character(0)
    if (is.data.frame(raw) && nrow(raw) && "mapped_cell" %in% colnames(raw)) {
      matched_cells <- unique(as.character(raw$mapped_cell %||% ""))
      matched_cells <- matched_cells[nzchar(matched_cells)]
    }
    if (!length(matched_cells)) {
      matched_cells <- unique(as.character(d_all$cell %||% ""))
      matched_cells <- matched_cells[nzchar(matched_cells)]
    }
    if (length(matched_cells)) {
      m_idx <- match(matched_cells, rownames(md))
      m_idx <- m_idx[!is.na(m_idx)]
      if (length(m_idx)) {
        md$vdj_barcode_match_status[m_idx] <- "matched"
        md$vdj_tcr_clone[m_idx] <- "0"
        md$vdj_bcr_clone[m_idx] <- "0"
      }
    }

    if (nrow(cell_chain)) {
      tcr <- cell_chain[cell_chain$chain == "TCR", , drop = FALSE]
      bcr <- cell_chain[cell_chain$chain == "BCR", , drop = FALSE]
      if (nrow(tcr)) {
        tcr <- tcr[!duplicated(tcr$cell), , drop = FALSE]
        idx <- match(tcr$cell, rownames(md))
        idx <- idx[!is.na(idx)]
        md$vdj_tcr_pos[idx] <- TRUE
        md$vdj_tcr_clone[idx] <- tcr$top_clone[match(rownames(md)[idx], tcr$cell)]
        md$vdj_tcr_clone_size[idx] <- as.integer(tcr_clone_sizes[md$vdj_tcr_clone[idx]] %||% 1)
      }
      if (nrow(bcr)) {
        bcr <- bcr[!duplicated(bcr$cell), , drop = FALSE]
        idx <- match(bcr$cell, rownames(md))
        idx <- idx[!is.na(idx)]
        md$vdj_bcr_pos[idx] <- TRUE
        md$vdj_bcr_clone[idx] <- bcr$top_clone[match(rownames(md)[idx], bcr$cell)]
        md$vdj_bcr_clone_size[idx] <- as.integer(bcr_clone_sizes[md$vdj_bcr_clone[idx]] %||% 1)
      }
    }

    sobj@meta.data <- md
    list(
      sobj = sobj,
      mapped_total = sum(md$vdj_tcr_pos | md$vdj_bcr_pos, na.rm = TRUE),
      tcr_pos = sum(md$vdj_tcr_pos, na.rm = TRUE),
      bcr_pos = sum(md$vdj_bcr_pos, na.rm = TRUE)
    )
  }

  .import_vdj_files <- function(file_df, source_tag = "upload", apply_to_meta = FALSE) {
    if (is.null(file_df) || !is.data.frame(file_df) || !nrow(file_df)) return(invisible(FALSE))
    .vdj_last_import_files(file_df)
    sobj <- .get_obj(); req(sobj)
    nm <- input$vdj_object_name %||% shared_data$active_object_name
    req(nm)
    on.exit({
      .cleanup_vdj_temp_state(nm)
      .vdj_manual_upload_pending(NULL)
      .vdj_manual_edit_pending(NULL)
    }, add = TRUE)
    .vdj_log("import_vdj_files start.", "source_tag=", source_tag, "object=", nm, "file_n=", nrow(file_df))

    md <- sobj@meta.data
    cell_names <- rownames(md)
    if (is.null(cell_names)) cell_names <- colnames(sobj)
    if (is.null(cell_names)) cell_names <- character(0)
    sample_col <- if ("orig.ident" %in% colnames(md)) as.character(md$orig.ident) else rep("all", length(cell_names))
    generic_tokens <- c(
      "filtered_feature_bc_matrix.h5", "filtered_feature_bc_matrix",
      "raw_feature_bc_matrix.h5", "raw_feature_bc_matrix",
      "filtered_feature_bc_matrix.h5.gz", "sample", "outs"
    )
    u_sample <- unique(sample_col[nzchar(sample_col)])
    if (length(u_sample) == 1L && tolower(u_sample[[1]]) %in% generic_tokens) {
      sample_col <- rep(as.character(nm), length(cell_names))
    }
    sample_map <- data.frame(cell = cell_names, sample = sample_col, stringsAsFactors = FALSE)
    sample_levels <- unique(sample_map$sample)
    .same_sample_hint <- function(hint, sid) {
      hk <- .norm_key(hint)
      sk <- .norm_key(sid)
      if (!nzchar(hk) || !nzchar(sk)) return(FALSE)
      identical(hk, sk) || grepl(hk, sk, fixed = TRUE) || grepl(sk, hk, fixed = TRUE)
    }
    .has_explicit_sample_cue <- function(name_txt, sample_hint) {
      n0 <- tolower(as.character(name_txt %||% ""))
      if (nzchar(as.character(sample_hint %||% ""))) return(TRUE)
      # Generic raw file names carry no explicit sample identity.
      if (n0 %in% c("filtered_contig_annotations.csv", "all_contig_annotations.csv")) return(FALSE)
      # Prefixed names like <sample>_..._contigs are explicit sample cues.
      grepl("contigs", n0, fixed = TRUE) || grepl("sr[0-9]{4,}", n0, perl = TRUE)
    }
    .vdj_log("object sample levels:", paste(sample_levels, collapse = ","))
    .map_to_allowed_cells <- function(barcodes, allowed_cells) {
      allowed_cells <- as.character(allowed_cells %||% character(0))
      barcodes <- as.character(barcodes %||% character(0))
      if (!length(barcodes) || !length(allowed_cells)) return(rep(NA_character_, length(barcodes)))

      map_from <- function(keys, cells) {
        keys <- as.character(keys %||% "")
        cells <- as.character(cells %||% "")
        ok <- nzchar(keys) & nzchar(cells)
        keys <- keys[ok]
        cells <- cells[ok]
        if (!length(keys)) return(setNames(character(0), character(0)))
        # Keep first seen key to provide deterministic mapping.
        dup <- duplicated(keys)
        setNames(cells[!dup], keys[!dup])
      }
      map_lookup <- function(map, keys) {
        keys <- as.character(keys %||% "")
        out <- rep(NA_character_, length(keys))
        if (!length(map) || !length(keys)) return(out)
        hit <- keys %in% names(map)
        if (any(hit)) out[hit] <- unname(map[keys[hit]])
        out
      }

      allowed_10x <- .extract_10x_bc(allowed_cells)
      map_exact <- map_from(allowed_cells, allowed_cells)
      map_canon <- map_from(.canon_bc(allowed_cells), allowed_cells)
      map_core <- map_from(.core_bc(allowed_cells), allowed_cells)
      map_10x <- map_from(allowed_10x, allowed_cells)
      map_10x_core <- map_from(.core_bc(allowed_10x), allowed_cells)

      bc_exact <- barcodes
      bc_canon <- .canon_bc(barcodes)
      bc_core <- .core_bc(barcodes)
      bc_10x <- .extract_10x_bc(barcodes)
      bc_10x_core <- .core_bc(bc_10x)

      out <- map_lookup(map_exact, bc_exact)
      miss <- is.na(out) | !nzchar(out)
      if (any(miss)) out[miss] <- map_lookup(map_10x, bc_exact[miss])
      miss <- is.na(out) | !nzchar(out)
      if (any(miss)) out[miss] <- map_lookup(map_10x, bc_10x[miss])
      miss <- is.na(out) | !nzchar(out)
      if (any(miss)) out[miss] <- map_lookup(map_10x_core, bc_10x_core[miss])
      miss <- is.na(out) | !nzchar(out)
      if (any(miss)) out[miss] <- map_lookup(map_canon, bc_canon[miss])
      miss <- is.na(out) | !nzchar(out)
      if (any(miss)) out[miss] <- map_lookup(map_core, bc_core[miss])

      out
    }

    parsed_blocks <- list()
    raw_blocks <- list()
    match_rows <- list()
    matched_cell_blocks <- list()
    n_rows_total <- 0L
    n_rows_chain_kept <- 0L
    n_rows_chain_unknown <- 0L
    n_rows_mapped <- 0L
    for (i in seq_len(nrow(file_df))) {
      one <- file_df[i, , drop = FALSE]
      one_name <- as.character(one$name %||% basename(as.character(one$datapath %||% "")))
      one_path <- as.character(one$datapath %||% "")
      sample_hint <- as.character(one$sample_hint %||% "")
      .vdj_log("processing file:", one_name, "path=", one_path, "sample_hint=", sample_hint)
      if (!nzchar(one_path) || !file.exists(one_path)) {
        .vdj_log(" -> missing_file")
        match_rows[[length(match_rows) + 1L]] <- data.frame(
          file = one_name, detected_sample = NA_character_, status = "missing_file", mapped_cells = 0L, stringsAsFactors = FALSE
        )
        next
      }
      df <- tryCatch(.read_vdj_table(one_path), error = function(e) NULL)
      if (is.null(df) || !is.data.frame(df) || nrow(df) == 0) {
        .vdj_log(" -> parse_failed")
        match_rows[[length(match_rows) + 1L]] <- data.frame(
          file = one_name, detected_sample = NA_character_, status = "parse_failed", mapped_cells = 0L, stringsAsFactors = FALSE
        )
        next
      }

      nms <- colnames(df)
      bc_col <- .pick_col(nms, c("barcode", "cell", "cell_id", "barcodes", "bc"))
      clone_col <- .pick_col(nms, c("raw_clonotype_id", "clonotype_id", "clone_id", "cdr3", "cdr3s_aa", "cdr3_aa"))
      chain_col <- .pick_col(nms, c("chain", "locus", "v_gene", "gene"))
      if (is.na(bc_col) || is.na(clone_col)) {
        .vdj_log(" -> missing_required_columns",
                 "cols=", paste(colnames(df), collapse = ","))
        match_rows[[length(match_rows) + 1L]] <- data.frame(
          file = one_name, detected_sample = NA_character_, status = "missing_required_columns", mapped_cells = 0L, stringsAsFactors = FALSE
        )
        next
      }

      sample_id <- .detect_sample_from_file(
        df = df,
        filename = one_name,
        sample_levels = sample_levels,
        object_name = nm
        , file_path = one_path
        , sample_hint = sample_hint
      )
      forced_sample <- as.character(one$force_sample %||% "")
      if (nzchar(forced_sample) && forced_sample %in% sample_levels) {
        sample_id <- forced_sample
        .vdj_log(" -> forced_sample override:", sample_id)
      }
      if ((is.na(sample_id) || !nzchar(sample_id)) && length(sample_levels) == 1L) {
        sid <- sample_levels[[1]]
        # Guard: never force-match files that already carry explicit sample identity
        # conflicting with the selected object sample.
        explicit_cue <- .has_explicit_sample_cue(one_name, sample_hint)
        if (!explicit_cue || .same_sample_hint(sample_hint, sid)) {
          bc_probe <- as.character(df[[bc_col]])
          bc_probe <- bc_probe[!is.na(bc_probe) & nzchar(bc_probe)]
          if (length(bc_probe)) {
            allowed_probe <- sample_map$cell[sample_map$sample == sid]
            mapped_probe <- .map_to_allowed_cells(bc_probe, allowed_probe)
            n_probe_hit <- sum(!is.na(mapped_probe) & nzchar(mapped_probe))
            .vdj_log(" -> single-sample barcode probe hits:", n_probe_hit, "of", length(bc_probe))
            if (n_probe_hit > 0L) sample_id <- sid
          }
        } else {
          .vdj_log(" -> single-sample fallback blocked by explicit sample cue mismatch.")
        }
      }
      if (is.na(sample_id) || !nzchar(sample_id)) {
        .vdj_log(" -> unmatched_sample")
        match_rows[[length(match_rows) + 1L]] <- data.frame(
          file = one_name, detected_sample = NA_character_, status = "unmatched_sample", mapped_cells = 0L, stringsAsFactors = FALSE
        )
        next
      }
      .vdj_log(" -> detected_sample:", sample_id)

      bc_full <- as.character(df[[bc_col]])
      cl_full <- as.character(df[[clone_col]])
      chain_input_full <- if (!is.na(chain_col)) as.character(df[[chain_col]]) else rep(NA_character_, nrow(df))
      ch_full <- if (!is.na(chain_col)) .classify_chain(df[[chain_col]]) else rep("UNKNOWN", nrow(df))

      allowed_cells <- sample_map$cell[sample_map$sample == sample_id]
      mapped_cell_full <- .map_to_allowed_cells(bc_full, allowed_cells)
      raw_blocks[[length(raw_blocks) + 1L]] <- .vdj_payload_build_raw_contigs(
        df = df,
        sample_id = sample_id,
        file_name = one_name,
        file_path = one_path,
        source_tag = source_tag,
        barcode_values = bc_full,
        clone_values = cl_full,
        chain_input = chain_input_full,
        chain_class = ch_full,
        mapped_cell = mapped_cell_full
      )

      use <- !is.na(bc_full) & nzchar(bc_full) & !is.na(cl_full) & nzchar(cl_full)
      bc <- bc_full[use]
      cl <- cl_full[use]
      ch <- ch_full[use]
      n_rows_total <- n_rows_total + length(bc)
      d <- data.frame(barcode = bc, clone = cl, chain = ch, sample = sample_id, stringsAsFactors = FALSE)
      n_rows_chain_unknown <- n_rows_chain_unknown + sum(!(d$chain %in% c("TCR", "BCR")))
      d <- d[d$chain %in% c("TCR", "BCR"), , drop = FALSE]
      n_rows_chain_kept <- n_rows_chain_kept + nrow(d)
      if (!nrow(d)) {
        .vdj_log(" -> no_tcr_bcr_rows")
        match_rows[[length(match_rows) + 1L]] <- data.frame(
          file = one_name, detected_sample = sample_id, status = "no_tcr_bcr_rows", mapped_cells = 0L, stringsAsFactors = FALSE
        )
        next
      }

      mapped_cell <- mapped_cell_full[use]
      d$cell <- mapped_cell
      d <- d[!is.na(d$cell) & nzchar(d$cell), , drop = FALSE]
      matched_cell_blocks[[length(matched_cell_blocks) + 1L]] <- unique(as.character(mapped_cell[!is.na(mapped_cell) & nzchar(mapped_cell)]))
      n_rows_mapped <- n_rows_mapped + nrow(d)
      .vdj_log(" -> mapped_rows:", nrow(d), "unique_cells:", length(unique(d$cell)))

      if (nrow(d) > 0L) parsed_blocks[[length(parsed_blocks) + 1L]] <- d
      match_rows[[length(match_rows) + 1L]] <- data.frame(
        file = one_name, detected_sample = sample_id, status = if (nrow(d) > 0L) "matched" else "barcode_no_overlap", mapped_cells = length(unique(d$cell)), stringsAsFactors = FALSE
      )
    }

    match_df <- if (length(match_rows)) do.call(rbind, match_rows) else data.frame(
      file = character(0), detected_sample = character(0), status = character(0), mapped_cells = integer(0), stringsAsFactors = FALSE
    )
    vdj_match_summary(match_df)
    .vdj_log("import_vdj_files summary statuses:", paste(table(match_df$status), collapse = "; "))
    if (!length(parsed_blocks)) {
      vdj_status(list(msg = "No valid/matched VDJ files were imported. Check required columns and sample matching.", type = "error"))
      .vdj_log("import_vdj_files end: no parsed blocks.")
      return(invisible(FALSE))
    }

    d_new <- do.call(rbind, parsed_blocks)
    raw_new <- .vdj_payload_bind_rows_fill_list(raw_blocks)
    if (!nrow(d_new)) {
      vdj_status(list(msg = "No valid barcode+clone rows found after matching.", type = "error"))
      return(invisible(FALSE))
    }

    vdj_payload <- .get_workspace_vdj_payload(nm, sobj)
    existing_records <- vdj_payload$records %||% NULL
    d_all <- .vdj_payload_merge_records(existing_records, d_new)
    if (!nrow(d_all)) {
      vdj_status(list(msg = "No VDJ records available after merge.", type = "error"))
      return(invisible(FALSE))
    }
    existing_raw_contigs <- vdj_payload$raw_contigs %||% NULL
    raw_all <- .vdj_payload_merge_raw_contigs(existing_raw_contigs, raw_new)

    apply_diag <- list(
      mapped_total = NA_integer_,
      tcr_pos = NA_integer_,
      bcr_pos = NA_integer_
    )
    vdj_payload$source_file <- as.character(file_df$name)
    vdj_payload$source_tag <- source_tag
    vdj_payload$imported_at <- Sys.time()
    vdj_payload$n_rows <- nrow(d_all)
    vdj_payload$n_rows_last_import <- nrow(d_new)
    vdj_payload$n_raw_contigs <- nrow(raw_all)
    vdj_payload$n_raw_contigs_last_import <- nrow(raw_new)
    vdj_payload$records <- d_all
    vdj_payload$raw_contigs <- raw_all
    vdj_payload$match_summary <- match_df
    vdj_payload$pending_apply <- !isTRUE(apply_to_meta)
    # Clear stale missing markers when fresh import succeeded for uploaded files.
    imported_names_norm <- unique(tolower(gsub("\\\\", "/", basename(as.character(file_df$name %||% character(0))))))
    keep_missing <- function(vals) {
      vals <- as.character(vals %||% character(0))
      if (!length(vals)) return(vals)
      key <- tolower(gsub("\\\\", "/", basename(vals)))
      vals[!(key %in% imported_names_norm)]
    }
    vdj_payload$missing_sources_lost <- keep_missing(vdj_payload$missing_sources_lost)
    vdj_payload$missing_sources_empty_ok <- keep_missing(vdj_payload$missing_sources_empty_ok)
    if (isTRUE(apply_to_meta)) {
      apply_res <- .apply_vdj_payload_to_metadata(sobj, vdj_payload)
      sobj <- apply_res$sobj
      apply_diag$mapped_total <- as.integer(apply_res$mapped_total %||% NA_integer_)
      apply_diag$tcr_pos <- as.integer(apply_res$tcr_pos %||% NA_integer_)
      apply_diag$bcr_pos <- as.integer(apply_res$bcr_pos %||% NA_integer_)
      vdj_payload$pending_apply <- FALSE
    }
    .set_workspace_entry(nm, sobj, vdj_payload = vdj_payload)
    # Keep object-linked file map synchronized with actual imported files.
    entry_after <- tryCatch(shared_data$all_seurat_objects[[nm]], error = function(e) NULL)
    if (is.list(entry_after)) {
      if (is.null(entry_after$meta) || !is.list(entry_after$meta)) entry_after$meta <- list()
      if (is.null(entry_after$meta$linked_files) || !is.list(entry_after$meta$linked_files)) entry_after$meta$linked_files <- list()
      link_df <- unique(data.frame(
        chain = as.character(d_all$chain %||% character(0)),
        source_name = as.character(d_all$source_file %||% character(0)),
        path = "",
        stringsAsFactors = FALSE
      ))
      link_df <- link_df[nzchar(as.character(link_df$source_name %||% "")) & link_df$chain %in% c("TCR", "BCR"), , drop = FALSE]
      if (nrow(link_df)) {
        lk <- paste0(link_df$chain, "::", tolower(link_df$source_name))
        link_df <- link_df[!duplicated(lk), , drop = FALSE]
      }
      entry_after$meta$linked_files$vdj <- link_df
      shared_data$all_seurat_objects[[nm]] <- entry_after
    }

    status_msg <- if (isTRUE(apply_to_meta)) {
      sprintf(
        "Imported VDJ (%s) and applied metadata: %d file(s) matched, %d unmatched. Rows kept TCR/BCR=%d/%d (unknown chain=%d), mapped rows=%d. Mapped %d cells (TCR+ %d, BCR+ %d).",
        source_tag,
        sum(match_df$status == "matched"), sum(match_df$status != "matched"),
        n_rows_chain_kept, n_rows_total, n_rows_chain_unknown, n_rows_mapped,
        as.integer(apply_diag$mapped_total %||% 0L), as.integer(apply_diag$tcr_pos %||% 0L), as.integer(apply_diag$bcr_pos %||% 0L)
      )
    } else {
      sprintf(
        "Imported VDJ files (%s) and staged records only: %d file(s) matched, %d unmatched. Rows kept TCR/BCR=%d/%d (unknown chain=%d), mapped rows=%d. Click 'Apply VDJ metadata to selected object' to write metadata columns.",
        source_tag,
        sum(match_df$status == "matched"), sum(match_df$status != "matched"),
        n_rows_chain_kept, n_rows_total, n_rows_chain_unknown, n_rows_mapped
      )
    }
    vdj_status(list(msg = status_msg, type = "info"))
    .vdj_log("import_vdj_files done.",
             "apply_to_meta=", isTRUE(apply_to_meta),
             "mapped_cells_total=", as.integer(apply_diag$mapped_total %||% NA_integer_),
             "tcr_pos=", as.integer(apply_diag$tcr_pos %||% NA_integer_),
             "bcr_pos=", as.integer(apply_diag$bcr_pos %||% NA_integer_))
    invisible(TRUE)
  }

  observeEvent(input$vdj_rewrite_btn, {
    sobj <- .get_obj(); req(sobj)
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% "selected_object"
    md <- sobj@meta.data
    if (!("orig.ident" %in% colnames(md))) {
      vdj_rewrite_status(list(msg = "Rewrite requires orig.ident in selected object.", type = "error"))
      return(invisible(NULL))
    }
    sel_paths <- as.character(input$vdj_rewrite_selected_paths %||% character(0))
    if (!length(sel_paths)) {
      vdj_rewrite_status(list(msg = "No VDJ source files selected for rewrite.", type = "warn"))
      return(invisible(NULL))
    }
    src <- .rewrite_source_rows()
    src <- src[as.character(src$path %||% "") %in% sel_paths, , drop = FALSE]
    if (!nrow(src)) {
      vdj_rewrite_status(list(msg = "Selected VDJ source files are unavailable.", type = "warn"))
      return(invisible(NULL))
    }

    cells <- rownames(md)
    if (is.null(cells) || !length(cells)) cells <- colnames(sobj)
    cells <- as.character(cells %||% character(0))
    sample_per_cell <- as.character(md$orig.ident %||% "")
    if (length(sample_per_cell) != length(cells)) sample_per_cell <- rep("", length(cells))
    sample_map <- data.frame(cell = cells, sample = sample_per_cell, stringsAsFactors = FALSE)
    sample_levels <- unique(sample_map$sample)
    sample_levels <- sample_levels[nzchar(sample_levels)]
    if (!length(sample_levels)) {
      vdj_rewrite_status(list(msg = "No sample labels found in orig.ident.", type = "error"))
      return(invisible(NULL))
    }
    template_by_sample <- setNames(vapply(sample_levels, function(s) {
      .infer_sample_template(sample_map$cell[sample_map$sample == s])
    }, character(1)), sample_levels)

    out_dir <- file.path(tempdir(), "wanlab_vdj_rewrite_inline")
    if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
    run_tag <- format(Sys.time(), "%Y%m%d_%H%M%S")

    summary_rows <- list()
    import_rows <- list()
    mk_sum <- function(file = "", detected_sample = NA_character_, template = NA_character_,
                       rows = 0L, changed = 0L, overlap_n = 0L, overlap_pct = 0,
                       example_before = "", example_after = "", status = "unknown") {
      data.frame(
        file = as.character(file %||% ""),
        detected_sample = as.character(detected_sample %||% NA_character_),
        template = as.character(template %||% NA_character_),
        rows = as.integer(rows %||% 0L),
        changed = as.integer(changed %||% 0L),
        overlap_n = as.integer(overlap_n %||% 0L),
        overlap_pct = as.numeric(overlap_pct %||% 0),
        example_before = as.character(example_before %||% ""),
        example_after = as.character(example_after %||% ""),
        status = as.character(status %||% "unknown"),
        stringsAsFactors = FALSE
      )
    }

    for (i in seq_len(nrow(src))) {
      one <- src[i, , drop = FALSE]
      in_path <- as.character(one$path[[1]] %||% "")
      in_name <- as.character(one$name[[1]] %||% basename(in_path))
      sample_id <- .detect_sample_from_row(one, sample_levels = sample_levels)
      if (is.na(sample_id) || !nzchar(sample_id) || !(sample_id %in% names(template_by_sample))) {
        summary_rows[[length(summary_rows) + 1L]] <- mk_sum(
          file = in_name, detected_sample = as.character(sample_id %||% NA_character_),
          status = "unmatched_sample"
        )
        next
      }
      df <- tryCatch(.read_vdj_table(in_path), error = function(e) NULL)
      if (is.null(df) || !is.data.frame(df) || !nrow(df)) {
        summary_rows[[length(summary_rows) + 1L]] <- mk_sum(
          file = in_name, detected_sample = sample_id, template = template_by_sample[[sample_id]],
          status = "parse_failed"
        )
        next
      }
      nms <- colnames(df)
      bc_col <- .pick_col(nms, c("barcode", "cell", "cell_id", "barcodes", "bc"))
      if (is.na(bc_col) || !nzchar(bc_col)) {
        summary_rows[[length(summary_rows) + 1L]] <- mk_sum(
          file = in_name, detected_sample = sample_id, template = template_by_sample[[sample_id]],
          rows = nrow(df), status = "missing_barcode_col"
        )
        next
      }
      chain_tag <- .infer_chain_tag(
        df = df,
        file_name = in_name,
        file_path = in_path,
        declared_type = if ("type" %in% colnames(one)) as.character(one$type[[1]] %||% "") else ""
      )
      old_bc <- as.character(df[[bc_col]] %||% "")
      new_bc <- .rewrite_barcodes_with_template(old_bc, template = template_by_sample[[sample_id]])
      allowed_cells <- as.character(sample_map$cell[sample_map$sample == sample_id] %||% character(0))
      overlap_n <- sum(new_bc %in% allowed_cells, na.rm = TRUE)
      overlap_pct <- round(100 * overlap_n / max(1, length(new_bc)), 1)
      changed_n <- sum(old_bc != new_bc, na.rm = TRUE)
      ex_idx <- which(nzchar(old_bc))[1]
      if (is.na(ex_idx) || !length(ex_idx)) ex_idx <- 1L
      ex_before <- as.character(old_bc[ex_idx] %||% "")
      ex_after <- as.character(new_bc[ex_idx] %||% "")
      df[[bc_col]] <- new_bc

      ext <- tolower(tools::file_ext(in_path))
      stem <- tools::file_path_sans_ext(basename(in_path))
      out_path <- file.path(
        out_dir,
        sprintf("%s__%s__%s__barcode_rewritten__%s_%02d.%s",
                sample_id, chain_tag, stem, run_tag, i, ifelse(nzchar(ext), ext, "csv"))
      )
      tryCatch({
        if (identical(ext, "csv")) utils::write.csv(df, out_path, row.names = FALSE) else utils::write.table(df, out_path, sep = "\t", row.names = FALSE, quote = TRUE)
      }, error = function(e) NULL)

      status <- if (overlap_n > 0L) "ok" else "barcode_no_overlap"
      summary_rows[[length(summary_rows) + 1L]] <- mk_sum(
        file = in_name, detected_sample = sample_id, template = template_by_sample[[sample_id]],
        rows = nrow(df), changed = changed_n, overlap_n = overlap_n, overlap_pct = overlap_pct,
        example_before = ex_before, example_after = ex_after, status = status
      )

      if (file.exists(out_path)) {
        import_rows[[length(import_rows) + 1L]] <- data.frame(
          name = paste0(sample_id, "__", chain_tag, "__", stem, "__rewritten__", run_tag, "_", sprintf("%02d", i)),
          datapath = out_path,
          sample_hint = sample_id,
          force_sample = sample_id,
          stringsAsFactors = FALSE
        )
      }
    }

    sum_df <- if (length(summary_rows)) do.call(rbind, summary_rows) else data.frame()
    vdj_rewrite_summary(sum_df)
    if (!length(import_rows)) {
      vdj_rewrite_status(list(msg = "Rewrite produced no importable files. Check sample matching and overlap.", type = "warn"))
      return(invisible(NULL))
    }
    to_import <- do.call(rbind, import_rows)
    ok <- tryCatch(.import_vdj_files(to_import, source_tag = "rewrite_inline", apply_to_meta = TRUE), error = function(e) FALSE)
    ok_n <- if (is.data.frame(sum_df) && nrow(sum_df)) sum(as.character(sum_df$status %||% "") == "ok") else 0L
    if (isTRUE(ok)) {
      vdj_rewrite_status(list(msg = sprintf("Rewrote %d file(s) and imported directly into object VDJ metadata.", ok_n), type = "info"))
    } else {
      vdj_rewrite_status(list(msg = "Rewrite ran, but import failed. Check VDJ status panel.", type = "error"))
    }
    invisible(NULL)
  })

  .vdj_relink_prompted_object <- reactiveVal("")
  .vdj_auto_import_attempted <- reactiveVal(character(0))
  .vdj_gene_sig <- reactiveVal("")
  .vdj_umap_sig <- reactiveVal("")
  .vdj_feature_plot <- reactiveVal(NULL)
  .vdj_feature_plot_sig <- reactiveVal("")
  .vdj_confocal_plot <- reactiveVal(NULL)
  .vdj_confocal_plot_sig <- reactiveVal("")

  observe({
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% ""
    if (!nzchar(nm)) return(invisible(NULL))
    attempted <- .vdj_auto_import_attempted() %||% character(0)
    if (!(nm %in% attempted)) {
      .vdj_auto_import_attempted(unique(c(attempted, nm)))
      try(.vdj_try_auto_import_from_relink(nm), silent = TRUE)
    }
    missing_sources <- .object_missing_vdj_sources(nm)
    has_real_vdj <- .object_has_vdj_links(nm)
    needs_relink <- (!has_real_vdj) || length(missing_sources) > 0
    if (!needs_relink) {
      if (identical(.vdj_relink_prompted_object(), nm)) .vdj_relink_prompted_object("")
      return(invisible(NULL))
    }
    if (identical(.vdj_relink_prompted_object(), nm)) return(invisible(NULL))
    .vdj_relink_prompted_object(nm)
    missing_ui <- if (length(missing_sources)) {
      tagList(
        tags$p(tags$b("Missing VDJ source files to relink:")),
        tags$ul(lapply(missing_sources, tags$li))
      )
    } else {
      tags$p("No valid embedded VDJ payload is available for this object.")
    }
    showModal(
      modalDialog(
        title = UI_TEXT$t_title_vdj_relink_required,
        div(
          class = "alert alert-danger",
          paste0(
            UI_TEXT$t_text_vdj_relink_required_prefix,
            as.character(nm),
            UI_TEXT$t_text_vdj_relink_required_suffix
          )
        ),
        missing_ui,
        tags$p("Use 'Upload VDJ file(s) (.csv/.tsv)' and then click 'Import VDJ'."),
        footer = tagList(
          modalButton("Later"),
          actionButton("vdj_relink_now_btn", "Relink VDJ now", class = "btn btn-danger")
        ),
        easyClose = TRUE,
        size = "m"
      )
    )
    invisible(NULL)
  })

  observeEvent(input$vdj_relink_now_btn, {
    removeModal()
    showNotification("Upload VDJ file(s) and click 'Import VDJ' to relink this object.", type = "warning", duration = 8)
  })

  observeEvent(input$vdj_import_btn, {
    overlay_show("Importing VDJ and mapping to cells…")
    on.exit(overlay_hide(), add = TRUE)
    .vdj_log("vdj_import_btn clicked.", "has_upload=", is.data.frame(input$vdj_file) && nrow(input$vdj_file))
    if (!is.null(input$vdj_file) && is.data.frame(input$vdj_file) && nrow(input$vdj_file)) {
      sobj <- .get_obj(); req(sobj)
      nm <- input$vdj_object_name %||% shared_data$active_object_name %||% "selected_object"
      sample_levels <- .object_sample_levels(sobj, nm)
      md <- sobj@meta.data
      cell_names <- rownames(md)
      if (is.null(cell_names)) cell_names <- colnames(sobj)
      if (is.null(cell_names)) cell_names <- character(0)
      sample_col <- if ("orig.ident" %in% colnames(md)) as.character(md$orig.ident) else rep("all", length(cell_names))
      sample_map <- data.frame(cell = cell_names, sample = sample_col, stringsAsFactors = FALSE)
      up <- input$vdj_file
      preview <- lapply(seq_len(nrow(up)), function(i) {
        p <- as.character(up$datapath[[i]] %||% "")
        n <- as.character(up$name[[i]] %||% basename(p))
        .upload_row_preview(path = p, name = n, sample_levels = sample_levels, object_name = nm, sample_map = sample_map)
      })
      up$prefill_sample <- vapply(preview, function(x) as.character(x$prefill_sample %||% NA_character_), character(1))
      up$inferred_chain <- vapply(preview, function(x) as.character(x$chain %||% "vdj"), character(1))
      up$overlap_n <- vapply(preview, function(x) as.integer(x$overlap_n %||% 0L), integer(1))
      up$barcode_n <- vapply(preview, function(x) as.integer(x$barcode_n %||% 0L), integer(1))
      .vdj_manual_upload_pending(up)
      showModal(
        modalDialog(
          title = "Confirm VDJ File-to-Sample Matching",
          uiOutput("vdj_upload_map_ui"),
          footer = tagList(
            modalButton("Cancel"),
            actionButton("vdj_upload_confirm_btn", "Confirm Import", class = "btn btn-primary")
          ),
          easyClose = FALSE,
          size = "l"
        )
      )
      return(invisible(NULL))
    }
    showNotification("No uploaded VDJ files selected. Upload .csv/.tsv files first.", type = "warning")
  })

  observeEvent(input$vdj_upload_confirm_btn, {
    pending <- .vdj_manual_upload_pending()
    req(is.data.frame(pending), nrow(pending) > 0)
    keep <- rep(FALSE, nrow(pending))
    forced <- rep(NA_character_, nrow(pending))
    for (i in seq_len(nrow(pending))) {
      sid <- as.character(input[[paste0("vdj_upload_match_", i)]] %||% "__skip__")
      if (!identical(sid, "__skip__") && nzchar(sid)) {
        keep[[i]] <- TRUE
        forced[[i]] <- sid
      }
    }
    if (!any(keep)) {
      removeModal()
      showNotification("No uploaded VDJ files selected for import.", type = "warning")
      return(invisible(NULL))
    }
    to_import <- pending[keep, , drop = FALSE]
    to_import$sample_hint <- as.character(forced[keep])
    to_import$force_sample <- as.character(forced[keep])
    removeModal()
    .import_vdj_files(to_import, source_tag = "upload_confirmed", apply_to_meta = FALSE)
  })

  observeEvent(input$vdj_edit_match_btn, {
    last <- .vdj_last_import_files()
    req(is.data.frame(last), nrow(last) > 0)
    sm <- vdj_match_summary()
    if (!is.data.frame(sm) || !nrow(sm)) {
      showNotification("No prior VDJ matching summary found to edit.", type = "warning")
      return(invisible(NULL))
    }
    ed <- last
    if (!"name" %in% colnames(ed)) ed$name <- basename(as.character(ed$datapath %||% ""))
    if (!"datapath" %in% colnames(ed) && "path" %in% colnames(ed)) ed$datapath <- ed$path
    if (!"datapath" %in% colnames(ed)) {
      showNotification("Missing source file path for remapping.", type = "error")
      return(invisible(NULL))
    }
    idx <- match(as.character(ed$name), as.character(sm$file))
    ed$detected_sample <- as.character(sm$detected_sample[idx] %||% "")
    .vdj_manual_edit_pending(ed)
    showModal(
      modalDialog(
        title = "Edit VDJ File Matching",
        uiOutput("vdj_edit_map_ui"),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("vdj_edit_confirm_btn", "Apply Matching", class = "btn btn-primary")
        ),
        easyClose = FALSE,
        size = "l"
      )
    )
  })

  observeEvent(input$vdj_edit_confirm_btn, {
    pending <- .vdj_manual_edit_pending()
    req(is.data.frame(pending), nrow(pending) > 0)
    keep <- rep(FALSE, nrow(pending))
    forced <- rep(NA_character_, nrow(pending))
    for (i in seq_len(nrow(pending))) {
      sid <- as.character(input[[paste0("vdj_edit_match_", i)]] %||% "__skip__")
      if (!identical(sid, "__skip__") && nzchar(sid)) {
        keep[[i]] <- TRUE
        forced[[i]] <- sid
      }
    }
    if (!any(keep)) {
      removeModal()
      showNotification("No files selected after remapping.", type = "warning")
      return(invisible(NULL))
    }
    to_import <- pending[keep, , drop = FALSE]
    to_import$sample_hint <- as.character(forced[keep])
    to_import$force_sample <- as.character(forced[keep])
    removeModal()
    .import_vdj_files(to_import, source_tag = "manual_remap", apply_to_meta = FALSE)
  })

  observeEvent(input$vdj_apply_meta_btn, {
    overlay_show("Applying staged VDJ metadata to selected object…")
    on.exit(overlay_hide(), add = TRUE)
    sobj <- .get_obj(); req(sobj)
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% ""
    req(nzchar(nm))
    vdj_payload <- .get_workspace_vdj_payload(nm, sobj)
    if (!is.list(vdj_payload) || !is.data.frame(vdj_payload$records) || !nrow(vdj_payload$records)) {
      showNotification("No staged VDJ records found. Import VDJ file(s) first.", type = "warning")
      return(invisible(NULL))
    }
    res <- tryCatch(.apply_vdj_payload_to_metadata(sobj, vdj_payload), error = function(e) e)
    if (inherits(res, "error")) {
      showNotification(paste0("Failed to apply VDJ metadata: ", conditionMessage(res)), type = "error")
      return(invisible(NULL))
    }
    sobj <- res$sobj
    vdj_payload$pending_apply <- FALSE
    .set_workspace_entry(nm, sobj, vdj_payload = vdj_payload)
    vdj_status(list(
      msg = sprintf(
        "VDJ metadata applied to object: mapped %d cells (TCR+ %d, BCR+ %d).",
        as.integer(res$mapped_total %||% 0L),
        as.integer(res$tcr_pos %||% 0L),
        as.integer(res$bcr_pos %||% 0L)
      ),
      type = "info"
    ))
    showNotification("VDJ metadata columns were written to this object.", type = "message")
  })

  observeEvent(input$vdj_show_diagnostics_btn, {
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% "selected object"
    showModal(
      modalDialog(
        title = UI_TEXT$t_title_vdj_barcode_diagnostics,
        tags$p(class = "text-muted", tags$small(UI_TEXT$t_text_diagnostics_note)),
        tags$p(class = "text-muted", tags$small(paste("Object:", nm))),
        fluidRow(
          column(
            12,
            wellPanel(
              h4(UI_TEXT$t_title_vdj_barcode_diagnostics),
              tableOutput("vdj_diag_table")
            )
          ),
          column(
            12,
            wellPanel(
              h4(UI_TEXT$t_title_per_sample_vdj_summary),
              tableOutput("vdj_sample_table")
            )
          )
        ),
        footer = modalButton("Close"),
        easyClose = TRUE,
        size = "l"
      )
    )
  })

  # Update gene choices only when object/gene source changes (prevents flashing loops).
  observe({
    sobj <- .get_obj(); req(sobj)
    genes <- .feature_names(sobj)
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% ""
    if (!length(genes)) return(invisible(NULL))

    sig <- paste(nm, length(genes), genes[[1]], genes[[length(genes)]], sep = "|")
    if (identical(sig, .vdj_gene_sig())) return(invisible(NULL))

    r_cur <- isolate(input$vdj_gene_r %||% "")
    g_cur <- isolate(input$vdj_gene_g %||% "")
    b_cur <- isolate(input$vdj_gene_b %||% "")
    r0 <- if (nzchar(r_cur) && r_cur %in% genes) r_cur else genes[[1]]
    g0 <- if (nzchar(g_cur) && g_cur %in% genes) g_cur else genes[[min(2, length(genes))]]
    b0 <- if (nzchar(b_cur) && b_cur %in% genes) b_cur else genes[[min(3, length(genes))]]

    freezeReactiveValue(input, "vdj_gene_r")
    freezeReactiveValue(input, "vdj_gene_g")
    freezeReactiveValue(input, "vdj_gene_b")
    wl_update_gene_selectize(session, "vdj_gene_r", genes, selected = r0)
    wl_update_gene_selectize(session, "vdj_gene_g", genes, selected = g0)
    wl_update_gene_selectize(session, "vdj_gene_b", genes, selected = b0)
    .vdj_gene_sig(sig)
  })

  .get_umap_df <- reactive({
    sobj <- .get_obj(); req(sobj)
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% ""
    red_names <- tryCatch(names(sobj@reductions), error = function(e) character(0))
    emb <- NULL
    emb_name <- NULL
    if (length(red_names)) {
      lo <- tolower(red_names)
      idx <- which(grepl("umap", lo))
      if (length(idx)) {
        for (k in idx) {
          rn <- red_names[[k]]
          em <- tryCatch(Seurat::Embeddings(sobj, rn), error = function(e) NULL)
          if (is.null(em)) em <- tryCatch(sobj@reductions[[rn]]@cell.embeddings, error = function(e) NULL)
          if (!is.null(em) && ncol(em) >= 2 && nrow(em) > 0) {
            emb <- em
            emb_name <- rn
            break
          }
        }
      }
    }

    if (is.null(emb)) {
      em <- tryCatch(sobj@misc$umap_quick, error = function(e) NULL)
      if (!is.null(em) && is.matrix(em) && ncol(em) >= 2 && nrow(em) > 0) {
        emb <- em
        emb_name <- "misc$umap_quick"
      }
    }

    # One-time temporary UMAP fallback for pre-normalization QC objects.
    if (is.null(emb) && exists(".cache_umap_into_meta", mode = "function")) {
      sig_try <- paste0(nm, "|quick_umap")
      if (!identical(sig_try, .vdj_umap_sig())) {
        .vdj_umap_sig(sig_try)
        vdj_status(list(msg = "Generating temporary UMAP for VDJ view…", type = "warn"))
        overlay_show("Generating temporary UMAP for VDJ view…")
        on.exit(overlay_hide(), add = TRUE)
        set.seed(42)
        sobj2 <- tryCatch(.cache_umap_into_meta(sobj, seed = 42L), error = function(e) NULL)
        if (inherits(sobj2, "Seurat")) {
          if (is.list(shared_data$all_seurat_objects[[nm]]) && !is.null(shared_data$all_seurat_objects[[nm]]$obj)) {
            shared_data$all_seurat_objects[[nm]]$obj <- sobj2
            if (is.null(shared_data$all_seurat_objects[[nm]]$prefs) || !is.list(shared_data$all_seurat_objects[[nm]]$prefs)) {
              shared_data$all_seurat_objects[[nm]]$prefs <- list()
            }
            if (is.null(shared_data$all_seurat_objects[[nm]]$plots) || !is.list(shared_data$all_seurat_objects[[nm]]$plots)) {
              shared_data$all_seurat_objects[[nm]]$plots <- list()
            }
            if (is.null(shared_data$all_seurat_objects[[nm]]$analysis_cache) || !is.list(shared_data$all_seurat_objects[[nm]]$analysis_cache)) {
              shared_data$all_seurat_objects[[nm]]$analysis_cache <- list()
            }
          } else {
            shared_data$all_seurat_objects[[nm]] <- list(
              obj = sobj2,
              prefs = list(),
              plots = list(),
              analysis_cache = list()
            )
          }
          sobj <- sobj2
          em <- tryCatch(sobj@misc$umap_quick, error = function(e) NULL)
          if (!is.null(em) && is.matrix(em) && ncol(em) >= 2 && nrow(em) > 0) {
            emb <- em
            emb_name <- "misc$umap_quick"
            vdj_status(list(msg = "Temporary UMAP generated for VDJ view.", type = "info"))
          }
        }
      }
    }

    if (!is.null(emb) && ncol(emb) >= 2) {
      df <- data.frame(cell = rownames(emb), UMAP_1 = emb[, 1], UMAP_2 = emb[, 2], stringsAsFactors = FALSE)
    } else {
      md <- sobj@meta.data
      mdn <- colnames(md)
      if (!length(mdn)) return(NULL)
      nrm <- gsub("[^a-z0-9]", "", tolower(mdn))

      pick_pair <- function(prefix) {
        i1 <- which(nrm == paste0(prefix, "1"))
        i2 <- which(nrm == paste0(prefix, "2"))
        if (length(i1) && length(i2)) return(c(i1[[1]], i2[[1]]))
        i1 <- which(grepl(prefix, nrm) & grepl("1$", nrm))
        i2 <- which(grepl(prefix, nrm) & grepl("2$", nrm))
        if (!length(i1) || !length(i2)) return(NULL)
        base1 <- sub("1$", "", nrm[i1])
        base2 <- sub("2$", "", nrm[i2])
        m <- match(base1, base2)
        if (any(!is.na(m))) {
          j <- which(!is.na(m))[1]
          return(c(i1[[j]], i2[[m[[j]]]]))
        }
        c(i1[[1]], i2[[1]])
      }

      ij <- pick_pair("umap")
      if (is.null(ij)) return(NULL)

      df <- data.frame(
        cell = rownames(md),
        UMAP_1 = suppressWarnings(as.numeric(md[[ij[[1]]]])),
        UMAP_2 = suppressWarnings(as.numeric(md[[ij[[2]]]])),
        stringsAsFactors = FALSE
      )
      df <- df[is.finite(df$UMAP_1) & is.finite(df$UMAP_2), , drop = FALSE]
      if (!nrow(df)) return(NULL)
      emb_name <- paste0(mdn[[ij[[1]]]], "+", mdn[[ij[[2]]]])
    }
    md <- sobj@meta.data
    df$vdj_tcr_clone_size <- suppressWarnings(as.numeric(md[df$cell, "vdj_tcr_clone_size"] %||% 0))
    df$vdj_bcr_clone_size <- suppressWarnings(as.numeric(md[df$cell, "vdj_bcr_clone_size"] %||% 0))
    attr(df, "emb_name") <- emb_name
    df
  })

  # Agent note: Keep Plotly outputs behind reactiveVal shields. Direct render
  # dependencies recreate htmlwidgets during unrelated shared-state invalidations
  # and make both VDJ plots flash.
  observe({
    df <- .get_umap_df()
    feat <- input$vdj_filter_feature %||% "tcr"
    th <- as.numeric(input$vdj_clone_threshold %||% 2)
    if (!is.finite(th)) th <- 2
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% ""
    sig <- paste(
      nm, attr(df, "emb_name") %||% "", nrow(df %||% data.frame()),
      feat, th,
      sum(df$vdj_tcr_clone_size %||% 0, na.rm = TRUE),
      sum(df$vdj_bcr_clone_size %||% 0, na.rm = TRUE),
      sep = "|"
    )
    if (identical(.vdj_feature_plot_sig(), sig)) return(invisible(NULL))
    .vdj_feature_plot_sig(sig)
    if (is.null(df) || !nrow(df)) {
      .vdj_feature_plot(
        plotly::plotly_empty(type = "scatter", mode = "markers") %>%
          layout(
            title = "VDJ clone overlay",
            annotations = list(list(
              text = "No UMAP reduction found for this object.",
              x = 0.5, y = 0.5, xref = "paper", yref = "paper",
              showarrow = FALSE
            ))
          )
      )
      .vdj_log("feature plot refresh", sig)
      return(invisible(NULL))
    }
    val <- if (identical(feat, "bcr")) df$vdj_bcr_clone_size else df$vdj_tcr_clone_size
    ttl <- if (identical(feat, "bcr")) "BCR expanded clone size" else "TCR expanded clone size"
    is_pos <- is.finite(val) & (val >= th)
    d_bg <- df[!is_pos, , drop = FALSE]
    d_pos <- df[is_pos, , drop = FALSE]
    v_pos <- val[is_pos]

    p <- plot_ly(type = "scattergl", mode = "markers")
    if (nrow(d_bg)) {
      p <- add_trace(
        p, data = d_bg, x = ~UMAP_1, y = ~UMAP_2,
        marker = list(size = 4, color = "rgba(170,170,170,0.35)"),
        hoverinfo = "skip",
        showlegend = FALSE
      )
    }
    if (nrow(d_pos)) {
      p <- add_trace(
        p, data = d_pos, x = ~UMAP_1, y = ~UMAP_2,
        marker = list(size = 4, color = v_pos, colorscale = "Viridis", showscale = TRUE),
        hoverinfo = "skip",
        showlegend = FALSE
      )
    } else if (nrow(d_bg)) {
      p <- add_trace(
        p, data = d_bg, x = ~UMAP_1, y = ~UMAP_2,
        marker = list(size = 4, color = val[!is_pos], colorscale = "Viridis", showscale = TRUE),
        hoverinfo = "skip",
        showlegend = FALSE
      )
    }
    .vdj_feature_plot(p %>% layout(
      title = ttl,
      xaxis = list(title = UI_TEXT$t_text_umap_1),
      yaxis = list(title = UI_TEXT$t_text_umap_2, scaleanchor = "x", scaleratio = 1),
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor = "rgba(0,0,0,0)"
    ))
    .vdj_log("feature plot refresh", sig)
  })

  output$vdj_feature_umap_plot <- renderPlotly({
    .vdj_feature_plot()
  })

  observe({
    sobj <- .get_obj(); req(sobj)
    df <- .get_umap_df()
    nm <- input$vdj_object_name %||% shared_data$active_object_name %||% ""
    requested_genes <- c(
      input$vdj_gene_r %||% "",
      input$vdj_gene_g %||% "",
      input$vdj_gene_b %||% ""
    )
    sig <- paste(
      nm, attr(df, "emb_name") %||% "", nrow(df %||% data.frame()),
      as.character(sobj@version), length(sobj@commands),
      tryCatch(SeuratObject::DefaultAssay(sobj), error = function(e) ""),
      paste(requested_genes, collapse = "|"),
      sep = "|"
    )
    if (identical(.vdj_confocal_plot_sig(), sig)) return(invisible(NULL))
    .vdj_confocal_plot_sig(sig)
    if (is.null(df) || !nrow(df)) {
      .vdj_confocal_plot(
        plotly::plotly_empty(type = "scatter", mode = "markers") %>%
          layout(
            title = "Confocal RGB UMAP",
            annotations = list(list(
              text = "No UMAP reduction found for this object.",
              x = 0.5, y = 0.5, xref = "paper", yref = "paper",
              showarrow = FALSE
            ))
          )
      )
      .vdj_log("confocal plot refresh", sig)
      return(invisible(NULL))
    }
    genes <- .feature_names(sobj)
    if (!length(genes)) {
      .vdj_confocal_plot(
        plotly::plotly_empty(type = "scatter", mode = "markers") %>%
          layout(
            title = "Confocal RGB UMAP",
            annotations = list(list(
              text = "No genes available.",
              x = 0.5, y = 0.5, xref = "paper", yref = "paper",
              showarrow = FALSE
            ))
          )
      )
      .vdj_log("confocal plot refresh", sig)
      return(invisible(NULL))
    }
    r <- .resolve_gene(input$vdj_gene_r, genes, NA_character_)
    g <- .resolve_gene(input$vdj_gene_g, genes, NA_character_)
    b <- .resolve_gene(input$vdj_gene_b, genes, NA_character_)
    if (any(!nzchar(c(r, g, b))) || any(is.na(c(r, g, b)))) {
      .vdj_confocal_plot(
        plotly::plotly_empty(type = "scatter", mode = "markers") %>%
          layout(
            title = "Confocal RGB UMAP",
            annotations = list(list(
              text = "Select R/G/B genes to render RGB UMAP.",
              x = 0.5, y = 0.5, xref = "paper", yref = "paper",
              showarrow = FALSE
            ))
          )
      )
      .vdj_log("confocal plot refresh", sig)
      return(invisible(NULL))
    }

    m <- .vdj_get_assay_data(sobj, layer = "data")
    if (is.null(m)) {
      .vdj_confocal_plot(
        plotly::plotly_empty(type = "scatter", mode = "markers") %>%
          layout(
            title = "Confocal RGB UMAP",
            annotations = list(list(
              text = "Expression matrix not available for selected object.",
              x = 0.5, y = 0.5, xref = "paper", yref = "paper",
              showarrow = FALSE
            ))
          )
      )
      .vdj_log("confocal plot refresh", sig)
      return(invisible(NULL))
    }
    miss <- setdiff(c(r, g, b), rownames(m))
    if (length(miss)) {
      .vdj_confocal_plot(
        plotly::plotly_empty(type = "scatter", mode = "markers") %>%
          layout(
            title = "Confocal RGB UMAP",
            annotations = list(list(
              text = sprintf("Gene(s) not found: %s", paste(miss, collapse = ", ")),
              x = 0.5, y = 0.5, xref = "paper", yref = "paper",
              showarrow = FALSE
            ))
          )
      )
      .vdj_log("confocal plot refresh", sig)
      return(invisible(NULL))
    }
    cells_use <- intersect(df$cell, colnames(m))
    if (!length(cells_use)) {
      .vdj_confocal_plot(
        plotly::plotly_empty(type = "scatter", mode = "markers") %>%
          layout(
            title = "Confocal RGB UMAP",
            annotations = list(list(
              text = "No overlapping cells between embedding and expression matrix.",
              x = 0.5, y = 0.5, xref = "paper", yref = "paper",
              showarrow = FALSE
            ))
          )
      )
      .vdj_log("confocal plot refresh", sig)
      return(invisible(NULL))
    }
    df <- df[match(cells_use, df$cell), , drop = FALSE]
    rv <- as.numeric(m[r, cells_use])
    gv <- as.numeric(m[g, cells_use])
    bv <- as.numeric(m[b, cells_use])
    cols <- .vdj_rgb_hex(rv, gv, bv)

    .vdj_confocal_plot(
      plot_ly(df, x = ~UMAP_1, y = ~UMAP_2, type = "scattergl", mode = "markers",
              marker = list(size = 4, color = cols),
              hoverinfo = "skip") %>%
      layout(
        title = sprintf("Confocal RGB: R=%s, G=%s, B=%s", r, g, b),
        xaxis = list(title = UI_TEXT$t_text_umap_1),
        yaxis = list(title = UI_TEXT$t_text_umap_2, scaleanchor = "x", scaleratio = 1),
        paper_bgcolor = "rgba(0,0,0,0)",
        plot_bgcolor = "rgba(0,0,0,0)"
      )
    )
    .vdj_log("confocal plot refresh", sig)
  })

  output$vdj_confocal_umap_plot <- renderPlotly({
    .vdj_confocal_plot()
  })

  observeEvent(input$vdj_apply_filter_btn, {
    sobj <- .get_obj(); req(sobj)
    overlay_show(UI_TEXT$t_text_applying_vdj_filter_and_creating_workspace_object)
    on.exit(overlay_hide(), add = TRUE)
    nm <- input$vdj_object_name %||% shared_data$active_object_name

    feat <- input$vdj_filter_feature %||% "tcr"
    mode <- input$vdj_filter_mode %||% "keep"
    th <- as.numeric(input$vdj_clone_threshold %||% 2)

    col_use <- if (identical(feat, "bcr")) "vdj_bcr_clone_size" else "vdj_tcr_clone_size"
    if (!(col_use %in% colnames(sobj@meta.data))) {
      showNotification("No VDJ clone-size column found. Import VDJ first.", type = "error")
      return()
    }

    v <- suppressWarnings(as.numeric(sobj@meta.data[[col_use]]))
    v[!is.finite(v)] <- 0
    keep <- if (identical(mode, "keep")) v >= th else !(v >= th)

    cells_keep <- colnames(sobj)[which(keep)]
    if (!length(cells_keep)) {
      showNotification("Filter removed all cells. Adjust threshold.", type = "warning")
      return()
    }

    sobj_f <- subset(sobj, cells = cells_keep)
    sobj_f <- .reset_subset_analysis_state(sobj_f)
    base <- sprintf("%s_%s_cl%d_filtered", nm, feat, as.integer(th))
    new_nm <- base
    i <- 1L
    while (!is.null(shared_data$all_seurat_objects[[new_nm]])) {
      new_nm <- paste0(base, "_", i)
      i <- i + 1L
    }

    shared_data$all_seurat_objects[[new_nm]] <- list(
      obj = sobj_f,
      prefs = list(),
      plots = list(),
      analysis_cache = list(),
      meta = list(stage = "filtered", parent = nm, method = "vdj_filter", feature = feat,
                  threshold = th, mode = mode, created = Sys.time())
    )
    shared_data$active_object_name <- new_nm
    showNotification(sprintf("Created filtered object: %s (%d cells)", new_nm, length(cells_keep)), type = "message")
  })
}
