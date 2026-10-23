testthat::test_that("Monocle3 adapter records compact trajectory output", {
  root <- normalizePath(if (file.exists("Content/app.R")) "." else file.path("..", ".."), mustWork = TRUE)
  source(file.path(root, "Content", "core", "backends", "trajectory_overlay_core.R"), local = .GlobalEnv)
  source(file.path(root, "Content", "core", "backends", "monocle3_core.R"), local = .GlobalEnv)
  cells <- paste0("c", 1:4)
  result <- list(
    reduction = "UMAP",
    emb = data.frame(cell = cells, x = 1:4, y = 4:1),
    pseudotime = c(0, 1, 2, 3),
    state = c("1", "1", "2", "2"),
    group = c("A", "A", "B", "B"),
    graph = list(
      nodes = c("n1", "n2"),
      edges = data.frame(from = "n1", to = "n2", stringsAsFactors = FALSE),
      cell_node = stats::setNames(c("n1", "n1", "n2", "n2"), cells)
    )
  )
  record <- monocle3_beta_record_overlay(result)
  testthat::expect_equal(record$source, "monocle3")
  testthat::expect_equal(record$cells, cells)
  testthat::expect_equal(record$reduction, "umap")
  testthat::expect_equal(nrow(record$graph$edges), 1L)
  testthat::expect_error(trajectory_overlay_validate_record(utils::modifyList(record, list(cells = c("c1", "c1")))), "unique")
})

testthat::test_that("Monocle3 runtime guard is explicit when package is absent", {
  root <- normalizePath(if (file.exists("Content/app.R")) "." else file.path("..", ".."), mustWork = TRUE)
  source(file.path(root, "Content", "core", "backends", "monocle3_core.R"), local = .GlobalEnv)
  guard <- monocle3_beta_runtime_guard()
  testthat::expect_true(is.logical(guard$ok) && length(guard$ok) == 1L)
  testthat::expect_true(nzchar(as.character(guard$summary)))
  if (!requireNamespace("monocle3", quietly = TRUE)) testthat::expect_false(guard$ok)
})

testthat::test_that("Monocle3 page stays navigable when package is absent", {
  testthat::skip_if(requireNamespace("monocle3", quietly = TRUE), "Monocle3 is installed; unavailable-runtime branch is not applicable.")
  root <- normalizePath(if (file.exists("Content/app.R")) "." else file.path("..", ".."), mustWork = TRUE)
  if (!exists("monocle3_server", mode = "function")) {
    old_wd <- getwd()
    setwd(file.path(root, "Content"))
    invisible(capture.output(suppressMessages(source("app.R"))))
    setwd(old_wd)
  }
  shared_data <- shiny::reactiveValues(all_seurat_objects = list(), active_object_name = "")
  shiny::testServer(function(input, output, session) {
    monocle3_server(input, output, session, shared_data = shared_data)
  }, {
    session$flushReact()
    testthat::expect_true(any(grepl("not available", as.character(output$monocle3_runtime_ui), fixed = TRUE)))
  })
})
