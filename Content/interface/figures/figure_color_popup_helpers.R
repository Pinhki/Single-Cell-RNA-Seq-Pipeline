.figure_coalesce <- function(a, b) if (!is.null(a)) a else b
.figure_default_picker_hex <- "#3B82F6"
.figure_default_picker_palette <- c("#1D4ED8", "#3B82F6", "#60A5FA", "#93C5FD", "#BFDBFE", "#DBEAFE")
FIGURE_BUSY_SPINNER_COLOR <- "#5F6368"

.figure_get_assay_data <- function(sobj, assay = NULL, layer = "data") {
  aa <- as.character(.figure_coalesce(assay, ""))
  if (!nzchar(aa)) aa <- tryCatch(as.character(Seurat::DefaultAssay(sobj)), error = function(e) "")
  ga_formals <- tryCatch(names(formals(Seurat::GetAssayData)), error = function(e) character(0))
  use_layer <- "layer" %in% ga_formals
  args <- if (isTRUE(use_layer)) {
    list(object = sobj, layer = layer)
  } else {
    list(object = sobj, slot = layer)
  }
  if (nzchar(aa)) args$assay <- aa
  out <- tryCatch(do.call(Seurat::GetAssayData, args), error = function(e) NULL)
  if (!is.null(out)) return(out)
  alt_args <- list(object = sobj)
  alt_args[[if (isTRUE(use_layer)) "slot" else "layer"]] <- layer
  if (nzchar(aa)) alt_args$assay <- aa
  tryCatch(do.call(Seurat::GetAssayData, alt_args), error = function(e) NULL)
}

.figure_safe_upper <- function(x, fallback = character(0)) {
  out <- tryCatch(as.character(.figure_coalesce(x, fallback)), error = function(e) as.character(fallback))
  out <- out[!is.na(out)]
  if (!length(out)) return(character(0))
  out <- tryCatch(toupper(out), error = function(e) as.character(fallback))
  out[!is.na(out)]
}

FIGURE_SHARED_SETTINGS_UI_TEXT <- list(
  t_choice_apply_color_fill = "Fill (shapes 21-25)",
  t_choice_apply_color_line = "Color (all shapes)",
  t_choice_theme_bw = "Black & White",
  t_choice_theme_classic = "Classic",
  t_choice_theme_cowplot = "Cowplot",
  t_choice_theme_minimal = "Minimal",
  t_choice_theme_umap_arrows = "UMAP Arrows",
  t_label_apply_color_to = "Apply Color To",
  t_label_axis_text_size = "Axis Text Size",
  t_label_axis_title_size = "Axis Title Size",
  t_label_border_width = "Border Width",
  t_label_legend_text_size = "Legend Text Size",
  t_label_plot_title_size = "Plot Title Size",
  t_label_point_shape = "Shape",
  t_label_point_size = "Point Size",
  t_label_theme = "Theme",
  t_label_transparency = "Transparency",
  t_label_x_axis = "X Label",
  t_label_y_axis = "Y Label",
  t_title_axes = "Shared Axis Labels",
  t_title_style = "Global Plot Style",
  t_title_text = "Text & Legend"
)

figure_safe_numeric <- function(x, fallback, min_value = -Inf, max_value = Inf) {
  num <- suppressWarnings(as.numeric(.figure_coalesce(x, fallback)))
  if (!is.finite(num)) num <- fallback
  max(min_value, min(max_value, num))
}

figure_safe_integer <- function(x, fallback, min_value = -Inf, max_value = Inf) {
  num <- suppressWarnings(as.integer(.figure_coalesce(x, fallback)))
  if (!is.finite(num)) num <- fallback
  as.integer(max(min_value, min(max_value, num)))
}

figure_shared_plot_settings_defaults <- function() {
  list(
    plot_theme = "Classic",
    point_size = 1,
    point_alpha = 1,
    point_shape = 19L,
    point_stroke = 0,
    color_map = "color",
    x_label = "UMAP_1",
    y_label = "UMAP_2",
    title_size = 16,
    axis_title_size = 14,
    axis_text_size = 10,
    legend_text_size = 10
  )
}

figure_shared_plot_settings <- function(session) {
  defaults <- figure_shared_plot_settings_defaults()
  user_data <- .figure_coalesce(session$userData, NULL)
  if (is.null(user_data)) stop("Session userData is unavailable for Figure Studio shared settings.")

  if (is.environment(user_data)) {
    if (!exists("figure_shared_plot_settings", envir = user_data, inherits = FALSE)) {
      assign(
        "figure_shared_plot_settings",
        lapply(defaults, shiny::reactiveVal),
        envir = user_data
      )
    }
    return(get("figure_shared_plot_settings", envir = user_data, inherits = FALSE))
  }

  if (is.list(user_data)) {
    if (is.null(user_data$figure_shared_plot_settings)) {
      user_data$figure_shared_plot_settings <- lapply(defaults, shiny::reactiveVal)
      session$userData <- user_data
    }
    return(user_data$figure_shared_plot_settings)
  }

  stop("Unsupported session userData container for Figure Studio shared settings.")
}

figure_shared_plot_settings_values <- function(settings, track_reactive = FALSE) {
  defaults <- figure_shared_plot_settings_defaults()
  setting_names <- names(defaults)
  out <- defaults
  resolve_value <- if (isTRUE(track_reactive)) {
    function(rv) rv()
  } else {
    function(rv) shiny::isolate(rv())
  }
  for (nm in setting_names) {
    rv <- settings[[nm]]
    if (is.function(rv)) out[[nm]] <- resolve_value(rv)
  }
  out
}

figure_shared_settings_input_ids <- function(prefix) {
  list(
    axis_text_size = paste0(prefix, "_axis_text_size"),
    axis_title_size = paste0(prefix, "_axis_title_size"),
    color_map = paste0(prefix, "_color_map"),
    legend_text_size = paste0(prefix, "_legend_text_size"),
    point_alpha = paste0(prefix, "_point_alpha"),
    point_shape = paste0(prefix, "_point_shape"),
    point_size = paste0(prefix, "_point_size"),
    point_stroke = paste0(prefix, "_point_stroke"),
    theme = paste0(prefix, "_theme"),
    title_size = paste0(prefix, "_title_size"),
    x_label = paste0(prefix, "_x_label"),
    y_label = paste0(prefix, "_y_label")
  )
}

figure_shared_settings_modal_body <- function(prefix, settings_values = NULL) {
  values <- utils::modifyList(
    figure_shared_plot_settings_defaults(),
    .figure_coalesce(settings_values, list())
  )
  ids <- figure_shared_settings_input_ids(prefix)

  shiny::tagList(
    shiny::h5(FIGURE_SHARED_SETTINGS_UI_TEXT$t_title_style),
    shiny::radioButtons(
      ids$theme,
      FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_theme,
      inline = TRUE,
      choices = c(
        FIGURE_SHARED_SETTINGS_UI_TEXT$t_choice_theme_umap_arrows,
        FIGURE_SHARED_SETTINGS_UI_TEXT$t_choice_theme_minimal,
        FIGURE_SHARED_SETTINGS_UI_TEXT$t_choice_theme_classic,
        FIGURE_SHARED_SETTINGS_UI_TEXT$t_choice_theme_bw,
        FIGURE_SHARED_SETTINGS_UI_TEXT$t_choice_theme_cowplot
      ),
      selected = values$plot_theme
    ),
    shiny::sliderInput(
      ids$point_size,
      FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_point_size,
      min = 0.1,
      max = 5,
      value = values$point_size,
      step = 0.1
    ),
    shiny::sliderInput(
      ids$point_alpha,
      FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_transparency,
      min = 0.1,
      max = 1,
      value = values$point_alpha,
      step = 0.05
    ),
    shiny::sliderInput(
      ids$point_shape,
      FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_point_shape,
      min = 0,
      max = 25,
      value = values$point_shape,
      step = 1
    ),
    shiny::sliderInput(
      ids$point_stroke,
      FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_border_width,
      min = 0,
      max = 3,
      value = values$point_stroke,
      step = 0.1
    ),
    shiny::radioButtons(
      ids$color_map,
      FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_apply_color_to,
      inline = TRUE,
      choices = stats::setNames(
        c("fill", "color"),
        c(
          FIGURE_SHARED_SETTINGS_UI_TEXT$t_choice_apply_color_fill,
          FIGURE_SHARED_SETTINGS_UI_TEXT$t_choice_apply_color_line
        )
      ),
      selected = values$color_map
    ),
    shiny::hr(),
    shiny::h5(FIGURE_SHARED_SETTINGS_UI_TEXT$t_title_axes),
    shiny::textInput(ids$x_label, FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_x_axis, value = values$x_label),
    shiny::textInput(ids$y_label, FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_y_axis, value = values$y_label),
    shiny::hr(),
    shiny::h5(FIGURE_SHARED_SETTINGS_UI_TEXT$t_title_text),
    shiny::sliderInput(
      ids$title_size,
      FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_plot_title_size,
      min = 8,
      max = 28,
      value = values$title_size,
      step = 1
    ),
    shiny::sliderInput(
      ids$axis_title_size,
      FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_axis_title_size,
      min = 8,
      max = 24,
      value = values$axis_title_size,
      step = 1
    ),
    shiny::sliderInput(
      ids$axis_text_size,
      FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_axis_text_size,
      min = 6,
      max = 20,
      value = values$axis_text_size,
      step = 1
    ),
    shiny::sliderInput(
      ids$legend_text_size,
      FIGURE_SHARED_SETTINGS_UI_TEXT$t_label_legend_text_size,
      min = 6,
      max = 20,
      value = values$legend_text_size,
      step = 1
    )
  )
}

