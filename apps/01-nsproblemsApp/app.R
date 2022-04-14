# ===================================================#
# File name: app.R
# This is code to create: nsproblemsApp (single module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-04-14
# MIT License
# Version: 0.1.0
# ===================================================#



# package -----------------------------------------------------------------
library(shiny)
library(tidyverse)
library(palmerpenguins)
library(reactable)



# ui ----------------------------------------------------------------------
ui <- fluidPage(title = "nsproblemsApp",
  sidebarLayout(
    sidebarPanel(
      # x variable graph
      selectInput(
        inputId = "x_var",
        label = "X column (graph)",
        selected = "body_mass_g",
        choices = names(
          select(
            palmerpenguins::penguins, where(is.numeric)
          )
        )
      ),
      # x variable table
      selectInput(
        inputId = "x_var",
        label = "X column (table)",
        selected = "body_mass_g",
        choices = names(palmerpenguins::penguins)
      ),
      # y variable graph
      selectInput(
        inputId = "y_var",
        label = "Y column (graph)",
        selected = "bill_length_mm",
        choices = names(
          select(
            palmerpenguins::penguins, where(is.numeric)
          )
        )
      ),
      # y variable table
      selectInput(
        inputId = "y_var",
        label = "Y column (table)",
        selected = "bill_length_mm",
        choices = names(palmerpenguins::penguins)
      ),
      # color graph
      selectInput(
        inputId = "color",
        label = "Color column (graph)",
        selected = "species",
        choices = names(
          select(
            palmerpenguins::penguins, where(is.factor)
          )
        )
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
      # plot
      plotOutput(outputId = "plot"),
      br(), br(),
      reactableOutput(outputId = "table"),
      # values
      tags$strong(tags$code("reactiveValues:")),
      verbatimTextOutput(outputId = "value")
    )
  )
)


# server ------------------------------------------------------------------
server <- function(input, output, session) {
  # data
  data <- reactive(
    select(
      palmerpenguins::penguins,
      all_of(c(input$x_var, input$y_var, input$color))
    )
  )

  # plot display
  output$plot <- renderPlot({
    # y labels
    y_lab <- str_replace_all(input$y_var, "_", " ")
    # x labels
    x_lab <- str_replace_all(input$x_var, "_", " ")
    # graph
    ggplot(data()) +
      geom_point(aes_string(
        x = input$x_var, 
          y = input$y_var,
        color = input$color
      )) +
      labs(
        title =
          paste0("Histogram of ", x_lab, " and ", y_lab),
        x = x_lab,
        y = y_lab
      )
  })

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
      searchable = TRUE,
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

shinyApp(ui = ui, server = server)