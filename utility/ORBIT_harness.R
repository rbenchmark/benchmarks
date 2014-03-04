# Harness for all the benchmarks of rbenchmark
#
# Author: Haichuan Wang
#
# Requirements: ORBIT as the RVM

harness_args <- commandArgs(TRUE)
harness_argc <- length(harness_args)
if(harness_argc < 4) {
    print("Usage: Rscript --vanilla ORBIT_Harness.R enableByteCode[TRUE/FALSE] useSystemTime[TRUE/FALSE] RepTimes yourFile.R arg1 arg2 ...")
    q()
}

if(!file.exists(harness_args[4])) {
    print("Cannot find", harness_args[4])
    q()
}

useSystemTime <- as.logical(harness_args[2])
if(is.na(useSystemTime)) { useSystemTime <- FALSE }
bench_reps <- as.integer(harness_args[3])
if(bench_reps < 2) {
    print("ORBIT requires bench repeat times >=2!")
    q()
}
source(harness_args[4])

if(!exists('run')) {
    print("Error: There is no run() function in your benchmark file!")
    q()
}

library(compiler);
run <- cmpfun(run)

if(harness_argc > 4) {
    bench_args <- harness_args[5:harness_argc]
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
if(useSystemTime){
    if(length(bench_args) == 0) {
        bench_time <- system.time({
            invisible(.Internal(roeonoff(1L)));
            run();
            invisible(.Internal(roeonoff(2L)));
            for(bench_i in 2:bench_reps) { run() };
            invisible(.Internal(roeonoff(0L)));
        })
    } else {
        bench_time <- system.time({
            invisible(.Internal(roeonoff(1L)));
            run(bench_args);
            invisible(.Internal(roeonoff(2L)));
            for(bench_i in 2:bench_reps) { run(bench_args) }
            invisible(.Internal(roeonoff(0L)));
        })
    }
    rawtime <- c(bench_time[[1]],bench_time[[2]],bench_time[[3]])
    write(rawtime, file='.rbench.system.time', sep=',')
} else {
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
}
