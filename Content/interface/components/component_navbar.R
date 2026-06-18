# Define the navbar UI structure
wan_lab_navbar <- function(id, theme, welcome_ui, environment_ui, qc_ui, contamination_correction_ui, hto_ui, doublet_ui, vdj_ui, barcode_ui, flowgate_ui,
                           atac_qc_ui, analysis_ui, data_browser_ui, recluster_ui, recluster_new_ui, rna_velocity_ui, rna_velocity_v052_ui, multiome_wnn_ui, multiome_marker_ui,
                           cellchat_ui, scenic_ui, monocle2_ui, nichenet_ui, niches_ui, sctenifoldknk_ui, cellwhisperer_ui,
                           figure_umap_ui, figure_feature_ui, figure_dotplot_ui, figure_alluvial_ui, figure_cluster_alluvial_ui, figure_tcr_studio_ui, figure_pseudobulk_volcano_hidden_ui,
                           export_ui, export_vdj_safe_ui, multiome_export_check_ui, rds_ui, right_sidebar_ui, APP_VERSION) {
  app_page <- function(x) div(class = "app-page", x)
  plotting_page <- function(x) div(class = "app-page plotting-page", x)
  .nav_spacer_safe <- function() {
    ns <- get0("nav_spacer", envir = asNamespace("bslib"), inherits = FALSE, ifnotfound = NULL)
    if (is.function(ns)) return(ns())
    if (!is.null(ns)) return(ns)
    tags$div(style = "flex:1 1 auto;")
  }
  .nav_title <- function(label, icon_name) {
    tagList(
      icon(icon_name, class = "wl-nav-icon"),
      span(label, class = "wl-nav-label")
    )
  }
  
  page_navbar(
    title = div(
      class = "wl-navbar-brand-title",
      span("Wan Lab Single Cell", class = "wl-navbar-brand-main"),
      span(sprintf("v%s", APP_VERSION), class = "wl-navbar-brand-version")
    ),
    id = id,
    theme = theme,
    fillable = TRUE,
    
    # Custom CSS inclusions
    header = tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "global.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "navbar.css?v=leftnav-action-label"),     # <-- New Navbar Style
      tags$link(rel = "stylesheet", type = "text/css", href = "custom_bslib.css"), # <-- Layout tweaks
      tags$script(HTML(
        "(function(){
          function bindRail(nav){
            if (!nav || nav.dataset.wlRailBound === 'true') return;
            nav.dataset.wlRailBound = 'true';
            nav.addEventListener('mouseenter', function(){ nav.classList.add('wl-nav-expanded'); });
            nav.addEventListener('mouseover', function(){ nav.classList.add('wl-nav-expanded'); });
            nav.addEventListener('mouseleave', function(){ nav.classList.remove('wl-nav-expanded'); });
            nav.addEventListener('focusin', function(){ nav.classList.add('wl-nav-expanded'); });
            nav.addEventListener('focusout', function(){ setTimeout(function(){ if (!nav.contains(document.activeElement)) nav.classList.remove('wl-nav-expanded'); }, 0); });
          }
          function init(){ document.querySelectorAll('.navbar').forEach(bindRail); }
          if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
          else init();
          document.addEventListener('shiny:bound', init);
        })();"
      ))
    ),
    
    # Sidebar Configuration (Global Right Side)
    sidebar = sidebar(
      id = "app_right_sidebar",
      position = "right",
      width = 300,
      open = "open", 
      bg = "#ffffff",
      right_sidebar_ui # Passed from app.R
    ),
    
    # ---- Tabs ----
    nav_panel(.nav_title("Welcome", "home"), value = "welcome_tab", app_page(welcome_ui)),
    
    nav_menu(
      .nav_title("Setup", "gear"),
      value = "setup_menu",
      nav_panel("Environment", value = "environment_tab", app_page(environment_ui))
    ),
    
    nav_menu(
      .nav_title("QC", "filter"),
      value = "qc_menu",
      nav_panel("Hashtag demultiplexing", value = "hto_tab", plotting_page(hto_ui)),
      nav_panel("Threshold QC", value = "qc_tab", plotting_page(qc_ui)),
      nav_panel(wl_alpha_label("Contamination Correction", "hidden"), value = "contam_tab", plotting_page(contamination_correction_ui)),
      nav_panel("Doublet Detection", value = "doublet_tab", plotting_page(doublet_ui)),
      nav_panel("VDJ TCR/BCR", value = "vdj_tab", plotting_page(vdj_ui)),
      nav_panel("I have barcodes", value = "barcode_tab", plotting_page(barcode_ui)),
      nav_panel(wl_beta_label("Flow Gating"), value = "flowgate_tab", plotting_page(flowgate_ui)),
      nav_panel(wl_beta_seurat5_label("ATAC QC"), value = "atac_qc_tab", plotting_page(atac_qc_ui))
    ),
    
    nav_menu(
      .nav_title("Analysis", "chart-line"),
      value = "analysis_menu",
      nav_panel("Main Analysis", value = "analysis_tab", plotting_page(analysis_ui)),
      nav_panel("Re-cluster", value = "recluster_tab", plotting_page(recluster_ui)),
      nav_panel("RNA velocity", value = "rna_velocity_tab", plotting_page(rna_velocity_ui)),
      nav_panel(wl_alpha_label("RNA velocity v0.5.2"), value = "rna_velocity_v052_tab", plotting_page(rna_velocity_v052_ui)),
      nav_panel(wl_beta_seurat5_label("WNN / Multiome Integration"), value = "multiome_wnn_tab", plotting_page(multiome_wnn_ui)),
      nav_panel(wl_beta_seurat5_label("Multiome Marker Explorer"), value = "multiome_marker_tab", plotting_page(multiome_marker_ui)),
      nav_panel(wl_beta_label("CellChat"), value = "cellchat_tab", plotting_page(cellchat_ui)),
      nav_panel(wl_alpha_label("pySCENIC"), value = "scenic_tab", plotting_page(scenic_ui)),
      nav_panel(wl_beta_label("Monocle2"), value = "monocle2_tab", plotting_page(monocle2_ui)),
      nav_panel(wl_alpha_label("NicheNet"), value = "nichenet_tab", plotting_page(nichenet_ui)),
      nav_panel(wl_alpha_label("NICHES"), value = "niches_tab", plotting_page(niches_ui)),
      nav_panel(wl_alpha_label("scTenifoldKnk"), value = "sctenifoldknk_tab", plotting_page(sctenifoldknk_ui)),
      nav_panel(wl_beta_label("CellWhisperer", "admin"), value = "cellwhisperer_tab", plotting_page(cellwhisperer_ui))
    ),
    
    nav_menu(
      .nav_title("Figures", "chart-area"),
      value = "figures_menu",
      nav_panel("UMAP Studio", value = "figure_studio_umap", plotting_page(figure_umap_ui)),
      nav_panel("Feature Plot", value = "figure_studio_feature", plotting_page(figure_feature_ui)),
      nav_panel("Dot Plot", value = "figure_studio_dotplot", plotting_page(figure_dotplot_ui)),
      nav_panel("TCR/BCR Alluvial", value = "figure_studio_alluvial", plotting_page(figure_alluvial_ui)),
      nav_panel("Cluster Alluvial", value = "figure_studio_cluster_alluvial", plotting_page(figure_cluster_alluvial_ui)),
      nav_panel("TCR/BCR Studio", value = "figure_studio_tcr_studio", plotting_page(figure_tcr_studio_ui)),
      nav_panel(wl_alpha_label("Pseudobulk Volcano", "hidden"), value = "figure_studio_pseudobulk_volcano_hidden", plotting_page(figure_pseudobulk_volcano_hidden_ui))
    ),
    
    nav_menu(
      .nav_title("Export", "file-export"),
      value = "export_menu",
      nav_panel("Export", value = "export_tab", app_page(export_ui)),
      nav_panel("VDJ-safe Export", value = "export_vdj_safe_tab", app_page(export_vdj_safe_ui)),
      nav_panel(wl_beta_seurat5_label("Multiome Export Check"), value = "multiome_export_check_tab", app_page(multiome_export_check_ui))
    ),
    nav_panel(.nav_title("Data Browser", "table"), value = "recluster_new_tab", plotting_page(recluster_new_ui)),
    nav_panel(.nav_title("Workspace", "database"), value = "rds_tab", app_page(rds_ui)),
    .nav_spacer_safe(),
    nav_item(actionLink("nav_dark_mode_toggle", .nav_title("Dark mode", "moon"))),
    nav_item(actionLink("nav_help", .nav_title("Help", "question-circle")))
  )
}
