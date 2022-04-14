# ===================================================#
# File name: app.R
# This is code to create: uploadExcelApp
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-04
# MIT License
# Version: 0.1.1
# ===================================================#


# packages ------------------------------------------
library(shiny)
library(data.table)
library(tidyverse)
library(purrr)
library(vroom)
library(reactable)
library(haven)
library(readxl)

# shiny.maxRequestSize -----------------------------
options(shiny.maxRequestSize = 2000 * 1024^2)
bgl <- tagList(tags$hr(style = "border-top: 3px solid #00B500;"))
mgl <- tagList(tags$hr(style = "border-top: 2px solid #00B500;"))
lgl <- tagList(tags$hr(style = "border-top: 1px solid #00B500;"))

# uploadExcelUI ------------------------------------
uploadExcelUI <- function(id) {
  tagList(
    h3("Excel file upload module"),
    bgl,
    fileInput(
      # xlsx_file -------
      inputId = NS(namespace = id, id = "xlsx_file"),
      label = tags$strong("File input (must be .xslx):", tags$code("input$xlsx_file"), tags$a(href = "https://github.com/mjfrigaard/my-modules/raw/main/apps/uploadExcelApp/data-raw/xlsx/lahman.xlsx", "(download example file)")), 
      accept = c(".xlsx")
    ),
    mgl,
    # sheets ---------
    h4(tags$strong("Sheets names:", tags$code("output$sheets"))),
    verbatimTextOutput(outputId = NS(namespace = id, id = "sheets"), 
      placeholder = TRUE),
    br(),
    # select_sheets ---------
    selectInput(
      inputId = NS(namespace = id, id = "select_sheets"),
      label = h4(tags$strong("Choose a sheet to import:", tags$code("input$select_sheets"))),
      choices = ""
    ),
    mgl,
    # get data! ----------
    h4(tags$strong("Click to import:", tags$code("input$getData"))),
    actionButton(inputId = NS(namespace = id, id = "getData"), 
      label = "Get Data"),
    br(), 
    # display ---------
    h4(tags$strong("Excel table:",tags$code("output$display"))),
    br(),
    reactable::reactableOutput(outputId = NS(namespace = id, 
      id = "display")),
    br(), 
    mgl,
    # values ---------
    h4(tags$strong("Reactive values:", tags$code("output$values"))),
    verbatimTextOutput(outputId = NS(namespace = id, id = "values"), 
      placeholder = TRUE),
  )
}

# uploadExcelServer ---------------------------------
uploadExcelServer <- function(id) {
  
  moduleServer(id, function(input, output, session) {
    # xlsx_sheets() ----
    xlsx_sheets <- reactive({
      req(input$xlsx_file)
      xlsx_sheets <- readxl::excel_sheets(path = input$xlsx_file$datapath)
      return(xlsx_sheets)
    })
    
    # print sheets
    output$sheets <- renderPrint({
      req(input$xlsx_file)
      print(xlsx_sheets())
    })
    
    # sheet drop-down options 
    observe({
      inFile <- input$xlsx_file
      if (is.null(inFile)) {
        return(NULL)
      } else {
        xlsx_sheets <- readxl::excel_sheets(path = input$xlsx_file$datapath)
        updateSelectInput(session, "select_sheets", choices = xlsx_sheets)
      }
    })
    
    # action button, click for data!
    observeEvent(input$getData, {
      worksheet_data <- readxl::read_excel(path = input$xlsx_file$datapath, 
                                            sheet = input$select_sheets)
      # display table
      output$display <- reactable::renderReactable(
        reactable(data = worksheet_data, 
        # reactable settings ------
        defaultPageSize = 10,
        width = 1000,
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        height = 350,
        wrap = FALSE,
        bordered = TRUE,
        searchable = TRUE,
        filterable = TRUE)
      )
    })
    
    # reactive values
    reactive_values <- reactive({
      req(input$xlsx_file)
      reactive_values <- reactiveValuesToList(x = input, all.names = TRUE)
      # remove reactable values 
      values <- reactive_values[str_detect(string = names(reactive_values), 
                                           pattern = "reactable", 
                                           negate = TRUE)]
      print(values)
    })
    # print reactive values
    output$values <- shiny::renderPrint({
      print(reactive_values())
    })
  })
}

# uploadExcelApp -----------------------------
uploadExcelApp <- function() {
  ui <- fluidPage(
    uploadExcelUI(id = "xlsx"),
  )

  server <- function(input, output, session) {
    uploadExcelServer(id = "xlsx")
  }

  shinyApp(ui, server)
}

uploadExcelApp()
