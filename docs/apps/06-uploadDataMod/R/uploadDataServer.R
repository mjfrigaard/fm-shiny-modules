# packages ----------------------------------------------------------------
library(shiny)
library(tidyverse)
library(purrr)
library(vroom)
library(reactable)
library(haven)
library(readxl)

# uploadDataServer ------------------------------------------------------------
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
