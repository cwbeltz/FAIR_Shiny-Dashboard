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
most_recent_upload$date <- max(aggScore_clean$dateUploaded)
most_recent_upload$pid <- aggScore_clean$pid[which(aggScore_clean$dateUploaded==most_recent_upload$date)]
  


#calculate weekly, monthly, and annual means scores
aggScore_with_date_floor <- aggScore_clean %>% 
  mutate(week_floor = lubridate::floor_date(dateUploaded, unit="week"),
         month_floor = lubridate::floor_date(dateUploaded, unit="month"),
         year_floor = lubridate::floor_date(dateUploaded, unit="year"))

temp_year <- aggScore_with_date_floor %>%
  filter(dateUploaded > (Sys.time()-lubridate::days(365*3))) %>%
  group_by(year_floor) %>%
  summarise(overallScore_annualMean = mean(scoreOverall)) %>% 
  summarise(annual_mean = mean(overallScore_annualMean),
            annual_sd = sd(overallScore_annualMean))
  
temp_month <- aggScore_with_date_floor %>%
  filter(dateUploaded > (Sys.time()-lubridate::days(365*1))) %>%
  group_by(month_floor) %>%
  summarise(overallScore_monthlyMean = mean(scoreOverall)) %>% 
  summarise(monthly_mean = mean(overallScore_monthlyMean),
            monthly_sd = sd(overallScore_monthlyMean))

temp_week <- aggScore_with_date_floor %>%
  filter(dateUploaded > (Sys.time()-lubridate::days(365*1))) %>%
  group_by(week_floor) %>%
  summarise(overallScore_weeklyMean = mean(scoreOverall)) %>% 
  summarise(weekly_mean = mean(overallScore_weeklyMean),
            weekly_sd = sd(overallScore_weeklyMean))
 
aggScore_timespan_averages <- data.frame(matrix(nrow = 3, ncol=3))
colnames(aggScore_timespan_averages) <- c("timeframe", "mean", "sd")

aggScore_timespan_averages$timeframe[1] <- "weekly" 
aggScore_timespan_averages$mean[1] <- temp_week$weekly_mean[1] 
aggScore_timespan_averages$sd[1] <- temp_week$weekly_sd[1]

aggScore_timespan_averages$timeframe[2] <- "monthly" 
aggScore_timespan_averages$mean[2] <- temp_month$monthly_mean[1] 
aggScore_timespan_averages$sd[2] <- temp_month$monthly_sd[1]

aggScore_timespan_averages$timeframe[3] <- "annual"
aggScore_timespan_averages$mean[3] <- temp_year$annual_mean[1] 
aggScore_timespan_averages$sd[3] <- temp_year$annual_sd[1]

rm(temp_month, temp_week, temp_year)
