/obj/screen/robot_panel
	name       = "panel"
	icon       = 'icons/mob/screen/styles/robot/panel.dmi'
	icon_state = "panel"
	screen_loc = ui_borg_panel
	requires_ui_style = FALSE

/obj/screen/robot_panel/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		R.installed_modules()
