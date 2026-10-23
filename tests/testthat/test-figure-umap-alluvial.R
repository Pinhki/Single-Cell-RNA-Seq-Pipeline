.figure_umap_alluvial_repo_root <- normalizePath(if (file.exists("Content/app.R")) "." else file.path("..", ".."), mustWork = TRUE)
.figure_umap_alluvial_content_dir <- file.path(.figure_umap_alluvial_repo_root, "Content")

if (!exists("figure_umap_server", mode = "function")) {
  .figure_umap_alluvial_old_wd <- getwd()
  setwd(.figure_umap_alluvial_content_dir)
  invisible(capture.output(suppressMessages(source("app.R"))))
  setwd(.figure_umap_alluvial_old_wd)
}

.figure_umap_alluvial_object <- function() {
  testthat::skip_if_not_installed("SeuratObject")
  cells <- paste0("cell", seq_len(8))
  metadata <- data.frame(
    condition = factor(c("A", "A", "B", "B", "A", "B", "A", "B")),
    tissue = factor(c("L", "L", "L", "L", "R", "R", "R", "R")),
    batch = factor(c("X", "Y", "X", "Y", "X", "Y", "X", "Y")),
    donor = factor(c("D1", "D1", "D2", "D2", "D1", "D1", "D2", "D2")),
    row.names = cells
  )
  counts <- matrix(
    rep(seq_len(4L), length.out = 4L * length(cells)),
    nrow = 4L,
    dimnames = list(c("GeneA", "GeneB", "GeneC", "GeneD"), cells)
  )
  object <- SeuratObject::CreateSeuratObject(counts = counts, meta.data = metadata)
  embeddings <- matrix(
    c(
      -2, -1, 0.5,
      -1, 1, 0.8,
      0, -1, 1.2,
      1, 1, 1.5,
      2, -0.5, 0.2,
      0.5, 0.5, -0.8,
      -0.5, 1.5, -1.1,
      1.5, -1.5, -0.4
    ),
    ncol = 3L,
    byrow = TRUE,
    dimnames = list(cells, c("UMAP_1", "UMAP_2", "UMAP_3"))
  )
  object[["umap"]] <- SeuratObject::CreateDimReducObject(
    embeddings = embeddings,
    key = "UMAP_",
    assay = SeuratObject::DefaultAssay(object)
  )
  object
}

.figure_umap_alluvial_shared_data <- function(object) {
  shiny::reactiveValues(
    all_seurat_objects = list(a = list(obj = object)),
    active_object_name = "a",
    full_sample_sheet = data.frame(sample = "a", stringsAsFactors = FALSE)
  )
}

testthat::test_that("alluvial helper aggregates 2 to 4 axes with facet-local percentages", {
  testthat::skip_if_not_installed("ggalluvial")
  object <- .figure_umap_alluvial_object()
  metadata <- object@meta.data
  prepared <- figure_umap_prepare_alluvial_data(
    metadata,
    axes = c("condition", "tissue", "batch", "donor"),
    split = "condition",
    unit = "percentage",
    node_order = "alphabetical"
  )

  testthat::expect_equal(prepared$axes, c("condition", "tissue", "batch", "donor"))
  testthat::expect_equal(nrow(prepared$lodes), nrow(prepared$flow) * 4L)
  testthat::expect_equal(as.numeric(tapply(prepared$flow$weight, prepared$flow$split, sum)), c(100, 100))
  testthat::expect_equal(prepared$node_levels$condition, c("A", "B"))
  testthat::expect_equal(prepared$node_levels$tissue, c("L", "R"))

  counts <- figure_umap_prepare_alluvial_data(metadata, c("condition", "tissue"), unit = "count", node_order = "data")
  testthat::expect_equal(sum(counts$flow$n_cells), nrow(metadata))
  testthat::expect_equal(counts$flow$weight, counts$flow$n_cells)
  testthat::expect_error(figure_umap_prepare_alluvial_data(metadata, c("condition")), "two to four")
  testthat::expect_error(figure_umap_prepare_alluvial_data(metadata, c("condition", "condition")), "distinct")
  testthat::expect_error(figure_umap_prepare_alluvial_data(metadata, c("condition", "missing")), "not available")
})

