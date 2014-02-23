# Shootout benchmark

The benchmark suite is ported from http://benchmarksgame.alioth.debian.org/.

The R shootout here are the combinations of several versions.
  - FastR version of Purdue FastR project (https://github.com/allr/fastr).
  - ORBIT version of UIUC ORBIT project

All the code were slightly modified to follow rbenchmark's interface.

## Attributes
Shootout is belong to Type I R code.

## The fastest R implementation
There are several different implementations included in the repository.
The fastest implementations (run with R byte-code interpreter) are

| Name | File |
| bindary-trees | bindary-trees.R|
| fannkuch-redux | fannkuch-redux.R |

Others we're still testing.

## Credit

- Purdue FastR project (https://github.com/allr/fastr).
- UIUC ORBIT project



