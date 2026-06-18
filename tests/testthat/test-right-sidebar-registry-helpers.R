.helper_source_path <- if (file.exists("Content/interface/components/right_sidebar_registry_helpers.R")) {
  "Content/interface/components/right_sidebar_registry_helpers.R"
} else {
  "../../Content/interface/components/right_sidebar_registry_helpers.R"
}
source(.helper_source_path)

testthat::test_that("sidebar registry safe object row falls back for malformed imported entries", {
  bad_entry <- list(
    obj = structure(list(), class = "Seurat")
  )

  row <- sidebar_registry_safe_object_row(
    "integrated_bad",
    bad_entry,
    remove_btn_html = function(key) stop("boom")
  )

  testthat::expect_s3_class(row, "data.frame")
  testthat::expect_equal(nrow(row), 1)
  testthat::expect_identical(row$name[[1]], "integrated_bad")
  testthat::expect_identical(row$key[[1]], "obj::integrated_bad")
  testthat::expect_match(row$display[[1]], "integrated_bad")
  testthat::expect_match(row$display[[1]], "Summary unavailable")
})
