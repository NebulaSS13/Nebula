// Omit the base gun_mode because it doesn't care about specific gun use flags
var/global/list/gun_hud_flag_decl_types = list(
	/decl/hud_element/gun_flag_move,
	/decl/hud_element/gun_flag_item,
	/decl/hud_element/gun_flag_radio
)

/// Root type for flag toggling in gun mode.
/obj/screen/gun_flag
	name = "gun"
	master = null
	dir = SOUTH

	var/option_name
	var/option_state
	var/option_flag

/obj/screen/gun_flag/proc/update_from_aiming_overlay(var/obj/aiming_overlay/aiming_overlay)
	if(!aiming_overlay || !option_flag || !option_name || !option_state)
		return
	if(aiming_overlay.target_permissions & option_flag)
		icon_state = "[option_state]1"
		SetName("Disallow [option_name]]")
	else
		icon_state = "[option_state]0"
		SetName("Allow [option_name]")

/obj/screen/gun_flag/Click(location, control, params)
	if(isliving(usr) && option_flag && option_name && option_state)
		var/mob/living/user = usr
		if(!user.aiming)
			user.aiming = new(user)
		user.aiming.toggle_permission(option_flag)
		return TRUE
	return FALSE

/// Root gun mode type - toggles aiming mode off or on when ticked.
/obj/screen/gun_mode
	name = "Toggle Gun Mode"
	icon_state = "gun0"
	screen_loc = ui_gun_select
	master = null
	dir = SOUTH

/decl/hud_element/gun_mode
	screen_object_type = /obj/screen/gun_mode
	hud_element_category = /decl/hud_element/gun_mode

/// Element for dis/allowing gun mode target clicking.
/obj/screen/gun_flag/item
	name = "Allow Item Use"
	icon_state = "no_item1"
	screen_loc = ui_gun1
	option_name = "Item Use"
	option_state = "no_item"
	option_flag = TARGET_CAN_CLICK

/decl/hud_element/gun_flag_item
	screen_object_type = /obj/screen/gun_flag/item
	hud_element_category = /decl/hud_element/gun_flag_item

/decl/hud_element/gun_flag_item/register_screen_object(obj/screen/elem, datum/hud/hud)
	return

/// Element for dis/allowing gun mode target movement.
/obj/screen/gun_flag/move
	name = "Allow Movement"
	icon_state = "no_walk1"
	screen_loc = ui_gun2
	option_name = "Movement"
	option_state = "no_walk"
	option_flag = TARGET_CAN_MOVE

/decl/hud_element/gun_flag_move
	screen_object_type = /obj/screen/gun_flag/move
	hud_element_category = /decl/hud_element/gun_flag_move

/decl/hud_element/gun_flag_move/register_screen_object(obj/screen/elem, datum/hud/hud)
	return

/// Element for dis/allowing gun mode target radio use.
/decl/hud_element/gun_flag_radio
	screen_object_type = /obj/screen/gun_flag/radio
	hud_element_category = /decl/hud_element/gun_flag_radio

/decl/hud_element/gun_flag_radio/register_screen_object(obj/screen/elem, datum/hud/hud)
	return

/obj/screen/gun_flag/radio
	name = "Disallow Radio Use"
	icon_state = "no_radio1"
	screen_loc = ui_gun4
	option_name = "Radio Use"
	option_state = "no_radio"
	option_flag = TARGET_CAN_RADIO
