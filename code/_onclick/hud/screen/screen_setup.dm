// Character setup stuff
/obj/screen/setup_preview
	icon = 'icons/effects/32x32.dmi'
	plane = DEFAULT_PLANE
	layer = MOB_LAYER
	requires_owner = FALSE
	requires_ui_style = FALSE
	var/datum/preferences/pref

/obj/screen/setup_preview/Destroy()
	pref = null
	return ..()

// Background 'floor'
/obj/screen/setup_preview/bg
	layer = TURF_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

// Uses Click() instead of handle_click() due to being accessed by new_player mobs.
/obj/screen/setup_preview/bg/Click(location, control, params)
	if(pref)
		pref.bgstate = next_in_list(pref.bgstate, pref.bgstate_options)
		var/mob/living/human/dummy/mannequin/mannequin = get_mannequin(pref.client_ckey)
		if(mannequin)
			pref.update_character_previews(mannequin)
	return ..()
