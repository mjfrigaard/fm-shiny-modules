#=============================================#
# File name: app.R
# This is code to create: uploadDataApp
# Description: module for uploading flat data files 
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
#=============================================#

# packages -----------------------------------
library(shiny)
library(data.table)
library(tidyverse)
library(purrr)
library(vroom)
library(reactable)
library(haven)
library(readxl)

# shiny.maxRequestSize ------------------------
options(shiny.maxRequestSize = 2000*1024^2)

# uploadDataUI --------------------------------
uploadDataUI <- function(id) {
    tagList(
        sidebarLayout(
            sidebarPanel(width = 4,
                tags$h3("Upload data"),
                # flat files 
                fileInput(NS(namespace = id, id = "upload"), 
                    label = "Upload files (csv, tsv, txt or sas7bdat)", 
                    accept = c(".csv", ".tsv", ".txt", ".sas7bdat", ".dta", ".sav"))),
            mainPanel(
                fluidRow(
                    column(12, 
                    br(), br(),
                    tags$h3("Your data:"),
                    reactableOutput(NS(namespace = id, id = "all_data")))
                        ),
                fluidRow(
                    column(12,
                    br(), 
                    tags$h5("Upload info:"),
                    verbatimTextOutput(NS(namespace = id, id = "values"))
                    )))
                
            )
        )
}

# uploadDataServer -------------------------
uploadDataServer <- function(id) {
    
  moduleServer(id, function(input, output, session) {
      
    # flat files
    load_flat_file <- function(name, path) {
      ext <- tools::file_ext(name)
      switch(ext,
        txt = readr::read_delim(path),
        csv = vroom::vroom(path, delim = ","),
        tsv = vroom::vroom(path, delim = "\t"),
        sas7bdat = haven::read_sas(data_file = path),
        sas7bcat = haven::read_sas(data_file = path),
        sav = haven::read_sav(file = path),
        dta = haven::read_dta(file = path),
        validate("Invalid file; Please upload a data file")
      )
    }

    data <- reactive({
      req(input$upload)
      load_flat_file(name = input$upload$name, path = input$upload$datapath)
    })

    output$all_data <- reactable::renderReactable({
      reactable::reactable(
        data = data(),
        # reactable settings ------
        defaultPageSize = 20,
        resizable = TRUE,
        highlight = TRUE,
        height = 400,
        wrap = FALSE,
        bordered = TRUE,
        searchable = TRUE,
        filterable = TRUE
      )
    })

    reactive_values <- reactive({
      req(input$upload)
      all_values <- reactiveValuesToList(x = input)
      values <- all_values[str_detect(names(all_values), "upload")]
      return(values)
    })

    output$values <- shiny::renderPrint({
      print(reactive_values())
    })
  })
}


# uploadDataDemo -----------------------

uploadDataDemo <- function() {
  
  ui <- fluidPage(
      
      uploadDataUI(id = "data"),
      
  )
  
  server <- function(input, output, session) {
      
    uploadDataServer(id = "data")
    
  }
  
  shinyApp(ui, server)
  
}

uploadDataDemo()