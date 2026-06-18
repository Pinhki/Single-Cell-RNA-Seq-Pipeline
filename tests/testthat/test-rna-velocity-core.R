.velocity_core_source_path <- if (file.exists("Content/core/backends/rna_velocity_core.R")) {
  "Content/core/backends/rna_velocity_core.R"
} else {
  "../../Content/core/backends/rna_velocity_core.R"
}
source(.velocity_core_source_path)

testthat::test_that("rna_velocity_beta_match_cells prefers exact matches and supports normalized fallback", {
  seurat_cells <- c("AAACCTGAGAAACCAT-1", "AAACCTGAGAAACCCA-1", "TTGGCCAATTCCGGAA-1")
  loom_cells <- c("sampleA:AAACCTGAGAAACCAT-1", "AAACCTGAGAAACCCA-1", "TTGGCCAATTCCGGAA")

  m <- rna_velocity_beta_match_cells(seurat_cells = seurat_cells, loom_cells = loom_cells)

  testthat::expect_equal(nrow(m), 3L)
  testthat::expect_equal(m$seurat_cell[[1]], "AAACCTGAGAAACCAT-1")
  testthat::expect_equal(m$loom_cell[[1]], "sampleA:AAACCTGAGAAACCAT-1")
  testthat::expect_equal(m$seurat_cell[[2]], "AAACCTGAGAAACCCA-1")
  testthat::expect_equal(m$loom_cell[[2]], "AAACCTGAGAAACCCA-1")
  testthat::expect_equal(m$seurat_cell[[3]], "TTGGCCAATTCCGGAA-1")
  testthat::expect_equal(m$loom_cell[[3]], "TTGGCCAATTCCGGAA")
})

testthat::test_that("rna_velocity_beta_python_status reports missing reticulate cleanly", {
  st <- rna_velocity_beta_python_status(reticulate_installed = FALSE)

  testthat::expect_false(isTRUE(st$ok))
  testthat::expect_true(grepl("reticulate", st$summary, ignore.case = TRUE))
})

testthat::test_that("rna_velocity_beta_python_status aggregates module readiness", {
  checker <- function(modules, python_path = "") {
    out <- rep(TRUE, length(modules))
    names(out) <- modules
    out[["scvelo"]] <- FALSE
    out
  }

  st <- rna_velocity_beta_python_status(
    reticulate_installed = TRUE,
    module_checker = checker,
    require_modules = c("scanpy", "scvelo", "anndata")
  )

  testthat::expect_false(isTRUE(st$ok))
  testthat::expect_identical(st$modules[["scanpy"]], TRUE)
  testthat::expect_identical(st$modules[["scvelo"]], FALSE)
  testthat::expect_true(grepl("scvelo", st$summary, ignore.case = TRUE))
})
