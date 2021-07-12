/decl/loadout_category/eyes
	name = "Eyewear"
	
/decl/loadout_option/eyes
	category = /decl/loadout_category/eyes
	slot = slot_glasses_str

/decl/loadout_option/eyes/eyepatch
	name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch

/decl/loadout_option/eyes/glasses
	name = "glasses selection"
	path = /obj/item/clothing/glasses

/decl/loadout_option/eyes/glasses/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"prescription glasses" = /obj/item/clothing/glasses/prescription,
		"green glasses" =        /obj/item/clothing/glasses/prescription/gglasses,
		"hipster glasses" =      /obj/item/clothing/glasses/prescription/hipster,
		"monocle" =              /obj/item/clothing/glasses/eyepatch/monocle
	)

/decl/loadout_option/eyes/shades
	name = "sunglasses selection"
	path = /obj/item/clothing/glasses/sunglasses
	cost = 3

/decl/loadout_option/eyes/shades/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"sunglasses, big" =         /obj/item/clothing/glasses/sunglasses/big,
		"sunglasses, presciption" = /obj/item/clothing/glasses/sunglasses/prescription
	)

/decl/loadout_option/eyes/blindfold
	name = "blindfold"
	path = /obj/item/clothing/glasses/blindfold
	flags = GEAR_HAS_COLOR_SELECTION
