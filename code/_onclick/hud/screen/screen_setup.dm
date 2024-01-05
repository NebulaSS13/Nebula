// Character setup stuff
/obj/screen/setup_preview
	plane = DEFAULT_PLANE
	layer = MOB_LAYER
	requires_owner = FALSE
	var/datum/preferences/pref

/obj/screen/setup_preview/Destroy()
	pref = null
	return ..()

// Background 'floor'
/obj/screen/setup_preview/bg
	layer = TURF_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

/obj/screen/setup_preview/bg/handle_click(mob/user, params)
	if(pref)
		pref.bgstate = next_in_list(pref.bgstate, pref.bgstate_options)
		pref.update_preview_icon()
