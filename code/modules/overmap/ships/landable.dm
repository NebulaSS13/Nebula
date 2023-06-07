// These come with shuttle functionality. Need to be assigned a (unique) shuttle datum name.
// Mapping location doesn't matter, so long as on a map loaded at the same time as the shuttle areas.
// Multiz shuttles currently not supported. Non-autodock shuttles currently not supported.

/obj/effect/overmap/visitable/ship/landable
	var/shuttle                                         // Name of associated shuttle. Must be autodock.
	var/obj/effect/shuttle_landmark/ship/landmark       // Record our open space landmark for easy reference.
	var/multiz = 0										// Index of multi-z levels, starts at 0
	var/use_mapped_z_levels = FALSE                     // If true, it will use the z level block on which it's mapped as the "Open Space" block; if false it creates a new block for that.
	                                                    // If you use this, use /obj/effect/shuttle_landmark/ship as the landmark (set the landmark tag to match on the shuttle; no other setup needed)
	var/status = SHIP_STATUS_LANDED
	var/level_type = /datum/level_data/space
	icon_state = "shuttle"
	moving_state = "shuttle_moving"

/obj/effect/overmap/visitable/ship/landable/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(shuttle, map_hash)

/obj/effect/overmap/visitable/ship/landable/Destroy()
	events_repository.unregister(/decl/observ/shuttle_moved, SSshuttle.shuttles[shuttle], src)
	return ..()

/obj/effect/overmap/visitable/ship/landable/can_burn()
	if(status != SHIP_STATUS_OVERMAP && status != SHIP_STATUS_ENCOUNTER)
		return 0
	return ..()

/obj/effect/overmap/visitable/ship/landable/burn()
	if(status != SHIP_STATUS_OVERMAP && status !=  SHIP_STATUS_ENCOUNTER)
		return 0
	return ..()

/obj/effect/overmap/visitable/ship/landable/check_ownership(obj/object)
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(!shuttle_datum)
		return
	var/list/areas = shuttle_datum.find_childfree_areas()
	if(get_area(object) in areas)
		return 1

/obj/effect/overmap/visitable/ship/landable/allow_free_landing(var/datum/shuttle/landing_shuttle)
	var/datum/shuttle/autodock/overmap/child_shuttle = SSshuttle.shuttles[shuttle]
	if(child_shuttle == landing_shuttle)
		return FALSE // Use the main landmark.
	if(child_shuttle.current_location != landmark)
		return FALSE // Cannot encounter a shuttle while it is landed elsewhere.
	. = ..()

/obj/effect/overmap/visitable/ship/landable/Process(wait, tick)
	..()
	var/datum/shuttle/autodock/overmap/child_shuttle = SSshuttle.shuttles[shuttle]
	if(!child_shuttle || !istype(child_shuttle))
		return
	if(child_shuttle.current_location.flags & SLANDMARK_FLAG_DISCONNECTED) // Keep an eye on the distance between the shuttle and the sector if we aren't fully docked.
		var/obj/effect/overmap/visitable/ship/landable/encounter = global.overmap_sectors[num2text(child_shuttle.current_location.z)]
		if((get_dist(src, encounter) > min(child_shuttle.range, 1))) // Some leeway so 0 range shuttles are still able to chase.
			child_shuttle.attempt_force_move(landmark)
		if(istype(encounter))
			if(encounter.status != SHIP_STATUS_OVERMAP) // Check if the encountered sector has moved out of space and landed elsewhere.
				child_shuttle.attempt_force_move(landmark)

// We autobuild our z levels.
/obj/effect/overmap/visitable/ship/landable/find_z_levels()
	if(!use_mapped_z_levels)
		for(var/i = 0 to multiz)
			SSmapping.increment_world_z_size(level_type)
			map_z += world.maxz
	else
		..()

/obj/effect/overmap/visitable/ship/landable/get_areas()
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(!shuttle_datum)
		return list()
	return shuttle_datum.find_childfree_areas()

