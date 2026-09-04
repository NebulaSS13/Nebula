/obj/screen/robot/radio
	name       = "radio"
	dir        = SOUTHWEST
	icon_state = "radio"
	screen_loc = ui_movi

/obj/screen/robot/radio/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/robot = user
		robot.radio_menu()