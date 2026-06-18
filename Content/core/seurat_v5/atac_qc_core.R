# atac_qc_core.R
# Seurat v5 ATAC QC helpers (app-safe + standalone-callable functions).

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

core_atac_qc_missing_metrics <- function(md) {
  keys <- c("count_atac", "feature_atac", "tss", "nuc", "frip")
  labs <- c(
    count_atac = "nCount_ATAC",
    feature_atac = "nFeature_ATAC",
    tss = "TSS.enrichment",
    nuc = "nucleosome_signal",
    frip = "pct_reads_in_peaks (FRiP)"
  )
  missing <- c()
  for (k in keys) {
    v <- core_atac_qc_get_metric(md, k)
    if (!any(is.finite(v))) missing <- c(missing, labs[[k]])
  }
  missing
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

core_atac_qc_autofill_metrics <- function(sobj, assay = "ATAC") {
  out <- list(
    object = sobj,
    changed = FALSE,
    diagnostics = character(0),
    missing_before = character(0),
    missing_after = character(0)
  )
  if (is.null(sobj) || !inherits(sobj, "Seurat")) {
    out$diagnostics <- c(out$diagnostics, "Input is not a Seurat object.")
    return(out)
  }

  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !nrow(md)) {
    out$diagnostics <- c(out$diagnostics, "Object metadata is empty.")
    return(out)
  }
  out$missing_before <- tryCatch(core_atac_qc_missing_metrics(md), error = function(e) character(0))
  if (!length(out$missing_before)) {
    out$missing_after <- character(0)
    return(out)
  }

  if (!requireNamespace("Signac", quietly = TRUE)) {
    out$diagnostics <- c(out$diagnostics, "Signac is not available.")
    out$missing_after <- out$missing_before
    return(out)
  }

  assay_names <- tryCatch(names(sobj@assays), error = function(e) character(0))
  if (!length(assay_names)) {
    out$diagnostics <- c(out$diagnostics, "No assays found in object.")
    out$missing_after <- out$missing_before
    return(out)
  }
  assay_use <- if (assay %in% assay_names) assay else assay_names[[1]]
  old_assay <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) assay_use)
  sobj <- tryCatch({ Seurat::DefaultAssay(sobj) <- assay_use; sobj }, error = function(e) sobj)
  on.exit({
    try(Seurat::DefaultAssay(sobj) <- old_assay, silent = TRUE)
  }, add = TRUE)

  .has_metric <- function(x, key) {
    vals <- tryCatch(core_atac_qc_get_metric(x, key), error = function(e) rep(NA_real_, nrow(x)))
    any(is.finite(vals))
  }

  if ("TSS.enrichment" %in% out$missing_before) {
    sobj <- tryCatch(
      Signac::TSSEnrichment(sobj, assay = assay_use, fast = TRUE, verbose = FALSE),
      error = function(e) {
        out$diagnostics <<- c(out$diagnostics, sprintf("TSS enrichment failed: %s", conditionMessage(e)))
        sobj
      }
    )
  }
  if ("nucleosome_signal" %in% out$missing_before) {
    sobj <- tryCatch(
      Signac::NucleosomeSignal(sobj, assay = assay_use, verbose = FALSE),
      error = function(e) {
        out$diagnostics <<- c(out$diagnostics, sprintf("Nucleosome signal failed: %s", conditionMessage(e)))
        sobj
      }
    )
  }
  md_after <- tryCatch(sobj@meta.data, error = function(e) md)
  if ("pct_reads_in_peaks (FRiP)" %in% out$missing_before && !.has_metric(md_after, "frip")) {
    if (all(c("peak_region_fragments", "passed_filters") %in% colnames(md_after))) {
      num <- suppressWarnings(as.numeric(md_after$peak_region_fragments))
      den <- suppressWarnings(as.numeric(md_after$passed_filters))
      frip <- rep(NA_real_, nrow(md_after))
      ok <- is.finite(num) & is.finite(den) & den > 0
      frip[ok] <- (num[ok] / den[ok]) * 100
      md_after$pct_reads_in_peaks <- frip
      sobj@meta.data <- md_after
    } else {
      out$diagnostics <- c(out$diagnostics, "FRiP unavailable: missing passed_filters/peak_region_fragments.")
    }
  }

  md_final <- tryCatch(sobj@meta.data, error = function(e) md_after)
  out$missing_after <- tryCatch(core_atac_qc_missing_metrics(md_final), error = function(e) out$missing_before)
  out$changed <- length(out$missing_after) < length(out$missing_before)
  out$object <- sobj
  out
}

