/atom/proc/get_base_monetary_worth()
	. = 1

/atom/proc/get_base_worth_multiplier()
	. = 1

/atom/proc/get_combined_monetary_worth()
	. = get_base_monetary_worth() * get_base_worth_multiplier()
	if(reagents)
		for(var/a in reagents.reagent_list)
			var/datum/reagent/reg = a
			. += reg.get_value() 
	for(var/atom/movable/a in contents)
		. += a.get_combined_monetary_worth()

// Temp workaround for null/zero vendor/trader prices.
/atom/movable/get_combined_monetary_worth()
	. = max(1, ..())
