# ===================================================#
# File name: app.R
# This is code to create: plotShinyDashApp (modules)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#

# packages -----------------------------------------
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


# plotShinyDashServer ---------------------------------
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

# plotShinyDashApp -------------------------------
plotShinyDashApp <- function() {
  # plotShinyDashUI module
  ui <- plotShinyDashUI(id = "graph")

  server <- function(input, output, session) {
    # plotShinyDashServer module
    plotShinyDashServer(id = "graph")
  }

  shinyApp(ui, server)
}

plotShinyDashApp()
