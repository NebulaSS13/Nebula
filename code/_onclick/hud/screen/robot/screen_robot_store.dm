/obj/screen/robot/store
	name       = "store"
	icon_state = "store"
	screen_loc = ui_borg_store

/obj/screen/robot/store/handle_click(mob/user, params)
	var/mob/living/silicon/robot/robot = user
	if(istype(robot) && robot.module)
		var/obj/item/active_item = robot.get_active_held_item()
		if(active_item)
			user.try_unequip(active_item, robot.module, FALSE)
	else
		to_chat(robot, "You haven't selected a module yet.")
