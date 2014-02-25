# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("Determinant of a 2500x2500 random matrix\n");
	for (i in 1:runs) {
		a <- rnorm(2500*2500); dim(a) <- c(2500, 2500)
		b <- det(a)
	}	
}
