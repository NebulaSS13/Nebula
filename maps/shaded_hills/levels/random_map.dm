/datum/random_map/automata/cave_system/shaded_hills
	descriptor          = "Shaded Hills caves"
	floor_type          = /turf/exterior/rock/basalt
	wall_type           = /turf/wall/natural/basalt/shaded_hills
	sparse_mineral_turf = /turf/wall/natural/random/basalt/shaded_hills
	rich_mineral_turf   = /turf/wall/natural/random/high_chance/basalt/shaded_hills

/datum/random_map/noise/shaded_hills
	abstract_type = /datum/random_map/noise/shaded_hills
	smoothing_iterations = 1
	smooth_single_tiles  = TRUE
	target_turf_type = /turf/unsimulated/mask

/datum/random_map/noise/shaded_hills/swamp
	descriptor           = "Shaded Hills swamp"

/datum/random_map/noise/shaded_hills/swamp/get_appropriate_path(var/value)
	value = noise2value(value)
	if(value <= 3)
		return /turf/exterior/mud/water/deep
	if(value <= 5)
		return /turf/exterior/mud/water
	if(value <= 7)
		return /turf/exterior/mud
	return /turf/exterior/grass

/datum/random_map/noise/shaded_hills/woods
	descriptor = "Shaded Hills Woods"

/datum/random_map/noise/shaded_hills/woods/get_appropriate_path(var/value)
	value = noise2value(value)
	if(value <= 6)
		return /turf/exterior/grass/wild
	return /turf/exterior/grass

/datum/random_map/noise/shaded_hills_woods/get_additional_spawns(var/value, var/turf/T)
	if(T.density || (locate(/obj/structure) in T))
		return
	value = noise2value(value)
	if(value <= 5)
		if(prob(75))
			new /obj/structure/flora/tree/hardwood/ebony
		else
			new /obj/structure/flora/tree/dead/ebony
	else if(value <= 7)
		if(prob(50))
			new /obj/structure/flora/tree/hardwood/ebony
		else if(prob(25))
			new /obj/structure/flora/tree/dead/ebony
	else
		if(prob(10))
			new /obj/structure/flora/tree/hardwood/ebony
		else if(prob(5))
			new /obj/structure/flora/tree/dead/ebony

// TODO
/datum/random_map/noise/forage/shaded_hills
	abstract_type = /datum/random_map/noise/forage/shaded_hills

/datum/random_map/noise/forage/shaded_hills/grassland

/datum/random_map/noise/forage/shaded_hills/swamp

/datum/random_map/noise/forage/shaded_hills/woods
