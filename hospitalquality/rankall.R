rankall <- function(outcome, num = "best"){
    ##read outcome data
    data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
    ## Check that outcome is valid
    colnr <- 0
    if(outcome == "heart attack")
      colnr <- 11
    else if(outcome == "heart failure")
      colnr <- 17
    else if(outcome == "pneumonia")
      colnr <- 23
    else{
      stop("invalid outcome")
    }
    
    ## For each state, find the hospital of given rank
    
    getlast <- FALSE
    if(num == "best") num <- 1
    else if(num == "worst") getlast <- TRUE


    data[,colnr] <- as.numeric(data[,colnr])
    sorteddata <- data[order(data[,7],data[,colnr],na.last = NA, data[,2]),]
    splitted <- split(sorteddata, sorteddata$State)
    if(getlast)
      listofnames <- lapply(splitted, function(x) x[nrow(x),2])
    else
      listofnames <- lapply(splitted,function(x) x[num,2])
    data.frame(hospital=unlist(listofnames),state=names(listofnames))

}