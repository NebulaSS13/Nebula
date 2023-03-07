/datum/level_data/planetoid
	level_flags             = (ZLEVEL_PLAYER|ZLEVEL_SEALED)
	border_filler           = /turf/unsimulated/mineral
	loop_turf_type          = /turf/exterior/mimic_edge/transition/loop
	transition_turf_type    = /turf/exterior/mimic_edge/transition
	take_starlight_ambience = FALSE

/datum/level_data/planetoid/exoplanet
	base_area = /area/exoplanet
	base_turf = /turf/exterior/dirt

/datum/level_data/planetoid/exoplanet/underground
	base_area = /area/exoplanet/underground
	base_turf = /turf/exterior/volcanic
	level_generators = list(
		/datum/random_map/noise/exoplanet/mantle,
	)

///Prepare our level for generation/load. And sync with the planet template
/datum/level_data/planetoid/before_template_load(datum/map_template/template, datum/planetoid_data/gen_data)
	. = ..()
	if(!gen_data)
		return //If there's no data from generation, it's fine we'll allow it

	//Apply parent's prefered bounds if we don't have any preferences
	if(!level_max_width && gen_data.width)
		level_max_width = gen_data.width
	if(!level_max_height && gen_data.height)
		level_max_height = gen_data.height

	//Refresh bounds
	setup_level_bounds()

	//override atmosphere
	apply_planet_atmosphere(gen_data)

	//Rename main area and level
	adapt_location_name(gen_data.name)

	//Try to adopt our parent planet's ambient lighting preferences
	apply_planet_ambient_lighting(gen_data)

///If we're getting atmos from our parent planet, decide if we're going to apply it, or ignore it
/datum/level_data/planetoid/proc/apply_planet_atmosphere(var/datum/planetoid_data/P)
	if(istype(exterior_atmosphere))
		return //level atmos takes priority over planet atmos
	exterior_atmosphere = P.atmosphere.Clone()

///Apply our parent planet's ambient lighting settings if we want to.
/datum/level_data/planetoid/proc/apply_planet_ambient_lighting(var/datum/planetoid_data/P)
	if(!ambient_light_level)
		ambient_light_level = P.surface_light_level
	if(!ambient_light_color)
		ambient_light_level = P.surface_light_color

/datum/level_data/planetoid/adapt_location_name(location_name)
	if(!(. = ..()))
		return
	if(ispath(base_area) && !ispath(base_area, world.area))
		var/area/A = new base_area()
		A.SetName("[location_name]")

///Try to spawn the given amount of ruins onto our level. Returns the template types that were spawned
/datum/level_data/planetoid/proc/seed_ruins(var/budget = 0, var/list/potentialRuins)
	//#TODO: Fill in allowed area from a proc or something
	var/list/areas_whitelist  = list(base_area)
	var/list/candidates_ruins = potentialRuins.Copy()
	var/list/spawned_ruins    = list()

	//Each iteration needs to either place a ruin or strictly decrease either the budget or ruins.len (or break).
	for(var/datum/map_template/R = candidates_ruins[1], length(candidates_ruins) && (budget > 0), R = pick(candidates_ruins))
		if((R.get_template_cost() <= budget) && !LAZYISIN(SSmapping.banned_ruin_names, R.name) && try_place_ruin(R, areas_whitelist))
			spawned_ruins += R
			budget        -= R.get_template_cost()
			//Mark spawned no-duplicate ruins globally
			if(!(R.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
				LAZYDISTINCTADD(SSmapping.banned_ruin_names, R.name)
		candidates_ruins -= R

	if(budget > 0)
		log_world("Ruin loader had no ruins to pick from with [budget] left to spend.")
	return spawned_ruins

/datum/level_data/planetoid/proc/try_place_ruin(var/datum/map_template/ruin, var/list/area_whitelist)
	//#FIXME: Isn't trying to fit in a ruin by rolling randomly a bit inneficient?
	// Try to place it
	var/sanity           = 20
	var/ruin_half_width  = RUIN_MAP_EDGE_PAD + round(ruin.width/2)  //Half the ruin size plus the map edge spacing, for testing from the centerpoint
	var/ruin_half_height = RUIN_MAP_EDGE_PAD + round(ruin.height/2)
	var/ruin_full_width  = (2 * RUIN_MAP_EDGE_PAD) + ruin.width
	var/ruin_full_height = (2 * RUIN_MAP_EDGE_PAD) + ruin.height
	if((ruin_full_width > level_inner_width) || (ruin_full_height > level_inner_height)) // Too big and will never fit.
		return //Return if it won't even fit on the entire level

	//Try to fit it in somehwere a few times, then give up if we can't
	while(sanity > 0)
		sanity--
		//Pick coordinates inside the level's border within which the ruin will fit. Including the extra ruin spacing from the level's borders.
		var/cturf_x = rand(level_inner_min_x + ruin_half_width,  level_inner_max_x - ruin_half_width)
		var/cturf_y = rand(level_inner_min_y + ruin_half_height, level_inner_max_y - ruin_half_height)
		var/turf/T  = locate(cturf_x, cturf_y, level_z)
		var/valid   = TRUE

		//#TODO: There's definitely a way to cache what turfs use an area, to avoid doing this for every single ruins!
		//       Could also probably cache TURF_FLAG_NORUINS turfs globally.
		var/list/affected_turfs = ruin.get_affected_turfs(T, TRUE)
		for(var/turf/test_turf in affected_turfs)
			var/area/A = get_area(test_turf)
			if(!is_type_in_list(A, area_whitelist) || (test_turf.turf_flags & TURF_FLAG_NORUINS))
				valid = FALSE
				break //Break out of the turf check loop, and grab a new set of coordinates
		if(!valid)
			continue

		log_world("Spawned ruin \"[ruin.name]\", center: ([T.x], [T.y], [T.z]), min: ([T.x - ruin_half_width], [T.y - ruin_half_height]), max: ([T.x + ruin_half_width], [T.y + ruin_half_height])")
		load_ruin(T, ruin)
		return ruin

/datum/level_data/planetoid/proc/load_ruin(turf/central_turf, datum/map_template/template)
	if(!template)
		return FALSE
	for(var/turf/T in template.get_affected_turfs(central_turf, TRUE))
		for(var/mob/living/simple_animal/monster in T)
			qdel(monster)
	template.load(central_turf, centered = TRUE)
	return TRUE

//
//
//

///Random map generator for generating underground planetary levels.
/datum/random_map/noise/exoplanet/mantle
	descriptor           = "planetary mantle"
	smoothing_iterations = 2
	land_type            = /turf/exterior/volcanic
	water_type           = /turf/exterior/lava
	water_level_min      = 3
	water_level_max      = 6
	fauna_prob           = 0
	megafauna_spawn_prob = 0
	flora_prob           = 0
	grass_prob           = 0
	large_flora_prob     = 0