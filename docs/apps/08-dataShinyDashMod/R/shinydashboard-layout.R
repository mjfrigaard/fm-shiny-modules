# ===================================================#
# File name: shinydashboard-layout.R
# This is code to create: plotdataAppSD (modules)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#


# packages ------------------------------------------

library(shiny)
library(shinydashboard)



# UI ------------------------------------------
ui <- shinydashboard::dashboardPage(
        sidebar = shinydashboard::dashboardSidebar(collapsed = FALSE),
        header = shinydashboard::dashboardHeader(title = "Header"),
        body = shinydashboard::dashboardBody(), 
        title = "Example layout", 
        skin = "black"
)


# server ---------------------------------------
server <- function(input, output) { }

shiny::shinyApp(ui = ui, server = server)