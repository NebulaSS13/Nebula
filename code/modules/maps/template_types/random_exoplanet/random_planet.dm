
///////////////////////////////////////////////////////////////////////
// Random Planetoid Template
///////////////////////////////////////////////////////////////////////
/// A randomly generated "tempate" for an planet-like objects. Meant to standardize how random planets are generated so it behave like all other map templates.
/datum/map_template/planetoid
	name                 = "random planet"
	abstract_type        = /datum/map_template/planetoid
	template_parent_type = /datum/map_template/planetoid
	template_categories  = list(MAP_TEMPLATE_CATEGORY_PLANET)
	level_data_type      = /datum/level_data/planetoid
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
	///A list of gas and their proportion to enforce on this planet.
	///If get_mandatory_gases() returns gases, they will be added to this. If null is randomly generated.
	var/list/initial_atmosphere_gases
	///Minimum possible base temperature range to pick from, in kelvins, when generating the atmosphere on this planet.
	var/atmosphere_temperature_min = TCMB
	///Maximum possible base temperature range to pick from, in kelvins, when generating the atmosphere on this planet.
	var/atmosphere_temperature_max = T100C
	///Minimum atmospheric pressure in the range to pick from for this planet template.
	var/atmosphere_pressure_min = 0.5 ATM
	///Maximum atmospheric pressure in the range to pick from for this planet template.
	var/atmosphere_pressure_max = 2 ATM

	///What weather state to use for this planet initially. If null, will not initialize any weather system.
	var/initial_weather_state
	///The type of overmap marker object to use for this planet
	var/overmap_marker_type = /obj/effect/overmap/visitable/sector/planetoid
	///The index of the generated level that will be considered the planet's surface for this generated planet counting from top to bottom.
	/// The surface here implies the first "solid ground" z-level from the top.
	var/surface_level_index = 1
	///Amount of shuttle landing points to generate on the surface level of the planet. If null, none will be generated.
	var/amount_shuttle_landing_points = 2
	///The maximum shuttle "radius" for the shuttle landing points that will be generated.
	var/max_shuttle_radius = 20
	///The type of engraving flavor text generator to use for the new planet
	var/xenoarch_engraving_flavor_type = /datum/xenoarch_engraving_flavor

	// *** Appearence ***
	///Possible colors for rock walls and rocks in general on this planet (Honestly, should be handled via materal system maybe?)
	var/list/possible_rock_colors = list(COLOR_ASTEROID_ROCK)
	///Planet ambient lighting minimum possible value from 0 to 1. This value may be overridden in individual /datum/level_data.
	var/surface_light_level_min = 0.45
	///Planet ambient lighting maximum possible value from 0 to 1. This value may be overridden in individual /datum/level_data.
	var/surface_light_level_max = 0.75
	///Possible list of colors to pick for the ambient lighting color. Null means a random color will be generated.
	///This value may be overridden by individual /datum/level_data.
	var/list/surface_light_colors

	// *** Fauna/Flora ***
	///Set to the type of fauna generator to enforce on all planets z-levels, if we're generating fauna.
	///If handling fauna per level, or not generating any, leave this null.
	var/fauna_generator_type
	///Set this to the type of flora generator to enforce on all planet z-levels, if generating flora.
	///When handling flora per level, or not generating flora, leave this null.
	var/flora_generator_type

	// *** Map Gen ***
	///Maximum amount of themes that can be picked for the same planet.
	var/max_themes = 2
	///List of theme types that can be picked by this planet when generating.
	var/list/possible_themes
	///A list of /datum/random_map types to apply to every z-level of this planet, in order.
	var/list/map_generators
	///Bit flag of the only ruin tags that may be picked by this planet.
	var/ruin_tags_whitelist
	///Bit flag of the ruin tags that may never be picked for this planet.
	var/ruin_tags_blacklist
	///Maximume amount of subtemplates/ruins/sites that may be picked and spawned on the planet.
	var/subtemplate_budget = 4
	///Ruin sites map template category to use for creating ruins on this planet.
	var/ruin_category = MAP_TEMPLATE_CATEGORY_PLANET_SITE

	///The chance that this planetoid template creates a planetoid with a ring.
	var/ring_probability = 25
	///Possible ring colors
	var/list/possible_ring_color = list(COLOR_OFF_WHITE, "#f0fcff", "#dcc4ad", "#d1dcad", "#adb8dc")
	///Possible ring sprites that can be used for a possible ring
	var/list/possible_ring_type_name = list(SKYBOX_PLANET_RING_TYPE_SPARSE, SKYBOX_PLANET_RING_TYPE_DENSE)

