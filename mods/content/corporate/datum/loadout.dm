/decl/loadout_option/accessory/ntaward
	name = "corporate award selection"
	description = "A medal or ribbon awarded to corporate personnel for significant accomplishments."
	path = /obj/item/clothing/medal
	cost = 8
	uid = "gear_accessory_corpaward"

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
	uid = "gear_accessory_corparmband"

/decl/loadout_option/suit/labcoat_corp
	name = "labcoat, corporate colors"
	path = /obj/item/clothing/suit/toggle/labcoat/science
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_suit_corplabcoat"

/decl/loadout_option/uniform/corp_polo
	name = "corporate polo selection"
	path = /obj/item/clothing/shirt/polo/corp
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_suit_corppolo"

/decl/loadout_option/uniform/corp_tunic
	name = "corporate tunic selection"
	path = /obj/item/clothing/shirt/tunic/corp
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_suit_corptunic"

/decl/loadout_option/uniform/corporate_jumpsuit
	name = "corporate jumpsuit selection"
	path = /obj/item/clothing/jumpsuit
	uid = "gear_suit_corpjumpsuit"

/decl/loadout_option/uniform/corporate_jumpsuit/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/jumpsuit/aether,
		/obj/item/clothing/jumpsuit/hephaestus,
		/obj/item/clothing/jumpsuit/wardt,
		/obj/item/clothing/jumpsuit/pcrc,
		/obj/item/clothing/jumpsuit/focal
	)

/decl/loadout_option/uniform/corporate
	name = "corporate uniform selection"
	path = /obj/item/clothing/costume
	uid = "gear_under_corpuniform"

/decl/loadout_option/uniform/corporate/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/costume/mbill,
		/obj/item/clothing/costume/saare,
		/obj/item/clothing/costume/grayson,
		/obj/item/clothing/costume/morpheus,
		/obj/item/clothing/costume/skinner,
		/obj/item/clothing/costume/dais
	)

/decl/loadout_option/uniform/corp_overalls
	name = "corporate colours, coveralls"
	path = /obj/item/clothing/jumpsuit/work
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_corpcoveralls"

/decl/loadout_option/uniform/corp_flight
	name = "corporate colours, flight suit"
	path = /obj/item/clothing/jumpsuit/pilot
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_corpflight"

/decl/loadout_option/uniform/corp_exec_shirt
	name = "corporate colours, slacks"
	path = /obj/item/clothing/shirt/button/corp
	uid = "gear_under_exec_shirt"

/decl/loadout_option/uniform/corp_exec_jacket
	name = "corporate jacket selection"
	path = /obj/item/clothing/suit/jacket/corp
	slot = slot_wear_suit_str
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_corpexecjacket"

/decl/loadout_option/uniform/corp_exec_tie
	name = "corporate tie selection"
	path = /obj/item/clothing/neck/tie/corp
	slot = slot_w_uniform_str
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_corpexectie"

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
		/obj/item/clothing/suit/jacket/leather/nanotrasen,
		/obj/item/clothing/suit/jacket/brown/nanotrasen
	)

/decl/loadout_option/suit/science_poncho
	name = "poncho, science"
	path = /obj/item/clothing/suit/poncho/roles/science
	uid = "gear_suit_corpponcho_science"

/decl/loadout_option/suit/hoodie_nt
	name = "hoodie, NanoTrasen"
	path = /obj/item/clothing/suit/toggle/nt_hoodie
	uid = "gear_suit_corphoodie"

/decl/loadout_option/suit/wintercoat_dais
	name = "winter coat, DAIS"
	path = /obj/item/clothing/suit/jacket/winter/dais
	uid = "gear_suit_corpcoat_dais"

/decl/loadout_option/suit/leather/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= /obj/item/clothing/suit/mbill
