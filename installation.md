# Installation and Packaging Guide

This document describes what to include when creating a distributable package of this project, what to exclude, and how to support incremental updates.

## 1) Required Contents (Must Be Packed)

Pack these items at the top level:

- `Content/`
- `Launch_Windows.bat`
- `launch_mac.app/`
- `package.md`
- `AGENTS.md` (optional for developers, recommended for maintainers)

For runtime dependency reuse (strongly recommended), also include:

- `package_libraries/`
- `package_libraries_location.txt`

If Python-backed features are expected to work immediately without redownload/rebuild, include:

- `python_envs/`

## 2) Recommended Optional Contents

Include only if you want end-users to have these extras:

- `Content/demo/` (example datasets)
- `READ ME FIRST if you are a new user.pdf` / `.docx` (user documentation)
- `docs/` (internal engineering docs)

## 3) Do Not Pack (Exclude)

Do not include these in release archives unless there is a specific reason:

- `further analysis/` (large analysis outputs, not runtime core)
- `results/` (generated output)
- `emergency_recovery/` (recovery artifacts, not standard runtime)
- `.DS_Store`
- `Source/` (authoring/reference material, not runtime)
- `Start by Learning - Run R by Your Self/` (training material; optional at most)
- `analysis.md`, `shared_data_contract.md`, `Update Log.txt` (maintainer notes, optional)

## 4) Quick Packaging Checklist

1. Confirm app runs from `Content/run.R` locally.
2. Clean generated outputs (`results/`, temporary analysis outputs).
3. Keep `package_libraries/` if you want offline/fast installation.
4. Keep `python_envs/` only if you want prebuilt Python environments shipped.
5. Create archive from project root.

## 5) Incremental Update Strategy (No Full Reinstall)

Goal: update app code without forcing users to reinstall all R packages or redownload databases.

### A. Preserve Runtime Caches Between Versions

When installing a new version, preserve these folders from the old installation and copy them into the new installation:

- `package_libraries/`
- `python_envs/` (if used)

Also keep:

- `package_libraries_location.txt` (if present and valid for the machine)

### B. Update Workflow for Maintainer

1. Build update package containing changed app code (usually `Content/`, launcher files, docs).
2. Do **not** overwrite user-preserved `package_libraries/` and `python_envs/` unless intentionally refreshing environments.
3. Start app with `Content/run.R`; bootstrap should install only missing dependencies.
4. Verify startup and one workflow from each major area (Setup, QC, Analysis, Export).

### C. Database/Resource Reuse

For resources downloaded at runtime (for example pySCENIC databases), keep existing downloaded resource folders in place during upgrade. The app should reuse them when paths are unchanged.

### D. Recommended Release Layout

- Full install package: includes everything needed for first-time install.
- Incremental update package: includes changed code/launchers only, plus instructions to keep existing `package_libraries/` and `python_envs/`.

## 6) Owner Confirmation Needed (Please Confirm)

I am not fully certain whether you want these bundled in your **ship version** by default:

- `Content/demo/`
- `Start by Learning - Run R by Your Self/`
- `READ ME FIRST ...` documents (PDF/DOCX)

If you confirm your preferred policy (include vs exclude), this file can be finalized to your exact release standard.

## Troubleshooting Confidence Policy

When troubleshooting issues or increasing performance, evaluate confidence first by percentage.
If confidence is not above 95%, ask the user first before applying fixes.
If confidence is below 50%, ignore the current path and rethink before proceeding.
Check whether related functions are affected by the change (for example global behavior, reactive() flow, and cross-page side effects), and whether the fix is a strong guard rather than a temporary patch; if affecting others is inevitable, ask for permission first.

