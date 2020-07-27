/datum/gear/gloves
	cost = 2
	slot = slot_gloves_str
	sort_category = "Gloves and Handwear"
	category = /datum/gear/gloves

/datum/gear/gloves/colored
	display_name = "gloves, colored"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/gloves/color

/datum/gear/gloves/latex
	display_name = "gloves, latex"
	path = /obj/item/clothing/gloves/latex
	cost = 3

/datum/gear/gloves/nitrile
	display_name = "gloves, nitrile"
	path = /obj/item/clothing/gloves/latex/nitrile
	cost = 3

/datum/gear/gloves/rainbow
	display_name = "gloves, rainbow"
	path = /obj/item/clothing/gloves/rainbow

/datum/gear/gloves/evening
	display_name = "gloves, evening, colour select"
	path = /obj/item/clothing/gloves/color/evening
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/ring
	display_name = "ring"
	path = /obj/item/clothing/ring
	cost = 2

/datum/gear/ring/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"CTI ring" =                /obj/item/clothing/ring/cti,
		"Mariner University ring" = /obj/item/clothing/ring/mariner,
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

/datum/gear/gloves/work
	display_name = "gloves, work"
	path = /obj/item/clothing/gloves/thick
	cost = 3
