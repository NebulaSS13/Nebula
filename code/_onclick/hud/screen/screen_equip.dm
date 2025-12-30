/obj/screen/equip
	name       = "equip"
	icon_state = "act_equip"
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE

/obj/screen/equip/handle_click(mob/user, params)
	if(ishuman(user))
		var/mob/living/human/H = user
		H.quick_equip()
