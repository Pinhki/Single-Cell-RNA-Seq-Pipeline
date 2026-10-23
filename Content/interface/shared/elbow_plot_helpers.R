# Agent note: This is the canonical elbow-plot builder shared by the Analysis
# and RDS import pages. Keep the rendering and theme here so cross-page fixes
# cannot drift into duplicate page-local implementations.

wanlab_build_standard_elbow_plot <- function(sobj) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)

  stdev <- tryCatch({
    red <- sobj[["pca"]]
    if (is.null(red)) return(numeric())
    as.numeric(slot(red, "stdev"))
  }, error = function(e) numeric())
  stdev <- stdev[is.finite(stdev) & !is.na(stdev)]
  if (!length(stdev)) return(NULL)

  df <- data.frame(
    PC = seq_along(stdev),
    Standard.Deviation = stdev,
    stringsAsFactors = FALSE
  )

  ggplot2::ggplot(df, ggplot2::aes(x = PC, y = Standard.Deviation)) +
    ggplot2::geom_point(size = 2.6, color = "black") +
    ggplot2::labs(x = "PC", y = "Standard Deviation") +
    ggplot2::theme_minimal(base_size = 12)
}
