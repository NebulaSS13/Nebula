// These are foul, but apparent we can't reliably access z-level strata during
// SSmapping gen. Using /atom/movable so they don't show up in the mapper.

/obj/item/stack/material/ore/basalt
	is_spawnable_type = TRUE
	material = /decl/material/solid/stone/basalt

/obj/item/stack/material/ore/basalt/three
	amount = 3

/obj/item/stack/material/ore/basalt/ten
	amount = 10

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
	var/list/forage = list(
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
			/obj/item/rock/flint,
			"rice",
			"mollusc",
			"clam",
			"sugarcane"
		),
		"cave_shallows" = list(
			/obj/item/rock/flint,
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
		"riverbed" = list(
			/obj/item/rock/flint,
			// no rice, generally rice wants at most 10cm water
			"mollusc",
			"clam"
		)
	)
	var/list/trees = list(
		/obj/structure/flora/tree/hardwood/walnut = 9,
		/obj/structure/flora/tree/dead/walnut = 1,
		/obj/structure/flora/tree/hardwood/ebony = 1,
		/obj/structure/flora/tree/dead/ebony = 1,
	)
	var/list/cave_trees = list(
		/obj/structure/flora/tree/softwood/towercap
	)
	var/tree_weight = 0.35
	var/cave_tree_weight = 0.35
	var/forage_weight = 0.3
	var/cave_forage_weight = 0.3

/datum/random_map/noise/forage/New()
	for(var/category in forage)
		var/list/forage_seeds = forage[category]
		for(var/forage_seed in forage_seeds)
			if(ispath(forage_seed) || istype(forage_seed, /datum/seed))
				continue
			forage_seeds -= forage_seed
			var/datum/seed/seed_datum = SSplants.seeds[forage_seed]
			if(istype(seed_datum))
				forage_seeds += seed_datum
			else
				log_error("Invalid seed name: [forage_seed]")
	return ..()

/datum/random_map/noise/forage/get_appropriate_path(value)
	return

/datum/random_map/noise/forage/get_additional_spawns(value, turf/T)
	if(!istype(T, /turf/floor))
		return
	var/turf/floor/floor = T
	var/decl/flooring/flooring = floor.get_topmost_flooring()
	var/parse_value = noise2value(value)
	var/place_prob
	var/place_type

	if(floor.is_outside())
		if(istype(flooring, /decl/flooring/rock))
			if(prob(15)) // Static as current map has limited amount of rock turfs
				var/rock_type = SAFEPICK(forage["rocks"])
				new rock_type(floor)
				return
		if(istype(flooring, /decl/flooring/grass))
			if(prob(parse_value * tree_weight))
				if(length(trees))
					var/tree_type = pickweight(trees)
					new tree_type(floor)
				return
			place_prob = parse_value * forage_weight
			place_type = SAFEPICK(forage["grass"])
		if(istype(flooring, /decl/flooring/mud))
			switch(floor.get_fluid_depth())
				if(FLUID_OVER_MOB_HEAD to FLUID_MAX_DEPTH)
					place_prob = parse_value * forage_weight
					place_type = SAFEPICK(forage["riverbed"])
				if(FLUID_SLURRY to FLUID_OVER_MOB_HEAD)
					place_prob = parse_value * forage_weight
					place_type = SAFEPICK(forage["shallows"])
				else
					place_prob = parse_value * forage_weight
					place_type = SAFEPICK(forage["riverbank"]) // no entries by default, expanded on subtypes
	else
		if(istype(flooring, /decl/flooring/mud))
			switch(floor.get_fluid_depth())
				if(FLUID_SLURRY to FLUID_OVER_MOB_HEAD)
					place_prob = parse_value * cave_forage_weight
					place_type = SAFEPICK(forage["cave_shallows"])
				if(0 to FLUID_SLURRY)
					if(prob(parse_value * cave_tree_weight))
						if(length(cave_trees))
							var/tree_type = pick(cave_trees)
							new tree_type(floor)
						return
					place_prob = parse_value * cave_forage_weight * 2
					place_type = SAFEPICK(forage["caves"])
		else if(istype(flooring, /decl/flooring/dirt))
			place_prob = parse_value * cave_forage_weight
			place_type = SAFEPICK(forage["caves"])

	if(place_type && prob(place_prob))
		if(istype(place_type, /datum/seed))
			new /obj/structure/flora/plant(floor, null, null, place_type)
			for(var/stepdir in global.alldirs)
				if(prob(15))
					var/turf/neighbor = get_step(floor, stepdir)
					if(istype(neighbor, floor.type) && !(locate(/obj/structure/flora/plant) in neighbor))
						new /obj/structure/flora/plant(neighbor, null, null, place_type)
		else if(ispath(place_type, /atom))
			new place_type(floor)
