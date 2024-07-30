/datum/mob_controller/passive
	speak_chance     = 0.25
	turns_per_wander = 10
	var/weakref/flee_target
	var/turns_since_scan

/datum/mob_controller/passive/proc/update_targets()
	//see if we should stop fleeing
	var/atom/flee_target_atom = flee_target?.resolve()
	if(istype(flee_target_atom) && (flee_target_atom.loc in view(body)))
		startle()
		stop_wandering()
		if(body.MayMove())
			var/static/datum/automove_metadata/_passive_flee_metadata = new(
				_avoid_target = TRUE,
				_acceptable_distance = 6
			)
			body.set_moving_quickly()
			body.start_automove(flee_target_atom, metadata = _passive_flee_metadata)
			return TRUE

	flee_target = null
	body.set_moving_slowly()
	body.stop_automove()
	resume_wandering()
	return FALSE

/datum/mob_controller/passive/do_process(time_elapsed)

	if(!(. = ..()))
		return

	// Handle fleeing from aggressors.
	if(body.stat == CONSCIOUS)
		turns_since_scan++
		if (turns_since_scan > 10)
			turns_since_scan = 0
			if(update_targets())
				return

	// Handle sleeping or wandering.
	if(isnull(flee_target))
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
			update_targets()
