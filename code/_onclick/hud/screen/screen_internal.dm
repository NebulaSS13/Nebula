/obj/screen/internals
	name       = "internal"
	icon_state = "internal0"
	screen_loc = ui_internal

/obj/screen/internals/on_update_icon()
	. = ..()
	var/mob/living/owner = owner_ref?.resolve()
	if(istype(owner) && owner.get_internals())
		icon_state = "internal1"
	else
		icon_state = "internal0"

/obj/screen/internals/handle_click(mob/user, params)
	if(isliving(user))
		var/mob/living/M = user
		M.ui_toggle_internals()
