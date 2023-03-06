/datum/exoplanet_theme/mountains
	name = "Mountains"
	var/rock_color

/datum/exoplanet_theme/mountains/get_map_generators(datum/planetoid_data/E)
	return list(/datum/random_map/automata/cave_system/mountains)

/datum/exoplanet_theme/mountains/get_planet_image_extra()
	var/image/res = image('icons/skybox/planet.dmi', "mountains")
	res.color = rock_color
	return res

/datum/random_map/automata/cave_system/mountains
	iterations = 2
	descriptor = "space mountains"
	wall_type =  /turf/exterior/wall
	cell_threshold = 6
	target_turf_type = null
	floor_type = null
	var/rock_color

/datum/random_map/automata/cave_system/mountains/New(var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/used_area)
	if(!rock_color)
		var/datum/planetoid_data/P = SSmapping.planetoid_data_by_z[tz]
		rock_color = P?.get_rock_color()
	var/datum/level_data/LD = SSmapping.levels_by_z[tz]
	if(target_turf_type == null)
		target_turf_type = SSmapping.base_turf_by_z[tz] || LD.base_turf || world.turf
	if(floor_type == null)
		floor_type = SSmapping.base_turf_by_z[tz] || LD.base_turf || world.turf
	..()

/datum/random_map/automata/cave_system/mountains/get_additional_spawns(value, var/turf/exterior/wall/T)
	if(istype(T))
		T.paint_color = rock_color
		T.queue_icon_update()
		if(use_area)
			T.floor_type = use_area.base_turf
