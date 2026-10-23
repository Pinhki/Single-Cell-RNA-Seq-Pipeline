.overlay_repo_root <- normalizePath(if (file.exists("Content/app.R")) "." else file.path("..", ".."), mustWork = TRUE)
.overlay_content_dir <- file.path(.overlay_repo_root, "Content")
if (!exists("figure_umap_server", mode = "function")) {
  .overlay_old_wd <- getwd()
  setwd(.overlay_content_dir)
  invisible(capture.output(suppressMessages(source("app.R"))))
  setwd(.overlay_old_wd)
}

.overlay_test_object <- function() {
  cells <- paste0("cell", 1:4)
  obj <- SeuratObject::CreateSeuratObject(
    counts = matrix(1, nrow = 2, ncol = 4, dimnames = list(c("g1", "g2"), cells)),
    meta.data = data.frame(condition = factor(c("A", "A", "B", "B")), row.names = cells)
  )
  obj[["umap"]] <- SeuratObject::CreateDimReducObject(
    embeddings = matrix(c(0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0), ncol = 3, byrow = TRUE, dimnames = list(cells, c("UMAP_1", "UMAP_2", "UMAP_3"))),
    key = "UMAP_",
    assay = SeuratObject::DefaultAssay(obj)
  )
  obj
}

testthat::test_that("Figure Studio renders a stored velocity overlay and split state", {
  testthat::skip_if_not_installed("plotly")
  obj <- .overlay_test_object()
  obj <- trajectory_overlay_write(obj, trajectory_overlay_record_from_velocity(list(
    reduction = "umap",
    vectors = data.frame(cell = colnames(obj), x = 0, y = 0, vx = 0.1, vy = 0.2, speed = 0.22, group = c("A", "A", "B", "B"))
  )))
  shared_data <- shiny::reactiveValues(all_seurat_objects = list(a = obj), active_object_name = "a")
  shiny::testServer(function(input, output, session) {
    figure_umap_server(input, output, session, shared_data = shared_data)
  }, {
    session$setInputs(
      figure_umap_view_mode = "2d",
      figure_umap_overlay_source = "rna_velocity",
      figure_umap_overlay_velocity_scale = 1,
      figure_umap_column_split = "condition",
      figure_umap_row_split = "__none__",
      figure_umap_preview_renderer = "static",
      figure_umap_export_composition = "umap",
      figure_umap_include_quantification = FALSE
    )
    session$flushReact()
    session$setInputs(figure_umap_overlay_source = "rna_velocity")
    session$flushReact()
    diagnostic <- as.character(output$figure_umap_overlay_diagnostic)
    testthat::expect_true(any(grepl("Available cells", diagnostic, fixed = TRUE)))
    testthat::expect_equal(shared_data$all_seurat_objects[["a"]]@misc$analysis$figure_studio_umap$overlay$source, "rna_velocity")
    rendered <- output$figure_umap_static_plot
    testthat::expect_true(is.list(rendered))
    testthat::expect_false(any(grepl("No rna_velocity overlay", as.character(output$figure_umap_diagnostics), fixed = TRUE)))
  })
})

