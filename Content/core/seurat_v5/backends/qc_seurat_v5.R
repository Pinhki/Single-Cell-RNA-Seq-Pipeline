## ---- core/seurat_v5/backends/qc_seurat_v5.R ---------------------------
# Reuse common QC implementation and stamp logs as v5 backend.
source(file.path("core", "seurat_v5", "backends", "qc_seurat_v4.R"), local = TRUE)
if (exists(".msg", mode = "function")) {
  .msg <- function(...) message("[qc_core:v5] ", paste0(..., collapse = ""))
}
