/mob/living/silicon/robot
	hud_used = /datum/hud/robot

/datum/hud/robot/get_ui_style_data()
	return GET_DECL(/decl/ui_style/robot)

/datum/hud/robot/get_ui_color()
	return COLOR_WHITE

/datum/hud/robot/get_ui_alpha()
	return 255
