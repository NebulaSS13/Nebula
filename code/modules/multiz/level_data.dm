#define ZLEVEL_STATION BITFLAG(0)
#define ZLEVEL_ADMIN   BITFLAG(1)
#define ZLEVEL_CONTACT BITFLAG(2)
#define ZLEVEL_PLAYER  BITFLAG(3)
#define ZLEVEL_SEALED  BITFLAG(4)

/obj/abstract/level_data
	/// z-level associated with this datum
	var/my_z
	/// A unique identifier for the level, used for SSzlevels looup
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
	var/base_turf_type = /turf/space
	/// Default area for this level on creation (as above)
	var/base_area_type = /area/space
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
	if(SSzlevels.levels_by_z["[my_z]"])
		PRINT_STACK_TRACE("Duplicate level data created for z[z].")
	SSzlevels.levels_by_z["[my_z]"] = src
	if(!level_id)
		level_id = "leveldata_[my_z]_[sequential_id(/obj/abstract/level_data)]"
	if(level_id in SSzlevels.levels_by_id)
		PRINT_STACK_TRACE("Duplicate level_id '[level_id]' for z[my_z].")
	else
		SSzlevels.levels_by_id[level_id] = src

	if(take_starlight_ambience)
		ambient_light_level = config.starlight
		ambient_light_color = SSskybox.background_color

	if(SSzlevels.initialized && !defer_level_setup)
		setup_level_data()

/obj/abstract/level_data/proc/setup_level_data()
	if(base_turf)
		SSzlevels.base_turf_by_z["[my_z]"] = base_turf
	if(level_flags & ZLEVEL_STATION)
		SSzlevels.station_levels |= my_z
	if(level_flags & ZLEVEL_ADMIN)
		SSzlevels.admin_levels   |= my_z
	if(level_flags & ZLEVEL_CONTACT)
		SSzlevels.contact_levels |= my_z
	if(level_flags & ZLEVEL_PLAYER)
		SSzlevels.player_levels  |= my_z
	if(level_flags & ZLEVEL_SEALED)
		SSzlevels.sealed_levels  |= my_z
	build_exterior_atmosphere()

/obj/abstract/level_data/Destroy(var/force)
	if(force)
		new type(locate(round(world.maxx/2), round(world.maxy/2), my_z))
		return ..()
	return QDEL_HINT_LETMELIVE

/obj/abstract/level_data/proc/find_connected_levels(var/list/found)
	for(var/other_id in connects_to)
		var/obj/abstract/level_data/neighbor = SSzlevels.levels_by_id[other_id] 
		neighbor.add_connected_levels(found)

/obj/abstract/level_data/proc/add_connected_levels(var/list/found)
	. = found
	if((my_z in found))
		return
	LAZYADD(found, my_z)
	if(!length(connects_to))
		return
	for(var/other_id in connects_to)
		var/obj/abstract/level_data/neighbor = SSzlevels.levels_by_id[other_id] 
		neighbor.add_connected_levels(found)

/obj/abstract/level_data/proc/build_exterior_atmosphere()
	if(islist(exterior_atmosphere))
		var/list/exterior_atmos_composition = exterior_atmosphere
		exterior_atmosphere = new
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

/*
 * Mappable subtypes.
 */
/obj/abstract/level_data/main_level
	name = "Main Station Level"
	level_flags = (ZLEVEL_STATION|ZLEVEL_CONTACT|ZLEVEL_PLAYER)

/obj/abstract/level_data/admin_level
	name = "Admin Level"
	level_flags = (ZLEVEL_ADMIN|ZLEVEL_SEALED)

/obj/abstract/level_data/player_level
	name = "Player Level"
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER)

// Used by the subsystem to populate the full z-level list during init.
/obj/abstract/level_data/filler
	name = "Filler Level"

/obj/abstract/level_data/empty
	name = "Empty Level"

/obj/abstract/level_data/space
	name = "Space Level"

/obj/abstract/level_data/exoplanet
	name = "Planetary Surface"
	exterior_atmosphere = list(
		/decl/material/gas/oxygen =   MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	exterior_atmos_temp = T20C
	level_flags = ZLEVEL_SEALED
	take_starlight_ambience = FALSE // This is set up by the exoplanet object.

/obj/abstract/level_data/unit_test
	name = "Test Area"
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER|ZLEVEL_SEALED)

// Used as a dummy z-level for the overmap.
/obj/abstract/level_data/overmap
	name = "Sensor Display"
	take_starlight_ambience = FALSE // Overmap doesn't care about ambient lighting

#undef ZLEVEL_STATION
#undef ZLEVEL_ADMIN
#undef ZLEVEL_CONTACT
#undef ZLEVEL_PLAYER
#undef ZLEVEL_SEALED