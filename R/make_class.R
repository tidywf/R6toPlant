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
-<%=pm%>(<%=flist(r6class$private_methods[[pm]])%>)
<% } -%>
<% } -%>
<% if(!is.null(r6class$public_methods)){ -%>
<% for(pm in names(r6class$public_methods)){ -%>
+<%=pm%>(<%=flist(r6class$public_methods[[pm]])%>)
<% } -%>
<% } -%>
}
"
}

flist <- function(fn){
    paste(names(formals(fn)), collapse=",\\n  ")
}


##' Create UML for a class
##'
##' 
##' @title make plant UML for a class
##' @param r6class an R6 class generator
##' @return text of the UML
##' @author Barry Rowlingson
##' @export
make_class <- function(r6class){
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
##' @return UML text
##' @author Barry Rowlingson
##' @export
make_classes <- function(classlist){
    cls = lapply(classlist, function(cls){
        make_class(cls)
    })
    do.call(paste0,cls)
}
