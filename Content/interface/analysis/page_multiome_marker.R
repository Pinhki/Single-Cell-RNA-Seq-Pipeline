# Multiome Marker Explorer (beta)

UI_TEXT <- list(
  t_btn_run_markers = "Run markers",
  t_label_assay = "Assay",
  t_label_feature = "Feature",
  t_label_group = "Group by",
  t_label_object = "Object",
  t_label_reduction = "Reduction",
  t_label_type_search_feature = "type to search feature...",
  t_text_explore_wnn_umap_plus_rna_atac = "Explore WNN/UMAP plus RNA/ATAC features and run quick marker scans.",
  t_title_analysis_multiome_marker_explorer_beta = "Analysis: Multiome Marker Explorer",
  t_title_embedding = "Embedding",
  t_title_feature_overlay = "Feature overlay",
  t_title_top_markers = "Top markers"
)

multiome_marker_ui <- fluidPage(
  class = "plotting-page",
  div(
    class = "page-header",
    h2(icon("search"), " ", UI_TEXT$t_title_analysis_multiome_marker_explorer_beta, " ", tags$span("beta", class = "beta-badge")),
    p(UI_TEXT$t_text_explore_wnn_umap_plus_rna_atac)
  ),
  fluidRow(
    column(
      3,
      div(
        class = "card p-3",
        selectInput("mm_object", UI_TEXT$t_label_object, choices = character(0)),
        selectInput("mm_reduction", UI_TEXT$t_label_reduction, choices = c("wnn.umap", "umap")),
        selectInput("mm_group_by", UI_TEXT$t_label_group, choices = character(0)),
        selectInput("mm_assay", UI_TEXT$t_label_assay, choices = character(0)),
        selectizeInput("mm_feature", UI_TEXT$t_label_feature, choices = NULL, multiple = FALSE, options = list(placeholder = UI_TEXT$t_label_type_search_feature)),
        actionButton("mm_run_markers", UI_TEXT$t_btn_run_markers, class = "btn btn-primary w-100")
      )
    ),
    column(
      9,
      class = "plot_area_card_style",
      div(class = "card p-3", h4(UI_TEXT$t_title_embedding), plotOutput("mm_umap_plot", height = "360px")),
      div(class = "card p-3", style = "margin-top:12px;", h4(UI_TEXT$t_title_feature_overlay), plotOutput("mm_feature_plot", height = "360px")),
      div(class = "card p-3", style = "margin-top:12px;", h4(UI_TEXT$t_title_top_markers), DTOutput("mm_marker_table"))
    )
  )
)

