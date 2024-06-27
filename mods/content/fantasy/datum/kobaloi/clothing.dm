/obj/item/bag/sack/Initialize()
	. = ..()
	if(!(BODYTYPE_KOBALOI in sprite_sheets))
		LAZYSET(sprite_sheets, BODYTYPE_KOBALOI, 'mods/content/fantasy/icons/clothing/sack_kobaloi.dmi')