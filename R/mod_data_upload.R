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
# R/mod_data_upload_server.R
mod_data_upload_server <- function(id){
  moduleServer(id, function(input, output, session) {
    uploaded_data <- reactive({
      req(input$file)

      # Read the CSV file
      df <- readr::read_csv(input$file$datapath)

      # Rename the carbon emission column right after reading
      names(df)[names(df) == "carbon emission in kgco2e"] <- "carbon_emission_kgco2e"

      # Perform basic validation with the new column name
      required_cols <- c("id", "site", "date", "type", "value", "carbon_emission_kgco2e")
      if (!all(required_cols %in% names(df))) {
        stop("Error: The uploaded CSV file is missing required columns.")
      }

      return(df)
    })
    return(uploaded_data)
  })
}
