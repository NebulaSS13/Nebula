
///////////////////////////////////////////////////////////////////////
// Random Planetoid Template
///////////////////////////////////////////////////////////////////////

/// A randomly generated "tempate" for an planet-like objects. Meant to standardize how random planets are generated so it behave like all other map templates.
/datum/map_template/planetoid/random
	name                 = "random planetoid"
	abstract_type        = /datum/map_template/planetoid/random
	template_parent_type = /datum/map_template/planetoid/random
	modify_tag_vars      = TRUE //Would set it to false, since we're generating everything on the fly, but unit test doesn't like it
	tallness             = 1 //Amount of vertical z-levels to generate for this planet.

	//#TODO: This could probably be simplified down.
	///Amount of adjacent stacked z-levels to generate north of the root z-level stack.
	///Setting this to 1 for instance will generate a stack of zlevels connecting to the north of all z-levels below the root level. Tallness is same as root.
	var/adjacent_levels_north = 0
	///Amount of adjacent stacked z-levels to generate south of the root z-level stack. Tallness is same as root.
	var/adjacent_levels_south = 0
	///Amount of adjacent stacked z-levels to generate east of the root z-level stack. Tallness is same as root.
	var/adjacent_levels_east = 0
	///Amount of adjacent stacked z-levels to generate west of the root z-level stack. Tallness is same as root.
	var/adjacent_levels_west = 0

	///A list of the same length as there are zlevels on this map(index is z level count in order).
	///Each entry is a level_data type, or null. If defined, will override the level_data_type var for the specified z-level.
	var/list/prefered_level_data_per_z

	///The type of overmap marker object to use for this planet
	var/overmap_marker_type = /obj/effect/overmap/visitable/sector/planetoid
	///The index of the generated level that will be considered the planet's surface for this generated planet counting from top to bottom.
	/// The surface here implies the first "solid ground" z-level from the top.
	var/surface_level_index = 1

	///Amount of shuttle landing points to generate on the surface level of the planet. If null, none will be generated.
	var/amount_shuttle_landing_points = 2
	///The maximum shuttle "radius" for the shuttle landing points that will be generated.
	var/max_shuttle_radius = 20

	// *** Map Gen ***
	///Maximum amount of themes that can be picked for the same planet.
	var/max_themes = 2
	///List of theme types that can be picked by this planet when generating.
	var/list/possible_themes
	///Bit flag of the only ruin tags that may be picked by this planet.
	var/ruin_tags_whitelist
	///Bit flag of the ruin tags that may never be picked for this planet.
	var/ruin_tags_blacklist
	///Maximume amount of subtemplates/ruins/sites that may be picked and spawned on the planet.
	var/subtemplate_budget = 4
	///Ruin sites map template category to use for creating ruins on this planet.
	var/ruin_category = MAP_TEMPLATE_CATEGORY_PLANET_SITE

/datum/map_template/planetoid/random/is_runtime_generated()
	return TRUE

/datum/map_template/planetoid/random/get_spawn_weight()
	return 100

/datum/map_template/planetoid/random/get_template_cost()
	return 1

///Create individual levels linked to this planet. Must be called after basic planet stuff has been generated(atmosphere, habitability, etc..)
/datum/map_template/planetoid/random/proc/generate_levels(var/datum/planetoid_data/gen_data, var/list/theme_generators)
	//Setup a list of level data types to use for each new z-levels
	var/list/lvl_to_build = list()
	for(var/i = 1 to tallness)
		lvl_to_build += LAZYACCESS(prefered_level_data_per_z, i) || level_data_type
	log_debug("Planet Levels:\n\tRoot Level:[world.maxz + 1]")

	//Build root z-stack first
	var/list/root_stack = build_z_stack(null, null, lvl_to_build, gen_data)

	//Build any amount of adjacent stacks at our desired cardinal directions
	var/list/north_stack = build_adjacent_z_stacks(adjacent_levels_north, NORTH, root_stack, lvl_to_build, gen_data)
	var/list/south_stack = build_adjacent_z_stacks(adjacent_levels_south, SOUTH, root_stack, lvl_to_build, gen_data)
	var/list/east_stack  = build_adjacent_z_stacks(adjacent_levels_east,  EAST,  root_stack, lvl_to_build, gen_data)
	var/list/west_stack  = build_adjacent_z_stacks(adjacent_levels_west,  WEST,  root_stack, lvl_to_build, gen_data)

	//Add the stacks for each cardinal directions up, avoiding null lists
	. = root_stack
	if(length(north_stack))
		. += north_stack
	if(length(south_stack))
		. += south_stack
	if(length(east_stack))
		. += east_stack
	if(length(west_stack))
		. += west_stack

	log_debug("Preparing [length(.)] planet levels...")
	//Generate individual levels now that the z-level structure is properly setup
	for(var/datum/level_data/planetoid/LD in .)
		log_debug("Setting up level [LD] ([LD.level_z]).")
		//place level transition borders and etc, but skip level gen
		LD.setup_level_data(TRUE)
		//Apply the theme's level gen (rock walls, debris, buildings, etc..)
		if(length(theme_generators))
			LD.apply_map_generators(theme_generators) //#TODO: Theme generators should probably selectively apply to levels
		//Let the level apply its level-specific generators (terrain/flora/fauna/grass)
		LD.generate_level()

