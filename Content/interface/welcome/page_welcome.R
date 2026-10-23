WELCOME_UI_TEXT <- list(
  # Hero block
  ui_text_pipeline_name = "WAN LAB scRNA-SEQ PIPELINE",
  ui_title_main = "Welcome! Let's Explore, Tune, and Make the Most of Single-Cell Datasets!",
  ui_text_main_description = "Run a full <strong>single-cell RNA-seq workflow</strong> with a structured GUI for <strong>environment setup</strong>, <strong>QC</strong>, <strong>analysis</strong>, <strong>visualization</strong>, and <strong>export</strong>. No more waiting days to hear back from <strong>bioinformaticians</strong> for a single parameter change. Take <strong>routine tuning</strong> into your own hands, and keep tighter control of <strong>boundary-sensitive data</strong> without the stress of losing <strong>rare populations</strong> or over-enriching them. Let bioinformaticians focus where they matter most: <strong>advanced analysis</strong> and <strong>figure refinement</strong>. Bring in <strong>public datasets</strong>, adjust them with confidence, and <strong>integrate them whenever inspiration strikes</strong>.",
  ui_text_main_hint = "Start by selecting an analysis environment, then import your data and proceed step-by-step through the pipeline.",
  ui_btn_start_setup = "Start Setting Up",
  ui_btn_fast_loupe = "I just want a Loupe file",
  ui_btn_why_here = "Why am I here, what should I do?",
  ui_modal_fast_caution_title = "Before continuing with manual tuning",
  ui_modal_fast_caution_body = "Manual parameter tuning can take substantial extra effort and may not produce biologically meaningful improvements for many routine datasets.",
  ui_modal_fast_caution_body_2 = "If your goal is to get a Loupe file quickly with default settings, the Fast Version is recommended.",
  ui_modal_fast_btn_use_fast = "Use Fast Version",
  ui_modal_fast_btn_continue_manual = "Continue Manual Setup",
  ui_title_tutorial_modal = "Getting Started Guide",
  ui_text_tutorial_placeholder = "Walkthrough file not found. Add 'Content/interface/welcome/why_am_i_here.md' to show content here.",
  ui_text_tutorial_close = "Close",

  # What's new block
  ui_text_whats_new = " What's New",
  ui_text_no_update_log_hint = "No update log found. Add 'Update Log.txt' in project root to auto-populate this section.",
  ui_text_open_full_update_log = "Open full update log",
  ui_text_update_log_filename = "Update Log.txt",
  ui_text_no_update_log_file_found = "No update log file found.",

  # Quick-start block
  ui_text_quick_start = " Quick Start",
  ui_text_quick_start_flow_hint = "Workflow map: follow directed steps, let automated routing guide you, and use optional modules when needed.",
  ui_text_quick_start_step_1_title = "Choose Seurat Runtime Version",
  ui_text_quick_start_step_1_desc = "Pick Seurat v4 or v5 at setup. Both are supported but not fully cross-compatible in one active run.",
  ui_text_quick_start_step_2_title = "Import Data or Load Workspace",
  ui_text_quick_start_step_2_desc = "Import new data or a saved workspace. Name each sample clearly and include batch plus condition metadata for downstream checks.",
  ui_text_quick_start_step_3_title = "Automatic Sample Detection",
  ui_text_quick_start_step_3_desc = "If hashtag or VDJ files are in the same folder, they are detected, imported, and bundled with the sample automatically.",
  ui_text_quick_start_step_4_title = "Confirm VDJ Matching (If Available)",
  ui_text_quick_start_step_4_desc = "Verify VDJ pairing first when present. You can keep all samples now and decide filtering later during interpretation.",
  ui_text_quick_start_step_5_title = "Hashtag Demultiplexing (If Available)",
  ui_text_quick_start_step_5_desc = "Process hashtag tags as an independent optional step when hashtag libraries are present.",
  ui_text_quick_start_step_6_title = "RNA QC (Or Loupe Barcode Shortcut)",
  ui_text_quick_start_step_6_desc = "Run RNA QC for filtering and quality control. If you already have trusted Loupe barcodes, skipping QC is recommended.",
  ui_text_quick_start_step_7_title = "Normalize, Integrate, and Select Resolution",
  ui_text_quick_start_step_7_desc = "Run normalization and integration, then UMAP and cluster tree. Use DEG plus annotation evidence to choose the best resolution.",
  ui_text_quick_start_step_8_title = "Save Workspace Regularly",
  ui_text_quick_start_step_8_desc = "Save at key checkpoints throughout analysis. Saving takes time but is strongly recommended for recovery and reproducibility.",
  ui_text_quick_start_step_9_title = "Export and Figure Production",
  ui_text_quick_start_step_9_desc = "Export to Loupe or build publication-ready panels in Figure Studio.",
  ui_text_quick_start_step_10_title = "Advanced Analysis (Optional)",
  ui_text_quick_start_step_10_desc = "Extend interpretation with Monocle2 pseudotime, CellChat communication inference, NicheNet/NICHES ligand-receptor analysis, pySCENIC regulon programs, and scTenifoldKnk virtual knockout modeling.",

  # Merged help + welcome guide block
  ui_title_pipeline_guide = " Pipeline Guide Cards",
  ui_text_pipeline_guide_intro = "Beginner-friendly reference for every stage in this app. If you are unsure what to do next, follow the cards in order and treat optional modules as opt-in.",
  ui_text_pipeline_nav_map = "Navigation map: Welcome -> Setup -> QC -> Analysis -> Figures -> Export -> Workspace -> Help (this section).",
  ui_text_pipeline_start_here_title = "Start Here in 3 Steps",
  ui_text_pipeline_start_here_steps = c(
    "Step 1: Setup Environment first, then import data or load workspace.",
    "Step 2: Run Threshold QC, then optional QC modules based on your data type.",
    "Step 3: Complete analysis, build figures, export outputs, and save workspace."
  ),
  ui_text_pipeline_welcome_title = "Welcome",
  ui_text_pipeline_welcome_desc = "Read quick start, tested environments, update log, and open the Why am I here tutorial for deeper context.",
  ui_text_pipeline_setup_title = "Setup: Environment",
  ui_text_pipeline_setup_desc = "Choose Seurat v4 or v5 runtime, confirm environment readiness, then begin imports.",
  ui_text_pipeline_qc_title = "QC Modules",
  ui_text_pipeline_qc_desc = "Threshold QC is the default quality gate before interpretation. Add optional QC modules only when matching assays or metadata are available.",
  ui_text_pipeline_qc_items = c(
    "Hashtag demultiplexing: separate hashtag-tagged samples (HTO/ADT) when available.",
    "Doublet Detection: detect likely multiplets before downstream interpretation.",
    "VDJ TCR/BCR: align receptor information with RNA objects for immune analysis.",
    "I have barcodes: apply trusted external barcodes such as Loupe selections.",
    "Flow Gating (beta): optional gating-style workflow for specific strategies.",
    "ATAC QC (beta, seurat5 only): optional QC for ATAC-aware pipelines."
  ),
  ui_text_pipeline_analysis_title = "Analysis Modules",
  ui_text_pipeline_analysis_desc = "Start with Main Analysis and Re-cluster, then extend to optional advanced modules when needed.",
  ui_text_pipeline_analysis_items = c(
    "Main Analysis: normalize, integrate, cluster, annotate, and review marker evidence.",
    "Re-cluster: subset and refine selected populations with focused parameters.",
    "RNA velocity: estimate directional dynamics when velocity-compatible layers exist.",
    "WNN / Multiome Integration (beta, seurat5 only): integrate RNA + ATAC structure.",
    "Multiome Marker Explorer (beta, seurat5 only): inspect multi-modal marker behavior.",
    "CellChat / pySCENIC / Monocle2 / NicheNet / NICHES / scTenifoldKnk (beta): optional advanced interpretation modules."
  ),
  ui_text_pipeline_figures_title = "Figures Studio",
  ui_text_pipeline_figures_items = c(
    "UMAP Studio: cluster-level embedding views and publication styling.",
    "Feature Plot: gene expression overlays on embeddings.",
    "Dot Plot: marker summaries across groups.",
    "TCR/BCR Alluvial and Cluster Alluvial: transition and composition summaries."
  ),
  ui_text_pipeline_export_title = "Export",
  ui_text_pipeline_export_items = c(
    "Export: standard output route for processed results.",
    "VDJ-safe Export: preserve VDJ-aware structures and matching requirements.",
    "Multiome Export Check (beta, seurat5 only): pre-export consistency checks."
  ),
  ui_text_pipeline_workspace_title = "Workspace",
  ui_text_pipeline_workspace_items = c(
    "Load a saved .rds workspace to continue analysis.",
    "Save at key checkpoints (post-QC, post-integration, pre-export).",
    "Use workspace saves to safely compare alternative parameter choices."
  ),
  ui_text_pipeline_help_title = "How to Use This Section",
  ui_text_pipeline_help_items = c(
    "Move card-by-card in order when starting out.",
    "Skip optional modules that do not match your data.",
    "If results look unusual, revisit QC and resolution choices first."
  ),

  # Tested system environment block
  ui_text_tested_env_title = "This pipeline has been tested and validated under the following system environments:",
  ui_text_tested_env_macos_title = " macOS Tahoe on Apple M-series chips",
  ui_text_tested_env_macos_memory = "64 GB memory",
  ui_text_tested_env_macos_storage = "150 GB storage",
  ui_text_tested_env_macos_r = "R 4.4.3",
  ui_text_tested_env_macos_note = "Note: R 4.5 and above are not supported yet.",
  ui_text_tested_env_windows_title = " Windows 11 ARM via virtual machine",
  ui_text_tested_env_windows_memory = "4 GB and 52 GB memory",
  ui_text_tested_env_windows_storage = "50 GB storage",
  ui_text_tested_env_windows_r = "R 4.4.3",
  ui_text_tested_env_windows_note = "Note: For ARM builds, R 4.5 and above are not supported yet.",

  # Credits block
  ui_text_credits = "Credits",
  ui_text_credit_built_with = "Built with: R, Seurat, Shiny. For detailed package usage, please check sessionInfo().",
  ui_text_credit_version = "Version: %s",
  ui_text_credit_codex_note = "Developed with support from Codex powered by ChatGPT, Antigravity by Gemini, and Cursor.\nPlease cross-check key results in the app using multiple methods for best accuracy.\nIf discrepancies beyond package-version differences are observed, please contact the author immediately to protect analysis integrity.",
  ui_text_credit_use_policy = "Original code is licensed under GNU GPL v3. Third-party components retain their own licenses."
)

