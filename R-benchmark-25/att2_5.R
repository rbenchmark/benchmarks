# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	require(Matrix)
	cat("Inverse of a 1600x1600 random matrix\n");
	for (i in 1:runs) {
		a <- new("dgeMatrix", x = rnorm(1600*1600), Dim = as.integer(c(1600, 1600)))
		b <- solve(a)
	}	
}
