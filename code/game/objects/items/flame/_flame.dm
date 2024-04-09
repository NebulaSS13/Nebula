//For anything that can light stuff on fire
/obj/item/flame

	abstract_type = /obj/item/flame
	icon_state    = ICON_STATE_WORLD
	w_class       = ITEM_SIZE_TINY
	throwforce    = 4
	origin_tech   = @'{"materials":1}'
	material      = /decl/material/solid/organic/wood

	/// Parameters for lighting when lit.
	var/lit_light_range = 1
	var/lit_light_power = 0.5
	var/lit_light_color = "#e09d37"

	/// Does this flame source smell of anything when burning?
	var/decl/scent_type/scent
	/// Is this item extinguished by being dropped?
	var/extinguish_on_dropped = TRUE
	/// How hot does this burn?
	var/lit_heat = 1000
	/// Can this item be extinguished by water?
	var/waterproof = FALSE
	/// Is this item currently lit?
	var/lit = FALSE
	/// How many SSobj ticks can this burn for?
	var/_fuel = 0
	/// How much fuel does this spend in a tick?
	var/_fuel_spend_amt = 1
	/// Can you put this item out with your hand?
	var/can_manually_extinguish = TRUE
	/// Can you light this item with your hand?
	var/can_manually_light = FALSE

/obj/item/flame/Initialize()

	var/list/available_scents = get_available_scents()
	if(LAZYLEN(available_scents))
		scent = pick(available_scents)
		scent = GET_DECL(scent)
		if(istype(scent))
			if(scent.color)
				set_color(scent.color)
			desc += " This one smells of [scent.scent]."
		else
			scent = null

	. = ..()

	set_extension(src, /datum/extension/tool, list(TOOL_CAUTERY = TOOL_QUALITY_BAD))
	update_icon()

/obj/item/flame/Destroy()
	extinguish(null, TRUE)
	return ..()

/obj/item/flame/proc/get_available_scents()
	return null

/obj/item/flame/get_tool_quality(archetype, property)
	return (!lit && archetype == TOOL_CAUTERY) ? TOOL_QUALITY_NONE : ..()

/obj/item/flame/proc/has_fuel(amount)
	return get_fuel() >= amount

/obj/item/flame/proc/light(mob/user, no_message)

	// TODO: check for oxidizer
	if(lit || !has_fuel(_fuel_spend_amt))
		return FALSE
	lit = TRUE
	damtype = BURN
	update_force()
	update_icon()
	if(!no_message)
		user.visible_message(
			SPAN_NOTICE("\The [user] lights \the [src]."),
			SPAN_NOTICE("You light \the [src].")
		)
	if(!is_processing)
		START_PROCESSING(SSobj, src)
	if(scent)
		set_extension(src, scent.scent_datum)
	if(lit_light_range && lit_light_power)
		set_light(lit_light_range, lit_light_power, lit_light_color)

	return TRUE

/obj/item/flame/attack(mob/living/M, mob/living/user)

	if(!istype(M) || user.a_intent == I_HURT || !lit || user.get_target_zone() != BP_MOUTH)
		return ..()

	var/obj/item/clothing/mask/smokable/cigarette/cig = M.get_equipped_item(slot_wear_mask_str)
	if(istype(cig))
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light(SPAN_NOTICE("\The [user] holds \the [src] out for \the [M], and lights \the [cig]."))
		return TRUE

	return ..()

/obj/item/flame/proc/extinguish(var/mob/user, var/no_message)
	if(!lit)
		return FALSE
	lit = FALSE
	damtype = BRUTE
	update_force()
	update_icon()
	set_light(0)
	if(scent)
		remove_extension(src, /datum/extension/scent)
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	if(!no_message)
		visible_message(SPAN_NOTICE("\The [src] goes out."))
	return TRUE

/obj/item/flame/attack_self(mob/user)

	if(!lit && can_manually_light)
		if(has_fuel(_fuel_spend_amt))
			light(user)
		else
			to_chat(user, SPAN_WARNING("\The [src] won't ignite. It must be out of fuel."))
		return TRUE

	if(lit && can_manually_extinguish)
		extinguish(user)
		return TRUE

	return ..()

/obj/item/flame/fluid_act(var/datum/reagents/fluids)
	..()
	if(!QDELETED(src) && fluids?.total_volume && !waterproof && lit)
		var/turf/location = get_turf(src)
		if(location)
			location.hotspot_expose(700, 5) // Potentially set fire to fuel etc.
		extinguish(no_message = TRUE)

/obj/item/flame/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	if(!QDELETED(src) && !can_manually_light)
		light(null, TRUE)

/obj/item/flame/get_heat()
	return max(..(), lit ? lit_heat : 0)

/obj/item/flame/can_puncture()
	return lit

/obj/item/flame/isflamesource()
	return lit

/obj/item/flame/proc/get_fuel()
	return _fuel

/obj/item/flame/proc/expend_fuel(amount)
	_fuel = max(0, get_fuel()-amount)
	return has_fuel(_fuel_spend_amt)

/obj/item/flame/resolve_attackby(var/atom/A, mob/user)
	. = ..()
	if(istype(A, /obj/item/flame) && lit)
		var/obj/item/flame/other = A
		if(!other.can_manually_light)
			other.light(user)

/obj/item/flame/attackby(obj/item/W, mob/user)
	if(user.a_intent != I_HURT && !can_manually_light && (W.isflamesource() || W.get_heat() > T100C))
		light(user)
		return TRUE
	return ..()

/obj/item/flame/Process()

	if((!waterproof && submerged()) || !expend_fuel(_fuel_spend_amt))
		extinguish()
		return PROCESS_KILL

	update_icon()

	// TODO: generalized ignition proc
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()

	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(get_heat(), w_class)

/obj/item/flame/dropped(var/mob/user)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if(lit && extinguish_on_dropped)
		var/turf/location = loc
		if(istype(location))
			location.hotspot_expose(700, 5)
		extinguish()
	return ..()

/obj/item/flame/spark_act(obj/effect/sparks/sparks)
	if(!can_manually_light)
		light(null, no_message = TRUE)
