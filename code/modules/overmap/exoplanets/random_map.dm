#define  COAST_VALUE  cell_range + 1
/datum/random_map/noise/exoplanet
	descriptor = "exoplanet"
	smoothing_iterations = 1
	target_turf_type = null

	var/water_level
	var/water_level_min = 0
	var/water_level_max = 5
	var/land_type = /turf/simulated/floor
	var/water_type
	var/coast_type

	//intended x*y size, used to adjust spawn probs
	var/intended_x = 150
	var/intended_y = 150
	var/large_flora_prob = 30
	var/flora_prob = 10
	var/fauna_prob = 2
	var/grass_prob
	var/megafauna_spawn_prob = 0.5 //chance that a given fauna mob will instead be a megafauna

	var/list/plantcolors = list("RANDOM")
	var/list/grass_cache

/datum/random_map/noise/exoplanet/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0, var/used_area, var/list/_plant_colors)
	if(target_turf_type == null)
		target_turf_type = world.turf
	water_level = rand(water_level_min,water_level_max)
	//automagically adjust probs for bigger maps to help with lag
	if(isnull(grass_prob)) grass_prob = flora_prob * 2
	var/size_mod = intended_x / tlx * intended_y / tly
	flora_prob *= size_mod
	large_flora_prob *= size_mod
	fauna_prob *= size_mod
	if(_plant_colors)
		plantcolors = _plant_colors
	..()

	GLOB.using_map.base_turf_by_z[num2text(tz)] = land_type

/datum/random_map/noise/exoplanet/get_map_char(var/value)
	if(water_type && noise2value(value) < water_level)
		return "~"
	return "[noise2value(value)]"

/datum/random_map/noise/exoplanet/get_appropriate_path(var/value)
	if(water_type && noise2value(value) < water_level)
		return water_type
	else
		if(coast_type && value == COAST_VALUE)
			return coast_type
		return land_type

/datum/random_map/noise/exoplanet/get_additional_spawns(var/value, var/turf/T)
	if(T.is_wall())
		return
	var/parsed_value = noise2value(value)
	switch(parsed_value)
		if(2 to 3)
			if(prob(fauna_prob))
				spawn_fauna(T)
		if(5 to 6)
			if(grass_prob > 10 && prob(grass_prob))
				spawn_grass(T)
			if(prob(flora_prob/3))
				spawn_flora(T)
		if(7 to 9)
			if(grass_prob > 1 && prob(grass_prob * 3))
				spawn_grass(T)
			if(prob(flora_prob))
				spawn_flora(T)
			else if(prob(large_flora_prob))
				spawn_flora(T, 1)

/datum/random_map/noise/exoplanet/proc/spawn_fauna(var/turf/T)
	if(prob(megafauna_spawn_prob))
		new /obj/effect/landmark/exoplanet_spawn/megafauna(T)
	else
		new /obj/effect/landmark/exoplanet_spawn(T)

/datum/random_map/noise/exoplanet/proc/get_grass_overlay()
	var/grass_num = "[rand(1,6)]"
	if(!LAZYACCESS(grass_cache, grass_num))
		var/color = pick(plantcolors)
		if(color == "RANDOM")
			color = get_random_colour(0,75,190)
		var/image/grass = overlay_image('icons/obj/flora/greygrass.dmi', "grass_[grass_num]", color, RESET_COLOR)
		grass.underlays += overlay_image('icons/obj/flora/greygrass.dmi', "grass_[grass_num]_shadow", null, RESET_COLOR)
		LAZYSET(grass_cache, grass_num, grass)
	return grass_cache[grass_num]

/datum/random_map/noise/exoplanet/proc/spawn_flora(var/turf/T, var/big)
	if(big)
		new /obj/effect/landmark/exoplanet_spawn/large_plant(T)
		for(var/turf/neighbor in RANGE_TURFS(T, 1))
			spawn_grass(neighbor)
	else
		new /obj/effect/landmark/exoplanet_spawn/plant(T)
		spawn_grass(T)

/datum/random_map/noise/exoplanet/proc/spawn_grass(var/turf/T)
	if(istype(T, water_type))
		return
	if(locate(/obj/effect/floor_decal) in T)
		return
	new /obj/effect/floor_decal(T, null, null, get_grass_overlay())

/datum/random_map/noise/exoplanet/cleanup()
	..()
	if(!water_type && !water_level)
		return
	for(var/x in 1 to limit_x - 1)
		for(var/y in 1 to limit_y - 1)
			if(noise2value(map[get_map_cell(x,y)]) < water_level)
				smooth_water(x, y)
			else
				smooth_islands(x, y)

//Remove one-tile puddles and place coastal turfs if set
/datum/random_map/noise/exoplanet/proc/smooth_water(x, y)
	var/list/coast = list()
	var/list/water = list()
	var/mapcell = get_map_cell(x,y)
	for(var/dx in list(-1,0,1))
		for(var/dy in list(-1,0,1))
			var/tmp_cell = get_map_cell(x+dx,y+dy)
			if(tmp_cell && tmp_cell != mapcell)
				if(noise2value(map[tmp_cell]) < water_level)
					water |= tmp_cell
				else
					coast |= tmp_cell
	if(!length(water))
		map[mapcell] = cell_range
	else if (coast_type)
		for(var/cell in coast)
			map[cell] = COAST_VALUE

//Remove one-tile 'islands' in water bodies
/datum/random_map/noise/exoplanet/proc/smooth_islands(x, y)
	var/list/buddies = list()
	var/mapcell = get_map_cell(x,y)
	for(var/dx in list(-1,0,1))
		for(var/dy in list(-1,0,1))
			var/tmp_cell = get_map_cell(x+dx,y+dy)
			if(tmp_cell && tmp_cell != mapcell)
				if(noise2value(map[tmp_cell]) >= water_level)
					buddies |= tmp_cell
	if(!length(buddies))
		map[mapcell] = 0
