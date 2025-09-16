# R/data.R

#' Sample Assignment Data
#'
#' A dataset containing sample energy consumption and carbon emission data.
#' This data is used for the shiny app dashboard.
#'
#' @format A data frame with 2973 rows and 6 variables:
#' \describe{
#'   \item{id}{Unique identifier for each entry.}
#'   \item{site}{The site of the energy consumption.}
#'   \item{date}{The date of the data entry.}
#'   \item{type}{The type of energy consumption (e.g., Water, Electricity).}
#'   \item{value}{The energy usage value.}
#'   \item{carbon emission in kgco2e}{The carbon emission value in kg.}
#' }
"SAMPLE_ASSIGNMENT_DATA"
