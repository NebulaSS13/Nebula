/obj/item/chems/cooking_vessel

	abstract_type                 = /obj/item/chems/cooking_vessel
	atom_flags                    = ATOM_FLAG_OPEN_CONTAINER
	obj_flags                     = OBJ_FLAG_HOLLOW
	w_class                       = ITEM_SIZE_LARGE
	icon_state                    = ICON_STATE_WORLD
	material_alteration           = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	storage                       = /datum/storage/hopper/industrial
	material                      = /decl/material/solid/metal/stainlesssteel
	amount_per_transfer_from_this = 15

	var/cooking_category
	var/started_cooking
	var/decl/recipe/last_recipe

// TODO: ladle
/obj/item/chems/cooking_vessel/attackby(obj/item/W, mob/user)

	if(user.a_intent == I_HURT)
		return ..()

	// Fill or take from the vessel.
	if(W.reagents && ATOM_IS_OPEN_CONTAINER(W) && !istype(W, /obj/item/chems/food))
		if(W.reagents.total_volume)
			if(istype(W, /obj/item/chems))
				var/obj/item/chems/vessel = W
				if(vessel.standard_pour_into(user, src))
					return TRUE
		else if(standard_pour_into(user, W))
			return TRUE

	return ..()

/obj/item/chems/cooking_vessel/proc/get_cooking_contents_strings()

	. = list()

	for(var/obj/item/thing in get_stored_inventory())
		. += "\the [thing]"

	if(reagents?.total_volume)
		for(var/reagent_type in reagents.reagent_volumes)
			var/decl/material/reagent = GET_DECL(reagent_type)
			var/reagent_name = reagent.get_reagent_name(reagents)
			if(!isnull(reagent.boiling_point) && temperature >= reagent.boiling_point)
				. += "[reagents.reagent_volumes[reagent_type]]u of simmering [reagent_name]"
			else
				. += "[reagents.reagent_volumes[reagent_type]]u of [reagent_name]"

/obj/item/chems/cooking_vessel/examine(mob/user, distance)
	. = ..()
	if(user && distance <= 1)
		var/list/contents_strings = get_cooking_contents_strings()
		if(length(contents_strings))
			to_chat(user, SPAN_NOTICE("\The [src] contains:"))
			for(var/content_string in contents_strings)
				to_chat(user, SPAN_NOTICE("- [content_string]"))
		else
			to_chat(user, SPAN_NOTICE("\The [src] is empty."))

/obj/item/chems/cooking_vessel/Process()
	. = ..()
	var/decl/recipe/recipe = select_recipe(cooking_category, src, temperature)
	if(!recipe) // Too hot, too cold, ingredients changed.
		//TODO fail last recipe
		started_cooking = null
		last_recipe = null
		return PROCESS_KILL
	if(isnull(started_cooking) || recipe != last_recipe)
		started_cooking = world.time
	else if((world.time - started_cooking) >= recipe.cooking_time)
		recipe.produce_result(src)
		started_cooking = null
		last_recipe = null
		return
	last_recipe = recipe
	update_icon()

/obj/item/chems/cooking_vessel/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()

/obj/item/chems/cooking_vessel/Entered()
	. = ..()
	started_cooking = null
	if(!is_processing)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/chems/cooking_vessel/on_reagent_change()
	. = ..()
	started_cooking = null
	if(!is_processing)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/chems/cooking_vessel/Destroy()
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/chems/cooking_vessel/ProcessAtomTemperature()
	. = ..()
	if(. != PROCESS_KILL && !is_processing)
		START_PROCESSING(SSobj, src)