/datum/map_template/planetoid/New(created_ad_hoc)
	. = ..()
	//Make sure we got a sensible surface_level_index
	if(surface_level_index < 1)
		log_warning("Map template: '[src]'([type]) had a 'surface_level_index' value that was '[isnull(surface_level_index)? "null" : surface_level_index]'. Forcing to 1!")
		surface_level_index = 1
	if(surface_level_index > tallness)
		log_warning("Map template: '[src]'([type]) had an invalid 'surface_level_index' value of '[surface_level_index]', while 'tallness' is '[tallness]'. Clamping.")
		surface_level_index = min(surface_level_index, tallness)

/datum/map_template/planetoid/is_runtime_generated()
	return TRUE

/datum/map_template/planetoid/get_spawn_weight()
	return 100

/datum/map_template/planetoid/get_template_cost()
	return 1

/datum/map_template/planetoid/load(turf/T, centered = FALSE)
	//Main reason for this is, map bounds are up to level_data. They're needed to tell what level of a planet is a level,
	// but cannot be combined with existing level_data.
	CRASH("Cannot load an exoplanet template over an existing level")

///Returns a new instance of a datum used for containing runtime info on the planet generated by this template.
/datum/map_template/planetoid/proc/create_planetoid_instance()
	var/datum/planetoid_data/PD = new /datum/planetoid_data(src)
	//#TODO: Work out some more elegant solution here cause it's pretty gross
	if(flora_generator_type)
		PD.setup_flora_generator(flora_generator_type)
	if(fauna_generator_type)
		PD.setup_fauna_generator(fauna_generator_type)
	return PD

///Create individual levels linked to this planet. Must be called after basic planet stuff has been generated(atmosphere, habitability, etc..)
/datum/map_template/planetoid/proc/generate_levels(var/datum/planetoid_data/gen_data, var/list/theme_generators)
	//Register the planetoid so the planet stuff can properly look us up when initializing the z-levels.
	SSmapping.register_planetoid(gen_data)

	//Setup a list of level data types to use for each new z-levels
	var/list/lvl_to_build = list()
	for(var/i = 1 to tallness)
		lvl_to_build += LAZYACCESS(prefered_level_data_per_z, i) || level_data_type
	log_debug("Planet Levels:\n\tRoot Level:[world.maxz + 1]")

	//Build root z-stack first
	var/list/root_stack = build_z_stack(null, null, lvl_to_build, gen_data)

	//Build any amount of adjacent stacks
	var/list/north_stack = build_adjacent_z_stacks(adjacent_levels_north, NORTH, root_stack, lvl_to_build, gen_data)
	var/list/south_stack = build_adjacent_z_stacks(adjacent_levels_south, SOUTH, root_stack, lvl_to_build, gen_data)
	var/list/east_stack  = build_adjacent_z_stacks(adjacent_levels_east,  EAST,  root_stack, lvl_to_build, gen_data)
	var/list/west_stack  = build_adjacent_z_stacks(adjacent_levels_west,  WEST,  root_stack, lvl_to_build, gen_data)

	//Add them up, avoiding nulls
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
		//Apply our own level gen and the theme's level gen (rock walls, debris, buildings, etc..)
		LD.apply_map_generators(length(theme_generators)? (map_generators | theme_generators) : map_generators) //#TODO: Theme generators should probably selectively apply to levels
		//Let the level apply its level-specific generators (flora/fauna/grass)
		LD.generate_level()

