# Harness for all the benchmarks of rbenchmark
#
# Author: Haichuan Wang
#
# Requirements: fast_r has no print function. Just use cat to simulate print


#fast_r has no harness
print <- function(...) { cat(..., '\n') }

harness_args <- commandArgs(TRUE)
harness_argc <- length(harness_args)

cat('harness_args =', harness_args, '\n')
cat('harness_argc =', harness_argc, '\n')
#if(harness_argc < 3) {
#    cat("Usage: ./r.sh --vanilla Harness.R enableByteCode[Y/N] RepTimes yourFile.R arg1 arg2 ...\n")
#    q()
#}

#if(!file.exists(harness_args[3])) {
#    cat("Cannot find", harness_args[3], '\n')
#    q()
#}

bench_reps <- as.integer(harness_args[4])
source(harness_args[5])

if(!exists('run')) {
    cat("Error: There is no run() function in your benchmark file!\n")
    q()
}

if(harness_argc > 5) {
    bench_args <- harness_args[6:harness_argc]
} else {
    bench_args <- character(0)
}

if(exists('setup')) {
    if(length(bench_args) == 0) {
        bench_args <- setup() 
        TRUE
    } else {
        bench_args <- setup(bench_args)
        FALSE
    }
} 

# finally do benchmark
if(length(bench_args) == 0) {
    for(bench_i in 1:bench_reps) { run() }
} else {
    for(bench_i in 1:bench_reps) { run(bench_args) }    
}


