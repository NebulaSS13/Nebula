/obj/screen/movement
	name                  = "movement method"
	screen_loc            = ui_movi
	icon_state            = "creeping"
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE

/obj/screen/movement/handle_click(mob/user, params)
	if(istype(user))
		user.set_next_usable_move_intent()

/obj/screen/movement/on_update_icon()
	var/mob/living/owner = owner_ref?.resolve()
	if(istype(owner) && istype(owner.move_intent))
		icon_state = owner.move_intent.hud_icon_state
	. = ..()
