/atom/movable/proc/can_be_grabbed(var/mob/grabber, var/target_zone)
	if(!istype(grabber) || !isturf(loc) || !isturf(grabber.loc))
		return FALSE
	if(!CanPhysicallyInteract(grabber))
		return FALSE
	if(grabber.anchored || grabber.buckled)
		return FALSE
	if(anchored)
		to_chat(grabber, SPAN_WARNING("\The [src] won't budge!"))
		return FALSE
	return TRUE

/atom/movable/proc/reset_pixel_offsets_for_grab(var/obj/item/grab/G)
	reset_plane_and_layer()

/atom/movable/proc/adjust_pixel_offsets_for_grab(var/obj/item/grab/G, var/grab_dir)
	reset_plane_and_layer()

/atom/movable/proc/get_object_size()
	return ITEM_SIZE_NORMAL
