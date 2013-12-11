# TODO: Add comment
# 
###############################################################################


run <- function(runs = 3) {
	cat("Escoufier's method on a 45x45 matrix (mixed)\n");
	Trace <- function(y) {sum(c(y)[1 + 0:(min(dim(y)) - 1) * (dim(y)[1] + 1)], na.rm=FALSE)}
	for (i in 1:runs) {
		x <- abs(rnorm(45*45)); dim(x) <- c(45, 45)
		p <- ncol(x)
		vt <- 1:p                                  # Variables to test
		vr <- NULL                                 # Result: ordered variables
		RV <- 1:p                                  # Result: correlations
		vrt <- NULL
		for (j in 1:p) {                           # loop on the variable number
			Rvmax <- 0
			for (k in 1:(p-j+1)) {                   # loop on the variables
				x2 <- cbind(x, x[,vr], x[,vt[k]])
				R <- cor(x2)                           # Correlations table
				Ryy <- R[1:p, 1:p]
				Rxx <- R[(p+1):(p+j), (p+1):(p+j)]
				Rxy <- R[(p+1):(p+j), 1:p]
				Ryx <- t(Rxy)
				rvt <- Trace(Ryx %*% Rxy) / sqrt(Trace(Ryy %*% Ryy) * Trace(Rxx %*% Rxx)) # RV calculation
				if (rvt > Rvmax) {
					Rvmax <- rvt                         # test of RV
					vrt <- vt[k]                         # temporary held variable
				}
			}
			vr[j] <- vrt                             # Result: variable
			RV[j] <- Rvmax                           # Result: correlation
			vt <- vt[vt!=vr[j]]                      # reidentify variables to test
		}
	}	
}
