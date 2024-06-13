/obj/item/clothing/head/overseerhood
	name = "grim hood"
	desc = "Darker than dark. What... what is this <i>made</i> of?"
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SHIELDED,
		ARMOR_BULLET = ARMOR_BALLISTIC_HEAVY,
		ARMOR_LASER = ARMOR_LASER_HEAVY,
		ARMOR_ENERGY = ARMOR_ENERGY_SHIELDED,
		ARMOR_BOMB = ARMOR_BOMB_SHIELDED
		)
	icon = 'icons/clothing/head/necromancer.dmi'
	item_flags = ITEM_FLAG_AIRTIGHT
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0
	bodytype_equip_flags = BODY_FLAG_HUMANOID
	flags_inv = HIDEEARS | BLOCK_HEAD_HAIR

/obj/item/clothing/suit/straight_jacket/overseercloak
	name = "grim cloak"
	desc = "The void of space woven into fabric. It's hard to tell where its edges are."
	icon = 'icons/clothing/suits/wizard/servant/overseer.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SHIELDED,
		ARMOR_BULLET = ARMOR_BALLISTIC_HEAVY,
		ARMOR_LASER = ARMOR_LASER_HEAVY,
		ARMOR_ENERGY = ARMOR_ENERGY_SHIELDED,
		ARMOR_BOMB = ARMOR_BOMB_SHIELDED
		)
	item_flags = ITEM_FLAG_AIRTIGHT
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS|SLOT_TAIL

//These are the ones that it gets when they toggle it off
/obj/item/clothing/shoes/sandal/grimboots
	name = "stained boots"
	desc = "These boots are stained with blood so dry that it's turned black..."
	color = COLOR_BLACK
	shine = 10
	item_flags = ITEM_FLAG_SILENT