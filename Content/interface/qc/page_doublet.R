# =======================================================
# page_doublet.R — Doublet Finder (page overlay + percent bar, Shiny progress,
# meta-cached UMAP, DBR slider, confocal RGB, tabbed UI, realtime log)
# Exports: doublet_ui, doublet_server(input, output, session, shared_data)
# =======================================================

DOUBLET_UI_TEXT <- list(
  t_btn_next_choose_final = "Next: Choose Final ->",
  t_btn_next_umap_overlay = "Next: UMAP Overlay ->",
  t_btn_proceed_analysis = "Proceed to Analysis ->",
  t_btn_run_scdblfinder = "Run scDblFinder",
  t_btn_set_chosen_dbr = "Set as chosen DBR",
  t_label_choose_final_tag = "Choose final tag (auto or dbrXXX):",
  t_label_dims_pca_scdblfinder = "Dims (PCA) for scDblFinder",
  t_label_doublet_rate_dbr_range = "Doublet Rate [DBR] range",
  t_label_doublet_rate_dbr_step = "Doublet Rate [DBR] step",
  t_label_include_scdblfinder_auto_run = "Include scDblFinder auto run",
  t_label_object = "Object",
  t_label_seed = "Seed",
  t_label_sample_scope = "Sample scope",
  t_label_umap_overlay = "UMAP overlay for:",
  t_text_blue_channel = "Blue channel",
  t_text_green_channel = "Green channel",
  t_text_input_dbr = "Input dbr",
  t_text_observed_doublet_rate = "Observed doublet rate",
  t_text_red_channel = "Red channel",
  t_text_run_scdblfinder_detect_doublets_inspect_overlays = "Run scDblFinder to detect doublets, inspect overlays, then choose the final tag.",
  t_text_run_scdblfinder_first = "Run scDblFinder first.",
  t_text_preparing_singlet_subset_for_analysis = "Preparing singlet subset for analysis…",
  t_text_type_search_gene = "type to search a gene...",
  t_text_umap_1 = "UMAP 1",
  t_text_umap_2 = "UMAP 2",
  t_title_choose_final = "Choose Final",
  t_title_confocal_genes = "Confocal genes",
  t_title_confocal_rgb = "Confocal (RGB)",
  t_title_doublet_umap = "Doublet UMAP",
  t_title_qc_doublet_finder = "QC: Doublet Finder",
  t_title_summary = "Summary",
  t_title_umap_overlay = "UMAP Overlay",
  t_text_run_scdblfinder_to_enable_selection = "Run scDblFinder to enable selection."

)

suppressPackageStartupMessages({
  library(shiny); library(DT); library(plotly)
  ok_uwot  <- requireNamespace("uwot", quietly = TRUE)     # fast UMAP path
  ok_later <- requireNamespace("later", quietly = TRUE)
})

`%||%` <- function(a,b) if (is.null(a)) b else a

