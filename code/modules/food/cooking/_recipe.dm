var/global/list/_cooking_recipe_cache = list()
/proc/select_recipe(category, atom/container, cooking_temperature)

	if(!category)
		return

	if(!global._cooking_recipe_cache[category])
		var/list/recipes = list()
		var/list/all_recipes = decls_repository.get_decls_of_subtype(/decl/recipe)
		for(var/rtype in all_recipes)
			var/decl/recipe/recipe = all_recipes[rtype]
			if(isnull(recipe.container_categories) || (category in recipe.container_categories))
				recipes += recipe
		global._cooking_recipe_cache[category] = recipes

	var/list/available_recipes = global._cooking_recipe_cache[category]
	if(!length(available_recipes))
		return

	var/highest_count = 0
	for(var/decl/recipe/recipe as anything in available_recipes)
		if(recipe.can_cook_in(container, cooking_temperature) && (!. || recipe.complexity >= highest_count))
			highest_count = recipe.complexity
			. = recipe

/* * * * * * * * * * * * * * * * * * * * * * * * * *
 * /datum/recipe by rastaf0            13 apr 2011 *
 * /decl/recipe by Neb                 21 may 2021 *
 *                                                 *
 * Happy tenth birthday you pile of spaghetti!     *
 * * * * * * * * * * * * * * * * * * * * * * * * * */

/decl/recipe

	abstract_type = /decl/recipe

	var/display_name              // Descriptive name of the recipe, should be unique to avoid codex pages being unsearchable. If not set, codex uses initial name of product.
	var/list/reagents             // example: = list(/decl/material/liquid/drink/juice/berry = 5) // do not list same reagent twice
	var/list/items                // example: = list(/obj/item/crowbar, /obj/item/welder, /obj/item/screwdriver = 2) // place /foo/bar before /foo
	var/list/fruit                // example: = list("fruit" = 3)
	var/cooking_time = 10 SECONDS                // Cooking time in deciseconds.

	/// What categories can this recipe be cooked by? Null for any.
	var/list/container_categories
	/// How many items to create, or how many reagent units to add.
	var/result_quantity = 1
	/// An atom type to create, or a /decl/material type if you want to place a reagent into the container.
	var/result
	/// A data list passed to the result if set to a material type.
	var/result_data

	/// A minimum cooking temperature for this recipe to be considered.
	var/minimum_temperature = 0
	/// A maximum temperature for this recipe to be considered.
	var/maximum_temperature = INFINITY

	// Enum for indicating what kind of heat this recipe requires to cook.
	// COOKING_HEAT_ANY, COOKING_HEAT_DIRECT, COOKING_HEAT_INDIRECT
	var/cooking_heat_type = COOKING_HEAT_ANY

	/// A reagent that must be present in the cooking contianer, but will not be consumed.
	var/cooking_medium_type
	/// A minimum about of the above reagent required.
	var/cooking_medium_amount

	var/const/REAGENT_REPLACE = 0 //Reagents in the ingredients are discarded (only the reagents present in the result at compiletime are used)
	var/const/REAGENT_MAX     = 1 //The result will contain the maximum of each reagent present between the two pools. Compiletime result, and sum of ingredients
	var/const/REAGENT_MIN     = 2 //As above, but the minimum, ignoring zero values.
	var/const/REAGENT_SUM     = 3 //The entire quantity of the ingredients are added to the result

	var/reagent_mix = REAGENT_MAX //How to handle reagent differences between the ingredients and the results

	/// Calculated from summing all reagents, ingredients, fruits etc. and used to determine which recipe should be used first.
	var/complexity = 0

	// Codex entry values.
	var/hidden_from_codex // If TRUE, codex page will not be generated for this recipe.
	var/lore_text         // IC description of recipe/food.
	var/mechanics_text    // Mechanical description of recipe/food.
	var/antag_text        // Any antagonist-relevant stuff relating to this recipe.

	var/completion_message

/decl/recipe/validate()
	. = ..()
	if(!ispath(result))
		. += "invalid or null result type: [result || "NULL"]"
	if(!isnum(result_quantity) || result_quantity <= 0)
		. += "invalid or null result amount: [result_quantity || "NULL"]"

/decl/recipe/Initialize()
	. = ..()
	complexity += length(reagents) + length(fruit)
	var/value
	for(var/i in items) // add the number of items total
		value = items[i]
		complexity += isnum(value) ? value : 1
	complexity += length(uniquelist(items)) // add how many unique items there are; will prioritise burgers over 2 bunbuns and 1 wasted meat, for example

/decl/recipe/proc/can_cook_in(atom/container, cooking_temperature)
	if(!istype(container))
		return FALSE
	if(cooking_temperature < minimum_temperature)
		return FALSE
	if(cooking_temperature > maximum_temperature)
		return FALSE
	if(!check_reagents(container.reagents))
		return FALSE
	if(!check_items(container))
		return FALSE
	if(!check_fruit(container))
		return FALSE
	return TRUE

