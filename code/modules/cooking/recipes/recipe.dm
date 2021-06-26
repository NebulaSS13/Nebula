/* * * * * * * * * * * * * * * * * * * * * * * * * *
 * /decl/recipe by rastaf0            13 apr 2011 *
 * * * * * * * * * * * * * * * * * * * * * * * * * *
 * This is powerful and flexible recipe system.
 * It exists not only for food.
 * supports both reagents and objects as prerequisites.
 * In order to use this system you have to define a deriative from /decl/recipe
 * * reagents are reagents. Acid, milc, booze, etc.
 * * items are objects. Fruits, tools, circuit boards.
 * * result is type to create as new object
 * * time is optional parameter, you shall use in in your machine,
	 default /decl/recipe/ procs does not rely on this parameter.
 *
 *  Functions you need:
 *  /decl/recipe/proc/make(var/obj/container as obj)
 *    Creates result inside container,
 *    deletes prerequisite reagents,
 *    transfers reagents from prerequisite objects,
 *    deletes all prerequisite objects (even not needed for recipe at the moment).
 *
 *  /proc/select_recipe(obj/obj as obj, exact = 1, appliance)
 *    Wonderful function that select suitable recipe for you.
 *    obj is a machine (or magik hat) with prerequisites,
 *    exact = 0 forces algorithm to ignore superfluous stuff.
 *
 *
 *  Functions you do not need to call directly but could:
 *  /decl/recipe/proc/check_reagents(var/datum/reagents/avail_reagents)
 *  /decl/recipe/proc/check_items(var/obj/container as obj)
 *
 * */



/decl/recipe
	var/display_name
	var/list/reagents // example: = list(/decl/material/liquid/drink/berryjuice = 5) // do not list same reagent twice
	var/list/items    // example: = list(/obj/item/crowbar, /obj/item/welder) // place /foo/bar before /foo
	var/list/fruit    // example: = list("fruit" = 3)
	var/coating = null//Required coating on all items in the recipe. The default value of null explitly requires no coating
	//A value of -1 is permissive and cares not for any coatings
	//Any typepath indicates a specific coating that should be present
	//Coatings are used for batter, breadcrumbs, beer-batter, colonel's secret coating, etc

	var/result        // example: = /obj/item/chems/food/snacks/donut/normal
	var/result_quantity = 1 //number of instances of result that are created.
	var/time = 100    // 1/10 part of second

	var/hidden_from_codex = FALSE
	var/lore_text
	var/mechanics_text
	var/antag_text
	var/added_to_codex = FALSE //to prevent duplicates

	#define RECIPE_REAGENT_REPLACE		0 //Reagents in the ingredients are discarded.
	//Only the reagents present in the result at compiletime are used
	#define RECIPE_REAGENT_MAX	1 //The result will contain the maximum of each reagent present between the two pools. Compiletime result, and sum of ingredients
	#define RECIPE_REAGENT_MIN 2 //As above, but the minimum, ignoring zero values.
	#define RECIPE_REAGENT_SUM 3 //The entire quantity of the ingredients are added to the result

	var/reagent_mix = RECIPE_REAGENT_MAX	//How to handle reagent differences between the ingredients and the results

	var/finished_temperature = T0C + 40 //The temperature of the reagents of the final product.Only affects nutrient type.

	var/appliance = MIX//Which appliances this recipe can be made in.
	//List of defines is in _defines/misc.dm. But for reference they are:
	/*
		MIX
		FRYER
		OVEN
		SKILLET
		SAUCEPAN
		POT
	*/
	//This is a bitfield, more than one type can be used

/decl/recipe/proc/get_appliance_names()
	var/list/appliance_names
	if(appliance & GRILL) // this comes first in the proc because it's the most important - geeves
		LAZYADD(appliance_names, "a grill")
	if(appliance & MIX)
		LAZYADD(appliance_names, "a mixing bowl or plate")
	if(appliance & FRYER)
		LAZYADD(appliance_names, "a fryer")
	if(appliance & OVEN)
		LAZYADD(appliance_names, "an oven")
	if(appliance & SKILLET)
		LAZYADD(appliance_names, "a skillet")
	if(appliance & SAUCEPAN)
		LAZYADD(appliance_names, "a saucepan")
	if(appliance & POT)
		LAZYADD(appliance_names, "a pot")
	return english_list(appliance_names, and_text = " or ")

