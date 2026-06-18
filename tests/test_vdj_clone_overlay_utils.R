source("Content/interface/shared/vdj_clone_overlay_utils.R")

meta <- data.frame(
  vdj_tcr_clone_size = c(0, 1, 2, 16),
  vdj_bcr_clone_size = c(0, 1, 12, 104)
)

tcr_cfg <- .vdj_clone_threshold_config(meta, feature = "tcr", current = 104)
stopifnot(identical(tcr_cfg$min, 1L))
stopifnot(identical(tcr_cfg$max, 16L))
stopifnot(identical(tcr_cfg$value, 16L))

bcr_cfg <- .vdj_clone_threshold_config(meta, feature = "bcr", current = 2)
stopifnot(identical(bcr_cfg$min, 1L))
stopifnot(identical(bcr_cfg$max, 104L))
stopifnot(identical(bcr_cfg$value, 2L))

cat("VDJ clone threshold config tests passed\n")
