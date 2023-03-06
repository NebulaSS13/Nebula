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
	ambient_light_level = 0

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

///If we're getting atmos from our parent planet, decide if we're going to apply it, or ignore it
/datum/level_data/planetoid/proc/apply_planet_atmosphere(var/datum/planetoid_data/P)
	if(istype(exterior_atmosphere))
		return //level atmos takes priority over planet atmos
	exterior_atmosphere = P.atmosphere.Clone()

/datum/level_data/planetoid/adapt_location_name(location_name)
	if(!(. = ..()))
		return
	if(ispath(base_area) && !ispath(base_area, /area/space))
		var/area/A = new base_area()
		A.SetName("Surface of [location_name]")

///Try to spawn the given amount of ruins onto our level. Returns the template types that were spawned
/datum/level_data/planetoid/proc/seed_ruins(var/budget = 0, var/list/potentialRuins)
	var/turf/level_test = locate(1, 1, level_z)
	if(!level_test)
		WARNING("Z level [level_z] does not exist - Not generating ruins")
		return

	//#TODO: Fill in allowed area from a proc or something
	var/list/whitelist = list(base_area)
	var/list/ruins = potentialRuins.Copy()
	for(var/R in potentialRuins)
		var/datum/map_template/ruin = R
		if(LAZYISIN(SSmapping.banned_ruin_names, ruin.name))
			ruins -= ruin //remove all prohibited ids from the candidate list; used to forbit global duplicates.

	var/list/spawned_ruins = list()
//Each iteration needs to either place a ruin or strictly decrease either the budget or ruins.len (or break).
	while(budget > 0)
		// Pick a ruin
		var/datum/map_template/ruin = null
		if(ruins && ruins.len)
			ruin = pick(ruins)
			if(ruin.get_template_cost() > budget)
				ruins -= ruin
				continue //Too expensive, get rid of it and try again
		else
			log_world("Ruin loader had no ruins to pick from with [budget] left to spend.")
			break
		// Try to place it
		var/sanity = 20
		// And if we can't fit it anywhere, give up, try again

		while(sanity > 0)
			sanity--

			var/width_border = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.width / 2)
			var/height_border = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.height / 2)
			if(width_border > (level_max_width - width_border) || height_border > (level_max_height - height_border)) // Too big and will never fit.
				ruins -= ruin //So let's not even try anymore with this one.
				break

			var/turf/T = locate(rand(width_border, level_max_width - width_border), rand(height_border, level_max_height - height_border), level_z)
			var/valid = TRUE

			for(var/turf/check in ruin.get_affected_turfs(T,1))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, whitelist)) || check.turf_flags & TURF_FLAG_NORUINS)
					if(sanity == 0)
						ruins -= ruin //It didn't fit, and we are out of sanity. Let's make sure not to keep trying the same one.
					valid = FALSE
					break //Let's try again

			if(!valid)
				continue
			log_world("Ruin \"[ruin.name]\" placed at ([T.x], [T.y], [T.z])")

			load_ruin(T, ruin)
			spawned_ruins += ruin
			var/ruin_cost = ruin.get_template_cost()
			if(ruin_cost >= 0)
				budget -= ruin_cost
			if(!(ruin.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
				for(var/other_ruin_datum in ruins)
					var/datum/map_template/other_ruin = other_ruin_datum
					if(ruin.name == other_ruin.name)
						ruins -= ruin //Remove all ruins with the same name if we don't allow duplicates
				LAZYDISTINCTADD(SSmapping.banned_ruin_names, ruin.name) //and ban them globally too
			break
	return spawned_ruins

/datum/level_data/planetoid/proc/load_ruin(turf/central_turf, datum/map_template/template)
	if(!template)
		return FALSE
	for(var/i in template.get_affected_turfs(central_turf, 1))
		var/turf/T = i
		for(var/mob/living/simple_animal/monster in T)
			qdel(monster)
	template.load(central_turf,centered = TRUE)
	return TRUE
