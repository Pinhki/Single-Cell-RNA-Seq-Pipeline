.helper_source_path <- if (file.exists("Content/interface/analysis/analysis_object_selector_helpers.R")) {
  "Content/interface/analysis/analysis_object_selector_helpers.R"
} else {
  "../../Content/interface/analysis/analysis_object_selector_helpers.R"
}
source(.helper_source_path)

testthat::test_that("analysis_object_is_integrated detects assay and compatibility fallbacks", {
  assay_entry <- list(obj = list(assays = c("RNA", "integrated")))
  stage_entry <- list(obj = list(assays = c("RNA")), meta = list(stage = "integrated"))
  prefix_entry <- list(obj = list(assays = c("RNA")))
  plain_entry <- list(obj = list(assays = c("RNA", "SCT")))
  adaptive_assay_entry <- list(obj = list(assays = c("RNA", "integrated_sct")))
  false_positive_entry <- list(obj = list(assays = c("RNA", "unintegrated")))

  testthat::expect_true(analysis_object_is_integrated("sample_a", assay_entry))
  testthat::expect_true(analysis_object_is_integrated("sample_b", stage_entry))
  testthat::expect_true(analysis_object_is_integrated("integrated_20260331", prefix_entry))
  testthat::expect_true(analysis_object_is_integrated("sample_c", adaptive_assay_entry))
  testthat::expect_false(analysis_object_is_integrated("sample_d", plain_entry))
  testthat::expect_false(analysis_object_is_integrated("sample_e", false_positive_entry))
})

testthat::test_that("analysis selector helpers resolve integrated choices and preferred default", {
  registry <- list(
    sample_a = list(obj = list(assays = c("RNA"))),
    sample_b = list(obj = list(assays = c("RNA", "integrated"))),
    integrated_legacy = list(obj = list(assays = c("RNA"))),
    sample_c = list(obj = list(assays = c("RNA")), meta = list(stage = "integrated"))
  )

  testthat::expect_equal(
    analysis_integrated_object_names(registry),
    c("sample_b", "integrated_legacy", "sample_c")
  )
  testthat::expect_identical(
    analysis_selector_mode_for_registry(registry),
    "replace"
  )
  testthat::expect_identical(
    analysis_selector_mode_for_registry(list(sample_only = list(obj = list(assays = c("RNA"))))),
    "multi"
  )
  testthat::expect_identical(
    analysis_preferred_integrated_name(registry, active_name = "sample_c"),
    "sample_c"
  )
  testthat::expect_identical(
    analysis_preferred_integrated_name(registry, active_name = "sample_a"),
    "sample_b"
  )
  testthat::expect_identical(
    analysis_preferred_integrated_name(list(sample_only = list(obj = list(assays = c("RNA"))))),
    ""
  )
})

testthat::test_that("analysis_object_is_integrated treats subset objects as reintegration sources", {
  subset_entry <- list(
    obj = list(assays = c("RNA", "integrated")),
    meta = list(stage = "recluster_subset", parents = "integrated_20260522_202247")
  )
  legacy_subset_entry <- list(
    obj = list(assays = c("RNA", "integrated")),
    meta = list(stage = "integrated", parents = "integrated_20260522_202247")
  )

  testthat::expect_false(analysis_object_is_integrated("T cells recluster 1", subset_entry))
  testthat::expect_false(analysis_object_is_integrated("T cells recluster 1", legacy_subset_entry))
})

testthat::test_that("analysis selector helpers resolve source choices and mode overrides", {
  registry <- list(
    sample_a = list(obj = list(assays = c("RNA"))),
    integrated_20260331 = list(obj = list(assays = c("RNA", "integrated"))),
    sample_b = list(obj = list(assays = c("RNA"))),
    T_cells_recluster_1 = list(
      obj = list(assays = c("RNA", "integrated")),
      meta = list(stage = "recluster_subset", parents = "integrated_20260331")
    )
  )

  testthat::expect_equal(
    analysis_nonintegrated_object_names(registry),
    c("sample_a", "sample_b", "T_cells_recluster_1")
  )
  testthat::expect_identical(
    analysis_selector_mode_for_registry(registry, reintegration_enabled = FALSE),
    "replace"
  )
  testthat::expect_identical(
    analysis_selector_mode_for_registry(registry, reintegration_enabled = TRUE),
    "reintegrate"
  )
  testthat::expect_equal(
    analysis_selector_choices_for_mode(registry, mode = "reintegrate"),
    c("sample_a", "integrated_20260331", "sample_b", "T_cells_recluster_1")
  )
})

