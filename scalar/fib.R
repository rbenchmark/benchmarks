# TODO: Add comment
# 
# Author: Administrator
###############################################################################


run <- function(rep=1000)
{
	n <-1000;
	for(i in 1:rep){
		a <- 1
		b <- 1
		for(j in 1:n) {t <- a; a <- b; b <- b+t}
	}
	b
}

#Default Driver

#args <- commandArgs(TRUE);
#if(length(args) > 0){
#	n <- as.integer(args[1]);
#}

run()