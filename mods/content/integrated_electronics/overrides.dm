// Allows the detailer to be used to set data cards' detail color, in addition to the paint sprayer.
/obj/item/card/data/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/detailer))
		var/obj/item/detailer/D = used_item
		detail_color = D.detail_color
		update_icon()
		return TRUE
	return ..()

// Gives the research borg a hand tele.
/obj/item/robot_module/research
	emag = /obj/abstract/prefab/hand_teleporter