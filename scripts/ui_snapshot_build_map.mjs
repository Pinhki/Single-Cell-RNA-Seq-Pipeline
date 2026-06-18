#!/usr/bin/env node
import fs from "fs";
import path from "path";
import { chromium } from "playwright";

const root = process.cwd();
const url = process.env.UI_SNAPSHOT_URL || process.argv[2];

if (!url) {
  console.error("Usage: node scripts/ui_snapshot_build_map.mjs <url>");
  process.exit(2);
}

const outDir = path.join(root, "ui_snapshots", "_map");
fs.mkdirSync(outDir, { recursive: true });

function writeJson(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2) + "\n");
}

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });

try {
  await page.goto(url, { waitUntil: "networkidle", timeout: 60000 });
  await page.waitForSelector("body", { timeout: 30000 });

  const uiMap = await page.evaluate(() => {
    function esc(s) {
      try { return CSS.escape(s); } catch { return String(s).replace(/[^a-zA-Z0-9_-]/g, "\\$&"); }
    }

    function cssPath(el) {
      if (!el || !el.tagName) return "";
      if (el.id) return "#" + esc(el.id);

      const parts = [];
      let cur = el;
      while (cur && cur.nodeType === 1 && cur !== document.body && parts.length < 6) {
        let part = cur.tagName.toLowerCase();
        const cls = Array.from(cur.classList || [])
          .filter(Boolean)
          .filter(c => !/^active$|^show$|^open$|^focus$|^selected$/.test(c))
          .slice(0, 3)
          .map(c => "." + esc(c))
          .join("");
        if (cls) part += cls;

        const parent = cur.parentElement;
        if (parent) {
          const sameTag = Array.from(parent.children).filter(x => x.tagName === cur.tagName);
          if (sameTag.length > 1 && !cur.id) {
            part += `:nth-of-type(${sameTag.indexOf(cur) + 1})`;
          }
        }

        parts.unshift(part);
        cur = cur.parentElement;
      }
      return parts.join(" > ");
    }

    function box(el) {
      const r = el.getBoundingClientRect();
      return {
        x: Math.round(r.x),
        y: Math.round(r.y),
        width: Math.round(r.width),
        height: Math.round(r.height)
      };
    }

    function text(el, n = 160) {
      return (el.innerText || el.textContent || "").replace(/\s+/g, " ").trim().slice(0, n);
    }

    function item(el, extra = {}) {
      return {
        selector: cssPath(el),
        tag: el.tagName.toLowerCase(),
        id: el.id || "",
        class: String(el.className || "").slice(0, 180),
        text: text(el),
        box: box(el),
        ...extra
      };
    }

    const map = {
      generated_at: new Date().toISOString(),
      url: location.href,
      navigation: [],
      buttons: [],
      cards: [],
      panels: [],
      inputs: [],
      outputs: [],
      tables: [],
      modals: [],
      dropdowns: []
    };

    document.querySelectorAll("nav a, nav li, #main_navbar a, #main_navbar li").forEach(el => {
      const b = box(el);
      if (b.width > 0 && b.height > 0) map.navigation.push(item(el));
    });

    document.querySelectorAll("button, a.btn, .action-button, [role='button']").forEach(el => {
      const b = box(el);
      if (b.width > 0 && b.height > 0) map.buttons.push(item(el, {
        shiny_id: el.id || el.getAttribute("data-input-id") || ""
      }));
    });

    document.querySelectorAll(".card, .well, .panel, .bslib-card").forEach(el => {
      const b = box(el);
      if (b.width > 0 && b.height > 0) map.cards.push(item(el));
    });

    document.querySelectorAll("main, section, aside, .tab-pane, .app-page, .container-fluid").forEach(el => {
      const b = box(el);
      if (b.width > 0 && b.height > 0 && b.width * b.height > 10000) map.panels.push(item(el));
    });

    document.querySelectorAll("input, select, textarea, .selectize-input").forEach(el => {
      const b = box(el);
      if (b.width > 0 && b.height > 0) map.inputs.push(item(el, {
        name: el.getAttribute("name") || "",
        type: el.getAttribute("type") || ""
      }));
    });

    document.querySelectorAll(".shiny-bound-output, [id$='_ui'], [id*='plot'], [id*='table'], [id*='output']").forEach(el => {
      const b = box(el);
      if (b.width > 0 && b.height > 0) map.outputs.push(item(el));
    });

    document.querySelectorAll("table, .dataTables_wrapper, .DTFC_ScrollWrapper").forEach(el => {
      const b = box(el);
      if (b.width > 0 && b.height > 0) map.tables.push(item(el));
    });

    document.querySelectorAll(".modal, [role='dialog']").forEach(el => {
      const b = box(el);
      if (b.width > 0 && b.height > 0) map.modals.push(item(el));
    });

    document.querySelectorAll(".dropdown, .dropdown-menu, .selectize-dropdown").forEach(el => {
      const b = box(el);
      if (b.width > 0 && b.height > 0) map.dropdowns.push(item(el));
    });

    for (const k of Object.keys(map)) {
      if (Array.isArray(map[k])) map[k] = map[k].slice(0, 120);
    }

    return map;
  });

  writeJson(path.join(outDir, "ui_map.json"), uiMap);

  const summary = {};
  for (const [k, v] of Object.entries(uiMap)) {
    if (Array.isArray(v)) summary[k] = v.length;
  }
  writeJson(path.join(outDir, "ui_map_summary.json"), {
    url,
    generated_at: new Date().toISOString(),
    counts: summary
  });

  console.log("status: ok");
  console.log("output:", path.join(outDir, "ui_map.json"));
  console.log("summary:", path.join(outDir, "ui_map_summary.json"));
  console.log(JSON.stringify(summary, null, 2));
} catch (err) {
  console.error("status: error");
  console.error("error:", err?.message || String(err));
  process.exit(1);
} finally {
  await browser.close();
}
