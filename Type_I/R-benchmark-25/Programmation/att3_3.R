# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("Grand common divisors of 400,000 pairs (recursion)\n");
	gcd2 <- function(x, y) {if (sum(y > 1.0E-4) == 0) x else {y[y == 0] <- x[y == 0]; Recall(y, x %% y)}}
	for (i in 1:runs) {
		a <- ceiling(runif(400000)*1000)
		b <- ceiling(runif(400000)*1000)
		c <- gcd2(a, b)                            # gcd2 is a recursive function
	}	
}
