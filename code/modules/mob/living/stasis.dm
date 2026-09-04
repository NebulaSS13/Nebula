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
