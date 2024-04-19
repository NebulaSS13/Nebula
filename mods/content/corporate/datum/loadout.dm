/decl/loadout_option/accessory/ntaward
	name = "corporate award selection"
	description = "A medal or ribbon awarded to corporate personnel for significant accomplishments."
	path = /obj/item/clothing/medal
	cost = 8

/decl/loadout_option/accessory/ntaward/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"sciences medal" =        /obj/item/clothing/medal/nanotrasen/bronze,
		"distinguished service" = /obj/item/clothing/medal/nanotrasen/silver,
		"command medal" =         /obj/item/clothing/medal/nanotrasen/gold
	)

/decl/loadout_option/accessory/armband_nt
	name = "corporate armband"
	path = /obj/item/clothing/armband/whitegreen

/decl/loadout_option/suit/labcoat_corp
	name = "labcoat, corporate colors"
	path = /obj/item/clothing/suit/toggle/labcoat/science
	loadout_flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/corporate
	name = "corporate uniform selection"
	path = /obj/item/clothing/under

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

/decl/loadout_option/uniform/corp_overalls
	name = "corporate colours, coveralls"
	path = /obj/item/clothing/under/work
	loadout_flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/corp_flight
	name = "corporate colours, flight suit"
	path = /obj/item/clothing/under/pilot
	loadout_flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/corp_exec_jacket
	name = "corporate colours, liason suit"
	path = /obj/item/clothing/under/formal/corp
	loadout_flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/suit/nanotrasen_poncho
	name = "poncho, NanoTrasen"
	path = /obj/item/clothing/suit/poncho/roles/science/nanotrasen

/decl/loadout_option/suit/corp_jacket
	name = "corporate jacket selection"
	path = /obj/item/clothing/suit

/decl/loadout_option/suit/corp_jacket/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/jacket/leather/nanotrasen,
		/obj/item/clothing/suit/jacket/brown/nanotrasen
	)

/decl/loadout_option/suit/science_poncho
	name = "poncho, science"
	path = /obj/item/clothing/suit/poncho/roles/science

/decl/loadout_option/suit/hoodie_nt
	name = "hoodie, NanoTrasen"
	path = /obj/item/clothing/suit/toggle/nt_hoodie

/decl/loadout_option/suit/wintercoat_dais
	name = "winter coat, DAIS"
	path = /obj/item/clothing/suit/jacket/winter/dais

/decl/loadout_option/suit/leather/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= /obj/item/clothing/suit/mbill
