# UI Inventory (from `repomix-ui-context-small.md`)

## 1. App structure
- Main entrypoint: `app.R` (primary), `run.R` (launcher/bootstrapping wrapper).
- Major UI directories:
  - `interface/` (page modules + shared helpers)
  - `www/` (CSS + JS assets)
- Major UI pages/modules:
  - `interface/welcome/`
  - `interface/setup/`
  - `interface/qc/`
  - `interface/analysis/`
  - `interface/figures/`
  - `interface/export/`
  - `interface/workspace/`
- Shared components:
  - `interface/components/component_navbar.R`
  - `interface/components/component_right_sidebar.R`
  - `interface/components/component_footer.R`
  - `interface/shared/*` (card, spinner, plot, modal, helper utilities)

## 2. Navigation / page inventory
| Page or section | File | Main purpose | Main inputs, if obvious | Main outputs, if obvious | UI complexity |
|---|---|---|---|---|---|
| App shell | `app.R` | Assembles navbar, right sidebar, footer, page wiring | `main_navbar`, sidebar controls | Page switching, modal/overlay triggers | High |
| Welcome | `interface/welcome/page_welcome.R` | Landing and onboarding view | Buttons, start actions | Navigation into setup/QC/analysis | Medium |
| Environment setup | `interface/setup/page_environment.R` | Environment/package readiness UI | Action buttons, status checks | Environment status panels | Medium |
| QC main | `interface/qc/page_qc.R` | Threshold QC controls and plots | Multiple `selectInput`, `checkboxInput`, `actionButton` | QC plots/tables | High |
| HTO demux | `interface/qc/page_hto.R` | Hashtag demultiplexing UI | HTO controls, run actions | HTO plots/tables | High |
| Doublet | `interface/qc/page_doublet.R` | Doublet detection controls | Run/config controls | Doublet outputs/plots | Medium |
| VDJ | `interface/qc/page_vdj.R` | VDJ analysis page UI | Selection controls, actions | VDJ visual outputs | High |
| Barcode/Flow/ATAC QC | `interface/qc/page_barcodes.R`, `page_flowgate.R`, `page_atac_qc.R` | Specialized QC workflows | Upload/select/run controls | Tables/plots | Medium |
| Main analysis | `interface/analysis/page_analysis.R` | Central analysis workspace | Many selectors, radio groups, buttons, file inputs | Multiple plots + DT tables | High |
| Data browser | `interface/analysis/page_data_browser.R`, `page_data_browser_new.R` | Object/data browsing and metadata views | Object/sample selectors | Tables, summary panels | High |
| Recluster | `interface/analysis/page_recluster.R` | Re-clustering workflow UI | Import/select/run actions | Scatter/UMAP outputs | High |
| Analysis add-ons | `interface/analysis/page_cellchat.R`, `page_monocle2.R`, `page_nichenet.R`, `page_niches.R`, `page_rna_velocity*.R`, `page_scenic.R`, `page_sctenifoldknk.R`, `page_multiome_*` | Specialized analysis extensions | Tool-specific controls | Tool-specific plots/tables | Medium-High |
| Figure studio | `interface/figures/page_figure_*.R` | Figure generation/editing UIs | Plot/format/annotation controls | Figure plots + export actions | High |
| Export | `interface/export/page_export.R`, `page_export_vdj_safe.R`, `page_multiome_export_check.R` | Export workflows and checks | Format/select/download controls | Export bundles/files | Medium |
| Workspace (.rds) | `interface/workspace/page_rds.R` | Workspace import/export controls | File inputs + export actions | Bundle/download/report UI | High |

## 3. Shared UI components
- Navbar:
  - `interface/components/component_navbar.R`
- Right sidebar:
  - `interface/components/component_right_sidebar.R`
  - `interface/components/right_sidebar_registry_helpers.R`
- Footer:
  - `interface/components/component_footer.R`
- Shared UI primitives/helpers:
  - `interface/shared/card_page_template.R`
  - `interface/shared/plot_card_state_helpers.R`
  - `interface/shared/spinner_overlay.R`
  - `interface/shared/qc_busy_spinner.R`
  - `interface/shared/shared_pdf_export_modal.R`
  - `interface/shared/code_block_helpers.R`
  - `interface/shared/beta_badge_helpers.R`
  - `interface/shared/beta_result_object_controls.R`
  - `interface/shared/admin_tab_registry.R`

## 4. Styling and assets
- CSS in context:
  - `www/custom_bslib.css`
  - `www/global.css`
  - `www/navbar.css`
  - `www/footer.css`
  - `www/qc.css`
  - `www/css/curve-color-picker.css`
  - `www/css/motion-color-picker.css`
