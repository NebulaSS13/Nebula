/obj/item/chems/cooking_vessel/pot
	name               = "pot"
	desc               = "A large pot for boiling things."
	icon               = 'icons/obj/food/cooking_vessels/pot.dmi'
	chem_volume        = 100
	cooking_category   = RECIPE_CATEGORY_POT
	presentation_flags = PRESENTATION_FLAG_NAME
	obj_flags          = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE
	work_sound = 'sound/effects/boiling-water.ogg'
	var/last_boil_status
	var/last_boil_temp

/obj/item/chems/cooking_vessel/pot/iron
	material = /decl/material/solid/metal/iron
	color = /decl/material/solid/metal/iron::color

/obj/item/chems/cooking_vessel/pot/get_reagents_overlay(state_prefix)
	var/image/our_overlay = ..()
	if(our_overlay && last_boil_status && check_state_in_icon("[our_overlay.icon_state]_boiling", our_overlay.icon))
		our_overlay.icon_state = "[our_overlay.icon_state]_boiling"
	return our_overlay

/obj/item/chems/cooking_vessel/pot/on_reagent_change()
	last_boil_temp   = null
	last_boil_status = null
	. = ..()

/obj/item/chems/cooking_vessel/pot/ProcessAtomTemperature()
	var/prior_temperature = temperature
	. = ..()
	// to avoid issues with it cooling down in ..() and reheating the same tick, we use the highest of the two
	// todo: just prevent the cooling instead, for a less-hacky solution
	var/use_temperature = max(temperature, prior_temperature)
	var/datum/gas_mixture/environment = loc?.return_air()
	var/ambient_pressure = environment ? environment.return_pressure() : ONE_ATMOSPHERE

	// Largely ignore return value so we don't skip this update on the final time we temperature process.
	if(use_temperature != last_boil_temp)

		last_boil_temp = use_temperature
		var/next_boil_status = FALSE
		for(var/decl/material/reagent as anything in REAGENT_VOLUMES(reagents))
			if(reagent.phase_at_temperature(use_temperature, ambient_pressure) == MAT_PHASE_GAS)
				next_boil_status = TRUE
				break

		if(next_boil_status != last_boil_status)
			last_boil_status = next_boil_status
			update_icon()

	if(. == PROCESS_KILL)
		last_boil_temp   = null
		last_boil_status = null

/obj/item/chems/cooking_vessel/cauldron
	name        = "cauldron"
	desc        = "A large round-bodied vessel for making large quantities of potion or soup."
	material    = /decl/material/solid/metal/iron
	color       = /decl/material/solid/metal/iron::color
	icon        = 'icons/obj/food/cooking_vessels/cauldron.dmi'
	chem_volume = 1000
	w_class     = ITEM_SIZE_STRUCTURE
	density     = TRUE

/obj/item/chems/cooking_vessel/cauldron/can_be_picked_up(mob/user)
	return FALSE
