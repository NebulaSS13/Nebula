/decl/loadout_category/avian
	name = "Avian"

/decl/loadout_option/avian
	whitelisted = list(SPECIES_AVIAN)
	category = /decl/loadout_category/avian
	abstract_type = /decl/loadout_option/avian

/decl/loadout_option/avian/uniform_selection
	name = "Neo-Avian uniform selection"
	path = /obj/item/clothing/dress/avian_smock
	slot = slot_w_uniform_str
	uid = "gear_under_avian"

/decl/loadout_option/avian/uniform_selection/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"plain smock"     = /obj/item/clothing/dress/avian_smock,
		"worker's smock"  = /obj/item/clothing/dress/avian_smock/worker,
		"rainbow smock"   = /obj/item/clothing/dress/avian_smock/rainbow,
		"armoured smock"  = /obj/item/clothing/dress/avian_smock/security,
		"hazard smock"    = /obj/item/clothing/dress/avian_smock/engineering,
		"black uniform"   = /obj/item/clothing/dress/avian_smock/utility,
		"gray uniform"    = /obj/item/clothing/dress/avian_smock/utility/gray,
		"stylish uniform" = /obj/item/clothing/dress/avian_smock/stylish_command
	)

/decl/loadout_option/avian/shoes
	name  = "footwraps"
	path  = /obj/item/clothing/shoes/avian/footwraps
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	slot  = slot_shoes_str
	uid = "gear_shoes_avian"
