# Figure Studio: paired UMAP and quantification workspace.
# One settled workspace state drives preview, quantification, comparison, and
# export so all rendered outputs use the same object and color branch.

FIGURE_UMAP_UI_TEXT <- list(
  title = "UMAP + Quantification",
  subtitle = "Build one paired UMAP and quantification figure from the active object.",
  view_mode = "1. View mode",
  data_context = "2. Data context",
  active_object = "Active object",
  embedding = "Embedding",
  camera = "3D camera",
  azimuth = "Azimuth",
  elevation = "Elevation",
  camera_distance = "Camera distance",
  apply_camera = "Use current 3D view",
  projection = "Projection",
  orthographic = "Orthographic",
  perspective = "Perspective",
  show_axes = "Show axes",
  color_mode = "3. Color by",
  metadata = "Metadata / Cluster",
  gene = "Gene expression",
  rgb = "RGB",
  tcr = "TCR",
  metadata_field = "Metadata field",
  palette = "Discrete palette",
  assay = "Assay",
  gene_field = "Gene",
  expression_source = "Expression source",
  normalized_data = "Normalized data",
  scaled_data = "Scaled data",
  raw_counts = "Raw counts",
  continuous_palette = "Continuous palette",
  gray_red = "Gray to Red",
  blue_yellow = "Blue to Yellow",
  viridis = "Viridis",
  red_gene = "Red gene",
  green_gene = "Green gene",
  blue_gene = "Blue gene",
  rgb_quant_component = "RGB quantification component",
  tcr_clone_field = "Clone field",
  tcr_display = "TCR display",
  clone_id = "Clone ID",
  clone_size = "Clone size",
  tcr_status = "TCR detection status",
  layout = "4. UMAP layout",
  split_column = "Split UMAP by (columns)",
  split_row = "Split UMAP by (rows)",
  legend_position = "Legend position",
  legend_columns = "Legend columns",
  annotate = "Annotate populations",
  overlay = "5. Trajectory overlay",
  overlay_source = "Overlay source",
  overlay_none = "None",
  overlay_monocle2 = "Monocle2 trajectory",
  overlay_monocle3 = "Monocle3 trajectory",
  overlay_velocity = "RNA velocity",
  overlay_diagnostic = "Overlay availability",
  overlay_monocle_cells = "Show pseudotime cells",
  overlay_monocle_graph = "Show principal graph",
  overlay_graph_width = "Graph width",
  overlay_graph_alpha = "Graph opacity",
  overlay_monocle_color = "Cell color",
  overlay_preserve_colors = "Preserve UMAP colors",
  overlay_pseudotime_colors = "Pseudotime",
  overlay_annotation_colors = "Annotation",
  overlay_palette_source = "Annotation palette",
  overlay_palette_metadata = "Metadata palette",
  overlay_palette_manual = "Manual palette",
  overlay_manual_palette = "Manual palette map (JSON)",
  overlay_label_groups = "Label cell groups",
  overlay_label_leaves = "Label leaves",
  overlay_label_branches = "Label branch points",
  overlay_velocity_scale = "Arrow scale",
  overlay_velocity_width = "Arrow width",
  overlay_velocity_alpha = "Arrow opacity",
  overlay_velocity_color = "Arrow color",
  overlay_velocity_single = "Single color",
  overlay_velocity_group = "Group",
  overlay_velocity_model = "Velocity model",
  overlay_velocity_pc = "PC count",
  overlay_velocity_mode = "Display mode",
  overlay_velocity_point = "Point only",
  overlay_velocity_stream = "Stream",
  overlay_velocity_grid = "Grid",
  overlay_velocity_sparse_grid = "Sparse grid",
  overlay_velocity_small_arrows = "Small arrows",
  overlay_velocity_latent = "Latent time",
  overlay_velocity_point_size = "Point size",
  overlay_velocity_grid_density = "Grid density",
  overlay_velocity_grid_width = "Grid arrow width",
  overlay_velocity_grid_size = "Grid arrow size",
  overlay_velocity_grid_length = "Grid arrow length",
  overlay_velocity_small_density = "Small grid density",
  overlay_velocity_small_width = "Small arrow width",
  overlay_velocity_small_size = "Small arrow size",
  overlay_velocity_small_length = "Small arrow length",
  overlay_velocity_stream_density = "Stream density",
  overlay_velocity_stream_size = "Stream arrow size",
  overlay_velocity_stream_max = "Stream max length",
  overlay_velocity_stream_linewidth = "Stream linewidth",
  quantification = "6. Quantification",
  include_quantification = "Include quantification",
  quant_target = "Quantify",
  same_as_color = "Same as Color by",
  explicit_metadata = "Metadata field",
  quant_field = "Quantification field",
  group_by = "Group by",
  split_by = "Split by",
  same_as_umap = "Same as UMAP split",
  none = "None",
  chart_type = "Chart type",
  auto = "Auto",
  composition = "Composition",
  alluvial = "Alluvial",
  violin = "Violin",
  box = "Box",
  dot = "Dot",
  value_unit = "Value",
  count = "Cell count",
  percentage = "Percentage",
  alluvial_axes = "Alluvial axes (ordered)",
  alluvial_axis_1 = "Axis 1",
  alluvial_axis_2 = "Axis 2",
  alluvial_axis_3 = "Axis 3 (optional)",
  alluvial_axis_4 = "Axis 4 (optional)",
  alluvial_color_axis = "Ribbon color by",
  alluvial_axis_1_choice = "Axis 1",
  alluvial_axis_2_choice = "Axis 2",
  alluvial_axis_3_choice = "Axis 3",
  alluvial_axis_4_choice = "Axis 4",
  alluvial_node_order = "Node ordering",
  alluvial_data_order = "Data order",
  alluvial_alphabetical = "Alphabetical",
  alluvial_abundance = "Abundance",
  alluvial_show_labels = "Show stratum labels",
  alluvial_ribbon_alpha = "Ribbon opacity",
  alluvial_ribbon_width = "Ribbon width",
  alluvial_percentage_note = "Percentage uses all cells within each quantification split facet as denominator.",
  alluvial_metadata_note = "Alluvial uses ordered metadata axes and cell counts; Quantify controls apply to other chart types.",
  alluvial_interactive_note = "Alluvial quantification uses the static preview and export path. Select Static export composition for paired 3D output.",
  comparison = "7. Comparison",
  comparison_mode = "Comparison mode",
  single_pair = "Single pair",
  two_pairs = "Two paired panels",
  comparison_object = "Comparison object",
  comparison_layout = "Arrangement",
  side_by_side = "Side by side",
  stacked = "Stacked",
  appearance = "8. Appearance",
  plot_title = "Plot title",
  typography = "Typography mode",
  fixed_typography = "Fixed typography / adaptive canvas",
  proportional_typography = "Proportional figure scaling",
  shared_settings = "Shared plot settings",
  export = "9. Export",
  export_composition = "Composition",
  paired = "UMAP + Quantification",
  umap_only = "UMAP only",
  quant_only = "Quantification only",
  pair_layout = "Pair layout",
  vertical = "Vertical",
  horizontal = "Horizontal",
  width = "Width",
  height = "Height",
  dpi = "Dpi",
  units = "Units",
  format = "Format",
  png = "PNG",
  svg = "SVG",
  pdf = "PDF",
  html = "HTML",
  apply_preview = "Apply Preview",
  download_pdf = "Download PDF",
  download_svg = "Download SVG",
  preview = "Preview",
  preview_renderer = "Preview renderer",
  interactive_preview = "Interactive (3D only)",
  static_preview = "Static export composition",
  focus = "Preview focus",
  focus_pair = "UMAP + Quantification",
  focus_umap = "UMAP only",
  focus_quant = "Quantification only",
  diagnostics = "Diagnostics",
  code = "Generated code",
  copy_code = "Copy Code",
  editable_code = "Editable R code",
  unavailable_modes = "The selected color mode cannot render with the settled active object.",
  unavailable_3d = "The selected embedding does not provide at least three dimensions for 3D rendering.",
  plotly_unavailable = "Interactive 3D rendering requires the existing plotly runtime package.",
  tcr_unavailable = "The active object has no usable TCR clone metadata.",
  rgb_invalid = "RGB mode requires three distinct genes available in the selected assay.",
  gene_invalid = "Gene expression mode requires a gene available in the selected assay.",
  no_object = "Select an active object with a usable embedding.",
  no_metadata = "The active object has no metadata fields available for coloring.",
  code_note = "The recipe records the active object, color branch, trajectory overlay, paired quantification, comparison, and export settings."
)

figure_umap_camera_panel_id <- function(mode = "none", column = "All cells", row = "All cells", prefix = "") {
  use_or <- function(a, b) if (!is.null(a)) a else b
  mode <- as.character(use_or(mode, "none"))[[1]]
  column <- as.character(use_or(column, "All cells"))[[1]]
  row <- as.character(use_or(row, "All cells"))[[1]]
  paste0(prefix, mode, "::", jsonlite::toJSON(list(column = column, row = row), auto_unbox = TRUE, null = "null"))
}

figure_umap_split_panel_specs <- function(cells, split_mode = "none", column_values = NULL, row_values = NULL, prefix = "") {
  use_or <- function(a, b) if (!is.null(a)) a else b
  cells <- as.character(use_or(cells, character(0)))
  n <- length(cells)
  column_values <- as.character(use_or(column_values, rep("All cells", n)))
  row_values <- as.character(use_or(row_values, rep("All cells", n)))
  if (length(column_values) != n || length(row_values) != n) stop("Split panel values must match embedding cells.", call. = FALSE)
  mode <- as.character(use_or(split_mode, "none"))[[1]]
  if (identical(mode, "none")) return(list(list(id = figure_umap_camera_panel_id(mode, prefix = prefix), label = "", cells = cells, column = "All cells", row = "All cells")))
  ordered_levels <- function(x) unique(x[!is.na(x) & nzchar(x)])
  col_levels <- ordered_levels(column_values)
  row_levels <- ordered_levels(row_values)
  specs <- list()
  add_spec <- function(column, row, label) {
    keep <- if (identical(mode, "column")) column_values == column else if (identical(mode, "row")) row_values == row else column_values == column & row_values == row
    keep[is.na(keep)] <- FALSE
    if (!any(keep)) return(invisible(NULL))
    specs[[length(specs) + 1L]] <<- list(
      id = figure_umap_camera_panel_id(mode, column = column, row = row, prefix = prefix),
      label = label,
      cells = cells[keep],
      column = column,
      row = row
    )
    invisible(NULL)
  }
  if (identical(mode, "column")) {
    for (column in col_levels) add_spec(column, "All rows", paste0("Column: ", column))
  } else if (identical(mode, "row")) {
    for (row in row_levels) add_spec("All columns", row, paste0("Row: ", row))
  } else {
    for (row in row_levels) for (column in col_levels) add_spec(column, row, paste0("Column: ", column, " | Row: ", row))
  }
  if (length(specs)) specs else list(list(id = figure_umap_camera_panel_id(mode, prefix = prefix), label = "", cells = cells, column = "All cells", row = "All cells"))
}

figure_umap_camera_for_panel <- function(camera_state, panel_id, fallback = list()) {
  use_or <- function(a, b) if (!is.null(a)) a else b
  camera_state <- use_or(camera_state, list())
  panels <- camera_state$panels
  panel <- if (is.list(panels)) panels[[panel_id]] else NULL
  if (is.null(panel) && is.list(panels)) {
    base_id <- sub("^[^:]+::", "", as.character(use_or(panel_id, "")))
    panel <- use_or(panels[[base_id]], use_or(panels[["none::{\"column\":\"All cells\",\"row\":\"All cells\"}"]], panels[["__all__"]]))
  }
  if (is.list(panel)) utils::modifyList(use_or(fallback, list()), panel) else use_or(fallback, list())
}

figure_umap_camera_event_map <- function(payload, panel_ids, existing = list()) {
  use_or <- function(a, b) if (!is.null(a)) a else b
  cameras <- if (is.list(payload) && is.list(payload$cameras)) payload$cameras else payload
  panel_ids <- as.character(use_or(panel_ids, character(0)))
  if (!is.list(cameras) || !length(cameras)) stop("Use current 3D view requires a captured Plotly camera.", call. = FALSE)
  if (is.null(names(cameras)) || any(!nzchar(names(cameras)))) stop("Captured Plotly camera is missing split-panel identity.", call. = FALSE)
  unknown <- setdiff(names(cameras), panel_ids)
  if (length(unknown)) stop("Captured Plotly camera contains an unknown split panel.", call. = FALSE)
  out <- use_or(existing, list())
  for (panel_id in names(cameras)) {
    camera <- cameras[[panel_id]]
    eye <- use_or(camera$eye, NULL)
    if (!is.list(eye) || !all(c("x", "y", "z") %in% names(eye))) stop("Captured Plotly camera has no complete eye position.", call. = FALSE)
    eye_values <- suppressWarnings(as.numeric(unlist(eye[c("x", "y", "z")], use.names = FALSE)))
    if (length(eye_values) != 3L || any(!is.finite(eye_values))) stop("Captured Plotly camera eye position is invalid.", call. = FALSE)
    out[[panel_id]] <- camera
  }
  out
}

figure_umap_camera_slider_values <- function(camera, distance_scale = 1.6) {
  eye <- if (!is.null(camera)) camera$eye else NULL
  if (!is.list(eye) || !all(c("x", "y", "z") %in% names(eye))) stop("Captured Plotly camera has no complete eye position.", call. = FALSE)
  xyz <- suppressWarnings(as.numeric(unlist(eye[c("x", "y", "z")], use.names = FALSE)))
  if (length(xyz) != 3L || any(!is.finite(xyz))) stop("Captured Plotly camera eye position is invalid.", call. = FALSE)
  horizontal <- sqrt(xyz[[1]]^2 + xyz[[2]]^2)
  list(
    azimuth = atan2(xyz[[2]], xyz[[1]]) * 180 / pi,
    elevation = atan2(xyz[[3]], horizontal) * 180 / pi,
    distance = sqrt(sum(xyz^2)) * distance_scale
  )
}

figure_umap_select_composition_plot <- function(bundle, composition = "paired") {
  composition <- as.character(if (is.null(composition)) "paired" else composition)[[1]]
  if (identical(composition, "umap")) bundle$umap else if (identical(composition, "quant")) bundle$quant else bundle$composition
}

figure_umap_prepare_alluvial_data <- function(metadata, axes, split = NULL, unit = "count", node_order = "data") {
  # Agent note: percentage weights use all cells in each split facet as the
  # denominator so every facet is independently comparable and reproducible.
  if (!is.data.frame(metadata)) stop("Alluvial metadata must be a data frame.", call. = FALSE)
  axes <- as.character(axes)
  axes <- axes[!is.na(axes) & nzchar(trimws(axes)) & axes != "__none__"]
  if (length(axes) < 2L || length(axes) > 4L) stop("Alluvial requires two to four ordered metadata axes.", call. = FALSE)
  if (anyDuplicated(axes)) stop("Alluvial axes must be distinct metadata fields.", call. = FALSE)
  missing_axes <- setdiff(axes, colnames(metadata))
  if (length(missing_axes)) stop(paste0("Alluvial axis field is not available: ", paste(missing_axes, collapse = ", ")), call. = FALSE)
  unit <- as.character(if (is.null(unit)) "count" else unit)[[1]]
  if (!(unit %in% c("count", "percentage"))) stop("Alluvial value unit must be count or percentage.", call. = FALSE)
  node_order <- as.character(if (is.null(node_order)) "data" else node_order)[[1]]
  if (!(node_order %in% c("data", "alphabetical", "abundance"))) stop("Alluvial node ordering is invalid.", call. = FALSE)
  split_name <- if (is.null(split) || !length(split)) "" else as.character(split)[[1]]
  if (split_name %in% c("", "__none__", "same_as_umap")) split_name <- ""
  if (nzchar(split_name) && !(split_name %in% colnames(metadata))) stop(paste0("Alluvial split field is not available: ", split_name), call. = FALSE)
  if (!nrow(metadata)) stop("Alluvial requires at least one metadata row.", call. = FALSE)

  clean <- function(value) {
    out <- as.character(value)
    out[is.na(out) | !nzchar(trimws(out))] <- "NA"
    out
  }
  rows <- as.data.frame(lapply(axes, function(axis) clean(metadata[[axis]])), stringsAsFactors = FALSE)
  colnames(rows) <- axes
  rows$split <- if (nzchar(split_name)) clean(metadata[[split_name]]) else rep("All cells", nrow(metadata))
  key <- do.call(paste, c(lapply(rows[axes], as.character), list(rows$split), sep = "\r"))
  first <- !duplicated(key)
  group_id <- match(key, key[first])
  flow <- rows[first, c("split", axes), drop = FALSE]
  flow$n_cells <- as.numeric(tabulate(group_id, nbins = sum(first)))
  flow$denominator <- ave(flow$n_cells, flow$split, FUN = sum)
  flow$weight <- if (identical(unit, "percentage")) 100 * flow$n_cells / flow$denominator else flow$n_cells
  flow$flow_id <- seq_len(nrow(flow))

  node_levels <- stats::setNames(lapply(axes, function(axis) {
    values <- unique(rows[[axis]])
    if (identical(node_order, "alphabetical")) return(sort(values))
    if (identical(node_order, "abundance")) {
      totals <- tapply(flow$n_cells, flow[[axis]], sum)
      return(names(totals)[order(-as.numeric(totals), names(totals))])
    }
    values
  }), axes)
  stratum_levels <- unlist(lapply(axes, function(axis) paste0(axis, "::", node_levels[[axis]])), use.names = FALSE)
  lodes <- do.call(rbind, lapply(seq_along(axes), function(i) {
    axis <- axes[[i]]
    data.frame(
      axis = axis,
      stratum_key = paste0(axis, "::", as.character(flow[[axis]])),
      stratum_label = as.character(flow[[axis]]),
      alluvium = as.character(flow$flow_id),
      split = flow$split,
      weight = flow$weight,
      n_cells = flow$n_cells,
      denominator = flow$denominator,
      stringsAsFactors = FALSE
    )
  }))
  lodes$axis <- factor(lodes$axis, levels = axes)
  lodes$stratum_key <- factor(lodes$stratum_key, levels = stratum_levels)
  list(flow = flow, lodes = lodes, axes = axes, split = if (nzchar(split_name)) split_name else NULL, unit = unit, node_order = node_order, node_levels = node_levels)
}

FIGURE_UMAP_CAMERA_CAPTURE_JS <- "
function(el, x, data) {
  if (!window.Plotly || !el || !el.on || !window.Shiny) return;
  var panels = (data && data.panels) || [];
  var known = (data && data.initial_cameras) || {};
  var clone = function(value) {
    if (value === undefined || value === null) return value;
    return JSON.parse(JSON.stringify(value));
  };
  var setPath = function(target, path, value) {
    var cursor = target;
    for (var i = 0; i < path.length - 1; i++) cursor = cursor[path[i]] || (cursor[path[i]] = {});
    cursor[path[path.length - 1]] = clone(value);
  };
  el.on('plotly_relayout', function(ev) {
    if (!ev || typeof ev !== 'object') return;
    var next = clone(known) || {};
    Object.keys(ev).forEach(function(key) {
      var match = key.match(/^scene([0-9]*)\\.camera(?:\\.(.*))?$/);
      if (!match) return;
      var index = match[1] ? Number(match[1]) - 1 : 0;
      var panel = panels[index];
      if (!panel) return;
      if (!match[2]) next[panel] = clone(ev[key]);
      else {
        next[panel] = next[panel] || {};
        setPath(next[panel], match[2].split('.'), ev[key]);
      }
    });
    var captured = {};
    panels.forEach(function(panel) { if (next[panel]) captured[panel] = next[panel]; });
    if (!Object.keys(captured).length) return;
    known = clone(captured);
    window.Shiny.setInputValue(data.input_id, {event: 'plotly_relayout', cameras: captured, panels: panels}, {priority: 'event'});
  });
}
"

library(scales)
source("interface/figures/color_palettes.R")

