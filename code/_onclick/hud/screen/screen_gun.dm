/obj/screen/gun
	icon = 'icons/mob/screen/styles/midnight/fire_intent.dmi'
	dir = SOUTH
	abstract_type = /obj/screen/gun
	var/toggle_flag

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
	screen_loc = ui_gun2
	toggle_flag = TARGET_CAN_MOVE

/obj/screen/gun/item
	name = "Allow Item Use"
	icon_state = "no_item1"
	screen_loc = ui_gun1
	toggle_flag = TARGET_CAN_CLICK

/obj/screen/gun/radio
	name = "Disallow Radio Use"
	icon_state = "no_radio1"
	screen_loc = ui_gun4
	toggle_flag = TARGET_CAN_RADIO

/obj/screen/gun/mode
	name = "Toggle Gun Mode"
	icon_state = "gun0"
	screen_loc = ui_gun_select

/obj/screen/gun/mode/handle_click(mob/user, params)
	if(..())
		var/mob/living/shooter = user
		shooter.aiming.toggle_active()
		return TRUE
	return FALSE
