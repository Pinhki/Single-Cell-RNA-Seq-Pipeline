.helper_source_path <- if (file.exists("Content/interface/analysis/annotation_layer_helpers.R")) {
  "Content/interface/analysis/annotation_layer_helpers.R"
} else {
  "../../Content/interface/analysis/annotation_layer_helpers.R"
}
source(.helper_source_path)

testthat::test_that("annotation default layer base keeps package name and annotation token", {
  testthat::expect_identical(
    annotation_default_layer_base("singleR", "tool_annotation"),
    "singleR_annotation"
  )
  testthat::expect_identical(
    annotation_default_layer_base("celltypist", ""),
    "celltypist_annotation"
  )
  testthat::expect_identical(
    annotation_default_layer_base("singleR", "custom"),
    "custom_annotation"
  )
})

testthat::test_that("annotation SingleR layer names append parsed resolution suffix", {
  testthat::expect_identical(
    annotation_singler_layer_name("tool_annotation", "integrated_snn_res.0.4"),
    "singleR_annotation_res_0.4"
  )
  testthat::expect_identical(
    annotation_singler_layer_name("my_annotation", "RNA_snn_res.1"),
    "my_annotation_res_1"
  )
})

testthat::test_that("annotation SingleR resolution choices group only multi-resolution annotation layers", {
  bucket <- list(
    singleR_annotation_res_0.4 = list(
      tool_name = "SingleR",
      params = list(run_mode = "multi_resolution", cluster_column = "integrated_snn_res.0.4", reference = "ImmGenData")
    ),
    singleR_annotation_res_0.8 = list(
      tool_name = "SingleR",
      params = list(run_mode = "multi_resolution", cluster_column = "integrated_snn_res.0.8", reference = "ImmGenData")
    ),
    singleR_annotation_res_1.2 = list(
      tool_name = "SingleR",
      params = list(run_mode = "single_resolution", cluster_column = "integrated_snn_res.1.2", reference = "ImmGenData")
    ),
    celltypist_annotation = list(
      tool_name = "CellTypist",
      params = list()
    )
  )

  choices <- annotation_singler_resolution_choices(bucket)
  testthat::expect_identical(
    unname(choices),
    c("singleR_annotation_res_0.4", "singleR_annotation_res_0.8")
  )
  testthat::expect_identical(
    names(choices),
    c("Resolution 0.4", "Resolution 0.8")
  )
})

testthat::test_that("analysis page includes multi-resolution SingleR controls and dedicated switcher", {
  .page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
    "Content/interface/analysis/page_analysis.R"
  } else {
    "../../Content/interface/analysis/page_analysis.R"
  }
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("anno_singler_cluster_cols_ui", page_source, fixed = TRUE))
  testthat::expect_true(grepl("anno_singler_resolution_switcher_ui", page_source, fixed = TRUE))
  testthat::expect_true(grepl("annotation_singler_layer_name", page_source, fixed = TRUE))
  testthat::expect_true(grepl("annotation_singler_resolution_choices", page_source, fixed = TRUE))
})
