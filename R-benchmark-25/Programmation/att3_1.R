# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("3,500,000 Fibonacci numbers calculation (vector calc)\n");
	phi <- 1.6180339887498949
	for (i in 1:runs) {
		a <- floor(runif(3500000)*1000)
		b <- (phi^a - (-phi)^(-a))/sqrt(5)
	}	
}
