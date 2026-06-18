# R/page_environment.R
ENV_UI_TEXT <- list(
  # Hero block
  ui_title_main = "Select and Prepare Analysis Environment",
  ui_text_main_description = "Primary setup runs in run.R (isolated Seurat v4/v5 libraries). Use this page for manual recovery and version switching.",

  # Hidden selector options
  ui_choice_env_seurat4 = "Seurat v4 (High compatibility and frequently tested)",
  ui_choice_env_seurat5 = "Seurat v5 (Beta)",
  ui_choice_env_scanpy = "Scanpy (Python Env Required - developing)",

  # Next-step block
  ui_label_environment_ready = " Environment Ready",
  ui_text_next_step_hint = "Choose your next step based on your data source.",
  ui_btn_import_data = "Import New Data",
  ui_btn_import_workspace = "Import Previous Workspace",

  # Environment selection block
  ui_label_environment_selection = " Environment Selection",
  ui_text_environment_selection_hint = "Pick a backend below. Each environment is isolated and version-pinned.",
  ui_label_status = "Status:",
  ui_btn_prepare_environment = "Prepare Environment",

  # Environment cards
  ui_card_title_seurat4 = "Seurat v4",
  ui_card_subtitle_seurat4 = "Highest compatibility",
  ui_card_point_seurat4_1 = "Compatible with pre-existing code templates",
  ui_card_point_seurat4_2 = "Stability has been frequently tested",
  ui_card_point_seurat4_3 = "Takes slightly longer computation time",

  ui_card_title_seurat5 = "Seurat v5",
  ui_card_subtitle_seurat5 = "Better multiomic support",
  ui_card_point_seurat5_1 = "Best support for scATAC, CITE-seq, etc.",
  ui_card_point_seurat5_2 = "No backward support for Seurat v4.",
  ui_card_point_seurat5_3 = "Beta support: verify outputs before production decisions",

  ui_card_title_scanpy = "Scanpy",
  ui_card_subtitle_scanpy = "Python backend (developing)",
  ui_card_point_scanpy_1 = "Extremely fast with Python multicore support",
  ui_card_point_scanpy_2 = "Compatibility not fully tested",
  ui_card_point_scanpy_3 = "Currently disabled",

  # Log block
  ui_label_preparation_log = " Preparation Log",
  ui_text_preparation_log_hint = "Compact runtime output for diagnostics.",
  ui_text_log_prepare_start = "Please start checking environment on the right. This may take several minutes...",
  ui_text_log_python_ready_prefix = "\nSUCCESS: Python environment '",
  ui_text_log_python_ready_suffix = "' is ready.\n",

  # Status text
  ui_text_status_none = "No environment is active.",
  ui_text_status_active_suffix = "is active now.",

  # Modal block
  ui_modal_title_switch_environment = "Switch Environment?",
  ui_modal_label_warning = "Warning:",
  ui_modal_text_switch_with_existing_state = "You are switching environment after analysis data/state already exists.",
  ui_modal_text_risk_details = "This can invalidate loaded objects and may crash downstream modules or produce inconsistent results.",
  ui_modal_text_save_hint = "Tip: save workspace first, then switch environment.",
  ui_btn_cancel = "Cancel",
  ui_btn_switch_anyway = "Switch Anyway",

  # Error/log labels
  ui_text_error_title = "A critical error occurred at:",
  ui_text_error_details_header = "\n\nERROR DETAILS:\n",
  ui_text_error_notification = "An error occurred. See log for details."
)

library(here)

options(repos = c(CRAN = "https://packagemanager.posit.co/cran/latest"))

.env_base_namespaces <- function() {
  c(
    "base", "compiler", "datasets", "graphics", "grDevices",
    "grid", "methods", "stats", "tools", "utils"
  )
}

.env_namespace_importers <- function(target, namespaces = loadedNamespaces(), imports_resolver = NULL) {
  if (is.null(target)) target <- ""
  target <- as.character(target)
  if (!nzchar(target)) return(character(0))

  if (is.null(imports_resolver)) {
    imports_resolver <- function(nm) {
      tryCatch(names(getNamespaceImports(nm)), error = function(e) character(0))
    }
  }

  pool <- setdiff(unique(as.character(namespaces)), c(.env_base_namespaces(), target))
  sort(unique(pool[vapply(pool, function(nm) target %in% imports_resolver(nm), logical(1))]))
}

