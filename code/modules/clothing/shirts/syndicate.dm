/obj/item/clothing/shirt/syndicate
	name = "tactical turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, turtleneck sweater."
	icon = 'icons/clothing/shirts/sweater_tactical.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_MINOR
		)
	siemens_coefficient = 0.9
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_TRACE)

/obj/item/clothing/shirt/syndicate/combat
	name = "combat turtleneck"
	desc = "The height of fashion and tactical utility."
	icon = 'icons/clothing/shirts/sweater_combat.dmi'

/obj/item/clothing/shirt/syndicate/tacticool
	name = "\improper Tacticool turtleneck"
	desc = "Just looking at it makes you want to buy an SKS, go into the woods, and -operate-."
	armor = null
	siemens_coefficient = 1
	matter = null
