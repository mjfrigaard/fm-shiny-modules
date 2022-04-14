library(shiny)

ui <- fluidPage(
  textInput(inputId = "nm", "name"),
  actionButton(inputId = "clr", "Clear"),
  textOutput(outputId = "hi")
)
server <- function(input, output, session) {
    
  hi <- reactive({paste0("Hi ", input$nm)})
  
  output$hi <- renderText({hi()})
  
  observeEvent(input$clr, {
    updateTextInput(session, "nm", value = "")
  })
}

shinyApp(ui = ui, server = server)