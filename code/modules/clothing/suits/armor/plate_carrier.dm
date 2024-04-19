//Modular plate carriers
/obj/item/clothing/suit/armor/pcarrier
	name = "plate carrier"
	desc = "A lightweight plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon = 'icons/clothing/suit/armor/plate_carrier.dmi'
	color = COLOR_GRAY40
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	material = /decl/material/solid/organic/leather
	starting_accessories = null

/obj/item/clothing/suit/armor/pcarrier/light
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate)

/obj/item/clothing/suit/armor/pcarrier/press
	color = COLOR_BABY_BLUE
	starting_accessories = list(/obj/item/clothing/accessory/armor/tag/press)

/obj/item/clothing/suit/armor/pcarrier/press/prepared
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate, /obj/item/clothing/accessory/armor/tag/press)

/obj/item/clothing/suit/armor/pcarrier/medium
	starting_accessories = list(/obj/item/clothing/accessory/armor/plate/medium, /obj/item/clothing/webbing/pouches)

/obj/item/clothing/suit/armor/pcarrier/blue
	name = "blue plate carrier"
	color = COLOR_BABY_BLUE

/obj/item/clothing/suit/armor/pcarrier/tan
	name = "tan plate carrier"
	color = COLOR_TAN

/obj/item/clothing/suit/armor/pcarrier/green
	name = "green plate carrier"
	color = COLOR_DARK_GREEN_GRAY
