# packages ----------------------------------------------------------------
library(shiny)
library(tidyverse)
library(palmerpenguins)


# plotUI ------------------------------------------------------------------
plotUI <- function(id) {
  tagList(
      # x variable 
    selectInput(inputId = NS(namespace = id, id = "x_var"), 
        label = "palmerpenguins::penguins X column", selected = 'body_mass_g',
        choices = names(select(palmerpenguins::penguins, where(is.numeric)))),
      # y variables 
    selectInput(inputId = NS(namespace = id, id = "y_var"), 
        label = "palmerpenguins::penguins Y column", selected = 'bill_length_mm',
        choices = names(select(palmerpenguins::penguins, where(is.numeric)))),
      # alpha
    selectInput(inputId = NS(namespace = id, id = "color"), 
        label = "palmerpenguins::penguins color column", selected = 'species',
        choices = names(select(palmerpenguins::penguins, where(is.factor)))),
      # plot
    plotOutput(outputId = NS(namespace = id, id = "plot")),
      # help text
    tags$h4("These are the reactive values in ", code("plotUI()"), " and ", code("plotServer()")),
      # values 
    verbatimTextOutput(outputId = NS(namespace = id, id = "value")),
      # help text 
    tags$em("Notice that when you change the inputs, the reactive values change (", code("$x_var"), " and ", code("$y_var"), ")"),
  )
}

# plotServer ------------------------------------------------------------------
plotServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # data 
    data <- reactive(
        select(palmerpenguins::penguins, 
            all_of(c(input$x_var, input$y_var, input$color)))
        )
    # plot
    output$plot <- renderPlot({
        # labels
      y_name <- str_replace_all(input$y_var, "_", " ")
      y_lab <- str_replace_all(y_name, "mm", "(mm)")
      x_name <- str_replace_all(input$x_var, "_", " ")
      x_lab <- str_replace_all(x_name, "mm", "(mm)")
      # graph
      ggplot(data()) +
            geom_point(aes_string(x = input$x_var, y = input$y_var, 
                color = input$color)) + 
        labs(title = 
                paste0("Histogram of ", x_lab, " and ", y_lab), 
             x = x_lab, 
             y = y_lab
            )
      
    }, res = 96)
    # reactive values 
    output$value <- renderPrint({
        values <- reactiveValuesToList(x = input, all.names = TRUE)
        print(values)
    })
    
  })
}

# reactiveValuesUI ----------------------------------------------------------
reactiveValuesUI <- function(id) {
  tagList(
      # help text
    tags$h4("These are the reactive values in ", code("reactiveValuesUI()"), " and ", code("reactiveValuesServer()")),
    verbatimTextOutput(outputId = NS(namespace = id, id = "value")),
      # help text
      tags$em("Notice that is an empty", code("named list()"), " because there aren't any reactive values in this module!"),
  )
}

# reactiveValuesServer -----------------------------------------------------
reactiveValuesServer <- function(id) {
  moduleServer(id = id, module = function(input, output, session) {
    output$value <- renderPrint({
        values <- reactiveValuesToList(x = input, all.names = TRUE)
        print(values)
    })
  })
}