/datum/fabricator_recipe/imprinter
	fabricator_types = list(FABRICATOR_CLASS_IMPRINTER)
	required_technology = TRUE

/datum/fabricator_recipe/imprinter/get_resources()
	. = ..()
	LAZYSET(resources, /decl/material/acid, 20)