///Build a stack that's adjacent to the specified stack.
/datum/map_template/planetoid/proc/build_adjacent_z_stacks(var/amount, var/direction_from_root, var/list/adjacent_level_data, var/list/new_level_data_types, var/datum/planetoid_data/gen_data)
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
/datum/map_template/planetoid/proc/build_z_stack(var/direction_from_root, var/list/adjacent_level_data, var/list/new_level_data_types, var/datum/planetoid_data/gen_data)
	. = list()
	var/stack_height = length(new_level_data_types)

	//Must build levels from bottom to top for multi-z to work
	for(var/i = stack_height, i >= 1, i--)
		//Register the z-level to the planetoid, BEFORE the level_data runs its init code, so turfs get linked properly
		SSmapping.register_planetoid_levels(world.maxz + 1, gen_data)
		var/myty                   = new_level_data_types[i]
		var/datum/level_data/LDadj = LAZYACCESS(adjacent_level_data, (stack_height - i) + 1) //stack is filled lowest level first, so we have to match in reverse
		var/datum/level_data/LDnew = SSmapping.increment_world_z_size(myty, TRUE)

		log_debug("\n\t\tLevel Z:[world.maxz], [dir_name(direction_from_root)] of z-level [LDadj?.level_z]")

		//Make sure the level connects to us if we have an adjacent level
		if(LDadj)
			LAZYSET(LDnew.connected_levels, LDadj.level_id, global.reverse_dir[direction_from_root])
			LAZYSET(LDadj.connected_levels, LDnew.level_id, direction_from_root)
		else
			//If we don't have an adjacent level, we're the root level stack and need to set some extra stuff
			if(i == stack_height)
				gen_data.set_topmost_level(LDnew)
			//Make sure we mark the surface level id
			if(i == surface_level_index)
				gen_data.set_surface_level(LDnew)

		LDnew.before_template_generation(src, gen_data) //Apply planet name, etc..
		. += LDnew

	log_debug("\n\tZ-Stack Top:[world.maxz], Direction:[dir_name(direction_from_root)]")
	//Make sure the stack has its stack top object
	var/obj/abstract/map_data/MD = new /obj/abstract/map_data(locate(1, 1, world.maxz), stack_height) //#TODO: maybe combine map_data with level_data?
	MD.SetName("ZStack: [gen_data.name] - [.[length(.)]]")

/datum/map_template/planetoid/load_new_z(no_changeturf = TRUE, centered = TRUE, datum/planetoid_data/gen_data) //centered == false should probably runtime, because it will never work properly
	if(!gen_data)
		gen_data = create_planetoid_instance()
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

	///Create all needed z-levels, tell each of them to generate themselves
	var/list/datum/level_data/new_level_data = generate_levels(gen_data, theme_map_generators)
	//Spawn the ruins and sites on the planet
	generate_features(gen_data, new_level_data, new_ruin_whitelist, new_ruin_blacklist)
	//This awkwardly named proc spawns subtemplates
	after_load()
	//Notify themes we finished gen
	for(var/datum/exoplanet_theme/T in gen_data.themes)
		T.after_map_generation(gen_data)
	//Setup overmap, landing positions, and all the misc things that require the planet to be fully initialized
	after_planet_gen(gen_data, SSmapping.levels_by_id[gen_data.topmost_level_id], SSmapping.levels_by_id[gen_data.surface_level_id])

	for(var/datum/level_data/LD in new_level_data)
		LD.after_template_load(src)
		if(SSlighting.initialized)
			SSlighting.InitializeZlev(LD.level_z)
		log_game("Z-level '[LD.name]'(planetoid:'[name]') loaded at [LD.level_z]")
	loaded++
	return locate(world.maxx/2, world.maxy/2, world.maxz)

/datum/map_template/planetoid/proc/before_planet_gen(var/datum/planetoid_data/gen_data)
	make_planet_name(gen_data)
	select_themes(gen_data)
	generate_habitability(gen_data)
	generate_atmosphere(gen_data)
	for(var/datum/exoplanet_theme/T in gen_data.themes)
		T.adjust_atmosphere(gen_data)
	generate_planet_materials(gen_data)
	generate_planetoid_rings(gen_data)
	generate_ambient_lighting(gen_data)
	gen_data.generate_life()

///Generates data about any possible rings our planet may have
/datum/map_template/planetoid/proc/generate_planetoid_rings(var/datum/planetoid_data/gen_data)
	if(!prob(ring_probability) || !length(possible_ring_type_name))
		return
	gen_data.has_rings      = TRUE
	gen_data.ring_color     = length(possible_ring_color)? pick(possible_ring_color) : COLOR_OFF_WHITE
	gen_data.ring_type_name = pick(possible_ring_type_name)

/datum/map_template/planetoid/proc/after_planet_gen(var/datum/planetoid_data/gen_data, var/datum/level_data/topmost_level_data, var/datum/level_data/surface_level_data)
	//#TODO: Generate vertical z-level connections (holes/stairs/ladders)?

	if(!gen_data.engraving_generator)
		gen_data.set_engraving_generator(new xenoarch_engraving_flavor_type())

	generate_daycycle(gen_data, surface_level_data)
	generate_weather(gen_data, topmost_level_data)
	generate_landing(gen_data, surface_level_data)
	//Fill in the overmap object
	setup_planet_overmap(gen_data, topmost_level_data)

