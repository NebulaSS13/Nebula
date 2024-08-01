/decl/loadout_category/hands
	name = "Handwear"

/decl/loadout_option/gloves
	cost = 2
	slot = slot_gloves_str
	category = /decl/loadout_category/hands
	abstract_type = /decl/loadout_option/gloves

/decl/loadout_option/gloves/colored
	name = "gloves, colored"
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/gloves
	uid = "gear_gloves_color"

/decl/loadout_option/gloves/evening
	name = "gloves, evening, color select"
	path = /obj/item/clothing/gloves/evening
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_gloves_evening"

/decl/loadout_option/ring
	name = "ring"
	path = /obj/item/clothing/gloves/ring
	cost = 2
	uid = "gear_gloves_ring"

/decl/loadout_option/ring/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"engagement ring" =         /obj/item/clothing/gloves/ring/engagement,
		"signet ring" =             /obj/item/clothing/gloves/ring/seal/signet,
		"masonic ring" =            /obj/item/clothing/gloves/ring/seal/mason,
		"ring, steel" =             /obj/item/clothing/gloves/ring/material/steel,
		"ring, bronze" =            /obj/item/clothing/gloves/ring/material/bronze,
		"ring, silver" =            /obj/item/clothing/gloves/ring/material/silver,
		"ring, gold" =              /obj/item/clothing/gloves/ring/material/gold,
		"ring, platinum" =          /obj/item/clothing/gloves/ring/material/platinum,
		"ring, glass" =             /obj/item/clothing/gloves/ring/material/glass,
		"ring, wood" =              /obj/item/clothing/gloves/ring/material/wood,
		"ring, plastic" =           /obj/item/clothing/gloves/ring/material/plastic
	)
