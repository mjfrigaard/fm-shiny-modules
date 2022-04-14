# ===================================================#
# File name: colselUI.R
# This is code to create: columnSelectApp (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#


# datasets ------------------------------------------
source("helpers.R")

# packages ------------------------------------------
library(shiny)
library(tidyverse)
library(reactable)
library(Lahman)

# lahman_data_name_title ------------------------------
lahman_data_name_title <- as_tibble(datasets(package = "Lahman"))

# lahman_ds ------------------------------------------------
lahman_ds <- pkg_data("Lahman")

# colselUI ------------------------------------------
colselUI <- function(id, filter = NULL) {
  tagList(
    sidebarLayout(
      sidebarPanel(
        # dataset
        selectInput(
          inputId = NS(namespace = id, id = "dataset"),
          label = "Dataset", selected = names(lahman_ds)[[1]],
          choices = names(lahman_ds)
        ),
        # columns
        selectizeInput(
          inputId = NS(namespace = id, id = "cols"),
          label = "Columns", selected = NULL,
          choices = names(lahman_ds[[1]]), 
          multiple = TRUE
        )
      ),
      mainPanel(
        htmlOutput(outputId = 
                NS(namespace = id, id = "label")),
        # data_display
        reactableOutput(
          outputId =
            NS(namespace = id, id = "data_display")
        ),
        # some space
        br(), br(), br(),
        # values
        tags$strong("data ", tags$code("reactiveValues:")),
        verbatimTextOutput(
          outputId =
            NS(namespace = id, id = "values")
        )
      )
    )
  )
}