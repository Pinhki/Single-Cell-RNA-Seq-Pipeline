# Package Bootstrap Policy

## Startup Readiness Requirement
- All startup-required packages must be installed and discoverable **before** `shiny::runApp()` starts.
- Launcher bootstrap fails fast if any package in the core bootstrap plan is still missing.

## Annotation Package Source Rule
- `SingleR` is installed from Bioconductor during bootstrap.
- `celldex` is installed from direct GitHub archive URL during bootstrap:
  - `https://codeload.github.com/SingleR-inc/celldex/tar.gz/ddf0173debf240f0861b32e3b96fa35bc67d8ecc`

## Seurat Environment Readiness
- Seurat environment bootstrap is eager by default (`seurat_v4` and `seurat_v5` prepared before app launch).
- To allow lazy Seurat bootstrap, set:
  - `WANLAB_EAGER_SEURAT_BOOTSTRAP=0`

## LoupeR Readiness
- `loupeR` auto-install/setup is scoped to isolated Seurat environments (not core).
- Controlled by:
  - `WANLAB_BOOTSTRAP_INSTALL_LOUPER` (default `TRUE`)

## Isolation Rule
- Never rely on outside installed package libraries for runtime dependencies.
- Runtime packages must be installed into project-managed libraries only.
- Default library mode is `project` (use project `package_libraries`).

## Troubleshooting Rule
- Always troubleshoot compilation problems first.
- Binary-only fallback is acceptable only after compile-path troubleshooting is complete.

## Troubleshooting Confidence Policy

When troubleshooting issues or increasing performance, evaluate confidence first by percentage.
If confidence is not above 95%, ask the user first before applying fixes.
If confidence is below 50%, ignore the current path and rethink before proceeding.
Check whether related functions are affected by the change (for example global behavior, reactive() flow, and cross-page side effects), and whether the fix is a strong guard rather than a temporary patch; if affecting others is inevitable, ask for permission first.

