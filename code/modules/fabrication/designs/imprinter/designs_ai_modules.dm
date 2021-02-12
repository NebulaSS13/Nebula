/datum/fabricator_recipe/imprinter/ai
	category = "Secondary AI Modules"
	path = /obj/item/ai_law_module/variable

/datum/fabricator_recipe/imprinter/ai/get_product_name()
	. = "AI module design ([..()])"

/datum/fabricator_recipe/imprinter/ai/onehuman
	path = /obj/item/ai_law_module/variable/onehuman

/datum/fabricator_recipe/imprinter/ai/protectstation
	path = /obj/item/ai_law_module/single

/datum/fabricator_recipe/imprinter/ai/notele
	path = /obj/item/ai_law_module/single/teleporter_offline

/datum/fabricator_recipe/imprinter/ai/quarantine
	path = /obj/item/ai_law_module/single/quarantine

/datum/fabricator_recipe/imprinter/ai/oxygen
	path = /obj/item/ai_law_module/single/oxygen

/datum/fabricator_recipe/imprinter/ai/freeform
	path = /obj/item/ai_law_module/freeform/auxillary

/datum/fabricator_recipe/imprinter/ai/reset
	path = /obj/item/ai_law_module/reset

/datum/fabricator_recipe/imprinter/ai/purge
	path = /obj/item/ai_law_module/purge

/datum/fabricator_recipe/imprinter/ai_core
	category = "Core AI Modules"
	path = /obj/item/ai_law_module/freeform

/datum/fabricator_recipe/imprinter/ai_core/get_product_name()
	. = "AI core module design ([..()])"

/datum/fabricator_recipe/imprinter/ai_core/asimov
	path = /obj/item/ai_law_module/lawset

/datum/fabricator_recipe/imprinter/ai_core/paladin
	path = /obj/item/ai_law_module/lawset/paladin

/datum/fabricator_recipe/imprinter/ai_core/tyrant
	path = /obj/item/ai_law_module/lawset/tyrant
