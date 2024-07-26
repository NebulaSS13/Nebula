// Admin object possession
/datum/movement_handler/mob/admin_possess/DoMove(direction, mob/mover, is_external)
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
/datum/movement_handler/mob/death/DoMove(direction, mob/mover, is_external)
	if(mob != mover || mob.stat != DEAD)
		return

	. = MOVEMENT_HANDLED

	if(!mob.client)
		return

	mob.ghostize()

// Incorporeal/Ghost movement
/datum/movement_handler/mob/incorporeal/DoMove(direction, mob/mover, is_external)
	. = MOVEMENT_HANDLED
	direction = mob.AdjustMovementDirection(direction, mover)
	mob.set_glide_size(0)

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
/datum/movement_handler/mob/eye/DoMove(direction, mob/mover, is_external)
	if(IS_NOT_SELF(mover)) // We only care about direct movement
		return
	if(!mob.eyeobj)
		return
	mob.eyeobj.EyeMove(direction)
	return MOVEMENT_HANDLED

/datum/movement_handler/mob/eye/MayMove(mob/mover, is_external)
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
/datum/movement_handler/mob/space/DoMove(direction, mob/mover, is_external)
	if(mob.has_gravity() || (IS_NOT_SELF(mover) && is_external))
		return
	if(!allow_move || !mob.space_do_move(allow_move, direction))
		return MOVEMENT_HANDLED

