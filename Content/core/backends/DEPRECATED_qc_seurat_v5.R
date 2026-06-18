# DEPRECATED FILE
# This file is no longer used by app routing.
# Use versioned core modules instead:
# - core/seurat_v4/*
# - core/seurat_v5/*
# Kept only for historical reference.

## ---- core/backends/qc_seurat_v5.R -------------------------------------
# Current QC backend is shared with v4 logic and routed by core detection.
source(file.path("core", "backends", "qc_seurat_v4.R"), local = TRUE)
