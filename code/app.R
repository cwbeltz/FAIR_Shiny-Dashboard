#---
#  title: "FAIR Scores: Creating a Shiny Dashboard"
#  author: "Christopher W. Beltz"
#  date created: "2020-11-30"
#  R version: "4.0.2"
#  input: "NA"
#  output: "NA"

#---

library(shiny)

ui <- fluidPage(sliderInput(inputId = "num", 
                            label = "Choose a number", 
                            value = 25, min = 1, max = 100),
                plotOutput("hist"))


server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num))
  })
}


shinyApp(ui = ui, server = server)

