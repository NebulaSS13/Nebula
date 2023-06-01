#define COAST_VALUE (cell_range + 1)

///Place down flora/fauna spawners, grass, water, and apply selected land type.
/datum/random_map/noise/exoplanet
	descriptor           = "exoplanet"
	smoothing_iterations = 1
	smooth_single_tiles  = TRUE

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

/datum/random_map/noise/exoplanet/New(var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/used_area)
	var/datum/level_data/LD = SSmapping.levels_by_z[tz]
	if(target_turf_type == null)
		target_turf_type = SSmapping.base_turf_by_z[tz] || LD.base_turf || world.turf
	water_level = rand(water_level_min,water_level_max)

	//automagically adjust probs for bigger maps to help with lag
	if(isnull(grass_prob))
		grass_prob = flora_prob * 2
	var/size_mod = intended_x / tlx * intended_y / tly
	flora_prob *= size_mod
	large_flora_prob *= size_mod
	fauna_prob *= size_mod

	var/datum/planetoid_data/P = SSmapping.planetoid_data_by_z[tz]
	if(istype(P))
		var/datum/planet_flora/floragen = P.flora
		var/datum/fauna_generator/faunagen = P.fauna

		//Prevent spawning some flora spawner type if they aren't available
		if(!length(floragen?.small_flora_types))
			flora_prob = 0
		if(!length(floragen?.big_flora_types))
			large_flora_prob = 0
		if(floragen?.plant_colors)
			plantcolors = floragen.plant_colors.Copy()
		if(!floragen)
			grass_prob = 0

		//Prevent spawning some fauna spawner types if they aren't available
		if(!length(faunagen?.megafauna_types))
			megafauna_spawn_prob = 0
		if(!length(faunagen?.fauna_types))
			fauna_prob = 0
	..()

	//#TODO: Doublec check why random maps are messing with the base turf at all??
	SSmapping.base_turf_by_z[tz] = land_type || SSmapping.base_turf_by_z[tz] || LD.base_turf || world.turf //Yes, it is necessary to be this thorough here

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
		new /obj/abstract/landmark/exoplanet_spawn/megafauna(T)
	else
		new /obj/abstract/landmark/exoplanet_spawn/animal(T)

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
		new /obj/abstract/landmark/exoplanet_spawn/large_plant(T)
		for(var/turf/neighbor in RANGE_TURFS(T, 1))
			spawn_grass(neighbor)
	else
		new /obj/abstract/landmark/exoplanet_spawn/plant(T)
		spawn_grass(T)

/datum/random_map/noise/exoplanet/proc/spawn_grass(var/turf/T)
	if(istype(T, water_type))
		return
	if(locate(/obj/effect/floor_decal) in T)
		return
	new /obj/effect/floor_decal(T, null, null, get_grass_overlay())

/datum/random_map/noise/exoplanet/cleanup()
	..()
	if(!water_type || !water_level || !coast_type)
		return
	for(var/x in 1 to limit_x - 1)
		for(var/y in 1 to limit_y - 1)
			var/mapcell = get_map_cell(x,y)
			if(noise2value(map[mapcell]) < water_level)
				var/neighbors = get_neighbors(x, y, TRUE)
				for(var/cell in neighbors)
					if(noise2value(map[cell]) >= water_level)
						map[cell] = COAST_VALUE

//////////////////////////////////////////////////////////////////////////////
// Definitions
//////////////////////////////////////////////////////////////////////////////

///Random map generator for generating underground planetary levels.
/datum/random_map/noise/exoplanet/mantle
	descriptor           = "planetary mantle"
	smoothing_iterations = 3
	land_type            = /turf/exterior/volcanic
	water_type           = /turf/exterior/lava
	water_level_min      = 4
	water_level_max      = 6
	fauna_prob           = 0
	megafauna_spawn_prob = 0
	flora_prob           = 0
	grass_prob           = 0
	large_flora_prob     = 0

//Random map generator to create rock walls underground
/datum/random_map/automata/cave_system/mantle
	descriptor       = "planetary mantle caves"
	target_turf_type = /turf/exterior/volcanic //Only let it apply to non-lava turfs
	floor_type       = null
	wall_type        = /turf/exterior/wall
