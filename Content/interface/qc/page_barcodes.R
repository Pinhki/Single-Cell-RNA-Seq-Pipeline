BARCODE_UI_TEXT <- list(
  t_btn_create_matched_object_workspace = "Create filtered objects in workspace",
  t_btn_parse_barcode_files = "Parse barcode files",
  t_btn_run_barcode_matching = "Run barcode matching",
  t_label_upload_barcode_files_txt_csv_tsv = "Upload barcode files (.txt/.csv/.tsv)",
  t_label_objects_include_matching = "Objects to include in matching",
  t_text_barcode_entries = "Barcode entries",
  t_text_expected_columns_barcode_cell_first_column = "Expected columns: barcode/cell. For mixed files, add sample/condition column(s) so rows can be mapped.",
  t_text_file_sample_mapping_help = "Map barcode-file sample/condition labels to imported sample names (or object names) before matching.",
  t_text_if_cell_names_include_suffixes_like = "If cell names include suffixes like -1, -2, _1, _2, assign each suffix to a sample for better matching.",
  t_text_scope = "Scope",
  t_text_upload_barcode_list_file_s_map = "Upload barcode list file(s), choose workspace objects, map barcode-file sample labels to imported samples/objects, then review matching across loaded Seurat objects.",
  t_title_barcode_input = "Barcode input",
  t_title_barcode_match_summary = "Barcode match summary",
  t_title_file_parsing_summary = "File parsing summary",
  t_title_file_sample_mapping = "File sample/condition mapping",
  t_title_object_level_match_details = "Object-level match details",
  t_title_matched_cells_umap = "Matched cells on UMAP",
  t_title_qc_i_have_barcodes = "QC: I have barcodes",
  t_title_suffix_assignment = "Suffix assignment"
)

library(shiny)
library(shinyjs)
library(DT)
library(plotly)
library(shinycssloaders)

`%||%` <- function(a, b) if (is.null(a)) b else a

barcode_build_match_scope_summary <- function(match_df) {
  m <- as.data.frame(match_df %||% data.frame(), stringsAsFactors = FALSE)
  if (!nrow(m)) {
    return(data.frame(
      scope = character(0),
      queries = integer(0),
      matched = integer(0),
      unmatched = integer(0),
      match_rate = numeric(0),
      stringsAsFactors = FALSE
    ))
  }

  needed <- c("mapped_target", "file_group", "matched")
  if (!all(needed %in% colnames(m))) {
    stop("barcode_build_match_scope_summary requires mapped_target, file_group, and matched columns")
  }

  scope <- ifelse(
    nzchar(as.character(m$mapped_target %||% "")),
    as.character(m$mapped_target),
    paste0("Unmapped: ", as.character(m$file_group %||% ""))
  )

  split_idx <- split(seq_len(nrow(m)), scope)
  out <- data.frame(
    scope = names(split_idx),
    queries = as.integer(vapply(split_idx, length, integer(1))),
    matched = as.integer(vapply(split_idx, function(ix) sum(as.integer(m$matched[ix]), na.rm = TRUE), integer(1))),
    stringsAsFactors = FALSE
  )
  out$unmatched <- pmax(out$queries - out$matched, 0L)
  out$match_rate <- round(100 * out$matched / pmax(out$queries, 1L), 1)
  out
}

