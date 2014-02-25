# TODO: Add comment
# 
# Author: Administrator
###############################################################################

setup <- function(args='30') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 30 }
    return(n)
}


run <- function(n=30)
{
	if (n < 2) { 1; }
	else {run(n - 1) + run(n - 2);}
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}
