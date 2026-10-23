# cellchat_core.R

`%||%` <- function(a, b) if (is.null(a)) b else a

cellchat_beta_object_names <- function(shared_data) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm in names(reg_flt)) if (is.null(reg[[nm]])) reg[[nm]] <- reg_flt[[nm]]

  nms <- names(reg)
  if (!length(nms)) return(character(0))
  nms <- nms[nzchar(nms)]
  if (!length(nms)) return(character(0))

  keep <- vapply(nms, function(nm) {
    x <- reg[[nm]]
    obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
    inherits(obj, "Seurat")
  }, logical(1))
  unique(nms[keep])
}

cellchat_beta_get_object <- function(shared_data, object_name = NULL) {
  reg_all <- (tryCatch(shared_data$all_seurat_objects, error = function(e) list())) %||% list()
  reg_flt <- (tryCatch(shared_data$filtered_objects, error = function(e) list())) %||% list()
  reg <- reg_all
  for (nm0 in names(reg_flt)) if (is.null(reg[[nm0]])) reg[[nm0]] <- reg_flt[[nm0]]

  valid_nms <- cellchat_beta_object_names(shared_data)
  nm <- as.character(object_name %||% "")
  if (!nzchar(nm)) nm <- as.character(tryCatch(shared_data$active_object_name, error = function(e) "") %||% "")
  if (!nzchar(nm) || !(nm %in% valid_nms)) nm <- if (length(valid_nms)) valid_nms[[length(valid_nms)]] else ""
  if (!nzchar(nm) || !(nm %in% names(reg))) return(NULL)

  x <- reg[[nm]]
  obj <- if (is.list(x) && !is.null(x$obj)) x$obj else x
  if (!inherits(obj, "Seurat")) return(NULL)
  obj
}

cellchat_beta_meta_cols <- function(sobj) {
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !nrow(md)) return(character(0))
  cols <- colnames(md)
  keep <- vapply(cols, function(cn) {
    v <- md[[cn]]
    v <- v[!is.na(v)]
    if (!length(v)) return(FALSE)
    nu <- length(unique(as.character(v)))
    if (nu < 2L) return(FALSE)
    if (is.numeric(v) || is.integer(v)) {
      return(nu <= max(30L, floor(0.2 * length(v))))
    }
    TRUE
  }, logical(1))
  cols[keep]
}

cellchat_beta_default_group <- function(cols) {
  p <- c("seurat_clusters", "celltype", "orig.ident", "sample", "condition", "batch")
  h <- intersect(p, cols)
  if (length(h)) h[[1]] else if (length(cols)) cols[[1]] else ""
}

cellchat_beta_assays <- function(sobj) {
  aa <- tryCatch(names(sobj@assays), error = function(e) character(0))
  aa[nzchar(aa)]
}

cellchat_beta_default_assay <- function(sobj) {
  aa <- cellchat_beta_assays(sobj)
  if (!length(aa)) return("")
  if ("RNA" %in% aa) return("RNA")
  da <- tryCatch(Seurat::DefaultAssay(sobj), error = function(e) "")
  if (nzchar(da) && da %in% aa) return(da)
  aa[[1]]
}

cellchat_beta_pathway_choices <- function(dat) {
  x <- as.character(dat$available_pathways %||% character(0))
  x <- x[nzchar(x)]
  unique(x)
}

.cellchat_df_from_matrix <- function(mat) {
  df <- as.data.frame(as.table(mat), stringsAsFactors = FALSE)
  colnames(df) <- c("sender", "receiver", "score")
  df$score <- as.numeric(df$score)
  df <- df[is.finite(df$score) & df$score > 0, , drop = FALSE]
  df[order(df$score, decreasing = TRUE), , drop = FALSE]
}

.cellchat_normalize_pair_df <- function(df) {
  if (is.null(df) || !nrow(df)) return(data.frame(sender = character(0), receiver = character(0), score = numeric(0), stringsAsFactors = FALSE))
  nms <- colnames(df)
  sender_col <- if ("source" %in% nms) "source" else if ("sender" %in% nms) "sender" else nms[[1]]
  receiver_col <- if ("target" %in% nms) "target" else if ("receiver" %in% nms) "receiver" else nms[[2]]
  score_col <- if ("prob" %in% nms) "prob" else if ("score" %in% nms) "score" else nms[[3]]
  out <- data.frame(
    sender = as.character(df[[sender_col]]),
    receiver = as.character(df[[receiver_col]]),
    score = suppressWarnings(as.numeric(df[[score_col]])),
    pathway_name = if ("pathway_name" %in% nms) as.character(df$pathway_name) else "",
    interaction_name = if ("interaction_name" %in% nms) as.character(df$interaction_name) else "",
    pval = if ("pval" %in% nms) suppressWarnings(as.numeric(df$pval)) else NA_real_,
    stringsAsFactors = FALSE
  )
  out <- out[is.finite(out$score) & out$score > 0, , drop = FALSE]
  out[order(out$score, decreasing = TRUE), , drop = FALSE]
}

