/obj/item
	var/_kobaloi_onmob_icon
	var/_hnoll_onmob_icon

/obj/item/setup_sprite_sheets()
	. = ..()
	if(_kobaloi_onmob_icon)
		LAZYSET(sprite_sheets, BODYTYPE_KOBALOI, _kobaloi_onmob_icon)
	if(_hnoll_onmob_icon)
		LAZYSET(sprite_sheets, BODYTYPE_HNOLL, _hnoll_onmob_icon)

/obj/item/clothing/gloves/setup_equip_flags()
	. = ..()
	if(!isnull(bodytype_equip_flags) && !(bodytype_equip_flags & BODY_EQUIP_FLAG_EXCLUDE))
		bodytype_equip_flags |= BODY_EQUIP_FLAG_HNOLL