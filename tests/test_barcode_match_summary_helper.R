qc_with_busy_spinner <- function(output_ui, color = NULL) {
  output_ui
}

source("Content/interface/qc/page_barcodes.R")

# Regression test:
# aggregate(..., FUN = c(...)) creates a matrix column; downstream scalar [[2]]
# access can throw "subscript out of bounds". This helper must stay robust.
match_df <- data.frame(
  file = c("Graph-based.csv", "Graph-based.csv", "Graph-based.csv"),
  file_group = c("Cluster 15", "Cluster 15", "Cluster 15"),
  mapped_target = c("sample_a", "sample_a", ""),
  barcode = c("AAACGCACAGCGGGTA-1", "AAACGCTGTAAGCCAT-1", "AAACTAGAGGTATAGA-1"),
  sample_hint = c("", "", ""),
  matched_object = c("sample_a_obj", "", ""),
  matched_cell = c("AAACGCACAGCGGGTA-1", "", ""),
  matched_sample = c("sample_a", "", ""),
  matched = c(TRUE, FALSE, FALSE),
  stringsAsFactors = FALSE
)

out <- barcode_build_match_scope_summary(match_df)

stopifnot(is.data.frame(out))
stopifnot(all(c("scope", "queries", "matched", "unmatched", "match_rate") %in% colnames(out)))
stopifnot(nrow(out) == 2L)
stopifnot(is.numeric(out$queries))
stopifnot(is.numeric(out$matched))
stopifnot(is.numeric(out$unmatched))
stopifnot(is.numeric(out$match_rate))
stopifnot(all(out$queries >= out$matched))
stopifnot(all(out$unmatched == (out$queries - out$matched)))

cat("Barcode match summary helper regression test passed\n")