///Generate the planet's minable resources, material for rocks and etc.
/datum/map_template/planetoid/proc/generate_planet_materials(var/datum/planetoid_data/gen_data)
	select_strata(gen_data)
	if(length(possible_rock_colors))
		gen_data.rock_color = pick(possible_rock_colors)

///If the planet doesn't have a name defined, a name will be randomly generated for it.
/datum/map_template/planetoid/proc/make_planet_name(var/datum/planetoid_data/gen_data) //Had to name this proc weird, because of the global generate_planet_name() proc...
	if(!gen_data.name)
		gen_data.SetName(generate_planet_name())

///Call after map is fully generated. Setup the overmap obj to match the planet we just generated.
/datum/map_template/planetoid/proc/setup_planet_overmap(var/datum/planetoid_data/gen_data, var/datum/level_data/topmost_level_data)
	//Try updating any existing ones first
	if(gen_data.overmap_marker)
		var/weakref/W = gen_data.overmap_marker
		var/obj/effect/overmap/visitable/sector/planetoid/P = W.resolve()
		if(istype(P))
			gen_data.set_overmap_marker(P)
			return

	//Ensure the overmap marker path is valid
	if(!ispath(overmap_marker_type, /obj/effect/overmap/visitable/sector/planetoid))
		overmap_marker_type = /obj/effect/overmap/visitable/sector/planetoid
	gen_data.set_overmap_marker(new overmap_marker_type(locate(1,1, topmost_level_data.level_z), topmost_level_data.level_z))

///Setup and populated weather system processing info for the current planetoid.
/datum/map_template/planetoid/proc/generate_weather(var/datum/planetoid_data/gen_data, var/datum/level_data/topmost_level_data)
	if(!ispath(initial_weather_state, /decl/state/weather))
		return
	SSweather.setup_weather_system(topmost_level_data, initial_weather_state)

///Generates the day duration, and whether the planet starts at night.
/datum/map_template/planetoid/proc/generate_daycycle(var/datum/planetoid_data/gen_data, var/datum/level_data/surface_level)
	gen_data.starts_at_night = (surface_level.ambient_light_level > 0.1)
	gen_data.day_duration    = rand(global.config.exoplanet_min_day_duration, global.config.exoplanet_max_day_duration)

///Calculate the color and intensity of the ambient starlight that this planet receives.
/datum/map_template/planetoid/proc/generate_ambient_lighting(var/datum/planetoid_data/gen_data)
	//Try to generate a surface light intensity if we don't have it yet
	if(!gen_data.surface_light_level)
		gen_data.surface_light_level = rand(surface_light_level_min * 100, surface_light_level_max * 100) / 100 //rand() doesn't work on decimal numbers

	//Try to generate surface light color if we don't have any yet
	if(!gen_data.surface_light_color)
		if(length(surface_light_colors))
			//If we have colors to pick from, go for it
			gen_data.surface_light_color = pick(surface_light_colors)
		else
			//Otherwise generate it randomly
			var/atmos_color = gen_data.atmosphere?.get_overall_color() || get_random_colour()
			var/list/HSV    = rgb2num(atmos_color, COLORSPACE_HSV)
			var/sat_factor  = rand(50, 80) / 100 //Make the color less saturated to around 50% to 80%
			var/val_factor  = 1 + (rand(10, 50) / 100) //Make the color brighter within a factor of 10%-50%
			//Scale and clamp to sane-ish values for lighting
			gen_data.surface_light_color = hsv(HSV[1], clamp(round(HSV[2] * sat_factor), 40, 80), clamp(round(HSV[3] * val_factor), 60, 90), 200)

///Selects the base strata for the whole planet. The levels have the final say however in what to do with that.
/datum/map_template/planetoid/proc/select_strata(var/datum/planetoid_data/gen_data)
	var/list/all_strata      = decls_repository.get_decls_of_subtype(/decl/strata)
	var/list/possible_strata = list()

	for(var/stype in all_strata)
		var/decl/strata/strata = all_strata[stype]
		if(strata.is_valid_exoplanet_strata(gen_data))
			possible_strata += stype

	if(length(possible_strata))
		. = pick(possible_strata)
		gen_data.set_strata(.)

///Tries to place landing areas for shuttles on the surface level of the planet. Run after generation is complete to avoid bad surprises!
/datum/map_template/planetoid/proc/generate_landing(var/datum/planetoid_data/gen_data, var/datum/level_data/surface_level)
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
