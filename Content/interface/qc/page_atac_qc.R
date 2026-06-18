# QC UI contract reference:
# docs/agents/qc/QC_UI_CONTRACT.md
# ATAC QC must follow RNA QC shared UI/plot conventions except ATAC-specific controls.
# Lock-step rule: any UI/style/plot change here must trigger explicit sync decision for page_qc.R.

UI_TEXT <- list(
  t_btn_apply_filters_add_workspace = "Apply filters & add to workspace",
  t_btn_update_thresholds_all_samples = "Update thresholds to all samples",
  t_text_adjust_per_sample_atac_thresholds_left = "Adjust per-sample ATAC thresholds in the left panel, then apply filtering.",
  t_text_no_atac_enabled_objects_available_yet = "No ATAC-enabled objects available yet -> Import multiome samples and add to page first.",
  t_text_no_atac_samples_available_qc_plots = "No ATAC samples available for QC plots -> Add files from the right sidebar first.",
  t_text_no_atac_samples_loaded = "No ATAC samples loaded.",
  t_text_no_plottable_atac_qc_metrics_found = "No plottable ATAC QC metrics found in current object.",
  t_title_atac_qc_parameters = "ATAC QC Parameters",
  t_title_atac_qc_viewer = "ATAC QC Viewer",
  t_title_per_sample_thresholds = "Per-sample thresholds",
  t_title_qc_atac_qc_beta = "QC: ATAC QC",
  t_text_tune_atac_qc_thresholds_then_apply_create_filtered = "Tune ATAC QC thresholds and apply to create filtered objects in workspace.",
  t_label_min_atac_counts = "Min ATAC counts",
  t_label_max_atac_counts = "Max ATAC counts",
  t_label_min_tss_enrichment = "Min TSS enrichment",
  t_label_max_nucleosome_signal = "Max nucleosome signal",
  t_label_min_frip = "Min FRiP",
  t_label_max_frip = "Max FRiP"

)

library(DT)
library(shiny)
library(shinyjs)
library(plotly)
library(bslib)
library(shinycssloaders)
library(shinybusy)

`%||%` <- function(a,b) if (is.null(a)) b else a

atac_qc_ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "qc.css"),
    tags$script(HTML("\n      (function () {\n        document.addEventListener('click', function(e){\n          var hdr = e.target.closest('.atac-collapse-header');\n          if(!hdr) return;\n          document.querySelectorAll('#atac-collapse-list .atac-collapse-header')\n            .forEach(function(x){ x.classList.remove('is-selected'); });\n          hdr.classList.add('is-selected');\n          var s = hdr.getAttribute('data-sample');\n          if(window.Shiny && s){\n            Shiny.setInputValue('atac_qc_toggle_sample', s, {priority:'event'});\n          }\n        }, false);\n      })();\n    "))
  ),
  div(
    class = "app-page plotting-page qc-lock-left-float",
    div(
      class = "page-header",
      h2(
        icon("bar-chart"), " ", UI_TEXT$t_title_qc_atac_qc_beta, " ",
        tags$span("beta", class = "beta-badge"),
        wl_seurat5_badge()
      ),
      p(UI_TEXT$t_text_adjust_per_sample_atac_thresholds_left)
    ),
    card_page_card(
      title = UI_TEXT$t_title_atac_qc_parameters,
      uiOutput("atac_qc_parameter_table_box"),
      class = "qc-parameter-card"
    ),
    hr(),
    h3(UI_TEXT$t_title_atac_qc_viewer),
    sidebarLayout(
      sidebarPanel(
        width = 3,
        class = "qc-sidebar-panel plotting-left-panel",
        div(
          class = "qc-sticky",
          h4(class = "qc-panel-title", UI_TEXT$t_title_per_sample_thresholds),
          helpText(UI_TEXT$t_text_tune_atac_qc_thresholds_then_apply_create_filtered),
          br(),
          div(class = "qc-accordion", uiOutput("atac_qc_sidebar_accordion")),
          br(),
          actionButton("atac_apply_all_samples_btn", UI_TEXT$t_btn_update_thresholds_all_samples, class = "btn btn-default btn-block", icon = icon("clone")),
          div(style = "height:6px"),
          actionButton("atac_qc_apply_btn", UI_TEXT$t_btn_apply_filters_add_workspace, class = "btn btn-primary btn-block", icon = icon("filter"))
        )
      ),
      mainPanel(
        width = 9,
        class = "plot_area_card_style",
        uiOutput("atac_qc_plot_area_ui")
      )
    )
  )
)

