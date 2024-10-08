/**
 *  Each slice origin items should cut into the same slice.
 *
 *  Each slice type defines an item from which it originates. Each sliceable
 *  item defines what item it cuts into. This test checks if the two defnitions
 *  are consistent between the two items.
 */
/datum/unit_test/food_slices_and_origin_items_should_be_consistent
	name = "FOOD: Each slice origin item should cut into the appropriate slice"

/datum/unit_test/food_slices_and_origin_items_should_be_consistent/start_test()
	var/any_failed = FALSE

	for (var/subtype in subtypesof(/obj/item/food/slice))
		var/obj/item/food/slice/slice = subtype

		if(TYPE_IS_ABSTRACT(slice))
			continue

		if(!initial(slice.whole_path))
			log_bad("[slice] does not define a whole_path.")
			any_failed = TRUE
			continue

		if(!ispath(initial(slice.whole_path), /obj/item/food/sliceable))
			log_bad("[slice]/whole_path is not a subtype of sliceable.")
			any_failed = TRUE
			continue

		var/obj/item/food/sliceable/whole = initial(slice.whole_path)

		// note that the slice can be a subtype of the one defined in slice_path
		if(!ispath(slice, initial(whole.slice_path)))
			log_bad("[whole] does not define slice_path as [slice].")
			any_failed = TRUE
			continue

	if(any_failed)
		fail("Some slice types were incorrectly defined.")
	else
		pass("All slice types defined correctly.")

	return 1

/datum/unit_test/recipes_should_produce_result
	name = "FOOD: Each recipe should produce the correct result"

/datum/unit_test/recipes_should_produce_result/start_test()
	var/list/processed_growns_by_tag = list()
	for(var/processed_type in subtypesof(/obj/item/food/processed_grown))
		var/obj/item/food/processed_grown/processed = processed_type
		if(processed::seed)
			continue
		if(processed::processed_grown_tag)
			processed_growns_by_tag[processed::processed_grown_tag] = processed
	var/list/seeds_by_tag = list()
	for(var/seed_name in SSplants.seeds)
		var/datum/seed/seed = SSplants.seeds[seed_name]
		if(!seed.roundstart) // roundstart seeds ONLY
			continue
		if(!seed.grown_tag)
			continue
		seeds_by_tag[seed.grown_tag] = seed_name

	var/failures = list()
	var/obj/container = new // dummy container for holding ingredients
	container.create_reagents(1000)
	for (var/decl/recipe/recipe in decls_repository.get_decls_of_subtype_unassociated(/decl/recipe))
		// assume all recipes are valid because /decl/recipe/validate() handles other things
		for(var/item_path in recipe.items)
			var/count = recipe.items[item_path] || 1
			if(ispath(item_path, /obj/item/stack))
				if(ispath(item_path, /obj/item/stack/material))
					new item_path(container, count, /decl/material/solid/organic/bone) // placeholder
				else
					new item_path(container, count)
			else
				for(var/i in 1 to count)
					if(ispath(item_path, /obj/item/food/grown))
						new item_path(container, null, null, "carrot") // placeholder
					else if(ispath(item_path, /obj/item/food/processed_grown))
						new item_path(container, null, null, "carrot") // placeholder
					else if(ispath(item_path, /obj/item/paper))
						new item_path(container, null, "This is so that fortune cookies work properly. TODO: Make this generic somehow?")
					else
						new item_path(container)
		var/recipe_is_valid = TRUE
		for(var/fruit_key in recipe.fruit)
			var/list/key_components = splittext(fruit_key, " ")
			var/fruit_index = 1
			var/dry = FALSE
			if(key_components[1] == "dried")
				fruit_index = 2
				dry = TRUE
			var/seed = seeds_by_tag[key_components[fruit_index]]
			if(!seed)
				failures += "Unable to find seed with grown_tag [key_components[fruit_index]] from recipe [recipe.type]"
				recipe_is_valid = FALSE
				continue
			if(length(key_components) > fruit_index) // processed grown!
				var/processed_type = processed_growns_by_tag[key_components[fruit_index + 1]]
				if(!processed_type)
					failures += "Unable to find processed grown type with tag [key_components[fruit_index + 1]] from recipe [recipe.type]"
					recipe_is_valid = FALSE
					continue
				for(var/i in 1 to recipe.fruit[fruit_key])
					var/obj/item/food/processed_grown/processed = new processed_type(container, null, null, seed)
					if(dry)
						processed = processed.dry_out(null, processed.get_max_drying_wetness() + 1)
						processed.forceMove(container)
			else
				for(var/i in 1 to recipe.fruit[fruit_key])
					var/obj/item/food/grown/grown = new /obj/item/food/grown(container, null, null, seed)
					if(dry)
						grown = grown.dry_out(null, grown.get_max_drying_wetness() + 1)
						grown.forceMove(container)

		for(var/material_key in recipe.reagents)
			container.add_to_reagents(material_key, recipe.reagents[material_key])

		if(!recipe_is_valid)
			QDEL_LIST(container.contents) // clean up prematurely
			container.reagents.clear_reagents()
			continue

		// continue with validation
		var/container_category = RECIPE_CATEGORY_MICROWAVE
		if(recipe.container_categories)
			container_category = recipe.container_categories[recipe.container_categories.len]
			if(!container_category)
				failures += "Invalid container categories [json_encode(recipe.container_categories)] on [recipe.type]"
				QDEL_LIST(container.contents) // clean up prematurely
				container.reagents.clear_reagents()
				continue
		var/cooking_temperature = T20C
		if(recipe.minimum_temperature > 0)
			cooking_temperature = max(cooking_temperature, recipe.minimum_temperature)
		if(recipe.maximum_temperature < INFINITY)
			cooking_temperature = min(cooking_temperature, recipe.maximum_temperature)
		var/decl/recipe/new_recipe = select_recipe(container_category, container, cooking_temperature)
		if(new_recipe && new_recipe != recipe)
			failures += "Recipe [recipe.type]'s ingredients selected [new_recipe.type] instead!"
		else if(!new_recipe)
			failures += "Recipe [recipe.type]'s ingredients selected NULL instead!"
		else
			recipe.produce_result(container)
			if(ispath(recipe.result, /decl/material) && !container.reagents.has_reagent(recipe.result))
				failures += "Recipe [recipe.type] did not produce the expected output [recipe.result]"
			if(ispath(recipe.result, /atom/movable) && !locate(recipe.result) in container)
				failures += "Recipe [recipe.type] did not produce the expected output [recipe.result]"

		QDEL_LIST(container.contents) // clean up
		container.reagents.clear_reagents()

	if(length(failures))
		fail("Some recipes failed to produce the right result:\n\t-[jointext(failures, "\n\t-")]")
	else
		pass("All recipes produced the right result.")

	return TRUE