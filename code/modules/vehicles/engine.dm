/obj/item/engine
	name = "engine"
	desc = "An engine used to power a small vehicle."
	icon = 'icons/obj/objects.dmi'
	w_class = ITEM_SIZE_HUGE
	material = /decl/material/solid/metal/steel
	var/broken = FALSE
	var/trail_type
	var/cost_per_move = 5

/obj/item/engine/proc/get_trail()
	if(trail_type)
		return new trail_type
	return null

/obj/item/engine/proc/prefill()
	return

/obj/item/engine/proc/use_power()
	return 0

/obj/item/engine/proc/rev_engine(var/obj/vehicle/vehicle)
	return

/obj/item/engine/proc/putter(var/obj/vehicle/vehicle)
	return

/obj/item/engine/electric
	name = "electric engine"
	desc = "A battery-powered engine used to power a small vehicle."
	icon_state = "engine_electric"
	trail_type = /datum/effect/effect/system/trail/ion
	cost_per_move = 200	// W
	var/obj/item/cell/cell

/obj/item/engine/electric/attackby(var/obj/item/used_item, var/mob/user)
	// TODO: use cell extension for this?
	if(istype(used_item, /obj/item/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("There is already a cell in \the [src]."))
		else
			cell = used_item
			user.drop_from_inventory(used_item)
			used_item.forceMove(src)
		return TRUE
	else if(IS_CROWBAR(used_item))
		if(cell)
			to_chat(user, SPAN_NOTICE("You pry out \the [cell] with \the [used_item]."))
			cell.dropInto(loc)
			cell = null
			return TRUE
		if(!user.check_intent(I_FLAG_HARM))
			to_chat(user, SPAN_WARNING("There is no cell in \the [src] to remove with \the [used_item]!"))
			return TRUE
	return ..()

/obj/item/engine/electric/prefill()
	cell = new /obj/item/cell/high(src.loc)

/obj/item/engine/electric/use_power()
	if(!cell)
		return FALSE
	return cell.use(cost_per_move * CELLRATE)

/obj/item/engine/electric/rev_engine(var/obj/vehicle/vehicle)
	vehicle.audible_message("\The [vehicle] beeps, spinning up.")

/obj/item/engine/electric/putter(var/obj/vehicle/vehicle)
	vehicle.audible_message("\The [vehicle] makes one depressed beep before winding down.")

/obj/item/engine/electric/emp_act(var/severity)
	if(cell)
		cell.emp_act(severity)
	..()

/obj/item/engine/thermal
	name = "thermal engine"
	desc = "A fuel-powered engine used to power a small vehicle."
	icon_state = "engine_fuel"
	trail_type = /datum/effect/effect/system/trail/thermal
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	chem_volume = 500
	var/datum/reagents/combustion_chamber
	var/fuel_points = 0
	//fuel points are determined by differing reagents

/obj/item/engine/thermal/prefill()
	fuel_points = 5000

/obj/item/engine/thermal/Initialize()
	. = ..()
	combustion_chamber = new(15, global.temp_reagents_holder)

/obj/item/engine/thermal/attackby(var/obj/item/used_item, var/mob/user)
	if(used_item.standard_pour_into(user, src))
		return TRUE
	return ..()

/// Attempts to burn a sample of the fuel in our reagent holder. Returns TRUE if enough fuel points are produced to move, otherwise returns FALSE.
/obj/item/engine/thermal/proc/burn_fuel()
	if(!reagents || REAGENT_TOTAL_VOLUME(reagents) <= 0 || broken)
		return FALSE
	reagents.trans_to_holder(combustion_chamber, min(REAGENT_TOTAL_VOLUME(reagents), 15))
	var/multiplier = 0
	var/actually_flammable = FALSE
	for(var/decl/material/reagent as anything in REAGENT_VOLUMES(temp_reagents_holder.reagents))
		var/new_multiplier = 1
		var/reagent_volume = REAGENT_VOLUME(combustion_chamber, reagent)
		if(reagent.accelerant_value < FUEL_VALUE_NONE) // suppresses fires rather than starts them
			// this means that FUEL_VALUE_SUPPRESSANT is on par with water in the old code
			new_multiplier = -(FUEL_VALUE_SUPPRESSANT + reagent.accelerant_value) / 2 * 0.4
		if(reagent.accelerant_value > FUEL_VALUE_NONE)
			// averaging these means that FUEL_VALUE_ACCELERANT is 1x, hydrazine is 1.25x, and exotic matter is 1.5x
			new_multiplier = (FUEL_VALUE_ACCELERANT + reagent.accelerant_value) / 2
			actually_flammable = TRUE
		if(ispath(reagent, /decl/material/liquid/nutriment/sugar) && REAGENT_VOLUME(reagents, reagent) > 1)
			broken = TRUE
			explosion(get_turf(src),-1,0,2,3,0)
			return 0
		multiplier += new_multiplier * reagent_volume
	if(!actually_flammable)
		return FALSE
	fuel_points += 20 * multiplier
	combustion_chamber.clear_reagents()
	return fuel_points >= cost_per_move

/obj/item/engine/thermal/use_power()
	if(fuel_points >= cost_per_move || burn_fuel())
		fuel_points -= cost_per_move
		return TRUE
	return FALSE

/obj/item/engine/thermal/rev_engine(var/obj/vehicle/vehicle)
	vehicle.audible_message("\The [vehicle] rumbles to life.")

/obj/item/engine/thermal/putter(var/obj/vehicle/vehicle)
	vehicle.audible_message("\The [vehicle] putters before turning off.")