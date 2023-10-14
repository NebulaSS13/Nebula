/obj/screen/robot_intent
	name       = "act_intent"
	dir        = SOUTHWEST
	icon       = 'icons/mob/screen1_robot.dmi'
	screen_loc = ui_acti

/obj/screen/robot_intent/handle_click(mob/user, params)
	user.a_intent_change("right")
