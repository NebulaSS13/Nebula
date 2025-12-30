/obj/screen/drop
	name       = "drop"
	icon_state = "act_drop"
	screen_loc = ui_drop_throw
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE

/obj/screen/drop/handle_click(mob/user, params)
	if(user.client)
		user.client.drop_item()
