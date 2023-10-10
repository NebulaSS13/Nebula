////Turf Vars////
#ifdef ZASDBG
///Set to TRUE during debugging to get descriptive to_chats of the object. Works for all atmos-related datums.
/turf/var/tmp/verbose = FALSE
#endif

/turf/proc/update_air_properties()

	if(zone?.invalid) //this turf's zone is in the process of being rebuilt
		c_copy_air() //not very efficient :(
		zone = null //Easier than iterating through the list at the zone.

	var/s_block = c_airblock(src)
	if(s_block & AIR_BLOCKED)
		#ifdef ZASDBG
		if(verbose)
			zas_log("Self-blocked.")
		dbg(zasdbgovl_blocked)
		#endif
		if(zone)
			var/zone/z = zone

			if(can_safely_remove_from_zone()) //Helps normal airlocks avoid rebuilding zones all the time
				c_copy_air() //we aren't rebuilding, but hold onto the old air so it can be readded
				z.remove(src)
			else
				z.rebuild()

		return 1

	var/previously_open = airflow_open_directions
	airflow_open_directions = 0

	var/list/postponed
	#ifdef MULTIZAS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif

		var/turf/unsim = get_step(src, d)

		if(!unsim) //edge of map
			continue

		var/block = unsim.c_airblock(src)
		if(block & AIR_BLOCKED)

			#ifdef ZASDBG
			if(verbose)
				zas_log("[dir2text(d)] is blocked.")
			//dbg(ZAS_DIRECTIONAL_BLOCKER(d))
			#endif

			continue

		var/r_block = c_airblock(unsim)
		if(r_block & AIR_BLOCKED)

			#ifdef ZASDBG
			if(verbose)
				zas_log("[dir2text(d)] is blocked.")
			//target.dbg(ZAS_DIRECTIONAL_BLOCKER(turn(d, 180)))
			#endif

			//Check that our zone hasn't been cut off recently.
			//This happens when windows move or are constructed. We need to rebuild.
			if((previously_open & d) && unsim.zone_membership_candidate)
				if(zone && unsim.zone == zone)
					zone.rebuild()
					return

			continue

		airflow_open_directions |= d

		if(unsim.zone_membership_candidate)

			unsim.airflow_open_directions |= global.reverse_dir[d]

			if(TURF_HAS_VALID_ZONE(unsim))

				//Might have assigned a zone, since this happens for each direction.
				if(!zone)

					//We do not merge if
					//    they are blocking us and we are not blocking them, or if
					//    we are blocking them and not blocking ourselves - this prevents tiny zones from forming on doorways.
					if(((block & ZONE_BLOCKED) && !(r_block & ZONE_BLOCKED)) || ((r_block & ZONE_BLOCKED) && !(s_block & ZONE_BLOCKED)))
						#ifdef ZASDBG
						if(verbose)
							zas_log("[dir2text(d)] is zone blocked.")
						//dbg(ZAS_ZONE_BLOCKER(d))
						#endif

						//Postpone this tile rather than exit, since a connection can still be made.
						if(!postponed) postponed = list()
						postponed.Add(unsim)

					else

						unsim.zone.add(src)

						#ifdef ZASDBG
						dbg(zasdbgovl_assigned)
						if(verbose)
							zas_log("Added to [zone]")
						#endif

				else if(unsim.zone != zone)

					#ifdef ZASDBG
					if(verbose)
						zas_log("Connecting to [unsim.zone]")
					#endif

					SSair.connect(src, unsim)


			#ifdef ZASDBG
				else if(verbose)
					zas_log("[dir2text(d)] has same zone.")

			else if(verbose)
				zas_log("[dir2text(d)] has an invalid or rebuilding zone.")
			#endif

		else

			//Postponing connections to tiles until a zone is assured.
			if(!postponed) postponed = list()
			postponed.Add(unsim)

	if(!TURF_HAS_VALID_ZONE(src)) //Still no zone, make a new one.
		var/zone/newzone = new/zone()
		newzone.add(src)

	#ifdef ZASDBG
		dbg(zasdbgovl_created)
		if(verbose)
			zas_log("New zone created for src.")

	ASSERT(zone)
	#endif

	//At this point, a zone should have happened. If it hasn't, don't add more checks, fix the bug.

	for(var/turf/T in postponed)
		SSair.connect(src, T)








