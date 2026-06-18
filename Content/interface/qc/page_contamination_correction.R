CONTAM_UI_TEXT <- list(
  title = "QC: Contamination Correction",
  subtitle = "Hidden alpha page for ambient RNA assessment and correction before integration.",
  object = "Object",
  method = "Method",
  run = "Run contamination correction",
  genes = "Genes of interest (comma/newline separated)",
  add_active = "Set corrected object as active",
  status_idle = "Ready. Select object and method, then run.",
  report = "Report summary",
  outputs = "Output artifacts",
  logs = "Logs",
  params = "Method parameters"
)

`%||%` <- function(a, b) if (is.null(a)) b else a

contamination_correction_ui <- fluidPage(
  class = "plotting-page",
  div(
    class = "page-header",
    h2(icon("shield-virus"), " ", wl_alpha_label("Contamination Correction", suffix = "hidden")),
    p(CONTAM_UI_TEXT$subtitle)
  ),
  fluidRow(
    column(
      3,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        selectInput("contam_object", CONTAM_UI_TEXT$object, choices = character(0)),
        tags$small(class = "text-muted", "Workspace object to correct. The original object will not be overwritten."),
        selectInput(
          "contam_method",
          CONTAM_UI_TEXT$method,
          choices = c("none", "SoupX", "DecontX", "CellBender"),
          selected = "DecontX"
        ),
        tags$small(class = "text-muted", "Correction method. SoupX needs raw+filtered droplets, DecontX works with filtered counts, CellBender needs raw 10x .h5."),
        textAreaInput("contam_genes", CONTAM_UI_TEXT$genes, value = "", rows = 5),
        tags$small(class = "text-muted", "Genes used for before/after evidence plots and summary tables. Leave empty to auto-select candidates."),
        checkboxInput("contam_set_active", CONTAM_UI_TEXT$add_active, value = TRUE),
        tags$small(class = "text-muted", "If checked, the new corrected object becomes the active workspace object after run."),
        checkboxInput("contam_cellbender_execute", "Execute CellBender command", value = FALSE),
        tags$small(class = "text-muted", "If unchecked, CellBender runs in import mode and expects output.h5 already present in the run folder."),
        checkboxInput("contam_cellbender_cpu_fallback", "Allow CPU fallback (CellBender)", value = TRUE),
        tags$small(class = "text-muted", "When GPU is not available, allow slower CPU execution instead of stopping."),
        numericInput("contam_cellbender_expected_cells", "CellBender expected_cells", value = 3000, min = 100),
        tags$small(class = "text-muted", "Approximate number of real cells expected in this sample. Used by CellBender model fitting."),
        numericInput("contam_cellbender_droplets", "CellBender total_droplets_included", value = 20000, min = 1000),
        tags$small(class = "text-muted", "How many total droplets to model (cells + empty/background droplets). Higher values increase runtime/memory."),
        numericInput("contam_cellbender_epochs", "CellBender epochs", value = 150, min = 10),
        tags$small(class = "text-muted", "Training iterations for CellBender. Higher epochs can improve convergence but increase runtime."),
        sliderInput("contam_cellbender_fpr", "CellBender FPR", min = 0.001, max = 0.2, value = 0.01, step = 0.001),
        tags$small(class = "text-muted", "Target false-positive rate for retaining counts as true signal. Lower = stricter background removal."),
        actionButton("contam_run_btn", CONTAM_UI_TEXT$run, class = "btn btn-primary btn-block", icon = icon("play"))
      )
    ),
    column(
      9,
      class = "plot_area_card_style",
      tabsetPanel(
        id = "contam_tabs",
        tabPanel(CONTAM_UI_TEXT$status_idle, verbatimTextOutput("contam_status")),
        tabPanel(CONTAM_UI_TEXT$report, tableOutput("contam_report_table")),
        tabPanel(CONTAM_UI_TEXT$outputs, verbatimTextOutput("contam_outputs")),
        tabPanel(CONTAM_UI_TEXT$logs, verbatimTextOutput("contam_logs"))
      )
    )
  )
)

