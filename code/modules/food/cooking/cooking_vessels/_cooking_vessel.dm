/obj/item/chems/cooking_vessel

	abstract_type                 = /obj/item/chems/cooking_vessel
	atom_flags                    = ATOM_FLAG_OPEN_CONTAINER
	obj_flags                     = OBJ_FLAG_HOLLOW
	w_class                       = ITEM_SIZE_LARGE
	icon_state                    = ICON_STATE_WORLD
	material_alteration           = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	storage                       = /datum/storage/hopper/industrial
	material                      = /decl/material/solid/metal/stainlesssteel
	color                         = /decl/material/solid/metal/stainlesssteel::color
	amount_per_transfer_from_this = 15

	// Used for work sounds.
	var/datum/sound_token/work_sound_token
	var/sound_id
	var/work_sound

	var/cooking_category
	var/started_cooking
	var/decl/recipe/last_recipe

/obj/item/chems/cooking_vessel/Initialize(ml, material_key)
	. = ..()
	if(work_sound)
		sound_id = "[work_sound]"

/obj/item/chems/cooking_vessel/Destroy()
	QDEL_NULL(work_sound_token)
	return ..()

// TODO: ladle
/obj/item/chems/cooking_vessel/attackby(obj/item/used_item, mob/user)

	if(user.check_intent(I_FLAG_HARM))
		return ..()

	// Fill or take from the vessel.
	if(used_item.reagents && ATOM_IS_OPEN_CONTAINER(used_item))
		if(used_item.reagents.total_volume)
			if(istype(used_item, /obj/item/chems))
				var/obj/item/chems/vessel = used_item
				if(vessel.standard_pour_into(user, src))
					return TRUE
		else if(standard_pour_into(user, used_item))
			return TRUE

	return ..()

// Boilerplate from /obj/item/chems/glass. TODO generalize to a lower level.
/obj/item/chems/cooking_vessel/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(get_attack_force() && !(item_flags & ITEM_FLAG_NO_BLUDGEON) && user.check_intent(I_FLAG_HARM))
		return ..()
	return FALSE

/obj/item/chems/cooking_vessel/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity || istype(target, /obj/machinery/reagent_temperature))
		return FALSE
	if(!ATOM_IS_OPEN_CONTAINER(src) || !proximity) //Is the container open & are they next to whatever they're clicking?
		return FALSE //If not, do nothing.
	if(target?.storage)
		return TRUE
	if(standard_dispenser_refill(user, target)) //Are they clicking a water tank/some dispenser?
		return TRUE
	if(standard_pour_into(user, target)) //Pouring into another beaker?
		return TRUE
	if(handle_eaten_by_mob(user, target) != EATEN_INVALID)
		return TRUE
	if(user.check_intent(I_FLAG_HARM))
		if(standard_splash_mob(user,target))
			return TRUE
		if(reagents && reagents.total_volume)
			to_chat(user, SPAN_DANGER("You splash the contents of \the [src] onto \the [target]."))
			reagents.splash(target, reagents.total_volume)
			return TRUE
	else if(reagents && reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You splash a small amount of the contents of \the [src] onto \the [target]."))
		reagents.splash(target, min(reagents.total_volume, 5))
		return TRUE
	. = ..()
// End boilerplate.

/obj/item/chems/cooking_vessel/proc/get_cooking_contents_strings()

	. = list()

	for(var/obj/item/thing in get_stored_inventory())
		. += "\the [thing]"

	if(reagents?.total_volume)
		for(var/decl/material/reagent as anything in reagents.solid_volumes)
			. += "[reagents.solid_volumes[reagent]]u of [reagent.get_reagent_name(reagents, MAT_PHASE_SOLID)]"

		var/datum/gas_mixture/environment = loc?.return_air()
		var/ambient_pressure = environment ? environment.return_pressure() : ONE_ATMOSPHERE
		for(var/decl/material/reagent as anything in reagents.liquid_volumes)
			var/reagent_name = reagent.get_reagent_name(reagents, MAT_PHASE_LIQUID)
			if(reagent.phase_at_temperature(temperature, ambient_pressure) == MAT_PHASE_GAS && reagent.soup_hot_desc)
				. += "[reagents.liquid_volumes[reagent]]u of [reagent.soup_hot_desc] [reagent_name]"
			else
				. += "[reagents.liquid_volumes[reagent]]u of [reagent_name]"

/obj/item/chems/cooking_vessel/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(user && distance <= 1)
		var/list/contents_strings = get_cooking_contents_strings()
		if(length(contents_strings))
			. += SPAN_NOTICE("\The [src] contains:")
			for(var/content_string in contents_strings)
				. += SPAN_NOTICE("- [content_string]")
		else
			. += SPAN_NOTICE("\The [src] is empty.")

/obj/item/chems/cooking_vessel/Process()
	var/decl/recipe/recipe = select_recipe(cooking_category, src, temperature)
	if(!recipe) // Too hot, too cold, ingredients changed.
		//TODO fail last recipe
		started_cooking = null
		last_recipe = null
		QDEL_NULL(work_sound_token)
		return PROCESS_KILL
	if(isnull(started_cooking) || recipe != last_recipe)
		started_cooking = world.time
	else if((world.time - started_cooking) >= recipe.cooking_time)
		recipe.produce_result(src)
		recipe = select_recipe(cooking_category, src, temperature)
		if(recipe && recipe == last_recipe && recipe.can_bulk_cook)
			// Bulk cooking has benefits like reduced cook time
			// we don't just do it instantly because there's messages each time
			started_cooking = world.time + (recipe.cooking_time / 5)
		else
			started_cooking = null
			last_recipe = null
		return
	last_recipe = recipe
	if(!work_sound_token)
		work_sound_token = play_looping_sound(src, sound_id, work_sound, volume = 30)
	update_icon()

/obj/item/chems/cooking_vessel/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(material.reflectiveness >= MAT_VALUE_SHINY && check_state_in_icon("[icon_state]-shine", icon))
		var/mutable_appearance/shine = mutable_appearance(icon, "[icon_state]-shine", adjust_brightness(color, 20 + material.reflectiveness))
		shine.alpha = material.reflectiveness * 3
		add_overlay(shine)

/obj/item/chems/cooking_vessel/Entered()
	. = ..()
	started_cooking = null
	if(!is_processing)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/chems/cooking_vessel/on_reagent_change()
	if(!(. = ..()))
		return
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
	update_icon()
