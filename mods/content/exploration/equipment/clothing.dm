/obj/item/clothing/suit/explorer
	name = "explorer suit"
	desc = "An armoured suit for exploring harsh environments."
	icon = 'mods/content/exploration/icons/suit_explo.dmi'
	hood = /obj/item/clothing/head/hood/explorer
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	siemens_coefficient = 0.9
	// Inferior to sec vests in bullet/laser but better for environmental protection.
	armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_RESISTANT,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_SMALL,
		(ARMOR_LASER)  = ARMOR_LASER_SMALL,
		(ARMOR_ENERGY) = ARMOR_ENERGY_SMALL,
		(ARMOR_BOMB)   = ARMOR_BOMB_PADDED,
		(ARMOR_BIO)    = ARMOR_BIO_STRONG,
		(ARMOR_RAD)    = ARMOR_RAD_RESISTANT
	)
	allowed = list(
		/obj/item/flashlight,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/knife,
		/obj/item/bladed,
		/obj/item/tank,
		/obj/item/radio,
		/obj/item/tool,
		/obj/item/cataloguer,
		/obj/item/specimen_tagger
	)

/obj/item/clothing/suit/explorer/get_assumed_clothing_state_modifiers()
	var/static/list/expected_state_modifiers = list(
		GET_DECL(/decl/clothing_state_modifier/hood)
	)
	return expected_state_modifiers

/obj/item/clothing/head/hood/explorer
	name = "explorer hood"
	desc = "An armoured hood for exploring harsh environments."
	icon = 'mods/content/exploration/icons/hood_explo.dmi'
	item_flags = ITEM_FLAG_THICKMATERIAL
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_RESISTANT,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_SMALL,
		(ARMOR_LASER)  = ARMOR_LASER_SMALL,
		(ARMOR_ENERGY) = ARMOR_ENERGY_SMALL,
		(ARMOR_BOMB)   = ARMOR_BOMB_PADDED,
		(ARMOR_BIO)    = ARMOR_BIO_STRONG,
		(ARMOR_RAD)    = ARMOR_RAD_RESISTANT
	)

/obj/item/clothing/suit/explorer/xenofauna
	name = "xenofauna field suit"
	desc = "A lightly armoured suit for surveying harsh environments."
	icon = 'mods/content/exploration/icons/suit_xeno.dmi'
	hood = /obj/item/clothing/head/hood/explorer/xenofauna
	siemens_coefficient = 0.5
	 // Better bio/rad protection than explo, but less armour.
	armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_KNIVES,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_MINOR,
		(ARMOR_LASER)  = ARMOR_LASER_MINOR,
		(ARMOR_ENERGY) = ARMOR_ENERGY_MINOR,
		(ARMOR_BOMB)   = ARMOR_BOMB_PADDED,
		(ARMOR_BIO)    = ARMOR_BIO_SHIELDED,
		(ARMOR_RAD)    = ARMOR_RAD_LARGE
	)

/obj/item/clothing/head/hood/explorer/xenofauna
	name = "xenofauna field hood"
	desc = "A lightly armoured hood for surveying harsh environments."
	siemens_coefficient = 0.5
	armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_KNIVES,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_MINOR,
		(ARMOR_LASER)  = ARMOR_LASER_MINOR,
		(ARMOR_ENERGY) = ARMOR_ENERGY_MINOR,
		(ARMOR_BOMB)   = ARMOR_BOMB_PADDED,
		(ARMOR_BIO)    = ARMOR_BIO_SHIELDED,
		(ARMOR_RAD)    = ARMOR_RAD_LARGE
	)
	icon = 'mods/content/exploration/icons/hood_xeno.dmi'

/obj/item/clothing/shoes/winterboots/explorer
	name = "explorer winter boots"
	desc = "Steel-toed winter boots for mining or exploration in hazardous environments. Very good at keeping toes warm and uncrushed."
	icon = 'mods/content/exploration/icons/boots_explo.dmi'
	armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_RESISTANT,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_MINOR,
		(ARMOR_LASER)  = ARMOR_LASER_MINOR,
		(ARMOR_ENERGY) = ARMOR_ENERGY_MINOR,
		(ARMOR_BOMB)   = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/jumpsuit/explorer
	name = "explorer's jumpsuit"
	desc = "A grey and cyan uniform for working in the field."
	icon = 'mods/content/exploration/icons/uniform_explo.dmi'

/obj/item/clothing/jumpsuit/xenofauna
	name = "xenofauna technician's jumpsuit"
	desc = "A grey and purple uniform for working in the field."
	icon = 'mods/content/exploration/icons/uniform_xeno.dmi'

/obj/item/clothing/mask/gas/explorer
	icon = 'mods/content/exploration/icons/mask_explo.dmi'
	name = "explorer gas mask"
	desc = "A military-grade gas mask that can be connected to an air supply."
	armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_SMALL,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_MINOR,
		(ARMOR_LASER)  = ARMOR_LASER_MINOR,
		(ARMOR_ENERGY) = ARMOR_ENERGY_MINOR,
		(ARMOR_BIO)    = ARMOR_BIO_RESISTANT,
	)
	siemens_coefficient = 0.9

/obj/item/clothing/permit/gun/planetside
	name = "planetside weapon permit"
	desc = "A card indicating that the owner is allowed to carry a weapon while on the surface."
	detail_color = COLOR_PALE_PINK

/obj/item/clothing/permit/gun/planetside/exploration
	name = "explorer weapon permit"
	desc = "A card indicating that the owner is allowed to carry weaponry during active exploration missions."
