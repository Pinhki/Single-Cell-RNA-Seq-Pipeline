qc_with_busy_spinner <- function(output_ui, color = NULL) {
  output_ui
}

src <- paste(readLines("Content/interface/qc/page_barcodes.R", warn = FALSE), collapse = "\n")

idx_parse <- regexpr("barcode_parse_btn", src, fixed = TRUE)[1]
idx_run <- regexpr("barcode_run_btn", src, fixed = TRUE)[1]
idx_selector <- regexpr("barcode_object_selector_ui", src, fixed = TRUE)[1]
idx_create <- regexpr("barcode_create_obj_btn", src, fixed = TRUE)[1]

stopifnot(idx_parse > 0L, idx_run > 0L, idx_selector > 0L, idx_create > 0L)

# Requested control order:
# parse -> object selector -> run -> create
stopifnot(idx_parse < idx_run)
stopifnot(idx_parse < idx_selector)
stopifnot(idx_selector < idx_run)
stopifnot(idx_run < idx_create)

# Auto-parse observer should exist.
stopifnot(grepl("observeEvent\\(input\\$barcode_files", src, perl = TRUE))

# Richer plotting area hooks should exist.
stopifnot(grepl("DTOutput\\(\"barcode_object_match_table\"\\)", src, perl = TRUE))
stopifnot(grepl("uiOutput\\(\"barcode_umap_card_ui\"\\)", src, perl = TRUE))
stopifnot(grepl("plotlyOutput\\(\"barcode_umap_plot\"", src, perl = TRUE))
stopifnot(grepl("\"barcode_umap_split_by\"", src, perl = TRUE))

cat("Barcode page requested UI hooks test passed\n")
