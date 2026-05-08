/obj/item/clothing/suit
	var/obj/item/clothing/head/hood

/obj/item/clothing/suit/Initialize()
	if(ispath(hood))
		hood = new hood(src)
		hood.paint_color = paint_color
		hood.markings_color = markings_color
		if(isnull(hood.markings_state_modifier))
			hood.markings_state_modifier = markings_state_modifier
		hood.update_icon()
	return ..()

/obj/item/clothing/suit/set_color(new_color)
	. = ..()
	if(. && istype(hood))
		hood.set_color(new_color)

/obj/item/clothing/suit/set_markings_color(new_color)
	. = ..()
	if(istype(hood))
		hood.set_markings_color(new_color)

/obj/item/clothing/suit/Destroy()
	if(istype(hood))
		QDEL_NULL(hood)
	return ..()

/obj/item/clothing/suit/get_contained_external_atoms()
	. = ..()
	if(hood && .)
		LAZYREMOVE(., hood)

/obj/item/clothing/suit/get_hood()
	if(istype(hood))
		return hood
	return ..()

/obj/item/clothing/suit/set_material(new_material)
	. = ..()
	if(. && istype(hood))
		hood.set_material(new_material)

// i don't think this needs to be a get_stored_inventory override instead since it should never be separated currently
// but that may change in the future
/obj/item/clothing/suit/get_contained_external_atoms()
	. = ..()
	if(length(.) && istype(hood)) // this is considered a component rather than a contained item
		. -= hood

/obj/item/clothing/suit/Initialize()
	if(ispath(hood))
		hood = new hood(src, material)
		if(paint_color)
			hood.set_color(paint_color)
	return ..()

/obj/item/clothing/suit/Destroy()
	if(istype(hood))
		QDEL_NULL(hood)
	return ..()

/obj/item/clothing/suit/equipped(mob/user, slot)
	if(slot != slot_wear_suit_str)
		remove_hood()
	. = ..()