#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
# R/app_server.R

app_server <- function(input, output, session) {

  # Call the data upload server module
  user_data_reactive <- mod_data_upload_server("data_upload_1")

  # Pass the reactive data from the upload module to the dashboard module
  mod_dashboard_server("dashboard_1", data_reactive = user_data_reactive)
}
