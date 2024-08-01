/obj/item/food/can/handle_eaten_by_mob(mob/user, mob/target)
	if(!ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, SPAN_NOTICE("You need to open \the [src] first!"))
		return EATEN_UNABLE
	return ..()
