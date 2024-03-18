
#' R6 Class Representing an R6 class generator with an extra name
#'
#' @description
#' A named generator class
#'
#' @details
#' In packages, R6 Class Generators are assigned to a named object,
#' but can also have a "classname" attribute which doesn't have to
#' be the same as the generator class object. This class exists to
#' store a separate name with the generator class object.
#'
#' @export
#' 
NamedClass = R6::R6Class(
    "NamedClass",
    public = list(
        #' @description
        #' create a new named class
        #' @param GeneratorName Name of the generator, text.
        #' @param Generator An R6 Class Generator function
        #' @return a new NamedClass object
        initialize = function(GeneratorName, Generator){
            if(!inherits(Generator,"R6ClassGenerator")){
                stop("Generator is not an R6 Class Generator")
            }
            if(!is.character(GeneratorName)){
                stop("Generator name is not character")
            }
            
            self$GeneratorName = GeneratorName
            self$Generator = Generator
        },
        #' @field GeneratorName The saved name.
        GeneratorName = NA,
        #' @field Generator The class generator.
        Generator = NA,
        #' @description
        #' Construct the plant UML text for this object.
        #' @return UML text of the object.
        make_plant = function(){
            make_named_plant(self$GeneratorName, self$Generator)
        }
        
    )
    
)

##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title 
##' @param Name 
##' @param Generator 
##' @param private_fields 
##' @param public_fields 
##' @param private_methods 
##' @param public_methods 
##' @param active 
##' @return 
##' @author Barry Rowlingson
make_named_plant = function(Name, Generator,
                            private_fields=TRUE,
                            public_fields=TRUE,
                            private_methods=TRUE,
                            public_methods=TRUE,
                            active=TRUE
                            ){
    c = Catter$new()
    ## main title

    ## sub title if mismatch name
    if(!identical(Generator$classname,Name)){
        if(is.null(Generator$classname)){
            subName = "NULL"
        }else{
            subName = Generator$classname
            ## c$append("\n..",subName,"..\n")
        }
        c$append("class ",Name," <<(6, #A0D0A0) ",subName,">> {\n")
    }else{
        c$append("class ",Name," <<(6, #A0D0A0)>> {\n")
    }
    
    
    ## public fields
    if(public_fields){
        for(pm in names(Generator$public_fields)){
            c$append("+",pm,"\n")
        }
    }

    ## active bindings...
    if(active){
        for(pm in names(Generator$active)){
            c$append("~",pm,"\n")
        }
    }
    
    ## public methods
    if(public_methods){
        for(pm in names(Generator$public_methods)){
            c$append("+",pm,"(",flist(Generator$public_methods[[pm]]),")\n")
        }
    }
    
    ## private fields
    if(private_fields){
        for(pm in names(Generator$private_fields)){
            c$append("-",pm,"\n")
        }
    }
    
    ## private methods
    if(private_methods){
        for(pm in names(Generator$private_methods)){
            c$append("-",pm,"(",flist(Generator$private_methods[[pm]]),")\n")
        }
    }


    
    c$append("\n}\n\n")
    return(c$text)
}

package_classes = function(packagename){
    au = get_named_classlist(packagename)
    aut = lapply(au, function(nc){nc$make_plant()})
    do.call(paste0, aut)
}

get_named_classlist = function(packagename){
    all_c = get_R6_classes(packagename)
    au = lapply(names(all_c), function(n){NamedClass$new(n, all_c[[n]])})
    au
}

make_class_plant <- function(namedr6classlist){
    aut = lapply(namedr6classlist, function(nc){nc$make_plant()})
    do.call(paste0, aut)
}

make_inherit_plant <- function(namedr6classlist){
    inhlist = lapply(namedr6classlist, function(cls){
        g = cls$Generator
        if(!is.null(g$inherit)){
            inh = g$inherit
            if(inherits(inh, "name")){
                iname = as.character(inh)
            }else{
                stopifnot(inherits(inh, "call"))
                iname = paste0(as.character(inh)[c(2,1,3)],collapse="")
            }
            
            paste0(cls$GeneratorName, " <|-- ",iname, "\n")
            
        }
    })
    do.call(paste0, inhlist)
}

                 
make_package_plant <- function(packagename){
    classes = get_named_classlist(packagename)
    
    inherits = make_inherit_plant(classes)
    classtxt = make_class_plant(classes)
    txt = paste0("@startuml\n", classtxt,"\n", inherits,"\n@enduml")
    return(txt)
}

make_package_diagram <- function(packagename, umlout, type="svg", open=FALSE, ...){
    plant = make_package_plant(packagename)
    if(missing(umlout)){
        out = tempfile(fileext=".uml")
    }else{
        out = umlout
    }
        
    cat(plant, file=out)
    cmd = paste0("plantuml -t",type," ",out)
    system(cmd)
    outimg = sub(".uml$",paste0(".",type), out)
    if(open){
        browseURL(outimg)
    }
    
    return(c(uml=out, output=outimg))
}

