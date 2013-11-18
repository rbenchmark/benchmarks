# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("Creation of a 3000x3000 Hilbert matrix (matrix calc)\n");
	a <- 3000
	for (i in 1:runs) {
		b <- rep(1:a, a); dim(b) <- c(a, a);
		b <- 1 / (t(b) + 0:(a-1))
	}	
}
