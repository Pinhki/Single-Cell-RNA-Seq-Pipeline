wan_lab_footer <- function(APP_VERSION = NA_character_) {
  app_version <- APP_VERSION
  app_version_label <- if (is.na(app_version) || !nzchar(app_version)) "NA" else app_version
  tagList(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "footer.css")),
    div(class = "footer",
      div(class = "footer-inner",
        span(sprintf("Wan Lab Single Cell Pipeline v%s", app_version_label)),
        span(" • "),
        span("© 2025 Wan Lab"),
        span(" • "),
        tags$a(href = "https://sites.wustl.edu/wanlab/", "Lab Website", target = "_blank"),
        span(" • "),
        span(
          class = "footer-policy",
          tags$abbr(
            title = "This app may not be perfect, but it was built under extreme tuning and stress testing by a PhD student who had no formal obligation to do this, no spare time to do this, and in truth would have preferred not to take this on at all. It was done solely out of care for the lab. The code is visible, but this is not open source. Any reverse engineering, modification, or analysis without explicit permission is unauthorized, and you assume all resulting risks and consequences, which will be refused for any help or suggestions.",
            style = "text-decoration: none; cursor: help;",
            HTML("<strong>Unauthorized</strong> LLM-assisted <strong>reverse engineering, modification, or adaptation</strong> of this app is strictly <strong>prohibited</strong>. Ask permission and contribute with <strong>etiquette</strong>.")
          )
        ),
        span(" • "),
        tags$a(href = "mailto:rongzhen@wustl.edu", "Contact Developer", target = "_blank")
      )
    )
  )
}
