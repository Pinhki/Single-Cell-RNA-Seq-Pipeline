#!/usr/bin/env node
import fs from "fs";
import path from "path";
import { chromium } from "playwright";

const targetName = process.argv[2];
if (!targetName) {
  console.error("Usage: ./ui-snapshot <target>");
  process.exit(2);
}

const root = process.cwd();
const configPath = path.join(root, "scripts", "ui_snapshot_targets.json");
if (!fs.existsSync(configPath)) {
  console.error("Missing config:", configPath);
  process.exit(2);
}

const config = JSON.parse(fs.readFileSync(configPath, "utf8"));
const target = config.targets?.[targetName];
if (!target) {
  console.error("Unknown target:", targetName);
  console.error("Available targets:", Object.keys(config.targets || {}).join(", "));
  process.exit(2);
}

const now = new Date();
const stamp = now.toISOString().replace(/[:.]/g, "-");
const outDir = path.join(root, "ui_snapshots", targetName, stamp);
fs.mkdirSync(outDir, { recursive: true });

const cssProps = [
  "display", "visibility", "position",
  "width", "height", "minWidth", "minHeight", "maxWidth", "maxHeight",
  "marginTop", "marginRight", "marginBottom", "marginLeft",
  "paddingTop", "paddingRight", "paddingBottom", "paddingLeft",
  "borderTopWidth", "borderRightWidth", "borderBottomWidth", "borderLeftWidth",
  "borderRadius", "fontSize", "fontWeight", "lineHeight",
  "overflow", "overflowX", "overflowY", "zIndex",
  "flex", "flexDirection", "alignItems", "justifyContent", "gap",
  "transform", "top", "left", "right", "bottom",
  "backgroundColor", "color"
];

function writeJson(file, data) {
  fs.writeFileSync(file, JSON.stringify(data, null, 2) + "\n");
}

function compactText(s) {
  return String(s || "").replace(/\s+/g, " ").trim();
}

function diffObjects(oldObj, newObj) {
  if (!oldObj || !newObj) return {};
  const out = {};
  const keys = new Set([...Object.keys(oldObj), ...Object.keys(newObj)]);
  for (const k of keys) {
    const a = oldObj[k];
    const b = newObj[k];
    if (JSON.stringify(a) !== JSON.stringify(b)) {
      out[k] = { old: a ?? null, new: b ?? null };
    }
  }
  return out;
}

function findPreviousSnapshot() {
  const base = path.join(root, "ui_snapshots", targetName);
  if (!fs.existsSync(base)) return null;
  const dirs = fs.readdirSync(base)
    .filter(x => x !== stamp && fs.existsSync(path.join(base, x, "metadata.json")))
    .sort();
  if (!dirs.length) return null;
  return path.join(base, dirs[dirs.length - 1]);
}

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({
  viewport: target.viewport || { width: 1440, height: 1000 }
});

let status = "ok";
let errorMessage = null;
const runtimeUrl = process.env.UI_SNAPSHOT_URL || target.url || config.default_url;

