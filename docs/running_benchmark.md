# Running a R benchmark

## The Basic Command

The driver is [rbench.py](../utility/rbench.py) under the utility directory. You can use "-h" to get the help.
```bash
$ rbench.py -h
usage: rbench.py [-h] [--meter {time,perf}]
                 [--rvm {R,R-bytecode,rbase2.4,...}]
                 [--warmup_rep WARMUP_REP] [--bench_rep BENCH_REP]
                 source [args [args ...]]
...
```

Do a simple benchmark
```bash
$ cd examples
$ ../utility/rbench.py hello_rbenchmark.R
```

It will use the default R VM (R-bytecode) and the default meter to benchmark the application. The output of benchmark application will be thrown away (redirect to /dev/null), and the timing result will be recorded in rbench.csv file.

The basic benchmark method has two phases
- pure warmup: run run() 2 times
- warmup + benchmark: run run() 2 + 5 times

Then the post processing will diff the two phases, and reports the average value for the 5 benchmark iterations.

## The Command Line Arguments

- --meter: Choose a meter for benchmarking. there are two meters right now
  + time: use the default timer of the os (outside R process). Precision is platform dependent. The reported value's unit is ms.
  + perf: Linux perf, only available on Linux platform. The reported value is from "perf stat"
  + system.time: measure the time use R system.time() (inside R process)
- --rvm: Choose a R VM for running the benchmark. All RVMs are defined in the [rbench.cfg](../utility/rbench.cfg) under the utility directory.
  + R: the default R in your environment, with R byte-code compiler disabled
  + R-bytecode: the default R in your environment, with R byte-code compiler enabled. By default, we use this R VM for benchmarking
  + ...: other R VMs listed in the [rbench.cfg](../utility/rbench.cfg)
- --warmup_rep: The number of repetition to execute run() in warmup. Default is 2.
- --bench_rep: The number of repetition to execute run() in Benchmark. At least 1. Default is 5.
- source: R source file for the benchmark or a directory containing the benchmark files or a .list file containing a list of R benchmark files
- args: the arguments that will be parsed into the source file.
- timingfile: the file to log the timing data in CSV format.  Default is "rbench.csv"
- bench_log: the file to log the output from the benchmarks or "stdout" to redirect to the script stdout (usually screen).

## Specify target for benchmarking

### A single R file
```bash
$ ../utility/rbench.py hello_rbenchmark.R 100
```

### A directory
The _src_ argument is a directory. The rbench driver will search all the .R files in the directory and sub directories, and run them one by one.

All the command line arguments will be applied to each R file's benchmarking.

```bash
$ ../utility/rbench.py Type_I/mathkernel 100  #100 will be applied to each .R
```

### A .list file
The _src_ argument is a .list file. Each line in the .list contains a .R file and the optional arguments for the benchmarking.

Here is one example riposte.list
```
# # is used for comment
black_scholes.R 10000
cleaning.R
example.R
```

When you run it with
```bash
$ ../../utility/rbench.py riposte.list 100
```
The additional argument 100 will be appended to the each line in the .list file for benchmarking.
For example, *black\_scholes.R*  will be run as "black_scholes.R 10000 100". 
*cleaning.R* will be run as "cleaning.R 100"


## The R Benchmark Driver Design

The infrastructure has a flexible structure that can support benchmarking different RVMs. It has three levels as below

```
rbench driver(rbench.py) -> GNUR harness (r_harness.R)       -> target R app
                         -> ORBIT harness (ORBIT_harness.R)
                         -> fastR harness (FastR_harness.R)
                         -> ...
                         -> raw harness (raw_harness.py) 
```

 - rbench driver: parsing command line arguments, and invoke the right harness
 - harness: connect to different RVMs, and control the benchmarking
 - target R app: the R file that has "run()" function for benchmarking

And the meter (timing or other counters) inside the rbench driver can measure the performance.
The design above allow the user to compare different RVMs result in a relatively similar way. Also it's fairly easy to add new harness to support new RVM.

### The harness file

A harness is typically written in R. The structure is

 - Parse the command line flags, get the source file name of the bench target, and other bench control parameters.
 - Load the bench target file by executing `source(filename)`
 - Do environment preparing. E.g. load  compiler package, and compile the run() function of the bench target if we want to test it with byte-code interpreter.
 - call setup() function in the bench target
 - call run() a few times according to the passed in arguments

There is a special harness called raw harness ([raw_harness.py](../utility/raw_harness.py)) that is used to support un-mature RVMs. For example, some RVMs donot have "source()" function. The raw harness will create a copy of the target R app, and insert the controls in the new R file, and invoke the RVM to directly execute the new R file.

### The Configuration Files

The configuration file [rbench.cfg](../utility/rbench.cfg) defines the general configurations as well as all the R VMs that could be used for benchmarking by the rbench driver.

