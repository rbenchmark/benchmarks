#!/usr/bin/python

'''
rbench.py -h
usage: rbench.py [-h] [--meter {time,perf}]
                 [--rvm {R,R-bytecode,rbase2.4,...}]
                 [--warmup_rep WARMUP_REP] [--bench_rep BENCH_REP]
                 source [args [args ...]]
...
'''

import sys, os, platform, subprocess
import time
import argparse
import ConfigParser
import datetime
from collections import OrderedDict
from perfreport import *
from hardwarereport import *
from time import strftime

def parse_cfg(utility_dir, filename='rbench.cfg'):
    return parse_cfg_file(utility_dir, utility_dir + '/rbench.cfg')

def parse_cfg_file(utility_dir, filename):
    config = ConfigParser.ConfigParser()
    config.read(filename)
    rvms = []
    for rvm in config.sections():
        if (rvm != 'GENERAL'):
            rvms.append(rvm)

    # Change the harness file's location here.
    # Set absolute R command paths.
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
    parser.add_argument('--rvm', default=rvms[0],
                        help='R VM used for the benchmark. Defined in rbench.cfg. Default is '+rvms[0])
    parser.add_argument('--warmup_rep', default=warmup_rep, type=int,
                        help='The number of repetition to execute run() in warmup. Default is %d' % warmup_rep)
    parser.add_argument('--bench_rep', default=bench_rep, type=int,
                        help='The number of repetition to execute run() in benchmark. Default is %d' % bench_rep)
    parser.add_argument('--timingfile', default='rbench.csv',
                        help='File to log the timing data in CSV format.  Default is rbench.csv')
    parser.add_argument('--config', help='Loads a custom config file.')
    parser.add_argument('source', nargs=1,
                        help='R source file for the benchmark or a directory containing the benchmark files or a .list file containing a list of R benchmark files')
    parser.add_argument('args', nargs='*',
                        help='arguments used by the source file')
    parser.add_argument('--bench_log', default='/dev/null',
                        help='File to log the output from the benchmarks or "stdout" to redirect to the script stdout (usually screen).')
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
def run_bench(config, rvm, meter, warmup_rep, bench_rep, source, rargs, bench_log):
    perf_cmd = config.get('GENERAL', 'PERF_CMD').split()
    perf_tmp = config.get('GENERAL', 'PERF_TMP')
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
        warmup_cmd = perf_cmd + [rcmd, rcmd_args, harness, harness_args,
                      use_system_time, str(warmup_rep), source, rargs]
        bench_cmd = perf_cmd + [rcmd, rcmd_args, harness, harness_args,
                     use_system_time, str(warmup_rep+bench_rep), source, rargs]
    else: #default python
        warmup_cmd = [rcmd, rcmd_args, harness, harness_args,
                      use_system_time, str(warmup_rep), source, rargs]
        bench_cmd = [rcmd, rcmd_args, harness, harness_args,
                     use_system_time, str(warmup_rep+bench_rep), source, rargs]

    # Create the environment dictionary for the subprocess module.
    env = os.environ.copy()
    bench_env = dict(x.split('=') for x in config.get(rvm, 'ENV').split(' '))
    env.update(bench_env)

    #Start warmup
    if meter == 'perf':
        with open(perf_tmp, 'w') as f:
            f.write('WARMUP_TIMES:'+str(warmup_rep)+'\n')
    if warmup_rep > 0:
        print '[rbench]%s %s - Pure warmup run() %d times' % (source, rargs, warmup_rep)
        print warmup_cmd
        if bench_log != sys.stdout:
            print >>bench_log, warmup_cmd  # Also log the command
            print >>bench_log, bench_env
            bench_log.flush()

        start_t = time.time()
        try:
            warmup_exit_code = subprocess.call(warmup_cmd, env=env, stdout=bench_log, stderr=subprocess.STDOUT)
            print >>bench_log
            bench_log.flush()
            if warmup_exit_code < 0:
                print >>sys.stderr, "Warmup terminated by signal ", -warmup_exit_code
        except OSError as e:  # Terminate the script on OS error.
            print >>sys.stderr, "Execution failed: ", e
            raise
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
    if bench_log != sys.stdout:
        print >>bench_log, bench_cmd  # Also log the command
        print >>bench_log, bench_env
        bench_log.flush()
    start_t = time.time()
    try:
        bench_exit_code = subprocess.call(bench_cmd, env=env, stdout=bench_log, stderr=subprocess.STDOUT)
        print >>bench_log, "\n"
        bench_log.flush()
        if bench_exit_code < 0:
            print >>sys.stderr, "Benchmark terminated by signal ", -bench_exit_code
    except OSError as e:  # Terminate the script on OS error.
        print >>sys.stderr, "Execution failed: ", e
        raise
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

