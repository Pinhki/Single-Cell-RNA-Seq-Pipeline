# Shared Figure Studio code-card helpers
if (!exists("%||%", mode = "function")) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
}

FIGURE_CODE_CARD_TEXT <- list(
  save_recipe = "Save Recipe to Workspace",
  download_recipe = "Download Recipe JSON",
  saved_recipe = "Recipe saved with dataset '%s'.",
  missing_dataset = "Select a valid dataset before saving the recipe."
)

figure_code_card_assets <- htmltools::singleton(
  shiny::tagList(
    wl_code_block_assets(),
    shiny::tags$style(shiny::HTML("
      .wl-figure-code-toolbar{
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:10px;
        margin:8px 0 8px 0;
      }
      .wl-figure-code-label{
        margin:0;
      }
      .wl-figure-code-toolbar .btn{
        white-space:nowrap;
      }
      .wl-figure-code-card{
        overflow: hidden;
      }
      .wl-figure-code-scroll .rds-code-block-wrap{
        margin-top: 0;
      }
      .wl-figure-code-scroll .rds-code-block{
        height: 320px;
        max-height: 320px;
        overflow: auto;
      }
    ")),
    shiny::tags$script(shiny::HTML("\
      (function(){\
        if (window.__wlFigureCodeCopyHandlerInstalled) return;\
        window.__wlFigureCodeCopyHandlerInstalled = true;\
        Shiny.addCustomMessageHandler('wl_figure_copy_code', async function(msg){\
          var txt = (msg && typeof msg.text === 'string') ? msg.text : '';\
          var status = 'ok';\
          try {\
            if (navigator.clipboard && navigator.clipboard.writeText) {\
              await navigator.clipboard.writeText(txt);\
            } else {\
              var ta = document.createElement('textarea');\
              ta.value = txt;\
              ta.setAttribute('readonly', '');\
              ta.style.position = 'absolute';\
              ta.style.left = '-9999px';\
              document.body.appendChild(ta);\
              ta.select();\
              var copied = document.execCommand('copy');\
              document.body.removeChild(ta);\
              if (copied !== true) { throw new Error('execCommand copy failed'); }\
            }\
          } catch (e) {\
            status = 'error';\
          }\
          if (msg && msg.result_input) {\
            Shiny.setInputValue(msg.result_input, { status: status, nonce: Date.now() }, { priority: 'event' });\
          }\
        });\
      })();\
    "))
  )
)

figure_code_card_ui <- function(id,
                                title,
                                notes = character(0),
                                copy_button_label = "Copy Code",
                                code_label = "Editable R code") {
  ns <- shiny::NS(id)
  shiny::tagList(
    figure_code_card_assets,
    shiny::div(
      class = "wl-side wl-figure-code-card",
      shiny::h4(title),
      if (length(notes)) shiny::tags$ul(class = "control-note-list", lapply(notes, function(x) shiny::tags$li(x))),
      shiny::div(
        class = "wl-figure-code-toolbar",
        shiny::h5(class = "wl-figure-code-label", code_label),
        shiny::actionButton(
          ns("copy_code"),
          label = shiny::tagList(shiny::icon("copy"), copy_button_label),
          class = "btn btn-sm btn-outline-secondary rds-code-copy-btn"
        )
      ),
      shiny::div(class = "wl-figure-code-scroll", shiny::uiOutput(ns("code_block_ui")))
      ,
      shiny::div(
        class = "wl-figure-code-toolbar",
        shiny::actionButton(
          ns("save_recipe_workspace"),
          label = shiny::tagList(shiny::icon("save"), FIGURE_CODE_CARD_TEXT$save_recipe),
          class = "btn btn-sm btn-outline-secondary"
        ),
        shiny::downloadButton(
          ns("download_recipe_json"),
          label = FIGURE_CODE_CARD_TEXT$download_recipe,
          class = "btn btn-sm btn-outline-secondary"
        )
      )
    )
  )
}

.figure_recipe_from_code <- function(code_text) {
  lines <- strsplit(as.character(code_text %||% ""), "\n", fixed = TRUE)[[1]]
  prefix <- "# PIPELINE_RECIPE_JSON: "
  marker <- lines[startsWith(lines, prefix)]
  if (!length(marker)) return(NULL)
  tryCatch(
    jsonlite::fromJSON(substring(marker[[1]], nchar(prefix) + 1L), simplifyVector = FALSE),
    error = function(e) NULL
  )
}

figure_code_card_server <- function(id,
                                    code_text_reactive,
                                    notes_reactive = NULL,
                                    shared_data = NULL,
                                    object_name_reactive = NULL,
                                    studio_name = id,
                                    recipe_reactive = NULL) {
  shiny::moduleServer(id, function(input, output, session) {
    `%||%` <- function(a, b) if (!is.null(a)) a else b
    code_text_rv <- shiny::reactiveVal("")

    observe({
      txt <- as.character(code_text_reactive() %||% "")
      code_text_rv(txt)
      session$onFlushed(function() {
        session$sendCustomMessage("wl_code_block_rehighlight", list(nonce = as.integer(Sys.time())))
      }, once = TRUE)
    })

    output$code_block_ui <- shiny::renderUI({
      shiny::div(
        class = "rds-code-block-wrap",
        shiny::tags$pre(
          class = "rds-code-block",
          shiny::tags$code(class = "rds-r-code", code_text_rv() %||% "")
        ),
        shiny::tags$script(shiny::HTML(
          "(function(){if(window.wlRunCodeBlockHighlight){setTimeout(function(){window.wlRunCodeBlockHighlight(true);},0);}})();"
        ))
      )
    })

    observeEvent(input$copy_code, {
      session$sendCustomMessage("wl_figure_copy_code", list(
        text = as.character(code_text_rv() %||% ""),
        result_input = session$ns("copy_result")
      ))
    }, ignoreInit = TRUE)

    observeEvent(input$copy_result, {
      status <- as.character((input$copy_result %||% list())$status %||% "ok")
      if (identical(status, "ok")) {
        shiny::showNotification("Code copied to clipboard.", type = "message", duration = 2)
      } else {
        shiny::showNotification("Could not copy automatically. Please copy manually from the text box.", type = "warning", duration = 4)
      }
    }, ignoreInit = TRUE)

    current_recipe <- shiny::reactive({
      object_name <- if (is.function(object_name_reactive)) {
        as.character(object_name_reactive() %||% "")[[1]]
      } else {
        ""
      }
      custom <- if (is.function(recipe_reactive)) recipe_reactive() else NULL
      if (is.list(custom) && length(custom)) return(custom)
      embedded <- .figure_recipe_from_code(code_text_rv())
      if (is.list(embedded) && length(embedded)) {
        embedded$schema_version <- 1L
        embedded$studio <- as.character(studio_name %||% id)[[1]]
        embedded$object_name <- object_name
        embedded$r_code <- as.character(code_text_rv() %||% "")
        return(embedded)
      }
      list(
        schema_version = 1L,
        studio = as.character(studio_name %||% id)[[1]],
        object_name = object_name,
        analysis_recipe = list(object_name = object_name),
        figure_recipe = list(r_code = as.character(code_text_rv() %||% ""))
      )
    })

    output$download_recipe_json <- shiny::downloadHandler(
      filename = function() {
        studio_key <- gsub("[^A-Za-z0-9_-]+", "_", as.character(studio_name %||% id)[[1]])
        paste0(studio_key, "_recipe.json")
      },
      content = function(file) {
        jsonlite::write_json(current_recipe(), path = file, auto_unbox = TRUE, pretty = TRUE, null = "null")
      }
    )

    observeEvent(input$save_recipe_workspace, {
      object_name <- as.character(current_recipe()$object_name %||% "")[[1]]
      registry <- tryCatch(shared_data$all_seurat_objects, error = function(e) NULL)
      entry <- if (is.list(registry) && nzchar(object_name)) registry[[object_name]] else NULL
      obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
      if (is.null(obj) || !inherits(obj, "Seurat")) {
        shiny::showNotification(FIGURE_CODE_CARD_TEXT$missing_dataset, type = "warning", duration = 4)
        return(invisible(NULL))
      }

      payload <- current_recipe()
      payload$saved_at <- format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")
      recipe_key <- paste0(
        gsub("[^A-Za-z0-9_-]+", "_", as.character(studio_name %||% id)[[1]]),
        "_",
        format(Sys.time(), "%Y%m%d_%H%M%S")
      )
      misc <- tryCatch(obj@misc, error = function(e) list())
      if (!is.list(misc$pipeline_recipes)) misc$pipeline_recipes <- list()
      misc$pipeline_recipes[[recipe_key]] <- payload
      obj@misc <- misc
      if (is.list(entry) && !is.null(entry$obj)) {
        entry$obj <- obj
        registry[[object_name]] <- entry
      } else {
        registry[[object_name]] <- obj
      }
      shared_data$all_seurat_objects <- registry
      shiny::showNotification(
        sprintf(FIGURE_CODE_CARD_TEXT$saved_recipe, object_name),
        type = "message",
        duration = 3
      )
    }, ignoreInit = TRUE)

    if (is.function(notes_reactive)) {
      output$notes_ui <- shiny::renderUI({
        notes <- notes_reactive()
        if (!length(notes)) return(NULL)
        shiny::tags$ul(class = "control-note-list", lapply(notes, function(x) shiny::tags$li(x)))
      })
    }

    list(code_text = shiny::reactive(code_text_rv() %||% ""))
  })
}

.figure_code_val <- function(x) {
  paste(deparse(x, width.cutoff = 500), collapse = "")
}

figure_recipe_code_lines <- function(analysis_recipe = list(), figure_recipe = list()) {
  recipe_json <- jsonlite::toJSON(
    list(analysis_recipe = analysis_recipe, figure_recipe = figure_recipe),
    auto_unbox = TRUE,
    null = "null"
  )
  c(
    "# Reproducible recipe captured from current pipeline controls",
    paste0("# PIPELINE_RECIPE_JSON: ", recipe_json),
    sprintf("analysis_recipe <- %s", .figure_code_val(analysis_recipe)),
    sprintf("figure_recipe <- %s", .figure_code_val(figure_recipe)),
    ""
  )
}

.figure_code_chr <- function(x, fallback = "") {
  x <- as.character(x %||% fallback)
  x <- x[!is.na(x)]
  if (!length(x)) return(fallback)
  x[[1]]
}

figure_code_default_notes <- function() {
  c(
    "The selected object must already exist in your workspace (or in app shared_data).",
    "This script is a starting template generated from current UI settings and can be edited.",
    "Add layers/theme changes under '# Add extra ggplot layers below'."
  )
}

.figure_code_object_lookup_lines <- function(object_name) {
  obj_name <- .figure_code_chr(object_name, "")
  c(
    "# 2) Optional: import exported workspace bundle (.rds)",
    "bundle <- readRDS('PATH/TO/workspace_bundle.rds')",
    "# If you loaded bundle above, expose object registry as shared_data:",
    "shared_data <- list(all_seurat_objects = bundle$all_seurat_objects)",
    "",
    "# 3) Set target object name",
    sprintf("obj_name <- %s", .figure_code_val(obj_name)),
    "",
    ".coalesce <- function(a, b) if (!is.null(a)) a else b",
    ".get_figure_object <- function(name) {",
    "  if (exists(name, envir = .GlobalEnv, inherits = FALSE)) {",
    "    return(get(name, envir = .GlobalEnv, inherits = FALSE))",
    "  }",
    "  if (exists('shared_data', envir = .GlobalEnv, inherits = FALSE)) {",
    "    sd <- get('shared_data', envir = .GlobalEnv, inherits = FALSE)",
    "    entry <- tryCatch(sd$all_seurat_objects[[name]], error = function(e) NULL)",
    "    if (!is.null(entry)) return(.coalesce(entry$obj, entry))",
    "  }",
    "  stop(sprintf('Object %s not found in .GlobalEnv or shared_data$all_seurat_objects.', name))",
    "}",
    "",
    "sobj <- .get_figure_object(obj_name)",
    "if (!inherits(sobj, 'Seurat')) stop('Resolved object is not a Seurat object.')"
  )
}

figure_generate_umap_script <- function(params) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  pal <- as.character(params$palette_values %||% character(0))
  pal <- pal[!is.na(pal) & nzchar(pal)]
  if (!length(pal)) pal <- NULL

  lines <- c(
    figure_recipe_code_lines(list(object_name = params$object_name), params),
    "# 1) Load packages",
    "library(Seurat)",
    "library(ggplot2)",
    "library(scales)",
    "",
    "# 2) Resolve Seurat object from your workspace (or app shared_data)",
    .figure_code_object_lookup_lines(params$object_name),
    "",
    "# 3) Plot settings from Figure Studio UI",
    sprintf("reduction_name <- %s  # Embedding reduction name (usually 'umap')", .figure_code_val(.figure_code_chr(params$reduction_name, "umap"))),
    sprintf("color_by <- %s  # Metadata column used for cluster/group coloring", .figure_code_val(.figure_code_chr(params$color_by, "seurat_clusters"))),
    sprintf("palette_values <- %s  # Custom palette vector; use NULL for automatic palette", .figure_code_val(pal)),
    sprintf("column_split <- %s  # Optional facet column split metadata", .figure_code_val(params$column_split %||% NULL)),
    sprintf("row_split <- %s  # Optional facet row split metadata", .figure_code_val(params$row_split %||% NULL)),
    sprintf("point_size <- %s  # Point size", .figure_code_val(params$point_size %||% 1)),
    sprintf("point_alpha <- %s  # Point opacity (0-1)", .figure_code_val(params$point_alpha %||% 1)),
    sprintf("point_shape <- %s  # ggplot shape index (0-25)", .figure_code_val(params$point_shape %||% 19L)),
    sprintf("point_stroke <- %s  # Point border width (useful for filled shapes)", .figure_code_val(params$point_stroke %||% 0)),
    sprintf("color_map <- %s  # 'color' (line color) or 'fill' (fillable points)", .figure_code_val(.figure_code_chr(params$color_map, "color"))),
    sprintf("plot_title <- %s  # Plot title", .figure_code_val(.figure_code_chr(params$title, "UMAP Projection"))),
    sprintf("x_label <- %s  # X-axis label", .figure_code_val(.figure_code_chr(params$x_label, "UMAP_1"))),
    sprintf("y_label <- %s  # Y-axis label", .figure_code_val(.figure_code_chr(params$y_label, "UMAP_2"))),
    sprintf("theme_choice <- %s  # Theme preset: Classic / Black & White / Cowplot / UMAP Arrows", .figure_code_val(.figure_code_chr(params$theme_choice, "Classic"))),
    sprintf("legend_position <- %s  # Legend position: right/top/bottom/left/none", .figure_code_val(.figure_code_chr(params$legend_position, "right"))),
    sprintf("legend_columns <- %s  # Used when legend_position is top/bottom", .figure_code_val(params$legend_columns %||% 4L)),
    sprintf("label_clusters <- %s  # TRUE to annotate cluster labels", .figure_code_val(isTRUE(params$label_clusters))),
    sprintf("label_size <- %s  # Cluster label text size", .figure_code_val(params$label_size %||% 4)),
    sprintf("stroke_enabled <- %s  # TRUE to enable cluster stroke outlines", .figure_code_val(isTRUE(params$stroke_enabled))),
    sprintf("stroke_column <- %s  # Metadata column used to choose stroked cluster values", .figure_code_val(params$stroke_column %||% NULL)),
    sprintf("stroke_selected_values <- %s  # One or more cluster/category values to outline", .figure_code_val(as.character(params$stroke_selected_values %||% character(0)))),
    sprintf("stroke_merge <- %s  # TRUE merges selected values into one combined outline", .figure_code_val(isTRUE(params$stroke_merge))),
    sprintf("stroke_padding <- %s  # Extra hull expansion around selected cluster(s)", .figure_code_val(params$stroke_padding %||% 0.08)),
    sprintf("stroke_smoothness <- %s  # Corner smoothing iterations for stroke contour", .figure_code_val(params$stroke_smoothness %||% 2)),
    sprintf("stroke_dash_frequency <- %s  # Larger value = denser dash pattern", .figure_code_val(params$stroke_dash_frequency %||% 5)),
    sprintf("stroke_width <- %s  # Stroke line width", .figure_code_val(params$stroke_width %||% 1.2)),
    sprintf("stroke_color <- %s  # Stroke color", .figure_code_val(.figure_code_chr(params$stroke_color, "#111111"))),
    "",
    "# 4) Build plotting data",
    "emb <- Seurat::Embeddings(sobj, reduction = reduction_name)",
    "df <- data.frame(cell_id = rownames(emb), dim1 = emb[, 1], dim2 = emb[, 2], stringsAsFactors = FALSE)",
    "md <- sobj@meta.data",
    "stopifnot(color_by %in% colnames(md))",
    "df$color_value <- as.character(md[df$cell_id, color_by, drop = TRUE])",
    "df$color_value[is.na(df$color_value) | !nzchar(df$color_value)] <- 'NA'",
    "color_levels <- unique(df$color_value)",
    "df$color_value <- factor(df$color_value, levels = color_levels)",
    "df$split_value <- if (!is.null(column_split) && column_split %in% colnames(md)) as.character(md[df$cell_id, column_split, drop = TRUE]) else 'All cells'",
    "df$split_value[is.na(df$split_value) | !nzchar(df$split_value)] <- 'NA'",
    "df$split_value_secondary <- if (!is.null(row_split) && row_split %in% colnames(md)) as.character(md[df$cell_id, row_split, drop = TRUE]) else 'All cells'",
    "df$split_value_secondary[is.na(df$split_value_secondary) | !nzchar(df$split_value_secondary)] <- 'NA'",
    "if (is.null(palette_values) || !length(palette_values)) palette_values <- scales::hue_pal()(length(color_levels))",
    "if (length(palette_values) < length(color_levels)) palette_values <- grDevices::colorRampPalette(palette_values)(length(color_levels))",
    "palette_values <- palette_values[seq_len(length(color_levels))]",
    "names(palette_values) <- color_levels",
    "legend_position <- tolower(as.character(legend_position))",
    "if (!legend_position %in% c('top', 'bottom', 'right', 'left', 'none')) legend_position <- 'right'",
    "legend_columns <- suppressWarnings(as.integer(legend_columns))",
    "if (!is.finite(legend_columns) || legend_columns < 1) legend_columns <- 4L",
    "legend_columns <- max(1L, min(8L, legend_columns))",
    "legend_is_horizontal <- legend_position %in% c('top', 'bottom')",
    "legend_columns_use <- max(1L, min(legend_columns, length(color_levels)))",
    "legend_rows_use <- max(1L, ceiling(length(color_levels) / legend_columns_use))",
    "",
    "# 5) Base UMAP plot",
    "p <- ggplot2::ggplot(df, ggplot2::aes(x = dim1, y = dim2))",
    "if (identical(color_map, 'fill')) {",
    "  if (!(point_shape %in% 21:25)) point_shape <- 21",
    "  p <- p + ggplot2::geom_point(ggplot2::aes(fill = color_value), shape = point_shape, size = point_size, alpha = point_alpha, stroke = point_stroke, color = '#1F1F1F') + ggplot2::scale_fill_manual(values = palette_values, drop = FALSE)",
    "} else {",
    "  p <- p + ggplot2::geom_point(ggplot2::aes(color = color_value), shape = point_shape, size = point_size, alpha = point_alpha, stroke = point_stroke) + ggplot2::scale_color_manual(values = palette_values, drop = FALSE)",
    "}",
    "",
    "if (isTRUE(label_clusters) && is.finite(label_size) && label_size > 0) {",
    "  med <- stats::aggregate(cbind(dim1, dim2) ~ color_value + split_value + split_value_secondary, data = df, FUN = median)",
    "  p <- p + ggplot2::geom_text(data = med, ggplot2::aes(x = dim1, y = dim2, label = color_value), inherit.aes = FALSE, size = label_size, fontface = 'bold')",
    "}",
    "",
    "# 6) Optional cluster stroke overlay",
    ".smooth_ring <- function(path_df, smooth_it = 0) {",
    "  if (!is.data.frame(path_df) || nrow(path_df) < 4 || smooth_it <= 0) return(path_df)",
    "  pts <- as.matrix(path_df[, c('dim1', 'dim2'), drop = FALSE])",
    "  pts <- pts[seq_len(nrow(pts) - 1), , drop = FALSE]",
    "  if (nrow(pts) < 3) return(path_df)",
    "  for (iter in seq_len(smooth_it)) {",
    "    n <- nrow(pts)",
    "    nxt <- rbind(pts[-1, , drop = FALSE], pts[1, , drop = FALSE])",
    "    q <- 0.75 * pts + 0.25 * nxt",
    "    r <- 0.25 * pts + 0.75 * nxt",
    "    out <- matrix(NA_real_, nrow = n * 2, ncol = 2)",
    "    out[seq(1, n * 2, by = 2), ] <- q",
    "    out[seq(2, n * 2, by = 2), ] <- r",
    "    pts <- out",
    "  }",
    "  smooth <- data.frame(dim1 = pts[, 1], dim2 = pts[, 2], stringsAsFactors = FALSE)",
    "  rbind(smooth, smooth[1, , drop = FALSE])",
    "}",
    ".build_hull <- function(sub_df, pad = 0, smooth_it = 0) {",
    "  xy <- unique(sub_df[, c('dim1', 'dim2'), drop = FALSE])",
    "  if (nrow(xy) < 3) return(NULL)",
    "  idx <- grDevices::chull(xy$dim1, xy$dim2)",
    "  if (length(idx) < 3) return(NULL)",
    "  hull <- xy[idx, , drop = FALSE]",
    "  cx <- mean(hull$dim1); cy <- mean(hull$dim2)",
    "  hull$dim1 <- cx + (hull$dim1 - cx) * (1 + max(0, pad))",
    "  hull$dim2 <- cy + (hull$dim2 - cy) * (1 + max(0, pad))",
    "  hull <- rbind(hull, hull[1, , drop = FALSE])",
    "  .smooth_ring(hull, smooth_it = smooth_it)",
    "}",
    ".build_stroke_segments <- function(path_df, dash_frequency = 5) {",
    "  if (!nrow(path_df)) return(path_df[0, c('x', 'y', 'xend', 'yend', 'stroke_group'), drop = FALSE])",
    "  freq <- suppressWarnings(as.numeric(dash_frequency))",
    "  if (!is.finite(freq) || freq < 1) freq <- 5",
    "  freq <- max(1, min(9, round(freq)))",
    "  .interp <- function(chunk, t) {",
    "    idx <- findInterval(t, chunk$cumlen, rightmost.closed = TRUE, all.inside = TRUE)",
    "    idx <- max(1, min(idx, nrow(chunk) - 1))",
    "    seg0 <- chunk$cumlen[idx]; seg1 <- chunk$cumlen[idx + 1]",
    "    if (!is.finite(seg1) || seg1 <= seg0) return(c(chunk$dim1[idx], chunk$dim2[idx]))",
    "    r <- (t - seg0) / (seg1 - seg0); r <- max(0, min(1, r))",
    "    c(chunk$dim1[idx] + (chunk$dim1[idx + 1] - chunk$dim1[idx]) * r, chunk$dim2[idx] + (chunk$dim2[idx + 1] - chunk$dim2[idx]) * r)",
    "  }",
    "  out <- lapply(split(path_df, path_df$stroke_group), function(chunk) {",
    "    if (nrow(chunk) < 2) return(NULL)",
    "    dx <- diff(as.numeric(chunk$dim1)); dy <- diff(as.numeric(chunk$dim2))",
    "    seg_len <- sqrt(dx^2 + dy^2); seg_len[!is.finite(seg_len)] <- 0",
    "    total_len <- sum(seg_len)",
    "    if (!is.finite(total_len) || total_len <= 0) return(NULL)",
    "    chunk$cumlen <- c(0, cumsum(seg_len))",
    "    dash_count <- as.integer(max(4, round(6 + freq * 4)))",
    "    dash_len <- total_len / (dash_count * 2)",
    "    if (!is.finite(dash_len) || dash_len <= 0) return(NULL)",
    "    rows <- vector('list', dash_count); row_idx <- 0L",
    "    for (k in seq_len(dash_count)) {",
    "      t0 <- (k - 1) * 2 * dash_len; t1 <- min(t0 + dash_len, total_len)",
    "      if (t0 >= total_len) break",
    "      p0 <- .interp(chunk, t0); p1 <- .interp(chunk, t1)",
    "      row_idx <- row_idx + 1L",
    "      rows[[row_idx]] <- data.frame(x = p0[[1]], y = p0[[2]], xend = p1[[1]], yend = p1[[2]], stroke_group = chunk$stroke_group[[1]], stringsAsFactors = FALSE)",
    "    }",
    "    rows <- rows[seq_len(row_idx)]",
    "    if (!length(rows)) return(NULL)",
    "    do.call(rbind, rows)",
    "  })",
    "  out <- out[!vapply(out, is.null, logical(1))]",
    "  if (!length(out)) return(path_df[0, c('x', 'y', 'xend', 'yend', 'stroke_group'), drop = FALSE])",
    "  do.call(rbind, out)",
    "}",
    "if (isTRUE(stroke_enabled) && !is.null(stroke_column) && stroke_column %in% colnames(md) && length(stroke_selected_values)) {",
    "  df$stroke_value <- as.character(md[df$cell_id, stroke_column, drop = TRUE])",
    "  df$stroke_value[is.na(df$stroke_value) | !nzchar(df$stroke_value)] <- 'NA'",
    "  sub <- df[df$stroke_value %in% stroke_selected_values, , drop = FALSE]",
    "  if (nrow(sub)) {",
    "    key <- if (isTRUE(stroke_merge)) rep('merged', nrow(sub)) else sub$stroke_value",
    "    sub$stroke_group <- paste(sub$split_value, sub$split_value_secondary, key, sep = '||')",
    "    hulls <- lapply(split(sub, sub$stroke_group), function(x) .build_hull(x, pad = stroke_padding, smooth_it = stroke_smoothness))",
    "    hulls <- hulls[!vapply(hulls, is.null, logical(1))]",
    "    if (length(hulls)) {",
    "      hull_df <- do.call(rbind, Map(function(h, g) cbind(h, stroke_group = g), hulls, names(hulls)))",
    "      seg_df <- .build_stroke_segments(hull_df, dash_frequency = stroke_dash_frequency)",
    "      if (nrow(seg_df)) {",
    "        p <- p + ggplot2::geom_segment(data = seg_df, ggplot2::aes(x = x, y = y, xend = xend, yend = yend, group = stroke_group), inherit.aes = FALSE, color = stroke_color, linewidth = stroke_width, lineend = 'round')",
    "      }",
    "    }",
    "  }",
    "}",
    "",
    "# 7) Faceting + theme",
    "if (!is.null(column_split) && !is.null(row_split) && column_split %in% colnames(md) && row_split %in% colnames(md) && !identical(column_split, row_split)) {",
    "  p <- p + ggplot2::facet_grid(rows = ggplot2::vars(split_value_secondary), cols = ggplot2::vars(split_value), drop = FALSE)",
    "} else if (!is.null(column_split) && column_split %in% colnames(md)) {",
    "  p <- p + ggplot2::facet_wrap(ggplot2::vars(split_value), nrow = 1, drop = FALSE)",
    "} else if (!is.null(row_split) && row_split %in% colnames(md)) {",
    "  p <- p + ggplot2::facet_wrap(ggplot2::vars(split_value_secondary), ncol = 1, drop = FALSE)",
    "}",
    "",
    "base_theme <- switch(theme_choice,",
    "  'Classic' = ggplot2::theme_classic(base_size = 12),",
    "  'Black & White' = ggplot2::theme_bw(base_size = 12),",
    "  'Cowplot' = ggplot2::theme_minimal(base_size = 12),",
    "  'UMAP Arrows' = ggplot2::theme_minimal(base_size = 12),",
    "  ggplot2::theme_minimal(base_size = 12)",
    ")",
    "p <- p + ggplot2::coord_fixed() + base_theme + ggplot2::labs(title = plot_title, x = x_label, y = y_label)",
    "if (isTRUE(legend_is_horizontal)) {",
    "  p <- p + ggplot2::guides(",
    "    colour = ggplot2::guide_legend(ncol = legend_columns_use, nrow = legend_rows_use, byrow = TRUE),",
    "    color  = ggplot2::guide_legend(ncol = legend_columns_use, nrow = legend_rows_use, byrow = TRUE),",
    "    fill   = ggplot2::guide_legend(ncol = legend_columns_use, nrow = legend_rows_use, byrow = TRUE)",
    "  )",
    "}",
    "p <- p + ggplot2::theme(",
    "  legend.position = legend_position,",
    "  legend.direction = if (isTRUE(legend_is_horizontal)) 'horizontal' else 'vertical',",
    "  legend.box = if (isTRUE(legend_is_horizontal)) 'horizontal' else 'vertical'",
    ")",
    "",
    "# 8) Add extra ggplot layers below",
    "# p <- p + ggplot2::theme(legend.position = 'bottom')",
    "",
    "print(p)"
  )
  paste(lines, collapse = "\n")
}

figure_generate_feature_script <- function(params) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  lines <- c(
    "# 1) Load packages",
    "library(Seurat)",
    "library(ggplot2)",
    "library(scales)",
    "",
    "# 2) Resolve Seurat object from your workspace (or app shared_data)",
    .figure_code_object_lookup_lines(params$object_name),
    "",
    "# 3) Plot settings from Figure Studio UI",
    sprintf("reduction_name <- %s  # Embedding reduction", .figure_code_val(.figure_code_chr(params$reduction_name, "umap"))),
    sprintf("assay_name <- %s  # Assay used for expression values", .figure_code_val(.figure_code_chr(params$assay_name, "RNA"))),
    sprintf("feature_name <- %s  # Feature/gene to visualize", .figure_code_val(.figure_code_chr(params$feature_name, ""))),
    sprintf("low_color <- %s  # Gradient color for low expression", .figure_code_val(.figure_code_chr(params$low_color, "#D3D3D3"))),
    sprintf("high_color <- %s  # Gradient color for high expression", .figure_code_val(.figure_code_chr(params$high_color, "#FF0000"))),
    sprintf("column_split <- %s  # Optional facet column split", .figure_code_val(params$column_split %||% NULL)),
    sprintf("row_split <- %s  # Optional facet row split", .figure_code_val(params$row_split %||% NULL)),
    sprintf("point_size <- %s  # Point size", .figure_code_val(params$point_size %||% 1)),
    sprintf("point_alpha <- %s  # Point opacity (0-1)", .figure_code_val(params$point_alpha %||% 1)),
    sprintf("point_shape <- %s  # ggplot shape index (0-25)", .figure_code_val(params$point_shape %||% 19L)),
    sprintf("point_stroke <- %s  # Point border width", .figure_code_val(params$point_stroke %||% 0)),
    sprintf("stroke_enabled <- %s  # TRUE to enable cluster stroke outlines", .figure_code_val(isTRUE(params$stroke_enabled))),
    sprintf("stroke_column <- %s  # Metadata column used for stroke selection", .figure_code_val(params$stroke_column %||% NULL)),
    sprintf("stroke_selected_values <- %s  # Values to outline", .figure_code_val(as.character(params$stroke_selected_values %||% character(0)))),
    sprintf("stroke_merge <- %s  # TRUE merges selected values into one outline", .figure_code_val(isTRUE(params$stroke_merge))),
    sprintf("stroke_padding <- %s  # Hull expansion around stroked groups", .figure_code_val(params$stroke_padding %||% 0.08)),
    sprintf("stroke_smoothness <- %s  # Corner smoothing iterations for stroke contour", .figure_code_val(params$stroke_smoothness %||% 2)),
    sprintf("stroke_dash_frequency <- %s  # Larger value = denser dash pattern", .figure_code_val(params$stroke_dash_frequency %||% 5)),
    sprintf("stroke_width <- %s  # Stroke line width", .figure_code_val(params$stroke_width %||% 1.2)),
    sprintf("stroke_color <- %s  # Stroke color", .figure_code_val(.figure_code_chr(params$stroke_color, "#111111"))),
    sprintf("plot_title <- %s  # Plot title", .figure_code_val(.figure_code_chr(params$title, "Feature Plot"))),
    sprintf("x_label <- %s  # X-axis label", .figure_code_val(.figure_code_chr(params$x_label, "UMAP_1"))),
    sprintf("y_label <- %s  # Y-axis label", .figure_code_val(.figure_code_chr(params$y_label, "UMAP_2"))),
    sprintf("theme_choice <- %s  # Theme preset", .figure_code_val(.figure_code_chr(params$theme_choice, "Classic"))),
    "",
    "# 4) Build plotting data",
    "emb <- Seurat::Embeddings(sobj, reduction = reduction_name)",
    "df <- data.frame(cell_id = rownames(emb), dim1 = emb[, 1], dim2 = emb[, 2], stringsAsFactors = FALSE)",
    "expr <- Seurat::FetchData(sobj, vars = feature_name, slot = 'data')",
    "df$feature_value <- as.numeric(expr[df$cell_id, feature_name, drop = TRUE])",
    "md <- sobj@meta.data",
    "df$split_value <- if (!is.null(column_split) && column_split %in% colnames(md)) as.character(md[df$cell_id, column_split, drop = TRUE]) else 'All cells'",
    "df$split_value[is.na(df$split_value) | !nzchar(df$split_value)] <- 'NA'",
    "df$split_value_secondary <- if (!is.null(row_split) && row_split %in% colnames(md)) as.character(md[df$cell_id, row_split, drop = TRUE]) else 'All cells'",
    "df$split_value_secondary[is.na(df$split_value_secondary) | !nzchar(df$split_value_secondary)] <- 'NA'",
    "",
    "# 5) Base feature plot",
    "p <- ggplot2::ggplot(df, ggplot2::aes(x = dim1, y = dim2)) +",
    "  ggplot2::geom_point(ggplot2::aes(color = feature_value), shape = point_shape, size = point_size, alpha = point_alpha, stroke = point_stroke) +",
    "  ggplot2::scale_color_gradient(low = low_color, high = high_color, na.value = '#8A8A8A', name = feature_name)",
    "",
    "# 6) Optional cluster stroke overlay",
    ".smooth_ring <- function(path_df, smooth_it = 0) {",
    "  if (!is.data.frame(path_df) || nrow(path_df) < 4 || smooth_it <= 0) return(path_df)",
    "  pts <- as.matrix(path_df[, c('dim1', 'dim2'), drop = FALSE])",
    "  pts <- pts[seq_len(nrow(pts) - 1), , drop = FALSE]",
    "  if (nrow(pts) < 3) return(path_df)",
    "  for (iter in seq_len(smooth_it)) {",
    "    n <- nrow(pts)",
    "    nxt <- rbind(pts[-1, , drop = FALSE], pts[1, , drop = FALSE])",
    "    q <- 0.75 * pts + 0.25 * nxt",
    "    r <- 0.25 * pts + 0.75 * nxt",
    "    out <- matrix(NA_real_, nrow = n * 2, ncol = 2)",
    "    out[seq(1, n * 2, by = 2), ] <- q",
    "    out[seq(2, n * 2, by = 2), ] <- r",
    "    pts <- out",
    "  }",
    "  smooth <- data.frame(dim1 = pts[, 1], dim2 = pts[, 2], stringsAsFactors = FALSE)",
    "  rbind(smooth, smooth[1, , drop = FALSE])",
    "}",
    ".build_hull <- function(sub_df, pad = 0, smooth_it = 0) {",
    "  xy <- unique(sub_df[, c('dim1', 'dim2'), drop = FALSE])",
    "  if (nrow(xy) < 3) return(NULL)",
    "  idx <- grDevices::chull(xy$dim1, xy$dim2)",
    "  if (length(idx) < 3) return(NULL)",
    "  hull <- xy[idx, , drop = FALSE]",
    "  cx <- mean(hull$dim1); cy <- mean(hull$dim2)",
    "  hull$dim1 <- cx + (hull$dim1 - cx) * (1 + max(0, pad))",
    "  hull$dim2 <- cy + (hull$dim2 - cy) * (1 + max(0, pad))",
    "  hull <- rbind(hull, hull[1, , drop = FALSE])",
    "  .smooth_ring(hull, smooth_it = smooth_it)",
    "}",
    ".build_stroke_segments <- function(path_df, dash_frequency = 5) {",
    "  if (!nrow(path_df)) return(path_df[0, c('x', 'y', 'xend', 'yend', 'stroke_group'), drop = FALSE])",
    "  freq <- suppressWarnings(as.numeric(dash_frequency))",
    "  if (!is.finite(freq) || freq < 1) freq <- 5",
    "  freq <- max(1, min(9, round(freq)))",
    "  .interp <- function(chunk, t) {",
    "    idx <- findInterval(t, chunk$cumlen, rightmost.closed = TRUE, all.inside = TRUE)",
    "    idx <- max(1, min(idx, nrow(chunk) - 1))",
    "    seg0 <- chunk$cumlen[idx]; seg1 <- chunk$cumlen[idx + 1]",
    "    if (!is.finite(seg1) || seg1 <= seg0) return(c(chunk$dim1[idx], chunk$dim2[idx]))",
    "    r <- (t - seg0) / (seg1 - seg0); r <- max(0, min(1, r))",
    "    c(chunk$dim1[idx] + (chunk$dim1[idx + 1] - chunk$dim1[idx]) * r, chunk$dim2[idx] + (chunk$dim2[idx + 1] - chunk$dim2[idx]) * r)",
    "  }",
    "  out <- lapply(split(path_df, path_df$stroke_group), function(chunk) {",
    "    if (nrow(chunk) < 2) return(NULL)",
    "    dx <- diff(as.numeric(chunk$dim1)); dy <- diff(as.numeric(chunk$dim2))",
    "    seg_len <- sqrt(dx^2 + dy^2); seg_len[!is.finite(seg_len)] <- 0",
    "    total_len <- sum(seg_len)",
    "    if (!is.finite(total_len) || total_len <= 0) return(NULL)",
    "    chunk$cumlen <- c(0, cumsum(seg_len))",
    "    dash_count <- as.integer(max(4, round(6 + freq * 4)))",
    "    dash_len <- total_len / (dash_count * 2)",
    "    if (!is.finite(dash_len) || dash_len <= 0) return(NULL)",
    "    rows <- vector('list', dash_count); row_idx <- 0L",
    "    for (k in seq_len(dash_count)) {",
    "      t0 <- (k - 1) * 2 * dash_len; t1 <- min(t0 + dash_len, total_len)",
    "      if (t0 >= total_len) break",
    "      p0 <- .interp(chunk, t0); p1 <- .interp(chunk, t1)",
    "      row_idx <- row_idx + 1L",
    "      rows[[row_idx]] <- data.frame(x = p0[[1]], y = p0[[2]], xend = p1[[1]], yend = p1[[2]], stroke_group = chunk$stroke_group[[1]], stringsAsFactors = FALSE)",
    "    }",
    "    rows <- rows[seq_len(row_idx)]",
    "    if (!length(rows)) return(NULL)",
    "    do.call(rbind, rows)",
    "  })",
    "  out <- out[!vapply(out, is.null, logical(1))]",
    "  if (!length(out)) return(path_df[0, c('x', 'y', 'xend', 'yend', 'stroke_group'), drop = FALSE])",
    "  do.call(rbind, out)",
    "}",
    "if (isTRUE(stroke_enabled) && !is.null(stroke_column) && stroke_column %in% colnames(md) && length(stroke_selected_values)) {",
    "  df$stroke_value <- as.character(md[df$cell_id, stroke_column, drop = TRUE])",
    "  df$stroke_value[is.na(df$stroke_value) | !nzchar(df$stroke_value)] <- 'NA'",
    "  sub <- df[df$stroke_value %in% stroke_selected_values, , drop = FALSE]",
    "  if (nrow(sub)) {",
    "    key <- if (isTRUE(stroke_merge)) rep('merged', nrow(sub)) else sub$stroke_value",
    "    sub$stroke_group <- paste(sub$split_value, sub$split_value_secondary, key, sep = '||')",
    "    hulls <- lapply(split(sub, sub$stroke_group), function(x) .build_hull(x, pad = stroke_padding, smooth_it = stroke_smoothness))",
    "    hulls <- hulls[!vapply(hulls, is.null, logical(1))]",
    "    if (length(hulls)) {",
    "      hull_df <- do.call(rbind, Map(function(h, g) cbind(h, stroke_group = g), hulls, names(hulls)))",
    "      seg_df <- .build_stroke_segments(hull_df, dash_frequency = stroke_dash_frequency)",
    "      if (nrow(seg_df)) {",
    "        p <- p + ggplot2::geom_segment(data = seg_df, ggplot2::aes(x = x, y = y, xend = xend, yend = yend, group = stroke_group), inherit.aes = FALSE, color = stroke_color, linewidth = stroke_width, lineend = 'round')",
    "      }",
    "    }",
    "  }",
    "}",
    "",
    "# 7) Faceting + theme",
    "if (!is.null(column_split) && !is.null(row_split) && column_split %in% colnames(md) && row_split %in% colnames(md) && !identical(column_split, row_split)) {",
    "  p <- p + ggplot2::facet_grid(rows = ggplot2::vars(split_value_secondary), cols = ggplot2::vars(split_value), drop = FALSE)",
    "} else if (!is.null(column_split) && column_split %in% colnames(md)) {",
    "  p <- p + ggplot2::facet_wrap(ggplot2::vars(split_value), nrow = 1, drop = FALSE)",
    "} else if (!is.null(row_split) && row_split %in% colnames(md)) {",
    "  p <- p + ggplot2::facet_wrap(ggplot2::vars(split_value_secondary), ncol = 1, drop = FALSE)",
    "}",
    "",
    "base_theme <- switch(theme_choice,",
    "  'Classic' = ggplot2::theme_classic(base_size = 12),",
    "  'Black & White' = ggplot2::theme_bw(base_size = 12),",
    "  'Cowplot' = ggplot2::theme_minimal(base_size = 12),",
    "  'UMAP Arrows' = ggplot2::theme_minimal(base_size = 12),",
    "  ggplot2::theme_minimal(base_size = 12)",
    ")",
    "p <- p + ggplot2::coord_fixed() + base_theme + ggplot2::labs(title = plot_title, x = x_label, y = y_label)",
    "",
    "# 8) Add extra ggplot layers below",
    "# p <- p + ggplot2::scale_color_viridis_c(option = 'magma')",
    "",
    "print(p)"
  )
  paste(lines, collapse = "\n")
}

