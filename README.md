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
                 source [args [args ...]]
...
```

Do a simple benchmark
```bash
$ cd examples
$ ../utility/rbench.py hello_rbenchmark.R
```

It will use the default R VM (R-bytecode) and the default meter to benchmark the application. 

The basic benchmark method has two phases
- warumup: run run() 2 times
- benchmark: run run() 5 times

Then it reports the average value for the 5 benchmark iterations.

You can use command line to do more controls
```bash
$ cd examples
$ ../utility/rbench.py --meter perf --rvm R hello_rbenchmark.R 1000
```

Then it will use Linux perf (only in Linux Platform) for the data measuring, and choose the R (without byte-code compiler) as the VM for benchmarking.

Please refer [Running Benchmark](docs/running_benchmark.md) for additional controls of running a benchmark


## Available benchmark suites

We define three categories for different R program styles.

### Type I: Looping Over Data

```
#ATT bench: creation of Toeplitz matrix
for (j in 1:500) {
    for (k in 1:500) {
        jk<-j - k;
        b[k,j] <- abs(jk) + 1
    }
}
```

### Type II: Vector Programming

```
#Riposte bench: a and g are large vectors
males_over_40 <- function(a,g) {
    a >= 40 & g == 1
}
```

### Type III:  Native library Glue

```
#ATT bench: FFT over 2.4Mill random values
a <- rnorm(2400000);
b <- fft(a)
```

Collections of Benchmarks of R
