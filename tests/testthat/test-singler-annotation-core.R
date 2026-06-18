.singler_core_source_path <- if (file.exists("Content/core/backends/singler_annotation_core.R")) {
  "Content/core/backends/singler_annotation_core.R"
} else {
  "../../Content/core/backends/singler_annotation_core.R"
}
source(.singler_core_source_path)

testthat::test_that("singler_detect_gene_id_style distinguishes common ID patterns", {
  testthat::expect_identical(
    singler_detect_gene_id_style(c("ENSG00000141510", "ENSG00000171862")),
    "ensembl-like"
  )
  testthat::expect_identical(
    singler_detect_gene_id_style(c("MS4A1", "CD3D", "NKG7")),
    "symbol-like"
  )
  testthat::expect_identical(
    singler_detect_gene_id_style(c("gene_1", "feature_2")),
    "mixed-or-other"
  )
})

testthat::test_that("singler_collect_overlap_details reports counts and examples", {
  test_mat <- matrix(
    seq_len(12),
    nrow = 4,
    dimnames = list(
      c("ENSG000001", "ENSG000002", "ENSG000003", "ENSG000004"),
      paste0("cell_", 1:3)
    )
  )
  ref <- matrix(
    seq_len(9),
    nrow = 3,
    dimnames = list(
      c("ENSG000002", "ENSG000004", "ENSG000009"),
      paste0("ref_", 1:3)
    )
  )

  details <- singler_collect_overlap_details(
    test_mat = test_mat,
    ref = ref,
    ref_name = "MockRef",
    min_common_genes = 2L
  )

  testthat::expect_identical(details$common_genes, 2L)
  testthat::expect_identical(details$dropped_genes, 2L)
  testthat::expect_true(isTRUE(details$ok))
  testthat::expect_identical(details$test_id_style, "ensembl-like")
  testthat::expect_identical(details$ref_id_style, "ensembl-like")
  testthat::expect_equal(details$test_examples, c("ENSG000001", "ENSG000002", "ENSG000003", "ENSG000004"))
  testthat::expect_equal(details$ref_examples, c("ENSG000002", "ENSG000004", "ENSG000009"))
})

testthat::test_that("singler_assert_reference_overlap fails early with actionable message", {
  test_mat <- matrix(
    seq_len(15),
    nrow = 5,
    dimnames = list(
      c("ENSG000001", "ENSG000002", "ENSG000003", "ENSG000004", "ENSG000005"),
      paste0("cell_", 1:3)
    )
  )
  ref <- matrix(
    seq_len(12),
    nrow = 4,
    dimnames = list(
      c("CD3D", "MS4A1", "NKG7", "LYZ"),
      paste0("ref_", 1:3)
    )
  )

  testthat::expect_error(
    singler_assert_reference_overlap(
      test_mat = test_mat,
      ref = ref,
      ref_name = "HumanPrimaryCellAtlasData",
      label_level = "label.main",
      min_common_genes = 3L
    ),
    regexp = paste(
      "Only 0 common genes were found",
      "HumanPrimaryCellAtlasData",
      "Ensembl IDs vs gene symbols",
      "Test gene ID style: ensembl-like",
      "Reference gene ID style: symbol-like",
      sep = ".*"
    )
  )
})

testthat::test_that("analysis page exposes SingleR cluster toggle and does not abort on overlap guard", {
  .page_source_path <- if (file.exists("Content/interface/analysis/page_analysis.R")) {
    "Content/interface/analysis/page_analysis.R"
  } else {
    "../../Content/interface/analysis/page_analysis.R"
  }
  page_source <- paste(readLines(.page_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(grepl("anno_singler_cluster_mode", page_source, fixed = TRUE))
  testthat::expect_false(
    grepl(
      "singler_assert_reference_overlap\\(",
      page_source,
      fixed = TRUE
    )
  )
})
