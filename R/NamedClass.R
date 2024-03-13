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

et = function(Name, Generator){

}

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
            c$append("class ",Name, "{\n")
            subName = "<NULL>"
        }else{
            subName = Generator$classname
            c$append("class ",Name," <<",subName,">> {\n")
            ## c$append("\n..",subName,"..\n")
        }

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
