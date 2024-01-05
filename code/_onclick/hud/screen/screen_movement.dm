/obj/screen/movement
	name       = "movement method"
	screen_loc = ui_movi

/obj/screen/movement/handle_click(mob/user, params)
	if(istype(user))
		user.set_next_usable_move_intent()
