/obj/screen/toggle
	name = "toggle"
	icon_state = "other"
	screen_loc = ui_inventory

/obj/screen/toggle/handle_click(mob/user, params)
	if(!user.hud_used)
		return
	if(user.hud_used.inventory_shown)
		user.client.screen -= user.hud_used.other
		user.hud_used.hide_inventory()
	else
		user.client.screen += user.hud_used.other
		user.hud_used.show_inventory()
	return TRUE
