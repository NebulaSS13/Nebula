SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE

	/*
	 * General map, submap and template handling
	 */
	var/list/map_templates =             list()
	var/list/submaps =                   list()
	var/list/map_templates_by_category = list()
	var/list/map_templates_by_type =     list()
	var/list/banned_maps =               list()
	var/list/banned_template_names =     list()

	// Listing .dmm filenames in the file at this location will blacklist any templates that include them from being used.
	// Maps must be the full file path to be properly included. ex. "maps/random_ruins/away_sites/example.dmm"
	var/banned_dmm_location = "config/banned_map_paths.json"
	var/decl/overmap_event_handler/overmap_event_handler

	/*
	 * Z-Level Handling Stuff
	 */
	/// Associative list of levels by strict z-level
	var/list/datum/level_data/levels_by_z =  list()
	/// Associative list of levels by string ID
	var/list/datum/level_data/levels_by_id = list()
	/// List of z-levels containing the 'main map'
	var/list/station_levels = list()
	/// List of z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/admin_levels =   list()
	/// List of z-levels that can be contacted from the station, for eg announcements
	var/list/contact_levels = list()
	/// List of z-levels a character can typically reach
	var/list/player_levels =  list()
	/// List of z-levels that don't allow random transit at edge
	var/list/sealed_levels =  list()
	/// Custom base turf by Z-level. Defaults to world.turf for unlisted Z-levels
	var/list/base_turf_by_z = list()
	/// This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
	var/list/accessible_z_levels = list()
	/// Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.
	var/list/map_levels
	/// The turf type used when generating floors between Z-levels at startup.
	var/base_floor_type = /turf/floor/airless
	/// Replacement area, if a base_floor_type is generated. Leave blank to skip.
	var/base_floor_area
	/// A list of connected z-levels to avoid repeatedly rebuilding connections
	var/list/connected_z_cache = list()
	/// A list of turbolift holders to initialize.
	var/list/turbolifts_to_initialize = list()
	///Associative list of planetoid/exoplanet data currently registered. The key is the planetoid id, the value is the planetoid_data datum.
	var/list/planetoid_data_by_id
	///List of all z-levels in the world where the index corresponds to a z-level, and the key at that index is the planetoid_data datum for the associated planet
	var/list/planetoid_data_by_z = list()
	///A list of queued markers to initialize during SSmapping init.
	var/list/obj/abstract/landmark/map_load_mark/queued_markers = list()

/datum/controller/subsystem/mapping/PreInit()
	reindex_lists()

#ifdef UNIT_TEST
/datum/controller/subsystem/mapping/proc/test_load_map_templates()
	for(var/map_template_name in map_templates)
		var/datum/map_template/map_template = get_template(map_template_name)
		// Away sites are supposed to be tested separately in the Away Site environment
		if(SSunit_tests.is_tested_separately(map_template))
			report_progress("Skipping template '[map_template]' ([map_template.type]): Is tested separately.")
			continue
		if(map_template.is_runtime_generated())
			report_progress("Skipping template '[map_template]' ([map_template.type]): Is generated at runtime.")
			continue
		load_template(map_template)
		if(map_template.template_flags & TEMPLATE_FLAG_TEST_DUPLICATES)
			load_template(map_template)
	log_unit_test("Map templates loaded.")

/datum/controller/subsystem/mapping/proc/load_template(datum/map_template/map_template)
	// Suggestion: Do smart things here to squeeze as many templates as possible into the same Z-level
	if(map_template.tallness == 1)
		increment_world_z_size(/datum/level_data/unit_test)
		var/turf/center = WORLD_CENTER_TURF(world.maxz)
		if(!center)
			CRASH("'[map_template]' (size: [map_template.width]x[map_template.height]) couldn't locate center turf at ([WORLD_CENTER_X][WORLD_CENTER_Y][world.maxz]) with world size ([WORLD_SIZE_TO_STRING])")
		log_unit_test("Loading template '[map_template]' ([map_template.type]) at [log_info_line(center)]")
		map_template.load(center, centered = TRUE)
	else // Multi-Z templates are loaded using different means
		log_unit_test("Loading template '[map_template]' ([map_template.type]) at Z-level [world.maxz+1] with a tallness of [map_template.tallness]")
		map_template.load_new_z()
#endif

/datum/controller/subsystem/mapping/Initialize(timeofday)

#ifdef UNIT_TEST
	// Shouldn't we be forcing this to true?
	set_config_value(/decl/config/toggle/roundstart_level_generation, FALSE)
