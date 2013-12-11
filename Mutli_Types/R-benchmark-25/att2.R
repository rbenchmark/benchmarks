# TODO: Add comment
# 
###############################################################################

setup <- function() {
	require(Matrix)
}

run <- function(dataset, runs = 3) {
	cat("   II. Matrix functions\n")
	cat("   --------------------\n")
	cat("FFT over 2,400,000 random values\n");
	for (i in 1:runs) {
		a <- rnorm(2400000)
		b <- fft(a)
	}	
	cat("Eigenvalues of a 640x640 random matrix\n");
	for (i in 1:runs) {
		a <- array(rnorm(600*600), dim = c(600, 600))
		b <- eigen(a, symmetric=FALSE, only.values=TRUE)$Value
	}	
	cat("Determinant of a 2500x2500 random matrix\n");
	for (i in 1:runs) {
		a <- rnorm(2500*2500); dim(a) <- c(2500, 2500)
		b <- det(a)
	}	
	cat("Cholesky decomposition of a 3000x3000 matrix\n");
	for (i in 1:runs) {
		a <- crossprod(new("dgeMatrix", x = rnorm(3000*3000),
						Dim = as.integer(c(3000, 3000))))
		b <- chol(a)
	}	
	cat("Inverse of a 1600x1600 random matrix\n");
	for (i in 1:runs) {
		a <- new("dgeMatrix", x = rnorm(1600*1600), Dim = as.integer(c(1600, 1600)))
		b <- solve(a)
	}	
}