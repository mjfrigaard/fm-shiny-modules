# packages ----------------------------------------------------------------
library(shiny)
library(tidyverse)
library(palmerpenguins)
library(reactable)

# dataUI --------------------------------------------
dataUI <- function(id) {
  tagList(
    sidebarLayout(
      sidebarPanel(
        # x variable
        selectInput(
          inputId = NS(namespace = id, id = "x_var"),
          label = "X column", selected = "body_mass_g",
          choices = names(palmerpenguins::penguins)
        ),
        # y variable
        selectInput(
          inputId = NS(namespace = id, id = "y_var"),
          label = "Y column", selected = "bill_length_mm",
          choices = names(palmerpenguins::penguins)
        ),
        # color
        selectInput(
          inputId = NS(namespace = id, id = "color"),
          label = "Color column", selected = "species",
          choices = names(palmerpenguins::penguins)
        )
      ),
      mainPanel(
        # table
        reactableOutput(
          outputId =
            NS(namespace = id, id = "table")
        ),
        # some space
        br(), br(), br(),
        # values
        tags$strong("data ", tags$code("reactiveValues:")),
        verbatimTextOutput(
          outputId =
            NS(namespace = id, id = "value")
        )
      )
    )
  )
}

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
