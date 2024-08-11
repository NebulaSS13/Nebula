/// Returns all the turfs within a zlevel's transition edge, on a given direction.
/// If include corners is true, the corners of the map will be included.
/proc/get_transition_edge_turfs(var/z, var/dir_edge, var/include_corners = FALSE)
	var/datum/level_data/LD = SSmapping.levels_by_z[z]

	//minimum and maximum corners making up the box, between which the transition edge is
	var/min_x = 1 //X of lower left corner of the edge
	var/min_y = 1 //Y of lower left corner of the edge
	var/max_x = 1 //X of upper right corner of the edge
	var/max_y = 1 //Y of upper right corner of the edge

	//Pos before or after the transition edge on either ends of each axis of the level. (Including corners or not)
	var/x_bef_transit = include_corners? (LD.level_inner_min_x - TRANSITIONEDGE) : (LD.level_inner_min_x)
	var/x_aft_transit = include_corners? (LD.level_inner_max_x + TRANSITIONEDGE) : (LD.level_inner_max_x)
	var/y_bef_transit = include_corners? (LD.level_inner_min_y - TRANSITIONEDGE) : (LD.level_inner_min_y)
	var/y_aft_transit = include_corners? (LD.level_inner_max_y + TRANSITIONEDGE) : (LD.level_inner_max_y)

	switch(dir_edge)
		if(NORTH)
			min_x = x_bef_transit
			min_y = LD.level_inner_max_y + 1 //Add one so we're outside the inner area (inner min/max are inclusive)
			max_x = x_aft_transit
			max_y = LD.level_inner_max_y + TRANSITIONEDGE  //End of the transition edge on that axis
		if(SOUTH)
			min_x = x_bef_transit
			min_y = LD.level_inner_min_y - TRANSITIONEDGE
			max_x = x_aft_transit
			max_y = LD.level_inner_min_y - 1
		if(EAST)
			min_x = LD.level_inner_max_x + 1
			min_y = y_bef_transit
			max_x = LD.level_inner_max_x + TRANSITIONEDGE
			max_y = y_aft_transit
		if(WEST)
			min_x = LD.level_inner_min_x - TRANSITIONEDGE
			min_y = y_bef_transit
			max_x = LD.level_inner_min_x - 1
			max_y = y_aft_transit

	return block(
		locate(min_x, min_y, LD.level_z),
		locate(max_x, max_y, LD.level_z)
	)

///Returns all the turfs from all 4 corners of the transition border of a level.
/proc/get_transition_edge_corner_turfs(var/z)
	var/datum/level_data/LD = SSmapping.levels_by_z[z]
	//South-West
	.  = block(
			locate(LD.level_inner_min_x - TRANSITIONEDGE, LD.level_inner_min_y - TRANSITIONEDGE, LD.level_z),
			locate(LD.level_inner_min_x - 1,              LD.level_inner_min_y - 1,              LD.level_z))
	//South-East
	. |= block(
			locate(LD.level_inner_max_x + 1,              LD.level_inner_min_y - TRANSITIONEDGE, LD.level_z),
			locate(LD.level_inner_max_x + TRANSITIONEDGE, LD.level_inner_min_y - 1,              LD.level_z))
	//North-West
	. |= block(
			locate(LD.level_inner_min_x - TRANSITIONEDGE, LD.level_inner_max_y + 1,              LD.level_z),
			locate(LD.level_inner_min_x - 1,              LD.level_inner_max_y + TRANSITIONEDGE, LD.level_z))
	//North-East
	. |= block(
			locate(LD.level_inner_max_x + 1,              LD.level_inner_max_y + 1,              LD.level_z),
			locate(LD.level_inner_max_x + TRANSITIONEDGE, LD.level_inner_max_y + TRANSITIONEDGE, LD.level_z))

