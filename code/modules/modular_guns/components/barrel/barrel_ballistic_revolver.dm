/obj/item/firearm_component/barrel/ballistic/revolver
	caliber = CALIBER_PISTOL_MAGNUM
	one_hand_penalty = 2
	bulk = 3
	accuracy = 2
	accuracy_power = 8

/obj/item/firearm_component/barrel/ballistic/revolver/capgun
	caliber = CALIBER_CAPS
	var/cap = TRUE

/obj/item/firearm_component/barrel/ballistic/revolver/capgun/holder_attackby(obj/item/W, mob/user)
	if(isWirecutter(W) && cap)
		cap = FALSE
		to_chat(user, SPAN_NOTICE("You snip the toy markings off \the [holder || src]."))
		update_icon()
		return TRUE
	. = ..()
	
/obj/item/firearm_component/barrel/ballistic/revolver/capgun/get_holder_overlay(holder_state)
	var/image/ret = ..()
	if(ret && cap)
		ret.overlays += "[holder_state]-cap"
	return ret
