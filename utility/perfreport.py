#!/usr/bin/python

import sys,string


    #problem found in perf, some metrics uses the same name
    #e.g. L1-dcache-misses for load misses and store misses
    
def gen_unique_metrix_name(bench_metrics, name, uid):
    if name in bench_metrics:
        name = name + str(uid)
        uid = uid + 1
    return name, uid

def process_perf_lines(lines):
    
    warmup_rep = 0
    bench_rep = 0
    warmup_metrics={}
    bench_metrics={}
    for line in lines:
        if line.startswith('WARMUP_TIMES'):
            values = string.split(line, ':')
            warmup_rep = int(values[1])
            unique_suffix_id = 1;
        elif line.startswith('BENCH_TIMES'):
            values = string.split(line, ':')
            bench_rep = int(values[1])
            unique_suffix_id = 1;
        elif ',' in line and (not line.startswith('<not supported>')):
            values=string.split(line,',')
            #now dependent on the state
            if (bench_rep == 0): #warmup period
                mname, unique_suffix_id = gen_unique_metrix_name(warmup_metrics, values[1], unique_suffix_id)
                warmup_metrics[mname] = float(values[0])
            else: # now in benchmark parse period
                mname, unique_suffix_id = gen_unique_metrix_name(bench_metrics, values[1], unique_suffix_id)
                bench_metrics[mname] = float(values[0])
    
    if(warmup_rep > 0):
        for key in bench_metrics:
            bench_metrics[key] = (bench_metrics[key] - warmup_metrics[key]) / (bench_rep - warmup_rep)
    else:
        for key in bench_metrics:
            bench_metrics[key] = (bench_metrics[key]) / (bench_rep)
        
    return bench_metrics


if __name__ == "__main__":
    #lines = [line.strip() for line in open('_perf.tmp')]
    lines = [line.strip() for line in sys.stdin.readlines()]
    metrics = process_perf_lines(lines)
    print "==== Each Iteration Metrics ===="
    keys = metrics.keys()
    keys.sort()
    for key in keys:
        print "%.2f,%s" % (metrics[key],key)
