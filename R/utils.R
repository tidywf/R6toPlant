###
### Class for appending text to an object
###
Catter = R6::R6Class("Catter",
                 public = list(
                     text = "",
                     append = function(...){
                         self$text = paste0(self$text, ...)
                     },
                     reset = function(){
                         self$text = ""
                     }
                 )
                 )

###
### format the arguments of a function.
###
flist <- function(fn, method=TRUE){
    if(method){
        s = paste(names(formals(fn)), collapse=",\\n  ")
    }else{
        s = ""
    }
    return(s)
}



