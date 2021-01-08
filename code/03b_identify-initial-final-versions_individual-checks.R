#---
#  title: "FAIR Scores: Creating a Shiny Dashboard"
#  author: "Christopher W. Beltz"
#  date created: "2021-01-08"
#  R version: "4.0.2"
#  input: "NA"
#  output: "NA"

#---



##############################################################################
## Identify INITIAL, FINAL, and INTERMEDIATE versions for each data package ##
##############################################################################

#identify initial/final/intermediate update
indivChecks_dateSplit <- indivChecks_clean %>%
  group_by(series_id) %>%
  arrange(date_uploaded, pid) %>%
  mutate(dateSplit = case_when(
    date_uploaded == min(date_uploaded) ~ "INITIAL",
    date_uploaded == max(date_uploaded) ~ "FINAL",
    TRUE ~ "INTERMEDIATE"))


indivChecks_clean <- indivChecks_dateSplit