barcode_build_object_match_detail <- function(match_df, objects_by_name) {
  m <- as.data.frame(match_df %||% data.frame(), stringsAsFactors = FALSE)
  if (!nrow(m)) {
    return(data.frame(
      matched_object = character(0),
      queries = integer(0),
      matched = integer(0),
      unique_cells = integer(0),
      metadata_columns = character(0),
      metadata_preview = character(0),
      example_pairs = character(0),
      stringsAsFactors = FALSE
    ))
  }

  m$matched <- as.logical(m$matched %||% FALSE)
  m$matched_object <- as.character(m$matched_object %||% "")
  m$matched_cell <- as.character(m$matched_cell %||% "")
  m$barcode <- as.character(m$barcode %||% "")

  obj_names <- unique(m$matched_object[nzchar(m$matched_object)])
  if (!length(obj_names)) {
    return(data.frame(
      matched_object = character(0),
      queries = integer(0),
      matched = integer(0),
      unique_cells = integer(0),
      metadata_columns = character(0),
      metadata_preview = character(0),
      example_pairs = character(0),
      stringsAsFactors = FALSE
    ))
  }

  .obj_meta <- function(obj) {
    if (is.null(obj)) return(NULL)
    if (inherits(obj, "Seurat")) {
      return(tryCatch(obj@meta.data, error = function(e) NULL))
    }
    if (is.list(obj) && is.data.frame(obj$meta.data)) return(obj$meta.data)
    NULL
  }

  rows <- lapply(obj_names, function(nm) {
    sub_all <- m[m$matched_object == nm, , drop = FALSE]
    sub_hit <- sub_all[sub_all$matched, , drop = FALSE]

    obj <- objects_by_name[[nm]]
    md <- .obj_meta(obj)
    md_cols <- if (is.data.frame(md)) colnames(md) else character(0)

    meta_cols_txt <- if (!length(md_cols)) {
      "<none>"
    } else if (length(md_cols) <= 8L) {
      paste(md_cols, collapse = ", ")
    } else {
      paste0(paste(head(md_cols, 8L), collapse = ", "), sprintf(" (+%d more)", length(md_cols) - 8L))
    }

    meta_preview <- "<none>"
    if (is.data.frame(md) && nrow(sub_hit)) {
      cell0 <- as.character(sub_hit$matched_cell[[1]] %||% "")
      if (nzchar(cell0) && (cell0 %in% rownames(md))) {
        pref <- c("orig.ident", "nCount_RNA", "nFeature_RNA", "percent.mt")
        take <- unique(c(pref[pref %in% md_cols], head(setdiff(md_cols, pref), 4L)))
        take <- take[seq_len(min(length(take), 4L))]
        if (length(take)) {
          vals <- vapply(take, function(k) as.character(md[cell0, k][[1]] %||% ""), character(1))
          meta_preview <- paste(paste0(take, "=", vals), collapse = "; ")
        }
      }
    }

    pair_txt <- "<none>"
    if (nrow(sub_hit)) {
      n_show <- min(3L, nrow(sub_hit))
      pair_txt <- paste(paste0(sub_hit$barcode[seq_len(n_show)], " -> ", sub_hit$matched_cell[seq_len(n_show)]), collapse = "; ")
    }

    data.frame(
      matched_object = nm,
      queries = nrow(sub_all),
      matched = sum(as.integer(sub_all$matched), na.rm = TRUE),
      unique_cells = length(unique(sub_hit$matched_cell[nzchar(sub_hit$matched_cell)])),
      metadata_columns = meta_cols_txt,
      metadata_preview = meta_preview,
      example_pairs = pair_txt,
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, rows)
}

barcode_ui <- fluidPage(
  div(
    class = "page-header",
    h2(icon("barcode"), " ", BARCODE_UI_TEXT$t_title_qc_i_have_barcodes),
    p(BARCODE_UI_TEXT$t_text_upload_barcode_list_file_s_map)
  ),
  fluidRow(
    column(
      4,
      wellPanel(
        h4(BARCODE_UI_TEXT$t_title_barcode_input),
        div(
          class = "text-muted",
          style = "font-size: 12px;",
          BARCODE_UI_TEXT$t_text_expected_columns_barcode_cell_first_column
        ),
        fileInput(
          "barcode_files",
          BARCODE_UI_TEXT$t_label_upload_barcode_files_txt_csv_tsv,
          multiple = TRUE,
          accept = c(".txt", ".csv", ".tsv")
        ),
        br(),
        actionButton(
          "barcode_parse_btn",
          BARCODE_UI_TEXT$t_btn_parse_barcode_files,
          class = "btn btn-primary btn-sm",
          icon = icon("upload")
        ),
        div(style = "height:8px"),
        uiOutput("barcode_object_selector_ui"),
        div(style = "height:6px"),
        actionButton(
          "barcode_run_btn",
          BARCODE_UI_TEXT$t_btn_run_barcode_matching,
          class = "btn btn-default btn-sm",
          icon = icon("search")
        ),
        div(style = "height:6px"),
        actionButton(
          "barcode_create_obj_btn",
          BARCODE_UI_TEXT$t_btn_create_matched_object_workspace,
          class = "btn btn-success btn-sm",
          icon = icon("check")
        ),
        br(), br(),
        uiOutput("barcode_status_ui")
      ),
      wellPanel(
        h4(BARCODE_UI_TEXT$t_title_file_sample_mapping),
        p(BARCODE_UI_TEXT$t_text_file_sample_mapping_help),
        uiOutput("barcode_mapping_targets_ui"),
        DTOutput("barcode_group_map_table")
      ),
      wellPanel(
        h4(BARCODE_UI_TEXT$t_title_suffix_assignment),
        p(BARCODE_UI_TEXT$t_text_if_cell_names_include_suffixes_like),
        DTOutput("barcode_suffix_map_table")
      )
    ),
    column(
      8,
      class = "plot_area_card_style",
      wellPanel(
        h4(BARCODE_UI_TEXT$t_title_file_parsing_summary),
        DTOutput("barcode_file_summary_table")
      ),
      wellPanel(
        h4(BARCODE_UI_TEXT$t_title_barcode_match_summary),
        DTOutput("barcode_match_summary_table"),
        div(style = "height:10px"),
        qc_with_busy_spinner(plotlyOutput("barcode_match_bar_plot", height = "320px"))
      ),
      wellPanel(
        h4(BARCODE_UI_TEXT$t_title_object_level_match_details),
        DTOutput("barcode_object_match_table")
      )
      ,
      uiOutput("barcode_umap_card_ui")
    )
  )
)

barcode_server <- function(input, output, session, shared_data) {
  .norm_key <- function(x) gsub("[^a-z0-9]", "", tolower(as.character(x %||% "")))
  .strip_suffix <- function(x) sub("([._-][0-9]+)$", "", as.character(x %||% ""), perl = TRUE)
  .extract_suffix <- function(x) {
    sx <- sub("^.*([._-][0-9]+)$", "\\1", as.character(x %||% ""), perl = TRUE)
    has <- grepl("[._-][0-9]+$", as.character(x %||% ""), perl = TRUE)
    sx[!has] <- ""
    sx
  }

  .barcode_keys <- function(x) {
    x <- trimws(as.character(x %||% ""))
    if (!nzchar(x)) return(character(0))

    no_suffix <- .strip_suffix(x)
    tokens <- unlist(strsplit(no_suffix, "[^A-Za-z0-9]+", perl = TRUE), use.names = FALSE)
    dna <- regmatches(no_suffix, gregexpr("[ACGTNacgtn]{8,}", no_suffix, perl = TRUE))[[1]]

    cand <- unique(c(x, no_suffix, tokens, dna))
    keys <- .norm_key(cand)
    keys <- unique(keys[nzchar(keys)])

    # Keep short tokens only when no better key exists.
    long_keys <- keys[nchar(keys) >= 6]
    if (length(long_keys)) return(long_keys)
    keys
  }

  .pick_barcode_col <- function(nms) {
    nms <- as.character(nms %||% character(0))
    if (!length(nms)) return(NA_character_)
    hit <- grep("barcode|cell", nms, ignore.case = TRUE, value = TRUE)[1]
    if (!is.na(hit) && nzchar(hit)) return(hit)
    nms[[1]]
  }

  .pick_group_col <- function(nms, barcode_col) {
    nms <- as.character(nms %||% character(0))
    if (!length(nms)) return(NA_character_)
    cand <- grep("sample|condition|group|object|orig.ident|orig_ident|dataset", nms, ignore.case = TRUE, value = TRUE)
    cand <- cand[!(cand %in% barcode_col)]
    if (!length(cand)) return(NA_character_)
    cand[[1]]
  }

  .score_candidate_table <- function(df, assume_header) {
    if (is.null(df) || !is.data.frame(df) || !nrow(df) || !ncol(df)) return(-Inf)
    bc_col <- .pick_barcode_col(colnames(df))
    if (is.na(bc_col) || !nzchar(bc_col)) return(-Inf)

    vals <- trimws(as.character(df[[bc_col]]))
    vals <- vals[nzchar(vals)]
    if (!length(vals)) return(-Inf)

    barcode_like <- grepl("^[A-Za-z0-9._:-]+$", vals) & nchar(vals) >= 8
    first_like <- as.numeric(barcode_like[[1]])
    rest_like <- if (length(barcode_like) > 1) mean(barcode_like[-1]) else first_like
    first_header_like <- grepl("barcode|cell|sample|condition|group|id", vals[[1]], ignore.case = TRUE)

    score <- mean(barcode_like) + 0.2 * (rest_like - first_like) + 0.05 * log1p(length(vals))
    if (!isTRUE(assume_header) && isTRUE(first_header_like)) score <- score - 0.35
    score
  }

  .read_delimited_with_detection <- function(path, ext) {
    read_fun <- if (identical(ext, "csv")) utils::read.csv else utils::read.delim

    df_header <- tryCatch(
      read_fun(path, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE),
      error = function(e) NULL
    )
    df_no_header <- tryCatch(
      read_fun(path, header = FALSE, stringsAsFactors = FALSE, check.names = FALSE),
      error = function(e) NULL
    )

    score_header <- .score_candidate_table(df_header, assume_header = TRUE)
    score_no_header <- .score_candidate_table(df_no_header, assume_header = FALSE)

    use_header <- is.finite(score_header) && (score_header >= (score_no_header + 0.03))
    chosen <- if (isTRUE(use_header)) df_header else df_no_header

    list(
      df = chosen,
      used_header = isTRUE(use_header),
      score_header = score_header,
      score_no_header = score_no_header
    )
  }

  .read_barcode_file <- function(path, filename) {
    ext <- tolower(tools::file_ext(filename %||% path))
    file_group_default <- tools::file_path_sans_ext(basename(filename %||% "barcode_file"))

    if (identical(ext, "txt")) {
      vals <- readLines(path, warn = FALSE)
      vals <- trimws(vals)
      vals <- vals[nzchar(vals)]
      out <- data.frame(
        barcode = unique(vals),
        file_group = file_group_default,
        stringsAsFactors = FALSE
      )
      return(list(rows = out, used_header = FALSE, group_col = "", parse_mode = "txt"))
    }

    parsed <- .read_delimited_with_detection(path, ext)
    df <- parsed$df
    if (is.null(df) || !is.data.frame(df) || !nrow(df) || !ncol(df)) {
      return(list(rows = data.frame(barcode = character(0), file_group = character(0), stringsAsFactors = FALSE), used_header = parsed$used_header, group_col = "", parse_mode = "delim"))
    }

    bc_col <- .pick_barcode_col(colnames(df))
    grp_col <- .pick_group_col(colnames(df), bc_col)

    out <- data.frame(
      barcode = trimws(as.character(df[[bc_col]] %||% character(0))),
      file_group = if (!is.na(grp_col) && nzchar(grp_col)) trimws(as.character(df[[grp_col]] %||% character(0))) else "",
      stringsAsFactors = FALSE
    )
    out <- out[nzchar(out$barcode), , drop = FALSE]
    if (!nrow(out)) {
      return(list(rows = out, used_header = parsed$used_header, group_col = ifelse(is.na(grp_col), "", grp_col), parse_mode = "delim"))
    }

    out$file_group[!nzchar(out$file_group)] <- file_group_default
    out <- unique(out)

    list(
      rows = out,
      used_header = parsed$used_header,
      group_col = ifelse(is.na(grp_col), "", grp_col),
      parse_mode = "delim"
    )
  }

  .guess_sample_from_label <- function(label, sample_levels) {
    sample_levels <- unique(as.character(sample_levels %||% character(0)))
    sample_levels <- sample_levels[nzchar(sample_levels)]
    if (!length(sample_levels)) return(NA_character_)
    if (length(sample_levels) == 1L) return(sample_levels[[1]])

    label_key <- .norm_key(label)
    sample_key <- .norm_key(sample_levels)
    idx <- which(nzchar(sample_key) & grepl(sample_key, label_key, fixed = TRUE))
    if (length(idx) == 1L) return(sample_levels[[idx]])
    NA_character_
  }

  .make_unique_filtered_name <- function(source_name, registry) {
    root <- as.character(source_name %||% "object")
    if (grepl("_rna_filtered(?:_[0-9]+)?$", root, ignore.case = TRUE)) {
      root <- sub("_rna_filtered(?:_[0-9]+)?$", "", root, ignore.case = TRUE)
    } else if (grepl("_filtered(?:_[0-9]+)?$", root, ignore.case = TRUE)) {
      root <- sub("_filtered(?:_[0-9]+)?$", "", root, ignore.case = TRUE)
    }

    cand <- paste0(root, "_filtered")
    if (is.null(registry[[cand]])) return(cand)

    k <- 2L
    repeat {
      cand_k <- paste0(root, "_filtered_", k)
      if (is.null(registry[[cand_k]])) return(cand_k)
      k <- k + 1L
    }
  }

  overlay_on <- reactiveVal(FALSE)
  .show_overlay <- function(msg = "Working...") {
    overlay_show(msg, loader = "filter")
    overlay_on(TRUE)
  }
  .hide_overlay <- function() {
    if (isTRUE(overlay_on())) {
      overlay_hide()
      overlay_on(FALSE)
    }
  }

  .all_objects <- reactive({
    reg <- shared_data$all_seurat_objects %||% list()
    if (!length(reg)) return(list())

    out <- lapply(names(reg), function(nm) {
      ent <- reg[[nm]]
      obj <- if (is.list(ent) && !is.null(ent$obj)) ent$obj else ent
      if (!inherits(obj, "Seurat")) return(NULL)
      list(name = nm, obj = obj)
    })
    out <- out[!vapply(out, is.null, logical(1))]
    names(out) <- vapply(out, `[[`, character(1), "name")
    out
  })

  .selected_object_names <- reactive({
    objs <- .all_objects()
    avail <- names(objs)
    if (!length(avail)) return(character(0))

    sel <- input$barcode_target_objects
    if (is.null(sel)) return(avail)
    intersect(as.character(sel), avail)
  })

  .object_condition_map <- reactive({
    sheet <- shared_data$full_sample_sheet
    if (is.null(sheet) || !is.data.frame(sheet) || !nrow(sheet)) return(setNames(character(0), character(0)))
    if (!all(c("name", "condition") %in% colnames(sheet))) return(setNames(character(0), character(0)))
    nm <- as.character(sheet$name %||% character(0))
    cond <- as.character(sheet$condition %||% character(0))
    setNames(cond, nm)
  })

  .cell_pool <- reactive({
    objs_all <- .all_objects()
    sel <- .selected_object_names()
    if (!length(sel)) {
      return(data.frame(
        object = character(0),
        cell = character(0),
        sample = character(0),
        condition = character(0),
        suffix = character(0),
        base = character(0),
        stringsAsFactors = FALSE
      ))
    }

    condition_map <- .object_condition_map()

    rows <- lapply(sel, function(nm) {
      ent <- objs_all[[nm]]
      if (is.null(ent) || is.null(ent$obj)) return(NULL)
      sobj <- ent$obj

      md <- tryCatch(sobj@meta.data, error = function(e) NULL)
      cells <- tryCatch(rownames(md), error = function(e) character(0))
      if (is.null(cells) || !length(cells)) return(NULL)

      sm <- if ("orig.ident" %in% colnames(md)) as.character(md[cells, "orig.ident"]) else rep("", length(cells))
      cond_val <- ""
      if (nm %in% names(condition_map)) cond_val <- as.character(condition_map[[nm]] %||% "")
      cond <- rep(cond_val, length(cells))
      data.frame(
        object = nm,
        cell = cells,
        sample = sm,
        condition = cond,
        suffix = .extract_suffix(cells),
        base = .strip_suffix(cells),
        stringsAsFactors = FALSE
      )
    })

    rows <- rows[!vapply(rows, is.null, logical(1))]
    if (!length(rows)) {
      return(data.frame(
        object = character(0),
        cell = character(0),
        sample = character(0),
        condition = character(0),
        suffix = character(0),
        base = character(0),
        stringsAsFactors = FALSE
      ))
    }
    do.call(rbind, rows)
  })

  .cell_key_index <- reactive({
    cp <- .cell_pool()
    req(nrow(cp) > 0)

    key_rows <- lapply(seq_len(nrow(cp)), function(i) {
      ks <- .barcode_keys(cp$cell[[i]])
      if (!length(ks)) return(NULL)
      data.frame(row = rep.int(i, length(ks)), key = ks, stringsAsFactors = FALSE)
    })
    key_rows <- key_rows[!vapply(key_rows, is.null, logical(1))]

    if (!length(key_rows)) return(list(cp = cp, key_lookup = list()))
    idx <- do.call(rbind, key_rows)
    list(cp = cp, key_lookup = split(idx$row, idx$key))
  })

  .build_group_map <- function(qdf, cp, old_map = NULL) {
    if (is.null(qdf) || !is.data.frame(qdf) || !nrow(qdf)) {
      return(data.frame(file_group = character(0), mapped_target = character(0), n_barcodes = integer(0), stringsAsFactors = FALSE))
    }

    groups <- sort(unique(as.character(qdf$file_group %||% character(0))))
    groups <- groups[nzchar(groups)]
    if (!length(groups)) {
      return(data.frame(file_group = character(0), mapped_target = character(0), n_barcodes = integer(0), stringsAsFactors = FALSE))
    }

    valid_samples <- sort(unique(as.character(cp$sample[nzchar(cp$sample)])))
    valid_objects <- sort(unique(as.character(cp$object[nzchar(cp$object)])))
    valid_conditions <- sort(unique(as.character(cp$condition[nzchar(cp$condition)])))
    valid_targets <- unique(c(valid_samples, valid_objects, valid_conditions))

    default_target <- vapply(groups, function(g) {
      if (g %in% valid_targets) return(g)
      gs <- .guess_sample_from_label(g, valid_samples)
      if (!is.na(gs) && nzchar(gs)) return(gs)
      if (length(valid_samples) == 1L) return(valid_samples[[1]])
      ""
    }, character(1))

    out <- data.frame(
      file_group = groups,
      mapped_target = default_target,
      n_barcodes = vapply(groups, function(g) sum(as.character(qdf$file_group) == g), integer(1)),
      stringsAsFactors = FALSE
    )

    if (!is.null(old_map) && is.data.frame(old_map) && nrow(old_map)) {
      idx <- match(out$file_group, as.character(old_map$file_group))
      keep <- !is.na(idx) & nzchar(as.character(old_map$mapped_target[idx]))
      out$mapped_target[keep] <- as.character(old_map$mapped_target[idx[keep]])
    }

    out
  }

  barcode_status <- reactiveVal(list(msg = "No barcode files parsed yet.", type = "info"))
  barcode_file_rows <- reactiveVal(data.frame(file = character(0), sample_guess = character(0), n_barcodes = integer(0), n_groups = integer(0), header_mode = character(0), group_column = character(0), stringsAsFactors = FALSE))
  barcode_queries <- reactiveVal(data.frame(file = character(0), barcode = character(0), file_group = character(0), sample_hint = character(0), stringsAsFactors = FALSE))
  suffix_map <- reactiveVal(data.frame(suffix = character(0), sample = character(0), n_cells = integer(0), stringsAsFactors = FALSE))
  group_map <- reactiveVal(data.frame(file_group = character(0), mapped_target = character(0), n_barcodes = integer(0), stringsAsFactors = FALSE))
  match_detail <- reactiveVal(data.frame(file = character(0), file_group = character(0), mapped_target = character(0), barcode = character(0), sample_hint = character(0), matched_object = character(0), matched_cell = character(0), matched_sample = character(0), matched = logical(0), stringsAsFactors = FALSE))

  output$barcode_status_ui <- renderUI({
    st <- barcode_status()
    cls <- if (identical(st$type, "error")) {
      "alert alert-danger"
    } else if (identical(st$type, "warn")) {
      "alert alert-warning"
    } else {
      "alert alert-info"
    }
    div(class = cls, st$msg)
  })

  output$barcode_object_selector_ui <- renderUI({
    objs <- .all_objects()
    if (!length(objs)) {
      return(helpText("No Seurat objects available yet."))
    }

    obj_names <- names(objs)
    obj_cells <- vapply(objs, function(ent) {
      md <- tryCatch(ent$obj@meta.data, error = function(e) NULL)
      if (is.null(md)) return(0L)
      nrow(md)
    }, integer(1))

    lbl <- setNames(obj_names, sprintf("%s (%d cells)", obj_names, obj_cells))
    selected <- input$barcode_target_objects
    if (is.null(selected)) selected <- obj_names

    n_rows <- max(4L, min(max(length(obj_names), length(selected %||% character(0))), 12L))

    selectInput(
      "barcode_target_objects",
      BARCODE_UI_TEXT$t_label_objects_include_matching,
      choices = lbl,
      selected = intersect(selected, obj_names),
      multiple = TRUE,
      selectize = FALSE,
      size = n_rows
    )
  })

  output$barcode_mapping_targets_ui <- renderUI({
    cp <- .cell_pool()
    valid_samples <- sort(unique(as.character(cp$sample[nzchar(cp$sample)])))
    valid_objects <- sort(unique(as.character(cp$object[nzchar(cp$object)])))
    valid_conditions <- sort(unique(as.character(cp$condition[nzchar(cp$condition)])))
    choices <- unique(c(valid_samples, valid_objects, valid_conditions))
    txt <- if (length(choices)) paste(choices, collapse = ", ") else "<none>"

    div(
      class = "text-muted",
      style = "font-size: 12px; margin-bottom: 8px;",
      paste0("Valid targets: ", txt)
    )
  })

  observe({
    cp <- .cell_pool()
    sample_levels <- unique(cp$sample[nzchar(cp$sample)])

    sx_levels <- sort(unique(cp$suffix))
    if (!length(sx_levels)) sx_levels <- ""

    rows <- lapply(sx_levels, function(sv) {
      sub <- cp[cp$suffix == sv, , drop = FALSE]
      sm <- ""
      if (nrow(sub) && any(nzchar(sub$sample))) {
        v <- sub$sample[nzchar(sub$sample)]
        if (length(v)) sm <- names(sort(table(v), decreasing = TRUE))[1]
      }
      data.frame(suffix = sv, sample = sm %||% "", n_cells = nrow(sub), stringsAsFactors = FALSE)
    })

    df <- do.call(rbind, rows)

    old <- isolate(suffix_map())
    if (is.data.frame(old) && nrow(old)) {
      idx <- match(df$suffix, old$suffix)
      keep <- !is.na(idx)
      df$sample[keep] <- ifelse(nzchar(old$sample[idx[keep]]), old$sample[idx[keep]], df$sample[keep])
    }

    if (length(sample_levels)) {
      bad <- !(df$sample %in% sample_levels) & nzchar(df$sample)
      df$sample[bad] <- ""
    }

    suffix_map(df)
  })

  output$barcode_suffix_map_table <- renderDT({
    df <- suffix_map()
    if (is.null(df) || !nrow(df)) {
      return(datatable(data.frame(Suffix = "<none>", Sample = "", Cells = 0), rownames = FALSE, options = list(dom = "t", paging = FALSE)))
    }

    show_df <- df
    show_df$suffix[show_df$suffix == ""] <- "<none>"
    datatable(
      show_df,
      rownames = FALSE,
      selection = "none",
      editable = list(target = "cell", disable = list(columns = c(0, 2))),
      options = list(dom = "t", paging = FALSE, scrollX = TRUE),
      colnames = c("Suffix", "Assigned sample", "Cells in selected objects")
    )
  }, server = FALSE)

  observeEvent(input$barcode_suffix_map_table_cell_edit, {
    info <- input$barcode_suffix_map_table_cell_edit
    df <- suffix_map()
    req(nrow(df))

    i <- info$row
    j <- info$col + 1L
    if (i < 1 || i > nrow(df) || j != 2L) return()

    df$sample[[i]] <- trimws(as.character(info$value %||% ""))
    suffix_map(df)
  })

  output$barcode_group_map_table <- renderDT({
    df <- group_map()
    if (is.null(df) || !nrow(df)) {
      return(datatable(data.frame(`File sample/condition` = "No parsed groups", `Mapped target` = "", `Barcode count` = 0), rownames = FALSE, options = list(dom = "t", paging = FALSE)))
    }

    datatable(
      df,
      rownames = FALSE,
      selection = "none",
      editable = list(target = "cell", disable = list(columns = c(0, 2))),
      options = list(dom = "t", paging = FALSE, scrollX = TRUE),
      colnames = c("File sample/condition", "Mapped imported sample/object", "Barcode count")
    )
  }, server = FALSE)

  observeEvent(input$barcode_group_map_table_cell_edit, {
    info <- input$barcode_group_map_table_cell_edit
    df <- group_map()
    req(nrow(df))

    i <- info$row
    j <- info$col + 1L
    if (i < 1 || i > nrow(df) || j != 2L) return()

    df$mapped_target[[i]] <- trimws(as.character(info$value %||% ""))
    group_map(df)
  })

  observe({
    q <- barcode_queries()
    cp <- .cell_pool()
    if (is.null(q) || !nrow(q) || is.null(cp) || !nrow(cp)) {
      group_map(data.frame(file_group = character(0), mapped_target = character(0), n_barcodes = integer(0), stringsAsFactors = FALSE))
      return(invisible(NULL))
    }

    old <- isolate(group_map())
    group_map(.build_group_map(q, cp, old))
  })

  .parse_barcode_files <- function() {
    req(input$barcode_files)
    cp <- .cell_pool()
    if (!nrow(cp)) {
      barcode_status(list(msg = "No cells found in selected objects. Pick at least one object first.", type = "warn"))
      return(FALSE)
    }

    .show_overlay("Parsing barcode files...")
    on.exit(.hide_overlay(), add = TRUE, after = FALSE)

    sample_levels <- unique(cp$sample[nzchar(cp$sample)])
    fi <- input$barcode_files

    rows <- list()
    qlist <- list()
    missing_group_info <- character(0)

    for (i in seq_len(nrow(fi))) {
      parsed <- tryCatch(.read_barcode_file(fi$datapath[[i]], fi$name[[i]]), error = function(e) NULL)
      if (is.null(parsed)) {
        rows[[length(rows) + 1L]] <- data.frame(
          file = fi$name[[i]],
          sample_guess = "",
          n_barcodes = 0L,
          n_groups = 0L,
          header_mode = "failed",
          group_column = "",
          stringsAsFactors = FALSE
        )
        next
      }

      sg <- .guess_sample_from_label(fi$name[[i]], sample_levels)
      dat <- parsed$rows
      if (is.null(dat) || !is.data.frame(dat) || !nrow(dat)) {
        rows[[length(rows) + 1L]] <- data.frame(
          file = fi$name[[i]],
          sample_guess = ifelse(is.na(sg), "", sg),
          n_barcodes = 0L,
          n_groups = 0L,
          header_mode = ifelse(isTRUE(parsed$used_header), "header", "no_header"),
          group_column = parsed$group_col %||% "",
          stringsAsFactors = FALSE
        )
        next
      }

      dat$file_group <- as.character(dat$file_group %||% "")
      fallback_group <- if (!is.na(sg) && nzchar(sg)) sg else tools::file_path_sans_ext(basename(fi$name[[i]]))
      dat$file_group[!nzchar(dat$file_group)] <- fallback_group

      qtmp <- data.frame(
        file = fi$name[[i]],
        barcode = as.character(dat$barcode),
        file_group = as.character(dat$file_group),
        sample_hint = ifelse(is.na(sg), "", sg),
        stringsAsFactors = FALSE
      )

      rows[[length(rows) + 1L]] <- data.frame(
        file = fi$name[[i]],
        sample_guess = ifelse(is.na(sg), "", sg),
        n_barcodes = nrow(qtmp),
        n_groups = length(unique(qtmp$file_group)),
        header_mode = ifelse(isTRUE(parsed$used_header), "header", "no_header"),
        group_column = parsed$group_col %||% "",
        stringsAsFactors = FALSE
      )

      if (!nzchar(parsed$group_col %||% "")) missing_group_info <- c(missing_group_info, fi$name[[i]])
      qlist[[length(qlist) + 1L]] <- qtmp
    }

    fdf <- if (length(rows)) do.call(rbind, rows) else data.frame(file = character(0), sample_guess = character(0), n_barcodes = integer(0), n_groups = integer(0), header_mode = character(0), group_column = character(0), stringsAsFactors = FALSE)
    qdf <- if (length(qlist)) do.call(rbind, qlist) else data.frame(file = character(0), barcode = character(0), file_group = character(0), sample_hint = character(0), stringsAsFactors = FALSE)

    barcode_file_rows(fdf)
    barcode_queries(qdf)
    match_detail(data.frame(file = character(0), file_group = character(0), mapped_target = character(0), barcode = character(0), sample_hint = character(0), matched_object = character(0), matched_cell = character(0), matched_sample = character(0), matched = logical(0), stringsAsFactors = FALSE))

    warn_msg <- ""
    if (length(missing_group_info)) {
      warn_msg <- paste0(
        " Some files have no sample/condition column; add one when possible, or map file groups manually below."
      )
    }

    barcode_status(list(
      msg = sprintf(
        "Parsed %d file(s), %d barcode entries across %d selected object(s).%s",
        nrow(fdf), nrow(qdf), length(unique(cp$object)), warn_msg
      ),
      type = if (nrow(qdf) > 0 && !length(missing_group_info)) "info" else "warn"
    ))
    TRUE
  }

  observeEvent(input$barcode_parse_btn, {
    .parse_barcode_files()
  })

  observeEvent(input$barcode_files, {
    req(input$barcode_files)
    # Auto-parse uploaded files immediately to keep flow responsive.
    .parse_barcode_files()
  }, ignoreInit = TRUE)

  output$barcode_file_summary_table <- renderDT({
    df <- barcode_file_rows()
    if (is.null(df) || !nrow(df)) {
      return(datatable(
        data.frame(File = "No files parsed", `Sample guess` = "", `Barcode count` = 0, `Group count` = 0, `Header mode` = "", `Sample/condition column` = ""),
        rownames = FALSE,
        selection = "none",
        options = list(dom = "t", paging = FALSE)
      ))
    }

    datatable(
      df,
      rownames = FALSE,
      selection = "none",
      options = list(dom = "t", paging = FALSE, scrollX = TRUE),
      colnames = c("File", "Sample guess", "Barcode count", "Group count", "Header mode", "Sample/condition column")
    )
  }, server = FALSE)

  observeEvent(input$barcode_run_btn, {
    q <- barcode_queries()
    req(nrow(q) > 0)

    .show_overlay("Running smart barcode matching...")
    on.exit(.hide_overlay(), add = TRUE)

    key_index <- .cell_key_index()
    cp <- key_index$cp
    key_lookup <- key_index$key_lookup
    req(nrow(cp) > 0)

    sx_map <- suffix_map()
    grp_map <- group_map()
    map_lookup <- if (is.data.frame(grp_map) && nrow(grp_map)) {
      setNames(as.character(grp_map$mapped_target), as.character(grp_map$file_group))
    } else {
      setNames(character(0), character(0))
    }

    valid_samples <- unique(as.character(cp$sample[nzchar(cp$sample)]))
    valid_objects <- unique(as.character(cp$object[nzchar(cp$object)]))
    valid_conditions <- unique(as.character(cp$condition[nzchar(cp$condition)]))
    valid_targets <- unique(c(valid_samples, valid_objects, valid_conditions))

    invalid_targets <- character(0)
    if (is.data.frame(grp_map) && nrow(grp_map)) {
      invalid_targets <- setdiff(unique(as.character(grp_map$mapped_target[nzchar(grp_map$mapped_target)])), valid_targets)
    }

    out <- vector("list", nrow(q))
    for (i in seq_len(nrow(q))) {
      b_raw <- trimws(as.character(q$barcode[[i]] %||% ""))
      file_group <- as.character(q$file_group[[i]] %||% "")
      s_hint <- as.character(q$sample_hint[[i]] %||% "")
      mapped_target <- as.character(map_lookup[[file_group]] %||% "")

      if (!nzchar(b_raw)) {
        out[[i]] <- data.frame(
          file = q$file[[i]], file_group = file_group, mapped_target = mapped_target,
          barcode = b_raw, sample_hint = s_hint,
          matched_object = "", matched_cell = "", matched_sample = "", matched = FALSE,
          stringsAsFactors = FALSE
        )
        next
      }

      keys <- .barcode_keys(b_raw)
      cand_rows <- unique(unlist(key_lookup[keys], use.names = FALSE))
      sub <- if (length(cand_rows)) cp[cand_rows, , drop = FALSE] else cp[0, , drop = FALSE]

      # suffix-aware fallback for edge cases where normalized key lookup misses.
      if (!nrow(sub)) {
        base <- .strip_suffix(b_raw)
        sx_use <- unique(as.character(sx_map$suffix %||% character(0)))

        if (nzchar(mapped_target) && mapped_target %in% valid_samples) {
          sx_use <- unique(c("", as.character(sx_map$suffix[as.character(sx_map$sample) == mapped_target])))
        } else if (nzchar(s_hint)) {
          sx_use <- unique(c("", as.character(sx_map$suffix[as.character(sx_map$sample) == s_hint])))
        }

        cand_cells <- unique(c(
          b_raw,
          base,
          paste0(base, sx_use[nzchar(sx_use)])
        ))
        sub <- cp[cp$cell %in% cand_cells, , drop = FALSE]
      }

      # Apply manual mapping restriction first, then sample-hint fallback.
      if (nzchar(mapped_target)) {
        if (mapped_target %in% valid_objects) {
          sub <- sub[sub$object == mapped_target, , drop = FALSE]
        } else if (mapped_target %in% valid_samples) {
          sub <- sub[sub$sample == mapped_target, , drop = FALSE]
        } else if (mapped_target %in% valid_conditions) {
          sub <- sub[sub$condition == mapped_target, , drop = FALSE]
        }
      } else if (nrow(sub) && nzchar(s_hint)) {
        sub <- sub[sub$sample == s_hint, , drop = FALSE]
      }

      if (!nrow(sub)) {
        out[[i]] <- data.frame(
          file = q$file[[i]], file_group = file_group, mapped_target = mapped_target,
          barcode = b_raw, sample_hint = s_hint,
          matched_object = "", matched_cell = "", matched_sample = "", matched = FALSE,
          stringsAsFactors = FALSE
        )
      } else {
        # Prefer exact cell-string match, then stripped-suffix match.
        score <- integer(nrow(sub))
        score[sub$cell == b_raw] <- score[sub$cell == b_raw] + 4L
        score[.strip_suffix(sub$cell) == .strip_suffix(b_raw)] <- score[.strip_suffix(sub$cell) == .strip_suffix(b_raw)] + 2L
        if (nzchar(mapped_target) && mapped_target %in% valid_samples) {
          score[sub$sample == mapped_target] <- score[sub$sample == mapped_target] + 1L
        }

        r <- sub[which.max(score), , drop = FALSE]
        out[[i]] <- data.frame(
          file = q$file[[i]], file_group = file_group, mapped_target = mapped_target,
          barcode = b_raw, sample_hint = s_hint,
          matched_object = r$object, matched_cell = r$cell, matched_sample = r$sample, matched = TRUE,
          stringsAsFactors = FALSE
        )
      }
    }

    mdf <- do.call(rbind, out)
    match_detail(mdf)

    n_match <- sum(mdf$matched)
    warn_suffix <- if (length(invalid_targets)) {
      paste0(" Invalid mapping target(s): ", paste(invalid_targets, collapse = ", "), ".")
    } else {
      ""
    }

    barcode_status(list(
      msg = sprintf("Matched %d / %d barcode entries (%.1f%%).%s", n_match, nrow(mdf), 100 * n_match / max(1, nrow(mdf)), warn_suffix),
      type = if (n_match > 0 && !length(invalid_targets)) "info" else "warn"
    ))
  })

  output$barcode_match_summary_table <- renderDT({
    m <- match_detail()
    if (is.null(m) || !nrow(m)) {
      return(datatable(
        data.frame(Scope = "No matching run yet", Queries = 0, Matched = 0, Unmatched = 0, `Match rate %` = 0),
        rownames = FALSE,
        selection = "none",
        options = list(dom = "t", paging = FALSE)
      ))
    }

    out <- barcode_build_match_scope_summary(m)

    datatable(
      out,
      rownames = FALSE,
      selection = "none",
      options = list(dom = "t", paging = FALSE),
      colnames = c("Scope", "Queries", "Matched", "Unmatched", "Match rate %")
    )
  }, server = FALSE)

  output$barcode_match_bar_plot <- renderPlotly({
    m <- match_detail()
    req(nrow(m) > 0)

    out <- barcode_build_match_scope_summary(m)

    plot_ly(out, x = ~scope, y = ~matched, type = "bar", name = "Matched", marker = list(color = "#16a34a")) %>%
      add_trace(y = ~unmatched, name = "Unmatched", marker = list(color = "#9ca3af")) %>%
      layout(
        barmode = "stack",
        xaxis = list(title = BARCODE_UI_TEXT$t_text_scope),
        yaxis = list(title = BARCODE_UI_TEXT$t_text_barcode_entries)
      )
  })

  output$barcode_object_match_table <- renderDT({
    m <- match_detail()
    if (is.null(m) || !nrow(m)) {
      return(datatable(
        data.frame(
          `Matched object` = "No matching run yet",
          Queries = 0,
          Matched = 0,
          `Unique matched cells` = 0,
          `Metadata columns` = "",
          `Metadata preview (first matched cell)` = "",
          `Example matched barcode pairs (first 3)` = ""
        ),
        rownames = FALSE,
        selection = "none",
        options = list(dom = "t", paging = FALSE, scrollX = TRUE)
      ))
    }

    objs <- .all_objects()
    obj_map <- lapply(objs, `[[`, "obj")
    out <- barcode_build_object_match_detail(m, objects_by_name = obj_map)

    datatable(
      out,
      rownames = FALSE,
      selection = "none",
      options = list(dom = "t", paging = FALSE, scrollX = TRUE),
      colnames = c(
        "Matched object",
        "Queries",
        "Matched",
        "Unique matched cells",
        "Metadata columns",
        "Metadata preview (first matched cell)",
        "Example matched barcode pairs (first 3)"
      )
    )
  }, server = FALSE)

  output$barcode_umap_card_ui <- renderUI({
    m <- match_detail()
    if (is.null(m) || !nrow(m)) return(NULL)

    objs <- .all_objects()
    obj_map <- lapply(objs, `[[`, "obj")
    sel <- .selected_object_names()
    candidates <- unique(as.character(sel %||% character(0)))
    candidates <- candidates[candidates %in% names(obj_map)]
    if (!length(candidates)) return(NULL)

    has_umap <- vapply(candidates, function(nm) {
      emb <- tryCatch(Seurat::Embeddings(obj_map[[nm]], reduction = "umap"), error = function(e) NULL)
      is.matrix(emb) && nrow(emb) > 0 && ncol(emb) >= 2
    }, logical(1))
    candidates <- candidates[has_umap]
    if (!length(candidates)) return(NULL)

    selected_obj <- if (!is.null(input$barcode_umap_object) && input$barcode_umap_object %in% candidates) input$barcode_umap_object else candidates[[1]]
    md <- tryCatch(obj_map[[selected_obj]]@meta.data, error = function(e) NULL)
    split_choices <- c("None" = "__none__")
    if (is.data.frame(md) && ncol(md)) {
      md_cols <- colnames(md)
      md_cols <- md_cols[vapply(md_cols, function(k) {
        v <- md[[k]]
        # keep practical split columns: categorical or moderate-cardinality numerics
        if (is.factor(v) || is.character(v) || is.logical(v)) return(TRUE)
        if (is.numeric(v) || is.integer(v)) return(length(unique(stats::na.omit(v))) <= 20L)
        FALSE
      }, logical(1))]
      if (length(md_cols)) split_choices <- c(split_choices, setNames(md_cols, md_cols))
    }

    wellPanel(
      h4(BARCODE_UI_TEXT$t_title_matched_cells_umap),
      selectInput(
        "barcode_umap_object",
        "Object",
        choices = candidates,
        selected = selected_obj
      ),
      selectInput(
        "barcode_umap_split_by",
        "Split by meta.data",
        choices = split_choices,
        selected = if (!is.null(input$barcode_umap_split_by) && input$barcode_umap_split_by %in% split_choices) input$barcode_umap_split_by else "__none__"
      ),
      qc_with_busy_spinner(plotlyOutput("barcode_umap_plot", height = "420px"))
    )
  })

  output$barcode_umap_plot <- renderPlotly({
    req(input$barcode_umap_object)
    objs <- .all_objects()
    obj_map <- lapply(objs, `[[`, "obj")
    obj <- obj_map[[input$barcode_umap_object]]
    req(!is.null(obj))

    emb <- Seurat::Embeddings(obj, reduction = "umap")
    req(is.matrix(emb), nrow(emb) > 0, ncol(emb) >= 2)
    df <- data.frame(cell = rownames(emb), x = emb[, 1], y = emb[, 2], stringsAsFactors = FALSE)
    md <- tryCatch(obj@meta.data, error = function(e) NULL)

    m <- match_detail()
    hit <- m[m$matched & as.character(m$matched_object) == input$barcode_umap_object, , drop = FALSE]
    hit_cells <- unique(as.character(hit$matched_cell[nzchar(hit$matched_cell)]))
    df$matched <- df$cell %in% hit_cells
    df$split_group <- "All cells"

    split_by <- as.character(input$barcode_umap_split_by %||% "__none__")
    if (!identical(split_by, "__none__") && is.data.frame(md) && split_by %in% colnames(md)) {
      v <- as.character(md[df$cell, split_by])
      v[is.na(v) | !nzchar(v)] <- "<NA>"
      df$split_group <- v
    }

    groups <- unique(as.character(df$split_group))
    groups <- groups[nzchar(groups)]
    if (!length(groups)) groups <- "All cells"
    max_panels <- 9L
    if (length(groups) > max_panels) groups <- groups[seq_len(max_panels)]
    df <- df[df$split_group %in% groups, , drop = FALSE]

    p_list <- lapply(groups, function(g) {
      dsub <- df[df$split_group == g, , drop = FALSE]
      plot_ly(
        dsub,
        x = ~x,
        y = ~y,
        type = "scattergl",
        mode = "markers",
        color = ~matched,
        colors = c(`FALSE` = "#9ca3af", `TRUE` = "#16a34a"),
        marker = list(size = 5, opacity = 0.85),
        text = ~cell,
        hovertemplate = "Cell: %{text}<br>UMAP1: %{x:.2f}<br>UMAP2: %{y:.2f}<extra></extra>"
      ) %>%
        layout(title = list(text = g, x = 0, y = 0.98, xanchor = "left", font = list(size = 12)))
    })

    n_cols <- if (length(groups) <= 2L) length(groups) else 2L
    subplot(p_list, nrows = ceiling(length(groups) / n_cols), shareX = TRUE, shareY = TRUE, titleX = TRUE, titleY = TRUE) %>%
      layout(
        showlegend = TRUE,
        legend = list(title = list(text = "Matched")),
        xaxis = list(title = "UMAP1"),
        yaxis = list(title = "UMAP2")
      )
  })

  observeEvent(input$barcode_create_obj_btn, {
    m <- match_detail()
    req(nrow(m) > 0)

    .show_overlay("Creating filtered objects from matched cells...")
    on.exit(.hide_overlay(), add = TRUE)

    keep <- unique(m[m$matched & nzchar(m$matched_object) & nzchar(m$matched_cell), c("matched_object", "matched_cell")])
    if (!nrow(keep)) {
      showNotification("No matched cells remain after filtering.", type = "warning")
      return(invisible(NULL))
    }

    objs <- .all_objects()
    req(length(objs) > 0)

    obj_map <- lapply(objs, `[[`, "obj")
    split_cells <- split(keep$matched_cell, keep$matched_object)

    created <- character(0)
    reg <- shared_data$all_seurat_objects %||% list()

    for (nm in names(split_cells)) {
      sobj <- obj_map[[nm]]
      if (is.null(sobj)) next

      cc <- unique(as.character(split_cells[[nm]]))
      obj_cells <- tryCatch(rownames(sobj@meta.data), error = function(e) character(0))
      cc <- cc[cc %in% obj_cells]
      if (!length(cc)) next

      sobj_f <- subset(sobj, cells = cc)
      sobj_f <- wanlab_reset_subset_analysis_state(sobj_f)

      new_name <- .make_unique_filtered_name(nm, reg)
      reg[[new_name]] <- list(
        obj = sobj_f,
        plots = list(),
        meta = list(
          stage = "filtered",
          parent = nm,
          parents = nm,
          method = "barcode_match",
          created = Sys.time(),
          matched_cells = ncol(sobj_f)
        )
      )
      created <- c(created, new_name)
    }

    if (!length(created)) {
      showNotification("No filtered objects were created.", type = "warning")
      return(invisible(NULL))
    }

    shared_data$all_seurat_objects <- reg
    shared_data$active_object_name <- created[[length(created)]]

    preview <- paste(head(created, 4), collapse = ", ")
    extra <- if (length(created) > 4) sprintf(" (+%d more)", length(created) - 4L) else ""
    showNotification(sprintf("Created %d filtered object(s): %s%s", length(created), preview, extra), type = "message")

    barcode_status(list(
      msg = sprintf("Created %d filtered object(s) from matched cells.", length(created)),
      type = "info"
    ))
  })

  observeEvent(input$main_navbar, {
    if (identical(input$main_navbar %||% "", "barcode_tab")) return(invisible(NULL))
    .hide_overlay()
    invisible(NULL)
  }, ignoreInit = TRUE)
}
