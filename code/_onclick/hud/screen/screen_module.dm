/obj/screen/robot_module/select
	name              = "module"
	icon              = 'icons/mob/screen/styles/robot/module.dmi'
	icon_state        = "nomod"
	screen_loc        = ui_borg_module
	requires_ui_style = FALSE

/obj/screen/robot_module/select/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		R.pick_module()