///Build a stack that's adjacent to the specified stack.
/datum/map_template/planetoid/random/proc/build_adjacent_z_stacks(var/amount, var/direction_from_root, var/list/adjacent_level_data, var/list/new_level_data_types, var/datum/planetoid_data/gen_data)
	var/list/lvl_data = list()
	if(amount < 1)
		return lvl_data
	lvl_data = build_z_stack(direction_from_root, adjacent_level_data, new_level_data_types, gen_data)
	if(amount < 2)
		return lvl_data
	//If amount if bigger than 2, build another adjacent stack to us
	lvl_data += build_adjacent_z_stacks(amount - 1, direction_from_root, lvl_data, new_level_data_types, gen_data)
	return lvl_data

///Create a new z-level stack that's connected to an existing z stack, on the given direction.
/datum/map_template/planetoid/random/proc/build_z_stack(var/direction_from_root, var/list/adjacent_level_data, var/list/new_level_data_types, var/datum/planetoid_data/gen_data)
	. = list()
	var/stack_height = length(new_level_data_types)

	//Must build levels from bottom to top for multi-z to work
	for(var/i = stack_height, i >= 1, i--)
		//Register the z-level to the planetoid, BEFORE the level_data runs its init code, so turfs get linked properly
		SSmapping.register_planetoid_levels(world.maxz + 1, gen_data)
		var/myty                   = new_level_data_types[i]
		var/datum/level_data/LDadj = LAZYACCESS(adjacent_level_data, (stack_height - i) + 1) //stack is filled lowest level first, so we have to match in reverse
		var/datum/level_data/planetoid/LDnew = SSmapping.increment_world_z_size(myty, TRUE)

		log_debug("\n\t\tLevel Z:[world.maxz], [dir_name(direction_from_root)] of z-level [LDadj?.level_z]")

		//Make sure the level connects to us if we have an adjacent level
		if(LDadj)
			LAZYSET(LDnew.connected_levels, LDadj.level_id, global.reverse_dir[direction_from_root])
			LAZYSET(LDadj.connected_levels, LDnew.level_id, direction_from_root)
		else
			//We have to manually set those, since we don't rely on level_id to get the topmost and surface level
			//If we don't have an adjacent level, we're the root level stack and need to set some extra stuff
			if(i == stack_height)
				gen_data.set_topmost_level(LDnew)
			//Make sure we mark the surface level id
			if(i == surface_level_index)
				gen_data.set_surface_level(LDnew)

		 //Apply planet name, etc..
		LDnew.set_planetoid(gen_data)
		. += LDnew

	log_debug("\n\tZ-Stack Top:[world.maxz], Direction:[dir_name(direction_from_root)]")
	//Make sure the stack has its stack top object
	var/obj/abstract/map_data/MD = new /obj/abstract/map_data(locate(1, 1, world.maxz), stack_height) //#TODO: maybe combine map_data with level_data?
	MD.SetName("ZStack: [gen_data.name] - [.[length(.)]]")