.cellchat_pick_db <- function(species = "human") {
  sp <- tolower(trimws(species %||% "human"))
  if (sp %in% c("mouse", "mm", "mm10")) return(CellChat::CellChatDB.mouse)
  if (sp %in% c("zebrafish", "danio")) return(CellChat::CellChatDB.zebrafish)
  CellChat::CellChatDB.human
}

.cellchat_species_label <- function(species = "human") {
  sp <- tolower(trimws(species %||% "human"))
  if (sp %in% c("mouse", "mm", "mm10")) return("Mouse")
  if (sp %in% c("zebrafish", "danio")) return("Zebrafish")
  "Human"
}

.cellchat_normalize_group_labels <- function(groups) {
  x <- as.character(groups %||% character(0))
  if (!length(x)) {
    return(list(groups = x, decode = setNames(character(0), character(0))))
  }

  decode <- setNames(character(0), character(0))
  if ("0" %in% x) {
    repl <- "cluster_0"
    while (repl %in% x) repl <- paste0(repl, "_safe")
    x[x == "0"] <- repl
    decode[repl] <- "0"
  }

  list(groups = x, decode = decode)
}

.cellchat_decode_group_labels <- function(x, decode) {
  out <- as.character(x %||% character(0))
  if (!length(out) || !length(decode)) return(out)
  for (safe_lbl in names(decode)) out[out == safe_lbl] <- decode[[safe_lbl]]
  out
}

.cellchat_humanize_error <- function(err, species = "human", assay = "", group_col = "") {
  msg <- tryCatch(conditionMessage(err), error = function(e) as.character(err))
  msg <- as.character(msg %||% "")
  msg <- trimws(msg)
  if (!nzchar(msg)) msg <- "Unknown CellChat error."
  low <- tolower(msg)

  species_lbl <- .cellchat_species_label(species)
  assay_lbl <- as.character(assay %||% "")
  group_lbl <- as.character(group_col %||% "")
  if (!nzchar(assay_lbl)) assay_lbl <- "(unknown)"
  if (!nzchar(group_lbl)) group_lbl <- "(unknown)"
  context <- sprintf("Context: species=%s, assay=%s, group column=%s.", species_lbl, assay_lbl, group_lbl)

  if (grepl("object@data\\.signaling|subsetdata", low, perl = TRUE)) {
    return(paste(
      "CellChat failed while building the signaling-gene matrix (`subsetData`).",
      "Most likely the selected Species does not match the gene symbols in this object.",
      "How to fix:",
      "1) Match species to gene symbol convention (Human: uppercase symbols like EPCAM/PTPRC; Mouse: title-case symbols like Epcam/Ptprc).",
      "2) Use assay `RNA` for CellChat inference (avoid corrected/integrated assay as primary input).",
      "3) Re-run Step 1 after changing Species/assay.",
      context,
      paste("Original CellChat error:", msg),
      sep = "\n"
    ))
  }

  if (grepl("presto|wilcoxon|do\\.fast", low, perl = TRUE)) {
    return(paste(
      "CellChat Wilcoxon marker step failed.",
      "The app will prefer presto for speed when available, but can run standard Wilcoxon mode.",
      "Please verify CellChat + presto installation state in the project-managed library and retry Step 1.",
      context,
      paste("Original CellChat error:", msg),
      sep = "\n"
    ))
  }

  paste(
    "CellChat inference failed.",
    context,
    paste("Original CellChat error:", msg),
    sep = "\n"
  )
}

