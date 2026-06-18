# WNN / Multiome Integration (beta)

UI_TEXT <- list(
  t_btn_run_wnn = "Run WNN",
  t_label_atac_dims_lsi = "ATAC dims (LSI)",
  t_label_clustering_resolution = "Clustering resolution",
  t_label_object = "Object",
  t_label_random_seed = "Random seed",
  t_label_rna_dims = "RNA dims",
  t_label_umap_min_distance = "UMAP min distance",
  t_label_umap_neighbors = "UMAP neighbors",
  t_text_build_weighted_nearest_neighbor_graph_rna = "Build weighted nearest-neighbor graph (RNA + ATAC), then run WNN UMAP/clustering.",
  t_title_analysis_wnn_multiome_integration_beta = "Analysis: WNN / Multiome Integration",
  t_title_wnn_umap = "WNN UMAP"
)

multiome_wnn_ui <- fluidPage(
  class = "plotting-page",
  div(
    class = "page-header",
    h2(icon("cogs"), " ", UI_TEXT$t_title_analysis_wnn_multiome_integration_beta, " ", tags$span("beta", class = "beta-badge")),
    p(UI_TEXT$t_text_build_weighted_nearest_neighbor_graph_rna)
  ),
  fluidRow(
    column(
      4,
      div(
        class = "card p-3",
        selectInput("wnn_object", UI_TEXT$t_label_object, choices = character(0)),
        numericInput("wnn_rna_dims", UI_TEXT$t_label_rna_dims, value = 30, min = 5, max = 100, step = 1),
        numericInput("wnn_atac_dims", UI_TEXT$t_label_atac_dims_lsi, value = 30, min = 5, max = 100, step = 1),
        sliderInput("wnn_neighbors", UI_TEXT$t_label_umap_neighbors, min = 5, max = 100, value = 30, step = 1),
        sliderInput("wnn_min_dist", UI_TEXT$t_label_umap_min_distance, min = 0.01, max = 0.99, value = 0.3, step = 0.01),
        sliderInput("wnn_resolution", UI_TEXT$t_label_clustering_resolution, min = 0.1, max = 2, value = 0.8, step = 0.1),
        numericInput("wnn_seed", UI_TEXT$t_label_random_seed, value = 42, min = 1, step = 1),
        actionButton("wnn_run_btn", UI_TEXT$t_btn_run_wnn, class = "btn btn-primary w-100"),
        div(style = "height:8px;"),
        htmlOutput("wnn_status")
      )
    ),
    column(
      8,
      class = "plot_area_card_style",
      div(
        class = "card p-3",
        h4(UI_TEXT$t_title_wnn_umap),
        plotOutput("wnn_plot", height = "620px")
      )
    )
  )
)

