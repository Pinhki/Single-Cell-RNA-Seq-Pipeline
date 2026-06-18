qc_with_busy_spinner <- function(output_ui, color = NULL) {
  output_ui
}

source("Content/interface/qc/page_barcodes.R")

if (!methods::isClass("Seurat")) {
  methods::setClass("Seurat", slots = c(meta.data = "data.frame"))
}

fake_obj <- methods::new(
  "Seurat",
  meta.data = data.frame(
    orig.ident = c("sample_a", "sample_a"),
    row.names = c("cell_a-1", "cell_b-1"),
    stringsAsFactors = FALSE
  )
)

shared_data <- shiny::reactiveValues(
  all_seurat_objects = list(orphan_object = list(obj = fake_obj)),
  full_sample_sheet = data.frame(
    name = "different_object",
    condition = "Condition X",
    stringsAsFactors = FALSE
  )
)

test_app <- function(input, output, session) {
  barcode_server(input, output, session, shared_data = shared_data)
}

shiny::testServer(
  test_app,
  expr = {
    session$flushReact()
    ui_txt <- paste(as.character(output$barcode_mapping_targets_ui), collapse = "\n")
    stopifnot(grepl("Valid targets:", ui_txt, fixed = TRUE))
    stopifnot(grepl("orphan_object", ui_txt, fixed = TRUE))
  }
)

cat("Barcode page init missing-sheet-entry test passed\n")
