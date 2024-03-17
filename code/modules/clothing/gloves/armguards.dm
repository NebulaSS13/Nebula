//Arm guards
/obj/item/clothing/gloves/armguards
	name = "arm guards"
	desc = "A pair of black arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armguards.dmi'
	icon_state = ICON_STATE_WORLD
	color = COLOR_GRAY40
	gender = PLURAL
	body_parts_covered = SLOT_ARMS
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	accessory_slot = ACCESSORY_SLOT_ARMOR_A
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)
	origin_tech = @'{"materials":1,"engineering":1,"combat":1}'

/obj/item/clothing/gloves/armguards/craftable
	material_armor_multiplier = 1
	matter = null
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

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

/obj/item/clothing/gloves/armguards/ablative
	name = "ablative arm guards"
	desc = "A pair of armored arm pads with advanced shielding to protect against energy weapons."
	icon = 'icons/clothing/accessories/armor/armguards_ablative.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_RIFLES,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	color = null
	siemens_coefficient = 0

/obj/item/clothing/gloves/armguards/merc
	name = "heavy arm guards"
	desc = "A pair of red-trimmed black arm pads reinforced with heavy armor plating. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armguards_merc.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	color = null
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"materials":2,"engineering":1,"combat":2}'
