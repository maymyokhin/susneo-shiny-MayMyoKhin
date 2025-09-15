#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd

# R/app_server.R
app_server <- function(input, output, session) {

  # Load the sample data from the data/ folder
  sample_data <- readr::read_csv(system.file("data", "SAMPLE_ASSIGNMENT_DATA.csv", package = "susneo.shiny.MayMyoKhin"))

  # Rename the column right after loading it
  names(sample_data)[names(sample_data) == "carbon emission in kgco2e"] <- "carbon_emission_kgco2e"

  data_reactive <- reactive({
    sample_data
  })

  # Call the data upload server module
  user_data_reactive <- mod_data_upload_server("data_upload_1")

  # Pass the reactive data from the upload module to the dashboard module
  mod_dashboard_server("dashboard_1", data_reactive = user_data_reactive)
}
