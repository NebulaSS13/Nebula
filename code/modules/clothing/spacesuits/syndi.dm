//Regular syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate
	name = "red space helmet"
	icon = 'icons/clothing/head/space/syndicate/red.dmi'
	desc = "A crimson helmet sporting clean lines and durable plating. Engineered to look menacing."
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SMALL,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/syndicate
	name = "red space suit"
	icon = 'icons/clothing/suits/space/syndicate/red.dmi'
	desc = "A crimson spacesuit sporting clean lines and durable plating. Robust, reliable, and slightly suspicious."
	w_class = ITEM_SIZE_NORMAL
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/energy_blade/sword,/obj/item/handcuffs,/obj/item/tank/emergency)
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SMALL,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/syndicate/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)

//Green syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/green
	name = "green space helmet"
	icon = 'icons/clothing/head/space/syndicate/green.dmi'

/obj/item/clothing/suit/space/syndicate/green
	name = "green space suit"
	icon = 'icons/clothing/suits/space/syndicate/green.dmi'

//Dark green syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/green/dark
	name = "dark green space helmet"
	icon = 'icons/clothing/head/space/syndicate/darkgreen.dmi'

/obj/item/clothing/suit/space/syndicate/green/dark
	name = "dark green space suit"
	icon = 'icons/clothing/suits/space/syndicate/darkgreen.dmi'


//Orange syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/orange
	name = "orange space helmet"
	icon = 'icons/clothing/head/space/syndicate/orange.dmi'

/obj/item/clothing/suit/space/syndicate/orange
	name = "orange space suit"
	icon = 'icons/clothing/suits/space/syndicate/orange.dmi'


//Blue syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/blue
	name = "blue space helmet"
	icon = 'icons/clothing/head/space/syndicate/blue.dmi'

/obj/item/clothing/suit/space/syndicate/blue
	name = "blue space suit"
	icon = 'icons/clothing/suits/space/syndicate/blue.dmi'


//Black syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black
	name = "black space helmet"
	icon = 'icons/clothing/head/space/syndicate/black.dmi'

/obj/item/clothing/suit/space/syndicate/black
	name = "black space suit"
	icon = 'icons/clothing/suits/space/syndicate/black.dmi'


//Black-green syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/green
	name = "black and green space helmet"
	icon = 'icons/clothing/head/space/syndicate/blackgreen.dmi'

/obj/item/clothing/suit/space/syndicate/black/green
	name = "black and green space suit"
	icon = 'icons/clothing/suits/space/syndicate/blackgreen.dmi'


//Black-blue syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/blue
	name = "black and blue space helmet"
	icon = 'icons/clothing/head/space/syndicate/blackblue.dmi'

/obj/item/clothing/suit/space/syndicate/black/blue
	name = "black and blue space suit"
	icon = 'icons/clothing/suits/space/syndicate/blackblue.dmi'


//Black medical syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/med
	name = "black medical space helmet"
	icon = 'icons/clothing/head/space/syndicate/blackmed.dmi'

/obj/item/clothing/suit/space/syndicate/black/med
	name = "black medical space suit"
	icon = 'icons/clothing/suits/space/syndicate/blackmed.dmi'


//Black-orange syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/orange
	name = "black and orange space helmet"
	icon = 'icons/clothing/head/space/syndicate/blackorange.dmi'

/obj/item/clothing/suit/space/syndicate/black/orange
	name = "black and orange space suit"
	icon = 'icons/clothing/suits/space/syndicate/blackorange.dmi'


//Black-red syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/red
	name = "black and red space helmet"
	icon = 'icons/clothing/head/space/syndicate/blackred.dmi'

/obj/item/clothing/suit/space/syndicate/black/red
	name = "black and red space suit"
	icon = 'icons/clothing/suits/space/syndicate/blackred.dmi'

//Black with yellow/red engineering syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/engie
	name = "black engineering space helmet"
	icon = 'icons/clothing/head/space/syndicate/blackengie.dmi'

/obj/item/clothing/suit/space/syndicate/black/engie
	name = "black engineering space suit"
	icon = 'icons/clothing/suits/space/syndicate/blackengie.dmi'