///Keeps details on how to generate, maintain and access a zlevel.
/datum/level_data
	///Name displayed to the player to refer to this level in user interfaces and etc. If null, one will be generated.
	var/name
	/// Multiplier applied to damage when falling through this level.
	var/fall_depth = 1
	/// The z-level that was assigned to this level_data
	var/level_z
	/// A unique string identifier for this particular z-level. Used to fetch a level without knowing its z-level.
	var/level_id
	/// Various flags indicating what this level functions as.
	var/level_flags = 0
	/// The desired width of the level, including the TRANSITIONEDGE.
	///If world.maxx is bigger, the exceeding area will be filled with turfs of "border_filler" type if defined, or base_turf otherwise.
	var/level_max_width
	/// The desired height of the level, including the TRANSITIONEDGE.
	///If world.maxy is bigger, the exceeding area will be filled with turfs of "border_filler" type if defined, or base_turf otherwise.
	var/level_max_height

	/// Filled by map gen on init. Indicates where the accessible level area starts past the transition edge.
	var/level_inner_min_x
	/// Filled by map gen on init. Indicates where the accessible level area starts past the transition edge.
	var/level_inner_min_y
	/// Filled by map gen on init. Indicates where the accessible level area starts past the transition edge.
	var/level_inner_max_x
	/// Filled by map gen on init. Indicates where the accessible level area starts past the transition edge.
	var/level_inner_max_y

	/// Filled by map gen on init. Indicates the width of the accessible area within the transition edges.
	var/level_inner_width
	/// Filled by map gen on init.Indicates the height of the accessible area within the transition edges.
	var/level_inner_height

	// *** Lighting ***
	/// Set to false to override with our own.
	var/use_global_exterior_ambience = TRUE
	/// Ambient lighting light intensity turfs on this level should have. Value from 0 to 1.
	var/ambient_light_level = 0
	/// Colour of ambient light for turfs on this level.
	var/ambient_light_color = COLOR_WHITE

	// *** Level Gen ***
	///The mineral strata assigned to this level if any. Set to a path at definition, then to a decl/strata instance at runtime.
	var/decl/strata/strata
	///The base material randomly chosen from the strata for this level.
	var/decl/material/strata_base_material
	///Strata types to forbid from generating on this level.
	var/list/forbid_strata = list(
		/decl/strata/permafrost
	)
	///The default base turf type for the whole level. It will be the base turf type for the z level, unless loaded by map.
	/// filler_turf overrides what turfs the level will be created with.
	var/base_turf = /turf/space
	/// When the level is created dynamically, all turfs on the map will be changed to this one type. If null, will use the base_turf instead.
	var/filler_turf
	///The default area type for the whole level. It will be applied to all turfs in the level on creation, unless loaded by map.
	var/base_area = /area/space
	///The turf to fill the border area beyond the bounds of the level with.
	/// If null, nothing will be placed in the border area. (This is also placed when a border cannot be looped if loop_unconnected_borders is TRUE)
	var/border_filler// = /turf/unsimulated/mineral
	///If set we will put a looping edge on every unconnected edge of the map. If null, will not loop unconnected edges.
	/// If an unconnected edge is facing a connected edge, it will be instead filled with "border_filler" instead, if defined.
	var/loop_turf_type// = /turf/unsimulated/mimc_edge/transition/loop
	/// The turf type to use for zlevel lateral connections
	var/transition_turf_type = /turf/mimic_edge/transition

	// *** Atmos ***
	/// Temperature of standard exterior atmosphere.
	var/exterior_atmos_temp = T20C
	/// Gas mixture datum returned to exterior return_air. Set to assoc list of material to moles to initialize the gas datum.
	var/datum/gas_mixture/exterior_atmosphere

	// *** Connections ***
	///A associative list of all level_ids to a direction bitflag. Indicates what direction of the map connects to what level
	var/list/connected_levels
	///A cached list of connected directions to their connected level id. Filled up at runtime.
	var/tmp/list/cached_connections

	///A list of /datum/random_map types to apply to this level if we're running level generation.
	/// May run before or after parent level gen
	var/list/level_generators

	///Whether the level data was setup already.
	var/tmp/_level_setup_completed = FALSE
	///This is set to prevent spamming the log when a turf has tried to grab our strata before we've been initialized
	var/tmp/_has_warned_uninitialized_strata = FALSE

	VAR_PROTECTED/UT_turf_exceptions_by_door_type // An associate list of door types/list of allowed turfs
	///Determines if edge turfs should be centered on the map dimensions.
	var/origin_is_world_center = TRUE
	/// If not null, this level will register with a daycycle id/type on New().
	var/daycycle_id
	/// Type provided to the above.
	var/daycycle_type = /datum/daycycle/exoplanet

	/// Extra spacing needed between any random level templates and the transition edge of a level.
	/// Note that this is more or less unnecessary if you are using a mapped area that doesn't stretch to the edge of the level.
	var/template_edge_padding = 15

	// Whether or not this level permits things like graffiti and filth to persist across rounds.
	var/permit_persistence = FALSE

