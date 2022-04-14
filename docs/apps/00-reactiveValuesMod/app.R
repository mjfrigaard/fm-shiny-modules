# ===================================================#
# File name: app.R
# This is code to create: reactiveValuesApp (single module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#

# packages -------------------------------------------
library(shiny)
library(tidyverse)

# reactiveValuesUI -----------------------------------
reactiveValuesUI <- function(id) {
  tagList(
      # x
     selectInput(inputId = 
             NS(namespace = id, id = "x_var"), 
        label = code("input$x_var"), selected = "carat",
        choices = c("carat", "depth" , "price")),
      # y
     selectInput(inputId = 
             NS(namespace = id, id = "y_var"), 
                label = code("input$y_var"), selected = "price",
        choices = c("carat", "depth" , "price")),
      # category
      selectInput(inputId = 
              NS(namespace = id, id = "category"),      
        label = code("input$category"), selected = "cut",
        choices = c("cut", "color", "clarity")),
      # alpha
      sliderInput(inputId = 
              NS(namespace = id, id = "alpha"), 
          label = code("input$alpha"), value = 0.5, min = 0.1, 
          max = 0.9, step = 0.1),
      # plot
     plotOutput(outputId = 
             NS(namespace = id, id = "plot")),
     # help text
    tags$h4("Reactive values in ", code("NS = vals")),
    verbatimTextOutput(outputId = 
            NS(namespace = id, id = "values"))
  )
}

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


# reactiveValuesApp ----------------------------
reactiveValuesApp <- function() {
  
  ui <- fluidPage(
      
      reactiveValuesUI(id = "vals")
      
  )
  
  server <- function(input, output, session) {
      
    reactiveValuesServer(id = "vals")
    
  }
  
  shinyApp(ui, server)
  
}

reactiveValuesApp()