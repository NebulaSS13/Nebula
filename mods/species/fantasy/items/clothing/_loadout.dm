/decl/loadout_category/fantasy
	abstract_type = /decl/loadout_category/fantasy

/decl/loadout_category/fantasy/clothing
	name = "Clothing"

/decl/loadout_option/clothing/fantasy
	abstract_type = /decl/loadout_option/clothing/fantasy
	category = /decl/loadout_category/fantasy/clothing
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/fantasy/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/material])
	.[/datum/gear_tweak/material] |= list(
		"leather"  = /decl/material/solid/organic/leather,
		"feathers" = /decl/material/solid/organic/skin/feathers,
		"fur"      = /decl/material/solid/organic/skin/fur,
		"cloth"    = /decl/material/solid/organic/cloth
	)

/decl/loadout_option/clothing/fantasy/uniform
	name = "loincloth"
	path = /obj/item/clothing/pants/loincloth
	slot = slot_w_uniform_str

/decl/loadout_option/clothing/fantasy/uniform/jerkin
	name = "jerkin"
	path = /obj/item/clothing/accessory/jerkin

/decl/loadout_option/clothing/fantasy/uniform/trousers
	name = "trousers"
	path = /obj/item/clothing/pants/trousers

/decl/loadout_option/clothing/fantasy/suit
	name = "robes"
	path = /obj/item/clothing/suit/robe
	slot = slot_suit_str

/decl/loadout_option/clothing/fantasy/suit/poncho
	name = "robes"
	path = /obj/item/clothing/suit/poncho/colored

/decl/loadout_option/clothing/fantasy/mask
	name = "bandana"
	path = /obj/item/clothing/mask/bandana/colourable
	slot = slot_wear_mask_str

/decl/loadout_category/fantasy/utility
	name = "Utility"

/decl/loadout_option/utility/fantasy
	abstract_type = /decl/loadout_option/utility/fantasy
	category = /decl/loadout_category/fantasy/utility

/decl/loadout_option/utility/fantasy/striker
	name = "flint striker"
	path = /obj/item/rock/flint
