wl_gene_selectize_options <- function(placeholder = "Type to search gene", max_options = 100L, min_chars = 1L) {
  max_options <- suppressWarnings(as.integer(max_options %||% 100L))
  if (!is.finite(max_options) || is.na(max_options) || max_options < 1L) max_options <- 100L
  min_chars <- suppressWarnings(as.integer(min_chars %||% 1L))
  if (!is.finite(min_chars) || is.na(min_chars) || min_chars < 1L) min_chars <- 1L

  list(
    placeholder = placeholder,
    maxOptions = max_options,
    openOnFocus = FALSE,
    preload = FALSE,
    closeAfterSelect = TRUE,
    loadThrottle = 250,
    score = I(sprintf(
      "function(search) { search = (search || '').trim(); if (search.length < %d) { return function() { return false; }; } return this.getScoreFunction(search); }",
      min_chars
    ))
  )
}

wl_gene_selectize_input <- function(inputId, label, selected = character(0), multiple = FALSE,
                                    placeholder = "Type to search gene", width = NULL,
                                    max_options = 100L, min_chars = 1L) {
  selected <- as.character(selected %||% character(0))
  selected <- selected[!is.na(selected) & nzchar(selected)]
  shiny::selectizeInput(
    inputId,
    label,
    choices = unique(selected),
    selected = selected,
    multiple = isTRUE(multiple),
    width = width,
    options = wl_gene_selectize_options(
      placeholder = placeholder,
      max_options = max_options,
      min_chars = min_chars
    )
  )
}

wl_update_gene_selectize <- function(session, inputId, genes, selected = character(0), server = TRUE) {
  genes <- unique(as.character(genes %||% character(0)))
  genes <- genes[!is.na(genes) & nzchar(genes)]
  selected <- as.character(selected %||% character(0))
  selected <- selected[!is.na(selected) & nzchar(selected)]
  shiny::updateSelectizeInput(
    session,
    inputId,
    choices = genes,
    selected = selected,
    server = isTRUE(server)
  )
}
