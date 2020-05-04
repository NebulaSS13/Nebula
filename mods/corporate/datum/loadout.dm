/datum/gear/accessory/ntaward
	display_name = "corporate award selection"
	description = "A medal or ribbon awarded to corporate personnel for significant accomplishments."
	path = /obj/item/clothing/accessory/medal
	cost = 8

/datum/gear/accessory/ntaward/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"sciences medal" =        /obj/item/clothing/accessory/medal/nanotrasen/bronze,
		"distinguished service" = /obj/item/clothing/accessory/medal/nanotrasen/silver,
		"command medal" =         /obj/item/clothing/accessory/medal/nanotrasen/gold
	)

/datum/gear/accessory/armband_nt
	display_name = "corporate armband"
	path = /obj/item/clothing/accessory/armband/whitered

/datum/gear/suit/labcoat_corp
	display_name = "labcoat, corporate colors"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/science
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/corporate
	display_name = "corporate uniform selection"
	path = /obj/item/clothing/under

/datum/gear/uniform/corporate/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/under/rank/corp/polo/nanotrasen,
		/obj/item/clothing/under/rank/corp/polo/heph,
		/obj/item/clothing/under/rank/corp/polo/zeng,
		/obj/item/clothing/under/rank/corp/mbill,
		/obj/item/clothing/under/rank/corp/saare,
		/obj/item/clothing/under/rank/corp/aether,
		/obj/item/clothing/under/rank/corp/hephaestus,
		/obj/item/clothing/under/rank/guard/pcrc,
		/obj/item/clothing/under/rank/guard/pcrcsuit,
		/obj/item/clothing/under/rank/corp/wardt,
		/obj/item/clothing/under/rank/corp/grayson,
		/obj/item/clothing/under/rank/corp/focal,
		/obj/item/clothing/under/rank/corp/morpheus,
		/obj/item/clothing/under/rank/corp/skinner,
		/obj/item/clothing/under/rank/corp/dais
	)

/datum/gear/uniform/corp_exec
	display_name = "corporate colours, senior researcher"
	path = /obj/item/clothing/under/rank/corp/executive
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/corp_overalls
	display_name = "corporate colours, coveralls"
	path = /obj/item/clothing/under/rank/corp/work
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/corp_flight
	display_name = "corporate colours, flight suit"
	path = /obj/item/clothing/under/rank/corp/pilot
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/corp_exec_jacket
	display_name = "corporate colours, liason suit"
	path = /obj/item/clothing/under/suit_jacket/corp
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/nanotrasen_poncho
	display_name = "poncho, NanoTrasen"
	path = /obj/item/clothing/suit/poncho/roles/science/nanotrasen

/datum/gear/suit/corp_jacket
	display_name = "corporate jacket selection"
	path = /obj/item/clothing/suit

/datum/gear/suit/corp_jacket/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/storage/leather_jacket/nanotrasen,
		/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	)

/datum/gear/suit/science_poncho
	display_name = "poncho, science"
	path = /obj/item/clothing/suit/poncho/roles/science

/datum/gear/suit/hoodie_nt
	display_name = "hoodie, NanoTrasen"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/nt

/datum/gear/suit/wintercoat_dais
	display_name = "winter coat, DAIS"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/dais

/datum/gear/head/cap/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list("major bill's shipping cap" = /obj/item/clothing/head/soft/mbill)
