/obj/screen/robot/inventory
	name              = "inventory"
	icon_state        = "inventory"
	screen_loc        = ui_borg_inventory

/obj/screen/robot/inventory/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/robot = user
		if(robot.module)
			robot.module.storage?.open(user)
		else
			to_chat(robot, "You haven't selected a module yet.")
