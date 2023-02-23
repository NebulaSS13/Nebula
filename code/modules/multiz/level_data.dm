/// Returns all the turfs within a zlevel's transition edge, on a given direction
/proc/get_transition_edge_turfs(var/z, var/dir_edge)
	var/datum/level_data/LD = SSmapping.levels_by_z[z]
	switch(dir_edge)
		if(NORTH)
			return block(
				locate(1,              1,                   LD.level_z),
				locate(TRANSITIONEDGE, LD.level_max_height, LD.level_z))
		if(SOUTH)
			return block(
				locate(LD.level_max_width - TRANSITIONEDGE, 1,                   LD.level_z),
				locate(LD.level_max_width,                  LD.level_max_height, LD.level_z))
		if(EAST)
			return block(
				locate(1,                  1,              LD.level_z),
				locate(LD.level_max_width, TRANSITIONEDGE, LD.level_z))
		if(WEST)
			return block(
				locate(1,                  LD.level_max_height - TRANSITIONEDGE, LD.level_z),
				locate(LD.level_max_width, LD.level_max_height,                  LD.level_z))

///Keeps details on how to generate, maintain and access a zlevel
/datum/level_data
	///Name displayed to the player to refer to this level in user interfaces and etc. If null, one will be generated.
	var/name

	/// The z-level that was assigned to this level_data
	var/level_z
	/// A unique string identifier for this particular z-level. Used to fetch a level without knowing its z-level.
	var/level_id
	/// Various flags indicating what this level functions as.
	var/level_flags
	/// The desired width of the level, including the TRANSITIONEDGE. If world.maxx is bigger, the exceeding area will be filled with turfs of "border_filler" type if defined, or base_turf otherwise.
	var/level_max_width
	/// The desired height of the level, including the TRANSITIONEDGE. If world.maxy is bigger, the exceeding area will be filled with turfs of "border_filler" type if defined, or base_turf otherwise.
	var/level_max_height
	/// Filled by map gen on init. Indicates where the accessible level area starts past the transition edge.
	var/tmp/level_inner_x
	/// Filled by map gen on init. Indicates where the accessible level area starts past the transition edge.
	var/tmp/level_inner_y
	/// Filled by map gen on init. Indicates the width of the accessible area within the transition edges.
	var/tmp/level_inner_with
	/// Filled by map gen on init.Indicates the height of the accessible area within the transition edges.
	var/tmp/level_inner_height

	// *** Lighting ***
	/// Set to false to leave dark
	var/take_starlight_ambience = TRUE
	/// This default makes turfs not generate light. Adjust to have exterior areas be lit.
	var/ambient_light_level = 0
	/// Colour of ambient light.
	var/ambient_light_color = COLOR_WHITE

	// *** Level Gen ***
	///The default base turf type for the whole level. It will be the base turf type for the z level, unless loaded by map. filler_turf overrides what turfs the level will be created with.
	var/base_turf = /turf/space
	/// When the level is created dynamically, all turfs on the map will be changed to this one type. If null, will use the base_turf instead.
	var/filler_turf
	///The default area type for the whole level. It will be applied to all turfs in the level on creation, unless loaded by map.
	var/base_area = /area/space
	///The turf to fill the border area beyond the bounds of the level with. If null, nothing will be placed in the border area. (This is also placed when a border cannot be looped if loop_unconnected_borders is TRUE)
	var/border_filler// = /turf/unsimulated/mineral
	/// If set we will put a looping edge on every unconnected edge of the map. If null, will not loop unconnected edges. If an unconnected edge is facing a connected edge, it will be instead filled with "border_filler" instead, if defined.
	var/loop_turf_type// = /turf/unsimulated/mimc_edge/transition/loop
	/// The turf type to use for zlevel lateral connections
	var/transition_turf_type = /turf/unsimulated/mimic_edge/transition

	// *** Atmos ***
	/// Temperature of standard exterior atmosphere.
	var/exterior_atmos_temp = T20C
	/// Gasmix datum returned to exterior return_air. Set to assoc list of material to moles to initialize the gas datum.
	var/datum/gas_mixture/exterior_atmosphere

	// *** Connections ***
	///A list of all level_ids, and a direction. Indicates what direction of the map connects to what level
	var/list/connected_levels
	///A cached list of connected directions to their connected level id
	var/tmp/list/cached_connections

