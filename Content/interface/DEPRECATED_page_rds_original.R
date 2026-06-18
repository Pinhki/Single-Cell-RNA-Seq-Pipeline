# DEPRECATED / ABANDONED FILE
# This is the legacy RDS page implementation and is not sourced by app.R.
# Replaced by: interface/page_rds.R
# Kept only for historical reference.
#
# Former path: interface/page_rds_original.R
# RDS Process

rds_ui <- fluidPage(
  add_busy_spinner(
    spin = "fading-circle",  # other options: "circle", "cube-grid", etc.
    position = "full-page",  # makes it look like a blocking overlay
    color = "#059",          # spinner color
    timeout = 100            # how long (ms) before it shows up
  ),
  
  titlePanel("Export/Import Seurat Object (.rds)"),
  p("Save your final processed Seurat object for future sessions, or load a previously saved object to continue your work."),
  hr(),
  
  
  sidebarLayout(
    sidebarPanel(
      h4("Export Object"),
      # --- ADD THIS ---
      shinyjs::disabled(
        downloadButton("download_rds_btn", "Download All Datasets (.rds)", class = "btn-primary")
      )
    ),
    mainPanel(
      h4("Import Object"),
      p("Importing an .rds file will replace the current objects and update the visualization pages."),
      # --- ADD THIS ---
      fileInput("import_rds_file", "Upload Seurat Object (.rds):", accept = c(".rds", ".RDS"))
    )
  )
)

# R/page_rds_server.R (or your equivalent file name)

rds_server <- function(input, output, session, shared_data, APP_VERSION, MINIMUM_COMPATIBLE_VERSION, MAXIMUM_COMPATIBLE_VERSION) {
  
  # --- The renderUI for the selector is no longer needed and can be removed ---
  # output$rds_export_selector_ui <- renderUI({ ... })
  observe({
    # Check if the list of objects is not NULL and has more than 0 items.
    if (!is.null(shared_data$all_seurat_objects) && length(shared_data$all_seurat_objects) > 0) {
      # If objects exist, enable the download button.
      shinyjs::enable("download_rds_btn")
    } else {
      # Otherwise, ensure the button is disabled.
      shinyjs::disable("download_rds_btn")
    }
  })
  # --- Observer for RDS Import (Modified to handle a list of objects) ---
  observeEvent(input$import_rds_file, {
    file <- input$import_rds_file
    req(file)
    
    showNotification("Importing session file...", type = "message", id = "rds_import_note")
    
    # Read the RDS file, which should contain a list of Seurat objects
    
    imported_data <- readRDS(file$datapath)
    
    # --- Version Check Logic ---
    imported_version <- "unknown"
    imported_list <- NULL
    
    if (is.list(imported_data) && "app_version" %in% names(imported_data)) {
      imported_version <- imported_data$app_version
      imported_list <- imported_data$all_seurat_objects
    } else if (is.list(imported_data) && all(sapply(imported_data, inherits, "Seurat"))) {
      imported_list <- imported_data
    } else {
      removeNotification("rds_import_note")
      showNotification("Error: The uploaded file is not a valid list of Seurat objects.", type = "error")
      return()
    }
    
    # --- THIS IS THE NEW, MORE ROBUST VERSION CHECK ---
    is_incompatible <- FALSE
    warning_message <- ""
    
    if (imported_version != "unknown") {
      # Check if the imported file is TOO OLD
      if (numeric_version(imported_version) < numeric_version(MINIMUM_COMPATIBLE_VERSION)) {
        is_incompatible <- TRUE
        warning_message <- paste("The file version (", imported_version, ") is older than the minimum compatible version (", MINIMUM_COMPATIBLE_VERSION, ").")
      }
      # Optional: Check if the imported file is NEWER than the app
      if (numeric_version(imported_version) > numeric_version(MAXIMUM_COMPATIBLE_VERSION)) {
        is_incompatible <- TRUE
        warning_message <- paste("The file version (", imported_version, ") is newer than this app's version (", APP_VERSION, "). Please update the application.")
      }
    }
    
    if (is_incompatible) {
      # If versions are incompatible, show a warning modal
      showModal(modalDialog(
        title = "Version Incompatibility Warning",
        p(warning_message),
        p("This may cause unexpected errors or incorrect results."),
        p("Do you still want to proceed with the import?"),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("confirm_import_anyway_btn", "Proceed Anyway", class = "btn-warning")
        )
      ))
    } else {
      # If versions are compatible, proceed with the import directly.
      perform_import(imported_list)
    }

  })
  
  # It contains the logic to handle the actual import process.
  perform_import <- function(imported_list) {
    # Replace the existing list with the newly imported one
    shared_data$all_seurat_objects <- imported_list
    
    # Set the active object to the first one from the imported list
    if (length(imported_list) > 0) {
      shared_data$active_object_name <- names(imported_list)[1]
    } else {
      shared_data$active_object_name <- NULL
    }
    
    shinyjs::show("analysis_tabs_by_type")
    
    removeNotification("rds_import_note")
    showNotification("Session imported successfully! Previous objects have been cleared.", type = "message")
    
    # Navigate to the analysis page to work with the newly imported data
    updateNavbarPage(session, "main_navbar", selected = "analysis_tab")
  }
  
  # It listens for the "Proceed Anyway" button click.
  observeEvent(input$confirm_import_anyway_btn, {
    # Re-read the file to ensure we have the data
    imported_data <- readRDS(input$import_rds_file$datapath)
    
    # Extract the list of objects, handling both versioned and un-versioned files
    imported_list <- imported_data$all_seurat_objects %||% imported_data
    
    # Call the helper function to perform the import
    perform_import(imported_list)
    
    # Close the modal dialog
    removeModal()
  })
  
  # --- Download Handler for RDS Export (Modified) ---
  output$download_rds_btn <- downloadHandler(
  
    filename = function() {
      paste0("Seurat_Session_v", APP_VERSION, "_", format(Sys.time(), "%Y%m%d"), ".rds")
    },
    content = function(file) {
      showNotification("Start file preparation. A download window will pop out after finish. Please don't click anywhere. This might take a while", type = "message")
      objects_to_save <- shared_data$all_seurat_objects
      req(length(objects_to_save) > 0)
      
      data_to_save <- list(
        app_version = APP_VERSION,
        all_seurat_objects = objects_to_save
      )
      
      saveRDS(data_to_save, file = file)
      removeNotification("rds_save_note")
      
    }
  )
}
