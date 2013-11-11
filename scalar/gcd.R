# TODO: Add comment
# 
# Author: Administrator
###############################################################################


run2 <- function(m, n)
{
	while(n!=0) {
		t=m; 
		m=n;
		n=t %% n;
	}
	m;
}

run <- function(l=100000) {
	
	a <- as.integer(runif(l, 1, 1000000000));
	b <- as.integer(runif(l, 1, 1000000000));	
	for(i in 1:l) {
		m<-a[i];
		n<-b[i];
		while(n!=0) {
			t=m; 
			m=n;
			n=t %% n;
		}
	}
	l
}

#Default Driver
#m<-123456789;
#n<-234736437;
#args <- commandArgs(TRUE);
#if(length(args) > 0){
#	m <- as.integer(args[1]);
#	n <- as.integer(args[2]);
#}
#run2(m,n);