/datum/level_data/New(var/_z_level, var/defer_level_setup = FALSE)
	. = ..()
	level_z = _z_level
	if(isnull(_z_level))
		PRINT_STACK_TRACE("Attempting to initialize a null z-level.")

	initialize_level_id()
	SSmapping.register_level_data(src)
	if(SSmapping.initialized && !defer_level_setup)
		setup_level_data()

/datum/level_data/Destroy(force)
	//Since this is a datum that lives inside the SSmapping subsystem, I'm not sure if we really need to prevent deletion.
	// It was fine for the obj version of this, but not much point now?
	SSmapping.unregister_level_data(src)
	. = ..()

///Generates a level_id if none were specified in the datum definition.
/datum/level_data/proc/initialize_level_id()
	if(level_id)
		return
	level_id = "leveldata_[level_z]_[sequential_id(/datum/level_data)]"

///Handle a new level_data datum overwriting us.
/datum/level_data/proc/replace_with(var/datum/level_data/new_level)
	new_level.copy_from(src)

///Handle copying data from a previous level_data we're replacing.
/datum/level_data/proc/copy_from(var/datum/level_data/old_level)
	//#TODO: It's not really clear what should get moved over by default. But putting some time to reflect on this would be good...
	return

///Initialize the turfs on the z-level.
/datum/level_data/proc/initialize_new_level()
	//#TODO: Is it really necessary to do this for any and all levels? Seems mainly useful for space levels?
	var/picked_turf = filler_turf || base_turf //Pick the filler_turf for filling if it's set, otherwise use the base_turf
	var/change_turf = (picked_turf && picked_turf != world.turf)
	var/change_area = (base_area && base_area != world.area)
	if(!change_turf && !change_area)
		return
	var/corner_start = locate(1, 1, level_z)
	var/corner_end =   locate(world.maxx, world.maxy, level_z)
	var/area/A = change_area ? get_base_area_instance() : null
	for(var/turf/T as anything in block(corner_start, corner_end))
		if(change_turf)
			T = T.ChangeTurf(picked_turf)
		if(change_area)
			ChangeArea(T, A)

///Prepare level for being used. Setup borders, lateral z connections, ambient lighting, atmosphere, etc..
/datum/level_data/proc/setup_level_data(var/skip_gen = FALSE)
	if(_level_setup_completed)
		log_debug("level_data for [src], on z [level_z], had setup_level_data called more than once!")
		return //Since we can defer setup, make sure we only setup once

	setup_level_bounds()
	setup_ambient()
	setup_exterior_atmosphere()
	setup_strata()
	if(!skip_gen)
		generate_level()
	after_generate_level()
	_level_setup_completed = TRUE

///Calculate the bounds of the level, the border area, and the inner accessible area.
///   Basically, by default levels are assumed to be loaded relative to the world center, so if they're smaller than the world
///   they get their origin offset so they're in the middle of the world. By default templates are always loaded at origin 1,1.
///   so that's useful to know and have control over!
/datum/level_data/proc/setup_level_bounds()
	//Get the width/height we got for the level and the edges
	level_max_width  = level_max_width  ? level_max_width  : world.maxx
	level_max_height = level_max_height ? level_max_height : world.maxy

	//The width of the accessible inner area of the level between the edges
	level_inner_width  = level_max_width  - (2 * TRANSITIONEDGE)
	level_inner_height = level_max_height - (2 * TRANSITIONEDGE)

	//Get the origin of the lower left corner where the level's edge begins at on the world.
	//#FIXME: This is problematic when dealing with an even width/height
	var/x_origin = origin_is_world_center? max(floor((world.maxx - level_max_width)  / 2), 1) : 1
	var/y_origin = origin_is_world_center? max(floor((world.maxy - level_max_height) / 2), 1) : 1

	//The first x/y that's past the edge and within the accessible level
	level_inner_min_x = x_origin + TRANSITIONEDGE
	level_inner_min_y = y_origin + TRANSITIONEDGE

	//The last x/y that's within the accessible level and before the edge
	level_inner_max_x = ((x_origin + level_max_width)  - TRANSITIONEDGE) - 1
	level_inner_max_y = ((y_origin + level_max_height) - TRANSITIONEDGE) - 1