/datum/movement_handler/mob/space/MayMove(mob/mover, is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED
	if(!mob.has_gravity())
		allow_move = mob.Process_Spacemove(1)
		if(!allow_move)
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Buckle movement
/datum/movement_handler/mob/buckle_relay/DoMove(direction, mob/mover, is_external)
	return mob?.buckled?.handle_buckled_relaymove(src, mob, direction, mover)

/datum/movement_handler/mob/buckle_relay/MayMove(mob/mover, is_external)
	if(mob.buckled)
		return mob.buckled.MayMove(mover, FALSE) ? (MOVEMENT_PROCEED|MOVEMENT_HANDLED) : MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Movement delay
/datum/movement_handler/mob/delay
	var/next_move

/datum/movement_handler/mob/delay/DoMove(var/direction, var/mover, var/is_external)
	if(!is_external)
		var/delay = max(1, mob.get_movement_delay(direction))
		if(direction & (direction - 1)) //moved diagonally successfully
			delay *= sqrt(2)
		next_move = world.time + delay
		mob.set_glide_size(delay)

/datum/movement_handler/mob/delay/MayMove(mob/mover, is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED
	return ((mover && mover != mob) ||  world.time >= next_move) ? MOVEMENT_PROCEED : MOVEMENT_STOP

/datum/movement_handler/mob/delay/proc/SetDelay(var/delay)
	next_move = max(next_move, world.time + delay)

/datum/movement_handler/mob/delay/proc/AddDelay(var/delay)
	next_move += max(0, delay)

// Stop effect
/datum/movement_handler/mob/DoMove(direction, mob/mover, is_external)
	if(MayMove(mover, is_external) == MOVEMENT_STOP)
		return MOVEMENT_HANDLED

/datum/movement_handler/mob/stop_effect/MayMove(mob/mover, is_external)
	for(var/obj/effect/stop/S in mob.loc)
		if(S.victim == mob)
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Transformation
/datum/movement_handler/mob/transformation/MayMove(mob/mover, is_external)
	return MOVEMENT_STOP

// Consciousness - Is the entity trying to conduct the move conscious?
/datum/movement_handler/mob/conscious/MayMove(mob/mover, is_external)
	return (mover ? mover.stat == CONSCIOUS : mob.stat == CONSCIOUS) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Along with more physical checks
/datum/movement_handler/mob/physically_capable/MayMove(mob/mover, is_external)
	// We only check physical capability if the host mob tried to do the moving
	if(mover && mover != mob)
		return MOVEMENT_PROCEED
	if(mob.incapacitated(INCAPACITATION_DISABLED & ~INCAPACITATION_FORCELYING))
		return MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Is anything physically preventing movement?
/datum/movement_handler/mob/physically_restrained/MayMove(mob/mover, is_external)
	if(istype(mob.buckled) && !mob.buckled.buckle_movable)
		if(mover == mob)
			to_chat(mob, SPAN_WARNING("You're buckled to \the [mob.buckled]!"))
		return MOVEMENT_STOP

	if(mob.anchored)
		if(mover == mob)
			to_chat(mob, SPAN_WARNING("You're anchored down!"))
		return MOVEMENT_STOP

	if(LAZYLEN(mob.pinned))
		if(mover == mob)
			to_chat(mob, SPAN_WARNING("You're pinned down by \a [mob.pinned[1]]!"))
		return MOVEMENT_STOP

	for(var/obj/item/grab/G as anything in mob.grabbed_by)
		if(G.assailant != mob && G.assailant != mover && (mob.restrained() || G.stop_move()))
			if(mover == mob)
				to_chat(mob, SPAN_WARNING("You're restrained and cannot move!"))
			mob.ProcessGrabs()
			return MOVEMENT_STOP

	return MOVEMENT_PROCEED

// Finally... the last of the mob movement junk
/datum/movement_handler/mob/movement/DoMove(direction, mob/mover, is_external)
	. = MOVEMENT_HANDLED

	if(!mob || mob.moving)
		return

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	//We are now going to move
	mob.moving = 1

	if(mover == mob)
		direction = mob.AdjustMovementDirection(direction, mover)

	var/turf/old_turf = get_turf(mob)
	step(mob, direction)

	if(!mob)
		return // If the mob gets deleted on move (e.g. Entered, whatever), it wipes this reference on us in Destroy (and we should be aborting all action anyway).
	if(mob.loc == old_turf) // Did not move for whatever reason.
		mob.moving = FALSE
		return

	mob.handle_footsteps()

	// Sprinting uses up stamina and causes exertion effects.
	if(MOVING_QUICKLY(mob))
		mob.last_quick_move_time = world.time
		mob.adjust_stamina(-(mob.get_stamina_used_per_step() * (1+mob.encumbrance())))
		if(ishuman(mob))
			var/decl/species/species = mob.get_species()
			if(species)
				species.handle_exertion(mob)

	//Moving with objects stuck in you can cause bad times.
	mob.handle_embedded_and_stomach_objects()
	mob.moving = FALSE

/datum/movement_handler/mob/movement/MayMove(mob/mover, is_external)
	return IS_SELF(mover) &&  mob.moving ? MOVEMENT_STOP : MOVEMENT_PROCEED

/mob/proc/get_stamina_used_per_step()
	return 1

/mob/proc/get_stamina_skill_mod()
	return 1

/mob/living/human/get_stamina_skill_mod()
	var/mod = (1-((get_skill_value(SKILL_HAULING) - SKILL_MIN)/(SKILL_MAX - SKILL_MIN)))
	if(species && (species.species_flags & SPECIES_FLAG_LOW_GRAV_ADAPTED))
		if(has_gravity())
			mod *= 1.2
		else
			mod *= 0.8
	return mod

/mob/living/human/get_stamina_used_per_step()
	return get_config_value(/decl/config/num/movement_min_sprint_cost) + get_config_value(/decl/config/num/movement_skill_sprint_cost_range) * get_stamina_skill_mod()

// Misc. helpers
/mob/proc/MayEnterTurf(var/turf/T)
	return T && !((mob_flags & MOB_FLAG_HOLY_BAD) && check_is_holy_turf(T))

/**
 * This proc adjusts movement direction for mobs with STAT_CONFUSE.
 *
 * Returns a direction, randomly adjusted if the mob had STAT_CONFUSE.
 *
 * Arguments:
 * * direction: The direction, mob was going to move before adjustment
 * * mover: The initiator of movement
 */
/mob/proc/AdjustMovementDirection(var/direction, var/mob/mover)

	if(!direction || !isnum(direction))
		return 0

	. = direction

	// If we are moved not on our own, we don't get move debuff
	if(src != mover)
		return

	if(!HAS_STATUS(src, STAT_CONFUSE))
		return

	var/stability = MOVING_DELIBERATELY(src) ? 75 : 25
	if(prob(stability))
		return

	return prob(50) ? global.cw_dir[.] : global.ccw_dir[.]
