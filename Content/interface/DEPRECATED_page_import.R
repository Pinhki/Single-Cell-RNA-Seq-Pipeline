# DEPRECATED / ABANDONED FILE
# This page is not sourced by app.R and is no longer part of active navigation.
# Import now runs from the right sidebar module.
# Kept only for historical reference.
#
# Former path: interface/page_import.R
# R/page_import_ui.R
library(shinyFiles)

import_ui <- fluidPage(
  titlePanel("Step 1: Import and Annotate All Samples"),
  p("Use the controls below to add all sample files for your experiment. You can add multiple batches from different locations before proceeding."),
  hr(),
  
  sidebarLayout(
    sidebarPanel(
      width = 4,
      h4("Add New Samples"),
      # Use shinyFiles for server-side file selection
      # We now show both buttons all the time.
      p("For each sample, you might have 2 types of file, of which you only need one for the following:"),
      br(),
      shinyFilesButton("import_h5_files", "Add H5 File(s)", "Select .h5 file(s) to add", multiple = TRUE, class="btn-primary"),
      br(),br(),
      shinyDirButton("import_matrix_dirs", "Add Matrix Folder(s)", "Select folder(s) to add", class="btn-primary"),
      br(),br(),
      p("Nothing above but just FASTQ files?", 
        actionLink("goto_help_fastq", "See the Help page for details.")),
      p("GEX data accept only. Still learning VDJ data."),
      br(),br(),
    ),
    mainPanel(
      width = 8,
      h4("Staged Samples"),
      p("These samples will be carried forward to the QC page. You can remove them here before proceeding."),
      div(
        id = "import_list_wrapper",
        style = "min-height: 300px; border: 1px solid #ccc; border-radius: 5px; padding: 10px;",
        uiOutput("import_sample_list_ui")
      ),
      hr(),
      shinyjs::hidden(
        div(id = "proceed_to_qc_ui",
            actionButton("proceed_to_qc_btn", "Confirm Samples & Go to QC Page →", class = "btn-success btn-lg", icon = icon("arrow-right"))
        )
      )
    )
  )
)
  


# R/page_import_server.R
library(shinyFiles)

