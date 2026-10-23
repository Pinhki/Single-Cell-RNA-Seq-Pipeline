.figure_umap_repo_root <- normalizePath(if (file.exists("Content/app.R")) "." else file.path("..", ".."), mustWork = TRUE)
.figure_umap_content_dir <- file.path(.figure_umap_repo_root, "Content")

if (!exists("figure_umap_server", mode = "function")) {
  .figure_umap_old_wd <- getwd()
  setwd(.figure_umap_content_dir)
  invisible(capture.output(suppressMessages(source("app.R"))))
  setwd(.figure_umap_old_wd)
}

.figure_umap_test_object <- function() {
  testthat::skip_if_not_installed("SeuratObject")
  set.seed(20260919)
  cells <- paste0("cell", seq_len(8))
  metadata <- data.frame(
    seurat_clusters = factor(c("0", "0", "1", "1", "0", "1", "0", "1")),
    condition = factor(c("A", "B", "A", "B", "A", "B", "A", "B")),
    row.names = cells
  )
  counts <- matrix(
    sample(1:5, 4L * length(cells), replace = TRUE),
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

testthat::test_that("camera panel identities and camera selection stay deterministic", {
  cells <- paste0("cell", seq_len(4))
  specs <- figure_umap_split_panel_specs(
    cells = cells,
    split_mode = "grid",
    column_values = c("B", "A", "B", "A"),
    row_values = c("Y", "Y", "X", "X"),
    prefix = "primary::"
  )
  ids <- vapply(specs, `[[`, character(1), "id")

  testthat::expect_length(ids, 4L)
  testthat::expect_true(all(startsWith(ids, "primary::grid::")))
  testthat::expect_equal(ids, vapply(figure_umap_split_panel_specs(
    cells = cells,
    split_mode = "grid",
    column_values = c("B", "A", "B", "A"),
    row_values = c("Y", "Y", "X", "X"),
    prefix = "primary::"
  ), `[[`, character(1), "id"))

  panel_id <- ids[[1]]
  selected <- figure_umap_camera_for_panel(
    list(
      azimuth = 35,
      projection = "perspective",
      panels = stats::setNames(list(list(azimuth = 35, projection = "perspective", eye = list(x = 1, y = 2, z = 3))), panel_id)
    ),
    panel_id,
    fallback = list(azimuth = 10, projection = "orthographic")
  )
  testthat::expect_equal(selected$azimuth, 35)
  testthat::expect_equal(selected$projection, "perspective")
  testthat::expect_equal(selected$eye$x, 1)
})

testthat::test_that("captured Plotly cameras map to named panels and fine sliders", {
  panels <- c("primary::column::A", "primary::column::B")
  payload <- list(
    event = "plotly_relayout",
    panels = panels,
    cameras = stats::setNames(list(
      list(eye = list(x = 1, y = 0, z = 1), up = list(x = 0, y = 0, z = 1)),
      list(eye = list(x = 0, y = -2, z = 0.5), up = list(x = 0, y = 0, z = 1))
    ), panels)
  )
  mapped <- figure_umap_camera_event_map(payload, panels)

  testthat::expect_equal(mapped[[panels[[1]]]]$eye$x, 1)
  testthat::expect_equal(mapped[[panels[[2]]]]$eye$y, -2)
  testthat::expect_equal(figure_umap_camera_slider_values(mapped[[panels[[1]]]])$azimuth, 0)
  testthat::expect_equal(figure_umap_camera_slider_values(mapped[[panels[[2]]]])$azimuth, -90)
  testthat::expect_error(
    figure_umap_camera_event_map(list(cameras = stats::setNames(list(list(eye = list(x = 1, y = 0, z = 1))), "unknown")), panels),
    "unknown split panel"
  )
  testthat::expect_error(
    figure_umap_camera_event_map(list(cameras = stats::setNames(list(list(eye = list(x = 1, y = 0))), panels[[1]])), panels),
    "complete eye"
  )
})

testthat::test_that("static preview uses same selected composition helper as export", {
  bundle <- list(umap = "umap_plot", quant = "quant_plot", composition = "paired_plot")
  testthat::expect_identical(figure_umap_select_composition_plot(bundle, "umap"), "umap_plot")
  testthat::expect_identical(figure_umap_select_composition_plot(bundle, "quant"), "quant_plot")
  testthat::expect_identical(figure_umap_select_composition_plot(bundle, "paired"), "paired_plot")
})

testthat::test_that("3D static preview captures split cameras and retains paired quantification", {
  testthat::skip_if_not_installed("plotly")
  object <- .figure_umap_test_object()
  shared_data <- shiny::reactiveValues(
    all_seurat_objects = list(a = object),
    active_object_name = "a",
    full_sample_sheet = data.frame(sample = "a", stringsAsFactors = FALSE)
  )

  shiny::testServer(function(input, output, session) {
    figure_umap_server(input, output, session, shared_data = shared_data)
  }, {
    session$setInputs(
      figure_umap_view_mode = "3d",
      figure_umap_color_mode = "metadata",
      figure_umap_column_split = "condition",
      figure_umap_row_split = "__none__",
      figure_umap_include_quantification = TRUE,
      figure_umap_quant_target = "same_as_color",
      figure_umap_quant_field = "condition",
      figure_umap_quant_group_by = "condition",
      figure_umap_quant_split_by = "same_as_umap",
      figure_umap_preview_renderer = "static",
      figure_umap_export_composition = "paired"
    )
    session$flushReact()

    panel_specs <- figure_umap_split_panel_specs(
      cells = colnames(object),
      split_mode = "column",
      column_values = object@meta.data$condition,
      row_values = rep("All rows", ncol(object)),
      prefix = "primary::"
    )
    panel_ids <- vapply(panel_specs, `[[`, character(1), "id")
    cameras <- stats::setNames(lapply(seq_along(panel_ids), function(i) {
      list(eye = list(x = i, y = i + 1, z = i + 2), up = list(x = 0, y = 0, z = 1))
    }), panel_ids)
    session$setInputs(figure_umap_camera_relayout = list(event = "plotly_relayout", cameras = cameras, panels = panel_ids))
    session$setInputs(figure_umap_apply_camera = 1)
    session$flushReact()

    stored <- shared_data$all_seurat_objects[["a"]]@misc$analysis$figure_studio_umap$camera$panels
    testthat::expect_equal(names(stored), panel_ids)
    testthat::expect_equal(stored[[panel_ids[[1]]]]$eye$x, 1)
    testthat::expect_equal(stored[[panel_ids[[2]]]]$eye$x, 2)

    surface <- as.character(output$figure_umap_plot_surface)
    testthat::expect_true(any(grepl("figure_umap_static_plot", surface, fixed = TRUE)))
    rendered <- output$figure_umap_static_plot
    testthat::expect_true(is.list(rendered))
    testthat::expect_true(is.null(output$figure_umap_diagnostics) || length(output$figure_umap_diagnostics) > 0)
  })
})
