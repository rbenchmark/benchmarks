# ------------------------------------------------------------------
# The Computer Language Shootout
# http://shootout.alioth.debian.org/
#
# Contributed by Leo Osvald
#
# Original Loc: https://github.com/allr/fastr/tree/master/test/r/shootout/mandelbrot
# Modified to be compatible with rbenchmark interface
# ------------------------------------------------------------------


setup <- function(args='1000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 1000 }
    return(n)
}

run<-function(n) {

    lim <- 2
    iter <- 50
    
    cat("P4\n")
    cat(n, n, "\n")
    bin_con <- pipe("cat", "wb")
    for (y in 0:(n-1)) {
        bits <- 0L
        x <- 0L
        while (x < n) {
            c <- 2 * x / n - 1.5 + 1i * (2 * y / n - 1)
            z <- 0+0i
            i <- 0L
            while (i < iter && abs(z) <= lim) {
                z <- z * z + c
                i <- i + 1L
            }
            bits <- 2L * bits + as.integer(abs(z) <= lim)
            if ((x <- x + 1L) %% 8L == 0) {
                writeBin(as.raw(bits), bin_con)
                bits <- 0L
            }
        }
        xmod <- x %% 8L
        if (xmod)
            writeBin(as.raw(bits * as.integer(2^(8L - xmod))), bin_con)
        flush(bin_con)
    }
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}