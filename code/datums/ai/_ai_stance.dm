// Stub type for future expansion/logic encapsulation.
/decl/mob_controller_stance
	abstract_type = /decl/mob_controller_stance
/decl/mob_controller_stance/none
/decl/mob_controller_stance/idle
/decl/mob_controller_stance/alert
/decl/mob_controller_stance/attack
/decl/mob_controller_stance/attacking
/decl/mob_controller_stance/tired
/decl/mob_controller_stance/contained
/decl/mob_controller_stance/commanded
	abstract_type = /decl/mob_controller_stance/commanded
/decl/mob_controller_stance/commanded/stop
/decl/mob_controller_stance/commanded/follow
/decl/mob_controller_stance/commanded/misc
/decl/mob_controller_stance/commanded/heal
/decl/mob_controller_stance/commanded/healing
/decl/mob_controller_stance/busy

/datum/mob_controller/proc/get_activity()
	return current_activity

/datum/mob_controller/proc/set_activity(new_activity)
	if(current_activity != new_activity)
		current_activity = new_activity
		return TRUE
	return FALSE

/datum/mob_controller/proc/set_stance(new_stance)
	if(stance != new_stance)
		stance = new_stance
		return TRUE
	return FALSE

/datum/mob_controller/proc/get_stance()
	return stance

/datum/mob_controller/proc/startle()
	if(QDELETED(body) || body.stat != UNCONSCIOUS)
		return
	body.set_stat(CONSCIOUS)
	if(body.current_posture?.prone)
		body.set_posture(/decl/posture/standing)
