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
            var peers = document.querySelectorAll('details.app-accordion[data-accordion-group="' + grp + '"]');
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
              handle.innerHTML = '<span class=\'app-resize-handle-grip\'></span><span class=\'app-resize-handle-text\'>Drag to resize</span>';
              
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

(function () {
        // Global Plotly modebar export policy:
        // - Keep modebar UX, but ensure two explicit export buttons: SVG and PNG.
        var PNG_SCALE = 4; // high-resolution raster fallback (Plotly uses scale, not direct DPI)

        function safeFilename(s) {
          return (s || 'plot_export')
            .toString()
            .trim()
            .replace(/\s+/g, '_')
            .replace(/[^A-Za-z0-9_\-]/g, '');
        }

        function ensureDualExportButtons(gd) {
          if (!gd || !window.Plotly || !Plotly.downloadImage) return;
          var modebar = gd.querySelector('.modebar');
          if (!modebar) return;

          var cameraBtn = modebar.querySelector('.modebar-btn[data-title*="Download plot"]');
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
