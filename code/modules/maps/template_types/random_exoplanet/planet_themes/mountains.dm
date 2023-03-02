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

/datum/random_map/automata/cave_system/mountains/New(var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/used_area, var/_rock_color)
	if(_rock_color)
		rock_color = _rock_color
	if(target_turf_type == null)
		target_turf_type = SSmapping.base_turf_by_z[tz] || world.turf
	if(floor_type == null)
		floor_type = SSmapping.base_turf_by_z[tz] || world.turf
	..()

/datum/random_map/automata/cave_system/mountains/get_additional_spawns(value, var/turf/exterior/wall/T)
	if(istype(T))
		T.paint_color = rock_color
		T.queue_icon_update()
		if(use_area)
			T.floor_type = use_area.base_turf