testthat::test_that("alluvial UI exposes ordered axes and styling controls", {
  html <- htmltools::renderTags(figure_umap_ui)$html
  testthat::expect_match(html, "Alluvial", fixed = TRUE)
  testthat::expect_match(html, "figure_umap_quant_axis_1", fixed = TRUE)
  testthat::expect_match(html, "figure_umap_quant_axis_4", fixed = TRUE)
  testthat::expect_match(html, "figure_umap_quant_alluvial_color_axis", fixed = TRUE)
  testthat::expect_match(html, "figure_umap_quant_alluvial_node_order", fixed = TRUE)
  testthat::expect_match(html, "figure_umap_quant_alluvial_ribbon_alpha", fixed = TRUE)
  testthat::expect_match(html, "figure_umap_quant_alluvial_ribbon_width", fixed = TRUE)
})

testthat::test_that("2D alluvial render persists state and supports paired static export composition", {
  testthat::skip_if_not_installed("ggalluvial")
  object <- .figure_umap_alluvial_object()
  shared_data <- .figure_umap_alluvial_shared_data(object)

  shiny::testServer(function(input, output, session) {
    figure_umap_server(input, output, session, shared_data = shared_data)
  }, {
    session$setInputs(
      figure_umap_view_mode = "2d",
      figure_umap_color_mode = "metadata",
      figure_umap_include_quantification = TRUE,
      figure_umap_quant_target = "same_as_color",
      figure_umap_quant_field = "condition",
      figure_umap_quant_group_by = "condition",
      figure_umap_quant_split_by = "condition",
      figure_umap_quant_chart = "alluvial",
      figure_umap_quant_unit = "percentage",
      figure_umap_quant_axis_1 = "condition",
      figure_umap_quant_axis_2 = "tissue",
      figure_umap_quant_axis_3 = "batch",
      figure_umap_quant_axis_4 = "donor",
      figure_umap_quant_alluvial_color_axis = "axis_2",
      figure_umap_quant_alluvial_node_order = "abundance",
      figure_umap_quant_alluvial_show_labels = TRUE,
      figure_umap_quant_alluvial_ribbon_alpha = 0.7,
      figure_umap_quant_alluvial_ribbon_width = 0.19,
      figure_umap_preview_renderer = "static",
      figure_umap_export_composition = "paired"
    )
    session$flushReact()
    session$setInputs(figure_umap_quant_alluvial_ribbon_width = 0.2)
    session$flushReact()

    rendered <- output$figure_umap_static_plot
    testthat::expect_true(is.list(rendered))
    state <- shared_data$all_seurat_objects[["a"]]$obj@misc$analysis$figure_studio_umap$quantification$alluvial
    testthat::expect_equal(state$axis_1, "condition")
    testthat::expect_equal(state$axis_4, "donor")
    testthat::expect_equal(state$color_axis, "axis_2")
    testthat::expect_equal(state$node_order, "abundance")
    testthat::expect_true(isTRUE(state$show_labels))
    testthat::expect_equal(state$ribbon_alpha, 0.7)
    testthat::expect_equal(state$ribbon_width, 0.2)
    diagnostics <- paste(as.character(output$figure_umap_diagnostics), collapse = "")
    testthat::expect_match(diagnostics, "text-success", fixed = TRUE)
    page_source <- paste(readLines(file.path(.figure_umap_alluvial_content_dir, "interface/figures/page_figure_umap.R"), warn = FALSE), collapse = "\n")
    testthat::expect_true(grepl("alluvial = alluvial", page_source, fixed = TRUE))
    testthat::expect_true(grepl("figure_umap_quant_alluvial_ribbon_alpha", page_source, fixed = TRUE))
  })
})

