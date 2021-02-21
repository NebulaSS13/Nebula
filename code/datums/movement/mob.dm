// Movement relayed to self handling
/datum/movement_handler/mob/relayed_movement
	var/prevent_host_move = FALSE
	var/list/allowed_movers

/datum/movement_handler/mob/relayed_movement/MayMove(var/mob/mover, var/is_external)
	if(is_external)
		return MOVEMENT_PROCEED
	if(mover == mob && !(prevent_host_move && LAZYLEN(allowed_movers) && !LAZYISIN(allowed_movers, mover)))
		return MOVEMENT_PROCEED
	if(LAZYISIN(allowed_movers, mover))
		return MOVEMENT_PROCEED

	return MOVEMENT_STOP

/datum/movement_handler/mob/relayed_movement/proc/AddAllowedMover(var/mover)
	LAZYDISTINCTADD(allowed_movers, mover)

/datum/movement_handler/mob/relayed_movement/proc/RemoveAllowedMover(var/mover)
	LAZYREMOVE(allowed_movers, mover)

// Admin object possession
/datum/movement_handler/mob/admin_possess/DoMove(var/direction)
	if(QDELETED(mob.control_object))
		return MOVEMENT_REMOVE

	. = MOVEMENT_HANDLED

	var/atom/movable/control_object = mob.control_object
	step(control_object, direction)
	if(QDELETED(control_object))
		. |= MOVEMENT_REMOVE
	else
		control_object.set_dir(direction)

// Death handling
/datum/movement_handler/mob/death/DoMove()
	if(mob.stat != DEAD)
		return
	. = MOVEMENT_HANDLED
	if(!mob.client)
		return
	mob.ghostize()

// Incorporeal/Ghost movement
/datum/movement_handler/mob/incorporeal/DoMove(var/direction)
	. = MOVEMENT_HANDLED
	direction = mob.AdjustMovementDirection(direction)

	var/turf/T = get_step(mob, direction)
	if(!mob.MayEnterTurf(T))
		return

	if(!mob.forceMove(T))
		return

	mob.set_dir(direction)
	mob.PostIncorporealMovement()

/mob/proc/PostIncorporealMovement()
	return

// Eye movement
/datum/movement_handler/mob/eye/DoMove(var/direction, var/mob/mover)
	if(IS_NOT_SELF(mover)) // We only care about direct movement
		return
	if(!mob.eyeobj)
		return
	mob.eyeobj.EyeMove(direction)
	return MOVEMENT_HANDLED

/datum/movement_handler/mob/eye/MayMove(var/mob/mover, var/is_external)
	if(IS_NOT_SELF(mover))
		return MOVEMENT_PROCEED
	if(is_external)
		return MOVEMENT_PROCEED
	if(!mob.eyeobj)
		return MOVEMENT_PROCEED
	return (MOVEMENT_PROCEED|MOVEMENT_HANDLED)

/datum/movement_handler/mob/space
	var/allow_move

// Space movement
/datum/movement_handler/mob/space/DoMove(var/direction, var/mob/mover)
	if(!mob.has_gravity())
		if(!allow_move)
			return MOVEMENT_HANDLED
		if(!mob.space_do_move(allow_move, direction))
			return MOVEMENT_HANDLED

