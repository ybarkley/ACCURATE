makeRavenTable <- function(encID, chan, detTime, peakFreq, rL) {


if (nrow(detTime) > nrow(peakFreq)){ # if more detections than peaks
ndiff = abs(nrow(detTime) - nrow(peakFreq)) # find the difference in row length
xtrPk <- data.frame(matrix(ncol=1, nrow=ndiff))              # make empty dataframe of size ndiff
xtrPk[,] <- 10 
colnames(xtrPk) <- 'peakFreq'
    peakFreq <- rbind(peakFreq, xtrPk) # add extra rows to peaks
} else if(nrow(detTime) < nrow(peakFreq)){
  ndiff = abs(nrow(detTime) - nrow(peakFreq))
    peakFreq = peakFreq[1:(nrow(peakFreq-ndiff)) , ]
} else (nrow(detTime) == nrow(peakFreq))
peakFreq = peakFreq

ravenDF = data.frame(detTime, detTime, peakFreq, peakFreq)

# #convert khz to Hz
ravenDF[,3] = ravenDF[,3]*1000
ravenDF[,4] = ravenDF[,4]*1000

#if det times and peak freqs don't match up for some reason, jsut make dummy freq columns
# ravenDF = data.frame(detTime)
# ravenDF$endtime = ravenDF$V1
# ravenDF$V1.2 = 10000
# ravenDF$V1.3 = 10000

colnames(ravenDF)[1] = 'Begin Time (s)'
colnames(ravenDF)[2] = 'End Time (s)'
colnames(ravenDF)[3] = 'Low Freq (Hz)'
colnames(ravenDF)[4] = 'High Freq (Hz)'

## add in columns for selection table to each csv

# Selection # - make a sequential vector of length of ravenDF
ravenDF$Selection = (1:nrow(ravenDF))

# View - Spectrogram
ravenDF$View = 'Spectrogram 1'

# Channel - 6
ravenDF$Channel = chan

selTable = ravenDF[ , c(5:7, 1:4)]
selTable$View = as.factor(selTable$View)

selTable$ClickStatus =''
selTable$Notes = ''

# selTable$`Begin Time (s)` = round(selTable$`Begin Time (s)`, 5) 
# selTable$`High Freq (Hz)` = round(selTable$`High Freq (Hz)`, 1) 
# selTable$`Low Freq (Hz)` = round(selTable$`Low Freq (Hz)`, 1) 
# selTable$`High Freq (Hz)` = round(selTable$`High Freq (Hz)`, 1) 


write.table(selTable, paste0(savePath, '/', encID, '_totalDetections_', rL,'RL_hp', chan, '.selections.txt') , row.names = F, sep = "\t", quote=F)

# write.table(selTable, paste0('C:\\Users\\yvers\\Documents\\CRP\\ACCURATE\\data\\CloseWhale4km\\LF_1706.A33.S15\\LF1706A33S15_totalDetector.selections.txt'), row.names = F, sep = "\t", quote=F)
# write.table(selTable, pate0('C:\\Users\\yvers\\Documents\\CRP\\ACCURATE\\data\\CloseWhale4km\\LF_1706.A33.S15\\detectorravenDF_loud\\LF1706A33S15_loudravenDF.selections.txt', row.names = F, sep = "\t", quote=F)
}
