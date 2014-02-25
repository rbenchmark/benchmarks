= Riposte Benchmark =

Ported from https://github.com/jtalbot/riposte/tree/master/benchmarks/pact
The original author is Justin Talbot.

The benchmarks were slightly modified to follow rbenchmark's interface, and they can take input size argument now.

== Run the benchmark ==

You need first generate the benchmark input data set using with GNU R
- gen_kmeans.R
- gen_lr.R
- gen_pca.R

Note: Please install *clusterGeneration* before run the above scripts.
```R
install.packages('clusterGeneration')
```

All the benchmarks can be run standalonely or with rbench.py
```bash
$ Rscript black_scholes.R
$ rbench.py black_scholes.R
```

== Known Issues ==
- qr.R doesn't work. Missing strip() function
- tpc.R doesn't work
