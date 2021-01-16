//Orange emergency space suit
/obj/item/clothing/head/helmet/space/emergency
	name = "emergency space helmet"
	desc = "A simple helmet with a built in light, smells like mothballs."
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/emergency
	name = "Emergency Softsuit"
	icon = 'icons/clothing/spacesuit/emergency/suit.dmi'
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate, looks pretty fragile."

/obj/item/clothing/suit/space/emergency/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 4)
