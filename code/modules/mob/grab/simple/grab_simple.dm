/obj/item/grab/simple
	type_name = GRAB_SIMPLE
	start_grab_name = SIMPLE_PASSIVE

/obj/item/grab/simple/Initialize()
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		visible_message(SPAN_DANGER("\The [assailant] has grabbed \the [affecting]!"))