/decl/recipe/proc/check_reagents(datum/reagents/avail_reagents)
	SHOULD_BE_PURE(TRUE)
	if(length(avail_reagents?.reagent_volumes) < length(reagents))
		return FALSE
	for(var/rtype in reagents)
		if(REAGENT_VOLUME(avail_reagents, rtype) < reagents[rtype])
			return FALSE
	return TRUE

/decl/recipe/proc/check_fruit(obj/container)
	// SHOULD_BE_PURE(TRUE) // We cannot set SHOULD_BE_PURE here as
	// get_contained_external_atoms() retrieves an extension, which is impure.
	if(!length(fruit))
		return TRUE
	var/container_contents = container?.get_contained_external_atoms()
	if(length(container_contents) < length(fruit))
		return FALSE
	var/list/needed_fruits = fruit.Copy()
	for(var/obj/item/food/S in container_contents)
		var/use_tag = S.get_grown_tag()
		if(!use_tag)
			continue
		if(isnull(needed_fruits[use_tag]))
			continue
		needed_fruits[use_tag]--
	for(var/ktag in needed_fruits)
		if(needed_fruits[ktag] > 0)
			return FALSE
	return TRUE

/decl/recipe/proc/check_items(obj/container)
	// SHOULD_BE_PURE(TRUE) // We cannot set SHOULD_BE_PURE here as
	// get_contained_external_atoms() retrieves an extension, which is impure.
	if(!length(items))
		return TRUE
	var/list/container_contents = container?.get_contained_external_atoms()
	if(length(container_contents) < length(items))
		return FALSE
	var/list/needed_items = items.Copy()
	for(var/itype in needed_items)
		for(var/thing in container_contents)
			if(!istype(thing, itype))
				continue
			container_contents -= thing
			if(isnum(needed_items[itype]))
				--needed_items[itype]
				if(needed_items[itype] <= 0)
					needed_items -= itype
					break
			else
				needed_items -= itype
				break
			// break
		if(!length(container_contents))
			break
	return !length(needed_items)

/decl/recipe/proc/create_result(atom/container, list/used_ingredients)

	if(!istype(container) || QDELETED(container) || !container.simulated)
		CRASH("Recipe trying to create a result with null or invalid container: [container || "NULL"], [container?.simulated || "NULL"]")
	if(!container.reagents?.maximum_volume)
		CRASH("Recipe trying to create a result in a container with null or zero capacity reagent holder: [container.reagents?.maximum_volume || "NULL"]")

	if(ispath(result, /atom/movable))
		var/produced = create_result_atom(container, used_ingredients)
		var/list/contained_atoms = container.get_contained_external_atoms()
		if(contained_atoms)
			contained_atoms -= produced
			for(var/obj/O in contained_atoms)
				O.reagents.trans_to_obj(produced, O.reagents.total_volume)
				qdel(O)
		return produced

	if(ispath(result, /decl/material))
		var/created_volume = result_quantity
		for(var/obj/item/ingredient in (used_ingredients["items"]|used_ingredients["fruits"]))
			if(!ingredient.reagents?.total_volume)
				continue
			for(var/reagent_type in ingredient.reagents.reagent_volumes)
				created_volume += ingredient.reagents.reagent_volumes[reagent_type]

		container.reagents?.add_reagent(result, created_volume, get_result_data(container, used_ingredients))
		return null

// Create the actual result atom. Handled by a proc to allow for recipes to override it.
/decl/recipe/proc/create_result_atom(atom/container, list/used_ingredients)
	return new result(container)

/// Return a data list to pass to a reagent creation proc. Allows for overriding/mutation based on ingredients.
/// Actually place or create the result of the recipe. Returns the produced item, or the container for reagents.
/decl/recipe/proc/get_result_data(atom/container, list/used_ingredients)
	return result_data

