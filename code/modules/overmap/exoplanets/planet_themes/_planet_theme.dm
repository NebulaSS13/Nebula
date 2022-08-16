/datum/exoplanet_theme
	var/name = "Nothing Special"

// Called by exoplanet datum before applying its map generators
/datum/exoplanet_theme/proc/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)

// Called by exoplanet datum after applying its map generators and spawning ruins
/datum/exoplanet_theme/proc/after_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)

/datum/exoplanet_theme/proc/get_planet_image_extra()

/datum/exoplanet_theme/proc/get_sensor_data()

/datum/exoplanet_theme/proc/adapt_animal(obj/effect/overmap/visitable/sector/exoplanet/E, mob/A)

/datum/exoplanet_theme/proc/modify_temperature(var/temperature)
	return temperature
