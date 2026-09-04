/obj/item
	var/_drake_onmob_icon
	var/_drake_hatchling_onmob_icon

/obj/item/setup_sprite_sheets()
	. = ..()
	if(_drake_onmob_icon)
		LAZYSET(sprite_sheets, BODYTYPE_GRAFADREKA, _drake_onmob_icon)
	if(_drake_hatchling_onmob_icon)
		LAZYSET(sprite_sheets, BODYTYPE_GRAFADREKA_HATCHLING, _drake_hatchling_onmob_icon)
