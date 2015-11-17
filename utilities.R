getDirectory <- function(googleAddress) {
        require(gsheet)
        dataFrame <- gsheet2tbl(googleAddress)
        return(dataFrame)
}

uniqueLast <- function(directoryData, lastNameCols, firstNameCols) {
         sortedNamesFrame <- data.frame(lastName=NA, firstName=NA, Index=NA, Full=NA, useInIndex = NA)
        for(i in 1:nrow(directoryData)) {
                if(length(unique(na.omit(as.vector(t(directoryData[i,colnames(directoryData)%in%lastNameCols])))))>1) {
       x <- unique(na.omit(as.vector(t(directoryData[i,colnames(directoryData)%in%lastNameCols]))))
                y <- unique(na.omit(as.vector(t(directoryData[i,colnames(directoryData)%in%firstNameCols]))))
                insert <- data.frame(lastName=x, firstName=y)
                insert <- cbind(insert, data.frame(Index=rep(i,times = nrow(insert)), Full=c(TRUE, rep(FALSE, times=(nrow(insert)-1))), useInIndex = c(FALSE, rep(TRUE, times=(nrow(insert)-1)))))
                } else if(length(unique(na.omit(as.vector(t(directoryData[i,colnames(directoryData)%in%lastNameCols])))))==1) {
                        insert <- data.frame(lastName=directoryData$LastName1[i], firstName=directoryData$FirstName1[i], Index=i, Full=TRUE, useInIndex=FALSE)
                }
                sortedNamesFrame <- rbind(sortedNamesFrame, insert)
        }
        sortedNamesFrame <- sortedNamesFrame[-1,]
        return(sortedNamesFrame)
}

fullVectors <- function(sortedNamesFrame) {
        fullNamesFrame <- sortedNamesFrame[sortedNamesFrame$Full==TRUE,]
}

makeDirectoryEntriesFull <- function(sortedNamesFrameFull, dataFrame) {
        directoryEntries <- vector(length = nrow(sortedNamesFrameFull))
        for(i in 1:nrow(sortedNamesFrameFull)) {
                x <- with(dataFrame[sortedNamesFrameFull$Index[i],], paste0(
                        LastName1,
                        ", ",
                        FirstName1,
                        if(!is.na(LastName2)) {" and "} else {""},
                        if(!is.na(LastName2)) {LastName2} else {""},
                        if(!is.na(LastName2)) {", "} else {""},
                        if(!is.na(LastName2)) {FirstName2} else {""},
                        if(!is.na(LastName3)) {" and "} else {""},
                        if(!is.na(LastName3)) {LastName3} else {""},
                        if(!is.na(LastName3)) {", "} else {""},
                        if(!is.na(LastName3)) {FirstName3} else {""},
                        if(!is.na(LastName4)) {" and "} else {""},
                        if(!is.na(LastName4)) {LastName4} else {""},
                        if(!is.na(LastName4)) {", "} else {""},
                        if(!is.na(LastName4)) {FirstName4} else {""},
                        " \\newline ",
                        if(!is.na(ChildName1)) {ChildName1} else {""},
                        if(!is.na(ChildName1)) {", Born "} else {""},
                        if(!is.na(ChildName1)) {ChildYearBorn1} else {""},
                        if(!is.na(ChildName1)) {"; "} else {""},
                        if(!is.na(ChildName2)) {ChildName2} else {""},
                        if(!is.na(ChildName2)) {", Born "} else {""},
                        if(!is.na(ChildName2)) {ChildYearBorn2} else {""},
                        if(!is.na(ChildName2)) {"; "} else {""},
                        if(!is.na(ChildName3)) {ChildNameBorn3} else {""},
                        if(!is.na(ChildName3)) {", Born "} else {""},
                        if(!is.na(ChildName3)) {ChildYearBorn3} else {""},
                        if(!is.na(ChildName3)) {"; "} else {""},
                        if(!is.na(ChildName4)) {ChildName4} else {""},
                        if(!is.na(ChildName4)) {", Born "} else {""},
                        if(!is.na(ChildName4)) {ChildYear4} else {""},
                        if(!is.na(ChildName4)) {"; "} else {""},
                        if(!is.na(ChildName5)) {ChildName5} else {""},
                        if(!is.na(ChildName5)) {", Born "} else {""},
                        if(!is.na(ChildName5)) {ChildYearBorn5} else {""},
                        if(!is.na(ChildName5)) {"; "} else {""},
                        if(!is.na(ChildName6)) {ChildName6} else {""},
                        if(!is.na(ChildName6)) {", Born "} else {""},
                        if(!is.na(ChildName6)) {ChildYearBorn6} else {""},
                        if(!is.na(ChildName6)) {"; "} else {""},
                        " \\newline ",
                        StreetNumber,
                        " ",
                        StreetName,
                        " \\newline ",
                        "Home Phone: ",
                        HomePhone,
                        " \\newline ",
                        if(!is.na(CellPhone1)) {"Cell Phone 1: "} else {""},
                        if(!is.na(CellPhone1)) {CellPhone1} else {""},
                        if(!is.na(CellPhone1)) {" \\newline "} else {""},
                        if(!is.na(CellPhone2)) {"Cell Phone 2: "} else {""},
                        if(!is.na(CellPhone2)) {CellPhone2} else {""},
                        if(!is.na(CellPhone2)) {" \\newline "} else {""},
                        if(!is.na(Email1)) {"Email 1: "} else {""},
                        if(!is.na(Email1)) {Email1} else {""},
                        if(!is.na(Email1)) {" \\newline "} else {""},
                        if(!is.na(Email2)) {"Email 2: "} else {""},
                        if(!is.na(Email2)) {Email2} else {""},
                        if(!is.na(Email2)) {" \\newline "} else {""}
                        ))
                directoryEntries[i] <- x
        }
        return(directoryEntries)
}

