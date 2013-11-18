#!/usr/bin/python

import sys,string


def parse_perf_lines(lines):
    metrics={}
    for line in lines:
        values=string.split(line,',')
        metrics[values[1]]=float(values[0])
    return metrics


def process_perf_lines(lines):
    warmup_rep=int(lines[0])
    
    if(warmup_rep >0):
        warmup_metrics = parse_perf_lines(lines[3:13])
        bench_rep = int(lines[13])
        bench_metrics = parse_perf_lines(lines[16:26])
        #do the diff
        for key in bench_metrics.keys():
            bench_metrics[key] = (bench_metrics[key] - warmup_metrics[key]) / (bench_rep - warmup_rep)
    else:
        bench_rep = int(lines[1])
        bench_metrics = parse_perf_lines(lines[4:14])
        
    return bench_metrics

if __name__ == "__main__":
    #lines = [line.strip() for line in open('_perf.tmp')]
    lines = [line.strip() for line in sys.stdin.readlines()]
    process_perf_lines(lines)
    print "==== Each Iteration Metrics ===="
    keys = metrics.keys()
    keys.sort()
    for key in keys:
        print "%.2f,%s" % (metrics[key],key)
