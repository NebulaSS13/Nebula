/decl/loadout_category/teshari
	name = "Avian"

/decl/loadout_option/teshari
	whitelisted = list(/decl/species/teshari::uid)
	category = /decl/loadout_category/teshari
	abstract_type = /decl/loadout_option/teshari

/decl/loadout_option/teshari/uniform_selection
	name = "teshari uniform selection"
	path = /obj/item/clothing/dress/teshari_smock
	slot = slot_w_uniform_str
	uid = "gear_under_tesh"

/decl/loadout_option/teshari/uniform_selection/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"plain smock"     = /obj/item/clothing/dress/teshari_smock,
		"worker's smock"  = /obj/item/clothing/dress/teshari_smock/worker,
		"rainbow smock"   = /obj/item/clothing/dress/teshari_smock/rainbow,
		"armoured smock"  = /obj/item/clothing/dress/teshari_smock/security,
		"hazard smock"    = /obj/item/clothing/dress/teshari_smock/engineering,
		"black uniform"   = /obj/item/clothing/dress/teshari_smock/utility,
		"gray uniform"    = /obj/item/clothing/dress/teshari_smock/utility/gray,
		"stylish uniform" = /obj/item/clothing/dress/teshari_smock/stylish_command
	)

/decl/loadout_option/teshari/shoes
	name  = "footwraps"
	path  = /obj/item/clothing/shoes/teshari/footwraps
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	slot  = slot_shoes_str
	uid = "gear_shoes_tesh"