multiome_marker_server <- function(input, output, session, shared_data) {
  .registry_obj <- function(name) {
    reg <- shared_data$all_seurat_objects %||% list()
    entry <- reg[[name]]
    if (is.null(entry)) return(NULL)
    if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
  }

  .has_atac <- function(obj) {
    assay_names <- tryCatch(names(obj@assays), error = function(e) character(0))
    if (!length(assay_names)) return(FALSE)
    low <- tolower(assay_names)
    any(grepl("(^|_|-)atac($|_|-)|peaks?|chromatin", low, perl = TRUE))
  }

  .feature_choices <- function(obj, assay) {
    ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
    args <- list(object = obj, assay = assay)
    if ("layer" %in% ga_formals) args$layer <- "counts" else args$slot <- "counts"
    x <- tryCatch(do.call(Seurat::GetAssayData, args), warning = function(w) NULL, error = function(e) NULL)
    if (is.null(x)) {
      if ("layer" %in% ga_formals) {
        args$slot <- "counts"
        args$layer <- NULL
      } else {
        args$layer <- "counts"
        args$slot <- NULL
      }
      x <- tryCatch(do.call(Seurat::GetAssayData, args), warning = function(w) NULL, error = function(e) NULL)
    }
    if (is.null(x)) return(character(0))
    rownames(x)
  }

  marker_tbl <- reactiveVal(data.frame())

  observe({
    reg <- shared_data$all_seurat_objects %||% list()
    nm <- names(reg)
    keep <- nm[vapply(nm, function(n) {
      obj <- .registry_obj(n)
      !is.null(obj) && .has_atac(obj)
    }, logical(1))]
    updateSelectInput(session, "mm_object", choices = keep, selected = keep[[1]] %||% "")
  })

  observe({
    req(input$mm_object)
    obj <- .registry_obj(input$mm_object)
    req(!is.null(obj))

    groups <- colnames(obj@meta.data)
    groups <- groups[vapply(groups, function(g) length(unique(obj@meta.data[[g]])) > 1, logical(1))]
    keep_first <- c("seurat_clusters", "orig.ident", "sample", "batch", "condition")
    groups <- unique(c(intersect(keep_first, groups), groups))
    updateSelectInput(session, "mm_group_by", choices = groups, selected = groups[[1]] %||% "")

    assays <- names(obj@assays)
    updateSelectInput(session, "mm_assay", choices = assays, selected = if ("RNA" %in% assays) "RNA" else assays[[1]] %||% "")

    reds <- names(obj@reductions)
    red_choices <- unique(c(intersect(c("wnn.umap", "umap"), reds), reds))
    updateSelectInput(session, "mm_reduction", choices = red_choices, selected = red_choices[[1]] %||% "")
  })

  observe({
    req(input$mm_object, input$mm_assay)
    obj <- .registry_obj(input$mm_object)
    req(!is.null(obj))
    feats <- .feature_choices(obj, input$mm_assay)
    updateSelectizeInput(session, "mm_feature", choices = feats, selected = feats[[1]] %||% "", server = TRUE)
  })

  output$mm_umap_plot <- renderPlot({
    req(input$mm_object, input$mm_reduction, input$mm_group_by)
    obj <- .registry_obj(input$mm_object)
    req(!is.null(obj))
    validate(need(input$mm_reduction %in% names(obj@reductions), "Selected reduction is not available."))
    validate(need(input$mm_group_by %in% colnames(obj@meta.data), "Selected group column is not available."))
    p <- DimPlot(obj, reduction = input$mm_reduction, group.by = input$mm_group_by, label = TRUE) +
      ggplot2::theme_minimal(base_family = "Arial") +
      ggplot2::theme(legend.position = "top", legend.direction = "horizontal", legend.box = "horizontal") +
      ggplot2::guides(
        colour = ggplot2::guide_legend(override.aes = list(size = 3.2, alpha = 1)),
        color  = ggplot2::guide_legend(override.aes = list(size = 3.2, alpha = 1))
      )
    print(p)
  })

  output$mm_feature_plot <- renderPlot({
    req(input$mm_object, input$mm_reduction, input$mm_feature)
    obj <- .registry_obj(input$mm_object)
    req(!is.null(obj))
    validate(need(input$mm_reduction %in% names(obj@reductions), "Selected reduction is not available."))
    p <- FeaturePlot(obj, reduction = input$mm_reduction, features = input$mm_feature) + ggplot2::theme_minimal(base_family = "Arial")
    print(p)
  })

  observeEvent(input$mm_run_markers, {
    req(input$mm_object, input$mm_group_by, input$mm_assay)
    obj <- .registry_obj(input$mm_object)
    req(!is.null(obj))
    overlay_show("Running marker scan…")
    on.exit(overlay_hide(), add = TRUE)

    tryCatch({
      validate(need(input$mm_group_by %in% colnames(obj@meta.data), "Group-by column missing."))
      DefaultAssay(obj) <- input$mm_assay
      Idents(obj) <- obj@meta.data[[input$mm_group_by]]
      mk <- FindAllMarkers(obj, only.pos = TRUE, min.pct = 0.1, logfc.threshold = 0.25, verbose = FALSE)
      if (!nrow(mk)) {
        marker_tbl(data.frame(message = "No markers found.", stringsAsFactors = FALSE))
      } else {
        mk <- mk[order(mk$p_val_adj, -abs(mk$avg_log2FC)), , drop = FALSE]
        marker_tbl(utils::head(mk, 500))
      }
    }, error = function(e) {
      marker_tbl(data.frame(error = conditionMessage(e), stringsAsFactors = FALSE))
      showNotification(paste("Marker scan failed:", conditionMessage(e)), type = "error")
    })
  })

  output$mm_marker_table <- renderDT({
    df <- marker_tbl()
    validate(need(is.data.frame(df) && nrow(df) > 0, "Run markers to display results."))
    datatable(df, rownames = FALSE, options = list(pageLength = 10, scrollX = TRUE))
  }, server = FALSE)
}
