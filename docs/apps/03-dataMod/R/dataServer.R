# ===================================================#
# File name: dataServer.R
# This is code to create: dataServer for palmer penguins data (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#

# packages ----------------------------------------------------------------
library(shiny)
library(data.table)
library(tidyverse)
library(purrr)
library(vroom)
library(reactable)
library(palmerpenguins)
library(haven)
library(readxl)

# dataServer ----------------------------------------
dataServer <- function(id) {
  moduleServer(id = id, module = function(input, output, session) {
    # data
    data <- reactive(
      select(
        palmerpenguins::penguins,
        all_of(c(input$x_var, input$y_var, input$color))
      )
    )

    # table display
    output$table <- reactable::renderReactable({
      reactable::reactable(
        data = data(),
        # reactable settings ------
        defaultPageSize = 10,
        resizable = TRUE,
        highlight = TRUE,
        height = 350,
        wrap = FALSE,
        bordered = TRUE,
        searchable = TRUE,
        filterable = TRUE
      )
    })

    # reactive values
    output$value <- shiny::renderPrint({
      # req(c(input$x_var, input$y_var, input$color))
      all_values <- reactiveValuesToList(x = input, all.names = TRUE)
      values <- all_values[str_detect(names(all_values), "reactable", TRUE)]
      print(values)
    })
  })
}
