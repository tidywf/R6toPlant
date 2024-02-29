class_template <- function(){
"
class <%= r6class$classname%> {
<% if(!is.null(r6class$private_fields)){-%>
<% for(pm in names(r6class$private_fields)){ -%>
-<%=pm%>
<% } -%>
<% } -%>
<% if(!is.null(r6class$public_fields)){ -%>
<% for(pm in names(r6class$public_fields)){ -%>
+<%=pm%>
<% } -%>
<% } -%>
<% if(!is.null(r6class$private_methods)){ -%>
<% for(pm in names(r6class$private_methods)){ -%>
-<%=pm%>(<%=flist(r6class$private_methods[[pm]], method_args)%>)
<% } -%>
<% } -%>
<% if(!is.null(r6class$public_methods)){ -%>
<% for(pm in names(r6class$public_methods)){ -%>
+<%=pm%>(<%=flist(r6class$public_methods[[pm]], method_args)%>)
<% } -%>
<% } -%>
}
"
}

flist <- function(fn, method=TRUE){
    if(method){
        s = paste(names(formals(fn)), collapse=",\\n  ")
    }else{
        s = ""
    }
    return(s)
}


##' Create UML for a class
##'
##' 
##' @title make plant UML for a class
##' @param r6class an R6 class generator
##' @param method_args show method args
##' @return text of the UML
##' @author Barry Rowlingson
##' @export
make_class <- function(r6class, method_args=TRUE){
    ccc = "" # keep check happy
    rm(ccc) # remove
    st = textConnection("ccc", "w")
    brew::brew(text=class_template(), output=st)
    close(st)
    return(paste(ccc, collapse="\n"))
}
##' Create UML for a list of classes
##'
##' 
##' @title Plant UML for a list of classes
##' @param classlist a list of R6 class generators
##' @param method_args should args of methods be shown
##' @return UML text
##' @author Barry Rowlingson
##' @export
make_classes <- function(classlist, method_args=TRUE){
    cls = lapply(classlist, function(cls){
        make_class(cls, method_args=method_args)
    })
    do.call(paste0,cls)
}
