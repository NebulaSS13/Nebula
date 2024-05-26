/obj/screen/robot_inventory
	name              = "inventory"
	icon              = 'icons/mob/screen/styles/robot/panel.dmi'
	icon_state        = "inventory"
	screen_loc        = ui_borg_inventory
	requires_ui_style = FALSE

/obj/screen/robot_inventory/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.module)
			R.hud_used.toggle_show_robot_modules()
			return 1
		to_chat(R, "You haven't selected a module yet.")
