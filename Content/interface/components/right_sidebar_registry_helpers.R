`%||%` <- get0("%||%", mode = "function", inherits = TRUE, ifnotfound = function(a, b) if (is.null(a)) b else a)

sidebar_registry_entry_object <- function(entry) {
  if (is.list(entry) && !is.null(entry$obj)) return(entry$obj)
  entry
}

sidebar_registry_entry_stage <- function(entry) {
  stage_raw <- tryCatch(entry$meta$stage, error = function(e) NULL)
  stage_chr <- as.character(stage_raw %||% character(0))
  stage_chr <- stage_chr[!is.na(stage_chr) & nzchar(stage_chr)]
  if (!length(stage_chr)) return("")
  tolower(stage_chr[[1]])
}

sidebar_registry_fmt_size <- function(n) {
  x <- suppressWarnings(as.numeric(n))
  if (!is.finite(x) || x < 0) return("Unknown size")
  u <- c("B", "KB", "MB", "GB", "TB")
  i <- 1L
  while (x >= 1024 && i < length(u)) {
    x <- x / 1024
    i <- i + 1L
  }
  if (i == 1L) sprintf("%d %s", round(x), u[i]) else sprintf("%.1f %s", x, u[i])
}

sidebar_registry_fmt_time <- function(x) {
  if (is.null(x) || !length(x)) return("Time: Unknown")
  tt <- suppressWarnings(as.POSIXct(x, origin = "1970-01-01", tz = Sys.timezone()))
  if (is.na(tt)) return("Time: Unknown")
  paste0("Time: ", format(tt, "%Y-%m-%d %H:%M"))
}

sidebar_registry_default_meta_line_html <- function(x) {
  vals <- as.character(x %||% "")
  if (!length(vals)) return(character(0))
  vapply(vals, function(txt) {
    txt <- as.character(txt %||% "")
    if (!nzchar(txt)) return("")
    parts <- trimws(strsplit(txt, "\\|", fixed = FALSE)[[1]])
    parts <- parts[nzchar(parts)]
    if (!length(parts)) return(htmltools::htmlEscape(txt))
    esc_parts <- vapply(parts, htmltools::htmlEscape, character(1))
    if (length(esc_parts) == 1L) return(esc_parts[[1]])
    seg <- esc_parts[[1]]
    for (i in 2:length(esc_parts)) {
      seg <- paste0(seg, "<span class='sfi-meta-sep'> | </span><wbr>", esc_parts[[i]])
    }
    seg
  }, character(1))
}

sidebar_registry_obj_cell_count <- function(obj) {
  assays <- tryCatch(as.character(names(obj@assays)), error = function(e) character(0))
  if (!length(assays)) return(NA_real_)

  target_assay <- if (any(tolower(assays) == "rna")) {
    assays[[which(tolower(assays) == "rna")[1]]]
  } else {
    assays[[1]]
  }

  assay_cells <- tryCatch(colnames(obj[[target_assay]]), error = function(e) NULL)
  if (is.null(assay_cells) || !length(assay_cells)) return(NA_real_)
  as.numeric(length(unique(as.character(assay_cells))))
}

sidebar_registry_obj_assay_count <- function(obj) {
  n <- suppressWarnings(tryCatch(as.numeric(length(names(obj@assays))), error = function(e) NA_real_))
  if (!is.finite(n) || is.na(n) || n < 0) return(NA_real_)
  n
}

sidebar_registry_obj_sample_count <- function(obj) {
  md <- tryCatch(obj@meta.data, error = function(e) NULL)
  if (is.null(md) || !is.data.frame(md) || !nrow(md)) return(NA_real_)
  cand <- intersect(c("orig.ident", "sample", "sample_name"), colnames(md))
  if (!length(cand)) return(NA_real_)
  best <- 1
  for (cc in cand) {
    vals <- as.character(md[[cc]])
    vals <- vals[!is.na(vals) & nzchar(vals)]
    u <- length(unique(vals))
    if (u > best) best <- u
  }
  as.numeric(best)
}

