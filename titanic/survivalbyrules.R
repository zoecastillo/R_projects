survivalbyrules <- function(x){
    if(x['Sex'] == "male"){
        if(x['Age'] > 16 | x['Pclass'] == 3) 
            return (0);
    }
    else if(x['Sex'] == "female"){
        if(x['Age'] <= 10 & x['Pclass'] == 3)
            return (0);
    }
    return (1);
}