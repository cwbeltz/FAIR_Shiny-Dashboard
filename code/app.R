#---
#  title: "FAIR Scores: Creating a Shiny Dashboard"
#  author: "Christopher W. Beltz"
#  date created: "2020-11-30"
#  R version: "4.0.2"
#  input: "NA"
#  output: "NA"

#---

library(here)

source(here("code", "00_load-packages.R"))
source(here("code", "01_load-data.R"))
source(here("code", "02_clean-data.R"))
source(here("code", "03_calculations.R"))
source(here("code", "04_test-figure.R"))



ui <- fluidPage(sliderInput(inputId = "timeframe", 
                            label = "Choose a number of days", 
                            value = 7, min = 1, max = 31),
                plotOutput("scatterplot"))



server <- function(input, output) {
  output$scatterplot <- renderPlot({
    aggChecks_subset %>% 
      ggplot(aes(x=sequenceId, y=scoreOverall)) +
      geom_point() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
}


shinyApp(ui = ui, server = server)

