/datum/random_map/automata/cave_system/shaded_hills
	descriptor          = "Shaded Hills caves"
	floor_type          = /turf/floor/natural/rock/basalt
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
		return /turf/floor/natural/mud/water/deep
	if(value <= 5)
		return /turf/floor/natural/mud/water
	if(value <= 7)
		return /turf/floor/natural/mud
	return /turf/floor/natural/grass

/datum/random_map/noise/shaded_hills/woods
	descriptor = "Shaded Hills Woods"

/datum/random_map/noise/shaded_hills/woods/get_appropriate_path(var/value)
	value = noise2value(value)
	if(value <= 6)
		return /turf/floor/natural/grass/wild
	return /turf/floor/natural/grass

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

/datum/random_map/noise/forage/shaded_hills/grassland/New()
	forage["grass"] |= list(
		"yarrow",
		"valerian"
	)
	..()

/datum/random_map/noise/forage/shaded_hills/swamp
	tree_weight = 4
	trees = list(
		/obj/structure/flora/tree/hardwood/ebony = 1,
		/obj/structure/flora/tree/dead/ebony = 2,
		/obj/structure/flora/bush = 4,
		/obj/structure/flora/bush/leafybush = 5,
		/obj/structure/flora/bush/grassybush = 5,
		/obj/structure/flora/bush/stalkybush = 5,
		/obj/structure/flora/bush/reedbush = 6,
		/obj/structure/flora/bush/fernybush = 6,
	)

/datum/random_map/noise/forage/shaded_hills/swamp/New()
	forage["grass"] |= list(
		"aloe",
		"foxglove"
	)
	forage["riverbed"] = list(
		// the swamp doesn't really have enough flowing water for molluscs to live here or for flint to wash up
		"algae"
	)
	forage["riverbank"] = list(
		"harebells",
		"lavender",
		"nettle",
		"algae",
		"mushrooms"
	)
	return ..()

/datum/random_map/noise/forage/shaded_hills/woods
	tree_weight = 7
	trees = list(
		/obj/structure/flora/tree/hardwood/yew = 8,
		/obj/structure/flora/tree/hardwood/mahogany = 8,
		/obj/structure/flora/bush/pointybush = 5,
		/obj/structure/flora/tree/dead/yew = 1,
		/obj/structure/flora/tree/dead/mahogany = 1,
		/obj/structure/flora/bush/genericbush = 1,
		/obj/structure/flora/bush/grassybush = 1,
		/obj/structure/flora/bush/stalkybush = 1,
		/obj/structure/flora/bush/reedbush = 1,
		/obj/structure/flora/bush/fernybush = 1,
	)

/datum/random_map/noise/forage/shaded_hills/woods/New()
	forage["grass"] |= list(
		"ginseng",
		"foxglove"
	)
	..()