core_atac_qc_plot_metric <- function(md, th, sample_name = "sample") {
  ms <- core_atac_qc_mask(md, th)
  status <- ifelse(ms$keep, "Pass", "Fail")

  mk_df <- function(vals, metric, min_v = NULL, max_v = NULL) {
    ok <- is.finite(vals)
    if (!any(ok)) {
      return(data.frame(
        sample = character(0),
        metric = character(0),
        value = numeric(0),
        status = character(0),
        min_v = numeric(0),
        max_v = numeric(0),
        stringsAsFactors = FALSE
      ))
    }
    data.frame(
      sample = sample_name,
      metric = metric,
      value = vals[ok],
      status = status[ok],
      min_v = min_v %||% NA_real_,
      max_v = max_v %||% NA_real_,
      stringsAsFactors = FALSE
    )
  }

  dd <- rbind(
    mk_df(ms$count_atac, "nCount_ATAC", th$min_count_atac, th$max_count_atac),
    mk_df(ms$tss, "TSS.enrichment", th$min_tss, NA_real_),
    mk_df(ms$nuc, "nucleosome_signal", NA_real_, th$max_nucleosome),
    mk_df(ms$frip, "pct_reads_in_peaks", th$min_frip, th$max_frip)
  )

  if (!nrow(dd)) {
    return(ggplot2::ggplot() + ggplot2::annotate("text", x = 0.5, y = 0.5, label = "No plottable ATAC metrics.") + ggplot2::theme_void())
  }

  ggplot2::ggplot(dd, ggplot2::aes(x = sample, y = value)) +
    ggplot2::geom_violin(fill = "#55b255", color = "#666666", alpha = 0.8, width = 0.85, trim = TRUE) +
    ggplot2::geom_point(ggplot2::aes(color = status), alpha = 0.7, size = 0.8, position = ggplot2::position_jitter(width = 0.16, height = 0)) +
    ggplot2::scale_color_manual(values = c(Pass = "#2faa43", Fail = "#9e9e9e")) +
    ggplot2::facet_wrap(~metric, scales = "free_y", ncol = 4) +
    ggplot2::theme_minimal(base_family = "Arial") +
    ggplot2::theme(legend.position = "none", strip.text = ggplot2::element_text(face = "bold", size = 12)) +
    ggplot2::labs(x = NULL, y = "Value")
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
  if (!any(ok)) {
    return(
      ggplot2::ggplot(data.frame(x = 1, y = 1), ggplot2::aes(x, y)) +
        ggplot2::annotate("text", x = 1, y = 1.05, label = metric_name, fontface = "bold", size = 6) +
        ggplot2::annotate("text", x = 1, y = 0.95, label = "Metric unavailable in metadata", color = "#7a7a7a", size = 4.6) +
        ggplot2::xlim(0.5, 1.5) +
        ggplot2::ylim(0.8, 1.2) +
        ggplot2::theme_void() +
        ggplot2::theme(plot.margin = ggplot2::margin(10, 12, 10, 12))
    )
  }

  .group_col <- function(md) {
    prefs <- c("condition", "Condition", "orig.ident", "sample", "Sample", "batch", "Batch")
    hit <- prefs[prefs %in% colnames(md)]
    if (!length(hit)) return(rep(sample_name, nrow(md)))
    as.character(md[[hit[[1]]]])
  }

  g <- .group_col(md)[ok]
  g[is.na(g) | !nzchar(g)] <- sample_name
  keep <- ms$keep[ok]
  df <- data.frame(
    group = factor(g, levels = unique(g)),
    value = vals[ok],
    status = ifelse(keep, "Pass", "Fail"),
    stringsAsFactors = FALSE
  )
  y_rng <- range(df$value, na.rm = TRUE)
  y_span <- max(1e-9, diff(y_rng))
  many_groups <- length(unique(df$group)) > 3

  p <- ggplot2::ggplot(df, ggplot2::aes(x = group, y = value)) +
    ggplot2::geom_violin(fill = "#58b857", color = "#6d6d6d", alpha = 0.9, width = 0.85, trim = TRUE) +
    ggplot2::geom_point(
      ggplot2::aes(color = status),
      alpha = 0.8,
      size = 1.3,
      position = ggplot2::position_jitter(width = 0.15, height = 0)
    ) +
    ggplot2::scale_color_manual(values = c(Pass = "#28a745", Fail = "#9e9e9e")) +
    ggplot2::theme_minimal(base_family = "Arial") +
    ggplot2::theme(
      legend.position = "none",
      panel.grid.minor = ggplot2::element_line(color = "#ededed"),
      panel.grid.major = ggplot2::element_line(color = "#dddddd"),
      axis.title.x = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(angle = if (many_groups) 45 else 0, hjust = if (many_groups) 1 else 0.5),
      plot.title = ggplot2::element_text(face = "bold", size = 12)
    ) +
    ggplot2::labs(title = metric_name, y = "Value")

  if (is.finite(thresh_min)) {
    p <- p +
      ggplot2::geom_hline(yintercept = thresh_min, linetype = "dashed", color = "#4a9ae7", linewidth = 0.7) +
      ggplot2::annotate(
        "text",
        x = 1,
        y = thresh_min + 0.02 * y_span,
        label = sprintf("min = %s", signif(thresh_min, 4)),
        color = "#2f6ba3",
        hjust = 0,
        size = 4.2
      )
  }
  if (is.finite(thresh_max)) {
    p <- p +
      ggplot2::geom_hline(yintercept = thresh_max, linetype = "dashed", color = "#4a9ae7", linewidth = 0.7) +
      ggplot2::annotate(
        "text",
        x = 1,
        y = thresh_max + 0.02 * y_span,
        label = sprintf("max = %s", signif(thresh_max, 4)),
        color = "#2f6ba3",
        hjust = 0,
        size = 4.2
      )
  }
  p
}