/datum/movement_handler/mob/space/MayMove(var/mob/mover, var/is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED

	if(!mob.has_gravity())
		allow_move = mob.Process_Spacemove(1)
		if(!allow_move)
			return MOVEMENT_STOP

	return MOVEMENT_PROCEED

// Buckle movement
/datum/movement_handler/mob/buckle_relay/DoMove(var/direction, var/mover)
	// TODO: Datumlize buckle-handling
	if(istype(mob.buckled, /obj/vehicle))
		//drunk driving
		if(mob.confused && prob(20)) //vehicles tend to keep moving in the same direction
			direction = turn(direction, pick(90, -90))
		mob.buckled.relaymove(mob, direction)
		return MOVEMENT_HANDLED

	if(mob.buckled) // Wheelchair driving!
		if(isspaceturf(mob.loc))
			return // No wheelchair driving in space
		if(istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
			. = MOVEMENT_HANDLED
			if(!mob.has_held_item_slot())
				return // No hands to drive your chair? Tough luck!
			//drunk wheelchair driving
			direction = mob.AdjustMovementDirection(direction)
			mob.buckled.DoMove(direction, mob)

/datum/movement_handler/mob/buckle_relay/MayMove(var/mover)
	if(mob.buckled)
		return mob.buckled.MayMove(mover, FALSE) ? (MOVEMENT_PROCEED|MOVEMENT_HANDLED) : MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Movement delay
/datum/movement_handler/mob/delay
	var/next_move

/datum/movement_handler/mob/delay/DoMove(var/direction, var/mover, var/is_external)
	if(!is_external)
		var/delay = max(1, mob.movement_delay())
		next_move = world.time + delay
		mob.glide_size = ADJUSTED_GLIDE_SIZE(delay)

/datum/movement_handler/mob/delay/MayMove(var/mover, var/is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED
	return ((mover && mover != mob) ||  world.time >= next_move) ? MOVEMENT_PROCEED : MOVEMENT_STOP

/datum/movement_handler/mob/delay/proc/SetDelay(var/delay)
	next_move = max(next_move, world.time + delay)

/datum/movement_handler/mob/delay/proc/AddDelay(var/delay)
	next_move += max(0, delay)

// Stop effect
/datum/movement_handler/mob/stop_effect/DoMove()
	if(MayMove() == MOVEMENT_STOP)
		return MOVEMENT_HANDLED

/datum/movement_handler/mob/stop_effect/MayMove()
	for(var/obj/effect/stop/S in mob.loc)
		if(S.victim == mob)
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Transformation
/datum/movement_handler/mob/transformation/MayMove()
	return MOVEMENT_STOP

// Consciousness - Is the entity trying to conduct the move conscious?
/datum/movement_handler/mob/conscious/MayMove(var/mob/mover)
	return (mover ? mover.stat == CONSCIOUS : mob.stat == CONSCIOUS) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Along with more physical checks
/datum/movement_handler/mob/physically_capable/MayMove(var/mob/mover)
	// We only check physical capability if the host mob tried to do the moving
	return ((mover && mover != mob) || !mob.incapacitated(INCAPACITATION_DISABLED & ~INCAPACITATION_FORCELYING)) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Is anything physically preventing movement?
/datum/movement_handler/mob/physically_restrained/MayMove(var/mob/mover)
	if(mob.anchored)
		if(mover == mob)
			to_chat(mob, SPAN_WARNING("You're anchored down!"))
		return MOVEMENT_STOP

	if(istype(mob.buckled) && !mob.buckled.buckle_movable)
		if(mover == mob)
			to_chat(mob, SPAN_WARNING("You're buckled to \the [mob.buckled]!"))
		return MOVEMENT_STOP

	if(LAZYLEN(mob.pinned))
		if(mover == mob)
			to_chat(mob, SPAN_WARNING("You're pinned down by \a [mob.pinned[1]]!"))
		return MOVEMENT_STOP

	for(var/obj/item/grab/G in mob.grabbed_by)
		if(G.assailant != mob && (mob.restrained() || G.stop_move()))
			if(mover == mob)
				to_chat(mob, SPAN_WARNING("You're restrained and cannot move!"))
			mob.ProcessGrabs()
			return MOVEMENT_STOP

	return MOVEMENT_PROCEED

// Finally.. the last of the mob movement junk
/datum/movement_handler/mob/movement/DoMove(var/direction, var/mob/mover)
	. = MOVEMENT_HANDLED

	if(mob.moving)
		return

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	//We are now going to move
	mob.moving = 1

	direction = mob.AdjustMovementDirection(direction)
	var/turf/old_turf = get_turf(mob)
	step(mob, direction)

	if(isturf(mob.loc))
		for(var/atom/movable/M in mob.ret_grab())
			if(M != src && M.loc != mob.loc && !M.anchored && get_dist(old_turf, M) <= 1)
				M.glide_size = mob.glide_size // This is adjusted by grabs again from events/some of the procs below, but doing it here makes it more likely to work with recursive movement.
				step(M, get_dir(M.loc, old_turf))
		for(var/obj/item/grab/G in mob.get_active_grabs())
			G.adjust_position()

	if(QDELETED(mob)) // No idea why, but this was causing null check runtimes on live.
		return

	for (var/obj/item/grab/G in mob)
		if (G.assailant_reverse_facing())
			mob.set_dir(GLOB.reverse_dir[direction])
		G.assailant_moved()
	for (var/obj/item/grab/G in mob.grabbed_by)
		G.adjust_position()

	if(direction & (UP|DOWN))
		var/txt_dir = (direction & UP) ? "upwards" : "downwards"
		old_turf.visible_message(SPAN_NOTICE("[mob] moves [txt_dir]."))
		for(var/obj/item/grab/G in mob.get_active_grabs())
			if(!G.affecting)
				continue
			var/turf/start = G.affecting.loc
			var/turf/destination = (direction == UP) ? GetAbove(G.affecting) : GetBelow(G.affecting)
			if(!start.CanZPass(G.affecting, direction))
				to_chat(mob, SPAN_WARNING("\The [start] blocked your pulled object!"))
				qdel(G)
				continue
			if(!destination.CanZPass(G.affecting, direction))
				to_chat(mob, SPAN_WARNING("The [G.affecting] you were pulling bumps up against \the [destination]."))
				qdel(G)
				continue
			for(var/atom/A in destination)
				if(!A.CanMoveOnto(G.affecting, start, 1.5, direction))
					to_chat(mob, SPAN_WARNING("\The [A] blocks the [G.affecting] you were pulling."))
					qdel(G)
					continue
			G.affecting.forceMove(destination)
			continue

	//Moving with objects stuck in you can cause bad times.
	if(get_turf(mob) != old_turf)
		if(MOVING_QUICKLY(mob))
			mob.last_quick_move_time = world.time
			mob.adjust_stamina(-(mob.get_stamina_used_per_step() * (1+mob.encumbrance())))
		mob.handle_embedded_and_stomach_objects()

	mob.moving = 0

/datum/movement_handler/mob/movement/MayMove(var/mob/mover)
	return IS_SELF(mover) &&  mob.moving ? MOVEMENT_STOP : MOVEMENT_PROCEED

/mob/proc/get_stamina_used_per_step()
	return 1

/mob/living/carbon/human/get_stamina_used_per_step()
	var/mod = (1-((get_skill_value(SKILL_HAULING) - SKILL_MIN)/(SKILL_MAX - SKILL_MIN)))
	if(species && (species.species_flags & SPECIES_FLAG_LOW_GRAV_ADAPTED))
		if(has_gravity())
			mod *= 1.2
		else
			mod *= 0.8

	return config.minimum_sprint_cost + (config.skill_sprint_cost_range * mod)

// Misc. helpers
/mob/proc/MayEnterTurf(var/turf/T)
	return T && !((mob_flags & MOB_FLAG_HOLY_BAD) && check_is_holy_turf(T))

/mob/proc/AdjustMovementDirection(var/direction)
	. = direction
	if(!confused)
		return

	var/stability = MOVING_DELIBERATELY(src) ? 75 : 25
	if(prob(stability))
		return

	return prob(50) ? GLOB.cw_dir[.] : GLOB.ccw_dir[.]