/obj/effect/overmap/visitable/ship/landable/move_to_starting_location()
	if(!use_mapped_z_levels)
		..()
		return // it actually doesn't matter what we do in this case

	// Attempt to find a safe and random overmap turf to start on
	var/datum/overmap/overmap = global.overmaps_by_name[overmap_id]
	var/list/candidates = list()
	for(var/turf/T in block(locate(OVERMAP_EDGE, OVERMAP_EDGE, overmap.assigned_z), locate(overmap.map_size_x - 1, overmap.map_size_y - 1, overmap.assigned_z)))
		if(locate(/obj/effect/overmap) in T)
			continue
		candidates += T
	if(length(candidates))
		forceMove(pick(candidates))
	else
		..() // this picks a random turf

/obj/effect/overmap/visitable/ship/landable/populate_sector_objects()
	..()

	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]

	// Finish "open space" z block setup
	if(!use_mapped_z_levels)
		var/top_z = map_z[map_z.len]
		var/turf/center_loc = WORLD_CENTER_TURF(top_z)
		landmark = new (center_loc, shuttle)
		add_landmark(landmark) // we don't restrict it but it does a more strict check in is_valid anyway
	else
		var/obj/effect/shuttle_landmark/ship/ship_landmark = shuttle_datum.current_location
		if(!istype(ship_landmark))
			PRINT_STACK_TRACE("Landable ship [src] with shuttle [shuttle] was mapped with a starting landmark type [ship_landmark.type], but should be /obj/effect/shuttle_landmark/ship.")
			ship_landmark = new(ship_landmark.loc, shuttle) // this is not great, but probably mostly works, and we already reported the issue
			qdel(shuttle_datum.current_location)
			shuttle_datum.current_location = ship_landmark
		landmark = ship_landmark
		landmark.shuttle_name = shuttle
		LAZYDISTINCTADD(initial_generic_waypoints, landmark.landmark_tag) // this is us being user-friendly: it means we register it properly regardless of whether the mapper put the tag in initial_restricted_waypoints

	var/visitor_dir = fore_dir
	for(var/landmark_name in list("FORE", "PORT", "AFT", "STARBOARD"))
		var/turf/visitor_turf = get_ranged_target_turf(get_turf(landmark), visitor_dir, round(min(world.maxx/4, world.maxy/4)))
		var/obj/effect/shuttle_landmark/visiting_shuttle/visitor_landmark = new (visitor_turf, landmark, landmark_name)
		add_landmark(visitor_landmark)
		visitor_dir = turn(visitor_dir, 90)

	// Configure shuttle datum
	events_repository.register(/decl/observ/shuttle_moved, shuttle_datum, src, .proc/on_shuttle_jump)
	on_landing(landmark, shuttle_datum.current_location) // We "land" at round start to properly place ourselves on the overmap.
	if(landmark == shuttle_datum.current_location)
		status = SHIP_STATUS_OVERMAP // we spawned on the overmap, so have to initialize our state properly.

/obj/effect/shuttle_landmark/ship
	name = "Open Space"
	landmark_tag = "ship"
	flags = SLANDMARK_FLAG_AUTOSET | SLANDMARK_FLAG_ZERO_G
	var/shuttle_name
	var/list/visitors // landmark -> visiting shuttle stationed there

/obj/effect/shuttle_landmark/ship/Initialize(mapload, shuttle_name)
	if(!mapload)
		landmark_tag += "_[shuttle_name]"
		src.shuttle_name = shuttle_name
	. = ..()

/obj/effect/shuttle_landmark/ship/Destroy()
	var/obj/effect/overmap/visitable/ship/landable/ship = global.overmap_sectors[num2text(z)]
	if(istype(ship) && ship.landmark == src)
		ship.landmark = null
	. = ..()

/obj/effect/shuttle_landmark/ship/cannot_depart(datum/shuttle/shuttle)
	if(LAZYLEN(visitors))
		return "Cannot maneuver with other shuttles nearby."

/obj/effect/shuttle_landmark/ship/is_valid(datum/shuttle/shuttle)
	return (shuttle.name == shuttle_name) && ..()

/obj/effect/shuttle_landmark/visiting_shuttle
	flags = SLANDMARK_FLAG_AUTOSET | SLANDMARK_FLAG_ZERO_G | SLANDMARK_FLAG_DISCONNECTED
	var/obj/effect/shuttle_landmark/ship/core_landmark

