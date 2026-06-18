#!/usr/bin/env node
import fs from "fs";
import path from "path";
import { chromium } from "playwright";

const root = process.cwd();
const url = process.env.UI_SNAPSHOT_URL;
if (!url) {
  console.error("Missing UI_SNAPSHOT_URL");
  process.exit(2);
}

const now = new Date();
const stamp = now.toISOString().replace(/[:.]/g, "-");
const outDir = path.join(root, "ui_snapshots", "_inspect", stamp);
fs.mkdirSync(outDir, { recursive: true });

function writeJson(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2) + "\n");
}

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });

try {
  await page.goto(url, { waitUntil: "networkidle", timeout: 60000 });
  await page.waitForSelector("body", { timeout: 30000 });

  const candidates = await page.evaluate(() => {
    function cssPath(el) {
      if (!el || !el.tagName) return "";
      if (el.id) return "#" + CSS.escape(el.id);

      const parts = [];
      let cur = el;
      while (cur && cur.nodeType === 1 && cur !== document.body && parts.length < 5) {
        let part = cur.tagName.toLowerCase();
        const cls = Array.from(cur.classList || [])
          .filter(Boolean)
          .slice(0, 3)
          .map(c => "." + CSS.escape(c))
          .join("");
        if (cls) part += cls;

        const parent = cur.parentElement;
        if (parent) {
          const same = Array.from(parent.children).filter(x => x.tagName === cur.tagName);
          if (same.length > 1) {
            part += `:nth-of-type(${same.indexOf(cur) + 1})`;
          }
        }
        parts.unshift(part);
        cur = cur.parentElement;
      }
      return parts.join(" > ");
    }

    const interesting = [
      "nav", "header", "main", "aside", "section",
      ".navbar", ".bslib-page-navbar", ".navbar-nav", ".nav-item",
      ".dropdown", ".dropdown-menu", ".selectize-input", ".selectize-dropdown",
      ".sidebar", ".right-sidebar", "#right_sidebar",
      ".card", ".panel", ".tab-pane", ".dataTables_wrapper",
      "[id]", "[role]", "button", "input", "select"
    ].join(",");

    const els = Array.from(document.querySelectorAll(interesting));
    return els.map((el, i) => {
      const r = el.getBoundingClientRect();
      const text = (el.innerText || el.textContent || "").replace(/\s+/g, " ").trim();
      const area = Math.round(r.width * r.height);
      return {
        i,
        tag: el.tagName.toLowerCase(),
        id: el.id || "",
        class: String(el.className || "").slice(0, 220),
        role: el.getAttribute("role") || "",
        selector: cssPath(el),
        x: Math.round(r.x),
        y: Math.round(r.y),
        width: Math.round(r.width),
        height: Math.round(r.height),
        area,
        visible: r.width > 0 && r.height > 0,
        text: text.slice(0, 180)
      };
    })
    .filter(x => x.visible && x.area > 100)
    .sort((a, b) => {
      const ay = Math.abs(a.y - 0);
      const by = Math.abs(b.y - 0);
      if (ay !== by) return ay - by;
      return b.area - a.area;
    })
    .slice(0, 120);
  });

  writeJson(path.join(outDir, "candidates.json"), candidates);
  fs.writeFileSync(path.join(root, "ui_snapshots", "_inspect", "latest.txt"), outDir + "\n");

  console.log("status: ok");
  console.log("url:", url);
  console.log("output:", outDir);
  console.log("");
  console.log("Top candidates:");
  for (const c of candidates.slice(0, 40)) {
    console.log(`[${c.i}] ${c.width}x${c.height} x=${c.x} y=${c.y} tag=${c.tag} id=${c.id || "-"} class=${c.class || "-"} selector=${c.selector}`);
    if (c.text) console.log("  text:", c.text.slice(0, 140));
  }
} catch (err) {
  writeJson(path.join(outDir, "error.json"), {
    status: "error",
    error: err?.message || String(err),
    url,
    timestamp: now.toISOString()
  });
  console.error("status: error");
  console.error("output:", outDir);
  console.error("error:", err?.message || String(err));
  process.exit(1);
} finally {
  await browser.close();
}
