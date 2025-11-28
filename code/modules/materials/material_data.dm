/decl/material/proc/initialize_data(list/newdata) // Called when the reagent is first added to a reagents datum.
	. = newdata
	if(allergen_flags)
		LAZYINITLIST(.)
		.[DATA_INGREDIENT_FLAGS] |= allergen_flags

/decl/material/proc/mix_data(var/datum/reagents/reagents, var/list/newdata, var/amount)

	if(!istype(reagents))
		return

	UNLINT(reagents.cached_color = null) // colour masking may change

	. = REAGENT_DATA(reagents, src)
	if(!length(newdata) || !islist(newdata))
		return

	// Blend in any allergen flags.
	var/new_allergens = newdata[DATA_INGREDIENT_FLAGS]
	if(new_allergens)
		LAZYINITLIST(.)
		.[DATA_INGREDIENT_FLAGS] |= new_allergens

	// Sum our existing taste data with the incoming taste data.
	var/total_taste = 0
	var/new_fraction = amount / REAGENT_VOLUME(reagents, src) // the fraction of the total reagent volume that the new data is associated with
	var/list/tastes = list()
	var/list/newtastes = LAZYACCESS(newdata, DATA_TASTE)
	for(var/taste in newtastes)
		var/newtaste   = newtastes[taste] * new_fraction
		tastes[taste] += newtaste
		total_taste   += newtaste

	// If we have an old taste list, keep it, but if we don't, generate
	// one to hold our base taste information. This is so pouring nutriment
	// with a taste list into honey for example won't completely mask the
	// taste of honey.
	var/list/oldtastes = LAZYACCESS(., DATA_TASTE)
	var/old_fraction = 1 - new_fraction
	if(length(oldtastes))
		for(var/taste in oldtastes)
			var/oldtaste   = oldtastes[taste] * old_fraction
			tastes[taste] += oldtaste
			total_taste   += oldtaste
	else if(length(tastes) && taste_description) // only add it to the list if we already have other tastes
		tastes[taste_description] += taste_mult * old_fraction
		total_taste               += taste_mult * old_fraction

	// Cull all tastes below 10% of total
	if(length(tastes))
		if(total_taste)
			for(var/taste in tastes)
				if((tastes[taste] / total_taste) < 0.1)
					tastes -= taste
		if(length(tastes))
			LAZYSET(., DATA_TASTE, tastes)

	// Blend our extra_colour...
	var/new_extra_color = newdata?[DATA_EXTRA_COLOR]
	if(new_extra_color)
		.[DATA_EXTRA_COLOR] = BlendHSV(new_extra_color, .[DATA_EXTRA_COLOR], new_fraction)