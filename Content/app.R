library(shiny)
library(shinyjs)
library(shinybusy)
library(bslib)
library(shinycssloaders)
library(rhandsontable)
library(plotly)
library(shinyWidgets)
library(shinyFiles)
library(fs)
library(DT)
library(colourpicker)
library(ggplot2)
library(patchwork)
# REMOVED: library(Seurat) - Loading handled dynamically by environment page

options(shiny.maxRequestSize = 50 * 1024^3)
# Agent navigation contract references:
# - docs/agents/global/NAVBAR_AND_ROUTING.md
# - docs/agents/core/CORE_ARCHITECTURE_CONTRACTS.md
# - docs/agents/contracts/SHARED_DATA_CONTRACT.md
here::i_am("app.R")
WANLAB_DIAG_MODE <- !identical(Sys.getenv("WANLAB_DIAG_MODE", "1"), "0")
APP_VERSION <- "0.5.2"
MINIMUM_COMPATIBLE_VERSION <- "0.2.0"
MAXIMUM_COMPATIBLE_VERSION <- "1.0.0"
`%||%` <- function(a, b) if (is.null(a)) b else a

wanlab_registry_entry_object <- function(entry) {
  if (is.list(entry) && !is.null(entry$obj)) return(entry$obj)
  entry
}

wanlab_canonicalize_object_entry <- function(entry) {
  sobj <- wanlab_registry_entry_object(entry)
  if (is.null(sobj) || !inherits(sobj, "Seurat")) return(NULL)
  out <- if (is.list(entry)) entry else list()
  out$obj <- sobj
  if (is.null(out$prefs) || !is.list(out$prefs)) out$prefs <- list()
  if (is.null(out$plots) || !is.list(out$plots)) out$plots <- list()
  if (is.null(out$analysis_cache) || !is.list(out$analysis_cache)) out$analysis_cache <- list()
  if (is.null(out$meta) || !is.list(out$meta)) out$meta <- list()
  if (is.null(out$meta$linked_files) || !is.list(out$meta$linked_files)) out$meta$linked_files <- list()
  if (is.null(out$meta$linked_files$vdj) || !is.data.frame(out$meta$linked_files$vdj)) {
    out$meta$linked_files$vdj <- data.frame(
      chain = character(0),
      source_name = character(0),
      stringsAsFactors = FALSE
    )
  } else {
    vdj_df <- out$meta$linked_files$vdj
    if (!("chain" %in% names(vdj_df))) vdj_df$chain <- character(nrow(vdj_df))
    if (!("source_name" %in% names(vdj_df))) {
      if ("path" %in% names(vdj_df)) {
        vdj_df$source_name <- basename(as.character(vdj_df$path %||% ""))
      } else {
        vdj_df$source_name <- character(nrow(vdj_df))
      }
    }
    out$meta$linked_files$vdj <- vdj_df[, c("chain", "source_name"), drop = FALSE]
  }
  out
}

wanlab_canonicalize_registry <- function(registry, sample_sheet = NULL) {
  reg <- registry %||% list()
  if (!is.list(reg)) reg <- tryCatch(as.list(reg), error = function(e) list())
  if (!length(reg)) return(list())
  out <- lapply(reg, wanlab_canonicalize_object_entry)
  keep <- !vapply(out, is.null, logical(1))
  out <- out[keep]
  if (!length(out)) return(list())
  nms <- names(out)
  if (is.null(nms)) nms <- rep("", length(out))
  nms <- as.character(nms %||% character(0))
  if (length(nms) < length(out)) nms <- c(nms, rep("", length(out) - length(nms)))
  sheet_names <- character(0)
  if (is.data.frame(sample_sheet) && nrow(sample_sheet) && "name" %in% colnames(sample_sheet)) {
    sheet_names <- as.character(sample_sheet$name %||% character(0))
    sheet_names <- sheet_names[!is.na(sheet_names) & nzchar(sheet_names)]
  }
  used <- unique(nms[nzchar(nms)])
  for (i in seq_along(nms)) {
    if (nzchar(nms[[i]]) && !is.na(nms[[i]])) next
    candidate <- ""
    if (i <= length(sheet_names) && nzchar(sheet_names[[i]]) && !(sheet_names[[i]] %in% used)) {
      candidate <- sheet_names[[i]]
    }
    if (!nzchar(candidate)) candidate <- paste0("Imported_", i)
    nms[[i]] <- candidate
    used <- c(used, candidate)
  }
  names(out) <- make.unique(nms)
  out
}

.reset_subset_analysis_state <- function(sobj) {
  if (is.null(sobj)) return(sobj)

  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (!is.null(md) && nrow(md)) {
    cols <- colnames(md)
    lower_cols <- tolower(cols)
    drop_patterns <- c(
      "^anno_",
      "^annotation_",
      "^singler_",
      "^markergene_",
      "^celltypist_",
      "^db_",
      "^monocle2_",
      "^nichenet_",
      "^niches_",
      "^cellchat_",
      "^scenic_",
      "^rv052_",
      "^sctenifoldknk_"
    )
    drop_by_pattern <- vapply(
      lower_cols,
      function(cc) any(vapply(drop_patterns, function(pp) grepl(pp, cc, ignore.case = TRUE, perl = TRUE), logical(1))),
      logical(1)
    )
    drop_meta <- cols[
      lower_cols %in% c("seurat_clusters") |
        grepl("(^|_)(snn|nn|wsnn|wknn)_res\\.[0-9]+", cols, ignore.case = TRUE) |
        grepl("(^|_)(snn|nn|wsnn|wknn)\\.res\\.[0-9]+", cols, ignore.case = TRUE) |
        grepl("(^|_)leiden_res\\.[0-9]+", cols, ignore.case = TRUE) |
        grepl("^seurat_clusters_res\\.[0-9]+", cols, ignore.case = TRUE) |
        grepl("^sweep_(nn_)?res\\.[0-9]+", cols, ignore.case = TRUE) |
        drop_by_pattern
    ]
    keep_meta <- setdiff(cols, unique(drop_meta))
    sobj@meta.data <- md[, keep_meta, drop = FALSE]
  }

  # Reset identities so downstream tabs do not inherit stale cluster identities.
  tryCatch({
    md2 <- sobj@meta.data
    if (!is.null(md2) && "orig.ident" %in% colnames(md2)) {
      Seurat::Idents(sobj) <- factor(as.character(md2$orig.ident))
    } else if (!is.null(md2) && nrow(md2)) {
      Seurat::Idents(sobj) <- factor(rep("subset", nrow(md2)), levels = "subset")
    }
  }, error = function(e) NULL)

  # Clear graph / neighbor state so fresh clustering is computed for the subset.
  tryCatch({
    if (!is.null(sobj@graphs) && length(sobj@graphs)) sobj@graphs <- list()
  }, error = function(e) NULL)
  tryCatch({
    if (!is.null(sobj@neighbors) && length(sobj@neighbors)) sobj@neighbors <- list()
  }, error = function(e) NULL)

  # Drop analysis reductions inherited from the parent object.
  tryCatch({
    red_names <- names(sobj@reductions)
    if (length(red_names)) {
      keep_red <- red_names[!tolower(red_names) %in% c("pca", "umap", "tsne", "umap3d")]
      sobj@reductions <- sobj@reductions[keep_red]
    }
  }, error = function(e) NULL)

  # Clear matching command history so re-runs reflect the subset, not the parent.
  tryCatch({
    cmd_names <- names(sobj@commands)
    if (length(cmd_names)) {
      drop_cmd <- cmd_names[
        grepl("runpca|runumap|runtsne|findneighbors|findclusters", cmd_names, ignore.case = TRUE)
      ]
      sobj@commands <- sobj@commands[setdiff(cmd_names, drop_cmd)]
    }
  }, error = function(e) NULL)

  sobj
}

# Keep all sourced app modules/pages in the same environment as app.R,
# even when called from nested helpers at runtime.
.app_source_env <- environment()

.time_source <- function(path, local = .app_source_env) {
  if (identical(local, FALSE)) local <- .app_source_env
  t0 <- proc.time()[["elapsed"]]
  tryCatch(
    source(path, local = local),
    error = function(e) {
      calls <- vapply(sys.calls(), function(cl) paste(deparse(cl), collapse = " "), character(1))
      msg <- sprintf("[APP SOURCE ERROR] %s :: %s", path, conditionMessage(e))
      message(msg)
      if (length(calls)) {
        message("[APP SOURCE ERROR] Call stack:")
        message(paste(calls, collapse = "\n"))
      }
      stop(msg, call. = FALSE)
    }
  )
  dt <- proc.time()[["elapsed"]] - t0
  message(sprintf("[APP SOURCE] %s: %.2fs", path, dt))
  invisible(TRUE)
}

# ---- Modules ----
# Shared UI infrastructure
.time_source("interface/shared/spinner_overlay.R")
.time_source("interface/shared/qc_busy_spinner.R")
.time_source("interface/shared/card_page_template.R")
.time_source("interface/shared/plot_card_state_helpers.R")
.time_source("interface/shared/gene_selectize_helpers.R")
.time_source("interface/shared/code_block_helpers.R")
.time_source("interface/shared/beta_badge_helpers.R")
.time_source("interface/shared/beta_result_object_controls.R")
.time_source("interface/shared/metadata_suffix_policy_helpers.R")
.time_source("interface/shared/vdj_clone_overlay_utils.R")
.time_source("interface/shared/vdj_payload_utils.R")
.time_source("interface/shared/admin_tab_registry.R")
.time_source("interface/components/right_sidebar_registry_helpers.R")
.time_source("interface/components/component_right_sidebar.R")
.time_source("interface/components/component_navbar.R") 
.time_source("interface/components/component_footer.R") 
.time_source("interface/shared/shared_pdf_export_modal.R")

# Welcome / Setup
.time_source("interface/welcome/page_welcome.R")
.time_source("interface/setup/page_environment.R")
# Independent beta analysis backend helpers
.time_source("core/backends/cellchat_core.R")
.time_source("core/backends/scenic_core.R")
.time_source("core/backends/monocle2_core.R")
.time_source("core/backends/nichenet_core.R")
.time_source("core/backends/niches_core.R")
.time_source("core/backends/sctenifoldknk_core.R")
.time_source("core/backends/rna_velocity_core.R")
.time_source("core/backends/singler_annotation_core.R")
.time_source("core/backends/h5ad_export_core.R")
# Core backend routing/helpers (versioned core trees)
.resolve_core_variant <- function(env_name = NULL) {
  nm <- tolower(as.character(env_name %||% ""))
  if (grepl("seurat5", nm, fixed = TRUE)) return("seurat_v5")
  "seurat_v4"
}

.source_core_modules <- function(core_variant = "seurat_v4") {
  base_dir <- file.path("core", core_variant)
  req_files <- c(
    "utils_seurat_backend.R",
    "qc_core.R",
    "contamination_core.R",
    "hto_core.R",
    "atac_qc_core.R",
    "doublet_core.R",
    "flowgate_core.R",
    "normalize_integrate_core.R",
    "umap_configuration_core.R",
    "clustering_resolution_core.R",
    "cluster_determination_core.R"
  )
  for (f in req_files) {
    p <- file.path(base_dir, f)
    if (!file.exists(p)) stop("Missing core module file: ", p)
    .time_source(p)
  }
  invisible(core_variant)
}

# initial load before interface pages are sourced
.source_core_modules("seurat_v4")
# DEPRECATED_page_import.R is legacy and intentionally not sourced.

# QC menu
.time_source("interface/qc/page_qc.R")
.time_source("interface/qc/page_contamination_correction.R")
.time_source("interface/qc/page_hto.R")
.time_source("interface/qc/page_doublet.R")
.time_source("interface/qc/page_vdj.R")
.time_source("interface/qc/page_barcodes.R")
.time_source("interface/qc/page_atac_qc.R")

# Analysis menu
.time_source("interface/analysis/page_data_browser.R")
.time_source("interface/analysis/analysis_object_selector_helpers.R")
.time_source("interface/analysis/annotation_layer_helpers.R")
.time_source("interface/analysis/analysis_umap_frequency_helpers.R")
.time_source("interface/analysis/analysis_umap_plot_helpers.R")
.time_source("interface/analysis/cellwhisperer_helpers.R")
.time_source("interface/analysis/page_analysis.R")
.time_source("interface/analysis/page_recluster.R")
.time_source("interface/analysis/page_data_browser_new.R")
.time_source("interface/analysis/page_rna_velocity.R")
.time_source("interface/analysis/page_rna_velocity_v052.R")
.time_source("interface/analysis/page_multiome_wnn.R")
.time_source("interface/analysis/page_multiome_marker.R")
.time_source("interface/analysis/page_cellchat.R")
.time_source("interface/analysis/page_scenic.R")
.time_source("interface/analysis/page_monocle2.R")
.time_source("interface/analysis/page_nichenet.R")
.time_source("interface/analysis/page_niches.R")
.time_source("interface/analysis/page_sctenifoldknk.R")

# Export menu
.time_source("interface/export/page_export.R")
.time_source("interface/export/page_export_vdj_safe.R")
.time_source("interface/export/page_multiome_export_check.R")

# Workspace / Figures / Help
.time_source("interface/workspace/page_rds.R")
.time_source("interface/figures/motion_color_picker_module.R")
.time_source("interface/figures/curve_color_picker_module.R")
.time_source("interface/figures/figure_color_popup_helpers.R")
.time_source("interface/figures/figure_code_card_helpers.R")
.time_source("interface/figures/page_figure_umap.R")
.time_source("interface/figures/page_figure_feature.R")
.time_source("interface/figures/page_figure_dotplot.R")
.time_source("interface/figures/page_figure_alluvial.R")
.time_source("interface/figures/page_figure_cluster_alluvial.R")
.time_source("interface/figures/page_figure_pseudobulk_volcano.R")
.time_source("interface/figures/page_figure_tcr_studio.R")

# Keep flowgate sourced last to preserve legacy global symbol order.
.time_source("interface/qc/page_flowgate.R")

# ---- Theme Definition ----
my_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#4b5563",
  secondary = "#9ca3af"
)

