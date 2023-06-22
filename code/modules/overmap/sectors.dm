var/global/list/known_overmap_sectors

//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
/obj/effect/overmap/visitable
	name = "map object"
	scannable = TRUE

	var/list/initial_generic_waypoints //store landmark_tag of landmarks that should be added to the actual lists below on init.
	var/list/initial_restricted_waypoints //For use with non-automatic landmarks (automatic ones add themselves).

	var/list/generic_waypoints = list()    //waypoints that any shuttle can use
	var/list/restricted_waypoints = list() //waypoints for specific shuttle types
	var/docking_codes

	// Custom spawn coordinates. Will pick random place if one of them or both not set.
	/// Custom X coordinate to spawn. Require `start_y` set to work.
	var/start_x
	/// Custom Y coordinate to spawn. Require `start_x` set to work.
	var/start_y

	var/sector_flags = OVERMAP_SECTOR_IN_SPACE

	var/hide_from_reports = FALSE

	var/has_distress_beacon
	var/free_landing = TRUE				// Whether or not shuttles can land in arbitrary places within the sector's z-levels.
	var/restricted_area = 0				// Regardless of if free_landing is set to TRUE, this square area (centered on the z level) will be restricted from free shuttle landing unless permitted by a docking becaon.

	var/list/map_z = list()
	var/list/associated_machinery

/obj/effect/overmap/visitable/proc/get_linked_machines_of_type(var/base_type)
	ASSERT(ispath(base_type, /obj/machinery))
	for(var/thing in LAZYACCESS(associated_machinery, base_type))
		var/weakref/machine_ref = thing
		var/obj/machinery/machine = machine_ref.resolve()
		if(istype(machine, base_type) && !QDELETED(machine))
			LAZYDISTINCTADD(., machine)
		else
			LAZYREMOVE(associated_machinery[base_type], thing)

/obj/effect/overmap/visitable/proc/unregister_machine(var/obj/machinery/machine, var/base_type)
	ASSERT(istype(machine))
	base_type = base_type || machine.base_type || machine.type
	if(islist(associated_machinery) && associated_machinery[base_type])
		LAZYREMOVE(associated_machinery[base_type], weakref(machine))

/obj/effect/overmap/visitable/proc/register_machine(var/obj/machinery/machine, var/base_type)
	ASSERT(istype(machine))
	if(!QDELETED(machine))
		base_type = base_type || machine.base_type || machine.type
		LAZYINITLIST(associated_machinery)
		LAZYDISTINCTADD(associated_machinery[base_type], weakref(machine))

/obj/effect/overmap/visitable/Destroy()
	LAZYREMOVE(global.known_overmap_sectors, src)
	associated_machinery = null
	. = ..()

/obj/effect/overmap/visitable/Initialize()
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return

	find_z_levels()             // This populates map_z and assigns z levels to the ship.
	move_to_starting_location() // Moves us to the appropriate spot on the overmap level.
	register_z_levels()         // This makes external calls to update global z level information.

	docking_codes = "[ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))][ascii2text(rand(65,90))]"

	if(sector_flags & OVERMAP_SECTOR_KNOWN)
		LAZYADD(global.known_overmap_sectors, src)
		layer = ABOVE_LIGHTING_LAYER
		plane = ABOVE_LIGHTING_PLANE
		for(var/obj/machinery/computer/ship/helm/H as anything in global.overmap_helm_computers)
			H.add_known_sector(src)

	LAZYADD(SSshuttle.sectors_to_initialize, src) //Queued for further init. Will populate the waypoint lists; waypoints not spawned yet will be added in as they spawn.
	SSshuttle.clear_init_queue()

	testing("Located sector \"[name]\" at [x],[y],[z], containing Z [english_list(map_z)]")

/obj/effect/overmap/visitable/modify_mapped_vars(map_hash)
	..()
	if(map_hash)
		var/new_generic
		for(var/old_tag in initial_generic_waypoints)
			ADJUST_TAG_VAR(old_tag, map_hash)
			LAZYADD(new_generic, old_tag)
		initial_generic_waypoints = new_generic
		for(var/shuttle_type in initial_restricted_waypoints)
			var/new_restricted = list()
			for(var/old_tag in initial_restricted_waypoints[shuttle_type])
				ADJUST_TAG_VAR(old_tag, map_hash)
				new_restricted += old_tag
			initial_restricted_waypoints[shuttle_type] = new_restricted

/obj/effect/overmap/visitable/proc/move_to_starting_location()
	var/datum/overmap/overmap = global.overmaps_by_name[overmap_id]
	var/location

	if(start_x && start_y)
		location = locate(start_x, start_y, overmap.assigned_z)
	else
		var/list/candidate_turfs = block(
		locate(OVERMAP_EDGE, OVERMAP_EDGE, overmap.assigned_z),
		locate(overmap.map_size_x - OVERMAP_EDGE, overmap.map_size_y - OVERMAP_EDGE, overmap.assigned_z)
		)

		candidate_turfs = where(candidate_turfs, /proc/can_not_locate, /obj/effect/overmap)
		location = SAFEPICK(candidate_turfs) || locate(
			rand(OVERMAP_EDGE, overmap.map_size_x - OVERMAP_EDGE),
			rand(OVERMAP_EDGE, overmap.map_size_y - OVERMAP_EDGE),
			overmap.assigned_z
		)

	forceMove(location)