.dbl_get_assay_data <- function(sobj, assay = NULL, layer = "data") {
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

.dbl_pick_expr_matrix <- function(seu) {
  assays <- unique(c(
    tryCatch(as.character(Seurat::DefaultAssay(seu)), error = function(e) NA_character_),
    "SCT",
    "RNA"
  ))
  assays <- assays[is.finite(nchar(assays)) & nzchar(assays)]
  layers <- c("data", "counts")
  for (aa in assays) {
    for (ly in layers) {
      mat <- .dbl_get_assay_data(seu, assay = aa, layer = ly)
      if (!is.null(mat) && nrow(mat) > 0 && ncol(mat) > 0) {
        return(list(expr = mat, assay = aa, layer = ly))
      }
    }
  }
  NULL
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

# ---------- helpers: tags, names, registry ----------
.dbr_tag         <- function(d) sprintf("%03d", as.integer(round(as.numeric(d) * 100)))  # 0.05 -> "005"
.col_class_dbr   <- function(d) paste0("DF.class_dbr", .dbr_tag(d))
.col_class_auto  <- function()  "DF.class_auto"
.get_sample_col  <- function(md) if ("sample" %in% names(md)) "sample" else "orig.ident"

.update_registry <- function(so, dbr_runs, has_auto, seed, sample_col){
  if (is.null(so@misc$scDblFinder)) so@misc$scDblFinder <- list()
  so@misc$scDblFinder$dbr_runs   <- sort(unique(as.numeric(dbr_runs)))
  so@misc$scDblFinder$has_auto   <- isTRUE(has_auto)
  so@misc$scDblFinder$timestamp  <- Sys.time()
  so@misc$scDblFinder$version    <- tryCatch(as.character(utils::packageVersion("scDblFinder")), error = function(e) NA_character_)
  so@misc$scDblFinder$seed       <- seed
  so@misc$scDblFinder$sample_col <- sample_col
  so
}

# ---------- FAST UMAP (once) → store in meta.data and @misc ----------
.cache_umap_into_meta <- function(seu, dims_fast = 20, n_neighbors = 15, min_dist = 0.30, seed = 42L, force = FALSE){
  seed <- suppressWarnings(as.integer(seed %||% 42L))
  if (!is.finite(seed) || seed <= 0L) seed <- 42L
  existing_seed <- suppressWarnings(as.integer(seu@misc$umap_quick_seed %||% NA_integer_))
  has_quick <- all(c("UMAP1_quick","UMAP2_quick") %in% colnames(seu@meta.data)) &&
    !is.null(seu@misc$umap_quick) && is.matrix(seu@misc$umap_quick)
  if (!isTRUE(force) && has_quick && is.finite(existing_seed) && existing_seed == seed) return(seu)
  if (!is.null(seu@reductions$umap)) {
    emb <- Seurat::Embeddings(seu, "umap")
  } else if (!is.null(seu@reductions$pca)) {
    pcs <- Seurat::Embeddings(seu, "pca")
    k <- min(dims_fast, ncol(pcs))
    mat <- pcs[, seq_len(k), drop = FALSE]
    if (ok_uwot) {
      set.seed(seed)
      emb <- uwot::umap(mat, n_neighbors = n_neighbors, min_dist = min_dist,
                        verbose = FALSE, ret_model = FALSE, fast_sgd = TRUE)
      rownames(emb) <- rownames(mat); colnames(emb) <- c("UMAP_1","UMAP_2")
    } else {
      seu <- Seurat::RunUMAP(seu, reduction = "pca", dims = 1:k, seed.use = seed, verbose = FALSE)
      emb <- Seurat::Embeddings(seu, "umap")
    }
  } else {
    def_assay <- Seurat::DefaultAssay(seu)
    if ("integrated" %in% names(seu@assays)) Seurat::DefaultAssay(seu) <- "integrated"
    seu <- Seurat::NormalizeData(seu, verbose = FALSE)
    seu <- Seurat::FindVariableFeatures(seu, verbose = FALSE)
    seu <- Seurat::ScaleData(seu, verbose = FALSE)
    seu <- Seurat::RunPCA(seu, npcs = max(20, dims_fast), verbose = FALSE)
    Seurat::DefaultAssay(seu) <- def_assay
    pcs <- Seurat::Embeddings(seu, "pca")
    k <- min(dims_fast, ncol(pcs))
    mat <- pcs[, seq_len(k), drop = FALSE]
    if (ok_uwot) {
      set.seed(seed)
      emb <- uwot::umap(mat, n_neighbors = n_neighbors, min_dist = min_dist,
                        verbose = FALSE, ret_model = FALSE, fast_sgd = TRUE)
      rownames(emb) <- rownames(mat); colnames(emb) <- c("UMAP_1","UMAP_2")
    } else {
      seu <- Seurat::RunUMAP(seu, reduction = "pca", dims = 1:k, seed.use = seed, verbose = FALSE)
      emb <- Seurat::Embeddings(seu, "umap")
    }
  }
  seu@misc$umap_quick <- emb
  seu@misc$umap_quick_seed <- seed
  emb <- emb[colnames(seu), , drop = FALSE]
  seu@meta.data$UMAP1_quick <- emb[,1]
  seu@meta.data$UMAP2_quick <- emb[,2]
  seu
}

# ---------- scDblFinder per-sample (returns aligned vectors) ----------
.run_scdbl_one_dbr <- function(seu, dbr = NULL, dims = 30, samples_keep = NULL){
  if (!requireNamespace("scDblFinder", quietly = TRUE) || !requireNamespace("SingleCellExperiment", quietly = TRUE))
    stop("Please install scDblFinder and SingleCellExperiment.")
  md <- seu@meta.data
  sample_col <- .get_sample_col(md)
  samp_vec <- as.character(md[[sample_col]])
  samples <- sort(unique(samp_vec[!is.na(samp_vec)]))
  if (!is.null(samples_keep) && length(samples_keep)) {
    samples <- samples[samples %in% as.character(samples_keep)]
  }
  if (!length(samples)) stop("No selected samples available in object for scDblFinder run.")
  df_class <- setNames(rep(NA_character_, ncol(seu)), colnames(seu))
  df_score <- setNames(rep(NA_real_,      ncol(seu)), colnames(seu))
  for (s in samples) {
    cells_s <- rownames(md)[samp_vec == s]
    sub <- subset(seu, cells = cells_s)
    sce <- try(Seurat::as.SingleCellExperiment(sub, assay = "SCT"), silent = TRUE)
    if (inherits(sce, "try-error")) sce <- Seurat::as.SingleCellExperiment(sub, assay = "RNA")
    if (is.null(dbr)) sce <- scDblFinder::scDblFinder(sce, dims = dims)
    else              sce <- scDblFinder::scDblFinder(sce, dbr = dbr, dims = dims)
    lab <- as.character(SummarizedExperiment::colData(sce)$scDblFinder.class)
    scr <- as.numeric (SummarizedExperiment::colData(sce)$scDblFinder.score)
    lab <- ifelse(tolower(lab) == "doublet","Doublet",
                  ifelse(tolower(lab) == "singlet","Singlet", NA_character_))
    names(lab) <- colnames(sce); names(scr) <- colnames(sce)
    df_class[cells_s] <- lab[cells_s]
    df_score[cells_s] <- scr[cells_s]
  }
  list(class = df_class, score = df_score, sample_col = sample_col)
}

# ---------- summary of DF.class_* ----------
.collect_summary <- function(md){
  cls_cols <- grep("^DF\\.class_(?:dbr\\d+|auto)$", colnames(md), value = TRUE)
  if (!length(cls_cols)) return(data.frame())
  do.call(rbind, lapply(cls_cols, function(cl){
    tag <- sub("^DF\\.class_", "", cl)
    dbr <- if (tag == "auto") NA_real_ else as.numeric(sub("^dbr", "", tag))/100
    vals <- as.character(md[[cl]])
    n_tot <- sum(!is.na(vals))
    n_dbl <- sum(tolower(vals) == "doublet", na.rm = TRUE)
    rate  <- if (n_tot > 0) n_dbl / n_tot else NA_real_
    data.frame(tag = tag, dbr = dbr, observed_rate = rate, stringsAsFactors = FALSE)
  }))
}

# ---------- RGB utility (confocal) ----------
.rgb_hex_from_three <- function(a, b, c) {
  clamp <- function(x) {
    x[!is.finite(x)] <- NA_real_
    q <- stats::quantile(x, 0.99, na.rm = TRUE)
    x <- pmin(x, q, na.rm = TRUE)
    rng <- range(x, na.rm = TRUE)
    if (diff(rng) == 0) return(rep(0, length(x)))
    (x - rng[1]) / diff(rng)
  }
  R <- clamp(a); G <- clamp(b); B <- clamp(c)
  cols <- grDevices::rgb(R, G, B, alpha = 0.9)
  cols[!is.finite(R) | !is.finite(G) | !is.finite(B)] <- "#00000015"
  cols
}

# =======================================================
# UI: header with Skip, then tabs (Summary / UMAP Overlay / Choose Final)
# =======================================================
doublet_ui <- fluidPage(
  tags$head(
    # NOTE: global.css removed. app.R handles global styling via navbar.css & custom_bslib.css
    tags$style(HTML("
      .header-row { display:flex; align-items:flex-start; justify-content:space-between; margin-bottom:2px; }
      .dbl-inline-note { margin: 10px 0 12px 0; padding: 14px 16px; border-radius: 8px; font-size: 1.05rem; }
      .dbl-inline-note.alert-info { background-color: #3d95cf; color: #ffffff; border-color: #3d95cf; }
      .selectize-input { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
      .selectize-dropdown-content { max-width: 520px; }
    "))
  ),
  div(
    class = "app-page plotting-page",
    div(
      class = "page-header",
      h2(icon("users"), " ", DOUBLET_UI_TEXT$t_title_qc_doublet_finder),
      p(DOUBLET_UI_TEXT$t_text_run_scdblfinder_detect_doublets_inspect_overlays)
    ),
    uiOutput("dbl_notice_ui"),
    tabsetPanel(
      id = "dbl_tabs",
      tabPanel(
        DOUBLET_UI_TEXT$t_title_summary,
        fluidRow(
          column(
            3,
            class = "plotting-left-panel",
            div(
              class = "wl-side",
              uiOutput("dbl_obj_picker"),
              uiOutput("dbl_sample_picker"),
              uiOutput("dbl_scope_note_ui"),
              checkboxInput("dbl_include_auto", DOUBLET_UI_TEXT$t_label_include_scdblfinder_auto_run, value = TRUE),
              sliderInput("dbl_dbr_range", DOUBLET_UI_TEXT$t_label_doublet_rate_dbr_range, min = 0.01, max = 0.99, value = c(0.05, 0.99), step = 0.01),
              sliderInput("dbl_dbr_step",  DOUBLET_UI_TEXT$t_label_doublet_rate_dbr_step,  min = 0.005, max = 0.05, value = 0.05, step = 0.005),
              numericInput("dbl_dims", DOUBLET_UI_TEXT$t_label_dims_pca_scdblfinder, value = 30, min = 10, max = 100, step = 1),
              numericInput("dbl_seed", DOUBLET_UI_TEXT$t_label_seed, value = 42, min = 1, max = 9999999, step = 1),
              actionButton("dbl_run", DOUBLET_UI_TEXT$t_btn_run_scdblfinder, class = "btn btn-primary", width = "100%")
            )
          ),
          column(
            9,
            class = "plot_area_card_style",
            div(
              class = "wl-side",
              qc_with_busy_spinner(plotlyOutput("dbl_rate_plot", height = 280)),
              qc_with_busy_spinner(DTOutput("dbl_summary_tbl"))
            )
          )
        ),
        div(
          style = "display:flex; justify-content:flex-end; margin-top:8px;",
          actionButton("dbl_next_from_summary", DOUBLET_UI_TEXT$t_btn_next_umap_overlay, class = "btn btn-secondary")
        )
      ),
      tabPanel(
        DOUBLET_UI_TEXT$t_title_umap_overlay,
        fluidRow(
          column(
            3,
            class = "plotting-left-panel",
            div(
              class = "wl-side",
              uiOutput("dbl_umap_choice_ui"),
              h4(DOUBLET_UI_TEXT$t_title_confocal_genes),
              uiOutput("dbl_gene_pickers")
            )
          ),
          column(
            9,
            class = "plot_area_card_style",
            fluidRow(
              column(
                6,
                div(
                  class = "wl-side",
                  h5(DOUBLET_UI_TEXT$t_title_doublet_umap),
                  qc_with_busy_spinner(plotOutput("dbl_umap_plot", height = 500))
                )
              ),
              column(
                6,
                div(
                  class = "wl-side",
                  h5(DOUBLET_UI_TEXT$t_title_confocal_rgb),
                  qc_with_busy_spinner(plotOutput("dbl_confocal_plot", height = 500))
                )
              )
            )
          )
        ),
        div(
          style = "display:flex; justify-content:flex-end; margin-top:8px;",
          actionButton("dbl_next_from_umap", DOUBLET_UI_TEXT$t_btn_next_choose_final, class = "btn btn-secondary")
        )
      ),
      tabPanel(
        DOUBLET_UI_TEXT$t_title_choose_final,
        fluidRow(
          column(
            3,
            class = "plotting-left-panel",
            div(
              class = "wl-side",
              uiOutput("dbl_choice_ui"),
              actionButton("dbl_apply", DOUBLET_UI_TEXT$t_btn_set_chosen_dbr, class = "btn btn-success", width = "100%"),
              div(style = "height:8px"),
              actionButton("dbl_proceed_analysis", DOUBLET_UI_TEXT$t_btn_proceed_analysis, class = "btn btn-primary", width = "100%")
            )
          )
        )
      )
    )
  )
)

# =======================================================
# SERVER
# =======================================================
doublet_server <- function(input, output, session, shared_data){
  dbl_notice <- reactiveVal(list(type = "info", msg = DOUBLET_UI_TEXT$t_text_run_scdblfinder_detect_doublets_inspect_overlays))
  output$dbl_notice_ui <- renderUI({
    note <- dbl_notice()
    if (is.null(note) || !nzchar(note$msg %||% "")) return(NULL)
    cls <- if (identical(note$type, "error")) "alert alert-danger" else if (identical(note$type, "warning")) "alert alert-warning" else "alert alert-info"
    div(class = paste(cls, "dbl-inline-note"), note$msg)
  })
  
  # Navigation fix: Use updateNavbarPage instead of updateTabsetPanel
  observeEvent(input$dbl_proceed_analysis, {
    overlay_show(DOUBLET_UI_TEXT$t_text_preparing_singlet_subset_for_analysis, loader = "filter")
    on.exit(overlay_hide(), add = TRUE)
    ent <- .get_entry(); req(ent)
    seu <- .get_seurat(); req(seu)
    
    chosen <- (seu@misc$scDblFinder$chosen_tag %||% input$dbl_final_tag) %||% NA_character_
    if (!is.na(chosen)) {
      tag_to_use <- chosen
    } else if ("DF.class_auto" %in% colnames(seu@meta.data)) {
      tag_to_use <- "auto"
    } else {
      hit <- grep("^DF\\.class_(.+)$", colnames(seu@meta.data), value = TRUE)
      tag_to_use <- if (length(hit)) sub("^DF\\.class_", "", hit[1]) else NA_character_
      if (!is.na(tag_to_use))
        showNotification(sprintf("No choice set; using '%s'.", tag_to_use), type = "message")
    }
    
    active_name <- input$dbl_obj_name
    new_name <- NULL
    if (!is.na(tag_to_use)) {
      new_name <- .create_doublet_filtered_entry(active_name, seu, tag_to_use)
    }
    final_name <- new_name %||% active_name
    
    shared_data$active_object_name <- final_name
    showNotification(
      sprintf("Proceeding to Analysis with '%s'%s.",
              final_name,
              if (!is.na(tag_to_use) && !is.null(new_name)) sprintf(" (Singlets from %s)", tag_to_use) else ""),
      type = "message"
    )
    # FIX: Use updateNavbarPage for the new layout
    updateNavbarPage(session, "main_navbar", selected = "analysis_tab")
  })
  
  observe({
    # We don't check for main_tabs inputs here anymore as the parent handles nav state
    # This block is simplified
  })
  
  show_blocker <- function(msg = "Working…", pct = NULL){
    overlay_show(text = msg, pct = pct, loader = "metrics")
  }
  update_blocker <- function(msg = NULL, pct = NULL){
    overlay_show(text = msg %||% "Working…", pct = pct, loader = "metrics")
  }
  hide_blocker <- function(){
    overlay_hide()
  }
  
  # --- object pick (under Summary tab) ---
  output$dbl_obj_picker <- renderUI({
    reg <- shared_data$all_seurat_objects %||% list()
    validate(need(length(reg) > 0, "No Seurat objects available."))
    # Prefer explicit pre-doublet/active context; missing context resolves to
    # newest registry entry under the shared active-object contract.
    object_names <- names(reg) %||% character(0)
    nm_default <- as.character(shared_data$pre_doublet_bundle %||% shared_data$active_object_name %||% "")
    nm_default <- if (length(nm_default) && nzchar(nm_default[[1]]) && nm_default[[1]] %in% object_names) {
      nm_default[[1]]
    } else if (length(object_names)) {
      object_names[[length(object_names)]]
    } else {
      ""
    }
    selectInput("dbl_obj_name", DOUBLET_UI_TEXT$t_label_object, choices = names(reg), selected = nm_default)
  })
  
  .get_entry  <- reactive({ req(input$dbl_obj_name); shared_data$all_seurat_objects[[input$dbl_obj_name]] })
  .get_seurat <- reactive({ ent <- .get_entry(); req(ent); ent$obj %||% ent$seurat %||% ent$object })
  .sample_scope_cells <- reactive({
    seu <- .get_seurat(); req(seu)
    md <- seu@meta.data
    sample_col <- .get_sample_col(md)
    scope <- as.character(input$dbl_sample_scope %||% "All samples")
    if (identical(scope, "All samples")) return(colnames(seu))
    cells <- rownames(md)[as.character(md[[sample_col]]) == scope]
    unique(cells[cells %in% colnames(seu)])
  })
  .scope_has_tag <- function(tag) {
    seu <- .get_seurat(); req(seu)
    md <- seu@meta.data
    cl_col <- paste0("DF.class_", tag)
    if (!(cl_col %in% colnames(md))) return(FALSE)
    cells <- .sample_scope_cells()
    if (!length(cells)) return(FALSE)
    vals <- as.character(md[cells, cl_col, drop = TRUE])
    any(!is.na(vals) & nzchar(vals))
  }
  output$dbl_sample_picker <- renderUI({
    seu <- .get_seurat(); req(seu)
    md <- seu@meta.data
    sample_col <- .get_sample_col(md)
    vals <- sort(unique(as.character(md[[sample_col]])[!is.na(md[[sample_col]])]))
    choices <- c("All samples", vals)
    selected <- isolate(input$dbl_sample_scope %||% "All samples")
    if (!(selected %in% choices)) selected <- "All samples"
    tagList(
      selectInput("dbl_sample_scope", DOUBLET_UI_TEXT$t_label_sample_scope, choices = choices, selected = selected),
      tags$div(
        class = "text-muted",
        style = "font-size: 12px; margin-top: 2px; margin-bottom: 8px;",
        sprintf("Scope options are sample IDs from this selected object only (metadata column: %s).", sample_col)
      )
    )
  })
  output$dbl_scope_note_ui <- renderUI({
    seu <- .get_seurat(); req(seu)
    md <- seu@meta.data
    scope <- as.character(input$dbl_sample_scope %||% "All samples")
    if (identical(scope, "All samples")) return(NULL)
    cls_cols <- grep("^DF\\.class_(?:dbr\\d+|auto)$", colnames(md), value = TRUE)
    if (!length(cls_cols)) return(NULL)
    cells <- .sample_scope_cells()
    if (!length(cells)) {
      return(div(class = "alert alert-warning dbl-inline-note", sprintf("Selected sample '%s' has no cells in this object.", scope)))
    }
    has_any <- FALSE
    for (cc in cls_cols) {
      vals <- as.character(md[cells, cc, drop = TRUE])
      if (any(!is.na(vals) & nzchar(vals))) {
        has_any <- TRUE
        break
      }
    }
    if (isTRUE(has_any)) return(NULL)
    div(class = "alert alert-warning dbl-inline-note",
        sprintf("Selected sample '%s' has not run scDblFinder/DBR yet. Run DBR for this sample scope first.", scope))
  })
  
  .dbl_task <- new.env(parent = emptyenv())
  .dbl_task$run_seq <- 0L
  .dbl_task$task_id <- ""
  .dbl_task$pause_requested <- FALSE
  .dbl_task$paused <- FALSE
  .dbl_task$skip_requested <- FALSE
  .dbl_task$cancel_requested <- FALSE
  .dbl_task$controls_available <- isTRUE(ok_later)
  .dbl_controls <- function(state = "running", note = NULL) {
    actions <- if (identical(state, "paused")) {
      list(
        overlay_control_action("resume", label = "Resume"),
        overlay_control_action(
          "cancel",
          label = "Cancel",
          confirm_title = "Cancel doublet detection?",
          confirm_detail = "Completed results will be discarded. The last valid state stays unchanged.",
          confirm_label = "Confirm cancel"
        )
      )
    } else if (identical(state, "running") && isTRUE(.dbl_task$controls_available)) {
      list(
        overlay_control_action("pause", label = "Pause"),
        overlay_control_action(
          "skip",
          label = "Skip remaining DBR",
          confirm_title = "Skip remaining DBR rates?",
          confirm_detail = "Finish current DBR, keep completed DBRs, then build the summary.",
          confirm_label = "Skip remaining"
        ),
        overlay_control_action(
          "cancel",
          label = "Cancel",
          confirm_title = "Cancel doublet detection?",
          confirm_detail = "Completed results will be discarded. The last valid state stays unchanged.",
          confirm_label = "Confirm cancel"
        )
      )
    } else {
      list()
    }
    overlay_controls(
      task_id = .dbl_task$task_id,
      actions = actions,
      state = state,
      note = note %||% if (identical(state, "paused")) {
        "Paused after current DBR. Resume to continue or cancel."
      } else if (identical(state, "running") && isTRUE(.dbl_task$controls_available)) {
        "Pause, skip, and cancel take effect after the current DBR."
      } else if (identical(state, "running")) {
        "Controls unavailable because safe event checkpoints are not available."
      } else {
        "Controls unavailable during this step. The current R call cannot be paused safely."
      }
    )
  }
  observeEvent(input$global_overlay_action, {
    payload <- input$global_overlay_action
    if (!is.list(payload)) return()
    if (!identical(as.character(payload$taskId %||% ""), .dbl_task$task_id)) return()
    action <- as.character(payload$action %||% "")
    if (identical(action, "pause")) .dbl_task$pause_requested <- TRUE
    if (identical(action, "resume")) .dbl_task$pause_requested <- FALSE
    if (identical(action, "skip")) .dbl_task$skip_requested <- TRUE
    if (identical(action, "cancel")) .dbl_task$cancel_requested <- TRUE
  }, ignoreInit = TRUE)
  session$onSessionEnded(function() {
    .dbl_task$cancel_requested <- TRUE
  })

  # --- run scDblFinder (per-sample) + pre-cache UMAP into meta ---
  observeEvent(input$dbl_run, {
    .dbl_task$run_seq <- as.integer(.dbl_task$run_seq) + 1L
    .dbl_task$task_id <- paste0("doublet-detection-", .dbl_task$run_seq)
    .dbl_task$pause_requested <- FALSE
    .dbl_task$paused <- FALSE
    .dbl_task$skip_requested <- FALSE
    .dbl_task$cancel_requested <- FALSE
    .dbl_task$controls_available <- isTRUE(ok_later)
    on.exit({
      .dbl_task$cancel_requested <- TRUE
      .dbl_task$task_id <- ""
    }, add = TRUE)
    seu <- .get_seurat(); req(seu)
    dbl_notice(list(type = "info", msg = "Running scDblFinder..."))
    
    rng  <- input$dbl_dbr_range; st <- input$dbl_dbr_step
    rates <- seq(rng[1], rng[2], by = st)
    rates <- rates[is.finite(rates) & rates > 0 & rates < 1]
    if (!length(rates) && !isTRUE(input$dbl_include_auto)) {
      dbl_notice(NULL)
      showNotification("Provide at least one DBR or enable auto.", type = "error"); return()
    }
    
    set.seed(input$dbl_seed)
    .mem_used_mb <- function() {
      suppressWarnings({
        g <- gc()
        as.numeric(sum(g[, 2], na.rm = TRUE))
      })
    }
    md <- seu@meta.data
    sample_col <- .get_sample_col(md)
    samp_vec <- as.character(md[[sample_col]])
    all_samples <- sort(unique(samp_vec[!is.na(samp_vec)]))
    sample_scope <- as.character(input$dbl_sample_scope %||% "All samples")
    target_samples <- if (identical(sample_scope, "All samples")) all_samples else intersect(all_samples, sample_scope)
    if (!length(target_samples)) {
      dbl_notice(NULL)
      showNotification("Selected sample scope is not available in this object.", type = "error")
      return()
    }
    have_auto <- FALSE
    done_tags <- character(0)
    
    # ---- progress accounting (per-sample granularity) ----
    auto_units  <- if (isTRUE(input$dbl_include_auto)) 1 else 0              # treat auto as 1 unit
    per_dbr_units <- max(1, length(target_samples))                           # per-sample within each dbr
    dbr_units   <- length(rates) * per_dbr_units
    final_units <- 2                                                         # cache UMAP + finalize
    total_units <- auto_units + dbr_units + final_units
    units_done  <- 0
    
    pct <- function(){ if (total_units <= 0) 0 else (units_done / total_units) * 100 }
    
    overlay_show(
      text = "Preparing scDblFinder runs...",
      pct = pct(),
      loader = "metrics",
      controls = .dbl_controls()
    )
    on.exit(hide_blocker(), add = TRUE)
    
    yield <- function(){ Sys.sleep(0.02); if (ok_later) later::run_now(0.001) }
    
    # Shiny progress bar mirrors the same units
    progress <- shiny::Progress$new(session, min = 0, max = total_units)
    on.exit(progress$close(), add = TRUE)
    last_ui_ts <- as.numeric(Sys.time())
    last_ui_pct <- -1L
    .push_ui <- function(message_txt,
                         pct_val,
                         detail_txt = NULL,
                         force = FALSE,
                         control_state = NULL,
                         control_note = NULL) {
      now <- as.numeric(Sys.time())
      pct_i <- as.integer(round(pct_val %||% 0))
      should_push <- isTRUE(force) || (pct_i != last_ui_pct) || ((now - last_ui_ts) >= 0.35)
      if (!isTRUE(should_push)) return(invisible(NULL))
      state_use <- control_state %||% if (isTRUE(.dbl_task$paused)) "paused" else "running"
      overlay_show(
        text = message_txt,
        pct = pct_i,
        loader = "metrics",
        controls = .dbl_controls(state = state_use, note = control_note)
      )
      progress$set(
        value = units_done,
        message = message_txt %||% "Running scDblFinder…",
        detail = detail_txt %||% sprintf("%d%%", pct_i)
      )
      last_ui_ts <<- now
      last_ui_pct <<- pct_i
      invisible(NULL)
    }
    dbl_checkpoint <- function(pct_val, detail_txt) {
      if (!isTRUE(.dbl_task$controls_available)) return("continue")
      if (isTRUE(.dbl_task$cancel_requested)) return("cancel")
      if (isTRUE(.dbl_task$skip_requested)) return("skip")
      if (!isTRUE(.dbl_task$pause_requested)) return("continue")
      .dbl_task$paused <- TRUE
      .push_ui(
        "Doublet detection paused.",
        pct_val,
        "Paused after current DBR. Resume to continue or cancel.",
        force = TRUE,
        control_state = "paused",
        control_note = "Paused after current DBR. Resume to continue or cancel."
      )
      repeat {
        yield()
        if (isTRUE(.dbl_task$cancel_requested)) return("cancel")
        if (isTRUE(.dbl_task$skip_requested)) return("skip")
        if (isTRUE(.dbl_task$pause_requested)) next
        .dbl_task$paused <- FALSE
        .push_ui("Resuming doublet detection...", pct_val, detail_txt, force = TRUE)
        return("continue")
      }
    }
    progress$set(value = 0,
                 message = "Preparing scDblFinder runs…",
                 detail  = sprintf("0 of %d units", total_units))
    
    if (isTRUE(input$dbl_include_auto)) {
      .push_ui("Running scDblFinder (auto)…", pct(), "Estimating doublets at auto dbr", force = TRUE); yield()
      
      res <- .run_scdbl_one_dbr(seu, dbr = NULL, dims = input$dbl_dims, samples_keep = target_samples)
      seu@meta.data[[.col_class_auto()]] <- res$class
      rm(res)
      invisible(gc(FALSE))
      have_auto <- TRUE; done_tags <- c(done_tags, "auto")
      
      units_done <- units_done + 1
      .push_ui("Finished auto", pct(), "Wrote DF.class_auto", force = TRUE); yield()
      if (isTRUE(.dbl_task$cancel_requested)) {
        showNotification("Doublet detection cancelled. Last valid state remains unchanged.", type = "message")
        return(invisible(NULL))
      }
    }
    
    completed_rates <- numeric(0)
    for (r in rates) {
      tag_class <- .col_class_dbr(r)
      .push_ui(
        sprintf("Running dbr=%.3f", r),
        pct(),
        sprintf("Processing %d samples…", max(1, length(target_samples))),
        force = TRUE
      ); yield()
      
      # per-sample (logs + work)
      md <- seu@meta.data
      samp_vec <- as.character(md[[sample_col]])
      samples <- target_samples
      if (!length(samples)) samples <- "all"
      df_class <- setNames(rep(NA_character_, ncol(seu)), colnames(seu))
      
      for (s in samples) {
        .push_ui(sprintf("dbr=%.3f — sample '%s'", r, s), pct(), sprintf("Sample '%s'…", s)); yield()
        
        if (identical(s, "all")) {
          # fallback: run once on the full object if no sample column
          sub <- seu
          cells_s <- colnames(seu)
        } else {
          cells_s <- rownames(md)[samp_vec == s]
          sub <- subset(seu, cells = cells_s)
        }
        
        sce <- try(Seurat::as.SingleCellExperiment(sub, assay = "SCT"), silent = TRUE)
        if (inherits(sce, "try-error")) sce <- Seurat::as.SingleCellExperiment(sub, assay = "RNA")
        sce <- scDblFinder::scDblFinder(sce, dbr = r, dims = input$dbl_dims)
        lab <- as.character(SummarizedExperiment::colData(sce)$scDblFinder.class)
        lab <- ifelse(tolower(lab) == "doublet","Doublet",
                      ifelse(tolower(lab) == "singlet","Singlet", NA_character_))
        names(lab) <- colnames(sce)
        df_class[colnames(sce)] <- lab[colnames(sce)]
        rm(sub, sce, lab, cells_s)
        invisible(gc(FALSE))
        
        units_done <- units_done + 1
        .push_ui(
          sprintf("dbr=%.3f — sample '%s' done", r, s),
          pct(),
          sprintf("Completed sample '%s' (mem %.0f MB)", s, .mem_used_mb())
        ); yield()
      }
      
      seu@meta.data[[tag_class]] <- df_class
      done_tags <- c(done_tags, paste0("dbr", .dbr_tag(r)))
      rm(df_class, md, samp_vec, samples)
      invisible(gc(FALSE))
      
      .push_ui(
        sprintf("Finished dbr=%.3f", r),
        pct(),
        sprintf("Wrote %s (mem %.0f MB)", tag_class, .mem_used_mb()),
        force = TRUE
      ); yield()
      completed_rates <- c(completed_rates, r)
      checkpoint <- dbl_checkpoint(pct(), sprintf("Completed dbr=%.3f.", r))
      if (identical(checkpoint, "cancel")) {
        showNotification("Doublet detection cancelled. Last valid state remains unchanged.", type = "message")
        return(invisible(NULL))
      }
      if (identical(checkpoint, "skip")) {
        total_units <- auto_units + length(completed_rates) * per_dbr_units + final_units
        showNotification("Remaining DBR rates skipped. Building the summary from completed results.", type = "message")
        break
      }
    }
    
    .push_ui(
      "Caching UMAP coordinates...",
      pct(),
      "Writing UMAP1_quick / UMAP2_quick",
      force = TRUE,
      control_state = "unavailable",
      control_note = "Controls unavailable during this step. The current R call cannot be paused safely."
    ); yield()
    seu <- .cache_umap_into_meta(seu)
    
    units_done <- units_done + 1
    .push_ui(
      "Finalizing...",
      pct(),
      "Updating registry",
      force = TRUE,
      control_state = "unavailable",
      control_note = "Controls unavailable during this step. The current R call cannot be paused safely."
    ); yield()
    
    seu <- .update_registry(seu, dbr_runs = completed_rates, has_auto = have_auto,
                            seed = input$dbl_seed, sample_col = sample_col)
    ent <- .get_entry(); ent$obj <- seu
    shared_data$all_seurat_objects[[input$dbl_obj_name]] <- ent
    
    units_done <- units_done + 1
    .push_ui("All jobs completed.", pct(), paste(done_tags, collapse = ", "), force = TRUE); yield()

    dbl_notice(list(type = "info", msg = sprintf("scDblFinder finished: %d DBR run(s)%s.", length(completed_rates), if (isTRUE(input$dbl_include_auto)) " + auto" else "")))
  }, ignoreInit = TRUE)
  
  # --- summary table & plot (Summary tab) ---
  .summary_df <- reactive({
    seu <- .get_seurat(); req(seu)
    .collect_summary(seu@meta.data)
  })
  
  output$dbl_summary_tbl <- renderDT({
    df <- .summary_df()
    if (!nrow(df)) {
      return(datatable(data.frame(Message = "No DF.class_* columns yet."),
                       options = list(dom='t', paging = FALSE)))
    }
    df$observed_pct <- round(df$observed_rate * 100, 2)
    df <- df[order(is.na(df$dbr), df$dbr), ]
    datatable(.safe_select_cols(df, c("tag","dbr","observed_pct"), default = NA),
              rownames = FALSE,
              options = list(pageLength = 10, order = list(list(2, "asc"))))
  }, server = FALSE)
  
  output$dbl_rate_plot <- renderPlotly({
    df <- .summary_df()
    if (!nrow(df)) {
      return(
        plotly::plot_ly(
          x = numeric(0), y = numeric(0),
          type = "scatter", mode = "markers",
          showlegend = FALSE
        ) |>
          plotly::layout(
            xaxis = list(visible = FALSE),
            yaxis = list(visible = FALSE),
            annotations = list(list(
              x = 0.5, y = 0.5, xref = "paper", yref = "paper",
              xanchor = "center", yanchor = "middle",
              text = DOUBLET_UI_TEXT$t_text_run_scdblfinder_first %||% "Run scDblFinder first to see summary trends and choose a final tag.",
              showarrow = FALSE,
              font = list(size = 15, color = "#475569")
            )),
            margin = list(l = 10, r = 10, t = 10, b = 10)
          )
      )
    }
    df_num  <- df[!is.na(df$dbr), , drop = FALSE]
    df_auto <- df[is.na(df$dbr), , drop = FALSE]
    
    p <- plotly::plot_ly()
    if (nrow(df_num)) {
      p <- p |>
        plotly::add_lines   (data = df_num,  x = ~dbr, y = ~observed_rate, name = "Observed vs dbr") |>
        plotly::add_markers (data = df_num,  x = ~dbr, y = ~observed_rate, name = "Points")
    }
    if (nrow(df_auto)) {
      p <- p |>
        plotly::add_markers (data = df_auto, x = 0,    y = ~observed_rate, name = "auto")
    }
    p |>
      plotly::layout(xaxis = list(title = DOUBLET_UI_TEXT$t_text_input_dbr, tickformat = ".0%"),
                     yaxis = list(title = DOUBLET_UI_TEXT$t_text_observed_doublet_rate, tickformat = ".0%"))
  })
  
  # --- UMAP/genes (UMAP tab) ---
  output$dbl_umap_choice_ui <- renderUI({
    df <- .summary_df()
    validate(need(nrow(df) > 0, "No results yet."))
    selectInput("dbl_umap_tag", DOUBLET_UI_TEXT$t_label_umap_overlay, choices = df$tag, selected = df$tag[1])
  })
  
  seu_umap_cached <- reactive({
    seu <- .get_seurat(); req(seu)
    .cache_umap_into_meta(seu)
  })
  
  expr_cached <- reactive({
    seu <- seu_umap_cached(); req(seu)
    .dbl_pick_expr_matrix(seu)
  })
  .dbl_feature_names <- function(seu, expr_info = NULL) {
    if (!is.null(expr_info) && is.list(expr_info) && !is.null(expr_info$expr)) {
      rn <- rownames(expr_info$expr)
      rn <- rn[is.finite(nchar(rn)) & nzchar(rn)]
      if (length(rn)) return(unique(as.character(rn)))
    }
    mats <- list(
      .dbl_get_assay_data(seu, assay = tryCatch(as.character(Seurat::DefaultAssay(seu)), error = function(e) ""), layer = "data"),
      .dbl_get_assay_data(seu, assay = "SCT", layer = "data"),
      .dbl_get_assay_data(seu, assay = "RNA", layer = "data"),
      .dbl_get_assay_data(seu, assay = tryCatch(as.character(Seurat::DefaultAssay(seu)), error = function(e) ""), layer = "counts"),
      .dbl_get_assay_data(seu, assay = "SCT", layer = "counts"),
      .dbl_get_assay_data(seu, assay = "RNA", layer = "counts")
    )
    for (m in mats) {
      if (!is.null(m)) {
        rn <- rownames(m)
        rn <- rn[is.finite(nchar(rn)) & nzchar(rn)]
        if (length(rn)) return(unique(as.character(rn)))
      }
    }
    character(0)
  }
  
  output$dbl_gene_pickers <- renderUI({
    tagList(
      wl_gene_selectize_input("gene_r", DOUBLET_UI_TEXT$t_text_red_channel, placeholder = DOUBLET_UI_TEXT$t_text_type_search_gene),
      wl_gene_selectize_input("gene_g", DOUBLET_UI_TEXT$t_text_green_channel, placeholder = DOUBLET_UI_TEXT$t_text_type_search_gene),
      wl_gene_selectize_input("gene_b", DOUBLET_UI_TEXT$t_text_blue_channel, placeholder = DOUBLET_UI_TEXT$t_text_type_search_gene)
    )
  })
  .dbl_gene_sig <- reactiveVal("")

  .update_dbl_gene_selects <- function() {
    # Controls live in UMAP tab; do not push updates while tab is inactive.
    if (!identical(input$dbl_tabs %||% "", DOUBLET_UI_TEXT$t_title_umap_overlay)) return(invisible(NULL))
    seu <- seu_umap_cached(); req(seu)
    expr_info <- expr_cached()
    all_genes <- .dbl_feature_names(seu, expr_info = expr_info)
    if (!length(all_genes)) return(invisible(NULL))
    v <- tryCatch(Seurat::VariableFeatures(seu), error = function(e) NULL)
    v_keep <- if (!is.null(v) && length(v)) v[v %in% all_genes] else character(0)
    defaults <- if (length(v_keep) >= 3) v_keep[1:3] else head(all_genes, 3)
    if (length(defaults) < 3) defaults <- rep_len(defaults, 3)
    keep_or_default <- function(current, fallback) {
      if (!is.null(current) && length(current) == 1 && nzchar(current) && current %in% all_genes) current else fallback
    }
    sel_r <- keep_or_default(isolate(input$gene_r), defaults[1])
    sel_g <- keep_or_default(isolate(input$gene_g), defaults[2])
    sel_b <- keep_or_default(isolate(input$gene_b), defaults[3])
    sig <- paste(
      input$dbl_obj_name %||% "",
      length(all_genes),
      all_genes[[1]],
      all_genes[[length(all_genes)]],
      sel_r, sel_g, sel_b,
      sep = "|"
    )
    if (identical(sig, .dbl_gene_sig())) return(invisible(NULL))
    freezeReactiveValue(input, "gene_r")
    freezeReactiveValue(input, "gene_g")
    freezeReactiveValue(input, "gene_b")
    wl_update_gene_selectize(session, "gene_r", all_genes, selected = sel_r)
    wl_update_gene_selectize(session, "gene_g", all_genes, selected = sel_g)
    wl_update_gene_selectize(session, "gene_b", all_genes, selected = sel_b)
    .dbl_gene_sig(sig)
  }
  
  observeEvent(list(seu_umap_cached(), expr_cached(), input$dbl_obj_name), {
    .update_dbl_gene_selects()
  }, ignoreInit = FALSE)

  observeEvent(input$dbl_tabs, {
    if (identical(input$dbl_tabs, DOUBLET_UI_TEXT$t_title_umap_overlay)) {
      .update_dbl_gene_selects()
    }
  }, ignoreInit = TRUE)
  
  output$dbl_umap_plot <- renderPlot({
    seu <- seu_umap_cached(); req(seu, input$dbl_umap_tag)
    if (!.scope_has_tag(input$dbl_umap_tag)) {
      scope <- as.character(input$dbl_sample_scope %||% "All samples")
      msg <- if (identical(scope, "All samples")) {
        sprintf("Tag '%s' has not run yet. Run scDblFinder first.", input$dbl_umap_tag)
      } else {
        sprintf("Sample '%s' has not run tag '%s' yet.", scope, input$dbl_umap_tag)
      }
      plot.new(); title(msg); return(invisible(NULL))
    }
    md <- seu@meta.data
    cl_col <- paste0("DF.class_", input$dbl_umap_tag)
    validate(need(cl_col %in% colnames(md), sprintf("Column %s not found.", cl_col)))
    validate(need(all(c("UMAP1_quick", "UMAP2_quick") %in% colnames(md)),
                  "UMAP coordinates not available yet."))
    xy  <- .safe_select_cols(md, c("UMAP1_quick","UMAP2_quick"), default = NA_real_)
    cls_raw <- as.character(md[[cl_col]])
    cls <- ifelse(tolower(cls_raw) == "doublet", "Doublet",
                  ifelse(tolower(cls_raw) == "singlet", "Singlet", NA_character_))
    df <- data.frame(
      UMAP1_quick = suppressWarnings(as.numeric(xy$UMAP1_quick)),
      UMAP2_quick = suppressWarnings(as.numeric(xy$UMAP2_quick)),
      Class = cls,
      stringsAsFactors = FALSE
    )
    df <- df[is.finite(df$UMAP1_quick) & is.finite(df$UMAP2_quick) & !is.na(df$Class), , drop = FALSE]
    if (!nrow(df)) {
      plot.new(); title("No valid UMAP points available."); return(invisible(NULL))
    }
    df$Class <- factor(df$Class, levels = c("Singlet", "Doublet"))
    p <- ggplot2::ggplot(df, ggplot2::aes(x = UMAP1_quick, y = UMAP2_quick, color = Class)) +
      ggplot2::geom_point(size = 0.55, alpha = 0.9) +
      ggplot2::scale_color_manual(values = c("Singlet" = "#12a365", "Doublet" = "#e53935"), drop = FALSE) +
      ggplot2::coord_equal() +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::labs(x = DOUBLET_UI_TEXT$t_text_umap_1, y = DOUBLET_UI_TEXT$t_text_umap_2, color = NULL)
    print(p)
  })
  
  output$dbl_confocal_plot <- renderPlot({
    seu <- seu_umap_cached(); req(seu)
    if (!.scope_has_tag(input$dbl_umap_tag %||% "")) {
      scope <- as.character(input$dbl_sample_scope %||% "All samples")
      msg <- if (identical(scope, "All samples")) {
        "Run scDblFinder first to render confocal RGB."
      } else {
        sprintf("Sample '%s' has not run selected DBR tag yet.", scope)
      }
      plot.new(); title(msg); return(invisible(NULL))
    }
    if (!nzchar(input$gene_r %||% "") || !nzchar(input$gene_g %||% "") || !nzchar(input$gene_b %||% "")) {
      plot.new(); title("Select R/G/B genes to render confocal RGB."); return(invisible(NULL))
    }
    expr_info <- expr_cached(); req(expr_info, expr_info$expr)
    expr <- expr_info$expr
    gs <- c(input$gene_r, input$gene_g, input$gene_b)
    gs_keep <- gs[gs %in% rownames(expr)]
    validate(need(length(gs_keep) == 3, "Selected genes not found in object."))
    a <- as.numeric(expr[gs_keep[1], colnames(seu)])
    b <- as.numeric(expr[gs_keep[2], colnames(seu)])
    c <- as.numeric(expr[gs_keep[3], colnames(seu)])
    cols <- .rgb_hex_from_three(a, b, c)
    md <- seu@meta.data
    validate(need(all(c("UMAP1_quick", "UMAP2_quick") %in% colnames(md)),
                  "UMAP coordinates not available yet."))
    xy <- .safe_select_cols(md, c("UMAP1_quick","UMAP2_quick"), default = NA_real_)
    df <- data.frame(
      UMAP1_quick = suppressWarnings(as.numeric(xy$UMAP1_quick)),
      UMAP2_quick = suppressWarnings(as.numeric(xy$UMAP2_quick)),
      col = cols,
      stringsAsFactors = FALSE
    )
    df <- df[is.finite(df$UMAP1_quick) & is.finite(df$UMAP2_quick), , drop = FALSE]
    if (!nrow(df)) {
      plot.new(); title("No valid UMAP points available."); return(invisible(NULL))
    }
    p <- ggplot2::ggplot(df, ggplot2::aes(x = UMAP1_quick, y = UMAP2_quick)) +
      ggplot2::geom_point(color = df$col, size = 0.55, alpha = 0.9) +
      ggplot2::coord_equal() +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::labs(
        x = paste0("UMAP 1 — R:", gs_keep[1]),
        y = paste0("UMAP 2 — G:", gs_keep[2], "  B:", gs_keep[3])
      )
    print(p)
  })
  
  # --- Choose Final tab ---
  output$dbl_choice_ui <- renderUI({
    df <- .summary_df()
    if (!nrow(df)) return(helpText(DOUBLET_UI_TEXT$t_text_run_scdblfinder_to_enable_selection))
    selectInput("dbl_final_tag", DOUBLET_UI_TEXT$t_label_choose_final_tag,
                choices = df$tag, selected = df$tag[1])
  })
  
  observeEvent(input$dbl_apply, {
    seu <- .get_seurat(); req(seu, input$dbl_final_tag)
    if (is.null(seu@misc$scDblFinder)) seu@misc$scDblFinder <- list()
    seu@misc$scDblFinder$chosen_tag <- input$dbl_final_tag
    ent <- .get_entry(); ent$obj <- seu
    shared_data$all_seurat_objects[[input$dbl_obj_name]] <- ent
    showNotification(sprintf("Doublet tag '%s' set.", input$dbl_final_tag), type = "message")
  })
  
  # ---------- tab "Next" navigation (NEW) ----------
  observeEvent(input$dbl_next_from_summary, {
    updateTabsetPanel(session, "dbl_tabs", selected = DOUBLET_UI_TEXT$t_title_umap_overlay)
  })
  observeEvent(input$dbl_next_from_umap, {
    updateTabsetPanel(session, "dbl_tabs", selected = DOUBLET_UI_TEXT$t_title_choose_final)
  })
  
  # ---------- helper: create Singlet-only object and register (NEW) ----------
  .create_doublet_filtered_entry <- function(entry_name, seu, tag) {
    # tag is like "auto" or "dbr005"
    cl_col <- paste0("DF.class_", tag)
    md <- seu@meta.data
    
    if (!cl_col %in% colnames(md)) {
      showNotification(sprintf("Column %s not found; using original object.", cl_col),
                       type = "warning", duration = 7)
      return(NULL)
    }
    
    # 1) pull the classification only for existing cells, coerce & align
    cls_vec <- as.character(md[[cl_col]])
    if (is.null(names(cls_vec))) names(cls_vec) <- rownames(md)
    # align by cell names strictly
    cls_vec <- cls_vec[colnames(seu)]
    # guard against any NA names / length drift
    if (length(cls_vec) != ncol(seu)) {
      showNotification("Classification length mismatch; using overlapping cells only.",
                       type = "warning", duration = 7)
      common <- intersect(names(cls_vec), colnames(seu))
      cls_vec <- cls_vec[common]
    }
    
    # 2) keep singlets only (case-insensitive)
    keep <- tolower(cls_vec) == "singlet"
    if (!any(keep, na.rm = TRUE)) {
      showNotification("No Singlets for chosen DBR; using original object.",
                       type = "warning", duration = 7)
      return(NULL)
    }
    kept_cells <- names(cls_vec)[keep]
    kept_cells <- kept_cells[kept_cells %in% colnames(seu)]
    
    # 3) subset safely by cell names
    sobj_filtered <- Seurat::subset(seu, cells = kept_cells)
    
    # 4) OPTIONAL: re-cache quick UMAP for the subset if present on parent
    if (all(c("UMAP1_quick","UMAP2_quick") %in% colnames(seu@meta.data))) {
      if (!all(c("UMAP1_quick","UMAP2_quick") %in% colnames(sobj_filtered@meta.data))) {
        # just carry over aligned coords if available
        xy <- seu@meta.data[kept_cells, c("UMAP1_quick","UMAP2_quick"), drop = FALSE]
        xy <- xy[colnames(sobj_filtered), , drop = FALSE]
        # only assign when dimensions match
        if (nrow(xy) == ncol(sobj_filtered)) {
          sobj_filtered@meta.data$UMAP1_quick <- xy$UMAP1_quick
          sobj_filtered@meta.data$UMAP2_quick <- xy$UMAP2_quick
        }
      }
    }
    
    # 5) record provenance in @misc; DO NOT write any long vectors into meta.data here
    if (is.null(sobj_filtered@misc)) sobj_filtered@misc <- list()
    sobj_filtered@misc$scDblFinder <- modifyList(
      seu@misc$scDblFinder %||% list(),
      list(chosen_tag = tag, source_col = cl_col, kept_n = length(kept_cells), total_n = ncol(seu))
    )
    
    sobj_filtered <- wanlab_reset_subset_analysis_state(sobj_filtered)
    out_name <- paste0(entry_name, "_dbl_", tag)
    shared_data$all_seurat_objects[[out_name]] <- list(
      obj   = sobj_filtered,
      prefs = list(),
      plots = list(),
      analysis_cache = list(),
      meta  = list(
        stage   = "doublet_filtered",
        parent  = entry_name,
        parents = entry_name,
        params  = list(chosen_tag = tag, source_col = cl_col,
                       kept_n = length(kept_cells), total_n = ncol(seu)),
        created = Sys.time()
      )
    )
    out_name
  }
}