///Setup ambient lighting for the level
/datum/level_data/proc/setup_ambient()
	if(!use_global_exterior_ambience)
		return
	ambient_light_level = get_config_value(/decl/config/num/exterior_ambient_light)
	ambient_light_color = SSskybox.background_color

///Setup/generate atmosphere for exterior turfs on the level.
/datum/level_data/proc/setup_exterior_atmosphere()
	//Skip setup if we've been set to a ref already
	if(istype(exterior_atmosphere))
		exterior_atmosphere.update_values() //Might as well update
		exterior_atmosphere.check_tile_graphic()
		return
	var/list/exterior_atmos_composition = exterior_atmosphere
	exterior_atmosphere = new
	if(islist(exterior_atmos_composition))
		for(var/gas in exterior_atmos_composition)
			exterior_atmosphere.adjust_gas(gas, exterior_atmos_composition[gas], FALSE)
		exterior_atmosphere.temperature = exterior_atmos_temp
		exterior_atmosphere.update_values()
		exterior_atmosphere.check_tile_graphic()

///Pick a strata for the given level if applicable.
/datum/level_data/proc/setup_strata()
	//If no strata, pick a random one
	if(isnull(strata))
		var/list/all_strata      = decls_repository.get_decls_of_subtype(/decl/strata)
		var/list/possible_strata = list()

		for(var/stype in all_strata)
			var/decl/strata/strata = all_strata[stype]
			if(!is_type_in_list(strata, forbid_strata) && strata.is_valid_level_stratum(src))
				possible_strata += stype

		strata = DEFAULTPICK(possible_strata, GET_DECL(/decl/strata/sedimentary))
	//Make sure we have a /decl/strata instance
	if(ispath(strata))
		strata = GET_DECL(strata)

	//cache the strata base material we picked from the list. So all turfs use the same we picked.
	if(strata && length(strata.base_materials) && !strata_base_material)
		strata_base_material = pick(strata.base_materials)
	if(ispath(strata_base_material, /decl/material))
		strata_base_material = GET_DECL(strata_base_material)
	return strata

//
// Level Load/Gen
//
/// Helper proc for subtemplate generation. Returns a point budget to spend on subtemplates.
/datum/level_data/proc/get_subtemplate_budget()
	return 0
/// Helper proc for subtemplate generation. Returns a string identifier for a general category of template.
/datum/level_data/proc/get_subtemplate_category()
	return
/// Helper proc for subtemplate generation. Returns a bitflag of template flags that must not be present for a subtemplate to be considered available.
/datum/level_data/proc/get_subtemplate_blacklist()
	return
/// Helper proc for subtemplate generation. Returns a bitflag of template flags that must be present for a subtemplate to be considered available.
/datum/level_data/proc/get_subtemplate_whitelist()
	return

///Called when setting up the level. Apply generators and anything that modifies the turfs of the level.
/datum/level_data/proc/generate_level()

	if(!get_config_value(/decl/config/toggle/roundstart_level_generation))
		return

	var/origx = level_inner_min_x
	var/origy = level_inner_min_y
	var/endx  = level_inner_min_x + level_inner_width
	var/endy  = level_inner_min_y + level_inner_height

	// Run level generators.
	for(var/gen_type in level_generators)
		new gen_type(origx, origy, level_z, endx, endy, FALSE, TRUE, get_base_area_instance())

	// Place points of interest.
	var/budget = get_subtemplate_budget()
	if(budget)
		spawn_subtemplates(budget, get_subtemplate_category(), get_subtemplate_blacklist(), get_subtemplate_whitelist())

