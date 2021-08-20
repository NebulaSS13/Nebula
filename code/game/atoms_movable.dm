/atom/movable
	layer = OBJ_LAYER
	appearance_flags = TILE_BOUND | PIXEL_SCALE | LONG_GLIDE
	glide_size = 8
	var/movable_flags
	var/last_move = null
	var/anchored = 0
	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/datum/thrownthing/throwing
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/item_state = null // Used to specify the item state for the on-mob overlays.
	var/does_spin = TRUE // Does the atom spin when thrown (of course it does :P)
	var/list/grabbed_by

	var/inertia_dir = 0
	var/atom/inertia_last_loc
	var/inertia_moving = 0
	var/inertia_next_move = 0
	var/inertia_move_delay = 5
	var/atom/movable/inertia_ignore

//call this proc to start space drifting
/atom/movable/proc/space_drift(direction)//move this down
	if(!loc || direction & (UP|DOWN) || Process_Spacemove(0))
		inertia_dir = 0
		inertia_ignore = null
		return 0

	inertia_dir = direction
	if(!direction)
		return 1
	inertia_last_loc = loc
	SSspacedrift.processing[src] = src
	return 1

//return 0 to space drift, 1 to stop, -1 for mobs to handle space slips
/atom/movable/proc/Process_Spacemove(var/allow_movement)
	if(!simulated)
		return 1

	if(has_gravity())
		return 1

	if(length(grabbed_by))
		return 1

	if(throwing)
		return 1

	if(anchored)
		return 1

	if(!isturf(loc))
		return 1

	if(locate(/obj/structure/lattice) in range(1, get_turf(src))) //Not realistic but makes pushing things in space easier
		return -1

	return 0

/atom/movable/hitby(var/atom/movable/AM, var/datum/thrownthing/TT)
	..()
	process_momentum(AM,TT)

/atom/movable/proc/process_momentum(var/atom/movable/AM, var/datum/thrownthing/TT)//physic isn't an exact science
	. = momentum_power(AM,TT)

	if(.)
		momentum_do(.,TT,AM)

/atom/movable/proc/momentum_power(var/atom/movable/AM, var/datum/thrownthing/TT)
	if(anchored)
		return 0

	. = (AM.get_mass()*TT.speed)/(get_mass()*min(AM.throw_speed,2))
	if(has_gravity())
		. *= 0.5

/atom/movable/proc/momentum_do(var/power, var/datum/thrownthing/TT)
	var/direction = TT.init_dir
	switch(power)
		if(0.75 to INFINITY)		//blown backward, also calls being pinned to walls
			throw_at(get_edge_target_turf(src, direction), min((TT.maxrange - TT.dist_travelled) * power, 10), throw_speed * min(power, 1.5))

		if(0.5 to 0.75)	//knocks them back and changes their direction
			step(src, direction)

		if(0.25 to 0.5)	//glancing change in direction
			var/drift_dir
			if(direction & (NORTH|SOUTH))
				if(inertia_dir & (NORTH|SOUTH))
					drift_dir |= (direction & (NORTH|SOUTH)) & (inertia_dir & (NORTH|SOUTH))
				else
					drift_dir |= direction & (NORTH|SOUTH)
			else
				drift_dir |= inertia_dir & (NORTH|SOUTH)
			if(direction & (EAST|WEST))
				if(inertia_dir & (EAST|WEST))
					drift_dir |= (direction & (EAST|WEST)) & (inertia_dir & (EAST|WEST))
				else
					drift_dir |= direction & (EAST|WEST)
			else
				drift_dir |= inertia_dir & (EAST|WEST)
			space_drift(drift_dir)

/atom/movable/proc/get_mass()
	return 1.5

/atom/movable/Bump(var/atom/A, yes)
	if(!QDELETED(throwing))
		throwing.hit_atom(A)

	if(inertia_dir)
		inertia_dir = 0

	if (A && yes)
		A.last_bumped = world.time
		INVOKE_ASYNC(A, /atom/proc/Bumped, src) // Avoids bad actors sleeping or unexpected side effects, as the legacy behavior was to spawn here
	..()

/atom/movable/proc/forceMove(atom/destination)
	if(QDELETED(src) && !QDESTROYING(src) && !isnull(destination))
		CRASH("Attempted to forceMove a QDELETED [src] out of nullspace!!!")
	if(loc == destination)
		return 0
	var/is_origin_turf = isturf(loc)
	var/is_destination_turf = isturf(destination)
	// It is a new area if:
	//  Both the origin and destination are turfs with different areas.
	//  When either origin or destination is a turf and the other is not.
	var/is_new_area = (is_origin_turf ^ is_destination_turf) || (is_origin_turf && is_destination_turf && loc.loc != destination.loc)

	var/atom/origin = loc
	loc = destination

	if(origin)
		origin.Exited(src, destination)
		if(is_origin_turf)
			for(var/atom/movable/AM in origin)
				AM.Uncrossed(src)
			if(is_new_area && is_origin_turf)
				origin.loc.Exited(src, destination)

	if(destination)
		destination.Entered(src, origin)
		if(is_destination_turf) // If we're entering a turf, cross all movable atoms
			for(var/atom/movable/AM in loc)
				if(AM != src)
					AM.Crossed(src)
			if(is_new_area && is_destination_turf)
				destination.loc.Entered(src, origin)
	return 1

