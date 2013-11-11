
# warmup() function is optional.
warmup <- function(cmdline_args){
    print("Executing hello_rbenchmark warmup() with input:")
    print(cmdline_args)
    return(cmdline_args)
}

run <- function (input) {
    print("Executing hello_rbenchmark run() with input")
    print(input)
}


if (!exists('harness_argc')) {
    input = commandArgs(TRUE)
    # input = warmup(input) # optional
    run(input)
}