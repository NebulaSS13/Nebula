//Regular syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate
	name = "red space helmet"
	icon = 'icons/clothing/head/space/syndicate/red.dmi'
	on_mob_icon = 'icons/clothing/head/space/syndicate/red.dmi'
	icon_state = "syndicate"
	item_state = "syndicate"
	desc = "A crimson helmet sporting clean lines and durable plating. Engineered to look menacing."
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/syndicate
	name = "red space suit"
	icon = 'icons/clothing/suit/space/syndicate/red.dmi'
	on_mob_icon = 'icons/clothing/suit/space/syndicate/red.dmi'
	desc = "A crimson spacesuit sporting clean lines and durable plating. Robust, reliable, and slightly suspicious."
	w_class = ITEM_SIZE_NORMAL
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs,/obj/item/tank/emergency)
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/syndicate/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1

//Green syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/green
	name = "green space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/green.dmi'

/obj/item/clothing/suit/space/syndicate/green
	name = "green space suit"
	icon = 'icons/clothing/suit/space/syndicate/green.dmi'

//Dark green syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/green/dark
	name = "dark green space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/darkgreen.dmi'

/obj/item/clothing/suit/space/syndicate/green/dark
	name = "dark green space suit"
	on_mob_icon = 'icons/clothing/suit/space/syndicate/darkgreen.dmi'


//Orange syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/orange
	name = "orange space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/orange.dmi'

/obj/item/clothing/suit/space/syndicate/orange
	name = "orange space suit"
	on_mob_icon = 'icons/clothing/suit/space/syndicate/orange.dmi'


//Blue syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/blue
	name = "blue space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/blue.dmi'

/obj/item/clothing/suit/space/syndicate/blue
	name = "blue space suit"
	on_mob_icon = 'icons/clothing/suit/space/syndicate/blue.dmi'


//Black syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black
	name = "black space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/black.dmi'

/obj/item/clothing/suit/space/syndicate/black
	name = "black space suit"
	on_mob_icon = 'icons/clothing/suit/space/syndicate/black.dmi'


//Black-green syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/green
	name = "black and green space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/blackgreen.dmi'

/obj/item/clothing/suit/space/syndicate/black/green
	name = "black and green space suit"
	on_mob_icon = 'icons/clothing/suit/space/syndicate/blackgreen.dmi'


//Black-blue syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/blue
	name = "black and blue space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/blackblue.dmi'

/obj/item/clothing/suit/space/syndicate/black/blue
	name = "black and blue space suit"
	on_mob_icon = 'icons/clothing/suit/space/syndicate/blackblue.dmi'


//Black medical syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/med
	name = "black medical space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/blackmed.dmi'

/obj/item/clothing/suit/space/syndicate/black/med
	name = "black medical space suit"
	on_mob_icon = 'icons/clothing/suit/space/syndicate/blackmed.dmi'


//Black-orange syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/orange
	name = "black and orange space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/blackorange.dmi'

/obj/item/clothing/suit/space/syndicate/black/orange
	name = "black and orange space suit"
	on_mob_icon = 'icons/clothing/suit/space/syndicate/blackorange.dmi'


//Black-red syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/red
	name = "black and red space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/blackred.dmi'

/obj/item/clothing/suit/space/syndicate/black/red
	name = "black and red space suit"
	on_mob_icon = 'icons/clothing/suit/space/syndicate/blackred.dmi'

//Black with yellow/red engineering syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/engie
	name = "black engineering space helmet"
	on_mob_icon = 'icons/clothing/head/space/syndicate/blackengie.dmi'

/obj/item/clothing/suit/space/syndicate/black/engie
	name = "black engineering space suit"
	on_mob_icon = 'icons/clothing/suit/space/syndicate/blackengie.dmi'