figure_bind_shared_settings_inputs <- function(input, settings, prefix) {
  ids <- figure_shared_settings_input_ids(prefix)

  shiny::observeEvent(input[[ids$theme]], {
    settings$plot_theme(as.character(input[[ids$theme]] %||% "Classic"))
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$point_size]], {
    settings$point_size(figure_safe_numeric(input[[ids$point_size]], 1, min_value = 0.1, max_value = 5))
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$point_alpha]], {
    settings$point_alpha(figure_safe_numeric(input[[ids$point_alpha]], 1, min_value = 0.1, max_value = 1))
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$point_shape]], {
    settings$point_shape(figure_safe_integer(input[[ids$point_shape]], 19L, min_value = 0L, max_value = 25L))
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$point_stroke]], {
    settings$point_stroke(figure_safe_numeric(input[[ids$point_stroke]], 0, min_value = 0, max_value = 3))
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$color_map]], {
    color_map <- tolower(as.character(input[[ids$color_map]] %||% "color"))
    settings$color_map(if (identical(color_map, "fill")) "fill" else "color")
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$x_label]], {
    settings$x_label(as.character(input[[ids$x_label]] %||% "UMAP_1"))
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$y_label]], {
    settings$y_label(as.character(input[[ids$y_label]] %||% "UMAP_2"))
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$title_size]], {
    settings$title_size(figure_safe_numeric(input[[ids$title_size]], 16, min_value = 8, max_value = 28))
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$axis_title_size]], {
    settings$axis_title_size(figure_safe_numeric(input[[ids$axis_title_size]], 14, min_value = 8, max_value = 24))
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$axis_text_size]], {
    settings$axis_text_size(figure_safe_numeric(input[[ids$axis_text_size]], 10, min_value = 6, max_value = 20))
  }, ignoreInit = TRUE)

  shiny::observeEvent(input[[ids$legend_text_size]], {
    settings$legend_text_size(figure_safe_numeric(input[[ids$legend_text_size]], 10, min_value = 6, max_value = 20))
  }, ignoreInit = TRUE)

  invisible(ids)
}

figure_effective_label_size <- function(show_labels = FALSE, label_size = 0) {
  if (!isTRUE(show_labels)) return(0)
  figure_safe_numeric(label_size, 0, min_value = 0, max_value = 20)
}

figure_point_mapping <- function(point_shape = 19, point_stroke = 0, color_map = "color") {
  shape <- figure_safe_integer(point_shape, 19L, min_value = 0L, max_value = 25L)
  stroke <- figure_safe_numeric(point_stroke, 0, min_value = 0, max_value = 3)
  aes_name <- if (identical(tolower(as.character(.figure_coalesce(color_map, "color"))), "fill")) "fill" else "color"
  if (identical(aes_name, "fill") && !(shape %in% 21:25)) shape <- 21L
  list(
    aes_name = aes_name,
    color_map = aes_name,
    shape = shape,
    stroke = stroke,
    use_fill = identical(aes_name, "fill")
  )
}

.figure_theme_cowplot <- function() {
  ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      axis.line = ggplot2::element_line(color = "#111111", linewidth = 0.4)
    )
}

figure_panel_axis_range <- function(panel_param, axis = c("x", "y")) {
  axis <- match.arg(axis)
  direct_name <- paste0(axis, ".range")
  direct_val <- panel_param[[direct_name]]
  if (is.numeric(direct_val) && length(direct_val) == 2L && all(is.finite(direct_val))) {
    return(as.numeric(direct_val))
  }

  axis_obj <- panel_param[[axis]]
  if (!is.null(axis_obj)) {
    cont <- tryCatch(axis_obj$continuous_range, error = function(e) NULL)
    if (is.numeric(cont) && length(cont) == 2L && all(is.finite(cont))) {
      return(as.numeric(cont))
    }
    rng <- tryCatch(axis_obj$range$range, error = function(e) NULL)
    if (is.numeric(rng) && length(rng) == 2L && all(is.finite(rng))) {
      return(as.numeric(rng))
    }
  }

  c(0, 1)
}

