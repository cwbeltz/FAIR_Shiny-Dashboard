#---
#  title: "FAIR Scores: Creating a Shiny Dashboard"
#  author: "Christopher W. Beltz"
#  date created: "2020-11-30"
#  R version: "4.0.2"
#  input: "NA"
#  output: "NA"

#---


############ Source Code ############ 
library(here)

source(here::here("code", "00_load-packages.R"))
source(here::here("code", "01_load-data.R"))
source(here::here("code", "02a_clean-data_aggregate-scores.R"))
source(here::here("code", "02b_clean-data_individual-checks.R"))
source(here::here("code", "03a_identify-initial-final-versions_aggregate-scores.R"))
source(here::here("code", "03b_identify-initial-final-versions_individual-checks.R"))
source(here::here("code", "04_calculations.R"))
source(here::here("code", "05a_identify-published-DOIs_aggregate-scores.R"))
source(here::here("code", "05b_identify-published-DOIs_individual-checks.R"))

source(here::here("code", "09_create-aesthetic-mapping.R"))

source(here::here("code", "graphical_theme", "theme_modified_ADC.R"))
source(here::here("code", "graphical_theme", "colors-shapes.R"))



############ UI and SERVER ############ 
source("ui.R")
source("server.R")



############ shinyApp block ############ 
shinyApp(ui = ui, server = server)

