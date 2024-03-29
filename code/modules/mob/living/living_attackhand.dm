/mob/living/attack_hand(mob/user)
	// Allow grabbing a mob that you are buckled to, so that you can generate a control grab (for riding).
	if(buckled == user && user.a_intent == I_GRAB)
		return try_make_grab(user)
	return ..() || (user && default_interaction(user))

/mob/living/proc/default_interaction(var/mob/user)

	SHOULD_CALL_PARENT(TRUE)

	switch(user.a_intent)
		if(I_HURT)
			. = default_hurt_interaction(user)
		if(I_HELP)
			. = default_help_interaction(user)
		if(I_DISARM)
			. = default_disarm_interaction(user)
		if(I_GRAB)
			. = default_grab_interaction(user)

/mob/living/proc/default_hurt_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

/mob/living/proc/default_help_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

/mob/living/proc/default_disarm_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

/mob/living/proc/default_grab_interaction(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return (scoop_check(user) && get_scooped(user, user)) || try_make_grab(user)

// This proc is where movable atoms handle being grabbed, but we handle it additionally in
// default_grab_interaction, so we override it here to return FALSE and avoid double-grabbing.
/mob/living/handle_grab_interaction(var/mob/user)
	return FALSE
