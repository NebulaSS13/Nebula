/obj/item/handle_eaten_by_mob(var/mob/user, var/mob/target)
	. = ..()
	if(. == EATEN_SUCCESS && !QDELETED(src))
		add_trace_DNA(target)
