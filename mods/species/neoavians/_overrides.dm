/obj/item
	var/_avian_onmob_icon

/obj/item/setup_sprite_sheets()
	. = ..()
	if(_avian_onmob_icon)
		LAZYSET(sprite_sheets, BODYTYPE_AVIAN, _avian_onmob_icon)
