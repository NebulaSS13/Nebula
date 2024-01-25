/obj/screen/robot_radio
	name       = "radio"
	dir        = SOUTHWEST
	icon       = 'icons/mob/screen/robot_panel.dmi'
	icon_state = "radio"
	screen_loc = ui_borg_radio

/obj/screen/robot_radio/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		R.radio_menu()
		return TRUE
	return ..()
