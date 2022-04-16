library(shiny)
library(tidyverse)
library(palmerpenguins)
library(reactable)

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