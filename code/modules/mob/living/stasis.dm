/mob/living/proc/set_stasis(var/factor, var/source = "misc")
	var/decl/species/my_species = get_species()
	if(!(my_species?.species_flags & SPECIES_FLAG_NO_SCAN) && !isSynthetic())
		LAZYSET(stasis_sources, source, factor)

/mob/living/proc/is_in_stasis()
	if(stasis_value)
		return life_tick % stasis_value
	return FALSE

// call only once per run of life
/mob/living/proc/update_stasis()
	stasis_value = 0
	if(LAZYLEN(stasis_sources))
		var/decl/species/my_species = get_species()
		if(!(my_species?.species_flags & SPECIES_FLAG_NO_SCAN) && !isSynthetic())
			for(var/source in stasis_sources)
				stasis_value += stasis_sources[source]
		LAZYCLEARLIST(stasis_sources)
