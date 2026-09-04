/obj/screen/gun
	icon = 'icons/mob/screen/styles/midnight/fire_intent.dmi'
	dir = SOUTH
	abstract_type = /obj/screen/gun
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE
	var/base_icon_state
	var/toggle_flag

/obj/screen/gun/on_update_icon()
	if(toggle_flag && base_icon_state)
		var/mob/living/owner = owner_ref?.resolve()
		icon_state = "[base_icon_state][!!(istype(owner) && owner.aiming && (owner.aiming.target_permissions & toggle_flag))]"
	..()

/obj/screen/gun/handle_click(mob/user, params)
	if(isliving(user))
		var/mob/living/shooter = user
		if(!shooter.aiming)
			shooter.aiming = new(user)
		if(toggle_flag)
			shooter.aiming.toggle_permission(toggle_flag)
		return TRUE
	return FALSE

/obj/screen/gun/move
	name = "Allow Movement"
	icon_state = "no_walk1"
	base_icon_state = "no_walk"
	screen_loc = ui_gun2
	toggle_flag = TARGET_CAN_MOVE

/obj/screen/gun/item
	name = "Allow Item Use"
	icon_state = "no_item1"
	base_icon_state = "no_item"
	screen_loc = ui_gun1
	toggle_flag = TARGET_CAN_CLICK

/obj/screen/gun/radio
	name = "Disallow Radio Use"
	icon_state = "no_radio1"
	base_icon_state = "no_radio"
	screen_loc = ui_gun3
	toggle_flag = TARGET_CAN_RADIO

/obj/screen/gun/mode
	name = "Toggle Gun Mode"
	icon_state = "gun0"
	base_icon_state = "gun"
	screen_loc = ui_gun_select

/obj/screen/gun/mode/on_update_icon()
	var/mob/living/owner = owner_ref?.resolve()
	icon_state = "[base_icon_state][!!(istype(owner) && owner.aiming?.active)]"
	..()

/obj/screen/gun/mode/handle_click(mob/user, params)
	if(..())
		var/mob/living/shooter = user
		shooter.aiming.toggle_active()
		return TRUE
	return FALSE
