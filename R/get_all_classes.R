get_R6_classes <- function(namespace){
    r6classlist <- sort(
        names(Filter(
            R6::is.R6Class, sapply(getNamespaceExports(namespace), get)
        )
        )
    )

    r6classes <- sapply(r6classlist, get)

    return(r6classes)
}

make_package_diagram <- function(namespace, output=stdout()){
    clss = get_R6_classes(namespace)
    make_plant(clss, output)
}
