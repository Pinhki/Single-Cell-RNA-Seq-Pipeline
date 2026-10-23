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

testthat::test_that("analysis bootstrap selection preserves valid active object", {
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
  testthat::expect_identical(boot$active_name, "sample_a")
  testthat::expect_identical(boot$selection, "sample_a")
})

testthat::test_that("analysis preferred loaded object name preserves explicit object intent", {
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
    "sample_a"
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
  testthat::expect_identical(
    analysis_preferred_loaded_object_name(registry),
    "sample_b"
  )
})

testthat::test_that("missing active object defaults to newest registry entry", {
  registry <- list(
    sample_a = list(obj = list(assays = c("RNA"))),
    sample_b = list(obj = list(assays = c("RNA")))
  )

  boot <- analysis_bootstrap_selection(
    registry,
    active_name = "",
    current_selection = character(0),
    reintegration_enabled = FALSE
  )
  testthat::expect_identical(boot$active_name, "sample_b")
  testthat::expect_identical(boot$selection, "sample_b")
})

testthat::test_that("replace-mode bootstrap also defaults to newest registry entry", {
  registry <- list(
    sample_a = list(obj = list(assays = c("RNA"))),
    integrated_old = list(obj = list(assays = c("RNA", "integrated"))),
    newest_object = list(obj = list(assays = c("RNA")))
  )

  boot <- analysis_bootstrap_selection(
    registry,
    active_name = "",
    current_selection = character(0),
    reintegration_enabled = FALSE
  )
  testthat::expect_identical(boot$active_name, "newest_object")
  testthat::expect_identical(boot$selection, "newest_object")
})

testthat::test_that("active-object recovery call sites use registry tail", {
  read_source <- function(path) {
    source_path <- if (file.exists(path)) path else file.path("..", "..", path)
    paste(readLines(source_path, warn = FALSE), collapse = "\n")
  }
  app_source <- read_source("Content/app.R")
  analysis_source <- read_source("Content/interface/analysis/page_analysis.R")
  browser_source <- read_source("Content/interface/analysis/page_data_browser.R")
  workspace_source <- read_source("Content/interface/workspace/page_rds.R")
  sidebar_source <- read_source("Content/interface/components/component_right_sidebar.R")
  barcode_source <- read_source("Content/interface/qc/page_barcodes.R")
  qc_source <- read_source("Content/interface/qc/page_qc.R")
  flowgate_source <- read_source("Content/interface/qc/page_flowgate.R")
  doublet_source <- read_source("Content/interface/qc/page_doublet.R")
  vdj_source <- read_source("Content/interface/qc/page_vdj.R")
  hto_source <- read_source("Content/interface/qc/page_hto.R")
  contamination_source <- read_source("Content/interface/qc/page_contamination_correction.R")
  atac_source <- read_source("Content/interface/qc/page_atac_qc.R")
  rds_source <- read_source("Content/interface/workspace/page_rds.R")
  beta_source <- read_source("Content/core/backends/analysis_beta_methods_core.R")
  beta_backend_sources <- vapply(
    c(
      "Content/core/backends/cellchat_core.R",
      "Content/core/backends/monocle2_core.R",
      "Content/core/backends/nichenet_core.R",
      "Content/core/backends/niches_core.R",
      "Content/core/backends/rna_velocity_core.R",
      "Content/core/backends/scenic_core.R",
      "Content/core/backends/sctenifoldknk_core.R"
    ),
    read_source,
    character(1)
  )

  testthat::expect_true(grepl("valid_names\\[\\[length\\(valid_names\\)\\]\\]", app_source, perl = TRUE))
  testthat::expect_true(grepl("obj_names\\[\\[length\\(obj_names\\)\\]\\]", app_source, perl = TRUE))
  testthat::expect_true(grepl("imported\\[\\[length\\(imported\\)\\]\\]", app_source, perl = TRUE))
  testthat::expect_true(grepl("reg_names\\[\\[length\\(reg_names\\)\\]\\]", analysis_source, perl = TRUE))
  testthat::expect_true(grepl("reg_names\\[\\[length\\(reg_names\\)\\]\\]", browser_source, perl = TRUE))
  testthat::expect_true(grepl("object_names\\[\\[length\\(object_names\\)\\]\\]", workspace_source, perl = TRUE))
  testthat::expect_true(grepl("remain\\[\\[length\\(remain\\)\\]\\]", sidebar_source, perl = TRUE))
  testthat::expect_true(grepl("created\\[\\[length\\(created\\)\\]\\]", barcode_source, perl = TRUE))
  testthat::expect_true(grepl("entry_names\\[\\[length\\(entry_names\\)\\]\\]", qc_source, perl = TRUE))
  testthat::expect_true(grepl("objs\\[\\[length\\(objs\\)\\]\\]", flowgate_source, perl = TRUE))
  testthat::expect_true(grepl("object_names\\[\\[length\\(object_names\\)\\]\\]", doublet_source, perl = TRUE))
  testthat::expect_true(grepl("nms\\[\\[length\\(nms\\)\\]\\]", vdj_source, perl = TRUE))
  testthat::expect_true(grepl("nms\\[\\[length\\(nms\\)\\]\\]", hto_source, perl = TRUE))
  testthat::expect_true(grepl("nms\\[\\[length\\(nms\\)\\]\\]", contamination_source, perl = TRUE))
  testthat::expect_true(grepl("applied\\[\\[length\\(applied\\)\\]\\]", atac_source, perl = TRUE))
  testthat::expect_true(grepl("nms\\[\\[length\\(nms\\)\\]\\]", rds_source, perl = TRUE))
  testthat::expect_true(grepl("imported_names\\[\\[length\\(imported_names\\)\\]\\]", sidebar_source, perl = TRUE))
  testthat::expect_true(grepl("imported_names\\[\\[length\\(imported_names\\)\\]\\]", workspace_source, perl = TRUE))
  testthat::expect_true(grepl("registry_names\\[\\[length\\(registry_names\\)\\]\\]", beta_source, perl = TRUE))
  testthat::expect_true(all(grepl("valid_nms\\[\\[length\\(valid_nms\\)\\]\\]", beta_backend_sources, fixed = FALSE)))
})

testthat::test_that("analysis page separates header switching from integration selection", {
  .page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
    "Content/interface/analysis/page_analysis.R"
  } else {
    "../../Content/interface/analysis/page_analysis.R"
  }
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("enabled = reactive(TRUE)", page_source, fixed = TRUE))
  testthat::expect_true(
    grepl(
      "!isTRUE(.analysis_should_lock_integration())",
      page_source,
      fixed = TRUE
    )
  )
  testthat::expect_true(
    grepl(
      "active = reactive(identical(.scalar_chr(input$main_navbar, default = \"\"), \"analysis_tab\"))",
      page_source,
      fixed = TRUE
    )
  )
  testthat::expect_true(grepl("analysis_prefer_integrated_boot_pending(FALSE)", page_source, fixed = TRUE))
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
