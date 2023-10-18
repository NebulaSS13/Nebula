/obj/screen/robot_modules_background
	icon_state = "block"

/obj/screen/robot_module_one
	name       = "module1"
	dir        = SOUTHWEST
	icon       = 'icons/mob/screen1_robot.dmi'
	icon_state = "inv1"
	screen_loc = ui_inv1

/obj/screen/robot_module_one/handle_click(mob/user, params)
	if(isrobot(usr))
		var/mob/living/silicon/robot/R = usr
		R.toggle_module(1)

/obj/screen/robot_module_two
	name       = "module2"
	dir        = SOUTHWEST
	icon       = 'icons/mob/screen1_robot.dmi'
	icon_state = "inv2"
	screen_loc = ui_inv2

/obj/screen/robot_module_two/handle_click(mob/user, params)
	if(isrobot(usr))
		var/mob/living/silicon/robot/R = usr
		R.toggle_module(2)

/obj/screen/robot_module_three
	name       = "module3"
	dir        = SOUTHWEST
	icon       = 'icons/mob/screen1_robot.dmi'
	icon_state = "inv3"
	screen_loc = ui_inv3

/obj/screen/robot_module_three/handle_click(mob/user, params)
	if(isrobot(usr))
		var/mob/living/silicon/robot/R = usr
		R.toggle_module(3)
