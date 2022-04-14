# ===================================================#
# File name: dataUI.R
# This is code to create: data UI module for plotdataApp (module)
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


# dataUI ----------------------------------------------------------
dataUI <- function(id) {
    tagList(
        sidebarLayout(
            sidebarPanel(        
                # cols
                selectizeInput(inputId = NS(namespace = id, id = "cols"), 
                    label = "Variables", 
                    choices = names(palmerpenguins::penguins), 
                    multiple = TRUE, 
                    selected = c("species", "body_mass_g", "bill_length_mm"))),
            mainPanel(        
                # table
                reactableOutput(outputId = NS(namespace = id, id = "table")),
                br(), br(), br(),
                # values
                tags$strong("data ", tags$code("reactiveValues:")),
                verbatimTextOutput(outputId = NS(namespace = id, id = "value")))
        )
  )
}