testthat::test_that("analysis bootstrap selection prefers integrated object over stale imported selection", {
  registry <- list(
    sample_a = list(obj = list(assays = c("RNA"))),
    integrated_20260331 = list(obj = list(assays = c("RNA", "integrated"))),
    sample_b = list(obj = list(assays = c("RNA")))
  )

  boot <- analysis_bootstrap_selection(
    registry,
    active_name = "sample_a",
    current_selection = "sample_a",
    reintegration_enabled = FALSE
  )

  testthat::expect_identical(boot$mode, "replace")
  testthat::expect_identical(boot$active_name, "integrated_20260331")
  testthat::expect_identical(boot$selection, "integrated_20260331")
})

testthat::test_that("analysis preferred loaded object name promotes integrated objects during import bootstrap", {
  registry <- list(
    sample_a = list(obj = list(assays = c("RNA"))),
    integrated_20260331 = list(obj = list(assays = c("RNA", "integrated"))),
    sample_b = list(obj = list(assays = c("RNA")))
  )

  testthat::expect_identical(
    analysis_preferred_loaded_object_name(
      registry,
      focus_name = "sample_a",
      imported_active_name = "sample_a"
    ),
    "integrated_20260331"
  )
  testthat::expect_identical(
    analysis_preferred_loaded_object_name(
      registry,
      focus_name = "integrated_20260331",
      imported_active_name = "sample_a"
    ),
    "integrated_20260331"
  )
  testthat::expect_identical(
    analysis_preferred_loaded_object_name(
      list(sample_only = list(obj = list(assays = c("RNA")))),
      focus_name = "sample_only",
      imported_active_name = ""
    ),
    "sample_only"
  )
})

testthat::test_that("analysis page enables only one selector mode at a time", {
  .page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
    "Content/interface/analysis/page_analysis.R"
  } else {
    "../../Content/interface/analysis/page_analysis.R"
  }
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "enabled\\s*=\\s*isTRUE\\(.analysis_replace_selector_enabled\\(\\)\\)",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "if \\(!isTRUE\\(.analysis_replace_selector_enabled\\(\\)\\)\\) return\\(invisible\\(NULL\\)\\)",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "if \\(!isTRUE\\(.analysis_multiselect_enabled\\(\\)\\)\\) return\\(invisible\\(NULL\\)\\)",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "analysis_preferred_integrated_name(",
      page_source,
      fixed = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "analysis_reintegration_enabled <- reactiveVal\\(FALSE\\)",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "Click to cancel re-integration\\.",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "Click to enable re-integration.",
      page_source,
      fixed = TRUE
    )
  )
  testthat::expect_false(
    grepl(
      "uiOutput\\(\"analysis_object_selector_umap_inline_ui\"\\)",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_false(
    grepl(
      "output\\$analysis_object_selector_umap_inline_ui\\s*<-\\s*renderUI",
      page_source,
      perl = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "plugins\\s*=\\s*list\\(\"remove_button\"\\)",
      page_source,
      perl = TRUE
    )
  )
})

testthat::test_that("workspace import and app bootstrap share integrated-object fallback", {
  .page_rds_source_path <- if (file.exists("Content/interface/workspace/page_rds.R")) {
    "Content/interface/workspace/page_rds.R"
  } else {
    "../../Content/interface/workspace/page_rds.R"
  }
  .app_source_path <- if (file.exists("Content/app.R")) {
    "Content/app.R"
  } else {
    "../../Content/app.R"
  }

  page_rds_source <- paste(readLines(.page_rds_source_path, warn = FALSE), collapse = "\n")
  app_source <- paste(readLines(.app_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "analysis_preferred_loaded_object_name",
      page_rds_source,
      fixed = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "analysis_preferred_loaded_object_name",
      app_source,
      fixed = TRUE
    )
  )
})
