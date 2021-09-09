library(here)
library(tidyverse)



dirpath = paste0(here::here('data'), '/CloseWhale4km/LF_1706.A33.S15')

# paste0(here::here()
# 
# 
# paste0(here('data'), '/GPSsec_1303.csv'))

ravTab = read.table( paste0(dirpath, '/LF1706A33S15_totalDetector.selections.txt'), sep = "\t", header = T )

#change blanks to NA
ravTab[ravTab== ""] <- NA  #changes ClickStatus blanks to NA
# colnames(ravTab) = c("Selection","View","Channel","BeginTime", "EndTime", "LowFreq", "HighFreq", "ClickStatus")

#fill in NAs with preceding value ()
ravTabDF <- ravTab %>% rename(BeginTime = Begin.Time..s., EndTime = End.Time..s., LowFreq = Low.Freq..Hz., HighFreq = High.Freq..Hz.) %>% fill(ClickStatus)

#I want all true detections