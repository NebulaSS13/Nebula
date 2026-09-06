/obj/item
	var/_alate_onmob_icon
	var/_gyne_onmob_icon

/obj/item/setup_sprite_sheets()
	. = ..()
	if(_alate_onmob_icon)
		LAZYSET(sprite_sheets, BODYTYPE_MANTID_SMALL, _alate_onmob_icon)
	if(_gyne_onmob_icon)
		LAZYSET(sprite_sheets, BODYTYPE_MANTID_LARGE, _gyne_onmob_icon)
