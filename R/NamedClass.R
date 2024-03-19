
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