contamination_correction_server <- function(input, output, session, shared_data) {
  rv <- reactiveValues(
    status = CONTAM_UI_TEXT$status_idle,
    report_tbl = data.frame(),
    outputs = "",
    logs = ""
  )

  .entry_obj <- function(entry) {
    if (is.list(entry) && !is.null(entry$obj)) return(entry$obj)
    entry
  }

  .split_genes <- function(x) {
    vals <- unlist(strsplit(as.character(x %||% ""), "[,\n\r\t; ]+", perl = TRUE))
    vals <- trimws(vals)
    unique(vals[nzchar(vals)])
  }

  .find_sample_row <- function(obj_name, obj) {
    ss <- shared_data$full_sample_sheet
    if (!is.data.frame(ss) || !nrow(ss)) return(NULL)

    idx <- which(as.character(ss$name) == as.character(obj_name))
    if (length(idx)) return(ss[idx[[1]], , drop = FALSE])

    md <- tryCatch(obj@meta.data, error = function(e) NULL)
    if (!is.null(md) && is.data.frame(md) && nrow(md)) {
      candidate <- as.character(md$orig.ident[[1]] %||% "")
      if (nzchar(candidate)) {
        idx2 <- which(as.character(ss$name) == candidate)
        if (length(idx2)) return(ss[idx2[[1]], , drop = FALSE])
      }
    }

    NULL
  }

  .make_unique_name <- function(base, reg_names) {
    if (!(base %in% reg_names)) return(base)
    i <- 1L
    cand <- paste0(base, "_", i)
    while (cand %in% reg_names) {
      i <- i + 1L
      cand <- paste0(base, "_", i)
    }
    cand
  }

  .append_cross_sample_summary <- function(out_root, run_id, sample_name, method, summary_tbl) {
    if (!is.data.frame(summary_tbl) || !nrow(summary_tbl)) return(invisible(NULL))
    amb_root <- file.path(out_root, "ambient_correction")
    dir.create(amb_root, recursive = TRUE, showWarnings = FALSE)
    fp <- file.path(amb_root, "cross_sample_summary.csv")

    add <- summary_tbl
    add$sample_name <- sample_name
    add$method <- method
    add$run_id <- run_id
    add$recorded_at <- as.character(Sys.time())

    prev <- if (file.exists(fp)) tryCatch(read.csv(fp, stringsAsFactors = FALSE), error = function(e) data.frame()) else data.frame()
    all_cols <- union(names(prev), names(add))
    for (nm in setdiff(all_cols, names(prev))) prev[[nm]] <- NA
    for (nm in setdiff(all_cols, names(add))) add[[nm]] <- NA
    out <- rbind(prev[, all_cols, drop = FALSE], add[, all_cols, drop = FALSE])
    write.csv(out, fp, row.names = FALSE)
    invisible(fp)
  }

  observe({
    reg <- shared_data$all_seurat_objects %||% list()
    nms <- names(reg)
    updateSelectInput(session, "contam_object", choices = nms, selected = if (length(nms)) nms[[1]] else "")
  })

  observeEvent(input$contam_run_btn, {
    overlay_show("Running contamination correction...")
    on.exit(overlay_hide(), add = TRUE)

    obj_name <- as.character(input$contam_object %||% "")
    method <- as.character(input$contam_method %||% "none")

    reg <- shared_data$all_seurat_objects %||% list()
    if (!nzchar(obj_name) || is.null(reg[[obj_name]])) {
      showNotification("Select a valid object first.", type = "error")
      return(invisible(NULL))
    }

    sobj <- .entry_obj(reg[[obj_name]])
    if (!inherits(sobj, "Seurat")) {
      showNotification("Selected entry is not a Seurat object.", type = "error")
      return(invisible(NULL))
    }

    sample_row <- .find_sample_row(obj_name, sobj)
    if (is.null(sample_row)) {
      showNotification("Could not map this object to a sample-sheet row/path.", type = "error")
      return(invisible(NULL))
    }

    detect <- tryCatch(
      core_contam_detect_inputs(sample_row = sample_row, seurat_obj = sobj),
      error = function(e) {
        showNotification(paste("Input detection error:", conditionMessage(e)), type = "error", duration = NULL)
        NULL
      }
    )
    if (is.null(detect)) return(invisible(NULL))

    if (!(method %in% detect$feasible_methods)) {
      showNotification(
        paste0("Method '", method, "' is not feasible for this sample. Feasible: ", paste(detect$feasible_methods, collapse = ", ")),
        type = "error",
        duration = NULL
      )
      return(invisible(NULL))
    }

    genes <- .split_genes(input$contam_genes)
    run_id <- paste0(format(Sys.time(), "%Y%m%d_%H%M%S"), "_", tolower(method), "_", gsub("[^A-Za-z0-9._-]", "_", as.character(detect$sample_name)))

    cfg <- list(
      assay = "RNA",
      use_auto_est = TRUE,
      execute = isTRUE(input$contam_cellbender_execute),
      allow_cpu_fallback = isTRUE(input$contam_cellbender_cpu_fallback),
      expected_cells = as.integer(input$contam_cellbender_expected_cells %||% 3000L),
      total_droplets_included = as.integer(input$contam_cellbender_droplets %||% 20000L),
      epochs = as.integer(input$contam_cellbender_epochs %||% 150L),
      fpr = as.numeric(input$contam_cellbender_fpr %||% 0.01),
      output_dir = file.path(tempdir(), "cellbender", run_id)
    )

    run_res <- tryCatch(
      core_contam_run_sample(method = method, seurat_obj = sobj, sample_context = detect, config = cfg),
      error = function(e) {
        showNotification(paste("Correction failed:", conditionMessage(e)), type = "error", duration = NULL)
        NULL
      }
    )
    if (is.null(run_res)) return(invisible(NULL))

    eval_res <- tryCatch(
      core_contam_generate_evaluation(
        before_obj = sobj,
        after_obj = run_res$object,
        genes = genes,
        config = list(before_assay = "RNA", after_assay = run_res$corrected_assay)
      ),
      error = function(e) {
        showNotification(paste("Evaluation warning:", conditionMessage(e)), type = "warning", duration = 8)
        list(summary = data.frame(), top_changed = data.frame(), plots = list())
      }
    )
    run_res$evaluation <- eval_res

    project_root <- tryCatch(.core_contam_project_root(detect$files$sample_input_path), error = function(e) getwd())
    output_root <- file.path(project_root, "ambient_correction")
    wr <- tryCatch(
      core_contam_write_outputs(result = run_res, output_root = output_root, run_id = run_id, overwrite = FALSE),
      error = function(e) {
        showNotification(paste("Output write error:", conditionMessage(e)), type = "error", duration = NULL)
        NULL
      }
    )
    if (is.null(wr)) return(invisible(NULL))

    .append_cross_sample_summary(project_root, run_id, detect$sample_name, method, eval_res$summary %||% data.frame())

    new_name_base <- paste0(obj_name, "_contam_", tolower(method))
    new_name <- .make_unique_name(new_name_base, names(reg))

    reg[[new_name]] <- list(
      obj = run_res$object,
      plots = reg[[obj_name]]$plots %||% list(),
      meta = list(
        stage = "contamination_corrected",
        parent = obj_name,
        parents = c(obj_name),
        created = Sys.time(),
        contamination = list(
          method = method,
          run_id = run_id,
          output_dir = wr$output_dir,
          corrected_assay = run_res$corrected_assay
        )
      )
    )
    shared_data$all_seurat_objects <- reg
    if (isTRUE(input$contam_set_active)) shared_data$active_object_name <- new_name

    rv$status <- paste0(
      "Completed: ", method,
      "\nInput object: ", obj_name,
      "\nCorrected object: ", new_name,
      "\nRun ID: ", run_id,
      "\nOutput: ", wr$output_dir
    )
    rv$report_tbl <- head(eval_res$top_changed %||% data.frame(), 40)
    rv$outputs <- paste(
      "corrected_object.rds",
      "config.json",
      "run.log",
      "summary_report.md",
      "summary_metrics.csv",
      sep = "\n"
    )
    rv$logs <- as.character(run_res$run_log %||% "")

    showNotification("Contamination correction complete; corrected object added to workspace.", type = "message")
  }, ignoreInit = TRUE)

  output$contam_status <- renderText({ rv$status })
  output$contam_report_table <- renderTable({ rv$report_tbl })
  output$contam_outputs <- renderText({ rv$outputs })
  output$contam_logs <- renderText({ rv$logs })
}
