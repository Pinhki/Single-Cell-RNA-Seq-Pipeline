.shared_helper_path <- if (file.exists("Content/interface/shared/code_block_helpers.R")) {
  "Content/interface/shared/code_block_helpers.R"
} else {
  "../../Content/interface/shared/code_block_helpers.R"
}
source(.shared_helper_path)

.helper_source_path <- if (file.exists("Content/interface/figures/figure_code_card_helpers.R")) {
  "Content/interface/figures/figure_code_card_helpers.R"
} else {
  "../../Content/interface/figures/figure_code_card_helpers.R"
}
source(.helper_source_path)

testthat::test_that("figure code card ui renders editable area and copy button", {
  ui <- figure_code_card_ui(
    id = "figure_code_test",
    title = "Customize in R",
    notes = c("n1", "n2"),
    copy_button_label = "Copy Code",
    code_label = "Editable R code:"
  )
  rendered <- htmltools::renderTags(ui)$html

  testthat::expect_match(rendered, "rds-code-block")
  testthat::expect_match(rendered, "rds-r-code")
  testthat::expect_match(rendered, "fa-copy")
  testthat::expect_match(rendered, "Copy Code")
  testthat::expect_match(rendered, "Editable R code")
})

testthat::test_that("umap generator emits standalone workspace script with stroke controls", {
  script_txt <- figure_generate_umap_script(list(
    object_name = "integrated_20260330_092828",
    color_by = "seurat_clusters",
    title = "UMAP Projection",
    stroke_dash_frequency = 7
  ))
  testthat::expect_match(script_txt, "integrated_20260330_092828", fixed = TRUE)
  testthat::expect_match(script_txt, "library\\(Seurat\\)")
  testthat::expect_match(script_txt, "Seurat::Embeddings", fixed = TRUE)
  testthat::expect_match(script_txt, "stroke_dash_frequency <- 7", fixed = TRUE)
  testthat::expect_match(script_txt, "Add extra ggplot layers below", fixed = TRUE)
  testthat::expect_false(grepl("source\\(", script_txt))
})

testthat::test_that("feature generator emits standalone workspace script with stroke controls", {
  script_txt <- figure_generate_feature_script(list(
    object_name = "integrated_20260330_092828",
    feature_name = "Cd3d",
    assay_name = "RNA",
    stroke_dash_frequency = 6
  ))
  testthat::expect_match(script_txt, "integrated_20260330_092828", fixed = TRUE)
  testthat::expect_match(script_txt, "library\\(Seurat\\)")
  testthat::expect_match(script_txt, "Seurat::FetchData", fixed = TRUE)
  testthat::expect_match(script_txt, "stroke_dash_frequency <- 6", fixed = TRUE)
  testthat::expect_match(script_txt, "Add extra ggplot layers below", fixed = TRUE)
  testthat::expect_false(grepl("source\\(", script_txt))
})

testthat::test_that("dotplot generator includes object name and dotplot constructor", {
  script_txt <- figure_generate_dotplot_script(list(
    object_name = "integrated_20260330_092828",
    genes = c("Cd3d", "Cd74")
  ))
  testthat::expect_match(script_txt, "integrated_20260330_092828", fixed = TRUE)
  testthat::expect_match(script_txt, "Seurat::DotPlot", fixed = TRUE)
  testthat::expect_match(script_txt, "readRDS\\('PATH/TO/workspace_bundle.rds'\\)")
  testthat::expect_match(script_txt, "Add extra ggplot layers below", fixed = TRUE)
  testthat::expect_false(grepl("source\\(", script_txt))
})

testthat::test_that("alluvial generators include object name and alluvial constructor", {
  alluvial_txt <- figure_generate_alluvial_script(list(
    object_name = "integrated_20260330_092828",
    cluster_col = "seurat_clusters"
  ))
  cluster_txt <- figure_generate_cluster_alluvial_script(list(
    object_name = "integrated_20260330_092828",
    cluster_col = "seurat_clusters",
    group_col = "orig.ident"
  ))

  testthat::expect_match(alluvial_txt, "integrated_20260330_092828", fixed = TRUE)
  testthat::expect_match(alluvial_txt, "ggalluvial::geom_alluvium", fixed = TRUE)
  testthat::expect_match(alluvial_txt, "readRDS\\('PATH/TO/workspace_bundle.rds'\\)")
  testthat::expect_false(grepl("source\\(", alluvial_txt))
  testthat::expect_match(cluster_txt, "integrated_20260330_092828", fixed = TRUE)
  testthat::expect_match(cluster_txt, "ggalluvial::geom_alluvium", fixed = TRUE)
  testthat::expect_match(cluster_txt, "readRDS\\('PATH/TO/workspace_bundle.rds'\\)")
  testthat::expect_match(cluster_txt, "Add extra ggplot layers below", fixed = TRUE)
  testthat::expect_false(grepl("source\\(", cluster_txt))
})
