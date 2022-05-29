/datum/fabricator_recipe
	var/name
	var/path
	var/hidden
	var/category = "General"
	var/list/resources
	var/list/fabricator_types = list(
		FABRICATOR_CLASS_GENERAL
	)
	var/build_time = 5 SECONDS
	var/max_amount = 1 // How many instances can be queued at once
	var/list/required_technology
	var/list/species_locked

// Populate name and resources from the product type.
/datum/fabricator_recipe/proc/get_product_name()
	. = atom_info_repository.get_name_for(path, amount = 1)

/datum/fabricator_recipe/New()
	..()
	if(!path)
		return
	if(!name)
		name = get_product_name()
	if(required_technology == TRUE)
		if(ispath(path, /obj/item))
			var/list/res = build(null, new/datum/fabricator_build_order(src, 1))
			if(length(res))
				var/obj/item/O = res[1]
				var/tech = O.get_origin_tech()
				if(tech)
					required_technology = cached_json_decode(tech)
				QDEL_NULL_LIST(res)
		if(!islist(required_technology))
			required_technology = list()
	if(!resources)
		get_resources()
	if(ispath(path, /obj/item/stack))
		var/obj/item/stack/stack = path
		max_amount = max(1, initial(stack.max_amount))

/datum/fabricator_recipe/proc/check_research_requirements(var/list/known_tech)
	var/list/check_tech = required_technology.Copy()
	for(var/tech in check_tech)
		if(known_tech[tech] >= check_tech[tech])
			check_tech -= tech
	return !length(check_tech)

/datum/fabricator_recipe/proc/get_resources()
	resources = list()
	var/list/building_cost = atom_info_repository.get_matter_for(path)
	for(var/mat in building_cost)
		resources[mat] = building_cost[mat] * FABRICATOR_EXTRA_COST_FACTOR

/obj/building_cost()
	. = ..()
	if(length(matter))
		for(var/material in matter)
			var/decl/material/M = GET_DECL(material)
			if(istype(M))
				.[M.type] = matter[material]
	if(reagents && length(reagents.reagent_volumes))
		for(var/R in reagents.reagent_volumes)
			.[R] = REAGENT_VOLUME(reagents, R)

/datum/fabricator_recipe/proc/build(var/turf/location, var/datum/fabricator_build_order/order)
	. = list()
	if(ispath(path, /obj/item/stack))
		. += new path(location, order.multiplier)
	else
		for(var/i = 1, i <= order.multiplier, i++)
			. += new path(location)