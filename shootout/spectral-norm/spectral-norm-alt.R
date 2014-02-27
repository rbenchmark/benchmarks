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
    eval_A_times_u <- function(u) u %*% g_eval_A_mat
    eval_At_times_u <- function(u) u %*% g_eval_At_mat
    eval_AtA_times_u <- function(u) eval_At_times_u(eval_A_times_u(u))
    
    g_eval_A_mat <- outer(seq(n), seq(n), FUN=eval_A)
    g_eval_At_mat <- t(g_eval_A_mat)
    u <- rep(1, n)
    v <- rep(0, n)
    for (itr in seq(10)) {
        v <- eval_AtA_times_u(u)
        u <- eval_AtA_times_u(v)
    }
    
    cat(sqrt(sum(u * v) / sum(v * v)), "\n")

}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}
