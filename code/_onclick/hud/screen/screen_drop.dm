/obj/screen/drop
	name       = "drop"
	icon_state = "act_drop"
	screen_loc = ui_drop_throw

/obj/screen/drop/handle_click(mob/user, params)
	if(user.client)
		user.client.drop_item()
