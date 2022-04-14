# ===================================================#
# File name: modules.R
# This is code to create: modules for plotdataApp (module)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#

# packages -------------------------------------------
library(shiny)
library(tidyverse)
library(palmerpenguins)
library(reactable)


# dataShinyDashUI ----------------------------------------------------------
dataShinyDashUI <- function(id) {
  tagList(
    shinydashboard::dashboardPage(
      sidebar = shinydashboard::dashboardSidebar(
        collapsed = FALSE,
        selectizeInput(
          inputId = NS(namespace = id, id = "cols"),
          label = "Variables",
          choices = names(palmerpenguins::penguins),
          multiple = TRUE,
          selected = c("species", "body_mass_g", "bill_length_mm")
        )
      ),
      header = shinydashboard::dashboardHeader(title = "dataShinyDashApp"),
      body = shinydashboard::dashboardBody(
        # table
        reactableOutput(outputId = NS(namespace = id, id = "table")),
        br(), br(), br(),
        # values
        tags$strong("data ", tags$code("reactiveValues:")),
        verbatimTextOutput(outputId = NS(namespace = id, id = "value"))
      ),
      title = "Example layout", skin = "black"
    )
  )
}

# dataShinyDashServer -----------------------------------------------------
dataShinyDashServer <- function(id) {
  moduleServer(id = id, module = function(input, output, session) {

    # data
    data <- reactive({
      select(palmerpenguins::penguins, all_of(input$cols))
    })

    # table display
    output$table <- reactable::renderReactable({
      req(input$cols)
      reactable::reactable(
        data = data(),
        # reactable settings ------
        defaultPageSize = 10,
        resizable = TRUE,
        highlight = TRUE,
        height = 400,
        wrap = FALSE,
        bordered = TRUE,
        searchable = TRUE,
        filterable = TRUE
      )
    })

    # reactive values
    output$value <- shiny::renderPrint({
      req(input$cols)
      all_values <- reactiveValuesToList(x = input, all.names = TRUE)
      values <- all_values[str_detect(names(all_values), "cols")]
      print(values)
    })
  })
}


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



# plotShinyDashServer -------------------------------
plotShinyDashServer <- function(id) {
  # create module
  moduleServer(id = id, module = function(input, output, session) {
    # data
    data <- reactive(
      select(
        palmerpenguins::penguins,
        all_of(c(input$x_var, input$y_var, input$color))
      )
    )
    # plot
    output$plot <- renderPlot({
      # y labels
      y_lab <- str_replace_all(input$y_var, "_", " ")
      # x labels
      x_lab <- str_replace_all(input$x_var, "_", " ")
      # graph
      ggplot(data()) +
        geom_point(
          aes_string(
            x = input$x_var,
            y = input$y_var,
            color = input$color
          )
        ) +
        labs(
          title =
            paste0("Scatter plot of ", x_lab, " and ", y_lab),
          x = x_lab,
          y = y_lab
        )
    })
    # reactive values
    output$value <- renderPrint({
      # these will change as inputs change!
      values <- reactiveValuesToList(x = input, all.names = TRUE)
      print(values)
    })
  })
}

