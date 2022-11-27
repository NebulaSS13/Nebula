/datum/fabricator_recipe/imprinter
	fabricator_types = list(FABRICATOR_CLASS_IMPRINTER)
	required_technology = TRUE

/datum/fabricator_recipe/imprinter/get_resources()
	. = ..()
	// 1 sheet of matter is 20u of reagents, which is converted during fabricator input
	LAZYSET(resources, /decl/material/liquid/acid, SHEET_MATERIAL_AMOUNT)
