# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("Creation, transp., deformation of a 2500x2500 matrix\n");
	for (i in 1:runs) {
		a <- matrix(rnorm(2500*2500)/10, ncol=2500, nrow=2500);
		b <- t(a);
		dim(b) <- c(1250,5000);
		a <- t(b)
	}	
}