///Apply the parent entity's map generators. (Planets generally)
///This proc is to give a chance to level_data subtypes to individually chose to ignore the parent generators.
/datum/level_data/proc/apply_map_generators(var/list/map_gen)
	if(!get_config_value(/decl/config/toggle/roundstart_level_generation))
		return
	var/origx = level_inner_min_x
	var/origy = level_inner_min_y
	var/endx  = level_inner_min_x + level_inner_width
	var/endy  = level_inner_min_y + level_inner_height
	for(var/gen_type in map_gen)
		new gen_type(origx, origy, level_z, endx, endy, FALSE, TRUE, get_base_area_instance())

///Called during level setup. Run anything that should happen only after the map is fully generated.
/datum/level_data/proc/after_generate_level()
	build_border()
	if(daycycle_id && daycycle_type)
		SSdaycycle.register_level(level_z, daycycle_id, daycycle_type)

///Changes anything named we may need to rename accordingly to the parent location name. For instance, exoplanets levels.
/datum/level_data/proc/adapt_location_name(var/location_name)
	SHOULD_CALL_PARENT(TRUE)
	if(!base_area || ispath(base_area, /area/space))
		return FALSE
	return TRUE

//#TODO: this could probably be done in a more elegant way. Since most map templates will never call this.
///Called before a runtime generated template is generated on our z-level. Only applies to templates generated onto new z-levels.
/// Is never called by templates which are loaded from file!
/datum/level_data/proc/before_template_generation(var/datum/map_template/template)
	return

///Called after a map_template has been loaded on our z-level. Only apply to templates loaded onto new z-levels.
/datum/level_data/proc/after_template_load(var/datum/map_template/template)
	if(template.accessibility_weight)
		SSmapping.accessible_z_levels[num2text(level_z)] = template.accessibility_weight
	SSmapping.player_levels |= level_z

///Builds the map's transition edge if applicable
/datum/level_data/proc/build_border()
	var/list/edge_states = compute_level_edges_states()
	for(var/edge_dir in global.cardinal)
		build_border_edge(edge_states[edge_dir], edge_dir)

	//Now prepare the corners of the border
	build_border_corners()

///Loop through the edges of the level and determine if they're connected, looping, filled, or untouched.
/datum/level_data/proc/compute_level_edges_states()
	var/list/edge_states = list()
	edge_states.len = 8 //Largest cardinal direction is WEST or 8
	var/should_loop_edges = ispath(loop_turf_type)
	var/has_filler_edge   = ispath(border_filler)

	//First determine and validate the borders
	for(var/adir in global.cardinal)
		//First check for connections, or loop
		if(get_connected_level_id(adir))
			edge_states[adir] = LEVEL_EDGE_CON
			var/reverse = global.reverse_dir[adir]
			//When facing a connected edge that wasn't set yet, make sure we don't put a loop edge opposite of it.
			if(should_loop_edges && ((edge_states[reverse] == LEVEL_EDGE_LOOP) || !edge_states[reverse]))
				edge_states[reverse] = has_filler_edge? LEVEL_EDGE_WALL : LEVEL_EDGE_NONE

		if(edge_states[adir])
			continue //Skip edges which either connect to another z-level, or have been forced to a specific type already
		if(should_loop_edges)
			edge_states[adir] = LEVEL_EDGE_LOOP
		else if(ispath(border_filler))
			edge_states[adir] = LEVEL_EDGE_WALL //Apply filler wall last if we have no connections or loop
		else
			edge_states[adir] = LEVEL_EDGE_NONE

	return edge_states

///Apply the specified edge type to the specified edge's turfs
/datum/level_data/proc/build_border_edge(var/edge_type, var/edge_dir)
	if(edge_type == LEVEL_EDGE_NONE)
		return

	var/list/edge_turfs
	switch(edge_type)
		if(LEVEL_EDGE_LOOP)
			edge_turfs = get_transition_edge_turfs(level_z, edge_dir, FALSE)
			for(var/turf/T in edge_turfs)
				T.ChangeTurf(loop_turf_type)
		if(LEVEL_EDGE_CON)
			edge_turfs = get_transition_edge_turfs(level_z, edge_dir, FALSE)
			for(var/turf/T in edge_turfs)
				T.ChangeTurf(transition_turf_type)
		if(LEVEL_EDGE_WALL)
			edge_turfs = get_transition_edge_turfs(level_z, edge_dir, TRUE)
			for(var/turf/T in edge_turfs)
				T.ChangeTurf(border_filler)

