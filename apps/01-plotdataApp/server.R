# ===================================================#
# File name: server.R
# This is code to create: plotdataApp (no modules)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#


# packages ------------------------------------------
library(shiny)
library(tidyverse)
library(palmerpenguins)
library(reactable)



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
          paste0("Scatter plot of ", x_lab, " and ", y_lab),
        x = x_lab,
        y = y_lab
      )
  })

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
  output$value <- renderPrint({
    all_values <- reactiveValuesToList(x = input, all.names = TRUE)
    values <- all_values[str_detect(names(all_values), "color|x_var|y_var")]
    print(values)
  })
}
