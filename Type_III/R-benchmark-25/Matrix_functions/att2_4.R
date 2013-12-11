# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	require(Matrix)
	cat("Cholesky decomposition of a 3000x3000 matrix\n");
	for (i in 1:runs) {
		a <- crossprod(new("dgeMatrix", x = rnorm(3000*3000),
						Dim = as.integer(c(3000, 3000))))
		b <- chol(a)
	}	
}