///Handle preparing the level's border's corners after we've stup the edges.
/datum/level_data/proc/build_border_corners()
	if(!border_filler)
		return
	//Now prepare the corners of the border
	var/list/all_corner_turfs = get_transition_edge_corner_turfs(level_z)
	for(var/turf/T in all_corner_turfs)
		T.ChangeTurf(border_filler) //Fill corners with border turf

//
// Accessors
//
/datum/level_data/proc/get_exterior_atmosphere()
	if(!exterior_atmosphere)
		return
	var/datum/gas_mixture/gas = new
	gas.copy_from(exterior_atmosphere)
	if(daycycle_id)
		var/datum/daycycle/daycycle = SSdaycycle.get_daycycle(daycycle_id)
		var/temp_mod = daycycle?.current_period?.temperature
		if(!isnull(temp_mod))
			gas.temperature = max(1, gas.temperature + temp_mod)
			gas.update_values()
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
/datum/level_data/proc/get_all_connected_level_data(var/list/_connected_siblings)
	. = list()
	//Since levels may refer to eachothers, make sure we're in the siblings list to avoid infinite recursion
	LAZYDISTINCTADD(_connected_siblings, src)
	for(var/id in connected_levels)
		var/datum/level_data/LD = SSmapping.levels_by_id[id]
		if(LD in _connected_siblings)
			continue
		. |= LD
		var/list/cur_con = LD.get_all_connected_level_data(_connected_siblings)
		if(length(cur_con))
			. |= cur_con

///Returns recursively a list of level_ids for each connected levels.
/datum/level_data/proc/get_all_connected_level_ids(var/list/_connected_siblings)
	. = list()
	//Since levels may refer to eachothers, make sure we're in the siblings list to avoid infinite recursion
	LAZYDISTINCTADD(_connected_siblings, level_id)
	for(var/id in connected_levels)
		var/datum/level_data/LD = SSmapping.levels_by_id[id]
		if(LD.level_id in _connected_siblings)
			continue
		. |= LD.level_id
		var/list/cur_con = LD.get_all_connected_level_ids(_connected_siblings)
		if(length(cur_con))
			. |= cur_con

///Returns recursively a list of z-level indices for each connected levels. Parameter is to keep trakc
/datum/level_data/proc/get_all_connected_level_z(var/list/_connected_siblings)
	. = list()
	//Since levels may refer to eachothers, make sure we're in the siblings list to avoid infinite recursion
	LAZYDISTINCTADD(_connected_siblings, level_z)
	for(var/id in connected_levels)
		var/datum/level_data/LD = SSmapping.levels_by_id[id]
		if(LD.level_z in _connected_siblings)
			continue
		. |= LD.level_z
		. |= LD.get_all_connected_level_z(_connected_siblings)


/datum/level_data/proc/find_connected_levels(var/list/found)
	LAZYDISTINCTADD(found, level_z)
	for(var/other_id in connected_levels)
		var/datum/level_data/neighbor = SSmapping.levels_by_id[other_id]
		if(neighbor.level_z in found)
			continue
		LAZYADD(found, neighbor.level_z)
		if(!length(neighbor.connected_levels))
			continue
		neighbor.find_connected_levels(found)

///Returns the instance of the base area for this level
/datum/level_data/proc/get_base_area_instance()
	var/area/found = locate(base_area)
	if(found)
		return found
	if(ispath(base_area))
		return new base_area
	return locate(world.area)

///Warns exactly once about a turf trying to initialize it's strata from us when we haven't completed setup.
/datum/level_data/proc/warn_bad_strata(var/turf/T)
	if(_has_warned_uninitialized_strata)
		return
	PRINT_STACK_TRACE("Turf tried to init its strata before it was setup for level '[level_id]' z:[level_z]! [log_info_line(T)]")
	_has_warned_uninitialized_strata = TRUE

