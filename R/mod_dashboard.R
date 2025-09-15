#' mod_dashboard_ui UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import shinythemes
#' @importFrom shiny fluidPage sidebarLayout sidebarPanel mainPanel fluidRow column h3 h2 h4 wellPanel uiOutput
#' @importFrom DT DTOutput
#' @importFrom plotly plotlyOutput

mod_dashboard_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinythemes::themeSelector(),
    fluidPage(
      theme = shinythemes::shinytheme("flatly"),
      sidebarLayout(
        # Sidebar Panel for all filters
        sidebarPanel(
          h3("Filters"),
          # Date Range Filter
          dateRangeInput(ns("date_range"), "Select Date Range:",
                         start = Sys.Date() - 365,
                         end = Sys.Date()),

          # Multi-select dropdown for facilities (sites)
          # UI will be rendered dynamically in the server part
          uiOutput(ns("site_selector"))
        ),

        # Main Panel for displaying KPIs, charts, and table
        mainPanel(
          h2("Sustainability Dashboard"),

          # Key Performance Indicators (KPIs)
          fluidRow(
            column(4, wellPanel(
              h4("Total Consumption"),
              textOutput(ns("total_consumption"))
            )),
            column(4, wellPanel(
              h4("Total Emissions (kgCO2e)"),
              textOutput(ns("total_emissions"))
            )),
            column(4, wellPanel(
              h4("Average Cost"),
              textOutput(ns("avg_cost"))
            ))
          ),

          # Visualizations
          tabsetPanel(
            tabPanel("Time Series Analysis", plotlyOutput(ns("time_series_chart"))),
            tabPanel("Facility Comparison", plotlyOutput(ns("comparison_chart"))),
            tabPanel("Energy Type Comparison", plotlyOutput(ns("energy_type_chart")))
          ),

          # Data Table
          h3("Data Summary Table"),
          DT::DTOutput(ns("data_table"))
        )
      )
    )
  )
}

#' dashboard Server Functions

#' @noRd
#' @importFrom shiny NS tagList
#' @importFrom dplyr filter summarise group_by
#' @importFrom magrittr "%>%"

mod_dashboard_server <- function(id, data_reactive) {
  moduleServer(id, function(input, output, session) {

    data_manager <- reactive({
      req(data_reactive())
      DataManager$new(data_reactive())
    })

    filtered_data <- reactive({
      req(data_manager(), input$date_range, input$selected_sites)

      # Use the filter_data method from the R6 class
      data_manager()$filter_data(
        start_date = input$date_range[1],
        end_date = input$date_range[2],
        selected_sites = input$selected_sites
      )
    })

    kpis <- reactive({
      req(filtered_data())
      # Use the calculate_kpis method from the R6 class
      data_manager()$calculate_kpis(filtered_data())
    })

    # Render the site selector UI dynamically
    output$site_selector <- renderUI({
      req(data_reactive())
      sites <- unique(data_reactive()$site)
      shiny::selectizeInput(
        session$ns("selected_sites"),
        "Select Facilities:",
        choices = sites,
        selected = sites,
        multiple = TRUE
      )
    })

    output$energy_type_chart <- plotly::renderPlotly({
      req(filtered_data())

      df <- filtered_data() %>%
        dplyr::group_by(site, type) %>%
        dplyr::summarise(total_value = sum(value), .groups = "drop")

      # Stacked bar chart ဆွဲမယ်
      p <- ggplot2::ggplot(df, ggplot2::aes(x = site, y = total_value, fill = type)) +
        ggplot2::geom_bar(stat = "identity", position = "stack") +
        ggplot2::labs(
          title = "Total Consumption by Energy Type",
          y = "Total Usage",
          x = "Facility"
        )

      plotly::ggplotly(p)
    })

    # Render KPIs
    output$total_consumption <- renderText({
      paste("Total Consumption:", kpis()$total_consumption, "units")
    })

    output$total_emissions <- renderText({
      paste("Total Emissions:", kpis()$total_emissions, "kg")
    })

    output$avg_cost <- renderText({
      paste("Avg Cost: $", kpis()$avg_cost)
    })

    # Render charts
    output$time_series_chart <- plotly::renderPlotly({
      df <- filtered_data() %>%
        dplyr::group_by(date, site) %>%
        dplyr::summarise(total_value = sum(value))

      p <- ggplot2::ggplot(df, ggplot2::aes(x = date, y = total_value, color = site)) +
        ggplot2::geom_line() +
        ggplot2::labs(title = "Energy Consumption Over Time", y = "Energy Usage", x = "Date")
      plotly::ggplotly(p)
    })

    output$comparison_chart <- plotly::renderPlotly({
      df <- filtered_data() %>%
        dplyr::group_by(site) %>%
        dplyr::summarise(total_value = sum(value))

      p <- ggplot2::ggplot(df, ggplot2::aes(x = site, y = total_value, fill = site)) +
        ggplot2::geom_bar(stat = "identity") +
        ggplot2::labs(title = "Total Consumption by Facility", y = "Total Usage", x = "Facility")
      plotly::ggplotly(p)
    })

    # Render data table
    output$data_table <- DT::renderDT({
      DT::datatable(filtered_data())
    })

  })
}


## To be copied in the UI
# mod_dashboard_ui("dashboard_1")

## To be copied in the server
# mod_dashboard_server("dashboard_1")
