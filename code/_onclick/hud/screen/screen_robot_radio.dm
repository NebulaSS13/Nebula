/obj/screen/robot_radio
	name       = "radio"
	dir        = SOUTHWEST
	icon       = 'icons/mob/screen1_robot.dmi'
	icon_state = "radio"
	screen_loc = ui_movi

/obj/screen/robot_radio/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		R.radio_menu()