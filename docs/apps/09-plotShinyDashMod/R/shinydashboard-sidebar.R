# ===================================================#
# File name: shinydashboard-sidebar.R
# This is code to create: plotdataAppSD (modules)
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-03
# MIT License
# Version: 0.1.0
# ===================================================#


# packages ------------------------------------------
library(shiny)
library(tidyverse)
library(palmerpenguins)
library(reactable)
library(shinydashboard)

sidebar <- dashboardSidebar(
  sidebarSearchForm(label = "Search...", "searchText", "searchButton"),
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", icon = icon("th"), tabName = "widgets", badgeLabel = "new",
             badgeColor = "green"
    ),
    menuItem("Charts", icon = icon("bar-chart-o"),
      menuSubItem("Chart sub-item 1", tabName = "subitem1"),
      menuSubItem("Chart sub-item 2", tabName = "subitem2")
    ),
    menuItem("Source code for app", icon = icon("file-code-o"),
      href = "https://github.com/rstudio/shinydashboard/blob/gh-pages/_apps/sidebar/app.R"
    )
  ),

  sliderInput("threshold", "Threshold:", 1, 20, 5),
  textInput("text", "Text input")
)

body <- dashboardBody()

ui <- dashboardPage(
  dashboardHeader(title = "My Dashboard"),
  sidebar,
  dashboardBody()
)

server <- function(input, output) { }

shinyApp(ui, server)
