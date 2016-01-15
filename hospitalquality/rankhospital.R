rankhospital <- function(state, outcome, num){
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
  
  getlast <- FALSE
  hosinstate <- data[data$State==state,]
  numofhos <- nrow(hosinstate)
  if(numofhos == 0)
    stop("invalid state")
  
  if(num == "best") num <- 1
  else if(num == "worst") getlast <- TRUE
  else if(num > numofhos) return(NA)
  
  ## Return hospital name in that state with num lowest 30-day death 
  ## rate
  hosinstate[,colnr] <- as.numeric(hosinstate[,colnr])
  sortedhos <- hosinstate[ order(hosinstate[,colnr], na.last = NA, hosinstate[,2]),]
  if(getlast)
    sortedhos[nrow(sortedhos),2]
  else
    sortedhos[num,2]
}