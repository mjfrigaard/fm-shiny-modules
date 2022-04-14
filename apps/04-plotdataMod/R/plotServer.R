# ===================================================#
# File name: plotServer.R
# This is code to create: plot Server module for plotdataApp (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#

# packages -------------------------------------------------------------
library(shiny)
library(tidyverse)
library(palmerpenguins)

# plotServer -------------------------------------------------------------

plotServer <- function(id) {
    # create module
  moduleServer(id = id, module = function(input, output, session) {
    # data 
    data <- reactive(
        select(palmerpenguins::penguins, 
            all_of(c(input$x_var, input$y_var, input$color))))
    # plot
    output$plot <- renderPlot({
        # y labels
      y_lab <- str_replace_all(input$y_var, "_", " ")
        # x labels
      x_lab <- str_replace_all(input$x_var, "_", " ")
        # graph
      ggplot(data()) +
            geom_point(aes_string(x = input$x_var, y = input$y_var, 
                color = input$color)) + 
        labs(title = 
                paste0("Scatter plot of ", x_lab, " and ", y_lab), 
             x = x_lab, 
             y = y_lab)})
    # reactive values 
    output$value <- renderPrint({
        # these will change as inputs change!
        values <- reactiveValuesToList(x = input, all.names = TRUE)
        print(values)})
  })
}


