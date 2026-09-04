/obj/screen/resist
	name       = "resist"
	icon_state = "act_resist"
	screen_loc = ui_pull_resist
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE

/obj/screen/resist/handle_click(mob/user, params)
	if(isliving(user))
		var/mob/living/L = user
		L.resist()
