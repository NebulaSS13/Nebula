/decl/loadout_category/suit
	name = "Suits"
	
/decl/loadout_option/suit
	slot = slot_wear_suit_str
	category = /decl/loadout_category/suit

/decl/loadout_option/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/suit/poncho/colored
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/suit/security_poncho
	display_name = "poncho, security"
	path = /obj/item/clothing/suit/poncho/roles/security

/decl/loadout_option/suit/medical_poncho
	display_name = "poncho, medical"
	path = /obj/item/clothing/suit/poncho/roles/medical

/decl/loadout_option/suit/engineering_poncho
	display_name = "poncho, engineering"
	path = /obj/item/clothing/suit/poncho/roles/engineering

/decl/loadout_option/suit/cargo_poncho
	display_name = "poncho, supply"
	path = /obj/item/clothing/suit/poncho/roles/cargo

/decl/loadout_option/suit/suit_jacket
	display_name = "standard suit jackets"
	path = /obj/item/clothing/suit/storage/toggle/suit

/decl/loadout_option/suit/suit_jacket/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/storage/toggle/suit/black,
		/obj/item/clothing/suit/storage/toggle/suit/blue,
		/obj/item/clothing/suit/storage/toggle/suit/purple
	)

/decl/loadout_option/suit/custom_suit_jacket
	display_name = "suit jacket, colour select"
	path = /obj/item/clothing/suit/storage/toggle/suit
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/suit/hazard
	display_name = "hazard vests"
	path = /obj/item/clothing/suit/storage/hazardvest
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/suit/hoodie
	display_name = "hoodie, colour select"
	path = /obj/item/clothing/suit/storage/hooded/hoodie
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/suit/labcoat
	display_name = "labcoat, colour select"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/suit/labcoat_blue
	display_name = "blue trimmed labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue

/decl/loadout_option/suit/coat
	display_name = "coat, colour select"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/coat
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/suit/leather
	display_name = "jacket selection"
	path = /obj/item/clothing/suit

/decl/loadout_option/suit/leather/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/brown_jacket
	)

/decl/loadout_option/suit/wintercoat
	display_name = "winter coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/decl/loadout_option/suit/track
	display_name = "track jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/track
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/suit/blueapron
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	cost = 1

/decl/loadout_option/suit/overalls
	display_name = "apron, overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1

/decl/loadout_option/suit/medcoat
	display_name = "medical suit selection"
	path = /obj/item/clothing/suit

/decl/loadout_option/suit/medcoat/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/storage/toggle/fr_jacket, 
		/obj/item/clothing/suit/storage/toggle/fr_jacket/ems, 
		/obj/item/clothing/suit/surgicalapron
	)

/decl/loadout_option/suit/trenchcoat
	display_name = "trenchcoat selection"
	path = /obj/item/clothing/suit
	cost = 3

/decl/loadout_option/suit/trenchcoat/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/storage/det_trench,
		/obj/item/clothing/suit/storage/det_trench/grey,
		/obj/item/clothing/suit/leathercoat
	)

/decl/loadout_option/suit/letterman_custom
	display_name = "letterman jacket, colour select"
	path = /obj/item/clothing/suit/letterman
	flags = GEAR_HAS_COLOR_SELECTION
	cost = 1

/decl/loadout_option/suit/cloak
	display_name = "plain cloak"
	path = /obj/item/clothing/accessory/cloak
	flags = GEAR_HAS_COLOR_SELECTION
	cost = 3
