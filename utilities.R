

isNotNullNAEmpty <- function(x) {(!is.null(x) && !is.na(x) && (nchar(x)>0))}

getDirectory <- function(googleAddress) {
        require(gsheet)
        dataFrame <- gsheet2tbl(googleAddress)
        return(dataFrame)
}
uniqueLast <- function(directoryData, lastNameCols, firstNameCols) {
         sortedNamesFrame <- data.frame(lastName=NA, firstName=NA, Index=NA, Full=NA, useInIndex = NA)
        for(i in 1:nrow(directoryData)) {
                x<- as.vector(t(directoryData[i,colnames(directoryData)%in%lastNameCols]))
                x<- x[which(sapply(x, nchar)>0)]
                if(length(unique(na.omit(x)))>1)
                        {
       x <- unique(na.omit(as.vector(t(directoryData[i,colnames(directoryData)%in%lastNameCols]))))
       x <- x[sapply(x, isNotNullNAEmpty)]
                y <- unique(na.omit(as.vector(t(directoryData[i,colnames(directoryData)%in%firstNameCols]))))
                y <- y[sapply(y, isNotNullNAEmpty)]
                insert <- data.frame(lastName=x, firstName=y)
                insert <- cbind(insert, data.frame(Index=rep(i,times = nrow(insert)), Full=c(TRUE, rep(FALSE, times=(nrow(insert)-1))), useInIndex = c(FALSE, rep(TRUE, times=(nrow(insert)-1)))))
                } else {
                        insert <- data.frame(lastName=directoryData$LastName1[i], firstName=directoryData$FirstName1[i], Index=i, Full=TRUE, useInIndex=FALSE)
                }
                sortedNamesFrame <- rbind(sortedNamesFrame, insert)
        }
        sortedNamesFrame <- sortedNamesFrame[-1,]
        sortedNamesFrame <-sortedNamesFrame[order(sortedNamesFrame$lastName, sortedNamesFrame$firstName),]
        return(sortedNamesFrame)
}

fullVectors <- function(sortedNamesFrame) {
        fullNamesFrame <- sortedNamesFrame[sortedNamesFrame$Full==TRUE,]
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
                        paste0("\\textbf{\\uppercase{", StreetName, "}} \\newline \\newline")
                        },
                        StreetNumber,
                        ": ", 
                        if(isNotNullNAEmpty(VacantForSale)) {paste0("")} else
                        if(LastName1 == LastName2 | !isNotNullNAEmpty(LastName2)) {LastName1} else 
                                {paste0(LastName1, " / ", LastName2)}
                ))
                directoryEntries[i] <- x
        }
        return(directoryEntries)
}

makeLetterStarts <- function(directoryFrame=directoryFrame, sortedNamesFrameAll = sortedNamesFrameAll) {
        letterStarts <-  vector(mode="character", length=nrow(sortedNamesFrameAll))
        letterStarts[1] <- substr(sortedNamesFrameAll$lastName[1],1,1)
        for(i in 2:nrow(sortedNamesFrameAll)) {
                a <- substr(sortedNamesFrameAll$lastName[i],1,1)
                b <- substr(sortedNamesFrameAll$lastName[i-1],1,1)
                if((a != b) && (!is.na(a)) && (!is.na(b)) && (!is.null(a)) && (!is.null(b))) {letterStarts[i] <- a}
        }
        return(letterStarts)
}

