cap = function(..., file){
    cat(..., file=file, sep="", append=TRUE)
}

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

