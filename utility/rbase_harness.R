# Harness for all the benchmarks of rbenchmark
#
# Author: Haichuan Wang
#
# Requirements: 

harness_args <- commandArgs(TRUE)
harness_argc <- length(harness_args)
if(harness_argc < 2 || !file.exists(harness_args[1])) {
    print("Usage: Rscript --vanilla Harness.R yourFile.R repTimes arg1 arg2 ...")
    q()
}

source(harness_args[1])
bench_reps <- as.integer(harness_args[2])

if(!exists('run', mode='function')) {
    print("Error: There is no run() function in your benchmark file!")
    q()
}

if(harness_argc > 2) {
    bench_args <- harness_args[3:harness_argc]
} else {
    bench_args <- NULL
}

if(exists('warmup', mode='function')) {
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