#endif

	reindex_lists()

	// Load our banned map list, if we have one.
	if(banned_dmm_location && fexists(banned_dmm_location))
		banned_maps = cached_json_decode(safe_file2text(banned_dmm_location))

	// Fetch and track all templates before doing anything that might need one.
	for(var/datum/map_template/MT as anything in get_all_template_instances())
		register_map_template(MT)

	// Load any queued map template markers.
	for(var/obj/abstract/landmark/map_load_mark/queued_mark in queued_markers)
		queued_mark.load_subtemplate()
	queued_markers.Cut()

	// Populate overmap.
	if(length(global.using_map.overmap_ids))
		for(var/overmap_id in global.using_map.overmap_ids)
			var/overmap_type = global.using_map.overmap_ids[overmap_id] || /datum/overmap
			new overmap_type(overmap_id)
	// This needs to be non-null even if the overmap isn't created for this map.
	overmap_event_handler = GET_DECL(/decl/overmap_event_handler)

	var/old_maxz
	for(var/z = 1 to world.maxz)
		var/datum/level_data/level = levels_by_z[z]
		if(!istype(level))
			level = new /datum/level_data/space(z)
			PRINT_STACK_TRACE("Missing z-level data object for z[num2text(z)]!")
		level.setup_level_data()

	old_maxz = world.maxz
	// Build away sites.
	global.using_map.build_away_sites()
	global.using_map.build_planets()

	// Resize the world to the max template size to fix a BYOND bug with world resizing breaking events.
	// REMOVE WHEN THIS IS FIXED: https://www.byond.com/forum/post/2833191
	var/new_maxx = world.maxx
	var/new_maxy = world.maxy
	for(var/map_template_name in map_templates)
		var/datum/map_template/map_template = map_templates[map_template_name]
		new_maxx = max(map_template.width, new_maxx)
		new_maxy = max(map_template.height, new_maxy)
	if (new_maxx > world.maxx)
		world.maxx = new_maxx
	if (new_maxy > world.maxy)
		world.maxy = new_maxy

#ifdef UNIT_TEST
	// Load all map templates if we're unit testing.
	test_load_map_templates()
#endif

	// Check/associated/setup our level data objects.
	for(var/z = old_maxz + 1 to world.maxz)
		var/datum/level_data/level = levels_by_z[z]
		if(!istype(level))
			level = new /datum/level_data/space(z)
			PRINT_STACK_TRACE("Missing z-level data object for z[num2text(z)]!")
		level.setup_level_data()

	// Generate turbolifts last, since away sites may have elevators to generate too.
	for(var/obj/abstract/turbolift_spawner/turbolift as anything in turbolifts_to_initialize)
		turbolift.build_turbolift()

	global.using_map.finalize_map_generation()

	. = ..()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates =             SSmapping.map_templates
	map_templates_by_category = SSmapping.map_templates_by_category
	map_templates_by_type =     SSmapping.map_templates_by_type

/datum/controller/subsystem/mapping/proc/register_map_template(var/datum/map_template/map_template)
	if(!validate_map_template(map_template) || !map_template.preload())
		return FALSE
	map_templates[map_template.name] = map_template
	for(var/temple_cat in map_template.template_categories) // :3
		LAZYINITLIST(map_templates_by_category[temple_cat])
		LAZYSET(map_templates_by_category[temple_cat], map_template.name, map_template)
	return TRUE

/datum/controller/subsystem/mapping/proc/validate_map_template(var/datum/map_template/map_template)
	if(!istype(map_template))
		PRINT_STACK_TRACE("Null or incorrectly typed map template attempted validation.")
		return FALSE
	if(length(banned_maps) && length(map_template.mappaths))
		for(var/mappath in map_template.mappaths)
			if(mappath in banned_maps)
				return FALSE
	if(!isnull(map_templates[map_template.name]))
		PRINT_STACK_TRACE("Duplicate map name '[map_template.name]' on type [map_template.type]!")
		return FALSE
	return TRUE

/datum/controller/subsystem/mapping/proc/get_all_template_instances()
	. = list()
	for(var/template_type in subtypesof(/datum/map_template))
		var/datum/map_template/template = template_type
		if(!TYPE_IS_ABSTRACT(template) && initial(template.template_parent_type) != template_type && initial(template.name))
			. += new template_type(type) // send name as a param to catch people doing illegal ad hoc creation

/datum/controller/subsystem/mapping/proc/get_template(var/template_name)
	return map_templates[template_name]

/datum/controller/subsystem/mapping/proc/get_templates_by_category(var/temple_cat) // :33
	return map_templates_by_category[temple_cat]

/datum/controller/subsystem/mapping/proc/get_template_by_type(var/template_type)
	var/datum/map_template/template = template_type
	var/template_name               = initial(template.name)
	if(template_name)
		return map_templates[template_name]

// Z-Level procs after this point.
/datum/controller/subsystem/mapping/proc/get_gps_level_name(var/z)
	if(z)
		var/datum/level_data/level = levels_by_z[z]
		. = level.get_display_name()
		if(length(.))
			return .
	return "Unknown Sector"