////////////////////////////////////////////
// Level Data Spawner
////////////////////////////////////////////

/// Mapper helper for spawning a specific level_data datum with the map as it gets loaded
/obj/abstract/level_data_spawner
	name = "space"
	icon_state = "level_data"
	is_spawnable_type = FALSE
	var/level_data_type = /datum/level_data/space

INITIALIZE_IMMEDIATE(/obj/abstract/level_data_spawner)
/obj/abstract/level_data_spawner/Initialize()
	var/datum/level_data/LD = new level_data_type(z)
	//Let the mapper forward a level name for the level_data, if none was defined
	if(!length(LD.name) && length(name))
		LD.name = name
	..()
	return INITIALIZE_HINT_QDEL

////////////////////////////////////////////
// Mapper Templates
////////////////////////////////////////////
/obj/abstract/level_data_spawner/player
	level_data_type = /datum/level_data/player_level

/obj/abstract/level_data_spawner/main_level
	level_data_type = /datum/level_data/main_level

/obj/abstract/level_data_spawner/admin_level
	level_data_type = /datum/level_data/admin_level

/obj/abstract/level_data_spawner/debug
	level_data_type = /datum/level_data/debug

/obj/abstract/level_data_spawner/mining_level
	level_data_type = /datum/level_data/mining_level


////////////////////////////////////////////
// Level Data Implementations
////////////////////////////////////////////
/datum/level_data/space
	daycycle_id = "space_solars"
	daycycle_type = /datum/daycycle/solars

/datum/level_data/debug
	name = "Debug Level"

/datum/level_data/main_level
	level_flags = (ZLEVEL_STATION|ZLEVEL_CONTACT|ZLEVEL_PLAYER)
	permit_persistence = TRUE

/datum/level_data/admin_level
	level_flags = (ZLEVEL_ADMIN|ZLEVEL_SEALED)

/datum/level_data/player_level
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER)
	permit_persistence = TRUE

/datum/level_data/unit_test
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER|ZLEVEL_SEALED)
	filler_turf = /turf/unsimulated/dark_filler

/datum/level_data/overmap
	name = "Sensor Display"
	level_flags = ZLEVEL_SEALED
	use_global_exterior_ambience = FALSE // Overmap doesn't care about ambient lighting
	base_turf = /turf/unsimulated/dark_filler
	transition_turf_type = null

/datum/level_data/mining_level
	level_flags = (ZLEVEL_PLAYER|ZLEVEL_SEALED)
	var/list/mining_turfs

/datum/level_data/mining_level/Destroy()
	mining_turfs = null
	return ..()

/datum/level_data/mining_level/asteroid
	base_turf = /turf/floor/natural/barren
	level_generators = list(
		/datum/random_map/automata/cave_system,
		/datum/random_map/noise/ore
	)

/datum/level_data/proc/get_subtemplate_areas(template_category, blacklist, whitelist)
	return list(base_area)