try {
  await page.goto(runtimeUrl, {
    waitUntil: "networkidle",
    timeout: target.timeout_ms || 60000
  });

  await page.waitForSelector(target.wait_for_selector || target.selector, {
    timeout: target.wait_timeout_ms || 30000
  });

  if (target.click_selector) {
    await page.click(target.click_selector, { timeout: 10000 });
    await page.waitForTimeout(target.after_click_wait_ms || 500);
  }

  let baseLocator = target.within
    ? page.locator(target.within).locator(target.selector)
    : page.locator(target.selector);

  if (target.text) {
    baseLocator = baseLocator.filter({ hasText: target.text });
  }
  const count = await baseLocator.count();
  const index = Number.isInteger(target.nth) ? target.nth : 0;
  const locator = baseLocator.nth(index);

  await locator.waitFor({ state: "visible", timeout: target.wait_timeout_ms || 30000 });

  const box = await locator.boundingBox();

  if (!box) throw new Error("Target has no bounding box: " + target.selector);

  await locator.screenshot({
    path: path.join(outDir, "screenshot.png"),
    timeout: 30000
  });

  const dom = await locator.evaluate(el => el.outerHTML);
  fs.writeFileSync(path.join(outDir, "dom.html"), dom + "\n");

  const domText = await locator.evaluate(el => el.innerText || el.textContent || "");
  fs.writeFileSync(path.join(outDir, "dom_text.txt"), compactText(domText) + "\n");

  const computed = await locator.evaluate((el, props) => {
    const s = window.getComputedStyle(el);
    const out = {};
    for (const p of props) out[p] = s[p] || s.getPropertyValue(p) || "";
    return out;
  }, cssProps);

  const childSummary = await locator.evaluate((el) => {
    return Array.from(el.querySelectorAll("*")).slice(0, 80).map((x, i) => ({
      i,
      tag: x.tagName.toLowerCase(),
      id: x.id || "",
      class: x.className ? String(x.className).slice(0, 160) : "",
      text: (x.innerText || x.textContent || "").replace(/\s+/g, " ").trim().slice(0, 120)
    }));
  });

  writeJson(path.join(outDir, "computed_style.json"), computed);
  writeJson(path.join(outDir, "bounding_box.json"), box);
  writeJson(path.join(outDir, "children_summary.json"), childSummary);

  const prev = findPreviousSnapshot();
  if (prev) {
    const prevStylePath = path.join(prev, "computed_style.json");
    const prevBoxPath = path.join(prev, "bounding_box.json");
    const prevTextPath = path.join(prev, "dom_text.txt");

    if (fs.existsSync(prevStylePath)) {
      const oldStyle = JSON.parse(fs.readFileSync(prevStylePath, "utf8"));
      writeJson(path.join(outDir, "computed_style_diff.json"), diffObjects(oldStyle, computed));
    }

    if (fs.existsSync(prevBoxPath)) {
      const oldBox = JSON.parse(fs.readFileSync(prevBoxPath, "utf8"));
      writeJson(path.join(outDir, "bounding_box_diff.json"), diffObjects(oldBox, box));
    }

    if (fs.existsSync(prevTextPath)) {
      const oldText = fs.readFileSync(prevTextPath, "utf8").trim();
      const newText = compactText(domText);
      fs.writeFileSync(
        path.join(outDir, "dom_text_diff.txt"),
        oldText === newText ? "NO_TEXT_CHANGE\n" : `OLD:\n${oldText}\n\nNEW:\n${newText}\n`
      );
    }
  } else {
    writeJson(path.join(outDir, "computed_style_diff.json"), {});
    writeJson(path.join(outDir, "bounding_box_diff.json"), {});
    fs.writeFileSync(path.join(outDir, "dom_text_diff.txt"), "NO_PREVIOUS_SNAPSHOT\n");
  }

  writeJson(path.join(outDir, "metadata.json"), {
    target: targetName,
    url: runtimeUrl,
    selector: target.selector,
    within: target.within || null,
    text: target.text || null,
    nth: Number.isInteger(target.nth) ? target.nth : 0,
    matched_count: count,
    timestamp: now.toISOString(),
    output_dir: outDir,
    screenshot: path.join(outDir, "screenshot.png")
  });

} catch (err) {
  status = "error";
  errorMessage = err?.message || String(err);
  writeJson(path.join(outDir, "error.json"), {
    target: targetName,
    status,
    error: errorMessage,
    url: runtimeUrl,
    selector: target.selector,
    timestamp: now.toISOString()
  });
} finally {
  await browser.close();
}

const latestFile = path.join(root, "ui_snapshots", targetName, "latest.txt");
fs.mkdirSync(path.dirname(latestFile), { recursive: true });
fs.writeFileSync(latestFile, outDir + "\n");

console.log("status:", status);
console.log("target:", targetName);
console.log("output:", outDir);
if (errorMessage) {
  console.error("error:", errorMessage);
  process.exit(1);
}
