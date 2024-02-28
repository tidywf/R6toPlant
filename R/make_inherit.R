make_inherit <- function(r6classlist){
    inhlist = lapply(r6classlist, function(cls){
        if(!is.null(cls$inherit)){
            inh = cls$inherit
            if(inherits(inh, "name")){
                iname = as.character(inh)
            }else{
                stopifnot(inherits(inh, "call"))
                iname = paste0(as.character(inh)[c(2,1,3)],collapse="")
            }
            
            paste0(cls$classname, " <|-- ",iname, "\n")
            
        }
    })
    do.call(paste0, inhlist)
}