testthat::test_that("paired static alluvial comparison remains renderable", {
  testthat::skip_if_not_installed("ggalluvial")
  object <- .figure_umap_alluvial_object()
  shared_data <- shiny::reactiveValues(
    all_seurat_objects = list(a = list(obj = object), b = list(obj = object)),
    active_object_name = "a",
    full_sample_sheet = data.frame(sample = c("a", "b"), stringsAsFactors = FALSE)
  )

  shiny::testServer(function(input, output, session) {
    figure_umap_server(input, output, session, shared_data = shared_data)
  }, {
    session$setInputs(
      figure_umap_view_mode = "2d",
      figure_umap_color_mode = "metadata",
      figure_umap_include_quantification = TRUE,
      figure_umap_quant_target = "same_as_color",
      figure_umap_quant_field = "condition",
      figure_umap_quant_group_by = "condition",
      figure_umap_quant_split_by = "same_as_umap",
      figure_umap_quant_chart = "alluvial",
      figure_umap_quant_axis_1 = "condition",
      figure_umap_quant_axis_2 = "tissue",
      figure_umap_quant_axis_3 = "batch",
      figure_umap_quant_axis_4 = "__none__",
      figure_umap_quant_alluvial_color_axis = "axis_1",
      figure_umap_quant_alluvial_node_order = "data",
      figure_umap_comparison_mode = "two",
      figure_umap_comparison_object = "b",
      figure_umap_comparison_layout = "horizontal",
      figure_umap_preview_renderer = "static",
      figure_umap_export_composition = "paired"
    )
    session$flushReact()
    testthat::expect_true(is.list(output$figure_umap_static_plot))
    diagnostics <- paste(as.character(output$figure_umap_diagnostics), collapse = "")
    testthat::expect_match(diagnostics, "text-success", fixed = TRUE)
  })
})

testthat::test_that("invalid alluvial axes surface diagnostics and 3D paired mode has explicit static boundary", {
  testthat::skip_if_not_installed("ggalluvial")
  testthat::skip_if_not_installed("plotly")
  object <- .figure_umap_alluvial_object()
  shared_data <- .figure_umap_alluvial_shared_data(object)

  shiny::testServer(function(input, output, session) {
    figure_umap_server(input, output, session, shared_data = shared_data)
  }, {
    session$setInputs(
      figure_umap_view_mode = "3d",
      figure_umap_color_mode = "metadata",
      figure_umap_include_quantification = TRUE,
      figure_umap_quant_target = "same_as_color",
      figure_umap_quant_field = "condition",
      figure_umap_quant_group_by = "condition",
      figure_umap_quant_split_by = "same_as_umap",
      figure_umap_quant_chart = "alluvial",
      figure_umap_quant_unit = "count",
      figure_umap_quant_axis_1 = "condition",
      figure_umap_quant_axis_2 = "condition",
      figure_umap_quant_axis_3 = "__none__",
      figure_umap_quant_axis_4 = "__none__",
      figure_umap_quant_alluvial_color_axis = "axis_1",
      figure_umap_preview_renderer = "static",
      figure_umap_export_composition = "paired"
    )
    session$flushReact()
    diagnostics <- paste(as.character(output$figure_umap_diagnostics), collapse = "")
    testthat::expect_match(diagnostics, "distinct", fixed = TRUE)

    session$setInputs(
      figure_umap_quant_axis_2 = "tissue",
      figure_umap_preview_renderer = "interactive",
      figure_umap_focus_view = "paired"
    )
    session$flushReact()
    surface <- paste(as.character(output$figure_umap_plot_surface), collapse = "")
    testthat::expect_match(surface, "static preview and export path", fixed = TRUE)

    session$setInputs(figure_umap_preview_renderer = "static")
    session$flushReact()
    testthat::expect_true(is.list(output$figure_umap_static_plot))
    diagnostics <- paste(as.character(output$figure_umap_diagnostics), collapse = "")
    testthat::expect_match(diagnostics, "text-success", fixed = TRUE)
  })
})
