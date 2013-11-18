# TODO: Add comment
# 
# Author: Administrator
###############################################################################

# I define GCD and LCM inside the run function

setup <- function(args='100') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 100 }
    return(n)
}

run <- function(repcount=100) {
	gcd = function(m, n) {
		while (n != 0){
			t <- n;
			n <- m %% n;
			m <- t; 
		}
		m;
	}
	
	lcm = function(m,n) {
		m * n / gcd(m,n);
	}
	
	#construct the input
	n<-40
	residual <- 1:n; #n length vec
	divisor <- residual+1; #n length vec

	
	#print(divisor);
	#print(residual);
	#benchpart
	for(iter in 1:repcount){
		a <- divisor[1];
		r <- residual[1];
		for(i in 2:n) {
			
			while(r %% divisor[i] != residual[i]) {
				r <- r + a;
				#print("a/r=");print(a);print(r);
			}
			a <- lcm(a, divisor[i]);
			#print("a=");print(a);
		}
	}
	print(r);
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}