multiome_wnn_server <- function(input, output, session, shared_data) {

  .registry_obj <- function(name) {
    reg <- shared_data$all_seurat_objects %||% list()
    entry <- reg[[name]]
    if (is.null(entry)) return(NULL)
    if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
  }

  .registry_put <- function(name, obj, stage = "analysis") {
    reg <- shared_data$all_seurat_objects %||% list()
    old <- reg[[name]]
    meta <- if (is.list(old) && !is.null(old$meta)) old$meta else list()
    meta$stage <- stage
    meta$created <- Sys.time()
    reg[[name]] <- list(obj = obj, prefs = list(), plots = list(), analysis_cache = list(), meta = meta)
    shared_data$all_seurat_objects <- reg
  }

  .has_atac <- function(obj) {
    assay_names <- tryCatch(names(obj@assays), error = function(e) character(0))
    if (!length(assay_names)) return(FALSE)
    low <- tolower(assay_names)
    any(grepl("(^|_|-)atac($|_|-)|peaks?|chromatin", low, perl = TRUE))
  }

  .pick_atac_assay <- function(obj) {
    assay_names <- tryCatch(names(obj@assays), error = function(e) character(0))
    if (!length(assay_names)) return(NULL)
    low <- tolower(assay_names)
    idx <- which(grepl("(^|_|-)atac($|_|-)|peaks?|chromatin", low, perl = TRUE))
    if (!length(idx)) return(NULL)
    assay_names[[idx[[1]]]]
  }

  wnn_result_name <- reactiveVal(NULL)
  wnn_status_msg <- reactiveVal("Ready.")

  observe({
    reg <- shared_data$all_seurat_objects %||% list()
    nm <- names(reg)
    keep <- nm[vapply(nm, function(n) {
      obj <- .registry_obj(n)
      !is.null(obj) && .has_atac(obj)
    }, logical(1))]
    updateSelectInput(session, "wnn_object", choices = keep, selected = keep[[1]] %||% "")
  })

  output$wnn_status <- renderUI({
    div(class = "small text-muted", wnn_status_msg())
  })

  observeEvent(input$wnn_run_btn, {
    req(input$wnn_object)
    req(!is.null(shared_data$active_environment$name) && grepl("seurat5", tolower(shared_data$active_environment$name), fixed = TRUE))
    obj <- .registry_obj(input$wnn_object)
    req(!is.null(obj))

    overlay_show("Running WNN integration…")
    on.exit(overlay_hide(), add = TRUE)

    tryCatch({
      DefaultAssay(obj) <- "RNA"
      if (!"pca" %in% names(obj@reductions)) {
        obj <- NormalizeData(obj, verbose = FALSE)
        obj <- FindVariableFeatures(obj, verbose = FALSE)
        obj <- ScaleData(obj, verbose = FALSE)
        obj <- RunPCA(obj, npcs = max(50, input$wnn_rna_dims), verbose = FALSE)
      }

      atac_assay <- .pick_atac_assay(obj)
      validate(need(!is.null(atac_assay), "No ATAC/peaks assay found for WNN."))
      DefaultAssay(obj) <- atac_assay

      if (!"lsi" %in% names(obj@reductions)) {
        if (!requireNamespace("Signac", quietly = TRUE)) {
          stop("Reduction 'lsi' is missing and Signac is not installed. Please provide an object with precomputed LSI.")
        }
        obj <- Signac::RunTFIDF(obj)
        obj <- Signac::FindTopFeatures(obj, min.cutoff = "q0")
        obj <- Signac::RunSVD(obj, reduction.name = "lsi", reduction.key = "LSI_")
      }

      DefaultAssay(obj) <- "RNA"
      obj <- FindMultiModalNeighbors(
        object = obj,
        reduction.list = list("pca", "lsi"),
        dims.list = list(1:input$wnn_rna_dims, 1:input$wnn_atac_dims),
        modality.weight.name = "RNA.weight"
      )
      obj <- RunUMAP(
        object = obj,
        nn.name = "weighted.nn",
        reduction.name = "wnn.umap",
        reduction.key = "wnnUMAP_",
        n.neighbors = input$wnn_neighbors,
        min.dist = input$wnn_min_dist,
        seed.use = input$wnn_seed
      )
      obj <- FindClusters(obj, graph.name = "wsnn", resolution = input$wnn_resolution, verbose = FALSE)

      new_name <- paste0(input$wnn_object, "_wnn")
      .registry_put(new_name, obj, stage = "analysis")
      shared_data$active_object_name <- new_name
      wnn_result_name(new_name)
      wnn_status_msg(sprintf("WNN finished. Saved object: %s", new_name))
      showNotification(sprintf("WNN done: %s", new_name), type = "message")
    }, error = function(e) {
      wnn_status_msg(conditionMessage(e))
      showNotification(paste("WNN failed:", conditionMessage(e)), type = "error")
    })
  })

  output$wnn_plot <- renderPlot({
    nm <- wnn_result_name() %||% input$wnn_object
    req(nzchar(nm))
    obj <- .registry_obj(nm)
    req(!is.null(obj))
    validate(need("wnn.umap" %in% names(obj@reductions), "Run WNN first to compute wnn.umap."))
    grp <- if ("seurat_clusters" %in% colnames(obj@meta.data)) "seurat_clusters" else "orig.ident"
    p <- DimPlot(obj, reduction = "wnn.umap", group.by = grp, label = TRUE) +
      ggplot2::theme_minimal(base_family = "Arial") +
      ggplot2::theme(legend.position = "top", legend.direction = "horizontal", legend.box = "horizontal") +
      ggplot2::guides(
        colour = ggplot2::guide_legend(override.aes = list(size = 3.2, alpha = 1)),
        color  = ggplot2::guide_legend(override.aes = list(size = 3.2, alpha = 1))
      )
    print(p)
  })
}
