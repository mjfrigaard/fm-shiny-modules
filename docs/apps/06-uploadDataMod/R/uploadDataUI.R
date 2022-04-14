# packages ----------------------------------------------------------------
library(shiny)
library(tidyverse)
library(purrr)
library(vroom)
library(reactable)
library(haven)
library(readxl)


# uploadDataUI ----------------------------------------------------------------
uploadDataUI <- function(id) {
    tagList(
        sidebarLayout(
            sidebarPanel(width = 4,
                tags$h3("Upload data"),
                # flat files 
                fileInput(NS(namespace = id, id = "upload"), 
                    label = "Upload files (csv, tsv, txt or sas7bdat)", 
                    accept = c(".csv", ".tsv", ".txt", ".sas7bdat", ".dta", ".sav")),
                # xlsx files
                fileInput(NS(namespace = id, id = "xlsx"), 
                    label = "Upload xlsx file here", 
                    accept = c(".xlsx", ".tsv", "sas7bdat", "sav", "dta")),
                # sheets
                verbatimTextOutput(outputId = NS(namespace = id, id = "sheets"))
                ),
            mainPanel(
                fluidRow(
                    column(8, 
                    br(), br(),
                    tags$h3("Your data:"),
                    reactableOutput(NS(namespace = id, id = "all_data")))
                        ),
                fluidRow(
                    column(8,
                    br(), 
                    tags$h5("Upload info:"),
                    verbatimTextOutput(NS(namespace = id, id = "values"))
                    )))
                
            )
        )
}