/obj/screen/robot_storage
	name       = "store hardpoint"
	icon       = 'icons/mob/screen/robot_panel.dmi'
	icon_state = "store"
	screen_loc = ui_borg_storage

/obj/screen/robot_storage/handle_click(mob/user, params)
	var/obj/item/equipped = user?.get_active_hand()
	if(equipped)
		var/mob/living/silicon/robot/R = user
		if(istype(R) && (equipped in R.module.equipment))
			user.try_unequip(equipped, R.module, FALSE)
		else
			user.try_unequip(equipped, null, FALSE)
		return TRUE
	return ..()
