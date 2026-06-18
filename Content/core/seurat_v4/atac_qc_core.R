# atac_qc_core.R (v4 shim)
# Multiome ATAC QC is Seurat v5-only in UI. Keep function signatures available.

`%||%` <- function(a, b) if (is.null(a)) b else a

core_atac_qc_metric_map <- function() {
  list(
    count_atac = c("nCount_ATAC", "peak_region_fragments"),
    feature_atac = c("nFeature_ATAC"),
    tss = c("TSS.enrichment", "TSS_enrichment"),
    nuc = c("nucleosome_signal", "nucleosomeSignal"),
    frip = c("pct_reads_in_peaks", "FRiP", "frip")
  )
}

core_atac_qc_first_col <- function(md, candidates) {
  hit <- candidates[candidates %in% colnames(md)]
  if (!length(hit)) return(NULL)
  hit[[1]]
}

core_atac_qc_get_metric <- function(md, key) {
  mm <- core_atac_qc_metric_map()
  cnam <- core_atac_qc_first_col(md, mm[[key]] %||% character(0))
  if (is.null(cnam)) return(rep(NA_real_, nrow(md)))
  suppressWarnings(as.numeric(md[[cnam]]))
}

core_atac_qc_infer_thresholds <- function(md) {
  cnt <- core_atac_qc_get_metric(md, "count_atac")
  tss <- core_atac_qc_get_metric(md, "tss")
  nuc <- core_atac_qc_get_metric(md, "nuc")
  frp <- core_atac_qc_get_metric(md, "frip")
  q_or <- function(x, p, default) {
    x <- x[is.finite(x)]
    if (!length(x)) return(default)
    y <- suppressWarnings(stats::quantile(x, p, na.rm = TRUE))
    if (!length(y) || !is.finite(y[[1]])) return(default)
    as.numeric(y[[1]])
  }

  safe_rng <- function(x, dmin = 0, dmax = 1) {
    x <- x[is.finite(x)]
    if (!length(x)) return(c(dmin, dmax))
    r <- range(x, na.rm = TRUE)
    if (!all(is.finite(r))) return(c(dmin, dmax))
    if (r[[1]] == r[[2]]) r[[2]] <- r[[1]] + 1
    r
  }

  r_cnt <- safe_rng(cnt, 0, 50000)
  r_tss <- safe_rng(tss, 0, 15)
  r_nuc <- safe_rng(nuc, 0, 3)
  r_frp <- safe_rng(frp, 0, 100)

  list(
    min_count_atac = floor(q_or(cnt, 0.01, r_cnt[[1]])),
    max_count_atac = ceiling(q_or(cnt, 0.99, r_cnt[[2]])),
    min_tss = round(q_or(tss, 0.10, r_tss[[1]]), 2),
    max_nucleosome = round(q_or(nuc, 0.90, r_nuc[[2]]), 2),
    min_frip = round(q_or(frp, 0.10, r_frp[[1]]), 2),
    max_frip = round(q_or(frp, 0.99, r_frp[[2]]), 2),
    range_count_atac = c(floor(r_cnt[[1]]), ceiling(r_cnt[[2]])),
    range_tss = c(round(r_tss[[1]], 2), round(r_tss[[2]], 2)),
    range_nucleosome = c(round(r_nuc[[1]], 2), round(r_nuc[[2]], 2)),
    range_frip = c(round(r_frp[[1]], 2), round(r_frp[[2]], 2))
  )
}

core_atac_qc_mask <- function(md, th) {
  cnt <- core_atac_qc_get_metric(md, "count_atac")
  tss <- core_atac_qc_get_metric(md, "tss")
  nuc <- core_atac_qc_get_metric(md, "nuc")
  frp <- core_atac_qc_get_metric(md, "frip")

  keep <- rep(TRUE, nrow(md))
  if (any(is.finite(cnt))) keep <- keep & is.finite(cnt) & cnt >= as.numeric(th$min_count_atac) & cnt <= as.numeric(th$max_count_atac)
  if (any(is.finite(tss))) keep <- keep & is.finite(tss) & tss >= as.numeric(th$min_tss)
  if (any(is.finite(nuc))) keep <- keep & is.finite(nuc) & nuc <= as.numeric(th$max_nucleosome)
  if (any(is.finite(frp))) keep <- keep & is.finite(frp) & frp >= as.numeric(th$min_frip) & frp <= as.numeric(th$max_frip)

  list(keep = keep, count_atac = cnt, feature_atac = core_atac_qc_get_metric(md, "feature_atac"), tss = tss, nuc = nuc, frip = frp)
}

