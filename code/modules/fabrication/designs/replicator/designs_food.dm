/datum/fabricator_recipe/food
	fabricator_types = list(FABRICATOR_CLASS_FOOD)
	path = /obj/item/chems/food/tofurkey

// Remove matter from plates from the recipe, since we don't print food with plates.
/datum/fabricator_recipe/food/get_resources()
	. = ..()
	var/obj/item/chems/food/food_result = path
	if(!ispath(food_result, /obj/item/chems/food))
		return // why?? why would this not be food??
	var/plate_path = initial(food_result.plate)
	if(ispath(plate_path))
		var/list/plate_matter = atom_info_repository.get_matter_for(plate_path)
		for(var/key in plate_matter)
			resources[key] -= (plate_matter[key] * FABRICATOR_EXTRA_COST_FACTOR)
			if(resources[key] <= 0)
				resources -= key

// Print the resulting food without a plate.
/datum/fabricator_recipe/food/build(turf/location, datum/fabricator_build_order/order)
	// TODO: On dev, we can just spawn it with skip_plate = TRUE instead. Without that we need a workaround.
	. = ..()
	for(var/obj/item/chems/food/food in .)
		if(istype(food.plate))
			QDEL_NULL(food.plate)

/datum/fabricator_recipe/food/soylentviridians
	path = /obj/item/chems/food/soylenviridians

/datum/fabricator_recipe/food/fries
	path = /obj/item/chems/food/fries

/datum/fabricator_recipe/food/soydope
	path = /obj/item/chems/food/soydope

/datum/fabricator_recipe/food/ricepudding
	path = /obj/item/chems/food/ricepudding