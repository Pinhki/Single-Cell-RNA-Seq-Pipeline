testthat::test_that("trajectory overlay records persist and project by cell id", {
  testthat::skip_if_not_installed("SeuratObject")
  root <- normalizePath(if (file.exists("Content/app.R")) "." else file.path("..", ".."), mustWork = TRUE)
  source(file.path(root, "Content", "core", "backends", "trajectory_overlay_core.R"), local = .GlobalEnv)
  counts <- matrix(1, nrow = 2, ncol = 4, dimnames = list(c("g1", "g2"), paste0("c", 1:4)))
  obj <- SeuratObject::CreateSeuratObject(counts = counts)
  vel <- trajectory_overlay_record_from_velocity(list(
    reduction = "umap",
    vectors = data.frame(cell = paste0("c", 1:4), x = 1:4, y = 4:1, vx = 0.2, vy = 0.4, speed = 0.45, group = "A", confidence = 0.8, latent_time = 1:4)
  ))
  obj <- trajectory_overlay_write(obj, vel)
  got <- trajectory_overlay_read(obj, "rna_velocity")
  testthat::expect_equal(got$reduction, "umap")
  projected <- trajectory_overlay_project(got, matrix(c(10:13, 20:17), ncol = 2, dimnames = list(paste0("c", 1:4), c("UMAP_1", "UMAP_2"))), "umap")
  testthat::expect_equal(projected$cells, paste0("c", 1:4))
  testthat::expect_equal(projected$vectors$x, 10:13)
  testthat::expect_error(trajectory_overlay_project(got, matrix(c(1:8), ncol = 2, dimnames = list(paste0("c", 1:4), c("x", "y"))), "pca"), "reduction")
})

testthat::test_that("portable plotting settings retain Dura defaults and diagnostics", {
  root <- normalizePath(if (file.exists("Content/app.R")) "." else file.path("..", ".."), mustWork = TRUE)
  source(file.path(root, "Content", "core", "backends", "trajectory_overlay_core.R"), local = .GlobalEnv)
  defaults <- trajectory_plot_settings_defaults()
  testthat::expect_equal(defaults$monocle3[c("width", "height", "dpi")], list(width = 8, height = 7, dpi = 300))
  testthat::expect_equal(defaults$velocity[c("pc_count", "model", "point_size", "arrow_alpha")], list(pc_count = 11L, model = "stochastic", point_size = 50, arrow_alpha = 0.55))
  vec <- data.frame(cell = c("c1", "c2"), x = 1:2, y = 2:1, vx = .1, vy = .2, group = c("A", "B"), latent_time = c(.2, .8))
  rec <- trajectory_overlay_record_from_velocity(list(vectors = vec, mode = "dynamical", pc_count = 11), plotting = list(model = "dynamical", display_mode = "stream"))
  testthat::expect_equal(rec$schema_version, 2L)
  testthat::expect_match(trajectory_velocity_display_diagnostic(rec, "stream"), "requires saved field data")
  rec$field_data <- list(stream = data.frame(x = 1, y = 2, xend = 2, yend = 3))
  testthat::expect_identical(trajectory_velocity_display_diagnostic(rec, "stream"), "")
})

testthat::test_that("Monocle2 graph fixture extracts and projects without a fabricated line", {
  root <- normalizePath(if (file.exists("Content/app.R")) "." else file.path("..", ".."), mustWork = TRUE)
  source(file.path(root, "Content", "core", "backends", "trajectory_overlay_core.R"), local = .GlobalEnv)
  closest <- matrix(c("n1", "n1", "n2", "n2"), ncol = 1, dimnames = list(paste0("c", 1:4), "vertex"))
  cds <- list(auxOrderingData = list(DDRTree = list(
    pr_graph_cell_proj_tree = data.frame(from = "n1", to = "n2", stringsAsFactors = FALSE),
    pr_graph_cell_proj_closest_vertex = closest
  )))
  rec <- trajectory_overlay_record_from_monocle(list(
    cds = cds,
    emb = data.frame(cell = paste0("c", 1:4), x = 1:4, y = 4:1),
    pseudotime = 1:4,
    state = c("1", "1", "2", "2"),
    group = c("A", "A", "B", "B")
  ))
  testthat::expect_equal(nrow(rec$graph$edges), 1L)
  projected <- trajectory_overlay_project(rec, matrix(c(1:4, 10:13), ncol = 2, dimnames = list(paste0("c", 1:4), c("x", "y"))))
  testthat::expect_equal(projected$graph_cell_node, setNames(c("n1", "n1", "n2", "n2"), paste0("c", 1:4)))
  testthat::expect_equal(nrow(projected$graph_edges), 1L)
  testthat::expect_equal(projected$graph_edges$from, "n1")
})
