# Shootout benchmark

The benchmark suite is ported from http://benchmarksgame.alioth.debian.org/.

The R shootout here are the combinations of several versions.
  - FastR version of Purdue FastR project (https://github.com/allr/fastr).
  - ORBIT version of UIUC ORBIT project

All the code were slightly modified to follow rbenchmark's interface.

## Attributes
Shootout is belong to Type I R code.

## The fastest R implementation
There are several different implementations of each shootout app included in the repository.
The fastest implementations (run with R byte-code interpreter 2.4.1) are

| Name | File |
|------|------|
| bindary-trees | bindary-trees.R|
| fannkuch-redux | fannkuch-redux.R |
| fasta | fasta-native.R |
| fasta-redux | fastaredux.R |
| k-nucleotide | k-nucleotide.R |
| mandelbrot | mandelbrot1.R |
| meteor-contest | meteor-contest.R |
| nbody | nbody.R |
| pidigits | pidigits.R |
| regex-dna | regexdna.R |
| reverse-complement | revcomp-1.R |
| spectral-norm | spectral-norm-alt.R |

Others we're still testing.

## Credit

- Purdue FastR project (https://github.com/allr/fastr).
- UIUC ORBIT project



