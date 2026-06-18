.load_run_advanced_bootstrap_helper_env <- function() {
  run_source_path <- if (file.exists("Content/run.R")) {
    "Content/run.R"
  } else {
    "../../Content/run.R"
  }

  lines <- readLines(run_source_path, warn = FALSE)
  start <- grep("^\\.seurat_bootstrap_lib_paths <- function", lines)[1]
  end <- grep("^# 4\\) Package Plan", lines)[1] - 1L
  code <- paste(lines[start:end], collapse = "\n")
  exprs <- parse(text = code)

  helper_env <- new.env(parent = .GlobalEnv)
  for (expr in exprs) {
    eval(expr, envir = helper_env)
  }
  helper_env
}

testthat::test_that("advanced bootstrap lib paths prioritize isolated Seurat envs ahead of core", {
  helper_env <- .load_run_advanced_bootstrap_helper_env()
  helper_env$ENV_PATH_BASE <- file.path(tempdir(), "wanlab-lib-root")
  helper_env$CORE_LIB_PATH <- file.path(helper_env$ENV_PATH_BASE, "core")
  helper_env$sys_libs <- c("/sys/base", "/sys/site")

  libs <- helper_env$.advanced_bootstrap_lib_paths()

  testthat::expect_equal(
    libs,
    c(
      file.path(helper_env$ENV_PATH_BASE, "seurat_v5"),
      file.path(helper_env$ENV_PATH_BASE, "seurat_v4"),
      helper_env$CORE_LIB_PATH,
      helper_env$sys_libs
    )
  )
})

testthat::test_that("advanced bootstrap prepares Seurat envs before missing package installs", {
  helper_env <- .load_run_advanced_bootstrap_helper_env()
  helper_env$ENV_PATH_BASE <- file.path(tempdir(), "wanlab-lib-root-prepare")
  helper_env$CORE_LIB_PATH <- file.path(helper_env$ENV_PATH_BASE, "core")
  helper_env$sys_libs <- character(0)

  calls <- character(0)
  helper_env$.step_start <- function(label) {
    calls <<- c(calls, paste0("start:", label))
    list(label = label)
  }
  helper_env$.step_end <- function(h) {
    calls <<- c(calls, paste0("end:", h$label))
    invisible(NULL)
  }
  helper_env$setup_seurat_v4 <- function() {
    calls <<- c(calls, "setup:v4")
    file.path(helper_env$ENV_PATH_BASE, "seurat_v4")
  }
  helper_env$setup_seurat_v5 <- function() {
    calls <<- c(calls, "setup:v5")
    file.path(helper_env$ENV_PATH_BASE, "seurat_v5")
  }
  helper_env$.purge_core_seurat_stack <- function(verbose = TRUE) {
    calls <<- c(calls, paste0("purge:", verbose))
    invisible(TRUE)
  }

  paths <- helper_env$.prepare_advanced_analysis_bootstrap_context(
    list(list(pkg = "NICHES", source = "github"))
  )

  testthat::expect_equal(paths$v4, file.path(helper_env$ENV_PATH_BASE, "seurat_v4"))
  testthat::expect_equal(paths$v5, file.path(helper_env$ENV_PATH_BASE, "seurat_v5"))
  testthat::expect_true(dir.exists(paths$v4))
  testthat::expect_true(dir.exists(paths$v5))
  testthat::expect_equal(
    calls,
    c(
      "start:Advanced bootstrap Seurat v4",
      "setup:v4",
      "end:Advanced bootstrap Seurat v4",
      "start:Advanced bootstrap Seurat v5",
      "setup:v5",
      "end:Advanced bootstrap Seurat v5",
      "purge:FALSE"
    )
  )
})

testthat::test_that("advanced bootstrap install wrapper uses isolated Seurat library paths", {
  helper_env <- .load_run_advanced_bootstrap_helper_env()
  helper_env$ENV_PATH_BASE <- file.path(tempdir(), "wanlab-lib-root-install")
  helper_env$CORE_LIB_PATH <- file.path(helper_env$ENV_PATH_BASE, "core")
  helper_env$sys_libs <- c("/sys/base")

  seen_paths <- NULL
  seen_plan <- NULL
  helper_env$.with_libpaths <- function(paths, fn) {
    seen_paths <<- paths
    fn()
  }
  helper_env$.ensure_many <- function(plan) {
    seen_plan <<- plan
    TRUE
  }

  plan <- list(list(pkg = "NICHES", source = "github"))
  helper_env$.install_missing_advanced_analysis_pkgs(plan)

  testthat::expect_equal(seen_paths, helper_env$.advanced_bootstrap_lib_paths())
  testthat::expect_equal(seen_plan, plan)
})
