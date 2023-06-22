/datum/exoplanet_theme
	var/name = "Nothing Special"

/datum/exoplanet_theme/proc/get_map_generators(var/datum/planetoid_data/E)

// Called by exoplanet datum before applying its map generators
/datum/exoplanet_theme/proc/before_map_generation(var/datum/planetoid_data/E)

// Called by exoplanet datum after applying its map generators and spawning ruins
/datum/exoplanet_theme/proc/after_map_generation(var/datum/planetoid_data/E)

/datum/exoplanet_theme/proc/adjust_atmosphere(var/datum/planetoid_data/E)

/datum/exoplanet_theme/proc/get_planet_image_extra(var/datum/planetoid_data/E)

/datum/exoplanet_theme/proc/get_sensor_data()

/datum/exoplanet_theme/proc/adapt_animal(var/datum/planetoid_data/E, var/mob/A)

/datum/exoplanet_theme/proc/modify_ruin_whitelist(var/whitelist_flags)

/datum/exoplanet_theme/proc/modify_ruin_blacklist(var/blacklist_flags)

/datum/exoplanet_theme/proc/get_extra_fauna()

/datum/exoplanet_theme/proc/get_extra_megafauna()