`%||%` <- get0("%||%", mode = "function", inherits = TRUE, ifnotfound = function(a, b) if (is.null(a)) b else a)

analysis_selector_chr_values <- function(x) {
  vals <- as.character(x %||% character(0))
  vals <- vals[!is.na(vals) & nzchar(vals)]
  vals
}

analysis_registry_object_names <- function(registry) {
  analysis_selector_chr_values(names(registry %||% list()))
}

analysis_selector_entry_object <- function(entry) {
  if (is.list(entry) && !is.null(entry$obj)) return(entry$obj)
  entry
}

analysis_selector_entry_stage <- function(entry) {
  stage_raw <- tryCatch(entry$meta$stage, error = function(e) NULL)
  stage_chr <- as.character(stage_raw %||% character(0))
  stage_chr <- stage_chr[!is.na(stage_chr) & nzchar(stage_chr)]
  if (!length(stage_chr)) return("")
  tolower(stage_chr[[1]])
}

analysis_selector_assay_names <- function(entry) {
  obj <- analysis_selector_entry_object(entry)
  if (is.null(obj)) return(character(0))

  if (is.list(obj) && !is.null(obj$assays)) {
    raw_assays <- obj$assays
    assay_names <- if (is.list(raw_assays)) {
      named <- names(raw_assays) %||% character(0)
      named <- named[nzchar(named)]
      if (length(named)) named else unlist(raw_assays, use.names = FALSE)
    } else {
      raw_assays
    }
    assay_names <- as.character(assay_names %||% character(0))
    assay_names <- assay_names[!is.na(assay_names) & nzchar(assay_names)]
    if (length(assay_names)) return(unique(assay_names))
  }

  assay_names <- tryCatch(Seurat::Assays(obj), error = function(e) character(0))
  assay_names <- as.character(assay_names %||% character(0))
  assay_names <- assay_names[!is.na(assay_names) & nzchar(assay_names)]
  unique(assay_names)
}

analysis_selector_name_looks_integrated <- function(x) {
  txt <- tolower(as.character(x %||% ""))
  txt <- txt[!is.na(txt) & nzchar(txt)]
  if (!length(txt)) return(FALSE)
  any(startsWith(txt, "integrated"))
}

analysis_object_is_integrated <- function(name, entry) {
  stage_now <- analysis_selector_entry_stage(entry)
  if (identical(stage_now, "recluster_subset")) {
    return(FALSE)
  }
  parents <- analysis_selector_chr_values(tryCatch(entry$meta$parents, error = function(e) character(0)))
  # Legacy subset entries inherited stage=integrated from an integrated parent.
  # Treat single-parent, non-integrated_* names as reintegration sources.
  if (identical(stage_now, "integrated") &&
      !analysis_selector_name_looks_integrated(name) &&
      length(parents) == 1L) {
    return(FALSE)
  }
  assay_names <- analysis_selector_assay_names(entry)
  has_integrated_assay <- any(vapply(
    assay_names,
    analysis_selector_name_looks_integrated,
    logical(1)
  ))
  has_stage_fallback <- identical(stage_now, "integrated")
  has_name_fallback <- analysis_selector_name_looks_integrated(name)
  isTRUE(has_integrated_assay || has_stage_fallback || has_name_fallback)
}

analysis_integrated_object_names <- function(registry) {
  if (is.null(registry) || !length(registry)) return(character(0))
  registry_names <- analysis_registry_object_names(registry)
  keep <- vapply(
    registry_names,
    function(nm) analysis_object_is_integrated(nm, registry[[nm]]),
    logical(1)
  )
  registry_names[keep]
}

analysis_nonintegrated_object_names <- function(registry) {
  registry_names <- analysis_registry_object_names(registry)
  integrated_names <- analysis_integrated_object_names(registry)
  registry_names[!(registry_names %in% integrated_names)]
}

