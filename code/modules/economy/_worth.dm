/atom/proc/get_base_value()
	. = 1

/atom/proc/get_value_multiplier()
	. = 1

/atom/proc/get_single_monetary_worth()
	. = get_base_value() * get_value_multiplier()
	if(reagents)
		for(var/a in reagents.reagent_volumes)
			var/decl/reagent/reg = decls_repository.get_decl(a)
			. += reg.get_value() * REAGENT_VOLUME(reagents, a)

/atom/proc/get_contents_monetary_worth()
	. = 0
	for(var/atom/movable/thing in contents)
		. += thing.get_combined_monetary_worth()

/atom/proc/get_combined_monetary_worth()
	. = max(1, get_single_monetary_worth() + get_contents_monetary_worth())