/*
	Simple heuristic for determining if removing the turf from it's zone will not partition the zone (A very bad thing).
	Instead of analyzing the entire zone, we only check the nearest 3x3 turfs surrounding the src turf.
	This implementation may produce false negatives but it (hopefully) will not produce any false postiives.
*/

/turf/proc/can_safely_remove_from_zone()
	if(!zone) return 1

	var/check_dirs = get_zone_neighbours(src)
	var/unconnected_dirs = check_dirs

	//src is only connected to the zone by a single direction, this is a safe removal.
	if (!(check_dirs & (check_dirs - 1))) //Equivalent to: if(IsInteger(log(2, .)))
		return TRUE

	#ifdef MULTIZAS
	var/to_check = global.cornerdirsz
	#else
	var/to_check = global.cornerdirs
	#endif

	for(var/dir in to_check)

		//for each pair of "adjacent" cardinals (e.g. NORTH and WEST, but not NORTH and SOUTH)
		if((dir & check_dirs) == dir)
			//check that they are connected by the corner turf
			var/connected_dirs = get_zone_neighbours(get_step(src, dir))
			if(connected_dirs && (dir & global.reverse_dir[connected_dirs]) == dir)
				unconnected_dirs &= ~dir //they are, so unflag the cardinals in question

	//it is safe to remove src from the zone if all cardinals are connected by corner turfs
	return !unconnected_dirs

//helper for can_safely_remove_from_zone()
/turf/proc/get_zone_neighbours(turf/T)
	. = 0
	if(istype(T) && T.zone)
		#ifdef MULTIZAS
		var/to_check = global.cardinalz
		#else
		var/to_check = global.cardinal
		#endif
		for(var/dir in to_check)
			var/turf/other = get_step(T, dir)
			if(isturf(other) && other.zone_membership_candidate && other.zone == T.zone && !(other.c_airblock(T) & AIR_BLOCKED) && get_dist(src, other) <= 1)
				. |= dir

/turf/proc/post_update_air_properties()
	if(connections) connections.update_all()

/turf/assume_air(datum/gas_mixture/giver) //use this for machines to adjust air
	var/datum/gas_mixture/my_air = return_air()
	if(my_air)
		my_air.merge(giver)
		return TRUE
	return FALSE

/turf/return_air()

	// ZAS participation
	if(zone && !zone.invalid)
		SSair.mark_zone_update(zone)
		return zone.air

	// Exterior turf global atmosphere
	if((!air && isnull(initial_gas)) || (external_atmosphere_participation && is_outside()))
		var/datum/level_data/level = SSmapping.levels_by_z[z]
		var/datum/gas_mixture/gas = level.get_exterior_atmosphere()
		var/initial_temperature = weather ? weather.adjust_temperature(gas.temperature) : gas.temperature
		if(length(affecting_heat_sources))
			for(var/obj/structure/fire_source/heat_source as anything in affecting_heat_sources)
				gas.temperature = gas.temperature + heat_source.exterior_temperature / max(1, get_dist(src, get_turf(heat_source)))
				if(abs(gas.temperature - initial_temperature) >= 100)
					break
		return gas

	// Base behavior
	. = air
	if(!.)
		. = make_air()
		if(zone)
			c_copy_air()

/turf/remove_air(amount as num)
	var/datum/gas_mixture/GM = return_air()
	return GM.remove(amount)

/turf/proc/assume_gas(gasid, moles, temp = null)
	var/datum/gas_mixture/my_air = return_air()
	if(my_air)
		if(isnull(temp))
			my_air.adjust_gas(gasid, moles)
		else
			my_air.adjust_gas_temp(gasid, moles, temp)
		return TRUE
	return FALSE

/turf/proc/make_air()
	air = new/datum/gas_mixture
	air.temperature = temperature
	if(initial_gas)
		air.gas = initial_gas.Copy()
	air.update_values()
	return air

/turf/proc/c_copy_air()
	if(!air)
		air = new/datum/gas_mixture
	air.copy_from(zone.air)
	air.group_multiplier = 1
