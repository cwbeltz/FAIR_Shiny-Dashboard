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
ui <- fluidPage(
  tags$h1("FAIR Metadata Analysis Tool"),
  fluidRow(
    column(4, 
           wellPanel(sliderInput(inputId = "timeframe", 
                       label = "Date Range:",
                       min = as.Date("2016-03-21","%Y-%m-%d"),
                       max = as.Date(Sys.Date(),"%Y-%m-%d"),
                       value = c(Sys.Date()-14, Sys.Date()), 
                       timeFormat="%Y-%m-%d", step = 7),
                     verbatimTextOutput("most_recent_date"))),
    column(8,
           plotOutput("binned_scatterplot_packageLevel")),
    fluidRow(
      column(4, plotOutput("barplot_detailed_scores")),
      column(8, plotOutput("linegraph_FAIR_overview"))
    )
  )
)



############ Server block ############ 
server <- function(input, output) {
  
  #calculate date to subset dataframe based on user input on days before today
  #user_defined_date <- reactive({lubridate::floor_date(Sys.time(), "day") - lubridate::days(input$timeframe)})
  
  #report dateTime of most recent dataset upload within the FAIR score dataset
  output$most_recent_date <- renderText(paste0("most recent data uploaded on ", as.POSIXct(most_recent_upload$date), " PT"))
  
  
  
####barplot
  output$barplot_detailed_scores <- renderPlot({
    
    plotData_sidewaysScatter <- aggScore_clean %>%
      dplyr::filter(dateSplit != "INTERMEDIATE") %>% 
      dplyr::filter(dateUploaded >= input$timeframe[1] & dateUploaded <= input$timeframe[2]) %>%
      group_by(dateSplit) %>% 
      summarise(OVERALL = mean(scoreOverall),
                Findable = mean(scoreFindable),
                Accessible = mean(scoreAccessible),
                Interoperable = mean(scoreInteroperable),
                Reusable = mean(scoreReusable)) %>%
      pivot_longer(cols=c(OVERALL, Findable, Accessible, Interoperable, Reusable),
                   names_to = "scoreType",
                   values_to = "meanScore")
    
    #change dateSplit variable names to re-order in legend
    plotData_sidewaysScatter$dateSplit <- ifelse(plotData_sidewaysScatter$dateSplit=="INITIAL", "2INITIAL", "3FINAL")
    
    #change levels for better plotting
    plotData_sidewaysScatter$dateSplit <- factor(plotData_sidewaysScatter$dateSplit, levels = c("1preADC", "2INITIAL", "3FINAL"))
    plotData_sidewaysScatter$scoreType <- factor(plotData_sidewaysScatter$scoreType, levels = c("Reusable", "Interoperable", "Accessible", "Findable", "OVERALL"))
    
    
    ######################################
    # Data Visualization
    ######################################
    
    #create graphical parameters
    colorValues <- c("2INITIAL" = "gray60", "3FINAL" = "orangered1")
    fillValues <- c("1preADC" = "yellow", "2INITIAL" = "gray80", "3FINAL" = "black")
    shapeValues <- c("2INITIAL" = 22, "3FINAL" = 21)
    sizeValues <- c("2INITIAL" = 3, "3FINAL" = 2.5)
    
    
    #plot it!
    sideways_binned_scatterplot <- ggplot(plotData_sidewaysScatter, aes(x=meanScore, y=scoreType)) +
      geom_line(aes(group=scoreType), color="gray60", size=2) +
      geom_point(aes(fill=dateSplit, shape=dateSplit), size=4) +
      scale_shape_manual(values=shapeValues,
                         name="",
                         labels=c("INITIAL", "FINAL")) +
      scale_fill_manual(values=fillValues,
                        name="",
                        labels=c("INITIAL", "FINAL")) +
      # scale_color_manual(values=colorValues,
      #                    name="",
      #                    labels=c("", "")) +
      xlim(0,1) +
      theme_ADC_modified +
      xlab("Mean Score for the Selected Time Period") +
      ylab("") +
      theme(legend.position="top")
    
    sideways_binned_scatterplot
    
    
  })
  
  
  
##### create plot for the FAIR score for each version of a sequenceID ####
  output$binned_scatterplot_packageLevel <- renderPlot({
    
    #obtain sequenceIds for any updated within from user-specified timeframe
    sequenceId_over_timeperiod <- aggScore_clean %>% 
      dplyr::filter(dateUploaded >= input$timeframe[1] & dateUploaded <= input$timeframe[2]) %>% 
      dplyr::summarize(sequenceId = unique(sequenceId))
    
    #subset dataframe using list of sequenceIds
    aggScore_subset <- aggScore_clean[aggScore_clean$sequenceId %in% sequenceId_over_timeperiod$sequenceId,]
    
    #order sequenceIds factor levels by chronology
    seqId_axis_order_chronology <- aggScore_subset %>% 
      group_by(sequenceId) %>% 
      arrange(dateUploaded, pid) %>% 
      slice(tail(row_number(), 1)) %>% 
      select(sequenceId, dateUploaded)
      
    #graph overall scores on y-axis and sequenceIds on the x-axis, with the score of each pid represented by a point

      scatter_plot <- ggplot(data=aggScore_subset, aes(x=sequenceId, y=scoreOverall)) +
      geom_jitter(data=aggScore_subset[aggScore_subset$dateSplit=="INTERMEDIATE",], aes(color=dateSplit, fill=dateSplit, shape=dateSplit, size=dateSplit), alpha=0.3, width=0.3, height=0) +
      geom_point(data=aggScore_subset[aggScore_subset$dateSplit!="INTERMEDIATE",], aes(color=dateSplit, fill=dateSplit, shape=dateSplit, size=dateSplit)) +
      theme_ADC_modified +
      ylim(0,1) +
      ylab("Overall Score") +
      xlab("Data Package Unique Sequence ID \n (ordered chronologically by most recent update)") +
      scale_x_discrete(limits = seqId_axis_order_chronology$sequenceId[order(seqId_axis_order_chronology$dateUploaded)]) +
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
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        theme(axis.title.x=element_blank(),
              axis.text.x=element_blank(),   #TODO_CWB: Remove at later date once submitter is available.
              axis.ticks.x=element_blank())
      
      scatter_plot
  })
  
  
  
#### FAIR score time series ####
  output$linegraph_FAIR_overview <- renderPlot({
    
    #summarize FAIR scores and uploads on both a weekly and monthly basis
    gganimate_NSF_weekly <- aggregate_score_ADC %>%
      filter(dateUploaded > as.Date("2016-03-20")) %>%
      mutate(year = lubridate::year(dateUploaded),
             month = lubridate::month(dateUploaded),
             week = lubridate::week(dateUploaded),
             date_floor = lubridate::floor_date(dateUploaded, "1 week")) %>%
      group_by(year, month, week, date_floor) %>%
      summarize(n=n(),
                meanOverall = mean(scoreOverall),
                meanFindable = mean(scoreFindable),
                meanAccessible = mean(scoreAccessible),
                meanInteroperable = mean(scoreInteroperable),
                meanReusable = mean(scoreReusable))
    
    #monthly
    gganimate_NSF_monthly <- aggregate_score_ADC %>%
      filter(dateUploaded > as.Date("2016-03-20")) %>%
      mutate(year = lubridate::year(dateUploaded),
             month = lubridate::month(dateUploaded),
             week = lubridate::week(dateUploaded),
             date_floor = lubridate::floor_date(dateUploaded, "1 month")) %>%
      group_by(year, month, date_floor) %>%
      summarize(n=n(),
                meanOverall = mean(scoreOverall),
                meanFindable = mean(scoreFindable),
                meanAccessible = mean(scoreAccessible),
                meanInteroperable = mean(scoreInteroperable),
                meanReusable = mean(scoreReusable))
    
    gganimate_NSF_monthly_nOnly <- gganimate_NSF_monthly %>% 
      select(date_floor, n)
    
    gganimate_NSF_monthly <- gganimate_NSF_monthly %>% 
      select(!n) %>% 
      pivot_longer(cols = c(meanOverall, meanFindable, meanAccessible, meanInteroperable, meanReusable),
                   names_to = "type",
                   values_to = "score")
    
    #set levels for better plotting later
    gganimate_NSF_monthly$type <- factor(gganimate_NSF_monthly$type, levels = c("meanOverall", "meanFindable", "meanAccessible", "meanInteroperable", "meanReusable"))
    
    #set graphic parameters
    colorValues <- c("meanOverall" = "black",
                     "meanFindable" = "darkgreen", 
                     "meanAccessible" = "darkblue",
                     "meanInteroperable" = "orange",
                     "meanReusable" = "firebrick")
    
    lineValues <- c("meanOverall" = "solid",
                    "meanFindable" = "dashed", 
                    "meanAccessible" = "dashed",
                    "meanInteroperable" = "dashed",
                    "meanReusable" = "dashed")
    
    sizeValues <- c("meanOverall" = 1.5,
                    "meanFindable" = 0.5, 
                    "meanAccessible" = 0.5,
                    "meanInteroperable" = 0.5,
                    "meanReusable" = 0.5)
    
    alphaValues <- c("meanOverall" = 1.0,
                     "meanFindable" = 0.75, 
                     "meanAccessible" = 0.75,
                     "meanInteroperable" = 0.75,
                     "meanReusable" = 0.75)
    
    
    #create static figure
    ggplot() +
      geom_bar(data = gganimate_NSF_monthly_nOnly, aes(x=date_floor, y=n, group=seq_along(date_floor)), fill="gray65", stat = 'identity', alpha=0.8) +
      geom_line(data = gganimate_NSF_monthly, aes(x=date_floor, y=score*4000, linetype=type, color=type, size=type, alpha=type)) +
      scale_color_manual(values=colorValues,
                         name="FAIR Score Category:",
                         labels=c("Overall", "Findable", "Accessible", "Interoperable", "Reusable")) +
      scale_linetype_manual(values=lineValues,
                            name="FAIR Score Category:",
                            labels=c("Overall", "Findable", "Accessible", "Interoperable", "Reusable")) +
      scale_size_manual(values=sizeValues,
                        name="FAIR Score Category:",
                        labels=c("Overall", "Findable", "Accessible", "Interoperable", "Reusable")) +
      scale_alpha_manual(values=alphaValues,
                         name="FAIR Score Category:",
                         labels=c("Overall", "Findable", "Accessible", "Interoperable", "Reusable")) +
      scale_y_continuous(name = 'Monthly Dataset Uploads', 
                         sec.axis = sec_axis(~./4000, name = "Mean Monthly FAIR Score")) +
      labs(x = "Date") +
      scale_x_datetime(date_breaks = "1 year", date_labels="%Y") +
      theme_ADC_modified +
      theme(legend.position = "top") +
      theme(axis.line.y.left = element_line(color = "gray40"),
            axis.ticks.y.left = element_line(color = "gray40"),
            axis.text.y.left = element_text(color="gray40"),
            axis.title.y.left = element_text(color="gray40")) +
      annotate('rect', xmin = as.POSIXct(input$timeframe[1]), xmax = as.POSIXct(input$timeframe[2]), ymin = -Inf, ymax = Inf, fill='gray80', alpha=0.3)
    
  })
  
  
  
}



############ shinyApp block ############ 
shinyApp(ui = ui, server = server)

