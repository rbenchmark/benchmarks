# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("Eigenvalues of a 640x640 random matrix\n");
	for (i in 1:runs) {
		a <- array(rnorm(600*600), dim = c(600, 600))
		b <- eigen(a, symmetric=FALSE, only.values=TRUE)$Value
	}	
}