/decl/recipe/proc/check_reagents(var/datum/reagents/avail_reagents)
	if(length(avail_reagents?.reagent_volumes) < length(reagents))
		return FALSE
	for(var/rtype in reagents)
		if(REAGENT_VOLUME(avail_reagents, rtype) < reagents[rtype])
			return FALSE
	return TRUE

/decl/recipe/proc/check_fruit(var/obj/container)
	if(!length(fruit))
		return TRUE
	var/container_contents = container?.get_contained_external_atoms()
	if(length(container_contents) < length(fruit))
		return FALSE
	var/list/needed_fruits = fruit.Copy()
	for(var/obj/item/chems/food/snacks/S in container_contents)
		var/use_tag
		if(istype(S, /obj/item/chems/food/snacks/grown))
			var/obj/item/chems/food/snacks/grown/G = S
			if(!G.seed || !G.seed.kitchen_tag)
				continue
			use_tag = G.dry ? "dried [G.seed.kitchen_tag]" : G.seed.kitchen_tag
		else if(istype(S, /obj/item/chems/food/snacks/fruit_slice))
			var/obj/item/chems/food/snacks/fruit_slice/FS = S
			if(!FS.seed || !FS.seed.kitchen_tag)
				continue
			use_tag = "[FS.seed.kitchen_tag] slice"
		use_tag = "[S.dry ? "dried " : ""][use_tag]"
		if(isnull(needed_fruits[use_tag]))
			continue
		if (check_coating(S))
			needed_fruits[use_tag]--
	for(var/ktag in needed_fruits)
		if(needed_fruits[ktag] > 0)
			return FALSE
	return .

/decl/recipe/proc/check_items(var/obj/container)
	if(!length(items))
		return TRUE
	var/container_contents = container?.get_contained_external_atoms()
	if(length(container_contents) < length(items))
		return FALSE
	var/list/needed_items = items.Copy()
	for(var/itype in needed_items)
		for(var/thing in container_contents)
			if(istype(thing, itype))
				container_contents -= thing
				needed_items -= itype
				break
		if(!length(container_contents))
			break
	return !length(needed_items)

//This is called on individual items within the container.
/decl/recipe/proc/check_coating(var/obj/item/chems/food/snacks/S)
	if(!istype(S))
		return TRUE//Only snacks can be battered

	if (coating == -1)
		return TRUE //-1 value doesnt care

	return !coating || (S.batter_coating == coating)

//general version
/decl/recipe/proc/make(var/obj/container)
	var/obj/result_obj = new result(container)
	var/list/contained_atoms = container.get_contained_external_atoms()
	if(contained_atoms)
		contained_atoms -= result_obj
		for(var/obj/O in contained_atoms)
			O.reagents.trans_to_obj(result_obj, O.reagents.total_volume)
			qdel(O)
	container.reagents.clear_reagents()
	return result_obj

// food-related
//This proc is called under the assumption that the container has already been checked and found to contain the necessary ingredients
/decl/recipe/proc/make_food(var/obj/container as obj)
	if(!result)
		log_error("<span class='danger'>Recipe [type] is defined without a result, please bug this.</span>")
		return


