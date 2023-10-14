/obj/screen/up_hint
	name       = "up hint"
	icon_state = "uphint0"
	screen_loc = ui_up_hint

/obj/screen/up_hint/handle_click(mob/user, params)
	if(isliving(user))
		var/mob/living/L = user
		L.lookup()
