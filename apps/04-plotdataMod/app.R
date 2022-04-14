# ===================================================#
# File name: app.R
# This is code to create: plotdataApp (modules)
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

# medium black line (mbl)
mbl <- tagList(tags$hr(style = "border-top: 2px solid #333333;"))

# plotUI ---------------------------------------------
plotUI <- function(id) {
  tagList(
    sidebarLayout(
      sidebarPanel(
        # x variable
        selectInput(
          inputId = NS(namespace = id, id = "x_var"),
          label = "X column",
          selected = "body_mass_g",
          choices = names(
            select(
              palmerpenguins::penguins, where(is.numeric)
            )
          )
        ),
        # y variable
        selectInput(
          inputId = NS(namespace = id, id = "y_var"),
          label = "Y column",
          selected = "bill_length_mm",
          choices = names(
            select(
              palmerpenguins::penguins, where(is.numeric)
            )
          )
        ),
        # color
        selectInput(
          inputId = NS(namespace = id, id = "color"),
          label = "Color column",
          selected = "species",
          choices = names(
            select(
              palmerpenguins::penguins, where(is.factor)
            )
          )
        )
      ),
      mainPanel(
        fluidRow(
          column(
            12,
            # plot
            plotOutput(outputId = NS(
              namespace = id,
              id = "plot"
            )),
          )
        ),
        fluidRow(
          column(
            12,
            # values
            tags$strong(tags$code("reactiveValues:")),
            verbatimTextOutput(outputId = NS(
              namespace = id,
              id = "value"
            ))
          )
        )
      )
    )
  )
}

# dataUI -------------------------------------------
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
        # some padding and title
        fluidRow(
          column(
            12,
            # table
            reactableOutput(outputId = NS(
              namespace = id,
              id = "table"
            ))
          )
        ),
        fluidRow(
          column(
            12,
            # more padding and title
            br(), br(),
            # values
            tags$strong(tags$code("reactiveValues:")),
            verbatimTextOutput(outputId = NS(
              namespace = id,
              id = "value"
            ))
          )
        )
      )
    )
  )
}


# plotServer ----------------------------------------
plotServer <- function(id) {
  # create module
  moduleServer(
    id = id,
    module = function(input, output, session) {
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
      output$value <- shiny::renderPrint({
        all_values <- reactiveValuesToList(
          x = input,
          all.names = TRUE
        )
        input_values <- str_detect(
          names(all_values), "reactable", TRUE
        )
        values <- all_values[input_values]
        print(values)
      })
    }
  )
}

# dataServer ---------------------------------------
dataServer <- function(id) {
  moduleServer(
    id = id,
    module = function(input, output, session) {
      # data
      data <- reactive(
        select(
          palmerpenguins::penguins,
          all_of(c(input$x_var, input$y_var, input$color))
        )
      )

      # table display
      output$table <- reactable::renderReactable({
        reactable::reactable(
          data = data(),
          # reactable settings 
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
      output$value <- shiny::renderPrint({
        all_values <- reactiveValuesToList(
          x = input,
          all.names = TRUE
        )
        input_values <- str_detect(
          names(all_values), "reactable", TRUE
        )
        values <- all_values[input_values]
        print(values)
      })
    }
  )
}





# plotdataApp ------------------------------------

plotdataApp <- function() {
  ui <- fluidPage(
    h3("Plot module"),
      # plot UI module
    plotUI(id = "graph"),
    mbl,
    br(), br(), br(),
    h3("Data module"),
      # data UI module
    dataUI(id = "data")
  )

  server <- function(input, output, session) {
      # plot server module
    plotServer(id = "graph")
      # data server module
    dataServer(id = "data")
  }

  shinyApp(ui, server)
}

plotdataApp()
