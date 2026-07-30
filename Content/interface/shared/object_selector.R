# Shared active-object selector contract.
#
# Agent note: These selectors are views/controllers for
# shared_data$active_object_name. Physical user events use a separate input;
# ordinary select changes are server echoes or browser restoration and must
# never become canonical state.

wl_object_selector_ui <- function(input_id, label) {
  tagList(
    tags$style(HTML("
      [data-wl-object-selector=\"true\"] .selectize-dropdown-content {
        max-height: none !important;
      }
    ")),
    div(
      `data-wl-object-selector` = "true",
      selectInput(
        input_id,
        label,
        choices = character(0),
        selected = character(0)
      )
    ),
    tags$script(HTML("
      (function () {
        if (window.__wlObjectSelectorContractInstalled) return;
        window.__wlObjectSelectorContractInstalled = true;
        window.__wlObjectSelectorEventSequence = 0;

        function guardedSelector(target) {
          if (!target) return null;
          var wrapper = target.closest
            ? target.closest('[data-wl-object-selector=\"true\"]')
            : null;
          if (!wrapper) return null;
          var selector = target.tagName === 'SELECT'
            ? target
            : wrapper.querySelector('select');
          if (!selector) return null;
          return selector;
        }

        function emitUserSelection(selector) {
          if (!selector || !selector.__wlPhysicalChangeArmed) return;
          selector.__wlPhysicalChangeArmed = false;
          if (!window.Shiny || !Shiny.setInputValue) return;
          Shiny.setInputValue(
            selector.id + '_user_event',
            {
              value: selector.value,
              sequence: ++window.__wlObjectSelectorEventSequence
            },
            {priority: 'event'}
          );
        }

        ['mousedown', 'keydown', 'touchstart'].forEach(function (eventName) {
          document.addEventListener(eventName, function (event) {
            var selector = guardedSelector(event.target);
            if (selector) selector.__wlPhysicalChangeArmed = true;
          }, true);
        });

        document.addEventListener('change', function (event) {
          var selector = guardedSelector(event.target);
          emitUserSelection(selector);
        }, true);

        if (window.jQuery) {
          jQuery(document)
            .off('shiny:updateinput.wlObjectSelectorContract')
            .on('shiny:updateinput.wlObjectSelectorContract', function (event) {
              var selector = guardedSelector(event.target);
              if (selector) selector.__wlPhysicalChangeArmed = false;
            });

          // Agent note: Selectize emits a jQuery synthetic change event, which
          // native addEventListener handlers do not reliably receive.
          jQuery(document)
            .off('change.wlObjectSelectorContract')
            .on(
              'change.wlObjectSelectorContract',
              '[data-wl-object-selector=\"true\"] select',
              function () {
                emitUserSelection(this);
              }
            );
        }
      })();
    "))
  )
}

wl_bind_active_object_selector <- function(
  input,
  session,
  shared_data,
  input_id,
  choices,
  enabled = reactive(TRUE),
  active = reactive(TRUE),
  on_user_selection = NULL,
  log_event = NULL
) {
  pending_value <- reactiveVal("")
  choices_signature <- reactiveVal("")

  normalize_choices <- function(values) {
    values <- as.character(values %||% character(0))
    unique(values[!is.na(values) & nzchar(values)])
  }
  log <- function(event, details = "") {
    if (is.function(log_event)) log_event(event, details)
    invisible(NULL)
  }
  selected_value <- function(object_choices) {
    canonical <- as.character(shared_data$active_object_name %||% "")
    canonical <- if (length(canonical)) canonical[[1]] else ""
    if (nzchar(canonical) && canonical %in% object_choices) canonical else ""
  }
  push_selector_state <- function(object_choices, selected) {
    pending_value(selected)
    suppressWarnings(try(freezeReactiveValue(input, input_id), silent = TRUE))
    updateSelectInput(
      session,
      input_id,
      choices = object_choices,
      selected = if (nzchar(selected)) selected else character(0)
    )
  }

  observe({
    object_choices <- normalize_choices(choices())
    selected <- selected_value(object_choices)
    signature <- paste(object_choices, collapse = "\r")
    current <- as.character(isolate(input[[input_id]]) %||% "")
    current <- if (length(current)) current[[1]] else ""
    registry_changed <- !identical(signature, choices_signature())
    value_changed <- !identical(current, selected)

    if (registry_changed) choices_signature(signature)
    if (registry_changed || value_changed) {
      push_selector_state(object_choices, selected)
      log(
        "selector_sync",
        sprintf("id=%s selected=%s choices=%d", input_id, selected, length(object_choices))
      )
    }

    if (length(object_choices) && isTRUE(enabled())) {
      shinyjs::enable(input_id)
    } else {
      shinyjs::disable(input_id)
    }

    canonical <- as.character(shared_data$active_object_name %||% "")
    canonical <- if (length(canonical)) canonical[[1]] else ""
    if (nzchar(canonical) && !canonical %in% object_choices) {
      log(
        "invalid_canonical",
        sprintf("id=%s active=%s choices=%s", input_id, canonical, paste(object_choices, collapse = "|"))
      )
    }
    invisible(NULL)
  })

  apply_user_selection <- function(selected, source = "bridge") {
    if (!isTRUE(active()) || !nzchar(selected)) return(invisible(NULL))

    object_choices <- normalize_choices(isolate(choices()))
    if (!selected %in% object_choices) {
      log("invalid_user_selection", sprintf("id=%s selected=%s", input_id, selected))
      showNotification(
        sprintf("Selected dataset '%s' is not available.", selected),
        type = "error",
        duration = 8
      )
      return(invisible(NULL))
    }

    previous <- as.character(shared_data$active_object_name %||% "")
    previous <- if (length(previous)) previous[[1]] else ""
    pending_value("")
    log(
      "user_selection",
      sprintf("id=%s selected=%s previous=%s source=%s", input_id, selected, previous, source)
    )
    if (is.function(on_user_selection)) {
      on_user_selection(selected, previous)
    } else if (!identical(previous, selected)) {
      shared_data$active_object_name <- selected
    }
    invisible(NULL)
  }

  observeEvent(input[[paste0(input_id, "_user_event")]], {
    event <- input[[paste0(input_id, "_user_event")]]
    selected <- as.character(event$value %||% "")
    selected <- if (length(selected)) selected[[1]] else ""
    apply_user_selection(selected, source = "bridge")
  }, ignoreInit = TRUE, priority = 1100)

  observeEvent(input[[input_id]], {
    selected <- as.character(input[[input_id]] %||% "")
    selected <- if (length(selected)) selected[[1]] else ""
    object_choices <- normalize_choices(isolate(choices()))
    canonical <- selected_value(object_choices)
    pending <- isolate(pending_value())

    if (identical(selected, canonical)) {
      if (identical(pending, selected)) {
        pending_value("")
        log("selector_sync_success", sprintf("id=%s value=%s", input_id, selected))
      }
      return(invisible(NULL))
    }

    # Agent note: Global autofill guard rejects unauthorized browser restoration.
    # Accept valid raw changes so switching does not depend on client bridge delivery.
    if (isTRUE(active()) && nzchar(selected) && selected %in% object_choices) {
      apply_user_selection(selected, source = "raw_change")
      return(invisible(NULL))
    }

    pending_value(canonical)
    log(
      "noncanonical_reset",
      sprintf("id=%s value=%s active=%s pending=%s", input_id, selected, canonical, pending)
    )
    suppressWarnings(try(freezeReactiveValue(input, input_id), silent = TRUE))
    updateSelectInput(
      session,
      input_id,
      selected = if (nzchar(canonical)) canonical else character(0)
    )
    invisible(NULL)
  }, ignoreInit = TRUE, priority = 1000)

  list(
    pending_value = pending_value,
    choices_signature = choices_signature
  )
}