makeDirectoryEntriesAll <- function(sortedNamesFrameAll, dataFrame=directoryFrame) {
        directoryEntries <- vector(length = nrow(sortedNamesFrameAll))
        for(i in 1:nrow(sortedNamesFrameAll)) {
                if(sortedNamesFrameAll$Full[i]==TRUE) {
                x <- with(dataFrame[sortedNamesFrameAll$Index[i],], paste0(
                        if(isNotNullNAEmpty(as.character(sortedNamesFrameAll$letterStarts[i]))) {
                        paste0(" \\textcolor{white}{---} \\newline \\textbf{\\uppercase{\\LARGE{",as.character(sortedNamesFrameAll$letterStarts[i]),"}}} \\newline \\newline")
                        },
                        " \\textbf{",
                        LastName1,
                        ", ",
                        FirstName1,
                        if(isNotNullNAEmpty(LastName2)) {
                                if(LastName1 == LastName2) {
                                        paste0(" and ", FirstName2)
                                } else {paste0(" and ", FirstName2, " ", LastName2)}
                        } else {""},
                        "} ",
                        " \\newline ",
                        if(isNotNullNAEmpty(BusinessName)) {paste0(" \\textit{", BusinessName, " } \\newline ")} else {""},
                        if(isNotNullNAEmpty(Absentee)) {paste0(" \\textit{Not Currently Residing at this Property} \\newline ")} else {""},
                        StreetNumber,
                        " ",
                        StreetName,
                        " \\newline ",
                        if(isNotNullNAEmpty(HomePhone)) {paste0(
                        "Home Phone: ",
                        HomePhone,
                        " \\newline ")} else {""},
                        if(isNotNullNAEmpty(HomeEmail)) {paste0("Home Email: ", HomeEmail, " \\newline ")} else {""},
        if(isNotNullNAEmpty(CellPhone1) | isNotNullNAEmpty(Email1)) 
                {paste0(FirstName1, ": ", 
                        if(isNotNullNAEmpty(CellPhone1)) {paste0(CellPhone1, ", ")}, 
                        if(isNotNullNAEmpty(Email1)) {Email1}, " \\newline ")} else {""},
        if(isNotNullNAEmpty(CellPhone2) | isNotNullNAEmpty(Email2)) 
                {paste0(FirstName2, ": ",
                        if(isNotNullNAEmpty(CellPhone2)) {paste0(CellPhone2, ", ")}, 
                        if(isNotNullNAEmpty(Email2)) {Email2}, " \\newline ")} else {""},
                        if(isNotNullNAEmpty(ChildName1)) {paste0("Children: ", ChildName1, if(isNotNullNAEmpty(ChildYearBorn1)) {paste0(" (", ChildYearBorn1, ")")})} else {""},
                        if(isNotNullNAEmpty(ChildName2)) {paste0("; ", ChildName2, if(isNotNullNAEmpty(ChildYearBorn2)) {paste0(" (", ChildYearBorn2, ")")})} else {""},
                        if(isNotNullNAEmpty(ChildName3)) {paste0("; ", ChildName3, if(isNotNullNAEmpty(ChildYearBorn3)) {paste0(" (", ChildYearBorn3, ")")})} else {""},
                        if(isNotNullNAEmpty(ChildName4)) {paste0("; ", ChildName4, if(isNotNullNAEmpty(ChildYearBorn4)) {paste0(" (", ChildYearBorn4, ")")})} else {""},
                        if(isNotNullNAEmpty(ChildName5)) {paste0("; ", ChildName5, if(isNotNullNAEmpty(ChildYearBorn5)) {paste0(" (", ChildYearBorn5, ")")})} else {""},
                        if(isNotNullNAEmpty(ChildName6)) {paste0("; ", ChildName6, if(isNotNullNAEmpty(ChildYearBorn6)) {paste0(" (", ChildYearBorn6, ")")})} else {""},
                        if(isNotNullNAEmpty(LastName3)) {paste0(" \\newline Also Residing: ", FirstName3, " ", LastName3)} else {""},
                        if(isNotNullNAEmpty(LastName4)) {paste0(", ", FirstName4, " ", LastName4)} else {""},
                        if(isNotNullNAEmpty(as.character(sortedNamesFrameAll$letterStarts[i+1]))) {" \\newline "}
                ))} else {x <- with(dataFrame[sortedNamesFrameAll$Index[i],], paste0(
                        if(isNotNullNAEmpty(as.character(sortedNamesFrameAll$letterStarts[i]))) {
                                paste0(" \\textcolor{white}{---} \\newline \\textbf{\\uppercase{\\LARGE{",as.character(sortedNamesFrameAll$letterStarts[i]),"}}} \\newline \\newline")
                        },
                                " \\textbf{",
                                sortedNamesFrameAll$lastName[i],
                                ", ",
                                sortedNamesFrameAll$firstName[i],
                                ", see ",
                                LastName1,
                                ", ",
                                FirstName1,
                                " } ",
                                if(isNotNullNAEmpty(as.character(sortedNamesFrameAll$letterStarts[i+1]))) {" \\newline "}
                        ))}
                        directoryEntries[i] <- x
        }
        return(directoryEntries)
}

getRightColumns <- function(origCols=lastNameCols, dataFrame=directoryData, i=i) {which(colnames(dataFrame)%in%origCols)[sapply(dataFrame[i,colnames(dataFrame)%in%origCols], isNotNullNAEmpty)]}

getBusinessEntry <- function(directoryFrame =directoryFrame) {
        businessIndex <- data.frame(index = NULL, businessName = NULL, businessNumber = NULL, businessStreet = NULL)
        for(i in 1:length(which(sapply(directoryFrame$BusinessName, isNotNullNAEmpty)))) {
                index <- which(sapply(directoryFrame$BusinessName, isNotNullNAEmpty))[i]
                businessName<- directoryFrame$BusinessName[index]
                businessNumber <- directoryFrame$StreetNumber[index]
                businessStreet <- directoryFrame$StreetName[index]
                addedRow <- c(index, businessName, businessNumber, businessStreet)
                businessIndex <- rbind(businessIndex, addedRow)
        }
        colnames(businessIndex) <- c("index", "businessName", "businessNumber", "businessStreet")
        return(businessIndex)
}

makeBusinessDirectory <- function(businessEntries = businessEntries, directoryFrame = directoryFrame) {
        businessDirectory <- vector(length = nrow(businessEntries))
        for(i in 1:nrow(businessEntries)) {
                row <- as.numeric(as.character(businessEntries$index[i]))
                x <- paste0(
                        " \\textbf{",
                        businessEntries$businessName[i],
                        "} \\newline ",
                        businessEntries$businessNumber[i],
                        " ",
                        businessEntries$businessStreet[i],
                        " \\newline See ",
                        directoryFrame[row,]$LastName1,
                        ", ",
                        directoryFrame[row,]$FirstName1,
                        " \\newline "
                )
                businessDirectory[i] <- x
        }
        return(businessDirectory)
}