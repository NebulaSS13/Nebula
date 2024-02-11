/obj/screen/intent/robot
	name       = "act_intent"
	dir        = SOUTHWEST
	screen_loc = ui_acti

/obj/screen/intent/robot/handle_click(mob/user, params)
	user.a_intent_change("right")
