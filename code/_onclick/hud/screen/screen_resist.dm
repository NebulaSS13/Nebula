/obj/screen/resist
	name       = "resist"
	icon_state = "act_resist"
	screen_loc = ui_pull_resist

/obj/screen/resist/handle_click(mob/user, params)
	if(isliving(user))
		var/mob/living/L = user
		L.resist()
