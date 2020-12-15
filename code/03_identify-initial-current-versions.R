#---
#  title: "FAIR Scores: Creating a Shiny Dashboard"
#  author: "Christopher W. Beltz"
#  date created: "2020-12-02"
#  R version: "4.0.2"
#  input: "NA"
#  output: "NA"

#---



#############################################################
## Calculate difference in FAIR scores for each sequenceId ##
#############################################################

#identify initial/final update
aggScore_dateSplit <- aggScore_clean %>%
  group_by(sequenceId) %>%
  arrange(dateUploaded, pid) %>%
  mutate(dateSplit = case_when(
    dateUploaded == min(dateUploaded) ~ "INITIAL",
    dateUploaded == max(dateUploaded) ~ "CURRENT",
    TRUE ~ "INTERMEDIATE"))

#change factor levels for better plotting later
aggScore_dateSplit$dateSplit <- factor(aggScore_dateSplit$dateSplit, levels=c("INITIAL", "INTERMEDIATE", "CURRENT"))

levels(aggScore_dateSplit$dateSplit)




aggScore_clean <- aggScore_dateSplit
