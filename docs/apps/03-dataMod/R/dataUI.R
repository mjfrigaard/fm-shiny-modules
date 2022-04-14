# ===================================================#
# File name: dataUI.R
# This is code to create: dataUI for palmer penguins data (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#

# packages ----------------------------------------------------------------
library(shiny)
library(data.table)
library(tidyverse)
library(purrr)
library(vroom)
library(reactable)
library(palmerpenguins)
library(haven)
library(readxl)


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
