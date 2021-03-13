 
## March 2021
## Data Summary of Sperm Whale Acoustic Encounters

library(gtsummary)
library(tidyverse)

#### PhD Data ####
# Load basic csv of ac. encounters used for PHD
data <- read.csv('./data/SpermiesWithEnvData_20200531.csv')

#remove 1642 cruise, data were too noisy
data <- filter(data, survey != 1642)

#add survey year
data$year <- 2010
data$year[data$survey==1303] <- 2013 
data$year[data$survey==1604] <- 2016
data$year[data$survey==1705] <- 2017
data$year[data$survey==1706] <- 2017
# data2 <- dplyr::select(data, last_col(), everything())

#filter for localized acoustic encounters, choose one peak from best estimates
data_loc <- filter(data, loc == 1 & type == 'best'& peak=='A')

data_loc %>%
  select(loc, click_code, rating, year) %>%
  tbl_summary(by = year,
              missing = 'no') %>%
  modify_spanning_header(all_stat_cols() ~ "**Acoustic Encounters**")


#filter for sighted acoustic encounters without codas with group size < 2
data_vis <- filter(data, sid < 999, !grepl('cd', click_code), grpsize < 5, rating >1)

data_vis %>%
  select(click_code, rating, grpsize, year) %>%
  tbl_summary(by = grpsize) %>%
  modify_spanning_header(all_stat_cols() ~ "**Sighted Acoustic Encounters**")

data_vis %>%
  select(click_code, rating, grpsize, year) %>%
  tbl_summary(by = grpsize) %>%
  modify_spanning_header(all_stat_cols() ~ "**Sighted, group < 5**") %>% add_n()  #add total column



##### WHICEAS Data ####

data_whiceas <- read.csv('./data/WHICEAS/WHICEAS_AcousticDetections_raw.csv')
data_whiceas <- data_whiceas[-c(1,4,7,8)]
data_whiceas$cruiseID <- 2001
#add identifier (survey.acid.sid)
data_whiceas$Label <-paste(2001, paste('A',data_whiceas$ac_id,sep=""), paste('S',data_whiceas$vis_id, sep=""), sep=".")

#duplicate Comments to put one in the beginning of df
data_whiceas$Comment2 <- data_whiceas$Comment

data_whiceas <- select(data_whiceas, cruiseID, Label, Comment2, everything())
data_whiceas <- rename(data_whiceas, Id = UID, latitude = latlong_LAT, longitude = latlong_LON, sid = vis_id)

data_pm <- filter(data_whiceas, species1_class1 == 46) #all whiceas spermies
data_pmVis <- filter(data_whiceas, species1_class1 == 46 & sid < 999)
