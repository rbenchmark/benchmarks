# Vector Add
# 
###############################################################################

setup = function(args='10000000') {
    n <- as.integer(args[1])
    if(is.na(n)){ n <- 10000000 }
    
    cat("Vector Add two",  n, "size vectors, built-in +\n");
    
    A <- rnorm(n)
    B <- rnorm(n)
    
    list(A, B, n)
}



run = function(data) {
    #a and b are matrix
    A <- data[[1]]
    B <- data[[2]]
    n <- data[[3]]
    C <- A + B
}