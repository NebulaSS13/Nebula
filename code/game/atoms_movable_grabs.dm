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

/atom/movable/proc/get_object_size()
	return ITEM_SIZE_NORMAL

/atom/movable/proc/buckled_grab_check(var/mob/grabber)
	if(grabber.buckled == src && buckled_mob == grabber)
		return TRUE
	if(grabber.anchored)
		return FALSE
	if(grabber.buckled)
		return FALSE
	return TRUE