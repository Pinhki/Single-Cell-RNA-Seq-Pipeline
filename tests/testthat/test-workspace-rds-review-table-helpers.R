.load_workspace_rds_helper_env <- function() {
  page_source_path <- if (file.exists("Content/interface/workspace/page_rds.R")) {
    "Content/interface/workspace/page_rds.R"
  } else {
    "../../Content/interface/workspace/page_rds.R"
  }

  lines <- readLines(page_source_path, warn = FALSE)
  cut <- grep("^# ---------------------------$", lines)[1] - 1L
  code <- paste(lines[seq_len(cut)], collapse = "\n")

  helper_env <- new.env(parent = .GlobalEnv)
  eval(parse(text = code), envir = helper_env)
  helper_env
}

testthat::test_that("workspace review table empty state keeps a stable schema", {
  helper_env <- .load_workspace_rds_helper_env()

  testthat::expect_true(is.function(helper_env$.empty_rds_review_table_df))

  empty_df <- helper_env$.empty_rds_review_table_df()

  testthat::expect_s3_class(empty_df, "data.frame")
  testthat::expect_equal(
    names(empty_df),
    c(
      "object",
      "cells",
      "assay",
      "n_features",
      "total_counts",
      "median_counts_per_cell",
      "reductions",
      "stage",
      "samples",
      "meta_cols",
      "cluster_res"
    )
  )
  testthat::expect_equal(nrow(empty_df), 0L)
})

testthat::test_that("workspace review table no longer tears down to renderDataTable(NULL)", {
  page_source_path <- if (file.exists("Content/interface/workspace/page_rds.R")) {
    "Content/interface/workspace/page_rds.R"
  } else {
    "../../Content/interface/workspace/page_rds.R"
  }
  page_source <- paste(readLines(page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_false(
    grepl(
      "output\\$rds_review_table\\s*<-\\s*DT::renderDataTable\\(NULL\\)",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "output\\$rds_review_table\\s*<-\\s*DT::renderDataTable\\([\\s\\S]*server\\s*=\\s*FALSE",
      page_source,
      perl = TRUE
    )
  )
})
