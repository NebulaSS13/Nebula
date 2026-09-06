/obj/screen/robot/module
	name              = "module"
	icon              = 'icons/mob/screen/styles/robot/module.dmi'
	icon_state        = "nomod"
	screen_loc        = ui_borg_module

/obj/screen/robot/module/on_update_icon()
	. = ..()
	icon_state = initial(icon_state)
	var/mob/living/silicon/robot/owner = owner_ref?.resolve()
	if(istype(owner) && owner.modtype)
		icon_state = lowertext(owner.modtype)

/obj/screen/robot/module/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/robot = user
		robot.pick_module()
