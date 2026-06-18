analysis_umap_axis_limits <- function(x, y, pad_mult = 0.10, min_span = 1) {
  x_vals <- suppressWarnings(as.numeric(x))
  y_vals <- suppressWarnings(as.numeric(y))
  keep <- is.finite(x_vals) & is.finite(y_vals)

  x_vals <- x_vals[keep]
  y_vals <- y_vals[keep]

  if (!length(x_vals) || !length(y_vals)) {
    return(list(x = c(-1, 1), y = c(-1, 1)))
  }

  xr <- range(x_vals, na.rm = TRUE)
  yr <- range(y_vals, na.rm = TRUE)
  x_span <- diff(xr)
  y_span <- diff(yr)

  min_span <- suppressWarnings(as.numeric(min_span))
  if (!is.finite(min_span) || min_span <= 0) min_span <- 1

  if (!is.finite(x_span) || x_span <= 0) x_span <- max(abs(xr), min_span)
  if (!is.finite(y_span) || y_span <= 0) y_span <- max(abs(yr), min_span)

  pad_mult <- suppressWarnings(as.numeric(pad_mult))
  if (!is.finite(pad_mult) || pad_mult < 0) pad_mult <- 0.10

  square_span <- max(x_span, y_span, min_span) * (1 + pad_mult)
  x_mid <- mean(xr)
  y_mid <- mean(yr)
  half_span <- square_span / 2

  list(
    x = c(x_mid - half_span, x_mid + half_span),
    y = c(y_mid - half_span, y_mid + half_span)
  )
}
