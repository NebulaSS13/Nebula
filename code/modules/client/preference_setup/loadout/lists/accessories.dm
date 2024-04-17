/decl/loadout_category/accessories
	name = "Accessories"

/decl/loadout_option/accessory
	category = /decl/loadout_category/accessories
	abstract_type = /decl/loadout_option/accessory
	slot = slot_tie_str

/decl/loadout_option/accessory/tie
	name = "tie selection"
	path = /obj/item/clothing/tie

/decl/loadout_option/accessory/tie/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"blue tie" =        /obj/item/clothing/tie/blue,
		"red tie" =         /obj/item/clothing/tie/red,
		"blue tie, clip" =  /obj/item/clothing/tie/blue_clip,
		"black tie" =       /obj/item/clothing/tie/black,
		"long red tie" =    /obj/item/clothing/tie/long/red,
		"long yellow tie" = /obj/item/clothing/tie/long/yellow,
		"navy tie" =        /obj/item/clothing/tie/navy,
		"horrible tie" =    /obj/item/clothing/tie/horrible,
		"brown tie" =       /obj/item/clothing/tie/brown
	)

/decl/loadout_option/accessory/tie_color
	name = "colored tie"
	path = /obj/item/clothing/tie
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/accessory/tie_color/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"tie" =         /obj/item/clothing/tie,
		"striped tie" = /obj/item/clothing/tie/long
	)

/decl/loadout_option/accessory/locket
	name = "locket"
	path = /obj/item/clothing/accessory/locket

/decl/loadout_option/accessory/necklace
	name = "necklace, colour select"
	path = /obj/item/clothing/accessory/necklace
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/accessory/bow
	name = "bowtie, horrible"
	path = /obj/item/clothing/tie/bow/ugly

/decl/loadout_option/accessory/bow/color
	name = "bowtie, colour select"
	path = /obj/item/clothing/tie/bow/color
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/accessory/bracelet
	name = "bracelet, color select"
	path = /obj/item/clothing/accessory/bracelet
	cost = 1
	loadout_flags = GEAR_HAS_COLOR_SELECTION
