# TODO: Add comment
# 
# Author: Administrator
###############################################################################


run <- function(n=30)
{
	if (n < 2) { 1; }
	else {run(n - 1) + run(n - 2);}
}

#Default Driver
n<-30;
#args <- commandArgs(TRUE);
#if(length(args) > 0){
#	n <- as.integer(args[1]);
#}
run(n);
