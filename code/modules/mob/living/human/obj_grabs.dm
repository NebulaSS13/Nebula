/obj/can_be_grabbed(var/mob/grabber, var/target_zone)
	. = ..()
	if(.)
		if(!grabber.can_pull_size)
			to_chat(grabber, SPAN_WARNING("\The [src] won't budge!"))
			return FALSE
		if(grabber.can_pull_size < w_class)
			to_chat(src, SPAN_WARNING("\The [src] is too large for you to move!"))
			return FALSE