/datum/controller/subsystem/mapping/proc/reindex_lists()
	levels_by_z.len = world.maxz // Populate with nulls so we don't get index errors later.
	base_turf_by_z.len = world.maxz
	planetoid_data_by_z.len = world.maxz
	connected_z_cache.Cut()

	//Update SSWeather's indexed lists, if we can.
	if(SSweather?.weather_by_z)
		SSweather.weather_by_z.len = world.maxz

/datum/controller/subsystem/mapping/proc/increment_world_z_size(var/new_level_type, var/defer_setup = FALSE)

	world.maxz++
	reindex_lists()

	if(SSzcopy.zlev_maximums.len)
		SSzcopy.calculate_zstack_limits()
	if(!new_level_type)
		PRINT_STACK_TRACE("Missing z-level data type for z["[world.maxz]"]!")
		return

	var/datum/level_data/level = new new_level_type(world.maxz, defer_setup)
	level.initialize_new_level()
	return level

/datum/controller/subsystem/mapping/proc/get_connected_levels(z, include_lateral = TRUE)
	if(z <= 0  || z > length(levels_by_z))
		CRASH("Invalid z-level supplied to get_connected_levels: [isnull(z) ? "NULL" : z]")
	var/list/root_stack = list(z)
	// Traverse up and down to get the multiz stack.
	for(var/level = z, HasBelow(level), level--)
		root_stack |= level-1
	for(var/level = z, HasAbove(level), level++)
		root_stack |= level+1
	. = list()
	// Check stack for any laterally connected neighbors.
	if(include_lateral)
		for(var/tz in root_stack)
			var/datum/level_data/level = levels_by_z[tz]
			if(level)
				var/list/cur_connected = level.get_all_connected_level_z()
				if(length(cur_connected))
					. |= cur_connected
	. |= root_stack

///Returns a list of all the level data of all the connected z levels to the given z.DBColumn
/datum/controller/subsystem/mapping/proc/get_connected_levels_data(z)
	if(z <= 0  || z > length(levels_by_z))
		CRASH("Invalid z-level supplied to get_connected_levels_data: [isnull(z) ? "NULL" : z]")
	var/list/root_lvl_data = list(levels_by_z[z])

	// Traverse up and down to get the multiz stack.
	for(var/level = z, HasBelow(level), level--)
		root_lvl_data |= levels_by_z[level - 1]
	for(var/level = z, HasAbove(level), level++)
		root_lvl_data |= levels_by_z[level + 1]

	. = list()
	// Check stack for any laterally connected neighbors.
	for(var/datum/level_data/L in root_lvl_data)
		var/list/cur_connected = L.get_all_connected_level_data()
		if(length(cur_connected))
			. |= cur_connected
	. |= root_lvl_data

/datum/controller/subsystem/mapping/proc/get_connected_levels_ids(z)
	if(z <= 0  || z > length(levels_by_z))
		CRASH("Invalid z-level supplied to get_connected_levels_ids: [isnull(z) ? "NULL" : z]")
	var/datum/level_data/LD = levels_by_z[z]
	var/list/root_lvl_ids = list(LD.level_id)

	// Traverse up and down to get the multiz stack.
	for(var/level = z, HasBelow(level), level--)
		var/datum/level_data/L = levels_by_z[level - 1]
		root_lvl_ids |= L.level_id
	for(var/level = z, HasAbove(level), level++)
		var/datum/level_data/L = levels_by_z[level + 1]
		root_lvl_ids |= L.level_id

	. = list()
	// Check stack for any laterally connected neighbors.
	for(var/id in root_lvl_ids)
		var/datum/level_data/level = levels_by_id[id]
		if(level)
			var/list/cur_connected = level.get_all_connected_level_ids()
			if(length(cur_connected))
				. |= cur_connected
	. |= root_lvl_ids

/datum/controller/subsystem/mapping/proc/are_connected_levels(var/zA, var/zB)
	if (zA <= 0 || zB <= 0 || zA > world.maxz || zB > world.maxz)
		return FALSE
	if (zA == zB)
		return TRUE
	if (length(connected_z_cache) >= zA && length(connected_z_cache[zA]) >= zB)
		return connected_z_cache[zA][zB]
	var/list/levels = get_connected_levels(zA)
	var/list/new_entry = new(world.maxz)
	for (var/entry in levels)
		new_entry[entry] = TRUE
	if (connected_z_cache.len < zA)
		connected_z_cache.len = zA
	connected_z_cache[zA] = new_entry
	return new_entry[zB]