atac_qc_server <- function(input, output, session, shared_data) {
  .safe_select_cols <- function(df, cols, default = NA) {
    if (is.null(df) || !is.data.frame(df)) return(data.frame(stringsAsFactors = FALSE))
    out <- df
    n <- nrow(out)
    for (cc in cols) {
      if (!(cc %in% colnames(out))) out[[cc]] <- rep(default, n)
    }
    out[, cols, drop = FALSE]
  }
  .get_entry_obj <- function(entry) {
    if (is.null(entry)) return(NULL)
    if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
  }
  .diag_block <- function(title, lines, type = "warning") {
    cls <- switch(type, info = "alert alert-info", error = "alert alert-danger", "alert alert-warning")
    div(
      class = cls,
      style = "margin-top:8px;",
      tags$b(title),
      tags$ul(lapply(lines, function(x) tags$li(as.character(x))))
    )
  }
  .obj_diag_lines <- function(sample_name, obj) {
    assay_names <- tryCatch(names(obj@assays), error = function(e) character(0))
    md_cols <- tryCatch(colnames(obj@meta.data), error = function(e) character(0))
    c(
      sprintf("sample: %s", sample_name %||% "NA"),
      sprintf("assays: %s", if (length(assay_names)) paste(assay_names, collapse = ", ") else "none"),
      sprintf("metadata rows: %s", tryCatch(nrow(obj@meta.data), error = function(e) "NA")),
      sprintf("metadata columns: %s", if (length(md_cols)) paste(utils::head(md_cols, 30), collapse = ", ") else "none")
    )
  }

  .has_atac <- function(obj) {
    assay_names <- tryCatch(names(obj@assays), error = function(e) character(0))
    if (!length(assay_names)) return(FALSE)
    low <- tolower(assay_names)
    if (any(grepl("(^|_|-)atac($|_|-)|peaks?|chromatin", low, perl = TRUE))) return(TRUE)
    assay_classes <- unlist(lapply(assay_names, function(an) {
      tolower(paste(tryCatch(class(obj[[an]]), error = function(e) character(0)), collapse = " "))
    }), use.names = FALSE)
    any(grepl("chromatinassay|atac", assay_classes, perl = TRUE))
  }

  .atac_table_from_registry <- function() {
    tryCatch({
      reg <- shared_data$all_seurat_objects %||% list()
      if (!length(reg)) return(NULL)
      sheet <- shared_data$full_sample_sheet

      rows <- lapply(names(reg), function(nm) {
        obj <- .get_entry_obj(reg[[nm]])
        if (is.null(obj) || !inherits(obj, "Seurat") || !.has_atac(obj)) return(NULL)
        md <- obj@meta.data
        th <- core_atac_qc_infer_thresholds(md)

        cond <- "Unknown"
        bat <- "Batch1"
        if (is.data.frame(sheet) && nrow(sheet) && "name" %in% names(sheet)) {
          i <- match(nm, as.character(sheet$name))
          if (!is.na(i)) {
            if ("condition" %in% names(sheet)) cond <- as.character(sheet$condition[[i]] %||% cond)
            if ("batch" %in% names(sheet)) bat <- as.character(sheet$batch[[i]] %||% bat)
          }
        }

        data.frame(
          name = as.character(nm),
          condition = cond,
          batch = bat,
          min_count_atac = th$min_count_atac,
          max_count_atac = th$max_count_atac,
          min_tss = th$min_tss,
          max_nucleosome = th$max_nucleosome,
          min_frip = th$min_frip,
          max_frip = th$max_frip,
          use_in_analysis = TRUE,
          qc_status = "Pending",
          excluded_from_final = FALSE,
          stringsAsFactors = FALSE
        )
      })

      out <- do.call(rbind, Filter(Negate(is.null), rows))
      if (is.null(out) || !nrow(out)) return(NULL)
      out
    }, error = function(e) {
      atac_diag_msg(sprintf("ATAC table build failed: %s", conditionMessage(e)))
      NULL
    })
  }

  active_name <- reactiveVal(NULL)
  atac_table_data <- reactiveVal(NULL)
  threshold_cache <- reactiveVal(list())
  atac_diag_msg <- reactiveVal(NULL)
  atac_metric_compute_state <- reactiveVal(list(tab_seen = FALSE, object_stamp = ""))

  .ensure_atac_table_cols <- function(df) {
    if (is.null(df) || !is.data.frame(df)) return(data.frame(stringsAsFactors = FALSE))
    n <- nrow(df)
    add_col <- function(nm, value) {
      if (nm %in% colnames(df)) return(invisible(NULL))
      vv <- value
      if (length(vv) == 1) vv <- rep(vv, n)
      df[[nm]] <<- vv
      invisible(NULL)
    }
    add_col("name", "")
    add_col("condition", "Unknown")
    add_col("batch", "Batch1")
    add_col("min_count_atac", 0)
    add_col("max_count_atac", 50000)
    add_col("min_tss", 1)
    add_col("max_nucleosome", 2)
    add_col("min_frip", 10)
    add_col("max_frip", 100)
    add_col("use_in_analysis", TRUE)
    add_col("qc_status", "Pending")
    add_col("excluded_from_final", FALSE)
    df$use_in_analysis <- as.logical(df$use_in_analysis %||% TRUE)
    df$use_in_analysis[is.na(df$use_in_analysis)] <- TRUE
    df$excluded_from_final <- as.logical(df$excluded_from_final %||% FALSE)
    df$excluded_from_final[is.na(df$excluded_from_final)] <- FALSE
    df
  }

  .save_thresholds <- function(sample_name, th) {
    cache <- threshold_cache(); cache[[sample_name]] <- th; threshold_cache(cache)
  }

  .thresholds_from_row <- function(row) {
    .num <- function(x, d) {
      y <- suppressWarnings(as.numeric(x))
      if (!length(y) || !is.finite(y[[1]])) return(d)
      y[[1]]
    }
    list(
      min_count_atac = .num(row$min_count_atac, 0),
      max_count_atac = .num(row$max_count_atac, 50000),
      min_tss = .num(row$min_tss, 1),
      max_nucleosome = .num(row$max_nucleosome, 2),
      min_frip = .num(row$min_frip, 10),
      max_frip = .num(row$max_frip, 100)
    )
  }

  .get_thresholds <- function(sample_name) {
    cache <- threshold_cache()
    if (!is.null(cache[[sample_name]])) return(cache[[sample_name]])
    df <- isolate(atac_table_data())
    if (is.data.frame(df) && nrow(df)) {
      i <- match(sample_name, as.character(df$name))
      if (!is.na(i)) return(.thresholds_from_row(df[i, , drop = FALSE]))
    }
    list(min_count_atac = 0, max_count_atac = 50000, min_tss = 1, max_nucleosome = 2, min_frip = 10, max_frip = 100)
  }

  .build_atac_violin_with_dots <- function(
    vec, label,
    dots = c("right","normal","none"),
    normal_width = 0.04,
    violin_scale = c("count","density"),
    vln_ticks = c("auto","count","total","none"),
    panel_gutter = 0.01,
    seam = c("classic","seamless"),
    nbins = 80, smooth = TRUE,
    dot_panel_w = 0.20, box_panel_w = 0.10, vln_panel_w = 0.28,
    mask = NULL,
    th   = NULL
  ){
    dots         <- match.arg(dots)
    violin_scale <- match.arg(violin_scale)
    vln_ticks    <- match.arg(vln_ticks)
    seam         <- match.arg(seam)
    p_left <- NULL; p_box <- plotly::plot_ly(); p_vln <- plotly::plot_ly()

    y <- as.numeric(vec); y <- y[is.finite(y)]
    if (!length(y)) return(NULL)
    N <- length(y)
    kept <- if (!is.null(mask) && length(mask) == length(vec)) mask[is.finite(vec)] else rep(FALSE, length(y))
    y_kept <- y[kept]

    dot_half_width <- 0.14
    dot_size <- 3; dot_alpha <- 0.55
    box_width <- 0.12
    u <- sort(unique(y)); step <- stats::median(diff(u))
    if (!is.finite(step)) step <- diff(range(y))/1000
    eps <- as.numeric(step)*0.15
    yj  <- if (eps > 0) y + stats::runif(length(y), -eps, eps) else y

    x_axis_no_ticks <- function(xrng = NULL, show_grid = TRUE){
      rng <- NULL
      if (!is.null(xrng)) {
        xs <- xrng[is.finite(xrng)]
        if (length(xs) >= 2) {
          lo <- min(xs); hi <- max(xs)
          if (is.finite(lo) && is.finite(hi) && hi > lo) rng <- c(lo, hi)
        }
      }
      ax <- list(type="linear",ticks="",showticklabels=FALSE,showgrid=isTRUE(show_grid),zeroline=FALSE,showline=TRUE,linecolor="rgba(0,0,0,0.35)",linewidth=1)
      if (!is.null(rng)) ax$range <- rng
      ax
    }
    y_axis_left <- list(title=label, automargin=TRUE, tickformat=",d",ticks="outside", showticklabels=TRUE,showgrid=TRUE, gridcolor="rgba(0,0,0,0.06)",zeroline=FALSE, showline=TRUE,linecolor="rgba(0,0,0,0.45)", linewidth=1)
    y_axis_overlay <- list(overlaying="y", showticklabels=FALSE,showgrid=FALSE, showline=TRUE)

    x_rng <- NULL
    if (dots == "normal") {
      hw <- max(0.01, as.numeric(normal_width))
      x_off <- stats::runif(length(yj), -hw, hw)
      x_rng <- c(-hw - 0.03, hw)
      p_left <- plotly::plot_ly()
      idx_f <- which(!kept); idx_k <- which(kept)
      if (length(idx_f)) p_left <- p_left |> plotly::add_trace(type = "scattergl", mode = "markers", x = x_off[idx_f], y = yj[idx_f], marker = list(size=dot_size, color="rgba(150,150,150,0.35)"), hoverinfo = "skip", showlegend = FALSE)
      if (length(idx_k)) p_left <- p_left |> plotly::add_trace(type = "scattergl", mode = "markers", x = x_off[idx_k], y = yj[idx_k], marker = list(size=dot_size, color="rgba(36,160,72,0.95)", opacity=0.9), hoverinfo = "skip", showlegend = FALSE)
      p_left <- p_left |> plotly::layout(xaxis = x_axis_no_ticks(x_rng, show_grid = (seam=="classic")), yaxis = y_axis_left, margin = list(l=64, r=0, t=4, b=28))
    }

    p_box <- plotly::plot_ly() |> plotly::add_boxplot(y = y, boxpoints = FALSE, width = box_width, line = list(width = 1, color = "rgba(255,140,0,1)"), fillcolor = "rgba(255,140,0,0.15)", whiskerwidth = 0.6, name = "", hoverinfo = "skip", showlegend = FALSE) |> plotly::layout(xaxis = x_axis_no_ticks(NULL, show_grid = (seam == "classic")), yaxis = y_axis_overlay, margin = list(l = 0, r = 0, t = 4, b = 28))

    add_cut_lines <- function(plt, x_range) {
      if (is.null(th)) return(plt)
      y_lines <- numeric(0)
      if (identical(label, "nCount_ATAC")) {
        if (!is.null(th$min_count_atac)) y_lines <- c(y_lines, as.numeric(th$min_count_atac))
        if (!is.null(th$max_count_atac)) y_lines <- c(y_lines, as.numeric(th$max_count_atac))
      }
      if (identical(label, "TSS.enrichment")) {
        if (!is.null(th$min_tss)) y_lines <- c(y_lines, as.numeric(th$min_tss))
      }
      if (identical(label, "nucleosome_signal")) {
        if (!is.null(th$max_nucleosome)) y_lines <- c(y_lines, as.numeric(th$max_nucleosome))
      }
      if (identical(label, "pct_reads_in_peaks (FRiP)")) {
        if (!is.null(th$min_frip)) y_lines <- c(y_lines, as.numeric(th$min_frip))
        if (!is.null(th$max_frip)) y_lines <- c(y_lines, as.numeric(th$max_frip))
      }
      for (y0 in y_lines) {
        plt <- plt |> plotly::add_trace(x = x_range, y = c(y0, y0), type="scatter", mode="lines", line = list(color="rgba(80,80,80,0.8)", dash="dash", width=1), hoverinfo="skip", showlegend=FALSE, inherit=FALSE)
      }
      plt
    }

    if (violin_scale == "count") {
      rng <- range(y, na.rm = TRUE)
      if (!is.finite(rng[1]) || !is.finite(rng[2]) || rng[1] == rng[2]) {
        e <- if (is.finite(rng[1])) (abs(rng[1]) * 1e-6 + 1e-6) else 1e-6
        rng[2] <- rng[1] + e
      }
      brks <- seq(rng[1], rng[2], length.out = nbins + 1)
      mids <- (brks[-1] + brks[-length(brks)]) / 2
      cnt  <- as.numeric(table(cut(y, brks, include.lowest = TRUE)))
      if (smooth && length(cnt) > 2) { cnt <- as.numeric(stats::filter(cnt, rep(1,3)/3, sides=2)); cnt[is.na(cnt)] <- 0 }
      max_cnt <- max(cnt, na.rm=TRUE); if (max_cnt < 1) max_cnt <- 1
      tv <- pretty(c(0, max_cnt), 4); tt <- format(tv, big.mark=",")
      ax_v <- list(type="linear", showgrid=TRUE, tickmode="array", tickvals=tv, ticktext=tt, zeroline=FALSE, showline=TRUE, linecolor="rgba(0,0,0,0.35)", linewidth=1)
      p_vln <- plotly::plot_ly() |> plotly::add_trace(x = cnt, y = mids, type="scatter", mode="lines", fill="tozerox", line=list(color="rgba(44,98,160,0.95)", width=1), fillcolor="rgba(44,98,160,0.30)", customdata = round(cnt), hovertemplate="y: %{y:.0f}<br>count: %{customdata}<extra></extra>", showlegend=FALSE)
      if (length(y_kept)) {
        cnt_k <- as.numeric(table(cut(y_kept, brks, include.lowest = TRUE)))
        if (smooth && length(cnt_k) > 2) { cnt_k <- as.numeric(stats::filter(cnt_k, rep(1,3)/3, sides=2)); cnt_k[is.na(cnt_k)] <- 0 }
        p_vln <- p_vln |> plotly::add_trace(x = cnt_k, y = mids, type="scatter", mode="lines", fill="tozerox", line=list(color="rgba(36,160,72,1)", width=1), fillcolor="rgba(36,160,72,0.35)", hoverinfo="skip", showlegend=FALSE, inherit=FALSE)
      }
      p_vln <- p_vln |> plotly::layout(xaxis=ax_v, yaxis=y_axis_overlay, margin=list(l=0, r=0, t=4, b=28)) |> add_cut_lines(x_range = c(0, max_cnt))
    } else {
      p_vln <- plotly::plot_ly() |> plotly::add_trace(x = rep(0, N), y = y, type = "violin", side = "positive", points = "false", line = list(color="rgba(44,98,160,0.95)", width=1), fillcolor = "rgba(44,98,160,0.30)", scalemode="width", meanline = list(visible=FALSE), width=0.5, showlegend=FALSE)
      if (length(y_kept)) {
        p_vln <- p_vln |> plotly::add_trace(x = rep(0, length(y_kept)), y = y_kept, type = "violin", side = "positive", points = "false", line = list(color="rgba(36,160,72,1)", width=1), fillcolor = "rgba(36,160,72,0.35)", scalemode="width", meanline = list(visible=FALSE), width=0.5, showlegend=FALSE, inherit=FALSE)
      }
      p_vln <- p_vln |> plotly::layout(xaxis=list(type="linear", showgrid=TRUE, zeroline=FALSE, showline=TRUE, linecolor="rgba(0,0,0,0.35)", linewidth=1), yaxis=y_axis_overlay, margin=list(l=0, r=0, t=4, b=28))
    }

    out <- if (is.null(p_left)) {
      plotly::subplot(p_box, p_vln, nrows=1, shareY=TRUE, widths=c(box_panel_w, vln_panel_w), margin = if (seam=="seamless") 0 else panel_gutter)
    } else {
      plotly::subplot(p_left, p_box, p_vln, nrows=1, shareY=TRUE, widths=c(dot_panel_w, box_panel_w, vln_panel_w), margin = if (seam=="seamless") 0 else panel_gutter)
    }
    out |> plotly::layout(yaxis = y_axis_left, hovermode = "closest") |> plotly::config(displaylogo = FALSE)
  }

  .build_atac_scatter_plotly <- function(md, th) {
    ms <- core_atac_qc_mask(md, th)
    x <- suppressWarnings(as.numeric(ms$count_atac))
    y <- suppressWarnings(as.numeric(ms$feature_atac))
    keep <- as.logical(ms$keep %||% FALSE)
    if (length(keep) != length(x)) keep <- rep(FALSE, length(x))
    keep[is.na(keep)] <- FALSE
    ok <- is.finite(x) & is.finite(y)
    if (!any(ok)) {
      return(plotly::plot_ly() |>
        plotly::layout(
          xaxis = list(visible = FALSE),
          yaxis = list(visible = FALSE),
          annotations = list(list(text = "No nCount_ATAC / nFeature_ATAC for scatter.", x = 0.5, y = 0.5, showarrow = FALSE))
        ))
    }

    x <- x[ok]
    y <- y[ok]
    keep <- keep[ok]
    idx_drop <- which(!keep)
    idx_keep <- which(keep)
    n_all <- length(x)
    n_keep <- sum(keep, na.rm = TRUE)
    r_all <- if (n_all >= 3) suppressWarnings(stats::cor(x, y, method = "pearson")) else NA_real_
    r_keep <- if (n_keep >= 3) suppressWarnings(stats::cor(x[keep], y[keep], method = "pearson")) else NA_real_
    r_all_txt <- if (is.finite(r_all)) sprintf("Unfiltered Pearson r = %.3f", r_all) else "Unfiltered Pearson r = NA"
    r_keep_txt <- if (is.finite(r_keep)) sprintf("Filtered Pearson r = %.3f", r_keep) else "Filtered Pearson r = NA"
    n_keep_txt <- sprintf("Filtered cells: %s / %s", format(n_keep, big.mark = ","), format(n_all, big.mark = ","))

    xr <- range(x, na.rm = TRUE)
    yr <- range(y, na.rm = TRUE)
    xw <- diff(xr); if (!is.finite(xw) || xw <= 0) xw <- 1
    yw <- diff(yr); if (!is.finite(yw) || yw <= 0) yw <- 1
    xr <- c(xr[[1]] - 0.02 * xw, xr[[2]] + 0.02 * xw)
    yr <- c(yr[[1]] - 0.04 * yw, yr[[2]] + 0.10 * yw)

    shapes <- Filter(Negate(is.null), list(
      if (is.finite(as.numeric(th$min_count_atac))) list(type = "line", x0 = as.numeric(th$min_count_atac), x1 = as.numeric(th$min_count_atac), y0 = yr[[1]], y1 = yr[[2]], line = list(dash = "dash", width = 1, color = "#888")) else NULL,
      if (is.finite(as.numeric(th$max_count_atac))) list(type = "line", x0 = as.numeric(th$max_count_atac), x1 = as.numeric(th$max_count_atac), y0 = yr[[1]], y1 = yr[[2]], line = list(dash = "dash", width = 1, color = "#888")) else NULL
    ))
    ann <- list(
      list(x = 0.98, y = 0.28, xref = "paper", yref = "paper", xanchor = "right", yanchor = "bottom", text = r_all_txt, showarrow = FALSE, font = list(size = 13, color = "rgba(120,120,120,0.95)")),
      list(x = 0.98, y = 0.23, xref = "paper", yref = "paper", xanchor = "right", yanchor = "bottom", text = r_keep_txt, showarrow = FALSE, font = list(size = 13, color = "rgba(36,160,72,1)")),
      list(x = 0.98, y = 0.18, xref = "paper", yref = "paper", xanchor = "right", yanchor = "bottom", text = n_keep_txt, showarrow = FALSE, font = list(size = 13, color = "rgba(36,160,72,1)"))
    )

    p <- plotly::plot_ly(type = "scattergl", mode = "markers")
    if (length(idx_drop)) {
      p <- p |> plotly::add_trace(x = x[idx_drop], y = y[idx_drop], marker = list(size = 4, color = "rgba(150,150,150,0.35)"), hoverinfo = "skip", showlegend = FALSE)
    }
    if (length(idx_keep)) {
      p <- p |> plotly::add_trace(x = x[idx_keep], y = y[idx_keep], marker = list(size = 4, color = "rgba(36,160,72,0.95)", opacity = 0.9), hoverinfo = "skip", showlegend = FALSE)
    }

    p |>
      plotly::layout(
        xaxis = list(title = list(text = "nCount_ATAC", standoff = 12), range = xr, automargin = TRUE),
        yaxis = list(title = list(text = "nFeature_ATAC", standoff = 10), range = yr, automargin = TRUE),
        shapes = shapes,
        annotations = ann,
        margin = list(l = 84, r = 40, t = 30, b = 88)
      ) |>
      plotly::config(displaylogo = FALSE)
  }

  observe({
    tryCatch({
      df <- .atac_table_from_registry()
      df <- .ensure_atac_table_cols(df)
      atac_table_data(df)
      if (is.null(df) || !nrow(df)) {
        active_name(NULL)
        threshold_cache(list())
        return()
      }
      cache <- threshold_cache()
      for (i in seq_len(nrow(df))) {
        nm <- as.character(df$name[[i]])
        if (is.null(cache[[nm]])) cache[[nm]] <- .thresholds_from_row(df[i, , drop = FALSE])
      }
      threshold_cache(cache)
      if (is.null(active_name()) || !active_name() %in% df$name) active_name(df$name[[1]])
      atac_diag_msg(NULL)
    }, error = function(e) {
      atac_diag_msg(sprintf("ATAC observer failed: %s", conditionMessage(e)))
      atac_table_data(NULL)
      active_name(NULL)
      threshold_cache(list())
    })
  })

  output$atac_qc_parameter_table_box <- renderUI({
    tryCatch({
      diag_msg <- atac_diag_msg()
      if (!is.null(diag_msg) && nzchar(diag_msg)) {
        return(.diag_block("ATAC QC setup failed.", c(diag_msg), type = "error"))
      }
      df <- atac_table_data()
      if (is.null(df) || !nrow(df)) {
        return(div(class = "alert alert-info", UI_TEXT$t_text_no_atac_enabled_objects_available_yet))
      }
      tagList(
        DTOutput("atac_qc_parameter_table"),
        div(
          style = "display:flex; gap:8px; justify-content:flex-end; margin-top:10px;",
          actionButton(
            "atac_qc_exclude_selected_btn",
            "Exclude selected",
            class = "btn btn-xs btn-outline-danger",
            icon = icon("ban")
          ),
          actionButton(
            "atac_qc_include_selected_btn",
            "Include selected",
            class = "btn btn-xs btn-outline-success",
            icon = icon("plus")
          )
        )
      )
    }, error = function(e) {
      .diag_block("ATAC QC table panel failed.", c(conditionMessage(e)), type = "error")
    })
  })

  output$atac_qc_parameter_table <- renderDT({
    df <- .ensure_atac_table_cols(atac_table_data()); req(df)
    d2 <- .safe_select_cols(df, c("name", "condition", "batch", "min_count_atac", "max_count_atac", "min_tss", "max_nucleosome", "min_frip", "max_frip", "use_in_analysis", "qc_status"))
    d2$use_in_analysis <- ifelse(isTRUE(d2$use_in_analysis), "Included", "Excluded")
    datatable(
      d2,
      editable = list(target = "cell", disable = list(columns = c(0,1,2,9,10))),
      selection = "multiple",
      class = "compact stripe hover",
      escape = FALSE,
      options = list(dom = 't', pageLength = nrow(d2), scrollX = TRUE, autoWidth = FALSE),
      colnames = c("Name", "Condition", "Batch", "Min ATAC", "Max ATAC", "Min TSS", "Max Nucleosome", "Min FRiP", "Max FRiP", "Included", "Status"),
      rownames = FALSE
    )
  }, server = FALSE)

  .set_selected_rows_excluded <- function(selected_rows, excluded_flag) {
    df <- .ensure_atac_table_cols(isolate(atac_table_data()))
    if (is.null(df) || !nrow(df)) return(invisible(FALSE))
    rows <- unique(as.integer(selected_rows))
    rows <- rows[is.finite(rows) & rows >= 1 & rows <= nrow(df)]
    if (!length(rows)) return(invisible(FALSE))
    df$excluded_from_final[rows] <- isTRUE(excluded_flag)
    df$use_in_analysis[rows] <- !isTRUE(excluded_flag)
    df$qc_status[rows] <- if (isTRUE(excluded_flag)) "Excluded" else "Pending"
    atac_table_data(df)
    invisible(TRUE)
  }

  observeEvent(input$atac_qc_exclude_selected_btn, {
    .set_selected_rows_excluded(input$atac_qc_parameter_table_rows_selected, excluded_flag = TRUE)
  }, ignoreInit = TRUE)

  observeEvent(input$atac_qc_include_selected_btn, {
    .set_selected_rows_excluded(input$atac_qc_parameter_table_rows_selected, excluded_flag = FALSE)
  }, ignoreInit = TRUE)

  observeEvent(input$main_navbar, {
    if (!identical(input$main_navbar %||% "", "atac_qc_tab")) return(invisible(NULL))
    df <- .ensure_atac_table_cols(isolate(atac_table_data()))
    if (is.null(df) || !nrow(df)) return(invisible(NULL))
    reg <- isolate(shared_data$all_seurat_objects %||% list())
    stamp <- paste(sort(names(reg)), collapse = "|")
    st <- isolate(atac_metric_compute_state())
    if (isTRUE(st$tab_seen) && identical(st$object_stamp %||% "", stamp)) return(invisible(NULL))

    overlay_show("Checking ATAC QC metrics and computing missing metadata...")
    on.exit(overlay_hide(), add = TRUE)

    changed_n <- 0L
    failed <- character(0)
    for (i in seq_len(nrow(df))) {
      nm <- as.character(df$name[[i]])
      obj <- .get_entry_obj(reg[[nm]])
      if (is.null(obj) || !inherits(obj, "Seurat")) next
      md_before <- tryCatch(obj@meta.data, error = function(e) NULL)
      miss_before <- if (!is.null(md_before) && nrow(md_before)) tryCatch(core_atac_qc_missing_metrics(md_before), error = function(e) character(0)) else character(0)
      if (!length(miss_before)) next
      filled <- tryCatch(core_atac_qc_autofill_metrics(obj, assay = "ATAC"), error = function(e) list(object = obj, changed = FALSE, diagnostics = conditionMessage(e), missing_after = miss_before))
      obj2 <- filled$object
      miss_after <- filled$missing_after %||% miss_before
      if (inherits(obj2, "Seurat")) {
        if (is.list(reg[[nm]]) && !is.null(reg[[nm]]$obj)) {
          reg[[nm]]$obj <- obj2
        } else {
          reg[[nm]] <- obj2
        }
      }
      if (isTRUE(filled$changed)) changed_n <- changed_n + 1L
      if (length(miss_after)) {
        failed <- c(failed, sprintf("%s: %s", nm, paste(miss_after, collapse = ", ")))
      }
    }
    shared_data$all_seurat_objects <- reg
    atac_table_data(.ensure_atac_table_cols(.atac_table_from_registry()))
    atac_metric_compute_state(list(tab_seen = TRUE, object_stamp = stamp))

    if (changed_n > 0) {
      showNotification(sprintf("Computed missing ATAC QC metadata for %d object(s).", changed_n), type = "message")
    }
    if (length(failed)) {
      showNotification(sprintf("ATAC QC metadata still missing for %d object(s). See diagnostics banner.", length(failed)), type = "warning", duration = 8)
      atac_diag_msg(paste(unique(failed), collapse = " | "))
    } else {
      atac_diag_msg(NULL)
    }
    invisible(NULL)
  }, ignoreInit = TRUE)

  output$atac_qc_sidebar_accordion <- renderUI({
    df <- atac_table_data()
    if (is.null(df)) return(div(class="text-muted small", UI_TEXT$t_text_no_atac_samples_loaded))
    if (!nrow(df)) return(div(class="text-muted small", UI_TEXT$t_text_no_atac_samples_loaded))
    cur <- active_name() %||% df$name[[1]]
    .safe_id <- function(x) gsub("[^A-Za-z0-9_]+", "_", x)

    panels <- lapply(seq_len(nrow(df)), function(i) {
      row <- df[i, , drop = FALSE]
      nm <- as.character(row$name[[1]])
      sid <- .safe_id(nm)
      is_open <- identical(nm, cur)
      md <- tryCatch({
        obj <- .get_entry_obj((shared_data$all_seurat_objects %||% list())[[nm]])
        if (is.null(obj)) NULL else obj@meta.data
      }, error = function(e) NULL)
      dth <- if (!is.null(md) && nrow(md)) core_atac_qc_infer_thresholds(md) else .thresholds_from_row(row)
      th <- .get_thresholds(nm)
      .rng <- function(x, dmin, dmax) {
        if (is.null(x) || length(x) < 2) return(c(dmin, dmax))
        a <- suppressWarnings(as.numeric(x[[1]]))
        b <- suppressWarnings(as.numeric(x[[2]]))
        if (!is.finite(a) || !is.finite(b)) return(c(dmin, dmax))
        if (a == b) b <- a + 1
        if (a > b) {
          tmp <- a; a <- b; b <- tmp
        }
        c(a, b)
      }
      .val <- function(v, r, d) {
        x <- suppressWarnings(as.numeric(v))
        if (!is.finite(x)) x <- d
        x <- min(max(x, r[[1]]), r[[2]])
        x
      }
      r_cnt <- .rng(dth$range_count_atac, 0, 50000)
      r_tss <- .rng(dth$range_tss, 0, 15)
      r_nuc <- .rng(dth$range_nucleosome, 0, 3)
      r_frp <- .rng(dth$range_frip, 0, 100)
      v_min_cnt <- .val(th$min_count_atac, r_cnt, r_cnt[[1]])
      v_max_cnt <- .val(th$max_count_atac, r_cnt, r_cnt[[2]])
      if (v_min_cnt > v_max_cnt) { tmp <- v_min_cnt; v_min_cnt <- v_max_cnt; v_max_cnt <- tmp }
      v_min_tss <- .val(th$min_tss, r_tss, r_tss[[1]])
      v_max_nuc <- .val(th$max_nucleosome, r_nuc, r_nuc[[2]])
      v_min_frp <- .val(th$min_frip, r_frp, r_frp[[1]])
      v_max_frp <- .val(th$max_frip, r_frp, r_frp[[2]])
      if (v_min_frp > v_max_frp) { tmp <- v_min_frp; v_min_frp <- v_max_frp; v_max_frp <- tmp }

      div(
        class = "qc-collapse-item",
        tags$a(
          class = "atac-collapse-header qc-collapse-header",
          `data-toggle` = "collapse", `data-bs-toggle` = "collapse",
          href = paste0("#atac_sec_", sid), role = "button",
          `aria-expanded` = if (is_open) "true" else "false",
          `aria-controls` = paste0("atac_sec_", sid),
          `data-sample` = nm,
          tags$span(class = "sample-title-text", nm)
        ),
        div(
          id = paste0("atac_sec_", sid),
          class = paste("collapse", if (is_open) "show"),
          `data-parent` = "#atac-collapse-list", `data-bs-parent` = "#atac-collapse-list",
          sliderInput(paste0("atac_", sid, "_min_count"), UI_TEXT$t_label_min_atac_counts, min = r_cnt[[1]], max = r_cnt[[2]], value = v_min_cnt, step = 1),
          sliderInput(paste0("atac_", sid, "_max_count"), UI_TEXT$t_label_max_atac_counts, min = r_cnt[[1]], max = r_cnt[[2]], value = v_max_cnt, step = 1),
          sliderInput(paste0("atac_", sid, "_min_tss"), UI_TEXT$t_label_min_tss_enrichment, min = r_tss[[1]], max = r_tss[[2]], value = v_min_tss, step = 0.01),
          sliderInput(paste0("atac_", sid, "_max_nuc"), UI_TEXT$t_label_max_nucleosome_signal, min = r_nuc[[1]], max = r_nuc[[2]], value = v_max_nuc, step = 0.01),
          sliderInput(paste0("atac_", sid, "_min_frip"), UI_TEXT$t_label_min_frip, min = r_frp[[1]], max = r_frp[[2]], value = v_min_frp, step = 0.01),
          sliderInput(paste0("atac_", sid, "_max_frip"), UI_TEXT$t_label_max_frip, min = r_frp[[1]], max = r_frp[[2]], value = v_max_frp, step = 0.01)
        )
      )
    })

    div(id = "atac-collapse-list", class = "qc-collapse", panels)
  })

  observeEvent(input$atac_qc_toggle_sample, {
    req(input$atac_qc_toggle_sample)
    active_name(input$atac_qc_toggle_sample)
  }, ignoreInit = TRUE)

  read_thresholds <- function(sample_name) {
    sid <- gsub("[^A-Za-z0-9_]+", "_", sample_name)
    old <- .get_thresholds(sample_name)
    th <- list(
      min_count_atac = input[[paste0("atac_", sid, "_min_count")]] %||% old$min_count_atac,
      max_count_atac = input[[paste0("atac_", sid, "_max_count")]] %||% old$max_count_atac,
      min_tss = input[[paste0("atac_", sid, "_min_tss")]] %||% old$min_tss,
      max_nucleosome = input[[paste0("atac_", sid, "_max_nuc")]] %||% old$max_nucleosome,
      min_frip = input[[paste0("atac_", sid, "_min_frip")]] %||% old$min_frip,
      max_frip = input[[paste0("atac_", sid, "_max_frip")]] %||% old$max_frip
    )
    .save_thresholds(sample_name, th)
    th
  }

  output$atac_qc_plot_area_ui <- renderUI({
    tryCatch({
      df <- atac_table_data()
      if (is.null(df) || !nrow(df)) {
        return(div(class = "alert alert-info", style = "margin-top:8px;", UI_TEXT$t_text_no_atac_samples_available_qc_plots))
      }
      nm <- active_name() %||% df$name[[1]]
      obj <- .get_entry_obj((shared_data$all_seurat_objects %||% list())[[nm]])
      if (is.null(obj) || !inherits(obj, "Seurat")) {
        return(.diag_block(
          "ATAC QC data issue: selected entry is not a valid Seurat object.",
          c(sprintf("sample: %s", nm %||% "NA"))
        ))
      }
      md <- tryCatch(obj@meta.data, error = function(e) NULL)
      if (is.null(md) || !nrow(md)) {
        return(.diag_block(
          "ATAC QC not ready: selected object has no usable metadata for QC plotting.",
          .obj_diag_lines(nm, obj)
        ))
      }
      miss <- character(0)
      missing_msg <- NULL
      miss <- tryCatch(core_atac_qc_missing_metrics(md), error = function(e) character(0))
      if (length(miss)) {
        missing_msg <- div(
          class = "alert alert-info",
          style = "margin-top:8px; margin-bottom:10px;",
          HTML(sprintf(
            "<b>Missing ATAC QC metrics:</b> %s.<br/>Current filtering will use available metrics only. For full ATAC QC, add Signac-derived metadata (e.g., TSS.enrichment, nucleosome_signal, FRiP).",
            paste(miss, collapse = ", ")
          ))
        )
      }

      miss_keys <- c(
        "nCount_ATAC" = "count_atac",
        "nucleosome_signal" = "nuc",
        "pct_reads_in_peaks (FRiP)" = "frip",
        "TSS.enrichment" = "tss"
      )
      all_keys <- c("count_atac", "nuc", "frip", "tss")
      drop_keys <- unname(miss_keys[intersect(names(miss_keys), miss %||% character(0))])
      available <- setdiff(all_keys, drop_keys)

      metric_tiles <- list()
      if ("count_atac" %in% available) metric_tiles <- c(metric_tiles, list(div(class = "qc-vln", qc_with_busy_spinner(plotlyOutput("atac_qc_metric_count_plot", height = "330px", width = "100%")))))
      if ("nuc" %in% available) metric_tiles <- c(metric_tiles, list(div(class = "qc-vln", qc_with_busy_spinner(plotlyOutput("atac_qc_metric_nuc_plot", height = "330px", width = "100%")))))
      if ("frip" %in% available) metric_tiles <- c(metric_tiles, list(div(class = "qc-vln", qc_with_busy_spinner(plotlyOutput("atac_qc_metric_frip_plot", height = "330px", width = "100%")))))
      if ("tss" %in% available) metric_tiles <- c(metric_tiles, list(div(class = "qc-vln", qc_with_busy_spinner(plotlyOutput("atac_qc_metric_tss_plot", height = "330px", width = "100%")))))

      metric_grid <- if (length(metric_tiles)) {
        div(
          class = paste("qc-violins atac-qc-violins", c("one","two","three","four")[min(length(metric_tiles), 4)]),
          metric_tiles
        )
      } else {
        div(class = "alert alert-warning", UI_TEXT$t_text_no_plottable_atac_qc_metrics_found)
      }
      tagList(
        missing_msg,
        fluidRow(
          column(
            12,
            metric_grid
          )
        ),
        hr(),
        fluidRow(
          column(
            12,
            div(
              class = "atac-qc-scatter",
              qc_with_busy_spinner(plotlyOutput("atac_qc_scatter_plot", height = "620px", width = "100%"))
            )
          )
        )
      )
    }, error = function(e) {
      .diag_block(
        "ATAC QC render failed.",
        c(
          sprintf("error: %s", conditionMessage(e)),
          sprintf("active tab: %s", input$main_navbar %||% "NA")
        ),
        type = "error"
      )
    })
  })

  output$atac_qc_metric_count_plot <- renderPlotly({
    req(identical(input$main_navbar %||% "", "atac_qc_tab"))
    df <- atac_table_data(); req(df, nrow(df) > 0)
    nm <- active_name() %||% df$name[[1]]
    obj <- .get_entry_obj((shared_data$all_seurat_objects %||% list())[[nm]])
    req(!is.null(obj))
    th <- read_thresholds(nm)
    ms <- core_atac_qc_mask(obj@meta.data, th)
    .build_atac_violin_with_dots(ms$count_atac, "nCount_ATAC", dots = "normal", violin_scale = "count", vln_ticks = "auto", seam = "classic", mask = ms$keep, th = th)
  })

  output$atac_qc_metric_nuc_plot <- renderPlotly({
    req(identical(input$main_navbar %||% "", "atac_qc_tab"))
    df <- atac_table_data(); req(df, nrow(df) > 0)
    nm <- active_name() %||% df$name[[1]]
    obj <- .get_entry_obj((shared_data$all_seurat_objects %||% list())[[nm]])
    req(!is.null(obj))
    th <- read_thresholds(nm)
    ms <- core_atac_qc_mask(obj@meta.data, th)
    .build_atac_violin_with_dots(ms$nuc, "nucleosome_signal", dots = "normal", violin_scale = "count", vln_ticks = "auto", seam = "classic", mask = ms$keep, th = th)
  })

  output$atac_qc_metric_frip_plot <- renderPlotly({
    req(identical(input$main_navbar %||% "", "atac_qc_tab"))
    df <- atac_table_data(); req(df, nrow(df) > 0)
    nm <- active_name() %||% df$name[[1]]
    obj <- .get_entry_obj((shared_data$all_seurat_objects %||% list())[[nm]])
    req(!is.null(obj))
    th <- read_thresholds(nm)
    ms <- core_atac_qc_mask(obj@meta.data, th)
    .build_atac_violin_with_dots(ms$frip, "pct_reads_in_peaks (FRiP)", dots = "normal", violin_scale = "count", vln_ticks = "auto", seam = "classic", mask = ms$keep, th = th)
  })

  output$atac_qc_metric_tss_plot <- renderPlotly({
    req(identical(input$main_navbar %||% "", "atac_qc_tab"))
    df <- atac_table_data(); req(df, nrow(df) > 0)
    nm <- active_name() %||% df$name[[1]]
    obj <- .get_entry_obj((shared_data$all_seurat_objects %||% list())[[nm]])
    req(!is.null(obj))
    th <- read_thresholds(nm)
    ms <- core_atac_qc_mask(obj@meta.data, th)
    .build_atac_violin_with_dots(ms$tss, "TSS.enrichment", dots = "normal", violin_scale = "count", vln_ticks = "auto", seam = "classic", mask = ms$keep, th = th)
  })

  output$atac_qc_scatter_plot <- renderPlotly({
    req(identical(input$main_navbar %||% "", "atac_qc_tab"))
    df <- atac_table_data(); req(df, nrow(df) > 0)
    nm <- active_name() %||% df$name[[1]]
    obj <- .get_entry_obj((shared_data$all_seurat_objects %||% list())[[nm]])
    req(!is.null(obj))
    th <- read_thresholds(nm)
    .build_atac_scatter_plotly(obj@meta.data, th)
  })

  observeEvent(input$atac_apply_all_samples_btn, {
    df <- .ensure_atac_table_cols(atac_table_data()); req(df, nrow(df) > 0)
    nm <- active_name() %||% df$name[[1]]
    th <- read_thresholds(nm)

    cache <- threshold_cache()
    for (i in which(!as.logical(df$excluded_from_final %||% FALSE))) {
      df$min_count_atac[i] <- th$min_count_atac
      df$max_count_atac[i] <- th$max_count_atac
      df$min_tss[i] <- th$min_tss
      df$max_nucleosome[i] <- th$max_nucleosome
      df$min_frip[i] <- th$min_frip
      df$max_frip[i] <- th$max_frip
      cache[[as.character(df$name[i])]] <- th
    }
    threshold_cache(cache)
    atac_table_data(df)
    showNotification("Current sample thresholds applied to all ATAC samples.", type = "message")
  })

  observeEvent(input$atac_qc_apply_btn, {
    df <- .ensure_atac_table_cols(atac_table_data()); req(df, nrow(df) > 0)
    overlay_show("Applying ATAC QC filters and adding filtered samples to workspace…")
    on.exit(overlay_hide(), add = TRUE)

    reg <- shared_data$all_seurat_objects %||% list()
    applied <- character(0)
    skipped <- character(0)
    include_idx <- which(!as.logical(df$excluded_from_final %||% FALSE))
    if (!length(include_idx)) {
      showNotification("No included ATAC samples selected for filtering.", type = "warning")
      return(invisible(NULL))
    }

    for (i in include_idx) {
      nm <- as.character(df$name[[i]])
      obj <- .get_entry_obj(reg[[nm]])
      if (is.null(obj)) { skipped <- c(skipped, nm); next }

      th <- read_thresholds(nm)
      sobj_filtered <- tryCatch(core_atac_qc_apply(obj, th), error = function(e) NULL)
      if (is.null(sobj_filtered) || !inherits(sobj_filtered, "Seurat") || ncol(sobj_filtered) == 0) {
        skipped <- c(skipped, nm)
        next
      }

      filt_name <- paste0(nm, "_atacqc_filtered")
      reg[[filt_name]] <- list(
        obj = sobj_filtered,
        prefs = list(),
        plots = list(),
        analysis_cache = list(),
        meta = list(stage = "filtered", parent = nm, parents = nm, params = th, created = Sys.time())
      )
      shared_data$filtered_objects[[filt_name]] <- sobj_filtered
      df$qc_status[i] <- "Filtered"
      applied <- c(applied, nm)
    }

    shared_data$all_seurat_objects <- reg
    atac_table_data(df)

    if (length(applied)) {
      shared_data$active_object_name <- paste0(applied[[1]], "_atacqc_filtered")
      showNotification(sprintf("ATAC QC done: %d filtered object(s) added to workspace.", length(applied)), type = "message")
    }
    if (length(skipped)) {
      showNotification(sprintf("Skipped %d sample(s): empty output or missing object.", length(skipped)), type = "warning", duration = 8)
    }
  })
}
