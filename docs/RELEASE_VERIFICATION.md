# Release verification: 2026-10-23

This public preview was checked on macOS with R 4.4.3.

| Check | Observed result |
| --- | --- |
| Fresh GitHub checkout | App opened with no sample data using existing project-managed dependencies. |
| Seurat 4 example | Seurat 4.4.0 / SeuratObject 4.1.4: 230 genes and 80 cells preserved, raw counts unchanged, 50 finite principal components. |
| Seurat 5 example | Seurat 5.0.3 / SeuratObject 5.0.2: the same count, cell and finite-PCA checks passed. |
| Data Browser helpers | All 27 expectations in `tests/testthat/test-data-browser-helpers.R` passed. |

The [welcome-screen screenshot](images/scrna-welcome.png) was captured from the fresh checkout on 2026-10-23. No sample data were loaded. These observations supersede the earlier archived screenshot for this public copy.

The example's first attempt in the default R library failed because Harmony was unavailable there. Both intended managed runtimes passed with Harmony 1.2.4 supplied by their shared core library. The example documentation explicitly selects the managed library rather than relying on the default R installation.

This is a source preview, not an offline installer. Installation from an empty dependency library, Windows execution, Loupe export prerequisites, integration and the optional advanced analysis modules are not established by these checks. Bootstrap warned that LoupeR subprocess prerequisites were unavailable; core startup still completed.

## Maintenance evidence

The public copy retains filtered code history and the current source. Its implemented responsibilities include separate Seurat 4/5 backends, shared object-state handling, data import and workspace recovery. The public-data example checks both runtimes; the Data Browser tests exercise metadata type and grouping behavior. These are verifiable maintenance responsibilities, not evidence of external adoption. No external user count is claimed.
