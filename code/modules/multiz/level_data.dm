#define ZLEVEL_STATION BITFLAG(0)
#define ZLEVEL_ADMIN   BITFLAG(1)
#define ZLEVEL_CONTACT BITFLAG(2)
#define ZLEVEL_PLAYER  BITFLAG(3)
#define ZLEVEL_SEALED  BITFLAG(4)

/obj/abstract/level_data
	/// Name displayed on GPS when this sector is shown.
	var/gps_name
	/// z-level associated with this datum
	var/my_z
	/// A unique identifier for the level, used for SSmapping looup
	var/level_id
	/// The base turf of the level (space, rock, etc)
	var/base_turf
	/// A list of ids that this level connects to horizontally.
	var/list/connects_to
	/// Various flags indicating what this level functions as.
	var/level_flags
	/// Temperature of standard exterior atmosphere.
	var/exterior_atmos_temp = T20C
	/// Gaxmix datum returned to exterior return_air. Set to assoc list of material to moles to initialize the gas datum.
	var/datum/gas_mixture/exterior_atmosphere
	/// Default turf for this level on creation (if created via z-level incrementing)
	var/created_base_turf_type = /turf/space
	/// Default area for this level on creation (as above)
	var/created_base_area_type = /area/space
	/// Set to false to leave dark
	var/take_starlight_ambience = TRUE
	/// This default makes turfs not generate light. Adjust to have exterior areas be lit.
	var/ambient_light_level = 0
	/// Colour of ambient light.
	var/ambient_light_color = COLOR_WHITE

INITIALIZE_IMMEDIATE(/obj/abstract/level_data)
/obj/abstract/level_data/Initialize(var/ml, var/defer_level_setup = FALSE)
	. = ..()

	my_z = z
	forceMove(null)

	if(SSmapping.levels_by_z.len < my_z)
		SSmapping.levels_by_z.len = max(SSmapping.levels_by_z.len, my_z)
		PRINT_STACK_TRACE("Attempting to initialize a z-level that has not incremented world.maxz.")

	// Swap out the old one but preserve any relevant references etc.
	if(SSmapping.levels_by_z[my_z])
		var/obj/abstract/level_data/old_level = SSmapping.levels_by_z[my_z]
		old_level.replace_with(src)
		qdel(old_level)

	SSmapping.levels_by_z[my_z] = src
	if(!level_id)
		level_id = "leveldata_[my_z]_[sequential_id(/obj/abstract/level_data)]"
	if(level_id in SSmapping.levels_by_id)
		PRINT_STACK_TRACE("Duplicate level_id '[level_id]' for z[my_z].")
	else
		SSmapping.levels_by_id[level_id] = src

	if(SSmapping.initialized && !defer_level_setup)
		setup_level_data()

/obj/abstract/level_data/proc/post_template_load(var/datum/map_template/template)
	if(template.accessibility_weight)
		SSmapping.accessible_z_levels[num2text(my_z)] = template.accessibility_weight
	SSmapping.player_levels |= my_z

/obj/abstract/level_data/Destroy(var/force)
	if(force)
		new type(locate(round(world.maxx/2), round(world.maxy/2), my_z))
		return ..()
	return QDEL_HINT_LETMELIVE

/obj/abstract/level_data/proc/replace_with(var/obj/abstract/level_data/new_level)
	new_level.copy_from(src)

/obj/abstract/level_data/proc/copy_from(var/obj/abstract/level_data/old_level)
	return

/obj/abstract/level_data/proc/initialize_level()
	var/change_turf = (created_base_turf_type && created_base_turf_type != world.turf)
	var/change_area = (created_base_area_type && created_base_area_type != world.area)
	if(!change_turf && !change_area)
		return
	var/corner_start = locate(1, 1, my_z)
	var/corner_end =   locate(world.maxx, world.maxy, my_z)
	var/area/A = change_area ? new created_base_area_type : null
	for(var/turf/T as anything in block(corner_start, corner_end))
		if(change_turf)
			T = T.ChangeTurf(created_base_turf_type)
		if(change_area)
			ChangeArea(T, A)

/obj/abstract/level_data/proc/setup_level_data()

	if(take_starlight_ambience)
		ambient_light_level = config.exterior_ambient_light
		ambient_light_color = SSskybox.background_color
	if(base_turf)
		SSmapping.base_turf_by_z[my_z] = base_turf
	if(level_flags & ZLEVEL_STATION)
		SSmapping.station_levels |= my_z
	if(level_flags & ZLEVEL_ADMIN)
		SSmapping.admin_levels   |= my_z
	if(level_flags & ZLEVEL_CONTACT)
		SSmapping.contact_levels |= my_z
	if(level_flags & ZLEVEL_PLAYER)
		SSmapping.player_levels  |= my_z
	if(level_flags & ZLEVEL_SEALED)
		SSmapping.sealed_levels  |= my_z

	build_exterior_atmosphere()
	if(config.generate_map)
		build_level()

