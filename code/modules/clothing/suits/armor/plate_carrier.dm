//Modular plate carriers
/obj/item/clothing/suit/armor/pcarrier
	name = "plate carrier"
	desc = "A lightweight plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon = 'icons/clothing/suit/armor/plate_carrier.dmi'
	color = COLOR_GRAY40
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/suit/armor/pcarrier/light
	starting_accessories = list(/obj/item/clothing/accessory/armorplate)
	origin_tech = "{'materials':1,'engineering':1, 'combat':1}"

/obj/item/clothing/suit/armor/pcarrier/light/press
	color = COLOR_BABY_BLUE
	starting_accessories = list(/obj/item/clothing/accessory/armorplate, /obj/item/clothing/accessory/armor/tag/press)
	origin_tech = "{'materials':1,'engineering':1, 'combat':1}"

/obj/item/clothing/suit/armor/pcarrier/medium
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/medium, /obj/item/clothing/accessory/storage/pouches)
	origin_tech = "{'materials':1,'engineering':1, 'combat':1}"

/obj/item/clothing/suit/armor/pcarrier/blue
	color = COLOR_BABY_BLUE
	material = /decl/material/solid/leather
	origin_tech = "{'materials':1,'engineering':1, 'combat':1}"

/obj/item/clothing/suit/armor/pcarrier/tan
	color = COLOR_TAN
	material = /decl/material/solid/leather
	origin_tech = "{'materials':1,'engineering':1, 'combat':1}"

// No ACC variants cause no thats not fair

/obj/item/clothing/suit/armor/pcarrier/light/noacc
	material = /decl/material/solid/leather
	origin_tech = "{'materials':1,'engineering':1, 'combat':1}"

/obj/item/clothing/suit/armor/pcarrier/light/press/noacc
	color = COLOR_BABY_BLUE
	starting_accessories = list(/obj/item/clothing/accessory/armor/tag/press)
	material = /decl/material/solid/leather
	origin_tech = "{'materials':1,'engineering':1, 'combat':1}"

/obj/item/clothing/suit/armor/pcarrier/medium/noacc
	starting_accessories = list(/obj/item/clothing/accessory/storage/pouches)
	material = /decl/material/solid/leather
	origin_tech = "{'materials':1,'engineering':1, 'combat':1}"
