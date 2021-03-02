/decl/status_condition/weakened
	name = "weakened"
	check_flags = CANWEAKEN

/decl/status_condition/weakened/handle_changed_amount(var/mob/living/victim, var/new_amount, var/last_amount)
	. = ..()
	victim.facing_dir = null

/decl/status_condition/weakened/handle_status(mob/living/victim, amount)
	. = ..()
	if(victim.aiming)
		victim.stop_aiming(no_message=1)
	victim.UpdateLyingBuckledAndVerbStatus()

/decl/status_condition/weakened/check_can_set(mob/living/victim)
	. = !(MUTATION_HULK in victim.mutations) && ..()
