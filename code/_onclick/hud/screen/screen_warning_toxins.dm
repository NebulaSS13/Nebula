/obj/screen/warning/toxin
	name        = "toxin"
	icon        = 'icons/mob/screen/styles/status_tox.dmi'
	icon_state  = "tox0"
	screen_loc  = ui_temp
	base_state  = "tox"
	check_alert = /decl/hud_element/toxins

/obj/screen/warning/toxin/handle_click(mob/user, params)
	if(icon_state == "tox0")
		to_chat(user, SPAN_NOTICE("The air is clear of toxins."))
	else
		to_chat(user, SPAN_DANGER("The air is eating away at your skin!"))
