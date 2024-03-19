
### Return the UML for a name and a generator class
### Internal, called via the make_plant method of NamedClass
###
make_named_plant <- function(Name, Generator,
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

package_classes <- function(packagename){
    au = get_named_classlist(packagename)
    aut = lapply(au, function(nc){nc$make_plant()})
    do.call(paste0, aut)
}

get_named_classlist <- function(packagename){
    all_c = get_R6_classes(packagename)
    au = lapply(names(all_c), function(n){NamedClass$new(n, all_c[[n]])})
    au
}

### Return the PlantUML for a list of named class objects
make_class_plant <- function(namedr6classlist){
    aut = lapply(namedr6classlist, function(nc){nc$make_plant()})
    do.call(paste0, aut)
}

### Return the PlantUML for inheritances between list of named class objects
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

##' Get the PlantUML for a package
##'
##' Given the name of a package, return the UML for R6 Classes in it.
##' @title Make PlantUML for Package
##' @param packagename Name of an installed package
##' @param header Extra PlantUML for the header
##' @return Text of the UML for the classes.
##' @author Barry Rowlingson
##' @export
make_package_plant <- function(packagename, header=""){

    classes = get_named_classlist(packagename)
    
    inherits = make_inherit_plant(classes)
    classtxt = make_class_plant(classes)
    txt = paste0("@startuml\n", header,"\n", classtxt,"\n", inherits,"\n@enduml\n")
    return(txt)
}

##' Make the UML and render it to an image file for R6 classes in
##' a package.
##' 
##' Given a package name, get the R6 classes it defines and make a diagram
##' @title Make Package R6 Class Diagram
##' @param packagename Name of a package, character.
##' @param umlout Where to create PlantUML output file. If missing, use a
##'               temporary file
##' @param type Image file type, eg svg or png. Passed to "plantuml" command.
##' @param header Extra PlantUML for the header
##' @param open If TRUE, use "browseURL" to open the image file
##' @param ... Other parameters
##' @return A named vector of UML and image file names
##' @author Barry Rowlingson
##' @export
make_package_diagram <- function(packagename, umlout, type="svg", header="", open=FALSE, ...){
    plant = make_package_plant(packagename, header=header)
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

