# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	require(Matrix)
	cat("Linear regr. over a 3000x3000 matrix (c = a \\ b')\n");
	for (i in 1:runs) {
		a <- new("dgeMatrix", x = rnorm(2000*2000), Dim = as.integer(c(2000,2000)))
		b <- as.double(1:2000)
		c <- solve(crossprod(a), crossprod(a,b))
	}	
}
