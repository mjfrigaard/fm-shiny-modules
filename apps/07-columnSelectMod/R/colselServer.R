# ===================================================#
# File name: colselServer.R
# This is code to create: columnSelectApp (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#


# helpers ------------------------------------------
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

# colselServer ---------------------------------
colselServer <- function(id) {
  moduleServer(id = id, module = function(input, output, session) {

    # data ----------------------------------
    data <- eventReactive(input$cols, {
      validate(
        need(input$dataset, "please select a dataset"),
        need(input$cols, "please select a column")
      )
      col_data <- select(.data = lahman_ds[[input$dataset]], any_of(input$cols))
      return(col_data)
    })


    # label ----------------------------------
    output$label <- renderUI({
      req(input$dataset)
      data_label <- dplyr::filter(
        .data = lahman_data_name_title,
        dataset %in% input$dataset
      ) %>%
        select(.data = ., title) %>%
        purrr::as_vector(.x = .) %>%
        base::unname(obj = .)
      return(h3(data_label))
    })

    # column drop-down options  ----------------
    observeEvent(eventExpr = input$dataset, {
      lahman_data <- input$dataset
      if (is.null(lahman_data)) {
        lahman_data <- character(0)
      } else {
        lahman_ds_names <- names(lahman_ds[[dataset538]])
        updateSelectizeInput(
          session = session, inputId = "cols",
          choices = lahman_ds_names, selected = lahman_ds_names
        )
      }
    })

    # observeEvent (reactable table) -------------------------
    observeEvent(eventExpr = data(), handlerExpr = {
      # data display -------------------------
      output$data_display <- reactable::renderReactable({
        reactable::reactable(
          data = data(),
          # reactable settings ------
          defaultPageSize = 10,
          resizable = TRUE,
          highlight = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          searchable = TRUE,
          filterable = TRUE
        )
      })
    })

    # reactive values -------------------------
    output$values <- shiny::renderPrint({
      all_values <- reactiveValuesToList(
        x = input,
        all.names = TRUE
      )
      values <- all_values[str_detect(names(all_values), "reactable", TRUE)]
      print(values)
    })
  })
}
