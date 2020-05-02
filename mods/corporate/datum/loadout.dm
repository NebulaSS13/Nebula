/datum/gear/accessory/ntaward
	display_name = "corporate award selection"
	description = "A medal or ribbon awarded to corporate personnel for significant accomplishments."
	path = /obj/item/clothing/accessory/medal
	cost = 8

/datum/gear/accessory/ntaward/New()
	..()
	var/ntawards = list()
	ntawards["sciences medal"] = /obj/item/clothing/accessory/medal/nanotrasen/bronze
	ntawards["distinguished service"] = /obj/item/clothing/accessory/medal/nanotrasen/silver
	ntawards["command medal"] = /obj/item/clothing/accessory/medal/nanotrasen/gold
	gear_tweaks += new/datum/gear_tweak/path(ntawards)

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

/datum/gear/uniform/corporate/New()
	..()
	var/corps = list()
	corps += /obj/item/clothing/under/rank/corp/polo/nanotrasen
	corps += /obj/item/clothing/under/rank/corp/polo/heph
	corps += /obj/item/clothing/under/rank/corp/polo/zeng
	corps += /obj/item/clothing/under/rank/corp/mbill
	corps += /obj/item/clothing/under/rank/corp/saare
	corps += /obj/item/clothing/under/rank/corp/aether
	corps += /obj/item/clothing/under/rank/corp/hephaestus
	corps += /obj/item/clothing/under/rank/guard/pcrc
	corps += /obj/item/clothing/under/rank/guard/pcrcsuit
	corps += /obj/item/clothing/under/rank/corp/wardt
	corps += /obj/item/clothing/under/rank/corp/grayson
	corps += /obj/item/clothing/under/rank/corp/focal
	corps += /obj/item/clothing/under/rank/corp/morpheus
	corps += /obj/item/clothing/under/rank/corp/skinner
	corps += /obj/item/clothing/under/rank/corp/dais
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(corps)

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

/datum/gear/suit/corp_jacket/New()
	..()
	var/jackets = list(
		/obj/item/clothing/suit/storage/leather_jacket/nanotrasen,
		/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	)
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(jackets)

/datum/gear/suit/science_poncho
	display_name = "poncho, science"
	path = /obj/item/clothing/suit/poncho/roles/science

/datum/gear/suit/hoodie_nt
	display_name = "hoodie, NanoTrasen"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/nt

/datum/gear/suit/wintercoat_dais
	display_name = "winter coat, DAIS"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/dais
