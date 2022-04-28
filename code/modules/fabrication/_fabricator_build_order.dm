/datum/fabricator_build_order
	var/datum/fabricator_recipe/target_recipe
	var/multiplier = 1
	var/remaining_time = 0
	var/list/earmarked_materials = list()
	var/list/data //Fabricator specific data

/datum/fabricator_build_order/New(var/datum/fabricator_recipe/_target_recipe, var/_multiplier = 1, var/list/_data = null)
	..()
	target_recipe = _target_recipe
	multiplier = _multiplier
	data = _data

/datum/fabricator_build_order/Destroy()
	target_recipe = null
	. = ..()

/datum/fabricator_build_order/proc/set_data(var/name, var/value)
	if(!name || !value)
		return
	LAZYSET(data, name, value)

//Returns the data entry for "name" or whatever is in "default" if there's nothing found
//Helps not having to deal with writing extra conditionals
/datum/fabricator_build_order/proc/get_data(var/name, var/default = null)
	if(!name)
		return default
	var/value = LAZYACCESS(data, name)
	return value ? value : default