# ---- UI ----
# We use the function from component_navbar.R to generate the main UI
# To ensure the footer is visible, we wrap everything in a div that allows flow
ui <- tagList(
  tags$head(
    qc_busy_spinner_assets,
    wl_code_block_assets(),
    tags$script(HTML("
      (function() {
        var lastInteractionTime = 0;
        var inputsUpdatingFromServer = {};

        function recordInteraction(e) {
          lastInteractionTime = Date.now();
        }

        document.addEventListener('mousedown', recordInteraction, true);
        document.addEventListener('keydown', recordInteraction, true);
        document.addEventListener('touchstart', recordInteraction, true);

        document.addEventListener('shiny:updateinput', function(event) {
          if (event.message && event.message.id) {
            var id = event.message.id;
            inputsUpdatingFromServer[id] = event.message.value;
            var el = document.getElementById(id);
            if (el) {
              el.__prev_value = event.message.value;
              if (el.type === 'checkbox' || el.type === 'radio') {
                el.__prev_checked = event.message.value;
              }
              console.log('[AUTOFILL DIAGNOSTIC] Server update message for:', id, 'value:', event.message.value);
            }
            setTimeout(function() {
              delete inputsUpdatingFromServer[id];
            }, 0);
          }
        });

        function handleInputChange(event) {
          var target = event.target;

          // Always allow programmatic changes from selectize/Shiny scripts (untrusted/synthetic events)
          var isSynthetic = event.isTrusted === false || 
                            event.isTrusted === undefined || 
                            (event.originalEvent && event.originalEvent.isTrusted === false) ||
                            (event.originalEvent && event.originalEvent.isTrusted === undefined);
          if (isSynthetic) {
            target.__prev_value = target.value;
            if (target.type === 'checkbox' || target.type === 'radio') {
              target.__prev_checked = target.checked;
            }
            return;
          }

          if (target.value === target.__prev_value) {
            if (target.type === 'checkbox' || target.type === 'radio') {
              if (target.checked === target.__prev_checked) return;
            } else {
              return;
            }
          }

          var timeSinceInteraction = Date.now() - lastInteractionTime;
          var isUpdating = inputsUpdatingFromServer.hasOwnProperty(target.id);
          var expectedValue = inputsUpdatingFromServer[target.id];
          var matchesExpected = false;
          if (isUpdating) {
            if (target.type === 'checkbox' || target.type === 'radio') {
              matchesExpected = String(target.checked) === String(expectedValue);
            } else {
              matchesExpected = String(target.value) === String(expectedValue);
            }
          }

          console.log('[AUTOFILL DIAGNOSTIC] Change event on guarded input:', target.id, 
            'value:', target.value, 
            'checked:', target.checked,
            'prev:', target.__prev_value, 
            'isUpdating:', isUpdating, 
            'expectedValue:', expectedValue, 
            'matchesExpected:', matchesExpected, 
            'timeSinceInteraction:', timeSinceInteraction
          );

          if ((!isUpdating || !matchesExpected) && timeSinceInteraction > 200) {
            event.stopImmediatePropagation();
            event.preventDefault();
            if (target.__prev_value !== undefined) {
              target.value = target.__prev_value;
              if (target.type === 'checkbox' || target.type === 'radio') {
                target.checked = target.__prev_checked;
              }
              if (target.selectize) {
                target.selectize.setValue(target.__prev_value, false);
              }
            }
            console.log('[AUTOFILL GUARD] Blocked browser auto-restore/autofill on:', target.id, 
              'value was:', target.value, 
              'reset to:', target.__prev_value
            );
          } else {
            target.__prev_value = target.value;
            if (target.type === 'checkbox' || target.type === 'radio') {
              target.__prev_checked = target.checked;
            }
          }
        }

        function getCanonicalValue(el) {
          var container = typeof el.closest === 'function' ? el.closest('[data-canonical-value]') : null;
          var val = el.getAttribute('data-canonical-value') || (container ? container.getAttribute('data-canonical-value') : null);
          if (val !== undefined && val !== null) return val;
          
          if (el.tagName === 'SELECT') {
            var selOpt = el.querySelector('option[selected]');
            if (selOpt) return selOpt.value;
            return el.options.length > 0 ? el.options[0].value : '';
          } else if (el.type === 'checkbox' || el.type === 'radio') {
            return el.hasAttribute('checked') || el.defaultChecked;
          } else {
            return el.getAttribute('value') || el.defaultValue || '';
          }
        }

        function initElement(el) {
          var id = el.id || '';
          var shouldGuard = id && (
            id.startsWith('recluster_new_') || 
            id.startsWith('active_object_name_') || 
            id.startsWith('recluster_dataset_')
          ) && !id.includes('_color_') && el.type !== 'color';
          if (shouldGuard) {
            if (!el.__guard_registered) {
              el.__guard_registered = true;
              el.addEventListener('change', handleInputChange, true);
              if (window.jQuery) {
                window.jQuery(el).on('change', handleInputChange);
              } else {
                var checkJQuery = setInterval(function() {
                  if (window.jQuery) {
                    clearInterval(checkJQuery);
                    window.jQuery(el).on('change', handleInputChange);
                  }
                }, 50);
              }
            }

            if (el.__prev_value === undefined) {
              var canonicalVal = getCanonicalValue(el);
              if (el.type === 'checkbox' || el.type === 'radio') {
                el.__prev_value = canonicalVal;
                el.__prev_checked = canonicalVal;
                if (el.checked !== canonicalVal) {
                  console.log('[AUTOFILL GUARD] Corrected pre-autofilled checkbox/radio on init:', el.id, 'from:', el.checked, 'to:', canonicalVal);
                  el.checked = canonicalVal;
                }
              } else {
                el.__prev_value = canonicalVal;
                if (el.value !== canonicalVal) {
                  console.log('[AUTOFILL GUARD] Corrected pre-autofilled select/input on init:', el.id, 'from:', el.value, 'to:', canonicalVal);
                  el.value = canonicalVal;
                  if (el.selectize) {
                    el.selectize.setValue(canonicalVal, true);
                  }
                }
              }
            }
          }
        }

        function initElements() {
          var els = document.querySelectorAll('input, select, textarea');
          for (var i = 0; i < els.length; i++) {
            initElement(els[i]);
          }
        }

        initElements();
        document.addEventListener('shiny:connected', initElements);
        document.addEventListener('shiny:value', initElements);
        document.addEventListener('shiny:bound', initElements);
        document.addEventListener('shiny:recalculated', initElements);

        // MutationObserver to catch dynamically added nodes immediately upon insertion
        var observer = new MutationObserver(function(mutations) {
          for (var i = 0; i < mutations.length; i++) {
            var addedNodes = mutations[i].addedNodes;
            for (var j = 0; j < addedNodes.length; j++) {
              var node = addedNodes[j];
              if (node.nodeType === 1) {
                var els = node.querySelectorAll ? node.querySelectorAll('input, select, textarea') : [];
                if (node.tagName === 'INPUT' || node.tagName === 'SELECT' || node.tagName === 'TEXTAREA') {
                  els = Array.prototype.slice.call(els);
                  els.unshift(node);
                }
                for (var m = 0; m < els.length; m++) {
                  initElement(els[m]);
                }
              }
            }
          }
        });
        observer.observe(document.documentElement, {
          childList: true,
          subtree: true
        });

        // Active background poller running every 50ms to detect and reverse browser form-restoration value changes
        setInterval(function() {
          var guardedIds = [
            'recluster_new_dataset_select', 
            'active_object_name_input', 
            'active_object_name_input_inline', 
            'active_object_name_input_umap_inline', 
            'recluster_dataset_select'
          ];
          for (var k = 0; k < guardedIds.length; k++) {
            var el = document.getElementById(guardedIds[k]);
            if (!el) continue;
            
            if (el.__prev_value === undefined) {
              var canonicalVal = getCanonicalValue(el);
              if (el.type === 'checkbox' || el.type === 'radio') {
                el.__prev_value = canonicalVal;
                el.__prev_checked = canonicalVal;
                if (el.checked !== canonicalVal) {
                  console.log('[AUTOFILL GUARD] Corrected pre-autofilled checkbox on query:', el.id, 'from:', el.checked, 'to:', canonicalVal);
                  el.checked = canonicalVal;
                }
              } else {
                el.__prev_value = canonicalVal;
                if (el.value !== canonicalVal) {
                  console.log('[AUTOFILL GUARD] Corrected pre-autofilled select/input on query:', el.id, 'from:', el.value, 'to:', canonicalVal);
                  el.value = canonicalVal;
                  if (el.selectize) {
                    el.selectize.setValue(canonicalVal, true);
                  }
                }
              }
            } else {
              if (el.type === 'checkbox' || el.type === 'radio') {
                if (el.checked !== el.__prev_checked) {
                  var timeSinceInteraction = Date.now() - lastInteractionTime;
                  var isUpdating = inputsUpdatingFromServer.hasOwnProperty(el.id);
                  var expectedValue = inputsUpdatingFromServer[el.id];
                  var matchesExpected = isUpdating && String(el.checked) === String(expectedValue);

                  console.log('[AUTOFILL DIAGNOSTIC] Poller detected checkbox change on:', el.id, 
                    'checked:', el.checked, 
                    'prev:', el.__prev_checked, 
                    'isUpdating:', isUpdating, 
                    'expectedValue:', expectedValue,
                    'matchesExpected:', matchesExpected,
                    'timeSinceInteraction:', timeSinceInteraction
                  );

                  if ((!isUpdating || !matchesExpected) && timeSinceInteraction > 200) {
                    console.log('[AUTOFILL GUARD] Reset unauthorized checkbox/radio change:', el.id, 'from:', el.checked, 'to:', el.__prev_checked);
                    el.checked = el.__prev_checked;
                  } else {
                    el.__prev_checked = el.checked;
                    el.__prev_value = el.checked;
                  }
                }
              } else {
                if (el.value !== el.__prev_value) {
                  var timeSinceInteraction = Date.now() - lastInteractionTime;
                  var isUpdating = inputsUpdatingFromServer.hasOwnProperty(el.id);
                  var expectedValue = inputsUpdatingFromServer[el.id];
                  var matchesExpected = isUpdating && String(el.value) === String(expectedValue);

                  console.log('[AUTOFILL DIAGNOSTIC] Poller detected select change on:', el.id, 
                    'value:', el.value, 
                    'prev:', el.__prev_value, 
                    'isUpdating:', isUpdating, 
                    'expectedValue:', expectedValue,
                    'matchesExpected:', matchesExpected,
                    'timeSinceInteraction:', timeSinceInteraction
                  );

                  if ((!isUpdating || !matchesExpected) && timeSinceInteraction > 200) {
                    console.log('[AUTOFILL GUARD] Reset unauthorized input change:', el.id, 'from:', el.value, 'to:', el.__prev_value);
                    el.value = el.__prev_value;
                    if (el.selectize) {
                      el.selectize.setValue(el.__prev_value, false);
                    }
                  } else {
                    el.__prev_value = el.value;
                  }
                }
              }
            }
          }
        }, 50);
      })();
    ")),
    tags$style(HTML("
      /* Global Plotly font override across all pages */
      .js-plotly-plot,
      .js-plotly-plot .plotly,
      .js-plotly-plot .main-svg,
      .js-plotly-plot text {
        font-family: Arial, Helvetica, sans-serif !important;
      }

      /* Emergency recovery lock: freeze interactions while snapshot is being written. */
      body.wl-emergency-lock,
      body.wl-emergency-lock * {
        cursor: wait !important;
      }
      body.wl-emergency-lock * {
        pointer-events: none !important;
      }
      body.wl-emergency-lock #global_overlay,
      body.wl-emergency-lock #global_overlay * {
        pointer-events: auto !important;
      }
      body.wl-emergency-lock #global_overlay {
        z-index: 10001 !important;
      }
    ")),
    tags$script(HTML("
      (function () {
        // Global accordion behavior:
        // - details[data-accordion-group]: enforce one-open-per-group
        // - .app-accordion-body: smooth open/close with measured max-height
        function refreshAccordionBodyHeight(detailsEl) {
          if (!detailsEl) return;
          var body = detailsEl.querySelector(':scope > .app-accordion-body');
          if (!body) return;
          if (detailsEl.open) {
            body.style.maxHeight = body.scrollHeight + 'px';
            body.style.opacity = '1';
          } else {
            body.style.maxHeight = '0px';
            body.style.opacity = '0';
          }
        }

        function refreshAllAccordions(root) {
          var scope = root || document;
          var all = scope.querySelectorAll('details.app-accordion');
          for (var i = 0; i < all.length; i++) refreshAccordionBodyHeight(all[i]);
        }

        document.addEventListener('toggle', function(ev) {
          var t = ev.target;
          if (!(t instanceof HTMLDetailsElement)) return;
          if (!t.classList.contains('app-accordion')) return;

          var grp = t.getAttribute('data-accordion-group') || '';
          if (t.open && grp) {
            var peers = document.querySelectorAll('details.app-accordion[data-accordion-group=\"' + grp + '\"]');
            for (var i = 0; i < peers.length; i++) {
              var p = peers[i];
              if (p !== t && p.open) p.open = false;
            }
          }
          refreshAccordionBodyHeight(t);
        }, true);

        document.addEventListener('DOMContentLoaded', function() { refreshAllAccordions(document); });
        document.addEventListener('shiny:connected', function() { refreshAllAccordions(document); });
        document.addEventListener('shiny:value', function() { refreshAllAccordions(document); }, true);

        // Keep CSS layout tokens synced with actual navbar/footer heights.
        function syncLayoutHeightVars() {
          var nav = document.querySelector('.navbar');
          var footer = document.querySelector('.footer');
          var navRect = nav ? nav.getBoundingClientRect() : null;
          var isDesktopRail = !!(
            navRect &&
            window.innerWidth > 991 &&
            navRect.height >= (window.innerHeight * 0.75) &&
            navRect.width <= 140
          );
          var navH = navRect ? Math.ceil(navRect.height || 56) : 56;
          if (isDesktopRail) navH = 0;
          var footerH = footer ? Math.ceil(footer.getBoundingClientRect().height || 0) : 0;
          document.documentElement.style.setProperty('--nav-h', navH + 'px');
          if (navRect) document.documentElement.style.setProperty('--nav-rail-h', Math.ceil(navRect.height || 0) + 'px');
          document.documentElement.style.setProperty('--footer-h', footerH + 'px');
        }

        if (document.readyState !== 'loading') setTimeout(syncLayoutHeightVars, 0);
        document.addEventListener('DOMContentLoaded', syncLayoutHeightVars);
        document.addEventListener('shiny:connected', syncLayoutHeightVars);
        window.addEventListener('resize', syncLayoutHeightVars);
        window.addEventListener('load', syncLayoutHeightVars);

        var layoutObs = new MutationObserver(function() { syncLayoutHeightVars(); });
        layoutObs.observe(document.documentElement, { childList: true, subtree: true });

        // Global resizable-plot contract:
        // .app-resizable-plot container resize must force Plotly reflow.
        function resizePlotlyInContainer(container) {
          if (!container) return;
          var plots = container.querySelectorAll('.js-plotly-plot');
          for (var i = 0; i < plots.length; i++) {
            var node = plots[i];
            if (window.Plotly && window.Plotly.Plots && typeof window.Plotly.Plots.resize === 'function') {
              try { window.Plotly.Plots.resize(node); } catch (e) {}
            }
          }
        }

        var resizePlotlyRaf = null;
        function scheduleResizePlotly(container) {
          if (resizePlotlyRaf) window.cancelAnimationFrame(resizePlotlyRaf);
          resizePlotlyRaf = window.requestAnimationFrame(function() {
            resizePlotlyInContainer(container);
            window.setTimeout(function() { resizePlotlyInContainer(container); }, 70);
          });
        }

        var rsObserver = null;
        function bindResizablePlots(root) {
          if (!window.ResizeObserver) return;
          if (!rsObserver) {
            rsObserver = new ResizeObserver(function(entries) {
              for (var i = 0; i < entries.length; i++) {
                scheduleResizePlotly(entries[i].target);
              }
            });
          }
          var scope = root || document;
          var nodes = scope.querySelectorAll('.app-resizable-plot');
          for (var j = 0; j < nodes.length; j++) {
            rsObserver.observe(nodes[j]);
            scheduleResizePlotly(nodes[j]);
          }
        }

        document.addEventListener('DOMContentLoaded', function() { bindResizablePlots(document); });
        document.addEventListener('shiny:connected', function() { bindResizablePlots(document); });
        document.addEventListener('shiny:value', function(ev) {
          var target = ev && ev.target ? ev.target : document;
          bindResizablePlots(target);
        }, true);

        // Global drag-handle contract:
        // .app-resize-handle with data-target id resizes target element height.
        var __appResizeDrag = null;
        function startResizeDrag(target, clientY) {
          if (!target) return;
          var rect = target.getBoundingClientRect();
          __appResizeDrag = {
            target: target,
            startY: clientY,
            startH: rect.height
          };
          document.body.style.cursor = 'ns-resize';
          document.body.style.userSelect = 'none';
        }
        function initResizeHandles(root) {
          var scope = root || document;
          var handles = scope.querySelectorAll('.app-resize-handle[data-target]');
          for (var i = 0; i < handles.length; i++) {
            var h = handles[i];
            h.dataset.boundResizeHandle = '1';
          }
        }
        function beginDragFromHandle(handleEl, clientY) {
          if (!handleEl) return;
          var targetId = handleEl.getAttribute('data-target');
          var target = targetId ? document.getElementById(targetId) : null;
          if (!target) return;
          startResizeDrag(target, clientY);
        }
        window.__wlResizeFromHandle = function(ev, handleEl) {
          if (ev && ev.preventDefault) ev.preventDefault();
          var h = handleEl || (ev && ev.currentTarget ? ev.currentTarget : null);
          var y = (ev && typeof ev.clientY === 'number') ? ev.clientY : 0;
          beginDragFromHandle(h, y);
          return false;
        };
        document.addEventListener('mousedown', function(ev) {
          var h = ev.target && ev.target.closest ? ev.target.closest('.app-resize-handle[data-target]') : null;
          if (!h) return;
          ev.preventDefault();
          beginDragFromHandle(h, ev.clientY);
        }, true);
        document.addEventListener('pointerdown', function(ev) {
          var h = ev.target && ev.target.closest ? ev.target.closest('.app-resize-handle[data-target]') : null;
          if (!h) return;
          ev.preventDefault();
          beginDragFromHandle(h, ev.clientY);
        }, true);
        document.addEventListener('mousemove', function(ev) {
          if (!__appResizeDrag || !__appResizeDrag.target) return;
          var dy = ev.clientY - __appResizeDrag.startY;
          var nextH = Math.max(320, Math.round(__appResizeDrag.startH + dy));
          __appResizeDrag.target.style.height = nextH + 'px';
          scheduleResizePlotly(__appResizeDrag.target);
        });
        document.addEventListener('pointermove', function(ev) {
          if (!__appResizeDrag || !__appResizeDrag.target) return;
          var dy = ev.clientY - __appResizeDrag.startY;
          var nextH = Math.max(320, Math.round(__appResizeDrag.startH + dy));
          __appResizeDrag.target.style.height = nextH + 'px';
          scheduleResizePlotly(__appResizeDrag.target);
        });
        document.addEventListener('mouseup', function() {
          if (!__appResizeDrag) return;
          __appResizeDrag = null;
          document.body.style.cursor = '';
          document.body.style.userSelect = '';
        });
        document.addEventListener('pointerup', function() {
          if (!__appResizeDrag) return;
          __appResizeDrag = null;
          document.body.style.cursor = '';
          document.body.style.userSelect = '';
        });
        // Portrait display optimizations: auto-collapse sidebar and inject resize handles
        var __sidebarCheckedPortrait = null;
        function checkAndCollapseSidebar() {
          var isPortrait = window.matchMedia('(max-width: 991.98px), (orientation: portrait)').matches;
          if (isPortrait && __sidebarCheckedPortrait !== true) {
            var sidebar = document.querySelector('.bslib-sidebar-layout.sidebar-right');
            if (sidebar && !sidebar.classList.contains('sidebar-collapsed')) {
              var toggle = sidebar.querySelector('.collapse-toggle, .bslib-sidebar-toggle');
              if (toggle) toggle.click();
            }
          }
          __sidebarCheckedPortrait = isPortrait;
        }
        document.addEventListener('shiny:connected', checkAndCollapseSidebar);
        window.addEventListener('resize', checkAndCollapseSidebar);

        function injectPortraitResizeHandles() {
          var pages = document.querySelectorAll('.plotting-page');
          pages.forEach(function (page) {
            var plotAreas = page.querySelectorAll('.plot_area_card_style');
            plotAreas.forEach(function (plotArea) {
              if (plotArea.querySelector('.app-resize-handle')) return;
              
              if (!plotArea.id) {
                plotArea.id = 'plot_area_auto_' + Math.random().toString(36).substr(2, 9);
              }
              
              var handle = document.createElement('div');
              handle.className = 'app-resize-handle wl-portrait-only-resizer';
              handle.setAttribute('data-target', plotArea.id);
              handle.innerHTML = '<span class=\\'app-resize-handle-grip\\'></span><span class=\\'app-resize-handle-text\\'>Drag to resize</span>';
              
              plotArea.appendChild(handle);
              plotArea.classList.add('app-resizable-plot');
              page.classList.add('app-resizable-plot-page');
              
              // Drag listeners: update CSS property on the page container to persist state
              handle.addEventListener('mousedown', function (ev) {
                var startY = ev.clientY;
                var startH = plotArea.getBoundingClientRect().height;
                var dragHandler = function (moveEv) {
                  var dy = moveEv.clientY - startY;
                  var nextH = Math.max(320, Math.round(startH + dy));
                  page.style.setProperty('--wl-portrait-plot-height', nextH + 'px');
                  if (typeof scheduleResizePlotly === 'function') scheduleResizePlotly(plotArea);
                };
                document.addEventListener('mousemove', dragHandler);
                document.addEventListener('mouseup', function upHandler() {
                  document.removeEventListener('mousemove', dragHandler);
                  document.removeEventListener('mouseup', upHandler);
                });
              });
              
              handle.addEventListener('pointerdown', function (ev) {
                var startY = ev.clientY;
                var startH = plotArea.getBoundingClientRect().height;
                var dragHandler = function (moveEv) {
                  var dy = moveEv.clientY - startY;
                  var nextH = Math.max(320, Math.round(startH + dy));
                  page.style.setProperty('--wl-portrait-plot-height', nextH + 'px');
                  if (typeof scheduleResizePlotly === 'function') scheduleResizePlotly(plotArea);
                };
                document.addEventListener('pointermove', dragHandler);
                document.addEventListener('pointerup', function upHandler() {
                  document.removeEventListener('pointermove', dragHandler);
                  document.removeEventListener('pointerup', upHandler);
                });
              });
            });
          });
        }
        
        document.addEventListener('DOMContentLoaded', injectPortraitResizeHandles);
        document.addEventListener('shiny:connected', injectPortraitResizeHandles);
        document.addEventListener('shown.bs.tab', injectPortraitResizeHandles, true);
        
        var portraitObserver = new MutationObserver(injectPortraitResizeHandles);
        portraitObserver.observe(document.documentElement, { childList: true, subtree: true });

        document.addEventListener('DOMContentLoaded', function() { initResizeHandles(document); });
        document.addEventListener('shiny:connected', function() { initResizeHandles(document); });
        document.addEventListener('shiny:value', function(ev) {
          var target = ev && ev.target ? ev.target : document;
          initResizeHandles(target);
        }, true);
      })();
    ")),
    tags$script(HTML("
      (function () {
        window.__wlFigurePreviewState = window.__wlFigurePreviewState || {};

        function clampPx(v, fallback) {
          var n = Number(v);
          if (!isFinite(n) || n <= 0) return fallback;
          return Math.round(Math.max(120, n));
        }

        function fitFrame(stage, frame, w, h) {
          if (!stage || !frame) return;
          var ww = Math.max(1, Math.round(Number(w) || 1));
          var hh = Math.max(1, Math.round(Number(h) || 1));
          var sw = Math.max(1, stage.clientWidth || 0);
          var sh = Math.max(1, stage.clientHeight || 0);
          var scale = Math.min(sw / ww, sh / hh);
          if (!isFinite(scale) || scale <= 0) scale = 1;
          if (scale > 1) scale = 1;
          frame.style.width = ww + 'px';
          frame.style.height = hh + 'px';
          frame.style.maxWidth = 'none';
          frame.style.maxHeight = 'none';
          frame.style.transform = 'scale(' + scale + ')';
          frame.style.display = 'block';
        }

        function attachResize(stageId, frameId) {
          var key = frameId;
          if (window.__wlFigurePreviewState[key]) return window.__wlFigurePreviewState[key];
          var state = {
            stageId: stageId,
            frameId: frameId,
            widthPx: 960,
            heightPx: 720,
            ro: null
          };
          window.__wlFigurePreviewState[key] = state;
          return state;
        }

        Shiny.addCustomMessageHandler('wl_figure_preview_fit', function(msg) {
          var stageId = (msg && msg.stage_id) || '';
          var frameId = (msg && msg.frame_id) || '';
          if (!stageId || !frameId) return;

          var stage = document.getElementById(stageId);
          var frame = document.getElementById(frameId);
          if (!stage || !frame) return;

          var state = attachResize(stageId, frameId);
          state.widthPx = clampPx(msg.width_px, state.widthPx || 960);
          state.heightPx = clampPx(msg.height_px, state.heightPx || 720);
          fitFrame(stage, frame, state.widthPx, state.heightPx);

          if (!state.ro && window.ResizeObserver) {
            state.ro = new ResizeObserver(function() {
              var st = document.getElementById(state.stageId);
              var fr = document.getElementById(state.frameId);
              if (!st || !fr) return;
              fitFrame(st, fr, state.widthPx, state.heightPx);
            });
            state.ro.observe(stage);
          }
        });

        function refitAll() {
          var map = window.__wlFigurePreviewState || {};
          Object.keys(map).forEach(function(k) {
            var state = map[k];
            var stage = document.getElementById(state.stageId);
            var frame = document.getElementById(state.frameId);
            if (!stage || !frame) return;
            fitFrame(stage, frame, state.widthPx || 960, state.heightPx || 720);
          });
        }

        window.addEventListener('resize', refitAll);
        document.addEventListener('shown.bs.tab', refitAll, true);
        window.addEventListener('load', function() {
          window.setTimeout(refitAll, 0);
          window.setTimeout(refitAll, 150);
        });
      })();
    ")),
    tags$script(HTML("
      (function () {
        // Float the shorter side for plotting pages: left panel or plot area.
        function syncPlotPanelFloatingMode() {
          function firstVisible(root, selector) {
            if (!root) return null;
            var nodes = root.querySelectorAll(selector);
            for (var n = 0; n < nodes.length; n++) {
              var el = nodes[n];
              if (!el) continue;
              var r = el.getBoundingClientRect();
              var visible = (el.offsetParent !== null) && (r.width > 0) && (r.height > 0);
              if (visible) return el;
            }
            return null;
          }

          var rootStyle = getComputedStyle(document.documentElement);
          var navHRaw = (rootStyle.getPropertyValue('--nav-h') || '').trim();
          var navH = parseFloat(navHRaw);
          if (!isFinite(navH)) navH = 56;
          var vw = window.innerWidth || document.documentElement.clientWidth || 1200;
          var isDesktop = vw > 991;
          var availableH = window.innerHeight - navH;
          if (!isFinite(availableH) || availableH <= 0) availableH = window.innerHeight;

          var pages = document.querySelectorAll('.plotting-page');
          for (var i = 0; i < pages.length; i++) {
            var page = pages[i];
            var leftPanel = firstVisible(page, '.plotting-left-panel');
            if (!leftPanel) {
              page.classList.remove('float-left-panel');
              page.classList.remove('float-plot-area');
              continue;
            }

            var pageRect = page.getBoundingClientRect();
            var isVisible = (page.offsetParent !== null) && (pageRect.width > 0) && (pageRect.height > 0);
            if (!isDesktop || !isVisible) {
              page.classList.remove('float-left-panel');
              page.classList.remove('float-plot-area');
              continue;
            }

            var plotArea = firstVisible(page, '.plot_area_card_style');
            var leftH = Math.max(leftPanel.scrollHeight || 0, leftPanel.getBoundingClientRect().height || 0);
            var rightH = 0;

            // Per-page lock: keep left panel floating mode stable (no class flipping).
            if (page.classList.contains('qc-lock-left-float')) {
              page.classList.remove('float-plot-area');
              page.classList.add('float-left-panel');
              continue;
            }

            if (plotArea) {
              rightH = Math.max(plotArea.scrollHeight || 0, plotArea.getBoundingClientRect().height || 0);

              // Robust right-side content estimate (handles wrappers that under-report scrollHeight).
              var rightSum = 0;
              var kids = plotArea.children || [];
              for (var k = 0; k < kids.length; k++) {
                var r = kids[k].getBoundingClientRect();
                var cs = window.getComputedStyle(kids[k]);
                var mt = parseFloat(cs.marginTop || '0') || 0;
                var mb = parseFloat(cs.marginBottom || '0') || 0;
                rightSum += (r.height || 0) + mt + mb;
              }
              rightH = Math.max(rightH, rightSum);
            }
            if (!isFinite(rightH) || rightH <= 0) rightH = leftH;

            page.classList.remove('float-left-panel');
            page.classList.remove('float-plot-area');
            if (leftH >= rightH) {
              page.classList.add('float-plot-area');
            } else {
              page.classList.add('float-left-panel');
            }
          }
        }

        var timer = null;
        function syncSoon() {
          if (timer) window.clearTimeout(timer);
          timer = window.setTimeout(syncPlotPanelFloatingMode, 40);
        }

        if (document.readyState !== 'loading') syncSoon();
        document.addEventListener('DOMContentLoaded', syncSoon);
        document.addEventListener('shiny:connected', syncSoon);
        document.addEventListener('shown.bs.tab', syncSoon, true);
        document.addEventListener('shown.bs.collapse', syncSoon, true);
        document.addEventListener('hidden.bs.collapse', syncSoon, true);
        window.addEventListener('resize', syncSoon);
        window.addEventListener('load', syncSoon);

        var obs = new MutationObserver(syncSoon);
        obs.observe(document.documentElement, { childList: true, subtree: true });
      })();
    ")),
    tags$script(HTML("
      (function () {
        // Global slider policy: debounce reactive updates so expensive renders
        // trigger once after drag settles, instead of on every tiny movement.
        function patchSliderRatePolicy() {
          if (!window.Shiny || !Shiny.inputBindings || !Shiny.inputBindings.bindingNames) return;
          var rec = Shiny.inputBindings.bindingNames['shiny.sliderInput'];
          if (!rec || !rec.binding) return;
          var binding = rec.binding;
          if (binding.__wanlabDebouncePatched) return;
          binding.getRatePolicy = function() {
            return { policy: 'debounce', delay: 220 };
          };
          binding.__wanlabDebouncePatched = true;
        }

        if (document.readyState !== 'loading') setTimeout(patchSliderRatePolicy, 0);
        document.addEventListener('DOMContentLoaded', patchSliderRatePolicy);
        document.addEventListener('shiny:connected', patchSliderRatePolicy);
      })();
    ")),
    tags$script(HTML("
      (function () {
        function syncTabPillIndicators() {
          var navs = document.querySelectorAll(
            '.tabbable > .nav.nav-tabs, .tabbable > .nav.nav-pills, ' +
            '.app-tabs-wrap .nav.nav-tabs, .app-tabs-wrap .nav.nav-pills'
          );

          for (var i = 0; i < navs.length; i++) {
            var nav = navs[i];
            if (!nav) continue;
            nav.classList.add('app-tab-pill-track');

            if (!nav.dataset.pillScrollBound) {
              nav.addEventListener('scroll', function () {
                syncTabPillIndicators();
              }, { passive: true });
              nav.dataset.pillScrollBound = '1';
            }

            var active = nav.querySelector(
              'li.active > a, .nav-item.active > a, .nav-link.active'
            );

            if (!active) {
              nav.style.setProperty('--app-tab-pill-w', '0px');
              continue;
            }

            var activeItem = active.closest('li, .nav-item');
            var x = ((activeItem ? activeItem.offsetLeft : 0) + active.offsetLeft) + nav.scrollLeft;
            var w = active.offsetWidth;
            if (!isFinite(x)) x = 0;
            if (!isFinite(w)) w = 0;
            nav.style.setProperty('--app-tab-pill-x', x + 'px');
            nav.style.setProperty('--app-tab-pill-w', w + 'px');
          }
        }

        function fitTabLabels() {
          var nodes = document.querySelectorAll(
            '.tabbable > .nav.nav-tabs a, .tabbable > .nav.nav-tabs .nav-link, ' +
            '.tabbable > .nav.nav-pills a, .tabbable > .nav.nav-pills .nav-link, ' +
            '.app-tabs-wrap .nav.nav-tabs a, .app-tabs-wrap .nav.nav-tabs .nav-link, ' +
            '.app-tabs-wrap .nav.nav-pills a, .app-tabs-wrap .nav.nav-pills .nav-link'
          );
          for (var i = 0; i < nodes.length; i++) {
            var el = nodes[i];
            if (!el) continue;
            el.classList.remove('app-tab-fit-sm');
            el.classList.remove('app-tab-fit-xs');
            if (el.scrollWidth > el.clientWidth + 2) {
              el.classList.add('app-tab-fit-sm');
            }
            if (el.scrollWidth > el.clientWidth + 2) {
              el.classList.add('app-tab-fit-xs');
            }
          }
          syncTabPillIndicators();
        }

        var timer = null;
        function fitSoon() {
          if (timer) window.clearTimeout(timer);
          timer = window.setTimeout(fitTabLabels, 30);
        }

        if (document.readyState !== 'loading') fitSoon();
        document.addEventListener('DOMContentLoaded', fitSoon);
        document.addEventListener('shiny:connected', fitSoon);
        document.addEventListener('shown.bs.tab', fitSoon, true);
        window.addEventListener('resize', fitSoon);

        var obs = new MutationObserver(fitSoon);
        obs.observe(document.documentElement, { childList: true, subtree: true });
      })();
    ")),
    tags$script(HTML("
      (function () {
        // Global Plotly modebar export policy:
        // - Keep modebar UX, but ensure two explicit export buttons: SVG and PNG.
        var PNG_SCALE = 4; // high-resolution raster fallback (Plotly uses scale, not direct DPI)

        function safeFilename(s) {
          return (s || 'plot_export')
            .toString()
            .trim()
            .replace(/\\s+/g, '_')
            .replace(/[^A-Za-z0-9_\\-]/g, '');
        }

        function ensureDualExportButtons(gd) {
          if (!gd || !window.Plotly || !Plotly.downloadImage) return;
          var modebar = gd.querySelector('.modebar');
          if (!modebar) return;

          var cameraBtn = modebar.querySelector('.modebar-btn[data-title*=\"Download plot\"]');
          if (!cameraBtn) cameraBtn = modebar.querySelector('.modebar-btn');
          if (!cameraBtn) return;

          var baseName = safeFilename(
            (gd.layout && gd.layout.title && (gd.layout.title.text || gd.layout.title)) ||
            gd.id ||
            'plot_export'
          );

          // Do not duplicate on repeated renders
          if (modebar.querySelector('.modebar-btn.custom-export-svg') &&
              modebar.querySelector('.modebar-btn.custom-export-png')) {
            // Keep legacy default camera hidden if it reappears.
            if (!cameraBtn.classList.contains('custom-export-svg') && !cameraBtn.classList.contains('custom-export-png')) {
              cameraBtn.style.display = 'none';
            }
            return;
          }

          // Hide original one-button export to avoid confusion.
          cameraBtn.style.display = 'none';

          var svgBtn = cameraBtn.cloneNode(true);
          svgBtn.classList.add('custom-export-svg');
          svgBtn.style.display = '';
          svgBtn.setAttribute('data-title', 'Download SVG');
          svgBtn.setAttribute('title', 'Download SVG');
          svgBtn.onclick = function(e) {
            e.preventDefault();
            e.stopPropagation();
            Plotly.downloadImage(gd, { format: 'svg', filename: baseName + '_svg' });
            return false;
          };

          var pngBtn = cameraBtn.cloneNode(true);
          pngBtn.classList.add('custom-export-png');
          pngBtn.style.display = '';
          pngBtn.setAttribute('data-title', 'Download PNG (high resolution)');
          pngBtn.setAttribute('title', 'Download PNG (high resolution)');
          pngBtn.onclick = function(e) {
            e.preventDefault();
            e.stopPropagation();
            Plotly.downloadImage(gd, { format: 'png', filename: baseName + '_png', scale: PNG_SCALE });
            return false;
          };

          cameraBtn.parentNode.appendChild(svgBtn);
          cameraBtn.parentNode.appendChild(pngBtn);
        }

        function scanAndApply() {
          var nodes = document.querySelectorAll('.js-plotly-plot');
          for (var i = 0; i < nodes.length; i++) ensureDualExportButtons(nodes[i]);
        }

        document.addEventListener('plotly_afterplot', function (ev) {
          ensureDualExportButtons(ev && ev.target);
        }, true);

        document.addEventListener('DOMContentLoaded', function () {
          scanAndApply();
          setTimeout(scanAndApply, 400);
          setTimeout(scanAndApply, 1200);
        });

        // Handle dynamically inserted outputs from Shiny re-rendering.
        var mo = new MutationObserver(function () { scanAndApply(); });
        mo.observe(document.documentElement, { childList: true, subtree: true });
      })();
    ")),
    tags$script(HTML("
      (function () {
        // Global slider optimization:
        // suppress reactive updates while dragging; allow update on mouse/touch release.
        var draggingSliderIds = new Set();

        function markDraggingFromHandle(el) {
          var irs = el.closest('.irs');
          if (!irs) return;
          var input = irs.previousElementSibling;
          if (!input) return;
          if (!input.id) return;
          if (!input.classList.contains('js-range-slider')) return;
          draggingSliderIds.add(input.id);
        }

        document.addEventListener('mousedown', function (ev) {
          var t = ev.target;
          if (!t) return;
          if (t.closest('.irs-handle') || t.closest('.irs-slider') || t.closest('.irs-line') || t.closest('.irs-bar')) {
            markDraggingFromHandle(t);
          }
        }, true);

        document.addEventListener('touchstart', function (ev) {
          var t = ev.target;
          if (!t) return;
          if (t.closest('.irs-handle') || t.closest('.irs-slider') || t.closest('.irs-line') || t.closest('.irs-bar')) {
            markDraggingFromHandle(t);
          }
        }, true);

        function clearDraggingSetSoon() {
          // Let the final post-release slider event pass through first.
          setTimeout(function () { draggingSliderIds.clear(); }, 0);
        }

        document.addEventListener('mouseup', clearDraggingSetSoon, true);
        document.addEventListener('touchend', clearDraggingSetSoon, true);
        document.addEventListener('touchcancel', clearDraggingSetSoon, true);

        $(document).on('shiny:inputchanged', function (ev) {
          // Block intermediate updates while user is dragging slider handles.
          if (!ev || !ev.name) return;
          if (draggingSliderIds.has(ev.name)) {
            ev.preventDefault();
          }
        });
      })();
    ")),
    tags$script(HTML("
      (function () {
        var bound = false;

        function showGlobalOverlayNow(text) {
          var msg = (typeof text === 'string' && text.length) ? text : 'Reading and inspecting .rds file...';

          // Preferred path: use shared overlay API when available.
          if (window.WLSpinnerOverlay && typeof window.WLSpinnerOverlay.show === 'function') {
            window.WLSpinnerOverlay.show({ id: 'global_overlay', text: msg });
            return;
          }

          // Fallback path: direct DOM show (defensive if API not yet attached).
          var el = document.getElementById('global_overlay');
          if (!el) return;
          var msgEl = el.querySelector('.so-message');
          if (msgEl) msgEl.textContent = msg;
          el.style.display = 'flex';
        }

        var uploadPollTimer = null;
        function startUploadProgressPoll() {
          if (uploadPollTimer) {
            clearInterval(uploadPollTimer);
            uploadPollTimer = null;
          }
          var ticks = 0;
          uploadPollTimer = setInterval(function () {
            ticks += 1;
            var bar = document.querySelector('#import_rds_file_progress .progress-bar');
            var w = bar ? parseFloat((bar.style.width || '0').replace('%', '')) : 0;
            if (isFinite(w) && w >= 100) {
              showGlobalOverlayNow('Reading and inspecting .rds file...');
              clearInterval(uploadPollTimer);
              uploadPollTimer = null;
              return;
            }
            // safety stop after ~60s to avoid long-running timer
            if (ticks >= 300) {
              clearInterval(uploadPollTimer);
              uploadPollTimer = null;
            }
          }, 200);
        }

        function bindRdsUploadOverlayHooks() {
          if (bound || !window.jQuery) return;
          bound = true;

          // Primary trigger: fires when Shiny completes browser-side file upload binding.
          window.jQuery(document).on('shiny:inputchanged.rdsUploadOverlayGlobal', function (evt) {
            if (!evt || evt.name !== 'import_rds_file') return;
            if (evt.inputType && evt.inputType !== 'shiny.fileupload') return;
            showGlobalOverlayNow('Reading and inspecting .rds file...');
          });

          // Fallback trigger: file chooser changed (covers edge cases where inputType differs).
          window.jQuery(document).on('change.rdsUploadOverlayGlobal', '#import_rds_file', function () {
            showGlobalOverlayNow('Uploading and preparing .rds import...');
            startUploadProgressPoll();
          });
        }

        if (document.readyState !== 'loading') bindRdsUploadOverlayHooks();
        document.addEventListener('DOMContentLoaded', bindRdsUploadOverlayHooks);
        document.addEventListener('shiny:connected', bindRdsUploadOverlayHooks);
      })();
    ")),
    tags$script(HTML("
      (function () {
        if (window.__wanlab_leave_guard_v1) return;
        window.__wanlab_leave_guard_v1 = true;

        var unloadWarning = 'Leaving or refreshing this page will clear unsaved in-memory workspace data. Save Workspace first.';
        var backWarning = 'Go back and leave this session? Unsaved in-memory workspace data will be lost.';
        var allowExit = false;

        function beforeUnloadHandler(event) {
          if (allowExit) return undefined;
          if (event) {
            event.preventDefault();
            event.returnValue = unloadWarning;
          }
          return unloadWarning;
        }

        window.addEventListener('beforeunload', beforeUnloadHandler);

        try {
          window.history.pushState({ wanlabGuard: true }, document.title, window.location.href);
        } catch (e) {}

        window.addEventListener('popstate', function () {
          if (allowExit) return;
          var leave = window.confirm(backWarning);
          if (leave) {
            allowExit = true;
            window.removeEventListener('beforeunload', beforeUnloadHandler);
            setTimeout(function () { window.history.back(); }, 0);
            return;
          }
          try {
            window.history.pushState({ wanlabGuard: true }, document.title, window.location.href);
          } catch (e) {}
        });
      })();
    ")),
    tags$script(HTML("
      (function () {
        if (window.__wanlab_plot_structure_flag_v1) return;
        window.__wanlab_plot_structure_flag_v1 = true;

        function hasStandardLaneRow(page) {
          var rows = page.querySelectorAll('.row');
          for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            var children = row.children;
            var hasLeft = false;
            var hasRight = false;
            for (var j = 0; j < children.length; j++) {
              var el = children[j];
              if (!(el instanceof Element)) continue;
              if (el.classList.contains('plotting-left-panel')) hasLeft = true;
              if (el.classList.contains('plot_area_card_style')) hasRight = true;
            }
            if (hasLeft && hasRight) return true;
          }
          return false;
        }

        function findTitleAnchor(page) {
          var cardTitle = page.querySelector('.card-page-title');
          if (cardTitle) return cardTitle;
          var pageHeaderH2 = page.querySelector('.page-header h2');
          if (pageHeaderH2) return pageHeaderH2;
          var h2 = page.querySelector('h2');
          if (h2) return h2;
          return null;
        }

        function ensureFlag(page) {
          var title = findTitleAnchor(page);
          if (!title) return;
          var existing = title.querySelector('.ui-structure-flag');
          var shouldFlag = !hasStandardLaneRow(page);
          if (shouldFlag && !existing) {
            var flag = document.createElement('span');
            flag.className = 'ui-structure-flag';
            flag.textContent = 'conflicting UI structure';
            title.appendChild(flag);
          } else if (!shouldFlag && existing) {
            existing.remove();
          }
        }

        function applyFlags() {
          var pages = document.querySelectorAll('.app-page.plotting-page');
          for (var i = 0; i < pages.length; i++) ensureFlag(pages[i]);
        }

        if (document.readyState !== 'loading') applyFlags();
        document.addEventListener('DOMContentLoaded', applyFlags);
        document.addEventListener('shown.bs.tab', function () {
          window.requestAnimationFrame(applyFlags);
        });
        document.addEventListener('shiny:value', function () {
          window.requestAnimationFrame(applyFlags);
        });

        var mo = new MutationObserver(function () {
          window.requestAnimationFrame(applyFlags);
        });
        mo.observe(document.documentElement, { childList: true, subtree: true });
      })();
    "))
  ),
  overlay_deps(),
  overlay_ui("global_overlay", default_text = "Working..."),
  wan_lab_navbar(
    id = "main_navbar",
    theme = my_theme,
    welcome_ui = welcome_ui,
    environment_ui = environment_ui,
    qc_ui = qc_ui,
    contamination_correction_ui = contamination_correction_ui,
    hto_ui = hto_ui,
    doublet_ui = doublet_ui,
    vdj_ui = vdj_ui,
    barcode_ui = barcode_ui,
    flowgate_ui = flowgate_ui,
    atac_qc_ui = atac_qc_ui,
    analysis_ui = analysis_ui,
    data_browser_ui = data_browser_ui,
    recluster_ui = recluster_ui,
    recluster_new_ui = recluster_new_ui,
    rna_velocity_ui = rna_velocity_ui,
    rna_velocity_v052_ui = rna_velocity_v052_ui,
    multiome_wnn_ui = multiome_wnn_ui,
    multiome_marker_ui = multiome_marker_ui,
    cellchat_ui = cellchat_ui,
    scenic_ui = scenic_ui,
    monocle2_ui = monocle2_ui,
    nichenet_ui = nichenet_ui,
    niches_ui = niches_ui,
    sctenifoldknk_ui = sctenifoldknk_ui,
    cellwhisperer_ui = cellwhisperer_ui,
    figure_umap_ui = figure_umap_ui,
    figure_feature_ui = figure_feature_ui,
    figure_dotplot_ui = figure_dotplot_ui,
    figure_alluvial_ui = figure_alluvial_ui,
    figure_cluster_alluvial_ui = figure_cluster_alluvial_ui,
    figure_tcr_studio_ui = figure_tcr_studio_ui,
    figure_pseudobulk_volcano_hidden_ui = figure_pseudobulk_volcano_ui,
    export_ui = export_ui,
    export_vdj_safe_ui = export_vdj_safe_ui,
    multiome_export_check_ui = multiome_export_check_ui,
    rds_ui = rds_ui,
    right_sidebar_ui = right_sidebar_ui("right_sidebar"),
    APP_VERSION = APP_VERSION
  ),
  # We place the footer here. Note: If page_navbar creates a full-screen layout, 
  # this footer might be pushed off-screen or require scrolling.
  wan_lab_footer(APP_VERSION = APP_VERSION)
)

# ---- Server ----
server <- function(input, output, session) {
  useShinyjs()
  
  # --- Shared State ---
  shared_data <- reactiveValues(
    active_environment = list(name = NULL, path = NULL),
    core_variant = "seurat_v4",
    full_sample_sheet = NULL,
    all_seurat_objects = list(),
    analysis_params_by_page = list(),
    active_object_name = NULL,
    imported_tabular_files = data.frame(name = character(0), path = character(0), type = character(0), stringsAsFactors = FALSE),
    selected_sidebar_items = NULL,
    request_import_modal = 0L,
    admin_force_enable_all_menus = FALSE,
    admin_unlocked_tabs = character(0),
    admin_locked_nav_values = setdiff(wanlab_admin_gated_tabs(), "recluster_new_tab"),
    admin_enable_seurat5 = TRUE,
    pending_import_auto_route = NULL,
    workflow_mode = "manual",
    fast_prepare_env_request = 0L,
    fast_loupe = list(
      run_id = 0L,
      status = "idle",
      phase = "idle",
      started_at = NULL,
      baseline_names = character(0),
      imported_names = character(0),
      message = "",
      error = NULL
    ),
    qc_completed = FALSE,
    has_atac_data = FALSE,
    filtered_objects = list(),
    analysis_boot = reactiveValues(active_object = NULL)
  )

  .sync_registry_to_canonical <- function() {
    reg_now <- shared_data$all_seurat_objects %||% list()
    reg_new <- wanlab_canonicalize_registry(reg_now, sample_sheet = shared_data$full_sample_sheet)
    old_names <- names(reg_now %||% list()) %||% character(0)
    new_names <- names(reg_new %||% list()) %||% character(0)
    shape_changed <- !identical(old_names, new_names) ||
      length(reg_now) != length(reg_new) ||
      any(vapply(reg_new, function(ent) {
        !is.list(ent) || is.null(ent$obj) || is.null(ent$prefs) || is.null(ent$plots) || is.null(ent$analysis_cache)
      }, logical(1)))
    if (isTRUE(shape_changed)) {
      shared_data$all_seurat_objects <- reg_new
    }
    valid_names <- names(shared_data$all_seurat_objects %||% list()) %||% character(0)
    active_nm <- as.character(shared_data$active_object_name %||% "")
    if (!nzchar(active_nm) || !(active_nm %in% valid_names)) {
      shared_data$active_object_name <- if (length(valid_names)) valid_names[[1]] else NULL
    }
    shared_data$object_prefs <- lapply(shared_data$all_seurat_objects %||% list(), function(ent) {
      if (is.list(ent) && is.list(ent$prefs)) ent$prefs else list()
    })
    invisible(NULL)
  }
  observeEvent(shared_data$all_seurat_objects, {
    .sync_registry_to_canonical()
  }, ignoreInit = FALSE)

  emergency_recovery_triggered <- FALSE
  emergency_recovery_modal_shown <- FALSE
  emergency_recovery_prompt_shown <- FALSE
  emergency_recovery_pending_reason <- NULL
  emergency_recovery_pending_err <- NULL

  .safe_isolate <- function(expr, default = NULL) {
    tryCatch(isolate(expr), error = function(e) default)
  }

  .sync_sheet_from_registry <- function(registry, current_sheet = NULL) {
    reg <- registry %||% list()
    reg_names <- as.character(names(reg) %||% character(0))
    reg_names <- reg_names[!is.na(reg_names) & nzchar(reg_names)]
    if (!length(reg_names)) {
      return(data.frame(
        name = character(0),
        path = character(0),
        type = character(0),
        condition = character(0),
        batch = character(0),
        min_features = numeric(0),
        max_features = numeric(0),
        min_umi_counts = numeric(0),
        max_umi_counts = numeric(0),
        max_mt_percent = numeric(0),
        use_in_analysis = logical(0),
        qc_status = character(0),
        stringsAsFactors = FALSE
      ))
    }

    # Keep canonical sheet focused on source/raw samples only.
    keep_names <- reg_names[!grepl("(_rna_filtered|_filtered)(?:_[0-9]+)?$", reg_names, ignore.case = TRUE)]
    if (!length(keep_names)) keep_names <- reg_names

    sheet <- if (is.data.frame(current_sheet)) current_sheet else data.frame(stringsAsFactors = FALSE)
    if (!nrow(sheet)) {
      sheet <- data.frame(
        name = character(0),
        path = character(0),
        type = character(0),
        condition = character(0),
        batch = character(0),
        min_features = numeric(0),
        max_features = numeric(0),
        min_umi_counts = numeric(0),
        max_umi_counts = numeric(0),
        max_mt_percent = numeric(0),
        use_in_analysis = logical(0),
        qc_status = character(0),
        stringsAsFactors = FALSE
      )
    }

    need_cols <- c("name","path","type","condition","batch","min_features","max_features","min_umi_counts","max_umi_counts","max_mt_percent","use_in_analysis","qc_status")
    for (cc in setdiff(need_cols, names(sheet))) sheet[[cc]] <- NA
    sheet <- sheet[, need_cols, drop = FALSE]

    rows <- lapply(keep_names, function(nm) {
      i <- match(nm, as.character(sheet$name %||% character(0)))
      entry <- reg[[nm]]
      meta <- if (is.list(entry) && !is.null(entry$meta)) entry$meta else list()
      source_path <- as.character(meta$source_path %||% "")
      if (!nzchar(source_path)) source_path <- paste0("registry::", nm)

      if (!is.na(i)) {
        row <- sheet[i, , drop = FALSE]
      } else {
        row <- data.frame(
          name = nm,
          path = source_path,
          type = "h5",
          condition = "Unknown",
          batch = "Batch1",
          min_features = 200,
          max_features = 5000,
          min_umi_counts = 500,
          max_umi_counts = 50000,
          max_mt_percent = 20,
          use_in_analysis = TRUE,
          qc_status = "Pending",
          stringsAsFactors = FALSE
        )
      }

      row$name <- nm
      if (is.na(row$path) || !nzchar(as.character(row$path))) row$path <- source_path
      if (is.na(row$condition) || !nzchar(as.character(row$condition))) row$condition <- "Unknown"
      if (is.na(row$batch) || !nzchar(as.character(row$batch))) row$batch <- "Batch1"
      if (is.na(row$type) || !nzchar(as.character(row$type))) row$type <- "h5"
      if (is.na(row$qc_status) || !nzchar(as.character(row$qc_status))) row$qc_status <- "Pending"
      if (is.na(row$use_in_analysis)) row$use_in_analysis <- TRUE
      row
    })

    out <- do.call(rbind, rows)
    rownames(out) <- NULL
    out
  }

  .emergency_recovery_bundle <- function(reason = "Unhandled error", err = NULL, include_objects = TRUE) {
    export_time <- format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")
    all_objs <- if (isTRUE(include_objects)) .safe_isolate(shared_data$all_seurat_objects %||% list(), default = list()) else list()
    filtered_objs <- if (isTRUE(include_objects)) .safe_isolate(shared_data$filtered_objects %||% list(), default = list()) else list()
    imported_tabular <- .safe_isolate(shared_data$imported_tabular_files %||% data.frame(), default = data.frame())
    analysis_params <- .safe_isolate(shared_data$analysis_params_by_page %||% list(), default = list())
    active_env <- .safe_isolate(shared_data$active_environment %||% list(name = NULL, path = NULL), default = list(name = NULL, path = NULL))
    active_obj_name <- .safe_isolate(shared_data$active_object_name %||% NA_character_, default = NA_character_)
    pipeline_sheet <- .safe_isolate(shared_data$full_sample_sheet, default = NULL)
    analysis_active_obj <- .safe_isolate(shared_data$analysis_boot$active_object %||% NULL, default = NULL)
    seurat_ver <- tryCatch(as.character(utils::packageVersion("Seurat")), error = function(e) NA_character_)

    list(
      app_version = APP_VERSION,
      exported_at = export_time,
      pipeline_info = list(
        pipeline_version = APP_VERSION,
        analysis_date = export_time,
        exported_at = export_time,
        active_environment = active_env$name %||% NA_character_,
        seurat_version = seurat_ver
      ),
      emergency_recovery = list(
        reason = as.character(reason %||% "Unhandled error"),
        error_message = as.character(
          if (inherits(err, "condition")) conditionMessage(err) else (as.character(err %||% "unknown error"))
        ),
        include_objects = isTRUE(include_objects)
      ),
      all_seurat_objects = all_objs,
      filtered_objects = filtered_objs,
      full_sample_sheet = pipeline_sheet,
      active_object_name = active_obj_name,
      imported_tabular_files = imported_tabular,
      analysis_params_by_page = analysis_params,
      analysis_boot_active_object = analysis_active_obj,
      session_info = capture.output(utils::sessionInfo())
    )
  }

  .emergency_recovery_output_dir <- function() {
    project_root <- tryCatch(normalizePath(here::here(".."), winslash = "/", mustWork = FALSE), error = function(e) here::here(".."))
    candidates <- c(
      file.path(project_root, "emergency_recovery"),
      file.path(tempdir(), "wan_lab_single_cell_emergency_recovery")
    )
    for (out_dir in candidates) {
      ok <- tryCatch({
        dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
        test_path <- tempfile(".write_test_", tmpdir = out_dir)
        suppressWarnings(writeLines("ok", con = test_path, useBytes = TRUE))
        unlink(test_path)
        TRUE
      }, error = function(e) FALSE)
      if (isTRUE(ok)) return(out_dir)
    }
    stop("No writable emergency recovery output directory is available.")
  }

  .write_emergency_recovery_rds <- function(reason = "Unhandled error", err = NULL) {
    out_dir <- .emergency_recovery_output_dir()
    stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
    full_path <- file.path(out_dir, paste0("emergency_workspace_", stamp, ".rds"))

    full_ok <- tryCatch({
      saveRDS(.emergency_recovery_bundle(reason = reason, err = err, include_objects = TRUE), file = full_path, compress = FALSE)
      TRUE
    }, error = function(e) FALSE)

    if (isTRUE(full_ok)) {
      return(list(path = full_path, minimal = FALSE))
    }

    minimal_path <- file.path(out_dir, paste0("emergency_workspace_", stamp, "_minimal.rds"))
    saveRDS(.emergency_recovery_bundle(reason = reason, err = err, include_objects = FALSE), file = minimal_path, compress = FALSE)
    list(path = minimal_path, minimal = TRUE)
  }

  .show_emergency_recovery_modal <- function(path, minimal = FALSE) {
    if (isTRUE(emergency_recovery_modal_shown)) return(invisible(NULL))
    emergency_recovery_modal_shown <<- TRUE
    showModal(modalDialog(
      title = "Emergency Recovery Created",
      easyClose = TRUE,
      footer = modalButton("Close"),
      p("A crash recovery snapshot was saved."),
      p(
        if (isTRUE(minimal)) {
          "A minimal snapshot was saved because the full object save failed."
        } else {
          "A full workspace snapshot was saved."
        }
      ),
      tags$p(tags$b("File path:")),
      tags$pre(style = "white-space:pre-wrap; word-break:break-all;", path)
    ))
  }

  .show_emergency_recovery_confirm_modal <- function(reason = "Unhandled error", err = NULL) {
    if (isTRUE(emergency_recovery_prompt_shown) || isTRUE(emergency_recovery_triggered)) return(invisible(NULL))
    emergency_recovery_prompt_shown <<- TRUE
    emergency_recovery_pending_reason <<- reason
    emergency_recovery_pending_err <<- err

    err_msg <- as.character(
      if (inherits(err, "condition")) conditionMessage(err) else (as.character(err %||% "unknown error"))
    )
    if (!nzchar(err_msg)) err_msg <- "unknown error"

    showModal(modalDialog(
      title = "Critical Error Detected",
      easyClose = FALSE,
      footer = tagList(
        actionButton("emergency_snapshot_skip_btn", "Skip"),
        actionButton("emergency_snapshot_save_btn", "Save Snapshot", class = "btn-danger")
      ),
      p("A critical error occurred."),
      p("Would you like to save an emergency recovery snapshot now?"),
      tags$p(tags$b("Error message:")),
      tags$pre(style = "white-space:pre-wrap; word-break:break-all;", err_msg)
    ))
    invisible(NULL)
  }

  .emergency_ui_lock <- function(active = TRUE) {
    if (isTRUE(active)) {
      msg <- "A critical error occurred. Saving emergency recovery snapshot..."
      try(overlay_show(text = msg), silent = TRUE)
      shinyjs::runjs(
        "(function(){document.body.classList.add('wl-emergency-lock');if(window.WLSpinnerOverlay&&typeof window.WLSpinnerOverlay.show==='function'){window.WLSpinnerOverlay.show({id:'global_overlay',text:'A critical error occurred. Saving emergency recovery snapshot...'});}})();"
      )
      return(invisible(NULL))
    }
    shinyjs::runjs("(function(){document.body.classList.remove('wl-emergency-lock');})();")
    try(overlay_hide(), silent = TRUE)
    invisible(NULL)
  }

  .trigger_emergency_recovery <- function(reason = "Unhandled error", err = NULL) {
    if (isTRUE(emergency_recovery_triggered) || isTRUE(emergency_recovery_prompt_shown)) return(invisible(NULL))
    .show_emergency_recovery_confirm_modal(reason = reason, err = err)
    invisible(NULL)
  }

  observeEvent(input$emergency_snapshot_skip_btn, {
    if (isTRUE(emergency_recovery_triggered)) return()
    emergency_recovery_triggered <<- TRUE
    emergency_recovery_prompt_shown <<- FALSE
    emergency_recovery_pending_reason <<- NULL
    emergency_recovery_pending_err <<- NULL
    removeModal()
    showNotification("Emergency snapshot skipped by user.", type = "warning", duration = 8)
  }, ignoreInit = TRUE)

  observeEvent(input$emergency_snapshot_save_btn, {
    if (isTRUE(emergency_recovery_triggered)) return()
    emergency_recovery_triggered <<- TRUE
    emergency_recovery_prompt_shown <<- FALSE
    removeModal()

    reason <- emergency_recovery_pending_reason %||% "Unhandled error"
    err <- emergency_recovery_pending_err
    emergency_recovery_pending_reason <<- NULL
    emergency_recovery_pending_err <<- NULL

    .emergency_ui_lock(TRUE)
    on.exit(.emergency_ui_lock(FALSE), add = TRUE)

    saved <- tryCatch(
      .write_emergency_recovery_rds(reason = reason, err = err),
      error = function(e) list(path = NA_character_, minimal = TRUE)
    )

    out_path <- as.character(saved$path %||% NA_character_)
    if (nzchar(out_path) && !is.na(out_path)) {
      showNotification("Emergency recovery RDS saved.", type = "error", duration = 10)
      .show_emergency_recovery_modal(path = out_path, minimal = isTRUE(saved$minimal))
    } else {
      showNotification("Emergency recovery failed: snapshot could not be written.", type = "error", duration = 12)
    }
  }, ignoreInit = TRUE)

  .previous_shiny_error_handler <- getOption("shiny.error")
  options(shiny.error = function(...) {
    args <- list(...)
    err <- if (length(args)) args[[1]] else NULL
    err_msg <- tryCatch(conditionMessage(err), error = function(e) as.character(err %||% ""))
    err_class <- tryCatch(paste(class(err), collapse = ","), error = function(e) "")
    call_tail <- tryCatch({
      cls <- sys.calls()
      if (!length(cls)) return(character(0))
      tail(vapply(cls, function(cl) paste(deparse(cl), collapse = " "), character(1)), 20L)
    }, error = function(e) character(0))
    tb_lines <- tryCatch(utils::capture.output(traceback(50)), error = function(e) character(0))
    trace_path <- tryCatch({
      out_dir <- .emergency_recovery_output_dir()
      stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
      p <- file.path(out_dir, paste0("app_error_trace_", stamp, ".log"))
      details <- c(
        sprintf("timestamp: %s", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
        sprintf("error_class: %s", err_class),
        sprintf("error_message: %s", err_msg),
        "---- call_tail ----",
        if (length(call_tail)) call_tail else "<empty>",
        "---- traceback ----",
        if (length(tb_lines)) tb_lines else "<empty>"
      )
      writeLines(details, con = p, useBytes = TRUE)
      p
    }, error = function(e) "")
    message(sprintf("[APP ERROR][%s] %s", format(Sys.time(), "%H:%M:%OS3"), err_msg))
    if (nzchar(trace_path)) {
      message("[APP ERROR] trace log: ", trace_path)
    }
    if (length(call_tail)) {
      message("[APP ERROR] call tail:")
      message(paste(call_tail, collapse = "\n"))
    }
    .trigger_emergency_recovery(reason = "Unhandled Shiny error", err = err)
    if (is.function(.previous_shiny_error_handler)) {
      .previous_shiny_error_handler(...)
    }
    invisible(NULL)
  })

  session$onSessionEnded(function() {
    options(shiny.error = .previous_shiny_error_handler)
  })

  .canonicalize_env_path <- function(p) {
    p <- as.character(p %||% "")
    if (!nzchar(p)) return("")
    p <- gsub("\\\\", "/", p)
    p2 <- sub("(^|/)package_libraries_user(/|$)", "\\1package_libraries\\2", p, perl = TRUE)
    p2 <- tryCatch(normalizePath(p2, winslash = "/", mustWork = FALSE), error = function(e) p2)
    p2
  }

  .canonicalize_active_environment <- function(env) {
    env <- env %||% list()
    env$path <- .canonicalize_env_path(env$path %||% "")
    core_paths <- as.character(unlist(env$core_paths %||% character(0), use.names = FALSE))
    if (length(core_paths)) {
      core_paths <- vapply(core_paths, .canonicalize_env_path, character(1))
      core_paths <- unique(core_paths[nzchar(core_paths)])
      env$core_paths <- core_paths
    }
    env
  }

  observe({
    # Startup signal: app should be launched via Content/run.R bootstrap.
    project_root <- tryCatch(normalizePath(here::here(".."), winslash = "/", mustWork = FALSE), error = function(e) "")
    pointer_file <- if (nzchar(project_root)) file.path(project_root, "package_libraries_location.txt") else ""
    env_root <- ""
    if (nzchar(pointer_file) && file.exists(pointer_file)) {
      pointer_lines <- tryCatch(readLines(pointer_file, warn = FALSE), error = function(e) character(0))
      env_line <- pointer_lines[grepl("^env_root\\s*:", pointer_lines, ignore.case = TRUE)]
      if (length(env_line)) {
        env_root <- trimws(sub("^[^:]*:\\s*", "", env_line[1]))
      }
    }

    env_status <- trimws(Sys.getenv("WANLAB_BOOTSTRAP_STATUS_FILE", ""))
    status_candidates <- c(
      env_status,
      if (nzchar(project_root)) file.path(project_root, "package_libraries", "bootstrap_status.txt") else "",
      if (nzchar(env_root)) file.path(env_root, "bootstrap_status.txt") else ""
    )
    status_candidates <- unique(status_candidates[nzchar(status_candidates)])
    status_found <- any(vapply(status_candidates, file.exists, logical(1)))

    if (!isTRUE(status_found)) {
      showNotification(
        "Launcher bootstrap status not found. Please start via Content/run.R so required packages are checked/installed before app startup.",
        type = "warning",
        duration = NULL,
        id = "bootstrap_status_missing"
      )
    } else {
      removeNotification("bootstrap_status_missing")
    }
  })

  .snapshot_inputs <- function(ids = NULL, prefixes = NULL) {
    vals <- reactiveValuesToList(input, all.names = TRUE)
    nms <- names(vals) %||% character(0)
    keep <- character(0)
    if (!is.null(ids)) keep <- c(keep, intersect(ids, nms))
    if (!is.null(prefixes) && length(prefixes)) {
      for (rx in prefixes) keep <- c(keep, grep(rx, nms, value = TRUE))
    }
    keep <- unique(keep)
    if (!length(keep)) return(list())
    out <- vals[keep]
    out <- out[!grepl("_btn$|_rows_selected$|_cell_clicked$|_row_last_clicked$|_state$", names(out))]
    out
  }

  .record_page_params <- function(page_id, trigger_id, ids = NULL, prefixes = NULL, extra = list()) {
    params <- .snapshot_inputs(ids = ids, prefixes = prefixes)
    shared_data$analysis_params_by_page[[page_id]] <- list(
      last_used_params = params,
      trigger_id = trigger_id,
      updated_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"),
      extra = extra
    )
  }

  .restore_input_value <- function(id, v) {
    if (is.null(v)) return(invisible(NULL))
    vv <- v
    if (is.factor(vv)) vv <- as.character(vv)
    if (length(vv) == 1 && is.logical(vv)) {
      try(updateCheckboxInput(session, id, value = vv), silent = TRUE)
    }
    if (is.numeric(vv) && length(vv) == 1) {
      try(updateNumericInput(session, id, value = vv), silent = TRUE)
      try(updateSliderInput(session, id, value = vv), silent = TRUE)
    }
    if (is.numeric(vv) && length(vv) %in% c(2L)) {
      try(updateSliderInput(session, id, value = vv), silent = TRUE)
    }
    if ((is.character(vv) || is.factor(vv)) && length(vv) == 1) {
      sv <- as.character(vv[[1]])
      try(updateTextInput(session, id, value = sv), silent = TRUE)
      try(updateSelectInput(session, id, selected = sv), silent = TRUE)
      # Use client-side updates during global restore; server-side selectize
      # can trigger early filter/download requests before choices are ready.
      try(updateSelectizeInput(session, id, selected = sv, server = FALSE), silent = TRUE)
      try(updateRadioButtons(session, id, selected = sv), silent = TRUE)
    }
    if ((is.character(vv) || is.factor(vv)) && length(vv) > 1) {
      sv <- as.character(vv)
      # Use client-side updates during global restore; server-side selectize
      # can trigger early filter/download requests before choices are ready.
      try(updateSelectizeInput(session, id, selected = sv, server = FALSE), silent = TRUE)
      try(updateCheckboxGroupInput(session, id, selected = sv), silent = TRUE)
    }
    invisible(NULL)
  }

  .restore_page_params <- function(page_id, params_store = NULL) {
    store <- params_store %||% list()
    rec <- store[[page_id]]
    if (is.null(rec)) return(invisible(NULL))
    params <- rec$last_used_params %||% list()
    if (!length(params)) return(invisible(NULL))
    # Do not replay volatile Analysis startup bindings.
    # Restoring these from stale snapshots can force empty values during
    # initial hydration and create tab/selector oscillation.
    if (identical(page_id, "analysis")) {
      volatile_ids <- c(
        "plot_tabs",
        "active_object_name_input",
        "active_object_name_input_inline",
        "active_object_name_input_umap_inline"
      )
      params <- params[setdiff(names(params), volatile_ids)]
      if (!length(params)) return(invisible(NULL))
    }
    for (id in names(params)) {
      .restore_input_value(id, params[[id]])
    }
    invisible(NULL)
  }

  observeEvent(shared_data$all_seurat_objects, {
    reg <- shared_data$all_seurat_objects %||% list()
    cur <- shared_data$full_sample_sheet
    synced <- .sync_sheet_from_registry(reg, cur)
    cur_df <- if (is.data.frame(cur)) cur else data.frame(stringsAsFactors = FALSE)
    old_names <- as.character(cur$name %||% character(0))
    new_names <- as.character(synced$name %||% character(0))
    if (!identical(old_names, new_names) || nrow(synced) != nrow(cur_df)) {
      shared_data$full_sample_sheet <- synced
      return(invisible(NULL))
    }
    # Also apply when core metadata fields were missing/NA and got repaired.
    cur_common <- intersect(names(cur_df), names(synced))
    if (!identical(cur_df[, cur_common, drop = FALSE], synced[, cur_common, drop = FALSE])) {
      shared_data$full_sample_sheet <- synced
    }
    invisible(NULL)
  }, ignoreInit = FALSE)
  
  # --- Module Servers ---
  right_sidebar_server("right_sidebar", shared_data, session)
  
  welcome_server(input, output, session, shared_data = shared_data)
  environment_server(input, output, session, shared_data)
  qc_server(input, output, session, shared_data)
  
  module_init <- new.env(parent = emptyenv())
  for (nm in c(
    "contam", "hto", "doublet", "vdj", "barcode", "flowgate",
    "atac_qc", "analysis", "recluster", "recluster_new", "multiome_wnn",
    "cellchat", "scenic", "monocle2", "nichenet", "niches", "sctenifoldknk", "rna_velocity_v052",
    "multiome_marker", "export", "export_vdj_safe", "multiome_export_check",
    "rds", "figure_umap", "figure_feature", "figure_dotplot", "figure_alluvial", "figure_cluster_alluvial", "figure_tcr_studio", "figure_color_picker_lab", "figure_poline_lab", "cellwhisperer"
  )) assign(nm, FALSE, envir = module_init)
  .init_once <- function(flag_name, fn) {
    if (isTRUE(get0(flag_name, envir = module_init, ifnotfound = FALSE))) return(invisible(FALSE))
    t0 <- proc.time()[["elapsed"]]
    ok <- TRUE
    tryCatch({
      assign(flag_name, TRUE, envir = module_init)
      fn()
    }, error = function(e) {
      ok <<- FALSE
      assign(flag_name, FALSE, envir = module_init)
      msg <- sprintf("[APP MODULE INIT] %s failed: %s", flag_name, conditionMessage(e))
      warning(msg, call. = FALSE, immediate. = TRUE)
      showNotification(sprintf("%s page initialization failed: %s", flag_name, conditionMessage(e)), type = "error", duration = NULL)
    })
    dt <- proc.time()[["elapsed"]] - t0
    if (isTRUE(ok)) {
      message(sprintf("[APP MODULE INIT] %s: %.2fs", flag_name, dt))
    } else {
      message(sprintf("[APP MODULE INIT] %s failed after %.2fs", flag_name, dt))
    }
    invisible(ok)
  }
  # Keep heavy modules lazy to reduce first-load time.

  observeEvent(input$main_navbar, {
    tab <- input$main_navbar %||% ""
    has_env <- nzchar(shared_data$active_environment$name %||% "")
    if (identical(tab, "rds_tab") && !has_env) {
      updateNavbarPage(session, "main_navbar", selected = "welcome_tab")
      showNotification("Please select an environment first.", type = "warning")
      return(invisible(NULL))
    }
    if (identical(tab, "hto_tab")) .init_once("hto", function() hto_server(input, output, session, shared_data))
    if (identical(tab, "contam_tab")) .init_once("contam", function() contamination_correction_server(input, output, session, shared_data))
    if (identical(tab, "doublet_tab")) .init_once("doublet", function() doublet_server(input, output, session, shared_data))
    if (identical(tab, "vdj_tab")) .init_once("vdj", function() vdj_server(input, output, session, shared_data))
    if (identical(tab, "barcode_tab")) .init_once("barcode", function() barcode_server(input, output, session, shared_data))
    if (identical(tab, "flowgate_tab")) .init_once("flowgate", function() flowgate_server(input, output, session, shared_data))
    if (identical(tab, "atac_qc_tab")) .init_once("atac_qc", function() atac_qc_server(input, output, session, shared_data))
    if (identical(tab, "analysis_tab")) .init_once("analysis", function() analysis_server(input, output, session, shared_data))
    if (identical(tab, "recluster_tab")) .init_once("recluster", function() recluster_server(input, output, session, shared_data))
    if (identical(tab, "recluster_new_tab")) {
      locked <- unique(as.character(shared_data$admin_locked_nav_values %||% character(0)))
      if ("recluster_new_tab" %in% locked) {
        shared_data$admin_locked_nav_values <- setdiff(locked, "recluster_new_tab")
      }
      .clear_nav_tab_gate_block("recluster_new_tab")
      .init_once("recluster_new", function() recluster_new_server(input, output, session, shared_data))
    }
    if (identical(tab, "rna_velocity_v052_tab")) .init_once("rna_velocity_v052", function() rna_velocity_v052_server(input, output, session, shared_data))
    if (identical(tab, "multiome_wnn_tab")) .init_once("multiome_wnn", function() multiome_wnn_server(input, output, session, shared_data))
    if (identical(tab, "multiome_marker_tab")) .init_once("multiome_marker", function() multiome_marker_server(input, output, session, shared_data))
    if (identical(tab, "cellchat_tab")) .init_once("cellchat", function() cellchat_server(input, output, session, shared_data))
    if (identical(tab, "scenic_tab")) .init_once("scenic", function() scenic_server(input, output, session, shared_data))
    if (identical(tab, "monocle2_tab")) .init_once("monocle2", function() monocle2_server(input, output, session, shared_data))
    if (identical(tab, "nichenet_tab")) .init_once("nichenet", function() nichenet_server(input, output, session, shared_data))
    if (identical(tab, "niches_tab")) .init_once("niches", function() niches_server(input, output, session, shared_data))
    if (identical(tab, "sctenifoldknk_tab")) .init_once("sctenifoldknk", function() sctenifoldknk_server(input, output, session, shared_data))
    if (identical(tab, "cellwhisperer_tab")) .init_once("cellwhisperer", function() cellwhisperer_server(input, output, session, shared_data))
    if (identical(tab, "export_tab")) .init_once("export", function() export_server(input, output, session, shared_data))
    if (identical(tab, "export_vdj_safe_tab")) .init_once("export_vdj_safe", function() export_vdj_safe_server(input, output, session, shared_data))
    if (identical(tab, "multiome_export_check_tab")) .init_once("multiome_export_check", function() multiome_export_check_server(input, output, session, shared_data))
    if (identical(tab, "rds_tab")) .init_once("rds", function() rds_server(input, output, session, shared_data, APP_VERSION, MINIMUM_COMPATIBLE_VERSION, MAXIMUM_COMPATIBLE_VERSION))
    if (identical(tab, "figure_studio_umap")) .init_once("figure_umap", function() figure_umap_server(input, output, session, shared_data))
    if (identical(tab, "figure_studio_feature")) .init_once("figure_feature", function() figure_feature_server(input, output, session, shared_data))
    if (identical(tab, "figure_studio_dotplot")) .init_once("figure_dotplot", function() figure_dotplot_server(input, output, session, shared_data))
    if (identical(tab, "figure_studio_alluvial")) .init_once("figure_alluvial", function() figure_alluvial_server(input, output, session, shared_data))
    if (identical(tab, "figure_studio_cluster_alluvial")) .init_once("figure_cluster_alluvial", function() figure_cluster_alluvial_server(input, output, session, shared_data))
    if (identical(tab, "figure_studio_tcr_studio")) .init_once("figure_tcr_studio", function() figure_tcr_studio_server(input, output, session, shared_data))
    if (identical(tab, "figure_studio_pseudobulk_volcano_hidden")) .init_once("figure_pseudobulk_volcano_hidden", function() figure_pseudobulk_volcano_server(input, output, session, shared_data))
  }, ignoreInit = FALSE)

  .tab_to_page_id <- c(
    qc_tab = "qc",
    contam_tab = "contam",
    hto_tab = "hto",
    doublet_tab = "doublet",
    vdj_tab = "vdj",
    flowgate_tab = "flowgate",
    atac_qc_tab = "atac_qc",
    analysis_tab = "analysis",
    recluster_tab = "recluster",
    recluster_new_tab = "recluster_new",
    rna_velocity_v052_tab = "rna_velocity_v052",
    multiome_wnn_tab = "multiome_wnn",
    multiome_marker_tab = "multiome_marker",
    cellchat_tab = "cellchat",
    scenic_tab = "scenic",
    monocle2_tab = "monocle2",
    nichenet_tab = "nichenet",
    niches_tab = "niches",
    sctenifoldknk_tab = "sctenifoldknk",
    cellwhisperer_tab = "cellwhisperer",
    multiome_export_check_tab = "multiome_export_check",
    figure_studio_umap = "figure_umap",
    figure_studio_feature = "figure_feature",
    figure_studio_dotplot = "figure_dotplot",
    figure_studio_alluvial = "figure_alluvial",
    figure_studio_cluster_alluvial = "figure_cluster_alluvial",
    figure_studio_tcr_studio = "figure_tcr_studio",
    figure_studio_pseudobulk_volcano_hidden = "figure_pseudobulk_volcano_hidden"
  )

  observeEvent(input$main_navbar, {
    tab <- input$main_navbar %||% ""
    page_id <- unname(.tab_to_page_id[tab])
    if (!length(page_id) || is.na(page_id) || !nzchar(page_id)) return(invisible(NULL))
    params_snapshot <- isolate(shared_data$analysis_params_by_page %||% list())
    session$onFlushed(function() .restore_page_params(page_id, params_snapshot), once = TRUE)
  }, ignoreInit = TRUE)

  .is_figure_tab <- function(tab) {
    tab %in% c(
      "figure_studio_umap",
      "figure_studio_feature",
      "figure_studio_dotplot",
      "figure_studio_alluvial",
      "figure_studio_cluster_alluvial",
      "figure_studio_tcr_studio",
      "figure_studio_pseudobulk_volcano_hidden"
    )
  }
  .is_sidebar_autoclose_tab <- function(tab) {
    isTRUE(.is_figure_tab(tab)) || identical(tab, "recluster_new_tab")
  }
  .was_figure_tab <- reactiveVal(FALSE)
  .was_sidebar_autoclose_tab <- reactiveVal(FALSE)
  .dark_mode_enabled <- reactiveVal(FALSE)

  .set_dark_mode <- function(enabled = FALSE) {
    is_on <- isTRUE(enabled)
    .dark_mode_enabled(is_on)
    label_html <- if (is_on) "<i class='fa fa-sun-o'></i> Light mode" else "<i class='fa fa-moon-o'></i> Dark mode"
    shinyjs::runjs(sprintf(
      "(function(){document.body.classList.toggle('app-dark-mode', %s); try{localStorage.setItem('wl_dark_mode', %s);}catch(e){} var b=document.getElementById('nav_dark_mode_toggle'); if(b){b.innerHTML=%s;}})();",
      if (is_on) "true" else "false",
      if (is_on) "'1'" else "'0'",
      jsonlite::toJSON(label_html, auto_unbox = TRUE)
    ))
  }

  .set_dark_mode_nav_visibility <- function(show_btn = FALSE) {
    shinyjs::runjs(sprintf(
      "(function(){var b=document.getElementById('nav_dark_mode_toggle'); if(!b) return; var show=%s; var host=b.closest('li,.nav-item,.navbar-nav > li') || b; host.style.display = show ? '' : 'none'; b.style.display = show ? '' : 'none';})();",
      if (isTRUE(show_btn)) "true" else "false"
    ))
  }

  observeEvent(input$main_navbar, {
    tab <- input$main_navbar %||% ""
    is_figure <- .is_figure_tab(tab)
    is_sidebar_autoclose <- .is_sidebar_autoclose_tab(tab)

    shinyjs::runjs(sprintf(
      "(function(){document.body.classList.toggle('figure-studio-active', %s);})();",
      if (isTRUE(is_figure)) "true" else "false"
    ))

    # Figure Studio tabs default dark ON when entered from non-figure tabs.
    # Non-figure tabs always force dark OFF.
    if (!isTRUE(is_figure)) {
      .set_dark_mode(FALSE)
    } else if (!isTRUE(.was_figure_tab())) {
      .set_dark_mode(TRUE)
    } else {
      .set_dark_mode(isTRUE(.dark_mode_enabled()))
    }
    .set_dark_mode_nav_visibility(isTRUE(is_figure))

    if (isTRUE(is_sidebar_autoclose)) {
      try(bslib::toggle_sidebar("app_right_sidebar", open = FALSE, session = session), silent = TRUE)
      session$onFlushed(function() {
        try(bslib::toggle_sidebar("app_right_sidebar", open = FALSE, session = session), silent = TRUE)
      }, once = TRUE)
    }

    .was_figure_tab(isTRUE(is_figure))
    .was_sidebar_autoclose_tab(isTRUE(is_sidebar_autoclose))
  }, ignoreInit = FALSE)

  session$onFlushed(function() {
    .set_dark_mode(FALSE)
    .set_dark_mode_nav_visibility(FALSE)
  }, once = TRUE)

  observeEvent(input$nav_dark_mode_restore, {
    .set_dark_mode(.is_figure_tab(input$main_navbar %||% ""))
  }, ignoreInit = TRUE)

  observeEvent(input$nav_dark_mode_toggle, {
    if (!isTRUE(.is_figure_tab(input$main_navbar %||% ""))) {
      .set_dark_mode(FALSE)
      .set_dark_mode_nav_visibility(FALSE)
      return(invisible(NULL))
    }
    .set_dark_mode(!isTRUE(.dark_mode_enabled()))
    .set_dark_mode_nav_visibility(TRUE)
  }, ignoreInit = TRUE)

  observeEvent(input$qc_refresh_btn, {
    .record_page_params("qc", "qc_refresh_btn", prefixes = c("^qc_"))
  }, ignoreInit = TRUE)
  observeEvent(input$hto_run_btn, {
    .record_page_params("hto", "hto_run_btn", prefixes = c("^hto_"))
  }, ignoreInit = TRUE)
  observeEvent(input$hto_apply_btn, {
    .record_page_params("hto", "hto_apply_btn", prefixes = c("^hto_"))
  }, ignoreInit = TRUE)
  observeEvent(input$dbl_run, {
    .record_page_params("doublet", "dbl_run", prefixes = c("^dbl_"))
  }, ignoreInit = TRUE)
  observeEvent(input$vdj_apply_filter_btn, {
    .record_page_params("vdj", "vdj_apply_filter_btn", prefixes = c("^vdj_"))
  }, ignoreInit = TRUE)
  observeEvent(input$flowgate_run_btn, {
    .record_page_params("flowgate", "flowgate_run_btn", prefixes = c("^flowgate_", "^fg_", "^flow_"))
  }, ignoreInit = TRUE)
  observeEvent(input$atac_qc_apply_btn, {
    .record_page_params("atac_qc", "atac_qc_apply_btn", prefixes = c("^atac_"))
  }, ignoreInit = TRUE)
  observeEvent(input$run_norm_btn, {
    .record_page_params("analysis", "run_norm_btn", prefixes = c("^norm_method$", "^prep_dims_slider$", "^integrate_by_var$", "^inte_method$"))
  }, ignoreInit = TRUE)
  observeEvent(input$run_inte_btn, {
    .record_page_params("analysis", "run_inte_btn", prefixes = c("^norm_method$", "^prep_dims_slider$", "^integrate_by_var$", "^inte_method$"))
  }, ignoreInit = TRUE)
  observeEvent(input$cfg_apply_btn, {
    .record_page_params("analysis", "cfg_apply_btn", prefixes = c("^cfg_", "^umap_"))
  }, ignoreInit = TRUE)
  observeEvent(input$run_sweep_btn, {
    .record_page_params("analysis", "run_sweep_btn", prefixes = c("^sweep_", "^cfg_", "^umap_"))
  }, ignoreInit = TRUE)
  observeEvent(input$apply_final_res_btn, {
    .record_page_params("analysis", "apply_final_res_btn", prefixes = c("^final_res_select$", "^sweep_", "^cfg_", "^umap_"))
  }, ignoreInit = TRUE)
  observeEvent(input$pb_refresh_btn, {
    .record_page_params("analysis", "pb_refresh_btn", prefixes = c("^pb_", "^cfg_", "^sweep_", "^heatmap_"))
  }, ignoreInit = TRUE)
  observeEvent(input$pb_run_custom_btn, {
    .record_page_params("analysis", "pb_run_custom_btn", prefixes = c("^pb_", "^cfg_", "^sweep_", "^heatmap_"))
  }, ignoreInit = TRUE)
  observeEvent(input$run_heatmap_btn2, {
    .record_page_params("analysis", "run_heatmap_btn2", prefixes = c("^heatmap_", "^pb_", "^cfg_", "^sweep_"))
  }, ignoreInit = TRUE)
  observeEvent(input$run_recluster_btn, {
    .record_page_params("recluster", "run_recluster_btn", prefixes = c("^recluster_", "^assay_select$", "^color_by_select$", "^split_by_select$", "^gene_expr_select_", "^dot_", "^stroke_", "^highlight_", "^scatter_", "^new_group_name$", "^gene_pos_", "^gene_neg_"))
  }, ignoreInit = TRUE)
  observeEvent(input$recluster_new_run_btn, {
    .record_page_params(
      "recluster_new",
      "recluster_new_run_btn",
      prefixes = c("^recluster_new_", "^recluster_new_assay_select$", "^recluster_new_color_by_select$", "^recluster_new_split_by_select$", "^recluster_new_gene_expr_select_", "^recluster_new_scatter_")
    )
  }, ignoreInit = TRUE)
  observeEvent(input$rv052_run_btn, {
    .record_page_params("rna_velocity_v052", "rv052_run_btn", prefixes = c("^rv052_"))
  }, ignoreInit = TRUE)
  observeEvent(input$wnn_run_btn, {
    .record_page_params("multiome_wnn", "wnn_run_btn", prefixes = c("^wnn_"))
  }, ignoreInit = TRUE)
  observeEvent(input$mm_run_markers, {
    .record_page_params("multiome_marker", "mm_run_markers", prefixes = c("^mm_"))
  }, ignoreInit = TRUE)
  observeEvent(input$mx_refresh_btn, {
    .record_page_params("multiome_export_check", "mx_refresh_btn", prefixes = c("^mx_"))
  }, ignoreInit = TRUE)
  observeEvent(input$rv_guidance_open_loom_btn, {
    updateNavbarPage(session, inputId = "main_navbar", selected = "rna_velocity_v052_tab")
  }, ignoreInit = TRUE)
  
  # --- Global Navigation Logic ---
  observeEvent(input$nav_help, {
    showModal(modalDialog(
      title = "Help",
      size = "l",
      welcome_help_modal_ui,
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
  
  # --- Visual Logic for Tabs (Enabling/Disabling) ---
  observe({
    obj_reg <- shared_data$all_seurat_objects
    if (is.null(obj_reg)) obj_reg <- list()
    obj_names <- names(obj_reg)
    has_env <- nzchar(shared_data$active_environment$name %||% "")
    fast_on <- identical(as.character(shared_data$workflow_mode %||% "manual"), "fast")
    active_nm <- shared_data$active_object_name
    has_active_obj <- !is.null(active_nm) &&
      length(active_nm) == 1 &&
      !is.na(active_nm) &&
      nzchar(as.character(active_nm)) &&
      as.character(active_nm) %in% obj_names

    if (length(obj_names) > 0 && !has_active_obj) {
      preferred_active_name <- get0("analysis_preferred_loaded_object_name", mode = "function", inherits = TRUE)
      target_active <- tryCatch(
        preferred_active_name(obj_reg, focus_name = "", imported_active_name = ""),
        error = function(e) ""
      )
      shared_data$active_object_name <- if (nzchar(target_active)) target_active else obj_names[[1]]
    }

    unlocked_tabs <- c(
      "environment_tab", "qc_tab", "contam_tab", "hto_tab", "doublet_tab", "vdj_tab", "barcode_tab", "flowgate_tab",
      "analysis_tab", "recluster_tab", "recluster_new_tab", "rna_velocity_tab", "rna_velocity_v052_tab", "cellchat_tab", "scenic_tab", "monocle2_tab",
      "nichenet_tab", "niches_tab", "sctenifoldknk_tab", "cellwhisperer_tab", "export_tab", "export_vdj_safe_tab", "rds_tab",
      "figure_studio_umap", "figure_studio_feature", "figure_studio_dotplot", "figure_studio_alluvial", "figure_studio_cluster_alluvial", "figure_studio_tcr_studio", "figure_studio_pseudobulk_volcano_hidden"
    )
    unlocked_menus <- c("setup_menu", "qc_menu", "analysis_menu", "figures_menu", "export_menu")
    nav_hide_in_fast <- c(unlocked_menus, unlocked_tabs)
    admin_locked_vals <- unique(as.character(shared_data$admin_locked_nav_values %||% character(0)))

    for (tab in unlocked_tabs) {
      if (tab %in% admin_locked_vals) next
      if (tab %in% c("recluster_new_tab", "rds_tab")) next # Handled dynamically below to prevent flashing enable state
      shinyjs::enable(selector = sprintf("a[data-value='%s']", tab))
    }
    for (menu in unlocked_menus) {
      if (menu %in% admin_locked_vals) next
      shinyjs::enable(selector = sprintf("a[data-value='%s']", menu))
    }
    for (val in nav_hide_in_fast) {
      shinyjs::toggle(selector = sprintf("a.nav-link[data-value='%s']", val), condition = !fast_on)
      shinyjs::toggle(selector = sprintf("a.dropdown-item[data-value='%s']", val), condition = !fast_on)
    }
    shinyjs::toggle(selector = "a.nav-link[data-value='welcome_tab']", condition = TRUE)

    # Workspace tab should stay disabled until environment is selected.
    if (isTRUE(shared_data$admin_force_enable_all_menus)) {
      shinyjs::enable(selector = "a[data-value='rds_tab']")
      shinyjs::enable(selector = "a.nav-link[data-value='rds_tab']")
      shinyjs::enable(selector = "a.dropdown-item[data-value='rds_tab']")
      return(invisible(NULL))
    }
    current_tab <- input$main_navbar %||% ""
    if (current_tab %in% admin_locked_vals) {
      updateNavbarPage(session, "main_navbar", selected = "analysis_tab")
      return(invisible(NULL))
    }
    if (isTRUE(fast_on)) return(invisible(NULL))

    # Consolidated navbar visibility policy (single source of truth):
    # 1) ATAC QC is visible whenever Seurat v5 environment is active.
    #    Other multiome tabs require Seurat v5 + ATAC data.
    atac_tabs <- c("multiome_wnn_tab", "multiome_marker_tab", "multiome_export_check_tab")
    env_name <- tolower(shared_data$active_environment$name %||% "")
    is_seurat5 <- grepl("seurat5", env_name, fixed = TRUE)
    show_atac_qc <- is_seurat5
    show_atac <- isTRUE(shared_data$has_atac_data) && is_seurat5
    shinyjs::toggle(selector = "a.nav-link[data-value='atac_qc_tab']", condition = show_atac_qc)
    shinyjs::toggle(selector = "a.dropdown-item[data-value='atac_qc_tab']", condition = show_atac_qc)
    for (tab in atac_tabs) {
      shinyjs::toggle(selector = sprintf("a.nav-link[data-value='%s']", tab), condition = show_atac)
      shinyjs::toggle(selector = sprintf("a.dropdown-item[data-value='%s']", tab), condition = show_atac)
    }

    # 2) HTO tab only when HTO/ADT exists (unless admin force).
    show_hto <- isTRUE(shared_data$admin_force_enable_all_menus) || isTRUE(shared_data$has_hto_data)
    shinyjs::toggle(selector = "a.nav-link[data-value='hto_tab']", condition = show_hto)
    shinyjs::toggle(selector = "a.dropdown-item[data-value='hto_tab']", condition = show_hto)

    # 2b) Data Browser enabled when workspace has loaded objects (unless admin force).
    has_workspace <- length(obj_names) > 0L
    show_data_browser <- isTRUE(shared_data$admin_force_enable_all_menus) || has_workspace
    shinyjs::show(selector = "a.nav-link[data-value='recluster_new_tab']")
    shinyjs::show(selector = "a.dropdown-item[data-value='recluster_new_tab']")
    if (isTRUE(show_data_browser)) {
      shinyjs::enable(selector = "a[data-value='recluster_new_tab']")
      shinyjs::enable(selector = "a.nav-link[data-value='recluster_new_tab']")
      shinyjs::enable(selector = "a.dropdown-item[data-value='recluster_new_tab']")
      .clear_nav_tab_gate_block("recluster_new_tab")
    } else {
      shinyjs::disable(selector = "a[data-value='recluster_new_tab']")
      shinyjs::disable(selector = "a.nav-link[data-value='recluster_new_tab']")
      shinyjs::disable(selector = "a.dropdown-item[data-value='recluster_new_tab']")
      if (identical(current_tab, "recluster_new_tab")) {
        updateNavbarPage(session, "main_navbar", selected = "welcome_tab")
      }
    }

    # 3) Admin-locked tabs remain hidden until individually unlocked.
    hidden_dev_tabs <- unique(admin_locked_vals)
    for (tab in hidden_dev_tabs) {
      shinyjs::hide(selector = sprintf("a.nav-link[data-value='%s']", tab))
      shinyjs::hide(selector = sprintf("a.dropdown-item[data-value='%s']", tab))
    }

    # Keep user on a visible tab when gated tabs are hidden.
    if (current_tab %in% hidden_dev_tabs) {
      updateNavbarPage(session, "main_navbar", selected = "analysis_tab")
    } else if (!show_atac_qc && identical(current_tab, "atac_qc_tab")) {
      updateNavbarPage(session, "main_navbar", selected = "qc_tab")
    } else if (!show_atac && current_tab %in% atac_tabs) {
      updateNavbarPage(session, "main_navbar", selected = "qc_tab")
    } else if (!show_hto && identical(current_tab, "hto_tab")) {
      updateNavbarPage(session, "main_navbar", selected = "qc_tab")
    }

    if (has_env) {
      shinyjs::enable(selector = "a[data-value='rds_tab']")
      shinyjs::enable(selector = "a.nav-link[data-value='rds_tab']")
      shinyjs::enable(selector = "a.dropdown-item[data-value='rds_tab']")
    } else {
      shinyjs::disable(selector = "a[data-value='rds_tab']")
      shinyjs::disable(selector = "a.nav-link[data-value='rds_tab']")
      shinyjs::disable(selector = "a.dropdown-item[data-value='rds_tab']")
      if (identical(input$main_navbar %||% "", "rds_tab")) {
        updateNavbarPage(session, "main_navbar", selected = "welcome_tab")
      }
    }
  })

  .fast_log <- function(...) {
    msg <- paste(..., collapse = "")
    message("[FAST_LOUPE] ", msg)
  }

  .fast_set_state <- function(phase = NULL, status = NULL, message = NULL, error = NULL, imported_names = NULL) {
    st <- shared_data$fast_loupe %||% list()
    if (!is.null(phase)) st$phase <- as.character(phase)
    if (!is.null(status)) st$status <- as.character(status)
    if (!is.null(message)) st$message <- as.character(message)
    if (!is.null(error)) st$error <- as.character(error)
    if (!is.null(imported_names)) st$imported_names <- as.character(imported_names)
    shared_data$fast_loupe <- st
    .fast_log("state phase=", st$phase %||% "", " status=", st$status %||% "", " msg=", st$message %||% "")
  }

  .fast_mode_active <- reactive({
    identical(as.character(shared_data$workflow_mode %||% "manual"), "fast")
  })

  .tag_admin_locked_nav_items <- function(values) {
    vals <- unique(as.character(values %||% character(0)))
    vals <- vals[nzchar(vals)]
    payload <- jsonlite::toJSON(as.list(vals), auto_unbox = TRUE)
    shinyjs::runjs(sprintf(
      "(function(){var vals=%s||[]; var locked={}; for(var i=0;i<vals.length;i++){locked[String(vals[i])] = true;} var nodes=document.querySelectorAll(\"a.nav-link[data-value],a.dropdown-item[data-value]\"); for(var n=0;n<nodes.length;n++){var el=nodes[n]; var v=String(el.getAttribute('data-value')||''); var isLocked=!!locked[v]; if(isLocked){el.setAttribute('data-admin-locked','true'); el.classList.add('wl-admin-locked-nav');} else {el.removeAttribute('data-admin-locked'); el.classList.remove('wl-admin-locked-nav');}}})();",
      payload
    ))
  }

  .clear_nav_tab_gate_block <- function(tab_id) {
    tab_id <- as.character(tab_id %||% "")
    if (!nzchar(tab_id)) return(invisible(NULL))
    shinyjs::runjs(sprintf(
      "$('a[data-value=%s]').removeClass('disabled').off('click.rds_gate_block');",
      jsonlite::toJSON(tab_id, auto_unbox = TRUE)
    ))
    invisible(NULL)
  }

  observeEvent(shared_data$admin_locked_nav_values, {
    .tag_admin_locked_nav_items(shared_data$admin_locked_nav_values %||% character(0))
  }, ignoreInit = FALSE)

  observeEvent(input$main_navbar, {
    if (!isTRUE(.fast_mode_active())) return(invisible(NULL))
    tab <- as.character(input$main_navbar %||% "")
    if (!identical(tab, "welcome_tab")) {
      updateNavbarPage(session, "main_navbar", selected = "welcome_tab")
    }
  }, ignoreInit = TRUE)

  observeEvent(shared_data$workflow_mode, {
    if (!isTRUE(.fast_mode_active())) return(invisible(NULL))
    overlay_show("Generating loupe file, this might take several minutes.")
    env_name_now <- tolower(as.character(shared_data$active_environment$name %||% ""))
    has_loaded_registry <- length(shared_data$all_seurat_objects %||% list()) > 0L
    has_loaded_sheet <- is.data.frame(shared_data$full_sample_sheet) && nrow(shared_data$full_sample_sheet) > 0L
    has_loaded_state <- isTRUE(has_loaded_registry || has_loaded_sheet)
    if (has_loaded_state && !identical(env_name_now, "seurat4")) {
      warn_msg <- paste(
        "Fast Version will switch runtime to Seurat v4.",
        "Current loaded data/workspace may be lost or become incompatible.",
        "Save workspace before continuing if needed."
      )
      .fast_log("warning ", warn_msg)
      shiny::showNotification(warn_msg, type = "warning", duration = 12)
    }
    .fast_set_state(
      phase = "waiting_env",
      status = "running",
      message = "Fast mode enabled. Forcing Seurat v4 environment and opening import."
    )
    shared_data$fast_prepare_env_request <- as.integer((shared_data$fast_prepare_env_request %||% 0L) + 1L)
    if (identical(env_name_now, "seurat4")) {
      .fast_set_state(
        phase = "waiting_import",
        message = "Seurat v4 already active. Opening import modal."
      )
      shared_data$request_import_modal <- as.integer((shared_data$request_import_modal %||% 0L) + 1L)
    }
    updateNavbarPage(session, "main_navbar", selected = "welcome_tab")
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(shared_data$active_environment$name, {
    if (!isTRUE(.fast_mode_active())) return(invisible(NULL))
    env_name <- tolower(as.character(shared_data$active_environment$name %||% ""))
    st <- shared_data$fast_loupe %||% list()
    if (!identical(as.character(st$phase %||% ""), "waiting_env")) return(invisible(NULL))
    if (!identical(env_name, "seurat4")) return(invisible(NULL))
    .fast_set_state(phase = "waiting_import", message = "Seurat v4 active. Opening import modal.")
    shared_data$request_import_modal <- as.integer((shared_data$request_import_modal %||% 0L) + 1L)
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(shared_data$all_seurat_objects, {
    if (!isTRUE(.fast_mode_active())) return(invisible(NULL))
    st <- shared_data$fast_loupe %||% list()
    phase <- as.character(st$phase %||% "")
    if (!(phase %in% c("waiting_import", "analysis_started", "integration_ran", "sweep_ran", "export_ready"))) {
      return(invisible(NULL))
    }
    reg_names <- names(shared_data$all_seurat_objects %||% list()) %||% character(0)
    baseline <- as.character(st$baseline_names %||% character(0))
    imported <- setdiff(reg_names, baseline)
    if (!length(imported) && length(as.character(st$imported_names %||% character(0)))) {
      imported <- as.character(st$imported_names %||% character(0))
    }
    if (!length(imported)) return(invisible(NULL))
    shared_data$active_object_name <- imported[[1]]
    .fast_set_state(imported_names = imported)

    .init_once("analysis", function() analysis_server(input, output, session, shared_data))
    updateNavbarPage(session, "main_navbar", selected = "analysis_tab")

    if (identical(phase, "waiting_import")) {
      .fast_set_state(phase = "analysis_started", message = "Import completed. Running integration/normalization pipeline.")
      try(updateSelectizeInput(session, "active_object_name_input_inline", selected = imported), silent = TRUE)
      try(updateSelectizeInput(session, "active_object_name_input_umap_inline", selected = imported), silent = TRUE)
      if (length(imported) > 1L) {
        try(updateRadioButtons(session, "inte_method", selected = "RPCA"), silent = TRUE)
        session$onFlushed(function() {
          shinyjs::runjs("var b=document.getElementById('run_inte_btn'); if(b){b.click();}")
        }, once = TRUE)
      } else {
        session$onFlushed(function() {
          shinyjs::runjs("var b=document.getElementById('run_norm_btn'); if(b){b.click();}")
        }, once = TRUE)
      }
      return(invisible(NULL))
    }

    if (identical(phase, "analysis_started")) {
      .fast_set_state(phase = "integration_ran", message = "Running clustering sweep.")
      session$onFlushed(function() {
        shinyjs::runjs("var b=document.getElementById('run_sweep_btn'); if(b){b.click();}")
      }, once = TRUE)
      return(invisible(NULL))
    }

    if (identical(phase, "integration_ran")) {
      entry <- shared_data$all_seurat_objects[[shared_data$active_object_name %||% ""]]
      cache <- tryCatch(entry$analysis_cache$cluster_sweep, error = function(e) NULL)
      has_sweep <- is.list(cache) && length(suppressWarnings(as.numeric(cache$resolutions %||% numeric(0)))) > 0L
      if (!isTRUE(has_sweep)) return(invisible(NULL))
      .fast_set_state(phase = "sweep_ran", message = "Applying final resolution.")
      session$onFlushed(function() {
        shinyjs::runjs("var b=document.getElementById('apply_final_res_btn'); if(b){b.click();}")
      }, once = TRUE)
      return(invisible(NULL))
    }

    if (identical(phase, "sweep_ran")) {
      entry <- shared_data$all_seurat_objects[[shared_data$active_object_name %||% ""]]
      final_res <- tryCatch(entry$prefs$final_resolution, error = function(e) NULL)
      if (is.null(final_res) || !is.finite(as.numeric(final_res))) return(invisible(NULL))
      .fast_set_state(phase = "export_ready", message = "Preparing auto-export to .cloupe.")
      .init_once("export", function() export_server(input, output, session, shared_data))
      updateNavbarPage(session, "main_navbar", selected = "export_tab")
      ts <- format(Sys.time(), "%Y%m%d_%H%M%S")
      try(updateTextInput(session, "loupe_filename_input", value = paste0("loupe_quick_", ts, ".cloupe")), silent = TRUE)
      session$onFlushed(function() {
        shinyjs::runjs("var b=document.getElementById('download_loupe_file_btn'); if(b){b.click();}")
      }, once = TRUE)
      .fast_set_state(phase = "done", status = "success", message = "Fast Loupe workflow finished.")
      overlay_hide()
      return(invisible(NULL))
    }
    invisible(NULL)
  }, ignoreInit = TRUE)

  # Detect ATAC-like content from loaded Seurat objects.
  observe({
    reg <- shared_data$all_seurat_objects %||% list()
    has_atac <- FALSE
    if (length(reg)) {
      for (nm in names(reg)) {
        entry <- reg[[nm]]
        obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
        assay_names <- tryCatch(names(obj@assays), error = function(e) character(0))
        if (length(assay_names) > 0) {
          low <- tolower(assay_names)
          if (any(grepl("(^|_|-)atac($|_|-)|peaks?|chromatin", low, perl = TRUE))) {
            has_atac <- TRUE
            break
          }
          assay_classes <- unlist(lapply(assay_names, function(an) {
            tolower(paste(tryCatch(class(obj[[an]]), error = function(e) character(0)), collapse = " "))
          }), use.names = FALSE)
          if (any(grepl("chromatinassay|atac", assay_classes, perl = TRUE))) {
            has_atac <- TRUE
            break
          }
        }
      }
    }
    shared_data$has_atac_data <- isTRUE(has_atac)
  })

  # Detect HTO/ADT-like content from loaded Seurat objects.
  observe({
    reg <- shared_data$all_seurat_objects %||% list()
    has_hto <- FALSE
    if (length(reg)) {
      for (nm in names(reg)) {
        entry <- reg[[nm]]
        obj <- if (is.list(entry) && !is.null(entry$obj)) entry$obj else entry
        assay_names <- tryCatch(names(obj@assays), error = function(e) character(0))
        if (!length(assay_names)) next
        low <- tolower(assay_names)
        if (any(low %in% c("adt", "hto")) ||
            any(grepl("hash|hashtag|adt|hto|antibody|cite", low, perl = TRUE))) {
          has_hto <- TRUE
          break
        }
      }
    }
    shared_data$has_hto_data <- isTRUE(has_hto)
  })

  observeEvent(shared_data$active_environment$name, {
    target_variant <- .resolve_core_variant(shared_data$active_environment$name)
    if (!identical(target_variant, shared_data$core_variant)) {
      .source_core_modules(target_variant)
      shared_data$core_variant <- target_variant
      message("[app] Switched core module set to: ", target_variant)
    }
  }, ignoreInit = FALSE)

  observeEvent(shared_data$active_environment, {
    env_old <- shared_data$active_environment %||% list()
    env_new <- .canonicalize_active_environment(env_old)
    changed <- !identical(env_old$path %||% "", env_new$path %||% "") ||
      !identical(
        as.character(unlist(env_old$core_paths %||% character(0), use.names = FALSE)),
        as.character(unlist(env_new$core_paths %||% character(0), use.names = FALSE))
      )
    if (isTRUE(changed)) {
      shared_data$active_environment <- modifyList(env_old, env_new)
      message("[app] Canonicalized active environment library paths to package_libraries root.")
    }
  }, ignoreInit = FALSE)
  
}

shinyApp(ui, server)
