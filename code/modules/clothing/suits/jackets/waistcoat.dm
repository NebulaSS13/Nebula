/obj/item/clothing/suit/jacket/waistcoat
	name = "waistcoat"
	desc = "A classy waistcoat."
	icon = 'icons/clothing/accessories/clothing/vest.dmi'

/obj/item/clothing/suit/jacket/waistcoat/black
	color = COLOR_GRAY15

/obj/item/clothing/suit/jacket/waistcoat/armored
	desc = "A classy waistcoat. This one seems suspiciously more durable."
	color = COLOR_GRAY15
	armor = list(
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_MELEE = ARMOR_MELEE_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR
		)
	body_parts_covered = SLOT_UPPER_BODY
	origin_tech = @'{"combat":2,"materials":3,"esoteric":2}'