/atom/movable/forceMove(atom/dest)
	var/old_loc = loc
	. = ..()
	if (.)
		// observ
		if(!loc)
			events_repository.raise_event(/decl/observ/moved, src, old_loc, null)

		// freelook
		if(opacity)
			updateVisibility(src)

		// lighting
		if (light_source_solo)
			light_source_solo.source_atom.update_light()
		else if (light_source_multi)
			var/datum/light_source/L
			var/thing
			for (thing in light_source_multi)
				L = thing
				L.source_atom.update_light()

/atom/movable/Move(...)
	var/old_loc = loc
	. = ..()
	if (.)
		if(!loc)
			events_repository.raise_event(/decl/observ/moved, src, old_loc, null)

		// freelook
		if(opacity)
			updateVisibility(src)

		// lighting
		if (light_source_solo)
			light_source_solo.source_atom.update_light()
		else if (light_source_multi)
			var/datum/light_source/L
			var/thing
			for (thing in light_source_multi)
				L = thing
				L.source_atom.update_light()

//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/datum/thrownthing/TT)
	SHOULD_CALL_PARENT(TRUE)
	if(istype(hit_atom) && !QDELETED(hit_atom))
		hit_atom.hitby(src, TT)

/atom/movable/proc/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback) //If this returns FALSE then callback will not be called.
	. = TRUE
	if (!target || speed <= 0 || QDELETED(src) || (target.z != src.z))
		return FALSE

	QDEL_NULL_LIST(grabbed_by)

	var/datum/thrownthing/TT = new(src, target, range, speed, thrower, callback)
	throwing = TT

	pixel_z = 0
	if(spin && does_spin)
		SpinAnimation(4,1)

	SSthrowing.processing[src] = TT
	if (SSthrowing.state == SS_PAUSED && length(SSthrowing.currentrun))
		SSthrowing.currentrun[src] = TT

//Overlays
/atom/movable/overlay
	var/atom/master = null
	var/follow_proc = /atom/movable/proc/move_to_loc_or_null
	anchored = TRUE
	simulated = FALSE

/atom/movable/overlay/Initialize()
	if(!loc)
		PRINT_STACK_TRACE("[type] created in nullspace.")
		return INITIALIZE_HINT_QDEL
	master = loc
	SetName(master.name)
	set_dir(master.dir)

	if(istype(master, /atom/movable))
		events_repository.register(/decl/observ/moved, master, src, follow_proc)
		SetInitLoc()

	events_repository.register(/decl/observ/destroyed, master, src, /datum/proc/qdel_self)
	events_repository.register(/decl/observ/dir_set, master, src, /atom/proc/recursive_dir_set)

	. = ..()

/atom/movable/overlay/proc/SetInitLoc()
	forceMove(master.loc)

/atom/movable/overlay/Destroy()
	if(istype(master, /atom/movable))
		events_repository.unregister(/decl/observ/moved, master, src)
	events_repository.unregister(/decl/observ/destroyed, master, src)
	events_repository.unregister(/decl/observ/dir_set, master, src)
	master = null
	. = ..()

/atom/movable/overlay/attackby(obj/item/I, mob/user)
	if (master)
		return master.attackby(I, user)

/atom/movable/overlay/attack_hand(mob/user)
	if (master)
		return master.attack_hand(user)

/atom/movable/proc/touch_map_edge()
	if(!simulated)
		return

	if(!z || (z in global.using_map.sealed_levels))
		return

	if(!global.universe.OnTouchMapEdge(src))
		return

	if(global.using_map.use_overmap)
		overmap_spacetravel(get_turf(src), src)
		return

	var/new_x
	var/new_y
	var/new_z = global.using_map.get_transit_zlevel(z)
	if(new_z)
		if(x <= TRANSITIONEDGE)
			new_x = world.maxx - TRANSITIONEDGE - 2
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (x >= (world.maxx - TRANSITIONEDGE + 1))
			new_x = TRANSITIONEDGE + 1
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (y <= TRANSITIONEDGE)
			new_y = world.maxy - TRANSITIONEDGE -2
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		else if (y >= (world.maxy - TRANSITIONEDGE + 1))
			new_y = TRANSITIONEDGE + 1
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		var/turf/T = locate(new_x, new_y, new_z)
		if(T)
			forceMove(T)

/atom/movable/proc/get_bullet_impact_effect_type()
	return BULLET_IMPACT_NONE

/atom/movable/attack_hand(mob/user)
	// Anchored check so we can operate switches etc on grab intent without getting grab failure msgs.
	if(isliving(user) && !user.lying && user.a_intent == I_GRAB && !anchored)
		var/mob/living/M = user
		M.make_grab(src)
		return 0
	. = ..()

/atom/movable/proc/pushed(var/pushdir)
	set waitfor = FALSE
	step(src, pushdir)

/**
* A wrapper for setDir that should only be able to fail by living mobs.
*
* Called from [/atom/movable/proc/keyLoop], this exists to be overwritten by living mobs with a check to see if we're actually alive enough to change directions
*/
/atom/movable/proc/keybind_face_direction(direction)
	return
