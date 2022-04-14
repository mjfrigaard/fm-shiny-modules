#=====================================================================#
# File name: load_excel_files.R
# This is code to create: function for uploading data files for uploadExcelApp
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
#=====================================================================#

# load_xslx ---------------------------------------------------------------
load_xslx <- function(name, path) {
    ext <- tools::file_ext(name)
    xlsx_data <- path %>%
         readxl::excel_sheets(path = .) %>%
         purrr::set_names() %>% 
         purrr::map_df(~ readxl::read_excel(path = path, sheet = .x), 
                        .id = "sheet")
        return(xlsx_data)
}