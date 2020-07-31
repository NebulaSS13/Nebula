/datum/gear/suit
	slot = slot_wear_suit_str
	sort_category = "Suits and Overwear"
	category = /datum/gear/suit

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/suit/poncho/colored
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/security_poncho
	display_name = "poncho, security"
	path = /obj/item/clothing/suit/poncho/roles/security

/datum/gear/suit/medical_poncho
	display_name = "poncho, medical"
	path = /obj/item/clothing/suit/poncho/roles/medical

/datum/gear/suit/engineering_poncho
	display_name = "poncho, engineering"
	path = /obj/item/clothing/suit/poncho/roles/engineering

/datum/gear/suit/cargo_poncho
	display_name = "poncho, supply"
	path = /obj/item/clothing/suit/poncho/roles/cargo

/datum/gear/suit/suit_jacket
	display_name = "standard suit jackets"
	path = /obj/item/clothing/suit/storage/toggle/suit

/datum/gear/suit/suit_jacket/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/storage/toggle/suit/black,
		/obj/item/clothing/suit/storage/toggle/suit/blue,
		/obj/item/clothing/suit/storage/toggle/suit/purple
	)

/datum/gear/suit/custom_suit_jacket
	display_name = "suit jacket, colour select"
	path = /obj/item/clothing/suit/storage/toggle/suit
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/hazard
	display_name = "hazard vests"
	path = /obj/item/clothing/suit/storage/hazardvest
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/hoodie
	display_name = "hoodie, colour select"
	path = /obj/item/clothing/suit/storage/hooded/hoodie
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/labcoat
	display_name = "labcoat, colour select"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/labcoat_blue
	display_name = "blue trimmed labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue

/datum/gear/suit/coat
	display_name = "coat, colour select"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/coat
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/leather
	display_name = "jacket selection"
	path = /obj/item/clothing/suit

/datum/gear/suit/leather/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/brown_jacket
	)

/datum/gear/suit/wintercoat
	display_name = "winter coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/gear/suit/track
	display_name = "track jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/track
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/blueapron
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	cost = 1

/datum/gear/suit/overalls
	display_name = "apron, overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1

/datum/gear/suit/medcoat
	display_name = "medical suit selection"
	path = /obj/item/clothing/suit

/datum/gear/suit/medcoat/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/storage/toggle/fr_jacket, 
		/obj/item/clothing/suit/storage/toggle/fr_jacket/ems, 
		/obj/item/clothing/suit/surgicalapron
	)

/datum/gear/suit/trenchcoat
	display_name = "trenchcoat selection"
	path = /obj/item/clothing/suit
	cost = 3

/datum/gear/suit/trenchcoat/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/storage/det_trench,
		/obj/item/clothing/suit/storage/det_trench/grey,
		/obj/item/clothing/suit/leathercoat
	)

/datum/gear/suit/letterman_custom
	display_name = "letterman jacket, colour select"
	path = /obj/item/clothing/suit/letterman
	flags = GEAR_HAS_COLOR_SELECTION
	cost = 1