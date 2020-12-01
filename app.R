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
                plotOutput("scatterplot"),
                verbatimTextOutput("most_recent_date"))



server <- function(input, output) {
  
  output$most_recent_date <- renderText(paste0("most recent data uploaded on ", as.Date(most_recent_upload$date)))
  
  user_defined_date <- reactive({lubridate::floor_date(Sys.time(), "day") - lubridate::days(input$timeframe)})
  
  
  output$scatterplot <- renderPlot({
    sequenceId_over_timeperiod <- aggChecks_clean %>% 
      filter(dateUploaded > user_defined_date()) %>% 
      summarize(sequenceId = unique(sequenceId))
    
    aggChecks_subset <- aggChecks_clean[aggChecks_clean$sequenceId %in% sequenceId_over_timeperiod$sequenceId,]
    
    
    
    #graph overall scores on y-axis and sequenceIds on the x-axis, with the score of each pid represented by a point
    aggChecks_subset %>% 
      ggplot(aes(x=sequenceId, y=scoreOverall)) +
      geom_point() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
}


shinyApp(ui = ui, server = server)

