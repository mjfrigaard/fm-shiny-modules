#=====================================================================#
# File name: load_file.R
# This is code to create: function for uploading data files for uploadExcelApp
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
#=====================================================================#

# packages ----------------------------------------------------------------
library(shiny)
library(tidyverse)
library(purrr)
library(vroom)
library(reactable)
library(haven)
library(readxl)


# load_file ---------------------------------------------------------------
load_file <- function(name, path) {
    ext <- tools::file_ext(name)
    if (ext == "xlsx") {
    xlsx_data <- xlsx_path %>%
                 readxl::excel_sheets(path = .) %>%
                 purrr::set_names() %>% 
                 purrr::map_df(~ readxl::read_excel(path = path, sheet = .x), 
                         .id = "sheet")
        return(xlsx_data)
    } else {
        switch(ext,
            txt = readr::read_delim(path),
            csv = vroom::vroom(path, delim = ","),
            tsv = vroom::vroom(path, delim = "\t"),
            sas7bdat = haven::read_sas(data_file = path),
            sas7bcat = haven::read_sas(data_file = path),  
            sav = haven::read_sav(file = path),
            dta = haven::read_dta(file = path),
        )
    }
}

# fs::dir_tree("data-raw/xlsx/")
# xlsx_path <- "data-raw/xlsx/lahman.xlsx"
# xlsx_data_upload <- xlsx_path %>%
#   excel_sheets() %>%
#   set_names() %>% 
#   map_df(~ read_excel(path = xlsx_path, sheet = .x), .id = "sheet")