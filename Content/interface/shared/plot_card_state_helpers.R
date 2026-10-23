# Shared UMAP state contract:
# Analysis and Data Browser may render separate controls, but they must read and
# write the same active-object-scoped UMAP/reduction values. Initialize controls
# directly from the shared final values; never show intermediate dropdown states
# or trial-render alternate parameters. If no shared values exist, seed the
# declared default/first choice (normally UMAP) once and reuse matching plots.

plot_card_not_ready_ui <- function(note, height_px = 360L, class = NULL) {
  msg <- if (is.null(note)) "" else as.character(note)
  h <- suppressWarnings(as.integer(height_px))
  if (!is.finite(h) || is.na(h) || h < 120L) h <- 360L
  cls <- paste(c("plot-card-not-ready", "anno-empty-state", class), collapse = " ")
  shiny::tags$div(
    class = cls,
    style = sprintf("height: %dpx;", h),
    msg
  )
}

.safe_plot_width <- function(session, id, default = 600L) {
  function() {
    val <- session$clientData[[paste0("output_", id, "_width")]]
    if (is.null(val) || is.na(val) || val < 20) default else as.integer(val)
  }
}

.safe_plot_height <- function(session, id, default = 400L) {
  function() {
    val <- session$clientData[[paste0("output_", id, "_height")]]
    if (is.null(val) || is.na(val) || val < 20) default else as.integer(val)
  }
}
