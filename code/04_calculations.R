#---
#  title: "FAIR Scores: Creating a Shiny Dashboard"
#  author: "Christopher W. Beltz"
#  date created: "2020-12-01"
#  R version: "4.0.2"
#  input: "NA"
#  output: "NA"

#---



#find date of most recent upload
most_recent_upload <- data.frame(matrix(ncol = 0, nrow = 1))
most_recent_upload$date <- max(aggChecks_clean$dateUploaded)
most_recent_upload$pid <- aggChecks_clean$pid[which(aggChecks_clean$dateUploaded==most_recent_upload$date)]
  


#identify initial submission and final update for each sequenceId




