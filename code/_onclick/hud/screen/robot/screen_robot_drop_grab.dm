/obj/screen/robot/drop_grab
	name = "drop grab"
	icon = 'icons/mob/screen/styles/robot/drop_grab.dmi'
	icon_state = "drop_grab"
	screen_loc = ui_borg_drop_grab
	invisibility = INVISIBILITY_MAXIMUM
	alpha = 0

/obj/screen/robot/drop_grab/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/robot = user
		robot.drop_item()
		update_icon()

/obj/screen/robot/drop_grab/on_update_icon()
	. = ..()
	var/mob/living/owner = owner_ref?.resolve()
	if(istype(owner) && length(owner.get_active_grabs()))
		set_invisibility(INVISIBILITY_NONE)
		alpha = 255
	else
		set_invisibility(INVISIBILITY_ABSTRACT)
		alpha = 0
