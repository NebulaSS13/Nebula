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
	if(isnull(flee_target) && prob(0.5))
		if(prob(50) && body.stat == CONSCIOUS)
			body.set_stat(UNCONSCIOUS)
			stop_wander = TRUE
			speak_chance = 0
		else if(body.stat == UNCONSCIOUS)
			body.set_stat(CONSCIOUS)
			stop_wander = FALSE
			speak_chance = initial(speak_chance)
		body.update_posture()

/datum/mob_controller/passive/retaliate(atom/source)
	if((. = ..()))
		source = source || get_turf(body)
		if(istype(source))
			flee_target = weakref(source)
			update_targets()

/datum/mob_controller/passive
	var/decl/skill/scooping_skill // If overridden (on a subtype, on a map/downstream, etc) check this skill to see if scooping should succeed uncontested.
	var/scooping_skill_req = SKILL_ADEPT

/datum/mob_controller/passive/scooped_by(mob/living/initiator)
	if(is_friend(initiator))
		return TRUE
	if(is_enemy(initiator) || (scooping_skill && initiator.skill_fail_prob(scooping_skill, 50, scooping_skill_req))) // scary, try to wriggle away
		retaliate(initiator) // run! run like the wind!
		if(!initiator.skill_fail_prob(SKILL_HAULING, 100, SKILL_EXPERT))
			to_chat(initiator, SPAN_WARNING("\The [body] tries to wriggle out of your grasp, but you hold on tight!"))
			return TRUE
		to_chat(initiator, SPAN_WARNING("\The [body] wriggles out of your grasp!"))
		initiator.drop_from_inventory(body)
		return FALSE
	return TRUE