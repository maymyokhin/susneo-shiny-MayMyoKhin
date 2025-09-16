# R/data_manager.R
#' DataManager for R6 Class
#'
#' An R6 class for managing and processing energy data.
#'
#' @export
#' @importFrom dplyr mutate filter
#' @importFrom magrittr "%>%"
#' @importFrom R6 R6Class
DataManager <- R6::R6Class("DataManager",
                           public = list(
                             data = NULL,

                             initialize = function(df) {
                               self$data <- df %>%
                                 # Use dplyr::rename() to change the column name within the pipe
                                 #dplyr::rename(carbon_emission_kgco2e = `carbon emission in kgco2e`) %>%
                                 dplyr::mutate(
                                   date = as.Date(date, format = "%d-%m-%Y"),
                                   carbon_emission_kgco2e = as.numeric(carbon_emission_kgco2e)
                                 )
                             },


                             filter_data = function(start_date, end_date, selected_sites) {
                               filtered_df <- self$data %>%
                                 dplyr::filter(
                                   date >= as.Date(start_date),
                                   date <= as.Date(end_date),
                                   site %in% selected_sites
                                 )
                               return(filtered_df)
                             },

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
