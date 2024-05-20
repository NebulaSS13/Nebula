/obj/item/clothing/suit/armor/bulletproof
	name = "ballistic vest"
	desc = "An armored vest with heavy plates to protect against ballistic projectiles."
	icon = 'icons/clothing/suits/armor/ballistic.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_AP,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	starting_accessories = null
	siemens_coefficient = 0.7
	material = /decl/material/solid/metal/plasteel
	matter = list(
		/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
		)
	origin_tech = @'{"materials":3,"engineering":1,"combat":3}'

/obj/item/clothing/suit/armor/bulletproof/prepared
	starting_accessories = list(
		/obj/item/clothing/gloves/armguards/ballistic,
		/obj/item/clothing/shoes/legguards/ballistic
	)

/obj/item/clothing/gloves/armguards/ballistic
	name = "ballistic arm guards"
	desc = "A pair of armored arm pads with heavy plates to protect against ballistic projectiles."
	icon = 'icons/clothing/accessories/armor/armguards_ballistic.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_RIFLE,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	color = null
	siemens_coefficient = 0.7
	material = /decl/material/solid/metal/plasteel
	matter = list(
		/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
		)
	origin_tech = @'{"materials":3,"engineering":1,"combat":3}'

/obj/item/clothing/shoes/legguards/ballistic
	name = "ballistic leg guards"
	desc = "A pair of armored leg pads with heavy plates to protect against ballistic projectiles. Looks like they might impair movement."
	icon = 'icons/clothing/accessories/armor/legguards_ballistic.dmi'
	color = null
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_RIFLE,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.7
	accessory_slowdown = 1
	material = /decl/material/solid/metal/plasteel
	matter = list(
		/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
		)
	origin_tech = @'{"materials":3,"engineering":1,"combat":3}'