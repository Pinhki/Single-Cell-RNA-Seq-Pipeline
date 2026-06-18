.helper_source_path <- if (file.exists("Content/interface/figures/figure_color_popup_helpers.R")) {
  "Content/interface/figures/figure_color_popup_helpers.R"
} else {
  "../../Content/interface/figures/figure_color_popup_helpers.R"
}
source(.helper_source_path)

testthat::test_that("figure_resolve_discrete_palette extends and trims deterministically", {
  palette_map <- list(Custom = c("#111111", "#222222", "#333333"))

  testthat::expect_equal(
    figure_resolve_discrete_palette(
      palette_name = "Custom Curve",
      level_count = 2,
      palette_map = palette_map,
      custom_palette = c("#AA0000", "#00AA00", "#0000AA"),
      default_palette = c("#999999", "#BBBBBB")
    ),
    c("#AA0000", "#00AA00")
  )

  expanded <- figure_resolve_discrete_palette(
    palette_name = "Custom Curve",
    level_count = 5,
    palette_map = palette_map,
    custom_palette = c("#AA0000", "#00AA00"),
    default_palette = c("#999999", "#BBBBBB")
  )

  testthat::expect_length(expanded, 5)
  testthat::expect_equal(expanded[[1]], "#AA0000")
  testthat::expect_equal(expanded[[5]], "#00AA00")
})

testthat::test_that("figure_resolve_discrete_palette preserves default seurat null semantics", {
  testthat::expect_null(
    figure_resolve_discrete_palette(
      palette_name = "Default Seurat",
      level_count = 4,
      palette_map = list(),
      custom_palette = c("#AA0000", "#00AA00"),
      default_palette = c("#999999", "#BBBBBB")
    )
  )
})

testthat::test_that("figure_normalize_gradient_colors returns safe uppercase hex values", {
  testthat::expect_equal(
    figure_normalize_gradient_colors(
      low = "lightgrey",
      high = "#ff0000",
      defaults = c(low = "#D3D3D3", high = "#FF0000")
    ),
    c(low = "#D3D3D3", high = "#FF0000")
  )

  testthat::expect_equal(
    figure_normalize_gradient_colors(
      low = "#aabbcc",
      high = "00ff00",
      defaults = c(low = "#D3D3D3", high = "#FF0000")
    ),
    c(low = "#AABBCC", high = "#00FF00")
  )
})

testthat::test_that("figure_palette_seed keeps palette size and valid fallback color", {
  seed <- figure_palette_seed(c("#123456", "#654321", "#ABCDEF"), fallback = "#3B82F6")
  testthat::expect_equal(seed$initial_hex, "#123456")
  testthat::expect_equal(seed$palette_n, 3)

  fallback_seed <- figure_palette_seed(character(0), fallback = "#3B82F6")
  testthat::expect_equal(fallback_seed$initial_hex, "#3B82F6")
  testthat::expect_equal(fallback_seed$palette_n, 6)
})

testthat::test_that("figure_gradient_commit_values extracts and normalizes picker payload colors", {
  committed <- figure_gradient_commit_values(
    low_payload = list(hex = "#aabbcc"),
    high_payload = list(hex = "00ff00"),
    defaults = c(low = "#D3D3D3", high = "#FF0000")
  )

  testthat::expect_equal(committed, c(low = "#AABBCC", high = "#00FF00"))
})

testthat::test_that("figure_gradient_commit_values falls back when picker payload is untouched default init", {
  committed <- figure_gradient_commit_values(
    low_payload = list(hex = "#3B82F6", meta = list(source = "init")),
    high_payload = list(hex = "#3B82F6", meta = list(source = "init")),
    defaults = c(low = "#D3D3D3", high = "#FF0000")
  )

  testthat::expect_equal(committed, c(low = "#D3D3D3", high = "#FF0000"))
})

testthat::test_that("figure_palette_from_payload keeps only valid uppercase hex colors", {
  payload <- list(palette = c("#123456", "bad", "#abcdef", NA))
  testthat::expect_equal(
    figure_palette_from_payload(payload, fallback = c("#3B82F6", "#10B981")),
    c("#123456", "#ABCDEF")
  )

  testthat::expect_equal(
    figure_palette_from_payload(list(palette = character(0)), fallback = c("#3B82F6", "#10B981")),
    c("#3B82F6", "#10B981")
  )
})

