//Leg guards
/obj/item/clothing/shoes/legguards
	name = "leg guards"
	desc = "A pair of armored leg pads in black. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/legguards.dmi'
	icon_state = ICON_STATE_WORLD
	color = COLOR_GRAY40
	gender = PLURAL
	body_parts_covered = SLOT_LEGS
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)
	origin_tech = @'{"materials":1,"engineering":1,"combat":1}'
	accessory_slot = ACCESSORY_SLOT_ARMOR_L
	slot_flags = SLOT_FEET

/obj/item/clothing/shoes/legguards/craftable
	material_armor_multiplier = 1
	matter = null
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
