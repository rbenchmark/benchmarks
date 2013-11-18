# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("2800x2800 cross-product matrix (b = a' * a)\n");
	for (i in 1:runs) {
		a <- rnorm(2800*2800); dim(a) <- c(2800, 2800)
		b <- crossprod(a)		# equivalent to: b <- t(a) %*% a
	}	
}