testthat::test_that("figure_palette_from_payload falls back when untouched curve payload stays on module default", {
  untouched_payload <- list(
    palette = c("#1D4ED8", "#3B82F6", "#60A5FA", "#93C5FD", "#BFDBFE", "#DBEAFE"),
    meta = list(source = "init")
  )

  testthat::expect_equal(
    figure_palette_from_payload(untouched_payload, fallback = c("#AA0000", "#00AA00", "#0000AA")),
    c("#AA0000", "#00AA00", "#0000AA")
  )
})

testthat::test_that("figure busy spinner helper renders flower epic overlay", {
  wrapped <- figure_with_busy_spinner(shiny::plotOutput("figure_test_plot", height = "300px"))
  rendered <- htmltools::renderTags(wrapped)$html

  testthat::expect_match(rendered, "figure-load-wrap")
  testthat::expect_match(rendered, "figure-load-indicator")
  testthat::expect_match(rendered, "flower")
  testthat::expect_match(rendered, "figure_test_plot")
})

testthat::test_that("figure busy spinner assets include recalculating overlay rules", {
  rendered <- htmltools::renderTags(figure_busy_spinner_assets)$html

  testthat::expect_match(rendered, "figure-load-wrap")
  testthat::expect_match(rendered, "recalculating")
  testthat::expect_match(rendered, "figure-load-indicator")
  testthat::expect_match(rendered, "background: rgba\\(38, 38, 38, 0.42\\)")
})

testthat::test_that("figure meta color columns include prioritized and non-factor metadata", {
  meta <- data.frame(
    sample = c("B", "A"),
    score = c(2, 1),
    seurat_clusters = c("0", "1"),
    stringsAsFactors = FALSE
  )

  cols <- figure_meta_columns_for_color(meta)

  testthat::expect_true(length(cols) >= 3)
  testthat::expect_equal(cols[[1]], "seurat_clusters")
  testthat::expect_true(all(c("sample", "score") %in% cols))
})

testthat::test_that("figure color levels handle factor and character-like metadata safely", {
  testthat::expect_equal(
    figure_color_levels_from_vector(factor(c("1", "0"), levels = c("0", "1"))),
    c("0", "1")
  )

  testthat::expect_equal(
    figure_color_levels_from_vector(c("beta", NA, "alpha", "beta")),
    c("NA", "alpha", "beta")
  )
})

testthat::test_that("figure preferred object name falls back to integrated UMAP-ready object", {
  registry <- list(
    SR010268_MG_NOD_20 = list(
      assays = c("RNA"),
      reductions = character(0)
    ),
    integrated_20260330_092828 = list(
      meta = list(stage = "integrated"),
      assays = c("integrated", "RNA"),
      reductions = c("umap", "pca")
    )
  )

  testthat::expect_equal(
    figure_preferred_object_name(
      registry = registry,
      current_selection = "",
      active_name = "SR010268_MG_NOD_20",
      required_reductions = "umap"
    ),
    "integrated_20260330_092828"
  )
})

testthat::test_that("figure preferred object name preserves a valid current page selection", {
  registry <- list(
    integrated_20260330_092828 = list(
      meta = list(stage = "integrated"),
      assays = c("integrated", "RNA"),
      reductions = c("umap", "pca")
    ),
    sample_processed = list(
      assays = c("RNA"),
      reductions = c("umap")
    )
  )

  testthat::expect_equal(
    figure_preferred_object_name(
      registry = registry,
      current_selection = "sample_processed",
      active_name = "integrated_20260330_092828",
      required_reductions = "umap"
    ),
    "sample_processed"
  )
})

testthat::test_that("figure select signatures stay stable for repeated identical updates", {
  sig <- figure_select_input_signature(
    choices = c("integrated_20260330_092828", "SR010268_MG_NOD_20"),
    selected = "integrated_20260330_092828"
  )

  testthat::expect_false(
    figure_select_input_needs_update(
      last_signature = sig,
      choices = c("integrated_20260330_092828", "SR010268_MG_NOD_20"),
      selected = "integrated_20260330_092828"
    )
  )

  testthat::expect_true(
    figure_select_input_needs_update(
      last_signature = sig,
      choices = c("integrated_20260330_092828", "SR010268_MG_NOD_20"),
      selected = "SR010268_MG_NOD_20"
    )
  )
})