figure_umap_ui <- fluidPage(
  tags$head(
    figure_busy_spinner_assets,
    if (is.function(get0("wl_pdf_modal_assets", mode = "function", ifnotfound = NULL))) wl_pdf_modal_assets() else NULL
  ),
  div(
    class = "page-header",
    h2(icon("area-chart"), " ", FIGURE_UMAP_UI_TEXT$title),
    p(FIGURE_UMAP_UI_TEXT$subtitle)
  ),
  hr(),
  sidebarLayout(
    sidebarPanel(
      width = 4,
      class = "plotting-left-panel",
      div(
        class = "wl-side",
        h4("Figure Studio"),
        radioButtons(
          "figure_umap_view_mode",
          FIGURE_UMAP_UI_TEXT$view_mode,
          choices = c("2D" = "2d", "3D" = "3d"),
          selected = "2d",
          inline = TRUE
        ),

        h5(FIGURE_UMAP_UI_TEXT$data_context),
        wl_object_selector_ui("figure_umap_dataset_select", FIGURE_UMAP_UI_TEXT$active_object),
        selectInput("figure_umap_reduction", FIGURE_UMAP_UI_TEXT$embedding, choices = character(0)),
        conditionalPanel(
          "input.figure_umap_view_mode == '3d'",
          h5(FIGURE_UMAP_UI_TEXT$camera),
          sliderInput("figure_umap_camera_azimuth", FIGURE_UMAP_UI_TEXT$azimuth, min = -180, max = 180, value = 35, step = 0.1),
          sliderInput("figure_umap_camera_elevation", FIGURE_UMAP_UI_TEXT$elevation, min = -90, max = 90, value = 25, step = 0.1),
          sliderInput("figure_umap_camera_distance", FIGURE_UMAP_UI_TEXT$camera_distance, min = 0.5, max = 3, value = 1.6, step = 0.01),
          selectInput(
            "figure_umap_camera_projection",
            FIGURE_UMAP_UI_TEXT$projection,
            choices = stats::setNames(c("orthographic", "perspective"), c(FIGURE_UMAP_UI_TEXT$orthographic, FIGURE_UMAP_UI_TEXT$perspective)),
            selected = "perspective"
          ),
          checkboxInput("figure_umap_camera_axes", FIGURE_UMAP_UI_TEXT$show_axes, value = TRUE),
          actionButton("figure_umap_apply_camera", FIGURE_UMAP_UI_TEXT$apply_camera, class = "btn btn-default")
        ),
        uiOutput("figure_umap_context_diagnostics"),

        h5(FIGURE_UMAP_UI_TEXT$color_mode),
        radioButtons(
          "figure_umap_color_mode",
          NULL,
          choices = stats::setNames(
            c("metadata", "gene", "rgb", "tcr"),
            c(FIGURE_UMAP_UI_TEXT$metadata, FIGURE_UMAP_UI_TEXT$gene, FIGURE_UMAP_UI_TEXT$rgb, FIGURE_UMAP_UI_TEXT$tcr)
          ),
          selected = "metadata",
          inline = TRUE
        ),
        conditionalPanel(
          "input.figure_umap_color_mode == 'metadata'",
          selectInput("figure_umap_colorby_select", FIGURE_UMAP_UI_TEXT$metadata_field, choices = character(0)),
          selectInput("figure_umap_palette", FIGURE_UMAP_UI_TEXT$palette, choices = c("Default Seurat"))
        ),
        conditionalPanel(
          "input.figure_umap_color_mode == 'gene'",
          selectInput("figure_umap_gene_assay", FIGURE_UMAP_UI_TEXT$assay, choices = character(0)),
          wl_gene_selectize_input("figure_umap_gene_select", FIGURE_UMAP_UI_TEXT$gene_field, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, defer_choices = TRUE),
          selectInput(
            "figure_umap_gene_layer",
            FIGURE_UMAP_UI_TEXT$expression_source,
            choices = stats::setNames(c("data", "scale.data", "counts"), c(FIGURE_UMAP_UI_TEXT$normalized_data, FIGURE_UMAP_UI_TEXT$scaled_data, FIGURE_UMAP_UI_TEXT$raw_counts)),
            selected = "data"
          ),
          selectInput(
            "figure_umap_gene_palette",
            FIGURE_UMAP_UI_TEXT$continuous_palette,
            choices = stats::setNames(c("gray_red", "blue_yellow", "viridis"), c(FIGURE_UMAP_UI_TEXT$gray_red, FIGURE_UMAP_UI_TEXT$blue_yellow, FIGURE_UMAP_UI_TEXT$viridis)),
            selected = "gray_red"
          )
        ),
        conditionalPanel(
          "input.figure_umap_color_mode == 'rgb'",
          selectInput("figure_umap_rgb_assay", FIGURE_UMAP_UI_TEXT$assay, choices = character(0)),
          wl_gene_selectize_input("figure_umap_rgb_red", FIGURE_UMAP_UI_TEXT$red_gene, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, defer_choices = TRUE),
          wl_gene_selectize_input("figure_umap_rgb_green", FIGURE_UMAP_UI_TEXT$green_gene, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, defer_choices = TRUE),
          wl_gene_selectize_input("figure_umap_rgb_blue", FIGURE_UMAP_UI_TEXT$blue_gene, placeholder = "Type to search gene", min_chars = 0L, open_on_focus = TRUE, preload = TRUE, defer_choices = TRUE),
          selectInput(
            "figure_umap_rgb_layer",
            FIGURE_UMAP_UI_TEXT$expression_source,
            choices = stats::setNames(c("data", "scale.data", "counts"), c(FIGURE_UMAP_UI_TEXT$normalized_data, FIGURE_UMAP_UI_TEXT$scaled_data, FIGURE_UMAP_UI_TEXT$raw_counts)),
            selected = "data"
          )
        ),
        conditionalPanel(
          "input.figure_umap_color_mode == 'tcr'",
          selectInput("figure_umap_tcr_clone_field", FIGURE_UMAP_UI_TEXT$tcr_clone_field, choices = character(0)),
          selectInput(
            "figure_umap_tcr_display",
            FIGURE_UMAP_UI_TEXT$tcr_display,
            choices = stats::setNames(c("clone", "clone_size", "status"), c(FIGURE_UMAP_UI_TEXT$clone_id, FIGURE_UMAP_UI_TEXT$clone_size, FIGURE_UMAP_UI_TEXT$tcr_status)),
            selected = "clone_size"
          ),
          selectInput("figure_umap_tcr_palette", FIGURE_UMAP_UI_TEXT$palette, choices = c("Default Seurat"), selected = "Default Seurat")
        ),

        h5(FIGURE_UMAP_UI_TEXT$layout),
        selectInput("figure_umap_column_split", FIGURE_UMAP_UI_TEXT$split_column, choices = c("None" = "__none__")),
        selectInput("figure_umap_row_split", FIGURE_UMAP_UI_TEXT$split_row, choices = c("None" = "__none__")),
        selectInput(
          "figure_umap_legend_position",
          FIGURE_UMAP_UI_TEXT$legend_position,
          choices = c("Right" = "right", "Top" = "top", "Bottom" = "bottom", "None" = "none"),
          selected = "right"
        ),
        sliderInput("figure_umap_legend_cols", FIGURE_UMAP_UI_TEXT$legend_columns, min = 1, max = 8, value = 4, step = 1),
        checkboxInput("figure_umap_annotate_populations", FIGURE_UMAP_UI_TEXT$annotate, value = FALSE),

        h5(FIGURE_UMAP_UI_TEXT$overlay),
        selectInput(
          "figure_umap_overlay_source",
          FIGURE_UMAP_UI_TEXT$overlay_source,
          choices = stats::setNames(c("none", "monocle2", "monocle3", "rna_velocity"), c(FIGURE_UMAP_UI_TEXT$overlay_none, FIGURE_UMAP_UI_TEXT$overlay_monocle2, FIGURE_UMAP_UI_TEXT$overlay_monocle3, FIGURE_UMAP_UI_TEXT$overlay_velocity)),
          selected = "none"
        ),
        uiOutput("figure_umap_overlay_diagnostic"),
        conditionalPanel(
          "input.figure_umap_overlay_source == 'monocle2' || input.figure_umap_overlay_source == 'monocle3'",
          checkboxInput("figure_umap_overlay_monocle_cells", FIGURE_UMAP_UI_TEXT$overlay_monocle_cells, value = TRUE),
          checkboxInput("figure_umap_overlay_monocle_graph", FIGURE_UMAP_UI_TEXT$overlay_monocle_graph, value = TRUE),
          sliderInput("figure_umap_overlay_graph_width", FIGURE_UMAP_UI_TEXT$overlay_graph_width, min = 0.1, max = 2, value = 0.7, step = 0.1),
          sliderInput("figure_umap_overlay_graph_alpha", FIGURE_UMAP_UI_TEXT$overlay_graph_alpha, min = 0.1, max = 1, value = 0.8, step = 0.05),
          selectInput("figure_umap_overlay_monocle_color", FIGURE_UMAP_UI_TEXT$overlay_monocle_color, choices = stats::setNames(c("annotation", "pseudotime", "preserve"), c(FIGURE_UMAP_UI_TEXT$overlay_annotation_colors, FIGURE_UMAP_UI_TEXT$overlay_pseudotime_colors, FIGURE_UMAP_UI_TEXT$overlay_preserve_colors)), selected = "annotation")
          ,selectInput("figure_umap_overlay_monocle_palette_source", FIGURE_UMAP_UI_TEXT$overlay_palette_source, choices = stats::setNames(c("metadata", "manual"), c(FIGURE_UMAP_UI_TEXT$overlay_palette_metadata, FIGURE_UMAP_UI_TEXT$overlay_palette_manual)), selected = "metadata")
          ,textAreaInput("figure_umap_overlay_monocle_manual_palette", FIGURE_UMAP_UI_TEXT$overlay_manual_palette, value = "{}", rows = 2)
          ,checkboxInput("figure_umap_overlay_monocle_label_groups", FIGURE_UMAP_UI_TEXT$overlay_label_groups, value = FALSE)
          ,checkboxInput("figure_umap_overlay_monocle_label_leaves", FIGURE_UMAP_UI_TEXT$overlay_label_leaves, value = FALSE)
          ,checkboxInput("figure_umap_overlay_monocle_label_branches", FIGURE_UMAP_UI_TEXT$overlay_label_branches, value = FALSE)
        ),
        conditionalPanel(
          "input.figure_umap_overlay_source == 'rna_velocity'",
          sliderInput("figure_umap_overlay_velocity_scale", FIGURE_UMAP_UI_TEXT$overlay_velocity_scale, min = 0.1, max = 4, value = 1, step = 0.1),
          sliderInput("figure_umap_overlay_velocity_width", FIGURE_UMAP_UI_TEXT$overlay_velocity_width, min = 0.1, max = 2, value = 0.6, step = 0.1),
          sliderInput("figure_umap_overlay_velocity_alpha", FIGURE_UMAP_UI_TEXT$overlay_velocity_alpha, min = 0.1, max = 1, value = 0.55, step = 0.05),
          selectInput("figure_umap_overlay_velocity_color", FIGURE_UMAP_UI_TEXT$overlay_velocity_color, choices = stats::setNames(c("single", "group"), c(FIGURE_UMAP_UI_TEXT$overlay_velocity_single, FIGURE_UMAP_UI_TEXT$overlay_velocity_group)), selected = "single"),
          selectInput("figure_umap_overlay_velocity_model", FIGURE_UMAP_UI_TEXT$overlay_velocity_model, choices = c("stochastic", "dynamical"), selected = "stochastic"),
          numericInput("figure_umap_overlay_velocity_pc", FIGURE_UMAP_UI_TEXT$overlay_velocity_pc, value = 11, min = 2, max = 100),
          selectInput("figure_umap_overlay_velocity_mode", FIGURE_UMAP_UI_TEXT$overlay_velocity_mode, choices = stats::setNames(c("point", "small_arrows", "grid", "sparse_grid", "stream"), c(FIGURE_UMAP_UI_TEXT$overlay_velocity_point, FIGURE_UMAP_UI_TEXT$overlay_velocity_small_arrows, FIGURE_UMAP_UI_TEXT$overlay_velocity_grid, FIGURE_UMAP_UI_TEXT$overlay_velocity_sparse_grid, FIGURE_UMAP_UI_TEXT$overlay_velocity_stream)), selected = "point"),
          checkboxInput("figure_umap_overlay_velocity_latent", FIGURE_UMAP_UI_TEXT$overlay_velocity_latent, value = FALSE),
          numericInput("figure_umap_overlay_velocity_point_size", FIGURE_UMAP_UI_TEXT$overlay_velocity_point_size, value = 50, min = 1),
          numericInput("figure_umap_overlay_velocity_grid_density", FIGURE_UMAP_UI_TEXT$overlay_velocity_grid_density, value = 0.25, min = 0.01),
          numericInput("figure_umap_overlay_velocity_grid_width", FIGURE_UMAP_UI_TEXT$overlay_velocity_grid_width, value = 0.003, min = 0.0001),
          numericInput("figure_umap_overlay_velocity_grid_size", FIGURE_UMAP_UI_TEXT$overlay_velocity_grid_size, value = 1.4, min = 0.1),
          numericInput("figure_umap_overlay_velocity_grid_length", FIGURE_UMAP_UI_TEXT$overlay_velocity_grid_length, value = 3, min = 0.1),
          numericInput("figure_umap_overlay_velocity_small_density", FIGURE_UMAP_UI_TEXT$overlay_velocity_small_density, value = 0.25, min = 0.01),
          numericInput("figure_umap_overlay_velocity_small_width", FIGURE_UMAP_UI_TEXT$overlay_velocity_small_width, value = 0.0025, min = 0.0001),
          numericInput("figure_umap_overlay_velocity_small_size", FIGURE_UMAP_UI_TEXT$overlay_velocity_small_size, value = 1.1, min = 0.1),
          numericInput("figure_umap_overlay_velocity_small_length", FIGURE_UMAP_UI_TEXT$overlay_velocity_small_length, value = 2.5, min = 0.1),
          numericInput("figure_umap_overlay_velocity_stream_density", FIGURE_UMAP_UI_TEXT$overlay_velocity_stream_density, value = 2, min = 0.01),
          numericInput("figure_umap_overlay_velocity_stream_size", FIGURE_UMAP_UI_TEXT$overlay_velocity_stream_size, value = 1, min = 0.1),
          numericInput("figure_umap_overlay_velocity_stream_max", FIGURE_UMAP_UI_TEXT$overlay_velocity_stream_max, value = 4, min = 0.1),
          numericInput("figure_umap_overlay_velocity_stream_linewidth", FIGURE_UMAP_UI_TEXT$overlay_velocity_stream_linewidth, value = 1, min = 0.1)
        ),

        h5(FIGURE_UMAP_UI_TEXT$quantification),
        checkboxInput("figure_umap_include_quantification", FIGURE_UMAP_UI_TEXT$include_quantification, value = TRUE),
        radioButtons(
          "figure_umap_quant_target",
          FIGURE_UMAP_UI_TEXT$quant_target,
          choices = stats::setNames(c("same_as_color", "explicit_metadata"), c(FIGURE_UMAP_UI_TEXT$same_as_color, FIGURE_UMAP_UI_TEXT$explicit_metadata)),
          selected = "same_as_color",
          inline = TRUE
        ),
        selectInput("figure_umap_quant_field", FIGURE_UMAP_UI_TEXT$quant_field, choices = character(0)),
        selectInput("figure_umap_quant_group_by", FIGURE_UMAP_UI_TEXT$group_by, choices = character(0)),
        conditionalPanel(
          "input.figure_umap_color_mode == 'rgb'",
          selectInput("figure_umap_rgb_quant_component", FIGURE_UMAP_UI_TEXT$rgb_quant_component, choices = character(0))
        ),
        selectInput(
          "figure_umap_quant_split_by",
          FIGURE_UMAP_UI_TEXT$split_by,
          choices = stats::setNames(c("same_as_umap", "__none__"), c(FIGURE_UMAP_UI_TEXT$same_as_umap, FIGURE_UMAP_UI_TEXT$none))
        ),
        selectInput(
          "figure_umap_quant_chart",
          FIGURE_UMAP_UI_TEXT$chart_type,
          choices = stats::setNames(c("auto", "composition", "alluvial", "violin", "box", "dot"), c(FIGURE_UMAP_UI_TEXT$auto, FIGURE_UMAP_UI_TEXT$composition, FIGURE_UMAP_UI_TEXT$alluvial, FIGURE_UMAP_UI_TEXT$violin, FIGURE_UMAP_UI_TEXT$box, FIGURE_UMAP_UI_TEXT$dot)),
          selected = "auto"
        ),
        conditionalPanel(
          "input.figure_umap_quant_chart == 'alluvial'",
          tags$small(class = "text-muted", FIGURE_UMAP_UI_TEXT$alluvial_metadata_note),
          h6(FIGURE_UMAP_UI_TEXT$alluvial_axes),
          selectInput("figure_umap_quant_axis_1", FIGURE_UMAP_UI_TEXT$alluvial_axis_1, choices = character(0)),
          selectInput("figure_umap_quant_axis_2", FIGURE_UMAP_UI_TEXT$alluvial_axis_2, choices = character(0)),
          selectInput("figure_umap_quant_axis_3", FIGURE_UMAP_UI_TEXT$alluvial_axis_3, choices = stats::setNames("__none__", FIGURE_UMAP_UI_TEXT$none)),
          selectInput("figure_umap_quant_axis_4", FIGURE_UMAP_UI_TEXT$alluvial_axis_4, choices = stats::setNames("__none__", FIGURE_UMAP_UI_TEXT$none)),
          selectInput(
            "figure_umap_quant_alluvial_color_axis",
            FIGURE_UMAP_UI_TEXT$alluvial_color_axis,
            choices = stats::setNames(c("axis_1", "axis_2", "axis_3", "axis_4"), c(FIGURE_UMAP_UI_TEXT$alluvial_axis_1_choice, FIGURE_UMAP_UI_TEXT$alluvial_axis_2_choice, FIGURE_UMAP_UI_TEXT$alluvial_axis_3_choice, FIGURE_UMAP_UI_TEXT$alluvial_axis_4_choice)),
            selected = "axis_1"
          ),
          selectInput(
            "figure_umap_quant_alluvial_node_order",
            FIGURE_UMAP_UI_TEXT$alluvial_node_order,
            choices = stats::setNames(c("data", "alphabetical", "abundance"), c(FIGURE_UMAP_UI_TEXT$alluvial_data_order, FIGURE_UMAP_UI_TEXT$alluvial_alphabetical, FIGURE_UMAP_UI_TEXT$alluvial_abundance)),
            selected = "data"
          ),
          checkboxInput("figure_umap_quant_alluvial_show_labels", FIGURE_UMAP_UI_TEXT$alluvial_show_labels, value = TRUE),
          sliderInput("figure_umap_quant_alluvial_ribbon_alpha", FIGURE_UMAP_UI_TEXT$alluvial_ribbon_alpha, min = 0.1, max = 1, value = 0.65, step = 0.05),
          sliderInput("figure_umap_quant_alluvial_ribbon_width", FIGURE_UMAP_UI_TEXT$alluvial_ribbon_width, min = 0.05, max = 0.8, value = 0.15, step = 0.01),
          tags$small(class = "text-muted", FIGURE_UMAP_UI_TEXT$alluvial_percentage_note)
        ),
        selectInput(
          "figure_umap_quant_unit",
          FIGURE_UMAP_UI_TEXT$value_unit,
          choices = stats::setNames(c("count", "percentage"), c(FIGURE_UMAP_UI_TEXT$count, FIGURE_UMAP_UI_TEXT$percentage)),
          selected = "count"
        ),

        h5(FIGURE_UMAP_UI_TEXT$comparison),
        radioButtons(
          "figure_umap_comparison_mode",
          FIGURE_UMAP_UI_TEXT$comparison_mode,
          choices = stats::setNames(c("single", "two"), c(FIGURE_UMAP_UI_TEXT$single_pair, FIGURE_UMAP_UI_TEXT$two_pairs)),
          selected = "single",
          inline = TRUE
        ),
        conditionalPanel(
          "input.figure_umap_comparison_mode == 'two'",
          selectInput("figure_umap_comparison_object", FIGURE_UMAP_UI_TEXT$comparison_object, choices = character(0)),
          radioButtons(
            "figure_umap_comparison_layout",
            FIGURE_UMAP_UI_TEXT$comparison_layout,
            choices = stats::setNames(c("horizontal", "vertical"), c(FIGURE_UMAP_UI_TEXT$side_by_side, FIGURE_UMAP_UI_TEXT$stacked)),
            selected = "horizontal",
            inline = TRUE
          )
        ),

        h5(FIGURE_UMAP_UI_TEXT$appearance),
        textInput("figure_umap_title_text", FIGURE_UMAP_UI_TEXT$plot_title, value = "UMAP Projection"),
        selectInput(
          "figure_umap_typography_mode",
          FIGURE_UMAP_UI_TEXT$typography,
          choices = stats::setNames(c("fixed", "proportional"), c(FIGURE_UMAP_UI_TEXT$fixed_typography, FIGURE_UMAP_UI_TEXT$proportional_typography)),
          selected = "fixed"
        ),
        actionButton("figure_umap_open_shared_settings", FIGURE_UMAP_UI_TEXT$shared_settings, class = "btn btn-default"),
        uiOutput("figure_umap_palette_card_ui"),

        h5(FIGURE_UMAP_UI_TEXT$export),
        radioButtons(
          "figure_umap_export_composition",
          FIGURE_UMAP_UI_TEXT$export_composition,
          choices = stats::setNames(c("paired", "umap", "quant"), c(FIGURE_UMAP_UI_TEXT$paired, FIGURE_UMAP_UI_TEXT$umap_only, FIGURE_UMAP_UI_TEXT$quant_only)),
          selected = "paired"
        ),
        radioButtons(
          "figure_umap_pair_layout",
          FIGURE_UMAP_UI_TEXT$pair_layout,
          choices = stats::setNames(c("vertical", "horizontal"), c(FIGURE_UMAP_UI_TEXT$vertical, FIGURE_UMAP_UI_TEXT$horizontal)),
          selected = "vertical",
          inline = TRUE
        ),
        wellPanel(
          fluidRow(
            column(4, numericInput("figure_umap_width", FIGURE_UMAP_UI_TEXT$width, value = 10)),
            column(4, numericInput("figure_umap_height", FIGURE_UMAP_UI_TEXT$height, value = 11)),
            column(4, numericInput("figure_umap_dpi", FIGURE_UMAP_UI_TEXT$dpi, value = 300, min = 72))
          ),
          radioButtons(
            "figure_umap_units",
            FIGURE_UMAP_UI_TEXT$units,
            choices = c("Inches" = "in", "Centimeters" = "cm"),
            selected = "in",
            inline = TRUE
          )
        ),
        selectInput(
          "figure_umap_export_format",
          FIGURE_UMAP_UI_TEXT$format,
          choices = stats::setNames(c("pdf", "svg", "png", "html"), c(FIGURE_UMAP_UI_TEXT$pdf, FIGURE_UMAP_UI_TEXT$svg, FIGURE_UMAP_UI_TEXT$png, FIGURE_UMAP_UI_TEXT$html)),
          selected = "pdf"
        ),
        fluidRow(
          column(4, actionButton("figure_umap_apply_preview", FIGURE_UMAP_UI_TEXT$apply_preview, class = "btn btn-default")),
          column(4, actionButton("open_umap_pdf_modal", FIGURE_UMAP_UI_TEXT$download_pdf, class = "btn btn-default")),
          column(4, downloadButton("download_umap_export", "Download export"))
        )
      )
    ),
    mainPanel(
      width = 8,
      class = "plot_area_card_style",
      tagList(
        div(
          class = "wl-side",
          h4(FIGURE_UMAP_UI_TEXT$preview),
          radioButtons(
            "figure_umap_focus_view",
            FIGURE_UMAP_UI_TEXT$focus,
            choices = stats::setNames(c("paired", "umap", "quant"), c(FIGURE_UMAP_UI_TEXT$focus_pair, FIGURE_UMAP_UI_TEXT$focus_umap, FIGURE_UMAP_UI_TEXT$focus_quant)),
            selected = "paired",
            inline = TRUE
          ),
          radioButtons(
            "figure_umap_preview_renderer",
            FIGURE_UMAP_UI_TEXT$preview_renderer,
            choices = stats::setNames(c("interactive", "static"), c(FIGURE_UMAP_UI_TEXT$interactive_preview, FIGURE_UMAP_UI_TEXT$static_preview)),
            selected = "interactive",
            inline = TRUE
          ),
          div(
            id = "figure_umap_preview_stage",
            class = "figure-preview-stage",
            div(
              id = "figure_umap_preview_frame",
              class = "figure-preview-frame",
              uiOutput("figure_umap_plot_surface")
            )
          )
        ),
        div(class = "wl-side", h4(FIGURE_UMAP_UI_TEXT$diagnostics), uiOutput("figure_umap_diagnostics")),
        div(
          figure_code_card_ui(
            id = "figure_umap_code_card",
            title = FIGURE_UMAP_UI_TEXT$code,
            notes = FIGURE_UMAP_UI_TEXT$code_note,
            copy_button_label = FIGURE_UMAP_UI_TEXT$copy_code,
            code_label = FIGURE_UMAP_UI_TEXT$editable_code
          )
        )
      )
    )
  )
)

