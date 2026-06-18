.run_source_path <- if (file.exists("Content/run.R")) {
  "Content/run.R"
} else {
  "../../Content/run.R"
}

testthat::test_that("python bootstrap normalizes quoted executable paths before system2 probes", {
  run_source <- paste(readLines(.run_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "\\.normalize_exec_path\\s*<-\\s*function\\(x\\)",
      run_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "py3\\s*<-\\s*\\.normalize_exec_path\\(unname\\(Sys\\.which\\(\"python3\"\\)\\[\\[1\\]\\]",
      run_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "for \\(cc in cands\\) \\{[\\s\\S]*?cc\\$bin\\s*<-\\s*\\.normalize_exec_path\\(cc\\$bin\\)[\\s\\S]*?system2\\(cc\\$bin,\\s*probe",
      run_source,
      perl = TRUE
    )
  )
})
