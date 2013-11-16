#!/usr/bin/python

import sys,string



def process_perf_lines(lines):
    warm_rep=int(lines[0])
    metrics={}
    #warmup
    for line in lines[3:13]:
        values=string.split(line,',')
        metrics[values[1]]=float(values[0])
        
    bench_rep=int(lines[13])
    #all loops
    for line in lines[16:26]:
        values=string.split(line,',')
        metrics[values[1]]=(float(values[0]) - metrics[values[1]]) / (bench_rep - warm_rep)
    
    return metrics

if __name__ == "__main__":
    #lines = [line.strip() for line in open('_perf.tmp')]
    lines = [line.strip() for line in sys.stdin.readlines()]
    process_perf_lines(lines)
    print "==== Each Iteration Metrics ===="
    keys = metrics.keys()
    keys.sort()
    for key in keys:
        print "%.2f,%s" % (metrics[key],key)
