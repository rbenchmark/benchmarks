#!/usr/bin/python

'''
rbench.py -h
usage: rbench.py [-h] [--meter {time,perf}]
                 [--rvm {R,R-bytecode,rbase2.4,...}]
                 [--warmup_rep WARMUP_REP] [--bench_rep BENCH_REP]
                 source [args [args ...]]
...
'''

import sys, os, platform
import time
import argparse
import ConfigParser
from perfreport import *

def parse_cfg(utility_dir):
    config = ConfigParser.ConfigParser()
    config.read(utility_dir+'/rbench.cfg')
    rvms = []
    for rvm in config.sections():
        if (rvm != 'GENERAL'):
            rvms.append(rvm)
    
    #then change the harness file's location here
    for rvm in rvms:
        rhome = config.get(rvm, 'HOME')
        if rhome != '':
            if platform.system() == 'Windows':
                config.set(rvm, 'CMD',  '"' + rhome + '\\' + config.get(rvm, 'CMD') + '"')
                config.set(rvm, 'HARNESS', utility_dir+'\\'+config.get(rvm, 'HARNESS'))  
            else:
                config.set(rvm, 'CMD',  rhome + '/' + config.get(rvm, 'CMD'))
                config.set(rvm, 'HARNESS', utility_dir+'/'+config.get(rvm, 'HARNESS'))        
    
    warmup_rep = config.getint('GENERAL', 'WARMUP_REP')
    bench_rep = config.getint('GENERAL', 'BENCH_REP')
    
    return config, rvms, warmup_rep, bench_rep


def parse_args(rvms, warmup_rep, bench_rep):
    parser = argparse.ArgumentParser(description='''Run R benchmark script with a selected R VM.
                                                    Please refer https://github.com/rbenchmark/benchmarks for detail user manual''')
    parser.add_argument('--meter', choices=['time','perf'], default='time',
                         help='''Meter used to measure the benchmark.
                         time: only measure the time in ms.
                         perf: Linux perf, only available at Linux platform''')
    parser.add_argument('--rvm', choices=rvms, default=rvms[1],
                        help='R VM used for the benchmark. Defined in rbench.cfg. Default is '+rvms[1])
    parser.add_argument('--warmup_rep', default=warmup_rep, type=int,
                        help='The number of repetition to execute run() in warmup. Default is %d' % warmup_rep)
    parser.add_argument('--bench_rep', default=bench_rep, type=int,
                        help='The number of repetition to execute run() in benchmark. Default is %d' % bench_rep)
    parser.add_argument('source', nargs=1,
                        help='R source file for the benchmark')
    parser.add_argument('args', nargs='*',
                        help='arguments used by the source file')
    args = parser.parse_args()
    
    if(not os.path.isfile(args.source[0])):
        print "[rbench]ERROR: Cannot find source file %s!" % args.source[0]
        sys.exit(1)
        
    if(args.warmup_rep < 0):
        print "[rbench]ERROR: WARMUP_REP number must be >= 0!"
        sys.exit(1)
    
    if(args.bench_rep < 1):
        print "[rbench]ERROR: BENCH_REP number must be > 0!"
        sys.exit(1)
        
    return args

'''Return a dictionary'''
def run_bench(config, rvm, meter, warmup_rep, bench_rep, source, rargs):
    perf_cmd = config.get('GENERAL', 'PERF_CMD')
    perf_tmp = config.get('GENERAL', 'PERF_TMP')
    env = config.get(rvm, 'ENV')
    rcmd = config.get(rvm, 'CMD')
    rcmd_args = config.get(rvm, 'ARGS')
    harness = config.get(rvm, 'HARNESS')
    harness_args = config.get(rvm, 'HARNESS_ARGS')
    
        
    if meter == 'perf':
        warmup_cmd = ' '.join([env, perf_cmd, rcmd, rcmd_args, harness, harness_args,
                               str(warmup_rep), source, rargs])
        bench_cmd = ' '.join([env, perf_cmd, rcmd, rcmd_args, harness, harness_args,
                               str(warmup_rep+bench_rep), source, rargs])
    else: #default python
        warmup_cmd = ' '.join([env, rcmd, rcmd_args, harness, harness_args,
                               str(warmup_rep), source, rargs])
        bench_cmd = ' '.join([env, rcmd, rcmd_args, harness, harness_args,
                               str(warmup_rep+bench_rep), source, rargs])
    
    #Start warmup
    if meter == 'perf':
        with open(perf_tmp, 'w') as f:
            f.write(str(warmup_rep)+'\n')
    if warmup_rep > 0:
        print '[rbench]%s %s - Pure warmup run() %d times' % (source, rargs, warmup_rep) 
        print warmup_cmd
                
        start_t = time.time()
        warmup_exit_code = os.system(warmup_cmd)
        end_t = time.time()
        warmup_t = end_t - start_t#to ms
    else:
        warmup_t = 0
        
        
    #start benchmark
    if meter == 'perf':
        with open(perf_tmp, 'a') as f:
            f.write(str(warmup_rep+bench_rep)+'\n')
    print '[rbench]%s %s - Warmup + Bench run() %d times' % (source, rargs, warmup_rep+bench_rep)
    print bench_cmd
    start_t = time.time()
    bench_exit_code = os.system(bench_cmd)
    end_t = time.time()
    bench_t = end_t - start_t #to ms
    
    #finally repare return the metrix
    if meter == 'perf':
        lines = [line.strip() for line in open(perf_tmp)]
        metrics = process_perf_lines(lines)
        os.remove(perf_tmp)
    else:
        metrics = {}
        
    metrics['time'] = (bench_t - warmup_t) * 1000 / bench_rep
    
    return metrics

def report(metrics, source, rargs):
    print '[rbench]%s %s - Metrics for one execution of run()' % (source, rargs) 
    keys = metrics.keys()
    keys.sort()
    for key in keys:
        print "%.2f,%s" % (metrics[key],key)

def main():
    utility_dir = os.path.dirname(os.path.realpath(__file__))
    config, rvms, warmup_rep, bench_rep = parse_cfg(utility_dir)
    args = parse_args(rvms, warmup_rep, bench_rep)
    
    metrics = run_bench(config, args.rvm, args.meter, args.warmup_rep, args.bench_rep, args.source[0], ' '.join(args.args))
    
    #print cwd_dir
    #finally print the metrics
    report(metrics, args.source[0], ' '.join(args.args))


if __name__ == "__main__":
    main()