.cellchat_identify_overexpressed_genes <- function(cc) {
  has_presto <- isTRUE(requireNamespace("presto", quietly = TRUE))
  fast_mode <- if (has_presto) "fast-presto" else "standard-wilcox"

  .run_with_mode <- function(do_fast) {
    tryCatch(
      CellChat::identifyOverExpressedGenes(cc, do.fast = isTRUE(do_fast)),
      error = function(e) e
    )
  }

  out <- .run_with_mode(has_presto)
  if (!inherits(out, "error")) return(list(cc = out, wilcox_mode = fast_mode))

  msg <- conditionMessage(out)

  # Some CellChat versions do not expose the do.fast argument.
  if (grepl("unused argument.*do\\.fast", msg, ignore.case = TRUE)) {
    out2 <- CellChat::identifyOverExpressedGenes(cc)
    return(list(cc = out2, wilcox_mode = fast_mode))
  }

  # Explicit fallback path when presto is absent / fast Wilcoxon cannot run.
  if (grepl("presto|wilcoxon|do\\.fast", msg, ignore.case = TRUE)) {
    out2 <- .run_with_mode(FALSE)
    if (inherits(out2, "error")) {
      out2 <- tryCatch(CellChat::identifyOverExpressedGenes(cc), error = function(e) e)
    }
    if (inherits(out2, "error")) stop(conditionMessage(out2))
    return(list(cc = out2, wilcox_mode = "standard-wilcox"))
  }

  stop(conditionMessage(out))
}

.cellchat_extract_pathway_matrix <- function(cc, selected_pathway = "") {
  p_arr <- tryCatch(cc@netP$prob, error = function(e) NULL)
  if (is.null(p_arr) || length(dim(p_arr)) != 3L) {
    m <- tryCatch(cc@net$weight, error = function(e) NULL)
    if (is.null(m) || !is.matrix(m)) {
      m <- matrix(0, nrow = 1, ncol = 1, dimnames = list("Unknown", "Unknown"))
    }
    return(list(pathway_matrix = m, selected_pathway = ""))
  }
  pw <- dimnames(p_arr)[[3]] %||% character(0)
  pw <- as.character(pw)
  pw <- pw[nzchar(pw)]
  sel <- as.character(selected_pathway %||% "")
  if (!nzchar(sel) || !(sel %in% pw)) sel <- pw[[1]] %||% ""
  if (!nzchar(sel)) {
    m <- tryCatch(cc@net$weight, error = function(e) NULL)
    if (is.null(m) || !is.matrix(m)) m <- matrix(0, nrow = dim(p_arr)[1], ncol = dim(p_arr)[2], dimnames = dimnames(p_arr)[1:2])
    return(list(pathway_matrix = m, selected_pathway = ""))
  }
  m <- p_arr[, , sel, drop = TRUE]
  if (!is.matrix(m)) {
    m <- matrix(m, nrow = dim(p_arr)[1], ncol = dim(p_arr)[2], dimnames = dimnames(p_arr)[1:2])
  }
  list(pathway_matrix = m, selected_pathway = sel)
}

