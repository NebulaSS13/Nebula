/obj/item/clothing/gloves/setup_equip_flags()
	. = ..()
	if(!isnull(bodytype_equip_flags) && !(bodytype_equip_flags & BODY_FLAG_EXCLUDE))
		bodytype_equip_flags |= BODY_FLAG_HNOLL