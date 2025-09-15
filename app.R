# app.R

# This is a single file app runner for the Golem-based Shiny application.
# It sources the necessary UI and server functions from the R/ folder.

# Load required packages
library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
library(plotly)
library(R6)
library(DT)
library(shinythemes)

# Load the custom Golem modules and functions from the R/ directory
source(file.path("R", "data_manager.R"))
source(file.path("R", "mod_dashboard.R"))
source(file.path("R", "mod_data_upload.R"))

# Load sample data (for local testing purposes)
sample_data <- readr::read_csv("data/SAMPLE_ASSIGNMENT_DATA.csv")
names(sample_data)[names(sample_data) == "carbon emission in kgco2e"] <- "carbon_emission_kgco2e"


# Define the app's UI
app_ui <- function(request) {
  tagList(
    shinythemes::shinytheme("flatly"),
    h1("SUSNEO Shiny Dashboard"),
    mod_data_upload_ui("data_upload_1"),
    hr(),
    mod_dashboard_ui("dashboard_1")
  )
}


# Define the app's server logic
app_server <- function(input, output, session) {
  # Handle data source: from uploaded file if available, otherwise use sample data
  user_data_reactive <- mod_data_upload_server("data_upload_1")

  # Pass data reactive to the dashboard module
  mod_dashboard_server(
    "dashboard_1",
    data_reactive = reactive({
      if (!is.null(user_data_reactive())) {
        user_data_reactive()
      } else {
        sample_data
      }
    })
  )
}

# Run the application
shinyApp(ui = app_ui, server = app_server)