//We will subtract all the ingredients from the container, and transfer their reagents into a holder
//We will not touch things which are not required for this recipe. They will be left behind for the caller
//to decide what to do. They may be used again to make another recipe or discarded, or merged into the results,
//thats no longer the concern of this proc
	var/datum/reagents/buffer = new /datum/reagents(1e12, global.temp_reagents_holder)//
	var/list/container_contents = container.get_contained_external_atoms()
	//Find items we need
	if (LAZYLEN(items))
		for (var/i in items)
			var/obj/item/I = locate(i) in container_contents
			if (I && I.reagents)
				I.reagents.trans_to_holder(buffer,I.reagents.total_volume)
				qdel(I)

	//Find fruits
	if (LAZYLEN(fruit))
		var/list/checklist = list()
		checklist = fruit.Copy()

		for(var/obj/item/chems/food/snacks/grown/G in container_contents)
			if(!G.seed || !G.seed.kitchen_tag || isnull(checklist[G.seed.kitchen_tag]))
				continue

			if (checklist[G.seed.kitchen_tag] > 0)
				//We found a thing we need
				checklist[G.seed.kitchen_tag]--
				if (G && G.reagents)
					G.reagents.trans_to_holder(buffer,G.reagents.total_volume)
				qdel(G)

	//And lastly deduct necessary quantities of reagents
	if (LAZYLEN(reagents))
		for (var/r in reagents)
			//Doesnt matter whether or not there's enough, we assume that check is done before
			container.reagents.trans_type_to(buffer, r, reagents[r])

	/*
	Now we've removed all the ingredients that were used and we have the buffer containing the total of
	all their reagents.
	If we have multiple results, holder will be used as a buffer to hold reagents for the result objects.
	If, as in the most common case, there is only a single result, then it will just be a reference to
	the single-result's reagents
	*/
	var/datum/reagents/holder = new/datum/reagents(1e12, global.temp_reagents_holder)
	var/list/results = list()
	for (var/_ in 1 to result_quantity)
		var/obj/result_obj = new result(container)
		results.Add(result_obj)

		if (!result_obj.reagents)//This shouldn't happen
			//If the result somehow has no reagents defined, then create a new holder
			result_obj.create_reagents(buffer.total_volume*1.5)

		if (result_quantity == 1)
			qdel(holder)
			holder = result_obj.reagents
		else
			result_obj.reagents.trans_to_holder(holder, result_obj.reagents.total_volume)


	switch(reagent_mix)
		if (RECIPE_REAGENT_REPLACE)
			//We do no transferring
		if (RECIPE_REAGENT_SUM)
			//Sum is easy, just shove the entire buffer into the result
			buffer.trans_to_holder(holder, buffer.total_volume)
		if (RECIPE_REAGENT_MAX)
			//We want the highest of each.
			//Iterate through everything in buffer. If the target has less than the buffer, then top it up
			for (var/_R in buffer.reagent_volumes)
				var/rvol = REAGENT_VOLUME(holder, _R)
				var/bvol = REAGENT_VOLUME(buffer, _R)
				if (rvol < bvol)
					//Transfer the difference
					buffer.trans_type_to(holder, _R, bvol-rvol)

		if (RECIPE_REAGENT_MIN)
			//Min is slightly more complex. We want the result to have the lowest from each side
			//But zero will not count. Where a side has zero its ignored and the side with a nonzero value is used
			for (var/_R in buffer.reagent_volumes)
				var/rvol = REAGENT_VOLUME(holder, _R)
				var/bvol = REAGENT_VOLUME(buffer, _R)
				if (rvol == 0) //If the target has zero of this reagent
					buffer.trans_type_to(holder, _R, bvol)
					//Then transfer all of ours

				else if (rvol > bvol)
					//if the target has more than ours
					//Remove the difference
					holder.remove_reagent(_R, rvol-bvol)


	if (length(results) > 1)
		//If we're here, then holder is a buffer containing the total reagents for all the results.
		//So now we redistribute it among them
		var/total = holder.total_volume
		for (var/i in results)
			var/atom/a = i //optimisation
			holder.trans_to(a, total / length(results))

	return results

//When exact is false, extraneous ingredients are ignored
//When exact is true, extraneous ingredients will fail the recipe
//In both cases, the full complement of required inredients is still needed
/proc/select_recipe(var/obj/obj as obj, var/appliance = null)
	if(!appliance)
		CRASH("Null appliance flag passed to select_recipe!")
	var/highest_count = 0
	var/count = 0
	var/available_recipes = decls_repository.get_decls_of_subtype(/decl/recipe)
	for (var/rtype in available_recipes)
		var/decl/recipe/recipe = available_recipes[rtype]
		if(!(appliance & recipe.appliance))
			continue
		if(!recipe.check_reagents(obj.reagents) || !recipe.check_items(obj)  || !recipe.check_fruit(obj))
			continue
		// Taken from cmp_recipe_complexity_dsc, but is way faster.
		count = LAZYLEN(recipe.items) + LAZYLEN(recipe.reagents) + LAZYLEN(recipe.fruit)
		if(count >= highest_count)
			highest_count = count
			. = recipe