testthat::test_that("figure shared plot settings initialize once per session with figure defaults", {
  fake_session <- list(userData = new.env(parent = emptyenv()))

  settings_a <- figure_shared_plot_settings(fake_session)
  settings_b <- figure_shared_plot_settings(fake_session)

  testthat::expect_identical(settings_a, settings_b)

  snapshot <- figure_shared_plot_settings_values(settings_a)
  testthat::expect_equal(snapshot$plot_theme, "Classic")
  testthat::expect_equal(snapshot$point_size, 1)
  testthat::expect_equal(snapshot$point_alpha, 1)
  testthat::expect_equal(snapshot$point_shape, 19)
  testthat::expect_equal(snapshot$point_stroke, 0)
  testthat::expect_equal(snapshot$color_map, "color")
  testthat::expect_equal(snapshot$x_label, "UMAP_1")
  testthat::expect_equal(snapshot$y_label, "UMAP_2")
  testthat::expect_equal(snapshot$legend_text_size, 10)
})

testthat::test_that("figure label size normalization makes cluster annotation optional", {
  testthat::expect_equal(figure_effective_label_size(FALSE, 4), 0)
  testthat::expect_equal(figure_effective_label_size(TRUE, 4), 4)
  testthat::expect_equal(figure_effective_label_size(TRUE, -1), 0)
})

testthat::test_that("figure point mapping coerces non-fill shapes into a fillable glyph", {
  fill_mapping <- figure_point_mapping(point_shape = 19, point_stroke = 0.3, color_map = "fill")
  color_mapping <- figure_point_mapping(point_shape = 19, point_stroke = 0.3, color_map = "color")

  testthat::expect_equal(fill_mapping$shape, 21)
  testthat::expect_equal(fill_mapping$aes_name, "fill")
  testthat::expect_equal(color_mapping$shape, 19)
  testthat::expect_equal(color_mapping$aes_name, "color")
})

testthat::test_that("figure color levels apply zero-based normalization for cluster-like columns", {
  lv <- figure_color_levels_from_vector(c("1", "2", "3"), column_name = "seurat_clusters")
  testthat::expect_equal(lv, c("0", "1", "2"))
})

testthat::test_that("figure stroke linetype shortens dashes as frequency increases", {
  low_freq <- figure_stroke_linetype_from_frequency(1)
  high_freq <- figure_stroke_linetype_from_frequency(9)

  testthat::expect_true(is.character(low_freq) && nchar(low_freq) == 2)
  testthat::expect_true(is.character(high_freq) && nchar(high_freq) == 2)
  testthat::expect_true(substr(low_freq, 1, 1) > substr(high_freq, 1, 1))
})

testthat::test_that("figure build stroke overlay returns one group per selected cluster without merge", {
  df <- data.frame(
    dim1 = c(0, 1, 0, 10, 11, 10, 30),
    dim2 = c(0, 0, 1, 0, 0, 1, 30),
    stroke_value = c("A", "A", "A", "B", "B", "B", "C"),
    split_value = factor(rep("All cells", 7), levels = "All cells"),
    split_value_secondary = factor(rep("All cells", 7), levels = "All cells"),
    stringsAsFactors = FALSE
  )

  overlay <- figure_build_cluster_stroke_overlay_data(
    df = df,
    selected_values = c("A", "B"),
    merge_groups = FALSE,
    padding = 0
  )

  groups <- unique(overlay$stroke_group)
  testthat::expect_length(groups, 2)
  testthat::expect_true(any(grepl("A", groups, fixed = TRUE)))
  testthat::expect_true(any(grepl("B", groups, fixed = TRUE)))
})

testthat::test_that("figure build stroke overlay merges selected clusters and applies padding", {
  df <- data.frame(
    dim1 = c(0, 1, 0, 10, 11, 10),
    dim2 = c(0, 0, 1, 0, 0, 1),
    stroke_value = c("A", "A", "A", "B", "B", "B"),
    split_value = factor(rep("All cells", 6), levels = "All cells"),
    split_value_secondary = factor(rep("All cells", 6), levels = "All cells"),
    stringsAsFactors = FALSE
  )

  overlay_no_pad <- figure_build_cluster_stroke_overlay_data(
    df = df,
    selected_values = c("A", "B"),
    merge_groups = TRUE,
    padding = 0
  )
  overlay_pad <- figure_build_cluster_stroke_overlay_data(
    df = df,
    selected_values = c("A", "B"),
    merge_groups = TRUE,
    padding = 0.2
  )

  testthat::expect_equal(length(unique(overlay_no_pad$stroke_group)), 1)
  testthat::expect_equal(length(unique(overlay_pad$stroke_group)), 1)
  testthat::expect_true(max(abs(overlay_pad$dim1)) >= max(abs(overlay_no_pad$dim1)))
})
