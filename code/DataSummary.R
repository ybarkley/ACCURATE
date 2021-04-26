 
## March 2021
## Data Summary of Sperm Whale Acoustic Encounters

library(gtsummary)
library(tidyverse)
library(janitor)
library(reshape2)


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


####FILTER DATA ####

#filter for localized acoustic encounters, choose one peak from best estimates
dataCodaLoc <- filter(data, loc == 1 & type == 'best'& peak=='A', rating >=2, grepl('cd', click_code), sid==999)

#filter by sightings with codas
dataCodaVis <- filter(data, sid<999, rating >=2, grepl('cd', click_code))
dataCoda <- rbind(dataCodaLoc, dataCodaVis)
dataCoda$label <- ifelse(dataCoda$loc == 1, 'localized', 'sighted')






#Table by year
#with gtsummary
dataLocCoda %>%
  select(click_code, year) %>%
  tbl_summary(by = year,
              missing = 'no') %>%
  modify_spanning_header(all_stat_cols() ~ "**Localized 'Good' Acoustic Encounters**")%>% add_n() %>%
  bold_labels()


#with janitor
dataCoda %>% tabyl(click_code, year, label)


dataCoda %>% filter(label == 'localized') %>%
  tabyl(click_code, year) %>%
  # adorn_totals(c("row", "col"), name='Total Encounters') %>%
  adorn_title("combined", row_name = 'Click Type', col_name = 'Survey Year') %>%
  knitr::kable()





#filter for sighted acoustic encounters without codas 
data_vis <- filter(data, sid < 999, !grepl('cd', click_code), grpsize < 3, rating >2)

data_vis %>%
  select(click_code, rating, grpsize, year) %>%
  tbl_summary(by = grpsize) %>%
  modify_spanning_header(all_stat_cols() ~ "**Sighted Acoustic Encounters**")

data_vis %>%
  select(click_code, rating, grpsize, year) %>%
  tbl_summary(by = grpsize) %>%
  modify_spanning_header(all_stat_cols() ~ "**Sighted, group < 5**") %>% add_n()  #add total column



##### WHICEAS Data ####



data_whiceas <- read.csv('./data/WHICEAS/WHICEAS_AcousticDetections_edit.csv')


data_pm <- filter(data_whiceas, species1_class1 == 46) #all whiceas spermies
data_pmVis <- filter(data_whiceas, species1_class1 == 46 & sid < 999)
