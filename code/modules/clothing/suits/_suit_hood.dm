/obj/item/clothing/suit
	var/obj/item/clothing/head/hood

/obj/item/clothing/suit/get_hood()
	if(istype(hood))
		return hood
	return ..()

/obj/item/clothing/suit/set_material(new_material)
	. = ..()
	if(. && istype(hood))
		hood.set_material(new_material)

/obj/item/clothing/suit/set_color(new_color)
	. = ..()
	if(. && istype(hood))
		hood.set_color(new_color)

/obj/item/clothing/suit/Initialize()
	if(ispath(hood))
		hood = new hood(src)
	return ..()

/obj/item/clothing/suit/Destroy()
	if(istype(hood))
		QDEL_NULL(hood)
	return ..()

/obj/item/clothing/suit/equipped(mob/user, slot)
	if(slot != slot_wear_suit_str)
		remove_hood()
	. = ..()