/datum/level_data/New(var/_z_level, var/defer_level_setup = FALSE)
	. = ..()
	level_z = _z_level
	if(isnull(_z_level))
		PRINT_STACK_TRACE("Attempting to initialize a null z-level.")
	if(SSmapping.levels_by_z.len < level_z)
		SSmapping.levels_by_z.len = max(SSmapping.levels_by_z.len, level_z)
		PRINT_STACK_TRACE("Attempting to initialize a z-level([level_z]) that has not incremented world.maxz.")

	// Swap out the old one but preserve any relevant references etc.
	if(SSmapping.levels_by_z[level_z])
		var/datum/level_data/old_level = SSmapping.levels_by_z[level_z]
		old_level.replace_with(src)
		qdel(old_level)

	SSmapping.levels_by_z[level_z] = src
	if(!level_id)
		level_id = "leveldata_[level_z]_[sequential_id(/datum/level_data)]"
	if(level_id in SSmapping.levels_by_id)
		PRINT_STACK_TRACE("Duplicate level_id '[level_id]' for z[level_z].")
	else
		SSmapping.levels_by_id[level_id] = src

	if(SSmapping.initialized && !defer_level_setup)
		setup_level_data()

/datum/level_data/Destroy(force)
	log_debug("Level data datum being destroyed: [log_info_line(src)]")
	//Since this is a datum that lives inside the SSmapping subsystem, I'm not sure if we really need to prevent deletion. It was fine for the obj version of this, but not much point now?
	SSmapping.unregister_level_data(src)
	. = ..()

/datum/level_data/proc/replace_with(var/datum/level_data/new_level)
	new_level.copy_from(src)

/datum/level_data/proc/copy_from(var/datum/level_data/old_level)
	return

///Initialize the turfs on the z-level
/datum/level_data/proc/initialize_new_level()
	var/picked_turf = filler_turf || base_turf //Pick the filler_turf for filling if it's set, otherwise use the base_turf
	var/change_turf = (picked_turf && picked_turf != world.turf)
	var/change_area = (base_area && base_area != world.area)
	if(!change_turf && !change_area)
		return
	var/corner_start = locate(1, 1, level_z)
	var/corner_end =   locate(world.maxx, world.maxy, level_z)
	var/area/A = change_area ? new base_area : null
	for(var/turf/T as anything in block(corner_start, corner_end))
		if(change_turf)
			T = T.ChangeTurf(picked_turf)
		if(change_area)
			ChangeArea(T, A)

/datum/level_data/proc/setup_level_data()
	SSmapping.register_level_data(src)
	setup_level_bounds()
	setup_ambient()
	setup_exterior_atmosphere()
	if(config.generate_map)
		generate_level()
		post_generate_level()

/datum/level_data/proc/setup_level_bounds()
	level_max_width    = level_max_width  ? level_max_width  : world.maxx
	level_max_height   = level_max_height ? level_max_height : world.maxy
	level_inner_x      = TRANSITIONEDGE + 1
	level_inner_y      = TRANSITIONEDGE + 1
	level_inner_with   = level_max_width  - (2 * (TRANSITIONEDGE + 1))
	level_inner_height = level_max_height - (2 * (TRANSITIONEDGE + 1))

/datum/level_data/proc/setup_ambient()
	if(!take_starlight_ambience)
		return
	ambient_light_level = config.exterior_ambient_light
	ambient_light_color = SSskybox.background_color

/datum/level_data/proc/setup_exterior_atmosphere()
	var/list/exterior_atmos_composition = exterior_atmosphere
	exterior_atmosphere = new
	if(islist(exterior_atmos_composition))
		for(var/gas in exterior_atmos_composition)
			exterior_atmosphere.adjust_gas(gas, exterior_atmos_composition[gas], FALSE)
		exterior_atmosphere.temperature = exterior_atmos_temp
		exterior_atmosphere.update_values()
		exterior_atmosphere.check_tile_graphic()

//
// Level Load/Gen
//

///Called when setting up the level. Apply generators and anything that modifies the turfs of the level.
/datum/level_data/proc/generate_level()
	return

