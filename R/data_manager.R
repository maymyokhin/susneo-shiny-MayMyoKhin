# R/data_manager.R
#' @title DataManager R6 Class
#'
#' @description An R6 class for managing and processing energy data.
#'
#' @field data A data frame containing the processed energy data.
#'
#' @export
#' @importFrom dplyr mutate filter
#' @importFrom magrittr "%>%"
#' @importFrom R6 R6Class
DataManager <- R6::R6Class("DataManager",
                           public = list(
                             data = NULL,

                             #' @description
                             #' Initializes the DataManager object with a data frame.
                             #'
                             #' @param df A data frame to be processed. It should contain columns
                             #'   `date`, `site`, `type`, `value`, and `carbon emission in kgco2e`.
                             initialize = function(df) {
                               self$data <- df %>%
                                 # Use dplyr::rename() to change the column name within the pipe
                                 #dplyr::rename(carbon_emission_kgco2e = `carbon emission in kgco2e`) %>%
                                 dplyr::mutate(
                                   date = as.Date(date, format = "%d-%m-%Y"),
                                   carbon_emission_kgco2e = as.numeric(carbon_emission_kgco2e)
                                 )
                             },

                             #' @description
                             #' Filters the data based on a selected date range and sites.
                             #'
                             #' @param start_date The start date of the filter range.
                             #' @param end_date The end date of the filter range.
                             #' @param selected_sites A vector of site names to filter by.
                             #' @return A filtered data frame.
                             filter_data = function(start_date, end_date, selected_sites) {
                               filtered_df <- self$data %>%
                                 dplyr::filter(
                                   date >= as.Date(start_date),
                                   date <= as.Date(end_date),
                                   site %in% selected_sites
                                 )
                               return(filtered_df)
                             },

                             #' @description
                             #' Calculates Key Performance Indicators (KPIs) from the data.
                             #'
                             #' @return A list containing the calculated KPIs.
                             calculate_kpis = function() { # No 'df' parameter
                               df <- self$data # Use the data stored in the class
                               if (nrow(df) == 0) {
                                 return(list(
                                   total_consumption = 0,
                                   total_emissions = 0,
                                   avg_usage = 0
                                 ))
                               }

                               kpis <- list(
                                 total_consumption = sum(df$value),
                                 # Access the correctly named column
                                 total_emissions = sum(df$carbon_emission_kgco2e),
                                 avg_cost = round(mean(df$value), 2)
                               )
                               return(kpis)
                             }
                           )
)
