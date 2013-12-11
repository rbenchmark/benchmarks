# TODO: Add comment
# 
# Author: Haichuan Wang(hwang154@illinois.edu)
###############################################################################

setup <- function(args='100000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 100000 }
    return(n)
}

#Simple trivial test of n
#no any optimizaiton, just test the worst loop case

run <- function(n=100000) {
	if(n<2) { n <- 2;}
	
	num_primes <- 0;

	for(i in 2:n) {
		limit <- sqrt(i);
		prime <- TRUE; #for 2 is prime
		j<-2; # i %% j
		while(prime && j <= limit){
			if((i %% j) ==0) { prime <- FALSE;}
			j <- j+1;
		}
		if(prime) {
			#print("prime:");print(i);
			num_primes<-num_primes+1;
		}
	}
	print(num_primes);
}


if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}