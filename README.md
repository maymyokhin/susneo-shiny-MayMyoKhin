# SUSNEO Shiny Dashboard

This is an R Shiny dashboard built using the `golem` framework. It is designed to visualize sustainability-related data, providing key performance indicators (KPIs) and interactive charts for effective monitoring and analysis.

## 🚀 Getting Started

To run this application locally, you will need to have R and RStudio installed. Follow these steps:

1.  **the Repository**
    ```bash
    [https://github.com/maymyokhin/susneo-shiny-MayMyoKhin.git](https://github.com/maymyokhin/susneo-shiny-MayMyoKhin.git)
    ```

2.  **Open the Project in RStudio**
    -   Open RStudio.
    -   Go to `File` > `Open Project` and select the `.Rproj` file from the cloned repository.

3.  **Install Dependencies**
    -   Open the RStudio Console and run the following command to install all required packages listed in the `DESCRIPTION` file.
    ```R
    golem::install_dev_deps()
    ```

4.  **Run the App**
    -   After installing the packages, you can launch the application by running the `dev/run_dev.R` script in RStudio.
    ```R
    shiny::runApp("app.R")
    # Or, you can simply source the dev/run_dev.R file
    ```

## 📊 App Overview

The dashboard features a clean user interface with two main functionalities:

* **Data Input:** Users can upload their own CSV file to dynamically update the dashboard with new data. The app performs validation to ensure the data has the correct format.
* **Data Visualization:** The main dashboard panel displays three key KPIs (Total Consumption, Total Emissions, Average Usage) and provides interactive charts and a data table for detailed analysis.

## 🏗️ Architecture

This application is built with the `golem` framework to ensure a robust and scalable structure. Key architectural components include:

* **Modules:** The app's functionality is divided into two main modules:
    * `mod_data_upload`: Manages the user interface and server logic for file uploads and data validation.
    * `mod_dashboard`: Handles all dashboard UI elements and the server logic for filtering, visualization, and KPI display.
* **R6 Class:** Business logic, such as data filtering and KPI calculations, is encapsulated in an `R6` class (`R/data_manager.R`). This promotes a clear separation of concerns, making the code more organized and testable.

## 💾 Data

The app is designed to work with a dataset containing sustainability information. The required CSV file (`inst/app/data/sample_data.csv`) must have the following columns:

* `id`
* `site`
* `date`
* `type`
* `value`
* `carbon emission in kgco2e`

## ✅ Testing

Unit tests are included to ensure the reliability of key components. You can run these tests from the RStudio Console using the following command:

```R
devtools::test()
