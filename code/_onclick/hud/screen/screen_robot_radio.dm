/obj/screen/robot_radio
	name       = "radio"
	dir        = SOUTHWEST
	icon       = 'icons/mob/screen/styles/robot/panel.dmi'
	icon_state = "radio"
	screen_loc = ui_movi
	requires_ui_style = FALSE

/obj/screen/robot_radio/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		R.radio_menu()