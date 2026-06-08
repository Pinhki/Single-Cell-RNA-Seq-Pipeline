wl_beta_badge <- function(text = "beta", with_icon = TRUE, icon_name = "flask") {
  badge_key <- tolower(gsub("[^A-Za-z0-9]+", "-", as.character(text %||% "beta")))
  badge_key <- gsub("(^-+|-+$)", "", badge_key)
  if (!nzchar(badge_key)) badge_key <- "beta"
  pieces <- list()
  if (isTRUE(with_icon)) {
    pieces <- c(pieces, list(icon(icon_name, class = "beta-badge__icon")))
  }
  pieces <- c(
    pieces,
    list(tags$span(text, class = "beta-badge__text"))
  )
  tags$span(class = paste("beta-badge", paste0("beta-badge--", badge_key)), pieces)
}

wl_beta_label <- function(label, suffix = NULL, with_icon = FALSE) {
  if (is.null(suffix) || !nzchar(suffix)) {
    return(tagList(label, wl_beta_badge(with_icon = with_icon)))
  }
  tagList(label, wl_beta_badge(with_icon = with_icon), tags$span(paste0(" (", suffix, ")")))
}

wl_seurat5_badge <- function(text = "Seurat v5") {
  tags$span(class = "seurat5-badge", tags$span(text, class = "seurat5-badge__text"))
}

wl_beta_seurat5_label <- function(label, with_icon = FALSE) {
  tagList(label, wl_beta_badge(with_icon = with_icon), wl_seurat5_badge())
}

wl_alpha_badge <- function(text = "alpha", with_icon = TRUE, icon_name = "triangle-exclamation") {
  pieces <- list()
  if (isTRUE(with_icon)) {
    pieces <- c(pieces, list(icon(icon_name, class = "alpha-badge__icon")))
  }
  pieces <- c(
    pieces,
    list(tags$span(text, class = "alpha-badge__text"))
  )
  tags$span(class = "alpha-badge", pieces)
}

wl_alpha_label <- function(label, suffix = NULL, with_icon = FALSE) {
  if (is.null(suffix) || !nzchar(suffix)) {
    return(tagList(label, wl_alpha_badge(with_icon = with_icon)))
  }
  tagList(label, wl_alpha_badge(with_icon = with_icon), tags$span(paste0(" (", suffix, ")")))
}

wl_deprecated_badge <- function(text = "deprecated", with_icon = TRUE, icon_name = "ban") {
  pieces <- list()
  if (isTRUE(with_icon)) {
    pieces <- c(pieces, list(icon(icon_name, class = "deprecated-badge__icon")))
  }
  pieces <- c(
    pieces,
    list(tags$span(text, class = "deprecated-badge__text"))
  )
  tags$span(class = "deprecated-badge", pieces)
}

wl_deprecated_label <- function(label, with_icon = FALSE) {
  tagList(label, wl_deprecated_badge(with_icon = with_icon))
}
