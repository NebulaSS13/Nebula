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

	// Listing .dmm filenames in the file at this location will blacklist any templates that include them from being used.
	// Maps must be the full file path to be properly included. ex. "maps/random_ruins/away_sites/example.dmm"
	var/banned_dmm_location = "config/banned_map_paths.json"
	var/decl/overmap_event_handler/overmap_event_handler

	/*
	 * Z-Level Handling Stuff
	 */
	/// Associative list of levels by strict z-level
	var/list/levels_by_z =  list()
	/// Associative list of levels by string ID
	var/list/levels_by_id = list()
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
	var/base_floor_type = /turf/simulated/floor/airless
	/// Replacement area, if a base_floor_type is generated. Leave blank to skip.
	var/base_floor_area
	/// A list of connected z-levels to avoid repeatedly rebuilding connections
	var/list/connected_z_cache = list()

/datum/controller/subsystem/mapping/PreInit()
	reindex_lists()

/datum/controller/subsystem/mapping/Initialize(timeofday)

	// Load our banned map list, if we have one.
	if(banned_dmm_location && fexists(banned_dmm_location))
		banned_maps = cached_json_decode(safe_file2text(banned_dmm_location))

	// Fetch and track all templates before doing anything that might need one.
	for(var/datum/map_template/MT as anything in get_all_template_instances())
		register_map_template(MT)

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

	// Populate overmap.
	if(length(global.using_map.overmap_ids))
		for(var/overmap_id in global.using_map.overmap_ids)
			var/overmap_type = global.using_map.overmap_ids[overmap_id] || /datum/overmap
			new overmap_type(overmap_id)
	// This needs to be non-null even if the overmap isn't created for this map.
	overmap_event_handler = GET_DECL(/decl/overmap_event_handler)

	// Build away sites.
	global.using_map.build_away_sites()

	// Initialize z-level objects.
#ifdef UNIT_TEST
	config.generate_map = TRUE
#endif
	for(var/z = 1 to world.maxz)
		var/obj/abstract/level_data/level = levels_by_z[z]
		if(!istype(level))
			level = new /obj/abstract/level_data/space(locate(round(world.maxx*0.5), round(world.maxy*0.5), z))
			PRINT_STACK_TRACE("Missing z-level data object for z[num2text(z)]!")
		level.setup_level_data()

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
		if(initial(template.template_parent_type) != template_type && initial(template.name))
			. += new template_type(type) // send name as a param to catch people doing illegal ad hoc creation

/datum/controller/subsystem/mapping/proc/get_template(var/template_name)
	return map_templates[template_name]

/datum/controller/subsystem/mapping/proc/get_templates_by_category(var/temple_cat) // :33
	return map_templates_by_category[temple_cat]

// Z-Level procs after this point.
/datum/controller/subsystem/mapping/proc/get_gps_level_name(var/z)
	if(z)
		var/obj/abstract/level_data/level = levels_by_z[z]
		if(level?.name)
			return level.get_gps_level_name()
	return "Unknown Sector"

/datum/controller/subsystem/mapping/proc/reindex_lists()
	levels_by_z.len = world.maxz // Populate with nulls so we don't get index errors later.
	base_turf_by_z.len = world.maxz
	connected_z_cache.Cut()

/datum/controller/subsystem/mapping/proc/increment_world_z_size(var/new_level_type, var/defer_setup = FALSE)

	world.maxz++
	reindex_lists()

	if(SSzcopy.zlev_maximums.len)
		SSzcopy.calculate_zstack_limits()
	if(!new_level_type)
		PRINT_STACK_TRACE("Missing z-level data type for z["[world.maxz]"]!")
		return

	var/obj/abstract/level_data/level = new new_level_type(locate(round(world.maxx*0.5), round(world.maxz*0.5), world.maxz), defer_setup)
	level.initialize_level()
	return level

/datum/controller/subsystem/mapping/proc/get_connected_levels(z)
	if(z <= 0  || z > length(levels_by_z))
		CRASH("Invalid z-level supplied to get_connected_levels: [isnull(z) ? "NULL" : z]")
	. = list(z)
	// Traverse up and down to get the multiz stack.
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1
	// Check stack for any laterally connected neighbors.
	for(var/tz in .)
		var/obj/abstract/level_data/level = levels_by_z[tz]
		if(level)
			level.find_connected_levels(.)

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