figure_axis_arrow_layer_data <- function(plot_obj, x_label = "", y_label = "") {
  built <- ggplot2::ggplot_build(plot_obj)
  layout_df <- built$layout$layout
  panel_params <- built$layout$panel_params
  facet_cols <- intersect(c("split_value", "split_value_secondary"), colnames(layout_df))
  rows <- vector("list", nrow(layout_df))

  for (idx in seq_len(nrow(layout_df))) {
    row_meta <- layout_df[idx, facet_cols, drop = FALSE]
    panel <- panel_params[[idx]]
    xr <- figure_panel_axis_range(panel, "x")
    yr <- figure_panel_axis_range(panel, "y")
    dx <- diff(xr)
    dy <- diff(yr)
    ax_len_x <- dx * 0.18
    ax_len_y <- dy * 0.18
    x_offset <- dx * 0.04
    y_offset <- dy * 0.04

    rows[[idx]] <- cbind(
      row_meta,
      x = xr[[1]],
      xend = xr[[1]] + ax_len_x,
      y = yr[[1]],
      yend = yr[[1]] + ax_len_y,
      x_label_x = xr[[1]] + (ax_len_x / 2),
      x_label_y = yr[[1]] - y_offset,
      y_label_x = xr[[1]] - x_offset,
      y_label_y = yr[[1]] + (ax_len_y / 2),
      x_label = as.character(.figure_coalesce(x_label, "")),
      y_label = as.character(.figure_coalesce(y_label, "")),
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  }

  arrow_df <- do.call(rbind, rows)
  if (is.null(arrow_df) || !nrow(arrow_df)) {
    arrow_df <- data.frame(
      x = 0,
      xend = 0.2,
      y = 0,
      yend = 0.2,
      x_label_x = 0.1,
      x_label_y = -0.04,
      y_label_x = -0.04,
      y_label_y = 0.1,
      x_label = as.character(.figure_coalesce(x_label, "")),
      y_label = as.character(.figure_coalesce(y_label, "")),
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  }

  list(
    x_labels = arrow_df,
    x_segments = arrow_df[, c(facet_cols, "x", "xend", "y"), drop = FALSE],
    y_labels = arrow_df,
    y_segments = arrow_df[, c(facet_cols, "x", "y", "yend"), drop = FALSE]
  )
}

figure_apply_plot_theme <- function(plot_obj,
                                    theme_choice = "Classic",
                                    title = NULL,
                                    x_label = NULL,
                                    y_label = NULL,
                                    legend_position = "right",
                                    legend_text_size = 10,
                                    axis_text_size = 10,
                                    axis_title_size = 14,
                                    plot_title_size = 16) {
  theme_choice <- as.character(.figure_coalesce(theme_choice, "Classic"))
  base_theme <- switch(
    theme_choice,
    "Classic" = ggplot2::theme_classic(base_size = 12),
    "Black & White" = ggplot2::theme_bw(base_size = 12),
    "Cowplot" = .figure_theme_cowplot(),
    "UMAP Arrows" = .figure_theme_cowplot(),
    ggplot2::theme_minimal(base_size = 12)
  )

  legend_position <- tolower(as.character(.figure_coalesce(legend_position, "right")))
  if (!legend_position %in% c("top", "bottom", "right", "left", "none")) legend_position <- "right"
  legend_is_horizontal <- legend_position %in% c("top", "bottom")

  plot_obj <- plot_obj +
    base_theme +
    ggplot2::theme(
      legend.position = legend_position,
      legend.direction = if (isTRUE(legend_is_horizontal)) "horizontal" else "vertical",
      legend.box = if (isTRUE(legend_is_horizontal)) "horizontal" else "vertical",
      legend.text = ggplot2::element_text(size = legend_text_size),
      axis.title = ggplot2::element_text(size = axis_title_size),
      axis.text = ggplot2::element_text(size = axis_text_size),
      plot.title = ggplot2::element_text(size = plot_title_size, face = "bold"),
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(face = "bold")
    )

  if (!identical(theme_choice, "UMAP Arrows")) {
    return(plot_obj + ggplot2::labs(title = title %||% NULL, x = x_label, y = y_label))
  }

  arrow_df <- figure_axis_arrow_layer_data(plot_obj, x_label = x_label, y_label = y_label)
  arrow_label_size <- max(3, axis_title_size / 4)

  plot_obj +
    ggplot2::geom_segment(
      data = arrow_df$x_segments,
      mapping = ggplot2::aes(x = x, xend = xend, y = y, yend = y),
      inherit.aes = FALSE,
      arrow = grid::arrow(length = grid::unit(0.15, "cm")),
      color = "#111111",
      linewidth = 0.35
    ) +
    ggplot2::geom_segment(
      data = arrow_df$y_segments,
      mapping = ggplot2::aes(x = x, xend = x, y = y, yend = yend),
      inherit.aes = FALSE,
      arrow = grid::arrow(length = grid::unit(0.15, "cm")),
      color = "#111111",
      linewidth = 0.35
    ) +
    ggplot2::geom_text(
      data = arrow_df$x_labels,
      mapping = ggplot2::aes(x = x_label_x, y = x_label_y, label = x_label),
      inherit.aes = FALSE,
      color = "#111111",
      size = arrow_label_size
    ) +
    ggplot2::geom_text(
      data = arrow_df$y_labels,
      mapping = ggplot2::aes(x = y_label_x, y = y_label_y, label = y_label),
      inherit.aes = FALSE,
      color = "#111111",
      angle = 90,
      size = arrow_label_size
    ) +
    ggplot2::labs(title = title %||% NULL, x = NULL, y = NULL) +
    ggplot2::theme(
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank()
    )
}

figure_extract_seurat_object <- function(entry) {
  if (inherits(entry, "Seurat")) return(entry)
  if (is.list(entry) && !is.null(entry$obj) && inherits(entry$obj, "Seurat")) return(entry$obj)
  NULL
}

figure_entry_assay_names <- function(entry) {
  obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
  if (is.null(obj)) return(character(0))

  if (is.list(obj) && !is.null(obj$assays)) {
    raw_assays <- obj$assays
    assay_names <- if (is.list(raw_assays)) {
      named <- .figure_coalesce(names(raw_assays), character(0))
      named <- named[nzchar(named)]
      if (length(named)) named else unlist(raw_assays, use.names = FALSE)
    } else {
      raw_assays
    }
    assay_names <- as.character(.figure_coalesce(assay_names, character(0)))
    assay_names <- assay_names[!is.na(assay_names) & nzchar(assay_names)]
    if (length(assay_names)) return(unique(assay_names))
  }

  sobj <- figure_extract_seurat_object(entry)
  if (is.null(sobj)) return(character(0))

  assay_names <- tryCatch(Seurat::Assays(sobj), error = function(e) character(0))
  assay_names <- as.character(.figure_coalesce(assay_names, character(0)))
  assay_names[!is.na(assay_names) & nzchar(assay_names)]
}

figure_entry_reduction_names <- function(entry) {
  obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
  if (is.null(obj)) return(character(0))

  if (is.list(obj) && !is.null(obj$reductions)) {
    raw_reductions <- obj$reductions
    reduction_names <- if (is.list(raw_reductions)) {
      named <- .figure_coalesce(names(raw_reductions), character(0))
      named <- named[nzchar(named)]
      if (length(named)) named else unlist(raw_reductions, use.names = FALSE)
    } else {
      raw_reductions
    }
    reduction_names <- as.character(.figure_coalesce(reduction_names, character(0)))
    reduction_names <- reduction_names[!is.na(reduction_names) & nzchar(reduction_names)]
    if (length(reduction_names)) return(unique(tolower(reduction_names)))
  }

  sobj <- figure_extract_seurat_object(entry)
  if (is.null(sobj)) return(character(0))

  reduction_names <- tryCatch(names(.figure_coalesce(sobj@reductions, list())), error = function(e) character(0))
  reduction_names <- as.character(.figure_coalesce(reduction_names, character(0)))
  unique(tolower(reduction_names[!is.na(reduction_names) & nzchar(reduction_names)]))
}

figure_object_is_integrated <- function(name, entry) {
  assay_names <- tolower(figure_entry_assay_names(entry))
  stage_raw <- tryCatch(entry$meta$stage, error = function(e) NULL)
  stage_chr <- tolower(as.character(.figure_coalesce(stage_raw, "")))
  name_chr <- tolower(as.character(.figure_coalesce(name, "")))

  any(grepl("^integrated", assay_names)) ||
    identical(.figure_coalesce(stage_chr[[1]], ""), "integrated") ||
    startsWith(.figure_coalesce(name_chr[[1]], ""), "integrated")
}

figure_entry_supports_reductions <- function(entry, required_reductions = character(0)) {
  required <- tolower(as.character(.figure_coalesce(required_reductions, character(0))))
  required <- required[!is.na(required) & nzchar(required)]
  if (!length(required)) return(TRUE)

  available <- figure_entry_reduction_names(entry)
  if (!length(available)) return(FALSE)

  any(required %in% available)
}

figure_preferred_object_name <- function(registry,
                                         current_selection = "",
                                         active_name = "",
                                         required_reductions = character(0)) {
  registry <- .figure_coalesce(registry, list())
  registry_names <- names(registry)
  registry_names <- as.character(.figure_coalesce(registry_names, character(0)))
  registry_names <- registry_names[!is.na(registry_names) & nzchar(registry_names)]
  if (!length(registry_names)) return("")

  suitable_names <- registry_names[vapply(
    registry_names,
    function(nm) figure_entry_supports_reductions(registry[[nm]], required_reductions),
    logical(1)
  )]
  if (!length(suitable_names)) suitable_names <- registry_names

  current_chr <- as.character(.figure_coalesce(current_selection, ""))
  if (length(current_chr) && !is.na(current_chr[[1]]) && current_chr[[1]] %in% suitable_names) {
    return(current_chr[[1]])
  }

  active_chr <- as.character(.figure_coalesce(active_name, ""))
  active_chr <- if (length(active_chr) && !is.na(active_chr[[1]]) && active_chr[[1]] %in% suitable_names) active_chr[[1]] else ""

  preferred_loaded_name <- get0("analysis_preferred_loaded_object_name", mode = "function", inherits = TRUE, ifnotfound = NULL)
  if (is.function(preferred_loaded_name)) {
    preferred_name <- tryCatch(
      preferred_loaded_name(
        registry[suitable_names],
        focus_name = active_chr,
        imported_active_name = active_chr
      ),
      error = function(e) ""
    )
    if (length(preferred_name) == 1 && !is.na(preferred_name) && preferred_name %in% suitable_names) {
      return(as.character(preferred_name))
    }
  }

  integrated_names <- suitable_names[vapply(
    suitable_names,
    function(nm) figure_object_is_integrated(nm, registry[[nm]]),
    logical(1)
  )]
  if (length(integrated_names)) {
    if (nzchar(active_chr) && active_chr %in% integrated_names) return(active_chr)
    return(integrated_names[[1]])
  }

  if (nzchar(active_chr)) return(active_chr)

  suitable_names[[1]]
}

figure_select_input_signature <- function(choices, selected = "") {
  choice_vals <- as.character(.figure_coalesce(choices, character(0)))
  choice_vals <- choice_vals[!is.na(choice_vals) & nzchar(choice_vals)]
  selected_chr <- as.character(.figure_coalesce(selected, ""))
  selected_chr <- selected_chr[!is.na(selected_chr)]
  selected_one <- if (length(selected_chr)) selected_chr[[1]] else ""

  paste(c(choice_vals, "::selected", selected_one), collapse = "\r")
}

figure_select_input_needs_update <- function(last_signature, choices, selected = "") {
  !identical(
    as.character(.figure_coalesce(last_signature, "")),
    figure_select_input_signature(choices = choices, selected = selected)
  )
}

figure_split_choices <- function(meta,
                                 exclude = character(0),
                                 none_value = "__none__",
                                 none_label = "None") {
  cols <- colnames(.figure_coalesce(meta, data.frame()))
  cols <- cols[!is.na(cols) & nzchar(cols)]
  exclude <- as.character(.figure_coalesce(exclude, character(0)))
  exclude <- exclude[!is.na(exclude) & nzchar(exclude)]
  cols <- setdiff(cols, exclude)
  preferred <- c("condition", "orig.ident", "batch", "sample", "sample_name")
  keep <- unique(c(preferred[preferred %in% cols], cols))
  stats::setNames(c(none_value, keep), c(none_label, keep))
}

figure_normalize_split_value <- function(x) {
  vals <- as.character(.figure_coalesce(x, "__none__"))
  vals <- vals[!is.na(vals)]
  if (!length(vals) || identical(vals[[1]], "__none__") || !nzchar(vals[[1]])) return(NULL)
  vals[[1]]
}

figure_normalize_split_vars <- function(column_split = NULL, row_split = NULL) {
  column_split <- figure_normalize_split_value(column_split)
  row_split <- figure_normalize_split_value(row_split)
  if (!is.null(column_split) && !is.null(row_split) && identical(column_split, row_split)) row_split <- NULL
  list(column_split = column_split, row_split = row_split)
}

figure_facet_mode <- function(column_split = NULL, row_split = NULL) {
  split_vars <- figure_normalize_split_vars(column_split = column_split, row_split = row_split)
  if (!is.null(split_vars$column_split) && !is.null(split_vars$row_split)) return("grid")
  if (!is.null(split_vars$column_split)) return("column")
  if (!is.null(split_vars$row_split)) return("row")
  "none"
}

figure_sort_levels_natural <- function(v) {
  vals <- as.character(.figure_coalesce(v, character(0)))
  vals[is.na(vals) | !nzchar(vals)] <- "NA"
  uniq <- unique(vals)
  if (!length(uniq)) return(character(0))

  numeric_like <- grepl("^-?[0-9]+(?:\\.[0-9]+)?$", uniq)
  if (all(numeric_like)) {
    return(uniq[order(as.numeric(uniq))])
  }

  .natural_key <- function(x) {
    tokens <- regmatches(x, gregexpr("[0-9]+|[^0-9]+", x, perl = TRUE))
    vapply(tokens, function(parts) {
      if (!length(parts)) return("@")
      mapped <- vapply(parts, function(p) {
        if (grepl("^[0-9]+$", p)) {
          num <- suppressWarnings(as.numeric(p))
          if (!is.finite(num)) return(paste0("#", p))
          return(sprintf("#%020.0f", num))
        }
        paste0("@", tolower(p))
      }, character(1))
      paste(mapped, collapse = "")
    }, character(1))
  }

  nat_key <- .natural_key(uniq)
  if (length(nat_key) == length(uniq)) {
    return(uniq[order(nat_key, uniq)])
  }

  sort(uniq)
}

figure_sort_facet_levels <- function(v) {
  lv <- figure_sort_levels_natural(v)
  if (!length(lv)) return(lv)
  sfx <- suppressWarnings(as.numeric(sub("^.*?([0-9]+)$", "\\1", lv)))
  if (length(sfx) == length(lv) && all(is.finite(sfx))) {
    return(lv[order(sfx)])
  }
  lv
}

figure_zero_base_labels_if_needed <- function(values, column_name = NULL) {
  vals <- as.character(.figure_coalesce(values, character(0)))
  vals[is.na(vals) | !nzchar(vals)] <- "NA"
  if (!length(vals)) return(vals)
  nm <- tolower(as.character(.figure_coalesce(column_name, "")))
  is_cluster_like <- identical(nm, ".ident") || grepl("(cluster|snn_res\\.|leiden_res\\.|_res\\.)", nm)
  if (!is_cluster_like) return(vals)
  if (!all(grepl("^-?[0-9]+$", vals))) return(vals)
  nums <- suppressWarnings(as.integer(vals))
  if (!length(nums) || any(!is.finite(nums))) return(vals)
  if (min(nums, na.rm = TRUE) != 1L) return(vals)
  as.character(nums - 1L)
}

figure_safe_meta_col <- function(md, x) {
  if (is.null(md) || !is.data.frame(md)) return(NULL)
  nm <- as.character(.figure_coalesce(x, ""))
  nm <- nm[!is.na(nm) & nzchar(nm)]
  if (!length(nm) || identical(nm[[1]], "__none__")) return(NULL)
  if (!(nm[[1]] %in% colnames(md))) return(NULL)
  nm[[1]]
}

figure_smart_short_labels <- function(values, column_name = NULL, keep_prefix_tokens = 1L) {
  vals <- as.character(.figure_coalesce(values, character(0)))
  vals[is.na(vals) | !nzchar(vals)] <- "NA"
  uniq <- unique(vals)
  out <- uniq
  names(out) <- uniq
  if (!length(uniq) || !identical(as.character(.figure_coalesce(column_name, "")), "orig.ident") || length(uniq) < 2L) {
    return(out)
  }

  parts <- strsplit(uniq, "_", fixed = TRUE)
  min_len <- suppressWarnings(min(lengths(parts)))
  if (!is.finite(min_len) || min_len < 2L) return(out)

  prefix_len <- 0L
  while (prefix_len < min_len) {
    tok <- vapply(parts, function(p) p[[prefix_len + 1L]], character(1))
    if (length(unique(tok)) != 1L) break
    prefix_len <- prefix_len + 1L
  }

  suffix_len <- 0L
  while (suffix_len < (min_len - prefix_len)) {
    tok <- vapply(parts, function(p) p[[length(p) - suffix_len]], character(1))
    if (length(unique(tok)) != 1L) break
    suffix_len <- suffix_len + 1L
  }

  keep_prefix_tokens <- max(0L, as.integer(.figure_coalesce(keep_prefix_tokens, 1L)))
  start_idx <- max(1L, prefix_len - keep_prefix_tokens + 1L)

  short <- vapply(parts, function(p) {
    end_idx <- length(p) - suffix_len
    if (end_idx < start_idx) return(paste(p, collapse = "_"))
    paste(p[start_idx:end_idx], collapse = "_")
  }, character(1))

  dup <- duplicated(short) | duplicated(short, fromLast = TRUE)
  short[dup] <- uniq[dup]
  out <- short
  names(out) <- uniq
  out
}

figure_meta_columns_for_color <- function(meta) {
  cols <- colnames(.figure_coalesce(meta, data.frame()))
  cols <- cols[!is.na(cols) & nzchar(cols)]
  if (!length(cols)) return(character(0))

  priority <- cols[grepl("(seurat_clusters|cluster|celltype|cell_type|snn_res\\.|leiden_res\\.)", tolower(cols))]
  unique(c(priority, setdiff(cols, priority)))
}

figure_pick_selected_choice <- function(choices, preferred = NULL) {
  choices <- as.character(.figure_coalesce(choices, character(0)))
  choices <- choices[!is.na(choices) & nzchar(choices)]
  if (!length(choices)) return(NULL)

  preferred <- as.character(.figure_coalesce(preferred, character(0)))
  preferred <- preferred[!is.na(preferred) & nzchar(preferred)]
  if (length(preferred) && preferred[[1]] %in% choices) return(preferred[[1]])

  choices[[1]]
}

figure_color_levels_from_vector <- function(values, column_name = NULL) {
  if (is.factor(values)) {
    levels_chr <- as.character(levels(values))
    if (any(is.na(values) | !nzchar(as.character(values)))) {
      levels_chr <- unique(c(levels_chr, "NA"))
    }
    levels_chr <- figure_zero_base_labels_if_needed(levels_chr, column_name)
    return(levels_chr[!is.na(levels_chr) & nzchar(levels_chr)])
  }

  vals <- as.character(.figure_coalesce(values, character(0)))
  vals[is.na(vals) | !nzchar(vals)] <- "NA"
  vals <- figure_zero_base_labels_if_needed(vals, column_name)
  uniq <- unique(vals)
  if (!length(uniq)) return(character(0))

  numeric_like <- grepl("^-?[0-9]+(?:\\.[0-9]+)?$", uniq)
  if (all(numeric_like)) {
    return(uniq[order(as.numeric(uniq))])
  }

  uniq <- sort(uniq)
  if ("NA" %in% uniq) uniq <- c("NA", setdiff(uniq, "NA"))
  uniq
}

figure_default_discrete_palette <- function(n) {
  n <- suppressWarnings(as.integer(.figure_coalesce(n, 0L)))
  if (!is.finite(n) || n < 1L) return(character(0))
  
  palette_choice <- tryCatch(get("DATA_BROWSER_DEFAULT_PALETTE", envir = .GlobalEnv), error = function(e) "Default Seurat")
  pal <- character(0)
  
  if (identical(palette_choice, "Default Seurat")) {
    fn <- tryCatch(getFromNamespace("DiscretePalette", "Seurat"), error = function(e) NULL)
    pal <- tryCatch(
      if (is.function(fn)) suppressWarnings(as.character(fn(n))) else character(0),
      error = function(e) character(0)
    )
  } else {
    pals <- tryCatch(get("all_palettes", envir = .GlobalEnv), error = function(e) list())
    base_colors <- if (is.list(pals)) pals[[palette_choice]] else NULL
    if (length(base_colors) > 0) {
      pal <- tryCatch(
        grDevices::colorRampPalette(base_colors)(n),
        error = function(e) character(0)
      )
    }
  }
  
  if (length(pal) < n) {
    pal_fallback <- grDevices::hcl.colors(max(n, 3L), palette = "Dark 3")
    if (length(pal) > 0) {
      pal <- c(pal, pal_fallback[(length(pal) + 1):max(n, 3L)])
    } else {
      pal <- pal_fallback
    }
  }
  
  res <- toupper(as.character(pal[seq_len(n)]))
  # Ensure no NA or invalid colors in the discrete palette
  fallback_pool <- tryCatch({
    pals <- get("all_palettes", envir = .GlobalEnv)
    custom_cols <- unlist(pals, use.names = FALSE)
    custom_cols <- toupper(unique(custom_cols[grepl("^#[0-9A-F]{6}$", toupper(as.character(custom_cols %||% character(0))))]))
    if (!length(custom_cols)) custom_cols <- c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")
    custom_cols
  }, error = function(e) {
    c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf")
  })
  
  for (i in seq_len(n)) {
    if (is.na(res[i]) || !grepl("^#[0-9A-F]{6}$", res[i])) {
      fallback_col <- fallback_pool[i]
      if (is.na(fallback_col) || !grepl("^#[0-9A-F]{6}$", fallback_col)) {
        hcl_fallback <- grDevices::hcl.colors(max(n, 3L), palette = "Dark 3")
        fallback_col <- hcl_fallback[i] %||% "#4B5563"
      }
      res[i] <- toupper(fallback_col)
    }
  }
  res
}

figure_metadata_color_candidates <- function(col_name) {
  nm <- as.character(.figure_coalesce(col_name, ""))
  if (!nzchar(nm)) return(character(0))
  unique(c(
    paste0(nm, "_color"),
    paste0(nm, "_colour"),
    paste0(nm, ".color"),
    paste0(nm, ".colour"),
    paste0(nm, " color"),
    paste0(nm, " colour")
  ))
}

figure_match_colname_ci <- function(all_cols, targets) {
  all_cols <- as.character(.figure_coalesce(all_cols, character(0)))
  targets <- as.character(.figure_coalesce(targets, character(0)))
  if (!length(all_cols) || !length(targets)) return(character(0))
  all_l <- tolower(all_cols)
  out <- character(0)
  for (tgt in targets) {
    idx <- which(all_l %in% tolower(tgt))
    if (length(idx)) out <- c(out, all_cols[idx[[1]]])
  }
  unique(out)
}

figure_is_hex_color <- function(x) {
  grepl("^#[0-9A-F]{6}$", toupper(as.character(.figure_coalesce(x, ""))))
}

figure_palette_from_metadata_colors <- function(meta, label_col, label_values, levels_vec) {
  if (!is.data.frame(meta) || !nzchar(label_col) || !(label_col %in% colnames(meta))) return(NULL)
  lv <- as.character(.figure_coalesce(levels_vec, character(0)))
  if (!length(lv)) return(NULL)
  color_col <- figure_match_colname_ci(colnames(meta), figure_metadata_color_candidates(label_col))
  if (!length(color_col)) return(NULL)
  color_col <- color_col[[1]]

  labels <- as.character(.figure_coalesce(label_values, character(0)))
  labels[is.na(labels) | !nzchar(labels)] <- "NA"
  labels <- figure_zero_base_labels_if_needed(labels, label_col)
  cols <- toupper(as.character(meta[[color_col]]))
  cols[!figure_is_hex_color(cols)] <- NA_character_

  pal <- setNames(rep(NA_character_, length(lv)), lv)
  for (nm in lv) {
    idx <- which(labels == nm & !is.na(cols))
    if (length(idx)) pal[[nm]] <- cols[idx[[1]]]
  }
  if (all(is.na(pal) | !nzchar(pal))) return(NULL)
  pal
}

figure_palette_from_dimplot <- function(sobj, reduction_name, color_col, levels_vec) {
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
  if (!nzchar(color_col) || !(color_col %in% colnames(sobj@meta.data))) return(NULL)
  lv <- as.character(.figure_coalesce(levels_vec, character(0)))
  if (!length(lv)) return(NULL)

  reds <- tryCatch(names(sobj@reductions), error = function(e) character(0))
  if (!length(reds)) return(NULL)
  red_use <- as.character(.figure_coalesce(reduction_name, ""))
  if (!nzchar(red_use) || !(red_use %in% reds)) {
    red_l <- tolower(reds)
    red_use <- if ("umap" %in% red_l) reds[[match("umap", red_l)]] else reds[[1]]
  }

  p_tmp <- tryCatch(Seurat::DimPlot(sobj, reduction = red_use, group.by = color_col), error = function(e) NULL)
  if (is.null(p_tmp) || !inherits(p_tmp, "ggplot")) return(NULL)
  d_plot <- tryCatch(p_tmp$data, error = function(e) NULL)
  d_layer <- tryCatch(ggplot2::ggplot_build(p_tmp)$data[[1]], error = function(e) NULL)
  if (is.null(d_plot) || is.null(d_layer) || !nrow(d_plot) || !nrow(d_layer) || !(color_col %in% colnames(d_plot))) return(NULL)

  vals <- as.character(d_plot[[color_col]])
  vals[is.na(vals) | !nzchar(vals)] <- "NA"
  vals <- figure_zero_base_labels_if_needed(vals, color_col)
  cols <- toupper(as.character(d_layer$colour))
  cols[!figure_is_hex_color(cols)] <- NA_character_
  n <- min(length(vals), length(cols))
  if (n < 1L) return(NULL)
  vals <- vals[seq_len(n)]
  cols <- cols[seq_len(n)]
  keep <- !is.na(vals) & nzchar(vals) & !is.na(cols)
  vals <- vals[keep]
  cols <- cols[keep]
  if (!length(vals) || !length(cols)) return(NULL)

  first_idx <- match(unique(vals), vals)
  map <- cols[first_idx]
  names(map) <- unique(vals)
  mapped <- unname(map[lv])
  names(mapped) <- lv
  if (all(is.na(mapped) | !nzchar(mapped))) return(NULL)
  mapped
}

figure_resolve_metadata_palette <- function(sobj, reduction_name, color_col, label_values, levels_vec) {
  lv <- as.character(.figure_coalesce(levels_vec, character(0)))
  if (!length(lv)) return(setNames(character(0), character(0)))
  fallback <- figure_default_discrete_palette(length(lv))
  names(fallback) <- lv

  # 1. Check sobj@misc$metadata_level_colors first
  misc <- tryCatch(sobj@misc, error = function(e) list())
  stored <- tryCatch(misc$metadata_level_colors[[color_col]], error = function(e) NULL)
  if (is.list(stored) && length(stored) > 0) {
    mapped <- vapply(lv, function(nm) {
      val <- stored[[nm]]
      if (!is.null(val) && grepl("^#[0-9A-F]{6}$", toupper(as.character(val)))) {
        toupper(as.character(val))
      } else {
        NA_character_
      }
    }, character(1))
    if (any(!is.na(mapped))) {
      bad <- is.na(mapped)
      if (any(bad)) {
        mapped[bad] <- fallback[bad]
      }
      return(mapped)
    }
  }

  meta <- tryCatch(sobj@meta.data, error = function(e) NULL)
  from_meta <- figure_palette_from_metadata_colors(meta = meta, label_col = color_col, label_values = label_values, levels_vec = lv)
  if (!is.null(from_meta) && length(from_meta)) {
    bad <- is.na(from_meta) | !nzchar(from_meta)
    from_meta[bad] <- fallback[bad]
    return(from_meta)
  }

  # Bypass default ggplot2/DimPlot colors to ensure we match the Data Browser's default palette
  # from_dimplot <- figure_palette_from_dimplot(sobj = sobj, reduction_name = reduction_name, color_col = color_col, levels_vec = lv)
  # if (!is.null(from_dimplot) && length(from_dimplot)) {
  #   bad <- is.na(from_dimplot) | !nzchar(from_dimplot)
  #   from_dimplot[bad] <- fallback[bad]
  #   return(from_dimplot)
  # }

  fallback
}

figure_axis_prefix_for_reduction <- function(reduction_name) {
  red <- tolower(.figure_safe_upper(reduction_name, "umap"))
  red <- red[!is.na(red) & nzchar(red)]
  red <- if (length(red)) red[[1]] else "umap"
  if (identical(red, "tsne")) return("tSNE")
  if (identical(red, "pca")) return("PC")
  .figure_safe_upper(red, "UMAP")[[1]]
}

figure_default_reduction_name <- function(obj, preferred = c("umap", "tsne", "pca")) {
  reds <- figure_entry_reduction_names(obj)
  if (!length(reds)) return(NULL)
  pref <- tolower(as.character(.figure_coalesce(preferred, character(0))))
  hit <- pref[pref %in% reds]
  if (length(hit)) return(hit[[1]])
  reds[[1]]
}

figure_prepare_split_factor <- function(values, column_name = NULL) {
  vals <- as.character(.figure_coalesce(values, character(0)))
  vals[is.na(vals) | !nzchar(vals)] <- "NA"
  vals <- figure_zero_base_labels_if_needed(vals, column_name)
  lv_raw <- figure_sort_facet_levels(vals)
  lab_map <- if (identical(column_name, "orig.ident")) {
    figure_smart_short_labels(lv_raw, column_name = column_name, keep_prefix_tokens = 1L)
  } else {
    stats::setNames(lv_raw, lv_raw)
  }
  fac_levels <- unname(lab_map[lv_raw])
  factor(unname(lab_map[vals]), levels = fac_levels)
}

figure_apply_embedding_facets <- function(plot_obj, facet_mode = "none") {
  mode <- tolower(as.character(.figure_coalesce(facet_mode, "none")))
  mode <- mode[!is.na(mode) & nzchar(mode)]
  mode <- if (length(mode)) mode[[1]] else "none"

  if (identical(mode, "grid")) {
    return(plot_obj + ggplot2::facet_grid(rows = ggplot2::vars(split_value_secondary), cols = ggplot2::vars(split_value), drop = FALSE))
  }
  if (identical(mode, "column")) {
    return(plot_obj + ggplot2::facet_wrap(ggplot2::vars(split_value), nrow = 1, drop = FALSE))
  }
  if (identical(mode, "row")) {
    return(plot_obj + ggplot2::facet_wrap(ggplot2::vars(split_value_secondary), ncol = 1, drop = FALSE))
  }
  plot_obj
}

figure_stroke_linetype_from_frequency <- function(frequency = 5) {
  freq <- suppressWarnings(as.numeric(.figure_coalesce(frequency, 5)))
  if (!is.finite(freq)) freq <- 5
  freq <- max(1, min(9, round(freq)))
  dash <- max(1, min(9, 10 - freq))
  gap <- max(1, min(9, dash))
  paste0(as.character(dash), as.character(gap))
}

figure_build_cluster_stroke_overlay_data <- function(df,
                                                     selected_values = character(0),
                                                     merge_groups = FALSE,
                                                     padding = 0,
                                                     smooth_iterations = 0,
                                                     value_col = "stroke_value",
                                                     facet_primary_col = "split_value",
                                                     facet_secondary_col = "split_value_secondary") {
  if (!is.data.frame(df) || !all(c("dim1", "dim2", value_col) %in% colnames(df))) {
    return(data.frame())
  }

  selected <- as.character(.figure_coalesce(selected_values, character(0)))
  selected <- selected[!is.na(selected) & nzchar(selected)]
  if (!length(selected)) return(df[0, c("dim1", "dim2"), drop = FALSE])

  value_vec <- as.character(df[[value_col]])
  value_vec[is.na(value_vec) | !nzchar(value_vec)] <- "NA"
  keep <- value_vec %in% selected
  if (!any(keep)) return(df[0, c("dim1", "dim2"), drop = FALSE])

  work <- df[keep, , drop = FALSE]
  work$..stroke_value <- value_vec[keep]
  if (facet_primary_col %in% colnames(work)) {
    work$..facet_primary <- as.character(work[[facet_primary_col]])
  } else {
    work$..facet_primary <- "All cells"
  }
  if (facet_secondary_col %in% colnames(work)) {
    work$..facet_secondary <- as.character(work[[facet_secondary_col]])
  } else {
    work$..facet_secondary <- "All cells"
  }

  pad <- suppressWarnings(as.numeric(.figure_coalesce(padding, 0)))
  if (!is.finite(pad) || pad < 0) pad <- 0
  pad <- min(1.5, pad)
  smooth_iter <- suppressWarnings(as.integer(round(as.numeric(.figure_coalesce(smooth_iterations, 0)))))
  if (!is.finite(smooth_iter) || smooth_iter < 0) smooth_iter <- 0L
  smooth_iter <- min(6L, smooth_iter)
  merge_flag <- isTRUE(merge_groups)

  .smooth_closed_ring <- function(path_df, iterations = 0L) {
    if (!is.data.frame(path_df) || nrow(path_df) < 4 || iterations <= 0) return(path_df)
    pts <- as.matrix(path_df[, c("dim1", "dim2"), drop = FALSE])
    pts <- pts[seq_len(nrow(pts) - 1), , drop = FALSE] # drop duplicated closing point
    if (nrow(pts) < 3) return(path_df)

    for (iter in seq_len(iterations)) {
      n <- nrow(pts)
      nxt <- rbind(pts[-1, , drop = FALSE], pts[1, , drop = FALSE])
      q <- 0.75 * pts + 0.25 * nxt
      r <- 0.25 * pts + 0.75 * nxt
      out <- matrix(NA_real_, nrow = n * 2, ncol = 2)
      out[seq(1, n * 2, by = 2), ] <- q
      out[seq(2, n * 2, by = 2), ] <- r
      pts <- out
    }

    smooth <- data.frame(dim1 = pts[, 1], dim2 = pts[, 2], stringsAsFactors = FALSE)
    rbind(smooth, smooth[1, , drop = FALSE])
  }

  .build_hull <- function(sub_df) {
    coords <- unique(data.frame(
      dim1 = suppressWarnings(as.numeric(sub_df$dim1)),
      dim2 = suppressWarnings(as.numeric(sub_df$dim2))
    ))
    coords <- coords[is.finite(coords$dim1) & is.finite(coords$dim2), , drop = FALSE]
    if (nrow(coords) < 3) return(NULL)
    hull_idx <- grDevices::chull(coords$dim1, coords$dim2)
    if (!length(hull_idx) || length(unique(hull_idx)) < 3) return(NULL)
    hull <- coords[hull_idx, , drop = FALSE]
    if (nrow(hull) < 3) return(NULL)

    cx <- mean(hull$dim1)
    cy <- mean(hull$dim2)
    hull$dim1 <- cx + (hull$dim1 - cx) * (1 + pad)
    hull$dim2 <- cy + (hull$dim2 - cy) * (1 + pad)
    hull <- rbind(hull, hull[1, , drop = FALSE])
    hull <- .smooth_closed_ring(hull, iterations = smooth_iter)
    hull
  }

  key_group <- if (merge_flag) {
    rep("merged", nrow(work))
  } else {
    work$..stroke_value
  }
  work$..key <- paste(work$..facet_primary, work$..facet_secondary, key_group, sep = "\r")

  pieces <- lapply(split(work, work$..key), function(chunk) {
    hull <- .build_hull(chunk)
    if (is.null(hull) || !nrow(hull)) return(NULL)
    hull$stroke_group <- chunk$..key[[1]]
    hull$split_value <- chunk$..facet_primary[[1]]
    hull$split_value_secondary <- chunk$..facet_secondary[[1]]
    hull
  })

  pieces <- pieces[!vapply(pieces, is.null, logical(1))]
  if (!length(pieces)) return(df[0, c("dim1", "dim2"), drop = FALSE])
  do.call(rbind, pieces)
}

figure_build_stroke_segments <- function(stroke_path_df, dash_frequency = 5) {
  if (!is.data.frame(stroke_path_df) || !all(c("dim1", "dim2", "stroke_group") %in% colnames(stroke_path_df))) {
    return(data.frame())
  }
  freq <- suppressWarnings(as.numeric(.figure_coalesce(dash_frequency, 5)))
  if (!is.finite(freq) || freq < 1) freq <- 5
  freq <- max(1, min(9, round(freq)))

  .interp_point <- function(df, t) {
    idx <- findInterval(t, df$cumlen, rightmost.closed = TRUE, all.inside = TRUE)
    idx <- max(1, min(idx, nrow(df) - 1))
    seg0 <- df$cumlen[idx]
    seg1 <- df$cumlen[idx + 1]
    if (!is.finite(seg1) || seg1 <= seg0) {
      return(c(df$dim1[idx], df$dim2[idx]))
    }
    ratio <- (t - seg0) / (seg1 - seg0)
    ratio <- max(0, min(1, ratio))
    c(
      df$dim1[idx] + (df$dim1[idx + 1] - df$dim1[idx]) * ratio,
      df$dim2[idx] + (df$dim2[idx + 1] - df$dim2[idx]) * ratio
    )
  }

  pieces <- lapply(split(stroke_path_df, stroke_path_df$stroke_group), function(chunk) {
    chunk <- chunk[order(seq_len(nrow(chunk))), , drop = FALSE]
    if (nrow(chunk) < 2) return(NULL)
    dx <- diff(as.numeric(chunk$dim1))
    dy <- diff(as.numeric(chunk$dim2))
    seg_len <- sqrt(dx^2 + dy^2)
    seg_len[!is.finite(seg_len)] <- 0
    total_len <- sum(seg_len)
    if (!is.finite(total_len) || total_len <= 0) return(NULL)

    chunk$cumlen <- c(0, cumsum(seg_len))
    dash_count <- as.integer(max(4, round(6 + freq * 4)))
    dash_len <- total_len / (dash_count * 2)
    if (!is.finite(dash_len) || dash_len <= 0) return(NULL)

    seg_rows <- vector("list", dash_count)
    row_idx <- 0L
    for (k in seq_len(dash_count)) {
      start_t <- (k - 1) * 2 * dash_len
      end_t <- start_t + dash_len
      if (start_t >= total_len) break
      end_t <- min(end_t, total_len)
      p0 <- .interp_point(chunk, start_t)
      p1 <- .interp_point(chunk, end_t)
      row_idx <- row_idx + 1L
      seg_rows[[row_idx]] <- data.frame(
        x = p0[[1]],
        y = p0[[2]],
        xend = p1[[1]],
        yend = p1[[2]],
        stroke_group = chunk$stroke_group[[1]],
        split_value = chunk$split_value[[1]],
        split_value_secondary = chunk$split_value_secondary[[1]],
        stringsAsFactors = FALSE
      )
    }
    seg_rows <- seg_rows[seq_len(row_idx)]
    if (!length(seg_rows)) return(NULL)
    do.call(rbind, seg_rows)
  })

  pieces <- pieces[!vapply(pieces, is.null, logical(1))]
  if (!length(pieces)) return(data.frame())
  do.call(rbind, pieces)
}

figure_build_discrete_embedding_plot <- function(sobj,
                                                 reduction_name,
                                                 color_by,
                                                 palette_values = NULL,
                                                 column_split = NULL,
                                                 row_split = NULL,
                                                 dot_size = 1,
                                                 alpha = 1,
                                                 title = NULL,
                                                 x_label = NULL,
                                                 y_label = NULL,
                                                 theme_choice = "Classic",
                                                 point_shape = 19,
                                                 point_stroke = 0,
                                                 color_map = "color",
                                                 stroke_enabled = FALSE,
                                                 stroke_column = NULL,
                                                 stroke_selected_values = character(0),
                                                 stroke_merge = FALSE,
                                                 stroke_padding = 0.08,
                                                 stroke_smoothness = 2,
                                                 stroke_width = 1.2,
                                                 stroke_dash_frequency = 5,
                                                 stroke_color = "#111111",
                                                 label_clusters = TRUE,
                                                 label_size = 4,
                                                 legend_position = "right",
                                                 legend_columns = 4,
                                                 legend_text_size = 10,
                                                 axis_text_size = 10,
                                                 axis_title_size = 14,
                                                 plot_title_size = 16) {
  emb <- tryCatch(Seurat::Embeddings(sobj, reduction_name), error = function(e) NULL)
  shiny::validate(shiny::need(!is.null(emb) && is.matrix(emb) && ncol(emb) >= 2, "Embedding preview unavailable."))

  cell_ids <- rownames(emb)
  md <- sobj@meta.data
  shiny::validate(shiny::need(all(cell_ids %in% rownames(md)), "Cell metadata mismatch for embedding preview."))

  df <- data.frame(
    cell_id = cell_ids,
    dim1 = as.numeric(emb[, 1]),
    dim2 = as.numeric(emb[, 2]),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )

  color_col <- figure_safe_meta_col(md, color_by)
  if (is.null(color_col)) {
    vals <- as.character(Seurat::Idents(sobj))
    color_col <- ".ident"
  } else {
    vals <- as.character(md[cell_ids, color_col, drop = TRUE])
  }
  vals[is.na(vals) | !nzchar(vals)] <- "NA"
  vals <- figure_zero_base_labels_if_needed(vals, color_col)
  color_levels <- figure_sort_levels_natural(vals)
  df$color_value <- factor(vals, levels = color_levels)
  legend_position <- tolower(as.character(.figure_coalesce(legend_position, "right")))
  if (!legend_position %in% c("top", "bottom", "right", "left", "none")) legend_position <- "right"
  legend_is_horizontal <- legend_position %in% c("top", "bottom")
  legend_columns <- figure_safe_integer(legend_columns, 4L, min_value = 1L, max_value = 8L)
  legend_columns_use <- max(1L, min(legend_columns, length(color_levels)))
  legend_rows_use <- max(1L, as.integer(ceiling(length(color_levels) / max(1L, legend_columns_use))))

  split_vars <- figure_normalize_split_vars(column_split = column_split, row_split = row_split)
  split_col <- figure_safe_meta_col(md, split_vars$column_split)
  row_col <- figure_safe_meta_col(md, split_vars$row_split)
  if (!is.null(split_col)) {
    df$split_value <- figure_prepare_split_factor(md[cell_ids, split_col, drop = TRUE], column_name = split_col)
  } else {
    df$split_value <- factor("All cells", levels = "All cells")
  }
  if (!is.null(row_col)) {
    df$split_value_secondary <- figure_prepare_split_factor(md[cell_ids, row_col, drop = TRUE], column_name = row_col)
  } else {
    df$split_value_secondary <- factor("All cells", levels = "All cells")
  }

  metadata_default_pal <- figure_resolve_metadata_palette(
    sobj = sobj,
    reduction_name = reduction_name,
    color_col = color_col,
    label_values = vals,
    levels_vec = color_levels
  )
  pal <- .figure_safe_upper(palette_values, character(0))
  pal <- pal[grepl("^#[0-9A-F]{6}$", pal)]
  if (!length(pal)) {
    pal <- metadata_default_pal
  }
  if (length(pal) < length(color_levels)) {
    pal <- grDevices::colorRampPalette(pal)(length(color_levels))
  }
  pal <- pal[seq_len(length(color_levels))]
  names(pal) <- color_levels

  axis_prefix <- figure_axis_prefix_for_reduction(reduction_name)
  if (is.null(x_label)) x_label <- paste0(axis_prefix, "_1")
  if (is.null(y_label)) y_label <- paste0(axis_prefix, "_2")
  dot_size_num <- suppressWarnings(as.numeric(.figure_coalesce(dot_size, 1)))
  if (!is.finite(dot_size_num) || dot_size_num <= 0) dot_size_num <- 1
  alpha_num <- suppressWarnings(as.numeric(.figure_coalesce(alpha, 1)))
  if (!is.finite(alpha_num) || alpha_num <= 0) alpha_num <- 1
  point_mapping <- figure_point_mapping(
    point_shape = point_shape,
    point_stroke = point_stroke,
    color_map = color_map
  )

  p <- ggplot2::ggplot(df, ggplot2::aes(dim1, dim2))
  if (isTRUE(point_mapping$use_fill)) {
    p <- p +
      ggplot2::geom_point(
        ggplot2::aes(fill = color_value),
        shape = point_mapping$shape,
        size = dot_size_num,
        alpha = alpha_num,
        stroke = point_mapping$stroke,
        color = "#1F1F1F"
      ) +
      ggplot2::scale_fill_manual(values = pal, drop = FALSE) +
      ggplot2::guides(fill = ggplot2::guide_legend(override.aes = list(
        shape = point_mapping$shape,
        size = max(3, dot_size_num * 3),
        alpha = 1,
        stroke = point_mapping$stroke,
        color = "#1F1F1F"
      ),
      ncol = if (isTRUE(legend_is_horizontal)) legend_columns_use else NULL,
      nrow = if (isTRUE(legend_is_horizontal)) legend_rows_use else NULL,
      byrow = isTRUE(legend_is_horizontal))) +
      ggplot2::labs(fill = color_col %||% "ident")
  } else {
    p <- p +
      ggplot2::geom_point(
        ggplot2::aes(color = color_value),
        shape = point_mapping$shape,
        size = dot_size_num,
        alpha = alpha_num,
        stroke = point_mapping$stroke
      ) +
      ggplot2::scale_color_manual(values = pal, drop = FALSE) +
      ggplot2::guides(color = ggplot2::guide_legend(override.aes = list(
        shape = point_mapping$shape,
        size = max(3, dot_size_num * 3),
        alpha = 1,
        stroke = point_mapping$stroke
      ),
      ncol = if (isTRUE(legend_is_horizontal)) legend_columns_use else NULL,
      nrow = if (isTRUE(legend_is_horizontal)) legend_rows_use else NULL,
      byrow = isTRUE(legend_is_horizontal))) +
      ggplot2::labs(color = color_col %||% "ident")
  }

  if (isTRUE(stroke_enabled)) {
    stroke_col <- figure_safe_meta_col(md, stroke_column)
    if (!is.null(stroke_col)) {
      stroke_vals <- as.character(md[cell_ids, stroke_col, drop = TRUE])
      stroke_vals[is.na(stroke_vals) | !nzchar(stroke_vals)] <- "NA"
      stroke_vals <- figure_zero_base_labels_if_needed(stroke_vals, stroke_col)
      df$stroke_value <- stroke_vals

      stroke_df <- figure_build_cluster_stroke_overlay_data(
        df = df,
        selected_values = stroke_selected_values,
        merge_groups = stroke_merge,
        padding = stroke_padding,
        smooth_iterations = stroke_smoothness,
        value_col = "stroke_value",
        facet_primary_col = "split_value",
        facet_secondary_col = "split_value_secondary"
      )
      if (nrow(stroke_df) > 0) {
        stroke_segments <- figure_build_stroke_segments(
          stroke_path_df = stroke_df,
          dash_frequency = stroke_dash_frequency
        )
      } else {
        stroke_segments <- data.frame()
      }
      if (nrow(stroke_segments) > 0) {
        width_num <- suppressWarnings(as.numeric(.figure_coalesce(stroke_width, 1.2)))
        if (!is.finite(width_num) || width_num <= 0) width_num <- 1.2
        width_num <- min(6, width_num)
        p <- p + ggplot2::geom_segment(
          data = stroke_segments,
          mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend, group = stroke_group),
          inherit.aes = FALSE,
          color = figure_safe_hex(stroke_color, "#111111"),
          linewidth = width_num,
          lineend = "round",
          show.legend = FALSE
        )
      }
    }
  }

  p <- p + ggplot2::coord_fixed()

  if (isTRUE(label_clusters) && isTRUE(is.finite(label_size)) && label_size > 0) {
    label_df <- stats::aggregate(
      cbind(dim1, dim2) ~ color_value + split_value + split_value_secondary,
      data = df,
      FUN = median
    )
    p <- p + ggplot2::geom_text(
      data = label_df,
      mapping = ggplot2::aes(x = dim1, y = dim2, label = color_value),
      inherit.aes = FALSE,
      color = "#111111",
      size = label_size,
      fontface = "bold",
      show.legend = FALSE
    )
  }

  p <- figure_apply_embedding_facets(
    p,
    facet_mode = figure_facet_mode(column_split = split_vars$column_split, row_split = split_vars$row_split)
  )

  figure_apply_plot_theme(
    plot_obj = p,
    theme_choice = theme_choice,
    title = title,
    x_label = x_label,
    y_label = y_label,
    legend_position = legend_position,
    legend_text_size = legend_text_size,
    axis_text_size = axis_text_size,
    axis_title_size = axis_title_size,
    plot_title_size = plot_title_size
  )
}

figure_build_feature_embedding_plot <- function(sobj,
                                                reduction_name,
                                                assay_name,
                                                feature_name,
                                                low_color,
                                                high_color,
                                                column_split = NULL,
                                                row_split = NULL,
                                                dot_size = 1,
                                                alpha = 1,
                                                title = NULL,
                                                x_label = NULL,
                                                y_label = NULL,
                                                theme_choice = "Classic",
                                                point_shape = 19,
                                                point_stroke = 0,
                                                color_map = "color",
                                                stroke_enabled = FALSE,
                                                stroke_column = NULL,
                                                stroke_selected_values = character(0),
                                                stroke_merge = FALSE,
                                                stroke_padding = 0.08,
                                                stroke_smoothness = 2,
                                                stroke_width = 1.2,
                                                stroke_dash_frequency = 5,
                                                stroke_color = "#111111",
                                                legend_text_size = 10,
                                                axis_text_size = 10,
                                                axis_title_size = 14,
                                                plot_title_size = 16) {
  emb <- tryCatch(Seurat::Embeddings(sobj, reduction_name), error = function(e) NULL)
  shiny::validate(shiny::need(!is.null(emb) && is.matrix(emb) && ncol(emb) >= 2, "Embedding preview unavailable."))

  cell_ids <- rownames(emb)
  md <- sobj@meta.data
  shiny::validate(shiny::need(all(cell_ids %in% rownames(md)), "Cell metadata mismatch for feature preview."))

  assay_to_use <- as.character(.figure_coalesce(assay_name, Seurat::DefaultAssay(sobj)))
  expr_mat <- .figure_get_assay_data(sobj = sobj, assay = assay_to_use, layer = "data")
  shiny::validate(shiny::need(!is.null(expr_mat), paste("Assay unavailable for feature plot:", assay_to_use)))

  feature_chr <- as.character(.figure_coalesce(feature_name, ""))
  feature_chr <- feature_chr[!is.na(feature_chr) & nzchar(feature_chr)]
  shiny::validate(shiny::need(length(feature_chr) == 1, "Select a feature to plot."))
  feature_chr <- feature_chr[[1]]
  shiny::validate(shiny::need(feature_chr %in% rownames(expr_mat), paste("Feature not found in assay:", feature_chr)))

  expr_vals <- as.numeric(expr_mat[feature_chr, cell_ids, drop = TRUE])
  expr_vals[!is.finite(expr_vals)] <- NA_real_

  df <- data.frame(
    cell_id = cell_ids,
    dim1 = as.numeric(emb[, 1]),
    dim2 = as.numeric(emb[, 2]),
    feature_value = expr_vals,
    stringsAsFactors = FALSE,
    check.names = FALSE
  )

  split_vars <- figure_normalize_split_vars(column_split = column_split, row_split = row_split)
  split_col <- figure_safe_meta_col(md, split_vars$column_split)
  row_col <- figure_safe_meta_col(md, split_vars$row_split)
  if (!is.null(split_col)) {
    df$split_value <- figure_prepare_split_factor(md[cell_ids, split_col, drop = TRUE], column_name = split_col)
  } else {
    df$split_value <- factor("All cells", levels = "All cells")
  }
  if (!is.null(row_col)) {
    df$split_value_secondary <- figure_prepare_split_factor(md[cell_ids, row_col, drop = TRUE], column_name = row_col)
  } else {
    df$split_value_secondary <- factor("All cells", levels = "All cells")
  }

  axis_prefix <- figure_axis_prefix_for_reduction(reduction_name)
  if (is.null(x_label)) x_label <- paste0(axis_prefix, "_1")
  if (is.null(y_label)) y_label <- paste0(axis_prefix, "_2")
  dot_size_num <- suppressWarnings(as.numeric(.figure_coalesce(dot_size, 1)))
  if (!is.finite(dot_size_num) || dot_size_num <= 0) dot_size_num <- 1
  alpha_num <- suppressWarnings(as.numeric(.figure_coalesce(alpha, 1)))
  if (!is.finite(alpha_num) || alpha_num <= 0) alpha_num <- 1
  point_mapping <- figure_point_mapping(
    point_shape = point_shape,
    point_stroke = point_stroke,
    color_map = color_map
  )

  p <- ggplot2::ggplot(df, ggplot2::aes(dim1, dim2))
  if (isTRUE(point_mapping$use_fill)) {
    p <- p +
      ggplot2::geom_point(
        ggplot2::aes(fill = feature_value),
        shape = point_mapping$shape,
        size = dot_size_num,
        alpha = alpha_num,
        stroke = point_mapping$stroke,
        color = "#1F1F1F"
      ) +
      ggplot2::scale_fill_gradient(
        low = figure_safe_hex(low_color, "#D3D3D3"),
        high = figure_safe_hex(high_color, "#FF0000"),
        name = feature_chr,
        na.value = "#8A8A8A"
      )
  } else {
    p <- p +
      ggplot2::geom_point(
        ggplot2::aes(color = feature_value),
        shape = point_mapping$shape,
        size = dot_size_num,
        alpha = alpha_num,
        stroke = point_mapping$stroke
      ) +
      ggplot2::scale_color_gradient(
        low = figure_safe_hex(low_color, "#D3D3D3"),
        high = figure_safe_hex(high_color, "#FF0000"),
        name = feature_chr,
        na.value = "#8A8A8A"
      )
  }

  if (isTRUE(stroke_enabled)) {
    stroke_col <- figure_safe_meta_col(md, stroke_column)
    if (!is.null(stroke_col)) {
      stroke_vals <- as.character(md[cell_ids, stroke_col, drop = TRUE])
      stroke_vals[is.na(stroke_vals) | !nzchar(stroke_vals)] <- "NA"
      stroke_vals <- figure_zero_base_labels_if_needed(stroke_vals, stroke_col)
      df$stroke_value <- stroke_vals

      stroke_df <- figure_build_cluster_stroke_overlay_data(
        df = df,
        selected_values = stroke_selected_values,
        merge_groups = stroke_merge,
        padding = stroke_padding,
        smooth_iterations = stroke_smoothness,
        value_col = "stroke_value",
        facet_primary_col = "split_value",
        facet_secondary_col = "split_value_secondary"
      )
      if (nrow(stroke_df) > 0) {
        stroke_segments <- figure_build_stroke_segments(
          stroke_path_df = stroke_df,
          dash_frequency = stroke_dash_frequency
        )
      } else {
        stroke_segments <- data.frame()
      }
      if (nrow(stroke_segments) > 0) {
        width_num <- suppressWarnings(as.numeric(.figure_coalesce(stroke_width, 1.2)))
        if (!is.finite(width_num) || width_num <= 0) width_num <- 1.2
        width_num <- min(6, width_num)
        p <- p + ggplot2::geom_segment(
          data = stroke_segments,
          mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend, group = stroke_group),
          inherit.aes = FALSE,
          color = figure_safe_hex(stroke_color, "#111111"),
          linewidth = width_num,
          lineend = "round",
          show.legend = FALSE
        )
      }
    }
  }

  p <- p + ggplot2::coord_fixed()

  p <- figure_apply_embedding_facets(
    p,
    facet_mode = figure_facet_mode(column_split = split_vars$column_split, row_split = split_vars$row_split)
  )

  figure_apply_plot_theme(
    plot_obj = p,
    theme_choice = theme_choice,
    title = title,
    x_label = x_label,
    y_label = y_label,
    legend_text_size = legend_text_size,
    axis_text_size = axis_text_size,
    axis_title_size = axis_title_size,
    plot_title_size = plot_title_size
  )
}

