/datum/mob_controller
	/// Should we retaliate/startle when grabbed or buckled?
	var/spooked_by_grab = TRUE
	/// Last mob to attempt to handle this mob.
	var/weakref/last_handler

/// General-purpose scooping reaction proc, used by /passive.
/// Returns TRUE if the scoop should proceed, FALSE if it should be canceled.
/datum/mob_controller/proc/scooped_by(mob/initiator)
	if(body.stat != CONSCIOUS)
		return TRUE
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

/datum/mob_controller/proc/on_buckled(mob/scary_grabber)
	if(!scary_grabber || !(scary_grabber in body.get_buckled_mobs())) // the buckle got cancelled somehow?
		return
	if(spooked_by_grab && !is_friend(scary_grabber))
		retaliate(scary_grabber)

/datum/mob_controller/proc/on_grabbed(mob/scary_grabber)
	if(!scary_grabber)
		return
	if(spooked_by_grab && !is_friend(scary_grabber))
		retaliate(scary_grabber)

// General stubs for when another mob has directed this mob to attack.
/datum/mob_controller/proc/check_handler_can_order(mob/handler, atom/target, intent_flags)
	return is_friend(handler)

/datum/mob_controller/proc/process_handler_target(mob/handler, atom/target, intent_flags)
	if(!check_handler_can_order(handler, target, intent_flags))
		return process_handler_failure(handler, target)
	last_handler = weakref(handler)
	return TRUE

/datum/mob_controller/proc/process_handler_failure(mob/handler, atom/target)
	return FALSE

/datum/mob_controller/proc/process_holder_interaction(mob/handler)
	last_handler = weakref(handler)
	return body?.attack_hand_with_interaction_checks(handler)

// The mob will try to unbuckle itself from nets, beds, chairs, etc.
/datum/mob_controller/proc/try_unbuckle()
	if(body.buckled && (ai_flags & AI_FLAG_ESCAPE_BUCKLES))
		if(istype(body.buckled, /obj/effect/energy_net))
			var/obj/effect/energy_net/Net = body.buckled
			Net.escape_net(body)
		else if(prob(25))
			body.buckled.unbuckle_mob(body)
		else if(prob(25))
			body.visible_message(SPAN_WARNING("\The [body] struggles against \the [body.buckled]!"))
