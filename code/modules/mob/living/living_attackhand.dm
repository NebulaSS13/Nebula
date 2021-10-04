/mob/living/attack_hand(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(!.)
		. = ..()
		if(!. && user)
			switch(user.a_intent)
				if(I_HURT)
					. = default_hurt_interaction(user)
				if(I_HELP)
					. = default_help_interaction(user)
				if(I_DISARM)
					. = default_disarm_interaction(user)
				if(I_GRAB)
					. = default_grab_interaction(user)
			if(!.)
				. = default_interaction(user)

/mob/living/proc/default_interaction(var/mob/user)

	SHOULD_CALL_PARENT(TRUE)

	var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
	if(hattable && hattable.hat)
		hattable.hat.forceMove(get_turf(src))
		user.put_in_hands(hattable.hat)
		user.visible_message(SPAN_DANGER("\The [user] removes \the [src]'s [hattable.hat]!"))
		hattable.hat = null
		update_icon()
		return TRUE

	if(ishuman(user))
		var/mob/living/carbon/H = user
		if(H.a_intent == I_GRAB)
			get_scooped(user, FALSE)
			return TRUE

	return FALSE

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
	if(isliving(user) && CanPhysicallyInteract(user) && !user.lying)
		return try_make_grab(user)
	return FALSE