analysis_selector_mode_for_registry <- function(registry, reintegration_enabled = FALSE) {
  if (length(analysis_integrated_object_names(registry)) && isTRUE(reintegration_enabled)) return("reintegrate")
  if (length(analysis_integrated_object_names(registry))) return("replace")
  "multi"
}

analysis_selector_choices_for_mode <- function(registry, mode = NULL, reintegration_enabled = FALSE) {
  mode_vals <- analysis_selector_chr_values(mode)
  mode_now <- if (length(mode_vals)) mode_vals[[1]] else ""
  if (!nzchar(mode_now)) {
    mode_now <- analysis_selector_mode_for_registry(registry, reintegration_enabled = reintegration_enabled)
  }
  if (identical(mode_now, "reintegrate")) return(analysis_registry_object_names(registry))
  analysis_registry_object_names(registry)
}

analysis_preferred_integrated_name <- function(registry, active_name = "") {
  integrated_names <- analysis_integrated_object_names(registry)
  if (!length(integrated_names)) return("")
  active_chr <- analysis_selector_chr_values(active_name)
  if (length(active_chr) && active_chr[[1]] %in% integrated_names) {
    return(active_chr[[1]])
  }
  integrated_names[[1]]
}

analysis_preferred_loaded_object_name <- function(registry, focus_name = "", imported_active_name = "") {
  registry_names <- analysis_registry_object_names(registry)
  if (!length(registry_names)) return("")

  focus_chr <- analysis_selector_chr_values(focus_name)
  focus_chr <- if (length(focus_chr) && focus_chr[[1]] %in% registry_names) focus_chr[[1]] else ""

  imported_chr <- analysis_selector_chr_values(imported_active_name)
  imported_chr <- if (length(imported_chr) && imported_chr[[1]] %in% registry_names) imported_chr[[1]] else ""

  # Agent note: Loading must preserve an explicit user object choice across
  # pages. Without one, registry insertion order defines the newest object.
  # Do not prioritize integrated objects here; it overrides valid user intent.
  if (nzchar(focus_chr)) return(focus_chr)
  if (nzchar(imported_chr)) return(imported_chr)

  registry_names[[length(registry_names)]]
}

analysis_bootstrap_selection <- function(registry, active_name = "", current_selection = character(0), reintegration_enabled = FALSE) {
  mode_now <- analysis_selector_mode_for_registry(
    registry,
    reintegration_enabled = reintegration_enabled
  )
  choices <- analysis_selector_choices_for_mode(registry, mode = mode_now)
  active_chr <- analysis_selector_chr_values(active_name)
  active_chr <- if (length(active_chr) && active_chr[[1]] %in% analysis_registry_object_names(registry)) active_chr[[1]] else ""
  selected_chr <- intersect(analysis_selector_chr_values(current_selection), choices)

  if (identical(mode_now, "replace")) {
    target_active <- analysis_preferred_integrated_name(registry, active_name = active_chr)
    if (!nzchar(target_active) && nzchar(active_chr) && active_chr %in% choices) target_active <- active_chr
    if (!nzchar(target_active) && length(choices)) target_active <- choices[[1]]
    return(list(
      mode = mode_now,
      choices = choices,
      selection = if (nzchar(target_active)) target_active else character(0),
      active_name = target_active
    ))
  }

  if (identical(mode_now, "reintegrate")) {
    if (!length(selected_chr) && nzchar(active_chr) && active_chr %in% choices) {
      selected_chr <- active_chr
    }
    return(list(
      mode = mode_now,
      choices = choices,
      selection = selected_chr,
      active_name = active_chr
    ))
  }

  if (!length(selected_chr)) {
    if (nzchar(active_chr) && active_chr %in% choices) {
      selected_chr <- active_chr
    } else if (length(choices)) {
      selected_chr <- choices[[1]]
    }
  }

  target_active <- active_chr
  if (!nzchar(target_active) || !target_active %in% choices) {
    target_active <- if (length(selected_chr)) selected_chr[[1]] else ""
  }
  list(
    mode = mode_now,
    choices = choices,
    selection = selected_chr,
    active_name = target_active
  )
}
