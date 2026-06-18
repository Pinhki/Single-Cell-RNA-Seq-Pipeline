COLOR_LAB_TEXT <- list(
  title = "Color Picker Lab",
  subtitle = "Standalone Motion-based dot picker module playground for future reuse across plotting pages.",
  single_card = "Single Color Picker",
  palette_card = "Palette Generator",
  preview_discrete = "Discrete Preview",
  preview_continuous = "Continuous Preview",
  output_title = "Live Payload",
  checklist_title = "Manual Validation Checklist"
)

library(ggplot2)

figure_color_picker_lab_ui <- fluidPage(
  div(
    class = "page-header",
    h2(icon("paint-brush"), " ", COLOR_LAB_TEXT$title),
    p(COLOR_LAB_TEXT$subtitle)
  ),

  fluidRow(
    column(
      6,
      div(
        class = "lab-card",
        h4(COLOR_LAB_TEXT$single_card),
        div(class = "lab-controls",
            actionButton("lab_single_reset", "Reset", class = "btn btn-outline-secondary btn-sm"),
            actionButton("lab_single_random", "Randomize", class = "btn btn-outline-primary btn-sm")
        ),
        motion_color_picker_ui("lab_single_picker", label = "Single color", mode = "single", initial_hex = "#3B82F6", initial_alpha = 1),
        htmlOutput("lab_single_hex_ui")
      )
    ),
    column(
      6,
      div(
        class = "lab-card",
        h4(COLOR_LAB_TEXT$palette_card),
        div(class = "lab-controls",
            actionButton("lab_palette_reset", "Reset", class = "btn btn-outline-secondary btn-sm"),
            actionButton("lab_palette_random", "Randomize", class = "btn btn-outline-primary btn-sm"),
            actionButton("lab_apply_preview", "Apply To Previews", class = "btn btn-success btn-sm")
        ),
        p(class = "lab-muted-note", "Plot previews update only when Apply is clicked."),
        motion_color_picker_ui("lab_palette_picker", label = "Palette mode", mode = "palette", initial_hex = "#8B5CF6", palette_n = 8, interpolation = "hsl"),
        uiOutput("lab_palette_swatches_ui")
      )
    )
  ),

  fluidRow(
    column(
      6,
      div(
        class = "lab-card",
        h4(COLOR_LAB_TEXT$preview_discrete),
        withSpinner(plotOutput("lab_discrete_plot", height = "320px"))
      )
    ),
    column(
      6,
      div(
        class = "lab-card",
        h4(COLOR_LAB_TEXT$preview_continuous),
        withSpinner(plotOutput("lab_continuous_plot", height = "320px"))
      )
    )
  ),

  fluidRow(
    column(
      6,
      div(
        class = "lab-card",
        h4(paste(COLOR_LAB_TEXT$output_title, "(Single)")),
        tags$div(class = "lab-code", verbatimTextOutput("lab_single_payload", placeholder = TRUE))
      )
    ),
    column(
      6,
      div(
        class = "lab-card",
        h4(paste(COLOR_LAB_TEXT$output_title, "(Palette)")),
        tags$div(class = "lab-code", verbatimTextOutput("lab_palette_payload", placeholder = TRUE))
      )
    )
  ),

  div(
    class = "lab-card",
    h4(COLOR_LAB_TEXT$checklist_title),
    tags$ol(
      tags$li("Drag hue ring and SV area: HEX and plot colors should update continuously."),
      tags$li("Adjust alpha slider: swatch opacity and JSON alpha should match."),
      tags$li("Palette mode: change palette size/interpolation and verify swatch count updates."),
      tags$li("Use Reset and Randomize repeatedly to confirm no stale state after tab switches."),
      tags$li("Confirm existing Figures tabs still load without errors.")
    )
  )
)

figure_color_picker_lab_server <- function(input, output, session, shared_data) {
  single <- motion_color_picker_server(
    "lab_single_picker",
    reset_trigger = reactive(input$lab_single_reset),
    randomize_trigger = reactive(input$lab_single_random)
  )

  palette <- motion_color_picker_server(
    "lab_palette_picker",
    reset_trigger = reactive(input$lab_palette_reset),
    randomize_trigger = reactive(input$lab_palette_random)
  )

  output$lab_single_hex_ui <- renderUI({
    v <- single()
    hex <- as.character(v$hex %||% "#3B82F6")
    alpha <- sprintf("%.2f", as.numeric(v$alpha %||% 1))
    HTML(sprintf("<p style='margin:8px 0 0 0;'><strong>HEX:</strong> <code>%s</code> &nbsp; <strong>Alpha:</strong> <code>%s</code></p>",
                 htmltools::htmlEscape(hex), htmltools::htmlEscape(alpha)))
  })

  output$lab_palette_swatches_ui <- renderUI({
    v <- palette()
    cols <- as.character(v$palette %||% character(0))
    if (!length(cols)) return(NULL)
    tags$div(
      class = "lab-swatch-row",
      lapply(cols, function(clr) {
        tags$div(class = "lab-chip", style = sprintf("background:%s;", clr), title = clr)
      })
    )
  })

  preview_state <- eventReactive(input$lab_apply_preview, {
    list(
      single = single(),
      palette = palette()
    )
  }, ignoreInit = FALSE)

  output$lab_discrete_plot <- renderPlot({
    v <- preview_state()$palette
    pal <- as.character(v$palette %||% c("#2563EB", "#10B981", "#F59E0B"))
    n_grp <- length(unique(mtcars$cyl))
    if (length(pal) < n_grp) {
      pal <- grDevices::colorRampPalette(pal)(n_grp)
    } else {
      pal <- pal[seq_len(n_grp)]
    }

    ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
      geom_point(size = 3.2, alpha = 0.9) +
      scale_color_manual(values = pal) +
      labs(x = "Weight", y = "MPG", color = "Cyl") +
      theme_minimal(base_size = 12)
  })

  output$lab_continuous_plot <- renderPlot({
    v <- preview_state()$single
    high <- as.character(v$hex %||% "#3B82F6")
    alpha <- suppressWarnings(as.numeric(v$alpha %||% 1))
    if (!is.finite(alpha)) alpha <- 1

    ggplot(faithful, aes(x = eruptions, y = waiting, color = waiting)) +
      geom_point(size = 2.5, alpha = max(0.15, min(1, alpha))) +
      scale_color_gradient(low = "#E5E7EB", high = high) +
      labs(x = "Eruptions", y = "Waiting", color = "Waiting") +
      theme_minimal(base_size = 12)
  })

  output$lab_single_payload <- renderText({
    jsonlite::toJSON(single(), auto_unbox = TRUE, pretty = TRUE, null = "null")
  })

  output$lab_palette_payload <- renderText({
    jsonlite::toJSON(palette(), auto_unbox = TRUE, pretty = TRUE, null = "null")
  })
}
