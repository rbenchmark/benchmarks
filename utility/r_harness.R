# Harness for all the benchmarks of rbenchmark
#
# Author: Haichuan Wang
#
# Requirements: 

harness_args <- commandArgs(TRUE)
harness_argc <- length(harness_args)
if(harness_argc < 4) {
    print("Usage: Rscript --vanilla r_harness.R enableByteCode[TRUE/FALSE] useSystemTime[TRUE/FALSE] RepTimes yourFile.R arg1 arg2 ...")
    q()
}

if(!file.exists(harness_args[4])) {
    print("Cannot find", harness_args[4])
    q()
}


enableBC <- as.logical(harness_args[1])
if(is.na(enableBC)) { enableBC <- FALSE }
useSystemTime <- as.logical(harness_args[2])
if(is.na(useSystemTime)) { useSystemTime <- FALSE }
bench_reps <- as.integer(harness_args[3])
source(harness_args[4])

if(!exists('run')) {
    print("Error: There is no run() function in your benchmark file!")
    q()
}

if(enableBC) {
    library(compiler);
	run <- cmpfun(run)
}

if(harness_argc > 4) {
    bench_args <- harness_args[5:harness_argc]
} else {
    bench_args <- character(0)
}
if(exists('setup')) {
    if(length(bench_args) == 0) {
        bench_args <- setup() 
        #TRUE
    } else {
        bench_args <- setup(bench_args)
        #FALSE
    }
} 

# finally do benchmark
if(useSystemTime){
    if(length(bench_args) == 0) {
        bench_time <- system.time(for(bench_i in 1:bench_reps) { run() })
    } else {
        bench_time <- system.time(for(bench_i in 1:bench_reps) { run(bench_args) })    
    }
    rawtime <- c(bench_time[[1]],bench_time[[2]],bench_time[[3]])
    write(rawtime, file='.rbench.system.time', sep=',')
} else {
    if(length(bench_args) == 0) {
        for(bench_i in 1:bench_reps) { run() }
    } else {
        for(bench_i in 1:bench_reps) { run(bench_args) }    
    }
}





