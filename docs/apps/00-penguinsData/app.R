# ===================================================#
# File name: app.R
# This is code to create: penguinsData (no modules)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-04-14
# MIT License
# Version: 0.1.0
# ===================================================#


library(shiny)
library(tidyverse)
library(palmerpenguins)
library(reactable)

ui <- fluidPage(
  titlePanel( "penguinsData"),
  sidebarLayout(
    sidebarPanel(
      # x variable table
      selectInput(
        inputId = "x_var",
        label = "X column (table)",
        selected = "body_mass_g",
        choices = names(palmerpenguins::penguins)
      ),
      # y variable table
      selectInput(
        inputId = "y_var",
        label = "Y column (table)",
        selected = "bill_length_mm",
        choices = names(palmerpenguins::penguins)
      ),
      # color table
      selectInput(
        inputId = "color",
        label = "Color column (table)",
        selected = "species",
        choices = names(palmerpenguins::penguins)
      )
    ),
    mainPanel(
      br(), br(),
      reactableOutput(outputId = "table"),
      # values
      tags$strong(tags$code("reactiveValues:")),
      verbatimTextOutput(outputId = "value")
    )
  )
)

server <- function(input, output, session) {
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
      defaultPageSize = 10,
      resizable = TRUE,
      highlight = TRUE,
      height = 350,
      wrap = FALSE,
      bordered = TRUE,
      filterable = TRUE
    )
  })

  # reactive values
  output$value <- renderPrint({
    all_values <- reactiveValuesToList(x = input, all.names = TRUE)
    values <- all_values[str_detect(names(all_values), "color|x_var|y_var")]
    print(values)
  })
}

shinyApp(ui = ui, server = server, 
         options = list(height = 1100, width = 800))