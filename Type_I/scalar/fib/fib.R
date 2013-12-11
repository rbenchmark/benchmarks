# TODO: Add comment
# 
# Author: Haichuan Wang(hwang154@illinois.edu)
###############################################################################

setup <- function(args='1000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 1000 }
    return(n)
}

run <- function(rep=1000)
{
	n <-1000;
	for(i in 1:rep){
		a <- 1
		b <- 1
		for(j in 1:n) {t <- a; a <- b; b <- b+t}
	}
	print(b)
}

#Default Driver

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}