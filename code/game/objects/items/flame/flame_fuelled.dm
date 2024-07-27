/obj/item/flame/fuelled

	abstract_type         = /obj/item/flame/fuelled
	_fuel_spend_amt       = 0.05
	can_manually_light    = TRUE
	extinguish_on_dropped = FALSE

	var/tmp/max_fuel      = 5
	var/tmp/start_fuelled = FALSE

	/// TODO: make this calculate a fuel amount via accelerant value or some other check.
	/// Reagent type to burn as fuel. If null, will use the map default.
	var/fuel_type

/obj/item/flame/fuelled/Initialize()
	. = ..()
	if(isnull(fuel_type))
		fuel_type = global.using_map.default_liquid_fuel_type
	initialize_reagents()

// Boilerplate from /obj/item/chems/glass. TODO generalize to a lower level.
/obj/item/flame/fuelled/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(force && !(item_flags & ITEM_FLAG_NO_BLUDGEON) && user.a_intent == I_HURT)
		. = ..()
		if(reagents?.total_volume && !QDELETED(target))
			target.visible_message(SPAN_DANGER("Some of the contents of \the [src] splash onto \the [target]."))
			reagents.splash(target, reagents.total_volume)
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
	if(reagents?.total_volume)
		to_chat(user, SPAN_NOTICE("You splash a small amount of the contents of \the [src] onto \the [target]."))
		reagents.splash(target, min(reagents.total_volume, 5))
		return TRUE
	. = ..()

// End boilerplate.

/obj/item/flame/fuelled/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && user)

		var/decl/material/fuel_reagent = GET_DECL(fuel_type)
		if(fuel_reagent)
			to_chat(user, SPAN_NOTICE("\The [src] is designed to burn [fuel_reagent.liquid_name]."))

		if(reagents?.maximum_volume)
			switch(reagents.total_volume / reagents.maximum_volume)
				if(0 to 0.1)
					to_chat(user, SPAN_WARNING("\The [src] is nearly empty."))
				if(0.1 to 0.25)
					to_chat(user, SPAN_NOTICE("\The [src] is one-quarter full."))
				if(0.25 to 0.5)
					to_chat(user, SPAN_NOTICE("\The [src] is half full."))
				if(0.5 to 0.75)
					to_chat(user, SPAN_NOTICE("\The [src] is three-quarters full."))
				else
					to_chat(user, SPAN_NOTICE("\The [src] is full."))

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

/obj/item/flame/fuelled/initialize_reagents(populate = TRUE)
	if(!reagents)
		create_reagents(max_fuel)
	. = ..()

/obj/item/flame/fuelled/populate_reagents()
	if(start_fuelled && fuel_type && max_fuel)
		add_to_reagents(fuel_type, max_fuel)

/obj/item/flame/fuelled/Process()
	. = ..()
	if(lit && prob(10) && REAGENT_VOLUME(reagents, fuel_type) < 1)
		visible_message(SPAN_WARNING("\The [src]'s flame flickers."))
		set_light(0)
		addtimer(CALLBACK(src, TYPE_PROC_REF(.atom, set_light), 2), 4)
