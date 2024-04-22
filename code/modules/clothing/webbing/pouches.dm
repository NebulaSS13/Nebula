//Pouches
/obj/item/clothing/webbing/pouches
	name = "storage pouches"
	desc = "A collection of black pouches that can be attached to a plate carrier. Carries up to two items."
	icon = 'icons/clothing/accessories/pouches/pouches.dmi'
	icon_state = ICON_STATE_WORLD
	color = COLOR_GRAY40
	gender = PLURAL
	storage = /datum/storage/pouches
	accessory_slot = ACCESSORY_SLOT_ARMOR_S

/obj/item/clothing/webbing/pouches/large
	name = "large storage pouches"
	desc = "A collection of black pouches that can be attached to a plate carrier. Carries up to four items."
	icon = 'icons/clothing/accessories/pouches/lpouches.dmi'
	storage = /datum/storage/pouches/large
	accessory_slowdown = 1

/obj/item/clothing/webbing/pouches/large/tan
	color = COLOR_TAN