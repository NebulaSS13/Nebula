/datum/exoplanet_theme/robotic_guardians
	name = "Robotic Guardians"
	var/list/guardian_types = list(
		/mob/living/simple_animal/hostile/hivebot,
		/mob/living/simple_animal/hostile/hivebot/range,
		/mob/living/simple_animal/hostile/viscerator/hive
	)
	var/list/mega_guardian_types = list(
		/mob/living/simple_animal/hostile/hivebot/mega
	)

/datum/exoplanet_theme/robotic_guardians/modify_ruin_whitelist(whitelist_flags)
	return whitelist_flags | RUIN_ALIEN

/datum/exoplanet_theme/robotic_guardians/get_extra_fauna()
	return guardian_types

/datum/exoplanet_theme/robotic_guardians/get_extra_megafauna()
	return mega_guardian_types

/datum/exoplanet_theme/robotic_guardians/adapt_animal(datum/planetoid_data/E, mob/A)
	// Stopping robots from fighting each other
	if(is_type_in_list(A, guardian_types | mega_guardian_types))
		A.faction = "Ancient Guardian"

/datum/exoplanet_theme/robotic_guardians/get_sensor_data()
	return "Movement without corresponding lifesigns detected on the surface."