analysis_umap_frequency_items_per_row <- function(container_width = 1050) {
  width_px <- suppressWarnings(as.numeric(container_width))
  if (!is.finite(width_px) || width_px <= 0) width_px <- 1050
  max(6L, as.integer(floor((width_px - 140) / 66)))
}

analysis_umap_frequency_legend_rows <- function(cluster_count, container_width = 1050) {
  n_clusters <- suppressWarnings(as.integer(cluster_count))
  if (!is.finite(n_clusters) || n_clusters < 1L) n_clusters <- 1L
  items_per_row <- analysis_umap_frequency_items_per_row(container_width = container_width)
  max(1L, as.integer(ceiling(n_clusters / items_per_row)))
}

analysis_umap_frequency_plot_height_px <- function(cluster_count, container_width = 1050, outer_n = 1L, inner_n = 1L) {
  legend_rows <- analysis_umap_frequency_legend_rows(
    cluster_count = cluster_count,
    container_width = container_width
  )
  legend_extra <- 20L + max(0L, legend_rows - 1L) * 24L

  outer_n <- suppressWarnings(as.integer(outer_n))
  inner_n <- suppressWarnings(as.integer(inner_n))
  if (!is.finite(outer_n) || outer_n < 1L) outer_n <- 1L
  if (!is.finite(inner_n) || inner_n < 1L) inner_n <- 1L

  total_bars <- outer_n * inner_n
  axis_extra <- if (total_bars >= 18L) {
    160L
  } else if (total_bars >= 12L) {
    120L
  } else if (total_bars >= 8L) {
    60L
  } else {
    0L
  }

  as.integer(max(620L, 520L + legend_extra + axis_extra))
}