def timestamp():
    now = datetime.datetime.now();
    return now.strftime("%Y-%m-%d %H:%M:%S") + strftime(" %z (%Z)", time.localtime())

def report(metrics, source, rargs):
    print '[rbench]%s %s - Metrics for one execution of run()' % (source, rargs)
    keys = metrics.keys()
    keys.sort()
    for key in keys:
        print "%.2f,%s" % (metrics[key],key)

def report_header():
    print '===================  R Benchmark Report ==================='
    now = datetime.datetime.now()
    print '                     ', timestamp()

def report_times(out, metrics_array, benchmarks, runspec, expt_env, print_colnames):
    if print_colnames:
        keys = [key for key in metrics_array[0].keys()]
        keys += ['timestamp', 'benchmark', 'args', 'path']
        keys += expt_env.keys()
        print >>out, ','.join(keys)
    for i in range(0, len(benchmarks)):
        value_strs = ['{:.2f}'.format(v) for v in metrics_array[i].values()]
        (source, args) = benchmarks[i]
        (source_dir, source_file, timestamp) = runspec[i]
        value_strs += [timestamp, source_file, args, source_dir]
        value_strs += expt_env.values()
        print >>out, ','.join(value_strs)

def report_all(benchmarks, metrics_array, runspec, rhome, expt_env):
    report_header()
    report_platform(rhome)
    #title
    print '>> Benchmarks: %d Measured' % len(benchmarks)
    report_times(sys.stdout, metrics_array, benchmarks, runspec, expt_env, True)

def main():
    utility_dir = os.path.dirname(os.path.realpath(__file__))
    config, rvms, warmup_rep, bench_rep = parse_cfg(utility_dir)
    args, benchmarks = parse_args(rvms, warmup_rep, bench_rep)
    if args.config:
        config, rvms, warmup_rep, bench_rep = parse_cfg_file(utility_dir, args.config)
    if not args.rvm in rvms:
        print '''[rbench]ERROR: Unknown RVM '%s'. Please choose one of %s''' % (args.rvm, rvms)
        sys.exit(1)
    metrics_array = [None]*len(benchmarks)
    runspec = [None]*len(benchmarks)
    expt_env = OrderedDict()
    expt_env['runs'] = str(args.warmup_rep + args.bench_rep)
    expt_env['Rscript'] = args.rvm
    expt_env['RscriptHome'] = config.get(args.rvm, 'HOME')
    expt_env['RscriptArgs'] = config.get(args.rvm, 'ARGS')
    expt_env['env'] = config.get(args.rvm, 'ENV')
    expt_env['platform'] = ' '.join([platform.system(), platform.release(),
                                     platform.version(), platform.machine(),
                                     platform.processor()])
    i = 0
    cur_dir = os.getcwd()
    try:
        print_colnames = not os.path.isfile(args.timingfile)
        out = open(args.timingfile, "a")
        print 'Logging the times in %s' % args.timingfile
    except IOError as e:
        print >>sys.stderr, "I/O error({0}): {1}".format(e.errno, e.strerror)
        print >>sys.stderr, "Benchmark data could not be logged!"

    if args.bench_log == 'stdout':
        bench_log = sys.stdout
    else:
        try:
            bench_log = open(args.bench_log, "w")
        except IOError as e:
            print >>sys.stderr, "Could not open benchmark log file for writing.  Logging on stdout."
            bench_log = sys.stdout

    for (source,bench_args) in benchmarks:
        try:
            (source_dir, source_file) = os.path.split(os.path.abspath(source))
            os.chdir(source_dir)
            metrics = run_bench(config, args.rvm, args.meter, args.warmup_rep, args.bench_rep, source_file, bench_args, bench_log)
            runspec[i] = [source_dir, source_file, timestamp()]
            metrics_array[i] = metrics
            report_times(out, metrics_array[i:i+1], benchmarks[i:i+1], runspec[i:i+1], expt_env, print_colnames)
            out.flush()
            os.fsync(out)
            print_colnames = False  # No column names after the first iteration.
            #finally print the metrics
            report(metrics, source, ' '.join(args.args))
            i = i + 1
        except IOError as e:
          print >>sys.stderr, "I/O error({0}): {1}".format(e.errno, e.strerror)
          print >>sys.stderr, "Some of the benchmark data could not be logged!"
        finally:
            os.chdir(cur_dir)

    report_all(benchmarks, metrics_array, runspec, config.get(args.rvm, 'CMD'), expt_env)
    out.close()
    bench_log.close()


if __name__ == "__main__":
    main()
