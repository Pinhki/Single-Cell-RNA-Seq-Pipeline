# spinner_overlay.R
# Global busy overlay (one DOM per app). 

# ===============================================================
#  GLOBAL OVERLAY — USAGE TEMPLATE (FOR FUTURE MAINTAINERS)
# ===============================================================
#
# This file defines a SINGLE global busy overlay for the entire app.
# It is mounted ONCE in app.R:
#
#     overlay_deps()
#     overlay_ui("global_overlay")
#
# No page/module should include its own overlay UI.  
# All modules simply CALL the API below.
#
# ===============================================================
#  HOW TO USE IN ANY PAGE OR MODULE
# ===============================================================
#
# --- In UI (page_xyz.R) ---
# DO NOT add overlay_deps() or overlay_ui() here.
#
#     xyz_ui <- fluidPage(
#         shinyjs::useShinyjs(),
#         # nothing overlay-related here
#         ...
#     )
#
# --- In SERVER (page_xyz.R) ---
#
# 1) Basic usage:
#
#     observeEvent(input$run_btn, {
#         overlay_show()                       # default message "Working…"
#         on.exit(overlay_hide(), add = TRUE)
#         ... long task ...
#     })
#
# 2) With custom message:
#
#     observeEvent(input$heavy_task_btn, {
#         overlay_show("Processing dataset…")
#         on.exit(overlay_hide(), add = TRUE)
#         ... long job ...
#     })
#
# 3) Recommended helper inside each module:
#
#     .show_overlay <- function(msg = NULL) {
#         if (is.null(msg) || !nzchar(msg)) overlay_show()
#         else overlay_show(text = msg)
#     }
#
#     .hide_overlay <- function() overlay_hide()
#
#     observeEvent(input$do_something, {
#         .show_overlay("Running analysis…")
#         on.exit(.hide_overlay(), add = TRUE)
#         ... task ...
#     })
#
# --- Behavior Notes ---
#
# * overlay_show() fails silently if the global overlay DOM is not yet mounted.
#   This is intentional and prevents JS errors during startup.
#
# * overlay_show(text="...") updates the message on every call.
#
# * overlay_hide() always hides the global overlay.
#
# --- Optional: Multiple overlays ---
# If ever needed (rare):
#
#     overlay_ui("secondary_overlay")
#     overlay_show(text="Step 1…", id="secondary_overlay")
#     overlay_hide(id="secondary_overlay")
#
# But normally only "global_overlay" is used.
#
# ===============================================================
# End of usage guide. Implementation starts below.
# ===============================================================

# Stable API:
#   overlay_deps()
#   overlay_ui(id = "global_overlay", default_text = "Working…")
#   overlay_show(text = NULL, id = "global_overlay", session = getDefaultReactiveDomain(), pct = NULL, tip = NULL, lightweight = FALSE, lock = TRUE, controls = NULL, loader = NULL)
#   overlay_hide(id = "global_overlay", session = getDefaultReactiveDomain())

# Loading tips (edit freely: one sentence per item).
SPINNER_OVERLAY_TIPS <- c(
  "Tip: Keep sample names short but unique to make side-by-side comparison easier.",
  "Tip: Start with moderate QC thresholds, then tighten in small steps.",
  "Tip: Save workspace snapshots before major filtering or reclustering.",
  "Tip: Use metadata fields (condition and batch) early for cleaner downstream plots."
)

.spinner_overlay_meme_paths <- function() {
  meme_dir <- file.path("www", "memes_busy_overlay", "raw")
  if (!dir.exists(meme_dir)) return(character(0))
  files <- list.files(
    meme_dir,
    pattern = "\\.(jpg|jpeg|png|gif|webp)$",
    ignore.case = TRUE
  )
  files <- files[nzchar(files)]
  if (!length(files)) return(character(0))
  file.path("memes_busy_overlay", "raw", files)
}

.spinner_pick_tip <- function(tips = SPINNER_OVERLAY_TIPS) {
  if (is.null(tips)) tips <- character(0)
  tips <- as.character(tips)
  tips <- tips[nzchar(trimws(tips))]
  if (!length(tips)) return("")
  sample(tips, size = 1)
}

# Agent note: Busy overlay media is opt-in. Keep startup media-free and reveal
# one random meme only from the explicit fun action; do not restore auto media
# or add an ASCII fallback.

# Agent note: Busy-overlay controls are explicit task capabilities. Page code
# must declare safe actions and checkpoint consequences; shared JavaScript only
# renders controls and emits the declared action event.
# Agent note: macOS action controls stay icon-only while compact. Keep labels
# in the DOM for accessible names; direct hover/focus reveals them in a pill.
overlay_control_action <- function(name,
                                   label = NULL,
                                   confirm = NULL,
                                   confirm_title = NULL,
                                   confirm_detail = NULL,
                                   confirm_label = NULL) {
  name <- tolower(trimws(as.character(if (is.null(name)) "" else name)))
  if (!nzchar(name)) stop("Overlay action name must not be empty.")
  if (is.null(label)) {
    label <- switch(
      name,
      pause = "Pause",
      resume = "Resume",
      skip = "Skip remaining",
      cancel = "Cancel",
      name
    )
  }
  if (is.null(confirm)) confirm <- name %in% c("cancel", "skip")
  out <- list(
    name = name,
    label = as.character(label),
    confirm = isTRUE(confirm)
  )
  if (!is.null(confirm_title)) out$confirmTitle <- as.character(confirm_title)
  if (!is.null(confirm_detail)) out$confirmDetail <- as.character(confirm_detail)
  if (!is.null(confirm_label)) out$confirmLabel <- as.character(confirm_label)
  out
}

