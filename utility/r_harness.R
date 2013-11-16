# Harness for all the benchmarks of rbenchmark
#
# Author: Haichuan Wang
#
# Requirements: 

harness_args <- commandArgs(TRUE)
harness_argc <- length(harness_args)
if(harness_argc < 3 || !file.exists(harness_args[3])) {
    print("Usage: Rscript --vanilla Harness.R enableByteCode[Y/N] RepTimes yourFile.R arg1 arg2 ...")
    q()
}

enableBC <- as.logical(harness_args[1])
if(is.na(enableBC)) { enableBC <- FALSE }
bench_reps <- as.integer(harness_args[2])
source(harness_args[3])

if(!exists('run')) {
    print("Error: There is no run() function in your benchmark file!")
    q()
}

if(enableBC) {
    library(compiler);
	run <- cmpfun(run)
}

if(harness_argc > 3) {
    bench_args <- harness_args[4:harness_argc]
} else {
    bench_args <- NULL
}

if(exists('warmup')) {
    if(is.null(bench_args)) {
        bench_args <- warmup()        
    } else {
        bench_args <- warmup(bench_args)
    }
} 

# finally do benchmark
if(is.null(bench_args)) {
    for(bench_i in 1:bench_reps) { run() }
} else {
    for(bench_i in 1:bench_reps) { run(bench_args) }    
}


