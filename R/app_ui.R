#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    fluidPage(
      theme = shinythemes::shinytheme("flatly"),
      h1("SUSNEO Shiny Dashboard"),

      # Place data upload module here
      mod_data_upload_ui("data_upload_1"),

      hr(), # Add a horizontal line for separation

      # Place dashboard module here
      mod_dashboard_ui("dashboard_1")
    )
  )
}


#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "susneo.shiny.MayMyoKhin"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
