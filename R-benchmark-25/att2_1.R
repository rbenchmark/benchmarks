# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("FFT over 2,400,000 random values\n");
	for (i in 1:runs) {
		a <- rnorm(2400000)
		b <- fft(a)
	}	
}
