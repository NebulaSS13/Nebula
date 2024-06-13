/obj/item/clothing/head/fiendhood
	name = "fiend's hood"
	desc = "A dark hood with blood-red trim. Something about the fabric blocks more light than it should."
	icon = 'icons/clothing/head/fiend_hood.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)
	bodytype_equip_flags = BODY_FLAG_HUMANOID
	flags_inv = HIDEEARS | BLOCK_HEAD_HAIR

/obj/item/clothing/suit/fiendcowl
	name = "fiend's cowl"
	desc = "A charred black duster with red trim. In its fabric, you can see the faint outline of millions of eyes."
	icon = 'icons/clothing/suits/wizard/servant/fiend_cowl.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS|SLOT_TAIL
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)

/obj/item/clothing/costume/fiendsuit
	name = "black suit"
	desc = "A snappy black suit with red trim. The undershirt's stained with something, though..."
	icon = 'icons/clothing/suits/suit_fiend.dmi'
	bodytype_equip_flags = BODY_FLAG_HUMANOID

/obj/item/clothing/shoes/dress/devilshoes
	desc = "Off-colour leather dress shoes. Their footsteps are silent."
	inset_color = COLOR_MAROON
	item_flags = ITEM_FLAG_SILENT
	color = "#2e1e1e"

/obj/item/clothing/head/fiendhood/fem
	name = "fiend's visage"
	desc = "To gaze upon this is to gaze into an inferno. Look away, before it looks back of its own accord."
	icon = 'icons/clothing/head/fiend_visage.dmi'
	flags_inv = HIDEEARS | BLOCK_ALL_HAIR

/obj/item/clothing/suit/fiendcowl/fem
	name = "fiend's robe"
	icon = 'icons/clothing/suits/wizard/servant/fiend_robe.dmi'
	desc = "A tattered, black and red robe. Nothing is visible through the holes in its fabric, except for a strange, inky blackness. It looks as if it was stitched together with other clothing..."
