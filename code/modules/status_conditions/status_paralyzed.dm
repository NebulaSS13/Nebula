/decl/status_condition/paralyzed
	name = "paralyzed"

/decl/status_condition/paralyzed/check_can_set(mob/living/victim)
	. = !(MUTATION_HULK in victim.mutations) && ..()
