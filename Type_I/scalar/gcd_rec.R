# TODO: Add comment
# 
# Author: Haichuan Wang(hwang154@illinois.edu)
###############################################################################


setup <- function(args=c('123456789', '234736437')) {
    m<-as.integer(args[1])
    n<-as.integer(args[2])
    if(is.na(m)){ m <- 123456789 }
    if(is.na(n)){ n <- 234736437 }
    list(m,n)
}

run <- function(mn) {
    m <- mn[[1]]
    n <- mn[[2]]
	gcd<-function(m,n) {
		if(n==0) { m; }
		else { gcd(n,m %% n); }		
	}
	r<-gcd(m,n);
	print(r);
}


if (!exists('harness_argc')) {
    mn <- setup(commandArgs(TRUE))
    run(mn)
}