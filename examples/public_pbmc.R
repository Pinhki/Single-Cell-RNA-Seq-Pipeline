# Run from the repository root with the selected Seurat runtime.
library(Seurat)
cat("R", as.character(getRversion()), "Seurat", as.character(packageVersion("Seurat")), "SeuratObject", as.character(packageVersion("SeuratObject")), "\n")
data("pbmc_small", package = "SeuratObject")
# Agent note: Use the matching count accessor for SeuratObject 4 and 5.
get_counts <- function(x) {
  if (packageVersion("SeuratObject") >= "5.0.0") GetAssayData(x, assay = "RNA", layer = "counts")
  else GetAssayData(x, assay = "RNA", slot = "counts")
}
counts <- get_counts(pbmc_small)
object <- CreateSeuratObject(counts = counts, project = "public-example")
source("Content/core/seurat_v5/normalize_integrate_core.R")
# This calls the app's normalization backend; no cells are filtered or annotated.
set.seed(42)
result <- core_analysis_tab_a_run_normalization(object, method = "LogNormalize")
out <- result$object
stopifnot(ncol(out) == 80L, nrow(out) == 230L,
          identical(colnames(out), colnames(object)),
          identical(as.matrix(get_counts(out)), as.matrix(counts)),
          all(is.finite(Embeddings(out, "pca"))))
args <- commandArgs(trailingOnly = TRUE)
if (length(args)) {
  dir.create(args[1], recursive = TRUE, showWarnings = FALSE)
  saveRDS(out, file.path(args[1], "public-pbmc-example.rds"))
  png(file.path(args[1], "public-pbmc-pca.png"), width = 1000, height = 700)
  plot(Embeddings(out, "pca")[, 1:2], pch = 16, col = "#2463A5",
       main = "Public pbmc_small example: app normalization backend")
  dev.off()
}
cat(sprintf("PASS: %d genes, %d cells, %d finite principal components; counts and cells unchanged.\n",
            nrow(out), ncol(out), ncol(Embeddings(out, "pca"))))
cat("No cell filtering, integration, clustering or cell-type annotation was performed.\n")
