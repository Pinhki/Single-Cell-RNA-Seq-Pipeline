wl_pdf_modal_assets <- function() {
  tagList(
    tags$style(HTML("
      .wl-pdf-preview-resize-box{
        resize: both;
        overflow: auto;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        background: #ffffff;
        min-width: 220px;
        min-height: 180px;
        max-width: 100%;
      }

      .wl-pdf-preview-resize-box img{
        width: 100%;
        height: 100%;
        object-fit: contain;
        display: block;
      }

      .wl-pdf-preview-hdrag{
        margin-top: 8px;
        height: 14px;
        border-radius: 999px;
        background: linear-gradient(90deg, #cbd5e1 0%, #94a3b8 50%, #cbd5e1 100%);
        cursor: ew-resize;
        user-select: none;
        touch-action: none;
        box-shadow: inset 0 0 0 1px rgba(15, 23, 42, 0.08);
      }

      .wl-pdf-preview-vdrag{
        position: absolute;
        top: 0;
        right: -18px;
        width: 14px;
        height: 100%;
        border-radius: 999px;
        background: linear-gradient(180deg, #cbd5e1 0%, #94a3b8 50%, #cbd5e1 100%);
        cursor: ns-resize;
        user-select: none;
        touch-action: none;
        box-shadow: inset 0 0 0 1px rgba(15, 23, 42, 0.08);
      }

      .wl-pdf-preview-stage{
        position: relative;
        display: inline-block;
        padding-right: 22px;
      }
    ")),
    tags$script(HTML("
      (function() {
        window.wlAttachPdfPreviewResize = function(boxId, inputId) {
          var el = document.getElementById(boxId);
          if (!el || typeof ResizeObserver === 'undefined') return;
          if (el.__wlResizeObserver) {
            try { el.__wlResizeObserver.disconnect(); } catch (e) {}
          }
          var emit = function() {
            Shiny.setInputValue(inputId, {
              w: el.clientWidth || 0,
              h: el.clientHeight || 0,
              nonce: Date.now()
            }, {priority: 'event'});
          };
          var ro = new ResizeObserver(emit);
          ro.observe(el);
          el.__wlResizeObserver = ro;
          emit();
        };

        window.wlSetPdfPreviewBoxSize = function(boxId, widthPx, heightPx) {
          var el = document.getElementById(boxId);
          if (!el) return;
          if (Number.isFinite(widthPx) && widthPx > 0) el.style.width = widthPx + 'px';
          if (Number.isFinite(heightPx) && heightPx > 0) el.style.height = heightPx + 'px';
        };

        window.wlAttachPdfPreviewHorizontalDrag = function(handleId, boxId, inputId) {
          var handle = document.getElementById(handleId);
          var box = document.getElementById(boxId);
          if (!handle || !box) return;
          if (handle.__wlDragBound) return;
          handle.__wlDragBound = true;

          var dragState = null;
          var minWidth = 220;
          var maxWidth = 1600;

          var emit = function() {
            if (!window.Shiny) return;
            Shiny.setInputValue(inputId, {
              w: box.clientWidth || 0,
              h: box.clientHeight || 0,
              nonce: Date.now()
            }, {priority: 'event'});
          };

          var onMove = function(evt) {
            if (!dragState) return;
            var x = evt.clientX;
            if (!Number.isFinite(x) && evt.touches && evt.touches.length) x = evt.touches[0].clientX;
            if (!Number.isFinite(x)) return;
            var nextWidth = Math.max(minWidth, Math.min(maxWidth, dragState.startWidth + (x - dragState.startX)));
            box.style.width = nextWidth + 'px';
            emit();
            evt.preventDefault();
          };

          var endDrag = function() {
            dragState = null;
            document.removeEventListener('mousemove', onMove, true);
            document.removeEventListener('mouseup', endDrag, true);
            document.removeEventListener('touchmove', onMove, true);
            document.removeEventListener('touchend', endDrag, true);
          };

          var startDrag = function(evt) {
            var x = evt.clientX;
            if (!Number.isFinite(x) && evt.touches && evt.touches.length) x = evt.touches[0].clientX;
            if (!Number.isFinite(x)) return;
            dragState = {
              startX: x,
              startWidth: box.clientWidth || box.offsetWidth || minWidth
            };
            document.addEventListener('mousemove', onMove, true);
            document.addEventListener('mouseup', endDrag, true);
            document.addEventListener('touchmove', onMove, true);
            document.addEventListener('touchend', endDrag, true);
            evt.preventDefault();
          };

          handle.addEventListener('mousedown', startDrag, true);
          handle.addEventListener('touchstart', startDrag, {passive: false, capture: true});
        };

        window.wlAttachPdfPreviewVerticalDrag = function(handleId, boxId, inputId) {
          var handle = document.getElementById(handleId);
          var box = document.getElementById(boxId);
          if (!handle || !box) return;
          if (handle.__wlDragBound) return;
          handle.__wlDragBound = true;

          var dragState = null;
          var minHeight = 180;
          var maxHeight = 1400;

          var emit = function() {
            if (!window.Shiny) return;
            Shiny.setInputValue(inputId, {
              w: box.clientWidth || 0,
              h: box.clientHeight || 0,
              nonce: Date.now()
            }, {priority: 'event'});
          };

          var onMove = function(evt) {
            if (!dragState) return;
            var y = evt.clientY;
            if (!Number.isFinite(y) && evt.touches && evt.touches.length) y = evt.touches[0].clientY;
            if (!Number.isFinite(y)) return;
            var nextHeight = Math.max(minHeight, Math.min(maxHeight, dragState.startHeight + (y - dragState.startY)));
            box.style.height = nextHeight + 'px';
            emit();
            evt.preventDefault();
          };

          var endDrag = function() {
            dragState = null;
            document.removeEventListener('mousemove', onMove, true);
            document.removeEventListener('mouseup', endDrag, true);
            document.removeEventListener('touchmove', onMove, true);
            document.removeEventListener('touchend', endDrag, true);
          };

          var startDrag = function(evt) {
            var y = evt.clientY;
            if (!Number.isFinite(y) && evt.touches && evt.touches.length) y = evt.touches[0].clientY;
            if (!Number.isFinite(y)) return;
            dragState = {
              startY: y,
              startHeight: box.clientHeight || box.offsetHeight || minHeight
            };
            document.addEventListener('mousemove', onMove, true);
            document.addEventListener('mouseup', endDrag, true);
            document.addEventListener('touchmove', onMove, true);
            document.addEventListener('touchend', endDrag, true);
            evt.preventDefault();
          };

          handle.addEventListener('mousedown', startDrag, true);
          handle.addEventListener('touchstart', startDrag, {passive: false, capture: true});
        };
      })();
    "))
  )
}

wl_pdf_modal_server <- function(
  input,
  output,
  session,
  id_prefix = "wl_pdf",
  build_bundle,
  download_btn_label = "Download PDF",
  default_modal_title = "PDF export settings"
) {
  stopifnot(is.function(build_bundle))

  `%||%` <- function(a, b) if (!is.null(a)) a else b
  .prefix <- gsub("[^A-Za-z0-9_]+", "_", as.character(id_prefix %||% "wl_pdf"))
  .id <- function(suffix) paste0(.prefix, "_", suffix)

  .state_kind <- reactiveVal(NULL)
  .preview_box_id <- .id("preview_resize_box")
  .preview_h_handle_id <- .id("preview_resize_handle_h")
  .preview_v_handle_id <- .id("preview_resize_handle_v")
  .input_box_size <- .id("preview_box_size")
  .ui_preview_box <- .id("preview_box_ui")
  .img_preview <- .id("preview_png")
  .download_output <- .id("download_pdf")
  .input_width <- .id("width_in")
  .input_height <- .id("height_in")
  .input_scale <- .id("preview_scale")

  .build_checked <- function(kind, width_px = NULL, height_px = NULL) {
    b <- build_bundle(kind = kind, width_px = width_px, height_px = height_px)
    if (!is.list(b) || is.null(b$plot)) stop("build_bundle must return list(plot=..., width_px=..., height_px=...).")
    b$width_px <- suppressWarnings(as.numeric(b$width_px %||% 1050))
    b$height_px <- suppressWarnings(as.numeric(b$height_px %||% 700))
    if (!is.finite(b$width_px) || b$width_px <= 0) b$width_px <- 1050
    if (!is.finite(b$height_px) || b$height_px <= 0) b$height_px <- 700
    b
  }

  .open_png_device <- function(path, width_px, height_px) {
    if (isTRUE(capabilities("cairo"))) {
      grDevices::png(filename = path, width = width_px, height = height_px, res = 96, bg = "white", type = "cairo")
      return(invisible(TRUE))
    }
    grDevices::png(filename = path, width = width_px, height = height_px, res = 96, bg = "white")
    invisible(TRUE)
  }

  .open_pdf_device <- function(path, width_in, height_in) {
    if (isTRUE(capabilities("cairo"))) {
      grDevices::cairo_pdf(file = path, width = width_in, height = height_in, onefile = TRUE, family = "sans")
      return(invisible(TRUE))
    }
    grDevices::pdf(file = path, width = width_in, height = height_in, onefile = TRUE, version = "1.4", useDingbats = FALSE)
    invisible(TRUE)
  }

  .open <- function(kind, title_txt = default_modal_title) {
    kind <- as.character(kind %||% "")
    req(nzchar(kind))
    b <- .build_checked(kind = kind)
    .state_kind(kind)

    updateNumericInput(session, .input_width, value = round(max(4, b$width_px / 96), 2))
    updateNumericInput(session, .input_height, value = round(max(3, b$height_px / 96), 2))
    updateSliderInput(session, .input_scale, value = 0.28)

    showModal(modalDialog(
      title = title_txt,
      size = "l",
      easyClose = TRUE,
      footer = tagList(
        modalButton("Close"),
        downloadButton(.download_output, download_btn_label, class = "btn btn-primary")
      ),
      fluidRow(
        column(
          4,
          numericInput(.input_width, "Width (inches)", value = round(max(4, b$width_px / 96), 2), min = 2, max = 60, step = 0.1),
          numericInput(.input_height, "Height (inches)", value = round(max(3, b$height_px / 96), 2), min = 2, max = 60, step = 0.1),
          sliderInput(.input_scale, "Preview scale", min = 0.15, max = 0.80, value = 0.28, step = 0.01),
          p(class = "text-muted", "Preview-only resize: drag the horizontal or vertical handle to inspect the plot more clearly. PDF export size still follows Width/Height (inches).")
        ),
        column(8, uiOutput(.ui_preview_box))
      )
    ))
  }

  output[[.ui_preview_box]] <- renderUI({
    req(.state_kind())
    scale_val <- suppressWarnings(as.numeric(input[[.input_scale]] %||% 0.28))
    if (!is.finite(scale_val) || scale_val <= 0) scale_val <- 0.28
    w_in <- suppressWarnings(as.numeric(input[[.input_width]] %||% 10))
    h_in <- suppressWarnings(as.numeric(input[[.input_height]] %||% 7))
    if (!is.finite(w_in) || w_in <= 0) w_in <- 10
    if (!is.finite(h_in) || h_in <= 0) h_in <- 7
    box_w <- as.integer(max(220, min(980, round(w_in * 96 * scale_val))))
    box_h <- as.integer(max(180, min(760, round(h_in * 96 * scale_val))))
    tags$div(
      class = "wl-pdf-preview-stage",
      tags$div(
        id = .preview_box_id,
        class = "wl-pdf-preview-resize-box",
        style = sprintf("width:%dpx;height:%dpx;", box_w, box_h),
        imageOutput(.img_preview, width = "100%", height = "100%"),
        tags$div(id = .preview_v_handle_id, class = "wl-pdf-preview-vdrag", title = "Drag vertically to resize preview height")
      ),
      tags$div(id = .preview_h_handle_id, class = "wl-pdf-preview-hdrag", title = "Drag horizontally to resize preview width"),
      tags$script(HTML(sprintf(
        paste0(
          "setTimeout(function(){",
          " if(window.wlAttachPdfPreviewResize){ window.wlAttachPdfPreviewResize('%s', '%s'); }",
          " if(window.wlAttachPdfPreviewHorizontalDrag){ window.wlAttachPdfPreviewHorizontalDrag('%s', '%s', '%s'); }",
          " if(window.wlAttachPdfPreviewVerticalDrag){ window.wlAttachPdfPreviewVerticalDrag('%s', '%s', '%s'); }",
          "}, 25);"
        ),
        .preview_box_id, .input_box_size,
        .preview_h_handle_id, .preview_box_id, .input_box_size,
        .preview_v_handle_id, .preview_box_id, .input_box_size
      )))
    )
  })

  observeEvent(
    list(input[[.input_width]], input[[.input_height]], input[[.input_scale]], .state_kind()),
    {
      req(.state_kind())
      scale_val <- suppressWarnings(as.numeric(input[[.input_scale]] %||% 0.28))
      if (!is.finite(scale_val) || scale_val <= 0) scale_val <- 0.28
      w_in <- suppressWarnings(as.numeric(input[[.input_width]] %||% 10))
      h_in <- suppressWarnings(as.numeric(input[[.input_height]] %||% 7))
      if (!is.finite(w_in) || w_in <= 0) w_in <- 10
      if (!is.finite(h_in) || h_in <= 0) h_in <- 7
      box_w <- as.integer(max(220, min(980, round(w_in * 96 * scale_val))))
      box_h <- as.integer(max(180, min(760, round(h_in * 96 * scale_val))))
      shinyjs::runjs(sprintf(
        "if(window.wlSetPdfPreviewBoxSize){ window.wlSetPdfPreviewBoxSize('%s', %d, %d); }",
        .preview_box_id, box_w, box_h
      ))
    },
    ignoreInit = TRUE
  )

  output[[.img_preview]] <- renderImage({
    kind <- .state_kind()
    req(kind)
    w_in <- suppressWarnings(as.numeric(input[[.input_width]] %||% 10))
    h_in <- suppressWarnings(as.numeric(input[[.input_height]] %||% 7))
    if (!is.finite(w_in) || w_in <= 0) w_in <- 10
    if (!is.finite(h_in) || h_in <= 0) h_in <- 7
    box <- input[[.input_box_size]] %||% list()
    box_w <- suppressWarnings(as.numeric(box$w %||% NA_real_))
    box_h <- suppressWarnings(as.numeric(box$h %||% NA_real_))
    w_px <- as.integer(max(320, min(3600, max(round(w_in * 96), round((box_w %||% 0) * 2)))))
    h_px <- as.integer(max(240, min(3600, max(round(h_in * 96), round((box_h %||% 0) * 2)))))
    b <- .build_checked(kind = kind, width_px = w_px, height_px = h_px)
    tf <- tempfile(fileext = ".png")
    .open_png_device(path = tf, width_px = w_px, height_px = h_px)
    on.exit(grDevices::dev.off(), add = TRUE)
    print(b$plot)
    list(src = tf, contentType = "image/png", width = "100%", height = "100%")
  }, deleteFile = TRUE)

  output[[.download_output]] <- downloadHandler(
    filename = function() {
      kind <- .state_kind()
      req(kind)
      b <- .build_checked(kind = kind)
      prefix <- as.character(b$filename_prefix %||% "plot_")
      paste0(prefix, format(Sys.time(), "%Y%m%d_%H%M%S"), ".pdf")
    },
    content = function(file) {
      kind <- .state_kind()
      req(kind)
      w_in <- suppressWarnings(as.numeric(input[[.input_width]] %||% NA_real_))
      h_in <- suppressWarnings(as.numeric(input[[.input_height]] %||% NA_real_))
      if (!is.finite(w_in) || w_in <= 0) w_in <- 10
      if (!is.finite(h_in) || h_in <= 0) h_in <- 7
      w_in <- max(2, min(60, w_in))
      h_in <- max(2, min(60, h_in))
      w_px <- as.integer(max(320, min(3600, round(w_in * 96))))
      h_px <- as.integer(max(240, min(3600, round(h_in * 96))))
      b <- .build_checked(kind = kind, width_px = w_px, height_px = h_px)
      .open_pdf_device(path = file, width_in = w_in, height_in = h_in)
      on.exit(grDevices::dev.off(), add = TRUE)
      print(b$plot)
    }
  )

  list(
    open = .open,
    ids = list(
      width = .input_width,
      height = .input_height,
      scale = .input_scale,
      download = .download_output
    )
  )
}
