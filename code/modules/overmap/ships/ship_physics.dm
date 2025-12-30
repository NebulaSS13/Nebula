#define DEFAULT_TURF_MASS		500

// Gets a ship's delta v in km/s. This only uses immediate impulse with whatever is in engines,
// to get a ship's total *possible* approxiamte delta v, use get_total_delta_v().
// partial power is used with burn() in order to only do partial burns.
/obj/effect/overmap/visitable/ship/get_delta_v(var/real_burn = FALSE, var/partial_power = 1)
	var/total_exhaust_velocity = 0
	partial_power = clamp(partial_power, 0, 1)
	for(var/datum/extension/ship_engine/E in engines)
		total_exhaust_velocity += real_burn ? E.burn(partial_power) : E.get_exhaust_velocity()
	var/vessel_mass = get_vessel_mass()
	// special note here
	// get_instant_wet_mass() returns kg
	// vessel_mass is in metric tonnes
	// This is not a correct rocket equation, but it's what is balanced for the game and
	// is intentional.
	var/raw_delta_v = (total_exhaust_velocity / GRAVITY_CONSTANT) * log((get_specific_wet_mass() + vessel_mass) / vessel_mass)
	return round(raw_delta_v, SHIP_MOVE_RESOLUTION)

// Stubbed method for future goodness.
// This will be used for delta-v equations for launching ships later.
/obj/effect/overmap/visitable/ship/proc/get_total_wet_mass()
	return vessel_mass * 0.2

// This is the amount of fuel we can spend in one specific impulse.
/obj/effect/overmap/visitable/ship/proc/get_specific_wet_mass()
	var/mass = 0
	for(var/datum/extension/ship_engine/E in engines)
		mass += E.get_specific_wet_mass()
	return mass

/obj/effect/overmap/visitable/ship/get_vessel_mass()
	. = vessel_mass
	for(var/obj/effect/overmap/visitable/ship/ship in src)
		. += ship.get_vessel_mass()

/obj/effect/overmap/visitable/ship/proc/recalculate_vessel_mass()
	var/list/zones = list()
	// for(var/turf/tile in area) is an implied in-world loop
	// an in-world loop per area is very bad, so instead
	// we do one in-world loop and check area
	var/list/areas = list()
	// create an associative list of area -> TRUE so that lookup is faster
	for(var/area/A in get_areas())
		if(istype(A, world.area)) // exclude the base area
			continue
		areas[A] = TRUE
	var/start_z = min(map_z)
	var/end_z = max(map_z)
	if(!start_z || !end_z)
		return initial(vessel_mass) // This shouldn't happen ideally so just go with the initial vessel mass
	for(var/z_level in start_z to end_z)
		var/datum/level_data/z_data = SSmapping.levels_by_z[z_level]
		for(var/turf/tile in block(z_data.level_inner_min_x, z_data.level_inner_min_y, z_level, z_data.level_inner_max_x, z_data.level_inner_max_y))
			var/area/tile_area = tile.loc
			if(!tile_area || !areas[tile_area])
				continue

			if(!tile.simulated || tile.is_open())
				continue

			. += DEFAULT_TURF_MASS
			if(istype(tile, /turf/wall))
				var/turf/wall/wall_tile = tile
				if(wall_tile.material)
					. += wall_tile.material.weight * 5
				if(wall_tile.reinf_material)
					. += wall_tile.reinf_material.weight * 5
				if(wall_tile.girder_material)
					. += wall_tile.girder_material.weight * 5

			if(tile.zone)
				zones[tile.zone] = TRUE // assoc list for fast deduplication

			for(var/atom/movable/C as anything in tile) // as anything is safe here since only movables can be in turf contents
				if(!C.simulated)
					continue
				. += C.get_mass()
				for(var/atom/movable/C2 in C)
					if(!C2.simulated)
						continue
					. += C2.get_mass()

	// loop over keys of all zones in the list
	for(var/zone/zone as anything in zones)
		. += zone.air.get_mass()

	// Convert kilograms to metric tonnes.
	. = . / 1000