There are several sections in the configuration file. The first section _GENERAL_ defines the basic information.
```
[GENERAL]
#Warmup iterations for run()
WARMUP_REP=2
#Benchmark iterations for run()
BENCH_REP=5
#Used for Linux perf temporary storage
PERF_TMP=_perf.tmp
#Linux perf measurement iterations
PERF_REP=1
#Linux perf command - default one
PERF_CMD=perf stat -r %(PERF_REP)s -x, -o %(PERF_TMP)s --append
```

Each of the following sections defines a new RVM installed in your environment. The rbench driver use the info to invoke the right RVM with the right harness file. For example, a rbytecode2.4 VM
```
[rbytecode2.4]
ENV=R_HOME=%(HOME)s R_COMPILE_PKGS=1 R_ENABLE_JIT=2
HOME=%(BASE_PATH)s/R-2.14.1.base
CMD=bin/Rscript
ARGS=--vanilla
HARNESS=r_harness.R
HARNESS_ARGS=TRUE
```

These configurations will be used to generate the command line issued by the driver.

### The Shell Commands Generated by the driver
The driver [rbench.py](../utility/rbench.py) will use the configuration info in [rbench.cfg](../utility/rbench.cfg) and the command line input to generate the command for benchmarking.

For example, if we use the default meter, the command line (shell script) structure is
```
#pure warmup
${ENV} ${CMD} ${ARGS} ${HARNESS} ${HARNESS_ARGS} ${WARMUP_REP} source args ...
#warmup + benchmark
${ENV} ${CMD} ${ARGS} ${HARNESS} ${HARNESS_ARGS} ${WARMUP_REP+BENCH_REP} source args ...
```

Let's use the hello_rbenchmark.R and all the default configuration as example, the final two commands are
```
#the command line, with the benchmark input is 1234
../utility/rbench.py hello_rbenchmark.R 1234
#pure warmup
R_COMPILE_PKGS=1 R_ENABLE_JIT=2 Rscript --vanilla /cygdrive/c/workspace/project/rbenchmark/benchmarks/utility/r_harness.R TRUE FALSE 2 hello_rbenchmark.R 1234
#warmup + benchmark
R_COMPILE_PKGS=1 R_ENABLE_JIT=2 Rscript --vanilla /cygdrive/c/workspace/project/rbenchmark/benchmarks/utility/r_harness.R TRUE FALSE 7 hello_rbenchmark.R 1234
```

## Add R VM for Benchmarking

In order to add a new RVM for benchmarking test, the VM developer needs to add a section in the configuration file [rbench.py](../utility/rbench.py).
And provide the required harness file if necessary.

For example, there is a pqR config in the configuration file. It reuses the r_harness.R
```
[pqRbase2.5]
ENV=R_HOME=%(HOME)s
HOME=%(BASE_PATH)s/pqR-2013-07-22
CMD=bin/Rscript
ARGS=--vanilla
HARNESS=r_harness.R
HARNESS_ARGS=FALSE
```

And there is a TERR config in the configuration file. Because TERR has no Rscript like command, we had to pass all into the TERR command.
```
[TERR]
ENV=TERR_HOME=%(HOME)s
HOME=/home/hwang154/tools/TIBCO/terr15
CMD=bin/TERR
ARGS=-f
HARNESS=r_harness.R
HARNESS_ARGS=--args FALSE
```

## Supported R VMs for Benchmarking

- GNU R: all versions of GNU R. Can select using byte-code compiler or not
- pqR: a pretty quick version of R. http://www.pqr-project.org/
- TERR: TIBCO Enterprise Runtime for R (TERR). [Web](http://spotfire.tibco.com/en/discover-spotfire/what-does-spotfire-do/predictive-analytics/tibco-enterprise-runtime-for-r-terr.aspx)
- Purdue FastR: https://github.com/allr/fastr
- Orcale FastR(TruffleR): https://bitbucket.org/allr/fastr
- Renjin: http://www.renjin.org/
- Riposte: https://github.com/jtalbot/riposte
- Rapydo: https://bitbucket.org/cfbolz/rapydo/src
- ORBIT: 

The command line arguments of several experiment R VMs, such as FastR, Renjin, Riposte, are different to the GNU R.
In order to benchmark these VMs, special harness scripts are used.
- FastR: fastr_harness.R. Simulate the print() function with cat().
- ORBIT: ORBIT_harness.R. Turn on ORBIT engine before run(), and turn off after run().
- Riposte, Renjin, Rapydo, TruffleR: raw_harness.py. Adding missing functions. Run the application from the directory where the VM is installed.

## (Deprecated) Makefile based driver
There is a makefile based driver for the benchmarking, include common.mk and Makefile in each directory. It is deprecated. 
