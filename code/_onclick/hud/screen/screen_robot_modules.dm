/obj/screen/robot_modules_background
	name              = "module"
	icon_state        = "block"
	icon              = 'icons/mob/screen/styles/robot/modules_background.dmi'
	requires_ui_style = FALSE

/obj/screen/robot_module
	dir               = SOUTHWEST
	requires_ui_style = FALSE
	icon              = 'icons/mob/screen/styles/robot/inventory.dmi'
	var/module_index

/obj/screen/robot_module/handle_click(mob/user, params)
	if(isrobot(user) && !isnull(module_index))
		var/mob/living/silicon/robot/robot = user
		robot.toggle_module(module_index)
		return TRUE
	return ..()

/obj/screen/robot_module/one
	name         = "module1"
	icon_state   = "inv1"
	screen_loc   = ui_inv1
	module_index = 1

/obj/screen/robot_module/two
	name         = "module2"
	icon_state   = "inv2"
	screen_loc   = ui_inv2
	module_index = 2

/obj/screen/robot_module/three
	name         = "module3"
	icon_state   = "inv3"
	screen_loc   = ui_inv3
	module_index = 3
