/decl/loadout_category/hands
	name = "Handwear"
	
/decl/loadout_option/gloves
	cost = 2
	slot = slot_gloves_str
	category = /decl/loadout_category/hands

/decl/loadout_option/gloves/colored
	name = "gloves, colored"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/gloves/color

/decl/loadout_option/gloves/evening
	name = "gloves, evening, colour select"
	path = /obj/item/clothing/gloves/color/evening
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/ring
	name = "ring"
	path = /obj/item/clothing/ring
	cost = 2

/decl/loadout_option/ring/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"engagement ring" =         /obj/item/clothing/ring/engagement,
		"signet ring" =             /obj/item/clothing/ring/seal/signet,
		"masonic ring" =            /obj/item/clothing/ring/seal/mason,
		"ring, steel" =             /obj/item/clothing/ring/material/steel,
		"ring, bronze" =            /obj/item/clothing/ring/material/bronze,
		"ring, silver" =            /obj/item/clothing/ring/material/silver,
		"ring, gold" =              /obj/item/clothing/ring/material/gold,
		"ring, platinum" =          /obj/item/clothing/ring/material/platinum,
		"ring, glass" =             /obj/item/clothing/ring/material/glass,
		"ring, wood" =              /obj/item/clothing/ring/material/wood,
		"ring, plastic" =           /obj/item/clothing/ring/material/plastic
	)