.env_collect_namespace_locks <- function(
  targets = c("Seurat", "SeuratObject"),
  namespaces = loadedNamespaces(),
  imports_resolver = NULL
) {
  active_targets <- intersect(unique(as.character(targets)), unique(as.character(namespaces)))
  out <- stats::setNames(vector("list", length(active_targets)), active_targets)
  for (target in active_targets) {
    out[[target]] <- .env_namespace_importers(
      target = target,
      namespaces = namespaces,
      imports_resolver = imports_resolver
    )
  }
  out
}

.env_namespace_lock_message <- function(blocking, blockers = NULL) {
  blocking <- unique(as.character(blocking))
  blocking <- blocking[nzchar(blocking)]
  if (!length(blocking)) return("")

  if (is.null(blockers)) {
    blockers <- .env_collect_namespace_locks(targets = blocking)
  }
  detail_lines <- vapply(blocking, function(pkg) {
    importers <- blockers[[pkg]]
    if (is.null(importers)) importers <- character(0)
    if (length(importers)) {
      paste0(pkg, " imported by: ", paste(importers, collapse = ", "), ".")
    } else {
      paste0(
        pkg,
        " has no remaining importer namespace; a live object, registered method, or stale session state is still holding it. ",
        "Please restart the R session before switching environments."
      )
    }
  }, character(1))

  paste0(
    "Could not unload package namespace(s) before environment switch: ",
    paste(blocking, collapse = ", "),
    ". ",
    paste(detail_lines, collapse = " ")
  )
}

.env_unload_pkg <- function(pkg) {
  if (paste0("package:", pkg) %in% search()) {
    try(detach(paste0("package:", pkg), unload = TRUE, character.only = TRUE), silent = TRUE)
  }
  if (pkg %in% loadedNamespaces()) {
    try(unloadNamespace(pkg), silent = TRUE)
  }
  !(pkg %in% loadedNamespaces())
}

.env_unload_importers_of <- function(target, max_pass = 8L) {
  for (i in seq_len(max(1L, as.integer(max_pass)))) {
    importers <- .env_namespace_importers(target)
    if (!length(importers)) break
    for (pkg in rev(importers)) .env_unload_pkg(pkg)
    .env_unload_pkg(target)
    if (!(target %in% loadedNamespaces())) break
  }
  invisible(!(target %in% loadedNamespaces()))
}

.env_unload_seurat_stack <- function(max_pass = 8L) {
  for (i in seq_len(max(1L, as.integer(max_pass)))) {
    blocking_before <- intersect(c("Seurat", "SeuratObject"), loadedNamespaces())
    if (!length(blocking_before)) break

    .env_unload_pkg("scRNAtoolVis")
    .env_unload_importers_of("Seurat", max_pass = 1L)
    .env_unload_importers_of("SeuratObject", max_pass = 1L)
    .env_unload_pkg("Seurat")
    .env_unload_pkg("SeuratObject")
    .env_unload_pkg("scRNAtoolVis")

    blocking_after <- intersect(c("Seurat", "SeuratObject"), loadedNamespaces())
    if (!length(blocking_after) || identical(blocking_after, blocking_before)) break
  }
  invisible(gc())
}