/obj/abstract/level_data/proc/build_level()
	return

/obj/abstract/level_data/proc/find_connected_levels(var/list/found)
	for(var/other_id in connects_to)
		var/obj/abstract/level_data/neighbor = SSmapping.levels_by_id[other_id]
		neighbor.add_connected_levels(found)

/obj/abstract/level_data/proc/add_connected_levels(var/list/found)
	. = found
	if((my_z in found))
		return
	LAZYADD(found, my_z)
	if(!length(connects_to))
		return
	for(var/other_id in connects_to)
		var/obj/abstract/level_data/neighbor = SSmapping.levels_by_id[other_id]
		neighbor.add_connected_levels(found)

/obj/abstract/level_data/proc/build_exterior_atmosphere()
	var/list/exterior_atmos_composition = exterior_atmosphere
	exterior_atmosphere = new
	if(islist(exterior_atmos_composition))
		for(var/gas in exterior_atmos_composition)
			exterior_atmosphere.adjust_gas(gas, exterior_atmos_composition[gas], FALSE)
		exterior_atmosphere.temperature = exterior_atmos_temp
		exterior_atmosphere.update_values()
		exterior_atmosphere.check_tile_graphic()

/obj/abstract/level_data/proc/get_exterior_atmosphere()
	if(exterior_atmosphere)
		var/datum/gas_mixture/gas = new
		gas.copy_from(exterior_atmosphere)
		return gas

/obj/abstract/level_data/proc/get_gps_level_name()
	if(!gps_name)
		var/obj/effect/overmap/overmap_entity = global.overmap_sectors[num2text(z)]
		if(overmap_entity?.name)
			gps_name = overmap_entity.name
		else if(name)
			gps_name = name
		else
			gps_name = "Sector #[my_z]"
	return gps_name

/*
 * Mappable subtypes.
 */
/obj/abstract/level_data/debug
	name = "Debug Level"

/obj/abstract/level_data/main_level
	level_flags = (ZLEVEL_STATION|ZLEVEL_CONTACT|ZLEVEL_PLAYER)

/obj/abstract/level_data/admin_level
	level_flags = (ZLEVEL_ADMIN|ZLEVEL_SEALED)

/obj/abstract/level_data/player_level
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER)

/obj/abstract/level_data/space

/obj/abstract/level_data/exoplanet
	exterior_atmosphere = list(
		/decl/material/gas/oxygen =   MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	exterior_atmos_temp = T20C
	level_flags = (ZLEVEL_PLAYER|ZLEVEL_SEALED)
	take_starlight_ambience = FALSE // This is set up by the exoplanet object.

/obj/abstract/level_data/unit_test
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER|ZLEVEL_SEALED)

// Used to generate mining ores etc.
/obj/abstract/level_data/mining_level
	level_flags = (ZLEVEL_PLAYER|ZLEVEL_SEALED)
	var/list/mining_turfs

/obj/abstract/level_data/mining_level/Destroy()
	mining_turfs = null
	return ..()

/obj/abstract/level_data/mining_level/asteroid
	base_turf = /turf/simulated/floor/asteroid

/obj/abstract/level_data/mining_level/post_template_load()
	..()
	new /datum/random_map/automata/cave_system(1, 1, my_z, world.maxx, world.maxy)
	new /datum/random_map/noise/ore(1, 1, my_z, world.maxx, world.maxy)
	refresh_mining_turfs()

/obj/abstract/level_data/mining_level/proc/refresh_mining_turfs()
	set waitfor = FALSE
	for(var/turf/simulated/floor/asteroid/mining_turf as anything in mining_turfs)
		mining_turf.updateMineralOverlays()
		CHECK_TICK
	mining_turfs = null

// Used as a dummy z-level for the overmap.
/obj/abstract/level_data/overmap
	name = "Sensor Display"
	take_starlight_ambience = FALSE // Overmap doesn't care about ambient lighting

#undef ZLEVEL_STATION
#undef ZLEVEL_ADMIN
#undef ZLEVEL_CONTACT
#undef ZLEVEL_PLAYER
#undef ZLEVEL_SEALED