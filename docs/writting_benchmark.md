# Writing a R benchmark program

## Basic Structure

A benchmark R program should have a mandatory run() function. The driver will call run() function in the benchmarking.
```
#hello_rbenchmark.R
run <- function () {
    print("Executing hello_rbenchmark run()")
}
```

The benchmark R program could have an optional setup() function. The driver will call setup() first, then use the return value of the setup() to call the run().
```
#hello_rbenchmark.R

setup <- function(cmdline_args=character(0)) {
   return(cmdline_args)
}

run <- function (input) {
    print("Executing hello_rbenchmark run() with input")
    print(input)
}
```

## The Harness R program

The benchmark harness is like rbench.py -> r_harness.R -> yourProg.R.
- rbench.py: setup the environments, preprocess command lines, and post process output
- r_harness.R: load your benchmark program, and execute it

The harness code (r_harness.R)
```
#code snippet in r_harness.R
bench_args <- ... # the benchmark args from command line. 
#If no args passed in, bench_args is just character(0)

if(exists('setup')) {
    if(length(bench_args) == 0) {
        bench_args <- setup()        
    } else {
        bench_args <- setup(bench_args)
    }
}

if(length(bench_args) == 0) {
    for(bench_i in 1:bench_reps) { run() }
} else {
    for(bench_i in 1:bench_reps) { run(bench_args) }    
}
```

So you can put the code for parsing command line arguments and preparing dataset in the setup() function. 
Then harness will first call the setup(), then call the run() for several times.

## Adding default execute routine

If you want to run your application with
```bash
$ Rscript yourProg.R
```

you can add the default wrapper in yourProg.R, like this
```
run <- function { ... }

if (!exists('harness_argc')) {
    run()
}
```

Or with argument processing in the setup()
```
setup <- function(cmdline_args=character(0)) { ... }

run <- function (input) { ... }

if (!exists('harness_argc')) {
    input = setup(commandArgs(TRUE))
    run(input)
}
```

Because the r\_harness.R will define harness\_argc variable, the default execution routine will be ignored by the benchmark harness.
