/decl/loadout_option/accessory/ntaward
	name = "corporate award selection"
	description = "A medal or ribbon awarded to corporate personnel for significant accomplishments."
	path = /obj/item/clothing/accessory/medal
	cost = 8
	uid = "gear_accessory_corpaward"

/decl/loadout_option/accessory/ntaward/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"sciences medal" =        /obj/item/clothing/accessory/medal/nanotrasen/bronze,
		"distinguished service" = /obj/item/clothing/accessory/medal/nanotrasen/silver,
		"command medal" =         /obj/item/clothing/accessory/medal/nanotrasen/gold
	)

/decl/loadout_option/accessory/armband_nt
	name = "corporate armband"
	path = /obj/item/clothing/accessory/armband/whitegreen
	uid = "gear_accessory_corparmband"

/decl/loadout_option/suit/labcoat_corp
	name = "labcoat, corporate colors"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/science
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_suit_corplabcoat"

/decl/loadout_option/uniform/corporate
	name = "corporate uniform selection"
	path = /obj/item/clothing/under
	uid = "gear_under_corpuniform"

/decl/loadout_option/uniform/corporate/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/under/polo/nanotrasen,
		/obj/item/clothing/under/polo/heph,
		/obj/item/clothing/under/polo/zeng,
		/obj/item/clothing/under/mbill,
		/obj/item/clothing/under/saare,
		/obj/item/clothing/under/aether,
		/obj/item/clothing/under/hephaestus,
		/obj/item/clothing/under/guard/pcrc,
		/obj/item/clothing/under/guard/pcrcsuit,
		/obj/item/clothing/under/wardt,
		/obj/item/clothing/under/grayson,
		/obj/item/clothing/under/focal,
		/obj/item/clothing/under/morpheus,
		/obj/item/clothing/under/skinner,
		/obj/item/clothing/under/dais
	)

/decl/loadout_option/uniform/corp_exec
	name = "corporate colours, senior researcher"
	path = /obj/item/clothing/under/executive
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_corpexec"

/decl/loadout_option/uniform/corp_overalls
	name = "corporate colours, coveralls"
	path = /obj/item/clothing/under/work
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_corpcoveralls"

/decl/loadout_option/uniform/corp_flight
	name = "corporate colours, flight suit"
	path = /obj/item/clothing/under/pilot
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_corpflight"

/decl/loadout_option/uniform/corp_exec_jacket
	name = "corporate colours, liason suit"
	path = /obj/item/clothing/under/suit_jacket/corp
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_corpexecjacket"

/decl/loadout_option/suit/nanotrasen_poncho
	name = "poncho, NanoTrasen"
	path = /obj/item/clothing/suit/poncho/roles/science/nanotrasen
	uid = "gear_suit_corpponcho"

/decl/loadout_option/suit/corp_jacket
	name = "corporate jacket selection"
	path = /obj/item/clothing/suit
	uid = "gear_suit_corpjacket"

/decl/loadout_option/suit/corp_jacket/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/storage/leather_jacket/nanotrasen,
		/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	)

/decl/loadout_option/suit/science_poncho
	name = "poncho, science"
	path = /obj/item/clothing/suit/poncho/roles/science
	uid = "gear_suit_corpponcho_science"

/decl/loadout_option/suit/hoodie_nt
	name = "hoodie, NanoTrasen"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/nt
	uid = "gear_suit_corphoodie"

/decl/loadout_option/suit/wintercoat_dais
	name = "winter coat, DAIS"
	path = /obj/item/clothing/suit/storage/toggle/wintercoat/dais
	uid = "gear_suit_corpcoat_dais"

/decl/loadout_option/suit/leather/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= /obj/item/clothing/suit/storage/mbill
