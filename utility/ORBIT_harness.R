# Harness for all the benchmarks of rbenchmark
#
# Author: Haichuan Wang
#
# Requirements: ORBIT as the RVM

harness_args <- commandArgs(TRUE)
harness_argc <- length(harness_args)
if(harness_argc < 3) {
    print("Usage: Rscript --vanilla ORBIT_Harness.R enableByteCode[TRUE/FALSE] RepTimes yourFile.R arg1 arg2 ...")
    q()
}

if(!file.exists(harness_args[3])) {
    print("Cannot find", harness_args[3])
    q()
}

bench_reps <- as.integer(harness_args[2])
if(bench_reps < 2) {
    print("ORBIT requires bench repeat times >=2!")
    q()
}
source(harness_args[3])

if(!exists('run')) {
    print("Error: There is no run() function in your benchmark file!")
    q()
}

library(compiler);
run <- cmpfun(run)

if(harness_argc > 3) {
    bench_args <- harness_args[4:harness_argc]
} else {
    bench_args <- character(0)
}

if(exists('setup')) {
    if(length(bench_args) == 0) {
        bench_args <- setup() 
    } else {
        bench_args <- setup(bench_args)
    }
} 


# finally do benchmark
if(length(bench_args) == 0) {
    invisible(.Internal(roeonoff(1L)));
    run()
    invisible(.Internal(roeonoff(2L)));
    for(bench_i in 2:bench_reps) { run() }
    invisible(.Internal(roeonoff(0L)));
} else {
    invisible(.Internal(roeonoff(1L)));
    run(bench_args)
    invisible(.Internal(roeonoff(2L)));
    for(bench_i in 2:bench_reps) { run(bench_args) }
    invisible(.Internal(roeonoff(0L)));
}
