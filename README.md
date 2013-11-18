#R Benchmark Suite

R Benchmark Suite is a collection of benchmarks for R programming language as well as a benchmarking environment for measuring the performance of different R VM implementations.

## Writing a benchmark R program



Please refer [Writing Benchmark](docs/writting_benchmark.md) for additional controls of the benchmark program

## Running a benchmark


Please refer [Running Benchmark](docs/running_benchmark.md) for additional controls of running a benchmark


## Available benchmark suites

We define three categories for different R program styles.

### Type I: Looping Over Data
'''R
#ATT bench: creation of Toeplitz matrix
for (j in 1:500) {
    for (k in 1:500) {
        jk<-j - k;
        b[k,j] <- abs(jk) + 1
    }
}
'''

### Type II: Vector Programming
'''R
#Riposte bench: a and g are large vectors
males_over_40 <- function(a,g) {
    a >= 40 & g == 1
}
'''

### Type III:  Native library Glue
'''R
#ATT bench: FFT over 2.4Mill random values
a <- rnorm(2400000);
b <- fft(a)
'''

Collections of Benchmarks of R