cellchat_beta_run <- function(
  sobj,
  group_col,
  species = "human",
  assay = NULL,
  top_lr = 30L,
  pval_thresh = 0.05,
  min_cells = 10L,
  nboot = 100L,
  raw_use = TRUE,
  population_size = FALSE,
  pathway_label = ""
) {
  if (!requireNamespace("CellChat", quietly = TRUE)) {
    stop("Package 'CellChat' is not available in the active environment.")
  }
  if (!inherits(sobj, "Seurat")) stop("Input object must be a Seurat object.")
  md <- tryCatch(sobj@meta.data, error = function(e) NULL)
  if (is.null(md) || !(group_col %in% colnames(md))) stop("Group column not found in metadata.")

  groups <- as.character(md[[group_col]])
  groups[is.na(groups) | !nzchar(groups)] <- "Unknown"
  if (length(unique(groups)) > 80L) {
    stop("Selected group column has too many unique values (>80). Choose a categorical metadata column.")
  }
  label_norm <- .cellchat_normalize_group_labels(groups)
  groups_for_cellchat <- label_norm$groups
  decode_labels <- label_norm$decode

  assays <- cellchat_beta_assays(sobj)
  assay_use <- as.character(assay %||% "")
  if (!nzchar(assay_use) || !(assay_use %in% assays)) assay_use <- cellchat_beta_default_assay(sobj)
  if (!nzchar(assay_use)) stop("Could not determine an assay for CellChat.")

  obj <- sobj
  Seurat::DefaultAssay(obj) <- assay_use

  # Integrated assay often contains corrected values that are not suitable for CellChat.
  if (identical(tolower(assay_use), "integrated") && ("RNA" %in% assays)) {
    assay_use <- "RNA"
    Seurat::DefaultAssay(obj) <- assay_use
  }

  obj[[group_col]] <- groups_for_cellchat

  .run_cellchat <- function(expr) {
    tryCatch(
      expr,
      error = function(e) {
        stop(.cellchat_humanize_error(e, species = species, assay = assay_use, group_col = group_col), call. = FALSE)
      }
    )
  }

  cc <- .run_cellchat(CellChat::createCellChat(object = obj, group.by = group_col, assay = assay_use))
  cc@DB <- .cellchat_pick_db(species)

  cc <- .run_cellchat(CellChat::subsetData(cc))
  idg <- .run_cellchat(.cellchat_identify_overexpressed_genes(cc))
  cc <- idg$cc
  cc <- .run_cellchat(CellChat::identifyOverExpressedInteractions(cc))
  cc <- .run_cellchat(CellChat::computeCommunProb(
    cc,
    raw.use = isTRUE(raw_use),
    population.size = isTRUE(population_size),
    nboot = max(10L, as.integer(nboot %||% 100L)),
    seed.use = 1L
  ))
  cc <- .run_cellchat(CellChat::filterCommunication(cc, min.cells = max(1L, as.integer(min_cells %||% 10L))))
  cc <- .run_cellchat(CellChat::computeCommunProbPathway(cc, thresh = as.numeric(pval_thresh %||% 0.05)))
  cc <- .run_cellchat(CellChat::aggregateNet(cc, thresh = as.numeric(pval_thresh %||% 0.05)))
  cc <- .run_cellchat(CellChat::netAnalysis_computeCentrality(cc, slot.name = "netP", thresh = as.numeric(pval_thresh %||% 0.05)))

  interaction <- tryCatch(cc@net$weight, error = function(e) NULL)
  if (is.null(interaction) || !is.matrix(interaction)) {
    interaction <- tryCatch(cc@net$count, error = function(e) NULL)
  }
  if (is.null(interaction) || !is.matrix(interaction)) {
    gtab <- sort(table(groups_for_cellchat), decreasing = TRUE)
    p <- as.numeric(gtab) / sum(gtab)
    interaction <- outer(p, p)
    rownames(interaction) <- names(gtab)
    colnames(interaction) <- names(gtab)
  }
  rownames(interaction) <- .cellchat_decode_group_labels(rownames(interaction), decode_labels)
  colnames(interaction) <- .cellchat_decode_group_labels(colnames(interaction), decode_labels)

  df_lr_raw <- tryCatch(CellChat::subsetCommunication(cc, slot.name = "net", thresh = as.numeric(pval_thresh %||% 0.05)), error = function(e) data.frame())
  df_path_raw <- tryCatch(CellChat::subsetCommunication(cc, slot.name = "netP", thresh = as.numeric(pval_thresh %||% 0.05)), error = function(e) data.frame())

  pair_df_all <- .cellchat_normalize_pair_df(df_lr_raw)
  if (nrow(pair_df_all)) {
    pair_df_all$sender <- .cellchat_decode_group_labels(pair_df_all$sender, decode_labels)
    pair_df_all$receiver <- .cellchat_decode_group_labels(pair_df_all$receiver, decode_labels)
  }
  pathway_df <- if (nrow(df_path_raw)) {
    agg <- stats::aggregate(prob ~ pathway_name, data = data.frame(pathway_name = as.character(df_path_raw$pathway_name), prob = as.numeric(df_path_raw$prob)), FUN = sum, na.rm = TRUE)
    colnames(agg) <- c("name", "score")
    agg <- agg[is.finite(agg$score), , drop = FALSE]
    agg[order(agg$score, decreasing = TRUE), , drop = FALSE]
  } else {
    data.frame(name = character(0), score = numeric(0), stringsAsFactors = FALSE)
  }

  available_pathways <- unique(c(as.character(pathway_df$name), as.character(pair_df_all$pathway_name)))
  available_pathways <- available_pathways[nzchar(available_pathways)]

  pw <- .cellchat_extract_pathway_matrix(cc, pathway_label)
  pathway_matrix <- pw$pathway_matrix
  rownames(pathway_matrix) <- .cellchat_decode_group_labels(rownames(pathway_matrix), decode_labels)
  colnames(pathway_matrix) <- .cellchat_decode_group_labels(colnames(pathway_matrix), decode_labels)
  selected_pathway <- pw$selected_pathway

  sender_score <- data.frame(group = rownames(interaction), score = rowSums(interaction, na.rm = TRUE), stringsAsFactors = FALSE)
  receiver_score <- data.frame(group = colnames(interaction), score = colSums(interaction, na.rm = TRUE), stringsAsFactors = FALSE)

  centr <- tryCatch(cc@netP$centr[[selected_pathway]], error = function(e) NULL)
  if (is.list(centr) && all(c("outdeg", "indeg") %in% names(centr))) {
    sender_score <- data.frame(
      group = .cellchat_decode_group_labels(names(centr$outdeg), decode_labels),
      score = as.numeric(centr$outdeg),
      stringsAsFactors = FALSE
    )
    receiver_score <- data.frame(
      group = .cellchat_decode_group_labels(names(centr$indeg), decode_labels),
      score = as.numeric(centr$indeg),
      stringsAsFactors = FALSE
    )
  }

  if (nzchar(selected_pathway) && nrow(pair_df_all)) {
    pair_df <- pair_df_all[pair_df_all$pathway_name %in% selected_pathway, , drop = FALSE]
    if (!nrow(pair_df)) pair_df <- pair_df_all
  } else {
    pair_df <- pair_df_all
  }

  if (!nrow(pair_df)) pair_df <- .cellchat_df_from_matrix(interaction)
  pair_df <- utils::head(pair_df[order(pair_df$score, decreasing = TRUE), , drop = FALSE], max(1L, as.integer(top_lr %||% 30L)))

  list(
    cellchat_obj = cc,
    group_label_decode = decode_labels,
    assay = assay_use,
    group_col = group_col,
    species = species,
    wilcox_mode = idg$wilcox_mode %||% "",
    groups = rownames(interaction),
    interaction = interaction,
    pathway_matrix = pathway_matrix,
    selected_pathway = selected_pathway,
    available_pathways = available_pathways,
    sender_score = sender_score,
    receiver_score = receiver_score,
    pair_df = pair_df,
    pair_df_all = pair_df_all,
    pathway_df = pathway_df
  )
}

