# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("2400x2400 normal distributed random matrix ^1000\n");
	for (i in 1:runs) {
		a <- abs(matrix(rnorm(2500*2500)/2, ncol=2500, nrow=2500));
		b <- a^1000 
	}	
}
