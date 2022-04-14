# ===================================================#
# File name: load_xlsx.R
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


# load_xslx ------------------------------------------
load_xslx <- function(name, path) {
    ext <- tools::file_ext(name)
    xlsx_data <- path %>% 
        readxl::excel_sheets() %>% 
        purrr::set_names() %>% 
        purrr::map(read_excel, path = path)
        return(xlsx_data)
}