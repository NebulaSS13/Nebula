///Base level data for levels that are subordinated to a /datum/planetoid_data entry.
///A bunch of things are fetched from planet gen to stay in sync.
/datum/level_data/planetoid
	level_flags                  = (ZLEVEL_PLAYER|ZLEVEL_SEALED)
	border_filler                = /turf/unsimulated/mineral
	loop_turf_type               = /turf/exterior/mimic_edge/transition/loop
	transition_turf_type         = /turf/exterior/mimic_edge/transition
	use_global_exterior_ambience = FALSE

///Level data for generating surface levels on exoplanets
/datum/level_data/planetoid/exoplanet
	base_area = /area/exoplanet
	base_turf = /turf/exterior/dirt

///Level data for generating underground levels on exoplanets
/datum/level_data/planetoid/exoplanet/underground
	base_area = /area/exoplanet/underground
	base_turf = /turf/exterior/volcanic
	level_generators = list(
		/datum/random_map/noise/exoplanet/mantle,
		/datum/random_map/automata/cave_system/mantle,
	)

/datum/level_data/planetoid/initialize_level_id()
	if(level_id)
		return
	level_id = "planetoid_[level_z]_[sequential_id(/datum/level_data)]"

/datum/level_data/planetoid/setup_strata()
	//If no fixed strata, grab the one from the owning planetoid_data if we have any
	if(!strata)
		var/datum/planetoid_data/planet = SSmapping.planetoid_data_by_z[level_z]
		strata = planet?.get_strata()
	. = ..()

///Prepare our level for generation/load. And sync with the planet template
/datum/level_data/planetoid/before_template_generation(datum/map_template/template, var/datum/planetoid_data/gen_data)
	//In cases when the planetoid_data isn't shared with us, like from loading non-random planet map templates, we can try fetching it.
	if(!gen_data)
		gen_data = SSmapping.planetoid_data_by_z[level_z]
	if(!gen_data)
		CRASH("'[src]', id:'[level_id]', z:'[level_z]'. Couldn't access expected planetoid_data!")

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
	exterior_atmosphere = P.atmosphere.Clone() //Make sure we get one instance per level

///Apply our parent planet's ambient lighting settings if we want to.
/datum/level_data/planetoid/proc/apply_planet_ambient_lighting(var/datum/planetoid_data/P)
	if(!ambient_light_level)
		ambient_light_level = P.surface_light_level
	if(!ambient_light_color)
		ambient_light_level = P.surface_light_color

/datum/level_data/planetoid/adapt_location_name(location_name)
	if(!(. = ..()))
		return
	if(!ispath(base_area) || ispath(base_area, world.area))
		return
	var/area/A = get_base_area_instance()
	//Make sure we're not going to rename the world's base area
	if(!istype(A, world.area))
		global.using_map.area_purity_test_exempt_areas |= A.type //Make sure we add any of those, so unit tests calm down when we rename
		A.SetName("[location_name]")

///Try to spawn the given amount of ruins onto our level. Returns the template types that were spawned
/datum/level_data/planetoid/proc/seed_ruins(var/budget = 0, var/list/potentialRuins)
	if(!length(potentialRuins))
		log_world("Ruin loader was given no ruins to pick from.")
		return list()
	//#TODO: Fill in allowed area from a proc or something
	var/list/areas_whitelist  = list(base_area)
	var/list/candidates_ruins = potentialRuins.Copy()
	var/list/spawned_ruins    = list()

	//Each iteration needs to either place a ruin or strictly decrease either the budget or ruins.len (or break).
	while(length(candidates_ruins) && (budget > 0))
		var/datum/map_template/R = pick(candidates_ruins)
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

///Attempts several times to find turfs where a ruin can be placed.
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

///Actually handles loading a ruin template at the given turf.
/datum/level_data/planetoid/proc/load_ruin(turf/central_turf, datum/map_template/template)
	if(!template)
		return FALSE
	for(var/turf/T in template.get_affected_turfs(central_turf, TRUE))
		for(var/mob/living/simple_animal/monster in T)
			qdel(monster)
	template.load(central_turf, centered = TRUE)
	return TRUE
