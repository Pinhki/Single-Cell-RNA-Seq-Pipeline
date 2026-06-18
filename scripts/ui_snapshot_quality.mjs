#!/usr/bin/env node
import fs from "fs";
import path from "path";

const dir = process.argv[2];
if (!dir) {
  console.error("Usage: node scripts/ui_snapshot_quality.mjs <snapshot_dir>");
  process.exit(2);
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, "utf8"));
}

function size(file) {
  try { return fs.statSync(file).size; } catch { return 0; }
}

const box = readJson(path.join(dir, "bounding_box.json"));
const metadata = readJson(path.join(dir, "metadata.json"));
const viewport = { width: 1440, height: 1000 };
const domBytes = size(path.join(dir, "dom.html"));
const screenshotBytes = size(path.join(dir, "screenshot.png"));
const matchedCount = metadata.matched_count || 0;

const warnings = [];
const coverage = ((box.width || 0) * (box.height || 0)) / (viewport.width * viewport.height);

if (matchedCount < 1) warnings.push("selector matched no elements");
if (matchedCount > 20) warnings.push("selector matched many elements; first match may be unstable");
if ((box.width || 0) < 5 || (box.height || 0) < 5) warnings.push("bounding box is very small");
if (coverage > 0.9) warnings.push("element covers almost all viewport; selector may be broad");
if (domBytes > 750000) warnings.push("DOM dump is large; selector may include too much subtree");
if (screenshotBytes > 750000) warnings.push("screenshot is large; selector may be broad");

let quality = "good";
if (matchedCount < 1 || (box.width || 0) < 5 || (box.height || 0) < 5) quality = "bad";
else if (warnings.length) quality = "review";

const report = {
  quality,
  warnings,
  matched_count: matchedCount,
  box,
  viewport_coverage: Number(coverage.toFixed(4)),
  dom_bytes: domBytes,
  screenshot_bytes: screenshotBytes,
  token_safety_note: "Advisory only. Do not block UI work because of warnings. Read this small JSON before opening screenshots."
};

fs.writeFileSync(path.join(dir, "snapshot_quality.json"), JSON.stringify(report, null, 2) + "\n");
console.log(JSON.stringify(report, null, 2));
