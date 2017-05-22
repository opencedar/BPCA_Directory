rm(list=ls())
source("utilities.R")

location <- scan ("sheetLocation", what="character")
directoryFrame <- getDirectory(location)

lastNameCols <- c("LastName1", "LastName2", "LastName3", "LastName4")
firstNameCols <- c("FirstName1", "FirstName2", "FirstName3", "FirstName4")
childNameCols <- c("childName1", "childName2", "childName3", "childName4", "childName5", "childName6")
chilYearBornCols<- c("childYearBorn1", "childYearBorn2", "childYearBorn3", "childYearBorn4", "childYearBorn5", "childYearBorn6")

sortedNamesFrameAll <- uniqueLast(directoryFrame, lastNameCols, firstNameCols)
sortedNamesFrameFull <- fullVectors(sortedNamesFrameAll)
sortedNamesFrameIndex <- sortedNamesFrameAll[sortedNamesFrameAll$useInIndex==TRUE,]
directoryEntriesIndex <- makeLastNameIndex(sortedNamesFrameIndex, directoryFrame)
businessEntries <- getBusinessEntry(directoryFrame)
businessDirectory <- makeBusinessDirectory(businessEntries, directoryFrame)
streetFrame <- makeStreetFrame(directoryFrame)
streetFrame <- makeStreetStarts(streetFrame)
streetEntries <- makeStreetEntries(streetFrame)
letterStarts <- makeLetterStarts(directoryFrame, sortedNamesFrameAll)
sortedNamesFrameAll <- cbind(sortedNamesFrameAll, letterStarts)
x <- which(sapply(directoryFrame$VacantForSale, isNotNullNAEmpty))
sortedNamesFrameAll <- sortedNamesFrameAll[!(sortedNamesFrameAll$Index %in% x),]
directoryEntriesAll <- makeDirectoryEntriesAll(sortedNamesFrameAll, dataFrame=directoryFrame)

