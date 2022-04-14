# ===================================================#
# File name: app.R
# This is code to create: columnSelectApp (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-07
# MIT License
# Version: 0.1.0
# ===================================================#

# packages ------------------------------------------
library(shiny)
library(tidyverse)
library(reactable)
library(fivethirtyeight)
library(fivethirtyeight)


# helpers ------------------------------------------
source("helpers.R")

# fivethirtyeight_data_name_title ------------------------------
fivethirtyeight_data_name_title <- as_tibble(datasets(package = "fivethirtyeight"))

# fivethirtyeight_ds ------------------------------------------------
fivethirtyeight_ds <- pkg_data("fivethirtyeight")
# remove datasets with large text
fivethirtyeight_ds[["ahca_polls"]] = NULL
fivethirtyeight_ds[["avengers"]] = NULL
fivethirtyeight_ds[["biopics"]] = NULL
fivethirtyeight_ds[["tenth_circuit"]] = NULL
fivethirtyeight_ds[["hiphop_cand_lyrics"]] = NULL
fivethirtyeight_ds[["mad_men"]] = NULL
fivethirtyeight_ds[["police_killings"]] = NULL

# colselUI -------------------------------------
colselUI <- function(id, filter = NULL) {
  tagList(
    sidebarLayout(
      sidebarPanel(
        # dataset
        selectInput(
          inputId = NS(namespace = id, id = "dataset"),
          label = "Dataset", selected = names(fivethirtyeight_ds)[[1]],
          choices = names(fivethirtyeight_ds)
        ),
        # columns
        selectizeInput(
          inputId = NS(namespace = id, id = "cols"),
          label = "Columns", selected = NULL,
          choices = names(fivethirtyeight_ds[[1]]),
          multiple = TRUE
        )
      ),
      mainPanel(
        htmlOutput(
          outputId =
            NS(namespace = id, id = "label")
        ),
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


# colselServer ---------------------------------
colselServer <- function(id) {
  moduleServer(id = id, module = function(input, output, session) {

    # data ----------------------------------
    data <- eventReactive(input$cols, {
      validate(
        need(input$dataset, "please select a dataset"),
        need(input$cols, "please select a column")
      )
      col_data <- select(fivethirtyeight_ds[[input$dataset]], 
                        any_of(input$cols))
      return(col_data)
    })


    # label ----------------------------------
    output$label <- renderUI({
      req(input$dataset)
      data_label <- dplyr::filter(
        .data = fivethirtyeight_data_name_title,
        dataset %in% input$dataset
      ) %>%
        select(.data = ., display_title) %>%
        purrr::as_vector(.x = .) %>%
        base::unname(obj = .)
        data_label_out <- h4("Title, '", em(data_label), "'")
      return(data_label_out)
    })

    # column drop-down options  ----------------
    observeEvent(eventExpr = input$dataset, {
      fivethirtyeight_data <- input$dataset
      if (is.null(fivethirtyeight_data)) {
        fivethirtyeight_data <- character(0)
      } else {
        names538 <- names(fivethirtyeight_ds[[fivethirtyeight_data]])
        updateSelectizeInput(
          session = session, inputId = "cols",
          choices = names538, selected = names538
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
          outlined = TRUE,
          resizable = TRUE,
          highlight = TRUE,
          wrap = TRUE,
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
      values <- all_values[str_detect(names(all_values), 
                                      "reactable", 
                                      TRUE)]
      print(values)
    })
  })
}




# columnSelectApp ------------------------------
columnSelectApp <- function() {
  ui <- fluidPage(
    h3(code("fivethirtyeight")), h3("columnSelectApp"),
    colselUI(id = "columns"),
  )

  server <- function(input, output, session) {
    colselServer(id = "columns")
  }

  shinyApp(ui, server)
}

columnSelectApp()
