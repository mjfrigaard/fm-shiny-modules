# ===================================================#
# File name: modules.R
# This is code to create: modules for plotdataApp (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#

# packages ----------------------------------------------------------------
library(shiny)
library(tidyverse)
library(palmerpenguins)
library(reactable)

# dataShinyDashUI ----------------------------------------------------------
dataShinyDashUI <- function(id) {
  tagList(
    shinydashboard::dashboardPage(
      sidebar = shinydashboard::dashboardSidebar(
        collapsed = FALSE,
        selectizeInput(
          inputId = NS(namespace = id, id = "cols"),
          label = "Variables",
          choices = names(palmerpenguins::penguins),
          multiple = TRUE,
          selected = c("species", "body_mass_g", "bill_length_mm")
        )
      ),
      header = shinydashboard::dashboardHeader(title = "dataShinyDashApp"),
      body = shinydashboard::dashboardBody(
        # table
        reactableOutput(outputId = NS(namespace = id, id = "table")),
        br(), br(), br(),
        # values
        tags$strong("data ", tags$code("reactiveValues:")),
        verbatimTextOutput(outputId = NS(namespace = id, id = "value"))
      ),
      title = "Example layout", skin = "black"
    )
  )
}

# dataShinyDashServer -----------------------------------------------------
dataShinyDashServer <- function(id) {
  moduleServer(id = id, module = function(input, output, session) {

    # data
    data <- reactive({
      select(palmerpenguins::penguins, all_of(input$cols))
    })

    # table display
    output$table <- reactable::renderReactable({
      req(input$cols)
      reactable::reactable(
        data = data(),
        # reactable settings ------
        defaultPageSize = 10,
        resizable = TRUE,
        highlight = TRUE,
        height = 400,
        wrap = FALSE,
        bordered = TRUE,
        searchable = TRUE,
        filterable = TRUE
      )
    })

    # reactive values
    output$value <- shiny::renderPrint({
      req(input$cols)
      all_values <- reactiveValuesToList(x = input, all.names = TRUE)
      values <- all_values[str_detect(names(all_values), "cols")]
      print(values)
    })
  })
}
