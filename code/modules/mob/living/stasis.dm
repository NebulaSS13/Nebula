/mob/living/proc/set_stasis(var/factor, var/source = "misc")
	var/decl/bodytype/my_bodytype = get_bodytype()
	if(my_bodytype?.body_flags & BODY_FLAG_NO_STASIS)
		return
	LAZYSET(stasis_sources, source, factor)

/mob/living/proc/is_in_stasis()
	return stasis_value ? !!(life_tick % stasis_value) : FALSE

/mob/living/proc/handle_stasis()
	stasis_value = 0
	if(stasis_sources)
		var/decl/bodytype/my_bodytype = get_bodytype()
		if(!(my_bodytype?.body_flags & BODY_FLAG_NO_STASIS))
			for(var/source in stasis_sources)
				stasis_value += stasis_sources[source]
		stasis_sources = null

	if(stasis_value > 1 && GET_STATUS(src, STAT_DROWSY) < stasis_value * 4)
		ADJ_STATUS(src, STAT_DROWSY, min(stasis_value, 3))
		if(stat == CONSCIOUS && prob(1))
			to_chat(src, SPAN_NOTICE("You feel slow and sluggish..."))

/mob/living/proc/get_cryogenic_factor(var/bodytemperature)

	if(isSynthetic())
		return 0

	var/cold_1 = get_mob_temperature_threshold(COLD_LEVEL_1)
	var/cold_2 = get_mob_temperature_threshold(COLD_LEVEL_2)
	var/cold_3 = get_mob_temperature_threshold(COLD_LEVEL_3)

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
