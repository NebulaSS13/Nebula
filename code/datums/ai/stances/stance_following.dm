/decl/mob_controller_stance/following
	name = "following a friend"

/decl/mob_controller_stance/following/check_movement_constraints(mob/living/body, datum/mob_controller/controller)
	if((. = ..()))
		return