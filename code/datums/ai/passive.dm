/datum/mob_controller/passive
	speak_chance     = 0.25
	turns_per_wander = 10
	var/weakref/flee_target
	var/turns_since_scan

/datum/mob_controller/passive/proc/update_targets()
	//see if we should stop fleeing
	var/atom/flee_target_atom = flee_target?.resolve()
	if(istype(flee_target_atom) && (flee_target_atom.loc in view(body)))
		if(body.MayMove())
			walk_away(body, flee_target_atom, 7, 2)
		stop_wandering()
	else
		flee_target = null
		resume_wandering()
	return !isnull(flee_target)

/datum/mob_controller/passive/do_process(time_elapsed)
	..()

	// Handle fleeing from aggressors.
	turns_since_scan++
	if (turns_since_scan > 10)
		body.stop_automove()
		turns_since_scan = 0
		if(update_targets())
			return

	// Handle sleeping or wandering.
	if(body.stat == CONSCIOUS && prob(0.25))
		body.set_stat(UNCONSCIOUS)
		do_wander = FALSE
		speak_chance = 0
	else if(body.stat == UNCONSCIOUS && prob(0.5))
		body.set_stat(CONSCIOUS)
		do_wander = TRUE

/datum/mob_controller/passive/retaliate(atom/source)
	if((. = ..()))
		source = source || get_turf(body)
		if(istype(source))
			flee_target = weakref(source)
			turns_since_scan = 10
