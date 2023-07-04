//shuttle moving state defines are in setup.dm

/datum/shuttle
	var/name = ""
	var/display_name = "" // User-facing; defaults to name.
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	var/list/shuttle_area //can be both single area type or a list of areas
	var/obj/effect/shuttle_landmark/current_location //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/flags = 0
	var/process_state = IDLE_STATE //Used with SHUTTLE_FLAGS_PROCESS, as well as to store current state.
	var/category = /datum/shuttle
	var/multiz = 0	//how many multiz levels, starts at 0

	var/ceiling_type = /turf/unsimulated/floor/shuttle_ceiling

	var/sound_takeoff = 'sound/effects/shuttle_takeoff.ogg'
	var/sound_landing = 'sound/effects/shuttle_landing.ogg'

	var/knockdown = 1 //whether shuttle downs non-buckled people when it moves

	var/defer_initialisation = FALSE //this shuttle will/won't be initialised automatically. If set to true, you are responsible for initialzing the shuttle manually.
	                                 //Useful for shuttles that are initialed by map_template loading, or shuttles that are created in-game or not used.
	var/logging_home_tag   //Whether in-game logs will be generated whenever the shuttle leaves/returns to the landmark with this landmark_tag.
	var/logging_access     //Controls who has write access to log-related stuff; should correlate with pilot access.

	var/mothershuttle //tag of mothershuttle
	var/motherdock    //tag of mothershuttle landmark, defaults to starting location

/datum/shuttle/New(map_hash, var/obj/effect/shuttle_landmark/initial_location)
	..()
	if(!display_name)
		display_name = name
	if(map_hash) // We adjust all tag vars, including name, for the map on which they are loaded. This is also done on subtypes.
		ADJUST_TAG_VAR(name, map_hash)
		ADJUST_TAG_VAR(current_location, map_hash)
		ADJUST_TAG_VAR(logging_home_tag, map_hash)
		ADJUST_TAG_VAR(mothershuttle, map_hash)
		ADJUST_TAG_VAR(motherdock, map_hash)

	var/list/areas = list()
	if(!isnull(shuttle_area))
		if(!islist(shuttle_area))
			shuttle_area = list(shuttle_area)
		for(var/area_type in shuttle_area)
			if(istype(area_type, /area)) // If the shuttle area is already an instance, it does not need to be located.
				areas += area_type
				events_repository.register(/decl/observ/destroyed, area_type, src, .proc/remove_shuttle_area)
				continue
			var/area/A
			if(map_hash && islist(SSshuttle.map_hash_to_areas[map_hash]))
				A = SSshuttle.map_hash_to_areas[map_hash][area_type] // We try to find the correct area of the given type.
			else
				A = locate(area_type) // But if this is a mainmap shuttle, there is only one anyway so just find it.
			if(!istype(A))
				CRASH("Shuttle \"[name]\" couldn't locate area [area_type].")
			areas += A
			events_repository.register(/decl/observ/destroyed, A, src, .proc/remove_shuttle_area)
		shuttle_area = areas

	if(initial_location)
		current_location = initial_location
	else
		current_location = SSshuttle.get_landmark(current_location)
	if(!istype(current_location))
		CRASH("Shuttle \"[name]\" could not find its starting location.")

	if(src.name in SSshuttle.shuttles)
		CRASH("A shuttle with the name '[name]' is already defined.")
	SSshuttle.shuttles[src.name] = src
	if(logging_home_tag)
		new /datum/shuttle_log(src)
	if(flags & SHUTTLE_FLAGS_PROCESS)
		SSshuttle.process_shuttles += src
	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(SSsupply.shuttle)
			CRASH("A supply shuttle is already defined.")
		SSsupply.shuttle = src

/datum/shuttle/proc/remove_shuttle_area(area/area_to_remove)
	events_repository.unregister(/decl/observ/destroyed, area_to_remove, src, .proc/remove_shuttle_area)
	SSshuttle.shuttle_areas -= area_to_remove
	shuttle_area -= area_to_remove
	if(!length(shuttle_area))
		qdel(src)

/datum/shuttle/Destroy()
	current_location = null

	SSshuttle.shuttles -= src.name
	SSshuttle.process_shuttles -= src
	SSshuttle.shuttle_logs -= src
	if(SSsupply.shuttle == src)
		SSsupply.shuttle = null

	. = ..()

