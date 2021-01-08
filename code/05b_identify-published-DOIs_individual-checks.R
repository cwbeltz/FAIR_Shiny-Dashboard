#---
#  title: "FAIR Scores: Creating a Shiny Dashboard"
#  author: "Christopher W. Beltz"
#  date created: "2021-01-08"
#  R version: "4.0.2"
#  input: "NA"
#  output: "NA"

#---



############################################
## Identify datasets published with a DOI ##
############################################

indivChecks_clean <- indivChecks_clean %>% 
  mutate(DOI_present = case_when(
    "doi" == substr(pid,1,3) ~ "DOI",
    TRUE ~ "none"))

indivChecks_clean$DOI_present <- factor(indivChecks_clean$DOI_present)




