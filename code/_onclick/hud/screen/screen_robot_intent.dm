/obj/screen/intent/robot
	name       = "act_intent"
	dir        = SOUTHWEST
	icon       = 'icons/mob/screen1_robot.dmi'
	screen_loc = ui_acti

/obj/screen/intent/robot/handle_click(mob/user, params)
	user.a_intent_change("right")
