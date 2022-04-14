# ===================================================#
# File name: uploadExcelServer.R
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