figure_generate_dotplot_script <- function(params) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  genes <- as.character(params$genes %||% character(0))
  gene_group_spec <- .figure_code_chr(params$gene_group_spec, "")
  ident_group_spec <- .figure_code_chr(params$ident_group_spec, "")
  lines <- c(
    figure_recipe_code_lines(list(object_name = params$object_name), params),
    "# 1) Load packages",
    "library(Seurat)",
    "library(ggplot2)",
    "",
    "# 2) Resolve Seurat object from your workspace (or app shared_data)",
    .figure_code_object_lookup_lines(params$object_name),
    "",
    "# 3) Plot settings from Figure Studio UI",
    sprintf("genes_to_plot <- %s  # Gene symbols to show", .figure_code_val(genes)),
    sprintf("low_color <- %s  # Low expression color", .figure_code_val(.figure_code_chr(params$low_color, "#D3D3D3"))),
    sprintf("high_color <- %s  # High expression color", .figure_code_val(.figure_code_chr(params$high_color, "#0000FF"))),
    sprintf("axis_text_angle <- %s  # X-axis text angle", .figure_code_val(params$axis_text_angle %||% 45)),
    sprintf("axis_text_size <- %s  # Axis text size", .figure_code_val(params$axis_text_size %||% 10)),
    sprintf("orientation <- %s  # 'Vertical' or 'Horizontal'", .figure_code_val(.figure_code_chr(params$orientation, "Vertical"))),
    sprintf("dot_size_max <- %s  # Maximum dot size scale", .figure_code_val(params$dot_size_max %||% 6)),
    sprintf("gene_group_spec <- %s  # Optional gene-group definitions", .figure_code_val(gene_group_spec)),
    sprintf("ident_group_spec <- %s  # Optional identity-group definitions", .figure_code_val(ident_group_spec)),
    sprintf("show_group_dashes <- %s  # TRUE to draw dashed separator lines", .figure_code_val(isTRUE(params$show_group_dashes))),
    sprintf("show_group_labels <- %s  # TRUE to draw group labels", .figure_code_val(isTRUE(params$show_group_labels))),
    "",
    "# 4) Build dot plot",
    ".split_group_items <- function(x) {",
    "  x <- as.character(x %||% '')",
    "  if (!nzchar(x)) return(character(0))",
    "  out <- unlist(strsplit(x, '[,;|]', perl = TRUE), use.names = FALSE)",
    "  out <- trimws(out)",
    "  unique(out[nzchar(out)])",
    "}",
    ".parse_grouping_spec <- function(spec_text) {",
    "  lines <- trimws(unlist(strsplit(as.character(spec_text %||% ''), '\\n', fixed = TRUE), use.names = FALSE))",
    "  lines <- lines[nzchar(lines)]",
    "  if (!length(lines)) return(list(names = character(0), items = list()))",
    "  out_names <- character(0)",
    "  out_items <- list()",
    "  current_name <- NULL",
    "  for (ln in lines) {",
    "    if (grepl('^\\\\[.+\\\\]$', ln)) {",
    "      current_name <- trimws(sub('^\\\\[(.+)\\\\]$', '\\\\1', ln))",
    "      if (!nzchar(current_name)) current_name <- NULL",
    "      if (!is.null(current_name) && !(current_name %in% out_names)) {",
    "        out_names <- c(out_names, current_name)",
    "        out_items[[current_name]] <- character(0)",
    "      }",
    "      next",
    "    }",
    "    if (grepl(':', ln, fixed = TRUE)) {",
    "      pair <- strsplit(ln, ':', fixed = TRUE)[[1]]",
    "      group_name <- trimws(pair[[1]])",
    "      if (nzchar(group_name)) {",
    "        current_name <- group_name",
    "        if (!(current_name %in% out_names)) {",
    "          out_names <- c(out_names, current_name)",
    "          out_items[[current_name]] <- character(0)",
    "        }",
    "        rhs <- trimws(paste(pair[-1], collapse = ':'))",
    "        if (nzchar(rhs)) out_items[[current_name]] <- unique(c(out_items[[current_name]], .split_group_items(rhs)))",
    "        next",
    "      }",
    "    }",
    "    if (is.null(current_name)) {",
    "      current_name <- paste0('Group ', length(out_names) + 1L)",
    "      out_names <- c(out_names, current_name)",
    "      out_items[[current_name]] <- character(0)",
    "    }",
    "    out_items[[current_name]] <- unique(c(out_items[[current_name]], .split_group_items(ln)))",
    "  }",
    "  list(names = out_names, items = out_items)",
    "}",
    ".ordered_levels <- function(x) {",
    "  if (is.factor(x)) return(as.character(levels(x)))",
    "  vals <- unique(as.character(x %||% character(0)))",
    "  vals[!is.na(vals) & nzchar(vals)]",
    "}",
    ".build_group_overlay <- function(levels_vec, spec_text) {",
    "  levels_vec <- as.character(levels_vec %||% character(0))",
    "  levels_vec <- levels_vec[nzchar(levels_vec)]",
    "  if (!length(levels_vec)) return(list(boundaries = numeric(0), centers = numeric(0), labels = character(0)))",
    "  spec <- .parse_grouping_spec(spec_text)",
    "  if (!length(spec$names)) return(list(boundaries = numeric(0), centers = numeric(0), labels = character(0)))",
    "  available_idx <- seq_along(levels_vec)",
    "  starts <- integer(0)",
    "  ends <- integer(0)",
    "  labels <- character(0)",
    "  for (nm in spec$names) {",
    "    members <- as.character(spec$items[[nm]] %||% character(0))",
    "    members <- members[nzchar(members)]",
    "    if (!length(members)) next",
    "    idx <- match(members, levels_vec)",
    "    idx <- sort(unique(stats::na.omit(idx)))",
    "    idx <- idx[idx %in% available_idx]",
    "    if (!length(idx)) next",
    "    starts <- c(starts, min(idx))",
    "    ends <- c(ends, max(idx))",
    "    labels <- c(labels, nm)",
    "    available_idx <- setdiff(available_idx, idx)",
    "  }",
    "  if (!length(labels)) return(list(boundaries = numeric(0), centers = numeric(0), labels = character(0)))",
    "  ord <- order(starts, ends)",
    "  starts <- starts[ord]; ends <- ends[ord]; labels <- labels[ord]",
    "  centers <- (starts + ends) / 2",
    "  boundaries <- numeric(0)",
    "  if (length(starts) >= 2) {",
    "    for (i in seq_len(length(starts) - 1L)) boundaries <- c(boundaries, (ends[[i]] + starts[[i + 1L]]) / 2)",
    "  }",
    "  list(boundaries = boundaries, centers = centers, labels = labels)",
    "}",
    "",
    "if (!length(genes_to_plot)) stop('No genes selected. Add genes before running this script.')",
    "genes_to_plot <- intersect(genes_to_plot, rownames(sobj))",
    "if (!length(genes_to_plot)) stop('Selected genes were not found in object rownames(sobj).')",
    "p <- Seurat::DotPlot(sobj, features = genes_to_plot)",
    "p <- p + ggplot2::scale_color_gradient(low = low_color, high = high_color)",
    "p <- p + ggplot2::theme(axis.text.x = ggplot2::element_text(angle = axis_text_angle, hjust = 1, size = axis_text_size), axis.text.y = ggplot2::element_text(size = axis_text_size))",
    "x_levels <- .ordered_levels(p$data$id)",
    "y_levels <- .ordered_levels(p$data$features.plot)",
    "ident_groups <- .build_group_overlay(x_levels, ident_group_spec)",
    "gene_groups <- .build_group_overlay(y_levels, gene_group_spec)",
    "if (isTRUE(show_group_dashes) && length(ident_groups$boundaries)) {",
    "  p <- p + ggplot2::geom_vline(xintercept = ident_groups$boundaries, linetype = 'dashed', linewidth = 0.45, color = '#3A3A3A', alpha = 0.9)",
    "}",
    "if (isTRUE(show_group_dashes) && length(gene_groups$boundaries)) {",
    "  p <- p + ggplot2::geom_hline(yintercept = gene_groups$boundaries, linetype = 'dashed', linewidth = 0.45, color = '#3A3A3A', alpha = 0.9)",
    "}",
    "if (isTRUE(show_group_labels) && (length(ident_groups$labels) || length(gene_groups$labels))) {",
    "  n_id <- length(x_levels)",
    "  n_gene <- length(y_levels)",
    "  label_size <- max(3, min(6, suppressWarnings(as.numeric(axis_text_size)) / 3))",
    "  if (!is.finite(label_size)) label_size <- 3.5",
    "  if (identical(orientation, 'Vertical')) {",
    "    if (length(ident_groups$labels)) {",
    "      ident_df <- data.frame(x = ident_groups$centers, y = 0.35, label = ident_groups$labels, stringsAsFactors = FALSE)",
    "      p <- p + ggplot2::geom_text(data = ident_df, ggplot2::aes(x = x, y = y, label = label), inherit.aes = FALSE, hjust = 1, size = label_size, fontface = 'bold', color = '#222222')",
    "    }",
    "    if (length(gene_groups$labels)) {",
    "      gene_df <- data.frame(x = n_id + 0.8, y = gene_groups$centers, label = gene_groups$labels, stringsAsFactors = FALSE)",
    "      p <- p + ggplot2::geom_text(data = gene_df, ggplot2::aes(x = x, y = y, label = label), inherit.aes = FALSE, hjust = 0, angle = 35, size = label_size, fontface = 'bold', color = '#222222')",
    "    }",
    "  } else {",
    "    if (length(ident_groups$labels)) {",
    "      ident_df <- data.frame(x = ident_groups$centers, y = n_gene + 0.8, label = ident_groups$labels, stringsAsFactors = FALSE)",
    "      p <- p + ggplot2::geom_text(data = ident_df, ggplot2::aes(x = x, y = y, label = label), inherit.aes = FALSE, hjust = 0, angle = 35, size = label_size, fontface = 'bold', color = '#222222')",
    "    }",
    "    if (length(gene_groups$labels)) {",
    "      gene_df <- data.frame(x = 0.35, y = gene_groups$centers, label = gene_groups$labels, stringsAsFactors = FALSE)",
    "      p <- p + ggplot2::geom_text(data = gene_df, ggplot2::aes(x = x, y = y, label = label), inherit.aes = FALSE, hjust = 1, size = label_size, fontface = 'bold', color = '#222222')",
    "    }",
    "  }",
    "}",
    "if (identical(orientation, 'Vertical')) {",
    "  p <- p + ggplot2::coord_flip(clip = 'off')",
    "} else {",
    "  p <- p + ggplot2::coord_cartesian(clip = 'off')",
    "}",
    "p <- p + ggplot2::theme(plot.margin = ggplot2::margin(18, 20, 18, 90))",
    "if (is.finite(max(p$data$pct.exp, na.rm = TRUE)) && max(p$data$pct.exp, na.rm = TRUE) > 0) {",
    "  p$data$pct.exp.scaled <- p$data$pct.exp * (dot_size_max / max(p$data$pct.exp, na.rm = TRUE))",
    "}",
    "if (!is.null(p$guides$size)) p$guides$size$range <- c(0, dot_size_max)",
    "",
    "# 6) Add extra ggplot layers below",
    "# p <- p + ggplot2::labs(title = 'Custom Dot Plot Title')",
    "",
    "print(p)"
  )
  paste(lines, collapse = "\n")
}

