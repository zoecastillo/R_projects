best <- function(state,outcome) {
    ## Read outcome data
    data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

    ## Check that state and outcome are valid
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
    
    hosinstate <- data[data$State==state,]
    numofhos <- nrow(hosinstate)
    if(numofhos == 0)
      stop("invalid state")
    
    ## Return hospital name in that state with lowest 30-day death 
    ## rate
    hosinstate[,colnr] <- as.numeric(hosinstate[,colnr]) ##produces NA warning
    minval <- min(hosinstate[,colnr], na.rm=TRUE)
    best <- hosinstate[hosinstate[,colnr]==minval,2]
    bestnona <- best[!is.na(best)]
    bestnona[1]
}