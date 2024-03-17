// These are foul, but apparent we can't reliably access z-level strata during
// SSmapping gen. Using /atom/movable so they don't show up in the mapper.

/obj/item/stack/material/ore/basalt
	is_spawnable_type = TRUE
	material = /decl/material/solid/stone/basalt

/obj/item/stack/material/ore/basalt/three
	amount = 3

/atom/movable/spawn_boulder
	name = "material boulder spawner"
	is_spawnable_type = FALSE
	simulated = FALSE
	var/spawn_type = /obj/structure/boulder/basalt

/atom/movable/spawn_boulder/Initialize()
	..()
	if(isturf(loc))
		if(islist(spawn_type))
			spawn_type = pickweight(spawn_type)
		if(spawn_type)
			new spawn_type(loc)
	return INITIALIZE_HINT_QDEL

/atom/movable/spawn_boulder/rock
	name = "material rock spawner"
	spawn_type = list(
		/obj/item/stack/material/ore/basalt/three,
		/obj/item/rock/basalt = 10,
		/obj/item/rock/hematite = 1
	)

/datum/random_map/noise/forage
	target_turf_type = null
	var/static/list/forage = list(
		"rocks" = list(
			/atom/movable/spawn_boulder,
			/atom/movable/spawn_boulder/rock
		),
		"caves" = list(
			"plumphelmet",
			"glowbell",
			"caverncandle",
			"weepingmoon",
			"towercap"
		),
		"shallows" = list(
			"rice",
			"mollusc",
			"clam",
			"sugarcane"
		),
		"cave_shallows" = list(
			"algae",
			"mollusc",
			"clam"
		),
		"grass" = list(
			"carrot",
			"berries",
			"potato",
			"cotton",
			"nettle",
			"ambrosiavulgaris",
			"harebells",
			"poppies",
			"sunflowers",
			"lavender",
			"garlic",
			"peppercorn",
			"bamboo",
			"coffee",
			"tea"
		),
	)
	var/list/trees = list(
		/obj/structure/flora/tree/hardwood/ebony
	)
	var/list/cave_trees = list(
		/obj/structure/flora/tree/softwood/towercap
	)

/datum/random_map/noise/forage/New()
	for(var/category in forage)
		var/list/forage_seeds = forage[category]
		for(var/forage_seed in forage_seeds)
			if(ispath(forage_seed))
				continue
			forage_seeds -= forage_seed
			if(!SSplants.seeds[forage_seed])
				log_error("Invalid seed name: [forage_seed]")
			else
				forage_seeds += SSplants.seeds[forage_seed]
	return ..()

/datum/random_map/noise/forage/get_appropriate_path(value)
	return

/datum/random_map/noise/forage/get_additional_spawns(value, turf/T)
	var/parse_value = noise2value(value)
	var/place_prob
	var/place_type

	if(T.is_outside())
		if(istype(T, /turf/exterior/rock))
			if(prob(15)) // Static as current map has limited amount of rock turfs
				var/rock_type = pick(forage["rocks"])
				new rock_type(T)
				return
		else if(istype(T, /turf/exterior/wildgrass))
			if(prob(parse_value * 0.35))
				var/tree_type = pick(trees)
				new tree_type(T)
				return
			place_prob = parse_value * 0.3
			place_type = pick(forage["grass"])
		else if(istype(T, /turf/exterior/mud/water))
			place_prob = parse_value * 0.3
			place_type = pick(forage["shallows"])
	else
		if(istype(T, /turf/exterior/mud) && !istype(T, /turf/exterior/mud/water/deep))
			if(prob(parse_value * 0.35))
				var/tree_type = pick(cave_trees)
				new tree_type(T)
				return
			place_prob = parse_value * 0.6
			place_type = pick(forage["caves"])
		else if(istype(T, /turf/exterior/dirt))
			place_prob = parse_value * 0.3
			place_type = pick(forage["caves"])
		else if(istype(T, /turf/exterior/mud/water))
			place_prob = parse_value * 0.3
			place_type = pick(forage["cave_shallows"])

	if(place_type && prob(place_prob))
		new /obj/structure/flora/plant(T, null, null, place_type)
		for(var/stepdir in global.alldirs)
			if(prob(15))
				var/turf/neighbor = get_step(T, stepdir)
				if(istype(neighbor, T.type) && !(locate(/obj/structure/flora/plant) in neighbor))
					new /obj/structure/flora/plant(neighbor, null, null, place_type)
