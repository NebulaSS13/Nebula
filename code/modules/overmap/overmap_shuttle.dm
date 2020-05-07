#define waypoint_sector(waypoint) map_sectors["[waypoint.z]"]

/datum/shuttle/autodock/overmap
	warmup_time = 10

	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.

	category = /datum/shuttle/autodock/overmap
	var/skill_needed = SKILL_BASIC
	var/operator_skill = SKILL_MIN

/datum/shuttle/autodock/overmap/fuel_check()
	var/delta_v = try_consume_fuel()
	if(!delta_v) //insufficient fuel or burn failed.
		for(var/area/A in shuttle_area)
			for(var/mob/living/M in A)
				M.show_message(SPAN_WARNING("You hear the shuttle engines sputter... and quietly die off. Perhaps they ran out of fuel?"), AUDIBLE_MESSAGE,
				SPAN_WARNING("The shuttle rumbles and then becomes still."), VISIBLE_MESSAGE)
				return FALSE //failure!
	return delta_v //success, continue with launch

/datum/shuttle/autodock/overmap/proc/can_go()
	if(!next_location)
		return FALSE
	if(moving_status == SHUTTLE_INTRANSIT)
		return FALSE //already going somewhere, current_location may be an intransit location instead of in a sector

	var/obj/effect/overmap/visitable/ship/ship = SSshuttle.get_ship_by_shuttle(src)
	if(istype(ship))
		// Bypass range check for ships.
		return TRUE

	//ensures that distances are calculated correctly when dealing with multi-tile sectors
	var/atom/movable/current_sector = waypoint_sector(current_location)
	var/atom/movable/next_sector = waypoint_sector(next_location)
	for(var/turf/current_loc_turf in current_sector.locs)
		for(var/turf/next_loc_turf in next_sector.locs)
			if(get_dist(current_loc_turf, next_loc_turf) <= range)
				return TRUE
	return FALSE

/datum/shuttle/autodock/overmap/can_launch()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/can_force()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/get_travel_time()
	var/distance_mod = get_dist(waypoint_sector(current_location), waypoint_sector(next_location))
	var/skill_mod = 0.2*(skill_needed - operator_skill)
	return move_time * (1 + distance_mod + skill_mod)

/datum/shuttle/autodock/overmap/process_launch()
	if(prob(10 * max(0, skill_needed - operator_skill)))
		var/places = get_possible_destinations()
		var/place = pick(places)
		set_destination(places[place])

	check_transition()
	return ..()

// This proc will look at our destination and make sure we have a transition layer created & ready for our arrival.
/datum/shuttle/autodock/overmap/proc/check_transition()
	if(!next_location)
		return FALSE

	// Normal transition.
	if(!landmark_transition)
		INCREMENT_WORLD_Z_SIZE
		landmark_transition = new("[name] transit")
		landmark_transition.loc = locate(100, 100, world.maxz)
	
	var/transit_z = landmark_transition.loc.z

	var/obj/effect/overmap/visitable/current_sector = waypoint_sector(current_location)
	var/obj/effect/overmap/visitable/next_sector = waypoint_sector(next_location) 
	if(current_sector.is_planet() || next_sector.is_planet())
		// We landin on a planet (or taking off from).		
		for(var/turf/T in block(locate(0, 0, transit_z), locate(world.maxx, world.maxy, transit_z)))
			T.ChangeTurf(/turf/simulated/open)
	else
		// Space transit.
		for(var/turf/T in block(locate(0, 0, transit_z), locate(world.maxx, world.maxy, transit_z)))
			T.ChangeTurf(/turf/space)
	return TRUE

/datum/shuttle/autodock/overmap/proc/set_destination(var/obj/effect/shuttle_landmark/A)
	if(A != current_location)
		if(next_location)
			next_location.landmark_deselected(src)
		next_location = A
		next_location.landmark_selected(src)

/datum/shuttle/autodock/overmap/proc/get_possible_destinations()
	var/list/res = list()
	for (var/obj/effect/overmap/visitable/S in range(get_turf(waypoint_sector(current_location)), range))
		var/list/waypoints = S.get_waypoints(name)
		for(var/obj/effect/shuttle_landmark/LZ in waypoints)
			if(LZ.is_valid(src))
				res["[waypoints[LZ]] - [LZ.name]"] = LZ
	return res

/datum/shuttle/autodock/overmap/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return "[waypoint_sector(current_location)] - [current_location]"

/datum/shuttle/autodock/overmap/get_destination_name()
	if(!next_location)
		return "None"
	return "[waypoint_sector(next_location)] - [next_location]"

/datum/shuttle/autodock/overmap/proc/try_consume_fuel() //returns delta v produced if sucessful, returns 0 if error (like insufficient fuel)
	var/obj/effect/overmap/visitable/ship/ship = SSshuttle.get_ship_by_shuttle(src)
	return ship.get_delta_v(TRUE)

/datum/shuttle/autodock/overmap/proc/get_heaviest_landmark() // If our destination or origin position are a planet, it returns that.
	var/obj/effect/overmap/visitable/sector = waypoint_sector(next_location)
	if(sector.is_planet())
		return next_location
	sector = waypoint_sector(current_location)
	if(sector.is_planet())
		return current_location