library(shiny)

welcome_app_version <- get0("APP_VERSION", inherits = TRUE, ifnotfound = NA_character_)
welcome_app_version_label <- if (is.na(welcome_app_version) || !nzchar(welcome_app_version)) "NA" else welcome_app_version
.welcome_guide_section_card <- function(title, icon_name, subtitle = NULL, ...) {
  subtitle_ui <- NULL
  if (!is.null(subtitle)) {
    if (is.character(subtitle) && length(subtitle) == 1 && nzchar(subtitle)) {
      subtitle_ui <- p(class = "welcome-guide-subtitle", subtitle)
    } else if (inherits(subtitle, "shiny.tag") || inherits(subtitle, "shiny.tag.list")) {
      subtitle_ui <- subtitle
    }
  }

  div(
    class = "card welcome-block welcome-guide-card",
    div(class = "welcome-block-title", icon(icon_name), title),
    subtitle_ui,
    ...
  )
}

.welcome_quickstart_compact_modal <- function() {
  steps <- Map(
    function(title, desc) {
      tags$li(
        tags$div(class = "welcome-quickstep-title", title),
        tags$div(class = "welcome-quickstep-desc", desc)
      )
    },
    list(
      WELCOME_UI_TEXT$ui_text_quick_start_step_1_title,
      WELCOME_UI_TEXT$ui_text_quick_start_step_2_title,
      WELCOME_UI_TEXT$ui_text_quick_start_step_3_title,
      WELCOME_UI_TEXT$ui_text_quick_start_step_4_title,
      WELCOME_UI_TEXT$ui_text_quick_start_step_5_title,
      WELCOME_UI_TEXT$ui_text_quick_start_step_6_title,
      WELCOME_UI_TEXT$ui_text_quick_start_step_7_title,
      WELCOME_UI_TEXT$ui_text_quick_start_step_8_title,
      WELCOME_UI_TEXT$ui_text_quick_start_step_9_title,
      WELCOME_UI_TEXT$ui_text_quick_start_step_10_title
    ),
    list(
      WELCOME_UI_TEXT$ui_text_quick_start_step_1_desc,
      WELCOME_UI_TEXT$ui_text_quick_start_step_2_desc,
      WELCOME_UI_TEXT$ui_text_quick_start_step_3_desc,
      WELCOME_UI_TEXT$ui_text_quick_start_step_4_desc,
      WELCOME_UI_TEXT$ui_text_quick_start_step_5_desc,
      WELCOME_UI_TEXT$ui_text_quick_start_step_6_desc,
      WELCOME_UI_TEXT$ui_text_quick_start_step_7_desc,
      WELCOME_UI_TEXT$ui_text_quick_start_step_8_desc,
      WELCOME_UI_TEXT$ui_text_quick_start_step_9_desc,
      WELCOME_UI_TEXT$ui_text_quick_start_step_10_desc
    )
  )

  tagList(
    tags$style(HTML("
      .welcome-manual-caution-wrap {
        max-height: 68vh;
        overflow-y: auto;
        overflow-x: visible;
        padding-left: 8px;
        padding-right: 4px;
      }
      .welcome-manual-caution-note { margin-bottom: 10px; }
      .welcome-manual-caution-steps {
        column-count: 2;
        column-gap: 16px;
        margin: 0;
        padding-left: 28px;
        list-style-position: outside;
      }
      .welcome-manual-caution-steps li {
        break-inside: avoid;
        margin: 0 0 8px 0;
      }
      .welcome-quickstep-title {
        font-weight: 700;
        font-size: 12px;
        line-height: 1.25;
        color: #1f2937;
        margin-bottom: 2px;
      }
      .welcome-quickstep-desc {
        font-size: 11px;
        line-height: 1.3;
        color: #4b5563;
      }
      @media (max-width: 900px) {
        .welcome-manual-caution-steps { column-count: 1; }
      }
    ")),
    div(
      class = "welcome-manual-caution-wrap",
      p(class = "welcome-manual-caution-note", WELCOME_UI_TEXT$ui_modal_fast_caution_body),
      p(class = "welcome-manual-caution-note", WELCOME_UI_TEXT$ui_modal_fast_caution_body_2),
      tags$div(class = "welcome-block-title", icon("sitemap"), WELCOME_UI_TEXT$ui_text_quick_start),
      tags$ol(class = "welcome-manual-caution-steps", steps)
    )
  )
}

welcome_help_modal_ui <- div(
  class = "welcome-page-wrap",
  div(
    class = "card welcome-block welcome-guide-card",
    div(class = "welcome-block-title", icon("book"), WELCOME_UI_TEXT$ui_title_pipeline_guide),
    p(class = "welcome-guide-subtitle", WELCOME_UI_TEXT$ui_text_pipeline_guide_intro),
    p(class = "welcome-guide-map", WELCOME_UI_TEXT$ui_text_pipeline_nav_map)
  ),
  fluidRow(
    class = "welcome-row-single welcome-guide-wrap",
    column(
      width = 6,
      class = "welcome-card-col",
      .welcome_guide_section_card(
        WELCOME_UI_TEXT$ui_text_pipeline_start_here_title,
        "play-circle",
        tags$ul(
          class = "welcome-guide-list",
          lapply(WELCOME_UI_TEXT$ui_text_pipeline_start_here_steps, tags$li)
        )
      )
    ),
    column(
      width = 12,
      class = "welcome-card-col",
      .welcome_guide_section_card(
        WELCOME_UI_TEXT$ui_text_pipeline_qc_title,
        "check-square",
        WELCOME_UI_TEXT$ui_text_pipeline_qc_desc,
        tags$ul(
          class = "welcome-guide-list",
          lapply(WELCOME_UI_TEXT$ui_text_pipeline_qc_items, tags$li)
        )
      )
    ),
    column(
      width = 12,
      class = "welcome-card-col",
      .welcome_guide_section_card(
        WELCOME_UI_TEXT$ui_text_pipeline_analysis_title,
        "flask",
        WELCOME_UI_TEXT$ui_text_pipeline_analysis_desc,
        tags$ul(
          class = "welcome-guide-list",
          lapply(WELCOME_UI_TEXT$ui_text_pipeline_analysis_items, tags$li)
        )
      )
    ),
    column(
      width = 6,
      class = "welcome-card-col",
      .welcome_guide_section_card(
        WELCOME_UI_TEXT$ui_text_pipeline_figures_title,
        "image",
        tags$ul(
          class = "welcome-guide-list",
          lapply(WELCOME_UI_TEXT$ui_text_pipeline_figures_items, tags$li)
        )
      )
    ),
    column(
      width = 6,
      class = "welcome-card-col",
      .welcome_guide_section_card(
        WELCOME_UI_TEXT$ui_text_pipeline_export_title,
        "download",
        tags$ul(
          class = "welcome-guide-list",
          lapply(WELCOME_UI_TEXT$ui_text_pipeline_export_items, tags$li)
        )
      )
    ),
    column(
      width = 12,
      class = "welcome-card-col",
      .welcome_guide_section_card(
        WELCOME_UI_TEXT$ui_text_pipeline_workspace_title,
        "save",
        tags$ul(
          class = "welcome-guide-list",
          lapply(WELCOME_UI_TEXT$ui_text_pipeline_workspace_items, tags$li)
        )
      )
    )
  )
)

welcome_ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .welcome-page-wrap{
        display: flex;
        flex-direction: column;
        align-items: flex-start;
      }

      .welcome-hero-shell{
        display: block;
        width: auto;
        max-width: 100%;
        margin-left: 0;
        margin-right: 0;
      }

      .welcome-hero-card{
        display: block;
        width: 100% !important;
        min-width: 0;
        color: #374151;
        box-shadow: 0 6px 18px rgba(15, 23, 42, 0.08), 0 1px 3px rgba(15, 23, 42, 0.06);
      }

      .welcome-title{
        display: block;
        max-width: none;
        white-space: nowrap;
      }

      .welcome-lead{
        line-height: 1.35;
        color: #374151;
        margin: 0 0 0.75rem 0;
        padding-left: 1.1rem;
      }

      .welcome-block{
        box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06), 0 1px 3px rgba(15, 23, 42, 0.05);
      }

      .welcome-row-single{
        width: 100%;
      }

      .welcome-card-col{
        float: none;
        margin-left: 0;
        margin-right: 0;
      }

      .welcome-quickstart-block{
        min-height: 0;
      }

      .welcome-updates-block{
        min-height: 0;
      }

      .welcome-env-block{
        min-height: 0;
        background: #f8fafc;
      }

      .welcome-env-title{
        margin: 0 0 12px 0;
        font-size: 0.95rem;
        font-weight: 700;
        color: #1f2937;
      }

      .welcome-env-shell{
        display: flex;
        align-items: stretch;
        gap: 14px;
      }

      .welcome-env-col{
        flex: 1 1 0;
        min-width: 0;
      }

      .welcome-env-col-title{
        margin: 0 0 6px 0;
        font-size: 0.88rem;
        font-weight: 700;
        color: #111827;
      }

      .welcome-env-list{
        margin: 0;
        padding-left: 1.1rem;
        color: #374151;
        line-height: 1.35;
      }

      .welcome-env-list li{
        margin: 0.12rem 0;
      }

      .welcome-env-note{
        font-weight: 700;
        color: #7f1d1d;
      }

      .welcome-env-separator{
        width: 1px;
        background: #d1d5db;
      }

      .welcome-flow-hint{
        margin: 0 0 8px 0;
        font-size: 0.76rem;
        color: #4b5563;
      }

      .welcome-flowchart{
        display: flex;
        flex-wrap: wrap;
        align-items: stretch;
        gap: 6px;
      }

      .welcome-flow-step{
        flex: 1 1 250px;
        min-width: 220px;
        border: none;
        border-radius: 10px;
        padding: 7px 9px;
        background: #f3f4f6;
      }

      .welcome-flow-step-title{
        margin: 0 0 4px 0;
        font-size: 0.82rem;
        color: #1f2937;
        font-weight: 700;
        line-height: 1.2;
      }

      .welcome-flow-step-desc{
        margin: 0;
        font-size: 0.72rem;
        color: #6b7280;
        line-height: 1.25;
      }

      .welcome-flow-arrow{
        display: flex;
        align-items: center;
        justify-content: center;
        color: #93a4b8;
        font-size: 0.9rem;
        font-weight: 700;
        min-width: 14px;
      }

      .welcome-flow-badges{
        margin: 0 0 6px 0;
      }

      .welcome-flow-badge{
        display: inline-block;
        margin: 0 5px 3px 0;
        padding: 1px 7px;
        border-radius: 999px;
        font-size: 0.68rem;
        font-weight: 700;
        letter-spacing: 0.01em;
      }

      .welcome-flow-badge-directed{
        color: #1d4f86;
        background: #dbeafe;
      }

      .welcome-flow-badge-automated{
        color: #05543a;
        background: #d1fae5;
      }

      .welcome-flow-badge-optional{
        color: #8a4b08;
        background: #ffedd5;
      }

      .welcome-flow-badge-save{
        color: #7b2f66;
        background: #fae8ff;
      }

      .welcome-flow-step-directed{
        background: #dbeafe;
      }

      .welcome-flow-step-directed .welcome-flow-step-title{
        color: #1d4f86;
      }

      .welcome-flow-step-directed .welcome-flow-step-desc{
        color: #355e8f;
      }

      .welcome-flow-step-automated{
        background: #d1fae5;
      }

      .welcome-flow-step-automated .welcome-flow-step-title{
        color: #05543a;
      }

      .welcome-flow-step-automated .welcome-flow-step-desc{
        color: #2e6e5a;
      }

      .welcome-flow-step-optional{
        background: #ffedd5;
      }

      .welcome-flow-step-optional .welcome-flow-step-title{
        color: #8a4b08;
      }

      .welcome-flow-step-optional .welcome-flow-step-desc{
        color: #9b6a37;
      }

      .welcome-flow-step-save{
        background: #fae8ff;
      }

      .welcome-flow-step-save .welcome-flow-step-title{
        color: #7b2f66;
      }

      .welcome-flow-step-save .welcome-flow-step-desc{
        color: #8d5b80;
      }

      .welcome-guide-wrap{
        width: 100%;
      }

      .welcome-guide-card{
        min-height: 0;
      }

      .welcome-guide-subtitle{
        margin: 0 0 8px 0;
        color: #475569;
        font-size: 0.86rem;
        line-height: 1.34;
      }

      .welcome-guide-list{
        margin: 0;
        padding-left: 1.15rem;
        color: #334155;
        line-height: 1.35;
      }

      .welcome-guide-list li{
        margin: 0 0 4px 0;
      }

      .welcome-guide-map{
        margin: 0;
        color: #334155;
        font-size: 0.86rem;
        line-height: 1.34;
      }

      .welcome-lead li{
        margin: 0.1rem 0;
      }

      .welcome-lead li::marker{
        color: #9ca3af;
      }

      @media (max-width: 900px){
        .welcome-hero-shell{
          max-width: calc(100vw - 32px);
        }
        .welcome-title{
          white-space: normal;
        }
        .welcome-flow-step{
          flex: 1 1 100%;
          min-width: 0;
        }
        .welcome-flow-arrow{
          width: 100%;
          min-height: 10px;
          transform: rotate(90deg);
        }
        .welcome-env-shell{
          flex-direction: column;
          gap: 10px;
        }
        .welcome-env-separator{
          width: 100%;
          height: 1px;
        }
      }
    ")),
    tags$script(HTML("
      (function() {
        function textWidthLike(el, text) {
          if (!el) return 0;
          var cs = window.getComputedStyle(el);
          var canvas = textWidthLike._canvas || (textWidthLike._canvas = document.createElement('canvas'));
          var ctx = canvas.getContext('2d');
          if (!ctx) return 0;
          var font = [
            cs.fontStyle || 'normal',
            cs.fontVariant || 'normal',
            cs.fontWeight || '400',
            cs.fontSize || '16px',
            cs.fontFamily || 'sans-serif'
          ].join(' ');
          ctx.font = font;
          return Math.ceil(ctx.measureText(String(text || '')).width || 0);
        }

        function resizeWelcomeHeroByTitle() {
          var shell = document.querySelector('.welcome-hero-shell');
          var card = document.querySelector('.welcome-hero-card');
          var title = document.querySelector('.welcome-title');
          if (!shell || !card || !title) return;

          var parent = shell.parentElement || shell;
          var parentRect = parent.getBoundingClientRect();
          var avail = Math.floor(parentRect.width || 0);
          if (!isFinite(avail) || avail <= 0) return;

          var titleTxt = (title.textContent || '').trim();
          var titleW = textWidthLike(title, titleTxt);
          var twoWordW = Math.max(
            textWidthLike(title, ' workflow dataset'),
            textWidthLike(title, ' single-cell dataset'),
            180
          );

          var cardPad = 44; // card horizontal padding + border buffer
          var target = titleW + twoWordW + cardPad;
          var maxW = Math.max(320, avail - 10); // keep < full remaining width
          var nextW = Math.min(target, maxW);

          shell.style.width = nextW + 'px';
          shell.style.maxWidth = maxW + 'px';
          card.style.width = '100%';
        }

        function bindWelcomeHeroResize() {
          resizeWelcomeHeroByTitle();
          var shell = document.querySelector('.welcome-hero-shell');
          if (!shell || shell.__wlHeroBound) return;
          shell.__wlHeroBound = true;

          if (typeof ResizeObserver !== 'undefined') {
            var ro = new ResizeObserver(function() { resizeWelcomeHeroByTitle(); });
            try { ro.observe(document.body); } catch (e) {}
            try { ro.observe(shell.parentElement || shell); } catch (e) {}
            shell.__wlHeroRO = ro;
          }

          window.addEventListener('resize', resizeWelcomeHeroByTitle);
          setTimeout(resizeWelcomeHeroByTitle, 60);
          setTimeout(resizeWelcomeHeroByTitle, 250);
        }

        document.addEventListener('DOMContentLoaded', bindWelcomeHeroResize);
        window.addEventListener('load', bindWelcomeHeroResize);
      })();
    "))
  ),
  div(
    class = "welcome-page-wrap",

    div(
      class = "welcome-hero-shell",
      div(
        class = "card welcome-hero-card",
        div(class = "welcome-eyebrow", WELCOME_UI_TEXT$ui_text_pipeline_name),
        h2(class = "welcome-title", WELCOME_UI_TEXT$ui_title_main),
        tags$ul(
          class = "welcome-lead",
          lapply(
            strsplit(WELCOME_UI_TEXT$ui_text_main_description, "(?<=\\.)\\s+", perl = TRUE)[[1]],
            function(line) tags$li(HTML(line))
          )
        ),
        div(
          class = "welcome-cta-row",
          actionButton(
            "to_environment_page_btn",
            label = WELCOME_UI_TEXT$ui_btn_start_setup,
            icon = icon("play"),
            class = "btn-primary btn-lg welcome-btn-start"
          ),
          actionButton(
            "start_fast_loupe_btn",
            label = WELCOME_UI_TEXT$ui_btn_fast_loupe,
            icon = icon("bolt"),
            class = "btn-info btn-lg"
          ),
          actionLink(
            "open_welcome_tutorial_modal_btn",
            label = tagList(icon("question-circle"), WELCOME_UI_TEXT$ui_btn_why_here),
            class = "welcome-link-why"
          )
        ),
        p(
          class = "welcome-sublead",
          WELCOME_UI_TEXT$ui_text_main_hint
        )
      )
    ),

    fluidRow(
      class = "welcome-row-single",
      column(
        width = 12,
        class = "welcome-card-col",
        div(
          class = "card welcome-block welcome-updates-block",
          div(class = "welcome-block-title", icon("lightbulb"), WELCOME_UI_TEXT$ui_text_whats_new),
          uiOutput("welcome_whats_new_ui"),
          uiOutput("welcome_update_log_link_ui")
        )
      )
    ),

    fluidRow(
      class = "welcome-row-single welcome-guide-wrap",
      column(
        width = 12,
        class = "welcome-card-col",
        .welcome_guide_section_card(
          WELCOME_UI_TEXT$ui_title_pipeline_guide,
          "book",
          WELCOME_UI_TEXT$ui_text_pipeline_guide_intro,
          p(class = "welcome-guide-map", WELCOME_UI_TEXT$ui_text_pipeline_nav_map)
        )
      ),
      column(
        width = 6,
        class = "welcome-card-col",
        .welcome_guide_section_card(
          WELCOME_UI_TEXT$ui_text_pipeline_start_here_title,
          "play-circle",
          tags$ul(
            class = "welcome-guide-list",
            lapply(WELCOME_UI_TEXT$ui_text_pipeline_start_here_steps, tags$li)
          )
        )
      ),
      column(
        width = 6,
        class = "welcome-card-col",
        .welcome_guide_section_card(
          WELCOME_UI_TEXT$ui_text_pipeline_welcome_title,
          "home",
          WELCOME_UI_TEXT$ui_text_pipeline_welcome_desc
        )
      ),
      column(
        width = 6,
        class = "welcome-card-col",
        .welcome_guide_section_card(
          WELCOME_UI_TEXT$ui_text_pipeline_setup_title,
          "cogs",
          WELCOME_UI_TEXT$ui_text_pipeline_setup_desc
        )
      ),
      column(
        width = 12,
        class = "welcome-card-col",
        .welcome_guide_section_card(
          WELCOME_UI_TEXT$ui_text_pipeline_qc_title,
          "check-square",
          WELCOME_UI_TEXT$ui_text_pipeline_qc_desc,
          tags$ul(
            class = "welcome-guide-list",
            lapply(WELCOME_UI_TEXT$ui_text_pipeline_qc_items, tags$li)
          )
        )
      ),
      column(
        width = 12,
        class = "welcome-card-col",
        .welcome_guide_section_card(
          WELCOME_UI_TEXT$ui_text_pipeline_analysis_title,
          "flask",
          WELCOME_UI_TEXT$ui_text_pipeline_analysis_desc,
          tags$ul(
            class = "welcome-guide-list",
            lapply(WELCOME_UI_TEXT$ui_text_pipeline_analysis_items, tags$li)
          )
        )
      ),
      column(
        width = 6,
        class = "welcome-card-col",
        .welcome_guide_section_card(
          WELCOME_UI_TEXT$ui_text_pipeline_figures_title,
          "image",
          tags$ul(
            class = "welcome-guide-list",
            lapply(WELCOME_UI_TEXT$ui_text_pipeline_figures_items, tags$li)
          )
        )
      ),
      column(
        width = 6,
        class = "welcome-card-col",
        .welcome_guide_section_card(
          WELCOME_UI_TEXT$ui_text_pipeline_export_title,
          "download",
          tags$ul(
            class = "welcome-guide-list",
            lapply(WELCOME_UI_TEXT$ui_text_pipeline_export_items, tags$li)
          )
        )
      ),
      column(
        width = 12,
        class = "welcome-card-col",
        .welcome_guide_section_card(
          WELCOME_UI_TEXT$ui_text_pipeline_workspace_title,
          "save",
          tags$ul(
            class = "welcome-guide-list",
            lapply(WELCOME_UI_TEXT$ui_text_pipeline_workspace_items, tags$li)
          )
        )
      )
    ),
    fluidRow(
      class = "welcome-row-single",
      column(
        width = 12,
        class = "welcome-card-col",
        div(
          class = "card welcome-block welcome-env-block",
          p(class = "welcome-env-title", WELCOME_UI_TEXT$ui_text_tested_env_title),
          div(
            class = "welcome-env-shell",
            div(
              class = "welcome-env-col",
              p(class = "welcome-env-col-title", icon("apple"), WELCOME_UI_TEXT$ui_text_tested_env_macos_title),
              tags$ul(
                class = "welcome-env-list",
                tags$li(WELCOME_UI_TEXT$ui_text_tested_env_macos_memory),
                tags$li(WELCOME_UI_TEXT$ui_text_tested_env_macos_storage),
                tags$li(WELCOME_UI_TEXT$ui_text_tested_env_macos_r),
                tags$li(span(class = "welcome-env-note", WELCOME_UI_TEXT$ui_text_tested_env_macos_note))
              )
            ),
            div(class = "welcome-env-separator"),
            div(
              class = "welcome-env-col",
              p(class = "welcome-env-col-title", icon("windows"), WELCOME_UI_TEXT$ui_text_tested_env_windows_title),
              tags$ul(
                class = "welcome-env-list",
                tags$li(WELCOME_UI_TEXT$ui_text_tested_env_windows_memory),
                tags$li(WELCOME_UI_TEXT$ui_text_tested_env_windows_storage),
                tags$li(WELCOME_UI_TEXT$ui_text_tested_env_windows_r),
                tags$li(span(class = "welcome-env-note", WELCOME_UI_TEXT$ui_text_tested_env_windows_note))
              )
            )
          )
        )
      )
    ),

    div(
      class = "welcome-credits",
      div(class = "welcome-credits-title", WELCOME_UI_TEXT$ui_text_credits),
      div(class = "welcome-credits-line", WELCOME_UI_TEXT$ui_text_credit_built_with),
      div(class = "welcome-credits-line", sprintf(WELCOME_UI_TEXT$ui_text_credit_version, welcome_app_version_label)),
      div(class = "welcome-credits-line welcome-credits-note", WELCOME_UI_TEXT$ui_text_credit_codex_note),
      div(class = "welcome-credits-line welcome-credits-note", HTML(WELCOME_UI_TEXT$ui_text_credit_use_policy))
    )
  )
)

welcome_server <- function(input, output, session, shared_data = NULL) {
  update_log_path <- reactiveVal(NULL)

  .find_tutorial_markdown_path <- function() {
    project_root <- normalizePath(file.path(getwd(), ".."), mustWork = FALSE)

    candidates <- c(
      getOption("shiny_welcome_tutorial_path", default = ""),
      Sys.getenv("SHINY_WELCOME_TUTORIAL_PATH", unset = ""),
      file.path(getwd(), "interface", "welcome", "why_am_i_here.md"),
      file.path(getwd(), "Content", "interface", "welcome", "why_am_i_here.md"),
      file.path(project_root, "Content", "interface", "welcome", "why_am_i_here.md")
    )

    candidates <- unique(candidates[nzchar(candidates)])
    existing <- candidates[file.exists(candidates)]
    if (!length(existing)) return(NULL)
    normalizePath(existing[[1]], mustWork = FALSE)
  }

  .render_tutorial_markdown <- function(path) {
    if (is.null(path) || !file.exists(path)) {
      return(
        div(
          class = "welcome-empty-note",
          WELCOME_UI_TEXT$ui_text_tutorial_placeholder
        )
      )
    }

    rendered <- tryCatch(
      shiny::includeMarkdown(path),
      error = function(e) NULL
    )

    if (!is.null(rendered)) return(rendered)

    lines <- tryCatch(
      readLines(path, warn = FALSE, encoding = "UTF-8"),
      error = function(e) character(0)
    )

    if (!length(lines)) {
      return(
        div(
          class = "welcome-empty-note",
          WELCOME_UI_TEXT$ui_text_tutorial_placeholder
        )
      )
    }

    tags$pre(paste(lines, collapse = "\n"))
  }

  .find_update_log_path <- function() {
    project_root <- normalizePath(file.path(getwd(), ".."), mustWork = FALSE)

    candidates <- c(
      getOption("shiny_update_log_path", default = ""),
      Sys.getenv("SHINY_UPDATE_LOG_PATH", unset = ""),
      file.path(project_root, "Update Log.txt"),
      file.path(project_root, "UPDATE_LOG.txt"),
      file.path(project_root, "update_log.txt"),
      file.path(project_root, "CHANGELOG.txt"),
      file.path(project_root, "changelog.txt")
    )

    candidates <- unique(candidates[nzchar(candidates)])
    existing <- candidates[file.exists(candidates)]
    if (!length(existing)) return(NULL)
    existing[[1]]
  }

  .extract_latest_block <- function(lines) {
    if (!length(lines)) return(character(0))

    lines <- gsub("\\r", "", lines)
    lines <- trimws(lines, which = "right")

    # drop leading/trailing empty lines
    while (length(lines) && !nzchar(trimws(lines[[1]]))) lines <- lines[-1]
    while (length(lines) && !nzchar(trimws(lines[[length(lines)]]))) lines <- lines[-length(lines)]
    if (!length(lines)) return(character(0))

    # Strategy 1: newest section starts at first version/date header
    header_idx <- which(grepl(
      "^(v(ersion)?\\s*\\d|\\[?v\\d|\\d{4}[-/]\\d{1,2}[-/]\\d{1,2}|\\d{1,2}[-/]\\d{1,2}[-/]\\d{2,4})",
      tolower(trimws(lines)),
      perl = TRUE
    ))

    if (length(header_idx)) {
      start <- header_idx[[1]]
      end <- if (length(header_idx) > 1) header_idx[[2]] - 1 else length(lines)
      block <- lines[start:end]
    } else {
      # Strategy 2: fallback to first paragraph block (separated by blank lines)
      text <- paste(lines, collapse = "\n")
      chunks <- strsplit(text, "\\n\\s*\\n+", perl = TRUE)[[1]]
      chunks <- trimws(chunks)
      chunks <- chunks[nzchar(chunks)]
      if (!length(chunks)) return(character(0))
      block <- strsplit(chunks[[1]], "\\n", fixed = FALSE)[[1]]
    }

    block <- trimws(block)
    block <- block[nzchar(block)]

    # Keep concise latest block preview.
    if (length(block) > 20) block <- block[1:20]
    block
  }

  .read_latest_update_block <- function() {
    path <- .find_update_log_path()
    if (is.null(path) || !file.exists(path)) {
      return(list(path = NULL, lines = character(0)))
    }

    lines <- tryCatch(
      readLines(path, warn = FALSE, encoding = "UTF-8"),
      error = function(e) character(0)
    )

    list(path = path, lines = .extract_latest_block(lines))
  }

  output$welcome_whats_new_ui <- renderUI({
    dat <- .read_latest_update_block()
    update_log_path(dat$path)

    if (!length(dat$lines)) {
      return(
        div(
          class = "welcome-empty-note",
          WELCOME_UI_TEXT$ui_text_no_update_log_hint
        )
      )
    }

    items <- lapply(dat$lines, function(line) {
      cleaned <- sub("^[*-]\\s*", "", line)
      tags$li(cleaned)
    })

    tags$ul(class = "welcome-update-list", items)
  })

  output$welcome_update_log_link_ui <- renderUI({
    path <- update_log_path()
    if (is.null(path) || !file.exists(path)) return(NULL)

    div(
      class = "welcome-update-link",
      icon("file-lines"),
      " ",
      downloadLink("welcome_download_update_log", WELCOME_UI_TEXT$ui_text_open_full_update_log)
    )
  })

  output$welcome_download_update_log <- downloadHandler(
    filename = function() {
      path <- update_log_path()
      if (is.null(path)) WELCOME_UI_TEXT$ui_text_update_log_filename else basename(path)
    },
    content = function(file) {
      path <- update_log_path()
      if (is.null(path) || !file.exists(path)) {
        writeLines(WELCOME_UI_TEXT$ui_text_no_update_log_file_found, file)
      } else {
        file.copy(path, file, overwrite = TRUE)
      }
    },
    contentType = "text/plain"
  )

  .start_fast_mode <- function() {
    if (is.null(shared_data)) return(invisible(NULL))
    existing <- shared_data$all_seurat_objects %||% list()
    shared_data$workflow_mode <- "fast"
    shared_data$fast_loupe <- list(
      run_id = as.integer((shared_data$fast_loupe$run_id %||% 0L) + 1L),
      status = "running",
      phase = "waiting_env",
      started_at = Sys.time(),
      baseline_names = names(existing %||% list()) %||% character(0),
      imported_names = character(0),
      message = "Fast Loupe workflow started from Welcome page.",
      error = NULL
    )
  }

  observeEvent(input$to_environment_page_btn, {
    showModal(modalDialog(
      title = WELCOME_UI_TEXT$ui_modal_fast_caution_title,
      size = "l",
      easyClose = TRUE,
      footer = tagList(
        modalButton("Cancel"),
        actionButton("caution_continue_manual_btn", WELCOME_UI_TEXT$ui_modal_fast_btn_continue_manual, class = "btn-warning"),
                  actionButton("caution_use_fast_btn", WELCOME_UI_TEXT$ui_modal_fast_btn_use_fast, class = "btn-info")
      ),
      .welcome_quickstart_compact_modal()
    ))
  })

  observeEvent(input$caution_continue_manual_btn, {
    removeModal()
    if (!is.null(shared_data)) {
      shared_data$workflow_mode <- "manual"
    }
    updateNavbarPage(session, inputId = "main_navbar", selected = "environment_tab")
  }, ignoreInit = TRUE)

  observeEvent(input$start_fast_loupe_btn, {
    .start_fast_mode()
  }, ignoreInit = TRUE)

  observeEvent(input$caution_use_fast_btn, {
    removeModal()
    .start_fast_mode()
  })

  output$welcome_tutorial_modal_content_ui <- renderUI({
    path <- .find_tutorial_markdown_path()
    .render_tutorial_markdown(path)
  })

  observeEvent(input$open_welcome_tutorial_modal_btn, {
    showModal(
      modalDialog(
        title = WELCOME_UI_TEXT$ui_title_tutorial_modal,
        size = "l",
        easyClose = TRUE,
        footer = modalButton(WELCOME_UI_TEXT$ui_text_tutorial_close),
        div(
          id = "welcome_tutorial_modal_content",
          class = "welcome-tutorial-modal-content",
          uiOutput("welcome_tutorial_modal_content_ui")
        )
      )
    )
  })

}
