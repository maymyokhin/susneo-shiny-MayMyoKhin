#' data_upload UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_data_upload_ui <- function(id){
  ns <- NS(id)
  tagList(
    fileInput(ns("file"), "Upload CSV File",
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv"))
  )
}



#' data_upload Server Functions
#'
#' @noRd
#' Data Upload Server Function
#'
mod_data_upload_server <- function(id){
  moduleServer(id, function(input, output, session) {

    # Reactive value to store the uploaded data
    uploaded_data <- reactive({
      req(input$file) # Require a file input

      # Read the CSV file
      df <- readr::read_csv(input$file$datapath)

      # Perform basic validation
      required_cols <- c("id", "site", "date", "type", "value", "carbon emission in kgco2e")
      if (!all(required_cols %in% names(df))) {
        stop("Error: The uploaded CSV file is missing required columns.")
      }

      # Rename the carbon emission column for consistency
      names(df) <- stringr::str_replace_all(names(df), " ", "_")

      return(df)
    })

    return(uploaded_data)
  })
}

## To be copied in the UI
# mod_data_upload_ui("data_upload_1")

## To be copied in the server
# mod_data_upload_server("data_upload_1")
