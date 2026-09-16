/decl/loadout_option/accessory/webbing_vest
	name = "webbing vest selection (Engineering, Security, Medical, Miner, Explorer)"
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Search and Rescue","Explorer","Shaft Miner")
	path = /obj/item/clothing/webbing/vest
	uid = "loadout_cynosure_webbing_vest"
	loadout_flags = GEAR_HAS_SUBTYPE_SELECTION

/decl/loadout_option/accessory/drop_pouches
	name = "drop pouches selection, (Engineering, Security, Medical, Miner, Explorer)"
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Security Officer","Detective","Head of Security","Warden","Paramedic","Chief Medical Officer","Medical Doctor","Search and Rescue","Explorer","Shaft Miner")
	path = /obj/item/clothing/webbing/drop_pouches
	uid = "loadout_cynosure_webbing_pouches"
	loadout_flags = GEAR_HAS_SUBTYPE_SELECTION

/decl/loadout_option/accessory/holster
	name = "holster selection (Security, CD, HoP, Explorer)"
	path = /obj/item/clothing/webbing/holster
	allowed_roles = list("Site Manager","Head of Personnel","Security Officer","Warden","Head of Security","Detective","Explorer")
	uid = "loadout_cynosure_webbing_holster"

/decl/loadout_option/accessory/holster/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"holster, shoulder" = /obj/item/clothing/webbing/holster,
		"holster, armpit"   = /obj/item/clothing/webbing/holster/armpit,
		"holster, hip"      = /obj/item/clothing/webbing/holster/hip,
		"holster, thigh"    = /obj/item/clothing/webbing/holster/thigh,
		"holster, waist"    = /obj/item/clothing/webbing/holster/waist
	)
