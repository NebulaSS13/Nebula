/datum/fabricator_build_order
	var/datum/fabricator_recipe/target_recipe
	var/multiplier = 1
	var/remaining_time = 0
	var/list/earmarked_materials = list()
	var/list/data //Fabricator specific data

/datum/fabricator_build_order/Destroy()
	target_recipe = null
	. = ..()
