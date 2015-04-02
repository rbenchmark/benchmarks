#R Benchmark Suite

R Benchmark Suite is a `collection of benchmarks` for R programming language as well as a `benchmarking environment` for measuring the performance of different R VM implementations.

## Available benchmark suites

| Name | Description | Type |
| ---- |-------------|------|
| Shooutout | R version of [Computer Language Benchmarks Game](http://benchmarksgame.alioth.debian.org/)| Type I |
| R-benchmark-25 | Also called [ATT benchmark](http://r.research.att.com/benchmarks/) | Type I and III |
| scalar | Micro benchmarks, such as GCD, fib, primes, etc. | Type I |
| mathkernel | Math kernels, such as Matrix-matrix multiply, vector add, etc. | Type I, II and III |
| riposte | Vector dominated benchmark used in [Riposte project](https://github.com/jtalbot/riposte) | Type II |
| misc | Some random collections | Type I, II, and III |

The benchmark type is defined as

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

### Type II: Vector Programming

Example
```
#Riposte benchmark: age and gender are large vectors
males_over_40 <- function(age, gender) {
    age >= 40 & gender == 1
}
```

### Type III:  Native library Glue

Example
```
#R-benchmark-25:  FFT over 2.4Mill random values
a <- rnorm(2400000);
b <- fft(a)
```

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

Note: on Windows platform, you may use "python rbench.py -h"

Do a simple benchmark
```bash
$ cd examples
$ ../utility/rbench.py hello_rbenchmark.R
```

It will use the default R VM (R-bytecode) and the default meter to benchmark the application. The output of benchmark application will be thrown away (redirect to "/dev/null"), and the timing result will be recorded in "rbench.csv" file.

The default benchmark method has two phases
- pure warmup: run run() 2 times
- warmup + benchmark: run run() 2 + 5 times

Then the post processing will diff the two phases, and reports the average value for the 5 benchmark iterations.

You can use command line to do more controls
```bash
$ cd examples
$ ../utility/rbench.py --meter perf --rvm R --bench_log stdout hello_rbenchmark.R 1000
```

Then it will use Linux perf (only on Linux Platform) for the data measuring, choose the R (without byte-code compiler) as the VM for benchmarking, and dump the benchmark's output to the standard output.

You can run benchmark for all .R files in a directory, or run benchmarks defined in a .list file.

Please refer [Running Benchmark](docs/running_benchmark.md) for additional controls of running a benchmark. 
And the driver supports many RVMs for benchmarking. Here is the [list](docs/running_benchmark.md#supported-r-vms-for-benchmarking). 


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

## FAQ

[FAQ](FAQ.md)

## Credit

The R-benchmark-25 benchmark is ported from http://r.research.att.com/benchmarks/.

The R version shootout benchmark is ported from UIUC ORBIT project and Purdue FastR project (https://github.com/allr/fastr).

The Riposte benchmark is ported from Riposte project (https://github.com/jtalbot/riposte/)

## Contact

Please contact Haichuan Wang (hwang154@illinois.edu) and Arun Chauhan(arunchauhan@google.com) for any questions and suggestions. 
