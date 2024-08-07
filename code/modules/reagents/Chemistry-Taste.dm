/* what this does:
catalogue the 'taste strength' of each one
calculate text size per text.
*/
/datum/reagents/proc/generate_taste_message(mob/living/taster, datum/reagents/source_holder)

	if(!istype(taster))
		return

	var/minimum_percent
	if(taster.isSynthetic())
		minimum_percent = TASTE_DULL
	else
		var/decl/species/my_species = istype(taster) && taster?.get_species()
		if(my_species)
			// the taste bonus makes it so that sipping a drink lets you taste it better
			// 1u makes it 2x as strong, 2u makes it 1.5x, 5u makes it 1.2x, etc
			minimum_percent = (my_species.taste_sensitivity * clamp(1 + (1/max(total_volume, 1)), 1, 2))
		else
			minimum_percent = TASTE_NORMAL
	minimum_percent = round(TASTE_DEGREE_PROB/minimum_percent)

	if(minimum_percent > 100)
		return

	var/list/tastes = get_taste_list(source_holder) //descriptor = strength
	var/total_taste = 0
	for(var/taste in tastes)
		total_taste += tastes[taste]

	//deal with percentages
	for(var/taste in tastes)
		var/percent = tastes[taste]/total_taste * 100
		if(percent < minimum_percent)
			continue
		var/intensity_desc = "a hint of"
		if(percent > minimum_percent * 2 || percent == 100)
			intensity_desc = ""
		else if(percent > minimum_percent * 3)
			intensity_desc = "the strong flavor of"
		if(intensity_desc == "")
			LAZYADD(., "[taste]")
		else
			LAZYADD(., "[intensity_desc] [taste]")

	if(length(.))
		. = english_list(., "something indescribable")

/datum/reagents/proc/get_taste_list(datum/reagents/source_holder)
	var/list/tastes = list() //descriptor = strength
	for(var/reagent_type in reagent_volumes)
		var/decl/material/reagent = GET_DECL(reagent_type)
		var/list/nutriment_data = LAZYACCESS(reagent_data, reagent_type)
		var/list/taste_data = LAZYACCESS(nutriment_data, "taste")
		if(length(taste_data))
			for(var/taste in taste_data)
				var/taste_power = taste_data[taste]
				tastes[taste]  += taste_power
		else if(reagent.taste_description)
			tastes[reagent.taste_description] += reagent.taste_mult

	var/decl/material/primary_ingredient = get_primary_reagent_decl()
	if(primary_ingredient?.cocktail_ingredient && source_holder?.my_atom)
		for(var/decl/cocktail/cocktail in SSmaterials.get_cocktails_by_primary_ingredient(primary_ingredient.type))
			if(!LAZYLEN(cocktail.tastes))
				continue
			if(!cocktail.matches(source_holder.my_atom))
				continue
			var/cocktail_volume = 0
			for(var/chem in cocktail.ratios)
				cocktail_volume += REAGENT_VOLUME(src, chem)
			for(var/taste_desc in cocktail.tastes)
				var/taste_power     = cocktail.tastes[taste_desc] * cocktail_volume
				tastes[taste_desc] += taste_power
	return tastes