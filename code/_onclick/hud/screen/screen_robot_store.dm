/obj/screen/robot_store
	name       = "store"
	icon       = 'icons/mob/screen/styles/robot/panel.dmi'
	icon_state = "store"
	screen_loc = ui_borg_store
	requires_ui_style = FALSE

/obj/screen/robot_store/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.module)
			R.uneq_active()
			R.hud_used.update_robot_modules_display()
		else
			to_chat(R, "You haven't selected a module yet.")
