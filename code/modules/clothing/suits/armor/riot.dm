/obj/item/clothing/suit/armor/riot
	name = "riot vest"
	desc = "An armored vest with heavy padding to protect against melee attacks."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/suit/armor/riot.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.5
	starting_accessories = list(/obj/item/clothing/accessory/armguards/riot, /obj/item/clothing/accessory/legguards/riot)

// Parts

/obj/item/clothing/accessory/legguards/riot
	name = "riot leg guards"
	desc = "A pair of armored leg pads with heavy padding to protect against melee attacks. Looks like they might impair movement."
	icon_state = "legguards_riot"
	color = null
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.5
	slowdown = 1
	matter = list(/decl/material/solid/metal/titanium = MATTER_AMOUNT_PRIMARY)
	origin_tech = "{'materials':2,'engineering':1,'combat':2}"
	
/obj/item/clothing/accessory/armguards/riot
	name = "riot arm guards"
	desc = "A pair of armored arm pads with heavy padding to protect against melee attacks."
	icon_state = "armguards_riot"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
		)
	color = null
	siemens_coefficient = 0.5
	matter = list(/decl/material/solid/metal/titanium = MATTER_AMOUNT_PRIMARY)
	origin_tech = "{'materials':2,'engineering':1,'combat':2}"

// no accessory
/obj/item/clothing/suit/armor/riot/noacc
	starting_accessories = null
