/obj/screen/throw_toggle
	name = "throw"
	icon_state = "act_throw_off"
	screen_loc = ui_drop_throw

/obj/screen/throw_toggle/handle_click(mob/user, params)
	if(!user.stat && isturf(user.loc) && !user.restrained())
		user.toggle_throw_mode()