figure_generate_alluvial_script <- function(params) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  split_col <- params$condition_col %||% NULL
  lines <- c(
    figure_recipe_code_lines(list(object_name = params$object_name), params),
    "# 1) Load packages",
    "library(Seurat)",
    "library(ggplot2)",
    "library(dplyr)",
    "library(ggalluvial)",
    "",
    "# 2) Resolve Seurat object from your workspace (or app shared_data)",
    .figure_code_object_lookup_lines(params$object_name),
    "",
    "# 3) Plot settings from Figure Studio UI",
    sprintf("cluster_col <- %s  # Cluster metadata column", .figure_code_val(.figure_code_chr(params$cluster_col, "seurat_clusters"))),
    sprintf("condition_col <- %s  # Optional condition split metadata (NULL for single panel)", .figure_code_val(split_col)),
    sprintf("chain <- %s  # 'tcr' or 'bcr' clonotype source", .figure_code_val(.figure_code_chr(params$chain, "tcr"))),
    sprintf("top_n <- %s  # Keep top N clonotypes per condition by total cells", .figure_code_val(params$top_n %||% 25)),
    sprintf("min_cells <- %s  # Minimum cells required for each flow segment", .figure_code_val(params$min_cells %||% 1)),
    sprintf("ribbon_alpha <- %s  # Ribbon transparency", .figure_code_val(params$alpha %||% 0.45)),
    sprintf("ribbon_width <- %s  # Ribbon width", .figure_code_val(params$ribbon_width %||% 0.08)),
    sprintf("cluster_palette <- %s  # Optional manual fill palette", .figure_code_val(params$cluster_palette %||% NULL)),
    "",
    "# 4) Build alluvial data and plot",
    "clone_col <- if (tolower(chain) == 'bcr') 'vdj_bcr_clone' else 'vdj_tcr_clone'",
    "md <- sobj@meta.data",
    "if (!(cluster_col %in% colnames(md))) stop('cluster_col not found in metadata.')",
    "if (!(clone_col %in% colnames(md))) stop('VDJ clone column not found in metadata.')",
    "df <- data.frame(",
    "  condition = if (is.null(condition_col) || !(condition_col %in% colnames(md))) 'All cells' else as.character(md[[condition_col]]),",
    "  cluster = as.character(md[[cluster_col]]),",
    "  clonotype = as.character(md[[clone_col]]),",
    "  stringsAsFactors = FALSE",
    ")",
    "df$condition[is.na(df$condition) | !nzchar(df$condition)] <- 'Unknown'",
    "df$cluster[is.na(df$cluster) | !nzchar(df$cluster)] <- 'Unknown'",
    "df$clonotype[is.na(df$clonotype)] <- ''",
    "df <- df[nzchar(df$clonotype), , drop = FALSE]",
    "flow_df <- dplyr::count(df, .data$condition, .data$cluster, .data$clonotype, name = 'n_cells')",
    "flow_df <- flow_df[flow_df$n_cells >= min_cells, , drop = FALSE]",
    "top_labels <- flow_df |>",
    "  dplyr::group_by(.data$condition, .data$clonotype) |>",
    "  dplyr::summarise(total_cells = sum(.data$n_cells), .groups = 'drop') |>",
    "  dplyr::arrange(.data$condition, dplyr::desc(.data$total_cells), .data$clonotype) |>",
    "  dplyr::slice_head(n = top_n) |>",
    "  dplyr::pull(.data$clonotype)",
    "flow_df <- flow_df[flow_df$clonotype %in% top_labels, , drop = FALSE]",
    "flow_df$alluvium <- paste(flow_df$condition, flow_df$cluster, flow_df$clonotype, sep = '||')",
    "",
    "p <- ggplot2::ggplot(flow_df, ggplot2::aes(x = .data$condition, stratum = .data$cluster, alluvium = .data$alluvium, y = .data$n_cells, fill = .data$cluster)) +",
    "  ggalluvial::geom_alluvium(alpha = ribbon_alpha, width = ribbon_width)",
    "if (!is.null(cluster_palette) && length(cluster_palette)) {",
    "  p <- p + ggplot2::scale_fill_manual(values = cluster_palette)",
    "}",
    "",
    "# 5) Add extra ggplot layers below",
    "# p <- p + ggplot2::labs(title = 'Custom Alluvial Plot')",
    "",
    "print(p)"
  )
  paste(lines, collapse = "\n")
}

