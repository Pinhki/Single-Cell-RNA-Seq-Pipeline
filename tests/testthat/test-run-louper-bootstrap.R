.run_source_path <- if (file.exists("Content/run.R")) {
  "Content/run.R"
} else {
  "../../Content/run.R"
}

testthat::test_that("loupeR env bootstrap validates installation from target isolated library", {
  run_source <- paste(readLines(.run_source_path, warn = FALSE), collapse = "\n")

  testthat::expect_true(
    grepl(
      "\\.ensure_louper_in_env\\s*<-\\s*function\\(lib_path\\)[\\s\\S]*?pkg_in_env\\s*<-\\s*\"loupeR\"\\s*%in%\\s*\\.installed_pkg_index\\(lib_path\\)",
      run_source,
      perl = TRUE
    )
  )

  testthat::expect_true(
    grepl(
      "library\\(\"loupeR\",\\s*lib\\.loc\\s*=\\s*c\\(lib_path,\\s*CORE_LIB_PATH,\\s*sys_libs\\)",
      run_source,
      perl = TRUE
    )
  )
})
