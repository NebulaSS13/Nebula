/obj/screen/robot/modules_background
	name              = "module"
	icon_state        = "block"
	icon              = 'icons/mob/screen/styles/robot/modules_background.dmi'

/obj/screen/robot/module
	dir               = SOUTHWEST
	icon              = 'icons/mob/screen/styles/robot/modules_inventory.dmi'
	var/module_index

/obj/screen/robot/module/handle_click(mob/user, params)
	if(isrobot(user) && !isnull(module_index))
		var/mob/living/silicon/robot/robot = user
		robot.toggle_module(module_index)
		return TRUE
	return ..()

/obj/screen/robot/module/one
	name         = "module1"
	icon_state   = "inv1"
	screen_loc   = ui_inv1
	module_index = 1

/obj/screen/robot/module/two
	name         = "module2"
	icon_state   = "inv2"
	screen_loc   = ui_inv2
	module_index = 2

/obj/screen/robot/module/three
	name         = "module3"
	icon_state   = "inv3"
	screen_loc   = ui_inv3
	module_index = 3