import_server <- function(input, output, session, shared_data) {
  
  # This reactiveVal holds the samples for this page before they are confirmed
  staged_samples <- reactiveVal(
    data.frame(
      id = character(0), name = character(0), condition = character(0), batch = character(0), 
      path = character(0), data_type = character(0), stringsAsFactors = FALSE
    )
  )
  
  # This temporarily holds paths from the file selection pop-up
  newly_added_sample_info <- reactiveVal(NULL)
  
  # --- shinyFiles Setup ---
  if (.Platform$OS.type == "windows") {
    available_letters <- paste0(LETTERS, ":/")
    drive_exists <- vapply(available_letters, dir.exists, logical(1))
    drives <- available_letters[drive_exists]
    roots_path <- setNames(drives, paste(LETTERS[drive_exists], "Drive"))
  } else {
    # For macOS/Linux, define roots differently
    roots_path <- c("Home" = fs::path_home(), "Root" = "/", "Volumes" = "/Volumes")
  }
  volumes <- getOption("shiny_app_volumes", default = c(Home = roots_path, "demo" = paste0(getwd(),"/demo")))
  shinyDirChoose(input, "import_matrix_dirs", roots = volumes, session = session)
  shinyFileChoose(input, "import_h5_files", roots = volumes, session = session, filetypes = c('', 'h5', 'hdf5'))
  
  # --- Observers for the "Add" buttons ---
  observeEvent(input$import_matrix_dirs, {
    req(is.list(input$import_matrix_dirs))
    paths <- parseDirPath(volumes, input$import_matrix_dirs)
    if (length(paths) > 0) newly_added_sample_info(list(paths = paths, type = "matrix"))
  })
  
  observeEvent(input$import_h5_files, {
    req(is.list(input$import_h5_files))
    paths <- parseFilePaths(volumes, input$import_h5_files)$datapath
    if (length(paths) > 0) newly_added_sample_info(list(paths = paths, type = "h5"))
  })
  
  # --- Observer to show the annotation modal ---
  observeEvent(newly_added_sample_info(), {
    info <- newly_added_sample_info()
    req(info)
    
    modal_ui <- fluidPage(
      h4("Annotate Your New Samples"),
      hr(),
      lapply(seq_along(info$paths), function(i) {
        path <- info$paths[i]
        ns_id <- paste0("sample_anno_", i)
        fluidRow(
          column(4, textInput(paste0(ns_id, "_name"), "Sample Name", value = basename(path))),
          column(4, textInput(paste0(ns_id, "_cond"), "Condition", placeholder = "e.g., Control")),
          column(4, textInput(paste0(ns_id, "_batch"), "Batch", placeholder = "e.g., Batch1"))
        )
      }),
      hr(),
      actionButton("submit_annotations", "Add Samples to List", class="btn-success")
    )
    
    showModal(modalDialog(title = "Sample Annotation", modal_ui, footer = modalButton("Cancel"), size = "l"))
  })
  
  # --- Observer to handle annotation submission ---
  observeEvent(input$submit_annotations, {
    info <- newly_added_sample_info()
    req(info)
    
    new_data <- lapply(seq_along(info$paths), function(i) {
      ns_id <- paste0("sample_anno_", i)
      data.frame(
        id = paste0(basename(info$paths[i]), "_", as.integer(Sys.time()), "_", i),
        name = input[[paste0(ns_id, "_name")]],
        condition = input[[paste0(ns_id, "_cond")]],
        batch = input[[paste0(ns_id, "_batch")]],
        path = info$paths[i],
        data_type = info$type,
        stringsAsFactors = FALSE
      )
    })
    
    new_data_df <- do.call(rbind, new_data)
    staged_samples(rbind(staged_samples(), new_data_df))
    newly_added_sample_info(NULL)
    removeModal()
  })
  
  # --- Render the list of staged samples ---
  output$import_sample_list_ui <- renderUI({
    df <- staged_samples()
    if (nrow(df) == 0) {
      return(tags$div(style = "color: #888;", "Add samples using the buttons on the left."))
    }
    
    lapply(1:nrow(df), function(i) {
      tags$div(
        style = "padding: 5px; border-bottom: 1px solid #eee;",
        tags$div(style = "float: right;",
                 tags$i(class = "fa fa-times-circle", style = "cursor: pointer; color: #999;",
                        onclick = sprintf("Shiny.setInputValue('delete_item_import', '%s', {priority: 'event'})", df$id[i]))
        ),
        tags$strong(df$name[i]),
        tags$div(tags$small(paste("Condition:", df$condition[i], "| Batch:", df$batch[i]))),
        tags$div(tags$small(tags$em(df$path[i])))
      )
    })
  })
  
  # --- Observer to handle deleting an item ---
  observeEvent(input$delete_item_import, {
    req(input$delete_item_import)
    id_to_delete <- input$delete_item_import
    current_df <- staged_samples()
    updated_df <- current_df[current_df$id != id_to_delete, ]
    staged_samples(updated_df)
  })
  
  # --- Observer to show/hide the "Proceed" button ---
  observe({
    shinyjs::toggle("proceed_to_qc_ui", condition = nrow(staged_samples()) > 0)
  })
  
  # --- Observer for the "Proceed to QC" button ---
  observeEvent(input$proceed_to_qc_btn, {
    df <- staged_samples()
    
    # Add the extra columns needed for the QC page table
    df$use_in_analysis <- TRUE
    df$min_features <- 200
    df$max_features <- 5000       # <-- NEW
    df$min_umi_counts <- 500     # <-- NEW
    df$max_umi_counts <- 50000     # <-- NEW
    df$max_mt_percent <- 20
    df$qc_status <- "Pending"
    
    # Merge with any data that might already be in the shared object
    existing_df <- shared_data$full_sample_sheet
    combined_df <- rbind(existing_df, df)
    final_df <- combined_df[!duplicated(combined_df$path), ]
    
    shared_data$full_sample_sheet <- final_df
    
    # Clear the staging area for the next time the user visits this page
    staged_samples(data.frame(id=character(0), name=character(0), condition=character(0), batch=character(0), path=character(0), data_type=character(0), stringsAsFactors=FALSE))
    
    updateTabsetPanel(session, "main_tabs", selected = "qc_tab")
    session$sendCustomMessage("setActiveNav", "qc_tab")
  })
  observeEvent(input$goto_help_fastq, {
    updateTabsetPanel(session, "main_tabs", selected = "help_tab")
    session$sendCustomMessage("setActiveNav", "help_tab")
  })
  
} # <-- IMPORTANT: All code must be inside this closing brace