/// Registers all the needed infos from a level_data into the mapping subsystem
/datum/controller/subsystem/mapping/proc/register_level_data(var/datum/level_data/LD)
	if(levels_by_z.len < LD.level_z)
		levels_by_z.len = max(levels_by_z.len, LD.level_z)
		PRINT_STACK_TRACE("Attempting to initialize a z-level([LD.level_z]) that has not incremented world.maxz.")

	//Assign level z
	var/datum/level_data/old_level = levels_by_z[LD.level_z]
	levels_by_z[LD.level_z] = LD

	if(old_level)
		// Swap out the old one but preserve any relevant references etc.
		old_level.replace_with(LD)
		QDEL_NULL(old_level)

	//Setup ID ref
	if(isnull(LD.level_id))
		PRINT_STACK_TRACE("Null level_id specified for z[LD.level_z].")
	else if(LD.level_id in levels_by_id)
		PRINT_STACK_TRACE("Duplicate level_id '[LD.level_id]' for z[LD.level_z].")
	else
		levels_by_id[LD.level_id] = LD

	//Always add base turf for Z. It'll get replaced as needed.
	base_turf_by_z[LD.level_z] = LD.base_turf || world.turf

	//Add to level flags lookup lists
	if(LD.level_flags & ZLEVEL_STATION)
		station_levels |= LD.level_z
	if(LD.level_flags & ZLEVEL_ADMIN)
		admin_levels   |= LD.level_z
	if(LD.level_flags & ZLEVEL_CONTACT)
		contact_levels |= LD.level_z
	if(LD.level_flags & ZLEVEL_PLAYER)
		player_levels  |= LD.level_z
	if(LD.level_flags & ZLEVEL_SEALED)
		sealed_levels  |= LD.level_z
	return TRUE

/datum/controller/subsystem/mapping/proc/unregister_level_data(var/datum/level_data/LD)
	if(levels_by_z[LD.level_z] == LD)
		//Clear the level data ref from the list if we're in it.
		levels_by_z[LD.level_z] = null
	levels_by_id -= LD.level_id

	base_turf_by_z[LD.level_z] = world.turf
	station_levels -= LD.level_z
	admin_levels   -= LD.level_z
	contact_levels -= LD.level_z
	player_levels  -= LD.level_z
	sealed_levels  -= LD.level_z
	return TRUE

///Adds a planetoid/exoplanet's data to the lookup tables. Optionally if the topmost_level_id var is set on P, will automatically assign all linked levels to P.
/datum/controller/subsystem/mapping/proc/register_planetoid(var/datum/planetoid_data/P)
	LAZYSET(planetoid_data_by_id, P.id, P)

	//Keep track of the topmost z-level to speed up looking up things
	var/datum/level_data/LD = levels_by_id[P.topmost_level_id]

	//#TODO: Check if this actually works, because planetoid_data initializes so early it's not clear if the hierarchy can ever be fully available for this
	//If we don't have level_data, we'll skip over assigning by z-level for now
	if(LD)
		//Assign all connected z-levels in the z list
		planetoid_data_by_z[LD.level_z] = P
		for(var/connected_z in get_connected_levels(LD.level_z))
			planetoid_data_by_z[connected_z] = P

	//#TODO: Until we split planet processing from the datum, make sure the planet datums get their process proc called regularly!
	START_PROCESSING(SSobj, P)

///Set the specified planetoid data for the specified level, and its connected levels.
/datum/controller/subsystem/mapping/proc/register_planetoid_levels(var/_z, var/datum/planetoid_data/P)
	LAZYSET(planetoid_data_by_id, P.id, P)
	//Since this will be called before the world's max z is incremented, make sure we're at least as tall as the z we get
	if(length(planetoid_data_by_z) < _z)
		LAZYINITLIST(planetoid_data_by_z)
		planetoid_data_by_z.len = _z
	planetoid_data_by_z[_z] = P

///Removes a planetoid/exoplanet's data from the lookup tables.
/datum/controller/subsystem/mapping/proc/unregister_planetoid(var/datum/planetoid_data/P)
	LAZYREMOVE(planetoid_data_by_id, P.id)

	//Clear our ref in the z list. Don't use the level_id since, we can't guarantee it'll still exist.
	for(var/z = 1 to length(planetoid_data_by_z))
		var/datum/planetoid_data/cur = planetoid_data_by_z[z]
		if(cur && (cur.id == P.id))
			planetoid_data_by_z[z] = null

	STOP_PROCESSING(SSobj, P)

///Called by the roundstart hook once we toggle to in-game state
/datum/controller/subsystem/mapping/proc/start_processing_all_planets()
	for(var/pid in planetoid_data_by_id)
		var/datum/planetoid_data/P = planetoid_data_by_id[pid]
		if(!P)
			continue
		P.begin_processing()

/hook/roundstart/proc/start_processing_all_planets()
	SSmapping.start_processing_all_planets()
	return TRUE
