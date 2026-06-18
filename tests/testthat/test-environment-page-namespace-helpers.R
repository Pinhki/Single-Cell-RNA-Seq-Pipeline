.load_environment_helper_env <- function() {
  page_source_path <- if (file.exists("Content/interface/setup/page_environment.R")) {
    "Content/interface/setup/page_environment.R"
  } else {
    "../../Content/interface/setup/page_environment.R"
  }

  lines <- readLines(page_source_path, warn = FALSE)
  cut <- grep("^environment_ui <-", lines)[1] - 1L
  code <- paste(lines[seq_len(cut)], collapse = "\n")
  exprs <- parse(text = code)

  helper_env <- new.env(parent = .GlobalEnv)
  for (expr in exprs) {
    eval(expr, envir = helper_env)
  }
  helper_env
}

testthat::test_that("environment helpers report Seurat and SeuratObject importers separately", {
  helper_env <- .load_environment_helper_env()

  imports_map <- list(
    Seurat = c("SeuratObject"),
    SeuratObject = character(0),
    direct_seurat_importer = c("Seurat"),
    seuratobject_importer = c("SeuratObject"),
    unrelated_pkg = c("ggplot2")
  )
  imports_resolver <- function(nm) {
    out <- imports_map[[nm]]
    if (is.null(out)) character(0) else out
  }

  blockers <- helper_env$.env_collect_namespace_locks(
    targets = c("Seurat", "SeuratObject"),
    namespaces = c(
      "base", "methods", "Seurat", "SeuratObject",
      "direct_seurat_importer", "seuratobject_importer", "unrelated_pkg"
    ),
    imports_resolver = imports_resolver
  )

  testthat::expect_identical(blockers$Seurat, "direct_seurat_importer")
  testthat::expect_identical(blockers$SeuratObject, c("Seurat", "seuratobject_importer"))
})

testthat::test_that("environment helper message distinguishes importer locks from session-held locks", {
  helper_env <- .load_environment_helper_env()

  msg <- helper_env$.env_namespace_lock_message(
    blocking = c("Seurat", "SeuratObject"),
    blockers = list(
      Seurat = character(0),
      SeuratObject = c("Seurat", "pkgB")
    )
  )

  testthat::expect_match(msg, "restart the R session")
  testthat::expect_match(msg, "SeuratObject imported by: Seurat, pkgB", fixed = TRUE)
  testthat::expect_match(msg, "Seurat has no remaining importer namespace", fixed = TRUE)
})
