# TODO: Add comment
# 
###############################################################################

setup <- function() {
	require(Matrix)
}

run <- function(dataset, runs = 3) {

	cat("   I. Matrix calculation\n")
	cat("   ---------------------\n")
	cat("2400x2400 normal distributed random matrix ^1000\n");
	for (i in 1:runs) {
		a <- abs(matrix(rnorm(2500*2500)/2, ncol=2500, nrow=2500));
		b <- a^1000 
	}
	
	cat("Creation, transp., deformation of a 2500x2500 matrix\n");
	for (i in 1:runs) {
		a <- matrix(rnorm(2500*2500)/10, ncol=2500, nrow=2500);
		b <- t(a);
		dim(b) <- c(1250,5000);
		a <- t(b)
	}	
	
	cat("2800x2800 cross-product matrix (b = a' * a)\n");
	for (i in 1:runs) {
		a <- rnorm(2800*2800); dim(a) <- c(2800, 2800)
		b <- crossprod(a)		# equivalent to: b <- t(a) %*% a
	}	
	
	cat("Sorting of 7,000,000 random values\n");
	for (i in 1:runs) {
		a <- rnorm(7000000)
		b <- sort(a, method="quick")
	}	
	

	cat("Linear regr. over a 3000x3000 matrix (c = a \\ b')\n");
	for (i in 1:runs) {
		a <- new("dgeMatrix", x = rnorm(2000*2000), Dim = as.integer(c(2000,2000)))
		b <- as.double(1:2000)
		c <- solve(crossprod(a), crossprod(a,b))
	}	
}