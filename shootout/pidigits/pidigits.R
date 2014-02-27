# ------------------------------------------------------------------
# The Computer Language Shootout
# http://shootout.alioth.debian.org/
#
# Contributed by Leo Osvald, Haichuan Wang
#
# Original Loc: https://github.com/allr/fastr/tree/master/test/r/shootout/pidigits
# Modified to be compatible with rbenchmark interface
# 
# Optimized by Haichuan Wang
# The big number here is simpler, not have sign tag. Can only work on positive numbers
# But it's about  4x faster


setup <- function(args='500') {
    n<-as.integer(args[1])
    if(is.na(n)){ n <- 500 }
    return(n)
}

run <-function(num) {
    
    ##create a big integer, integer cell, each one is up too 9999.
    UNIT<-10000L;
    
    zeropad <- function(s, n) {
        paste(sep="", paste(collapse="", rep('0', max(0L, n - nchar(s)))), s)
    }
    
    #return the sign value
    sign_bigint <- function(v) {
        v_len <- length(v);
        mvalue <- v[v_len];
        if(mvalue >= 0) { return(1L);}
        else { return(-1L);};
    }
        
    bigint <- function(v) { #convert number into bigint
        if(v >= 0L) {v_sign <- 1L; }
        else {v_sign <- -1L;}
        
        v <- v * v_sign; #change to normal
        
        i <- 1;
        value <- 0L;
        repeat {
            value[i] <- v %% UNIT;
            v <- v %/% UNIT; 
            if(v == 0L) {
                break;
            }
            i <- i+1;
        }
        
        
        value_len <- length(value);
        value[value_len] <- v_sign * value[value_len];
        return(value);
    }
    
    bigint_to_str <- function(value) { #convert to string
        value <- rev(value);
        valuestr <- as.character(value);
        if(length(valuestr) > 1) {
            for(i in 2:length(valuestr)) { #fill each one
                valuestr[i] <- paste(collapse="", sep="", rep('0', 4L-nchar(valuestr[i])), valuestr[i]);
            }
        }
        return(paste(collapse="", sep="", valuestr));
    }
    
    bigint_to_int <- function(value) { #convert to integer, may overflow
        value_len <- length(value);
        value_sign <- sign_bigint(value);
        value[value_len] <- value_sign * value[value_len]; #change to mag
        v <- value[value_len]; #last one
        if(length(value) > 1) {
            for(i in (length(value)-1):1){
                v <- v * UNIT + value[i];
            }
        }
        return(v*value_sign);
    }
    
    cmp_mag <- function(x,y) {
        x_len = length(x);
        y_len = length(y);
        #x,y must be >=0
        if(x_len < y_len) return(-1L);
        if(x_len > y_len) return(1L);
        for(i in x_len:1) {
            c <- (x[i] > y[i]) - (x[i] < y[i])
            if (c) {
                return(c)
            }
        }
        return (0L);
    }
    
    cmp_bigint <- function(x, y) {
        #first get the sign
        x_sign <- sign_bigint(x);
        y_sign <- sign_bigint(y);
        if(x_sign != y_sign) {
            return((x_sign > y_sign) - (x_sign < y_sign));
        }
        
        #the same sign, cmp mag, and need consider the x/y switch
        x_len = length(x);
        y_len = length(y);
        if(x_sign == -1L) { #do switch
            tmp <-x; x<-y; y<-tmp;
            tmp_len<-x_len; x_len<-y_len; y_len<-tmp_len;
            x[x_len] <- x_sign * x[x_len];
            y[y_len] <- y_sign * y[y_len];        
        } 
    
        return(cmp_mag(x,y));
    
    }
    
    add_mag<- function(x,y) {
        # if x is shorter, swap the two vectors, now x is always largeer
        if (length(x) < length(y)) {
            tmp <- x; x <- y; y <- tmp
        }
        x_len <- length(x)
        y_len <- length(y)
        
        carry <- 0L;
        sum <- x; #pre-allocate space
        for(i in 1:y_len){
            cur_sum = x[i] + y[i] + carry;
            sum[i] = cur_sum %% UNIT;
            carry = cur_sum %/% UNIT;
        }
        
        #now the rest
        if(x_len > y_len) {
            for(i in (y_len+1):x_len) {
                cur_sum = carry + x[i];
                sum[i] = cur_sum %% UNIT;
                carry = cur_sum %/% UNIT;
            }
        }
        if(carry > 0L) {
            sum[x_len+1] = carry;
        }
        return(sum);
    }
    sign_prod <- function(x, y) {(x == y) - (x != y)}
    
    add_bigint <- function(x, y) {
        #first get the sign
        x_sign <- sign_bigint(x);
        y_sign <- sign_bigint(y);
        x_len = length(x);
        y_len = length(y);
        #get mag
        x[x_len] <- x_sign * x[x_len];
        y[y_len] <- y_sign * y[y_len];    
        
        
        if(x_sign == y_sign) {
            value <- add_mag(x,y); #get mag
            value_len <- length(value);
            value[value_len] <- x_sign * value[value_len];
            return(value);
        }
        
        mag_cmp <- cmp_mag(x,y); 
        if(mag_cmp == 0L) {
            return (0L);
        }
        if(mag_cmp > 0L) {
            value <- sub_mag(x,y);
        } else {
            value <- sub_mag(y,x);
        }
        #now compose the result
        new_sign <-sign_prod(mag_cmp, x_sign);
        value_len <- length(value);
        value[value_len] <- new_sign * value[value_len];
        return(value);
    }
    
    compact_bigint<- function(v) {
        #removing leading zero
        v_len = length(v);
        if(v_len == 1L) { return(v);}
        for(i in v_len:2) {
            if(v[i] == 0L) {
                v_len <- v_len - 1L;
            } else {
                break;
            }
        }
        return(v[1:v_len]);
    }
    
    sub_mag <- function(x, y) {
    #    cmp_res <- cmp_bigint(x,y);
    #    if(cmp_res == 0L) { return(0L)};
    #    if(cmp_res == -1L) { print("ERROR, not suppor minus numbers!!!"); return(0L)};
        
        x_len <- length(x);
        y_len <- length(y);
        #y is less, starting from the lowest
        borrow <- 0L;
        diff <- x; #pre-allocate the space
        for(i in 1 : y_len) {
            cur_diff <- x[i] - y[i] - borrow;
            if(cur_diff < 0L) {
                diff[i] = UNIT + cur_diff;
                borrow <- 1L;
            } else {
                diff[i] = cur_diff;
                borrow <- 0L;
            }
        }
        #now the rest
        if(x_len > y_len) {
            for(i in (y_len+1):x_len) {
                cur_diff = x[i] - borrow;
                if(cur_diff < 0L) {
                    diff[i] = UNIT + cur_diff;
                    borrow <- 1L;
                } else {
                    diff[i] = cur_diff;
                    borrow <- 0L;
                }
            }
        }
        #finally clean the larger 0L's 
       compact_bigint(diff);
    }
    
    sub_bigint<- function(x,y) {
        x_sign = sign_bigint(x);
        y_sign = sign_bigint(y);
        #get the mag
        
        x_len = length(x);
        y_len = length(y);
        #get mag
        x[x_len] <- x_sign * x[x_len];
        y[y_len] <- y_sign * y[y_len];    
        
        if (x_sign != y_sign) {
            value <- add_mag(x, y);
            value_len <- length(value);
            value[value_len] <- x_sign * value[value_len];
            return(value);
        }
        
        mag_cmp <- cmp_mag(x, y)
        if (mag_cmp == 0L) {
            return(0L);
        }
    
        if (mag_cmp > 0L){
            value <- sub_mag(x, y);
        }
        else{
            value <- sub_mag(y, x);
        }
        
        new_sign <-sign_prod(mag_cmp, x_sign);
        value_len <- length(value);
        value[value_len] <- new_sign * value[value_len];
        return(value);
    }
    
    
    mul_bigint <- function(x,y) {
        x_len <- length(x);
        y_len <- length(y);
        x_sign = sign_bigint(x);
        y_sign = sign_bigint(y);
        #get mag
        x[x_len] <- x_sign * x[x_len];
        y[y_len] <- y_sign * y[y_len];    
        
        res<-rep(0L, x_len+y_len); #allocate memory
        
    
        for(i in 1:x_len) {
            #each time get one from x, and add the right point in res
            carry<- 0L;
            k<-i;
            for(j in 1:y_len) {
                cur_res <- y[j]*x[i]+res[k]+carry;
                res[k] <- cur_res %% UNIT;
                carry <- cur_res %/% UNIT;
                k<-k+1L;
            }
            #the remaining carry
            while(carry > 0L) {
                cur_res <- res[k] + carry;
                res[k] <- cur_res %% UNIT;
                carry <- cur_res %/% UNIT;
                k<-k+1L;
            }
        }
        
        value <-compact_bigint(res);
        value_len <- length(value);
        value[value_len]<- x_sign * y_sign * value[value_len];
        
        return(value);
    }
    
    UNIT_digits = as.integer(log10(UNIT))
    log10_bigint <- function(m) { UNIT_digits * (length(m) - 1L) + as.integer(log10(m[length(m)])) }
    
    pow10_bigint <- function(n) {c(rep.int(0L, n %/% UNIT_digits), as.integer(10^(n %% UNIT_digits))) }
    
    div2_bigint <- function(x) {
        x_len <- length(x)
        if (x_len == 1L){
            return(x %/% 2L)
        }
        res <- rep(0L, x_len);
        rem <- 0L;
        for(i in x_len:1L) {
            v <- rem * UNIT + x[i]
            res[i] <- v %/% 2L;
            rem <- v %% 2L;
        }
        return(compact_bigint(res))
    }
    
    
    div_bigint <- function(x,y) {
        if(length(y) == 1L && y == 1L) { return(x);}
        
        x_len <- length(x);
        y_len <- length(y);
        x_sign = sign_bigint(x);
        y_sign = sign_bigint(y);
        #get mag
        x[x_len] <- x_sign * x[x_len];
        y[y_len] <- y_sign * y[y_len];    
    
        mag_cmp <- cmp_mag(x,y);
        if(mag_cmp == 0L) { return(1L*(x_sign == y_sign));}
        if(mag_cmp < 0L) { return (0L);}
        
        
        
        x_log10 <- log10_bigint(x);
        y_log10 <- log10_bigint(y);
        lo_log10 <- x_log10 - y_log10 - (x_log10 != y_log10);
        hi_log10 <- x_log10 - y_log10 + 1L;
        lo <-pow10_bigint(lo_log10);
        
        #try pruning hi > 10 or lo <10
        # try pruning hi > 10 or lo <= 10
        if (lo_log10 == 0L && hi_log10 > 1L) {
            lo10 <- mul_bigint(lo, 10L);
            if (cmp_bigint(mul_bigint(lo10, y), x) == 1L) {
                hi <- lo10;
            }
            else {
                lo <- lo10;
                hi <- pow10_bigint(hi_log10);
            }
        } else {
            hi <- pow10_bigint(hi_log10);
        }
        
        while (cmp_bigint(lo, hi) == -1L) {
            mid <- div2_bigint(add_bigint(add_bigint(lo, hi), 1L));
            cmp_value <- cmp_bigint(mul_bigint(mid, y), x);
            if (cmp_value == -1L || cmp_value == 0L){
                lo <- mid;
            }
            else{
                hi <- sub_bigint(mid, 1L);
            }
        }
        
        
        value <-lo;
        value_len <- length(value);
        value[value_len]<- x_sign * y_sign * value[value_len];
        
        return(value);
    
    }
    
    
    
    
    i <- k <- ns <- 0L;
    k1 <- 1L;
    
    n <- d <- bigint(1L); #bigint1L
    a <- t <- u <- bigint(0L);
    
    while(TRUE) {
        k <- k + 1L;
        t <- mul_bigint(n, 2L);
        #cat("t=", t, "\n");
        n <- mul_bigint(n, bigint(k));
        #cat("n=", n, "\n");
        a <- add_bigint(a, t);
        #cat("a=", a, "\n");
    
        k1 <- k1 + 2L;
        k1_big <-bigint(k1);
        #cat("k1_big=", k1_big, "\n");
        a <- mul_bigint(a, k1_big);
        #cat("a=", a, "\n");
        d <- mul_bigint(d, k1_big);
        #cat("d=", d, "\n");
        cmp_an <- cmp_bigint(a, n);
        #cat("cmp_an=", cmp_an, "\n");
        if(cmp_an == 1L || cmp_an == 0L) {
            n3a <- add_bigint(mul_bigint(n, 3L), a);
            #cat("L0 n3a=", n3a, "\n");
            t <- div_bigint(n3a, d);
            #cat("L0 t=", t, "\n");
            td <- mul_bigint(t, d);
            #cat("L1 td=", td, "\n");
            u <- add_bigint(sub_bigint(n3a, td),  n);
            if(cmp_bigint(d, u) == 1L) {
                ns <- ns * 10L + bigint_to_int(t);
                i <- i + 1L;
                if (i %% 5L == 0L) {
                    cat(zeropad(as.character(ns), 5))
                    if (i %% 2L == 0L)
                        cat(sep="", "\t:", i, "\n")
                    ns = 0L
                }
                if(i >= num) { break; }
                #cat("L2 td=", td, "\n");
                a <- sub_bigint(a, td);
                #cat("L3 a=", a, "\n");
                a <- mul_bigint(a, 10L);
                #cat("L4 a=", a, "\n");
                n <- mul_bigint(n, 10L);
            }
        }
        #cat("end a=", a, "\n");
    }
}

if (!exists('harness_argc')) {
    n <- setup(commandArgs(TRUE))
    run(n)
}
