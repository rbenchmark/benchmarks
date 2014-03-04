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
import datetime
from perfreport import *
from hardwarereport import *

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
        if platform.system() == 'Windows':
            if rhome != '':
                config.set(rvm, 'CMD',  '"' + rhome + '\\' + config.get(rvm, 'CMD') + '"')
            config.set(rvm, 'HARNESS', utility_dir+'\\'+config.get(rvm, 'HARNESS'))  
        else:
            if rhome != '':
                config.set(rvm, 'CMD',  rhome + '/' + config.get(rvm, 'CMD'))
            config.set(rvm, 'HARNESS', utility_dir+'/'+config.get(rvm, 'HARNESS'))        
    
    warmup_rep = config.getint('GENERAL', 'WARMUP_REP')
    bench_rep = config.getint('GENERAL', 'BENCH_REP')
    
    return config, rvms, warmup_rep, bench_rep


def parse_args(rvms, warmup_rep, bench_rep):
    parser = argparse.ArgumentParser(description='''Run R benchmark script with a selected R VM.
                                                    Please refer https://github.com/rbenchmark/benchmarks for detail user manual''')
    parser.add_argument('--meter', choices=['time','perf', 'system.time'], default='time',
                         help='''Meter used to measure the benchmark.
                         time: only measure the time in ms (Outside R process);
                         perf: Linux perf, only available on Linux platform;
                         system.time: measure the time use R system.time() (Inside R process)''')
    parser.add_argument('--rvm', choices=rvms, default=rvms[0],
                        help='R VM used for the benchmark. Defined in rbench.cfg. Default is '+rvms[1])
    parser.add_argument('--warmup_rep', default=warmup_rep, type=int,
                        help='The number of repetition to execute run() in warmup. Default is %d' % warmup_rep)
    parser.add_argument('--bench_rep', default=bench_rep, type=int,
                        help='The number of repetition to execute run() in benchmark. Default is %d' % bench_rep)
    parser.add_argument('source', nargs=1,
                        help='R source file for the benchmark or a directory containing the benchmark files or a .list file containing a list of R benchmark files')
    parser.add_argument('args', nargs='*',
                        help='arguments used by the source file')
    args = parser.parse_args()
            
    if(args.warmup_rep < 0):
        print "[rbench]ERROR: WARMUP_REP number must be >= 0!"
        sys.exit(1)
    
    if(args.bench_rep < 1):
        print "[rbench]ERROR: BENCH_REP number must be > 0!"
        sys.exit(1)
    
    cmd_args = ' '.join(args.args) #the comand line args
    benchmarks = [] #each itme is a tuple (benchmarksrc, args)
    
    src = args.source[0]
    if os.path.isdir(src):
        for root, dirs, files in os.walk(args.source[0]):
            files.sort()
            for name in files:
                if name[-2:] == '.R':
                    benchmarks.append((os.path.join(root, name), cmd_args))
    
    if os.path.isfile(src):
        if src.endswith('.list'):
            #process it with a special routine
            srcdir = os.path.dirname(src)
            lines = [line.strip() for line in open(src)]
            for line in lines: #each line main contain script and args
                if len(line) > 0 and not line.startswith('#'):
                    benchmarks.append((os.path.join(srcdir, line) + ' ' + cmd_args).split(' ', 1))
        else:
            benchmarks = [(src,cmd_args)]
        
        
    if len(benchmarks) == 0:
        print "[rbench]ERROR: Cannot find benchmark R files. Please check the source: %s!" % args.source[0]
        sys.exit(1)
    
    return args, benchmarks

