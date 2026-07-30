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
#   overlay_show(text = NULL, id = "global_overlay", session = getDefaultReactiveDomain(), pct = NULL, tip = NULL)
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

.spinner_overlay_ascii_source_paths <- function() {
  ascii_dir <- file.path("www", "ascii_busy_overlay")
  if (!dir.exists(ascii_dir)) return(character(0))
  files <- list.files(
    ascii_dir,
    pattern = "\\.js$",
    ignore.case = TRUE
  )
  files <- files[nzchar(files)]
  if (!length(files)) return(character(0))
  file.path("ascii_busy_overlay", files)
}

.spinner_pick_tip <- function(tips = SPINNER_OVERLAY_TIPS) {
  if (is.null(tips)) tips <- character(0)
  tips <- as.character(tips)
  tips <- tips[nzchar(trimws(tips))]
  if (!length(tips)) return("")
  sample(tips, size = 1)
}

overlay_deps <- function() {
  shiny::tagList(
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
          .so-card.is-expanded{
            width: fit-content;
            max-width: 94vw;
            grid-template-columns: minmax(320px, 430px) auto;
            gap: 20px;
          }
          .so-left{
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: center;
            text-align: left;
            gap: 14px;
            min-width: 0;
            padding-left: 18px;
            padding-right: 4px;
            position: relative;
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
          .so-ascii-host{
            width: auto;
            height: calc(50vh - 40px);
            max-width: min(48vw, 620px);
            aspect-ratio: 1 / 1;
            border-radius: var(--so-inner-radius);
            background: #ffffff;
            position: relative;
            overflow: hidden;
            display: none;
          }
          .so-ascii-host,
          .so-ascii-host *{
            background: #ffffff !important;
          }
          .so-ascii-diag{
            width: auto;
            height: calc(50vh - 40px);
            max-width: min(48vw, 620px);
            border-radius: var(--so-inner-radius);
            background: #f8fafc;
            color: #1e293b;
            padding: 16px;
            font-size: 13px;
            line-height: 1.35;
            display: none;
            align-items: center;
            justify-content: center;
            text-align: center;
          }
          .so-spinner{
            width: 72px;
            height: 72px;
            border-radius: 50%;
            border: 6px solid rgba(148,163,184,0.32);
            border-top-color: #3b82f6;
            animation: so-spin 0.9s linear infinite;
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
            display: none;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            width: auto;
            justify-content: flex-end;
            position: absolute;
            right: 6px;
            bottom: 2px;
          }
          .so-card.is-expanded .so-media-toggle-wrap{
            display: flex;
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
            .so-ascii-host{
              height: auto;
              max-height: 44vh;
            }
            .so-ascii-diag{
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
            function presenterModeOn(el) {
              return (String(el.getAttribute('data-presenter-mode') || '').toLowerCase() === 'true');
            }
            function getUserMediaMode(el) {
              var mode = String(el.getAttribute('data-user-media-mode') || 'auto').toLowerCase();
              if (mode !== 'ascii' && mode !== 'meme') return 'auto';
              return mode;
            }
            function setUserMediaMode(el, mode) {
              var clean = String(mode || 'auto').toLowerCase();
              if (clean !== 'ascii' && clean !== 'meme') clean = 'auto';
              el.setAttribute('data-user-media-mode', clean);
              syncMediaToggleLinks(el);
            }
            function setMediaMode(el, mode) {
              var imgEl = el.querySelector('.so-meme');
              var asciiHost = el.querySelector('.so-ascii-host');
              var diagEl = el.querySelector('.so-ascii-diag');
              if (imgEl) imgEl.style.display = (mode === 'meme') ? 'block' : 'none';
              if (asciiHost) asciiHost.style.display = (mode === 'ascii') ? 'block' : 'none';
              if (diagEl) diagEl.style.display = (mode === 'diag') ? 'flex' : 'none';
            }
            function syncMediaToggleLinks(el) {
              var quiet = el.querySelector('.so-media-toggle-link[data-media-mode=\"ascii\"]');
              var fun = el.querySelector('.so-media-toggle-link[data-media-mode=\"meme\"]');
              if (!quiet || !fun) return;
              var mode = getUserMediaMode(el);
              quiet.style.display = (mode === 'ascii') ? 'none' : 'inline';
              fun.style.display = (mode === 'ascii') ? 'inline' : 'none';
            }
            function setAsciiDiagnostic(el, msg) {
              var diagEl = el.querySelector('.so-ascii-diag');
              if (!diagEl) return;
              diagEl.textContent = msg || '';
            }
            function clearAsciiMount(id) {
              window.__spinnerOverlayAsciiHandles = window.__spinnerOverlayAsciiHandles || {};
              var map = window.__spinnerOverlayAsciiHandles;
              var handle = map[id];
              if (handle && typeof handle.destroy === 'function') {
                try { handle.destroy(); } catch (e) {}
              }
              delete map[id];
            }
            function loadAsciiSourceScript(src) {
              return new Promise(function(resolve, reject) {
                var prev = document.getElementById('spinner-overlay-ascii-source-script');
                if (prev && prev.parentNode) prev.parentNode.removeChild(prev);
                var cleanSrc = String(src || '');
                if (cleanSrc && cleanSrc.charAt(0) !== '/' && !/^https?:\\/\\//i.test(cleanSrc)) {
                  cleanSrc = '/' + cleanSrc;
                }
                var script = document.createElement('script');
                script.id = 'spinner-overlay-ascii-source-script';
                script.src = cleanSrc + (cleanSrc.indexOf('?') >= 0 ? '&' : '?') + 'v=' + Date.now();
                script.async = true;
                script.onload = function() { resolve(); };
                script.onerror = function() { reject(new Error('Failed to load ' + src)); };
                document.head.appendChild(script);
              });
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
            function mountRandomAscii(el, id) {
              var host = el.querySelector('.so-ascii-host');
              if (!host) return Promise.resolve(false);
              clearAsciiMount(id);
              host.innerHTML = '';
              var sources = parseListAttr(el, 'data-ascii-sources');
              if (!sources.length) {
                setAsciiDiagnostic(el, 'Presenter Mode is ON, but no ASCII source files were found in Content/www/ascii_busy_overlay/.');
                setMediaMode(el, 'diag');
                return Promise.resolve(true);
              }
              var idx = Math.floor(Math.random() * sources.length);
              var src = sources[idx];
              return loadAsciiSourceScript(src).then(function() {
                var api = window.TextmodeAsciiSource;
                if (!api || typeof api.mount !== 'function') {
                  throw new Error('TextmodeAsciiSource.mount is unavailable after loading ' + src);
                }
                setMediaMode(el, 'ascii');
                return Promise.resolve(api.mount(host, {
                  fitContainer: true,
                  showPlayButton: true,
                  settings: { bgColor: '#ffffff' }
                })).then(function(handle) {
                  window.__spinnerOverlayAsciiHandles = window.__spinnerOverlayAsciiHandles || {};
                  window.__spinnerOverlayAsciiHandles[id] = handle || null;
                  return true;
                });
              }).catch(function(err) {
                setAsciiDiagnostic(el, 'Presenter Mode ASCII render failed: ' + String((err && err.message) || err));
                setMediaMode(el, 'diag');
                return true;
              });
            }
            function showMemeMedia(el, id) {
              clearAsciiMount(id);
              setAsciiDiagnostic(el, '');
              return setRandomMeme(el);
            }
            function showAsciiMedia(el, id) {
              clearAsciiMount(id);
              setAsciiDiagnostic(el, '');
              return mountRandomAscii(el, id);
            }
            function applyPreferredMedia(el, id) {
              var mode = getUserMediaMode(el);
              if (mode === 'ascii') return showAsciiMedia(el, id);
              if (mode === 'meme') return Promise.resolve(showMemeMedia(el, id));
              if (presenterModeOn(el)) return showAsciiMedia(el, id);
              return Promise.resolve(showMemeMedia(el, id));
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
              var rightEl = el.querySelector('.so-right');
              var cardEl = el.querySelector('.so-card');
              if (!rightEl) return;
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
            function setProgress(el, pct) {
              var wrap = el.querySelector('.so-progress-wrap');
              var fill = el.querySelector('.so-progress-fill');
              var pctEl = el.querySelector('.so-progress-pct');
              if (!wrap || !fill || !pctEl) return;
              var num = Number(pct);
              if (Number.isFinite(num) && num > 0) {
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
            function fmtElapsed(ms) {
              var sec = Math.max(0, Math.floor(ms / 1000));
              var h = Math.floor(sec / 3600);
              var m = Math.floor((sec % 3600) / 60);
              var s = sec % 60;
              function pad2(x) { return String(x).padStart(2, '0'); }
              return pad2(h) + ':' + pad2(m) + ':' + pad2(s);
            }
            function clearOutputWait(id) {
              window.__spinnerOverlayOutputWaiters = window.__spinnerOverlayOutputWaiters || {};
              var waitMap = window.__spinnerOverlayOutputWaiters;
              if (waitMap[id]) {
                clearInterval(waitMap[id]);
                delete waitMap[id];
              }
            }
            function outputLooksReady(outputEl) {
              if (!outputEl) return false;
              var busy = outputEl.classList.contains('recalculating') || !!outputEl.querySelector('.recalculating');
              if (busy) return false;
              var img = outputEl.querySelector('img');
              if (img) {
                return !!img.complete && ((img.naturalWidth || 0) > 0);
              }
              if (outputEl.querySelector('canvas,svg')) return true;
              return false;
            }
            function hideOverlayWhenOutputReady(payload) {
              if (!payload) payload = {};
              var id = payload.id || 'global_overlay';
              var outputId = payload.outputId || '';
              if (!outputId) {
                hideOverlay({ id: id });
                return;
              }
              window.__spinnerOverlayOutputWaiters = window.__spinnerOverlayOutputWaiters || {};
              var waitMap = window.__spinnerOverlayOutputWaiters;
              clearOutputWait(id);
              var timeoutMs = Number(payload.timeoutMs);
              if (!Number.isFinite(timeoutMs) || timeoutMs <= 0) timeoutMs = 15000;
              var t0 = Date.now();
              waitMap[id] = setInterval(function() {
                var outputEl = document.getElementById(outputId);
                if (outputLooksReady(outputEl)) {
                  clearOutputWait(id);
                  hideOverlay({ id: id });
                  return;
                }
                if ((Date.now() - t0) >= timeoutMs) {
                  clearOutputWait(id);
                  hideOverlay({ id: id });
                }
              }, 100);
            }

            function showOverlay(payload) {
              if (!payload) payload = {};
              var id  = payload.id || 'global_overlay';
              var el  = document.getElementById(id);
              if (!el) return;     // fail quietly if overlay not mounted yet
              var lightweight = !!payload.lightweight;
              if (Object.prototype.hasOwnProperty.call(payload, 'presenterMode')) {
                el.setAttribute('data-presenter-mode', payload.presenterMode ? 'true' : 'false');
              }
              var alreadyVisible = (el.style.display === 'flex');
              window.__spinnerOverlayTimers = window.__spinnerOverlayTimers || {};
              var timerMap = window.__spinnerOverlayTimers;
              setMessage(el, payload.text);
              if (!alreadyVisible || Object.prototype.hasOwnProperty.call(payload, 'tip')) {
                setTip(el, payload.tip);
              }
              setProgress(el, payload.pct);
              if (alreadyVisible) {
                clearMemeRevealTimer(id);
                clearAsciiMount(id);
                hideMemeNow(el);
                setAsciiDiagnostic(el, '');
                syncMediaToggleLinks(el);
                if (!lightweight) {
                  Promise.resolve(applyPreferredMedia(el, id)).then(function(hasMedia) {
                    if (hasMedia) revealRightAfterDelay(el, id, 3000);
                  });
                }
                return;
              }

              clearOutputWait(id);
              clearMemeRevealTimer(id);
              clearAsciiMount(id);
              hideMemeNow(el);
              setAsciiDiagnostic(el, '');
              syncMediaToggleLinks(el);
              if (!lightweight) {
                Promise.resolve(applyPreferredMedia(el, id)).then(function(hasMedia) {
                  if (hasMedia) revealRightAfterDelay(el, id, 3000);
                });
              }
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
            }
            function hideOverlay(payload) {
              if (!payload) payload = {};
              var id  = payload.id || 'global_overlay';
              var el  = document.getElementById(id);
              if (!el) return;
              window.__spinnerOverlayTimers = window.__spinnerOverlayTimers || {};
              var timerMap = window.__spinnerOverlayTimers;
              clearOutputWait(id);
              clearMemeRevealTimer(id);
              clearAsciiMount(id);
              hideMemeNow(el);
              setMediaMode(el, 'meme');
              if (timerMap[id]) {
                clearInterval(timerMap[id]);
                delete timerMap[id];
              }
              setElapsed(el, '');
              el.style.display = 'none';
            }
            function setPresenterMode(payload) {
              if (!payload) payload = {};
              var id = payload.id || 'global_overlay';
              var el = document.getElementById(id);
              if (!el) return;
              el.setAttribute('data-presenter-mode', payload.presenterMode ? 'true' : 'false');
              if (!payload.presenterMode) {
                clearAsciiMount(id);
                setMediaMode(el, 'meme');
              }
            }
            document.addEventListener('click', function(ev) {
              var btn = ev.target && ev.target.closest ? ev.target.closest('.so-media-toggle-link') : null;
              if (!btn) return;
              var overlay = btn.closest('.so-backdrop');
              if (!overlay) return;
              var id = overlay.id || 'global_overlay';
              var mode = String(btn.getAttribute('data-media-mode') || '').toLowerCase();
              if (mode !== 'ascii' && mode !== 'meme') return;
              ev.preventDefault();
              setUserMediaMode(overlay, mode);
              if (overlay.style.display !== 'flex') return;
              hideMemeNow(overlay);
              Promise.resolve(applyPreferredMedia(overlay, id)).then(function(hasMedia) {
                if (hasMedia) revealRightAfterDelay(overlay, id, 0);
              });
            }, true);

            window.WLSpinnerOverlay = window.WLSpinnerOverlay || {
              show: showOverlay,
              hide: hideOverlay,
              hideWhenOutputReady: hideOverlayWhenOutputReady,
              setPresenterMode: setPresenterMode
            };

            Shiny.addCustomMessageHandler('spinner-overlay-toggle', function(payload) {
              if (!payload) return;
              if (payload.visible) {
                showOverlay(payload);
              } else {
                hideOverlay(payload);
              }
            });
            Shiny.addCustomMessageHandler('spinner-overlay-hide-when-output-ready', function(payload) {
              hideOverlayWhenOutputReady(payload);
            });
            Shiny.addCustomMessageHandler('spinner-overlay-set-presenter-mode', function(payload) {
              setPresenterMode(payload);
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
  ascii_source_paths <- .spinner_overlay_ascii_source_paths()
  shiny::div(
    id = id,
    class = "so-backdrop",
    style = "display:none;",
    `data-default-text` = default_text,
    `data-tips` = jsonlite::toJSON(SPINNER_OVERLAY_TIPS, auto_unbox = FALSE),
    `data-memes` = jsonlite::toJSON(meme_paths, auto_unbox = FALSE),
    `data-ascii-sources` = jsonlite::toJSON(ascii_source_paths, auto_unbox = FALSE),
    `data-user-media-mode` = "auto",
    `data-presenter-mode` = "false",
    shiny::div(
      class = "so-card",
      shiny::div(
        class = "so-left",
        shiny::div(class = "so-spinner"),
        shiny::div(class = "so-message", default_text),
        shiny::div(
          class = "so-progress-wrap",
          shiny::div(class = "so-progress-track", shiny::div(class = "so-progress-fill")),
          shiny::div(class = "so-progress-pct", "")
        ),
        shiny::div(class = "so-elapsed", ""),
        shiny::div(class = "so-tip", ""),
        shiny::div(
          class = "so-media-toggle-wrap",
          shiny::tags$button(
            type = "button",
            class = "so-media-toggle-link",
            `data-media-mode` = "ascii",
            "Turn this off, I need some tranquility"
          ),
          shiny::tags$button(
            type = "button",
            class = "so-media-toggle-link",
            `data-media-mode` = "meme",
            style = "display:none;",
            "Tired of waiting? I want to have some fun"
          )
        )
      ),
      shiny::div(
        class = "so-right",
        shiny::div(class = "so-ascii-host"),
        shiny::div(class = "so-ascii-diag"),
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
                         lightweight = FALSE) {
  if (is.null(session)) return(invisible(NULL))
  presenter_mode <- isTRUE(session$userData$presenter_mode_on)
  tip_use <- if (is.null(tip)) .spinner_pick_tip() else as.character(tip)
  session$sendCustomMessage(
    "spinner-overlay-toggle",
    list(id = id, visible = TRUE, text = text, pct = pct, tip = tip_use, presenterMode = presenter_mode, lightweight = isTRUE(lightweight))
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

overlay_hide_when_output_ready <- function(output_id,
                                           id = "global_overlay",
                                           session = shiny::getDefaultReactiveDomain(),
                                           timeout_ms = 15000L) {
  if (is.null(session) || is.null(output_id) || !nzchar(as.character(output_id))) return(invisible(NULL))
  session$sendCustomMessage(
    "spinner-overlay-hide-when-output-ready",
    list(id = id, outputId = as.character(output_id), timeoutMs = as.integer(timeout_ms))
  )
  invisible(NULL)
}
