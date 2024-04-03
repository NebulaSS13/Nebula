/obj/item/flame/fuelled

	abstract_type         = /obj/item/flame/fuelled
	_fuel_spend_amt       = 0.05
	can_manually_light    = TRUE
	extinguish_on_dropped = FALSE

	var/tmp/max_fuel      = 5
	var/tmp/start_fuelled = FALSE
	var/fuel_type         = /decl/material/liquid/fuel

/obj/item/flame/fuelled/Initialize()
	. = ..()
	initialize_reagents()

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
	if(start_fuelled)
		add_to_reagents(fuel_type, max_fuel)

/obj/item/flame/fuelled/Process()
	. = ..()
	if(lit && prob(10) && REAGENT_VOLUME(reagents, fuel_type) < 1)
		visible_message(SPAN_WARNING("\The [src]'s flame flickers."))
		set_light(0)
		addtimer(CALLBACK(src, TYPE_PROC_REF(.atom, set_light), 2), 4)