//The extra datum/planetoid_data/gen_data arg is only for admin spawming exoplanets, since some parameters are taken from the user
/datum/map_template/planetoid/random/load_new_z(no_changeturf = TRUE, centered = TRUE, var/datum/planetoid_data/gen_data) //centered == false should probably runtime, because it will never work properly
	if(!gen_data)
		gen_data = create_planetoid_instance()

	//Generate some of the background stuff for our new planet
	before_planet_gen(gen_data)

	//Prepare themes, and apply ruin overrides
	var/new_ruin_whitelist = ruin_tags_whitelist
	var/new_ruin_blacklist = ruin_tags_blacklist
	var/list/theme_map_generators
	for(var/datum/exoplanet_theme/T in gen_data.themes)
		new_ruin_whitelist = T.modify_ruin_whitelist(new_ruin_whitelist)
		new_ruin_blacklist = T.modify_ruin_blacklist(new_ruin_blacklist)
		T.before_map_generation(gen_data)

		var/list/gennies = T.get_map_generators()
		if(length(gennies)) //Make sure we don't add null entries if this returns nothing
			LAZYADD(theme_map_generators, gennies)

	//Figure out if we generate from scratch the planet, or we're loading a pre-made map
	var/list/datum/level_data/new_level_data = list()
	if(length(mappaths))
		var/zbefore = world.maxz

		//Load levels from map files
		..(no_changeturf, centered)

		///Add all the level_data from the levels we loaded, so we can sync the levels
		for(var/cntz = zbefore to world.maxz)
			var/datum/level_data/LD = SSmapping.levels_by_z[cntz]
			ASSERT(istype(LD))
			new_level_data += LD
	else
		//Create levels from scratch
		///Create all needed z-levels, tell each of them to generate themselves
		new_level_data = generate_levels(gen_data, theme_map_generators)
		//Spawn the ruins and sites on the planet
		generate_features(gen_data, new_level_data, new_ruin_whitelist, new_ruin_blacklist)

	//Notify themes we finished gen. Since some themes may not change level gen, we run it for either random or mapped planets
	for(var/datum/exoplanet_theme/T in gen_data.themes)
		T.after_map_generation(gen_data)

	//Setup overmap, landing positions, and all the misc things that require the planet to be fully initialized
	after_planet_gen(gen_data, SSmapping.levels_by_id[gen_data.topmost_level_id], SSmapping.levels_by_id[gen_data.surface_level_id])

	//Run the finishing touch on all loaded levels
	for(var/datum/level_data/LD in new_level_data)
		LD.after_template_load(src)
		if(SSlighting.initialized)
			SSlighting.InitializeZlev(LD.level_z)
		log_game("Z-level '[LD.name]'(planetoid:'[name]') loaded at [LD.level_z]")
	loaded++
	return WORLD_CENTER_TURF(world.maxz)

/datum/map_template/planetoid/random/proc/before_planet_gen(var/datum/planetoid_data/gen_data)
	//Make sure to apply theme stuff
	select_themes(gen_data)
	for(var/datum/exoplanet_theme/T in gen_data.themes)
		T.adjust_atmosphere(gen_data)

/datum/map_template/planetoid/random/proc/after_planet_gen(var/datum/planetoid_data/gen_data, var/datum/level_data/topmost_level_data, var/datum/level_data/surface_level_data)
	//#TODO: Generate vertical z-level connections (holes/stairs/ladders)?
	generate_weather(gen_data, topmost_level_data)

	generate_landing(gen_data, surface_level_data)

	//Fill in the overmap object
	setup_planet_overmap(gen_data, topmost_level_data)

///Call after map is fully generated. Setup the overmap obj to match the planet we just generated.
/datum/map_template/planetoid/random/setup_planet_overmap(var/datum/planetoid_data/gen_data, var/datum/level_data/topmost_level_data)
	//Update if loaded from map, or create one if created at runtime
	if(is_runtime_generated())
		gen_data.set_overmap_marker(new overmap_marker_type(
			locate(topmost_level_data.level_inner_min_x, topmost_level_data.level_inner_min_y, topmost_level_data.level_z),
			topmost_level_data.level_z))
	else
		. = ..()

///Make sure all levels of this planet have the weather system setup.
/datum/map_template/planetoid/random/proc/generate_weather(var/datum/planetoid_data/gen_data, var/datum/level_data/topmost_level_data)
	if(!ispath(gen_data.initial_weather_state, /decl/state/weather))
		return
	gen_data.reset_weather(gen_data.initial_weather_state)

///Tries to place landing areas for shuttles on the surface level of the planet. Run after generation is complete to avoid bad surprises!
/datum/map_template/planetoid/random/proc/generate_landing(var/datum/planetoid_data/gen_data, var/datum/level_data/surface_level)
	var/list/places
	var/attempts       = 10 * amount_shuttle_landing_points
	var/points_left    = amount_shuttle_landing_points
	var/landing_radius = CEILING(max_shuttle_radius / 2)
	var/border_padding = landing_radius + 3

	while(points_left)
		attempts--
		var/turf/T = locate(
			rand(surface_level.level_inner_min_x + border_padding, surface_level.level_inner_max_x  - border_padding),
			rand(surface_level.level_inner_min_y + border_padding, surface_level.level_inner_max_y  - border_padding),
			surface_level.level_z)

		if(!T || (T in places)) // Two landmarks on one turf is forbidden as the landmark code doesn't work with it.
			continue

		if(attempts >= 0) // While we have the patience, try to find better spawn points. If out of patience, put them down wherever, so long as there are no repeats.
			var/valid = 1
			var/list/block_to_check = block(locate(T.x - landing_radius, T.y - landing_radius, T.z), locate(T.x + landing_radius, T.y + landing_radius, T.z))
			for(var/turf/check in block_to_check)
				if(!istype(get_area(check), gen_data.surface_area) || check.turf_flags & TURF_FLAG_NORUINS)
					valid = 0
					break
			if(attempts >= 10)
				if(check_collision(T.loc, block_to_check)) //While we have lots of patience, ensure landability
					valid = 0

			if(!valid)
				continue

		points_left--
		LAZYADD(places, T)
		new /obj/effect/shuttle_landmark/automatic/clearing(T, landing_radius)
