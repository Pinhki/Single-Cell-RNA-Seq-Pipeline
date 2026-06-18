POLINE_LAB_TEXT <- list(
  title = "Poline Palette Lab",
  subtitle = "Poline-style interactive picker with line-based interpolation.",
  credit = "Inspired by Poline by meodai (elastiq.ch)",
  apply = "Apply Palette",
  random = "Randomize",
  reset = "Reset"
)

library(ggplot2)

figure_poline_lab_ui <- fluidPage(
  div(
    class = "page-header",
    h2(icon("palette"), " ", POLINE_LAB_TEXT$title),
    p(POLINE_LAB_TEXT$subtitle),
    div(
      class = "poline-credit",
      tags$span(POLINE_LAB_TEXT$credit),
      tags$span(" · "),
      tags$a("meodai.github.io/poline", href = "https://meodai.github.io/poline/", target = "_blank", rel = "noopener noreferrer")
    )
  ),

  fluidRow(
    column(
      4,
      div(
        class = "poline-card",
        h4("Controls"),
        div(style = "margin-bottom:8px;",
            actionButton("poline_reset", POLINE_LAB_TEXT$reset, class = "btn btn-outline-secondary btn-sm"),
            actionButton("poline_randomize", POLINE_LAB_TEXT$random, class = "btn btn-outline-info btn-sm"),
            actionButton("poline_apply", POLINE_LAB_TEXT$apply, class = "btn btn-success btn-sm")
        ),
        curve_color_picker_ui(
          "poline_picker_wc",
          label = "Poline-style picker",
          mode = "palette",
          initial_hex = "#7C3AED",
          palette_n = 8,
          interpolation = "rgb"
        ),
        p(class = "poline-muted", "Preview plots update only when Apply is clicked.")
      )
    ),
    column(
      8,
      div(
        class = "poline-card",
        h4("Palette Swatches"),
        uiOutput("poline_swatches_ui")
      ),
      fluidRow(
        column(6,
               div(class = "poline-card", h4("Categorical Preview"), withSpinner(plotOutput("poline_discrete_plot", height = "300px")))
        ),
        column(6,
               div(class = "poline-card", h4("Gradient Preview"), withSpinner(plotOutput("poline_gradient_plot", height = "300px")))
        )
      ),
      div(
        class = "poline-card",
        h4("Export Payload"),
        tags$div(class = "poline-code", verbatimTextOutput("poline_payload", placeholder = TRUE))
      )
    )
  )
)

figure_poline_lab_server <- function(input, output, session, shared_data) {
  poline_picker <- curve_color_picker_server(
    "poline_picker_wc",
    reset_trigger = reactive(input$poline_reset),
    randomize_trigger = reactive(input$poline_randomize)
  )

  .runtime_payload <- reactive({
    v <- poline_picker()
    palette <- as.character(v$palette %||% character(0))
    palette <- palette[grepl("^#[0-9A-Fa-f]{6}$", palette)]
    if (!length(palette)) palette <- c("#7C3AED", "#06B6D4", "#F59E0B")

    list(
      colors_hex = toupper(palette),
      colors_hsl = list(v$hsl %||% c(260, 80, 55)),
      anchors_hsl = list(v$hsl %||% c(260, 80, 55)),
      num_points = as.integer(length(palette)),
      closed_loop = FALSE,
      meta = v$meta %||% list(source = "runtime", timestamp_ms = as.numeric(Sys.time()) * 1000)
    )
  })

  palette_state <- eventReactive(input$poline_apply, {
    .runtime_payload()
  }, ignoreInit = FALSE)

  output$poline_swatches_ui <- renderUI({
    cols <- .runtime_payload()$colors_hex
    tags$div(
      class = "poline-swatches",
      lapply(cols, function(clr) {
        tags$div(class = "poline-chip", style = sprintf("background:%s;", clr), title = clr)
      })
    )
  })

  output$poline_discrete_plot <- renderPlot({
    cols <- palette_state()$colors_hex
    groups <- sort(unique(mtcars$cyl))
    if (length(cols) < length(groups)) cols <- grDevices::colorRampPalette(cols)(length(groups))
    cols <- cols[seq_len(length(groups))]

    ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
      geom_point(size = 3, alpha = 0.9) +
      scale_color_manual(values = cols) +
      labs(x = "Weight", y = "MPG", color = "Cyl") +
      theme_minimal(base_size = 12)
  })

  output$poline_gradient_plot <- renderPlot({
    cols <- palette_state()$colors_hex
    if (length(cols) < 2) cols <- c("#111827", "#93C5FD")

    faithful2 <- faithful
    faithful2$idx <- seq_len(nrow(faithful2))

    ggplot(faithful2, aes(idx, waiting, color = waiting)) +
      geom_point(size = 2.2, alpha = 0.85) +
      scale_color_gradientn(colors = cols) +
      labs(x = "Index", y = "Waiting", color = "Value") +
      theme_minimal(base_size = 12)
  })

  output$poline_payload <- renderText({
    jsonlite::toJSON(palette_state(), auto_unbox = TRUE, pretty = TRUE, null = "null")
  })
}
