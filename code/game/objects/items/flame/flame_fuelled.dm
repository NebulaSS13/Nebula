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

/obj/item/flame/fuelled/afterattack(obj/target, mob/user, proximity)
	if(proximity && !lit && standard_dispenser_refill(user, target)) // To be able to refill lanterns and lighters from reagent dispensers.
		playsound(src.loc, 'sound/effects/refill.ogg', 50, TRUE, -6)
		return TRUE
	return ..()