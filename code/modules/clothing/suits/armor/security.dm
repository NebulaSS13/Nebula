/obj/item/clothing/suit/armor/vest/heavy/warden
	starting_accessories = list(
		/obj/item/clothing/webbing/pouches,
		/obj/item/clothing/armor_attachment/tag
	)

/obj/item/clothing/suit/armor/vest/heavy/hos
	starting_accessories = list(
		/obj/item/clothing/webbing/pouches,
		/obj/item/clothing/armor_attachment/tag/hos
	)

/obj/item/clothing/suit/armor/pcarrier/detective
	color = COLOR_DARK_GREEN_GRAY
	starting_accessories = list(
		/obj/item/clothing/armor_attachment/plate,
		/obj/item/clothing/badge
	)

/obj/item/clothing/suit/armor/pcarrier/tactical
	name = "tactical plate carrier"
	color = COLOR_TAN
	starting_accessories = list(
		/obj/item/clothing/armor_attachment/plate/tactical,
		/obj/item/clothing/webbing/pouches/large/tan
	)

/obj/item/clothing/suit/armor/warden
	name = "warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon = 'icons/clothing/suits/warden.dmi'
	armor = list(
		ARMOR_MELEE  = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER  = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB   = ARMOR_BOMB_MINOR
		)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	heat_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	material = /decl/material/solid/organic/leather
	matter = list(
		/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)
