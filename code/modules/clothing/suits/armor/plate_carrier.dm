//Modular plate carriers
/obj/item/clothing/suit/armor/pcarrier
	name = "plate carrier"
	desc = "A lightweight plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon = 'icons/obj/clothing/obj_suit_modular_armor.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/onmob/onmob_modular_armor.dmi')
	icon_state = "pcarrier"
	color = COLOR_GRAY40
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/suit/armor/pcarrier/light
	starting_accessories = list(/obj/item/clothing/accessory/armorplate)

/obj/item/clothing/suit/armor/pcarrier/light/press
	color = COLOR_BABY_BLUE
	starting_accessories = list(/obj/item/clothing/accessory/armorplate, /obj/item/clothing/accessory/armor/tag/press)

/obj/item/clothing/suit/armor/pcarrier/medium
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/medium, /obj/item/clothing/accessory/storage/pouches)

/obj/item/clothing/suit/armor/pcarrier/blue
	color = COLOR_BABY_BLUE

/obj/item/clothing/suit/armor/pcarrier/tan
	color = COLOR_TAN