// food-related
/decl/recipe/proc/produce_result(obj/container)

	/*
	We will subtract all the ingredients from the container, and transfer their reagents into a holder
	We will not touch things which are not required for this recipe. They will be left behind for the caller
	to decide what to do. They may be used again to make another recipe or discarded, or merged into the results,
	thats no longer the concern of this proc
	*/

	// We collected the used ingredients before removing them in case
	// the result proc needs to check the list for procedural products.
	var/list/used_ingredients = list(
		"items"    = list(),
		"fruit"    = list(),
		"reagents" = list()
	)

	// Find items we need.
	var/list/container_contents = container.get_contained_external_atoms()
	if(LAZYLEN(items))
		for(var/item_type in items)
			for(var/item_count in 1 to max(1, items[item_type]))
				var/obj/item/item = locate(item_type) in container_contents
				container_contents -= item
				used_ingredients["items"] += item

	// Find fruits that we need.
	if(LAZYLEN(fruit))
		var/list/checklist = fruit.Copy()
		for(var/obj/item/food/food in container_contents)
			var/check_grown_tag = food.get_grown_tag()
			if(check_grown_tag && checklist[check_grown_tag] > 0)
				//We found a thing we need
				container_contents -= food
				checklist[check_grown_tag]--
				used_ingredients["fruits"] += food

	// And lastly deduct necessary quantities of reagents.
	if(LAZYLEN(reagents))
		for(var/reagent_type in reagents)
			used_ingredients["reagents"][reagent_type] += reagents[reagent_type]

	/*
	Now we've removed all the ingredients that were used and we have the buffer containing the total of
	all their reagents.
	If we have multiple results, holder will be used as a buffer to hold reagents for the result objects.
	If, as in the most common case, there is only a single result, then it will just be a reference to
	the single-result's reagents
	*/

	// Create our food products.
	// Note that this will simply put reagents into the container for non-object recipes.
	if(ispath(result, /decl/material))
		var/atom/movable/result_obj = create_result(container, used_ingredients)
		if(istype(result_obj))
			LAZYADD(., result_obj)
	else
		for(var/_ in 1 to result_quantity)
			var/atom/movable/result_obj = create_result(container, used_ingredients)
			if(istype(result_obj))
				LAZYADD(., result_obj)

	// Collect all our ingredient reagents in a buffer.
	// If we aren't using a buffer, just discard the reagents.
	var/datum/reagents/buffer = (reagent_mix != REAGENT_REPLACE) ? new(INFINITY, global.temp_reagents_holder) : null
	for(var/atom/item as anything in used_ingredients["items"])
		if(item.reagents)
			if(buffer)
				item.reagents.trans_to_holder(buffer, item.reagents.total_volume)
			else
				item.reagents.clear_reagents()
		item.physically_destroyed()
	for(var/atom/fruit as anything in used_ingredients["fruits"])
		if(fruit.reagents)
			if(buffer)
				fruit.reagents.trans_to_holder(buffer, fruit.reagents.total_volume)
			else
				fruit.reagents.clear_reagents()
		fruit.physically_destroyed()
	for(var/reagent_type in used_ingredients["reagents"])
		var/reagent_amount = used_ingredients["reagents"][reagent_type]
		if(buffer)
			container.reagents.trans_type_to_holder(buffer, reagent_type, reagent_amount)
		else
			container.reagents.remove_reagent(reagent_type, reagent_amount)

	/// Set the appropriate flag on the food for stressor updates.
	for(var/obj/item/food/food in .)
		food.cooked_food = FOOD_COOKED

	if(completion_message && ATOM_IS_OPEN_CONTAINER(container))
		container.visible_message(SPAN_NOTICE(completion_message))

	// We only care about the outputs, so we can go home now.
	if(reagent_mix == REAGENT_REPLACE)
		if(buffer)
			qdel(buffer)
		return

	// Collect all of the resulting food reagents.
	var/temporary_holder
	var/datum/reagents/holder
	if(length(.) == 1)
		var/atom/movable/result_obj = .[1]
		holder = result_obj.reagents
	else
		temporary_holder = new /datum/reagents(INFINITY, global.temp_reagents_holder)
		holder = temporary_holder
		if(length(.) > 1)
			for(var/atom/movable/result_obj in .)
				result_obj.reagents.trans_to_holder(holder, result_obj.reagents.total_volume)

	switch(reagent_mix)

		if(REAGENT_SUM)
			//Sum is easy, just shove the entire buffer into the result
			buffer.trans_to_holder(holder, buffer.total_volume)

		if(REAGENT_MAX)
			//We want the highest of each.
			//Iterate through everything in buffer. If the target has less than the buffer, then top it up
			for (var/reagent_type in buffer.reagent_volumes)
				var/rvol = REAGENT_VOLUME(holder, reagent_type)
				var/bvol = REAGENT_VOLUME(buffer, reagent_type)
				if (rvol < bvol)
					//Transfer the difference
					buffer.trans_type_to_holder(holder, reagent_type, bvol-rvol)

		if(REAGENT_MIN)
			//Min is slightly more complex. We want the result to have the lowest from each side
			//But zero will not count. Where a side has zero its ignored and the side with a nonzero value is used
			for (var/reagent_type in buffer.reagent_volumes)
				var/rvol = REAGENT_VOLUME(holder, reagent_type)
				var/bvol = REAGENT_VOLUME(buffer, reagent_type)
				if (rvol == 0) //If the target has zero of this reagent
					buffer.trans_type_to_holder(holder, reagent_type, bvol)
					//Then transfer all of ours

				else if (rvol > bvol)
					//if the target has more than ours
					//Remove the difference
					holder.remove_reagent(reagent_type, rvol-bvol)

	if(length(.) > 1)
		// If we're here, then holder is a buffer containing the total reagents
		// for all the results. So now we redistribute it among them.
		var/total = round(holder.total_volume / length(.))
		for(var/atom/result as anything in .)
			holder.trans_to(result, total)

	// Clean up after ourselves.
	if(buffer)
		qdel(buffer)
	if(temporary_holder && holder)
		qdel(holder)
