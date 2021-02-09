
/obj/item/firearm_component/barrel/ballistic/revolver
	caliber = CALIBER_PISTOL_MAGNUM
	one_hand_penalty = 2
	bulk = 3

/obj/item/firearm_component/barrel/ballistic/revolver/capgun
	caliber = CALIBER_CAPS
	var/cap = TRUE
/*
/obj/item/gun/revolver/capgun/attackby(obj/item/wirecutters/W, mob/user)
	if(!istype(W) || !cap)
		return ..()
	to_chat(user, "<span class='notice'>You snip off the toy markings off the [holder || src].</span>")
	name = "revolver"
	desc += " Someone snipped off the barrel's toy mark. How dastardly."
	cap = FALSE
	update_icon()
	return 1
*/

/obj/item/firearm_component/barrel/ballistic/revolver/capgun/get_holder_overlay(holder_state)
	var/image/ret = ..()
	if(ret && cap)
		ret.overlays += "[holder_state]-cap"
	return ret
