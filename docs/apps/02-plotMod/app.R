# ===================================================#
# File name: app.R
# This is code to create: plotApp() (demo)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#


# packages -----------------------------------------


library(shiny)
library(tidyverse)
library(palmerpenguins)


# plotUI --------------------------------------------

plotUI <- function(id) {
  tagList(
    # x variable
    selectInput(
      inputId =
        NS(namespace = id, id = "x_var"),
      label = "X column", selected = "body_mass_g",
      choices = names(
        select(
          palmerpenguins::penguins, where(is.numeric)
        )
      )
    ),
    # y variable
    selectInput(
      inputId =
        NS(namespace = id, id = "y_var"),
      label = "Y column", selected = "bill_length_mm",
      choices = names(
        select(
          palmerpenguins::penguins, where(is.numeric)
        )
      )
    ),
    # color
    selectInput(
      inputId =
        NS(namespace = id, id = "color"),
      label = "Color column", selected = "species",
      choices = names(
        select(
          palmerpenguins::penguins, where(is.factor)
        )
      )
    ),
    # plot
    plotOutput(
      outputId =
        NS(namespace = id, id = "plot")
    ),

    # values
    verbatimTextOutput(
      outputId =
        NS(namespace = id, id = "value")
    )
  )
}


# plotServer -----------------------------------

plotServer <- function(id) {
  # create module
  moduleServer(id = id, module = function(input, output, session) {
    # data
    data <- reactive(
      select(
        palmerpenguins::penguins,
        all_of(c(input$x_var, input$y_var, input$color))
      )
    )
    # plot
    output$plot <- renderPlot({
      # y labels
      y_lab <- str_replace_all(input$y_var, "_", " ")
      # x labels
      x_lab <- str_replace_all(input$x_var, "_", " ")
      # graph
      ggplot(data()) +
        geom_point(
          aes_string(
            x = input$x_var,
            y = input$y_var,
            color = input$color
          )
        ) +
        labs(
          title =
            paste0("Scatter plot of ", x_lab, " and ", y_lab),
          x = x_lab,
          y = y_lab
        )
    })
    # reactive values
    output$value <- renderPrint({
      # these will change as inputs change!
      values <- reactiveValuesToList(x = input, all.names = TRUE)
      print(values)
    })
  })
}


# plotApp ------------------------------

plotApp <- function() {
    
  ui <- fluidPage(
    # some space
    br(), br(),
    # plot ui module
    plotUI(id = "graph"),
  )

  server <- function(input, output, session) {
    # plot output module
    plotServer(id = "graph")
  }

  shinyApp(ui, server)
  
}

plotApp()