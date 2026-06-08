`%||%` <- function(a, b) if (is.null(a)) b else a

wanlab_admin_gated_pages <- function() {
  data.frame(
    tab = c(
      "contam_tab",
      "flowgate_tab",
      "rna_velocity_v052_tab",
      "cellwhisperer_tab",
      "figure_studio_pseudobulk_volcano_hidden",
      "multiome_export_check_tab"
    ),
    label = c(
      "Hidden contamination page",
      "Flow Gating (beta)",
      "RNA velocity v0.5.2 (alpha)",
      "CellWhisperer (admin)",
      "Pseudobulk Volcano (hidden alpha)",
      "Multiome Export Check (beta, seurat5 only)"
    ),
    button_id = c(
      "admin_open_contamination_tab_btn",
      "admin_open_flowgate_tab_btn",
      "admin_open_rna_velocity_v052_btn",
      "admin_open_cellwhisperer_tab_btn",
      "admin_open_figure_pbv_hidden_tab_btn",
      "admin_open_multiome_export_check_tab_btn"
    ),
    icon = c(
      "shield-virus",
      "flask",
      "flask",
      "brain",
      "chart-line",
      "file-export"
    ),
    class = c(
      "btn btn-outline-warning",
      "btn btn-outline-primary",
      "btn btn-outline-primary",
      "btn btn-outline-info",
      "btn btn-outline-secondary",
      "btn btn-outline-primary"
    ),
    stringsAsFactors = FALSE
  )
}

wanlab_admin_gated_tabs <- function() {
  defs <- wanlab_admin_gated_pages()
  unique(as.character(defs$tab %||% character(0)))
}

wanlab_admin_button_to_tab <- function() {
  defs <- wanlab_admin_gated_pages()
  stats::setNames(as.character(defs$tab %||% character(0)), as.character(defs$button_id %||% character(0)))
}
