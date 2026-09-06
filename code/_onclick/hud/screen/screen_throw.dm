/obj/screen/throw_toggle
	name = "throw"
	icon_state = "act_throw_off"
	screen_loc = ui_drop_throw
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE

/obj/screen/throw_toggle/handle_click(mob/user, params)
	if(!user.stat && isturf(user.loc) && !user.restrained())
		user.toggle_throw_mode()

/obj/screen/throw_toggle/on_update_icon()
	var/mob/living/owner = owner_ref?.resolve()
	if(istype(owner))
		icon_state = "act_throw_[owner.in_throw_mode ? "on" : "off"]"
	. = ..()
