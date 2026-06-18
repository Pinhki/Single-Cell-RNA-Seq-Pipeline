# Shared code-block helpers (global across pages)

wl_code_block_assets <- local({
  cache <- NULL
  function() {
    if (!is.null(cache)) return(cache)
    cache <<- htmltools::singleton(
      shiny::tagList(
        shiny::tags$style(shiny::HTML("
          .rds-code-block-wrap {
            margin-top: 8px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            background: #272822;
            overflow: hidden;
          }
          .rds-code-block {
            margin: 0;
            padding: 12px 14px;
            color: #f8f8f2;
            font-size: 12.5px;
            line-height: 1.45;
            overflow-x: auto;
            background: #272822;
          }
          .rds-code-block code {
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace;
            white-space: pre;
            display: block;
            margin: 0;
            padding: 0;
            text-indent: 0;
          }
          .rds-code-block ::selection {
            background: rgba(125, 211, 252, 0.22);
            color: #f8f8f2;
          }
          .rds-code-copy-btn {
            display: inline-block !important;
            margin-bottom: 6px;
          }
          .rds-code-block .tok-cmt { color: #75715e; font-style: italic; }
          .rds-code-block .tok-str { color: #e6db74; }
          .rds-code-block .tok-kw  { color: #f92672; font-weight: 700; }
          .rds-code-block .tok-fn  { color: #a6e22e; }
          .rds-code-block .tok-op  { color: #f8f8f2; }
          .rds-code-block .tok-s4  { color: #66d9ef; }
        ")),
        shiny::tags$script(shiny::HTML("
          (function() {
            if (window.__wlCodeBlockHighlightInstalled) return;
            window.__wlCodeBlockHighlightInstalled = true;
            function escapeHtml(str) {
              return str
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;');
            }
            function highlightPlain(text) {
              var s = escapeHtml(text);
              s = s.replace(/\\b(function|if|else|for|in|TRUE|FALSE|NULL)\\b/g, '<span class=\"tok-kw\">$1</span>');
              s = s.replace(/\\b(readRDS|names|dim|head|class|length|stopifnot|library)\\b/g, '<span class=\"tok-fn\">$1</span>');
              s = s.replace(/(@)/g, '<span class=\"tok-s4\">$1</span>');
              s = s.replace(/(<-|\\$|::|\\[\\[|\\]\\])/g, '<span class=\"tok-op\">$1</span>');
              return s;
            }
            function highlightRLine(line) {
              var out = [];
              var plain = [];
              var i = 0;
              var n = line.length;
              function flushPlain() {
                if (!plain.length) return;
                out.push(highlightPlain(plain.join('')));
                plain = [];
              }
              while (i < n) {
                var ch = line[i];
                if (ch === '#') {
                  flushPlain();
                  out.push('<span class=\"tok-cmt\">' + escapeHtml(line.slice(i)) + '</span>');
                  return out.join('');
                }
                if (ch === '\"' || ch === \"'\") {
                  flushPlain();
                  var q = ch;
                  var j = i + 1;
                  var esc = false;
                  while (j < n) {
                    var cj = line[j];
                    if (esc) {
                      esc = false;
                    } else if (cj === '\\\\') {
                      esc = true;
                    } else if (cj === q) {
                      j += 1;
                      break;
                    }
                    j += 1;
                  }
                  out.push('<span class=\"tok-str\">' + escapeHtml(line.slice(i, j)) + '</span>');
                  i = j;
                  continue;
                }
                plain.push(ch);
                i += 1;
              }
              flushPlain();
              return out.join('');
            }
            function highlightR(codeEl, force) {
              if (!codeEl) return;
              if (force) codeEl.removeAttribute('data-rds-hl');
              if (codeEl.getAttribute('data-rds-hl') === '1') return;
              var txt = (codeEl.textContent || '').replace(/\\r\\n/g, '\\n');
              var lines = txt.split('\\n');
              while (lines.length && !lines[0].trim()) lines.shift();
              while (lines.length && !lines[lines.length - 1].trim()) lines.pop();
              var minIndent = null;
              for (var i = 0; i < lines.length; i++) {
                var ln = lines[i];
                if (!ln.trim()) continue;
                var m = ln.match(/^\\s*/);
                var indent = m ? m[0].length : 0;
                if (minIndent === null || indent < minIndent) minIndent = indent;
              }
              if (minIndent && minIndent > 0) {
                lines = lines.map(function(line) {
                  return line.slice(Math.min(minIndent, line.length));
                });
              }
              var html = lines.map(highlightRLine).join('\\n');
              codeEl.innerHTML = html;
              codeEl.setAttribute('data-rds-hl', '1');
            }
            function runHighlight(force) {
              var nodes = document.querySelectorAll('code.rds-r-code');
              Array.prototype.forEach.call(nodes, function(node) { highlightR(node, !!force); });
            }
            window.wlRunCodeBlockHighlight = runHighlight;
            if (window.Shiny && typeof window.Shiny.addCustomMessageHandler === 'function') {
              window.Shiny.addCustomMessageHandler('wl_code_block_rehighlight', function(msg) {
                runHighlight(true);
              });
            }
            document.addEventListener('DOMContentLoaded', runHighlight);
            document.addEventListener('shiny:connected', function() { runHighlight(true); });
            document.addEventListener('shiny:value', function() { runHighlight(true); });
          })();
        "))
      )
    )
    cache
  }
})

wl_code_block_ui <- function(code_text) {
  txt <- if (!is.null(code_text)) code_text else ""
  shiny::div(
    class = "rds-code-block-wrap",
    shiny::tags$pre(class = "rds-code-block", shiny::tags$code(class = "rds-r-code", txt))
  )
}
