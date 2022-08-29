/atom
	var/monetary_worth_multiplier = 1

/atom/proc/get_base_value()
	. = 1

/atom/proc/get_value_multiplier()
	. = monetary_worth_multiplier

/atom/proc/get_single_monetary_worth()
	. = get_base_value() * get_value_multiplier()
	if(reagents)
		for(var/decl/material/R as anything in reagents.reagent_volumes)
			. += R.get_value() * REAGENT_VOLUME(reagents, R) * REAGENT_WORTH_MULTIPLIER
	. = max(0, round(.))

/atom/proc/get_contents_monetary_worth()
	. = 0
	for(var/atom/movable/thing in get_contained_external_atoms())
		. += thing.get_combined_monetary_worth()

/atom/proc/get_combined_monetary_worth()
	. = max(0, round(get_single_monetary_worth() + get_contents_monetary_worth()))