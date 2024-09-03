/obj/item/clothing/shirt/tunic
	name = "tunic"
	desc = "A long garment that belts around the waist."
	body_parts_covered = SLOT_UPPER_BODY | SLOT_LOWER_BODY
	slot_flags = SLOT_UPPER_BODY | SLOT_OVER_BODY
	icon = 'icons/clothing/shirts/tunics/tunic.dmi'
	markings_state_modifier = "_skirt"
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/item/clothing/shirt/tunic/short
	icon = 'icons/clothing/shirts/tunics/tunic_short.dmi'
	desc = "A short garment that belts around the waist."
	body_parts_covered = SLOT_UPPER_BODY

/obj/item/clothing/shirt/tunic/blue
	name = "blue tunic"
	desc = "A royal blue tunic. Beautifully archaic."
	icon = 'icons/clothing/shirts/tunics/tunic_blue.dmi'
	material_alteration = MAT_FLAG_ALTERATION_NONE
	markings_state_modifier = null

/obj/item/clothing/shirt/tunic/blue/champion
	name = "champion's tunic"
	siemens_coefficient = 0.8
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MINOR
	)

/obj/item/clothing/shirt/tunic/green
	name = "green tunic"
	desc = "It looks like a cross between Robin Hood's tunic and some patchwork leather armor. Whoever put this together must have been in a hurry."
	icon = 'icons/clothing/shirts/tunics/tunic_green.dmi'
	material_alteration = MAT_FLAG_ALTERATION_NONE
	markings_state_modifier = null

/obj/item/clothing/shirt/tunic/green/familiar
	name = "familiar's tunic"
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_LASER = ARMOR_LASER_MINOR,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL
	)

/obj/item/clothing/shirt/tunic/captain
	name = "captain's parade tunic"
	desc = "Worn by a Captain to show their class."
	icon = 'icons/clothing/shirts/tunics/tunic_captain.dmi'
	body_parts_covered = SLOT_UPPER_BODY | SLOT_LOWER_BODY | SLOT_ARMS
	material_alteration = MAT_FLAG_ALTERATION_NONE
	markings_state_modifier = null