core_atac_qc_plot_scatter <- function(md, th) {
  ms <- core_atac_qc_mask(md, th)
  x <- ms$count_atac
  y <- ms$feature_atac
  ok <- is.finite(x) & is.finite(y)
  if (!any(ok)) {
    return(ggplot2::ggplot() + ggplot2::annotate("text", x = 0.5, y = 0.5, label = "No nCount_ATAC / nFeature_ATAC for scatter.") + ggplot2::theme_void())
  }

  df <- data.frame(x = x[ok], y = y[ok], keep = ms$keep[ok], stringsAsFactors = FALSE)
  r_all <- suppressWarnings(stats::cor(df$x, df$y, method = "pearson"))
  r_pass <- suppressWarnings(stats::cor(df$x[df$keep], df$y[df$keep], method = "pearson"))
  n_all <- nrow(df)
  n_pass <- sum(df$keep, na.rm = TRUE)

  xr <- range(df$x, na.rm = TRUE)
  yr <- range(df$y, na.rm = TRUE)
  x_ann <- xr[[2]] - 0.02 * diff(xr)
  y_ann1 <- yr[[1]] + 0.10 * diff(yr)
  y_ann2 <- yr[[1]] + 0.04 * diff(yr)

  ggplot2::ggplot(df, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(data = df[!df$keep, , drop = FALSE], color = "#bdbdbd", alpha = 0.7, size = 0.9) +
    ggplot2::geom_point(data = df[df$keep, , drop = FALSE], color = "#2faa43", alpha = 0.8, size = 1.0) +
    ggplot2::geom_vline(xintercept = as.numeric(th$min_count_atac), linetype = "dashed", color = "#6da9e4") +
    ggplot2::geom_vline(xintercept = as.numeric(th$max_count_atac), linetype = "dashed", color = "#6da9e4") +
    ggplot2::annotate("text", x = x_ann, y = y_ann1, hjust = 1, color = "#777777", size = 4.6,
      label = sprintf("Unfiltered Pearson r = %.3f", ifelse(is.finite(r_all), r_all, NA_real_))) +
    ggplot2::annotate("text", x = x_ann, y = y_ann2, hjust = 1, color = "#2faa43", size = 4.6,
      label = sprintf("Filtered Pearson r = %.3f", ifelse(is.finite(r_pass), r_pass, NA_real_))) +
    ggplot2::annotate("text", x = x_ann, y = yr[[1]] + 0.01 * diff(yr), hjust = 1, color = "#2faa43", size = 4.6,
      label = sprintf("Filtered cells: %s / %s", format(n_pass, big.mark = ","), format(n_all, big.mark = ","))) +
    ggplot2::theme_minimal(base_family = "Arial") +
    ggplot2::labs(x = "nCount_ATAC", y = "nFeature_ATAC")
}
