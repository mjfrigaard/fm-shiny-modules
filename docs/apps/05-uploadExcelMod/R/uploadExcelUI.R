# ===================================================#
# File name: uploadExcelUI.R
# This is code to create: xlsxUploadApp
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
