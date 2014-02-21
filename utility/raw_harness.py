#!/usr/bin/python


# Usage raw_harness.py Y/N repTimes sourceFile arguments


# finally, will append a full function file
'''
original R file

#if has input, gen

args=c(args, argd, ...)
dataset = setup

'''
import sys,os


raw_haress_str = '''

rnorm <- runif

if(exists('setup')) {
    if(length(bench_args) == 0) {
        bench_args <- setup() 
        TRUE
    } else {
        bench_args <- setup(bench_args)
        FALSE
    }
} 

if(length(bench_args) == 0) {
    for(bench_i in 1:bench_reps) { run() }
} else {
    for(bench_i in 1:bench_reps) { run(bench_args) }   
}




'''


if __name__ == "__main__":
    argv = sys.argv
    argc = int(argv[1]) #this is how many fixed for the rvm
    
    rvm_path = argv[2]
    rvm_cmd = argv[3:(argc+1)] #with all args
    
    use_system_time = argv[argc+1]
    if(use_system_time == 'TRUE'):
        print '[rbench]Cannot use system.time() for these experiment R VMs. Fall back to meter=time.'

    rep = argv[argc+2]
    print rep
    src = argv[argc+3] #the file
    print src
    #construct the file's full current full path
    src = os.path.join(os.getcwd(), src)
    #now generate the source file
    #use the benchmark file to 
    src_dir = os.path.dirname(src)
    src_basename = os.path.basename(src)
    tmpsrc = os.path.join(src_dir, 'rbench_'+src_basename)
    
    #then decide whether there are additional args
    if(len(argv) > argc+4):
        bench_args = argv[argc+4:]
        bench_args_str = "bench_args <- c('" + "','".join(bench_args)+ "')\n"
    else:
        bench_args_str = "bench_args <- character(0)\n"
    
    bench_reps_str = 'bench_reps <- ' + rep +'\n'
    # now generate the file
    
    with open(tmpsrc, 'w') as f:
        f.write('harness_argc<-1\n')
        f.write(bench_args_str)
        f.write(bench_reps_str)
        with open(src, 'r') as srcf:
            f.write(srcf.read())
        f.write(raw_haress_str)
    
    
    #now start running
    #need change to the directory
    os.chdir(rvm_path)
    rvm_cmd.append(tmpsrc)
    exit_code = os.system(' '.join(rvm_cmd))
    os.remove(tmpsrc)
    sys.exit(exit_code)
    