figure_generate_cluster_alluvial_script <- function(params) {
  `%||%` <- function(a, b) if (!is.null(a)) a else b
  split_col <- params$split_col %||% NULL
  lines <- c(
    figure_recipe_code_lines(list(object_name = params$object_name), params),
    "# 1) Load packages",
    "library(Seurat)",
    "library(ggplot2)",
    "library(dplyr)",
    "library(ggalluvial)",
    "",
    "# 2) Resolve Seurat object from your workspace (or app shared_data)",
    .figure_code_object_lookup_lines(params$object_name),
    "",
    "# 3) Plot settings from Figure Studio UI",
    sprintf("cluster_col <- %s  # Cluster metadata column", .figure_code_val(.figure_code_chr(params$cluster_col, "seurat_clusters"))),
    sprintf("group_col <- %s  # Group column shown on x-axis", .figure_code_val(.figure_code_chr(params$group_col, "orig.ident"))),
    sprintf("split_col <- %s  # Optional split-panel metadata (NULL for one panel)", .figure_code_val(split_col)),
    sprintf("metric <- %s  # 'ratio' or 'count'", .figure_code_val(.figure_code_chr(params$metric, "ratio"))),
    sprintf("mode <- %s  # 'alluvial' or 'stacked'", .figure_code_val(.figure_code_chr(params$mode, "alluvial"))),
    sprintf("top_n <- %s  # Keep top N clusters by total abundance", .figure_code_val(params$top_n %||% 15)),
    sprintf("min_cells <- %s  # Minimum cells for each segment", .figure_code_val(params$min_cells %||% 1)),
    sprintf("ribbon_alpha <- %s  # Ribbon transparency for alluvial mode", .figure_code_val(params$alpha %||% 0.45)),
    sprintf("ribbon_width <- %s  # Ribbon width for alluvial mode", .figure_code_val(params$ribbon_width %||% 0.28)),
    sprintf("stack_bar_width <- %s  # Bar width for stacked mode", .figure_code_val(params$stack_bar_width %||% 0.85)),
    sprintf("stack_fill_alpha <- %s  # Bar alpha for stacked mode", .figure_code_val(params$stack_fill_alpha %||% 1)),
    sprintf("cluster_palette <- %s  # Optional manual fill palette", .figure_code_val(params$cluster_palette %||% NULL)),
    "",
    "# 4) Build cluster-composition data and plot",
    "md <- sobj@meta.data",
    "stopifnot(cluster_col %in% colnames(md), group_col %in% colnames(md))",
    "split_vals <- if (is.null(split_col) || !(split_col %in% colnames(md))) 'All cells' else as.character(md[[split_col]])",
    "df <- data.frame(split = split_vals, group = as.character(md[[group_col]]), cluster = as.character(md[[cluster_col]]), stringsAsFactors = FALSE)",
    "df$split[is.na(df$split) | !nzchar(df$split)] <- 'Unknown'",
    "df$group[is.na(df$group) | !nzchar(df$group)] <- 'Unknown'",
    "df$cluster[is.na(df$cluster) | !nzchar(df$cluster)] <- 'Unknown'",
    "df_counts <- dplyr::count(df, .data$split, .data$group, .data$cluster, name = 'n_cells')",
    "df_counts <- df_counts[df_counts$n_cells >= min_cells, , drop = FALSE]",
    "top_clusters <- df_counts |>",
    "  dplyr::group_by(.data$cluster) |>",
    "  dplyr::summarise(total = sum(.data$n_cells), .groups = 'drop') |>",
    "  dplyr::arrange(dplyr::desc(.data$total), .data$cluster) |>",
    "  dplyr::slice_head(n = top_n) |>",
    "  dplyr::pull(.data$cluster)",
    "df_counts <- df_counts[df_counts$cluster %in% top_clusters, , drop = FALSE]",
    "if (identical(metric, 'ratio')) {",
    "  df_counts <- df_counts |>",
    "    dplyr::group_by(.data$split, .data$group) |>",
    "    dplyr::mutate(value = .data$n_cells / sum(.data$n_cells)) |>",
    "    dplyr::ungroup()",
    "} else {",
    "  df_counts$value <- as.numeric(df_counts$n_cells)",
    "}",
    "p <- ggplot2::ggplot(df_counts, ggplot2::aes(x = .data$group, y = .data$value, fill = .data$cluster))",
    "if (identical(mode, 'stacked')) {",
    "  p <- p + ggplot2::geom_col(width = stack_bar_width, alpha = stack_fill_alpha)",
    "} else {",
    "  p <- p + ggalluvial::geom_alluvium(ggplot2::aes(stratum = .data$cluster, alluvium = .data$cluster), alpha = ribbon_alpha, width = ribbon_width)",
    "}",
    "if (!is.null(cluster_palette) && length(cluster_palette)) {",
    "  p <- p + ggplot2::scale_fill_manual(values = cluster_palette)",
    "}",
    "",
    "# 5) Add extra ggplot layers below",
    "# p <- p + ggplot2::labs(title = 'Custom Cluster Alluvial Plot')",
    "",
    "print(p)"
  )
  paste(lines, collapse = "\n")
}
