/decl/loadout_category/suit
	name = "Suits"

/decl/loadout_option/suit
	slot = slot_wear_suit_str
	category = /decl/loadout_category/suit
	abstract_type = /decl/loadout_option/suit

/decl/loadout_option/suit/poncho
	name = "poncho selection"
	path = /obj/item/clothing/suit/poncho/colored
	cost = 1
	loadout_flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/suit/suit_jacket
	name = "standard suit jackets"
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
	name = "suit jacket, colour select"
	path = /obj/item/clothing/suit/storage/toggle/suit
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/suit/hoodie
	name = "hoodie, colour select"
	path = /obj/item/clothing/suit/storage/toggle/hoodie
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/suit/coat
	name = "coat, colour select"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/coat
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/suit/leather
	name = "jacket selection"
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
	name = "winter coat"
	path = /obj/item/clothing/suit/storage/toggle/wintercoat

/decl/loadout_option/suit/track
	name = "track jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/track
	loadout_flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/suit/blueapron
	name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	cost = 1

/decl/loadout_option/suit/overalls
	name = "apron, overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1

/decl/loadout_option/suit/trenchcoat
	name = "trenchcoat selection"
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
	name = "letterman jacket, colour select"
	path = /obj/item/clothing/suit/letterman
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	cost = 1

/decl/loadout_option/suit/cloak
	name = "plain cloak"
	path = /obj/item/clothing/accessory/cloak
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	cost = 3