- JS in context:
  - `www/js/poline-lab-runtime.js`
- Most important for visual consistency:
  - `www/custom_bslib.css` (broad layout/tokens/card/sidebar behavior)
  - `www/global.css` (global typography/spacing/containers)
  - `www/navbar.css` (navigation visual contract)
  - `www/footer.css` (footer layout contract)
  - `www/qc.css` (QC-specific consistency layer)

## 5. Current UI consistency risks
- Very large, multi-purpose page files (`page_analysis.R`, `page_qc.R`, `page_hto.R`) likely mix patterns from multiple eras.
- Potential header/card inconsistency across page families (`qc`, `analysis`, `figures`, `workspace`).
- Button labeling patterns appear mixed (verb-first vs noun-first, varying urgency colors).
- Dense control clusters in single panels may reduce scanability (especially analysis and QC pages).
- Multiple table styles likely coexist (DT options and wrappers vary per page).
- Plot container sizing logic appears repeated across files, risking drift.
- Sidebar interaction styling is complex and may diverge from page card styles.
- Duplicated UI helper patterns may exist between `interface/shared/` and page-local helpers.

## 6. Files that dominate UI context size
- Largest files:
  - `interface/analysis/page_analysis.R`
  - `interface/components/component_right_sidebar.R`
  - `interface/qc/page_qc.R`
  - `interface/qc/page_hto.R`
  - `interface/analysis/page_data_browser_new.R`
  - `interface/workspace/page_rds.R`
  - `app.R`
  - `run.R`
- Recommendation:
  - Keep in normal UI context: `app.R`, `run.R`, `component_navbar.R`, `component_footer.R`, core CSS.
  - Split into page-specific context: `page_analysis.R`, `page_qc.R`, `page_hto.R`, `page_data_browser_new.R`, `page_rds.R`.
  - Exclude from global design context by default: heavy workflow pages unless actively being edited.

## 7. Recommended future Repomix contexts
- A. Global UI shell context
  - Include: `app.R`, `run.R`, `interface/components/**/*.R`, `interface/shared/**/*.R`, `www/**/*.css`, `www/js/poline-lab-runtime.js`.
  - Exclude: `interface/analysis/**`, `interface/qc/**`, `interface/workspace/**`, `core/**`, `seurat4/**`, data/demo/assets.
  - Use when: global nav/sidebar/footer consistency work.
- B. Page-specific context
  - Include: one target page family (example `interface/qc/page_qc.R` + related helpers + shared/components + relevant CSS).
  - Exclude: unrelated page families and backend folders.
  - Use when: focused redesign/refactor of one workflow page.
- C. Full UI audit context
  - Include: all `interface/**/*.R`, `app.R`, `run.R`, CSS, selected lightweight JS.
  - Exclude: `core/**`, `seurat4/**`, demo/data/binaries/images/logos/overlays.
  - Use when: comprehensive UI consistency audits and cross-page standards pass.

## 8. Safe first UI consistency targets
- Standardize page title/subtitle pattern across all page modules.
- Standardize card spacing/padding/margin scale via shared classes only.
- Standardize primary/secondary/danger button label style and placement.
- Standardize DT table wrapper classes and default pagination/scroll options.
- Standardize plot container height presets (`sm`/`md`/`lg`) and apply consistently.
- Standardize section divider and helper-text style.
- Consolidate duplicated “run/apply/download” control row patterns into shared helper(s).
- Normalize sidebar-to-main spacing and vertical rhythm.
- Standardize empty-state and no-data message style.
- Standardize modal footer button order and button classes.

## 9. Do-not-touch list
- `core/**` and `seurat4/**` (backend/analysis logic).
- Any import/export or workflow behavior logic in `app.R`/`run.R` without explicit approval.
- Navigation ID contracts and tab IDs (unknown full list from UI context alone).
- Right sidebar data-state contracts and object wiring in `component_right_sidebar.R`.
- Any file outside UI scope for design-only passes.
- Unknown from UI context: exact shared-data invariants that may couple UI controls to backend state.

## Troubleshooting Confidence Policy

When troubleshooting issues or increasing performance, evaluate confidence first by percentage.
If confidence is not above 95%, ask the user first before applying fixes.
If confidence is below 50%, ignore the current path and rethink before proceeding.
Check whether related functions are affected by the change (for example global behavior, reactive() flow, and cross-page side effects), and whether the fix is a strong guard rather than a temporary patch; if affecting others is inevitable, ask for permission first.

