SUBSYSTEM_DEF(zlevels)
	name = "Z-Levels"
	flags = SS_NO_FIRE
	init_order = SS_INIT_ZLEVELS

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

/datum/controller/subsystem/zlevels/Initialize(start_timeofday)
	for(var/z = 1 to world.maxz)
		var/obj/abstract/level_data/level = levels_by_z["[z]"]
		if(!level)
			log_warning("No level data found for z[z], generating a filler level object.")
			level = new /obj/abstract/level_data/filler(locate(round(world.maxx*0.5), round(world.maxz*0.5), z))
		level.setup_level_data()
		report_progress("z[z]: [get_level_name(z)]")
	. = ..()

/datum/controller/subsystem/zlevels/proc/get_level_name(var/z)
	z = "[z]"
	if(!z)
		return "Unknown Sector"
	var/obj/abstract/level_data/level = levels_by_z[z]
	if(level?.name)
		return level.name
	var/obj/effect/overmap/overmap_entity = global.overmap_sectors[z]
	if(overmap_entity?.name)
		return overmap_entity.name
	return "Sector #[z]"

/datum/controller/subsystem/zlevels/proc/increment_world_z_size(var/new_level_type = /obj/abstract/level_data/filler, var/defer_setup = FALSE)
	world.maxz++
	connected_z_cache.Cut()
	if(SSzcopy.zlev_maximums.len)
		SSzcopy.calculate_zstack_limits()
	var/obj/abstract/level_data/level = new new_level_type(locate(round(world.maxx*0.5), round(world.maxz*0.5), world.maxz), defer_setup)
	if(level.base_turf_type && level.base_turf_type != world.turf)
		for(var/turf/T as anything in block(locate(1, 1, .),locate(world.maxx, world.maxy, level.my_z)))
			T.ChangeTurf(level.base_turf_type)
	return level

/datum/controller/subsystem/zlevels/proc/levels_are_z_connected(var/za, var/zb)
	return (za > 0 && zb > 0 && za <= world.maxz && zb <= world.maxz) && ((za == zb) || ((length(connected_z_cache) >= za && connected_z_cache[za] && length(connected_z_cache[za]) >= zb) ? connected_z_cache[za][zb] : are_connected_levels(za, zb)))

/datum/controller/subsystem/zlevels/proc/get_connected_levels(z)
	. = list(z)
	// Traverse up and down to get the multiz stack.
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1
	// Check stack for any laterally connected neighbors.
	for(var/tz in .)
		var/obj/abstract/level_data/level = levels_by_z["[tz]"]
		if(level)
			level.find_connected_levels(.)

/datum/controller/subsystem/zlevels/proc/are_connected_levels(var/zA, var/zB)
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
