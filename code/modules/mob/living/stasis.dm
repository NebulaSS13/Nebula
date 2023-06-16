/mob/living/proc/set_stasis(var/factor, var/source = "misc")
	var/decl/species/my_species = get_species()
	if((my_species?.species_flags & SPECIES_FLAG_NO_SCAN) || isSynthetic())
		return
	LAZYSET(stasis_sources, source, factor)

/mob/living/proc/is_in_stasis()
	return stasis_value ? !!(life_tick % stasis_value) : FALSE

/mob/living/proc/handle_stasis()
	stasis_value = 0
	if(stasis_sources)
		var/decl/species/my_species = get_species()
		if(!(my_species?.species_flags & SPECIES_FLAG_NO_SCAN) && !isSynthetic())
			for(var/source in stasis_sources)
				stasis_value += stasis_sources[source]
		stasis_sources = null

/mob/living/proc/get_cryogenic_factor(var/bodytemperature)

	if(isSynthetic())
		return 0

	var/decl/species/my_species = get_species()
	var/cold_1 = my_species ? my_species.cold_level_1 : 243
	var/cold_2 = my_species ? my_species.cold_level_2 : 200
	var/cold_3 = my_species ? my_species.cold_level_3 : 120

	if(bodytemperature > cold_1)
		return 0
	if(bodytemperature > cold_2)
		. = 5 * (1 - (bodytemperature - cold_2) / (cold_1 - cold_2))
		. = max(2, .)
	else if(bodytemperature > cold_3)
		. = 20 * (1 - (bodytemperature - cold_3) / (cold_2 - cold_3))
		. = max(5, .)
	else
		. = 80 * (1 - bodytemperature / cold_3)
		. = max(20, .)
	return round(.)
