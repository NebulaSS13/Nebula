/atom/movable/proc/can_be_grabbed(var/mob/grabber, var/target_zone)
	if(!istype(grabber) || !isturf(loc) || !isturf(grabber.loc))
		return FALSE
	if(!CanPhysicallyInteract(grabber))
		return FALSE
	if(!buckled_grab_check(grabber))
		return FALSE
	if(anchored)
		to_chat(grabber, SPAN_WARNING("\The [src] won't budge!"))
		return FALSE
	return TRUE

/atom/movable/proc/buckled_grab_check(var/mob/grabber)
	if(grabber.buckled == src && buckled_mob == grabber)
		return TRUE
	if(grabber.anchored)
		return FALSE
	if(grabber.buckled)
		return FALSE
	return TRUE

/atom/movable/handle_grab_interaction(var/mob/user)

	// Anchored check so we can operate switches etc on grab intent without getting grab failure msgs.
	// NOTE: /mob/living overrides this to return FALSE in favour of using default_grab_interaction
	if(isliving(user) && user.a_intent == I_GRAB && !user.current_posture.prone && !anchored)
		return try_make_grab(user)
	return ..()

/atom/movable/proc/try_make_grab(mob/living/user, defer_hand = FALSE)
	if(istype(user) && CanPhysicallyInteract(user) && !user.current_posture.prone)
		if(user == buckled_mob)
			return give_control_grab(buckled_mob)
		return user.make_grab(src, defer_hand = defer_hand)
	return null

/atom/movable/proc/give_control_grab(var/mob/M)
	return
