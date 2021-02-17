/atom
	var/monetary_worth_multiplier = 1

/atom/proc/get_base_value()
	. = 1

/atom/proc/get_value_multiplier()
	. = monetary_worth_multiplier

/atom/proc/get_single_monetary_worth()
	. = get_base_value() * get_value_multiplier()
	if(reagents)
		for(var/a in reagents.reagent_volumes)
			var/decl/material/reg = GET_DECL(a)
			. += reg.get_value() * REAGENT_VOLUME(reagents, a) * REAGENT_WORTH_MULTIPLIER

/atom/proc/get_contents_monetary_worth()
	. = 0
	for(var/atom/movable/thing in contents)
		. += thing.get_combined_monetary_worth()

/atom/proc/get_combined_monetary_worth()
	. = max(1, get_single_monetary_worth() + get_contents_monetary_worth())
