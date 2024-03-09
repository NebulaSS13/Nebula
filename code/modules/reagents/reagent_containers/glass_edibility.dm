/obj/item/chems/glass/handle_eaten_by_mob(var/mob/user, var/mob/target)
	if(!ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, SPAN_WARNING("You need to open \the [src] first."))
		return EATEN_UNABLE
	if(user.a_intent == I_HURT)
		return EATEN_INVALID
	return ..()