figure_busy_spinner_assets <- local({
  shiny::tags$style(shiny::HTML("
    .figure-load-wrap{
      position: relative;
      width: 100%;
    }
    .figure-load-indicator{
      display: none;
      position: absolute;
      inset: 0;
      z-index: 11;
      align-items: center;
      justify-content: center;
      pointer-events: none;
      background: rgba(38, 38, 38, 0.42);
    }
    .figure-load-wrap > .recalculating + .figure-load-indicator{
      display: flex;
    }
    .figure-load-wrap > .recalculating{
      opacity: 0.24;
    }
    @keyframes figure-load-fallback-spin{
      to{
        transform: rotate(360deg);
      }
    }
    .figure-modal-dark-dialog .modal-content{
      background:#111111;
      color:#e5e5e5;
      border:1px solid rgba(120,120,120,.52);
      box-shadow:0 24px 80px rgba(0,0,0,.45);
    }
    .figure-modal-dark-dialog .modal-header,
    .figure-modal-dark-dialog .modal-footer{
      background:#171717;
      border-color:rgba(120,120,120,.42);
    }
    .figure-modal-dark-dialog .modal-title{
      color:#f5f5f5;
      font-weight:700;
    }
    .figure-modal-dark-dialog .close{
      color:#d4d4d4;
      opacity:.85;
      text-shadow:none;
    }
    .figure-modal-dark-dialog .close:hover{
      color:#ffffff;
      opacity:1;
    }
    .figure-modal-dark-dialog .modal-body{
      background:#111111;
    }
    .figure-modal-dark-dialog .form-control,
    .figure-modal-dark-dialog select,
    .figure-modal-dark-dialog textarea{
      background:#1d1d1d;
      color:#ededed;
      border-color:#4a4a4a;
    }
    .figure-modal-dark-dialog .radio label,
    .figure-modal-dark-dialog .checkbox label,
    .figure-modal-dark-dialog label,
    .figure-modal-dark-dialog h5,
    .figure-modal-dark-dialog p,
    .figure-modal-dark-dialog span,
    .figure-modal-dark-dialog .control-label{
      color:#e5e5e5;
    }
    .figure-modal-dark-dialog .btn-default{
      background:#3a3a3a;
      color:#f5f5f5;
      border-color:#575757;
    }
    .figure-modal-dark-dialog .btn-default:hover{
      background:#4a4a4a;
      color:#ffffff;
      border-color:#666666;
    }
    .figure-modal-dark-dialog .btn-primary{
      background:#545454;
      color:#ffffff;
      border-color:#6a6a6a;
    }
    .figure-modal-dark-dialog .btn-primary:hover{
      background:#666666;
      color:#ffffff;
      border-color:#7a7a7a;
    }
    .figure-modal-dark-dialog .btn-outline-secondary{
      background:#242424;
      color:#e5e5e5;
      border-color:#4f4f4f;
    }
    .figure-modal-dark-dialog .btn-outline-secondary:hover{
      background:#343434;
      color:#ffffff;
      border-color:#666666;
    }
  "))
})

figure_busy_spinner_tag <- function(color = FIGURE_BUSY_SPINNER_COLOR) {
  if (requireNamespace("shinybusy", quietly = TRUE)) {
    return(
      shinybusy::spin_epic(
        spin = "flower",
        color = color
      )
    )
  }

  shiny::tags$div(
    class = "figure-load-spinner-fallback",
    `data-spin` = "flower",
    style = sprintf(
      "width:44px;height:44px;border-radius:999px;border:4px solid %s;border-top-color:transparent;animation:figure-load-fallback-spin 0.9s linear infinite;",
      color
    )
  )
}

figure_with_busy_spinner <- function(output_ui, color = FIGURE_BUSY_SPINNER_COLOR) {
  shiny::div(
    class = "figure-load-wrap",
    output_ui,
    shiny::div(
      class = "figure-load-indicator",
      figure_busy_spinner_tag(color = color)
    )
  )
}

figure_safe_hex <- function(x, fallback = "#3B82F6") {
  fallback_up <- .figure_safe_upper(fallback, "#3B82F6")
  fallback_up <- if (length(fallback_up)) fallback_up[[1]] else "#3B82F6"
  if (!is.character(x) || length(x) != 1L || !nzchar(x)) return(fallback_up)
  x <- .figure_safe_upper(trimws(x), fallback_up)
  x <- if (length(x)) x[[1]] else fallback_up
  if (!startsWith(x, "#")) x <- paste0("#", x)
  if (!grepl("^#[0-9A-F]{6}$", x)) return(fallback_up)
  x
}

figure_normalize_gradient_colors <- function(low, high, defaults) {
  defaults <- .figure_coalesce(defaults, c(low = "#D3D3D3", high = "#FF0000"))
  c(
    low = figure_safe_hex(low, .figure_coalesce(defaults[["low"]], "#D3D3D3")),
    high = figure_safe_hex(high, .figure_coalesce(defaults[["high"]], "#FF0000"))
  )
}

figure_resolve_discrete_palette <- function(palette_name,
                                            level_count,
                                            palette_map,
                                            custom_palette = NULL,
                                            default_palette = NULL) {
  palette_name <- as.character(.figure_coalesce(palette_name, "Default Seurat"))
  if (identical(palette_name, "Default Seurat")) return(NULL)

  level_count <- max(0L, suppressWarnings(as.integer(.figure_coalesce(level_count, 0L))))
  palette_map <- .figure_coalesce(palette_map, list())

  base <- if (identical(palette_name, "Custom Curve")) {
    custom_palette
  } else {
    palette_map[[palette_name]]
  }

  base <- .figure_safe_upper(base, .figure_coalesce(default_palette, character(0)))
  base <- base[grepl("^#[0-9A-F]{6}$", base)]
  if (!length(base)) return(NULL)
  if (level_count <= 0L) return(base)
  if (length(base) == level_count) return(base)
  if (length(base) > level_count) return(base[seq_len(level_count)])

  grDevices::colorRampPalette(base)(level_count)
}

figure_palette_seed <- function(colors, fallback = "#3B82F6") {
  colors <- .figure_safe_upper(colors, character(0))
  colors <- colors[grepl("^#[0-9A-F]{6}$", colors)]

  list(
    initial_hex = if (length(colors)) colors[[1]] else figure_safe_hex(fallback, "#3B82F6"),
    palette_n = if (length(colors)) max(2L, min(16L, length(colors))) else 6L
  )
}

figure_gradient_commit_values <- function(low_payload, high_payload, defaults) {
  low_hex <- if (is.list(low_payload)) low_payload$hex else low_payload
  high_hex <- if (is.list(high_payload)) high_payload$hex else high_payload
  low_source <- if (is.list(low_payload) && is.list(low_payload$meta)) as.character(.figure_coalesce(low_payload$meta$source, "")) else ""
  high_source <- if (is.list(high_payload) && is.list(high_payload$meta)) as.character(.figure_coalesce(high_payload$meta$source, "")) else ""

  if (identical(low_source, "init") && identical(figure_safe_hex(low_hex, .figure_default_picker_hex), .figure_default_picker_hex)) {
    low_hex <- defaults[["low"]]
  }
  if (identical(high_source, "init") && identical(figure_safe_hex(high_hex, .figure_default_picker_hex), .figure_default_picker_hex)) {
    high_hex <- defaults[["high"]]
  }

  figure_normalize_gradient_colors(low = low_hex, high = high_hex, defaults = defaults)
}

figure_palette_from_payload <- function(payload, fallback = character(0)) {
  palette <- if (is.list(payload)) payload$palette else payload
  source <- if (is.list(payload) && is.list(payload$meta)) as.character(.figure_coalesce(payload$meta$source, "")) else ""
  palette <- .figure_safe_upper(palette, character(0))
  palette <- palette[grepl("^#[0-9A-F]{6}$", palette)]
  fallback <- .figure_safe_upper(fallback, character(0))
  fallback <- fallback[grepl("^#[0-9A-F]{6}$", fallback)]

  if (identical(source, "init") &&
      length(palette) &&
      identical(unname(palette), unname(.figure_default_picker_palette)) &&
      length(fallback)) {
    return(fallback)
  }

  if (length(palette)) return(palette)

  fallback
}

figure_gradient_swatches_ui <- function(colors) {
  colors <- figure_normalize_gradient_colors(
    low = colors[["low"]],
    high = colors[["high"]],
    defaults = colors
  )

  shiny::tags$div(
    style = "display:flex;gap:8px;align-items:center;",
    lapply(unname(colors), function(clr) {
      shiny::tags$div(
        title = clr,
        style = sprintf(
          "width:34px;height:20px;border-radius:999px;background:%s;border:1px solid #CBD5E1;",
          clr
        )
      )
    })
  )
}

figure_palette_swatches_ui <- function(colors) {
  colors <- .figure_safe_upper(colors, character(0))
  colors <- colors[grepl("^#[0-9A-F]{6}$", colors)]

  if (!length(colors)) {
    return(shiny::tags$div(style = "color:#6b7280;font-size:0.9em;", "No palette selected"))
  }

  shiny::tags$div(
    style = "display:flex;flex-wrap:wrap;gap:6px;align-items:center;",
    lapply(colors, function(clr) {
      shiny::tags$div(
        title = clr,
        style = sprintf(
          "width:22px;height:22px;border-radius:6px;background:%s;border:1px solid rgba(148,163,184,.42);",
          clr
        )
      )
    })
  )
}

figure_color_card_ui <- function(title,
                                 subtitle = NULL,
                                 swatch_ui,
                                 button_id,
                                 button_label,
                                 note = NULL) {
  shiny::tags$div(
    class = "well",
    style = "margin-bottom:0;",
    shiny::tags$div(
      style = "display:flex;justify-content:space-between;align-items:flex-start;gap:12px;",
      shiny::tags$div(
        style = "min-width:0;flex:1 1 auto;",
        shiny::tags$strong(title),
        if (!is.null(subtitle)) shiny::tags$div(
          style = "margin-top:4px;color:#6b7280;font-size:0.9em;",
          subtitle
        )
      ),
      shiny::actionButton(button_id, button_label, class = "btn btn-primary btn-sm")
    ),
    shiny::tags$div(style = "margin-top:10px;", swatch_ui),
    if (!is.null(note)) shiny::tags$div(
      style = "margin-top:8px;color:#6b7280;font-size:0.85em;",
      note
    )
  )
}

figure_dark_modal_dialog <- function(...) {
  htmltools::tagAppendAttributes(
    shiny::modalDialog(...),
    class = "figure-modal-dark-dialog"
  )
}

figure_picker_modal_footer <- function(reset_id, apply_id, apply_label = "Apply") {
  shiny::tagList(
    shiny::actionButton(reset_id, "Reset", class = "btn btn-outline-secondary"),
    shiny::modalButton("Cancel"),
    shiny::actionButton(apply_id, apply_label, class = "btn btn-primary")
  )
}

figure_two_color_modal_body <- function(low_picker_id,
                                        high_picker_id,
                                        low_hex,
                                        high_hex,
                                        low_label = "Low color",
                                        high_label = "High color") {
  shiny::fluidRow(
    shiny::column(
      6,
      motion_color_picker_ui(
        low_picker_id,
        label = low_label,
        mode = "single",
        initial_hex = figure_safe_hex(low_hex, "#D3D3D3"),
        initial_alpha = 1
      )
    ),
    shiny::column(
      6,
      motion_color_picker_ui(
        high_picker_id,
        label = high_label,
        mode = "single",
        initial_hex = figure_safe_hex(high_hex, "#FF0000"),
        initial_alpha = 1
      )
    )
  )
}

figure_curve_palette_modal_body <- function(picker_id,
                                            initial_hex,
                                            palette_n,
                                            interpolation = "hsl",
                                            label = "Curve palette") {
  curve_color_picker_ui(
    picker_id,
    label = label,
    mode = "palette",
    initial_hex = figure_safe_hex(initial_hex, "#3B82F6"),
    palette_n = max(2L, min(16L, suppressWarnings(as.integer(.figure_coalesce(palette_n, 6L))))),
    interpolation = as.character(.figure_coalesce(interpolation, "hsl"))
  )
}
