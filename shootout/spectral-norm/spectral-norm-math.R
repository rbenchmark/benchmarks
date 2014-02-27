# ------------------------------------------------------------------
# The Computer Language Shootout
# http://shootout.alioth.debian.org/
#
# Contributed by Leo Osvald
#
# Original Loc: https://github.com/allr/fastr/blob/master/test/r/shootout/spectralnorm/
# Modified to be compatible with rbenchmark interface
# ------------------------------------------------------------------

setup <- function(args='3000') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 3000L }
    return(n)
}

run <-function(n) {

    options(digits=10)
    
    eval_A <- function(i, j) 1 / ((i + j - 2) * (i + j - 1) / 2 + i)
    
    m <- outer(seq(n), seq(n), FUN=eval_A)
    cat(sqrt(max(eigen(t(m) %*% m)$val)), "\n")

}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}