figure_umap_server <- function(input, output, session, shared_data) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b

  .normalize_preview_px <- function(width_raw, height_raw, units_raw = "in") {
    w <- suppressWarnings(as.numeric(width_raw %||% 10))
    h <- suppressWarnings(as.numeric(height_raw %||% 11))
    if (!is.finite(w) || w <= 0) w <- 10
    if (!is.finite(h) || h <= 0) h <- 11
    if (identical(as.character(units_raw %||% "in"), "cm")) {
      w <- w / 2.54
      h <- h / 2.54
    }
    list(width_px = as.integer(max(320, round(w * 96))), height_px = as.integer(max(240, round(h * 96))))
  }

  preview_dims <- reactiveVal(.normalize_preview_px(10, 11, "in"))
  shared_plot_settings <- figure_shared_plot_settings(session)
  figure_bind_shared_settings_inputs(input, shared_plot_settings, prefix = "figure_umap_shared")
  palette_choices <- c("Default Seurat", names(all_palettes))
  palette_signature <- reactiveVal("")
  reduction_signature <- reactiveVal("")
  color_signature <- reactiveVal("")
  quant_field_signature <- reactiveVal("")
  quant_group_signature <- reactiveVal("")
  quant_split_signature <- reactiveVal("")
  quant_axis_1_signature <- reactiveVal("")
  quant_axis_2_signature <- reactiveVal("")
  quant_axis_3_signature <- reactiveVal("")
  quant_axis_4_signature <- reactiveVal("")
  quant_alluvial_color_signature <- reactiveVal("")
  split_column_signature <- reactiveVal("")
  split_row_signature <- reactiveVal("")
  gene_assay_signature <- reactiveVal("")
  rgb_assay_signature <- reactiveVal("")
  gene_signature <- reactiveVal("")
  rgb_red_signature <- reactiveVal("")
  rgb_green_signature <- reactiveVal("")
  rgb_blue_signature <- reactiveVal("")
  rgb_quant_signature <- reactiveVal("")
  tcr_signature <- reactiveVal("")
  comparison_signature <- reactiveVal("")
  hydration_active <- new.env(parent = emptyenv())
  hydration_active$value <- FALSE
  hydrated_state <- reactiveVal(NULL)
  camera_relayout_event <- reactiveVal(NULL)
  camera_panel_state <- reactiveVal(NULL)
  context_revision <- reactiveVal(0L)
  last_context_name <- ""
  last_context_entry <- NULL
  camera_programmatic_update <- new.env(parent = emptyenv())
  camera_programmatic_update$value <- FALSE

  dataset_choices <- reactive({ names(shared_data$all_seurat_objects %||% list()) })

  canonical_object_name <- reactive({
    registry <- shared_data$all_seurat_objects %||% list()
    names_registry <- names(registry)
    if (!length(names_registry)) return("")
    current <- as.character(shared_data$active_object_name %||% "")
    current <- if (length(current)) current[[1]] else ""
    if (nzchar(current) && current %in% names_registry) return(current)
    names_registry[[length(names_registry)]]
  })

  observe({
    registry <- shared_data$all_seurat_objects %||% list()
    names_registry <- names(registry)
    current <- as.character(shared_data$active_object_name %||% "")
    current <- if (length(current)) current[[1]] else ""
    if (length(names_registry) && (!nzchar(current) || !(current %in% names_registry))) {
      shared_data$active_object_name <- names_registry[[length(names_registry)]]
    }
  })

  wl_bind_active_object_selector(
    input = input,
    session = session,
    shared_data = shared_data,
    input_id = "figure_umap_dataset_select",
    choices = dataset_choices,
    enabled = reactive(length(dataset_choices()) > 0),
    active = reactive(identical(input$main_navbar %||% "", "figure_studio_umap")),
    on_user_selection = NULL
  )

  active_object <- reactive({
    nm <- canonical_object_name()
    req(nzchar(nm))
    obj <- figure_extract_seurat_object((shared_data$all_seurat_objects %||% list())[[nm]])
    req(obj)
    obj
  })

  .reduction_choices <- function(obj) {
    nms <- tryCatch(names(obj@reductions), error = function(e) character(0))
    nms <- as.character(nms %||% character(0))
    nms[vapply(nms, function(nm) {
      emb <- tryCatch(Seurat::Embeddings(obj, reduction = nm), error = function(e) NULL)
      is.matrix(emb) && ncol(emb) >= 2L
    }, logical(1))]
  }

  .reduction_dimensions <- function(obj, reduction_name) {
    emb <- tryCatch(Seurat::Embeddings(obj, reduction = reduction_name), error = function(e) NULL)
    if (!is.matrix(emb)) 0L else ncol(emb)
  }

  .assay_choices <- function(obj) {
    assays <- tryCatch(Seurat::Assays(obj), error = function(e) character(0))
    as.character(assays %||% character(0))
  }

  .gene_choices <- function(obj, assay_name, layer_name = "data") {
    mat <- tryCatch(.figure_get_assay_data(obj, assay = assay_name, layer = layer_name), error = function(e) NULL)
    if (is.null(mat)) return(character(0))
    genes <- rownames(mat)
    genes <- as.character(genes %||% character(0))
    unique(genes[!is.na(genes) & nzchar(genes)])
  }

  .tcr_clone_choices <- function(obj) {
    md_names <- colnames(obj@meta.data)
    candidates <- md_names[grepl("(^|_)(vdj_)?tcr(_|$)|clone|clonotype|cdr3", tolower(md_names))]
    unique(as.character(candidates[!is.na(candidates) & nzchar(candidates)]))
  }

  .metadata_choices <- function(obj) figure_meta_columns_for_color(obj@meta.data)

  .selected_or_first <- function(current, choices, preferred = NULL) {
    choices <- unname(as.character(choices %||% character(0)))
    choices <- choices[!is.na(choices) & nzchar(choices)]
    current <- as.character(current %||% "")
    current <- if (length(current)) current[[1]] else ""
    if (nzchar(current) && current %in% choices) return(current)
    preferred <- as.character(preferred %||% "")
    preferred <- if (length(preferred)) preferred[[1]] else ""
    if (nzchar(preferred) && preferred %in% choices) return(preferred)
    if (length(choices)) choices[[1]] else ""
  }

  selected_reduction <- reactive({
    obj <- active_object()
    choices <- .reduction_choices(obj)
    .selected_or_first(input$figure_umap_reduction, choices, figure_resolve_reduction_name(obj, "umap"))
  })

  selected_colorby <- reactive({
    obj <- active_object()
    choices <- .metadata_choices(obj)
    .selected_or_first(input$figure_umap_colorby_select, choices, if ("seurat_clusters" %in% choices) "seurat_clusters" else NULL)
  })

  .selected_assay <- function(obj, input_id) {
    assays <- .assay_choices(obj)
    default_assay <- tryCatch(as.character(Seurat::DefaultAssay(obj)), error = function(e) "")
    .selected_or_first(input[[input_id]], assays, default_assay)
  }

  selected_gene_assay <- reactive({ .selected_assay(active_object(), "figure_umap_gene_assay") })
  selected_rgb_assay <- reactive({ .selected_assay(active_object(), "figure_umap_rgb_assay") })
  selected_gene <- reactive({
    obj <- active_object()
    genes <- .gene_choices(obj, selected_gene_assay(), as.character(input$figure_umap_gene_layer %||% "data")[[1]])
    .selected_or_first(input$figure_umap_gene_select, genes, if (length(genes)) genes[[1]] else "")
  })
  selected_rgb_genes <- reactive({
    obj <- active_object()
    genes <- .gene_choices(obj, selected_rgb_assay(), as.character(input$figure_umap_rgb_layer %||% "data")[[1]])
    picked <- c(input$figure_umap_rgb_red %||% "", input$figure_umap_rgb_green %||% "", input$figure_umap_rgb_blue %||% "")
    defaults <- head(genes, 3L)
    out <- vapply(seq_len(3L), function(i) .selected_or_first(picked[[i]], genes, if (length(defaults) >= i) defaults[[i]] else ""), character(1))
    out
  })
  selected_tcr_field <- reactive({
    obj <- active_object()
    .selected_or_first(input$figure_umap_tcr_clone_field, .tcr_clone_choices(obj), "")
  })

  .sync_gene <- function(id, signature_rv, choices, selected) {
    choices <- unique(as.character(choices %||% character(0)))
    choices <- choices[!is.na(choices) & nzchar(choices)]
    selected <- as.character(selected %||% "")
    selected <- if (length(selected)) selected[[1]] else ""
    sig <- figure_select_input_signature(choices, selected)
    if (identical(signature_rv(), sig)) return(invisible(NULL))
    signature_rv(sig)
    wl_update_gene_selectize(session, id, choices, selected = if (nzchar(selected)) selected else character(0), server = TRUE)
    invisible(NULL)
  }

  .sync_select <- function(id, signature_rv, choices, selected) {
    choices <- choices %||% character(0)
    sig <- figure_select_input_signature(choices, selected)
    if (identical(signature_rv(), sig)) return(invisible(NULL))
    signature_rv(sig)
    updateSelectInput(session, id, choices = choices, selected = if (nzchar(selected)) selected else character(0))
    invisible(NULL)
  }

  .rgb_component_choices <- function(rgb_genes) {
    rgb_genes <- as.character(rgb_genes %||% character(0))
    labels <- c("Red gene: ", "Green gene: ", "Blue gene: ")
    keep <- seq_along(rgb_genes) <= length(labels) & !is.na(rgb_genes) & nzchar(rgb_genes)
    if (!any(keep)) return(character(0))
    stats::setNames(rgb_genes[keep], paste0(labels[keep], rgb_genes[keep]))
  }

  .alluvial_defaults <- function(saved = list(), choices, group_by = "", quant_field = "") {
    scalar <- function(value, fallback = "") {
      if (is.null(value) || !length(value)) return(as.character(fallback %||% "")[[1]])
      as.character(value)[[1]]
    }
    choices <- unique(as.character(choices %||% character(0)))
    choices <- choices[!is.na(choices) & nzchar(choices)]
    group_by <- scalar(group_by)
    quant_field <- scalar(quant_field)
    axis_1_default <- if (nzchar(group_by)) group_by else if (length(choices)) choices[[1]] else ""
    axis_1 <- scalar(saved$axis_1, axis_1_default)
    other_choices <- setdiff(choices, axis_1)
    axis_2_default <- if (nzchar(quant_field) && !identical(quant_field, axis_1)) quant_field else if (length(other_choices)) other_choices[[1]] else ""
    list(
      axis_1 = axis_1,
      axis_2 = scalar(saved$axis_2, axis_2_default),
      axis_3 = scalar(saved$axis_3, "__none__"),
      axis_4 = scalar(saved$axis_4, "__none__"),
      color_axis = scalar(saved$color_axis, "axis_1"),
      node_order = scalar(saved$node_order, "data"),
      show_labels = if (is.null(saved$show_labels)) TRUE else isTRUE(saved$show_labels),
      ribbon_alpha = if (is.null(saved$ribbon_alpha)) 0.65 else suppressWarnings(as.numeric(saved$ribbon_alpha)[[1]]),
      ribbon_width = if (is.null(saved$ribbon_width)) 0.15 else suppressWarnings(as.numeric(saved$ribbon_width)[[1]])
    )
  }

  .alluvial_input_state <- function(saved = list(), choices, group_by = "", quant_field = "") {
    state <- .alluvial_defaults(saved, choices, group_by = group_by, quant_field = quant_field)
    input_value <- function(id, fallback) {
      value <- input[[id]]
      if (is.null(value) || !length(value)) fallback else value[[1]]
    }
    state$axis_1 <- as.character(input_value("figure_umap_quant_axis_1", state$axis_1))
    state$axis_2 <- as.character(input_value("figure_umap_quant_axis_2", state$axis_2))
    state$axis_3 <- as.character(input_value("figure_umap_quant_axis_3", state$axis_3))
    state$axis_4 <- as.character(input_value("figure_umap_quant_axis_4", state$axis_4))
    state$color_axis <- as.character(input_value("figure_umap_quant_alluvial_color_axis", state$color_axis))
    state$node_order <- as.character(input_value("figure_umap_quant_alluvial_node_order", state$node_order))
    state$show_labels <- isTRUE(input_value("figure_umap_quant_alluvial_show_labels", state$show_labels))
    state$ribbon_alpha <- suppressWarnings(as.numeric(input_value("figure_umap_quant_alluvial_ribbon_alpha", state$ribbon_alpha)))
    state$ribbon_width <- suppressWarnings(as.numeric(input_value("figure_umap_quant_alluvial_ribbon_width", state$ribbon_width)))
    state
  }

  .overlay_state <- function(saved = list()) {
    numeric_value <- function(value, fallback) {
      out <- suppressWarnings(as.numeric(value %||% fallback)[[1]])
      if (!is.finite(out)) fallback else out
    }
    monocle_color <- as.character(saved$monocle_color %||% "annotation")[[1]]
    velocity_mode <- as.character(saved$velocity_mode %||% "point")[[1]]
    list(
      source = if (as.character(saved$source %||% "none")[[1]] %in% c("none", "monocle2", "monocle3", "rna_velocity")) as.character(saved$source %||% "none")[[1]] else "none",
      monocle_cells = if (is.null(saved$monocle_cells)) TRUE else isTRUE(saved$monocle_cells),
      monocle_graph = if (is.null(saved$monocle_graph)) TRUE else isTRUE(saved$monocle_graph),
      graph_width = numeric_value(saved$graph_width, 0.7),
      graph_alpha = numeric_value(saved$graph_alpha, 0.8),
      monocle_color = if (monocle_color %in% c("annotation", "pseudotime", "preserve")) monocle_color else "annotation",
      monocle_palette_source = if (identical(saved$monocle_palette_source, "manual")) "manual" else "metadata",
      monocle_manual_palette = as.character(saved$monocle_manual_palette %||% "{}")[[1]],
      monocle_label_groups = isTRUE(saved$monocle_label_groups),
      monocle_label_leaves = isTRUE(saved$monocle_label_leaves),
      monocle_label_branches = isTRUE(saved$monocle_label_branches),
      velocity_scale = numeric_value(saved$velocity_scale, 1),
      velocity_width = numeric_value(saved$velocity_width, 0.6),
      velocity_alpha = numeric_value(saved$velocity_alpha, 0.55),
      velocity_color = if (identical(saved$velocity_color, "group")) "group" else "single",
      velocity_model = if (identical(saved$velocity_model, "dynamical")) "dynamical" else "stochastic",
      velocity_pc = numeric_value(saved$velocity_pc, 11),
      velocity_mode = if (velocity_mode %in% c("point", "stream", "grid", "sparse_grid", "small_arrows")) velocity_mode else "point",
      velocity_latent = isTRUE(saved$velocity_latent),
      velocity_point_size = numeric_value(saved$velocity_point_size, 50),
      velocity_grid_density = numeric_value(saved$velocity_grid_density, 0.25),
      velocity_grid_width = numeric_value(saved$velocity_grid_width, 0.003),
      velocity_grid_size = numeric_value(saved$velocity_grid_size, 1.4),
      velocity_grid_length = numeric_value(saved$velocity_grid_length, 3),
      velocity_small_density = numeric_value(saved$velocity_small_density, 0.25),
      velocity_small_width = numeric_value(saved$velocity_small_width, 0.0025),
      velocity_small_size = numeric_value(saved$velocity_small_size, 1.1),
      velocity_small_length = numeric_value(saved$velocity_small_length, 2.5),
      velocity_stream_density = numeric_value(saved$velocity_stream_density, 2),
      velocity_stream_size = numeric_value(saved$velocity_stream_size, 1),
      velocity_stream_max = numeric_value(saved$velocity_stream_max, 4),
      velocity_stream_linewidth = numeric_value(saved$velocity_stream_linewidth, 1)
    )
  }

  observe({
    obj <- active_object()
    .sync_select("figure_umap_reduction", reduction_signature, .reduction_choices(obj), selected_reduction())
  })

  observe({
    obj <- active_object()
    choices <- .metadata_choices(obj)
    selected <- selected_colorby()
    .sync_select("figure_umap_colorby_select", color_signature, choices, selected)
    .sync_select("figure_umap_quant_field", quant_field_signature, choices, .selected_or_first(input$figure_umap_quant_field, choices, selected))
    .sync_select("figure_umap_quant_group_by", quant_group_signature, choices, .selected_or_first(input$figure_umap_quant_group_by, choices, selected))
  })

  observe({
    obj <- active_object()
    choices <- .metadata_choices(obj)
    saved_state <- hydrated_state() %||% list()
    saved_quant <- saved_state$quantification %||% list()
    group_by <- if (is.null(input$figure_umap_quant_group_by) || !length(input$figure_umap_quant_group_by)) saved_quant$group_by %||% selected_colorby() else input$figure_umap_quant_group_by
    quant_field <- if (is.null(input$figure_umap_quant_field) || !length(input$figure_umap_quant_field)) saved_quant$field %||% selected_colorby() else input$figure_umap_quant_field
    defaults <- .alluvial_defaults(saved_quant$alluvial %||% list(), choices, group_by = group_by, quant_field = quant_field)
    axis_choices <- stats::setNames(choices, choices)
    optional_choices <- c(stats::setNames("__none__", FIGURE_UMAP_UI_TEXT$none), axis_choices)
    color_choices <- stats::setNames(c("axis_1", "axis_2", "axis_3", "axis_4"), c(FIGURE_UMAP_UI_TEXT$alluvial_axis_1_choice, FIGURE_UMAP_UI_TEXT$alluvial_axis_2_choice, FIGURE_UMAP_UI_TEXT$alluvial_axis_3_choice, FIGURE_UMAP_UI_TEXT$alluvial_axis_4_choice))
    .sync_select("figure_umap_quant_axis_1", quant_axis_1_signature, axis_choices, defaults$axis_1)
    .sync_select("figure_umap_quant_axis_2", quant_axis_2_signature, axis_choices, defaults$axis_2)
    .sync_select("figure_umap_quant_axis_3", quant_axis_3_signature, optional_choices, defaults$axis_3)
    .sync_select("figure_umap_quant_axis_4", quant_axis_4_signature, optional_choices, defaults$axis_4)
    .sync_select("figure_umap_quant_alluvial_color_axis", quant_alluvial_color_signature, color_choices, defaults$color_axis)
  })

  observe({
    obj <- active_object()
    assays <- .assay_choices(obj)
    gene_assay <- .selected_assay(obj, "figure_umap_gene_assay")
    rgb_assay <- .selected_assay(obj, "figure_umap_rgb_assay")
    .sync_select("figure_umap_gene_assay", gene_assay_signature, assays, gene_assay)
    .sync_select("figure_umap_rgb_assay", rgb_assay_signature, assays, rgb_assay)

    gene_layer <- as.character(input$figure_umap_gene_layer %||% "data")[[1]]
    rgb_layer <- as.character(input$figure_umap_rgb_layer %||% "data")[[1]]
    gene_values <- .gene_choices(obj, gene_assay, gene_layer)
    rgb_values <- .gene_choices(obj, rgb_assay, rgb_layer)
    gene_value <- .selected_or_first(input$figure_umap_gene_select, gene_values, if (length(gene_values)) gene_values[[1]] else "")
    rgb_inputs <- c(input$figure_umap_rgb_red %||% "", input$figure_umap_rgb_green %||% "", input$figure_umap_rgb_blue %||% "")
    rgb_defaults <- head(rgb_values, 3L)
    rgb_values_selected <- vapply(seq_len(3L), function(i) .selected_or_first(rgb_inputs[[i]], rgb_values, if (length(rgb_defaults) >= i) rgb_defaults[[i]] else ""), character(1))
    .sync_gene("figure_umap_gene_select", gene_signature, gene_values, gene_value)
    .sync_gene("figure_umap_rgb_red", rgb_red_signature, rgb_values, rgb_values_selected[[1]])
    .sync_gene("figure_umap_rgb_green", rgb_green_signature, rgb_values, rgb_values_selected[[2]])
    .sync_gene("figure_umap_rgb_blue", rgb_blue_signature, rgb_values, rgb_values_selected[[3]])
    rgb_component_choices <- .rgb_component_choices(rgb_values_selected)
    .sync_select("figure_umap_rgb_quant_component", rgb_quant_signature, rgb_component_choices, .selected_or_first(input$figure_umap_rgb_quant_component, unname(rgb_component_choices), if (length(rgb_values_selected)) rgb_values_selected[[1]] else ""))

    tcr_values <- .tcr_clone_choices(obj)
    .sync_select("figure_umap_tcr_clone_field", tcr_signature, tcr_values, .selected_or_first(input$figure_umap_tcr_clone_field, tcr_values, if ("vdj_tcr_clone" %in% tcr_values) "vdj_tcr_clone" else ""))
  })

  observe({
    registry <- shared_data$all_seurat_objects %||% list()
    current <- canonical_object_name()
    choices <- setdiff(names(registry), current)
    selected <- .selected_or_first(input$figure_umap_comparison_object, choices, if (length(choices)) choices[[1]] else "")
    .sync_select("figure_umap_comparison_object", comparison_signature, choices, selected)
  })

  .sync_quant_chart_for_mode <- function(mode = NULL, tcr_display = NULL) {
    mode <- as.character(mode %||% input$figure_umap_color_mode %||% "metadata")[[1]]
    tcr_display <- as.character(tcr_display %||% input$figure_umap_tcr_display %||% "clone_size")[[1]]
    chart <- as.character(input$figure_umap_quant_chart %||% "auto")[[1]]
    numeric_branch <- mode %in% c("gene", "rgb") || (identical(mode, "tcr") && identical(tcr_display, "clone_size"))
    if (isTRUE(numeric_branch) && chart %in% c("composition")) updateSelectInput(session, "figure_umap_quant_chart", selected = "auto")
    if (!isTRUE(numeric_branch) && chart %in% c("violin", "box")) updateSelectInput(session, "figure_umap_quant_chart", selected = "auto")
    invisible(NULL)
  }

  observeEvent(input$figure_umap_color_mode, .sync_quant_chart_for_mode(input$figure_umap_color_mode), ignoreInit = TRUE)
  observeEvent(input$figure_umap_tcr_display, .sync_quant_chart_for_mode("tcr", input$figure_umap_tcr_display), ignoreInit = TRUE)

  observe({
    obj <- active_object()
    choices <- figure_split_choices(obj@meta.data)
    selected_column <- .selected_or_first(input$figure_umap_column_split, unname(choices), "__none__")
    row_choices <- figure_split_choices(obj@meta.data, exclude = if (identical(selected_column, "__none__")) character(0) else selected_column)
    selected_row <- .selected_or_first(input$figure_umap_row_split, unname(row_choices), "__none__")
    .sync_select("figure_umap_column_split", split_column_signature, choices, selected_column)
    .sync_select("figure_umap_row_split", split_row_signature, row_choices, selected_row)
    quant_split_choices <- c(stats::setNames(c("same_as_umap", "__none__"), c(FIGURE_UMAP_UI_TEXT$same_as_umap, FIGURE_UMAP_UI_TEXT$none)), stats::setNames(unname(choices)[-1], unname(choices)[-1]))
    quant_split <- as.character(input$figure_umap_quant_split_by %||% "same_as_umap")[[1]]
    if (!(quant_split %in% unname(quant_split_choices))) quant_split <- "same_as_umap"
    .sync_select("figure_umap_quant_split_by", quant_split_signature, quant_split_choices, quant_split)
  })

  observe({
    current <- as.character(input$figure_umap_palette %||% "Default Seurat")[[1]]
    if (!(current %in% palette_choices)) current <- "Default Seurat"
    .sync_select("figure_umap_palette", palette_signature, palette_choices, current)
  })

  # Agent note: Workspace controls live in object-owned misc state so switching
  # active objects cannot leave session-only figure settings authoritative.
  .read_workspace_state <- function(obj) {
    misc <- tryCatch(obj@misc, error = function(e) list())
    if (!is.list(misc) || !is.list(misc$analysis)) return(list())
    state <- misc$analysis$figure_studio_umap
    if (is.list(state)) state else list()
  }

  .hydrate_workspace_state <- function(obj) {
    saved <- .read_workspace_state(obj)
    metadata <- saved$metadata %||% list()
    gene <- saved$gene %||% list()
    rgb <- saved$rgb %||% list()
    tcr <- saved$tcr %||% list()
    quant <- saved$quantification %||% list()
    layout <- saved$layout %||% list()
    camera <- saved$camera %||% list()
    comparison <- saved$comparison %||% list()
    overlay <- .overlay_state(saved$overlay %||% list())
    export <- saved$export %||% list()
    appearance <- utils::modifyList(figure_shared_plot_settings_defaults(), saved$appearance %||% list())
    reductions <- .reduction_choices(obj)
    metadata_choices <- .metadata_choices(obj)
    assays <- .assay_choices(obj)
    default_assay <- tryCatch(as.character(Seurat::DefaultAssay(obj)), error = function(e) "")
    gene_assay <- .selected_or_first(gene$assay, assays, default_assay)
    rgb_assay <- .selected_or_first(rgb$assay, assays, default_assay)
    gene_layer <- .selected_or_first(gene$layer, c("data", "scale.data", "counts"), "data")
    rgb_layer <- .selected_or_first(rgb$layer, c("data", "scale.data", "counts"), "data")
    gene_values <- .gene_choices(obj, gene_assay, gene_layer)
    rgb_values <- .gene_choices(obj, rgb_assay, rgb_layer)
    gene_name <- .selected_or_first(gene$feature, gene_values, if (length(gene_values)) gene_values[[1]] else "")
    rgb_defaults <- head(rgb_values, 3L)
    rgb_genes <- c(
      .selected_or_first(rgb$red, rgb_values, if (length(rgb_defaults) >= 1) rgb_defaults[[1]] else ""),
      .selected_or_first(rgb$green, rgb_values, if (length(rgb_defaults) >= 2) rgb_defaults[[2]] else ""),
      .selected_or_first(rgb$blue, rgb_values, if (length(rgb_defaults) >= 3) rgb_defaults[[3]] else "")
    )
    tcr_values <- .tcr_clone_choices(obj)
    tcr_field <- .selected_or_first(tcr$clone_field, tcr_values, if ("vdj_tcr_clone" %in% tcr_values) "vdj_tcr_clone" else "")
    reduction <- .selected_or_first(saved$reduction, reductions, figure_resolve_reduction_name(obj, "umap"))
    colorby <- .selected_or_first(metadata$field, metadata_choices, if ("seurat_clusters" %in% metadata_choices) "seurat_clusters" else NULL)
    quant_field <- .selected_or_first(quant$field, metadata_choices, colorby)
    group_by <- .selected_or_first(quant$group_by, metadata_choices, colorby)
    alluvial <- .alluvial_defaults(quant$alluvial %||% list(), metadata_choices, group_by = group_by, quant_field = quant_field)
    split_choices <- figure_split_choices(obj@meta.data)
    split_column <- .selected_or_first(layout$column_split, unname(split_choices), "__none__")
    row_choices <- figure_split_choices(obj@meta.data, exclude = if (identical(split_column, "__none__")) character(0) else split_column)
    split_row <- .selected_or_first(layout$row_split, unname(row_choices), "__none__")
    split_quant <- as.character(quant$split_by %||% "same_as_umap")[[1]]
    split_values <- c("same_as_umap", "__none__", unname(split_choices)[-1])
    if (!(split_quant %in% split_values)) split_quant <- "same_as_umap"
    rgb_component_choices <- .rgb_component_choices(rgb_genes)
    camera_panels <- if (is.list(camera$panels)) camera$panels else list()
    list(
      view_mode = if (identical(saved$view_mode, "3d")) "3d" else "2d",
      color_mode = .selected_or_first(saved$color_mode, c("metadata", "gene", "rgb", "tcr"), "metadata"),
      reduction = reduction,
      metadata = list(field = colorby, palette = .selected_or_first(metadata$palette, palette_choices, "Default Seurat")),
      gene = list(assay = gene_assay, feature = gene_name, layer = gene_layer, palette = .selected_or_first(gene$palette, c("gray_red", "blue_yellow", "viridis"), "gray_red")),
      rgb = list(assay = rgb_assay, red = rgb_genes[[1]], green = rgb_genes[[2]], blue = rgb_genes[[3]], layer = rgb_layer, quant_component = .selected_or_first(rgb$quant_component, unname(rgb_component_choices), rgb_genes[[1]])),
      tcr = list(clone_field = tcr_field, display = .selected_or_first(tcr$display, c("clone", "clone_size", "status"), "clone_size"), palette = .selected_or_first(tcr$palette, palette_choices, "Default Seurat")),
      camera = list(azimuth = as.numeric(camera$azimuth %||% 35), elevation = as.numeric(camera$elevation %||% 25), distance = as.numeric(camera$distance %||% 1.6), projection = if (identical(camera$projection, "orthographic")) "orthographic" else "perspective", axes = if (is.null(camera$axes)) TRUE else isTRUE(camera$axes), panels = camera_panels),
      layout = list(column_split = split_column, row_split = split_row, legend_position = as.character(layout$legend_position %||% "right")[[1]], legend_columns = as.numeric(layout$legend_columns %||% 4), annotate = isTRUE(layout$annotate)),
      quantification = list(
        enabled = if (is.null(quant$enabled)) TRUE else isTRUE(quant$enabled),
        target = if (identical(quant$target, "explicit_metadata")) "explicit_metadata" else "same_as_color",
        field = quant_field,
        group_by = group_by,
        split_by = split_quant,
        chart = as.character(quant$chart %||% "auto")[[1]],
        unit = as.character(quant$unit %||% "count")[[1]],
        alluvial = alluvial
      ),
      overlay = overlay,
      comparison = list(mode = if (identical(comparison$mode, "two")) "two" else "single", object = as.character(comparison$object %||% "")[[1]], layout = if (identical(comparison$layout, "vertical")) "vertical" else "horizontal"),
      appearance = appearance,
      typography_mode = if (identical(saved$typography_mode, "proportional")) "proportional" else "fixed",
      title = as.character(saved$title %||% "UMAP Projection")[[1]],
      export = list(
        composition = as.character(export$composition %||% "paired")[[1]],
        pair_layout = as.character(export$pair_layout %||% "vertical")[[1]],
        width = as.numeric(export$width %||% 10),
        height = as.numeric(export$height %||% 11),
        dpi = as.numeric(export$dpi %||% 300),
        units = as.character(export$units %||% "in")[[1]],
        format = if (as.character(export$format %||% "pdf")[[1]] %in% c("pdf", "svg", "png", "html")) as.character(export$format %||% "pdf")[[1]] else "pdf"
      )
    )
  }

  observe({
    registry <- shared_data$all_seurat_objects %||% list()
    nm <- canonical_object_name()
    if (!nzchar(nm) || is.null(registry[[nm]])) return(invisible(NULL))
    entry <- registry[[nm]]
    obj <- figure_extract_seurat_object(entry)
    if (is.null(obj)) return(invisible(NULL))
    changed <- !identical(nm, last_context_name) || !identical(entry, last_context_entry)
    if (!changed) return(invisible(NULL))
    last_context_name <<- nm
    last_context_entry <<- entry
    context_revision(context_revision() + 1L)
    state <- .hydrate_workspace_state(obj)
    hydrated_state(state)
    camera_panel_state(state$camera$panels %||% list())
    camera_relayout_event(NULL)
    hydration_active$value <- TRUE
    updateRadioButtons(session, "figure_umap_view_mode", selected = state$view_mode)
    updateRadioButtons(session, "figure_umap_color_mode", selected = state$color_mode)
    updateSelectInput(session, "figure_umap_reduction", selected = state$reduction)
    updateSliderInput(session, "figure_umap_camera_azimuth", value = state$camera$azimuth)
    updateSliderInput(session, "figure_umap_camera_elevation", value = state$camera$elevation)
    updateSliderInput(session, "figure_umap_camera_distance", value = state$camera$distance)
    updateSelectInput(session, "figure_umap_camera_projection", selected = state$camera$projection)
    updateCheckboxInput(session, "figure_umap_camera_axes", value = state$camera$axes)
    updateSelectInput(session, "figure_umap_colorby_select", selected = state$metadata$field)
    updateSelectInput(session, "figure_umap_palette", selected = state$metadata$palette)
    updateSelectInput(session, "figure_umap_gene_assay", selected = state$gene$assay)
    updateSelectInput(session, "figure_umap_gene_layer", selected = state$gene$layer)
    updateSelectInput(session, "figure_umap_gene_palette", selected = state$gene$palette)
    wl_update_gene_selectize(session, "figure_umap_gene_select", .gene_choices(obj, state$gene$assay, state$gene$layer), selected = state$gene$feature, server = TRUE)
    updateSelectInput(session, "figure_umap_rgb_assay", selected = state$rgb$assay)
    updateSelectInput(session, "figure_umap_rgb_layer", selected = state$rgb$layer)
    updateSelectInput(session, "figure_umap_rgb_quant_component", selected = state$rgb$quant_component)
    wl_update_gene_selectize(session, "figure_umap_rgb_red", .gene_choices(obj, state$rgb$assay, state$rgb$layer), selected = state$rgb$red, server = TRUE)
    wl_update_gene_selectize(session, "figure_umap_rgb_green", .gene_choices(obj, state$rgb$assay, state$rgb$layer), selected = state$rgb$green, server = TRUE)
    wl_update_gene_selectize(session, "figure_umap_rgb_blue", .gene_choices(obj, state$rgb$assay, state$rgb$layer), selected = state$rgb$blue, server = TRUE)
    updateSelectInput(session, "figure_umap_tcr_clone_field", selected = state$tcr$clone_field)
    updateSelectInput(session, "figure_umap_tcr_display", selected = state$tcr$display)
    updateSelectInput(session, "figure_umap_tcr_palette", selected = state$tcr$palette)
    updateSelectInput(session, "figure_umap_column_split", selected = state$layout$column_split)
    updateSelectInput(session, "figure_umap_row_split", selected = state$layout$row_split)
    updateSelectInput(session, "figure_umap_legend_position", selected = state$layout$legend_position)
    updateSliderInput(session, "figure_umap_legend_cols", value = state$layout$legend_columns)
    updateCheckboxInput(session, "figure_umap_annotate_populations", value = state$layout$annotate)
    updateSelectInput(session, "figure_umap_overlay_source", selected = state$overlay$source)
    updateCheckboxInput(session, "figure_umap_overlay_monocle_cells", value = state$overlay$monocle_cells)
    updateCheckboxInput(session, "figure_umap_overlay_monocle_graph", value = state$overlay$monocle_graph)
    updateSliderInput(session, "figure_umap_overlay_graph_width", value = state$overlay$graph_width)
    updateSliderInput(session, "figure_umap_overlay_graph_alpha", value = state$overlay$graph_alpha)
    updateSelectInput(session, "figure_umap_overlay_monocle_color", selected = state$overlay$monocle_color)
    updateSelectInput(session, "figure_umap_overlay_monocle_palette_source", selected = state$overlay$monocle_palette_source)
    updateTextAreaInput(session, "figure_umap_overlay_monocle_manual_palette", value = state$overlay$monocle_manual_palette)
    updateCheckboxInput(session, "figure_umap_overlay_monocle_label_groups", value = state$overlay$monocle_label_groups)
    updateCheckboxInput(session, "figure_umap_overlay_monocle_label_leaves", value = state$overlay$monocle_label_leaves)
    updateCheckboxInput(session, "figure_umap_overlay_monocle_label_branches", value = state$overlay$monocle_label_branches)
    updateSliderInput(session, "figure_umap_overlay_velocity_scale", value = state$overlay$velocity_scale)
    updateSliderInput(session, "figure_umap_overlay_velocity_width", value = state$overlay$velocity_width)
    updateSliderInput(session, "figure_umap_overlay_velocity_alpha", value = state$overlay$velocity_alpha)
    updateSelectInput(session, "figure_umap_overlay_velocity_color", selected = state$overlay$velocity_color)
    updateSelectInput(session, "figure_umap_overlay_velocity_model", selected = state$overlay$velocity_model)
    updateNumericInput(session, "figure_umap_overlay_velocity_pc", value = state$overlay$velocity_pc)
    updateSelectInput(session, "figure_umap_overlay_velocity_mode", selected = state$overlay$velocity_mode)
    updateCheckboxInput(session, "figure_umap_overlay_velocity_latent", value = state$overlay$velocity_latent)
    updateNumericInput(session, "figure_umap_overlay_velocity_point_size", value = state$overlay$velocity_point_size)
    updateNumericInput(session, "figure_umap_overlay_velocity_grid_density", value = state$overlay$velocity_grid_density)
    updateNumericInput(session, "figure_umap_overlay_velocity_grid_width", value = state$overlay$velocity_grid_width)
    updateNumericInput(session, "figure_umap_overlay_velocity_grid_size", value = state$overlay$velocity_grid_size)
    updateNumericInput(session, "figure_umap_overlay_velocity_grid_length", value = state$overlay$velocity_grid_length)
    updateNumericInput(session, "figure_umap_overlay_velocity_small_density", value = state$overlay$velocity_small_density)
    updateNumericInput(session, "figure_umap_overlay_velocity_small_width", value = state$overlay$velocity_small_width)
    updateNumericInput(session, "figure_umap_overlay_velocity_small_size", value = state$overlay$velocity_small_size)
    updateNumericInput(session, "figure_umap_overlay_velocity_small_length", value = state$overlay$velocity_small_length)
    updateNumericInput(session, "figure_umap_overlay_velocity_stream_density", value = state$overlay$velocity_stream_density)
    updateNumericInput(session, "figure_umap_overlay_velocity_stream_size", value = state$overlay$velocity_stream_size)
    updateNumericInput(session, "figure_umap_overlay_velocity_stream_max", value = state$overlay$velocity_stream_max)
    updateNumericInput(session, "figure_umap_overlay_velocity_stream_linewidth", value = state$overlay$velocity_stream_linewidth)
    updateCheckboxInput(session, "figure_umap_include_quantification", value = state$quantification$enabled)
    updateRadioButtons(session, "figure_umap_quant_target", selected = state$quantification$target)
    updateSelectInput(session, "figure_umap_quant_field", selected = state$quantification$field)
    updateSelectInput(session, "figure_umap_quant_group_by", selected = state$quantification$group_by)
    updateSelectInput(session, "figure_umap_quant_split_by", selected = state$quantification$split_by)
    updateSelectInput(session, "figure_umap_quant_chart", selected = state$quantification$chart)
    updateSelectInput(session, "figure_umap_quant_unit", selected = state$quantification$unit)
    alluvial <- state$quantification$alluvial %||% list()
    updateSelectInput(session, "figure_umap_quant_axis_1", selected = alluvial$axis_1)
    updateSelectInput(session, "figure_umap_quant_axis_2", selected = alluvial$axis_2)
    updateSelectInput(session, "figure_umap_quant_axis_3", selected = alluvial$axis_3)
    updateSelectInput(session, "figure_umap_quant_axis_4", selected = alluvial$axis_4)
    updateSelectInput(session, "figure_umap_quant_alluvial_color_axis", selected = alluvial$color_axis)
    updateSelectInput(session, "figure_umap_quant_alluvial_node_order", selected = alluvial$node_order)
    updateCheckboxInput(session, "figure_umap_quant_alluvial_show_labels", value = alluvial$show_labels)
    updateSliderInput(session, "figure_umap_quant_alluvial_ribbon_alpha", value = alluvial$ribbon_alpha)
    updateSliderInput(session, "figure_umap_quant_alluvial_ribbon_width", value = alluvial$ribbon_width)
    updateRadioButtons(session, "figure_umap_comparison_mode", selected = state$comparison$mode)
    updateSelectInput(session, "figure_umap_comparison_object", selected = state$comparison$object)
    updateRadioButtons(session, "figure_umap_comparison_layout", selected = state$comparison$layout)
    updateTextInput(session, "figure_umap_title_text", value = state$title)
    updateSelectInput(session, "figure_umap_typography_mode", selected = state$typography_mode)
    updateRadioButtons(session, "figure_umap_export_composition", selected = state$export$composition)
    updateRadioButtons(session, "figure_umap_pair_layout", selected = state$export$pair_layout)
    updateNumericInput(session, "figure_umap_width", value = state$export$width)
    updateNumericInput(session, "figure_umap_height", value = state$export$height)
    updateNumericInput(session, "figure_umap_dpi", value = state$export$dpi)
    updateRadioButtons(session, "figure_umap_units", selected = state$export$units)
    updateSelectInput(session, "figure_umap_export_format", selected = state$export$format)
    for (setting_name in names(state$appearance)) {
      if (is.function(shared_plot_settings[[setting_name]])) shared_plot_settings[[setting_name]](state$appearance[[setting_name]])
    }
    session$onFlushed(function() hydration_active$value <- FALSE, once = TRUE)
    invisible(NULL)
  })

  .camera_panel_specs_for_object <- function(obj, state, prefix = "primary::") {
    emb <- tryCatch(Seurat::Embeddings(obj, reduction = state$reduction), error = function(e) NULL)
    if (!is.matrix(emb) || nrow(emb) < 1L) stop("Selected embedding is not available for camera panels.", call. = FALSE)
    frame <- .split_frame(obj, state, rownames(emb), seq_len(nrow(emb)), seq_len(nrow(emb)))
    split_mode <- figure_facet_mode(state$layout$column_split, state$layout$row_split)
    figure_umap_split_panel_specs(rownames(emb), split_mode, frame$split_value, frame$split_value_secondary, prefix = prefix)
  }

  .camera_panel_ids_for_state <- function(obj, state) {
    ids <- vapply(.camera_panel_specs_for_object(obj, state, prefix = "primary::"), `[[`, character(1), "id")
    if (identical(state$comparison$mode, "two")) {
      registry <- shared_data$all_seurat_objects %||% list()
      compare_name <- state$comparison$object
      if (!nzchar(compare_name) || is.null(registry[[compare_name]])) stop("Comparison object is not available for camera capture.", call. = FALSE)
      compare_obj <- figure_extract_seurat_object(registry[[compare_name]])
      if (is.null(compare_obj)) stop("Comparison object is not a Seurat object for camera capture.", call. = FALSE)
      ids <- c(ids, vapply(.camera_panel_specs_for_object(compare_obj, state, prefix = "secondary::"), `[[`, character(1), "id"))
    }
    ids
  }

  observeEvent(list(input$figure_umap_camera_azimuth, input$figure_umap_camera_elevation, input$figure_umap_camera_distance, input$figure_umap_camera_projection), {
    if (isTRUE(hydration_active$value) || isTRUE(camera_programmatic_update$value)) return(invisible(NULL))
    camera_panel_state(list())
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$figure_umap_camera_relayout, {
    camera_relayout_event(input$figure_umap_camera_relayout)
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$figure_umap_apply_camera, {
    obj <- active_object()
    state <- .current_workspace_state()
    panel_ids <- tryCatch(.camera_panel_ids_for_state(obj, state), error = function(e) e)
    if (inherits(panel_ids, "error")) {
      showNotification(conditionMessage(panel_ids), type = "error")
      return(invisible(NULL))
    }
    camera_map <- tryCatch(
      figure_umap_camera_event_map(camera_relayout_event(), panel_ids, camera_panel_state() %||% list()),
      error = function(e) e
    )
    if (inherits(camera_map, "error")) {
      showNotification(conditionMessage(camera_map), type = "warning")
      return(invisible(NULL))
    }
    state$camera$panels <- camera_map
    first_camera <- camera_map[[panel_ids[[1]]]]
    slider_values <- figure_umap_camera_slider_values(first_camera)
    state$camera$azimuth <- max(-180, min(180, slider_values$azimuth))
    state$camera$elevation <- max(-90, min(90, slider_values$elevation))
    state$camera$distance <- max(0.5, min(3, slider_values$distance))
    camera_panel_state(camera_map)
    camera_programmatic_update$value <- TRUE
    updateSliderInput(session, "figure_umap_camera_azimuth", value = state$camera$azimuth)
    updateSliderInput(session, "figure_umap_camera_elevation", value = state$camera$elevation)
    updateSliderInput(session, "figure_umap_camera_distance", value = state$camera$distance)
    session$onFlushed(function() camera_programmatic_update$value <- FALSE, once = TRUE)
    .write_workspace_state(canonical_object_name(), state)
    invisible(NULL)
  }, ignoreInit = TRUE)

  .state_eval <- function(label, fn) {
    tryCatch(
      fn(),
      error = function(e) {
        msg <- conditionMessage(e)
        if (!nzchar(msg)) msg <- paste(class(e), collapse = ",")
        stop(paste0(label, ": ", msg), call. = FALSE)
      }
    )
  }

  .snapshot_workspace_state <- function(obj) {
    if (is.null(obj)) stop("Active object is not settled.", call. = FALSE)
    reduction_choices <- .state_eval("reduction choices", function() .reduction_choices(obj))
    metadata_choices <- .state_eval("metadata choices", function() .metadata_choices(obj))
    reduction_input <- .state_eval("selected reduction input", function() input$figure_umap_reduction)
    preferred_reduction <- .state_eval("preferred reduction", function() figure_resolve_reduction_name(obj, "umap"))
    reduction <- .state_eval("selected reduction choice", function() .selected_or_first(reduction_input, reduction_choices, preferred_reduction))
    colorby <- .state_eval("selected metadata field", function() .selected_or_first(input$figure_umap_colorby_select, metadata_choices, if ("seurat_clusters" %in% metadata_choices) "seurat_clusters" else NULL))
    color_mode <- as.character(input$figure_umap_color_mode %||% "metadata")[[1]]
    gene_assay <- .selected_assay(obj, "figure_umap_gene_assay")
    rgb_assay <- .selected_assay(obj, "figure_umap_rgb_assay")
    gene_layer <- as.character(input$figure_umap_gene_layer %||% "data")[[1]]
    rgb_layer <- as.character(input$figure_umap_rgb_layer %||% "data")[[1]]
    rgb_genes <- selected_rgb_genes()
    quant_chart_input <- as.character(input$figure_umap_quant_chart %||% "auto")[[1]]
    numeric_quant_branch <- color_mode %in% c("gene", "rgb") || (identical(color_mode, "tcr") && identical(as.character(input$figure_umap_tcr_display %||% "clone_size")[[1]], "clone_size"))
    quant_chart <- if (isTRUE(numeric_quant_branch) && identical(quant_chart_input, "composition")) "auto" else if (!isTRUE(numeric_quant_branch) && quant_chart_input %in% c("violin", "box")) "auto" else quant_chart_input
    saved_state <- hydrated_state() %||% list()
    saved_quant <- saved_state$quantification %||% list()
    alluvial_group_by <- if (is.null(input$figure_umap_quant_group_by) || !length(input$figure_umap_quant_group_by)) saved_quant$group_by %||% colorby else input$figure_umap_quant_group_by
    alluvial_quant_field <- if (is.null(input$figure_umap_quant_field) || !length(input$figure_umap_quant_field)) saved_quant$field %||% colorby else input$figure_umap_quant_field
    alluvial <- .alluvial_input_state(saved_quant$alluvial %||% list(), metadata_choices, group_by = alluvial_group_by, quant_field = alluvial_quant_field)
    overlay <- .overlay_state(list(
      source = input$figure_umap_overlay_source,
      monocle_cells = input$figure_umap_overlay_monocle_cells,
      monocle_graph = input$figure_umap_overlay_monocle_graph,
      graph_width = input$figure_umap_overlay_graph_width,
      graph_alpha = input$figure_umap_overlay_graph_alpha,
      monocle_color = input$figure_umap_overlay_monocle_color,
      monocle_palette_source = input$figure_umap_overlay_monocle_palette_source,
      monocle_manual_palette = input$figure_umap_overlay_monocle_manual_palette,
      monocle_label_groups = input$figure_umap_overlay_monocle_label_groups,
      monocle_label_leaves = input$figure_umap_overlay_monocle_label_leaves,
      monocle_label_branches = input$figure_umap_overlay_monocle_label_branches,
      velocity_scale = input$figure_umap_overlay_velocity_scale,
      velocity_width = input$figure_umap_overlay_velocity_width,
      velocity_alpha = input$figure_umap_overlay_velocity_alpha,
      velocity_color = input$figure_umap_overlay_velocity_color,
      velocity_model = input$figure_umap_overlay_velocity_model,
      velocity_pc = input$figure_umap_overlay_velocity_pc,
      velocity_mode = input$figure_umap_overlay_velocity_mode,
      velocity_latent = input$figure_umap_overlay_velocity_latent,
      velocity_point_size = input$figure_umap_overlay_velocity_point_size,
      velocity_grid_density = input$figure_umap_overlay_velocity_grid_density,
      velocity_grid_width = input$figure_umap_overlay_velocity_grid_width,
      velocity_grid_size = input$figure_umap_overlay_velocity_grid_size,
      velocity_grid_length = input$figure_umap_overlay_velocity_grid_length,
      velocity_small_density = input$figure_umap_overlay_velocity_small_density,
      velocity_small_width = input$figure_umap_overlay_velocity_small_width,
      velocity_small_size = input$figure_umap_overlay_velocity_small_size,
      velocity_small_length = input$figure_umap_overlay_velocity_small_length,
      velocity_stream_density = input$figure_umap_overlay_velocity_stream_density,
      velocity_stream_size = input$figure_umap_overlay_velocity_stream_size,
      velocity_stream_max = input$figure_umap_overlay_velocity_stream_max,
      velocity_stream_linewidth = input$figure_umap_overlay_velocity_stream_linewidth
    ))
    rgb_component_choices <- .rgb_component_choices(rgb_genes)
    camera_panels <- camera_panel_state()
    if (is.null(camera_panels)) camera_panels <- list()
    list(
      schema_version = 1L,
      view_mode = as.character(input$figure_umap_view_mode %||% "2d")[[1]],
      color_mode = color_mode,
      reduction = reduction,
      metadata = list(field = colorby, palette = as.character(input$figure_umap_palette %||% "Default Seurat")[[1]]),
      gene = list(assay = gene_assay, feature = selected_gene(), layer = gene_layer, palette = as.character(input$figure_umap_gene_palette %||% "gray_red")[[1]]),
      rgb = list(assay = rgb_assay, red = rgb_genes[[1]], green = rgb_genes[[2]], blue = rgb_genes[[3]], layer = rgb_layer, quant_component = .selected_or_first(input$figure_umap_rgb_quant_component, unname(rgb_component_choices), rgb_genes[[1]])),
      tcr = list(clone_field = selected_tcr_field(), display = as.character(input$figure_umap_tcr_display %||% "clone_size")[[1]], palette = as.character(input$figure_umap_tcr_palette %||% "Default Seurat")[[1]]),
      camera = list(azimuth = as.numeric(input$figure_umap_camera_azimuth %||% 35), elevation = as.numeric(input$figure_umap_camera_elevation %||% 25), distance = as.numeric(input$figure_umap_camera_distance %||% 1.6), projection = as.character(input$figure_umap_camera_projection %||% "perspective")[[1]], axes = isTRUE(input$figure_umap_camera_axes %||% TRUE), panels = camera_panels),
      layout = list(column_split = as.character(input$figure_umap_column_split %||% "__none__")[[1]], row_split = as.character(input$figure_umap_row_split %||% "__none__")[[1]], legend_position = as.character(input$figure_umap_legend_position %||% "right")[[1]], legend_columns = as.numeric(input$figure_umap_legend_cols %||% 4), annotate = isTRUE(input$figure_umap_annotate_populations)),
      quantification = list(enabled = isTRUE(input$figure_umap_include_quantification), target = as.character(input$figure_umap_quant_target %||% "same_as_color")[[1]], field = as.character(input$figure_umap_quant_field %||% colorby)[[1]], group_by = as.character(input$figure_umap_quant_group_by %||% colorby)[[1]], split_by = as.character(input$figure_umap_quant_split_by %||% "same_as_umap")[[1]], chart = quant_chart, unit = as.character(input$figure_umap_quant_unit %||% "count")[[1]], alluvial = alluvial),
      overlay = overlay,
      comparison = list(mode = as.character(input$figure_umap_comparison_mode %||% "single")[[1]], object = as.character(input$figure_umap_comparison_object %||% "")[[1]], layout = as.character(input$figure_umap_comparison_layout %||% "horizontal")[[1]]),
      appearance = .state_eval("shared plot settings", function() figure_shared_plot_settings_values(shared_plot_settings, track_reactive = TRUE)),
      typography_mode = as.character(input$figure_umap_typography_mode %||% "fixed")[[1]],
      title = as.character(input$figure_umap_title_text %||% "UMAP Projection")[[1]],
      export = list(composition = as.character(input$figure_umap_export_composition %||% "paired")[[1]], pair_layout = as.character(input$figure_umap_pair_layout %||% "vertical")[[1]], width = as.numeric(input$figure_umap_width %||% 10), height = as.numeric(input$figure_umap_height %||% 11), dpi = as.numeric(input$figure_umap_dpi %||% 300), units = as.character(input$figure_umap_units %||% "in")[[1]], format = as.character(input$figure_umap_export_format %||% "pdf")[[1]])
    )
  }

  .current_workspace_state <- reactive({
    .snapshot_workspace_state(active_object())
  })

  .write_workspace_state <- function(nm, state) {
    entry <- (shared_data$all_seurat_objects %||% list())[[nm]]
    obj <- figure_extract_seurat_object(entry)
    if (is.null(obj)) return(invisible(NULL))
    existing <- .read_workspace_state(obj)
    if (identical(existing, state)) return(invisible(NULL))
    misc <- tryCatch(obj@misc, error = function(e) list())
    if (!is.list(misc)) misc <- list()
    if (!is.list(misc$analysis)) misc$analysis <- list()
    misc$analysis$figure_studio_umap <- state
    obj@misc <- misc
    if (is.list(entry) && !is.null(entry$obj)) entry$obj <- obj else entry <- obj
    registry <- shared_data$all_seurat_objects %||% list()
    registry[[nm]] <- entry
    shared_data$all_seurat_objects <- registry
    last_context_entry <<- entry
    invisible(NULL)
  }

  observe({
    state <- .current_workspace_state()
    nm <- canonical_object_name()
    if (!nzchar(nm) || isTRUE(hydration_active$value)) return(invisible(NULL))
    .write_workspace_state(nm, state)
  })

  umap_color_levels <- reactive({
    obj <- active_object()
    col_name <- selected_colorby()
    validate(need(nzchar(col_name) && col_name %in% colnames(obj@meta.data), FIGURE_UMAP_UI_TEXT$no_metadata))
    figure_color_levels_from_vector(obj@meta.data[[col_name]], column_name = col_name)
  })

  umap_default_palette <- reactive({
    obj <- active_object()
    col_name <- selected_colorby()
    figure_resolve_metadata_palette(sobj = obj, reduction_name = selected_reduction(), color_col = col_name, label_values = as.character(obj@meta.data[[col_name]]), levels_vec = umap_color_levels())
  })

  umap_effective_palette <- reactive({
    levels <- umap_color_levels()
    defaults <- umap_default_palette()
    resolved <- figure_resolve_discrete_palette(palette_name = input$figure_umap_palette, level_count = length(levels), palette_map = all_palettes, default_palette = defaults)
    if (is.null(resolved)) defaults else stats::setNames(resolved, levels)
  })

  output$figure_umap_palette_card_ui <- renderUI({
    tags$div(class = "figure-palette-card", tags$small(class = "text-muted", paste("Current palette:", input$figure_umap_palette %||% "Default Seurat")), figure_palette_swatches_ui(umap_effective_palette()))
  })

  .clean_plot_values <- function(x) {
    out <- as.character(x)
    out[is.na(out) | !nzchar(trimws(out))] <- "NA"
    out
  }

  .expression_values <- function(obj, assay, layer, feature, cells) {
    mat <- tryCatch(.figure_get_assay_data(obj, assay = assay, layer = layer), error = function(e) NULL)
    if (is.null(mat)) stop(sprintf("Assay '%s' has no '%s' expression layer.", assay, layer), call. = FALSE)
    if (!nzchar(feature) || !(feature %in% rownames(mat))) stop(sprintf("Feature '%s' is not available in assay '%s'.", feature, assay), call. = FALSE)
    idx <- match(cells, colnames(mat))
    if (anyNA(idx)) stop("Expression data is missing cells from the selected embedding.", call. = FALSE)
    values <- suppressWarnings(as.numeric(mat[feature, idx, drop = TRUE]))
    values[!is.finite(values)] <- NA_real_
    values
  }

  .continuous_colors <- function(palette_name) {
    if (identical(palette_name, "blue_yellow")) return(c("#1D4ED8", "#FDE047"))
    if (identical(palette_name, "viridis")) return(scales::viridis_pal()(2))
    c("#D9D9D9", "#B91C1C")
  }

  .rgb_hex <- function(red, green, blue) {
    normalize <- function(x) {
      x <- suppressWarnings(as.numeric(x))
      x[!is.finite(x)] <- 0
      if (!length(x) || !any(x > 0)) return(rep(0, length(x)))
      positive <- x[x > 0]
      high <- suppressWarnings(as.numeric(stats::quantile(positive, 0.99, na.rm = TRUE)))
      if (!is.finite(high) || high <= 0) high <- max(positive, na.rm = TRUE)
      if (!is.finite(high) || high <= 0) return(rep(0, length(x)))
      pmax(0, pmin(1, x / high))
    }
    rr <- normalize(red)
    gg <- normalize(green)
    bb <- normalize(blue)
    grDevices::rgb(rr, gg, bb, alpha = 0.95)
  }

  .discrete_palette <- function(obj, state, reduction_name, values, field = NULL, palette_name = "Default Seurat") {
    levels <- figure_color_levels_from_vector(values, column_name = field %||% "value")
    defaults <- if (!is.null(field) && field %in% colnames(obj@meta.data)) {
      figure_resolve_metadata_palette(obj, reduction_name, field, as.character(values), levels)
    } else {
      scales::hue_pal()(max(1L, length(levels)))
    }
    resolved <- figure_resolve_discrete_palette(palette_name = palette_name, level_count = length(levels), palette_map = all_palettes, default_palette = defaults)
    if (is.null(resolved)) resolved <- defaults
    stats::setNames(resolved, levels)
  }

  .resolve_color_data <- function(obj, state, reduction_name) {
    emb <- tryCatch(Seurat::Embeddings(obj, reduction = reduction_name), error = function(e) NULL)
    if (!is.matrix(emb) || ncol(emb) < 2L) stop("Selected embedding is not available for plotting.", call. = FALSE)
    cells <- rownames(emb)
    md <- obj@meta.data
    if (!all(cells %in% rownames(md))) stop("Cell metadata does not match selected embedding.", call. = FALSE)
    mode <- state$color_mode
    if (identical(mode, "metadata")) {
      field <- state$metadata$field
      if (!nzchar(field) || !(field %in% colnames(md))) stop(FIGURE_UMAP_UI_TEXT$no_metadata, call. = FALSE)
      raw <- md[cells, field, drop = TRUE]
      values <- .clean_plot_values(raw)
      levels <- figure_color_levels_from_vector(values, column_name = field)
      return(list(kind = "discrete", values = factor(values, levels = levels), levels = levels, palette = .discrete_palette(obj, state, reduction_name, values, field = field, palette_name = state$metadata$palette), title = field, cells = cells, emb = emb, field = field))
    }
    if (identical(mode, "gene")) {
      values <- .expression_values(obj, state$gene$assay, state$gene$layer, state$gene$feature, cells)
      return(list(kind = "continuous", values = values, low_high = .continuous_colors(state$gene$palette), title = state$gene$feature, cells = cells, emb = emb, assay = state$gene$assay, layer = state$gene$layer, feature = state$gene$feature))
    }
    if (identical(mode, "rgb")) {
      genes <- c(state$rgb$red, state$rgb$green, state$rgb$blue)
      if (any(!nzchar(genes)) || anyDuplicated(genes)) stop(FIGURE_UMAP_UI_TEXT$rgb_invalid, call. = FALSE)
      red <- .expression_values(obj, state$rgb$assay, state$rgb$layer, genes[[1]], cells)
      green <- .expression_values(obj, state$rgb$assay, state$rgb$layer, genes[[2]], cells)
      blue <- .expression_values(obj, state$rgb$assay, state$rgb$layer, genes[[3]], cells)
      return(list(kind = "rgb", values = .rgb_hex(red, green, blue), components = list(red = red, green = green, blue = blue), title = paste(genes, collapse = " / "), cells = cells, emb = emb, assay = state$rgb$assay, layer = state$rgb$layer, genes = genes))
    }
    if (identical(mode, "tcr")) {
      field <- state$tcr$clone_field
      if (!nzchar(field) || !(field %in% colnames(md))) stop(FIGURE_UMAP_UI_TEXT$tcr_unavailable, call. = FALSE)
      raw <- md[cells, field, drop = TRUE]
      clone_ids <- if (exists("vdj_clone_valid_ids", mode = "function")) vdj_clone_valid_ids(raw) else .clean_plot_values(raw)
      clone_ids[is.na(clone_ids) | !nzchar(clone_ids)] <- "No TCR"
      status <- ifelse(clone_ids == "No TCR", "No TCR", "TCR detected")
      size_candidates <- if (grepl("bcr", tolower(field))) c("vdj_bcr_clone_size", "bcr_clone_size", "clone_size") else c("vdj_tcr_clone_size", "tcr_clone_size", "clone_size")
      size_matches <- size_candidates[size_candidates %in% colnames(md)]
      size_field <- if (length(size_matches)) size_matches[[1]] else ""
      if (nzchar(size_field)) clone_size <- suppressWarnings(as.numeric(md[cells, size_field, drop = TRUE])) else {
        counts <- table(clone_ids[clone_ids != "No TCR"])
        clone_size <- as.numeric(counts[clone_ids])
      }
      clone_size[!is.finite(clone_size)] <- 0
      if (identical(state$tcr$display, "clone_size")) return(list(kind = "continuous", values = clone_size, low_high = c("#E5E7EB", "#7C3AED"), title = "TCR clone size", cells = cells, emb = emb, field = field, clone_ids = clone_ids, clone_size = clone_size))
      display_values <- if (identical(state$tcr$display, "status")) status else clone_ids
      return(list(kind = "discrete", values = factor(display_values, levels = figure_color_levels_from_vector(display_values, field)), levels = figure_color_levels_from_vector(display_values, field), palette = .discrete_palette(obj, state, reduction_name, display_values, palette_name = state$tcr$palette), title = if (identical(state$tcr$display, "status")) "TCR status" else field, cells = cells, emb = emb, field = field, clone_ids = clone_ids, clone_size = clone_size))
    }
    stop(FIGURE_UMAP_UI_TEXT$unavailable_modes, call. = FALSE)
  }

  .split_frame <- function(obj, state, cells, x, y, z = NULL) {
    md <- obj@meta.data[cells, , drop = FALSE]
    splits <- figure_normalize_split_vars(state$layout$column_split, state$layout$row_split)
    col_raw <- as.character(splits$column_split %||% "")
    row_raw <- as.character(splits$row_split %||% "")
    col_name <- if (length(col_raw) && nzchar(col_raw[[1]]) && col_raw[[1]] != "__none__") col_raw[[1]] else ""
    row_name <- if (length(row_raw) && nzchar(row_raw[[1]]) && row_raw[[1]] != "__none__") row_raw[[1]] else ""
    if (nzchar(col_name) && !(col_name %in% colnames(md))) stop("UMAP column split field is not available in active object.", call. = FALSE)
    if (nzchar(row_name) && !(row_name %in% colnames(md))) stop("UMAP row split field is not available in active object.", call. = FALSE)
    out <- data.frame(dim1 = x, dim2 = y, stringsAsFactors = FALSE)
    if (!is.null(z)) out$dim3 <- z
    out$split_value <- if (nzchar(col_name)) figure_prepare_split_factor(md[[col_name]], column_name = col_name) else factor("All cells", levels = "All cells")
    out$split_value_secondary <- if (nzchar(row_name)) figure_prepare_split_factor(md[[row_name]], column_name = row_name) else factor("All cells", levels = "All cells")
    out
  }

  .split_panel_specs <- function(obj, state, cells, prefix = "primary::") {
    frame <- .split_frame(obj, state, cells, seq_along(cells), seq_along(cells))
    figure_umap_split_panel_specs(cells, figure_facet_mode(state$layout$column_split, state$layout$row_split), frame$split_value, frame$split_value_secondary, prefix = prefix)
  }

  .subset_color_data <- function(color_data, indices) {
    out <- color_data
    out$cells <- color_data$cells[indices]
    out$emb <- color_data$emb[indices, , drop = FALSE]
    if (!is.null(color_data$values)) out$values <- color_data$values[indices]
    if (!is.null(color_data$clone_ids)) out$clone_ids <- color_data$clone_ids[indices]
    if (!is.null(color_data$clone_size)) out$clone_size <- color_data$clone_size[indices]
    if (is.list(color_data$components)) out$components <- lapply(color_data$components, `[`, indices)
    out
  }

  .camera_base <- function(state) {
    camera <- state$camera
    camera$panels <- NULL
    camera
  }

  .camera_for_panel <- function(state, panel_id) {
    camera <- figure_umap_camera_for_panel(state$camera, panel_id, fallback = .camera_base(state))
    if (is.list(camera$eye) && all(c("x", "y", "z") %in% names(camera$eye))) {
      slider_values <- figure_umap_camera_slider_values(camera)
      camera$azimuth <- slider_values$azimuth
      camera$elevation <- slider_values$elevation
      camera$distance <- slider_values$distance
    }
    camera
  }

  .attach_camera_capture <- function(widget, panel_specs, state) {
    if (is.null(widget)) return(NULL)
    if (!requireNamespace("htmlwidgets", quietly = TRUE)) stop("Interactive camera capture requires the existing htmlwidgets runtime package.", call. = FALSE)
    panel_ids <- vapply(panel_specs, `[[`, character(1), "id")
    cameras <- lapply(panel_ids, function(panel_id) .camera_for_panel(state, panel_id))
    names(cameras) <- panel_ids
    htmlwidgets::onRender(widget, FIGURE_UMAP_CAMERA_CAPTURE_JS, data = list(input_id = "figure_umap_camera_relayout", panels = panel_ids, initial_cameras = cameras))
  }

  .apply_embedding_style <- function(p, state, title, x_label, y_label, legend_position = NULL) {
    appearance <- state$appearance
    figure_apply_plot_theme(p, theme_choice = appearance$plot_theme, title = title, x_label = x_label, y_label = y_label, legend_position = legend_position %||% state$layout$legend_position, legend_text_size = appearance$legend_text_size, axis_text_size = appearance$axis_text_size, axis_title_size = appearance$axis_title_size, plot_title_size = appearance$title_size)
  }

  .resolve_overlay_data <- function(obj, state, color_data, object_label = "active object") {
    source <- as.character(state$overlay$source %||% "none")[[1]]
    if (identical(source, "none")) return(list(source = "none"))
    record <- trajectory_overlay_read(obj, source)
    if (is.null(record)) stop(sprintf("No %s overlay is stored on %s. Run the source analysis first for that object or choose None.", source, object_label), call. = FALSE)
    trajectory_overlay_project(record, color_data$emb, reduction = state$reduction)
  }

  .overlay_split_edges <- function(obj, state, overlay_data) {
    edges <- overlay_data$graph_edges
    mapping <- overlay_data$graph_cell_node
    if (is.null(edges) || !nrow(edges) || is.null(mapping)) return(data.frame())
    cell_df <- data.frame(cell = names(mapping), node = as.character(mapping), stringsAsFactors = FALSE)
    cell_df <- cell_df[cell_df$cell %in% overlay_data$cells, , drop = FALSE]
    if (!nrow(cell_df)) return(data.frame())
    frame <- .split_frame(obj, state, overlay_data$cells, overlay_data$x, overlay_data$y)
    cell_df$split_value <- as.character(frame$split_value[match(cell_df$cell, overlay_data$cells)])
    cell_df$split_value_secondary <- as.character(frame$split_value_secondary[match(cell_df$cell, overlay_data$cells)])
    out <- lapply(seq_len(nrow(edges)), function(i) {
      edge <- edges[i, , drop = FALSE]
      candidates <- unique(cell_df[cell_df$node %in% c(as.character(edge$from), as.character(edge$to)), c("split_value", "split_value_secondary"), drop = FALSE])
      if (!nrow(candidates)) return(NULL)
      rows <- lapply(seq_len(nrow(candidates)), function(j) {
        panel <- candidates[j, , drop = FALSE]
        use <- cell_df$split_value == panel$split_value[[1]] & cell_df$split_value_secondary == panel$split_value_secondary[[1]]
        nodes <- cell_df[use, , drop = FALSE]
        if (!all(c(as.character(edge$from), as.character(edge$to)) %in% nodes$node)) return(NULL)
        from_cells <- nodes$cell[nodes$node == as.character(edge$from)]
        to_cells <- nodes$cell[nodes$node == as.character(edge$to)]
        data.frame(
          dim1 = mean(overlay_data$x[from_cells], na.rm = TRUE),
          dim2 = mean(overlay_data$y[from_cells], na.rm = TRUE),
          xend = mean(overlay_data$x[to_cells], na.rm = TRUE),
          yend = mean(overlay_data$y[to_cells], na.rm = TRUE),
          split_value = panel$split_value[[1]],
          split_value_secondary = panel$split_value_secondary[[1]],
          stringsAsFactors = FALSE
        )
      })
      do.call(rbind, rows)
    })
    out <- out[!vapply(out, is.null, logical(1))]
    if (!length(out)) return(data.frame())
    do.call(rbind, out)
  }

  .add_overlay_layers <- function(p, obj, state, overlay_data) {
    if (identical(overlay_data$source, "none")) return(p)
    if (identical(overlay_data$source, "rna_velocity")) {
      vec <- as.data.frame(overlay_data$vectors, stringsAsFactors = FALSE)
      frame <- .split_frame(obj, state, overlay_data$cells, vec$x, vec$y)
      vec$dim1 <- vec$x
      vec$dim2 <- vec$y
      scale <- as.numeric(state$overlay$velocity_scale %||% 1)
      width <- as.numeric(state$overlay$velocity_width %||% 0.6)
      alpha <- as.numeric(state$overlay$velocity_alpha %||% 0.8)
      if (!is.finite(scale) || scale <= 0 || !is.finite(width) || width <= 0 || !is.finite(alpha) || alpha <= 0 || alpha > 1) stop("RNA velocity overlay settings are invalid.", call. = FALSE)
      vec$xend <- vec$x + vec$vx * scale
      vec$yend <- vec$y + vec$vy * scale
      vec$split_value <- frame$split_value
      vec$split_value_secondary <- frame$split_value_secondary
      display_mode <- state$overlay$velocity_mode %||% "point"
      diagnostic <- trajectory_velocity_display_diagnostic(list(plotting = list(velocity = list(display_mode = display_mode)), field_data = overlay_data$field_data %||% list()), display_mode)
      if (nzchar(diagnostic)) stop(diagnostic, call. = FALSE)
      if (identical(display_mode, "point")) return(p)
      if (identical(display_mode, "stream")) {
        field <- overlay_data$field_data[[display_mode]]
        p <- p + ggplot2::geom_segment(data = field, ggplot2::aes(x, y, xend = xend, yend = yend), inherit.aes = FALSE, color = "#111827", alpha = alpha, linewidth = state$overlay$velocity_stream_linewidth)
        return(p)
      }
      if (display_mode %in% c("grid", "sparse_grid")) {
        field <- overlay_data$field_data[[display_mode]]
        p <- p + ggplot2::geom_segment(data = field, ggplot2::aes(x, y, xend = x + vx, yend = y + vy), inherit.aes = FALSE, color = "#111827", alpha = alpha, linewidth = if (display_mode == "grid") state$overlay$velocity_grid_width else state$overlay$velocity_small_width, arrow = grid::arrow(length = grid::unit(0.12, "cm")))
        return(p)
      }
      if (identical(state$overlay$velocity_color, "group")) {
        groups <- figure_color_levels_from_vector(vec$group, column_name = "velocity_group")
        group_palette <- stats::setNames(scales::hue_pal()(length(groups)), groups)
        vec$overlay_color <- unname(group_palette[as.character(vec$group)])
        p <- p + ggplot2::geom_segment(data = vec, ggplot2::aes(dim1, dim2, xend = xend, yend = yend), inherit.aes = FALSE, color = vec$overlay_color, alpha = alpha, linewidth = width, arrow = grid::arrow(length = grid::unit(0.12, "cm")))
      } else {
        p <- p + ggplot2::geom_segment(data = vec, ggplot2::aes(dim1, dim2, xend = xend, yend = yend), inherit.aes = FALSE, color = "#111827", alpha = alpha, linewidth = width, arrow = grid::arrow(length = grid::unit(0.12, "cm")))
      }
      return(p)
    }
    cell_df <- data.frame(dim1 = overlay_data$x, dim2 = overlay_data$y, pseudotime = overlay_data$pseudotime, annotation = overlay_data$annotation %||% overlay_data$group, cell = overlay_data$cells, stringsAsFactors = FALSE)
    frame <- .split_frame(obj, state, overlay_data$cells, overlay_data$x, overlay_data$y)
    cell_df$split_value <- frame$split_value
    cell_df$split_value_secondary <- frame$split_value_secondary
    if (isTRUE(state$overlay$monocle_cells)) {
      if (identical(state$overlay$monocle_color, "pseudotime")) {
        pt <- cell_df$pseudotime
        finite <- is.finite(pt)
        overlay_colors <- rep("#9CA3AF", nrow(cell_df))
        if (any(finite)) {
          span <- range(pt[finite], na.rm = TRUE)
          scaled <- if (diff(span) > 0) (pt - span[[1]]) / diff(span) else rep(0.5, length(pt))
          ramp <- grDevices::colorRampPalette(scales::viridis_pal()(2))(101)
          overlay_colors[finite] <- ramp[pmax(1L, pmin(101L, floor(scaled[finite] * 100) + 1L))]
        }
        p <- p + ggplot2::geom_point(data = cell_df, ggplot2::aes(dim1, dim2), inherit.aes = FALSE, color = overlay_colors, size = 1.4, alpha = 0.9)
      } else if (identical(state$overlay$monocle_color, "annotation")) {
        if (identical(state$overlay$monocle_palette_source, "manual")) {
          manual <- tryCatch(jsonlite::fromJSON(state$overlay$monocle_manual_palette %||% "{}", simplifyVector = TRUE), error = function(e) list())
          manual <- if (is.list(manual)) unlist(manual, use.names = TRUE) else character(0)
          colors <- unname(manual[as.character(cell_df$annotation)])
          colors[is.na(colors) | !nzchar(colors)] <- "#9CA3AF"
          p <- p + ggplot2::geom_point(data = cell_df, ggplot2::aes(dim1, dim2), inherit.aes = FALSE, color = colors, size = 1.4, alpha = 0.9)
        } else {
          p <- p + ggplot2::geom_point(data = cell_df, ggplot2::aes(dim1, dim2, color = annotation), inherit.aes = FALSE, size = 1.4, alpha = 0.9)
        }
      } else {
        p <- p + ggplot2::geom_point(data = cell_df, ggplot2::aes(dim1, dim2), inherit.aes = FALSE, shape = 1, color = "#111827", stroke = 0.35, size = 1.8, alpha = 0.9)
      }
    }
    if (isTRUE(state$overlay$monocle_label_groups) && any(nzchar(cell_df$annotation))) {
      labels <- stats::aggregate(cbind(dim1, dim2) ~ annotation + split_value + split_value_secondary, data = cell_df[nzchar(cell_df$annotation), , drop = FALSE], FUN = median)
      p <- p + ggplot2::geom_text(data = labels, ggplot2::aes(dim1, dim2, label = annotation), inherit.aes = FALSE, size = 3, fontface = "bold", show.legend = FALSE)
    }
    if (isTRUE(state$overlay$monocle_graph)) {
      source_label <- if (identical(overlay_data$source, "monocle2")) "Monocle2" else "Monocle3"
      if (is.null(overlay_data$graph_edges) || !nrow(overlay_data$graph_edges)) stop(sprintf("%s graph display was requested, but the stored result has no usable principal graph.", source_label), call. = FALSE)
      edge_df <- .overlay_split_edges(obj, state, overlay_data)
      if (nrow(edge_df)) p <- p + ggplot2::geom_segment(data = edge_df, ggplot2::aes(dim1, dim2, xend = xend, yend = yend), inherit.aes = FALSE, color = "#111827", alpha = state$overlay$graph_alpha, linewidth = state$overlay$graph_width)
      if (isTRUE(state$overlay$monocle_label_leaves) || isTRUE(state$overlay$monocle_label_branches)) {
        edges <- overlay_data$graph_edges
        degree <- table(c(as.character(edges$from), as.character(edges$to)))
        nodes <- overlay_data$graph_nodes
        node_names <- rownames(nodes)
        keep <- (isTRUE(state$overlay$monocle_label_leaves) & degree[node_names] == 1) | (isTRUE(state$overlay$monocle_label_branches) & degree[node_names] > 2)
        keep[is.na(keep)] <- FALSE
        if (any(keep)) {
          labels <- data.frame(dim1 = nodes[keep, 1], dim2 = nodes[keep, 2], label = node_names[keep], stringsAsFactors = FALSE)
          p <- p + ggplot2::geom_text(data = labels, ggplot2::aes(dim1, dim2, label = label), inherit.aes = FALSE, size = 2.7, fontface = "bold", show.legend = FALSE)
        }
      }
    }
    p
  }

  .build_embedding_2d <- function(obj, state, color_data, x, y, title_suffix = "", overlay_data = NULL) {
    frame <- .split_frame(obj, state, color_data$cells, x, y)
    frame$value <- color_data$values
    frame$cell <- color_data$cells
    p <- ggplot2::ggplot(frame, ggplot2::aes(dim1, dim2))
    point_size <- as.numeric(state$appearance$point_size %||% 1)
    point_alpha <- as.numeric(state$appearance$point_alpha %||% 1)
    point_shape <- as.integer(state$appearance$point_shape %||% 19L)
    point_stroke <- as.numeric(state$appearance$point_stroke %||% 0)
    if (!is.finite(point_size) || point_size <= 0) point_size <- 1
    if (!is.finite(point_alpha) || point_alpha <= 0) point_alpha <- 1
    if (!is.finite(point_stroke) || point_stroke < 0) point_stroke <- 0
    if (identical(color_data$kind, "discrete")) {
      p <- p + ggplot2::geom_point(ggplot2::aes(color = value), size = point_size, alpha = point_alpha, shape = point_shape, stroke = point_stroke) + ggplot2::scale_color_manual(values = color_data$palette, drop = FALSE, name = color_data$title)
      if (isTRUE(state$layout$annotate)) {
        labels <- stats::aggregate(cbind(dim1, dim2) ~ value + split_value + split_value_secondary, data = frame, FUN = median)
        p <- p + ggplot2::geom_text(data = labels, ggplot2::aes(dim1, dim2, label = value), inherit.aes = FALSE, size = 3.2, fontface = "bold", show.legend = FALSE)
      }
    } else if (identical(color_data$kind, "continuous")) {
      p <- p + ggplot2::geom_point(ggplot2::aes(color = value), size = point_size, alpha = point_alpha, shape = point_shape, stroke = point_stroke) + ggplot2::scale_color_gradient(low = color_data$low_high[[1]], high = color_data$low_high[[2]], na.value = "#9CA3AF", name = color_data$title)
    } else {
      p <- p + ggplot2::geom_point(size = point_size, alpha = point_alpha, shape = point_shape, stroke = point_stroke, color = color_data$values) + ggplot2::labs(subtitle = paste("R:", color_data$genes[[1]], "G:", color_data$genes[[2]], "B:", color_data$genes[[3]]))
    }
    p <- p + ggplot2::coord_fixed()
    split_mode <- figure_facet_mode(state$layout$column_split, state$layout$row_split)
    if (!identical(split_mode, "none")) {
      p <- p + if (identical(split_mode, "grid")) ggplot2::facet_grid(rows = ggplot2::vars(split_value_secondary), cols = ggplot2::vars(split_value), drop = FALSE) else if (identical(split_mode, "column")) ggplot2::facet_wrap(ggplot2::vars(split_value), nrow = 1, drop = FALSE) else ggplot2::facet_wrap(ggplot2::vars(split_value_secondary), ncol = 1, drop = FALSE)
    }
    if (!is.null(overlay_data)) p <- .add_overlay_layers(p, obj, state, overlay_data)
    .apply_embedding_style(p, state, paste(state$title, title_suffix), paste0(state$reduction, "_1"), paste0(state$reduction, "_2"), if (identical(color_data$kind, "rgb")) "none" else NULL)
  }

  .project_3d <- function(emb, state, camera = NULL) {
    camera <- camera %||% state$camera
    azimuth <- pi * as.numeric(camera$azimuth %||% 35) / 180
    elevation <- pi * as.numeric(camera$elevation %||% 25) / 180
    camera_distance <- as.numeric(camera$distance %||% 1.6)
    if (!is.finite(camera_distance) || camera_distance <= 0) stop("3D camera distance must be positive.", call. = FALSE)
    x <- as.numeric(emb[, 1]); y <- as.numeric(emb[, 2]); z <- as.numeric(emb[, 3])
    x1 <- cos(azimuth) * x - sin(azimuth) * y
    y1 <- sin(azimuth) * x + cos(azimuth) * y
    x2 <- x1
    y2 <- cos(elevation) * y1 - sin(elevation) * z
    z2 <- sin(elevation) * y1 + cos(elevation) * z
    zoom <- 1.6 / camera_distance
    x2 <- x2 * zoom
    y2 <- y2 * zoom
    if (identical(camera$projection, "perspective")) {
      scale <- 1 / pmax(0.35, 1 + 0.003 * (z2 - stats::median(z2, na.rm = TRUE)) / camera_distance)
      x2 <- x2 * scale
      y2 <- y2 * scale
    }
    list(x = x2, y = y2, z = z2)
  }

  .build_embedding_3d_static <- function(obj, state, color_data, title_suffix = "", prefix = "primary::") {
    specs <- .split_panel_specs(obj, state, color_data$cells, prefix = prefix)
    split_mode <- figure_facet_mode(state$layout$column_split, state$layout$row_split)
    if (identical(split_mode, "none")) {
      projection <- .project_3d(color_data$emb, state, camera = .camera_for_panel(state, specs[[1]]$id))
      return(.build_embedding_2d(obj, state, color_data, projection$x, projection$y, title_suffix = paste("3D", title_suffix)))
    }
    panel_plots <- lapply(specs, function(spec) {
      indices <- match(spec$cells, color_data$cells)
      panel_data <- .subset_color_data(color_data, indices)
      projection <- .project_3d(panel_data$emb, state, camera = .camera_for_panel(state, spec$id))
      panel_state <- state
      panel_state$layout <- state$layout
      panel_state$layout$column_split <- "__none__"
      panel_state$layout$row_split <- "__none__"
      .build_embedding_2d(obj, panel_state, panel_data, projection$x, projection$y, title_suffix = paste("3D", title_suffix, spec$label))
    })
    patchwork::wrap_plots(panel_plots, ncol = if (identical(split_mode, "row")) 1 else min(2L, length(panel_plots)))
  }

  .combine_3d_panels <- function(panel_plots) {
    if (length(panel_plots) <= 1L) return(panel_plots[[1]])
    built <- lapply(panel_plots, plotly::plotly_build)
    n_panels <- length(built)
    ncols <- min(2L, n_panels)
    nrows <- max(1L, ceiling(n_panels / ncols))
    margin <- 0.03
    x_span <- (1 - margin * (ncols + 1)) / ncols
    y_span <- (1 - margin * (nrows + 1)) / nrows
    result <- built[[1]]
    layout <- result$x$layout
    old_scenes <- grep("^scene[0-9]+$", names(layout), value = TRUE)
    if (length(old_scenes)) layout[old_scenes] <- NULL
    layout$scene <- NULL
    result$x$data <- list()
    for (i in seq_len(n_panels)) {
      scene_id <- if (i == 1L) "scene" else paste0("scene", i)
      traces <- built[[i]]$x$data %||% list()
      for (trace in traces) {
        trace$scene <- scene_id
        result$x$data[[length(result$x$data) + 1L]] <- trace
      }
      row_index <- (i - 1L) %/% ncols
      col_index <- (i - 1L) %% ncols
      x0 <- margin + col_index * (x_span + margin)
      y1 <- 1 - margin - row_index * (y_span + margin)
      scene <- built[[i]]$x$layout$scene %||% list()
      scene$domain <- list(x = c(x0, x0 + x_span), y = c(y1 - y_span, y1))
      layout[[scene_id]] <- scene
    }
    result$x$layout <- layout
    result
  }

  .combine_3d_quantification <- function(umap_widget, quant_widget, pair_layout = "vertical") {
    if (is.null(quant_widget)) return(umap_widget)
    umap <- plotly::plotly_build(umap_widget)
    quant <- plotly::plotly_build(quant_widget)
    layout <- umap$x$layout
    scene_names <- grep("^scene[0-9]*$", names(layout), value = TRUE)
    scale_domain <- function(domain, x0, x1) {
      values <- suppressWarnings(as.numeric(unlist(domain, use.names = FALSE)))
      if (length(values) != 2L || any(!is.finite(values))) values <- c(0, 1)
      c(x0 + values[[1]] * (x1 - x0), x0 + values[[2]] * (x1 - x0))
    }
    scale_scene <- function(scene, x0, x1, y0, y1) {
      domain <- scene$domain %||% list(x = c(0, 1), y = c(0, 1))
      x_domain <- scale_domain(domain$x %||% c(0, 1), x0, x1)
      y_domain <- scale_domain(domain$y %||% c(0, 1), y0, y1)
      scene$domain <- list(x = x_domain, y = y_domain)
      scene
    }
    if (identical(pair_layout, "horizontal")) {
      umap_x <- c(0.02, 0.64); umap_y <- c(0.08, 0.96); quant_x <- c(0.70, 0.98); quant_y <- c(0.10, 0.90)
    } else {
      umap_x <- c(0.04, 0.96); umap_y <- c(0.36, 0.97); quant_x <- c(0.04, 0.96); quant_y <- c(0.05, 0.28)
    }
    for (scene_name in scene_names) layout[[scene_name]] <- scale_scene(layout[[scene_name]], umap_x[[1]], umap_x[[2]], umap_y[[1]], umap_y[[2]])
    quant_axes <- grep("^[xy]axis[0-9]*$", names(quant$x$layout), value = TRUE)
    for (axis_name in quant_axes) {
      axis <- quant$x$layout[[axis_name]]
      if (startsWith(axis_name, "xaxis")) axis$domain <- scale_domain(axis$domain %||% c(0, 1), quant_x[[1]], quant_x[[2]]) else axis$domain <- scale_domain(axis$domain %||% c(0, 1), quant_y[[1]], quant_y[[2]])
      layout[[axis_name]] <- axis
    }
    for (trace in (quant$x$data %||% list())) {
      trace$xaxis <- trace$xaxis %||% "x"
      trace$yaxis <- trace$yaxis %||% "y"
      umap$x$data[[length(umap$x$data) + 1L]] <- trace
    }
    layout$annotations <- c(layout$annotations %||% list(), quant$x$layout$annotations %||% list())
    umap$x$layout <- layout
    umap
  }

  .build_embedding_3d_interactive <- function(obj, state, color_data, title_suffix = "", prefix = "primary::") {
    if (!requireNamespace("plotly", quietly = TRUE)) stop(FIGURE_UMAP_UI_TEXT$plotly_unavailable, call. = FALSE)
    if (ncol(color_data$emb) < 3L) stop(FIGURE_UMAP_UI_TEXT$unavailable_3d, call. = FALSE)
    specs <- .split_panel_specs(obj, state, color_data$cells, prefix = prefix)
    panel_plots <- lapply(specs, function(spec) {
      indices <- match(spec$cells, color_data$cells)
      panel_data <- .subset_color_data(color_data, indices)
      emb <- panel_data$emb
      df <- data.frame(x = emb[, 1], y = emb[, 2], z = emb[, 3], value = panel_data$values, cell = panel_data$cells, stringsAsFactors = FALSE)
      point_size <- as.numeric(state$appearance$point_size %||% 1)
      point_alpha <- as.numeric(state$appearance$point_alpha %||% 1)
      marker <- list(size = max(2, point_size * 3), opacity = min(1, max(0.05, point_alpha)))
      if (identical(panel_data$kind, "rgb")) marker$color <- panel_data$values
      p <- if (identical(panel_data$kind, "discrete")) {
        plotly::plot_ly(df, x = ~x, y = ~y, z = ~z, color = ~value, colors = unname(panel_data$palette), type = "scatter3d", mode = "markers", marker = marker, text = ~cell, hoverinfo = "text")
      } else if (identical(panel_data$kind, "continuous")) {
        plotly::plot_ly(df, x = ~x, y = ~y, z = ~z, color = ~value, colors = grDevices::colorRampPalette(panel_data$low_high)(100), type = "scatter3d", mode = "markers", marker = marker, text = ~cell, hoverinfo = "text")
      } else {
        plotly::plot_ly(df, x = ~x, y = ~y, z = ~z, type = "scatter3d", mode = "markers", marker = marker, text = ~cell, hoverinfo = "text")
      }
      camera <- .camera_for_panel(state, spec$id)
      azimuth <- pi * as.numeric(camera$azimuth %||% 35) / 180
      elevation <- pi * as.numeric(camera$elevation %||% 25) / 180
      camera_distance <- as.numeric(camera$distance %||% 1.6)
      if (!is.finite(camera_distance) || camera_distance <= 0) stop("3D camera distance must be positive.", call. = FALSE)
      eye <- camera$eye
      if (!is.list(eye) || !all(c("x", "y", "z") %in% names(eye))) {
        eye_distance <- camera_distance / 1.6
        eye <- list(x = cos(azimuth) * cos(elevation) * eye_distance, y = sin(azimuth) * cos(elevation) * eye_distance, z = sin(elevation) * eye_distance)
      }
      camera_plotly <- list(eye = eye, projection = list(type = if (identical(camera$projection, "orthographic")) "orthographic" else "perspective"))
      axis <- list(title = "", showticklabels = isTRUE(camera$axes), showgrid = isTRUE(camera$axes))
      plotly::config(plotly::layout(p, title = paste(state$title, "3D", title_suffix, spec$label), scene = list(xaxis = axis, yaxis = axis, zaxis = axis, camera = camera_plotly), showlegend = !identical(panel_data$kind, "rgb")), displaylogo = FALSE, responsive = TRUE)
    })
    .combine_3d_panels(panel_plots)
  }

  .quantification_target <- function(obj, state, color_data) {
    md <- obj@meta.data[color_data$cells, , drop = FALSE]
    if (identical(state$quantification$target, "explicit_metadata")) {
      field <- state$quantification$field
      if (!nzchar(field) || !(field %in% colnames(md))) stop("Quantification field is not available in active object.", call. = FALSE)
      return(list(name = field, values = md[[field]], categorical = !is.numeric(md[[field]]), palette = NULL))
    }
    if (identical(state$color_mode, "metadata")) return(list(name = state$metadata$field, values = md[[state$metadata$field]], categorical = TRUE, palette = color_data$palette))
    if (identical(state$color_mode, "gene")) return(list(name = state$gene$feature, values = .expression_values(obj, state$gene$assay, state$gene$layer, state$gene$feature, rownames(md)), categorical = FALSE, palette = NULL))
    if (identical(state$color_mode, "rgb")) {
      component <- state$rgb$quant_component
      component_genes <- c(state$rgb$red, state$rgb$green, state$rgb$blue)
      if (!nzchar(component) || !(component %in% component_genes)) stop(FIGURE_UMAP_UI_TEXT$rgb_invalid, call. = FALSE)
      return(list(name = paste("RGB component", component), values = .expression_values(obj, state$rgb$assay, state$rgb$layer, component, rownames(md)), categorical = FALSE, palette = NULL))
    }
    if (identical(state$color_mode, "tcr")) {
      if (identical(state$tcr$display, "clone_size")) return(list(name = "TCR clone size", values = color_data$clone_size, categorical = FALSE, palette = NULL))
      if (identical(state$tcr$display, "status")) return(list(name = "TCR status", values = ifelse(color_data$clone_ids == "No TCR", "No TCR", "TCR detected"), categorical = TRUE, palette = color_data$palette))
      return(list(name = state$tcr$clone_field, values = color_data$clone_ids, categorical = TRUE, palette = color_data$palette))
    }
    stop(FIGURE_UMAP_UI_TEXT$unavailable_modes, call. = FALSE)
  }

  .build_alluvial_quantification_plot <- function(obj, state, color_data, md) {
    # Agent note: ggplotly cannot serialize ggalluvial reliably; keep alluvial
    # quantification on static preview/export paths and expose that boundary in
    # the 3D interactive surface instead of dropping the quant panel.
    if (!requireNamespace("ggalluvial", quietly = TRUE)) stop("Alluvial quantification requires the existing ggalluvial runtime package.", call. = FALSE)
    cfg <- state$quantification$alluvial %||% list()
    axis_slots <- c("axis_1", "axis_2", "axis_3", "axis_4")
    axes <- vapply(axis_slots, function(slot) as.character(cfg[[slot]] %||% "__none__")[[1]], character(1))
    split_col <- state$quantification$split_by
    if (identical(split_col, "same_as_umap")) split_col <- state$layout$column_split
    prepared <- figure_umap_prepare_alluvial_data(md, axes, split = split_col, unit = state$quantification$unit, node_order = cfg$node_order)
    color_slot <- as.character(cfg$color_axis %||% "axis_1")[[1]]
    if (!(color_slot %in% axis_slots)) stop("Alluvial ribbon color source must reference one ordered axis.", call. = FALSE)
    color_axis <- axes[[match(color_slot, axis_slots)]]
    if (identical(color_axis, "__none__") || !nzchar(color_axis)) stop("Alluvial ribbon color source must reference a selected axis.", call. = FALSE)
    color_levels <- prepared$node_levels[[color_axis]]
    palette_values <- .discrete_palette(obj, state, state$reduction, as.character(md[[color_axis]]), field = color_axis, palette_name = state$metadata$palette)
    palette_values <- palette_values[color_levels]
    if (anyNA(palette_values)) stop("Alluvial ribbon color palette does not cover selected axis levels.", call. = FALSE)

    alpha <- suppressWarnings(as.numeric(cfg$ribbon_alpha)[[1]])
    ribbon_width <- suppressWarnings(as.numeric(cfg$ribbon_width)[[1]])
    if (!is.finite(alpha) || alpha <= 0 || alpha > 1) stop("Alluvial ribbon opacity must be between 0 and 1.", call. = FALSE)
    if (!is.finite(ribbon_width) || ribbon_width <= 0 || ribbon_width > 1) stop("Alluvial ribbon width must be between 0 and 1.", call. = FALSE)

    lodes <- prepared$lodes
    color_index <- match(lodes$alluvium, as.character(prepared$flow$flow_id))
    lodes$color_value <- factor(as.character(prepared$flow[[color_axis]][color_index]), levels = color_levels)
    has_split <- !is.null(prepared$split)
    p <- ggplot2::ggplot(
      lodes,
      ggplot2::aes(x = .data$axis, stratum = .data$stratum_key, alluvium = .data$alluvium, y = .data$weight, fill = .data$color_value)
    ) +
      ggalluvial::geom_alluvium(alpha = alpha, width = ribbon_width, curve_type = "xspline", knot.pos = 0.5, color = NA) +
      ggalluvial::geom_stratum(width = ribbon_width, alpha = 0.9, color = "#4D4D4D", linewidth = 0.15) +
      ggplot2::scale_fill_manual(values = palette_values, drop = FALSE, name = color_axis) +
      ggplot2::scale_x_discrete(limits = prepared$axes, labels = prepared$axes, drop = FALSE, expand = ggplot2::expansion(mult = c(0.08, 0.08)))
    if (has_split) p <- p + ggplot2::facet_wrap(~split, scales = "free_y", drop = FALSE)

    anchor_plot <- ggplot2::ggplot(
      lodes,
      ggplot2::aes(x = .data$axis, stratum = .data$stratum_key, alluvium = .data$alluvium, y = .data$weight)
    ) + ggalluvial::geom_stratum(width = ribbon_width, alpha = 0)
    if (has_split) anchor_plot <- anchor_plot + ggplot2::facet_wrap(~split, scales = "free_y", drop = FALSE)
    anchor_build <- ggplot2::ggplot_build(anchor_plot)
    anchor_index <- which(vapply(anchor_build$data, function(data) all(c("x", "stratum", "ymin", "ymax", "PANEL") %in% colnames(data)), logical(1)))
    if (!length(anchor_index)) stop("Could not compute alluvial stratum labels.", call. = FALSE)
    anchors <- anchor_build$data[[anchor_index[[1]]]]
    labels <- unlist(lapply(prepared$axes, function(axis) {
      stats::setNames(prepared$node_levels[[axis]], paste0(axis, "::", prepared$node_levels[[axis]]))
    }), use.names = TRUE)
    anchors$label <- unname(labels[as.character(anchors$stratum)])
    if (anyNA(anchors$label)) stop("Could not resolve alluvial stratum labels.", call. = FALSE)
    anchors$ymid <- (anchors$ymin + anchors$ymax) / 2
    panel_layout <- tryCatch(anchor_build$layout$layout, error = function(e) NULL)
    if (has_split && !is.null(panel_layout) && "split" %in% colnames(panel_layout)) {
      anchors <- merge(anchors, panel_layout[, c("PANEL", "split"), drop = FALSE], by = "PANEL", all.x = TRUE, sort = FALSE)
    }
    if (isTRUE(cfg$show_labels)) {
      p <- p + ggplot2::geom_text(data = anchors, ggplot2::aes(x = .data$x, y = .data$ymid, label = .data$label), inherit.aes = FALSE, size = 3, check_overlap = TRUE)
    }
    y_label <- if (identical(prepared$unit, "percentage")) "Percentage of cells per facet" else "Cell count"
    figure_apply_plot_theme(
      p,
      theme_choice = state$appearance$plot_theme,
      title = "Metadata alluvial quantification",
      x_label = NULL,
      y_label = y_label,
      legend_position = state$layout$legend_position,
      legend_text_size = state$appearance$legend_text_size,
      axis_text_size = state$appearance$axis_text_size,
      axis_title_size = state$appearance$axis_title_size,
      plot_title_size = state$appearance$title_size
    )
  }

  .build_quantification_plot <- function(obj, state, color_data) {
    if (!isTRUE(state$quantification$enabled)) return(ggplot2::ggplot() + ggplot2::theme_void() + ggplot2::labs(title = "Quantification disabled"))
    md <- obj@meta.data[color_data$cells, , drop = FALSE]
    if (identical(state$quantification$chart, "alluvial")) return(.build_alluvial_quantification_plot(obj, state, color_data, md))
    group_col <- state$quantification$group_by
    if (!nzchar(group_col) || !(group_col %in% colnames(md))) stop("Quantification group is not available in active object.", call. = FALSE)
    split_col <- state$quantification$split_by
    if (identical(split_col, "same_as_umap")) split_col <- state$layout$column_split
    split_enabled <- nzchar(split_col) && !identical(split_col, "__none__")
    if (split_enabled && !(split_col %in% colnames(md))) stop("Quantification split field is not available in active object.", call. = FALSE)
    target <- .quantification_target(obj, state, color_data)
    clean <- .clean_plot_values
    qdf <- data.frame(group = clean(md[[group_col]]), split = if (split_enabled) clean(md[[split_col]]) else "All cells", stringsAsFactors = FALSE)
    if (!isTRUE(target$categorical) && is.numeric(target$values)) {
      qdf$value <- suppressWarnings(as.numeric(target$values))
      qdf <- qdf[is.finite(qdf$value), , drop = FALSE]
      if (!nrow(qdf)) stop("Quantification field has no finite numeric values.", call. = FALSE)
      qdf$group <- factor(qdf$group, levels = sort(unique(qdf$group)))
      chart <- state$quantification$chart
      if (identical(chart, "auto") || identical(chart, "composition")) chart <- "violin"
      p <- ggplot2::ggplot(qdf, ggplot2::aes(x = group, y = value, fill = group))
      if (identical(chart, "box")) p <- p + ggplot2::geom_boxplot(width = 0.62, outlier.size = 0.35, alpha = 0.78)
      else if (identical(chart, "dot")) p <- p + ggplot2::geom_jitter(width = 0.18, height = 0, size = 0.7, alpha = 0.55)
      else {
        if (!identical(chart, "violin")) stop("Numeric quantification supports violin, box, or dot charts.", call. = FALSE)
        p <- p + ggplot2::geom_violin(scale = "width", trim = TRUE, alpha = 0.78, color = "#374151") + ggplot2::geom_boxplot(width = 0.12, outlier.size = 0.25, alpha = 0.42)
      }
      if (split_enabled) p <- p + ggplot2::facet_wrap(~split)
      return(figure_apply_plot_theme(p, theme_choice = state$appearance$plot_theme, title = paste(target$name, "quantification"), x_label = group_col, y_label = target$name, legend_position = "none", legend_text_size = state$appearance$legend_text_size, axis_text_size = state$appearance$axis_text_size, axis_title_size = state$appearance$axis_title_size, plot_title_size = state$appearance$title_size))
    }
    categories <- clean(target$values)
    levels <- figure_color_levels_from_vector(categories, target$name)
    qdf$category <- factor(categories, levels = levels)
    counts <- as.data.frame(table(qdf$split, qdf$group, qdf$category), stringsAsFactors = FALSE)
    names(counts) <- c("split", "group", "category", "count")
    counts <- counts[counts$count > 0, , drop = FALSE]
    if (!nrow(counts)) stop("Quantification field has no categorical values.", call. = FALSE)
    counts$height <- as.numeric(counts$count)
    if (identical(state$quantification$unit, "percentage")) {
      totals <- stats::aggregate(count ~ split + group, data = counts, FUN = sum)
      names(totals)[3] <- "total"
      counts <- merge(counts, totals, by = c("split", "group"), all.x = TRUE, sort = FALSE)
      counts$height <- 100 * counts$count / counts$total
      y_label <- "Percentage"
    } else y_label <- "Cell count"
    pal <- target$palette %||% stats::setNames(scales::hue_pal()(length(levels)), levels)
    pal <- pal[levels]
    chart <- state$quantification$chart
    if (identical(chart, "auto")) chart <- "composition"
    if (!(chart %in% c("composition", "dot"))) stop("Categorical quantification supports composition or dot charts.", call. = FALSE)
    p <- ggplot2::ggplot(counts, ggplot2::aes(x = group, y = height, fill = category))
    if (identical(chart, "dot")) p <- p + ggplot2::geom_point(position = ggplot2::position_dodge(width = 0.7), size = 2.2)
    else p <- p + ggplot2::geom_col(position = "stack", alpha = 0.9)
    if (split_enabled) p <- p + ggplot2::facet_wrap(~split)
    p <- p + ggplot2::scale_fill_manual(values = pal, drop = FALSE)
    figure_apply_plot_theme(p, theme_choice = state$appearance$plot_theme, title = paste(target$name, "quantification"), x_label = group_col, y_label = y_label, legend_position = state$layout$legend_position, legend_text_size = state$appearance$legend_text_size, axis_text_size = state$appearance$axis_text_size, axis_title_size = state$appearance$axis_title_size, plot_title_size = state$appearance$title_size)
  }

  .build_workspace_bundle <- function(obj, state, title_suffix = "", prefix = "primary::") {
    red <- state$reduction
    dims <- .reduction_dimensions(obj, red)
    if (dims < 2L) stop("Selected embedding does not provide two dimensions.", call. = FALSE)
    if (identical(state$view_mode, "3d") && dims < 3L) stop(FIGURE_UMAP_UI_TEXT$unavailable_3d, call. = FALSE)
    color_data <- .resolve_color_data(obj, state, red)
    overlay_data <- NULL
    overlay_notice <- ""
    if (!identical(state$overlay$source, "none")) {
      if (identical(state$view_mode, "3d")) {
        overlay_notice <- "Trajectory overlays are currently supported in 2D static and export views. Switch View mode to 2D to display this overlay; 3D camera state remains unchanged."
      } else {
        overlay_data <- .resolve_overlay_data(obj, state, color_data, object_label = if (nzchar(title_suffix)) trimws(title_suffix) else "active object")
      }
    }
    camera_specs <- if (identical(state$view_mode, "3d")) .split_panel_specs(obj, state, color_data$cells, prefix = prefix) else list()
    static_umap <- if (identical(state$view_mode, "3d")) .build_embedding_3d_static(obj, state, color_data, title_suffix = title_suffix, prefix = prefix) else .build_embedding_2d(obj, state, color_data, color_data$emb[, 1], color_data$emb[, 2], title_suffix = title_suffix, overlay_data = overlay_data)
    quant <- .build_quantification_plot(obj, state, color_data)
    static_composition <- if (!isTRUE(state$quantification$enabled)) static_umap else if (identical(state$export$pair_layout, "horizontal")) patchwork::wrap_plots(static_umap, quant, nrow = 1) else patchwork::wrap_plots(static_umap, quant, ncol = 1, heights = c(2, 1))
    interactive_umap <- NULL
    interactive_quant <- NULL
    interactive_composition <- NULL
    if (identical(state$view_mode, "3d")) {
      interactive_umap <- .build_embedding_3d_interactive(obj, state, color_data, title_suffix = title_suffix, prefix = prefix)
      if (!identical(state$quantification$chart, "alluvial")) {
        interactive_quant <- plotly::config(plotly::ggplotly(quant, tooltip = "none"), displaylogo = FALSE, responsive = TRUE)
        interactive_composition <- .combine_3d_quantification(interactive_umap, if (isTRUE(state$quantification$enabled)) interactive_quant else NULL, state$export$pair_layout)
      }
    }
    list(static_umap = static_umap, quant = quant, static_composition = static_composition, interactive_umap = interactive_umap, interactive_quant = interactive_quant, interactive_composition = interactive_composition, camera_specs = camera_specs, overlay_notice = overlay_notice, object_name = title_suffix)
  }

  .combine_static <- function(primary, secondary, layout) {
    if (identical(layout, "vertical")) patchwork::wrap_plots(primary, secondary, ncol = 1) else patchwork::wrap_plots(primary, secondary, nrow = 1)
  }

  .combine_interactive <- function(primary, secondary, layout) {
    if (!requireNamespace("plotly", quietly = TRUE)) stop(FIGURE_UMAP_UI_TEXT$plotly_unavailable, call. = FALSE)
    if (identical(layout, "vertical")) plotly::subplot(primary, secondary, nrows = 2, margin = 0.03) else plotly::subplot(primary, secondary, nrows = 1, margin = 0.03)
  }

  plot_bundle <- reactiveVal(list(error = "Waiting for active object."))
  bundle_signature <- reactiveVal("")
  observe({
    obj_result <- tryCatch(list(ok = TRUE, value = active_object()), error = function(e) list(ok = FALSE, error = conditionMessage(e)))
    if (!isTRUE(obj_result$ok)) {
      plot_bundle(list(error = paste("Active object resolution failed:", obj_result$error %||% FIGURE_UMAP_UI_TEXT$no_object)))
      return(invisible(NULL))
    }
    obj <- obj_result$value
    state_result <- tryCatch(list(ok = TRUE, value = .snapshot_workspace_state(obj)), error = function(e) list(ok = FALSE, error = paste0(conditionMessage(e), " [", paste(class(e), collapse = ","), "]")))
    if (!isTRUE(state_result$ok)) {
      plot_bundle(list(error = paste("Figure Studio state resolution failed:", state_result$error %||% "Unknown state error.")))
      return(invisible(NULL))
    }
    state <- state_result$value
    key <- paste(context_revision(), jsonlite::toJSON(state, auto_unbox = TRUE, null = "null"), sep = "::")
    if (identical(bundle_signature(), key)) return(invisible(NULL))
    bundle_signature(key)
    result <- tryCatch({
      primary <- .build_workspace_bundle(obj, state, prefix = "primary::")
      static_umap <- primary$static_umap
      static_quant <- primary$quant
      static_composition <- primary$static_composition
      interactive_umap <- primary$interactive_umap
      interactive_quant <- primary$interactive_quant
      interactive_composition <- primary$interactive_composition
      overlay_notices <- primary$overlay_notice
      compare_name <- state$comparison$object
      if (identical(state$comparison$mode, "two")) {
        registry <- shared_data$all_seurat_objects %||% list()
        if (!nzchar(compare_name) || is.null(registry[[compare_name]])) stop("Comparison object is not available in the settled object registry.", call. = FALSE)
        compare_obj <- figure_extract_seurat_object(registry[[compare_name]])
        if (is.null(compare_obj)) stop("Comparison object is not a Seurat object.", call. = FALSE)
        secondary <- .build_workspace_bundle(compare_obj, state, title_suffix = paste("-", compare_name), prefix = "secondary::")
        static_umap <- .combine_static(static_umap, secondary$static_umap, state$comparison$layout)
        static_quant <- .combine_static(static_quant, secondary$quant, state$comparison$layout)
        static_composition <- .combine_static(static_composition, secondary$static_composition, state$comparison$layout)
        overlay_notices <- c(overlay_notices, secondary$overlay_notice)
        if (identical(state$view_mode, "3d")) {
          interactive_umap <- .combine_interactive(interactive_umap, secondary$interactive_umap, state$comparison$layout)
          interactive_quant <- .combine_interactive(interactive_quant, secondary$interactive_quant, state$comparison$layout)
          interactive_composition <- .combine_interactive(interactive_composition, secondary$interactive_composition, state$comparison$layout)
          camera_specs <- c(primary$camera_specs, secondary$camera_specs)
          interactive_umap <- .attach_camera_capture(interactive_umap, camera_specs, state)
          interactive_composition <- .attach_camera_capture(interactive_composition, camera_specs, state)
        }
      } else if (identical(state$view_mode, "3d")) {
        interactive_umap <- .attach_camera_capture(interactive_umap, primary$camera_specs, state)
        interactive_composition <- .attach_camera_capture(interactive_composition, primary$camera_specs, state)
      }
      list(error = "", umap = static_umap, quant = static_quant, composition = static_composition, interactive_umap = interactive_umap, interactive_quant = interactive_quant, interactive_composition = interactive_composition, overlay_notice = paste(unique(overlay_notices[nzchar(overlay_notices)]), collapse = " "), state = state, object_name = canonical_object_name())
    }, error = function(e) {
      msg <- conditionMessage(e)
      if (!nzchar(msg)) msg <- paste(class(e), collapse = ",")
      call_txt <- tryCatch(paste(deparse(conditionCall(e)), collapse = " "), error = function(err) "")
      list(error = paste0(msg, if (nzchar(call_txt)) paste0(" [", call_txt, "]") else ""), state = state, object_name = canonical_object_name())
    })
    plot_bundle(result)
    invisible(NULL)
  })

  output$figure_umap_context_diagnostics <- renderUI({
    obj <- tryCatch(active_object(), error = function(e) NULL)
    if (is.null(obj)) return(tags$small(class = "text-warning", FIGURE_UMAP_UI_TEXT$no_object))
    red <- selected_reduction()
    if (!nzchar(red)) return(tags$small(class = "text-warning", "No usable embedding is available."))
    dims <- .reduction_dimensions(obj, red)
    if (identical(as.character(input$figure_umap_view_mode %||% "2d")[[1]], "3d") && dims < 3L) return(tags$small(class = "text-warning", FIGURE_UMAP_UI_TEXT$unavailable_3d))
    tags$small(class = "text-muted", paste("Resolved:", red, "(", dims, "dimensions)"))
  })

  output$figure_umap_overlay_diagnostic <- renderUI({
    obj <- tryCatch(active_object(), error = function(e) NULL)
    source <- as.character(input$figure_umap_overlay_source %||% "none")[[1]]
    if (identical(source, "none")) return(tags$small(class = "text-muted", "No overlay selected."))
    if (is.null(obj)) return(tags$small(class = "text-warning", "Overlay source cannot be checked until an active object is selected."))
    rec <- tryCatch(trajectory_overlay_read(obj, source), error = function(e) e)
    if (inherits(rec, "error")) return(tags$small(class = "text-danger", conditionMessage(rec)))
    if (is.null(rec)) return(tags$small(class = "text-warning", sprintf("No %s overlay is stored on this object.", source)))
    if (source %in% c("monocle2", "monocle3") && nzchar(as.character(rec$graph_diagnostic %||% ""))) {
      return(tags$small(class = "text-warning", paste("Available cells:", length(rec$cells), "Graph:", rec$graph_diagnostic)))
    }
    tags$small(class = "text-success", paste("Available cells:", length(rec$cells), "Source:", source))
  })

  output$figure_umap_diagnostics <- renderUI({
    bundle <- plot_bundle()
    msgs <- character(0)
    if (nzchar(bundle$error %||% "")) msgs <- c(msgs, bundle$error)
    if (nzchar(bundle$overlay_notice %||% "")) msgs <- c(msgs, bundle$overlay_notice)
    if (!length(msgs)) return(tags$small(class = "text-success", "Preview and export use the same settled object, color branch, and quantification bundle."))
    tags$ul(class = "text-warning", lapply(unique(msgs), tags$li))
  })

  output$figure_umap_plot_surface <- renderUI({
    bundle <- plot_bundle()
    overlay_notice <- if (is.list(bundle) && nzchar(bundle$overlay_notice %||% "")) tags$div(class = "alert alert-warning p-2 small", bundle$overlay_notice) else NULL
    view_mode <- as.character(input$figure_umap_view_mode %||% "2d")[[1]]
    renderer <- as.character(input$figure_umap_preview_renderer %||% "interactive")[[1]]
    if (identical(renderer, "static")) {
      return(tagList(overlay_notice, figure_with_busy_spinner(plotOutput("figure_umap_static_plot", width = "100%", height = "100%"))))
    }
    if (identical(view_mode, "3d")) {
      if (!requireNamespace("plotly", quietly = TRUE)) return(tags$small(class = "text-warning", FIGURE_UMAP_UI_TEXT$plotly_unavailable))
      focus <- as.character(input$figure_umap_focus_view %||% "paired")[[1]]
      chart <- as.character(input$figure_umap_quant_chart %||% "auto")[[1]]
      if (identical(chart, "alluvial") && !identical(focus, "umap")) return(tags$small(class = "text-warning", FIGURE_UMAP_UI_TEXT$alluvial_interactive_note))
      return(tagList(overlay_notice, figure_with_busy_spinner(plotly::plotlyOutput("figure_umap_plotly", width = "100%", height = "100%"))))
    }
    tagList(overlay_notice, figure_with_busy_spinner(plotOutput("figure_umap_plot", width = "100%", height = "100%")))
  })

  output$figure_umap_plot <- renderPlot({
    bundle <- plot_bundle()
    validate(need(is.list(bundle) && !nzchar(bundle$error %||% ""), bundle$error %||% FIGURE_UMAP_UI_TEXT$no_object))
    focus <- as.character(input$figure_umap_focus_view %||% "paired")[[1]]
    if (identical(focus, "umap")) bundle$umap else if (identical(focus, "quant")) bundle$quant else bundle$composition
  }, width = function() as.integer(preview_dims()$width_px), height = function() as.integer(preview_dims()$height_px), res = 96)

  output$figure_umap_static_plot <- renderPlot({
    bundle <- plot_bundle()
    validate(need(is.list(bundle) && !nzchar(bundle$error %||% ""), bundle$error %||% FIGURE_UMAP_UI_TEXT$no_object))
    .selected_export_plot(bundle)
  }, width = function() as.integer(preview_dims()$width_px), height = function() as.integer(preview_dims()$height_px), res = 96)

  if (requireNamespace("plotly", quietly = TRUE)) {
    output$figure_umap_plotly <- plotly::renderPlotly({
      bundle <- plot_bundle()
      validate(need(is.list(bundle) && !nzchar(bundle$error %||% ""), bundle$error %||% FIGURE_UMAP_UI_TEXT$no_object))
      focus <- as.character(input$figure_umap_focus_view %||% "paired")[[1]]
      selected <- if (identical(focus, "umap")) bundle$interactive_umap else if (identical(focus, "quant")) bundle$interactive_quant else bundle$interactive_composition
      validate(need(!is.null(selected), FIGURE_UMAP_UI_TEXT$alluvial_interactive_note))
      selected
    })
  }

  generated_plot_code <- reactive({
    state <- .current_workspace_state()
    figure_recipe_code_lines(analysis_recipe = list(object_name = canonical_object_name(), reduction = selected_reduction()), figure_recipe = list(workspace = state, note = "The active color branch, paired quantification, comparison, and export format are resolved from one workspace state."))
  })

  figure_code_card_server("figure_umap_code_card", code_text_reactive = generated_plot_code, shared_data = shared_data, object_name_reactive = canonical_object_name, studio_name = "UMAP + Quantification Studio")

  .apply_preview <- function() {
    dims <- .normalize_preview_px(input$figure_umap_width, input$figure_umap_height, input$figure_umap_units)
    preview_dims(dims)
    session$sendCustomMessage("wl_figure_preview_fit", list(stage_id = "figure_umap_preview_stage", frame_id = "figure_umap_preview_frame", width_px = dims$width_px, height_px = dims$height_px))
    invisible(dims)
  }

  observeEvent(input$figure_umap_apply_preview, .apply_preview(), ignoreInit = TRUE)
  observeEvent(input$main_navbar, {
    if (identical(input$main_navbar %||% "", "figure_studio_umap")) .apply_preview()
  }, ignoreInit = FALSE)

  .selected_export_plot <- function(bundle) {
    figure_umap_select_composition_plot(bundle, input$figure_umap_export_composition %||% "paired")
  }

  .selected_export_interactive_plot <- function(bundle) {
    composition <- as.character(input$figure_umap_export_composition %||% "paired")[[1]]
    if (identical(composition, "umap")) bundle$interactive_umap else if (identical(composition, "quant")) bundle$interactive_quant else bundle$interactive_composition
  }

  .figure_umap_pdf_bundle <- function(kind, width_px = NULL, height_px = NULL) {
    req(identical(kind, "umap_pdf"))
    bundle <- plot_bundle()
    validate(need(is.list(bundle) && !nzchar(bundle$error %||% ""), bundle$error %||% FIGURE_UMAP_UI_TEXT$no_object))
    width_raw <- suppressWarnings(as.numeric(input$figure_umap_width %||% 10))
    height_raw <- suppressWarnings(as.numeric(input$figure_umap_height %||% 11))
    if (!is.finite(width_raw) || width_raw <= 0) width_raw <- 10
    if (!is.finite(height_raw) || height_raw <= 0) height_raw <- 11
    units_raw <- as.character(input$figure_umap_units %||% "in")[[1]]
    width_in <- if (identical(units_raw, "cm")) width_raw / 2.54 else width_raw
    height_in <- if (identical(units_raw, "cm")) height_raw / 2.54 else height_raw
    if (length(width_px) && is.finite(width_px[[1]]) && width_px[[1]] > 0) width_in <- width_px[[1]] / 96
    if (length(height_px) && is.finite(height_px[[1]]) && height_px[[1]] > 0) height_in <- height_px[[1]] / 96
    list(plot = .selected_export_plot(bundle), width_px = as.integer(max(320, round(width_in * 96))), height_px = as.integer(max(240, round(height_in * 96))), filename_prefix = paste0(bundle$object_name %||% "dataset", "_UMAP_quantification_"))
  }

  pdf_server <- get0("wl_pdf_modal_server", mode = "function", ifnotfound = NULL)
  if (is.null(pdf_server)) stop("Shared PDF modal helper is unavailable.")
  pdf_modal <- pdf_server(input = input, output = output, session = session, id_prefix = "figure_umap_pdf", build_bundle = .figure_umap_pdf_bundle, download_btn_label = FIGURE_UMAP_UI_TEXT$download_pdf, default_modal_title = "PDF export settings: UMAP + quantification")
  observeEvent(input$open_umap_pdf_modal, pdf_modal$open("umap_pdf", title_txt = "PDF export settings: UMAP + quantification"), ignoreInit = TRUE)

  output$download_umap_export <- downloadHandler(
    filename = function() {
      format <- as.character(input$figure_umap_export_format %||% "pdf")[[1]]
      paste0(canonical_object_name() %||% "dataset", "_UMAP_quantification.", format)
    },
    content = function(file) {
      bundle <- plot_bundle()
      validate(need(!nzchar(bundle$error %||% ""), bundle$error %||% FIGURE_UMAP_UI_TEXT$no_object))
      format <- as.character(input$figure_umap_export_format %||% "pdf")[[1]]
      if (identical(format, "html")) {
        widget <- .selected_export_interactive_plot(bundle)
        if (is.null(widget)) stop("HTML export is available only for the interactive 3D renderer.", call. = FALSE)
        if (!requireNamespace("htmlwidgets", quietly = TRUE)) stop("HTML export requires the existing htmlwidgets runtime package.", call. = FALSE)
        htmlwidgets::saveWidget(widget, file = file, selfcontained = TRUE)
        return(invisible(NULL))
      }
      width <- suppressWarnings(as.numeric(input$figure_umap_width %||% 10))
      height <- suppressWarnings(as.numeric(input$figure_umap_height %||% 11))
      units <- as.character(input$figure_umap_units %||% "in")[[1]]
      dpi <- suppressWarnings(as.numeric(input$figure_umap_dpi %||% 300))
      if (!is.finite(width) || width <= 0) width <- 10
      if (!is.finite(height) || height <= 0) height <- 11
      if (!is.finite(dpi) || dpi <= 0) dpi <- 300
      device <- if (identical(format, "svg")) "svg" else if (identical(format, "png")) "png" else "pdf"
      ggplot2::ggsave(filename = file, plot = .selected_export_plot(bundle), device = device, width = width, height = height, units = units, dpi = dpi)
      invisible(NULL)
    }
  )
}
