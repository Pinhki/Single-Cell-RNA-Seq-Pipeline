# Multiome Export Check (beta)

UI_TEXT <- list(
  t_btn_run_checks = "Run checks",
  t_label_object = "Object",
  t_text_preflight_passed_object_looks_ready_multiome = "Preflight passed: object looks ready for multiome export.",
  t_text_preflight_validation_before_exporting_multiomic_objects = "Preflight validation before exporting multiomic objects to Loupe.",
  t_title_checklist = "Checklist",
  t_title_export_multiome_export_check_beta = "Export: Multiome Export Check"
)

multiome_export_check_ui <- fluidPage(
  titlePanel(tagList(icon("check"), " ", UI_TEXT$t_title_export_multiome_export_check_beta, " ", tags$span("beta", class = "beta-badge"))),
  p(UI_TEXT$t_text_preflight_validation_before_exporting_multiomic_objects),
  tags$hr(),
  fluidRow(
    column(
      4,
      div(
        class = "card p-3",
        selectInput("mx_object", UI_TEXT$t_label_object, choices = character(0)),
        actionButton("mx_refresh_btn", UI_TEXT$t_btn_run_checks, class = "btn btn-primary w-100"),
        div(style = "height:10px;"),
        htmlOutput("mx_overall")
      )
    ),
    column(
      8,
      div(
        class = "card p-3",
        h4(UI_TEXT$t_title_checklist),
        DTOutput("mx_check_table")
      )
    )
  )
)

multiome_export_check_server <- function(input, output, session, shared_data) {
  .registry_obj <- function(name) {
    reg <- shared_data$all_seurat_objects %||% list()
    entry <- reg[[name]]
    if (is.null(entry)) return(NULL)
    if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
  }

  .has_atac_assay <- function(obj) {
    assays <- tryCatch(names(obj@assays), error = function(e) character(0))
    low <- tolower(assays)
    any(grepl("(^|_|-)atac($|_|-)|peaks?|chromatin", low, perl = TRUE))
  }

  check_tbl <- reactiveVal(data.frame())

  observe({
    reg <- shared_data$all_seurat_objects %||% list()
    nm <- names(reg)
    keep <- nm[vapply(nm, function(n) {
      obj <- .registry_obj(n)
      !is.null(obj) && .has_atac_assay(obj)
    }, logical(1))]
    updateSelectInput(session, "mx_object", choices = keep, selected = keep[[1]] %||% "")
  })

  observeEvent(c(input$mx_refresh_btn, input$mx_object), {
    req(input$mx_object)
    obj <- .registry_obj(input$mx_object)
    req(!is.null(obj))

    assays <- tryCatch(names(obj@assays), error = function(e) character(0))
    reds <- tryCatch(names(obj@reductions), error = function(e) character(0))
    md_cols <- tryCatch(colnames(obj@meta.data), error = function(e) character(0))
    cells <- tryCatch(colnames(obj), error = function(e) character(0))

    row <- function(item, pass, detail) {
      data.frame(
        Check = item,
        Status = if (isTRUE(pass)) "PASS" else "FAIL",
        Detail = as.character(detail),
        stringsAsFactors = FALSE
      )
    }

    out <- rbind(
      row("RNA assay available", "RNA" %in% assays, paste(assays, collapse = ", ")),
      row("ATAC/peaks assay available", .has_atac_assay(obj), paste(assays, collapse = ", ")),
      row("Embedding available (wnn.umap or umap)", any(c("wnn.umap", "umap") %in% reds), paste(reds, collapse = ", ")),
      row("Clustering metadata available", any(grepl("clusters|wsnn", md_cols, ignore.case = TRUE)), paste(md_cols[grepl("clusters|wsnn", md_cols, ignore.case = TRUE)], collapse = ", ")),
      row("Cell barcodes are non-empty and unique", length(cells) > 0 && all(nzchar(cells)) && !any(duplicated(cells)),
          sprintf("n=%s, duplicated=%s", format(length(cells), big.mark = ","), sum(duplicated(cells))))
    )
    check_tbl(out)
  }, ignoreInit = FALSE)

  output$mx_overall <- renderUI({
    df <- check_tbl()
    validate(need(is.data.frame(df) && nrow(df) > 0, "No checks run yet."))
    fail_n <- sum(df$Status != "PASS")
    if (fail_n == 0) {
      div(class = "alert alert-success", UI_TEXT$t_text_preflight_passed_object_looks_ready_multiome)
    } else {
      div(class = "alert alert-warning", sprintf("Preflight found %d issue(s). Please resolve before export.", fail_n))
    }
  })

  output$mx_check_table <- renderDT({
    df <- check_tbl()
    validate(need(is.data.frame(df) && nrow(df) > 0, "No checks run yet."))
    datatable(df, rownames = FALSE, options = list(dom = "t", paging = FALSE, scrollX = TRUE))
  }, server = FALSE)
}
