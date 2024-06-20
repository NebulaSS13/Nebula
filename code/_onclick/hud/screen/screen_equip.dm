/obj/screen/equip
	name       = "equip"
	icon_state = "act_equip"

/obj/screen/equip/handle_click(mob/user, params)
	if(ishuman(usr))
		var/mob/living/human/H = usr
		H.quick_equip()
