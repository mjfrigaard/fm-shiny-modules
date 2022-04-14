# ===================================================#
# File name: dataServer.R
# This is code to create: data Server module for plotdataApp (module)
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

# dataServer -----------------------------------------------------
dataServer <- function(id) {
    
  moduleServer(id = id, module = function(input, output, session) {
    
    # data 
    data <- reactive({
        select(palmerpenguins::penguins, all_of(input$cols))
        })
    
    # table display
    output$table <- reactable::renderReactable({
        req(input$cols)
        reactable::reactable(data = data(), 
            # reactable settings ------
            defaultPageSize = 10,
            resizable = TRUE,
            highlight = TRUE,
            height = 400,
            wrap = FALSE,
            bordered = TRUE,
            searchable = TRUE,
            filterable = TRUE)
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