overlay_controls <- function(task_id,
                             actions = list(),
                             note = NULL,
                             state = "running",
                             placement = "left",
                             action_input_id = "global_overlay_action") {
  list(
    taskId = as.character(task_id),
    actionInputId = as.character(action_input_id),
    placement = as.character(placement),
    state = as.character(state),
    note = if (is.null(note)) "" else as.character(note),
    actions = actions
  )
}

overlay_deps <- function() {
  shiny::tagList(
    processing_motion_deps(),
    shiny::singleton(
      shiny::tags$head(
        # CSS
        shiny::tags$style(shiny::HTML("
          .so-backdrop{
            position: fixed;
            inset: 0;
            z-index: 9999;
            display: none;                 /* hidden by default */
            align-items: center;
            justify-content: center;
            background: rgba(2, 6, 23, 0.55);
            backdrop-filter: blur(6px) saturate(125%);
          }
          .so-card{
            --so-card-radius: 30px;
            --so-card-inset: 20px;
            --so-inner-radius: calc(var(--so-card-radius) - var(--so-card-inset));
            width: min(92vw, 700px);
            height: 50vh;
            max-height: 50vh;
            padding: 20px;
            border-radius: var(--so-card-radius);
            background: #ffffff;
            border: 1px solid #e2e8f0;
            box-shadow: 0 20px 54px rgba(15, 23, 42, 0.30);
            display: grid;
            grid-template-columns: 1fr;
            gap: 0;
            font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            color: #0f172a;
            transition: width 360ms ease-in-out, gap 360ms ease-in-out;
          }
          .Pinhki-platform-mac .so-card{
            border: 0;
          }
          .so-card.is-expanded{
            width: fit-content;
            max-width: 94vw;
            grid-template-columns: minmax(320px, 430px) auto;
            gap: 20px;
          }
          .so-left{
            --so-content-inset-x: 18px;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: center;
            text-align: left;
            gap: 0;
            min-width: 0;
            padding-left: 0;
            padding-right: 4px;
            position: relative;
            /* Agent note: Keep one explicit horizontal content edge. Padding
               and absolute positioning can otherwise resolve different box
               origins. */
            align-self: stretch;
          }
          .so-content{
            width: calc(100% - var(--so-content-inset-x));
            margin-left: var(--so-content-inset-x);
            min-width: 0;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 14px;
          }
          .so-content > :not(.so-media-toggle-wrap){
            position: relative;
            top: -12px;
          }
          .so-content > .so-spinner{
            margin-left: 0;
          }
          .so-control-slot{
            /* Agent note: Use same explicit content edge as message and bar. */
            position: absolute;
            top: 0;
            left: var(--so-content-inset-x);
            right: 4px;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: flex-start;
            gap: 6px;
            width: auto;
            min-height: 34px;
          }
          .so-control-actions{
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: inherit;
            gap: 6px;
            width: 100%;
          }
          .so-control-action,
          .so-confirm-action{
            border: 0;
            border-radius: 999px;
            padding: 6px 12px;
            font: inherit;
            font-size: 12px;
            font-weight: 700;
            line-height: 1.2;
            cursor: pointer;
            box-shadow: none;
          }
          .so-control-action:focus-visible,
          .so-confirm-action:focus-visible{
            outline: 2px solid #64748b;
            outline-offset: 2px;
          }
          .Pinhki-platform-mac .so-control-slot{
            min-height: 42px;
          }
          .Pinhki-platform-mac .so-control-actions{
            flex-wrap: nowrap;
            gap: 8px;
            width: max-content;
            min-height: 42px;
            overflow: visible;
          }
          .Pinhki-platform-mac .so-control-action{
            width: 36px;
            min-width: 36px;
            height: 36px;
            min-height: 36px;
            flex: 0 0 auto;
            box-sizing: border-box;
            aspect-ratio: 1 / 1;
            margin-left: 0;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            overflow: hidden;
            border: 0;
            border-radius: 50% !important;
            color: #ffffff;
            background: rgba(71, 85, 105, 0.78);
            box-shadow: none;
            -webkit-backdrop-filter: blur(10px) saturate(125%);
            backdrop-filter: blur(10px) saturate(125%);
            transition:
              width 280ms cubic-bezier(0.22, 1, 0.36, 1),
              min-width 280ms cubic-bezier(0.22, 1, 0.36, 1),
              border-radius 240ms ease-out,
              padding 240ms ease-out,
              transform 260ms cubic-bezier(0.22, 1, 0.36, 1),
              background 220ms ease;
          }
          .Pinhki-platform-mac .so-control-action:hover,
          .Pinhki-platform-mac .so-control-action:focus-visible{
            width: 104px;
            min-width: 104px;
            aspect-ratio: auto;
            padding: 0 13px;
            justify-content: flex-start;
            border-radius: 999px !important;
            transform: translateY(-1px);
            z-index: 5;
            box-shadow: none;
          }
          .Pinhki-platform-mac .so-action-resume:hover,
          .Pinhki-platform-mac .so-action-resume:focus-visible{
            width: 112px;
            min-width: 112px;
          }
          .Pinhki-platform-mac .so-action-skip:hover,
          .Pinhki-platform-mac .so-action-skip:focus-visible{
            width: 224px;
            min-width: 224px;
          }
          .Pinhki-platform-mac .so-control-action::before{
            width: 16px;
            min-width: 16px;
            height: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: inherit;
            font-size: 12px;
            font-weight: 800;
            line-height: 1;
            opacity: 0.68;
            filter: blur(0);
            transform: scale(0.92);
            transition: opacity 160ms ease, filter 220ms ease, transform 220ms ease;
          }
          .Pinhki-platform-mac .so-action-pause::before{ content: '||'; }
          .Pinhki-platform-mac .so-action-resume::before{ content: '>'; font-size: 16px; }
          .Pinhki-platform-mac .so-action-skip::before{ content: '>>'; }
          .Pinhki-platform-mac .so-action-cancel::before{ content: 'x'; font-size: 15px; }
          .Pinhki-platform-mac .so-control-label{
            max-width: 0;
            opacity: 0;
            filter: blur(6px);
            transform: translateX(-5px);
            overflow: hidden;
            white-space: nowrap;
            transition:
              max-width 280ms cubic-bezier(0.22, 1, 0.36, 1),
              opacity 160ms ease,
              filter 220ms ease,
              transform 220ms ease;
          }
          .Pinhki-platform-mac .so-control-action:hover .so-control-label,
          .Pinhki-platform-mac .so-control-action:focus-visible .so-control-label{
            max-width: 205px;
            opacity: 1;
            filter: blur(0);
            transform: none;
          }
          .Pinhki-platform-mac .so-control-action:hover::before,
          .Pinhki-platform-mac .so-control-action:focus-visible::before{
            opacity: 0;
            filter: blur(4px);
            transform: scale(0.82);
          }
          .Pinhki-platform-mac .so-action-pause{
            color: #ffffff;
            background: rgba(10, 132, 255, 0.78);
            z-index: 3;
          }
          .Pinhki-platform-mac .so-action-resume{
            color: #ffffff;
            background: rgba(48, 164, 108, 0.78);
            z-index: 3;
          }
          .Pinhki-platform-mac .so-action-skip{
            color: #ffffff;
            background: rgba(217, 145, 0, 0.78);
            z-index: 2;
          }
          .Pinhki-platform-mac .so-action-cancel{
            color: #ffffff;
            background: rgba(224, 73, 73, 0.78);
            z-index: 1;
          }
          .so-action-pause{
            color: #1d4ed8;
            background: #dbeafe;
          }
          .so-action-resume{
            color: #166534;
            background: #dcfce7;
          }
          .so-action-skip{
            color: #92400e;
            background: #fef3c7;
          }
          .so-action-cancel{
            color: #b91c1c;
            background: #fee2e2;
          }
          .so-control-note{
            display: none;
            max-width: 100%;
            color: #475569;
            font-size: 12px;
            line-height: 1.35;
            opacity: 0;
            transition: opacity 1s ease;
          }
          .so-control-slot[data-controls-revealed='true'] .so-control-note{
            opacity: 1;
          }
          .so-confirm{
            display: none;
            gap: 7px;
            margin-top: 0;
            padding: 0;
            color: #0f172a;
            background: transparent;
            border: 0;
            border-radius: 0;
            box-shadow: none;
            font-size: 12px;
            line-height: 1.35;
          }
          .so-confirm-title{
            font-weight: 700;
          }
          .so-confirm-detail{
            color: #475569;
          }
          .so-confirm-actions{
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 6px;
          }
          .so-confirm-cancel{
            color: #334155;
            background: #e2e8f0;
          }
          .so-confirm-accept{
            color: #ffffff;
          }
          .so-confirm-accept.so-action-cancel{
            background: #dc2626;
          }
          .so-confirm-accept.so-action-skip{
            background: #d97706;
          }
          .Pinhki-platform-mac .so-confirm.is-visible{
            animation: so-confirm-expand 260ms ease-out both;
            transform-origin: top left;
          }
          .so-card:not(.is-expanded) .so-control-note{
            max-width: 440px;
          }
          .so-right{
            display: none;
            align-items: center;
            justify-content: flex-end;
            width: auto;
            max-width: none;
            min-width: 0;
            min-height: 0;
            overflow: hidden;
            border-radius: var(--so-inner-radius);
            opacity: 0;
            transform: translateX(-10px);
            justify-self: start;
          }
          .so-right.is-visible{
            display: flex;
            animation: so-fade-in 420ms ease-in-out both;
          }
          .so-meme{
            width: auto;
            height: calc(50vh - 40px);
            max-width: min(48vw, 620px);
            border-radius: var(--so-inner-radius);
            object-fit: contain;
            background: transparent;
            display: block;
          }
          .so-message{
            font-size: 18px;
            font-weight: 500;
            color: #0f172a;
          }
          .so-progress-wrap{
            width: 100%;
            max-width: 420px;
            display: none;
            margin-top: -2px;
          }
          .so-progress-track{
            width: 100%;
            height: 10px;
            border-radius: 999px;
            background: #e2e8f0;
            overflow: hidden;
          }
          .so-progress-fill{
            height: 100%;
            width: 0%;
            background: linear-gradient(90deg, #7dd3fc, #60a5fa);
            transition: width 140ms linear;
          }
          .so-progress-pct{
            margin-top: 6px;
            font-size: 16px;
            font-weight: 600;
            color: #0f172a;
          }
          .so-tip{
            margin-top: 2px;
            font-size: 13px;
            line-height: 1.35;
            color: #334155;
            max-width: 440px;
          }
          .so-media-toggle-wrap{
            margin-top: 0;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            width: auto;
            justify-content: flex-end;
            position: absolute;
            right: 6px;
            bottom: 2px;
          }
          .so-media-toggle-link{
            background: transparent;
            border: 0;
            padding: 0;
            margin: 0;
            color: #6b7280;
            text-decoration: underline;
            font-size: 12px;
            line-height: 1.35;
            cursor: pointer;
          }
          .so-media-toggle-link:hover{
            color: #4b5563;
          }
          .so-media-toggle-link:focus-visible{
            outline: 2px solid #94a3b8;
            outline-offset: 2px;
            border-radius: 2px;
          }
          .so-elapsed{
            margin-top: -6px;
            font-size: 12px;
            color: #475569;
            letter-spacing: 0.2px;
          }
          @media (max-width: 900px){
            .so-card{
              --so-card-radius: 24px;
              --so-card-inset: 20px;
              grid-template-columns: 1fr;
              gap: 14px;
              padding: 20px;
              border-radius: var(--so-card-radius);
              width: min(96vw, 700px);
              height: auto;
              max-height: none;
            }
            .so-right{
              justify-content: flex-start;
            }
            .so-meme{
              height: auto;
              max-height: 44vh;
            }
          }
          @keyframes so-spin{
            to { transform: rotate(360deg); }
          }
          @keyframes so-fade-in{
            from{
              opacity: 0;
              transform: translateX(-12px);
            }
            to{
              opacity: 1;
              transform: translateX(0);
            }
          }
          @keyframes so-confirm-expand{
            from{
              opacity: 0;
              transform: scaleY(0.82);
            }
            to{
              opacity: 1;
              transform: scaleY(1);
            }
          }
        ")),
        # JS
        shiny::tags$script(shiny::HTML("
          (function() {
            function setMessage(el, text) {
              var msgEl = el.querySelector('.so-message');
              if (!msgEl) return;
              if (typeof text === 'string' && text.length) {
                msgEl.textContent = text;
              } else {
                var def = el.getAttribute('data-default-text') || 'Working…';
                msgEl.textContent = def;
              }
            }
            function pickDefaultTip(el) {
              var raw = el.getAttribute('data-tips') || '[]';
              var arr = [];
              try { arr = JSON.parse(raw); } catch (e) { arr = []; }
              if (!Array.isArray(arr) || !arr.length) return '';
              var clean = arr.filter(function(x) { return (typeof x === 'string') && x.trim().length > 0; });
              if (!clean.length) return '';
              var idx = Math.floor(Math.random() * clean.length);
              return clean[idx] || '';
            }
            function setTip(el, text) {
              var tipEl = el.querySelector('.so-tip');
              if (!tipEl) return;
              if (typeof text === 'string' && text.length) {
                tipEl.textContent = text;
              } else {
                tipEl.textContent = pickDefaultTip(el);
              }
            }
            function parseListAttr(el, attrName) {
              var raw = el.getAttribute(attrName) || '[]';
              var arr = [];
              try { arr = JSON.parse(raw); } catch (e) { arr = []; }
              if (!Array.isArray(arr)) return [];
              return arr.filter(function(x) {
                return (typeof x === 'string') && x.trim().length > 0;
              });
            }
            function getUserMediaMode(el) {
              var mode = String(el.getAttribute('data-user-media-mode') || 'none').toLowerCase();
              return mode === 'meme' ? 'meme' : 'none';
            }
            function setUserMediaMode(el, mode) {
              var clean = String(mode || 'none').toLowerCase();
              if (clean !== 'meme') clean = 'none';
              el.setAttribute('data-user-media-mode', clean);
              syncMediaToggleLinks(el);
            }
            function setMediaMode(el, mode) {
              var imgEl = el.querySelector('.so-meme');
              if (imgEl) imgEl.style.display = (mode === 'meme') ? 'block' : 'none';
            }
            function syncMediaToggleLinks(el) {
              var fun = el.querySelector('.so-media-toggle-link[data-media-mode=\"meme\"]');
              if (!fun) return;
              var mode = getUserMediaMode(el);
              fun.style.display = (mode === 'meme') ? 'none' : 'inline';
            }
            function setRandomMeme(el) {
              var imgEl = el.querySelector('.so-meme');
              var rightEl = el.querySelector('.so-right');
              if (!imgEl || !rightEl) return false;
              var clean = parseListAttr(el, 'data-memes');
              if (!clean.length) {
                imgEl.removeAttribute('src');
                rightEl.classList.remove('is-visible');
                rightEl.style.display = 'none';
                return false;
              }
              var idx = Math.floor(Math.random() * clean.length);
              var src = clean[idx];
              if (src && src.charAt(0) !== '/' && !/^https?:\\/\\//i.test(src)) {
                src = '/' + src;
              }
              imgEl.src = src;
              setMediaMode(el, 'meme');
              return true;
            }
            function showMemeMedia(el) {
              return setRandomMeme(el);
            }
            function applyPreferredMedia(el) {
              var mode = getUserMediaMode(el);
              if (mode === 'meme') return Promise.resolve(showMemeMedia(el));
              return Promise.resolve(false);
            }
            function clearMemeRevealTimer(id) {
              window.__spinnerOverlayPicTimers = window.__spinnerOverlayPicTimers || {};
              var tmap = window.__spinnerOverlayPicTimers;
              if (tmap[id]) {
                clearTimeout(tmap[id]);
                delete tmap[id];
              }
            }
            function hideMemeNow(el) {
              var imgEl = el.querySelector('.so-meme');
              var rightEl = el.querySelector('.so-right');
              var cardEl = el.querySelector('.so-card');
              if (!rightEl) return;
              if (imgEl) imgEl.removeAttribute('src');
              rightEl.classList.remove('is-visible');
              rightEl.style.display = 'none';
              if (cardEl) cardEl.classList.remove('is-expanded');
            }
            function revealRightAfterDelay(el, id, delayMs) {
              if (!el) return;
              var rightEl = el.querySelector('.so-right');
              var cardEl = el.querySelector('.so-card');
              if (!rightEl) return;
              clearMemeRevealTimer(id);
              window.__spinnerOverlayPicTimers = window.__spinnerOverlayPicTimers || {};
              var tmap = window.__spinnerOverlayPicTimers;
              tmap[id] = setTimeout(function() {
                if (cardEl) cardEl.classList.add('is-expanded');
                rightEl.style.display = 'flex';
                void rightEl.offsetWidth; // restart animation if needed
                rightEl.classList.add('is-visible');
                delete tmap[id];
              }, Math.max(0, delayMs || 0));
            }
            function syncInteractionLock(id, locked) {
              var el = document.getElementById(id);
              if (el) {
                if (locked) el.setAttribute('data-overlay-lock', 'true');
                else el.removeAttribute('data-overlay-lock');
              }
              var active = document.querySelector('.so-backdrop[data-overlay-lock=\"true\"]');
              if (document.body) {
                document.body.classList.toggle('wl-overlay-lock', !!active);
                if (active) document.body.setAttribute('aria-busy', 'true');
                else document.body.removeAttribute('aria-busy');
              }
            }
            function setProgress(el, pct) {
              var wrap = el.querySelector('.so-progress-wrap');
              var fill = el.querySelector('.so-progress-fill');
              var pctEl = el.querySelector('.so-progress-pct');
              if (!wrap || !fill || !pctEl) return;
              var hasPct = !(pct === null || typeof pct === 'undefined' || pct === '');
              var num = Number(pct);
              if (hasPct && Number.isFinite(num) && num >= 0) {
                var clamped = Math.max(0, Math.min(100, Math.round(num)));
                wrap.style.display = 'block';
                fill.style.width = clamped + '%';
                pctEl.textContent = clamped + '%';
              } else {
                wrap.style.display = 'none';
                fill.style.width = '0%';
                pctEl.textContent = '';
              }
            }
            function setElapsed(el, text) {
              var elapsedEl = el.querySelector('.so-elapsed');
              if (!elapsedEl) return;
              elapsedEl.textContent = text || '';
            }
            function setProcessingMotion(el, requested, preserveCurrent) {
              var host = el.querySelector('.processing-motion-host');
              if (!host || !window.WLProcessingMotion || typeof window.WLProcessingMotion.set !== 'function') {
                console.error('Processing motion library is unavailable.');
                return false;
              }
              return window.WLProcessingMotion.set(host, requested, !!preserveCurrent);
            }
            function fmtElapsed(ms) {
              var sec = Math.max(0, Math.floor(ms / 1000));
              var h = Math.floor(sec / 3600);
              var m = Math.floor((sec % 3600) / 60);
              var s = sec % 60;
              function pad2(x) { return String(x).padStart(2, '0'); }
              return pad2(h) + ':' + pad2(m) + ':' + pad2(s);
            }
            function defaultControlNote() {
              return 'We are getting things ready. This may take a moment.';
            }
            function actionLabel(name) {
              var labels = {
                pause: 'Pause',
                resume: 'Resume',
                skip: 'Skip remaining',
                cancel: 'Cancel'
              };
              return labels[name] || name;
            }
            function actionClass(name) {
              return 'so-action-' + String(name || '').replace(/[^a-z0-9_-]/gi, '');
            }
            function normalizeControlAction(raw) {
              if (typeof raw === 'string') {
                return {
                  name: raw.toLowerCase(),
                  label: actionLabel(raw.toLowerCase()),
                  confirm: raw === 'cancel' || raw === 'skip'
                };
              }
              if (!raw || typeof raw !== 'object') return null;
              var name = String(raw.name || raw.action || '').toLowerCase();
              if (!name) return null;
              return {
                name: name,
                label: String(raw.label || actionLabel(name)),
                confirm: raw.confirm === true || name === 'cancel' || name === 'skip',
                confirmTitle: String(raw.confirmTitle || ''),
                confirmDetail: String(raw.confirmDetail || ''),
                confirmLabel: String(raw.confirmLabel || 'Confirm')
              };
            }
            function clearConfirm(el) {
              var box = el && el.querySelector ? el.querySelector('.so-confirm') : null;
              if (!box) return;
              box.style.display = 'none';
              box.classList.remove('is-visible');
              box.removeAttribute('data-confirm-action');
            }
            function clearControlRevealTimer(id) {
              window.__spinnerOverlayControlTimers = window.__spinnerOverlayControlTimers || {};
              var timerMap = window.__spinnerOverlayControlTimers;
              if (timerMap[id]) {
                clearTimeout(timerMap[id]);
                delete timerMap[id];
              }
            }
            function setControlSlotVisibility(el, visible) {
              var slot = el && el.querySelector ? el.querySelector('.so-control-slot') : null;
              if (!slot) return;
              var note = el.querySelector('.so-control-note');
              var hasContent = slot.getAttribute('data-controls-present') === 'true';
              var show = !!visible && hasContent;
              if (note) note.style.opacity = '0';
              slot.setAttribute('data-controls-revealed', show ? 'true' : 'false');
              slot.style.display = show ? 'flex' : 'none';
              if (show && note) {
                void note.offsetWidth;
                note.style.opacity = '1';
              }
            }
            function revealControlsAfterDelay(el, id, delayMs) {
              if (!el) return;
              clearControlRevealTimer(id);
              setControlSlotVisibility(el, false);
              window.__spinnerOverlayControlTimers = window.__spinnerOverlayControlTimers || {};
              var timerMap = window.__spinnerOverlayControlTimers;
              timerMap[id] = setTimeout(function() {
                setControlSlotVisibility(el, true);
                delete timerMap[id];
              }, Math.max(0, delayMs || 0));
            }
            function renderControls(el, raw) {
              if (!el) return;
              var slot = el.querySelector('.so-control-slot');
              var actionBox = el.querySelector('.so-control-actions');
              var noteEl = el.querySelector('.so-control-note');
              if (!slot || !actionBox || !noteEl) return;
              var wasRevealed = slot.getAttribute('data-controls-revealed') === 'true';
              var spec = (raw && typeof raw === 'object') ? raw : {};
              var rawActions = Array.isArray(spec.actions) ? spec.actions : [];
              var actions = rawActions.map(normalizeControlAction).filter(function(x) { return !!x; });
              // Agent note: Keep overlay controls left-aligned on every platform
              // and beside every card layout, including cards with right media.
              var placement = 'left';
              var taskId = String(spec.taskId || '');
              var actionInputId = String(spec.actionInputId || 'global_overlay_action');
              var state = String(spec.state || (actions.length ? 'running' : 'unavailable'));
              slot.setAttribute('data-placement', placement);
              el.setAttribute('data-overlay-task-id', taskId);
              el.setAttribute('data-overlay-action-input', actionInputId);
              el.setAttribute('data-overlay-control-state', state);
              actionBox.innerHTML = '';
              actions.forEach(function(action) {
                var btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'so-control-action ' + actionClass(action.name);
                var label = document.createElement('span');
                label.className = 'so-control-label';
                label.textContent = action.label;
                btn.appendChild(label);
                btn.setAttribute('aria-label', action.label);
                btn.setAttribute('data-overlay-action', action.name);
                btn.setAttribute('data-overlay-confirm', action.confirm ? 'true' : 'false');
                if (action.confirmTitle) btn.setAttribute('data-confirm-title', action.confirmTitle);
                if (action.confirmDetail) btn.setAttribute('data-confirm-detail', action.confirmDetail);
                if (action.confirmLabel) btn.setAttribute('data-confirm-label', action.confirmLabel);
                actionBox.appendChild(btn);
              });
              var note = (typeof spec.note === 'string') ? spec.note : '';
              if (!actions.length && !note) note = defaultControlNote();
              noteEl.textContent = note;
              noteEl.style.display = note ? 'block' : 'none';
              var hasContent = !!(actions.length || note);
              slot.setAttribute('data-controls-present', hasContent ? 'true' : 'false');
              if (!hasContent) {
                slot.setAttribute('data-controls-revealed', 'false');
                slot.style.display = 'none';
              } else {
                slot.style.display = wasRevealed ? 'flex' : 'none';
              }
              return { taskId: taskId, hasContent: hasContent };
            }
            function showConfirm(el, btn) {
              var box = el.querySelector('.so-confirm');
              var titleEl = el.querySelector('.so-confirm-title');
              var detailEl = el.querySelector('.so-confirm-detail');
              var acceptBtn = el.querySelector('.so-confirm-accept');
              if (!box || !titleEl || !detailEl || !acceptBtn) return;
              var action = String(btn.getAttribute('data-overlay-action') || '');
              var status = el.querySelector('.so-message');
              var statusText = status ? status.textContent : 'The current operation';
              var title = btn.getAttribute('data-confirm-title') || (action === 'cancel' ? 'Cancel operation?' : 'Skip remaining work?');
              var detail = btn.getAttribute('data-confirm-detail');
              if (!detail) {
                detail = action === 'cancel'
                  ? 'Current status: ' + statusText + '. Uncommitted work will be discarded. The last valid state stays unchanged.'
                  : 'The current safe checkpoint will finish. Later steps will not run.';
              }
              titleEl.textContent = title;
              detailEl.textContent = detail;
              acceptBtn.textContent = btn.getAttribute('data-confirm-label') || (action === 'cancel' ? 'Confirm cancel' : 'Confirm');
              acceptBtn.className = 'so-confirm-action so-confirm-accept wan-squircle ' + actionClass(action);
              box.setAttribute('data-confirm-action', action);
              box.style.display = 'grid';
              box.classList.remove('is-visible');
              void box.offsetWidth;
              box.classList.add('is-visible');
            }
            function sendOverlayAction(el, action) {
              if (!el || !action) return;
              var inputId = el.getAttribute('data-overlay-action-input') || 'global_overlay_action';
              var seq = Number(el.getAttribute('data-overlay-action-seq') || 0) + 1;
              el.setAttribute('data-overlay-action-seq', String(seq));
              var payload = {
                overlayId: el.id || 'global_overlay',
                taskId: el.getAttribute('data-overlay-task-id') || '',
                action: String(action),
                sequence: seq,
                timestamp: Date.now()
              };
              if (window.Shiny && typeof window.Shiny.setInputValue === 'function') {
                window.Shiny.setInputValue(inputId, payload, {priority: 'event'});
              }
            }
            function showOverlay(payload) {
              if (!payload) payload = {};
              var id  = payload.id || 'global_overlay';
              var el  = document.getElementById(id);
              if (!el) return;     // fail quietly if overlay not mounted yet
              var lock = Object.prototype.hasOwnProperty.call(payload, 'lock') ? payload.lock !== false : true;
              syncInteractionLock(id, lock);
              var lightweight = !!payload.lightweight;
              var alreadyVisible = (el.style.display === 'flex');
              var previousTaskId = String(el.getAttribute('data-overlay-task-id') || '');
              var nextTaskId = '';
              if (payload.controls && typeof payload.controls === 'object') {
                nextTaskId = String(payload.controls.taskId || '');
              }
              // Agent note: A visible overlay can be reused by a new task; each
              // explicit taskId must start a fresh delayed control reveal.
              var controlTaskChanged = !!nextTaskId && nextTaskId !== previousTaskId;
              if (controlTaskChanged) {
                clearControlRevealTimer(id);
                setControlSlotVisibility(el, false);
              }
              setProcessingMotion(el, payload.loader, alreadyVisible);
              if (!alreadyVisible) {
                clearControlRevealTimer(id);
                setControlSlotVisibility(el, false);
              }
              var controlState = renderControls(el, payload.controls);
              clearConfirm(el);
              window.__spinnerOverlayTimers = window.__spinnerOverlayTimers || {};
              var timerMap = window.__spinnerOverlayTimers;
              setMessage(el, payload.text);
              if (!alreadyVisible || Object.prototype.hasOwnProperty.call(payload, 'tip')) {
                setTip(el, payload.tip);
              }
              setProgress(el, payload.pct);
              if (alreadyVisible) {
                clearMemeRevealTimer(id);
                hideMemeNow(el);
                syncMediaToggleLinks(el);
                if (!lightweight) {
                  Promise.resolve(applyPreferredMedia(el)).then(function(hasMedia) {
                    if (hasMedia) revealRightAfterDelay(el, id, 3000);
                  });
                }
                if (controlTaskChanged && controlState && controlState.hasContent) {
                  revealControlsAfterDelay(el, id, 3000);
                }
                return;
              }

              clearMemeRevealTimer(id);
              hideMemeNow(el);
              setUserMediaMode(el, 'none');
              syncMediaToggleLinks(el);
              if (timerMap[id]) {
                clearInterval(timerMap[id]);
                delete timerMap[id];
              }
              var t0 = Date.now();
              setElapsed(el, 'Elapsed: 00:00:00');
              timerMap[id] = setInterval(function() {
                setElapsed(el, 'Elapsed: ' + fmtElapsed(Date.now() - t0));
              }, 1000);
              el.style.display = 'flex';
              // Agent note: Delay task controls for 3 seconds so short tasks do not flash action UI.
              if (controlState && controlState.hasContent) {
                revealControlsAfterDelay(el, id, 3000);
              } else {
                clearControlRevealTimer(id);
                setControlSlotVisibility(el, false);
              }
            }
            function hideOverlay(payload) {
              if (!payload) payload = {};
              var id  = payload.id || 'global_overlay';
              syncInteractionLock(id, false);
              var el  = document.getElementById(id);
              if (!el) return;
              window.__spinnerOverlayTimers = window.__spinnerOverlayTimers || {};
              var timerMap = window.__spinnerOverlayTimers;
              clearMemeRevealTimer(id);
              clearControlRevealTimer(id);
              hideMemeNow(el);
              setControlSlotVisibility(el, false);
              setUserMediaMode(el, 'none');
              setMediaMode(el, 'none');
              clearConfirm(el);
              if (timerMap[id]) {
                clearInterval(timerMap[id]);
                delete timerMap[id];
              }
              setElapsed(el, '');
              el.style.display = 'none';
            }
            document.addEventListener('click', function(ev) {
              var actionBtn = ev.target && ev.target.closest ? ev.target.closest('.so-control-action') : null;
              if (actionBtn) {
                var actionOverlay = actionBtn.closest('.so-backdrop');
                if (!actionOverlay) return;
                ev.preventDefault();
                var action = actionBtn.getAttribute('data-overlay-action') || '';
                if (actionBtn.getAttribute('data-overlay-confirm') === 'true') {
                  showConfirm(actionOverlay, actionBtn);
                } else {
                  sendOverlayAction(actionOverlay, action);
                }
                return;
              }
              var confirmCancel = ev.target && ev.target.closest ? ev.target.closest('.so-confirm-cancel') : null;
              if (confirmCancel) {
                var cancelOverlay = confirmCancel.closest('.so-backdrop');
                if (!cancelOverlay) return;
                ev.preventDefault();
                clearConfirm(cancelOverlay);
                return;
              }
              var confirmAccept = ev.target && ev.target.closest ? ev.target.closest('.so-confirm-accept') : null;
              if (confirmAccept) {
                var acceptOverlay = confirmAccept.closest('.so-backdrop');
                if (!acceptOverlay) return;
                ev.preventDefault();
                var confirmBox = acceptOverlay.querySelector('.so-confirm');
                var confirmedAction = confirmBox ? confirmBox.getAttribute('data-confirm-action') : '';
                clearConfirm(acceptOverlay);
                sendOverlayAction(acceptOverlay, confirmedAction);
                return;
              }
              var btn = ev.target && ev.target.closest ? ev.target.closest('.so-media-toggle-link') : null;
              if (!btn) return;
              var overlay = btn.closest('.so-backdrop');
              if (!overlay) return;
              var id = overlay.id || 'global_overlay';
              var mode = String(btn.getAttribute('data-media-mode') || '').toLowerCase();
              if (mode !== 'meme') return;
              ev.preventDefault();
              setUserMediaMode(overlay, mode);
              if (overlay.style.display !== 'flex') return;
              hideMemeNow(overlay);
              Promise.resolve(applyPreferredMedia(overlay)).then(function(hasMedia) {
                if (hasMedia) revealRightAfterDelay(overlay, id, 0);
              });
            }, true);

            window.WLSpinnerOverlay = window.WLSpinnerOverlay || {
              show: showOverlay,
              hide: hideOverlay
            };

            Shiny.addCustomMessageHandler('spinner-overlay-toggle', function(payload) {
              if (!payload) return;
              if (payload.visible) {
                showOverlay(payload);
              } else {
                hideOverlay(payload);
              }
            });
          })();
        "))
      )
    )
  )
}

overlay_ui <- function(id = "global_overlay", default_text = "Working…") {
  # NOTE: id is used as a plain DOM id, not namespaced,
  # because the JS looks it up with document.getElementById(id).
  meme_paths <- .spinner_overlay_meme_paths()
  shiny::div(
    id = id,
    class = "so-backdrop",
    style = "display:none;",
    `data-default-text` = default_text,
    `data-tips` = jsonlite::toJSON(SPINNER_OVERLAY_TIPS, auto_unbox = FALSE),
    `data-memes` = jsonlite::toJSON(meme_paths, auto_unbox = FALSE),
    `data-user-media-mode` = "none",
    shiny::div(
      class = "so-card wan-squircle",
      shiny::div(
        class = "so-left",
        shiny::div(
          class = "so-control-slot",
          `data-placement` = "left",
          shiny::div(class = "so-control-actions"),
          shiny::div(class = "so-control-note")
        ),
        shiny::div(
          class = "so-content",
          processing_motion_ui(class = "so-spinner"),
          shiny::div(class = "so-message", default_text),
          shiny::div(
            class = "so-progress-wrap",
            shiny::div(class = "so-progress-track", shiny::div(class = "so-progress-fill")),
            shiny::div(class = "so-progress-pct", "")
          ),
          shiny::div(
            class = "so-confirm",
            role = "alertdialog",
            `aria-live` = "assertive",
            shiny::div(class = "so-confirm-title"),
            shiny::div(class = "so-confirm-detail"),
            shiny::div(
              class = "so-confirm-actions",
              shiny::tags$button(
                type = "button",
                class = "so-confirm-action so-confirm-cancel wan-squircle",
                "Keep running"
              ),
              shiny::tags$button(
                type = "button",
                class = "so-confirm-action so-confirm-accept wan-squircle",
                "Confirm"
              )
            )
          ),
          shiny::div(class = "so-elapsed", ""),
          shiny::div(class = "so-tip", ""),
          shiny::div(
            class = "so-media-toggle-wrap",
            shiny::tags$button(
              type = "button",
              class = "so-media-toggle-link",
              `data-media-mode` = "meme",
              "Tired of waiting? I want to have some fun"
            )
          )
        )
      ),
      shiny::div(
        class = "so-right",
        shiny::tags$img(class = "so-meme", alt = "Random lab meme")
      )
    )
  )
}

overlay_show <- function(text = NULL,
                         id = "global_overlay",
                         session = shiny::getDefaultReactiveDomain(),
                         pct = NULL,
                         tip = NULL,
                         lightweight = FALSE,
                         lock = TRUE,
                         controls = NULL,
                         loader = NULL) {
  if (is.null(session)) return(invisible(NULL))
  tip_use <- if (is.null(tip)) .spinner_pick_tip() else as.character(tip)
  loader_use <- processing_motion_loader(loader)
  payload <- list(
    id = id,
    visible = TRUE,
    text = text,
    pct = pct,
    tip = tip_use,
    lightweight = isTRUE(lightweight),
    lock = isTRUE(lock),
    controls = controls
  )
  if (!is.null(loader_use)) payload$loader <- loader_use
  session$sendCustomMessage(
    "spinner-overlay-toggle",
    payload
  )
  invisible(NULL)
}

overlay_hide <- function(id = "global_overlay",
                         session = shiny::getDefaultReactiveDomain()) {
  if (is.null(session)) return(invisible(NULL))
  session$sendCustomMessage(
    "spinner-overlay-toggle",
    list(id = id, visible = FALSE)
  )
  invisible(NULL)
}