cellchat_beta_select_outputs <- function(dat, pathway_label = "", top_lr = 30L) {
  if (is.null(dat) || !is.list(dat)) stop("CellChat data object is missing.")
  out <- dat

  sel <- as.character(pathway_label %||% "")
  all_pw <- cellchat_beta_pathway_choices(out)
  if (nzchar(sel) && !(sel %in% all_pw)) sel <- ""

  if (!is.null(out$cellchat_obj) && nzchar(sel)) {
    pw <- .cellchat_extract_pathway_matrix(out$cellchat_obj, sel)
    out$pathway_matrix <- pw$pathway_matrix
    decode_labels <- out$group_label_decode %||% setNames(character(0), character(0))
    rownames(out$pathway_matrix) <- .cellchat_decode_group_labels(rownames(out$pathway_matrix), decode_labels)
    colnames(out$pathway_matrix) <- .cellchat_decode_group_labels(colnames(out$pathway_matrix), decode_labels)
    out$selected_pathway <- pw$selected_pathway
  }

  pair_df <- out$pair_df_all %||% out$pair_df %||% data.frame()
  if (nrow(pair_df) && nzchar(sel) && ("pathway_name" %in% colnames(pair_df))) {
    pair_sub <- pair_df[pair_df$pathway_name %in% sel, , drop = FALSE]
    if (nrow(pair_sub)) pair_df <- pair_sub
  }
  if (!nrow(pair_df) && is.matrix(out$interaction)) pair_df <- .cellchat_df_from_matrix(out$interaction)
  out$pair_df <- utils::head(pair_df[order(pair_df$score, decreasing = TRUE), , drop = FALSE], max(1L, as.integer(top_lr %||% 30L)))

  out
}

# Backward-compatible alias retained for existing interface calls.
cellchat_beta_preview <- function(sobj, group_col, species = "human", assay = NULL, top_lr = 30L, pval_thresh = 0.05, min_cells = 10L, nboot = 100L, raw_use = TRUE, population_size = FALSE, pathway_label = "") {
  cellchat_beta_run(
    sobj = sobj,
    group_col = group_col,
    species = species,
    assay = assay,
    top_lr = top_lr,
    pval_thresh = pval_thresh,
    min_cells = min_cells,
    nboot = nboot,
    raw_use = raw_use,
    population_size = population_size,
    pathway_label = pathway_label
  )
}
