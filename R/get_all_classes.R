get_R6_classes <- function(namespace, internal=TRUE){
    if(internal){
        names = ls(getNamespace(namespace), all.names=TRUE)
    }else{
        names = getNamespaceExports(namespace)
    }
    
    r6classlist <- sort(
        names(Filter(
            R6::is.R6Class, sapply(names, function(n){getFromNamespace(n, namespace)})
        )
        )
    )

    r6classes <- sapply(r6classlist, function(n){getFromNamespace(n, namespace)})

    return(r6classes)
}

make_package_diagram <- function(namespace, output=stdout(), method_args=TRUE, internal=TRUE){
    clss = get_R6_classes(namespace, internal=internal)
    make_plant(clss, output, method_args=method_args)
}