sidebar_registry_obj_has_atac <- function(obj) {
  assays <- tryCatch(as.character(names(obj@assays)), error = function(e) character(0))
  if (!length(assays)) return(FALSE)
  low <- tolower(assays)
  if (any(low %in% c("atac", "peaks", "chromatin"))) return(TRUE)
  if (any(grepl("atac|peak|chromatin", low, perl = TRUE))) return(TRUE)
  cls <- unlist(lapply(assays, function(an) {
    tolower(paste(tryCatch(class(obj[[an]]), error = function(e) character(0)), collapse = " "))
  }), use.names = FALSE)
  any(grepl("chromatinassay|atac", cls, perl = TRUE))
}

sidebar_registry_entry_umap_pca_dims <- function(entry) {
  dims_now <- suppressWarnings(as.integer(tryCatch(entry$prefs$confirmed_dims$value, error = function(e) NULL)))
  if (!length(dims_now)) return(NA_integer_)
  d <- dims_now[[1]]
  if (!is.finite(d) || is.na(d) || d < 2L) return(NA_integer_)
  as.integer(d)
}

sidebar_registry_object_row <- function(name,
                                        entry,
                                        sample_path_map = character(0),
                                        remove_btn_html = function(key) "",
                                        meta_line_html = sidebar_registry_default_meta_line_html) {
  nm <- as.character(name %||% "")
  obj <- sidebar_registry_entry_object(entry)
  meta <- if (is.list(entry) && !is.null(entry$meta)) entry$meta else NULL
  stage <- sidebar_registry_entry_stage(entry)
  is_filtered <- grepl("_filtered$", nm, ignore.case = TRUE) || identical(stage, "filtered")
  type_txt <- if (is_filtered) "Seurat object (filtered)" else "Seurat object"
  size_txt <- tryCatch(sidebar_registry_fmt_size(as.numeric(utils::object.size(obj))), error = function(e) "Unknown size")
  cells_n <- sidebar_registry_obj_cell_count(obj)
  assays_n <- sidebar_registry_obj_assay_count(obj)
  samples_n <- sidebar_registry_obj_sample_count(obj)
  has_atac <- sidebar_registry_obj_has_atac(obj)
  is_merged_like <- isTRUE(samples_n > 1) || grepl("integrat|merge", tolower(paste(nm, stage)), perl = TRUE)

  cells_txt <- if (is.finite(cells_n)) paste0(format(cells_n, big.mark = ","), " cells") else "Cells: NA"
  atac_txt <- paste0("ATAC: ", if (isTRUE(has_atac)) "Yes" else "No")
  type_line <- paste(type_txt, size_txt, atac_txt, sep = " | ")

  created <- meta$created %||% NA
  sample_path <- tryCatch(as.character(sample_path_map[[nm]] %||% ""), error = function(e) "")
  if ((is.null(created) || is.na(created)) && nzchar(sample_path) && file.exists(sample_path)) {
    created <- file.info(sample_path)$mtime
  }
  t_txt <- sidebar_registry_fmt_time(created)
  detail_txt <- if (is_merged_like) {
    paste0(
      "Assays: ",
      if (is.finite(assays_n)) format(assays_n, big.mark = ",") else "NA",
      " | Samples: ",
      if (is.finite(samples_n)) format(samples_n, big.mark = ",") else "NA",
      " | ", t_txt
    )
  } else {
    t_txt
  }
  umap_pca_dims <- sidebar_registry_entry_umap_pca_dims(entry)
  if (is.finite(umap_pca_dims) && !is.na(umap_pca_dims)) {
    detail_txt <- paste0(detail_txt, " | UMAP PCA dims: ", format(umap_pca_dims, big.mark = ","))
  }
  md <- tryCatch(obj@meta.data, error = function(e) NULL)
  has_vdj_cols <- is.data.frame(md) && nrow(md) && all(c("vdj_tcr_pos", "vdj_bcr_pos", "vdj_tcr_clone", "vdj_bcr_clone", "vdj_tcr_clone_size", "vdj_bcr_clone_size") %in% colnames(md))
  if (isTRUE(has_vdj_cols)) {
    .is_detected_clone <- function(x) {
      xx <- tolower(trimws(as.character(x %||% "")))
      !(is.na(xx) | xx == "" | xx == "0" | xx == "unknown")
    }
    tcr_pos <- as.logical(md$vdj_tcr_pos %||% FALSE) & .is_detected_clone(md$vdj_tcr_clone %||% "")
    bcr_pos <- as.logical(md$vdj_bcr_pos %||% FALSE) & .is_detected_clone(md$vdj_bcr_clone %||% "")
    tcr_n <- sum(tcr_pos, na.rm = TRUE)
    bcr_n <- sum(bcr_pos, na.rm = TRUE)
    both_n <- sum((tcr_pos | bcr_pos), na.rm = TRUE)
    vdj_txt <- paste0("VDJ: TCR+ ", format(as.integer(tcr_n), big.mark = ","), " | BCR+ ", format(as.integer(bcr_n), big.mark = ","), " | VDJ+ ", format(as.integer(both_n), big.mark = ","))
    if (as.integer(both_n) == 0L) vdj_txt <- paste0(vdj_txt, " | no VDJ detected")
    detail_txt <- paste0(detail_txt, " | ", vdj_txt)
  }

  disp <- sprintf(
    "<div class='sidebar-file-item sfi-seurat'>%s<div class='sfi-header'><div class='sfi-title' title='%s'><span class='sfi-title-text'>%s</span></div><div class='sfi-cell-count'>%s</div></div><div class='sfi-meta1'>%s</div><div class='sfi-meta2'>%s</div></div>",
    remove_btn_html(paste0("obj::", nm)),
    htmltools::htmlEscape(nm), htmltools::htmlEscape(nm),
    htmltools::htmlEscape(cells_txt),
    meta_line_html(type_line),
    meta_line_html(detail_txt)
  )

  data.frame(
    name = nm,
    kind = "Seurat object",
    status = "Ready",
    key = paste0("obj::", nm),
    object_name = nm,
    cell_count_text = cells_txt,
    size_text = size_txt,
    type_text = type_txt,
    time_text = t_txt,
    display = disp,
    stringsAsFactors = FALSE
  )
}