core_atac_qc_apply <- function(sobj, th) {
  md <- sobj@meta.data
  ms <- core_atac_qc_mask(md, th)
  if (!any(ms$keep)) return(NULL)
  subset(sobj, cells = rownames(md)[ms$keep])
}

core_atac_qc_plot_metric <- function(md, th, sample_name = "sample") {
  core_atac_qc_plot_scatter(md, th)
}

core_atac_qc_plot_metric_panel <- function(md, th, metric_key = "count_atac", sample_name = "sample") {
  ms <- core_atac_qc_mask(md, th)
  vals <- switch(
    metric_key,
    count_atac = ms$count_atac,
    nuc = ms$nuc,
    frip = ms$frip,
    tss = ms$tss,
    ms$count_atac
  )
  metric_name <- switch(
    metric_key,
    count_atac = "nCount_ATAC",
    nuc = "nucleosome_signal",
    frip = "pct_reads_in_peaks (FRiP)",
    tss = "TSS.enrichment",
    "nCount_ATAC"
  )
  thresh_min <- switch(
    metric_key,
    count_atac = as.numeric(th$min_count_atac),
    nuc = NA_real_,
    frip = as.numeric(th$min_frip),
    tss = as.numeric(th$min_tss),
    NA_real_
  )
  thresh_max <- switch(
    metric_key,
    count_atac = as.numeric(th$max_count_atac),
    nuc = as.numeric(th$max_nucleosome),
    frip = as.numeric(th$max_frip),
    tss = NA_real_,
    NA_real_
  )

  ok <- is.finite(vals)
  if (!any(ok)) return(ggplot2::ggplot() + ggplot2::theme_void())

  df <- data.frame(
    group = sample_name,
    value = vals[ok],
    status = ifelse(ms$keep[ok], "Pass", "Fail"),
    stringsAsFactors = FALSE
  )
  y_rng <- range(df$value, na.rm = TRUE)
  y_span <- max(1e-9, diff(y_rng))

  p <- ggplot2::ggplot(df, ggplot2::aes(x = group, y = value)) +
    ggplot2::geom_violin(fill = "#58b857", color = "#6d6d6d", alpha = 0.9, width = 0.85, trim = TRUE) +
    ggplot2::geom_point(
      ggplot2::aes(color = status),
      alpha = 0.8,
      size = 1.2,
      position = ggplot2::position_jitter(width = 0.15, height = 0)
    ) +
    ggplot2::scale_color_manual(values = c(Pass = "#28a745", Fail = "#9e9e9e")) +
    ggplot2::theme_minimal(base_family = "Arial") +
    ggplot2::theme(legend.position = "none", axis.title.x = ggplot2::element_blank()) +
    ggplot2::labs(title = metric_name, y = "Value")
  if (is.finite(thresh_min)) p <- p + ggplot2::geom_hline(yintercept = thresh_min, linetype = "dashed", color = "#4a9ae7")
  if (is.finite(thresh_max)) p <- p + ggplot2::geom_hline(yintercept = thresh_max, linetype = "dashed", color = "#4a9ae7")
  p
}

core_atac_qc_plot_scatter <- function(md, th) {
  ms <- core_atac_qc_mask(md, th)
  x <- ms$count_atac
  y <- ms$feature_atac
  ok <- is.finite(x) & is.finite(y)
  if (!any(ok)) return(ggplot2::ggplot() + ggplot2::theme_void())
  df <- data.frame(x = x[ok], y = y[ok], keep = ms$keep[ok], stringsAsFactors = FALSE)
  ggplot2::ggplot(df, ggplot2::aes(x = x, y = y, color = keep)) +
    ggplot2::geom_point() +
    ggplot2::theme_minimal(base_family = "Arial")
}
