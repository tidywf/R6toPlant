expos = function(ns){

    ## get all exported object names
    nse = getNamespaceExports(ns)
    ## get all names in the namespace
    lsn = ls(getNamespace(ns), all.names = TRUE)

    ## re-exports are the exports minus the full listing
    reexps = setdiff(nse, lsn)

    ## actual exports are then the exports minus the re-exports
    myexp = setdiff(nse, reexps)

    ## unexported objects are the full listing minus the exports
    notexpo = setdiff(lsn, nse)

    list(exports = myexp, not_exports = notexpo, re_exports = reexps)
}
    
allR6ClassGens <- function(ns){

    bypart = expos(ns)
    
    ## make a checker for that namespace
    r6check = isR6ClassGen(ns)

    ## exported R6 objects
    expo = Filter(r6check, bypart$exports)

    ## unexported R6 objects
    notexpo = Filter(r6check, bypart$not_exports)

    ## re-exported R6 objects
    rexpo = Filter(r6check, bypart$re_exports)

    list(exports = expo, not_exports = notexpo, re_exports = rexpo)
}

isR6ClassGen <- function(ns){
    f = function(name){
#        is.R6Class(getFromNamespace(name, ns))
        R6::is.R6Class(get(name, asNamespace(ns)))
    }
    f    
}
