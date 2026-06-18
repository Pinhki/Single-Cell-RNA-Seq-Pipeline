qc_files <- c(
  "Content/interface/qc/page_hto.R",
  "Content/interface/qc/page_doublet.R",
  "Content/interface/qc/page_vdj.R",
  "Content/interface/qc/page_barcodes.R",
  "Content/interface/qc/page_atac_qc.R",
  "Content/interface/qc/page_flowgate.R"
)

helper_path <- "Content/interface/shared/qc_busy_spinner.R"

stopifnot(file.exists(helper_path))
helper_text <- paste(readLines(helper_path, warn = FALSE), collapse = "\n")
stopifnot(grepl("spin\\s*=\\s*\"self-building-square\"", helper_text, perl = TRUE))

for (path in qc_files) {
  stopifnot(file.exists(path))
  txt <- paste(readLines(path, warn = FALSE), collapse = "\n")
  stopifnot(grepl("qc_with_busy_spinner\\(", txt, perl = TRUE))
  stopifnot(!grepl("withSpinner\\(", txt, perl = TRUE))
}

cat("QC busy spinner usage tests passed\n")
