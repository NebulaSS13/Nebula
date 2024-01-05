/obj/screen/internals
	name       = "internal"
	icon_state = "internal0"
	screen_loc = ui_internal

/obj/screen/internals/handle_click(mob/user, params)
	if(isliving(user))
		var/mob/living/M = user
		M.ui_toggle_internals()
