/datum/fabricator_recipe/imprinter
	fabricator_types = list(FABRICATOR_CLASS_IMPRINTER)
	required_technology = TRUE

/datum/fabricator_recipe/imprinter/get_resources()
	. = ..()
	LAZYSET(resources, MAT_ACID_SULPHURIC, 20)
