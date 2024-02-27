make_inherit <- function(r6classlist){
    inhlist = lapply(r6classlist, function(cls){
        if(!is.null(cls$inherit)){
            inhs = lapply(cls$inherit, function(inh){
                paste0(cls$classname, " <|-- ",inh, "\n")
            })
            paste0(inhs)
        }
    })
    do.call(paste0, inhlist)
}