///Try to allocate the given amount of POIs onto our level. Returns the template types that were spawned
/datum/level_data/proc/spawn_subtemplates(budget = 0, template_category, blacklist, whitelist)

	if(budget <= 0)
		return

	var/list/possible_subtemplates = list()
	var/list/all_subtemplates = SSmapping.get_templates_by_category(template_category)
	for(var/poi_name in all_subtemplates)
		var/datum/map_template/poi = all_subtemplates[poi_name]
		var/poi_tags = poi.get_template_tags()
		if(whitelist && !(whitelist & poi_tags))
			continue
		if(blacklist & poi_tags)
			continue
		possible_subtemplates += poi

	if(!length(possible_subtemplates))
		return //If we don't have any templates, don't bother

	if(!length(possible_subtemplates))
		log_world("Level [level_id] was given no templates to pick from.")
		return

	var/list/repeatable_templates = list()
	var/list/areas_whitelist = get_subtemplate_areas(template_category, blacklist, whitelist)
	var/list/candidate_points_of_interest = possible_subtemplates.Copy()
	//Each iteration needs to either place a subtemplate or strictly decrease either the budget or templates list length (or break).
	while(length(candidate_points_of_interest) && (budget > 0))
		var/datum/map_template/R = pick(candidate_points_of_interest)
		if((R.get_template_cost() <= budget) && !LAZYISIN(SSmapping.banned_template_names, R.name) && try_place_subtemplate(R, areas_whitelist))
			LAZYADD(., R)
			budget -= R.get_template_cost()
			//Mark spawned no-duplicate POI globally
			if(!(R.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
				LAZYDISTINCTADD(SSmapping.banned_template_names, R.name)
			if(R.template_flags & TEMPLATE_FLAG_GENERIC_REPEATABLE)
				repeatable_templates |= R
		candidate_points_of_interest -= R

		// Generic repeatable templates can be picked again if we have remaining budget.
		if(!length(candidate_points_of_interest) && budget > 0 && length(repeatable_templates))
			candidate_points_of_interest = repeatable_templates.Copy()
			repeatable_templates = list()

	if(budget > 0)
		log_world("Level [level_id] had no templates to pick from with [budget] left to spend.")

///Attempts several times to find turfs where a subtemplate can be placed.
/datum/level_data/proc/try_place_subtemplate(var/datum/map_template/template, var/list/area_whitelist)
	//#FIXME: Isn't trying to fit in a subtemplate by rolling randomly a bit inneficient?
	// Try to place it
	var/template_full_width  = (2 * template_edge_padding) + template.width
	var/template_full_height = (2 * template_edge_padding) + template.height
	if((template_full_width > level_inner_width) || (template_full_height > level_inner_height)) // Too big and will never fit.
		return //Return if it won't even fit on the entire level

	var/template_half_width  = template_edge_padding + round(template.width/2)  //Half the template size plus the map edge spacing, for testing from the centerpoint
	var/template_half_height = template_edge_padding + round(template.height/2)
	//Try to fit it in somehwere a few times, then give up if we can't
	var/sanity = 20
	while(sanity > 0)
		sanity--
		//Pick coordinates inside the level's border within which the template will fit. Including the extra template spacing from the level's borders.
		var/cturf_x = rand(level_inner_min_x + template_half_width,  level_inner_max_x - template_half_width)
		var/cturf_y = rand(level_inner_min_y + template_half_height, level_inner_max_y - template_half_height)
		var/turf/T  = locate(cturf_x, cturf_y, level_z)
		var/valid   = TRUE

		//#TODO: There's definitely a way to cache what turfs use an area, to avoid doing this for every single templates!
		//       Could also probably cache TURF_FLAG_NO_POINTS_OF_INTEREST turfs globally.
		var/list/affected_turfs = template.get_affected_turfs(T, TRUE)
		for(var/turf/test_turf in affected_turfs)
			var/area/A = get_area(test_turf)
			if((length(area_whitelist) && !is_type_in_list(A, area_whitelist)) || (test_turf.turf_flags & TURF_FLAG_NO_POINTS_OF_INTEREST))
				valid = FALSE
				break //Break out of the turf check loop, and grab a new set of coordinates
		if(!valid)
			continue
		log_world("Spawned template \"[template.name]\", center: ([T.x], [T.y], [T.z]), min: ([T.x - template_half_width], [T.y - template_half_height]), max: ([T.x + template_half_width], [T.y + template_half_height])")
		load_subtemplate(T, template)
		return template

///Actually handles loading a template template at the given turf.
/datum/level_data/proc/load_subtemplate(turf/central_turf, datum/map_template/template)
	if(!template)
		return FALSE
	for(var/turf/T in template.get_affected_turfs(central_turf, TRUE))
		for(var/mob/living/simple_animal/monster in T)
			qdel(monster)
	template.load(central_turf, centered = TRUE)
	return TRUE

/datum/level_data/proc/update_turf_ambience()
	if(SSatoms.atom_init_stage >= INITIALIZATION_INNEW_REGULAR)
		for(var/turf/level_turf as anything in block(locate(level_inner_min_x, level_inner_min_y, level_z), locate(level_inner_max_x, level_inner_max_y, level_z)))
			level_turf.update_ambient_light_from_z_or_area() // SSambience.queued |= level_turf - seems to be less consistent
			CHECK_TICK