///Called during level setup. Run anything that should happen only after the map is fully generated.
/datum/level_data/proc/post_generate_level()
	build_border()

///Called while a map_template is being loaded on our z-level. Only apply to templates loaded onto new z-levels.
/datum/level_data/proc/template_load(var/datum/map_template/template)
	return

///Called after a map_template has been loaded on our z-level. Only apply to templates loaded onto new z-levels.
/datum/level_data/proc/post_template_load(var/datum/map_template/template)
	if(template.accessibility_weight)
		SSmapping.accessible_z_levels[num2text(level_z)] = template.accessibility_weight
	SSmapping.player_levels |= level_z

///Builds the map's transition edge if applicable
/datum/level_data/proc/build_border()
	var/const/static/EDGE_NONE = 0
	var/const/static/EDGE_LOOP = 1
	var/const/static/EDGE_WALL = 2
	var/const/static/EDGE_CON  = 3

	var/list/edge_states = list()
	edge_states.len = 8

	//First determine and validate the borders
	for(var/adir in global.cardinal)
		//First check for connections, or loop
		if(get_connected_level_id(adir))
			edge_states[adir] = EDGE_CON
			var/reverse = global.reverse_dir[adir]
			if(!ispath(loop_turf_type) || (ispath(loop_turf_type) && (edge_states[reverse] == EDGE_CON)))
				continue //Skip filler wall when we're not looping borders or we're looping them and aren't facing a connected edge
			//If we're looping borders and the opposite edge is facing a connected edge, let the default filler wall apply

		else if(ispath(loop_turf_type))
			edge_states[adir] = EDGE_LOOP
			continue //Skip filler wall

		///Apply filler wall last if we have no connections or loop
		if(ispath(border_filler))
			edge_states[adir] = EDGE_WALL
		else
			edge_states[adir] = EDGE_NONE

	//Then apply the borders
	for(var/adir in global.cardinal)
		var/border_type = edge_states[adir]
		if(border_type == EDGE_NONE)
			continue

		var/list/edge_turfs = get_transition_edge_turfs(level_z, adir)
		switch(border_type)
			if(EDGE_LOOP)
				for(var/turf/T in edge_turfs)
					T.ChangeTurf(loop_turf_type)
			if(EDGE_CON)
				for(var/turf/T in edge_turfs)
					T.ChangeTurf(transition_turf_type)
			if(EDGE_WALL)
				for(var/turf/T in edge_turfs)
					T.ChangeTurf(border_filler)

//
// Accessors
//
/datum/level_data/proc/get_exterior_atmosphere()
	if(exterior_atmosphere)
		var/datum/gas_mixture/gas = new
		gas.copy_from(exterior_atmosphere)
		return gas

/datum/level_data/proc/get_display_name()
	if(!name)
		var/obj/effect/overmap/overmap_entity = global.overmap_sectors[num2text(level_z)]
		if(overmap_entity?.name)
			name = overmap_entity.name
		else
			name = "Sector #[level_z]"
	return name

/datum/level_data/proc/get_connected_level_id(var/direction)
	if(!length(cached_connections))
		//Build a list that we can access with the direction value instead of having to do string conversions
		cached_connections = list()
		cached_connections.len = DOWN //Down is the largest of the directional values
		for(var/lvlid in connected_levels)
			cached_connections[connected_levels[lvlid]] = lvlid

	if(istext(direction))
		CRASH("Direction must be a direction flag.")
	return cached_connections[direction]

///Returns recursively a list of level_data for each connected levels.
/datum/level_data/proc/get_all_connected_level_data()
	if(!length(connected_levels))
		return
	. = list()
	for(var/id in connected_levels)
		var/datum/level_data/LD = SSmapping.levels_by_id[id]
		. |= LD
		. |= LD.get_all_connected_level_data()

///Returns recursively a list of level_ids for each connected levels.
/datum/level_data/proc/get_all_connected_level_ids()
	if(!length(connected_levels))
		return
	. = list()
	for(var/id in connected_levels)
		var/datum/level_data/LD = SSmapping.levels_by_id[id]
		. |= LD.level_id
		. |= LD.get_all_connected_level_ids()

