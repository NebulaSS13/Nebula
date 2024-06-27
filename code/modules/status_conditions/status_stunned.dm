/decl/status_condition/stunned
	name = "stunned"
	check_flags = CANSTUN
	status_marker_state = "stunned"

/decl/status_condition/stunned/check_can_set(var/mob/living/victim)
	. = ..() && !victim.can_feel_pain()

/decl/status_condition/stunned/handle_changed_amount(var/mob/living/victim, var/new_amount, var/last_amount)
	. = ..()
	victim.facing_dir = null
	victim.update_posture()

/decl/status_condition/stunned/handle_status(mob/living/victim, amount)
	. = ..()
	victim.update_posture()