makeLastNameIndex <- function(sortedNamesFrameIndex, dataFrame) {
        directoryEntries <- vector(length = nrow(sortedNamesFrameIndex))
        for(i in 1:nrow(sortedNamesFrameIndex)) {
                x <- with(sortedNamesFrameIndex[i,], paste0(
                        lastName,
                        ", ",
                        firstName,
                        ": see ",
                        dataFrame$LastName1[Index],
                        ", ",
                        dataFrame$FirstName1[Index]
                ))
                directoryEntries[i] <- x
        }
        return(directoryEntries)
}

makeStreetFrame<- function(directoryFrame) {
        streetFrame <- directoryFrame
        streetFrame <- cbind(streetFrame, rep(1:nrow(streetFrame)))
        colnames(streetFrame)[ncol(streetFrame)] <- "origIndex"
        streetFrame <- streetFrame[order(streetFrame$StreetName, streetFrame$StreetNumber),]
        return(streetFrame)
}

makeStreetStarts <- function(streetFrame) {
        streetStarts <- c(TRUE)
        for(i in 2:nrow(streetFrame)) {
                if(streetFrame$StreetName[i] != streetFrame$StreetName[i-1]) {
                        streetStarts <- c(streetStarts, TRUE)
                } else {streetStarts <- c(streetStarts, FALSE)}
        }
        outputFrame <- cbind(streetFrame, streetStarts)
        return(outputFrame)
}


makeStreetEntries <- function(streetFrame) {
        directoryEntries <- vector(length = nrow(streetFrame))
        for(i in 1:nrow(streetFrame)) {
                x <- with(streetFrame[i,], paste0(
                        if(streetStarts == TRUE) {
                        paste0("\\textbf{\\uppercase{", StreetName, "}} \\newline \\newline  ")
                        },
                        StreetNumber,
                        " ",
                        StreetName,
                        " \\newline ",
                        LastName1,
                        ", ",
                        FirstName1,
                        if(!is.na(LastName2)) {" and "} else {""},
                        if(!is.na(LastName2)) {LastName2} else {""},
                        if(!is.na(LastName2)) {", "} else {""},
                        if(!is.na(LastName2)) {FirstName2} else {""},
                        if(!is.na(LastName3)) {" and "} else {""},
                        if(!is.na(LastName3)) {LastName3} else {""},
                        if(!is.na(LastName3)) {", "} else {""},
                        if(!is.na(LastName3)) {FirstName3} else {""},
                        if(!is.na(LastName4)) {" and "} else {""},
                        if(!is.na(LastName4)) {LastName4} else {""},
                        if(!is.na(LastName4)) {", "} else {""},
                        if(!is.na(LastName4)) {FirstName4} else {""},
                        " \\newline ",
                        if(!is.na(ChildName1)) {ChildName1} else {""},
                        if(!is.na(ChildName1)) {", Born "} else {""},
                        if(!is.na(ChildName1)) {ChildYearBorn1} else {""},
                        if(!is.na(ChildName1)) {"; "} else {""},
                        if(!is.na(ChildName2)) {ChildName2} else {""},
                        if(!is.na(ChildName2)) {", Born "} else {""},
                        if(!is.na(ChildName2)) {ChildYearBorn2} else {""},
                        if(!is.na(ChildName2)) {"; "} else {""},
                        if(!is.na(ChildName3)) {ChildNameBorn3} else {""},
                        if(!is.na(ChildName3)) {", Born "} else {""},
                        if(!is.na(ChildName3)) {ChildYearBorn3} else {""},
                        if(!is.na(ChildName3)) {"; "} else {""},
                        if(!is.na(ChildName4)) {ChildName4} else {""},
                        if(!is.na(ChildName4)) {", Born "} else {""},
                        if(!is.na(ChildName4)) {ChildYear4} else {""},
                        if(!is.na(ChildName4)) {"; "} else {""},
                        if(!is.na(ChildName5)) {ChildName5} else {""},
                        if(!is.na(ChildName5)) {", Born "} else {""},
                        if(!is.na(ChildName5)) {ChildYearBorn5} else {""},
                        if(!is.na(ChildName5)) {"; "} else {""},
                        if(!is.na(ChildName6)) {ChildName6} else {""},
                        if(!is.na(ChildName6)) {", Born "} else {""},
                        if(!is.na(ChildName6)) {ChildYearBorn6} else {""},
                        if(!is.na(ChildName6)) {"; "} else {""},
                        " \\newline ",
                        "Home Phone: ",
                        HomePhone,
                        " \\newline ",
                        if(!is.na(CellPhone1)) {"Cell Phone 1: "} else {""},
                        if(!is.na(CellPhone1)) {CellPhone1} else {""},
                        if(!is.na(CellPhone1)) {" \\newline "} else {""},
                        if(!is.na(CellPhone2)) {"Cell Phone 2: "} else {""},
                        if(!is.na(CellPhone2)) {CellPhone2} else {""},
                        if(!is.na(CellPhone2)) {" \\newline "} else {""},
                        if(!is.na(Email1)) {"Email 1: "} else {""},
                        if(!is.na(Email1)) {Email1} else {""},
                        if(!is.na(Email1)) {" \\newline "} else {""},
                        if(!is.na(Email2)) {"Email 2: "} else {""},
                        if(!is.na(Email2)) {Email2} else {""},
                        if(!is.na(Email2)) {" \\newline "} else {""}
                ))
                directoryEntries[i] <- x
        }
        return(directoryEntries)
}


