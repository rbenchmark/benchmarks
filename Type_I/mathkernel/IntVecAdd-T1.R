# Vector Add
# 
###############################################################################

setup = function(args='10000000') {
    n <- as.integer(args[1])
    if(is.na(n)){ n <- 10000000 }
    
    cat("Vector Add two integer",  n, "size vectors, iterative method\n");
    
    A <- as.integer(rnorm(n) * 1000)
    B <- as.integer(rnorm(n) * 1000)
    
    list(A, B, n)
}



run <- function(data) {
    #a and b are matrix
    A <- data[[1]]
    B <- data[[2]]
    n <- data[[3]]
    C <- vector('double', n)
    for(i in 1:n) {
        C[i] = A[i] + B[i]
    }
    C
}