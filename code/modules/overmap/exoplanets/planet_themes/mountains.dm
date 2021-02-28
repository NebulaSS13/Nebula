/datum/exoplanet_theme/mountains
	name = "Mountains"
	var/rock_color

/datum/exoplanet_theme/mountains/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	rock_color = pick(E.rock_colors)
	for(var/zlevel in E.map_z)
		new /datum/random_map/automata/cave_system/mountains(null,E.x_origin,E.y_origin,zlevel,E.x_origin+E.x_size,E.x_origin+E.y_size,0,1,1, E.planetary_area, rock_color)

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

/datum/random_map/automata/cave_system/mountains/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0, var/used_area, var/_rock_color)
	if(_rock_color)
		rock_color = _rock_color
	if(target_turf_type == null)
		target_turf_type = world.turf
	if(floor_type == null)
		floor_type = world.turf
	..()

/datum/random_map/automata/cave_system/mountains/get_additional_spawns(value, var/turf/exterior/wall/T)
	if(istype(T))
		T.paint_color = rock_color
		T.queue_icon_update()
		if(use_area)
			T.floor_type = use_area.base_turf
