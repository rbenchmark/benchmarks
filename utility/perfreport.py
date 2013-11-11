#!/usr/bin/python
import sys,string
#lines = [line.strip() for line in open('_perf.tmp')]
lines = [line.strip() for line in sys.stdin.readlines()]

warm_c=int(lines[0])
metrics={}
#warmup
for line in lines[3:13]:
    values=string.split(line,',')
    metrics[values[1]]=float(values[0])

all_c=int(lines[13])
#all loops
for line in lines[16:26]:
    values=string.split(line,',')
    metrics[values[1]]=(float(values[0]) - metrics[values[1]]) / (all_c - warm_c)

#report
print "==== Each Iteration Metrics ===="
keys = metrics.keys()
keys.sort()
for key in keys:
    print "%.2f,%s" % (metrics[key],key)

