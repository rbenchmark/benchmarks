# The Computer Language Benchmarks Game

# http://shootout.alioth.debian.org/

#

# contributed by Olof Kraigher

# modified by Tupteq
# 2to3
# translated to R by Haichuan Wang. 
#
# Require R version 3.0 or higher, which has bit operation
# Note: use a 2 elements vector xy to express x,y
# some vector optimization

setup <- function(args='100') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 100 }
    return(n)
}

run <- function(n = 100) {

    # R modification to bit opertor in meteor-contest
    # each element will only store 25 bit
    # the pair[1] store the low bits, and pair[2] store the high bits
    
    # the following function will work on a pair 2x1 vector
    
    # return a 2x1 vector with only one bit set at location 
    genBitPair <- function (num) {
        retval <- c(0,0);
        i <- num %/% 25 + 1;
        s <- num %% 25;
        retval[i] <- bitwShiftL(1, s);
        return(retval);
    }
    
    #pre-compute bit pair
    bitPair <- matrix(0, 50, 2);
    for(bitLoc in 1:50){
        bitPair[bitLoc,] <- genBitPair(bitLoc - 1);
    }
    
    
    # check is a bit is zero at bitLoc
    isBitZero <- function(pair, bitLoc) {
        out <- bitwAnd(pair, bitPair[bitLoc + 1,]);
        return(out[1] == 0 && out[2] == 0);
    }
    
    width <- 5
    height <- 10
    
    rotate <- list(E='NE', NE='NW', NW='W', W='SW', SW='SE', SE='E');
    flip <- list(E="W", NE="NW", NW="NE", W="E", SW="SE", SE="SW");
    
    move <- list(E=function(xy)c(xy[1]+1, xy[2]),
                W=function(xy)c(xy[1]-1, xy[2]),
                NE=function(xy)c(xy[1] + (xy[2]%%2), xy[2]-1),
                NW=function(xy)c(xy[1] + (xy[2]%%2) - 1, xy[2]-1),
                SE=function(xy)c(xy[1] + (xy[2]%%2), xy[2]+1),
                SW=function(xy)c(xy[1] + (xy[2]%%2) - 1, xy[2]+1));
    
    solutions <- c();
    masks <- rep(list(c(0,0)), 10); # each element is 2x1 vector
    
    valid <- function(xy)(0 <= xy[1] && xy[1] < width && 0 <= xy[2] && xy[2] < height);
    
    # input mask is a 2x1 vector
    zerocount = function(mask){
        return(50 - sum(bitwAnd(bitPair, mask) > 0));
    }
    
    # input board is a 2x1 vector
    # return 2x1 vector xy
    findFreeCell <- function(board){
        for(y in 0:(height-1)){
            for(x in 0:(width-1)){
                if( isBitZero(board, (x + width*y) ) ){
                    return(c(x, y));
                }
            }
        }
    }
    
    #board & xxx_todo_changeme: 2x1 vector
    floodFill <- function(board, xxx_todo_changeme){
        xy <- xxx_todo_changeme
        if (valid(xy) && isBitZero(board, (xy[1] + width*xy[2])) ){
            
            board <- bitwOr(board, bitPair[1 + xy[1] + width*xy[2],]);
    
            for (f in move){
                board <- bitwOr(board, floodFill(board, f(xy)));
            }
        }
        return(board);
    }
    
    
    noIslands <- function(mask){
        zeroes <- zerocount(mask);
    
        if(zeroes < 5){
            return(FASLE);
        }
    
        while (mask[1] != 0x1FFFFFF || mask[2] != 0x1FFFFFF){
            mask <- floodFill(mask, findFreeCell(mask));
            new_zeroes <- zerocount(mask);
    
            if((zeroes - new_zeroes) < 5){
                return(FALSE);
            }
    
            zeroes <- new_zeroes;
        }
        return(TRUE);
    }
    
    getBitmask <- function(xy, piece){
        mask <- bitPair[1 + xy[1] + width*xy[2],];
    
        for(cell in piece){
            xy = move[[cell]](xy);
            if(valid(xy)){
                mask <- bitwOr(mask, bitPair[1 + xy[1] + width*xy[2],]);
            }
            else{
                return(list(FALSE, c(0,0)));
            }
        }
        return(list(TRUE, mask));
    }
    
    allBitmasks <- function(piece, color){
        bitmasks <- list();
        for (orientations in 0:1){
            for (rotations in 0: (5 - 3*(color == 4))) {
                for (y in 0:(height-1)) {
                    for (x in 0:(width-1)) {
                        isValidMask <- getBitmask(c(x, y), piece);
                        isValid <- isValidMask[[1]];
                        mask <- isValidMask[[2]];
                        if(isValid && noIslands(mask)){
                            bitmasks <- append(bitmasks, list(mask));
                        }
                    }
                }
                newP <- list();
                for(cell in piece){
                    newP <- append(newP, rotate[[cell]]);
                }
                piece <- newP;
            }
            newP <- list();
            for(cell in piece){
                newP <- append(newP, flip[[cell]]);
            }
            piece <- newP;
        }
        return(bitmasks);
    }
    
    #utility function masks sort, simple popup sorting
    #compare 2x1 vector function
    maskLarger <- function(mask1, mask2){
        #33554432 = 2^25
        v1 <- mask1[2] * 33554432 + mask1[1];
        v2 <- mask2[2] * 33554432 + mask2[1];
        return(v1 > v2);
    }
    masksSort <- function(listMask){
        #simple pop up 
        
        len <- length(listMask);
        for(i in 1 : (len -1 )){
            for( j in 1 : (len - i) ){
                if(maskLarger(listMask[[j]], listMask[[j+1]])) {
                    #switch
                    listMask[j:(j+1)] <- listMask[(j+1):j];
                }
            }
        }
        return(listMask);
    }
    
    
    
    generateBitmasks <- function(){
    
        pieces = list(list("E", "E", "E", "SE"),
                      list("SE", "SW", "W", "SW"),
                      list("W", "W", "SW", "SE"),
                      list("E",  "E", "SW", "SE"),
                      list("NW", "W", "NW", "SE", "SW"),
                      list("E",  "E", "NE", "W"),
                      list("NW", "NE", "NE", "W"),
                      list("NE", "SE", "E", "NE"),
                      list("SE", "SE", "E", "SE"), 
                      list("E", "NW", "NW", "NW")
                 );
    
         #global, two level lists, and the final element is also a list
        colorMask <- rep(list(list()), times=10);
        masksAtCell <<- rep(list(colorMask), times= width*height); 
                 
        color <- 0;
        for(piece in pieces){
            masks <- allBitmasks(piece, color);
            masks <- masksSort(masks);
            cellCounter <- width*height - 1;
            cellMask = bitPair[1 + cellCounter,];
            j <- length(masks) - 1;
    
            while (j >= 0){
                maskCellAnd <- bitwAnd(masks[[j+1]], cellMask);
                if (maskCellAnd[1] == cellMask[1]
                    && maskCellAnd[2] == cellMask[2]){
                    masksAtCell[[cellCounter+1]][[color+1]] <<- append(masksAtCell[[cellCounter+1]][[color+1]], masks[j+1]);
                    j <- j-1;
                }
                else{
                    cellCounter <- cellCounter - 1;
                    cellMask = bitPair[1 + cellCounter,];
                }
            }
            color <- color+ 1;
        }
    }
    
    solveCell <- function(cell, board){    
        
        if (to_go <= 0){
            # Got enough solutions
        }
        else if (board[1] == 0x1FFFFFF && board[2] == 0x1FFFFFF){
            # Solved
            addSolutions();
        }
        else if (sum(bitwAnd(board, bitPair[1 + cell,])) != 0){
            # Cell full
            solveCell(cell-1, board);
        }
        else if (cell < 0){
            # Out of board
        }
        else{
            for (color in 0:9){
                if (masks[[color+1]][1] == 0 && masks[[color+1]][2] == 0){
                    for (mask in masksAtCell[[cell+1]][[color+1]]){
                        if (sum(bitwAnd(mask, board)) == 0){
                            masks[[color+1]] <<- mask;
                            solveCell(cell-1, bitwOr(board, mask));
                            masks[[color+1]] <<- c(0,0);
                        }
                    }
                }
            }
        }
    }
    
    
    addSolutions <- function(){
        s <- c(); # as char vector
    
        for(y in 0:(height-1)){
            for( x in 0:(width-1)) {
                mask <- bitPair[1 + x + y *width,];
                for(color in 0:9){
                    if(sum(bitwAnd(masks[[color+1]], mask)) != 0){
                        s <- append(s, color);
                        break;
                    }
                    else if (color == 9){
                        s <- append(s, '.');
                    }
                }
            }
        }
        
        # Inverse
        ns <- c(); # as char vector
        slen <- length(s); # used to correct the index of s, which might be 0(-1 in python)
        for (y in 0:(height-1)){
            for (x in 0:(width-1)){
                ind <- width - x - 1 + (width - y - 1) * width;
                ns <- append(ns, s[ind %% slen + 1]);
            }
        }
        # Finally append
        solutions <<- append(solutions, paste(s, collapse=' '));
        solutions <<- append(solutions, paste(ns, collapse=' '));
        to_go <<- to_go - 2;
    }
    
    printSolution <- function(solution){
        for (y in 0:(height -1)) {
            headStart <-  if((y %% 2) == 0) {''} else { ' ' };
            line_start <- y * width * 2 + 1;
            line_end <- line_start + 9;
            one_line <- substr(solution, line_start, line_end);
            print(paste(headStart, one_line));
        }
        print("");
    }
    
    solve <-function(n){
        #global to_go
        to_go <<- n;
        generateBitmasks();
        solveCell(width*height - 1, c(0,0));
    }
    
    ######################### Main Function 
    # default workload

    solve(n);
    print("end");
    print(paste(length(solutions), " solutions found"));
    
    printSolution(min(solutions));
    printSolution(max(solutions));
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}

