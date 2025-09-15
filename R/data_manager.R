# R/data_manager.R
#' @export
#' @importFrom dplyr mutate filter
#' @importFrom magrittr "%>%"

DataManager <- R6::R6Class("DataManager",
                           public = list(
                             data = NULL,
                             initialize = function(df) {
                               # Data preprocessing: Convert date column to Date type
                               self$data <- df %>%
                                 dplyr::mutate(date = as.Date(date, format = "%d-%m-%Y"))
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

                             calculate_kpis = function(df) {
                               kpis <- list(
                                 total_consumption = sum(df$value),
                                 total_emissions = sum(df$carbon_emission_kgco2e),
                                 avg_usage = round(mean(df$value * 0.1), 2)
                               )
                               return(kpis)
                             }
                           )
)
