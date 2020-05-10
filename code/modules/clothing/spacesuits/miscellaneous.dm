//Orange emergency space suit
/obj/item/clothing/head/helmet/space/emergency
	name = "emergency space helmet"
	desc = "A simple helmet with a built in light, smells like mothballs."
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/emergency
	name = "Emergency Softsuit"
	icon_state = "space_emergency"
	icon = 'icons/clothing/spacesuit/emergency/suit.dmi'
	on_mob_icon = 'icons/clothing/spacesuit/emergency/suit.dmi'
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate, looks pretty fragile."

/obj/item/clothing/suit/space/emergency/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 4