sidebar_registry_safe_object_row <- function(name,
                                             entry,
                                             sample_path_map = character(0),
                                             remove_btn_html = function(key) "",
                                             meta_line_html = sidebar_registry_default_meta_line_html) {
  tryCatch(
    sidebar_registry_object_row(
      name = name,
      entry = entry,
      sample_path_map = sample_path_map,
      remove_btn_html = remove_btn_html,
      meta_line_html = meta_line_html
    ),
    error = function(e) {
      nm <- as.character(name %||% "")
      remove_btn <- tryCatch(remove_btn_html(paste0("obj::", nm)), error = function(err) "")
      meta_line <- tryCatch(meta_line_html("Seurat object | Unknown size | Cells: NA"), error = function(err) "Seurat object | Unknown size | Cells: NA")
      detail_line <- tryCatch(meta_line_html("Summary unavailable"), error = function(err) "Summary unavailable")
      disp <- sprintf(
        "<div class='sidebar-file-item sfi-seurat'>%s<div class='sfi-header'><div class='sfi-title' title='%s'><span class='sfi-title-text'>%s</span></div><div class='sfi-cell-count'>Cells: NA</div></div><div class='sfi-meta1'>%s</div><div class='sfi-meta2'>%s</div></div>",
        remove_btn,
        htmltools::htmlEscape(nm), htmltools::htmlEscape(nm),
        meta_line,
        detail_line
      )
      data.frame(
        name = nm,
        kind = "Seurat object",
        status = "Ready",
        key = paste0("obj::", nm),
        object_name = nm,
        cell_count_text = "Cells: NA",
        size_text = "Unknown size",
        type_text = "Seurat object",
        time_text = "Time: Unknown",
        display = disp,
        stringsAsFactors = FALSE
      )
    }
  )
}