'''Return a dictionary'''
def run_bench(config, rvm, meter, warmup_rep, bench_rep, source, rargs):
    perf_cmd = config.get('GENERAL', 'PERF_CMD')
    perf_tmp = config.get('GENERAL', 'PERF_TMP')
    env = config.get(rvm, 'ENV')
    rcmd = config.get(rvm, 'CMD')
    rcmd_args = config.get(rvm, 'ARGS')
    harness = config.get(rvm, 'HARNESS')
    harness_args = config.get(rvm, 'HARNESS_ARGS')
    
    #Use meter value to decide weather use system.time() inside R
    if meter == 'system.time':
        use_system_time = 'TRUE'
    else:
        use_system_time = 'FALSE'
    
        
    if meter == 'perf':
        warmup_cmd = ' '.join([env, perf_cmd, rcmd, rcmd_args, harness, harness_args,
                               use_system_time, str(warmup_rep), source, rargs])
        bench_cmd = ' '.join([env, perf_cmd, rcmd, rcmd_args, harness, harness_args,
                               use_system_time, str(warmup_rep+bench_rep), source, rargs])
    else: #default python
        warmup_cmd = ' '.join([env, rcmd, rcmd_args, harness, harness_args,
                               use_system_time, str(warmup_rep), source, rargs])
        bench_cmd = ' '.join([env, rcmd, rcmd_args, harness, harness_args,
                               use_system_time, str(warmup_rep+bench_rep), source, rargs])
    
    #Start warmup
    if meter == 'perf':
        with open(perf_tmp, 'w') as f:
            f.write('WARMUP_TIMES:'+str(warmup_rep)+'\n')
    if warmup_rep > 0:
        print '[rbench]%s %s - Pure warmup run() %d times' % (source, rargs, warmup_rep) 
        print warmup_cmd
                
        start_t = time.time()
        warmup_exit_code = os.system(warmup_cmd)
        end_t = time.time()
        warmup_t = end_t - start_t#to ms
        
        if meter == 'system.time':
            #read the file .rbench.system.time
            try:
                with open('.rbench.system.time', 'r') as f:
                    lines = f.readline().split(',')
                    warmup_rtimes = [float(lines[0]), float(lines[1]), float(lines[2])]
            except:
                print '[rbench]Error: Cannot use system.time() to measure the running time! Fall back to meter=time'
                meter = 'time'
    else:
        warmup_t = 0
        if meter == 'system.time':
            warmup_rtimes = [0.0, 0.0, 0.0]
        
    #start benchmark
    if meter == 'perf':
        with open(perf_tmp, 'a') as f:
            f.write('BENCH_TIMES:' + str(warmup_rep+bench_rep)+'\n')
    print '[rbench]%s %s - Warmup + Bench run() %d times' % (source, rargs, warmup_rep+bench_rep)
    print bench_cmd
    start_t = time.time()
    bench_exit_code = os.system(bench_cmd)
    end_t = time.time()
    bench_t = end_t - start_t #to ms

    if meter == 'system.time':
    #read the file .rbench.system.time
        try:
            with open('.rbench.system.time', 'r') as f:
                lines = f.readline().split(',')
                bench_rtimes = [float(lines[0]), float(lines[1]), float(lines[2])]
                os.remove('.rbench.system.time')
        except:
               print '[rbench]Error: Cannot use system.time() to measure the running time! Fall back to meter=time'
               meter = 'time'
    
    #finally repare return the metrix
    if meter == 'perf':
        lines = [line.strip() for line in open(perf_tmp)]
        metrics = process_perf_lines(lines)
        #os.remove(perf_tmp)
        metrics['time'] = (bench_t - warmup_t) * 1000 / bench_rep
    elif meter == 'time':
        metrics = {}
        metrics['time'] = (bench_t - warmup_t) * 1000 / bench_rep
    else: #system.time
        metrics = {}
        metrics['user'] = (bench_rtimes[0] - warmup_rtimes[0]) * 1000 / bench_rep
        metrics['system'] = (bench_rtimes[1] - warmup_rtimes[1]) * 1000 / bench_rep
        metrics['elapsed'] = (bench_rtimes[2] - warmup_rtimes[2]) * 1000 / bench_rep
        
    
    
    if bench_exit_code != 0: #wrong result
        for key in metrics.keys():
            metrics[key] = float('nan')
    
    return metrics

def report(metrics, source, rargs):
    print '[rbench]%s %s - Metrics for one execution of run()' % (source, rargs) 
    keys = metrics.keys()
    keys.sort()
    for key in keys:
        print "%.2f,%s" % (metrics[key],key)


def report_header():
    print '===================  R Benchmark Report ==================='
    now = datetime.datetime.now()
    print '                     ', now.strftime("%Y-%m-%d %H:%M")

def report_all(benchmarks, metrics_array, rhome):
    report_header()
    report_platform(rhome)
    #title
    print '>> Benchmarks: %d Measured' % len(benchmarks)
    keys = [key for key in metrics_array[0].keys()]
    keys.append('benchmark')
    print ','.join(keys)
    for i in range(0, len(benchmarks)):
        value_strs = ['{:.2f}'.format(v) for v in metrics_array[i].values()]
        value_strs.append(' '.join(benchmarks[i]))
        print ','.join(value_strs)


def main():
    utility_dir = os.path.dirname(os.path.realpath(__file__))
    config, rvms, warmup_rep, bench_rep = parse_cfg(utility_dir)
    args, benchmarks = parse_args(rvms, warmup_rep, bench_rep)
    
    metrics_array = [None]*len(benchmarks)
    i = 0
    
    for (source,bench_args) in benchmarks:
        metrics = run_bench(config, args.rvm, args.meter, args.warmup_rep, args.bench_rep, source, bench_args)
        #print cwd_dir
        #finally print the metrics
        report(metrics, source, ' '.join(args.args))
        metrics_array[i] = metrics
        i = i + 1

    report_all(benchmarks, metrics_array, config.get(args.rvm, 'CMD'))


if __name__ == "__main__":
    main()
