/datum/mob_controller/passive/hunter
	var/weakref/hunt_target
	var/next_hunt = 0

/datum/mob_controller/passive/hunter/update_targets()
	// Fleeing takes precedence.
	. = ..()
	if(!.  && !get_target() && world.time >= next_hunt) // TODO: generalized nutrition process. && body.get_nutrition() < body.get_max_nutrition() * 0.5)
		for(var/mob/living/snack in view(body)) //search for a new target
			if(can_hunt(snack))
				set_target(snack)
				break

	return . || !!get_target()

/datum/mob_controller/passive/hunter/proc/can_hunt(mob/living/victim)
	return !victim.isSynthetic() && (victim.stat == DEAD || victim.get_object_size() < body.get_object_size())

/datum/mob_controller/passive/hunter/proc/try_attack_prey(mob/living/prey)
	body.set_intent(I_FLAG_HARM)
	body.ClickOn(prey)

/datum/mob_controller/passive/hunter/proc/consume_prey(mob/living/prey)
	if(prey.stat != DEAD)
		return
	body.visible_message(SPAN_DANGER("\The [body] consumes the body of \the [prey]!"))
	var/remains_type = prey.get_remains_type()
	if(remains_type)
		var/obj/item/remains/remains = new remains_type(get_turf(prey))
		remains.desc += "These look like they belonged to \a [prey.name]."
	body.adjust_nutrition(5 * prey.get_max_health())
	next_hunt = world.time + rand(15 MINUTES, 30 MINUTES)
	if(prob(5))
		prey.gib()
	else
		qdel(prey)
	set_target(null)
	resume_wandering()

/datum/mob_controller/passive/hunter/get_target(atom/new_target)
	if(isnull(hunt_target))
		return null
	var/atom/prey = hunt_target.resolve()
	if(!istype(prey) || QDELETED(prey))
		set_target(null)
		return null
	return prey

/datum/mob_controller/passive/hunter/set_target(atom/new_target)
	hunt_target = new_target ? weakref(new_target) : null
	return TRUE

/datum/mob_controller/passive/hunter/do_process(time_elapsed)
	if(!(. = ..()))
		return
	if(body.incapacitated() || body.current_posture?.prone || body.buckled || flee_target || !get_target())
		return
	process_hunting(get_target())

/datum/mob_controller/passive/hunter/proc/process_hunting(atom/target)

	if(!istype(target) || QDELETED(target) || !(target in view(body)))
		set_target(null)
		resume_wandering()
		return FALSE

	// Find or pursue the target.
	if(!body.Adjacent(target))
		stop_wandering()
		body.start_automove(target)
		return FALSE

	if(!ismob(target))
		return TRUE // Indicates a valid target that this base proc does not handle.

	// Hunt/consume the target.
	. = FALSE // we handle mobs already
	var/mob/prey = target
	if(prey.stat != DEAD && (!is_friend(prey) || !handle_friend_hunting(prey)))
		try_attack_prey(prey)
	if(QDELETED(prey))
		set_target(null)
		resume_wandering()
		return
	// Eat the mob.
	consume_prey(prey)

// Stub for hawks to return to their handler and dock with the mothership.
/datum/mob_controller/passive/hunter/proc/handle_friend_hunting(mob/user)
	return FALSE
