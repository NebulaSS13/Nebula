/obj/screen/proc/handle_click(mob/user, params)
	return

/obj/screen/Click(location, control, params)
	if(ismob(usr) && usr.client && usr.canClick() && !usr.incapacitated())
		return handle_click(usr, params)
	return FALSE