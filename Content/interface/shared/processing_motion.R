# Reusable processing-motion library.
#
# This module owns motion geometry, animation rules, and loader state. Busy
# overlay code only hosts this component and selects an explicit type.

PROCESSING_MOTION_TYPES <- c(
  "generic", "import", "parse", "metrics", "filter", "embedding",
  "feature", "integration", "cluster", "selected", "export", "package"
)

# Agent note: Motion names describe operation data shape. Keep selection
# explicit at call sites; do not infer animation from user-facing text.
# Agent note: Generic orbit uses one shared focus and Kepler phase so dots move
# faster near the focus and slower at the far point; preserve clockwise motion
# and the 1:1 viewBox when tuning its parameters.
processing_motion_loader <- function(loader = "generic") {
  if (is.null(loader)) return(NULL)
  if (length(loader) != 1L || is.na(loader)) {
    stop("Processing motion type must be one non-missing loader name.")
  }
  match.arg(tolower(trimws(as.character(loader))), PROCESSING_MOTION_TYPES)
}

processing_motion_deps <- function() {
  shiny::tagList(
    shiny::singleton(
      shiny::tags$style(shiny::HTML('
        .processing-motion-host{
          --pm-stroke: 3px;
          --pm-dot-radius: 4px;
          --pm-pill-width: 24px;
          --pm-pill-height: 8px;
          --pm-visual-left: 0px;
          width: 120px;
          height: 120px;
          display: flex;
          align-items: center;
          justify-content: center;
          color: #222222;
          flex: 0 0 auto;
        }
        .processing-motion-graphic{
          display: none;
          width: 120px;
          height: 80px;
          overflow: visible;
          transform: translateX(calc(-1 * var(--pm-visual-left)));
        }
        .processing-motion-host .processing-motion-graphic[data-processing-motion-graphic="generic"]{
          width: 120px;
          height: 120px;
        }
        /* Agent note: Keep each SVG visible artwork flush with the shared
           text edge; viewBox widths differ from artwork bounds. */
        .processing-motion-host[data-processing-motion="generic"]{ --pm-visual-left: 13px; }
        .processing-motion-host[data-processing-motion="import"]{ --pm-visual-left: 18px; }
        .processing-motion-host[data-processing-motion="parse"]{ --pm-visual-left: 26px; }
        .processing-motion-host[data-processing-motion="metrics"]{ --pm-visual-left: 20px; }
        .processing-motion-host[data-processing-motion="filter"]{ --pm-visual-left: 20px; }
        .processing-motion-host[data-processing-motion="embedding"]{ --pm-visual-left: 10px; }
        .processing-motion-host[data-processing-motion="feature"]{ --pm-visual-left: 22px; }
        .processing-motion-host[data-processing-motion="integration"]{ --pm-visual-left: 22px; }
        .processing-motion-host[data-processing-motion="cluster"]{ --pm-visual-left: 46px; }
        .processing-motion-host[data-processing-motion="selected"]{ --pm-visual-left: 26px; }
        .processing-motion-host[data-processing-motion="export"]{ --pm-visual-left: 20px; }
        .processing-motion-host[data-processing-motion="package"]{ --pm-visual-left: 30px; }
        .processing-motion-host[data-processing-motion="generic"] .processing-motion-graphic[data-processing-motion-graphic="generic"],
        .processing-motion-host[data-processing-motion="import"] .processing-motion-graphic[data-processing-motion-graphic="import"],
        .processing-motion-host[data-processing-motion="parse"] .processing-motion-graphic[data-processing-motion-graphic="parse"],
        .processing-motion-host[data-processing-motion="metrics"] .processing-motion-graphic[data-processing-motion-graphic="metrics"],
        .processing-motion-host[data-processing-motion="filter"] .processing-motion-graphic[data-processing-motion-graphic="filter"],
        .processing-motion-host[data-processing-motion="embedding"] .processing-motion-graphic[data-processing-motion-graphic="embedding"],
        .processing-motion-host[data-processing-motion="feature"] .processing-motion-graphic[data-processing-motion-graphic="feature"],
        .processing-motion-host[data-processing-motion="integration"] .processing-motion-graphic[data-processing-motion-graphic="integration"],
        .processing-motion-host[data-processing-motion="cluster"] .processing-motion-graphic[data-processing-motion-graphic="cluster"],
        .processing-motion-host[data-processing-motion="selected"] .processing-motion-graphic[data-processing-motion-graphic="selected"],
        .processing-motion-host[data-processing-motion="export"] .processing-motion-graphic[data-processing-motion-graphic="export"],
        .processing-motion-host[data-processing-motion="package"] .processing-motion-graphic[data-processing-motion-graphic="package"]{
          display: block;
        }
        .processing-motion-host .pm-stroke{
          fill: none;
          stroke: currentColor;
          stroke-width: var(--pm-stroke);
          stroke-linecap: round;
          stroke-linejoin: round;
        }
        .processing-motion-host .pm-dot,
        .processing-motion-host .pm-pill{
          fill: currentColor;
        }
        .processing-motion-host .pm-dot{
          r: var(--pm-dot-radius);
        }
        .processing-motion-host .pm-pill{
          width: var(--pm-pill-width);
          height: var(--pm-pill-height);
          rx: calc(var(--pm-pill-height) / 2);
        }
        .pm-generic-dot{
          animation: pm-generic 1.75s cubic-bezier(0.4, 0, 0.2, 1) infinite;
        }
        .pm-generic-core{
          animation: pm-generic-core 1.4s cubic-bezier(0.4, 0, 0.2, 1) infinite;
        }
        @keyframes pm-generic{
          0%, 100%{ opacity: 0.28; }
          50%{ opacity: 0.82; }
        }
        @keyframes pm-generic-core{
          0%, 100%{ opacity: 0.62; }
          50%{ opacity: 1; }
        }
        .pm-import-row,
        .pm-parse-row,
        .pm-metric-row,
        .pm-export-row,
        .pm-package-part{
          animation-duration: 2.6s;
          animation-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
          animation-iteration-count: infinite;
        }
        .pm-import-row{ animation-name: pm-import; }
        @keyframes pm-import{
          0%, 100%{ opacity: 0.24; transform: translateX(-12px); }
          48%{ opacity: 0.82; transform: translateX(5px); }
          72%{ opacity: 0.5; transform: translateX(0); }
        }
        .pm-parse-row{ animation-name: pm-parse; }
        @keyframes pm-parse{
          0%, 100%{ opacity: 0.24; transform: translateY(7px); }
          48%{ opacity: 0.82; transform: translateY(0); }
          72%{ opacity: 0.5; transform: translateY(2px); }
        }
        .pm-metric-row{ animation-name: pm-metrics; }
        @keyframes pm-metrics{
          0%, 100%{ opacity: 0.24; transform: translateX(-8px); }
          48%{ opacity: 0.82; transform: translateX(0); }
          72%{ opacity: 0.5; transform: translateX(0); }
        }
        .pm-filter-value{
          opacity: 0.34;
          animation: pm-filter-value 2.8s cubic-bezier(0.4, 0, 0.2, 1) infinite;
        }
        .pm-filter-value:nth-child(2){ animation-delay: -0.2s; }
        .pm-filter-value:nth-child(3){ animation-delay: -0.4s; }
        .pm-filter-value:nth-child(4){ animation-delay: -0.6s; }
        .pm-filter-value:nth-child(5){ animation-delay: -0.8s; }
        .pm-filter-value:nth-child(6){ animation-delay: -1s; }
        .pm-filter-value:nth-child(7){ animation-delay: -1.2s; }
        @keyframes pm-filter-value{
          0%, 100%{ opacity: 0.34; }
          28%{ opacity: 0.86; }
          62%, 78%{ opacity: 0.42; }
        }
        .pm-filter-outside{ animation-name: pm-filter-outside; }
        @keyframes pm-filter-outside{
          0%, 34%{ opacity: 0.34; }
          58%{ opacity: 0.18; }
          72%, 100%{ opacity: 0.04; }
        }
        .pm-filter-bound{
          transform-box: view-box;
          transform-origin: 0 0;
          animation-duration: 2.8s;
          animation-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
          animation-iteration-count: infinite;
        }
        .pm-filter-bound.left{ animation-name: pm-filter-bound-left; }
        .pm-filter-bound.right{ animation-name: pm-filter-bound-right; }
        @keyframes pm-filter-bound-left{
          0%, 100%{ opacity: 0.22; transform: translateX(0); }
          26%{ opacity: 0.76; transform: translateX(0); }
          62%{ opacity: 0.82; transform: translateX(18px); }
          78%{ opacity: 0.42; transform: translateX(18px); }
        }
        @keyframes pm-filter-bound-right{
          0%, 100%{ opacity: 0.22; transform: translateX(0); }
          26%{ opacity: 0.76; transform: translateX(0); }
          62%{ opacity: 0.82; transform: translateX(-18px); }
          78%{ opacity: 0.42; transform: translateX(-18px); }
        }
        .pm-embedding-row{
          animation: pm-embedding-row 3s cubic-bezier(0.4, 0, 0.2, 1) infinite;
        }
        .pm-embedding-row:nth-child(2){ animation-delay: -0.28s; }
        .pm-embedding-row:nth-child(3){ animation-delay: -0.56s; }
        @keyframes pm-embedding-row{
          0%, 100%{ opacity: 0.4; transform: translateX(0); }
          24%{ opacity: 0.86; transform: translateX(0); }
          54%, 70%{ opacity: 0.5; transform: translateX(3px); }
        }
        .pm-embedding-scan{
          transform-box: view-box;
          transform-origin: 0 0;
          animation: pm-embedding-scan 3s cubic-bezier(0.4, 0, 0.2, 1) infinite;
        }
        @keyframes pm-embedding-scan{
          0%, 22%{ opacity: 0; transform: translateX(0); }
          30%{ opacity: 0.72; transform: translateX(0); }
          58%{ opacity: 0.72; transform: translateX(28px); }
          68%, 100%{ opacity: 0; transform: translateX(28px); }
        }
        .pm-embedding-transfer{
          stroke-dasharray: 1 7;
          animation: pm-embedding-transfer 3s linear infinite;
        }
        @keyframes pm-embedding-transfer{
          0%, 46%{ opacity: 0; stroke-dashoffset: 0; }
          54%, 70%{ opacity: 0.5; stroke-dashoffset: -16; }
          78%, 100%{ opacity: 0; stroke-dashoffset: -16; }
        }
        .pm-embedding-result{
          opacity: 0.56;
          animation: pm-embedding-result 3s cubic-bezier(0.4, 0, 0.2, 1) infinite;
        }
        @keyframes pm-embedding-result{
          0%, 50%{ opacity: 0.56; }
          68%{ opacity: 0.86; }
          88%{ opacity: 0.72; }
          100%{ opacity: 0.56; }
        }
        .pm-feature-point{
          opacity: 0.34;
          animation: pm-feature-point 2.6s cubic-bezier(0.4, 0, 0.2, 1) infinite;
        }
        .pm-feature-point:nth-child(2){ animation-delay: -0.32s; }
        .pm-feature-point:nth-child(3){ animation-delay: -0.64s; }
        .pm-feature-point:nth-child(4){ animation-delay: -0.96s; }
        .pm-feature-point:nth-child(5){ animation-delay: -1.28s; }
        @keyframes pm-feature-point{
          0%, 100%{ opacity: 0.28; }
          48%{ opacity: 0.82; }
          72%{ opacity: 0.46; }
        }
        .pm-integration-left,
        .pm-integration-right{
          animation-duration: 2.75s;
          animation-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
          animation-iteration-count: infinite;
        }
        .pm-integration-left{ animation-name: pm-integration-left; }
        .pm-integration-right{ animation-name: pm-integration-right; }
        @keyframes pm-integration-left{
          0%, 100%{ opacity: 0.28; transform: translateX(-8px); }
          50%{ opacity: 0.78; transform: translateX(4px); }
        }
        @keyframes pm-integration-right{
          0%, 100%{ opacity: 0.28; transform: translateX(8px); }
          50%{ opacity: 0.78; transform: translateX(-4px); }
        }
        .pm-cluster-group{
          animation: pm-cluster-group 2.9s cubic-bezier(0.4, 0, 0.2, 1) infinite;
        }
        .pm-cluster-group:nth-child(2){ animation-delay: -0.48s; }
        .pm-cluster-group:nth-child(3){ animation-delay: -0.96s; }
        @keyframes pm-cluster-group{
          0%, 100%{ opacity: 0.28; transform: translate(0, 0); }
          52%{ opacity: 0.78; transform: translate(var(--pm-cluster-x), var(--pm-cluster-y)); }
          74%{ opacity: 0.46; transform: translate(calc(var(--pm-cluster-x) * 0.7), calc(var(--pm-cluster-y) * 0.7)); }
        }
        .pm-context-cloud{
          opacity: 0.18;
          animation: pm-context 2.8s cubic-bezier(0.4, 0, 0.2, 1) infinite;
        }
        @keyframes pm-context{
          0%, 100%{ opacity: 0.18; }
          48%{ opacity: 0.32; }
          72%{ opacity: 0.16; }
        }
        .pm-selected-cloud{
          opacity: 0.34;
          animation: pm-selected 2.8s cubic-bezier(0.4, 0, 0.2, 1) infinite;
        }
        @keyframes pm-selected{
          0%, 100%{ opacity: 0.34; }
          48%{ opacity: 0.82; }
          72%{ opacity: 0.5; }
        }
        .pm-export-row{ animation-name: pm-export; }
        @keyframes pm-export{
          0%, 100%{ opacity: 0.22; transform: translateX(0); }
          50%{ opacity: 0.78; transform: translateX(30px); }
          72%{ opacity: 0.28; transform: translateX(40px); }
        }
        .pm-package-part{ animation-name: pm-package; }
        @keyframes pm-package{
          0%, 100%{ opacity: 0.24; transform: translateY(-8px); }
          50%{ opacity: 0.78; transform: translateY(0); }
          72%{ opacity: 0.46; transform: translateY(2px); }
        }
        @media (prefers-reduced-motion: reduce){
          .processing-motion-host *{ animation-play-state: paused !important; }
        }
      '))
    ),
    shiny::singleton(
      shiny::tags$script(shiny::HTML('
        (function() {
          var types = {
            generic: true,
            import: true,
            parse: true,
            metrics: true,
            filter: true,
            embedding: true,
            feature: true,
            integration: true,
            cluster: true,
            selected: true,
            export: true,
            package: true
          };
          var TAU = Math.PI * 2;
          var focusX = 60;
          var focusY = 60;
          function solveKepler(meanAnomaly, eccentricity) {
            var eccentricAnomaly = meanAnomaly;
            for (var iteration = 0; iteration < 7; iteration += 1) {
              var residual = eccentricAnomaly - eccentricity * Math.sin(eccentricAnomaly) - meanAnomaly;
              eccentricAnomaly -= residual / (1 - eccentricity * Math.cos(eccentricAnomaly));
            }
            return eccentricAnomaly;
          }
          function placeGenericOrbit(circle, orbit, elapsedSeconds) {
            var meanAnomaly = ((orbit.phase + elapsedSeconds / orbit.period) % 1 + 1) % 1 * TAU;
            var eccentricAnomaly = solveKepler(meanAnomaly, orbit.e);
            var semiMinor = orbit.a * Math.sqrt(1 - orbit.e * orbit.e);
            var localX = orbit.a * (Math.cos(eccentricAnomaly) - orbit.e);
            var localY = semiMinor * Math.sin(eccentricAnomaly);
            var cosOmega = Math.cos(orbit.omega);
            var sinOmega = Math.sin(orbit.omega);
            var x = focusX + localX * cosOmega - localY * sinOmega;
            var y = focusY + localX * sinOmega + localY * cosOmega;
            circle.setAttribute("cx", x.toFixed(3));
            circle.setAttribute("cy", y.toFixed(3));
          }
          function startGenericMotion(host) {
            if (!host || host.__wlGenericMotionFrame) return;
            var circles = Array.prototype.slice.call(host.querySelectorAll("[data-pm-orbit]"));
            if (!circles.length) return;
            var orbits = circles.map(function(circle) {
              return { circle: circle, orbit: JSON.parse(circle.getAttribute("data-pm-orbit")) };
            });
            var startedAt = window.performance.now();
            var reducedMotion = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
            var frame = function(now) {
              var elapsedSeconds = (now - startedAt) / 1000;
              orbits.forEach(function(item) {
                placeGenericOrbit(item.circle, item.orbit, elapsedSeconds);
              });
              if (!reducedMotion) host.__wlGenericMotionFrame = window.requestAnimationFrame(frame);
            };
            host.__wlGenericMotionFrame = window.requestAnimationFrame(frame);
          }
          function initGenericMotion(root) {
            if (!root) return;
            Array.prototype.forEach.call(root.querySelectorAll(".processing-motion-host"), startGenericMotion);
          }
          function set(host, requested, preserveCurrent) {
            if (!host || typeof host.setAttribute !== "function") {
              console.error("Processing motion host is unavailable.");
              return false;
            }
            var current = String(host.getAttribute("data-processing-motion") || "generic").toLowerCase();
            var value = (requested === null || typeof requested === "undefined" || requested === "")
              ? (preserveCurrent ? current : "generic")
              : String(requested).trim().toLowerCase();
            if (!Object.prototype.hasOwnProperty.call(types, value)) {
              console.error("Unknown processing motion type: " + value);
              return false;
            }
            host.setAttribute("data-processing-motion", value);
            startGenericMotion(host);
            return true;
          }
          window.WLProcessingMotion = { types: types, set: set, init: initGenericMotion };
          if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", function() { initGenericMotion(document); });
          } else {
            initGenericMotion(document);
          }
        })();
      '))
    )
  )
}

processing_motion_ui <- function(loader = "generic", class = NULL) {
  loader_use <- processing_motion_loader(loader)
  shiny::div(
    class = unique(c("processing-motion-host", class)),
    `data-processing-motion` = loader_use,
    `aria-hidden` = "true",
    shiny::HTML('
      <svg class="processing-motion-graphic" data-processing-motion-graphic="generic" viewBox="0 0 120 120" aria-hidden="true">
        <circle class="pm-dot pm-generic-core" r="4" data-pm-orbit="{&quot;a&quot;:8,&quot;e&quot;:0.38,&quot;omega&quot;:0,&quot;phase&quot;:0,&quot;period&quot;:1.8}"></circle>
        <circle class="pm-dot pm-generic-core" r="4" data-pm-orbit="{&quot;a&quot;:8,&quot;e&quot;:0.38,&quot;omega&quot;:0,&quot;phase&quot;:0.5,&quot;period&quot;:1.8}" style="animation-delay:-0.65s;"></circle>
        <circle class="pm-dot pm-generic-dot" r="4" data-pm-orbit="{&quot;a&quot;:19,&quot;e&quot;:0.28,&quot;omega&quot;:0,&quot;phase&quot;:0.05,&quot;period&quot;:2.2}" style="animation-delay:-0.2s;"></circle>
        <circle class="pm-dot pm-generic-dot" r="4" data-pm-orbit="{&quot;a&quot;:21,&quot;e&quot;:0.36,&quot;omega&quot;:0.35,&quot;phase&quot;:0.43,&quot;period&quot;:2.5}" style="animation-delay:-0.5s;"></circle>
        <circle class="pm-dot pm-generic-dot" r="4" data-pm-orbit="{&quot;a&quot;:24,&quot;e&quot;:0.42,&quot;omega&quot;:-0.24,&quot;phase&quot;:0.78,&quot;period&quot;:2.9}" style="animation-delay:-0.8s;"></circle>
        <circle class="pm-dot pm-generic-dot" r="4" data-pm-orbit="{&quot;a&quot;:26,&quot;e&quot;:0.3,&quot;omega&quot;:1.1,&quot;phase&quot;:0.22,&quot;period&quot;:3.2}" style="animation-delay:-1.1s;"></circle>
        <circle class="pm-dot pm-generic-dot" r="4" data-pm-orbit="{&quot;a&quot;:28,&quot;e&quot;:0.48,&quot;omega&quot;:-0.8,&quot;phase&quot;:0.61,&quot;period&quot;:3.7}" style="animation-delay:-0.4s;"></circle>
        <circle class="pm-dot pm-generic-dot" r="4" data-pm-orbit="{&quot;a&quot;:30,&quot;e&quot;:0.38,&quot;omega&quot;:0.58,&quot;phase&quot;:0.09,&quot;period&quot;:4.1}" style="animation-delay:-0.7s;"></circle>
        <circle class="pm-dot pm-generic-dot" r="4" data-pm-orbit="{&quot;a&quot;:32,&quot;e&quot;:0.44,&quot;omega&quot;:1.62,&quot;phase&quot;:0.48,&quot;period&quot;:4.7}" style="animation-delay:-1.3s;"></circle>
        <circle class="pm-dot pm-generic-dot" r="4" data-pm-orbit="{&quot;a&quot;:34,&quot;e&quot;:0.32,&quot;omega&quot;:-1.2,&quot;phase&quot;:0.83,&quot;period&quot;:5.3}" style="animation-delay:-0.9s;"></circle>
        <circle class="pm-dot pm-generic-dot" r="4" data-pm-orbit="{&quot;a&quot;:35,&quot;e&quot;:0.5,&quot;omega&quot;:0.92,&quot;phase&quot;:0.31,&quot;period&quot;:5.9}" style="animation-delay:-0.6s;"></circle>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="import" viewBox="0 0 120 80" aria-hidden="true">
        <g class="pm-import-row"><rect class="pm-pill" x="18" y="20" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="46" y="20" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="74" y="20" width="24" height="8" rx="4"></rect></g>
        <g class="pm-import-row" style="animation-delay:-0.42s;"><rect class="pm-pill" x="18" y="36" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="46" y="36" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="74" y="36" width="24" height="8" rx="4"></rect></g>
        <g class="pm-import-row" style="animation-delay:-0.84s;"><rect class="pm-pill" x="18" y="52" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="46" y="52" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="74" y="52" width="24" height="8" rx="4"></rect></g>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="parse" viewBox="0 0 120 80" aria-hidden="true">
        <g class="pm-parse-row"><circle class="pm-dot" cx="30" cy="26" r="4"></circle><circle class="pm-dot" cx="50" cy="26" r="4"></circle><circle class="pm-dot" cx="70" cy="26" r="4"></circle><circle class="pm-dot" cx="90" cy="26" r="4"></circle></g>
        <g class="pm-parse-row" style="animation-delay:-0.42s;"><circle class="pm-dot" cx="30" cy="40" r="4"></circle><circle class="pm-dot" cx="50" cy="40" r="4"></circle><circle class="pm-dot" cx="70" cy="40" r="4"></circle><circle class="pm-dot" cx="90" cy="40" r="4"></circle></g>
        <g class="pm-parse-row" style="animation-delay:-0.84s;"><circle class="pm-dot" cx="30" cy="54" r="4"></circle><circle class="pm-dot" cx="50" cy="54" r="4"></circle><circle class="pm-dot" cx="70" cy="54" r="4"></circle><circle class="pm-dot" cx="90" cy="54" r="4"></circle></g>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="metrics" viewBox="0 0 120 80" aria-hidden="true">
        <path class="pm-stroke" d="M22 62 H98" opacity="0.14"></path>
        <g class="pm-metric-row"><circle class="pm-dot" cx="28" cy="23" r="4"></circle><circle class="pm-dot" cx="42" cy="23" r="4"></circle><circle class="pm-dot" cx="56" cy="23" r="4"></circle><circle class="pm-dot" cx="70" cy="23" r="4"></circle></g>
        <g class="pm-metric-row" style="animation-delay:-0.42s;"><circle class="pm-dot" cx="28" cy="40" r="4"></circle><circle class="pm-dot" cx="42" cy="40" r="4"></circle><circle class="pm-dot" cx="56" cy="40" r="4"></circle><circle class="pm-dot" cx="70" cy="40" r="4"></circle></g>
        <g class="pm-metric-row" style="animation-delay:-0.84s;"><circle class="pm-dot" cx="28" cy="57" r="4"></circle><circle class="pm-dot" cx="42" cy="57" r="4"></circle><circle class="pm-dot" cx="56" cy="57" r="4"></circle><circle class="pm-dot" cx="70" cy="57" r="4"></circle></g>
        <path class="pm-stroke" d="M84 20 V60" opacity="0.24"></path>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="filter" viewBox="0 0 120 80" aria-hidden="true">
        <path class="pm-stroke" d="M22 60 H98" opacity="0.16"></path>
        <g class="pm-filter-values">
          <circle class="pm-dot pm-filter-value pm-filter-outside" cx="29" cy="34" r="4"></circle><circle class="pm-dot pm-filter-value pm-filter-outside" cx="37" cy="49" r="4"></circle><circle class="pm-dot pm-filter-value" cx="49" cy="27" r="4"></circle><circle class="pm-dot pm-filter-value" cx="61" cy="52" r="4"></circle><circle class="pm-dot pm-filter-value" cx="71" cy="35" r="4"></circle><circle class="pm-dot pm-filter-value pm-filter-outside" cx="83" cy="49" r="4"></circle><circle class="pm-dot pm-filter-value pm-filter-outside" cx="92" cy="29" r="4"></circle>
        </g>
        <g class="pm-filter-bound left"><path class="pm-stroke" d="M24 18 V60"></path></g><g class="pm-filter-bound right"><path class="pm-stroke" d="M96 18 V60"></path></g>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="embedding" viewBox="0 0 120 80" aria-hidden="true">
        <g class="pm-embedding-matrix">
          <g class="pm-embedding-row"><rect class="pm-pill" x="12" y="20" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="40" y="20" width="24" height="8" rx="4"></rect></g>
          <g class="pm-embedding-row" style="animation-delay:-0.28s;"><rect class="pm-pill" x="12" y="36" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="40" y="36" width="24" height="8" rx="4"></rect></g>
          <g class="pm-embedding-row" style="animation-delay:-0.56s;"><rect class="pm-pill" x="12" y="52" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="40" y="52" width="24" height="8" rx="4"></rect></g>
        </g>
        <g class="pm-embedding-scan"><path class="pm-stroke" d="M12 17 V63"></path></g><path class="pm-stroke pm-embedding-transfer" d="M70 40 H75" opacity="0.42"></path>
        <g class="pm-embedding-result"><circle class="pm-dot" cx="78" cy="31" r="4"></circle><circle class="pm-dot" cx="91" cy="25" r="4"></circle><circle class="pm-dot" cx="99" cy="38" r="4"></circle><circle class="pm-dot" cx="83" cy="48" r="4"></circle><circle class="pm-dot" cx="96" cy="54" r="4"></circle><circle class="pm-dot" cx="72" cy="43" r="4"></circle></g>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="feature" viewBox="0 0 120 80" aria-hidden="true">
        <path class="pm-stroke" d="M24 60 H98 M24 60 V20" opacity="0.2"></path>
        <circle class="pm-dot pm-feature-point" cx="42" cy="45" r="4"></circle><circle class="pm-dot pm-feature-point" cx="56" cy="34" r="4"></circle><circle class="pm-dot pm-feature-point" cx="70" cy="51" r="4"></circle><circle class="pm-dot pm-feature-point" cx="84" cy="29" r="4"></circle><circle class="pm-dot pm-feature-point" cx="92" cy="43" r="4"></circle>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="integration" viewBox="0 0 120 80" aria-hidden="true">
        <path class="pm-stroke" d="M24 62 H96" opacity="0.14"></path><g class="pm-integration-left"><circle class="pm-dot" cx="38" cy="31" r="4"></circle><circle class="pm-dot" cx="30" cy="44" r="4"></circle><circle class="pm-dot" cx="43" cy="52" r="4"></circle></g><g class="pm-integration-right"><circle class="pm-dot" cx="82" cy="28" r="4"></circle><circle class="pm-dot" cx="91" cy="43" r="4"></circle><circle class="pm-dot" cx="78" cy="53" r="4"></circle></g>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="cluster" viewBox="0 0 120 80" aria-hidden="true">
        <g class="pm-cluster-group" style="--pm-cluster-x:-8px;--pm-cluster-y:-6px;"><circle class="pm-dot" cx="50" cy="29" r="4"></circle><circle class="pm-dot" cx="55" cy="36" r="4"></circle></g><g class="pm-cluster-group" style="--pm-cluster-x:8px;--pm-cluster-y:-6px;"><circle class="pm-dot" cx="65" cy="29" r="4"></circle><circle class="pm-dot" cx="70" cy="36" r="4"></circle></g><g class="pm-cluster-group" style="--pm-cluster-x:0px;--pm-cluster-y:8px;"><circle class="pm-dot" cx="55" cy="51" r="4"></circle><circle class="pm-dot" cx="62" cy="56" r="4"></circle></g>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="selected" viewBox="0 0 120 80" aria-hidden="true">
        <g class="pm-context-cloud"><circle class="pm-dot" cx="30" cy="28" r="4"></circle><circle class="pm-dot" cx="44" cy="21" r="4"></circle><circle class="pm-dot" cx="82" cy="28" r="4"></circle><circle class="pm-dot" cx="94" cy="50" r="4"></circle><circle class="pm-dot" cx="38" cy="57" r="4"></circle></g><g class="pm-selected-cloud"><circle class="pm-dot" cx="60" cy="37" r="4"></circle><circle class="pm-dot" cx="70" cy="43" r="4"></circle><circle class="pm-dot" cx="58" cy="51" r="4"></circle></g>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="export" viewBox="0 0 120 80" aria-hidden="true">
        <path class="pm-stroke" d="M22 22 H98 M22 40 H98 M22 58 H98" opacity="0.14"></path><g class="pm-export-row"><rect class="pm-pill" x="22" y="18" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="50" y="18" width="24" height="8" rx="4"></rect></g><g class="pm-export-row" style="animation-delay:-0.42s;"><rect class="pm-pill" x="22" y="36" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="50" y="36" width="24" height="8" rx="4"></rect></g><g class="pm-export-row" style="animation-delay:-0.84s;"><rect class="pm-pill" x="22" y="54" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="50" y="54" width="24" height="8" rx="4"></rect></g>
      </svg>
      <svg class="processing-motion-graphic" data-processing-motion-graphic="package" viewBox="0 0 120 80" aria-hidden="true">
        <g class="pm-package-part"><rect class="pm-pill" x="30" y="22" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="66" y="22" width="24" height="8" rx="4"></rect></g><g class="pm-package-part" style="animation-delay:-0.46s;"><rect class="pm-pill" x="30" y="36" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="66" y="36" width="24" height="8" rx="4"></rect></g><g class="pm-package-part" style="animation-delay:-0.92s;"><rect class="pm-pill" x="30" y="50" width="24" height="8" rx="4"></rect><rect class="pm-pill" x="66" y="50" width="24" height="8" rx="4"></rect></g>
      </svg>
    ')
  )
}
