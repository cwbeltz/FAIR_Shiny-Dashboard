#---
#  title: "FAIR Scores: Creating a Shiny Dashboard"
#  author: "Christopher W. Beltz"
#  date created: "2020-12-01"
#  R version: "4.0.2"
#  input: "NA"
#  output: "NA"

#---



#subset data to only those sequenceIds updated within the last week
sequenceId_over_timeperiod <- aggChecks_clean %>% 
  filter(dateUploaded > lubridate::floor_date(Sys.time(), "day") - lubridate::days(7)) %>% 
  summarize(sequenceId = unique(sequenceId))

aggChecks_subset <- aggChecks_clean[aggChecks_clean$sequenceId %in% sequenceId_over_timeperiod$sequenceId,]



#graph overall scores on y-axis and sequenceIds on the x-axis, with the score of each pid represented by a point
test_figure <- aggChecks_subset %>% 
  ggplot(aes(x=sequenceId, y=scoreOverall)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

