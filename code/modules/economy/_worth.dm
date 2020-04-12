/atom/proc/get_base_value()
	. = 1

/atom/proc/get_value_multiplier()
	. = 1

/atom/proc/get_single_monetary_worth()
	return get_base_value() * get_value_multiplier()

/atom/proc/get_combined_monetary_worth()
	. = get_single_monetary_worth()
	if(reagents)
		for(var/a in reagents.reagent_list)
			var/datum/reagent/reg = a
			. += reg.get_value() 
	for(var/atom/movable/a in contents)
		. += a.get_single_monetary_worth()

// Temp workaround for null/zero vendor/trader prices.
/atom/movable/get_combined_monetary_worth()
	. = max(1, ..())
