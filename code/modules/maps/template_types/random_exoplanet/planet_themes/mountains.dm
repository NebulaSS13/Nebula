/datum/exoplanet_theme/mountains
	name = "Mountains"

/datum/exoplanet_theme/mountains/get_map_generators(datum/planetoid_data/E)
	return list(/datum/random_map/automata/cave_system/mountains)

/datum/exoplanet_theme/mountains/get_planet_image_extra(datum/planetoid_data/E)
	var/image/res = image('icons/skybox/planet.dmi', "mountains")
	res.color = E.get_rock_color()
	return res

/datum/random_map/automata/cave_system/mountains
	iterations = 2
	descriptor = "space mountains"
	wall_type =  /turf/exterior/wall
	cell_threshold = 6
	target_turf_type = null
	floor_type = null

/datum/random_map/automata/cave_system/mountains/New(var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/used_area)
	var/datum/level_data/LD = SSmapping.levels_by_z[tz]
	if(target_turf_type == null)
		target_turf_type = SSmapping.base_turf_by_z[tz] || LD.base_turf || world.turf
	if(floor_type == null)
		floor_type = SSmapping.base_turf_by_z[tz] || LD.base_turf || world.turf
	..()

/datum/random_map/automata/cave_system/mountains/get_additional_spawns(value, var/turf/exterior/wall/T)
	if(istype(T) && use_area)
		T.floor_type = use_area.base_turf
