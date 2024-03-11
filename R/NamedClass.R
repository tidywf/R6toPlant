NamedClass = R6Class(
    "NamedClass",
    public = list(
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
        GeneratorName = NA,
        Generator = NA,
        make_plant = function(){
            make_named_plant(self$GeneratorName, self$Generator)
        }
        
    )
    
)

make_named_plant = function(Name, Generator){
    out = ""
    rm(out)
    tout = textConnection("out", "w")
    ## main title
    cap("class ",Name, "{", file=tout)

    ## sub title if mismatch name
    if(!identical(Generator$classname,Name)){
        if(is.null(Generator$classname)){
            subName = "<NULL>"
        }else{
            subName = Generator$classname
        }
        cap("...",subName,"...\n", file=tout)                    
    }

    ## private fields
    for(pm in names(Generator$private_fields)){
        cap("-",pm,"\n", file=tout)
    }

    ## public fields
    for(pm in names(Generator$public_fields)){
        cap("+",pm,"\n", file=tout)
    }

    ## private methods
    for(pm in names(Generator$private_methods)){
        cap("-",pm,"(",flist(Generator$private_methods[[pm]]),")\n", file=tout)
    }

    ## public methods
    for(pm in names(Generator$public_methods)){
        cap("+",pm,"(",flist(Generator$private_methods[[pm]]),")\n", file=tout)
    }

    ## active bindings...
    
    
    cap("\n}\n\n", file=tout)
    close(tout)
    out = paste(out, collapse="\n")
    return(out)
}
