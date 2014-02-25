# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("Creation of a 500x500 Toeplitz matrix (loops)\n");
	for (i in 1:runs) {
		b <- rep(0, 500*500); dim(b) <- c(500, 500)
		for (j in 1:500) {
			for (k in 1:500) {
				jk<-j - k;
				b[k,j] <- abs(jk) + 1
			}
		}
	}	
}
