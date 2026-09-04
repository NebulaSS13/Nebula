/decl/status_condition/weakened
	name = "weakened"
	check_flags = CANWEAKEN
	status_marker_state = "weakened"

/decl/status_condition/weakened/handle_changed_amount(var/mob/living/victim, var/new_amount, var/last_amount)
	. = ..()
	victim.facing_dir = null
	if(victim.aiming)
		victim.stop_aiming(no_message=1)
	victim.update_posture()

/decl/status_condition/weakened/handle_status(mob/living/victim, amount)
	. = ..()
	if(victim.aiming)
		victim.stop_aiming(no_message=1)
	victim.update_posture()
