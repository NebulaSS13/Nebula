/obj/item/clothing/suit/armor/riot
	name = "riot vest"
	desc = "An armored vest with heavy padding to protect against melee attacks."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/suits/armor/riot.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.5
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/cloth = MATTER_AMOUNT_SECONDARY
		)
	origin_tech = @'{"materials":1,"engineering":1,"combat":2}'

/obj/item/clothing/suit/armor/riot/prepared
	starting_accessories = list(
		/obj/item/clothing/gloves/armguards/riot,
		/obj/item/clothing/shoes/legguards/riot
	)

// Parts

/obj/item/clothing/shoes/legguards/riot
	name = "riot leg guards"
	desc = "A pair of armored leg pads with heavy padding to protect against melee attacks. Looks like they might impair movement."
	icon = 'icons/clothing/accessories/armor/legguards_riot.dmi'
	color = null
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.5
	accessory_slowdown = 1
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/organic/cloth = MATTER_AMOUNT_SECONDARY)
	origin_tech = @'{"materials":1,"engineering":1,"combat":2}'

/obj/item/clothing/gloves/armguards/riot
	name = "riot arm guards"
	desc = "A pair of armored arm pads with heavy padding to protect against melee attacks."
	icon = 'icons/clothing/accessories/armor/armguards_riot.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	color = null
	siemens_coefficient = 0.5
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/organic/cloth = MATTER_AMOUNT_SECONDARY)
	origin_tech = @'{"materials":1,"engineering":1,"combat":2}'

