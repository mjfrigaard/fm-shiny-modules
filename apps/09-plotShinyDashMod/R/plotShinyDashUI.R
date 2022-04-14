# ===================================================#
# File name: plotShinyDashUI.R
# This is code to create: data UI module for plotShinyDashApp (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#

# packages ----------------------------------------------------------------
library(shiny)
library(tidyverse)
library(palmerpenguins)
library(reactable)
library(shinydashboard)


# plotShinyDashUI -----------------------------------------
plotShinyDashUI <- function(id) {
  tagList(
    dashboardPage(
      ## sidebar -----------------------------------------
      sidebar = shinydashboard::dashboardSidebar(
        collapsed = FALSE,
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
        )
      ),
      ## header -----------------------------------------
      header = shinydashboard::dashboardHeader(title = "plotShinyDashApp"),

      ## body -----------------------------------------
      body = shinydashboard::dashboardBody(
        fluidRow(
          box(width = 12, 
              title = "Plot", 
              solidHeader = TRUE, 
              collapsible = TRUE,
            # plot
            plotOutput(
              outputId =
                NS(namespace = id, id = "plot")
            )
          )
        ),
        # values
        fluidRow(
          box(width = 12, 
              title = "reactiveValues", 
              solidHeader = TRUE, 
              collapsible = TRUE,
            verbatimTextOutput(
              outputId = NS(namespace = id, id = "value")
            )
          )
        )
      ),
      title = "Example layout", skin = "black"
    )
  )
}

