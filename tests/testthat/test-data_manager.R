# tests/testthat/test-data_manager.R

library(testthat)
library(dplyr)
library(R6)

source(file.path("..", "..", "R", "data_manager.R"))

create_test_data <- function() {
  df <- data.frame(
    id = 1:5,
    site = c("A", "B", "A", "C", "A"),
    date = as.Date(c("2024-01-01", "2024-01-02", "2024-01-03", "2024-01-04", "2024-01-05")),
    type = c("Water", "Electricity", "Water", "Gas", "Electricity"),
    value = c(100, 200, 150, 300, 250),
    emissions = c(10, 20, 15, 30, 25)
  )

  # Then, set the column names using a vector
  names(df)[names(df) == "emissions"] <- "carbon emission in kgco2e"

  return(df)
}

test_that("calculate_kpis returns correct values", {
  test_df <- create_test_data()

  dm <- DataManager$new(test_df)

  kpis <- dm$calculate_kpis()

  # Test for expected numeric values
  expect_equal(kpis$total_consumption, 1000)
  expect_equal(kpis$total_emissions, 100)
  expect_equal(kpis$avg_usage, 200)
})

test_that("filter_data filters correctly by date and site", {
  test_df <- create_test_data()
  dm <- DataManager$new(test_df)

  # Test with a specific date range
  filtered_df <- dm$filter_data("2024-01-02", "2024-01-04", c("A", "B", "C"))
  expect_equal(nrow(filtered_df), 3)

  # Test with a specific site
  filtered_df_site <- dm$filter_data("2024-01-01", "2024-01-05", "A")
  expect_equal(nrow(filtered_df_site), 3)
})
