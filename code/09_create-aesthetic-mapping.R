#create new asthetic mapping for AGGREGATE SCORES
aggScore_clean$aesMap <- aggScore_clean$dateSplit

aggScore_clean$aesMap <- factor(aggScore_clean$aesMap, levels=c("INITIAL", "INTERMEDIATE", "FINAL", "DOI"))

aggScore_clean$aesMap[aggScore_clean$dateSplit=="FINAL" & aggScore_clean$DOI_present=="DOI"] <- factor("DOI")



#create new asthetic mapping for INDIVIDUAL CHECKS
indivChecks_clean$aesMap <- indivChecks_clean$dateSplit

indivChecks_clean$aesMap <- factor(indivChecks_clean$aesMap, levels=c("INITIAL", "INTERMEDIATE", "FINAL", "DOI"))

indivChecks_clean$aesMap[indivChecks_clean$dateSplit=="FINAL" & indivChecks_clean$DOI_present=="DOI"] <- factor("DOI")


