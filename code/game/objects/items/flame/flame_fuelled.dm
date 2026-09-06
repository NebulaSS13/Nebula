/obj/item/flame/fuelled

	abstract_type         = /obj/item/flame/fuelled
	_fuel_spend_amt       = 0.05
	can_manually_light    = TRUE
	extinguish_on_dropped = FALSE
	watertight            = TRUE
	chem_volume           = 5

	var/tmp/start_fuelled = FALSE

	/// TODO: make this calculate a fuel amount via accelerant value or some other check.
	/// Reagent type to burn as fuel. If null, will use the map default.
	var/fuel_type

/obj/item/flame/fuelled/Initialize()
	if(isnull(fuel_type))
		fuel_type = global.using_map.default_liquid_fuel_type
	. = ..()

// Boilerplate from /obj/item/chems/glass. TODO generalize to a lower level.
/obj/item/flame/fuelled/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(get_attack_force() && !(item_flags & ITEM_FLAG_NO_BLUDGEON) && user.check_intent(I_FLAG_HARM))
		. = ..()
		if(REAGENT_TOTAL_VOLUME(reagents) && !QDELETED(target))
			target.visible_message(SPAN_DANGER("Some of the contents of \the [src] splash onto \the [target]."))
			reagents.splash(target, REAGENT_TOTAL_VOLUME(reagents))
		return TRUE
	return FALSE

/obj/item/flame/fuelled/afterattack(obj/target, mob/user, proximity)
	if(!ATOM_IS_OPEN_CONTAINER(src) || !proximity) //Is the container open & are they next to whatever they're clicking?
		return FALSE //If not, do nothing.
	if(target?.storage)
		return TRUE
	if(!lit && standard_dispenser_refill(user, target)) //Are they clicking a water tank/some dispenser?
		playsound(src.loc, 'sound/effects/refill.ogg', 50, TRUE, -6)
		return TRUE
	if(standard_pour_into(user, target)) //Pouring into another beaker?
		return TRUE
	if(handle_eaten_by_mob(user, target) != EATEN_INVALID)
		return TRUE
	if(REAGENT_TOTAL_VOLUME(reagents))
		to_chat(user, SPAN_NOTICE("You splash a small amount of the contents of \the [src] onto \the [target]."))
		reagents.splash(target, min(REAGENT_TOTAL_VOLUME(reagents), 5))
		return TRUE
	. = ..()

// End boilerplate.

/obj/item/flame/fuelled/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1 && user)

		var/decl/material/fuel_reagent = GET_DECL(fuel_type)
		if(fuel_reagent)
			. += SPAN_NOTICE("\The [src] is designed to burn [fuel_reagent.liquid_name].")

		var/max_vol = REAGENT_MAXIMUM_VOLUME(reagents)
		if(max_vol)
			switch(REAGENT_TOTAL_VOLUME(reagents) / max_vol)
				if(0 to 0.1)
					. += SPAN_WARNING("\The [src] is nearly empty.")
				if(0.1 to 0.25)
					. += SPAN_NOTICE("\The [src] is one-quarter full.")
				if(0.25 to 0.5)
					. += SPAN_NOTICE("\The [src] is half full.")
				if(0.5 to 0.75)
					. += SPAN_NOTICE("\The [src] is three-quarters full.")
				else
					. += SPAN_NOTICE("\The [src] is full.")

/obj/item/flame/fuelled/get_fuel()
	return REAGENT_VOLUME(reagents, fuel_type)

/obj/item/flame/fuelled/expend_fuel(amount)
	if(has_fuel(amount))
		reagents.remove_reagent(fuel_type, amount)
		var/decl/material/fuel = GET_DECL(fuel_type)
		if(isatom(loc))
			var/list/waste = fuel.get_burn_products(amount, lit_heat)
			if(LAZYLEN(waste))
				loc.take_waste_burn_products(waste, lit_heat)
		return TRUE
	return FALSE

/obj/item/flame/fuelled/populate_reagents()
	if(start_fuelled && fuel_type)
		var/max_vol = REAGENT_MAXIMUM_VOLUME(reagents)
		if(max_vol)
			add_to_reagents(fuel_type, max_vol)

/obj/item/flame/fuelled/Process()
	. = ..()
	if(lit && prob(10) && REAGENT_VOLUME(reagents, fuel_type) < 1)
		visible_message(SPAN_WARNING("\The [src]'s flame flickers."))
		set_light(0)
		addtimer(CALLBACK(src, TYPE_PROC_REF(.atom, set_light), 2), 4)
