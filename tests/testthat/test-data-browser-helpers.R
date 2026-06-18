.helper_source_path <- if (file.exists("Content/interface/analysis/data_browser_helpers.R")) {
  "Content/interface/analysis/data_browser_helpers.R"
} else {
  "../../Content/interface/analysis/data_browser_helpers.R"
}
source(.helper_source_path)

testthat::test_that("db_is_effectively_numeric detects numeric-like metadata vectors", {
  testthat::expect_true(db_is_effectively_numeric(c("1", "2.5", NA, "3")))
  testthat::expect_true(db_is_effectively_numeric(c(1, 2, 3)))
  testthat::expect_false(db_is_effectively_numeric(c("1", "A", "3")))
  testthat::expect_false(db_is_effectively_numeric(c(NA, NA)))
})

testthat::test_that("db_prepare_color_vector preserves continuous numerics", {
  out_num <- db_prepare_color_vector(c("1", "2.5", NA, "3"))
  testthat::expect_true(is.numeric(out_num))
  testthat::expect_equal(out_num[1], 1)
  testthat::expect_true(is.na(out_num[3]))

  out_cat <- db_prepare_color_vector(c("A", "B", NA))
  testthat::expect_type(out_cat, "character")
  testthat::expect_equal(out_cat[[3]], "NA")
})

testthat::test_that("cluster-like metadata stays discrete even when values are numeric-like", {
  vals <- c("0", "1", "2", NA, "10")
  out <- db_prepare_color_vector(vals, col_name = "sweep_nn_res.0.1")
  testthat::expect_type(out, "character")
  testthat::expect_equal(out[[1]], "0")
  testthat::expect_equal(out[[4]], "NA")
})

testthat::test_that("cluster-like column detection catches common cluster metadata names", {
  testthat::expect_true(db_is_cluster_like_metadata("seurat_clusters", c("0", "1", "2")))
  testthat::expect_true(db_is_cluster_like_metadata("sweep_nn_res.0.1", c("0", "1", "2")))
  testthat::expect_false(db_is_cluster_like_metadata("nCount_RNA", c("1000", "1200", "900")))
})

testthat::test_that("cluster levels are ordered with numeric-first cluster semantics", {
  lv <- db_order_levels_for_color(c("10", "2", "1", "B"), cluster_like = TRUE)
  testthat::expect_equal(lv, c("1", "2", "10", "B"))
})

testthat::test_that("db_build_split_choices keeps preferred order and none option", {
  cols <- c("orig.ident", "batch", "custom_col")
  out <- db_build_split_choices(cols)
  testthat::expect_equal(unname(out[[1]]), "__none__")
  testthat::expect_true("orig.ident" %in% names(out))
  testthat::expect_true("batch" %in% names(out))
  testthat::expect_true("custom_col" %in% names(out))

  out2 <- db_build_split_choices(cols, exclude = "orig.ident")
  testthat::expect_false("orig.ident" %in% names(out2))
})

testthat::test_that("split guard blocks continuous numeric metadata from split choices", {
  md <- data.frame(
    orig.ident = c("S1", "S1", "S2", "S2"),
    seurat_clusters = c("0", "1", "0", "1"),
    nCount_RNA = c("1000", "1001", "1002", "1003"),
    stringsAsFactors = FALSE
  )
  testthat::expect_true(db_is_split_safe_metadata("orig.ident", md$orig.ident))
  testthat::expect_true(db_is_split_safe_metadata("seurat_clusters", md$seurat_clusters))
  testthat::expect_false(db_is_split_safe_metadata("nCount_RNA", md$nCount_RNA))

  out <- db_build_split_choices(colnames(md), meta_df = md)
  testthat::expect_true("orig.ident" %in% names(out))
  testthat::expect_true("seurat_clusters" %in% names(out))
  testthat::expect_false("nCount_RNA" %in% names(out))
})
