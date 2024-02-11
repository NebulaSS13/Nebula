/obj/screen/robot_drop_grab
	name = "drop grab"
	icon = 'icons/mob/screen/styles/robot/drop_grab.dmi'
	icon_state = "drop_grab"
	screen_loc = ui_borg_drop_grab
	invisibility = INVISIBILITY_MAXIMUM
	alpha = 0
	requires_ui_style = FALSE

/obj/screen/robot_drop_grab/handle_click(mob/user, params)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		R.drop_item()
		set_invisibility(INVISIBILITY_MAXIMUM)
		alpha = 0
