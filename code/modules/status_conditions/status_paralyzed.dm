/decl/status_condition/paralyzed
	name = "paralyzed"
	status_marker_state = "paralyzed"

/decl/status_condition/paralyzed/check_can_set(mob/living/victim)
	. = !(MUTATION_HULK in victim.mutations) && ..()
