# data-raw/DATASET_GENERATION.R

# Load necessary package
library(readr)

# Load the data from CSV
SAMPLE_ASSIGNMENT_DATA <- readr::read_csv("data-raw/SAMPLE_ASSIGNMENT_DATA.csv")

# Use usethis to save the data in the correct format for a package
usethis::use_data(SAMPLE_ASSIGNMENT_DATA, overwrite = TRUE)