/obj/effect/shuttle_landmark/visiting_shuttle/Initialize(mapload, obj/effect/shuttle_landmark/ship/master, _name)
	core_landmark = master
	SetName(_name)
	landmark_tag = master.shuttle_name + _name
	events_repository.register(/decl/observ/destroyed, master, src, /datum/proc/qdel_self)
	. = ..()

/obj/effect/shuttle_landmark/visiting_shuttle/Destroy()
	events_repository.unregister(/decl/observ/destroyed, core_landmark, src)
	LAZYREMOVE(core_landmark.visitors, src)
	core_landmark = null
	. = ..()

/obj/effect/shuttle_landmark/visiting_shuttle/is_valid(datum/shuttle/shuttle)
	. = ..()
	if(!.)
		return
	var/datum/shuttle/boss_shuttle = SSshuttle.shuttles[core_landmark.shuttle_name]
	if(boss_shuttle.current_location != core_landmark)
		return FALSE // Only available when our governing shuttle is in space.
	if(shuttle == boss_shuttle) // Boss shuttle only lands on main landmark
		return FALSE

/obj/effect/shuttle_landmark/visiting_shuttle/shuttle_arrived(datum/shuttle/shuttle)
	LAZYSET(core_landmark.visitors, src, shuttle)
/obj/effect/shuttle_landmark/visiting_shuttle/shuttle_departed(datum/shuttle/shuttle, obj/effect/shuttle_landmark/old_landmark, obj/effect/shuttle_landmark/new_landmark)
	LAZYREMOVE(core_landmark.visitors, src)

/obj/effect/overmap/visitable/ship/landable/proc/on_shuttle_jump(datum/shuttle/given_shuttle, obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(given_shuttle != SSshuttle.shuttles[shuttle])
		return
	var/datum/shuttle/autodock/auto = given_shuttle
	if(into == auto.landmark_transition)
		status = SHIP_STATUS_TRANSIT
		on_takeoff(from, into)
		return
	if(into == landmark)
		status = SHIP_STATUS_OVERMAP
		on_takeoff(from, into)
		return
	if(into.flags & SLANDMARK_FLAG_DISCONNECTED)
		status = SHIP_STATUS_ENCOUNTER
		on_takeoff(from, into)
		return
	status = SHIP_STATUS_LANDED
	on_landing(from, into)

/obj/effect/overmap/visitable/ship/landable/proc/on_landing(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	var/obj/effect/overmap/visitable/target = global.overmap_sectors[num2text(into.z)]
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(into.landmark_tag == shuttle_datum.motherdock) // If our motherdock is a landable ship, it won't be found properly here so we need to find it manually.
		for(var/obj/effect/overmap/visitable/ship/landable/landable in SSshuttle.ships)
			if(landable.shuttle == shuttle_datum.mothershuttle)
				target = landable
				break
	if(!target || target == src)
		return
	forceMove(target)
	halt()

/obj/effect/overmap/visitable/ship/landable/proc/on_takeoff(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(!isturf(loc))
		forceMove(get_turf(loc))
		unhalt()

/obj/effect/overmap/visitable/ship/landable/get_landed_info()
	switch(status)
		if(SHIP_STATUS_LANDED)
			var/obj/effect/overmap/visitable/location = loc
			if(istype(loc, /obj/effect/overmap/visitable/sector))
				return "Landed on \the [location.name]. Use secondary thrust to get clear before activating primary engines."
			if(istype(loc, /obj/effect/overmap/visitable/ship))
				return "Docked with \the [location.name]. Use secondary thrust to get clear before activating primary engines."
			return "Docked with an unknown object."
		if(SHIP_STATUS_ENCOUNTER)
			var/datum/shuttle/autodock/overmap/child_shuttle = SSshuttle.shuttles[shuttle]
			var/obj/effect/overmap/visitable/location = global.overmap_sectors[num2text(child_shuttle.current_location.z)]
			return "Maneuvering nearby \the [location.name]."
		if(SHIP_STATUS_TRANSIT)
			return "Maneuvering under secondary thrust."
		if(SHIP_STATUS_OVERMAP)
			return "In open space."