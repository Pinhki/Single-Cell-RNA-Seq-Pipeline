#!/usr/bin/env node
import fs from "fs";
import path from "path";
import { chromium } from "playwright";

const root = process.cwd();
const url = process.env.UI_SNAPSHOT_URL;
const query = process.env.UI_SNAPSHOT_QUERY || "";

if (!url || !query) {
  console.error("Usage: UI_SNAPSHOT_URL=<url> UI_SNAPSHOT_QUERY=<text> node scripts/ui_snapshot_find.mjs");
  process.exit(2);
}

const now = new Date();
const stamp = now.toISOString().replace(/[:.]/g, "-");
const outDir = path.join(root, "ui_snapshots", "_find", stamp);
fs.mkdirSync(outDir, { recursive: true });

function writeJson(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2) + "\n");
}

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });

try {
  await page.goto(url, { waitUntil: "networkidle", timeout: 60000 });
  await page.waitForSelector("body", { timeout: 30000 });

  const candidates = await page.evaluate((q) => {
    const query = String(q || "").toLowerCase().trim();

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

    function textOf(el) {
      return (el.innerText || el.textContent || "").replace(/\s+/g, " ").trim();
    }

    function scoreEl(el) {
      const r = el.getBoundingClientRect();
      const text = textOf(el);
      const low = text.toLowerCase();
      const id = (el.id || "").toLowerCase();
      const cls = String(el.className || "").toLowerCase();
      const role = (el.getAttribute("role") || "").toLowerCase();
      const aria = (el.getAttribute("aria-label") || "").toLowerCase();
      const title = (el.getAttribute("title") || "").toLowerCase();

      if (r.width <= 0 || r.height <= 0) return null;
      if (text.length > 5000) return null;

      let score = 0;
      if (low === query) score += 100;
      else if (low.split(/\s+/).includes(query)) score += 70;
      else if (low.includes(query)) score += 55;

      if (id.includes(query)) score += 40;
      if (cls.includes(query)) score += 20;
      if (role.includes(query)) score += 10;
      if (aria.includes(query)) score += 35;
      if (title.includes(query)) score += 30;

      const tag = el.tagName.toLowerCase();
      if (["button", "a", "input", "select", "textarea"].includes(tag)) score += 20;
      if (el.closest("button,a,.btn,[role='button']")) score += 15;
      if (el.id) score += 10;

      const area = r.width * r.height;
      if (area < 200) score -= 20;
      if (area > 400000) score -= 20;

      if (score <= 0) return null;

      const preferred = el.closest("button,a,.btn,[role='button'],input,select,textarea,.card,.panel,.modal,.dropdown-menu,.dataTables_wrapper") || el;

      return {
        score,
        tag,
        id: el.id || "",
        class: String(el.className || "").slice(0, 220),
        role,
        selector: cssPath(preferred),
        matched_selector: cssPath(el),
        preferred_tag: preferred.tagName.toLowerCase(),
        x: Math.round(r.x),
        y: Math.round(r.y),
        width: Math.round(r.width),
        height: Math.round(r.height),
        text: text.slice(0, 240)
      };
    }

    const all = Array.from(document.querySelectorAll("body *"));
    const scored = [];
    for (const el of all) {
      const s = scoreEl(el);
      if (s) scored.push(s);
    }

    const seen = new Set();
    return scored
      .sort((a, b) => b.score - a.score)
      .filter(x => {
        const key = x.selector + "|" + x.text;
        if (seen.has(key)) return false;
        seen.add(key);
        return true;
      })
      .slice(0, 30);
  }, query);

  writeJson(path.join(outDir, "find_results.json"), {
    query,
    url,
    timestamp: now.toISOString(),
    candidates
  });

  fs.writeFileSync(path.join(root, "ui_snapshots", "_find", "latest.txt"), outDir + "\n");

  console.log("status: ok");
  console.log("query:", query);
  console.log("url:", url);
  console.log("output:", outDir);
  console.log("");
  console.log("Top candidates:");
  for (const [i, c] of candidates.slice(0, 12).entries()) {
    console.log(`[${i}] score=${c.score} ${c.width}x${c.height} x=${c.x} y=${c.y}`);
    console.log(`    selector: ${c.selector}`);
    console.log(`    tag=${c.tag} id=${c.id || "-"} class=${c.class || "-"}`);
    if (c.text) console.log(`    text: ${c.text.slice(0, 180)}`);
  }

  if (!candidates.length) {
    console.log("No candidates found. Try ./ui-snapshot inspect <url>");
  }
} catch (err) {
  writeJson(path.join(outDir, "error.json"), {
    status: "error",
    error: err?.message || String(err),
    query,
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
