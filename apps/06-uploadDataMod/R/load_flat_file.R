#=====================================================================#
# File name: load_flat_file.R
# This is code to create: function for uploading data files for uploadDataApp
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
#=====================================================================#

# packages ----------------------------------------------------------------
library(shiny)
library(data.table)
library(tidyverse)
library(purrr)
library(vroom)
library(reactable)
library(haven)
library(readxl)

# load_flat_file ----------------------------------------------------------
load_flat_file <- function(name, path) {
  ext <- tools::file_ext(name)
  data <- switch(ext,
    txt = data.table::fread(path),
    csv = data.table::fread(path),
    tsv = data.table::fread(path),
    sas7bdat = haven::read_sas(data_file = path),
    sas7bcat = haven::read_sas(data_file = path),
    sav = haven::read_sav(file = path),
    dta = haven::read_dta(file = path)
  )
  return_data <- as_tibble(data)
  return(return_data)
}