//This is called later in the init order by SSshuttle to populate sector objects. Importantly for subtypes, shuttles will be created by then.
/obj/effect/overmap/visitable/proc/populate_sector_objects()

/obj/effect/overmap/visitable/proc/get_areas()
	return get_filtered_areas(list(/proc/area_belongs_to_zlevels = map_z))

/obj/effect/overmap/visitable/proc/find_z_levels()
	map_z = SSmapping.get_connected_levels(z)

/obj/effect/overmap/visitable/proc/register_z_levels()
	var/datum/overmap/overmap = global.overmaps_by_z[num2text(z)]
	if(istype(overmap))
		for(var/zlevel in map_z)
			global.overmap_sectors[num2text(zlevel)] = src

	SSmapping.player_levels |= map_z
	if(!(sector_flags & OVERMAP_SECTOR_IN_SPACE))
		SSmapping.sealed_levels |= map_z
	if(sector_flags & OVERMAP_SECTOR_BASE)
		SSmapping.station_levels |= map_z
		SSmapping.contact_levels |= map_z
		SSmapping.map_levels |= map_z

//Helper for init.
/obj/effect/overmap/visitable/proc/check_ownership(obj/object)
	if((object.z in map_z) && !(get_area(object) in SSshuttle.shuttle_areas))
		return 1

// Returns the /obj/effect/overmap/visitable to which the atom belongs based on localtion, or null
/atom/proc/get_owning_overmap_object()
	var/z = get_z(src)
	var/initial_sector = global.overmap_sectors[num2text(z)]
	if(!initial_sector)
		return

	var/list/check_sectors = list(initial_sector)
	var/list/checked_sectors

	while(length(check_sectors))

		var/obj/effect/overmap/visitable/sector = check_sectors[1]
		if(sector.check_ownership(src))
			return sector

		check_sectors -= sector
		LAZYADD(checked_sectors, sector)
		for(var/obj/effect/overmap/visitable/next_sector in sector)
			if(!(next_sector in checked_sectors))
				check_sectors |= next_sector

//If shuttle_name is false, will add to generic waypoints; otherwise will add to restricted. Does not do checks.
/obj/effect/overmap/visitable/proc/add_landmark(obj/effect/shuttle_landmark/landmark, shuttle_restricted_type)
	landmark.sector_set(src, shuttle_restricted_type)
	if(shuttle_restricted_type)
		LAZYADD(restricted_waypoints[shuttle_restricted_type], landmark)
	else
		generic_waypoints += landmark

/obj/effect/overmap/visitable/proc/remove_landmark(obj/effect/shuttle_landmark/landmark, shuttle_restricted_type)
	if(shuttle_restricted_type)
		var/list/shuttles = restricted_waypoints[shuttle_restricted_type]
		LAZYREMOVE(shuttles, landmark)
	else
		generic_waypoints -= landmark

/obj/effect/overmap/visitable/proc/get_waypoints(var/shuttle_type)
	. = list()
	for(var/obj/effect/overmap/visitable/contained in src)
		. += contained.get_waypoints(shuttle_type)
	for(var/thing in generic_waypoints)
		.[thing] = name
	if(shuttle_type in restricted_waypoints)
		for(var/thing in restricted_waypoints[shuttle_type])
			.[thing] = name

/obj/effect/overmap/visitable/proc/generate_skybox()
	return

/obj/effect/overmap/visitable/MouseEntered(location, control, params)
	openToolTip(user = usr, tip_src = src, params = params, title = name)
	..()

/obj/effect/overmap/visitable/MouseDown()
	closeToolTip(usr) //No reason not to, really
	..()

/obj/effect/overmap/visitable/MouseExited()
	closeToolTip(usr) //No reason not to, really
	..()

///Returns the level_data for the highest level in the root z-stack associated to this marker.
/obj/effect/overmap/visitable/proc/get_topmost_level_data()
	if(!length(map_z))
		CRASH("Tried to get the topmost level for an overmap marker that doesn't have associated z-levels.")

	//Save some time for simple cases
	if(length(map_z) == 1)
		return SSmapping.levels_by_z[map_z[1]]

	//Attempts grabbing the map_data for the current level stack, and use it if we have one
	var/obj/abstract/map_data/M = global.get_map_data(map_z[1])
	if(M)
		return SSmapping.levels_by_z[M.z]

	//If no z stack data, assume levels are laid out from the bottommost z level towards the topmost.
	return SSmapping.levels_by_z[max(map_z)]

/obj/effect/overmap/visitable/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"
	anchored = 1

// Because of the way these are spawned, they will potentially have their invisibility adjusted by the turfs they are mapped on
// prior to being moved to the overmap. This blocks that. Use set_invisibility to adjust invisibility as needed instead.
/obj/effect/overmap/visitable/sector/hide()
	return

/obj/effect/overmap/visitable/proc/allow_free_landing(var/datum/shuttle/landing_shuttle)
	return free_landing

/obj/effect/overmap/visitable/handle_overmap_pixel_movement()
	..()
	for(var/thing in get_linked_machines_of_type(/obj/machinery/computer/ship))
		var/obj/machinery/computer/ship/machine = thing
		if(machine.z in map_z)
			for(var/weakref/W in machine.viewers)
				var/mob/M = W.resolve()
				if(istype(M) && M.client)
					M.client.default_pixel_x = pixel_x
					M.client.default_pixel_y = pixel_y
					M.client.pixel_x = pixel_x
					M.client.pixel_y = pixel_y
