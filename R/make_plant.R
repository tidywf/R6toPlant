##' Make PlantUML diagram from a list of R6 classes
##'
##' 
##' @title Create UML diagram from R6 object generators
##' @param classes list of R6 class generators
##' @param output filename or connection for output
##' @param method_args should method args be shown?
##' @return none
##' @author Barry Rowlingson
##' @export
make_plant <- function(classes, output=stdout(), method_args=TRUE){
    brew::brew(text="@startuml\n<%= make_classes(classes, method_args=method_args)%><%=make_inherit(classes)%>@enduml", output=output)
}

    
