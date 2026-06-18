# Figure Studio Hidden Page Contract

Last updated: 2026-04-16

## Scope
This document defines implementation requirements for the hidden Figure Studio pseudobulk volcano page.

## Hidden Routing Pattern (Required)
1. Register the hidden tab in `Content/interface/components/component_navbar.R` so it is routable.
2. Keep the tab admin-locked by default:
   - include it in `wanlab_admin_gated_tabs()` registry (`Content/interface/shared/admin_tab_registry.R`)
   - app nav logic in `Content/app.R` tags locked entries as `data-admin-locked='true'` and prevents normal unlock paths from unhiding them.
3. Open the tab only from admin modal actions in right sidebar:
   - add admin button in `Content/interface/components/admin_hidden_panel.R`
   - wire `updateNavbarPage(..., inputId = "main_navbar", selected = "figure_studio_pseudobulk_volcano_hidden")` in `Content/interface/components/component_right_sidebar.R`.
4. Hidden tab id for this page is: `figure_studio_pseudobulk_volcano_hidden`.

## Data Contract (Cache-Only)
1. The page must only read cached pseudobulk results from:
   - `shared_data$all_seurat_objects[[active]]$analysis_cache$pseudobulk_overview`
   - `shared_data$all_seurat_objects[[active]]$analysis_cache$pseudobulk_custom`
2. The page must not run pseudobulk computation.
3. The page must not write new pseudobulk cache payloads.

## ggmagnify Contract
1. `ggmagnify` is required for this hidden page.
2. No fallback rendering path is allowed when `ggmagnify` is unavailable.
3. Dependency installation must remain TEST_VERSION-only:
   - add `ggmagnify` only in `PKG_PLAN_HIDDEN_TEST` (`Content/run.R`).

## Figure Studio UX Contract
1. Keep standard Figure Studio layout pattern:
   - `.page-header`
   - `plotting-left-panel`
   - `plot_area_card_style`
   - `figure_with_busy_spinner(...)`
2. Include shared plot settings modal integration.
3. Include preview dimension controls and PDF export modal integration.
4. Expose full aesthetics controls for volcano rendering (thresholds, colors, labels, facet/magnify settings).

## Code Box Contract
1. The page must include an editable R code box via figure code-card helpers.
2. Generated script must reflect current UI settings.
3. Script should remain pipeline-independent and point to cached pseudobulk result usage.

## Troubleshooting Confidence Policy

When troubleshooting issues or increasing performance, evaluate confidence first by percentage.
If confidence is not above 95%, ask the user first before applying fixes.
If confidence is below 50%, ignore the current path and rethink before proceeding.
Check whether related functions are affected by the change (for example global behavior, reactive() flow, and cross-page side effects), and whether the fix is a strong guard rather than a temporary patch; if affecting others is inevitable, ask for permission first.