environment_ui <- fluidPage(
  div(
    class = "env-page-wrap",

    div(
      class = "card env-hero-card",
      h2(icon("sliders"), " ", ENV_UI_TEXT$ui_title_main),
      p(
        class = "env-hero-note",
        ENV_UI_TEXT$ui_text_main_description
      )
    ),

    # hidden radio (keeps existing server logic simple)
    div(style = "display:none;",
        radioButtons(
          "env_choice",
          NULL,
          choices = setNames(
            c("seurat4", "seurat5", "scanpy"),
            c(
              ENV_UI_TEXT$ui_choice_env_seurat4,
              ENV_UI_TEXT$ui_choice_env_seurat5,
              ENV_UI_TEXT$ui_choice_env_scanpy
            )
          ),
          selected = "seurat4"
        )
    ),

    shinyjs::hidden(
      div(
        id = "proceed_to_import_ui",
        class = "card env-next-card focus_card_style",
        div(class = "env-card-title", icon("circle-check"), ENV_UI_TEXT$ui_label_environment_ready),
        p(class = "env-card-subtitle", ENV_UI_TEXT$ui_text_next_step_hint),
        div(
          class = "env-next-actions",
          actionButton(
            "proceed_to_import_btn",
            ENV_UI_TEXT$ui_btn_import_data,
            class = "btn-info btn-md",
            icon = icon("plus")
          ),
          actionButton(
            "proceed_to_rds_btn",
            ENV_UI_TEXT$ui_btn_import_workspace,
            class = "btn-success btn-md",
            icon = icon("file-import")
          )
        )
      )
    ),


    div(class = "card env-select-card",
      div(class = "env-card-title", icon("sliders"), ENV_UI_TEXT$ui_label_environment_selection, wl_beta_badge(with_icon = TRUE)),
      p(class = "env-card-subtitle", ENV_UI_TEXT$ui_text_environment_selection_hint),
      uiOutput("env_cards_ui"),
      div(class = "env-status-inline", strong(ENV_UI_TEXT$ui_label_status), " ", textOutput("env_status", inline = TRUE)),
      div(class = "env-primary-action",
        actionButton(
          "prepare_env_btn",
          ENV_UI_TEXT$ui_btn_prepare_environment,
          icon = icon("cogs"),
          class = "btn-primary btn-md"
        )
      )
    ),

    div(
      class = "card env-log-card",
      div(class = "env-card-title", icon("clipboard-list"), ENV_UI_TEXT$ui_label_preparation_log),
      p(class = "env-card-subtitle", ENV_UI_TEXT$ui_text_preparation_log_hint),
      tags$pre(
        id = "env_log",
        class = "env-log-pre",
        verbatimTextOutput("env_log_output")
      )
    )
  )
)

