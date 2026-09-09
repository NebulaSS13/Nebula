/*
	idle       -> flagged aggressive, found a target, flagged alerts     -> alert
	idle       -> flagged aggressive, found a target, not flagged alerts -> attacking
	alert      -> incapacitated                                          -> idle
	alert      -> target is within minimum distance                      -> attacking
	alert      -> alert time has elapsed has target                      -> attacking
	tired      -> tired time elapsed, still has a target                 -> attacking
	tired      -> tired time elapsed, lost target                        -> idle
	attacking  -> no target/lost target, flagged alerts                  -> alert
	attacking  -> no target/lost target, not flagged alerts              -> idle
	attacking  -> flagged tires, been in stance for 20 seconds           -> tired
	any stance -> health below %, flagged as coward                      -> fleeing
	any stance -> attacked, flagged aggressive                           -> attacking
	any stance -> attacked, flagged coward                               -> fleeing
	fleeing    -> target is no longer in sight                           -> idle
*/

/decl/mob_controller_stance
	var/name
	var/stance_can_flee = TRUE
	abstract_type = /decl/mob_controller_stance

/decl/mob_controller_stance/proc/check_movement_constraints(mob/living/body, datum/mob_controller/controller)
	if(!isnull(controller.home) && get_dist(body, controller.home) > controller.home_wander_distance)
		body.start_automove(controller.home)
		return TRUE
	return FALSE

/decl/mob_controller_stance/proc/suspend_activity(mob/living/body, datum/mob_controller/controller)
	return

/decl/mob_controller_stance/proc/resume_activity(mob/living/body, datum/mob_controller/controller)
	return

/decl/mob_controller_stance/proc/on_body_life(mob/living/body, datum/mob_controller/controller)

	if(QDELETED(body) || QDELETED(controller) || body.stat)
		return FALSE
	if(check_movement_constraints(body, controller))
		return FALSE

	controller.try_unbuckle()
	if(!body.buckled && (controller.ai_flags & AI_FLAG_AMBUSHER) && body.can_cloak() && !body.is_cloaked())
		body.apply_cloak()

	if(stance_can_flee && (controller.ai_flags & AI_FLAG_COWARD) && body.get_health_percent() < controller.flee_threshold)
		controller.set_flee_target(get_turf(body))
		controller.set_stance(/decl/mob_controller_stance/fleeing)
		return FALSE

	return TRUE

/decl/mob_controller_stance/proc/on_stance_set(mob/living/body, datum/mob_controller/controller)
	body?.stop_automove()
	controller?.stop_wandering()

/decl/mob_controller_stance/proc/on_stance_unset(mob/living/body, datum/mob_controller/controller)
	return