///Returns recursively a list of z-level indices for each connected levels.
/datum/level_data/proc/get_all_connected_level_z()
	if(!length(connected_levels))
		return
	. = list()
	for(var/id in connected_levels)
		var/datum/level_data/LD = SSmapping.levels_by_id[id]
		. |= LD.level_z
		. |= LD.get_all_connected_level_z()


/datum/level_data/proc/find_connected_levels(var/list/found)
	for(var/other_id in connected_levels)
		var/datum/level_data/neighbor = SSmapping.levels_by_id[other_id]
		neighbor.add_connected_levels(found)

/datum/level_data/proc/add_connected_levels(var/list/found)
	. = found
	if((level_z in found))
		return
	LAZYADD(found, level_z)
	if(!length(connected_levels))
		return
	for(var/other_id in connected_levels)
		var/datum/level_data/neighbor = SSmapping.levels_by_id[other_id]
		neighbor.add_connected_levels(found)


////////////////////////////////////////////
// Level Data Spawner
////////////////////////////////////////////

/// Mapper helper for spawning a specific level_data datum with the map as it gets loaded
/obj/abstract/landmark/level_data_spawner
	name = "space"
	delete_me = TRUE
	var/level_data_type = /datum/level_data/space

INITIALIZE_IMMEDIATE(/obj/abstract/landmark/level_data_spawner)
/obj/abstract/landmark/level_data_spawner/Initialize()
	var/datum/level_data/LD = new level_data_type(z)
	//Let the mapper forward a level name for the level_data, if none was defined
	if(!length(LD.name) && length(name))
		LD.name = name
	. = ..()

////////////////////////////////////////////
// Mapper Templates
////////////////////////////////////////////
/obj/abstract/landmark/level_data_spawner/player
	level_data_type = /datum/level_data/player_level

/obj/abstract/landmark/level_data_spawner/main_level
	level_data_type = /datum/level_data/main_level

/obj/abstract/landmark/level_data_spawner/admin_level
	level_data_type = /datum/level_data/admin_level

/obj/abstract/landmark/level_data_spawner/debug
	level_data_type = /datum/level_data/debug

/obj/abstract/landmark/level_data_spawner/mining_level
	level_data_type = /datum/level_data/mining_level


////////////////////////////////////////////
// Level Data Implementations
////////////////////////////////////////////
/*
 * Mappable subtypes.
 */
/datum/level_data/space

/datum/level_data/debug
	name = "Debug Level"

/datum/level_data/main_level
	level_flags = (ZLEVEL_STATION|ZLEVEL_CONTACT|ZLEVEL_PLAYER)

/datum/level_data/admin_level
	level_flags = (ZLEVEL_ADMIN|ZLEVEL_SEALED)

/datum/level_data/player_level
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER)

/datum/level_data/exoplanet
	exterior_atmosphere = list(
		/decl/material/gas/oxygen =   MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	exterior_atmos_temp = T20C
	level_flags = (ZLEVEL_PLAYER|ZLEVEL_SEALED)
	take_starlight_ambience = FALSE // This is set up by the exoplanet object.

/datum/level_data/unit_test
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER|ZLEVEL_SEALED)

// Used to generate mining ores etc.
/datum/level_data/mining_level
	level_flags = (ZLEVEL_PLAYER|ZLEVEL_SEALED)
	var/list/mining_turfs

/datum/level_data/mining_level/Destroy()
	mining_turfs = null
	return ..()

/datum/level_data/mining_level/asteroid
	base_turf = /turf/simulated/floor/asteroid

/datum/level_data/mining_level/post_template_load()
	..()
	new /datum/random_map/automata/cave_system(1, 1, level_z, world.maxx, world.maxy)
	new /datum/random_map/noise/ore(1, 1, level_z, world.maxx, world.maxy)
	refresh_mining_turfs()

/datum/level_data/mining_level/proc/refresh_mining_turfs()
	set waitfor = FALSE
	for(var/turf/simulated/floor/asteroid/mining_turf as anything in mining_turfs)
		mining_turf.updateMineralOverlays()
		CHECK_TICK
	mining_turfs = null

// Used as a dummy z-level for the overmap.
/datum/level_data/overmap
	name = "Sensor Display"
	take_starlight_ambience = FALSE // Overmap doesn't care about ambient lighting
