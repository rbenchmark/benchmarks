#R Benchmark Suite

R Benchmark Suite is a collection of benchmarks for R programming language as well as a benchmarking environment for measuring the performance of different R VM implementations.

## Writing a benchmark R program

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

Please refer [Writing Benchmark](docs/writting_benchmark.md) for additional controls of the benchmark program

## Running a benchmark

The driver is [rbench.py](utility/rbench.py) under utility directory. You can use "-h" to get the help.
```bash
$ rbench.py -h
usage: rbench.py [-h] [--meter {time,perf}]
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

Please refer [Running Benchmark](docs/running_benchmark.md) for additional controls of running a benchmark


## Available benchmark suites

We define three categories for different R program styles.

### Benchmark Categories

#### Type I: Looping Over Data

```
#ATT bench: creation of Toeplitz matrix
for (j in 1:500) {
    for (k in 1:500) {
        jk<-j - k;
        b[k,j] <- abs(jk) + 1
    }
}
```

#### Type II: Vector Programming

```
#Riposte bench: a and g are large vectors
males_over_40 <- function(a,g) {
    a >= 40 & g == 1
}
```

#### Type III:  Native library Glue

```
#ATT bench: FFT over 2.4Mill random values
a <- rnorm(2400000);
b <- fft(a)
```

### Collections of Benchmarks of R
- Scalar benchmark: A few simple micro benchmarks, such as fib, forloop, primes, etc..
  + Category: Type I
- shootout: R version of http://benchmarksgame.alioth.debian.org/. Different groups have different implementations
  + fastr version: ported from https://github.com/allr/
  + orbit version: ported from ORBIT (Optimized R Byte-code InterpreTer) project
    + Category: Type I
- R-benchmark-25(ATT benchmark): from http://r.research.att.com/benchmarks/R-benchmark-25.R
  + Category: Type I and III