testthat::test_that("Figure Studio projects a stored Monocle2 graph into split panels", {
  obj <- .overlay_test_object()
  record <- trajectory_overlay_record_from_monocle(list(
    cds = list(auxOrderingData = list(DDRTree = list(
      pr_graph_cell_proj_tree = data.frame(from = "n1", to = "n2", stringsAsFactors = FALSE),
      pr_graph_cell_proj_closest_vertex = matrix(c("n1", "n1", "n2", "n2"), ncol = 1, dimnames = list(colnames(obj), "vertex"))
    ))),
    emb = data.frame(cell = colnames(obj), x = 1:4, y = 4:1),
    pseudotime = 1:4,
    state = c("1", "1", "2", "2"),
    group = c("A", "A", "B", "B")
  ))
  obj <- trajectory_overlay_write(obj, record)
  shared_data <- shiny::reactiveValues(all_seurat_objects = list(a = obj), active_object_name = "a")
  shiny::testServer(function(input, output, session) {
    figure_umap_server(input, output, session, shared_data = shared_data)
  }, {
    session$setInputs(
      figure_umap_view_mode = "2d",
      figure_umap_overlay_source = "monocle2",
      figure_umap_overlay_monocle_cells = TRUE,
      figure_umap_overlay_monocle_graph = TRUE,
      figure_umap_column_split = "condition",
      figure_umap_row_split = "__none__",
      figure_umap_preview_renderer = "static",
      figure_umap_export_composition = "umap",
      figure_umap_include_quantification = FALSE
    )
    session$flushReact()
    testthat::expect_true(is.list(output$figure_umap_static_plot))
    testthat::expect_false(any(grepl("No usable principal graph", as.character(output$figure_umap_diagnostics), fixed = TRUE)))
  })
})

testthat::test_that("Figure Studio reports missing and unsupported overlay sources", {
  obj <- .overlay_test_object()
  shared_data <- shiny::reactiveValues(all_seurat_objects = list(a = obj), active_object_name = "a")
  shiny::testServer(function(input, output, session) {
    figure_umap_server(input, output, session, shared_data = shared_data)
  }, {
    session$setInputs(figure_umap_overlay_source = "monocle2", figure_umap_view_mode = "2d", figure_umap_preview_renderer = "static")
    session$flushReact()
    testthat::expect_true(any(grepl("No monocle2 overlay", as.character(output$figure_umap_overlay_diagnostic), fixed = TRUE)))
    testthat::expect_true(any(grepl("No monocle2 overlay", as.character(output$figure_umap_diagnostics), fixed = TRUE)))

    session$setInputs(figure_umap_overlay_source = "rna_velocity", figure_umap_view_mode = "3d")
    session$flushReact()
    testthat::expect_true(any(grepl("Trajectory overlays are currently supported in 2D", as.character(output$figure_umap_plot_surface), fixed = TRUE)))
  })
})

testthat::test_that("Figure Studio accepts Monocle3 overlay state and route is visible", {
  obj <- .overlay_test_object()
  record <- monocle3_beta_record_overlay(list(
    reduction = "UMAP",
    emb = data.frame(cell = colnames(obj), x = 1:4, y = 4:1),
    pseudotime = 1:4,
    state = c("1", "1", "2", "2"),
    group = c("A", "A", "B", "B"),
    graph = list(
      nodes = c("n1", "n2"),
      edges = data.frame(from = "n1", to = "n2", stringsAsFactors = FALSE),
      cell_node = stats::setNames(c("n1", "n1", "n2", "n2"), colnames(obj))
    )
  ))
  obj <- trajectory_overlay_write(obj, record)
  shared_data <- shiny::reactiveValues(all_seurat_objects = list(a = obj), active_object_name = "a")
  shiny::testServer(function(input, output, session) {
    figure_umap_server(input, output, session, shared_data = shared_data)
  }, {
    session$setInputs(figure_umap_view_mode = "2d", figure_umap_overlay_source = "monocle3", figure_umap_preview_renderer = "static", figure_umap_include_quantification = FALSE)
    session$flushReact()
    session$setInputs(figure_umap_overlay_source = "monocle3")
    session$flushReact()
    testthat::expect_true(any(grepl("Available cells", as.character(output$figure_umap_overlay_diagnostic), fixed = TRUE)))
    testthat::expect_true(is.list(output$figure_umap_static_plot))
    testthat::expect_equal(shared_data$all_seurat_objects[["a"]]@misc$analysis$figure_studio_umap$overlay$source, "monocle3")
  })
  testthat::expect_true(exists("ui", envir = .GlobalEnv))
  testthat::expect_true(any(grepl("monocle3_tab", as.character(get("ui", envir = .GlobalEnv)), fixed = TRUE)))
})
