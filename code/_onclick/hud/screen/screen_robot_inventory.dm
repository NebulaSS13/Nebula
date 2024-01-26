/obj/screen/robot_inventory
	name       = "inventory"
	icon       = 'icons/mob/screen/robot_panel.dmi'
	icon_state = "inventory"
	screen_loc = ui_borg_inventory

/obj/screen/robot_inventory/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.module)
			R.hud_used?.toggle_show_robot_modules()
		else
			to_chat(R, SPAN_WARNING("You haven't selected a module yet."))
		return TRUE
	return ..()