/datum/shuttle/autodock/overmap/do_long_jump(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	if(moving_status == SHUTTLE_IDLE)
		return	//someone cancelled the launch

	var/obj/effect/overmap/visitable/ship/ship = SSshuttle.get_ship_by_shuttle(src)
	if(!istype(ship))
		// Somehow this got called by a shuttle w/o a ship reference?
		return ..() // Safety return.

	var/delta_v = fuel_check()
	if(!delta_v) // engines failed to produce thrust.
		var/datum/shuttle/autodock/S = src
		if(istype(S))
			S.cancel_launch(null)
		return

	var/delta_v_budget = ship.get_delta_v_budget(waypoint_sector(destination))

	arrive_time = world.time + ((delta_v_budget / delta_v) * 10 SECONDS) // Estimated!
	moving_status = SHUTTLE_INTRANSIT
	if(attempt_move(interim))
		playsound(destination, sound_landing, 100, 0, 7)

	addtimer(CALLBACK(src, .proc/continue_long_jump, destination, 1, delta_v_budget, delta_v_budget - delta_v), 10 SECONDS)

/datum/shuttle/autodock/overmap/proc/continue_long_jump(var/obj/effect/shuttle_landmark/destination, var/burns, var/delta_v_budget, var/remaining_delta_v)
	var/delta_v = fuel_check()

	if(burns >= 5 || !delta_v)
		var/obj/effect/shuttle_landmark/landmark = get_heaviest_landmark()
		var/obj/effect/overmap/visitable/sector = waypoint_sector(landmark)
		if(landmark && sector && sector.is_planet())
			// Enter freefall. We're super fucked!
			return freefall(landmark, remaining_delta_v)
		else
			// This is just space transit. We're stuck here now.
			moving_status = SHUTTLE_FREEFALL // We're in freefall but not destructively. Nothing to hit.
			return

	var/new_remaining_delta_v = remaining_delta_v - delta_v
	arrive_time = world.time + ((delta_v_budget / new_remaining_delta_v) * 10 SECONDS) // Estimated!	

	if(remaining_delta_v > 0)
		addtimer(CALLBACK(src, .proc/continue_long_jump, destination, burns + 1, delta_v_budget, new_remaining_delta_v), 10 SECONDS)
	else if(attempt_move(destination))
		playsound(destination, sound_landing, 100, 0, 7)
		moving_status = SHUTTLE_IDLE // We landed!

/datum/shuttle/autodock/overmap/proc/freefall(var/obj/effect/shuttle_landmark/destination, var/remaining_delta_v)
	var/obj/effect/overmap/visitable/sector = waypoint_sector(destination)
	
	var/is_descending = istype(sector, /obj/effect/overmap/visitable/sector/exoplanet)
	for(var/area/A in shuttle_area)
		for(var/mob/living/M in A)
			M.show_message(SPAN_WARNING("The ship rattles and becomes still as it ceases controlled [is_descending ? "descent" : "ascent"]. The ground sure seems to be approaching fast."), VISIBLE_MESSAGE)
	moving_status = SHUTTLE_FREEFALL

	var/freefall_time = min(30, remaining_delta_v) SECONDS
	addtimer(CALLBACK(src, .proc/do_freefall, destination, remaining_delta_v), freefall_time)

/datum/shuttle/autodock/overmap/proc/do_freefall(var/obj/effect/shuttle_landmark/destination, var/remaining_delta_v)
	if(moving_status != SHUTTLE_FREEFALL)
		return // We pulled out!
	// Crash!
	crash_land(3, destination)

// Force moves a shuttle to the given landmark and damages the shuttle via explosions. The explosions will be placed semi-randomly,
// targeting the outer areas of the shuttle more severely. Severity determines how 'bad' the crash is, increasing the strength of explosions.
// Number of explosions is determined by the size of the shuttle via amount of turfs.
/datum/shuttle/autodock/overmap/proc/crash_land(var/severity, var/obj/effect/shuttle_landmark/crash_zone)
    if(!crash_zone)
        return
   
    attempt_move(crash_zone)
 
    var/max_x
    var/max_y
    var/min_x
    var/min_y
    var/shuttle_z
 
    // List of potential 'targets' for the explosions.
    var/list/shuttle_turfs = list()
   
    // Locating the approximate center of the shuttle in order to weight the probability of a turf being targeted.
    for(var/area/A in shuttle_area)
        for(var/turf/T in A.contents)
            if(!max_x && !max_y && !min_x && !min_y)
                max_x = T.x
                max_y = T.y
                min_x = T.x
                min_y = T.y
 
                shuttle_z = T.z
 
            shuttle_turfs += T
            max_x = max(T.x, max_x)
            max_y = max(T.y, max_y)
            min_x = min(T.x, max_x)
            min_y = min(T.y, min_y)
 
    var/turf/center_turf = locate(round(min_x + ((max_x - min_x)/2)), round(min_y + ((max_y - min_y/2))), shuttle_z)
 
    for(var/turf/T in shuttle_turfs)
        shuttle_turfs[T] = get_dist(T, center_turf)
 
    for(var/explosion_count = 0 to length(shuttle_turfs) step 20) // 1 explosion for every 20 turfs in the shuttle, still weighting the edges.
        explosion(pickweight(shuttle_turfs), severity-2, severity, severity+2, 5)