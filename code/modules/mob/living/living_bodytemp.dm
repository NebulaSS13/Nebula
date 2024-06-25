/mob/living/proc/has_metabolic_thermoregulation()
	if(isSynthetic())
		return FALSE
	var/decl/species/my_species = get_species()
	if(my_species?.body_temperature == null)
		return FALSE
	return TRUE

/mob/living/proc/get_bodytemperature_difference()
	var/decl/species/my_species = get_species()
	if(my_species)
		return (my_species.body_temperature - bodytemperature)
	return 0

/mob/living/proc/stabilize_body_temperature()

	// This species doesn't have metabolic thermoregulation and can't adjust towards a baseline.
	if(!has_metabolic_thermoregulation())
		return

	// We may produce heat naturally.
	var/decl/species/my_species = get_species()
	if(my_species?.passive_temp_gain)
		bodytemperature += my_species.passive_temp_gain

	var/body_temperature_difference = get_bodytemperature_difference()
	if (abs(body_temperature_difference) < 0.5)
		return //fuck this precision

	var/cold_1 = get_mob_temperature_threshold(COLD_LEVEL_1)
	var/heat_1 = get_mob_temperature_threshold(HEAT_LEVEL_1)
	if(bodytemperature < cold_1) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
		var/nut_remove = 10 * DEFAULT_HUNGER_FACTOR
		if(get_nutrition() >= nut_remove) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
			adjust_nutrition(-nut_remove)
			bodytemperature += max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
	else if(cold_1 <= bodytemperature && bodytemperature <= heat_1)
		bodytemperature += body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
	else if(bodytemperature > heat_1) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
		var/hyd_remove = 10 * DEFAULT_THIRST_FACTOR
		if(get_hydration() >= hyd_remove)
			adjust_hydration(-hyd_remove)
			bodytemperature += min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)

/// This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, SLOT_UPPER_BODY, SLOT_LOWER_BODY, etc.
/// Temperature parameter is the temperature you're being exposed to.
/mob/living/proc/get_heat_protection_flags(temperature)
	return 0
