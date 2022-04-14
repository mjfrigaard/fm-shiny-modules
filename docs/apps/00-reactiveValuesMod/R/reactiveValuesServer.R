# ===================================================#
# File name: reactiveValuesServer.R
# This is code to create: reactiveValuesApp (no modules)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#

# packages ----------------------------------------------------------------
library(shiny)
library(tidyverse)


# reactiveValuesServer -----------------------------------------------------
reactiveValuesServer <- function(id) {
  moduleServer(id = id, module = function(input, output, session) {
      
    # data 
    data <- reactive(
        select(ggplot2::diamonds, 
            all_of(c(input$x_var, 
                     input$y_var, 
                     input$category))))
     
    # plot
    output$plot <- renderPlot({
      ggplot(data()) +
            geom_point(
                aes_string(
                    x = input$x_var, 
                    y = input$y_var, 
                color = input$category), 
                alpha = input$alpha) + 
        labs(title = 
                paste0("Plot of ", 
                            input$x_var, 
                      " and ", 
                            input$y_var, 
                      " by ", 
                            input$category), 
             x = input$x_var, 
             y = input$y_var)})
    
    # values
    output$values <- renderPrint({
        values <- reactiveValuesToList(x = input,
                                    all.names = TRUE)
        print(values)
    })
  })
}

