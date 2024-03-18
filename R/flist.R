
flist <- function(fn, method=TRUE){
    if(method){
        s = paste(names(formals(fn)), collapse=",\\n  ")
    }else{
        s = ""
    }
    return(s)
}

