# TODO: Add comment
# 
###############################################################################

#??switch
run <- function(runs = 3) {
	cat("Sorting of 7,000,000 random values\n");
	for (i in 1:runs) {
		a <- rnorm(7000000)
		b <- sort(a, method="quick")
	}	
}