/datum/shuttle/proc/short_jump(var/obj/effect/shuttle_landmark/destination)
	if(moving_status != SHUTTLE_IDLE) return

	moving_status = SHUTTLE_WARMUP
	if(sound_takeoff)
		playsound(current_location, sound_takeoff, 100, 20, 0.2)
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			var/datum/shuttle/autodock/S = src
			if(istype(S))
				S.cancel_launch(null)
			return

		moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
		attempt_move(destination)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/long_jump(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	if(moving_status != SHUTTLE_IDLE) return

	var/obj/effect/shuttle_landmark/start_location = current_location

	moving_status = SHUTTLE_WARMUP
	if(sound_takeoff)
		playsound(current_location, sound_takeoff, 100, 20, 0.2)
	spawn(warmup_time*10)
		if(moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			var/datum/shuttle/autodock/S = src
			if(istype(S))
				S.cancel_launch(null)
			return

		arrive_time = world.time + travel_time*10
		moving_status = SHUTTLE_INTRANSIT
		if(attempt_move(interim))
			var/fwooshed = 0
			while (world.time < arrive_time)
				if(!fwooshed && (arrive_time - world.time) < 100)
					fwooshed = 1
					playsound(destination, sound_landing, 100, 0, 7)
				sleep(5)
			if(!attempt_move(destination))
				attempt_move(start_location) //try to go back to where we started. If that fails, I guess we're stuck in the interim location

		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/fuel_check()
	return 1 //fuel check should always pass in non-overmap shuttles (they have magic engines)

/*****************
* Shuttle Moved Handling * (Observer Pattern Implementation: Shuttle Moved)
* Shuttle Pre Move Handling * (Observer Pattern Implementation: Shuttle Pre Move)
*****************/

/datum/shuttle/proc/attempt_move(var/obj/effect/shuttle_landmark/destination)
	if(current_location == destination)
		return FALSE

	if(!destination.is_valid(src))
		return FALSE
	if(current_location.cannot_depart(src))
		return FALSE
	testing("[src] moving to [destination]. Areas are [english_list(shuttle_area)]")
	var/list/translation = list()
	for(var/area/A in shuttle_area)
		testing("Moving [A]")
		translation += get_turf_translation(get_turf(current_location), get_turf(destination), A.contents)
	var/obj/effect/shuttle_landmark/old_location = current_location
	RAISE_EVENT(/decl/observ/shuttle_pre_move, src, old_location, destination)
	shuttle_moved(destination, translation)
	RAISE_EVENT_REPEAT(/decl/observ/shuttle_moved, src, old_location, destination)
	if(istype(old_location))
		old_location.shuttle_departed(src)
	destination.shuttle_arrived(src)
	return TRUE

// Attempts to force move the shuttle with minimal checks.
// In ideal use, none of the checks fail and this is a standard move to location while overriding any movement time or fuel checks.
// Anything in the arrival area will be destroyed with no warning. Use sparingly.
/datum/shuttle/proc/attempt_force_move(var/obj/effect/shuttle_landmark/destination)
	if(current_location == destination)
		log_error("Error when attempting to force move a shuttle: Attempted to move [src] to its current location [destination].")
		return FALSE

	testing("Force moving [src] to [destination]. Areas are [english_list(shuttle_area)]")
	var/list/translation = list()

	for(var/area/A in shuttle_area)
		testing("Moving [A]")
		translation += get_turf_translation(get_turf(current_location), get_turf(destination), A.contents)
	var/obj/effect/shuttle_landmark/old_location = current_location
	RAISE_EVENT(/decl/observ/shuttle_pre_move, src, old_location, destination)
	shuttle_moved(destination, translation)
	RAISE_EVENT_REPEAT(/decl/observ/shuttle_moved, src, old_location, destination)
	if(istype(old_location))
		old_location.shuttle_departed(src)
	destination.shuttle_arrived(src)
	return TRUE

//just moves the shuttle from A to B, if it can be moved
//A note to anyone overriding move in a subtype. shuttle_moved() must absolutely not, under any circumstances, fail to move the shuttle.
//If you want to conditionally cancel shuttle launches, that logic must go in short_jump(), long_jump() or attempt_move()
/datum/shuttle/proc/shuttle_moved(var/obj/effect/shuttle_landmark/destination, var/list/turf_translation)

//	log_debug("move_shuttle() called for [shuttle_tag] leaving [origin] en route to [destination].")
//	log_degug("area_coming_from: [origin]")
//	log_debug("destination: [destination]")
	if((flags & SHUTTLE_FLAGS_ZERO_G))
		var/new_grav = 1
		if(destination.flags & SLANDMARK_FLAG_ZERO_G)
			var/area/new_area = get_area(destination)
			new_grav = new_area.has_gravity
		for(var/area/our_area in shuttle_area)
			if(our_area.has_gravity != new_grav)
				our_area.gravitychange(new_grav)

	for(var/turf/src_turf in turf_translation)
		var/turf/dst_turf = turf_translation[src_turf]
		if(src_turf.is_solid_structure()) //in case someone put a hole in the shuttle and you were lucky enough to be under it
			for(var/atom/movable/AM in dst_turf)
				if(AM.movable_flags & MOVABLE_FLAG_DEL_SHUTTLE)
					qdel(AM)
					continue
				if(!AM.simulated)
					continue
				if(isliving(AM))
					var/mob/living/bug = AM
					bug.gib()
				else
					qdel(AM) //it just gets atomized I guess? TODO throw it into space somewhere, prevents people from using shuttles as an atom-smasher
	for(var/area/A in shuttle_area)
		// if there was a zlevel above our origin, erase our ceiling now we're leaving
		if(HasAbove(current_location.z))
			for(var/turf/TO in A.contents)
				var/turf/TA = GetAbove(TO)
				if(istype(TA, ceiling_type))
					TA.ChangeTurf(get_base_turf_by_area(TA), 1, 1)
		if(knockdown)
			A.throw_unbuckled_occupants(4, 1)

	if(logging_home_tag)
		var/datum/shuttle_log/s_log = SSshuttle.shuttle_logs[src]
		s_log.handle_move(current_location, destination)

	var/list/new_turfs = translate_turfs(turf_translation, current_location.base_area, current_location.base_turf, TRUE)
	current_location = destination

	// if there's a zlevel above our destination, paint in a ceiling on it so we retain our air
	if(HasAbove(current_location.z))
		for(var/area/A in shuttle_area)
			for(var/turf/TD in A.contents)
				var/turf/TA = GetAbove(TD)
				if(istype(TA, get_base_turf_by_area(TA)) || (istype(TA) && TA.is_open()))
					if(get_area(TA) in shuttle_area)
						continue
					TA.ChangeTurf(ceiling_type, TRUE, TRUE, TRUE)

	handle_pipes_and_power_on_move(new_turfs)

	if(mothershuttle)
		var/datum/shuttle/mothership = SSshuttle.shuttles[mothershuttle]
		if(mothership)
			if(current_location.landmark_tag == motherdock)
				mothership.shuttle_area |= shuttle_area
			else
				mothership.shuttle_area -= shuttle_area

// Remove all powernets and pipenets that were affected, and rebuild them.
/datum/shuttle/proc/handle_pipes_and_power_on_move(var/list/new_turfs)
	var/list/powernets = list()
	var/list/cables = list()
	var/list/pipes = list()

	for(var/turf/T in new_turfs)
		for(var/obj/structure/cable/cable in T)
			powernets |= cable.powernet
		for(var/obj/machinery/atmospherics/pipe in T)
			pipes |= pipe
			if(LAZYLEN(pipe.nodes_to_networks))
				pipes |= pipe.nodes_to_networks // This gets all pipes that used to be adjacent to us
		for(var/direction in global.cardinal) // We do this so that if a shuttle lands in a way that should imply a new pipe/power connection, that actually happens
			var/turf/neighbor = get_step(T, direction)
			if(neighbor)
				for(var/obj/structure/cable/cable in neighbor)
					powernets |= cable.powernet
				for(var/obj/machinery/atmospherics/pipe in neighbor)
					pipes |= pipe

	for(var/datum/powernet/P in powernets)
		cables |= P.cables
		qdel(P)
	for(var/obj/structure/cable/C in cables)
		if(!C.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(C)
			propagate_network(C,C.powernet)
	for(var/obj/machinery/atmospherics/pipe as anything in pipes)
		pipe.atmos_init() // this will clear pipenet/pipeline
	for(var/obj/machinery/atmospherics/pipe as anything in pipes)
		pipe.build_network()

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)

/datum/shuttle/proc/find_children()
	. = list()
	for(var/shuttle_name in SSshuttle.shuttles)
		var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_name]
		if(shuttle.mothershuttle == name)
			. += shuttle

//Returns those areas that are not actually child shuttles.
/datum/shuttle/proc/find_childfree_areas()
	. = shuttle_area.Copy()
	for(var/datum/shuttle/child in find_children())
		. -= child.shuttle_area

/datum/shuttle/autodock/proc/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return "\the [current_location]"

/datum/shuttle/autodock/proc/get_destination_name()
	if(!next_location)
		return "None"
	return next_location.name

// Testing
// Returns either null (all good) or a string explaining any issues.
/datum/shuttle/proc/test_landmark_setup()
	if(!current_location)
		if(initial(current_location))
			return "Starting location (tag: [initial(current_location)]) was not found."
		else
			return "Starting location was not set or forwarded properly."
	if(!motherdock && initial(motherdock))
		return "The motherdock (tag: [initial(motherdock)]) was not found."
	if(!mothershuttle && initial(mothershuttle))
		return "The mothershuttle (tag: [initial(mothershuttle)]) was not found."