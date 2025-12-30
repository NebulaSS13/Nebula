// TODO: big fuckoff fur collar icons
/obj/item/clothing/head/hood/cloak/winter
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	material = /decl/material/solid/organic/cloth/wool

/obj/item/clothing/suit/hooded_cloak/winter
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS|SLOT_LEGS|SLOT_HANDS|SLOT_FEET
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	hood = /obj/item/clothing/head/hood/cloak/winter
	protects_against_weather = TRUE
	material = /decl/material/solid/organic/cloth/wool

/obj/item/clothing/suit/robe/sleeved/shrine
	material                = /decl/material/solid/organic/cloth/linen
	paint_color             = COLOR_DARK_RED
	markings_color          = COLOR_OFF_WHITE
	markings_state_modifier = "_sleeves"
