#R Benchmark Suite

R Benchmark Suite is a collection of benchmarks for R programming language as well as a benchmarking environment for measuring the performance of different R VM implementations.

## Available benchmark suites

We defined three categories for different R program styles.

### Type I: Looping Over Data

Example
```
#R-benchmark-25: creation of Toeplitz matrix
for (j in 1:500) {
    for (k in 1:500) {
        jk<-j - k;
        b[k,j] <- abs(jk) + 1
    }
}
```
Collected benchmarks
- Type_I
  + mathkernel: Simple math kernels, such as matrix-matrix multiply, vector add, etc., written in Type I style.
  + R-benchmark-25: subtasks of Programmation in R-benchmark-25
  + scalar: A few simple micro benchmarks, such as fib, forloop, primes, etc..
  + shootout: Collected from difference sources, including FastR project https://github.com/allr, ORBIT project, etc. 

### Type II: Vector Programming

Example
```
#Riposte benchmark: a and g are large vectors
males_over_40 <- function(a,g) {
    a >= 40 & g == 1
}
```
Collected benchmarks
- Type_II
  + mathkernel: Simple math kernels, such as matrix-matrix multiply, vector add, etc., written in Type II style.
  + riposte: Vector dominated benchmark used in Riposte project

### Type III:  Native library Glue

Example
```
#R-benchmark-25:  FFT over 2.4Mill random values
a <- rnorm(2400000);
b <- fft(a)
```

Collected benchmarks
- Type_III
  + mathkernel: Simple math kernels, such as matrix-matrix multiply, etc., written in Type III style.
  + R-benchmark-25: subtasks of Matrix calculation and Matrix_functions in R-benchmark-25

### Mixed Types

Some benchmarks are hard to be categorized into a single type. We store them under
- Multi-Types
  + R-benchmark-25((ATT benchmark): The full version, ported from http://r.research.att.com/benchmarks/R-benchmark-25.R
  + misc: Benchmarks collected from the web


## Running a benchmark

The driver is [rbench.py](utility/rbench.py) under utility directory. You can use "-h" to get the help.
```bash
$ rbench.py -h
usage: rbench.py [-h] [--meter {time,perf,system.time}]
                 [--rvm {R,R-bytecode,rbase2.4,...}]
                 [--warmup_rep WARMUP_REP] [--bench_rep BENCH_REP]
                 source [args [args ...]]
...
```

Note: on Windows platform, please use "python rbench.py -h"

Do a simple benchmark
```bash
$ cd examples
$ ../utility/rbench.py hello_rbenchmark.R
```

It will use the default R VM (R-bytecode) and the default meter to benchmark the application. 

The basic benchmark method has two phases
- pure warmup: run run() 2 times
- warmup + benchmark: run run() 2 + 5 times

Then the post processing will diff the two phases, and reports the average value for the 5 benchmark iterations.

You can use command line to do more controls
```bash
$ cd examples
$ ../utility/rbench.py --meter perf --rvm R hello_rbenchmark.R 1000
```

Then it will use Linux perf (only on Linux Platform) for the data measuring, and choose the R (without byte-code compiler) as the VM for benchmarking.

You can run benchmark for all .R files in a directory, or run benchmarks defined in a .list file.

Please refer [Running Benchmark](docs/running_benchmark.md) for additional controls of running a benchmark


## Writing your own benchmark R program

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

run <- function (input) { # input = setup(cmdline_args)
    print("Executing hello_rbenchmark run() with input")
    print(input)
}
```

Please refer [Writing Benchmark](docs/writting_benchmark.md) for additional controls of the benchmark program

## Credit

The R-benchmark-25 benchmark is ported from http://r.research.att.com/benchmarks/.

The R version shootout benchmark is ported from UIUC ORBIT project and Purdue FastR project (https://github.com/allr/fastr).

The Riposte benchmark is ported from Riposte project (https://github.com/jtalbot/riposte/)

## Contact

Please contact Haichuan Wang (hwang154@illinois.edu) for any questions and suggestions. 
