/obj/item/clothing/head/caretakerhood
	name = "holy hood"
	desc = "The hood of a shining white robe, with blue trim. Who would possess this robe and still want to hide themself away?"
	icon = 'icons/clothing/head/caretaker.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)
	bodytype_equip_flags = BODY_FLAG_HUMANOID
	flags_inv = HIDEEARS | BLOCK_HEAD_HAIR

/obj/item/clothing/suit/caretakercloak
	name = "holy cloak"
	desc = "A shining white and blue robe. For some reason, it reminds you of the holidays."
	icon = 'icons/clothing/suits/wizard/servant/caretaker.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)

/obj/item/clothing/shoes/dress/caretakershoes
	name = "black leather shoes"
	desc = "Dress shoes. These aren't as shiny as usual."
	inset_color = COLOR_SKY_BLUE
	shine = 30
	armor = list(
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)