environment_server <- function(input, output, session, shared_data) {

  .env_logo <- function(src, fallback_icon, alt) {
    local_path <- file.path("www", src)
    if (file.exists(local_path)) {
      tags$img(src = src, class = "env-choice-logo", alt = alt)
    } else {
      div(class = "env-choice-logo-fallback", icon(fallback_icon))
    }
  }

  output$env_cards_ui <- renderUI({
    seurat5_enabled <- TRUE
    selected <- if (is.null(input$env_choice)) "seurat4" else input$env_choice

    card <- function(id, title, subtitle, points, logo_tag, disabled = FALSE) {
      classes <- c("env-choice-card")
      if (identical(selected, id)) classes <- c(classes, "active")
      if (disabled) classes <- c(classes, "disabled")

      click_js <- if (!disabled) sprintf("Shiny.setInputValue('env_card_click','%s',{priority:'event'})", id) else NULL

      div(
        class = paste(classes, collapse = " "),
        onclick = click_js,
        logo_tag,
        div(class = "env-choice-name", title),
        div(class = "env-choice-sub", subtitle),
        tags$ul(class = "env-choice-list", lapply(points, tags$li))
      )
    }

    div(
      class = "env-choice-grid",
      card(
        "seurat4",
        ENV_UI_TEXT$ui_card_title_seurat4,
        ENV_UI_TEXT$ui_card_subtitle_seurat4,
        c(
          ENV_UI_TEXT$ui_card_point_seurat4_1,
          ENV_UI_TEXT$ui_card_point_seurat4_2,
          ENV_UI_TEXT$ui_card_point_seurat4_3
        ),
        .env_logo("logos/seurat.jpg", "circle-nodes", "Seurat")
      ),
      card(
        "seurat5",
        wl_beta_label(ENV_UI_TEXT$ui_card_title_seurat5, with_icon = TRUE),
        ENV_UI_TEXT$ui_card_subtitle_seurat5,
        c(
          ENV_UI_TEXT$ui_card_point_seurat5_1,
          ENV_UI_TEXT$ui_card_point_seurat5_2,
          ENV_UI_TEXT$ui_card_point_seurat5_3
        ),
        .env_logo("logos/seurat.jpg", "atom", "Seurat"),
        disabled = !isTRUE(seurat5_enabled)
      ),
      card(
        "scanpy",
        ENV_UI_TEXT$ui_card_title_scanpy,
        ENV_UI_TEXT$ui_card_subtitle_scanpy,
        c(
          ENV_UI_TEXT$ui_card_point_scanpy_1,
          ENV_UI_TEXT$ui_card_point_scanpy_2,
          ENV_UI_TEXT$ui_card_point_scanpy_3
        ),
        .env_logo("logos/scanpy.svg", "python", "Scanpy"),
        disabled = TRUE
      )
    )
  })

  observeEvent(input$env_card_click, {
    req(input$env_card_click)
    if (input$env_card_click %in% c("seurat5", "seurat4", "scanpy")) {
      updateRadioButtons(session, "env_choice", selected = input$env_card_click)
    }
  })

  observeEvent(shared_data$active_environment$path, {
    env_path <- shared_data$active_environment$path
    if (!is.null(env_path) && dir.exists(env_path)) {
      message(paste("Active library path set to:", env_path))
    }
  }, ignoreInit = TRUE)

  env_definitions <- list(
    seurat5 = list(
      packages = data.frame(
        package = c("Seurat"),
        version = c("5.0.3")
      ),
      type = "R"
    ),
    seurat4 = list(
      packages = data.frame(
        package = c("SeuratObject", "Seurat", "RANN", "ROCR"),
        version = c("4.1.4", "4.4.0", NA, NA),
        url = c("https://satijalab.r-universe.dev", "https://satijalab.r-universe.dev", NA, NA)
      ),
      type = "R"
    ),
    scanpy = list(
      r_packages = c("reticulate", "anndata"),
      python_packages = c("scanpy", "leidenalg", "pandas"),
      type = "Python"
    )
  )

  log_messages <- reactiveVal("")
  output$env_log_output <- renderText({ log_messages() })
  output$env_status <- renderText({
    env <- shared_data$active_environment
    if (is.null(env$name)) {
      ENV_UI_TEXT$ui_text_status_none
    } else {
      paste(env$name, ENV_UI_TEXT$ui_text_status_active_suffix)
    }
  })

  .has_pipeline_state <- function() {
    has_samples <- !is.null(shared_data$full_sample_sheet) && is.data.frame(shared_data$full_sample_sheet) && nrow(shared_data$full_sample_sheet) > 0
    has_objects <- !is.null(shared_data$all_seurat_objects) && length(shared_data$all_seurat_objects) > 0
    has_active <- !is.null(shared_data$active_object_name) && nzchar(shared_data$active_object_name)
    has_filtered <- !is.null(shared_data$filtered_objects) && length(shared_data$filtered_objects) > 0
    has_qc <- isTRUE(shared_data$qc_completed)
    has_analysis_obj <- tryCatch(!is.null(shared_data$analysis_boot$active_object), error = function(e) FALSE)

    isTRUE(has_samples || has_objects || has_active || has_filtered || has_qc || has_analysis_obj)
  }

  .run_prepare_env <- function(chosen_env_id) {
    shinyjs::hide("proceed_to_import_ui")
    overlay_show("Preparing environment…")
    on.exit(overlay_hide(), add = TRUE)

    env_def <- env_definitions[[chosen_env_id]]
    log_messages(ENV_UI_TEXT$ui_text_log_prepare_start)

    tryCatch({
      if (env_def$type == "R") {
        project_root <- normalizePath(here::here(".."), mustWork = FALSE)
        package_roots <- unique(c(file.path(project_root, "package_libraries")))
        env_dir_name <- switch(chosen_env_id,
                               seurat4 = "seurat_v4",
                               seurat5 = "seurat_v5",
                               chosen_env_id)
        env_candidates <- file.path(package_roots, env_dir_name)
        existing_env_candidates <- env_candidates[dir.exists(env_candidates)]
        if (!length(existing_env_candidates)) {
          stop("Environment not found. Tried: ", paste(env_candidates, collapse = " | "), " . Please run launcher bootstrap first.")
        }
        has_seurat <- vapply(existing_env_candidates, function(p) "Seurat" %in% rownames(installed.packages(lib.loc = p)), logical(1))
        if (!any(has_seurat)) {
          stop("Seurat is not installed in any environment candidate: ", paste(existing_env_candidates, collapse = " | "), " . Please rerun launcher bootstrap.")
        }
        lib_path <- existing_env_candidates[which(has_seurat)[1]]
        active_package_root <- dirname(lib_path)
        preferred_core <- file.path(project_root, "package_libraries", "core")
        core_candidates <- unique(c(preferred_core, file.path(active_package_root, "core"), file.path(package_roots, "core")))
        core_candidates <- core_candidates[dir.exists(core_candidates)]
        core_path <- core_candidates[1] %||% file.path(active_package_root, "core")

        .major <- function(v) {
          x <- as.character(v %||% NA_character_)
          x <- x[!is.na(x) & nzchar(x)]
          if (!length(x)) return(NA_character_)
          sub("^([0-9]+).*$", "\\1", x[[1]])
        }
        .install_version_retry <- function(pkg, version, lib, deps = NA, tries = 3L) {
          if (!requireNamespace("remotes", quietly = TRUE)) {
            install.packages("remotes", repos = "https://cloud.r-project.org", lib = core_path, dependencies = NA)
          }
          last_err <- NULL
          for (attempt in seq_len(max(1L, as.integer(tries)))) {
            ok <- tryCatch({
              remotes::install_version(
                package = pkg,
                version = version,
                lib = lib,
                repos = "https://cloud.r-project.org",
                upgrade = "never",
                dependencies = deps
              )
              TRUE
            }, error = function(e) {
              last_err <<- conditionMessage(e)
              FALSE
            })
            if (isTRUE(ok)) return(invisible(TRUE))
            if (attempt < tries) Sys.sleep(10L * attempt)
          }
          stop("Failed to install ", pkg, "@", version, " after ", tries, " attempt(s): ", last_err %||% "unknown error")
        }
        .pkg_ver_in_lib <- function(pkg, lib) {
          tryCatch(as.character(utils::packageVersion(pkg, lib.loc = lib)), error = function(e) NA_character_)
        }
        .ensure_env_major <- function(pkg, expected_version, lib, deps = NA) {
          expected_major <- .major(expected_version)
          current <- .pkg_ver_in_lib(pkg, lib)
          if (identical(.major(current), expected_major)) return(invisible(TRUE))
          message(
            "Repairing ", pkg, " in ", chosen_env_id,
            ": found ", ifelse(is.na(current), "missing", current),
            ", expected major ", expected_major, " (target ", expected_version, ")."
          )
          .install_version_retry(pkg, expected_version, lib = lib, deps = deps, tries = 3L)
          repaired <- .pkg_ver_in_lib(pkg, lib)
          if (!identical(.major(repaired), expected_major)) {
            stop(
              "Version repair failed for ", pkg, ": expected major ", expected_major,
              " but found ", repaired %||% "NA", " in ", lib
            )
          }
          invisible(TRUE)
        }
        .parse_desc_pkgs <- function(x) {
          x <- as.character(x %||% "")
          if (!nzchar(x)) return(character(0))
          x <- gsub("[\r\n]+", " ", x)
          parts <- trimws(unlist(strsplit(x, ",", fixed = TRUE), use.names = FALSE))
          parts <- gsub("\\(.*?\\)", "", parts)
          parts <- trimws(parts)
          parts[nzchar(parts)]
        }
        .required_ns_from_desc <- function(pkg, lib) {
          desc_path <- file.path(lib, pkg, "DESCRIPTION")
          if (!file.exists(desc_path)) return(character(0))
          d <- tryCatch(read.dcf(desc_path, fields = c("Depends", "Imports", "LinkingTo")), error = function(e) NULL)
          if (is.null(d) || !NROW(d)) return(character(0))
          vals <- as.list(d[1, , drop = FALSE])
          req <- unique(unlist(lapply(vals, .parse_desc_pkgs), use.names = FALSE))
          base_pkgs <- c("R", "base", "compiler", "datasets", "graphics", "grDevices", "grid", "methods", "parallel", "splines", "stats", "tcltk", "tools", "utils")
          setdiff(req, base_pkgs)
        }
        .ensure_desc_runtime_deps <- function(pkg, lib) {
          req <- .required_ns_from_desc(pkg, lib)
          if (!length(req)) return(invisible(TRUE))
          present <- vapply(
            req,
            function(p) isTRUE(tryCatch(requireNamespace(p, quietly = TRUE, lib.loc = c(lib, core_path, keep_paths)), error = function(e) FALSE)),
            logical(1)
          )
          missing <- unique(req[!present])
          if (length(missing)) {
            message("Installing missing runtime dependencies for ", pkg, ": ", paste(missing, collapse = ", "))
            install.packages(missing, repos = "https://cloud.r-project.org", lib = lib, dependencies = NA)
          }
          still_missing <- unique(req[!vapply(
            req,
            function(p) isTRUE(tryCatch(requireNamespace(p, quietly = TRUE, lib.loc = c(lib, core_path, keep_paths)), error = function(e) FALSE)),
            logical(1)
          )])
          if (length(still_missing)) {
            stop("Missing runtime dependency package(s) for ", pkg, ": ", paste(still_missing, collapse = ", "))
          }
          invisible(TRUE)
        }

        # Strictly unload Seurat stack before switching environment.
        .env_unload_seurat_stack()
        if ("Seurat" %in% loadedNamespaces() || "SeuratObject" %in% loadedNamespaces()) {
          blocking <- intersect(c("Seurat", "SeuratObject"), loadedNamespaces())
          stop(.env_namespace_lock_message(blocking))
        }

        # Keep core/system paths, but drop any previously pinned seurat_v4/v5 path.
        original_lib_paths <- .libPaths()
        keep_paths <- original_lib_paths[!grepl("package_libraries(_user)?[/\\\\]seurat_v[45]$", original_lib_paths)]
        # Selected env must be first so Seurat/SeuratObject resolve from the chosen
        # isolated environment before core/system fallback.
        .libPaths(unique(c(lib_path, core_path, keep_paths)))

        # Runtime guard: SeuratObject depends on sp/spam. Ensure they are available
        # for the selected environment before loading Seurat.
        runtime_missing <- c("sp", "spam")[!vapply(
          c("sp", "spam"),
          function(pkg) isTRUE(tryCatch(requireNamespace(pkg, quietly = TRUE, lib.loc = c(lib_path, core_path, keep_paths)), error = function(e) FALSE)),
          logical(1)
        )]
        if (length(runtime_missing)) {
          install.packages(runtime_missing, repos = "https://cloud.r-project.org", lib = lib_path, dependencies = NA)
        }
        runtime_still_missing <- c("sp", "spam")[!vapply(
          c("sp", "spam"),
          function(pkg) isTRUE(tryCatch(requireNamespace(pkg, quietly = TRUE, lib.loc = c(lib_path, core_path, keep_paths)), error = function(e) FALSE)),
          logical(1)
        )]
        if (length(runtime_still_missing)) {
          stop("Required runtime package(s) still missing in selected environment: ", paste(runtime_still_missing, collapse = ", "))
        }

        # Version integrity: seurat4 must pair with SeuratObject v4; seurat5 must pair with v5.
        expected_versions <- switch(
          chosen_env_id,
          seurat4 = list(SeuratObject = "4.1.4", Seurat = "4.4.0"),
          seurat5 = list(SeuratObject = "5.0.2", Seurat = "5.0.3"),
          NULL
        )
        if (!is.null(expected_versions)) {
          .ensure_env_major("SeuratObject", expected_versions$SeuratObject, lib = lib_path, deps = NA)
          .ensure_env_major("Seurat", expected_versions$Seurat, lib = lib_path, deps = FALSE)
          .ensure_desc_runtime_deps("SeuratObject", lib = lib_path)
          .ensure_desc_runtime_deps("Seurat", lib = lib_path)
        }

        # Bootstrap contract guard: annotation dependencies must be present in canonical core.
        missing_anno <- c("SingleR", "celldex")[!vapply(
          c("SingleR", "celldex"),
          function(pkg) isTRUE(tryCatch(requireNamespace(pkg, quietly = TRUE, lib.loc = core_path), error = function(e) FALSE)),
          logical(1)
        )]
        if (length(missing_anno)) {
          stop(
            "Bootstrap incomplete in canonical core library (", core_path, "): missing ",
            paste(missing_anno, collapse = ", "),
            ". Please run Content/run.R launcher bootstrap before entering analysis."
          )
        }

        # Force load from selected env and capture actual runtime versions.
        suppressPackageStartupMessages(library("Seurat", lib.loc = lib_path, character.only = TRUE))
        seurat_ver <- tryCatch(as.character(utils::packageVersion("Seurat")), error = function(e) NA_character_)
        so_ver <- tryCatch(as.character(utils::packageVersion("SeuratObject")), error = function(e) NA_character_)
        seurat_path <- tryCatch(find.package("Seurat")[1], error = function(e) NA_character_)
        so_path <- tryCatch(find.package("SeuratObject")[1], error = function(e) NA_character_)
        norm_lib_path <- tryCatch(normalizePath(lib_path, winslash = "/", mustWork = FALSE), error = function(e) lib_path)
        norm_seurat_path <- tryCatch(normalizePath(seurat_path, winslash = "/", mustWork = FALSE), error = function(e) seurat_path)
        norm_so_path <- tryCatch(normalizePath(so_path, winslash = "/", mustWork = FALSE), error = function(e) so_path)
        if (!startsWith(norm_seurat_path, norm_lib_path) || !startsWith(norm_so_path, norm_lib_path)) {
          stop(
            "Environment contamination: Seurat stack was not loaded from selected environment library.\n",
            "Expected prefix: ", norm_lib_path,
            "\nLoaded Seurat from: ", norm_seurat_path,
            "\nLoaded SeuratObject from: ", norm_so_path
          )
        }

        expected_major <- if (identical(chosen_env_id, "seurat4")) "4" else if (identical(chosen_env_id, "seurat5")) "5" else NA_character_
        got_seurat <- .major(seurat_ver)
        got_so <- .major(so_ver)
        if (!is.na(expected_major) &&
            (!identical(got_seurat, expected_major) || !identical(got_so, expected_major))) {
          stop(
            sprintf(
              "Environment mismatch: selected %s but loaded Seurat=%s (from %s), SeuratObject=%s (from %s).",
              chosen_env_id, seurat_ver %||% "NA", seurat_path %||% "unknown path", so_ver %||% "NA", so_path %||% "unknown path"
            )
          )
        }

        shared_data$active_environment <- list(name = chosen_env_id, path = lib_path, package_root = active_package_root, core_paths = core_path)
        shared_data$env_runtime_info <- list(
          seurat = seurat_ver,
          seuratobject = so_ver,
          seurat_path = seurat_path,
          seuratobject_path = so_path,
          lib_paths = .libPaths()
        )

        log_messages(paste0(
          "SUCCESS: Activated ", chosen_env_id, " from ", lib_path,
          "\nLoaded Seurat=", seurat_ver, " [", seurat_path, "]",
          "\nLoaded SeuratObject=", so_ver, " [", so_path, "]"
        ))
        shinyjs::show("proceed_to_import_ui")
      }

      if (env_def$type == "Python") {
        log_messages(paste0(
          log_messages(),
          ENV_UI_TEXT$ui_text_log_python_ready_prefix,
          chosen_env_id,
          ENV_UI_TEXT$ui_text_log_python_ready_suffix
        ))
      }
    }, error = function(e) {
      error_text <- paste(
        ENV_UI_TEXT$ui_text_error_title,
        Sys.time(),
        ENV_UI_TEXT$ui_text_error_details_header,
        e$message
      )

      log_messages(error_text)

      shiny::showNotification(
        ENV_UI_TEXT$ui_text_error_notification,
        type = "error",
        duration = 15
      )
    })
  }

  observeEvent(input$prepare_env_btn, {
    target_env <- input$env_choice
    current_env <- shared_data$active_environment$name

    switching_env <- !is.null(current_env) && nzchar(current_env) && !identical(current_env, target_env)
    if (switching_env && .has_pipeline_state()) {
      showModal(modalDialog(
        title = ENV_UI_TEXT$ui_modal_title_switch_environment,
        easyClose = FALSE,
        footer = tagList(
          modalButton(ENV_UI_TEXT$ui_btn_cancel),
          actionButton("confirm_env_switch_btn", ENV_UI_TEXT$ui_btn_switch_anyway, class = "btn-danger")
        ),
        p(strong(ENV_UI_TEXT$ui_modal_label_warning), paste0(" ", ENV_UI_TEXT$ui_modal_text_switch_with_existing_state)),
        p(ENV_UI_TEXT$ui_modal_text_risk_details),
        p(ENV_UI_TEXT$ui_modal_text_save_hint)
      ))
      return(invisible(NULL))
    }

    .run_prepare_env(target_env)
  })

  observeEvent(input$confirm_env_switch_btn, {
    removeModal()
    .run_prepare_env(input$env_choice)
  })

  observeEvent(input$proceed_to_import_btn, {
    shared_data$request_import_modal <- as.integer((shared_data$request_import_modal %||% 0L) + 1L)
  })

  observeEvent(shared_data$fast_prepare_env_request, {
    req(as.integer(shared_data$fast_prepare_env_request %||% 0L) > 0L)
    # Fast Loupe workflow requires deterministic Seurat v4 activation without
    # additional user prompts.
    updateRadioButtons(session, "env_choice", selected = "seurat4")
    .run_prepare_env("seurat4")
    invisible(NULL)
  }, ignoreInit = TRUE)

  observeEvent(input$proceed_to_rds_btn, {
    updateNavbarPage(session, "main_navbar", selected = "rds_tab")
  })
}
