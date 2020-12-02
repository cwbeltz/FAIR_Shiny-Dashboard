#---
#  title: "FAIR Scores: Creating a Shiny Dashboard"
#  author: "Christopher W. Beltz"
#  date created: "2020-11-30"
#  R version: "4.0.2"
#  input: "NA"
#  output: "NA"

#---

library(here)

source(here::here("code", "00_load-packages.R"))
source(here::here("code", "01_load-data.R"))
source(here::here("code", "02_clean-data.R"))
source(here::here("code", "03_identify-initial-final-versions.R"))
source(here::here("code", "04_calculations.R"))

source(here::here("code", "graphical_theme", "theme_modified_ADC.R"))
source(here::here("code", "graphical_theme", "colors-shapes.R"))

############ UI block ############ 
ui <- fluidPage(sliderInput(inputId = "timeframe", 
                            label = "Choose a number of days", 
                            value = 7, min = 1, max = 31),
                plotOutput("scatterplot"),
                verbatimTextOutput("most_recent_date"))



############ Server block ############ 
server <- function(input, output) {
  
  #report dateTime of most recent dataset upload within the FAIR score dataset
  output$most_recent_date <- renderText(paste0("most recent data uploaded on ", as.POSIXct(most_recent_upload$date), " Pacific Time"))
  
  
  
  #calculate date to subset dataframe based on user input on days before today
  user_defined_date <- reactive({lubridate::floor_date(Sys.time(), "day") - lubridate::days(input$timeframe)})
  
  
  
  #create plot for the FAIR score for each version of a sequenceID
  output$scatterplot <- renderPlot({
    
    #obtain sequenceIds for any updated within from user-specified timeframe
    sequenceId_over_timeperiod <- aggChecks_clean %>% 
      dplyr::filter(dateUploaded > user_defined_date()) %>% 
      dplyr::summarize(sequenceId = unique(sequenceId))
    
    #subset dataframe using list of sequenceIds
    aggChecks_subset <- aggChecks_clean[aggChecks_clean$sequenceId %in% sequenceId_over_timeperiod$sequenceId,]
    
    #graph overall scores on y-axis and sequenceIds on the x-axis, with the score of each pid represented by a point
    aggChecks_subset %>% 
      ggplot(aes(x=sequenceId, y=scoreOverall)) +
      geom_jitter(data=aggChecks_subset[aggChecks_subset$dateSplit=="INTERMEDIATE",], aes(color=dateSplit, fill=dateSplit, shape=dateSplit, size=dateSplit), alpha=0.3, width=0.3, height=0) +
      geom_point(data=aggChecks_subset[aggChecks_subset$dateSplit!="INTERMEDIATE",], aes(color=dateSplit, fill=dateSplit, shape=dateSplit, size=dateSplit)) +
      scale_fill_manual(values=fillValues,
                        name="",
                        labels=c("FINAL", "INITIAL", "INTERMEDIATE")) +
      scale_color_manual(values=colorValues,
                         name="",
                         labels=c("FINAL", "INITIAL", "INTERMEDIATE")) +
      scale_shape_manual(values=shapeValues,
                         name="",
                         labels=c("FINAL", "INITIAL", "INTERMEDIATE")) +
      scale_size_manual(values=sizeValues,
                         name="",
                         labels=c("FINAL", "INITIAL", "INTERMEDIATE")) +
      theme_ADC_modified +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
}



############ shinyApp block ############ 
shinyApp(ui = ui, server = server)

