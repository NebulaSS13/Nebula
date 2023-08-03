/atom
	var/monetary_worth_multiplier = 1

/atom/proc/get_base_value()
	. = 0

/atom/proc/get_single_monetary_worth()
	. = get_base_value()
	if(reagents)
		for(var/a in reagents.reagent_volumes)
			var/decl/material/reg = GET_DECL(a)
			. += reg.get_value() * REAGENT_VOLUME(reagents, a) * REAGENT_WORTH_MULTIPLIER
	. = max(0, round(.))

/atom/proc/get_contents_monetary_worth()
	. = 0
	for(var/atom/movable/thing in contents)
		. += thing.get_combined_monetary_worth()

/atom/proc/get_combined_monetary_worth()
	. = max(0, round(get_single_monetary_worth() + get_contents_monetary_worth()))