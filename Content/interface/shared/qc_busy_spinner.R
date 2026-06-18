QC_BUSY_SPINNER_COLOR <- "#9aa0a6"

qc_busy_spinner_assets <- local({
  shiny::tags$style(shiny::HTML("
    .qc-load-wrap{
      position: relative;
      width: 100%;
    }
    .qc-load-indicator{
      display: none;
      position: absolute;
      inset: 0;
      z-index: 11;
      align-items: center;
      justify-content: center;
      pointer-events: none;
      background: rgba(255, 255, 255, 0.70);
    }
    .qc-load-wrap > .recalculating + .qc-load-indicator{
      display: flex;
    }
    .qc-load-wrap > .recalculating{
      opacity: 0.30;
    }
  "))
})

qc_with_busy_spinner <- function(output_ui, color = QC_BUSY_SPINNER_COLOR) {
  shiny::div(
    class = "qc-load-wrap",
    output_ui,
    shiny::div(
      class = "qc-load-indicator",
      shinybusy::spin_epic(
        spin = "self-building-square",
        color = color
      )
    )
  )
}
