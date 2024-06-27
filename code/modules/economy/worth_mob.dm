/mob/get_single_monetary_worth()
	. = 0.5 * mob_size
	if(stat != DEAD)
		. *= 1.5
	. = max(round(.), mob_size)

/mob/living/get_single_monetary_worth()
	. = ..()
	for(var/atom/movable/organ in get_organs())
		. += organ.get_combined_monetary_worth()
	if(butchery_data)
		var/decl/butchery_data/butchery_decl = GET_DECL(butchery_data)
		. += butchery_decl.get_monetary_worth(src)
	. = round(.)

/mob/living/get_value_multiplier()
	var/decl/species/my_species = get_species()
	. = my_species ? my_species.rarity_value : 1
