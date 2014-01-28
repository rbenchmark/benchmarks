
# setup() function is optional.
setup <- function(cmdline_args=character(0)){
    print("Executing hello_rbenchmark setup() with input:")
    print(cmdline_args)
    return(cmdline_args)
}

run <- function(input='No input') {
    print("Executing hello_rbenchmark run() with input")
    print(input)
}


if (!exists('harness_argc')) {
    input = commandArgs(TRUE)
    input = setup(input) # optional
    run(input)
}