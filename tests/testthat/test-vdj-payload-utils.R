.vdj_payload_utils_source_path <- if (file.exists("Content/interface/shared/vdj_payload_utils.R")) {
  "Content/interface/shared/vdj_payload_utils.R"
} else {
  "../../Content/interface/shared/vdj_payload_utils.R"
}

source(.vdj_payload_utils_source_path)

testthat::test_that("VDJ record normalization keeps current mapped-record behavior", {
  raw <- data.frame(
    barcode = c("bc1", "bc1", "bc2", "bc3", ""),
    clone = c("cl1", "cl1", "cl2", "cl3", "cl4"),
    chain = c("tcr", "TCR", "BCR", "UNKNOWN", "TCR"),
    sample = c("s1", "s1", "s1", "s1", "s1"),
    cell = c("cell1", "cell1", "cell2", "cell3", "cell4"),
    extra = 1:5,
    stringsAsFactors = FALSE
  )

  out <- .vdj_payload_normalize_records(raw)

  testthat::expect_identical(colnames(out), c("barcode", "clone", "chain", "sample", "cell"))
  testthat::expect_equal(nrow(out), 2L)
  testthat::expect_identical(sort(out$chain), c("BCR", "TCR"))
  testthat::expect_true(all(out$sample == "s1"))
})

testthat::test_that("VDJ record merge replaces freshly imported sample-chain slices only", {
  existing <- data.frame(
    barcode = c("bc1", "bc2", "bc3"),
    clone = c("old_tcr", "old_bcr", "other_tcr"),
    chain = c("TCR", "BCR", "TCR"),
    sample = c("sample_a", "sample_a", "sample_b"),
    cell = c("cell_a1", "cell_a2", "cell_b1"),
    stringsAsFactors = FALSE
  )
  fresh <- data.frame(
    barcode = c("bc4", "bc5"),
    clone = c("new_tcr", "new_tcr_2"),
    chain = c("TCR", "TCR"),
    sample = c("sample_a", "sample_c"),
    cell = c("cell_a3", "cell_c1"),
    stringsAsFactors = FALSE
  )

  out <- .vdj_payload_merge_records(existing, fresh)

  testthat::expect_equal(nrow(out), 4L)
  testthat::expect_false(any(out$clone == "old_tcr"))
  testthat::expect_true(any(out$clone == "old_bcr"))
  testthat::expect_true(any(out$clone == "other_tcr"))
  testthat::expect_true(any(out$clone == "new_tcr"))
})

testthat::test_that("raw contig preservation keeps original columns and app mapping metadata", {
  df <- data.frame(
    barcode = c("AAAC-1", "AAAD-1"),
    raw_clonotype_id = c("clonotype1", "clonotype2"),
    chain = c("TRB", "IGH"),
    productive = c(TRUE, FALSE),
    cdr3 = c("CASSQ", "CARDR"),
    v_gene = c("TRBV7-9", "IGHV1-2"),
    stringsAsFactors = FALSE
  )

  out <- .vdj_payload_build_raw_contigs(
    df = df,
    sample_id = "sample_a",
    file_name = "filtered_contig_annotations.csv",
    file_path = "/tmp/filtered_contig_annotations.csv",
    source_tag = "upload",
    barcode_values = df$barcode,
    clone_values = df$raw_clonotype_id,
    chain_input = df$chain,
    chain_class = c("TCR", "BCR"),
    mapped_cell = c("sample_a_AAAC-1", NA_character_)
  )

  testthat::expect_true(all(c("barcode", "raw_clonotype_id", "chain", "productive", "cdr3", "v_gene") %in% colnames(out)))
  testthat::expect_true(all(c(
    "wl_vdj_sample",
    "wl_vdj_file_name",
    "wl_vdj_file_path",
    "wl_vdj_source_tag",
    "wl_vdj_barcode_input",
    "wl_vdj_clone_input",
    "wl_vdj_chain_input",
    "wl_vdj_chain_class",
    "wl_vdj_mapped_cell",
    "wl_vdj_matched_to_object",
    "wl_vdj_row_index"
  ) %in% colnames(out)))
  testthat::expect_identical(out$wl_vdj_sample, c("sample_a", "sample_a"))
  testthat::expect_identical(out$wl_vdj_chain_class, c("TCR", "BCR"))
  testthat::expect_identical(out$wl_vdj_matched_to_object, c(TRUE, FALSE))
})

testthat::test_that("raw contig merge replaces sample-chain slices and keeps unrelated slices", {
  existing <- .vdj_payload_build_raw_contigs(
    df = data.frame(barcode = c("A1", "A2", "A3"), clone = c("x1", "x2", "x3"), stringsAsFactors = FALSE),
    sample_id = c("sample_a", "sample_a", "sample_a"),
    file_name = c("a_tcr.csv", "a_tcr.csv", "a_bcr.csv"),
    file_path = c("/tmp/a_tcr.csv", "/tmp/a_tcr.csv", "/tmp/a_bcr.csv"),
    source_tag = "upload",
    barcode_values = c("A1", "A2", "A3"),
    clone_values = c("x1", "x2", "x3"),
    chain_input = c("TRB", "TRA", "IGH"),
    chain_class = c("TCR", "TCR", "BCR"),
    mapped_cell = c("cell1", "cell2", "cell3")
  )
  fresh <- .vdj_payload_build_raw_contigs(
    df = data.frame(barcode = c("A4", "B1"), clone = c("x4", "y1"), stringsAsFactors = FALSE),
    sample_id = c("sample_a", "sample_b"),
    file_name = c("a_tcr_new.csv", "b_tcr.csv"),
    file_path = c("/tmp/a_tcr_new.csv", "/tmp/b_tcr.csv"),
    source_tag = "upload",
    barcode_values = c("A4", "B1"),
    clone_values = c("x4", "y1"),
    chain_input = c("TRB", "TRB"),
    chain_class = c("TCR", "TCR"),
    mapped_cell = c("cell4", "cell5")
  )

  out <- .vdj_payload_merge_raw_contigs(existing, fresh)

  testthat::expect_equal(sum(out$wl_vdj_sample == "sample_a" & out$wl_vdj_chain_class == "TCR"), 1L)
  testthat::expect_equal(sum(out$wl_vdj_sample == "sample_a" & out$wl_vdj_chain_class == "BCR"), 1L)
  testthat::expect_equal(sum(out$wl_vdj_sample == "sample_b" & out$wl_vdj_chain_class == "TCR"), 1L)
  testthat::expect_false(any(out$wl_vdj_file_name == "a_tcr.csv"))
  testthat::expect_true(any(out$wl_vdj_file_name == "a_bcr.csv"))
  testthat::expect_true(any(out$wl_vdj_file_name == "a_tcr_new.csv"))
})
